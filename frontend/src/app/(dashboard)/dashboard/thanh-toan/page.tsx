"use client"

import { useCallback, useEffect, useMemo, useRef, useState, type FormEvent } from "react"
import Link from "next/link"
import { useSession } from "next-auth/react"
import {
  Banknote,
  CalendarDays,
  ChevronLeft,
  ChevronRight,
  CreditCard,
  FileCheck2,
  Pencil,
  Plus,
  ReceiptText,
  RefreshCw,
  Search,
  Trash2,
} from "lucide-react"
import { toast } from "sonner"

import { EmptyState, ErrorState } from "@/components/dashboard/dashboard-ui"
import { DashboardCard, HeroActionButton } from "@/components/dashboard/shared-ui"
import { ImageUpload } from "@/components/ui/image-upload"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
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
import { Textarea } from "@/components/ui/textarea"
import { unwrapPageData } from "@/lib/api-response"
import { cn } from "@/lib/utils"
import styles from "./thanh-toan-hero.module.css"
import type {
  ApiResponse,
  HoaDon,
  PaginatedResponse,
  PhuongThucThanhToanDb,
  ThanhToan,
  TrangThaiThanhToan,
} from "@/types"

type PaymentRecord = Omit<ThanhToan, "hoaDon" | "ngayThanhToan" | "phuongThuc"> & {
  hoaDon: string | HoaDon
  ngayThanhToan: string
  phuongThuc?: PhuongThucThanhToanDb
}

type PaymentForm = {
  hoaDonId: string
  soTien: string
  phuongThuc: PhuongThucThanhToanDb
  ngayThanhToan: string
  trangThai: "SUCCESS" | "PENDING"
  nganHang: string
  soGiaoDich: string
  ghiChu: string
  anhBienLai: string
}

const today = new Date().toISOString().slice(0, 10)

const blankForm = (): PaymentForm => ({
  hoaDonId: "",
  soTien: "",
  phuongThuc: "CASH",
  ngayThanhToan: today,
  trangThai: "SUCCESS",
  nganHang: "",
  soGiaoDich: "",
  ghiChu: "",
  anhBienLai: "",
})

const currency = (amount?: number) =>
  new Intl.NumberFormat("vi-VN", { style: "currency", currency: "VND" }).format(amount || 0)

const paymentId = (item: PaymentRecord) => item._id || item.id || ""

function paymentMethod(item: PaymentRecord) {
  return item.phuongThucThanhToan || item.phuongThuc || "CASH"
}

function methodLabel(method: PhuongThucThanhToanDb | undefined) {
  switch (method) {
    case "BANK_TRANSFER":
      return "Chuyển khoản"
    case "VIETQR":
      return "VietQR"
    case "MOMO":
      return "MoMo"
    case "ZALOPAY":
      return "ZaloPay"
    case "OTHER":
      return "Khác"
    default:
      return "Tiền mặt"
  }
}

function StatusBadge({ status }: { status?: TrangThaiThanhToan }) {
  switch (status) {
    case "SUCCESS":
      return <Badge className="border-transparent bg-[#4FA7A0]/15 text-[#267D76]">Đã thu</Badge>
    case "PENDING":
      return <Badge className="border-transparent bg-amber-100 text-amber-800">Chờ xác nhận</Badge>
    case "FAILED":
      return <Badge className="border-transparent bg-red-100 text-red-800">Thất bại</Badge>
    case "REFUNDED":
      return <Badge className="border-transparent bg-[#4FA7A0]/15 text-[#243B5A]">Đã hoàn</Badge>
    default:
      return <Badge variant="secondary">Đã hủy</Badge>
  }
}

