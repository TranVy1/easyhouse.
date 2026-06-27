import React, { ReactNode } from 'react';
import { cn } from '@/lib/utils';
import { Card } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { LucideIcon, TrendingUp, TrendingDown, Cloud } from 'lucide-react';
import { Button } from '@/components/ui/button';
import Link from 'next/link';

/* ── Moving Clouds ── */
export const MovingClouds = () => (
  <div className="pointer-events-none absolute inset-0 overflow-hidden opacity-[0.25] z-0 motion-reduce:hidden" aria-hidden="true">
    <Cloud className="absolute left-[8%] top-[15%] h-14 w-14 text-white animate-cloud-float" style={{ animationDelay: '0s' }} />
    <Cloud className="absolute right-[15%] top-[12%] h-28 w-28 text-white animate-cloud-float" style={{ animationDelay: '1.5s', animationDuration: '16s' }} />
    <Cloud className="absolute bottom-[20%] left-[40%] h-20 w-20 text-white animate-cloud-float" style={{ animationDelay: '4s', animationDuration: '12s' }} />
    
    {/* SVG Clouds spanning across screen */}
    <div className="absolute top-10 left-0 w-[200%] animate-cloud-drift opacity-60">
      <svg width="120" height="70" viewBox="0 0 104 60" fill="none" xmlns="http://www.w3.org/2000/svg" className="ml-[10%]">
        <path d="M28.4 25.6C29.6 11.2 35.8 0 43.4 0C49.6 0 54.8 7.2 57.4 17.6C59.4 16.4 61.4 16 63.4 16C72.2 16 79.4 30.4 79.4 48C79.4 48.8 79.4 49.6 79.2 50.4C81.2 48.8 83.2 48 85.4 48C95.6 48 104 52.8 104 60H18.4C8.2 60 0 52.8 0 42.6C0 32.8 7.6 24.8 17.2 24.2C17.2 24 17.2 24 17.2 24C17.2 17.8 22.2 25.6 28.4 25.6Z" fill="currentColor"/>
      </svg>
      <svg width="120" height="70" viewBox="0 0 104 60" fill="none" xmlns="http://www.w3.org/2000/svg" className="ml-[55%] mt-6">
        <path d="M28.4 25.6C29.6 11.2 35.8 0 43.4 0C49.6 0 54.8 7.2 57.4 17.6C59.4 16.4 61.4 16 63.4 16C72.2 16 79.4 30.4 79.4 48C79.4 48.8 79.4 49.6 79.2 50.4C81.2 48.8 83.2 48 85.4 48C95.6 48 104 52.8 104 60H18.4C8.2 60 0 52.8 0 42.6C0 32.8 7.6 24.8 17.2 24.2C17.2 24 17.2 24 17.2 24C17.2 17.8 22.2 25.6 28.4 25.6Z" fill="currentColor"/>
      </svg>
    </div>
  </div>
);

/* ── HeroActionButton ── */
type HeroActionButtonProps = React.ComponentProps<typeof Button> & {
  href?: string;
}
export const HeroActionButton = React.forwardRef<HTMLButtonElement, HeroActionButtonProps>(
  ({ className, variant, href, children, onClick, ...props }, ref) => {
    const isPrimary = variant === 'default';
    const baseClasses = "inline-flex items-center justify-center flex-1 sm:flex-none h-12 px-5 sm:px-6 rounded-2xl text-[14px] sm:text-[15px] font-semibold transition-all duration-300 ease-out focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-white/70 active:translate-y-0 shrink-0 whitespace-nowrap";
    
    const primaryClasses = "bg-[#F2A45B] text-white shadow-[0_16px_34px_rgba(242,164,91,0.38)] hover:-translate-y-1 hover:scale-[1.02] hover:bg-[#ffb36d] hover:shadow-[0_22px_48px_rgba(242,164,91,0.52)] disabled:bg-white/15 disabled:text-white/70 disabled:shadow-none disabled:hover:translate-y-0 disabled:hover:scale-100 disabled:cursor-not-allowed";
    const secondaryClasses = "border border-white/35 bg-white/15 text-white shadow-[0_10px_24px_rgba(0,0,0,0.16)] backdrop-blur-md hover:-translate-y-1 hover:border-white/55 hover:bg-white/25 hover:shadow-[0_16px_34px_rgba(0,0,0,0.24)] disabled:bg-white/15 disabled:text-white/70 disabled:border-white/20 disabled:shadow-none disabled:hover:translate-y-0 disabled:cursor-not-allowed";

    const computedClass = cn(baseClasses, isPrimary ? primaryClasses : secondaryClasses, className);
    const handleLinkClick: React.MouseEventHandler<HTMLAnchorElement> | undefined = onClick
      ? (event) => onClick(event as unknown as React.MouseEvent<HTMLButtonElement>)
      : undefined;

    if (href) {
      return (
        <Link href={href} className={computedClass} onClick={handleLinkClick}>
          {children}
        </Link>
      );
    }

    return (
      <Button ref={ref} variant={isPrimary ? "default" : "secondary"} className={computedClass} onClick={onClick} {...props}>
        {children}
      </Button>
    );
  }
);
HeroActionButton.displayName = "HeroActionButton";

