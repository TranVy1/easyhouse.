'use client';

import { useState, useEffect, useCallback } from 'react';
import { signOut, useSession } from 'next-auth/react';
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
import { useRouter } from 'next/navigation';
import {
  AlertTriangle,
  ArrowLeft,
  Bell,
  Calendar,
  ChevronRight,
  Edit3,
  FileText,
  Home,
  Key,
  Lock,
  LogOut,
  Mail,
  MapPin,
  Phone,
  Receipt,
  Save,
  ShieldCheck,
  User,
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
  isActive?: boolean;
  trangThai?: string;
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

const EMPTY_VALUE = 'Chưa cập nhật';

const roleLabels: Record<string, string> = {
  admin: 'Quản trị viên',
  ADMIN: 'Quản trị viên',
  chuNha: 'Chủ nhà',
  LANDLORD: 'Chủ nhà',
  nhanVien: 'Nhân viên',
  STAFF: 'Nhân viên',
  khachThue: 'Khách thuê',
  TENANT: 'Khách thuê',
};

const statusLabels: Record<string, string> = {
  hoatDong: 'Hoạt động',
  ACTIVE: 'Hoạt động',
  INACTIVE: 'Chưa kích hoạt',
  chuaKichHoat: 'Chưa kích hoạt',
  tamKhoa: 'Tạm khóa',
  khoa: 'Tạm khóa',
  BANNED: 'Tạm khóa',
};

export default function ProfilePage() {
  const router = useRouter();
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
    const fetchProvinces = async () => {
      try {
        const res = await fetch("https://provinces.open-api.vn/api/v1/p/");
        const data = await res.json();
        setProvinces(data);
      } catch (err) {
        console.error("Error fetching provinces:", err);
      }
    };
    fetchProvinces();
  }, []);

  // Fetch Districts when province changes
  useEffect(() => {
    if (selectedProvince) {
      const province = provinces.find(p => p.name === selectedProvince);
      if (province) {
        fetch(`https://provinces.open-api.vn/api/v1/p/${province.code}?depth=2`)
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
        fetch(`https://provinces.open-api.vn/api/v1/d/${district.code}?depth=2`)
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

  const getRoleLabel = (role?: string) => {
    if (!role) return undefined;
    return roleLabels[role] || role;
  };

  const getStatusLabel = (trangThai?: string, isActive?: boolean) => {
    if (trangThai) return statusLabels[trangThai] || trangThai;
    if (typeof isActive === 'boolean') return isActive ? 'Hoạt động' : 'Chưa kích hoạt';
    return undefined;
  };

  const getInitials = (name: string) => {
    return name
      .split(' ')
      .filter(Boolean)
      .map(n => n[0])
      .join('')
      .toUpperCase()
      .slice(0, 2);
  };

  const formatDate = (date?: string) => {
    if (!date) return EMPTY_VALUE;
    return new Date(date).toLocaleDateString('vi-VN', {
      day: '2-digit',
      month: 'long',
      year: 'numeric',
    });
  };

  const displayName = profile?.name || session?.user?.name || EMPTY_VALUE;
  const displayEmail = profile?.email || session?.user?.email || EMPTY_VALUE;
  const displayPhone = formData.phone || session?.user?.phone || EMPTY_VALUE;
  const displayAddress = formData.address || EMPTY_VALUE;
  const displayAvatar = formData.avatar || session?.user?.avatar || '';
  const roleLabel = getRoleLabel(profile?.role || session?.user?.role);
  const statusLabel = getStatusLabel(profile?.trangThai, profile?.isActive);
  const hasRealName = Boolean(profile?.name || session?.user?.name);

  const navLinkItems = [
    { icon: FileText, label: 'Hợp đồng thuê nhà', href: '/dashboard/hop-dong' },
    { icon: Receipt, label: 'Hóa đơn phòng', href: '/dashboard/hoa-don' },
    { icon: AlertTriangle, label: 'Báo cáo sự cố', href: '/dashboard/su-co' },
  ];

  if (loading) {
    return (
      <div className="min-h-[520px] rounded-[2rem] bg-[#F8F3EC] flex items-center justify-center">
        <div className="text-center">
          <div className="mx-auto mb-4 h-10 w-10 animate-spin rounded-full border-2 border-[#4FA7A0]/25 border-t-[#243B5A]" />
          <p className="text-sm font-medium text-[#243B5A]/70">Đang tải thông tin...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="-m-4 min-h-[calc(100vh-3.5rem)] bg-[#F8F3EC] py-5 pl-14 pr-4 text-[#243B5A] sm:px-4 md:-m-6 md:px-6 md:py-7 lg:-m-8 lg:px-8 lg:py-9">
      <div className="mx-auto w-full max-w-[1240px] space-y-6">
        <section className="relative overflow-hidden rounded-[2rem] bg-[radial-gradient(circle_at_80%_20%,rgba(79,167,160,0.42),transparent_28%),linear-gradient(135deg,#0F1F3D_0%,#243B5A_38%,#3741B6_72%,#1A73E8_100%)] px-5 py-6 text-white shadow-[0_22px_70px_rgba(36,59,90,0.28)] md:px-8 md:py-8 lg:min-h-[260px]">
          <div className="pointer-events-none absolute inset-0 opacity-[0.13] [background-image:linear-gradient(rgba(255,255,255,.7)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,.7)_1px,transparent_1px)] [background-size:36px_36px]" />
          <div className="pointer-events-none absolute -right-8 bottom-0 hidden h-44 w-[360px] opacity-25 lg:block">
            <div className="absolute bottom-0 left-4 h-28 w-24 rounded-t-[1.8rem] border border-white/45" />
            <div className="absolute bottom-0 left-28 h-40 w-28 rounded-t-[2rem] border border-white/45" />
            <div className="absolute bottom-0 left-64 h-32 w-24 rounded-t-[1.8rem] border border-white/45" />
            <div className="absolute bottom-20 left-44 h-px w-10 bg-white/45" />
            <div className="absolute bottom-28 left-44 h-px w-10 bg-white/45" />
            <div className="absolute bottom-16 left-76 h-px w-10 bg-white/45" />
          </div>

          <div className="relative z-10 flex flex-col gap-7 lg:flex-row lg:items-center lg:justify-between">
            <div className="flex flex-col gap-5 sm:flex-row sm:items-center">
              <Button
                variant="ghost"
                size="icon"
                onClick={() => router.push('/dashboard')}
                className="absolute right-0 top-0 h-10 w-10 rounded-full border border-white/20 bg-white/10 text-white shadow-sm backdrop-blur hover:bg-white/20 sm:static"
                title="Quay lại"
              >
                <ArrowLeft className="h-5 w-5" />
              </Button>
              <Avatar className="h-24 w-24 rounded-[1.6rem] border-4 border-white/55 bg-white/10 shadow-2xl md:h-28 md:w-28">
                <AvatarImage src={displayAvatar} alt={displayName} />
                <AvatarFallback className="rounded-[1.35rem] bg-white/12 text-3xl font-bold text-white backdrop-blur">
                  {hasRealName ? getInitials(displayName) : <User className="h-9 w-9" />}
                </AvatarFallback>
              </Avatar>

              <div className="min-w-0 pr-12 sm:pr-0">
                <p className="mb-2 text-xs font-bold uppercase tracking-[0.22em] text-white/70">
                  {roleLabel ? `Tài khoản ${roleLabel}` : 'Tài khoản EasyHouse'}
                </p>
                <h1 className="truncate text-3xl font-extrabold tracking-tight text-white md:text-4xl">
                  {displayName}
                </h1>
                <div className="mt-2 flex min-w-0 items-center gap-2 text-sm text-white/80">
                  <Mail className="h-4 w-4 shrink-0" />
                  <span className="truncate">{displayEmail}</span>
                </div>
                <div className="mt-4 flex flex-wrap gap-2">
                  {roleLabel && (
                    <Badge className="rounded-full border-white/40 bg-white px-4 py-1.5 text-xs font-bold uppercase tracking-wide text-[#243B5A]">
                      {roleLabel}
                    </Badge>
                  )}
                  {statusLabel && (
                    <Badge className="rounded-full border-[#4FA7A0]/30/70 bg-[#4FA7A0]/10 px-4 py-1.5 text-xs font-bold text-[#267D76]">
                      <ShieldCheck className="h-3.5 w-3.5" />
                      {statusLabel}
                    </Badge>
                  )}
                </div>
              </div>
            </div>

            <div className="w-full max-w-sm rounded-[1.6rem] border border-white/20 bg-white/12 p-4 shadow-2xl shadow-black/10 backdrop-blur-md lg:mr-2">
              <div className="flex items-center gap-4">
                <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-white/15 text-white ring-1 ring-white/20">
                  <Home className="h-7 w-7" />
                </div>
                <div>
                  <p className="text-xs font-bold uppercase tracking-[0.2em] text-white/70">EasyHouse</p>
                  <p className="text-lg font-extrabold leading-tight text-white">Quản lý thuê phòng</p>
                </div>
              </div>
            </div>
          </div>
        </section>

        <Tabs defaultValue="profile" className="grid gap-6 lg:grid-cols-[286px_minmax(0,1fr)] lg:items-start">
          <Card className="overflow-hidden rounded-[1.6rem] border-[#E8DED2] bg-white/90 py-0 shadow-[0_18px_55px_rgba(36,59,90,0.12)]">
            <CardHeader className="px-5 pb-2 pt-5">
              <CardTitle className="text-xs font-extrabold uppercase tracking-[0.18em] text-[#243B5A]/55">
                Điều hướng
              </CardTitle>
            </CardHeader>
            <CardContent className="px-3 pb-4">
              <TabsList className="flex h-auto w-full flex-col gap-2 bg-transparent p-0">
                <TabsTrigger
                  value="profile"
                  className="group h-auto w-full justify-start rounded-2xl border border-transparent px-4 py-3 text-left text-sm font-bold text-[#526477] data-[state=active]:border-[#4FA7A0]/25 data-[state=active]:bg-[#4FA7A0]/10 data-[state=active]:text-[#243B5A] data-[state=active]:shadow-sm"
                >
                  <User className="mr-2 h-4 w-4 text-[#4FA7A0] group-data-[state=active]:text-[#243B5A]" />
                  <span className="flex-1">Thông tin cá nhân</span>
                  <ChevronRight className="ml-auto h-4 w-4 opacity-40" />
                </TabsTrigger>
                <TabsTrigger
                  value="security"
                  className="group h-auto w-full justify-start rounded-2xl border border-transparent px-4 py-3 text-left text-sm font-bold text-[#526477] data-[state=active]:border-[#4FA7A0]/25 data-[state=active]:bg-[#4FA7A0]/10 data-[state=active]:text-[#243B5A] data-[state=active]:shadow-sm"
                >
                  <Lock className="mr-2 h-4 w-4 text-[#4FA7A0] group-data-[state=active]:text-[#243B5A]" />
                  <span className="flex-1">Đổi mật khẩu</span>
                  <ChevronRight className="ml-auto h-4 w-4 opacity-40" />
                </TabsTrigger>
                <TabsTrigger
                  value="notifications"
                  className="group h-auto w-full justify-start rounded-2xl border border-transparent px-4 py-3 text-left text-sm font-bold text-[#526477] data-[state=active]:border-[#4FA7A0]/25 data-[state=active]:bg-[#4FA7A0]/10 data-[state=active]:text-[#243B5A] data-[state=active]:shadow-sm"
                >
                  <Bell className="mr-2 h-4 w-4 text-[#4FA7A0] group-data-[state=active]:text-[#243B5A]" />
                  <span className="flex-1">Thông báo</span>
                  <ChevronRight className="ml-auto h-4 w-4 opacity-40" />
                </TabsTrigger>
              </TabsList>

              <div className="mt-3 space-y-2 border-t border-[#E8DED2] pt-3">
                {navLinkItems.map((item) => {
                  const Icon = item.icon;
                  return (
                    <Button
                      key={item.href}
                      type="button"
                      variant="ghost"
                      onClick={() => router.push(item.href)}
                      className="h-auto w-full justify-start rounded-2xl px-4 py-3 text-sm font-bold text-[#526477] hover:bg-[#F8F3EC] hover:text-[#243B5A]"
                    >
                      <Icon className="mr-2 h-4 w-4 text-[#4FA7A0]" />
                      <span className="flex-1 text-left">{item.label}</span>
                      <ChevronRight className="ml-auto h-4 w-4 opacity-40" />
                    </Button>
                  );
                })}
              </div>

              <div className="mt-3 border-t border-[#E8DED2] pt-3">
                <Button
                  type="button"
                  variant="ghost"
                  onClick={() => signOut({ callbackUrl: '/dang-nhap' })}
                  className="h-auto w-full justify-start rounded-2xl border border-[#F2A45B]/20 bg-[#F2A45B]/10 px-4 py-3 text-sm font-bold text-[#A13C33] hover:bg-[#F2A45B]/20 hover:text-[#8C2F28]"
                >
                  <LogOut className="mr-2 h-4 w-4" />
                  <span className="flex-1 text-left">Đăng xuất</span>
                </Button>
              </div>
            </CardContent>
          </Card>

          <div className="min-w-0">
            <TabsContent value="profile" className="mt-0">
              <Card className="overflow-hidden rounded-[1.6rem] border-[#E8DED2] bg-white/95 py-0 shadow-[0_18px_55px_rgba(36,59,90,0.12)]">
                <CardHeader className="flex flex-col gap-4 border-b border-[#E8DED2] px-5 py-5 md:flex-row md:items-center md:justify-between md:px-7">
                  <div>
                    <CardTitle className="text-2xl font-extrabold tracking-tight text-[#243B5A]">
                      Thông tin cá nhân
                    </CardTitle>
                    <CardDescription className="mt-2 text-sm text-[#6B7C8F]">
                      Chỉnh sửa tên, số điện thoại và địa chỉ của bạn
                    </CardDescription>
                  </div>
                  {!isEditing && (
                    <Button
                      onClick={() => setIsEditing(true)}
                      className="h-12 rounded-2xl bg-gradient-to-r from-[#243B5A] to-[#2D62B7] px-5 text-sm font-bold text-white shadow-lg shadow-[#243B5A]/20 hover:from-[#1E314B] hover:to-[#2657A7] md:w-auto"
                    >
                      <Edit3 className="mr-2 h-4 w-4" />
                      Chỉnh sửa
                    </Button>
                  )}
                </CardHeader>

                <CardContent className="space-y-6 px-5 py-6 md:px-7 md:py-7">
                  <div className="grid grid-cols-1 gap-5 md:grid-cols-2">
                    <ProfileField
                      icon={User}
                      label="Họ và tên"
                      value={displayName}
                      editing={isEditing}
                    >
                      <Input
                        id="name"
                        value={formData.name}
                        onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                        placeholder="Nhập họ và tên"
                        className="h-12 rounded-2xl border-[#E8DED2] bg-white pl-11 text-[#243B5A] shadow-sm focus-visible:ring-[#4FA7A0]/30"
                      />
                    </ProfileField>

                    <ProfileField icon={Mail} label="Địa chỉ email" value={displayEmail} isLocked />

                    <ProfileField
                      icon={Phone}
                      label="Số điện thoại"
                      value={displayPhone}
                      editing={isEditing}
                    >
                      <Input
                        id="phone"
                        value={formData.phone}
                        onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                        placeholder="Nhập số điện thoại"
                        className="h-12 rounded-2xl border-[#E8DED2] bg-white pl-11 text-[#243B5A] shadow-sm focus-visible:ring-[#4FA7A0]/30"
                      />
                    </ProfileField>

                    <ProfileField icon={MapPin} label="Địa chỉ" value={displayAddress} editing={isEditing}>
                      <div className="space-y-3">
                        <div className="grid grid-cols-1 gap-3 sm:grid-cols-3">
                          <div className="space-y-1.5">
                            <p className="ml-1 text-[10px] font-bold uppercase tracking-wide text-[#6B7C8F]">Tỉnh / Thành phố</p>
                            <Select value={selectedProvince} onValueChange={setSelectedProvince}>
                              <SelectTrigger className="h-11 rounded-2xl border-[#E8DED2]">
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
                            <p className="ml-1 text-[10px] font-bold uppercase tracking-wide text-[#6B7C8F]">Quận / Huyện</p>
                            <Select value={selectedDistrict} onValueChange={setSelectedDistrict} disabled={!selectedProvince}>
                              <SelectTrigger className="h-11 rounded-2xl border-[#E8DED2]">
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
                            <p className="ml-1 text-[10px] font-bold uppercase tracking-wide text-[#6B7C8F]">Phường / Xã</p>
                            <Select value={selectedWard} onValueChange={setSelectedWard} disabled={!selectedDistrict}>
                              <SelectTrigger className="h-11 rounded-2xl border-[#E8DED2]">
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
                        <Input
                          value={detailAddress}
                          onChange={(e) => setDetailAddress(e.target.value)}
                          placeholder="Số nhà, tên đường..."
                          className="h-12 rounded-2xl border-[#E8DED2] bg-white text-[#243B5A] shadow-sm focus-visible:ring-[#4FA7A0]/30"
                        />
                      </div>
                    </ProfileField>
                  </div>

                  <div className="rounded-2xl border border-[#4FA7A0]/20 bg-[#4FA7A0]/10 p-4 text-sm text-[#243B5A]">
                    <div className="flex gap-3">
                      <div className="mt-0.5 flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-white text-[#243B5A] shadow-sm">
                        <ShieldCheck className="h-4 w-4" />
                      </div>
                      <p className="leading-6">
                        Email không thể tự thay đổi. Để cập nhật email, liên hệ chủ trọ hoặc gửi yêu cầu hỗ trợ.
                      </p>
                    </div>
                  </div>

                  <div className="grid grid-cols-1 gap-4 border-t border-[#E8DED2] pt-5 sm:grid-cols-2">
                    <SystemInfoCard label="Ngày tham gia" value={formatDate(profile?.createdAt)} />
                    <SystemInfoCard label="Hoạt động cuối" value={formatDate(profile?.lastLogin)} />
                  </div>

                  {isEditing && (
                    <div className="flex flex-col gap-3 border-t border-[#E8DED2] pt-6 sm:flex-row sm:justify-end">
                      <Button
                        variant="outline"
                        size="lg"
                        onClick={handleCancel}
                        className="h-12 rounded-2xl border-[#E8DED2] px-8 font-bold text-[#243B5A] hover:bg-[#F8F3EC]"
                      >
                        Hủy
                      </Button>
                      <Button
                        size="lg"
                        onClick={handleSave}
                        disabled={saving}
                        className="h-12 min-w-[150px] rounded-2xl bg-gradient-to-r from-[#243B5A] to-[#2D62B7] px-8 font-bold text-white shadow-lg shadow-[#243B5A]/20 hover:from-[#1E314B] hover:to-[#2657A7]"
                      >
                        {saving ? (
                          <span className="flex items-center gap-2">
                            <span className="h-4 w-4 animate-spin rounded-full border-2 border-white/30 border-t-white" />
                            Đang lưu...
                          </span>
                        ) : (
                          <span className="flex items-center gap-2">
                            <Save className="h-4 w-4" />
                            Lưu thay đổi
                          </span>
                        )}
                      </Button>
                    </div>
                  )}
                </CardContent>
              </Card>
            </TabsContent>

            <TabsContent value="security" className="mt-0">
              <Card className="rounded-[1.6rem] border-[#E8DED2] bg-white/95 py-0 shadow-[0_18px_55px_rgba(36,59,90,0.12)]">
                <CardHeader className="border-b border-[#E8DED2] px-5 py-5 md:px-7">
                  <CardTitle className="text-2xl font-extrabold tracking-tight text-[#243B5A]">Đổi mật khẩu</CardTitle>
                  <CardDescription className="mt-2 text-sm text-[#6B7C8F]">
                    Đảm bảo mật khẩu của bạn có ít nhất 8 ký tự
                  </CardDescription>
                </CardHeader>
                <CardContent className="px-5 py-6 md:px-7 md:py-7">
                  <form onSubmit={handlePasswordChange} className="mx-auto max-w-xl space-y-5">
                    <PasswordInput
                      id="old-password"
                      label="Mật khẩu hiện tại"
                      value={passwordData.oldPassword}
                      onChange={(value) => setPasswordData({ ...passwordData, oldPassword: value })}
                    />
                    <PasswordInput
                      id="new-password"
                      label="Mật khẩu mới"
                      value={passwordData.newPassword}
                      onChange={(value) => setPasswordData({ ...passwordData, newPassword: value })}
                    />
                    <PasswordInput
                      id="confirm-password"
                      label="Xác nhận mật khẩu mới"
                      value={passwordData.confirmPassword}
                      onChange={(value) => setPasswordData({ ...passwordData, confirmPassword: value })}
                    />
                    <Button
                      type="submit"
                      disabled={changingPassword}
                      className="h-12 w-full rounded-2xl bg-gradient-to-r from-[#243B5A] to-[#2D62B7] font-bold text-white shadow-lg shadow-[#243B5A]/20 hover:from-[#1E314B] hover:to-[#2657A7]"
                    >
                      {changingPassword ? 'Đang cập nhật...' : 'Đổi mật khẩu'}
                    </Button>
                  </form>
                </CardContent>
              </Card>
            </TabsContent>

            <TabsContent value="notifications" className="mt-0">
              <Card className="rounded-[1.6rem] border-[#E8DED2] bg-white/95 py-0 shadow-[0_18px_55px_rgba(36,59,90,0.12)]">
                <CardHeader className="border-b border-[#E8DED2] px-5 py-5 md:px-7">
                  <CardTitle className="flex items-center gap-2 text-2xl font-extrabold tracking-tight text-[#243B5A]">
                    <Bell className="h-5 w-5 text-[#4FA7A0]" />
                    Cài đặt thông báo
                  </CardTitle>
                  <CardDescription className="mt-2 text-sm text-[#6B7C8F]">
                    Quản lý các thông báo và email
                  </CardDescription>
                </CardHeader>
                <CardContent className="px-5 py-6 md:px-7 md:py-7">
                  <div className="rounded-2xl border border-[#4FA7A0]/20 bg-[#4FA7A0]/10 p-4 text-sm text-[#243B5A]">
                    Tính năng cài đặt thông báo sẽ được cập nhật trong phiên bản tiếp theo.
                  </div>
                </CardContent>
              </Card>
            </TabsContent>
          </div>
        </Tabs>
      </div>
    </div>
  );
}

function ProfileField({
  icon: Icon,
  label,
  value,
  editing,
  isLocked,
  children,
}: {
  icon: React.ComponentType<{ className?: string }>;
  label: string;
  value: string;
  editing?: boolean;
  isLocked?: boolean;
  children?: React.ReactNode;
}) {
  return (
    <div className={label === 'Địa chỉ' ? 'space-y-2 md:col-span-2' : 'space-y-2'}>
      <Label className="text-xs font-extrabold uppercase tracking-[0.12em] text-[#6B7C8F]">
        {label}
      </Label>
      {editing && children ? (
        <div className="relative">
          {label !== 'Địa chỉ' && <Icon className="pointer-events-none absolute left-4 top-4 h-4 w-4 text-[#6B7C8F]" />}
          {children}
        </div>
      ) : (
        <div className="flex min-h-12 items-center gap-3 rounded-2xl border border-[#E8DED2] bg-white px-4 py-3 text-[#243B5A] shadow-sm">
          <Icon className="h-4 w-4 shrink-0 text-[#6B7C8F]" />
          <span className="min-w-0 flex-1 break-words text-sm font-semibold">{value || EMPTY_VALUE}</span>
          {isLocked && <Lock className="h-4 w-4 shrink-0 text-[#6B7C8F]" />}
        </div>
      )}
    </div>
  );
}

function SystemInfoCard({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-center gap-4 rounded-2xl border border-[#E8DED2] bg-[#F8F3EC]/70 p-4">
      <div className="flex h-11 w-11 shrink-0 items-center justify-center rounded-2xl bg-white text-[#4FA7A0] shadow-sm">
        <Calendar className="h-5 w-5" />
      </div>
      <div className="min-w-0">
        <p className="text-xs font-bold uppercase tracking-wide text-[#6B7C8F]">{label}</p>
        <p className="truncate text-sm font-extrabold text-[#243B5A]">{value}</p>
      </div>
    </div>
  );
}

function PasswordInput({
  id,
  label,
  value,
  onChange,
}: {
  id: string;
  label: string;
  value: string;
  onChange: (value: string) => void;
}) {
  return (
    <div className="space-y-2">
      <Label htmlFor={id} className="text-xs font-extrabold uppercase tracking-[0.12em] text-[#6B7C8F]">
        {label}
      </Label>
      <div className="relative">
        <Key className="pointer-events-none absolute left-4 top-4 h-4 w-4 text-[#6B7C8F]" />
        <Input
          id={id}
          type="password"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder="••••••••"
          required
          className="h-12 rounded-2xl border-[#E8DED2] bg-white pl-11 text-[#243B5A] shadow-sm focus-visible:ring-[#4FA7A0]/30"
        />
      </div>
    </div>
  );
}
