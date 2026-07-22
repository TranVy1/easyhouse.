'use client';

import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
  AlertCircle,
  Archive,
  ArchiveRestore,
  BellOff,
  Check,
  ChevronDown,
  Forward,
  Headset,
  Info,
  Loader2,
  LogOut,
  MessageSquarePlus,
  MoreHorizontal,
  Paperclip,
  Pin,
  Reply,
  Search,
  Send,
  Trash2,
  Undo2,
  Users,
  Wifi,
  WifiOff,
  X,
} from 'lucide-react';
import { AnhDaiDien } from '@/components/chat/AnhDaiDien';
import { BangThongTin } from '@/components/chat/BangThongTin';
import { useChat } from '@/hooks/use-chat';
import { gioDayDu, gioPhut, nhanNgan, nhanPhanCach, viTriTrongCum, type ViTriTrongCum } from '@/lib/chat-time';
import type { ChiTietTinNhan, CuocTroChuyen, NguoiLienHe, TepDinhKem, TinNhan } from '@/types';

/**
 * Giao diện chat dùng chung cho cả cổng chủ nhà và cổng khách thuê.
 * Hai trang chỉ khác nhau ở việc có hiện nút "Liên hệ ban quản lý" hay không.
 */
export function ChatPanel({ hienNutHoTro = false }: { hienNutHoTro?: boolean }) {
  const {
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
    doiAnhNhom,
    doiTenNhom,
    // P8
    tinGhims,
    datGhimTin,
    chuyenTiep,
    chiTietTin,
    xoaHoiThoai,
    xemLuuTru,
    doiCheDoLuuTru,
    xoaLoi,
  } = useChat();

  const [noiDung, setNoiDung] = useState('');
  const [moDanhBa, setMoDanhBa] = useState(false);
  const [boLoc, setBoLoc] = useState('');
  const [tepDinhKem, setTepDinhKem] = useState<TepDinhKem | null>(null);
  const [dangTaiTep, setDangTaiTep] = useState(false);
  const [tinTraLoi, setTinTraLoi] = useState<TinNhan | null>(null);
  const [ketQuaTinNhan, setKetQuaTinNhan] = useState<TinNhan[]>([]);
  const [dangTimTin, setDangTimTin] = useState(false);
  const [moBangThongTin, setMoBangThongTin] = useState(false);
  // P8
  const [tinChuyenTiep, setTinChuyenTiep] = useState<TinNhan | null>(null);
  const [chiTiet, setChiTiet] = useState<ChiTietTinNhan | null>(null);
  const [tinNoiBat, setTinNoiBat] = useState<string | null>(null);
  const [oDay, setODay] = useState(true);
  const oChonTep = useRef<HTMLInputElement>(null);
  const oTimKiem = useRef<HTMLInputElement>(null);
  const cuoiDanhSach = useRef<HTMLDivElement>(null);
  const khungTin = useRef<HTMLDivElement>(null);
  const timerGo = useRef<ReturnType<typeof setTimeout> | null>(null);

  /** Coi như "đang ở đáy" khi còn cách dưới 120px — chừa chỗ cho sai số cuộn mượt. */
  const NGUONG_DAY = 120;

  /**
   * Cuộn xuống cuối khung tin.
   *
   * Cuộn mượt là thứ CÓ THỂ bị bỏ qua: tab chạy nền, webview nhúng, hoặc người
   * dùng bật "giảm chuyển động" thì `behavior:'smooth'` im lặng không làm gì.
   * "Bấm mũi tên mà không xuống đáy" là lỗi thấy ngay, nên sau một nhịp phải
   * kiểm lại và chốt cứng nếu quả thật không nhúc nhích.
   */
  const cuonXuongDay = useCallback((muot = true) => {
    const khung = khungTin.current;
    if (!khung) return;

    const truoc = khung.scrollTop;
    khung.scrollTo({ top: khung.scrollHeight, behavior: muot ? 'smooth' : 'auto' });

    if (!muot) return;
    setTimeout(() => {
      const conThieu = khung.scrollHeight - khung.scrollTop - khung.clientHeight;
      // Chỉ can thiệp khi cuộn mượt KHÔNG hề chạy — nếu nó đang chạy dở thì
      // scrollTop đã khác `truoc`, đừng giật ngang giữa chừng.
      if (khung.scrollTop === truoc && conThieu > 8) {
        khung.scrollTop = khung.scrollHeight;
      }
    }, 300);
  }, []);

  /**
   * Chỉ tự cuộn khi người dùng ĐANG ở đáy.
   *
   * Trước đây cuộn vô điều kiện theo `tinNhans.length`: đang đọc lại tin cũ mà có
   * tin mới tới là bị giật thẳng xuống đáy, mất chỗ đang đọc. Messenger cũng không
   * làm vậy — nó hiện nút mũi tên xuống thay vì tự kéo.
   */
  useEffect(() => {
    if (oDay) cuonXuongDay();
    // `oDay` cố ý KHÔNG nằm trong deps: chỉ xét lúc có tin mới, không xét lúc cuộn.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tinNhans.length, cuonXuongDay]);

  /** Nhảy tới một tin trong khung đang xem và tô sáng tạm thời. */
  const nhayToiTin = useCallback((tinNhanId: string) => {
    const phanTu = khungTin.current?.querySelector(`[data-tin-id="${tinNhanId}"]`);
    if (!phanTu) return false;
    // Nhảy thẳng chứ không cuộn mượt: quãng đường có thể rất dài (hàng trăm tin),
    // và cuộn mượt còn bị bỏ qua ở một số môi trường — xem ghi chú ở cuonXuongDay.
    phanTu.scrollIntoView({ behavior: 'auto', block: 'center' });
    setTinNoiBat(tinNhanId);
    // Tắt tô sáng sau 2s — để mãi thì lần sau nhảy tới tin khác sẽ có hai vệt sáng.
    setTimeout(() => setTinNoiBat((cu) => (cu === tinNhanId ? null : cu)), 2000);
    return true;
  }, []);

  const moChiTiet = useCallback(
    async (tin: TinNhan) => {
      const kq = await chiTietTin(tin._id);
      if (kq) setChiTiet(kq);
    },
    [chiTietTin],
  );

  /**
   * Tìm nội dung tin nhắn khi gõ vào ô lọc.
   *
   * Chờ 300ms rồi mới gọi API: gõ 10 ký tự mà bắn 10 request thì vừa phí vừa
   * dễ nhận kết quả về sai thứ tự.
   */
  useEffect(() => {
    const tuKhoa = boLoc.trim();
    if (tuKhoa.length < 2) {
      setKetQuaTinNhan([]);
      return;
    }
    let huy = false;
    setDangTimTin(true);
    const timer = setTimeout(() => {
      timKiemTinNhan(tuKhoa)
        .then((kq) => !huy && setKetQuaTinNhan(kq))
        .catch(() => !huy && setKetQuaTinNhan([]))
        .finally(() => !huy && setDangTimTin(false));
    }, 300);
    return () => {
      huy = true;
      clearTimeout(timer);
    };
  }, [boLoc, timKiemTinNhan]);

  // Đánh dấu đã đọc tới tin cuối cùng đang hiển thị.
  useEffect(() => {
    const cuoi = tinNhans[tinNhans.length - 1];
    if (cuoi && !cuoi.dangGui) danhDauDaDoc(cuoi.soThuTu);
  }, [tinNhans, danhDauDaDoc]);

  const doiPhuong = useMemo(
    () => hoiThoaiDangMo?.thanhVien?.filter((tv) => tv._id !== nguoiDungId) ?? [],
    [hoiThoaiDangMo, nguoiDungId],
  );

  const tenAiDangGo = aiDangGo
    .map((id) => doiPhuong.find((tv) => tv._id === id)?.hoTen)
    .filter(Boolean);

  const laNhom = laLoaiNhom(hoiThoaiDangMo?.loai);

  /**
   * Lọc theo tên hội thoại, tên thành viên và nội dung xem trước.
   *
   * Bỏ dấu trước khi so: gõ "ca nha" vẫn tìm ra "Cả nhà". Người Việt gõ không dấu
   * để tìm nhanh là chuyện rất thường.
   */
  const hoiThoaiHienThi = useMemo(() => {
    const tuKhoa = boDau(boLoc.trim());
    if (!tuKhoa) return hoiThoais;

    return hoiThoais.filter((h) => {
      const tenThanhVien = (h.thanhVien ?? []).map((tv) => tv.hoTen ?? '').join(' ');
      const gop = boDau(`${h.ten ?? ''} ${h.xemTruoc ?? ''} ${tenThanhVien}`);
      return gop.includes(tuKhoa);
    });
  }, [hoiThoais, boLoc]);

  const xuLyGo = (giaTri: string) => {
    setNoiDung(giaTri);
    baoDangGo(true);
    if (timerGo.current) clearTimeout(timerGo.current);
    // Chỉ báo "dừng gõ" sau 2s im lặng, tránh spam mỗi lần gõ một ký tự.
    timerGo.current = setTimeout(() => baoDangGo(false), 2000);
  };

  const xuLyGui = () => {
    if (!noiDung.trim() && !tepDinhKem) return;
    guiTin(noiDung, tepDinhKem, tinTraLoi?._id);
    setNoiDung('');
    setTepDinhKem(null);
    setTinTraLoi(null);
    baoDangGo(false);
  };

  /**
   * Người khác đã đọc tới số thứ tự nào — lấy mốc lớn nhất trong nhóm.
   * Dùng để hiện "Đã xem" dưới tin cuối cùng của mình.
   */
  const mocDaXem = useMemo(
    () => Math.max(0, ...doiPhuong.map((tv) => tv.docDenSeq ?? 0)),
    [doiPhuong],
  );

  return (
    <div className="relative flex h-[calc(100vh-9rem)] overflow-hidden rounded-xl border bg-background">
      {/* ── Cột trái: danh sách hội thoại ── */}
      <aside
        className={`flex w-full flex-col border-r md:w-80 ${hoiThoaiDangMo ? 'hidden md:flex' : 'flex'}`}
      >
        <div className="flex items-center justify-between gap-2 border-b p-3">
          <h2 className="text-sm font-semibold">Tin nhắn</h2>
          <div className="flex items-center gap-1">
            {hienNutHoTro && (
              <button
                onClick={() => moKenhHoTro()}
                title="Liên hệ ban quản lý"
                className="rounded-md p-2 text-muted-foreground hover:bg-muted hover:text-foreground"
              >
                <Headset size={16} />
              </button>
            )}
            <button
              onClick={() => setMoDanhBa(true)}
              title="Cuộc trò chuyện mới"
              className="rounded-md p-2 text-muted-foreground hover:bg-muted hover:text-foreground"
            >
              <MessageSquarePlus size={16} />
            </button>
          </div>
        </div>

        <TrangThaiKetNoi trangThai={trangThaiKetNoi} />

        {/* Lọc ngay trên danh sách đã tải nên phản hồi tức thì, không gọi API.
            Đây là lọc theo TÊN hội thoại/thành viên — tìm theo NỘI DUNG tin nhắn
            là việc khác, thuộc P4 (xem CHAT_MODULE_PLAN.md §11.1). */}
        <div className="flex items-center gap-2 border-b px-3 py-2">
          <Search size={14} className="shrink-0 text-muted-foreground" />
          <input
            ref={oTimKiem}
            value={boLoc}
            onChange={(e) => setBoLoc(e.target.value)}
            placeholder="Tìm cuộc trò chuyện…"
            className="min-w-0 flex-1 bg-transparent text-sm outline-none"
          />
          {boLoc && (
            <button onClick={() => setBoLoc('')} aria-label="Xoá tìm kiếm">
              <X size={13} className="text-muted-foreground hover:text-foreground" />
            </button>
          )}
        </div>

        {/* Chuyển giữa danh sách thường và kho lưu trữ. Đặt ngay dưới ô tìm để
            người dùng thấy được vì sao một hội thoại "biến mất". */}
        <button
          onClick={() => doiCheDoLuuTru(!xemLuuTru)}
          className="flex items-center gap-2 border-b px-3 py-1.5 text-left text-xs text-muted-foreground hover:bg-muted/60"
        >
          {xemLuuTru ? <ArchiveRestore size={13} /> : <Archive size={13} />}
          {xemLuuTru ? 'Quay lại danh sách chính' : 'Xem mục đã lưu trữ'}
        </button>

        <div className="flex-1 overflow-y-auto">
          {hoiThoais.length === 0 && (
            <p className="p-4 text-center text-sm text-muted-foreground">
              {xemLuuTru ? 'Chưa lưu trữ cuộc trò chuyện nào.' : 'Chưa có cuộc trò chuyện nào.'}
            </p>
          )}
          {hoiThoais.length > 0 && hoiThoaiHienThi.length === 0 && (
            <p className="p-4 text-center text-sm text-muted-foreground">
              Không có cuộc trò chuyện nào khớp “{boLoc}”.
            </p>
          )}
          {hoiThoaiHienThi.map((h) => (
            <MucHoiThoai
              key={h._id}
              hoiThoai={h}
              dangChon={h._id === hoiThoaiDangMo?._id}
              onClick={() => moHoiThoai(h)}
              menu={
                <MenuMucHoiThoai
                  hoiThoai={h}
                  onGhim={() => capNhatTuyChon(h._id, { ghim: !h.ghim })}
                  onTatThongBao={() =>
                    capNhatTuyChon(h._id, { tatThongBao: !h.tatThongBao })
                  }
                  onLuuTru={() => capNhatTuyChon(h._id, { luuTru: !h.luuTru })}
                  onRoiNhom={() => {
                    if (confirm(`Rời khỏi nhóm "${h.ten}"?`)) roiNhom(h._id);
                  }}
                  onXoa={() => {
                    // Nói rõ đây là xoá bản của MÌNH: người dùng hay tưởng là xoá
                    // cho cả hai bên như thu hồi tin nhắn.
                    if (
                      confirm(
                        `Xoá cuộc trò chuyện "${h.ten}"?\n\n` +
                          'Chỉ xoá ở phía bạn — người kia vẫn giữ nguyên tin nhắn. ' +
                          'Nếu có tin mới, cuộc trò chuyện sẽ hiện lại nhưng không còn lịch sử cũ.',
                      )
                    ) {
                      xoaHoiThoai(h._id);
                    }
                  }}
                />
              }
            />
          ))}

          {/* Kết quả tìm theo NỘI DUNG tin nhắn — server tìm không phân biệt dấu.
              Tách hẳn khỏi phần trên vì đó là lọc theo TÊN hội thoại. */}
          {boLoc.trim().length >= 2 && (
            <div className="border-t">
              <p className="px-3 pb-1 pt-2 text-[11px] font-semibold uppercase text-muted-foreground">
                Tin nhắn {dangTimTin && '…'}
              </p>
              {!dangTimTin && ketQuaTinNhan.length === 0 && (
                <p className="px-3 pb-2 text-xs text-muted-foreground">Không có tin nhắn nào khớp.</p>
              )}
              {ketQuaTinNhan.map((t) => (
                <button
                  key={t._id}
                  onClick={() => moTaiTin(t.cuocTroChuyenId, t.soThuTu)}
                  className="flex w-full flex-col gap-0.5 border-b px-3 py-2 text-left hover:bg-muted/60"
                >
                  <span className="flex items-baseline justify-between gap-2">
                    <span className="truncate text-xs font-medium">
                      {hoiThoais.find((h) => h._id === t.cuocTroChuyenId)?.ten ?? 'Cuộc trò chuyện'}
                    </span>
                    <span className="shrink-0 text-[10px] text-muted-foreground">
                      {nhanNgan(t.ngayTao)}
                    </span>
                  </span>
                  <span className="line-clamp-2 text-xs text-muted-foreground">
                    {t.tenNguoiGui ? `${t.tenNguoiGui}: ` : ''}
                    {t.noiDung}
                  </span>
                </button>
              ))}
            </div>
          )}
        </div>
      </aside>

      {/* ── Cột phải: khung chat ── */}
      <section className={`flex flex-1 flex-col ${hoiThoaiDangMo ? 'flex' : 'hidden md:flex'}`}>
        {!hoiThoaiDangMo ? (
          <div className="flex flex-1 items-center justify-center p-6 text-center text-sm text-muted-foreground">
            Chọn một cuộc trò chuyện để bắt đầu.
          </div>
        ) : (
          <>
            <header className="flex items-center gap-3 border-b p-3">
              <button
                onClick={() => moHoiThoai(hoiThoaiDangMo)}
                className="md:hidden"
                aria-label="Quay lại"
              >
                <X size={18} />
              </button>
              <AnhDaiDien
                ten={hoiThoaiDangMo.ten}
                anh={hoiThoaiDangMo.anh}
                laNhom={laNhom}
                co={34}
              />
              <div className="min-w-0 flex-1">
                <p className="truncate text-sm font-semibold">{hoiThoaiDangMo.ten}</p>
                <p className="truncate text-xs text-muted-foreground">
                  {tenAiDangGo.length > 0
                    ? `${tenAiDangGo.join(', ')} đang nhập…`
                    : hoiThoaiDangMo.loai === 'SUPPORT'
                      ? 'Kênh liên hệ ban quản lý'
                      : laNhom
                        // Với nhóm thì đếm TỔNG thành viên (kể cả mình) — đếm "người
                        // khác" sẽ ra "0 người" khi chỉ còn lại mình, đọc rất khó hiểu.
                        ? `${nhanLoaiNhom(hoiThoaiDangMo.loai)}${hoiThoaiDangMo.thanhVien?.length ?? 0} thành viên`
                        : `${doiPhuong.length} người`}
                </p>
              </div>

              {/* Header chỉ còn MỘT nút. Mọi thứ về hội thoại nằm trong bảng thông
                  tin — rải nút trên header thì hết chỗ và khó tìm. */}
              <button
                onClick={() => setMoBangThongTin((v) => !v)}
                title="Thông tin cuộc trò chuyện"
                className={`rounded-md p-2 hover:bg-muted ${
                  moBangThongTin ? 'text-primary' : 'text-muted-foreground'
                }`}
              >
                <Info size={16} />
              </button>
            </header>

            {/* Băng tin đã ghim — bấm vào thì nhảy tới đúng tin đó. */}
            {tinGhims.length > 0 && (
              <div className="flex items-start gap-2 border-b bg-amber-500/10 px-3 py-1.5">
                <Pin size={12} className="mt-0.5 shrink-0 text-amber-600 dark:text-amber-400" />
                <div className="min-w-0 flex-1 space-y-0.5">
                  {tinGhims.map((t) => (
                    <button
                      key={t._id}
                      onClick={() => {
                        // Tin ghim có thể đã cuộn ra ngoài vùng đang nạp: khi đó
                        // nạp lại quanh nó thay vì im lặng không làm gì.
                        if (!nhayToiTin(t._id) && hoiThoaiDangMo) {
                          moTaiTin(hoiThoaiDangMo._id, t.soThuTu).then(() =>
                            setTimeout(() => nhayToiTin(t._id), 300),
                          );
                        }
                      }}
                      className="block w-full truncate text-left text-[11px] text-muted-foreground hover:text-foreground hover:underline"
                    >
                      {t.noiDung ?? '[Tệp đính kèm]'}
                    </button>
                  ))}
                </div>
              </div>
            )}

            <div
              className="relative flex min-h-0 flex-1 flex-col"
            >
            <div
              ref={khungTin}
              onScroll={(e) => {
                const el = e.currentTarget;
                if (el.scrollTop < 60) taiThemTinCu();
                setODay(el.scrollHeight - el.scrollTop - el.clientHeight < NGUONG_DAY);
              }}
              className="flex-1 space-y-0.5 overflow-y-auto p-4"
            >
              {dangTaiThem && (
                <p className="text-center text-xs text-muted-foreground">Đang tải tin cũ…</p>
              )}
              {!conTinCu && tinNhans.length > 0 && (
                <p className="text-center text-xs text-muted-foreground">Đầu cuộc trò chuyện</p>
              )}
              {dangTai ? (
                <div className="flex justify-center py-6">
                  <Loader2 className="animate-spin text-muted-foreground" size={20} />
                </div>
              ) : (
                tinNhans.map((t, i) => {
                  // Vị trí trong cụm quyết định: có chèn dải phân cách không, có hiện
                  // tên người gửi không, và có hiện giờ ở cuối cụm không.
                  const viTri = viTriTrongCum(t, tinNhans[i - 1], tinNhans[i + 1]);
                  const cuaToi = t.nguoiGuiId === nguoiDungId;
                  // "Đã xem" chỉ hiện dưới tin CUỐI CÙNG của mình đã được đọc —
                  // gắn vào mọi tin thì màn hình đầy chữ "Đã xem".
                  const laTinCuoiCuaToi =
                    cuaToi && !tinNhans.slice(i + 1).some((s) => s.nguoiGuiId === nguoiDungId);
                  return (
                    <div key={t._id}>
                      {viTri.hienPhanCach && <PhanCachThoiGian iso={t.ngayTao} />}
                      <BongBongTin
                        tin={t}
                        cuaToi={cuaToi}
                        viTri={viTri}
                        tinGoc={t.traLoiChoId ? tinNhans.find((x) => x._id === t.traLoiChoId) : undefined}
                        daXem={laTinCuoiCuaToi && !t.dangGui && mocDaXem >= t.soThuTu}
                        noiBat={t._id === tinNoiBat}
                        onTraLoi={() => setTinTraLoi(t)}
                        onThuHoi={() => {
                          if (confirm('Thu hồi tin nhắn này? Nội dung sẽ bị xoá hẳn.')) thuHoi(t._id);
                        }}
                        onChuyenTiep={() => setTinChuyenTiep(t)}
                        onGhim={() => datGhimTin(t._id, !t.dangGhim)}
                        onChiTiet={() => moChiTiet(t)}
                      />
                    </div>
                  );
                })
              )}
              <div ref={cuoiDanhSach} />
            </div>

            {/* Nút cuộn xuống cuối — chỉ hiện khi đang xem tin cũ, kèm số tin
                chưa đọc để biết có gì mới ở dưới hay không. */}
            {!oDay && (
              <button
                onClick={() => {
                  cuonXuongDay();
                  setODay(true);
                }}
                title="Xuống tin mới nhất"
                aria-label="Xuống tin mới nhất"
                className="absolute bottom-3 right-4 flex items-center gap-1.5 rounded-full border bg-popover px-3 py-1.5 text-xs shadow-lg hover:bg-muted"
              >
                <ChevronDown size={14} />
                {(hoiThoaiDangMo?.soTinChuaDoc ?? 0) > 0 && (
                  <span className="rounded-full bg-primary px-1.5 text-[10px] font-semibold text-primary-foreground">
                    {hoiThoaiDangMo?.soTinChuaDoc}
                  </span>
                )}
              </button>
            )}
            </div>

            <footer className="border-t">
              {/* Đang trả lời tin nào: trích dẫn để người gõ biết mình đang nói về gì. */}
              {tinTraLoi && (
                <div className="flex items-start gap-2 border-b bg-muted/40 px-3 py-2 text-xs">
                  <div className="min-w-0 flex-1 border-l-2 border-primary pl-2">
                    <p className="font-medium text-primary">
                      Trả lời {tinTraLoi.tenNguoiGui ?? 'tin nhắn'}
                    </p>
                    <p className="truncate text-muted-foreground">
                      {tinTraLoi.noiDung ?? '[Tệp đính kèm]'}
                    </p>
                  </div>
                  <button onClick={() => setTinTraLoi(null)} aria-label="Bỏ trả lời">
                    <X size={13} className="text-muted-foreground" />
                  </button>
                </div>
              )}

              {/* Xem trước tệp trước khi gửi — tránh gửi nhầm ảnh. */}
              {tepDinhKem && (
                <div className="flex items-center gap-2 border-b bg-muted/40 px-3 py-2 text-xs">
                  {tepDinhKem.loaiTinNhan === 'IMAGE' ? (
                    // eslint-disable-next-line @next/next/no-img-element
                    <img src={tepDinhKem.url} alt="" className="h-10 w-10 rounded object-cover" />
                  ) : (
                    <Paperclip size={14} className="text-muted-foreground" />
                  )}
                  <span className="min-w-0 flex-1 truncate">{tepDinhKem.tenTep ?? 'Tệp đính kèm'}</span>
                  <button onClick={() => setTepDinhKem(null)} aria-label="Bỏ tệp">
                    <X size={13} className="text-muted-foreground" />
                  </button>
                </div>
              )}

              <div className="flex items-center gap-2 p-3">
                <input
                  ref={oChonTep}
                  type="file"
                  className="hidden"
                  accept="image/*,application/pdf"
                  onChange={async (e) => {
                    const f = e.target.files?.[0];
                    e.target.value = ''; // cho phép chọn lại đúng tệp đó lần sau
                    if (!f) return;
                    setDangTaiTep(true);
                    try {
                      setTepDinhKem(await taiTepLen(f));
                    } catch (err) {
                      alert(err instanceof Error ? err.message : 'Tải tệp thất bại');
                    } finally {
                      setDangTaiTep(false);
                    }
                  }}
                />
                <button
                  onClick={() => oChonTep.current?.click()}
                  disabled={dangTaiTep}
                  title="Đính kèm ảnh hoặc tệp"
                  className="rounded-lg p-2 text-muted-foreground hover:bg-muted hover:text-foreground disabled:opacity-40"
                >
                  {dangTaiTep ? <Loader2 size={16} className="animate-spin" /> : <Paperclip size={16} />}
                </button>

                <input
                  value={noiDung}
                  onChange={(e) => xuLyGo(e.target.value)}
                  onKeyDown={(e) => {
                    if (e.key === 'Enter' && !e.shiftKey) {
                      e.preventDefault();
                      xuLyGui();
                    }
                  }}
                  placeholder="Nhập tin nhắn…"
                  className="flex-1 rounded-lg border bg-muted/40 px-3 py-2 text-sm outline-none focus:ring-2 focus:ring-ring"
                />
                <button
                  onClick={xuLyGui}
                  disabled={!noiDung.trim() && !tepDinhKem}
                  className="rounded-lg bg-primary p-2.5 text-primary-foreground disabled:opacity-40"
                  aria-label="Gửi"
                >
                  <Send size={16} />
                </button>
              </div>
            </footer>
          </>
        )}
      </section>

      {/* Cột thứ ba. Màn hình hẹp thì chiếm toàn bộ, che hai cột kia. */}
      {hoiThoaiDangMo && moBangThongTin && (
        <div className="absolute inset-0 z-20 bg-background md:static md:z-auto md:w-80 md:shrink-0">
          <BangThongTin
            hoiThoai={hoiThoaiDangMo}
            nguoiDungId={nguoiDungId}
            onDong={() => setMoBangThongTin(false)}
            onGhim={() => capNhatTuyChon(hoiThoaiDangMo._id, { ghim: !hoiThoaiDangMo.ghim })}
            onTatThongBao={(phut) => {
              if (phut === null) {
                // Bật lại: gửi false để server xoá cả hạn cũ.
                capNhatTuyChon(hoiThoaiDangMo._id, { tatThongBao: false });
              } else if (phut === 0) {
                capNhatTuyChon(hoiThoaiDangMo._id, { tatThongBao: true });
              } else {
                capNhatTuyChon(hoiThoaiDangMo._id, { tatThongBaoPhut: phut });
              }
            }}
            timTrongHoiThoai={timTrongHoiThoai}
            onChonKetQuaTim={(tin) => moTaiTin(tin.cuocTroChuyenId, tin.soThuTu)}
            onRoiNhom={() => {
              if (confirm(`Rời khỏi nhóm "${hoiThoaiDangMo.ten}"?`)) {
                roiNhom(hoiThoaiDangMo._id);
                setMoBangThongTin(false);
              }
            }}
            layTepDinhKem={layTepDinhKem}
            layLienKet={layLienKet}
            datBietDanh={datBietDanh}
            // Chỉ nhóm TỰ TẠO mới sửa được; nhóm theo nhà/tầng do hệ thống quản lý.
            // BangThongTin còn kiểm thêm vai trò trước khi hiện nút.
            onDoiAnhNhom={
              hoiThoaiDangMo.loai === 'GROUP'
                ? (tep) => doiAnhNhom(hoiThoaiDangMo._id, tep)
                : undefined
            }
            onDoiTenNhom={
              hoiThoaiDangMo.loai === 'GROUP'
                ? (ten) => doiTenNhom(hoiThoaiDangMo._id, ten)
                : undefined
            }
          />
        </div>
      )}

      {moDanhBa && (
        <HopThoaiDanhBa
          layDanhBa={layDanhBa}
          onChon={async (nguoi) => {
            setMoDanhBa(false);
            await moChatVoi(nguoi._id);
          }}
          onTaoNhom={async (ten, ids) => {
            setMoDanhBa(false);
            await taoNhom(ten, ids);
          }}
          onDong={() => setMoDanhBa(false)}
        />
      )}

      {tinChuyenTiep && (
        <HopThoaiChuyenTiep
          tin={tinChuyenTiep}
          hoiThoais={hoiThoais}
          hoiThoaiDangMoId={hoiThoaiDangMo?._id}
          onXong={async (ids) => {
            const ok = await chuyenTiep(tinChuyenTiep._id, ids);
            if (ok) setTinChuyenTiep(null);
          }}
          onDong={() => setTinChuyenTiep(null)}
        />
      )}

      {chiTiet && <HopThoaiChiTietTin chiTiet={chiTiet} onDong={() => setChiTiet(null)} />}

      {loi && (
        <div className="fixed bottom-4 right-4 flex items-center gap-2 rounded-lg border border-destructive/40 bg-destructive/10 px-3 py-2 text-sm text-destructive">
          <AlertCircle size={16} />
          <span>{loi}</span>
          <button onClick={xoaLoi} aria-label="Đóng">
            <X size={14} />
          </button>
        </div>
      )}
    </div>
  );
}

/**
 * Chỉ báo khi kết nối realtime đứt. Quan trọng: người dùng cần biết mình đang
 * xem dữ liệu có thể đã cũ, thay vì tưởng là không ai nhắn gì.
 */
function TrangThaiKetNoi({ trangThai }: { trangThai: string }) {
  if (trangThai === 'connected') return null;
  const dangNoi = trangThai === 'connecting';
  return (
    <div className="flex items-center gap-2 border-b bg-amber-50 px-3 py-1.5 text-xs text-amber-700 dark:bg-amber-950/40 dark:text-amber-400">
      {dangNoi ? <Wifi size={13} /> : <WifiOff size={13} />}
      {dangNoi ? 'Đang kết nối…' : 'Mất kết nối — sẽ tự nối lại'}
    </div>
  );
}

/**
 * Chiều cao ước lượng của menu thả xuống (5 mục × ~33px + viền).
 * Chỉ dùng để quyết định lật lên hay xuống nên không cần chính xác tuyệt đối —
 * đo thật thì phải render trước rồi mới đo, gây nháy một khung hình.
 */
const CAO_MENU_UOC_LUONG = 190;

/** Tổ tiên gần nhất có thanh cuộn dọc — chính nó là thứ cắt mất menu. */
function timKhungCuon(tu: HTMLElement | null): HTMLElement | null {
  let nut = tu?.parentElement ?? null;
  while (nut) {
    const tran = getComputedStyle(nut).overflowY;
    if (tran === 'auto' || tran === 'scroll') return nut;
    nut = nut.parentElement;
  }
  return null;
}

/**
 * Menu ba chấm ngay trên mục danh sách — thao tác với hội thoại mà KHÔNG phải mở nó.
 *
 * Đây là điểm khác biệt so với bảng thông tin: bảng thông tin chỉ mở được khi đã
 * vào hội thoại, còn lưu trữ / tắt báo / xoá thường là việc muốn làm từ ngoài danh sách.
 */
function MenuMucHoiThoai({
  hoiThoai,
  onGhim,
  onTatThongBao,
  onLuuTru,
  onRoiNhom,
  onXoa,
}: {
  hoiThoai: CuocTroChuyen;
  onGhim: () => void;
  onTatThongBao: () => void;
  onLuuTru: () => void;
  onRoiNhom: () => void;
  onXoa: () => void;
}) {
  const [mo, setMo] = useState(false);
  const [latLen, setLatLen] = useState(false);
  const boc = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!mo) return;
    const xuLy = (e: MouseEvent) => {
      if (boc.current && !boc.current.contains(e.target as Node)) setMo(false);
    };
    document.addEventListener('mousedown', xuLy);
    return () => document.removeEventListener('mousedown', xuLy);
  }, [mo]);

  /**
   * Mục ở cuối danh sách thì menu thả xuống bị KHUNG CUỘN cắt mất — mục cuối cùng
   * ("Xoá cuộc trò chuyện") bấm không tới. Thiếu chỗ phía dưới thì lật lên trên.
   *
   * Đo so với khung cuộn chứ không so với cửa sổ: thứ cắt menu là `overflow-y`
   * của danh sách, không phải mép màn hình.
   */
  const moMenu = () => {
    if (!mo) {
      const nut = boc.current?.getBoundingClientRect();
      const khung = timKhungCuon(boc.current);
      const mepDuoi = khung ? khung.getBoundingClientRect().bottom : window.innerHeight;
      setLatLen(!!nut && mepDuoi - nut.bottom < CAO_MENU_UOC_LUONG);
    }
    setMo((v) => !v);
  };

  const muc: Array<{ nhan: string; icon: React.ReactNode; chay: () => void; nguyHiem?: boolean }> = [
    {
      nhan: hoiThoai.ghim ? 'Bỏ ghim' : 'Ghim lên đầu',
      icon: <Pin size={13} />,
      chay: onGhim,
    },
    {
      nhan: hoiThoai.tatThongBao ? 'Bật thông báo' : 'Tắt thông báo',
      icon: <BellOff size={13} />,
      chay: onTatThongBao,
    },
    {
      nhan: hoiThoai.luuTru ? 'Bỏ lưu trữ' : 'Lưu trữ',
      icon: hoiThoai.luuTru ? <ArchiveRestore size={13} /> : <Archive size={13} />,
      chay: onLuuTru,
    },
  ];
  // Nhóm hệ thống (cả nhà / cùng tầng) do job đồng bộ quản lý: rời tay xong sẽ bị
  // thêm lại, nên không đưa lựa chọn đó ra cho người dùng.
  if (hoiThoai.loai === 'GROUP') {
    muc.push({ nhan: 'Rời nhóm', icon: <LogOut size={13} />, chay: onRoiNhom, nguyHiem: true });
  }
  muc.push({ nhan: 'Xoá cuộc trò chuyện', icon: <Trash2 size={13} />, chay: onXoa, nguyHiem: true });

  return (
    <div ref={boc} className="relative shrink-0">
      <button
        onClick={(e) => {
          e.stopPropagation();
          moMenu();
        }}
        title="Tuỳ chọn"
        aria-label={`Tuỳ chọn cho ${hoiThoai.ten ?? 'cuộc trò chuyện'}`}
        className={`rounded p-1 text-muted-foreground hover:bg-muted hover:text-foreground ${
          mo ? 'opacity-100' : 'opacity-0 transition-opacity group-hover:opacity-100'
        }`}
      >
        <MoreHorizontal size={14} />
      </button>

      {mo && (
        // z-50: phải cao hơn MỌI thứ trong danh sách. Trước đây dùng z-30 và các
        // phần hiển thị của mục lại có z-10 — chỉ cần một mục phía sau vẽ đè là
        // menu trông như trong suốt (chữ của mục lộ xuyên qua nền trắng).
        <div
          className={`absolute right-0 z-50 w-48 overflow-hidden rounded-lg border bg-popover shadow-xl ring-1 ring-black/5 ${
            latLen ? 'bottom-full mb-1' : 'top-full mt-1'
          }`}
        >
          {muc.map((m) => (
            <button
              key={m.nhan}
              onClick={(e) => {
                e.stopPropagation();
                setMo(false);
                m.chay();
              }}
              className={`flex w-full items-center gap-2 px-3 py-2 text-left text-xs hover:bg-muted ${
                m.nguyHiem ? 'text-destructive' : ''
              }`}
            >
              {m.icon}
              {m.nhan}
            </button>
          ))}
        </div>
      )}
    </div>
  );
}