function PaymentSkeleton() {
  return (
    <div className="space-y-6" aria-label="Đang tải thanh toán">
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

export default function ThanhToanPage() {
  const accessToken = useSession()?.data?.accessToken
  const preselectedInvoiceConsumed = useRef(false)
  const [data, setData] = useState<PaymentRecord[]>([])
  const [invoices, setInvoices] = useState<HoaDon[]>([])
  const [loading, setLoading] = useState(true)
  const [refreshing, setRefreshing] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [searchInput, setSearchInput] = useState("")
  const [search, setSearch] = useState("")
  const [filters, setFilters] = useState({
    phuongThuc: "all",
    trangThai: "all",
    tuNgay: "",
    denNgay: "",
  })
  const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 10 })
  const [total, setTotal] = useState(0)
  const [totalPages, setTotalPages] = useState(1)
  const [formOpen, setFormOpen] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [editing, setEditing] = useState<PaymentRecord | null>(null)
  const [formData, setFormData] = useState<PaymentForm>(blankForm)
  const [cancelTarget, setCancelTarget] = useState<PaymentRecord | null>(null)

  useEffect(() => {
    document.title = "Thanh toán | EasyHouse"
  }, [])

  useEffect(() => {
    const timeout = window.setTimeout(() => {
      setSearch(searchInput.trim())
      setPagination((current) => ({ ...current, pageIndex: 0 }))
    }, 350)
    return () => window.clearTimeout(timeout)
  }, [searchInput])

  const fetchInvoices = useCallback(async () => {
    try {
      const response = await fetch("/api/hoa-don?page=1&limit=100", {
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      })
      const result: ApiResponse<HoaDon[] | PaginatedResponse<HoaDon>> = await response.json()
      if (response.ok && result.success) {
        setInvoices(unwrapPageData(result.data))
      }
    } catch {
      setInvoices([])
    }
  }, [accessToken])

  const fetchPayments = useCallback(
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
        if (filters.phuongThuc !== "all") params.set("phuongThuc", filters.phuongThuc)
        if (filters.trangThai !== "all") params.set("trangThai", filters.trangThai)
        if (filters.tuNgay) params.set("tuNgay", filters.tuNgay)
        if (filters.denNgay) params.set("denNgay", filters.denNgay)

        const response = await fetch(`/api/thanh-toan?${params.toString()}`, {
          headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
        })
        const result: ApiResponse<PaginatedResponse<PaymentRecord>> = await response.json()
        if (!response.ok || !result.success || !result.data) {
          throw new Error(result.message || "Không thể tải danh sách thanh toán")
        }
        setData(result.data.data || [])
        setTotal(result.data.total || 0)
        setTotalPages(Math.max(result.data.totalPages || 1, 1))
      } catch (fetchError) {
        setError(fetchError instanceof Error ? fetchError.message : "Không thể tải danh sách thanh toán")
        setData([])
        setTotal(0)
      } finally {
        setLoading(false)
        setRefreshing(false)
      }
    },
    [accessToken, filters.denNgay, filters.phuongThuc, filters.trangThai, filters.tuNgay, pagination.pageIndex, pagination.pageSize, search],
  )

  useEffect(() => {
    void fetchInvoices()
  }, [fetchInvoices])

  useEffect(() => {
    if (preselectedInvoiceConsumed.current || invoices.length === 0) return
    const invoiceId = new URLSearchParams(window.location.search).get("hoaDonId")
    if (!invoiceId || !invoices.some((invoice) => (invoice._id || invoice.id) === invoiceId)) return
    preselectedInvoiceConsumed.current = true
    setEditing(null)
    setFormData({ ...blankForm(), hoaDonId: invoiceId })
    setFormOpen(true)
  }, [invoices])

  useEffect(() => {
    void fetchPayments()
  }, [fetchPayments])

  const invoiceFor = useCallback(
    (item: PaymentRecord) => {
      if (typeof item.hoaDon === "object" && item.hoaDon !== null) return item.hoaDon
      return invoices.find((invoice) => (invoice._id || invoice.id) === item.hoaDon)
    },
    [invoices],
  )

  const metrics = useMemo(() => {
    const success = data.filter((item) => item.trangThai === "SUCCESS")
    return {
      successMoney: success.reduce((sum, item) => sum + Number(item.soTien || 0), 0),
      successCount: success.length,
      pendingCount: data.filter((item) => item.trangThai === "PENDING").length,
      cancelledCount: data.filter((item) => item.trangThai === "CANCELLED" || item.trangThai === "REFUNDED").length,
    }
  }, [data])

  const heroStatus = useMemo(() => {
    if (metrics.cancelledCount > 0) {
      return { label: "Có giao dịch cần kiểm tra", tone: "danger" as const }
    }
    if (metrics.pendingCount > 0) {
      return { label: "Cần xác nhận giao dịch", tone: "warning" as const }
    }
    return { label: "Đối soát ổn định", tone: "success" as const }
  }, [metrics.cancelledCount, metrics.pendingCount])

  const filterPeriodLabel = useMemo(() => {
    if (filters.tuNgay && filters.denNgay) {
      return `Kỳ: ${new Date(filters.tuNgay).toLocaleDateString("vi-VN")} - ${new Date(filters.denNgay).toLocaleDateString("vi-VN")}`
    }
    if (filters.tuNgay) return `Từ ${new Date(filters.tuNgay).toLocaleDateString("vi-VN")}`
    if (filters.denNgay) return `Đến ${new Date(filters.denNgay).toLocaleDateString("vi-VN")}`
    return "Bộ lọc hiện tại"
  }, [filters.denNgay, filters.tuNgay])

  const resetFilters = () => {
    setSearchInput("")
    setSearch("")
    setFilters({ phuongThuc: "all", trangThai: "all", tuNgay: "", denNgay: "" })
    setPagination((current) => ({ ...current, pageIndex: 0 }))
  }

  const openCreate = () => {
    setEditing(null)
    setFormData(blankForm())
    setFormOpen(true)
  }

  const openEdit = (item: PaymentRecord) => {
    const invoice = invoiceFor(item)
    setEditing(item)
    setFormData({
      hoaDonId: invoice?._id || invoice?.id || (typeof item.hoaDon === "string" ? item.hoaDon : ""),
      soTien: String(item.soTien || ""),
      phuongThuc: paymentMethod(item),
      ngayThanhToan: new Date(item.ngayThanhToan).toISOString().slice(0, 10),
      trangThai: item.trangThai === "PENDING" ? "PENDING" : "SUCCESS",
      nganHang: "",
      soGiaoDich: item.maThamChieu || "",
      ghiChu: item.ghiChu || "",
      anhBienLai: item.anhBienLai || "",
    })
    setFormOpen(true)
  }

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    if (!formData.hoaDonId) {
      toast.error("Vui lòng chọn hóa đơn")
      return
    }
    if (!formData.soTien || Number(formData.soTien) <= 0) {
      toast.error("Số tiền thanh toán phải lớn hơn 0")
      return
    }
    setSubmitting(true)
    try {
      const response = await fetch(editing ? `/api/thanh-toan/${paymentId(editing)}` : "/api/thanh-toan", {
        method: editing ? "PUT" : "POST",
        headers: {
          "Content-Type": "application/json",
          ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
        },
        body: JSON.stringify({
          hoaDonId: formData.hoaDonId,
          soTien: Number(formData.soTien),
          phuongThuc: formData.phuongThuc,
          ngayThanhToan: formData.ngayThanhToan,
          trangThai: formData.trangThai,
          thongTinChuyenKhoan:
            formData.phuongThuc === "CASH"
              ? undefined
              : { nganHang: formData.nganHang, soGiaoDich: formData.soGiaoDich },
          ghiChu: formData.ghiChu,
          anhBienLai: formData.anhBienLai,
        }),
      })
      const result: ApiResponse<PaymentRecord> = await response.json()
      if (!response.ok || !result.success) {
        throw new Error(result.message || "Không thể lưu thanh toán")
      }
      toast.success(editing ? "Đã cập nhật thanh toán" : "Đã ghi nhận thanh toán")
      setFormOpen(false)
      setEditing(null)
      await fetchPayments(true)
    } catch (submitError) {
      toast.error(submitError instanceof Error ? submitError.message : "Không thể lưu thanh toán")
    } finally {
      setSubmitting(false)
    }
  }

  const cancelPayment = async () => {
    if (!cancelTarget) return
    setSubmitting(true)
    try {
      const response = await fetch(`/api/thanh-toan/${paymentId(cancelTarget)}`, {
        method: "DELETE",
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
      })
      const result: ApiResponse<null> = await response.json()
      if (!response.ok || !result.success) {
        throw new Error(result.message || "Không thể hủy thanh toán")
      }
      toast.success("Đã hủy giao dịch và cập nhật lại số đã thu của hóa đơn")
      setCancelTarget(null)
      await fetchPayments(true)
    } catch (cancelError) {
      toast.error(cancelError instanceof Error ? cancelError.message : "Không thể hủy thanh toán")
    } finally {
      setSubmitting(false)
    }
  }

  if (loading) return <PaymentSkeleton />
  if (error) return <ErrorState title="Không tải được thanh toán" description={error} onRetry={() => void fetchPayments()} />

  return (
    <div className="space-y-6">
      <section className={cn("thanh-toan-hero", styles.hero)}>
        <div className={cn("thanh-toan-hero__content", styles.content)}>
          <div className={cn("thanh-toan-hero__eyebrow", styles.eyebrow)}>
            <Banknote className="h-4 w-4" aria-hidden="true" />
            THANH TOÁN
          </div>

          <div className={cn("thanh-toan-hero__title-row", styles.titleRow)}>
            <h1>Thanh toán</h1>
            <span
              className={cn(
                "thanh-toan-hero__status-badge",
                styles.statusBadge,
                heroStatus.tone === "warning" && "is-warning",
                heroStatus.tone === "warning" && styles.statusWarning,
                heroStatus.tone === "danger" && "is-danger",
                heroStatus.tone === "danger" && styles.statusDanger,
              )}
            >
              {heroStatus.label}
            </span>
          </div>

          <p>Ghi nhận tiền thực thu, đối soát hóa đơn và theo dõi trạng thái giao dịch trong một nơi.</p>

          <div className={cn("thanh-toan-hero__insight", styles.insight)}>
            <span>
              Hiện đã ghi nhận <strong>{currency(metrics.successMoney)}</strong>, có{" "}
              <strong>{metrics.pendingCount}</strong> giao dịch chờ xác nhận và{" "}
              <strong>{metrics.cancelledCount}</strong> giao dịch đã hủy/hoàn.
            </span>
          </div>

          <div className={cn("thanh-toan-hero__chips", styles.chips)} aria-label="Tóm tắt bộ lọc thanh toán">
            <span className={cn("thanh-toan-hero__chip", styles.chip)}>{filterPeriodLabel}</span>
            <span className={cn("thanh-toan-hero__chip", styles.chip)}>{total} giao dịch</span>
            <span className={cn("thanh-toan-hero__chip", styles.chip)}>Đã thu {currency(metrics.successMoney)}</span>
            <span className={cn("thanh-toan-hero__chip", styles.chip)}>Chờ xác nhận {metrics.pendingCount}</span>
            <span className={cn("thanh-toan-hero__chip", styles.chip)}>Hủy/hoàn {metrics.cancelledCount}</span>
          </div>

          <div className={cn("thanh-toan-hero__stats", styles.stats)}>
            {[
              {
                title: "Khớp lọc",
                value: String(total),
                hint: "Theo điều kiện lọc hiện tại",
                icon: <ReceiptText className="h-5 w-5" />,
                tone: "neutral",
              },
              {
                title: "Đã thu trên trang",
                value: currency(metrics.successMoney),
                hint: "Tổng tiền đã ghi nhận",
                icon: <Banknote className="h-5 w-5" />,
                tone: metrics.successMoney > 0 ? "success" : "neutral",
              },
              {
                title: "Chờ xác nhận",
                value: String(metrics.pendingCount),
                hint: metrics.pendingCount > 0 ? "Có giao dịch cần duyệt" : "Không có giao dịch cần duyệt",
                icon: <CalendarDays className="h-5 w-5" />,
                tone: metrics.pendingCount > 0 ? "warning" : "success",
              },
              {
                title: "Đã hủy/hoàn",
                value: String(metrics.cancelledCount),
                hint: metrics.cancelledCount > 0 ? "Có giao dịch cần kiểm tra" : "Không có giao dịch hoàn/hủy",
                icon: <FileCheck2 className="h-5 w-5" />,
                tone: metrics.cancelledCount > 0 ? "danger" : "neutral",
              },
            ].map((item, index) => (
              <div
                key={item.title}
                className={cn(
                  "thanh-toan-hero__stat-card",
                  `is-${item.tone}`,
                  styles.statCard,
                  item.tone === "success" && styles.toneSuccess,
                  item.tone === "warning" && styles.toneWarning,
                  item.tone === "danger" && styles.toneDanger,
                )}
                style={{ animationDelay: `${index * 70}ms` }}
              >
                <div className={cn("thanh-toan-hero__stat-top", styles.statTop)}>
                  <span>{item.title}</span>
                  <span className={cn("thanh-toan-hero__stat-icon", styles.statIcon)}>{item.icon}</span>
                </div>
                <strong>{item.value}</strong>
                <small>{item.hint}</small>
              </div>
            ))}
          </div>
        </div>

        <div className={cn("thanh-toan-hero__actions", styles.actions)}>
          <HeroActionButton
            className={cn("thanh-toan-hero__button thanh-toan-hero__button-secondary", styles.button, styles.buttonSecondary)}
            variant="secondary"
            onClick={() => void fetchPayments(true)}
            disabled={refreshing}
          >
            <RefreshCw className={refreshing ? "animate-spin" : ""} />
            Làm mới
          </HeroActionButton>
          <HeroActionButton
            className={cn("thanh-toan-hero__button thanh-toan-hero__button-primary", styles.button, styles.buttonPrimary)}
            variant="default"
            onClick={openCreate}
          >
            <Plus />
            Ghi nhận thanh toán
          </HeroActionButton>
        </div>
      </section>

      <DashboardCard>
        <CardHeader className="pb-3 border-b border-gray-100">
          <CardTitle className="text-sm font-medium text-gray-700">Bộ lọc giao dịch</CardTitle>
          <CardDescription>Tìm kiếm và lọc được thực hiện trên server trước khi phân trang.</CardDescription>
        </CardHeader>
        <CardContent className="grid gap-3 md:grid-cols-2 xl:grid-cols-6">
          <div className="relative md:col-span-2">
            <Search className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
            <Input
              className="pl-9"
              value={searchInput}
              onChange={(event) => setSearchInput(event.target.value)}
              placeholder="Mã HĐ, phòng, khách, mã giao dịch..."
            />
          </div>
          <Select value={filters.phuongThuc} onValueChange={(value) => {
            setFilters((current) => ({ ...current, phuongThuc: value }))
            setPagination((current) => ({ ...current, pageIndex: 0 }))
          }}>
            <SelectTrigger><SelectValue placeholder="Phương thức" /></SelectTrigger>
            <SelectContent>
              <SelectItem value="all">Mọi phương thức</SelectItem>
              <SelectItem value="CASH">Tiền mặt</SelectItem>
              <SelectItem value="BANK_TRANSFER">Chuyển khoản</SelectItem>
              <SelectItem value="VIETQR">VietQR</SelectItem>
              <SelectItem value="MOMO">MoMo</SelectItem>
              <SelectItem value="ZALOPAY">ZaloPay</SelectItem>
              <SelectItem value="OTHER">Khác</SelectItem>
            </SelectContent>
          </Select>
          <Select value={filters.trangThai} onValueChange={(value) => {
            setFilters((current) => ({ ...current, trangThai: value }))
            setPagination((current) => ({ ...current, pageIndex: 0 }))
          }}>
            <SelectTrigger><SelectValue placeholder="Trạng thái" /></SelectTrigger>
            <SelectContent>
              <SelectItem value="all">Mọi trạng thái</SelectItem>
              <SelectItem value="SUCCESS">Đã thu</SelectItem>
              <SelectItem value="PENDING">Chờ xác nhận</SelectItem>
              <SelectItem value="FAILED">Thất bại</SelectItem>
              <SelectItem value="CANCELLED">Đã hủy</SelectItem>
              <SelectItem value="REFUNDED">Đã hoàn</SelectItem>
            </SelectContent>
          </Select>
          <Input
            type="date"
            aria-label="Từ ngày"
            value={filters.tuNgay}
            onChange={(event) => {
              setFilters((current) => ({ ...current, tuNgay: event.target.value }))
              setPagination((current) => ({ ...current, pageIndex: 0 }))
            }}
          />
          <Input
            type="date"
            aria-label="Đến ngày"
            value={filters.denNgay}
            onChange={(event) => {
              setFilters((current) => ({ ...current, denNgay: event.target.value }))
              setPagination((current) => ({ ...current, pageIndex: 0 }))
            }}
          />
          <Button variant="ghost" className="xl:col-start-6" onClick={resetFilters}>Xóa lọc</Button>
        </CardContent>
      </DashboardCard>

      <DashboardCard className="overflow-hidden">
        <CardHeader className="border-b bg-[#F2E8DC]/70 pb-4">
          <CardTitle className="text-lg text-[#243B5A]">Danh sách thanh toán</CardTitle>
          <CardDescription>{total} giao dịch phù hợp bộ lọc hiện tại</CardDescription>
        </CardHeader>
        <CardContent>
          {data.length === 0 ? (
            <EmptyState
              title="Chưa có giao dịch phù hợp"
              description="Điều chỉnh bộ lọc hoặc ghi nhận thanh toán mới cho hóa đơn cần thu."
            />
          ) : (
            <>
              <div className="hidden overflow-x-auto md:block">
                <Table>
                  <TableHeader>
                    <TableRow>
                      <TableHead>Hóa đơn / phòng</TableHead>
                      <TableHead>Ngày thu</TableHead>
                      <TableHead>Phương thức</TableHead>
                      <TableHead>Tham chiếu</TableHead>
                      <TableHead>Trạng thái</TableHead>
                      <TableHead className="text-right">Số tiền</TableHead>
                      <TableHead className="text-right">Thao tác</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {data.map((item) => {
                      const invoice = invoiceFor(item)
                      const editable = item.trangThai !== "CANCELLED" && item.trangThai !== "REFUNDED"
                      return (
                        <TableRow key={paymentId(item)}>
                          <TableCell>
                            <Link className="font-medium text-primary hover:underline" href={`/dashboard/hoa-don/${invoice?._id || invoice?.id || ""}`}>
                              {invoice?.maHoaDon || "Không xác định"}
                            </Link>
                            <p className="text-xs text-muted-foreground">
                              {typeof invoice?.phong === "object" ? invoice.phong.ten || invoice.phong.maPhong : "Chưa có phòng"}
                            </p>
                          </TableCell>
                          <TableCell>{new Date(item.ngayThanhToan).toLocaleDateString("vi-VN")}</TableCell>
                          <TableCell>{methodLabel(paymentMethod(item))}</TableCell>
                          <TableCell>{item.maThamChieu || "-"}</TableCell>
                          <TableCell><StatusBadge status={item.trangThai} /></TableCell>
                          <TableCell className="text-right font-semibold">{currency(Number(item.soTien))}</TableCell>
                          <TableCell className="text-right">
                            <Button size="icon-sm" variant="ghost" disabled={!editable} onClick={() => openEdit(item)}>
                              <Pencil />
                              <span className="sr-only">Sửa</span>
                            </Button>
                            <Button size="icon-sm" variant="ghost" disabled={!editable} onClick={() => setCancelTarget(item)}>
                              <Trash2 />
                              <span className="sr-only">Hủy</span>
                            </Button>
                          </TableCell>
                        </TableRow>
                      )
                    })}
                  </TableBody>
                </Table>
              </div>

              <div className="space-y-3 md:hidden">
                {data.map((item) => {
                  const invoice = invoiceFor(item)
                  const editable = item.trangThai !== "CANCELLED" && item.trangThai !== "REFUNDED"
                  return (
                    <div key={paymentId(item)} className="rounded-xl border p-4">
                      <div className="flex justify-between gap-3">
                        <div>
                          <Link className="font-semibold text-primary" href={`/dashboard/hoa-don/${invoice?._id || invoice?.id || ""}`}>
                            {invoice?.maHoaDon || "Không xác định"}
                          </Link>
                          <p className="text-sm text-muted-foreground">{new Date(item.ngayThanhToan).toLocaleDateString("vi-VN")}</p>
                        </div>
                        <StatusBadge status={item.trangThai} />
                      </div>
                      <p className="mt-3 text-xl font-semibold">{currency(Number(item.soTien))}</p>
                      <div className="mt-2 flex justify-between text-sm text-muted-foreground">
                        <span>{methodLabel(paymentMethod(item))}</span>
                        <span>{item.maThamChieu || "Không có mã"}</span>
                      </div>
                      <div className="mt-4 flex gap-2">
                        <Button variant="outline" size="sm" className="flex-1" disabled={!editable} onClick={() => openEdit(item)}>
                          <Pencil />Sửa
                        </Button>
                        <Button variant="outline" size="sm" className="flex-1" disabled={!editable} onClick={() => setCancelTarget(item)}>
                          <Trash2 />Hủy
                        </Button>
                      </div>
                    </div>
                  )
                })}
              </div>

              <div className="mt-6 flex flex-col justify-between gap-3 border-t pt-4 sm:flex-row sm:items-center">
                <Select
                  value={String(pagination.pageSize)}
                  onValueChange={(value) => setPagination({ pageIndex: 0, pageSize: Number(value) })}
                >
                  <SelectTrigger className="w-32"><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="10">10 / trang</SelectItem>
                    <SelectItem value="20">20 / trang</SelectItem>
                    <SelectItem value="50">50 / trang</SelectItem>
                  </SelectContent>
                </Select>
                <div className="flex items-center justify-between gap-3">
                  <span className="text-sm text-muted-foreground">Trang {pagination.pageIndex + 1} / {totalPages}</span>
                  <Button size="icon-sm" variant="outline" disabled={pagination.pageIndex === 0} onClick={() => setPagination((current) => ({ ...current, pageIndex: current.pageIndex - 1 }))}>
                    <ChevronLeft />
                    <span className="sr-only">Trang trước</span>
                  </Button>
                  <Button size="icon-sm" variant="outline" disabled={pagination.pageIndex + 1 >= totalPages} onClick={() => setPagination((current) => ({ ...current, pageIndex: current.pageIndex + 1 }))}>
                    <ChevronRight />
                    <span className="sr-only">Trang sau</span>
                  </Button>
                </div>
              </div>
            </>
          )}
        </CardContent>
      </DashboardCard>

      <Dialog open={formOpen} onOpenChange={(open) => {
        setFormOpen(open)
        if (!open) setEditing(null)
      }}>
        <DialogContent className="max-h-[92vh] max-w-2xl overflow-y-auto">
          <DialogHeader>
            <DialogTitle>{editing ? "Cập nhật thanh toán" : "Ghi nhận thanh toán"}</DialogTitle>
            <DialogDescription>
              Chỉ giao dịch ở trạng thái đã thu mới được cộng vào số đã thanh toán của hóa đơn.
            </DialogDescription>
          </DialogHeader>
          <form className="space-y-4" onSubmit={handleSubmit}>
            <div className="space-y-2">
              <Label htmlFor="payment-invoice">Hóa đơn</Label>
              <Select value={formData.hoaDonId} onValueChange={(value) => setFormData((current) => ({ ...current, hoaDonId: value }))}>
                <SelectTrigger id="payment-invoice"><SelectValue placeholder="Chọn hóa đơn cần thu" /></SelectTrigger>
                <SelectContent>
                  {invoices.map((invoice) => (
                    <SelectItem key={invoice._id || invoice.id} value={invoice._id || invoice.id || ""}>
                      {invoice.maHoaDon} - còn {currency(invoice.conLai)}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="space-y-2">
                <Label htmlFor="payment-amount">Số tiền (VNĐ)</Label>
                <Input id="payment-amount" type="number" min="1" required value={formData.soTien} onChange={(event) => setFormData((current) => ({ ...current, soTien: event.target.value }))} />
              </div>
              <div className="space-y-2">
                <Label htmlFor="payment-date">Ngày thanh toán</Label>
                <Input id="payment-date" type="date" required value={formData.ngayThanhToan} onChange={(event) => setFormData((current) => ({ ...current, ngayThanhToan: event.target.value }))} />
              </div>
              <div className="space-y-2">
                <Label>Phương thức</Label>
                <Select value={formData.phuongThuc} onValueChange={(value) => setFormData((current) => ({ ...current, phuongThuc: value as PhuongThucThanhToanDb }))}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="CASH">Tiền mặt</SelectItem>
                    <SelectItem value="BANK_TRANSFER">Chuyển khoản</SelectItem>
                    <SelectItem value="VIETQR">VietQR</SelectItem>
                    <SelectItem value="MOMO">MoMo</SelectItem>
                    <SelectItem value="ZALOPAY">ZaloPay</SelectItem>
                    <SelectItem value="OTHER">Khác</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Trạng thái ghi nhận</Label>
                <Select value={formData.trangThai} onValueChange={(value) => setFormData((current) => ({ ...current, trangThai: value as PaymentForm["trangThai"] }))}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="SUCCESS">Đã thu tiền</SelectItem>
                    <SelectItem value="PENDING">Chờ xác nhận</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>
            {formData.phuongThuc !== "CASH" && (
              <div className="grid gap-4 rounded-xl border bg-muted/30 p-4 sm:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="payment-bank">Ngân hàng / ví</Label>
                  <Input id="payment-bank" value={formData.nganHang} onChange={(event) => setFormData((current) => ({ ...current, nganHang: event.target.value }))} placeholder="VD: Vietcombank" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="payment-reference">Mã giao dịch</Label>
                  <Input id="payment-reference" value={formData.soGiaoDich} onChange={(event) => setFormData((current) => ({ ...current, soGiaoDich: event.target.value }))} placeholder="Mã đối soát" />
                </div>
              </div>
            )}
            <div className="space-y-2">
              <Label htmlFor="payment-note">Ghi chú</Label>
              <Textarea id="payment-note" rows={3} value={formData.ghiChu} onChange={(event) => setFormData((current) => ({ ...current, ghiChu: event.target.value }))} placeholder="Thông tin cần lưu khi đối chiếu..." />
            </div>
            <ImageUpload
              imageUrl={formData.anhBienLai}
              onImageChange={(url) => setFormData((current) => ({ ...current, anhBienLai: url }))}
              label="Ảnh biên nhận"
              placeholder="Tải ảnh xác nhận giao dịch"
            />
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setFormOpen(false)} disabled={submitting}>Đóng</Button>
              <Button type="submit" disabled={submitting}>
                <CreditCard />
                {submitting ? "Đang lưu..." : editing ? "Lưu thay đổi" : "Ghi nhận"}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      <Dialog open={Boolean(cancelTarget)} onOpenChange={(open) => {
        if (!open) setCancelTarget(null)
      }}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Hủy giao dịch thanh toán?</DialogTitle>
            <DialogDescription>
              Giao dịch {cancelTarget?.maThamChieu || (cancelTarget ? paymentId(cancelTarget) : "")} sẽ được chuyển sang trạng thái đã hủy. Số đã thu của hóa đơn sẽ được tính lại.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setCancelTarget(null)} disabled={submitting}>Giữ giao dịch</Button>
            <Button variant="destructive" onClick={() => void cancelPayment()} disabled={submitting}>
              {submitting ? "Đang hủy..." : "Xác nhận hủy"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}
