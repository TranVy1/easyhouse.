// API contracts mirrored from the Spring Boot backend.
// Field names intentionally match backend JSON (Vietnamese domain names preserved).

/** Generic backend envelope: { success, message, data } */
export interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

/** Paginated list envelope carried inside ApiResponse.data */
export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

export type Role = "ADMIN" | "LANDLORD" | "STAFF" | "TENANT" | string;

/** POST /api/auth/login -> data */
export interface AuthResponse {
  id: string;
  email: string;
  hoTen: string;
  vaiTro: Role;
  soDienThoai?: string;
  anhDaiDien?: string;
  token: string;
  refreshToken: string;
  emailVerified: boolean;
  requirePasswordChange: boolean;
}

export interface KhachThueResponse {
  _id: string;
  hoTen: string;
  soDienThoai?: string;
  email?: string;
  [key: string]: unknown;
}

/** POST /api/auth/khach-thue/login -> data */
export interface KhachThueLoginResponse {
  token: string;
  refreshToken: string;
  khachThue: KhachThueResponse;
  requirePasswordChange: boolean;
}

/** The session we persist locally, unified across both login flows. */
export interface Session {
  token: string;
  refreshToken: string;
  role: Role;
  hoTen: string;
  soDienThoai?: string;
  email?: string;
  avatar?: string;
  userId?: string;
}

/** GET /api/dashboard/stats -> data */
export interface DashboardStats {
  tongSoPhong: number;
  phongTrong: number;
  phongDangThue: number;
  phongBaoTri: number;
  doanhThuThang: number;
  doanhThuNam: number;
  hoaDonSapDenHan: number;
  suCoCanXuLy: number;
  hopDongSapHetHan: number;
  tongKhachDangThue: number;
  tienDaThu: number;
  tienChuaThu: number;
}

/** GET /api/auth/khach-thue/me -> data */
export interface KhachThueDashboard {
  khachThue?: { hoTen: string; trangThai?: string };
  hopDongHienTai?: {
    maHopDong?: string;
    ngayBatDau?: string;
    ngayKetThuc?: string;
    tienCoc?: number;
    phong?: {
      maPhong?: string;
      giaThue?: number;
      toaNha?: { tenToaNha?: string; diaChi?: { duong?: string; phuong?: string } };
    };
  };
  soHoaDonChuaThanhToan: number;
  soSuCoDangMo: number;
  soThongBaoMoi: number;
  hoaDonGanNhat?: {
    maHoaDon?: string;
    thang: number;
    nam: number;
    tongTien?: number;
    trangThai?: string;
  };
  lienHe?: { hoTen?: string; soDienThoai?: string; email?: string };
}

export interface HoaDon {
  _id: string;
  maHoaDon?: string;
  phong?: unknown;
  khachThue?: unknown;
  thang?: number;
  nam?: number;
  kyThang?: number;
  kyNam?: number;
  tongTien?: number;
  daTra?: number;
  conLai?: number;
  trangThai?: string;
  hanThanhToan?: string;
  hanTra?: string;
  [key: string]: unknown;
}

export interface SuCo {
  _id: string;
  tieuDe?: string;
  moTa?: string;
  loaiSuCo?: string;
  mucDoUuTien?: string;
  trangThai?: string;
  phong?: { _id: string; maPhong?: string };
  nguoiBaoCao?: { _id: string; hoTen?: string; soDienThoai?: string };
  ngayBaoCao?: string;
  [key: string]: unknown;
}

export interface ThongBao {
  _id: string;
  tieuDe?: string;
  noiDung?: string;
  loai?: string;
  kenh?: string;
  guiTatCa?: boolean;
  daDoc?: string[];
  ngayTao?: string;
  [key: string]: unknown;
}

export interface Phong {
  _id: string;
  maPhong?: string;
  toaNha?: { _id?: string; tenToaNha?: string };
  giaThue?: number;
  tienCoc?: number;
  trangThai?: string;
  dienTich?: number;
  tang?: number;
  soNguoiToiDa?: number;
  [key: string]: unknown;
}

// ─── Module tin nhắn (chat realtime) ────────────────────────────────────────

export type LoaiCuocTroChuyen = 'DIRECT' | 'GROUP' | 'BUILDING' | 'FLOOR' | 'SUPPORT';
export type LoaiTinNhan = 'TEXT' | 'IMAGE' | 'FILE' | 'SYSTEM';

export interface ThanhVienChat {
  _id: string;              // nguoiDungId
  hoTen?: string;
  anhDaiDien?: string;
  vaiTro?: string;
  docDenSeq?: number;
}

export interface CuocTroChuyen {
  _id: string;
  loai: LoaiCuocTroChuyen;
  ten?: string;
  anh?: string;
  nhaTroId?: string;
  trangThai?: string;
  tinNhanCuoiLuc?: string;
  xemTruoc?: string;
  soTinChuaDoc?: number;
  ghim?: boolean;
  tatThongBao?: boolean;
  docDenSeq?: number;
  thanhVien?: ThanhVienChat[];
}

export interface TinNhan {
  _id: string;
  soThuTu: number;
  cuocTroChuyenId: string;
  nguoiGuiId?: string;
  tenNguoiGui?: string;
  anhNguoiGui?: string;
  loai: LoaiTinNhan;
  noiDung?: string;
  fileUrl?: string;
  traLoiChoId?: string;
  maClient?: string;
  daThuHoi?: boolean;
  ngayTao?: string;
  dangGui?: boolean;        // chỉ tồn tại ở client
  loiGui?: boolean;
}

export interface NguoiLienHe {
  _id: string;
  hoTen?: string;
  soDienThoai?: string;
  anhDaiDien?: string;
  vaiTro?: 'LANDLORD' | 'STAFF' | 'TENANT';
}

export interface SuKienTrangThaiChat {
  loai: 'DANG_GO' | 'DUNG_GO' | 'DA_DOC';
  cuocTroChuyenId: string;
  nguoiDungId: string;
  denSeq?: number;
}

/** Kết quả tải tệp đính kèm cho chat — client gửi `_id` kèm trong tin nhắn. */
export interface TepDinhKem {
  _id: string;
  url: string;
  loaiTinNhan: 'IMAGE' | 'FILE';
  tenTep?: string;
  kichThuocBytes?: number;
}
