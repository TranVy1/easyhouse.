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
  ShoppingCart,
  Package,
  Box,
  AlertTriangle,
  ClipboardList,
  Clock,
  DollarSign,
  Anchor,
  ChevronRight,
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
        fetch(selectedToaNhaId !== "all" ? `/api/dashboard/analytics/overview?nhaTroId=${selectedToaNhaId}` : "/api/dashboard/analytics/overview", { headers }),
        fetch(selectedToaNhaId !== "all" ? `/api/dashboard/analytics/revenue-chart?months=12&nhaTroId=${selectedToaNhaId}` : "/api/dashboard/analytics/revenue-chart?months=12", { headers }),
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
      <div className="flex flex-col sm:flex-row items-stretch sm:items-center justify-end mb-4 gap-4">
        <div className="flex flex-col sm:flex-row items-stretch sm:items-center gap-3 w-full sm:w-auto">
          <Popover open={openCombobox} onOpenChange={setOpenCombobox}>
            <PopoverTrigger asChild>
              <Button
                variant="outline"
                role="combobox"
                aria-expanded={openCombobox}
                className="justify-between w-full sm:min-w-[200px] border-gray-300 text-gray-700 font-normal hover:bg-gray-50 focus:ring-2 focus:ring-emerald-500"
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
          <Button asChild className="bg-emerald-600 hover:bg-emerald-700 text-white">
            <Link href="/dashboard/toa-nha">
              <Plus className="w-4 h-4 mr-1" />
              Tòa nhà
            </Link>
          </Button>
        </div>
      </div>

      {/* ── THỐNG KÊ PHÒNG ── */}
      {/* ── THỐNG KÊ PHÒNG ── */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Card 1: Số phòng có thể cho thuê */}
        <Link href="/dashboard/phong?trangThai=trong">
          <Card className="shadow-sm border border-gray-100 rounded-2xl hover:shadow-md transition-shadow cursor-pointer h-full">
            <CardContent className="p-5 flex flex-col gap-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 rounded-full bg-red-500 text-white flex items-center justify-center shrink-0">
                    <ShoppingCart className="w-6 h-6" />
                  </div>
                  <div className="flex items-center gap-3">
                    <span className="text-3xl font-bold text-gray-900">{overview.totalRooms}</span>
                    <span className="text-sm text-orange-500 bg-orange-50 px-2 py-1 rounded-md font-medium">100%</span>
                  </div>
                </div>
                <ChevronRight className="w-5 h-5 text-gray-400" />
              </div>
              <div className="text-[15px] font-medium text-gray-700">
                Số phòng có thể cho thuê
              </div>
            </CardContent>
          </Card>
        </Link>

        {/* Card 2: Số phòng đang trống */}
        <Link href="/dashboard/phong?trangThai=trong">
          <Card className="shadow-sm border border-gray-100 rounded-2xl hover:shadow-md transition-shadow cursor-pointer h-full">
            <CardContent className="p-5 flex flex-col gap-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 rounded-full bg-red-500 text-white flex items-center justify-center shrink-0">
                    <Package className="w-6 h-6" />
                  </div>
                  <div className="flex items-center gap-3">
                    <span className="text-3xl font-bold text-gray-900">{overview.availableRooms}</span>
                    <span className="text-sm text-orange-500 bg-orange-50 px-2 py-1 rounded-md font-medium">
                      {overview.totalRooms > 0 ? Math.round((overview.availableRooms / overview.totalRooms) * 100) : 0}%
                    </span>
                  </div>
                </div>
                <ChevronRight className="w-5 h-5 text-gray-400" />
              </div>
              <div className="text-[15px] font-medium text-gray-700">
                Số phòng đang trống
              </div>
            </CardContent>
          </Card>
        </Link>

        {/* Card 3: Số phòng đang thuê */}
        <Link href="/dashboard/phong?trangThai=dangThue">
          <Card className="shadow-sm border border-gray-100 rounded-2xl hover:shadow-md transition-shadow cursor-pointer h-full">
            <CardContent className="p-5 flex flex-col gap-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 rounded-full bg-blue-600 text-white flex items-center justify-center shrink-0">
                    <Box className="w-6 h-6" />
                  </div>
                  <div className="flex items-center gap-3">
                    <span className="text-3xl font-bold text-gray-900">{overview.occupiedRooms}</span>
                    <span className="text-sm text-emerald-600 bg-emerald-50 px-2 py-1 rounded-md font-medium">
                      {overview.totalRooms > 0 ? Math.round((overview.occupiedRooms / overview.totalRooms) * 100) : 0}%
                    </span>
                  </div>
                </div>
                <ChevronRight className="w-5 h-5 text-gray-400" />
              </div>
              <div className="text-[15px] font-medium text-gray-700">
                Số phòng đang thuê
              </div>
            </CardContent>
          </Card>
        </Link>

        {/* Card 4: Số phòng sắp kết thúc hợp đồng */}
        <Link href="/dashboard/hop-dong?status=SAP_HET_HAN">
          <Card className="shadow-sm border border-gray-100 rounded-2xl hover:shadow-md transition-shadow cursor-pointer h-full">
            <CardContent className="p-5 flex flex-col gap-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 rounded-full bg-amber-500 text-white flex items-center justify-center shrink-0">
                    <AlertTriangle className="w-6 h-6" />
                  </div>
                  <div className="flex items-center gap-3">
                    <span className="text-3xl font-bold text-gray-900">{overview.expiringContractCount}</span>
                    <span className="text-sm text-orange-500 bg-orange-50 px-2 py-1 rounded-md font-medium">
                      {overview.occupiedRooms > 0 ? Math.round((overview.expiringContractCount / overview.occupiedRooms) * 100) : 0}%
                    </span>
                  </div>
                </div>
                <ChevronRight className="w-5 h-5 text-gray-400" />
              </div>
              <div className="text-[15px] font-medium text-gray-700">
                Số phòng sắp kết thúc hợp đồng
              </div>
            </CardContent>
          </Card>
        </Link>

        {/* Card 5: Số phòng báo kết thúc hợp đồng */}
        <Link href="/dashboard/hop-dong?status=DA_CHAM_DUT">
          <Card className="shadow-sm border border-gray-100 rounded-2xl hover:shadow-md transition-shadow cursor-pointer h-full">
            <CardContent className="p-5 flex flex-col gap-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 rounded-full bg-amber-400 text-white flex items-center justify-center shrink-0">
                    <ClipboardList className="w-6 h-6" />
                  </div>
                  <div className="flex items-center gap-3">
                    <span className="text-3xl font-bold text-gray-900">0</span>
                    <span className="text-sm text-orange-500 bg-orange-50 px-2 py-1 rounded-md font-medium">0%</span>
                  </div>
                </div>
                <ChevronRight className="w-5 h-5 text-gray-400" />
              </div>
              <div className="text-[15px] font-medium text-gray-700">
                Số phòng báo kết thúc hợp đồng
              </div>
            </CardContent>
          </Card>
        </Link>

        {/* Card 6: Số phòng quá hạn hợp đồng */}
        <Link href="/dashboard/hop-dong?status=QUA_HAN">
          <Card className="shadow-sm border border-gray-100 rounded-2xl hover:shadow-md transition-shadow cursor-pointer h-full">
            <CardContent className="p-5 flex flex-col gap-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 rounded-full bg-black text-white flex items-center justify-center shrink-0">
                    <Clock className="w-6 h-6" />
                  </div>
                  <div className="flex items-center gap-3">
                    <span className="text-3xl font-bold text-gray-900">0</span>
                    <span className="text-sm text-orange-500 bg-orange-50 px-2 py-1 rounded-md font-medium">0%</span>
                  </div>
                </div>
                <ChevronRight className="w-5 h-5 text-gray-400" />
              </div>
              <div className="text-[15px] font-medium text-gray-700">
                Số phòng quá hạn hợp đồng
              </div>
            </CardContent>
          </Card>
        </Link>

        {/* Card 7: Số phòng đang nợ tiền */}
        <Link href="/dashboard/hoa-don?status=CHUA_THANH_TOAN">
          <Card className="shadow-sm border border-gray-100 rounded-2xl hover:shadow-md transition-shadow cursor-pointer h-full">
            <CardContent className="p-5 flex flex-col gap-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 rounded-full bg-emerald-500 text-white flex items-center justify-center shrink-0">
                    <DollarSign className="w-6 h-6" />
                  </div>
                  <div className="flex items-center gap-3">
                    <span className="text-3xl font-bold text-gray-900">{overview.overdueInvoiceCount}</span>
                    <span className="text-sm text-orange-500 bg-orange-50 px-2 py-1 rounded-md font-medium">
                      {overview.occupiedRooms > 0 ? Math.round((overview.overdueInvoiceCount / overview.occupiedRooms) * 100) : 0}%
                    </span>
                  </div>
                </div>
                <ChevronRight className="w-5 h-5 text-gray-400" />
              </div>
              <div className="text-[15px] font-medium text-gray-700">
                Số phòng đang nợ tiền
              </div>
            </CardContent>
          </Card>
        </Link>

        {/* Card 8: Số phòng đang cọc giữ chỗ */}
        <Link href="/dashboard/phong">
          <Card className="shadow-sm border border-gray-100 rounded-2xl hover:shadow-md transition-shadow cursor-pointer h-full">
            <CardContent className="p-5 flex flex-col gap-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 rounded-full bg-slate-500 text-white flex items-center justify-center shrink-0">
                    <Anchor className="w-6 h-6" />
                  </div>
                  <div className="flex items-center gap-3">
                    <span className="text-3xl font-bold text-gray-900">0</span>
                    <span className="text-sm text-emerald-600 bg-emerald-50 px-2 py-1 rounded-md font-medium">0%</span>
                  </div>
                </div>
                <ChevronRight className="w-5 h-5 text-gray-400" />
              </div>
              <div className="text-[15px] font-medium text-gray-700">
                Số phòng đang cọc giữ chỗ
              </div>
            </CardContent>
          </Card>
        </Link>
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
