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

import { EmptyState, ErrorState } from "@/components/dashboard/dashboard-ui"
import { DashboardHero, DashboardKpiCard, DashboardCard, HeroActionButton } from "@/components/dashboard/shared-ui"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Checkbox } from "@/components/ui/checkbox"
import { Label } from "@/components/ui/label"
import { ScrollArea } from "@/components/ui/scroll-area"
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
      return <Badge className="border-transparent bg-[#4FA7A0]/15 text-[#267D76]">Đã thanh toán</Badge>
    case "PARTIAL":
      return <Badge className="border-transparent bg-amber-100 text-amber-800">Thanh toán một phần</Badge>
    case "OVERDUE":
      return <Badge className="border-transparent bg-red-100 text-red-800">Quá hạn</Badge>
    case "DRAFT":
      return <Badge variant="outline">Nháp</Badge>
    case "CANCELLED":
      return <Badge variant="secondary">Đã hủy</Badge>
    case "OVERPAID":
      return <Badge className="border-transparent bg-[#4FA7A0]/15 text-[#243B5A]">Thu dư</Badge>
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
  const [isGenerateOpen, setIsGenerateOpen] = useState(false)
  const [toaNhas, setToaNhas] = useState<any[]>([])
  const [fetchingToaNhas, setFetchingToaNhas] = useState(false)
  const [genForm, setGenForm] = useState({
    nhaTroId: "all",
    kyThang: String(new Date().getMonth() + 1),
    kyNam: String(new Date().getFullYear()),
    requireConfirmedReadings: false,
    sendNotification: false,
  })
  const [previewLoading, setPreviewLoading] = useState(false)
  const [previewData, setPreviewData] = useState<any>(null)
  const [previewError, setPreviewError] = useState<string | null>(null)
  const [generating, setGenerating] = useState(false)
  const [genResult, setGenResult] = useState<any>(null)

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
    if (typeof window !== "undefined") {
      const params = new URLSearchParams(window.location.search)
      const searchParam = params.get("search")
      if (searchParam) {
        setSearchInput(searchParam)
      }
    }
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

  const fetchToaNhas = useCallback(async () => {
    setFetchingToaNhas(true)
    try {
      const response = await fetch('/api/toa-nha?page=1&limit=100', {
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      })
      const result = await response.json()
      if (response.ok && result.success && result.data) {
        setToaNhas(result.data.data || [])
      }
    } catch (err) {
      console.error("Lỗi khi tải danh sách tòa nhà:", err)
    } finally {
      setFetchingToaNhas(false)
    }
  }, [accessToken])

  const handlePreview = async () => {
    setPreviewLoading(true)
    setPreviewError(null)
    setGenResult(null)
    try {
      const params = new URLSearchParams({
        kyThang: genForm.kyThang,
        kyNam: genForm.kyNam,
        requireConfirmedReadings: String(genForm.requireConfirmedReadings),
      })
      if (genForm.nhaTroId !== "all") {
        params.set("nhaTroId", genForm.nhaTroId)
      }
      const response = await fetch(`/api/hoa-don/generation-preview?${params.toString()}`, {
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      })
      const result = await response.json()
      if (!response.ok || !result.success) {
        throw new Error(result.message || "Không thể tải xem trước sinh hóa đơn")
      }
      setPreviewData(result.data)
    } catch (err) {
      setPreviewError(err instanceof Error ? err.message : "Có lỗi xảy ra")
      setPreviewData(null)
    } finally {
      setPreviewLoading(false)
    }
  }

  const handleGenerate = async () => {
    setGenerating(true)
    try {
      const body: any = {
        kyThang: Number(genForm.kyThang),
        kyNam: Number(genForm.kyNam),
        requireConfirmedReadings: genForm.requireConfirmedReadings,
        sendNotification: genForm.sendNotification,
      }
      if (genForm.nhaTroId !== "all") {
        body.nhaTroId = genForm.nhaTroId
      }
      const response = await fetch("/api/hoa-don/generate-monthly", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
        },
        body: JSON.stringify(body),
      })
      const result = await response.json()
      if (!response.ok || !result.success) {
        throw new Error(result.message || "Tạo hóa đơn hàng tháng thất bại")
      }
      setGenResult(result.data)
      toast.success("Đã sinh hóa đơn hàng tháng thành công")
      await fetchInvoices(true)
    } catch (err) {
      toast.error(err instanceof Error ? err.message : "Có lỗi xảy ra")
    } finally {
      setGenerating(false)
    }
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
      <DashboardHero
        icon={ReceiptText}
        title="Hóa đơn"
        description="Lập hóa đơn theo kỳ, theo dõi dư nợ và chuyển nhanh sang ghi nhận thanh toán."
        actions={
          <>
            <HeroActionButton variant="secondary" onClick={() => void fetchInvoices(true)} disabled={refreshing}>
              <RefreshCw className={`h-4 w-4 sm:mr-2 ${refreshing ? "animate-spin" : ""}`} />
              <span className="hidden sm:inline">Làm mới</span>
            </HeroActionButton>
            <HeroActionButton variant="secondary" onClick={() => setIsGenerateOpen(true)} className="bg-[#4FA7A0]/20 hover:bg-[#4FA7A0]/40 border-[#4FA7A0]/50 text-white">
              <CalendarDays className="h-4 w-4 sm:mr-2" />
              <span className="hidden sm:inline">Sinh hóa đơn tháng</span>
            </HeroActionButton>
            <HeroActionButton asChild variant="default">
              <Link href="/dashboard/hoa-don/them-moi">
                <Plus className="h-4 w-4 sm:mr-2" />
                <span className="hidden sm:inline">Lập hóa đơn</span>
              </Link>
            </HeroActionButton>
          </>
        }
      >
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-3 md:gap-4 relative z-10">
          <DashboardKpiCard 
            title="Hóa đơn khớp lọc" 
            value={String(total)} 
            icon={<ReceiptText className="h-5 w-5" />} 
            tone="default" 
          />
          <DashboardKpiCard 
            title="Còn phải thu" 
            value={currency(metrics.outstanding)} 
            icon={<CircleDollarSign className="h-5 w-5" />} 
            tone="orange" 
          />
          <DashboardKpiCard 
            title="Đã thu" 
            value={currency(metrics.collected)} 
            icon={<CalendarDays className="h-5 w-5" />} 
            tone="emerald" 
          />
          <DashboardKpiCard 
            title="Quá hạn" 
            value={String(metrics.overdue)} 
            icon={<AlertCircle className="h-5 w-5" />} 
            tone="red" 
          />
        </div>
      </DashboardHero>

      <DashboardCard className="overflow-hidden">
        <CardHeader className="border-b bg-[#F2E8DC]/70 pb-4">
          <CardTitle className="text-lg text-[#243B5A]">Bộ lọc hóa đơn</CardTitle>
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
      </DashboardCard>

      <DashboardCard className="overflow-hidden">
        <CardHeader className="border-b bg-[#F2E8DC]/70 pb-4">
          <CardTitle className="text-lg text-[#243B5A]">Danh sách hóa đơn</CardTitle>
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
      </DashboardCard>

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

      <Dialog open={isGenerateOpen} onOpenChange={(open) => {
        setIsGenerateOpen(open)
        if (!open) {
          setPreviewData(null)
          setPreviewError(null)
          setGenResult(null)
        } else {
          void fetchToaNhas()
        }
      }}>
        <DialogContent className="max-w-4xl max-h-[90vh] flex flex-col p-6">
          <DialogHeader>
            <DialogTitle className="text-xl font-bold flex items-center gap-2">
              <CalendarDays className="h-5 w-5 text-[#243B5A]" />
              Sinh hóa đơn hàng tháng tự động
            </DialogTitle>
            <DialogDescription>
              Sinh hàng loạt hóa đơn cho tất cả hợp đồng đang hiệu lực. Xem trước chi phí dự kiến trước khi xác nhận.
            </DialogDescription>
          </DialogHeader>

          {/* Form Filter */}
          {!genResult && (
            <div className="grid gap-4 sm:grid-cols-3 bg-muted/40 p-4 rounded-xl border mb-2">
              <div className="space-y-1.5">
                <Label htmlFor="nhaTro">Tòa nhà</Label>
                <Select value={genForm.nhaTroId} onValueChange={(value) => setGenForm(prev => ({ ...prev, nhaTroId: value }))}>
                  <SelectTrigger id="nhaTro">
                    <SelectValue placeholder="Chọn tòa nhà" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">Tất cả tòa nhà</SelectItem>
                    {toaNhas.map((tn) => (
                      <SelectItem key={tn.id || tn._id} value={tn.id || tn._id}>{tn.ten}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-1.5">
                <Label htmlFor="thang">Tháng</Label>
                <Select value={genForm.kyThang} onValueChange={(value) => setGenForm(prev => ({ ...prev, kyThang: value }))}>
                  <SelectTrigger id="thang">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {Array.from({ length: 12 }, (_, i) => (
                      <SelectItem key={i + 1} value={String(i + 1)}>Tháng {i + 1}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-1.5">
                <Label htmlFor="nam">Năm</Label>
                <Select value={genForm.kyNam} onValueChange={(value) => setGenForm(prev => ({ ...prev, kyNam: value }))}>
                  <SelectTrigger id="nam">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {Array.from({ length: 5 }, (_, i) => String(currentYear - 2 + i)).map((year) => (
                      <SelectItem key={year} value={year}>{year}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <div className="sm:col-span-3 flex flex-wrap gap-6 pt-2">
                <div className="flex items-center gap-2">
                  <Checkbox 
                    id="requireConfirmedReadings" 
                    checked={genForm.requireConfirmedReadings} 
                    onCheckedChange={(checked) => setGenForm(prev => ({ ...prev, requireConfirmedReadings: !!checked }))}
                  />
                  <Label htmlFor="requireConfirmedReadings" className="font-normal cursor-pointer text-sm">
                    Chỉ sinh khi đã chốt đủ chỉ số điện/nước
                  </Label>
                </div>
                
                <div className="flex items-center gap-2">
                  <Checkbox 
                    id="sendNotification" 
                    checked={genForm.sendNotification} 
                    onCheckedChange={(checked) => setGenForm(prev => ({ ...prev, sendNotification: !!checked }))}
                  />
                  <Label htmlFor="sendNotification" className="font-normal cursor-pointer text-sm">
                    Tự động gửi email/thông báo cho khách thuê
                  </Label>
                </div>
              </div>

              <div className="sm:col-span-3 flex justify-end pt-2">
                <Button 
                  onClick={handlePreview} 
                  disabled={previewLoading || generating}
                  className="bg-[#243B5A] hover:bg-[#1B2E47] text-white font-medium"
                >
                  {previewLoading ? "Đang xử lý..." : "Xem trước hóa đơn"}
                </Button>
              </div>
            </div>
          )}

          {/* Results Summary after generation */}
          {genResult && (
            <div className="space-y-4 py-4 flex-1 overflow-hidden flex flex-col">
              <div className="grid gap-4 grid-cols-3 text-center">
                <div className="p-3 bg-[#4FA7A0]/10 dark:bg-[#4FA7A0]/20 border border-[#4FA7A0]/20 dark:border-[#4FA7A0]/30 rounded-xl">
                  <p className="text-sm font-medium text-[#267D76] dark:text-[#8CCBC5]">Thành công</p>
                  <p className="text-2xl font-bold text-[#267D76] dark:text-[#8CCBC5]">{genResult.createdCount}</p>
                </div>
                <div className="p-3 bg-amber-50 dark:bg-amber-950/20 border border-amber-100 dark:border-amber-900 rounded-xl">
                  <p className="text-sm font-medium text-amber-600 dark:text-amber-400">Bỏ qua</p>
                  <p className="text-2xl font-bold text-amber-700 dark:text-amber-300">{genResult.skippedCount}</p>
                </div>
                <div className="p-3 bg-red-50 dark:bg-red-950/20 border border-red-100 dark:border-red-900 rounded-xl">
                  <p className="text-sm font-medium text-red-600 dark:text-red-400">Lỗi</p>
                  <p className="text-2xl font-bold text-red-700 dark:text-red-300">{genResult.errorCount}</p>
                </div>
              </div>

              <div className="text-sm font-semibold text-muted-foreground mt-2">Chi tiết nhật ký chạy:</div>
              <ScrollArea className="flex-1 border rounded-xl p-2 bg-muted/20">
                <div className="space-y-1.5 text-sm font-mono">
                  {genResult.logs && genResult.logs.length > 0 ? (
                    genResult.logs.map((log: any, idx: number) => (
                      <div key={idx} className="flex justify-between items-center py-1 border-b last:border-0 px-2">
                        <span>Phòng: <span className="font-bold text-[#243B5A] dark:text-slate-200">{log.maPhong || "Chưa rõ"}</span></span>
                        <div className="flex items-center gap-2">
                          <Badge 
                            variant={log.status === "SUCCESS" ? "default" : log.status === "SKIPPED" ? "secondary" : "destructive"}
                            className={log.status === "SUCCESS" ? "bg-[#4FA7A0]/15 text-[#267D76] hover:bg-[#4FA7A0]/15 border-none" : undefined}
                          >
                            {log.status === "SUCCESS" ? "Thành công" : log.status === "SKIPPED" ? "Bỏ qua" : "Lỗi"}
                          </Badge>
                          {log.reason && <span className="text-xs text-muted-foreground">({log.reason})</span>}
                        </div>
                      </div>
                    ))
                  ) : (
                    <div className="text-center text-muted-foreground py-4">Không có bản ghi nhật ký nào.</div>
                  )}
                </div>
              </ScrollArea>
            </div>
          )}

          {/* Preview candidate list */}
          {!genResult && previewData && (
            <div className="flex-1 overflow-hidden flex flex-col space-y-3 mt-2 min-h-[300px]">
              <div className="flex justify-between items-center text-sm font-semibold border-b pb-2">
                <span>Danh sách ứng viên ({previewData.candidates?.length || 0} hợp đồng)</span>
                <span className="text-[#243B5A]">Tổng tiền dự kiến: {currency(previewData.tongEstimatedAmount)}</span>
              </div>
              <ScrollArea className="flex-1 border rounded-xl bg-background">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead className="w-24">Phòng</TableHead>
                      <TableHead className="w-40">Khách thuê</TableHead>
                      <TableHead className="w-32">Trạng thái</TableHead>
                      <TableHead className="text-right w-32">Tiền dự tính</TableHead>
                      <TableHead>Cảnh báo / Ghi chú</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {previewData.candidates && previewData.candidates.length > 0 ? (
                      previewData.candidates.map((cand: any, idx: number) => (
                        <TableRow key={idx}>
                          <TableCell className="font-bold">{cand.maPhong}</TableCell>
                          <TableCell className="truncate max-w-[150px]">{cand.tenKhachThue}</TableCell>
                          <TableCell>
                            <Badge 
                              variant={cand.status === "READY" ? "default" : cand.status === "EXISTS" ? "secondary" : "destructive"}
                              className={cand.status === "READY" ? "bg-[#4FA7A0]/15 text-[#267D76] hover:bg-[#4FA7A0]/15 border-none" : undefined}
                            >
                              {cand.status === "READY" ? "Sẵn sàng" : cand.status === "EXISTS" ? "Đã có HĐ" : "Thiếu chỉ số"}
                            </Badge>
                          </TableCell>
                          <TableCell className="text-right font-medium">{currency(cand.estimatedAmount)}</TableCell>
                          <TableCell className="text-xs text-muted-foreground">
                            {cand.warnings && cand.warnings.length > 0 ? cand.warnings.join(", ") : "Không có cảnh báo"}
                          </TableCell>
                        </TableRow>
                      ))
                    ) : (
                      <TableRow>
                        <TableCell colSpan={5} className="text-center py-6 text-muted-foreground">
                          Không tìm thấy hợp đồng nào phù hợp trong bộ lọc này.
                        </TableCell>
                      </TableRow>
                    )}
                  </TableBody>
                </Table>
              </ScrollArea>

              {/* Stats card */}
              <div className="flex justify-between items-center text-sm p-3 bg-[#F8F3EC] dark:bg-[#243B5A] border rounded-xl">
                <div>
                  Hợp đồng ready: <span className="font-bold text-[#267D76] dark:text-[#8CCBC5]">{previewData.tongReady}</span> / {previewData.tongHopDong}
                </div>
                <div className="font-bold">
                  Tổng tiền chốt dự kiến: {currency(previewData.tongEstimatedAmount)}
                </div>
              </div>
            </div>
          )}

          {previewError && (
            <div className="p-4 bg-red-50 dark:bg-red-950/20 border border-red-100 dark:border-red-900 rounded-xl text-sm text-red-600 dark:text-red-400 my-2">
              Lỗi tải xem trước: {previewError}
            </div>
          )}

          <DialogFooter className="mt-4 flex-row gap-2 justify-end">
            {genResult ? (
              <Button 
                onClick={() => {
                  setIsGenerateOpen(false)
                  setGenResult(null)
                  setPreviewData(null)
                }}
                className="w-full sm:w-auto bg-[#243B5A] hover:bg-[#243B5A] text-white font-medium"
              >
                Đóng lại
              </Button>
            ) : (
              <>
                <Button 
                  variant="outline" 
                  onClick={() => setIsGenerateOpen(false)} 
                  disabled={generating}
                  className="w-full sm:w-auto"
                >
                  Hủy bỏ
                </Button>
                {previewData && (
                  <Button
                    onClick={handleGenerate}
                    disabled={previewData.tongReady === 0 || generating}
                    className="w-full sm:w-auto bg-[#4FA7A0] hover:bg-[#3F8F89] text-white font-medium"
                  >
                    {generating ? "Đang sinh hóa đơn..." : `Xác nhận sinh ${previewData.tongReady} hóa đơn`}
                  </Button>
                )}
              </>
            )}
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}
