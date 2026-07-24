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
        const response = await fetch('/api/auth/verify-email', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ token }),
        });
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
    <div className="relative min-h-screen overflow-hidden bg-[#F8F3EC]">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_20%_20%,rgba(79,167,160,0.22),transparent_45%),radial-gradient(circle_at_80%_15%,rgba(36,59,90,0.18),transparent_40%),radial-gradient(circle_at_60%_80%,rgba(242,164,91,0.18),transparent_38%)]" />

      <div className="relative z-10 flex min-h-screen items-center justify-center px-4 py-10">
        <Card className="w-full max-w-lg border-[#E8DED2] bg-[#FFFDF8]/95 shadow-2xl shadow-[#243B5A]/10 backdrop-blur-sm">
          <CardHeader className="space-y-2">
            <CardTitle className="text-2xl font-bold text-[#243B5A]">Xác thực email tài khoản</CardTitle>
            <CardDescription className="text-sm text-[#6B7A8C]">
              Hệ thống đang kiểm tra liên kết xác thực của bạn.
            </CardDescription>
          </CardHeader>

          <CardContent className="space-y-4">
            {state === 'loading' && (
              <div className="flex items-center gap-3 rounded-lg border border-[#243B5A]/20 bg-[#243B5A]/10 p-4 text-[#243B5A]">
                <Loader2 className="h-5 w-5 animate-spin" />
                <p className="text-sm font-medium">{message}</p>
              </div>
            )}

            {state === 'success' && (
              <Alert className="border-[#4FA7A0]/30 bg-[#4FA7A0]/10 text-[#267D76]">
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
              <Button variant="ghost" asChild className="px-0 text-[#6B7A8C] hover:text-[#243B5A]">
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
