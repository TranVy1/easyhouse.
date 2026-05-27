'use client';

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Home, FileText, AlertCircle, MapPin, Calendar, DollarSign, Phone, Mail, FileWarning, SearchX, User } from 'lucide-react';
import { useTenantDashboard } from './context';
import Link from 'next/link';
import { Button } from '@/components/ui/button';

export default function KhachThueDashboardPage() {
  const { data: dashboardData, loading, error, refreshData } = useTenantDashboard();

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (error) {
    return (
      <Card className="mx-auto mt-8 max-w-lg border-red-200 bg-red-50">
        <CardContent className="space-y-4 p-6 text-center">
          <p className="text-sm text-red-700">{error}</p>
          <Button variant="outline" onClick={() => void refreshData()}>Thử tải lại</Button>
        </CardContent>
      </Card>
    );
  }

  if (!dashboardData) {
    return <div className="text-center text-gray-600">Chưa có dữ liệu cư dân.</div>;
  }

  const { khachThue, hopDongHienTai, soHoaDonChuaThanhToan, soSuCoDangMo, hoaDonGanNhat, lienHe } = dashboardData;


  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND'
    }).format(amount);
  };

  const formatDate = (date: string | Date) => {
    return new Date(date).toLocaleDateString('vi-VN');
  };

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Tổng quan</h1>
        <p className="text-gray-600">Xin chào {khachThue.hoTen}, đây là thông tin của bạn</p>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 md:gap-6">
        <Card className="flex flex-col">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Phòng</CardTitle>
            <Home className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-xl md:text-2xl font-bold truncate">
              {hopDongHienTai?.phong?.maPhong || '---'}
            </div>
          </CardContent>
        </Card>

        <Card className="flex flex-col">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Nợ cước</CardTitle>
            <FileText className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className={`text-xl md:text-2xl font-bold ${soHoaDonChuaThanhToan > 0 ? 'text-red-600' : 'text-green-600'}`}>
              {soHoaDonChuaThanhToan}
            </div>
          </CardContent>
        </Card>

        <Card className="flex flex-col">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Sự cố chờ</CardTitle>
            <FileWarning className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className={`text-xl md:text-2xl font-bold ${soSuCoDangMo > 0 ? 'text-orange-600' : 'text-gray-900'}`}>
              {soSuCoDangMo}
            </div>
          </CardContent>
        </Card>

        <Card className="flex flex-col">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Trạng thái</CardTitle>
            <AlertCircle className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="mt-1">
              {khachThue.trangThai === 'dangThue' ? (
                <Badge className="bg-green-600">Đang thuê</Badge>
              ) : khachThue.trangThai === 'daTraPhong' ? (
                <Badge variant="secondary">Đã trả</Badge>
              ) : (
                <Badge variant="outline">Chưa thuê</Badge>
              )}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Thông tin phòng */}
      {hopDongHienTai ? (
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Home className="h-5 w-5" />
              Thông tin phòng đang thuê
            </CardTitle>
          </CardHeader>
          <CardContent className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <h3 className="font-semibold mb-4 text-gray-700">Thông tin phòng</h3>
              <div className="space-y-4">
                <div className="flex items-start gap-3 bg-gray-50 p-3 rounded-lg">
                  <div className="bg-white p-2 rounded-md shadow-sm">
                    <Home className="h-5 w-5 text-blue-600" />
                  </div>
                  <div>
                    <p className="text-xs text-muted-foreground font-medium uppercase tracking-wider">Mã phòng</p>
                    <p className="font-bold text-gray-900">{hopDongHienTai.phong?.maPhong}</p>
                  </div>
                </div>
                <div className="flex items-start gap-3 bg-gray-50 p-3 rounded-lg">
                  <div className="bg-white p-2 rounded-md shadow-sm">
                    <MapPin className="h-5 w-5 text-blue-600" />
                  </div>
                  <div>
                    <p className="text-xs text-muted-foreground font-medium uppercase tracking-wider">Địa chỉ</p>
                    <p className="font-bold text-gray-900">{hopDongHienTai.phong?.toaNha?.tenToaNha}</p>
                    <p className="text-sm text-gray-600">
                      {hopDongHienTai.phong?.toaNha?.diaChi?.duong}, {hopDongHienTai.phong?.toaNha?.diaChi?.phuong}
                    </p>
                  </div>
                </div>
                <div className="flex items-start gap-3 bg-gray-50 p-3 rounded-lg">
                  <div className="bg-white p-2 rounded-md shadow-sm">
                    <DollarSign className="h-5 w-5 text-green-600" />
                  </div>
                  <div>
                    <p className="text-xs text-muted-foreground font-medium uppercase tracking-wider">Giá thuê/tháng</p>
                    <p className="font-bold text-green-700 text-lg">{formatCurrency(hopDongHienTai.phong?.giaThue || hopDongHienTai.giaThue || hopDongHienTai.giaThueHopDong || 0)}</p>
                  </div>
                </div>
              </div>
            </div>
            
            <div>
              <h3 className="font-semibold mb-4 text-gray-700">Thông tin hợp đồng</h3>
              <div className="space-y-4">
                <div className="flex items-start gap-3 bg-gray-50 p-3 rounded-lg">
                  <div className="bg-white p-2 rounded-md shadow-sm">
                    <FileText className="h-5 w-5 text-orange-500" />
                  </div>
                  <div>
                    <p className="text-xs text-muted-foreground font-medium uppercase tracking-wider">Mã hợp đồng</p>
                    <p className="font-bold text-gray-900">{hopDongHienTai.maHopDong}</p>
                  </div>
                </div>
                <div className="flex items-start gap-3 bg-gray-50 p-3 rounded-lg">
                  <div className="bg-white p-2 rounded-md shadow-sm">
                    <Calendar className="h-5 w-5 text-blue-600" />
                  </div>
                  <div>
                    <p className="text-xs text-muted-foreground font-medium uppercase tracking-wider">Thời hạn</p>
                    <p className="font-bold text-gray-900">
                      {formatDate(hopDongHienTai.ngayBatDau)} - {formatDate(hopDongHienTai.ngayKetThuc)}
                    </p>
                  </div>
                </div>
                <div className="flex items-start gap-3 bg-gray-50 p-3 rounded-lg">
                  <div className="bg-white p-2 rounded-md shadow-sm">
                    <DollarSign className="h-5 w-5 text-orange-600" />
                  </div>
                  <div>
                    <p className="text-xs text-muted-foreground font-medium uppercase tracking-wider">Tiền cọc</p>
                    <p className="font-bold text-orange-700 text-lg">{formatCurrency(hopDongHienTai.tienCoc)}</p>
                  </div>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      ) : (
        <Card className="bg-gray-50 border-dashed border-2">
          <CardContent className="flex flex-col items-center justify-center p-8 text-center space-y-4">
            <div className="bg-gray-100 p-4 rounded-full text-gray-400">
              <SearchX className="h-10 w-10" />
            </div>
            <div>
              <h3 className="font-bold text-lg text-gray-800">Chưa có hợp đồng nào</h3>
              <p className="text-sm text-gray-500 max-w-sm mt-1">
                Bạn hiện chưa có hợp đồng thuê phòng nào đang hoạt động. Nếu bạn vừa chuyển vào, vui lòng liên hệ quản lý để được hỗ trợ.
              </p>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Hóa đơn gần nhất */}
      {hoaDonGanNhat ? (
        <Card>
          <CardHeader className="flex flex-row items-center justify-between">
            <CardTitle className="flex items-center gap-2">
              <FileText className="h-5 w-5" />
              Hóa đơn mới nhất
            </CardTitle>
            <Button variant="outline" size="sm" asChild>
              <Link href="/khach-thue/dashboard/hoa-don">Xem tất cả</Link>
            </Button>
          </CardHeader>
          <CardContent>
            <div className="bg-gray-50 rounded-lg p-4 border grid grid-cols-2 md:grid-cols-4 gap-4">
              <div>
                <p className="text-xs text-muted-foreground font-medium uppercase">Kỳ thanh toán</p>
                <p className="font-bold text-gray-900 mt-1">Tháng {hoaDonGanNhat.thang}/{hoaDonGanNhat.nam}</p>
              </div>
              <div className="hidden md:block">
                <p className="text-xs text-muted-foreground font-medium uppercase">Mã HĐ</p>
                <p className="font-medium mt-1 truncate">{hoaDonGanNhat.maHoaDon}</p>
              </div>
              <div>
                <p className="text-xs text-muted-foreground font-medium uppercase">Tổng tiền</p>
                <p className="font-bold text-blue-700 text-lg mt-1">{formatCurrency(hoaDonGanNhat.tongTien)}</p>
              </div>
              <div className="flex items-center justify-start md:justify-end">
                {hoaDonGanNhat.trangThai === 'daThanhToan' ? (
                  <Badge className="bg-green-600">Đã thanh toán</Badge>
                ) : hoaDonGanNhat.trangThai === 'chuaThanhToan' ? (
                  <Badge variant="outline" className="border-red-500 text-red-600">Chưa thanh toán</Badge>
                ) : hoaDonGanNhat.trangThai === 'quaHan' ? (
                  <Badge variant="destructive">Quá hạn</Badge>
                ) : (
                  <Badge variant="secondary" className="bg-orange-100 text-orange-800">TT một phần</Badge>
                )}
              </div>
            </div>
          </CardContent>
        </Card>
      ) : (
        <Card className="bg-gray-50 border-dashed border-2">
          <CardContent className="flex flex-col items-center justify-center p-8 text-center space-y-4">
            <div className="bg-gray-100 p-4 rounded-full text-gray-400">
              <FileText className="h-10 w-10" />
            </div>
            <div>
              <h3 className="font-bold text-lg text-gray-800">Chưa có hóa đơn nào</h3>
              <p className="text-sm text-gray-500 mt-1">Bạn chưa có hóa đơn nào cần thanh toán.</p>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Thông tin liên hệ */}
      {lienHe ? (
        <Card className="border-blue-100 shadow-sm">
          <CardHeader className="bg-blue-50/50 pb-4 border-b border-blue-50">
            <CardTitle className="text-blue-900 flex items-center gap-2">
              <Phone className="h-5 w-5" />
              Thông tin hỗ trợ
            </CardTitle>
            <CardDescription>
              Liên hệ với ban quản lý khi bạn cần hỗ trợ hoặc báo sự cố
            </CardDescription>
          </CardHeader>
          <CardContent className="pt-6">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="flex items-center gap-4 bg-white border rounded-xl p-4 shadow-sm">
                <div className="bg-blue-100 p-3 rounded-full text-blue-600">
                  <User className="h-6 w-6" />
                </div>
                <div>
                  <p className="text-sm text-gray-500">Quản lý / Chủ trọ</p>
                  <p className="font-bold text-gray-900">{lienHe.hoTen}</p>
                </div>
              </div>
              
              <div className="flex items-center gap-4 bg-white border rounded-xl p-4 shadow-sm hover:border-blue-300 transition-colors cursor-pointer" onClick={() => window.location.href = `tel:${lienHe.soDienThoai}`}>
                <div className="bg-green-100 p-3 rounded-full text-green-600">
                  <Phone className="h-6 w-6" />
                </div>
                <div>
                  <p className="text-sm text-gray-500">Số điện thoại</p>
                  <p className="font-bold text-green-700">{lienHe.soDienThoai}</p>
                </div>
              </div>

              {lienHe.email && (
                <div className="flex items-center gap-4 bg-white border rounded-xl p-4 shadow-sm md:col-span-2">
                  <div className="bg-purple-100 p-3 rounded-full text-purple-600">
                    <Mail className="h-6 w-6" />
                  </div>
                  <div>
                    <p className="text-sm text-gray-500">Email</p>
                    <p className="font-bold text-gray-900">{lienHe.email}</p>
                  </div>
                </div>
              )}
            </div>
            
            <div className="mt-6 flex justify-center">
              <Button asChild className="w-full md:w-auto">
                <Link href="/khach-thue/dashboard/su-co">
                  <AlertCircle className="w-4 h-4 mr-2" />
                  Báo cáo sự cố ngay
                </Link>
              </Button>
            </div>
          </CardContent>
        </Card>
      ) : (
        <Card>
          <CardHeader>
            <CardTitle>Thông tin liên hệ</CardTitle>
            <CardDescription>Vui lòng liên hệ quản lý nếu có thắc mắc</CardDescription>
          </CardHeader>
          <CardContent className="space-y-2">
            <div className="flex items-center gap-2">
              <Phone className="h-4 w-4 text-muted-foreground" />
              <span className="text-sm">Hotline: 1900-xxxx (Chưa cập nhật)</span>
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  );
}

