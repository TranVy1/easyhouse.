import Link from 'next/link';
import { IllustrationLeft, IllustrationRight } from './AuthIllustration';

interface AuthLayoutProps {
  children: React.ReactNode;
  title: string;
  description?: string;
  /** Hide illustrations — Tenant Login or compact pages */
  hideIllustration?: boolean;
}

/**
 * AuthLayout — Centered card with illustrations flanking (visual reference style).
 *
 * Desktop:  Logo top-left │ [illus-L]  [CARD]  [illus-R] │
 * Mobile:   Logo top-left │ Card full-width               │
 */
export function AuthLayout({ children, title, description, hideIllustration = false }: AuthLayoutProps) {
  return (
    <div className="min-h-screen flex flex-col bg-[#F7F7F5] relative overflow-hidden">

      {/* ── Ambient corner decorations ── very low opacity, purely decorative ── */}
      <div className="pointer-events-none absolute inset-0" aria-hidden="true">
        {/* Top-left arch */}
        <svg className="absolute -top-16 -left-16 w-64 h-64 opacity-[0.04]" viewBox="0 0 200 200" fill="none">
          <circle cx="100" cy="100" r="90" stroke="#0F172A" strokeWidth="1.5" />
          <circle cx="100" cy="100" r="65" stroke="#0F172A" strokeWidth="1" />
          <circle cx="100" cy="100" r="40" stroke="#0F172A" strokeWidth="0.8" />
        </svg>
        {/* Bottom-right arch */}
        <svg className="absolute -bottom-20 -right-20 w-72 h-72 opacity-[0.04]" viewBox="0 0 200 200" fill="none">
          <circle cx="100" cy="100" r="90" stroke="#0D9488" strokeWidth="1.5" />
          <circle cx="100" cy="100" r="60" stroke="#0D9488" strokeWidth="1" />
        </svg>
        {/* Top-right thin grid */}
        <svg className="absolute top-0 right-0 w-40 h-40 opacity-[0.035]" viewBox="0 0 160 160" fill="none">
          <defs>
            <pattern id="auth-grid" width="20" height="20" patternUnits="userSpaceOnUse">
              <path d="M20 0H0V20" stroke="#0F172A" strokeWidth="0.8" fill="none" />
            </pattern>
          </defs>
          <rect width="160" height="160" fill="url(#auth-grid)" />
        </svg>
        {/* Bottom-left thin grid */}
        <svg className="absolute bottom-0 left-0 w-40 h-40 opacity-[0.035]" viewBox="0 0 160 160" fill="none">
          <rect width="160" height="160" fill="url(#auth-grid)" />
        </svg>
      </div>

      {/* ── Header ── */}
      <header
        className="
          flex items-center justify-between
          px-6 sm:px-10 pt-6 pb-2
          flex-shrink-0
          animate-in fade-in slide-in-from-top-2 duration-400 ease-out
        "
      >
        {/* Logo */}
        <Link
          href="/"
          className="select-none group flex items-center gap-2 focus:outline-none focus-visible:ring-2 focus-visible:ring-[#0D9488] rounded-md"
          aria-label="EasyHouse – Trang chủ"
        >
          <span className="flex h-8 w-8 items-center justify-center rounded-lg bg-[#0D9488] shadow-sm transition-transform duration-200 group-hover:scale-105">
            <svg viewBox="0 0 24 24" fill="none" className="h-5 w-5" aria-hidden="true">
              <path d="M3 12l9-9 9 9" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
              <path d="M5 10v9a1 1 0 001 1h4v-4h4v4h4a1 1 0 001-1v-9" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
            </svg>
          </span>
          <span className="text-[17px] font-black text-slate-900 tracking-tight uppercase leading-none transition-colors duration-150 group-hover:text-slate-700">
            Easy<span className="text-[#0D9488]">House</span>
          </span>
        </Link>

        {/* Back link */}
        <Link
          href="/"
          className="
            hidden sm:inline-flex items-center gap-1.5
            text-[13px] font-medium text-slate-500
            hover:text-slate-800 transition-colors duration-150
            rounded-md px-2 py-1 hover:bg-slate-100
            focus:outline-none focus-visible:ring-2 focus-visible:ring-[#0D9488]
          "
        >
          Về trang chủ
        </Link>
      </header>

      {/* ── Main stage ── */}
      <main className="flex-1 flex items-center justify-center px-4 py-6 sm:py-8">
        <div className="w-full max-w-[1140px] flex items-end justify-center gap-0 md:gap-2 lg:gap-4">

          {/* Illustration LEFT */}
          {!hideIllustration && (
            <div
              className="
                hidden md:flex flex-shrink-0 items-end justify-end
                w-[230px] lg:w-[275px]
                h-[310px] lg:h-[360px]
                animate-in fade-in slide-in-from-left-8 duration-700 ease-out
              "
              aria-hidden="true"
            >
              <IllustrationLeft />
            </div>
          )}

          {/* ── AUTH CARD ── */}
          <div
            className="
              w-full max-w-[450px] flex-shrink-0
              bg-white
              rounded-[24px]
              border border-slate-100/80
              shadow-[0_4px_6px_rgba(0,0,0,0.03),_0_12px_40px_rgba(0,0,0,0.07),_0_32px_64px_rgba(0,0,0,0.04)]
              px-7 py-9 sm:px-10 sm:py-10
              animate-in fade-in slide-in-from-bottom-6 zoom-in-[0.98] duration-500 ease-out
              transition-shadow duration-300
              hover:shadow-[0_4px_6px_rgba(0,0,0,0.04),_0_16px_48px_rgba(0,0,0,0.09),_0_40px_80px_rgba(0,0,0,0.05)]
            "
          >
            {/* Card header */}
            <div className="mb-7">
              <h2 className="text-[26px] font-black text-slate-900 tracking-tight leading-tight mb-1.5">
                {title}
              </h2>
              {description && (
                <p className="text-[14px] text-slate-500 font-medium leading-snug">{description}</p>
              )}
            </div>

            {children}
          </div>

          {/* Illustration RIGHT */}
          {!hideIllustration && (
            <div
              className="
                hidden md:flex flex-shrink-0 items-end justify-start
                w-[230px] lg:w-[275px]
                h-[310px] lg:h-[360px]
                animate-in fade-in slide-in-from-right-8 duration-700 ease-out
              "
              aria-hidden="true"
            >
              <IllustrationRight />
            </div>
          )}

        </div>
      </main>

      {/* ── Footer ── */}
      <footer className="text-center pb-5 flex-shrink-0 animate-in fade-in duration-700 delay-300 ease-out">
        <p className="text-[12px] text-slate-400 font-medium">
          &copy; {new Date().getFullYear()} EasyHouse. Hệ thống quản lý phòng trọ chuyên nghiệp.
        </p>
      </footer>
    </div>
  );
}
