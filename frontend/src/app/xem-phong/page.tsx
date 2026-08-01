'use client';

import { useState, useEffect, useCallback } from 'react';
import Image from 'next/image';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { 
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { 
  Search, 
  Home, 
  MapPin, 
  Users, 
  Square, 
  Eye,
  ArrowLeft,
  LocateFixed,
  ExternalLink,
} from 'lucide-react';
import { Phong, ToaNha } from '@/types';
import { toast } from 'sonner';
import Link from 'next/link';
import { ImageCarousel } from '@/components/ui/image-carousel';

type ToaNhaRef = string | { tenToaNha?: string };
type UserLocation = { viDo: number; kinhDo: number };

const getToaNhaTen = (toaNha: ToaNhaRef) => {
  if (typeof toaNha === 'object' && toaNha?.tenToaNha) {
    return toaNha.tenToaNha;
  }
  return 'N/A';
};

export default function XemPhongPage() {
  const [phongList, setPhongList] = useState<Phong[]>([]);
  const [toaNhaList, setToaNhaList] = useState<ToaNha[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedToaNha, setSelectedToaNha] = useState('');
  const [minGia, setMinGia] = useState('');
  const [maxGia, setMaxGia] = useState('');
  const [minDienTich, setMinDienTich] = useState('');
  const [page, setPage] = useState(1);
  const [totalElements, setTotalElements] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const [userLocation, setUserLocation] = useState<UserLocation | null>(null);
  const [radiusKm, setRadiusKm] = useState('5');
  const fetchPhong = useCallback(async (
    toaNhaFilter = '',
    searchFilter = '',
    minGiaFilter = '',
    maxGiaFilter = '',
    minDienTichFilter = '',
    requestedPage = 1,
    location: UserLocation | null = null,
    radiusFilter = '5',
  ) => {
    try {
      setLoading(true);
      setError('');
      const params = new URLSearchParams({ limit: '12' });
      if (location) {
        params.append('viDo', location.viDo.toString());
        params.append('kinhDo', location.kinhDo.toString());
        params.append('radiusKm', radiusFilter);
      } else {
        params.append('page', requestedPage.toString());
      }
      if (toaNhaFilter && toaNhaFilter !== 'all') params.append('toaNha', toaNhaFilter);
      if (searchFilter) params.append('search', searchFilter);
      if (minGiaFilter) params.append('minGia', minGiaFilter);
      if (maxGiaFilter) params.append('maxGia', maxGiaFilter);
      if (minDienTichFilter) params.append('minDienTich', minDienTichFilter);
      
      const endpoint = location ? '/api/public/phong/gan-nhat' : '/api/public/phong';
      const response = await fetch(`${endpoint}?${params.toString()}`);
      const result = await response.json();
      if (!response.ok || !result.success) {
        throw new Error(result.message || 'Không tải được danh sách phòng');
      }
      setPhongList(result.data.data || []);
      setTotalElements(result.data.total || 0);
      setTotalPages(result.data.totalPages || 0);
    } catch (error) {
      console.error('Error fetching phong:', error);
      const message = error instanceof Error ? error.message : 'Có lỗi xảy ra khi tải danh sách phòng';
      setError(message);
      toast.error(message);
    } finally {
      setLoading(false);
    }
  }, []);

  const findNearbyRooms = () => {
    if (!navigator.geolocation) {
      const message = 'Trình duyệt không hỗ trợ xác định vị trí.';
      setError(message);
      toast.error(message);
      return;
    }
    navigator.geolocation.getCurrentPosition(
      (position) => {
        setPage(1);
        setUserLocation({ viDo: position.coords.latitude, kinhDo: position.coords.longitude });
        toast.success('Đã dùng vị trí của bạn để tìm phòng gần nhất.');
      },
      () => {
        const message = 'Cần cho phép truy cập vị trí để tìm phòng gần bạn.';
        setError(message);
        toast.error(message);
      },
      { enableHighAccuracy: true, timeout: 10000, maximumAge: 300000 },
    );
  };

  const fetchToaNha = useCallback(async () => {
    try {
      const response = await fetch('/api/public/toa-nha');
      if (response.ok) {
        const result = await response.json();
        if (result.success) {
          setToaNhaList(result.data);
        }
      }
    } catch (error) {
      console.error('Error fetching toa nha:', error);
    }
  }, []);

  useEffect(() => {
    fetchToaNha();
    
    // Check for phong parameter in URL
    const urlParams = new URLSearchParams(window.location.search);
    const phongParam = urlParams.get('phong');
    if (phongParam) {
      setSearchTerm(phongParam);
    }
  }, [fetchToaNha]);

  useEffect(() => {
    setPage(1);
  }, [selectedToaNha, searchTerm, minGia, maxGia, minDienTich, radiusKm]);

  useEffect(() => {
    const timer = setTimeout(() => {
      fetchPhong(selectedToaNha, searchTerm.trim(), minGia, maxGia, minDienTich, page, userLocation, radiusKm);
    }, 350);
    return () => clearTimeout(timer);
  }, [selectedToaNha, searchTerm, minGia, maxGia, minDienTich, page, userLocation, radiusKm, fetchPhong]);

  // Auto-open phong details when phong parameter is in URL
  useEffect(() => {
    const urlParams = new URLSearchParams(window.location.search);
    const phongParam = urlParams.get('phong');
    if (phongParam && phongList.length > 0) {
      const targetPhong = phongList.find(p => (p.maPhong || p.ten || '').toLowerCase() === phongParam.toLowerCase());
      if (targetPhong) {
        window.location.href = `/phong/${targetPhong._id || targetPhong.id}`;
      }
    }
  }, [phongList]);

  const filteredPhong = phongList;

  const getTrangThaiBadge = (trangThai: string) => {
    const variants = {
      trong: { variant: 'secondary' as const, label: 'Trống', color: 'text-green-600' },
      daDat: { variant: 'outline' as const, label: 'Đã đặt', color: 'text-[#243B5A]' },
      dangThue: { variant: 'default' as const, label: 'Đang thuê', color: 'text-orange-600' },
      baoTri: { variant: 'destructive' as const, label: 'Bảo trì', color: 'text-red-600' },
    };
    
    const config = variants[trangThai as keyof typeof variants] || variants.trong;
    return <Badge variant={config.variant} className={config.color}>{config.label}</Badge>;
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND'
    }).format(amount);
  };

  const tienNghiLabels = {
    dieuhoa: 'Điều hòa',
    nonglanh: 'Nóng lạnh',
    tulanh: 'Tủ lạnh',
    giuong: 'Giường',
    tuquanao: 'Tủ quần áo',
    banlamviec: 'Bàn làm việc',
    ghe: 'Ghế',
    tivi: 'TV',
    wifi: 'WiFi',
    maygiat: 'Máy giặt',
    bep: 'Bếp',
    noi: 'Nồi',
    chen: 'Chén',
    bat: 'Bát',
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-[#F8F3EC] relative">
        {/* Polka dot background */}
        <div className="absolute inset-0 opacity-20">
          <div className="absolute inset-0" style={{
            backgroundImage: 'radial-gradient(circle, rgba(79, 167, 160, 0.35) 1px, transparent 1px)',
            backgroundSize: '20px 20px'
          }}></div>
        </div>
        
        <div className="relative container mx-auto px-4 py-8">
          <div className="space-y-6">
            <div className="h-8 bg-gradient-to-r from-[#E6F3F1] to-[#F8E0C4] rounded-xl w-48 animate-pulse"></div>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {[...Array(6)].map((_, i) => (
                <div key={i} className="h-96 rounded-[22px] border border-[#E8DED1] bg-[#FFFCF8] shadow-[0_12px_30px_rgba(36,59,90,0.08)] animate-pulse"></div>
              ))}
            </div>
          </div>
        </div>
      </div>
    );
  }



  return (
    <div className="min-h-screen bg-[#F8F3EC] relative">
      {/* Polka dot background */}
      <div className="absolute inset-0 opacity-10">
        <div className="absolute inset-0" style={{
          backgroundImage: 'radial-gradient(circle, rgba(79, 167, 160, 0.26) 2px, transparent 2px)',
          backgroundSize: '30px 30px'
        }}></div>
      </div>
      
      <div className="relative container mx-auto px-4 py-4 md:py-8">
        {/* Header */}
        <div className="mb-4 md:mb-8">
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4">
            <div>
              <h1 className="text-xl md:text-2xl lg:text-3xl font-black text-[#243B5A]">
                Danh sách phòng cho thuê
              </h1>
              <p className="text-xs md:text-sm text-[#6B7A8C]">Tìm phòng phù hợp với nhu cầu của bạn</p>
            </div>
            <Link href="/" className="w-full sm:w-auto">
              <Button variant="outline" size="sm" className="w-full sm:w-auto">
                <ArrowLeft className="h-4 w-4 mr-2" />
                Về trang chủ
              </Button>
            </Link>
          </div>

          {/* Search and Filters */}
          <div className="relative">
            {/* Background decoration */}
            <div className="absolute inset-0 bg-gradient-to-r from-[#4FA7A0]/10 via-white/30 to-[#F2A45B]/10 rounded-3xl blur-xl"></div>
            
            <Card className="relative overflow-hidden rounded-[24px] border border-[#243B5A]/[0.08] bg-[#FFFCF8]/95 shadow-[0_18px_40px_rgba(36,59,90,0.10)] backdrop-blur-md">
              {/* Gradient border effect */}
              <div className="absolute inset-0 rounded-3xl bg-gradient-to-r from-[#4FA7A0]/20 via-white/20 to-[#F2A45B]/20 p-[1px]">
                <div className="w-full h-full bg-white/95 backdrop-blur-md rounded-3xl"></div>
              </div>
              
              <div className="relative p-6 md:p-8">
                {/* Header with icon */}
                <div className="flex items-center gap-3 mb-6">
                  <div className="w-10 h-10 bg-[#243B5A] rounded-xl flex items-center justify-center shadow-lg">
                    <Search className="h-5 w-5 text-white" />
                  </div>
                  <div>
                    <h2 className="text-lg md:text-xl font-black text-[#243B5A]">
                      Tìm kiếm phòng
                    </h2>
                    <p className="text-xs md:text-sm text-[#6B7A8C]">Tìm phòng phù hợp với nhu cầu của bạn</p>
                  </div>
                </div>

                {/* Search and filter grid */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4 md:gap-6">
                  {/* Search input */}
                  <div className="md:col-span-1">
                    <label className="block text-sm font-medium text-[#243B5A] mb-2">Tìm kiếm</label>
                    <div className="relative group">
                      <div className="absolute inset-0 bg-gradient-to-r from-[#4FA7A0]/20 to-[#F2A45B]/20 rounded-xl blur opacity-0 group-focus-within:opacity-100 transition-opacity duration-300"></div>
                      <div className="relative">
                        <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 h-4 w-4 text-[#6B7A8C] group-focus-within:text-[#4FA7A0] transition-colors duration-300" />
                        <Input
                          placeholder="Nhập mã phòng, mô tả..."
                          value={searchTerm}
                          onChange={(e) => setSearchTerm(e.target.value)}
                          className="pl-12 pr-4 py-3 h-12 text-sm border-0 bg-[#F8F3EC]/70 focus:bg-white focus:ring-2 focus:ring-[#4FA7A0]/20 focus:border-[#4FA7A0]/20 rounded-xl transition-all duration-300 shadow-sm hover:shadow-md focus:shadow-lg"
                        />
                      </div>
                    </div>
                  </div>

                  {/* Building filter */}
                  <div className="md:col-span-1">
                    <label className="block text-sm font-medium text-[#243B5A] mb-2">Tòa nhà</label>
                    <div className="relative group">
                      <div className="absolute inset-0 bg-gradient-to-r from-[#4FA7A0]/20 to-[#243B5A]/10 rounded-xl blur opacity-0 group-focus-within:opacity-100 transition-opacity duration-300"></div>
                      <div className="relative">
                        <Select value={selectedToaNha} onValueChange={setSelectedToaNha}>
                          <SelectTrigger className="h-12 text-sm border-0 bg-[#F8F3EC]/70 focus:bg-white focus:ring-2 focus:ring-[#4FA7A0]/25 focus:border-[#4FA7A0]/30 rounded-xl transition-all duration-300 shadow-sm hover:shadow-md focus:shadow-lg">
                            <SelectValue placeholder="Chọn tòa nhà" />
                          </SelectTrigger>
                          <SelectContent className="border-0 shadow-xl rounded-xl bg-white/95 backdrop-blur-md">
                            <SelectItem value="all" className="text-sm hover:bg-[#F8F3EC]">Tất cả tòa nhà</SelectItem>
                            {toaNhaList.map((toaNha) => (
                              <SelectItem key={toaNha._id} value={toaNha._id!} className="text-sm hover:bg-[#F8F3EC]">
                                {toaNha.tenToaNha}
                              </SelectItem>
                            ))}
                          </SelectContent>
                        </Select>
                      </div>
                    </div>
                  </div>

                  {/* Minimum price */}
                  <div className="md:col-span-1">
                    <label className="block text-sm font-medium text-[#243B5A] mb-2">Giá từ</label>
                    <Input type="number" min="0" placeholder="2.000.000" value={minGia} onChange={(e) => setMinGia(e.target.value)} className="h-12 rounded-xl bg-[#F8F3EC]/70" />
                  </div>

                  {/* Maximum price */}
                  <div className="md:col-span-1">
                    <label className="block text-sm font-medium text-[#243B5A] mb-2">Giá đến</label>
                    <Input type="number" min="0" placeholder="5.000.000" value={maxGia} onChange={(e) => setMaxGia(e.target.value)} className="h-12 rounded-xl bg-[#F8F3EC]/70" />
                  </div>

                  {/* Minimum area */}
                  <div className="md:col-span-1">
                    <label className="block text-sm font-medium text-[#243B5A] mb-2">Diện tích từ (m2)</label>
                    <Input type="number" min="0" placeholder="20" value={minDienTich} onChange={(e) => setMinDienTich(e.target.value)} className="h-12 rounded-xl bg-[#F8F3EC]/70" />
                  </div>
                </div>

                <div className="mt-5 flex flex-col gap-3 rounded-2xl border border-[#4FA7A0]/20 bg-[#E6F3F1]/60 p-4 sm:flex-row sm:items-end sm:justify-between">
                  <div>
                    <p className="text-sm font-semibold text-[#243B5A]">Gợi ý phòng gần nhất</p>
                    <p className="text-xs text-[#6B7A8C]">Cho phép vị trí để sắp xếp phòng trống theo khoảng cách thực tế.</p>
                  </div>
                  <div className="flex flex-col gap-2 sm:flex-row sm:items-center">
                    <Select value={radiusKm} onValueChange={setRadiusKm}>
                      <SelectTrigger className="h-10 w-full bg-white sm:w-[130px]">
                        <SelectValue placeholder="Bán kính" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="2">Trong 2 km</SelectItem>
                        <SelectItem value="5">Trong 5 km</SelectItem>
                        <SelectItem value="10">Trong 10 km</SelectItem>
                      </SelectContent>
                    </Select>
                    <Button type="button" onClick={findNearbyRooms} className="bg-[#267D76] hover:bg-[#1f665f]">
                      <LocateFixed className="mr-2 h-4 w-4" />
                      {userLocation ? 'Cập nhật vị trí' : 'Tìm gần tôi'}
                    </Button>
                  </div>
                </div>

                {/* Results summary */}
                <div className="mt-6 pt-6 border-t border-[#E8DED2]/50">
                  <div className="flex items-center justify-between">
                    <p className="text-sm text-[#6B7A8C]">
                      Hiển thị <span className="font-semibold text-[#243B5A]">{filteredPhong.length}</span> trong <span className="font-semibold text-[#243B5A]">{totalElements}</span> phòng trống phù hợp
                    </p>
                    {(searchTerm || selectedToaNha || minGia || maxGia || minDienTich || userLocation) && (
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => {
                          setSearchTerm('');
                          setSelectedToaNha('');
                          setMinGia('');
                          setMaxGia('');
                          setMinDienTich('');
                          setUserLocation(null);
                        }}
                        className="text-xs text-[#6B7A8C] hover:text-[#243B5A] hover:bg-slate-100"
                      >
                        Xóa bộ lọc
                      </Button>
                    )}
                  </div>
                </div>
              </div>
            </Card>
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 md:gap-4 mb-4 md:mb-8">
          <Card className="p-4 border border-[#E8DED2] bg-white shadow-sm">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs font-medium text-[#6B7A8C]">Phòng trống phù hợp</p>
                <p className="text-2xl font-bold text-[#243B5A]">{totalElements}</p>
              </div>
              <Home className="h-5 w-5 text-[#267D76]" />
            </div>
          </Card>
          <Card className="p-4 border border-[#E8DED2] bg-white shadow-sm">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs font-medium text-[#6B7A8C]">Tòa nhà đang hiển thị</p>
                <p className="text-2xl font-bold text-[#243B5A]">{selectedToaNha && selectedToaNha !== 'all' ? '1' : toaNhaList.length}</p>
              </div>
              <MapPin className="h-5 w-5 text-[#6B7A8C]" />
            </div>
          </Card>
        </div>

        {error && (
          <Card className="mb-6 border-red-200 bg-red-50">
            <CardContent className="flex flex-col gap-3 p-5 sm:flex-row sm:items-center sm:justify-between">
              <p className="text-sm text-red-700">{error}</p>
              <Button variant="outline" size="sm" onClick={() => fetchPhong(selectedToaNha, searchTerm.trim(), minGia, maxGia, minDienTich, page, userLocation, radiusKm)}>
                Thử lại
              </Button>
            </CardContent>
          </Card>
        )}

        {/* Room Grid */}
        {!error && <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 md:gap-6">
          {filteredPhong.map((phong) => (
            <Card key={phong._id} className="group cursor-pointer overflow-hidden rounded-[22px] border border-[#243B5A]/[0.08] bg-[#FFFCF8] shadow-[0_12px_30px_rgba(36,59,90,0.08)] transition duration-200 ease-out hover:-translate-y-1 hover:shadow-[0_18px_40px_rgba(36,59,90,0.12)]">
              <div className="aspect-video bg-gradient-to-br from-slate-100 to-slate-200 relative overflow-hidden">
                {(phong.anhDaiDien || (phong.anhPhong && phong.anhPhong.length > 0)) ? (
                  <>
                    <div className="relative h-full w-full transition-transform duration-300 ease-out group-hover:scale-[1.03]">
                      <Image
                        src={phong.anhDaiDien || phong.anhPhong?.[0]}
                        alt={`Phòng ${phong.ten || phong.maPhong}`}
                        fill
                        sizes="(max-width: 768px) 100vw, 33vw"
                        className="object-cover"
                      />
                    </div>
                    <div className="absolute inset-0 bg-gradient-to-t from-black/40 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                    {phong.anhPhong && phong.anhPhong.length > 0 && (
                      <ImageCarousel
                        images={phong.anhPhong}
                        className="opacity-0 group-hover:opacity-100 transition-all duration-300"
                      />
                    )}
                  </>
                ) : (
                  <div className="w-full h-full flex items-center justify-center">
                    <div className="flex flex-col items-center gap-3">
                      <div className="flex h-16 w-16 items-center justify-center rounded-2xl bg-white/85 text-[#243B5A] shadow-sm ring-1 ring-[#E3D8CA]">
                        <Home className="h-8 w-8" />
                      </div>
                      <span className="rounded-full bg-white/80 px-3 py-1 text-xs font-bold text-[#6B7A8C] ring-1 ring-[#E8DED1]">Chưa có ảnh</span>
                    </div>
                  </div>
                )}
                <div className="absolute top-2 left-2">
                  {getTrangThaiBadge(phong.trangThai)}
                </div>
              </div>
              
              <CardHeader className="p-4 md:p-6">
                <CardTitle className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2 text-base md:text-lg">
                  <span className="text-[#243B5A]">Phòng {phong.ten || phong.maPhong}</span>
                  <span className="text-base md:text-lg font-black text-[#F2A45B]">
                    {formatCurrency(phong.giaHienTai || phong.giaThue)}
                  </span>
                </CardTitle>
                <CardDescription className="flex flex-wrap gap-2 md:gap-4 text-xs md:text-sm">
                  <span className="flex items-center">
                    <MapPin className="h-3 w-3 md:h-4 md:w-4 mr-1 flex-shrink-0" />
                    <span className="truncate">{phong.tenNhaTro || getToaNhaTen(phong.toaNha as ToaNhaRef)}</span>
                  </span>
                  <span className="flex items-center">
                    <Square className="h-3 w-3 md:h-4 md:w-4 mr-1 flex-shrink-0" />
                    {phong.dienTich}m²
                  </span>
                  <span className="flex items-center">
                    <Users className="h-3 w-3 md:h-4 md:w-4 mr-1 flex-shrink-0" />
                    {phong.soNguoiToiDa} người
                  </span>
                  {typeof phong.khoangCachKm === 'number' && Number.isFinite(phong.khoangCachKm) && (
                    <span className="flex items-center font-medium text-[#267D76]">
                      <LocateFixed className="h-3 w-3 md:h-4 md:w-4 mr-1 flex-shrink-0" />
                      {phong.khoangCachKm.toLocaleString('vi-VN')} km
                    </span>
                  )}
                </CardDescription>
              </CardHeader>

              <CardContent className="p-4 md:p-6">
                {phong.moTa && (
                  <p className="text-xs md:text-sm text-gray-600 mb-3 md:mb-4 line-clamp-2">
                    {phong.moTa}
                  </p>
                )}
                
                {((phong.tienNghi?.length || 0) > 0 || (phong.tienIchNoiBat?.length || 0) > 0) && (
                  <div className="flex flex-wrap gap-1 mb-3 md:mb-4">
                    {(phong.tienIchNoiBat || phong.tienNghi || []).slice(0, 3).map((tienNghi) => (
                      <Badge key={tienNghi} variant="outline" className="text-[10px] md:text-xs">
                        {tienNghiLabels[tienNghi as keyof typeof tienNghiLabels] || tienNghi}
                      </Badge>
                    ))}
                    {((phong.tienIchNoiBat?.length || 0) > 3 || (phong.tienNghi?.length || 0) > 3) && (
                      <Badge variant="outline" className="text-[10px] md:text-xs">
                        +{((phong.tienIchNoiBat || phong.tienNghi || []).length) - 3}
                      </Badge>
                    )}
                  </div>
                )}

                <div className="flex gap-2">
                <Link href={`/phong/${phong._id || phong.id}`} className="block flex-1">
                  <Button 
                    size="sm"
                    className="w-full rounded-2xl bg-[#243B5A] text-white border-0 shadow-lg shadow-[#243B5A]/10 transition-all duration-200 ease-out hover:-translate-y-0.5 hover:bg-[#4FA7A0] hover:shadow-xl group"
                  >
                    <Eye className="h-3.5 w-3.5 md:h-4 md:w-4 mr-2 group-hover:scale-110 transition-transform duration-300" />
                    Xem chi tiết
                  </Button>
                </Link>
                  {phong.viDo !== undefined && phong.kinhDo !== undefined && (
                    <a
                      href={`https://www.google.com/maps/dir/?api=1&destination=${encodeURIComponent(`${phong.viDo},${phong.kinhDo}`)}`}
                      target="_blank"
                      rel="noreferrer"
                      aria-label="Chỉ đường trên Google Maps"
                    >
                      <Button type="button" size="sm" variant="outline" className="h-full rounded-2xl">
                        <ExternalLink className="h-4 w-4" />
                      </Button>
                    </a>
                  )}
                </div>
              </CardContent>
            </Card>
          ))}
        </div>}

        {!error && filteredPhong.length === 0 && (
          <Card className="border-0 shadow-xl bg-white/80 backdrop-blur-sm">
            <CardContent className="flex flex-col items-center justify-center py-12 p-4 md:p-6">
              <div className="w-20 h-20 md:w-24 md:h-24 bg-[#4FA7A0]/10 rounded-full flex items-center justify-center mb-6">
                <Home className="h-10 w-10 md:h-12 md:w-12 text-[#267D76]" />
              </div>
              <h3 className="text-base md:text-lg font-black text-[#243B5A] mb-2">
                Không tìm thấy phòng nào
              </h3>
              <p className="text-xs md:text-sm text-[#6B7A8C] text-center">
                Hãy thử thay đổi bộ lọc hoặc từ khóa tìm kiếm
              </p>
            </CardContent>
          </Card>
        )}

        {!error && totalPages > 1 && (
          <div className="mt-8 flex items-center justify-center gap-3">
            <Button variant="outline" disabled={page <= 1} onClick={() => setPage((current) => current - 1)}>
              Trang trước
            </Button>
            <span className="text-sm text-[#6B7A8C]">Trang {page} / {totalPages}</span>
            <Button variant="outline" disabled={page >= totalPages} onClick={() => setPage((current) => current + 1)}>
              Trang sau
            </Button>
          </div>
        )}
      </div>
    </div>
  );
}
