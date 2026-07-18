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

const statusConfig: Record<TrangThaiPhongHienThi, { label: string; card: string; badge: string; dot: string; iconText: string; statusText: string }> = {
  VACANT: {
    label: 'Phòng trống',
    card: 'border-[#8FD3C7] bg-[#DDF3EF] hover:border-[#2E9C8C] hover:bg-[#C9EAE4]',
    badge: 'border-[#8FD3C7] bg-[#DDF3EF] text-[#2E7D71]',
    dot: 'bg-[#2E9C8C]',
    iconText: 'text-[#2E9C8C]',
    statusText: 'text-[#2E7D71]',
  },
  RENTED: {
    label: 'Đang thuê',
    card: 'border-[#9FB6E3] bg-[#E3EBF8] hover:border-[#2F5B9A] hover:bg-[#D4E0F4]',
    badge: 'border-[#9FB6E3] bg-[#E3EBF8] text-[#274C84]',
    dot: 'bg-[#2F5B9A]',
    iconText: 'text-[#2F5B9A]',
    statusText: 'text-[#274C84]',
  },
  CONTRACT_EXPIRING: {
    label: 'Sắp hết hạn',
    card: 'border-[#F2C97A] bg-[#FDECCF] hover:border-[#C9871A] hover:bg-[#F9DFB3]',
    badge: 'border-[#F2C97A] bg-[#FDECCF] text-[#A86E10]',
    dot: 'bg-[#C9871A]',
    iconText: 'text-[#C9871A]',
    statusText: 'text-[#A86E10]',
  },
  MAINTENANCE: {
    label: 'Bảo trì',
    card: 'border-[#E9A8A8] bg-[#FCE2E2] hover:border-[#C94A4A] hover:bg-[#F6CACA]',
    badge: 'border-[#E9A8A8] bg-[#FCE2E2] text-[#A53A3A]',
    dot: 'bg-[#C94A4A]',
    iconText: 'text-[#C94A4A]',
    statusText: 'text-[#A53A3A]',
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
                          'min-h-[124px] rounded-2xl border p-4 text-left shadow-sm transition-all duration-200 ease-out hover:-translate-y-[2px] hover:shadow-md focus:outline-none focus:ring-4 focus:ring-[#4FA7A0]/20',
                          config.card
                        )}
                      >
                        <div className="flex items-start justify-between gap-2">
                          <span className="truncate text-lg font-bold leading-6 text-[#243B5A]">{room.maPhong}</span>
                          {room.trangThaiHienThi === 'MAINTENANCE' ? (
                            <Hammer className={cn("mt-0.5 h-4 w-4 shrink-0", config.iconText)} />
                          ) : room.trangThaiHienThi === 'RENTED' ? (
                            <UserRound className={cn("mt-0.5 h-4 w-4 shrink-0", config.iconText)} />
                          ) : null}
                        </div>
                        <div className={cn("mt-3 flex items-center gap-2 text-sm font-semibold", config.statusText)}>
                          <span className={cn('h-2.5 w-2.5 rounded-full shadow-sm', config.dot)} />
                          <span>{config.label}</span>
                        </div>
                        {room.khachThueHienTai && (
                          <div className="mt-3 flex items-center gap-1.5 truncate text-xs font-semibold text-[#4B5D75]">
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
          <Card className="overflow-hidden border-[#E8DED2] shadow-sm">
            <CardContent className="p-0 overflow-x-auto">
              <div className="min-w-[800px]">
                <div className="grid grid-cols-[1.2fr_1fr_0.8fr_1fr_1.2fr_0.8fr] items-center border-b border-[#E8DED2] bg-[#F1E8DC] px-5 py-3 text-sm font-semibold text-[#243B5A]">
                  <div>Phòng</div>
                  <div>Giá thuê</div>
                  <div>Diện tích</div>
                  <div>Trạng thái</div>
                  <div>Khách thuê</div>
                  <div className="text-right">Thao tác</div>
                </div>
                <div className="divide-y divide-[#E8DED2]">
                  {rooms.map((room) => (
                    <button
                      key={room._id || room.id}
                      type="button"
                      onClick={() => setSelectedRoom(room)}
                      className="grid w-full grid-cols-[1.2fr_1fr_0.8fr_1fr_1.2fr_0.8fr] items-center px-5 py-4 text-left text-sm transition-colors hover:bg-slate-50 focus:bg-slate-50 focus:outline-none"
                    >
                      <div className="flex items-center gap-2">
                        <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-[#EAF0F8] text-[#243B5A]">
                          <DoorOpen className="h-4 w-4" />
                        </div>
                        <span className="text-base font-bold text-[#243B5A]">{room.maPhong}</span>
                      </div>
                      <div className="font-medium text-emerald-600">{formatCurrency(room.giaHienTai)}</div>
                      <div className="text-muted-foreground">{room.dienTich || 0} m²</div>
                      <div>
                        <Badge variant="outline" className={cn("px-2.5 py-0.5 text-xs font-semibold", statusConfig[room.trangThaiHienThi].badge)}>
                          {statusConfig[room.trangThaiHienThi].label}
                        </Badge>
                      </div>
                      <div className="flex items-center gap-2 pr-2 truncate">
                        {room.khachThueHienTai ? (
                          <>
                            <UserRound className="h-4 w-4 shrink-0 text-muted-foreground" />
                            <span className="truncate font-medium text-[#243B5A]">{room.khachThueHienTai}</span>
                          </>
                        ) : (
                          <span className="text-muted-foreground">-</span>
                        )}
                      </div>
                      <div className="flex justify-end text-sm font-medium text-[#4FA7A0]">
                        <span className="inline-flex h-8 items-center justify-center rounded-md px-3 text-xs font-medium transition-colors hover:bg-[#4FA7A0]/10">
                          Chi tiết
                        </span>
                      </div>
                    </button>
                  ))}
                  {rooms.length === 0 && (
                    <div className="p-8 text-center text-sm text-muted-foreground">
                      Không có phòng nào trong danh sách.
                    </div>
                  )}
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>

      <Dialog open={Boolean(selectedRoom)} onOpenChange={(open) => !open && setSelectedRoom(null)}>
        <DialogContent className="w-[95vw] sm:max-w-[1200px] p-0 overflow-hidden border-0 bg-white rounded-xl shadow-xl flex flex-col max-h-[90vh]">
          {selectedRoom && (
            <>
              {/* Header */}
              <div className="flex items-center justify-between px-6 py-4 border-b shrink-0">
                <DialogTitle className="text-sm font-bold text-[#148356] uppercase tracking-wide">Thông tin căn hộ</DialogTitle>
                {/* The close button is rendered automatically by DialogContent, we don't need to add it again unless it's hidden */}
              </div>
              
              <div className="flex-1 overflow-y-auto min-h-0">
                <div className="p-6 space-y-8">
                  
                  {/* Thông tin chung */}
                  <div>
                    <h3 className="text-sm font-bold text-gray-800 mb-3">Thông tin chung</h3>
                    <div className="border rounded-md overflow-hidden">
                      <table className="w-full text-sm text-left">
                        <tbody className="divide-y divide-gray-200">
                          <tr className="bg-white">
                            <td className="px-4 py-3 font-medium text-gray-700 w-1/3 border-r border-gray-100 bg-gray-50/50">Tên căn hộ</td>
                            <td className="px-4 py-3 text-gray-900 font-medium">{selectedRoom.maPhong}</td>
                          </tr>
                          <tr className="bg-white">
                            <td className="px-4 py-3 font-medium text-gray-700 w-1/3 border-r border-gray-100 bg-gray-50/50">Tòa nhà</td>
                            <td className="px-4 py-3 text-gray-900">{data?.tenToaNha}</td>
                          </tr>
                          <tr className="bg-white">
                            <td className="px-4 py-3 font-medium text-gray-700 w-1/3 border-r border-gray-100 bg-gray-50/50">Tầng</td>
                            <td className="px-4 py-3 text-gray-900">
                              {(() => {
                                const floor = data?.tang.find(f => f.phong.some(p => p.id === selectedRoom.id || p._id === selectedRoom._id));
                                return floor ? (floor.tenTang || `Tầng ${floor.soTang}`) : '—';
                              })()}
                            </td>
                          </tr>
                          <tr className="bg-white">
                            <td className="px-4 py-3 font-medium text-gray-700 w-1/3 border-r border-gray-100 bg-gray-50/50">Giá thuê</td>
                            <td className="px-4 py-3 text-gray-900">{formatCurrency(selectedRoom.giaHienTai)}</td>
                          </tr>
                          <tr className="bg-white">
                            <td className="px-4 py-3 font-medium text-gray-700 w-1/3 border-r border-gray-100 bg-gray-50/50">Đặt cọc</td>
                            <td className="px-4 py-3 text-gray-900">{formatCurrency(selectedRoom.giaHienTai)}</td>
                          </tr>
                          <tr className="bg-white">
                            <td className="px-4 py-3 font-medium text-gray-700 w-1/3 border-r border-gray-100 bg-gray-50/50">Trạng thái hoạt động</td>
                            <td className="px-4 py-3">
                              <label className="relative inline-flex items-center cursor-not-allowed opacity-70">
                                <input type="checkbox" className="sr-only peer" checked disabled />
                                <div className="w-10 h-5 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-gray-500"></div>
                              </label>
                            </td>
                          </tr>
                          <tr className="bg-white">
                            <td className="px-4 py-3 font-medium text-gray-700 w-1/3 border-r border-gray-100 bg-gray-50/50">Trạng thái thuê</td>
                            <td className="px-4 py-3">
                              <Badge variant="outline" className={cn("px-2 py-0.5 text-xs font-semibold rounded bg-[#E4F4EC] text-[#148356] border-[#148356]/20")}>
                                {statusConfig[selectedRoom.trangThaiHienThi].label}
                              </Badge>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </div>

                  {/* Đặt cọc */}
                  <div>
                    <h3 className="text-sm font-bold text-gray-800 mb-3">Đặt cọc</h3>
                    <div className="border rounded-md bg-[#FAFAFA] p-3 text-center text-sm font-medium text-gray-600">
                      Không có dữ liệu
                    </div>
                  </div>

                  {/* Hợp đồng */}
                  <div>
                    <h3 className="text-sm font-bold text-gray-800 mb-3">Hợp đồng</h3>
                    <div className="border rounded-md overflow-hidden overflow-x-auto">
                      <table className="w-full text-sm text-left">
                        <thead className="bg-[#FAFAFA] border-b border-gray-200 text-gray-700">
                          <tr>
                            <th className="px-4 py-3 border-r border-gray-100 font-medium">Số hợp đồng</th>
                            <th className="px-4 py-3 border-r border-gray-100 font-medium">Khách hàng</th>
                            <th className="px-4 py-3 border-r border-gray-100 font-medium">Giá thuê</th>
                            <th className="px-4 py-3 border-r border-gray-100 font-medium">Đặt cọc</th>
                            <th className="px-4 py-3 border-r border-gray-100 font-medium">Ngày bắt đầu</th>
                            <th className="px-4 py-3 font-medium">Ngày hết hạn</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-200">
                          {selectedRoom.hopDongId ? (
                            <tr className="bg-white hover:bg-gray-50/50">
                              <td className="px-4 py-3 border-r border-gray-100 text-gray-900">{selectedRoom.maHopDong}</td>
                              <td className="px-4 py-3 border-r border-gray-100 text-gray-900">{selectedRoom.khachThueHienTai || '—'}</td>
                              <td className="px-4 py-3 border-r border-gray-100 text-gray-900">{formatCurrency(selectedRoom.giaHienTai)}</td>
                              <td className="px-4 py-3 border-r border-gray-100 text-gray-900">{formatCurrency(selectedRoom.giaHienTai)}</td>
                              <td className="px-4 py-3 border-r border-gray-100 text-gray-900">{formatDate(selectedRoom.ngayBatDau)}</td>
                              <td className="px-4 py-3 text-gray-900">{formatDate(selectedRoom.ngayKetThuc)}</td>
                            </tr>
                          ) : (
                            <tr>
                              <td colSpan={6} className="px-4 py-6 text-center text-gray-500 bg-white">Không có hợp đồng</td>
                            </tr>
                          )}
                        </tbody>
                      </table>
                    </div>
                  </div>

                  {/* Khách hàng */}
                  <div>
                    <h3 className="text-sm font-bold text-gray-800 mb-3">Khách hàng</h3>
                    <div className="border rounded-md overflow-hidden overflow-x-auto">
                      <table className="w-full text-sm text-left">
                        <thead className="bg-[#FAFAFA] border-b border-gray-200 text-gray-700">
                          <tr>
                            <th className="px-4 py-3 border-r border-gray-100 font-medium">Tên cư dân</th>
                            <th className="px-4 py-3 border-r border-gray-100 font-medium w-1/4">Số điện thoại</th>
                            <th className="px-4 py-3 border-r border-gray-100 font-medium w-1/4">Email</th>
                            <th className="px-4 py-3 font-medium w-1/4">GTTT</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-200">
                          {selectedRoom.khachThueHienTai ? (
                            <tr className="bg-white hover:bg-gray-50/50">
                              <td className="px-4 py-3 border-r border-gray-100 text-gray-900">{selectedRoom.khachThueHienTai}</td>
                              <td className="px-4 py-3 border-r border-gray-100 text-gray-900">0396822875</td>
                              <td className="px-4 py-3 border-r border-gray-100 text-gray-400">—</td>
                              <td className="px-4 py-3 text-gray-400">—</td>
                            </tr>
                          ) : (
                            <tr>
                              <td colSpan={4} className="px-4 py-6 text-center text-gray-500 bg-white">Chưa có khách thuê</td>
                            </tr>
                          )}
                        </tbody>
                      </table>
                    </div>
                  </div>

                  {/* Tài sản */}
                  <div className="pb-4">
                    <h3 className="text-sm font-bold text-gray-800 mb-3">Tài sản</h3>
                    <div className="border rounded-md overflow-hidden overflow-x-auto">
                      <table className="w-full text-sm text-left">
                        <thead className="bg-[#FAFAFA] border-b border-gray-200 text-gray-700">
                          <tr>
                            <th className="px-4 py-3 border-r border-gray-100 font-medium w-1/4">Mã TS</th>
                            <th className="px-4 py-3 border-r border-gray-100 font-medium w-1/4">Tên TS</th>
                            <th className="px-4 py-3 border-r border-gray-100 font-medium w-1/4">Giá trị</th>
                            <th className="px-4 py-3 font-medium w-1/4">Tình trạng</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-200">
                          <tr className="bg-white hover:bg-gray-50/50">
                            <td className="px-4 py-3 border-r border-gray-100 text-gray-900">TS107786</td>
                            <td className="px-4 py-3 border-r border-gray-100 text-gray-900">Tủ Lạnh</td>
                            <td className="px-4 py-3 border-r border-gray-100 text-gray-900">2,000,000 đ</td>
                            <td className="px-4 py-3 text-gray-900"></td>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </div>

                </div>
              </div>
            </>
          )}
        </DialogContent>
      </Dialog>
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
