'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useSession, signOut } from 'next-auth/react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Lock, ShieldCheck, Loader2 } from 'lucide-react';
import { toast } from 'sonner';
import { SessionProvider } from 'next-auth/react';

function DoiMatKhauContent() {
  const router = useRouter();
  const { data: session, update } = useSession();
  const [formData, setFormData] = useState({
    matKhauCu: '123456',
    matKhauMoi: '',
    xacNhanMatKhau: '',
  });
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (formData.matKhauMoi.length < 6) {
      toast.error('Mật khẩu mới phải có ít nhất 6 ký tự');
      return;
    }

    if (formData.matKhauMoi !== formData.xacNhanMatKhau) {
      toast.error('Mật khẩu xác nhận không khớp');
      return;
    }

    setIsLoading(true);

    try {
      const response = await fetch('/api/user/change-password', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${session?.accessToken}`,
        },
        body: JSON.stringify({
          oldPassword: formData.matKhauCu,
          newPassword: formData.matKhauMoi,
        }),
      });

      const result = await response.json();

      if (response.ok && result.success) {
        toast.success('Đổi mật khẩu thành công!');
        await update({ requirePasswordChange: false });
        router.push('/khach-thue/dashboard');
      } else {
        toast.error(result.message || 'Đổi mật khẩu thất bại');
      }
    } catch (error) {
      console.error('Error changing password:', error);
      toast.error('Có lỗi xảy ra, vui lòng thử lại sau');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100 p-4">
      <Card className="w-full max-w-md shadow-xl border-t-4 border-t-[#4FA7A0]">
        <CardHeader className="space-y-3 text-center">
          <div className="mx-auto w-16 h-16 bg-[#4FA7A0]/10 rounded-full flex items-center justify-center">
            <ShieldCheck className="h-8 w-8 text-[#4FA7A0]" />
          </div>
          <CardTitle className="text-2xl font-bold text-[#243B5A]">Bảo mật tài khoản</CardTitle>
          <CardDescription>
            Bạn đang đăng nhập bằng mật khẩu mặc định. Vui lòng đổi mật khẩu mới để bảo vệ tài khoản và hợp đồng của bạn.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="matKhauMoi">Mật khẩu mới</Label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                <Input
                  id="matKhauMoi"
                  type="password"
                  placeholder="Nhập mật khẩu mới (Tối thiểu 6 ký tự)"
                  value={formData.matKhauMoi}
                  onChange={(e) => setFormData(prev => ({ ...prev, matKhauMoi: e.target.value }))}
                  className="pl-10"
                  required
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="xacNhanMatKhau">Xác nhận mật khẩu mới</Label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                <Input
                  id="xacNhanMatKhau"
                  type="password"
                  placeholder="Nhập lại mật khẩu mới"
                  value={formData.xacNhanMatKhau}
                  onChange={(e) => setFormData(prev => ({ ...prev, xacNhanMatKhau: e.target.value }))}
                  className="pl-10"
                  required
                />
              </div>
            </div>

            <Button type="submit" className="w-full bg-[#4FA7A0] hover:bg-[#3D857F]" disabled={isLoading}>
              {isLoading ? (
                <>
                  <Loader2 className="animate-spin mr-2 h-4 w-4" />
                  Đang xử lý...
                </>
              ) : (
                'Cập nhật mật khẩu'
              )}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}

export default function DoiMatKhauLanDauPage() {
  return (
    <SessionProvider basePath="/api/auth-tenant">
      <DoiMatKhauContent />
    </SessionProvider>
  );
}
