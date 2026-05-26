'use client';

import { useState, useEffect, useCallback } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Label } from '@/components/ui/label';
import { 
  Plus, 
  Search, 
  Edit, 
  Trash2, 
  Coins, 
  Building2, 
  Calendar, 
  Info,
  RefreshCw,
  Sliders,
  DollarSign,
  ChevronLeft,
  ChevronRight,
  ChevronsLeft,
  ChevronsRight
} from 'lucide-react';
import { toast } from 'sonner';
import { ToaNha, CauHinhGia, LoaiMucHoaDon, LoaiTinhPhi } from '@/types';

// Map LoaiMucHoaDon enums to Vietnamese labels
const LOAI_MUC_LABEL: Record<LoaiMucHoaDon, string> = {
  ROOM: 'Tiền phòng',
  ELECTRICITY: 'Tiền điện',
  WATER: 'Tiền nước',
  INTERNET: 'Internet',
  GARBAGE: 'Tiền rác',
  PARKING: 'Gửi xe',
  SERVICE: 'Dịch vụ khác',
  MAINTENANCE: 'Chi phí bảo trì',
  DEBT: 'Nợ cũ',
  DISCOUNT: 'Giảm giá',
  OTHER: 'Khác',
};

// Map LoaiTinhPhi enums to Vietnamese labels
const LOAI_TINH_PHI_LABEL: Record<LoaiTinhPhi, string> = {
  FIXED: 'Cố định',
  PER_PERSON: 'Theo người ở',
  PER_ROOM: 'Theo phòng',
  PER_UNIT: 'Theo chỉ số (kW/m3)',
  PERCENT: 'Theo phần trăm',
};

