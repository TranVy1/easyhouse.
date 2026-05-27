"use client"

import { useCallback, useEffect, useMemo, useState } from "react"
import Link from "next/link"
import { useSession } from "next-auth/react"
import {
  AlertCircle,
  CalendarDays,
  ChevronLeft,
  ChevronRight,
  CircleDollarSign,
  Eye,
  Plus,
  ReceiptText,
  RefreshCw,
  Search,
  Trash2,
} from "lucide-react"
import { toast } from "sonner"

import { DashboardPageHeader, EmptyState, ErrorState, MetricCard } from "@/components/dashboard/dashboard-ui"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import type { ApiResponse, HoaDon, PaginatedResponse, TrangThaiHoaDon } from "@/types"

const currentYear = new Date().getFullYear()
const currency = (amount?: number) =>
  new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(amount || 0)
const invoiceId = (item: HoaDon) => item._id || item.id || ""

function roomLabel(invoice: HoaDon) {
  if (typeof invoice.phong === "object" && invoice.phong !== null) {
    return invoice.phong.ten || invoice.phong.maPhong || "Chưa xác định"
  }
  return "Chưa xác định"
}

function tenantLabel(invoice: HoaDon) {
  return typeof invoice.khachThue === "object" && invoice.khachThue !== null
    ? invoice.khachThue.hoTen || "Chưa xác định"
    : "Chưa xác định"
}

function InvoiceStatus({ status }: { status: TrangThaiHoaDon }) {
  switch (status) {
    case "PAID":
      return <Badge className="border-transparent bg-emerald-100 text-emerald-800">Đã thanh toán</Badge>
    case "PARTIAL":
      return <Badge className="border-transparent bg-amber-100 text-amber-800">Thanh toán một phần</Badge>
    case "OVERDUE":
      return <Badge className="border-transparent bg-red-100 text-red-800">Quá hạn</Badge>
    case "DRAFT":
      return <Badge variant="outline">Nháp</Badge>
    case "CANCELLED":
      return <Badge variant="secondary">Đã hủy</Badge>
    case "OVERPAID":
      return <Badge className="border-transparent bg-blue-100 text-blue-800">Thu dư</Badge>
    default:
      return <Badge className="border-transparent bg-orange-100 text-orange-800">Chưa thanh toán</Badge>
  }
}

function InvoiceSkeleton() {
  return (
    <div className="space-y-6" aria-label="Đang tải hóa đơn">
      <div className="h-20 animate-pulse rounded-xl bg-muted" />
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        {Array.from({ length: 4 }, (_, index) => (
          <div key={index} className="h-32 animate-pulse rounded-xl bg-muted" />
        ))}
      </div>
      <div className="h-[420px] animate-pulse rounded-xl bg-muted" />
    </div>
  )
}

