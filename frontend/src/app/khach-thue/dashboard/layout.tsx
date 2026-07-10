'use client';

import { useState, useEffect } from 'react';
import { SessionProvider, useSession, signOut } from 'next-auth/react';
import { useRouter, usePathname } from 'next/navigation';
import { Button } from '@/components/ui/button';
import { Home, FileText, AlertCircle, User, LogOut, Menu, X, Bell, ScrollText, LayoutDashboard, Building } from 'lucide-react';
import Link from 'next/link';
import { toast } from 'sonner';
import { TenantProvider, useTenantDashboard } from './context';

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
  const router = useRouter();
  const { data: session } = useSession();
  const role = session?.user?.role as string | undefined;
  const isAdmin = ['admin', 'ADMIN', 'chuNha', 'LANDLORD', 'nhanVien', 'STAFF'].includes(role || '');

  const navigation = [
    { name: 'Tổng quan', href: '/khach-thue/dashboard', icon: Home, badge: 0 },
    { name: 'Hóa đơn', href: '/khach-thue/dashboard/hoa-don', icon: FileText, badge: data?.soHoaDonChuaThanhToan || 0 },
    { name: 'Hợp đồng', href: '/khach-thue/dashboard/hop-dong', icon: ScrollText, badge: 0 },
    { name: 'Sự cố', href: '/khach-thue/dashboard/su-co', icon: AlertCircle, badge: data?.soSuCoDangMo || 0 },
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
      {/* Desktop Sidebar */}
      <aside className={`
        fixed top-0 left-0 z-40 w-64 h-screen transition-transform bg-sidebar border-r border-border hidden lg:block
      `}>
        <div className="h-full px-4 py-6 overflow-y-auto flex flex-col">
          <div className="flex items-center gap-2 mb-8 px-2">
            <div className="bg-primary p-1.5 rounded-lg flex items-center justify-center shadow-sm">
               <Building className="h-5 w-5 text-primary-foreground" />
            </div>
            <span className="font-bold text-xl text-foreground tracking-tight font-['Be_Vietnam_Pro']">EasyHouse</span>
          </div>

          <div className="mb-8 p-3.5 bg-muted/50 border border-border rounded-2xl flex items-center gap-3">
             <div className="h-10 w-10 rounded-full bg-gradient-to-br from-primary to-primary/80 flex items-center justify-center text-primary-foreground font-bold text-sm shrink-0 shadow-sm">
               {getInitials(data?.khachThue?.hoTen)}
             </div>
             <div className="overflow-hidden">
               <p className="text-sm font-bold text-foreground truncate leading-tight">{data?.khachThue?.hoTen || 'Khách thuê'}</p>
               <div className="flex items-center mt-1">
                 <span className="h-1.5 w-1.5 rounded-full bg-emerald-500 mr-1.5"></span>
                 <p className="text-[10px] text-muted-foreground font-medium tracking-wide uppercase">Đang hoạt động</p>
               </div>
             </div>
          </div>

          <nav className="space-y-1.5">
            <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-3 px-2">Menu chính</p>
            {navigation.map((item) => {
              const Icon = item.icon;
              const isActive = pathname === item.href;
              return (
                <Link
                  key={item.name}
                  href={item.href}
                  className={`
                    flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 relative group
                    ${isActive
                      ? 'bg-primary/10 text-primary font-semibold'
                      : 'text-muted-foreground hover:bg-muted hover:text-foreground hover:translate-x-1'
                    }
                  `}
                >
                  <Icon className={`h-5 w-5 ${isActive ? 'text-primary' : 'text-muted-foreground group-hover:text-foreground transition-colors'}`} />
                  <span className="font-medium text-sm">{item.name}</span>
                  {item.badge > 0 && (
                    <span className="absolute right-4 bg-red-500 text-white text-[10px] font-bold rounded-full h-5 min-w-[20px] px-1 flex items-center justify-center shadow-sm shadow-red-500/20">
                      {item.badge > 99 ? '99+' : item.badge}
                    </span>
                  )}
                </Link>
              );
            })}
          </nav>

          <div className="mt-auto pt-6 space-y-2">
            {isAdmin && (
              <Button
                variant="outline"
                className="w-full justify-start text-primary border-primary/20 hover:text-primary hover:bg-primary/5 rounded-xl h-11 dark:hover:bg-primary/10"
                onClick={() => router.push('/dashboard')}
              >
                <LayoutDashboard className="h-4 w-4 mr-3" />
                Về Quản lý
              </Button>
            )}
            <Button
              variant="outline"
              className="w-full justify-start text-destructive border-destructive/20 hover:text-destructive hover:bg-destructive/10 rounded-xl h-11 transition-colors"
              onClick={handleLogout}
            >
              <LogOut className="h-4 w-4 mr-3" />
              Đăng xuất
            </Button>
          </div>
        </div>
      </aside>

      {/* Mobile Bottom Navigation */}
      <nav className="lg:hidden fixed bottom-0 left-0 right-0 z-50 glass-panel border-t-0 flex justify-around items-center h-16 px-2 safe-area-bottom pb-safe rounded-t-xl">
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
                  <span className="absolute -top-1.5 -right-2 bg-red-500 text-white text-[9px] font-bold rounded-full h-4 min-w-[16px] px-0.5 flex items-center justify-center border-2 border-white">
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

      {/* Mobile More Options Overlay */}
      {isMobileMenuOpen && (
        <div className="fixed inset-0 z-[60] lg:hidden flex flex-col justify-end">
          <div
            className="absolute inset-0 bg-black/40 backdrop-blur-sm transition-opacity"
            onClick={() => setIsMobileMenuOpen(false)}
          />
          <div className="relative bg-background rounded-t-3xl p-5 pb-safe space-y-4 animate-in slide-in-from-bottom duration-300 border-t border-border">
            <div className="flex justify-between items-center pb-4 border-b border-border">
              <h3 className="font-bold text-lg font-['Be_Vietnam_Pro'] text-foreground">Menu</h3>
              <Button variant="ghost" size="icon" className="rounded-full hover:bg-muted" onClick={() => setIsMobileMenuOpen(false)}>
                <X className="h-5 w-5 text-muted-foreground" />
              </Button>
            </div>
            
            <div className="p-4 bg-gradient-to-r from-primary to-primary/80 rounded-2xl mb-4 text-primary-foreground flex items-center gap-4">
              <div className="h-12 w-12 rounded-full bg-white/20 flex items-center justify-center text-primary-foreground font-bold text-lg shrink-0 shadow-inner">
                {getInitials(data?.khachThue?.hoTen)}
              </div>
              <div>
                 <h2 className="text-xs font-medium text-primary-foreground/80 tracking-wide uppercase mb-0.5">Xin chào,</h2>
                 <p className="text-lg font-bold truncate leading-tight font-['Be_Vietnam_Pro']">{data?.khachThue?.hoTen}</p>
              </div>
            </div>
            
            <div className="space-y-2">
              {navigation.slice(4).map((item) => {
                const Icon = item.icon;
                return (
                  <Link
                    key={item.name}
                    href={item.href}
                    onClick={() => setIsMobileMenuOpen(false)}
                    className="flex items-center gap-4 p-3.5 rounded-xl hover:bg-muted transition-colors"
                  >
                    <div className="bg-muted p-2 rounded-lg">
                       <Icon className="h-5 w-5 text-muted-foreground" />
                    </div>
                    <span className="font-medium text-foreground">{item.name}</span>
                    {item.badge > 0 && <span className="ml-auto rounded-full bg-red-500 px-2.5 py-0.5 text-[10px] font-bold text-white shadow-sm shadow-red-500/20">{item.badge > 99 ? '99+' : item.badge}</span>}
                  </Link>
                );
              })}
              
              <div className="h-px w-full bg-border my-2"></div>
              
              {isAdmin && (
                <button
                  onClick={() => { setIsMobileMenuOpen(false); router.push('/dashboard'); }}
                  className="w-full flex items-center gap-4 p-3.5 rounded-xl hover:bg-primary/5 text-primary transition-colors"
                >
                  <div className="bg-primary/10 p-2 rounded-lg">
                    <LayoutDashboard className="h-5 w-5" />
                  </div>
                  <span className="font-medium">Về Quản lý</span>
                </button>
              )}
              <button
                onClick={() => { setIsMobileMenuOpen(false); handleLogout(); }}
                className="w-full flex items-center gap-4 p-3.5 rounded-xl hover:bg-destructive/10 text-destructive transition-colors"
              >
                <div className="bg-destructive/10 p-2 rounded-lg">
                  <LogOut className="h-5 w-5" />
                </div>
                <span className="font-medium">Đăng xuất</span>
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
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#4FA7A0]"></div>
      </div>
    );
  }

  if (status === 'authenticated' && session?.user?.requirePasswordChange) {
    return null;
  }

  return (
    <TenantProvider>
      <div className="min-h-screen bg-background pb-16 lg:pb-0">
        <TenantNavigation
          pathname={pathname}
          handleLogout={handleLogout}
          isMobileMenuOpen={isMobileMenuOpen}
          setIsMobileMenuOpen={setIsMobileMenuOpen}
        />

        {/* Main content */}
        <main className="lg:ml-64 min-h-screen">
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
    <SessionProvider>
      <KhachThueDashboardLayoutContent>{children}</KhachThueDashboardLayoutContent>
    </SessionProvider>
  );
}
