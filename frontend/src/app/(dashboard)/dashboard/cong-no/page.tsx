"use client"

import { useCallback, useEffect, useMemo, useState } from "react"
import Link from "next/link"
import { useSession } from "next-auth/react"
import {
  AlertTriangle,
  CalendarDays,
  ChevronLeft,
  ChevronRight,
  CircleDollarSign,
  FileText,
  House,
  ReceiptText,
  RefreshCw,
  Search,
} from "lucide-react"

import { EmptyState, ErrorState } from "@/components/dashboard/dashboard-ui"
import { DashboardCard } from "@/components/dashboard/shared-ui"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { cn } from "@/lib/utils"
import {
  Dialog,
  DialogContent,
  DialogDescription,
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
import type { ApiResponse, HoaDon, PaginatedResponse } from "@/types"

interface CongNoData {
  phongId: string
  maPhong: string
  toaNhaId: string | null
  tenToaNha: string | null
  khachThueId: string | null
  tenKhachThue: string | null
  soDienThoai: string | null
  tongNo: number
  noQuaHan: number
  danhSachHoaDonNo: HoaDon[]
}

const formatCurrency = (value: number) =>
  new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
    maximumFractionDigits: 0,
  }).format(value)

const formatDate = (value?: string | Date) =>
  value ? new Date(value).toLocaleDateString("vi-VN") : "Chưa có hạn"

const getOutstandingAmount = (hoaDon: HoaDon) =>
  hoaDon.conLai ?? hoaDon.tongTien - (hoaDon.daThanhToan ?? hoaDon.daTra ?? 0)

