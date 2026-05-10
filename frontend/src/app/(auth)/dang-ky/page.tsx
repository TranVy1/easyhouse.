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
import { Loader2, Eye, EyeOff, MailCheck, Sparkles } from 'lucide-react';

const registerSchema = z.object({
  ten: z.string().min(2, 'Tên phải có ít nhất 2 ký tự'),
  email: z.string().email('Email không hợp lệ'),
  matKhau: z.string().min(6, 'Mật khẩu phải có ít nhất 6 ký tự'),
  xacNhanMatKhau: z.string(),
  soDienThoai: z.string().regex(/^[0-9]{10,11}$/, 'Số điện thoại không hợp lệ'),
  vaiTro: z.enum(['chuNha', 'nhanVien'], {
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
    <div className="relative min-h-screen overflow-hidden bg-slate-950 py-6 md:py-12 px-4 sm:px-6 lg:px-8">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_15%_15%,rgba(14,165,233,0.2),transparent_42%),radial-gradient(circle_at_85%_20%,rgba(34,197,94,0.22),transparent_44%),radial-gradient(circle_at_55%_80%,rgba(250,204,21,0.14),transparent_38%)]" />
      <div className="absolute -left-12 top-20 h-56 w-56 rounded-full bg-cyan-400/20 blur-3xl" />
      <div className="absolute right-0 top-1/3 h-64 w-64 rounded-full bg-emerald-400/20 blur-3xl" />

      <div className="relative z-10 mx-auto max-w-md w-full space-y-6 md:space-y-8">
        <div className="text-center">
          <div className="mb-3 inline-flex items-center gap-2 rounded-full border border-white/20 bg-white/10 px-3 py-1 text-xs font-medium text-white backdrop-blur">
            <Sparkles className="h-3 w-3" />
            Tài khoản mới
          </div>
          <h2 className="mt-2 text-2xl md:text-3xl font-bold text-white">
            Đăng ký tài khoản
          </h2>
          <p className="mt-2 text-xs md:text-sm text-slate-200">
            Quản lý phòng trọ
          </p>
        </div>
        
        <Card className="border-white/20 bg-white/95 shadow-2xl backdrop-blur-sm">
          <CardHeader className="p-4 md:p-6">
            <CardTitle className="text-lg md:text-xl">Đăng ký</CardTitle>
            <CardDescription className="text-xs md:text-sm">
              Tạo tài khoản mới để sử dụng hệ thống
            </CardDescription>
          </CardHeader>
          <CardContent className="p-4 md:p-6">
            <form onSubmit={handleSubmit(onSubmit)} className="space-y-3 md:space-y-4">
              {error && (
                <Alert variant="destructive">
                  <AlertDescription>{error}</AlertDescription>
                </Alert>
              )}

              {success && (
                <Alert className="border-green-300 bg-green-50 text-green-700">
                  <MailCheck className="h-4 w-4" />
                  <AlertDescription>{success}</AlertDescription>
                </Alert>
              )}

              <div className="space-y-2">
                <Label htmlFor="ten" className="text-xs md:text-sm">Họ và tên</Label>
                <Input
                  id="ten"
                  placeholder="Nhập họ và tên"
                  {...register('ten')}
                  className={`text-sm ${errors.ten ? 'border-red-500' : ''}`}
                />
                {errors.ten && (
                  <p className="text-xs md:text-sm text-red-500">{errors.ten.message}</p>
                )}
              </div>

              <div className="space-y-2">
                <Label htmlFor="email" className="text-xs md:text-sm">Email</Label>
                <Input
                  id="email"
                  type="email"
                  placeholder="Nhập email"
                  {...register('email')}
                  className={`text-sm ${errors.email ? 'border-red-500' : ''}`}
                />
                {errors.email && (
                  <p className="text-xs md:text-sm text-red-500">{errors.email.message}</p>
                )}
              </div>

              <div className="space-y-2">
                <Label htmlFor="soDienThoai" className="text-xs md:text-sm">Số điện thoại</Label>
                <Input
                  id="soDienThoai"
                  placeholder="Nhập số điện thoại"
                  {...register('soDienThoai')}
                  className={`text-sm ${errors.soDienThoai ? 'border-red-500' : ''}`}
                />
                {errors.soDienThoai && (
                  <p className="text-xs md:text-sm text-red-500">{errors.soDienThoai.message}</p>
                )}
              </div>

              <div className="space-y-2">
                <Label htmlFor="vaiTro" className="text-xs md:text-sm">Vai trò</Label>
                <Select onValueChange={(value) => setValue('vaiTro', value as 'chuNha' | 'nhanVien')}>
                  <SelectTrigger className={`text-sm ${errors.vaiTro ? 'border-red-500' : ''}`}>
                    <SelectValue placeholder="Chọn vai trò" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="chuNha" className="text-sm">Chủ nhà</SelectItem>
                    <SelectItem value="nhanVien" className="text-sm">Nhân viên</SelectItem>
                  </SelectContent>
                </Select>
                {errors.vaiTro && (
                  <p className="text-xs md:text-sm text-red-500">{errors.vaiTro.message}</p>
                )}
              </div>

              <div className="space-y-2">
                <Label htmlFor="matKhau" className="text-xs md:text-sm">Mật khẩu</Label>
                <div className="relative">
                  <Input
                    id="matKhau"
                    type={showPassword ? 'text' : 'password'}
                    placeholder="Nhập mật khẩu"
                    {...register('matKhau')}
                    className={`text-sm ${errors.matKhau ? 'border-red-500 pr-10' : 'pr-10'}`}
                  />
                  <Button
                    type="button"
                    variant="ghost"
                    size="sm"
                    className="absolute right-0 top-0 h-full px-3 py-2 hover:bg-transparent"
                    onClick={() => setShowPassword(!showPassword)}
                  >
                    {showPassword ? (
                      <EyeOff className="h-3.5 w-3.5 md:h-4 md:w-4" />
                    ) : (
                      <Eye className="h-3.5 w-3.5 md:h-4 md:w-4" />
                    )}
                  </Button>
                </div>
                {errors.matKhau && (
                  <p className="text-xs md:text-sm text-red-500">{errors.matKhau.message}</p>
                )}
              </div>

              <div className="space-y-2">
                <Label htmlFor="xacNhanMatKhau" className="text-xs md:text-sm">Xác nhận mật khẩu</Label>
                <div className="relative">
                  <Input
                    id="xacNhanMatKhau"
                    type={showConfirmPassword ? 'text' : 'password'}
                    placeholder="Nhập lại mật khẩu"
                    {...register('xacNhanMatKhau')}
                    className={`text-sm ${errors.xacNhanMatKhau ? 'border-red-500 pr-10' : 'pr-10'}`}
                  />
                  <Button
                    type="button"
                    variant="ghost"
                    size="sm"
                    className="absolute right-0 top-0 h-full px-3 py-2 hover:bg-transparent"
                    onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                  >
                    {showConfirmPassword ? (
                      <EyeOff className="h-3.5 w-3.5 md:h-4 md:w-4" />
                    ) : (
                      <Eye className="h-3.5 w-3.5 md:h-4 md:w-4" />
                    )}
                  </Button>
                </div>
                {errors.xacNhanMatKhau && (
                  <p className="text-xs md:text-sm text-red-500">{errors.xacNhanMatKhau.message}</p>
                )}
              </div>

              <Button
                type="submit"
                size="sm"
                className="w-full"
                disabled={isLoading}
              >
                {isLoading ? (
                  <>
                    <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                    Đang đăng ký...
                  </>
                ) : (
                  'Đăng ký'
                )}
              </Button>
            </form>

            <div className="mt-4 md:mt-6 text-center">
              <p className="text-xs md:text-sm text-gray-600">
                Đã có tài khoản?{' '}
                <Link href="/dang-nhap" className="font-medium text-blue-600 hover:text-blue-500">
                  Đăng nhập ngay
                </Link>
              </p>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
