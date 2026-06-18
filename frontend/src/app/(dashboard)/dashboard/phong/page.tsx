'use client';

import { useState, useEffect, useCallback } from 'react';
import { useSession } from 'next-auth/react';
import Image from 'next/image';
import { Button } from '@/components/ui/button';
import { useCache } from '@/hooks/use-cache';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
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
  Home,
  Users,
  Eye,
  Copy,
  Info,
  Image as ImageIcon,
  RefreshCw,
  ExternalLink,
  Building2
} from 'lucide-react';
import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
} from '@/components/ui/carousel';
import { Phong, ToaNha } from '@/types';
import { PhongDataTable } from './table';
import { PhongForm } from '@/components/ui/phong-form';
import { PhongImageUpload } from '@/components/ui/phong-image-upload';
import { FolderImageUploader } from '@/components/ui/folder-image-uploader';
import { DeleteConfirmPopover } from '@/components/ui/delete-confirm-popover';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { toast } from 'sonner';
import { unwrapPageData } from '@/lib/api-response';

type PhongTenant = {
  _id: string;
  hoTen: string;
  soDienThoai: string;
};

export default function PhongPage() {
  const accessToken = useSession()?.data?.accessToken;
  const { clearCache, isRefreshing, setIsRefreshing } = useCache<{
    phongList: Phong[];
    toaNhaList: ToaNha[];
  }>({ key: 'phong-data', duration: 300000 }); // 5 phút

  const [phongList, setPhongList] = useState<Phong[]>([]);
  const [toaNhaList, setToaNhaList] = useState<ToaNha[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [appliedSearch, setAppliedSearch] = useState('');
  const [selectedToaNha, setSelectedToaNha] = useState('');
  const [selectedTrangThai, setSelectedTrangThai] = useState('');
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [editingPhong, setEditingPhong] = useState<Phong | null>(null);
  const [isImageViewerOpen, setIsImageViewerOpen] = useState(false);
  const [viewingImages, setViewingImages] = useState<string[]>([]);
  const [viewingPhongName, setViewingPhongName] = useState('');
  const [isTenantsViewerOpen, setIsTenantsViewerOpen] = useState(false);
  const [viewingTenants, setViewingTenants] = useState<PhongTenant[]>([]);
  const [viewingTenantsPhongName, setViewingTenantsPhongName] = useState('');

  // Pagination state
  const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 10 });
  const [totalElements, setTotalElements] = useState(0);
  const [totalPages, setTotalPages] = useState(0);

  useEffect(() => {
    document.title = 'Quản lý Phòng';
  }, []);

  const fetchPhong = useCallback(async (toaNhaFilter = '', trangThaiFilter = '', search = '', page = 1, limit = 10) => {
    try {
      setLoading(true);

      let phongSuccess = false;
      let toaNhaSuccess = false;

      const params = new URLSearchParams({
        page: page.toString(),
        limit: limit.toString()
      });
      if (toaNhaFilter && toaNhaFilter !== 'all') params.append('toaNha', toaNhaFilter);
      if (trangThaiFilter && trangThaiFilter !== 'all') params.append('trangThai', trangThaiFilter);
      if (search) params.append('search', search);

      // Fetch phong
      const response = await fetch(`/api/phong?${params.toString()}`, {
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      });
      let phongData: Phong[] = [];
      if (response.ok) {
        const result = await response.json();
        if (result.success) {
          phongData = Array.isArray(result.data) ? result.data : (result.data?.data || []);
          setPhongList(phongData);
          if (result.data && !Array.isArray(result.data)) {
            setTotalElements(result.data.total || 0);
            setTotalPages(result.data.totalPages || 0);
          } else {
            setTotalElements(phongData.length);
            setTotalPages(1);
          }
          phongSuccess = true;
        }
      }

      // Fetch toa nha
      const toaNhaResponse = await fetch('/api/toa-nha?page=1&limit=100', {
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      });
      let toaNhaData: ToaNha[] = [];
      if (toaNhaResponse.ok) {
        const result = await toaNhaResponse.json();
        if (result.success) {
          toaNhaData = unwrapPageData<ToaNha>(result.data);
          setToaNhaList(toaNhaData);
          toaNhaSuccess = true;
        }
      }

      // Remove caching for now since pagination makes it complex
      if (phongSuccess && toaNhaSuccess) {
        // Not setting cache for paginated lists
      }
    } catch (error) {
      console.error('Error fetching phong:', error);
    } finally {
      setLoading(false);
    }
  }, [accessToken]);

  const fetchToaNha = useCallback(async () => {
    try {
      const response = await fetch('/api/toa-nha?page=1&limit=100', {
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      });
      if (response.ok) {
        const result = await response.json();
        if (result.success) {
          setToaNhaList(unwrapPageData<ToaNha>(result.data));
        }
      }
    } catch (error) {
      console.error('Error fetching toa nha:', error);
    }
  }, [accessToken]);

  useEffect(() => {
    fetchPhong(selectedToaNha, selectedTrangThai, appliedSearch, pagination.pageIndex + 1, pagination.pageSize);
  }, [fetchPhong, selectedToaNha, selectedTrangThai, appliedSearch, pagination.pageIndex, pagination.pageSize]);

  useEffect(() => {
    const timeout = window.setTimeout(() => {
      setAppliedSearch(searchTerm.trim());
      setPagination(prev => ({ ...prev, pageIndex: 0 }));
    }, 350);
    return () => window.clearTimeout(timeout);
  }, [searchTerm]);

  useEffect(() => {
    fetchToaNha();
  }, [fetchToaNha]);

  const handleRefresh = async () => {
    setIsRefreshing(true);
    await fetchPhong(selectedToaNha, selectedTrangThai, appliedSearch, pagination.pageIndex + 1, pagination.pageSize);
    setIsRefreshing(false);
    toast.success('Đã tải dữ liệu mới nhất');
  };

  useEffect(() => {
    // Reset pagination when filter changes
    setPagination(prev => ({ ...prev, pageIndex: 0 }));
  }, [selectedToaNha, selectedTrangThai]);

  const filteredPhong = phongList;

  const handleEdit = (phong: Phong) => {
    setEditingPhong(phong);
    setIsDialogOpen(true);
  };

  const handleDelete = async (id: string) => {
    try {
      const response = await fetch(`/api/phong/${id}`, {
        method: 'DELETE',
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      });

      if (response.ok) {
        const result = await response.json();
        if (result.success) {
          clearCache();
          await fetchPhong(selectedToaNha, selectedTrangThai, appliedSearch, pagination.pageIndex + 1, pagination.pageSize);
          toast.success('Xóa phòng thành công!');
        } else {
          toast.error(result.message || 'Có lỗi xảy ra khi xóa phòng');
        }
      } else {
        const error = await response.json();
        toast.error(error.message || 'Có lỗi xảy ra khi xóa phòng');
      }
    } catch (error) {
      console.error('Error deleting phong:', error);
      toast.error('Có lỗi xảy ra khi xóa phòng');
    }
  };

  const handleViewImages = (phong: Phong) => {
    if (phong.anhPhong && phong.anhPhong.length > 0) {
      setViewingImages(phong.anhPhong);
      setViewingPhongName(phong.maPhong);
      setIsImageViewerOpen(true);
    } else {
      toast.info('Phòng này chưa có ảnh nào');
    }
  };

  const handleViewTenants = (phong: Phong) => {
    const hopDong = phong.hopDongHienTai;

    if (hopDong && hopDong.khachThueId && hopDong.khachThueId.length > 0) {
      setViewingTenants(hopDong.khachThueId);
      setViewingTenantsPhongName(phong.maPhong);
      setIsTenantsViewerOpen(true);
    } else {
      toast.info('Phòng này chưa có người thuê');
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
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3 md:gap-4">
        <div>
          <h1 className="text-xl md:text-2xl font-bold text-gray-900">Quản lý phòng</h1>
          <p className="text-xs md:text-sm text-gray-600">Danh sách tất cả phòng trong hệ thống</p>
        </div>
        <div className="flex flex-wrap gap-2 w-full sm:w-auto">
          <Button
            variant="outline"
            size="sm"
            onClick={handleRefresh}
            disabled={isRefreshing}
          >
            <RefreshCw className={`h-4 w-4 mr-2 ${isRefreshing ? 'animate-spin' : ''}`} />
            {isRefreshing ? 'Đang tải...' : 'Tải mới'}
          </Button>

          <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
            <DialogTrigger asChild>
              <Button size="sm" onClick={() => setEditingPhong(null)} className="w-full sm:w-auto">
                <Plus className="h-4 w-4 mr-2" />
                Thêm phòng
              </Button>
            </DialogTrigger>
            <DialogContent className="max-w-5xl max-h-[90vh] overflow-y-auto w-[95vw] md:w-full">
              <DialogHeader>
                <DialogTitle className="text-base md:text-lg">
                  {editingPhong ? 'Chỉnh sửa phòng' : 'Thêm phòng mới'}
                </DialogTitle>
                <DialogDescription className="text-xs md:text-sm">
                  {editingPhong ? 'Cập nhật thông tin phòng' : 'Nhập thông tin phòng mới'}
                </DialogDescription>
              </DialogHeader>

              <PhongForm
                key={editingPhong?._id || 'new'}
                phong={editingPhong}
                toaNhaList={toaNhaList}
                onClose={() => setIsDialogOpen(false)}
                onSuccess={() => {
                  clearCache();
                  setIsDialogOpen(false);
                  fetchPhong(selectedToaNha, selectedTrangThai, appliedSearch, pagination.pageIndex + 1, pagination.pageSize);
                  toast.success(editingPhong ? 'Cập nhật phòng thành công!' : 'Thêm phòng thành công!');
                }}
              />
            </DialogContent>
          </Dialog>

          <FolderImageUploader
            toaNhaList={toaNhaList}
            accessToken={accessToken as string | undefined}
            onComplete={() => {
              clearCache();
              fetchPhong(selectedToaNha, selectedTrangThai, appliedSearch, pagination.pageIndex + 1, pagination.pageSize);
            }}
          />
        </div>
      </div>

      {/* Bộ lọc Tòa nhà dưới dạng thẻ */}
      <div className="space-y-3">
        <div className="flex justify-between items-center">
          <h2 className="text-sm md:text-base font-semibold text-gray-900 flex items-center gap-2">
            <Building2 className="h-4 w-4 text-indigo-600 animate-pulse" />
            Chọn tòa nhà
          </h2>
          {selectedToaNha && selectedToaNha !== 'all' && (
            <Button 
              variant="ghost" 
              size="sm" 
              onClick={() => setSelectedToaNha('all')} 
              className="text-xs text-indigo-600 hover:text-indigo-700 h-auto p-0"
            >
              Xem tất cả
            </Button>
          )}
        </div>
        
        {/* Container hiển thị các thẻ tòa nhà */}
        <div className="flex md:grid md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-3 overflow-x-auto pb-3 pt-1 scrollbar-thin snap-x scroll-smooth -mx-4 px-4 md:mx-0 md:px-0">
          {/* Thẻ Tất cả tòa nhà */}
          <div 
            onClick={() => setSelectedToaNha('all')}
            className={`flex-shrink-0 w-[220px] md:w-auto snap-start cursor-pointer rounded-xl border p-4 transition-all duration-300 hover:-translate-y-1 hover:shadow-md flex flex-col justify-between ${
              (!selectedToaNha || selectedToaNha === 'all')
                ? 'border-indigo-600 bg-indigo-50/40 ring-2 ring-indigo-600/20'
                : 'border-gray-200 bg-white hover:border-gray-300'
            }`}
          >
            <div>
              <div className="flex items-start justify-between">
                <div className={`p-2.5 rounded-lg ${
                  (!selectedToaNha || selectedToaNha === 'all') ? 'bg-indigo-600 text-white' : 'bg-indigo-100 text-indigo-600'
                }`}>
                  <Building2 className="h-5 w-5" />
                </div>
                {(!selectedToaNha || selectedToaNha === 'all') && (
                  <span className="flex h-5 w-5 items-center justify-center rounded-full bg-indigo-600 text-white text-[10px] font-bold">
                    ✓
                  </span>
                )}
              </div>
              <div className="mt-4">
                <h3 className="font-semibold text-gray-900 text-sm md:text-base">Tất cả tòa nhà</h3>
                <p className="text-xs text-gray-500 mt-1">Hệ thống EasyHouse</p>
              </div>
            </div>
            <div className="mt-4 pt-3 border-t border-dashed border-gray-100 flex items-center justify-between text-xs text-gray-600">
              <span>Tổng số phòng:</span>
              <span className="font-semibold text-gray-900">
                {toaNhaList.reduce((acc, curr) => acc + (curr.tongSoPhong || 0), 0)}
              </span>
            </div>
          </div>

          {/* Danh sách từng tòa nhà */}
          {toaNhaList.map((toaNha) => {
            const isActive = selectedToaNha === toaNha._id;
            const address = toaNha.diaChiDayDu || 
              (toaNha.diaChi 
                ? `${toaNha.diaChi.soNha || ''} ${toaNha.diaChi.duong || ''}, ${toaNha.diaChi.quan || ''}`.trim().replace(/^,|,$/g, '')
                : '');
            const hasImage = toaNha.anhToaNha && toaNha.anhToaNha.length > 0;
            const firstImage = hasImage ? toaNha.anhToaNha[0] : null;

            return (
              <div
                key={toaNha._id}
                onClick={() => setSelectedToaNha(toaNha._id!)}
                className={`flex-shrink-0 w-[220px] md:w-auto snap-start cursor-pointer rounded-xl border overflow-hidden transition-all duration-300 hover:-translate-y-1 hover:shadow-md flex flex-col justify-between ${
                  isActive
                    ? 'border-indigo-600 bg-indigo-50/40 ring-2 ring-indigo-600/20'
                    : 'border-gray-200 bg-white hover:border-gray-300'
                }`}
              >
                {/* Building Cover Image */}
                <div className="relative h-24 w-full bg-gradient-to-br from-indigo-500/10 to-purple-500/10 flex items-center justify-center overflow-hidden border-b border-gray-100">
                  {firstImage ? (
                    <Image
                      src={firstImage}
                      alt={toaNha.tenToaNha}
                      fill
                      sizes="220px"
                      className="object-cover transition-transform duration-500 hover:scale-110"
                    />
                  ) : (
                    <Building2 className="h-8 w-8 text-indigo-500/60" />
                  )}
                  {isActive && (
                    <div className="absolute top-2 right-2 flex h-5 w-5 items-center justify-center rounded-full bg-indigo-600 text-white text-[10px] font-bold shadow-sm z-10">
                      ✓
                    </div>
                  )}
                </div>

                {/* Building Content */}
                <div className="p-3 flex-1 flex flex-col justify-between">
                  <div>
                    <h3 className="font-semibold text-gray-900 text-sm md:text-base line-clamp-1">
                      {toaNha.tenToaNha}
                    </h3>
                    <p className="text-[10px] md:text-xs text-gray-500 mt-1 line-clamp-1 flex items-center gap-1" title={address}>
                      {address || 'Chưa cập nhật địa chỉ'}
                    </p>
                  </div>

                  {/* Building Stats */}
                  <div className="mt-3 pt-2.5 border-t border-dashed border-gray-100 grid grid-cols-2 gap-1 text-[10px] md:text-xs text-gray-600">
                    <div className="flex flex-col">
                      <span className="text-gray-400">Trống:</span>
                      <span className="font-semibold text-green-600">{toaNha.phongTrong ?? 0} phòng</span>
                    </div>
                    <div className="flex flex-col text-right">
                      <span className="text-gray-400">Đang thuê:</span>
                      <span className="font-semibold text-blue-600">{toaNha.phongDangThue ?? 0} phòng</span>
                    </div>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-2 md:gap-3">
        <Card className="p-2 md:p-3">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-[10px] md:text-xs font-medium text-gray-600">Tổng số phòng</p>
              <p className="text-lg md:text-xl font-bold">{totalElements}</p>
            </div>
            <Home className="h-4 w-4 md:h-5 md:w-5 text-blue-500" />
          </div>
        </Card>

        <Card className="p-2 md:p-3">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-[10px] md:text-xs font-medium text-gray-600">Phòng trống</p>
              <p className="text-lg md:text-xl font-bold text-green-600">
                {phongList.filter(p => p.trangThai === 'trong' || p.trangThai === 'AVAILABLE').length}
              </p>
            </div>
            <Users className="h-4 w-4 md:h-5 md:w-5 text-green-500" />
          </div>
        </Card>

        <Card className="p-2 md:p-3">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-[10px] md:text-xs font-medium text-gray-600">Đang thuê</p>
              <p className="text-lg md:text-xl font-bold text-blue-600">
                {phongList.filter(p => p.trangThai === 'dangThue' || p.trangThai === 'RENTED').length}
              </p>
            </div>
            <Users className="h-4 w-4 md:h-5 md:w-5 text-blue-500" />
          </div>
        </Card>

        <Card className="p-2 md:p-3">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-[10px] md:text-xs font-medium text-gray-600">Bảo trì</p>
              <p className="text-lg md:text-xl font-bold text-red-600">
                {phongList.filter(p => p.trangThai === 'baoTri').length}
              </p>
            </div>
            <Users className="h-4 w-4 md:h-5 md:w-5 text-red-500" />
          </div>
        </Card>
      </div>

      {/* Desktop Table View */}
      <Card className="hidden md:block">
        <CardHeader>
          <CardTitle>Danh sách phòng</CardTitle>
          <CardDescription>
            {filteredPhong.length} phòng được tìm thấy
          </CardDescription>
        </CardHeader>
        <CardContent className="p-6">
          <PhongDataTable
            data={filteredPhong}
            toaNhaList={toaNhaList}
            onEdit={handleEdit}
            onDelete={handleDelete}
            onViewImages={handleViewImages}
            onViewTenants={handleViewTenants}
            searchTerm={searchTerm}
            onSearchChange={setSearchTerm}
            selectedTrangThai={selectedTrangThai}
            onTrangThaiChange={setSelectedTrangThai}
            pageCount={totalPages}
            totalElements={totalElements}
            pagination={pagination}
            onPaginationChange={setPagination}
          />
        </CardContent>
      </Card>

      {/* Mobile Card View */}
      <div className="md:hidden space-y-3">
        <div className="flex justify-between items-center">
          <h2 className="text-base font-semibold">Danh sách phòng</h2>
          <span className="text-xs text-gray-600">{filteredPhong.length} phòng</span>
        </div>

        {/* Mobile Filters */}
        <div className="space-y-2">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
            <Input
              placeholder="Tìm kiếm phòng..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="pl-10 text-sm"
            />
          </div>
          <div>
            <Select value={selectedTrangThai} onValueChange={setSelectedTrangThai}>
              <SelectTrigger className="text-sm w-full">
                <SelectValue placeholder="Trạng thái" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all" className="text-sm">Tất cả trạng thái</SelectItem>
                <SelectItem value="trong" className="text-sm">Trống</SelectItem>
                <SelectItem value="daDat" className="text-sm">Đã đặt</SelectItem>
                <SelectItem value="dangThue" className="text-sm">Đang thuê</SelectItem>
                <SelectItem value="baoTri" className="text-sm">Bảo trì</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>

        {filteredPhong.length === 0 ? (
          <Card className="p-6 text-center">
            <Home className="h-10 w-10 mx-auto text-gray-400 mb-3" />
            <h3 className="text-base font-medium text-gray-900 mb-1">Không tìm thấy phòng nào</h3>
            <p className="text-sm text-gray-600">Thử thay đổi bộ lọc hoặc tìm kiếm khác</p>
          </Card>
        ) : (
          <div className="grid grid-cols-1 gap-3">
            {filteredPhong.map((phong) => {
              const getTrangThaiColor = (trangThai: string) => {
                switch (trangThai) {
                  case 'trong':
                  case 'AVAILABLE': return 'bg-green-100 text-green-800';
                  case 'daDat':
                  case 'RESERVED': return 'bg-yellow-100 text-yellow-800';
                  case 'dangThue':
                  case 'RENTED': return 'bg-blue-100 text-blue-800';
                  case 'baoTri':
                  case 'MAINTENANCE':
                  case 'INACTIVE': return 'bg-red-100 text-red-800';
                  default: return 'bg-gray-100 text-gray-800';
                }
              };

              const getTrangThaiText = (trangThai: string) => {
                switch (trangThai) {
                  case 'trong':
                  case 'AVAILABLE': return 'Trống';
                  case 'daDat':
                  case 'RESERVED': return 'Đã đặt';
                  case 'dangThue':
                  case 'RENTED': return 'Đang thuê';
                  case 'baoTri':
                  case 'MAINTENANCE': return 'Bảo trì';
                  case 'INACTIVE': return 'Ngưng hoạt động';
                  default: return trangThai;
                }
              };

              return (
                <Card key={phong._id} className="hover:shadow-md transition-shadow">
                  <CardContent className="p-3">
                    <div className="flex justify-between items-start mb-2">
                      <div className="flex-1">
                        <h3 className="font-semibold text-base">{phong.maPhong}</h3>
                        <p className="text-xs text-gray-600">Tầng {phong.tang} • {phong.dienTich}m²</p>
                      </div>
                      <Badge className={`${getTrangThaiColor(phong.trangThai)} text-xs`}>
                        {getTrangThaiText(phong.trangThai)}
                      </Badge>
                    </div>

                    <div className="space-y-1.5 mb-3">
                      <div className="flex justify-between text-sm">
                        <span className="text-gray-600">Giá thuê:</span>
                        <span className="font-semibold text-green-600">
                          {new Intl.NumberFormat('vi-VN', {
                            style: 'currency',
                            currency: 'VND'
                          }).format(phong.giaThue)}
                        </span>
                      </div>
                      <div className="flex justify-between text-sm">
                        <span className="text-gray-600">Tiền cọc:</span>
                        <span className="font-medium text-orange-600">
                          {new Intl.NumberFormat('vi-VN', {
                            style: 'currency',
                            currency: 'VND'
                          }).format(phong.tienCoc)}
                        </span>
                      </div>
                      <div className="flex justify-between text-sm border-t border-dashed pt-1 mt-1">
                        <span className="text-gray-600">Người ở tối đa:</span>
                        <span className="font-medium">
                          {phong.soNguoiToiDa || 0} người
                        </span>
                      </div>
                    </div>

                    {/* Thông tin người thuê */}
                    {(() => {
                      const hopDong = phong.hopDongHienTai;

                      if (hopDong && hopDong.khachThueId && hopDong.khachThueId.length > 0) {
                        const nguoiDaiDien = hopDong.nguoiDaiDien;
                        const soLuongKhachThue = hopDong.khachThueId.length;

                        return (
                          <div className="mb-3 p-2 bg-blue-50 rounded-md border border-blue-200">
                            <div className="flex items-center gap-1.5 mb-1">
                              <Users className="h-3.5 w-3.5 text-blue-600" />
                              <span className="text-xs font-medium text-blue-900">Người thuê</span>
                            </div>
                            <div className="text-sm text-gray-900 font-medium">
                              {nguoiDaiDien?.hoTen || 'N/A'}
                            </div>
                            {nguoiDaiDien?.soDienThoai && (
                              <div className="text-xs text-gray-600">
                                {nguoiDaiDien.soDienThoai}
                              </div>
                            )}
                            {soLuongKhachThue > 1 && (
                              <Button
                                variant="link"
                                size="sm"
                                className="text-xs text-blue-600 hover:text-blue-700 h-auto p-0 mt-0.5"
                                onClick={() => handleViewTenants(phong)}
                              >
                                +{soLuongKhachThue - 1} người khác
                              </Button>
                            )}
                          </div>
                        );
                      }
                      return null;
                    })()}

                    {phong.anhPhong && phong.anhPhong.length > 0 && (
                      <div className="mb-3">
                        <div className="relative h-32 w-full overflow-hidden rounded-md" onClick={() => handleViewImages(phong)}>
                          <Image
                            src={phong.anhPhong[0]}
                            alt={phong.maPhong}
                            fill
                            sizes="(max-width: 768px) 100vw, 33vw"
                            className="object-cover"
                          />
                        </div>
                        {phong.anhPhong.length > 1 && (
                          <div className="text-xs text-gray-600 mt-1">
                            +{phong.anhPhong.length - 1} ảnh khác
                          </div>
                        )}
                      </div>
                    )}

                    <div className="space-y-2">
                      <div className="flex gap-2">
                        {phong.anhPhong && phong.anhPhong.length > 0 && (
                          <Button
                            variant="outline"
                            size="sm"
                            onClick={() => handleViewImages(phong)}
                            className="text-blue-600 hover:text-blue-700 hover:bg-blue-50"
                            title="Xem ảnh phòng"
                          >
                            <Eye className="h-3.5 w-3.5" />
                          </Button>
                        )}
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => {
                            const publicUrl = `${window.location.origin}/xem-phong?phong=${phong.maPhong}`;
                            navigator.clipboard.writeText(publicUrl);
                            toast.success(`Đã sao chép link xem phòng ${phong.maPhong}`);
                          }}
                          className="text-blue-600 hover:text-blue-700 hover:bg-blue-50"
                          title="Sao chép link xem phòng"
                        >
                          <Copy className="h-3.5 w-3.5" />
                        </Button>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => {
                            const publicUrl = `${window.location.origin}/xem-phong?phong=${phong.maPhong}`;
                            window.open(publicUrl, '_blank');
                          }}
                          className="text-green-600 hover:text-green-700 hover:bg-green-50"
                          title="Xem trang công khai"
                        >
                          <ExternalLink className="h-3.5 w-3.5" />
                        </Button>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => handleEdit(phong)}
                          className="flex-1 text-xs"
                        >
                          <Edit className="h-3.5 w-3.5 mr-1" />
                          Sửa
                        </Button>
                        <DeleteConfirmPopover
                          onConfirm={() => handleDelete(phong._id!)}
                          title="Xóa phòng"
                          description="Bạn có chắc chắn muốn xóa phòng này?"
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

      {/* Image Viewer Dialog */}
      <Dialog open={isImageViewerOpen} onOpenChange={setIsImageViewerOpen}>
        <DialogContent className="max-w-4xl max-h-[90vh] overflow-hidden w-[95vw] md:w-full">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2 text-base md:text-lg">
              <ImageIcon className="h-4 w-4 md:h-5 md:w-5" />
              Ảnh phòng {viewingPhongName}
            </DialogTitle>
          </DialogHeader>

          <div className="flex-1 overflow-hidden">
            {viewingImages.length > 0 && (
              <Carousel className="w-full">
                <CarouselContent>
                  {viewingImages.map((image, index) => (
                    <CarouselItem key={index}>
                      <div className="flex items-center justify-center p-1 md:p-2">
                        <div className="relative h-[50vh] md:h-[60vh] w-full overflow-hidden rounded-lg">
                          <Image
                            src={image}
                            alt={`Ảnh ${index + 1} của phòng ${viewingPhongName}`}
                            fill
                            sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
                            className="object-contain"
                          />
                        </div>
                      </div>
                    </CarouselItem>
                  ))}
                </CarouselContent>
                {viewingImages.length > 1 && (
                  <>
                    <CarouselPrevious className="hidden md:flex" />
                    <CarouselNext className="hidden md:flex" />
                  </>
                )}
              </Carousel>
            )}
          </div>

          <DialogFooter>
            <div className="text-xs md:text-sm text-gray-600">
              {viewingImages.length} ảnh {viewingImages.length > 1 && '- Vuốt để xem thêm'}
            </div>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Tenants Viewer Dialog */}
      <Dialog open={isTenantsViewerOpen} onOpenChange={setIsTenantsViewerOpen}>
        <DialogContent className="max-w-3xl max-h-[90vh] overflow-auto w-[95vw] md:w-full">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2 text-base md:text-lg">
              <Users className="h-4 w-4 md:h-5 md:w-5" />
              Danh sách người thuê - Phòng {viewingTenantsPhongName}
            </DialogTitle>
            <DialogDescription className="text-xs md:text-sm">
              Tổng cộng {viewingTenants.length} người đang thuê phòng này
            </DialogDescription>
          </DialogHeader>

          <div className="space-y-3 md:space-y-4 py-2 md:py-4">
            {viewingTenants.map((tenant, index) => (
              <Card key={tenant._id || index} className="overflow-hidden">
                <CardContent className="p-3 md:p-4">
                  <div className="flex items-start gap-3 md:gap-4">
                    <div className="flex-shrink-0">
                      <div className="w-10 h-10 md:w-12 md:h-12 rounded-full bg-blue-100 flex items-center justify-center">
                        <Users className="h-5 w-5 md:h-6 md:w-6 text-blue-600" />
                      </div>
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center justify-between mb-1 md:mb-2">
                        <h3 className="text-base md:text-lg font-semibold text-gray-900">
                          {tenant.hoTen}
                        </h3>
                        <Badge variant="outline" className="ml-2 text-xs">
                          #{index + 1}
                        </Badge>
                      </div>

                      <div className="grid grid-cols-1 gap-2">
                        <div className="flex items-center gap-2 text-sm">
                          <span className="font-medium text-gray-600">SĐT:</span>
                          <span className="text-gray-900">{tenant.soDienThoai}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>

          <DialogFooter>
            <Button variant="outline" onClick={() => setIsTenantsViewerOpen(false)} className="text-sm">
              Đóng
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}

