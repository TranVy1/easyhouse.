"use client"

import { useCallback, useEffect, useState } from "react"
import Link from "next/link"
import { useSession } from "next-auth/react"
import {
  Building2,
  DoorOpen,
  Bed,
  Percent,
  Star,
  Plus,
  RefreshCw,
  Check,
  ChevronsUpDown,
} from "lucide-react"

import {
  DashboardSkeleton,
  ErrorState,
} from "@/components/dashboard/dashboard-ui"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover"
import { Command, CommandEmpty, CommandGroup, CommandInput, CommandItem, CommandList } from "@/components/ui/command"
import { cn } from "@/lib/utils"

import { RevenueChart } from "@/components/dashboard/RevenueChart"

// Reusing types
type AnalyticsOverview = {
  totalRooms: number;
  occupiedRooms: number;
  availableRooms: number;
  occupancyRate: number;
  expectedRevenueThisMonth: number;
  collectedThisMonth: number;
  outstandingThisMonth: number;
  collectionRate: number;
  overdueInvoiceCount: number;
  openIncidentCount: number;
  expiringContractCount: number;
}

function formatCurrency(amount?: number) {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
    maximumFractionDigits: 0,
  }).format(amount || 0)
}

export default function DashboardPage() {
  const { data: session } = useSession()
  
  const [overview, setOverview] = useState<AnalyticsOverview | null>(null)
  const [revenueData, setRevenueData] = useState<any[]>([])
  const [toaNhas, setToaNhas] = useState<any[]>([])
  const [selectedToaNhaId, setSelectedToaNhaId] = useState<string>("all")
  const [openCombobox, setOpenCombobox] = useState(false)
  
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    document.title = "Bảng tin | EasyHouse"
  }, [])

  const fetchData = useCallback(async () => {
    setLoading(true)
    setError(null)

    try {
      const headers = { Authorization: `Bearer ${session?.accessToken}` }
      
      const parseRes = async (res: Response, name: string) => {
        const text = await res.text();
        if (!res.ok) throw new Error(`Lỗi máy chủ (${name}): ${res.status} ${text.substring(0, 50)}`);
        try {
          return text ? JSON.parse(text) : {};
        } catch (e) {
          throw new Error(`JSON lỗi (${name}): ${text.substring(0, 50)}`);
        }
      };

      const [overviewRes, revRes, toaNhasRes] = await Promise.all([
        fetch(selectedToaNhaId !== "all" ? `/api/dashboard/analytics/overview?toaNhaId=${selectedToaNhaId}` : "/api/dashboard/analytics/overview", { headers }),
        fetch(selectedToaNhaId !== "all" ? `/api/dashboard/analytics/revenue-chart?months=12&toaNhaId=${selectedToaNhaId}` : "/api/dashboard/analytics/revenue-chart?months=12", { headers }),
        fetch("/api/toa-nha?size=100", { headers }),
      ]);

      const oData = await parseRes(overviewRes, "overview");
      const rData = await parseRes(revRes, "revenue");
      const tData = await parseRes(toaNhasRes, "toa-nha");

      if (oData.success) setOverview(oData.data);
      if (rData.success) setRevenueData(rData.data);
      if (tData.success || (tData.data && Array.isArray(tData.data.data))) {
        setToaNhas(Array.isArray(tData.data) ? tData.data : (tData.data?.data || []));
      }
    } catch (requestError) {
      setError(requestError instanceof Error ? requestError.message : "Không thể kết nối máy chủ.")
    } finally {
      setLoading(false)
    }
  }, [session?.accessToken, selectedToaNhaId])

  useEffect(() => {
    if (session?.accessToken) {
      fetchData()
    }
  }, [fetchData, session])

  if (loading) return <DashboardSkeleton />

  if (error || !overview) {
    return (
      <ErrorState
        description={error || "Không có dữ liệu tổng quan để hiển thị."}
        onRetry={fetchData}
      />
    )
  }

  return (
    <div className="space-y-6 min-h-screen pb-10">
      {/* ── HEADER ── */}
      <div className="flex items-center justify-end mb-4">
        <div className="flex items-center gap-3">
          <Popover open={openCombobox} onOpenChange={setOpenCombobox}>
            <PopoverTrigger asChild>
              <Button
                variant="outline"
                role="combobox"
                aria-expanded={openCombobox}
                className="justify-between min-w-[200px] border-gray-300 text-gray-700 font-normal hover:bg-gray-50 focus:ring-2 focus:ring-emerald-500"
              >
                {selectedToaNhaId === "all"
                  ? "Tất cả tòa nhà"
                  : toaNhas.find((t) => t._id === selectedToaNhaId)?.tenToaNha || "Chọn tòa nhà..."}
                <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
              </Button>
            </PopoverTrigger>
            <PopoverContent className="w-[250px] p-0" align="end">
              <Command>
                <CommandInput placeholder="Tìm kiếm tòa nhà..." />
                <CommandList>
                  <CommandEmpty>Không tìm thấy tòa nhà nào.</CommandEmpty>
                  <CommandGroup>
                    <CommandItem
                      key="all"
                      value="all"
                      onSelect={() => {
                        setSelectedToaNhaId("all")
                        setOpenCombobox(false)
                      }}
                    >
                      <Check
                        className={cn(
                          "mr-2 h-4 w-4",
                          selectedToaNhaId === "all" ? "opacity-100" : "opacity-0"
                        )}
                      />
                      Tất cả tòa nhà
                    </CommandItem>
                    {toaNhas.map((toaNha) => (
                      <CommandItem
                        key={toaNha._id}
                        value={toaNha.tenToaNha}
                        onSelect={() => {
                          setSelectedToaNhaId(toaNha._id)
                          setOpenCombobox(false)
                        }}
                      >
                        <Check
                          className={cn(
                            "mr-2 h-4 w-4",
                            selectedToaNhaId === toaNha._id ? "opacity-100" : "opacity-0"
                          )}
                        />
                        {toaNha.tenToaNha}
                      </CommandItem>
                    ))}
                  </CommandGroup>
                </CommandList>
              </Command>
            </PopoverContent>
          </Popover>
          <Button className="bg-emerald-600 hover:bg-emerald-700 text-white">
            <Plus className="w-4 h-4 mr-1" />
            Tòa nhà
          </Button>
        </div>
      </div>

      {/* ── ROW 1: TÒA NHÀ & CĂN HỘ ── */}
      <div className="grid grid-cols-1 md:grid-cols-6 gap-4">
        {/* Tòa nhà */}
        <Card className="col-span-1 shadow-sm border border-gray-100 rounded-xl">
          <CardContent className="p-4 flex flex-col h-full min-h-[120px]">
            <Building2 className="w-5 h-5 text-gray-700 mb-auto" />
            <div>
              <div className="text-3xl font-bold text-gray-900">0</div>
              <div className="text-xs text-gray-500 mt-1">Tòa nhà</div>
            </div>
          </CardContent>
        </Card>

        {/* Căn hộ */}
        <Card className="col-span-1 shadow-sm border border-gray-100 rounded-xl">
          <CardContent className="p-4 flex flex-col h-full min-h-[120px]">
            <DoorOpen className="w-5 h-5 text-gray-700 mb-auto" />
            <div>
              <div className="text-3xl font-bold text-gray-900">{overview.totalRooms}</div>
              <div className="text-xs text-gray-500 mt-1">Căn hộ</div>
            </div>
          </CardContent>
        </Card>

        {/* Căn hộ chi tiết */}
        <Card className="col-span-1 md:col-span-4 shadow-sm border border-gray-100 rounded-xl overflow-hidden">
          <CardContent className="p-0 h-full">
            <div className="grid grid-cols-2 md:grid-cols-4 h-full divide-y md:divide-y-0 md:divide-x divide-gray-100">
              <div className="p-4 flex flex-col justify-center">
                <div className="text-sm font-semibold text-gray-700 mb-2">Căn hộ đang thuê</div>
                <div className="text-3xl font-bold text-emerald-500">{overview.occupiedRooms}</div>
                <div className="text-xs mt-1 text-emerald-500">{(overview.occupancyRate).toFixed(2)} % <span className="text-gray-400">căn hộ</span></div>
              </div>
              <div className="p-4 flex flex-col justify-center">
                <div className="text-sm font-semibold text-gray-700 mb-2">Căn hộ đang cọc</div>
                <div className="text-3xl font-bold text-amber-500">0</div>
                <div className="text-xs mt-1 text-amber-500">0.00 % <span className="text-gray-400">căn hộ</span></div>
              </div>
              <div className="p-4 flex flex-col justify-center">
                <div className="text-sm font-semibold text-gray-700 mb-2">Căn hộ đang trống</div>
                <div className="text-3xl font-bold text-red-500">{overview.availableRooms}</div>
                <div className="text-xs mt-1 text-red-500">{overview.totalRooms > 0 ? ((overview.availableRooms / overview.totalRooms) * 100).toFixed(2) : "0.00"} % <span className="text-gray-400">căn hộ</span></div>
              </div>
              <div className="p-4 flex flex-col justify-center">
                <div className="text-sm font-semibold text-gray-700 mb-2">Căn hộ ngừng hoạt động</div>
                <div className="text-3xl font-bold text-slate-400">0</div>
                <div className="text-xs mt-1 text-slate-400">0.00 % <span className="text-gray-400">căn hộ</span></div>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* ── ROW 2: GIƯỜNG & TỶ LỆ LẤP ĐẦY ── */}
      <div className="grid grid-cols-1 md:grid-cols-6 gap-4">
        {/* Giường */}
        <Card className="col-span-1 shadow-sm border border-gray-100 rounded-xl">
          <CardContent className="p-4 flex flex-col h-full min-h-[120px]">
            <Bed className="w-5 h-5 text-gray-700 mb-auto" />
            <div>
              <div className="text-3xl font-bold text-gray-900">0</div>
              <div className="text-xs text-gray-500 mt-1">giường</div>
            </div>
          </CardContent>
        </Card>

        {/* Tỷ lệ lấp đầy */}
        <Card className="col-span-1 shadow-sm border border-gray-100 rounded-xl">
          <CardContent className="p-4 flex flex-col h-full min-h-[120px]">
            <Percent className="w-5 h-5 text-gray-700 mb-auto" />
            <div>
              <div className="text-3xl font-bold text-gray-900">{overview.occupancyRate.toFixed(0)}%</div>
              <div className="text-xs text-gray-500 mt-1">Tỷ lệ lấp đầy</div>
            </div>
          </CardContent>
        </Card>

        {/* Giường chi tiết */}
        <Card className="col-span-1 md:col-span-4 shadow-sm border border-gray-100 rounded-xl overflow-hidden">
          <CardContent className="p-0 h-full">
            <div className="grid grid-cols-2 md:grid-cols-4 h-full divide-y md:divide-y-0 md:divide-x divide-gray-100">
              <div className="p-4 flex flex-col justify-center">
                <div className="text-sm font-semibold text-gray-700 mb-2">Giường đang thuê</div>
                <div className="text-3xl font-bold text-emerald-500">0</div>
                <div className="text-xs mt-1 text-emerald-500">0.00 % <span className="text-gray-400">giường</span></div>
              </div>
              <div className="p-4 flex flex-col justify-center">
                <div className="text-sm font-semibold text-gray-700 mb-2">Giường đang cọc</div>
                <div className="text-3xl font-bold text-amber-500">0</div>
                <div className="text-xs mt-1 text-amber-500">0.00 % <span className="text-gray-400">giường</span></div>
              </div>
              <div className="p-4 flex flex-col justify-center">
                <div className="text-sm font-semibold text-gray-700 mb-2">Giường đang trống</div>
                <div className="text-3xl font-bold text-red-500">0</div>
                <div className="text-xs mt-1 text-red-500">0.00 % <span className="text-gray-400">giường</span></div>
              </div>
              <div className="p-4 flex flex-col justify-center">
                <div className="text-sm font-semibold text-gray-700 mb-2">Giường ngừng hoạt động</div>
                <div className="text-3xl font-bold text-slate-400">0</div>
                <div className="text-xs mt-1 text-slate-400">0.00 % <span className="text-gray-400">giường</span></div>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* ── ROW 3: KHÁCH HẸN, ĐẶT CỌC, HỢP ĐỒNG ── */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
        {/* Khách hẹn */}
        <Card className="shadow-sm">
          <CardHeader className="p-4 pb-2 flex flex-row items-center justify-between border-b border-gray-50">
            <CardTitle className="text-sm font-semibold text-gray-800">Tổng quan khách hẹn</CardTitle>
            <Link href="#" className="text-xs text-emerald-600 hover:underline">Xem chi tiết</Link>
          </CardHeader>
          <CardContent className="p-4 space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <div className="text-2xl font-bold text-gray-900">0</div>
                <div className="text-xs text-gray-500 mt-1">Khách hẹn mới</div>
              </div>
              <div>
                <div className="text-2xl font-bold text-gray-900">0</div>
                <div className="text-xs text-gray-500 mt-1">Đã ký hợp đồng</div>
              </div>
            </div>
            {/* Progress bar line placeholder */}
            <div className="h-1.5 w-full bg-gray-100 rounded-full overflow-hidden flex">
              <div className="w-1/2 bg-gray-200"></div>
            </div>
            <div className="grid grid-cols-2 gap-4 pt-2">
              <div>
                <div className="text-xs text-gray-500 mb-1">Nguồn khách lớn nhất</div>
                <div className="text-sm font-medium text-gray-900">N/A</div>
              </div>
              <div>
                <div className="text-xs text-gray-500 mb-1">Tỷ lệ chuyển đổi <span className="text-gray-400 ml-1">ⓘ</span></div>
                <div className="text-sm font-medium text-gray-900">0%</div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Đặt cọc */}
        <Card className="shadow-sm">
          <CardHeader className="p-4 pb-2 flex flex-row items-center justify-between border-b border-gray-50">
            <CardTitle className="text-sm font-semibold text-gray-800">Tổng quan đặt cọc</CardTitle>
            <Link href="#" className="text-xs text-emerald-600 hover:underline">Xem chi tiết</Link>
          </CardHeader>
          <CardContent className="p-4 space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <div className="text-2xl font-bold text-gray-900">0</div>
                <div className="text-xs text-gray-500 mt-1">Khách cọc mới</div>
              </div>
              <div>
                <div className="text-2xl font-bold text-gray-900">0</div>
                <div className="text-xs text-gray-500 mt-1">Khách vào thuê</div>
              </div>
            </div>
            <div className="h-1.5 w-full bg-gray-100 rounded-full overflow-hidden flex">
              <div className="w-1/2 bg-gray-200"></div>
            </div>
            <div className="grid grid-cols-2 gap-4 pt-2">
              <div>
                <div className="text-xs text-gray-500 mb-1">Top sale</div>
                <div className="text-sm font-medium text-gray-900">N/A</div>
              </div>
              <div>
                <div className="text-xs text-gray-500 mb-1">Tỷ lệ chuyển đổi <span className="text-gray-400 ml-1">ⓘ</span></div>
                <div className="text-sm font-medium text-gray-900">0%</div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Hợp đồng */}
        <Card className="shadow-sm">
          <CardHeader className="p-4 pb-2 flex flex-row items-center justify-between border-b border-gray-50">
            <CardTitle className="text-sm font-semibold text-gray-800">Tổng quan hợp đồng</CardTitle>
            <Link href="/dashboard/hop-dong" className="text-xs text-emerald-600 hover:underline">Xem chi tiết</Link>
          </CardHeader>
          <CardContent className="p-4 flex flex-col justify-between space-y-4">
            <div className="space-y-2">
              <div className="flex justify-between items-center">
                <span className="text-sm text-emerald-600 font-medium">Ký mới trong tháng</span>
                <span className="text-sm text-emerald-600 font-bold">0</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-sm text-red-500 font-medium">Thanh lý trong tháng</span>
                <span className="text-sm text-red-500 font-bold">0</span>
              </div>
            </div>
            <div className="grid grid-cols-3 gap-2 mt-auto">
              <div className="bg-gray-50 p-2 rounded-md text-center">
                <div className="text-lg font-bold text-emerald-600">{overview.occupiedRooms}</div>
                <div className="text-[10px] text-gray-500 uppercase mt-1">Đang thuê</div>
              </div>
              <div className="bg-gray-50 p-2 rounded-md text-center">
                <div className="text-lg font-bold text-amber-500">0</div>
                <div className="text-[10px] text-gray-500 uppercase mt-1">Sắp chuyển đi</div>
              </div>
              <div className="bg-gray-50 p-2 rounded-md text-center">
                <div className="text-lg font-bold text-indigo-500">{overview.expiringContractCount}</div>
                <div className="text-[10px] text-gray-500 uppercase mt-1">Sắp hết hạn</div>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* ── ROW 4: HÓA ĐƠN & BIỂU ĐỒ ── */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
        {/* Hóa đơn */}
        <Card className="shadow-sm lg:col-span-1">
          <CardHeader className="p-4 pb-2 flex flex-row items-center justify-between border-b border-gray-50">
            <CardTitle className="text-sm font-semibold text-gray-800">Tiền hóa đơn tháng này</CardTitle>
            <Link href="/dashboard/hoa-don" className="text-xs text-emerald-600 hover:underline">Xem chi tiết</Link>
          </CardHeader>
          <CardContent className="p-4 space-y-5">
            <div>
              <div className="text-sm text-gray-500 mb-1">Tất cả</div>
              <div className="flex items-end gap-2">
                <div className="text-3xl font-bold text-gray-900">{formatCurrency(overview.expectedRevenueThisMonth)}</div>
                <span className="text-xs text-red-500 bg-red-50 px-1.5 py-0.5 rounded font-medium mb-1.5">0.00 % tháng trước</span>
              </div>
            </div>
            
            <div className="space-y-2">
              <div className="h-2 w-full bg-gray-100 rounded-full overflow-hidden flex">
                <div className="bg-emerald-500 h-full" style={{ width: `${overview.collectionRate}%` }}></div>
                <div className="bg-red-500 h-full" style={{ width: `${100 - overview.collectionRate}%` }}></div>
              </div>
              <div className="flex items-center gap-4 text-xs text-gray-600">
                <div className="flex items-center gap-1.5">
                  <span className="w-2 h-2 rounded-full bg-emerald-500"></span> Đã thu
                </div>
                <div className="flex items-center gap-1.5">
                  <span className="w-2 h-2 rounded-full bg-red-500"></span> Chưa thu
                </div>
              </div>
            </div>

            <div className="space-y-3 pt-2">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2 text-sm text-gray-600">
                  <div className="w-4 h-4 bg-gray-100 rounded flex items-center justify-center text-[10px]">🏠</div>
                  Tiền nhà
                </div>
                <div className="flex items-center gap-4">
                  <span className="text-sm font-medium">0 đ</span>
                  <span className="text-xs text-gray-400 w-6 text-right">0%</span>
                </div>
              </div>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2 text-sm text-gray-600">
                  <div className="w-4 h-4 bg-gray-100 rounded flex items-center justify-center text-[10px]">💡</div>
                  Tiền điện
                </div>
                <div className="flex items-center gap-4">
                  <span className="text-sm font-medium">0 đ</span>
                  <span className="text-xs text-gray-400 w-6 text-right">0%</span>
                </div>
              </div>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2 text-sm text-gray-600">
                  <div className="w-4 h-4 bg-gray-100 rounded flex items-center justify-center text-[10px]">💧</div>
                  Tiền nước
                </div>
                <div className="flex items-center gap-4">
                  <span className="text-sm font-medium">0 đ</span>
                  <span className="text-xs text-gray-400 w-6 text-right">0%</span>
                </div>
              </div>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2 text-sm text-gray-600">
                  <div className="w-4 h-4 bg-gray-100 rounded flex items-center justify-center text-[10px]">📋</div>
                  Dịch vụ khác
                </div>
                <div className="flex items-center gap-4">
                  <span className="text-sm font-medium">0 đ</span>
                  <span className="text-xs text-gray-400 w-6 text-right">0%</span>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Biểu đồ */}
        <Card className="shadow-sm lg:col-span-2">
          <CardHeader className="p-4 pb-2 border-b border-gray-50 flex flex-row items-center justify-between">
            <CardTitle className="text-sm font-semibold text-gray-800">Biểu đồ thu chi</CardTitle>
            <RefreshCw className="w-4 h-4 text-gray-400 cursor-pointer hover:text-gray-600" onClick={fetchData} />
          </CardHeader>
          <CardContent className="p-4 bg-gray-50/50">
            <RevenueChart data={revenueData} />
          </CardContent>
        </Card>
      </div>

      {/* ── ROW 5: CÔNG VIỆC, ĐÁNH GIÁ, THỐNG KÊ ── */}
      <div className="grid grid-cols-1 lg:grid-cols-4 gap-4">
        {/* Tổng quan công việc */}
        <Card className="shadow-sm">
          <CardHeader className="p-4 pb-2 flex flex-row items-center justify-between border-b border-gray-50">
            <CardTitle className="text-sm font-semibold text-gray-800">Tổng quan công việc</CardTitle>
            <Link href="/dashboard/su-co" className="text-xs text-emerald-600 hover:underline">Xem chi tiết</Link>
          </CardHeader>
          <CardContent className="p-4 space-y-4">
            <div className="space-y-3">
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-600">Phát sinh trong tháng</span>
                <span className="text-sm font-bold">{overview.openIncidentCount}</span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-600">Hoàn thành</span>
                <span className="text-sm font-bold">0</span>
              </div>
            </div>
            <div className="grid grid-cols-3 gap-2 mt-4">
              <div className="bg-gray-50 p-2 rounded-md text-center">
                <div className="text-lg font-bold text-emerald-500">{overview.openIncidentCount}</div>
                <div className="text-[10px] text-gray-500 uppercase mt-1">Chưa làm</div>
              </div>
              <div className="bg-gray-50 p-2 rounded-md text-center">
                <div className="text-lg font-bold text-amber-500">0</div>
                <div className="text-[10px] text-gray-500 uppercase mt-1">Đang làm</div>
              </div>
              <div className="bg-gray-50 p-2 rounded-md text-center">
                <div className="text-lg font-bold text-indigo-500">0</div>
                <div className="text-[10px] text-gray-500 uppercase mt-1">Chờ nghiệm thu</div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Đánh giá khách hàng */}
        <Card className="shadow-sm">
          <CardHeader className="p-4 pb-2 border-b border-gray-50">
            <CardTitle className="text-sm font-semibold text-gray-800">Đánh giá khách hàng</CardTitle>
            <div className="text-xs text-gray-500 mt-1">Dựa trên 0 đánh giá</div>
          </CardHeader>
          <CardContent className="p-4">
            <div className="space-y-2">
              {[5, 4, 3, 2, 1].map((star) => (
                <div key={star} className="flex items-center gap-2 text-sm">
                  <span className="w-3 text-gray-600 font-medium">{star}</span>
                  <div className="flex gap-0.5 text-amber-400">
                    {Array.from({ length: 5 }).map((_, i) => (
                      <Star key={i} className={`w-3 h-3 ${i < star ? "fill-current" : "text-gray-200 fill-gray-200"}`} />
                    ))}
                  </div>
                  <div className="flex-1"></div>
                  <span className="text-gray-400 text-xs">0 (0%)</span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* 4 Thống kê nhỏ */}
        <Card className="shadow-sm lg:col-span-2">
          <CardContent className="p-0 h-full">
            <div className="grid grid-cols-2 h-full divide-x divide-y divide-gray-100">
              <div className="p-4 flex flex-col justify-center border-b">
                <div className="text-sm font-medium text-gray-800 mb-2">Tòa nhà nhiều sự cố nhất</div>
                <div className="text-xs text-emerald-600 mt-auto">0 <span className="text-gray-500">sự cố/công việc</span></div>
              </div>
              <div className="p-4 flex flex-col justify-center border-b border-l">
                <div className="text-sm font-medium text-gray-800 mb-2">Căn hộ nhiều sự cố nhất</div>
                <div className="text-xs text-emerald-600 mt-auto">0 <span className="text-gray-500">sự cố/công việc</span></div>
              </div>
              <div className="p-4 flex flex-col justify-center">
                <div className="text-sm font-medium text-gray-800 mb-2">Loại công việc phát sinh nhiều nhất</div>
                <div className="text-xs text-emerald-600 mt-auto">0 <span className="text-gray-500">sự cố/công việc</span></div>
              </div>
              <div className="p-4 flex flex-col justify-center border-l">
                <div className="text-sm font-medium text-gray-800 mb-2">Nhân viên còn nhiều việc nhất</div>
                <div className="text-xs text-emerald-600 mt-auto">0 <span className="text-gray-500">việc chưa xong</span></div>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

    </div>
  )
}
