'use client';

import { useEffect, useState, useMemo } from 'react';
import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Badge } from '@/components/ui/badge';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
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
  Zap,
  Droplets,
  ShieldCheck,
  FileCheck2,
  Calendar,
  DollarSign,
  AlertCircle
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

type KhoanKhauTru = { moTa: string; soTien: number; chungTuUrl?: string };
type TaiSanBanGiao = { 
  id: string; 
  tenTaiSan: string; 
  soLuongBanDau: number; 
  tinhTrangBanDau: string; 
  soLuongThucTe?: number; 
  tinhTrangThucTe?: string; 
  chungTuUrl?: string; 
  ghiChu?: string; 
  daXacNhan?: boolean;
  mucKhauTru?: number;
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
  const [activeTab, setActiveTab] = useState<'quick' | 'detail'>('quick');
  const [loading, setLoading] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [quyetToan, setQuyetToan] = useState<QuyetToan | null>(null);

  // Form states
  const [ngayTraPhong, setNgayTraPhong] = useState('');
  const [huyTruocHan, setHuyTruocHan] = useState(false);
  const [chiSoDienBanDau, setChiSoDienBanDau] = useState(0);
  const [chiSoNuocBanDau, setChiSoNuocBanDau] = useState(0);
  const [chiSoDienCuoiKy, setChiSoDienCuoiKy] = useState(0);
  const [chiSoNuocCuoiKy, setChiSoNuocCuoiKy] = useState(0);
  const [donGiaDien, setDonGiaDien] = useState(0);
  const [donGiaNuoc, setDonGiaNuoc] = useState(0);
  const [khoanKhauTru, setKhoanKhauTru] = useState<KhoanKhauTru[]>([]);
  const [ghiChu, setGhiChu] = useState('');

  // Asset handover (Optional tab)
  const [taiSanBanGiao, setTaiSanBanGiao] = useState<TaiSanBanGiao[]>([]);
  const [savingAssets, setSavingAssets] = useState(false);

  // Signature Pads
  const [openSignPadBenA, setOpenSignPadBenA] = useState(false);
  const [openSignPadBenB, setOpenSignPadBenB] = useState(false);

  const headers = accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined;

  useEffect(() => {
    if (!isOpen || !hopDong?._id) return;
    const today = new Date().toISOString().slice(0, 10);
    setNgayTraPhong(today);
    setActiveTab('quick');
    setQuyetToan(null);
    setKhoanKhauTru([]);
    setGhiChu('');
    setTaiSanBanGiao([]);

    if (hopDong.ngayKetThuc) {
      const endDateStr = typeof hopDong.ngayKetThuc === 'string' 
        ? hopDong.ngayKetThuc.slice(0, 10) 
        : new Date(hopDong.ngayKetThuc).toISOString().slice(0, 10);
      setHuyTruocHan(today < endDateStr);
    } else {
      setHuyTruocHan(false);
    }

    void loadData();
  }, [isOpen, hopDong?._id]);

  const loadData = async () => {
    if (!hopDong?._id) return;
    setLoading(true);
    try {
      const now = new Date();
      const [readingResponse, settlementResponse] = await Promise.all([
        fetch(`/api/hoa-don/latest-reading?hopDongId=${hopDong._id}&thang=${now.getMonth() + 1}&nam=${now.getFullYear()}`, { headers }),
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
        setDonGiaDien(Number(reading.data?.donGiaDien || 0));
        setDonGiaNuoc(Number(reading.data?.donGiaNuoc || 0));
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
        }
      }
    } catch {
      toast.error('Không thể tải thông tin chỉ số điện nước');
    } finally {
      setLoading(false);
    }
  };

  const handleDateChange = (newDate: string) => {
    setNgayTraPhong(newDate);
    if (hopDong?.ngayKetThuc) {
      const endDateStr = typeof hopDong.ngayKetThuc === 'string' 
        ? hopDong.ngayKetThuc.slice(0, 10) 
        : new Date(hopDong.ngayKetThuc).toISOString().slice(0, 10);
      setHuyTruocHan(newDate < endDateStr);
    }
  };

  const addDeduction = () => setKhoanKhauTru(items => [...items, { moTa: '', soTien: 0 }]);
  const updateDeduction = (index: number, patch: Partial<KhoanKhauTru>) => setKhoanKhauTru(items => items.map((item, i) => i === index ? { ...item, ...patch } : item));
  const removeDeduction = (index: number) => setKhoanKhauTru(items => items.filter((_, i) => i !== index));

  const dienTieuThu = Math.max(0, chiSoDienCuoiKy - chiSoDienBanDau);
  const nuocTieuThu = Math.max(0, chiSoNuocCuoiKy - chiSoNuocBanDau);
  const uocTinhDien = dienTieuThu * donGiaDien;
  const uocTinhNuoc = nuocTieuThu * donGiaNuoc;
  const tongKhauTruHuHai = useMemo(() => 
    khoanKhauTru.reduce((sum, item) => sum + (Number(item.soTien) || 0), 0),
    [khoanKhauTru]
  );
  const tienCocGoc = Number(hopDong?.tienCoc || 0);

  const tongChiPhiPhatSinhUocTinh = uocTinhDien + uocTinhNuoc + tongKhauTruHuHai;
  const tienCocDaCanTruUocTinh = Math.min(tienCocGoc, tongChiPhiPhatSinhUocTinh);
  const tienCocConDuUocTinh = Math.max(0, tienCocGoc - tongChiPhiPhatSinhUocTinh);
  const tienPhaiThuThemUocTinh = Math.max(0, tongChiPhiPhatSinhUocTinh - tienCocGoc);

  const handleFastCheckout = async () => {
    if (!hopDong?._id) return;
    if (chiSoDienCuoiKy < chiSoDienBanDau || chiSoNuocCuoiKy < chiSoNuocBanDau) {
      toast.error('Chỉ số điện/nước cuối kỳ không được nhỏ hơn đầu kỳ');
      return;
    }
    if (khoanKhauTru.some(k => !k.moTa.trim() || k.soTien <= 0)) {
      toast.error('Vui lòng nhập đầy đủ mô tả và số tiền hợp lệ cho các khoản khấu trừ');
      return;
    }

    setSubmitting(true);
    try {
      const createRes = await fetch(`/api/hop-dong/${hopDong._id}/quyet-toan-tra-phong`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', ...(headers || {}) },
        body: JSON.stringify({
          ngayTraPhong: ngayTraPhong || new Date().toISOString().slice(0, 10),
          huyTruocHan,
          chiSoDienBanDau,
          chiSoDienCuoiKy,
          chiSoNuocBanDau,
          chiSoNuocCuoiKy,
          khoanKhauTru,
          ghiChu: ghiChu || (huyTruocHan ? 'Hủy phòng trước hạn (Không hoàn cọc)' : 'Quyết toán trả phòng hoàn tất'),
        }),
      });
      const createData = await createRes.json();
      if (!createRes.ok || !createData.success) throw new Error(createData.message || 'Lỗi khi lập quyết toán');

      const completeRes = await fetch(`/api/hop-dong/${hopDong._id}/quyet-toan-tra-phong/hoan-tat`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', ...(headers || {}) },
        body: JSON.stringify({
          daHoanCoc: !huyTruocHan,
          banGiaoDaXacNhan: true,
          veSinhKiemTraXong: true,
          ghiChu: ghiChu || 'Hoàn tất trả phòng qua hệ thống EasyHouse',
        }),
      });
      const completeData = await completeRes.json();
      if (!completeRes.ok || !completeData.success) throw new Error(completeData.message || 'Lỗi khi hoàn tất trả phòng');

      toast.success('Trả phòng thành công! Hợp đồng đã kết thúc và phòng đã chuyển sang trạng thái Trống.');
      onSuccess(completeData.data || hopDong);
      onClose();
    } catch (error) {
      console.error(error);
      toast.error(error instanceof Error ? error.message : 'Có lỗi xảy ra khi hoàn tất trả phòng');
    } finally {
      setSubmitting(false);
    }
  };

  const updateAsset = (index: number, patch: Partial<TaiSanBanGiao>) => {
    setTaiSanBanGiao(items => items.map((item, i) => i === index ? { ...item, ...patch } : item));
  };

  const saveAssetHandover = async () => {
    if (!hopDong?._id) return;
    setSavingAssets(true);
    try {
      const response = await fetch(`/api/hop-dong/${hopDong._id}/quyet-toan-tra-phong/ban-giao`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', ...(headers || {}) },
        body: JSON.stringify({
          items: taiSanBanGiao.map(item => ({
            id: item.id,
            soLuongThucTe: item.soLuongThucTe ?? item.soLuongBanDau,
            tinhTrangThucTe: item.tinhTrangThucTe || item.tinhTrangBanDau,
            chungTuUrl: item.chungTuUrl,
            ghiChu: item.ghiChu,
            daXacNhan: true,
            mucKhauTru: item.mucKhauTru || 0,
          })),
        }),
      });
      const result = await response.json();
      if (!response.ok || !result.success) throw new Error(result.message);
      setQuyetToan(result.data);
      setTaiSanBanGiao(result.data.taiSanBanGiao || []);
      toast.success('Đã lưu biên bản bàn giao tài sản');
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Không thể lưu kiểm kê tài sản');
    } finally {
      setSavingAssets(false);
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

  const isBenASigned = quyetToan?.bienBanTrangThai === 'BEN_A_DA_KY' || quyetToan?.bienBanTrangThai === 'HOAN_TAT';
  const isBenBSigned = quyetToan?.bienBanTrangThai === 'BEN_B_DA_KY' || quyetToan?.bienBanTrangThai === 'HOAN_TAT';

  const roomName = typeof hopDong?.phong === 'object' 
    ? ((hopDong?.phong as any)?.ten || (hopDong?.phong as any)?.maPhong || '---')
    : '---';

  const tenantName = typeof hopDong?.nguoiDaiDien === 'object'
    ? (hopDong?.nguoiDaiDien as any)?.hoTen || '---'
    : Array.isArray(hopDong?.khachThueId) && typeof hopDong?.khachThueId[0] === 'object'
    ? (hopDong?.khachThueId[0] as any)?.hoTen || '---'
    : '---';

  return (
    <>
      <Dialog open={isOpen} onOpenChange={open => !open && !submitting && onClose()}>
        <DialogContent className="sm:max-w-[650px] max-h-[92vh] overflow-y-auto p-0 rounded-2xl border-none shadow-2xl bg-white">
          {/* Header Banner */}
          <div className="bg-[#243B5A] text-white p-5 rounded-t-2xl relative overflow-hidden">
            <div className="absolute top-0 right-0 w-48 h-48 bg-[#4FA7A0]/15 rounded-full blur-3xl pointer-events-none" />
            <div className="flex items-center justify-between relative z-10">
              <div className="space-y-1">
                <div className="flex items-center gap-2">
                  <span className="text-[11px] font-extrabold uppercase tracking-widest text-[#4FA7A0] bg-[#4FA7A0]/20 px-2 py-0.5 rounded-md">
                    Thủ tục trả phòng
                  </span>
                  <span className="text-xs text-slate-300">
                    Phòng {roomName} · Khách: {tenantName}
                  </span>
                </div>
                <DialogTitle className="text-lg font-bold text-white">
                  Quyết toán & Trả phòng: {hopDong?.maHopDong}
                </DialogTitle>
                <DialogDescription className="text-xs text-slate-300 font-medium">
                  Khấu trừ chi phí & hư hại vào tiền cọc gốc. Tự động giải phóng phòng sang trạng thái Trống.
                </DialogDescription>
              </div>
            </div>

            {/* Navigation Tabs */}
            <div className="mt-4 pt-2 border-t border-white/10">
              <Tabs value={activeTab} onValueChange={(v) => setActiveTab(v as 'quick' | 'detail')} className="w-full">
                <TabsList className="bg-white/10 p-1 rounded-xl h-9 grid grid-cols-2 text-xs">
                  <TabsTrigger value="quick" className="rounded-lg data-[state=active]:bg-white data-[state=active]:text-[#243B5A] font-bold text-slate-200">
                    ⚡ Trả phòng nhanh
                  </TabsTrigger>
                  <TabsTrigger value="detail" className="rounded-lg data-[state=active]:bg-white data-[state=active]:text-[#243B5A] font-bold text-slate-200">
                    📋 Biên bản & Tài sản (Tùy chọn)
                  </TabsTrigger>
                </TabsList>
              </Tabs>
            </div>
          </div>

          <div className="p-5 space-y-4">
            {loading ? (
              <div className="py-12 flex flex-col items-center justify-center space-y-3">
                <Loader2 className="h-8 w-8 animate-spin text-[#4FA7A0]" />
                <p className="text-xs font-medium text-[#6B7A8C]">Đang tải dữ liệu chỉ số điện nước...</p>
              </div>
            ) : activeTab === 'quick' ? (
              /* ── TAB 1: TRẢ PHÒNG NHANH GỌN (CHÍNH) ── */
              <div className="space-y-4">
                {/* 1. Ngày trả phòng & Loại trả phòng */}
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 bg-[#F8F9FA] p-3.5 rounded-xl border border-slate-200">
                  <div className="space-y-1.5">
                    <Label className="text-xs font-bold text-[#243B5A] flex items-center gap-1.5">
                      <Calendar className="h-4 w-4 text-[#4FA7A0]" /> Ngày trả phòng
                    </Label>
                    <Input 
                      type="date" 
                      value={ngayTraPhong} 
                      onChange={e => handleDateChange(e.target.value)}
                      className="h-9 bg-white text-xs font-semibold"
                    />
                  </div>

                  <div className="space-y-1.5 flex flex-col justify-end">
                    <div className={cn(
                      "p-2 rounded-lg border flex items-center justify-between gap-2 transition-all",
                      huyTruocHan ? "bg-red-50/80 border-red-200" : "bg-emerald-50/80 border-emerald-200"
                    )}>
                      <div className="flex items-center gap-2">
                        <Checkbox 
                          id="huyTruocHan" 
                          checked={huyTruocHan} 
                          onCheckedChange={v => setHuyTruocHan(v === true)}
                          className={huyTruocHan ? "data-[state=checked]:bg-red-600" : ""}
                        />
                        <Label htmlFor="huyTruocHan" className={cn(
                          "text-xs font-bold cursor-pointer",
                          huyTruocHan ? "text-red-700" : "text-emerald-800"
                        )}>
                          {huyTruocHan ? 'Hủy phòng trước hạn (Mất cọc)' : 'Trả phòng đúng hạn (Hoàn cọc dư)'}
                        </Label>
                      </div>
                      <Badge className={cn(
                        "text-[10px] font-extrabold px-1.5 py-0.5",
                        huyTruocHan ? "bg-red-100 text-red-700 border-red-300" : "bg-emerald-100 text-emerald-800 border-emerald-300"
                      )} variant="outline">
                        {huyTruocHan ? 'Không hoàn cọc' : 'Có hoàn cọc'}
                      </Badge>
                    </div>
                  </div>
                </div>

                {/* 2. Chốt điện & nước */}
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div className="p-3 rounded-xl border border-amber-200 bg-amber-50/40 space-y-2">
                    <div className="flex items-center justify-between">
                      <Label className="text-xs font-bold text-amber-900 flex items-center gap-1">
                        <Zap className="h-3.5 w-3.5 text-amber-600" /> Điện cuối kỳ (kWh)
                      </Label>
                      <span className="text-[11px] font-bold text-amber-800 bg-amber-100 px-1.5 py-0.5 rounded">
                        +{dienTieuThu} kWh
                      </span>
                    </div>
                    <div className="grid grid-cols-2 gap-2">
                      <div>
                        <span className="text-[10px] text-gray-500 block mb-0.5">Số cũ</span>
                        <Input value={chiSoDienBanDau} disabled className="h-8 bg-white/70 text-xs font-semibold" />
                      </div>
                      <div>
                        <span className="text-[10px] text-gray-700 font-bold block mb-0.5">Số mới *</span>
                        <Input 
                          type="number" 
                          min={chiSoDienBanDau} 
                          value={chiSoDienCuoiKy} 
                          onChange={e => setChiSoDienCuoiKy(Number(e.target.value))} 
                          className="h-8 bg-white font-bold text-xs text-[#243B5A] border-amber-300" 
                        />
                      </div>
                    </div>
                  </div>

                  <div className="p-3 rounded-xl border border-blue-200 bg-blue-50/40 space-y-2">
                    <div className="flex items-center justify-between">
                      <Label className="text-xs font-bold text-blue-900 flex items-center gap-1">
                        <Droplets className="h-3.5 w-3.5 text-blue-600" /> Nước cuối kỳ (m³)
                      </Label>
                      <span className="text-[11px] font-bold text-blue-800 bg-blue-100 px-1.5 py-0.5 rounded">
                        +{nuocTieuThu} m³
                      </span>
                    </div>
                    <div className="grid grid-cols-2 gap-2">
                      <div>
                        <span className="text-[10px] text-gray-500 block mb-0.5">Số cũ</span>
                        <Input value={chiSoNuocBanDau} disabled className="h-8 bg-white/70 text-xs font-semibold" />
                      </div>
                      <div>
                        <span className="text-[10px] text-gray-700 font-bold block mb-0.5">Số mới *</span>
                        <Input 
                          type="number" 
                          min={chiSoNuocBanDau} 
                          value={chiSoNuocCuoiKy} 
                          onChange={e => setChiSoNuocCuoiKy(Number(e.target.value))} 
                          className="h-8 bg-white font-bold text-xs text-[#243B5A] border-blue-300" 
                        />
                      </div>
                    </div>
                  </div>
                </div>

                {/* 3. Khoản khấu trừ hư hại tài sản */}
                <div className="space-y-2 rounded-xl border border-slate-200 bg-[#FBFBFA] p-3.5">
                  <div className="flex items-center justify-between">
                    <div>
                      <Label className="text-xs font-bold text-[#243B5A] uppercase tracking-wider flex items-center gap-1">
                        <ShieldCheck className="h-3.5 w-3.5 text-[#4FA7A0]" /> Khấu trừ hư hại / bồi thường đồ đạc
                      </Label>
                      <p className="text-[11px] text-[#6B7A8C]">
                        Tự động trừ trực tiếp vào tiền cọc (tiền gốc) của khách hàng.
                      </p>
                    </div>
                    <Button size="sm" variant="outline" type="button" onClick={addDeduction} className="text-xs h-7 font-bold border-slate-300">
                      <Plus className="mr-1 h-3 w-3 text-[#4FA7A0]" /> Thêm khoản
                    </Button>
                  </div>

                  {khoanKhauTru.length === 0 ? (
                    <div className="p-2.5 text-center rounded-lg border border-dashed border-slate-200 bg-white text-xs text-slate-500">
                      Không có hư hại đồ đạc nào phát sinh.
                    </div>
                  ) : (
                    <div className="space-y-2">
                      {khoanKhauTru.map((item, index) => (
                        <div className="grid grid-cols-[1fr_130px_auto] gap-2 items-center bg-white p-2 rounded-lg border shadow-2xs" key={index}>
                          <Input 
                            placeholder="Tên hư hại (vd: Vỡ gương, hỏng quạt...)" 
                            value={item.moTa} 
                            onChange={e => updateDeduction(index, { moTa: e.target.value })} 
                            className="h-8 text-xs font-medium"
                          />
                          <Input 
                            type="number" 
                            min="1" 
                            placeholder="Số tiền (VNĐ)" 
                            value={item.soTien || ''} 
                            onChange={e => updateDeduction(index, { soTien: Number(e.target.value) })} 
                            className="h-8 text-xs font-bold text-red-600"
                          />
                          <Button 
                            size="icon" 
                            variant="ghost" 
                            type="button" 
                            onClick={() => removeDeduction(index)}
                            className="h-8 w-8 text-slate-400 hover:text-red-600"
                          >
                            <Trash2 className="h-3.5 w-3.5" />
                          </Button>
                        </div>
                      ))}
                    </div>
                  )}
                </div>

                {/* 4. Bảng tính quyết toán tài chính trực quan (Realtime Financial Summary) */}
                <div className="rounded-xl border border-[#243B5A]/15 bg-gradient-to-br from-[#F8F9FA] to-[#EFF6FF] p-3.5 space-y-2.5 shadow-xs">
                  <div className="flex items-center justify-between pb-1.5 border-b border-slate-200">
                    <span className="text-xs font-bold text-[#243B5A] uppercase tracking-wider flex items-center gap-1">
                      <DollarSign className="h-4 w-4 text-[#4FA7A0]" /> Bảng tính khấu trừ & Quyết toán
                    </span>
                    <span className="text-[11px] text-slate-500 font-medium">Tự động tính từ cọc gốc</span>
                  </div>

                  <div className="grid grid-cols-2 sm:grid-cols-4 gap-2 text-xs">
                    <div className="p-2 bg-white rounded-lg border">
                      <span className="text-[10px] text-gray-500 block">Tiền cọc gốc (A)</span>
                      <span className="font-bold text-[#243B5A] text-sm">{formatVND(tienCocGoc)}</span>
                    </div>
                    <div className="p-2 bg-white rounded-lg border">
                      <span className="text-[10px] text-gray-500 block">Điện + Nước ước tính</span>
                      <span className="font-bold text-slate-700 text-sm">{formatVND(uocTinhDien + uocTinhNuoc)}</span>
                    </div>
                    <div className="p-2 bg-white rounded-lg border">
                      <span className="text-[10px] text-gray-500 block">Khấu trừ hư hại</span>
                      <span className="font-bold text-red-600 text-sm">- {formatVND(tongKhauTruHuHai)}</span>
                    </div>
                    <div className="p-2 bg-white rounded-lg border">
                      <span className="text-[10px] text-gray-500 block">Cọc cấn trừ (B)</span>
                      <span className="font-bold text-red-600 text-sm">- {formatVND(tienCocDaCanTruUocTinh)}</span>
                    </div>
                  </div>

                  {/* Kết luận dòng tiền */}
                  <div className={cn(
                    "p-3 rounded-xl border flex items-center justify-between gap-3 mt-1",
                    huyTruocHan 
                      ? "bg-red-50 border-red-200" 
                      : tienCocConDuUocTinh > 0 
                      ? "bg-emerald-50 border-emerald-200" 
                      : "bg-slate-100 border-slate-200"
                  )}>
                    <div className="space-y-0.5">
                      <span className="text-xs font-bold block">
                        {huyTruocHan ? (
                          <span className="text-red-800 flex items-center gap-1">
                            <AlertCircle className="h-4 w-4 text-red-600" /> Hủy trước hạn: Không hoàn cọc
                          </span>
                        ) : tienCocConDuUocTinh > 0 ? (
                          <span className="text-emerald-800 flex items-center gap-1">
                            <CheckCircle2 className="h-4 w-4 text-emerald-600" /> Số tiền cọc hoàn lại cho khách:
                          </span>
                        ) : (
                          <span className="text-slate-800">Cọc vừa đủ cấn trừ chi phí:</span>
                        )}
                      </span>
                      <span className="text-[11px] text-slate-600">
                        {huyTruocHan 
                          ? (tienPhaiThuThemUocTinh > 0 ? `Chi phí vượt cọc, khách cần đóng thêm` : `Cọc còn dư ${formatVND(tienCocConDuUocTinh)} được giữ lại`)
                          : (tienPhaiThuThemUocTinh > 0 ? `Khách cần đóng thêm phần vượt cọc` : `Đã trừ hết chi phí và hư hại vào cọc gốc`)}
                      </span>
                    </div>
                    
                    <div className="text-right">
                      {huyTruocHan ? (
                        tienPhaiThuThemUocTinh > 0 ? (
                          <span className="text-base font-black text-red-700">{formatVND(tienPhaiThuThemUocTinh)}</span>
                        ) : (
                          <span className="text-sm font-bold text-red-700">0 đ (Mất cọc)</span>
                        )
                      ) : tienCocConDuUocTinh > 0 ? (
                        <span className="text-lg font-black text-emerald-700">{formatVND(tienCocConDuUocTinh)}</span>
                      ) : (
                        <span className="text-base font-black text-red-700">{formatVND(tienPhaiThuThemUocTinh)}</span>
                      )}
                    </div>
                  </div>
                </div>
              </div>
            ) : (
              /* ── TAB 2: BIÊN BẢN & TÀI SẢN (TÙY CHỌN) ── */
              <div className="space-y-4">
                {/* Asset Checklist */}
                <div className="space-y-3 rounded-xl border border-slate-200 bg-[#FBFBFA] p-3.5">
                  <div className="flex items-center justify-between">
                    <div>
                      <Label className="text-xs font-bold text-[#243B5A] uppercase tracking-wider">
                        Danh mục đồ đạc trong phòng
                      </Label>
                      <p className="text-[11px] text-[#6B7A8C]">
                        Ghi nhận hiện trạng đồ đạc khi bàn giao phòng (tùy chọn).
                      </p>
                    </div>
                    {taiSanBanGiao.length > 0 && (
                      <Button size="sm" type="button" onClick={saveAssetHandover} disabled={savingAssets} className="text-xs h-7 bg-[#4FA7A0] text-white font-bold">
                        {savingAssets ? <Loader2 className="mr-1 h-3 w-3 animate-spin" /> : <ShieldCheck className="mr-1 h-3 w-3" />}
                        Lưu đồ đạc
                      </Button>
                    )}
                  </div>

                  {taiSanBanGiao.length === 0 ? (
                    <div className="p-3 text-center rounded-lg border border-dashed border-slate-200 bg-white text-xs text-slate-500">
                      Phòng này không có danh mục tài sản riêng cần kiểm kê.
                    </div>
                  ) : (
                    <div className="space-y-2 max-h-48 overflow-y-auto pr-1">
                      {taiSanBanGiao.map((item, index) => (
                        <div className="grid grid-cols-[1fr_80px_1fr] gap-2 items-center bg-white p-2 rounded-lg border text-xs" key={item.id}>
                          <div>
                            <span className="font-bold text-[#243B5A] block">{item.tenTaiSan}</span>
                            <span className="text-[10px] text-slate-500">Gốc: {item.soLuongBanDau} ({item.tinhTrangBanDau})</span>
                          </div>
                          <div>
                            <Input 
                              type="number" 
                              min="0" 
                              max={item.soLuongBanDau} 
                              value={item.soLuongThucTe ?? item.soLuongBanDau} 
                              onChange={e => updateAsset(index, { soLuongThucTe: Number(e.target.value) })}
                              className="h-7 text-xs font-bold"
                            />
                          </div>
                          <div>
                            <Input 
                              placeholder="Tình trạng (Tốt/Hỏng...)" 
                              value={item.tinhTrangThucTe || item.tinhTrangBanDau} 
                              onChange={e => updateAsset(index, { tinhTrangThucTe: e.target.value })} 
                              className="h-7 text-xs"
                            />
                          </div>
                        </div>
                      ))}
                    </div>
                  )}
                </div>

                {/* Chữ ký số (Tùy chọn) */}
                <div className="rounded-xl border border-slate-200 bg-white p-3.5 space-y-3">
                  <div className="flex items-center justify-between">
                    <Label className="text-xs font-bold text-[#243B5A] uppercase tracking-wider flex items-center gap-1.5">
                      <FileCheck2 className="h-4 w-4 text-[#4FA7A0]" /> Chữ ký biên bản bàn giao (Tùy chọn)
                    </Label>
                    {hopDong?._id && (
                      <Button size="sm" variant="ghost" asChild className="text-xs h-7 text-[#243B5A]">
                        <a href={`/api/hop-dong/${hopDong._id}/bien-ban-ban-giao?format=pdf&token=${accessToken || ''}`} target="_blank" rel="noreferrer">
                          <ExternalLink className="mr-1 h-3 w-3" /> Xem PDF
                        </a>
                      </Button>
                    )}
                  </div>

                  <div className="grid grid-cols-2 gap-2">
                    <div className="p-2.5 rounded-lg border bg-[#F8F9FA] flex flex-col justify-between space-y-2">
                      <div className="flex items-center justify-between">
                        <span className="text-xs font-bold text-[#243B5A]">Chủ trọ (Bên A)</span>
                        {isBenASigned ? (
                          <Badge className="bg-emerald-600 text-white text-[10px]">Đã ký</Badge>
                        ) : (
                          <Badge variant="outline" className="text-slate-500 text-[10px]">Chưa ký</Badge>
                        )}
                      </div>
                      {!isBenASigned && (
                        <Button size="sm" type="button" onClick={() => setOpenSignPadBenA(true)} className="text-xs font-bold bg-[#243B5A] text-white h-7">
                          <PenTool className="mr-1 h-3 w-3 text-[#4FA7A0]" /> Ký ngay
                        </Button>
                      )}
                    </div>

                    <div className="p-2.5 rounded-lg border bg-[#F8F9FA] flex flex-col justify-between space-y-2">
                      <div className="flex items-center justify-between">
                        <span className="text-xs font-bold text-[#243B5A]">Khách thuê (Bên B)</span>
                        {isBenBSigned ? (
                          <Badge className="bg-emerald-600 text-white text-[10px]">Đã ký</Badge>
                        ) : (
                          <Badge variant="outline" className="text-slate-500 text-[10px]">Chưa ký</Badge>
                        )}
                      </div>
                      {!isBenBSigned && (
                        <Button size="sm" variant="outline" type="button" onClick={() => setOpenSignPadBenB(true)} className="text-xs font-bold text-orange-700 bg-orange-50 border-orange-200 h-7">
                          <PenTool className="mr-1 h-3 w-3 text-orange-600" /> Khách ký
                        </Button>
                      )}
                    </div>
                  </div>
                </div>
              </div>
            )}
          </div>

          {/* Footer Actions */}
          <DialogFooter className="bg-[#F8F3EC] p-3.5 px-5 border-t border-slate-200 flex flex-row items-center justify-between sm:justify-between">
            <Button 
              variant="outline" 
              type="button"
              size="sm"
              onClick={onClose} 
              disabled={submitting}
              className="text-xs font-bold"
            >
              Hủy
            </Button>

            <div className="flex items-center gap-2">
              <Button 
                type="button"
                size="sm"
                onClick={handleFastCheckout} 
                disabled={submitting}
                className="bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold h-9 px-5 shadow-sm shadow-emerald-600/25 transition-all"
              >
                {submitting ? <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" /> : <CheckCircle2 className="mr-1.5 h-3.5 w-3.5" />}
                Xác nhận & Hoàn tất trả phòng
              </Button>
            </div>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Signature Pad Dialogs */}
      {hopDong?._id && (
        <>
          <HopDongSignaturePad
            isOpen={openSignPadBenA}
            onClose={() => setOpenSignPadBenA(false)}
            hopDongId={hopDong._id}
            accessToken={accessToken}
            role="LANDLORD"
            title="Ký biên bản bàn giao (Bên A - Chủ trọ)"
            description="Chữ ký sẽ được đóng dấu vào Biên bản bàn giao trả phòng."
            endpoint={`/api/hop-dong/${hopDong._id}/bien-ban-ban-giao/ky`}
            buildBody={(chuKyBase64: string) => ({ vaiTro: 'BEN_A', chuKyBase64 })}
            onSuccess={() => { void reloadSettlement(); }}
          />

          <HopDongSignaturePad
            isOpen={openSignPadBenB}
            onClose={() => setOpenSignPadBenB(false)}
            hopDongId={hopDong._id}
            accessToken={accessToken}
            role="TENANT"
            title="Ký biên bản bàn giao (Bên B - Khách thuê)"
            description="Khách thuê ký xác nhận số liệu chốt điện nước và bàn giao phòng."
            endpoint={`/api/hop-dong/${hopDong._id}/bien-ban-ban-giao/ky`}
            buildBody={(chuKyBase64: string) => ({ vaiTro: 'BEN_B', chuKyBase64 })}
            onSuccess={() => { void reloadSettlement(); }}
          />
        </>
      )}
    </>
  );
}
