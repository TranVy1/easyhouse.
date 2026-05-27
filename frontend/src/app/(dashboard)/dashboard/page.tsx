"use client"

import { useCallback, useEffect, useState } from "react"
import Link from "next/link"
import { useSession } from "next-auth/react"
import {
  AlertTriangle,
  ArrowRight,
  CalendarClock,
  CircleDollarSign,
  ClipboardCheck,
  DoorOpen,
  FilePlus2,
  Gauge,
  ReceiptText,
  RefreshCw,
  Wrench,
} from "lucide-react"

import {
  DashboardPageHeader,
  DashboardSkeleton,
  EmptyState,
  ErrorState,
  MetricCard,
  QuickAction,
} from "@/components/dashboard/dashboard-ui"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import type { ApiResponse, AuditLog, DashboardStats } from "@/types"

type OperationalStats = DashboardStats & {
  tongKhachDangThue?: number
  tienDaThu?: number
  tienChuaThu?: number
}

type AuditPage = { content?: AuditLog[] }

function formatCurrency(amount?: number) {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
    maximumFractionDigits: 0,
  }).format(amount || 0)
}

function formatDate(value?: string | Date | null) {
  if (!value) return ""
  return new Date(value).toLocaleString("vi-VN", {
    hour: "2-digit",
    minute: "2-digit",
    day: "2-digit",
    month: "2-digit",
  })
}

