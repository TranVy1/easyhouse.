// Frontend domain contract for EasyHouse.
//
// The database uses PostgreSQL/Supabase snake_case columns. The UI keeps
// Vietnamese camelCase names and a few legacy aliases so the backend can evolve
// without forcing every screen to change at once.

export type ID = string;
export type DateLike = string | Date;
export type EntityRef<T> = T & { id: ID; _id: ID };
export type Ref<T> = ID | EntityRef<T>;
export type ToaNhaRef = ID | { id?: ID; _id: ID; tenToaNha: string; ten?: string };
export type PhongRef = ID | { id?: ID; _id?: ID; maPhong: string; ten?: string; toaNha?: { _id: ID; tenToaNha: string } };
export type KhachThueRef = ID | KhachThue;

export type VaiTroHeThong = 'ADMIN' | 'LANDLORD' | 'STAFF' | 'TENANT';
export type VaiTroUi = 'admin' | 'chuNha' | 'nhanVien' | 'khachThue';

export type TrangThaiNguoiDung = 'ACTIVE' | 'INACTIVE' | 'BANNED';
export type TrangThaiNguoiDungUi = 'hoatDong' | 'khoa' | 'chuaKichHoat';

export type TrangThaiPhongDb = 'AVAILABLE' | 'RESERVED' | 'RENTED' | 'MAINTENANCE' | 'INACTIVE';
export type TrangThaiPhongUi = 'trong' | 'daDat' | 'dangThue' | 'baoTri' | 'ngungHoatDong';
export type TrangThaiPhong = TrangThaiPhongDb | TrangThaiPhongUi;

export type TrangThaiHopDongDb = 'DRAFT' | 'PENDING' | 'ACTIVE' | 'EXPIRED' | 'TERMINATED' | 'CANCELLED';
export type TrangThaiHopDongUi = 'nhap' | 'choKichHoat' | 'hoatDong' | 'hetHan' | 'daKetThuc' | 'daHuy';
export type TrangThaiHopDong = TrangThaiHopDongDb | TrangThaiHopDongUi;

export type TrangThaiCocHopDong = 'NOT_PAID' | 'KEPT' | 'REFUNDED' | 'DEDUCTED' | 'FORFEITED';

export type TrangThaiHoaDonDb = 'DRAFT' | 'UNPAID' | 'PARTIAL' | 'PAID' | 'OVERPAID' | 'OVERDUE' | 'CANCELLED';
export type TrangThaiHoaDonUi =
  | 'nhap'
  | 'chuaThanhToan'
  | 'daThanhToanMotPhan'
  | 'daThanhToan'
  | 'thanhToanDu'
  | 'quaHan'
  | 'daHuy';
export type TrangThaiHoaDon = TrangThaiHoaDonDb | TrangThaiHoaDonUi;

export type LoaiMucHoaDon =
  | 'ROOM'
  | 'ELECTRICITY'
  | 'WATER'
  | 'SERVICE'
  | 'INTERNET'
  | 'GARBAGE'
  | 'PARKING'
  | 'MAINTENANCE'
  | 'DEBT'
  | 'DISCOUNT'
  | 'OTHER';

export type TrangThaiThanhToan = 'PENDING' | 'SUCCESS' | 'FAILED' | 'CANCELLED' | 'REFUNDED';
export type PhuongThucThanhToanDb = 'CASH' | 'BANK_TRANSFER' | 'VIETQR' | 'MOMO' | 'ZALOPAY' | 'OTHER';
export type PhuongThucThanhToanUi = 'tienMat' | 'chuyenKhoan' | 'vietQr' | 'viDienTu' | 'khac';
export type PhuongThucThanhToan = PhuongThucThanhToanDb | PhuongThucThanhToanUi;

export type LoaiChiSo = 'ELECTRICITY' | 'WATER';
export type TrangThaiChiSo = 'DRAFT' | 'CONFIRMED' | 'BILLED' | 'CANCELLED';
export type LoaiTinhPhi = 'FIXED' | 'PER_PERSON' | 'PER_ROOM' | 'PER_UNIT' | 'PERCENT';

