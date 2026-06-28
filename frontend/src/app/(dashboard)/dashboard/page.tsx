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
  Activity,
  Clock,
  Edit,
  Trash2,
  LogIn,
  Plus,
  Eye,
  Download,
  CheckCircle2,
} from "lucide-react"

import {
  DashboardSkeleton,
  ErrorState,
  QuickAction,
  EmptyState,
} from "@/components/dashboard/dashboard-ui"
import {
  DashboardHero,
  DashboardKpiCard,
  HeroActionButton,
} from "@/components/dashboard/shared-ui"
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

/* ── Activity log helpers ── */

const actionIconMap: Record<string, typeof Activity> = {
  LOGIN: LogIn,
  CREATE: Plus,
  UPDATE: Edit,
  DELETE: Trash2,
  VIEW: Eye,
}

const actionColorMap: Record<string, string> = {
  LOGIN:  "bg-[#E6F3F1] text-[#4FA7A0]",
  CREATE: "bg-[#4FA7A0]/10 text-[#267D76]",
  UPDATE: "bg-[#F2A45B]/10 text-[#D4893A]",
  DELETE: "bg-[#C75345]/8 text-[#C75345]",
  VIEW:   "bg-[#243B5A]/8 text-[#243B5A]",
}

function getActionInfo(action: string) {
  const upper = action?.toUpperCase() || ""
  for (const key of Object.keys(actionIconMap)) {
    if (upper.includes(key)) {
      return { Icon: actionIconMap[key], color: actionColorMap[key] }
    }
  }
  return { Icon: Activity, color: "bg-[#E6F3F1] text-[#4FA7A0]" }
}

/* ── Health Score ── */

