'use client';

import { useEffect, useState } from 'react';
import { signIn } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { Loader2, Eye, EyeOff } from 'lucide-react';

import { 
  Dialog, 
  DialogContent, 
  DialogDescription, 
  DialogFooter, 
  DialogHeader, 
  DialogTitle, 
  DialogTrigger 
} from '@/components/ui/dialog';
import { toast } from 'sonner';

const loginSchema = z.object({
  email: z.string().email('Email không hợp lệ'),
  matKhau: z.string().min(6, 'Mật khẩu phải có ít nhất 6 ký tự'),
});

type LoginForm = z.infer<typeof loginSchema>;

export default function LoginPage() {
  const [isLoading, setIsLoading] = useState(false);
  const [isForgotPassLoading, setIsForgotPassLoading] = useState(false);
  const [error, setError] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [forgotPassEmail, setForgotPassEmail] = useState('');
  const [isForgotPassOpen, setIsForgotPassOpen] = useState(false);
  const router = useRouter();

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<LoginForm>({
    resolver: zodResolver(loginSchema),
  });

  useEffect(() => {
    const query = new URLSearchParams(window.location.search);
    if (query.get('error')) {
      setError('Email hoặc mật khẩu không đúng');
    }
  }, []);

  const onSubmit = async (data: LoginForm) => {
    setIsLoading(true);
    setError('');

    try {
      const result = await signIn('credentials', {
        email: data.email,
        matKhau: data.matKhau,
        redirect: false,
        callbackUrl: '/dashboard',
      });

      if (!(result?.ok && !result.error)) {
        setError('Email hoặc mật khẩu không đúng');
      } else {
        router.push(result.url || '/dashboard');
      }
    } catch {
      setError('Đã xảy ra lỗi, vui lòng thử lại');
    } finally {
      setIsLoading(false);
    }
  };

  const handleForgotPassSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!forgotPassEmail) {
      toast.error('Vui lòng nhập email');
      return;
    }

    setIsForgotPassLoading(true);
    try {
      const response = await fetch('/api/auth/forgot-password', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email: forgotPassEmail }),
      });

      const data = await response.json();
      if (data.success) {
        toast.success('Mật khẩu mới đã được gửi vào email của bạn');
        setIsForgotPassOpen(false);
        setForgotPassEmail('');
      } else {
        toast.error(data.message || 'Đã có lỗi xảy ra');
      }
    } catch {
      toast.error('Đã có lỗi xảy ra, vui lòng thử lại sau');
    } finally {
      setIsForgotPassLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-[#f8fafc] dark:bg-slate-950 px-4 py-12">
      <div className="absolute inset-0 z-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-[10%] -left-[10%] w-[40%] h-[40%] rounded-full bg-blue-500/5 blur-[120px]" />
        <div className="absolute -bottom-[10%] -right-[10%] w-[40%] h-[40%] rounded-full bg-indigo-500/5 blur-[120px]" />
      </div>

      <div className="w-full max-w-[450px] z-10">
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-slate-900 dark:text-white tracking-tight">Chào mừng bạn đến với EasyHouse!</h1>
        </div>

        <Card className="border-none shadow-2xl shadow-slate-200/60 dark:shadow-none dark:bg-slate-900/50 dark:backdrop-blur-xl overflow-hidden">
          <div className="h-1.5 w-full bg-gradient-to-r from-blue-600 to-indigo-600" />
          <CardHeader className="space-y-3 p-8 pb-2 text-center">
            <div className="space-y-1">
              <CardTitle className="text-2xl font-bold text-slate-900 dark:text-white">
                Đăng Nhập
              </CardTitle>
              <CardDescription className="text-base font-medium text-slate-500 dark:text-slate-400">
                Đăng nhập vào EasyHouse
              </CardDescription>
            </div>
          </CardHeader>
          <CardContent className="p-8 pt-4">
            <form onSubmit={handleSubmit(onSubmit)} className="space-y-5">
              {error && (
                <Alert variant="destructive" className="bg-red-50 dark:bg-red-900/20 border-red-200 dark:border-red-800">
                  <AlertDescription className="text-red-800 dark:text-red-400 font-medium">{error}</AlertDescription>
                </Alert>
              )}

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

              <div className="space-y-2">
                <div className="flex items-center justify-between ml-1">
                  <Label htmlFor="matKhau" className="text-sm font-semibold text-slate-700 dark:text-slate-300">Mật khẩu</Label>
                  
                  <Dialog open={isForgotPassOpen} onOpenChange={setIsForgotPassOpen}>
                    <DialogTrigger asChild>
                      <button type="button" className="text-xs font-medium text-blue-600 hover:text-blue-500 transition-colors">
                        Quên mật khẩu?
                      </button>
                    </DialogTrigger>
                    <DialogContent className="sm:max-w-[425px]">
                      <DialogHeader>
                        <DialogTitle>Quên mật khẩu</DialogTitle>
                        <DialogDescription>
                          Nhập email của bạn để nhận mật khẩu mới.
                        </DialogDescription>
                      </DialogHeader>
                      <form onSubmit={handleForgotPassSubmit} className="space-y-4 py-4">
                        <div className="space-y-2">
                          <Label htmlFor="forgot-email">Email tài khoản</Label>
                          <Input
                            id="forgot-email"
                            type="email"
                            placeholder="your-email@example.com"
                            value={forgotPassEmail}
                            onChange={(e) => setForgotPassEmail(e.target.value)}
                            required
                          />
                        </div>
                        <DialogFooter>
                          <Button type="submit" disabled={isForgotPassLoading} className="w-full">
                            {isForgotPassLoading ? (
                              <>
                                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                                Đang xử lý...
                              </>
                            ) : (
                              'Gửi mật khẩu mới'
                            )}
                          </Button>
                        </DialogFooter>
                      </form>
                    </DialogContent>
                  </Dialog>
                </div>
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

              <div className="pt-2">
                <Button
                  type="submit"
                  className="w-full h-12 text-base font-bold bg-blue-600 hover:bg-blue-700 shadow-lg shadow-blue-500/25 transition-all active:scale-[0.98]"
                  disabled={isLoading}
                >
                  {isLoading ? (
                    <>
                      <Loader2 className="mr-2 h-5 w-5 animate-spin" />
                      Đang đăng nhập...
                    </>
                  ) : (
                    'Đăng nhập ngay'
                  )}
                </Button>
              </div>
            </form>

            <div className="relative my-8">
              <div className="absolute inset-0 flex items-center">
                <span className="w-full border-t border-slate-200 dark:border-slate-800"></span>
              </div>
              <div className="relative flex justify-center text-xs uppercase">
                <span className="bg-white dark:bg-[#0f172a] px-4 text-slate-500 dark:text-slate-400 font-medium">Hoặc</span>
              </div>
            </div>

            <div className="text-center">
              <p className="text-sm text-slate-600 dark:text-slate-400">
                Bạn mới sử dụng hệ thống?{' '}
                <Link href="/dang-ky" className="font-bold text-blue-600 hover:text-blue-500 transition-colors">
                  Đăng ký tài khoản
                </Link>
              </p>
            </div>
          </CardContent>
        </Card>

        <p className="mt-8 text-center text-xs text-slate-400">
          &copy; 2026 EasyHouse. All rights reserved.
        </p>
      </div>
    </div>
  );
}
