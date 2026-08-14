import type {
  ChiTietHoaDon,
  HoaDon,
  HopDong,
  KhachThue,
  Phong,
  PhuongThucThanhToan,
  PhuongThucThanhToanDb,
  SuCo,
  ThanhToan,
  ThongBao,
  ToaNha,
  TrangThaiHoaDon,
  TrangThaiHoaDonDb,
  TrangThaiHopDong,
  TrangThaiHopDongDb,
  TrangThaiPhong,
  TrangThaiPhongDb,
  TrangThaiSuCo,
} from '@/types';

type AnyRecord = Record<string, unknown>;

const isRecord = (value: unknown): value is AnyRecord =>
  typeof value === 'object' && value !== null && !Array.isArray(value);

export const getEntityId = (value: unknown): string => {
  if (typeof value === 'string') return value;
  if (!isRecord(value)) return '';
  return String(value.id ?? value._id ?? '');
};

const toNumber = (value: unknown, fallback = 0): number => {
  if (typeof value === 'number' && Number.isFinite(value)) return value;
  if (typeof value === 'string' && value.trim() !== '') {
    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : fallback;
  }
  return fallback;
};

const toStringArray = (value: unknown): string[] => {
  if (!Array.isArray(value)) return [];
  return value.map((item) => String(item)).filter(Boolean);
};

export const phongStatusFromDb = (status?: string): TrangThaiPhong => {
  switch (status) {
    case 'AVAILABLE':
      return 'trong';
    case 'RESERVED':
      return 'daDat';
    case 'RENTED':
      return 'dangThue';
    case 'MAINTENANCE':
      return 'baoTri';
    case 'INACTIVE':
      return 'ngungHoatDong';
    default:
      return (status as TrangThaiPhong) || 'trong';
  }
};

export const phongStatusToDb = (status?: string): TrangThaiPhongDb => {
  switch (status) {
    case 'trong':
      return 'AVAILABLE';
    case 'daDat':
      return 'RESERVED';
    case 'dangThue':
      return 'RENTED';
    case 'baoTri':
      return 'MAINTENANCE';
    case 'ngungHoatDong':
      return 'INACTIVE';
    default:
      return (status as TrangThaiPhongDb) || 'AVAILABLE';
  }
};

export const hopDongStatusFromDb = (status?: string): TrangThaiHopDong => {
  switch (status) {
    case 'DRAFT':
      return 'nhap';
    case 'PENDING':
      return 'choKichHoat';
    case 'ACTIVE':
      return 'hoatDong';
    case 'EXPIRED':
      return 'hetHan';
    case 'TERMINATED':
      return 'daKetThuc';
    case 'CANCELLED':
      return 'daHuy';
    default:
      return (status as TrangThaiHopDong) || 'nhap';
  }
};

export const hopDongStatusToDb = (status?: string): TrangThaiHopDongDb => {
  switch (status) {
    case 'nhap':
      return 'DRAFT';
    case 'choKichHoat':
      return 'PENDING';
    case 'hoatDong':
      return 'ACTIVE';
    case 'hetHan':
      return 'EXPIRED';
    case 'daKetThuc':
      return 'TERMINATED';
    case 'daHuy':
      return 'CANCELLED';
    default:
      return (status as TrangThaiHopDongDb) || 'DRAFT';
  }
};

export const hoaDonStatusFromDb = (status?: string): TrangThaiHoaDon => {
  switch (status) {
    case 'DRAFT':
      return 'nhap';
    case 'UNPAID':
    case 'ISSUED':
      return 'chuaThanhToan';
    case 'PARTIAL':
      return 'daThanhToanMotPhan';
    case 'PAID':
      return 'daThanhToan';
    case 'OVERPAID':
      return 'thanhToanDu';
    case 'OVERDUE':
      return 'quaHan';
    case 'CANCELLED':
      return 'daHuy';
    default:
      return (status as TrangThaiHoaDon) || 'chuaThanhToan';
  }
};

