'use client';

import { useEffect, useState } from 'react';
import { SessionProvider } from 'next-auth/react';
import { useSession } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import { Loader2, Home, Search } from 'lucide-react';
import Link from 'next/link';
import { AppSidebar } from '@/components/app-sidebar';
import {
  SidebarInset,
  SidebarProvider,
  SidebarTrigger,
} from '@/components/ui/sidebar';
import { Separator } from '@/components/ui/separator';
import { DynamicBreadcrumb } from '@/components/ui/dynamic-breadcrumb';
import { PageProgress } from '@/components/ui/page-progress';
import { ThemeToggle } from '@/components/theme-toggle';
import { Input } from '@/components/ui/input';

import { signOut } from 'next-auth/react';

interface DashboardLayoutProps {
  children: React.ReactNode;
}

function DashboardLayoutContent({ children }: DashboardLayoutProps) {
  const { data: session, status } = useSession();
  const router = useRouter();
  const [searchQuery, setSearchQuery] = useState("");

  useEffect(() => {
    if (status === 'loading') return;

    if (!session) {
      router.push('/dang-nhap');
      return;
    }

    // If refresh token expired, force re-login
    if (session.error === 'RefreshAccessTokenError') {
      signOut({ callbackUrl: '/dang-nhap' });
      return;
    }

    if (session.user?.requirePasswordChange && !window.location.pathname.includes('/ho-so')) {
      router.push('/dashboard/ho-so');
    }
  }, [session, status, router]);

  if (status === 'loading') {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <div className="text-center">
          <Loader2 className="mx-auto mb-4 h-8 w-8 animate-spin text-primary" />
          <p className="text-sm text-muted-foreground">Đang chuẩn bị không gian quản lý...</p>
        </div>
      </div>
    );
  }

  if (!session) {
    return null;
  }

  return (
    <SidebarProvider>
      <AppSidebar />
      <SidebarInset className="overflow-hidden bg-background">
        <header className="sticky top-0 z-40 flex h-[60px] shrink-0 items-center gap-3 border-b border-[#E8DED2]/60 bg-white/90 px-4 backdrop-blur-md md:px-6 shadow-[0_2px_10px_-4px_rgba(15,23,42,0.05)]">
          <PageProgress />
          <SidebarTrigger className="-ml-1" />
          <Separator orientation="vertical" className="mx-1 h-5 opacity-50" />
          <div className="flex flex-1 items-center gap-4">
            <div className="min-w-0 hidden md:flex overflow-hidden">
              <DynamicBreadcrumb />
            </div>
            {/* Search */}
            <div className="hidden lg:flex items-center relative w-64 ml-4 group">
              <Search className="absolute left-2.5 h-4 w-4 text-slate-400 group-hover:text-[#4FA7A0] transition-colors pointer-events-none z-10" />
              <Input
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Tìm kiếm..."
                className="pl-9 pr-12 h-9 bg-[#F8F3EC]/50 hover:bg-[#F8F3EC] border border-[#E8DED2]/60 hover:border-[#4FA7A0]/50 focus-visible:bg-white focus-visible:border-[#4FA7A0] focus-visible:ring-[#4FA7A0]/30 focus-visible:ring-[3px] rounded-lg text-sm text-[#243B5A] transition-all shadow-none"
              />
              <kbd className="pointer-events-none absolute right-2 top-1/2 -translate-y-1/2 inline-flex h-5 select-none items-center gap-1 rounded border border-slate-200 bg-white px-1.5 font-mono text-[10px] font-medium text-slate-500 opacity-100 z-10">
                <span className="text-xs">⌘</span>K
              </kbd>
            </div>
          </div>
          <div className="ml-auto flex items-center gap-3">
            <Link
              href="/"
              className="flex items-center gap-1.5 px-3.5 py-1.5 text-xs sm:text-sm font-semibold text-[#243B5A] bg-white border border-[#E8DED2] hover:bg-[#F8F3EC] dark:bg-slate-800 dark:border-white/15 dark:text-slate-200 dark:hover:bg-slate-700 rounded-xl transition-all hover:-translate-y-[1px] shadow-[0_2px_8px_-2px_rgba(15,23,42,0.08)] shrink-0"
            >
              <Home size={15} className="text-[#F2A45B]" />
              <span className="hidden sm:inline">Trang chủ</span>
            </Link>
            <div className="w-px h-5 bg-slate-200 mx-1 hidden sm:block"></div>
            <ThemeToggle />
          </div>
        </header>
        <main className="flex-1 overflow-y-auto bg-[#F8F3EC] dark:bg-background">
          <div className="mx-auto w-full max-w-[1440px] p-4 md:p-6 lg:p-8">
            {children}
          </div>
        </main>
      </SidebarInset>
    </SidebarProvider>
  );
}

export default function DashboardLayout({ children }: DashboardLayoutProps) {
  return (
    <SessionProvider>
      <DashboardLayoutContent>{children}</DashboardLayoutContent>
    </SessionProvider>
  );
}
