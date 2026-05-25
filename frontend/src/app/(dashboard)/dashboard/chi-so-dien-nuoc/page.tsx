'use client';

import { useState, useEffect, useCallback } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Plus, Pencil, Trash2, Search, Loader2, Image as ImageIcon } from 'lucide-react';
import { toast } from 'sonner';
import { ChiSoDienNuoc, LoaiChiSo, TrangThaiChiSo } from '@/types';
import { ImageUpload } from '@/components/ui/image-upload';

export default function ChiSoDienNuocPage() {
  const [data, setData] = useState<ChiSoDienNuoc[]>([]);
  const [loading, setLoading] = useState(true);
  const [phongList, setPhongList] = useState<any[]>([]);

  // Dialog state
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);

  // Form state
  const [formData, setFormData] = useState({
    phongId: '',
    loai: 'ELECTRICITY' as LoaiChiSo,
    kyNam: new Date().getFullYear(),
    kyThang: new Date().getMonth() + 1,
    ngayGhi: new Date().toISOString().split('T')[0],
    chiSoCu: 0,
    chiSoMoi: 0,
    trangThai: 'DRAFT' as TrangThaiChiSo,
    ghiChu: '',
    anhDongHo: '',
  });

  const fetchData = useCallback(async () => {
    try {
      setLoading(true);
      const res = await fetch('/api/chi-so-dien-nuoc');
      if (!res.ok) throw new Error('Không thể tải dữ liệu chỉ số');
      const json = await res.json();
      setData(json.data || []);
    } catch (error: any) {
      toast.error(error.message || 'Không thể tải dữ liệu chỉ số');
    } finally {
      setLoading(false);
    }
  }, []);

  const fetchPhong = useCallback(async () => {
    try {
      const res = await fetch('/api/phong');
      if (res.ok) {
        const json = await res.json();
        setPhongList(json.data || []);
      }
    } catch (error) {
      console.error('Failed to fetch phong', error);
    }
  }, []);

  useEffect(() => {
    fetchData();
    fetchPhong();
  }, [fetchData, fetchPhong]);

  const handleOpenDialog = (item?: ChiSoDienNuoc) => {
    if (item) {
      setEditingId(item._id || item.id || null);
      setFormData({
        phongId: (item.phong as any)?._id || (item.phong as any)?.id || item.phong || '',
        loai: item.loai || 'ELECTRICITY',
        kyNam: item.kyNam || new Date().getFullYear(),
        kyThang: item.kyThang || new Date().getMonth() + 1,
        ngayGhi: item.ngayGhi ? new Date(item.ngayGhi).toISOString().split('T')[0] : new Date().toISOString().split('T')[0],
        chiSoCu: item.chiSoCu || 0,
        chiSoMoi: item.chiSoMoi || 0,
        trangThai: item.trangThai || 'DRAFT',
        ghiChu: item.ghiChu || '',
        anhDongHo: item.anhDongHo || '',
      });
    } else {
      setEditingId(null);
      setFormData({
        phongId: '',
        loai: 'ELECTRICITY',
        kyNam: new Date().getFullYear(),
        kyThang: new Date().getMonth() + 1,
        ngayGhi: new Date().toISOString().split('T')[0],
        chiSoCu: 0,
        chiSoMoi: 0,
        trangThai: 'DRAFT',
        ghiChu: '',
        anhDongHo: '',
      });
    }
    setIsDialogOpen(true);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (formData.chiSoMoi < formData.chiSoCu) {
      toast.error('Chỉ số mới không được nhỏ hơn chỉ số cũ');
      return;
    }
    
    if (!formData.phongId) {
      toast.error('Vui lòng chọn phòng');
      return;
    }

    try {
      setIsSubmitting(true);
      const url = editingId ? `/api/chi-so-dien-nuoc/${editingId}` : '/api/chi-so-dien-nuoc';
      const method = editingId ? 'PUT' : 'POST';

      const res = await fetch(url, {
        method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData),
      });

      if (!res.ok) {
        const errorData = await res.json();
        throw new Error(errorData.message || 'Lưu thất bại');
      }

      toast.success(editingId ? 'Cập nhật chỉ số thành công' : 'Thêm mới chỉ số thành công');
      
      setIsDialogOpen(false);
      fetchData();
    } catch (error: any) {
      toast.error(error.message || 'Lưu thất bại');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Bạn có chắc chắn muốn xóa chỉ số này?')) return;
    
    try {
      const res = await fetch(`/api/chi-so-dien-nuoc/${id}`, { method: 'DELETE' });
      if (!res.ok) throw new Error('Xóa thất bại');
      
      toast.success('Đã xóa chỉ số');
      fetchData();
    } catch (error: any) {
      toast.error(error.message || 'Xóa thất bại');
    }
  };

  const getTrangThaiBadge = (status: TrangThaiChiSo) => {
    switch (status) {
      case 'DRAFT': return <Badge variant="outline">Bản nháp</Badge>;
      case 'CONFIRMED': return <Badge className="bg-blue-500 hover:bg-blue-600">Đã chốt</Badge>;
      case 'BILLED': return <Badge className="bg-green-500 hover:bg-green-600">Đã lên hóa đơn</Badge>;
      case 'CANCELLED': return <Badge variant="destructive">Đã hủy</Badge>;
      default: return <Badge variant="secondary">{status}</Badge>;
    }
  };

  return (
    <div className="flex flex-col gap-6 p-6 max-w-7xl mx-auto w-full">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Chốt chỉ số điện nước</h1>
          <p className="text-muted-foreground mt-2">
            Ghi nhận và quản lý chỉ số tiêu thụ hàng tháng của các phòng
          </p>
        </div>
        
        <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
          <DialogTrigger asChild>
            <Button onClick={() => handleOpenDialog()}>
              <Plus className="mr-2 h-4 w-4" />
              Ghi chỉ số mới
            </Button>
          </DialogTrigger>
          <DialogContent className="sm:max-w-[600px]">
            <DialogHeader>
              <DialogTitle>{editingId ? 'Cập nhật chỉ số' : 'Ghi chỉ số mới'}</DialogTitle>
              <DialogDescription>
                Nhập thông tin chỉ số điện nước cho kỳ thanh toán.
              </DialogDescription>
            </DialogHeader>
            
            <form onSubmit={handleSubmit} className="space-y-4 py-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <label className="text-sm font-medium">Phòng</label>
                  <Select 
                    value={formData.phongId} 
                    onValueChange={(v) => setFormData({...formData, phongId: v})}
                  >
                    <SelectTrigger>
                      <SelectValue placeholder="Chọn phòng" />
                    </SelectTrigger>
                    <SelectContent>
                      {phongList.map(p => (
                        <SelectItem key={p._id || p.id} value={p._id || p.id}>
                          {p.maPhong || p.ten}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
                
                <div className="space-y-2">
                  <label className="text-sm font-medium">Loại chỉ số</label>
                  <Select 
                    value={formData.loai} 
                    onValueChange={(v: LoaiChiSo) => setFormData({...formData, loai: v})}
                  >
                    <SelectTrigger>
                      <SelectValue placeholder="Loại" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="ELECTRICITY">Điện</SelectItem>
                      <SelectItem value="WATER">Nước</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                
                <div className="space-y-2">
                  <label className="text-sm font-medium">Kỳ (Tháng)</label>
                  <Input 
                    type="number" 
                    min={1} max={12}
                    value={formData.kyThang} 
                    onChange={e => setFormData({...formData, kyThang: parseInt(e.target.value) || 1})} 
                  />
                </div>
                
                <div className="space-y-2">
                  <label className="text-sm font-medium">Năm</label>
                  <Input 
                    type="number" 
                    min={2000}
                    value={formData.kyNam} 
                    onChange={e => setFormData({...formData, kyNam: parseInt(e.target.value) || 2024})} 
                  />
                </div>
                
                <div className="space-y-2">
                  <label className="text-sm font-medium">Chỉ số cũ</label>
                  <Input 
                    type="number" 
                    min={0}
                    value={formData.chiSoCu} 
                    onChange={e => setFormData({...formData, chiSoCu: parseInt(e.target.value) || 0})} 
                  />
                </div>
                
                <div className="space-y-2">
                  <label className="text-sm font-medium">Chỉ số mới</label>
                  <Input 
                    type="number" 
                    min={0}
                    value={formData.chiSoMoi} 
                    onChange={e => setFormData({...formData, chiSoMoi: parseInt(e.target.value) || 0})} 
                  />
                </div>
                
                <div className="space-y-2">
                  <label className="text-sm font-medium">Tiêu thụ (Tự tính)</label>
                  <Input 
                    type="number" 
                    disabled
                    value={Math.max(0, formData.chiSoMoi - formData.chiSoCu)} 
                  />
                </div>

                <div className="space-y-2">
                  <label className="text-sm font-medium">Trạng thái</label>
                  <Select 
                    value={formData.trangThai} 
                    onValueChange={(v: TrangThaiChiSo) => setFormData({...formData, trangThai: v})}
                  >
                    <SelectTrigger>
                      <SelectValue placeholder="Trạng thái" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="DRAFT">Bản nháp</SelectItem>
                      <SelectItem value="CONFIRMED">Đã chốt</SelectItem>
                      <SelectItem value="BILLED">Đã lên hóa đơn</SelectItem>
                      <SelectItem value="CANCELLED">Đã hủy</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>
              
              <div className="space-y-2">
                <label className="text-sm font-medium">Ngày ghi</label>
                <Input 
                  type="date" 
                  value={formData.ngayGhi} 
                  onChange={e => setFormData({...formData, ngayGhi: e.target.value})} 
                />
              </div>
              
              <div className="space-y-2">
                <label className="text-sm font-medium">Ghi chú</label>
                <Input 
                  value={formData.ghiChu} 
                  onChange={e => setFormData({...formData, ghiChu: e.target.value})} 
                  placeholder="Ghi chú thêm..."
                />
              </div>

              <div className="space-y-2">
                <ImageUpload
                  imageUrl={formData.anhDongHo}
                  onImageChange={url => setFormData({...formData, anhDongHo: url})}
                  label={formData.loai === 'ELECTRICITY' ? 'Ảnh đồng hồ điện' : 'Ảnh đồng hồ nước'}
                  placeholder="Chọn ảnh đồng hồ"
                />
              </div>
              
              <DialogFooter className="pt-4">
                <Button type="button" variant="outline" onClick={() => setIsDialogOpen(false)}>
                  Hủy
                </Button>
                <Button type="submit" disabled={isSubmitting}>
                  {isSubmitting && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                  {editingId ? 'Lưu thay đổi' : 'Thêm chỉ số'}
                </Button>
              </DialogFooter>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <Card>
        <CardHeader className="pb-3">
          <CardTitle>Danh sách chỉ số</CardTitle>
          <CardDescription>Tổng quan các chỉ số điện nước đã ghi</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="rounded-md border">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Kỳ</TableHead>
                  <TableHead>Phòng</TableHead>
                  <TableHead>Loại</TableHead>
                  <TableHead className="text-right">CS Cũ</TableHead>
                  <TableHead className="text-right">CS Mới</TableHead>
                  <TableHead className="text-right">Tiêu thụ</TableHead>
                  <TableHead className="text-center">Ảnh</TableHead>
                  <TableHead>Trạng thái</TableHead>
                  <TableHead className="text-right">Thao tác</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {loading ? (
                  <TableRow>
                    <TableCell colSpan={9} className="h-24 text-center">
                      <Loader2 className="mx-auto h-6 w-6 animate-spin text-muted-foreground" />
                    </TableCell>
                  </TableRow>
                ) : data.length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={9} className="h-24 text-center">
                      Chưa có dữ liệu chỉ số nào.
                    </TableCell>
                  </TableRow>
                ) : (
                  data.map((item) => (
                    <TableRow key={item._id || item.id}>
                      <TableCell className="font-medium">
                        {item.kyThang}/{item.kyNam}
                      </TableCell>
                      <TableCell>
                        {(item.phong as any)?.maPhong || (item.phong as any)?.ten || 'N/A'}
                      </TableCell>
                      <TableCell>
                        {item.loai === 'ELECTRICITY' ? 'Điện' : 'Nước'}
                      </TableCell>
                      <TableCell className="text-right">{item.chiSoCu}</TableCell>
                      <TableCell className="text-right font-medium">{item.chiSoMoi}</TableCell>
                      <TableCell className="text-right font-bold text-primary">
                        {item.tieuThu || (item.chiSoMoi && item.chiSoCu ? item.chiSoMoi - item.chiSoCu : 0)}
                      </TableCell>
                      <TableCell className="text-center">
                        {item.anhDongHo ? (
                          <a 
                            href={item.anhDongHo} 
                            target="_blank" 
                            rel="noopener noreferrer" 
                            className="inline-flex items-center justify-center text-blue-500 hover:text-blue-600 hover:underline gap-1 text-sm font-medium"
                          >
                            <ImageIcon className="h-4 w-4" />
                            Xem ảnh
                          </a>
                        ) : (
                          <span className="text-muted-foreground text-xs">Không có</span>
                        )}
                      </TableCell>
                      <TableCell>
                        {getTrangThaiBadge(item.trangThai || 'DRAFT')}
                      </TableCell>
                      <TableCell className="text-right">
                        <Button 
                          variant="ghost" 
                          size="icon" 
                          onClick={() => handleOpenDialog(item)}
                          disabled={item.trangThai === 'BILLED'}
                        >
                          <Pencil className="h-4 w-4" />
                        </Button>
                        <Button 
                          variant="ghost" 
                          size="icon" 
                          className="text-red-500 hover:text-red-600 hover:bg-red-50"
                          onClick={() => handleDelete(item._id || item.id as string)}
                          disabled={item.trangThai === 'BILLED'}
                        >
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </TableCell>
                    </TableRow>
                  ))
                )}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
