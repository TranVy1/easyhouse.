'use client';

import { useState, useEffect, useCallback } from 'react';
import Image from 'next/image';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { User, Phone, Mail, Camera, Save, Lock, ShieldCheck } from 'lucide-react';
import { useSession } from 'next-auth/react';
import { toast } from 'sonner';
import { useTenantDashboard } from '../context';

export default function TenantProfilePage() {
  const session = useSession()?.data;
  const accessToken = session?.accessToken;
  const { refreshData } = useTenantDashboard();
  
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [file, setFile] = useState<File | null>(null);
  
  const [formData, setFormData] = useState({
    name: '',
    phone: '',
    email: '',
    avatar: ''
  });
  const [changingPassword, setChangingPassword] = useState(false);
  const [passwordData, setPasswordData] = useState({
    oldPassword: '',
    newPassword: '',
    confirmPassword: ''
  });

  const fetchProfile = useCallback(async () => {
    try {
      setLoading(true);
      const res = await fetch('/api/user/profile', {
        headers: {
          'Authorization': `Bearer ${accessToken}`
        }
      });
      const data = await res.json();
      if (data.success && data.data) {
        setFormData({
          name: data.data.name || '',
          phone: data.data.phone || '',
          email: data.data.email || '',
          avatar: data.data.avatar || ''
        });
      } else {
        toast.error('Không thể tải thông tin cá nhân');
      }
    } catch (error) {
      console.error('Lỗi khi tải hồ sơ:', error);
      toast.error('Có lỗi xảy ra');
    } finally {
      setLoading(false);
    }
  }, [accessToken]);

  useEffect(() => {
    if (accessToken) {
      void fetchProfile();
    }
  }, [accessToken, fetchProfile]);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files.length > 0) {
      const selectedFile = e.target.files[0];
      if (selectedFile.size > 2 * 1024 * 1024) {
        toast.error('Kích thước ảnh tối đa là 2MB');
        return;
      }
      setFile(selectedFile);
      
      // Preview
      const reader = new FileReader();
      reader.onload = (e) => {
        setFormData({...formData, avatar: e.target?.result as string});
      };
      reader.readAsDataURL(selectedFile);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!session?.accessToken) return;

    try {
      setSaving(true);
      let avatarUrl = formData.avatar;

      // 1. Upload ảnh nếu có thay đổi
      if (file) {
        const fileData = new FormData();
        fileData.append('file', file);
        
        const uploadRes = await fetch('/api/upload', {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${session.accessToken}`
          },
          body: fileData
        });
        
        const uploadData = await uploadRes.json();
        if (uploadData.success) {
          avatarUrl = uploadData.data.secure_url || uploadData.data.url;
        } else {
          toast.error('Lỗi tải ảnh lên');
          setSaving(false);
          return;
        }
      }

      // 2. Gửi thông tin cập nhật
      const payload = {
        name: formData.name,
        phone: formData.phone,
        avatar: avatarUrl
      };

      const res = await fetch('/api/user/profile', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${session.accessToken}`
        },
        body: JSON.stringify(payload)
      });

      const result = await res.json();
      if (result.success) {
        toast.success('Cập nhật hồ sơ thành công');
        setFile(null);
        refreshData(); // Cập nhật lại UI header
      } else {
        throw new Error(result.error || 'Lỗi cập nhật hồ sơ');
      }
    } catch (error: unknown) {
      console.error('Lỗi cập nhật:', error);
      toast.error(error instanceof Error ? error.message : 'Có lỗi xảy ra');
    } finally {
      setSaving(false);
    }
  };

  const handleChangePassword = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!session?.accessToken) return;
    if (passwordData.newPassword !== passwordData.confirmPassword) {
      toast.error('Mật khẩu xác nhận không khớp');
      return;
    }

    try {
      setChangingPassword(true);
      const res = await fetch('/api/user/change-password', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${session.accessToken}`
        },
        body: JSON.stringify({
          oldPassword: passwordData.oldPassword,
          newPassword: passwordData.newPassword
        })
      });
      const result = await res.json();
      if (!result.success) {
        throw new Error(result.message || result.error || 'Đổi mật khẩu thất bại');
      }
      toast.success('Đổi mật khẩu thành công');
      setPasswordData({ oldPassword: '', newPassword: '', confirmPassword: '' });
    } catch (error: unknown) {
      toast.error(error instanceof Error ? error.message : 'Đổi mật khẩu thất bại');
    } finally {
      setChangingPassword(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  return (
    <div className="p-4 md:p-8 max-w-4xl mx-auto space-y-6 pb-24 md:pb-8">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">Hồ Sơ Cá Nhân</h1>
        <p className="text-muted-foreground mt-1">Quản lý thông tin tài khoản của bạn</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card className="md:col-span-2">
          <CardHeader>
            <CardTitle>Thông tin liên hệ</CardTitle>
            <CardDescription>Cập nhật thông tin để quản lý nhà có thể liên lạc khi cần thiết.</CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit} className="space-y-6">
              <div className="flex flex-col sm:flex-row items-center gap-6 pb-6 border-b">
                <div className="relative group">
                  <div className="relative h-24 w-24 rounded-full overflow-hidden border-4 border-white shadow-md bg-gray-100 flex items-center justify-center">
                    {formData.avatar ? (
                      <Image
                        src={formData.avatar} 
                        alt="Avatar" 
                        fill
                        sizes="96px"
                        className="object-cover"
                      />
                    ) : (
                      <User className="h-10 w-10 text-gray-400" />
                    )}
                  </div>
                  <label htmlFor="avatar-upload" className="absolute bottom-0 right-0 bg-blue-600 p-1.5 rounded-full text-white cursor-pointer hover:bg-blue-700 shadow-sm transition-colors">
                    <Camera className="h-4 w-4" />
                  </label>
                  <input 
                    id="avatar-upload" 
                    type="file" 
                    accept="image/*" 
                    className="hidden" 
                    onChange={handleFileChange} 
                  />
                </div>
                <div>
                  <h3 className="font-semibold text-lg">{formData.name || 'Người dùng'}</h3>
                  <p className="text-sm text-gray-500">Khách thuê</p>
                </div>
              </div>

              <div className="space-y-4 pt-2">
                <div className="grid gap-2">
                  <Label htmlFor="name">Họ và tên</Label>
                  <div className="relative">
                    <User className="absolute left-3 top-3 h-4 w-4 text-gray-400" />
                    <Input 
                      id="name" 
                      placeholder="Nguyễn Văn A" 
                      className="pl-9"
                      value={formData.name}
                      onChange={(e) => setFormData({...formData, name: e.target.value})}
                      required
                    />
                  </div>
                </div>

                <div className="grid gap-2">
                  <Label htmlFor="phone">Số điện thoại</Label>
                  <div className="relative">
                    <Phone className="absolute left-3 top-3 h-4 w-4 text-gray-400" />
                    <Input 
                      id="phone" 
                      placeholder="0912345678" 
                      className="pl-9"
                      value={formData.phone}
                      onChange={(e) => setFormData({...formData, phone: e.target.value})}
                      required
                    />
                  </div>
                </div>

                <div className="grid gap-2">
                  <Label htmlFor="email">Email đăng nhập (Không thể thay đổi)</Label>
                  <div className="relative">
                    <Mail className="absolute left-3 top-3 h-4 w-4 text-gray-400" />
                    <Input 
                      id="email" 
                      type="email" 
                      className="pl-9 bg-gray-50"
                      value={formData.email}
                      disabled
                    />
                  </div>
                </div>
              </div>

              <Button type="submit" disabled={saving} className="w-full sm:w-auto mt-4">
                {saving ? 'Đang lưu...' : 'Lưu thay đổi'}
                {!saving && <Save className="ml-2 h-4 w-4" />}
              </Button>
            </form>
          </CardContent>
        </Card>

        <div className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="text-lg flex items-center gap-2">
                <Lock className="h-5 w-5" />
                Mật khẩu
              </CardTitle>
            </CardHeader>
            <CardContent>
              <form onSubmit={handleChangePassword} className="space-y-3">
                <div className="grid gap-2">
                  <Label htmlFor="oldPassword">Mật khẩu hiện tại</Label>
                  <Input
                    id="oldPassword"
                    type="password"
                    value={passwordData.oldPassword}
                    onChange={(e) => setPasswordData({ ...passwordData, oldPassword: e.target.value })}
                    required
                  />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="newPassword">Mật khẩu mới</Label>
                  <Input
                    id="newPassword"
                    type="password"
                    minLength={8}
                    value={passwordData.newPassword}
                    onChange={(e) => setPasswordData({ ...passwordData, newPassword: e.target.value })}
                    required
                  />
                </div>
                <div className="grid gap-2">
                  <Label htmlFor="confirmPassword">Nhập lại mật khẩu mới</Label>
                  <Input
                    id="confirmPassword"
                    type="password"
                    minLength={8}
                    value={passwordData.confirmPassword}
                    onChange={(e) => setPasswordData({ ...passwordData, confirmPassword: e.target.value })}
                    required
                  />
                </div>
                <Button type="submit" variant="outline" disabled={changingPassword} className="w-full">
                  {changingPassword ? 'Đang đổi mật khẩu...' : 'Đổi mật khẩu'}
                </Button>
              </form>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="text-lg flex items-center gap-2">
                <ShieldCheck className="h-5 w-5" />
                Dữ liệu cá nhân
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-sm text-gray-600 leading-relaxed">
                Các thông tin nhạy cảm khác như Căn cước công dân (CCCD), Số thẻ ngân hàng được lưu trữ bảo mật và chỉ cung cấp thông qua chủ nhà/quản lý để đảm bảo an toàn.
              </p>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
