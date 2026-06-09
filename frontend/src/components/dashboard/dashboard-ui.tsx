import Link from "next/link"
import type { ReactNode } from "react"
import type { LucideIcon } from "lucide-react"
import { AlertCircle, ArrowRight, Inbox } from "lucide-react"

import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { cn } from "@/lib/utils"

type MetricTone = "default" | "success" | "warning" | "danger"

const metricTones: Record<MetricTone, string> = {
  default: "bg-indigo-50/50 border border-indigo-100/80 text-indigo-600 dark:bg-indigo-950/20 dark:border-indigo-900/40 dark:text-indigo-400",
  success: "bg-emerald-50/50 border border-emerald-100/80 text-emerald-700 dark:bg-emerald-950/20 dark:border-emerald-900/40 dark:text-emerald-400",
  warning: "bg-amber-50/50 border border-amber-100/80 text-amber-700 dark:bg-amber-950/20 dark:border-amber-900/40 dark:text-amber-400",
  danger: "bg-red-50/50 border border-red-100/80 text-red-700 dark:bg-red-950/20 dark:border-red-900/40 dark:text-red-400",
}

export function DashboardPageHeader({
  eyebrow,
  title,
  description,
  actions,
}: {
  eyebrow?: string
  title: string
  description: string
  actions?: ReactNode
}) {
  return (
    <div className="flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
      <div className="space-y-1">
        {eyebrow ? (
          <p className="text-xs font-semibold uppercase tracking-[0.14em] text-primary">{eyebrow}</p>
        ) : null}
        <h1 className="text-2xl font-semibold tracking-tight text-foreground md:text-3xl">{title}</h1>
        <p className="max-w-2xl text-sm text-muted-foreground md:text-base">{description}</p>
      </div>
      {actions ? <div className="flex flex-wrap gap-2">{actions}</div> : null}
    </div>
  )
}

export function MetricCard({
  label,
  value,
  hint,
  icon: Icon,
  tone = "default",
}: {
  label: string
  value: string | number
  hint: string
  icon: LucideIcon
  tone?: MetricTone
}) {
  return (
    <Card className="gap-0 border-border/60 py-0 shadow-xs hover:shadow-md hover:border-slate-300/60 dark:hover:border-slate-700/60 transition-all duration-300 hover:-translate-y-0.5 group">
      <CardContent className="p-5">
        <div className="flex items-start justify-between gap-3">
          <div className="min-w-0 space-y-2">
            <p className="text-sm font-medium text-slate-500 dark:text-slate-400">{label}</p>
            <p className="truncate text-2xl font-bold tracking-tight text-slate-900 dark:text-slate-50">{value}</p>
            <p className="text-xs text-muted-foreground">{hint}</p>
          </div>
          <div className={cn("rounded-2xl p-3 shadow-2xs transition-transform duration-300 group-hover:scale-110", metricTones[tone])}>
            <Icon className="size-5" />
          </div>
        </div>
      </CardContent>
    </Card>
  )
}

export function QuickAction({
  href,
  title,
  description,
  icon: Icon,
}: {
  href: string
  title: string
  description: string
  icon: LucideIcon
}) {
  return (
    <Link
      href={href}
      className="group flex min-h-24 items-start gap-4 rounded-2xl border border-border/70 bg-card p-4 transition-all duration-300 hover:border-primary/25 hover:bg-slate-50/30 hover:shadow-md hover:-translate-y-0.5"
    >
      <div className="rounded-xl bg-primary/5 p-3 text-primary border border-primary/5 group-hover:bg-primary/10 group-hover:border-primary/10 transition-colors shadow-2xs">
        <Icon className="size-5" />
      </div>
      <div className="min-w-0 flex-1">
        <p className="text-sm font-semibold text-slate-800 dark:text-slate-100 group-hover:text-primary transition-colors">{title}</p>
        <p className="mt-1.5 text-xs leading-5 text-muted-foreground">{description}</p>
      </div>
      <ArrowRight className="mt-1.5 size-4 text-muted-foreground transition-all duration-300 group-hover:translate-x-1 group-hover:text-primary" />
    </Link>
  )
}

export function DashboardSkeleton() {
  return (
    <div className="space-y-6" aria-label="Đang tải dữ liệu">
      <div className="h-20 animate-pulse rounded-xl bg-muted" />
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        {Array.from({ length: 4 }, (_, index) => (
          <div key={index} className="h-32 animate-pulse rounded-xl bg-muted" />
        ))}
      </div>
      <div className="grid gap-4 lg:grid-cols-3">
        <div className="h-80 animate-pulse rounded-xl bg-muted lg:col-span-2" />
        <div className="h-80 animate-pulse rounded-xl bg-muted" />
      </div>
    </div>
  )
}

export function ErrorState({
  title = "Không thể tải dữ liệu",
  description,
  onRetry,
}: {
  title?: string
  description: string
  onRetry?: () => void
}) {
  return (
    <Card className="border-dashed py-0 shadow-none">
      <CardContent className="flex flex-col items-center gap-3 p-8 text-center">
        <div className="rounded-full bg-red-50 p-3 text-red-600 dark:bg-red-950/40 dark:text-red-300">
          <AlertCircle className="size-6" />
        </div>
        <div>
          <p className="font-medium">{title}</p>
          <p className="mt-1 text-sm text-muted-foreground">{description}</p>
        </div>
        {onRetry ? (
          <Button variant="outline" onClick={onRetry}>
            Thử lại
          </Button>
        ) : null}
      </CardContent>
    </Card>
  )
}

export function EmptyState({
  title,
  description,
}: {
  title: string
  description: string
}) {
  return (
    <div className="flex flex-col items-center gap-2 py-8 text-center">
      <Inbox className="size-8 text-muted-foreground/60" />
      <p className="text-sm font-medium">{title}</p>
      <p className="max-w-sm text-sm text-muted-foreground">{description}</p>
    </div>
  )
}
