'use client';

import { useCallback, useEffect, useState } from 'react';
import {
  BellOff,
  ExternalLink,
  FileText,
  Images,
  Link2,
  Loader2,
  LogOut,
  Pencil,
  Pin,
  Search,
  X,
} from 'lucide-react';
import { nhanNgan, nhanPhanCach } from '@/lib/chat-time';
import { useThongBaoDay } from '@/hooks/use-thong-bao-day';
import type { CuocTroChuyen, LienKetChat, ThanhVienChat, TinNhan } from '@/types';

/**
 * Bảng thông tin hội thoại, mở từ nút ⓘ trên header.
 *
 * Gom mọi thứ về hội thoại vào một chỗ thay vì rải nút trên header — đúng cách
 * Messenger/Zalo/Teams làm, và giải quyết việc header không đủ chỗ.
 */

type TabDinhKem = 'IMAGE' | 'FILE' | 'LINK';

export function BangThongTin({
  hoiThoai,
  nguoiDungId,
  onDong,
  onGhim,
  onTatThongBao,
  onRoiNhom,
  timTrongHoiThoai,
  onChonKetQuaTim,
  layTepDinhKem,
  layLienKet,
  datBietDanh,
}: {
  hoiThoai: CuocTroChuyen;
  nguoiDungId?: string;
  onDong: () => void;
  onGhim: () => void;
  /** null = bật lại thông báo; số = tắt trong bấy nhiêu phút; 0 = tắt vô thời hạn. */
  onTatThongBao: (phut: number | null) => void;
  onRoiNhom: () => void;
  timTrongHoiThoai: (hoiThoaiId: string, tuKhoa: string) => Promise<TinNhan[]>;
  onChonKetQuaTim: (tin: TinNhan) => void;
  layTepDinhKem: (hoiThoaiId: string, loai: 'IMAGE' | 'FILE') => Promise<TinNhan[]>;
  layLienKet: (hoiThoaiId: string) => Promise<LienKetChat[]>;
  datBietDanh: (hoiThoaiId: string, nguoiDungIdDich: string, bietDanh: string) => Promise<void>;
}) {
  const [tab, setTab] = useState<TabDinhKem>('IMAGE');
  const [dinhKem, setDinhKem] = useState<TinNhan[]>([]);
  const [lienKets, setLienKets] = useState<LienKetChat[]>([]);
  const [dangTai, setDangTai] = useState(false);
  const [dangSuaBietDanh, setDangSuaBietDanh] = useState<string | null>(null);
  const [bietDanhMoi, setBietDanhMoi] = useState('');
  const [moMenuTat, setMoMenuTat] = useState(false);
  const [moTim, setMoTim] = useState(false);

  const laNhom =
    hoiThoai.loai === 'GROUP' || hoiThoai.loai === 'BUILDING' || hoiThoai.loai === 'FLOOR';

  const taiTab = useCallback(async () => {
    setDangTai(true);
    try {
      if (tab === 'LINK') {
        setLienKets(await layLienKet(hoiThoai._id));
      } else {
        setDinhKem(await layTepDinhKem(hoiThoai._id, tab));
      }
    } catch {
      // Không chặn cả bảng vì một tab lỗi — các mục khác vẫn dùng được.
      if (tab === 'LINK') setLienKets([]);
      else setDinhKem([]);
    } finally {
      setDangTai(false);
    }
  }, [tab, hoiThoai._id, layTepDinhKem, layLienKet]);

  useEffect(() => {
    taiTab();
  }, [taiTab]);

  return (
    <aside className="flex w-full flex-col border-l bg-background md:w-80">
      <div className="flex items-center justify-between border-b p-3">
        <h3 className="text-sm font-semibold">Thông tin cuộc trò chuyện</h3>
        <button onClick={onDong} aria-label="Đóng bảng thông tin">
          <X size={16} className="text-muted-foreground hover:text-foreground" />
        </button>
      </div>

      <div className="flex-1 overflow-y-auto">
        {/* ── Đầu bảng ── */}
        <div className="flex flex-col items-center gap-2 border-b p-4">
          <div className="flex h-14 w-14 items-center justify-center rounded-full bg-primary/10 text-lg font-semibold text-primary">
            {(hoiThoai.ten ?? '?').charAt(0).toUpperCase()}
          </div>
          <p className="text-center text-sm font-semibold">{hoiThoai.ten}</p>
          <p className="text-xs text-muted-foreground">
            {laNhom
              ? `${hoiThoai.thanhVien?.length ?? 0} thành viên`
              : hoiThoai.loai === 'SUPPORT'
                ? 'Kênh liên hệ ban quản lý'
                : 'Trò chuyện riêng'}
          </p>
        </div>

        {/* ── Hành động nhanh: gom hết nút từ header về đây ── */}
        <div className="grid grid-cols-3 gap-1 border-b p-2">
          <NutNhanh
            icon={<Pin size={16} />}
            nhan={hoiThoai.ghim ? 'Bỏ ghim' : 'Ghim'}
            dangBat={!!hoiThoai.ghim}
            onClick={onGhim}
          />
          <NutNhanh
            icon={<BellOff size={16} />}
            nhan={hoiThoai.tatThongBao ? 'Bật lại' : 'Tắt báo'}
            dangBat={!!hoiThoai.tatThongBao}
            onClick={() => (hoiThoai.tatThongBao ? onTatThongBao(null) : setMoMenuTat(true))}
          />
          <NutNhanh
            icon={<Search size={16} />}
            nhan="Tìm"
            dangBat={moTim}
            onClick={() => setMoTim((v) => !v)}
          />
        </div>

        {/* Đang tắt có hạn thì phải cho biết đến bao giờ, nếu không người dùng
            sẽ tưởng là tắt vĩnh viễn rồi quên mất. */}
        {hoiThoai.tatThongBao && hoiThoai.tatThongBaoDen && (
          <div className="border-b px-3 py-1.5 text-[11px] text-muted-foreground">
            Tắt thông báo đến {nhanPhanCach(hoiThoai.tatThongBaoDen)}
          </div>
        )}

        {moMenuTat && (
          <MenuTatThongBao
            onChon={(phut) => {
              setMoMenuTat(false);
              onTatThongBao(phut);
            }}
            onDong={() => setMoMenuTat(false)}
          />
        )}

        {/* Tìm CHỈ trong hội thoại đang mở, kết quả hiện ngay tại đây.
            Khác hẳn ô tìm ở danh sách bên trái — cái đó tìm khắp mọi hội thoại. */}
        {moTim && (
          <TimTrongHoiThoai
            hoiThoaiId={hoiThoai._id}
            timTrongHoiThoai={timTrongHoiThoai}
            onChonKetQua={onChonKetQuaTim}
          />
        )}

        <MucThongBaoDay />

        {/* ── Thành viên và biệt danh ── */}
        <div className="border-b p-3">
          <p className="mb-2 text-xs font-semibold uppercase text-muted-foreground">
            {laNhom ? 'Thành viên' : 'Biệt danh'}
          </p>
          <div className="flex flex-col gap-1">
            {(hoiThoai.thanhVien ?? []).map((tv) => (
              <MucThanhVien
                key={tv._id}
                thanhVien={tv}
                laToi={tv._id === nguoiDungId}
                dangSua={dangSuaBietDanh === tv._id}
                giaTri={bietDanhMoi}
                onBatDauSua={() => {
                  setDangSuaBietDanh(tv._id);
                  setBietDanhMoi(tv.bietDanh ?? '');
                }}
                onDoiGiaTri={setBietDanhMoi}
                onLuu={async () => {
                  await datBietDanh(hoiThoai._id, tv._id, bietDanhMoi);
                  setDangSuaBietDanh(null);
                }}
                onHuy={() => setDangSuaBietDanh(null)}
              />
            ))}
          </div>
        </div>

        {/* ── Ảnh · Tệp · Liên kết ── */}
        <div className="p-3">
          <div className="mb-2 flex gap-1">
            <NutTab dangChon={tab === 'IMAGE'} onClick={() => setTab('IMAGE')} icon={<Images size={13} />} nhan="Ảnh" />
            <NutTab dangChon={tab === 'FILE'} onClick={() => setTab('FILE')} icon={<FileText size={13} />} nhan="Tệp" />
            <NutTab dangChon={tab === 'LINK'} onClick={() => setTab('LINK')} icon={<Link2 size={13} />} nhan="Liên kết" />
          </div>

          {dangTai ? (
            <div className="flex justify-center py-6">
              <Loader2 size={16} className="animate-spin text-muted-foreground" />
            </div>
          ) : tab === 'LINK' ? (
            <DanhSachLienKet lienKets={lienKets} />
          ) : tab === 'IMAGE' ? (
            <LuoiAnh tins={dinhKem} />
          ) : (
            <DanhSachTep tins={dinhKem} />
          )}
        </div>

        {hoiThoai.loai === 'GROUP' && (
          <div className="border-t p-3">
            <button
              onClick={onRoiNhom}
              className="flex w-full items-center gap-2 rounded-lg px-2 py-2 text-sm text-destructive hover:bg-destructive/10"
            >
              <LogOut size={15} />
              Rời nhóm
            </button>
          </div>
        )}
      </div>
    </aside>
  );
}

