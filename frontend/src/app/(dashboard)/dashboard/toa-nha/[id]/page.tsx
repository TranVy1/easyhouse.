'use client';

import { useCallback, useEffect, useMemo, useState } from 'react';
import type { ReactNode } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { useSession } from 'next-auth/react';
import Link from 'next/link';
import {
  ArrowLeft,
  Building2,
  CalendarDays,
  DoorOpen,
  FileText,
  Hammer,
  Home,
  RefreshCw,
  Plus,
  Search,
  UserRound,
  Trash2,
  Maximize,
  Banknote,
  FileSignature,
} from 'lucide-react';

import { toast } from 'sonner';
import { 
  Dialog, 
  DialogTrigger, 
  DialogContent, 
  DialogHeader, 
  DialogTitle, 
  DialogDescription, 
  DialogClose 
} from '@/components/ui/dialog';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Sheet, SheetContent, SheetTitle } from '@/components/ui/sheet';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Avatar, AvatarFallback } from '@/components/ui/avatar';
import { ScrollArea } from '@/components/ui/scroll-area';
import type { SoDoPhong, SoDoToaNha, TrangThaiPhongHienThi } from '@/types';
import { cn } from '@/lib/utils';
import { PhongForm } from '@/components/ui/phong-form';

const statusConfig: Record<TrangThaiPhongHienThi, { label: string; card: string; badge: string; dot: string }> = {
  VACANT: {
    label: 'Phòng trống',
    card: 'border-[#4FA7A0]/35 bg-[#EAF7F4] text-[#243B5A] hover:border-[#4FA7A0]/70 hover:bg-[#DFF2EF]',
    badge: 'border-[#4FA7A0]/35 bg-[#EAF7F4] text-[#267D76]',
    dot: 'bg-[#4FA7A0]',
  },
  RENTED: {
    label: 'Đang thuê',
    card: 'border-[#243B5A]/25 bg-[#EAF0F8] text-[#243B5A] hover:border-[#243B5A]/55 hover:bg-[#DFE9F5]',
    badge: 'border-[#243B5A]/25 bg-[#EAF0F8] text-[#243B5A]',
    dot: 'bg-[#243B5A]',
  },
  CONTRACT_EXPIRING: {
    label: 'Sắp hết hạn',
    card: 'border-[#F2A45B]/45 bg-[#FFF6E8] text-[#7A4A12] hover:border-[#F2A45B]/80 hover:bg-[#FFF0D8]',
    badge: 'border-[#F2A45B]/45 bg-[#FFF6E8] text-[#A15D16]',
    dot: 'bg-[#F2A45B]',
  },
  MAINTENANCE: {
    label: 'Bảo trì',
    card: 'border-[#F2A45B]/35 bg-[#FFF3E6] text-[#7A3E0D] hover:border-[#F2A45B]/70 hover:bg-[#FFEBD6]',
    badge: 'border-[#F2A45B]/35 bg-[#FFF3E6] text-[#B45F14]',
    dot: 'bg-[#F2A45B]',
  },
};

function formatCurrency(value?: number) {
  if (value == null) return '0 đ';
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', maximumFractionDigits: 0 }).format(value);
}

function formatDate(value?: string | Date) {
  if (!value) return '-';
  return new Date(value).toLocaleDateString('vi-VN');
}

