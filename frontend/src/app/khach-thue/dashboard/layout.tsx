'use client';

import { useState, useEffect } from 'react';
import { SessionProvider, useSession, signOut } from 'next-auth/react';
import { useRouter, usePathname } from 'next/navigation';
import { Button } from '@/components/ui/button';
import { Home, FileText, AlertCircle, User, LogOut, Menu, X, Bell, ScrollText, LayoutDashboard, Building, Moon, Sun, MessageCircle } from 'lucide-react';
import Link from 'next/link';
import { toast } from 'sonner';
import { TenantProvider, useTenantDashboard } from './context';
import { useChuaDocTinNhan } from '@/hooks/use-chua-doc-tin-nhan';
import { ThemeToggle } from '@/components/theme-toggle';

interface TenantNavigationProps {
  pathname: string;
  handleLogout: () => void;
  isMobileMenuOpen: boolean;
  setIsMobileMenuOpen: (open: boolean) => void;
}

function TenantNavigation({
  pathname,
  handleLogout,
  isMobileMenuOpen,
  setIsMobileMenuOpen
}: TenantNavigationProps) {
  const { data } = useTenantDashboard();
  const soTinChuaDoc = useChuaDocTinNhan();
  const router = useRouter();
  const { data: session } = useSession();
  const role = session?.user?.role as string | undefined;
  const isAdmin = ['admin', 'ADMIN', 'chuNha', 'LANDLORD', 'nhanVien', 'STAFF'].includes(role || '');

  const navigation = [
    { name: 'Tổng quan', href: '/khach-thue/dashboard', icon: Home, badge: 0 },
    { name: 'Hóa đơn', href: '/khach-thue/dashboard/hoa-don', icon: FileText, badge: data?.soHoaDonChuaThanhToan || 0 },
    { name: 'Hợp đồng', href: '/khach-thue/dashboard/hop-dong', icon: ScrollText, badge: 0 },
    { name: 'Sự cố', href: '/khach-thue/dashboard/su-co', icon: AlertCircle, badge: data?.soSuCoDangMo || 0 },
    { name: 'Tin nhắn', href: '/khach-thue/dashboard/tin-nhan', icon: MessageCircle, badge: soTinChuaDoc },
    { name: 'Thông báo', href: '/khach-thue/dashboard/thong-bao', icon: Bell, badge: data?.soThongBaoMoi || 0 },
    { name: 'Tài khoản', href: '/khach-thue/dashboard/thong-tin', icon: User, badge: 0 },
  ];

  const getInitials = (name?: string) => {
    if (!name) return 'T';
    const parts = name.split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  };

  return (
    <>
      {/* Desktop Top Navigation */}
      <header className="hidden lg:flex fixed top-0 left-0 right-0 z-40 h-16 bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60 border-b border-border px-6 xl:px-8 items-center justify-between">
        <div className="flex items-center gap-6 xl:gap-8">
          {/* Logo */}
          <div className="flex items-center gap-2 shrink-0">
            <div className="bg-primary p-1.5 rounded-lg flex items-center justify-center shadow-sm">
               <Building className="h-5 w-5 text-primary-foreground" />
            </div>
            <span className="font-bold text-xl text-foreground tracking-tight font-['Be_Vietnam_Pro'] hidden xl:block">EasyHouse</span>
          </div>

          {/* Nav Links */}
          <nav className="flex items-center gap-1">
            {navigation.map((item) => {
              const Icon = item.icon;
              const isActive = pathname === item.href;
              return (
                <Link
                  key={item.name}
                  href={item.href}
                  className={`
                    flex items-center gap-2 px-3 py-2 rounded-lg transition-all duration-200 relative
                    ${isActive
                      ? 'bg-primary/10 text-primary font-semibold'
                      : 'text-muted-foreground hover:bg-muted hover:text-foreground'
                    }
                  `}
                >
                  <Icon className={`h-4 w-4 ${isActive ? 'text-primary' : 'text-muted-foreground'}`} />
                  <span className="text-sm">{item.name}</span>
                  {item.badge > 0 && (
                    <span className="ml-1 bg-red-500 text-white text-[10px] font-bold rounded-full h-5 min-w-[20px] px-1 flex items-center justify-center shadow-sm shadow-red-500/20">
                      {item.badge > 99 ? '99+' : item.badge}
                    </span>
                  )}
                </Link>
              );
            })}
          </nav>
        </div>

        {/* User & Actions */}
        <div className="flex items-center gap-3">
          {isAdmin && (
            <Button
              variant="outline"
              size="sm"
              className="hidden xl:flex text-primary border-primary/20 hover:text-primary hover:bg-primary/10 rounded-lg transition-colors"
              onClick={() => router.push('/dashboard')}
            >
              <LayoutDashboard className="h-4 w-4 mr-2" />
              Về Quản lý
            </Button>
          )}
          <ThemeToggle />
          <div className="flex items-center gap-3 pl-3 border-l border-border">
             <div className="text-right hidden xl:block">
               <p className="text-sm font-bold text-foreground leading-none mb-1">{data?.khachThue?.hoTen || 'Khách thuê'}</p>
               <p className="text-[10px] text-muted-foreground font-medium uppercase leading-none">Đang hoạt động</p>
             </div>
             {/* Open Menu overlay on click to show logout option */}
             <div 
               className="h-9 w-9 rounded-full bg-gradient-to-br from-primary to-primary/80 flex items-center justify-center text-primary-foreground font-bold text-sm shadow-sm cursor-pointer hover:opacity-90 transition-opacity" 
               onClick={() => setIsMobileMenuOpen(true)}
             >
               {getInitials(data?.khachThue?.hoTen)}
             </div>
          </div>
        </div>
      </header>

      {/* Mobile Bottom Navigation */}
      <nav className="lg:hidden fixed bottom-0 left-0 right-0 z-50 bg-background/95 backdrop-blur border-t border-border flex justify-around items-center h-16 px-2 safe-area-bottom pb-safe">
        {navigation.slice(0, 4).map((item) => {
          const Icon = item.icon;
          const isActive = pathname === item.href;
          return (
            <Link
              key={item.name}
              href={item.href}
              className={`
                flex flex-col items-center justify-center w-full h-full relative transition-colors duration-200
                ${isActive ? 'text-primary' : 'text-muted-foreground hover:text-foreground'}
              `}
            >
              <div className="relative">
                <Icon className={`h-5 w-5 mb-1 ${isActive ? 'text-primary' : 'text-muted-foreground'}`} />
                {item.badge > 0 && (
                  <span className="absolute -top-1.5 -right-2 bg-red-500 text-white text-[9px] font-bold rounded-full h-4 min-w-[16px] px-0.5 flex items-center justify-center border-2 border-background">
                    {item.badge > 9 ? '9+' : item.badge}
                  </span>
                )}
              </div>
              <span className={`text-[10px] font-medium ${isActive ? 'text-primary font-semibold' : ''}`}>{item.name}</span>
            </Link>
          );
        })}
        {/* Mobile menu trigger for more options */}
        <button
          onClick={() => setIsMobileMenuOpen(true)}
          className={`flex flex-col items-center justify-center w-full h-full relative text-muted-foreground hover:text-foreground transition-colors duration-200`}
        >
          <Menu className="h-5 w-5 mb-1" />
          <span className="text-[10px] font-medium">Thêm</span>
        </button>
      </nav>

      {/* More Options Overlay (Mobile & Desktop Dropdown) */}
      {isMobileMenuOpen && (
        <div className="fixed inset-0 z-[60] flex flex-col justify-end lg:justify-start lg:items-end lg:pt-20 lg:pr-6">
          <div
            className="absolute inset-0 bg-black/40 backdrop-blur-sm transition-opacity"
            onClick={() => setIsMobileMenuOpen(false)}
          />
          <div className="relative bg-background lg:rounded-2xl rounded-t-3xl p-5 lg:p-4 pb-safe space-y-4 animate-in slide-in-from-bottom lg:slide-in-from-top lg:fade-in duration-300 lg:duration-200 border border-border lg:shadow-xl lg:w-80 lg:mb-auto">
            <div className="flex justify-between items-center pb-4 lg:pb-3 border-b border-border">
              <h3 className="font-bold text-lg lg:text-base font-['Be_Vietnam_Pro'] text-foreground">Menu</h3>
              <Button variant="ghost" size="icon" className="rounded-full hover:bg-muted h-8 w-8" onClick={() => setIsMobileMenuOpen(false)}>
                <X className="h-4 w-4 text-muted-foreground" />
              </Button>
            </div>
            
            <div className="p-4 lg:p-3 bg-gradient-to-r from-primary to-primary/80 rounded-2xl lg:rounded-xl mb-4 text-primary-foreground flex items-center gap-4 lg:gap-3">
              <div className="h-12 w-12 lg:h-10 lg:w-10 rounded-full bg-white/20 flex items-center justify-center text-primary-foreground font-bold text-lg lg:text-base shrink-0 shadow-inner">
                {getInitials(data?.khachThue?.hoTen)}
              </div>
              <div>
                 <h2 className="text-xs font-medium text-primary-foreground/80 tracking-wide uppercase mb-0.5">Xin chào,</h2>
                 <p className="text-lg lg:text-base font-bold truncate leading-tight font-['Be_Vietnam_Pro']">{data?.khachThue?.hoTen}</p>
              </div>
            </div>
            
            <div className="space-y-1 lg:space-y-0.5">
              {/* Show remaining nav items on mobile */}
              <div className="lg:hidden">
                {navigation.slice(4).map((item) => {
                  const Icon = item.icon;
                  return (
                    <Link
                      key={item.name}
                      href={item.href}
                      onClick={() => setIsMobileMenuOpen(false)}
                      className="flex items-center gap-4 lg:gap-3 p-3.5 lg:p-2.5 rounded-xl lg:rounded-lg hover:bg-muted transition-colors"
                    >
                      <div className="bg-muted p-2 rounded-lg">
                         <Icon className="h-5 w-5 lg:h-4 lg:w-4 text-muted-foreground" />
                      </div>
                      <span className="font-medium lg:text-sm text-foreground">{item.name}</span>
                      {item.badge > 0 && <span className="ml-auto rounded-full bg-red-500 px-2.5 py-0.5 text-[10px] font-bold text-white shadow-sm shadow-red-500/20">{item.badge > 99 ? '99+' : item.badge}</span>}
                    </Link>
                  );
                })}
                <div className="h-px w-full bg-border my-2"></div>
              </div>
              
              {isAdmin && (
                <button
                  onClick={() => { setIsMobileMenuOpen(false); router.push('/dashboard'); }}
                  className="w-full flex items-center gap-4 lg:gap-3 p-3.5 lg:p-2.5 rounded-xl lg:rounded-lg hover:bg-primary/5 text-primary transition-colors lg:hidden"
                >
                  <div className="bg-primary/10 p-2 rounded-lg">
                    <LayoutDashboard className="h-5 w-5 lg:h-4 lg:w-4" />
                  </div>
                  <span className="font-medium lg:text-sm">Về Quản lý</span>
                </button>
              )}
              
              <button
                onClick={() => { setIsMobileMenuOpen(false); handleLogout(); }}
                className="w-full flex items-center gap-4 lg:gap-3 p-3.5 lg:p-2.5 rounded-xl lg:rounded-lg hover:bg-destructive/10 text-destructive transition-colors"
              >
                <div className="bg-destructive/10 p-2 rounded-lg">
                  <LogOut className="h-5 w-5 lg:h-4 lg:w-4" />
                </div>
                <span className="font-medium lg:text-sm">Đăng xuất</span>
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}

function KhachThueDashboardLayoutContent({
  children,
}: {
  children: React.ReactNode;
}) {
  const router = useRouter();
  const pathname = usePathname();
  const sessionState = useSession({
    required: true,
    onUnauthenticated() {
      router.push('/khach-thue/dang-nhap');
    },
  });
  const session = sessionState?.data;
  const status = sessionState?.status ?? 'loading';
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  useEffect(() => {
    if (status === 'authenticated' && session?.user?.requirePasswordChange) {
      if (pathname !== '/khach-thue/doi-mat-khau') {
        router.replace('/khach-thue/doi-mat-khau');
      }
    }
  }, [status, session, pathname, router]);

  const handleLogout = async () => {
    await signOut({ callbackUrl: '/khach-thue/dang-nhap' });
    toast.success('Đã đăng xuất');
  };

  if (status === 'loading') {
    return (
      <div className="min-h-screen flex items-center justify-center bg-background">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
      </div>
    );
  }

  if (status === 'authenticated' && session?.user?.requirePasswordChange) {
    return null;
  }

  return (
    <TenantProvider>
      <div className="min-h-screen bg-muted/20 pb-16 lg:pb-0 lg:pt-16">
        <TenantNavigation
          pathname={pathname}
          handleLogout={handleLogout}
          isMobileMenuOpen={isMobileMenuOpen}
          setIsMobileMenuOpen={setIsMobileMenuOpen}
        />

        {/* Main content */}
        <main className="min-h-screen max-w-7xl mx-auto">
          <div className="p-4 md:p-6 lg:p-8 pt-6">
            {children}
          </div>
        </main>
      </div>
    </TenantProvider>
  );
}

export default function KhachThueDashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <SessionProvider basePath="/api/auth-tenant">
      <KhachThueDashboardLayoutContent>{children}</KhachThueDashboardLayoutContent>
    </SessionProvider>
  );
}
