'use client';

import { useState, useEffect, useCallback } from 'react';
import type { ReactNode } from 'react';
import { useSession } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import { Button } from '@/components/ui/button';
import { useCache } from '@/hooks/use-cache';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { DashboardKpiCard, DashboardCard, HeroActionButton, FilterBadge } from '@/components/dashboard/shared-ui';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';

import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
} from '@/components/ui/command';
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from '@/components/ui/popover';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Checkbox } from '@/components/ui/checkbox';
import { 
  Plus, 
  Search, 
  Edit,  
  Building2, 
  DoorOpen,
  FileUp,
  Home,
  MapPin,
  Percent,
  RefreshCw,
  Copy,
  Check,
  ChevronsUpDown,
  AlertCircle,
  TrendingUp,
  TrendingDown,
} from 'lucide-react';
import { cn } from '@/lib/utils';

import { ToaNha } from '@/types';
import { DeleteConfirmPopover } from '@/components/ui/delete-confirm-popover';
import { toast } from 'sonner';
import { ToaNhaDataTable } from './table';

const calculateOccupancyRate = (rented: number, total: number) => {
  return total > 0 ? Math.round((rented / total) * 100) : 0;
};

const getOccupancyColor = (percentage: number) => {
  if (percentage <= 30) return 'text-red-600';
  if (percentage <= 70) return 'text-orange-500';
  return 'text-[#4FA7A0]';
};

const getOccupancyBgColor = (percentage: number) => {
  if (percentage <= 30) return 'bg-red-500';
  if (percentage <= 70) return 'bg-orange-500';
  return 'bg-[#4FA7A0]';
};

const getLowOccupancyBuildings = (buildings: ToaNha[]) => {
  return [...buildings]
    .filter(b => b.tongSoPhong && b.tongSoPhong > 0)
    .sort((a, b) => {
      const rateA = calculateOccupancyRate(a.phongDangThue || 0, a.tongSoPhong || 0);
      const rateB = calculateOccupancyRate(b.phongDangThue || 0, b.tongSoPhong || 0);
      return rateA - rateB;
    })
    .slice(0, 3);
};



