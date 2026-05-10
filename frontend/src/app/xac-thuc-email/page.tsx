'use client';

import { Suspense, useEffect, useState } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import Link from 'next/link';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { CheckCircle2, Loader2, MailX, ArrowLeft } from 'lucide-react';

type VerifyState = 'loading' | 'success' | 'error';

export default function VerifyEmailPage() {
  return (
    <Suspense fallback={null}>
      <VerifyEmailContent />
    </Suspense>
  );
}

function VerifyEmailContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const token = searchParams.get('token');

  const [state, setState] = useState<VerifyState>('loading');
  const [message, setMessage] = useState('Đang xác thực email của bạn...');

  useEffect(() => {
    const verifyEmail = async () => {
      if (!token) {
        setState('error');
        setMessage('Liên kết xác thực không hợp lệ hoặc đã bị thiếu mã token.');
        return;
      }

      try {
        const response = await fetch(`/api/auth/verify-email?token=${encodeURIComponent(token)}`);
        const result = await response.json();

        if (result.success) {
          setState('success');
          setMessage(result.message || 'Xác thực email thành công. Bạn có thể đăng nhập ngay.');
          setTimeout(() => {
            router.push('/dang-nhap');
          }, 2500);
        } else {
          setState('error');
          setMessage(result.message || 'Xác thực email thất bại. Vui lòng thử lại.');
        }
      } catch {
        setState('error');
        setMessage('Có lỗi kết nối khi xác thực email. Vui lòng thử lại sau.');
      }
    };

    verifyEmail();
  }, [router, token]);

  return (
    <div className="relative min-h-screen overflow-hidden bg-slate-950">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_20%_20%,rgba(34,197,94,0.22),transparent_45%),radial-gradient(circle_at_80%_15%,rgba(59,130,246,0.22),transparent_40%),radial-gradient(circle_at_60%_80%,rgba(234,179,8,0.18),transparent_38%)]" />

      <div className="relative z-10 flex min-h-screen items-center justify-center px-4 py-10">
        <Card className="w-full max-w-lg border-white/20 bg-white/95 shadow-2xl backdrop-blur-sm">
          <CardHeader className="space-y-2">
            <CardTitle className="text-2xl font-bold text-slate-900">Xác thực email tài khoản</CardTitle>
            <CardDescription className="text-sm text-slate-600">
              Hệ thống đang kiểm tra liên kết xác thực của bạn.
            </CardDescription>
          </CardHeader>

          <CardContent className="space-y-4">
            {state === 'loading' && (
              <div className="flex items-center gap-3 rounded-lg border border-blue-200 bg-blue-50 p-4 text-blue-700">
                <Loader2 className="h-5 w-5 animate-spin" />
                <p className="text-sm font-medium">{message}</p>
              </div>
            )}

            {state === 'success' && (
              <Alert className="border-green-300 bg-green-50 text-green-700">
                <CheckCircle2 className="h-4 w-4" />
                <AlertDescription className="text-sm">{message}</AlertDescription>
              </Alert>
            )}

            {state === 'error' && (
              <Alert variant="destructive">
                <MailX className="h-4 w-4" />
                <AlertDescription className="text-sm">{message}</AlertDescription>
              </Alert>
            )}

            <div className="flex flex-col gap-2 pt-2 sm:flex-row">
              <Button asChild className="w-full sm:w-auto">
                <Link href="/dang-nhap">Đi đến đăng nhập</Link>
              </Button>
              <Button asChild variant="outline" className="w-full sm:w-auto">
                <Link href="/dang-ky">Đăng ký lại</Link>
              </Button>
            </div>

            <div className="pt-2">
              <Button variant="ghost" asChild className="px-0 text-slate-600 hover:text-slate-900">
                <Link href="/dang-nhap">
                  <ArrowLeft className="mr-2 h-4 w-4" />
                  Quay lại đăng nhập
                </Link>
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
