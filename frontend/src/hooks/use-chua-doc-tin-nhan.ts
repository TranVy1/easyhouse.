'use client';

import { useEffect, useState } from 'react';
import { useSession } from 'next-auth/react';

/**
 * Số tin nhắn chưa đọc, dùng cho badge ở thanh điều hướng.
 *
 * Ở đây dùng polling thưa (60s) chứ không mở WebSocket: layout được mount trên
 * mọi trang, mà mở thêm một kết nối WebSocket chỉ để đếm badge là lãng phí.
 * Endpoint /chua-doc cố tình làm thật nhẹ (một truy vấn COUNT duy nhất).
 *
 * Nhưng polling một mình thì KHÔNG đủ: badge nằm ở layout còn việc đọc tin xảy ra
 * trong ChatPanel — hai cây component tách rời. Người dùng đọc xong mà badge vẫn
 * đứng nguyên tới 60 giây, trông như hỏng. Vì vậy có thêm kênh báo hiệu ở dưới.
 */
const CHU_KY_MS = 60_000;

/**
 * Những hook đang hiển thị badge. Dùng Set ở phạm vi module thay vì CustomEvent
 * trên `window`: an toàn khi render phía máy chủ, và giữ được kiểu chặt chẽ.
 * Nhẹ hơn nhiều so với kéo cả một thư viện quản lý trạng thái vào chỉ vì một con số.
 */
const nhungAiDangNghe = new Set<() => void>();

/**
 * Báo cho badge biết số chưa đọc có thể đã đổi — gọi sau khi đánh dấu đã đọc,
 * khi nhận tin mới qua WebSocket, hoặc khi xoá/lưu trữ hội thoại.
 *
 * Cố ý KHÔNG truyền con số vào: nguồn sự thật vẫn là server, ở đây chỉ nói
 * "đếm lại đi". Truyền số tự tính ở client sẽ lệch ngay khi có nhiều thiết bị.
 */
export function baoCanDemLaiChuaDoc() {
  for (const nghe of nhungAiDangNghe) nghe();
}

export function useChuaDocTinNhan() {
  const { data: session } = useSession();
  const token = session?.accessToken as string | undefined;
  const [soChuaDoc, setSoChuaDoc] = useState(0);

  useEffect(() => {
    if (!token) return;
    let huy = false;

    const dem = async (boQuaKiemTraHienThi = false) => {
      // Tab đang ẩn thì bỏ qua vòng đếm ĐỊNH KỲ — tránh tải vô ích khi người dùng
      // mở sẵn hàng chục tab.
      //
      // Nhưng lần đếm đầu tiên và các lần do kênh báo hiệu kích hoạt thì luôn chạy:
      //   - Mở trang bằng Ctrl+click vào tab nền: tab "ẩn" ngay từ đầu, chặn luôn
      //     thì badge đứng 0 cho tới khi người dùng bấm sang tab đó.
      //   - Kênh báo hiệu là hệ quả của thao tác người dùng vừa làm, phải phản ánh ngay.
      if (
        !boQuaKiemTraHienThi &&
        typeof document !== 'undefined' &&
        document.visibilityState !== 'visible'
      ) {
        return;
      }
      try {
        const res = await fetch('/api/tin-nhan/chua-doc', {
          headers: { Authorization: `Bearer ${token}` },
        });
        if (!res.ok) return;
        const json = await res.json();
        if (!huy) setSoChuaDoc(json?.data?.soTinChuaDoc ?? 0);
      } catch {
        /* Badge sai tạm thời không đáng để báo lỗi. */
      }
    };

    const demNgay = () => {
      void dem(true);
    };

    // Lần đầu đếm vô điều kiện (xem giải thích trong `dem`); chỉ vòng lặp định kỳ
    // mới nể trạng thái ẩn/hiện của tab.
    void dem(true);
    const timer = setInterval(() => void dem(), CHU_KY_MS);

    // Quay lại tab sau một lúc thì đếm lại ngay: vòng polling vừa rồi có thể đã
    // bị bỏ qua vì tab đang ẩn, chờ thêm 60 giây nữa là quá lâu.
    // Chỉ đếm khi tab HIỆN lại — sự kiện này bắn cả lúc tab bị ẩn đi.
    const khiDoiHienThi = () => {
      if (document.visibilityState === 'visible') demNgay();
    };

    nhungAiDangNghe.add(demNgay);
    document.addEventListener('visibilitychange', khiDoiHienThi);

    return () => {
      huy = true;
      clearInterval(timer);
      nhungAiDangNghe.delete(demNgay);
      document.removeEventListener('visibilitychange', khiDoiHienThi);
    };
  }, [token]);

  return soChuaDoc;
}
