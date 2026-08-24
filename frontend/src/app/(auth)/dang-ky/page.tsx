'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import Link from 'next/link';
import { Loader2, Mail, CheckCircle2, Phone, User } from 'lucide-react';

import { AuthLayout } from '@/components/auth/AuthLayout';
import { AuthInput } from '@/components/auth/AuthInput';
import { PasswordInput } from '@/components/auth/PasswordInput';
import { FormError } from '@/components/auth/FormError';

// ── Validation ──────────────────────────────────────────────────────────────
const registerSchema = z
  .object({
    ten: z.string().min(2, 'Tên phải có ít nhất 2 ký tự'),
    email: z.string().email('Email không hợp lệ'),
    matKhau: z.string().min(6, 'Mật khẩu phải có ít nhất 6 ký tự'),
    xacNhanMatKhau: z.string(),
    soDienThoai: z.string().regex(/^[0-9]{10,11}$/, 'Số điện thoại không hợp lệ (10–11 số)'),
  })
  .refine((d) => d.matKhau === d.xacNhanMatKhau, {
    message: 'Mật khẩu xác nhận không khớp',
    path: ['xacNhanMatKhau'],
  });

type RegisterForm = z.infer<typeof registerSchema>;

// ── Page ────────────────────────────────────────────────────────────────────
export default function RegisterPage() {
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [isSuccess, setIsSuccess] = useState(false);
  const router = useRouter();

  const {
    register,
    handleSubmit,
    watch,
    formState: { errors },
  } = useForm<RegisterForm>({ resolver: zodResolver(registerSchema) });

  const pwdValue = watch('matKhau') ?? '';

  // ── Submit ────────────────────────────────────────────────────────────────
  const onSubmit = async (data: RegisterForm) => {
    if (isLoading) return;
    setIsLoading(true);
    setError('');

    try {
      const res = await fetch('/api/auth/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          ten: data.ten,
          email: data.email,
          matKhau: data.matKhau,
          soDienThoai: data.soDienThoai,
          vaiTro: 'LANDLORD',
        }),
      });

      const result = await res.json();

      if (result.success) {
        setIsSuccess(true);
        setTimeout(() => router.push('/dang-nhap'), 3000);
      } else {
        setError(result.message || 'Đã xảy ra lỗi, vui lòng thử lại');
      }
    } catch {
      setError('Đã xảy ra lỗi, vui lòng thử lại');
    } finally {
      setIsLoading(false);
    }
  };

  // ── Success screen ────────────────────────────────────────────────────────
  if (isSuccess) {
    return (
      <AuthLayout title="" hideIllustration>
        <div className="flex flex-col items-center text-center py-8 animate-in fade-in zoom-in-95 duration-500">
          <div className="h-16 w-16 rounded-full bg-teal-50 border border-teal-200 flex items-center justify-center mb-5 shadow-sm">
            <CheckCircle2 className="h-8 w-8 text-[#0D9488]" />
          </div>
          <h2 className="text-[22px] font-black text-slate-900 mb-2">Đăng ký thành công!</h2>
          <p className="text-[14px] text-slate-500 leading-relaxed max-w-[300px]">
            Tài khoản đã được tạo. Đang chuyển hướng về trang Đăng nhập…
          </p>
        </div>
      </AuthLayout>
    );
  }

  // ── Render form ───────────────────────────────────────────────────────────
  return (
    <AuthLayout
      title="Tạo tài khoản"
      description="Đăng ký để bắt đầu quản lý phòng trọ cùng EasyHouse"
      hideIllustration
    >
      <FormError message={error} />

      <form onSubmit={handleSubmit(onSubmit)} noValidate className="space-y-0">

        {/* ── Section: Thông tin cá nhân ── */}
        <div className="flex items-center gap-2 mb-3">
          <span className="text-[11px] font-bold text-slate-400 uppercase tracking-widest whitespace-nowrap">
            Thông tin cá nhân
          </span>
          <div className="h-px bg-slate-100 flex-1" />
        </div>

        <div className="space-y-4 mb-5">
          <AuthInput
            label="Họ và tên"
            placeholder="Nguyễn Văn A"
            autoComplete="name"
            icon={<User size={16} />}
            error={errors.ten?.message}
            {...register('ten')}
          />
          <AuthInput
            label="Số điện thoại"
            type="tel"
            placeholder="0912345678"
            autoComplete="tel"
            icon={<Phone size={16} />}
            error={errors.soDienThoai?.message}
            {...register('soDienThoai')}
          />
        </div>

        {/* ── Section: Tài khoản ── */}
        <div className="flex items-center gap-2 mb-3">
          <span className="text-[11px] font-bold text-slate-400 uppercase tracking-widest whitespace-nowrap">
            Tài khoản
          </span>
          <div className="h-px bg-slate-100 flex-1" />
        </div>

        <div className="space-y-4 mb-6">
          <AuthInput
            label="Email"
            type="email"
            placeholder="name@example.com"
            autoComplete="email"
            icon={<Mail size={16} />}
            error={errors.email?.message}
            {...register('email')}
          />
          <PasswordInput
            label="Mật khẩu"
            placeholder="Ít nhất 6 ký tự"
            autoComplete="new-password"
            showStrength
            value={pwdValue}
            error={errors.matKhau?.message}
            {...register('matKhau')}
          />
          <PasswordInput
            label="Xác nhận mật khẩu"
            placeholder="Nhập lại mật khẩu"
            autoComplete="new-password"
            error={errors.xacNhanMatKhau?.message}
            {...register('xacNhanMatKhau')}
          />
        </div>

        {/* Submit */}
        <button
          type="submit"
          disabled={isLoading}
          className="
            w-full h-12 rounded-[12px]
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
            <><Loader2 className="h-4 w-4 animate-spin" /> Đang xử lý...</>
          ) : (
            'Tạo tài khoản'
          )}
        </button>
      </form>

      {/* Sign-in link */}
      <div className="mt-6 pt-5 border-t border-slate-100 text-center space-y-3">
        <p className="text-[14px] text-slate-600 font-medium">
          Đã có tài khoản?{' '}
          <Link href="/dang-nhap" className="font-bold text-[#0D9488] hover:text-[#0F766E] transition-colors">
            Đăng nhập
          </Link>
        </p>
        <p className="text-[11px] text-slate-400">
          Bằng cách đăng ký, bạn đồng ý với{' '}
          <Link href="#" className="underline hover:text-slate-600 transition-colors">Điều khoản dịch vụ</Link>
          {' '}và{' '}
          <Link href="#" className="underline hover:text-slate-600 transition-colors">Chính sách bảo mật</Link>.
        </p>
      </div>
    </AuthLayout>
  );
}
