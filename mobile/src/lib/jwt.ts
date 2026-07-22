/**
 * Đọc phần thân (payload) của JWT.
 *
 * Chỉ để biết "mình là ai", KHÔNG phải xác thực — chữ ký do server kiểm tra trên
 * từng request. Client chỉ cần đọc claim, không cần và không được tin tưởng nó
 * cho việc phân quyền.
 *
 * Tự giải mã base64url thay vì dùng `atob`: React Native không cung cấp `atob`
 * trong global (đã kiểm tra trong react-native/Libraries), nên phụ thuộc vào nó
 * là đặt cược vào thứ có thể không tồn tại.
 */

const BANG_BASE64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

function giaiMaBase64Url(chuoi: string): Uint8Array {
  const base64 = chuoi.replace(/-/g, '+').replace(/_/g, '/');
  const dem = base64.replace(/=+$/, '');

  const bytes = new Uint8Array(Math.floor((dem.length * 3) / 4));
  let viTri = 0;
  let bo = 0;
  let soBit = 0;

  for (const kyTu of dem) {
    const giaTri = BANG_BASE64.indexOf(kyTu);
    if (giaTri === -1) continue; // bỏ qua ký tự lạ thay vì ném lỗi giữa chừng

    bo = (bo << 6) | giaTri;
    soBit += 6;
    if (soBit >= 8) {
      soBit -= 8;
      bytes[viTri++] = (bo >> soBit) & 0xff;
    }
  }
  return bytes.subarray(0, viTri);
}

/**
 * Lấy id người dùng từ claim `sub`.
 *
 * KHÔNG được dùng id trả về từ API đăng nhập khách thuê: nó là **khach_thue.id**
 * (AuthService.loginKhachThue trả KhachThueResponse), trong khi tin nhắn gắn theo
 * **nguoi_dung.id**. Claim `sub` là nguoi_dung.id ở cả hai luồng đăng nhập.
 */
export function docNguoiDungIdTuToken(token?: string | null): string | undefined {
  if (!token) return undefined;
  try {
    const phanThan = token.split('.')[1];
    if (!phanThan) return undefined;
    const json = new TextDecoder().decode(giaiMaBase64Url(phanThan));
    const claims = JSON.parse(json) as { sub?: string };
    return claims?.sub;
  } catch {
    return undefined;
  }
}
