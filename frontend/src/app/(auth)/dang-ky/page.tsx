'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { Loader2, Eye, EyeOff, MailCheck, ArrowLeft } from 'lucide-react';

const registerSchema = z.object({
  ten: z.string().min(2, 'Tên phải có ít nhất 2 ký tự'),
  email: z.string().email('Email không hợp lệ'),
  matKhau: z.string().min(6, 'Mật khẩu phải có ít nhất 6 ký tự'),
  xacNhanMatKhau: z.string(),
  soDienThoai: z.string().regex(/^[0-9]{10,11}$/, 'Số điện thoại không hợp lệ'),
  vaiTro: z.enum(['ADMIN', 'TENANT'], {
    error: 'Vui lòng chọn vai trò',
  }),
}).refine((data) => data.matKhau === data.xacNhanMatKhau, {
  message: 'Mật khẩu xác nhận không khớp',
  path: ['xacNhanMatKhau'],
});

type RegisterForm = z.infer<typeof registerSchema>;

export default function RegisterPage() {
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const router = useRouter();

  const {
    register,
    handleSubmit,
    setValue,
    formState: { errors },
  } = useForm<RegisterForm>({
    resolver: zodResolver(registerSchema),
    defaultValues: {
      vaiTro: 'ADMIN',
    },
  });

  const onSubmit = async (data: RegisterForm) => {
    setIsLoading(true);
    setError('');
    setSuccess('');

    try {
      const response = await fetch('/api/auth/register', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ten: data.ten,
          email: data.email,
          matKhau: data.matKhau,
          soDienThoai: data.soDienThoai,
          vaiTro: data.vaiTro,
        }),
      });

      const result = await response.json();

      if (result.success) {
        setSuccess('Đăng ký thành công! Vui lòng kiểm tra email để xác thực tài khoản trước khi đăng nhập.');
        setTimeout(() => {
          router.push('/dang-nhap');
        }, 2500);
      } else {
        setError(result.message || 'Đã xảy ra lỗi, vui lòng thử lại');
      }
    } catch {
      setError('Đã xảy ra lỗi, vui lòng thử lại');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-[#F8F3EC] dark:bg-[#172A42] px-4 py-12 relative overflow-hidden">
      {/* Back to Home Button */}
      <div className="absolute top-6 left-6 z-20">
        <Link 
          href="/" 
          className="flex items-center gap-1.5 text-xs font-bold text-[#6B7A8C] hover:text-[#243B5A] transition-colors bg-[#FFFDF8] dark:bg-[#243B5A] border border-[#E8DED2] dark:border-[#243B5A]/25 px-4 py-2.5 rounded-xl shadow-sm hover:bg-[#F8F3EC]"
        >
          <ArrowLeft size={14} /> Trở về trang chủ
        </Link>
      </div>

      {/* Background Elements */}
      <div className="absolute inset-0 z-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-[10%] -left-[10%] w-[50%] h-[50%] rounded-full bg-[#4FA7A0]/5 blur-[120px]" />
        <div className="absolute -bottom-[10%] -right-[10%] w-[50%] h-[50%] rounded-full bg-[#FF5A3D]/5 blur-[120px]" />
      </div>

      <div className="w-full max-w-[650px] z-10">
        {/* Brand Logo Banner */}
        <div className="flex flex-col items-center justify-center mb-8">
          <Link href="/" className="flex flex-col items-center select-none cursor-pointer group">
            <h1 className="text-3xl font-black text-[#243B5A] tracking-tight leading-none uppercase flex items-center gap-1 group-hover:opacity-90 transition-opacity">
              EASY<span className="text-[#243B5A] dark:text-white">HOUSE</span>
            </h1>
            <p className="text-[10px] text-[#6B7A8C] font-medium mt-1 uppercase tracking-wider">Kênh thông tin phòng trọ số 1 Việt Nam</p>
          </Link>
        </div>

        <Card className="border-none shadow-2xl shadow-[#243B5A]/10 dark:shadow-none dark:bg-[#243B5A]/50 dark:backdrop-blur-xl overflow-hidden rounded-2xl">
          {/* Brand Gradient Bar */}
          <div className="h-1.5 w-full bg-gradient-to-r from-blue-600 to-[#FF5A3D]" />
          <CardHeader className="space-y-3 p-8 pb-2 text-center">
            <div className="space-y-1">
              <CardTitle className="text-2xl font-black text-[#243B5A] dark:text-white">
                ĐĂNG KÝ
              </CardTitle>
              <CardDescription className="text-sm font-medium text-[#6B7A8C] dark:text-[#6B7A8C]">
                Tạo tài khoản mới trên EasyHouse
              </CardDescription>
            </div>
          </CardHeader>
          <CardContent className="p-8 pt-4">
            <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
              {error && (
                <Alert variant="destructive" className="bg-red-50 dark:bg-red-900/20 border-red-200 dark:border-red-800 rounded-xl">
                  <AlertDescription className="text-red-800 dark:text-red-400 font-bold text-xs">{error}</AlertDescription>
                </Alert>
              )}

              {success && (
                <Alert className="border-[#4FA7A0]/30 bg-[#4FA7A0]/10 dark:bg-[#4FA7A0]/20 text-[#267D76] dark:text-[#8CCBC5] rounded-xl">
                  <MailCheck className="h-5 w-5 mr-3" />
                  <AlertDescription className="font-bold text-xs">{success}</AlertDescription>
                </Alert>
              )}

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* Họ tên */}
                <div className="space-y-2">
                  <Label htmlFor="ten" className="text-xs font-bold text-[#243B5A] dark:text-slate-300 ml-1 uppercase tracking-wider">Họ và tên</Label>
                  <Input
                    id="ten"
                    placeholder="Nguyễn Văn A"
                    {...register('ten')}
                    className={`h-12 rounded-xl bg-[#F8F3EC]/50 dark:bg-[#1E344E] border-[#E8DED2] dark:border-white/15 focus:ring-2 focus:ring-[#4FA7A0]/25 transition-all ${errors.ten ? 'border-red-500' : ''}`}
                  />
                  {errors.ten && (
                    <p className="text-xs text-red-500 font-bold ml-1">{errors.ten.message}</p>
                  )}
                </div>

                {/* Email */}
                <div className="space-y-2">
                  <Label htmlFor="email" className="text-xs font-bold text-[#243B5A] dark:text-slate-300 ml-1 uppercase tracking-wider">Email</Label>
                  <Input
                    id="email"
                    type="email"
                    placeholder="name@example.com"
                    {...register('email')}
                    className={`h-12 rounded-xl bg-[#F8F3EC]/50 dark:bg-[#1E344E] border-[#E8DED2] dark:border-white/15 focus:ring-2 focus:ring-[#4FA7A0]/25 transition-all ${errors.email ? 'border-red-500' : ''}`}
                  />
                  {errors.email && (
                    <p className="text-xs text-red-500 font-bold ml-1">{errors.email.message}</p>
                  )}
                </div>

                {/* Số điện thoại */}
                <div className="space-y-2 md:col-span-2">
                  <Label htmlFor="soDienThoai" className="text-xs font-bold text-[#243B5A] dark:text-slate-300 ml-1 uppercase tracking-wider">Số điện thoại</Label>
                  <Input
                    id="soDienThoai"
                    placeholder="0912345678"
                    {...register('soDienThoai')}
                    className={`h-12 rounded-xl bg-[#F8F3EC]/50 dark:bg-[#1E344E] border-[#E8DED2] dark:border-white/15 focus:ring-2 focus:ring-[#4FA7A0]/25 transition-all ${errors.soDienThoai ? 'border-red-500' : ''}`}
                  />
                  {errors.soDienThoai && (
                    <p className="text-xs text-red-500 font-bold ml-1">{errors.soDienThoai.message}</p>
                  )}
                </div>

                {/* Mật khẩu */}
                <div className="space-y-2">
                  <Label htmlFor="matKhau" className="text-xs font-bold text-[#243B5A] dark:text-slate-300 ml-1 uppercase tracking-wider">Mật khẩu</Label>
                  <div className="relative">
                    <Input
                      id="matKhau"
                      type={showPassword ? 'text' : 'password'}
                      placeholder="••••••••"
                      {...register('matKhau')}
                      className={`h-12 rounded-xl bg-[#F8F3EC]/50 dark:bg-[#1E344E] border-[#E8DED2] dark:border-white/15 focus:ring-2 focus:ring-[#4FA7A0]/25 transition-all ${errors.matKhau ? 'border-red-500 pr-12' : 'pr-12'}`}
                    />
                    <button
                      type="button"
                      className="absolute right-0 top-0 h-full px-4 text-[#6B7A8C] hover:text-[#6B7A8C] dark:hover:text-slate-300 transition-colors"
                      onClick={() => setShowPassword(!showPassword)}
                    >
                      {showPassword ? <EyeOff className="h-5 w-5" /> : <Eye className="h-5 w-5" />}
                    </button>
                  </div>
                  {errors.matKhau && (
                    <p className="text-xs text-red-500 font-bold ml-1">{errors.matKhau.message}</p>
                  )}
                </div>

                {/* Xác nhận mật khẩu */}
                <div className="space-y-2">
                  <Label htmlFor="xacNhanMatKhau" className="text-xs font-bold text-[#243B5A] dark:text-slate-300 ml-1 uppercase tracking-wider">Xác nhận mật khẩu</Label>
                  <div className="relative">
                    <Input
                      id="xacNhanMatKhau"
                      type={showConfirmPassword ? 'text' : 'password'}
                      placeholder="••••••••"
                      {...register('xacNhanMatKhau')}
                      className={`h-12 rounded-xl bg-[#F8F3EC]/50 dark:bg-[#1E344E] border-[#E8DED2] dark:border-white/15 focus:ring-2 focus:ring-[#4FA7A0]/25 transition-all ${errors.xacNhanMatKhau ? 'border-red-500 pr-12' : 'pr-12'}`}
                    />
                    <button
                      type="button"
                      className="absolute right-0 top-0 h-full px-4 text-[#6B7A8C] hover:text-[#6B7A8C] dark:hover:text-slate-300 transition-colors"
                      onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                    >
                      {showConfirmPassword ? <EyeOff className="h-5 w-5" /> : <Eye className="h-5 w-5" />}
                    </button>
                  </div>
                  {errors.xacNhanMatKhau && (
                    <p className="text-xs text-red-500 font-bold ml-1">{errors.xacNhanMatKhau.message}</p>
                  )}
                </div>
              </div>

              {/* Vai trò */}
              <div className="space-y-2">
                <Label htmlFor="vaiTro" className="text-xs font-bold text-[#243B5A] dark:text-slate-300 ml-1 uppercase tracking-wider">Bạn là</Label>
                <Select
                  defaultValue="ADMIN"
                  onValueChange={(value) => setValue('vaiTro', value as 'ADMIN' | 'TENANT')}
                >
                  <SelectTrigger className="h-12 rounded-xl bg-[#F8F3EC]/50 dark:bg-[#1E344E] border-[#E8DED2] dark:border-white/15 focus:ring-2 focus:ring-[#4FA7A0]/25">
                    <SelectValue placeholder="Chọn vai trò" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="ADMIN">Chủ trọ / Quản lý</SelectItem>
                    <SelectItem value="TENANT">Người thuê / Khách thuê</SelectItem>
                  </SelectContent>
                </Select>
                {errors.vaiTro && (
                  <p className="text-xs text-red-500 font-bold ml-1">{errors.vaiTro.message}</p>
                )}
              </div>

              <div className="pt-4">
                <Button
                  type="submit"
                  className="w-full h-12 rounded-xl text-base font-bold bg-[#FF5A3D] hover:bg-[#E54F35] text-white shadow-lg shadow-orange-500/20 hover:shadow-orange-500/25 transition-all active:scale-[0.98]"
                  disabled={isLoading}
                >
                  {isLoading ? (
                    <>
                      <Loader2 className="mr-2 h-5 w-5 animate-spin" />
                      Đang xử lý đăng ký...
                    </>
                  ) : (
                    'Tạo tài khoản ngay'
                  )}
                </Button>
              </div>
            </form>

            <div className="relative my-8">
              <div className="absolute inset-0 flex items-center">
                <span className="w-full border-t border-[#E8DED2] dark:border-[#243B5A]/25"></span>
              </div>
              <div className="relative flex justify-center text-xs uppercase">
                <span className="bg-[#FFFDF8] dark:bg-[#1E344E] px-4 text-[#6B7A8C] dark:text-[#6B7A8C] font-bold">Bạn đã có tài khoản?</span>
              </div>
            </div>

            <div className="text-center">
              <Link href="/dang-nhap" className="inline-flex items-center text-sm font-extrabold text-[#243B5A] hover:text-[#243B5A] transition-colors hover:underline">
                Quay lại đăng nhập
              </Link>
            </div>
          </CardContent>
        </Card>

        <p className="mt-8 text-center text-xs text-[#6B7A8C]">
          Bằng cách đăng ký, bạn đồng ý với Điều khoản & Chính sách bảo mật của chúng tôi.
        </p>
      </div>
    </div>
  );
}
