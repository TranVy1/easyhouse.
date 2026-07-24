'use client';

import { useState, useEffect, useRef } from 'react';
import { useSession } from 'next-auth/react';
import { Button } from '@/components/ui/button';
import { useCache } from '@/hooks/use-cache';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Badge } from '@/components/ui/badge';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { DashboardHero, DashboardKpiCard, DashboardCard } from '@/components/dashboard/shared-ui';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { 
  Users, 
  Plus, 
  Search, 
  Edit, 
  Trash2, 
  Shield, 
  Phone,
  Calendar,
  RefreshCw
} from 'lucide-react';
import { toast } from 'sonner';
import { UserDataTable } from './table';
import { ConfirmActionDialog } from '@/components/ui/confirm-action-dialog';

interface User {
  _id: string;
  name?: string;
  ten?: string;
  email: string;
  phone?: string;
  soDienThoai?: string;
  role?: string;
  vaiTro?: string;
  avatar?: string;
  anhDaiDien?: string;
  createdAt: string;
  lastLogin?: string;
  isActive?: boolean;
  trangThai?: string;
}

interface CreateUserData {
  name: string;
  email: string;
  password: string;
  phone: string;
  role: string;
}

export default function AccountManagementPage() {
  const { data: session } = useSession();
  const { getCache, setCache, clearCache, isRefreshing, setIsRefreshing } = useCache<{ users: User[] }>({ key: 'tai-khoan-data', duration: 300000 });
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [isCreateDialogOpen, setIsCreateDialogOpen] = useState(false);
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false);
  const [selectedUser, setSelectedUser] = useState<User | null>(null);
  
  const [isConfirmOpen, setIsConfirmOpen] = useState(false);
  const [itemToDelete, setItemToDelete] = useState<string | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);
  
  const hasFetchedRef = useRef(false); // Track xem đã fetch chưa
  const [createUserData, setCreateUserData] = useState<CreateUserData>({
    name: '',
    email: '',
    password: '',
    phone: '',
    role: 'admin'
  });
  const [editUserData, setEditUserData] = useState({
    name: '',
    phone: '',
    role: '',
    isActive: true
  });

  useEffect(() => {
    document.title = 'Quản lý Tài khoản';
  }, []);

  useEffect(() => {
    // Chỉ fetch 1 lần duy nhất khi user là admin
    const userRole = session?.user?.role?.replace(/^ROLE_/, '').toUpperCase();
    if (userRole === 'ADMIN' && !hasFetchedRef.current) {
      hasFetchedRef.current = true;
      fetchUsers(false); // Sử dụng cache nếu có
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [session?.user?.role]);

  const fetchUsers = async (forceRefresh = false) => {
    try {
      setLoading(true);
      
      if (!forceRefresh) {
        const cachedData = getCache();
        if (cachedData) {
          setUsers(cachedData.users || []);
          setLoading(false);
          return;
        }
      }
      
      const response = await fetch('/api/admin/users', {
        headers: { Authorization: `Bearer ${session?.accessToken}` },
      });
      if (response.ok) {
        const payload = await response.json();
        if (payload.success === false) {
          toast.error(payload.message || 'Không thể tải danh sách người dùng');
          return;
        }
        const data = Array.isArray(payload) ? payload : payload.data || [];
        setUsers(data);
        setCache({ users: data });
      } else {
        toast.error('Không thể tải danh sách người dùng');
      }
    } catch (error) {
      console.error('Error fetching users:', error);
      toast.error('Có lỗi xảy ra khi tải danh sách người dùng');
    } finally {
      setLoading(false);
    }
  };

  const handleRefresh = async () => {
    setIsRefreshing(true);
    await fetchUsers(true);
    setIsRefreshing(false);
    toast.success('Đã tải dữ liệu mới nhất');
  };

  const handleCreateUser = async () => {
    try {
      const response = await fetch('/api/admin/users', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${session?.accessToken}`,
        },
        body: JSON.stringify(createUserData),
      });

      if (response.ok) {
        const result = await response.json();
        if (result.success === false) {
          toast.error(result.message || 'Tạo tài khoản thất bại');
          return;
        }
        toast.success('Tạo tài khoản thành công');
        setIsCreateDialogOpen(false);
        setCreateUserData({
          name: '',
          email: '',
          password: '',
          phone: '',
          role: 'admin'
        });
        clearCache();
        fetchUsers(true);
      } else {
        const error = await response.json();
        toast.error(error.message || 'Tạo tài khoản thất bại');
      }
    } catch (error) {
      console.error('Error creating user:', error);
      toast.error('Có lỗi xảy ra khi tạo tài khoản');
    }
  };

  const handleEditUser = async () => {
    if (!selectedUser) return;

    try {
      const response = await fetch(`/api/admin/users/${selectedUser._id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${session?.accessToken}`,
        },
        body: JSON.stringify(editUserData),
      });

      if (response.ok) {
        const result = await response.json();
        if (result.success === false) {
          toast.error(result.message || 'Cập nhật tài khoản thất bại');
          return;
        }
        toast.success('Cập nhật tài khoản thành công');
        setIsEditDialogOpen(false);
        setSelectedUser(null);
        clearCache();
        fetchUsers(true);
      } else {
        const error = await response.json();
        toast.error(error.message || 'Cập nhật tài khoản thất bại');
      }
    } catch (error) {
      console.error('Error updating user:', error);
      toast.error('Có lỗi xảy ra khi cập nhật tài khoản');
    }
  };

  const handleDeleteUser = (userId: string) => {
    setItemToDelete(userId);
    setIsConfirmOpen(true);
  };

  const confirmDeleteUser = async () => {
    if (!itemToDelete) return;
    setIsDeleting(true);
    try {
      const response = await fetch(`/api/admin/users/${itemToDelete}`, {
        method: 'DELETE',
        headers: { Authorization: `Bearer ${session?.accessToken}` },
      });

      if (response.ok) {
        const result = await response.json();
        if (result.success === false) {
          toast.error(result.message || 'Xóa tài khoản thất bại');
          return;
        }
        clearCache();
        toast.success('Xóa tài khoản thành công');
        fetchUsers(true);
      } else{
        const error = await response.json();
        toast.error(error.message || 'Xóa tài khoản thất bại');
      }
    } catch (error) {
      console.error('Error deleting user:', error);
      toast.error('Có lỗi xảy ra khi xóa tài khoản');
    } finally {
      setIsDeleting(false);
      setIsConfirmOpen(false);
      setItemToDelete(null);
    }
  };

  const openEditDialog = (user: User) => {
    setSelectedUser(user);
    setEditUserData({
      name: getUserName(user),
      phone: getUserPhone(user),
      role: getUserRole(user),
      isActive: getUserIsActive(user)
    });
    setIsEditDialogOpen(true);
  };

  const getRoleBadge = (role: string) => {
    switch (role) {
      case 'admin':
        return <Badge variant="destructive">Quản trị viên</Badge>;
      default:
        return <Badge variant="outline">Khách thuê</Badge>;
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

  // Helper functions to safely get user data
  const getUserName = (user: User) => user.name || user.ten || 'Không có tên';
  const getUserPhone = (user: User) => user.phone || user.soDienThoai || '';
  const getUserRole = (user: User) => {
    const raw = user.role || user.vaiTro || 'nhanVien';
    const clean = raw.replace(/^ROLE_/, '').toUpperCase();
    if (clean === 'ADMIN') return 'admin';
    if (clean === 'LANDLORD' || clean === 'CHUNHA') return 'chuNha';
    if (clean === 'STAFF' || clean === 'NHANVIEN') return 'nhanVien';
    if (clean === 'TENANT' || clean === 'KHACHTHUE') return 'tenant';
    return raw.toLowerCase();
  };
  const getUserAvatar = (user: User) => user.avatar || user.anhDaiDien || '';
  const getUserIsActive = (user: User) => user.isActive !== undefined ? user.isActive : (user.trangThai === 'hoatDong' || user.trangThai === 'ACTIVE');

  const filteredUsers = users.filter(user =>
    (user.name || user.ten || '').toLowerCase().includes(searchTerm.toLowerCase()) ||
    (user.email || '').toLowerCase().includes(searchTerm.toLowerCase())
  );

  const userRole = session?.user?.role?.replace(/^ROLE_/, '').toUpperCase();
  if (userRole !== 'ADMIN') {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <Shield className="h-12 w-12 text-red-500 mx-auto mb-4" />
          <h2 className="text-xl font-semibold text-gray-900 mb-2">Không có quyền truy cập</h2>
          <p className="text-gray-600">Bạn cần quyền quản trị viên để truy cập trang này.</p>
        </div>
      </div>
    );
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#4FA7A0] mx-auto mb-4"></div>
          <p className="text-gray-600">Đang tải danh sách người dùng...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-4 md:space-y-6">
      <DashboardHero
        icon={Users}
        title="Quản lý tài khoản"
        description="Quản lý người dùng và phân quyền hệ thống"
        actions={
          <>
            <Button 
              variant="outline"
              onClick={handleRefresh}
              disabled={isRefreshing}
            >
              <RefreshCw className={isRefreshing ? 'animate-spin mr-2 h-4 w-4' : 'mr-2 h-4 w-4'} />
              {isRefreshing ? 'Đang tải...' : 'Làm mới'}
            </Button>
            <Button onClick={() => setIsCreateDialogOpen(true)}>
              <Plus className="mr-2 h-4 w-4" />
              Tạo tài khoản
            </Button>
          </>
        }
      >
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 md:gap-4 relative z-10">
          <DashboardKpiCard
            title="Tổng người dùng"
            value={String(users.length)}
            icon={<Users className="h-5 w-5" />}
            tone="default"
          />
          <DashboardKpiCard
            title="Quản trị viên"
            value={String(users.filter(u => getUserRole(u) === 'admin').length)}
            icon={<Shield className="h-5 w-5" />}
            tone="red"
          />
          <DashboardKpiCard
            title="Chủ nhà"
            value={String(users.filter(u => getUserRole(u) === 'chuNha').length)}
            icon={<Users className="h-5 w-5" />}
            tone="emerald"
          />
          <DashboardKpiCard
            title="Nhân viên"
            value={String(users.filter(u => getUserRole(u) === 'nhanVien').length)}
            icon={<Users className="h-5 w-5" />}
            tone="orange"
          />
        </div>
      </DashboardHero>

      {/* Create User Dialog */}
      <Dialog open={isCreateDialogOpen} onOpenChange={setIsCreateDialogOpen}>
        <DialogContent className="w-[95vw] sm:w-full sm:max-w-[425px]">
            <DialogHeader>
              <DialogTitle className="text-base md:text-lg">Tạo tài khoản mới</DialogTitle>
              <DialogDescription className="text-xs md:text-sm">
                Tạo tài khoản người dùng mới cho hệ thống
              </DialogDescription>
            </DialogHeader>
            <div className="grid gap-3 md:gap-4 py-4">
              <div className="space-y-2">
                <Label htmlFor="name" className="text-xs md:text-sm">Họ và tên</Label>
                <Input
                  id="name"
                  value={createUserData.name}
                  onChange={(e) => setCreateUserData({ ...createUserData, name: e.target.value })}
                  placeholder="Nhập họ và tên"
                  className="text-sm"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="email" className="text-xs md:text-sm">Email</Label>
                <Input
                  id="email"
                  type="email"
                  value={createUserData.email}
                  onChange={(e) => setCreateUserData({ ...createUserData, email: e.target.value })}
                  placeholder="Nhập email"
                  className="text-sm"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="password" className="text-xs md:text-sm">Mật khẩu</Label>
                <Input
                  id="password"
                  type="password"
                  value={createUserData.password}
                  onChange={(e) => setCreateUserData({ ...createUserData, password: e.target.value })}
                  placeholder="Nhập mật khẩu"
                  className="text-sm"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="phone" className="text-xs md:text-sm">Số điện thoại</Label>
                <Input
                  id="phone"
                  value={createUserData.phone}
                  onChange={(e) => setCreateUserData({ ...createUserData, phone: e.target.value })}
                  placeholder="Nhập số điện thoại"
                  className="text-sm"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="role" className="text-xs md:text-sm">Vai trò</Label>
                <Select value={createUserData.role} onValueChange={(value) => setCreateUserData({ ...createUserData, role: value })}>
                  <SelectTrigger className="text-sm">
                    <SelectValue placeholder="Chọn vai trò" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="admin" className="text-sm">Quản trị viên</SelectItem>
                    <SelectItem value="tenant" className="text-sm">Khách thuê</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>
            <DialogFooter className="flex-col sm:flex-row gap-2">
              <Button variant="outline" size="sm" onClick={() => setIsCreateDialogOpen(false)} className="w-full sm:w-auto">
                Hủy
              </Button>
              <Button size="sm" onClick={handleCreateUser} className="w-full sm:w-auto">
                Tạo tài khoản
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>

     



      {/* Desktop Table */}
      <DashboardCard className="hidden md:block overflow-hidden border-0 shadow-sm ring-1 ring-[#E5E0D8]">
        <CardHeader className="border-b bg-[#F2E8DC]/70 p-5 md:p-6">
          <CardTitle className="text-lg">
            Danh sách người dùng
          </CardTitle>
          <CardDescription>
            Quản lý tất cả tài khoản trong hệ thống ({filteredUsers.length} người dùng)
          </CardDescription>
        </CardHeader>
        <CardContent className="p-6">
          <UserDataTable
            data={filteredUsers}
            onEdit={openEditDialog}
            onDelete={handleDeleteUser}
            currentUserId={session?.user?.id}
            searchTerm={searchTerm}
            onSearchChange={setSearchTerm}
          />
        </CardContent>
      </DashboardCard>

      {/* Mobile Cards */}
      <div className="md:hidden">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-lg font-semibold">Danh sách người dùng</h2>
          <span className="text-sm text-gray-500">{filteredUsers.length} người dùng</span>
        </div>

        {/* Mobile Search */}
        <div className="mb-4">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
            <Input
              placeholder="Tìm kiếm..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="pl-10 text-sm"
            />
          </div>
        </div>

        {/* Mobile Card List */}
        <div className="space-y-3">
          {filteredUsers.map((user) => {
            const isCurrentUser = session?.user?.id === user._id;
            
            return (
              <Card key={user._id} className="p-4">
                <div className="space-y-3">
                  {/* Header with avatar and info */}
                  <div className="flex items-start gap-3">
                    <Avatar className="h-12 w-12">
                      <AvatarImage src={getUserAvatar(user)} />
                      <AvatarFallback className="bg-[#4FA7A0]/15 text-[#243B5A]">
                        {getInitials(getUserName(user))}
                      </AvatarFallback>
                    </Avatar>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-start justify-between gap-2">
                        <div className="flex-1 min-w-0">
                          <h3 className="font-medium text-gray-900 truncate">{getUserName(user)}</h3>
                          <p className="text-sm text-gray-500 truncate">{user.email}</p>
                        </div>
                        {getRoleBadge(getUserRole(user))}
                      </div>
                      {isCurrentUser && (
                        <Badge variant="outline" className="mt-1 text-xs">Bạn</Badge>
                      )}
                    </div>
                  </div>

                  {/* Contact info */}
                  <div className="space-y-1 text-sm border-t pt-2">
                    {getUserPhone(user) && (
                      <div className="flex items-center gap-2 text-gray-600">
                        <Phone className="h-3 w-3" />
                        <span>{getUserPhone(user)}</span>
                      </div>
                    )}
                    <div className="flex items-center gap-2 text-gray-500 text-xs">
                      <Calendar className="h-3 w-3" />
                      <span>Tham gia: {new Date(user.createdAt).toLocaleDateString('vi-VN')}</span>
                    </div>
                  </div>

                  {/* Status */}
                  <div className="border-t pt-2">
                    <Badge variant={getUserIsActive(user) ? "default" : "secondary"} className="text-xs">
                      {getUserIsActive(user) ? 'Hoạt động' : 'Ngừng hoạt động'}
                    </Badge>
                  </div>

                  {/* Action buttons */}
                  {!isCurrentUser && (
                    <div className="flex gap-2 pt-2 border-t">
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={() => openEditDialog(user)}
                        className="flex-1"
                      >
                        <Edit className="h-3.5 w-3.5 mr-1" />
                        Sửa
                      </Button>
                      <Button
                        variant="outline"
                        size="sm"
                        onClick={() => handleDeleteUser(user._id)}
                        className="flex-1 text-red-600 hover:bg-red-50"
                      >
                        <Trash2 className="h-3.5 w-3.5 mr-1" />
                        Xóa
                      </Button>
                    </div>
                  )}
                </div>
              </Card>
            );
          })}
        </div>

        {filteredUsers.length === 0 && (
          <div className="text-center py-8">
            <Users className="h-12 w-12 text-gray-300 mx-auto mb-4" />
            <p className="text-gray-500">Không có người dùng nào</p>
          </div>
        )}
      </div>

      {/* Edit User Dialog */}
      <Dialog open={isEditDialogOpen} onOpenChange={setIsEditDialogOpen}>
        <DialogContent className="w-[95vw] sm:w-full sm:max-w-[425px]">
          <DialogHeader>
            <DialogTitle className="text-base md:text-lg">Chỉnh sửa tài khoản</DialogTitle>
            <DialogDescription className="text-xs md:text-sm">
              Cập nhật thông tin tài khoản người dùng
            </DialogDescription>
          </DialogHeader>
          <div className="grid gap-3 md:gap-4 py-4">
            <div className="space-y-2">
              <Label htmlFor="edit-name" className="text-xs md:text-sm">Họ và tên</Label>
              <Input
                id="edit-name"
                value={editUserData.name}
                onChange={(e) => setEditUserData({ ...editUserData, name: e.target.value })}
                placeholder="Nhập họ và tên"
                className="text-sm"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="edit-phone" className="text-xs md:text-sm">Số điện thoại</Label>
              <Input
                id="edit-phone"
                value={editUserData.phone}
                onChange={(e) => setEditUserData({ ...editUserData, phone: e.target.value })}
                placeholder="Nhập số điện thoại"
                className="text-sm"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="edit-role" className="text-xs md:text-sm">Vai trò</Label>
              <Select value={editUserData.role} onValueChange={(value) => setEditUserData({ ...editUserData, role: value })}>
                <SelectTrigger className="text-sm">
                  <SelectValue placeholder="Chọn vai trò" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="admin" className="text-sm">Quản trị viên</SelectItem>
                  <SelectItem value="tenant" className="text-sm">Khách thuê</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          <DialogFooter className="flex-col sm:flex-row gap-2">
            <Button variant="outline" size="sm" onClick={() => setIsEditDialogOpen(false)} className="w-full sm:w-auto">
              Hủy
            </Button>
            <Button size="sm" onClick={handleEditUser} className="w-full sm:w-auto">
              Cập nhật
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
      
      <ConfirmActionDialog
        open={isConfirmOpen}
        onOpenChange={setIsConfirmOpen}
        title="Xác nhận xóa tài khoản"
        description="Bạn có chắc chắn muốn xóa tài khoản này? Thao tác này không thể hoàn tác."
        confirmText="Xóa"
        variant="destructive"
        loading={isDeleting}
        onConfirm={confirmDeleteUser}
      />
    </div>
  );
}