/* ── ActionGroup ── */
export function ActionGroup({
  className,
  children,
  position = "end"
}: {
  className?: string;
  children: ReactNode;
  position?: "start" | "end" | "between";
}) {
  return (
    <div className={cn(
      "flex w-full flex-wrap items-center gap-3 sm:w-auto",
      position === "start" ? "justify-start" : position === "between" ? "justify-between" : "justify-end",
      className
    )}>
      {children}
    </div>
  );
}

/* ── DashboardHero ── */
export function DashboardHero({
  icon: Icon,
  title,
  description,
  stats,
  actions,
  illustration,
  children,
  variant = "default",
}: {
  icon?: LucideIcon;
  title: string;
  description: string;
  stats?: ReactNode;
  actions?: ReactNode;
  illustration?: ReactNode;
  children?: ReactNode;
  variant?: "default" | "image";
}) {
  if (variant === "image") {
    return (
      <section className="dashboard-hero">
        <div className="dashboard-hero__inner">
          <div className="dashboard-hero__content">
            <div className="dashboard-hero__eyebrow">
              {Icon && <Icon className="h-4 w-4" aria-hidden="true" />}
              <span>{title}</span>
            </div>
            <h1>{title}</h1>
            <p>{description}</p>
            {stats && (
              <div className="dashboard-hero__chips">
                {stats}
              </div>
            )}
          </div>

          {actions && (
            <div className="dashboard-hero__actions">
              {actions}
            </div>
          )}
        </div>

        {children && (
          <div className="dashboard-hero__children">
            {children}
          </div>
        )}
      </section>
    );
  }

  return (
    <div className="group/hero relative overflow-hidden rounded-[24px] md:rounded-[28px] border border-white/20 bg-gradient-to-br from-[#243B5A] via-[#2F6F7A] to-[#4FA7A0] px-6 py-7 md:px-8 md:py-8 lg:px-10 lg:py-8 shadow-[0_16px_40px_-12px_rgba(36,59,90,0.4)] transition-all duration-300 ease-out hover:shadow-[0_24px_60px_-12px_rgba(36,59,90,0.5)] animate-in fade-in slide-in-from-bottom-6">
      
      <MovingClouds />

      {/* Glows */}
      <div className="pointer-events-none absolute right-12 bottom-4 hidden lg:block z-0 h-44 w-44 rounded-full bg-[#F2A45B]/30 blur-3xl transition-all duration-500 ease-out group-hover/hero:scale-125" />
      <div className="pointer-events-none absolute right-32 top-8 hidden lg:block z-0 h-52 w-52 rounded-full bg-[#7DCDC6]/20 blur-3xl transition-all duration-500 ease-out group-hover/hero:scale-110" />

      {/* Illustration */}
      {illustration && (
        <div className="pointer-events-none absolute right-4 lg:right-8 bottom-0 hidden lg:flex items-end justify-center z-10 hero-visual-wrap h-full" aria-hidden="true">
          <div className="pointer-events-none absolute bottom-2 right-6 h-10 w-[70%] rounded-full bg-black/25 blur-2xl opacity-35" />
          <div className="hero-building flex items-end h-[95%] origin-bottom scale-[1.15] md:scale-[1.25] transition-all duration-700 ease-out group-hover/hero:scale-[1.25] md:group-hover/hero:scale-[1.35] group-hover/hero:brightness-110">
            {illustration}
          </div>
        </div>
      )}

      {/* Main Content Area */}
      <div className="relative z-20 flex flex-col gap-6">
        {/* Top Row: Content & Actions */}
        <div className="flex flex-col gap-6 lg:flex-row lg:items-center lg:justify-between">
          {/* Left Content */}
          <div className="relative z-20 max-w-[760px] lg:max-w-[55%] xl:max-w-[60%] text-white">
            <div className="mb-2 flex items-center gap-2 text-sm font-bold uppercase tracking-wide text-white/75">
              {Icon && <Icon className="h-4 w-4" />}
              {title}
            </div>
            <h1 className="mt-2 max-w-[900px] whitespace-normal md:whitespace-nowrap text-[clamp(1.75rem,3.5vw,2.75rem)] font-extrabold leading-[1.1] tracking-tight text-white drop-shadow-sm">
              {title}
            </h1>
            <p className="mt-3 max-w-[620px] text-base font-medium leading-relaxed text-white/80 md:text-lg">
              {description}
            </p>
            {stats && (
              <div className="mt-4 flex flex-wrap items-center gap-2">
                {stats}
              </div>
            )}
          </div>

          {/* Actions */}
          {actions && (
            <div className={cn(
              "relative z-30 pointer-events-auto flex w-full flex-wrap items-center gap-3 sm:w-auto lg:w-auto lg:justify-end",
              children 
                ? "lg:mt-0" 
                : "lg:absolute lg:right-[clamp(2rem,4vw,4rem)] lg:top-1/2 lg:mt-0 lg:max-w-[44%] lg:-translate-y-1/2"
            )}>
              {actions}
            </div>
          )}
        </div>

        {/* Additional Content (e.g. KPI Grids) */}
        {children && (
          <div className="relative z-30 mt-8">
            {children}
          </div>
        )}
      </div>
    </div>
  );
}