function MucHoiThoai({
  hoiThoai,
  dangChon,
  onClick,
  menu,
}: {
  hoiThoai: CuocTroChuyen;
  dangChon: boolean;
  onClick: () => void;
  menu: React.ReactNode;
}) {
  const chuaDoc = hoiThoai.soTinChuaDoc ?? 0;
  const laNhom = laLoaiNhom(hoiThoai.loai);
  const nhanLoai = nhanNganLoai(hoiThoai.loai);
  const soThanhVien = hoiThoai.thanhVien?.length ?? 0;

  return (
    // Bọc ngoài là div chứ không phải button: menu ba chấm là một <button>, mà
    // button lồng trong button là HTML không hợp lệ (trình duyệt sẽ tự tách thẻ).
    //
    // `focus-within:z-20` nâng cả mục lên khi menu bên trong đang mở (nút menu vẫn
    // giữ focus lúc đó), để menu không bị các mục PHÍA SAU trong danh sách vẽ đè.
    <div
      className={`group relative flex w-full items-center gap-3 border-b px-3 py-2.5 text-left hover:bg-muted/60 focus-within:z-20 ${
        dangChon ? 'bg-muted' : ''
      }`}
    >
      <button
        onClick={onClick}
        className="absolute inset-0 cursor-pointer"
        aria-label={`Mở ${hoiThoai.ten ?? 'cuộc trò chuyện'}`}
      />
      {/* Nhóm dùng biểu tượng người + màu khác hẳn; chat 1-1 giữ chữ cái đầu tên.
          Nhìn lướt là phân biệt được ngay mà không cần đọc chữ. */}
      {/* Không đặt z-index cho các phần hiển thị: chúng chỉ cần nằm trên nút phủ
          trong suốt ở trên, mà thứ tự DOM đã lo việc đó. Gán z-index ở đây sẽ tạo
          ra thứ cạnh tranh với menu thả xuống của các mục khác. */}
      <AnhDaiDien
        ten={hoiThoai.ten}
        anh={hoiThoai.anh}
        laNhom={laNhom}
        co={36}
        className="pointer-events-none relative"
      />

      <div className="pointer-events-none relative min-w-0 flex-1">
        <div className="flex items-baseline justify-between gap-2">
          <p className="flex min-w-0 items-center gap-1.5">
            <span className="truncate text-sm font-medium">{hoiThoai.ten}</span>
            {nhanLoai && (
              <span className={`shrink-0 rounded px-1.5 py-0.5 text-[10px] font-medium ${nhanLoai.mau}`}>
                {nhanLoai.chu}
              </span>
            )}
          </p>
          {/* Nhãn rất ngắn: hôm nay hiện giờ, cũ hơn thì hiện thứ hoặc ngày. */}
          <span className="shrink-0 text-[10px] text-muted-foreground">
            {nhanNgan(hoiThoai.tinNhanCuoiLuc)}
          </span>
        </div>
        <p className="truncate text-xs text-muted-foreground">
          {laNhom && soThanhVien > 0 && (
            <span className="mr-1 text-muted-foreground/70">{soThanhVien} người ·</span>
          )}
          {hoiThoai.xemTruoc ?? 'Chưa có tin nhắn'}
        </p>
      </div>

      <div className="relative flex shrink-0 items-center gap-1 self-center">
        {hoiThoai.tatThongBao && (
          <BellOff size={12} className="pointer-events-none text-muted-foreground" />
        )}
        {hoiThoai.ghim && <Pin size={12} className="pointer-events-none text-muted-foreground" />}
        {chuaDoc > 0 && (
          <span className="pointer-events-none rounded-full bg-primary px-1.5 py-0.5 text-[10px] font-semibold text-primary-foreground">
            {chuaDoc > 99 ? '99+' : chuaDoc}
          </span>
        )}
        {menu}
      </div>
    </div>
  );
}

