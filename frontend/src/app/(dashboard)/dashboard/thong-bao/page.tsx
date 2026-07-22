'use client';

import { useState, useEffect, useCallback } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { DashboardHero, DashboardKpiCard, DashboardCard, HeroActionButton } from "@/components/dashboard/shared-ui";
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
import { Textarea } from '@/components/ui/textarea';
import {
  Plus,
  Search,
  Edit,
  Trash2,
  Bell,
  Calendar,
  Users,
  Eye,
  Send,
  Building2,
  Home,
  RefreshCw,
  ChevronLeft,
  ChevronRight,
  ChevronsLeft,
  ChevronsRight
} from 'lucide-react';
import { ThongBao, ToaNha, Phong, KhachThue } from '@/types';
import { toast } from 'sonner';
import { useSession } from 'next-auth/react';
import { useCache } from '@/hooks/use-cache';
import { unwrapPageData } from '@/lib/api-response';
import { ConfirmActionDialog } from '@/components/ui/confirm-action-dialog';

const getId = (value: unknown): string | undefined => {
  if (!value) return undefined;
  if (typeof value === 'string') return value;
  if (typeof value === 'object' && '_id' in value) {
    const id = (value as { _id?: unknown })._id;
    return typeof id === 'string' ? id : undefined;
  }
  return undefined;
};

