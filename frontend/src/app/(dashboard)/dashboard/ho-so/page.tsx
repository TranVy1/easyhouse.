'use client';

import { useState, useEffect, useCallback } from 'react';
import { useSession } from 'next-auth/react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Badge } from '@/components/ui/badge';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { 
  User, 
  Phone, 
  MapPin, 
  Calendar, 
  Edit3, 
  Save, 
  Camera,
  Key,
  Bell
} from 'lucide-react';
import { toast } from 'sonner';

interface UserProfile {
  _id: string;
  name: string;
  email: string;
  phone?: string;
  address?: string;
  avatar?: string;
  role: string;
  createdAt: string;
  lastLogin?: string;
}

interface Province {
  code: number;
  name: string;
}

interface District {
  code: number;
  name: string;
}

interface Ward {
  code: number;
  name: string;
}

export default function ProfilePage() {
  const { data: session, update } = useSession();
  const accessToken = session?.accessToken;
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [isEditing, setIsEditing] = useState(false);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [formData, setFormData] = useState({
    name: '',
    phone: '',
    address: '',
    avatar: ''
  });
  
  const [passwordData, setPasswordData] = useState({
    oldPassword: '',
    newPassword: '',
    confirmPassword: ''
  });
  const [changingPassword, setChangingPassword] = useState(false);

  // Address Selection State
  const [provinces, setProvinces] = useState<Province[]>([]);
  const [districts, setDistricts] = useState<District[]>([]);
  const [wards, setWards] = useState<Ward[]>([]);
  const [selectedProvince, setSelectedProvince] = useState<string>("");
  const [selectedDistrict, setSelectedDistrict] = useState<string>("");
  const [selectedWard, setSelectedWard] = useState<string>("");
  const [detailAddress, setDetailAddress] = useState<string>("");

  useEffect(() => {
    document.title = 'Hồ sơ cá nhân';
    fetchProvinces();
  }, []);

  // Fetch Provinces
  const fetchProvinces = async () => {
    try {
      const res = await fetch("https://provinces.open-api.vn/api/p/");
      const data = await res.json();
      setProvinces(data);
    } catch (err) {
      console.error("Error fetching provinces:", err);
    }
  };

  // Fetch Districts when province changes
  useEffect(() => {
    if (selectedProvince) {
      const province = provinces.find(p => p.name === selectedProvince);
      if (province) {
        fetch(`https://provinces.open-api.vn/api/p/${province.code}?depth=2`)
          .then(res => res.json())
          .then(data => {
            setDistricts(data.districts);
            setWards([]);
            setSelectedDistrict("");
            setSelectedWard("");
          });
      }
    }
  }, [selectedProvince, provinces]);

  // Fetch Wards when district changes
  useEffect(() => {
    if (selectedDistrict) {
      const district = districts.find(d => d.name === selectedDistrict);
      if (district) {
        fetch(`https://provinces.open-api.vn/api/d/${district.code}?depth=2`)
          .then(res => res.json())
          .then(data => {
            setWards(data.wards);
            setSelectedWard("");
          });
      }
    }
  }, [selectedDistrict, districts]);

  // Sync address selection to formData.address
  useEffect(() => {
    const parts = [detailAddress, selectedWard, selectedDistrict, selectedProvince].filter(Boolean);
    setFormData(prev => ({ ...prev, address: parts.join(", ") }));
  }, [selectedProvince, selectedDistrict, selectedWard, detailAddress]);

  const handlePasswordChange = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (passwordData.newPassword !== passwordData.confirmPassword) {
      toast.error('Mật khẩu mới và xác nhận mật khẩu không khớp');
      return;
    }

    setChangingPassword(true);
    try {
      const response = await fetch('/api/user/change-password', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${session?.accessToken}`
        },
        body: JSON.stringify({
          oldPassword: passwordData.oldPassword,
          newPassword: passwordData.newPassword
        }),
      });

      const result = await response.json();
      if (result.success) {
        toast.success('Đổi mật khẩu thành công');
        setPasswordData({ oldPassword: '', newPassword: '', confirmPassword: '' });
      } else {
        toast.error(result.message || 'Đổi mật khẩu thất bại');
      }
    } catch (error) {
      console.error('Error changing password:', error);
      toast.error('Có lỗi xảy ra khi đổi mật khẩu');
    } finally {
      setChangingPassword(false);
    }
  };

  const fetchProfile = useCallback(async () => {
    try {
      const response = await fetch('/api/user/profile', {
        headers: {
          'Authorization': `Bearer ${accessToken}`
        }
      });
      if (response.ok) {
        const result = await response.json();
        if (result.success && result.data) {
          setProfile(result.data);
          setFormData({
            name: result.data.name || '',
            phone: result.data.phone || '',
            address: result.data.address || '',
            avatar: result.data.avatar || ''
          });
        }
      }
    } catch (error) {
      console.error('Error fetching profile:', error);
      toast.error('Không thể tải thông tin hồ sơ');
    } finally {
      setLoading(false);
    }
  }, [accessToken]);

  useEffect(() => {
    if (session?.user) {
      void fetchProfile();
    }
  }, [session?.user, fetchProfile]);

  const handleSave = async () => {
    setSaving(true);
    try {
      const response = await fetch('/api/user/profile', {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${session?.accessToken}`
        },
        body: JSON.stringify(formData),
      });

      if (response.ok) {
        const result = await response.json();
        if (result.success && result.data) {
          setProfile(result.data);
          setIsEditing(false);
          toast.success('Cập nhật hồ sơ thành công');
          
          // Update session
          await update({
            ...session,
            user: {
              ...session?.user,
              name: result.data.name,
              avatar: result.data.avatar
            }
          });
        }
      } else {
        toast.error('Cập nhật hồ sơ thất bại');
      }
    } catch (error) {
      console.error('Error updating profile:', error);
      toast.error('Có lỗi xảy ra khi cập nhật hồ sơ');
    } finally {
      setSaving(false);
    }
  };

  const handleCancel = () => {
    setFormData({
      name: profile?.name || '',
      phone: profile?.phone || '',
      address: profile?.address || '',
      avatar: profile?.avatar || ''
    });
    setSelectedProvince("");
    setSelectedDistrict("");
    setSelectedWard("");
    setDetailAddress("");
    setIsEditing(false);
  };

  const getRoleBadge = (role: string) => {
    switch (role) {
      case 'admin':
        return <Badge variant="destructive">Quản trị viên</Badge>;
      case 'chuNha':
        return <Badge variant="default">Chủ nhà</Badge>;
      case 'nhanVien':
        return <Badge variant="secondary">Nhân viên</Badge>;
      default:
        return <Badge variant="outline">Người dùng</Badge>;
    }
  };

  const getInitials = (name: string) => {
    return name
      .split(' ')
      .map(n => n[0])
      .join('')
      .toUpperCase()
      .slice(0, 2);
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Đang tải thông tin...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-4xl mx-auto space-y-4 md:space-y-6 pb-10">
      <div className="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-3">
        <div>
          <h1 className="text-xl md:text-2xl lg:text-3xl font-bold text-gray-900">Hồ sơ cá nhân</h1>
          <p className="text-xs md:text-sm text-gray-600">Quản lý thông tin tài khoản của bạn</p>
        </div>
        {!isEditing && (
          <Button size="sm" onClick={() => setIsEditing(true)}>
            <Edit3 className="h-4 w-4 sm:mr-2" />
            <span className="hidden sm:inline">Chỉnh sửa</span>
          </Button>
        )}
      </div>

      <Tabs defaultValue="profile" className="space-y-4 md:space-y-6">
        <TabsList className="grid w-full grid-cols-3">
          <TabsTrigger value="profile" className="text-xs md:text-sm">
            <User className="h-3 w-3 md:h-4 md:w-4 mr-1 md:mr-2" />
            <span className="hidden sm:inline">Thông tin</span>
            <span className="sm:hidden">TT</span>
          </TabsTrigger>
          <TabsTrigger value="security" className="text-xs md:text-sm">
            <Key className="h-3 w-3 md:h-4 md:w-4 mr-1 md:mr-2" />
            <span className="hidden sm:inline">Bảo mật</span>
            <span className="sm:hidden">BM</span>
          </TabsTrigger>
          <TabsTrigger value="notifications" className="text-xs md:text-sm">
            <Bell className="h-3 w-3 md:h-4 md:w-4 mr-1 md:mr-2" />
            <span className="hidden sm:inline">Thông báo</span>
            <span className="sm:hidden">TB</span>
          </TabsTrigger>
        </TabsList>

        <TabsContent value="profile" className="space-y-4 md:space-y-6">
          <Card>
            <CardHeader className="p-4 md:p-6">
              <CardTitle className="flex items-center gap-2 text-base md:text-lg">
                <User className="h-4 w-4 md:h-5 md:w-5" />
                Thông tin cơ bản
              </CardTitle>
              <CardDescription className="text-xs md:text-sm">
                Cập nhật thông tin cá nhân và ảnh đại diện
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6 p-4 md:p-8">
              {/* Avatar Section */}
              <div className="flex flex-col sm:flex-row items-center gap-6 p-4 bg-slate-50/50 rounded-2xl border border-dashed border-slate-200">
                <div className="relative group">
                  <Avatar className="h-24 w-24 ring-4 ring-white shadow-xl transition-transform duration-300 group-hover:scale-105">
                    <AvatarImage src={formData.avatar} alt={formData.name} />
                    <AvatarFallback className="text-2xl bg-blue-600 text-white font-bold">
                      {getInitials(formData.name)}
                    </AvatarFallback>
                  </Avatar>
                  {isEditing && (
                    <Button variant="outline" size="icon" className="absolute -bottom-1 -right-1 h-8 w-8 rounded-full bg-white shadow-md hover:bg-gray-50">
                      <Camera className="h-4 w-4" />
                    </Button>
                  )}
                </div>
                <div className="flex-1 text-center sm:text-left space-y-1">
                  <h3 className="text-xl font-bold text-slate-800">{formData.name}</h3>
                  <div className="flex flex-wrap justify-center sm:justify-start gap-2">
                    {profile?.role && getRoleBadge(profile.role)}
                    <Badge variant="outline" className="bg-white/50">{profile?.email}</Badge>
                  </div>
                </div>
              </div>

              {/* Form Fields */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6">
                <div className="space-y-2.5">
                  <Label htmlFor="name" className="text-sm font-semibold text-slate-700">Họ và tên</Label>
                  {isEditing ? (
                    <Input
                      id="name"
                      value={formData.name}
                      onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                      placeholder="Nhập họ và tên"
                      className="h-11 transition-all focus:ring-2 focus:ring-blue-500/20"
                    />
                  ) : (
                    <div className="flex items-center gap-3 px-4 h-11 border rounded-lg bg-slate-50/30 text-slate-600">
                      <User className="h-4 w-4 opacity-70" />
                      <span className="text-sm font-medium">{formData.name}</span>
                    </div>
                  )}
                </div>

                <div className="space-y-2.5">
                  <Label htmlFor="phone" className="text-sm font-semibold text-slate-700">Số điện thoại</Label>
                  {isEditing ? (
                    <Input
                      id="phone"
                      value={formData.phone}
                      onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                      placeholder="Nhập số điện thoại"
                      className="h-11 transition-all focus:ring-2 focus:ring-blue-500/20"
                    />
                  ) : (
                    <div className="flex items-center gap-3 px-4 h-11 border rounded-lg bg-slate-50/30 text-slate-600">
                      <Phone className="h-4 w-4 opacity-70" />
                      <span className="text-sm font-medium">{formData.phone || 'Chưa cập nhật'}</span>
                    </div>
                  )}
                </div>

                <div className="space-y-2.5 md:col-span-2">
                  <Label htmlFor="address" className="text-sm font-semibold text-slate-700">Địa chỉ</Label>
                  {isEditing ? (
                    <div className="space-y-4">
                      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                        <div className="space-y-1.5">
                          <p className="text-[10px] font-bold uppercase text-slate-400 ml-1">Tỉnh / Thành phố</p>
                          <Select value={selectedProvince} onValueChange={setSelectedProvince}>
                            <SelectTrigger className="h-10">
                              <SelectValue placeholder="Chọn Tỉnh/TP" />
                            </SelectTrigger>
                            <SelectContent>
                              {provinces.map(p => (
                                <SelectItem key={p.code} value={p.name}>{p.name}</SelectItem>
                              ))}
                            </SelectContent>
                          </Select>
                        </div>
                        <div className="space-y-1.5">
                          <p className="text-[10px] font-bold uppercase text-slate-400 ml-1">Quận / Huyện</p>
                          <Select value={selectedDistrict} onValueChange={setSelectedDistrict} disabled={!selectedProvince}>
                            <SelectTrigger className="h-10">
                              <SelectValue placeholder="Chọn Quận/Huyện" />
                            </SelectTrigger>
                            <SelectContent>
                              {districts.map(d => (
                                <SelectItem key={d.code} value={d.name}>{d.name}</SelectItem>
                              ))}
                            </SelectContent>
                          </Select>
                        </div>
                        <div className="space-y-1.5">
                          <p className="text-[10px] font-bold uppercase text-slate-400 ml-1">Phường / Xã</p>
                          <Select value={selectedWard} onValueChange={setSelectedWard} disabled={!selectedDistrict}>
                            <SelectTrigger className="h-10">
                              <SelectValue placeholder="Chọn Phường/Xã" />
                            </SelectTrigger>
                            <SelectContent>
                              {wards.map(w => (
                                <SelectItem key={w.code} value={w.name}>{w.name}</SelectItem>
                              ))}
                            </SelectContent>
                          </Select>
                        </div>
                      </div>
                      <div className="space-y-1.5">
                        <p className="text-[10px] font-bold uppercase text-slate-400 ml-1">Số nhà, tên đường</p>
                        <Input 
                          value={detailAddress}
                          onChange={(e) => setDetailAddress(e.target.value)}
                          placeholder="Số nhà, tên đường..."
                          className="h-11"
                        />
                      </div>
                    </div>
                  ) : (
                    <div className="flex items-start gap-3 p-4 border rounded-lg bg-slate-50/30 text-slate-600">
                      <MapPin className="h-4 w-4 opacity-70 mt-0.5" />
                      <span className="text-sm font-medium leading-relaxed">{formData.address || 'Chưa cập nhật'}</span>
                    </div>
                  )}
                </div>
              </div>

              {/* Action Buttons */}
              {isEditing && (
                <div className="flex flex-col sm:flex-row justify-end gap-3 pt-6 border-t">
                  <Button variant="outline" size="lg" onClick={handleCancel} className="h-11 px-8">
                    Hủy
                  </Button>
                  <Button size="lg" onClick={handleSave} disabled={saving} className="h-11 px-8 min-w-[140px] shadow-lg shadow-blue-500/20">
                    {saving ? (
                      <div className="flex items-center gap-2">
                        <div className="animate-spin rounded-full h-4 w-4 border-2 border-white/30 border-t-white"></div>
                        Đang lưu...
                      </div>
                    ) : (
                      <div className="flex items-center gap-2">
                        <Save className="h-4 w-4" />
                        Lưu thay đổi
                      </div>
                    )}
                  </Button>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Account Information */}
          <Card className="border-none shadow-md bg-slate-50/50">
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-bold uppercase tracking-wider text-slate-500">Thông tin hệ thống</CardTitle>
            </CardHeader>
            <CardContent className="grid grid-cols-1 sm:grid-cols-2 gap-6 p-6">
              <div className="flex items-center gap-4 p-4 bg-white rounded-xl border border-slate-100 shadow-sm">
                <div className="p-2 bg-blue-50 rounded-lg text-blue-600">
                  <Calendar className="h-5 w-5" />
                </div>
                <div>
                  <p className="text-xs font-medium text-slate-500">Ngày tham gia</p>
                  <p className="text-sm font-bold text-slate-700">
                    {profile?.createdAt ? new Date(profile.createdAt).toLocaleDateString('vi-VN', { day: '2-digit', month: 'long', year: 'numeric' }) : 'N/A'}
                  </p>
                </div>
              </div>
              <div className="flex items-center gap-4 p-4 bg-white rounded-xl border border-slate-100 shadow-sm">
                <div className="p-2 bg-purple-50 rounded-lg text-purple-600">
                  <Calendar className="h-5 w-5" />
                </div>
                <div>
                  <p className="text-xs font-medium text-slate-500">Hoạt động cuối</p>
                  <p className="text-sm font-bold text-slate-700">
                    {profile?.lastLogin ? new Date(profile.lastLogin).toLocaleDateString('vi-VN', { day: '2-digit', month: 'long', year: 'numeric' }) : 'Vừa xong'}
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="security" className="space-y-4 md:space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">Đổi mật khẩu</CardTitle>
              <CardDescription>Đảm bảo mật khẩu của bạn có ít nhất 8 ký tự</CardDescription>
            </CardHeader>
            <CardContent className="p-4 md:p-6">
              <div className="max-w-md mx-auto">
                <form onSubmit={handlePasswordChange} className="space-y-4">
                  <div className="space-y-2">
                    <Label htmlFor="old-password">Mật khẩu hiện tại</Label>
                    <Input 
                      id="old-password" 
                      type="password" 
                      value={passwordData.oldPassword}
                      onChange={(e) => setPasswordData({...passwordData, oldPassword: e.target.value})}
                      placeholder="••••••••" 
                      required
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="new-password">Mật khẩu mới</Label>
                    <Input 
                      id="new-password" 
                      type="password" 
                      value={passwordData.newPassword}
                      onChange={(e) => setPasswordData({...passwordData, newPassword: e.target.value})}
                      placeholder="••••••••" 
                      required
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="confirm-password">Xác nhận mật khẩu mới</Label>
                    <Input 
                      id="confirm-password" 
                      type="password" 
                      value={passwordData.confirmPassword}
                      onChange={(e) => setPasswordData({...passwordData, confirmPassword: e.target.value})}
                      placeholder="••••••••" 
                      required
                    />
                  </div>
                  <Button type="submit" disabled={changingPassword} className="w-full">
                    {changingPassword ? 'Đang cập nhật...' : 'Đổi mật khẩu'}
                  </Button>
                </form>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="notifications" className="space-y-4 md:space-y-6">
          <Card>
            <CardHeader className="p-4 md:p-6">
              <CardTitle className="flex items-center gap-2 text-base md:text-lg">
                <Bell className="h-4 w-4 md:h-5 md:w-5" />
                Cài đặt thông báo
              </CardTitle>
              <CardDescription className="text-xs md:text-sm">
                Quản lý các thông báo và email
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-3 md:space-y-4 p-4 md:p-6">
              <div className="p-3 md:p-4 border rounded-lg bg-blue-50 border-blue-200">
                <p className="text-xs md:text-sm text-blue-800">
                  Tính năng cài đặt thông báo sẽ được cập nhật trong phiên bản tiếp theo.
                </p>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