/** Nhãn đứng trước số thành viên, để phân biệt nhóm hệ thống với nhóm tự tạo. */
function nhanLoaiNhom(loai?: string): string {
  if (loai === 'BUILDING') return 'Nhóm cả nhà · ';
  if (loai === 'FLOOR') return 'Nhóm cùng tầng · ';
  return '';
}

/**
 * Nhãn ngắn hiện cạnh tên trong danh sách, mỗi loại một màu.
 *
 * Màu chọn theo ý nghĩa chứ không tuỳ tiện:
 *   Cả nhà      – lam  : phạm vi rộng nhất
 *   Tầng        – tím  : phạm vi hẹp hơn, nằm trong nhà
 *   Nhóm tự tạo – hổ phách: do người dùng lập, khớp với màu ảnh đại diện nhóm
 *   Ban quản lý – lục  : kênh chính thức, phân biệt hẳn với nhóm do dân lập
 *
 * Chat 1-1 cố tình KHÔNG có nhãn: đó là mặc định, gắn nhãn cho mọi thứ thì nhãn
 * mất hết tác dụng phân biệt.
 */
function nhanNganLoai(loai?: string): { chu: string; mau: string } | null {
  switch (loai) {
    case 'BUILDING':
      return { chu: 'Cả nhà', mau: 'bg-sky-500/15 text-sky-700 dark:text-sky-300' };
    case 'FLOOR':
      return { chu: 'Tầng', mau: 'bg-violet-500/15 text-violet-700 dark:text-violet-300' };
    case 'GROUP':
      return { chu: 'Nhóm', mau: 'bg-amber-500/15 text-amber-700 dark:text-amber-400' };
    case 'SUPPORT':
      return { chu: 'Ban quản lý', mau: 'bg-emerald-500/15 text-emerald-700 dark:text-emerald-400' };
    default:
      return null;
  }
}

