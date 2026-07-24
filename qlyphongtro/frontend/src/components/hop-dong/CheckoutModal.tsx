'use client';

import { useState, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { HopDong } from '@/types';
import { toast } from 'sonner';
import { Loader2 } from 'lucide-react';

interface CheckoutModalProps {
  hopDong: HopDong | null;
  isOpen: boolean;
  onClose: () => void;
  onSuccess: (updatedHopDong: any) => void;
  accessToken?: string;
}

export function CheckoutModal({ hopDong, isOpen, onClose, onSuccess, accessToken }: CheckoutModalProps) {
  const [step, setStep] = useState(1);
  const [loading, setLoading] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  
  const [data, setData] = useState({
    chiSoDienBanDau: 0,
    chiSoNuocBanDau: 0,
    chiSoDienCuoiKy: 0,
    chiSoNuocCuoiKy: 0,
    tienPhong: 0,
    giaDien: 0,
    giaNuoc: 0,
    tienDichVu: 0,
  });

  useEffect(() => {
    if (isOpen && hopDong) {
      setStep(1);
      setData(prev => ({ ...prev, chiSoDienCuoiKy: 0, chiSoNuocCuoiKy: 0 }));
      fetchInitialData();
    }
  }, [isOpen, hopDong]);

  const fetchInitialData = async () => {
    if (!hopDong) return;
    setLoading(true);
    try {
      // Get latest readings
      const now = new Date();
      const res = await fetch(`/api/hoa-don/latest-reading?hopDongId=${hopDong._id}&thang=${now.getMonth() + 1}&nam=${now.getFullYear()}`, {
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      });
      const result = await res.json();
      if (res.ok && result.success) {
        setData(prev => ({
          ...prev,
          chiSoDienBanDau: result.data?.chiSoDienBanDau || 0,
          chiSoNuocBanDau: result.data?.chiSoNuocBanDau || 0,
          tienPhong: hopDong.giaThue || 0,
          giaDien: hopDong.giaDien || 0,
          giaNuoc: hopDong.giaNuoc || 0,
          tienDichVu: hopDong.phiDichVu?.reduce((sum: number, dv: any) => sum + (dv.gia || 0), 0) || 0,
        }));
      }
    } catch (error) {
      console.error('Lỗi lấy chỉ số', error);
    } finally {
      setLoading(false);
    }
  };

  const handleNext = () => {
    if (data.chiSoDienCuoiKy < data.chiSoDienBanDau) {
      toast.error('Chỉ số điện cuối phải lớn hơn hoặc bằng chỉ số ban đầu');
      return;
    }
    if (data.chiSoNuocCuoiKy < data.chiSoNuocBanDau) {
      toast.error('Chỉ số nước cuối phải lớn hơn hoặc bằng chỉ số ban đầu');
      return;
    }
    setStep(2);
  };

  const tienDien = (data.chiSoDienCuoiKy - data.chiSoDienBanDau) * data.giaDien;
  const tienNuoc = (data.chiSoNuocCuoiKy - data.chiSoNuocBanDau) * data.giaNuoc;
  const tongTienHoaDon = data.tienPhong + tienDien + tienNuoc + data.tienDichVu;
  const tienCoc = hopDong?.tienCoc || 0;
  
  const soTienKhauTru = Math.min(tienCoc, tongTienHoaDon);
  const soTienHoanTra = tienCoc - soTienKhauTru;
  const phaiThuThem = tongTienHoaDon - soTienKhauTru;

  const handleSubmit = async () => {
    if (!hopDong) return;
    setSubmitting(true);
    try {
      const response = await fetch(`/api/hop-dong/${hopDong._id}/ket-thuc`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
        },
        body: JSON.stringify({
          ngayKetThucThucTe: new Date().toISOString().split('T')[0],
          chiSoDienCuoiKy: data.chiSoDienCuoiKy,
          chiSoNuocCuoiKy: data.chiSoNuocCuoiKy,
          soTienKhauTru,
          soTienHoanTra,
          ghiChu: 'Thanh lý hợp đồng qua hệ thống',
        }),
      });
      const result = await response.json();
      if (response.ok && result.success) {
        toast.success('Đã thanh lý hợp đồng thành công');
        onSuccess(result.data);
        onClose();
      } else {
        toast.error(result.message || 'Lỗi thanh lý hợp đồng');
      }
    } catch (error) {
      toast.error('Có lỗi xảy ra');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={(open) => !open && !submitting && onClose()}>
      <DialogContent className="sm:max-w-[500px]">
        <DialogHeader>
          <DialogTitle>Thanh lý hợp đồng: {hopDong?.maHopDong}</DialogTitle>
          <DialogDescription>
            {step === 1 ? 'Nhập chỉ số điện nước cuối cùng để chốt hóa đơn' : 'Xác nhận thông tin cấn trừ cọc và hóa đơn cuối'}
          </DialogDescription>
        </DialogHeader>

        {loading ? (
          <div className="py-8 flex justify-center"><Loader2 className="animate-spin" /></div>
        ) : step === 1 ? (
          <div className="space-y-4 py-4">
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Chỉ số điện ban đầu</Label>
                <Input value={data.chiSoDienBanDau} disabled className="bg-gray-50" />
              </div>
              <div className="space-y-2">
                <Label>Chỉ số điện cuối</Label>
                <Input type="number" min={data.chiSoDienBanDau} value={data.chiSoDienCuoiKy} onChange={(e) => setData(prev => ({...prev, chiSoDienCuoiKy: parseInt(e.target.value) || 0}))} />
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Chỉ số nước ban đầu</Label>
                <Input value={data.chiSoNuocBanDau} disabled className="bg-gray-50" />
              </div>
              <div className="space-y-2">
                <Label>Chỉ số nước cuối</Label>
                <Input type="number" min={data.chiSoNuocBanDau} value={data.chiSoNuocCuoiKy} onChange={(e) => setData(prev => ({...prev, chiSoNuocCuoiKy: parseInt(e.target.value) || 0}))} />
              </div>
            </div>
          </div>
        ) : (
          <div className="space-y-4 py-4 text-sm">
            <div className="bg-gray-50 p-3 rounded-md space-y-2">
              <div className="flex justify-between font-medium border-b pb-2 mb-2"><span className="text-gray-600">Tổng hóa đơn cuối</span><span>{tongTienHoaDon.toLocaleString('vi-VN')} đ</span></div>
              <div className="flex justify-between text-gray-500"><span>Tiền phòng</span><span>{data.tienPhong.toLocaleString('vi-VN')} đ</span></div>
              <div className="flex justify-between text-gray-500"><span>Tiền điện ({data.chiSoDienCuoiKy - data.chiSoDienBanDau} kWh)</span><span>{tienDien.toLocaleString('vi-VN')} đ</span></div>
              <div className="flex justify-between text-gray-500"><span>Tiền nước ({data.chiSoNuocCuoiKy - data.chiSoNuocBanDau} m3)</span><span>{tienNuoc.toLocaleString('vi-VN')} đ</span></div>
              <div className="flex justify-between text-gray-500"><span>Tiền dịch vụ</span><span>{data.tienDichVu.toLocaleString('vi-VN')} đ</span></div>
            </div>

            <div className="bg-blue-50 p-3 rounded-md space-y-2 border border-blue-100">
              <div className="flex justify-between font-medium text-blue-900 border-b border-blue-200 pb-2 mb-2"><span>Xử lý cọc</span><span>{tienCoc.toLocaleString('vi-VN')} đ</span></div>
              <div className="flex justify-between text-blue-800"><span>Khấu trừ vào hóa đơn</span><span>- {soTienKhauTru.toLocaleString('vi-VN')} đ</span></div>
              <div className="flex justify-between text-blue-800 font-semibold"><span>Hoàn trả lại khách</span><span>{soTienHoanTra.toLocaleString('vi-VN')} đ</span></div>
            </div>

            {phaiThuThem > 0 && (
              <div className="bg-red-50 p-3 rounded-md border border-red-100 text-red-800 font-medium flex justify-between">
                <span>Khách cần đóng thêm</span>
                <span>{phaiThuThem.toLocaleString('vi-VN')} đ</span>
              </div>
            )}
          </div>
        )}

        <DialogFooter>
          {step === 1 ? (
            <>
              <Button variant="outline" onClick={onClose}>Hủy</Button>
              <Button onClick={handleNext}>Tiếp tục</Button>
            </>
          ) : (
            <>
              <Button variant="outline" onClick={() => setStep(1)} disabled={submitting}>Quay lại</Button>
              <Button onClick={handleSubmit} disabled={submitting}>
                {submitting && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                Xác nhận Thanh lý
              </Button>
            </>
          )}
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
