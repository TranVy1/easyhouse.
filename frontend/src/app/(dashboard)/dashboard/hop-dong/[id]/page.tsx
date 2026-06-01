'use client';

import { useState, useEffect } from 'react';
import type { ReactNode } from 'react';
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
import { Textarea } from '@/components/ui/textarea';
import { Badge } from '@/components/ui/badge';
import { 
  ArrowLeft,
  FileCheck2,
  Eye,
  Save,
  Loader2,
  Plus,
  Check,
  CheckCircle2,
  ChevronsUpDown,
  LockKeyhole,
} from 'lucide-react';
import { HopDong, Phong, KhachThue } from '@/types';
import { toast } from 'sonner';
import { cn } from "@/lib/utils";
import { hopDongStatusFromDb, normalizeHopDong, normalizeKhachThue, normalizePhong } from '@/lib/domain-mappers';
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

type PhiDichVuForm = {
  dichVuId?: string;
  ten: string;
  gia: number;
  soLuong?: number;
  loaiTinhPhi?: string;
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

type ContractWorkflowMeta = HopDong & {
  previewedAt?: string;
  confirmedAt?: string;
  lockedAt?: string;
};

const contractStatusLabel: Record<string, string> = {
  nhap: 'Nháp',
  choKichHoat: 'Chờ kích hoạt',
  hoatDong: 'Hoạt động',
  hetHan: 'Hết hạn',
  daKetThuc: 'Đã kết thúc',
  daHuy: 'Đã hủy',
};

export default function ChinhSuaHopDongPage() {
  const router = useRouter();
  const params = useParams();
  const hopDongId = params.id as string;
  const { data: session } = useSession();
  const accessToken = session?.accessToken;

  const [hopDong, setHopDong] = useState<HopDong | null>(null);
  const [phongList, setPhongList] = useState<Phong[]>([]);
  const [khachThueList, setKhachThueList] = useState<KhachThue[]>([]);
  const [dichVuOptions, setDichVuOptions] = useState<DichVuOption[]>([]);
  const [globalDichVuList, setGlobalDichVuList] = useState<DichVuOption[]>([]);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [workflowSubmitting, setWorkflowSubmitting] = useState<'preview' | 'confirm' | null>(null);

  const [formData, setFormData] = useState({
    maHopDong: '',
    phong: '',
    khachThueId: [] as string[],
    nguoiDaiDien: '',
    ngayBatDau: new Date().toISOString().split('T')[0],
    ngayKetThuc: '',
    giaThue: 0,
    tienCoc: 0,
    chuKyThanhToan: 'thang' as 'thang' | 'quy' | 'nam',
    ngayThanhToan: 15,
    dieuKhoan: '',
    giaDien: 3500,
    giaNuoc: 25000,
    chiSoDienBanDau: 0,
    chiSoNuocBanDau: 0,
    phiDichVu: [] as PhiDichVuForm[],
    trangThai: 'hoatDong' as 'nhap' | 'choKichHoat' | 'hoatDong' | 'hetHan' | 'daKetThuc' | 'daHuy',
  });

  const [openPhong, setOpenPhong] = useState(false);
  const [openKhachThue, setOpenKhachThue] = useState(false);
  const [openNguoiDaiDien, setOpenNguoiDaiDien] = useState(false);
  const [openAddDichVu, setOpenAddDichVu] = useState(false);
  const [searchDichVu, setSearchDichVu] = useState("");

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

  const isUuid = (value?: string) =>
    Boolean(value && /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(value));

  const sanitizePhiDichVu = (items: PhiDichVuForm[]) =>
    items.map((item) => ({
      ...(isUuid(item.dichVuId) ? { dichVuId: item.dichVuId } : {}),
      ten: item.ten.trim(),
      gia: Number(item.gia || 0),
      soLuong: Number(item.soLuong || 1),
      loaiTinhPhi: item.loaiTinhPhi || 'FIXED',
    }));

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

  const normalizeChuKyThanhToan = (value?: string): 'thang' | 'quy' | 'nam' => {
    switch (value) {
      case 'QUARTERLY':
      case 'quy':
        return 'quy';
      case 'YEARLY':
      case 'nam':
        return 'nam';
      default:
        return 'thang';
    }
  };

  const normalizeTrangThaiHopDong = (value?: string): 'nhap' | 'choKichHoat' | 'hoatDong' | 'hetHan' | 'daKetThuc' | 'daHuy' => {
    const status = hopDongStatusFromDb(value);
    switch (status) {
      case 'choKichHoat':
      case 'hoatDong':
      case 'hetHan':
      case 'daKetThuc':
      case 'daHuy':
        return status;
      default:
        return 'nhap';
    }
  };

  const loadDichVuTheoPhong = async (phongId: string, currentPhiDichVu: PhiDichVuForm[] = []) => {
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
      
      if (currentPhiDichVu.length === 0) {
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
      }
    } catch (error) {
      console.error('Error loading contract services:', error);
      setDichVuOptions([]);
    }
  };

  useEffect(() => {
    if (hopDongId && accessToken) {
      fetchData();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [accessToken, hopDongId]);

  const fetchData = async () => {
    try {
      // Fetch hợp đồng chi tiết theo ID
      const hopDongResponse = await fetch(`/api/hop-dong/${hopDongId}`, {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      if (hopDongResponse.ok) {
        const hopDongData = await hopDongResponse.json().catch(() => ({}));
        if (hopDongData.success === false) {
          throw new Error(hopDongData.message || 'Không tìm thấy hợp đồng');
        }
        const hopDongItem = hopDongData.data ? normalizeHopDong(hopDongData.data) : null;
        if (hopDongItem) {
          setHopDong(hopDongItem);
          
          const khachThueIds = hopDongItem.khachThueId?.map((kt: string | { _id: string }) => typeof kt === 'object' ? kt._id : kt) || [];
          const nguoiDaiDienId = hopDongItem.khachThueDaiDienId ||
            (typeof hopDongItem.nguoiDaiDien === 'object' ? (hopDongItem.nguoiDaiDien as {_id: string})?._id || '' : hopDongItem.nguoiDaiDien || '');

          setFormData({
            maHopDong: hopDongItem.maHopDong || '',
            phong: typeof hopDongItem.phong === 'object' ? (hopDongItem.phong as {_id: string})?._id || '' : hopDongItem.phong || '',
            khachThueId: khachThueIds.filter((id: string) => id !== nguoiDaiDienId),
            nguoiDaiDien: nguoiDaiDienId,
            ngayBatDau: hopDongItem.ngayBatDau ? hopDongItem.ngayBatDau.toString().split('T')[0] : new Date().toISOString().split('T')[0],
            ngayKetThuc: hopDongItem.ngayKetThuc ? hopDongItem.ngayKetThuc.toString().split('T')[0] : '',
            giaThue: hopDongItem.giaThue || 0,
            tienCoc: hopDongItem.tienCoc || 0,
            chuKyThanhToan: normalizeChuKyThanhToan(hopDongItem.chuKyThanhToan),
            ngayThanhToan: hopDongItem.ngayThanhToan || 15,
            dieuKhoan: hopDongItem.dieuKhoan || '',
            giaDien: hopDongItem.giaDien || 3500,
            giaNuoc: hopDongItem.giaNuoc || 25000,
            chiSoDienBanDau: hopDongItem.chiSoDienBanDau || 0,
            chiSoNuocBanDau: hopDongItem.chiSoNuocBanDau || 0,
            phiDichVu: hopDongItem.phiDichVu || [],
            trangThai: normalizeTrangThaiHopDong(hopDongItem.trangThai),
          });
          const phongId = typeof hopDongItem.phong === 'object' ? (hopDongItem.phong as {_id: string})?._id || '' : hopDongItem.phong || '';
          if (phongId) {
            loadDichVuTheoPhong(phongId, hopDongItem.phiDichVu || []);
          }
        } else {
          toast.error('Không tìm thấy hợp đồng');
          router.push('/dashboard/hop-dong');
          return;
        }
      } else {
        toast.error('Lỗi khi tải thông tin hợp đồng');
        router.push('/dashboard/hop-dong');
        return;
      }

      // Fetch phong data
      const phongResponse = await fetch('/api/phong?page=1&limit=100', {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const phongData = await phongResponse.json().catch(() => ({}));
      if (!phongResponse.ok || phongData.success === false) {
        throw new Error(phongData.message || 'Không tải được danh sách phòng');
      }
      setPhongList(unwrapPageData<Phong>(phongData.data).map(normalizePhong));

      // Fetch khach thue data
      const khachThueResponse = await fetch('/api/khach-thue?page=1&limit=100', {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const khachThueData = await khachThueResponse.json().catch(() => ({}));
      if (!khachThueResponse.ok || khachThueData.success === false) {
        throw new Error(khachThueData.message || 'Không tải được danh sách khách thuê');
      }
      setKhachThueList(unwrapPageData<KhachThue>(khachThueData.data).map(normalizeKhachThue));

      // Fetch dich vu data
      const dichVuResponse = await fetch('/api/dich-vu?page=1&limit=100', {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const dvData = await dichVuResponse.json().catch(() => ({}));
      if (!dichVuResponse.ok || dvData.success === false) {
        toast.error(dvData.message || 'Không tải được danh sách dịch vụ');
      } else {
        setGlobalDichVuList(unwrapPageData<ApiDichVu>(dvData.data).map((dv: ApiDichVu) => ({
          dichVuId: String(dv._id ?? dv.id ?? ''),
          ten: dv.tenDichVu ?? dv.ten ?? '',
          loaiTinhPhi: dv.loaiTinhPhi,
          donVi: dv.donVi,
          donGiaMacDinh: Number(dv.donGiaMacDinh || 0),
          batBuoc: dv.batBuoc,
        })).filter((dv: DichVuOption) => dv.dichVuId && dv.ten));
      }
    } catch (error) {
      console.error('Error fetching data:', error);
      toast.error(error instanceof Error ? error.message : 'Có lỗi xảy ra khi tải dữ liệu');
    } finally {
      setLoading(false);
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
      loadDichVuTheoPhong(phongId, []);
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

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (submitting) return;
    
    const validationError = validateContractForm();
    if (validationError) {
      toast.error(validationError);
      return;
    }

    setSubmitting(true);

    try {
      const thanhVienIds = Array.from(new Set([formData.nguoiDaiDien, ...formData.khachThueId].filter(Boolean)));
      const response = await fetch(`/api/hop-dong/${hopDongId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify({
          ...formData,
          nguoiDaiDien: formData.nguoiDaiDien,
          khachThueId: thanhVienIds,
          khachThueIds: thanhVienIds,
          ngayBatDau: ensureISODate(formData.ngayBatDau),
          ngayKetThuc: ensureISODate(formData.ngayKetThuc),
          phiDichVu: sanitizePhiDichVu(formData.phiDichVu),
        }),
      });

      const result = await response.json().catch(() => ({}));
      if (response.ok && result.success) {
        // Xóa cache để force refresh data
        sessionStorage.removeItem('hop-dong-data');
        toast.success(result.message || 'Đã cập nhật hợp đồng thành công');
        // Sử dụng replace để không tạo history entry mới
        // và refresh để cập nhật dữ liệu server-side
        router.replace('/dashboard/hop-dong');
        router.refresh();
      } else {
        toast.error(result.message || 'Có lỗi xảy ra');
      }
    } catch (error) {
      console.error('Error submitting form:', error);
      toast.error('Có lỗi xảy ra khi lưu hợp đồng');
    } finally {
      setSubmitting(false);
    }
  };

  const runContractWorkflow = async (action: 'preview' | 'confirm') => {
    if (workflowSubmitting || submitting) return;
    setWorkflowSubmitting(action);
    try {
      const response = await fetch(`/api/hop-dong/${hopDongId}/${action}`, {
        method: 'POST',
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      });
      const result = await response.json().catch(() => ({}));
      if (!response.ok || !result.success) {
        toast.error(result.message || 'Có lỗi xảy ra khi xử lý hợp đồng');
        return;
      }

      const updated = result.data ? normalizeHopDong(result.data) : null;
      if (updated) {
        setHopDong(updated);
        setFormData(prev => ({
          ...prev,
          dieuKhoan: updated.dieuKhoan || prev.dieuKhoan,
          trangThai: normalizeTrangThaiHopDong(updated.trangThai),
        }));
      }
      sessionStorage.removeItem('hop-dong-data');
      toast.success(result.message || (action === 'preview' ? 'Đã tạo bản xem trước hợp đồng' : 'Đã xác nhận hợp đồng'));
      if (action === 'confirm') {
        router.refresh();
      }
    } catch (error) {
      console.error(`Error running contract ${action}:`, error);
      toast.error('Có lỗi xảy ra khi xử lý hợp đồng');
    } finally {
      setWorkflowSubmitting(null);
    }
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

  if (!hopDong) {
    return (
      <div className="space-y-6">
        <div className="flex items-center gap-4">
          <Button 
            variant="outline" 
            size="icon"
            onClick={() => router.push('/dashboard/hop-dong')}
          >
            <ArrowLeft className="h-4 w-4" />
          </Button>
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Không tìm thấy hợp đồng</h1>
          </div>
        </div>
      </div>
    );
  }

  const workflowMeta = hopDong as ContractWorkflowMeta;
  const isLocked = Boolean(workflowMeta.lockedAt);
  const isPreviewed = Boolean(workflowMeta.previewedAt || formData.dieuKhoan);
  const isConfirmed = Boolean(workflowMeta.confirmedAt || formData.trangThai === 'hoatDong');

  return (
    <div className="space-y-4 md:space-y-6">
      {/* Header */}
      <div className="flex flex-col gap-4 rounded-lg border bg-card p-4 shadow-sm md:flex-row md:items-center md:justify-between md:p-5">
        <div className="flex items-center gap-3 md:gap-4">
        <Button 
          variant="outline" 
          size="sm"
          onClick={() => router.push('/dashboard/hop-dong')}
        >
            <ArrowLeft className="h-4 w-4" />
          </Button>
          <div>
            <div className="mb-1 flex items-center gap-2">
              <Badge variant="outline">{contractStatusLabel[formData.trangThai] || formData.trangThai}</Badge>
              {isLocked && (
                <Badge variant="outline" className="border-blue-200 bg-blue-50 text-blue-700">
                  <LockKeyhole className="mr-1 h-3 w-3" />
                  Đã khóa
                </Badge>
              )}
            </div>
            <h1 className="text-2xl font-semibold tracking-normal text-foreground md:text-3xl">Hợp đồng {hopDong.maHopDong}</h1>
            <p className="text-sm text-muted-foreground">Xem trước, xác nhận và quản lý dữ liệu hợp đồng.</p>
          </div>
        </div>
        <div className="text-left text-sm md:text-right">
          <div className="text-muted-foreground">Phòng</div>
          <div className="font-medium">{phongList.find((phong) => phong._id === formData.phong)?.maPhong || '-'}</div>
        </div>
      </div>

      <Card className="py-0">
        <CardContent className="p-4">
          <div className="grid gap-3 md:grid-cols-3">
            <WorkflowStep
              active
              done={isPreviewed}
              icon={<Eye className="h-4 w-4" />}
              title="Xem trước"
              description="Sinh nội dung hợp đồng để kiểm tra trước khi ký."
            />
            <WorkflowStep
              active={isPreviewed}
              done={isConfirmed}
              icon={<FileCheck2 className="h-4 w-4" />}
              title="Xác nhận"
              description="Khóa dữ liệu, chuyển phòng sang đang thuê."
            />
            <WorkflowStep
              active={isConfirmed}
              done={isLocked}
              icon={<CheckCircle2 className="h-4 w-4" />}
              title="Lịch thanh toán"
              description="Tạo lịch thu tiền theo chu kỳ hợp đồng."
            />
          </div>
          {isLocked && (
            <div className="mt-4 rounded-md border border-blue-200 bg-blue-50 p-3 text-sm text-blue-800">
              Hợp đồng đã được xác nhận và khóa. Các thay đổi trực tiếp nên được xử lý bằng phụ lục hoặc quy trình điều chỉnh hợp đồng.
            </div>
          )}
        </CardContent>
      </Card>

      {/* Form */}
      <Card>
        <CardHeader className="p-4 md:p-6">
          <CardTitle className="text-lg md:text-xl">Thông tin hợp đồng</CardTitle>
          <CardDescription className="text-xs md:text-sm">
            Cập nhật thông tin hợp đồng {hopDong.maHopDong}
          </CardDescription>
        </CardHeader>
        <CardContent className="p-4 md:p-6">
          <form onSubmit={handleSubmit} className="space-y-4 md:space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-3 md:gap-4">
              <div className="space-y-2">
                <Label htmlFor="maHopDong" className="text-xs md:text-sm">Mã hợp đồng</Label>
                <Input
                  id="maHopDong"
                  value={formData.maHopDong}
                  onChange={(e) => setFormData(prev => ({ ...prev, maHopDong: e.target.value.toUpperCase() }))}
                  placeholder="HD001"
                  required
                  className="text-sm"
                />
              </div>
              
              <div className="space-y-2">
                <Label className="text-xs md:text-sm">Phòng *</Label>
                <Popover open={openPhong} onOpenChange={setOpenPhong}>
                  <PopoverTrigger asChild>
                    <Button
                      variant="outline"
                      role="combobox"
                      aria-expanded={openPhong}
                      className="w-full justify-between text-sm"
                      size="sm"
                    >
                      {formData.phong
                        ? phongList.find((phong) => phong._id === formData.phong)?.maPhong
                        : "Chọn phòng..."}
                      <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                    </Button>
                  </PopoverTrigger>
                  <PopoverContent className="w-[90vw] md:w-[400px] p-0">
                    <Command>
                      <CommandInput placeholder="Tìm kiếm phòng..." />
                      <CommandEmpty>Không tìm thấy phòng.</CommandEmpty>
                      <CommandGroup className="max-h-64 overflow-auto">
                        {phongList.map((phong) => (
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

              <div className="space-y-2">
                <Label className="text-xs md:text-sm">Người đại diện</Label>
                <Popover open={openNguoiDaiDien} onOpenChange={setOpenNguoiDaiDien}>
                  <PopoverTrigger asChild>
                    <Button
                      variant="outline"
                      role="combobox"
                      aria-expanded={openNguoiDaiDien}
                      className="w-full justify-between text-sm"
                      size="sm"
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
                              value={khachThue.hoTen}
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
                              {khachThue.hoTen}
                            </CommandItem>
                          ))}
                      </CommandGroup>
                    </Command>
                  </PopoverContent>
                </Popover>
              </div>
            </div>

            <div className="space-y-2">
              <div className="rounded-md border border-blue-200 bg-blue-50 px-3 py-2 text-xs text-blue-800">
                Người đại diện là người đứng tên hợp đồng. Danh sách bên dưới chỉ là bạn cùng phòng và được lưu vào thành viên hợp đồng.
              </div>
              <Label className="text-xs md:text-sm">Bạn cùng phòng / thành viên ở cùng</Label>
              <Popover open={openKhachThue} onOpenChange={setOpenKhachThue}>
                <PopoverTrigger asChild>
                  <Button
                    variant="outline"
                    role="combobox"
                    aria-expanded={openKhachThue}
                    className="w-full justify-between min-h-10 h-auto text-sm"
                    size="sm"
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
                          value={khachThue.hoTen}
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

            <div className="grid grid-cols-1 md:grid-cols-2 gap-3 md:gap-4">
              <div className="space-y-2">
                <Label htmlFor="ngayBatDau" className="text-xs md:text-sm">Ngày bắt đầu</Label>
                <Input
                  id="ngayBatDau"
                  type="date"
                  value={formData.ngayBatDau}
                  onChange={(e) => setFormData(prev => ({ ...prev, ngayBatDau: e.target.value }))}
                  required
                  className="text-sm"
                />
              </div>
              
              <div className="space-y-2">
                <Label htmlFor="ngayKetThuc" className="text-xs md:text-sm">Ngày kết thúc</Label>
                <Input
                  id="ngayKetThuc"
                  type="date"
                  value={formData.ngayKetThuc}
                  onChange={(e) => setFormData(prev => ({ ...prev, ngayKetThuc: e.target.value }))}
                  required
                  className="text-sm"
                />
                <div className="flex flex-wrap gap-2 mt-2">
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    onClick={() => setQuickDuration(3)}
                    className="text-xs"
                  >
                    3 tháng
                  </Button>
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    onClick={() => setQuickDuration(6)}
                    className="text-xs"
                  >
                    6 tháng
                  </Button>
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    onClick={() => setQuickDuration(12)}
                    className="text-xs"
                  >
                    1 năm
                  </Button>
                </div>
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-3 md:gap-4">
              <div className="space-y-2">
                <Label htmlFor="giaThue" className="text-xs md:text-sm">Giá thuê (VNĐ/tháng)</Label>
                <Input
                  id="giaThue"
                  type="number"
                  min="0"
                  value={formData.giaThue}
                  onChange={(e) => setFormData(prev => ({ ...prev, giaThue: parseInt(e.target.value) || 0 }))}
                  required
                  className="text-sm"
                />
                <span className="text-[10px] md:text-xs text-muted-foreground">
                  {formatCurrency(formData.giaThue)}
                </span>
              </div>
              
              <div className="space-y-2">
                <Label htmlFor="tienCoc" className="text-xs md:text-sm">Tiền cọc (VNĐ)</Label>
                <Input
                  id="tienCoc"
                  type="number"
                  min="0"
                  value={formData.tienCoc}
                  onChange={(e) => setFormData(prev => ({ ...prev, tienCoc: parseInt(e.target.value) || 0 }))}
                  required
                  className="text-sm"
                />
                <span className="text-[10px] md:text-xs text-muted-foreground">
                  {formatCurrency(formData.tienCoc)}
                </span>
              </div>
              
              <div className="space-y-2">
                <Label htmlFor="ngayThanhToan" className="text-xs md:text-sm">Ngày thanh toán</Label>
                <Input
                  id="ngayThanhToan"
                  type="number"
                  min="1"
                  max="31"
                  value={formData.ngayThanhToan}
                  onChange={(e) => setFormData(prev => ({ ...prev, ngayThanhToan: parseInt(e.target.value) || 1 }))}
                  required
                  className="text-sm"
                />
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3 md:gap-4">
              <div className="space-y-2">
                <Label htmlFor="chuKyThanhToan" className="text-xs md:text-sm">Chu kỳ thanh toán</Label>
                <Select value={formData.chuKyThanhToan} onValueChange={(value) => setFormData(prev => ({ ...prev, chuKyThanhToan: value as 'thang' | 'quy' | 'nam' }))}>
                  <SelectTrigger className="text-sm" size="sm">
                    <SelectValue placeholder="Chọn chu kỳ" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="thang" className="text-sm">Tháng</SelectItem>
                    <SelectItem value="quy" className="text-sm">Quý</SelectItem>
                    <SelectItem value="nam" className="text-sm">Năm</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              
              <div className="space-y-2">
                <Label htmlFor="giaDien" className="text-xs md:text-sm">Giá điện (VNĐ/kWh)</Label>
                <Input
                  id="giaDien"
                  type="number"
                  min="0"
                  value={formData.giaDien}
                  onChange={(e) => setFormData(prev => ({ ...prev, giaDien: parseInt(e.target.value) || 0 }))}
                  required
                  className="text-sm"
                />
                <span className="text-[10px] md:text-xs text-muted-foreground">
                  {formatCurrency(formData.giaDien)}
                </span>
              </div>
              
              <div className="space-y-2">
                <Label htmlFor="giaNuoc" className="text-xs md:text-sm">Giá nước (VNĐ/m³)</Label>
                <Input
                  id="giaNuoc"
                  type="number"
                  min="0"
                  value={formData.giaNuoc}
                  onChange={(e) => setFormData(prev => ({ ...prev, giaNuoc: parseInt(e.target.value) || 0 }))}
                  required
                  className="text-sm"
                />
                <span className="text-[10px] md:text-xs text-muted-foreground">
                  {formatCurrency(formData.giaNuoc)}
                </span>
              </div>
              
              <div className="space-y-2">
                <Label htmlFor="trangThai" className="text-xs md:text-sm">Trạng thái</Label>
                <Select value={formData.trangThai} onValueChange={(value) => setFormData(prev => ({ ...prev, trangThai: value as 'nhap' | 'choKichHoat' | 'hoatDong' | 'hetHan' | 'daKetThuc' | 'daHuy' }))}>
                  <SelectTrigger className="text-sm" size="sm">
                    <SelectValue placeholder="Chọn trạng thái" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="nhap" className="text-sm">Nháp</SelectItem>
                    <SelectItem value="choKichHoat" className="text-sm">Chờ kích hoạt</SelectItem>
                    <SelectItem value="hoatDong" className="text-sm">Hoạt động</SelectItem>
                    <SelectItem value="hetHan" className="text-sm">Hết hạn</SelectItem>
                    <SelectItem value="daKetThuc" className="text-sm">Đã kết thúc</SelectItem>
                    <SelectItem value="daHuy" className="text-sm">Đã hủy</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-3 md:gap-4">
              <div className="space-y-2">
                <Label htmlFor="chiSoDienBanDau" className="text-xs md:text-sm">Chỉ số điện ban đầu (kWh)</Label>
                <Input
                  id="chiSoDienBanDau"
                  type="number"
                  min="0"
                  value={formData.chiSoDienBanDau}
                  onChange={(e) => setFormData(prev => ({ ...prev, chiSoDienBanDau: parseInt(e.target.value) || 0 }))}
                  placeholder="Nhập chỉ số điện ban đầu"
                  required
                  className="text-sm"
                />
                <span className="text-[10px] md:text-xs text-muted-foreground">
                  Chỉ số đồng hồ điện khi bắt đầu hợp đồng
                </span>
              </div>
              
              <div className="space-y-2">
                <Label htmlFor="chiSoNuocBanDau" className="text-xs md:text-sm">Chỉ số nước ban đầu (m³)</Label>
                <Input
                  id="chiSoNuocBanDau"
                  type="number"
                  min="0"
                  value={formData.chiSoNuocBanDau}
                  onChange={(e) => setFormData(prev => ({ ...prev, chiSoNuocBanDau: parseInt(e.target.value) || 0 }))}
                  placeholder="Nhập chỉ số nước ban đầu"
                  required
                  className="text-sm"
                />
                <span className="text-[10px] md:text-xs text-muted-foreground">
                  Chỉ số đồng hồ nước khi bắt đầu hợp đồng
                </span>
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="dieuKhoan" className="text-xs md:text-sm">Điều khoản</Label>
              <Textarea
                id="dieuKhoan"
                value={formData.dieuKhoan}
                onChange={(e) => setFormData(prev => ({ ...prev, dieuKhoan: e.target.value }))}
                rows={8}
                required
                className="resize-none text-sm"
              />
            </div>

            <div className="space-y-2">
              <Label>Dịch vụ áp dụng cho hợp đồng</Label>
              {!formData.phong ? (
                <p className="text-sm text-muted-foreground">Chọn phòng trước để tải danh sách dịch vụ đang áp dụng cho tòa nhà/phòng.</p>
              ) : dichVuOptions.length === 0 ? (
                <p className="text-sm text-muted-foreground">Phòng này chưa có dịch vụ nào trong cấu hình giá.</p>
              ) : (
                <div className="space-y-4">
                  <div className="space-y-2">
                    {dichVuOptions.map((option) => {
                      const selected = formData.phiDichVu.find(phi => phi.dichVuId === option.dichVuId);
                      return (
                        <div key={option.dichVuId} className="grid grid-cols-1 md:grid-cols-[1fr_160px_120px_auto] gap-2 rounded border p-3">
                          <button type="button" onClick={() => toggleDichVuHopDong(option)} className="flex items-center gap-2 text-left">
                            <span className={cn("flex h-4 w-4 items-center justify-center rounded-sm border", selected ? "bg-primary text-primary-foreground" : "bg-background")}>
                              {selected && <Check className="h-3 w-3" />}
                            </span>
                            <span className="text-sm font-medium">{option.ten}</span>
                            {option.batBuoc && <Badge variant="outline">Bắt buộc</Badge>}
                          </button>
                          <Input type="number" min="0" value={selected?.gia ?? option.donGiaMacDinh} disabled={!selected} onChange={(e) => updateDichVuHopDong(option.dichVuId, 'gia', Number(e.target.value) || 0)} />
                          <Input type="number" min="0" step="0.1" value={selected?.soLuong ?? 1} disabled={!selected} onChange={(e) => updateDichVuHopDong(option.dichVuId, 'soLuong', Number(e.target.value) || 0)} />
                          <div className="text-sm text-muted-foreground md:text-right">
                            {selected ? formatCurrency((selected.gia || 0) * (selected.soLuong || 1)) : formatCurrency(option.donGiaMacDinh)}
                          </div>
                        </div>
                      );
                    })}
                  </div>

                  <div className="mt-4 border-t pt-4">
                    <Label className="text-xs md:text-sm mb-2 block">Thêm dịch vụ khác</Label>
                    <Popover open={openAddDichVu} onOpenChange={setOpenAddDichVu}>
                      <PopoverTrigger asChild>
                        <Button variant="outline" role="combobox" aria-expanded={openAddDichVu} className="w-full justify-between text-sm">
                          Chọn thêm dịch vụ từ danh sách...
                          <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                        </Button>
                      </PopoverTrigger>
                      <PopoverContent className="w-[90vw] md:w-full p-0">
                        <Command>
                          <CommandInput placeholder="Tìm dịch vụ..." value={searchDichVu} onValueChange={setSearchDichVu} />
                          <CommandEmpty>
                            <div className="flex flex-col items-center justify-center py-4 space-y-3">
                              <p className="text-sm text-muted-foreground">Không tìm thấy dịch vụ &quot;{searchDichVu}&quot;.</p>
                              {searchDichVu.trim() && (
                                <Button 
                                  type="button" 
                                  variant="secondary" 
                                  size="sm" 
                                  onClick={() => {
                                    const newDv: DichVuOption = {
                                      dichVuId: `new-${Date.now()}`,
                                      ten: searchDichVu.trim(),
                                      donGiaMacDinh: 0,
                                      loaiTinhPhi: 'FIXED'
                                    };
                                    setDichVuOptions(prev => [...prev, newDv]);
                                    toggleDichVuHopDong(newDv);
                                    setSearchDichVu("");
                                    setOpenAddDichVu(false);
                                  }}
                                >
                                  <Plus className="mr-2 h-4 w-4" /> Tạo nhanh dịch vụ này
                                </Button>
                              )}
                            </div>
                          </CommandEmpty>
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

            <div className="rounded-md border border-amber-200 bg-amber-50 p-3 text-sm text-amber-900">
              Khi bấm xác nhận, hệ thống sẽ khóa hợp đồng, cập nhật phòng sang đang thuê và tạo lịch thanh toán. Hãy dùng xem trước trước khi xác nhận.
            </div>

            <div className="flex flex-col sm:flex-row justify-end gap-2 md:gap-3 pt-4 border-t">
              <Button
                type="button"
                variant="outline"
                size="sm"
                onClick={() => runContractWorkflow('preview')}
                disabled={submitting || Boolean(workflowSubmitting) || isLocked}
                className="w-full sm:w-auto sm:min-w-[120px]"
              >
                {workflowSubmitting === 'preview' ? (
                  <Loader2 className="h-4 w-4 mr-2 animate-spin" />
                ) : (
                  <Eye className="h-4 w-4 mr-2" />
                )}
                Xem trước
              </Button>
              <Button
                type="button"
                variant="outline"
                size="sm"
                onClick={() => runContractWorkflow('confirm')}
                disabled={submitting || Boolean(workflowSubmitting) || isLocked}
                className="w-full sm:w-auto sm:min-w-[120px]"
              >
                {workflowSubmitting === 'confirm' ? (
                  <Loader2 className="h-4 w-4 mr-2 animate-spin" />
                ) : (
                  <FileCheck2 className="h-4 w-4 mr-2" />
                )}
                Xác nhận
              </Button>
              <Button 
                type="button" 
                variant="outline"
                size="sm"
                onClick={() => router.push('/dashboard/hop-dong')}
                disabled={submitting}
                className="w-full sm:w-auto sm:min-w-[80px]"
              >
                Hủy
              </Button>
              <Button 
                type="submit"
                size="sm"
                disabled={submitting || isLocked}
                className="w-full sm:w-auto sm:min-w-[120px]"
              >
                {submitting ? (
                  <>
                    <Loader2 className="h-4 w-4 mr-2 animate-spin" />
                    Đang cập nhật...
                  </>
                ) : (
                  <>
                    <Save className="h-4 w-4 mr-2" />
                    {isLocked ? 'Hợp đồng đã khóa' : 'Cập nhật hợp đồng'}
                  </>
                )}
              </Button>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}

function WorkflowStep({
  title,
  description,
  icon,
  active,
  done,
}: {
  title: string;
  description: string;
  icon: ReactNode;
  active?: boolean;
  done?: boolean;
}) {
  return (
    <div
      className={cn(
        'rounded-lg border p-3',
        done && 'border-emerald-200 bg-emerald-50',
        !done && active && 'border-blue-200 bg-blue-50',
        !done && !active && 'bg-muted/30 text-muted-foreground'
      )}
    >
      <div className="flex items-start gap-3">
        <div
          className={cn(
            'rounded-md border bg-background p-2',
            done && 'border-emerald-200 text-emerald-700',
            !done && active && 'border-blue-200 text-blue-700'
          )}
        >
          {icon}
        </div>
        <div>
          <div className="text-sm font-semibold">{title}</div>
          <div className="mt-1 text-xs text-muted-foreground">{description}</div>
        </div>
      </div>
    </div>
  );
}