function CongNoSkeleton() {
  return (
    <div className="space-y-6" aria-label="Đang tải dữ liệu công nợ">
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

function InvoiceStatus({ status }: { status: HoaDon["trangThai"] }) {
  if (status === "OVERDUE" || status === "quaHan") {
    return <Badge variant="destructive">Quá hạn</Badge>
  }
  if (status === "PARTIAL" || status === "daThanhToanMotPhan") {
    return <Badge className="border-transparent bg-amber-100 text-amber-800">Thanh toán một phần</Badge>
  }
  return <Badge variant="outline">Chưa thanh toán</Badge>
}

export default function CongNoPage() {
  const accessToken = useSession()?.data?.accessToken
  const [data, setData] = useState<CongNoData[]>([])
  const [loading, setLoading] = useState(true)
  const [refreshing, setRefreshing] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [search, setSearch] = useState("")
  const [appliedSearch, setAppliedSearch] = useState("")
  const [debtFilter, setDebtFilter] = useState("all")
  const [selectedDebt, setSelectedDebt] = useState<CongNoData | null>(null)
  const [pagination, setPagination] = useState({ pageIndex: 0, pageSize: 10 })
  const [totalElements, setTotalElements] = useState(0)
  const [totalPages, setTotalPages] = useState(0)

  useEffect(() => {
    document.title = "Công nợ | EasyHouse"
  }, [])

  const fetchData = useCallback(
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
          sort: "tongNo,desc",
        })
        if (appliedSearch) params.set("search", appliedSearch)
        if (debtFilter === "overdue") params.set("overdueOnly", "true")
        const response = await fetch(`/api/cong-no?${params.toString()}`, {
          headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
        })
        const result: ApiResponse<PaginatedResponse<CongNoData>> = await response.json()

        if (!response.ok || !result.success || !result.data) {
          throw new Error(result.message || "Không thể tải danh sách công nợ.")
        }

        setData(result.data.data || [])
        setTotalElements(result.data.total || 0)
        setTotalPages(result.data.totalPages || 0)
      } catch (requestError) {
        setData([])
        setError(requestError instanceof Error ? requestError.message : "Không thể kết nối máy chủ.")
      } finally {
        setLoading(false)
        setRefreshing(false)
      }
    },
    [accessToken, appliedSearch, debtFilter, pagination.pageIndex, pagination.pageSize],
  )

  useEffect(() => {
    fetchData()
  }, [fetchData])

  useEffect(() => {
    const timeout = window.setTimeout(() => {
      setPagination((current) => ({ ...current, pageIndex: 0 }))
      setAppliedSearch(search.trim())
    }, 350)

    return () => window.clearTimeout(timeout)
  }, [search])

  useEffect(() => {
    setPagination((current) => ({ ...current, pageIndex: 0 }))
  }, [debtFilter])

  const pageTotals = useMemo(
    () =>
      data.reduce(
        (total, item) => ({
          debt: total.debt + item.tongNo,
          overdue: total.overdue + item.noQuaHan,
          invoices: total.invoices + item.danhSachHoaDonNo.length,
        }),
        { debt: 0, overdue: 0, invoices: 0 },
      ),
    [data],
  )

  const billingPeriod = useMemo(() => {
    const period = data
      .flatMap((item) => item.danhSachHoaDonNo)
      .find((hoaDon) => hoaDon.thang && hoaDon.nam)

    return period ? `Tháng ${period.thang}/${period.nam}` : null
  }, [data])

  const statusBadge = useMemo(() => {
    if (pageTotals.overdue > 0) {
      return { label: "Có khoản quá hạn", className: "is-danger" }
    }

    if (pageTotals.debt > 0 || totalElements > 0) {
      return { label: "Còn nợ cần theo dõi", className: "" }
    }

    return { label: "Công nợ ổn định", className: "is-stable" }
  }, [pageTotals.debt, pageTotals.overdue, totalElements])

  if (loading) return <CongNoSkeleton />

  if (error) {
    return <ErrorState title="Không tải được công nợ" description={error} onRetry={() => fetchData()} />
  }

  return (
    <div className="space-y-6 lg:space-y-8">
      <section className="cong-no-hero">
        <div className="cong-no-hero__content">
          <div className="cong-no-hero__eyebrow">
            <CircleDollarSign className="h-4 w-4" aria-hidden="true" />
            <span>CÔNG NỢ</span>
          </div>

          <div className="cong-no-hero__title-row">
            <h1>Công nợ</h1>
            <span className={cn("cong-no-hero__status-badge", statusBadge.className)}>
              {statusBadge.label}
            </span>
          </div>

          <p>
            Theo dõi khoản phải thu, hóa đơn chưa tất toán và các công nợ cần xử lý theo từng phòng.
          </p>

          {data.length > 0 ? (
            <div className="cong-no-hero__insight">
              <span>
                Theo dữ liệu đang hiển thị: <strong>{totalElements} phòng đang có nợ</strong>, tổng công nợ{" "}
                <strong>{formatCurrency(pageTotals.debt)}</strong> và{" "}
                {pageTotals.overdue > 0 ? (
                  <>
                    quá hạn <strong>{formatCurrency(pageTotals.overdue)}</strong>.
                  </>
                ) : (
                  <strong>chưa có khoản nào quá hạn</strong>
                )}
              </span>
            </div>
          ) : null}

          <div className="cong-no-hero__chips">
            <span className="cong-no-hero__chip">
              <CalendarDays className="h-4 w-4" aria-hidden="true" />
              {billingPeriod ? `Kỳ: ${billingPeriod}` : "Theo bộ lọc hiện tại"}
            </span>
            <span className="cong-no-hero__chip">
              <House className="h-4 w-4" aria-hidden="true" />
              {totalElements} phòng có nợ
            </span>
            <span className="cong-no-hero__chip">
              <CircleDollarSign className="h-4 w-4" aria-hidden="true" />
              {formatCurrency(pageTotals.debt)} cần thu
            </span>
            <span className="cong-no-hero__chip">
              <AlertTriangle className="h-4 w-4" aria-hidden="true" />
              {formatCurrency(pageTotals.overdue)} quá hạn
            </span>
            <span className="cong-no-hero__chip">
              <FileText className="h-4 w-4" aria-hidden="true" />
              {pageTotals.invoices} hóa đơn chưa tất toán
            </span>
          </div>

          <div className="cong-no-hero__actions">
            <Button
              variant="outline"
              onClick={() => fetchData(true)}
              disabled={refreshing}
              className="cong-no-hero__button cong-no-hero__button-secondary"
            >
              <RefreshCw className={refreshing ? "mr-2 h-4 w-4 animate-spin" : "mr-2 h-4 w-4"} />
              {refreshing ? "Đang tải" : "Làm mới"}
            </Button>
            <Button asChild className="cong-no-hero__button cong-no-hero__button-primary">
              <Link href="/dashboard/hoa-don">
                <ReceiptText className="mr-2 h-4 w-4" />
                Xem hóa đơn cần thu
              </Link>
            </Button>
          </div>

          <div className="cong-no-hero__stats">
            <article className="cong-no-hero__stat-card is-navy">
              <div className="cong-no-hero__stat-top">
                <span>Phòng đang có nợ</span>
                <House className="h-5 w-5" aria-hidden="true" />
              </div>
              <strong>{totalElements}</strong>
              <small>Có khoản cần theo dõi</small>
            </article>
            <article className={cn("cong-no-hero__stat-card", pageTotals.debt > 0 ? "is-orange" : "is-teal")}>
              <div className="cong-no-hero__stat-top">
                <span>Tổng nợ trên trang</span>
                <CircleDollarSign className="h-5 w-5" aria-hidden="true" />
              </div>
              <strong>{formatCurrency(pageTotals.debt)}</strong>
              <small>Theo dữ liệu đang hiển thị</small>
            </article>
            <article className={cn("cong-no-hero__stat-card", pageTotals.overdue > 0 ? "is-red" : "is-teal")}>
              <div className="cong-no-hero__stat-top">
                <span>Quá hạn trên trang</span>
                <AlertTriangle className="h-5 w-5" aria-hidden="true" />
              </div>
              <strong>{formatCurrency(pageTotals.overdue)}</strong>
              <small>{pageTotals.overdue > 0 ? "Khoản cần ưu tiên liên hệ" : "Không có khoản quá hạn"}</small>
            </article>
            <article className="cong-no-hero__stat-card is-navy">
              <div className="cong-no-hero__stat-top">
                <span>Hóa đơn trên trang</span>
                <FileText className="h-5 w-5" aria-hidden="true" />
              </div>
              <strong>{pageTotals.invoices}</strong>
              <small>Hóa đơn chưa tất toán</small>
            </article>
          </div>
        </div>
      </section>

      <DashboardCard className="overflow-hidden border-0 shadow-sm ring-1 ring-[#E5E0D8]">
        <CardHeader className="border-b bg-[#F2E8DC]/70 p-5 md:p-6">
          <div className="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
            <div>
              <CardTitle className="text-lg">Danh sách cần thu</CardTitle>
              <CardDescription className="mt-1">
                Sắp xếp theo tổng nợ giảm dần. Tìm kiếm và lọc áp dụng trên toàn bộ danh sách.
              </CardDescription>
            </div>
            <div className="flex flex-col gap-2 sm:flex-row">
              <div className="relative sm:w-72">
                <Search className="absolute left-3 top-1/2 size-4 -translate-y-1/2 text-muted-foreground" />
                <Input
                  type="search"
                  placeholder="Tìm phòng, khách thuê, SĐT..."
                  className="pl-9"
                  value={search}
                  onChange={(event) => setSearch(event.target.value)}
                />
              </div>
              <Select value={debtFilter} onValueChange={setDebtFilter}>
                <SelectTrigger className="w-full sm:w-44">
                  <SelectValue placeholder="Loại công nợ" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Tất cả khoản nợ</SelectItem>
                  <SelectItem value="overdue">Có nợ quá hạn</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </CardHeader>

        <CardContent className="p-4 md:p-6">
          {data.length === 0 ? (
            <EmptyState
              title={appliedSearch || debtFilter !== "all" ? "Không có kết quả phù hợp" : "Không có công nợ"}
              description={
                appliedSearch || debtFilter !== "all"
                  ? "Thử bỏ bộ lọc hoặc đổi từ khóa tìm kiếm."
                  : "Các khoản chưa thanh toán sẽ xuất hiện tại đây."
              }
            />
          ) : (
            <>
              <div className="hidden overflow-hidden rounded-xl border md:block">
                <Table>
                  <TableHeader className="bg-[#F8F3EC]">
                    <TableRow>
                      <TableHead className="font-semibold text-[#243B5A]">Tòa nhà / Phòng</TableHead>
                      <TableHead className="font-semibold text-[#243B5A]">Khách thuê</TableHead>
                      <TableHead className="font-semibold text-[#243B5A]">Hóa đơn nợ</TableHead>
                      <TableHead className="text-right font-semibold text-[#243B5A]">Tổng nợ</TableHead>
                      <TableHead className="text-right font-semibold text-[#243B5A]">Quá hạn</TableHead>
                      <TableHead className="text-right font-semibold text-[#243B5A]">Thao tác</TableHead>
                    </TableRow>
                  </TableHeader>
                  <TableBody>
                    {data.map((item) => (
                      <TableRow key={item.phongId} className="hover:bg-[#F8F3EC]/50 transition-colors">
                        <TableCell>
                          <p className="font-medium">{item.maPhong}</p>
                          <p className="text-xs text-muted-foreground">{item.tenToaNha || "Chưa xác định tòa nhà"}</p>
                        </TableCell>
                        <TableCell>
                          <p>{item.tenKhachThue || "Chưa xác định"}</p>
                          <p className="text-xs text-muted-foreground">{item.soDienThoai || "Chưa có SĐT"}</p>
                        </TableCell>
                        <TableCell>{item.danhSachHoaDonNo.length}</TableCell>
                        <TableCell className="text-right font-semibold">{formatCurrency(item.tongNo)}</TableCell>
                        <TableCell className="text-right">
                          {item.noQuaHan > 0 ? (
                            <Badge variant="destructive">{formatCurrency(item.noQuaHan)}</Badge>
                          ) : (
                            <Badge variant="secondary">Chưa quá hạn</Badge>
                          )}
                        </TableCell>
                        <TableCell className="text-right">
                          <Button variant="outline" size="sm" onClick={() => setSelectedDebt(item)}>
                            Chi tiết
                          </Button>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>

              <div className="space-y-3 md:hidden">
                {data.map((item) => (
                  <article key={item.phongId} className="rounded-xl border bg-card p-4">
                    <div className="flex items-start justify-between gap-3">
                      <div>
                        <p className="font-medium">{item.maPhong}</p>
                        <p className="text-sm text-muted-foreground">{item.tenToaNha || "Chưa xác định tòa nhà"}</p>
                      </div>
                      {item.noQuaHan > 0 ? (
                        <Badge variant="destructive">Quá hạn</Badge>
                      ) : (
                        <Badge variant="secondary">Chưa quá hạn</Badge>
                      )}
                    </div>
                    <div className="mt-4 grid grid-cols-2 gap-3 border-y py-3 text-sm">
                      <div>
                        <p className="text-xs text-muted-foreground">Khách thuê</p>
                        <p className="mt-1 truncate">{item.tenKhachThue || "Chưa xác định"}</p>
                      </div>
                      <div>
                        <p className="text-xs text-muted-foreground">Số hóa đơn</p>
                        <p className="mt-1">{item.danhSachHoaDonNo.length}</p>
                      </div>
                      <div>
                        <p className="text-xs text-muted-foreground">Tổng nợ</p>
                        <p className="mt-1 font-semibold">{formatCurrency(item.tongNo)}</p>
                      </div>
                      <div>
                        <p className="text-xs text-muted-foreground">Quá hạn</p>
                        <p className="mt-1 font-semibold text-red-600">{formatCurrency(item.noQuaHan)}</p>
                      </div>
                    </div>
                    <Button className="mt-4 w-full" variant="outline" onClick={() => setSelectedDebt(item)}>
                      Xem khoản nợ
                    </Button>
                  </article>
                ))}
              </div>
            </>
          )}

          {totalPages > 0 ? (
            <div className="mt-6 flex flex-col gap-3 border-t pt-4 sm:flex-row sm:items-center sm:justify-between">
              <p className="text-sm text-muted-foreground">
                Hiển thị {data.length} trong {totalElements} phòng có nợ
              </p>
              <div className="flex items-center justify-between gap-3 sm:justify-end">
                <Select
                  value={String(pagination.pageSize)}
                  onValueChange={(value) =>
                    setPagination({ pageIndex: 0, pageSize: Number(value) })
                  }
                >
                  <SelectTrigger size="sm" className="w-24">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent side="top">
                    {[10, 20, 50].map((pageSize) => (
                      <SelectItem key={pageSize} value={String(pageSize)}>
                        {pageSize} dòng
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                <span className="text-sm font-medium">
                  Trang {pagination.pageIndex + 1} / {totalPages}
                </span>
                <div className="flex gap-1">
                  <Button
                    variant="outline"
                    size="icon-sm"
                    onClick={() =>
                      setPagination((current) => ({ ...current, pageIndex: current.pageIndex - 1 }))
                    }
                    disabled={pagination.pageIndex === 0}
                  >
                    <ChevronLeft />
                    <span className="sr-only">Trang trước</span>
                  </Button>
                  <Button
                    variant="outline"
                    size="icon-sm"
                    onClick={() =>
                      setPagination((current) => ({ ...current, pageIndex: current.pageIndex + 1 }))
                    }
                    disabled={pagination.pageIndex + 1 >= totalPages}
                  >
                    <ChevronRight />
                    <span className="sr-only">Trang sau</span>
                  </Button>
                </div>
              </div>
            </div>
          ) : null}
        </CardContent>
      </DashboardCard>

      <Dialog open={Boolean(selectedDebt)} onOpenChange={(open) => !open && setSelectedDebt(null)}>
        <DialogContent className="max-h-[90vh] overflow-y-auto sm:max-w-2xl">
          <DialogHeader>
            <DialogTitle>
              {selectedDebt?.maPhong} - {selectedDebt?.tenKhachThue || "Khách thuê"}
            </DialogTitle>
            <DialogDescription>
              Các hóa đơn chưa tất toán thuộc phòng này. Việc gửi nhắc nợ cần endpoint thông báo riêng.
            </DialogDescription>
          </DialogHeader>

          <div className="grid grid-cols-2 gap-3 rounded-xl bg-muted/60 p-4 text-sm">
            <div>
              <p className="text-muted-foreground">Tổng cần thu</p>
              <p className="mt-1 font-semibold">{formatCurrency(selectedDebt?.tongNo || 0)}</p>
            </div>
            <div>
              <p className="text-muted-foreground">Đã quá hạn</p>
              <p className="mt-1 font-semibold text-red-600">{formatCurrency(selectedDebt?.noQuaHan || 0)}</p>
            </div>
          </div>

          <div className="space-y-3">
            {selectedDebt?.danhSachHoaDonNo.map((hoaDon) => (
              <div key={hoaDon.id || hoaDon._id} className="rounded-xl border p-4">
                <div className="flex flex-wrap items-start justify-between gap-2">
                  <div>
                    <p className="font-medium">{hoaDon.maHoaDon}</p>
                    <p className="text-sm text-muted-foreground">
                      Kỳ {hoaDon.thang}/{hoaDon.nam} · Hạn {formatDate(hoaDon.hanThanhToan || hoaDon.hanTra)}
                    </p>
                  </div>
                  <InvoiceStatus status={hoaDon.trangThai} />
                </div>
                <div className="mt-4 flex items-center justify-between border-t pt-3">
                  <span className="text-sm text-muted-foreground">Còn phải thu</span>
                  <div className="flex items-center gap-3">
                    <span className="font-semibold">{formatCurrency(getOutstandingAmount(hoaDon))}</span>
                    <Button
                      size="sm"
                      variant="secondary"
                      onClick={async () => {
                        try {
                          const res = await fetch(`/api/debt-reminders/invoice/${hoaDon._id || hoaDon.id}/manual`, {
                            method: "POST",
                            headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
                          })
                          const result = await res.json()
                          if (result.success) {
                            alert("Đã gửi nhắc nợ thành công")
                          } else {
                            alert(result.message || "Gửi nhắc nợ thất bại")
                          }
                        } catch (err) {
                          alert("Lỗi khi gửi nhắc nợ")
                        }
                      }}
                    >
                      Nhắc nợ
                    </Button>
                    <Button asChild size="sm" variant="outline">
                      <Link href={`/dashboard/hoa-don/${hoaDon._id || hoaDon.id}`}>Mở hóa đơn</Link>
                    </Button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