function computeHealthScore(overview: AnalyticsOverview) {
  // Collection rate contributes 40%
  const collectionScore = Math.min(overview.collectionRate, 100) * 0.4
  // Occupancy rate contributes 35%
  const occupancyScore = Math.min(overview.occupancyRate, 100) * 0.35
  // Incidents penalty: max 25%, each open incident costs 5 points
  const incidentPenalty = Math.min(overview.openIncidentCount * 5, 25)
  const incidentScore = 25 - incidentPenalty

  const total = Math.round(collectionScore + occupancyScore + incidentScore)
  const clamped = Math.max(0, Math.min(100, total))

  let status: string
  let statusColor: string
  if (clamped >= 85) { status = "Tốt"; statusColor = "text-[#4FA7A0]" }
  else if (clamped >= 65) { status = "Khá"; statusColor = "text-[#F2A45B]" }
  else { status = "Cần cải thiện"; statusColor = "text-[#C75345]" }

  return { score: clamped, status, statusColor }
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

  const userName = session?.user?.name || "Quản trị viên"
  const currentMonth = new Date().toLocaleDateString("vi-VN", { month: "long", year: "numeric" })
  const health = computeHealthScore(overview)

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
      {/* ── HERO ── */}
      <DashboardHero
        variant="image"
        icon={Activity}
        title="Phân tích tài chính & Vận hành"
        description="Theo dõi chi tiết dòng tiền, công nợ và tình hình kinh doanh."
        stats={
          <>
            <span className="dashboard-hero__chip">
              <Clock className="size-3.5" aria-hidden="true" />
              Kỳ: {currentMonth}
            </span>
            <span className="dashboard-hero__chip">
              <DoorOpen className="size-3.5" aria-hidden="true" />
              {overview.totalRooms} phòng
            </span>
          </>
        }
        actions={
          <>
            <HeroActionButton onClick={fetchData} variant="secondary" className="dashboard-hero__button dashboard-hero__button-secondary">
              <RefreshCw className="h-4 w-4 sm:mr-2 inline-block" />
              <span className="hidden sm:inline">Làm mới</span>
            </HeroActionButton>
            <HeroActionButton href="/dashboard/bao-cao" variant="secondary" className="dashboard-hero__button dashboard-hero__button-secondary">
              <Download className="h-4 w-4 sm:mr-2 inline-block" />
              <span className="hidden sm:inline">Xuất báo cáo</span>
            </HeroActionButton>
            <HeroActionButton href="/dashboard/hoa-don/them-moi" variant="default" className="dashboard-hero__button dashboard-hero__button-primary">
              <FilePlus2 className="h-4 w-4 sm:mr-2 inline-block" />
              <span className="hidden sm:inline">Tạo hóa đơn</span>
            </HeroActionButton>
          </>
        }
      />

      {/* ── KPI CARDS ── */}
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4 animate-fade-in-up-d1">
        <DashboardKpiCard
          title="Tỷ lệ thu tiền tháng này"
          value={`${overview.collectionRate.toFixed(1)}%`}
          icon={<TrendingUp className="h-5 w-5" />}
          tone={overview.collectionRate >= 90 ? "emerald" : "orange"}
          trend={{ value: `Phải thu: ${formatCurrency(overview.expectedRevenueThisMonth)}`, isUp: overview.collectionRate >= 90 }}
        />
        <DashboardKpiCard
          title="Đã thu tháng này"
          value={formatCurrency(overview.collectedThisMonth)}
          icon={<CircleDollarSign className="h-5 w-5" />}
          tone="emerald"
          trend={{ value: "Thực thu từ khách", isUp: true }}
        />
        <DashboardKpiCard
          title="Còn nợ tháng này"
          value={formatCurrency(overview.outstandingThisMonth)}
          icon={<ReceiptText className="h-5 w-5" />}
          tone={overview.outstandingThisMonth > 0 ? "red" : "default"}
          trend={{ value: "Số tiền chưa thanh toán", isUp: overview.outstandingThisMonth === 0 }}
        />
        <DashboardKpiCard
          title="Phòng đang thuê"
          value={`${overview.occupiedRooms}/${overview.totalRooms}`}
          icon={<DoorOpen className="h-5 w-5" />}
          tone="blue"
          trend={{ value: `${overview.occupancyRate.toFixed(1)}% tỷ lệ lấp đầy`, isUp: overview.occupancyRate > 70 }}
        />
      </div>

      {/* ── BIỂU ĐỒ TÀI CHÍNH ── */}
      <div className="grid gap-4 md:grid-cols-7 animate-fade-in-up-d2">
        <div className="col-span-4">
          <RevenueChart data={revenueData} />
        </div>
        <div className="col-span-3">
          <DebtAgingChart data={debtAgingData} />
        </div>
      </div>

      {/* ── TRUNG TÂM VẬN HÀNH & TOP KHÁCH NỢ ── */}
      <div className="grid gap-4 xl:grid-cols-[2fr_1.1fr] animate-fade-in-up-d3">
        <ActionItemsPanel taskItems={taskItems} />
        <TopDebtorsTable data={topDebtors} />
      </div>

      {/* ── ĐIỂM VẬN HÀNH + THAO TÁC NHANH ── */}
      <div className="grid gap-4 lg:grid-cols-[1fr_2fr] animate-fade-in-up-d5">
        {/* Health Score Card */}
        <Card className="border-border/60 shadow-sm overflow-hidden rounded-2xl">
          <CardHeader className="pb-3 border-b bg-gradient-to-r from-[#E6F3F1]/50 to-transparent">
            <div className="flex items-center gap-2">
              <div className="rounded-lg bg-[#4FA7A0]/10 p-1.5">
                <Gauge className="size-4 text-[#4FA7A0]" />
              </div>
              <CardTitle className="text-base text-[#243B5A]">Tình hình vận hành</CardTitle>
            </div>
          </CardHeader>
          <CardContent className="p-5 space-y-5">
            {/* Score display */}
            <div className="flex items-center justify-center gap-6 py-2">
              <div className="relative flex size-24 items-center justify-center">
                <svg className="size-24 -rotate-90 drop-shadow-sm" viewBox="0 0 80 80">
                  <circle cx="40" cy="40" r="34" fill="none" stroke="#E8DED2" strokeWidth="6" />
                  <circle
                    cx="40" cy="40" r="34" fill="none"
                    stroke={health.score >= 85 ? "#4FA7A0" : health.score >= 65 ? "#F2A45B" : "#C75345"}
                    strokeWidth="6"
                    strokeLinecap="round"
                    strokeDasharray={`${(health.score / 100) * 213.6} 213.6`}
                    className="transition-all duration-1000 ease-out"
                  />
                </svg>
                <div className="absolute flex flex-col items-center justify-center">
                  <span className="text-2xl font-black text-[#243B5A] tracking-tighter">{health.score}</span>
                  <span className="text-[10px] uppercase font-bold text-[#6B7A8C] tracking-wider mt-0.5">Điểm</span>
                </div>
              </div>
              <div className="space-y-1">
                <p className={`text-xl font-bold ${health.statusColor}`}>{health.status}</p>
                <p className="text-sm text-[#6B7A8C] leading-snug">
                  Hệ thống đang hoạt động {health.status.toLowerCase()} dựa trên dữ liệu thu tiền và lấp đầy.
                </p>
              </div>
            </div>
            {/* Factor breakdown */}
            <div className="space-y-3 rounded-xl bg-[#F8F3EC]/50 p-4 border border-[#E8DED2]/50">
              <HealthFactor
                label="Thu tiền"
                value={`${overview.collectionRate.toFixed(0)}%`}
                good={overview.collectionRate >= 80}
              />
              <HealthFactor
                label="Lấp đầy"
                value={`${overview.occupancyRate.toFixed(0)}%`}
                good={overview.occupancyRate >= 80}
              />
              <HealthFactor
                label="Sự cố mở"
                value={`${overview.openIncidentCount}`}
                good={overview.openIncidentCount === 0}
              />
            </div>
          </CardContent>
        </Card>

        {/* Quick Actions */}
        <section className="space-y-3">
          <h2 className="text-lg font-bold text-[#243B5A]">Thao tác nhanh</h2>
          <div className="grid gap-3 sm:grid-cols-2 h-[calc(100%-2rem)]">
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
      </div>

      {/* ── HOẠT ĐỘNG GẦN ĐÂY (ADMIN) ── */}
      {role === "ADMIN" ? (
        <Card className="gap-0 py-0 border-border/60 shadow-sm overflow-hidden rounded-2xl animate-fade-in-up-d6">
          <CardHeader className="border-b bg-gradient-to-r from-[#243B5A]/[0.02] to-transparent p-5 md:px-8 md:py-6">
            <div className="flex items-center justify-between gap-4">
              <div className="flex items-center gap-3">
                <div className="rounded-xl bg-[#E6F3F1] p-2">
                  <Activity className="size-5 text-[#4FA7A0]" />
                </div>
                <div>
                  <CardTitle className="text-lg text-[#243B5A]">Hoạt động gần đây</CardTitle>
                  <CardDescription className="mt-0.5">Nhật ký hệ thống theo thời gian thực.</CardDescription>
                </div>
              </div>
              <Button asChild variant="ghost" size="sm" className="text-[#4FA7A0] hover:text-[#267D76] hover:bg-[#E6F3F1] rounded-lg">
                <Link href="/dashboard/audit-log">
                  Xem tất cả
                  <ArrowRight className="ml-1.5 size-4" />
                </Link>
              </Button>
            </div>
          </CardHeader>
          <CardContent className="p-0">
            {recentLogs.length === 0 ? (
              <div className="p-8">
                <EmptyState title="Chưa có hoạt động mới" description="Nhật ký thao tác sẽ xuất hiện tại đây." />
              </div>
            ) : (
              <div className="relative p-5 md:p-8">
                {/* Timeline line */}
                <div className="absolute bottom-8 left-[39px] top-8 w-px bg-border/60 md:left-[51px]" />
                
                <div className="space-y-6 relative">
                  {recentLogs.map((log) => {
                    const { Icon: LogIcon, color } = getActionInfo(log.hanhDong)
                    return (
                      <div key={log.id || log._id} className="group relative flex gap-4 md:gap-5 items-start">
                        {/* Timeline dot/icon */}
                        <div className={`relative z-10 flex size-10 shrink-0 items-center justify-center rounded-full border-4 border-white ${color} shadow-sm transition-transform duration-300 group-hover:scale-110`}>
                          <LogIcon className="size-4" />
                        </div>
                        {/* Content */}
                        <div className="flex flex-1 flex-col sm:flex-row sm:items-center justify-between gap-2 pt-1 border-b border-border/40 pb-5 group-last:border-0 group-last:pb-0">
                          <div>
                            <p className="text-sm font-semibold text-[#243B5A] group-hover:text-[#4FA7A0] transition-colors">
                              {log.hanhDong}
                            </p>
                            <div className="flex items-center gap-2 mt-1">
                              <span className="text-xs font-medium text-[#6B7A8C]">{log.nguoiDungHoTen || "Hệ thống"}</span>
                              <span className="text-xs text-border">•</span>
                              <span className="text-[11px] text-[#6B7A8C]/70">{formatDate(log.taoLuc)}</span>
                            </div>
                          </div>
                          <Badge variant="secondary" className="w-fit bg-[#F8F3EC] text-[#243B5A] border border-[#E8DED2] text-[10px] uppercase font-bold tracking-wider px-2.5 py-0.5">
                            {log.bangTacDong || "Hệ thống"}
                          </Badge>
                        </div>
                      </div>
                    )
                  })}
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      ) : null}
    </div>
  )
}

/* ── Health Factor Row ── */

function HealthFactor({ label, value, good }: { label: string; value: string; good: boolean }) {
  return (
    <div className="flex items-center justify-between text-sm">
      <span className="text-[#6B7A8C]">{label}</span>
      <span className={`font-semibold ${good ? "text-[#4FA7A0]" : "text-[#F2A45B]"}`}>
        {value}
      </span>
    </div>
  )
}
