'use client';

import { useState, useEffect, useCallback } from 'react';
import { Card, CardContent } from '@/components/ui/card';
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
  ArrowLeft,
  LocateFixed,
} from 'lucide-react';
import { Phong, ToaNha } from '@/types';
import { toast } from 'sonner';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { PropertyCard, PropertyCardSkeleton } from '@/components/property/property-card';
import { CountUp, StaggerGroup, StaggerItem, motion } from '@/components/motion';

type ToaNhaRef = string | { tenToaNha?: string };
type UserLocation = { viDo: number; kinhDo: number };

const getToaNhaTen = (toaNha: ToaNhaRef) => {
  if (typeof toaNha === 'object' && toaNha?.tenToaNha) {
    return toaNha.tenToaNha;
  }
  return 'N/A';
};

export default function XemPhongPage() {
  const router = useRouter();
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

  /** Trang thai phong -> badge cua PropertyCard (nhan + tong mau). */
  const getTrangThaiBadge = (trangThai: string): { label: string; tone: 'teal' | 'navy' | 'orange' } => {
    const variants: Record<string, { label: string; tone: 'teal' | 'navy' | 'orange' }> = {
      trong: { label: 'Còn trống', tone: 'teal' },
      daDat: { label: 'Đã đặt', tone: 'navy' },
      dangThue: { label: 'Đang thuê', tone: 'orange' },
      baoTri: { label: 'Bảo trì', tone: 'navy' },
    };
    return variants[trangThai] || variants.trong;
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

  /*
   * Co y KHONG return sam mot man hinh loading toan trang o day.
   * Fetch duoc debounce theo tung ky tu nguoi dung go, nen return sam se lam
   * ca header va bo loc bien mat roi hien lai lien tuc trong luc go.
   * Thay vao do chi rieng luoi phong doi thanh skeleton (xem ben duoi).
   */

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

        <StaggerGroup className="mb-4 grid grid-cols-1 gap-3 sm:grid-cols-2 md:mb-8 md:gap-4" stagger={0.08}>
          <StaggerItem>
            <motion.div whileHover={{ y: -4 }} transition={{ type: 'spring', stiffness: 400, damping: 25 }}>
              <Card className="border border-[#E8DED2] bg-white p-4 shadow-sm">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs font-medium text-[#6B7A8C]">Phòng trống phù hợp</p>
                    <p className="text-2xl font-bold text-[#243B5A]">
                      <CountUp value={totalElements} duration={0.9} />
                    </p>
                  </div>
                  <Home className="h-5 w-5 text-[#267D76]" />
                </div>
              </Card>
            </motion.div>
          </StaggerItem>
          <StaggerItem>
            <motion.div whileHover={{ y: -4 }} transition={{ type: 'spring', stiffness: 400, damping: 25 }}>
              <Card className="border border-[#E8DED2] bg-white p-4 shadow-sm">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-xs font-medium text-[#6B7A8C]">Tòa nhà đang hiển thị</p>
                    <p className="text-2xl font-bold text-[#243B5A]">
                      <CountUp
                        value={selectedToaNha && selectedToaNha !== 'all' ? 1 : toaNhaList.length}
                        duration={0.9}
                      />
                    </p>
                  </div>
                  <MapPin className="h-5 w-5 text-[#6B7A8C]" />
                </div>
              </Card>
            </motion.div>
          </StaggerItem>
        </StaggerGroup>

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

        {/* Room Grid - dung chung PropertyCard voi trang chu */}
        {!error && loading && (
          <div className="grid grid-cols-1 gap-4 md:grid-cols-2 md:gap-6 lg:grid-cols-3">
            {Array.from({ length: 6 }).map((_, i) => (
              <PropertyCardSkeleton key={i} />
            ))}
          </div>
        )}

        {!error && !loading && (
          <StaggerGroup
            className="grid grid-cols-1 gap-4 md:grid-cols-2 md:gap-6 lg:grid-cols-3"
            stagger={0.06}
            amount={0.02}
          >
            {filteredPhong.map((phong) => {
              const id = phong._id || phong.id;
              const images = [
                phong.anhDaiDien,
                ...(phong.anhPhong || []),
              ].filter((src, index, list): src is string => Boolean(src) && list.indexOf(src) === index);

              const amenities = (phong.tienIchNoiBat || phong.tienNghi || []).map(
                (item) => tienNghiLabels[item as keyof typeof tienNghiLabels] || item
              );

              return (
                <StaggerItem key={phong._id} className="h-full">
                  <PropertyCard
                    room={{
                      id: id ?? '',
                      name: `Phòng ${phong.ten || phong.maPhong}`,
                      location: phong.tenNhaTro || getToaNhaTen(phong.toaNha as ToaNhaRef),
                      priceLabel: formatCurrency(phong.giaHienTai || phong.giaThue),
                      areaLabel: `${phong.dienTich}m²`,
                      description: phong.moTa,
                      images,
                      amenities,
                      badge: getTrangThaiBadge(phong.trangThai),
                      meta: (
                        <>
                          {phong.soNguoiToiDa ? (
                            <span className="rounded-full bg-[#F8F3EC] px-2.5 py-1 text-[#243B5A]">
                              {phong.soNguoiToiDa} người
                            </span>
                          ) : null}
                          {typeof phong.khoangCachKm === 'number' && Number.isFinite(phong.khoangCachKm) ? (
                            <span className="inline-flex items-center gap-1 rounded-full bg-[#4FA7A0]/10 px-2.5 py-1 text-[#267D76]">
                              <LocateFixed className="h-3 w-3" />
                              {phong.khoangCachKm.toLocaleString('vi-VN')} km
                            </span>
                          ) : null}
                        </>
                      ),
                    }}
                    onSelect={() => router.push(`/phong/${id}`)}
                    className="eh-shadow-float eh-shadow-float-hover h-full"
                  />
                </StaggerItem>
              );
            })}
          </StaggerGroup>
        )}

        {!error && !loading && filteredPhong.length === 0 && (
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
