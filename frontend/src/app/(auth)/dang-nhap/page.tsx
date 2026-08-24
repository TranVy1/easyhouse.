'use client';

import { useEffect, useState } from 'react';
import { signIn, getSession } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import Link from 'next/link';
import { Loader2, Mail } from 'lucide-react';
import { toast } from 'sonner';

import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';

import { AuthLayout } from '@/components/auth/AuthLayout';
import { AuthInput } from '@/components/auth/AuthInput';
import { PasswordInput } from '@/components/auth/PasswordInput';
import { FormError } from '@/components/auth/FormError';

// ── Validation ──────────────────────────────────────────────────────────────
const loginSchema = z.object({
  email: z.string().trim().min(1, 'Vui lòng nhập email').email('Email không hợp lệ'),
  matKhau: z.string().trim().min(6, 'Mật khẩu phải có ít nhất 6 ký tự'),
});
type LoginForm = z.infer<typeof loginSchema>;

// ── Page ────────────────────────────────────────────────────────────────────
export default function LoginPage() {
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [forgotEmail, setForgotEmail] = useState('');
  const [forgotLoading, setForgotLoading] = useState(false);
  const [forgotOpen, setForgotOpen] = useState(false);
  const router = useRouter();

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<LoginForm>({ resolver: zodResolver(loginSchema) });

  // Surface NextAuth redirect error (e.g. session expired)
  useEffect(() => {
    if (new URLSearchParams(window.location.search).get('error')) {
      setError('Email hoặc mật khẩu không đúng');
    }
  }, []);

  // ── Submit ────────────────────────────────────────────────────────────────
  const onSubmit = async (data: LoginForm) => {
    if (isLoading) return;
    setIsLoading(true);
    setError('');

    try {
      const result = await signIn('credentials', {
        email: data.email,
        matKhau: data.matKhau,
        redirect: false,
      });

      if (!result?.ok || result.error) {
        setError('Email hoặc mật khẩu không đúng');
        return;
      }

      // Determine redirect target from session role
      const session = await getSession();
      const role = (typeof session?.user?.role === 'string'
        ? session.user.role.replace(/^ROLE_/, '').toUpperCase()
        : '') as string;

      const params = new URLSearchParams(window.location.search);
      let target = params.get('callbackUrl') ?? '';

      // Safely extract path from absolute callback URL
      if (target) {
        try {
          target = new URL(target, window.location.origin).pathname;
        } catch {
          // leave as-is
        }
      }

      if (role === 'TENANT') {
        if (!target || target.startsWith('/dashboard')) target = '/';
      } else {
        if (!target || target === '/') target = '/dashboard';
      }

      router.push(target);
      router.refresh();
    } catch {
      setError('Đã có lỗi xảy ra, vui lòng thử lại');
    } finally {
      setIsLoading(false);
    }
  };

  // ── Forgot password ───────────────────────────────────────────────────────
  const handleForgotSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!forgotEmail.trim()) {
      toast.error('Vui lòng nhập email');
      return;
    }
    setForgotLoading(true);
    try {
      const res = await fetch('/api/auth/forgot-password', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email: forgotEmail }),
      });
      const data = await res.json();
      if (data.success) {
        toast.success('Mật khẩu mới đã được gửi vào email của bạn');
        setForgotOpen(false);
        setForgotEmail('');
      } else {
        toast.error(data.message || 'Đã có lỗi xảy ra');
      }
    } catch {
      toast.error('Lỗi kết nối, vui lòng thử lại sau');
    } finally {
      setForgotLoading(false);
    }
  };

  // ── Render ────────────────────────────────────────────────────────────────
  return (
    <AuthLayout
      title="Chào mừng trở lại 👋"
      description="Đăng nhập để quản lý phòng trọ của bạn"
    >
      <FormError message={error} />

      <form onSubmit={handleSubmit(onSubmit)} noValidate className="space-y-4">
        {/* Email */}
        <AuthInput
          label="Email"
          type="email"
          placeholder="name@example.com"
          autoComplete="email"
          icon={<Mail size={16} />}
          error={errors.email?.message}
          {...register('email')}
        />

        {/* Password */}
        <PasswordInput
          label="Mật khẩu"
          placeholder="Nhập mật khẩu"
          autoComplete="current-password"
          error={errors.matKhau?.message}
          {...register('matKhau')}
        />

        {/* Forgot password — appears right-aligned under the password field */}
        <div className="flex justify-end -mt-2">
          <Dialog open={forgotOpen} onOpenChange={setForgotOpen}>
            <DialogTrigger className="text-[13px] font-semibold text-[#0D9488] hover:text-[#0F766E] transition-colors focus:outline-none focus-visible:underline">
              Quên mật khẩu?
            </DialogTrigger>
            <DialogContent className="sm:max-w-[390px] rounded-[20px] p-0 overflow-hidden border-0 shadow-2xl">
              <div className="px-7 py-7">
                <DialogHeader className="mb-5">
                  <DialogTitle className="text-[18px] font-black text-slate-900">
                    Quên mật khẩu
                  </DialogTitle>
                  <DialogDescription className="text-[13px] text-slate-500 mt-1">
                    Nhập email đăng nhập của bạn. Mật khẩu mới sẽ được gửi ngay về hộp thư.
                  </DialogDescription>
                </DialogHeader>
                <form onSubmit={handleForgotSubmit} className="space-y-4">
                  <AuthInput
                    label="Email tài khoản"
                    type="email"
                    placeholder="your-email@example.com"
                    value={forgotEmail}
                    onChange={(e) => setForgotEmail(e.target.value)}
                    icon={<Mail size={16} />}
                    required
                  />
                  <button
                    type="submit"
                    disabled={forgotLoading}
                    className="
                      w-full h-12 rounded-[12px]
                      bg-slate-900 hover:bg-slate-800
                      text-white text-[14px] font-semibold
                      transition-all duration-150 active:scale-[0.98]
                      disabled:opacity-60 disabled:cursor-not-allowed
                      flex items-center justify-center gap-2
                    "
                  >
                    {forgotLoading ? (
                      <><Loader2 className="h-4 w-4 animate-spin" /> Đang xử lý...</>
                    ) : (
                      'Gửi mật khẩu mới'
                    )}
                  </button>
                </form>
              </div>
            </DialogContent>
          </Dialog>
        </div>

        {/* Submit button — hover lift + active scale */}
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
            'Đăng nhập'
          )}
        </button>
      </form>

      {/* Divider + register + tenant links */}
      <div className="mt-6 pt-6 border-t border-slate-100 space-y-3">
        <p className="text-center text-[14px] text-slate-600 font-medium">
          Chưa có tài khoản?{' '}
          <Link
            href="/dang-ky"
            className="font-bold text-[#0D9488] hover:text-[#0F766E] underline-offset-2 hover:underline transition-all duration-150"
          >
            Đăng ký ngay
          </Link>
        </p>

        {/* Tenant portal shortcut — arrow slides right on hover */}
        <Link
          href="/khach-thue/dang-nhap"
          className="group flex flex-col items-center gap-1 bg-teal-50/60 border border-teal-100 hover:border-teal-200 hover:bg-teal-50 rounded-[14px] px-4 py-3 transition-all duration-200"
        >
          <p className="text-[13px] text-teal-800 font-medium">Bạn là Khách thuê phòng?</p>
          <span className="text-[13px] font-bold text-teal-700 group-hover:text-teal-900 transition-colors flex items-center gap-1">
            Đăng nhập tại Cổng khách thuê
            <span className="inline-block transition-transform duration-180 group-hover:translate-x-[3px]">&rarr;</span>
          </span>
        </Link>
      </div>
    </AuthLayout>
  );
}