export const hoaDonStatusToDb = (status?: string): TrangThaiHoaDonDb => {
  switch (status) {
    case 'nhap':
      return 'DRAFT';
    case 'chuaThanhToan':
      return 'ISSUED';
    case 'daThanhToanMotPhan':
      return 'PARTIAL';
    case 'daThanhToan':
      return 'PAID';
    case 'thanhToanDu':
      return 'OVERPAID';
    case 'quaHan':
      return 'OVERDUE';
    case 'daHuy':
      return 'CANCELLED';
    default:
      return (status as TrangThaiHoaDonDb) || 'UNPAID';
  }
};

export const phuongThucFromDb = (method?: string): PhuongThucThanhToan => {
  switch (method) {
    case 'CASH':
      return 'tienMat';
    case 'BANK_TRANSFER':
      return 'chuyenKhoan';
    case 'VIETQR':
      return 'vietQr';
    case 'MOMO':
    case 'ZALOPAY':
      return 'viDienTu';
    case 'OTHER':
      return 'khac';
    default:
      return (method as PhuongThucThanhToan) || 'tienMat';
  }
};

export const phuongThucToDb = (method?: string): PhuongThucThanhToanDb => {
  switch (method) {
    case 'tienMat':
      return 'CASH';
    case 'chuyenKhoan':
      return 'BANK_TRANSFER';
    case 'vietQr':
      return 'VIETQR';
    case 'viDienTu':
      return 'MOMO';
    case 'khac':
      return 'OTHER';
    default:
      return (method as PhuongThucThanhToanDb) || 'CASH';
  }
};

export const normalizeToaNha = (raw: unknown): ToaNha => {
  const item = isRecord(raw) ? raw : {};
  const diaChiObj = isRecord(item.diaChi) ? item.diaChi : {};
  const diaChi = {
    soNha: String(item.soNha ?? item.so_nha ?? diaChiObj.soNha ?? ''),
    duong: String(item.duong ?? diaChiObj.duong ?? ''),
    phuong: String(item.phuong ?? diaChiObj.phuong ?? ''),
    quan: String(item.quan ?? diaChiObj.quan ?? ''),
    thanhPho: String(item.thanhPho ?? item.thanh_pho ?? diaChiObj.thanhPho ?? ''),
  };

  return {
    ...(item as Partial<ToaNha>),
    id: getEntityId(item),
    _id: getEntityId(item),
    ten: String(item.ten ?? item.tenToaNha ?? ''),
    tenToaNha: String(item.tenToaNha ?? item.ten ?? ''),
    chuTroId: String(item.chuTroId ?? item.chu_tro_id ?? item.chuSoHuu ?? ''),
    chuSoHuu: String(item.chuSoHuu ?? item.chuTroId ?? item.chu_tro_id ?? ''),
    diaChi,
    diaChiDayDu: String(item.diaChiDayDu ?? item.dia_chi ?? ''),
    anhToaNha: Array.isArray(item.anhToaNha) ? item.anhToaNha.map(String) : [],
    tongSoPhong: toNumber(item.tongSoPhong),
    tienNghiChung: Array.isArray(item.tienNghiChung)
      ? item.tienNghiChung.map(String)
      : String(item.tien_nghi_chung ?? '')
          .split(',')
          .map((text) => text.trim())
          .filter(Boolean),
    ngayTao: String(item.ngayTao ?? item.tao_luc ?? item.taoLuc ?? ''),
    ngayCapNhat: String(item.ngayCapNhat ?? item.cap_nhat_luc ?? item.capNhatLuc ?? ''),
  };
};