/* ── DashboardCard ── */
export function DashboardCard({ className, children, ...props }: React.ComponentProps<typeof Card>) {
  return (
    <Card 
      className={cn(
        "rounded-2xl md:rounded-[24px] border border-[#E8DED1]/80 bg-white/95 backdrop-blur shadow-sm shadow-[#243B5A]/5 transition-all duration-300 hover:-translate-y-1 hover:shadow-lg hover:shadow-[#243B5A]/10", 
        className
      )} 
      {...props}
    >
      {children}
    </Card>
  );
}

export function DashboardKpiCard({
  title,
  value,
  icon,
  tone = 'default',
  trend,
  hint,
}: {
  title: string;
  value: number | string;
  icon: ReactNode;
  tone?: 'emerald' | 'blue' | 'orange' | 'red' | 'default';
  trend?: { value: string; isUp: boolean };
  hint?: string;
}) {
  return (
    <Card className={cn(
      "group relative flex min-h-[118px] flex-col justify-between rounded-[22px] border-0 bg-white/95 p-4 shadow-[0_12px_28px_rgba(15,23,42,0.12)] ring-1 ring-slate-200/70 transition-all duration-300 hover:-translate-y-1.5 hover:shadow-[0_20px_40px_-15px_rgba(15,23,42,0.2)] animate-in fade-in slide-in-from-bottom-4",
      tone === 'emerald' && "ring-[#4FA7A0]/30 hover:shadow-[#4FA7A0]/15",
      tone === 'blue' && "ring-[#243B5A]/30 hover:shadow-[#243B5A]/15",
      tone === 'orange' && "ring-[#F2A45B]/30 hover:shadow-[#F2A45B]/15",
      tone === 'red' && "ring-red-200 hover:shadow-red-500/10"
    )}>
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0 flex-1">
          <p className="max-w-[150px] text-sm font-semibold leading-snug text-slate-500">
            {title}
          </p>
        </div>

        <div className={cn(
          "flex h-10 w-10 shrink-0 items-center justify-center rounded-2xl border shadow-[0_6px_16px_rgba(15,23,42,0.08)] transition-transform duration-300 group-hover:scale-110",
          tone === 'emerald' ? 'border-[#4FA7A0]/30 bg-[#4FA7A0]/10 text-[#267D76]' :
          tone === 'blue' ? 'border-[#4FA7A0]/30 bg-[#4FA7A0]/10 text-[#243B5A]' :
          tone === 'orange' ? 'border-[#F2A45B]/30 bg-[#F2A45B]/10 text-[#F2A45B]' :
          tone === 'red' ? 'border-red-200 bg-red-50 text-red-600' :
          'border-slate-200/80 bg-white/80 text-muted-foreground'
        )}>
          {icon}
        </div>
      </div>

      <div className="mt-3 min-w-0">
        <p className={cn(
          "max-w-full whitespace-nowrap text-[clamp(1.35rem,1.75vw,1.85rem)] font-extrabold leading-none tracking-tight tabular-nums",
          tone === 'emerald' && 'text-[#267D76]',
          tone === 'blue' && 'text-[#243B5A]',
          tone === 'orange' && 'text-[#F2A45B]',
          tone === 'red' && 'text-red-600',
          tone === 'default' && 'text-slate-900'
        )}>
          {value}
        </p>

        {(trend || hint) && (
          <div className="mt-2.5 flex flex-wrap items-center gap-2">
            {trend && (
              <p className={cn("flex items-center text-xs font-semibold leading-snug", trend.isUp ? "text-emerald-600" : "text-rose-600")}>
                {trend.isUp ? <TrendingUp className="mr-1 h-3.5 w-3.5" /> : <TrendingDown className="mr-1 h-3.5 w-3.5" />}
                {trend.value}
              </p>
            )}
            {hint && (
              <p className="text-xs font-semibold leading-snug text-slate-400">
                {hint}
              </p>
            )}
          </div>
        )}
      </div>
    </Card>
  );
}

