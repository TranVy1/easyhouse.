'use client';

import { useState, useEffect } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { getSession, useSession } from 'next-auth/react';
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
  Plus
} from 'lucide-react';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { Phong, KhachThue, ToaNha } from '@/types';
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

export default function ThemMoiHopDongPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const nhaTroId = searchParams.get('nhaTroId');
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
    return unwrapPageData<any>(json.data);
  };

  const { data: nhaTroListData } = useSWR(accessToken ? '/api/toa-nha?page=1&limit=100' : null, fetcher);
  const { data: globalDichVuListData } = useSWR(accessToken ? '/api/dich-vu?page=1&limit=100' : null, fetcher);
  
  const nhaTroList = (nhaTroListData || []).map(normalizeToaNha);
  const globalDichVuList = (globalDichVuListData || []).map((dv: any) => ({
    dichVuId: String(dv._id ?? dv.id ?? ''),
    ten: dv.tenDichVu ?? dv.ten ?? '',
    loaiTinhPhi: dv.loaiTinhPhi,
    donVi: dv.donVi,
    donGiaMacDinh: Number(dv.donGiaMacDinh || 0),
    batBuoc: dv.batBuoc,
  }));

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
    phong: '',
    khachThueId: [] as string[],
    nguoiDaiDien: '',
    ngayBatDau: new Date().toISOString().split('T')[0],
    ngayKetThuc: '',
    giaThue: 0 as number | string,
    tienCoc: 0 as number | string,
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
      const response = await fetch('/api/hop-dong', {
        method: 'POST',
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
          phiDichVu: formData.phiDichVu.map((phi: any) => ({
             ...phi,
             gia: Number(phi.gia || 0)
          })),
        }),
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
    <div className="space-y-4 md:space-y-6">
      {/* Header */}
      <div className="flex items-center gap-3 md:gap-4">
        <Button
          variant="outline"
          size="sm"
          onClick={() => router.push('/dashboard/hop-dong')}
        >
          <ArrowLeft className="h-4 w-4" />
        </Button>
        <div>
          <h1 className="text-xl md:text-2xl lg:text-3xl font-bold text-gray-900">Xem trước hợp đồng</h1>
          <p className="text-xs md:text-sm text-gray-600">Nhập thông tin hợp đồng mới</p>
        </div>
      </div>

      {/* Form */}
      <Card>
        <CardHeader className="p-4 md:p-6">
          <CardTitle className="text-lg md:text-xl">Thông tin hợp đồng</CardTitle>
          <CardDescription className="text-xs md:text-sm">
            Điền đầy đủ thông tin để tạo hợp đồng mới
          </CardDescription>
        </CardHeader>
        <CardContent className="p-4 md:p-6">
          <form onSubmit={handleSubmit} className="space-y-4 md:space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-3 md:gap-4">
              <div className="space-y-2">
                <Label className="text-xs md:text-sm">Nhà trọ *</Label>
                <Popover open={openNhaTro} onOpenChange={setOpenNhaTro}>
                  <PopoverTrigger asChild>
                    <Button
                      variant="outline"
                      role="combobox"
                      aria-expanded={openNhaTro}
                      className="w-full justify-between text-sm"
                      size="sm"
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

            <div className="space-y-2">
              <div className="rounded-md border border-blue-200 bg-blue-50 px-3 py-2 text-xs text-blue-800">
                Chọn người đại diện đứng tên hợp đồng trước. Danh sách bên dưới chỉ dùng để thêm bạn cùng phòng, không thay thế người đại diện.
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
                  onChange={(e) => setFormData(prev => ({ ...prev, giaThue: e.target.value === '' ? '' : parseInt(e.target.value) || 0 }))}
                  required
                  className="text-sm"
                />
                <span className="text-[10px] md:text-xs text-muted-foreground">
                  {formatCurrency(Number(formData.giaThue))}
                </span>
              </div>

              <div className="space-y-2">
                <Label htmlFor="tienCoc" className="text-xs md:text-sm">Tiền cọc (VNĐ)</Label>
                <Input
                  id="tienCoc"
                  type="number"
                  min="0"
                  value={formData.tienCoc}
                  onChange={(e) => setFormData(prev => ({ ...prev, tienCoc: e.target.value === '' ? '' : parseInt(e.target.value) || 0 }))}
                  required
                  className="text-sm"
                />
                <span className="text-[10px] md:text-xs text-muted-foreground">
                  {formatCurrency(Number(formData.tienCoc))}
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
                  onChange={(e) => setFormData(prev => ({ ...prev, ngayThanhToan: e.target.value === '' ? '' : parseInt(e.target.value) || 1 }))}
                  required
                  className="text-sm"
                />
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3 md:gap-4">
              <div className="space-y-2">
                <Label htmlFor="chuKyThanhToan">Chu kỳ thanh toán</Label>
                <Select value={formData.chuKyThanhToan} onValueChange={(value) => setFormData(prev => ({ ...prev, chuKyThanhToan: value as 'thang' | 'quy' | 'nam' }))}>
                  <SelectTrigger>
                    <SelectValue placeholder="Chọn chu kỳ" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="thang">Tháng</SelectItem>
                    <SelectItem value="quy">Quý</SelectItem>
                    <SelectItem value="nam">Năm</SelectItem>
                  </SelectContent>
                </Select>
              </div>



              <div className="space-y-2">
                <Label htmlFor="trangThai">Trạng thái</Label>
                <Select value={formData.trangThai} onValueChange={(value) => setFormData(prev => ({ ...prev, trangThai: value as 'nhap' | 'choKichHoat' | 'hoatDong' | 'hetHan' | 'daKetThuc' | 'daHuy' }))}>
                  <SelectTrigger>
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

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="chiSoDienBanDau">Chỉ số điện ban đầu (kWh)</Label>
                <Input
                  id="chiSoDienBanDau"
                  type="number"
                  min="0"
                  value={formData.chiSoDienBanDau}
                  onChange={(e) => setFormData(prev => ({ ...prev, chiSoDienBanDau: e.target.value === '' ? '' : parseInt(e.target.value) || 0 }))}
                  placeholder="Nhập chỉ số điện ban đầu"
                  required
                />
                <span className="text-xs text-muted-foreground">
                  Chỉ số đồng hồ điện khi bắt đầu hợp đồng
                </span>
              </div>

              <div className="space-y-2">
                <Label htmlFor="chiSoNuocBanDau">Chỉ số nước ban đầu (m³)</Label>
                <Input
                  id="chiSoNuocBanDau"
                  type="number"
                  min="0"
                  value={formData.chiSoNuocBanDau}
                  onChange={(e) => setFormData(prev => ({ ...prev, chiSoNuocBanDau: e.target.value === '' ? '' : parseInt(e.target.value) || 0 }))}
                  placeholder="Nhập chỉ số nước ban đầu"
                  required
                />
                <span className="text-xs text-muted-foreground">
                  Chỉ số đồng hồ nước khi bắt đầu hợp đồng
                </span>
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="dieuKhoan">Điều khoản</Label>
              <Textarea
                id="dieuKhoan"
                value={formData.dieuKhoan}
                onChange={(e) => setFormData(prev => ({ ...prev, dieuKhoan: e.target.value }))}
                rows={8}
                required
                className="resize-none"
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="ghiChu">Ghi chú bàn giao / nội bộ</Label>
              <Textarea
                id="ghiChu"
                value={formData.ghiChu}
                onChange={(e) => setFormData(prev => ({ ...prev, ghiChu: e.target.value }))}
                placeholder="Khách không sử dụng Tủ lạnh, đã dọn ra ngoài..."
                rows={3}
                className="resize-none"
              />
            </div>

            {formData.phong && (
              <div className="space-y-2 pb-4">
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

            <div className="space-y-2">
              <Label>Dịch vụ áp dụng cho hợp đồng</Label>
              {!formData.phong ? (
                <p className="text-sm text-muted-foreground">Chọn phòng trước để tải danh sách dịch vụ đang áp dụng cho tòa nhà/phòng.</p>
              ) : dichVuOptions.length === 0 ? (
                <p className="text-sm text-muted-foreground">Phòng này chưa có dịch vụ nào trong cấu hình giá.</p>
              ) : (
                <div className="space-y-4">
                  <div className="rounded-lg border overflow-hidden">
                    {/* Header Desktop */}
                    <div className="hidden md:grid grid-cols-[1fr_100px_120px_120px] gap-4 bg-muted/50 p-3 px-4 text-sm font-medium text-muted-foreground border-b">
                      <div>Tên dịch vụ</div>
                      <div>Đơn giá</div>
                      <div>Số lượng</div>
                      <div className="text-right">Thành tiền</div>
                    </div>

                    <div className="divide-y">
                      {dichVuOptions.map((option) => {
                        const selected = formData.phiDichVu.find(phi => phi.dichVuId === option.dichVuId);
                        return (
                          <div key={option.dichVuId} className={cn("grid grid-cols-1 md:grid-cols-[1fr_160px_120px_120px] items-center gap-3 md:gap-4 p-4 transition-colors", selected ? "bg-primary/5" : "bg-card hover:bg-muted/30")}>
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
                                  className={cn("pr-7 h-9 bg-background", !selected && "opacity-50")}
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
                                className={cn("h-9 bg-background", !selected && "opacity-50")}
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

            <div className="flex flex-col sm:flex-row justify-end gap-2 md:gap-3 pt-4 border-t">
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
                disabled={submitting}
                className="w-full sm:w-auto sm:min-w-[120px]"
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
            <div className="max-w-2xl mx-auto space-y-4 font-serif text-sm">
              <div className="text-center font-bold">
                CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM<br/>
                Độc lập - Tự do - Hạnh phúc
              </div>
              <h2 className="text-xl font-bold text-center mt-6 mb-4">HỢP ĐỒNG THUÊ PHÒNG TRỌ</h2>
              <p className="font-bold">1. Đại diện bên cho thuê (Bên A):</p>
              <p>Ban Quản Lý Tòa Nhà</p>
              
              <p className="font-bold mt-4">2. Bên thuê phòng trọ (Bên B):</p>
              <p>Ông/Bà: {khachThueList.find(k => k._id === formData.nguoiDaiDien)?.hoTen || '[Chưa chọn]'}</p>
              <p>SĐT: {khachThueList.find(k => k._id === formData.nguoiDaiDien)?.soDienThoai}</p>
              <p>CCCD: {khachThueList.find(k => k._id === formData.nguoiDaiDien)?.cccd}</p>
              
              <div className="font-bold mt-4">3. Điều khoản thỏa thuận:</div>
              <p>- Cho thuê phòng: <strong>{phongList.find(p => p._id === formData.phong)?.maPhong}</strong> tại {nhaTroList.find(t => t._id === selectedNhaTro)?.tenToaNha}</p>
              <p>- Giá thuê: <strong>{formatCurrency(Number(formData.giaThue))}</strong> /tháng (Thanh toán vào ngày {formData.ngayThanhToan} hàng tháng)</p>
              <p>- Tiền đặt cọc: <strong>{formatCurrency(Number(formData.tienCoc))}</strong></p>
              <p>- Tiền điện: (Theo thỏa thuận / Dịch vụ)</p>
              <p>- Tiền nước: (Theo thỏa thuận / Dịch vụ)</p>
              {formData.phiDichVu.length > 0 && (
                <div>
                  <p>- Phí dịch vụ bổ sung:</p>
                  <ul className="list-disc pl-5">
                    {formData.phiDichVu.map((phi, i) => (
                      <li key={i}>{phi.ten}: {formatCurrency(phi.gia)}</li>
                    ))}
                  </ul>
                </div>
              )}
              <p>- Thời hạn: Từ ngày {formData.ngayBatDau} đến {formData.ngayKetThuc}</p>
              <div className="mt-6">
                <h3 className="font-bold text-lg mb-2 text-center">TRÁCH NHIỆM CỦA CÁC BÊN</h3>
                
                <p className="font-bold mt-3">* Trách nhiệm của bên A:</p>
                <p>- Tạo mọi điều kiện thuận lợi để bên B thực hiện theo hợp đồng.</p>
                <p>- Cung cấp nguồn điện, nước đầy đủ cho bên B sử dụng.</p>

                <p className="font-bold mt-3">* Trách nhiệm của bên B:</p>
                <p>- Thanh toán đầy đủ tiền theo đúng thỏa thuận.</p>
                <p>- Bảo quản các trang thiết bị và cơ sở vật chất của bên A trang bị cho ban đầu (làm hỏng phải sửa, mất phải đền).</p>
                <p>- Không được tự ý sửa chữa, cải tạo cơ sở vật chất khi chưa được sự đồng ý của bên A.</p>
                <p>- Luôn có ý thức giữ gìn vệ sinh trong và ngoài khu vực phòng trọ.</p>
                <p>- Bên B phải chấp hành mọi quy định của pháp luật Nhà nước và quy định của địa phương.</p>
                <p>- Nếu bên B cho khách ở qua đêm thì phải báo trước và được sự đồng ý của bên A, đồng thời phải chịu trách nhiệm về các hành vi vi phạm pháp luật của khách trong thời gian ở lại (nếu có).</p>
              </div>

              <div className="mt-6">
                <h3 className="font-bold text-lg mb-2 text-center">TRÁCH NHIỆM CHUNG</h3>
                <p>- Hai bên phải tạo điều kiện thuận lợi cho nhau để thực hiện hợp đồng.</p>
                <p>- Nếu một trong hai bên vi phạm hợp đồng trong thời gian hợp đồng vẫn còn hiệu lực thì bên còn lại có quyền đơn phương chấm dứt hợp đồng thuê nhà trọ. Ngoài ra, nếu hành vi vi phạm đó gây tổn thất cho bên bị vi phạm thì bên vi phạm sẽ phải bồi thường mọi thiệt hại đã gây ra.</p>
                <p>- Trong trường hợp muốn chấm dứt hợp đồng trước thời hạn, cần phải báo trước cho bên kia ít nhất 30 ngày và hai bên phải có sự thống nhất với nhau.</p>
                <p>- Kết thúc hợp đồng, Bên A phải trả lại đầy đủ tiền đặt cọc cho bên B.</p>
                <p>- Bên nào vi phạm các điều khoản chung thì phải chịu trách nhiệm trước pháp luật.</p>
                <p>- Hợp đồng này được lập thành 02 bản và có giá trị pháp lý như nhau, mỗi bên giữ một bản.</p>
              </div>
              
              {formData.dieuKhoan && (
                <div className="mt-6">
                  <h3 className="font-bold text-lg mb-2 text-center">ĐIỀU KHOẢN BỔ SUNG</h3>
                  <div className="whitespace-pre-line">{formData.dieuKhoan}</div>
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

