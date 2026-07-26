import { api } from "./client";
import { docNguoiDungIdTuToken } from "@/lib/jwt";
import type { AuthResponse, KhachThueLoginResponse, Session } from "@/types";

/** Manager/staff login by email. */
export async function loginManager(email: string, matKhau: string): Promise<Session> {
  const data = await api.post<AuthResponse>(
    "/api/auth/login",
    { email, matKhau },
    false
  );
  return {
    token: data.token,
    refreshToken: data.refreshToken,
    role: data.vaiTro,
    hoTen: data.hoTen,
    soDienThoai: data.soDienThoai,
    email: data.email,
    avatar: data.anhDaiDien,
    // Lấy từ claim `sub` để userId LUÔN là nguoi_dung.id ở cả hai luồng đăng nhập.
    // Xem chú thích ở loginTenant để biết vì sao điều này quan trọng.
    userId: docNguoiDungIdTuToken(data.token) ?? data.id,
  };
}

/** Tenant login by phone number. */
export async function loginTenant(soDienThoai: string, matKhau: string): Promise<Session> {
  const data = await api.post<KhachThueLoginResponse>(
    "/api/auth/khach-thue/login",
    { soDienThoai, matKhau },
    false
  );
  return {
    token: data.token,
    refreshToken: data.refreshToken,
    role: "TENANT",
    hoTen: data.khachThue?.hoTen ?? "Khách thuê",
    soDienThoai: data.khachThue?.soDienThoai ?? soDienThoai,
    email: data.khachThue?.email,
    // KHÔNG dùng data.khachThue._id: đó là **khach_thue.id**, còn tin nhắn và mọi
    // tham chiếu người dùng khác đều theo **nguoi_dung.id**. Lấy nhầm thì tin của
    // chính mình sẽ hiển thị như tin của người khác.
    userId: docNguoiDungIdTuToken(data.token),
  };
}

export async function logout(): Promise<void> {
  try {
    await api.post<void>("/api/auth/logout");
  } catch {
    // best-effort; local session is cleared regardless
  }
}

export function isManagerRole(role: string): boolean {
  return ["ADMIN", "LANDLORD", "STAFF"].includes(role);
}
