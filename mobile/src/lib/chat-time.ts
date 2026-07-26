/**
 * Định dạng thời gian cho khung chat, theo đúng quy ước của Messenger/Zalo.
 *
 * LƯU Ý: file này là bản sao y hệt `frontend/src/lib/chat-time.ts`. Hai dự án là
 * hai package npm riêng, không có monorepo nên chưa chia sẻ code được. Khi sửa
 * quy tắc hiển thị thời gian thì phải sửa CẢ HAI nơi.
 *
 * Ba quy tắc rút ra khi khảo sát các ứng dụng chat phổ biến:
 *
 * 1. KHÔNG gắn giờ vào từng tin. Mỗi bong bóng một cái giờ làm màn hình rối và
 *    khó đọc. Thay vào đó dùng dải phân cách ở giữa, chỉ chèn khi có khoảng nghỉ
 *    đáng kể hoặc sang ngày mới.
 * 2. GOM tin gửi liên tiếp của cùng một người trong khoảng ngắn thành một cụm —
 *    chỉ tin đầu cụm mới hiện tên người gửi.
 * 3. Nhãn thời gian dùng mốc TƯƠNG ĐỐI ("Hôm nay", "Hôm qua", tên thứ) vì người
 *    đọc quan tâm "cách đây bao lâu" hơn là ngày tháng tuyệt đối.
 */

/** Chèn dải phân cách khi cách tin trước quá lâu. Messenger dùng mốc khoảng 1 giờ. */
const NGUONG_PHAN_CACH_MS = 60 * 60 * 1000;

/** Gom tin cùng người trong khoảng này thành một cụm. */
const NGUONG_GOM_CUM_MS = 5 * 60 * 1000;

const THU_TRONG_TUAN = ['Chủ nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'];

const haiChuSo = (n: number) => String(n).padStart(2, '0');

/** "14:32" */
export function gioPhut(d: Date): string {
  return `${haiChuSo(d.getHours())}:${haiChuSo(d.getMinutes())}`;
}

function cungNgay(a: Date, b: Date): boolean {
  return (
    a.getFullYear() === b.getFullYear() &&
    a.getMonth() === b.getMonth() &&
    a.getDate() === b.getDate()
  );
}

/**
 * Nhãn cho dải phân cách. Càng xa hiện tại thì càng nhiều thông tin:
 *   hôm nay        -> "14:32"
 *   hôm qua        -> "Hôm qua 14:32"
 *   trong 7 ngày   -> "Thứ Ba 14:32"
 *   cùng năm       -> "12 thg 7, 14:32"
 *   năm khác       -> "12 thg 7, 2025 14:32"
 */
export function nhanPhanCach(iso?: string): string {
  if (!iso) return '';
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return '';

  const bayGio = new Date();
  const homQua = new Date(bayGio);
  homQua.setDate(bayGio.getDate() - 1);

  if (cungNgay(d, bayGio)) return gioPhut(d);
  if (cungNgay(d, homQua)) return `Hôm qua ${gioPhut(d)}`;

  const cachMay = Math.floor((bayGio.getTime() - d.getTime()) / (24 * 60 * 60 * 1000));
  if (cachMay < 7) return `${THU_TRONG_TUAN[d.getDay()]} ${gioPhut(d)}`;

  const ngayThang = `${d.getDate()} thg ${d.getMonth() + 1}`;
  return d.getFullYear() === bayGio.getFullYear()
    ? `${ngayThang}, ${gioPhut(d)}`
    : `${ngayThang}, ${d.getFullYear()} ${gioPhut(d)}`;
}

/**
 * Nhãn rất ngắn cho danh sách hội thoại, nơi chỉ có vài chục pixel:
 *   hôm nay -> "14:32" · hôm qua -> "Hôm qua" · trong tuần -> "T3" · cũ hơn -> "12/7"
 */
export function nhanNgan(iso?: string): string {
  if (!iso) return '';
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return '';

  const bayGio = new Date();
  const homQua = new Date(bayGio);
  homQua.setDate(bayGio.getDate() - 1);

  if (cungNgay(d, bayGio)) return gioPhut(d);
  if (cungNgay(d, homQua)) return 'Hôm qua';

  const cachMay = Math.floor((bayGio.getTime() - d.getTime()) / (24 * 60 * 60 * 1000));
  if (cachMay < 7) return d.getDay() === 0 ? 'CN' : `T${d.getDay() + 1}`;

  return `${d.getDate()}/${d.getMonth() + 1}`;
}

/** Giờ đầy đủ cho tooltip khi rê chuột — nơi duy nhất hiện thời gian chính xác. */
export function gioDayDu(iso?: string): string {
  if (!iso) return '';
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return '';
  return `${THU_TRONG_TUAN[d.getDay()]}, ${d.getDate()}/${d.getMonth() + 1}/${d.getFullYear()} lúc ${gioPhut(d)}:${haiChuSo(d.getSeconds())}`;
}

export interface ViTriTrongCum {
  /** Có chèn dải phân cách thời gian phía trên tin này không. */
  hienPhanCach: boolean;
  /** Tin đầu cụm — nơi duy nhất hiện tên người gửi. */
  dauCum: boolean;
  /** Tin cuối cụm — nơi hiện giờ gửi và trạng thái "đã xem". */
  cuoiCum: boolean;
}

/**
 * Tính vị trí của một tin trong cụm, dựa vào tin liền trước và liền sau.
 *
 * Tin hệ thống luôn đứng riêng: nó không thuộc về ai nên không gom cụm được.
 */
export function viTriTrongCum(
  tin: { nguoiGuiId?: string; ngayTao?: string; loai?: string },
  truoc?: { nguoiGuiId?: string; ngayTao?: string; loai?: string },
  sau?: { nguoiGuiId?: string; ngayTao?: string; loai?: string },
): ViTriTrongCum {
  const t = tin.ngayTao ? new Date(tin.ngayTao).getTime() : 0;
  const tTruoc = truoc?.ngayTao ? new Date(truoc.ngayTao).getTime() : null;
  const tSau = sau?.ngayTao ? new Date(sau.ngayTao).getTime() : null;

  const hienPhanCach =
    tTruoc === null ||
    t - tTruoc >= NGUONG_PHAN_CACH_MS ||
    !cungNgay(new Date(t), new Date(tTruoc));

  if (tin.loai === 'SYSTEM') {
    return { hienPhanCach, dauCum: true, cuoiCum: true };
  }

  const cungNguoiTruoc =
    truoc?.loai !== 'SYSTEM' &&
    truoc?.nguoiGuiId === tin.nguoiGuiId &&
    tTruoc !== null &&
    t - tTruoc < NGUONG_GOM_CUM_MS;

  const cungNguoiSau =
    sau?.loai !== 'SYSTEM' &&
    sau?.nguoiGuiId === tin.nguoiGuiId &&
    tSau !== null &&
    tSau - t < NGUONG_GOM_CUM_MS;

  return {
    hienPhanCach,
    dauCum: hienPhanCach || !cungNguoiTruoc,
    cuoiCum: !cungNguoiSau,
  };
}
