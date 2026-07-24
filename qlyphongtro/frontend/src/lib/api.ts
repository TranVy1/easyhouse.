/**
 * Shared API service layer for EasyHouse frontend.
 * Automatically handles JSON headers and response unwrapping.
 * Authorization header is injected by Next.js middleware (middleware.ts).
 */

export class ApiError extends Error {
  constructor(
    message: string,
    public readonly status?: number,
  ) {
    super(message);
    this.name = 'ApiError';
  }
}

async function request<T>(path: string, options?: RequestInit): Promise<T> {
  const res = await fetch(path, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...options?.headers,
    },
  });

  let text = '';
  let json: { success?: boolean; data?: T; message?: string; error?: string };
  try {
    text = await res.text();
    json = text ? JSON.parse(text) : {};
  } catch {
    throw new ApiError(`HTTP ${res.status}: Invalid JSON response - ${text.substring(0, 50)}`, res.status);
  }

  if (!res.ok || json.success === false) {
    throw new ApiError(json.message || json.error || `HTTP ${res.status}`, res.status);
  }

  return json.data as T;
}

export const api = {
  get: <T>(path: string, opts?: RequestInit) =>
    request<T>(path, { method: 'GET', ...opts }),

  post: <T>(path: string, body?: unknown, opts?: RequestInit) =>
    request<T>(path, { method: 'POST', body: JSON.stringify(body), ...opts }),

  put: <T>(path: string, body?: unknown, opts?: RequestInit) =>
    request<T>(path, { method: 'PUT', body: JSON.stringify(body), ...opts }),

  delete: <T>(path: string, opts?: RequestInit) =>
    request<T>(path, { method: 'DELETE', ...opts }),
};

/** Extract paginated items from backend PaginatedResponse */
export function extractItems<T>(data: unknown): T[] {
  if (!data) return [];
  const d = data as Record<string, unknown>;
  // Support: { items: [] }, { data: [] }, { content: [] }, plain array
  if (Array.isArray(d)) return d as T[];
  if (Array.isArray(d.items)) return d.items as T[];
  if (Array.isArray(d.data)) return d.data as T[];
  if (Array.isArray(d.content)) return d.content as T[];
  return [];
}