export const normalizePhong = (raw: unknown): Phong => {
  const item = isRecord(raw) ? raw : {};
  const images = Array.isArray(item.anhPhong)
    ? item.anhPhong.map(String)
    : Array.isArray(item.anh_phong)
      ? item.anh_phong.map(String)
      : [];
  const amenities = Array.isArray(item.tienNghi)
    ? item.tienNghi.map(String)
    : Array.isArray(item.tien_nghi)
      ? item.tien_nghi.map(String)
      : [];

  return {
    ...(item as Partial<Phong>),
    id: getEntityId(item),
    _id: getEntityId(item),
    nhaTroId: String(item.nhaTroId ?? item.nha_tro_id ?? item.toaNha ?? ''),
    toaNha: (item.toaNha ?? item.nhaTro ?? item.nha_tro_id ?? '') as Phong['toaNha'],
    ten: String(item.ten ?? item.maPhong ?? ''),
    maPhong: String(item.maPhong ?? item.ten ?? ''),
    tang: toNumber(item.tang),
    dienTich: toNumber(item.dienTich ?? item.dien_tich),
    giaHienTai: toNumber(item.giaHienTai ?? item.gia_hien_tai ?? item.giaThue),
    giaThue: toNumber(item.giaThue ?? item.giaHienTai ?? item.gia_hien_tai),
    tienCocMacDinh: toNumber(item.tienCocMacDinh ?? item.tien_coc_mac_dinh ?? item.tienCoc),
    tienCoc: toNumber(item.tienCoc ?? item.tienCocMacDinh ?? item.tien_coc_mac_dinh),
    anhPhong: images,
    tienNghi: amenities,
    trangThai: phongStatusFromDb(String(item.trangThai ?? item.trang_thai ?? 'AVAILABLE')),
    soNguoiToiDa: toNumber(item.soNguoiToiDa ?? item.so_nguoi_toi_da, 1),
    ngayTao: String(item.ngayTao ?? item.tao_luc ?? item.taoLuc ?? ''),
    ngayCapNhat: String(item.ngayCapNhat ?? item.cap_nhat_luc ?? item.capNhatLuc ?? ''),
  };
};

export const normalizeKhachThue = (raw: unknown): KhachThue => {
  const item = isRecord(raw) ? raw : {};
  const anhCCCD = isRecord(item.anhCCCD) ? item.anhCCCD : {};

  return {
    ...(item as Partial<KhachThue>),
    id: getEntityId(item),
    _id: getEntityId(item),
    nguoiDungId: String(item.nguoiDungId ?? item.nguoi_dung_id ?? ''),
    chuTroId: String(item.chuTroId ?? item.chu_tro_id ?? ''),
    hoTen: String(item.hoTen ?? item.ho_ten ?? ''),
    soDienThoai: String(item.soDienThoai ?? item.so_dien_thoai ?? ''),
    soCccd: String(item.soCccd ?? item.so_cccd ?? item.cccd ?? ''),
    cccd: String(item.cccd ?? item.soCccd ?? item.so_cccd ?? ''),
    ngaySinh: String(item.ngaySinh ?? item.ngay_sinh ?? ''),
    queQuan: String(item.queQuan ?? item.que_quan ?? ''),
    anhCCCD: {
      matTruoc: String(anhCCCD.matTruoc ?? item.anhCccdTruoc ?? item.anh_cccd_truoc ?? ''),
      matSau: String(anhCCCD.matSau ?? item.anhCccdSau ?? item.anh_cccd_sau ?? ''),
    },
    dangHoatDong: item.dangHoatDong === undefined ? true : Boolean(item.dangHoatDong),
    trangThai: (item.trangThai as KhachThue['trangThai']) || (item.dangHoatDong === false ? 'daTraPhong' : 'chuaThue'),
    ngayTao: String(item.ngayTao ?? item.tao_luc ?? item.taoLuc ?? ''),
    ngayCapNhat: String(item.ngayCapNhat ?? item.cap_nhat_luc ?? item.capNhatLuc ?? ''),
  };
};

