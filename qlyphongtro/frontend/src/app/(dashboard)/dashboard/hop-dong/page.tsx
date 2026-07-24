'use client';

import { useState, useEffect, useCallback } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { useSession } from 'next-auth/react';
import { Button } from '@/components/ui/button';
import { useCache } from '@/hooks/use-cache';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { DashboardCard } from '@/components/dashboard/shared-ui';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
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
  FileText, 
  Calendar,
  Download,
  Edit,
  X as CloseIcon,
  RefreshCw,
  Search,
  Trash2,
  Loader2,
  Users,
  Building2,
  Home
} from 'lucide-react';
import { HopDong, Phong, KhachThue, ToaNha } from '@/types';
import { HopDongDataTable } from './table';
import { hopDongStatusFromDb, normalizeHopDong, normalizeKhachThue, normalizePhong, normalizeToaNha } from '@/lib/domain-mappers';
import { toast } from 'sonner';
import { generateAndDownloadHopDong } from '@/lib/export-hop-dong';
import { CheckoutModal } from '@/components/hop-dong/CheckoutModal';

export default function HopDongPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const accessToken = useSession()?.data?.accessToken as string | undefined;
  const { getCache, setCache, clearCache, isRefreshing, setIsRefreshing } = useCache<{
    hopDongList: HopDong[];
    phongList: Phong[];
    khachThueList: KhachThue[];
    toaNhaList: ToaNha[];
  }>({ key: 'hop-dong-data', duration: 300000 }); // 5 phút
  
  const [hopDongList, setHopDongList] = useState<HopDong[]>([]);
  const [phongList, setPhongList] = useState<Phong[]>([]);
  const [khachThueList, setKhachThueList] = useState<KhachThue[]>([]);
  const [toaNhaList, setToaNhaList] = useState<ToaNha[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [appliedSearch, setAppliedSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState<string>(searchParams.get('status') || 'all');
  const [toaNhaFilter, setToaNhaFilter] = useState<string>('all');
  const [viewingHopDong, setViewingHopDong] = useState<HopDong | null>(null);
  const [actionLoading, setActionLoading] = useState<string | null>(null);
  const [deleteTarget, setDeleteTarget] = useState<HopDong | null>(null);
  const [cancelTarget, setCancelTarget] = useState<HopDong | null>(null);
  const [checkoutTarget, setCheckoutTarget] = useState<HopDong | null>(null);
  const [extendTarget, setExtendTarget] = useState<HopDong | null>(null);
  const [extendDate, setExtendDate] = useState('');

  // Pagination state
  const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 10 });
  const [totalElements, setTotalElements] = useState(0);
  const [totalPages, setTotalPages] = useState(0);

  useEffect(() => {
    document.title = 'Quản lý Hợp đồng';
  }, []);

  const readList = useCallback(async <T,>(url: string, label: string, mapper: (item: unknown) => T): Promise<T[]> => {
    const response = await fetch(url, {
      headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
    });
    let result: { success?: boolean; message?: string; data?: unknown } = {};
    try {
      result = await response.json();
    } catch {
      result = {};
    }

    if (!response.ok || result.success === false) {
      throw new Error(result.message || `Không tải được ${label}`);
    }

    const rawData = result.data as unknown[] | { data?: unknown[] } | undefined;
    const items = Array.isArray(rawData) ? rawData : (rawData?.data || []);
    return items.map(mapper);
  }, [accessToken]);

  const fetchData = useCallback(async (forceRefresh = false): Promise<boolean> => {
    try {
      setLoading(true);
      
      // Thử load từ cache trước cho danh mục phụ (nếu không force refresh)
      if (!forceRefresh) {
        const cachedData = getCache();
        if (cachedData && cachedData.phongList && cachedData.phongList.length > 0) {
          setPhongList(cachedData.phongList);
          setKhachThueList(cachedData.khachThueList || []);
          setToaNhaList(cachedData.toaNhaList || []);
        }
      }
      
      const params = new URLSearchParams({
        page: (pagination.pageIndex + 1).toString(),
        limit: pagination.pageSize.toString()
      });
      if (statusFilter && statusFilter !== 'all') params.append('trangThai', statusFilter);
      if (toaNhaFilter && toaNhaFilter !== 'all') params.append('toaNha', toaNhaFilter);
      if (appliedSearch) params.append('search', appliedSearch);

      const response = await fetch(`/api/hop-dong?${params.toString()}`, {
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      });
      let hopDongs: HopDong[] = [];
      if (response.ok) {
        const result = await response.json();
        if (result.success) {
          hopDongs = Array.isArray(result.data) ? result.data : (result.data?.data || []).map(normalizeHopDong);
          if (result.data && !Array.isArray(result.data)) {
            setTotalElements(result.data.total || 0);
            setTotalPages(result.data.totalPages || 0);
          } else {
            setTotalElements(hopDongs.length);
            setTotalPages(1);
          }
        }
      }

      const [phongs, khachThues, toaNhas] = await Promise.all([
        readList('/api/phong', 'danh sách phòng', normalizePhong),
        readList('/api/khach-thue', 'danh sách khách thuê', normalizeKhachThue),
        readList('/api/toa-nha', 'danh sách tòa nhà', normalizeToaNha),
      ]);

      setHopDongList(hopDongs);
      setPhongList(phongs);
      setKhachThueList(khachThues);
      setToaNhaList(toaNhas);

      // Lưu vào cache
      setCache({
        hopDongList: hopDongs,
        phongList: phongs,
        khachThueList: khachThues,
        toaNhaList: toaNhas,
      });
      return true;

    } catch (error) {
      console.error('Error fetching data:', error);
      toast.error(error instanceof Error ? error.message : 'Không tải được dữ liệu hợp đồng');
      return false;
    } finally {
      setLoading(false);
    }
  }, [accessToken, getCache, setCache, pagination.pageIndex, pagination.pageSize, statusFilter, toaNhaFilter, appliedSearch, readList]);

  useEffect(() => {
    fetchData(false);
  }, [fetchData]);

  const handleRefresh = async () => {
    setIsRefreshing(true);
    const ok = await fetchData(true); // Force refresh
    setIsRefreshing(false);
    if (ok) {
      toast.success('Đã tải dữ liệu mới nhất');
    }
  };

  useEffect(() => {
    // Reset pagination when filter changes
    setPagination(prev => ({ ...prev, pageIndex: 0 }));
  }, [statusFilter, toaNhaFilter, appliedSearch]);

  useEffect(() => {
    const timeoutId = window.setTimeout(() => setAppliedSearch(searchTerm.trim()), 350);
    return () => window.clearTimeout(timeoutId);
  }, [searchTerm]);

  const normalizeStatus = (status?: string) => hopDongStatusFromDb(status || 'nhap');
  const isActiveStatus = (status?: string) => normalizeStatus(status) === 'hoatDong';

  const filteredHopDong = hopDongList;

  const getStatusBadge = (status: string) => {
    switch (normalizeStatus(status)) {
      case 'nhap':
        return <Badge variant="outline">Nháp</Badge>;
      case 'choKichHoat':
        return <Badge variant="secondary">Chờ kích hoạt</Badge>;
      case 'hoatDong':
        return <Badge variant="default">Hoạt động</Badge>;
      case 'hetHan':
        return <Badge variant="destructive">Hết hạn</Badge>;
      case 'daKetThuc':
        return <Badge variant="secondary">Đã kết thúc</Badge>;
      case 'daHuy':
        return <Badge variant="secondary">Đã hủy</Badge>;
      default:
        return <Badge variant="outline">{status}</Badge>;
    }
  };

  const getPhongName = (phong: string | { maPhong: string }) => {
    if (typeof phong === 'object' && phong?.maPhong) {
      return phong.maPhong;
    }
    const phongObj = phongList.find(p => p._id === phong);
    return phongObj?.maPhong || 'Không xác định';
  };

  const getPhongInfo = (phong: string | { maPhong: string; toaNha?: { tenToaNha: string } }) => {
    if (typeof phong === 'object' && phong?.maPhong) {
      return {
        maPhong: phong.maPhong,
        toaNha: phong.toaNha?.tenToaNha || 'Không xác định'
      };
    }
    
    const phongObj = phongList.find(p => p._id === phong);
    if (!phongObj) return { maPhong: 'Không xác định', toaNha: 'Không xác định' };
    
    const toaNha = toaNhaList.find(t => t._id === phongObj.toaNha);
    return {
      maPhong: phongObj.maPhong,
      toaNha: toaNha?.tenToaNha || 'Không xác định'
    };
  };

  const getKhachThueName = (khachThue: string | { hoTen: string }) => {
    if (typeof khachThue === 'object' && khachThue?.hoTen) {
      return khachThue.hoTen;
    }
    const khachThueObj = khachThueList.find(k => k._id === khachThue);
    return khachThueObj?.hoTen || 'Không xác định';
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND',
    }).format(amount);
  };

  const isExpiringSoon = (ngayKetThuc: Date | string) => {
    const today = new Date();
    const endDate = new Date(ngayKetThuc);
    const diffTime = endDate.getTime() - today.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays <= 30 && diffDays > 0;
  };

  const isExpired = (ngayKetThuc: Date | string) => {
    const today = new Date();
    const endDate = new Date(ngayKetThuc);
    return endDate < today;
  };

  const handleEdit = (hopDong: HopDong) => {
    router.push(`/dashboard/hop-dong/${hopDong._id}`);
  };

  const handleView = (hopDong: HopDong) => {
    setViewingHopDong(hopDong);
  };

  const requestDelete = (hopDong: HopDong) => {
    setDeleteTarget(hopDong);
  };

  const confirmDelete = async () => {
    if (!deleteTarget?._id) return;
    const id = deleteTarget._id;
    setActionLoading(`delete-${id}`);
    try {
      const response = await fetch(`/api/hop-dong/${id}`, {
        method: 'DELETE',
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      });
      const result = await response.json().catch(() => ({}));
      
      if (response.ok && result.success) {
        // Xóa cache
        clearCache();
        setHopDongList(prev => prev.filter(hopDong => hopDong._id !== id));
        setDeleteTarget(null);
        toast.success(result.message || 'Đã xóa hợp đồng thành công');
      } else {
        toast.error(result.message || 'Có lỗi xảy ra khi xóa hợp đồng');
      }
    } catch (error) {
      console.error('Lỗi khi xóa hợp đồng:', error);
      toast.error('Có lỗi xảy ra khi xóa hợp đồng');
    } finally {
      setActionLoading(null);
    }
  };

  const handleDownload = async (hopDong: HopDong) => {
    try {
      const phongInfo = getPhongInfo(hopDong.phong);
      const nguoiDaiDienName = getKhachThueName(hopDong.nguoiDaiDien);
      const nguoiDaiDienObj = khachThueList.find(kt => {
        const ktId = typeof kt._id === 'object' ? (kt._id as { _id: string })._id : kt._id;
        const daiDienId = typeof hopDong.nguoiDaiDien === 'object' ? (hopDong.nguoiDaiDien as { _id: string })._id : hopDong.nguoiDaiDien;
        return ktId === daiDienId;
      });
      await generateAndDownloadHopDong(hopDong, phongInfo, nguoiDaiDienName, nguoiDaiDienObj, formatCurrency);
      toast.success('Đã tải xuống hợp đồng thành công!');
    } catch (error) {
      toast.error('Có lỗi xảy ra khi tạo file Word');
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
    return Number.isNaN(parsed.getTime()) ? dateStr : formatLocalISODate(parsed);
  };

  const getEndDateValue = (hopDong: HopDong) => String(hopDong.ngayKetThuc || '').split('T')[0];

  const formatLocalISODate = (date: Date) => {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  };

  const addDays = (dateStr: string, days: number) => {
    const parts = /^(\d{4})-(\d{2})-(\d{2})$/.exec(dateStr);
    const date = parts
      ? new Date(Number(parts[1]), Number(parts[2]) - 1, Number(parts[3]))
      : new Date(dateStr);
    if (Number.isNaN(date.getTime())) return formatLocalISODate(new Date());
    date.setDate(date.getDate() + days);
    return formatLocalISODate(date);
  };

  const requestGiaHan = (hopDong: HopDong) => {
    setExtendTarget(hopDong);
    setExtendDate(getEndDateValue(hopDong));
  };

  const confirmGiaHan = async () => {
    if (!extendTarget?._id) return;
    const nextEndDate = ensureISODate(extendDate);
    const currentEndDate = getEndDateValue(extendTarget);
    if (!/^\d{4}-\d{2}-\d{2}$/.test(nextEndDate)) {
      toast.error('Ngày kết thúc mới không hợp lệ');
      return;
    }
    if (currentEndDate && nextEndDate <= currentEndDate) {
      toast.error('Ngày kết thúc mới phải sau ngày kết thúc hiện tại');
      return;
    }

    setActionLoading(`giahan-${extendTarget._id}`);
    try {
      const response = await fetch(`/api/hop-dong/${extendTarget._id}/gia-han`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
        },
        body: JSON.stringify({
          ngayKetThucMoi: nextEndDate,
          ngayHieuLuc: currentEndDate ? addDays(currentEndDate, 1) : formatLocalISODate(new Date()),
          noiDung: 'Gia hạn hợp đồng',
        }),
      });
      const result = await response.json().catch(() => ({}));
      
      if (response.ok && result.success) {
        clearCache();
        setHopDongList(prev => prev.map(hd => 
          hd._id === extendTarget._id ? normalizeHopDong(result.data) : hd
        ));
        setExtendTarget(null);
        setExtendDate('');
        toast.success(result.message || 'Đã gia hạn hợp đồng thành công');
      } else {
        toast.error(result.message || 'Có lỗi xảy ra khi gia hạn hợp đồng');
      }
    } catch (error) {
      console.error('Error extending contract:', error);
      toast.error('Có lỗi xảy ra khi gia hạn hợp đồng');
    } finally {
      setActionLoading(null);
    }
  };

  const requestHuy = (hopDong: HopDong) => {
    if (isActiveStatus(hopDong.trangThai)) {
      setCheckoutTarget(hopDong);
    } else {
      setCancelTarget(hopDong);
    }
  };

  const confirmHuy = async () => {
    if (!cancelTarget?._id) return;
    setActionLoading(`huy-${cancelTarget._id}`);
    try {
      const active = isActiveStatus(cancelTarget.trangThai);
      const response = await fetch(`/api/hop-dong/${cancelTarget._id}/${active ? 'ket-thuc' : 'huy'}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
        },
        body: active ? JSON.stringify({
          ngayKetThucThucTe: formatLocalISODate(new Date()),
          trangThaiCoc: 'KEPT',
          ghiChu: 'Kết thúc hợp đồng từ danh sách',
        }) : undefined,
      });
      const result = await response.json().catch(() => ({}));
      
      if (response.ok && result.success) {
        clearCache();
        setHopDongList(prev => prev.map(hd => 
          hd._id === cancelTarget._id ? normalizeHopDong(result.data) : hd
        ));
        setCancelTarget(null);
        toast.success(result.message || 'Đã hủy hợp đồng thành công');
      } else {
        toast.error(result.message || 'Có lỗi xảy ra khi hủy hợp đồng');
      }
    } catch (error) {
      console.error('Error cancelling contract:', error);
      toast.error('Có lỗi xảy ra khi hủy hợp đồng');
    } finally {
      setActionLoading(null);
    }
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

  const activeContracts = hopDongList.filter(h => isActiveStatus(h.trangThai)).length;
  const expiringContracts = hopDongList.filter(h => isExpiringSoon(h.ngayKetThuc)).length;
  const expiredContracts = hopDongList.filter(h => isExpired(h.ngayKetThuc)).length;
  const expiringTone = expiringContracts > 0 ? 'warning' : 'neutral';
  const expiredTone = expiredContracts > 0 ? 'danger' : 'success';
  const heroStatusLabel = expiringContracts > 0 || expiredContracts > 0 ? 'Cần kiểm tra gia hạn' : 'Hợp đồng ổn định';

  return (
    <div className="space-y-4 md:space-y-6">
      {/* Hero Section */}
      <section className="hop-dong-hero">
        <div className="hop-dong-hero__content">
          <div className="hop-dong-hero__eyebrow">
            <FileText className="h-4 w-4" aria-hidden="true" />
            <span>QUẢN LÝ HỢP ĐỒNG</span>
          </div>

          <div className="hop-dong-hero__title-row">
            <h1>Quản lý hợp đồng</h1>
            <span className="hop-dong-hero__status-badge">{heroStatusLabel}</span>
          </div>

          <p>
            Theo dõi hợp đồng thuê phòng, thời hạn, gia hạn, thanh lý và trạng thái hiệu lực trong một nơi.
          </p>

          <div className="hop-dong-hero__insight">
            Hiện có <strong className="mx-1">{activeContracts} hợp đồng đang hiệu lực</strong> trên tổng <strong className="mx-1">{totalElements} hợp đồng</strong>, 
            {expiringContracts > 0 ? (
              <>
                có <strong className="ml-1">{expiringContracts} hợp đồng sắp hết hạn</strong>.
              </>
            ) : (
              <>
                chưa có hợp đồng nào <strong className="ml-1">sắp hết hạn</strong>.
              </>
            )}
          </div>
        </div>

        <div className="hop-dong-hero__actions">
          <Button
            variant="secondary"
            onClick={handleRefresh}
            disabled={isRefreshing}
            className="hop-dong-hero__button hop-dong-hero__button-secondary"
          >
            <RefreshCw className={`h-4 w-4 sm:mr-2 ${isRefreshing ? 'animate-spin' : ''}`} />
            <span className="hidden sm:inline">{isRefreshing ? 'Đang tải...' : 'Tải mới'}</span>
          </Button>
          <Button
            variant="default"
            onClick={() => router.push('/dashboard/hop-dong/them-moi')}
            className="hop-dong-hero__button hop-dong-hero__button-primary"
          >
            <Plus className="h-4 w-4 sm:mr-2" />
            <span className="hidden sm:inline">Thêm hợp đồng</span>
            <span className="sm:hidden">Thêm</span>
          </Button>
        </div>
      </section>

      {/* Tổng quan hợp đồng - Stats Section */}
      <section className="mt-6 mb-2">
        <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">
          <div className="hop-dong-hero__stat-card hop-dong-hero__stat-card--default">
            <div className="hop-dong-hero__stat-top">
              <span>Tổng hợp đồng</span>
              <FileText className="h-5 w-5" aria-hidden="true" />
            </div>
            <strong>{totalElements}</strong>
            <small>Toàn bộ hợp đồng đã tạo</small>
          </div>

          <div className="hop-dong-hero__stat-card hop-dong-hero__stat-card--success">
            <div className="hop-dong-hero__stat-top">
              <span>Hoạt động</span>
              <FileText className="h-5 w-5" aria-hidden="true" />
            </div>
            <strong>{activeContracts}</strong>
            <small>Đang còn hiệu lực thuê</small>
          </div>

          <div className={`hop-dong-hero__stat-card hop-dong-hero__stat-card--${expiringTone}`}>
            <div className="hop-dong-hero__stat-top">
              <span>Sắp hết hạn</span>
              <Calendar className="h-5 w-5" aria-hidden="true" />
            </div>
            <strong>{expiringContracts}</strong>
            <small>Cần gia hạn trong 30 ngày</small>
          </div>

          <div className={`hop-dong-hero__stat-card hop-dong-hero__stat-card--${expiredTone}`}>
            <div className="hop-dong-hero__stat-top">
              <span>Đã hết hạn</span>
              <Calendar className="h-5 w-5" aria-hidden="true" />
            </div>
            <strong>{expiredContracts}</strong>
            <small>{expiredContracts > 0 ? 'Cần xử lý hợp đồng quá hạn' : 'Không có hợp đồng quá hạn'}</small>
          </div>
        </div>
      </section>

      <Dialog open={!!extendTarget} onOpenChange={(open) => !open && setExtendTarget(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Gia hạn hợp đồng</DialogTitle>
            <DialogDescription>
              Chọn ngày kết thúc mới cho hợp đồng {extendTarget?.maHopDong}. Ngày mới phải sau ngày kết thúc hiện tại.
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-2">
            <Label htmlFor="extendDate">Ngày kết thúc mới</Label>
            <Input
              id="extendDate"
              type="date"
              value={extendDate}
              min={extendTarget ? getEndDateValue(extendTarget) : undefined}
              onChange={(event) => setExtendDate(event.target.value)}
            />
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setExtendTarget(null)} disabled={!!actionLoading}>
              Hủy
            </Button>
            <Button onClick={confirmGiaHan} disabled={actionLoading === `giahan-${extendTarget?._id}`}>
              {actionLoading === `giahan-${extendTarget?._id}` && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Gia hạn
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={!!cancelTarget} onOpenChange={(open) => !open && setCancelTarget(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Hủy hợp đồng</DialogTitle>
            <DialogDescription>
              Hợp đồng {cancelTarget?.maHopDong} sẽ được cập nhật theo trạng thái thực tế. Phòng sẽ được đồng bộ lại trạng thái sau khi lưu.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setCancelTarget(null)} disabled={!!actionLoading}>
              Đóng
            </Button>
            <Button variant="destructive" onClick={confirmHuy} disabled={actionLoading === `huy-${cancelTarget?._id}`}>
              {actionLoading === `huy-${cancelTarget?._id}` && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Xác nhận hủy
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={!!deleteTarget} onOpenChange={(open) => !open && setDeleteTarget(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Xóa hợp đồng</DialogTitle>
            <DialogDescription>
              Hợp đồng {deleteTarget?.maHopDong} sẽ được xóa mềm khỏi danh sách. Phòng liên quan sẽ được đồng bộ lại trạng thái.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeleteTarget(null)} disabled={!!actionLoading}>
              Không xóa
            </Button>
            <Button variant="destructive" onClick={confirmDelete} disabled={actionLoading === `delete-${deleteTarget?._id}`}>
              {actionLoading === `delete-${deleteTarget?._id}` && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Xác nhận xóa
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <CheckoutModal 
        isOpen={!!checkoutTarget}
        hopDong={checkoutTarget}
        onClose={() => setCheckoutTarget(null)}
        accessToken={accessToken}
        onSuccess={(updatedHopDong) => {
          clearCache();
          setHopDongList(prev => prev.map(hd => 
            hd._id === updatedHopDong.id || hd._id === updatedHopDong._id ? normalizeHopDong(updatedHopDong) : hd
          ));
        }}
      />

      {/* View Modal */}
      {viewingHopDong && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-0 md:p-4">
          {/* Backdrop */}
          <div 
            className="fixed inset-0 bg-[#243B5A]/45" 
            onClick={() => setViewingHopDong(null)}
          />
          
          {/* Modal Content */}
          <div className="relative w-full h-full md:w-[95vw] md:h-[95vh] md:max-w-6xl bg-white md:rounded-lg shadow-lg overflow-hidden flex flex-col">
            {/* Fixed Header */}
            <div className="flex items-center justify-between p-4 md:p-6 border-b bg-white flex-shrink-0">
              <div>
                <h2 className="text-lg md:text-2xl font-semibold">Chi tiết hợp đồng</h2>
                <p className="text-xs md:text-sm text-gray-600">
                  Thông tin chi tiết hợp đồng {viewingHopDong.maHopDong}
                </p>
              </div>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => setViewingHopDong(null)}
                  className="h-8 w-8 p-0"
                >
                  <CloseIcon className="h-4 w-4" />
                </Button>
            </div>
            
            {/* Scrollable Content */}
            <div className="flex-1 overflow-y-auto p-4 md:p-6">
              <div className="space-y-4 md:space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-3 md:gap-4">
                  <div>
                    <Label className="text-xs md:text-sm font-medium text-gray-500">Mã hợp đồng</Label>
                    <p className="text-base md:text-lg font-semibold">{viewingHopDong.maHopDong}</p>
                  </div>
                  <div>
                    <Label className="text-xs md:text-sm font-medium text-gray-500">Trạng thái</Label>
                    <div className="mt-1">{getStatusBadge(viewingHopDong.trangThai)}</div>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-3 md:gap-4">
                  <div>
                    <Label className="text-xs md:text-sm font-medium text-gray-500">Phòng</Label>
                    <p className="text-base md:text-lg">{getPhongName(viewingHopDong.phong)}</p>
                  </div>
                  <div>
                    <Label className="text-xs md:text-sm font-medium text-gray-500">Tòa nhà</Label>
                    <p className="text-base md:text-lg">{getPhongInfo(viewingHopDong.phong).toaNha}</p>
                  </div>
                </div>

                <div>
                  <Label className="text-sm font-medium text-gray-500">Khách thuê</Label>
                  <div className="mt-2 space-y-1">
                    {viewingHopDong.khachThueId.map((khachThue, index) => {
                      const khachThueId = typeof khachThue === 'object' ? (khachThue as { _id: string })._id : khachThue;
                      const nguoiDaiDienId = typeof viewingHopDong.nguoiDaiDien === 'object' ? (viewingHopDong.nguoiDaiDien as { _id: string })._id : viewingHopDong.nguoiDaiDien;
                      return (
                        <div key={khachThueId} className="flex items-center gap-2">
                          <span className="text-sm">
                            {index + 1}. {getKhachThueName(khachThue)}
                            {khachThueId === nguoiDaiDienId && (
                              <Badge variant="outline" className="ml-2">Người đại diện</Badge>
                            )}
                          </span>
                        </div>
                      );
                    })}
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <Label className="text-sm font-medium text-gray-500">Ngày bắt đầu</Label>
                    <p className="text-lg">{new Date(viewingHopDong.ngayBatDau).toLocaleDateString('vi-VN')}</p>
                  </div>
                  <div>
                    <Label className="text-sm font-medium text-gray-500">Ngày kết thúc</Label>
                    <p className="text-lg">{new Date(viewingHopDong.ngayKetThuc).toLocaleDateString('vi-VN')}</p>
                  </div>
                </div>

                <div className="grid grid-cols-3 gap-4">
                  <div>
                    <Label className="text-sm font-medium text-gray-500">Giá thuê</Label>
                    <p className="text-lg font-semibold">{formatCurrency(viewingHopDong.giaThue)}/tháng</p>
                  </div>
                  <div>
                    <Label className="text-sm font-medium text-gray-500">Tiền cọc</Label>
                    <p className="text-lg font-semibold">{formatCurrency(viewingHopDong.tienCoc)}</p>
                  </div>
                  <div>
                    <Label className="text-sm font-medium text-gray-500">Ngày thanh toán</Label>
                    <p className="text-lg">Hàng {viewingHopDong.chuKyThanhToan} - ngày {viewingHopDong.ngayThanhToan}</p>
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <Label className="text-sm font-medium text-gray-500">Giá điện</Label>
                    <p className="text-lg">{formatCurrency(viewingHopDong.giaDien)}/kWh</p>
                  </div>
                  <div>
                    <Label className="text-sm font-medium text-gray-500">Giá nước</Label>
                    <p className="text-lg">{formatCurrency(viewingHopDong.giaNuoc)}/m³</p>
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <Label className="text-sm font-medium text-gray-500">Chỉ số điện ban đầu</Label>
                    <p className="text-lg">{viewingHopDong.chiSoDienBanDau} kWh</p>
                  </div>
                  <div>
                    <Label className="text-sm font-medium text-gray-500">Chỉ số nước ban đầu</Label>
                    <p className="text-lg">{viewingHopDong.chiSoNuocBanDau} m³</p>
                  </div>
                </div>

                {viewingHopDong.phiDichVu.length > 0 && (
                  <div>
                    <Label className="text-sm font-medium text-gray-500">Phí dịch vụ</Label>
                    <div className="mt-2 space-y-2">
                      {viewingHopDong.phiDichVu.map((phi, index) => (
                        <div key={index} className="flex justify-between items-center p-2 bg-gray-50 rounded">
                          <span>{phi.ten}</span>
                          <span className="font-semibold">{formatCurrency(phi.gia)}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                <div>
                  <Label className="text-sm font-medium text-gray-500">Điều khoản</Label>
                  <p className="text-sm mt-2 p-3 bg-gray-50 rounded whitespace-pre-wrap">
                    {viewingHopDong.dieuKhoan}
                  </p>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <Label className="text-sm font-medium text-gray-500">Ngày tạo</Label>
                    <p className="text-sm">{new Date(viewingHopDong.ngayTao).toLocaleDateString('vi-VN')}</p>
                  </div>
                  <div>
                    <Label className="text-sm font-medium text-gray-500">Ngày cập nhật</Label>
                    <p className="text-sm">{new Date(viewingHopDong.ngayCapNhat).toLocaleDateString('vi-VN')}</p>
                  </div>
                </div>
              </div>
            </div>

            {/* Fixed Footer */}
            <div className="flex flex-col sm:flex-row gap-2 p-4 md:p-6 border-t bg-white flex-shrink-0">
              <Button variant="outline" size="sm" onClick={() => setViewingHopDong(null)} className="flex-1 sm:flex-none">
                Đóng
              </Button>
              <Button size="sm" onClick={() => handleDownload(viewingHopDong)} className="flex-1 sm:flex-none">
                <Download className="h-3 w-3 md:h-4 md:w-4 mr-2" />
                Tải xuống
              </Button>
              <Button size="sm" onClick={() => {
                setViewingHopDong(null);
                handleEdit(viewingHopDong);
              }} className="flex-1 sm:flex-none">
                <Edit className="h-3 w-3 md:h-4 md:w-4 mr-2" />
                Chỉnh sửa
              </Button>
            </div>
          </div>
        </div>
      )}



      {/* Desktop Table */}
      <DashboardCard className="hidden md:block overflow-hidden">
        <CardHeader className="border-b bg-[#F2E8DC]/70 pb-4">
          <CardTitle className="text-lg text-[#243B5A]">Danh sách hợp đồng</CardTitle>
          <CardDescription>
            {filteredHopDong.length} hợp đồng được tìm thấy
          </CardDescription>
        </CardHeader>
        <CardContent className="p-6">
          <HopDongDataTable
            data={filteredHopDong}
            phongList={phongList}
            khachThueList={khachThueList}
            toaNhaList={toaNhaList}
            onView={handleView}
            onEdit={handleEdit}
            onDelete={requestDelete}
            onDownload={handleDownload}
            onGiaHan={requestGiaHan}
            onHuy={requestHuy}
            actionLoading={actionLoading}
            searchTerm={searchTerm}
            onSearchChange={setSearchTerm}
            statusFilter={statusFilter}
            onStatusChange={setStatusFilter}
            toaNhaFilter={toaNhaFilter}
            onToaNhaChange={setToaNhaFilter}
            allToaNhaList={toaNhaList}
            pageCount={totalPages}
            totalElements={totalElements}
            pagination={pagination}
            onPaginationChange={setPagination}
          />
        </CardContent>
      </DashboardCard>

      {/* Mobile Cards */}
      <div className="md:hidden">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-lg font-semibold">Danh sách hợp đồng</h2>
          <span className="text-sm text-gray-500">{filteredHopDong.length} hợp đồng</span>
        </div>
        
        {/* Mobile Filters */}
        <div className="space-y-2 mb-4">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
            <Input
              placeholder="Tìm kiếm hợp đồng..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="pl-10 text-sm"
            />
          </div>
          <div className="grid grid-cols-2 gap-2">
            <Select value={statusFilter} onValueChange={setStatusFilter}>
              <SelectTrigger className="text-sm">
                <SelectValue placeholder="Trạng thái" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all" className="text-sm">Tất cả</SelectItem>
                <SelectItem value="nhap" className="text-sm">Nháp</SelectItem>
                <SelectItem value="choKichHoat" className="text-sm">Chờ kích hoạt</SelectItem>
                <SelectItem value="hoatDong" className="text-sm">Hoạt động</SelectItem>
                <SelectItem value="hetHan" className="text-sm">Hết hạn</SelectItem>
                <SelectItem value="daKetThuc" className="text-sm">Đã kết thúc</SelectItem>
                <SelectItem value="daHuy" className="text-sm">Đã hủy</SelectItem>
              </SelectContent>
            </Select>
            <Select value={toaNhaFilter} onValueChange={setToaNhaFilter}>
              <SelectTrigger className="text-sm">
                <SelectValue placeholder="Tòa nhà" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all" className="text-sm">Tất cả</SelectItem>
                {toaNhaList.map((toaNha) => (
                  <SelectItem key={toaNha._id} value={toaNha._id!} className="text-sm">
                    {toaNha.tenToaNha}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
        </div>

        {/* Mobile Card List */}
        <div className="space-y-3">
          {filteredHopDong.map((hopDong) => {
            const phongInfo = getPhongInfo(hopDong.phong);
            const nguoiDaiDien = getKhachThueName(hopDong.nguoiDaiDien);
            const isExpiring = isExpiringSoon(hopDong.ngayKetThuc);

            return (
              <Card key={hopDong._id} className="p-4">
                <div className="space-y-3">
                  {/* Header with contract code and status */}
                  <div className="flex justify-between items-start">
                    <div>
                      <h3 className="font-medium text-gray-900">{hopDong.maHopDong}</h3>
                      <div className="flex items-center gap-2 mt-1">
                        <Home className="h-3 w-3 text-gray-400" />
                        <span className="text-sm text-gray-600">{phongInfo.maPhong}</span>
                      </div>
                    </div>
                    <div className="flex flex-col gap-1 items-end">
                      {(() => {
                        switch (normalizeStatus(hopDong.trangThai)) {
                          case 'hoatDong':
                            return <Badge variant="default" className="text-xs">Hoạt động</Badge>;
                          case 'hetHan':
                            return <Badge variant="destructive" className="text-xs">Hết hạn</Badge>;
                          case 'daHuy':
                            return <Badge variant="secondary" className="text-xs">Đã hủy</Badge>;
                          default:
                            return <Badge variant="outline" className="text-xs">{hopDong.trangThai}</Badge>;
                        }
                      })()}
                      {isExpiring && isActiveStatus(hopDong.trangThai) && (
                        <Badge variant="outline" className="text-xs text-orange-600 border-orange-600">
                          Sắp hết hạn
                        </Badge>
                      )}
                    </div>
                  </div>

                  {/* Building and tenant info */}
                  <div className="space-y-1 text-sm">
                    <div className="flex items-center gap-2">
                      <Building2 className="h-3 w-3 text-gray-400" />
                      <span className="text-gray-600">{phongInfo.toaNha}</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <Users className="h-3 w-3 text-gray-400" />
                      <span className="text-gray-600">{nguoiDaiDien}</span>
                      {hopDong.khachThueId.length > 1 && (
                        <Badge variant="secondary" className="text-[10px]">
                          +{hopDong.khachThueId.length - 1}
                        </Badge>
                      )}
                    </div>
                  </div>

                  {/* Contract dates */}
                  <div className="grid grid-cols-2 gap-2 text-xs text-gray-500 border-t pt-2">
                    <div>
                      <Calendar className="h-3 w-3 inline mr-1" />
                      Từ: {new Date(hopDong.ngayBatDau).toLocaleDateString('vi-VN')}
                    </div>
                    <div>
                      <Calendar className="h-3 w-3 inline mr-1" />
                      Đến: {new Date(hopDong.ngayKetThuc).toLocaleDateString('vi-VN')}
                    </div>
                  </div>

                  {/* Pricing info */}
                  <div className="border-t pt-2">
                    <div className="grid grid-cols-2 gap-2 text-sm">
                      <div>
                        <span className="text-gray-500">Giá thuê:</span>
                        <p className="font-semibold text-green-600">{formatCurrency(hopDong.giaThue)}</p>
                      </div>
                      <div>
                        <span className="text-gray-500">Tiền cọc:</span>
                        <p className="font-semibold text-[#243B5A]">{formatCurrency(hopDong.tienCoc)}</p>
                      </div>
                    </div>
                  </div>

                  {/* Action buttons */}
                  <div className="flex flex-wrap gap-2 pt-2 border-t">
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => handleView(hopDong)}
                      className="flex-1"
                    >
                      <FileText className="h-3.5 w-3.5 mr-1" />
                      Xem
                    </Button>
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => handleEdit(hopDong)}
                      className="flex-1"
                    >
                      <Edit className="h-3.5 w-3.5 mr-1" />
                      Sửa
                    </Button>
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => handleDownload(hopDong)}
                      className="flex-1"
                    >
                      <Download className="h-3.5 w-3.5 mr-1" />
                      Tải
                    </Button>
                    {isActiveStatus(hopDong.trangThai) && (
                      <>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => requestGiaHan(hopDong)}
                          disabled={actionLoading === `giahan-${hopDong._id}`}
                          className="flex-1"
                        >
                          {actionLoading === `giahan-${hopDong._id}` ? (
                            <Loader2 className="h-3.5 w-3.5 mr-1 animate-spin" />
                          ) : (
                            <Calendar className="h-3.5 w-3.5 mr-1" />
                          )}
                          Gia hạn
                        </Button>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => requestHuy(hopDong)}
                          disabled={actionLoading === `huy-${hopDong._id}`}
                          className="flex-1"
                        >
                          {actionLoading === `huy-${hopDong._id}` ? (
                            <Loader2 className="h-3.5 w-3.5 mr-1 animate-spin" />
                          ) : (
                            <CloseIcon className="h-3.5 w-3.5 mr-1" />
                          )}
                          Hủy
                        </Button>
                      </>
                    )}
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => requestDelete(hopDong)}
                      disabled={actionLoading === `delete-${hopDong._id}`}
                      className="flex-1 text-destructive"
                    >
                      {actionLoading === `delete-${hopDong._id}` ? (
                        <Loader2 className="h-3.5 w-3.5 mr-1 animate-spin" />
                      ) : (
                        <Trash2 className="h-3.5 w-3.5 mr-1" />
                      )}
                      Xóa
                    </Button>
                  </div>
                </div>
              </Card>
            );
          })}
        </div>

        {filteredHopDong.length === 0 && (
          <div className="text-center py-8">
            <FileText className="h-12 w-12 text-gray-300 mx-auto mb-4" />
            <p className="text-gray-500">Không có hợp đồng nào</p>
          </div>
        )}
      </div>

    </div>
  );
}
