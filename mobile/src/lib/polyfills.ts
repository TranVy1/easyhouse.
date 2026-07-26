/**
 * Polyfill bắt buộc cho @stomp/stompjs trên React Native.
 *
 * stompjs dùng TextEncoder (5 chỗ) và TextDecoder (3 chỗ) để mã hoá khung STOMP.
 * Trên Hermes:
 *   - TextEncoder: engine đã cung cấp sẵn
 *   - TextDecoder: KHÔNG có, phải lấp
 *
 * `@bacons/text-decoder/install` tự kiểm tra `"TextDecoder" in globalThis` trước
 * khi lấp, nên import nhiều lần cũng không ghi đè thứ engine đã có.
 *
 * PHẢI import file này ở entry của app (app/_layout.tsx), TRƯỚC khi bất kỳ màn hình
 * nào chạm tới stompjs. Nếu nạp muộn, lỗi sẽ hiện ra dưới dạng "Can't find variable:
 * TextDecoder" từ sâu trong thư viện, rất khó lần ngược.
 */
import '@bacons/text-decoder/install';

/**
 * Kiểm tra ngay lúc khởi động thay vì để vỡ giữa chừng.
 *
 * Nếu một bản React Native/Hermes tương lai bỏ TextEncoder, ta muốn thấy thông báo
 * nói rõ thiếu gì và sửa thế nào, chứ không phải một lỗi khó hiểu từ trong stompjs.
 */
export function kiemTraPolyfill(): { day_du: boolean; thieu: string[] } {
  const thieu: string[] = [];
  if (typeof globalThis.TextEncoder === 'undefined') thieu.push('TextEncoder');
  if (typeof globalThis.TextDecoder === 'undefined') thieu.push('TextDecoder');

  if (thieu.length > 0) {
    console.error(
      `[chat] Thiếu ${thieu.join(', ')} — chat realtime sẽ không hoạt động.\n` +
        'Cách sửa: cài thêm polyfill tương ứng và import ở src/lib/polyfills.ts.',
    );
  }
  return { day_du: thieu.length === 0, thieu };
}