/**
 * Bật thông báo đẩy cho trình duyệt — thứ WebSocket không làm được: nhận tin cả
 * khi đã đóng tab.
 *
 * Ẩn hẳn khi trình duyệt không hỗ trợ hoặc server chưa cấu hình khoá VAPID, thay
 * vì hiện một nút bấm vào không chạy.
 */
function MucThongBaoDay() {
  const { trangThai, bat, tat } = useThongBaoDay();

  if (trangThai === 'dang-kiem-tra' || trangThai === 'khong-ho-tro' || trangThai === 'chua-bat') {
    return null;
  }

  if (trangThai === 'bi-tu-choi') {
    return (
      <div className="border-b px-3 py-2 text-[11px] text-muted-foreground">
        Bạn đã chặn thông báo cho trang này. Muốn bật lại thì mở cài đặt quyền của
        trình duyệt — trang web không tự hỏi lại được.
      </div>
    );
  }

  const daBat = trangThai === 'da-dang-ky';
  return (
    <div className="flex items-center justify-between gap-2 border-b px-3 py-2">
      <div className="min-w-0">
        <p className="text-xs font-medium">Thông báo khi đóng tab</p>
        <p className="text-[10px] text-muted-foreground">
          {daBat ? 'Đang bật cho trình duyệt này' : 'Nhận tin cả khi không mở trang'}
        </p>
      </div>
      <button
        onClick={() => (daBat ? tat() : bat().catch((e) => alert(e.message)))}
        className={`shrink-0 rounded-md px-2 py-1 text-xs ${
          daBat ? 'bg-muted text-muted-foreground' : 'bg-primary text-primary-foreground'
        }`}
      >
        {daBat ? 'Tắt' : 'Bật'}
      </button>
    </div>
  );
}

