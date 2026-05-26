'use client';

import { useState, useEffect, useCallback, use } from 'react';
import Image from 'next/image';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { 
  Home, 
  MapPin, 
  Users, 
  Square, 
  Phone,
  ArrowLeft,
  Star,
  ZoomIn
} from 'lucide-react';
import { toast } from 'sonner';
import Link from 'next/link';
import { ImageCarousel } from '@/components/ui/image-carousel';
import { DatLichHenDialog } from '@/components/ui/dat-lich-hen-dialog';

export default function PhongDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const unwrappedParams = use(params);
  const { id } = unwrappedParams;
  
  const [phong, setPhong] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [selectedImageIndex, setSelectedImageIndex] = useState(0);
  const [isBookingOpen, setIsBookingOpen] = useState(false);

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
      RESERVED: { variant: 'outline' as const, label: 'Đã đặt', color: 'text-blue-600' },
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

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-cyan-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-indigo-600"></div>
      </div>
    );
  }

  if (!phong) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-cyan-50 flex flex-col items-center justify-center p-4">
        <h1 className="text-2xl font-bold mb-4">Không tìm thấy phòng</h1>
        <Link href="/xem-phong">
          <Button><ArrowLeft className="mr-2 h-4 w-4" /> Quay lại danh sách</Button>
        </Link>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-cyan-50 relative">
      <div className="absolute inset-0 opacity-15">
        <div className="absolute inset-0" style={{
          backgroundImage: 'radial-gradient(circle, #6366f1 1.5px, transparent 1.5px)',
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
              <h1 className="text-xl md:text-2xl lg:text-3xl font-bold bg-gradient-to-r from-indigo-800 via-purple-700 to-cyan-700 bg-clip-text text-transparent">
                Phòng {phong.ten}
              </h1>
              <p className="text-xs md:text-sm text-slate-600">
                {phong.nhaTro?.tenNhaTro} - Tầng {phong.tang || 'N/A'}
              </p>
            </div>
            <div className="text-left md:text-right">
              <div className="text-xl md:text-2xl font-bold bg-gradient-to-r from-emerald-600 to-green-600 bg-clip-text text-transparent">
                {formatCurrency(phong.giaHienTai)}
              </div>
              <div className="text-xs md:text-sm text-slate-500">/ tháng</div>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-4 md:gap-6 lg:gap-8">
          <div className="lg:col-span-2 space-y-4 md:space-y-6">
            {phong.anhList && phong.anhList.length > 0 ? (
              <Card className="border-0 shadow-xl bg-white/95 backdrop-blur-sm">
                <CardHeader className="p-4 md:p-6">
                  <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2">
                    <CardTitle className="text-base md:text-lg bg-gradient-to-r from-indigo-700 to-purple-600 bg-clip-text text-transparent">Hình ảnh phòng</CardTitle>
                    <ImageCarousel
                      images={phong.anhList}
                      trigger={
                        <Button variant="outline" size="sm" className="text-xs md:text-sm w-full sm:w-auto">
                          <ZoomIn className="h-3.5 w-3.5 md:h-4 md:w-4 mr-1 md:mr-2" />
                          Xem toàn màn hình
                        </Button>
                      }
                    />
                  </div>
                </CardHeader>
                <CardContent className="p-4 md:p-6">
                  <div className="space-y-3 md:space-y-4">
                    <div className="aspect-video rounded-lg overflow-hidden bg-gray-100">
                      <div className="relative h-full w-full">
                        <Image
                          src={phong.anhList[selectedImageIndex]}
                          alt={`Ảnh phòng ${selectedImageIndex + 1}`}
                          fill
                          sizes="(max-width: 768px) 100vw, 50vw"
                          className="object-cover"
                        />
                      </div>
                    </div>
                    
                    <div className="grid grid-cols-4 md:grid-cols-6 gap-2">
                      {phong.anhList.map((image: string, index: number) => (
                        <div 
                          key={index} 
                          className={`aspect-square rounded-lg overflow-hidden cursor-pointer border-2 transition-all ${
                            index === selectedImageIndex 
                              ? 'border-blue-500 ring-2 ring-blue-200' 
                              : 'border-gray-200 hover:border-gray-300'
                          }`}
                          onClick={() => setSelectedImageIndex(index)}
                        >
                          <div className="relative h-full w-full">
                            <Image
                              src={image}
                              alt={`Ảnh phòng ${index + 1}`}
                              fill
                              sizes="25vw"
                              className="object-cover"
                            />
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                </CardContent>
              </Card>
            ) : (
              <Card>
                <CardContent className="flex flex-col items-center justify-center py-12 p-4 md:p-6">
                  <Home className="h-12 w-12 md:h-16 md:w-16 text-gray-400 mb-4" />
                  <p className="text-sm md:text-base text-gray-500">Chưa có hình ảnh phòng</p>
                </CardContent>
              </Card>
            )}

            {phong.moTa && (
              <Card className="border-0 shadow-xl bg-white/95 backdrop-blur-sm">
                <CardHeader className="p-4 md:p-6">
                  <CardTitle className="text-base md:text-lg bg-gradient-to-r from-indigo-700 to-purple-600 bg-clip-text text-transparent">Mô tả</CardTitle>
                </CardHeader>
                <CardContent className="p-4 md:p-6">
                  <p className="text-sm md:text-base text-gray-700 whitespace-pre-wrap">{phong.moTa}</p>
                </CardContent>
              </Card>
            )}

            {phong.tienIchList && phong.tienIchList.length > 0 && (
              <Card className="border-0 shadow-xl bg-white/95 backdrop-blur-sm">
                <CardHeader className="p-4 md:p-6">
                  <CardTitle className="text-base md:text-lg bg-gradient-to-r from-indigo-700 to-purple-600 bg-clip-text text-transparent">Tiện nghi</CardTitle>
                </CardHeader>
                <CardContent className="p-4 md:p-6">
                  <div className="grid grid-cols-2 md:grid-cols-3 gap-2 md:gap-3">
                    {phong.tienIchList.map((tienNghi: string) => (
                      <div key={tienNghi} className="flex items-center space-x-2">
                        <Star className="h-3 w-3 md:h-4 md:w-4 text-yellow-500 flex-shrink-0" />
                        <span className="text-xs md:text-sm truncate">{tienNghiLabels[tienNghi] || tienNghi}</span>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            )}
          </div>

          <div className="space-y-4 md:space-y-6">
            <Card className="border-0 shadow-xl bg-white/95 backdrop-blur-sm">
              <CardHeader className="p-4 md:p-6">
                <CardTitle className="text-base md:text-lg bg-gradient-to-r from-indigo-700 to-purple-600 bg-clip-text text-transparent">Thông tin phòng</CardTitle>
              </CardHeader>
              <CardContent className="space-y-3 md:space-y-4 p-4 md:p-6">
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

            <Card className="border-0 shadow-xl bg-gradient-to-br from-emerald-50/80 to-green-100/80 backdrop-blur-sm">
              <CardHeader className="p-4 md:p-6">
                <CardTitle className="text-base md:text-lg bg-gradient-to-r from-emerald-700 to-green-600 bg-clip-text text-transparent">Giá thuê</CardTitle>
              </CardHeader>
              <CardContent className="space-y-3 md:space-y-4 p-4 md:p-6">
                <div className="flex items-center justify-between">
                  <span className="text-xs md:text-sm text-gray-600">Giá thuê:</span>
                  <span className="font-bold text-base md:text-lg text-green-600">
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
              <Card className="border-0 shadow-xl bg-gradient-to-br from-green-50/80 to-emerald-100/80 backdrop-blur-sm">
                <CardHeader className="p-4 md:p-6">
                  <CardTitle className="text-base md:text-lg bg-gradient-to-r from-green-700 to-emerald-600 bg-clip-text text-transparent">Liên hệ thuê phòng</CardTitle>
                </CardHeader>
                <CardContent className="space-y-3 md:space-y-4 p-4 md:p-6">
                  <p className="text-xs md:text-sm text-slate-600">
                    Phòng này hiện đang trống và có thể cho thuê. Vui lòng liên hệ để biết thêm thông tin.
                  </p>
                  <Button 
                    className="w-full bg-gradient-to-r from-green-600 to-emerald-600 hover:from-green-700 hover:to-emerald-700 border-0 shadow-lg hover:shadow-xl transition-all duration-300" 
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
      
      <DatLichHenDialog 
        isOpen={isBookingOpen} 
        onClose={() => setIsBookingOpen(false)} 
        phongId={phong._id} 
        maPhong={phong.ten} 
      />
    </div>
  );
}
