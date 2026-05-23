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
  vaiTro: z.enum(['LANDLORD', 'STAFF', 'TENANT'], {
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
      vaiTro: 'LANDLORD',
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
    <div className="min-h-screen flex items-center justify-center bg-[#f8fafc] dark:bg-slate-950 px-4 py-12 relative overflow-hidden">
      {/* Background Elements */}
      <div className="absolute inset-0 z-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-[10%] -left-[10%] w-[50%] h-[50%] rounded-full bg-blue-500/5 blur-[120px]" />
        <div className="absolute -bottom-[10%] -right-[10%] w-[50%] h-[50%] rounded-full bg-emerald-500/5 blur-[120px]" />
      </div>

      <div className="w-full max-w-[650px] z-10">
        <div className="text-center mb-10">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-blue-50 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 text-xs font-bold uppercase tracking-wider mb-6 border border-blue-100 dark:border-blue-800">
            <Sparkles className="h-3.5 w-3.5" />
            Khởi đầu mới cùng EasyHouse
          </div>
          <h1 className="text-4xl font-extrabold text-slate-900 dark:text-white tracking-tight">Tham gia EasyHouse</h1>
        
        </div>

        <Card className="border-none shadow-2xl shadow-slate-200/60 dark:shadow-none dark:bg-slate-900/50 dark:backdrop-blur-xl overflow-hidden">
          <div className="h-1.5 w-full bg-gradient-to-r from-blue-600 to-indigo-600" />
          <CardHeader className="space-y-3 p-8 pb-2 text-center">
            <div className="space-y-1">
              <CardTitle className="text-2xl font-bold text-slate-900 dark:text-white">
                Đăng Ký
              </CardTitle>
              <CardDescription className="text-base font-medium text-slate-500 dark:text-slate-400">
                Tạo tài khoản mới trên EasyHouse
              </CardDescription>
            </div>
          </CardHeader>
          <CardContent className="p-8 pt-4">
            <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
              {error && (
                <Alert variant="destructive" className="bg-red-50 dark:bg-red-900/20 border-red-200 dark:border-red-800">
                  <AlertDescription className="text-red-800 dark:text-red-400 font-medium">{error}</AlertDescription>
                </Alert>
              )}

              {success && (
                <Alert className="border-emerald-200 bg-emerald-50 dark:bg-emerald-900/20 text-emerald-800 dark:text-emerald-400">
                  <MailCheck className="h-5 w-5 mr-3" />
                  <AlertDescription className="font-medium">{success}</AlertDescription>
                </Alert>
              )}

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* Họ tên */}
                <div className="space-y-2">
                  <Label htmlFor="ten" className="text-sm font-semibold text-slate-700 dark:text-slate-300 ml-1">Họ và tên</Label>
                  <Input
                    id="ten"
                    placeholder="Nguyễn Văn A"
                    {...register('ten')}
                    className={`h-12 bg-slate-50/50 dark:bg-slate-800/50 border-slate-200 dark:border-slate-700 focus:ring-2 focus:ring-blue-500/20 transition-all ${errors.ten ? 'border-red-500' : ''}`}
                  />
                  {errors.ten && (
                    <p className="text-xs text-red-500 font-medium ml-1">{errors.ten.message}</p>
                  )}
                </div>

                {/* Email */}
                <div className="space-y-2">
                  <Label htmlFor="email" className="text-sm font-semibold text-slate-700 dark:text-slate-300 ml-1">Email</Label>
                  <Input
                    id="email"
                    type="email"
                    placeholder="name@example.com"
                    {...register('email')}
                    className={`h-12 bg-slate-50/50 dark:bg-slate-800/50 border-slate-200 dark:border-slate-700 focus:ring-2 focus:ring-blue-500/20 transition-all ${errors.email ? 'border-red-500' : ''}`}
                  />
                  {errors.email && (
                    <p className="text-xs text-red-500 font-medium ml-1">{errors.email.message}</p>
                  )}
                </div>

                {/* Số điện thoại */}
                <div className="space-y-2 md:col-span-2">
                  <Label htmlFor="soDienThoai" className="text-sm font-semibold text-slate-700 dark:text-slate-300 ml-1">Số điện thoại</Label>
                  <Input
                    id="soDienThoai"
                    placeholder="0912345678"
                    {...register('soDienThoai')}
                    className={`h-12 bg-slate-50/50 dark:bg-slate-800/50 border-slate-200 dark:border-slate-700 focus:ring-2 focus:ring-blue-500/20 transition-all ${errors.soDienThoai ? 'border-red-500' : ''}`}
                  />
                  {errors.soDienThoai && (
                    <p className="text-xs text-red-500 font-medium ml-1">{errors.soDienThoai.message}</p>
                  )}
                </div>

                {/* Mật khẩu */}
                <div className="space-y-2">
                  <Label htmlFor="matKhau" className="text-sm font-semibold text-slate-700 dark:text-slate-300 ml-1">Mật khẩu</Label>
                  <div className="relative">
                    <Input
                      id="matKhau"
                      type={showPassword ? 'text' : 'password'}
                      placeholder="••••••••"
                      {...register('matKhau')}
                      className={`h-12 bg-slate-50/50 dark:bg-slate-800/50 border-slate-200 dark:border-slate-700 focus:ring-2 focus:ring-blue-500/20 transition-all ${errors.matKhau ? 'border-red-500 pr-12' : 'pr-12'}`}
                    />
                    <button
                      type="button"
                      className="absolute right-0 top-0 h-full px-4 text-slate-400 hover:text-slate-600 dark:hover:text-slate-300 transition-colors"
                      onClick={() => setShowPassword(!showPassword)}
                    >
                      {showPassword ? <EyeOff className="h-5 w-5" /> : <Eye className="h-5 w-5" />}
                    </button>
                  </div>
                  {errors.matKhau && (
                    <p className="text-xs text-red-500 font-medium ml-1">{errors.matKhau.message}</p>
                  )}
                </div>

                {/* Xác nhận mật khẩu */}
                <div className="space-y-2">
                  <Label htmlFor="xacNhanMatKhau" className="text-sm font-semibold text-slate-700 dark:text-slate-300 ml-1">Xác nhận mật khẩu</Label>
                  <div className="relative">
                    <Input
                      id="xacNhanMatKhau"
                      type={showConfirmPassword ? 'text' : 'password'}
                      placeholder="••••••••"
                      {...register('xacNhanMatKhau')}
                      className={`h-12 bg-slate-50/50 dark:bg-slate-800/50 border-slate-200 dark:border-slate-700 focus:ring-2 focus:ring-blue-500/20 transition-all ${errors.xacNhanMatKhau ? 'border-red-500 pr-12' : 'pr-12'}`}
                    />
                    <button
                      type="button"
                      className="absolute right-0 top-0 h-full px-4 text-slate-400 hover:text-slate-600 dark:hover:text-slate-300 transition-colors"
                      onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                    >
                      {showConfirmPassword ? <EyeOff className="h-5 w-5" /> : <Eye className="h-5 w-5" />}
                    </button>
                  </div>
                  {errors.xacNhanMatKhau && (
                    <p className="text-xs text-red-500 font-medium ml-1">{errors.xacNhanMatKhau.message}</p>
                  )}
                </div>
              </div>

              {/* Vai trò */}
              <div className="space-y-2">
                <Label htmlFor="vaiTro" className="text-sm font-semibold text-slate-700 dark:text-slate-300 ml-1">Bạn là</Label>
                <Select
                  defaultValue="LANDLORD"
                  onValueChange={(value) => setValue('vaiTro', value as 'LANDLORD' | 'STAFF' | 'TENANT')}
                >
                  <SelectTrigger className="h-12 bg-slate-50/50 dark:bg-slate-800/50 border-slate-200 dark:border-slate-700">
                    <SelectValue placeholder="Chọn vai trò" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="LANDLORD">Chủ trọ</SelectItem>
                    <SelectItem value="TENANT">Người thuê</SelectItem>
                  </SelectContent>
                </Select>
                {errors.vaiTro && (
                  <p className="text-xs text-red-500 font-medium ml-1">{errors.vaiTro.message}</p>
                )}
              </div>

              <div className="pt-4">
                <Button
                  type="submit"
                  className="w-full h-12 text-base font-bold bg-blue-600 hover:bg-blue-700 shadow-lg shadow-blue-500/25 transition-all active:scale-[0.98]"
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
                <span className="w-full border-t border-slate-200 dark:border-slate-800"></span>
              </div>
              <div className="relative flex justify-center text-xs uppercase">
                <span className="bg-white dark:bg-[#0f172a] px-4 text-slate-500 dark:text-slate-400 font-medium">Bạn đã có tài khoản?</span>
              </div>
            </div>

            <div className="text-center">
              <Link href="/dang-nhap" className="inline-flex items-center text-sm font-bold text-blue-600 hover:text-blue-500 transition-colors">
                Quay lại đăng nhập
              </Link>
            </div>
          </CardContent>
        </Card>

        <p className="mt-8 text-center text-xs text-slate-400">
          Bằng cách đăng ký, bạn đồng ý với Điều khoản & Chính sách bảo mật của chúng tôi.
        </p>
      </div>
    </div>
  );
}