function laLoaiNhom(loai?: string): boolean {
  return loai === 'GROUP' || loai === 'BUILDING' || loai === 'FLOOR';
}

/**
 * Bỏ dấu tiếng Việt và hạ chữ thường, để so khớp khi tìm kiếm.
 *
 * NFD tách nguyên âm khỏi dấu thanh rồi xoá dải ký tự dấu (U+0300–U+036F).
 * Riêng "đ/Đ" phải xử lý tay vì nó là một chữ cái độc lập, không phải "d" + dấu
 * nên NFD không tách ra được.
 */
function boDau(chuoi: string): string {
  return chuoi
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .replace(/đ/g, 'd') // đ
    .replace(/Đ/g, 'D') // Đ
    .toLowerCase();
}

/**
 * Dải phân cách thời gian, đặt giữa hai cụm tin cách nhau lâu hoặc khác ngày.
 * Đây là chỗ DUY NHẤT hiện mốc thời gian dạng chữ — tránh nhồi giờ vào mọi bong bóng.
 */
function PhanCachThoiGian({ iso }: { iso?: string }) {
  const nhan = nhanPhanCach(iso);
  if (!nhan) return null;
  return (
    <div className="flex justify-center py-3">
      <span className="rounded-full bg-muted/70 px-2.5 py-0.5 text-[11px] font-medium text-muted-foreground">
        {nhan}
      </span>
    </div>
  );
}

