import { useCallback, useEffect, useRef, useState } from 'react';
import { api } from '@/api/client';
import { useAuth } from '@/auth/AuthContext';
import { chatSocket, type ChatSocketState } from '@/lib/ws-client';
import type { CuocTroChuyen, NguoiLienHe, SuKienTrangThaiChat, TinNhan } from '@/types';

/**
 * Logic chat cho mobile. Cùng nguyên tắc với bản web:
 * DB là nguồn sự thật, WebSocket chỉ là đường đẩy, và có 3 lớp chống mất tin —
 * số thứ tự do server cấp, phát hiện nhảy số thì gọi delta bù, mỗi lần nối lại
 * đều bù trước khi tin vào luồng realtime.
 *
 * Khác web: dùng `api` client sẵn có (đã tự refresh token khi 401) thay vì fetch trần.
 */

const API = '/api/tin-nhan';

export function useChat() {
  const { session } = useAuth();
  const token = session?.token;
  const nguoiDungId = session?.userId;

  const [hoiThoais, setHoiThoais] = useState<CuocTroChuyen[]>([]);
  const [hoiThoaiDangMo, setHoiThoaiDangMo] = useState<CuocTroChuyen | null>(null);
  const [tinNhans, setTinNhans] = useState<TinNhan[]>([]);
  const [dangTai, setDangTai] = useState(false);
  const [trangThaiKetNoi, setTrangThaiKetNoi] = useState<ChatSocketState>('idle');
  const [aiDangGo, setAiDangGo] = useState<string[]>([]);
  const [loi, setLoi] = useState<string | null>(null);

  // Handler WebSocket đăng ký một lần nên phải đọc qua ref, nếu không sẽ luôn
  // thấy giá trị cũ của state.
  const hoiThoaiDangMoRef = useRef<string | null>(null);
  const seqCuoiRef = useRef(0);

  // ── Danh sách ────────────────────────────────────────────────────────────

  const taiDanhSach = useCallback(async () => {
    if (!token) return;
    try {
      const data = await api.get<{ data: CuocTroChuyen[] }>(`${API}/hoi-thoai`, {
        page: 1,
        limit: 50,
      });
      setHoiThoais(data?.data ?? []);
    } catch (e) {
      setLoi(e instanceof Error ? e.message : 'Không tải được danh sách');
    }
  }, [token]);

  // ── Tin nhắn ─────────────────────────────────────────────────────────────

  const capNhatDanhSachTin = useCallback((tinMoi: TinNhan[]) => {
    if (tinMoi.length === 0) return;
    setTinNhans((truoc) => {
      const theoId = new Map(truoc.map((t) => [t._id, t]));
      for (const tin of tinMoi) {
        // Bỏ bản optimistic tương ứng trước khi chèn bản thật.
        if (tin.maClient) {
          for (const [id, cu] of theoId) {
            if (cu.dangGui && cu.maClient === tin.maClient) theoId.delete(id);
          }
        }
        theoId.set(tin._id, tin);
      }
      return [...theoId.values()].sort((a, b) => (a.soThuTu ?? 0) - (b.soThuTu ?? 0));
    });
    const lonNhat = Math.max(...tinMoi.map((t) => t.soThuTu ?? 0));
    if (lonNhat > seqCuoiRef.current) seqCuoiRef.current = lonNhat;
  }, []);

  const buPhanDaLo = useCallback(
    async (hoiThoaiId: string) => {
      try {
        const data = await api.get<TinNhan[]>(`${API}/hoi-thoai/${hoiThoaiId}/tin-nhan/moi`, {
          sau: seqCuoiRef.current,
          limit: 100,
        });
        capNhatDanhSachTin(data ?? []);
      } catch {
        /* Lần nối lại sau sẽ bù tiếp — không cần làm phiền người dùng. */
      }
    },
    [capNhatDanhSachTin],
  );

  const moHoiThoai = useCallback(
    async (hoiThoai: CuocTroChuyen) => {
      setHoiThoaiDangMo(hoiThoai);
      hoiThoaiDangMoRef.current = hoiThoai._id;
      seqCuoiRef.current = 0;
      setTinNhans([]);
      setAiDangGo([]);
      setDangTai(true);
      try {
        const data = await api.get<TinNhan[]>(`${API}/hoi-thoai/${hoiThoai._id}/tin-nhan`, {
          limit: 30,
        });
        capNhatDanhSachTin(data ?? []);
      } catch (e) {
        setLoi(e instanceof Error ? e.message : 'Không tải được tin nhắn');
      } finally {
        setDangTai(false);
      }
    },
    [capNhatDanhSachTin],
  );

  const dongHoiThoai = useCallback(() => {
    setHoiThoaiDangMo(null);
    hoiThoaiDangMoRef.current = null;
    setTinNhans([]);
    seqCuoiRef.current = 0;
  }, []);

  const guiTin = useCallback(
    async (noiDung: string) => {
      const hoiThoaiId = hoiThoaiDangMoRef.current;
      if (!hoiThoaiId || !noiDung.trim()) return;

      // Không dùng crypto.randomUUID: Hermes không đảm bảo có sẵn.
      const maClient = `${Date.now()}-${Math.random().toString(36).slice(2, 10)}`;

      const tamThoi: TinNhan = {
        _id: `tam-${maClient}`,
        soThuTu: Number.MAX_SAFE_INTEGER,
        cuocTroChuyenId: hoiThoaiId,
        nguoiGuiId: nguoiDungId,
        loai: 'TEXT',
        noiDung,
        maClient,
        ngayTao: new Date().toISOString(),
        dangGui: true,
      };
      setTinNhans((truoc) => [...truoc, tamThoi]);

      try {
        const daGui = await api.post<TinNhan>(`${API}/hoi-thoai/${hoiThoaiId}/tin-nhan`, {
          noiDung,
          loai: 'TEXT',
          maClient,
        });
        capNhatDanhSachTin([daGui]);
        taiDanhSach();
      } catch (e) {
        // Giữ lại tin và đánh dấu lỗi. Gửi lại cùng maClient sẽ không tạo tin trùng.
        setTinNhans((truoc) =>
          truoc.map((t) => (t.maClient === maClient ? { ...t, dangGui: false, loiGui: true } : t)),
        );
        setLoi(e instanceof Error ? e.message : 'Gửi tin thất bại');
      }
    },
    [nguoiDungId, capNhatDanhSachTin, taiDanhSach],
  );

  const danhDauDaDoc = useCallback(async (denSeq: number) => {
    const hoiThoaiId = hoiThoaiDangMoRef.current;
    if (!hoiThoaiId || !denSeq || denSeq === Number.MAX_SAFE_INTEGER) return;
    try {
      await api.post(`${API}/hoi-thoai/${hoiThoaiId}/da-doc`, { denSeq });
      setHoiThoais((truoc) =>
        truoc.map((h) => (h._id === hoiThoaiId ? { ...h, soTinChuaDoc: 0 } : h)),
      );
    } catch {
      /* Không đáng để báo lỗi cho người dùng. */
    }
  }, []);

  const baoDangGo = useCallback((dangGo: boolean) => {
    const id = hoiThoaiDangMoRef.current;
    if (id) chatSocket.baoDangGo(id, dangGo);
  }, []);

  const moChatVoi = useCallback(
    async (nguoiDungIdDich: string) => {
      const hoiThoai = await api.post<CuocTroChuyen>(`${API}/hoi-thoai/truc-tiep`, {
        nguoiDungId: nguoiDungIdDich,
      });
      await taiDanhSach();
      await moHoiThoai(hoiThoai);
      return hoiThoai;
    },
    [taiDanhSach, moHoiThoai],
  );

  const moKenhHoTro = useCallback(async () => {
    const hoiThoai = await api.post<CuocTroChuyen>(`${API}/hoi-thoai/ho-tro`, {});
    await taiDanhSach();
    await moHoiThoai(hoiThoai);
    return hoiThoai;
  }, [taiDanhSach, moHoiThoai]);

  const layDanhBa = useCallback(
    (tuKhoa?: string) =>
      api.get<NguoiLienHe[]>(`${API}/nguoi-lien-he`, tuKhoa ? { q: tuKhoa } : {}),
    [],
  );

  // ── Vòng đời WebSocket ───────────────────────────────────────────────────

  useEffect(() => {
    if (!token) {
      chatSocket.disconnect();
      return;
    }
    chatSocket.connect(token);

    const boTinNhan = chatSocket.onTinNhan((payload) => {
      const tin = payload as TinNhan;

      if (tin.cuocTroChuyenId !== hoiThoaiDangMoRef.current) {
        taiDanhSach();
        return;
      }
      // Nhảy số thứ tự = đã lỡ tin ở giữa. Gọi delta bù thay vì hiển thị thủng lỗ.
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
        setAiDangGo((t) => (t.includes(sk.nguoiDungId) ? t : [...t, sk.nguoiDungId]));
        setTimeout(() => setAiDangGo((t) => t.filter((id) => id !== sk.nguoiDungId)), 4000);
      } else if (sk.loai === 'DUNG_GO') {
        setAiDangGo((t) => t.filter((id) => id !== sk.nguoiDungId));
      }
    });

    const boState = chatSocket.onStateChange((s) => {
      setTrangThaiKetNoi(s);
      // Mỗi lần nối lại (kể cả khi quay ra từ background): bù trước, tin sau.
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
    trangThaiKetNoi,
    aiDangGo,
    loi,
    nguoiDungId,
    moHoiThoai,
    dongHoiThoai,
    guiTin,
    danhDauDaDoc,
    baoDangGo,
    moChatVoi,
    moKenhHoTro,
    layDanhBa,
    taiDanhSach,
    xoaLoi: () => setLoi(null),
  };
}
