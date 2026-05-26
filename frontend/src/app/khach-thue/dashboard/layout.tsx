'use client';

import { useState } from 'react';
import { useSession, signOut } from 'next-auth/react';
import { useRouter, usePathname } from 'next/navigation';
import { Button } from '@/components/ui/button';
import { Home, FileText, AlertCircle, User, LogOut, Menu, X } from 'lucide-react';
import Link from 'next/link';
import { toast } from 'sonner';
import { TenantProvider, useTenantDashboard } from './context';

// Navigation component that uses context
function TenantNavigation({ 
  pathname, 
  handleLogout, 
  isMobileMenuOpen, 
  setIsMobileMenuOpen 
}: any) {
  const { data } = useTenantDashboard();
  
  const navigation = [
    { name: 'Tổng quan', href: '/khach-thue/dashboard', icon: Home, badge: 0 },
    { name: 'Hóa đơn', href: '/khach-thue/dashboard/hoa-don', icon: FileText, badge: data?.soHoaDonChuaThanhToan || 0 },
    { name: 'Sự cố', href: '/khach-thue/dashboard/su-co', icon: AlertCircle, badge: data?.soSuCoDangMo || 0 },
    { name: 'Thông báo', href: '/khach-thue/dashboard/thong-bao', icon: AlertCircle, badge: data?.soThongBaoMoi || 0 }, // using alert circle for now, maybe Bell is better
    { name: 'Tài khoản', href: '/khach-thue/dashboard/thong-tin', icon: User, badge: 0 },
  ];

  return (
    <>
      {/* Desktop Sidebar */}
      <aside className={`
        fixed top-0 left-0 z-40 w-64 h-screen transition-transform bg-white border-r hidden lg:block
      `}>
        <div className="h-full px-4 py-6 overflow-y-auto">
          <div className="mb-6 p-4 bg-blue-50 rounded-lg">
            <h2 className="text-lg font-bold text-blue-900">Xin chào,</h2>
            <p className="text-sm text-blue-700 font-medium">{data?.khachThue?.hoTen}</p>
          </div>

          <nav className="space-y-2">
            {navigation.map((item) => {
              const Icon = item.icon;
              const isActive = pathname === item.href;
              return (
                <Link
                  key={item.name}
                  href={item.href}
                  className={`
                    flex items-center gap-3 px-4 py-3 rounded-lg transition-colors relative
                    ${isActive 
                      ? 'bg-blue-600 text-white' 
                      : 'text-gray-700 hover:bg-gray-100'
                    }
                  `}
                >
                  <Icon className="h-5 w-5" />
                  <span className="font-medium">{item.name}</span>
                  {item.badge > 0 && (
                    <span className="absolute right-4 bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">
                      {item.badge}
                    </span>
                  )}
                </Link>
              );
            })}
          </nav>

          <div className="mt-auto pt-6 border-t mt-6">
            <Button
              variant="outline"
              className="w-full justify-start text-red-600 hover:text-red-700 hover:bg-red-50"
              onClick={handleLogout}
            >
              <LogOut className="h-5 w-5 mr-3" />
              Đăng xuất
            </Button>
          </div>
        </div>
      </aside>

      {/* Mobile Bottom Navigation */}
      <nav className="lg:hidden fixed bottom-0 left-0 right-0 z-50 bg-white border-t flex justify-around items-center h-16 px-2 safe-area-bottom pb-safe">
        {navigation.slice(0, 4).map((item) => {
          const Icon = item.icon;
          const isActive = pathname === item.href;
          return (
            <Link
              key={item.name}
              href={item.href}
              className={`
                flex flex-col items-center justify-center w-full h-full relative
                ${isActive ? 'text-blue-600' : 'text-gray-500'}
              `}
            >
              <div className="relative">
                <Icon className="h-6 w-6 mb-1" />
                {item.badge > 0 && (
                  <span className="absolute -top-1 -right-2 bg-red-500 text-white text-[10px] font-bold rounded-full h-4 w-4 flex items-center justify-center border-2 border-white">
                    {item.badge > 9 ? '9+' : item.badge}
                  </span>
                )}
              </div>
              <span className="text-[10px] font-medium">{item.name}</span>
            </Link>
          );
        })}
        {/* Mobile menu trigger for more options */}
        <button
          onClick={() => setIsMobileMenuOpen(true)}
          className={`flex flex-col items-center justify-center w-full h-full relative text-gray-500`}
        >
          <Menu className="h-6 w-6 mb-1" />
          <span className="text-[10px] font-medium">Thêm</span>
        </button>
      </nav>

      {/* Mobile More Options Overlay */}
      {isMobileMenuOpen && (
        <div className="fixed inset-0 z-[60] lg:hidden flex flex-col justify-end">
          <div 
            className="absolute inset-0 bg-black/50" 
            onClick={() => setIsMobileMenuOpen(false)}
          />
          <div className="relative bg-white rounded-t-2xl p-4 pb-safe space-y-4 animate-in slide-in-from-bottom">
            <div className="flex justify-between items-center pb-4 border-b">
              <h3 className="font-bold text-lg">Menu</h3>
              <Button variant="ghost" size="icon" onClick={() => setIsMobileMenuOpen(false)}>
                <X className="h-5 w-5" />
              </Button>
            </div>
            <div className="p-4 bg-blue-50 rounded-lg mb-4">
              <h2 className="text-sm font-bold text-blue-900">Xin chào,</h2>
              <p className="text-lg text-blue-700 font-medium">{data?.khachThue?.hoTen}</p>
            </div>
            <div className="space-y-2">
              <Link 
                href="/khach-thue/dashboard/thong-tin"
                onClick={() => setIsMobileMenuOpen(false)}
                className="flex items-center gap-3 p-3 rounded-lg hover:bg-gray-100"
              >
                <User className="h-5 w-5 text-gray-600" />
                <span className="font-medium text-gray-700">Tài khoản cá nhân</span>
              </Link>
              <button 
                onClick={() => { setIsMobileMenuOpen(false); handleLogout(); }}
                className="w-full flex items-center gap-3 p-3 rounded-lg hover:bg-red-50 text-red-600"
              >
                <LogOut className="h-5 w-5" />
                <span className="font-medium">Đăng xuất</span>
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}

// Removed local data interface

export default function KhachThueDashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const router = useRouter();
  const pathname = usePathname();
  const { data: session, status } = useSession({
    required: true,
    onUnauthenticated() {
      router.push('/khach-thue/dang-nhap');
    },
  });
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  const handleLogout = async () => {
    await signOut({ callbackUrl: '/khach-thue/dang-nhap' });
    toast.success('Đã đăng xuất');
  };

  if (status === 'loading') {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  const khachThue = session?.user;

  const navigation = [
    { name: 'Tổng quan', href: '/khach-thue/dashboard', icon: Home },
    { name: 'Hóa đơn', href: '/khach-thue/dashboard/hoa-don', icon: FileText },
    { name: 'Sự cố', href: '/khach-thue/dashboard/su-co', icon: AlertCircle },
    { name: 'Thông tin cá nhân', href: '/khach-thue/dashboard/thong-tin', icon: User },
  ];

  return (
    <TenantProvider>
      <div className="min-h-screen bg-gray-50 pb-16 lg:pb-0">
        <TenantNavigation 
          pathname={pathname}
          handleLogout={handleLogout}
          isMobileMenuOpen={isMobileMenuOpen}
          setIsMobileMenuOpen={setIsMobileMenuOpen}
        />

        {/* Main content */}
        <main className="lg:ml-64 min-h-screen">
          <div className="p-4 lg:p-8">
            {children}
          </div>
        </main>
      </div>
    </TenantProvider>
  );
}