export default function ThongBaoPage() {
  const { data: session } = useSession();
  const accessToken = session?.accessToken;
  const { getCache, setCache, clearCache, isRefreshing, setIsRefreshing } = useCache<{
    thongBaoList: ThongBao[];
    toaNhaList: ToaNha[];
    phongList: Phong[];
    khachThueList: KhachThue[];
  }>({ key: 'thong-bao-data', duration: 300000 });

  const [thongBaoList, setThongBaoList] = useState<ThongBao[]>([]);
  const [toaNhaList, setToaNhaList] = useState<ToaNha[]>([]);
  const [phongList, setPhongList] = useState<Phong[]>([]);
  const [khachThueList, setKhachThueList] = useState<KhachThue[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [typeFilter, setTypeFilter] = useState<string>('all');
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [editingThongBao, setEditingThongBao] = useState<ThongBao | null>(null);

  const [isConfirmOpen, setIsConfirmOpen] = useState(false);
  const [itemToDelete, setItemToDelete] = useState<string | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);

  // Pagination state
  const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 10 });
  const [totalElements, setTotalElements] = useState(0);
  const [totalPages, setTotalPages] = useState(0);

  useEffect(() => {
    document.title = 'Quản lý Thông báo';
  }, []);

  const fetchData = useCallback(async (forceRefresh = false, showLoading = true) => {
    try {
      if (showLoading) {
        setLoading(true);
      }

      if (!forceRefresh) {
        const cachedData = getCache();
        if (cachedData) {
          setThongBaoList(cachedData.thongBaoList || []);
          setToaNhaList(cachedData.toaNhaList || []);
          setPhongList(cachedData.phongList || []);
          setKhachThueList(cachedData.khachThueList || []);
          setLoading(false);
          return;
        }
      }

      // Fetch thông báo từ API
      const params = new URLSearchParams({
        page: (pagination.pageIndex + 1).toString(),
        limit: pagination.pageSize.toString()
      });
      if (typeFilter && typeFilter !== 'all') params.append('loai', typeFilter);
      
      const thongBaoResponse = await fetch(`/api/thong-bao?${params.toString()}`, {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const thongBaoData = thongBaoResponse.ok ? await thongBaoResponse.json() : { data: [] };
      
      let thongBaos = [];
      if (thongBaoData.success) {
        if (thongBaoData.data && !Array.isArray(thongBaoData.data)) {
          thongBaos = thongBaoData.data.data || [];
          setTotalElements(thongBaoData.data.total || 0);
          setTotalPages(thongBaoData.data.totalPages || 0);
        } else {
          thongBaos = thongBaoData.data || [];
          setTotalElements(thongBaos.length);
          setTotalPages(1);
        }
      }
      setThongBaoList(thongBaos);

      // Fetch tòa nhà từ API
      const toaNhaResponse = await fetch('/api/toa-nha?page=1&limit=100', {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const toaNhaData = toaNhaResponse.ok ? await toaNhaResponse.json() : { data: [] };
      const toaNhas = toaNhaData.success ? unwrapPageData<ToaNha>(toaNhaData.data) : [];
      setToaNhaList(toaNhas);

      // Fetch phòng từ API
      const phongResponse = await fetch('/api/phong?page=1&limit=100&simple=true', {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const phongData = phongResponse.ok ? await phongResponse.json() : { data: [] };
      const phongs = phongData.success ? unwrapPageData<Phong>(phongData.data) : [];
      setPhongList(phongs);

      // Fetch khách thuê từ API
      const khachThueResponse = await fetch('/api/khach-thue?page=1&limit=100', {
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const khachThueData = khachThueResponse.ok ? await khachThueResponse.json() : { data: [] };
      const khachThues = khachThueData.success ? unwrapPageData<KhachThue>(khachThueData.data) : [];
      setKhachThueList(khachThues);

      setCache({
        thongBaoList: thongBaos,
        toaNhaList: toaNhas,
        phongList: phongs,
        khachThueList: khachThues,
      });
    } catch (error) {
      console.error('Error fetching data:', error);
      setThongBaoList([]);
      setToaNhaList([]);
      setPhongList([]);
      setKhachThueList([]);
    } finally {
      setLoading(false);
    }
  }, [accessToken, getCache, setCache, pagination.pageIndex, pagination.pageSize, typeFilter]);

  useEffect(() => {
    fetchData(false, false);
  }, [fetchData, typeFilter, pagination.pageIndex, pagination.pageSize]);

  useEffect(() => {
    // Reset pagination when filter changes
    setPagination(prev => ({ ...prev, pageIndex: 0 }));
  }, [typeFilter]);

  const handleRefresh = async () => {
    setIsRefreshing(true);
    await fetchData(true, false);
    setIsRefreshing(false);
    toast.success('Đã tải dữ liệu mới nhất');
  };

  const filteredThongBao = thongBaoList.filter(thongBao => {
    const matchesSearch = thongBao.tieuDe?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      thongBao.noiDung?.toLowerCase().includes(searchTerm.toLowerCase());

    return matchesSearch;
  });

  const getTypeBadge = (type: string) => {
    switch (type) {
      case 'chung':
        return <Badge variant="default">Chung</Badge>;
      case 'hoaDon':
        return <Badge variant="secondary">Hóa đơn</Badge>;
      case 'suCo':
        return <Badge variant="destructive">Sự cố</Badge>;
      case 'hopDong':
        return <Badge variant="outline">Hợp đồng</Badge>;
      case 'khac':
        return <Badge variant="outline">Khác</Badge>;
      default:
        return <Badge variant="outline">{type}</Badge>;
    }
  };

  const getToaNhaName = (toaNhaId?: string) => {
    if (!toaNhaId) return 'Tất cả tòa nhà';
    const toaNha = toaNhaList.find(tn => tn._id === toaNhaId);
    return toaNha?.tenToaNha || 'Không xác định';
  };

  const getToaNhaNameForThongBao = (thongBao: ThongBao) => {
    if (thongBao.toaNha) {
      return getToaNhaName(thongBao.toaNha);
    }

    const phongIds = thongBao.phong || [];
    if (phongIds.length === 0) {
      return 'Tất cả tòa nhà';
    }

    const toaNhaNames = phongIds
      .map(id => phongList.find(phong => phong._id === id))
      .map(phong => getId(phong?.toaNha))
      .filter((id): id is string => Boolean(id))
      .filter((id, index, ids) => ids.indexOf(id) === index)
      .map(getToaNhaName);

    return toaNhaNames.length > 0 ? toaNhaNames.join(', ') : 'Không xác định';
  };

  const getPhongNames = (phongIds?: string[]) => {
    if (!phongIds || phongIds.length === 0) return 'Tất cả phòng';
    const phongNames = phongIds.map(id => {
      const phong = phongList.find(p => p._id === id);
      return phong?.maPhong || 'Không xác định';
    });
    return phongNames.join(', ');
  };

  const getKhachThueNames = (khachThueIds?: string[]) => {
    if (!khachThueIds || khachThueIds.length === 0) return 'Tất cả khách thuê';
    const khachThueNames = khachThueIds.map(id => {
      const khachThue = khachThueList.find(k => k._id === id);
      return khachThue?.hoTen || 'Không xác định';
    });
    return khachThueNames.join(', ');
  };

  const handleEdit = (thongBao: ThongBao) => {
    setEditingThongBao(thongBao);
    setIsDialogOpen(true);
  };

  const handleDelete = (id: string) => {
    setItemToDelete(id);
    setIsConfirmOpen(true);
  };

  const confirmDelete = async () => {
    if (!itemToDelete) return;
    setIsDeleting(true);
    try {
      const response = await fetch(`/api/thong-bao/${itemToDelete}`, {
        method: 'DELETE',
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const result = await response.json();

      if (response.ok && result.success) {
        clearCache();
        setThongBaoList(prev => prev.filter(thongBao => thongBao._id !== itemToDelete));
        toast.success('Xóa thông báo thành công');
      } else {
        toast.error(result.message || 'Có lỗi xảy ra khi xóa thông báo');
      }
    } catch (error) {
      console.error('Error deleting thong bao:', error);
      toast.error('Có lỗi xảy ra khi xóa thông báo');
    } finally {
      setIsDeleting(false);
      setIsConfirmOpen(false);
      setItemToDelete(null);
    }
  };

  const handleSend = async (thongBao: ThongBao) => {
    if (!thongBao._id) return;

    try {
      const response = await fetch(`/api/thong-bao/${thongBao._id}/send`, {
        method: 'POST',
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const result = await response.json();

      if (response.ok && result.success) {
        clearCache();
        await fetchData(true, false);
        toast.success(result.message || 'Gửi thông báo thành công');
      } else {
        toast.error(result.message || 'Có lỗi xảy ra khi gửi thông báo');
      }
    } catch (error) {
      console.error('Error sending thong bao:', error);
      toast.error('Có lỗi xảy ra khi gửi thông báo');
    }
  };

  const handleToggleRead = async (thongBao: ThongBao) => {
    if (!thongBao._id) return;

    const daDoc = !(thongBao.daDoc && thongBao.daDoc.length > 0);
    try {
      const response = await fetch(`/api/thong-bao/${thongBao._id}/da-doc?daDoc=${daDoc}`, {
        method: 'PATCH',
        headers: { Authorization: `Bearer ${accessToken}` },
      });
      const result = await response.json();

      if (response.ok && result.success) {
        clearCache();
        setThongBaoList(prev => prev.map(item => (
          item._id === thongBao._id ? result.data : item
        )));
        toast.success(daDoc ? 'Đã đánh dấu đã đọc' : 'Đã đánh dấu chưa đọc');
      } else {
        toast.error(result.message || 'Có lỗi xảy ra khi cập nhật trạng thái đọc');
      }
    } catch (error) {
      console.error('Error updating read status:', error);
      toast.error('Có lỗi xảy ra khi cập nhật trạng thái đọc');
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

  return (
    <div className="space-y-4 md:space-y-6">
      <DashboardHero
        icon={Bell}
        title="Quản lý thông báo"
        description="Gửi và quản lý thông báo đến khách thuê"
        actions={
          <>
            <HeroActionButton
              variant="secondary"
              onClick={handleRefresh}
              disabled={isRefreshing}
            >
              <RefreshCw className={`h-4 w-4 sm:mr-2 ${isRefreshing ? 'animate-spin' : ''}`} />
              <span className="hidden sm:inline">{isRefreshing ? 'Đang tải...' : 'Tải mới'}</span>
            </HeroActionButton>
            <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
              <DialogTrigger asChild>
                <HeroActionButton variant="default" onClick={() => setEditingThongBao(null)}>
                  <Plus className="h-4 w-4 sm:mr-2" />
                  <span className="hidden sm:inline">Tạo thông báo</span>
                  <span className="sm:hidden">Tạo</span>
                </HeroActionButton>
              </DialogTrigger>
              <DialogContent className="w-[95vw] md:w-full max-w-4xl max-h-[90vh] overflow-y-auto">
                <DialogHeader>
                  <DialogTitle>
                    {editingThongBao ? 'Chỉnh sửa thông báo' : 'Tạo thông báo mới'}
                  </DialogTitle>
                  <DialogDescription>
                    {editingThongBao ? 'Cập nhật thông tin thông báo' : 'Nhập thông tin thông báo mới'}
                  </DialogDescription>
                </DialogHeader>

                <ThongBaoForm
                  thongBao={editingThongBao}
                  toaNhaList={toaNhaList}
                  phongList={phongList}
                  khachThueList={khachThueList}
                  onClose={() => setIsDialogOpen(false)}
                  onSuccess={() => {
                    clearCache();
                    setIsDialogOpen(false);
                    fetchData(true, false);
                  }}
                />
              </DialogContent>
            </Dialog>
          </>
        }
      >
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-3 md:gap-4 relative z-10">
          <DashboardKpiCard 
            title="Tổng thông báo" 
            value={String(totalElements)} 
            icon={<Bell className="h-5 w-5" />} 
            tone="default" 
          />
          <DashboardKpiCard 
            title="Chung" 
            value={String(thongBaoList.filter(t => t.loai === 'chung').length)} 
            icon={<Bell className="h-5 w-5" />} 
            tone="blue" 
          />
          <DashboardKpiCard 
            title="Hóa đơn" 
            value={String(thongBaoList.filter(t => t.loai === 'hoaDon').length)} 
            icon={<Bell className="h-5 w-5" />} 
            tone="emerald" 
          />
          <DashboardKpiCard 
            title="Sự cố" 
            value={String(thongBaoList.filter(t => t.loai === 'suCo').length)} 
            icon={<Bell className="h-5 w-5" />} 
            tone="red" 
          />
        </div>
      </DashboardHero>

      {/* Desktop Table */}
      <DashboardCard className="hidden md:block overflow-hidden">
        <CardHeader className="border-b bg-[#F2E8DC]/70 pb-4">
          <CardTitle className="text-lg text-[#243B5A]">Danh sách thông báo</CardTitle>
          <CardDescription>
            {filteredThongBao.length} thông báo được tìm thấy
          </CardDescription>
        </CardHeader>
        <CardContent className="p-6">
          {/* Tìm kiếm và Bộ lọc */}
          <div className="flex flex-col sm:flex-row items-start sm:items-center gap-3 mb-4">
            <div className="flex flex-col sm:flex-row gap-3 flex-1 w-full">
              <div className="flex-1 sm:max-w-md">
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input
                    placeholder="Tìm kiếm theo tiêu đề, nội dung..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className="pl-10"
                  />
                </div>
              </div>
              <Select value={typeFilter} onValueChange={setTypeFilter}>
                <SelectTrigger className="w-full sm:w-[160px]">
                  <SelectValue placeholder="Loại" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Tất cả</SelectItem>
                  <SelectItem value="chung">Chung</SelectItem>
                  <SelectItem value="hoaDon">Hóa đơn</SelectItem>
                  <SelectItem value="suCo">Sự cố</SelectItem>
                  <SelectItem value="hopDong">Hợp đồng</SelectItem>
                  <SelectItem value="khac">Khác</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Tiêu đề</TableHead>
                  <TableHead>Loại</TableHead>
                  <TableHead>Người nhận</TableHead>
                  <TableHead>Phòng</TableHead>
                  <TableHead>Tòa nhà</TableHead>
                  <TableHead>Ngày gửi</TableHead>
                  <TableHead>Trạng thái</TableHead>
                  <TableHead className="text-right">Thao tác</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {filteredThongBao.map((thongBao) => (
                  <TableRow key={thongBao._id}>
                    <TableCell className="font-medium">
                      <div>
                        <div className="font-medium">{thongBao.tieuDe}</div>
                        <div className="text-sm text-gray-500 truncate max-w-xs">
                          {thongBao.noiDung}
                        </div>
                      </div>
                    </TableCell>
                    <TableCell>{getTypeBadge(thongBao.loai)}</TableCell>
                    <TableCell>
                      <div className="text-sm">
                        {getKhachThueNames(thongBao.nguoiNhan)}
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="text-sm">
                        {getPhongNames(thongBao.phong || [])}
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="flex items-center gap-2">
                        <Building2 className="h-4 w-4 text-gray-400" />
                        <span className="text-sm">
                          {getToaNhaNameForThongBao(thongBao)}
                        </span>
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="flex items-center gap-2">
                        <Calendar className="h-4 w-4 text-gray-400" />
                        <span className="text-sm">
                          {new Date(thongBao.ngayGui || thongBao.taoLuc || (thongBao as any).ngayTao || new Date()).toLocaleDateString('vi-VN')}
                        </span>
                      </div>
                    </TableCell>
                    <TableCell>
                      <Badge variant={thongBao.daDoc && thongBao.daDoc.length > 0 ? "default" : "secondary"}>
                        {thongBao.daDoc && thongBao.daDoc.length > 0 ? 'Đã đọc' : 'Chưa đọc'}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-right">
                      <div className="flex justify-end gap-2">
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => handleToggleRead(thongBao)}
                        >
                          <Eye className="h-4 w-4" />
                        </Button>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => handleSend(thongBao)}
                        >
                          <Send className="h-4 w-4" />
                        </Button>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => handleEdit(thongBao)}
                        >
                          <Edit className="h-4 w-4" />
                        </Button>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => handleDelete(thongBao._id!)}
                          className="text-red-600 hover:text-red-700"
                        >
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>
          
          <div className="flex items-center justify-between mt-4">
            <div className="text-muted-foreground hidden flex-1 text-sm lg:flex">
              Hiển thị {filteredThongBao.length} / {totalElements} thông báo
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
      </DashboardCard>

      {/* Mobile Cards */}
      <div className="md:hidden">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-lg font-semibold">Danh sách thông báo</h2>
          <span className="text-sm text-gray-500">{filteredThongBao.length} thông báo</span>
        </div>

        {/* Mobile Filters */}
        <div className="space-y-2 mb-4">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
            <Input
              placeholder="Tìm kiếm thông báo..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="pl-10 text-sm"
            />
          </div>
          <Select value={typeFilter} onValueChange={setTypeFilter}>
            <SelectTrigger className="text-sm">
              <SelectValue placeholder="Loại thông báo" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all" className="text-sm">Tất cả</SelectItem>
              <SelectItem value="chung" className="text-sm">Chung</SelectItem>
              <SelectItem value="hoaDon" className="text-sm">Hóa đơn</SelectItem>
              <SelectItem value="suCo" className="text-sm">Sự cố</SelectItem>
              <SelectItem value="hopDong" className="text-sm">Hợp đồng</SelectItem>
              <SelectItem value="khac" className="text-sm">Khác</SelectItem>
            </SelectContent>
          </Select>
        </div>

        {/* Mobile Card List */}
        <div className="space-y-3">
          {filteredThongBao.map((thongBao) => {
            return (
              <Card key={thongBao._id} className="p-4">
                <div className="space-y-3">
                  {/* Header with title and type */}
                  <div className="flex justify-between items-start gap-2">
                    <div className="flex-1 min-w-0">
                      <h3 className="font-medium text-gray-900">{thongBao.tieuDe}</h3>
                      <div className="flex items-center gap-2 mt-1">
                        <Calendar className="h-3 w-3 text-gray-400" />
                        <span className="text-xs text-gray-500">
                          {new Date(thongBao.ngayGui).toLocaleDateString('vi-VN')}
                        </span>
                      </div>
                    </div>
                    {getTypeBadge(thongBao.loai)}
                  </div>

                  {/* Content */}
                  <div className="border-t pt-2">
                    <p className="text-xs text-gray-600 line-clamp-3">{thongBao.noiDung}</p>
                  </div>

                  {/* Recipients info */}
                  <div className="space-y-1 text-xs border-t pt-2">
                    {(thongBao.toaNha || (thongBao.phong && thongBao.phong.length > 0)) && (
                      <div className="flex items-center gap-2 text-gray-500">
                        <Building2 className="h-3 w-3" />
                        <span>{getToaNhaNameForThongBao(thongBao)}</span>
                      </div>
                    )}
                    {thongBao.phong && thongBao.phong.length > 0 && (
                      <div className="flex items-center gap-2 text-gray-500">
                        <Home className="h-3 w-3" />
                        <span className="truncate">{getPhongNames(thongBao.phong)}</span>
                      </div>
                    )}
                    <div className="flex items-center gap-2 text-gray-500">
                      <Users className="h-3 w-3" />
                      <span className="truncate">{getKhachThueNames(thongBao.nguoiNhan)}</span>
                    </div>
                  </div>

                  {/* Read status */}
                  <div className="border-t pt-2">
                    <Badge variant={thongBao.daDoc && thongBao.daDoc.length > 0 ? "default" : "secondary"} className="text-xs">
                      {thongBao.daDoc && thongBao.daDoc.length > 0 ? 'Đã đọc' : 'Chưa đọc'}
                    </Badge>
                  </div>

                  {/* Action buttons */}
                  <div className="flex flex-wrap gap-2 pt-2 border-t">
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => handleToggleRead(thongBao)}
                      className="flex-1"
                    >
                      <Eye className="h-3.5 w-3.5 mr-1" />
                      {thongBao.daDoc && thongBao.daDoc.length > 0 ? 'Chưa đọc' : 'Đã đọc'}
                    </Button>
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => handleSend(thongBao)}
                      className="flex-1"
                    >
                      <Send className="h-3.5 w-3.5 mr-1" />
                      Gửi
                    </Button>
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => handleEdit(thongBao)}
                      className="flex-1"
                    >
                      <Edit className="h-3.5 w-3.5 mr-1" />
                      Sửa
                    </Button>
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => handleDelete(thongBao._id!)}
                      className="flex-1 text-red-600 hover:bg-red-50"
                    >
                      <Trash2 className="h-3.5 w-3.5 mr-1" />
                      Xóa
                    </Button>
                  </div>
                </div>
              </Card>
            );
          })}
        </div>

        {filteredThongBao.length === 0 && (
          <div className="text-center py-8">
            <Bell className="h-12 w-12 text-gray-300 mx-auto mb-4" />
            <p className="text-gray-500">Không có thông báo nào</p>
          </div>
        )}
      </div>

      <ConfirmActionDialog
        open={isConfirmOpen}
        onOpenChange={setIsConfirmOpen}
        title="Xác nhận xóa thông báo"
        description="Bạn có chắc chắn muốn xóa thông báo này? Thao tác này không thể hoàn tác."
        confirmText="Xóa"
        variant="destructive"
        loading={isDeleting}
        onConfirm={confirmDelete}
      />
    </div>
  );
}

// Form component for adding/editing thong bao
function ThongBaoForm({
  thongBao,
  toaNhaList,
  phongList,
  khachThueList,
  onClose,
  onSuccess
}: {
  thongBao: ThongBao | null;
  toaNhaList: ToaNha[];
  phongList: Phong[];
  khachThueList: KhachThue[];
  onClose: () => void;
  onSuccess: () => void;
}) {
  const { data: session } = useSession();
  const accessToken = session?.accessToken;
  const [formData, setFormData] = useState({
    tieuDe: thongBao?.tieuDe || '',
    noiDung: thongBao?.noiDung || '',
    loai: thongBao?.loai || 'chung',
    nguoiNhan: thongBao?.nguoiNhan || [],
    phong: thongBao?.phong || [],
    toaNha: thongBao?.toaNha || 'all',
  });

  const filteredPhongList = formData.toaNha === 'all'
    ? phongList
    : phongList.filter((phong) => getId(phong.toaNha) === formData.toaNha);

  const handleToaNhaChange = (value: string) => {
    setFormData(prev => {
      const nextPhong = value === 'all'
        ? prev.phong
        : prev.phong.filter(phongId => {
          const phong = phongList.find(item => item._id === phongId);
          return getId(phong?.toaNha) === value;
        });

      return {
        ...prev,
        toaNha: value,
        phong: nextPhong,
      };
    });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    let finalNguoiNhan = [...formData.nguoiNhan];

    // Nếu không chọn người nhận cụ thể nào, ta sẽ tự động lấy danh sách theo phòng hoặc tòa nhà
    if (finalNguoiNhan.length === 0) {
      if (formData.phong.length > 0) {
        finalNguoiNhan = khachThueList
          .filter(kt => {
            const pId = getId(kt.hopDongHienTai?.phong);
            return pId && formData.phong.includes(pId);
          })
          .map(kt => getId(kt))
          .filter(Boolean) as string[];
      } else if (formData.toaNha !== 'all') {
        finalNguoiNhan = khachThueList
          .filter(kt => {
            const tnId = getId(kt.hopDongHienTai?.phong?.toaNha);
            return tnId === formData.toaNha;
          })
          .map(kt => getId(kt))
          .filter(Boolean) as string[];
      }
    }

    // Nếu đã chọn tòa nhà/phòng nhưng khu vực đó không có khách thuê nào
    if (formData.toaNha !== 'all' && finalNguoiNhan.length === 0) {
      toast.error('Không có khách thuê nào trong khu vực đã chọn để gửi thông báo.');
      return;
    }

    try {
      const url = thongBao
        ? `/api/thong-bao/${thongBao._id}`
        : '/api/thong-bao';
      const method = thongBao ? 'PUT' : 'POST';
      const payload = {
        ...formData,
        nguoiNhan: finalNguoiNhan,
        toaNha: formData.toaNha === 'all' ? undefined : formData.toaNha,
      };

      const response = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify(payload),
      });

      const result = await response.json();

      if (result.success) {
        toast.success(thongBao ? 'Cập nhật thông báo thành công' : 'Tạo thông báo thành công');
        onSuccess();
      } else {
        toast.error(result.message || 'Có lỗi xảy ra');
      }
    } catch (error) {
      console.error('Error submitting form:', error);
      toast.error('Có lỗi xảy ra khi gửi form');
    }
  };

  const handleNguoiNhanChange = (khachThueId: string, checked: boolean) => {
    setFormData(prev => ({
      ...prev,
      nguoiNhan: checked
        ? [...prev.nguoiNhan, khachThueId]
        : prev.nguoiNhan.filter(id => id !== khachThueId)
    }));
  };

  const handlePhongChange = (phongId: string, checked: boolean) => {
    setFormData(prev => ({
      ...prev,
      phong: checked
        ? [...prev.phong, phongId]
        : prev.phong.filter(id => id !== phongId)
    }));
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-3 md:space-y-4">
      <div className="space-y-2">
        <Label htmlFor="tieuDe" className="text-xs md:text-sm">Tiêu đề</Label>
        <Input
          id="tieuDe"
          value={formData.tieuDe}
          onChange={(e) => setFormData(prev => ({ ...prev, tieuDe: e.target.value }))}
          placeholder="Nhập tiêu đề thông báo"
          required
          className="text-sm"
        />
      </div>

      <div className="space-y-2">
        <Label htmlFor="noiDung" className="text-xs md:text-sm">Nội dung</Label>
        <Textarea
          id="noiDung"
          value={formData.noiDung}
          onChange={(e) => setFormData(prev => ({ ...prev, noiDung: e.target.value }))}
          rows={6}
          placeholder="Nhập nội dung thông báo..."
          required
          className="text-sm"
        />
      </div>

      <div className="space-y-2">
        <Label htmlFor="loai" className="text-xs md:text-sm">Loại thông báo</Label>
        <Select value={formData.loai} onValueChange={(value) => setFormData(prev => ({ ...prev, loai: value as ThongBao['loai'] }))}>
          <SelectTrigger className="text-sm">
            <SelectValue placeholder="Chọn loại thông báo" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="chung" className="text-sm">Chung</SelectItem>
            <SelectItem value="hoaDon" className="text-sm">Hóa đơn</SelectItem>
            <SelectItem value="suCo" className="text-sm">Sự cố</SelectItem>
            <SelectItem value="hopDong" className="text-sm">Hợp đồng</SelectItem>
            <SelectItem value="khac" className="text-sm">Khác</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <div className="space-y-2">
        <Label htmlFor="toaNha" className="text-xs md:text-sm">Tòa nhà</Label>
        <Select value={formData.toaNha} onValueChange={handleToaNhaChange}>
          <SelectTrigger className="text-sm">
            <SelectValue placeholder="Chọn tòa nhà (tùy chọn)" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all" className="text-sm">Tất cả tòa nhà</SelectItem>
            {toaNhaList.map((toaNha) => (
              <SelectItem key={toaNha._id} value={toaNha._id!} className="text-sm">
                {toaNha.tenToaNha}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <div className="space-y-2">
        <Label className="text-xs md:text-sm">Phòng (tùy chọn)</Label>
        <div className="grid grid-cols-2 gap-2 max-h-32 overflow-y-auto border rounded-md p-2">
          {filteredPhongList.length === 0 && (
            <p className="col-span-2 text-xs text-gray-500">
              Không có phòng trong tòa nhà đã chọn
            </p>
          )}
          {filteredPhongList.map((phong) => (
            <div key={phong._id} className="flex items-center space-x-2">
              <input
                type="checkbox"
                id={phong._id}
                checked={formData.phong.includes(phong._id!)}
                onChange={(e) => handlePhongChange(phong._id!, e.target.checked)}
                className="rounded border-gray-300"
              />
              <Label htmlFor={phong._id} className="text-xs cursor-pointer">
                {phong.maPhong}
              </Label>
            </div>
          ))}
        </div>
      </div>

      <div className="space-y-2">
        <Label className="text-xs md:text-sm">Người nhận</Label>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-2 max-h-32 overflow-y-auto border rounded-md p-2">
          {khachThueList.map((khachThue) => (
            <div key={khachThue._id} className="flex items-center space-x-2">
              <input
                type="checkbox"
                id={khachThue._id}
                checked={formData.nguoiNhan.includes(khachThue._id!)}
                onChange={(e) => handleNguoiNhanChange(khachThue._id!, e.target.checked)}
                className="rounded border-gray-300"
              />
              <Label htmlFor={khachThue._id} className="text-xs cursor-pointer truncate">
                {khachThue.hoTen}
              </Label>
            </div>
          ))}
        </div>
      </div>

      <DialogFooter className="flex-col sm:flex-row gap-2">
        <Button type="button" variant="outline" size="sm" onClick={onClose} className="w-full sm:w-auto">
          Hủy
        </Button>
        <Button type="submit" size="sm" className="w-full sm:w-auto">
          {thongBao ? 'Cập nhật' : 'Tạo thông báo'}
        </Button>
      </DialogFooter>
    </form>
  );
}