/**
 * Các mốc thời gian tắt thông báo, lấy theo Messenger.
 *
 * Có mốc ngắn (15 phút) là vì nhu cầu thật hay gặp: đang họp, đang ngủ trưa —
 * chỉ cần yên tĩnh một lát chứ không phải tắt hẳn rồi quên bật lại.
 */
const CAC_MOC_TAT: Array<{ phut: number; nhan: string }> = [
  { phut: 15, nhan: '15 phút' },
  { phut: 60, nhan: '1 giờ' },
  { phut: 480, nhan: '8 giờ' },
  { phut: 1440, nhan: '24 giờ' },
  { phut: 0, nhan: 'Đến khi tôi bật lại' },
];

function MenuTatThongBao({
  onChon,
  onDong,
}: {
  onChon: (phut: number) => void;
  onDong: () => void;
}) {
  return (
    <div className="border-b bg-muted/30 p-2">
      <div className="mb-1 flex items-center justify-between px-1">
        <span className="text-[11px] font-semibold uppercase text-muted-foreground">
          Tắt thông báo trong
        </span>
        <button onClick={onDong} aria-label="Đóng">
          <X size={12} className="text-muted-foreground" />
        </button>
      </div>
      <div className="flex flex-col">
        {CAC_MOC_TAT.map((m) => (
          <button
            key={m.phut}
            onClick={() => onChon(m.phut)}
            className="rounded-md px-2 py-1.5 text-left text-xs hover:bg-muted"
          >
            {m.nhan}
          </button>
        ))}
      </div>
    </div>
  );
}

/**
 * Tìm trong RIÊNG hội thoại đang mở, kết quả hiện tại chỗ.
 *
 * Tách hẳn khỏi ô tìm ở danh sách bên trái: cái đó tìm khắp mọi hội thoại và mọi
 * người. Người dùng đang mở một cuộc trò chuyện thì thường muốn tìm trong đúng
 * cuộc đó, đẩy họ ra danh sách chung là bắt họ lọc lại bằng mắt.
 */
