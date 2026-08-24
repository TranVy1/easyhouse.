'use client';

import { Suspense, useState } from 'react';
import { useSearchParams } from 'next/navigation';
import { signIn, SessionProvider } from 'next-auth/react';
import { Loader2, Phone } from 'lucide-react';
import { toast } from 'sonner';
import Link from 'next/link';

import { AuthLayout } from '@/components/auth/AuthLayout';
import { AuthInput } from '@/components/auth/AuthInput';
import { PasswordInput } from '@/components/auth/PasswordInput';
import { FormError } from '@/components/auth/FormError';

// ── Inner component (uses useSearchParams — must be inside Suspense) ────────
function KhachThueDangNhapContent() {
  const searchParams = useSearchParams();
  const callbackUrl = searchParams.get('callbackUrl') || '/khach-thue/dashboard';

  const [formData, setFormData] = useState({ soDienThoai: '', matKhau: '' });
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');

  // ── Submit ────────────────────────────────────────────────────────────────
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.soDienThoai.trim() || !formData.matKhau) {
      setError('Vui lòng nhập đầy đủ Số điện thoại và Mật khẩu');
      return;
    }
    if (isLoading) return;
    setIsLoading(true);
    setError('');

    try {
      const result = await signIn('tenant-credentials', {
        redirect: false,
        soDienThoai: formData.soDienThoai,
        matKhau: formData.matKhau,
      });

      if (result?.error) {
        setError(result.error);
      } else {
        toast.success('Đăng nhập thành công!');
        window.location.href = callbackUrl;
      }
    } catch (err) {
      console.error('Tenant login error:', err);
      setError('Có lỗi xảy ra, vui lòng thử lại sau');
    } finally {
      setIsLoading(false);
    }
  };

  // ── Render ────────────────────────────────────────────────────────────────
  return (
    <AuthLayout
      title="Đăng nhập Khách thuê"
      description="Theo dõi hợp đồng, hóa đơn và sự cố phòng trọ của bạn"
      hideIllustration
    >
      {/* Default password notice */}
      <div className="mb-5 bg-amber-50 border border-amber-200 rounded-[12px] px-4 py-3">
        <p className="text-[13px] font-semibold text-amber-800">Mật khẩu mặc định: 123456</p>
        <p className="text-[12px] text-amber-700/80 mt-0.5">
          Vui lòng đổi mật khẩu sau khi đăng nhập thành công.
        </p>
      </div>

      <FormError message={error} />

      <form onSubmit={handleSubmit} noValidate className="space-y-4">
        <AuthInput
          label="Số điện thoại"
          type="tel"
          placeholder="0123456789"
          autoComplete="tel"
          icon={<Phone size={16} />}
          value={formData.soDienThoai}
          onChange={(e) => setFormData((p) => ({ ...p, soDienThoai: e.target.value }))}
        />

        <PasswordInput
          label="Mật khẩu"
          placeholder="Nhập mật khẩu"
          autoComplete="current-password"
          value={formData.matKhau}
          onChange={(e) => setFormData((p) => ({ ...p, matKhau: e.target.value }))}
        />

        <button
          type="submit"
          disabled={isLoading}
          className="
            w-full h-12 rounded-[12px] mt-2
            bg-[#0D9488] hover:bg-[#0F766E]
            text-white text-[15px] font-bold
            shadow-sm hover:shadow-[0_6px_20px_rgba(13,148,136,0.35)]
            hover:-translate-y-[1px]
            transition-all duration-200 active:scale-[0.98] active:translate-y-0
            disabled:opacity-70 disabled:cursor-not-allowed disabled:hover:translate-y-0
            flex items-center justify-center gap-2
          "
        >
          {isLoading ? (
            <><Loader2 className="h-4 w-4 animate-spin" /> Đang đăng nhập...</>
          ) : (
            'Đăng nhập hệ thống'
          )}
        </button>
      </form>

      {/* Link to landlord portal */}
      <div className="mt-6 pt-5 border-t border-slate-100">
        <div className="bg-blue-50/60 border border-blue-100 rounded-[14px] px-4 py-3 flex flex-col items-center gap-1 hover:bg-blue-50 transition-colors">
          <p className="text-[13px] text-blue-800 font-medium">Bạn là Chủ trọ / Quản lý?</p>
          <Link
            href="/dang-nhap"
            className="text-[13px] font-bold text-blue-700 hover:text-blue-900 transition-colors"
          >
            Đăng nhập tại Cổng quản lý &rarr;
          </Link>
        </div>
      </div>
    </AuthLayout>
  );
}

// ── Root export ─────────────────────────────────────────────────────────────
export default function KhachThueDangNhap() {
  return (
    <SessionProvider>
      <Suspense
        fallback={
          <div className="min-h-screen flex items-center justify-center bg-[#F7F7F5]">
            <Loader2 className="h-8 w-8 animate-spin text-[#0D9488]" />
          </div>
        }
      >
        <KhachThueDangNhapContent />
      </Suspense>
    </SessionProvider>
  );
}