export default function CauHinhGiaPage() {
  const [toaNhaList, setToaNhaList] = useState<ToaNha[]>([]);
  const [selectedToaNhaId, setSelectedToaNhaId] = useState<string>('');
  const [cauHinhGiaList, setCauHinhGiaList] = useState<CauHinhGia[]>([]);
  const [loadingToaNhas, setLoadingToaNhas] = useState(true);
  const [loadingConfigs, setLoadingConfigs] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategoryFilter, setSelectedCategoryFilter] = useState<string>('ALL');
  const [selectedStatusFilter, setSelectedStatusFilter] = useState<string>('ALL');
  
  // Pagination state
  const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 10 });
  const [totalElements, setTotalElements] = useState(0);
  const [totalPages, setTotalPages] = useState(0);

  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [editingConfig, setEditingConfig] = useState<CauHinhGia | null>(null);

  // Fetch list of buildings
  const fetchToaNhas = useCallback(async () => {
    try {
      setLoadingToaNhas(true);
      const response = await fetch('/api/toa-nha');
      if (response.ok) {
        const result = await response.json();
        if (result.success && result.data) {
          const list: ToaNha[] = result.data;
          setToaNhaList(list);
          if (list.length > 0) {
            setSelectedToaNhaId(list[0]._id || list[0].id || '');
          }
        }
      }
    } catch (error) {
      console.error('Lỗi khi tải danh sách tòa nhà:', error);
      toast.error('Không thể tải danh sách tòa nhà');
    } finally {
      setLoadingToaNhas(false);
    }
  }, []);

  // Fetch configurations for selected building
  const fetchConfigs = useCallback(async (nhaTroId: string, pageIndex: number, pageSize: number, loaiFilter: string, statusFilter: string) => {
    if (!nhaTroId) return;
    try {
      setLoadingConfigs(true);
      const params = new URLSearchParams({
        nhaTroId,
        page: (pageIndex + 1).toString(),
        limit: pageSize.toString()
      });
      if (loaiFilter && loaiFilter !== 'ALL') params.append('loai', loaiFilter);
      if (statusFilter === 'ACTIVE') params.append('dangApDung', 'true');
      if (statusFilter === 'INACTIVE') params.append('dangApDung', 'false');

      const response = await fetch(`/api/cau-hinh-gia?${params.toString()}`);
      if (response.ok) {
        const result = await response.json();
        if (result.success) {
          let cauHinhGiaData = [];
          if (result.data && !Array.isArray(result.data)) {
            cauHinhGiaData = result.data.data || [];
            setTotalElements(result.data.total || 0);
            setTotalPages(result.data.totalPages || 0);
          } else {
            cauHinhGiaData = result.data || [];
            setTotalElements(cauHinhGiaData.length);
            setTotalPages(1);
          }
          setCauHinhGiaList(cauHinhGiaData);
        }
      }
    } catch (error) {
      console.error('Lỗi khi tải cấu hình giá:', error);
      toast.error('Không thể tải danh sách cấu hình giá');
    } finally {
      setLoadingConfigs(false);
    }
  }, []);

  useEffect(() => {
    document.title = 'Cấu hình giá dịch vụ';
    fetchToaNhas();
  }, [fetchToaNhas]);

  useEffect(() => {
    if (selectedToaNhaId) {
      fetchConfigs(selectedToaNhaId, pagination.pageIndex, pagination.pageSize, selectedCategoryFilter, selectedStatusFilter);
    }
  }, [selectedToaNhaId, pagination.pageIndex, pagination.pageSize, selectedCategoryFilter, selectedStatusFilter, fetchConfigs]);

  const handleRefresh = async () => {
    if (selectedToaNhaId) {
      await fetchConfigs(selectedToaNhaId, pagination.pageIndex, pagination.pageSize, selectedCategoryFilter, selectedStatusFilter);
      toast.success('Đã tải lại cấu hình giá mới nhất');
    }
  };

  const handleEdit = (config: CauHinhGia) => {
    setEditingConfig(config);
    setIsDialogOpen(true);
  };

  const handleDeactivate = async (id: string) => {
    try {
      const response = await fetch(`/api/cau-hinh-gia/${id}`, {
        method: 'DELETE',
      });
      if (response.ok) {
        const result = await response.json();
        if (result.success) {
          toast.success('Đã ngưng áp dụng cấu hình giá này!');
          if (selectedToaNhaId) {
            fetchConfigs(selectedToaNhaId, pagination.pageIndex, pagination.pageSize, selectedCategoryFilter, selectedStatusFilter);
          }
        } else {
          toast.error(result.message || 'Lỗi khi ngưng áp dụng cấu hình giá');
        }
      }
    } catch (error) {
      console.error('Lỗi ngưng áp dụng cấu hình giá:', error);
      toast.error('Lỗi hệ thống khi ngưng áp dụng cấu hình giá');
    }
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND',
    }).format(amount);
  };

  // Filter configurations for search (client-side search only, server-side filtering handled above)
  const filteredConfigs = cauHinhGiaList.filter((config) => {
    const matchesSearch = config.tenHienThi.toLowerCase().includes(searchTerm.toLowerCase()) ||
      LOAI_MUC_LABEL[config.loai]?.toLowerCase().includes(searchTerm.toLowerCase());
      
    return matchesSearch;
  });

  if (loadingToaNhas) {
    return (
      <div className="space-y-6">
        <div className="h-8 bg-gray-200 rounded w-48 animate-pulse"></div>
        <div className="h-96 bg-gray-200 rounded animate-pulse"></div>
      </div>
    );
  }

  return (
    <div className="space-y-4 md:space-y-6 pb-10">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3">
        <div>
          <h1 className="text-xl md:text-2xl lg:text-3xl font-bold text-gray-900 flex items-center gap-2">
            <Coins className="h-6 w-6 text-yellow-500" />
            Cấu hình giá dịch vụ
          </h1>
          <p className="text-xs md:text-sm text-gray-600">
            Quản lý đơn giá phòng trọ, điện, nước và các dịch vụ đi kèm
          </p>
        </div>
        <div className="flex gap-2 w-full sm:w-auto">
          <Button
            variant="outline"
            size="sm"
            onClick={handleRefresh}
            disabled={loadingConfigs}
            className="flex-1 sm:flex-none"
          >
            <RefreshCw className={`h-4 w-4 mr-2 ${loadingConfigs ? 'animate-spin' : ''}`} />
            Tải lại
          </Button>
          <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
            <DialogTrigger asChild>
              <Button size="sm" onClick={() => setEditingConfig(null)} className="flex-1 sm:flex-none">
                <Plus className="h-4 w-4 mr-2" />
                Thêm cấu hình
              </Button>
            </DialogTrigger>
            <DialogContent className="max-w-md w-[95vw] rounded-xl">
              <DialogHeader>
                <DialogTitle>{editingConfig ? 'Chỉnh sửa cấu hình giá' : 'Thêm cấu hình giá mới'}</DialogTitle>
                <DialogDescription>
                  Thiết lập đơn giá áp dụng cho tòa nhà. Giá cũ đã dùng trong hóa đơn sẽ không bị ảnh hưởng.
                </DialogDescription>
              </DialogHeader>
              <CauHinhGiaForm
                config={editingConfig}
                toaNhaId={selectedToaNhaId}
                toaNhaList={toaNhaList}
                onClose={() => setIsDialogOpen(false)}
                onSuccess={() => {
                  setIsDialogOpen(false);
                  if (selectedToaNhaId) {
                    fetchConfigs(selectedToaNhaId, pagination.pageIndex, pagination.pageSize, selectedCategoryFilter, selectedStatusFilter);
                  }
                }}
              />
            </DialogContent>
          </Dialog>
        </div>
      </div>

      {/* Building Selector Dropdown */}
      <Card className="border-none shadow-sm bg-gradient-to-r from-blue-50 to-indigo-50/50">
        <CardContent className="p-4 flex flex-col md:flex-row items-start md:items-center gap-4">
          <div className="flex items-center gap-2 text-slate-700 font-semibold min-w-[120px]">
            <Building2 className="h-5 w-5 text-indigo-600" />
            <span>Chọn tòa nhà:</span>
          </div>
          <Select value={selectedToaNhaId} onValueChange={setSelectedToaNhaId}>
            <SelectTrigger className="w-full md:w-[320px] bg-white border-slate-200">
              <SelectValue placeholder="Chọn tòa nhà để xem giá" />
            </SelectTrigger>
            <SelectContent>
              {toaNhaList.map((t) => (
                <SelectItem key={t._id || t.id} value={t._id || t.id || ''}>
                  {t.tenToaNha}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </CardContent>
      </Card>

      {/* Main Content */}
      <div className="grid grid-cols-1 gap-6">
        <Card className="border-none shadow-sm">
          <CardHeader className="pb-3 border-b border-slate-100 flex flex-col md:flex-row justify-between items-start md:items-center gap-3">
            <div>
              <CardTitle className="text-base md:text-lg">Danh sách cấu hình đơn giá</CardTitle>
              <CardDescription>Các mức giá dịch vụ đang được áp dụng cho tòa nhà này</CardDescription>
            </div>
            {/* Filters */}
            <div className="flex flex-wrap items-center gap-2 w-full md:w-auto">
              <div className="relative flex-1 md:w-64">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                <Input
                  placeholder="Tìm kiếm..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-9 h-9 text-xs"
                />
              </div>

              <Select value={selectedCategoryFilter} onValueChange={setSelectedCategoryFilter}>
                <SelectTrigger className="w-[140px] h-9 text-xs bg-white">
                  <SelectValue placeholder="Mục hóa đơn" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="ALL">Tất cả mục</SelectItem>
                  {Object.entries(LOAI_MUC_LABEL).map(([key, value]) => (
                    <SelectItem key={key} value={key} className="text-xs">
                      {value}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>

              <Select value={selectedStatusFilter} onValueChange={setSelectedStatusFilter}>
                <SelectTrigger className="w-[120px] h-9 text-xs bg-white">
                  <SelectValue placeholder="Trạng thái" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="ALL">Tất cả</SelectItem>
                  <SelectItem value="ACTIVE">Đang áp dụng</SelectItem>
                  <SelectItem value="INACTIVE">Ngừng áp dụng</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </CardHeader>

          <CardContent className="p-0">
            {loadingConfigs ? (
              <div className="p-8 text-center text-slate-500 animate-pulse">Đang tải cấu hình giá...</div>
            ) : filteredConfigs.length === 0 ? (
              <div className="p-12 text-center">
                <Info className="h-10 w-10 mx-auto text-slate-400 mb-2" />
                <p className="font-medium text-slate-900">Không tìm thấy cấu hình giá nào</p>
                <p className="text-xs text-slate-500 mt-1">Vui lòng kiểm tra lại bộ lọc hoặc tạo cấu hình giá mới.</p>
              </div>
            ) : (
              <div className="overflow-x-auto">
                <Table className="text-xs md:text-sm">
                  <TableHeader>
                    <TableRow className="bg-slate-50/50 hover:bg-slate-50/50">
                      <TableHead className="font-semibold text-slate-700">Tên hiển thị</TableHead>
                      <TableHead className="font-semibold text-slate-700">Loại mục</TableHead>
                      <TableHead className="font-semibold text-slate-700">Đơn giá</TableHead>
                      <TableHead className="font-semibold text-slate-700">Cách tính phí</TableHead>
                      <TableHead className="font-semibold text-slate-700">Thời gian hiệu lực</TableHead>
                      <TableHead className="font-semibold text-slate-700">Trạng thái</TableHead>
                      <TableHead className="font-semibold text-slate-700 text-right">Thao tác</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {filteredConfigs.map((config) => (
                      <TableRow key={config._id || config.id} className="hover:bg-slate-50/30">
                        <TableCell className="font-medium text-slate-900">{config.tenHienThi}</TableCell>
                        <TableCell>
                          <Badge variant="outline" className="font-normal text-xs bg-slate-50 text-slate-700 border-slate-200">
                            {LOAI_MUC_LABEL[config.loai] || config.loai}
                          </Badge>
                        </TableCell>
                        <TableCell className="font-bold text-slate-900 text-base">
                          {formatCurrency(config.donGia)}
                        </TableCell>
                        <TableCell className="text-slate-600">
                          {LOAI_TINH_PHI_LABEL[config.loaiTinhPhi] || config.loaiTinhPhi}
                        </TableCell>
                        <TableCell className="text-slate-600">
                          <div className="flex items-center gap-1">
                            <Calendar className="h-3.5 w-3.5 text-slate-400" />
                            <span>Từ {String(config.hieuLucTu)}</span>
                            {config.hieuLucDen && <span>đến {String(config.hieuLucDen)}</span>}
                          </div>
                        </TableCell>
                        <TableCell>
                          {config.dangApDung ? (
                            <Badge className="bg-green-100 text-green-700 hover:bg-green-100 border-none font-medium">
                              Đang áp dụng
                            </Badge>
                          ) : (
                            <Badge className="bg-slate-100 text-slate-500 hover:bg-slate-100 border-none font-medium">
                              Ngừng áp dụng
                            </Badge>
                          )}
                        </TableCell>
                        <TableCell className="text-right">
                          <div className="flex justify-end gap-1.5">
                            <Button
                              variant="outline"
                              size="sm"
                              onClick={() => handleEdit(config)}
                              className="h-8 w-8 p-0"
                            >
                              <Edit className="h-3.5 w-3.5" />
                            </Button>
                            {config.dangApDung && (
                              <Button
                                variant="outline"
                                size="sm"
                                onClick={() => handleDeactivate(config._id || config.id || '')}
                                className="h-8 w-8 p-0 text-red-600 hover:text-red-700 hover:bg-red-50"
                                title="Ngừng áp dụng"
                              >
                                <Trash2 className="h-3.5 w-3.5" />
                              </Button>
                            )}
                          </div>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>
            )}
            
            <div className="flex items-center justify-between p-4 border-t">
              <div className="text-muted-foreground hidden flex-1 text-sm lg:flex">
                Hiển thị {filteredConfigs.length} / {totalElements} cấu hình
              </div>
              <div className="flex w-full items-center gap-8 lg:w-fit">
                <div className="hidden items-center gap-2 lg:flex">
                  <Label htmlFor="rows-per-page" className="text-sm font-medium">
                    Số hàng mỗi trang
                  </Label>
                  <Select
                    value={`${pagination.pageSize}`}
                    onValueChange={(value) => {
                      setPagination(prev => ({ ...prev, pageSize: Number(value), pageIndex: 0 }))
                    }}
                  >
                    <SelectTrigger size="sm" className="w-20" id="rows-per-page">
                      <SelectValue placeholder={pagination.pageSize} />
                    </SelectTrigger>
                    <SelectContent side="top">
                      {[10, 20, 30, 40, 50].map((pageSize) => (
                        <SelectItem key={pageSize} value={`${pageSize}`}>
                          {pageSize}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
                <div className="flex w-fit items-center justify-center text-sm font-medium">
                  Trang {pagination.pageIndex + 1} / {totalPages || 1}
                </div>
                <div className="ml-auto flex items-center gap-2 lg:ml-0">
                  <Button
                    variant="outline"
                    className="hidden h-8 w-8 p-0 lg:flex"
                    onClick={() => setPagination(prev => ({ ...prev, pageIndex: 0 }))}
                    disabled={pagination.pageIndex === 0}
                  >
                    <span className="sr-only">Trang đầu</span>
                    <ChevronsLeft className="h-4 w-4" />
                  </Button>
                  <Button
                    variant="outline"
                    className="size-8 p-0"
                    onClick={() => setPagination(prev => ({ ...prev, pageIndex: Math.max(0, prev.pageIndex - 1) }))}
                    disabled={pagination.pageIndex === 0}
                  >
                    <span className="sr-only">Trang trước</span>
                    <ChevronLeft className="h-4 w-4" />
                  </Button>
                  <Button
                    variant="outline"
                    className="size-8 p-0"
                    onClick={() => setPagination(prev => ({ ...prev, pageIndex: Math.min(totalPages - 1, prev.pageIndex + 1) }))}
                    disabled={pagination.pageIndex >= totalPages - 1}
                  >
                    <span className="sr-only">Trang sau</span>
                    <ChevronRight className="h-4 w-4" />
                  </Button>
                  <Button
                    variant="outline"
                    className="hidden h-8 w-8 p-0 lg:flex"
                    onClick={() => setPagination(prev => ({ ...prev, pageIndex: totalPages - 1 }))}
                    disabled={pagination.pageIndex >= totalPages - 1}
                  >
                    <span className="sr-only">Trang cuối</span>
                    <ChevronsRight className="h-4 w-4" />
                  </Button>
                </div>
              </div>
            </div>
            
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

// Form component for creating or editing CauHinhGia
interface FormProps {
  config: CauHinhGia | null;
  toaNhaId: string;
  toaNhaList: ToaNha[];
  onClose: () => void;
  onSuccess: () => void;
}

function CauHinhGiaForm({ config, toaNhaId, toaNhaList, onClose, onSuccess }: FormProps) {
  const getTodayString = () => {
    const today = new Date();
    const yyyy = today.getFullYear();
    const mm = String(today.getMonth() + 1).padStart(2, '0');
    const dd = String(today.getDate()).padStart(2, '0');
    return `${yyyy}-${mm}-${dd}`;
  };

  const [formData, setFormData] = useState({
    nhaTroId: config?.nhaTroId || toaNhaId || '',
    loai: config?.loai || 'ROOM',
    tenHienThi: config?.tenHienThi || '',
    loaiTinhPhi: config?.loaiTinhPhi || 'FIXED',
    donGia: config?.donGia !== undefined ? String(config.donGia) : '',
    hieuLucTu: config?.hieuLucTu ? String(config.hieuLucTu) : getTodayString(),
    hieuLucDen: config?.hieuLucDen ? String(config.hieuLucDen) : '',
    dangApDung: config?.dangApDung !== undefined ? config.dangApDung : true,
  });

  const [submitting, setSubmitting] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.nhaTroId) {
      toast.error('Vui lòng chọn tòa nhà');
      return;
    }
    if (!formData.tenHienThi.trim()) {
      toast.error('Vui lòng nhập tên hiển thị');
      return;
    }
    const priceNum = Number(formData.donGia);
    if (isNaN(priceNum) || priceNum < 0) {
      toast.error('Đơn giá không hợp lệ (phải >= 0)');
      return;
    }

    try {
      setSubmitting(true);
      const payload = {
        nhaTroId: formData.nhaTroId,
        loai: formData.loai,
        tenHienThi: formData.tenHienThi.trim(),
        loaiTinhPhi: formData.loaiTinhPhi,
        donGia: priceNum,
        hieuLucTu: formData.hieuLucTu,
        hieuLucDen: formData.hieuLucDen || null,
        dangApDung: formData.dangApDung,
      };

      const url = config ? `/api/cau-hinh-gia/${config._id || config.id}` : '/api/cau-hinh-gia';
      const method = config ? 'PUT' : 'POST';

      const response = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });

      if (response.ok) {
        const result = await response.json();
        if (result.success) {
          toast.success(config ? 'Cập nhật cấu hình thành công!' : 'Tạo cấu hình giá thành công!');
          onSuccess();
        } else {
          toast.error(result.message || 'Lỗi khi xử lý biểu mẫu');
        }
      } else {
        const errorResult = await response.json();
        toast.error(errorResult.message || 'Có lỗi xảy ra từ máy chủ');
      }
    } catch (error) {
      console.error('Lỗi khi gửi form:', error);
      toast.error('Có lỗi xảy ra khi kết nối máy chủ');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4 pt-2">
      {/* NhaTro / ToaNha Selector (Disabled on edit) */}
      <div className="space-y-1">
        <Label htmlFor="form-nhaTroId" className="text-xs font-semibold">Tòa nhà áp dụng</Label>
        <Select 
          value={formData.nhaTroId} 
          onValueChange={(val) => setFormData(prev => ({ ...prev, nhaTroId: val }))}
          disabled={!!config}
        >
          <SelectTrigger className="w-full text-xs h-9">
            <SelectValue placeholder="Chọn tòa nhà" />
          </SelectTrigger>
          <SelectContent>
            {toaNhaList.map((t) => (
              <SelectItem key={t._id || t.id} value={t._id || t.id || ''} className="text-xs">
                {t.tenToaNha}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      {/* Item Type (loai) */}
      <div className="space-y-1">
        <Label htmlFor="form-loai" className="text-xs font-semibold">Loại mục thanh toán</Label>
        <Select 
          value={formData.loai} 
          onValueChange={(val) => setFormData(prev => ({ ...prev, loai: val as LoaiMucHoaDon }))}
        >
          <SelectTrigger className="w-full text-xs h-9">
            <SelectValue placeholder="Chọn loại mục" />
          </SelectTrigger>
          <SelectContent>
            {Object.entries(LOAI_MUC_LABEL).map(([key, val]) => (
              <SelectItem key={key} value={key} className="text-xs">
                {val}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      {/* Display Name */}
      <div className="space-y-1">
        <Label htmlFor="form-tenHienThi" className="text-xs font-semibold">Tên hiển thị trên hóa đơn</Label>
        <Input
          id="form-tenHienThi"
          placeholder="Ví dụ: Tiền điện (sinh hoạt), Tiền nước sạch..."
          value={formData.tenHienThi}
          onChange={(e) => setFormData(prev => ({ ...prev, tenHienThi: e.target.value }))}
          className="text-xs h-9"
          required
        />
      </div>

      <div className="grid grid-cols-2 gap-3">
        {/* Price / Rate */}
        <div className="space-y-1">
          <Label htmlFor="form-donGia" className="text-xs font-semibold">Đơn giá (VND)</Label>
          <div className="relative">
            <DollarSign className="absolute left-2.5 top-1/2 transform -translate-y-1/2 h-3.5 w-3.5 text-slate-400" />
            <Input
              id="form-donGia"
              type="number"
              min="0"
              placeholder="0"
              value={formData.donGia}
              onChange={(e) => setFormData(prev => ({ ...prev, donGia: e.target.value }))}
              className="pl-8 text-xs h-9"
              required
            />
          </div>
        </div>

        {/* Charge type (loaiTinhPhi) */}
        <div className="space-y-1">
          <Label htmlFor="form-loaiTinhPhi" className="text-xs font-semibold">Phương thức tính phí</Label>
          <Select 
            value={formData.loaiTinhPhi} 
            onValueChange={(val) => setFormData(prev => ({ ...prev, loaiTinhPhi: val as LoaiTinhPhi }))}
          >
            <SelectTrigger className="w-full text-xs h-9">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              {Object.entries(LOAI_TINH_PHI_LABEL).map(([key, val]) => (
                <SelectItem key={key} value={key} className="text-xs">
                  {val}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-3">
        {/* Effective From */}
        <div className="space-y-1">
          <Label htmlFor="form-hieuLucTu" className="text-xs font-semibold">Có hiệu lực từ ngày</Label>
          <Input
            id="form-hieuLucTu"
            type="date"
            value={formData.hieuLucTu}
            onChange={(e) => setFormData(prev => ({ ...prev, hieuLucTu: e.target.value }))}
            className="text-xs h-9"
            required
          />
        </div>

        {/* Effective To */}
        <div className="space-y-1">
          <Label htmlFor="form-hieuLucDen" className="text-xs font-semibold">Hết hiệu lực (không bắt buộc)</Label>
          <Input
            id="form-hieuLucDen"
            type="date"
            value={formData.hieuLucDen}
            onChange={(e) => setFormData(prev => ({ ...prev, hieuLucDen: e.target.value }))}
            className="text-xs h-9"
          />
        </div>
      </div>

      {/* Status Active Checkbox */}
      <div className="flex items-center space-x-2 pt-1">
        <input
          id="form-dangApDung"
          type="checkbox"
          checked={formData.dangApDung}
          onChange={(e) => setFormData(prev => ({ ...prev, dangApDung: e.target.checked }))}
          className="rounded border-slate-300 text-indigo-600 focus:ring-indigo-500 h-4 w-4"
        />
        <Label htmlFor="form-dangApDung" className="text-xs font-medium text-slate-700 cursor-pointer">
          Áp dụng ngay lập tức
        </Label>
      </div>

      <DialogFooter className="pt-2">
        <Button variant="outline" size="sm" type="button" onClick={onClose} disabled={submitting}>
          Hủy
        </Button>
        <Button size="sm" type="submit" disabled={submitting}>
          {submitting ? 'Đang lưu...' : 'Lưu lại'}
        </Button>
      </DialogFooter>
    </form>
  );
}
