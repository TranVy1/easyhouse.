import Link from "next/link";
import Image from "next/image";
import type { ReactNode } from "react";
import type { LucideIcon } from "lucide-react";
import { AlertCircle, ArrowRight, Inbox } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { cn } from "@/lib/utils";

/* ── Tone palette ── */

type MetricTone = "default" | "success" | "warning" | "danger";

const metricIconTones: Record<MetricTone, string> = {
  default: "bg-[#E6F3F1] text-[#4FA7A0] border border-[#4FA7A0]/15",
  success: "bg-[#E6F3F1] text-[#267D76] border border-[#4FA7A0]/20",
  warning: "bg-[#F2A45B]/10 text-[#D4893A] border border-[#F2A45B]/20",
  danger: "bg-[#C75345]/8 text-[#C75345] border border-[#C75345]/15",
};

const metricAccentBar: Record<MetricTone, string> = {
  default: "bg-[#4FA7A0]",
  success: "bg-[#4FA7A0]",
  warning: "bg-[#F2A45B]",
  danger: "bg-[#C75345]",
};

/* ── Hero Header ── */

export function DashboardPageHeader({
  eyebrow,
  title,
  description,
  greeting,
  statusChips,
  actions,
}: {
  eyebrow?: string;
  title: string;
  description: string;
  greeting?: string;
  statusChips?: ReactNode;
  actions?: ReactNode;
}) {
  return (
    <div className="group/hero relative overflow-hidden rounded-[28px] border border-white/20 bg-[radial-gradient(circle_at_88%_18%,rgba(255,180,84,0.38),transparent_26%),radial-gradient(circle_at_75%_85%,rgba(125,205,198,0.34),transparent_32%),linear-gradient(135deg,#172A45_0%,#1F5F73_48%,#4FA7A0_100%)] p-6 md:p-8 shadow-[0_18px_45px_rgba(36,59,90,0.18)] transition-all duration-300 ease-out hover:shadow-[0_24px_60px_rgba(36,59,90,0.24)] animate-fade-in-up">
      {/* Decorative shapes */}
      <div className="pointer-events-none absolute -right-8 -top-8 h-40 w-40 rounded-full bg-white/[0.04] z-0" />
      <div className="pointer-events-none absolute -bottom-12 -right-4 h-56 w-56 rounded-full bg-[#4FA7A0]/[0.08] z-0" />
      <div className="pointer-events-none absolute right-24 top-6 h-20 w-20 rounded-full bg-[#F2A45B]/[0.06] z-0" />

      {/* Image glow backgrounds */}
      <div className="pointer-events-none absolute right-12 bottom-4 hidden lg:block z-0 h-44 w-44 rounded-full bg-[#F2A45B]/30 blur-3xl transition-all duration-500 ease-out group-hover/hero:scale-125" />
      <div className="pointer-events-none absolute right-32 top-8 hidden lg:block z-0 h-52 w-52 rounded-full bg-[#7DCDC6]/20 blur-3xl transition-all duration-500 ease-out group-hover/hero:scale-110" />

      {/* Building Image */}
      <div
        className="pointer-events-none absolute right-6 bottom-[-10px] hidden lg:block z-10"
        aria-hidden="true"
      >
        <Image
          src="/images/easyhouse-hero-building-transparent.png"
          alt=""
          width={520}
          height={360}
          priority
          className="h-auto w-[260px] xl:w-[300px] 2xl:w-[480px] object-contain opacity-95 drop-shadow-[0_24px_42px_rgba(0,0,0,0.24)] transition-all duration-500 ease-out group-hover/hero:scale-[1.035] group-hover/hero:-translate-y-1.5"
        />
      </div>

      <div className="relative z-30 max-w-[620px] lg:max-w-[54%] xl:max-w-[56%]">
        <div className="space-y-2">
          {greeting ? (
            <p className="text-sm font-medium text-white/70">{greeting}</p>
          ) : eyebrow ? (
            <p className="text-xs font-semibold uppercase tracking-[0.14em] text-[#8CCBC5]">
              {eyebrow}
            </p>
          ) : null}
          <h1 className="text-2xl font-bold tracking-tight text-white md:text-3xl">
            {title}
          </h1>
          <p className="max-w-xl text-sm text-white/65 md:text-base">
            {description}
          </p>
          {statusChips ? (
            <div className="flex flex-wrap gap-2 pt-1">{statusChips}</div>
          ) : null}
        </div>
      </div>

      {actions ? (
        <div className="relative z-40 mt-6 flex flex-wrap lg:flex-nowrap items-center gap-3 lg:absolute lg:right-8 lg:bottom-8 xl:right-10 xl:bottom-9">
          {actions}
        </div>
      ) : null}
    </div>
  );
}

/* ── Status Chip ── */

export function StatusChip({ children }: { children: ReactNode }) {
  return (
    <span className="inline-flex items-center gap-1.5 rounded-full bg-white/10 px-3 py-1 text-xs font-medium text-white/80 backdrop-blur-sm border border-white/10">
      {children}
    </span>
  );
}

/* ── Metric Card ── */

