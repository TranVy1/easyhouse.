'use client';

import { useState, useEffect, useCallback } from 'react';
import { useSession } from 'next-auth/react';
import Image from 'next/image';
import { Button } from '@/components/ui/button';
import { useCache } from '@/hooks/use-cache';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { DashboardCard, HeroActionButton } from '@/components/dashboard/shared-ui';
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
  Building2,
  AlertCircle,
  ChevronLeft,
  ChevronRight
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

  // Building Pagination state
  const [buildingPage, setBuildingPage] = useState(1);
  const [buildingsPerPage, setBuildingsPerPage] = useState(10);

  useEffect(() => {
    const handleResize = () => {
      if (window.innerWidth < 768) {
        setBuildingsPerPage(4);
      } else if (window.innerWidth < 1024) {
        setBuildingsPerPage(6);
      } else {
        setBuildingsPerPage(10);
      }
    };
    handleResize(); // Initial check
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

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
  const availableRoomCount = phongList.filter(p => p.trangThai === 'trong' || p.trangThai === 'AVAILABLE').length;
  const rentedRoomCount = phongList.filter(p => p.trangThai === 'dangThue' || p.trangThai === 'RENTED').length;
  const maintenanceRoomCount = phongList.filter(p => p.trangThai === 'baoTri' || p.trangThai === 'MAINTENANCE').length;

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
    <div className="space-y-6 md:space-y-8 animate-in fade-in duration-500">
      {/* Hero Section */}
      <section className="phong-hero">
        <div className="phong-hero__content">
          <div className="phong-hero__eyebrow">
            <Home className="h-4 w-4" aria-hidden="true" />
            <span>QUẢN LÝ PHÒNG</span>
          </div>

          <h1>Quản lý phòng</h1>

          <p>
            Theo dõi trạng thái phòng, phòng trống, phòng đang thuê và các phòng cần xử lý trong thời gian thực.
          </p>

          {phongList.length > 0 && (
            <div className="phong-hero__insight">
              <span>
                Hiện có <strong>{availableRoomCount} phòng trống</strong>, <strong>{rentedRoomCount} phòng đang thuê</strong>. Hãy tối ưu lấp đầy để tăng doanh thu.
              </span>
            </div>
          )}

          <div className="phong-hero__stats">
            <div className="phong-hero__stat-card">
              <div className="phong-hero__stat-top">
                <div>
                  <span>Tổng số phòng</span>
                  <strong>{totalElements}</strong>
                </div>
                <Building2 className="h-5 w-5" aria-hidden="true" />
              </div>
              <p>Toàn bộ phòng trong hệ thống</p>
            </div>

            <div className="phong-hero__stat-card phong-hero__stat-card--teal">
              <div className="phong-hero__stat-top">
                <div>
                  <span>Phòng trống</span>
                  <strong>{availableRoomCount}</strong>
                </div>
                <Home className="h-5 w-5" aria-hidden="true" />
              </div>
              <p>Sẵn sàng cho thuê</p>
            </div>

            <div className="phong-hero__stat-card phong-hero__stat-card--orange">
              <div className="phong-hero__stat-top">
                <div>
                  <span>Đang thuê</span>
                  <strong>{rentedRoomCount}</strong>
                </div>
                <Users className="h-5 w-5" aria-hidden="true" />
              </div>
              <p>Đang có khách sử dụng</p>
            </div>

            <div className="phong-hero__stat-card phong-hero__stat-card--red">
              <div className="phong-hero__stat-top">
                <div>
                  <span>Bảo trì</span>
                  <strong>{maintenanceRoomCount}</strong>
                </div>
                <AlertCircle className="h-5 w-5" aria-hidden="true" />
              </div>
              <p>{maintenanceRoomCount > 0 ? 'Phòng cần xử lý' : 'Không có phòng cần xử lý'}</p>
            </div>
          </div>
        </div>

        <div className="phong-hero__actions">
          <HeroActionButton
            variant="secondary"
            className="phong-hero__button phong-hero__button-secondary"
            onClick={handleRefresh}
            disabled={isRefreshing}
          >
            <RefreshCw className={`h-4 w-4 sm:mr-2 ${isRefreshing ? 'animate-spin' : ''}`} />
            <span className="hidden sm:inline">{isRefreshing ? 'Đang tải...' : 'Tải mới'}</span>
          </HeroActionButton>

          <FolderImageUploader
            toaNhaList={toaNhaList}
            accessToken={accessToken as string | undefined}
            onComplete={() => {
              clearCache();
              fetchPhong(selectedToaNha, selectedTrangThai, appliedSearch, pagination.pageIndex + 1, pagination.pageSize);
            }}
            trigger={
              <HeroActionButton variant="secondary" className="phong-hero__button phong-hero__button-secondary">
                <ImageIcon className="h-4 w-4 sm:mr-2" />
                <span className="hidden sm:inline">Upload ảnh</span>
              </HeroActionButton>
            }
          />

          <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
            <DialogTrigger asChild>
              <HeroActionButton variant="default" className="phong-hero__button phong-hero__button-primary">
                <Plus className="h-4 w-4 sm:mr-2" />
                <span className="hidden sm:inline">Thêm phòng</span>
                <span className="sm:hidden">Thêm</span>
              </HeroActionButton>
            </DialogTrigger>
            <DialogContent className="sm:max-w-[800px] max-h-[calc(100dvh-32px)] flex flex-col p-0 gap-0 w-[95vw] md:w-full rounded-2xl overflow-hidden border-0 shadow-2xl">
              <div className="shrink-0 px-6 pt-6 pb-4">
                <DialogHeader>
                  <DialogTitle className="text-xl md:text-2xl font-bold text-[#243B5A]">
                    {editingPhong ? 'Chỉnh sửa phòng' : 'Thêm phòng mới'}
                  </DialogTitle>
                  <DialogDescription className="text-sm text-gray-500 mt-1">
                    {editingPhong ? 'Cập nhật thông tin chi tiết của phòng.' : 'Nhập thông tin chi tiết cho phòng mới của bạn.'}
                  </DialogDescription>
                </DialogHeader>
              </div>

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
        </div>
      </section>

      {/* Bộ lọc Tòa nhà dưới dạng thẻ */}
      <div className="space-y-3">
        <div className="flex justify-between items-center px-1">
          <h2 className="text-sm md:text-base font-bold text-[#243B5A] flex items-center gap-2">
            <Building2 className="h-5 w-5 text-[#4FA7A0]" />
            Chọn tòa nhà
          </h2>
          {selectedToaNha && selectedToaNha !== 'all' && (
            <Button 
              variant="ghost" 
              size="sm" 
              onClick={() => setSelectedToaNha('all')} 
              className="text-xs text-[#4FA7A0] hover:text-[#243B5A] h-auto p-0 transition-colors"
            >
              Xem tất cả
            </Button>
          )}
        </div>
        
        {/* Container hiển thị các thẻ tòa nhà */}
        <div className="flex md:grid md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4 overflow-x-auto pb-4 pt-2 scrollbar-thin snap-x scroll-smooth -mx-4 px-4 md:mx-0 md:px-0 min-h-[160px]">
          {(() => {
            const combinedBuildings = [
              { _id: 'all', isAllCard: true } as unknown as ToaNha & { isAllCard?: boolean },
              ...(toaNhaList as (ToaNha & { isAllCard?: boolean })[])
            ];
            
            const totalBuildingPages = Math.ceil(combinedBuildings.length / buildingsPerPage);
            const currentPage = Math.min(buildingPage, totalBuildingPages || 1);
            const startIndex = (currentPage - 1) * buildingsPerPage;
            const endIndex = startIndex + buildingsPerPage;
            const paginatedBuildings = combinedBuildings.slice(startIndex, endIndex);

            return paginatedBuildings.map((item, index) => {
              if (item.isAllCard) {
                return (
                  <div 
                    key="all"
                    onClick={() => setSelectedToaNha('all')}
                    className={`flex-shrink-0 w-[240px] md:w-auto snap-start cursor-pointer rounded-[16px] border p-4 transition-all duration-300 hover:-translate-y-1 hover:shadow-lg flex flex-col justify-between group animate-in fade-in slide-in-from-bottom-2 ${
                      (!selectedToaNha || selectedToaNha === 'all')
                        ? 'border-[#4FA7A0] bg-gradient-to-br from-white to-[#4FA7A0]/5 shadow-md ring-1 ring-[#4FA7A0]/20'
                        : 'border-gray-200/60 bg-white hover:border-[#4FA7A0]/50'
                    }`}
                    style={{ animationFillMode: 'both', animationDelay: `${index * 50}ms` }}
                  >
                    <div>
                      <div className="flex items-start justify-between">
                        <div className={`p-3 rounded-xl transition-colors duration-300 ${
                          (!selectedToaNha || selectedToaNha === 'all') ? 'bg-[#4FA7A0] text-white shadow-sm' : 'bg-[#F8F3EC] text-[#243B5A] group-hover:bg-[#4FA7A0]/10 group-hover:text-[#4FA7A0]'
                        }`}>
                          <Building2 className="h-6 w-6" />
                        </div>
                        {(!selectedToaNha || selectedToaNha === 'all') && (
                          <span className="flex h-6 w-6 items-center justify-center rounded-full bg-[#243B5A] text-white text-[10px] font-bold shadow-sm animate-in zoom-in">
                            ✓
                          </span>
                        )}
                      </div>
                      <div className="mt-5">
                        <h3 className="font-semibold text-[#243B5A] text-base md:text-lg">Tất cả tòa nhà</h3>
                        <p className="text-xs text-gray-500 mt-1">Hệ thống EasyHouse</p>
                      </div>
                    </div>
                    <div className="mt-5 pt-4 border-t border-dashed border-gray-200 flex flex-col gap-2">
                      <div className="flex items-center justify-between text-sm text-gray-600">
                        <span>Tổng số phòng:</span>
                        <span className="font-bold text-[#243B5A]">
                          {toaNhaList.reduce((acc, curr) => acc + (curr.tongSoPhong || 0), 0)}
                        </span>
                      </div>
                      {/* Progress bar for 'All' */}
                      {(() => {
                         const total = toaNhaList.reduce((acc, curr) => acc + (curr.tongSoPhong || 0), 0);
                         const rented = toaNhaList.reduce((acc, curr) => acc + (curr.phongDangThue || 0), 0);
                         const percent = total > 0 ? Math.round((rented / total) * 100) : 0;
                         return (
                           <div className="w-full bg-gray-100 rounded-full h-1.5 mt-1 overflow-hidden">
                             <div className="bg-[#4FA7A0] h-1.5 rounded-full transition-all duration-1000" style={{ width: `${percent}%` }}></div>
                           </div>
                         );
                      })()}
                    </div>
                  </div>
                );
              }

              const toaNha = item as ToaNha;
              const isActive = selectedToaNha === toaNha._id;
              const address = toaNha.diaChiDayDu || 
                (toaNha.diaChi 
                  ? `${toaNha.diaChi.soNha || ''} ${toaNha.diaChi.duong || ''}, ${toaNha.diaChi.quan || ''}`.trim().replace(/^,|,$/g, '')
                  : '');
              const hasImage = toaNha.anhToaNha && toaNha.anhToaNha.length > 0;
              const firstImage = hasImage ? toaNha.anhToaNha[0] : null;
              const percent = (toaNha.tongSoPhong && toaNha.tongSoPhong > 0) ? Math.round(((toaNha.phongDangThue || 0) / toaNha.tongSoPhong) * 100) : 0;

              return (
                <div
                  key={toaNha._id}
                  onClick={() => setSelectedToaNha(toaNha._id!)}
                  className={`flex-shrink-0 w-[240px] md:w-auto snap-start cursor-pointer rounded-[16px] border overflow-hidden transition-all duration-300 hover:-translate-y-1 hover:shadow-lg flex flex-col justify-between group animate-in fade-in slide-in-from-bottom-2 ${
                    isActive
                      ? 'border-[#4FA7A0] bg-gradient-to-br from-white to-[#4FA7A0]/5 shadow-md ring-1 ring-[#4FA7A0]/20'
                      : 'border-gray-200/60 bg-white hover:border-[#4FA7A0]/50'
                  }`}
                  style={{ animationFillMode: 'both', animationDelay: `${index * 50}ms` }}
                >
                  {/* Building Cover Image */}
                  <div className="relative h-28 w-full bg-gradient-to-br from-[#243B5A]/10 to-[#4FA7A0]/10 flex items-center justify-center overflow-hidden border-b border-gray-100/50">
                    {firstImage ? (
                      <Image
                        src={firstImage}
                        alt={toaNha.tenToaNha}
                        fill
                        sizes="240px"
                        className="object-cover transition-transform duration-700 group-hover:scale-110"
                      />
                    ) : (
                      <Building2 className="h-10 w-10 text-[#243B5A]/30 group-hover:text-[#4FA7A0]/50 transition-colors" />
                    )}
                    <div className="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent opacity-50"></div>
                    {isActive && (
                      <div className="absolute top-2 right-2 flex h-6 w-6 items-center justify-center rounded-full bg-[#243B5A] text-white text-[10px] font-bold shadow-md animate-in zoom-in z-10 border-2 border-white">
                        ✓
                      </div>
                    )}
                  </div>

                  {/* Building Content */}
                  <div className="p-4 flex-1 flex flex-col justify-between">
                    <div>
                      <h3 className="font-semibold text-[#243B5A] text-base line-clamp-1 group-hover:text-[#4FA7A0] transition-colors">
                        {toaNha.tenToaNha}
                      </h3>
                      <p className="text-[11px] text-gray-500 mt-1 line-clamp-2 leading-snug" title={address}>
                        {address || 'Chưa cập nhật địa chỉ'}
                      </p>
                    </div>

                    <div className="mt-4 pt-3 border-t border-dashed border-gray-200 flex flex-col gap-2">
                       <div className="flex justify-between items-end text-xs">
                         <span className="text-gray-500 font-medium">Lấp đầy <span className="text-[#4FA7A0] font-bold">{percent}%</span></span>
                         <span className="text-gray-500">{toaNha.phongDangThue || 0}/{toaNha.tongSoPhong || 0}</span>
                       </div>
                       <div className="w-full bg-gray-100 rounded-full h-1.5 overflow-hidden">
                         <div className="bg-[#4FA7A0] h-1.5 rounded-full transition-all duration-1000" style={{ width: `${percent}%` }}></div>
                       </div>
                    </div>
                  </div>
                </div>
              );
            });
          })()}
        </div>

        {/* Phân trang tòa nhà */}
        {(() => {
          const totalBuildingPages = Math.ceil((toaNhaList.length + 1) / buildingsPerPage);
          if (totalBuildingPages <= 1) return null;
          
          const currentPage = Math.min(buildingPage, totalBuildingPages);
          const startIndex = (currentPage - 1) * buildingsPerPage;
          const endIndex = Math.min(startIndex + buildingsPerPage, toaNhaList.length + 1);

          return (
            <div className="flex items-center justify-between px-1 mt-1 animate-in fade-in">
              <div className="text-xs md:text-sm text-gray-500 font-medium">
                Hiển thị {startIndex + 1}-{endIndex} của {toaNhaList.length + 1} tòa nhà
              </div>
              <div className="flex items-center gap-1">
                <Button
                  variant="outline"
                  size="icon"
                  className="h-8 w-8 rounded-full border-gray-200 text-[#243B5A] hover:bg-gray-100 disabled:opacity-40 disabled:hover:bg-transparent transition-all"
                  onClick={() => setBuildingPage(p => Math.max(1, p - 1))}
                  disabled={currentPage === 1}
                >
                  <ChevronLeft className="h-4 w-4" />
                </Button>
                <div className="flex items-center gap-1 px-2">
                  {Array.from({ length: totalBuildingPages }).map((_, i) => {
                    const page = i + 1;
                    const isActive = page === currentPage;
                    return (
                      <button
                        key={page}
                        onClick={() => setBuildingPage(page)}
                        className={`h-7 w-7 rounded-full text-xs font-semibold transition-all duration-300 focus-visible:ring-2 focus-visible:ring-[#4FA7A0]/50 focus:outline-none ${
                          isActive 
                            ? 'bg-[#4FA7A0] text-white shadow-sm transform scale-105' 
                            : 'text-gray-500 hover:bg-gray-100 hover:text-[#243B5A]'
                        }`}
                      >
                        {page}
                      </button>
                    );
                  })}
                </div>
                <Button
                  variant="outline"
                  size="icon"
                  className="h-8 w-8 rounded-full border-gray-200 text-[#243B5A] hover:bg-gray-100 disabled:opacity-40 disabled:hover:bg-transparent transition-all"
                  onClick={() => setBuildingPage(p => Math.min(totalBuildingPages, p + 1))}
                  disabled={currentPage === totalBuildingPages}
                >
                  <ChevronRight className="h-4 w-4" />
                </Button>
              </div>
            </div>
          );
        })()}
      </div>



      {/* Desktop Table View */}
      <DashboardCard className="hidden md:block overflow-hidden">
        <CardHeader className="border-b bg-[#F2E8DC]/70 pb-4">
          <CardTitle className="text-lg text-[#243B5A]">Danh sách phòng</CardTitle>
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
      </DashboardCard>

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
                  case 'AVAILABLE': return 'bg-[#4FA7A0]/15 text-[#4FA7A0] border border-[#4FA7A0]/20';
                  case 'daDat':
                  case 'RESERVED': return 'bg-[#F2A45B]/15 text-[#F2A45B] border border-[#F2A45B]/20';
                  case 'dangThue':
                  case 'RENTED': return 'bg-[#243B5A]/10 text-[#243B5A] border border-[#243B5A]/20';
                  case 'baoTri':
                  case 'MAINTENANCE':
                  case 'INACTIVE': return 'bg-red-50 text-red-600 border border-red-200';
                  default: return 'bg-gray-100 text-gray-800 border border-gray-200';
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
                <Card key={phong._id} className="hover:shadow-md transition-shadow border-gray-200/60 rounded-[16px]">
                  <CardContent className="p-4">
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
                        <span className="text-gray-500">Giá thuê:</span>
                        <span className="font-semibold text-[#243B5A]">
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
                          <div className="mb-3 p-2 bg-[#4FA7A0]/10 rounded-md border border-[#4FA7A0]/30">
                            <div className="flex items-center gap-1.5 mb-1">
                              <Users className="h-3.5 w-3.5 text-[#243B5A]" />
                              <span className="text-xs font-medium text-[#243B5A]">Người thuê</span>
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
                                className="text-xs text-[#243B5A] hover:text-[#243B5A] h-auto p-0 mt-0.5"
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
                            className="text-[#243B5A] hover:text-[#243B5A] hover:bg-[#4FA7A0]/10"
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
                          className="text-[#243B5A] hover:text-[#243B5A] hover:bg-[#4FA7A0]/10"
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
                      <div className="w-10 h-10 md:w-12 md:h-12 rounded-full bg-[#4FA7A0]/15 flex items-center justify-center">
                        <Users className="h-5 w-5 md:h-6 md:w-6 text-[#243B5A]" />
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