export default function ToaNhaDetailPage() {
  const params = useParams<{ id: string }>();
  const router = useRouter();
  const accessToken = useSession()?.data?.accessToken;
  const [data, setData] = useState<SoDoToaNha | null>(null);
  const [loading, setLoading] = useState(true);
  const [selectedRoom, setSelectedRoom] = useState<SoDoPhong | null>(null);
  const [statusFilter, setStatusFilter] = useState<TrangThaiPhongHienThi | 'ALL'>('ALL');
  const [roomSearch, setRoomSearch] = useState('');
  const [isAddRoomOpen, setIsAddRoomOpen] = useState(false);

  const fetchSoDo = useCallback(async () => {
    if (!params.id) return;
    setLoading(true);
    try {
      const response = await fetch(`/api/toa-nha/${params.id}/so-do`, {
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      });
      const result = await response.json();
      if (result.success) {
        setData(result.data);
      }
    } finally {
      setLoading(false);
    }
  }, [accessToken, params.id]);

  useEffect(() => {
    document.title = data?.tenToaNha ? `${data.tenToaNha} - Sơ đồ phòng` : 'Chi tiết tòa nhà';
  }, [data?.tenToaNha]);

  useEffect(() => {
    fetchSoDo();
  }, [fetchSoDo]);

  const rooms = useMemo(() => data?.tang.flatMap((floor) => floor.phong) || [], [data]);
  const visibleFloors = useMemo(() => {
    const keyword = roomSearch.trim().toLowerCase();

    return (data?.tang || [])
      .map((floor) => ({
        ...floor,
        phong: floor.phong.filter((room) => {
          const matchesStatus = statusFilter === 'ALL' || room.trangThaiHienThi === statusFilter;
          const matchesSearch = !keyword
            || room.maPhong?.toLowerCase().includes(keyword)
            || room.khachThueHienTai?.toLowerCase().includes(keyword)
            || room.maHopDong?.toLowerCase().includes(keyword);

          return matchesStatus && matchesSearch;
        }),
      }))
      .filter((floor) => floor.phong.length > 0);
  }, [data?.tang, roomSearch, statusFilter]);
  const occupancyRate = data && data.tongSoPhong > 0 ? Math.round((data.phongDangThue / data.tongSoPhong) * 100) : 0;

  if (loading) {
    return (
      <div className="space-y-4">
        <div className="h-9 w-48 animate-pulse rounded bg-muted" />
        <div className="grid grid-cols-2 gap-3 lg:grid-cols-4">
          {Array.from({ length: 4 }).map((_, index) => (
            <div key={index} className="h-24 animate-pulse rounded-lg bg-muted" />
          ))}
        </div>
        <div className="h-96 animate-pulse rounded-lg bg-muted" />
      </div>
    );
  }

  if (!data) {
    return (
      <div className="space-y-4">
        <Button variant="outline" onClick={() => router.push('/dashboard/toa-nha')}>
          <ArrowLeft className="mr-2 h-4 w-4" />
          Quay lại
        </Button>
        <Card>
          <CardContent className="p-8 text-center text-sm text-muted-foreground">
            Không tải được dữ liệu tòa nhà.
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className="space-y-4 md:space-y-6">
      <div className="flex flex-col gap-4 rounded-xl border border-[#E8DED2] bg-[#FFFCF7] p-4 shadow-sm md:flex-row md:items-center md:justify-between md:p-5">
        <div className="space-y-1">
          <Button variant="ghost" className="h-8 px-0" onClick={() => router.push('/dashboard/toa-nha')}>
            <ArrowLeft className="mr-2 h-4 w-4" />
            Tòa nhà
          </Button>
          <div className="flex items-center gap-2">
            <Building2 className="h-6 w-6 text-primary" />
            <h1 className="text-2xl font-semibold tracking-normal text-foreground">{data.tenToaNha}</h1>
          </div>
          <p className="text-sm text-muted-foreground">
            Sơ đồ vận hành phòng, hợp đồng hiện tại và trạng thái cần xử lý.
          </p>
        </div>
        <div className="mt-2 flex w-full flex-wrap items-center gap-2 sm:w-auto sm:justify-end sm:gap-3 md:mt-0">
          <Button
            variant="outline"
            onClick={fetchSoDo}
            className="h-11 rounded-xl border-[#243B5A]/12 bg-[#FFFCF7] px-5 text-sm font-semibold text-[#243B5A] shadow-sm transition-all duration-200 ease-out hover:-translate-y-[1px] hover:border-[#4FA7A0]/40 hover:bg-white hover:text-[#243B5A] hover:shadow-md active:scale-[0.98] focus-visible:ring-4 focus-visible:ring-[#4FA7A0]/20"
          >
            <RefreshCw className="mr-2 h-4 w-4" />
            Tải mới
          </Button>
          <Button
            onClick={() => setIsAddRoomOpen(true)}
            className="h-11 rounded-xl bg-[#243B5A] px-5 text-sm font-semibold text-white shadow-sm shadow-[#243B5A]/20 transition-all duration-200 ease-out hover:-translate-y-[1px] hover:bg-[#1D314D] hover:shadow-md hover:shadow-[#243B5A]/25 active:scale-[0.98] focus-visible:ring-4 focus-visible:ring-[#4FA7A0]/25"
          >
            <Plus className="mr-2 h-4 w-4" />
            Thêm phòng
          </Button>
        </div>
      </div>

      <Dialog open={isAddRoomOpen} onOpenChange={setIsAddRoomOpen}>
        <DialogContent className="flex max-h-[calc(100vh-40px)] w-[calc(100vw-24px)] max-w-[calc(100vw-24px)] grid-rows-none flex-col gap-0 overflow-hidden rounded-[22px] border border-[#243B5A]/8 bg-[#FFFCF7] p-0 shadow-2xl shadow-[#243B5A]/18 sm:max-w-[calc(100vw-32px)] lg:w-[50vw] lg:min-w-[720px] lg:max-w-[920px] [&_[data-slot=dialog-close]]:right-4 [&_[data-slot=dialog-close]]:top-4 [&_[data-slot=dialog-close]]:flex [&_[data-slot=dialog-close]]:h-8 [&_[data-slot=dialog-close]]:w-8 [&_[data-slot=dialog-close]]:items-center [&_[data-slot=dialog-close]]:justify-center [&_[data-slot=dialog-close]]:rounded-full [&_[data-slot=dialog-close]]:opacity-80 [&_[data-slot=dialog-close]]:transition-all [&_[data-slot=dialog-close]]:duration-200 [&_[data-slot=dialog-close]]:hover:bg-[#4FA7A0]/10 [&_[data-slot=dialog-close]]:hover:text-[#243B5A] [&_[data-slot=dialog-close]]:focus:ring-[3px] [&_[data-slot=dialog-close]]:focus:ring-[#4FA7A0]/20">
          <DialogHeader className="shrink-0 border-b border-[#243B5A]/10 bg-[#FFFCF7]/95 px-5 py-3.5 text-left backdrop-blur lg:px-7">
            <DialogTitle className="pr-9 text-xl font-bold leading-tight text-[#243B5A]">Thêm phòng mới</DialogTitle>
            <DialogDescription className="mt-1 text-sm leading-5 text-[#6B7A8C]">
              Nhập thông tin phòng và cấu hình trạng thái ban đầu.
            </DialogDescription>
          </DialogHeader>
          {data && (
            <PhongForm
              phong={null}
              toaNhaList={[{ _id: params.id, tenToaNha: data.tenToaNha }]}
              onClose={() => setIsAddRoomOpen(false)}
              onSuccess={() => {
                setIsAddRoomOpen(false);
                fetchSoDo();
                toast.success('Thêm phòng thành công!');
              }}
            />
          )}
        </DialogContent>
      </Dialog>

      <div className="grid grid-cols-2 gap-3 lg:grid-cols-5">
        <Metric title="Tầng" value={data.tongSoTang} icon={<Building2 className="h-4 w-4" />} />
        <Metric title="Tổng phòng" value={data.tongSoPhong} icon={<Home className="h-4 w-4" />} />
        <Metric title="Phòng trống" value={data.phongTrong} tone="green" icon={<DoorOpen className="h-4 w-4" />} />
        <Metric title="Đang thuê" value={data.phongDangThue} tone="blue" icon={<UserRound className="h-4 w-4" />} />
        <Metric title="Lấp đầy" value={`${occupancyRate}%`} icon={<FileText className="h-4 w-4" />} />
      </div>

      <Tabs defaultValue="map" className="space-y-4">
        <TabsList>
          <TabsTrigger value="overview">Tổng quan</TabsTrigger>
          <TabsTrigger value="map">Sơ đồ phòng</TabsTrigger>
          <TabsTrigger value="rooms">Danh sách phòng</TabsTrigger>
        </TabsList>

        <TabsContent value="overview" className="space-y-4">
          <div className="grid gap-4 lg:grid-cols-3">
            <Card>
              <CardHeader>
                <CardTitle className="text-base">Vận hành</CardTitle>
              </CardHeader>
              <CardContent className="space-y-3 text-sm">
                <InfoRow label="Phòng bảo trì" value={data.phongBaoTri} />
                <InfoRow label="Hợp đồng sắp hết hạn" value={data.hopDongSapHetHan} />
                <InfoRow label="Doanh thu dự kiến" value={formatCurrency(data.doanhThuDuKienThang)} />
              </CardContent>
            </Card>
            <Card className="lg:col-span-2">
              <CardHeader>
                <CardTitle className="text-base">Trạng thái phòng</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-2 gap-3 md:grid-cols-4">
                  {(['VACANT', 'RENTED', 'CONTRACT_EXPIRING', 'MAINTENANCE'] as TrangThaiPhongHienThi[]).map((status) => (
                    <div key={status} className="rounded-lg border p-3">
                      <Badge variant="outline" className={statusConfig[status].badge}>
                        {statusConfig[status].label}
                      </Badge>
                      <div className="mt-3 text-2xl font-semibold">
                        {rooms.filter((room) => room.trangThaiHienThi === status).length}
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </div>
        </TabsContent>

        <TabsContent value="map" className="space-y-4">
          <div className="rounded-xl border border-[#E8DED2] bg-[#FFFCF7] p-3 shadow-sm">
            <div className="mb-3 flex flex-wrap items-center gap-3">
              {(['VACANT', 'RENTED', 'CONTRACT_EXPIRING', 'MAINTENANCE'] as TrangThaiPhongHienThi[]).map((status) => (
                <div key={status} className="flex items-center gap-2 text-xs font-medium text-[#64748B]">
                  <span className={cn('h-2.5 w-2.5 rounded-full ring-2 ring-white', statusConfig[status].dot)} />
                  <span>{statusConfig[status].label}</span>
                </div>
              ))}
            </div>
            <div className="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
            <div className="relative w-full md:max-w-sm">
              <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
              <input
                value={roomSearch}
                onChange={(event) => setRoomSearch(event.target.value)}
                placeholder="Tìm phòng, khách thuê, mã hợp đồng..."
                className="h-11 w-full rounded-xl border border-[#E2D8CC] bg-white pl-9 pr-3 text-sm font-medium text-[#243B5A] outline-none transition-all placeholder:text-slate-400 focus:border-[#4FA7A0] focus:ring-4 focus:ring-[#4FA7A0]/15"
              />
            </div>
            <div className="flex gap-2 overflow-x-auto pb-1 md:pb-0">
              <Button
                type="button"
                variant="outline"
                size="sm"
                onClick={() => setStatusFilter('ALL')}
                className={cn(
                  'h-10 shrink-0 rounded-xl border-[#E2D8CC] px-4 font-semibold transition-all hover:-translate-y-[1px] hover:shadow-sm',
                  statusFilter === 'ALL'
                    ? 'border-[#243B5A] bg-[#243B5A] text-white hover:bg-[#1D314D] hover:text-white'
                    : 'bg-white text-[#243B5A] hover:border-[#4FA7A0]/50 hover:bg-[#F8F3EC]'
                )}
              >
                Tất cả
              </Button>
              {(['VACANT', 'RENTED', 'CONTRACT_EXPIRING', 'MAINTENANCE'] as TrangThaiPhongHienThi[]).map((status) => (
                <Button
                  key={status}
                  type="button"
                  variant="outline"
                  size="sm"
                  onClick={() => setStatusFilter(status)}
                  className={cn(
                    'h-10 shrink-0 rounded-xl border-[#E2D8CC] px-4 font-semibold transition-all hover:-translate-y-[1px] hover:shadow-sm',
                    statusFilter === status
                      ? 'border-[#4FA7A0] bg-[#4FA7A0] text-white hover:bg-[#438F89] hover:text-white'
                      : 'bg-white text-[#243B5A] hover:border-[#4FA7A0]/50 hover:bg-[#F8F3EC]'
                  )}
                >
                  {statusConfig[status].label}
                </Button>
              ))}
            </div>
            </div>
          </div>

          <div className="space-y-4">
            {visibleFloors.map((floor) => (
              <section key={floor.soTang} className="rounded-xl border border-[#E8DED2] bg-[#FFFCF7] p-4 shadow-sm">
                <div className="mb-4 flex items-center justify-between gap-3">
                  <h2 className="text-sm font-bold text-[#243B5A]">{floor.tenTang || `Tầng ${floor.soTang}`}</h2>
                  <span className="rounded-full border border-[#E8DED2] bg-white px-3 py-1 text-xs font-semibold text-[#64748B]">{floor.phong.length} phòng</span>
                </div>
                <div className="grid grid-cols-1 gap-3 min-[420px]:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 2xl:grid-cols-6">
                  {floor.phong.map((room) => {
                    const config = statusConfig[room.trangThaiHienThi] || statusConfig.VACANT;
                    return (
                      <button
                        key={room._id || room.id}
                        type="button"
                        onClick={() => setSelectedRoom(room)}
                        aria-label={`Xem chi tiết phòng ${room.maPhong} - ${config.label}`}
                        className={cn(
                          'min-h-[124px] rounded-xl border p-3 text-left shadow-sm transition-all duration-200 ease-out hover:-translate-y-[2px] hover:shadow-md focus:outline-none focus:ring-4 focus:ring-[#4FA7A0]/20',
                          config.card
                        )}
                      >
                        <div className="flex items-start justify-between gap-2">
                          <span className="truncate text-lg font-bold leading-6">{room.maPhong}</span>
                          {room.trangThaiHienThi === 'MAINTENANCE' ? (
                            <Hammer className="mt-0.5 h-4 w-4 shrink-0" />
                          ) : room.trangThaiHienThi === 'RENTED' ? (
                            <UserRound className="mt-0.5 h-4 w-4 shrink-0" />
                          ) : null}
                        </div>
                        <div className="mt-3 flex items-center gap-2 text-xs font-semibold">
                          <span className={cn('h-2 w-2 rounded-full', config.dot)} />
                          <span>{config.label}</span>
                        </div>
                        {room.khachThueHienTai && (
                          <div className="mt-3 flex items-center gap-1.5 truncate text-xs font-medium opacity-80">
                            <UserRound className="h-3.5 w-3.5 shrink-0" />
                            <span className="truncate">{room.khachThueHienTai}</span>
                          </div>
                        )}
                      </button>
                    );
                  })}
                </div>
              </section>
            ))}
            {visibleFloors.length === 0 && (
              <Card>
                <CardContent className="p-8 text-center text-sm text-muted-foreground">
                  Không có phòng phù hợp với bộ lọc hiện tại.
                </CardContent>
              </Card>
            )}
          </div>
        </TabsContent>

        <TabsContent value="rooms">
          <Card>
            <CardContent className="p-0">
              <div className="divide-y">
                {rooms.map((room) => (
                  <button
                    key={room._id || room.id}
                    type="button"
                    onClick={() => setSelectedRoom(room)}
                    className="grid w-full grid-cols-2 gap-3 p-4 text-left hover:bg-muted/50 md:grid-cols-5"
                  >
                    <div className="font-medium">{room.maPhong}</div>
                    <div>{formatCurrency(room.giaHienTai)}</div>
                    <div>{room.dienTich || 0} m2</div>
                    <div>
                      <Badge variant="outline" className={statusConfig[room.trangThaiHienThi].badge}>
                        {statusConfig[room.trangThaiHienThi].label}
                      </Badge>
                    </div>
                    <div className="truncate text-sm text-muted-foreground">{room.khachThueHienTai || '-'}</div>
                  </button>
                ))}
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>

      <Sheet open={Boolean(selectedRoom)} onOpenChange={(open) => !open && setSelectedRoom(null)}>
        <SheetContent 
          aria-describedby={undefined}
          className="flex flex-col h-full w-full sm:max-w-md p-0 overflow-hidden border-l"
          onInteractOutside={(e) => {
            const target = e.target as Element | null;
            if (target?.closest('[data-radix-popper-content-wrapper]') || target?.closest('[role="dialog"]')) {
              e.preventDefault();
            }
          }}
        >
          {selectedRoom && (
            <>
              <div className="bg-muted/30 border-b p-6 pt-10">
                <div className="flex items-start justify-between">
                  <div>
                    <div className="flex items-center gap-2 text-sm font-medium text-muted-foreground mb-1">
                      <DoorOpen className="h-4 w-4" />
                      Chi tiết phòng
                    </div>
                    <SheetTitle className="text-3xl font-bold tracking-tight">Phòng {selectedRoom.maPhong}</SheetTitle>
                  </div>
                  <Badge variant="outline" className={cn("px-3 py-1 text-xs uppercase tracking-wider font-semibold", statusConfig[selectedRoom.trangThaiHienThi].badge)}>
                    {statusConfig[selectedRoom.trangThaiHienThi].label}
                  </Badge>
                </div>
              </div>

              <ScrollArea className="flex-1 p-6">
                <div className="space-y-6 pb-6">
                  {/* Thông tin cơ bản */}
                  <div className="grid grid-cols-2 gap-4">
                    <Card className="shadow-none border-muted/60 bg-muted/20">
                      <CardContent className="p-4 flex flex-col items-center justify-center text-center space-y-1">
                        <div className="p-2 bg-background rounded-full shadow-sm mb-1">
                          <Maximize className="h-4 w-4 text-muted-foreground" />
                        </div>
                        <p className="text-xs text-muted-foreground font-medium uppercase tracking-wider">Diện tích</p>
                        <p className="text-base font-semibold">{selectedRoom.dienTich || 0} m²</p>
                      </CardContent>
                    </Card>
                    <Card className="shadow-none border-blue-100 bg-blue-50/50">
                      <CardContent className="p-4 flex flex-col items-center justify-center text-center space-y-1">
                        <div className="p-2 bg-white rounded-full shadow-sm mb-1">
                          <Banknote className="h-4 w-4 text-blue-600" />
                        </div>
                        <p className="text-xs text-blue-600/80 font-medium uppercase tracking-wider">Giá thuê</p>
                        <p className="text-base font-semibold text-blue-700">{formatCurrency(selectedRoom.giaHienTai)}</p>
                      </CardContent>
                    </Card>
                  </div>

                  {/* Thông tin thuê */}
                  <div className="space-y-3">
                    <h4 className="text-sm font-semibold text-foreground flex items-center gap-2">
                      <UserRound className="h-4 w-4 text-primary" />
                      Thông tin khách thuê
                    </h4>
                    <div className="rounded-xl border bg-card overflow-hidden">
                      <div className="p-4 flex items-center gap-4 border-b">
                        <Avatar className="h-10 w-10 border bg-muted">
                          <AvatarFallback className="bg-primary/10 text-primary font-semibold">
                            {selectedRoom.khachThueHienTai ? selectedRoom.khachThueHienTai.charAt(0).toUpperCase() : '?'}
                          </AvatarFallback>
                        </Avatar>
                        <div>
                          <p className="text-sm font-medium">{selectedRoom.khachThueHienTai || 'Chưa có người thuê'}</p>
                          {selectedRoom.maHopDong && (
                            <p className="text-xs text-muted-foreground flex items-center mt-0.5">
                              <FileSignature className="h-3 w-3 mr-1" />
                              Hợp đồng: {selectedRoom.maHopDong}
                            </p>
                          )}
                        </div>
                      </div>
                      {selectedRoom.hopDongId && (
                        <div className="bg-muted/20 p-3 px-4 grid grid-cols-2 gap-4 text-sm">
                          <div>
                            <p className="text-xs text-muted-foreground mb-0.5">Ngày bắt đầu</p>
                            <p className="font-medium">{formatDate(selectedRoom.ngayBatDau)}</p>
                          </div>
                          <div>
                            <p className="text-xs text-muted-foreground mb-0.5">Ngày kết thúc</p>
                            <p className="font-medium">{formatDate(selectedRoom.ngayKetThuc)}</p>
                          </div>
                        </div>
                      )}
                    </div>
                  </div>

                  {/* Hành động nhanh */}
                  <div className="space-y-3">
                    <h4 className="text-sm font-semibold text-foreground">Hành động nhanh</h4>
                    <div className="grid grid-cols-2 gap-2">
                      {selectedRoom.hopDongId ? (
                        <Button variant="outline" className="h-12 justify-start px-4 shadow-sm hover:border-primary/50 hover:bg-primary/5 transition-all" asChild>
                          <Link href={`/dashboard/hop-dong/${selectedRoom.hopDongId}`}>
                            <div className="p-1.5 bg-muted rounded-md mr-3">
                              <FileText className="h-4 w-4 text-foreground" />
                            </div>
                            <span className="font-medium">Hợp đồng</span>
                          </Link>
                        </Button>
                      ) : (
                        <Button variant="outline" className="h-12 justify-start px-4 shadow-sm opacity-50 cursor-not-allowed" disabled>
                          <div className="p-1.5 bg-muted rounded-md mr-3">
                            <FileText className="h-4 w-4 text-foreground" />
                          </div>
                          <span className="font-medium">Hợp đồng</span>
                        </Button>
                      )}
                      <Button variant="outline" className="h-12 justify-start px-4 shadow-sm hover:border-primary/50 hover:bg-primary/5 transition-all" asChild>
                        <Link href={`/dashboard/hoa-don?search=${selectedRoom.maPhong}`}>
                          <div className="p-1.5 bg-muted rounded-md mr-3">
                            <CalendarDays className="h-4 w-4 text-foreground" />
                          </div>
                          <span className="font-medium">Hóa đơn</span>
                        </Link>
                      </Button>
                    </div>
                  </div>
                </div>
              </ScrollArea>

              <div className="p-4 border-t bg-muted/10 mt-auto">
                <Dialog>
                  <DialogTrigger asChild>
                    <Button variant="ghost" className="w-full text-red-600 hover:text-red-700 hover:bg-red-50">
                      <Trash2 className="mr-2 h-4 w-4" />
                      Xóa phòng này
                    </Button>
                  </DialogTrigger>
                  <DialogContent>
                    <DialogHeader>
                      <DialogTitle>Xóa phòng</DialogTitle>
                      <DialogDescription>
                        Bạn có chắc chắn muốn xóa phòng {selectedRoom.maPhong}? Thao tác này không thể hoàn tác.
                      </DialogDescription>
                    </DialogHeader>
                    <div className="flex justify-end gap-2 mt-4">
                      <DialogClose asChild>
                        <Button variant="outline">Hủy</Button>
                      </DialogClose>
                      <DialogClose asChild>
                        <Button variant="destructive" onClick={async () => {
                          const roomId = selectedRoom._id || selectedRoom.id;
                          if (!roomId) {
                            toast.error('Không tìm thấy mã định danh của phòng để xóa');
                            return;
                          }
                          try {
                            const res = await fetch(`/api/phong/${roomId}`, {
                              method: 'DELETE',
                              headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
                            });
                            if (res.ok) {
                              const result = await res.json();
                              if (result.success) {
                                toast.success('Đã xóa phòng thành công');
                                fetchSoDo();
                                setTimeout(() => setSelectedRoom(null), 100);
                              } else {
                                toast.error(result.message || 'Có lỗi xảy ra khi xóa phòng');
                              }
                            } else {
                              let errorMsg = 'Có lỗi xảy ra khi xóa phòng (HTTP ' + res.status + ')';
                              try {
                                const errData = await res.json();
                                errorMsg = errData.message || errorMsg;
                              } catch {}
                              toast.error(errorMsg);
                            }
                          } catch {
                            toast.error('Không thể kết nối đến máy chủ để xóa phòng');
                          }
                        }}>
                          Xóa
                        </Button>
                      </DialogClose>
                    </div>
                  </DialogContent>
                </Dialog>
              </div>
            </>
          )}
        </SheetContent>
      </Sheet>
    </div>
  );
}

function Metric({
  title,
  value,
  icon,
  tone,
}: {
  title: string;
  value: number | string;
  icon: ReactNode;
  tone?: 'green' | 'blue';
}) {
  return (
    <Card>
      <CardContent className="flex items-center justify-between p-4">
        <div>
          <p className="text-xs text-muted-foreground">{title}</p>
          <p className={cn('mt-1 text-2xl font-semibold', tone === 'green' && 'text-[#267D76]', tone === 'blue' && 'text-[#243B5A]')}>
            {value}
          </p>
        </div>
        <div className="rounded-md border bg-muted p-2 text-muted-foreground">{icon}</div>
      </CardContent>
    </Card>
  );
}

function InfoRow({ label, value }: { label: string; value: ReactNode }) {
  return (
    <div className="flex items-center justify-between gap-4">
      <span className="text-muted-foreground">{label}</span>
      <span className="text-right font-medium">{value}</span>
    </div>
  );
}