export const normalizeHopDong = (raw: unknown): HopDong => {
  const item = isRecord(raw) ? raw : {};
  const members = Array.isArray(item.thanhVien)
    ? item.thanhVien
    : Array.isArray(item.thanh_vien)
      ? item.thanh_vien
      : [];
  const representativeId = getEntityId(item.khachThueDaiDienId ?? item.khach_thue_id ?? item.nguoiDaiDien ?? '');

  return {
    ...(item as Partial<HopDong>),
    id: getEntityId(item),
    _id: getEntityId(item),
    maHopDong: String(item.maHopDong ?? item.ma_hop_dong ?? ''),
    phongId: String(item.phongId ?? item.phong_id ?? item.phong ?? ''),
    phong: (item.phong ?? item.phongId ?? item.phong_id ?? '') as HopDong['phong'],
    khachThueDaiDienId: representativeId,
    khachThueId:
      Array.isArray(item.khachThueId) && item.khachThueId.length > 0
        ? item.khachThueId.map(getEntityId)
        : [representativeId, ...members.map((member) => getEntityId(member))].filter(Boolean),
    nguoiDaiDien: (item.nguoiDaiDien ?? item.khachThueDaiDien ?? representativeId) as HopDong['nguoiDaiDien'],
    ngayBatDau: String(item.ngayBatDau ?? item.ngay_bat_dau ?? ''),
    ngayKetThuc: String(item.ngayKetThuc ?? item.ngay_ket_thuc ?? ''),
    giaThueHopDong: toNumber(item.giaThueHopDong ?? item.gia_thue_hop_dong ?? item.giaThue),
    giaThue: toNumber(item.giaThue ?? item.giaThueHopDong ?? item.gia_thue_hop_dong),
    tienCoc: toNumber(item.tienCoc ?? item.tien_coc),
    chuKyThanhToan: (item.chuKyThanhToan ?? item.chu_ky_thanh_toan ?? 'thang') as HopDong['chuKyThanhToan'],
    ngayThanhToan: toNumber(item.ngayThanhToan ?? item.ngay_thanh_toan_hang_thang, 5),
    ngayThanhToanHangThang: toNumber(item.ngayThanhToanHangThang ?? item.ngay_thanh_toan_hang_thang, 5),
    dieuKhoan: String(item.dieuKhoan ?? item.noi_dung_hop_dong ?? ''),
    giaDien: toNumber(item.giaDien),
    giaNuoc: toNumber(item.giaNuoc),
    chiSoDienBanDau: toNumber(item.chiSoDienBanDau ?? item.chi_so_dien_ban_dau),
    chiSoNuocBanDau: toNumber(item.chiSoNuocBanDau ?? item.chi_so_nuoc_ban_dau),
    phiDichVu: Array.isArray(item.phiDichVu) ? (item.phiDichVu as HopDong['phiDichVu']) : [],
    trangThai: hopDongStatusFromDb(String(item.trangThai ?? item.trang_thai ?? 'DRAFT')),
    ngayTao: String(item.ngayTao ?? item.tao_luc ?? item.taoLuc ?? ''),
    ngayCapNhat: String(item.ngayCapNhat ?? item.cap_nhat_luc ?? item.capNhatLuc ?? ''),
  };
};

