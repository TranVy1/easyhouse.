'use client';

import { useState, useEffect, useCallback } from 'react';
import { useRouter } from 'next/navigation';
import { useSession } from 'next-auth/react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Label } from '@/components/ui/label';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { 
  ArrowLeft,
  Save,
  FileText,
  Zap,
  Droplets,
  Wrench,
  Calculator,
  RefreshCw,
  Car,
  CheckCircle2,
  Clock,
  ShieldAlert,
  Info
} from 'lucide-react';
import { HopDong, Phong, KhachThue } from '@/types';
import { toast } from 'sonner';

const invoiceControlClass =
  "h-11 min-h-11 w-full rounded-xl border border-[#E6DED2] bg-white px-4 text-sm leading-none text-[#0F2A43] shadow-sm outline-none transition-all focus-visible:ring-1 focus-visible:ring-[#4FA7A0]/40";

// Helper functions
const getPhongName = (phongId: string | Phong, phongList: Phong[]) => {
  if (!phongId) return 'N/A';
  if (typeof phongId === 'object' && phongId.maPhong) {
    return phongId.maPhong;
  }
  if (typeof phongId === 'string') {
    const phong = phongList.find(p => p._id === phongId);
    return phong?.maPhong || 'N/A';
  }
  return 'N/A';
};

const getKhachThueName = (khachThueId: string | KhachThue, khachThueList: KhachThue[]) => {
  if (!khachThueId) return 'N/A';
  if (typeof khachThueId === 'object' && khachThueId.hoTen) {
    return khachThueId.hoTen;
  }
  if (typeof khachThueId === 'string') {
    const khachThue = khachThueList.find(k => k._id === khachThueId);
    return khachThue?.hoTen || 'N/A';
  }
  return 'N/A';
};

const calculateProratedRent = (hopDong: HopDong, thang: number, nam: number) => {
  const monthlyRent = Number(hopDong.giaThue || 0);
  if (!monthlyRent) return 0;

  const monthStart = new Date(nam, thang - 1, 1);
  const monthEnd = new Date(nam, thang, 0);
  const toLocalDate = (value?: string | Date) => {
    if (!value) return null;
    const date = new Date(value);
    return Number.isNaN(date.getTime())
      ? null
      : new Date(date.getFullYear(), date.getMonth(), date.getDate());
  };
  const contractStart = toLocalDate(hopDong.ngayBatDau);
  const scheduledEnd = toLocalDate(hopDong.ngayKetThuc);
  const actualEnd = toLocalDate(hopDong.ngayKetThucThucTe);
  const contractEnd = scheduledEnd && actualEnd
    ? (scheduledEnd < actualEnd ? scheduledEnd : actualEnd)
    : scheduledEnd || actualEnd;

  const occupiedStart = contractStart && contractStart > monthStart ? contractStart : monthStart;
  const occupiedEnd = contractEnd && contractEnd < monthEnd ? contractEnd : monthEnd;
  if (occupiedEnd < occupiedStart) return 0;

  const occupiedDays = Math.floor((occupiedEnd.getTime() - occupiedStart.getTime()) / 86_400_000) + 1;
  return Math.round((monthlyRent * occupiedDays / monthEnd.getDate()) * 100) / 100;
};

