'use client';

import { useState, useEffect, type ReactNode } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { useSession } from 'next-auth/react';
import useSWR from 'swr';
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
import { Textarea } from '@/components/ui/textarea';
import type { TaiSanPhong } from '@/types';
import { Badge } from '@/components/ui/badge';
import {
  ArrowLeft,
  Save,
  Loader2,
  Check,
  ChevronsUpDown,
  Plus,
  Home,
  CalendarDays,
  WalletCards,
  Gauge,
  FileText,
  StickyNote,
  Info,
  type LucideIcon
} from 'lucide-react';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { toast } from 'sonner';
import { cn } from "@/lib/utils";
import { normalizeKhachThue, normalizePhong, normalizeToaNha } from '@/lib/domain-mappers';
import { unwrapPageData } from '@/lib/api-response';
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
} from "@/components/ui/command";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";

type PhiDichVuForm = {
  dichVuId?: string;
  ten: string;
  gia: number;
  soLuong?: number;
  loaiTinhPhi?: string;
};

const fieldClass = "space-y-1.5";
const labelClass = "text-[13px] font-semibold text-[#243B5A]";
const helperTextClass = "mt-1.5 block text-xs leading-5 text-[#6B7A90]";
const controlClass = "h-12 w-full rounded-[14px] border border-[rgba(36,59,90,0.12)] bg-white px-4 text-[15px] font-medium text-[#243B5A] shadow-[0_1px_2px_rgba(36,59,90,0.04)] placeholder:text-[#93A1B3] focus-visible:border-[#4FA7A0] focus-visible:ring-4 focus-visible:ring-[#4FA7A0]/15 focus-visible:ring-offset-0";
const comboControlClass = "min-h-12 w-full justify-between rounded-[14px] border border-[rgba(36,59,90,0.12)] bg-white px-4 text-left text-[15px] font-semibold text-[#243B5A] shadow-[0_1px_2px_rgba(36,59,90,0.04)] hover:bg-[#FFFCF7] hover:shadow-[0_8px_18px_rgba(36,59,90,0.08)] focus-visible:border-[#4FA7A0] focus-visible:ring-4 focus-visible:ring-[#4FA7A0]/15 focus-visible:ring-offset-0 disabled:cursor-not-allowed disabled:opacity-60";
const selectTriggerClass = "h-12 w-full rounded-[14px] border border-[rgba(36,59,90,0.12)] bg-white px-4 text-[15px] font-semibold text-[#243B5A] shadow-[0_1px_2px_rgba(36,59,90,0.04)] focus:border-[#4FA7A0] focus:ring-4 focus:ring-[#4FA7A0]/15 focus:ring-offset-0";
const quickButtonClass = "h-9 rounded-full border border-[rgba(36,59,90,0.12)] bg-white px-4 text-xs font-semibold text-[#243B5A] shadow-sm transition-all hover:-translate-y-0.5 hover:border-[#4FA7A0]/35 hover:bg-[#4FA7A0]/10 hover:text-[#2F7F79]";
const textareaClass = "w-full rounded-[14px] border border-[rgba(36,59,90,0.12)] bg-white px-4 py-3 text-[15px] font-medium leading-6 text-[#243B5A] shadow-[0_1px_2px_rgba(36,59,90,0.04)] placeholder:text-[#93A1B3] focus-visible:border-[#4FA7A0] focus-visible:ring-4 focus-visible:ring-[#4FA7A0]/15 focus-visible:ring-offset-0 [&::-webkit-scrollbar]:w-2 [&::-webkit-scrollbar-thumb]:rounded-full [&::-webkit-scrollbar-thumb]:bg-[#4FA7A0]/30 [&::-webkit-scrollbar-track]:bg-transparent";