/* ── FilterBadge ── */
export function FilterBadge({ active, children, onClick }: { active: boolean; children: ReactNode; onClick?: () => void }) {
  return (
    <Badge 
      variant={active ? "default" : "outline"}
      className={cn(
        "cursor-pointer px-4 py-1.5 text-xs font-medium transition-all hover:scale-105",
        active 
          ? "bg-[#4FA7A0] hover:bg-[#3D8580] text-white shadow-sm border-[#4FA7A0]" 
          : "bg-white hover:bg-[#F8F3EC] text-muted-foreground hover:text-[#243B5A] border-[#E8DED1]"
      )}
      onClick={onClick}
    >
      {children}
    </Badge>
  );
}

/* ── Status Badge Unified ── */
export function StatusBadge({ status, label }: { status: string; label: string }) {
  let colorClass = "bg-gray-100 text-gray-800 border-gray-200";
  switch (status) {
    // Success / Active
    case 'trong': case 'AVAILABLE': case 'SUCCESS': case 'ACTIVE':
      colorClass = "bg-[#4FA7A0]/15 text-[#267D76] border border-[#4FA7A0]/30";
      break;
    // Warning / Reserved
    case 'daDat': case 'RESERVED': case 'PENDING':
      colorClass = "bg-[#F2A45B]/15 text-[#D4893A] border border-[#F2A45B]/30";
      break;
    // Info / In-progress
    case 'dangThue': case 'RENTED': case 'IN_PROGRESS':
      colorClass = "bg-[#243B5A]/10 text-[#243B5A] border border-[#243B5A]/30";
      break;
    // Danger / Error
    case 'baoTri': case 'MAINTENANCE': case 'INACTIVE': case 'OVERDUE': case 'FAILED':
      colorClass = "bg-red-50 text-red-600 border border-red-200";
      break;
    default:
      break;
  }
  return <Badge className={cn("font-medium", colorClass)}>{label}</Badge>;
}
