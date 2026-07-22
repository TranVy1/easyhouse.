'use client';

import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { useSession } from 'next-auth/react';
import { chatSocket, type ChatSocketState } from '@/lib/ws-client';
import { baoCanDemLaiChuaDoc } from '@/hooks/use-chua-doc-tin-nhan';
import type {
  CuocTroChuyen,
  LienKetChat,
  NguoiLienHe,
  SuKienTrangThaiChat,
  TepDinhKem,
  TinNhan,
} from '@/types';

/**
 * Toàn bộ logic client của chat.
 *
 * Nguyên tắc: DB là nguồn sự thật duy nhất, WebSocket chỉ là đường đẩy.
 * Vì vậy có 3 lớp chống mất tin:
 *   1. mọi tin đều có soThuTu do server cấp
 *   2. nhận tin có soThuTu nhảy cóc  => tự gọi REST delta bù phần đã lỡ
 *   3. mỗi lần (re)connect WebSocket => luôn gọi delta trước khi tin vào luồng realtime
 */

const API = '/api/tin-nhan';

/**
 * Lấy id người dùng từ claim `sub` của access token.
 *
 * KHÔNG được dùng `session.user.id`: với luồng đăng nhập khách thuê, backend trả
 * về KhachThueResponse nên `session.user.id` là **khach_thue.id**, còn tin nhắn
 * thì luôn gắn theo **nguoi_dung.id**. Lấy nhầm thì tin của chính mình sẽ hiển
 * thị như tin của người khác (lệch trái, có tên người gửi).
 *
 * Claim `sub` là nguoi_dung.id ở cả hai luồng đăng nhập (AuthService.login và
 * AuthService.loginKhachThue đều gọi generateAccessToken(user.getId(), ...)).
 *
 * Đây chỉ là giải mã để biết mình là ai, KHÔNG phải xác thực — server vẫn tự
 * kiểm tra chữ ký trên từng request.
 */
function docNguoiDungIdTuToken(token?: string): string | undefined {
  if (!token) return undefined;
  try {
    const phanThan = token.split('.')[1];
    if (!phanThan) return undefined;
    const base64 = phanThan.replace(/-/g, '+').replace(/_/g, '/');
    const dem = atob(base64.padEnd(Math.ceil(base64.length / 4) * 4, '='));
    const bytes = Uint8Array.from(dem, (c) => c.charCodeAt(0));
    return JSON.parse(new TextDecoder().decode(bytes))?.sub;
  } catch {
    return undefined;
  }
}

