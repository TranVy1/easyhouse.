'use client';

import { useState, useEffect, useCallback, use } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { 
  Home, 
  Phone,
  ArrowLeft,
  Star,
  MapPin,
  Navigation,
  ExternalLink,
} from 'lucide-react';
import { toast } from 'sonner';
import Link from 'next/link';
import { DatLichHenDialog } from '@/components/ui/dat-lich-hen-dialog';
import { SessionProvider } from 'next-auth/react';
import { Gallery } from '@/components/property/gallery';
import { PanoramaTeaser, PanoramaViewer, useDetectPanoramas } from '@/components/property/panorama-viewer';
import { CountUp, Reveal, StaggerGroup, StaggerItem, motion } from '@/components/motion';

interface PublicPhongDetail {
  _id: string;
  ten: string;
  tang?: number;
  giaHienTai: number;
  tienCocMacDinh: number;
  dienTich: number;
  soNguoiToiDa: number;
  trangThai: string;
  moTa?: string;
  anhList: string[];
  tienIchList: string[];
  nhaTro?: { tenNhaTro?: string; diaChi?: string };
}

export default function PhongDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const unwrappedParams = use(params);
  const { id } = unwrappedParams;
  
  const [phong, setPhong] = useState<PublicPhongDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [isBookingOpen, setIsBookingOpen] = useState(false);
  const [tourOpen, setTourOpen] = useState(false);

  // Tu dong nhan dien anh 360 (equirectangular 2:1) trong danh sach anh phong.
  const panoramas = useDetectPanoramas(phong?.anhList ?? []);

  const fetchPhong = useCallback(async () => {
    try {
      const response = await fetch(`/api/public/phong/${id}`);
      if (response.ok) {
        const result = await response.json();
        if (result.success) {
          setPhong(result.data);
        } else {
          toast.error(result.message || 'Không tìm thấy phòng');
        }
      }
    } catch (error) {
      console.error('Error fetching phong detail:', error);
      toast.error('Có lỗi xảy ra khi tải chi tiết phòng');
    } finally {
      setLoading(false);
    }
  }, [id]);

  useEffect(() => {
    fetchPhong();
  }, [fetchPhong]);

  const getTrangThaiBadge = (trangThai: string) => {
    const variants = {
      AVAILABLE: { variant: 'secondary' as const, label: 'Trống', color: 'text-green-600' },
      RESERVED: { variant: 'outline' as const, label: 'Đã đặt', color: 'text-[#243B5A]' },
      RENTED: { variant: 'default' as const, label: 'Đang thuê', color: 'text-orange-600' },
      MAINTENANCE: { variant: 'destructive' as const, label: 'Bảo trì', color: 'text-red-600' },
    };
    
    const tt = trangThai || 'AVAILABLE';
    const config = variants[tt as keyof typeof variants] || variants.AVAILABLE;
    return <Badge variant={config.variant} className={config.color}>{config.label}</Badge>;
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND'
    }).format(amount || 0);
  };

  const tienNghiLabels: Record<string, string> = {
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

  const roomLocation = phong?.nhaTro?.diaChi?.trim();
  const googleMapsEmbedUrl = roomLocation
    ? `https://www.google.com/maps?q=${encodeURIComponent(roomLocation)}&z=16&output=embed`
    : null;
  const googleMapsDirectionsUrl = roomLocation
    ? `https://www.google.com/maps/dir/?api=1&destination=${encodeURIComponent(roomLocation)}`
    : null;

  if (loading) {
    return (
      <div className="min-h-screen bg-[#F8F3EC]">
        <div className="container relative mx-auto px-4 py-4 md:py-8">
          <div className="skeleton-shimmer mb-6 h-9 w-40 rounded-xl" />
          <div className="mb-6 space-y-3">
            <div className="skeleton-shimmer h-8 w-64 rounded-lg" />
            <div className="skeleton-shimmer h-4 w-48 rounded-full" />
          </div>
          <div className="grid grid-cols-1 gap-4 md:gap-6 lg:grid-cols-3 lg:gap-8">
            <div className="space-y-4 md:space-y-6 lg:col-span-2">
              <div className="skeleton-shimmer h-[240px] w-full rounded-3xl md:h-[420px]" />
              <div className="skeleton-shimmer h-32 w-full rounded-2xl" />
              <div className="skeleton-shimmer h-40 w-full rounded-2xl" />
            </div>
            <div className="space-y-4">
              <div className="skeleton-shimmer h-64 w-full rounded-2xl" />
              <div className="skeleton-shimmer h-48 w-full rounded-2xl" />
            </div>
          </div>
        </div>
      </div>
    );
  }

  if (!phong) {
    return (
      <div className="flex min-h-screen flex-col items-center justify-center gap-4 bg-[#F8F3EC] p-4 text-center">
        <div className="flex h-16 w-16 items-center justify-center rounded-2xl bg-white text-[#243B5A] shadow-sm ring-1 ring-[#E8DED2]">
          <Home className="h-7 w-7" />
        </div>
        <h1 className="text-2xl font-black text-[#243B5A]">Không tìm thấy phòng</h1>
        <p className="max-w-sm text-sm text-[#6B7A8C]">
          Phòng có thể đã được thuê hoặc chủ nhà đã gỡ tin đăng.
        </p>
        <Link href="/xem-phong">
          <Button className="rounded-2xl bg-[#243B5A] hover:bg-[#1b2e47]">
            <ArrowLeft className="mr-2 h-4 w-4" /> Quay lại danh sách
          </Button>
        </Link>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#F8F3EC] relative">
      <div className="absolute inset-0 opacity-15">
        <div className="absolute inset-0" style={{
          backgroundImage: 'radial-gradient(circle, rgba(79, 167, 160, 0.26) 1.5px, transparent 1.5px)',
          backgroundSize: '25px 25px'
        }}></div>
      </div>
      
      <div className="relative container mx-auto px-4 py-4 md:py-8">
        <div className="mb-4 md:mb-6">
          <Link href="/xem-phong">
            <Button variant="outline" size="sm" className="mb-3 md:mb-4">
              <ArrowLeft className="h-4 w-4 mr-2" />
              Quay lại danh sách
            </Button>
          </Link>
          
          <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-3">
            <div>
              <h1 className="text-xl md:text-2xl lg:text-3xl font-bold text-[#243B5A]">
                Phòng {phong.ten}
              </h1>
              <p className="text-xs md:text-sm text-[#6B7A8C]">
                {phong.nhaTro?.tenNhaTro} - Tầng {phong.tang || 'N/A'}
              </p>
            </div>
            <div className="text-left md:text-right">
              <div className="text-xl font-bold text-[#F2A45B] md:text-2xl">
                <CountUp
                  value={phong.giaHienTai || 0}
                  duration={1}
                  format={(n) => formatCurrency(n)}
                />
              </div>
              <div className="text-xs text-[#6B7A8C] md:text-sm">/ tháng</div>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-4 md:gap-6 lg:gap-8">
          <div className="lg:col-span-2 space-y-4 md:space-y-6">
            {phong.anhList && phong.anhList.length > 0 ? (
              <Reveal duration={0.5}>
                {/* Gallery mosaic + lightbox dung chung voi trang chu */}
                <Gallery images={phong.anhList} alt={`Phòng ${phong.ten}`} />
              </Reveal>
            ) : (
              <Card className="gap-0 border border-[#E8DED2] bg-[#FFFDF8]">
                <CardContent className="flex flex-col items-center justify-center p-4 py-12 md:p-6">
                  <Home className="mb-4 h-12 w-12 text-[#6B7A8C] md:h-16 md:w-16" />
                  <p className="text-sm text-[#6B7A8C] md:text-base">Chưa có hình ảnh phòng</p>
                </CardContent>
              </Card>
            )}

            {/* Tour 360 - chi hien khi co anh equirectangular */}
            {panoramas.length > 0 && (
              <Reveal delay={0.05}>
                {tourOpen ? (
                  <div className="space-y-3">
                    <PanoramaViewer panoramas={panoramas} height="480px" />
                    <button
                      onClick={() => setTourOpen(false)}
                      className="text-sm font-bold text-[#6B7A8C] transition-colors hover:text-[#243B5A]"
                    >
                      Thu gọn tour 360°
                    </button>
                  </div>
                ) : (
                  <PanoramaTeaser onOpen={() => setTourOpen(true)} count={panoramas.length} />
                )}
              </Reveal>
            )}

            {phong.moTa && (
              <Card className="gap-0 border border-[#E8DED2] bg-[#FFFDF8] shadow-sm">
                <CardHeader className="grid-rows-[auto] px-4 pb-0 pt-4 md:px-6 md:pt-6">
                  <CardTitle className="text-base md:text-lg text-[#243B5A]">Mô tả</CardTitle>
                </CardHeader>
                <CardContent className="px-4 pb-4 pt-3 md:px-6 md:pb-6">
                  <p className="text-sm md:text-base text-gray-700 whitespace-pre-wrap">{phong.moTa}</p>
                </CardContent>
              </Card>
            )}

            {phong.tienIchList && phong.tienIchList.length > 0 && (
              <Card className="gap-0 border border-[#E8DED2] bg-[#FFFDF8] shadow-sm">
                <CardHeader className="grid-rows-[auto] px-4 pb-0 pt-4 md:px-6 md:pt-6">
                  <CardTitle className="text-base md:text-lg text-[#243B5A]">Tiện nghi</CardTitle>
                </CardHeader>
                <CardContent className="px-4 pb-4 pt-3 md:px-6 md:pb-6">
                  <StaggerGroup className="grid grid-cols-2 gap-2 md:grid-cols-3 md:gap-3" stagger={0.05}>
                    {phong.tienIchList.map((tienNghi: string) => (
                      <StaggerItem key={tienNghi}>
                        <motion.div
                          whileHover={{ y: -3 }}
                          transition={{ type: 'spring', stiffness: 400, damping: 25 }}
                          className="flex items-center gap-2 rounded-xl border border-[#E8DED2] bg-[#F8F3EC] px-3 py-2.5 transition-colors hover:border-[#4FA7A0]/40 hover:bg-white"
                        >
                          <Star className="h-3 w-3 flex-shrink-0 fill-amber-400 text-amber-400 md:h-4 md:w-4" />
                          <span className="truncate text-xs font-semibold text-[#243B5A] md:text-sm">
                            {tienNghiLabels[tienNghi] || tienNghi}
                          </span>
                        </motion.div>
                      </StaggerItem>
                    ))}
                  </StaggerGroup>
                </CardContent>
              </Card>
            )}

            <Card className="gap-0 border border-[#E8DED2] bg-[#FFFDF8] shadow-sm">
              <CardHeader className="grid-rows-[auto] px-4 pb-0 pt-4 md:px-6 md:pt-6">
                <CardTitle className="flex items-center gap-2 text-base md:text-lg text-[#243B5A]">
                  <MapPin className="h-5 w-5 text-[#FF5A3D]" />
                  Vị trí địa lý
                </CardTitle>
              </CardHeader>
              <CardContent className="px-4 pb-4 pt-3 md:px-6 md:pb-6">
                {googleMapsEmbedUrl ? (
                  <>
                    <div className="relative h-64 overflow-hidden rounded-xl border border-slate-200 bg-slate-100">
                      <iframe
                        src={googleMapsEmbedUrl}
                        title={`Bản đồ ${roomLocation}`}
                        className="h-full w-full border-0"
                        loading="lazy"
                        referrerPolicy="no-referrer-when-downgrade"
                        allowFullScreen
                      />
                    </div>
                    <div className="mt-3 flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                      <p className="flex items-start gap-2 text-sm text-slate-600">
                        <MapPin className="mt-0.5 h-4 w-4 shrink-0 text-[#FF5A3D]" />
                        {roomLocation}
                      </p>
                      <a href={googleMapsDirectionsUrl!} target="_blank" rel="noopener noreferrer">
                        <Button variant="outline" size="sm" className="w-full sm:w-auto">
                          <Navigation className="mr-2 h-4 w-4" />
                          Chỉ đường
                          <ExternalLink className="ml-2 h-3.5 w-3.5" />
                        </Button>
                      </a>
                    </div>
                  </>
                ) : (
                  <p className="text-sm text-slate-500">Chủ nhà chưa cập nhật địa chỉ để hiển thị bản đồ.</p>
                )}
              </CardContent>
            </Card>
          </div>

          <div className="space-y-4 md:space-y-6">
            <Card className="gap-0 border border-[#E8DED2] bg-[#FFFDF8] shadow-sm">
              <CardHeader className="grid-rows-[auto] px-4 pb-0 pt-4 md:px-6 md:pt-6">
                <CardTitle className="text-base md:text-lg text-[#243B5A]">Thông tin phòng</CardTitle>
              </CardHeader>
              <CardContent className="space-y-3 px-4 pb-4 pt-3 md:space-y-4 md:px-6 md:pb-6">
                <div className="flex items-center justify-between text-xs md:text-sm">
                  <span className="text-gray-600">Tên phòng:</span>
                  <span className="font-medium">{phong.ten}</span>
                </div>
                <div className="flex items-center justify-between text-xs md:text-sm">
                  <span className="text-gray-600">Tòa nhà:</span>
                  <span className="font-medium truncate ml-2">
                    {phong.nhaTro?.tenNhaTro}
                  </span>
                </div>
                <div className="flex items-center justify-between text-xs md:text-sm">
                  <span className="text-gray-600">Diện tích:</span>
                  <span className="font-medium">{phong.dienTich} m²</span>
                </div>
                <div className="flex items-center justify-between text-xs md:text-sm">
                  <span className="text-gray-600">Số người tối đa:</span>
                  <span className="font-medium">{phong.soNguoiToiDa} người</span>
                </div>
                <div className="flex items-center justify-between text-xs md:text-sm">
                  <span className="text-gray-600">Trạng thái:</span>
                  {getTrangThaiBadge(phong.trangThai)}
                </div>
              </CardContent>
            </Card>

            <Card className="gap-0 border border-[#E8DED2] bg-[#FFFDF8] shadow-sm">
              <CardHeader className="grid-rows-[auto] px-4 pb-0 pt-4 md:px-6 md:pt-6">
                <CardTitle className="text-base md:text-lg text-[#243B5A]">Giá thuê</CardTitle>
              </CardHeader>
              <CardContent className="space-y-3 px-4 pb-4 pt-3 md:space-y-4 md:px-6 md:pb-6">
                <div className="flex items-center justify-between">
                  <span className="text-xs md:text-sm text-gray-600">Giá thuê:</span>
                  <span className="font-bold text-base md:text-lg text-[#F2A45B]">
                    {formatCurrency(phong.giaHienTai)}
                  </span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-xs md:text-sm text-gray-600">Tiền cọc:</span>
                  <span className="text-sm md:text-base font-medium">
                    {formatCurrency(phong.tienCocMacDinh)}
                  </span>
                </div>
              </CardContent>
            </Card>

            {phong.trangThai === 'AVAILABLE' && (
              <Card className="gap-0 border border-[#E8DED2] bg-[#FFFDF8] shadow-sm">
                <CardHeader className="grid-rows-[auto] px-4 pb-0 pt-4 md:px-6 md:pt-6">
                  <CardTitle className="text-base md:text-lg text-[#243B5A]">Liên hệ thuê phòng</CardTitle>
                </CardHeader>
                <CardContent className="space-y-3 px-4 pb-4 pt-3 md:space-y-4 md:px-6 md:pb-6">
                  <p className="text-xs md:text-sm text-[#6B7A8C]">
                    Phòng này hiện đang trống và có thể cho thuê. Vui lòng liên hệ để biết thêm thông tin.
                  </p>
                  <Button 
                    className="w-full bg-[#FF5A3D] hover:bg-orange-600 border-0 rounded-2xl shadow-md shadow-orange-200 transition-all duration-300" 
                    size="sm"
                    onClick={() => setIsBookingOpen(true)}
                  >
                    <Phone className="h-4 w-4 mr-2" />
                    Đặt lịch xem phòng
                  </Button>
                </CardContent>
              </Card>
            )}
          </div>
        </div>
      </div>
      
      <SessionProvider>
        <DatLichHenDialog 
          isOpen={isBookingOpen} 
          onClose={() => setIsBookingOpen(false)} 
          phongId={phong._id} 
          maPhong={phong.ten} 
        />
      </SessionProvider>
    </div>
  );
}