function TimTrongHoiThoai({
  hoiThoaiId,
  timTrongHoiThoai,
  onChonKetQua,
}: {
  hoiThoaiId: string;
  timTrongHoiThoai: (hoiThoaiId: string, tuKhoa: string) => Promise<TinNhan[]>;
  onChonKetQua: (tin: TinNhan) => void;
}) {
  const [tuKhoa, setTuKhoa] = useState('');
  const [ketQua, setKetQua] = useState<TinNhan[]>([]);
  const [dangTim, setDangTim] = useState(false);

  useEffect(() => {
    const tk = tuKhoa.trim();
    if (tk.length < 2) {
      setKetQua([]);
      return;
    }
    let huy = false;
    setDangTim(true);
    // Chờ 300ms rồi mới gọi: gõ 10 ký tự mà bắn 10 request thì vừa phí vừa dễ
    // nhận kết quả về sai thứ tự.
    const timer = setTimeout(() => {
      timTrongHoiThoai(hoiThoaiId, tk)
        .then((kq) => !huy && setKetQua(kq))
        .catch(() => !huy && setKetQua([]))
        .finally(() => !huy && setDangTim(false));
    }, 300);
    return () => {
      huy = true;
      clearTimeout(timer);
    };
  }, [tuKhoa, hoiThoaiId, timTrongHoiThoai]);

  return (
    <div className="border-b p-2">
      <div className="mb-1 flex items-center gap-2 rounded-lg border bg-background px-2 py-1.5">
        <Search size={13} className="shrink-0 text-muted-foreground" />
        <input
          value={tuKhoa}
          onChange={(e) => setTuKhoa(e.target.value)}
          placeholder="Tìm trong cuộc trò chuyện này…"
          autoFocus
          className="min-w-0 flex-1 bg-transparent text-xs outline-none"
        />
        {dangTim && <Loader2 size={12} className="animate-spin text-muted-foreground" />}
      </div>

      {tuKhoa.trim().length >= 2 && !dangTim && ketQua.length === 0 && (
        <p className="px-1 py-2 text-[11px] text-muted-foreground">Không tìm thấy tin nào.</p>
      )}

      <div className="max-h-56 overflow-y-auto">
        {ketQua.map((t) => (
          <button
            key={t._id}
            onClick={() => onChonKetQua(t)}
            className="flex w-full flex-col gap-0.5 rounded-md px-2 py-1.5 text-left hover:bg-muted"
          >
            <span className="flex items-baseline justify-between gap-2">
              <span className="truncate text-[11px] font-medium">{t.tenNguoiGui}</span>
              <span className="shrink-0 text-[10px] text-muted-foreground">{nhanNgan(t.ngayTao)}</span>
            </span>
            <span className="line-clamp-2 text-[11px] text-muted-foreground">{t.noiDung}</span>
          </button>
        ))}
      </div>
    </div>
  );
}

function NutNhanh({
  icon,
  nhan,
  dangBat,
  onClick,
}: {
  icon: React.ReactNode;
  nhan: string;
  dangBat?: boolean;
  onClick: () => void;
}) {
  return (
    <button
      onClick={onClick}
      className={`flex flex-col items-center gap-1 rounded-lg px-1 py-2 text-[11px] hover:bg-muted ${
        dangBat ? 'text-primary' : 'text-muted-foreground'
      }`}
    >
      {icon}
      <span className="truncate">{nhan}</span>
    </button>
  );
}

function NutTab({
  dangChon,
  onClick,
  icon,
  nhan,
}: {
  dangChon: boolean;
  onClick: () => void;
  icon: React.ReactNode;
  nhan: string;
}) {
  return (
    <button
      onClick={onClick}
      className={`flex flex-1 items-center justify-center gap-1 rounded-md px-2 py-1.5 text-xs ${
        dangChon ? 'bg-primary text-primary-foreground' : 'bg-muted text-muted-foreground hover:bg-muted/70'
      }`}
    >
      {icon}
      {nhan}
    </button>
  );
}