export default function ToaNhaPage() {
  const router = useRouter();
  const accessToken = useSession()?.data?.accessToken;
  const { clearCache, isRefreshing, setIsRefreshing } = useCache<{ toaNhaList: ToaNha[] }>({ key: 'toa-nha-data', duration: 300000 });
  const [toaNhaList, setToaNhaList] = useState<ToaNha[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [appliedSearch, setAppliedSearch] = useState('');
  const [activeFilter, setActiveFilter] = useState<'ALL' | 'AVAILABLE' | 'LOW' | 'RENTED' | 'ATTENTION'>('ALL');
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [editingToaNha, setEditingToaNha] = useState<ToaNha | null>(null);
  const [isImportOpen, setIsImportOpen] = useState(false);
  const [importText, setImportText] = useState('');
  const [importPreview, setImportPreview] = useState<{
    tongDong: number;
    dongHopLe: number;
    dongLoi: number;
    phongTaoMoi: number;
    rows?: Array<{ dong: number; hopLe: boolean; tenToaNha?: string; maPhong?: string; loi?: string; hanhDong?: string }>;
  } | null>(null);
  const [importing, setImporting] = useState(false);
  
  // Pagination state
  const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 10 });
  const [totalElements, setTotalElements] = useState(0);
  const [totalPages, setTotalPages] = useState(0);

  useEffect(() => {
    document.title = 'Quản lý Tòa nhà';
  }, []);

  const fetchToaNha = useCallback(async (page = 1, limit = 10, search = '') => {
    try {
      setLoading(true);

      const params = new URLSearchParams({ page: String(page), limit: String(limit) });
      if (search) params.set('search', search);
      const response = await fetch(`/api/toa-nha?${params.toString()}`, {
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      });
      if (response.ok) {
        const result = await response.json();
        if (result.success) {
          const toaNhas = Array.isArray(result.data) ? result.data : (result.data?.data || []);
          setToaNhaList(toaNhas);
          if (result.data && !Array.isArray(result.data)) {
            setTotalElements(result.data.total || 0);
            setTotalPages(result.data.totalPages || 0);
          } else {
            setTotalElements(toaNhas.length);
            setTotalPages(1);
          }
        }
      }
    } catch (error) {
      console.error('Error fetching toa nha:', error);
    } finally {
      setLoading(false);
    }
  }, [accessToken]);

  useEffect(() => {
    fetchToaNha(pagination.pageIndex + 1, pagination.pageSize, appliedSearch);
  }, [fetchToaNha, pagination.pageIndex, pagination.pageSize, appliedSearch]);

  useEffect(() => {
    const timeout = window.setTimeout(() => {
      setAppliedSearch(searchTerm.trim());
      setPagination(prev => ({ ...prev, pageIndex: 0 }));
    }, 350);
    return () => window.clearTimeout(timeout);
  }, [searchTerm]);

  const handleRefresh = async () => {
    setIsRefreshing(true);
    await fetchToaNha(pagination.pageIndex + 1, pagination.pageSize, appliedSearch);
    setIsRefreshing(false);
    toast.success('Đã tải dữ liệu mới nhất');
  };

  const filteredToaNha = toaNhaList.filter(b => {
    if (activeFilter === 'AVAILABLE') return (b.phongTrong || 0) > 0;
    if (activeFilter === 'LOW') return calculateOccupancyRate(b.phongDangThue || 0, b.tongSoPhong || 0) > 10 && calculateOccupancyRate(b.phongDangThue || 0, b.tongSoPhong || 0) <= 40;
    if (activeFilter === 'RENTED') return (b.phongDangThue || 0) > 0;
    if (activeFilter === 'ATTENTION') return calculateOccupancyRate(b.phongDangThue || 0, b.tongSoPhong || 0) <= 10;
    return true;
  });

  const tongPhong = toaNhaList.reduce((sum, toaNha) => sum + (toaNha.tongSoPhong || 0), 0);
  const phongTrong = toaNhaList.reduce((sum, toaNha) => sum + (toaNha.phongTrong || 0), 0);
  const phongDangThue = toaNhaList.reduce((sum, toaNha) => sum + (toaNha.phongDangThue || 0), 0);
  const tyLeLapDay = calculateOccupancyRate(phongDangThue, tongPhong);
  
  const lowOccupancyBuildings = getLowOccupancyBuildings(toaNhaList);
  const areaDistribution = toaNhaList.reduce((acc, curr) => {
    const quan = curr.diaChi?.quan || 'Khác';
    acc[quan] = (acc[quan] || 0) + 1;
    return acc;
  }, {} as Record<string, number>);
  const sortedAreas = Object.entries(areaDistribution).sort((a, b) => b[1] - a[1]);

  const handleEdit = (toaNha: ToaNha) => {
    setEditingToaNha(toaNha);
    setIsDialogOpen(true);
  };

  const handleView = (toaNha: ToaNha) => {
    const id = toaNha._id || toaNha.id;
    if (id) router.push(`/dashboard/toa-nha/${id}`);
  };

  const handleDelete = async (id: string) => {
    try {
      const response = await fetch(`/api/toa-nha/${id}`, {
        method: 'DELETE',
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      });
      
      if (response.ok) {
        const result = await response.json();
        if (result.success) {
          clearCache();
          await fetchToaNha(pagination.pageIndex + 1, pagination.pageSize, appliedSearch);
          toast.success('Xóa tòa nhà thành công!');
        } else {
          toast.error(result.message || 'Có lỗi xảy ra khi xóa tòa nhà');
        }
      } else {
        const error = await response.json();
        toast.error(error.message || 'Có lỗi xảy ra khi xóa tòa nhà');
      }
    } catch (error) {
      console.error('Error deleting toa nha:', error);
      toast.error('Có lỗi xảy ra khi xóa tòa nhà');
    }
  };

  const parseImportRows = () => {
    return importText
      .split(/\r?\n/)
      .map(line => line.trim())
      .filter(Boolean)
      .map((line, index) => {
        const cols = line.split(/\t|,/).map(value => value.trim());
        if (index === 0 && cols.some(col => col.toLowerCase().includes('ten_toa_nha') || col.toLowerCase().includes('tên'))) {
          return null;
        }
        return {
          tenToaNha: cols[0] || '',
          diaChi: cols[1] || '',
          tang: Number(cols[2] || 0),
          maPhong: cols[3] || '',
          dienTich: Number(cols[4] || 0),
          giaThue: Number((cols[5] || '0').replace(/[^\d]/g, '')),
          tienCoc: Number((cols[6] || '0').replace(/[^\d]/g, '')),
          soNguoiToiDa: Number(cols[7] || 2),
        };
      })
      .filter(Boolean);
  };

  const runImport = async (mode: 'preview' | 'confirm') => {
    const rows = parseImportRows();
    if (rows.length === 0) {
      toast.error('Vui lòng nhập dữ liệu import');
      return;
    }
    setImporting(true);
    try {
      const response = await fetch(`/api/import/toa-nha/${mode}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
        },
        body: JSON.stringify({ rows }),
      });
      const result = await response.json().catch(() => ({}));
      if (!response.ok || !result.success) {
        toast.error(result.message || 'Import thất bại');
        return;
      }
      setImportPreview(result.data);
      toast.success(mode === 'preview' ? 'Đã kiểm tra dữ liệu import' : 'Đã import dữ liệu');
      if (mode === 'confirm') {
        clearCache();
        await fetchToaNha(pagination.pageIndex + 1, pagination.pageSize, appliedSearch);
      }
    } finally {
      setImporting(false);
    }
  };

  const formatAddress = (diaChi: ToaNha['diaChi']) => {
    return `${diaChi.soNha} ${diaChi.duong}, ${diaChi.phuong}, ${diaChi.quan}, ${diaChi.thanhPho}`;
  };

  if (loading) {
    return (
      <div className="space-y-6">
        <div className="flex justify-between items-center">
          <div className="h-8 bg-gray-200 rounded w-48 animate-pulse"></div>
          <div className="h-10 bg-gray-200 rounded w-32 animate-pulse"></div>
        </div>
        <div className="h-96 bg-gray-200 rounded animate-pulse"></div>
      </div>
    );
  }

  return (
    <div className="space-y-5 md:space-y-6">
      <section className="toa-nha-hero">
        <div className="toa-nha-hero__content">
          <div className="toa-nha-hero__eyebrow">
            <Building2 className="h-4 w-4" aria-hidden="true" />
            <span>Tòa nhà</span>
          </div>

          <h1>Tòa nhà</h1>

          <p>
            Theo dõi tình trạng phòng, tỷ lệ lấp đầy và hiệu suất khai thác từng tòa nhà.
          </p>

          {tongPhong > 0 && (
            <div className="toa-nha-hero__insight">
              <span className="toa-nha-hero__insight-icon">
                <Building2 className="h-4 w-4 text-white/90" />
              </span>
              <span className="toa-nha-hero__insight-text">
                Hiện có <strong className="whitespace-nowrap">{phongTrong} phòng trống</strong>, cần ưu tiên tối ưu khai thác các tòa có tỷ lệ lấp đầy thấp.
              </span>
            </div>
          )}

          <div className="toa-nha-hero__chips">
            <span className="toa-nha-hero__chip">{totalElements} tòa nhà</span>
            <span className="toa-nha-hero__chip">{tongPhong} phòng</span>
            <span className="toa-nha-hero__chip">Lấp đầy {tyLeLapDay}%</span>
          </div>
        </div>

        <div className="toa-nha-hero__actions">
            <HeroActionButton
              variant="secondary"
              onClick={handleRefresh}
              disabled={isRefreshing}
              className="toa-nha-hero__button toa-nha-hero__button-secondary"
            >
              <RefreshCw className={`h-4 w-4 mr-2 ${isRefreshing ? 'animate-spin' : ''}`} />
              <span>{isRefreshing ? 'Đang tải...' : 'Tải mới'}</span>
            </HeroActionButton>
            
            <Dialog open={isImportOpen} onOpenChange={setIsImportOpen}>
              <DialogTrigger asChild>
                <HeroActionButton variant="secondary" className="toa-nha-hero__button toa-nha-hero__button-secondary">
                  <FileUp className="h-4 w-4 mr-2" />
                  <span>Import</span>
                </HeroActionButton>
              </DialogTrigger>
              <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto w-[95vw] md:w-full">
                <DialogHeader>
                  <DialogTitle>Import tòa nhà và phòng</DialogTitle>
                  <DialogDescription>
                    Dán dữ liệu từ Excel, kiểm tra lỗi theo dòng rồi mới xác nhận ghi vào hệ thống.
                  </DialogDescription>
                </DialogHeader>
                <div className="space-y-3">
                  <div className="rounded-md border bg-muted/30 p-3 text-xs text-muted-foreground">
                    Thứ tự cột: <b>ten_toa_nha</b>, <b>dia_chi</b>, <b>tang</b>, <b>ma_phong</b>, <b>dien_tich</b>, <b>gia_thue</b>, <b>tien_coc</b>, <b>so_nguoi_toi_da</b>.
                  </div>
                  <Textarea
                    value={importText}
                    onChange={(e) => setImportText(e.target.value)}
                    rows={8}
                    placeholder={'Tòa A\t123 Nguyễn Trãi\t1\t101\t20\t2500000\t2500000\t2'}
                    className="font-mono text-xs"
                  />
                  {importPreview && (
                    <div className="rounded-lg border p-3 text-sm">
                      <div className="grid grid-cols-2 gap-2 md:grid-cols-4">
                        <div className="rounded-md bg-muted/40 p-2">Tổng dòng: <b>{importPreview.tongDong}</b></div>
                        <div className="rounded-md bg-[#4FA7A0]/10 p-2 text-[#267D76]">Hợp lệ: <b>{importPreview.dongHopLe}</b></div>
                        <div className="rounded-md bg-red-50 p-2 text-red-700">Lỗi: <b>{importPreview.dongLoi}</b></div>
                        <div className="rounded-md bg-[#4FA7A0]/10 p-2 text-[#243B5A]">Phòng tạo mới: <b>{importPreview.phongTaoMoi}</b></div>
                      </div>
                      {importPreview.rows?.some(row => !row.hopLe) && (
                        <div className="mt-3 max-h-40 overflow-auto rounded border">
                          {importPreview.rows.filter(row => !row.hopLe).map(row => (
                            <div key={row.dong} className="border-b p-2 text-xs last:border-b-0">
                              Dòng {row.dong}: {row.loi}
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  )}
                </div>
                <DialogFooter>
                  <Button type="button" variant="outline" disabled={importing} onClick={() => runImport('preview')}>
                    Kiểm tra
                  </Button>
                  <Button type="button" disabled={importing || !importPreview || importPreview.dongLoi > 0} onClick={() => runImport('confirm')}>
                    Xác nhận import
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

            <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
              <DialogTrigger asChild>
                <HeroActionButton variant="default" onClick={() => setEditingToaNha(null)} className="toa-nha-hero__button toa-nha-hero__button-primary">
                  <Plus className="h-4 w-4 mr-2" />
                  <span>Thêm tòa nhà</span>
                </HeroActionButton>
              </DialogTrigger>
              <DialogContent className="max-w-[95vw] sm:max-w-5xl max-h-[90vh] overflow-y-auto">
                <DialogHeader>
                  <DialogTitle className="text-base md:text-lg">
                    {editingToaNha ? 'Chỉnh sửa tòa nhà' : 'Thêm tòa nhà mới'}
                  </DialogTitle>
                  <DialogDescription className="text-xs md:text-sm">
                    {editingToaNha ? 'Cập nhật thông tin tòa nhà' : 'Nhập thông tin tòa nhà mới'}
                  </DialogDescription>
                </DialogHeader>
                
                <ToaNhaForm 
                  key={editingToaNha?._id || 'new'}
                  toaNha={editingToaNha}
                  onClose={() => setIsDialogOpen(false)}
                  onSuccess={() => {
                    clearCache();
                    setIsDialogOpen(false);
                    fetchToaNha(pagination.pageIndex + 1, pagination.pageSize, appliedSearch);
                    toast.success(editingToaNha ? 'Cập nhật tòa nhà thành công!' : 'Thêm tòa nhà thành công!');
                  }}
                />
              </DialogContent>
            </Dialog>
        </div>
      </section>
      {/* Stats Cards */}
      <div className="grid grid-cols-2 gap-4 lg:grid-cols-5">
        <DashboardKpiCard title="Tòa nhà" value={totalElements} icon={<Building2 className="h-5 w-5" />} tone="default" />
        <DashboardKpiCard title="Tổng phòng" value={tongPhong} icon={<Home className="h-5 w-5" />} tone="default" />
        <DashboardKpiCard title="Phòng trống" value={phongTrong} tone="emerald" icon={<DoorOpen className="h-5 w-5" />} trend={{ value: `${tongPhong > 0 ? Math.round((phongTrong / tongPhong) * 100) : 0}%`, isUp: true }} />
        <DashboardKpiCard title="Đang thuê" value={phongDangThue} tone="blue" icon={<Home className="h-5 w-5" />} />
        <DashboardKpiCard title="Lấp đầy" value={`${tyLeLapDay}%`} tone="orange" icon={<Percent className="h-5 w-5" />} trend={tyLeLapDay < 50 ? { value: 'Cần chú ý', isUp: false } : undefined} />
      </div>

      {/* Filter Chips */}
      <div className="flex flex-wrap items-center gap-2 overflow-x-auto pb-1 scrollbar-hide">
        {[
          { id: 'ALL', label: 'Tất cả' },
          { id: 'AVAILABLE', label: 'Còn phòng trống' },
          { id: 'LOW', label: 'Lấp đầy thấp' },
          { id: 'RENTED', label: 'Đang khai thác' },
          { id: 'ATTENTION', label: 'Cần chú ý' }
        ].map(filter => (
          <FilterBadge 
            key={filter.id}
            active={activeFilter === filter.id}
            onClick={() => {
              setActiveFilter(filter.id as any);
              setPagination(prev => ({ ...prev, pageIndex: 0 }));
            }}
          >
            {filter.label}
          </FilterBadge>
        ))}
      </div>

      {/* Main Content Grid */}
      <div className="grid grid-cols-1 xl:grid-cols-4 gap-6">
        <div className="xl:col-span-3 space-y-6">
          {/* Desktop Table View */}
          <DashboardCard className="hidden md:block overflow-hidden">
            <CardHeader className="border-b bg-[#F2E8DC]/70 pb-4">
              <CardTitle className="text-lg text-[#243B5A]">Danh sách tòa nhà</CardTitle>
              <CardDescription>
                {filteredToaNha.length} tòa nhà phù hợp bộ lọc hiện tại
              </CardDescription>
            </CardHeader>
            <CardContent className="p-0">
              <div className="p-4 md:p-5">
                <ToaNhaDataTable
                  data={filteredToaNha}
                  onView={handleView}
                  onEdit={handleEdit}
                  onDelete={handleDelete}
                  searchTerm={searchTerm}
                  onSearchChange={setSearchTerm}
                  pageCount={totalPages}
                  totalElements={totalElements}
                  pagination={pagination}
                  onPaginationChange={setPagination}
                />
              </div>
            </CardContent>
          </DashboardCard>

      {/* Mobile Card View */}
      <div className="md:hidden space-y-3">
        <div className="flex justify-between items-center">
          <h2 className="text-base font-semibold">Danh sách tòa nhà</h2>
          <span className="text-xs text-muted-foreground">{filteredToaNha.length} tòa nhà</span>
        </div>

        {/* Mobile Filters */}
        <div className="space-y-2">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
            <Input
              placeholder="Tìm kiếm tòa nhà..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="pl-10 text-sm"
            />
          </div>
        </div>
        
        {filteredToaNha.length === 0 ? (
          <Card className="p-6 text-center">
            <Building2 className="h-10 w-10 mx-auto text-gray-400 mb-3" />
            <h3 className="text-base font-medium text-gray-900 mb-1">Không tìm thấy tòa nhà nào</h3>
            <p className="text-sm text-gray-600">Thử thay đổi tìm kiếm</p>
          </Card>
        ) : (
          <div className="grid grid-cols-1 gap-3">
            {filteredToaNha.map((toaNha) => {
              const phongTrong = toaNha.phongTrong || 0;
              const phongDangThue = toaNha.phongDangThue || 0;
              const tongPhongToa = toaNha.tongSoPhong || 0;
              const tyLeToa = tongPhongToa > 0 ? Math.round((phongDangThue / tongPhongToa) * 100) : 0;
              
              return (
                <Card key={toaNha._id} className="py-0 transition-shadow hover:shadow-md cursor-pointer" onDoubleClick={() => handleView(toaNha)}>
                  <CardContent className="p-4">
                    <div className="flex justify-between items-start mb-2">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-1">
                          <Building2 className="h-4 w-4 text-primary" />
                          <h3 className="font-semibold text-base">{toaNha.tenToaNha}</h3>
                        </div>
                        <div className="flex items-start gap-1.5 text-xs text-gray-600">
                          <MapPin className="h-3.5 w-3.5 mt-0.5 flex-shrink-0" />
                          <span className="line-clamp-2">{formatAddress(toaNha.diaChi)}</span>
                        </div>
                      </div>
                    </div>
                    
                    <div className="mb-3 rounded-md border bg-muted/30 p-3">
                      <div className="mb-3 flex items-center justify-between text-xs">
                        <span className="text-muted-foreground">Tỷ lệ lấp đầy</span>
                        <span className="font-medium">{tyLeToa}%</span>
                      </div>
                      <div className="mb-3 h-2 overflow-hidden rounded-full bg-background">
                        <div className="h-full rounded-full bg-[#4FA7A0]" style={{ width: `${tyLeToa}%` }} />
                      </div>
                      <div className="grid grid-cols-3 gap-2">
                      <div className="text-center">
                        <div className="text-xs text-gray-600">Tổng</div>
                        <div className="text-sm font-semibold">{tongPhongToa}</div>
                      </div>
                      <div className="text-center border-x border-gray-200">
                        <div className="text-xs text-gray-600">Trống</div>
                        <div className="text-sm font-semibold text-[#267D76]">{phongTrong}</div>
                      </div>
                      <div className="text-center">
                        <div className="text-xs text-gray-600">Thuê</div>
                        <div className="text-sm font-semibold text-[#243B5A]">{phongDangThue}</div>
                      </div>
                      </div>
                    </div>

                    {toaNha.tienNghiChung && toaNha.tienNghiChung.length > 0 && (
                      <div className="mb-3">
                        <div className="text-xs text-muted-foreground mb-1">Tiện nghi:</div>
                        <div className="flex flex-wrap gap-1">
                          {toaNha.tienNghiChung.slice(0, 3).map((tienNghi) => (
                            <Badge key={tienNghi} variant="secondary" className="text-xs">
                              {tienNghi}
                            </Badge>
                          ))}
                          {toaNha.tienNghiChung.length > 3 && (
                            <Badge variant="outline" className="text-xs">
                              +{toaNha.tienNghiChung.length - 3}
                            </Badge>
                          )}
                        </div>
                      </div>
                    )}

                    <div className="space-y-2">
                      <div className="flex gap-2">
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => {
                            const publicUrl = `${window.location.origin}/xem-phong`;
                            navigator.clipboard.writeText(publicUrl);
                            toast.success('Đã sao chép link trang xem phòng');
                          }}
                          className="text-[#267D76] hover:text-[#267D76] hover:bg-[#4FA7A0]/10"
                          title="Sao chép liên kết trang xem phòng"
                        >
                          <Copy className="h-3.5 w-3.5" />
                        </Button>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => handleView(toaNha)}
                          className="flex-1 text-xs"
                        >
                          Sơ đồ
                        </Button>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => handleEdit(toaNha)}
                          className="flex-1 text-xs"
                        >
                          <Edit className="h-3.5 w-3.5 mr-1" />
                          Sửa
                        </Button>
                        <DeleteConfirmPopover
                          onConfirm={() => handleDelete(toaNha._id!)}
                          title="Xóa tòa nhà"
                          description="Bạn có chắc chắn muốn xóa tòa nhà này?"
                          className="text-black hover:text-red-700 hover:bg-red-50"
                        />
                      </div>
                    </div>
                  </CardContent>
                </Card>
              );
            })}
          </div>
        )}
      </div>
      </div>

      {/* Right Column Panels */}
      <div className="space-y-6">
        {/* Panel Tòa nhà cần chú ý */}
        <Card className="rounded-xl shadow-sm border-border/50">
          <CardHeader className="border-b bg-[#F8F3EC] pb-4">
            <CardTitle className="text-base text-[#243B5A] flex items-center gap-2">
              <AlertCircle className="h-4 w-4 text-[#F2A45B]" />
              Cần chú ý
            </CardTitle>
            <CardDescription className="text-xs">
              Tòa nhà có lấp đầy thấp nhất
            </CardDescription>
          </CardHeader>
          <CardContent className="p-4">
            {lowOccupancyBuildings.length === 0 ? (
              <div className="text-center text-sm text-muted-foreground py-4">
                Không có dữ liệu
              </div>
            ) : (
              <div className="space-y-4">
                {lowOccupancyBuildings.map((toaNha) => {
                  const rate = calculateOccupancyRate(toaNha.phongDangThue || 0, toaNha.tongSoPhong || 0);
                  const suggestion = rate === 0 
                    ? "Chưa có phòng thuê. Nên đẩy mạnh hoạt động quảng bá." 
                    : "Tỷ lệ lấp đầy thấp. Cần kiểm tra giá thuê hoặc trạng thái phòng.";
                  
                  return (
                    <div key={toaNha._id} className="group relative rounded-lg border p-3 hover:bg-muted/50 transition-colors cursor-pointer" onClick={() => handleView(toaNha)}>
                      <div className="flex justify-between items-start mb-1">
                        <span className="font-semibold text-sm text-[#243B5A] truncate pr-2">{toaNha.tenToaNha}</span>
                        <Badge variant="outline" className={cn("text-[10px] font-bold", getOccupancyColor(rate))}>{rate}%</Badge>
                      </div>
                      <div className="text-xs text-muted-foreground mb-2">
                        {toaNha.phongDangThue || 0} / {toaNha.tongSoPhong || 0} phòng đang thuê
                      </div>
                      <div className="text-xs text-[#243B5A] bg-white border rounded p-2 italic shadow-sm group-hover:bg-[#F8F3EC] transition-colors">
                        "{suggestion}"
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </CardContent>
        </Card>

        {/* Panel Phân bố khu vực */}
        <Card className="rounded-xl shadow-sm border-border/50">
          <CardHeader className="border-b bg-[#F8F3EC] pb-4">
            <CardTitle className="text-base text-[#243B5A] flex items-center gap-2">
              <MapPin className="h-4 w-4 text-[#4FA7A0]" />
              Khu vực
            </CardTitle>
          </CardHeader>
          <CardContent className="p-4 space-y-4">
            {sortedAreas.map(([quan, count]) => {
              const maxCount = sortedAreas[0][1];
              const percentage = Math.round((count / maxCount) * 100);
              return (
                <div key={quan} className="space-y-1">
                  <div className="flex justify-between text-xs">
                    <span className="font-medium text-[#243B5A] truncate pr-2">{quan}</span>
                    <span className="text-muted-foreground">{count}</span>
                  </div>
                  <div className="h-1.5 overflow-hidden rounded-full bg-muted">
                    <div className="h-full rounded-full bg-[#4FA7A0]/70" style={{ width: `${percentage}%` }} />
                  </div>
                </div>
              );
            })}
          </CardContent>
        </Card>
      </div>
      </div>
    </div>
  );
}

// Form component for adding/editing toa nha
function ToaNhaForm({ 
  toaNha, 
  onClose, 
  onSuccess 
}: { 
  toaNha: ToaNha | null;
  onClose: () => void;
  onSuccess: () => void;
}) {
  const accessToken = useSession()?.data?.accessToken;
  const [formData, setFormData] = useState({
    tenToaNha: toaNha?.tenToaNha || '',
    soNha: toaNha?.diaChi.soNha || '',
    duong: toaNha?.diaChi.duong || '',
    phuong: toaNha?.diaChi.phuong || '',
    quan: toaNha?.diaChi.quan || '',
    thanhPho: toaNha?.diaChi.thanhPho || '',
    moTa: toaNha?.moTa || '',
    tienNghiChung: toaNha?.tienNghiChung || [],
    cheDoTaoPhong: 'NONE',
    soTang: '6',
    soPhongMoiTang: '10',
    dienTichMacDinh: '20',
    giaThueMacDinh: '2500000',
    tienCocMacDinh: '2500000',
    soNguoiToiDa: '2',
    tienNghiMacDinh: [] as string[],
  });
  const [cauTrucTang, setCauTrucTang] = useState([
    { soTang: '1', soPhong: '5', dienTichMacDinh: '20', giaThueMacDinh: '2500000', tienCocMacDinh: '2500000', soNguoiToiDa: '2' },
    { soTang: '2', soPhong: '8', dienTichMacDinh: '22', giaThueMacDinh: '2700000', tienCocMacDinh: '2700000', soNguoiToiDa: '2' },
  ]);

  const [provinces, setProvinces] = useState<{code: number, name: string}[]>([]);
  const [districts, setDistricts] = useState<{code: number, name: string}[]>([]);
  const [wards, setWards] = useState<{code: number, name: string}[]>([]);
  
  const [provinceCode, setProvinceCode] = useState<string>('');
  const [districtCode, setDistrictCode] = useState<string>('');

  const [openProvince, setOpenProvince] = useState(false);
  const [openDistrict, setOpenDistrict] = useState(false);
  const [openWard, setOpenWard] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleAutoFillCustomFloors = () => {
    const numFloors = parseInt(formData.soTang, 10);
    if (isNaN(numFloors) || numFloors <= 0) {
      toast.error('Vui lòng nhập số tầng hợp lệ lớn hơn 0 ở phần Cấu hình chung phía trên.');
      return;
    }
    if (numFloors > 200) {
      toast.error('Số tầng tối đa cho phép là 200 để đảm bảo hiệu suất.');
      return;
    }

    if (cauTrucTang.length > 0 && cauTrucTang.some(f => f.soTang || f.soPhong)) {
      if (!window.confirm(`Thao tác này sẽ ghi đè danh sách hiện tại bằng ${numFloors} tầng mới. Bạn có chắc chắn không?`)) {
        return;
      }
    }

    const newFloors = Array.from({ length: numFloors }).map((_, i) => ({
      soTang: String(i + 1),
      soPhong: formData.soPhongMoiTang || '',
      dienTichMacDinh: formData.dienTichMacDinh || '',
      giaThueMacDinh: formData.giaThueMacDinh || '',
      tienCocMacDinh: formData.tienCocMacDinh || '',
      soNguoiToiDa: formData.soNguoiToiDa || '',
    }));

    setCauTrucTang(newFloors);
    toast.success(`Đã tự động điền danh sách ${numFloors} tầng.`);
  };

  useEffect(() => {
    fetch('https://provinces.open-api.vn/api/v1/p/')
      .then(res => res.json())
      .then(data => {
        setProvinces(data);
        if (formData.thanhPho) {
          const normalizeStr = (s: string) => {
            const normalized = s.toLowerCase().replace(/thành phố|tỉnh|tp\s*|quận|huyện|phường|xã|q\.|h\.|p\./gi, '').trim();
            if (normalized === 'hcm') return 'hồ chí minh';
            return normalized;
          };
          const target = normalizeStr(formData.thanhPho);
          const p = data.find((x: {name: string, code: number}) => {
             const name = normalizeStr(x.name);
             return name === target || name.includes(target) || target.includes(name);
          });
          if (p) {
             setProvinceCode(String(p.code));
             setFormData(prev => ({ ...prev, thanhPho: p.name }));
          }
        }
      })
      .catch(err => console.error("Error fetching provinces:", err));
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    if (provinceCode) {
      fetch(`https://provinces.open-api.vn/api/v1/p/${provinceCode}?depth=2`)
        .then(res => res.json())
        .then(data => {
          setDistricts(data.districts || []);
          if (formData.quan && data.districts) {
            const normalizeStr = (s: string) => s.toLowerCase().replace(/thành phố|tỉnh|tp\s*|quận|huyện|phường|xã|q\.|h\.|p\./gi, '').trim();
            const target = normalizeStr(formData.quan);
            const d = data.districts.find((x: {name: string, code: number}) => {
               const name = normalizeStr(x.name);
               return name === target || name.includes(target) || target.includes(name);
            });
            if (d) {
               setDistrictCode(String(d.code));
               setFormData(prev => ({ ...prev, quan: d.name }));
            }
          }
        })
        .catch(err => console.error("Error fetching districts:", err));
    } else {
      setDistricts([]);
      setDistrictCode('');
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [provinceCode]);

  useEffect(() => {
    if (districtCode) {
      fetch(`https://provinces.open-api.vn/api/v1/d/${districtCode}?depth=2`)
        .then(res => res.json())
        .then(data => {
          setWards(data.wards || []);
          if (formData.phuong && data.wards) {
            const normalizeStr = (s: string) => s.toLowerCase().replace(/thành phố|tỉnh|tp\s*|quận|huyện|phường|xã|q\.|h\.|p\./gi, '').trim();
            const target = normalizeStr(formData.phuong);
            const w = data.wards.find((x: {name: string, code: number}) => {
               const name = normalizeStr(x.name);
               return name === target || name.includes(target) || target.includes(name);
            });
            if (w) {
               setFormData(prev => ({ ...prev, phuong: w.name }));
            }
          }
        })
        .catch(err => console.error("Error fetching wards:", err));
    } else {
      setWards([]);
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [districtCode]);

  const handleProvinceChange = (codeStr: string) => {
    const p = provinces.find(x => String(x.code) === codeStr);
    setProvinceCode(codeStr);
    setFormData(prev => ({ 
      ...prev, 
      thanhPho: p?.name || '',
      quan: '', 
      phuong: ''
    }));
    setDistrictCode('');
  };

  const handleDistrictChange = (codeStr: string) => {
    const d = districts.find(x => String(x.code) === codeStr);
    setDistrictCode(codeStr);
    setFormData(prev => ({ 
      ...prev, 
      quan: d?.name || '',
      phuong: '' 
    }));
  };

  const handleWardChange = (name: string) => {
    setFormData(prev => ({ ...prev, phuong: name }));
  };

  const tienNghiOptions = [
    { value: 'wifi', label: 'WiFi' },
    { value: 'camera', label: 'Camera an ninh' },
    { value: 'baoVe', label: 'Bảo vệ 24/7' },
    { value: 'giuXe', label: 'Giữ xe' },
    { value: 'thangMay', label: 'Thang máy' },
    { value: 'sanPhoi', label: 'Sân phơi' },
    { value: 'nhaVeSinhChung', label: 'Nhà vệ sinh chung' },
    { value: 'khuBepChung', label: 'Khu bếp chung' },
  ];

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (isSubmitting) return;
    
    if (!toaNha && formData.cheDoTaoPhong !== 'NONE') {
      if (formData.cheDoTaoPhong === 'FIXED') {
        if (Number(formData.soTang) <= 0 || Number(formData.soPhongMoiTang) <= 0) {
          toast.error('Số tầng và số phòng mỗi tầng phải lớn hơn 0');
          return;
        }
      } else if (formData.cheDoTaoPhong === 'CUSTOM') {
        if (cauTrucTang.length === 0) {
          toast.error('Vui lòng thêm ít nhất 1 tầng');
          return;
        }
        const invalidFloor = cauTrucTang.find(f => Number(f.soTang) <= 0 || Number(f.soPhong) <= 0);
        if (invalidFloor) {
          toast.error('Số tầng và số phòng của mỗi tầng phải lớn hơn 0');
          return;
        }
      }
    }

    setIsSubmitting(true);
    try {
      const submitData = {
        tenToaNha: formData.tenToaNha,
        diaChi: {
          soNha: formData.soNha,
          duong: formData.duong,
          phuong: formData.phuong,
          quan: formData.quan,
          thanhPho: formData.thanhPho,
        },
        moTa: formData.moTa,
        tienNghiChung: formData.tienNghiChung,
        ...(toaNha || formData.cheDoTaoPhong === 'NONE' ? {} : formData.cheDoTaoPhong === 'CUSTOM' ? {
          cheDoTaoPhong: 'CUSTOM',
          dienTichMacDinh: Number(formData.dienTichMacDinh),
          giaThueMacDinh: Number(formData.giaThueMacDinh),
          tienCocMacDinh: Number(formData.tienCocMacDinh),
          soNguoiToiDa: Number(formData.soNguoiToiDa),
          cauTrucTang: cauTrucTang.map((floor) => ({
            soTang: Number(floor.soTang),
            soPhong: Number(floor.soPhong),
            dienTichMacDinh: Number(floor.dienTichMacDinh),
            giaThueMacDinh: Number(floor.giaThueMacDinh),
            tienCocMacDinh: Number(floor.tienCocMacDinh),
            soNguoiToiDa: Number(floor.soNguoiToiDa),
          })),
          tienNghiMacDinh: formData.tienNghiMacDinh,
        } : {
          cheDoTaoPhong: formData.cheDoTaoPhong,
          soTang: Number(formData.soTang),
          soPhongMoiTang: Number(formData.soPhongMoiTang),
          dienTichMacDinh: Number(formData.dienTichMacDinh),
          giaThueMacDinh: Number(formData.giaThueMacDinh),
          tienCocMacDinh: Number(formData.tienCocMacDinh),
          soNguoiToiDa: Number(formData.soNguoiToiDa),
          tienNghiMacDinh: formData.tienNghiMacDinh,
        }),
      };

      const url = toaNha ? `/api/toa-nha/${toaNha._id}` : '/api/toa-nha';
      const method = toaNha ? 'PUT' : 'POST';

      const response = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
          ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
        },
        body: JSON.stringify(submitData),
      });

      if (response.ok) {
        const result = await response.json();
        if (result.success) {
          onSuccess();
        } else {
          toast.error(result.message || 'Có lỗi xảy ra');
        }
      } else {
        let errorMsg = 'Có lỗi xảy ra từ máy chủ (HTTP ' + response.status + ')';
        try {
          const text = await response.text();
          try {
            const error = JSON.parse(text);
            errorMsg = error.message || errorMsg;
          } catch (e) {
            console.error("Server trả về lỗi không phải JSON:", text);
            if (text.includes("Internal Server Error")) {
              errorMsg = "Lỗi hệ thống máy chủ (Internal Server Error). Vui lòng kiểm tra dữ liệu hoặc liên hệ admin.";
            }
          }
        } catch (e) {}
        toast.error(errorMsg);
      }
    } catch (error) {
      console.error('Error submitting form:', error);
      toast.error('Có lỗi xảy ra khi gửi form');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleTienNghiChange = (tienNghi: string, checked: boolean) => {
    setFormData(prev => ({
      ...prev,
      tienNghiChung: checked 
        ? [...prev.tienNghiChung, tienNghi]
        : prev.tienNghiChung.filter(t => t !== tienNghi)
    }));
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-3 md:space-y-4">
      <div className="space-y-2">
        <Label htmlFor="tenToaNha" className="text-sm">Tên tòa nhà</Label>
        <Input
          id="tenToaNha"
          value={formData.tenToaNha}
          onChange={(e) => setFormData(prev => ({ ...prev, tenToaNha: e.target.value }))}
          required
          className="text-sm"
        />
      </div>

      <div className="space-y-2">
        <Label htmlFor="thanhPho" className="text-sm">Tỉnh / Thành phố</Label>
        <Popover open={openProvince} onOpenChange={setOpenProvince} modal={true}>
          <PopoverTrigger asChild>
            <Button
              variant="outline"
              role="combobox"
              aria-expanded={openProvince}
              className="w-full justify-between text-sm font-normal bg-white"
            >
              {provinceCode
                ? provinces.find((p) => String(p.code) === provinceCode)?.name
                : (formData.thanhPho || "Chọn Tỉnh/Thành phố")}
              <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
            </Button>
          </PopoverTrigger>
          <PopoverContent className="w-[var(--radix-popover-trigger-width)] p-0 h-[300px]" align="start">
            <Command>
              <CommandInput placeholder="Tìm Tỉnh/Thành phố..." className="text-sm" />
              <CommandList className="max-h-[260px]">
                <CommandEmpty>Không tìm thấy.</CommandEmpty>
                <CommandGroup>
                  {provinces.map((p) => (
                    <CommandItem
                      key={p.code}
                      value={p.name}
                      onSelect={() => {
                        handleProvinceChange(String(p.code));
                        setOpenProvince(false);
                      }}
                      onMouseDown={(e) => {
                        e.preventDefault();
                        e.stopPropagation();
                        handleProvinceChange(String(p.code));
                        setOpenProvince(false);
                      }}
                    >
                      <Check
                        className={cn(
                          "mr-2 h-4 w-4",
                          provinceCode === String(p.code) ? "opacity-100" : "opacity-0"
                        )}
                      />
                      {p.name}
                    </CommandItem>
                  ))}
                </CommandGroup>
              </CommandList>
            </Command>
          </PopoverContent>
        </Popover>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-3 md:gap-4">
        <div className="space-y-2">
          <Label htmlFor="quan" className="text-sm">Quận / Huyện</Label>
          <Popover open={openDistrict} onOpenChange={setOpenDistrict} modal={true}>
            <PopoverTrigger asChild>
              <Button
                variant="outline"
                role="combobox"
                aria-expanded={openDistrict}
                className="w-full justify-between text-sm font-normal bg-white"
                disabled={!provinceCode}
              >
                {districtCode
                  ? districts.find((d) => String(d.code) === districtCode)?.name
                  : (formData.quan || "Chọn Quận/Huyện")}
                <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
              </Button>
            </PopoverTrigger>
            <PopoverContent className="w-[var(--radix-popover-trigger-width)] p-0 h-[300px]" align="start">
              <Command>
                <CommandInput placeholder="Tìm Quận/Huyện..." className="text-sm" />
                <CommandList className="max-h-[260px]">
                  <CommandEmpty>Không tìm thấy.</CommandEmpty>
                  <CommandGroup>
                    {districts.map((d) => (
                      <CommandItem
                        key={d.code}
                        value={d.name}
                        onSelect={() => {
                          handleDistrictChange(String(d.code));
                          setOpenDistrict(false);
                        }}
                        onMouseDown={(e) => {
                          e.preventDefault();
                          e.stopPropagation();
                          handleDistrictChange(String(d.code));
                          setOpenDistrict(false);
                        }}
                      >
                        <Check
                          className={cn(
                            "mr-2 h-4 w-4",
                            districtCode === String(d.code) ? "opacity-100" : "opacity-0"
                          )}
                        />
                        {d.name}
                      </CommandItem>
                    ))}
                  </CommandGroup>
                </CommandList>
              </Command>
            </PopoverContent>
          </Popover>
        </div>
        
        <div className="space-y-2">
          <Label htmlFor="phuong" className="text-sm">Phường / Xã</Label>
          <Popover open={openWard} onOpenChange={setOpenWard} modal={true}>
            <PopoverTrigger asChild>
              <Button
                variant="outline"
                role="combobox"
                aria-expanded={openWard}
                className="w-full justify-between text-sm font-normal bg-white"
                disabled={!districtCode}
              >
                {formData.phuong || "Chọn Phường/Xã"}
                <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
              </Button>
            </PopoverTrigger>
            <PopoverContent className="w-[var(--radix-popover-trigger-width)] p-0 h-[300px]" align="start">
              <Command>
                <CommandInput placeholder="Tìm Phường/Xã..." className="text-sm" />
                <CommandList className="max-h-[260px]">
                  <CommandEmpty>Không tìm thấy.</CommandEmpty>
                  <CommandGroup>
                    {wards.map((w) => (
                      <CommandItem
                        key={w.code}
                        value={w.name}
                        onSelect={() => {
                          handleWardChange(w.name);
                          setOpenWard(false);
                        }}
                        onMouseDown={(e) => {
                          e.preventDefault();
                          e.stopPropagation();
                          handleWardChange(w.name);
                          setOpenWard(false);
                        }}
                      >
                        <Check
                          className={cn(
                            "mr-2 h-4 w-4",
                            formData.phuong === w.name ? "opacity-100" : "opacity-0"
                          )}
                        />
                        {w.name}
                      </CommandItem>
                    ))}
                  </CommandGroup>
                </CommandList>
              </Command>
            </PopoverContent>
          </Popover>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-3 md:gap-4">
        <div className="space-y-2">
          <Label htmlFor="duong" className="text-sm">Tên đường</Label>
          <Input
            id="duong"
            value={formData.duong}
            onChange={(e) => setFormData(prev => ({ ...prev, duong: e.target.value }))}
            placeholder="Ví dụ: Nguyễn Trãi"
            required
            className="text-sm"
          />
        </div>
        
        <div className="space-y-2">
          <Label htmlFor="soNha" className="text-sm">Số nhà</Label>
          <Input
            id="soNha"
            value={formData.soNha}
            onChange={(e) => setFormData(prev => ({ ...prev, soNha: e.target.value }))}
            placeholder="Ví dụ: 19"
            required
            className="text-sm"
          />
        </div>
      </div>

      <div className="space-y-2">
        <Label htmlFor="moTa" className="text-sm">Mô tả</Label>
        <Textarea
          id="moTa"
          value={formData.moTa}
          onChange={(e) => setFormData(prev => ({ ...prev, moTa: e.target.value }))}
          rows={3}
          className="text-sm"
        />
      </div>

      <div className="space-y-2">
        <Label className="text-sm">Tiện nghi chung</Label>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-2">
          {tienNghiOptions.map((option) => (
            <div key={option.value} className="flex items-center space-x-2">
              <input
                type="checkbox"
                id={option.value}
                checked={formData.tienNghiChung.includes(option.value)}
                onChange={(e) => handleTienNghiChange(option.value, e.target.checked)}
                className="rounded border-gray-300"
              />
              <Label htmlFor={option.value} className="text-sm">
                {option.label}
              </Label>
            </div>
          ))}
        </div>
      </div>

      {!toaNha && (
        <div className="space-y-3 rounded-lg border p-3">
          <div>
            <Label className="text-sm">Tạo phòng nhanh</Label>
            <Select
              value={formData.cheDoTaoPhong}
              onValueChange={(value) => setFormData(prev => ({ ...prev, cheDoTaoPhong: value }))}
            >
              <SelectTrigger className="mt-2">
                <SelectValue placeholder="Chọn chế độ" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="NONE">Chỉ tạo tòa nhà</SelectItem>
                <SelectItem value="FIXED">Tạo tầng/phòng cố định</SelectItem>
                <SelectItem value="CUSTOM">Tùy chỉnh từng tầng (Tầng có số phòng khác nhau)</SelectItem>
              </SelectContent>
            </Select>
            <p className="mt-1 text-xs text-muted-foreground">
              Gợi ý: Chọn "Tùy chỉnh từng tầng" nếu tầng 2 có 3 phòng, tầng 3 có 6 phòng,...
            </p>
          </div>

          {formData.cheDoTaoPhong === 'FIXED' && (
            <div className="grid grid-cols-1 gap-3 md:grid-cols-2">
              <div className="space-y-2">
                <Label htmlFor="soTang" className="text-sm">Số tầng</Label>
                <Input id="soTang" type="number" min={1} value={formData.soTang} onChange={(e) => setFormData(prev => ({ ...prev, soTang: e.target.value }))} />
              </div>
              <div className="space-y-2">
                <Label htmlFor="soPhongMoiTang" className="text-sm">Phòng mỗi tầng</Label>
                <Input id="soPhongMoiTang" type="number" min={1} value={formData.soPhongMoiTang} onChange={(e) => setFormData(prev => ({ ...prev, soPhongMoiTang: e.target.value }))} />
              </div>
              <div className="space-y-2">
                <Label htmlFor="dienTichMacDinh" className="text-sm">Diện tích mặc định</Label>
                <Input id="dienTichMacDinh" type="number" min={1} value={formData.dienTichMacDinh} onChange={(e) => setFormData(prev => ({ ...prev, dienTichMacDinh: e.target.value }))} />
              </div>
              <div className="space-y-2">
                <Label htmlFor="soNguoiToiDa" className="text-sm">Số người tối đa</Label>
                <Input id="soNguoiToiDa" type="number" min={1} value={formData.soNguoiToiDa} onChange={(e) => setFormData(prev => ({ ...prev, soNguoiToiDa: e.target.value }))} />
              </div>
              <div className="space-y-2">
                <Label htmlFor="giaThueMacDinh" className="text-sm">Giá thuê mặc định</Label>
                <Input id="giaThueMacDinh" type="number" min={0} value={formData.giaThueMacDinh} onChange={(e) => setFormData(prev => ({ ...prev, giaThueMacDinh: e.target.value }))} />
              </div>
              <div className="space-y-2">
                <Label htmlFor="tienCocMacDinh" className="text-sm">Tiền cọc mặc định</Label>
                <Input id="tienCocMacDinh" type="number" min={0} value={formData.tienCocMacDinh} onChange={(e) => setFormData(prev => ({ ...prev, tienCocMacDinh: e.target.value }))} />
              </div>

              <div className="rounded-md bg-muted p-3 text-sm md:col-span-2">
                Dự kiến tạo {Number(formData.soTang || 0) * Number(formData.soPhongMoiTang || 0)} phòng, Tên phòng dạng Phòng 101, Phòng 102...
              </div>
            </div>
          )}

          {formData.cheDoTaoPhong === 'CUSTOM' && (
            <div className="space-y-3">
              <div className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                <div className="text-sm text-muted-foreground">
                  Cấu hình số phòng, diện tích và giá riêng cho từng tầng.
                  <br className="hidden sm:block" />
                  <span className="text-blue-600 font-medium">Giải quyết vấn đề: Tầng 2 có 3 phòng, tầng 3 có 6 phòng,...</span>
                </div>
                <div className="flex gap-2">
                  <Button
                    type="button"
                    variant="secondary"
                    size="sm"
                    onClick={handleAutoFillCustomFloors}
                  >
                    Tự động điền {formData.soTang || 'N'} tầng
                  </Button>
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    onClick={() => setCauTrucTang(prev => [
                      ...prev,
                      {
                        soTang: String(prev.length + 1),
                        soPhong: formData.soPhongMoiTang,
                        dienTichMacDinh: formData.dienTichMacDinh,
                        giaThueMacDinh: formData.giaThueMacDinh,
                        tienCocMacDinh: formData.tienCocMacDinh,
                        soNguoiToiDa: formData.soNguoiToiDa,
                      },
                    ])}
                  >
                    <Plus className="mr-2 h-4 w-4" />
                    Thêm tầng
                  </Button>
                </div>
              </div>

              <div className="space-y-2 max-h-[50vh] overflow-y-auto pr-2 pb-2">
                {cauTrucTang.map((floor, index) => (
                  <div key={index} className="grid grid-cols-2 gap-2 rounded-md border p-3 md:grid-cols-7">
                    <div className="space-y-1">
                      <Label className="text-xs">Tầng</Label>
                      <Input
                        type="number"
                        min={0}
                        value={floor.soTang}
                        onChange={(e) => setCauTrucTang(prev => prev.map((item, i) => i === index ? { ...item, soTang: e.target.value } : item))}
                      />
                    </div>
                    <div className="space-y-1">
                      <Label className="text-xs">Phòng</Label>
                      <Input
                        type="number"
                        min={1}
                        value={floor.soPhong}
                        onChange={(e) => setCauTrucTang(prev => prev.map((item, i) => i === index ? { ...item, soPhong: e.target.value } : item))}
                      />
                    </div>
                    <div className="space-y-1">
                      <Label className="text-xs">Diện tích</Label>
                      <Input
                        type="number"
                        min={1}
                        value={floor.dienTichMacDinh}
                        onChange={(e) => setCauTrucTang(prev => prev.map((item, i) => i === index ? { ...item, dienTichMacDinh: e.target.value } : item))}
                      />
                    </div>
                    <div className="space-y-1 md:col-span-2">
                      <Label className="text-xs">Giá thuê</Label>
                      <Input
                        type="number"
                        min={0}
                        value={floor.giaThueMacDinh}
                        onChange={(e) => setCauTrucTang(prev => prev.map((item, i) => i === index ? { ...item, giaThueMacDinh: e.target.value } : item))}
                      />
                    </div>
                    <div className="space-y-1">
                      <Label className="text-xs">Số người</Label>
                      <Input
                        type="number"
                        min={1}
                        value={floor.soNguoiToiDa}
                        onChange={(e) => setCauTrucTang(prev => prev.map((item, i) => i === index ? { ...item, soNguoiToiDa: e.target.value } : item))}
                      />
                    </div>
                    <div className="flex items-end">
                      <Button
                        type="button"
                        variant="outline"
                        size="sm"
                        disabled={cauTrucTang.length <= 1}
                        onClick={() => setCauTrucTang(prev => prev.filter((_, i) => i !== index))}
                        className="w-full"
                      >
                        Xóa
                      </Button>
                    </div>
                  </div>
                ))}
              </div>

              <div className="rounded-md bg-muted p-3 text-sm">
                Dự kiến tạo {cauTrucTang.reduce((sum, floor) => sum + Number(floor.soPhong || 0), 0)} phòng theo cấu trúc tùy chỉnh.
              </div>
            </div>
          )}

          {formData.cheDoTaoPhong !== 'NONE' && (
            <div className="space-y-2 rounded-lg border p-3 mt-3">
              <Label className="text-sm font-semibold text-gray-700">Tiện nghi áp dụng cho tất cả các phòng mới sinh</Label>
              <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-3 bg-gray-50/50 p-4 border border-dashed rounded-lg">
                {[
                  { value: 'dieuhoa', label: 'Điều hòa' },
                  { value: 'nonglanh', label: 'Nóng lạnh' },
                  { value: 'tulanh', label: 'Tủ lạnh' },
                  { value: 'giuong', label: 'Giường' },
                  { value: 'tuquanao', label: 'Tủ quần áo' },
                  { value: 'banlamviec', label: 'Bàn làm việc' },
                  { value: 'ghe', label: 'Ghế' },
                  { value: 'tivi', label: 'TV' },
                  { value: 'wifi', label: 'WiFi' },
                  { value: 'maygiat', label: 'Máy giặt' },
                  { value: 'bep', label: 'Bếp' }
                ].map((option) => (
                  <div key={option.value} className="flex items-center space-x-2.5 py-1">
                    <input
                      type="checkbox"
                      id={`phong-tn-${option.value}`}
                      checked={formData.tienNghiMacDinh.includes(option.label)}
                      onChange={(e) => {
                        const checked = e.target.checked;
                        setFormData(prev => ({
                          ...prev,
                          tienNghiMacDinh: checked
                            ? [...prev.tienNghiMacDinh, option.label]
                            : prev.tienNghiMacDinh.filter(t => t !== option.label)
                        }));
                      }}
                      className="rounded border-gray-300 h-4 w-4 accent-blue-600 cursor-pointer"
                    />
                    <Label htmlFor={`phong-tn-${option.value}`} className="text-sm font-medium text-gray-600 hover:text-gray-900 cursor-pointer select-none">
                      {option.label}
                    </Label>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      )}

      <DialogFooter className="gap-2">
        <Button type="button" variant="outline" onClick={onClose} className="text-sm">
          Hủy
        </Button>
        <Button type="submit" className="text-sm" disabled={isSubmitting}>
          {isSubmitting ? 'Đang xử lý...' : (toaNha ? 'Cập nhật' : 'Thêm mới')}
        </Button>
      </DialogFooter>
    </form>
  );
}
