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
        <header className="sticky top-0 z-40 flex h-16 shrink-0 items-center gap-3 border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60 px-4 md:px-6">
          <PageProgress />
          <SidebarTrigger className="-ml-1" />
          <Separator orientation="vertical" className="mx-1 h-5 opacity-50" />
          <div className="flex flex-1 items-center gap-4">
            <div className="min-w-0 hidden md:flex overflow-hidden">
              <DynamicBreadcrumb />
            </div>
            {/* Search */}
            <div className="hidden lg:flex items-center relative w-64 ml-4 group">
              <Search className="absolute left-2.5 h-4 w-4 text-muted-foreground group-hover:text-primary transition-colors pointer-events-none z-10" />
              <Input
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Tìm kiếm..."
                className="pl-9 pr-12 h-9 bg-muted/50 hover:bg-muted border-border hover:border-primary/50 focus-visible:bg-background focus-visible:border-primary focus-visible:ring-primary/30 focus-visible:ring-[3px] rounded-lg text-sm text-foreground transition-all shadow-none"
              />
              <kbd className="pointer-events-none absolute right-2 top-1/2 -translate-y-1/2 inline-flex h-5 select-none items-center gap-1 rounded border border-border bg-background px-1.5 font-mono text-[10px] font-medium text-muted-foreground opacity-100 z-10">
                <span className="text-xs">⌘</span>K
              </kbd>
            </div>
          </div>
          <div className="ml-auto flex items-center gap-3">
            <Link
              href="/"
              className="flex items-center gap-1.5 px-3.5 py-1.5 text-xs sm:text-sm font-semibold text-foreground bg-card border border-border hover:bg-accent hover:text-accent-foreground rounded-xl transition-all hover:-translate-y-[1px] shadow-[0_2px_8px_-2px_rgba(0,0,0,0.08)] dark:shadow-none shrink-0"
            >
              <Home size={15} className="text-chart-1" />
              <span className="hidden sm:inline">Trang chủ</span>
            </Link>
            <div className="w-px h-5 bg-border mx-1 hidden sm:block"></div>
            <ThemeToggle />
          </div>
        </header>
        <main className="flex-1 overflow-y-auto bg-background min-w-0">
          <div className="w-full min-w-0 p-4 md:p-5 lg:p-6">
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
