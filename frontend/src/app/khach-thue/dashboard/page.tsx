'use client';

import { useState, useEffect } from 'react';
import { Card, CardContent, CardHeader, CardTitle, CardFooter } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Home, FileText, AlertCircle, Calendar, DollarSign, Phone, Mail, FileWarning, SearchX, User, Wallet, Info } from 'lucide-react';
import { useTenantDashboard } from './context';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { useSession } from 'next-auth/react';
import { TenantContract } from '@/types';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";

export default function KhachThueDashboardPage() {
  const { data: dashboardData, loading, error, refreshData } = useTenantDashboard();
  const session = useSession()?.data;
  const accessToken = session?.accessToken;
  const [activeContracts, setActiveContracts] = useState<TenantContract[]>([]);
  const [fetchingContracts, setFetchingContracts] = useState(false);

  useEffect(() => {
    if (accessToken) {
      const fetchContracts = async () => {
        setFetchingContracts(true);
        try {
          const res = await fetch('/api/tenant/hop-dong', {
            headers: { 'Authorization': `Bearer ${accessToken}` }
          });
          const data = await res.json();
          if (data.success && data.data && data.data.data) {
            const contracts: TenantContract[] = data.data.data;
            setActiveContracts(contracts.filter(c => c.trangThai === 'hoatDong'));
          }
        } catch (error) {
          console.error('Lỗi khi tải hợp đồng:', error);
        } finally {
          setFetchingContracts(false);
        }
      };
      fetchContracts();
    }
  }, [accessToken]);

  if (loading) {
    return (
      <div className="flex items-center justify-center h-[70vh]">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#4FA7A0]"></div>
      </div>
    );
  }

  if (error) {
    return (
      <Card className="mx-auto mt-8 max-w-lg border-red-200 bg-red-50">
        <CardContent className="space-y-4 p-8 text-center">
          <AlertCircle className="h-10 w-10 text-red-500 mx-auto" />
          <p className="text-sm text-red-700 font-medium">{error}</p>
          <Button variant="outline" onClick={() => void refreshData()} className="border-red-200 text-red-700 hover:bg-red-100">
            Thử tải lại
          </Button>
        </CardContent>
      </Card>
    );
  }

  if (!dashboardData) {
    return (
      <div className="flex flex-col items-center justify-center h-[60vh] text-center space-y-3">
        <User className="h-12 w-12 text-gray-300" />
        <p className="text-gray-500 font-medium">Chưa có dữ liệu cư dân.</p>
      </div>
    );
  }

  const { khachThue, hopDongHienTai, soHoaDonChuaThanhToan, soSuCoDangMo, hoaDonGanNhat, lienHe } = dashboardData;

  // Use fetched active contracts if available, otherwise fallback to hopDongHienTai
  let currentActiveContracts = activeContracts;
  if (currentActiveContracts.length === 0 && hopDongHienTai) {
    currentActiveContracts = [hopDongHienTai];
  }
  const activeRooms = currentActiveContracts.map(c => c.phong).filter(Boolean);
  const currentContractToDisplay = currentActiveContracts[0];

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND'
    }).format(amount);
  };

  const formatDate = (date?: string | Date) => {
    if (!date) return '---';
    return new Date(date).toLocaleDateString('vi-VN');
  };

  let mainStatus = { label: 'Đang thuê', type: 'good' };

  if (soHoaDonChuaThanhToan > 0) {
    mainStatus = { label: 'Có nợ cần thanh toán', type: 'warning' };
  } else if (soSuCoDangMo > 0) {
    mainStatus = { label: 'Có sự cố chờ xử lý', type: 'pending' };
  } else if (activeRooms.length > 0) {
    mainStatus = { label: 'Đang thuê', type: 'good' };
  } else {
    mainStatus = { label: 'Chưa có phòng', type: 'neutral' };
  }

  const tenantName = khachThue?.hoTen || session?.user?.name || 'khách thuê';

  const quickActions = [
    { title: 'Tổng quan các phòng', icon: SearchX, href: '/xem-phong', color: 'text-[#267D76]', bg: 'bg-[#4FA7A0]/10', hover: 'hover:border-[#4FA7A0]/30 hover:bg-[#4FA7A0]/5' },
    { title: 'Xem hóa đơn', icon: FileText, href: '/khach-thue/dashboard/hoa-don', color: 'text-blue-600', bg: 'bg-blue-50', hover: 'hover:border-blue-200 hover:bg-blue-50/50' },
    { title: 'Gửi sự cố', icon: AlertCircle, href: '/khach-thue/dashboard/su-co', color: 'text-orange-600', bg: 'bg-orange-50', hover: 'hover:border-orange-200 hover:bg-orange-50/50' },
    { title: 'Xem hợp đồng', icon: FileText, href: '/khach-thue/dashboard/hop-dong', color: 'text-[#4FA7A0]', bg: 'bg-[#4FA7A0]/10', hover: 'hover:border-[#4FA7A0]/30 hover:bg-[#4FA7A0]/5' },
    { title: 'Tài khoản', icon: User, href: '/khach-thue/dashboard/thong-tin', color: 'text-purple-600', bg: 'bg-purple-50', hover: 'hover:border-purple-200 hover:bg-purple-50/50' }
  ];

  const renderRoomCardContent = (roomCount: number, isMultiple: boolean, displayRoom: string) => (
    <Card className="flex flex-col hover:-translate-y-1 hover:shadow-md transition-all duration-300 cursor-pointer border-transparent hover:border-[#4FA7A0]/30 h-full shadow-sm">
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
        <CardTitle className="text-sm font-medium text-gray-500">Phòng</CardTitle>
        <div className="bg-[#4FA7A0]/10 p-2 rounded-lg">
          <Home className="h-4 w-4 text-[#4FA7A0]" />
        </div>
      </CardHeader>
      <CardContent>
        {fetchingContracts && currentActiveContracts.length === 0 ? (
          <div className="h-8 w-24 bg-gray-200 animate-pulse rounded"></div>
        ) : (
          <div className="text-xl md:text-2xl font-bold text-[#243B5A] truncate">
            {displayRoom}
          </div>
        )}
        <p className="text-xs text-gray-500 mt-1">
          {isMultiple ? 'Xem danh sách' : (roomCount === 1 ? 'Phòng đang thuê' : 'Bạn chưa thuê phòng')}
        </p>
      </CardContent>
    </Card>
  );

  const renderRoomCard = () => {
    const roomCount = activeRooms.length;
    const isMultiple = roomCount > 1;
    const displayRoom = isMultiple ? `${roomCount} phòng` : (roomCount === 1 ? (activeRooms[0]?.maPhong || '---') : 'Chưa có phòng');

    if (isMultiple) {
      return (
        <Dialog>
          <DialogTrigger asChild>
            {renderRoomCardContent(roomCount, isMultiple, displayRoom)}
          </DialogTrigger>
          <DialogContent className="sm:max-w-md">
            <DialogHeader>
              <DialogTitle className="font-['Be_Vietnam_Pro'] text-[#243B5A]">Phòng đang thuê</DialogTitle>
              <DialogDescription>
                Danh sách các phòng bạn đang thuê trong hệ thống.
              </DialogDescription>
            </DialogHeader>
            <div className="space-y-4 my-4 max-h-[60vh] overflow-y-auto pr-2">
              {currentActiveContracts.map(contract => (
                <div key={contract.id || contract._id} className="p-4 border border-gray-100 rounded-xl flex flex-col gap-3 hover:bg-gray-50 transition-colors">
                  <div className="flex justify-between items-start">
                    <div className="flex items-center gap-3">
                      <div className="bg-[#4FA7A0]/10 p-2.5 rounded-lg text-[#4FA7A0]">
                        <Home className="h-5 w-5" />
                      </div>
                      <div>
                        <p className="font-bold text-[#243B5A] text-lg leading-tight">{contract.phong?.maPhong || '---'}</p>
                        <p className="text-xs text-gray-500 mt-0.5">{contract.phong?.toaNha?.tenToaNha || '---'}</p>
                      </div>
                    </div>
                    <Badge className="bg-green-600">Đang thuê</Badge>
                  </div>
                  <div className="bg-white p-3 rounded-lg border border-gray-100 grid grid-cols-2 gap-3 text-sm">
                    <div className="flex flex-col">
                      <span className="text-[10px] text-gray-400 uppercase tracking-wider font-semibold mb-0.5">Hợp đồng</span>
                      <span className="font-medium text-gray-700 truncate">{contract.maHopDong}</span>
                    </div>
                    <div className="flex flex-col">
                      <span className="text-[10px] text-gray-400 uppercase tracking-wider font-semibold mb-0.5">Ngày bắt đầu</span>
                      <span className="font-medium text-gray-700">{formatDate(contract.ngayBatDau as string)}</span>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </DialogContent>
        </Dialog>
      );
    }

    return (
      <Link href="/khach-thue/dashboard/hop-dong">
        {renderRoomCardContent(roomCount, isMultiple, displayRoom)}
      </Link>
    );
  };

  return (
    <div className="tenant-dashboard-overview animate-in fade-in duration-500 max-w-7xl mx-auto">
      {/* Welcome Hero */}
      <section className="tenant-dashboard-hero" aria-label="Tổng quan khách thuê">
        <div className="tenant-dashboard-hero__content">
          <div className="tenant-dashboard-hero__main">
            <h1>
              Xin chào, {tenantName} <span aria-hidden="true">👋</span>
            </h1>

            <p>
              Tổng quan phòng thuê, hóa đơn, hợp đồng và thông báo mới nhất của bạn.
            </p>
          </div>
        </div>
      </section>

      {/* KPI Cards */}
      <div className="tenant-dashboard-kpi-grid grid grid-cols-2 lg:grid-cols-4 gap-4 md:gap-6">
        {renderRoomCard()}

        <Card className="flex flex-col hover:-translate-y-1 hover:shadow-md transition-all duration-300 border-transparent hover:border-[#F2A45B]/30 h-full shadow-sm">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-gray-500">Nợ cước</CardTitle>
            <div className={`p-2 rounded-lg ${soHoaDonChuaThanhToan > 0 ? 'bg-red-50' : 'bg-green-50'}`}>
              <Wallet className={`h-4 w-4 ${soHoaDonChuaThanhToan > 0 ? 'text-red-600' : 'text-green-600'}`} />
            </div>
          </CardHeader>
          <CardContent>
            <div className={`text-xl md:text-2xl font-bold truncate ${soHoaDonChuaThanhToan > 0 ? 'text-red-600' : 'text-green-600'}`}>
              {soHoaDonChuaThanhToan > 0 ? `${soHoaDonChuaThanhToan} hóa đơn` : '0 đ'}
            </div>
            <p className="text-xs text-gray-500 mt-1">
              {soHoaDonChuaThanhToan > 0 ? 'Cần thanh toán' : 'Không có khoản nợ'}
            </p>
          </CardContent>
        </Card>

        <Card className="flex flex-col hover:-translate-y-1 hover:shadow-md transition-all duration-300 border-transparent hover:border-[#F2A45B]/30 h-full shadow-sm">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-gray-500">Sự cố chờ</CardTitle>
            <div className="bg-[#F2A45B]/10 p-2 rounded-lg">
              <FileWarning className="h-4 w-4 text-[#F2A45B]" />
            </div>
          </CardHeader>
          <CardContent>
            <div className={`text-xl md:text-2xl font-bold truncate ${soSuCoDangMo > 0 ? 'text-orange-600' : 'text-[#243B5A]'}`}>
              {soSuCoDangMo}
            </div>
            <p className="text-xs text-gray-500 mt-1">Sự cố đang xử lý</p>
          </CardContent>
        </Card>

        <Card className="flex flex-col hover:-translate-y-1 hover:shadow-md transition-all duration-300 border-transparent hover:border-gray-200 h-full shadow-sm">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium text-gray-500">Trạng thái</CardTitle>
            <div className="bg-blue-50 p-2 rounded-lg">
              <AlertCircle className="h-4 w-4 text-blue-500" />
            </div>
          </CardHeader>
          <CardContent>
            <div className="mt-1">
               <Badge className={
                 mainStatus.type === 'warning' ? 'bg-red-500 hover:bg-red-600 text-white' :
                 mainStatus.type === 'pending' ? 'bg-orange-500 hover:bg-orange-600 text-white' :
                 mainStatus.type === 'good' ? 'bg-green-600 hover:bg-green-700 text-white' :
                 'bg-gray-500 hover:bg-gray-600 text-white'
               }>
                 {mainStatus.label}
               </Badge>
            </div>
            <p className="text-xs text-gray-500 mt-2">Trạng thái tổng quan</p>
          </CardContent>
        </Card>
      </div>

      {/* Quick Actions */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {quickActions.map((action, idx) => {
          const Icon = action.icon;
          return (
            <Link href={action.href} key={idx}>
              <Card className={`flex flex-col items-center justify-center p-5 text-center cursor-pointer transition-all duration-300 border border-transparent ${action.hover} shadow-sm hover:shadow-md group h-full bg-white`}>
                <div className={`${action.bg} ${action.color} p-3.5 rounded-2xl mb-3 group-hover:scale-110 transition-transform duration-300`}>
                  <Icon className="h-6 w-6" />
                </div>
                <span className="text-sm font-semibold text-gray-700 group-hover:text-gray-900">{action.title}</span>
              </Card>
            </Link>
          );
        })}
      </div>

      {/* Active Contract & Recent Invoice */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 md:gap-8">
        {/* Contract Section */}
        <div className="flex flex-col gap-4">
          <h2 className="text-lg font-bold font-['Be_Vietnam_Pro'] text-[#243B5A] flex items-center gap-2">
            <FileText className="h-5 w-5 text-[#4FA7A0]"/> Hợp đồng hiện tại
          </h2>
          {currentContractToDisplay ? (
            <Card className="hover:shadow-md transition-shadow border border-gray-100 h-full flex flex-col shadow-sm">
               <CardHeader className="pb-4">
                 <div className="flex justify-between items-start">
                   <Badge variant="outline" className="bg-[#4FA7A0]/5 text-[#243B5A] border-[#4FA7A0]/20 font-semibold px-3 py-1">
                     {currentContractToDisplay.maHopDong}
                   </Badge>
                   <Badge className="bg-green-600">Đang hiệu lực</Badge>
                 </div>
               </CardHeader>
               <CardContent className="flex-1 space-y-5">
                  <div className="flex items-center gap-4">
                     <div className="bg-gray-50 p-3.5 rounded-full border border-gray-100">
                       <Home className="h-6 w-6 text-gray-500" />
                     </div>
                     <div>
                       <p className="text-[11px] text-gray-400 uppercase tracking-widest font-semibold mb-0.5">Phòng</p>
                       <p className="font-bold text-xl text-[#243B5A] leading-none">{currentContractToDisplay.phong?.maPhong || '---'}</p>
                     </div>
                  </div>

                  <div className="grid grid-cols-2 gap-4 bg-gray-50/80 p-4 rounded-xl border border-gray-100">
                     <div>
                        <p className="text-[11px] text-gray-500 uppercase tracking-widest font-semibold flex items-center gap-1.5 mb-1.5"><Calendar className="h-3.5 w-3.5 text-gray-400"/> Bắt đầu</p>
                        <p className="font-medium text-sm text-gray-800">{formatDate(currentContractToDisplay.ngayBatDau as string)}</p>
                     </div>
                     <div>
                        <p className="text-[11px] text-gray-500 uppercase tracking-widest font-semibold flex items-center gap-1.5 mb-1.5"><Calendar className="h-3.5 w-3.5 text-gray-400"/> Kết thúc</p>
                        <p className="font-medium text-sm text-gray-800">{formatDate(currentContractToDisplay.ngayKetThuc as string)}</p>
                     </div>
                  </div>
               </CardContent>
               <CardFooter className="pt-2 pb-5">
                  <Button variant="outline" className="w-full text-[#4FA7A0] border-[#4FA7A0]/20 hover:bg-[#4FA7A0]/5 hover:text-[#3d8580] font-medium transition-colors" asChild>
                     <Link href="/khach-thue/dashboard/hop-dong">Xem chi tiết hợp đồng</Link>
                  </Button>
               </CardFooter>
            </Card>
          ) : (
            <Card className="border-dashed border-2 bg-gray-50/50 h-full flex items-center justify-center min-h-[280px]">
               <CardContent className="flex flex-col items-center justify-center p-6 text-center">
                 <div className="bg-white p-4 rounded-full shadow-sm border border-gray-100 mb-4">
                   <SearchX className="h-8 w-8 text-gray-400" />
                 </div>
                 <h3 className="font-bold text-gray-800 text-lg">Chưa có hợp đồng thuê</h3>
                 <p className="text-sm text-gray-500 mt-2 mb-5 max-w-[260px] leading-relaxed">
                   Khi bạn có hợp đồng đang hiệu lực, thông tin sẽ hiển thị tại đây.
                 </p>
               </CardContent>
            </Card>
          )}
        </div>

        {/* Invoice Section */}
        <div className="flex flex-col gap-4">
          <div className="flex justify-between items-center">
            <h2 className="text-lg font-bold font-['Be_Vietnam_Pro'] text-[#243B5A] flex items-center gap-2">
              <DollarSign className="h-5 w-5 text-orange-500"/> Hóa đơn gần nhất
            </h2>
            {hoaDonGanNhat && (
              <Link href="/khach-thue/dashboard/hoa-don" className="text-sm text-[#4FA7A0] hover:text-[#3d8580] transition-colors font-medium">
                Xem tất cả
              </Link>
            )}
          </div>

          {hoaDonGanNhat ? (
            <Card className={`hover:shadow-md transition-shadow border border-gray-100 h-full flex flex-col shadow-sm ${hoaDonGanNhat.trangThai === 'chuaThanhToan' || hoaDonGanNhat.trangThai === 'quaHan' ? 'border-red-200 shadow-red-50' : ''}`}>
               <CardHeader className="pb-4">
                 <div className="flex justify-between items-start">
                   <div>
                     <p className="text-[11px] text-gray-400 uppercase tracking-widest font-semibold mb-1">Kỳ thanh toán</p>
                     <p className="font-bold text-[#243B5A] text-base">Tháng {hoaDonGanNhat.thang}/{hoaDonGanNhat.nam}</p>
                   </div>
                   {hoaDonGanNhat.trangThai === 'daThanhToan' ? (
                     <Badge className="bg-green-600">Đã thanh toán</Badge>
                   ) : hoaDonGanNhat.trangThai === 'chuaThanhToan' ? (
                     <Badge variant="outline" className="border-red-500 text-red-600 bg-red-50 font-medium">Chưa thanh toán</Badge>
                   ) : hoaDonGanNhat.trangThai === 'quaHan' ? (
                     <Badge variant="destructive">Quá hạn</Badge>
                   ) : (
                     <Badge variant="secondary" className="bg-orange-100 text-orange-800">TT một phần</Badge>
                   )}
                 </div>
               </CardHeader>
               <CardContent className="flex-1 space-y-5">
                  <div className={`p-4 rounded-xl flex items-center justify-between border ${hoaDonGanNhat.trangThai === 'chuaThanhToan' || hoaDonGanNhat.trangThai === 'quaHan' ? 'bg-red-50/50 border-red-100' : 'bg-gray-50/80 border-gray-100'}`}>
                     <div>
                        <p className="text-[11px] text-gray-500 uppercase tracking-widest font-semibold mb-1">Tổng tiền</p>
                        <p className={`font-bold text-2xl leading-none ${hoaDonGanNhat.trangThai === 'chuaThanhToan' || hoaDonGanNhat.trangThai === 'quaHan' ? 'text-red-600' : 'text-[#243B5A]'}`}>
                          {formatCurrency(hoaDonGanNhat.tongTien)}
                        </p>
                     </div>
                     <div className={`p-2.5 rounded-full ${hoaDonGanNhat.trangThai === 'chuaThanhToan' || hoaDonGanNhat.trangThai === 'quaHan' ? 'bg-red-100 text-red-400' : 'bg-white shadow-sm text-gray-300'}`}>
                       <DollarSign className="h-6 w-6" />
                     </div>
                  </div>

                  <div className="grid grid-cols-2 gap-4 text-sm px-1">
                     <div className="flex flex-col gap-1.5">
                        <span className="text-[11px] text-gray-400 uppercase tracking-widest font-semibold">Mã hóa đơn</span>
                        <span className="font-medium text-gray-800">{hoaDonGanNhat.maHoaDon}</span>
                     </div>
                     {hoaDonGanNhat.hanThanhToan && (
                       <div className="flex flex-col gap-1.5">
                          <span className="text-[11px] text-gray-400 uppercase tracking-widest font-semibold">Hạn thanh toán</span>
                          <span className={`font-medium ${hoaDonGanNhat.trangThai === 'quaHan' ? 'text-red-600 font-bold' : 'text-gray-800'}`}>
                            {formatDate(hoaDonGanNhat.hanThanhToan)}
                          </span>
                       </div>
                     )}
                  </div>
               </CardContent>
               <CardFooter className="pt-2 pb-5">
                  <Button
                    variant={hoaDonGanNhat.trangThai === 'chuaThanhToan' || hoaDonGanNhat.trangThai === 'quaHan' ? 'default' : 'outline'}
                    className={`w-full font-medium transition-colors ${hoaDonGanNhat.trangThai === 'chuaThanhToan' || hoaDonGanNhat.trangThai === 'quaHan' ? 'bg-[#4FA7A0] hover:bg-[#3d8580] text-white shadow-sm shadow-[#4FA7A0]/20' : 'text-[#4FA7A0] border-[#4FA7A0]/20 hover:bg-[#4FA7A0]/5'}`}
                    asChild
                  >
                     <Link href={`/khach-thue/dashboard/hoa-don/${hoaDonGanNhat.id || hoaDonGanNhat._id}`}>
                       {hoaDonGanNhat.trangThai === 'chuaThanhToan' || hoaDonGanNhat.trangThai === 'quaHan' ? 'Thanh toán ngay' : 'Xem chi tiết hóa đơn'}
                     </Link>
                  </Button>
               </CardFooter>
            </Card>
          ) : (
            <Card className="border-dashed border-2 bg-gray-50/50 h-full flex items-center justify-center min-h-[280px]">
               <CardContent className="flex flex-col items-center justify-center p-6 text-center">
                 <div className="bg-white p-4 rounded-full shadow-sm border border-gray-100 mb-4">
                   <FileText className="h-8 w-8 text-gray-400" />
                 </div>
                 <h3 className="font-bold text-gray-800 text-lg">Chưa có hóa đơn</h3>
                 <p className="text-sm text-gray-500 mt-2 max-w-[260px] leading-relaxed">
                   Các hóa đơn tiền phòng, điện nước sẽ xuất hiện tại đây khi được tạo.
                 </p>
               </CardContent>
            </Card>
          )}
        </div>
      </div>

      {/* Manager Contact Section */}
      <div className="pt-2">
        <Card className="overflow-hidden border border-gray-100 shadow-sm rounded-2xl">
          <div className="flex flex-col md:flex-row">
            <div className="bg-gradient-to-br from-[#243B5A] to-[#2d4a70] p-6 md:p-8 text-white md:w-5/12 flex flex-col justify-center relative overflow-hidden">
              <div className="relative z-10">
                <h2 className="text-xl font-bold font-['Be_Vietnam_Pro'] mb-3 tracking-tight">Thông tin liên hệ quản lý</h2>
                <p className="text-blue-100 text-sm opacity-90 leading-relaxed max-w-sm">
                  Liên hệ ngay khi bạn cần hỗ trợ về phòng, hóa đơn hoặc hợp đồng thuê. Ban quản lý luôn sẵn sàng hỗ trợ bạn.
                </p>
              </div>
              <Phone className="absolute -right-6 -bottom-6 h-32 w-32 text-white/5 transform -rotate-12" />
            </div>

            <div className="p-6 md:p-8 md:w-7/12 bg-white">
              {lienHe ? (
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 h-full content-center">
                  <div className="flex items-center gap-4 p-3 rounded-xl hover:bg-gray-50 transition-colors border border-transparent hover:border-gray-100">
                    <div className="bg-[#4FA7A0]/10 p-3 rounded-full text-[#4FA7A0] shrink-0">
                      <User className="h-5 w-5" />
                    </div>
                    <div>
                      <p className="text-[11px] text-gray-400 uppercase tracking-widest font-semibold mb-0.5">Quản lý / Chủ trọ</p>
                      <p className="font-bold text-gray-900 text-sm">{lienHe.hoTen}</p>
                    </div>
                  </div>

                  <a href={`tel:${lienHe.soDienThoai}`} className="flex items-center gap-4 p-3 rounded-xl hover:bg-green-50 transition-colors border border-transparent hover:border-green-100 group cursor-pointer">
                    <div className="bg-green-100 p-3 rounded-full text-green-600 shrink-0 group-hover:scale-110 transition-transform duration-300">
                      <Phone className="h-5 w-5" />
                    </div>
                    <div>
                      <p className="text-[11px] text-gray-400 uppercase tracking-widest font-semibold mb-0.5">Hotline hỗ trợ</p>
                      <p className="font-bold text-green-700 text-sm group-hover:text-green-800 transition-colors">{lienHe.soDienThoai}</p>
                    </div>
                  </a>

                  <div className="flex items-center gap-4 p-3 rounded-xl hover:bg-gray-50 transition-colors border border-transparent hover:border-gray-100 sm:col-span-2">
                    <div className="bg-[#F2A45B]/10 p-3 rounded-full text-[#F2A45B] shrink-0">
                      <Mail className="h-5 w-5" />
                    </div>
                    <div className="overflow-hidden">
                      <p className="text-[11px] text-gray-400 uppercase tracking-widest font-semibold mb-0.5">Email</p>
                      <p className="font-bold text-gray-900 text-sm truncate">{lienHe.email || 'Chưa cập nhật email'}</p>
                    </div>
                  </div>
                </div>
              ) : (
                <div className="flex flex-col items-center justify-center h-full text-center py-8 text-gray-500 gap-3">
                  <div className="bg-gray-50 p-4 rounded-full">
                    <Info className="h-6 w-6 text-gray-400" />
                  </div>
                  <p className="text-sm font-medium">Thông tin quản lý chưa được cập nhật.</p>
                </div>
              )}
            </div>
          </div>
        </Card>
      </div>
    </div>
  );
}
