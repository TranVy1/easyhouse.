'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
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
  Check,
  ChevronsUpDown
} from 'lucide-react';
import { Phong, KhachThue } from '@/types';
import { toast } from 'sonner';
import { cn } from "@/lib/utils";
import { normalizeKhachThue, normalizePhong } from '@/lib/domain-mappers';
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
  const [phongList, setPhongList] = useState<Phong[]>([]);
  const [khachThueList, setKhachThueList] = useState<KhachThue[]>([]);
  const [dichVuOptions, setDichVuOptions] = useState<DichVuOption[]>([]);
  const [globalDichVuList, setGlobalDichVuList] = useState<DichVuOption[]>([]);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);

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
    chiSoDienBanDau: 0,
    chiSoNuocBanDau: 0,
    phiDichVu: [] as PhiDichVuForm[],
    trangThai: 'nhap' as 'nhap' | 'choKichHoat' | 'hoatDong' | 'hetHan' | 'daKetThuc' | 'daHuy',
  });

  const [openPhong, setOpenPhong] = useState(false);
  const [openKhachThue, setOpenKhachThue] = useState(false);
  const [openNguoiDaiDien, setOpenNguoiDaiDien] = useState(false);
  const [openAddDichVu, setOpenAddDichVu] = useState(false);

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

  const loadDichVuTheoPhong = async (phongId: string) => {
    if (!phongId) {
      setDichVuOptions([]);
      return;
    }
    try {
      const response = await fetch(`/api/hop-dong/dich-vu?phongId=${phongId}`);
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

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      const phongResponse = await fetch('/api/phong?limit=100');
      const phongData = await phongResponse.json().catch(() => ({}));
      if (!phongResponse.ok || phongData.success === false) {
        throw new Error(phongData.message || 'Không tải được danh sách phòng');
      }
      const availablePhong = (phongData.data || [])
        .map(normalizePhong)
        .filter((phong: Phong) =>
          phong.trangThai === 'trong' || phong.trangThai === 'AVAILABLE' || phong.trangThai === 'daDat' || phong.trangThai === 'RESERVED'
        );
      setPhongList(availablePhong);

      const khachThueResponse = await fetch('/api/khach-thue?limit=100');
      const khachThueData = await khachThueResponse.json().catch(() => ({}));
      if (!khachThueResponse.ok || khachThueData.success === false) {
        throw new Error(khachThueData.message || 'Không tải được danh sách khách thuê');
      }
      setKhachThueList((khachThueData.data || []).map(normalizeKhachThue));

      const dichVuResponse = await fetch('/api/dich-vu');
      const dvData = await dichVuResponse.json().catch(() => ({}));
      if (!dichVuResponse.ok || dvData.success === false) {
        toast.error(dvData.message || 'Không tải được danh sách dịch vụ');
      } else {
        setGlobalDichVuList((dvData.data || []).map((dv: ApiDichVu) => ({
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
      const response = await fetch('/api/hop-dong', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
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
        toast.success(result.message || 'Đã tạo hợp đồng thành công');
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
          onClick={() => router.push('/dashboard/hop-dong')}
        >
          <ArrowLeft className="h-4 w-4" />
        </Button>
        <div>
          <h1 className="text-xl md:text-2xl lg:text-3xl font-bold text-gray-900">Tạo hợp đồng mới</h1>
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
                    <SelectItem value="hoatDong">Hoạt động</SelectItem>
                    <SelectItem value="hetHan">Hết hạn</SelectItem>
                    <SelectItem value="daKetThuc">Đã kết thúc</SelectItem>
                    <SelectItem value="daHuy">Đã hủy</SelectItem>
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
                  onChange={(e) => setFormData(prev => ({ ...prev, chiSoDienBanDau: parseInt(e.target.value) || 0 }))}
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
                  onChange={(e) => setFormData(prev => ({ ...prev, chiSoNuocBanDau: parseInt(e.target.value) || 0 }))}
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
                    Đang tạo...
                  </>
                ) : (
                  <>
                    <Save className="h-4 w-4 mr-2" />
                    Tạo hợp đồng
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

