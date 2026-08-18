'use client';

import { useCallback, useEffect, useState } from 'react';
import { useSession } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter, DialogDescription,
} from '@/components/ui/dialog';
import { CalendarPlus, LogOut, Loader2, RefreshCw, Inbox } from 'lucide-react';
import { toast } from 'sonner';

interface YeuCau {
  _id: string;
  hopDongId: string;
  maHopDong?: string;
  tenPhong?: string;
  tenKhachThue?: string;
  loai: 'HUY' | 'GIA_HAN' | string;
  trangThai: string;
  lyDo?: string;
  ngayMongMuon?: string;
  soThangGiaHan?: number;
  taoLuc?: string;
}

/**
 * Hang doi duyet yeu cau huy / gia han hop dong.
 *
 * Duyet HUY chi danh dau da duyet — buoc tiep theo (quyet toan tra phong, kiem ke
 * tai san, bien ban ban giao) lam trong man hinh hop dong, vi co dinh toi tien.
 */
export default function YeuCauHopDongPage() {
  const { data: session } = useSession();
  const router = useRouter();
  const accessToken = session?.accessToken as string | undefined;

  const [danhSach, setDanhSach] = useState<YeuCau[]>([]);
  const [dangTai, setDangTai] = useState(true);
  const [dangXuLy, setDangXuLy] = useState(false);
  const [chon, setChon] = useState<YeuCau | null>(null);
  const [hanhDong, setHanhDong] = useState<'duyet' | 'tu-choi' | null>(null);
  const [ghiChu, setGhiChu] = useState('');
  const [soThang, setSoThang] = useState('');
  const [giaThueMoi, setGiaThueMoi] = useState('');

  const headers = useCallback(
    (): HeadersInit => (accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
    [accessToken],
  );

  const tai = useCallback(async () => {
    if (!accessToken) return;
    setDangTai(true);
    try {
      const res = await fetch('/api/yeu-cau-hop-dong/cho-duyet', { headers: headers() });
      const json = await res.json();
      if (Array.isArray(json?.data)) setDanhSach(json.data);
    } catch {
      toast.error('Không tải được danh sách yêu cầu');
    } finally {
      setDangTai(false);
    }
  }, [accessToken, headers]);

  useEffect(() => { void tai(); }, [tai]);

  const moHopThoai = (y: YeuCau, hd: 'duyet' | 'tu-choi') => {
    setChon(y);
    setHanhDong(hd);
    setGhiChu('');
    setSoThang(y.soThangGiaHan != null ? String(y.soThangGiaHan) : '');
    setGiaThueMoi('');
  };

  const xuLy = async () => {
    if (!chon || !hanhDong) return;
    if (hanhDong === 'tu-choi' && !ghiChu.trim()) {
      toast.error('Vui lòng nhập lý do từ chối');
      return;
    }
    setDangXuLy(true);
    try {
      const body: Record<string, unknown> = { ghiChuDuyet: ghiChu };
      if (hanhDong === 'duyet' && chon.loai === 'GIA_HAN') {
        if (soThang) body.soThangGiaHan = Number(soThang);
        if (giaThueMoi) body.giaThueMoi = Number(giaThueMoi);
      }
      const res = await fetch(`/api/yeu-cau-hop-dong/${chon._id}/${hanhDong}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', ...headers() },
        body: JSON.stringify(body),
      });
      const json = await res.json();
      if (!res.ok || json?.success === false) throw new Error(json?.message || 'Xử lý thất bại');
      toast.success(json?.message || 'Đã xử lý');
      setChon(null); setHanhDong(null);
      await tai();
    } catch (e) {
      toast.error(e instanceof Error ? e.message : 'Xử lý thất bại');
    } finally {
      setDangXuLy(false);
    }
  };

  return (
    <div className="p-4 md:p-6 space-y-4">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="text-2xl font-semibold text-[#243B5A]">Yêu cầu hợp đồng</h1>
          <p className="text-sm text-muted-foreground">
            Duyệt yêu cầu hủy và gia hạn hợp đồng do khách thuê gửi.
          </p>
        </div>
        <Button variant="outline" size="sm" onClick={() => void tai()} disabled={dangTai}>
          <RefreshCw className={`h-4 w-4 mr-1 ${dangTai ? 'animate-spin' : ''}`} /> Tải mới
        </Button>
      </div>

      {dangTai ? (
        <div className="flex items-center gap-2 text-muted-foreground p-8 justify-center">
          <Loader2 className="h-5 w-5 animate-spin" /> Đang tải…
        </div>
      ) : danhSach.length === 0 ? (
        <Card>
          <CardContent className="p-10 text-center text-muted-foreground">
            <Inbox className="h-10 w-10 mx-auto mb-3 opacity-50" />
            Không có yêu cầu nào đang chờ duyệt.
          </CardContent>
        </Card>
      ) : (
        <div className="grid gap-3">
          {danhSach.map((y) => (
            <Card key={y._id}>
              <CardHeader className="pb-3">
                <div className="flex flex-wrap items-start justify-between gap-2">
                  <div>
                    <CardTitle className="text-base flex items-center gap-2">
                      {y.loai === 'HUY'
                        ? <LogOut className="h-4 w-4 text-red-600" />
                        : <CalendarPlus className="h-4 w-4 text-[#4FA7A0]" />}
                      {y.loai === 'HUY' ? 'Yêu cầu hủy hợp đồng' : 'Yêu cầu gia hạn hợp đồng'}
                    </CardTitle>
                    <CardDescription>
                      {y.maHopDong} · Phòng {y.tenPhong || '—'} · {y.tenKhachThue || '—'}
                    </CardDescription>
                  </div>
                  <Badge className="bg-amber-50 text-amber-700 border-amber-200">Chờ duyệt</Badge>
                </div>
              </CardHeader>
              <CardContent className="space-y-3 text-sm">
                {y.loai === 'GIA_HAN' && y.soThangGiaHan != null && (
                  <div>Khách xin gia hạn: <strong>{y.soThangGiaHan} tháng</strong></div>
                )}
                {y.ngayMongMuon && (
                  <div>
                    {y.loai === 'HUY' ? 'Ngày mong muốn trả phòng: ' : 'Ngày kết thúc mong muốn: '}
                    <strong>{new Date(y.ngayMongMuon).toLocaleDateString('vi-VN')}</strong>
                  </div>
                )}
                {y.lyDo && <div className="text-muted-foreground">Lý do: {y.lyDo}</div>}

                {y.loai === 'HUY' && (
                  <div className="p-2.5 rounded-lg bg-amber-50 border border-amber-200 text-amber-900 text-xs">
                    Duyệt xong vẫn cần lập quyết toán trả phòng, kiểm kê tài sản và ký biên bản
                    bàn giao thì mới chốt được tiền cọc.
                  </div>
                )}

                <div className="flex flex-wrap gap-2 pt-1">
                  <Button size="sm" onClick={() => moHopThoai(y, 'duyet')}
                    className="bg-[#4FA7A0] hover:bg-[#3D8B85] text-white text-xs h-8">
                    Duyệt
                  </Button>
                  <Button size="sm" variant="outline" onClick={() => moHopThoai(y, 'tu-choi')}
                    className="text-xs h-8 text-red-600 border-red-200 hover:bg-red-50">
                    Từ chối
                  </Button>
                  <Button size="sm" variant="ghost" className="text-xs h-8"
                    onClick={() => router.push(`/dashboard/hop-dong/${y.hopDongId}`)}>
                    Xem hợp đồng
                  </Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      <Dialog open={chon !== null} onOpenChange={(o) => { if (!o) { setChon(null); setHanhDong(null); } }}>
        <DialogContent className="sm:max-w-[480px]">
          <DialogHeader>
            <DialogTitle>
              {hanhDong === 'duyet' ? 'Duyệt yêu cầu' : 'Từ chối yêu cầu'}
            </DialogTitle>
            <DialogDescription>
              {hanhDong === 'duyet' && chon?.loai === 'GIA_HAN'
                ? 'Bạn có thể điều chỉnh số tháng và giá thuê mới trước khi duyệt. Hệ thống sẽ tạo phụ lục gia hạn.'
                : hanhDong === 'duyet'
                  ? 'Sau khi duyệt, tiến hành lập quyết toán trả phòng và biên bản bàn giao.'
                  : 'Khách thuê sẽ nhận được lý do từ chối này.'}
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-3">
            {hanhDong === 'duyet' && chon?.loai === 'GIA_HAN' && (
              <>
                <div className="space-y-1.5">
                  <Label htmlFor="soThang">Số tháng gia hạn</Label>
                  <Input id="soThang" type="number" min={1} max={60} value={soThang}
                    onChange={(e) => setSoThang(e.target.value)} />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="giaThueMoi">Giá thuê mới (để trống nếu giữ nguyên)</Label>
                  <Input id="giaThueMoi" type="number" min={0} value={giaThueMoi}
                    onChange={(e) => setGiaThueMoi(e.target.value)} placeholder="VNĐ/tháng" />
                </div>
              </>
            )}
            <div className="space-y-1.5">
              <Label htmlFor="ghiChu">
                {hanhDong === 'tu-choi' ? 'Lý do từ chối *' : 'Ghi chú'}
              </Label>
              <Textarea id="ghiChu" rows={3} value={ghiChu}
                onChange={(e) => setGhiChu(e.target.value)} />
            </div>
          </div>

          <DialogFooter>
            <Button variant="outline" type="button"
              onClick={() => { setChon(null); setHanhDong(null); }} disabled={dangXuLy}>
              Đóng
            </Button>
            <Button type="button" onClick={xuLy} disabled={dangXuLy}
              className={hanhDong === 'tu-choi'
                ? 'bg-red-600 hover:bg-red-700 text-white'
                : 'bg-[#4FA7A0] hover:bg-[#3D8B85] text-white'}>
              {dangXuLy ? 'Đang xử lý...' : hanhDong === 'tu-choi' ? 'Từ chối' : 'Duyệt'}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
