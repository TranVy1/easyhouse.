'use client';

import { useState, useEffect, useCallback } from 'react';
import { useRouter, useParams } from 'next/navigation';
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
  Loader2,
  FileText,
  Zap,
  Droplets,
  Wrench,
  Calculator,
  Settings,
  Printer,
  Share2,
  Phone,
  CheckCircle2,
  Trash2,
  Send,
  FileDown
} from 'lucide-react';
import * as XLSX from 'xlsx';
import { KhachThue, Phong, HoaDon, HopDong } from '@/types';
import { toast } from 'sonner';
import { ConfirmActionDialog } from '@/components/ui/confirm-action-dialog';

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

export default function ChinhSuaHoaDonPage() {
  const router = useRouter();
  const params = useParams();
  const hoaDonId = params.id as string;
  const { data: session } = useSession();
  const accessToken = session?.accessToken;

  const [hoaDon, setHoaDon] = useState<HoaDon | null>(null);
  const [hopDongList, setHopDongList] = useState<HopDong[]>([]);
  const [phongList, setPhongList] = useState<Phong[]>([]);
  const [khachThueList, setKhachThueList] = useState<KhachThue[]>([]);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [isConfirmOpen, setIsConfirmOpen] = useState(false);
  const [isDeleting, setIsDeleting] = useState(false);
  const [issuing, setIssuing] = useState(false);
  const [timeline, setTimeline] = useState<Array<{ id?: string; hanhDong: string; nguoiThucHien?: string; thoiDiem?: string }>>([]);

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
    tienNuoc: 0,
    soNuoc: 0,
    chiSoNuocBanDau: 0,
    chiSoNuocCuoiKy: 0,
    phiDichVu: [] as Array<{ ten: string, gia: number }>,
    tongTien: 0,
    daThanhToan: 0,
    conLai: 0,
    soDuCo: 0,
    trangThai: 'chuaThanhToan' as 'chuaThanhToan' | 'daThanhToanMotPhan' | 'daThanhToan' | 'quaHan' | 'PAID' | 'OVERPAID',
    hanThanhToan: '',
    ghiChu: '',
    resetCongTo: false,
    soKwhThucTe: 0,
    soKhoiNuocThucTe: 0,
  });

  const [newPhiDichVu, setNewPhiDichVu] = useState({ ten: '', gia: 0 });

  const fetchData = useCallback(async () => {
    try {
      // Fetch hóa đơn chi tiết theo ID
      const hoaDonResponse = await fetch(`/api/hoa-don/${hoaDonId}`, {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      if (hoaDonResponse.ok) {
        const hoaDonData = await hoaDonResponse.json();
        const hoaDonItem = hoaDonData.data;
        if (hoaDonItem) {
          setHoaDon(hoaDonItem);
          console.log('Hoa don loaded for editing:', hoaDonItem);

          // Set form data
          console.log('Setting form data with electricity readings:', {
            chiSoDienBanDau: hoaDonItem.chiSoDienBanDau,
            chiSoDienCuoiKy: hoaDonItem.chiSoDienCuoiKy,
            chiSoNuocBanDau: hoaDonItem.chiSoNuocBanDau,
            chiSoNuocCuoiKy: hoaDonItem.chiSoNuocCuoiKy
          });

          setFormData({
            maHoaDon: hoaDonItem.maHoaDon || '',
            hopDong: typeof hoaDonItem.hopDong === 'object' ? (hoaDonItem.hopDong as { _id: string })?._id || '' : hoaDonItem.hopDong || '',
            phong: typeof hoaDonItem.phong === 'object' ? (hoaDonItem.phong as { _id: string })?._id || '' : hoaDonItem.phong || '',
            khachThue: typeof hoaDonItem.khachThue === 'object' ? (hoaDonItem.khachThue as { _id: string })?._id || '' : hoaDonItem.khachThue || '',
            thang: hoaDonItem.thang || new Date().getMonth() + 1,
            nam: hoaDonItem.nam || new Date().getFullYear(),
            tienPhong: hoaDonItem.tienPhong || 0,
            tienDien: hoaDonItem.tienDien || 0,
            soDien: hoaDonItem.soDien || 0,
            chiSoDienBanDau: hoaDonItem.chiSoDienBanDau ?? 0,
            chiSoDienCuoiKy: hoaDonItem.chiSoDienCuoiKy ?? 0,
            tienNuoc: hoaDonItem.tienNuoc || 0,
            soNuoc: hoaDonItem.soNuoc || 0,
            chiSoNuocBanDau: hoaDonItem.chiSoNuocBanDau ?? 0,
            chiSoNuocCuoiKy: hoaDonItem.chiSoNuocCuoiKy ?? 0,
            phiDichVu: hoaDonItem.phiDichVu || [],
            tongTien: hoaDonItem.tongTien || 0,
            daThanhToan: hoaDonItem.daThanhToan || 0,
            conLai: Math.max(0, hoaDonItem.conLai || 0),
            soDuCo: Math.max(0, hoaDonItem.soDuCo || 0),
            trangThai: hoaDonItem.trangThai || 'chuaThanhToan',
            hanThanhToan: hoaDonItem.hanThanhToan ?
              (typeof hoaDonItem.hanThanhToan === 'string' ? (hoaDonItem.hanThanhToan as string).split('T')[0] :
                new Date(hoaDonItem.hanThanhToan as Date).toISOString().split('T')[0]) : '',
            ghiChu: hoaDonItem.ghiChu || '',
            resetCongTo: false,
            soKwhThucTe: 0,
            soKhoiNuocThucTe: 0,
          });
        } else {
          toast.error('Không tìm thấy hóa đơn');
          router.push('/dashboard/hoa-don');
          return;
        }
      } else {
        toast.error('Lỗi khi tải thông tin hóa đơn');
        router.push('/dashboard/hoa-don');
        return;
      }

      const timelineResponse = await fetch(`/api/hoa-don/${hoaDonId}/timeline`, {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      if (timelineResponse.ok) {
        const timelineData = await timelineResponse.json();
        setTimeline(timelineData.data || []);
      }

      // Fetch form data (hop dong, phong, khach thue)
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
      console.error('Error fetching data:', error);
      toast.error('Có lỗi xảy ra khi tải dữ liệu');
    } finally {
      setLoading(false);
    }
  }, [accessToken, hoaDonId, router]);

  useEffect(() => {
    if (hoaDonId && accessToken) {
      fetchData();
    }
  }, [accessToken, hoaDonId, fetchData]);

  const calculateTotal = useCallback(() => {
    const totalPhiDichVu = formData.phiDichVu.reduce((sum: number, phi) => sum + phi.gia, 0);

    // Tính tiền điện nước từ chỉ số
    const soDien = formData.resetCongTo ? formData.soKwhThucTe : (formData.chiSoDienCuoiKy - formData.chiSoDienBanDau);
    const soNuoc = formData.resetCongTo ? formData.soKhoiNuocThucTe : (formData.chiSoNuocCuoiKy - formData.chiSoNuocBanDau);

    // Lấy giá điện nước từ hợp đồng
    const selectedHopDong = hopDongList.find(hd => hd._id === formData.hopDong);
    const giaDien = selectedHopDong?.giaDien || 0;
    const giaNuoc = selectedHopDong?.giaNuoc || 0;

    const tienDienTinh = soDien * giaDien;
    const tienNuocTinh = soNuoc * giaNuoc;

    const total = formData.tienPhong + tienDienTinh + tienNuocTinh + totalPhiDichVu;
    const soDu = total - formData.daThanhToan;

    setFormData(prev => ({
      ...prev,
      soDien: Math.max(0, soDien),
      soNuoc: Math.max(0, soNuoc),
      tienDien: tienDienTinh,
      tienNuoc: tienNuocTinh,
      tongTien: total,
      conLai: Math.max(0, soDu),
      soDuCo: Math.max(0, -soDu)
    }));
  }, [
    formData.tienPhong,
    formData.chiSoDienBanDau,
    formData.chiSoDienCuoiKy,
    formData.chiSoNuocBanDau,
    formData.chiSoNuocCuoiKy,
    formData.phiDichVu,
    formData.daThanhToan,
    formData.hopDong,
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
      const requestData = {
        ...formData,
        kyThang: formData.thang,
        kyNam: formData.nam,
        hanTra: formData.hanThanhToan,
        tuNgay: formData.thang && formData.nam ? `${formData.nam}-${String(formData.thang).padStart(2, '0')}-01` : undefined,
        denNgay: formData.thang && formData.nam ? new Date(formData.nam, formData.thang, 0).toISOString().split('T')[0] : undefined,
        resetCongTo: formData.resetCongTo,
        soKwhThucTe: formData.soKwhThucTe,
        soKhoiNuocThucTe: formData.soKhoiNuocThucTe,
      };

      console.log('Submitting form data for update:', requestData);

      const response = await fetch(`/api/hoa-don/${hoaDonId}`, {
        method: 'PUT',
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
        toast.success(result.message || 'Hóa đơn đã được cập nhật thành công');
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

  const confirmDelete = async () => {
    setIsDeleting(true);
    try {
      const res = await fetch(`/api/hoa-don/${hoaDonId}`, { method: 'DELETE' });
      if (res.ok) {
        toast.success('Xóa hóa đơn thành công');
        router.push('/dashboard/hoa-don');
      } else {
        toast.error('Có lỗi khi xóa hóa đơn');
      }
    } catch (e) {
      toast.error('Lỗi kết nối');
    } finally {
      setIsDeleting(false);
      setIsConfirmOpen(false);
    }
  };

  const phatHanhHoaDon = async () => {
    setIssuing(true);
    try {
      const res = await fetch(`/api/hoa-don/${hoaDonId}/phat-hanh`, {
        method: 'POST', headers: { Authorization: `Bearer ${accessToken}` },
      });
      const result = await res.json();
      if (!res.ok) throw new Error(result.message || 'Không thể phát hành hóa đơn');
      setHoaDon(result.data);
      toast.success('Đã phát hành hóa đơn. Nội dung và tổng tiền đã được khóa.');
      await fetchData();
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Không thể phát hành hóa đơn');
    } finally {
      setIssuing(false);
    }
  };

  const xuatExcel = async () => {
    if (!hoaDon) return;
    let payments: any[] = [];
    try {
      const paymentResponse = await fetch(`/api/thanh-toan/hoa-don/${hoaDonId}`, {
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      });
      const paymentResult = await paymentResponse.json();
      if (paymentResponse.ok && paymentResult.success) payments = paymentResult.data || [];
    } catch {
      // The invoice itself remains exportable when payment history is unavailable.
    }
    const rows = (hoaDon.chiTietHoaDon || hoaDon.chiTiet || []).map((item: any) => ({
      'Loại': item.loai,
      'Diễn giải': item.moTa,
      'Số lượng': item.soLuong,
      'Đơn giá': item.donGia,
      'Thành tiền': item.thanhTien,
      'Nguồn': item.sourceType || 'DỮ LIỆU CŨ',
      'Kỳ tính từ': item.periodStart || '',
      'Kỳ tính đến': item.periodEnd || '',
      'Mã kiểm chứng': item.calculationHash || '',
    }));
    rows.push({
      'Loại': 'TỔNG', 'Diễn giải': hoaDon.maHoaDon, 'Số lượng': 0, 'Đơn giá': 0,
      'Thành tiền': hoaDon.tongTien, 'Nguồn': '', 'Kỳ tính từ': '', 'Kỳ tính đến': '', 'Mã kiểm chứng': '',
    });
    const workbook = XLSX.utils.book_new();
    const summary = XLSX.utils.json_to_sheet([{
      "Invoice code": hoaDon.maHoaDon, "Document type": hoaDon.loaiHoaDon || "REGULAR",
      "Period from": hoaDon.tuNgay || "", "Period to": hoaDon.denNgay || "", "Due date": hoaDon.hanTra || hoaDon.hanThanhToan || "",
      "Room rent": hoaDon.tienPhong || 0, "Electricity": hoaDon.tienDien || 0, "Water": hoaDon.tienNuoc || 0,
      "Total": hoaDon.tongTien || 0, "Paid": hoaDon.daTra ?? hoaDon.daThanhToan ?? 0,
      "Balance": hoaDon.conLai || 0, "Status": hoaDon.trangThai,
    }]);
    const sheet = XLSX.utils.json_to_sheet(rows);
    const paymentSheet = XLSX.utils.json_to_sheet(payments.map((payment: any) => ({
      "Invoice code": hoaDon.maHoaDon, "Transaction": payment.maGiaoDich || payment._id || payment.id || "",
      "Method": payment.phuongThuc || payment.phuongThucThanhToan || "", "Reference": payment.maThamChieu || payment.externalTransactionId || "",
      "Amount": payment.soTien || 0, "Status": payment.trangThai || "", "Paid at": payment.ngayThanhToan || "",
    })));
    summary['!cols'] = [{ wch: 18 }, { wch: 18 }, { wch: 14 }, { wch: 14 }, { wch: 14 }, { wch: 16 }, { wch: 16 }, { wch: 16 }, { wch: 16 }, { wch: 16 }, { wch: 16 }, { wch: 14 }];
    sheet['!cols'] = [{ wch: 18 }, { wch: 42 }, { wch: 12 }, { wch: 16 }, { wch: 16 }, { wch: 24 }, { wch: 14 }, { wch: 14 }, { wch: 66 }];
    paymentSheet['!cols'] = [{ wch: 18 }, { wch: 38 }, { wch: 18 }, { wch: 28 }, { wch: 16 }, { wch: 16 }, { wch: 18 }];
    [summary, sheet, paymentSheet].forEach((worksheet) => {
      worksheet['!autofilter'] = { ref: worksheet['!ref'] || 'A1' };
      Object.values(worksheet).forEach((cell: any) => { if (cell?.t === 'n') cell.z = '#,##0 [$₫-vi-VN]'; });
    });
    XLSX.utils.book_append_sheet(workbook, summary, 'Invoice Summary');
    XLSX.utils.book_append_sheet(workbook, sheet, 'Invoice Items');
    if (payments.length > 0) XLSX.utils.book_append_sheet(workbook, paymentSheet, 'Payments');
    XLSX.writeFile(workbook, `hoa-don-${hoaDon.maHoaDon}.xlsx`);
  };

  const huyHoaDon = async () => {
    const lyDo = window.prompt('Nhập lý do hủy hóa đơn (bắt buộc):');
    if (!lyDo?.trim()) return;
    try {
      const res = await fetch(`/api/hoa-don/${hoaDonId}/huy`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${accessToken}` },
        body: JSON.stringify({ lyDo: lyDo.trim() }),
      });
      const result = await res.json();
      if (!res.ok) throw new Error(result.message || 'Không thể hủy hóa đơn');
      setHoaDon(result.data);
      toast.success('Đã hủy hóa đơn và lưu lại lý do.');
      await fetchData();
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Không thể hủy hóa đơn');
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

  if (!hoaDon) {
    return (
      <div className="space-y-6">
        <div className="flex items-center gap-4">
          <Button
            variant="outline"
            size="icon"
            onClick={() => router.push('/dashboard/hoa-don')}
          >
            <ArrowLeft className="h-4 w-4" />
          </Button>
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Không tìm thấy hóa đơn</h1>
          </div>
        </div>
      </div>
    );
  }

  const isDraft = hoaDon.trangThai === 'DRAFT' || hoaDon.trangThai === 'nhap';

  // Helpers for display
  const fmt = (n: number) => n.toLocaleString('vi-VN') + ' đ';
  const tenPhong = typeof hoaDon.phong === 'object' && hoaDon.phong !== null
    ? ((hoaDon.phong as any).ten || (hoaDon.phong as any).maPhong || 'N/A')
    : getPhongName(hoaDon.phong as string, phongList);
  const tenNhaTro = typeof hoaDon.phong === 'object' && hoaDon.phong !== null
    ? ((hoaDon.phong as any).nhaTro?.ten || '')
    : '';
  const tenKhach = typeof hoaDon.khachThue === 'object' && hoaDon.khachThue !== null
    ? ((hoaDon.khachThue as any).hoTen || 'N/A')
    : getKhachThueName(hoaDon.khachThue as string, khachThueList);
  const soDienSD = formData.resetCongTo ? formData.soKwhThucTe : Math.max(0, formData.chiSoDienCuoiKy - formData.chiSoDienBanDau);
  const soNuocSD = formData.resetCongTo ? formData.soKhoiNuocThucTe : Math.max(0, formData.chiSoNuocCuoiKy - formData.chiSoNuocBanDau);
  const totalDichVu = formData.phiDichVu.reduce((sum, p) => sum + p.gia, 0);

  const trangThaiConfig: Record<string, { label: string; color: string; bg: string }> = {
    chuaThanhToan: { label: 'Chưa thu', color: '#D97706', bg: '#FEF3C7' },
    daThanhToanMotPhan: { label: 'Thu một phần', color: '#2563EB', bg: '#DBEAFE' },
    daThanhToan: { label: 'Đã thu xong', color: '#16A34A', bg: '#DCFCE7' },
    PAID: { label: 'Đã thu xong', color: '#16A34A', bg: '#DCFCE7' },
    OVERPAID: { label: 'Dư có', color: '#0F766E', bg: '#CCFBF1' },
    quaHan: { label: 'Quá hạn', color: '#DC2626', bg: '#FEE2E2' },
  };
  const tsConf = trangThaiConfig[formData.trangThai] || trangThaiConfig.chuaThanhToan;

  const hanThanhToanDate = formData.hanThanhToan
    ? new Date(formData.hanThanhToan).toLocaleDateString('vi-VN')
    : '—';
  const ngayTao = (hoaDon as any).createdAt || (hoaDon as any).taoLuc || hoaDon.ngayTao
    ? new Date(String((hoaDon as any).createdAt || (hoaDon as any).taoLuc || hoaDon.ngayTao)).toLocaleDateString('vi-VN')
    : '—';
  const hasDien = (formData.tienDien || 0) > 0;
  const hasNuoc = (formData.tienNuoc || 0) > 0;
  const hasOtherDichVu = formData.phiDichVu && formData.phiDichVu.length > 0;
  const hasAnyServiceSection = hasDien || hasNuoc || hasOtherDichVu;
  const overallServiceTotal = (formData.tienDien || 0) + (formData.tienNuoc || 0) + totalDichVu;

  return (
    <div className="bg-[#F6F7F9] min-h-screen pb-24 md:pb-8 font-sans">
      {/* Top bar (Floating Card) */}
      <div className="sticky top-4 z-10 max-w-3xl mx-auto px-4 pt-2">
        <div className="bg-white rounded-[20px] shadow-sm border border-gray-200 flex items-center justify-between p-3 px-4">
          <button
            onClick={() => router.push('/dashboard/hoa-don')}
            className="flex items-center justify-center w-10 h-10 rounded-full bg-gray-50 hover:bg-gray-100 transition-colors"
          >
            <ArrowLeft className="h-5 w-5 text-gray-700" />
          </button>
          <h1 className="text-[17px] font-bold text-gray-800">Chi tiết hóa đơn</h1>
          <div className="flex items-center gap-2">
            <button aria-label="In hóa đơn" onClick={() => window.print()} className="flex items-center justify-center w-10 h-10 rounded-full bg-gray-50 hover:bg-gray-100 transition-colors"><Printer className="h-5 w-5 text-gray-700" /></button>
            <button aria-label="Xuất Excel" onClick={xuatExcel} className="flex items-center justify-center w-10 h-10 rounded-full bg-gray-50 hover:bg-gray-100 transition-colors"><FileDown className="h-5 w-5 text-gray-700" /></button>
          </div>
        </div>
      </div>

      <div className="max-w-3xl mx-auto px-4 py-6 space-y-5">

        {/* Main Receipt Card */}
        <div className="bg-white rounded-[24px] shadow-sm border border-gray-200 overflow-hidden relative">
          {/* Header */}
          <div className="p-6 text-center">
            <h2 className="text-[22px] font-bold text-gray-900">{tenPhong}</h2>
            <p className="text-[15px] font-medium text-gray-600 mt-1">Khách thuê: {tenKhach}</p>
          </div>

          {/* Meta Grid */}
          <div className="grid grid-cols-3 divide-x divide-gray-200 border-t border-b border-gray-200 mx-5 rounded-[14px] overflow-hidden mb-6 border">
            <div className="px-2 py-3.5 text-center bg-gray-50/50">
              <p className="text-[11.5px] text-gray-500 mb-1.5">Hóa đơn tháng</p>
              <p className="text-[13px] font-semibold text-gray-900">T.{formData.thang}, {formData.nam}</p>
            </div>
            <div className="px-2 py-3.5 text-center bg-white">
              <p className="text-[11.5px] text-gray-500 mb-1.5">Ngày lập hóa đơn</p>
              <p className="text-[13px] font-semibold text-gray-900">{ngayTao}</p>
            </div>
            <div className="px-2 py-3.5 text-center bg-gray-50/50">
              <p className="text-[11.5px] text-gray-500 mb-1.5">Hạn nạp tiền</p>
              <p className="text-[13px] font-semibold text-gray-900">{hanThanhToanDate}</p>
            </div>
          </div>

          <div className="px-5 space-y-4">
            {/* Lý do thu */}
            <div className="flex items-start justify-between py-2">
              <div>
                <p className="text-[14px] text-gray-600 mb-1.5">Lý do thu</p>
                <p className="text-[15px] font-bold text-gray-900">Tiền phòng tháng {formData.thang}</p>
              </div>
              <div className="flex flex-col items-end gap-2">
                <span className="px-3 py-1 rounded-full text-[12px] font-semibold flex items-center gap-1.5" style={{ color: tsConf.color, backgroundColor: tsConf.bg }}>
                  <span className="w-1.5 h-1.5 rounded-full" style={{ backgroundColor: tsConf.color }}></span>
                  {tsConf.label}
                </span>

              </div>
            </div>

            <div className="h-[1px] bg-gray-200 w-full" />

            {/* Tiền thuê nhà */}
            {hoaDon?.chiTietHoaDon && hoaDon.chiTietHoaDon.some((c: any) => c.loai === 'TIEN_PHONG') ? (
              hoaDon.chiTietHoaDon.filter((c: any) => c.loai === 'TIEN_PHONG').map((c: any, idx: number) => (
                <div key={idx} className="flex items-start justify-between py-3 border-t border-gray-100">
                  <div>
                    <p className="text-[15px] font-semibold text-gray-800">Tiền thuê nhà</p>
                    <p className="text-[14px] font-bold text-gray-900 mt-1">{c.moTa}</p>
                    {c.soLuong > 1 && (
                      <p className="text-[12px] text-gray-500 mt-1">{c.soLuong} × {fmt(c.donGia)}</p>
                    )}
                  </div>
                  <div className="text-right">
                    <p className="text-[13px] text-gray-500 mb-0.5">Thành tiền</p>
                    <p className="text-[16px] font-bold text-gray-900">{fmt(c.thanhTien)}</p>
                  </div>
                </div>
              ))
            ) : (
              <div className="flex items-start justify-between py-3 border-t border-gray-100">
                <div>
                  <p className="text-[15px] font-semibold text-gray-800">Tiền thuê nhà</p>
                  <p className="text-[14px] text-gray-500 mt-1">1 tháng</p>
                </div>
                <div className="text-right">
                  <p className="text-[13px] text-gray-500 mb-0.5">Thành tiền</p>
                  <p className="text-[16px] font-bold text-gray-900">{fmt(formData.tienPhong || 0)}</p>
                </div>
              </div>
            )}

            {/* Thu tiền cọc */}
            {hoaDon?.chiTietHoaDon && hoaDon.chiTietHoaDon.some((c: any) => c.loai === 'TIEN_COC') && (
              <>
                <div className="h-[1px] bg-gray-100 w-full" />
                {hoaDon.chiTietHoaDon.filter((c: any) => c.loai === 'TIEN_COC').map((c: any, idx: number) => (
                  <div key={idx} className="flex items-start justify-between py-3">
                    <div>
                      <p className="text-[15px] font-semibold text-gray-800">Thu tiền cọc</p>
                      {c.moTa && c.moTa !== 'Thu tiền cọc' && <p className="text-[14px] text-gray-500 mt-1">{c.moTa}</p>}
                    </div>
                    <div className="text-right">
                      <p className="text-[13px] text-gray-500 mb-0.5">Thành tiền</p>
                      <p className="text-[16px] font-bold text-gray-900">{fmt(c.thanhTien)}</p>
                    </div>
                  </div>
                ))}
              </>
            )}

            {/* Tiền điện */}
            <div className="flex justify-between items-start py-4 border-t border-gray-100">
              <div>
                <p className="text-[15px] font-bold text-gray-900">Tiền điện</p>
                <p className="text-[13px] text-gray-500 mt-0.5 mb-1.5">Số mới: {formData.chiSoDienCuoiKy || 0} - Số cũ: {formData.chiSoDienBanDau || 0}</p>
                {hoaDon?.chiTietHoaDon?.find((c: any) => c.loai === 'TIEN_DIEN') ? (
                  <span className="inline-flex items-center px-2.5 py-1 rounded-full bg-[#F0FDF4] text-gray-800 text-[13px] font-medium">
                    <span className="w-1.5 h-1.5 rounded-full bg-gray-400 mr-2"></span>
                    {hoaDon.chiTietHoaDon!.find((c: any) => c.loai === 'TIEN_DIEN')?.soLuong} KWh x {fmt(hoaDon.chiTietHoaDon!.find((c: any) => c.loai === 'TIEN_DIEN')?.donGia || 0).replace(' đ', '')}đ
                  </span>
                ) : (
                  <span className="inline-flex items-center px-2.5 py-1 rounded-full bg-[#F0FDF4] text-gray-800 text-[13px] font-medium">
                    <span className="w-1.5 h-1.5 rounded-full bg-gray-400 mr-2"></span>
                    {soDienSD} KWh
                  </span>
                )}
              </div>
              <div className="text-right">
                <p className="text-[13px] text-gray-500 mb-0.5">Thành tiền</p>
                <p className="text-[16px] font-bold text-gray-900">{fmt(formData.tienDien || 0)}</p>
              </div>
            </div>

            {/* Tiền nước */}
            <div className="flex justify-between items-start py-4 border-t border-gray-100">
              <div>
                <p className="text-[15px] font-bold text-gray-900">Tiền nước</p>
                {(formData.chiSoNuocCuoiKy > 0 || formData.chiSoNuocBanDau > 0) && (
                  <p className="text-[13px] text-gray-500 mt-0.5 mb-1.5">Số mới: {formData.chiSoNuocCuoiKy || 0} - Số cũ: {formData.chiSoNuocBanDau || 0}</p>
                )}
                {hoaDon?.chiTietHoaDon?.find((c: any) => c.loai === 'TIEN_NUOC') ? (
                  <span className="inline-flex items-center px-2.5 py-1 rounded-full bg-[#F0FDF4] text-gray-800 text-[13px] font-medium">
                    <span className="w-1.5 h-1.5 rounded-full bg-gray-400 mr-2"></span>
                    {hoaDon.chiTietHoaDon!.find((c: any) => c.loai === 'TIEN_NUOC')?.soLuong} khối x {fmt(hoaDon.chiTietHoaDon!.find((c: any) => c.loai === 'TIEN_NUOC')?.donGia || 0).replace(' đ', '')}đ
                  </span>
                ) : (
                  <span className="inline-flex items-center px-2.5 py-1 rounded-full bg-[#F0FDF4] text-gray-800 text-[13px] font-medium">
                    <span className="w-1.5 h-1.5 rounded-full bg-gray-400 mr-2"></span>
                    {soNuocSD} khối
                  </span>
                )}
              </div>
              <div className="text-right">
                <p className="text-[13px] text-gray-500 mb-0.5">Thành tiền</p>
                <p className="text-[16px] font-bold text-gray-900">{fmt(formData.tienNuoc || 0)}</p>
              </div>
            </div>

            {/* Dịch vụ khác */}
            {formData.phiDichVu.map((phi: any, i: number) => {
              const matchChiTiet = hoaDon?.chiTietHoaDon?.find((c: any) => c.loai === 'TIEN_DICH_VU' && c.moTa?.includes(phi.ten));
              return (
                <div key={i} className="flex justify-between items-start py-4 border-t border-gray-100">
                  <div>
                    <p className="text-[15px] font-bold text-gray-900">{phi.ten}</p>
                    <span className="inline-flex items-center px-2.5 py-1 rounded-full bg-[#F0FDF4] text-gray-800 text-[13px] font-medium mt-1">
                      <span className="w-1.5 h-1.5 rounded-full bg-gray-400 mr-2"></span>
                      {matchChiTiet?.moTa || 'Phí dịch vụ'}
                    </span>
                  </div>
                  <div className="text-right">
                    <p className="text-[13px] text-gray-500 mb-0.5">Thành tiền</p>
                    <p className="text-[16px] font-bold text-gray-900">{fmt(phi.gia || 0)}</p>
                  </div>
                </div>
              );
            })}

            {/* Phí gửi xe */}
            {hoaDon?.chiTietHoaDon?.filter((c: any) => c.loai === 'PARKING').map((phiXe: any, i: number) => (
              <div key={`parking-${i}`} className="flex justify-between items-start py-4 border-t border-gray-100">
                <div>
                  <p className="text-[15px] font-bold text-gray-900">Phí gửi xe</p>
                  <span className="inline-flex items-center px-2.5 py-1 rounded-full bg-[#F0FDF4] text-gray-800 text-[13px] font-medium mt-1">
                    <span className="w-1.5 h-1.5 rounded-full bg-gray-400 mr-2"></span>
                    {phiXe.moTa}
                  </span>
                </div>
                <div className="text-right">
                  <p className="text-[13px] text-gray-500 mb-0.5">Thành tiền</p>
                  <p className="text-[16px] font-bold text-gray-900">{fmt(phiXe.thanhTien || 0)}</p>
                </div>
              </div>
            ))}

            <div className="flex flex-col items-end pb-5 pt-3">
              <p className="text-[14px] text-gray-600 mb-1.5">Tổng cộng kỳ này</p>
              <p className="text-[22px] font-extrabold text-gray-900">{fmt(formData.tongTien)}</p>
            </div>
          </div>
          <div className="absolute top-0 bottom-0 right-0 w-1 bg-gradient-to-l from-black/5 to-transparent pointer-events-none"></div>
        </div>

        {/* Đã trả & Số lần thanh toán */}
        <div className="flex flex-col items-end px-2 pt-2 pb-1">
          <p className="text-[14px] text-gray-600 mb-1">Đã trả</p>
          <p className="text-[22px] font-bold text-[#16A34A]">{fmt(formData.daThanhToan)}</p>
        </div>

        <div className="bg-[#F0FDF4] border border-[#86EFAC] rounded-xl p-4 flex items-center justify-between shadow-sm relative mb-4">
          <div>
            <p className="text-[14px] text-gray-800 font-medium">Số lần thanh toán</p>
            <a href="#payment-history" className="text-[14px] text-[#2563EB] hover:underline mt-1 inline-block">
              {(hoaDon as any).lichSuThanhToan ? (hoaDon as any).lichSuThanhToan.length : 0} lần, nhấp để xem
            </a>
          </div>
          <div className="text-right">
            <p className="text-[14px] text-gray-800 font-medium mb-1">Tổng phải thu</p>
            {formData.soDuCo > 0 || (formData.trangThai as string) === 'OVERPAID' ? (
              <span className="text-[14px] font-semibold text-[#0F766E]">
                Dư có {fmt(formData.soDuCo)}
              </span>
            ) : formData.trangThai === 'daThanhToan' || (formData.trangThai as string) === 'PAID' ? (
              <span className="text-[14px] font-semibold text-[#16A34A] flex items-center justify-end gap-1.5">
                <CheckCircle2 className="h-4 w-4" />
                Đã thu xong
              </span>
            ) : (
              <span className="text-[14px] font-semibold text-red-600">
                Còn nợ {fmt(formData.conLai)}
              </span>
            )}
          </div>
          <div className="absolute top-3 bottom-3 right-0 w-[3px] bg-gray-300 rounded-l-full"></div>
        </div>

        {formData.ghiChu && (
          <div className="bg-amber-50 border border-amber-200 rounded-2xl p-5 mb-4 shadow-sm">
            <p className="text-[13px] font-semibold text-amber-800 mb-1.5">Ghi chú</p>
            <p className="text-[14px] text-amber-900">{formData.ghiChu}</p>
          </div>
        )}



        {isDraft && <Button
          className="w-full py-6 text-[16px] font-semibold rounded-xl shadow-md mb-3 bg-[#243B5A] hover:bg-[#1C304B]"
          onClick={phatHanhHoaDon}
          disabled={issuing}
        >
          {issuing ? <Loader2 className="mr-2 h-5 w-5 animate-spin" /> : <Send className="mr-2 h-5 w-5" />} Phát hành hóa đơn
        </Button>}

        {isDraft && <Button
          variant="destructive"
          className="w-full py-6 text-[16px] font-semibold rounded-xl shadow-md mb-6 hover:bg-red-700"
          onClick={() => setIsConfirmOpen(true)}
        >
          <Trash2 className="mr-2 h-5 w-5" /> Xóa hóa đơn
        </Button>}

        {!isDraft && hoaDon.trangThai !== 'PAID' && hoaDon.trangThai !== 'daThanhToan' && hoaDon.trangThai !== 'CANCELLED' && hoaDon.trangThai !== 'daHuy' && <Button
          variant="outline"
          className="w-full py-5 text-[15px] font-semibold rounded-xl mb-3 border-red-200 text-red-700 hover:bg-red-50"
          onClick={huyHoaDon}
        >Hủy hóa đơn (cần lý do)</Button>}

        <Card className="mb-6 print:shadow-none">
          <CardHeader><CardTitle className="text-base">Nguồn và kiểm chứng từng dòng</CardTitle><CardDescription>Thông tin này được máy chủ chốt khi tạo hóa đơn.</CardDescription></CardHeader>
          <CardContent className="overflow-x-auto">
            <table className="w-full text-sm"><thead><tr className="border-b text-left text-gray-500"><th className="pb-2">Dòng tiền</th><th className="pb-2">Nguồn</th><th className="pb-2">Kỳ tính</th><th className="pb-2">Mã kiểm chứng</th></tr></thead>
              <tbody>{(hoaDon.chiTietHoaDon || hoaDon.chiTiet || []).map((item: any) => <tr key={item.id || item.moTa} className="border-b align-top"><td className="py-2">{item.moTa}</td><td className="py-2">{item.sourceType || 'Dữ liệu cũ'}</td><td className="py-2">{item.periodStart || '-'}{item.periodEnd ? ` → ${item.periodEnd}` : ''}</td><td className="py-2 font-mono text-xs break-all">{item.calculationHash || '-'}</td></tr>)}</tbody>
            </table>
          </CardContent>
        </Card>

        <Card className="mb-6 print:hidden">
          <CardHeader><CardTitle className="text-base">Lịch sử hóa đơn</CardTitle><CardDescription>Ai đã thực hiện thao tác và thời điểm ghi nhận.</CardDescription></CardHeader>
          <CardContent className="space-y-3">
            {timeline.length === 0 ? <p className="text-sm text-gray-500">Chưa có lịch sử để hiển thị.</p> : timeline.map((item) => <div key={item.id || `${item.hanhDong}-${item.thoiDiem}`} className="flex items-center justify-between border-b pb-2 text-sm"><span className="font-medium">{item.hanhDong}</span><span className="text-right text-gray-500">{item.nguoiThucHien || 'Hệ thống'}<br />{item.thoiDiem ? new Date(item.thoiDiem).toLocaleString('vi-VN') : ''}</span></div>)}
          </CardContent>
        </Card>


        {/* Edit form (collapsible) */}
        {isDraft && <details className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden group">
          <summary className="flex items-center justify-between px-5 py-4 cursor-pointer select-none list-none">
            <span className="text-sm font-semibold text-gray-700">✏️ Chỉnh sửa hóa đơn</span>
            <span className="text-gray-400 group-open:rotate-180 transition-transform">▼</span>
          </summary>
          <div className="px-5 pb-5 border-t border-gray-100">
            <form onSubmit={handleSubmit} className="space-y-4 pt-4">
              {/* Trạng thái & Hạn thanh toán */}
              <div className="grid grid-cols-2 gap-3">
                <div className="space-y-1.5">
                  <Label className="text-xs font-medium text-gray-600">Trạng thái</Label>
                  <Select
                    value={formData.trangThai}
                    onValueChange={(v) => setFormData(prev => ({ ...prev, trangThai: v as typeof formData.trangThai }))}
                  >
                    <SelectTrigger className="h-10 text-sm">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="chuaThanhToan">Chưa thanh toán</SelectItem>
                      <SelectItem value="daThanhToanMotPhan">Một phần</SelectItem>
                      <SelectItem value="daThanhToan">Đã thanh toán</SelectItem>
                      <SelectItem value="quaHan">Quá hạn</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-1.5">
                  <Label className="text-xs font-medium text-gray-600">Hạn thanh toán</Label>
                  <Input
                    type="date"
                    value={formData.hanThanhToan}
                    onChange={(e) => setFormData(prev => ({ ...prev, hanThanhToan: e.target.value }))}
                    className="h-10 text-sm"
                  />
                </div>
              </div>

              {/* Chỉ số điện */}
              <div className="space-y-2">
                <p className="text-xs font-semibold text-gray-600 flex items-center gap-1"><Zap className="h-3.5 w-3.5 text-yellow-500" />Chỉ số điện</p>
                <div className="flex items-center gap-2 bg-yellow-50 border border-yellow-200 rounded-lg px-3 py-2 mb-1">
                  <input
                    type="checkbox" id="resetDien"
                    checked={formData.resetCongTo}
                    onChange={(e) => setFormData(prev => ({ ...prev, resetCongTo: e.target.checked }))}
                    className="h-4 w-4 cursor-pointer"
                  />
                  <label htmlFor="resetDien" className="text-xs text-yellow-800 cursor-pointer">Reset công tơ</label>
                </div>
                <div className="grid grid-cols-2 gap-3">
                  <div className="space-y-1">
                    <Label className="text-xs text-gray-500">Chỉ số cũ (kWh)</Label>
                    <Input type="number" min="0" value={formData.chiSoDienBanDau}
                      onChange={(e) => setFormData(prev => ({ ...prev, chiSoDienBanDau: +e.target.value || 0 }))}
                      className="h-9 text-sm" />
                  </div>
                  <div className="space-y-1">
                    <Label className="text-xs text-gray-500">Chỉ số mới (kWh)</Label>
                    <Input type="number" min="0" value={formData.chiSoDienCuoiKy}
                      onChange={(e) => setFormData(prev => ({ ...prev, chiSoDienCuoiKy: +e.target.value || 0 }))}
                      className="h-9 text-sm" />
                  </div>
                </div>
              </div>

              {/* Chỉ số nước */}
              <div className="space-y-2">
                <p className="text-xs font-semibold text-gray-600 flex items-center gap-1"><Droplets className="h-3.5 w-3.5 text-blue-500" />Chỉ số nước</p>
                <div className="grid grid-cols-2 gap-3">
                  <div className="space-y-1">
                    <Label className="text-xs text-gray-500">Chỉ số cũ (m³)</Label>
                    <Input type="number" min="0" value={formData.chiSoNuocBanDau}
                      onChange={(e) => setFormData(prev => ({ ...prev, chiSoNuocBanDau: +e.target.value || 0 }))}
                      className="h-9 text-sm" />
                  </div>
                  <div className="space-y-1">
                    <Label className="text-xs text-gray-500">Chỉ số mới (m³)</Label>
                    <Input type="number" min="0" value={formData.chiSoNuocCuoiKy}
                      onChange={(e) => setFormData(prev => ({ ...prev, chiSoNuocCuoiKy: +e.target.value || 0 }))}
                      className="h-9 text-sm" />
                  </div>
                </div>
              </div>

              {/* Phí dịch vụ */}
              <div className="space-y-2">
                <p className="text-xs font-semibold text-gray-600 flex items-center gap-1"><Wrench className="h-3.5 w-3.5 text-gray-500" />Phí dịch vụ</p>
                {formData.phiDichVu.map((phi, i) => (
                  <div key={i} className="flex items-center justify-between px-3 py-2 bg-gray-50 rounded-lg border">
                    <span className="text-sm">{phi.ten}</span>
                    <div className="flex items-center gap-2">
                      <span className="text-sm font-medium text-gray-800">{phi.gia.toLocaleString('vi-VN')} đ</span>
                      <button type="button" onClick={() => removePhiDichVu(i)}
                        className="text-red-400 hover:text-red-600 text-xs px-1.5 py-0.5 rounded border border-red-200 hover:bg-red-50">✕</button>
                    </div>
                  </div>
                ))}
                <div className="flex gap-2">
                  <Input placeholder="Tên dịch vụ" value={newPhiDichVu.ten}
                    onChange={(e) => setNewPhiDichVu(prev => ({ ...prev, ten: e.target.value }))}
                    className="flex-1 h-9 text-sm" />
                  <Input placeholder="Giá" type="number" min="0" value={newPhiDichVu.gia}
                    onChange={(e) => setNewPhiDichVu(prev => ({ ...prev, gia: +e.target.value || 0 }))}
                    className="w-28 h-9 text-sm" />
                  <Button type="button" onClick={addPhiDichVu} disabled={!newPhiDichVu.ten || newPhiDichVu.gia <= 0}
                    className="h-9 px-3 text-sm">+</Button>
                </div>
              </div>

              {/* Ghi chú */}
              <div className="space-y-1.5">
                <Label className="text-xs font-medium text-gray-600">Ghi chú</Label>
                <Input value={formData.ghiChu}
                  onChange={(e) => setFormData(prev => ({ ...prev, ghiChu: e.target.value }))}
                  placeholder="Ghi chú về hóa đơn..." className="h-10 text-sm" />
              </div>

              <Button type="submit" disabled={submitting} className="w-full h-11 font-semibold text-base bg-[#243B5A] hover:bg-[#1D314D]">
                {submitting ? <><Loader2 className="h-4 w-4 mr-2 animate-spin" />Đang cập nhật...</> : <><Save className="h-4 w-4 mr-2" />Lưu thay đổi</>}
              </Button>
            </form>
          </div>
        </details>}
      </div>

      <ConfirmActionDialog
        open={isConfirmOpen}
        onOpenChange={setIsConfirmOpen}
        title="Xác nhận xóa hóa đơn"
        description="Bạn có chắc chắn muốn xóa hóa đơn này? Thao tác này không thể hoàn tác."
        confirmText="Xóa"
        variant="destructive"
        loading={isDeleting}
        onConfirm={confirmDelete}
      />
    </div>
  );
}