export default function DashboardPage() {
  const { data: session } = useSession()
  const role = session?.user?.role?.replace(/^ROLE_/, "").toUpperCase()
  const [stats, setStats] = useState<OperationalStats | null>(null)
  const [recentLogs, setRecentLogs] = useState<AuditLog[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    document.title = "Tổng quan vận hành | EasyHouse"
  }, [])

  const fetchData = useCallback(async () => {
    setLoading(true)
    setError(null)

    try {
      const statsResponse = await fetch("/api/dashboard/stats", {
        headers: { Authorization: `Bearer ${session?.accessToken}` },
      })
      const statsResult: ApiResponse<OperationalStats> = await statsResponse.json()
      if (!statsResponse.ok || !statsResult.success || !statsResult.data) {
        throw new Error(statsResult.message || "Không lấy được số liệu tổng quan.")
      }
      setStats(statsResult.data)

      if (role === "ADMIN") {
        const logsResponse = await fetch("/api/audit-log?size=5", {
          headers: { Authorization: `Bearer ${session?.accessToken}` },
        })
        if (logsResponse.ok) {
          const logsResult: ApiResponse<AuditPage> = await logsResponse.json()
          setRecentLogs(logsResult.data?.content || [])
        }
      } else {
        setRecentLogs([])
      }
    } catch (requestError) {
      setStats(null)
      setError(requestError instanceof Error ? requestError.message : "Không thể kết nối máy chủ.")
    } finally {
      setLoading(false)
    }
  }, [role, session?.accessToken])

  useEffect(() => {
    fetchData()
  }, [fetchData])

  if (loading) return <DashboardSkeleton />

  if (error || !stats) {
    return (
      <ErrorState
        description={error || "Không có dữ liệu tổng quan để hiển thị."}
        onRetry={fetchData}
      />
    )
  }

  const occupancyRate =
    stats.tongSoPhong > 0 ? Math.round((stats.phongDangThue / stats.tongSoPhong) * 100) : 0

  const taskItems = [
    {
      title: "Hóa đơn sắp đến hạn",
      value: stats.hoaDonSapDenHan,
      href: "/dashboard/hoa-don",
      description: "Kiểm tra và gửi nhắc thanh toán",
      tone: "bg-amber-50 text-amber-700 dark:bg-amber-950/40 dark:text-amber-300",
    },
    {
      title: "Hợp đồng sắp hết hạn",
      value: stats.hopDongSapHetHan,
      href: "/dashboard/hop-dong",
      description: "Trao đổi gia hạn hoặc kết thúc",
      tone: "bg-blue-50 text-blue-700 dark:bg-blue-950/40 dark:text-blue-300",
    },
    {
      title: "Sự cố cần xử lý",
      value: stats.suCoCanXuLy,
      href: "/dashboard/su-co",
      description: "Ưu tiên xử lý yêu cầu đang mở",
      tone: "bg-red-50 text-red-700 dark:bg-red-950/40 dark:text-red-300",
    },
  ]

  return (
    <div className="space-y-6 lg:space-y-8">
      <DashboardPageHeader
        eyebrow="Điều hành"
        title="Tổng quan vận hành"
        description="Theo dõi thu tiền, công suất phòng và các việc cần xử lý trong một nơi."
        actions={
          <>
            <Button variant="outline" onClick={fetchData}>
              <RefreshCw />
              Làm mới
            </Button>
            <Button asChild>
              <Link href="/dashboard/hoa-don/them-moi">
                <FilePlus2 />
                Tạo hóa đơn
              </Link>
            </Button>
          </>
        }
      />

      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <MetricCard
          label="Phòng đang thuê"
          value={`${stats.phongDangThue}/${stats.tongSoPhong}`}
          hint={`${occupancyRate}% tỷ lệ lấp đầy`}
          icon={DoorOpen}
          tone="default"
        />
        <MetricCard
          label="Đã thu tháng này"
          value={formatCurrency(stats.tienDaThu ?? stats.doanhThuThang)}
          hint="Giao dịch đã ghi nhận"
          icon={CircleDollarSign}
          tone="success"
        />
        <MetricCard
          label="Tiền chưa thu"
          value={formatCurrency(stats.tienChuaThu ?? stats.tongCongNo)}
          hint="Cần theo dõi công nợ"
          icon={ReceiptText}
          tone={(stats.tienChuaThu ?? stats.tongCongNo ?? 0) > 0 ? "warning" : "success"}
        />
        <MetricCard
          label="Sự cố đang mở"
          value={stats.suCoCanXuLy}
          hint="Yêu cầu cần phản hồi"
          icon={AlertTriangle}
          tone={stats.suCoCanXuLy > 0 ? "danger" : "success"}
        />
      </div>

      <div className="grid gap-4 xl:grid-cols-[1.45fr_1fr]">
        <Card className="gap-0 py-0">
          <CardHeader className="border-b p-5 md:p-6">
            <CardTitle className="text-lg">Việc cần xử lý</CardTitle>
            <CardDescription>Truy cập nhanh các đầu việc ảnh hưởng đến thu tiền và cư trú.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-3 p-4 md:p-6">
            {taskItems.map((item) => (
              <Link
                key={item.title}
                href={item.href}
                className="flex items-center gap-4 rounded-xl border p-4 transition-colors hover:border-primary/25 hover:bg-accent/40"
              >
                <div className={`flex size-11 shrink-0 items-center justify-center rounded-xl text-lg font-semibold ${item.tone}`}>
                  {item.value}
                </div>
                <div className="min-w-0 flex-1">
                  <p className="font-medium">{item.title}</p>
                  <p className="truncate text-sm text-muted-foreground">{item.description}</p>
                </div>
                <ArrowRight className="size-4 text-muted-foreground" />
              </Link>
            ))}
          </CardContent>
        </Card>

        <Card className="gap-0 py-0">
          <CardHeader className="border-b p-5 md:p-6">
            <CardTitle className="text-lg">Sử dụng phòng</CardTitle>
            <CardDescription>Tình trạng phòng tại thời điểm hiện tại.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-5 p-5 md:p-6">
            <div>
              <div className="mb-2 flex justify-between text-sm">
                <span className="font-medium">Tỷ lệ lấp đầy</span>
                <span className="text-muted-foreground">{occupancyRate}%</span>
              </div>
              <div className="h-2.5 overflow-hidden rounded-full bg-muted">
                <div className="h-full rounded-full bg-primary" style={{ width: `${occupancyRate}%` }} />
              </div>
            </div>
            {[
              { label: "Đang thuê", amount: stats.phongDangThue, color: "bg-primary" },
              { label: "Còn trống", amount: stats.phongTrong, color: "bg-emerald-500" },
              { label: "Bảo trì", amount: stats.phongBaoTri, color: "bg-amber-500" },
            ].map((roomStatus) => (
              <div key={roomStatus.label} className="flex items-center justify-between text-sm">
                <div className="flex items-center gap-2">
                  <span className={`size-2.5 rounded-full ${roomStatus.color}`} />
                  <span className="text-muted-foreground">{roomStatus.label}</span>
                </div>
                <span className="font-medium">{roomStatus.amount} phòng</span>
              </div>
            ))}
            <div className="rounded-lg bg-muted/60 px-3 py-2 text-sm text-muted-foreground">
              <Gauge className="mr-2 inline size-4" />
              Tổng cộng {stats.tongSoPhong} phòng đang quản lý.
            </div>
          </CardContent>
        </Card>
      </div>

      <section className="space-y-3">
        <h2 className="text-lg font-semibold">Thao tác nhanh</h2>
        <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
          <QuickAction
            href="/dashboard/chi-so-dien-nuoc"
            title="Ghi chỉ số"
            description="Chốt điện nước cho kỳ mới."
            icon={ClipboardCheck}
          />
          <QuickAction
            href="/dashboard/hop-dong/them-moi"
            title="Tạo hợp đồng"
            description="Đưa khách vào phòng trống."
            icon={CalendarClock}
          />
          <QuickAction
            href="/dashboard/cong-no"
            title="Theo dõi công nợ"
            description="Kiểm tra khoản còn thiếu."
            icon={CircleDollarSign}
          />
          <QuickAction
            href="/dashboard/su-co"
            title="Xử lý sự cố"
            description="Xem yêu cầu bảo trì mới."
            icon={Wrench}
          />
        </div>
      </section>

      {role === "ADMIN" ? (
        <Card className="gap-0 py-0">
          <CardHeader className="border-b p-5 md:p-6">
            <div className="flex items-center justify-between gap-4">
              <div>
                <CardTitle className="text-lg">Hoạt động gần đây</CardTitle>
                <CardDescription className="mt-1">Nhật ký mới nhất dành cho quản trị viên.</CardDescription>
              </div>
              <Button asChild variant="ghost" size="sm">
                <Link href="/dashboard/audit-log">
                  Xem tất cả
                  <ArrowRight />
                </Link>
              </Button>
            </div>
          </CardHeader>
          <CardContent className="p-4 md:p-6">
            {recentLogs.length === 0 ? (
              <EmptyState title="Chưa có hoạt động mới" description="Nhật ký thao tác sẽ xuất hiện tại đây." />
            ) : (
              <div className="divide-y">
                {recentLogs.map((log) => (
                  <div key={log.id || log._id} className="flex items-center gap-3 py-3 first:pt-0 last:pb-0">
                    <div className="min-w-0 flex-1">
                      <p className="truncate text-sm font-medium">{log.hanhDong}</p>
                      <p className="text-xs text-muted-foreground">
                        {log.nguoiDungHoTen || "Hệ thống"} · {formatDate(log.taoLuc)}
                      </p>
                    </div>
                    <Badge variant="secondary">{log.bangTacDong || "Hệ thống"}</Badge>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>
      ) : null}
    </div>
  )
}
