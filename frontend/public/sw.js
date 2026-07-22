/**
 * Service worker cho thông báo đẩy (Web Push).
 *
 * Chạy tách khỏi trang, nên vẫn nhận được thông báo khi người dùng đã đóng tab —
 * đó chính là thứ mà WebSocket không làm được và là lý do tồn tại của P5.
 *
 * Đặt trong public/ để Next.js phục vụ ở gốc (/sw.js). Service worker chỉ điều
 * khiển được những đường dẫn NGANG HÀNG hoặc SÂU HƠN vị trí của nó, nên phải ở gốc.
 */

self.addEventListener('push', (event) => {
  if (!event.data) return;

  let du = {};
  try {
    du = event.data.json();
  } catch {
    du = { tieuDe: 'Tin nhắn mới', noiDung: event.data.text() };
  }

  event.waitUntil(
    self.registration.showNotification(du.tieuDe || 'Tin nhắn mới', {
      body: du.noiDung || '',
      icon: '/favicon.ico',
      badge: '/favicon.ico',
      // Gom thông báo cùng một hội thoại thành một: nhắn 10 tin không nên tạo
      // 10 thông báo xếp chồng trên màn hình.
      tag: du.hoiThoaiId || 'tin-nhan',
      renotify: true,
      data: { duongDan: du.duongDan || '/' },
    }),
  );
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const duongDan = event.notification.data?.duongDan || '/';

  event.waitUntil(
    // Nếu app đã mở sẵn ở tab nào đó thì chuyển sang tab đó thay vì mở tab mới —
    // mở thêm tab mỗi lần bấm thông báo là cách nhanh nhất làm người dùng khó chịu.
    self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then((danhSach) => {
      for (const client of danhSach) {
        if (client.url.includes(duongDan) && 'focus' in client) return client.focus();
      }
      return self.clients.openWindow(duongDan);
    }),
  );
});
