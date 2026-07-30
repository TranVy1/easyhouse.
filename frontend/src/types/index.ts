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
  | 'OTHER'
  | 'BALCONY'
  | 'TRASH'
  | 'AIR_CONDITIONER'
  | 'WASHING_MACHINE'
  | 'REFRIGERATOR'
  | 'WATER_HEATER'
  | 'BED'
  | 'WARDROBE'
  | 'TABLE_CHAIR'
  | 'KITCHEN'
  | 'KITCHEN_SHELF'
  | 'CLEANING'
  | 'LAUNDRY'
  | 'SMART_LOCK'
  | 'SECURITY_CAMERA'
  | 'DEPOSIT';

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

export type TrangThaiLichHen = 'PENDING' | 'CONFIRMED' | 'CANCELLED' | 'COMPLETED' | 'NO_SHOW';
export type LoaiDoiTuongMedia = 'USER' | 'TENANT' | 'ROOM' | 'CONTRACT' | 'INVOICE' | 'PAYMENT' | 'INCIDENT' | 'METER_READING' | 'APPOINTMENT' | 'OTHER';

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

export interface DichVu {
  id?: ID;
  _id?: ID;
  chuTroId?: ID;
  tenDichVu: string;
  loaiTinhPhi: LoaiTinhPhi;
  donVi?: string;
  donGiaMacDinh: number;
  batBuoc: boolean;
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
  viDo?: number;
  kinhDo?: number;
  googlePlaceId?: string;
  diaChiDaChuanHoa?: string;
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

export interface Tang {
  id?: ID;
  _id?: ID;
  nhaTroId: ID;
  soTang: number;
  tenTang?: string;
  thuTuHienThi?: number;
  soPhongDuKien?: number;
  trangThai: string;
}

export type TrangThaiPhongHienThi = 'VACANT' | 'RENTED' | 'CONTRACT_EXPIRING' | 'MAINTENANCE';

export interface SoDoPhong {
  id?: ID;
  _id?: ID;
  maPhong: string;
  dienTich?: number;
  giaHienTai?: number;
  trangThaiVatLy: TrangThaiPhongDb;
  trangThaiHienThi: TrangThaiPhongHienThi;
  hopDongId?: ID;
  maHopDong?: string;
  ngayBatDau?: DateLike;
  ngayKetThuc?: DateLike;
  khachThueId?: ID;
  khachThueHienTai?: string;
}

export interface SoDoTang {
  soTang: number;
  tenTang?: string;
  phong: SoDoPhong[];
}

export interface ThongKeToaNha {
  id?: ID;
  _id?: ID;
  nhaTroId?: ID;
  tenToaNha: string;
  tongSoTang: number;
  tongSoPhong: number;
  phongTrong: number;
  phongDangThue: number;
  phongBaoTri: number;
  hopDongSapHetHan: number;
  doanhThuDuKienThang: number;
}

export interface SoDoToaNha extends ThongKeToaNha {
  tang: SoDoTang[];
}

export interface Phong {
  id?: ID;
  _id?: ID;
  nhaTroId?: ID;
  toaNha: ToaNhaRef;
  tenNhaTro?: string;
  viDo?: number;
  kinhDo?: number;
  khoangCachKm?: number;
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
  anhDaiDien?: string;
  tienNghi: string[];
  tienIchNoiBat?: string[];
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
  khachThueId: Array<ID | (Pick<KhachThue, 'hoTen'> & { _id: ID })>;
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
  signedPdfUrl?: string;
  tenantSignedAt?: string;
  landlordSignedAt?: string;
  signatureStatus?: 'UNSIGNED' | 'LANDLORD_SIGNED' | 'TENANT_SIGNED' | 'COMPLETED' | 'REJECTED';
  rejectionReason?: string;
  ghiChu?: string;
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
  chiTietHoaDon?: ChiTietHoaDon[];
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
  soDuCo?: number;
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

export interface LichHen {
  id?: ID;
  _id?: ID;
  phongId?: ID;
  phong?: PhongRef;
  nguoiDungId?: ID;
  hoTen: string;
  soDienThoai: string;
  email?: string;
  ngayHen: DateLike;
  trangThai: TrangThaiLichHen;
  daGuiNhacNho?: boolean;
  ghiChu?: string;
  ghiChuAdmin?: string;
  taoLuc?: DateLike;
  capNhatLuc?: DateLike;
}

export interface FileMedia {
  id?: ID;
  _id?: ID;
  doiTuong: LoaiDoiTuongMedia;
  doiTuongId: ID;
  url: string;
  publicId?: string;
  loaiFile?: string;
  kichThuocBytes?: number;
  metadata?: Record<string, unknown>;
  nguoiTaiLenId?: ID;
  taoLuc?: DateLike;
}

export type TenantProfile = Omit<KhachThue, 'hopDongHienTai'>;
export interface TenantContract extends Omit<HopDong, 'phong'> {
  phong?: {
    id?: ID;
    _id?: ID;
    maPhong?: string;
    ten?: string;
    giaThue?: number;
    toaNha?: { 
      id?: ID; 
      _id?: ID; 
      tenToaNha?: string; 
      diaChi?: {
        duong?: string;
        phuong?: string;
      }
    };
  };
}
export type TenantInvoice = Omit<HoaDon, 'hopDong' | 'khachThue'>;

export interface TenantDashboardData {
  khachThue: TenantProfile;
  hopDongHienTai?: TenantContract;
  soHoaDonChuaThanhToan: number;
  soSuCoDangMo: number;
  soThongBaoMoi: number;
  hoaDonGanNhat?: TenantInvoice;
  lienHe?: {
    hoTen: string;
    soDienThoai: string;
    email: string;
  };
}

export interface BaoCaoTongQuan {
  doanhThu: number;
  tienDaThu: number;
  tienChuaThu: number;
  tyLeLapDay: number;
  suCoCanXuLy: number;
  hopDongSapHetHan: number;
  bieuDoDoanhThu: {
    thang: string;
    doanhThu: number;
    daThu: number;
  }[];
}

export interface AuditLog {
  id?: ID;
  _id?: ID;
  nguoiDungId?: ID;
  nguoiDungHoTen?: string;
  nguoiDungEmail?: string;
  hanhDong: string;
  bangTacDong?: string;
  banGhiId?: ID;
  duLieuCu?: string;
  duLieuMoi?: string;
  ipAddress?: string;
  userAgent?: string;
  taoLuc?: DateLike;
}

export interface BankTransaction {
  id?: ID;
  _id?: ID;
  nhaTroId?: ID;
  hoaDonId?: ID;
  soTien: number;
  noiDungChuyenKhoan?: string;
  maGiaoDich?: string;
  nganHang?: string;
  thoiGianGiaoDich: DateLike;
  payload?: Record<string, unknown>;
  daDoiSoat: boolean;
  taoLuc?: DateLike;
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

export interface ContractSignature {
  id?: string;
  signerId?: string;
  signerName: string;
  signerRole: 'LANDLORD' | 'TENANT';
  signatureImageUrl?: string;
  signedAt: string;
  ipAddress?: string;
  userAgent?: string;
}

export type TrangThaiPhuongTien = 'HIEU_LUC' | 'HET_HIEU_LUC';

export interface PhuongTien {
  id?: ID;
  _id?: ID;
  maPt: string;
  loaiXe: string;
  bienSo: string;
  anhXe?: string;
  loaiPhuongTien?: string;
  tenDongXe?: string;
  mauXe?: string;
  tenChuXe?: string;
  soVeXe?: string;
  nhaTroId: ID;
  khachThueId?: ID;
  khachThue?: KhachThue;
  phongId?: ID;
  phong?: Phong;
  nhaTro?: ToaNha;
  trangThai: TrangThaiPhuongTien;
  createdAt?: DateLike;
  updatedAt?: DateLike;
}

export interface TaiSanPhong {
  id?: string;
  _id?: string;
  phongId?: string;
  khoTaiSanId?: string;
  tenPhong?: string;
  nhaTroId?: string;
  tenNhaTro?: string;
  tenTaiSan: string;
  soLuong: number;
  giaTri: number;
  tinhTrang: string;
  ghiChu?: string;
  anhTaiSan?: string;
}

export interface KhoTaiSan {
  id?: string;
  _id?: string;
  nhaTroId?: string;
  tenNhaTro?: string;
  tenTaiSan: string;
  hinhAnh?: string;
  tongSoLuong: number;
  soLuongKhaDung?: number;
  soLuongDaCapPhat?: number;
  soLuongHuHong?: number;
  tinhTrang: string;
  ghiChu?: string;
}

export interface LichSuKhoTaiSan {
  id?: string;
  khoTaiSanId?: string;
  phongId?: string;
  tenPhong?: string;
  loaiGiaoDich: string;
  soLuong: number;
  ghiChu?: string;
  taoLuc?: string;
}

// ─── Module tin nhắn (chat realtime) ────────────────────────────────────────

export type LoaiCuocTroChuyen = 'DIRECT' | 'GROUP' | 'BUILDING' | 'FLOOR' | 'SUPPORT';
export type LoaiTinNhan = 'TEXT' | 'IMAGE' | 'FILE' | 'SYSTEM';

export interface ThanhVienChat {
  _id: string;              // nguoiDungId
  hoTen?: string;
  bietDanh?: string;        // hiển thị ưu tiên bietDanh ?? hoTen
  anhDaiDien?: string;
  vaiTro?: string;
  docDenSeq?: number;       // dùng để hiện "đã xem"
}

export interface CuocTroChuyen {
  _id: string;
  loai: LoaiCuocTroChuyen;
  ten?: string;             // server đã tự suy tên hiển thị cho chat 1-1
  anh?: string;
  nhaTroId?: string;
  trangThai?: string;
  tinNhanCuoiLuc?: string;
  xemTruoc?: string;
  soTinChuaDoc?: number;
  ghim?: boolean;
  /** Đang tắt thông báo (gộp cả tắt vô thời hạn lẫn tắt có hạn). */
  tatThongBao?: boolean;
  /** Mốc hết hạn tắt. Null mà tatThongBao=true nghĩa là tắt vô thời hạn. */
  tatThongBaoDen?: string;
  /** Đang lưu trữ: ẩn khỏi danh sách chính nhưng giữ nguyên lịch sử (P8). */
  luuTru?: boolean;
  docDenSeq?: number;
  thanhVien?: ThanhVienChat[];
}

export interface TinNhan {
  _id: string;
  soThuTu: number;          // mốc thứ tự tuyệt đối, dùng làm cursor
  cuocTroChuyenId: string;
  nguoiGuiId?: string;      // null = tin hệ thống
  tenNguoiGui?: string;
  anhNguoiGui?: string;
  loai: LoaiTinNhan;
  noiDung?: string;
  fileUrl?: string;
  traLoiChoId?: string;
  maClient?: string;        // khớp tin optimistic với tin server trả về
  daThuHoi?: boolean;
  ngayTao?: string;
  dangGui?: boolean;        // chỉ tồn tại ở client, chưa có phản hồi từ server
  loiGui?: boolean;

  // P8 — ghim tin có phạm vi CẢ HỘI THOẠI, khác ghim hội thoại ở CuocTroChuyen.ghim
  dangGhim?: boolean;
  ghimLuc?: string;
  tenNguoiGhim?: string;
  chuyenTiepTuId?: string;  // có giá trị = tin này là bản chuyển tiếp
}

/** Ai đã xem một tin nhắn — dùng cho hộp thoại "Chi tiết tin nhắn" (P8). */
export interface NguoiXemTin {
  _id: string;
  hoTen?: string;
  anhDaiDien?: string;
  xemLuc?: string;
}

export interface ChiTietTinNhan {
  tinNhan: TinNhan;
  daXem: NguoiXemTin[];
  chuaXem: NguoiXemTin[];
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

/** Một liên kết được chia sẻ trong hội thoại (server trích từ nội dung tin nhắn). */
export interface LienKetChat {
  url: string;
  tinNhanId: string;
  soThuTu: number;
  tenNguoiGui?: string;
  ngayGui?: string;
}
