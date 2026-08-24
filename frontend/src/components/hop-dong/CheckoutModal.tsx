'use client';

import { useEffect, useState } from 'react';
import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Badge } from '@/components/ui/badge';
import { HopDong } from '@/types';
import { HopDongSignaturePad } from './HopDongSignaturePad';
import { 
  Loader2, 
  Plus, 
  Trash2, 
  CheckCircle2, 
  Clock, 
  PenTool, 
  ExternalLink,
  ChevronRight,
  ArrowLeft,
  Zap,
  Droplets,
  ShieldCheck,
  AlertTriangle,
  FileCheck2,
  UserCheck,
  UserX
} from 'lucide-react';
import { toast } from 'sonner';
import { cn } from '@/lib/utils';

interface CheckoutModalProps {
  hopDong: HopDong | null;
  isOpen: boolean;
  onClose: () => void;
  onSuccess: (updatedHopDong: HopDong) => void;
  accessToken?: string;
}

type KhoanKhauTru = { moTa: string; soTien: number; chungTuUrl: string };
type TaiSanBanGiao = { 
  id: string; 
  tenTaiSan: string; 
  soLuongBanDau: number; 
  tinhTrangBanDau: string; 
  soLuongThucTe?: number; 
  tinhTrangThucTe?: string; 
  chungTuUrl?: string; 
  ghiChu?: string; 
  daXacNhan?: boolean 
};

type QuyetToan = {
  trangThai: string;
  bienBanTrangThai?: string;
  hoaDon: { 
    _id: string; 
    maHoaDon: string; 
    tongTien: number; 
    trangThai: string; 
    chiTietHoaDon?: Array<{ moTa: string; thanhTien: number }> 
  };
  tienCocBanDau: number;
  tienCocDaCanTru: number;
  tienCocCanHoan: number;
  tienPhaiThuThem: number;
  banGiaoDaXacNhan: boolean;
  veSinhKiemTraXong: boolean;
  taiSanBanGiao?: TaiSanBanGiao[];
};

const formatVND = (value?: number) => Number(value || 0).toLocaleString('vi-VN') + ' đ';

