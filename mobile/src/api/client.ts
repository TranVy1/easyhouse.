import Constants from "expo-constants";
import type { ApiResponse, Session } from "@/types";

/**
 * Địa chỉ backend, theo thứ tự ưu tiên:
 *   1. EXPO_PUBLIC_API_BASE_URL — đặt trong .env, không phải sửa app.json
 *   2. extra.apiBaseUrl trong app.json
 *   3. mặc định cho máy ảo Android
 *
 * LƯU Ý VỀ CỔNG: docker-compose ánh xạ backend ra cổng **8082** của host
 * (8082:8080), không phải 8080. Trên máy này cổng 8080 còn đang bị một dự án
 * khác chiếm, nên trỏ nhầm sẽ nói chuyện với sai server mà không báo lỗi gì rõ ràng.
 *
 * Chọn giá trị theo cách chạy:
 *   máy ảo Android + docker : http://10.0.2.2:8082
 *   máy thật qua USB        : chạy `adb reverse tcp:8082 tcp:8082` rồi dùng http://localhost:8082
 *   máy thật cùng mạng LAN  : http://<IP-máy-tính>:8082
 *   backend chạy trực tiếp  : ...:8080 (mvn spring-boot:run không qua docker)
 */
const BASE_URL: string =
  (process.env.EXPO_PUBLIC_API_BASE_URL as string | undefined) ??
  (Constants.expoConfig?.extra?.apiBaseUrl as string) ??
  "http://10.0.2.2:8082";

/** Abort a request if the server does not respond within this window. */
const REQUEST_TIMEOUT_MS = 15000;

/**
 * The client keeps the live session in memory. AuthContext wires it up with
 * getters/setters so the client can transparently refresh tokens on 401 and
 * force a logout when the refresh token is dead.
 */
let currentSession: Session | null = null;
let onSessionChange: ((s: Session | null) => void) | null = null;

/**
 * A single in-flight refresh shared by every request that hits a 401 at the
 * same time. Without this, concurrent 401s each POST /refresh, and because the
 * backend rotates (invalidates) the refresh token, all but the first fail and
 * the user gets logged out unexpectedly.
 */
let refreshPromise: Promise<Session | null> | null = null;

export function configureClient(opts: {
  session: Session | null;
  onSessionChange: (s: Session | null) => void;
}): void {
  currentSession = opts.session;
  onSessionChange = opts.onSessionChange;
}

export function setClientSession(session: Session | null): void {
  currentSession = session;
}

export class ApiError extends Error {
  status: number;
  constructor(message: string, status: number) {
    super(message);
    this.status = status;
  }
}

interface RequestOptions {
  method?: string;
  body?: unknown;
  auth?: boolean; // attach bearer token (default true)
  query?: Record<string, string | number | undefined>;
}

function buildUrl(path: string, query?: RequestOptions["query"]): string {
  const base = path.startsWith("http") ? path : `${BASE_URL}${path}`;
  if (!query) return base;
  const parts: string[] = [];
  for (const [k, v] of Object.entries(query)) {
    if (v !== undefined && v !== null && v !== "") {
      parts.push(`${encodeURIComponent(k)}=${encodeURIComponent(String(v))}`);
    }
  }
  if (parts.length === 0) return base;
  return `${base}${base.includes("?") ? "&" : "?"}${parts.join("&")}`;
}

async function rawFetch<T>(
  path: string,
  opts: RequestOptions,
  token?: string
): Promise<ApiResponse<T>> {
  const headers: Record<string, string> = { "Content-Type": "application/json" };
  if (opts.auth !== false && token) headers.Authorization = `Bearer ${token}`;

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), REQUEST_TIMEOUT_MS);

  let res: Response;
  try {
    res = await fetch(buildUrl(path, opts.query), {
      method: opts.method ?? "GET",
      headers,
      body: opts.body !== undefined ? JSON.stringify(opts.body) : undefined,
      signal: controller.signal,
    });
  } catch (e) {
    // Network failure or timeout (abort).
    const aborted = e instanceof Error && e.name === "AbortError";
    throw new ApiError(
      aborted ? "Máy chủ phản hồi quá lâu, vui lòng thử lại." : "Không kết nối được máy chủ.",
      0
    );
  } finally {
    clearTimeout(timer);
  }

  let json: ApiResponse<T> | null = null;
  try {
    json = (await res.json()) as ApiResponse<T>;
  } catch {
    // non-JSON response
  }

  if (res.status === 401) {
    throw new ApiError(json?.message ?? "Phiên đăng nhập đã hết hạn.", 401);
  }
  if (!res.ok || (json && json.success === false)) {
    throw new ApiError(json?.message ?? `Lỗi máy chủ (${res.status})`, res.status);
  }
  if (!json) throw new ApiError("Phản hồi không hợp lệ từ máy chủ.", res.status);
  return json;
}

/** Perform the actual refresh network call and update session state. */
async function doRefresh(refreshToken: string): Promise<Session | null> {
  try {
    const res = await rawFetch<{ token: string; refreshToken: string }>(
      "/api/auth/refresh",
      { method: "POST", body: { refreshToken }, auth: false }
    );
    const base = currentSession;
    if (!base) return null;
    const next: Session = {
      ...base,
      token: res.data.token,
      refreshToken: res.data.refreshToken ?? base.refreshToken,
    };
    currentSession = next;
    onSessionChange?.(next);
    return next;
  } catch {
    return null;
  }
}

/** Attempt to mint a fresh access token, de-duplicating concurrent callers. */
async function tryRefresh(): Promise<Session | null> {
  const rt = currentSession?.refreshToken;
  if (!rt) return null;
  if (!refreshPromise) {
    refreshPromise = doRefresh(rt).finally(() => {
      refreshPromise = null;
    });
  }
  return refreshPromise;
}

/** Core request: performs the call, refreshing once on 401. */
export async function request<T>(path: string, opts: RequestOptions = {}): Promise<T> {
  try {
    const res = await rawFetch<T>(path, opts, currentSession?.token);
    return res.data;
  } catch (err) {
    if (err instanceof ApiError && err.status === 401 && opts.auth !== false) {
      const refreshed = await tryRefresh();
      if (refreshed) {
        const res = await rawFetch<T>(path, opts, refreshed.token);
        return res.data;
      }
      // Refresh failed -> force logout.
      currentSession = null;
      onSessionChange?.(null);
    }
    throw err;
  }
}

export const api = {
  get: <T>(path: string, query?: RequestOptions["query"]) =>
    request<T>(path, { method: "GET", query }),
  post: <T>(path: string, body?: unknown, auth = true) =>
    request<T>(path, { method: "POST", body, auth }),
  put: <T>(path: string, body?: unknown) => request<T>(path, { method: "PUT", body }),
  patch: <T>(path: string, body?: unknown) => request<T>(path, { method: "PATCH", body }),
  del: <T>(path: string) => request<T>(path, { method: "DELETE" }),
};

export { BASE_URL };
