'use client';

import { useCallback, useEffect, useMemo, useState } from 'react';
import type { ReactNode } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { useSession } from 'next-auth/react';
import {
  ArrowLeft,
  Building2,
  CalendarDays,
  DoorOpen,
  FileText,
  Hammer,
  Home,
  RefreshCw,
  Search,
  UserRound,
} from 'lucide-react';

import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Sheet, SheetContent, SheetHeader, SheetTitle } from '@/components/ui/sheet';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import type { SoDoPhong, SoDoToaNha, TrangThaiPhongHienThi } from '@/types';
import { cn } from '@/lib/utils';

const statusConfig: Record<TrangThaiPhongHienThi, { label: string; className: string; badge: string }> = {
  VACANT: {
    label: 'Phòng trống',
    className: 'border-emerald-200 bg-emerald-50 text-emerald-900 hover:bg-emerald-100',
    badge: 'bg-emerald-100 text-emerald-700 border-emerald-200',
  },
  RENTED: {
    label: 'Đang thuê',
    className: 'border-blue-200 bg-blue-50 text-blue-900 hover:bg-blue-100',
    badge: 'bg-blue-100 text-blue-700 border-blue-200',
  },
  CONTRACT_EXPIRING: {
    label: 'Sắp hết hạn',
    className: 'border-amber-200 bg-amber-50 text-amber-900 hover:bg-amber-100',
    badge: 'bg-amber-100 text-amber-800 border-amber-200',
  },
  MAINTENANCE: {
    label: 'Bảo trì',
    className: 'border-slate-200 bg-slate-100 text-slate-700 hover:bg-slate-200',
    badge: 'bg-slate-100 text-slate-700 border-slate-200',
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
      <div className="flex flex-col gap-4 rounded-lg border bg-card p-4 shadow-sm md:flex-row md:items-center md:justify-between md:p-5">
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
        <Button variant="outline" onClick={fetchSoDo}>
          <RefreshCw className="mr-2 h-4 w-4" />
          Tải mới
        </Button>
      </div>

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
          <div className="flex flex-col gap-3 rounded-lg border bg-card p-3 md:flex-row md:items-center md:justify-between">
            <div className="relative w-full md:max-w-sm">
              <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
              <input
                value={roomSearch}
                onChange={(event) => setRoomSearch(event.target.value)}
                placeholder="Tìm phòng, khách thuê, mã hợp đồng..."
                className="h-9 w-full rounded-md border bg-background pl-9 pr-3 text-sm outline-none focus:border-ring focus:ring-2 focus:ring-ring/30"
              />
            </div>
            <div className="flex gap-2 overflow-x-auto pb-1 md:pb-0">
              <Button type="button" variant={statusFilter === 'ALL' ? 'default' : 'outline'} size="sm" onClick={() => setStatusFilter('ALL')}>
                Tất cả
              </Button>
              {(['VACANT', 'RENTED', 'CONTRACT_EXPIRING', 'MAINTENANCE'] as TrangThaiPhongHienThi[]).map((status) => (
                <Button
                  key={status}
                  type="button"
                  variant={statusFilter === status ? 'default' : 'outline'}
                  size="sm"
                  onClick={() => setStatusFilter(status)}
                >
                  {statusConfig[status].label}
                </Button>
              ))}
            </div>
          </div>

          <div className="space-y-3">
            {visibleFloors.map((floor) => (
              <section key={floor.soTang} className="rounded-lg border bg-background p-3">
                <div className="mb-3 flex items-center justify-between">
                  <h2 className="text-sm font-semibold">{floor.tenTang || `Tầng ${floor.soTang}`}</h2>
                  <span className="text-xs text-muted-foreground">{floor.phong.length} phòng</span>
                </div>
                <div className="grid grid-cols-2 gap-2 sm:grid-cols-4 md:grid-cols-6 xl:grid-cols-10">
                  {floor.phong.map((room) => {
                    const config = statusConfig[room.trangThaiHienThi] || statusConfig.VACANT;
                    return (
                      <button
                        key={room._id || room.id}
                        type="button"
                        onClick={() => setSelectedRoom(room)}
                        aria-label={`Xem chi tiết phòng ${room.maPhong} - ${config.label}`}
                        className={cn(
                          'min-h-24 rounded-md border p-2 text-left transition focus:outline-none focus:ring-2 focus:ring-primary',
                          config.className
                        )}
                      >
                        <div className="flex items-center justify-between gap-2">
                          <span className="text-base font-semibold">{room.maPhong}</span>
                          {room.trangThaiHienThi === 'MAINTENANCE' && <Hammer className="h-4 w-4" />}
                        </div>
                        <div className="mt-2 text-xs">{config.label}</div>
                        {room.khachThueHienTai && (
                          <div className="mt-1 truncate text-xs opacity-80">{room.khachThueHienTai}</div>
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
        <SheetContent className="w-full sm:max-w-md">
          {selectedRoom && (
            <>
              <SheetHeader>
                <SheetTitle>Phòng {selectedRoom.maPhong}</SheetTitle>
              </SheetHeader>
              <div className="mt-6 space-y-4 text-sm">
                <Badge variant="outline" className={statusConfig[selectedRoom.trangThaiHienThi].badge}>
                  {statusConfig[selectedRoom.trangThaiHienThi].label}
                </Badge>
                <InfoRow label="Diện tích" value={`${selectedRoom.dienTich || 0} m2`} />
                <InfoRow label="Giá thuê" value={formatCurrency(selectedRoom.giaHienTai)} />
                <InfoRow label="Khách hiện tại" value={selectedRoom.khachThueHienTai || '-'} />
                <InfoRow label="Mã hợp đồng" value={selectedRoom.maHopDong || '-'} />
                <InfoRow label="Ngày bắt đầu" value={formatDate(selectedRoom.ngayBatDau)} />
                <InfoRow label="Ngày kết thúc" value={formatDate(selectedRoom.ngayKetThuc)} />
                <div className="grid grid-cols-2 gap-2 pt-2">
                  <Button variant="outline" disabled={!selectedRoom.hopDongId}>
                    <FileText className="mr-2 h-4 w-4" />
                    Hợp đồng
                  </Button>
                  <Button variant="outline">
                    <CalendarDays className="mr-2 h-4 w-4" />
                    Hóa đơn
                  </Button>
                </div>
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
          <p className={cn('mt-1 text-2xl font-semibold', tone === 'green' && 'text-emerald-600', tone === 'blue' && 'text-blue-600')}>
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