export const normalizeHoaDon = (raw: unknown): HoaDon => {
  const item = isRecord(raw) ? raw : {};
  const details = Array.isArray(item.chiTiet)
    ? (item.chiTiet as ChiTietHoaDon[])
    : Array.isArray(item.chiTietHoaDon)
      ? (item.chiTietHoaDon as ChiTietHoaDon[])
    : Array.isArray(item.chi_tiet)
      ? (item.chi_tiet as ChiTietHoaDon[])
      : [];
  const roomLine = details.find((line) => line.loai === 'ROOM');
  const electricityLine = details.find((line) => line.loai === 'ELECTRICITY');
  const waterLine = details.find((line) => line.loai === 'WATER');
  const serviceLines = details.filter((line) => !['ROOM', 'ELECTRICITY', 'WATER', 'DEBT', 'DISCOUNT'].includes(line.loai));
  const tongTien = toNumber(item.tongTien ?? item.tong_tien);
  const daTra = toNumber(item.daTra ?? item.da_tra ?? item.daThanhToan);

  return {
    ...(item as Partial<HoaDon>),
    id: getEntityId(item),
    _id: getEntityId(item),
    maHoaDon: String(item.maHoaDon ?? item.ma_hoa_don ?? ''),
    hopDongId: String(item.hopDongId ?? item.hop_dong_id ?? item.hopDong ?? ''),
    hopDong: (item.hopDong ?? item.hopDongId ?? item.hop_dong_id ?? '') as HoaDon['hopDong'],
    phongId: String(item.phongId ?? item.phong_id ?? item.phong ?? ''),
    phong: (item.phong ?? item.phongId ?? item.phong_id ?? '') as HoaDon['phong'],
    khachThueId: String(item.khachThueId ?? item.khach_thue_id ?? item.khachThue ?? ''),
    khachThue: (item.khachThue ?? item.khachThueId ?? item.khach_thue_id ?? '') as HoaDon['khachThue'],
    kyThang: toNumber(item.kyThang ?? item.ky_thang ?? item.thang),
    kyNam: toNumber(item.kyNam ?? item.ky_nam ?? item.nam),
    thang: toNumber(item.thang ?? item.kyThang ?? item.ky_thang),
    nam: toNumber(item.nam ?? item.kyNam ?? item.ky_nam),
    soDuDauKy: toNumber(item.soDuDauKy ?? item.so_du_dau_ky),
    tongTienPhatSinh: toNumber(item.tongTienPhatSinh ?? item.tong_tien_phat_sinh),
    chiTiet: details,
    tienPhong: toNumber(item.tienPhong, toNumber(roomLine?.thanhTien)),
    tienDien: toNumber(item.tienDien, toNumber(electricityLine?.thanhTien)),
    soDien: toNumber(item.soDien, toNumber(electricityLine?.soLuong)),
    chiSoDienBanDau: toNumber(item.chiSoDienBanDau),
    chiSoDienCuoiKy: toNumber(item.chiSoDienCuoiKy),
    tienNuoc: toNumber(item.tienNuoc, toNumber(waterLine?.thanhTien)),
    soNuoc: toNumber(item.soNuoc, toNumber(waterLine?.soLuong)),
    chiSoNuocBanDau: toNumber(item.chiSoNuocBanDau),
    chiSoNuocCuoiKy: toNumber(item.chiSoNuocCuoiKy),
    phiDichVu: Array.isArray(item.phiDichVu)
      ? (item.phiDichVu as HoaDon['phiDichVu'])
      : serviceLines.map((line) => ({ id: line.id, ten: line.moTa, gia: line.thanhTien, soLuong: line.soLuong })),
    tongTien,
    daTra,
    daThanhToan: daTra,
    soDuCuoiKy: toNumber(item.soDuCuoiKy ?? item.so_du_cuoi_ky, tongTien - daTra),
    conLai: toNumber(item.conLai, tongTien - daTra),
    trangThai: hoaDonStatusFromDb(String(item.trangThai ?? item.trang_thai ?? 'UNPAID')),
    hanTra: String(item.hanTra ?? item.han_tra ?? item.hanThanhToan ?? ''),
    hanThanhToan: String(item.hanThanhToan ?? item.hanTra ?? item.han_tra ?? ''),
    ngayTao: String(item.ngayTao ?? item.tao_luc ?? item.taoLuc ?? ''),
    ngayCapNhat: String(item.ngayCapNhat ?? item.cap_nhat_luc ?? item.capNhatLuc ?? ''),
  };
};

export const normalizeThanhToan = (raw: unknown): ThanhToan => {
  const item = isRecord(raw) ? raw : {};
  return {
    ...(item as Partial<ThanhToan>),
    id: getEntityId(item),
    _id: getEntityId(item),
    hoaDonId: String(item.hoaDonId ?? item.hoa_don_id ?? item.hoaDon ?? ''),
    hoaDon: (item.hoaDon ?? item.hoaDonId ?? item.hoa_don_id ?? '') as ThanhToan['hoaDon'],
    khachThueId: String(item.khachThueId ?? item.khach_thue_id ?? ''),
    soTien: toNumber(item.soTien ?? item.so_tien),
    phuongThucThanhToan: phuongThucToDb(String(item.phuongThucThanhToan ?? item.phuong_thuc_thanh_toan ?? item.phuongThuc)),
    phuongThuc: phuongThucFromDb(String(item.phuongThuc ?? item.phuongThucThanhToan ?? item.phuong_thuc_thanh_toan)),
    maThamChieu: String(item.maThamChieu ?? item.ma_tham_chieu ?? ''),
    externalTransactionId: String(item.externalTransactionId ?? item.external_transaction_id ?? ''),
    trangThai: (item.trangThai ?? item.trang_thai ?? 'SUCCESS') as ThanhToan['trangThai'],
    ngayThanhToan: new Date(String(item.ngayThanhToan ?? item.ngay_thanh_toan ?? Date.now())),
    nguoiThanhToanId: String(item.nguoiThanhToanId ?? item.nguoi_thanh_toan_id ?? ''),
    nguoiNhan: String(item.nguoiNhan ?? item.nguoi_ghi_nhan_id ?? ''),
    nguoiGhiNhanId: String(item.nguoiGhiNhanId ?? item.nguoi_ghi_nhan_id ?? ''),
    ngayTao: String(item.ngayTao ?? item.tao_luc ?? item.taoLuc ?? ''),
  };
};