export type LoaiSuCo = 'dien_nuoc' | 'noi_that' | 've_sinh' | 'an_ninh' | 'internet' | 'khac';
export type UuTien = 'thap' | 'trung_binh' | 'cao' | 'khan_cap';
export type TrangThaiSuCo = 'PENDING' | 'IN_PROGRESS' | 'RESOLVED' | 'CANCELLED';

export type LoaiThongBaoDb = 'SYSTEM' | 'INVOICE' | 'PAYMENT' | 'CONTRACT' | 'INCIDENT' | 'APPOINTMENT' | 'DEBT';
export type LoaiThongBaoUi = 'chung' | 'hoaDon' | 'thanhToan' | 'hopDong' | 'suCo' | 'lichHen' | 'congNo' | 'khac';
export type LoaiThongBao = LoaiThongBaoDb | LoaiThongBaoUi;
export type KenhThongBao = 'IN_APP' | 'EMAIL' | 'SMS' | 'ZALO' | 'TELEGRAM' | 'PUSH';

export interface DiaChi {
  soNha: string;
  duong: string;
  phuong: string;
  quan: string;
  thanhPho: string;
}

export interface AnhCCCD {
  matTruoc: string;
  matSau: string;
}

export interface ThongTinChuyenKhoan {
  nganHang: string;
  soGiaoDich: string;
}

export interface PhiDichVu {
  id?: ID;
  dichVuId?: ID;
  ten: string;
  gia: number;
  soLuong?: number;
  loaiTinhPhi?: LoaiTinhPhi;
}

export interface NguoiDung {
  id?: ID;
  _id?: ID;
  email: string;
  hoTen: string;
  ten?: string;
  matKhau?: string;
  soDienThoai?: string;
  vaiTro: VaiTroHeThong | VaiTroUi;
  anhDaiDien?: string;
  ngaySinh: DateLike;
  gioiTinh?: string;
  diaChi?: string;
  queQuan?: string;
  soCccd?: string;
  trangThai: TrangThaiNguoiDung | TrangThaiNguoiDungUi;
  ngayTao: DateLike;
  ngayCapNhat: DateLike;
  taoLuc?: DateLike;
  capNhatLuc?: DateLike;
}

export interface ToaNha {
  id?: ID;
  _id?: ID;
  ten: string;
  tenToaNha: string;
  chuTroId?: ID;
  chuSoHuu?: ID;
  diaChi: DiaChi;
  diaChiDayDu?: string;
  soNha?: string;
  duong?: string;
  phuong?: string;
  quan?: string;
  thanhPho?: string;
  moTa?: string;
  anhToaNha: string[];
  tongSoPhong: number;
  phongTrong?: number;
  phongDangThue?: number;
  tienNghiChung: string[];
  noiQuy?: string;
  trangThai?: string;
  ngayTao: DateLike;
  ngayCapNhat: DateLike;
  taoLuc?: DateLike;
  capNhatLuc?: DateLike;
}

export interface Phong {
  id?: ID;
  _id?: ID;
  nhaTroId?: ID;
  toaNha: ToaNhaRef;
  ten?: string;
  maPhong: string;
  khuVuc?: string;
  tang: number;
  dienTich: number;
  giaHienTai?: number;
  giaThue: number;
  tienCocMacDinh?: number;
  tienCoc: number;
  moTa?: string;
  anhPhong: string[];
  tienNghi: string[];
  trangThai: TrangThaiPhong;
  soNguoiToiDa: number;
  ngayTao: DateLike;
  ngayCapNhat: DateLike;
  taoLuc?: DateLike;
  capNhatLuc?: DateLike;
  hopDongHienTai?: {
    id?: ID;
    _id?: ID;
    khachThueId: Array<Pick<KhachThue, 'hoTen' | 'soDienThoai'> & { id?: ID; _id: ID }>;
    nguoiDaiDien: Pick<KhachThue, 'hoTen' | 'soDienThoai'> & { id?: ID; _id: ID };
  };
}