function MucThanhVien({
  thanhVien,
  laToi,
  dangSua,
  giaTri,
  onBatDauSua,
  onDoiGiaTri,
  onLuu,
  onHuy,
}: {
  thanhVien: ThanhVienChat;
  laToi: boolean;
  dangSua: boolean;
  giaTri: string;
  onBatDauSua: () => void;
  onDoiGiaTri: (v: string) => void;
  onLuu: () => void;
  onHuy: () => void;
}) {
  if (dangSua) {
    return (
      <div className="flex items-center gap-1 rounded-lg bg-muted/50 p-1.5">
        <input
          value={giaTri}
          onChange={(e) => onDoiGiaTri(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === 'Enter') onLuu();
            if (e.key === 'Escape') onHuy();
          }}
          placeholder="Để trống để xoá biệt danh"
          autoFocus
          className="min-w-0 flex-1 rounded border bg-background px-2 py-1 text-xs outline-none"
        />
        <button onClick={onLuu} className="rounded px-2 py-1 text-xs text-primary hover:bg-muted">
          Lưu
        </button>
        <button onClick={onHuy} className="rounded px-1 py-1 text-muted-foreground hover:bg-muted">
          <X size={12} />
        </button>
      </div>
    );
  }

  return (
    <div className="group flex items-center gap-2 rounded-lg px-1.5 py-1.5 hover:bg-muted/50">
      <div className="flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-primary/10 text-[11px] font-semibold text-primary">
        {(thanhVien.bietDanh ?? thanhVien.hoTen ?? '?').charAt(0).toUpperCase()}
      </div>
      <div className="min-w-0 flex-1">
        <p className="truncate text-xs font-medium">
          {thanhVien.bietDanh ?? thanhVien.hoTen}
          {laToi && <span className="ml-1 text-muted-foreground">(bạn)</span>}
        </p>
        {/* Còn hiện tên gốc khi có biệt danh, để không ai bị lẫn danh tính. */}
        {thanhVien.bietDanh && (
          <p className="truncate text-[10px] text-muted-foreground">{thanhVien.hoTen}</p>
        )}
      </div>
      <button
        onClick={onBatDauSua}
        title="Đặt biệt danh"
        className="shrink-0 rounded p-1 text-muted-foreground opacity-0 transition-opacity hover:bg-muted group-hover:opacity-100"
      >
        <Pencil size={12} />
      </button>
    </div>
  );
}

/*
 * Ảnh, tệp và liên kết đều mở NGAY TRONG TAB HIỆN TẠI (không target="_blank").
 * Không đặt rel="noopener noreferrer" vì rel đó chỉ có tác dụng khi mở tab mới.
 */

function LuoiAnh({ tins }: { tins: TinNhan[] }) {
  if (tins.length === 0) {
    return <p className="py-4 text-center text-xs text-muted-foreground">Chưa có ảnh nào.</p>;
  }
  return (
    <div className="grid grid-cols-3 gap-1">
      {tins.map((t) => (
        <a key={t._id} href={t.fileUrl} title={nhanNgan(t.ngayTao)}>
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src={t.fileUrl} alt="" className="aspect-square w-full rounded object-cover" />
        </a>
      ))}
    </div>
  );
}

function DanhSachTep({ tins }: { tins: TinNhan[] }) {
  if (tins.length === 0) {
    return <p className="py-4 text-center text-xs text-muted-foreground">Chưa có tệp nào.</p>;
  }
  return (
    <div className="flex flex-col gap-1">
      {tins.map((t) => (
        <a
          key={t._id}
          href={t.fileUrl}
          className="flex items-center gap-2 rounded-lg px-1.5 py-1.5 hover:bg-muted/60"
        >
          <FileText size={15} className="shrink-0 text-muted-foreground" />
          <div className="min-w-0 flex-1">
            <p className="truncate text-xs">{t.noiDung || 'Tệp đính kèm'}</p>
            <p className="text-[10px] text-muted-foreground">
              {t.tenNguoiGui} · {nhanNgan(t.ngayTao)}
            </p>
          </div>
        </a>
      ))}
    </div>
  );
}

function DanhSachLienKet({ lienKets }: { lienKets: LienKetChat[] }) {
  if (lienKets.length === 0) {
    return <p className="py-4 text-center text-xs text-muted-foreground">Chưa có liên kết nào.</p>;
  }
  return (
    <div className="flex flex-col gap-1">
      {lienKets.map((lk, i) => (
        <a
          key={`${lk.tinNhanId}-${i}`}
          href={lk.url}
          className="flex items-center gap-2 rounded-lg px-1.5 py-1.5 hover:bg-muted/60"
        >
          <ExternalLink size={14} className="shrink-0 text-muted-foreground" />
          <div className="min-w-0 flex-1">
            <p className="truncate text-xs text-primary underline underline-offset-2">{lk.url}</p>
            <p className="text-[10px] text-muted-foreground">
              {lk.tenNguoiGui} · {nhanNgan(lk.ngayGui)}
            </p>
          </div>
        </a>
      ))}
    </div>
  );
}