export const normalizeSuCo = (raw: unknown): SuCo => {
  const item = isRecord(raw) ? raw : {};
  const priority = String(item.uuTien ?? item.mucDoUuTien ?? item.uu_tien ?? 'trung_binh') as SuCo['mucDoUuTien'];

  return {
    ...(item as Partial<SuCo>),
    id: getEntityId(item),
    _id: getEntityId(item),
    phongId: String(item.phongId ?? item.phong_id ?? item.phong ?? ''),
    phong: (item.phong ?? item.phongId ?? item.phong_id ?? '') as SuCo['phong'],
    khachThueId: String(item.khachThueId ?? item.khach_thue_id ?? item.khachThue ?? ''),
    khachThue: (item.khachThue ?? item.khachThueId ?? item.khach_thue_id ?? '') as SuCo['khachThue'],
    tieuDe: String(item.tieuDe ?? item.tieu_de ?? ''),
    moTa: String(item.moTa ?? item.mo_ta ?? ''),
    nguoiBaoId: String(item.nguoiBaoId ?? item.nguoi_bao_id ?? ''),
    loaiSuCo: String(item.loaiSuCo ?? item.loai_su_co ?? 'khac') as SuCo['loaiSuCo'],
    uuTien: priority,
    mucDoUuTien: priority,
    trangThai: String(item.trangThai ?? item.trang_thai ?? 'PENDING') as TrangThaiSuCo,
    nguoiPhuTrachId: String(item.nguoiPhuTrachId ?? item.nguoi_phu_trach_id ?? ''),
    nguoiPhuTrach: String(item.nguoiPhuTrach ?? item.nguoi_phu_trach_id ?? ''),
    ngayBaoCao: String(item.ngayBaoCao ?? item.tao_luc ?? item.taoLuc ?? ''),
    giaiQuyetLuc: String(item.giaiQuyetLuc ?? item.giai_quyet_luc ?? ''),
    ngayCapNhat: String(item.ngayCapNhat ?? item.cap_nhat_luc ?? item.capNhatLuc ?? ''),
  };
};

export const normalizeThongBao = (raw: unknown): ThongBao => {
  const item = isRecord(raw) ? raw : {};
  return {
    ...(item as Partial<ThongBao>),
    id: getEntityId(item),
    _id: getEntityId(item),
    tieuDe: String(item.tieuDe ?? item.tieu_de ?? ''),
    noiDung: String(item.noiDung ?? item.noi_dung ?? ''),
    loai: (item.loai as ThongBao['loai']) || 'chung',
    nguoiGuiId: String(item.nguoiGuiId ?? item.nguoi_gui_id ?? item.nguoiGui ?? ''),
    nguoiGui: String(item.nguoiGui ?? item.nguoiGuiId ?? item.nguoi_gui_id ?? ''),
    nguoiNhan: toStringArray(item.nguoiNhan ?? item.nguoi_nhan),
    phong: toStringArray(item.phong ?? item.phongIds ?? item.phong_ids),
    toaNha: String(item.toaNha ?? item.toa_nha_id ?? ''),
    daDoc: toStringArray(item.daDoc ?? item.da_doc ?? item.da_doc_json),
    ngayGui: String(item.ngayGui ?? item.ngay_gui ?? item.tao_luc ?? ''),
    ngayTao: String(item.ngayTao ?? item.tao_luc ?? item.taoLuc ?? ''),
  };
};
