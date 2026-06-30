'use client';

import { useState, useEffect, useCallback } from 'react';
import { useSession } from 'next-auth/react';
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
import { 
  Plus, 
  Search, 
  Edit, 
  Trash2, 
  Users, 
  Phone,
  Mail,
  Calendar,
  MapPin,
  Info,
  CreditCard,
  RefreshCw,
  Copy
} from 'lucide-react';
import { KhachThue } from '@/types';
import { KhachThueDataTable } from './table';
import { CCCDUpload } from '@/components/ui/cccd-upload';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { toast } from 'sonner';
import styles from './page.module.css';

export default function KhachThuePage() {
  const accessToken = useSession()?.data?.accessToken;
  const { clearCache, isRefreshing, setIsRefreshing } = useCache<{ khachThueList: KhachThue[] }>({ key: 'khach-thue-data', duration: 300000 });
  const [khachThueList, setKhachThueList] = useState<KhachThue[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [appliedSearch, setAppliedSearch] = useState('');
  const [selectedTrangThai, setSelectedTrangThai] = useState('');
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [editingKhachThue, setEditingKhachThue] = useState<KhachThue | null>(null);
  const [isFormSubmitting, setIsFormSubmitting] = useState(false);
  const [actionLoading, setActionLoading] = useState<string | null>(null);

  // Pagination state
  const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 10 });
  const [totalElements, setTotalElements] = useState(0);
  const [totalPages, setTotalPages] = useState(0);

  useEffect(() => {
    document.title = 'Quản lý Khách thuê';
  }, []);

  const fetchKhachThue = useCallback(async (trangThai = '', search = '', page = 1, limit = 10) => {
    try {
      setLoading(true);
      
      const params = new URLSearchParams({
        page: page.toString(),
        limit: limit.toString()
      });
      if (trangThai && trangThai !== 'all') params.append('trangThai', trangThai);
      if (search) params.append('search', search);
      
      const response = await fetch(`/api/khach-thue?${params.toString()}`, {
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      });
      let khachThueData: KhachThue[] = [];
      if (response.ok) {
        const result = await response.json();
        if (result.success) {
          khachThueData = Array.isArray(result.data) ? result.data : (result.data?.data || []);
          setKhachThueList(khachThueData);
          if (result.data && !Array.isArray(result.data)) {
            setTotalElements(result.data.total || 0);
            setTotalPages(result.data.totalPages || 0);
          } else {
            setTotalElements(khachThueData.length);
            setTotalPages(1);
          }
        }
      }
    } catch (error) {
      console.error('Error fetching khach thue:', error);
    } finally {
      setLoading(false);
    }
  }, [accessToken]);

  useEffect(() => {
    fetchKhachThue(selectedTrangThai, appliedSearch, pagination.pageIndex + 1, pagination.pageSize);
  }, [fetchKhachThue, selectedTrangThai, appliedSearch, pagination.pageIndex, pagination.pageSize]);

  const handleRefresh = async () => {
    setIsRefreshing(true);
    await fetchKhachThue(selectedTrangThai, appliedSearch, pagination.pageIndex + 1, pagination.pageSize);
    setIsRefreshing(false);
    toast.success('Đã tải dữ liệu mới nhất');
  };

  useEffect(() => {
    // Reset pagination when filter changes
    setPagination(prev => ({ ...prev, pageIndex: 0 }));
  }, [selectedTrangThai, appliedSearch]);

  useEffect(() => {
    const timeoutId = window.setTimeout(() => setAppliedSearch(searchTerm.trim()), 350);
    return () => window.clearTimeout(timeoutId);
  }, [searchTerm]);

  const filteredKhachThue = khachThueList;
  const totalKhachThue = totalElements;
  const dangThueCount = khachThueList.filter(k => k.trangThai === 'dangThue' || k.trangThai === 'ACTIVE').length;
  const daTraPhongCount = khachThueList.filter(k => k.trangThai === 'daTraPhong').length;
  const chuaThueCount = khachThueList.filter(k => k.trangThai === 'chuaThue').length;
  const heroStats = [
    {
      title: 'Tổng khách thuê',
      value: totalKhachThue,
      description: 'Toàn bộ hồ sơ khách thuê',
      tone: 'navy',
    },
    {
      title: 'Đang thuê',
      value: dangThueCount,
      description: 'Đang ở và còn hiệu lực',
      tone: 'teal',
    },
    {
      title: 'Đã trả phòng',
      value: daTraPhongCount,
      description: 'Đã kết thúc hợp đồng',
      tone: 'blue',
    },
    {
      title: 'Chưa thuê',
      value: chuaThueCount,
      description: 'Hồ sơ chưa phát sinh',
      tone: 'orange',
    },
  ];
  const statToneClass: Record<string, string> = {
    teal: styles.statCardTeal,
    blue: styles.statCardBlue,
    orange: styles.statCardOrange,
    navy: '',
  };

  const handleEdit = (khachThue: KhachThue) => {
    setEditingKhachThue(khachThue);
    setIsDialogOpen(true);
  };

  const handleDelete = async (id: string) => {
    if (confirm('Bạn có chắc chắn muốn xóa khách thuê này?')) {
      setActionLoading(`delete-${id}`);
      try {
        const response = await fetch(`/api/khach-thue/${id}`, {
          method: 'DELETE',
          headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
        });
        
        if (response.ok) {
          const result = await response.json();
          if (result.success) {
            clearCache();
            await fetchKhachThue(selectedTrangThai, appliedSearch, pagination.pageIndex + 1, pagination.pageSize);
            toast.success('Xóa khách thuê thành công!');
          } else {
            toast.error(result.message || 'Có lỗi xảy ra');
          }
        } else {
          const error = await response.json();
          toast.error(error.message || 'Có lỗi xảy ra');
        }
      } catch (error) {
        console.error('Error deleting khach thue:', error);
        toast.error('Có lỗi xảy ra khi xóa khách thuê');
      } finally {
        setActionLoading(null);
      }
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
      {/* Hero Section */}
      <section className={`khach-thue-hero ${styles.hero}`}>
        <div className={styles.content}>
          <div className={styles.eyebrow}>
            <Users className="h-4 w-4" aria-hidden="true" />
            QUẢN LÝ KHÁCH THUÊ
          </div>

          <div className={styles.titleRow}>
            <h1>Quản lý khách thuê</h1>
            <span className={styles.statusBadge}>Hồ sơ ổn định</span>
          </div>

          <p>
            Quản lý hồ sơ khách thuê, trạng thái cư trú, hợp đồng và công nợ trong một nơi.
          </p>

          {totalKhachThue > 0 && (
            <div className={styles.insight}>
              Hiện có <strong>{dangThueCount} khách đang thuê</strong> trong <strong>{totalKhachThue} hồ sơ</strong>, hệ thống đang vận hành ổn định.
            </div>
          )}

          <div className={styles.stats}>
            {heroStats.map((stat) => (
              <div
                key={stat.title}
                className={`${styles.statCard} ${statToneClass[stat.tone]}`}
              >
                <div className={styles.statTop}>
                  <span>{stat.title}</span>
                  <Users className="h-5 w-5" aria-hidden="true" />
                </div>
                <strong>{stat.value}</strong>
                <p>{stat.description}</p>
              </div>
            ))}
          </div>
        </div>

        <div className={`khach-thue-hero__actions ${styles.actions}`}>
          <HeroActionButton
            variant="secondary"
            onClick={handleRefresh}
            disabled={isRefreshing}
            className={`khach-thue-hero__button ${styles.button} ${styles.buttonSecondary}`}
          >
            <RefreshCw className={`h-4 w-4 sm:mr-2 ${isRefreshing ? 'animate-spin' : ''}`} />
            <span className="hidden sm:inline">{isRefreshing ? 'Đang tải...' : 'Tải mới'}</span>
          </HeroActionButton>
          
          <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
            <DialogTrigger asChild>
              <HeroActionButton
                variant="default"
                onClick={() => setEditingKhachThue(null)}
                className={`khach-thue-hero__button ${styles.button} ${styles.buttonPrimary}`}
              >
                <Plus className="h-4 w-4 sm:mr-2" />
                <span className="hidden sm:inline">Thêm khách thuê</span>
                <span className="sm:hidden">Thêm</span>
              </HeroActionButton>
            </DialogTrigger>
            <DialogContent className="w-[95vw] md:w-full max-w-4xl max-h-[90vh] overflow-y-auto">
              <DialogHeader>
                <DialogTitle>
                  {editingKhachThue ? 'Chỉnh sửa khách thuê' : 'Thêm khách thuê mới'}
                </DialogTitle>
                <DialogDescription>
                  {editingKhachThue ? 'Cập nhật thông tin khách thuê' : 'Nhập thông tin khách thuê mới'}
                </DialogDescription>
              </DialogHeader>
              
              <KhachThueForm 
                khachThue={editingKhachThue}
                onClose={() => setIsDialogOpen(false)}
                onSuccess={(newKhachThue) => {
                    clearCache();
                  setIsDialogOpen(false);
                  if (newKhachThue) {
                    // Fallback: refresh data nếu không có dữ liệu trả về hoặc có
                    fetchKhachThue(selectedTrangThai, appliedSearch, pagination.pageIndex + 1, pagination.pageSize);
                  } else {
                    // Fallback: refresh data nếu không có dữ liệu trả về
                    fetchKhachThue(selectedTrangThai, appliedSearch, pagination.pageIndex + 1, pagination.pageSize);
                  }
                  toast.success(editingKhachThue ? 'Cập nhật khách thuê thành công!' : 'Thêm khách thuê thành công!');
                }}
                isSubmitting={isFormSubmitting}
                setIsSubmitting={setIsFormSubmitting}
              />
            </DialogContent>
          </Dialog>
        </div>
      </section>

      {/* Desktop Table */}
      <DashboardCard className="hidden md:block overflow-hidden">
        <CardHeader className="border-b bg-[#F2E8DC]/70 pb-4">
          <CardTitle className="text-lg text-[#243B5A]">Danh sách khách thuê</CardTitle>
          <CardDescription>
            {filteredKhachThue.length} khách thuê được tìm thấy
          </CardDescription>
        </CardHeader>
        <CardContent className="p-6">
          <KhachThueDataTable
            data={filteredKhachThue}
            onEdit={handleEdit}
            onDelete={handleDelete}
            actionLoading={actionLoading}
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

      {/* Mobile Cards */}
      <div className="md:hidden">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-lg font-semibold">Danh sách khách thuê</h2>
          <span className="text-sm text-gray-500">{filteredKhachThue.length} khách thuê</span>
        </div>
        
        {/* Mobile Filters */}
        <div className="space-y-2 mb-4">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
            <Input
              placeholder="Tìm kiếm khách thuê..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="pl-10 text-sm"
            />
          </div>
          <Select value={selectedTrangThai} onValueChange={setSelectedTrangThai}>
            <SelectTrigger className="text-sm">
              <SelectValue placeholder="Trạng thái" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all" className="text-sm">Tất cả</SelectItem>
              <SelectItem value="dangThue" className="text-sm">Đang thuê</SelectItem>
              <SelectItem value="daTraPhong" className="text-sm">Đã trả phòng</SelectItem>
              <SelectItem value="chuaThue" className="text-sm">Chưa thuê</SelectItem>
            </SelectContent>
          </Select>
        </div>

        {/* Mobile Card List */}
        <div className="space-y-3">
          {filteredKhachThue.map((khachThue) => (
            <Card key={khachThue._id} className="p-4">
              <div className="space-y-3">
                {/* Header with name and status */}
                <div className="flex justify-between items-start">
                  <div>
                    <h3 className="font-medium text-gray-900">{khachThue.hoTen}</h3>
                    <p className="text-sm text-gray-500 capitalize">{khachThue.gioiTinh}</p>
                  </div>
                  <div className="flex gap-2">
                    {(() => {
                      switch (khachThue.trangThai) {
                        case 'dangThue':
                          return <Badge variant="default" className="text-xs">Đang thuê</Badge>;
                        case 'daTraPhong':
                          return <Badge variant="secondary" className="text-xs">Đã trả phòng</Badge>;
                        case 'chuaThue':
                          return <Badge variant="outline" className="text-xs">Chưa thuê</Badge>;
                        default:
                          return <Badge variant="outline" className="text-xs">{khachThue.trangThai}</Badge>;
                      }
                    })()}
                  </div>
                </div>

                {/* Contact info */}
                <div className="space-y-1">
                  <div className="flex items-center gap-2 text-sm">
                    <Phone className="h-3 w-3 text-gray-400" />
                    <span>{khachThue.soDienThoai}</span>
                  </div>
                  {khachThue.email && (
                    <div className="flex items-center gap-2 text-sm text-gray-500">
                      <Mail className="h-3 w-3" />
                      <span className="truncate">{khachThue.email}</span>
                    </div>
                  )}
                  <div className="flex items-center gap-2 text-sm text-gray-500">
                    <CreditCard className="h-3 w-3" />
                    <span className="font-mono">{khachThue.cccd}</span>
                  </div>
                </div>

                {/* Additional info */}
                <div className="space-y-1 text-xs text-gray-500">
                  <div className="flex items-center gap-2">
                    <Calendar className="h-3 w-3" />
                    <span>Ngày sinh: {khachThue.ngaySinh ? new Date(khachThue.ngaySinh).toLocaleDateString('vi-VN') : 'N/A'}</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <MapPin className="h-3 w-3" />
                    <span className="truncate">{khachThue.queQuan}</span>
                  </div>
                  {khachThue.ngheNghiep && (
                    <div className="flex items-center gap-2">
                      <Users className="h-3 w-3" />
                      <span>{khachThue.ngheNghiep}</span>
                    </div>
                  )}
                </div>

                {/* Room info if available */}
                {khachThue.hopDongHienTai?.phong && (
                  <div className="border-t pt-2">
                    <div className="flex items-center gap-2 text-sm">
                      <Users className="h-3 w-3 text-green-600" />
                      <span className="font-medium">Phòng: {khachThue.hopDongHienTai.phong.maPhong}</span>
                    </div>
                    {khachThue.hopDongHienTai.phong.toaNha && (
                      <div className="flex items-center gap-2 text-xs text-gray-500 ml-5">
                        <span>{khachThue.hopDongHienTai.phong.toaNha.tenToaNha}</span>
                      </div>
                    )}
                  </div>
                )}

                {/* Action buttons */}
                <div className="flex justify-between items-center pt-2 border-t">
                  <div className="flex gap-2">
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => {
                        const publicUrl = `${window.location.origin}/khach-thue/dang-nhap`;
                        navigator.clipboard.writeText(publicUrl);
                        toast.success('Đã sao chép link đăng nhập khách thuê');
                      }}
                      className="text-green-600 hover:text-green-700 hover:bg-green-50"
                      title="Sao chép liên kết đăng nhập khách thuê"
                    >
                      <Copy className="h-3.5 w-3.5" />
                    </Button>
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => handleEdit(khachThue)}
                      disabled={actionLoading === `edit-${khachThue._id}`}
                    >
                      <Edit className="h-3.5 w-3.5" />
                    </Button>
                  </div>
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => handleDelete(khachThue._id!)}
                    disabled={actionLoading === `delete-${khachThue._id}`}
                    className="text-red-600 hover:text-red-700 hover:bg-red-50"
                  >
                    <Trash2 className="h-3.5 w-3.5" />
                  </Button>
                </div>
              </div>
            </Card>
          ))}
        </div>

        {filteredKhachThue.length === 0 && (
          <div className="text-center py-8">
            <Users className="h-12 w-12 text-gray-300 mx-auto mb-4" />
            <p className="text-gray-500">Không có khách thuê nào</p>
          </div>
        )}
      </div>
    </div>
  );
}

