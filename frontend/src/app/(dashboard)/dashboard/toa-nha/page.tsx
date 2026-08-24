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
import { ConfirmActionDialog } from '@/components/ui/confirm-action-dialog';

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
  Columns,
  Trash2
} from 'lucide-react';
import { cn } from '@/lib/utils';
import * as XLSX from 'xlsx';

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
const removeVietnameseTones = (str: string) => {
  if (!str || typeof str !== 'string') return '';
  let result = str;
  result = result.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a");
  result = result.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e");
  result = result.replace(/ì|í|ị|ỉ|ĩ/g, "i");
  result = result.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o");
  result = result.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, "u");
  result = result.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, "y");
  result = result.replace(/đ/g, "d");
  result = result.replace(/À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ/g, "A");
  result = result.replace(/È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ/g, "E");
  result = result.replace(/Ì|Í|Ị|Ỉ|Ĩ/g, "I");
  result = result.replace(/Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|MỠ/g, "O");
  result = result.replace(/Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ/g, "U");
  result = result.replace(/Ỳ|Ý|Ỵ|Ỷ|Ỹ/g, "Y");
  result = result.replace(/Đ/g, "D");
  result = result.replace(/\u0300|\u0301|\u0303|\u0309|\u0323/g, "");
  result = result.replace(/\u02C6|\u0306|\u031B/g, "");
  result = result.replace(/ + /g, " ");
  return result.trim().toLowerCase();
};