export function useChat() {
  const { data: session } = useSession();
  const token = session?.accessToken as string | undefined;
  const nguoiDungId = useMemo(() => docNguoiDungIdTuToken(token), [token]);

  const [hoiThoais, setHoiThoais] = useState<CuocTroChuyen[]>([]);
  const [idDangMo, setIdDangMo] = useState<string | null>(null);
  /**
   * Chỉ dùng trong khoảnh khắc hội thoại vừa được tạo mà danh sách chưa kịp tải lại.
   * Ngoài lúc đó, `hoiThoais` là nguồn sự thật duy nhất.
   */
  const [hoiThoaiDuPhong, setHoiThoaiDuPhong] = useState<CuocTroChuyen | null>(null);
  const [tinNhans, setTinNhans] = useState<TinNhan[]>([]);
  const [dangTai, setDangTai] = useState(false);
  const [dangTaiThem, setDangTaiThem] = useState(false);
  const [conTinCu, setConTinCu] = useState(true);
  const [trangThaiKetNoi, setTrangThaiKetNoi] = useState<ChatSocketState>('idle');
  const [aiDangGo, setAiDangGo] = useState<string[]>([]);
  const [loi, setLoi] = useState<string | null>(null);

  /** Đang xem kho lưu trữ hay danh sách thường (P8). */
  const [xemLuuTru, setXemLuuTru] = useState(false);
  /** Tin đã ghim của hội thoại đang mở — hiển thị ở băng đầu khung chat (P8). */
  const [tinGhims, setTinGhims] = useState<TinNhan[]>([]);

  // Dùng ref cho những giá trị mà callback của WebSocket cần đọc: handler được
  // đăng ký một lần, nếu đọc qua state sẽ luôn thấy giá trị cũ.
  const hoiThoaiDangMoRef = useRef<string | null>(null);
  const seqCuoiRef = useRef<number>(0);
  const xemLuuTruRef = useRef(false);

  /**
   * Hội thoại đang mở là DẪN XUẤT từ `hoiThoais`, không phải state riêng.
   *
   * Trước đây đây là một state độc lập, dẫn tới lỗi: bấm ghim thì `hoiThoais`
   * được cập nhật nhưng `hoiThoaiDangMo` giữ nguyên, nên nút trên header không
   * đổi màu dù DB đã lưu đúng. Hai nguồn dữ liệu cho cùng một sự thật thì sớm
   * muộn cũng lệch — bỏ hẳn cái thứ hai là cách sửa triệt để.
   */
  const hoiThoaiDangMo = useMemo(() => {
    if (!idDangMo) return null;
    return (
      hoiThoais.find((h) => h._id === idDangMo) ??
      (hoiThoaiDuPhong?._id === idDangMo ? hoiThoaiDuPhong : null)
    );
  }, [hoiThoais, idDangMo, hoiThoaiDuPhong]);

  const goi = useCallback(
    async (duongDan: string, init?: RequestInit) => {
      const res = await fetch(`${API}${duongDan}`, {
        ...init,
        headers: {
          'Content-Type': 'application/json',
          ...(token ? { Authorization: `Bearer ${token}` } : {}),
          ...(init?.headers ?? {}),
        },
      });
      const json = await res.json().catch(() => ({}));
      if (!res.ok) {
        throw new Error(json?.message || `Lỗi ${res.status}`);
      }
      return json?.data;
    },
    [token],
  );

  // ── Danh sách hội thoại ──────────────────────────────────────────────────

  const taiDanhSach = useCallback(async () => {
    if (!token) return;
    try {
      const data = await goi(`/hoi-thoai?page=1&limit=50&luuTru=${xemLuuTruRef.current}`);
      setHoiThoais(data?.data ?? []);
    } catch (e) {
      setLoi(e instanceof Error ? e.message : 'Không tải được danh sách');
    }
  }, [goi, token]);

  /**
   * Chuyển giữa danh sách thường và kho lưu trữ.
   *
   * Dùng ref song song với state vì `taiDanhSach` được gọi từ nhiều nơi (kể cả
   * trong handler WebSocket) mà không muốn nó phải phụ thuộc vào state — thêm
   * dependency vào đó sẽ tạo lại callback liên tục và huỷ/đăng ký lại subscription.
   */
  const doiCheDoLuuTru = useCallback(
    async (xem: boolean) => {
      xemLuuTruRef.current = xem;
      setXemLuuTru(xem);
      // Đóng hội thoại đang mở: nó có thể không thuộc danh sách mới.
      setIdDangMo(null);
      hoiThoaiDangMoRef.current = null;
      await taiDanhSach();
    },
    [taiDanhSach],
  );

  // ── Tin nhắn ─────────────────────────────────────────────────────────────

  /**
   * Tải băng tin đã ghim của hội thoại đang mở (P8).
   * Khai báo sớm vì `moHoiThoai` bên dưới cần dùng.
   */
  const taiTinGhim = useCallback(
    async (hoiThoaiId: string) => {
      try {
        setTinGhims((await goi(`/hoi-thoai/${hoiThoaiId}/ghim`)) ?? []);
      } catch {
        // Băng ghim là phụ trợ: hỏng thì để trống chứ không chặn cả khung chat.
        setTinGhims([]);
      }
    },
    [goi],
  );

  const capNhatDanhSachTin = useCallback((tinMoi: TinNhan[]) => {
    if (tinMoi.length === 0) return;
    setTinNhans((truoc) => {
      const theoId = new Map(truoc.map((t) => [t._id, t]));
      for (const tin of tinMoi) {
        // Xoá bản optimistic tương ứng (khớp theo maClient) trước khi chèn bản thật.
        if (tin.maClient) {
          for (const [id, cu] of theoId) {
            if (cu.dangGui && cu.maClient === tin.maClient) theoId.delete(id);
          }
        }
        theoId.set(tin._id, tin);
      }
      return [...theoId.values()].sort((a, b) => (a.soThuTu ?? 0) - (b.soThuTu ?? 0));
    });
    const seqLonNhat = Math.max(...tinMoi.map((t) => t.soThuTu ?? 0));
    if (seqLonNhat > seqCuoiRef.current) seqCuoiRef.current = seqLonNhat;
  }, []);

  /** Lấy phần đã lỡ kể từ mốc đang giữ. Dùng khi nối lại và khi phát hiện nhảy số. */
  const buPhanDaLo = useCallback(
    async (hoiThoaiId: string) => {
      try {
        const data: TinNhan[] = await goi(
          `/hoi-thoai/${hoiThoaiId}/tin-nhan/moi?sau=${seqCuoiRef.current}&limit=100`,
        );
        capNhatDanhSachTin(data ?? []);
      } catch {
        /* Nối lại lần sau sẽ bù tiếp — không cần làm phiền người dùng. */
      }
    },
    [goi, capNhatDanhSachTin],
  );

  const moHoiThoai = useCallback(
    async (hoiThoai: CuocTroChuyen) => {
      setHoiThoaiDuPhong(hoiThoai);
      setIdDangMo(hoiThoai._id);
      hoiThoaiDangMoRef.current = hoiThoai._id;
      seqCuoiRef.current = 0;
      setTinNhans([]);
      setConTinCu(true);
      setAiDangGo([]);
      setTinGhims([]);
      setDangTai(true);
      try {
        const data: TinNhan[] = await goi(`/hoi-thoai/${hoiThoai._id}/tin-nhan?limit=30`);
        capNhatDanhSachTin(data ?? []);
        setConTinCu((data ?? []).length === 30);
      } catch (e) {
        setLoi(e instanceof Error ? e.message : 'Không tải được tin nhắn');
      } finally {
        setDangTai(false);
      }
      // Băng ghim tải sau, song song — không để nó làm chậm việc hiện tin nhắn.
      void taiTinGhim(hoiThoai._id);
    },
    [goi, capNhatDanhSachTin, taiTinGhim],
  );

  /**
   * Mở hội thoại và nạp đúng vùng quanh một tin cụ thể — dùng khi bấm vào kết quả
   * tìm kiếm.
   *
   * Dùng `?truoc=<seq+1>` nên tin cần tìm nằm ở CUỐI trang vừa nạp, chắc chắn
   * nhìn thấy. Không cần thêm endpoint mới.
   */
  const moTaiTin = useCallback(
    async (hoiThoaiId: string, soThuTu: number) => {
      const hoiThoai: CuocTroChuyen =
        hoiThoais.find((h) => h._id === hoiThoaiId) ?? (await goi(`/hoi-thoai/${hoiThoaiId}`));

      setHoiThoaiDuPhong(hoiThoai);
      setIdDangMo(hoiThoaiId);
      hoiThoaiDangMoRef.current = hoiThoaiId;
      seqCuoiRef.current = 0;
      setTinNhans([]);
      setConTinCu(true);
      setDangTai(true);
      try {
        const data: TinNhan[] = await goi(
          `/hoi-thoai/${hoiThoaiId}/tin-nhan?truoc=${soThuTu + 1}&limit=30`,
        );
        capNhatDanhSachTin(data ?? []);
      } catch (e) {
        setLoi(e instanceof Error ? e.message : 'Không mở được tin nhắn');
      } finally {
        setDangTai(false);
      }
    },
    [goi, hoiThoais, capNhatDanhSachTin],
  );

  const taiThemTinCu = useCallback(async () => {
    const hoiThoaiId = hoiThoaiDangMoRef.current;
    if (!hoiThoaiId || dangTaiThem || !conTinCu || tinNhans.length === 0) return;
    setDangTaiThem(true);
    try {
      const cuNhat = tinNhans[0].soThuTu;
      const data: TinNhan[] = await goi(
        `/hoi-thoai/${hoiThoaiId}/tin-nhan?truoc=${cuNhat}&limit=30`,
      );
      if (!data || data.length === 0) {
        setConTinCu(false);
      } else {
        // Chèn tin cũ vào đầu; KHÔNG đụng seqCuoiRef vì mốc đó là cận trên.
        setTinNhans((truoc) => {
          const theoId = new Map([...data, ...truoc].map((t) => [t._id, t]));
          return [...theoId.values()].sort((a, b) => (a.soThuTu ?? 0) - (b.soThuTu ?? 0));
        });
        setConTinCu(data.length === 30);
      }
    } finally {
      setDangTaiThem(false);
    }
  }, [goi, tinNhans, dangTaiThem, conTinCu]);

  // ── Gửi tin ──────────────────────────────────────────────────────────────

  /**
   * Tải tệp lên trước, gửi tin sau.
   *
   * Tách hai bước để người dùng thấy ngay ảnh xem trước trong khi còn đang gõ,
   * và khi gửi lỗi thì không phải tải lại tệp.
   */
  const taiTepLen = useCallback(
    async (tep: File): Promise<TepDinhKem> => {
      const hoiThoaiId = hoiThoaiDangMoRef.current;
      if (!hoiThoaiId) throw new Error('Chưa mở cuộc trò chuyện');

      const form = new FormData();
      form.append('file', tep);

      // KHÔNG đặt Content-Type: trình duyệt phải tự sinh kèm boundary của multipart.
      const res = await fetch(`${API}/hoi-thoai/${hoiThoaiId}/tep`, {
        method: 'POST',
        headers: token ? { Authorization: `Bearer ${token}` } : {},
        body: form,
      });
      const json = await res.json().catch(() => ({}));
      if (!res.ok) throw new Error(json?.message || 'Tải tệp thất bại');
      return json.data as TepDinhKem;
    },
    [token],
  );

  /**
   * Đổi ảnh đại diện nhóm.
   *
   * Tải ảnh lên qua đúng đường đã có cho tệp đính kèm rồi gắn URL vào nhóm — không
   * làm đường upload thứ hai. Server tự phát tin hệ thống "đã đổi ảnh nhóm".
   *
   * Chỉ áp cho NHÓM: chat 1-1 dùng ảnh đại diện của đối phương, không ai được sửa.
   */
  const doiAnhNhom = useCallback(
    async (hoiThoaiId: string, tep: File) => {
      try {
        const daTai = await taiTepLen(tep);
        if (!daTai?.url) throw new Error('Không lấy được đường dẫn ảnh');
        await goi(`/hoi-thoai/${hoiThoaiId}`, {
          method: 'PATCH',
          body: JSON.stringify({ anh: daTai.url }),
        });
        await taiDanhSach();
      } catch (e) {
        setLoi(e instanceof Error ? e.message : 'Không đổi được ảnh nhóm');
      }
    },
    [goi, taiTepLen, taiDanhSach],
  );

  const guiTin = useCallback(
    async (noiDung: string, tep?: TepDinhKem | null, traLoiChoId?: string) => {
      const hoiThoaiId = hoiThoaiDangMoRef.current;
      if (!hoiThoaiId || (!noiDung.trim() && !tep)) return;

      const maClient =
        typeof crypto !== 'undefined' && crypto.randomUUID
          ? crypto.randomUUID()
          : `${Date.now()}-${Math.random()}`;

      const loai = (tep?.loaiTinNhan as TinNhan['loai']) ?? 'TEXT';

      // Optimistic: hiện ngay, đối chiếu lại khi server trả về (khớp theo maClient).
      const tamThoi: TinNhan = {
        _id: `tam-${maClient}`,
        soThuTu: Number.MAX_SAFE_INTEGER,
        cuocTroChuyenId: hoiThoaiId,
        nguoiGuiId: nguoiDungId,
        loai,
        noiDung,
        fileUrl: tep?.url,
        traLoiChoId,
        maClient,
        ngayTao: new Date().toISOString(),
        dangGui: true,
      };
      setTinNhans((truoc) => [...truoc, tamThoi]);

      try {
        const daGui: TinNhan = await goi(`/hoi-thoai/${hoiThoaiId}/tin-nhan`, {
          method: 'POST',
          body: JSON.stringify({
            noiDung,
            loai,
            maClient,
            fileMediaId: tep?._id,
            traLoiChoId,
          }),
        });
        capNhatDanhSachTin([daGui]);
        taiDanhSach();
      } catch (e) {
        // Giữ lại tin và đánh dấu lỗi thay vì xoá đi — người dùng còn thấy nội dung
        // mình vừa gõ. Gửi lại cùng maClient sẽ không tạo tin trùng.
        setTinNhans((truoc) =>
          truoc.map((t) => (t.maClient === maClient ? { ...t, dangGui: false, loiGui: true } : t)),
        );
        setLoi(e instanceof Error ? e.message : 'Gửi tin thất bại');
      }
    },
    [goi, nguoiDungId, capNhatDanhSachTin, taiDanhSach],
  );

  const danhDauDaDoc = useCallback(
    async (denSeq: number) => {
      const hoiThoaiId = hoiThoaiDangMoRef.current;
      if (!hoiThoaiId || !denSeq || denSeq === Number.MAX_SAFE_INTEGER) return;
      try {
        await goi(`/hoi-thoai/${hoiThoaiId}/da-doc`, {
          method: 'POST',
          body: JSON.stringify({ denSeq }),
        });
        setHoiThoais((truoc) =>
          truoc.map((h) => (h._id === hoiThoaiId ? { ...h, soTinChuaDoc: 0 } : h)),
        );
        // Badge ở thanh điều hướng nằm trong CÂY COMPONENT KHÁC (layout), nó không
        // thấy được state ở đây. Không báo thì người dùng đọc xong mà badge vẫn
        // đứng nguyên tới vòng polling sau — trông y như hỏng.
        baoCanDemLaiChuaDoc();
      } catch {
        /* Không quan trọng tới mức phải báo lỗi cho người dùng. */
      }
    },
    [goi],
  );

  /** Thu hồi tin của chính mình. Server xoá hẳn nội dung chứ không chỉ ẩn đi. */
  const thuHoi = useCallback(
    async (tinNhanId: string) => {
      try {
        const daThuHoi: TinNhan = await goi(`/${tinNhanId}/thu-hoi`, { method: 'POST' });
        // Server đẩy bản cập nhật qua WebSocket cho mọi người, kể cả mình. Cập nhật
        // tại chỗ ở đây để người bấm thấy phản hồi ngay, không chờ vòng WebSocket.
        setTinNhans((truoc) => truoc.map((t) => (t._id === daThuHoi._id ? daThuHoi : t)));
        taiDanhSach();
      } catch (e) {
        setLoi(e instanceof Error ? e.message : 'Thu hồi thất bại');
      }
    },
    [goi, taiDanhSach],
  );

  // ── Ghim tin, chuyển tiếp, chi tiết (P8) ─────────────────────────────────

  /**
   * Ghim / bỏ ghim một TIN NHẮN — khác hẳn ghim HỘI THOẠI ở `capNhatTuyChon`.
   * Phạm vi cả hội thoại: mọi thành viên đều thấy.
   */
  const datGhimTin = useCallback(
    async (tinNhanId: string, ghim: boolean) => {
      const hoiThoaiId = hoiThoaiDangMoRef.current;
      try {
        const daDoi: TinNhan = await goi(`/${tinNhanId}/ghim`, {
          method: ghim ? 'POST' : 'DELETE',
        });
        setTinNhans((truoc) => truoc.map((t) => (t._id === daDoi._id ? { ...t, ...daDoi } : t)));
        if (hoiThoaiId) await taiTinGhim(hoiThoaiId);
      } catch (e) {
        setLoi(e instanceof Error ? e.message : 'Không ghim được tin nhắn');
      }
    },
    [goi, taiTinGhim],
  );

  /** Chuyển tiếp sang một hoặc nhiều hội thoại khác. */
  const chuyenTiep = useCallback(
    async (tinNhanId: string, hoiThoaiIds: string[]) => {
      try {
        await goi(`/${tinNhanId}/chuyen-tiep`, {
          method: 'POST',
          body: JSON.stringify({ hoiThoaiIds }),
        });
        await taiDanhSach();
        return true;
      } catch (e) {
        setLoi(e instanceof Error ? e.message : 'Chuyển tiếp thất bại');
        return false;
      }
    },
    [goi, taiDanhSach],
  );

  /** Ai đã xem tin này, ai chưa. */
  const chiTietTin = useCallback(
    async (tinNhanId: string) => {
      try {
        return await goi(`/${tinNhanId}/chi-tiet`);
      } catch (e) {
        setLoi(e instanceof Error ? e.message : 'Không xem được chi tiết');
        return null;
      }
    },
    [goi],
  );

  /**
   * Xoá cuộc trò chuyện — chỉ xoá bản của mình, người kia vẫn giữ nguyên.
   * Có tin mới thì hội thoại sẽ hiện lại nhưng trống.
   */
  const xoaHoiThoai = useCallback(
    async (hoiThoaiId: string) => {
      try {
        await goi(`/hoi-thoai/${hoiThoaiId}`, { method: 'DELETE' });
        if (hoiThoaiDangMoRef.current === hoiThoaiId) {
          setIdDangMo(null);
          hoiThoaiDangMoRef.current = null;
          setTinNhans([]);
        }
        await taiDanhSach();
        // Xoá bản của mình cũng kéo mốc đã đọc lên hết, nên số chưa đọc đổi theo.
        baoCanDemLaiChuaDoc();
      } catch (e) {
        setLoi(e instanceof Error ? e.message : 'Không xoá được');
      }
    },
    [goi, taiDanhSach],
  );

  /** Ghim / tắt thông báo — tuỳ chọn riêng của mình, không ảnh hưởng ai khác. */
  const capNhatTuyChon = useCallback(
    async (
      hoiThoaiId: string,
      tuyChon: {
        ghim?: boolean;
        tatThongBao?: boolean;
        tatThongBaoPhut?: number;
        luuTru?: boolean;
      },
    ) => {
      // Cập nhật lạc quan để nút phản hồi tức thì, rồi tải lại để lấy đúng thứ tự sắp xếp.
      setHoiThoais((truoc) =>
        truoc.map((h) => (h._id === hoiThoaiId ? { ...h, ...tuyChon } : h)),
      );
      try {
        await goi(`/hoi-thoai/${hoiThoaiId}/tuy-chon`, {
          method: 'PATCH',
          body: JSON.stringify(tuyChon),
        });
        await taiDanhSach();
      } catch (e) {
        setLoi(e instanceof Error ? e.message : 'Không cập nhật được');
        taiDanhSach();
      }
    },
    [goi, taiDanhSach],
  );

  /**
   * Tìm theo NỘI DUNG tin nhắn (khác với ô lọc danh sách hội thoại theo tên).
   * Server tìm không phân biệt dấu, và chỉ trong hội thoại mình là thành viên.
   */
  const timKiemTinNhan = useCallback(
    async (tuKhoa: string): Promise<TinNhan[]> => {
      if (tuKhoa.trim().length < 2) return [];
      const data = await goi(`/tim-kiem?q=${encodeURIComponent(tuKhoa.trim())}&limit=30`);
      return data?.data ?? [];
    },
    [goi],
  );

  /**
   * Tìm trong RIÊNG một hội thoại — dùng cho ô tìm trong bảng thông tin.
   *
   * Cùng endpoint với tìm toàn cục, chỉ thêm hoiThoaiId để thu hẹp phạm vi. Không
   * lọc ở client vì như vậy sẽ bỏ sót những tin chưa được tải về.
   */
  const timTrongHoiThoai = useCallback(
    async (hoiThoaiId: string, tuKhoa: string): Promise<TinNhan[]> => {
      if (tuKhoa.trim().length < 2) return [];
      const data = await goi(
        `/tim-kiem?q=${encodeURIComponent(tuKhoa.trim())}&hoiThoaiId=${hoiThoaiId}&limit=30`,
      );
      return data?.data ?? [];
    },
    [goi],
  );

  // ── Bảng thông tin hội thoại ─────────────────────────────────────────────

  /** Ảnh hoặc tệp đã trao đổi — hai tab riêng vì cách hiển thị khác hẳn nhau. */
  const layTepDinhKem = useCallback(
    async (hoiThoaiId: string, loai: 'IMAGE' | 'FILE'): Promise<TinNhan[]> => {
      const data = await goi(`/hoi-thoai/${hoiThoaiId}/tep-dinh-kem?loai=${loai}&limit=60`);
      return data?.data ?? [];
    },
    [goi],
  );

  const layLienKet = useCallback(
    async (hoiThoaiId: string): Promise<LienKetChat[]> => {
      const data = await goi(`/hoi-thoai/${hoiThoaiId}/lien-ket?limit=60`);
      return data?.data ?? [];
    },
    [goi],
  );

  /**
   * Đặt/xoá biệt danh. Server trả về hội thoại đã cập nhật nên chỉ cần nạp lại
   * danh sách là mọi nơi hiển thị đúng.
   */
  const datBietDanh = useCallback(
    async (hoiThoaiId: string, nguoiDungIdDich: string, bietDanh: string) => {
      try {
        await goi(`/hoi-thoai/${hoiThoaiId}/thanh-vien/${nguoiDungIdDich}/biet-danh`, {
          method: 'PATCH',
          body: JSON.stringify({ bietDanh }),
        });
        await taiDanhSach();
      } catch (e) {
        setLoi(e instanceof Error ? e.message : 'Không đặt được biệt danh');
      }
    },
    [goi, taiDanhSach],
  );

  const baoDangGo = useCallback((dangGo: boolean) => {
    const hoiThoaiId = hoiThoaiDangMoRef.current;
    if (hoiThoaiId) chatSocket.baoDangGo(hoiThoaiId, dangGo);
  }, []);

  // ── Mở hội thoại mới ─────────────────────────────────────────────────────

  const moChatVoi = useCallback(
    async (nguoiDungIdDich: string) => {
      const hoiThoai: CuocTroChuyen = await goi('/hoi-thoai/truc-tiep', {
        method: 'POST',
        body: JSON.stringify({ nguoiDungId: nguoiDungIdDich }),
      });
      await taiDanhSach();
      await moHoiThoai(hoiThoai);
      return hoiThoai;
    },
    [goi, taiDanhSach, moHoiThoai],
  );

  /** Tạo nhóm tự chọn người — dùng cho mượn đồ, trao đổi trong khu trọ. */
  const taoNhom = useCallback(
    async (ten: string, thanhVienIds: string[]) => {
      const nhom: CuocTroChuyen = await goi('/hoi-thoai', {
        method: 'POST',
        body: JSON.stringify({ ten, thanhVienIds }),
      });
      await taiDanhSach();
      await moHoiThoai(nhom);
      return nhom;
    },
    [goi, taiDanhSach, moHoiThoai],
  );

  const roiNhom = useCallback(
    async (hoiThoaiId: string) => {
      await goi(`/hoi-thoai/${hoiThoaiId}/roi`, { method: 'POST' });
      setIdDangMo(null);
      setHoiThoaiDuPhong(null);
      hoiThoaiDangMoRef.current = null;
      setTinNhans([]);
      await taiDanhSach();
    },
    [goi, taiDanhSach],
  );

  const moKenhHoTro = useCallback(async () => {
    const hoiThoai: CuocTroChuyen = await goi('/hoi-thoai/ho-tro', { method: 'POST' });
    await taiDanhSach();
    await moHoiThoai(hoiThoai);
    return hoiThoai;
  }, [goi, taiDanhSach, moHoiThoai]);

  const layDanhBa = useCallback(
    async (tuKhoa?: string): Promise<NguoiLienHe[]> => {
      const q = tuKhoa ? `?q=${encodeURIComponent(tuKhoa)}` : '';
      return (await goi(`/nguoi-lien-he${q}`)) ?? [];
    },
    [goi],
  );

  // ── Vòng đời WebSocket ───────────────────────────────────────────────────

  useEffect(() => {
    if (!token) return;
    chatSocket.connect();

    const boTinNhan = chatSocket.onTinNhan((payload) => {
      const tin = payload as TinNhan;

      if (tin.cuocTroChuyenId !== hoiThoaiDangMoRef.current) {
        taiDanhSach(); // hội thoại khác: chỉ cần cập nhật preview và số chưa đọc
        baoCanDemLaiChuaDoc(); // badge phải nhích lên ngay, không chờ vòng polling
        return;
      }

      // Nhảy số thứ tự nghĩa là đã lỡ mất tin ở giữa (frame rớt, mạng chập chờn).
      // Gọi delta bù thay vì hiển thị một cuộc hội thoại thủng lỗ chỗ.
      if (seqCuoiRef.current > 0 && tin.soThuTu > seqCuoiRef.current + 1) {
        buPhanDaLo(tin.cuocTroChuyenId);
        return;
      }

      capNhatDanhSachTin([tin]);
      taiDanhSach();
    });

    const boTrangThai = chatSocket.onTrangThai((payload) => {
      const sk = payload as SuKienTrangThaiChat;
      if (sk.cuocTroChuyenId !== hoiThoaiDangMoRef.current) return;

      if (sk.loai === 'DANG_GO') {
        setAiDangGo((truoc) => (truoc.includes(sk.nguoiDungId) ? truoc : [...truoc, sk.nguoiDungId]));
        // Tự tắt sau 4s phòng khi frame DUNG_GO bị rớt.
        setTimeout(() => setAiDangGo((truoc) => truoc.filter((id) => id !== sk.nguoiDungId)), 4000);
      } else if (sk.loai === 'DUNG_GO') {
        setAiDangGo((truoc) => truoc.filter((id) => id !== sk.nguoiDungId));
      } else if (sk.loai === 'DA_DOC') {
        // Cập nhật vào `hoiThoais` (nguồn sự thật) chứ không vào một state riêng —
        // `hoiThoaiDangMo` là dẫn xuất nên tự cập nhật theo.
        const capNhatMoc = (h: CuocTroChuyen): CuocTroChuyen => ({
          ...h,
          thanhVien: h.thanhVien?.map((tv) =>
            tv._id === sk.nguoiDungId ? { ...tv, docDenSeq: sk.denSeq } : tv,
          ),
        });
        setHoiThoais((truoc) =>
          truoc.map((h) => (h._id === sk.cuocTroChuyenId ? capNhatMoc(h) : h)),
        );
        setHoiThoaiDuPhong((truoc) =>
          truoc && truoc._id === sk.cuocTroChuyenId ? capNhatMoc(truoc) : truoc,
        );
      }
    });

    const boState = chatSocket.onStateChange((s) => {
      setTrangThaiKetNoi(s);
      // Mỗi lần nối lại: bù phần đã lỡ TRƯỚC khi tin vào luồng realtime.
      if (s === 'connected') {
        taiDanhSach();
        const dangMo = hoiThoaiDangMoRef.current;
        if (dangMo && seqCuoiRef.current > 0) buPhanDaLo(dangMo);
      }
    });

    return () => {
      boTinNhan();
      boTrangThai();
      boState();
    };
  }, [token, taiDanhSach, buPhanDaLo, capNhatDanhSachTin]);

  useEffect(() => {
    taiDanhSach();
  }, [taiDanhSach]);

  return {
    hoiThoais,
    hoiThoaiDangMo,
    tinNhans,
    dangTai,
    dangTaiThem,
    conTinCu,
    trangThaiKetNoi,
    aiDangGo,
    loi,
    nguoiDungId,
    moHoiThoai,
    moTaiTin,
    taiThemTinCu,
    guiTin,
    taiTepLen,
    thuHoi,
    capNhatTuyChon,
    timKiemTinNhan,
    timTrongHoiThoai,
    layTepDinhKem,
    layLienKet,
    datBietDanh,
    danhDauDaDoc,
    baoDangGo,
    moChatVoi,
    moKenhHoTro,
    taoNhom,
    roiNhom,
    layDanhBa,
    taiDanhSach,
    doiAnhNhom,
    // P8
    tinGhims,
    datGhimTin,
    chuyenTiep,
    chiTietTin,
    xoaHoiThoai,
    xemLuuTru,
    doiCheDoLuuTru,
    xoaLoi: () => setLoi(null),
  };
}
