'use client';

import { useEffect } from 'react';
import { SessionProvider } from 'next-auth/react';
import { useSession } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import { Loader2, Home } from 'lucide-react';
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

import { signOut } from 'next-auth/react';

interface DashboardLayoutProps {
  children: React.ReactNode;
}

function DashboardLayoutContent({ children }: DashboardLayoutProps) {
  const { data: session, status } = useSession();
  const router = useRouter();

  useEffect(() => {
    if (status === 'loading') return;

    if (!session) {
      router.push('/dang-nhap');
      return;
    }

    // If refresh token expired, force re-login
    if (session.error === 'RefreshAccessTokenError') {
      signOut({ callbackUrl: '/dang-nhap' });
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
        <header className="sticky top-0 z-40 flex h-14 shrink-0 items-center gap-2 border-b bg-background/92 px-4 backdrop-blur md:px-6">
          <PageProgress />
          <SidebarTrigger className="-ml-1" />
          <Separator orientation="vertical" className="mx-1 h-5" />
          <div className="min-w-0 overflow-hidden">
            <DynamicBreadcrumb />
          </div>
          <div className="ml-auto flex items-center gap-2">
            <Link
              href="/"
              className="flex items-center gap-1.5 px-3 py-1.5 text-xs sm:text-sm font-semibold text-[#243B5A] bg-white border border-[#E8DED2] hover:bg-[#F8F3EC] dark:bg-slate-800 dark:border-white/15 dark:text-slate-200 dark:hover:bg-slate-700 rounded-xl transition-all shadow-sm shrink-0"
            >
              <Home size={15} className="text-[#FF5A3D]" />
              <span className="hidden sm:inline">Quay về trang chủ</span>
            </Link>
            <ThemeToggle />
          </div>
        </header>
        <main className="flex-1 overflow-y-auto">
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