export function MetricCard({
  label,
  value,
  hint,
  icon: Icon,
  tone = "default",
}: {
  label: string;
  value: string | number;
  hint: string;
  icon: LucideIcon;
  tone?: MetricTone;
}) {
  return (
    <Card className="group relative flex min-h-[118px] flex-col justify-between overflow-hidden rounded-[22px] border border-border/60 bg-white/95 p-4 shadow-[0_12px_28px_rgba(15,23,42,0.12)] transition-all duration-300 hover:-translate-y-1 hover:border-[#E8DED2] hover:shadow-[0_18px_36px_rgba(15,23,42,0.16)]">
      {/* Top accent bar */}
      <div
        className={cn(
          "absolute inset-x-0 top-0 h-[3px] opacity-80",
          metricAccentBar[tone],
        )}
      />
      
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0 flex-1">
          <p className="max-w-[150px] text-sm font-semibold leading-snug text-slate-500">
            {label}
          </p>
        </div>
        
        <div
          className={cn(
            "flex h-10 w-10 shrink-0 items-center justify-center rounded-2xl shadow-sm transition-transform duration-300 group-hover:scale-110",
            metricIconTones[tone],
          )}
        >
          <Icon className="size-5" />
        </div>
      </div>

      <div className="mt-3 min-w-0">
        <p className="max-w-full whitespace-nowrap text-[clamp(1.35rem,1.75vw,1.85rem)] font-extrabold leading-none tracking-tight text-[#243B5A] dark:text-slate-50 tabular-nums">
          {value}
        </p>

        {hint && (
          <p className="mt-2.5 text-xs font-semibold leading-snug text-slate-400">
            {hint}
          </p>
        )}
      </div>
    </Card>
  );
}

/* ── Quick Action ── */

export function QuickAction({
  href,
  title,
  description,
  icon: Icon,
}: {
  href: string;
  title: string;
  description: string;
  icon: LucideIcon;
}) {
  return (
    <Link
      href={href}
      className="group flex min-h-[5.5rem] items-start gap-4 rounded-2xl border border-border/70 bg-card p-4 transition-all duration-300 hover:border-[#4FA7A0]/25 hover:bg-[#E6F3F1]/30 hover:shadow-md hover:-translate-y-0.5"
    >
      <div className="rounded-xl bg-[#E6F3F1] p-3 text-[#4FA7A0] border border-[#4FA7A0]/10 group-hover:bg-[#4FA7A0]/15 group-hover:text-[#267D76] transition-colors duration-300 shadow-xs">
        <Icon className="size-5" />
      </div>
      <div className="min-w-0 flex-1">
        <p className="text-sm font-semibold text-[#243B5A] dark:text-slate-100 group-hover:text-[#4FA7A0] transition-colors duration-200">
          {title}
        </p>
        <p className="mt-1 text-xs leading-5 text-[#6B7A8C]">{description}</p>
      </div>
      <ArrowRight className="mt-1.5 size-4 text-[#6B7A8C]/50 transition-all duration-300 group-hover:translate-x-1 group-hover:text-[#4FA7A0]" />
    </Link>
  );
}

/* ── Skeleton ── */

export function DashboardSkeleton() {
  return (
    <div className="space-y-6" aria-label="Đang tải dữ liệu">
      {/* Hero skeleton */}
      <div className="h-36 animate-pulse rounded-2xl bg-gradient-to-br from-[#243B5A]/20 to-[#4FA7A0]/10" />
      {/* KPI skeletons */}
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        {Array.from({ length: 4 }, (_, index) => (
          <div
            key={index}
            className="h-[120px] animate-pulse rounded-xl bg-muted/60 animate-shimmer"
          />
        ))}
      </div>
      {/* Chart skeletons */}
      <div className="grid gap-4 md:grid-cols-7">
        <div className="col-span-4 h-[420px] animate-pulse rounded-xl bg-muted/60" />
        <div className="col-span-3 h-[420px] animate-pulse rounded-xl bg-muted/60" />
      </div>
    </div>
  );
}

/* ── Error State ── */

export function ErrorState({
  title = "Không thể tải dữ liệu",
  description,
  onRetry,
}: {
  title?: string;
  description: string;
  onRetry?: () => void;
}) {
  return (
    <Card className="border-dashed py-0 shadow-none">
      <CardContent className="flex flex-col items-center gap-3 p-8 text-center">
        <div className="rounded-full bg-[#C75345]/8 p-3.5 text-[#C75345]">
          <AlertCircle className="size-6" />
        </div>
        <div>
          <p className="font-semibold text-[#243B5A]">{title}</p>
          <p className="mt-1 text-sm text-[#6B7A8C]">{description}</p>
        </div>
        {onRetry ? (
          <Button variant="outline" onClick={onRetry} className="mt-1">
            Thử lại
          </Button>
        ) : null}
      </CardContent>
    </Card>
  );
}

/* ── Empty State ── */

export function EmptyState({
  title,
  description,
}: {
  title: string;
  description: string;
}) {
  return (
    <div className="flex flex-col items-center gap-2 py-6 text-center">
      <div className="rounded-full bg-[#E6F3F1] p-2.5">
        <Inbox className="size-5 text-[#4FA7A0]" />
      </div>
      <p className="text-sm font-medium text-[#243B5A]">{title}</p>
      <p className="max-w-sm text-xs text-[#6B7A8C]">{description}</p>
    </div>
  );
}