export default function HoaDonPage() {
  const accessToken = useSession()?.data?.accessToken
  const [data, setData] = useState<HoaDon[]>([])
  const [loading, setLoading] = useState(true)
  const [refreshing, setRefreshing] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [searchInput, setSearchInput] = useState("")
  const [search, setSearch] = useState("")
  const [filters, setFilters] = useState({
    trangThai: "all",
    kyThang: "all",
    kyNam: String(currentYear),
  })
  const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 10 })
  const [total, setTotal] = useState(0)
  const [totalPages, setTotalPages] = useState(1)
  const [cancelTarget, setCancelTarget] = useState<HoaDon | null>(null)
  const [cancelling, setCancelling] = useState(false)

  useEffect(() => {
    document.title = "Hóa đơn | EasyHouse"
  }, [])

  useEffect(() => {
    const timeout = window.setTimeout(() => {
      setSearch(searchInput.trim())
      setPagination((current) => ({ ...current, pageIndex: 0 }))
    }, 350)
    return () => window.clearTimeout(timeout)
  }, [searchInput])

  const fetchInvoices = useCallback(
    async (isRefresh = false) => {
      if (isRefresh) {
        setRefreshing(true)
      } else {
        setLoading(true)
      }
      setError(null)
      try {
        const params = new URLSearchParams({
          page: String(pagination.pageIndex + 1),
          limit: String(pagination.pageSize),
        })
        if (search) params.set("search", search)
        if (filters.trangThai !== "all") params.set("trangThai", filters.trangThai)
        if (filters.kyThang !== "all") params.set("kyThang", filters.kyThang)
        if (filters.kyNam !== "all") params.set("kyNam", filters.kyNam)
        const response = await fetch(`/api/hoa-don?${params.toString()}`, {
          headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
        })
        const result: ApiResponse<PaginatedResponse<HoaDon>> = await response.json()
        if (!response.ok || !result.success || !result.data) {
          throw new Error(result.message || "Không thể tải danh sách hóa đơn")
        }
        setData(result.data.data || [])
        setTotal(result.data.total || 0)
        setTotalPages(Math.max(result.data.totalPages || 1, 1))
      } catch (fetchError) {
        setError(fetchError instanceof Error ? fetchError.message : "Không thể tải danh sách hóa đơn")
        setData([])
        setTotal(0)
      } finally {
        setLoading(false)
        setRefreshing(false)
      }
    },
    [accessToken, filters.kyNam, filters.kyThang, filters.trangThai, pagination.pageIndex, pagination.pageSize, search],
  )

  useEffect(() => {
    void fetchInvoices()
  }, [fetchInvoices])

  const metrics = useMemo(() => {
    const outstanding = data.reduce((sum, invoice) => sum + Number(invoice.conLai || 0), 0)
    const collected = data.reduce((sum, invoice) => sum + Number(invoice.daTra ?? invoice.daThanhToan ?? 0), 0)
    const overdue = data.filter((invoice) => invoice.trangThai === "OVERDUE").length
    return { outstanding, collected, overdue }
  }, [data])

  const setFilter = (key: keyof typeof filters, value: string) => {
    setFilters((current) => ({ ...current, [key]: value }))
    setPagination((current) => ({ ...current, pageIndex: 0 }))
  }

  const resetFilters = () => {
    setSearchInput("")
    setSearch("")
    setFilters({ trangThai: "all", kyThang: "all", kyNam: String(currentYear) })
    setPagination((current) => ({ ...current, pageIndex: 0 }))
  }

  const cancelInvoice = async () => {
    if (!cancelTarget) return
    setCancelling(true)
    try {
      const response = await fetch(`/api/hoa-don/${invoiceId(cancelTarget)}`, {
        method: "DELETE",
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      })
      const result: ApiResponse<null> = await response.json()
      if (!response.ok || !result.success) {
        throw new Error(result.message || "Không thể hủy hóa đơn")
      }
      toast.success("Đã hủy hóa đơn và cập nhật các chỉ số liên quan")
      setCancelTarget(null)
      await fetchInvoices(true)
    } catch (cancelError) {
      toast.error(cancelError instanceof Error ? cancelError.message : "Không thể hủy hóa đơn")
    } finally {
      setCancelling(false)
    }
  }

  if (loading) return <InvoiceSkeleton />
  if (error) return <ErrorState title="Không tải được hóa đơn" description={error} onRetry={() => void fetchInvoices()} />

  return (
    <div className="space-y-6">
      <DashboardPageHeader
        eyebrow="Doanh thu"
        title="Hóa đơn"
        description="Lập hóa đơn theo kỳ, theo dõi dư nợ và chuyển nhanh sang ghi nhận thanh toán."
        actions={
          <>
            <Button variant="outline" onClick={() => void fetchInvoices(true)} disabled={refreshing}>
              <RefreshCw className={refreshing ? "animate-spin" : ""} />
              Làm mới
            </Button>
            <Button asChild>
              <Link href="/dashboard/hoa-don/them-moi"><Plus />Lập hóa đơn</Link>
            </Button>
          </>
        }
      />

      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <MetricCard label="Hóa đơn khớp lọc" value={String(total)} hint="Tất cả trang kết quả" icon={ReceiptText} />
        <MetricCard label="Còn phải thu trên trang" value={currency(metrics.outstanding)} hint="KPI phạm vi trang hiện tại" icon={CircleDollarSign} tone="warning" />
        <MetricCard label="Đã thu trên trang" value={currency(metrics.collected)} hint="KPI phạm vi trang hiện tại" icon={CalendarDays} tone="success" />
        <MetricCard label="Quá hạn trên trang" value={String(metrics.overdue)} hint="Cần ưu tiên thu nợ" icon={AlertCircle} tone="danger" />
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Bộ lọc hóa đơn</CardTitle>
          <CardDescription>Tìm kiếm mã hóa đơn, khách thuê, phòng hoặc ghi chú trên toàn bộ dữ liệu.</CardDescription>
        </CardHeader>
        <CardContent className="grid gap-3 md:grid-cols-2 xl:grid-cols-5">
          <div className="relative md:col-span-2">
            <Search className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
            <Input className="pl-9" value={searchInput} onChange={(event) => setSearchInput(event.target.value)} placeholder="Mã hóa đơn, phòng, khách thuê..." />
          </div>
          <Select value={filters.trangThai} onValueChange={(value) => setFilter("trangThai", value)}>
            <SelectTrigger><SelectValue placeholder="Trạng thái" /></SelectTrigger>
            <SelectContent>
              <SelectItem value="all">Mọi trạng thái</SelectItem>
              <SelectItem value="DRAFT">Nháp</SelectItem>
              <SelectItem value="UNPAID">Chưa thanh toán</SelectItem>
              <SelectItem value="PARTIAL">Thanh toán một phần</SelectItem>
              <SelectItem value="OVERDUE">Quá hạn</SelectItem>
              <SelectItem value="PAID">Đã thanh toán</SelectItem>
              <SelectItem value="OVERPAID">Thu dư</SelectItem>
              <SelectItem value="CANCELLED">Đã hủy</SelectItem>
            </SelectContent>
          </Select>
          <Select value={filters.kyThang} onValueChange={(value) => setFilter("kyThang", value)}>
            <SelectTrigger><SelectValue placeholder="Tháng" /></SelectTrigger>
            <SelectContent>
              <SelectItem value="all">Mọi tháng</SelectItem>
              {Array.from({ length: 12 }, (_, index) => (
                <SelectItem key={index + 1} value={String(index + 1)}>Tháng {index + 1}</SelectItem>
              ))}
            </SelectContent>
          </Select>
          <Select value={filters.kyNam} onValueChange={(value) => setFilter("kyNam", value)}>
            <SelectTrigger><SelectValue placeholder="Năm" /></SelectTrigger>
            <SelectContent>
              <SelectItem value="all">Mọi năm</SelectItem>
              {Array.from({ length: 5 }, (_, index) => currentYear - 2 + index).map((year) => (
                <SelectItem key={year} value={String(year)}>{year}</SelectItem>
              ))}
            </SelectContent>
          </Select>
          <Button variant="ghost" className="xl:col-start-5" onClick={resetFilters}>Xóa lọc</Button>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Danh sách hóa đơn</CardTitle>
          <CardDescription>{total} hóa đơn trong kết quả lọc</CardDescription>
        </CardHeader>
        <CardContent>
          {data.length === 0 ? (
            <EmptyState title="Chưa có hóa đơn phù hợp" description="Điều chỉnh bộ lọc hoặc lập hóa đơn mới cho kỳ cần thu." />
          ) : (
            <>
              <div className="hidden overflow-x-auto md:block">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Mã / kỳ</TableHead>
                      <TableHead>Phòng / khách thuê</TableHead>
                      <TableHead>Hạn trả</TableHead>
                      <TableHead>Trạng thái</TableHead>
                      <TableHead className="text-right">Tổng tiền</TableHead>
                      <TableHead className="text-right">Còn lại</TableHead>
                      <TableHead className="text-right">Thao tác</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {data.map((invoice) => {
                      const canCollect = !["PAID", "CANCELLED"].includes(invoice.trangThai)
                      const canCancel = invoice.trangThai !== "CANCELLED"
                      return (
                        <TableRow key={invoiceId(invoice)}>
                          <TableCell>
                            <p className="font-medium">{invoice.maHoaDon}</p>
                            <p className="text-xs text-muted-foreground">Kỳ {invoice.kyThang || invoice.thang}/{invoice.kyNam || invoice.nam}</p>
                          </TableCell>
                          <TableCell>
                            <p>{roomLabel(invoice)}</p>
                            <p className="text-xs text-muted-foreground">{tenantLabel(invoice)}</p>
                          </TableCell>
                          <TableCell>{new Date(String(invoice.hanTra || invoice.hanThanhToan)).toLocaleDateString("vi-VN")}</TableCell>
                          <TableCell><InvoiceStatus status={invoice.trangThai} /></TableCell>
                          <TableCell className="text-right">{currency(invoice.tongTien)}</TableCell>
                          <TableCell className="text-right font-semibold">{currency(invoice.conLai)}</TableCell>
                          <TableCell className="text-right">
                            <Button asChild size="icon-sm" variant="ghost">
                              <Link href={`/dashboard/hoa-don/${invoiceId(invoice)}`}><Eye /><span className="sr-only">Chi tiết</span></Link>
                            </Button>
                            {canCollect && (
                              <Button asChild size="sm" variant="outline">
                                <Link href={`/dashboard/thanh-toan?hoaDonId=${invoiceId(invoice)}`}>Thu tiền</Link>
                              </Button>
                            )}
                            <Button size="icon-sm" variant="ghost" disabled={!canCancel} onClick={() => setCancelTarget(invoice)}>
                              <Trash2 /><span className="sr-only">Hủy hóa đơn</span>
                            </Button>
                          </TableCell>
                        </TableRow>
                      )
                    })}
                  </TableBody>
                </Table>
              </div>

              <div className="space-y-3 md:hidden">
                {data.map((invoice) => {
                  const canCollect = !["PAID", "CANCELLED"].includes(invoice.trangThai)
                  return (
                    <div key={invoiceId(invoice)} className="rounded-xl border p-4">
                      <div className="flex justify-between gap-3">
                        <div>
                          <p className="font-semibold">{invoice.maHoaDon}</p>
                          <p className="text-sm text-muted-foreground">Kỳ {invoice.kyThang || invoice.thang}/{invoice.kyNam || invoice.nam} - {roomLabel(invoice)}</p>
                        </div>
                        <InvoiceStatus status={invoice.trangThai} />
                      </div>
                      <div className="mt-4 grid grid-cols-2 gap-3 text-sm">
                        <div>
                          <p className="text-muted-foreground">Tổng tiền</p>
                          <p className="font-medium">{currency(invoice.tongTien)}</p>
                        </div>
                        <div>
                          <p className="text-muted-foreground">Còn lại</p>
                          <p className="font-semibold">{currency(invoice.conLai)}</p>
                        </div>
                      </div>
                      <div className="mt-4 flex flex-wrap gap-2">
                        <Button asChild size="sm" variant="outline"><Link href={`/dashboard/hoa-don/${invoiceId(invoice)}`}>Chi tiết</Link></Button>
                        {canCollect && <Button asChild size="sm"><Link href={`/dashboard/thanh-toan?hoaDonId=${invoiceId(invoice)}`}>Thu tiền</Link></Button>}
                        <Button size="sm" variant="ghost" disabled={invoice.trangThai === "CANCELLED"} onClick={() => setCancelTarget(invoice)}>Hủy</Button>
                      </div>
                    </div>
                  )
                })}
              </div>

              <div className="mt-6 flex flex-col justify-between gap-3 border-t pt-4 sm:flex-row sm:items-center">
                <Select value={String(pagination.pageSize)} onValueChange={(value) => setPagination({ pageIndex: 0, pageSize: Number(value) })}>
                  <SelectTrigger className="w-32"><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="10">10 / trang</SelectItem>
                    <SelectItem value="20">20 / trang</SelectItem>
                    <SelectItem value="50">50 / trang</SelectItem>
                  </SelectContent>
                </Select>
                <div className="flex items-center gap-3">
                  <span className="text-sm text-muted-foreground">Trang {pagination.pageIndex + 1} / {totalPages}</span>
                  <Button size="icon-sm" variant="outline" disabled={pagination.pageIndex === 0} onClick={() => setPagination((current) => ({ ...current, pageIndex: current.pageIndex - 1 }))}>
                    <ChevronLeft /><span className="sr-only">Trang trước</span>
                  </Button>
                  <Button size="icon-sm" variant="outline" disabled={pagination.pageIndex + 1 >= totalPages} onClick={() => setPagination((current) => ({ ...current, pageIndex: current.pageIndex + 1 }))}>
                    <ChevronRight /><span className="sr-only">Trang sau</span>
                  </Button>
                </div>
              </div>
            </>
          )}
        </CardContent>
      </Card>

      <Dialog open={Boolean(cancelTarget)} onOpenChange={(open) => {
        if (!open) setCancelTarget(null)
      }}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Hủy hóa đơn?</DialogTitle>
            <DialogDescription>
              Hóa đơn {cancelTarget?.maHoaDon || ""} sẽ được hủy và giữ lại cho lịch sử đối soát. Chỉ số đã dùng trong hóa đơn cũng được cập nhật theo nghiệp vụ backend.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setCancelTarget(null)} disabled={cancelling}>Giữ hóa đơn</Button>
            <Button variant="destructive" onClick={() => void cancelInvoice()} disabled={cancelling}>
              {cancelling ? "Đang hủy..." : "Xác nhận hủy"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}