export interface KhachThue {
  id?: ID;
  _id?: ID;
  nguoiDungId?: ID;
  chuTroId?: ID;
  hoTen: string;
  soDienThoai: string;
  email?: string;
  soCccd?: string;
  cccd: string;
  ngaySinh: DateLike;
  gioiTinh?: 'nam' | 'nu' | 'khac' | string;
  diaChi?: string;
  queQuan: string;
  anhCCCD: AnhCCCD;
  ngheNghiep?: string;
  matKhau?: string;
  dangHoatDong?: boolean;
  trangThai: 'dangThue' | 'daTraPhong' | 'chuaThue' | 'ACTIVE' | string;
  ngayTao: DateLike;
  ngayCapNhat: DateLike;
  taoLuc?: DateLike;
  capNhatLuc?: DateLike;
  hopDongHienTai?: {
    id?: ID;
    _id?: ID;
    phong: {
      id?: ID;
      _id?: ID;
      maPhong: string;
      tang?: number;
      toaNha: Pick<ToaNha, 'id' | '_id' | 'tenToaNha'>;
    };
  };
}

export interface ThanhVienHopDong {
  id?: ID;
  _id?: ID;
  hopDongId: ID;
  khachThueId?: ID;
  hoTen: string;
  soCccd?: string;
  soDienThoai?: string;
  ngayVao: DateLike;
  ngayRoi?: DateLike;
  dangO: boolean;
  laNguoiDaiDien: boolean;
  ghiChu?: string;
}

export interface HopDong {
  id?: ID;
  _id?: ID;
  maHopDong: string;
  phongId?: ID;
  phong: PhongRef;
  khachThueId: ID[];
  khachThueDaiDienId?: ID;
  nguoiDaiDien: KhachThueRef;
  thanhVien?: ThanhVienHopDong[];
  ngayBatDau: DateLike;
  ngayKetThuc: DateLike;
  ngayKetThucThucTe?: DateLike;
  giaThueHopDong?: number;
  giaThue: number;
  tienCoc: number;
  trangThaiCoc?: TrangThaiCocHopDong;
  chuKyThanhToan: 'thang' | 'quy' | 'nam' | 'MONTHLY' | 'QUARTERLY' | 'YEARLY';
  ngayThanhToan: number;
  ngayThanhToanHangThang?: number;
  tuDongGiaHan?: boolean;
  dieuKhoan: string;
  giaDien: number;
  giaNuoc: number;
  chiSoDienBanDau: number;
  chiSoNuocBanDau: number;
  phiDichVu: PhiDichVu[];
  trangThai: TrangThaiHopDong;
  fileHopDong?: string;
  filePdf?: string;
  chuKyChuTro?: string;
  chuKyKhachThue?: string;
  ngayTao: DateLike;
  ngayCapNhat: DateLike;
  taoLuc?: DateLike;
  capNhatLuc?: DateLike;
}

export interface ChiSoDienNuoc {
  id?: ID;
  _id?: ID;
  phongId?: ID;
  phong: ID | Phong;
  hopDongId?: ID;
  loai?: LoaiChiSo;
  kyThang?: number;
  kyNam?: number;
  thang: number;
  nam: number;
  chiSoCu?: number;
  chiSoMoi?: number;
  tieuThu?: number;
  chiSoDienCu: number;
  chiSoDienMoi: number;
  soDienTieuThu: number;
  chiSoNuocCu: number;
  chiSoNuocMoi: number;
  soNuocTieuThu: number;
  anhDongHo?: string;
  anhChiSoDien?: string;
  anhChiSoNuoc?: string;
  nguoiGhiId?: ID;
  nguoiGhi: ID;
  trangThai?: TrangThaiChiSo;
  ghiChu?: string;
  ngayGhi: DateLike;
  ngayTao: DateLike;
  taoLuc?: DateLike;
}

export interface ChiTietHoaDon {
  id?: ID;
  _id?: ID;
  hoaDonId: ID;
  dichVuId?: ID;
  chiSoDienNuocId?: ID;
  suCoId?: ID;
  loai: LoaiMucHoaDon;
  moTa: string;
  soLuong: number;
  donGia: number;
  thanhTien: number;
}

