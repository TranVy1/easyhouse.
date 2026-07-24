'use client';

import { useCallback, useEffect, useState } from 'react';
import { useSession } from 'next-auth/react';

/**
 * Đăng ký nhận thông báo đẩy trên trình duyệt (Web Push).
 *
 * Bốn trạng thái cần phân biệt rõ, vì mỗi cái cần một cách xử lý khác nhau ở UI:
 *   khong-ho-tro : trình duyệt không có Push API (Safari cũ, chế độ ẩn danh…)
 *   chua-bat     : server chưa cấu hình khoá VAPID → ẩn hẳn nút đi
 *   bi-tu-choi   : người dùng đã từ chối → KHÔNG hỏi lại được nữa, phải hướng dẫn
 *                  họ tự bật trong cài đặt trình duyệt
 *   san-sang     : hỏi được
 */
export type TrangThaiPush = 'dang-kiem-tra' | 'khong-ho-tro' | 'chua-bat' | 'bi-tu-choi' | 'san-sang' | 'da-dang-ky';

/**
 * Khoá VAPID từ server ở dạng base64url, Push API lại đòi BufferSource.
 *
 * Trả về ArrayBuffer chứ không phải Uint8Array: TypeScript 5.7 trở đi phân biệt
 * `Uint8Array<ArrayBufferLike>` với `BufferSource`, nên trả Uint8Array sẽ không
 * khớp kiểu của `applicationServerKey`.
 */
function base64UrlSangBytes(base64Url: string): ArrayBuffer {
  const dem = '='.repeat((4 - (base64Url.length % 4)) % 4);
  const base64 = (base64Url + dem).replace(/-/g, '+').replace(/_/g, '/');
  const chuoi = atob(base64);

  const bytes = new Uint8Array(new ArrayBuffer(chuoi.length));
  for (let i = 0; i < chuoi.length; i++) bytes[i] = chuoi.charCodeAt(i);
  return bytes.buffer;
}

export function useThongBaoDay() {
  const { data: session } = useSession();
  const token = session?.accessToken as string | undefined;
  const [trangThai, setTrangThai] = useState<TrangThaiPush>('dang-kiem-tra');

  const goi = useCallback(
    async (duongDan: string, init?: RequestInit) => {
      const res = await fetch(`/api/thong-bao-day${duongDan}`, {
        ...init,
        headers: {
          'Content-Type': 'application/json',
          ...(token ? { Authorization: `Bearer ${token}` } : {}),
          ...(init?.headers ?? {}),
        },
      });
      const json = await res.json().catch(() => ({}));
      if (!res.ok) throw new Error(json?.message || `Lỗi ${res.status}`);
      return json?.data;
    },
    [token],
  );

  useEffect(() => {
    if (!token) return;

    const kiemTra = async () => {
      if (typeof window === 'undefined' || !('serviceWorker' in navigator) || !('PushManager' in window)) {
        setTrangThai('khong-ho-tro');
        return;
      }
      try {
        const { khoaCong } = await goi('/khoa-cong');
        if (!khoaCong) {
          setTrangThai('chua-bat'); // server chưa cấu hình VAPID
          return;
        }
        if (Notification.permission === 'denied') {
          setTrangThai('bi-tu-choi');
          return;
        }
        const dangKy = await navigator.serviceWorker.getRegistration();
        const daCo = await dangKy?.pushManager.getSubscription();
        setTrangThai(daCo ? 'da-dang-ky' : 'san-sang');
      } catch {
        setTrangThai('chua-bat');
      }
    };
    kiemTra();
  }, [token, goi]);

  const bat = useCallback(async () => {
    const { khoaCong } = await goi('/khoa-cong');
    if (!khoaCong) throw new Error('Máy chủ chưa bật thông báo đẩy');

    const quyen = await Notification.requestPermission();
    if (quyen !== 'granted') {
      setTrangThai(quyen === 'denied' ? 'bi-tu-choi' : 'san-sang');
      return;
    }

    const dangKySW = await navigator.serviceWorker.register('/sw.js');
    await navigator.serviceWorker.ready;

    const sub = await dangKySW.pushManager.subscribe({
      // Bắt buộc true: trình duyệt không cho gửi push âm thầm, mọi push phải
      // hiển thị cho người dùng thấy.
      userVisibleOnly: true,
      applicationServerKey: base64UrlSangBytes(khoaCong),
    });

    const json = sub.toJSON();
    await goi('/dang-ky', {
      method: 'POST',
      body: JSON.stringify({
        nenTang: 'WEB',
        endpoint: sub.endpoint,
        khoaP256dh: json.keys?.p256dh,
        khoaAuth: json.keys?.auth,
        moTaThietBi: navigator.userAgent.slice(0, 200),
      }),
    });
    setTrangThai('da-dang-ky');
  }, [goi]);

  const tat = useCallback(async () => {
    const dangKy = await navigator.serviceWorker.getRegistration();
    const sub = await dangKy?.pushManager.getSubscription();
    if (!sub) {
      setTrangThai('san-sang');
      return;
    }
    // Huỷ ở server TRƯỚC: nếu huỷ ở trình duyệt trước rồi server lỗi thì bản ghi
    // sẽ nằm lại vĩnh viễn và cứ gửi vào một endpoint đã chết.
    await goi('/huy-dang-ky', { method: 'POST', body: JSON.stringify({ endpoint: sub.endpoint }) });
    await sub.unsubscribe();
    setTrangThai('san-sang');
  }, [goi]);

  return { trangThai, bat, tat };
}
