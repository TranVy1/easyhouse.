'use client';

import { useEffect, useState } from 'react';
import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { HopDong } from '@/types';
import { Loader2, Plus, Trash2 } from 'lucide-react';
import { toast } from 'sonner';

interface CheckoutModalProps {
  hopDong: HopDong | null;
  isOpen: boolean;
  onClose: () => void;
  onSuccess: (updatedHopDong: any) => void;
  accessToken?: string;
}

type KhoanKhauTru = { moTa: string; soTien: number; chungTuUrl: string };
type QuyetToan = {
  trangThai: string;
  hoaDon: { _id: string; maHoaDon: string; tongTien: number; trangThai: string; chiTietHoaDon?: Array<{ moTa: string; thanhTien: number }> };
  tienCocBanDau: number;
  tienCocDaCanTru: number;
  tienCocCanHoan: number;
  tienPhaiThuThem: number;
  banGiaoDaXacNhan: boolean;
  veSinhKiemTraXong: boolean;
};

const money = (value?: number) => Number(value || 0).toLocaleString('vi-VN') + ' đ';

export function CheckoutModal({ hopDong, isOpen, onClose, onSuccess, accessToken }: CheckoutModalProps) {
  const [loading, setLoading] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [quyetToan, setQuyetToan] = useState<QuyetToan | null>(null);
  const [chiSoDienBanDau, setChiSoDienBanDau] = useState(0);
  const [chiSoNuocBanDau, setChiSoNuocBanDau] = useState(0);
  const [chiSoDienCuoiKy, setChiSoDienCuoiKy] = useState(0);
  const [chiSoNuocCuoiKy, setChiSoNuocCuoiKy] = useState(0);
  const [khoanKhauTru, setKhoanKhauTru] = useState<KhoanKhauTru[]>([]);
  const [daHoanCoc, setDaHoanCoc] = useState(false);
  const [banGiaoDaXacNhan, setBanGiaoDaXacNhan] = useState(false);
  const [veSinhKiemTraXong, setVeSinhKiemTraXong] = useState(false);

  const headers = accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined;

  useEffect(() => {
    if (!isOpen || !hopDong?._id) return;
    setQuyetToan(null);
    setKhoanKhauTru([]);
    setDaHoanCoc(false);
    setBanGiaoDaXacNhan(false);
    setVeSinhKiemTraXong(false);
    void load();
  }, [isOpen, hopDong?._id]);

  const load = async () => {
    if (!hopDong?._id) return;
    setLoading(true);
    try {
      const [readingResponse, settlementResponse] = await Promise.all([
        fetch(`/api/hoa-don/latest-reading?hopDongId=${hopDong._id}&thang=${new Date().getMonth() + 1}&nam=${new Date().getFullYear()}`, { headers }),
        fetch(`/api/hop-dong/${hopDong._id}/quyet-toan-tra-phong`, { headers }),
      ]);
      const reading = await readingResponse.json();
      if (readingResponse.ok && reading.success) {
        setChiSoDienBanDau(reading.data?.chiSoDienBanDau || 0);
        setChiSoNuocBanDau(reading.data?.chiSoNuocBanDau || 0);
      }
      if (settlementResponse.ok) {
        const result = await settlementResponse.json();
        if (result.success) setQuyetToan(result.data);
      }
    } catch {
      toast.error('Không thể tải dữ liệu trả phòng');
    } finally {
      setLoading(false);
    }
  };

  const createSettlement = async () => {
    if (!hopDong?._id) return;
    if (chiSoDienCuoiKy < chiSoDienBanDau || chiSoNuocCuoiKy < chiSoNuocBanDau) {
      toast.error('Chỉ số cuối kỳ không được nhỏ hơn chỉ số đầu kỳ');
      return;
    }
    if (khoanKhauTru.some(item => !item.moTa.trim() || item.soTien <= 0 || !item.chungTuUrl.trim())) {
      toast.error('Mỗi khoản khấu trừ phải có mô tả, số tiền và chứng từ');
      return;
    }
    setSubmitting(true);
    try {
      const response = await fetch(`/api/hop-dong/${hopDong._id}/quyet-toan-tra-phong`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', ...(headers || {}) },
        body: JSON.stringify({
          ngayTraPhong: new Date().toISOString().slice(0, 10),
          chiSoDienBanDau, chiSoDienCuoiKy, chiSoNuocBanDau, chiSoNuocCuoiKy, khoanKhauTru,
          ghiChu: 'Lập quyết toán trả phòng qua hệ thống',
        }),
      });
      const result = await response.json();
      if (!response.ok || !result.success) throw new Error(result.message);
      setQuyetToan(result.data);
      toast.success('Đã lập hóa đơn quyết toán. Không có khoản cọc nào bị mất.');
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Không thể lập quyết toán');
    } finally {
      setSubmitting(false);
    }
  };

  const completeCheckout = async () => {
    if (!hopDong?._id || !quyetToan) return;
    setSubmitting(true);
    try {
      const response = await fetch(`/api/hop-dong/${hopDong._id}/quyet-toan-tra-phong/hoan-tat`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', ...(headers || {}) },
        body: JSON.stringify({ daHoanCoc, banGiaoDaXacNhan, veSinhKiemTraXong }),
      });
      const result = await response.json();
      if (!response.ok || !result.success) throw new Error(result.message);
      toast.success('Đã hoàn tất trả phòng và giải phóng phòng');
      onSuccess(result.data);
      onClose();
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Không thể hoàn tất trả phòng');
    } finally {
      setSubmitting(false);
    }
  };

  const addDeduction = () => setKhoanKhauTru(items => [...items, { moTa: '', soTien: 0, chungTuUrl: '' }]);
  const updateDeduction = (index: number, patch: Partial<KhoanKhauTru>) => setKhoanKhauTru(items => items.map((item, i) => i === index ? { ...item, ...patch } : item));

  return <Dialog open={isOpen} onOpenChange={open => !open && !submitting && onClose()}>
    <DialogContent className="sm:max-w-[620px] max-h-[90vh] overflow-y-auto">
      <DialogHeader>
        <DialogTitle>Quyết toán trả phòng: {hopDong?.maHopDong}</DialogTitle>
        <DialogDescription>{quyetToan ? 'Số tiền do máy chủ tính; chỉ hoàn tất sau thanh toán, hoàn cọc và bàn giao.' : 'Nhập chỉ số cuối kỳ và các khoản khấu trừ có chứng từ.'}</DialogDescription>
      </DialogHeader>

      {loading ? <div className="py-8 flex justify-center"><Loader2 className="animate-spin" /></div> : !quyetToan ? <div className="space-y-5 py-2">
        <div className="grid grid-cols-2 gap-3">
          <div><Label>Chỉ số điện đầu / cuối</Label><div className="mt-2 grid grid-cols-2 gap-2"><Input value={chiSoDienBanDau} disabled /><Input type="number" min={chiSoDienBanDau} value={chiSoDienCuoiKy} onChange={e => setChiSoDienCuoiKy(Number(e.target.value))} /></div></div>
          <div><Label>Chỉ số nước đầu / cuối</Label><div className="mt-2 grid grid-cols-2 gap-2"><Input value={chiSoNuocBanDau} disabled /><Input type="number" min={chiSoNuocBanDau} value={chiSoNuocCuoiKy} onChange={e => setChiSoNuocCuoiKy(Number(e.target.value))} /></div></div>
        </div>
        <div className="space-y-3 rounded-md border p-3">
          <div className="flex items-center justify-between"><Label>Khoản khấu trừ cọc có chứng từ</Label><Button size="sm" variant="outline" onClick={addDeduction}><Plus className="mr-1 h-4 w-4" />Thêm khoản</Button></div>
          {khoanKhauTru.length === 0 && <p className="text-sm text-muted-foreground">Không có khoản nào thì toàn bộ cọc còn dư sẽ được hoàn theo quyết toán.</p>}
          {khoanKhauTru.map((item, index) => <div className="grid grid-cols-[1fr_110px_1fr_auto] gap-2" key={index}>
            <Input placeholder="Nội dung" value={item.moTa} onChange={e => updateDeduction(index, { moTa: e.target.value })} />
            <Input type="number" min="1" placeholder="Số tiền" value={item.soTien || ''} onChange={e => updateDeduction(index, { soTien: Number(e.target.value) })} />
            <Input placeholder="URL/mã chứng từ" value={item.chungTuUrl} onChange={e => updateDeduction(index, { chungTuUrl: e.target.value })} />
            <Button size="icon" variant="ghost" onClick={() => setKhoanKhauTru(items => items.filter((_, i) => i !== index))}><Trash2 className="h-4 w-4" /></Button>
          </div>)}
        </div>
      </div> : <div className="space-y-4 py-2 text-sm">
        <div className="rounded-md border bg-muted/40 p-3 space-y-2">
          <div className="flex justify-between font-medium"><span>Hóa đơn quyết toán {quyetToan.hoaDon.maHoaDon}</span><span>{money(quyetToan.hoaDon.tongTien)}</span></div>
          <div className="flex justify-between"><span>Trạng thái hóa đơn</span><span>{quyetToan.hoaDon.trangThai}</span></div>
          {quyetToan.hoaDon.chiTietHoaDon?.map((item, index) => <div className="flex justify-between text-muted-foreground" key={index}><span>{item.moTa}</span><span>{money(item.thanhTien)}</span></div>)}
        </div>
        <div className="rounded-md border border-blue-200 bg-blue-50 p-3 space-y-2">
          <div className="flex justify-between"><span>Cọc ban đầu</span><span>{money(quyetToan.tienCocBanDau)}</span></div>
          <div className="flex justify-between"><span>Cấn trừ vào hóa đơn có chứng từ</span><span>- {money(quyetToan.tienCocDaCanTru)}</span></div>
          <div className="flex justify-between font-semibold"><span>Phải hoàn lại khách</span><span>{money(quyetToan.tienCocCanHoan)}</span></div>
          {quyetToan.tienPhaiThuThem > 0 && <div className="flex justify-between font-semibold text-red-700"><span>Khách cần thanh toán thêm</span><span>{money(quyetToan.tienPhaiThuThem)}</span></div>}
        </div>
        <p className="text-muted-foreground">Nếu khách cần đóng thêm, hãy ghi nhận thanh toán đủ cho hóa đơn trên trước khi bấm hoàn tất.</p>
        {quyetToan.tienCocCanHoan > 0 && <div className="flex gap-2 items-center"><Checkbox id="refund" checked={daHoanCoc} onCheckedChange={value => setDaHoanCoc(value === true)} /><Label htmlFor="refund">Đã hoàn phần cọc dư cho khách</Label></div>}
        <div className="flex gap-2 items-center"><Checkbox id="handover" checked={banGiaoDaXacNhan} onCheckedChange={value => setBanGiaoDaXacNhan(value === true)} /><Label htmlFor="handover">Đã bàn giao phòng</Label></div>
        <div className="flex gap-2 items-center"><Checkbox id="inspection" checked={veSinhKiemTraXong} onCheckedChange={value => setVeSinhKiemTraXong(value === true)} /><Label htmlFor="inspection">Đã vệ sinh và kiểm tra hoàn tất</Label></div>
      </div>}

      <DialogFooter>
        <Button variant="outline" onClick={onClose} disabled={submitting}>Đóng</Button>
        {!quyetToan ? <Button onClick={createSettlement} disabled={submitting}>{submitting && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}Lập quyết toán</Button> : <Button onClick={completeCheckout} disabled={submitting}>{submitting && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}Hoàn tất trả phòng</Button>}
      </DialogFooter>
    </DialogContent>
  </Dialog>;
}
