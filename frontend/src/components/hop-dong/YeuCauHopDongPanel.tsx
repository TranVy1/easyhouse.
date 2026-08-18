'use client';

import { useCallback, useEffect, useState } from 'react';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter, DialogDescription,
} from '@/components/ui/dialog';
import { AlertCircle, CalendarPlus, Clock, CheckCircle2, XCircle, LogOut } from 'lucide-react';
import { toast } from 'sonner';

export interface YeuCauHopDong {
  _id: string;
  loai: 'HUY' | 'GIA_HAN' | string;
  trangThai: 'CHO_DUYET' | 'DA_DUYET' | 'TU_CHOI' | 'DA_HUY_YEU_CAU' | string;
  lyDo?: string;
  ngayMongMuon?: string;
  soThangGiaHan?: number;
  ghiChuDuyet?: string;
  taoLuc?: string;
}

interface Props {
  hopDongId: string;
  /** Chi cho gui yeu cau khi hop dong dang hieu luc. */
  trangThaiHopDong?: string;
  accessToken?: string;
  onChanged?: () => void;
}

const nhanLoai = (loai: string) => (loai === 'HUY' ? 'Hủy hợp đồng' : 'Gia hạn hợp đồng');

/**
 * Khach thue gui yeu cau huy / gia han hop dong va theo doi trang thai duyet.
 *
 * Backend chi cho phep MOT yeu cau CHO_DUYET tren mot hop dong (unique partial
 * index), nen khi dang co yeu cau cho duyet thi an nut gui moi.
 */