/**
 * Menu hành động của MỘT tin nhắn.
 *
 * Trước đây hai nút trả lời/thu hồi hiện thường trực cạnh bong bóng: chật, và
 * không còn chỗ cho các hành động mới. Gom vào menu ba chấm như Messenger.
 */
function MenuTin({
  tin,
  cuaToi,
  onTraLoi,
  onChuyenTiep,
  onGhim,
  onChiTiet,
  onThuHoi,
}: {
  tin: TinNhan;
  cuaToi: boolean;
  onTraLoi: () => void;
  onChuyenTiep: () => void;
  onGhim: () => void;
  onChiTiet: () => void;
  onThuHoi: () => void;
}) {
  const [mo, setMo] = useState(false);
  const [latLen, setLatLen] = useState(false);
  const boc = useRef<HTMLDivElement>(null);

  // Bấm ra ngoài thì đóng — menu nổi mà không tự đóng là lỗi rất khó chịu.
  useEffect(() => {
    if (!mo) return;
    const xuLy = (e: MouseEvent) => {
      if (boc.current && !boc.current.contains(e.target as Node)) setMo(false);
    };
    document.addEventListener('mousedown', xuLy);
    return () => document.removeEventListener('mousedown', xuLy);
  }, [mo]);

  // Tin ở cuối khung chat cũng sát đáy vùng cuộn — cùng vấn đề với menu danh sách.
  const moMenu = () => {
    if (!mo) {
      const nut = boc.current?.getBoundingClientRect();
      const khung = timKhungCuon(boc.current);
      const mepDuoi = khung ? khung.getBoundingClientRect().bottom : window.innerHeight;
      setLatLen(!!nut && mepDuoi - nut.bottom < CAO_MENU_UOC_LUONG);
    }
    setMo((v) => !v);
  };

  const muc: Array<{ nhan: string; icon: React.ReactNode; chay: () => void; nguyHiem?: boolean }> = [
    { nhan: 'Trả lời', icon: <Reply size={13} />, chay: onTraLoi },
    { nhan: 'Chuyển tiếp', icon: <Forward size={13} />, chay: onChuyenTiep },
    {
      nhan: tin.dangGhim ? 'Bỏ ghim' : 'Ghim tin nhắn',
      icon: <Pin size={13} />,
      chay: onGhim,
    },
    { nhan: 'Chi tiết', icon: <Info size={13} />, chay: onChiTiet },
  ];
  // Chỉ người gửi mới thu hồi được — server cũng kiểm tra lại.
  if (cuaToi) {
    muc.push({ nhan: 'Thu hồi', icon: <Undo2 size={13} />, chay: onThuHoi, nguyHiem: true });
  }

  return (
    <div ref={boc} className="relative shrink-0">
      <button
        onClick={moMenu}
        title="Tuỳ chọn"
        aria-label="Tuỳ chọn tin nhắn"
        className={`rounded p-1 text-muted-foreground hover:bg-muted hover:text-foreground ${
          mo ? 'opacity-100' : 'opacity-0 transition-opacity group-hover:opacity-100'
        }`}
      >
        <MoreHorizontal size={14} />
      </button>

      {mo && (
        <div
          className={`absolute z-50 w-44 overflow-hidden rounded-lg border bg-popover shadow-xl ring-1 ring-black/5 ${
            cuaToi ? 'right-0' : 'left-0'
          } ${latLen ? 'bottom-full mb-1' : 'top-full mt-1'}`}
        >
          {muc.map((m) => (
            <button
              key={m.nhan}
              onClick={() => {
                setMo(false);
                m.chay();
              }}
              className={`flex w-full items-center gap-2 px-3 py-2 text-left text-xs hover:bg-muted ${
                m.nguyHiem ? 'text-destructive' : ''
              }`}
            >
              {m.icon}
              {m.nhan}
            </button>
          ))}
        </div>
      )}
    </div>
  );
}