export function CheckoutModal({ hopDong, isOpen, onClose, onSuccess, accessToken }: CheckoutModalProps) {
  const [currentStep, setCurrentStep] = useState<1 | 2 | 3>(1);
  const [loading, setLoading] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [quyetToan, setQuyetToan] = useState<QuyetToan | null>(null);
  
  // Readings & Deductions
  const [chiSoDienBanDau, setChiSoDienBanDau] = useState(0);
  const [chiSoNuocBanDau, setChiSoNuocBanDau] = useState(0);
  const [chiSoDienCuoiKy, setChiSoDienCuoiKy] = useState(0);
  const [chiSoNuocCuoiKy, setChiSoNuocCuoiKy] = useState(0);
  const [khoanKhauTru, setKhoanKhauTru] = useState<KhoanKhauTru[]>([]);

  // Asset handover
  const [taiSanBanGiao, setTaiSanBanGiao] = useState<TaiSanBanGiao[]>([]);
  const [savingAssets, setSavingAssets] = useState(false);

  // Refund & Finalization
  const [daHoanCoc, setDaHoanCoc] = useState(false);
  const [chungTuHoanCoc, setChungTuHoanCoc] = useState('');
  const [maThamChieuHoanCoc, setMaThamChieuHoanCoc] = useState('');
  const [banGiaoDaXacNhan, setBanGiaoDaXacNhan] = useState(false);
  const [veSinhKiemTraXong, setVeSinhKiemTraXong] = useState(false);

  // Signature Pads
  const [openSignPadBenA, setOpenSignPadBenA] = useState(false);
  const [openSignPadBenB, setOpenSignPadBenB] = useState(false);

  const headers = accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined;

  useEffect(() => {
    if (!isOpen || !hopDong?._id) return;
    setCurrentStep(1);
    setQuyetToan(null);
    setKhoanKhauTru([]);
    setDaHoanCoc(false);
    setChungTuHoanCoc('');
    setMaThamChieuHoanCoc('');
    setBanGiaoDaXacNhan(false);
    setVeSinhKiemTraXong(false);
    setTaiSanBanGiao([]);
    void loadData();
  }, [isOpen, hopDong?._id]);

  const loadData = async () => {
    if (!hopDong?._id) return;
    setLoading(true);
    try {
      const [readingResponse, settlementResponse] = await Promise.all([
        fetch(`/api/hoa-don/latest-reading?hopDongId=${hopDong._id}&thang=${new Date().getMonth() + 1}&nam=${new Date().getFullYear()}`, { headers }),
        fetch(`/api/hop-dong/${hopDong._id}/quyet-toan-tra-phong`, { headers }),
      ]);

      const reading = await readingResponse.json().catch(() => ({}));
      if (readingResponse.ok && reading.success) {
        const dienDau = Number(reading.data?.chiSoDienBanDau || hopDong.chiSoDienBanDau || 0);
        const nuocDau = Number(reading.data?.chiSoNuocBanDau || hopDong.chiSoNuocBanDau || 0);
        setChiSoDienBanDau(dienDau);
        setChiSoNuocBanDau(nuocDau);
        setChiSoDienCuoiKy(dienDau);
        setChiSoNuocCuoiKy(nuocDau);
      } else {
        const dienDau = Number(hopDong.chiSoDienBanDau || 0);
        const nuocDau = Number(hopDong.chiSoNuocBanDau || 0);
        setChiSoDienBanDau(dienDau);
        setChiSoNuocBanDau(nuocDau);
        setChiSoDienCuoiKy(dienDau);
        setChiSoNuocCuoiKy(nuocDau);
      }

      if (settlementResponse.ok) {
        const result = await settlementResponse.json();
        if (result.success && result.data) {
          setQuyetToan(result.data);
          setTaiSanBanGiao(result.data.taiSanBanGiao || []);
          setCurrentStep(result.data.bienBanTrangThai === 'HOAN_TAT' ? 3 : 2);
        }
      }
    } catch {
      toast.error('Không thể tải dữ liệu trả phòng');
    } finally {
      setLoading(false);
    }
  };

  const reloadSettlement = async () => {
    if (!hopDong?._id) return;
    try {
      const res = await fetch(`/api/hop-dong/${hopDong._id}/quyet-toan-tra-phong`, { headers });
      const data = await res.json();
      if (res.ok && data.success) {
        setQuyetToan(data.data);
        setTaiSanBanGiao(data.data.taiSanBanGiao || []);
      }
    } catch (e) {
      console.error(e);
    }
  };

  const createSettlement = async () => {
    if (!hopDong?._id) return;
    if (chiSoDienCuoiKy < chiSoDienBanDau || chiSoNuocCuoiKy < chiSoNuocBanDau) {
      toast.error('Chỉ số điện/nước cuối kỳ không được nhỏ hơn chỉ số đầu kỳ');
      return;
    }
    if (khoanKhauTru.some(item => !item.moTa.trim() || item.soTien <= 0 || !item.chungTuUrl.trim())) {
      toast.error('Mỗi khoản khấu trừ phải có đầy đủ: Mô tả, Số tiền và Mã/Link chứng từ');
      return;
    }
    setSubmitting(true);
    try {
      const response = await fetch(`/api/hop-dong/${hopDong._id}/quyet-toan-tra-phong`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', ...(headers || {}) },
        body: JSON.stringify({
          ngayTraPhong: new Date().toISOString().slice(0, 10),
          chiSoDienBanDau,
          chiSoDienCuoiKy,
          chiSoNuocBanDau,
          chiSoNuocCuoiKy,
          khoanKhauTru,
          ghiChu: 'Lập quyết toán trả phòng qua hệ thống EasyHouse',
        }),
      });
      const result = await response.json();
      if (!response.ok || !result.success) throw new Error(result.message);
      setQuyetToan(result.data);
      setTaiSanBanGiao(result.data.taiSanBanGiao || []);
      toast.success('Lập quyết toán thành công! Chuyển sang kiểm kê tài sản.');
      setCurrentStep(2);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Không thể lập quyết toán');
    } finally {
      setSubmitting(false);
    }
  };

  const updateAsset = (index: number, patch: Partial<TaiSanBanGiao>) => {
    setTaiSanBanGiao(items => items.map((item, i) => i === index ? { ...item, ...patch } : item));
  };

  const saveAssetHandover = async () => {
    if (!hopDong?._id) return;
    if (taiSanBanGiao.some(item => item.soLuongThucTe === undefined || !item.tinhTrangThucTe?.trim() || !item.daXacNhan)) {
      toast.error('Vui lòng kiểm kê, nhập tình trạng và tích xác nhận cho từng tài sản');
      return;
    }
    if (taiSanBanGiao.some(item => (item.soLuongThucTe !== item.soLuongBanDau || item.tinhTrangThucTe?.trim().toLowerCase() !== item.tinhTrangBanDau.trim().toLowerCase()) && !item.chungTuUrl?.trim())) {
      toast.error('Tài sản thiếu hoặc hư hỏng phải có link ảnh/chứng từ đính kèm');
      return;
    }
    setSavingAssets(true);
    try {
      const response = await fetch(`/api/hop-dong/${hopDong._id}/quyet-toan-tra-phong/ban-giao`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', ...(headers || {}) },
        body: JSON.stringify({
          items: taiSanBanGiao.map(item => ({
            id: item.id,
            soLuongThucTe: item.soLuongThucTe,
            tinhTrangThucTe: item.tinhTrangThucTe,
            chungTuUrl: item.chungTuUrl,
            ghiChu: item.ghiChu,
            daXacNhan: item.daXacNhan,
          })),
        }),
      });
      const result = await response.json();
      if (!response.ok || !result.success) throw new Error(result.message);
      setQuyetToan(result.data);
      setTaiSanBanGiao(result.data.taiSanBanGiao || []);
      toast.success('Đã lưu biên bản bàn giao tài sản thành công');
      setCurrentStep(3);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Không thể lưu biên bản bàn giao');
    } finally {
      setSavingAssets(false);
    }
  };

  const isBenASigned = quyetToan?.bienBanTrangThai === 'BEN_A_DA_KY' || quyetToan?.bienBanTrangThai === 'HOAN_TAT';
  const isBenBSigned = quyetToan?.bienBanTrangThai === 'BEN_B_DA_KY' || quyetToan?.bienBanTrangThai === 'HOAN_TAT';
  const isFullySigned = quyetToan?.bienBanTrangThai === 'HOAN_TAT';

  const completeCheckout = async () => {
    if (!hopDong?._id || !quyetToan) return;

    // Strict validation: Both parties must sign
    if (!isFullySigned) {
      if (!isBenASigned && !isBenBSigned) {
        toast.error('Biên bản bàn giao chưa có chữ ký của cả 2 bên. Vui lòng ký trước khi hoàn tất.');
      } else if (!isBenASigned) {
        toast.error('Chủ trọ (Bên A) chưa ký biên bản bàn giao. Vui lòng bấm "Ký xác nhận (Bên A)".');
      } else {
        toast.error('Khách thuê (Bên B) chưa ký biên bản bàn giao. Vui lòng cho khách ký trực tiếp bằng nút "Khách ký trực tiếp (Bên B)" hoặc chờ khách ký trên ứng dụng.');
      }
      return;
    }

    if (quyetToan.tienCocCanHoan > 0 && (!daHoanCoc || !chungTuHoanCoc.trim())) {
      toast.error('Vui lòng tích xác nhận hoàn cọc và nhập mã giao dịch/chứng từ hoàn tiền');
      return;
    }
    if (!banGiaoDaXacNhan) {
      toast.error('Vui lòng tích xác nhận Đã thu hồi chìa khóa và bàn giao phòng');
      return;
    }
    if (!veSinhKiemTraXong) {
      toast.error('Vui lòng tích xác nhận Đã vệ sinh và kiểm tra hoàn tất');
      return;
    }

    setSubmitting(true);
    try {
      const response = await fetch(`/api/hop-dong/${hopDong._id}/quyet-toan-tra-phong/hoan-tat`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', ...(headers || {}) },
        body: JSON.stringify({
          daHoanCoc,
          chungTuHoanCoc,
          maThamChieuHoanCoc,
          banGiaoDaXacNhan,
          veSinhKiemTraXong,
        }),
      });
      const result = await response.json();
      if (!response.ok || !result.success) throw new Error(result.message);
      toast.success('Đã hoàn tất trả phòng! Phòng đã được giải phóng sang trạng thái Trống.');
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

  const dienTieuThu = Math.max(0, chiSoDienCuoiKy - chiSoDienBanDau);
  const nuocTieuThu = Math.max(0, chiSoNuocCuoiKy - chiSoNuocBanDau);

  const getBienBanBadge = (status?: string) => {
    switch (status) {
      case 'HOAN_TAT':
        return <Badge className="bg-emerald-50 text-emerald-700 border-emerald-200 flex items-center gap-1"><CheckCircle2 className="h-3.5 w-3.5 text-emerald-600" /> Đã đủ 2 chữ ký</Badge>;
      case 'BEN_A_DA_KY':
        return <Badge className="bg-blue-50 text-blue-700 border-blue-200 flex items-center gap-1"><Clock className="h-3.5 w-3.5 text-blue-600" /> Chủ trọ đã ký · Chờ khách ký</Badge>;
      case 'BEN_B_DA_KY':
        return <Badge className="bg-amber-50 text-amber-700 border-amber-200 flex items-center gap-1"><Clock className="h-3.5 w-3.5 text-amber-600" /> Khách đã ký · Chờ chủ trọ</Badge>;
      case 'CHO_KY':
        return <Badge variant="outline" className="text-orange-700 bg-orange-50 border-orange-200 flex items-center gap-1"><Clock className="h-3.5 w-3.5" /> Chờ 2 bên ký</Badge>;
      default:
        return <Badge variant="outline">Chưa lập</Badge>;
    }
  };

  return (
    <>
      <Dialog open={isOpen} onOpenChange={open => !open && !submitting && onClose()}>
        <DialogContent className="sm:max-w-[700px] max-h-[92vh] overflow-y-auto p-0 rounded-2xl border-none shadow-2xl">
          {/* Header Banner */}
          <div className="bg-[#243B5A] text-white p-6 pb-5 rounded-t-2xl relative overflow-hidden">
            <div className="absolute top-0 right-0 w-48 h-48 bg-[#4FA7A0]/15 rounded-full blur-3xl pointer-events-none" />
            <div className="flex items-center justify-between relative z-10">
              <div className="space-y-1">
                <div className="flex items-center gap-2">
                  <span className="text-[11px] font-extrabold uppercase tracking-widest text-[#4FA7A0] bg-[#4FA7A0]/20 px-2 py-0.5 rounded-md">
                    Thủ tục trả phòng
                  </span>
                  <span className="text-xs text-slate-300">
                    Phòng {typeof hopDong?.phong === 'object' ? (hopDong?.phong as { maPhong?: string })?.maPhong : '---'}
                  </span>
                </div>
                <DialogTitle className="text-xl font-black text-white">
                  Quyết toán & Bàn giao: {hopDong?.maHopDong}
                </DialogTitle>
                <DialogDescription className="text-xs text-slate-300 font-medium">
                  {currentStep === 1 && 'Bước 1: Chốt chỉ số điện nước & các khoản khấu trừ phát sinh'}
                  {currentStep === 2 && 'Bước 2: Bảng tính quyết toán tiền cọc & Kiểm kê hiện trạng tài sản'}
                  {currentStep === 3 && 'Bước 3: Ký biên bản bàn giao pháp lý & Hoàn tất giải phóng phòng'}
                </DialogDescription>
              </div>
            </div>

            {/* Stepper Progress Bar */}
            <div className="grid grid-cols-3 gap-2 mt-4 pt-3 border-t border-white/10 text-xs font-semibold">
              <button 
                type="button"
                onClick={() => setCurrentStep(1)}
                className={cn(
                  "flex items-center gap-1.5 transition-all text-left",
                  currentStep === 1 ? "text-[#4FA7A0] font-bold" : "text-slate-400 hover:text-white"
                )}
              >
                <span className={cn("w-5 h-5 rounded-full flex items-center justify-center text-[10px]", currentStep === 1 ? "bg-[#4FA7A0] text-[#243B5A] font-bold" : "bg-white/10")}>1</span>
                Chốt điện nước
              </button>
              <button 
                type="button"
                onClick={() => quyetToan && setCurrentStep(2)}
                disabled={!quyetToan}
                className={cn(
                  "flex items-center gap-1.5 transition-all text-left",
                  currentStep === 2 ? "text-[#4FA7A0] font-bold" : quyetToan ? "text-slate-400 hover:text-white" : "text-slate-500 opacity-50 cursor-not-allowed"
                )}
              >
                <span className={cn("w-5 h-5 rounded-full flex items-center justify-center text-[10px]", currentStep === 2 ? "bg-[#4FA7A0] text-[#243B5A] font-bold" : "bg-white/10")}>2</span>
                Kiểm kê tài sản
              </button>
              <button 
                type="button"
                onClick={() => quyetToan && setCurrentStep(3)}
                disabled={!quyetToan}
                className={cn(
                  "flex items-center gap-1.5 transition-all text-left",
                  currentStep === 3 ? "text-[#4FA7A0] font-bold" : quyetToan ? "text-slate-400 hover:text-white" : "text-slate-500 opacity-50 cursor-not-allowed"
                )}
              >
                <span className={cn("w-5 h-5 rounded-full flex items-center justify-center text-[10px]", currentStep === 3 ? "bg-[#4FA7A0] text-[#243B5A] font-bold" : "bg-white/10")}>3</span>
                Ký & Hoàn tất
              </button>
            </div>
          </div>

          <div className="p-6 space-y-6">
            {loading ? (
              <div className="py-12 flex flex-col items-center justify-center space-y-3">
                <Loader2 className="h-8 w-8 animate-spin text-[#4FA7A0]" />
                <p className="text-xs font-medium text-[#6B7A8C]">Đang nạp dữ liệu quyết toán từ hệ thống...</p>
              </div>
            ) : currentStep === 1 ? (
              /* ── BƯỚC 1: CHỐT ĐIỆN NƯỚC & KHẤU TRỪ ── */
              <div className="space-y-5">
                {/* Điện & Nước Cards */}
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div className="p-4 rounded-xl border border-amber-200 bg-amber-50/50 space-y-3">
                    <div className="flex items-center justify-between">
                      <Label className="text-xs font-bold text-amber-900 flex items-center gap-1.5 uppercase">
                        <Zap className="h-4 w-4 text-amber-600" /> Chỉ số điện (kWh)
                      </Label>
                      <span className="text-[11px] font-bold text-amber-700 bg-amber-100 px-2 py-0.5 rounded">
                        Dùng: +{dienTieuThu} kWh
                      </span>
                    </div>
                    <div className="grid grid-cols-2 gap-2">
                      <div>
                        <span className="text-[10px] text-gray-500 font-medium block mb-1">Đầu kỳ</span>
                        <Input value={chiSoDienBanDau} disabled className="h-10 bg-white/70 font-semibold" />
                      </div>
                      <div>
                        <span className="text-[10px] text-gray-700 font-bold block mb-1">Cuối kỳ *</span>
                        <Input 
                          type="number" 
                          min={chiSoDienBanDau} 
                          value={chiSoDienCuoiKy} 
                          onChange={e => setChiSoDienCuoiKy(Number(e.target.value))} 
                          className="h-10 bg-white font-bold text-[#243B5A] border-amber-300 focus:ring-amber-500" 
                        />
                      </div>
                    </div>
                  </div>

                  <div className="p-4 rounded-xl border border-blue-200 bg-blue-50/50 space-y-3">
                    <div className="flex items-center justify-between">
                      <Label className="text-xs font-bold text-blue-900 flex items-center gap-1.5 uppercase">
                        <Droplets className="h-4 w-4 text-blue-600" /> Chỉ số nước (m³)
                      </Label>
                      <span className="text-[11px] font-bold text-blue-700 bg-blue-100 px-2 py-0.5 rounded">
                        Dùng: +{nuocTieuThu} m³
                      </span>
                    </div>
                    <div className="grid grid-cols-2 gap-2">
                      <div>
                        <span className="text-[10px] text-gray-500 font-medium block mb-1">Đầu kỳ</span>
                        <Input value={chiSoNuocBanDau} disabled className="h-10 bg-white/70 font-semibold" />
                      </div>
                      <div>
                        <span className="text-[10px] text-gray-700 font-bold block mb-1">Cuối kỳ *</span>
                        <Input 
                          type="number" 
                          min={chiSoNuocBanDau} 
                          value={chiSoNuocCuoiKy} 
                          onChange={e => setChiSoNuocCuoiKy(Number(e.target.value))} 
                          className="h-10 bg-white font-bold text-[#243B5A] border-blue-300 focus:ring-blue-500" 
                        />
                      </div>
                    </div>
                  </div>
                </div>

                {/* Khoản khấu trừ cọc */}
                <div className="space-y-3 rounded-xl border border-slate-200 bg-[#FBFBFA] p-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <Label className="text-xs font-bold text-[#243B5A] uppercase tracking-wider">
                        Khoản khấu trừ cọc có chứng từ
                      </Label>
                      <p className="text-[11px] text-[#6B7A8C] mt-0.5">
                        Thêm các khoản bồi thường hư hỏng hoặc phạt vi phạm (bắt buộc kèm link ảnh/mã chứng từ).
                      </p>
                    </div>
                    <Button size="sm" variant="outline" type="button" onClick={addDeduction} className="text-xs h-8 font-bold border-slate-300">
                      <Plus className="mr-1 h-3.5 w-3.5 text-[#4FA7A0]" /> Thêm khoản
                    </Button>
                  </div>

                  {khoanKhauTru.length === 0 ? (
                    <div className="p-3 text-center rounded-lg border border-dashed border-slate-200 bg-white text-xs text-slate-500">
                      Không có khoản phạt/hư hỏng nào. Toàn bộ cọc còn dư sau khi bù trừ tiền phòng và điện nước sẽ được hoàn lại cho khách.
                    </div>
                  ) : (
                    <div className="space-y-2">
                      {khoanKhauTru.map((item, index) => (
                        <div className="grid grid-cols-[1fr_120px_1fr_auto] gap-2 items-center bg-white p-2 rounded-lg border" key={index}>
                          <Input 
                            placeholder="Nội dung (vd: Vỡ gương phòng tắm)" 
                            value={item.moTa} 
                            onChange={e => updateDeduction(index, { moTa: e.target.value })} 
                            className="h-9 text-xs"
                          />
                          <Input 
                            type="number" 
                            min="1" 
                            placeholder="Số tiền" 
                            value={item.soTien || ''} 
                            onChange={e => updateDeduction(index, { soTien: Number(e.target.value) })} 
                            className="h-9 text-xs font-bold text-red-600"
                          />
                          <Input 
                            placeholder="Link ảnh chứng từ / biên lai" 
                            value={item.chungTuUrl} 
                            onChange={e => updateDeduction(index, { chungTuUrl: e.target.value })} 
                            className="h-9 text-xs"
                          />
                          <Button 
                            size="icon" 
                            variant="ghost" 
                            type="button" 
                            onClick={() => setKhoanKhauTru(items => items.filter((_, i) => i !== index))}
                            className="h-8 w-8 text-slate-400 hover:text-red-600"
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              </div>
            ) : currentStep === 2 ? (
              /* ── BƯỚC 2: BẢNG TÍNH QUYẾT TOÁN & KIỂM KÊ TÀI SẢN ── */
              <div className="space-y-5">
                {/* Financial Summary */}
                {quyetToan && (
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div className="rounded-xl border border-slate-200 bg-white p-4 space-y-2.5 shadow-xs">
                      <div className="flex justify-between items-center pb-2 border-b">
                        <span className="text-xs font-bold text-[#243B5A]">Hóa đơn quyết toán</span>
                        <Badge variant="outline" className="font-mono text-xs">{quyetToan.hoaDon.maHoaDon}</Badge>
                      </div>
                      <div className="space-y-1.5 text-xs text-[#6B7A8C]">
                        {quyetToan.hoaDon.chiTietHoaDon?.map((item, index) => (
                          <div className="flex justify-between" key={index}>
                            <span>{item.moTa}</span>
                            <span className="font-medium text-slate-900">{formatVND(item.thanhTien)}</span>
                          </div>
                        ))}
                      </div>
                      <div className="pt-2 border-t flex justify-between font-bold text-sm text-[#243B5A]">
                        <span>Tổng hóa đơn:</span>
                        <span>{formatVND(quyetToan.hoaDon.tongTien)}</span>
                      </div>
                    </div>

                    <div className="rounded-xl border border-[#4FA7A0]/30 bg-[#4FA7A0]/5 p-4 flex flex-col justify-between shadow-xs">
                      <div className="space-y-2 text-xs">
                        <div className="flex justify-between text-[#6B7A8C]">
                          <span>Tiền cọc ban đầu:</span>
                          <span className="font-bold text-[#243B5A]">{formatVND(quyetToan.tienCocBanDau)}</span>
                        </div>
                        <div className="flex justify-between text-[#6B7A8C]">
                          <span>Cấn trừ vào hóa đơn & khấu trừ:</span>
                          <span className="font-bold text-red-600">- {formatVND(quyetToan.tienCocDaCanTru)}</span>
                        </div>
                      </div>

                      <div className="mt-4 pt-3 border-t border-[#4FA7A0]/20">
                        {quyetToan.tienCocCanHoan > 0 ? (
                          <div className="p-3 bg-emerald-50 border border-emerald-200 rounded-lg">
                            <span className="text-xs font-bold text-emerald-800 uppercase block">Số tiền cọc cần hoàn trả khách:</span>
                            <span className="text-xl font-black text-emerald-700">{formatVND(quyetToan.tienCocCanHoan)}</span>
                          </div>
                        ) : quyetToan.tienPhaiThuThem > 0 ? (
                          <div className="p-3 bg-red-50 border border-red-200 rounded-lg">
                            <span className="text-xs font-bold text-red-800 uppercase block">Khách cần thanh toán thêm:</span>
                            <span className="text-xl font-black text-red-700">{formatVND(quyetToan.tienPhaiThuThem)}</span>
                          </div>
                        ) : (
                          <div className="p-3 bg-slate-100 rounded-lg text-xs font-bold text-slate-700 text-center">
                            Tiền cọc cấn trừ vừa đủ hóa đơn (0 đ phát sinh).
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                )}

                {/* Asset Checklist */}
                <div className="space-y-3 rounded-xl border border-slate-200 bg-[#FBFBFA] p-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <Label className="text-xs font-bold text-[#243B5A] uppercase tracking-wider">
                        Kiểm kê hiện trạng tài sản bàn giao
                      </Label>
                      <p className="text-[11px] text-[#6B7A8C] mt-0.5">
                        Xác nhận số lượng và tình trạng thực tế đồ dùng trong phòng lúc trả.
                      </p>
                    </div>
                    {taiSanBanGiao.length > 0 && (
                      <Button size="sm" type="button" onClick={saveAssetHandover} disabled={savingAssets} className="text-xs h-8 bg-[#4FA7A0] hover:bg-[#3D8B85] text-white font-bold">
                        {savingAssets ? <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" /> : <ShieldCheck className="mr-1.5 h-3.5 w-3.5" />}
                        Lưu biên bản bàn giao
                      </Button>
                    )}
                  </div>

                  {taiSanBanGiao.length === 0 ? (
                    <div className="p-4 text-center rounded-lg border border-dashed border-slate-200 bg-white text-xs text-slate-500">
                      Phòng này không có danh mục tài sản cố định riêng cần kiểm kê. Bạn có thể chuyển sang Bước 3 để ký biên bản và hoàn tất.
                    </div>
                  ) : (
                    <div className="space-y-3">
                      {taiSanBanGiao.map((item, index) => (
                        <div className="space-y-2 rounded-xl border border-slate-200 bg-white p-3 shadow-2xs" key={item.id}>
                          <div className="flex items-center justify-between font-bold text-xs text-[#243B5A]">
                            <span>{item.tenTaiSan}</span>
                            <span className="text-[11px] font-medium text-slate-500">
                              Ban đầu: <strong>{item.soLuongBanDau}</strong> · {item.tinhTrangBanDau}
                            </span>
                          </div>
                          <div className="grid grid-cols-2 gap-2">
                            <div>
                              <span className="text-[10px] text-gray-500 block mb-0.5">Số lượng thực tế</span>
                              <Input 
                                type="number" 
                                min="0" 
                                max={item.soLuongBanDau} 
                                value={item.soLuongThucTe ?? ''} 
                                onChange={e => updateAsset(index, { soLuongThucTe: Number(e.target.value) })}
                                className="h-8 text-xs font-bold"
                              />
                            </div>
                            <div>
                              <span className="text-[10px] text-gray-500 block mb-0.5">Tình trạng thực tế</span>
                              <Input 
                                placeholder="vd: Tốt / Hỏng / Bình thường" 
                                value={item.tinhTrangThucTe || ''} 
                                onChange={e => updateAsset(index, { tinhTrangThucTe: e.target.value })} 
                                className="h-8 text-xs"
                              />
                            </div>
                          </div>
                          <Input 
                            placeholder="URL link ảnh chứng từ nếu thiếu/hư hỏng" 
                            value={item.chungTuUrl || ''} 
                            onChange={e => updateAsset(index, { chungTuUrl: e.target.value })} 
                            className="h-8 text-xs"
                          />
                          <div className="flex items-center gap-2 pt-1">
                            <Checkbox 
                              id={`asset-${item.id}`} 
                              checked={item.daXacNhan === true} 
                              onCheckedChange={value => updateAsset(index, { daXacNhan: value === true })} 
                            />
                            <Label htmlFor={`asset-${item.id}`} className="text-xs font-semibold text-[#243B5A] cursor-pointer">
                              Đã kiểm kê và xác nhận đồ đạc này
                            </Label>
                          </div>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              </div>
            ) : (
              /* ── BƯỚC 3: KÝ BIÊN BẢN & HOÀN TẤT TRẢ PHÒNG ── */
              <div className="space-y-5">
                {/* Handover Report Signing Card */}
                <div className="rounded-xl border border-slate-200 bg-[#FBFBFA] p-4 space-y-4">
                  <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 pb-2 border-b">
                    <div>
                      <Label className="text-xs font-bold text-[#243B5A] uppercase tracking-wider flex items-center gap-1.5">
                        <FileCheck2 className="h-4 w-4 text-[#4FA7A0]" /> Chữ ký biên bản bàn giao (Bắt buộc 2 bên)
                      </Label>
                      <p className="text-[11px] text-[#6B7A8C] mt-0.5">
                        Cần có đủ chữ ký của Chủ trọ và Khách thuê để có giá trị pháp lý chốt cọc.
                      </p>
                    </div>
                    {getBienBanBadge(quyetToan?.bienBanTrangThai)}
                  </div>

                  {/* 2 Signers Status Grid */}
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    {/* Bên A: Chủ trọ */}
                    <div className={cn(
                      "p-3.5 rounded-xl border transition-all flex flex-col justify-between space-y-3",
                      isBenASigned ? "bg-emerald-50/70 border-emerald-200" : "bg-white border-slate-200 shadow-2xs"
                    )}>
                      <div className="flex items-center justify-between">
                        <span className="text-xs font-bold text-[#243B5A] flex items-center gap-1.5">
                          <UserCheck className={cn("h-4 w-4", isBenASigned ? "text-emerald-600" : "text-slate-400")} />
                          Bên A (Chủ trọ nhận phòng)
                        </span>
                        {isBenASigned ? (
                          <Badge className="bg-emerald-600 text-white text-[10px] font-bold">Đã ký</Badge>
                        ) : (
                          <Badge variant="outline" className="text-red-600 border-red-200 bg-red-50 text-[10px]">Chưa ký</Badge>
                        )}
                      </div>

                      <div>
                        {isBenASigned ? (
                          <p className="text-[11px] text-emerald-800 font-medium">Chữ ký điện tử của bạn đã được đóng dấu vào văn bản.</p>
                        ) : (
                          <Button 
                            size="sm" 
                            type="button" 
                            onClick={() => setOpenSignPadBenA(true)}
                            className="w-full text-xs font-bold bg-[#243B5A] hover:bg-[#1B2E47] text-white h-9"
                          >
                            <PenTool className="mr-1.5 h-3.5 w-3.5 text-[#4FA7A0]" />
                            Ký xác nhận (Bên A)
                          </Button>
                        )}
                      </div>
                    </div>

                    {/* Bên B: Khách thuê */}
                    <div className={cn(
                      "p-3.5 rounded-xl border transition-all flex flex-col justify-between space-y-3",
                      isBenBSigned ? "bg-emerald-50/70 border-emerald-200" : "bg-white border-slate-200 shadow-2xs"
                    )}>
                      <div className="flex items-center justify-between">
                        <span className="text-xs font-bold text-[#243B5A] flex items-center gap-1.5">
                          <UserCheck className={cn("h-4 w-4", isBenBSigned ? "text-emerald-600" : "text-slate-400")} />
                          Bên B (Khách thuê trả phòng)
                        </span>
                        {isBenBSigned ? (
                          <Badge className="bg-emerald-600 text-white text-[10px] font-bold">Đã ký</Badge>
                        ) : (
                          <Badge variant="outline" className="text-red-600 border-red-200 bg-red-50 text-[10px]">Chưa ký</Badge>
                        )}
                      </div>

                      <div>
                        {isBenBSigned ? (
                          <p className="text-[11px] text-emerald-800 font-medium">Khách thuê đã ký xác nhận biên bản bàn giao.</p>
                        ) : (
                          <div className="space-y-1.5">
                            <Button 
                              size="sm" 
                              variant="outline"
                              type="button" 
                              onClick={() => setOpenSignPadBenB(true)}
                              className="w-full text-xs font-bold text-orange-700 bg-orange-50 border-orange-200 hover:bg-orange-100 h-9"
                            >
                              <PenTool className="mr-1.5 h-3.5 w-3.5 text-orange-600" />
                              Khách ký trực tiếp (Bên B)
                            </Button>
                            <p className="text-[10px] text-slate-500 text-center italic">
                              Khách có thể ký ngay trên máy này hoặc ký từ tài khoản khách
                            </p>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>

                  {/* Warning banner if not fully signed */}
                  {!isFullySigned && (
                    <div className="p-3 bg-amber-50 border border-amber-200 rounded-xl flex items-start gap-2 text-xs text-amber-900">
                      <AlertTriangle className="h-4 w-4 text-amber-600 shrink-0 mt-0.5" />
                      <div>
                        <span className="font-bold">Lưu ý pháp lý:</span> Hệ thống chỉ cho phép hoàn tất trả phòng khi đã có <strong>đủ chữ ký của cả Chủ trọ và Khách thuê</strong>.
                      </div>
                    </div>
                  )}

                  {hopDong?._id && isBenASigned && (
                    <div className="pt-1 flex justify-end">
                      <Button 
                        size="sm" 
                        variant="ghost"
                        asChild
                        className="text-xs h-8 text-[#243B5A]"
                      >
                        <a href={`/api/hop-dong/${hopDong._id}/bien-ban-ban-giao?format=pdf`} target="_blank" rel="noreferrer">
                          <ExternalLink className="mr-1.5 h-3.5 w-3.5" /> Xem trước file PDF Biên bản bàn giao
                        </a>
                      </Button>
                    </div>
                  )}
                </div>

                {/* Refund confirmation if required */}
                {quyetToan && quyetToan.tienCocCanHoan > 0 && (
                  <div className="rounded-xl border border-emerald-200 bg-emerald-50/60 p-4 space-y-3">
                    <div className="flex items-center gap-2">
                      <Checkbox 
                        id="refund" 
                        checked={daHoanCoc} 
                        onCheckedChange={value => setDaHoanCoc(value === true)} 
                      />
                      <Label htmlFor="refund" className="text-xs font-bold text-emerald-900 cursor-pointer">
                        Đã chuyển khoản hoàn lại phần tiền cọc dư ({formatVND(quyetToan.tienCocCanHoan)}) cho khách
                      </Label>
                    </div>
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 pt-1">
                      <Input 
                        placeholder="Mã giao dịch ngân hàng / Link ảnh biên nhận (bắt buộc) *" 
                        value={chungTuHoanCoc} 
                        onChange={e => setChungTuHoanCoc(e.target.value)} 
                        className="h-9 text-xs bg-white border-emerald-300"
                      />
                      <Input 
                        placeholder="Mã tham chiếu ngân hàng (nếu có)" 
                        value={maThamChieuHoanCoc} 
                        onChange={e => setMaThamChieuHoanCoc(e.target.value)} 
                        className="h-9 text-xs bg-white border-emerald-300"
                      />
                    </div>
                  </div>
                )}

                {/* Handover & Cleaning confirmations */}
                <div className="rounded-xl border border-slate-200 bg-white p-4 space-y-3">
                  <Label className="text-xs font-bold text-[#243B5A] uppercase tracking-wider block">
                    Xác nhận bàn giao & Giải phóng phòng
                  </Label>
                  <div className="space-y-2">
                    <div className="flex items-center gap-2">
                      <Checkbox 
                        id="handover" 
                        checked={banGiaoDaXacNhan} 
                        onCheckedChange={value => setBanGiaoDaXacNhan(value === true)} 
                      />
                      <Label htmlFor="handover" className="text-xs font-semibold text-[#243B5A] cursor-pointer">
                        Đã thu hồi chìa khóa và xác nhận bàn giao phòng
                      </Label>
                    </div>
                    <div className="flex items-center gap-2">
                      <Checkbox 
                        id="inspection" 
                        checked={veSinhKiemTraXong} 
                        onCheckedChange={value => setVeSinhKiemTraXong(value === true)} 
                      />
                      <Label htmlFor="inspection" className="text-xs font-semibold text-[#243B5A] cursor-pointer">
                        Đã vệ sinh, dọn dẹp và kiểm tra hoàn tất
                      </Label>
                    </div>
                  </div>
                </div>
              </div>
            )}
          </div>

          {/* Footer Navigation */}
          <DialogFooter className="bg-[#F8F3EC] p-4 px-6 border-t border-slate-200 flex flex-row items-center justify-between sm:justify-between">
            <div>
              {currentStep > 1 ? (
                <Button 
                  variant="outline" 
                  type="button"
                  size="sm"
                  onClick={() => setCurrentStep((currentStep - 1) as any)}
                  disabled={submitting}
                  className="text-xs font-bold"
                >
                  <ArrowLeft className="mr-1.5 h-3.5 w-3.5" /> Quay lại
                </Button>
              ) : (
                <Button 
                  variant="outline" 
                  type="button"
                  size="sm"
                  onClick={onClose} 
                  disabled={submitting}
                  className="text-xs font-bold"
                >
                  Đóng
                </Button>
              )}
            </div>

            <div className="flex items-center gap-2">
              {currentStep === 1 ? (
                <Button 
                  type="button"
                  size="sm"
                  onClick={createSettlement} 
                  disabled={submitting}
                  className="bg-[#243B5A] hover:bg-[#1B2E47] text-white text-xs font-bold h-9 px-4"
                >
                  {submitting ? <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" /> : null}
                  Lập quyết toán <ChevronRight className="ml-1 h-3.5 w-3.5" />
                </Button>
              ) : currentStep === 2 ? (
                <Button 
                  type="button"
                  size="sm"
                  onClick={() => setCurrentStep(3)} 
                  disabled={submitting}
                  className="bg-[#243B5A] hover:bg-[#1B2E47] text-white text-xs font-bold h-9 px-4"
                >
                  Tiếp tục ký & hoàn tất <ChevronRight className="ml-1 h-3.5 w-3.5" />
                </Button>
              ) : (
                <Button 
                  type="button"
                  size="sm"
                  onClick={completeCheckout} 
                  disabled={submitting || !isFullySigned}
                  className={cn(
                    "text-white text-xs font-bold h-9 px-5 transition-all shadow-sm",
                    isFullySigned 
                      ? "bg-emerald-600 hover:bg-emerald-700 shadow-emerald-600/30 cursor-pointer" 
                      : "bg-slate-400 opacity-60 cursor-not-allowed"
                  )}
                >
                  {submitting ? <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" /> : <CheckCircle2 className="mr-1.5 h-3.5 w-3.5" />}
                  {isFullySigned ? 'Hoàn tất trả phòng' : 'Cần đủ 2 chữ ký để hoàn tất'}
                </Button>
              )}
            </div>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Signature Pad Dialogs for Handover */}
      {hopDong?._id && (
        <>
          <HopDongSignaturePad
            isOpen={openSignPadBenA}
            onClose={() => setOpenSignPadBenA(false)}
            hopDongId={hopDong._id}
            accessToken={accessToken}
            role="LANDLORD"
            title="Ký biên bản bàn giao (Bên A - Chủ trọ nhận phòng)"
            description="Chữ ký sẽ được đóng dấu vào Biên bản bàn giao trả phòng."
            endpoint={`/api/hop-dong/${hopDong._id}/bien-ban-ban-giao/ky`}
            buildBody={(chuKyBase64: string) => ({ vaiTro: 'BEN_A', chuKyBase64 })}
            onSuccess={() => {
              void reloadSettlement();
            }}
          />

          <HopDongSignaturePad
            isOpen={openSignPadBenB}
            onClose={() => setOpenSignPadBenB(false)}
            hopDongId={hopDong._id}
            accessToken={accessToken}
            role="TENANT"
            title="Ký biên bản bàn giao (Bên B - Khách thuê trả phòng)"
            description="Khách thuê ký xác nhận số liệu chốt điện nước và hiện trạng tài sản."
            endpoint={`/api/hop-dong/${hopDong._id}/bien-ban-ban-giao/ky`}
            buildBody={(chuKyBase64: string) => ({ vaiTro: 'BEN_B', chuKyBase64 })}
            onSuccess={() => {
              void reloadSettlement();
            }}
          />
        </>
      )}
    </>
  );
}