export function YeuCauHopDongPanel({ hopDongId, trangThaiHopDong, accessToken, onChanged }: Props) {
  const [danhSach, setDanhSach] = useState<YeuCauHopDong[]>([]);
  const [dangMo, setDangMo] = useState<'HUY' | 'GIA_HAN' | null>(null);
  const [dangGui, setDangGui] = useState(false);
  const [lyDo, setLyDo] = useState('');
  const [ngayMongMuon, setNgayMongMuon] = useState('');
  const [soThang, setSoThang] = useState('6');

  const headers = useCallback(
    (): HeadersInit => (accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
    [accessToken],
  );

  const tai = useCallback(async () => {
    try {
      const res = await fetch(`/api/hop-dong/${hopDongId}/yeu-cau`, { headers: headers() });
      if (!res.ok) return;
      const json = await res.json();
      if (Array.isArray(json?.data)) setDanhSach(json.data);
    } catch {
      // Khong chan giao dien neu tai that bai.
    }
  }, [hopDongId, headers]);

  useEffect(() => { void tai(); }, [tai]);

  const choDuyet = danhSach.find((y) => y.trangThai === 'CHO_DUYET');
  const guiDuoc = trangThaiHopDong === 'ACTIVE' && !choDuyet;

  const gui = async () => {
    if (!dangMo) return;
    setDangGui(true);
    try {
      const body: Record<string, unknown> = { loai: dangMo, lyDo };
      if (dangMo === 'HUY') {
        if (!ngayMongMuon) { toast.error('Vui lòng chọn ngày mong muốn trả phòng'); return; }
        body.ngayMongMuon = ngayMongMuon;
      } else {
        const n = Number(soThang);
        if (!n || n <= 0) { toast.error('Vui lòng nhập số tháng gia hạn'); return; }
        body.soThangGiaHan = n;
      }
      const res = await fetch(`/api/hop-dong/${hopDongId}/yeu-cau`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', ...headers() },
        body: JSON.stringify(body),
      });
      const json = await res.json();
      if (!res.ok || json?.success === false) throw new Error(json?.message || 'Gửi yêu cầu thất bại');
      toast.success(json?.message || 'Đã gửi yêu cầu');
      setDangMo(null); setLyDo(''); setNgayMongMuon('');
      await tai();
      onChanged?.();
    } catch (e) {
      toast.error(e instanceof Error ? e.message : 'Gửi yêu cầu thất bại');
    } finally {
      setDangGui(false);
    }
  };

  const rutLai = async (id: string) => {
    try {
      const res = await fetch(`/api/yeu-cau-hop-dong/${id}/rut-lai`, {
        method: 'POST', headers: headers(),
      });
      const json = await res.json();
      if (!res.ok || json?.success === false) throw new Error(json?.message || 'Không rút lại được');
      toast.success('Đã rút lại yêu cầu');
      await tai();
      onChanged?.();
    } catch (e) {
      toast.error(e instanceof Error ? e.message : 'Không rút lại được');
    }
  };

  const badge = (tt: string) => {
    switch (tt) {
      case 'CHO_DUYET':
        return <Badge className="bg-amber-50 text-amber-700 border-amber-200 flex items-center gap-1">
          <Clock className="h-3 w-3" /> Chờ chủ trọ duyệt</Badge>;
      case 'DA_DUYET':
        return <Badge className="bg-emerald-50 text-emerald-700 border-emerald-200 flex items-center gap-1">
          <CheckCircle2 className="h-3 w-3" /> Đã duyệt</Badge>;
      case 'TU_CHOI':
        return <Badge variant="destructive" className="flex items-center gap-1">
          <XCircle className="h-3 w-3" /> Bị từ chối</Badge>;
      default:
        return <Badge variant="outline">Đã rút lại</Badge>;
    }
  };

  return (
    <div className="space-y-3">
      <div className="flex flex-wrap items-center gap-2">
        <Button
          size="sm" variant="outline" type="button"
          disabled={!guiDuoc}
          title={!guiDuoc ? 'Hợp đồng phải đang hiệu lực và không có yêu cầu nào đang chờ duyệt' : undefined}
          onClick={() => setDangMo('GIA_HAN')}
          className="text-xs h-8"
        >
          <CalendarPlus className="h-3.5 w-3.5 mr-1" /> Yêu cầu gia hạn
        </Button>
        <Button
          size="sm" variant="outline" type="button"
          disabled={!guiDuoc}
          title={!guiDuoc ? 'Hợp đồng phải đang hiệu lực và không có yêu cầu nào đang chờ duyệt' : undefined}
          onClick={() => setDangMo('HUY')}
          className="text-xs h-8 text-red-600 border-red-200 hover:bg-red-50"
        >
          <LogOut className="h-3.5 w-3.5 mr-1" /> Yêu cầu hủy hợp đồng
        </Button>
      </div>

      {choDuyet && (
        <div className="flex gap-3 p-3 border border-amber-200 bg-amber-50 rounded-xl text-sm">
          <AlertCircle className="h-5 w-5 text-amber-600 shrink-0 mt-0.5" />
          <div className="flex-1">
            <p className="font-semibold text-amber-900">
              Bạn đang có một yêu cầu {nhanLoai(choDuyet.loai).toLowerCase()} chờ duyệt
            </p>
            <p className="text-amber-800 mt-0.5">
              Chủ trọ sẽ phản hồi sớm. Với yêu cầu hủy, hai bên cần lập biên bản bàn giao
              trước khi chốt tiền cọc.
            </p>
            <Button size="sm" variant="ghost" type="button"
              onClick={() => rutLai(choDuyet._id)}
              className="mt-2 h-7 text-xs text-amber-900 hover:bg-amber-100">
              Rút lại yêu cầu
            </Button>
          </div>
        </div>
      )}

      {danhSach.length > 0 && (
        <div className="border rounded-xl divide-y">
          {danhSach.map((y) => (
            <div key={y._id} className="p-3 text-sm flex flex-wrap items-start justify-between gap-2">
              <div>
                <div className="font-medium text-[#243B5A]">{nhanLoai(y.loai)}</div>
                {y.loai === 'GIA_HAN' && y.soThangGiaHan != null && (
                  <div className="text-muted-foreground">Xin gia hạn {y.soThangGiaHan} tháng</div>
                )}
                {y.ngayMongMuon && (
                  <div className="text-muted-foreground">
                    {y.loai === 'HUY' ? 'Ngày mong muốn trả phòng: ' : 'Ngày kết thúc mong muốn: '}
                    {new Date(y.ngayMongMuon).toLocaleDateString('vi-VN')}
                  </div>
                )}
                {y.lyDo && <div className="text-muted-foreground">Lý do: {y.lyDo}</div>}
                {y.ghiChuDuyet && (
                  <div className="text-muted-foreground">Phản hồi từ chủ trọ: {y.ghiChuDuyet}</div>
                )}
              </div>
              {badge(y.trangThai)}
            </div>
          ))}
        </div>
      )}

      <Dialog open={dangMo !== null} onOpenChange={(o) => !o && setDangMo(null)}>
        <DialogContent className="sm:max-w-[480px]">
          <DialogHeader>
            <DialogTitle>{dangMo ? nhanLoai(dangMo) : ''}</DialogTitle>
            <DialogDescription>
              {dangMo === 'HUY'
                ? 'Yêu cầu sẽ được gửi tới chủ trọ. Sau khi duyệt, hai bên lập biên bản bàn giao và kiểm kê tài sản trước khi chốt tiền cọc.'
                : 'Chủ trọ có thể điều chỉnh số tháng và giá thuê mới khi duyệt yêu cầu của bạn.'}
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-3">
            {dangMo === 'HUY' ? (
              <div className="space-y-1.5">
                <Label htmlFor="ngayMongMuon">Ngày mong muốn trả phòng <span className="text-red-500">*</span></Label>
                <Input id="ngayMongMuon" type="date" value={ngayMongMuon}
                  onChange={(e) => setNgayMongMuon(e.target.value)} />
              </div>
            ) : (
              <div className="space-y-1.5">
                <Label htmlFor="soThang">Số tháng muốn gia hạn <span className="text-red-500">*</span></Label>
                <Input id="soThang" type="number" min={1} max={60} value={soThang}
                  onChange={(e) => setSoThang(e.target.value)} />
              </div>
            )}
            <div className="space-y-1.5">
              <Label htmlFor="lyDo">Lý do</Label>
              <Textarea id="lyDo" rows={3} value={lyDo} onChange={(e) => setLyDo(e.target.value)}
                placeholder={dangMo === 'HUY' ? 'Ví dụ: chuyển công tác…' : 'Ví dụ: muốn ở thêm…'} />
            </div>
          </div>

          <DialogFooter>
            <Button variant="outline" type="button" onClick={() => setDangMo(null)} disabled={dangGui}>Đóng</Button>
            <Button type="button" onClick={gui} disabled={dangGui}
              className="bg-[#4FA7A0] hover:bg-[#3D8B85] text-white">
              {dangGui ? 'Đang gửi...' : 'Gửi yêu cầu'}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
