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
import { generateAndDownloadHopDong } from '@/lib/export-hop-dong';
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

type DichVuOption = {
  dichVuId: string;
  ten: string;
  loaiTinhPhi?: string;
  donVi?: string;
  donGiaMacDinh: number;
  batBuoc?: boolean;
};

type ApiDichVu = {
  _id?: string;
  id?: string;
  tenDichVu?: string;
  ten?: string;
  loaiTinhPhi?: string;
  donVi?: string;
  donGiaMacDinh?: number;
  batBuoc?: boolean;
};

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
  const [dichVuOptions, setDichVuOptions] = useState<DichVuOption[]>([]);
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
  const { data: globalDichVuListData } = useSWR<unknown[]>(accessToken ? '/api/dich-vu?page=1&limit=100' : null, fetcher);
  
  const nhaTroList = (nhaTroListData || []).map(normalizeToaNha);
  const globalDichVuList = (globalDichVuListData || []).map((item) => {
    const dv = item as ApiDichVu;
    return {
      dichVuId: String(dv._id ?? dv.id ?? ''),
      ten: dv.tenDichVu ?? dv.ten ?? '',
      loaiTinhPhi: dv.loaiTinhPhi,
      donVi: dv.donVi,
      donGiaMacDinh: Number(dv.donGiaMacDinh || 0),
      batBuoc: dv.batBuoc,
    };
  });

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

  const [openPhong, setOpenPhong] = useState(false);
  const [openKhachThue, setOpenKhachThue] = useState(false);
  const [openNguoiDaiDien, setOpenNguoiDaiDien] = useState(false);
  const [openAddDichVu, setOpenAddDichVu] = useState(false);
  const [openAddKhachThue, setOpenAddKhachThue] = useState(false);
  const [openPreviewModal, setOpenPreviewModal] = useState(false);
  const [loadingAddKhachThue, setLoadingAddKhachThue] = useState(false);
  const [newKhachThueData, setNewKhachThueData] = useState({ hoTen: '', soDienThoai: '', cccd: '' });

  const handleQuickAddKhachThue = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newKhachThueData.hoTen || !newKhachThueData.soDienThoai) {
      toast.error('Vui lòng nhập họ tên và số điện thoại');
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
        setNewKhachThueData({ hoTen: '', soDienThoai: '', cccd: '' });
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

  const loadDichVuTheoPhong = async (phongId: string) => {
    if (!phongId) {
      setDichVuOptions([]);
      return;
    }
    try {
      const response = await fetch(`/api/hop-dong/dich-vu?phongId=${phongId}`, {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const result = response.ok ? await response.json() : { data: [] };
      const options = (result.data || []).map((item: DichVuOption) => ({
        ...item,
        dichVuId: String(item.dichVuId),
        donGiaMacDinh: Number(item.donGiaMacDinh || 0),
      }));
      setDichVuOptions(options);

      setFormData(prev => ({
        ...prev,
        phiDichVu: [
          ...prev.phiDichVu.filter(phi => options.some((option: DichVuOption) => option.dichVuId === phi.dichVuId)),
          ...options
            .filter((option: DichVuOption) => option.batBuoc && !prev.phiDichVu.some(phi => phi.dichVuId === option.dichVuId))
            .map((option: DichVuOption) => ({
              dichVuId: option.dichVuId,
              ten: option.ten,
              gia: option.donGiaMacDinh,
              soLuong: 1,
              loaiTinhPhi: option.loaiTinhPhi,
            })),
        ],
      }));
    } catch (error) {
      console.error('Error loading contract services:', error);
      setDichVuOptions([]);
    }
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
      loadDichVuTheoPhong(phongId);
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

  const toggleDichVuHopDong = (option: DichVuOption) => {
    setFormData(prev => {
      const exists = prev.phiDichVu.some(phi => phi.dichVuId === option.dichVuId);
      return {
        ...prev,
        phiDichVu: exists
          ? prev.phiDichVu.filter(phi => phi.dichVuId !== option.dichVuId)
          : [...prev.phiDichVu, {
            dichVuId: option.dichVuId,
            ten: option.ten,
            gia: option.donGiaMacDinh,
            soLuong: 1,
            loaiTinhPhi: option.loaiTinhPhi,
          }],
      };
    });
  };

  const updateDichVuHopDong = (dichVuId: string, field: 'gia' | 'soLuong', value: number) => {
    setFormData(prev => ({
      ...prev,
      phiDichVu: prev.phiDichVu.map(phi =>
        phi.dichVuId === dichVuId ? { ...phi, [field]: value } : phi
      ),
    }));
  };

  const calculateEndDate = (startDate: string, months: number) => {
    const start = new Date(startDate);
    const end = new Date(start);
    end.setMonth(end.getMonth() + months);
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

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const validationError = validateContractForm();
    if (validationError) {
      toast.error(validationError);
      return;
    }
    setOpenPreviewModal(true);
  };

  const handleConfirmAndSave = async () => {
    if (submitting) return;

    const validationError = validateContractForm();
    if (validationError) {
      toast.error(validationError);
      return;
    }

    setSubmitting(true);

    try {
      const thanhVienIds = Array.from(new Set([formData.nguoiDaiDien, ...formData.khachThueId].filter(Boolean)));
      
      let apiUrl = '/api/hop-dong';
      if (datCocId) {
        apiUrl = `/api/dat-coc/${datCocId}/convert`;
      }

      const hopDongPayload = {
        ...formData,
        nguoiDaiDien: formData.nguoiDaiDien,
        khachThueId: thanhVienIds,
        khachThueIds: thanhVienIds,
        ngayBatDau: ensureISODate(formData.ngayBatDau),
        ngayKetThuc: ensureISODate(formData.ngayKetThuc),
        giaThueHopDong: Number(formData.giaThue || 0),
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

      const requestBody = datCocId 
        ? { hopDongRequest: hopDongPayload }
        : hopDongPayload;

      const response = await fetch(apiUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify(requestBody),
      });

      const result = await response.json().catch(() => ({}));
      if (response.ok && result.success) {
        toast.success(result.message || 'Đã lưu hợp đồng thành công');
        
        try {
          const phongObj = phongList.find(p => p._id === formData.phong);
          const toaNhaObj = nhaTroList.find(t => t._id === selectedNhaTro);
          const phongInfo = {
            maPhong: phongObj?.maPhong || '',
            toaNha: toaNhaObj?.tenToaNha || ''
          };
          const nguoiDaiDienObj = khachThueList.find(k => k._id === formData.nguoiDaiDien);
          const nguoiDaiDienName = nguoiDaiDienObj?.hoTen || '';
          
          await generateAndDownloadHopDong(
            { ...formData, ...result.data, ngayTao: new Date().toISOString() }, 
            phongInfo,
            nguoiDaiDienName,
            nguoiDaiDienObj,
            formatCurrency
          );
        } catch (err) {
          console.error("Error exporting docx", err);
          toast.error("Lưu thành công nhưng lỗi tạo file Hợp đồng");
        }
        
        setOpenPreviewModal(false);
        sessionStorage.removeItem('hop-dong-data');
        router.push('/dashboard/hop-dong');
        router.refresh();
      } else {
        toast.error(result.message || 'Có lỗi xảy ra khi lưu hợp đồng');
      }
    } catch (error) {
      console.error('Error submitting form:', error);
      toast.error('Có lỗi xảy ra khi lưu hợp đồng');
    } finally {
      setSubmitting(false);
    }
  };

  if (!nhaTroListData || !globalDichVuListData) {
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
                              setDichVuOptions([]);
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

            <div className="mt-5 space-y-2">
              <div className="flex items-start gap-2.5 rounded-[12px] border border-[#4FA7A0]/25 bg-[#4FA7A0]/10 px-3 py-2.5 text-xs font-medium leading-5 text-[#256D68]">
                <Info className="mt-0.5 h-4 w-4 shrink-0" />
                Chọn người đại diện đứng tên hợp đồng trước. Danh sách bên dưới chỉ dùng để thêm bạn cùng phòng, không thay thế người đại diện.
              </div>
              <Label className={labelClass}>Bạn cùng phòng / thành viên ở cùng</Label>
              <Popover open={openKhachThue} onOpenChange={setOpenKhachThue}>
                <PopoverTrigger asChild>
                  <Button
                    variant="outline"
                    role="combobox"
                    aria-expanded={openKhachThue}
                    className={cn(comboControlClass, "h-auto py-2.5")}
                  >
                    <div className="flex flex-wrap gap-1 text-xs md:text-sm">
                      {formData.khachThueId.length === 0 ? (
                        <span className="text-muted-foreground">Chọn thêm người ở cùng...</span>
                      ) : (
                        formData.khachThueId.map((id) => {
                          const khachThue = khachThueList.find(k => k._id === id);
                          return (
                            <Badge key={id} variant="secondary" className="mr-1">
                              {khachThue?.hoTen}
                            </Badge>
                          );
                        })
                      )}
                    </div>
                    <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                  </Button>
                </PopoverTrigger>
                <PopoverContent className="w-[90vw] md:w-full p-0">
                  <Command>
                    <CommandInput placeholder="Tìm khách thuê để thêm vào phòng..." className="text-sm" />
                    <CommandEmpty className="text-sm">Không tìm thấy khách thuê.</CommandEmpty>
                    <CommandGroup className="max-h-64 overflow-auto">
                      {khachThueList.filter(khachThue => khachThue._id !== formData.nguoiDaiDien).map((khachThue) => (
                        <CommandItem
                          key={khachThue._id}
                          value={`${khachThue.hoTen} ${khachThue.soDienThoai} ${khachThue._id}`}
                          onSelect={() => toggleKhachThue(khachThue._id!)}
                        >
                          <div className="flex items-center space-x-2 w-full">
                            <div className={cn(
                              "mr-2 flex h-4 w-4 items-center justify-center rounded-sm border border-primary",
                              formData.khachThueId.includes(khachThue._id!)
                                ? "bg-primary text-primary-foreground"
                                : "opacity-50 [&_svg]:invisible"
                            )}>
                              <Check className="h-4 w-4" />
                            </div>
                            <span>{khachThue.hoTen}</span>
                            <span className="text-xs text-muted-foreground ml-auto">
                              {khachThue.soDienThoai}
                            </span>
                          </div>
                        </CommandItem>
                      ))}
                    </CommandGroup>
                  </Command>
                </PopoverContent>
              </Popover>
              <p className="text-xs text-muted-foreground">
                Đã chọn {formData.khachThueId.length} người ở cùng. Tổng người trong hợp đồng: {formData.nguoiDaiDien ? formData.khachThueId.length + 1 : formData.khachThueId.length}.
              </p>
            </div>

            </FormSection>

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
              title="Ghi chú & dịch vụ áp dụng"
              description="Bổ sung ghi chú bàn giao, tiện ích phòng và các dịch vụ tính phí trong hợp đồng."
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

            <div className="mt-5 space-y-3 rounded-[16px] border border-[rgba(36,59,90,0.08)] bg-white/75 p-4 shadow-[0_8px_20px_rgba(36,59,90,0.04)]">
              <Label>Dịch vụ áp dụng cho hợp đồng</Label>
              {!formData.phong ? (
                <p className="text-sm text-muted-foreground">Chọn phòng trước để tải danh sách dịch vụ đang áp dụng cho tòa nhà/phòng.</p>
              ) : dichVuOptions.length === 0 ? (
                <p className="text-sm text-muted-foreground">Phòng này chưa có dịch vụ nào trong cấu hình giá.</p>
              ) : (
                <div className="space-y-4">
                  <div className="overflow-hidden rounded-[14px] border border-[rgba(36,59,90,0.10)] bg-white">
                    {/* Header Desktop */}
                    <div className="hidden grid-cols-[1fr_100px_120px_120px] gap-4 border-b border-[rgba(36,59,90,0.08)] bg-[#F8F3EC]/70 px-4 py-3 text-sm font-semibold text-[#6B7A90] md:grid">
                      <div>Tên dịch vụ</div>
                      <div>Đơn giá</div>
                      <div>Số lượng</div>
                      <div className="text-right">Thành tiền</div>
                    </div>

                    <div className="divide-y">
                      {dichVuOptions.map((option) => {
                        const selected = formData.phiDichVu.find(phi => phi.dichVuId === option.dichVuId);
                        return (
                          <div key={option.dichVuId} className={cn("grid grid-cols-1 items-center gap-3 p-4 transition-colors md:grid-cols-[1fr_160px_120px_120px] md:gap-4", selected ? "bg-[#4FA7A0]/8" : "bg-white hover:bg-[#FFFCF7]")}>
                            <button type="button" onClick={() => toggleDichVuHopDong(option)} className="flex items-center gap-3 text-left">
                              <span className={cn("flex h-5 w-5 shrink-0 items-center justify-center rounded border transition-colors", selected ? "bg-primary border-primary text-primary-foreground" : "border-input")}>
                                {selected && <Check className="h-3.5 w-3.5" />}
                              </span>
                              <div className="flex flex-col gap-0.5">
                                <span className="text-sm font-medium">{option.ten}</span>
                                {option.batBuoc && <span className="text-[10px] uppercase tracking-wider font-semibold text-primary/70">Bắt buộc</span>}
                              </div>
                            </button>

                            <div className="flex items-center gap-2 md:block">
                              <span className="md:hidden w-24 text-sm text-muted-foreground">Đơn giá:</span>
                              <div className="relative w-full">
                                <Input
                                  type="number"
                                  min="0"
                                  className={cn(controlClass, "h-10 pr-7 text-sm", !selected && "opacity-50")}
                                  value={selected?.gia ?? option.donGiaMacDinh}
                                  disabled={!selected}
                                  onChange={(e) => updateDichVuHopDong(option.dichVuId, 'gia', Number(e.target.value) || 0)}
                                />
                                <span className="absolute right-3 top-1/2 -translate-y-1/2 text-xs text-muted-foreground">₫</span>
                              </div>
                            </div>

                            <div className="flex items-center gap-2 md:block">
                              <span className="md:hidden w-24 text-sm text-muted-foreground">Số lượng:</span>
                              <Input
                                type="number"
                                min="0"
                                step="0.1"
                                className={cn(controlClass, "h-10 text-sm", !selected && "opacity-50")}
                                value={selected?.soLuong ?? 1}
                                disabled={!selected}
                                onChange={(e) => updateDichVuHopDong(option.dichVuId, 'soLuong', Number(e.target.value) || 0)}
                              />
                            </div>

                            <div className="flex items-center gap-2 md:block md:text-right border-t md:border-t-0 pt-2 md:pt-0 mt-1 md:mt-0">
                              <span className="md:hidden w-24 text-sm text-muted-foreground">Thành tiền:</span>
                              <div className={cn("text-sm font-semibold md:font-medium", selected ? "text-primary" : "text-muted-foreground")}>
                                {selected ? formatCurrency((selected.gia || 0) * (selected.soLuong || 1)) : formatCurrency(option.donGiaMacDinh)}
                              </div>
                            </div>
                          </div>
                        );
                      })}
                    </div>
                  </div>

                  <div className="mt-4 border-t border-[rgba(36,59,90,0.08)] pt-4">
                    <Label className={cn(labelClass, "mb-2 block")}>Thêm dịch vụ khác</Label>
                    <Popover open={openAddDichVu} onOpenChange={setOpenAddDichVu}>
                      <PopoverTrigger asChild>
                        <Button variant="outline" role="combobox" aria-expanded={openAddDichVu} className={comboControlClass}>
                          Chọn thêm dịch vụ từ danh sách...
                          <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                        </Button>
                      </PopoverTrigger>
                      <PopoverContent className="w-[90vw] md:w-full p-0">
                        <Command>
                          <CommandInput placeholder="Tìm dịch vụ..." />
                          <CommandEmpty>Không tìm thấy dịch vụ.</CommandEmpty>
                          <CommandGroup className="max-h-64 overflow-auto">
                            {globalDichVuList
                              .filter(dv => !dichVuOptions.some(opt => opt.dichVuId === dv.dichVuId))
                              .map((dv) => (
                                <CommandItem
                                  key={dv.dichVuId}
                                  value={dv.ten}
                                  onSelect={() => {
                                    setDichVuOptions(prev => [...prev, dv]);
                                    toggleDichVuHopDong(dv);
                                    setOpenAddDichVu(false);
                                  }}
                                >
                                  {dv.ten} - {formatCurrency(dv.donGiaMacDinh)} {dv.donVi ? `/${dv.donVi}` : ''}
                                </CommandItem>
                              ))}
                          </CommandGroup>
                        </Command>
                      </PopoverContent>
                    </Popover>
                  </div>
                </div>
              )}
            </div>

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
        <DialogContent className="sm:max-w-[800px] h-[80vh] flex flex-col">
          <DialogHeader>
            <DialogTitle>Xem trước Hợp đồng</DialogTitle>
          </DialogHeader>
          <div className="flex-1 overflow-y-auto p-4 border rounded-md bg-white text-black">
            <div className="max-w-2xl mx-auto space-y-4 font-legal text-sm leading-relaxed">
              <div className="text-center font-bold">
                CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM<br/>
                Độc lập - Tự do - Hạnh phúc<br/>
                -----------------
              </div>
              <h2 className="text-xl font-bold text-center mt-6 mb-4">HỢP ĐỒNG THUÊ PHÒNG TRỌ</h2>
              
              <p className="italic mb-6 text-justify">
                - Căn cứ Bộ Luật Dân sự số 91/2015/QH13 của Quốc hội nước Cộng hòa Xã hội Chủ nghĩa Việt Nam;<br/>
                - Căn cứ vào nhu cầu và khả năng của hai bên;
              </p>
              
              <p>Hôm nay, ngày ... tháng ... năm ..., tại địa chỉ nhà trọ, chúng tôi gồm:</p>

              <p className="font-bold uppercase mt-4">BÊN CHO THUÊ (BÊN A):</p>
              <p>Ông/Bà: <strong>Ban Quản Lý Tòa Nhà</strong></p>
              <p>Đại diện cho nhà trọ: {nhaTroList.find(t => t._id === selectedNhaTro)?.tenToaNha}</p>
              
              <p className="font-bold uppercase mt-4">BÊN THUÊ (BÊN B):</p>
              <p>Ông/Bà: <strong>{khachThueList.find(k => k._id === formData.nguoiDaiDien)?.hoTen || '[Chưa chọn]'}</strong></p>
              <p>SĐT: {khachThueList.find(k => k._id === formData.nguoiDaiDien)?.soDienThoai}</p>
              <p>CCCD: {khachThueList.find(k => k._id === formData.nguoiDaiDien)?.cccd}</p>
              
              <p className="mt-4 italic font-bold">Hai bên cùng thỏa thuận và ký kết Hợp đồng thuê phòng trọ với các điều khoản sau:</p>

              <div className="font-bold mt-4 uppercase">ĐIỀU 1: ĐỐI TƯỢNG HỢP ĐỒNG VÀ THỜI GIAN THUÊ</div>
              <p>1.1 Bên A đồng ý cho bên B thuê phòng số <strong>{phongList.find(p => p._id === formData.phong)?.maPhong}</strong> tại {nhaTroList.find(t => t._id === selectedNhaTro)?.tenToaNha}.</p>
              <p>1.2 Mục đích thuê: Để ở. Số lượng người ở tối đa theo quy định của tòa nhà.</p>
              <p>1.3 Thời hạn thuê: Từ ngày <strong>{formData.ngayBatDau}</strong> đến ngày <strong>{formData.ngayKetThuc}</strong>.</p>

              <div className="font-bold mt-6 uppercase">ĐIỀU 2: GIÁ THUÊ VÀ PHƯƠNG THỨC THANH TOÁN</div>
              <p>2.1 Giá thuê phòng: <strong>{formatCurrency(Number(formData.giaThue))}</strong> /tháng (Giá thuê này chưa bao gồm các chi phí dịch vụ khác).</p>
              <p>2.2 Phí dịch vụ:</p>
              <ul className="list-disc pl-5 mb-2 space-y-1">
                <li>Tiền điện: (Theo thỏa thuận / Dịch vụ)</li>
                <li>Tiền nước: (Theo thỏa thuận / Dịch vụ)</li>
                {formData.phiDichVu.map((phi, i) => (
                  <li key={i}>{phi.ten}: {formatCurrency(phi.gia)}</li>
                ))}
              </ul>
              <p>2.3 Tiền đặt cọc: <strong>{formatCurrency(Number(formData.tienCoc))}</strong>. Bên A sẽ hoàn trả lại số tiền cọc này cho Bên B khi chấm dứt hợp đồng và Bên B đã thanh toán đầy đủ các khoản chi phí phát sinh.</p>
              <p>2.4 Phương thức thanh toán: Thanh toán bằng tiền mặt hoặc chuyển khoản vào ngày <strong>{formData.ngayThanhToan}</strong> hàng tháng.</p>

              <div className="font-bold mt-6 uppercase">ĐIỀU 3: QUYỀN VÀ NGHĨA VỤ CỦA BÊN A</div>
              <ul className="list-disc pl-5 space-y-1">
                <li>Bàn giao phòng trọ và trang thiết bị kèm theo (nếu có) cho Bên B đúng thời gian thỏa thuận.</li>
                <li>Đảm bảo quyền sử dụng trọn vẹn, độc lập của Bên B trong thời gian thuê.</li>
                <li>Hỗ trợ Bên B trong việc đăng ký tạm trú (nếu Bên B có yêu cầu và cung cấp đủ giấy tờ).</li>
                <li>Được quyền chấm dứt hợp đồng đơn phương nếu Bên B vi phạm các điều khoản trong hợp đồng hoặc quy định của khu trọ.</li>
              </ul>

              <div className="font-bold mt-6 uppercase">ĐIỀU 4: QUYỀN VÀ NGHĨA VỤ CỦA BÊN B</div>
              <ul className="list-disc pl-5 space-y-1">
                <li>Sử dụng phòng trọ đúng mục đích, không sử dụng vào các mục đích vi phạm pháp luật.</li>
                <li>Thanh toán tiền thuê phòng và các chi phí dịch vụ đầy đủ và đúng hạn.</li>
                <li>Có trách nhiệm bảo quản tài sản, trang thiết bị do Bên A cung cấp. Nếu làm hư hỏng, mất mát phải bồi thường theo giá trị hiện tại.</li>
                <li>Không được tự ý sửa chữa, thay đổi cấu trúc phòng trọ khi chưa có sự đồng ý của Bên A.</li>
                <li>Chấp hành nghiêm chỉnh các quy định về an ninh trật tự, phòng cháy chữa cháy và quy chế của khu trọ.</li>
                <li>Không được cho thuê lại hoặc chuyển nhượng hợp đồng thuê phòng cho người khác.</li>
                <li>Nếu cho khách ở qua đêm phải báo trước và được sự đồng ý của Bên A, chịu trách nhiệm về các hành vi của khách.</li>
              </ul>

              <div className="font-bold mt-6 uppercase">ĐIỀU 5: ĐIỀU KHOẢN CHẤM DỨT HỢP ĐỒNG VÀ XỬ LÝ TIỀN CỌC</div>
              <ul className="list-disc pl-5 space-y-1">
                <li>Hợp đồng đương nhiên chấm dứt khi hết hạn. Nếu Bên B muốn gia hạn phải thông báo cho Bên A trước 15 ngày.</li>
                <li>Nếu Bên B đơn phương chấm dứt hợp đồng trước hạn, Bên B phải báo trước cho Bên A ít nhất 30 ngày và sẽ KHÔNG được hoàn lại tiền cọc.</li>
                <li>Nếu Bên A đơn phương chấm dứt hợp đồng trước hạn không do lỗi của Bên B, Bên A phải báo trước ít nhất 30 ngày và hoàn lại tiền cọc cùng một khoản bồi thường tương đương tiền cọc cho Bên B.</li>
                <li>Bên A có quyền đơn phương chấm dứt hợp đồng không cần báo trước, không hoàn cọc và yêu cầu Bên B dời đi ngay lập tức nếu Bên B vi phạm nghiêm trọng (Tàng trữ chất cấm, đánh nhau gây rối, chậm thanh toán tiền phòng quá 15 ngày...).</li>
              </ul>

              <div className="font-bold mt-6 uppercase">ĐIỀU 6: ĐIỀU KHOẢN CHUNG</div>
              <ul className="list-disc pl-5 mb-4 space-y-1">
                <li>Hai bên cam kết thực hiện đúng các điều khoản đã ghi trong hợp đồng.</li>
                <li>Những vấn đề phát sinh chưa được ghi trong hợp đồng sẽ được hai bên thỏa thuận giải quyết trên tinh thần hợp tác.</li>
                <li>Hợp đồng được lập thành 02 bản có giá trị pháp lý như nhau, mỗi bên giữ 01 bản.</li>
              </ul>

              {formData.dieuKhoan && (
                <div className="mt-6">
                  <div className="font-bold mt-6 uppercase">ĐIỀU KHOẢN BỔ SUNG (NỘI QUY)</div>
                  <div className="whitespace-pre-line ml-4 mt-2">{formData.dieuKhoan}</div>
                </div>
              )}

              <div className="mt-8 flex justify-between font-bold text-center">
                <div>
                  <p>ĐẠI DIỆN BÊN A</p>
                  <p className="font-normal italic text-sm mt-1">(Ký và ghi họ tên)</p>
                </div>
                <div>
                  <p>ĐẠI DIỆN BÊN B</p>
                  <p className="font-normal italic text-sm mt-1">(Ký và ghi họ tên)</p>
                </div>
              </div>
            </div>
          </div>
          <DialogFooter className="mt-4 gap-2">
            <Button type="button" variant="outline" onClick={() => setOpenPreviewModal(false)} disabled={submitting}>Quay lại chỉnh sửa</Button>
            <Button onClick={handleConfirmAndSave} disabled={submitting}>
              {submitting && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Xác nhận, Lưu & In Hợp đồng
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
              <Label htmlFor="cccd">CCCD / CMND</Label>
              <Input
                id="cccd"
                value={newKhachThueData.cccd}
                onChange={(e) => setNewKhachThueData(prev => ({ ...prev, cccd: e.target.value }))}
                placeholder="012345678912"
              />
            </div>
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