export interface HoaDon {
  id?: ID;
  _id?: ID;
  maHoaDon: string;
  hopDongId?: ID;
  hopDong: Ref<HopDong>;
  phongId?: ID;
  phong: ID | Phong;
  khachThueId?: ID;
  khachThue: KhachThueRef;
  kyThang?: number;
  kyNam?: number;
  thang: number;
  nam: number;
  tuNgay?: DateLike;
  denNgay?: DateLike;
  soDuDauKy?: number;
  tongTienPhatSinh?: number;
  chiTiet?: ChiTietHoaDon[];
  tienPhong: number;
  tienDien: number;
  soDien: number;
  chiSoDienBanDau: number;
  chiSoDienCuoiKy: number;
  tienNuoc: number;
  soNuoc: number;
  chiSoNuocBanDau: number;
  chiSoNuocCuoiKy: number;
  phiDichVu: PhiDichVu[];
  tongTien: number;
  daTra?: number;
  daThanhToan: number;
  soDuCuoiKy?: number;
  conLai: number;
  trangThai: TrangThaiHoaDon;
  hanTra?: DateLike;
  hanThanhToan: DateLike;
  ngayLapHoaDon?: DateLike;
  ngayPhatHanh?: DateLike;
  ngayGui?: DateLike;
  daGui?: boolean;
  tienGiam?: number;
  phiPhatSinh?: number;
  ghiChu?: string;
  ngayTao: DateLike;
  ngayCapNhat: DateLike;
  taoLuc?: DateLike;
  capNhatLuc?: DateLike;
}

export interface ThanhToan {
  id?: ID;
  _id?: ID;
  hoaDonId?: ID;
  hoaDon: Ref<HoaDon>;
  khachThueId?: ID;
  soTien: number;
  phuongThucThanhToan?: PhuongThucThanhToanDb;
  phuongThuc: PhuongThucThanhToan;
  thongTinChuyenKhoan?: ThongTinChuyenKhoan;
  maThamChieu?: string;
  externalTransactionId?: string;
  trangThai?: TrangThaiThanhToan;
  ngayThanhToan: Date;
  nguoiThanhToanId?: ID;
  nguoiNhan?: ID;
  nguoiGhiNhanId?: ID;
  ghiChu?: string;
  anhBienLai?: string;
  ngayTao: DateLike;
  taoLuc?: DateLike;
}

export interface SuCo {
  id?: ID;
  _id?: ID;
  phongId?: ID;
  phong: PhongRef;
  khachThueId?: ID;
  khachThue: KhachThueRef;
  nguoiBaoId?: ID;
  nguoiBaoCao?: Pick<KhachThue, 'id' | '_id' | 'hoTen' | 'soDienThoai'>;
  tieuDe: string;
  moTa: string;
  anhSuCo?: string[];
  loaiSuCo: LoaiSuCo;
  uuTien?: UuTien;
  mucDoUuTien: UuTien;
  trangThai: TrangThaiSuCo;
  nguoiPhuTrachId?: ID;
  nguoiPhuTrach?: ID;
  ghiChuXuLy?: string;
  ghiChuChuNha?: string;
  chiPhiSuaChua?: number;
  tinhVaoHoaDon?: boolean;
  ngayBaoCao: DateLike;
  giaiQuyetLuc?: DateLike;
  ngayHoanThanh?: DateLike;
  ngayCapNhat: DateLike;
  taoLuc?: DateLike;
  capNhatLuc?: DateLike;
}

export interface ThongBao {
  id?: ID;
  _id?: ID;
  tieuDe: string;
  noiDung: string;
  loai: LoaiThongBao;
  nguoiGuiId?: ID;
  nguoiGui: ID;
  nguoiNhan: ID[];
  phong?: ID[];
  toaNha?: ID;
  doiTuong?: string;
  doiTuongId?: ID;
  kenh?: KenhThongBao;
  guiTatCa?: boolean;
  daDoc: ID[];
  ngayGui: DateLike;
  ngayTao: DateLike;
  taoLuc?: DateLike;
}

export interface CauHinhGia {
  id?: ID;
  _id?: ID;
  nhaTroId: ID;
  dichVuId?: ID;
  loai: LoaiMucHoaDon;
  tenHienThi: string;
  loaiTinhPhi: LoaiTinhPhi;
  donGia: number;
  hieuLucTu: DateLike;
  hieuLucDen?: DateLike;
  dangApDung: boolean;
}

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  message?: string;
  error?: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

export interface LoginForm {
  email: string;
  matKhau: string;
}

export interface RegisterForm {
  ten: string;
  hoTen?: string;
  email: string;
  matKhau: string;
  soDienThoai: string;
  vaiTro: VaiTroHeThong | VaiTroUi;
}

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
  tongCongNo?: number;
  tiLeLapDay?: number;
}