// Form component for adding/editing khach thue
function KhachThueForm({
  khachThue, 
  onClose, 
  onSuccess,
  isSubmitting,
  setIsSubmitting
}: { 
  khachThue: KhachThue | null;
  onClose: () => void;
  onSuccess: (newKhachThue?: KhachThue) => void;
  isSubmitting: boolean;
  setIsSubmitting: (value: boolean) => void;
}) {
  const accessToken = useSession()?.data?.accessToken;
  const [formData, setFormData] = useState({
    hoTen: khachThue?.hoTen || '',
    soDienThoai: khachThue?.soDienThoai || '',
    email: khachThue?.email || '',
    cccd: khachThue?.cccd || '',
    ngaySinh: khachThue?.ngaySinh ? new Date(khachThue.ngaySinh).toISOString().split('T')[0] : '',
    gioiTinh: khachThue?.gioiTinh || 'nam',
    queQuan: khachThue?.queQuan || '',
    anhCCCD: {
      matTruoc: khachThue?.anhCCCD?.matTruoc || '',
      matSau: khachThue?.anhCCCD?.matSau || '',
    },
    ngheNghiep: khachThue?.ngheNghiep || '',
    matKhau: '',
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (isSubmitting) return; // Ngăn submit nhiều lần
    
    setIsSubmitting(true);
    
    try {
      const url = khachThue ? `/api/khach-thue/${khachThue._id}` : '/api/khach-thue';
      const method = khachThue ? 'PUT' : 'POST';

      // Chỉ gửi matKhau khi nó được nhập
      const submitData = formData.matKhau.trim()
        ? { ...formData }
        : {
            ...formData,
            matKhau: undefined,
          };

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
          onSuccess(result.data);
        } else {
          toast.error(result.message || 'Có lỗi xảy ra');
        }
      } else {
        const error = await response.json();
        toast.error(error.message || 'Có lỗi xảy ra');
      }
    } catch (error) {
      console.error('Error submitting form:', error);
      toast.error('Có lỗi xảy ra khi gửi form');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4 md:space-y-6">
      <Tabs defaultValue="thong-tin" className="w-full">
        <TabsList className="grid w-full grid-cols-2">
          <TabsTrigger value="thong-tin" className="flex items-center gap-1 md:gap-2 text-xs md:text-sm">
            <Info className="h-3 w-3 md:h-4 md:w-4" />
            <span className="hidden sm:inline">Thông tin</span>
            <span className="sm:hidden">Thông tin</span>
          </TabsTrigger>
          <TabsTrigger value="anh-cccd" className="flex items-center gap-1 md:gap-2 text-xs md:text-sm">
            <CreditCard className="h-3 w-3 md:h-4 md:w-4" />
            <span className="hidden sm:inline">Ảnh CCCD</span>
            <span className="sm:hidden">CCCD</span>
          </TabsTrigger>
        </TabsList>
        
        <TabsContent value="thong-tin" className="space-y-4 md:space-y-6 mt-4 md:mt-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-3 md:gap-4">
            <div className="space-y-2">
              <Label htmlFor="hoTen" className="text-xs md:text-sm">Họ tên</Label>
              <Input
                id="hoTen"
                value={formData.hoTen}
                onChange={(e) => setFormData(prev => ({ ...prev, hoTen: e.target.value }))}
                required
                className="text-sm"
              />
            </div>
            
            <div className="space-y-2">
              <Label htmlFor="soDienThoai" className="text-xs md:text-sm">Số điện thoại</Label>
              <Input
                id="soDienThoai"
                value={formData.soDienThoai}
                onChange={(e) => setFormData(prev => ({ ...prev, soDienThoai: e.target.value }))}
                required
                className="text-sm"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-3 md:gap-4">
            <div className="space-y-2">
              <Label htmlFor="email" className="text-xs md:text-sm">Email</Label>
              <Input
                id="email"
                type="email"
                value={formData.email}
                onChange={(e) => setFormData(prev => ({ ...prev, email: e.target.value }))}
                className="text-sm"
              />
            </div>
            
            <div className="space-y-2">
              <Label htmlFor="cccd" className="text-xs md:text-sm">CCCD</Label>
              <Input
                id="cccd"
                value={formData.cccd}
                onChange={(e) => setFormData(prev => ({ ...prev, cccd: e.target.value }))}
                required
                className="text-sm"
              />
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-3 md:gap-4">
            <div className="space-y-2">
              <Label htmlFor="ngaySinh" className="text-xs md:text-sm">Ngày sinh</Label>
              <Input
                id="ngaySinh"
                type="date"
                value={formData.ngaySinh}
                onChange={(e) => setFormData(prev => ({ ...prev, ngaySinh: e.target.value }))}
                required
                className="text-sm"
              />
            </div>
            
            <div className="space-y-2">
              <Label htmlFor="gioiTinh" className="text-xs md:text-sm">Giới tính</Label>
              <Select value={formData.gioiTinh} onValueChange={(value) => setFormData(prev => ({ ...prev, gioiTinh: value as 'nam' | 'nu' }))}>
                <SelectTrigger className="text-sm">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="nam" className="text-sm">Nam</SelectItem>
                  <SelectItem value="nu" className="text-sm">Nữ</SelectItem>
                  <SelectItem value="khac" className="text-sm">Khác</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="space-y-2">
            <Label htmlFor="queQuan" className="text-xs md:text-sm">Quê quán</Label>
            <Input
              id="queQuan"
              value={formData.queQuan}
              onChange={(e) => setFormData(prev => ({ ...prev, queQuan: e.target.value }))}
              required
              className="text-sm"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="ngheNghiep" className="text-xs md:text-sm">Nghề nghiệp</Label>
            <Input
              id="ngheNghiep"
              value={formData.ngheNghiep}
              onChange={(e) => setFormData(prev => ({ ...prev, ngheNghiep: e.target.value }))}
              className="text-sm"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="matKhau" className="text-xs md:text-sm">Mật khẩu đăng nhập</Label>
            <Input
              id="matKhau"
              type="password"
              value={formData.matKhau}
              onChange={(e) => setFormData(prev => ({ ...prev, matKhau: e.target.value }))}
              placeholder={khachThue && khachThue.matKhau ? "Để trống nếu không muốn thay đổi" : "Nhập mật khẩu (tối thiểu 6 ký tự)"}
              className="text-sm"
            />
            <p className="text-[10px] md:text-xs text-muted-foreground">
              {khachThue && khachThue.matKhau 
                ? "Khách thuê đã có tài khoản đăng nhập. Để trống nếu không muốn thay đổi mật khẩu."
                : "Tạo mật khẩu để khách thuê có thể đăng nhập vào hệ thống."
              }
            </p>
          </div>
        </TabsContent>
        
        <TabsContent value="anh-cccd" className="space-y-4 md:space-y-6 mt-4 md:mt-6">
          <CCCDUpload
            anhCCCD={formData.anhCCCD}
            onCCCDChange={(anhCCCD) => setFormData(prev => ({ ...prev, anhCCCD }))}
            className="w-full"
          />
        </TabsContent>
      </Tabs>

      <DialogFooter className="flex-col sm:flex-row gap-2">
        <Button type="button" variant="outline" onClick={onClose} disabled={isSubmitting} className="w-full sm:w-auto">
          Hủy
        </Button>
        <Button type="submit" disabled={isSubmitting} className="w-full sm:w-auto">
          {isSubmitting ? (
            <>
              <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></div>
              <span className="hidden sm:inline">{khachThue ? 'Đang cập nhật...' : 'Đang thêm...'}</span>
              <span className="sm:hidden">{khachThue ? 'Đang cập nhật...' : 'Đang thêm...'}</span>
            </>
          ) : (
            <>
              <span className="hidden sm:inline">{khachThue ? 'Cập nhật' : 'Thêm mới'}</span>
              <span className="sm:hidden">{khachThue ? 'Cập nhật' : 'Thêm mới'}</span>
            </>
          )}
        </Button>
      </DialogFooter>
    </form>
  );
}