export default function ThemMoiHoaDonPage() {
  const router = useRouter();
  const { data: session } = useSession();
  const accessToken = session?.accessToken;
  const [hopDongList, setHopDongList] = useState<HopDong[]>([]);
  const [phongList, setPhongList] = useState<Phong[]>([]);
  const [khachThueList, setKhachThueList] = useState<KhachThue[]>([]);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);

  const [formData, setFormData] = useState({
    maHoaDon: '',
    hopDong: '',
    phong: '',
    khachThue: '',
    thang: new Date().getMonth() + 1,
    nam: new Date().getFullYear(),
    tienPhong: 0,
    tienDien: 0,
    soDien: 0,
    chiSoDienBanDau: 0,
    chiSoDienCuoiKy: 0,
    giaDien: 0,
    tienNuoc: 0,
    soNuoc: 0,
    chiSoNuocBanDau: 0,
    chiSoNuocCuoiKy: 0,
    giaNuoc: 0,
    phiDichVu: [] as Array<{ten: string, gia: number, soLuong?: number, donVi?: string}>,
    phuongTienList: [] as Array<{id?: string, bienSo: string, loaiXe: string, moTa?: string, donGia: number, thanhTien: number, activeDays?: number, totalDays?: number}>,
    tongTienXe: 0,
    tongTien: 0,
    daThanhToan: 0,
    conLai: 0,
    trangThai: 'chuaThanhToan' as 'nhap' | 'chuaThanhToan',
    hanThanhToan: '',
    ghiChu: '',
    soDuDauKy: 0,
    resetCongTo: false,
    soKwhThucTe: 0,
    soKhoiNuocThucTe: 0,
  });

  // Tự động sinh mã hóa đơn
  const generateInvoiceCode = () => {
    const currentDate = new Date();
    const year = currentDate.getFullYear();
    const month = String(currentDate.getMonth() + 1).padStart(2, '0');
    const day = String(currentDate.getDate()).padStart(2, '0');
    const randomNum = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
    
    return `HD${year}${month}${day}${randomNum}`;
  };

  const [newPhiDichVu, setNewPhiDichVu] = useState({ ten: '', gia: 0 });
  const [readingSource, setReadingSource] = useState<{
    chiSoDienBanDau: number;
    chiSoDienCuoiKy: number;
    chiSoNuocBanDau: number;
    chiSoNuocCuoiKy: number;
    isFirstInvoice: boolean;
    lastInvoiceMonth: string | null;
    coChiSoDienKyNay?: boolean;
    coChiSoNuocKyNay?: boolean;
  } | null>(null);

  useEffect(() => {
    if (!accessToken) return;
    fetchFormData();
    // Tự động sinh mã hóa đơn khi trang load
    setFormData(prev => ({ ...prev, maHoaDon: generateInvoiceCode() }));
  // fetchFormData is declared below to preserve the legacy form initialization order.
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [accessToken]);

  const fetchFormData = async () => {
    try {
      const formDataResponse = await fetch('/api/hoa-don/form-data', {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      if (formDataResponse.ok) {
        const formData = await formDataResponse.json();
        console.log('Form data loaded:', formData.data);
        const data = formData.data || {};
        setHopDongList(data.hopDongList || []);
        setPhongList(data.phongList || []);
        setKhachThueList(data.khachThueList || []);
      } else {
        console.error('Failed to load form data:', formDataResponse.status);
      }
    } catch (error) {
      console.error('Error fetching form data:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchLatestElectricityReading = useCallback(async (hopDongId: string, thang: number, nam: number) => {
    try {
      const response = await fetch(`/api/hoa-don/latest-reading?hopDong=${hopDongId}&thang=${thang}&nam=${nam}`, {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      if (response.ok) {
        const data = await response.json();
        if (data.success && data.data) {
          console.log('Latest invoice prefill bundle:', data.data);
          const bundle = data.data;
          setFormData(prev => {
            const chiSoDien = Number(bundle.chiSoDienBanDau) || 0;
            const chiSoNuoc = Number(bundle.chiSoNuocBanDau) || 0;
            const chiSoDienCuoiKy = Number.isFinite(Number(bundle.chiSoDienCuoiKy))
              ? Number(bundle.chiSoDienCuoiKy)
              : chiSoDien;
            const chiSoNuocCuoiKy = Number.isFinite(Number(bundle.chiSoNuocCuoiKy))
              ? Number(bundle.chiSoNuocCuoiKy)
              : chiSoNuoc;

            return {
              ...prev,
              tienPhong: bundle.tienPhong !== undefined ? Number(bundle.tienPhong) : prev.tienPhong,
              chiSoDienBanDau: chiSoDien,
              chiSoDienCuoiKy,
              giaDien: Number(bundle.donGiaDien) || prev.giaDien,
              chiSoNuocBanDau: chiSoNuoc,
              chiSoNuocCuoiKy,
              giaNuoc: Number(bundle.donGiaNuoc) || prev.giaNuoc,
              phiDichVu: Array.isArray(bundle.phiDichVu) && bundle.phiDichVu.length > 0
                ? bundle.phiDichVu.map((s: any) => ({
                    ten: s.ten,
                    gia: Number(s.gia) || 0,
                    soLuong: Number(s.soLuong) || 1,
                    donVi: s.donVi || 'tháng'
                  }))
                : prev.phiDichVu,
              phuongTienList: Array.isArray(bundle.phuongTienList) ? bundle.phuongTienList : [],
              tongTienXe: Number(bundle.tongTienXe) || 0,
              soDuDauKy: Number(bundle.soDuDauKy) || 0,
              hanThanhToan: prev.hanThanhToan || bundle.hanThanhToan || '',
            };
          });
          setReadingSource(bundle);
        }
      }
    } catch (error) {
      console.error('Error fetching latest electricity reading:', error);
    }
  }, [accessToken]);

  // Helper: trích xuất UUID string từ object hoặc string
  const extractId = (value: unknown): string => {
    if (!value) return '';
    if (typeof value === 'string') return value;
    if (typeof value === 'object' && value !== null && '_id' in value) {
      return (value as { _id: string })._id;
    }
    return '';
  };

  // Auto-fill form data when contract is selected
  useEffect(() => {
    if (formData.hopDong) {
      const selectedHopDong = hopDongList.find(hd => hd._id === formData.hopDong);
      if (selectedHopDong) {
        console.log('Auto-filling form data from contract:', selectedHopDong);
        
        // Trích xuất UUID string từ object (phong có thể là {_id, maPhong, ...})
        const phongId = extractId(selectedHopDong.phong);
        const khachThueId = extractId(selectedHopDong.nguoiDaiDien);
        
        setFormData(prev => ({
          ...prev,
          phong: phongId,
          khachThue: khachThueId,
          tienPhong: calculateProratedRent(selectedHopDong, prev.thang, prev.nam),
          phiDichVu: selectedHopDong.phiDichVu || [],
          chiSoDienBanDau: selectedHopDong.chiSoDienBanDau || 0,
          chiSoDienCuoiKy: selectedHopDong.chiSoDienBanDau || 0,
          chiSoNuocBanDau: selectedHopDong.chiSoNuocBanDau || 0,
          chiSoNuocCuoiKy: selectedHopDong.chiSoNuocBanDau || 0,
        }));
        
        fetchLatestElectricityReading(formData.hopDong, formData.thang, formData.nam);
      }
    }
  }, [formData.hopDong, hopDongList, formData.thang, formData.nam, fetchLatestElectricityReading]);

  // Tự động cập nhật chỉ số khi thay đổi tháng/năm
  useEffect(() => {
    if (formData.hopDong && (formData.thang || formData.nam)) {
      fetchLatestElectricityReading(formData.hopDong, formData.thang, formData.nam);
    }
  }, [formData.hopDong, formData.thang, formData.nam, fetchLatestElectricityReading]);

  const calculateTotal = useCallback(() => {
    const selectedHopDong = hopDongList.find(hd => hd._id === formData.hopDong);
    
    // Tìm dịch vụ Điện và Nước trong phiDichVu
    const dienService = selectedHopDong?.phiDichVu?.find(p => p.ten.toLowerCase().includes('điện') || p.ten.toLowerCase().includes('electricity'));
    const nuocService = selectedHopDong?.phiDichVu?.find(p => p.ten.toLowerCase().includes('nước') || p.ten.toLowerCase().includes('water'));
    
    // Ưu tiên đơn giá gốc từ hợp đồng hoặc từ readingSource
    const giaDien = formData.giaDien || selectedHopDong?.giaDien || (dienService ? dienService.gia : 0);
    const giaNuoc = formData.giaNuoc || selectedHopDong?.giaNuoc || (nuocService ? nuocService.gia : 0);
    
    // Lọc bỏ Điện và Nước khỏi tổng phí dịch vụ để không bị tính đúp
    const filteredPhiDichVu = formData.phiDichVu.filter(phi => 
      !phi.ten.toLowerCase().includes('điện') && 
      !phi.ten.toLowerCase().includes('electricity') && 
      !phi.ten.toLowerCase().includes('nước') && 
      !phi.ten.toLowerCase().includes('water')
    );
    const totalPhiDichVu = filteredPhiDichVu.reduce((sum: number, phi) => sum + (phi.gia * (phi.soLuong || 1)), 0);

    const soDien = Math.max(0, formData.resetCongTo
      ? formData.soKwhThucTe
      : formData.chiSoDienCuoiKy - formData.chiSoDienBanDau);
    const soNuoc = Math.max(0, formData.resetCongTo
      ? formData.soKhoiNuocThucTe
      : formData.chiSoNuocCuoiKy - formData.chiSoNuocBanDau);
    
    const tienDienTinh = soDien * giaDien;
    const tienNuocTinh = soNuoc * giaNuoc;
    const tongTienXe = formData.tongTienXe || 0;
    const soDuDauKy = formData.soDuDauKy || 0;
    
    const total = formData.tienPhong + tienDienTinh + tienNuocTinh + totalPhiDichVu + tongTienXe + soDuDauKy;
    const conLai = total - formData.daThanhToan;
    
    setFormData(prev => ({
      ...prev,
      soDien,
      soNuoc,
      giaDien,
      giaNuoc,
      tienDien: tienDienTinh,
      tienNuoc: tienNuocTinh,
      tongTien: total,
      conLai: conLai
    }));
  }, [
    formData.tienPhong,
    formData.chiSoDienCuoiKy,
    formData.chiSoDienBanDau,
    formData.chiSoNuocCuoiKy,
    formData.chiSoNuocBanDau,
    formData.giaDien,
    formData.giaNuoc,
    formData.daThanhToan,
    formData.phiDichVu,
    formData.phuongTienList,
    formData.tongTienXe,
    formData.hopDong,
    formData.soDuDauKy,
    formData.resetCongTo,
    formData.soKwhThucTe,
    formData.soKhoiNuocThucTe,
    hopDongList,
  ]);

  useEffect(() => {
    calculateTotal();
  }, [calculateTotal]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Kiểm tra validation trước khi submit
    if (formData.chiSoDienBanDau < 0 || formData.chiSoDienCuoiKy < 0) {
      toast.error('Chỉ số điện không được âm');
      return;
    }
    
    if (formData.chiSoNuocBanDau < 0 || formData.chiSoNuocCuoiKy < 0) {
      toast.error('Chỉ số nước không được âm');
      return;
    }
    
    if (!formData.resetCongTo && formData.chiSoDienCuoiKy < formData.chiSoDienBanDau) {
      toast.error('Chỉ số điện cuối kỳ phải lớn hơn hoặc bằng chỉ số ban đầu');
      return;
    }
    
    if (!formData.resetCongTo && formData.chiSoNuocCuoiKy < formData.chiSoNuocBanDau) {
      toast.error('Chỉ số nước cuối kỳ phải lớn hơn hoặc bằng chỉ số ban đầu');
      return;
    }
    
    setSubmitting(true);
    
    try {
      // Lọc bỏ Điện và Nước khỏi phiDichVu để backend không thêm đúp (backend tự add tiền điện/nước riêng)
      const filteredPhiDichVu = formData.phiDichVu.filter(phi => 
        !phi.ten.toLowerCase().includes('điện') && 
        !phi.ten.toLowerCase().includes('electricity') && 
        !phi.ten.toLowerCase().includes('nước') && 
        !phi.ten.toLowerCase().includes('water')
      );

      // Đảm bảo các trường ID luôn là UUID string, không phải object
      const requestData = {
        ...formData,
        kyThang: formData.thang,
        kyNam: formData.nam,
        hanTra: formData.hanThanhToan,
        tuNgay: `${formData.nam}-${String(formData.thang).padStart(2, '0')}-01`,
        denNgay: new Date(formData.nam, formData.thang, 0).toISOString().split('T')[0],
        phiDichVu: filteredPhiDichVu,
        hopDong: extractId(formData.hopDong) || formData.hopDong,
        phong: extractId(formData.phong) || formData.phong,
        khachThue: extractId(formData.khachThue) || formData.khachThue,
        resetCongTo: formData.resetCongTo,
        soKwhThucTe: formData.soKwhThucTe,
        soKhoiNuocThucTe: formData.soKhoiNuocThucTe,
        // Nếu maHoaDon trống, không gửi để backend tự sinh
        ...(formData.maHoaDon.trim() ? {} : { maHoaDon: undefined }),
      };
      
      console.log('Submitting form data:', requestData);
      
      const response = await fetch('/api/hoa-don', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify(requestData),
      });

      if (response.ok) {
        const result = await response.json();
        // Xóa cache
        sessionStorage.removeItem('hoa-don-data');
        toast.success(result.message || 'Hóa đơn đã được tạo thành công');
        router.replace('/dashboard/hoa-don');
        router.refresh();
      } else {
        const errorData = await response.json();
        toast.error(errorData.message || 'Có lỗi xảy ra');
      }
    } catch (error) {
      console.error('Error submitting form:', error);
      toast.error('Có lỗi xảy ra khi gửi dữ liệu');
    } finally {
      setSubmitting(false);
    }
  };

  const addPhiDichVu = () => {
    if (newPhiDichVu.ten && newPhiDichVu.gia > 0) {
      setFormData(prev => ({
        ...prev,
        phiDichVu: [...prev.phiDichVu, { ...newPhiDichVu }]
      }));
      setNewPhiDichVu({ ten: '', gia: 0 });
    }
  };

  const removePhiDichVu = (index: number) => {
    setFormData(prev => ({
      ...prev,
      phiDichVu: prev.phiDichVu.filter((_, i) => i !== index)
    }));
  };

  if (loading) {
    return (
      <div className="space-y-6">
        <div className="flex items-center gap-4">
          <div className="h-8 w-8 bg-gray-200 rounded animate-pulse"></div>
          <div className="h-8 bg-gray-200 rounded w-48 animate-pulse"></div>
        </div>
        <div className="h-96 bg-gray-200 rounded animate-pulse"></div>
      </div>
    );
  }

  return (
    <div className="space-y-4 md:space-y-6">
      {/* Header */}
      <div className="flex items-center gap-3 md:gap-4">
        <Button 
          variant="outline" 
          size="sm"
          onClick={() => router.push('/dashboard/hoa-don')}
        >
          <ArrowLeft className="h-4 w-4" />
        </Button>
        <div>
          <h1 className="text-xl md:text-2xl lg:text-3xl font-bold text-gray-900">Tạo hóa đơn mới</h1>
          <p className="text-xs md:text-sm text-gray-600">Nhập thông tin hóa đơn mới</p>
        </div>
      </div>

      {/* Form */}
      <Card>
        <CardHeader className="p-4 md:p-6">
          <CardTitle className="text-lg md:text-xl">Thông tin hóa đơn</CardTitle>
          <CardDescription className="text-xs md:text-sm">
            Điền đầy đủ thông tin để tạo hóa đơn mới
          </CardDescription>
        </CardHeader>
        <CardContent className="p-4 md:p-6">
          <form onSubmit={handleSubmit}>
            <Tabs defaultValue="thong-tin" className="w-full">
              <TabsList className="grid w-full grid-cols-5">
                <TabsTrigger value="thong-tin" className="flex items-center gap-1 md:gap-2 text-xs md:text-sm px-1 md:px-3">
                  <FileText className="h-3 w-3 md:h-4 md:w-4" />
                  <span className="hidden sm:inline">Thông tin</span>
                  <span className="sm:hidden">Info</span>
                </TabsTrigger>
                <TabsTrigger value="dien-nuoc" className="flex items-center gap-1 md:gap-2 text-xs md:text-sm px-1 md:px-3">
                  <Zap className="h-3 w-3 md:h-4 md:w-4" />
                  <span className="hidden sm:inline">Điện & Nước</span>
                  <span className="sm:hidden">Đ&N</span>
                </TabsTrigger>
                <TabsTrigger value="dich-vu" className="flex items-center gap-1 md:gap-2 text-xs md:text-sm px-1 md:px-3">
                  <Wrench className="h-3 w-3 md:h-4 md:w-4" />
                  <span className="hidden sm:inline">Dịch vụ</span>
                  <span className="sm:hidden">DV</span>
                </TabsTrigger>
                <TabsTrigger value="phuong-tien" className="flex items-center gap-1 md:gap-2 text-xs md:text-sm px-1 md:px-3">
                  <Car className="h-3 w-3 md:h-4 md:w-4" />
                  <span className="hidden sm:inline">Phí xe</span>
                  <span className="sm:hidden">Xe</span>
                </TabsTrigger>
                <TabsTrigger value="tong-ket" className="flex items-center gap-1 md:gap-2 text-xs md:text-sm px-1 md:px-3">
                  <Calculator className="h-3 w-3 md:h-4 md:w-4" />
                  <span className="hidden sm:inline">Tổng kết</span>
                  <span className="sm:hidden">TK</span>
                </TabsTrigger>
              </TabsList>

              <TabsContent value="thong-tin" className="space-y-5 mt-6">
                <div className="col-span-full w-full">
                  <div className="grid w-full grid-cols-1 lg:grid-cols-2 gap-5 items-start">
                    <div className="flex w-full min-w-0 flex-col gap-2">
                      <Label htmlFor="maHoaDon" className="text-sm font-semibold text-[#243B5A]">Mã hóa đơn</Label>
                      <div className="relative w-full min-w-0">
                        <Input
                          id="maHoaDon"
                          value={formData.maHoaDon}
                          onChange={(e) => setFormData(prev => ({ ...prev, maHoaDon: e.target.value.toUpperCase() }))}
                          placeholder="HD202401001"
                          required
                          className={`${invoiceControlClass} py-0 pr-12 focus-visible:ring-offset-0`}
                        />
                        <Button
                          type="button"
                          variant="ghost"
                          size="icon"
                          onClick={() => setFormData(prev => ({ ...prev, maHoaDon: generateInvoiceCode() }))}
                          className="absolute right-1.5 top-1/2 h-8 w-8 -translate-y-1/2 rounded-lg border-0 bg-transparent text-[#243B5A] shadow-none hover:bg-[#F8F3EC] hover:text-[#243B5A]"
                          title="Tự động sinh mã hóa đơn"
                        >
                          <RefreshCw className="h-4 w-4" />
                        </Button>
                      </div>
                      <div className="min-h-[28px] text-xs text-[#607089] pt-1">
                        💡 Mã hóa đơn sẽ được tự động sinh nếu để trống
                      </div>
                    </div>

                    <div className="flex w-full min-w-0 flex-col gap-2">
                      <Label htmlFor="hopDong" className="text-sm font-semibold text-[#243B5A]">Hợp đồng *</Label>
                      <div className="flex w-full min-w-0 flex-col gap-2">
                        <Select value={formData.hopDong} onValueChange={(value) => setFormData(prev => ({ ...prev, hopDong: value }))}>
                          <SelectTrigger className={`${invoiceControlClass} justify-between py-0 text-left`}>
                            <SelectValue placeholder="Chọn hợp đồng">
                              {formData.hopDong ? (() => {
                                const hd = hopDongList.find(h => h._id === formData.hopDong);
                                if (!hd) return "Chọn hợp đồng";
                                const phongObj = typeof hd.phong === 'object' ? (hd.phong as Phong) : null;
                                const phongName = phongObj?.maPhong || getPhongName(hd.phong as string, phongList);
                                const toaNhaName = phongObj?.toaNha && typeof phongObj.toaNha === 'object'
                                  ? ((phongObj.toaNha as { tenToaNha?: string }).tenToaNha ?? 'N/A')
                                  : 'N/A';
                                return <span className="block w-full truncate text-left">{hd.maHopDong} • Phòng {phongName} • {toaNhaName}</span>;
                              })() : "Chọn hợp đồng"}
                            </SelectValue>
                          </SelectTrigger>
                          <SelectContent
                            className="w-[calc(100vw-32px)] sm:w-[var(--radix-select-trigger-width)] max-h-[380px] overflow-y-auto rounded-2xl border border-[#E6DED2] bg-white p-2 shadow-xl"
                          >
                            {hopDongList.length === 0 ? (
                              <div className="p-3 text-sm text-gray-500 text-center">Đang tải hợp đồng...</div>
                            ) : (
                              hopDongList
                                .filter(hd => hd.trangThai === 'hoatDong' || hd.trangThai === 'ACTIVE')
                                .map((hopDong) => {
                                  const phongObj = typeof hopDong.phong === 'object' ? (hopDong.phong as Phong) : null;
                                  const phongName = phongObj?.maPhong || getPhongName(hopDong.phong as string, phongList);
                                  const toaNhaName = phongObj?.toaNha && typeof phongObj.toaNha === 'object'
                                    ? ((phongObj.toaNha as { tenToaNha?: string }).tenToaNha ?? 'N/A')
                                    : 'N/A';
                                  const nguoiDaiDienName = getKhachThueName(hopDong.nguoiDaiDien, khachThueList);

                                  const formatDate = (date: string | Date | null | undefined) => {
                                    try {
                                      if (!date) return 'N/A';
                                      const dateObj = new Date(date);
                                      if (isNaN(dateObj.getTime())) return 'N/A';
                                      return dateObj.toLocaleDateString('vi-VN');
                                    } catch {
                                      return 'N/A';
                                    }
                                  };

                                  const ngayBatDau = formatDate(hopDong.ngayBatDau);
                                  const ngayKetThuc = formatDate(hopDong.ngayKetThuc);

                                  return (
                                    <SelectItem
                                      key={hopDong._id}
                                      value={hopDong._id!}
                                      className="p-0 mb-1.5 last:mb-0 items-start rounded-xl border border-transparent focus:bg-transparent data-[state=checked]:bg-transparent whitespace-normal [&>span]:w-full [&>span]:block group"
                                    >
                                      <div className="w-full rounded-xl border border-[#EFE7DA] bg-white pl-8 pr-3 py-2.5 transition-all hover:border-[#4FA7A0]/40 hover:bg-[#F8F3EC] hover:shadow-sm group-data-[state=checked]:bg-[#EAF7F5] group-data-[state=checked]:border-[#4FA7A0] group-data-[state=checked]:ring-1 group-data-[state=checked]:ring-[#4FA7A0]/30">
                                        <div className="flex items-center justify-between gap-3 min-w-0">
                                          <div className="min-w-0 flex-1 truncate text-sm font-bold text-[#243B5A]">
                                            {hopDong.maHopDong}
                                          </div>
                                          <span className="shrink-0 rounded-full bg-[#EAF7F5] px-2 py-0.5 text-[11px] font-semibold text-[#4FA7A0]">
                                            Đang hoạt động
                                          </span>
                                        </div>

                                        <div className="mt-1 flex flex-wrap items-center gap-x-2 gap-y-0.5 text-sm font-medium text-[#334155]">
                                          <span>Phòng {phongName}</span>
                                          {toaNhaName !== 'N/A' && (
                                            <>
                                              <span className="text-slate-300">•</span>
                                              <span className="break-words">{toaNhaName}</span>
                                            </>
                                          )}
                                        </div>

                                        <div className="mt-1 flex flex-wrap items-center gap-x-2 gap-y-0.5 text-xs text-slate-500">
                                          <span className="truncate max-w-[220px]">👤 {nguoiDaiDienName}</span>
                                          <span className="text-slate-300">•</span>
                                          <span>
                                            📅 {ngayBatDau !== 'N/A' && ngayKetThuc !== 'N/A' ? `${ngayBatDau} → ${ngayKetThuc}` : 'Chưa có thông tin ngày'}
                                          </span>
                                        </div>
                                      </div>
                                    </SelectItem>
                                  );
                                })
                            )}
                          </SelectContent>
                        </Select>
                      </div>
                      <div className="min-h-[28px] text-xs text-[#607089] pt-1">
                        {hopDongList.filter(hd => hd.trangThai === 'hoatDong' || hd.trangThai === 'ACTIVE').length} hợp đồng hoạt động
                      </div>
                    </div>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                  <div className="flex flex-col gap-2">
                    <Label htmlFor="phong" className="text-sm font-semibold text-[#243B5A]">Phòng</Label>
                    <Input
                      id="phong"
                      value={getPhongName(formData.phong, phongList)}
                      disabled
                      className="bg-gray-50 h-12 shadow-sm rounded-xl border-gray-200"
                    />
                  </div>
                  
                  <div className="flex flex-col gap-2">
                    <Label htmlFor="khachThue" className="text-sm font-semibold text-[#243B5A]">Khách thuê</Label>
                    <Input
                      id="khachThue"
                      value={getKhachThueName(formData.khachThue, khachThueList)}
                      disabled
                      className="bg-gray-50 h-12 shadow-sm rounded-xl border-gray-200"
                    />
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
                  <div className="flex flex-col gap-2">
                    <Label htmlFor="thang" className="text-sm font-semibold text-[#243B5A]">Tháng</Label>
                    <Input
                      id="thang"
                      type="number"
                      min="1"
                      max="12"
                      value={formData.thang}
                      onChange={(e) => setFormData(prev => ({ ...prev, thang: parseInt(e.target.value) || 1 }))}
                      required
                      className="h-12 shadow-sm rounded-xl border-gray-200"
                    />
                  </div>
                  
                  <div className="flex flex-col gap-2">
                    <Label htmlFor="nam" className="text-sm font-semibold text-[#243B5A]">Năm</Label>
                    <Input
                      id="nam"
                      type="number"
                      min="2020"
                      value={formData.nam}
                      onChange={(e) => setFormData(prev => ({ ...prev, nam: parseInt(e.target.value) || new Date().getFullYear() }))}
                      required
                      className="h-12 shadow-sm rounded-xl border-gray-200"
                    />
                  </div>
                  
                  <div className="flex flex-col gap-2">
                    <Label htmlFor="hanThanhToan" className="text-sm font-semibold text-[#243B5A]">Hạn thanh toán</Label>
                    <Input
                      id="hanThanhToan"
                      type="date"
                      value={formData.hanThanhToan}
                      onChange={(e) => setFormData(prev => ({ ...prev, hanThanhToan: e.target.value }))}
                      required
                      className="h-12 shadow-sm rounded-xl border-gray-200"
                    />
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
                  <div className="flex flex-col gap-2">
                    <Label htmlFor="tienPhong" className="text-sm font-semibold text-[#243B5A]">Tiền phòng (VNĐ)</Label>
                    <Input
                      id="tienPhong"
                      type="number"
                      min="0"
                      value={formData.tienPhong}
                      onChange={(e) => setFormData(prev => ({ ...prev, tienPhong: parseInt(e.target.value) || 0 }))}
                      required
                      className="h-12 shadow-sm rounded-xl border-gray-200"
                    />
                  </div>
                  
                  <div className="flex flex-col gap-2">
                    <Label htmlFor="soDuDauKy" className="text-sm font-semibold text-[#243B5A]">Nợ cũ / Số dư đầu kỳ (VNĐ)</Label>
                    <Input
                      id="soDuDauKy"
                      type="number"
                      min="0"
                      value={formData.soDuDauKy}
                      onChange={(e) => setFormData(prev => ({ ...prev, soDuDauKy: parseInt(e.target.value) || 0 }))}
                      className="h-12 shadow-sm rounded-xl border-gray-200"
                    />
                  </div>

                  <div className="flex flex-col gap-2">
                    <Label htmlFor="daThanhToan" className="text-sm font-semibold text-[#243B5A]">Đã thanh toán (VNĐ)</Label>
                    <Input
                      id="daThanhToan"
                      type="number"
                      min="0"
                      value={formData.daThanhToan}
                      onChange={(e) => setFormData(prev => ({ ...prev, daThanhToan: parseInt(e.target.value) || 0 }))}
                      required
                      className="h-12 shadow-sm rounded-xl border-gray-200"
                    />
                  </div>
                </div>
              </TabsContent>

              <TabsContent value="dien-nuoc" className="space-y-4 mt-6">
                <div className="flex items-center justify-between">
                  <h3 className="text-base font-semibold">⚡💧 Chỉ số điện & nước</h3>
                  {readingSource && (
                    <div className="text-xs text-[#243B5A] bg-[#4FA7A0]/10 px-2 py-1 rounded">
                      {readingSource.isFirstInvoice 
                        ? "📋 Từ hợp đồng"
                        : `📄 Từ hóa đơn ${readingSource.lastInvoiceMonth}`
                      }
                    </div>
                  )}
                </div>
                
                <div className="flex items-center space-x-2 mb-4 bg-yellow-50 p-3 rounded-lg border border-yellow-200">
                  <input
                    type="checkbox"
                    id="resetCongTo"
                    checked={formData.resetCongTo}
                    onChange={(e) => setFormData(prev => ({ ...prev, resetCongTo: e.target.checked }))}
                    className="h-4 w-4 rounded border-gray-300 text-[#4FA7A0] focus:ring-[#4FA7A0] cursor-pointer"
                  />
                  <Label htmlFor="resetCongTo" className="text-sm font-medium cursor-pointer text-yellow-800">
                    Reset công tơ (Công tơ quay lại từ 0. Vui lòng nhập số điện/nước sử dụng thực tế)
                  </Label>
                </div>

                <div className="overflow-x-auto">
                  <table className="w-full border-collapse border border-gray-200 rounded-lg">
                    <thead>
                      <tr className="bg-gray-50">
                        <th className="border border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Loại</th>
                        <th className="border border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Chỉ số ban đầu</th>
                        <th className="border border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Chỉ số cuối kỳ</th>
                        <th className="border border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Số sử dụng</th>
                        <th className="border border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Đơn giá</th>
                        <th className="border border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Thành tiền</th>
                      </tr>
                    </thead>
                    <tbody>
                      {/* Điện */}
                      <tr>
                        <td className="border border-gray-200 px-4 py-3">
                          <div className="flex items-center gap-2">
                            <Zap className="h-4 w-4 text-yellow-500" />
                            <span className="font-medium">Điện</span>
                          </div>
                        </td>
                        <td className="border border-gray-200 px-4 py-3">
                          <Input
                            type="number"
                            min="0"
                            value={formData.chiSoDienBanDau}
                            onChange={(e) => {
                              const val = e.target.value === '' ? 0 : parseInt(e.target.value) || 0;
                              const value = Math.max(0, val);
                              setFormData(prev => ({
                                ...prev,
                                chiSoDienBanDau: value
                              }));
                            }}
                            className="h-8 w-20 text-center"
                            placeholder="0"
                          />
                          <span className="text-xs text-gray-500 ml-1">kWh</span>
                        </td>
                        <td className="border border-gray-200 px-4 py-3">
                          <Input
                            type="number"
                            min="0"
                            value={formData.chiSoDienCuoiKy}
                            onChange={(e) => {
                              const val = e.target.value === '' ? 0 : parseInt(e.target.value) || 0;
                              const value = Math.max(0, val);
                              setFormData(prev => ({ ...prev, chiSoDienCuoiKy: value }));
                            }}
                            className="h-8 w-20 text-center"
                            placeholder="0"
                          />
                          <span className="text-xs text-gray-500 ml-1">kWh</span>
                          {formData.chiSoDienCuoiKy < formData.chiSoDienBanDau && (
                            <div className="text-xs text-red-500 mt-1">⚠️ Phải ≥ chỉ số đầu</div>
                          )}
                        </td>
                        <td className="border border-gray-200 px-4 py-3">
                          <div className="flex items-center gap-1">
                            {formData.resetCongTo ? (
                              <Input 
                                type="number" 
                                min="0" 
                                value={formData.soKwhThucTe} 
                                onChange={(e) => setFormData(prev => ({ ...prev, soKwhThucTe: Math.max(0, parseInt(e.target.value) || 0) }))} 
                                className="h-8 w-20 text-center bg-yellow-50 font-medium" 
                              />
                            ) : (
                              <span className={`font-medium ${
                                formData.soDien < 0 ? 'text-red-600' : 
                                formData.soDien === 0 ? 'text-gray-500' : 
                                'text-[#243B5A]'
                              }`}>
                                {formData.soDien}
                              </span>
                            )}
                            <span className="text-xs text-gray-500">kWh</span>
                            {!formData.resetCongTo && formData.soDien < 0 && (
                              <span className="text-xs text-red-500 ml-1">⚠️</span>
                            )}
                          </div>
                        </td>
                        <td className="border border-gray-200 px-4 py-3">
                          <div className="flex items-center gap-1">
                            <span className="font-medium">
                              {hopDongList.find(hd => hd._id === formData.hopDong)?.giaDien || 0}
                            </span>
                            <span className="text-xs text-gray-500">VNĐ/kWh</span>
                          </div>
                        </td>
                        <td className="border border-gray-200 px-4 py-3">
                          <div className="flex items-center gap-1">
                            <span className="font-medium text-green-600">{formData.tienDien.toLocaleString('vi-VN')}</span>
                            <span className="text-xs text-gray-500">VNĐ</span>
                          </div>
                        </td>
                      </tr>
                      
                      {/* Nước */}
                      <tr>
                        <td className="border border-gray-200 px-4 py-3">
                          <div className="flex items-center gap-2">
                            <Droplets className="h-4 w-4 text-[#4FA7A0]" />
                            <span className="font-medium">Nước</span>
                          </div>
                        </td>
                        <td className="border border-gray-200 px-4 py-3">
                          <Input
                            type="number"
                            min="0"
                            value={formData.chiSoNuocBanDau}
                            onChange={(e) => {
                              const val = e.target.value === '' ? 0 : parseInt(e.target.value) || 0;
                              const value = Math.max(0, val);
                              setFormData(prev => ({
                                ...prev,
                                chiSoNuocBanDau: value
                              }));
                            }}
                            className="h-8 w-20 text-center"
                            placeholder="0"
                          />
                          <span className="text-xs text-gray-500 ml-1">m³</span>
                        </td>
                        <td className="border border-gray-200 px-4 py-3">
                          <Input
                            type="number"
                            min="0"
                            value={formData.chiSoNuocCuoiKy}
                            onChange={(e) => {
                              const val = e.target.value === '' ? 0 : parseInt(e.target.value) || 0;
                              const value = Math.max(0, val);
                              setFormData(prev => ({ ...prev, chiSoNuocCuoiKy: value }));
                            }}
                            className="h-8 w-20 text-center"
                            placeholder="0"
                          />
                          <span className="text-xs text-gray-500 ml-1">m³</span>
                          {formData.chiSoNuocCuoiKy < formData.chiSoNuocBanDau && (
                            <div className="text-xs text-red-500 mt-1">⚠️ Phải ≥ chỉ số đầu</div>
                          )}
                        </td>
                        <td className="border border-gray-200 px-4 py-3">
                          <div className="flex items-center gap-1">
                            {formData.resetCongTo ? (
                              <Input 
                                type="number" 
                                min="0" 
                                value={formData.soKhoiNuocThucTe} 
                                onChange={(e) => setFormData(prev => ({ ...prev, soKhoiNuocThucTe: Math.max(0, parseInt(e.target.value) || 0) }))} 
                                className="h-8 w-20 text-center bg-yellow-50 font-medium" 
                              />
                            ) : (
                              <span className={`font-medium ${
                                formData.soNuoc < 0 ? 'text-red-600' : 
                                formData.soNuoc === 0 ? 'text-gray-500' : 
                                'text-[#243B5A]'
                              }`}>
                                {formData.soNuoc}
                              </span>
                            )}
                            <span className="text-xs text-gray-500">m³</span>
                            {!formData.resetCongTo && formData.soNuoc < 0 && (
                              <span className="text-xs text-red-500 ml-1">⚠️</span>
                            )}
                          </div>
                        </td>
                        <td className="border border-gray-200 px-4 py-3">
                          <div className="flex items-center gap-1">
                            <span className="font-medium">
                              {hopDongList.find(hd => hd._id === formData.hopDong)?.giaNuoc || 0}
                            </span>
                            <span className="text-xs text-gray-500">VNĐ/m³</span>
                          </div>
                        </td>
                        <td className="border border-gray-200 px-4 py-3">
                          <div className="flex items-center gap-1">
                            <span className="font-medium text-green-600">{formData.tienNuoc.toLocaleString('vi-VN')}</span>
                            <span className="text-xs text-gray-500">VNĐ</span>
                          </div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                
                {/* Tổng kết điện nước */}
                <div className="grid grid-cols-2 gap-4 p-4 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-lg border">
                  <div className="text-center">
                    <div className="text-sm text-gray-600 mb-1">Tổng tiền điện</div>
                    <div className="text-lg font-bold text-yellow-600">{formData.tienDien.toLocaleString('vi-VN')} VNĐ</div>
                  </div>
                  <div className="text-center">
                    <div className="text-sm text-gray-600 mb-1">Tổng tiền nước</div>
                    <div className="text-lg font-bold text-[#243B5A]">{formData.tienNuoc.toLocaleString('vi-VN')} VNĐ</div>
                  </div>
                </div>
              </TabsContent>

              <TabsContent value="dich-vu" className="space-y-4 mt-6">
                <div className="flex items-center justify-between">
                  <h3 className="text-base font-semibold text-[#243B5A]">🔧 Phí dịch vụ cố định & phát sinh</h3>
                  <span className="text-xs bg-slate-100 text-slate-700 px-2.5 py-1 rounded-full font-medium">
                    {formData.phiDichVu.length} dịch vụ
                  </span>
                </div>
                
                {formData.phiDichVu.length > 0 ? (
                  <div className="space-y-2">
                    {formData.phiDichVu.map((phi, index) => (
                      <div key={index} className="flex items-center justify-between p-3 bg-[#F8F3EC]/50 rounded-xl border border-[#E8DED2]">
                        <div>
                          <p className="text-sm font-semibold text-[#243B5A]">{phi.ten}</p>
                          {phi.donVi && <p className="text-xs text-gray-500">Đơn vị: {phi.donVi}</p>}
                        </div>
                        <div className="flex items-center gap-3">
                          <span className="text-sm font-bold text-[#4FA7A0]">{phi.gia.toLocaleString('vi-VN')} VNĐ</span>
                          <Button
                            type="button"
                            variant="ghost"
                            size="sm"
                            onClick={() => removePhiDichVu(index)}
                            className="h-8 w-8 p-0 text-red-500 hover:text-red-700 hover:bg-red-50 rounded-lg"
                            title="Xóa dịch vụ này"
                          >
                            ✕
                          </Button>
                        </div>
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-6 border border-dashed rounded-xl text-gray-500 text-sm">
                    Chưa có phí dịch vụ nào cho kỳ này.
                  </div>
                )}
                
                <div className="space-y-2 bg-slate-50 p-4 rounded-xl border border-slate-200">
                  <Label className="text-sm font-semibold text-[#243B5A]">Thêm phí dịch vụ phát sinh</Label>
                  <div className="flex flex-col sm:flex-row gap-2">
                    <Input
                      placeholder="Tên dịch vụ (Vệ sinh, rác, wifi...)"
                      value={newPhiDichVu.ten}
                      onChange={(e) => setNewPhiDichVu(prev => ({ ...prev, ten: e.target.value }))}
                      className="flex-1 h-10 bg-white"
                    />
                    <Input
                      placeholder="Đơn giá (VNĐ)"
                      type="number"
                      min="0"
                      value={newPhiDichVu.gia || ''}
                      onChange={(e) => setNewPhiDichVu(prev => ({ ...prev, gia: parseInt(e.target.value) || 0 }))}
                      className="w-full sm:w-36 h-10 bg-white"
                    />
                    <Button 
                      type="button" 
                      onClick={addPhiDichVu}
                      disabled={!newPhiDichVu.ten || newPhiDichVu.gia <= 0}
                      className="h-10 px-4 text-sm bg-[#4FA7A0] hover:bg-[#3D8580]"
                    >
                      + Thêm
                    </Button>
                  </div>
                </div>
              </TabsContent>

              <TabsContent value="phuong-tien" className="space-y-4 mt-6">
                <div className="flex items-center justify-between">
                  <h3 className="text-base font-semibold text-[#243B5A]">🛵 Phương tiện & Phí gửi xe phòng</h3>
                  <span className="text-xs bg-teal-50 text-[#4FA7A0] px-2.5 py-1 rounded-full font-bold">
                    Tổng phí xe: {formData.tongTienXe.toLocaleString('vi-VN')} VNĐ
                  </span>
                </div>

                {formData.phuongTienList && formData.phuongTienList.length > 0 ? (
                  <div className="overflow-x-auto">
                    <table className="w-full border-collapse border border-gray-200 rounded-xl overflow-hidden">
                      <thead className="bg-gray-50 text-[#243B5A] text-xs uppercase tracking-wider">
                        <tr>
                          <th className="border border-gray-200 px-4 py-3 text-left">Loại xe</th>
                          <th className="border border-gray-200 px-4 py-3 text-left">Biển số</th>
                          <th className="border border-gray-200 px-4 py-3 text-center">Thời gian tính phí</th>
                          <th className="border border-gray-200 px-4 py-3 text-right">Đơn giá / Thành tiền</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-gray-100 text-sm">
                        {formData.phuongTienList.map((pt, idx) => (
                          <tr key={idx} className="hover:bg-slate-50">
                            <td className="border border-gray-200 px-4 py-3 font-semibold text-gray-900">
                              {pt.loaiXe || 'Xe máy'}
                            </td>
                            <td className="border border-gray-200 px-4 py-3 font-mono text-[#243B5A]">
                              {pt.bienSo || '—'}
                            </td>
                            <td className="border border-gray-200 px-4 py-3 text-center text-xs text-gray-600">
                              {pt.activeDays ? `${pt.activeDays}/${pt.totalDays || 30} ngày` : 'Nguyên tháng'}
                            </td>
                            <td className="border border-gray-200 px-4 py-3 text-right font-bold text-[#4FA7A0]">
                              {pt.thanhTien.toLocaleString('vi-VN')} VNĐ
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                ) : (
                  <div className="bg-slate-50 border border-dashed rounded-xl p-8 text-center text-gray-500">
                    <Car className="h-10 w-10 mx-auto text-gray-400 mb-2" />
                    <p className="font-medium">Phòng này chưa có phương tiện nào đăng ký gửi xe trong kỳ.</p>
                    <p className="text-xs text-gray-400 mt-1">Phí gửi xe = 0 VNĐ</p>
                  </div>
                )}

                <div className="bg-blue-50 text-blue-800 border border-blue-200 rounded-xl p-3.5 text-xs flex items-start gap-2">
                  <Info className="h-4 w-4 shrink-0 text-blue-600 mt-0.5" />
                  <p>
                    Phí gửi xe được hệ thống tự động tính toán dựa trên danh sách phương tiện đang gán với phòng và biểu phí cấu hình cho từng loại xe trong kỳ.
                  </p>
                </div>
              </TabsContent>

              <TabsContent value="tong-ket" className="space-y-5 mt-6">
                <div className="flex items-center justify-between">
                  <h3 className="text-base font-bold text-[#243B5A]">💰 Bảng kê chi tiết các nguồn tiền thu</h3>
                  <span className="text-xs text-gray-500">Kỳ T.{formData.thang}/{formData.nam}</span>
                </div>

                {/* Breakdown Card */}
                <div className="border border-[#E8DED2] bg-[#FFFDF8] rounded-2xl p-5 shadow-sm space-y-3">
                  <div className="flex items-center justify-between py-2 border-b border-gray-100">
                    <div className="flex items-center gap-2">
                      <FileText className="h-4 w-4 text-[#243B5A]" />
                      <span className="text-sm font-medium text-gray-800">Tiền thuê phòng</span>
                    </div>
                    <span className="text-sm font-bold text-gray-900">{formData.tienPhong.toLocaleString('vi-VN')} VNĐ</span>
                  </div>

                  <div className="flex items-center justify-between py-2 border-b border-gray-100">
                    <div className="flex items-center gap-2">
                      <Zap className="h-4 w-4 text-yellow-500" />
                      <span className="text-sm font-medium text-gray-800">
                        Tiền điện ({formData.soDien} kWh x {formData.giaDien.toLocaleString('vi-VN')}đ)
                      </span>
                    </div>
                    <span className="text-sm font-bold text-gray-900">{formData.tienDien.toLocaleString('vi-VN')} VNĐ</span>
                  </div>

                  <div className="flex items-center justify-between py-2 border-b border-gray-100">
                    <div className="flex items-center gap-2">
                      <Droplets className="h-4 w-4 text-[#4FA7A0]" />
                      <span className="text-sm font-medium text-gray-800">
                        Tiền nước ({formData.soNuoc} m³ x {formData.giaNuoc.toLocaleString('vi-VN')}đ)
                      </span>
                    </div>
                    <span className="text-sm font-bold text-gray-900">{formData.tienNuoc.toLocaleString('vi-VN')} VNĐ</span>
                  </div>

                  {formData.phiDichVu.length > 0 && (
                    <div className="flex items-center justify-between py-2 border-b border-gray-100">
                      <div className="flex items-center gap-2">
                        <Wrench className="h-4 w-4 text-blue-500" />
                        <span className="text-sm font-medium text-gray-800">
                          Phí dịch vụ ({formData.phiDichVu.length} khoản)
                        </span>
                      </div>
                      <span className="text-sm font-bold text-gray-900">
                        {formData.phiDichVu.reduce((s, p) => s + p.gia * (p.soLuong || 1), 0).toLocaleString('vi-VN')} VNĐ
                      </span>
                    </div>
                  )}

                  {formData.tongTienXe > 0 && (
                    <div className="flex items-center justify-between py-2 border-b border-gray-100">
                      <div className="flex items-center gap-2">
                        <Car className="h-4 w-4 text-purple-500" />
                        <span className="text-sm font-medium text-gray-800">
                          Phí gửi xe ({formData.phuongTienList.length} xe)
                        </span>
                      </div>
                      <span className="text-sm font-bold text-gray-900">{formData.tongTienXe.toLocaleString('vi-VN')} VNĐ</span>
                    </div>
                  )}

                  {formData.soDuDauKy > 0 && (
                    <div className="flex items-center justify-between py-2 border-b border-gray-100">
                      <div className="flex items-center gap-2">
                        <Clock className="h-4 w-4 text-amber-600" />
                        <span className="text-sm font-medium text-amber-700">Dư nợ kỳ trước chuyển sang</span>
                      </div>
                      <span className="text-sm font-bold text-amber-700">{formData.soDuDauKy.toLocaleString('vi-VN')} VNĐ</span>
                    </div>
                  )}

                  <div className="flex items-center justify-between pt-3 text-base">
                    <span className="font-extrabold text-[#243B5A]">Tổng cộng hóa đơn kỳ này</span>
                    <span className="text-xl font-extrabold text-[#4FA7A0]">{formData.tongTien.toLocaleString('vi-VN')} VNĐ</span>
                  </div>
                </div>

                <div className="grid grid-cols-3 gap-3 p-4 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl border">
                  <div className="text-center">
                    <div className="text-xs text-gray-600 mb-1">Tổng tiền</div>
                    <div className="text-base sm:text-lg font-bold text-gray-900">{formData.tongTien.toLocaleString('vi-VN')} VNĐ</div>
                  </div>
                  <div className="text-center">
                    <div className="text-xs text-gray-600 mb-1">Đã thanh toán</div>
                    <div className="text-base sm:text-lg font-bold text-green-600">{formData.daThanhToan.toLocaleString('vi-VN')} VNĐ</div>
                  </div>
                  <div className="text-center">
                    <div className="text-xs text-gray-600 mb-1">Còn lại</div>
                    <div className={`text-base sm:text-lg font-bold ${formData.conLai > 0 ? 'text-red-600' : 'text-green-600'}`}>
                      {formData.conLai.toLocaleString('vi-VN')} VNĐ
                    </div>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                  <div className="flex flex-col gap-2">
                    <Label htmlFor="trangThai" className="text-sm font-semibold text-[#243B5A]">Trạng thái</Label>
                    <Select value={formData.trangThai} onValueChange={(value) => setFormData(prev => ({ ...prev, trangThai: value as 'nhap' | 'chuaThanhToan' }))}>
                      <SelectTrigger className="h-12 shadow-sm rounded-xl border-gray-200">
                        <SelectValue placeholder="Chọn trạng thái" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="chuaThanhToan">Chưa thanh toán</SelectItem>
                        <SelectItem value="nhap">Nháp</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>

                  <div className="flex flex-col gap-2">
                    <Label htmlFor="ghiChu" className="text-sm font-semibold text-[#243B5A]">Ghi chú</Label>
                    <Input
                      id="ghiChu"
                      value={formData.ghiChu}
                      onChange={(e) => setFormData(prev => ({ ...prev, ghiChu: e.target.value }))}
                      placeholder="Ghi chú về hóa đơn..."
                      className="h-12 shadow-sm rounded-xl border-gray-200"
                    />
                  </div>
                </div>

                {/* Action Buttons */}
                <div className="flex flex-col sm:flex-row justify-end gap-2 md:gap-3 pt-4 border-t">
                  <Button 
                    type="button" 
                    variant="outline"
                    size="sm"
                    onClick={() => router.push('/dashboard/hoa-don')}
                    disabled={submitting}
                    className="w-full sm:w-auto sm:min-w-[80px]"
                  >
                    Hủy
                  </Button>
                  <Button 
                    type="submit"
                    size="sm"
                    disabled={submitting}
                    className="w-full sm:w-auto sm:min-w-[120px]"
                  >
                    <Save className="h-4 w-4 mr-2" />
                    {submitting ? 'Đang tạo...' : 'Tạo hóa đơn'}
                  </Button>
                </div>
              </TabsContent>
            </Tabs>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
