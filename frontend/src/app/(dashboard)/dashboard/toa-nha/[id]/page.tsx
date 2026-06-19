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
import { Sheet, SheetContent, SheetHeader, SheetTitle } from '@/components/ui/sheet';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Avatar, AvatarFallback } from '@/components/ui/avatar';
import { ScrollArea } from '@/components/ui/scroll-area';
import type { SoDoPhong, SoDoToaNha, TrangThaiPhongHienThi } from '@/types';
import { cn } from '@/lib/utils';
import { PhongForm } from '@/components/ui/phong-form';

const statusConfig: Record<TrangThaiPhongHienThi, { label: string; className: string; badge: string }> = {
  VACANT: {
    label: 'Phòng trống',
    className: 'border-[#4FA7A0]/30 bg-[#4FA7A0]/10 text-[#243B5A] hover:bg-[#4FA7A0]/15',
    badge: 'bg-[#4FA7A0]/15 text-[#267D76] border-[#4FA7A0]/30',
  },
  RENTED: {
    label: 'Đang thuê',
    className: 'border-[#4FA7A0]/30 bg-[#4FA7A0]/10 text-[#243B5A] hover:bg-[#4FA7A0]/15',
    badge: 'bg-[#4FA7A0]/15 text-[#243B5A] border-[#4FA7A0]/30',
  },
  CONTRACT_EXPIRING: {
    label: 'Sắp hết hạn',
    className: 'border-amber-200 bg-amber-50 text-amber-900 hover:bg-amber-100',
    badge: 'bg-amber-100 text-amber-800 border-amber-200',
  },
  MAINTENANCE: {
    label: 'Bảo trì',
    className: 'border-[#E8DED2] bg-slate-100 text-[#243B5A] hover:bg-slate-200',
    badge: 'bg-slate-100 text-[#243B5A] border-[#E8DED2]',
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
                <div className="flex gap-2">
          <Button variant="outline" onClick={fetchSoDo}>
          <RefreshCw className="mr-2 h-4 w-4" />
          Tải mới
        </Button>
          <Button onClick={() => setIsAddRoomOpen(true)}>
            <Plus className="mr-2 h-4 w-4" />
            Thêm phòng
          </Button>
        </div>
      </div>

      <Dialog open={isAddRoomOpen} onOpenChange={setIsAddRoomOpen}>
        <DialogContent className="max-w-5xl max-h-[90vh] overflow-y-auto w-[95vw] md:w-full">
          <DialogHeader>
            <DialogTitle className="text-base md:text-lg">Thêm phòng mới</DialogTitle>
          </DialogHeader>
          {data && (
            <PhongForm
              phong={null}
              toaNhaList={[{ _id: params.id, tenToaNha: data.tenToaNha } as any]}
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
                              } catch (e) {}
                              toast.error(errorMsg);
                            }
                          } catch (error) {
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