function FormSection({
  title,
  description,
  icon: Icon,
  children,
}: {
  title: string;
  description?: string;
  icon: LucideIcon;
  children: ReactNode;
}) {
  return (
    <section className="rounded-[18px] border border-[rgba(36,59,90,0.08)] bg-white/55 p-4 shadow-[0_10px_26px_rgba(36,59,90,0.04)] md:p-5">
      <div className="mb-4 flex items-start gap-3">
        <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-[12px] bg-[#4FA7A0]/12 text-[#2F7F79]">
          <Icon className="h-4.5 w-4.5" />
        </div>
        <div className="min-w-0">
          <h2 className="text-base font-bold text-[#243B5A] md:text-[17px]">{title}</h2>
          {description && <p className="mt-1 text-xs leading-5 text-[#6B7A90] md:text-[13px]">{description}</p>}
        </div>
      </div>
      {children}
    </section>
  );
}

export default function ThemMoiHopDongPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const nhaTroId = searchParams.get('nhaTroId');
  const datCocId = searchParams.get('datCocId');
  const phongId = searchParams.get('phongId');
  const khachThueId = searchParams.get('khachThueId');
  const tienCocParams = searchParams.get('tienCoc');

  const { data: session } = useSession();
  const accessToken = session?.accessToken;
  const [selectedNhaTro, setSelectedNhaTro] = useState<string>(nhaTroId || '');
  const [openNhaTro, setOpenNhaTro] = useState(false);
  const [submitting, setSubmitting] = useState(false);

  // SWR Fetcher
  const fetcher = async (url: string) => {
    const res = await fetch(url, {
      headers: {
        'Authorization': `Bearer ${accessToken}`,
      },
    });
    const json = await res.json();
    return unwrapPageData<unknown>(json.data);
  };

  const { data: nhaTroListData } = useSWR<unknown[]>(accessToken ? '/api/toa-nha?page=1&limit=100' : null, fetcher);
  const nhaTroList = (nhaTroListData || []).map(normalizeToaNha);

  const { data: phongListData } = useSWR(
    selectedNhaTro ? `/api/phong?page=1&limit=100&nhaTroId=${selectedNhaTro}&simple=true` : null,
    fetcher
  );
  const phongList = (phongListData || []).map(normalizePhong);

  const { data: khachThueListData, mutate: mutateKhachThue } = useSWR(
    selectedNhaTro ? `/api/khach-thue?page=1&limit=100&nhaTroId=${selectedNhaTro}` : null,
    fetcher
  );
  const khachThueList = (khachThueListData || []).map(normalizeKhachThue);

  const [formData, setFormData] = useState({
    maHopDong: '',
    phong: phongId || '',
    khachThueId: khachThueId ? [khachThueId] : ([] as string[]),
    nguoiDaiDien: khachThueId || '',
    ngayBatDau: new Date().toISOString().split('T')[0],
    ngayKetThuc: '',
    giaThue: 0 as number | string,
    tienCoc: (tienCocParams ? Number(tienCocParams) : 0) as number | string,
    chuKyThanhToan: 'thang' as 'thang' | 'quy' | 'nam',
    ngayThanhToan: 5 as number | string,
    ghiChu: '',
    dieuKhoan: `ĐIỀU KHOẢN HỢP ĐỒNG THUÊ PHÒNG

1. BÊN CHO THUÊ (Chủ nhà):
- Cung cấp phòng ở đầy đủ tiện nghi theo thỏa thuận
- Đảm bảo an ninh, an toàn cho khách thuê
- Bảo trì, sửa chữa các hư hỏng do hao mòn tự nhiên

2. BÊN THUÊ (Khách thuê):
- Thanh toán đúng hạn tiền thuê và các chi phí khác
- Sử dụng phòng đúng mục đích, giữ gìn vệ sinh
- Không được cải tạo, sửa chữa phòng mà không có sự đồng ý
- Báo cáo kịp thời các hư hỏng, sự cố

3. ĐIỀU KHOẢN CHUNG:
- Thời hạn hợp đồng: Từ ngày bắt đầu đến ngày kết thúc
- Tiền cọc: Được hoàn trả khi kết thúc hợp đồng (trừ các khoản phát sinh)
- Thanh toán: Hàng tháng vào ngày quy định
- Điện, nước: Tính theo chỉ số đồng hồ và giá quy định
- Phí dịch vụ: Theo thỏa thuận riêng

4. CHẤM DỨT HỢP ĐỒNG:
- Bên thuê có thể chấm dứt hợp đồng trước thời hạn với thông báo trước 30 ngày
- Bên cho thuê có thể chấm dứt hợp đồng nếu vi phạm nghiêm trọng
- Hoàn trả tiền cọc sau khi kiểm tra tình trạng phòng

5. ĐIỀU KHOẢN KHÁC:
- Hai bên cam kết thực hiện đúng các điều khoản đã thỏa thuận
- Mọi tranh chấp sẽ được giải quyết thông qua thương lượng
- Hợp đồng có hiệu lực kể từ ngày ký`,
    chiSoDienBanDau: 0 as number | string,
    chiSoNuocBanDau: 0 as number | string,
    giaDien: 0 as number | string,
    giaNuoc: 0 as number | string,
    phiDichVu: [] as PhiDichVuForm[],
    trangThai: 'nhap' as 'nhap' | 'choKichHoat' | 'hoatDong' | 'hetHan' | 'daKetThuc' | 'daHuy',
  });

  
  useEffect(() => {
    fetch('/api/hop-dong/default-terms')
      .then((res) => res.json())
      .then((resData) => {
        if (resData?.data) {
          const rawText = resData.data
            .replace(/<p>/g, '')
            .replace(/<\/p>/g, '\n\n')
            .replace(/<strong>/g, '')
            .replace(/<\/strong>/g, '')
            .trim();
          setFormData((prev) => {
            if (!prev.dieuKhoan || prev.dieuKhoan.includes('ĐIỀU KHOẢN HỢP ĐỒNG THUÊ PHÒNG')) {
              return { ...prev, dieuKhoan: rawText };
            }
            return prev;
          });
        }
      })
      .catch((err) => console.error('Error loading default terms:', err));
  }, []);

  const { data: taiSanListData } = useSWR(
    formData.phong ? `/api/tai-san-phong/phong/${formData.phong}` : null,
    fetcher
  );
  const taiSanList = (taiSanListData || []) as TaiSanPhong[];

  const [openPhong, setOpenPhong] = useState(false);
  const [openKhachThue, setOpenKhachThue] = useState(false);
  const [openNguoiDaiDien, setOpenNguoiDaiDien] = useState(false);
  const [openAddKhachThue, setOpenAddKhachThue] = useState(false);
  const [openPreviewModal, setOpenPreviewModal] = useState(false);
  const [previewHopDongId, setPreviewHopDongId] = useState<string | null>(null);
  const [loadingAddKhachThue, setLoadingAddKhachThue] = useState(false);
  // Cac truong nay dung bang danh sach bat buoc o ContractDocumentService.
  // thieuThongTin(). Thu thap du ngay tu dau de sau nay khong bi chan luc ky.
  const [newKhachThueData, setNewKhachThueData] = useState({
    hoTen: '', soDienThoai: '', cccd: '', ngaySinh: '', diaChi: '',
  });

  const handleQuickAddKhachThue = async (e: React.FormEvent) => {
    e.preventDefault();
    const thieu: string[] = [];
    if (!newKhachThueData.hoTen.trim()) thieu.push('họ và tên');
    if (!newKhachThueData.soDienThoai.trim()) thieu.push('số điện thoại');
    if (!newKhachThueData.cccd.trim()) thieu.push('CCCD/CMND');
    if (!newKhachThueData.ngaySinh) thieu.push('ngày sinh');
    if (!newKhachThueData.diaChi.trim()) thieu.push('địa chỉ thường trú');
    if (thieu.length > 0) {
      toast.error(`Vui lòng nhập ${thieu.join(', ')} — đây là thông tin bắt buộc để ký hợp đồng`);
      return;
    }
    setLoadingAddKhachThue(true);
    try {
      const response = await fetch('/api/khach-thue', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify(newKhachThueData),
      });
      const result = await response.json();
      if (response.ok && result.success) {
        toast.success('Thêm khách thuê thành công');
        
        // Cập nhật SWR cache ngay lập tức để danh sách hiển thị
        if (result.data) {
          mutateKhachThue((prev: unknown[] | undefined) => {
            const newList = prev ? [result.data, ...prev] : [result.data];
            return newList;
          }, false);
          
          // Tự động chọn làm người đại diện
          const newId = result.data._id || result.data.id;
          if (newId) {
            setFormData(prev => ({
              ...prev,
              nguoiDaiDien: String(newId),
              khachThueId: prev.khachThueId.filter((id: string) => id !== String(newId))
            }));
          }
        }
        
        // Gọi mutate để fetch lại data từ server background
        mutateKhachThue();
        setOpenAddKhachThue(false);
        setNewKhachThueData({ hoTen: '', soDienThoai: '', cccd: '', ngaySinh: '', diaChi: '' });
      } else {
        toast.error(result.message || 'Thêm khách thuê thất bại');
      }
    } catch (error) {
      console.error(error);
      toast.error('Có lỗi xảy ra');
    } finally {
      setLoadingAddKhachThue(false);
    }
  };

  useEffect(() => {
    if (selectedNhaTro && accessToken) {
      const fetchPrices = async () => {
        try {
          const [dienRes, nuocRes] = await Promise.all([
            fetch(`/api/cau-hinh-gia/ap-dung?nhaTroId=${selectedNhaTro}&loai=ELECTRICITY`, {
              headers: { Authorization: `Bearer ${accessToken}` }
            }),
            fetch(`/api/cau-hinh-gia/ap-dung?nhaTroId=${selectedNhaTro}&loai=WATER`, {
              headers: { Authorization: `Bearer ${accessToken}` }
            })
          ]);
          
          const dienData = dienRes.ok ? await dienRes.json() : null;
          const nuocData = nuocRes.ok ? await nuocRes.json() : null;

          setFormData(prev => ({
            ...prev,
            giaDien: dienData?.data?.donGia || prev.giaDien || 0,
            giaNuoc: nuocData?.data?.donGia || prev.giaNuoc || 0
          }));
        } catch (err) {
          console.error("Error fetching cau hinh gia", err);
        }
      };
      fetchPrices();
    }
  }, [selectedNhaTro, accessToken]);

  const ensureISODate = (dateStr: string) => {
    if (!dateStr) return '';
    if (/^\d{4}-\d{2}-\d{2}$/.test(dateStr)) return dateStr;
    const parts = dateStr.split('/');
    if (parts.length === 3) {
      const day = parts[0].padStart(2, '0');
      const month = parts[1].padStart(2, '0');
      const year = parts[2];
      return `${year}-${month}-${day}`;
    }
    const parsed = new Date(dateStr);
    return Number.isNaN(parsed.getTime()) ? dateStr : parsed.toISOString().split('T')[0];
  };

  const validateContractForm = () => {
    const startDate = ensureISODate(formData.ngayBatDau);
    const endDate = ensureISODate(formData.ngayKetThuc);

    if (!formData.phong) return 'Vui lòng chọn phòng cho hợp đồng';
    if (!formData.nguoiDaiDien) return 'Vui lòng chọn người đại diện hợp đồng';
    if (!startDate || !endDate) return 'Vui lòng nhập ngày bắt đầu và ngày kết thúc hợp đồng';
    if (!/^\d{4}-\d{2}-\d{2}$/.test(startDate) || !/^\d{4}-\d{2}-\d{2}$/.test(endDate)) {
      return 'Ngày hợp đồng không hợp lệ';
    }
    if (endDate <= startDate) return 'Ngày kết thúc hợp đồng phải sau ngày bắt đầu';
    if (!Number.isFinite(Number(formData.giaThue)) || Number(formData.giaThue) < 0) {
      return 'Giá thuê hợp đồng không hợp lệ';
    }
    if (!Number.isFinite(Number(formData.tienCoc)) || Number(formData.tienCoc) < 0) {
      return 'Tiền cọc hợp đồng không hợp lệ';
    }
    if (!Number.isInteger(Number(formData.ngayThanhToan)) || Number(formData.ngayThanhToan) < 1 || Number(formData.ngayThanhToan) > 31) {
      return 'Ngày thanh toán hằng tháng phải từ 1 đến 31';
    }
    if (Number(formData.chiSoDienBanDau) < 0 || Number(formData.chiSoNuocBanDau) < 0) {
      return 'Chỉ số điện nước ban đầu không được âm';
    }
    const invalidService = formData.phiDichVu.find((item) =>
      !item.ten.trim() ||
      !Number.isFinite(Number(item.gia)) ||
      Number(item.gia) < 0 ||
      !Number.isFinite(Number(item.soLuong || 1)) ||
      Number(item.soLuong || 1) < 0
    );
    if (invalidService) return `Dịch vụ "${invalidService.ten || 'chưa đặt tên'}" có đơn giá hoặc số lượng không hợp lệ`;
    return null;
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND',
    }).format(amount);
  };

  const handlePhongChange = (phongId: string) => {
    const selectedPhong = phongList.find(p => p._id === phongId);
    if (selectedPhong) {
      setFormData(prev => ({
        ...prev,
        phong: phongId,
        giaThue: selectedPhong.giaThue || 0,
        tienCoc: selectedPhong.tienCoc || 0,
        phiDichVu: [],
      }));
    }
    setOpenPhong(false);
  };

  const toggleKhachThue = (khachThueId: string) => {
    if (khachThueId === formData.nguoiDaiDien) return;
    setFormData(prev => ({
      ...prev,
      khachThueId: prev.khachThueId.includes(khachThueId)
        ? prev.khachThueId.filter(id => id !== khachThueId)
        : [...prev.khachThueId, khachThueId]
    }));
  };

  const calculateEndDate = (startDate: string, months: number) => {
    const start = new Date(startDate);
    const end = new Date(start);
    end.setMonth(end.getMonth() + months);
    end.setDate(end.getDate() - 1);
    return end.toISOString().split('T')[0];
  };

  const setQuickDuration = (months: number) => {
    if (formData.ngayBatDau) {
      const endDate = calculateEndDate(formData.ngayBatDau, months);
      setFormData(prev => ({
        ...prev,
        ngayKetThuc: endDate
      }));
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const validationError = validateContractForm();
    if (validationError) {
      toast.error(validationError);
      return;
    }

    setSubmitting(true);
    try {
      const thanhVienIds = Array.from(new Set([formData.nguoiDaiDien, ...formData.khachThueId].filter(Boolean)));
      const hopDongPayload = {
        ...formData,
        nguoiDaiDien: formData.nguoiDaiDien,
        khachThueId: thanhVienIds,
        khachThueIds: thanhVienIds,
        ngayBatDau: ensureISODate(formData.ngayBatDau),
        ngayKetThuc: ensureISODate(formData.ngayKetThuc),
        giaThueHopDong: Number(formData.giaThue || 0),
        trangThai: 'nhap',
        phiDichVu: [
          ...formData.phiDichVu
            .filter((phi: PhiDichVuForm) =>
              !phi.ten.toLowerCase().includes('điện') && 
              !phi.ten.toLowerCase().includes('nước') &&
              !phi.ten.toLowerCase().includes('electricity') && 
              !phi.ten.toLowerCase().includes('water')
            )
            .map((phi: PhiDichVuForm) => ({
              ...phi,
              gia: Number(phi.gia || 0)
            })),
          { ten: 'Điện', gia: Number(formData.giaDien || 0), soLuong: 1, loaiTinhPhi: 'theo_chi_so' },
          { ten: 'Nước', gia: Number(formData.giaNuoc || 0), soLuong: 1, loaiTinhPhi: 'theo_chi_so' }
        ],
      };

      let apiUrl = previewHopDongId ? `/api/hop-dong/${previewHopDongId}` : '/api/hop-dong';
      let method = previewHopDongId ? 'PUT' : 'POST';
      if (!previewHopDongId && datCocId) {
        apiUrl = `/api/dat-coc/${datCocId}/convert-to-contract`;
      }

      const requestBody = (!previewHopDongId && datCocId)
        ? { hopDongRequest: hopDongPayload }
        : hopDongPayload;

      const response = await fetch(apiUrl, {
        method,
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify(requestBody),
      });

      const result = await response.json().catch(() => ({}));
      if (response.ok && result.success) {
        const savedId = result.data?._id || result.data?.id || previewHopDongId;
        setPreviewHopDongId(savedId);
        setOpenPreviewModal(true);
      } else {
        toast.error(result.message || 'Có lỗi khi chuẩn bị xem trước hợp đồng');
      }
    } catch (error) {
      console.error('Lỗi xem trước:', error);
      toast.error('Có lỗi xảy ra');
    } finally {
      setSubmitting(false);
    }
  };

  if (!nhaTroListData) {
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
    <div className="mx-auto w-full max-w-7xl space-y-6 px-1 pb-10 text-[#243B5A] md:px-3 lg:px-4">
      {/* Header */}
      <div className="flex items-center gap-4 pt-1 md:gap-5">
        <Button
          variant="outline"
          onClick={() => router.push('/dashboard/hop-dong')}
          className="h-11 w-11 rounded-[14px] border-[rgba(36,59,90,0.12)] bg-[#FFFCF7] p-0 text-[#243B5A] shadow-sm transition-all hover:-translate-y-0.5 hover:bg-white hover:shadow-[0_10px_22px_rgba(36,59,90,0.08)]"
        >
          <ArrowLeft className="h-4 w-4" />
        </Button>
        <div>
          <h1 className="text-2xl font-bold tracking-normal text-[#243B5A] md:text-3xl">Thêm hợp đồng mới</h1>
          <p className="mt-1 text-sm font-medium text-[#6B7A90]">Nhập thông tin để tạo và xem trước hợp đồng.</p>
        </div>
      </div>

      {/* Form */}
      <Card className="overflow-hidden rounded-[24px] border border-[rgba(36,59,90,0.08)] bg-[#FFFCF7] shadow-[0_20px_55px_rgba(36,59,90,0.10)]">
        <CardHeader className="border-b border-[rgba(36,59,90,0.08)] px-5 py-5 md:px-8 md:py-7">
          <CardTitle className="text-xl font-bold text-[#243B5A] md:text-2xl">Thông tin hợp đồng</CardTitle>
          <CardDescription className="mt-1 text-sm font-medium text-[#6B7A90]">
            Điền đầy đủ thông tin để tạo hợp đồng mới
          </CardDescription>
        </CardHeader>
        <CardContent className="px-5 py-5 md:px-8 md:py-8">
          <form onSubmit={handleSubmit} className="space-y-5 md:space-y-6">
            <FormSection
              title="Thông tin thuê phòng"
              description="Chọn nhà trọ, phòng và người đại diện đứng tên hợp đồng."
              icon={Home}
            >
            <div className="grid grid-cols-1 gap-4 lg:grid-cols-3">
              <div className={fieldClass}>
                <Label className={labelClass}>Nhà trọ <span className="text-[#F2A45B]">*</span></Label>
                <Popover open={openNhaTro} onOpenChange={setOpenNhaTro}>
                  <PopoverTrigger asChild>
                    <Button
                      variant="outline"
                      role="combobox"
                      aria-expanded={openNhaTro}
                      className={comboControlClass}
                    >
                      {selectedNhaTro
                        ? nhaTroList.find((nt) => nt._id === selectedNhaTro)?.tenToaNha
                        : "Chọn nhà trọ..."}
                      <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                    </Button>
                  </PopoverTrigger>
                  <PopoverContent className="w-[90vw] md:w-[300px] p-0">
                    <Command>
                      <CommandInput placeholder="Tìm kiếm nhà trọ..." />
                      <CommandEmpty>Không tìm thấy nhà trọ.</CommandEmpty>
                      <CommandGroup className="max-h-64 overflow-auto">
                        {nhaTroList.map((nt) => (
                          <CommandItem
                            key={nt._id}
                            value={nt.tenToaNha}
                            onSelect={() => {
                              setSelectedNhaTro(nt._id!);
                              setFormData(prev => ({ ...prev, phong: '', giaThue: 0 as number | string, tienCoc: 0 as number | string, phiDichVu: [] }));
                              setOpenNhaTro(false);
                            }}
                          >
                            <Check
                              className={cn(
                                "mr-2 h-4 w-4",
                                selectedNhaTro === nt._id ? "opacity-100" : "opacity-0"
                              )}
                            />
                            {nt.tenToaNha}
                          </CommandItem>
                        ))}
                      </CommandGroup>
                    </Command>
                  </PopoverContent>
                </Popover>
              </div>

              <div className={fieldClass}>
                <Label className={labelClass}>Phòng <span className="text-[#F2A45B]">*</span></Label>
                <Popover open={openPhong} onOpenChange={setOpenPhong}>
                  <PopoverTrigger asChild>
                    <Button
                      variant="outline"
                      role="combobox"
                      aria-expanded={openPhong}
                      className={comboControlClass}
                      disabled={!selectedNhaTro}
                    >
                      {formData.phong
                        ? phongList.find((phong) => phong._id === formData.phong)?.maPhong
                        : "Chọn phòng..."}
                      <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                    </Button>
                  </PopoverTrigger>
                  <PopoverContent className="w-[90vw] md:w-[300px] p-0">
                    <Command>
                      <CommandInput placeholder="Tìm kiếm phòng..." />
                      <CommandEmpty>Không tìm thấy phòng.</CommandEmpty>
                      <CommandGroup className="max-h-64 overflow-auto">
                        {phongList.filter(p => !selectedNhaTro || p.nhaTroId === selectedNhaTro || (typeof p.toaNha === 'object' && (p.toaNha._id === selectedNhaTro || p.toaNha.id === selectedNhaTro))).map((phong) => (
                          <CommandItem
                            key={phong._id}
                            value={`${phong.maPhong} ${phong.dienTich} ${phong.giaThue}`}
                            onSelect={() => handlePhongChange(phong._id!)}
                          >
                            <Check
                              className={cn(
                                "mr-2 h-4 w-4",
                                formData.phong === phong._id ? "opacity-100" : "opacity-0"
                              )}
                            />
                            <div className="flex flex-col">
                              <span>{phong.maPhong} - {phong.dienTich}m²</span>
                              <span className="text-xs text-muted-foreground">
                                {formatCurrency(phong.giaThue)}
                              </span>
                            </div>
                          </CommandItem>
                        ))}
                      </CommandGroup>
                    </Command>
                  </PopoverContent>
                </Popover>
              </div>

              <div className={fieldClass}>
                <Label className={labelClass}>Người đại diện</Label>
                <Popover open={openNguoiDaiDien} onOpenChange={setOpenNguoiDaiDien}>
                  <PopoverTrigger asChild>
                    <Button
                      variant="outline"
                      role="combobox"
                      aria-expanded={openNguoiDaiDien}
                      className={comboControlClass}
                    >
                      {formData.nguoiDaiDien
                        ? khachThueList.find((k) => k._id === formData.nguoiDaiDien)?.hoTen
                        : "Chọn người đại diện..."}
                      <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                    </Button>
                  </PopoverTrigger>
                  <PopoverContent className="w-[90vw] md:w-[300px] p-0">
                    <Command>
                      <CommandInput placeholder="Tìm kiếm..." />
                      <CommandEmpty>Không tìm thấy.</CommandEmpty>
                      <CommandGroup className="max-h-64 overflow-auto">
                        {khachThueList
                          .map((khachThue) => (
                            <CommandItem
                              key={khachThue._id}
                              value={`${khachThue.hoTen} ${khachThue.soDienThoai} ${khachThue._id}`}
                              onSelect={() => {
                                setFormData(prev => ({
                                  ...prev,
                                  nguoiDaiDien: khachThue._id!,
                                  khachThueId: prev.khachThueId.filter(id => id !== khachThue._id),
                                }));
                                setOpenNguoiDaiDien(false);
                              }}
                            >
                              <Check
                                className={cn(
                                  "mr-2 h-4 w-4",
                                  formData.nguoiDaiDien === khachThue._id ? "opacity-100" : "opacity-0"
                                )}
                              />
                              <div className="flex flex-col">
                                <span>{khachThue.hoTen}</span>
                                <span className="text-xs text-muted-foreground">{khachThue.soDienThoai} - {khachThue.cccd}</span>
                              </div>
                            </CommandItem>
                          ))}
                      </CommandGroup>
                      <div className="p-1 border-t">
                        <Button
                          variant="ghost"
                          className="w-full justify-start text-sm"
                          onClick={() => {
                            setOpenNguoiDaiDien(false);
                            setOpenAddKhachThue(true);
                          }}
                        >
                          <Plus className="mr-2 h-4 w-4" />
                          Thêm khách thuê nhanh
                        </Button>
                      </div>
                    </Command>
                  </PopoverContent>
                </Popover>
              </div>
            </div>



            </FormSection>

            {formData.phong && (
              <FormSection
                title="Tài sản bàn giao"
                description="Các tài sản có sẵn trong phòng sẽ được bàn giao cho khách thuê."
                icon={Info}
              >
                <div className="rounded-[14px] border border-[rgba(36,59,90,0.12)] bg-white overflow-hidden">
                  <table className="w-full text-[13px] text-left">
                    <thead className="bg-[#F8FAFC] border-b border-[rgba(36,59,90,0.08)] text-[#6B7A90]">
                      <tr>
                        <th className="px-4 py-3 font-semibold">Tên tài sản</th>
                        <th className="px-4 py-3 font-semibold w-[20%] text-center">Số lượng</th>
                        <th className="px-4 py-3 font-semibold w-[25%] text-right">Giá trị (VNĐ)</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-[rgba(36,59,90,0.08)]">
                      {taiSanList.length > 0 ? (
                        taiSanList.map((ts, idx) => (
                          <tr key={String(ts.id || ts._id || idx)} className="hover:bg-[#F8FAFC]/50 transition-colors">
                            <td className="px-4 py-3 text-[#243B5A] font-medium">
                              {ts.tenTaiSan}
                              {ts.tinhTrang && (
                                <span className="ml-2 inline-flex items-center px-1.5 py-0.5 rounded text-[10px] font-semibold bg-[#4FA7A0]/10 text-[#4FA7A0]">
                                  {ts.tinhTrang}
                                </span>
                              )}
                            </td>
                            <td className="px-4 py-3 text-[#6B7A90] text-center">{ts.soLuong}</td>
                            <td className="px-4 py-3 text-[#243B5A] font-medium text-right text-[#E76F51]">
                              {new Intl.NumberFormat('vi-VN').format(ts.giaTri)}
                            </td>
                          </tr>
                        ))
                      ) : (
                        <tr>
                          <td colSpan={3} className="px-4 py-8 text-center text-[#6B7A90]">
                            Không có tài sản nào được ghi nhận cho phòng này.
                          </td>
                        </tr>
                      )}
                    </tbody>
                  </table>
                </div>
              </FormSection>
            )}

            <FormSection
              title="Thời hạn hợp đồng"
              description="Thiết lập ngày bắt đầu, ngày kết thúc hoặc chọn nhanh thời hạn phổ biến."
              icon={CalendarDays}
            >
            <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
              <div className={fieldClass}>
                <Label htmlFor="ngayBatDau" className={labelClass}>Ngày bắt đầu</Label>
                <Input
                  id="ngayBatDau"
                  type="date"
                  value={formData.ngayBatDau}
                  onChange={(e) => setFormData(prev => ({ ...prev, ngayBatDau: e.target.value }))}
                  required
                  className={controlClass}
                />
              </div>

              <div className={fieldClass}>
                <Label htmlFor="ngayKetThuc" className={labelClass}>Ngày kết thúc</Label>
                <Input
                  id="ngayKetThuc"
                  type="date"
                  value={formData.ngayKetThuc}
                  onChange={(e) => setFormData(prev => ({ ...prev, ngayKetThuc: e.target.value }))}
                  required
                  className={controlClass}
                />
                <div className="flex flex-wrap gap-2 mt-2">
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    onClick={() => setQuickDuration(3)}
                    className={quickButtonClass}
                  >
                    3 tháng
                  </Button>
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    onClick={() => setQuickDuration(6)}
                    className={quickButtonClass}
                  >
                    6 tháng
                  </Button>
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    onClick={() => setQuickDuration(12)}
                    className={quickButtonClass}
                  >
                    1 năm
                  </Button>
                </div>
              </div>
            </div>

            </FormSection>

            <FormSection
              title="Tài chính & thanh toán"
              description="Nhập giá thuê, tiền cọc, ngày thu tiền và trạng thái khởi tạo."
              icon={WalletCards}
            >
            <div className="grid grid-cols-1 gap-4 lg:grid-cols-3">
              <div className={fieldClass}>
                <Label htmlFor="giaThue" className={labelClass}>Giá thuê (VNĐ/tháng)</Label>
                <Input
                  id="giaThue"
                  type="number"
                  min="0"
                  value={formData.giaThue}
                  onChange={(e) => setFormData(prev => ({ ...prev, giaThue: e.target.value === '' ? '' : parseInt(e.target.value) || 0 }))}
                  required
                  className={controlClass}
                />
                <span className={helperTextClass}>
                  {formatCurrency(Number(formData.giaThue))}
                </span>
              </div>

              <div className={fieldClass}>
                <Label htmlFor="tienCoc" className={labelClass}>Tiền cọc (VNĐ)</Label>
                <Input
                  id="tienCoc"
                  type="number"
                  min="0"
                  value={formData.tienCoc}
                  onChange={(e) => setFormData(prev => ({ ...prev, tienCoc: e.target.value === '' ? '' : parseInt(e.target.value) || 0 }))}
                  required
                  className={controlClass}
                />
                <span className={helperTextClass}>
                  {formatCurrency(Number(formData.tienCoc))}
                </span>
              </div>

              <div className={fieldClass}>
                <Label htmlFor="ngayThanhToan" className={labelClass}>Ngày thanh toán</Label>
                <Input
                  id="ngayThanhToan"
                  type="number"
                  min="1"
                  max="31"
                  value={formData.ngayThanhToan}
                  onChange={(e) => setFormData(prev => ({ ...prev, ngayThanhToan: e.target.value === '' ? '' : parseInt(e.target.value) || 1 }))}
                  required
                  className={controlClass}
                />
              </div>
            </div>

            <div className="mt-5 grid grid-cols-1 gap-4 md:grid-cols-2">
              <div className={fieldClass}>
                <Label htmlFor="chuKyThanhToan">Chu kỳ thanh toán</Label>
                <Select value={formData.chuKyThanhToan} onValueChange={(value) => setFormData(prev => ({ ...prev, chuKyThanhToan: value as 'thang' | 'quy' | 'nam' }))}>
                  <SelectTrigger className={selectTriggerClass}>
                    <SelectValue placeholder="Chọn chu kỳ" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="thang">Tháng</SelectItem>
                    <SelectItem value="quy">Quý</SelectItem>
                    <SelectItem value="nam">Năm</SelectItem>
                  </SelectContent>
                </Select>
              </div>



              <div className={fieldClass}>
                <Label htmlFor="trangThai">Trạng thái</Label>
                <Select value={formData.trangThai} onValueChange={(value) => setFormData(prev => ({ ...prev, trangThai: value as 'nhap' | 'choKichHoat' | 'hoatDong' | 'hetHan' | 'daKetThuc' | 'daHuy' }))}>
                  <SelectTrigger className={selectTriggerClass}>
                    <SelectValue placeholder="Chọn trạng thái" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="nhap">Nháp</SelectItem>
                    <SelectItem value="choKichHoat">Chờ kích hoạt</SelectItem>
                    <SelectItem value="hoatDong" disabled>Hoạt động sau khi xác nhận</SelectItem>
                    <SelectItem value="hetHan" disabled>Hết hạn tự động</SelectItem>
                    <SelectItem value="daKetThuc" disabled>Kết thúc bằng chức năng riêng</SelectItem>
                    <SelectItem value="daHuy" disabled>Hủy bằng chức năng riêng</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            </FormSection>

            <FormSection
              title="Chỉ số điện nước ban đầu"
              description="Ghi nhận chỉ số và đơn giá áp dụng khi hợp đồng bắt đầu."
              icon={Gauge}
            >
            <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
              <div className={fieldClass}>
                <Label htmlFor="chiSoDienBanDau">Chỉ số điện ban đầu (kWh)</Label>
                <Input
                  id="chiSoDienBanDau"
                  type="number"
                  min="0"
                  value={formData.chiSoDienBanDau}
                  onChange={(e) => setFormData(prev => ({ ...prev, chiSoDienBanDau: e.target.value === '' ? '' : parseInt(e.target.value) || 0 }))}
                  placeholder="Nhập chỉ số điện ban đầu"
                  required
                  className={controlClass}
                />
                <span className={helperTextClass}>
                  Chỉ số đồng hồ điện khi bắt đầu hợp đồng
                </span>
              </div>

              <div className={fieldClass}>
                <Label htmlFor="chiSoNuocBanDau">Chỉ số nước ban đầu (m³)</Label>
                <Input
                  id="chiSoNuocBanDau"
                  type="number"
                  min="0"
                  value={formData.chiSoNuocBanDau}
                  onChange={(e) => setFormData(prev => ({ ...prev, chiSoNuocBanDau: e.target.value === '' ? '' : parseInt(e.target.value) || 0 }))}
                  placeholder="Nhập chỉ số nước ban đầu"
                  required
                  className={controlClass}
                />
                <span className={helperTextClass}>
                  Chỉ số đồng hồ nước khi bắt đầu hợp đồng
                </span>
              </div>
            </div>

            <div className="mt-4 grid grid-cols-1 gap-4 md:grid-cols-2">
              <div className={fieldClass}>
                <Label htmlFor="giaDien">Đơn giá điện (VNĐ/kWh)</Label>
                <Input
                  id="giaDien"
                  type="number"
                  min="0"
                  value={formData.giaDien}
                  onChange={(e) => setFormData(prev => ({ ...prev, giaDien: e.target.value === '' ? '' : parseInt(e.target.value) || 0 }))}
                  placeholder="Nhập đơn giá điện"
                  required
                  className={controlClass}
                />
                <span className={helperTextClass}>
                  Mức giá cố định áp dụng cho tiền điện
                </span>
              </div>

              <div className={fieldClass}>
                <Label htmlFor="giaNuoc">Đơn giá nước (VNĐ/m³)</Label>
                <Input
                  id="giaNuoc"
                  type="number"
                  min="0"
                  value={formData.giaNuoc}
                  onChange={(e) => setFormData(prev => ({ ...prev, giaNuoc: e.target.value === '' ? '' : parseInt(e.target.value) || 0 }))}
                  placeholder="Nhập đơn giá nước"
                  required
                  className={controlClass}
                />
                <span className={helperTextClass}>
                  Mức giá cố định áp dụng cho tiền nước
                </span>
              </div>
            </div>

            </FormSection>

            <FormSection
              title="Điều khoản hợp đồng"
              description="Rà soát nội dung điều khoản trước khi xem trước và lưu hợp đồng."
              icon={FileText}
            >
            <div className={fieldClass}>
              <Label htmlFor="dieuKhoan">Điều khoản</Label>
              <Textarea
                id="dieuKhoan"
                value={formData.dieuKhoan}
                onChange={(e) => setFormData(prev => ({ ...prev, dieuKhoan: e.target.value }))}
                rows={9}
                required
                className={cn(textareaClass, "min-h-[220px] resize-none")}
              />
            </div>
            </FormSection>

            <FormSection
              title="Ghi chú & tiện ích phòng"
              description="Bổ sung ghi chú bàn giao và xem các tiện ích hiện có của phòng."
              icon={StickyNote}
            >
            <div className={fieldClass}>
              <Label htmlFor="ghiChu">Ghi chú bàn giao / nội bộ</Label>
              <Textarea
                id="ghiChu"
                value={formData.ghiChu}
                onChange={(e) => setFormData(prev => ({ ...prev, ghiChu: e.target.value }))}
                placeholder="Khách không sử dụng Tủ lạnh, đã dọn ra ngoài..."
                rows={4}
                className={cn(textareaClass, "min-h-[112px] resize-none")}
              />
            </div>

            {formData.phong && (
              <div className="mt-5 space-y-2 rounded-[14px] border border-[rgba(36,59,90,0.08)] bg-[#FFFCF7] p-4">
                <Label>Tiện ích có sẵn của phòng</Label>
                <div className="flex flex-wrap gap-2">
                  {(() => {
                    const selectedPhong = phongList.find(p => p._id === formData.phong);
                    const tienNghi = selectedPhong?.tienNghi || [];
                    if (tienNghi.length === 0) return <span className="text-sm text-muted-foreground">Phòng chưa có tiện ích nào được thiết lập.</span>;
                    return tienNghi.map((tn, idx) => (
                      <Badge key={idx} variant="secondary">{tn}</Badge>
                    ));
                  })()}
                </div>
              </div>
            )}

            </FormSection>

            <div className="flex flex-col justify-end gap-3 border-t border-[rgba(36,59,90,0.10)] pt-5 sm:flex-row">
              <Button
                type="button"
                variant="outline"
                onClick={() => router.push('/dashboard/hop-dong')}
                disabled={submitting}
                className="h-12 w-full rounded-[14px] border border-[rgba(36,59,90,0.14)] bg-white px-7 text-sm font-semibold text-[#243B5A] shadow-sm transition-all hover:-translate-y-0.5 hover:bg-[#FFFCF7] hover:shadow-[0_10px_22px_rgba(36,59,90,0.08)] active:scale-[0.98] disabled:cursor-not-allowed disabled:opacity-60 sm:w-auto"
              >
                Hủy
              </Button>
              <Button
                type="submit"
                disabled={submitting}
                className="h-12 w-full rounded-[14px] bg-[#243B5A] px-8 text-sm font-bold text-white shadow-[0_12px_28px_rgba(36,59,90,0.18)] transition-all hover:-translate-y-0.5 hover:bg-[#1D304A] hover:shadow-[0_16px_34px_rgba(36,59,90,0.24)] active:scale-[0.98] disabled:cursor-not-allowed disabled:opacity-60 sm:w-auto"
              >
                {submitting ? (
                  <>
                    <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
                    Đang xử lý...
                  </>
                ) : (
                  <>
                    <Save className="h-4 w-4 mr-2" />
                    Xem trước hợp đồng
                  </>
                )}
              </Button>
            </div>
          </form>
        </CardContent>
      </Card>
            {/* Modal Preview Hop Dong */}
      <Dialog open={openPreviewModal} onOpenChange={setOpenPreviewModal}>
        <DialogContent className="sm:max-w-[900px] h-[85vh] flex flex-col p-6">
          <DialogHeader>
            <DialogTitle className="text-[#243B5A] flex items-center gap-2">
              <FileText className="h-5 w-5 text-[#4FA7A0]" />
              Xem trước Văn bản Hợp đồng
            </DialogTitle>
            <p className="text-xs text-[#6B7A90]">
              Văn bản được tạo trực tiếp từ biểu mẫu chuẩn duy nhất của hệ thống.
            </p>
          </DialogHeader>

          <div className="flex-1 border border-slate-200 rounded-xl overflow-hidden bg-white shadow-inner my-2">
            {previewHopDongId ? (
              <iframe
                src={`/api/hop-dong/${previewHopDongId}/document?format=html`}
                className="w-full h-full border-0"
                title="Xem trước Hợp đồng"
              />
            ) : (
              <div className="flex items-center justify-center h-full text-sm text-slate-500">
                Đang tải văn bản...
              </div>
            )}
          </div>

          <DialogFooter className="mt-2 gap-2 flex flex-col sm:flex-row justify-between items-center">
            <Button
              type="button"
              variant="outline"
              onClick={() => setOpenPreviewModal(false)}
              disabled={submitting}
              className="text-xs"
            >
              Quay lại chỉnh sửa
            </Button>
            <Button
              type="button"
              onClick={() => {
                toast.success('Hợp đồng đã được lưu thành công');
                sessionStorage.removeItem('hop-dong-data');
                if (previewHopDongId) {
                  router.push(`/dashboard/hop-dong/${previewHopDongId}`);
                } else {
                  router.push('/dashboard/hop-dong');
                }
              }}
              disabled={submitting}
              className="bg-[#243B5A] hover:bg-[#1D304A] text-white text-xs font-semibold"
            >
              Hoàn tất & Đến trang Hợp đồng
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Modal Quick Add Khách Thuê */}
      <Dialog open={openAddKhachThue} onOpenChange={setOpenAddKhachThue}>
        <DialogContent className="sm:max-w-[425px]">
          <DialogHeader>
            <DialogTitle>Thêm khách thuê nhanh</DialogTitle>
          </DialogHeader>
          <form onSubmit={handleQuickAddKhachThue} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="hoTen">Họ và tên *</Label>
              <Input
                id="hoTen"
                required
                value={newKhachThueData.hoTen}
                onChange={(e) => setNewKhachThueData(prev => ({ ...prev, hoTen: e.target.value }))}
                placeholder="Nguyễn Văn A"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="soDienThoai">Số điện thoại *</Label>
              <Input
                id="soDienThoai"
                required
                value={newKhachThueData.soDienThoai}
                onChange={(e) => setNewKhachThueData(prev => ({ ...prev, soDienThoai: e.target.value }))}
                placeholder="0987654321"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="cccd">CCCD / CMND *</Label>
              <Input
                id="cccd"
                required
                value={newKhachThueData.cccd}
                onChange={(e) => setNewKhachThueData(prev => ({ ...prev, cccd: e.target.value }))}
                placeholder="012345678912"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="ngaySinh">Ngày sinh *</Label>
              <Input
                id="ngaySinh"
                type="date"
                required
                value={newKhachThueData.ngaySinh}
                onChange={(e) => setNewKhachThueData(prev => ({ ...prev, ngaySinh: e.target.value }))}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="diaChi">Địa chỉ thường trú *</Label>
              <Input
                id="diaChi"
                required
                value={newKhachThueData.diaChi}
                onChange={(e) => setNewKhachThueData(prev => ({ ...prev, diaChi: e.target.value }))}
                placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành"
              />
            </div>
            <p className="text-xs text-muted-foreground">
              Các trường trên đều bắt buộc vì hợp đồng cần đủ thông tin mới ký điện tử được.
            </p>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setOpenAddKhachThue(false)} disabled={loadingAddKhachThue}>
                Hủy
              </Button>
              <Button type="submit" disabled={loadingAddKhachThue}>
                {loadingAddKhachThue ? "Đang thêm..." : "Thêm mới"}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  );
}

