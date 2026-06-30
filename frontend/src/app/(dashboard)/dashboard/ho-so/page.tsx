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
  Activity,
  AlertTriangle,
  Bell,
  Calendar,
  CheckCircle2,
  ChevronRight,
  Clock,
  Edit3,
  FileText,
  HelpCircle,
  Home,
  Key,
  Lock,
  LogOut,
  Mail,
  MapPin,
  Phone,
  Receipt,
  Save,
  Shield,
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

const globalStyles = `
  .ho-so-hero {
    position: relative;
    overflow: hidden;
    isolation: isolate;
    min-height: 300px;
    border-radius: 32px;
    padding: 42px 48px;
    color: #ffffff;
    background-image:
      linear-gradient(
        90deg,
        rgba(13, 35, 61, 0.94) 0%,
        rgba(18, 58, 82, 0.84) 42%,
        rgba(18, 88, 105, 0.32) 68%,
        rgba(18, 88, 105, 0.08) 100%
      ),
      url("/images/ho-so-hero-bg.png");
    background-size: cover;
    background-position: center right;
    background-repeat: no-repeat;
    border: 1px solid rgba(255, 255, 255, 0.16);
    box-shadow: 0 26px 70px rgba(36, 59, 90, 0.22);
    animation: hoSoHeroIn 560ms cubic-bezier(0.22, 1, 0.36, 1) both;
  }

  .ho-so-hero__clouds {
    position: absolute;
    inset: 0;
    z-index: 1;
    pointer-events: none;
    overflow: hidden;
  }

  .ho-so-hero__clouds::before,
  .ho-so-hero__clouds::after {
    content: "";
    position: absolute;
    width: 180px;
    height: 56px;
    border-radius: 999px;
    background:
      radial-gradient(circle at 25% 52%, rgba(255,255,255,0.2) 0 28px, transparent 29px),
      radial-gradient(circle at 48% 35%, rgba(255,255,255,0.16) 0 34px, transparent 35px),
      radial-gradient(circle at 72% 54%, rgba(255,255,255,0.14) 0 26px, transparent 27px);
    opacity: 0.38;
    filter: blur(0.5px);
    animation: hoSoCloudMove 34s linear infinite;
  }

  .ho-so-hero__clouds::before {
    top: 18%;
    left: -220px;
  }

  .ho-so-hero__clouds::after {
    top: 62%;
    left: -280px;
    transform: scale(0.72);
    opacity: 0.28;
    animation-duration: 44s;
    animation-delay: -16s;
  }

  @keyframes hoSoCloudMove {
    from {
      translate: 0 0;
    }
    to {
      translate: calc(100vw + 520px) 0;
    }
  }

  @keyframes hoSoHeroIn {
    from {
      opacity: 0;
      transform: translateY(14px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .ho-so-hero__content {
    position: relative;
    z-index: 2;
    display: flex;
    align-items: center;
    gap: 28px;
    max-width: 720px;
    min-width: 0;
    animation: hoSoItemIn 620ms cubic-bezier(0.22, 1, 0.36, 1) 80ms both;
  }

  .ho-so-hero__avatar-wrap {
    position: relative;
    flex: 0 0 auto;
  }

  .ho-so-hero__avatar {
    display: grid;
    place-items: center;
    width: 132px;
    height: 132px;
    border-radius: 34px;
    color: #ffffff;
    font-size: 48px;
    font-weight: 800;
    background:
      linear-gradient(135deg, rgba(255,255,255,0.22), rgba(255,255,255,0.06)),
      linear-gradient(135deg, #4FA7A0 0%, #243B5A 100%);
    border: 3px solid rgba(255, 255, 255, 0.42);
    box-shadow:
      0 22px 54px rgba(0, 0, 0, 0.22),
      0 0 0 8px rgba(255, 255, 255, 0.06);
    overflow: hidden;
    transition:
      transform 240ms ease,
      box-shadow 240ms ease;
  }

  .ho-so-hero__avatar:hover {
    transform: translateY(-3px);
    box-shadow:
      0 28px 70px rgba(0, 0, 0, 0.28),
      0 0 0 8px rgba(79, 167, 160, 0.16);
  }

  .ho-so-hero__avatar-fallback {
    border-radius: 28px;
    background:
      linear-gradient(135deg, rgba(255,255,255,0.18), rgba(255,255,255,0.06)),
      linear-gradient(135deg, #4FA7A0 0%, #243B5A 100%);
    color: #ffffff;
    font-size: 48px;
    font-weight: 850;
  }

  .ho-so-hero__status-dot {
    position: absolute;
    right: 12px;
    bottom: 12px;
    width: 18px;
    height: 18px;
    border-radius: 999px;
    background: #22c55e;
    border: 3px solid rgba(255, 255, 255, 0.92);
    box-shadow: 0 0 0 5px rgba(34, 197, 94, 0.16);
  }

  .ho-so-hero__info {
    min-width: 0;
  }

  .ho-so-hero__role {
    display: inline-flex;
    align-items: center;
    min-height: 30px;
    padding: 6px 12px;
    border-radius: 999px;
    color: #ffffff;
    font-size: 12px;
    font-weight: 850;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    background: rgba(255, 255, 255, 0.14);
    border: 1px solid rgba(255, 255, 255, 0.22);
    backdrop-filter: blur(14px);
  }

  .ho-so-hero__info h1 {
    margin: 8px 0 6px;
    color: #ffffff;
    font-size: clamp(40px, 4vw, 64px);
    line-height: 1;
    font-weight: 850;
    letter-spacing: 0;
    overflow-wrap: anywhere;
  }

  .ho-so-hero__email {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    max-width: 100%;
    margin: 0;
    color: rgba(255, 255, 255, 0.86);
    font-size: 17px;
    font-weight: 650;
    overflow-wrap: anywhere;
  }

  .ho-so-hero__badges {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-top: 14px;
  }

  .ho-so-hero__badge {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    min-height: 34px;
    padding: 7px 12px;
    border-radius: 999px;
    color: #7FFFE0;
    font-size: 13px;
    font-weight: 800;
    background: rgba(79, 167, 160, 0.16);
    border: 1px solid rgba(127, 255, 224, 0.22);
    backdrop-filter: blur(14px);
  }

  .ho-so-hero__badge.is-warning {
    color: #F2A45B;
    background: rgba(242, 164, 91, 0.16);
    border-color: rgba(242, 164, 91, 0.28);
  }

  .ho-so-hero__badge.is-danger {
    color: #FFB4B4;
    background: rgba(239, 68, 68, 0.16);
    border-color: rgba(239, 68, 68, 0.28);
  }

  .ho-so-hero__description {
    max-width: 620px;
    margin-top: 16px;
    color: rgba(255, 255, 255, 0.76);
    font-size: 15px;
    line-height: 1.55;
  }

  .ho-so-hero__side {
    position: absolute;
    z-index: 2;
    top: 36px;
    right: 40px;
    display: grid;
    gap: 16px;
    width: min(330px, 32vw);
    animation: hoSoItemIn 620ms cubic-bezier(0.22, 1, 0.36, 1) 140ms both;
  }

  .ho-so-hero__brand-card,
  .ho-so-hero__completion-card {
    border-radius: 24px;
    padding: 20px;
    color: #ffffff;
    background: rgba(255, 255, 255, 0.13);
    border: 1px solid rgba(255, 255, 255, 0.2);
    backdrop-filter: blur(16px);
    box-shadow:
      inset 0 1px 0 rgba(255, 255, 255, 0.14),
      0 18px 42px rgba(0, 0, 0, 0.16);
  }

  .ho-so-hero__brand-card {
    display: flex;
    align-items: center;
    gap: 14px;
  }

  .ho-so-hero__brand-icon {
    display: grid;
    place-items: center;
    width: 48px;
    height: 48px;
    flex: 0 0 auto;
    border-radius: 18px;
    color: #ffffff;
    background: rgba(255, 255, 255, 0.15);
    border: 1px solid rgba(255, 255, 255, 0.2);
  }

  .ho-so-hero__brand-card p,
  .ho-so-hero__completion-card p {
    margin: 0;
  }

  .ho-so-hero__eyebrow {
    color: rgba(255, 255, 255, 0.72);
    font-size: 10px;
    font-weight: 800;
    letter-spacing: 0.18em;
    text-transform: uppercase;
  }

  .ho-so-hero__brand-title {
    margin-top: 4px;
    color: #ffffff;
    font-size: 16px;
    font-weight: 850;
    line-height: 1.2;
  }

  .ho-so-hero__completion-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
  }

  .ho-so-hero__completion-head span {
    color: rgba(255, 255, 255, 0.9);
    font-size: 12px;
    font-weight: 800;
  }

  .ho-so-hero__completion-head strong {
    color: #7FFFE0;
    font-size: 20px;
    font-weight: 900;
  }

  .ho-so-hero__progress {
    height: 10px;
    overflow: hidden;
    margin-top: 12px;
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.16);
  }

  .ho-so-hero__progress > div {
    height: 100%;
    border-radius: inherit;
    background: linear-gradient(90deg, #4FA7A0 0%, #7FFFE0 70%, #F2A45B 100%);
    box-shadow: 0 0 18px rgba(127, 255, 224, 0.32);
    transform-origin: left;
    animation: profileProgressIn 800ms cubic-bezier(0.22, 1, 0.36, 1) both;
  }

  .ho-so-hero__missing {
    margin-top: 10px !important;
    color: rgba(255, 255, 255, 0.72);
    font-size: 12px;
    font-weight: 700;
    line-height: 1.45;
  }

  @keyframes profileProgressIn {
    from {
      transform: scaleX(0);
    }
    to {
      transform: scaleX(1);
    }
  }

  @keyframes hoSoItemIn {
    from {
      opacity: 0;
      transform: translateY(12px) scale(0.98);
    }
    to {
      opacity: 1;
      transform: translateY(0) scale(1);
    }
  }

  @media (max-width: 1024px) {
    .ho-so-hero {
      padding: 34px 32px;
    }

    .ho-so-hero__side {
      position: relative;
      top: auto;
      right: auto;
      width: 100%;
      max-width: 560px;
      margin-top: 28px;
    }
  }

  @media (max-width: 768px) {
    .ho-so-hero {
      min-height: auto;
      padding: 28px 22px;
      border-radius: 24px;
      background-position: 72% center;
      background-image:
        linear-gradient(
          90deg,
          rgba(13, 35, 61, 0.97) 0%,
          rgba(18, 58, 82, 0.94) 58%,
          rgba(18, 88, 105, 0.78) 100%
        ),
        url("/images/ho-so-hero-bg.png");
    }

    .ho-so-hero__content {
      align-items: flex-start;
      flex-direction: column;
      gap: 18px;
    }

    .ho-so-hero__avatar {
      width: 96px;
      height: 96px;
      border-radius: 26px;
      font-size: 36px;
    }

    .ho-so-hero__avatar-fallback {
      border-radius: 22px;
      font-size: 36px;
    }

    .ho-so-hero__status-dot {
      right: 8px;
      bottom: 8px;
      width: 16px;
      height: 16px;
    }

    .ho-so-hero__info h1 {
      font-size: 42px;
    }

    .ho-so-hero__email {
      font-size: 15px;
    }
  }

  @media (max-width: 520px) {
    .ho-so-hero {
      padding: 24px 18px;
    }

    .ho-so-hero__info h1 {
      font-size: 34px;
    }

    .ho-so-hero__brand-card,
    .ho-so-hero__completion-card {
      padding: 16px;
      border-radius: 20px;
    }
  }

  .profile-page-card {
    animation: profileCardIn 520ms cubic-bezier(0.22, 1, 0.36, 1) both;
  }

  @keyframes profileCardIn {
    from {
      opacity: 0;
      transform: translateY(12px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .profile-action-button {
    transition:
      transform 220ms ease,
      box-shadow 220ms ease,
      background-color 220ms ease;
  }

  .profile-action-button:hover {
    transform: translateY(-2px);
  }
  
  .profile-nav-item {
    transition: transform 200ms ease, background-color 200ms ease, color 200ms ease;
  }
  .profile-nav-item:hover {
    transform: translateX(4px);
  }

  @media (prefers-reduced-motion: reduce) {
    .ho-so-hero,
    .ho-so-hero__avatar,
    .ho-so-hero__content,
    .ho-so-hero__side,
    .ho-so-hero__progress > div,
    .ho-so-hero__clouds::before,
    .ho-so-hero__clouds::after,
    .profile-page-card,
    .profile-action-button,
    .profile-nav-item {
      animation: none !important;
      transition: none !important;
      transform: none !important;
      translate: none !important;
    }
  }
  
  .profile-card {
    border-radius: 28px;
    background: rgba(255, 255, 255, 0.92);
    border: 1px solid rgba(226, 218, 207, 0.8);
    box-shadow: 0 20px 54px rgba(36, 59, 90, 0.1);
    backdrop-filter: blur(16px);
    transition: box-shadow 300ms ease;
  }

  .profile-card:hover {
    box-shadow: 0 24px 64px rgba(36, 59, 90, 0.14);
  }
`;

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
    document.title = 'Hồ sơ cá nhân | EasyHouse';
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
        await update({
          ...session,
          user: {
            ...session?.user,
            requirePasswordChange: false
          }
        });
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
  const displayPhone = formData.phone || profile?.phone || session?.user?.phone || EMPTY_VALUE;
  const displayAddress = formData.address || profile?.address || EMPTY_VALUE;
  const displayAvatar = formData.avatar || profile?.avatar || session?.user?.avatar || '';
  const roleLabel = getRoleLabel(profile?.role || session?.user?.role);
  const statusLabel = getStatusLabel(profile?.trangThai, profile?.isActive);
  const hasRealName = Boolean(profile?.name || session?.user?.name);
  const normalizedAccountStatus = (profile?.trangThai || '').toLowerCase();
  const isAccountActive = profile?.isActive === true || normalizedAccountStatus === 'active' || normalizedAccountStatus === 'hoatdong';
  const isAccountWarning = !isAccountActive && (
    profile?.isActive === false ||
    normalizedAccountStatus.includes('inactive') ||
    normalizedAccountStatus.includes('chuakichhoat') ||
    normalizedAccountStatus.includes('tamkhoa') ||
    normalizedAccountStatus.includes('khoa') ||
    normalizedAccountStatus.includes('banned')
  );
  const statusBadgeClassName = `ho-so-hero__badge ${isAccountWarning ? 'is-warning' : ''}`;

  // Tính hoàn thiện hồ sơ
  const profileFieldsList = [
    { key: 'name', value: profile?.name || session?.user?.name, label: 'Họ tên' },
    { key: 'email', value: profile?.email || session?.user?.email, label: 'Email' },
    { key: 'phone', value: profile?.phone || session?.user?.phone, label: 'Số điện thoại' },
    { key: 'address', value: profile?.address, label: 'Địa chỉ' },
  ];
  const completedFieldsCount = profileFieldsList.filter(f => Boolean(f.value)).length;
  const completionPercent = Math.round((completedFieldsCount / profileFieldsList.length) * 100);
  const missingFields = profileFieldsList.filter(f => !Boolean(f.value)).map(f => f.label);

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
      <style dangerouslySetInnerHTML={{ __html: globalStyles }} />
      <div className="mx-auto w-full max-w-[1240px] space-y-8">
        
        {/* HERO SECTION */}
        <section className="ho-so-hero">
          <div className="ho-so-hero__clouds" aria-hidden="true" />
          <div className="relative z-10">
            <div className="ho-so-hero__content">
              {/* Avatar */}
              <div className="ho-so-hero__avatar-wrap">
                <Avatar className="ho-so-hero__avatar">
                  <AvatarImage src={displayAvatar} alt={displayName} className="object-cover" />
                  <AvatarFallback className="ho-so-hero__avatar-fallback">
                    {hasRealName ? getInitials(displayName) : <User className="h-10 w-10" />}
                  </AvatarFallback>
                </Avatar>
                {isAccountActive && <div className="ho-so-hero__status-dot" title="Đang hoạt động" />}
              </div>

              {/* Identity Info */}
              <div className="ho-so-hero__info">
                {roleLabel && (
                  <div className="ho-so-hero__role">
                    {roleLabel}
                  </div>
                )}
                <h1>
                  {displayName}
                </h1>
                <p className="ho-so-hero__email">
                  <Mail className="h-4 w-4 shrink-0" />
                  <span>{displayEmail}</span>
                </p>

                <div className="ho-so-hero__badges">
                  {statusLabel && (
                    <Badge className={`${statusBadgeClassName} ${
                      statusLabel === 'Hoạt động' ? 'border-[#4FA7A0]/40 bg-[#4FA7A0]/20 text-[#A6E8E2]' : 
                      statusLabel === 'Tạm khóa' ? 'border-[#F2A45B]/40 bg-[#F2A45B]/20 text-[#FFE5CC]' :
                      'border-white/20 bg-white/10 text-white'
                    }`}>
                      {statusLabel === 'Hoạt động' ? <CheckCircle2 className="mr-1.5 h-3.5 w-3.5" /> : <AlertTriangle className="mr-1.5 h-3.5 w-3.5" />}
                      {statusLabel}
                    </Badge>
                  )}
                  <Badge className="ho-so-hero__badge">
                    <ShieldCheck className="h-3.5 w-3.5" />
                    Bảo mật cao
                  </Badge>
                </div>

                <p className="ho-so-hero__description">
                  Quản lý thông tin tài khoản, bảo mật và trạng thái hồ sơ cá nhân.
                </p>
              </div>
            </div>

            <div className="ho-so-hero__side">
              {/* Brand Card */}
              <div className="ho-so-hero__brand-card">
                <div className="flex items-center gap-4">
                  <div className="ho-so-hero__brand-icon">
                    <Home className="h-6 w-6" />
                  </div>
                  <div>
                    <p className="ho-so-hero__eyebrow">EasyHouse</p>
                    <p className="ho-so-hero__brand-title">Quản lý thuê phòng</p>
                  </div>
                </div>
              </div>

              {/* Completion Bar */}
              <div className="ho-so-hero__completion-card">
                <div className="ho-so-hero__completion-head">
                  <span>Hoàn thiện hồ sơ</span>
                  <strong>{completionPercent}%</strong>
                </div>
                <div className="ho-so-hero__progress">
                  <div 
                    style={{ width: `${completionPercent}%` }}
                  />
                </div>
                <p className="ho-so-hero__missing">
                  {missingFields.length > 0 ? `Còn thiếu: ${missingFields.join(', ')}` : 'Hồ sơ đã được cập nhật đầy đủ'}
                </p>
              </div>
            </div>
          </div>
        </section>

        {/* MAIN LAYOUT */}
        <Tabs defaultValue="profile" className="grid gap-6 lg:grid-cols-[286px_minmax(0,1fr)] lg:items-start">
          
          {/* SIDEBAR NAVIGATION */}
          <div className="flex flex-col gap-6">
            <Card className="profile-card profile-page-card overflow-hidden py-2" style={{ animationDelay: '100ms' }}>
              <CardContent className="p-3">
                <div className="flex flex-col gap-1">
                  
                  {/* Nhóm: Tài khoản */}
                  <p className="px-3 py-2 text-[10px] font-extrabold uppercase tracking-widest text-[#6B7C8F]/70">Tài khoản</p>
                  <TabsList className="flex h-auto w-full flex-col gap-1 bg-transparent p-0">
                    <TabsTrigger
                      value="profile"
                      className="profile-nav-item group h-auto w-full justify-start rounded-2xl border border-transparent px-4 py-3 text-left text-sm font-bold text-[#526477] data-[state=active]:border-[#4FA7A0]/25 data-[state=active]:bg-[#4FA7A0]/10 data-[state=active]:text-[#243B5A] data-[state=active]:shadow-sm hover:bg-[#F8F3EC] hover:text-[#243B5A]"
                    >
                      <User className="mr-3 h-4 w-4 text-[#4FA7A0] opacity-80 group-data-[state=active]:opacity-100" />
                      <span className="flex-1">Thông tin cá nhân</span>
                      <ChevronRight className="ml-auto h-4 w-4 opacity-40 group-data-[state=active]:opacity-100 group-data-[state=active]:text-[#4FA7A0]" />
                    </TabsTrigger>
                    <TabsTrigger
                      value="security"
                      className="profile-nav-item group h-auto w-full justify-start rounded-2xl border border-transparent px-4 py-3 text-left text-sm font-bold text-[#526477] data-[state=active]:border-[#4FA7A0]/25 data-[state=active]:bg-[#4FA7A0]/10 data-[state=active]:text-[#243B5A] data-[state=active]:shadow-sm hover:bg-[#F8F3EC] hover:text-[#243B5A]"
                    >
                      <Lock className="mr-3 h-4 w-4 text-[#4FA7A0] opacity-80 group-data-[state=active]:opacity-100" />
                      <span className="flex-1">Đổi mật khẩu</span>
                      <ChevronRight className="ml-auto h-4 w-4 opacity-40 group-data-[state=active]:opacity-100 group-data-[state=active]:text-[#4FA7A0]" />
                    </TabsTrigger>
                    <TabsTrigger
                      value="notifications"
                      className="profile-nav-item group h-auto w-full justify-start rounded-2xl border border-transparent px-4 py-3 text-left text-sm font-bold text-[#526477] data-[state=active]:border-[#4FA7A0]/25 data-[state=active]:bg-[#4FA7A0]/10 data-[state=active]:text-[#243B5A] data-[state=active]:shadow-sm hover:bg-[#F8F3EC] hover:text-[#243B5A]"
                    >
                      <Bell className="mr-3 h-4 w-4 text-[#4FA7A0] opacity-80 group-data-[state=active]:opacity-100" />
                      <span className="flex-1">Thông báo</span>
                      <ChevronRight className="ml-auto h-4 w-4 opacity-40 group-data-[state=active]:opacity-100 group-data-[state=active]:text-[#4FA7A0]" />
                    </TabsTrigger>
                  </TabsList>

                  {/* Nhóm: Dữ liệu của tôi */}
                  <div className="mt-2 border-t border-[#E8DED2]/60 pt-2">
                    <p className="px-3 py-2 text-[10px] font-extrabold uppercase tracking-widest text-[#6B7C8F]/70">Dữ liệu của tôi</p>
                    <div className="space-y-1">
                      {navLinkItems.map((item) => {
                        const Icon = item.icon;
                        return (
                          <Button
                            key={item.href}
                            type="button"
                            variant="ghost"
                            onClick={() => router.push(item.href)}
                            className="profile-nav-item h-auto w-full justify-start rounded-2xl px-4 py-3 text-sm font-bold text-[#526477] hover:bg-[#F8F3EC] hover:text-[#243B5A]"
                          >
                            <Icon className="mr-3 h-4 w-4 text-[#4FA7A0] opacity-80" />
                            <span className="flex-1 text-left">{item.label}</span>
                            <ChevronRight className="ml-auto h-4 w-4 opacity-40" />
                          </Button>
                        );
                      })}
                    </div>
                  </div>

                  {/* Nhóm: Phiên làm việc */}
                  <div className="mt-2 border-t border-[#E8DED2]/60 pt-3">
                    <Button
                      type="button"
                      variant="ghost"
                      onClick={() => signOut({ callbackUrl: '/dang-nhap' })}
                      className="profile-nav-item h-auto w-full justify-start rounded-2xl border border-[#F2A45B]/20 bg-[#F2A45B]/5 px-4 py-3 text-sm font-bold text-[#A13C33] hover:bg-[#F2A45B]/20 hover:text-[#8C2F28]"
                    >
                      <LogOut className="mr-3 h-4 w-4" />
                      <span className="flex-1 text-left">Đăng xuất</span>
                    </Button>
                  </div>

                </div>
              </CardContent>
            </Card>

            {/* Help Card */}
            <Card className="profile-card profile-page-card overflow-hidden bg-gradient-to-br from-[#243B5A] to-[#1E314B] border-none text-white p-5" style={{ animationDelay: '200ms' }}>
              <div className="flex items-start gap-3">
                <div className="p-2 bg-white/10 rounded-xl shrink-0">
                  <HelpCircle className="h-5 w-5 text-[#A6E8E2]" />
                </div>
                <div>
                  <h4 className="text-sm font-extrabold mb-1">Bạn cần hỗ trợ?</h4>
                  <p className="text-xs text-white/70 leading-relaxed mb-3">Nếu gặp khó khăn khi sử dụng, hãy liên hệ với trung tâm trợ giúp.</p>
                  <Button variant="outline" className="w-full h-9 rounded-xl border-white/20 bg-transparent hover:bg-white/10 text-white text-xs font-bold transition-colors">
                    Trung tâm trợ giúp
                  </Button>
                </div>
              </div>
            </Card>
          </div>

          {/* CONTENT TABS */}
          <div className="min-w-0">
            
            <TabsContent value="profile" className="mt-0 outline-none">
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 lg:gap-6 mb-6">
                {/* Overview Stats */}
                <div className="profile-page-card profile-card p-5" style={{ animationDelay: '150ms' }}>
                  <div className="flex items-center gap-3 text-[#243B5A] mb-2">
                    <Shield className="h-4 w-4 text-[#4FA7A0]" />
                    <p className="text-[10px] font-extrabold uppercase tracking-widest text-[#6B7C8F]">Vai trò</p>
                  </div>
                  <p className="text-base font-extrabold text-[#243B5A] pl-7 truncate">{roleLabel || EMPTY_VALUE}</p>
                </div>
                <div className="profile-page-card profile-card p-5" style={{ animationDelay: '250ms' }}>
                  <div className="flex items-center gap-3 text-[#243B5A] mb-2">
                    <Calendar className="h-4 w-4 text-[#4FA7A0]" />
                    <p className="text-[10px] font-extrabold uppercase tracking-widest text-[#6B7C8F]">Ngày tham gia</p>
                  </div>
                  <p className="text-base font-extrabold text-[#243B5A] pl-7 truncate">{formatDate(profile?.createdAt)}</p>
                </div>
                <div className="profile-page-card profile-card p-5" style={{ animationDelay: '350ms' }}>
                  <div className="flex items-center gap-3 text-[#243B5A] mb-2">
                    <Clock className="h-4 w-4 text-[#4FA7A0]" />
                    <p className="text-[10px] font-extrabold uppercase tracking-widest text-[#6B7C8F]">Hoạt động cuối</p>
                  </div>
                  <p className="text-base font-extrabold text-[#243B5A] pl-7 truncate">{formatDate(profile?.lastLogin)}</p>
                </div>
              </div>

              <Card className="profile-card profile-page-card border-none" style={{ animationDelay: '450ms' }}>
                <CardHeader className="flex flex-col gap-4 border-b border-[#E8DED2]/60 px-6 py-6 md:flex-row md:items-center md:justify-between">
                  <div>
                    <CardTitle className="text-xl font-extrabold tracking-tight text-[#243B5A]">
                      Thông tin cá nhân
                    </CardTitle>
                    <CardDescription className="mt-1.5 text-sm text-[#6B7C8F]">
                      Quản lý thông tin liên hệ và địa chỉ của bạn
                    </CardDescription>
                  </div>
                  {!isEditing ? (
                    <Button
                      onClick={() => setIsEditing(true)}
                      className="profile-action-button h-11 rounded-2xl bg-gradient-to-r from-[#243B5A] to-[#2D62B7] px-5 text-sm font-bold text-white shadow-lg shadow-[#243B5A]/15 hover:from-[#1E314B] hover:to-[#2657A7] md:w-auto"
                    >
                      <Edit3 className="mr-2 h-4 w-4" />
                      Chỉnh sửa hồ sơ
                    </Button>
                  ) : (
                    <div className="flex items-center gap-2">
                      <Button
                        variant="ghost"
                        onClick={handleCancel}
                        className="h-11 rounded-2xl px-4 text-sm font-bold text-[#6B7C8F] hover:bg-[#F8F3EC] hover:text-[#243B5A]"
                      >
                        Hủy
                      </Button>
                      <Button
                        onClick={handleSave}
                        disabled={saving}
                        className="profile-action-button h-11 rounded-2xl bg-[#4FA7A0] px-5 text-sm font-bold text-white shadow-lg shadow-[#4FA7A0]/20 hover:bg-[#3d8c86]"
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
                </CardHeader>

                <CardContent className="space-y-6 px-6 py-7">
                  <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
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
                        className="h-[52px] rounded-2xl border-[#E8DED2] bg-white pl-11 text-[#243B5A] shadow-sm focus-visible:ring-[#4FA7A0]/30 focus-visible:border-[#4FA7A0]/50 transition-all"
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
                        className="h-[52px] rounded-2xl border-[#E8DED2] bg-white pl-11 text-[#243B5A] shadow-sm focus-visible:ring-[#4FA7A0]/30 focus-visible:border-[#4FA7A0]/50 transition-all"
                      />
                    </ProfileField>

                    <ProfileField icon={MapPin} label="Địa chỉ" value={displayAddress} editing={isEditing}>
                      <div className="space-y-3">
                        <div className="grid grid-cols-1 gap-3 sm:grid-cols-3">
                          <div className="space-y-1.5">
                            <p className="ml-1 text-[10px] font-bold uppercase tracking-wide text-[#6B7C8F]">Tỉnh / Thành phố</p>
                            <Select value={selectedProvince} onValueChange={setSelectedProvince}>
                              <SelectTrigger className="h-[46px] rounded-2xl border-[#E8DED2] focus:ring-[#4FA7A0]/30 transition-all">
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
                              <SelectTrigger className="h-[46px] rounded-2xl border-[#E8DED2] focus:ring-[#4FA7A0]/30 transition-all">
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
                              <SelectTrigger className="h-[46px] rounded-2xl border-[#E8DED2] focus:ring-[#4FA7A0]/30 transition-all">
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
                          className="h-[52px] rounded-2xl border-[#E8DED2] bg-white text-[#243B5A] shadow-sm focus-visible:ring-[#4FA7A0]/30 focus-visible:border-[#4FA7A0]/50 transition-all"
                        />
                      </div>
                    </ProfileField>

                    {/* Email Lock Notification */}
                    <div className="col-span-1 md:col-span-2 mt-2">
                      <div className="flex items-start gap-3 rounded-[18px] border border-[#4FA7A0]/20 bg-[#4FA7A0]/5 p-4 text-[#243B5A]">
                        <div className="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-xl bg-white text-[#4FA7A0] shadow-sm">
                          <ShieldCheck className="h-4 w-4" />
                        </div>
                        <p className="leading-relaxed text-sm font-medium">
                          Email đăng nhập được bảo vệ và không thể tự thay đổi. Để cập nhật email, vui lòng liên hệ chủ trọ hoặc gửi yêu cầu hỗ trợ.
                        </p>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>

              {/* Recent Activity */}
              <Card className="profile-card profile-page-card border-none mt-6" style={{ animationDelay: '550ms' }}>
                <CardHeader className="border-b border-[#E8DED2]/60 px-6 py-5">
                   <CardTitle className="flex items-center gap-2 text-lg font-extrabold tracking-tight text-[#243B5A]">
                     <Activity className="h-5 w-5 text-[#4FA7A0]" />
                     Hoạt động gần đây
                   </CardTitle>
                </CardHeader>
                <CardContent className="px-6 py-6">
                  {profile?.lastLogin ? (
                    <div className="flex items-center gap-4 relative pl-4 border-l-2 border-[#E8DED2]">
                       <div className="absolute -left-[9px] top-1/2 -translate-y-1/2 h-4 w-4 rounded-full bg-white border-2 border-[#4FA7A0]" />
                       <div>
                         <p className="text-sm font-bold text-[#243B5A]">Đăng nhập hệ thống</p>
                         <p className="text-xs font-medium text-[#6B7C8F] mt-0.5">{formatDate(profile?.lastLogin)}</p>
                       </div>
                    </div>
                  ) : (
                    <div className="text-center py-6 text-[#6B7C8F] text-sm font-medium">Chưa có hoạt động gần đây.</div>
                  )}
                </CardContent>
              </Card>
            </TabsContent>

            <TabsContent value="security" className="mt-0 outline-none">
              <div className="grid gap-6">
                <Card className="profile-card profile-page-card border-none" style={{ animationDelay: '150ms' }}>
                  <CardHeader className="border-b border-[#E8DED2]/60 px-6 py-6">
                    <CardTitle className="text-xl font-extrabold tracking-tight text-[#243B5A]">Đổi mật khẩu</CardTitle>
                    <CardDescription className="mt-1.5 text-sm text-[#6B7C8F]">
                      Đảm bảo mật khẩu của bạn có ít nhất 8 ký tự và đủ độ mạnh
                    </CardDescription>
                  </CardHeader>
                  <CardContent className="px-6 py-7">
                    <form onSubmit={handlePasswordChange} className="mx-auto max-w-xl space-y-6">
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
                        className="profile-action-button h-[52px] w-full rounded-2xl bg-gradient-to-r from-[#243B5A] to-[#2D62B7] font-bold text-white shadow-lg shadow-[#243B5A]/15 hover:from-[#1E314B] hover:to-[#2657A7] text-base mt-2"
                      >
                        {changingPassword ? 'Đang cập nhật...' : 'Đổi mật khẩu'}
                      </Button>
                    </form>
                  </CardContent>
                </Card>

                {/* Account Security Info Card */}
                <Card className="profile-card profile-page-card border-none" style={{ animationDelay: '250ms' }}>
                  <CardHeader className="border-b border-[#E8DED2]/60 px-6 py-5">
                    <CardTitle className="flex items-center gap-2 text-lg font-extrabold tracking-tight text-[#243B5A]">
                      <ShieldCheck className="h-5 w-5 text-[#4FA7A0]" />
                      Bảo mật tài khoản
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="px-6 py-6 space-y-4">
                    <div className="flex items-center justify-between p-4 rounded-2xl bg-[#F8F3EC]/50 border border-transparent hover:bg-[#F8F3EC] transition-colors">
                      <div className="flex items-center gap-3">
                        <Key className="h-5 w-5 text-[#6B7C8F]" />
                        <div>
                          <p className="text-sm font-bold text-[#243B5A]">Mật khẩu</p>
                          <p className="text-xs text-[#6B7C8F] mt-0.5">Đã thiết lập</p>
                        </div>
                      </div>
                      <Badge className="bg-[#4FA7A0]/10 text-[#267D76] border-none font-bold">An toàn</Badge>
                    </div>
                    <div className="flex items-center justify-between p-4 rounded-2xl bg-[#F8F3EC]/50 border border-transparent hover:bg-[#F8F3EC] transition-colors">
                      <div className="flex items-center gap-3">
                        <Mail className="h-5 w-5 text-[#6B7C8F]" />
                        <div>
                          <p className="text-sm font-bold text-[#243B5A]">Email đăng nhập</p>
                          <p className="text-xs text-[#6B7C8F] mt-0.5">Được bảo vệ</p>
                        </div>
                      </div>
                      <Badge className="bg-[#4FA7A0]/10 text-[#267D76] border-none font-bold">Xác thực</Badge>
                    </div>
                    <div className="flex items-center justify-between p-4 rounded-2xl bg-[#F8F3EC]/50 border border-transparent hover:bg-[#F8F3EC] transition-colors">
                      <div className="flex items-center gap-3">
                        <Activity className="h-5 w-5 text-[#6B7C8F]" />
                        <div>
                          <p className="text-sm font-bold text-[#243B5A]">Phiên đăng nhập</p>
                          <p className="text-xs text-[#6B7C8F] mt-0.5">Đang hoạt động</p>
                        </div>
                      </div>
                      <Badge className="bg-[#4FA7A0]/10 text-[#267D76] border-none font-bold">An toàn</Badge>
                    </div>
                  </CardContent>
                </Card>
              </div>
            </TabsContent>

            <TabsContent value="notifications" className="mt-0 outline-none">
              <Card className="profile-card profile-page-card border-none" style={{ animationDelay: '150ms' }}>
                <CardHeader className="border-b border-[#E8DED2]/60 px-6 py-6">
                  <CardTitle className="flex items-center gap-2 text-xl font-extrabold tracking-tight text-[#243B5A]">
                    <Bell className="h-5 w-5 text-[#4FA7A0]" />
                    Cài đặt thông báo
                  </CardTitle>
                  <CardDescription className="mt-1.5 text-sm text-[#6B7C8F]">
                    Quản lý các thông báo hệ thống và email
                  </CardDescription>
                </CardHeader>
                <CardContent className="px-6 py-7">
                  <div className="rounded-[18px] border border-[#4FA7A0]/20 bg-[#4FA7A0]/5 p-5 text-sm text-[#243B5A]">
                    <p className="font-medium text-center">
                      Tính năng tùy chỉnh cài đặt thông báo chi tiết đang được phát triển và sẽ sớm ra mắt.
                    </p>
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
    <div className={label === 'Địa chỉ' ? 'space-y-2.5 md:col-span-2' : 'space-y-2.5'}>
      <Label className="text-[11px] font-bold uppercase tracking-[0.15em] text-[#6B7C8F] ml-1">
        {label}
      </Label>
      {editing && children ? (
        <div className="relative">
          {label !== 'Địa chỉ' && <Icon className="pointer-events-none absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-[#6B7C8F]" />}
          {children}
        </div>
      ) : (
        <div className="flex min-h-[52px] items-center gap-3 rounded-2xl border border-transparent bg-[#F8F3EC]/50 px-4 py-3 text-[#243B5A] transition-colors hover:bg-[#F8F3EC]">
          <Icon className="h-4 w-4 shrink-0 text-[#4FA7A0]" />
          <span className="min-w-0 flex-1 break-words text-sm font-semibold">{value || EMPTY_VALUE}</span>
          {isLocked && <Lock className="h-4 w-4 shrink-0 text-[#6B7C8F]/60" />}
        </div>
      )}
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
    <div className="space-y-2.5">
      <Label htmlFor={id} className="text-[11px] font-bold uppercase tracking-[0.15em] text-[#6B7C8F] ml-1">
        {label}
      </Label>
      <div className="relative">
        <Key className="pointer-events-none absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-[#6B7C8F]" />
        <Input
          id={id}
          type="password"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder="••••••••"
          required
          className="h-[52px] rounded-2xl border-[#E8DED2] bg-white pl-11 text-[#243B5A] shadow-sm focus-visible:ring-[#4FA7A0]/30 focus-visible:border-[#4FA7A0]/50 transition-all"
        />
      </div>
    </div>
  );
}