function BongBongTin({
  tin,
  cuaToi,
  viTri,
  tinGoc,
  daXem,
  noiBat,
  onTraLoi,
  onThuHoi,
  onChuyenTiep,
  onGhim,
  onChiTiet,
}: {
  tin: TinNhan;
  cuaToi: boolean;
  viTri: ViTriTrongCum;
  tinGoc?: TinNhan;
  daXem?: boolean;
  /** Tô sáng tạm thời khi vừa nhảy tới tin này từ tìm kiếm hoặc từ băng ghim. */
  noiBat?: boolean;
  onTraLoi: () => void;
  onThuHoi: () => void;
  onChuyenTiep: () => void;
  onGhim: () => void;
  onChiTiet: () => void;
}) {
  if (tin.loai === 'SYSTEM') {
    return <p className="py-1 text-center text-xs text-muted-foreground">{tin.noiDung}</p>;
  }

  // Bo góc theo vị trí trong cụm để nhìn ra đâu là một chuỗi tin liền mạch:
  // góc phía người gửi chỉ bo tròn ở tin đầu và tin cuối cụm.
  const boGoc = cuaToi
    ? `${viTri.dauCum ? 'rounded-tr-2xl' : 'rounded-tr-md'} ${viTri.cuoiCum ? 'rounded-br-2xl' : 'rounded-br-md'}`
    : `${viTri.dauCum ? 'rounded-tl-2xl' : 'rounded-tl-md'} ${viTri.cuoiCum ? 'rounded-bl-2xl' : 'rounded-bl-md'}`;

  return (
    <div
      data-tin-id={tin._id}
      className={`flex flex-col ${cuaToi ? 'items-end' : 'items-start'} ${viTri.dauCum ? 'mt-2' : ''} ${
        noiBat ? 'rounded-lg bg-amber-400/20 ring-1 ring-amber-400/60 transition-colors' : ''
      }`}
    >
      {/* Tên người gửi chỉ hiện ở tin ĐẦU cụm, và không hiện với tin của chính mình. */}
      {!cuaToi && viTri.dauCum && tin.tenNguoiGui && (
        <span className="mb-0.5 pl-8 text-[11px] font-medium text-muted-foreground">
          {tin.tenNguoiGui}
        </span>
      )}

      {/* Hai nhãn nhỏ đặt NGOÀI bong bóng: đặt bên trong sẽ đội nội dung xuống
          và làm hỏng việc gom tin liên tiếp. */}
      {(tin.dangGhim || tin.chuyenTiepTuId) && !tin.daThuHoi && (
        <span className="mb-0.5 flex items-center gap-1 px-1 text-[10px] text-muted-foreground">
          {tin.dangGhim && (
            <>
              <Pin size={9} /> Đã ghim
            </>
          )}
          {tin.chuyenTiepTuId && (
            <>
              <Forward size={9} /> Đã chuyển tiếp
            </>
          )}
        </span>
      )}

      {/* Nhóm bong bóng + nút hành động: nút chỉ hiện khi rê chuột, để không
          chiếm chỗ và không làm rối khi đang đọc. */}
      <div className={`group flex items-end gap-1.5 ${cuaToi ? 'flex-row-reverse' : 'flex-row'}`}>
        {/* Ảnh người gửi chỉ cạnh tin CUỐI cụm và chỉ với tin của người khác —
            gắn vào mọi tin thì một chuỗi 5 tin sẽ có 5 ảnh giống hệt nhau.
            Vẫn chừa chỗ trống ở các tin khác để bong bóng thẳng hàng. */}
        {!cuaToi &&
          (viTri.cuoiCum ? (
            <AnhDaiDien ten={tin.tenNguoiGui} anh={tin.anhNguoiGui} co={26} className="mb-0.5" />
          ) : (
            <span className="w-[26px] shrink-0" aria-hidden />
          ))}
        <div
          // Rê chuột lên bong bóng để xem giờ chính xác tới giây.
          title={gioDayDu(tin.ngayTao)}
          className={`max-w-[75%] rounded-2xl px-3 py-2 text-sm ${boGoc} ${
            cuaToi ? 'bg-primary text-primary-foreground' : 'bg-muted'
          } ${tin.dangGui ? 'opacity-60' : ''} ${tin.loiGui ? 'ring-1 ring-destructive' : ''}`}
        >
          {tin.daThuHoi ? (
            <span className="italic opacity-70">Tin nhắn đã được thu hồi</span>
          ) : (
            <>
              {/* Trích dẫn tin được trả lời, nếu tin gốc còn trong danh sách đang xem. */}
              {tinGoc && (
                <div
                  className={`mb-1 border-l-2 pl-2 text-xs opacity-80 ${
                    cuaToi ? 'border-primary-foreground/50' : 'border-primary'
                  }`}
                >
                  <p className="font-medium">{tinGoc.tenNguoiGui ?? 'Tin nhắn'}</p>
                  <p className="line-clamp-2">{tinGoc.noiDung ?? '[Tệp đính kèm]'}</p>
                </div>
              )}

              {tin.fileUrl &&
                (tin.loai === 'IMAGE' ? (
                  // eslint-disable-next-line @next/next/no-img-element
                  <img src={tin.fileUrl} alt="" className="mb-1 max-h-56 rounded-lg object-cover" />
                ) : (
                  <a
                    href={tin.fileUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="mb-1 flex items-center gap-1.5 underline underline-offset-2"
                  >
                    <Paperclip size={13} />
                    Tệp đính kèm
                  </a>
                ))}

              {tin.noiDung && <span className="whitespace-pre-wrap break-words">{tin.noiDung}</span>}
            </>
          )}
        </div>

        {!tin.daThuHoi && !tin.dangGui && (
          <MenuTin
            tin={tin}
            cuaToi={cuaToi}
            onTraLoi={onTraLoi}
            onChuyenTiep={onChuyenTiep}
            onGhim={onGhim}
            onChiTiet={onChiTiet}
            onThuHoi={onThuHoi}
          />
        )}
      </div>

      {/* Giờ chỉ hiện ở tin CUỐI cụm — đủ để định vị mà không làm rối màn hình. */}
      {viTri.cuoiCum && !tin.dangGui && !tin.loiGui && (
        <span className="mt-0.5 px-1 text-[10px] text-muted-foreground">
          {gioPhut(new Date(tin.ngayTao ?? ''))}
          {daXem && <span className="ml-1 text-primary">· Đã xem</span>}
        </span>
      )}
      {tin.dangGui && <span className="mt-0.5 px-1 text-[10px] text-muted-foreground">Đang gửi…</span>}
      {tin.loiGui && <span className="mt-0.5 px-1 text-[10px] text-destructive">Gửi lỗi</span>}
    </div>
  );
}

/**
 * Một hộp thoại phục vụ cả hai việc: mở chat 1-1 và tạo nhóm.
 * Gộp lại vì danh sách người chọn y hệt nhau — tách đôi chỉ làm người dùng phải
 * nhớ thêm một nút nữa.
 */
function HopThoaiDanhBa({
  layDanhBa,
  onChon,
  onTaoNhom,
  onDong,
}: {
  layDanhBa: (q?: string) => Promise<NguoiLienHe[]>;
  onChon: (nguoi: NguoiLienHe) => void;
  onTaoNhom: (ten: string, ids: string[]) => void;
  onDong: () => void;
}) {
  const [tuKhoa, setTuKhoa] = useState('');
  const [danhSach, setDanhSach] = useState<NguoiLienHe[]>([]);
  const [dangTai, setDangTai] = useState(true);
  const [cheDoNhom, setCheDoNhom] = useState(false);
  const [tenNhom, setTenNhom] = useState('');
  const [daChon, setDaChon] = useState<string[]>([]);

  const doiChon = (id: string) =>
    setDaChon((truoc) => (truoc.includes(id) ? truoc.filter((x) => x !== id) : [...truoc, id]));

  useEffect(() => {
    let huy = false;
    setDangTai(true);
    // Chờ 250ms để không gọi API sau mỗi ký tự.
    const timer = setTimeout(() => {
      layDanhBa(tuKhoa)
        .then((ds) => !huy && setDanhSach(ds))
        .finally(() => !huy && setDangTai(false));
    }, 250);
    return () => {
      huy = true;
      clearTimeout(timer);
    };
  }, [tuKhoa, layDanhBa]);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
      <div className="flex max-h-[70vh] w-full max-w-md flex-col rounded-xl border bg-background shadow-lg">
        <div className="flex items-center justify-between border-b p-3">
          <h3 className="text-sm font-semibold">
            {cheDoNhom ? 'Tạo nhóm mới' : 'Chọn người để nhắn tin'}
          </h3>
          <div className="flex items-center gap-2">
            <button
              onClick={() => {
                setCheDoNhom((v) => !v);
                setDaChon([]);
              }}
              className="rounded-md px-2 py-1 text-xs text-muted-foreground hover:bg-muted"
            >
              {cheDoNhom ? 'Chat 1-1' : 'Tạo nhóm'}
            </button>
            <button onClick={onDong} aria-label="Đóng">
              <X size={16} />
            </button>
          </div>
        </div>

        {cheDoNhom && (
          <div className="border-b px-3 py-2">
            <input
              value={tenNhom}
              onChange={(e) => setTenNhom(e.target.value)}
              placeholder="Tên nhóm (VD: Mượn đồ tầng 2)"
              className="w-full rounded-lg border bg-muted/40 px-3 py-2 text-sm outline-none focus:ring-2 focus:ring-ring"
            />
          </div>
        )}

        <div className="flex items-center gap-2 border-b px-3 py-2">
          <Search size={15} className="text-muted-foreground" />
          <input
            value={tuKhoa}
            onChange={(e) => setTuKhoa(e.target.value)}
            placeholder="Tìm theo tên hoặc số điện thoại…"
            className="flex-1 bg-transparent text-sm outline-none"
            autoFocus
          />
        </div>

        <div className="flex-1 overflow-y-auto">
          {dangTai && (
            <div className="flex justify-center py-6">
              <Loader2 className="animate-spin text-muted-foreground" size={18} />
            </div>
          )}
          {!dangTai && danhSach.length === 0 && (
            <p className="p-4 text-center text-sm text-muted-foreground">
              Không tìm thấy ai trong phạm vi nhà trọ của bạn.
            </p>
          )}
          {danhSach.map((nguoi) => (
            <button
              key={nguoi._id}
              onClick={() => (cheDoNhom ? doiChon(nguoi._id) : onChon(nguoi))}
              className={`flex w-full items-center gap-3 border-b px-3 py-2.5 text-left hover:bg-muted/60 ${
                cheDoNhom && daChon.includes(nguoi._id) ? 'bg-primary/5' : ''
              }`}
            >
              {cheDoNhom && (
                <span
                  className={`flex h-4 w-4 shrink-0 items-center justify-center rounded border ${
                    daChon.includes(nguoi._id)
                      ? 'border-primary bg-primary text-primary-foreground'
                      : 'border-muted-foreground/40'
                  }`}
                >
                  {daChon.includes(nguoi._id) && <Check size={11} />}
                </span>
              )}
              <AnhDaiDien ten={nguoi.hoTen} anh={nguoi.anhDaiDien} co={32} />
              <div className="min-w-0 flex-1">
                <p className="truncate text-sm font-medium">{nguoi.hoTen}</p>
                <p className="truncate text-xs text-muted-foreground">{nguoi.soDienThoai}</p>
              </div>
              <span className="shrink-0 rounded-full bg-muted px-2 py-0.5 text-[10px] text-muted-foreground">
                {nguoi.vaiTro === 'LANDLORD'
                  ? 'Chủ nhà'
                  : nguoi.vaiTro === 'STAFF'
                    ? 'Quản lý'
                    : 'Khách thuê'}
              </span>
            </button>
          ))}
        </div>

        {cheDoNhom && (
          <div className="flex items-center justify-between gap-2 border-t p-3">
            <span className="text-xs text-muted-foreground">Đã chọn {daChon.length} người</span>
            <button
              // Nhóm cần tối thiểu 2 người (người tạo + 1), nên phải chọn ít nhất 1.
              disabled={!tenNhom.trim() || daChon.length < 1}
              onClick={() => onTaoNhom(tenNhom.trim(), daChon)}
              className="rounded-lg bg-primary px-3 py-1.5 text-sm text-primary-foreground disabled:opacity-40"
            >
              Tạo nhóm
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

/**
 * Chọn hội thoại để chuyển tiếp tin.
 *
 * Cho chọn nhiều đích một lần vì thao tác thường gặp là "báo cho cả hai nhà".
 * Loại hội thoại ĐANG MỞ khỏi danh sách: chuyển tiếp về chính chỗ đang đứng là
 * vô nghĩa và chỉ tổ bấm nhầm.
 */
function HopThoaiChuyenTiep({
  tin,
  hoiThoais,
  hoiThoaiDangMoId,
  onXong,
  onDong,
}: {
  tin: TinNhan;
  hoiThoais: CuocTroChuyen[];
  hoiThoaiDangMoId?: string;
  onXong: (hoiThoaiIds: string[]) => Promise<void>;
  onDong: () => void;
}) {
  const [daChon, setDaChon] = useState<string[]>([]);
  const [tuKhoa, setTuKhoa] = useState('');
  const [dangGui, setDangGui] = useState(false);

  const ungVien = useMemo(() => {
    const tk = boDau(tuKhoa.trim());
    return hoiThoais
      .filter((h) => h._id !== hoiThoaiDangMoId)
      .filter((h) => !tk || boDau(h.ten ?? '').includes(tk));
  }, [hoiThoais, hoiThoaiDangMoId, tuKhoa]);

  const doiChon = (id: string) =>
    setDaChon((truoc) => (truoc.includes(id) ? truoc.filter((x) => x !== id) : [...truoc, id]));

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
      <div className="flex max-h-[70vh] w-full max-w-md flex-col rounded-xl border bg-background shadow-lg">
        <div className="flex items-center justify-between border-b p-3">
          <h3 className="text-sm font-semibold">Chuyển tiếp tin nhắn</h3>
          <button onClick={onDong} aria-label="Đóng">
            <X size={16} />
          </button>
        </div>

        {/* Cho xem lại nội dung sắp gửi đi — chuyển tiếp nhầm tin là lỗi không sửa được. */}
        <div className="border-b bg-muted/40 px-3 py-2">
          <p className="line-clamp-2 text-xs text-muted-foreground">
            {tin.noiDung ?? '[Tệp đính kèm]'}
          </p>
        </div>

        <div className="border-b px-3 py-2">
          <input
            value={tuKhoa}
            onChange={(e) => setTuKhoa(e.target.value)}
            placeholder="Tìm cuộc trò chuyện…"
            className="w-full rounded-md border bg-background px-2 py-1.5 text-sm outline-none focus:ring-1 focus:ring-primary"
          />
        </div>

        <div className="flex-1 overflow-y-auto">
          {ungVien.length === 0 ? (
            <p className="p-4 text-center text-xs text-muted-foreground">
              Không có cuộc trò chuyện nào phù hợp.
            </p>
          ) : (
            ungVien.map((h) => (
              <button
                key={h._id}
                onClick={() => doiChon(h._id)}
                className="flex w-full items-center gap-2 border-b px-3 py-2 text-left text-sm hover:bg-muted"
              >
                <span
                  className={`flex h-4 w-4 shrink-0 items-center justify-center rounded border ${
                    daChon.includes(h._id) ? 'border-primary bg-primary text-primary-foreground' : ''
                  }`}
                >
                  {daChon.includes(h._id) && <Check size={11} />}
                </span>
                <span className="truncate">{h.ten}</span>
              </button>
            ))
          )}
        </div>

        <div className="border-t p-3">
          <button
            disabled={daChon.length === 0 || dangGui}
            onClick={async () => {
              setDangGui(true);
              try {
                await onXong(daChon);
              } finally {
                setDangGui(false);
              }
            }}
            className="w-full rounded-md bg-primary px-3 py-2 text-sm text-primary-foreground disabled:opacity-50"
          >
            {dangGui ? 'Đang gửi…' : `Chuyển tiếp${daChon.length ? ` (${daChon.length})` : ''}`}
          </button>
        </div>
      </div>
    </div>
  );
}

/** Ai đã xem tin, ai chưa. Trong nhóm thì phần "chưa xem" mới là thứ cần biết. */
function HopThoaiChiTietTin({
  chiTiet,
  onDong,
}: {
  chiTiet: ChiTietTinNhan;
  onDong: () => void;
}) {
  const nhom = (nhan: string, ds: ChiTietTinNhan['daXem'], hienGio: boolean) =>
    ds.length > 0 && (
      <div className="border-b px-3 py-2 last:border-b-0">
        <p className="mb-1 text-[11px] font-semibold uppercase text-muted-foreground">
          {nhan} · {ds.length}
        </p>
        {ds.map((n) => (
          <div key={n._id} className="flex items-center justify-between gap-2 py-0.5 text-xs">
            <span className="truncate">{n.hoTen ?? 'Ẩn danh'}</span>
            {hienGio && n.xemLuc && (
              <span className="shrink-0 text-[10px] text-muted-foreground">
                {nhanPhanCach(n.xemLuc)}
              </span>
            )}
          </div>
        ))}
      </div>
    );

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
      <div className="flex max-h-[70vh] w-full max-w-sm flex-col rounded-xl border bg-background shadow-lg">
        <div className="flex items-center justify-between border-b p-3">
          <h3 className="text-sm font-semibold">Chi tiết tin nhắn</h3>
          <button onClick={onDong} aria-label="Đóng">
            <X size={16} />
          </button>
        </div>

        <div className="border-b bg-muted/40 px-3 py-2">
          <p className="line-clamp-3 text-xs">{chiTiet.tinNhan.noiDung ?? '[Tệp đính kèm]'}</p>
          <p className="mt-1 text-[10px] text-muted-foreground">
            Gửi lúc {gioDayDu(chiTiet.tinNhan.ngayTao)}
          </p>
        </div>

        <div className="flex-1 overflow-y-auto">
          {nhom('Đã xem', chiTiet.daXem, true)}
          {nhom('Chưa xem', chiTiet.chuaXem, false)}
          {chiTiet.daXem.length === 0 && chiTiet.chuaXem.length === 0 && (
            <p className="p-4 text-center text-xs text-muted-foreground">
              Chưa có ai khác trong cuộc trò chuyện này.
            </p>
          )}
        </div>
      </div>
    </div>
  );
}
