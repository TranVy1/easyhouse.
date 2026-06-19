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
  TrendingUp,
} from "lucide-react"

import {
  DashboardPageHeader,
  DashboardSkeleton,
  ErrorState,
  MetricCard,
  QuickAction,
  EmptyState
} from "@/components/dashboard/dashboard-ui"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import type { ApiResponse, AuditLog } from "@/types"

import { RevenueChart } from "@/components/dashboard/RevenueChart"
import { DebtAgingChart } from "@/components/dashboard/DebtAgingChart"
import { TopDebtorsTable } from "@/components/dashboard/TopDebtorsTable"
import { ActionItemsPanel } from "@/components/dashboard/ActionItemsPanel"

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
  
  const [overview, setOverview] = useState<AnalyticsOverview | null>(null)
  const [revenueData, setRevenueData] = useState<any[]>([])
  const [debtAgingData, setDebtAgingData] = useState<any>(null)
  const [topDebtors, setTopDebtors] = useState<any[]>([])
  const [recentLogs, setRecentLogs] = useState<AuditLog[]>([])
  
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    document.title = "Analytics | EasyHouse"
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

      const [overviewRes, revRes, debtRes, debtorsRes] = await Promise.all([
        fetch("/api/dashboard/analytics/overview", { headers }),
        fetch("/api/dashboard/analytics/revenue-chart?months=12", { headers }),
        fetch("/api/dashboard/analytics/debt-aging", { headers }),
        fetch("/api/dashboard/analytics/top-debtors?limit=5", { headers })
      ]);

      const oData = await parseRes(overviewRes, "overview");
      const rData = await parseRes(revRes, "revenue");
      const dData = await parseRes(debtRes, "debt");
      const tdData = await parseRes(debtorsRes, "debtors");

      if (oData.success) setOverview(oData.data);
      if (rData.success) setRevenueData(rData.data);
      if (dData.success) setDebtAgingData(dData.data);
      if (tdData.success) setTopDebtors(tdData.data);

      if (role === "ADMIN") {
        const logsResponse = await fetch("/api/audit-log?size=5", { headers })
        if (logsResponse.ok) {
          const logsResult = await logsResponse.json()
          setRecentLogs(logsResult.data?.content || [])
        }
      }
    } catch (requestError) {
      setError(requestError instanceof Error ? requestError.message : "Không thể kết nối máy chủ.")
    } finally {
      setLoading(false)
    }
  }, [role, session?.accessToken])

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

  const taskItems = [
    {
      title: "Hóa đơn quá hạn",
      value: overview.overdueInvoiceCount,
      href: "/dashboard/cong-no",
      description: "Hóa đơn đã quá hạn cần nhắc thanh toán",
      tone: "bg-amber-50 text-amber-700 dark:bg-amber-950/40 dark:text-amber-300",
    },
    {
      title: "Hợp đồng sắp hết hạn",
      value: overview.expiringContractCount,
      href: "/dashboard/hop-dong",
      description: "Hợp đồng sắp hết hạn trong 30 ngày tới",
      tone: "bg-[#4FA7A0]/10 text-[#243B5A] dark:bg-[#243B5A]/35 dark:text-[#8CCBC5]",
    },
    {
      title: "Sự cố đang mở",
      value: overview.openIncidentCount,
      href: "/dashboard/su-co",
      description: "Sự cố người thuê báo cáo chưa xử lý",
      tone: "bg-red-50 text-red-700 dark:bg-red-950/40 dark:text-red-300",
    },
  ]

  return (
    <div className="space-y-6 lg:space-y-8">
      <DashboardPageHeader
        eyebrow="Dashboard Analytics"
        title="Phân tích tài chính & Vận hành"
        description="Theo dõi chi tiết dòng tiền, công nợ và tình hình kinh doanh."
        actions={
          <>
            <Button variant="outline" onClick={fetchData}>
              <RefreshCw className="mr-2 h-4 w-4" />
              Làm mới
            </Button>
            <Button asChild>
              <Link href="/dashboard/hoa-don/them-moi">
                <FilePlus2 className="mr-2 h-4 w-4" />
                Tạo hóa đơn
              </Link>
            </Button>
          </>
        }
      />

      {/* TỔNG QUAN */}
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <MetricCard
          label="Tỷ lệ thu tiền tháng này"
          value={`${overview.collectionRate.toFixed(1)}%`}
          hint={`Phải thu: ${formatCurrency(overview.expectedRevenueThisMonth)}`}
          icon={TrendingUp}
          tone={overview.collectionRate >= 90 ? "success" : "warning"}
        />
        <MetricCard
          label="Đã thu tháng này"
          value={formatCurrency(overview.collectedThisMonth)}
          hint="Thực thu từ khách"
          icon={CircleDollarSign}
          tone="success"
        />
        <MetricCard
          label="Còn nợ tháng này"
          value={formatCurrency(overview.outstandingThisMonth)}
          hint="Số tiền chưa thanh toán"
          icon={ReceiptText}
          tone={overview.outstandingThisMonth > 0 ? "danger" : "default"}
        />
        <MetricCard
          label="Phòng đang thuê"
          value={`${overview.occupiedRooms}/${overview.totalRooms}`}
          hint={`${overview.occupancyRate.toFixed(1)}% tỷ lệ lấp đầy`}
          icon={DoorOpen}
          tone="default"
        />
      </div>

      {/* BIỂU ĐỒ TÀI CHÍNH */}
      <div className="grid gap-4 md:grid-cols-7">
        <div className="col-span-4">
          <RevenueChart data={revenueData} />
        </div>
        <div className="col-span-3">
          <DebtAgingChart data={debtAgingData} />
        </div>
      </div>

      {/* CẢNH BÁO BẤT THƯỜNG */}
      <div className="grid gap-4">
        <ActionItemsPanel />
      </div>

      {/* HOẠT ĐỘNG VẬN HÀNH */}
      <div className="grid gap-4 xl:grid-cols-[1.4fr_1fr]">
        <Card className="col-span-1 border-t-4 border-t-orange-400">
          <CardHeader className="border-b p-5 md:p-6">
            <CardTitle className="text-lg">Việc cần xử lý ngay</CardTitle>
            <CardDescription>Các sự kiện cần sự can thiệp của người quản lý.</CardDescription>
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

        <TopDebtorsTable data={topDebtors} />
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
        <Card className="gap-0 py-0 mt-8">
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