const customFilter = (value: string, search: string) => {
  if (!value || typeof value !== 'string') return 0;
  if (!search || typeof search !== 'string') return 1;
  if (value.toLowerCase().includes(search.toLowerCase())) return 1;
  const normalizedValue = removeVietnameseTones(value);
  const normalizedSearch = removeVietnameseTones(search);
  if (normalizedValue.includes(normalizedSearch)) return 1;
  return 0;
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

  const downloadImportTemplate = () => {
    const rows = [['ten_toa_nha', 'dia_chi', 'tang', 'ma_phong', 'dien_tich', 'gia_thue', 'tien_coc', 'so_nguoi_toi_da'], ['Tòa A', '123 Nguyễn Trãi', 1, '101', 20, 2500000, 2500000, 2]];
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, XLSX.utils.aoa_to_sheet(rows), 'ToaNha');
    XLSX.writeFile(workbook, 'mau-import-toa-nha.xlsx');
  };

  const readImportFile = async (file: File) => {
    const workbook = XLSX.read(await file.arrayBuffer(), { type: 'array' });
    const sheet = workbook.Sheets[workbook.SheetNames[0]];
    const rows = XLSX.utils.sheet_to_json(sheet, { header: 1, defval: '' }) as unknown[][];
    setImportText(rows.map(row => row.map(cell => String(cell ?? '').trim()).join('\t')).join('\n'));
    setImportPreview(null);
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
    <div className="space-y-4 md:space-y-6 pb-10 bg-slate-50 min-h-screen">
      {/* ── BREADCRUMB / TOP BARS ── */}
      <div className="flex items-center text-sm text-gray-500 mb-2">
        <span>Danh mục dữ liệu</span>
        <span className="mx-2">&gt;</span>
        <span className="font-semibold text-gray-900">Tòa nhà</span>
      </div>

      {/* ── KPI CARDS ── */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Card className="shadow-sm border border-[#E8DCCB] rounded-xl">
          <CardContent className="p-4 flex flex-col justify-between h-24 relative overflow-hidden">
            <div className="absolute left-4 top-1/2 -translate-y-1/2">
              <div className="bg-blue-50 text-blue-500 p-3 rounded-full border border-blue-100 flex items-center justify-center">
                <Building2 className="w-6 h-6" />
              </div>
            </div>
            <div className="text-right z-10 w-full flex flex-col items-end justify-center h-full">
              <div className="text-2xl font-bold text-blue-600">{totalElements}</div>
              <div className="text-xs text-blue-500 uppercase tracking-wide mt-1 font-medium">Tất cả tòa nhà</div>
            </div>
          </CardContent>
        </Card>
        <Card className="shadow-sm border border-[#E8DCCB] rounded-xl">
          <CardContent className="p-4 flex flex-col justify-between h-24 relative overflow-hidden">
            <div className="absolute left-4 top-1/2 -translate-y-1/2">
              <div className="bg-emerald-50 text-emerald-500 p-3 rounded-full border border-emerald-100 flex items-center justify-center">
                <Building2 className="w-6 h-6" />
              </div>
            </div>
            <div className="text-right z-10 w-full flex flex-col items-end justify-center h-full">
              <div className="text-2xl font-bold text-emerald-600">{totalElements}</div>
              <div className="text-xs text-emerald-500 uppercase tracking-wide mt-1 font-medium">Đang hoạt động</div>
            </div>
          </CardContent>
        </Card>
        <Card className="shadow-sm border border-[#E8DCCB] rounded-xl">
          <CardContent className="p-4 flex flex-col justify-between h-24 relative overflow-hidden">
            <div className="absolute left-4 top-1/2 -translate-y-1/2">
              <div className="bg-red-50 text-red-500 p-3 rounded-full border border-red-100 flex items-center justify-center">
                <Building2 className="w-6 h-6" />
              </div>
            </div>
            <div className="text-right z-10 w-full flex flex-col items-end justify-center h-full">
              <div className="text-2xl font-bold text-red-600">0</div>
              <div className="text-xs text-red-500 uppercase tracking-wide mt-1 font-medium">Ngưng hoạt động</div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* ── CONTENT AREA ── */}
      <Card className="shadow-sm border-t-0 rounded-t-none md:rounded-t-lg md:border-t rounded-xl overflow-hidden mt-4">
        <div className="p-4 border-b border-gray-100 flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white">
          {/* Filters */}
          <div className="flex flex-wrap items-center gap-3 w-full md:w-auto">
            <div className="relative w-full md:w-auto">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
              <Input
                placeholder="Tìm kiếm"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-9 text-sm w-full md:w-[200px]"
              />
            </div>
            <Select>
              <SelectTrigger className="w-[180px] text-sm text-gray-500">
                <SelectValue placeholder="Trạng thái hoạt động" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">Tất cả</SelectItem>
                <SelectItem value="active">Đang hoạt động</SelectItem>
                <SelectItem value="inactive">Ngưng hoạt động</SelectItem>
              </SelectContent>
            </Select>
            <Select>
              <SelectTrigger className="w-[150px] text-sm text-gray-500 flex items-center gap-2">
                <MapPin className="w-4 h-4 mr-1" />
                <SelectValue placeholder="Khu vực" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">Tất cả</SelectItem>
              </SelectContent>
            </Select>
          </div>

          {/* Actions */}
          <div className="flex items-center gap-2">
            <Button size="icon" onClick={() => { setEditingToaNha(null); setIsDialogOpen(true); }} className="bg-emerald-600 hover:bg-emerald-700 h-9 w-9 text-white">
              <Plus className="h-4 w-4" />
            </Button>
            <Button size="icon" variant="outline" onClick={downloadImportTemplate} title="Tải file Excel mẫu" className="border-amber-400 text-amber-500 hover:bg-amber-50 h-9 w-9">
              <FileUp className="h-4 w-4 rotate-180" />
            </Button>
            <Button size="icon" variant="outline" onClick={() => setIsImportOpen(true)} title="Nhập từ Excel" className="border-emerald-400 text-emerald-500 hover:bg-emerald-50 h-9 w-9">
              <FileUp className="h-4 w-4" />
            </Button>
            <Button size="icon" variant="outline" className="border-blue-500 text-white bg-blue-600 hover:bg-blue-700 h-9 w-9">
              <Columns className="h-4 w-4" />
            </Button>
          </div>
        </div>

        {/* Dialogs */}
        <Dialog open={isImportOpen} onOpenChange={setIsImportOpen}>
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
              <Input type="file" accept=".xlsx,.xls,.csv" onChange={async (e) => { const file = e.target.files?.[0]; if (file) await readImportFile(file); }} />
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
          <DialogContent className="flex max-h-[calc(100vh-48px)] max-w-[calc(100vw-24px)] flex-col overflow-hidden rounded-2xl border border-[#E8DCCB] bg-[#FFFBF5] p-0 shadow-[0_24px_70px_rgba(36,59,90,0.24)] sm:max-w-3xl">
            <DialogHeader className="border-b border-[#E8DCCB]/80 px-5 py-4 sm:px-6">
              <DialogTitle className="text-lg font-bold text-[#243B5A] md:text-xl">
                {editingToaNha ? 'Chỉnh sửa tòa nhà' : 'Thêm tòa nhà mới'}
              </DialogTitle>
              <DialogDescription className="text-sm text-[#5F7087]">
                {editingToaNha ? 'Cập nhật thông tin tòa nhà' : 'Nhập thông tin tòa nhà và cấu hình phòng ban đầu'}
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

        {/* Table */}
        <div className="w-full">
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
      </Card>
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
    maToa: (toaNha as any)?.maToa || '',
    hoatDong: toaNha?.trangThai !== 'INACTIVE',
    soNha: toaNha?.diaChi.soNha || '',
    duong: toaNha?.diaChi.duong || '',
    phuong: toaNha?.diaChi.phuong || '',
    quan: toaNha?.diaChi.quan || '',
    thanhPho: toaNha?.diaChi.thanhPho || '',
    viDo: toaNha?.viDo?.toString() || '',
    kinhDo: toaNha?.kinhDo?.toString() || '',
    googlePlaceId: toaNha?.googlePlaceId || '',
    moTa: toaNha?.moTa || '',
    tienNghiChung: toaNha?.tienNghiChung || ['camera', 'baoVe', 'giuXe', 'sanPhoi', 'nhaVeSinhChung', 'khuBepChung'],
    cheDoTaoPhong: 'NONE',
    soTang: '6',
    soPhongMoiTang: '10',
    dienTichMacDinh: '20',
    giaThueMacDinh: '2500000',
    tienCocMacDinh: '2500000',
    soNguoiToiDa: '2',
    tienNghiMacDinh: [] as string[],
  });

  const [dichVuList, setDichVuList] = useState<any[]>([]);

  useEffect(() => {
    if (!accessToken) return;
    fetch('/api/dich-vu', {
      headers: { Authorization: `Bearer ${accessToken}` }
    })
      .then(res => res.json())
      .then((data: any) => {
        if (data.success) {
          const services = Array.isArray(data.data) ? data.data : (data.data?.data || data.data?.content || []);
          const initialList = services.map((dv: any) => ({
            id: dv._id || dv.id,
            ten: dv.tenDichVu,
            suDung: dv.batBuoc || false,
            donGia: dv.donGiaMacDinh || 0,
            donVi: dv.donVi || '',
            loaiTinhPhi: dv.loaiTinhPhi || 'FIXED',
            isCustom: false
          }));

          if (toaNha && (toaNha as any).dichVuList && Array.isArray((toaNha as any).dichVuList)) {
            const buildingServices = (toaNha as any).dichVuList;
            buildingServices.forEach((bService: any) => {
              const existing = initialList.find((s: any) => s.id === bService.id);
              if (existing) {
                existing.suDung = bService.suDung !== false;
                existing.donGia = bService.donGia;
                existing.loaiTinhPhi = bService.loaiTinhPhi;
                if (bService.donVi) existing.donVi = bService.donVi;
              } else {
                initialList.push({
                  id: bService.id,
                  ten: bService.ten,
                  suDung: bService.suDung !== false,
                  donGia: bService.donGia,
                  donVi: bService.donVi || '',
                  loaiTinhPhi: bService.loaiTinhPhi || 'FIXED',
                  isCustom: true
                });
              }
            });
            // For any global service not in buildingServices, if it's editing an existing building, 
            // it means it's turned off, unless it's batBuoc. But wait, if they turned it off, it's not in the DB.
            // We should set suDung = false for those.
            initialList.forEach((s: any) => {
              const inBuilding = buildingServices.find((b: any) => b.id === s.id);
              if (!inBuilding) {
                s.suDung = false; // Turn off if not in building's config
              }
            });
          }
          setDichVuList(initialList);
        }
      })
      .catch(err => console.error("Error fetching dich vu:", err));
  }, [accessToken]);

  const [isServiceModalOpen, setIsServiceModalOpen] = useState(false);
  const [newService, setNewService] = useState({
    ten: '',
    loaiTinhPhi: 'Cố định',
    donVi: '',
    donGia: '',
    batBuoc: false
  });

  const handleSaveService = () => {
    if (!newService.ten) return;
    setDichVuList(prev => [
      ...prev,
      {
        id: `custom-${Date.now()}`,
        ten: newService.ten,
        suDung: true,
        donGia: Number(newService.donGia) || 0,
        donVi: newService.donVi,
        loaiTinhPhi: newService.loaiTinhPhi,
        batBuoc: newService.batBuoc,
        isCustom: true
      }
    ]);
    setIsServiceModalOpen(false);
    setNewService({ ten: '', loaiTinhPhi: 'Cố định', donVi: '', donGia: '', batBuoc: false });
  };

  const [cauTrucTang, setCauTrucTang] = useState([
    { soTang: '1', soPhong: '5', dienTichMacDinh: '20', giaThueMacDinh: '2500000', tienCocMacDinh: '2500000', soNguoiToiDa: '2' },
    { soTang: '2', soPhong: '8', dienTichMacDinh: '22', giaThueMacDinh: '2700000', tienCocMacDinh: '2700000', soNguoiToiDa: '2' },
  ]);

  const [provinces, setProvinces] = useState<{ code: string, name: string }[]>([]);
  const [districts, setDistricts] = useState<{ code: string, name: string }[]>([]);
  const [wards, setWards] = useState<{ code: string, name: string }[]>([]);

  const [provinceCode, setProvinceCode] = useState<string>('');
  const [districtCode, setDistrictCode] = useState<string>('');

  const [openProvince, setOpenProvince] = useState(false);
  const [openDistrict, setOpenDistrict] = useState(false);
  const [openWard, setOpenWard] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const [isConfirmFillOpen, setIsConfirmFillOpen] = useState(false);
  const [pendingNumFloors, setPendingNumFloors] = useState<number>(0);

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
      setPendingNumFloors(numFloors);
      setIsConfirmFillOpen(true);
      return;
    }

    executeAutoFill(numFloors);
  };

  const executeAutoFill = (numFloors: number) => {
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
    setIsConfirmFillOpen(false);
  };

  useEffect(() => {
    fetch('https://esgoo.net/api-tinhthanh/1/0.htm')
      .then(res => res.json())
      .then(result => {
        if (result.error === 0) {
          const mappedProvinces = result.data.map((x: any) => ({ code: x.id, name: x.full_name }));
          setProvinces(mappedProvinces);
          const data = mappedProvinces;
          if (formData.thanhPho) {
            const normalizeStr = (s: string) => {
              const normalized = s.toLowerCase().replace(/thành phố|tỉnh|tp\s*|quận|huyện|phường|xã|q\.|h\.|p\./gi, '').trim();
              if (normalized === 'hcm') return 'hồ chí minh';
              return normalized;
            };
            const target = normalizeStr(formData.thanhPho);
            const p = data.find((x: { name: string, code: string }) => {
              const name = normalizeStr(x.name);
              return name === target || name.includes(target) || target.includes(name);
            });
            if (p) {
              setProvinceCode(String(p.code));
              setFormData(prev => ({ ...prev, thanhPho: p.name }));
            }
          }
        }
      })
      .catch(err => console.error("Error fetching provinces:", err));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    if (provinceCode) {
      fetch(`https://esgoo.net/api-tinhthanh/2/${provinceCode}.htm`)
        .then(res => res.json())
        .then(json => {
          if (json.error === 0 && Array.isArray(json.data)) {
            const nextDistricts = json.data.map((d: any) => ({ code: d.id, name: d.full_name }));
            setDistricts(nextDistricts);
            if (formData.quan && nextDistricts.length) {
              const normalizeStr = (s: string) => s.toLowerCase().replace(/thành phố|tỉnh|tp\s*|quận|huyện|phường|xã|q\.|h\.|p\./gi, '').trim();
              const target = normalizeStr(formData.quan);
              const district = nextDistricts.find((x: any) => {
                const name = normalizeStr(x.name);
                return name === target || name.includes(target) || target.includes(name);
              });
              if (district) {
                setDistrictCode(String(district.code));
                setFormData(prev => ({ ...prev, quan: district.name }));
              }
            }
          }
        })
        .catch(err => console.error("Error fetching districts:", err));
    } else {
      setDistricts([]);
      setWards([]);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [provinceCode]);

  useEffect(() => {
    if (districtCode) {
      fetch(`https://esgoo.net/api-tinhthanh/3/${districtCode}.htm`)
        .then(res => res.json())
        .then(json => {
          if (json.error === 0 && Array.isArray(json.data)) {
            const nextWards = json.data.map((w: any) => ({ code: w.id, name: w.full_name }));
            setWards(nextWards);
            if (formData.phuong && nextWards.length) {
              const normalizeStr = (s: string) => s.toLowerCase().replace(/thành phố|tỉnh|tp\s*|quận|huyện|phường|xã|q\.|h\.|p\./gi, '').trim();
              const target = normalizeStr(formData.phuong);
              const ward = nextWards.find((x: any) => {
                const name = normalizeStr(x.name);
                return name === target || name.includes(target) || target.includes(name);
              });
              if (ward) {
                setFormData(prev => ({ ...prev, phuong: ward.name }));
              }
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
    setDistrictCode('');
    setFormData(prev => ({
      ...prev,
      thanhPho: p?.name || '',
      quan: '',
      phuong: ''
    }));
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

  const DEFAULT_SERVICES = [
    { id: 'internet', ten: 'Internet', donGia: 100000, donVi: 'đ / tháng' },
    { id: 'guixe', ten: 'Gửi xe máy', donGia: 100000, donVi: 'đ / xe' },
    { id: 'dondep', ten: 'Dọn vệ sinh', donGia: 50000, donVi: 'đ / người' },
    { id: 'thangmay', ten: 'Thang máy', donGia: 50000, donVi: 'đ / người' },
    { id: 'maygiat', ten: 'Máy giặt chung', donGia: 50000, donVi: 'đ / người' },
  ];

  const tienNghiOptions = [
    { value: 'camera', label: 'Camera an ninh' },
    { value: 'baoVe', label: 'Bảo vệ 24/7' },
    { value: 'giuXe', label: 'Giữ xe' },
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
        maToa: formData.maToa,
        hoatDong: formData.hoatDong,
        dichVuList: dichVuList.filter(d => d.suDung),
        diaChi: {
          thanhPho: formData.thanhPho,
          quan: formData.quan,
          phuong: formData.phuong,
          duong: formData.duong,
          soNha: formData.soNha,
        },
        moTa: formData.moTa,
        viDo: formData.viDo === '' ? undefined : Number(formData.viDo),
        kinhDo: formData.kinhDo === '' ? undefined : Number(formData.kinhDo),
        googlePlaceId: formData.googlePlaceId || undefined,
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
        } catch (e) { }
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

  const fieldWrap = "space-y-1.5";
  const labelClass = "text-xs font-semibold uppercase tracking-wide text-[#243B5A]/75";
  const inputClass = "h-11 rounded-xl border-[#E2D6C8] bg-white/90 px-3 text-sm text-[#243B5A] shadow-sm transition placeholder:text-[#9B8F82] focus-visible:border-[#4FA7A0] focus-visible:ring-2 focus-visible:ring-[#4FA7A0]/18 focus-visible:ring-offset-0";
  const selectButtonClass = cn(inputClass, "w-full justify-between font-normal hover:bg-white");
  const popoverClass = "w-[var(--radix-popover-trigger-width)] overflow-hidden rounded-xl border-[#E2D6C8] p-0 shadow-xl";

  return (
    <form onSubmit={handleSubmit} className="flex min-h-0 flex-1 flex-col">
      <div className="min-h-0 flex-1 space-y-4 overflow-y-auto px-5 py-4 sm:px-6">
        {/* Thông tin cơ bản */}
        <div className="mb-2 font-semibold text-[#243B5A] flex items-center justify-between border-b border-[#E2D6C8] pb-2">
          <span>Thông tin cơ bản</span>
          <div className="flex items-center gap-2">
            <span className="text-sm font-medium text-[#5F7087]">Hoạt động</span>
            <label className="relative inline-flex items-center cursor-pointer">
              <input type="checkbox" className="sr-only peer" checked={formData.hoatDong} onChange={(e) => setFormData(prev => ({ ...prev, hoatDong: e.target.checked }))} />
              <div className="w-10 h-5 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-[#4FA7A0]"></div>
            </label>
          </div>
        </div>

        <div className="grid grid-cols-1 gap-3 md:grid-cols-2">
          <div className={fieldWrap}>
            <Label htmlFor="tenToaNha" className={labelClass}>Tên tòa nhà *</Label>
            <Input
              id="tenToaNha"
              value={formData.tenToaNha}
              onChange={(e) => setFormData(prev => ({ ...prev, tenToaNha: e.target.value }))}
              placeholder="Nhập tên toà nhà..."
              required
              className={inputClass}
            />
          </div>
          {/* <div className={fieldWrap}>
            <Label htmlFor="maToa" className={labelClass}>Tên viết tắt/Mã tòa</Label>
            <Input
              id="maToa"
              value={formData.maToa}
              onChange={(e) => setFormData(prev => ({ ...prev, maToa: e.target.value }))}
              placeholder="Nhập mã viết tắt..."
              className={inputClass}
            />
          </div> */}
        </div>

        {/* Thông tin địa chỉ */}
        <div className="mt-6 mb-2 font-semibold text-[#243B5A] border-b border-[#E2D6C8] pb-2">Thông tin địa chỉ</div>
        <div className="grid grid-cols-1 gap-3 md:grid-cols-2">
          <div className={fieldWrap}>
            <Label htmlFor="thanhPho" className={labelClass}>Tỉnh / Thành phố</Label>
            <Popover open={openProvince} onOpenChange={setOpenProvince} modal={true}>
              <PopoverTrigger asChild>
                <Button
                  variant="outline"
                  role="combobox"
                  aria-expanded={openProvince}
                  className={selectButtonClass}
                >
                  <span className="truncate">
                    {provinceCode
                      ? provinces.find((p) => String(p.code) === provinceCode)?.name
                      : (formData.thanhPho || "Chọn Tỉnh/Thành phố")}
                  </span>
                  <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 text-[#6D7B8E]" />
                </Button>
              </PopoverTrigger>
              <PopoverContent className={popoverClass} align="start" onOpenAutoFocus={(e) => e.preventDefault()} onPointerDown={(e) => e.stopPropagation()}>
                <Command filter={customFilter}>
                  <CommandInput placeholder="Tìm Tỉnh/Thành phố..." className="h-10 text-sm" autoFocus />
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
                          className="text-sm"
                        >
                          <Check
                            className={cn(
                              "mr-2 h-4 w-4 text-[#4FA7A0]",
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

          <div className={fieldWrap}>
            <Label htmlFor="quan" className={labelClass}>Quận / Huyện</Label>
            <Popover open={openDistrict} onOpenChange={setOpenDistrict} modal={true}>
              <PopoverTrigger asChild>
                <Button
                  variant="outline"
                  role="combobox"
                  aria-expanded={openDistrict}
                  className={selectButtonClass}
                  disabled={!provinceCode}
                >
                  <span className="truncate">{formData.quan || "Chọn Quận/Huyện"}</span>
                  <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 text-[#6D7B8E]" />
                </Button>
              </PopoverTrigger>
              <PopoverContent className={popoverClass} align="start" onOpenAutoFocus={(e) => e.preventDefault()} onPointerDown={(e) => e.stopPropagation()}>
                <Command filter={customFilter}>
                  <CommandInput placeholder="Tìm Quận/Huyện..." className="h-10 text-sm" autoFocus />
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
                              "mr-2 h-4 w-4 text-[#4FA7A0]",
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

          <div className={fieldWrap}>
            <Label htmlFor="phuong" className={labelClass}>Phường / Xã</Label>
            <Popover open={openWard} onOpenChange={setOpenWard} modal={true}>
              <PopoverTrigger asChild>
                <Button
                  variant="outline"
                  role="combobox"
                  aria-expanded={openWard}
                  className={selectButtonClass}
                  disabled={!districtCode}
                >
                  <span className="truncate">{formData.phuong || "Chọn Phường/Xã"}</span>
                  <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 text-[#6D7B8E]" />
                </Button>
              </PopoverTrigger>
              <PopoverContent className={popoverClass} align="start" onOpenAutoFocus={(e) => e.preventDefault()} onPointerDown={(e) => e.stopPropagation()}>
                <Command filter={customFilter}>
                  <CommandInput placeholder="Tìm Phường/Xã..." className="h-10 text-sm" autoFocus />
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
                              "mr-2 h-4 w-4 text-[#4FA7A0]",
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

        <div className="grid grid-cols-1 gap-3 md:grid-cols-2">
          <div className={fieldWrap}>
            <Label htmlFor="duong" className={labelClass}>Tên đường</Label>
            <Input
              id="duong"
              value={formData.duong}
              onChange={(e) => setFormData(prev => ({ ...prev, duong: e.target.value }))}
              placeholder="Ví dụ: Nguyễn Trãi"
              required
              className={inputClass}
            />
          </div>

          <div className={fieldWrap}>
            <Label htmlFor="soNha" className={labelClass}>Số nhà</Label>
            <Input
              id="soNha"
              value={formData.soNha}
              onChange={(e) => setFormData(prev => ({ ...prev, soNha: e.target.value }))}
              placeholder="Ví dụ: 19"
              required
              className={inputClass}
            />
          </div>
        </div>

        <section className="mt-4 rounded-xl border border-[#D8EAE6] bg-[#EEF8F5] p-4">
          <p className="text-sm font-semibold text-[#243B5A]">Vị trí Google Maps</p>
          <p className="mt-1 text-xs text-[#6D7B8E]">Dán link Google Maps để tự động trích xuất tọa độ.</p>
          <div className="mt-3 space-y-3">
            <div className={fieldWrap}>
              <Label htmlFor="mapLink" className={labelClass}>Link Google Maps</Label>
              <Input 
                id="mapLink" 
                onChange={(e) => {
                  const url = e.target.value;
                  const regex1 = /@(-?\d+\.\d+),(-?\d+\.\d+)/;
                  const match1 = url.match(regex1);
                  if (match1) {
                    setFormData(prev => ({ ...prev, viDo: match1[1], kinhDo: match1[2] }));
                    return;
                  }
                  const regex2 = /!3d(-?\d+\.\d+)!4d(-?\d+\.\d+)/;
                  const match2 = url.match(regex2);
                  if (match2) {
                    setFormData(prev => ({ ...prev, viDo: match2[1], kinhDo: match2[2] }));
                    return;
                  }
                  const regex3 = /[?&]q=(-?\d+\.\d+),(-?\d+\.\d+)/;
                  const match3 = url.match(regex3);
                  if (match3) {
                    setFormData(prev => ({ ...prev, viDo: match3[1], kinhDo: match3[2] }));
                    return;
                  }
                  const regex4 = /^(-?\d+\.\d+)[\s,]+(-?\d+\.\d+)$/;
                  const match4 = url.trim().match(regex4);
                  if (match4) {
                    setFormData(prev => ({ ...prev, viDo: match4[1], kinhDo: match4[2] }));
                    return;
                  }
                }} 
                placeholder="Dán link Google Maps (VD: https://www.google.com/maps/.../@10.7769,106.7009,15z)" 
                className={inputClass} 
              />
            </div>
            <div className="grid grid-cols-1 gap-3 md:grid-cols-3">
              <div className={fieldWrap}>
                <Label htmlFor="viDo" className={labelClass}>Vĩ độ</Label>
                <Input id="viDo" type="number" step="any" min="-90" max="90" value={formData.viDo} onChange={(e) => setFormData(prev => ({ ...prev, viDo: e.target.value }))} placeholder="10.7769" className={cn(inputClass, "bg-gray-50")} />
              </div>
              <div className={fieldWrap}>
                <Label htmlFor="kinhDo" className={labelClass}>Kinh độ</Label>
                <Input id="kinhDo" type="number" step="any" min="-180" max="180" value={formData.kinhDo} onChange={(e) => setFormData(prev => ({ ...prev, kinhDo: e.target.value }))} placeholder="106.7009" className={cn(inputClass, "bg-gray-50")} />
              </div>
              <div className={fieldWrap}>
                <Label htmlFor="googlePlaceId" className={labelClass}>Google Place ID</Label>
                <Input id="googlePlaceId" value={formData.googlePlaceId} onChange={(e) => setFormData(prev => ({ ...prev, googlePlaceId: e.target.value }))} placeholder="Chưa có" className={inputClass} />
              </div>
            </div>
          </div>
        </section>

        <div className={fieldWrap}>
          <Label htmlFor="moTa" className={labelClass}>Mô tả</Label>
          <Textarea
            id="moTa"
            value={formData.moTa}
            onChange={(e) => setFormData(prev => ({ ...prev, moTa: e.target.value }))}
            rows={3}
            className={cn(inputClass, "min-h-20 resize-none py-2 leading-5")}
          />
        </div>



        <div className={fieldWrap}>
          <Label className={labelClass}>Tiện nghi chung</Label>
          <div className="grid grid-cols-1 gap-2 sm:grid-cols-2 lg:grid-cols-3">
            {tienNghiOptions.map((option) => (
              <Label
                key={option.value}
                htmlFor={option.value}
                className={cn(
                  "flex min-h-11 cursor-pointer items-center gap-2 rounded-xl border bg-white/80 px-3 py-2 text-sm font-medium text-[#243B5A] shadow-sm transition hover:border-[#4FA7A0]/60 hover:bg-[#F1FAF8]",
                  formData.tienNghiChung.includes(option.value)
                    ? "border-[#4FA7A0] bg-[#E9F7F4] text-[#1F5F5B]"
                    : "border-[#E2D6C8]"
                )}
              >
                <Checkbox
                  id={option.value}
                  checked={formData.tienNghiChung.includes(option.value)}
                  onCheckedChange={(checked) => handleTienNghiChange(option.value, checked === true)}
                  className="border-[#C9BDAF] data-[state=checked]:border-[#4FA7A0] data-[state=checked]:bg-[#4FA7A0]"
                />
                <span className="truncate">{option.label}</span>
              </Label>
            ))}
          </div>
        </div>

        {!toaNha && (
          <section className="space-y-4 rounded-2xl border border-[#D8EAE6] bg-[#EEF8F5] p-4 shadow-sm">
            <div>
              <Label className="text-sm font-bold text-[#243B5A]">Tạo phòng nhanh</Label>
              <Select
                value={formData.cheDoTaoPhong}
                onValueChange={(value) => setFormData(prev => ({ ...prev, cheDoTaoPhong: value }))}
              >
                <SelectTrigger className={cn(inputClass, "mt-2 w-full bg-white")}>
                  <SelectValue placeholder="Tạo tầng/phòng cố định" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="NONE">Chỉ tạo tòa nhà</SelectItem>
                  <SelectItem value="FIXED">Tạo tầng/phòng cố định</SelectItem>
                  <SelectItem value="CUSTOM">Tùy chỉnh từng tầng (Tầng có số phòng khác nhau)</SelectItem>
                </SelectContent>
              </Select>
              <p className="mt-1 text-xs text-muted-foreground">
                Gợi ý: Chọn &quot;Tùy chỉnh từng tầng&quot; nếu tầng 2 có 3 phòng, tầng 3 có 6 phòng,...
              </p>
            </div>

            {formData.cheDoTaoPhong === 'FIXED' && (
              <div className="grid grid-cols-1 gap-3 md:grid-cols-2">
                <div className={fieldWrap}>
                  <Label htmlFor="soTang" className={labelClass}>Số tầng</Label>
                  <Input id="soTang" type="number" min={1} value={formData.soTang} onChange={(e) => setFormData(prev => ({ ...prev, soTang: e.target.value }))} className={inputClass} />
                </div>
                <div className={fieldWrap}>
                  <Label htmlFor="soPhongMoiTang" className={labelClass}>Phòng mỗi tầng</Label>
                  <Input id="soPhongMoiTang" type="number" min={1} value={formData.soPhongMoiTang} onChange={(e) => setFormData(prev => ({ ...prev, soPhongMoiTang: e.target.value }))} className={inputClass} />
                </div>
                <div className={fieldWrap}>
                  <Label htmlFor="dienTichMacDinh" className={labelClass}>Diện tích mặc định</Label>
                  <Input id="dienTichMacDinh" type="number" min={1} value={formData.dienTichMacDinh} onChange={(e) => setFormData(prev => ({ ...prev, dienTichMacDinh: e.target.value }))} className={inputClass} />
                </div>
                <div className={fieldWrap}>
                  <Label htmlFor="soNguoiToiDa" className={labelClass}>Số người tối đa</Label>
                  <Input id="soNguoiToiDa" type="number" min={1} value={formData.soNguoiToiDa} onChange={(e) => setFormData(prev => ({ ...prev, soNguoiToiDa: e.target.value }))} className={inputClass} />
                </div>
                <div className={fieldWrap}>
                  <Label htmlFor="giaThueMacDinh" className={labelClass}>Giá thuê mặc định</Label>
                  <Input id="giaThueMacDinh" type="number" min={0} value={formData.giaThueMacDinh} onChange={(e) => setFormData(prev => ({ ...prev, giaThueMacDinh: e.target.value }))} className={inputClass} />
                </div>
                <div className={fieldWrap}>
                  <Label htmlFor="tienCocMacDinh" className={labelClass}>Tiền cọc mặc định</Label>
                  <Input id="tienCocMacDinh" type="number" min={0} value={formData.tienCocMacDinh} onChange={(e) => setFormData(prev => ({ ...prev, tienCocMacDinh: e.target.value }))} className={inputClass} />
                </div>

                <div className="rounded-xl border border-[#D8EAE6] bg-white/70 p-3 text-sm text-[#5F7087] md:col-span-2">
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
                          className={inputClass}
                        />
                      </div>
                      <div className="space-y-1">
                        <Label className="text-xs">Phòng</Label>
                        <Input
                          type="number"
                          min={1}
                          value={floor.soPhong}
                          onChange={(e) => setCauTrucTang(prev => prev.map((item, i) => i === index ? { ...item, soPhong: e.target.value } : item))}
                          className={inputClass}
                        />
                      </div>
                      <div className="space-y-1">
                        <Label className="text-xs">Diện tích</Label>
                        <Input
                          type="number"
                          min={1}
                          value={floor.dienTichMacDinh}
                          onChange={(e) => setCauTrucTang(prev => prev.map((item, i) => i === index ? { ...item, dienTichMacDinh: e.target.value } : item))}
                          className={inputClass}
                        />
                      </div>
                      <div className="space-y-1 md:col-span-2">
                        <Label className="text-xs">Giá thuê</Label>
                        <Input
                          type="number"
                          min={0}
                          value={floor.giaThueMacDinh}
                          onChange={(e) => setCauTrucTang(prev => prev.map((item, i) => i === index ? { ...item, giaThueMacDinh: e.target.value } : item))}
                          className={inputClass}
                        />
                      </div>
                      <div className="space-y-1">
                        <Label className="text-xs">Số người</Label>
                        <Input
                          type="number"
                          min={1}
                          value={floor.soNguoiToiDa}
                          onChange={(e) => setCauTrucTang(prev => prev.map((item, i) => i === index ? { ...item, soNguoiToiDa: e.target.value } : item))}
                          className={inputClass}
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

                <div className="rounded-xl border border-[#D8EAE6] bg-white/70 p-3 text-sm text-[#5F7087]">
                  Dự kiến tạo {cauTrucTang.reduce((sum, floor) => sum + Number(floor.soPhong || 0), 0)} phòng theo cấu trúc tùy chỉnh.
                </div>
              </div>
            )}

            {formData.cheDoTaoPhong !== 'NONE' && (
              <div className="mt-3 space-y-2 rounded-2xl border border-dashed border-[#B9DCD7] bg-white/60 p-3">
                <Label className="text-sm font-semibold text-[#243B5A]">Tiện nghi áp dụng cho tất cả các phòng mới sinh</Label>
                <div className="grid grid-cols-2 gap-2 sm:grid-cols-3 md:grid-cols-4">
                  {[
                    { value: 'dieuhoa', label: 'Điều hòa' },
                    { value: 'nonglanh', label: 'Nóng lạnh' },
                    { value: 'giuong', label: 'Giường' },
                    { value: 'tuquanao', label: 'Tủ quần áo' },
                    { value: 'banlamviec', label: 'Bàn làm việc' },
                    { value: 'ghe', label: 'Ghế' },
                    { value: 'tivi', label: 'TV' },
                    { value: 'maygiat', label: 'Máy giặt' },
                    { value: 'bep', label: 'Bếp' }
                  ].map((option) => (
                    <Label key={option.value} htmlFor={`phong-tn-${option.value}`} className="flex cursor-pointer items-center gap-2 rounded-xl border border-[#E2D6C8] bg-white/80 px-3 py-2 text-sm font-medium text-[#243B5A] transition hover:border-[#4FA7A0]/60 hover:bg-[#F1FAF8]">
                      <Checkbox
                        id={`phong-tn-${option.value}`}
                        checked={formData.tienNghiMacDinh.includes(option.label)}
                        onCheckedChange={(checked) => {
                          setFormData(prev => ({
                            ...prev,
                            tienNghiMacDinh: checked === true
                              ? [...prev.tienNghiMacDinh, option.label]
                              : prev.tienNghiMacDinh.filter(t => t !== option.label)
                          }));
                        }}
                        className="border-[#C9BDAF] data-[state=checked]:border-[#4FA7A0] data-[state=checked]:bg-[#4FA7A0]"
                      />
                      <span className="truncate">
                        {option.label}
                      </span>
                    </Label>
                  ))}
                </div>
              </div>
            )}
          </section>
        )}
      </div>

      <DialogFooter className="flex-shrink-0 gap-2 border-t border-[#E8DCCB]/80 bg-[#FFFBF5]/95 px-5 py-4 backdrop-blur sm:flex-row sm:justify-end sm:px-6">
        <Button type="button" variant="outline" onClick={onClose} className="h-11 rounded-xl border-[#D8CDBF] bg-white/70 px-5 text-sm font-semibold text-[#243B5A] transition hover:bg-[#F8F3EC] sm:min-w-28">
          Hủy
        </Button>
        <Button type="submit" className="h-11 rounded-xl bg-[#243B5A] px-5 text-sm font-semibold text-white shadow-sm transition hover:-translate-y-0.5 hover:bg-[#2D496E] hover:shadow-md sm:min-w-36" disabled={isSubmitting}>
          {isSubmitting ? 'Đang xử lý...' : (toaNha ? 'Cập nhật' : 'Thêm tòa nhà')}
        </Button>
      </DialogFooter>

      <ConfirmActionDialog
        open={isConfirmFillOpen}
        onOpenChange={setIsConfirmFillOpen}
        title="Xác nhận cấu hình lại số tầng"
        description={`Thao tác này sẽ ghi đè danh sách hiện tại bằng ${pendingNumFloors} tầng mới. Bạn có chắc chắn không?`}
        confirmText="Đồng ý"
        variant="default"
        onConfirm={() => executeAutoFill(pendingNumFloors)}
      />
    </form>
  );
}
