'use client';

import { useState } from 'react';
import useSWR from 'swr';
import { useSession } from 'next-auth/react';
import { Edit, Plus, Trash2 } from 'lucide-react';
import { toast } from 'sonner';

import { Button } from '@/components/ui/button';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import type { TaiSanPhong } from '@/types';

function formatCurrency(value?: number) {
  if (value == null) return '0 đ';
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', maximumFractionDigits: 0 }).format(value);
}

export function TaiSanSection({ phongId }: { phongId: string }) {
  const { data: session } = useSession();
  const accessToken = session?.accessToken;

  const fetcher = async (url: string) => {
    const res = await fetch(url, {
      headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
    });
    const json = await res.json();
    return json.success ? json.data : [];
  };

  const { data: taiSanList, mutate, isLoading } = useSWR<TaiSanPhong[]>(
    phongId ? `/api/tai-san-phong/phong/${phongId}` : null,
    fetcher
  );

  const [isFormOpen, setIsFormOpen] = useState(false);
  const [editingItem, setEditingItem] = useState<TaiSanPhong | null>(null);
  const [formData, setFormData] = useState({
    tenTaiSan: '',
    soLuong: 1,
    giaTri: 0,
    tinhTrang: 'Mới',
    ghiChu: '',
  });

  const handleOpenAdd = () => {
    setEditingItem(null);
    setFormData({ tenTaiSan: '', soLuong: 1, giaTri: 0, tinhTrang: 'Mới', ghiChu: '' });
    setIsFormOpen(true);
  };

  const handleOpenEdit = (item: TaiSanPhong) => {
    setEditingItem(item);
    setFormData({
      tenTaiSan: item.tenTaiSan || '',
      soLuong: item.soLuong || 1,
      giaTri: item.giaTri || 0,
      tinhTrang: item.tinhTrang || 'Mới',
      ghiChu: item.ghiChu || '',
    });
    setIsFormOpen(true);
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Bạn có chắc chắn muốn xóa tài sản này?')) return;
    try {
      const res = await fetch(`/api/tai-san-phong/${id}`, {
        method: 'DELETE',
        headers: {
          Authorization: `Bearer ${accessToken}`,
        },
      });
      const result = await res.json();
      if (result.success) {
        toast.success('Đã xóa tài sản');
        mutate();
      } else {
        toast.error(result.error || 'Lỗi khi xóa tài sản');
      }
    } catch (err) {
      toast.error('Có lỗi xảy ra');
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.tenTaiSan) {
      toast.error('Vui lòng nhập tên tài sản');
      return;
    }

    try {
      let res;
      if (editingItem) {
        res = await fetch(`/api/tai-san-phong/${editingItem.id || editingItem._id}`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${accessToken}`,
          },
          body: JSON.stringify(formData),
        });
      } else {
        res = await fetch(`/api/tai-san-phong/phong/${phongId}`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${accessToken}`,
          },
          body: JSON.stringify({ ...formData, phongId }),
        });
      }

      const result = await res.json();
      if (result.success) {
        toast.success(editingItem ? 'Cập nhật thành công' : 'Thêm tài sản thành công');
        setIsFormOpen(false);
        mutate();
      } else {
        toast.error(result.error || 'Lỗi khi lưu tài sản');
      }
    } catch (err) {
      toast.error('Có lỗi xảy ra khi lưu tài sản');
    }
  };

  return (
    <div className="pb-4">
      <div className="flex items-center justify-between mb-3">
        <h3 className="text-sm font-bold text-gray-800">Tài sản</h3>
        <Button onClick={handleOpenAdd} size="sm" variant="outline" className="h-8 rounded-md text-[#4FA7A0] border-[#4FA7A0]/30 hover:bg-[#4FA7A0]/10">
          <Plus className="w-3.5 h-3.5 mr-1" />
          Thêm tài sản
        </Button>
      </div>

      <div className="border rounded-md overflow-hidden overflow-x-auto">
        <table className="w-full text-sm text-left">
          <thead className="bg-[#FAFAFA] border-b border-gray-200 text-gray-700">
            <tr>
              <th className="px-4 py-3 border-r border-gray-100 font-medium">Mã TS</th>
              <th className="px-4 py-3 border-r border-gray-100 font-medium">Tên TS</th>
              <th className="px-4 py-3 border-r border-gray-100 font-medium">Số lượng</th>
              <th className="px-4 py-3 border-r border-gray-100 font-medium">Giá trị</th>
              <th className="px-4 py-3 border-r border-gray-100 font-medium">Tình trạng</th>
              <th className="px-4 py-3 font-medium text-right">Thao tác</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-200">
            {isLoading ? (
              <tr>
                <td colSpan={6} className="px-4 py-6 text-center text-gray-500 bg-white">Đang tải...</td>
              </tr>
            ) : taiSanList && taiSanList.length > 0 ? (
              taiSanList.map((ts) => {
                const tsId = ts.id || ts._id;
                // Generate a pseudo-code for UI based on short ID
                const maTs = 'TS' + (tsId || '').substring(0, 6).toUpperCase();
                return (
                  <tr key={String(tsId)} className="bg-white hover:bg-gray-50/50">
                    <td className="px-4 py-3 border-r border-gray-100 text-gray-900">{maTs}</td>
                    <td className="px-4 py-3 border-r border-gray-100 text-gray-900 font-medium">{ts.tenTaiSan}</td>
                    <td className="px-4 py-3 border-r border-gray-100 text-gray-900">{ts.soLuong}</td>
                    <td className="px-4 py-3 border-r border-gray-100 text-gray-900 text-[#E76F51]">{formatCurrency(ts.giaTri)}</td>
                    <td className="px-4 py-3 border-r border-gray-100 text-gray-900">
                      <span className="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-gray-100 text-gray-800">
                        {ts.tinhTrang}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-right">
                      <div className="flex items-center justify-end gap-2">
                        <button
                          onClick={() => handleOpenEdit(ts)}
                          className="p-1.5 text-gray-500 hover:text-[#4FA7A0] hover:bg-[#4FA7A0]/10 rounded transition-colors"
                          title="Sửa"
                        >
                          <Edit className="w-4 h-4" />
                        </button>
                        <button
                          onClick={() => handleDelete(String(tsId))}
                          className="p-1.5 text-gray-500 hover:text-red-600 hover:bg-red-50 rounded transition-colors"
                          title="Xóa"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                );
              })
            ) : (
              <tr>
                <td colSpan={6} className="px-4 py-6 text-center text-gray-500 bg-white">Không có tài sản nào</td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      <Dialog open={isFormOpen} onOpenChange={setIsFormOpen}>
        <DialogContent className="sm:max-w-[500px]">
          <DialogHeader>
            <DialogTitle>{editingItem ? 'Sửa tài sản' : 'Thêm tài sản mới'}</DialogTitle>
          </DialogHeader>
          
          <form onSubmit={handleSubmit} className="space-y-4 mt-4">
            <div className="space-y-2">
              <Label htmlFor="tenTaiSan">Tên tài sản <span className="text-red-500">*</span></Label>
              <Input
                id="tenTaiSan"
                value={formData.tenTaiSan}
                onChange={(e) => setFormData({ ...formData, tenTaiSan: e.target.value })}
                placeholder="VD: Tủ lạnh, Máy giặt..."
              />
            </div>
            
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="soLuong">Số lượng</Label>
                <Input
                  id="soLuong"
                  type="number"
                  min="1"
                  value={formData.soLuong}
                  onChange={(e) => setFormData({ ...formData, soLuong: parseInt(e.target.value) || 1 })}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="giaTri">Giá trị (VNĐ)</Label>
                <Input
                  id="giaTri"
                  type="number"
                  min="0"
                  value={formData.giaTri}
                  onChange={(e) => setFormData({ ...formData, giaTri: parseInt(e.target.value) || 0 })}
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label>Tình trạng</Label>
              <Select value={formData.tinhTrang} onValueChange={(val) => setFormData({ ...formData, tinhTrang: val })}>
                <SelectTrigger>
                  <SelectValue placeholder="Chọn tình trạng" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="Mới">Mới</SelectItem>
                  <SelectItem value="Tốt">Tốt</SelectItem>
                  <SelectItem value="Bình thường">Bình thường</SelectItem>
                  <SelectItem value="Cũ">Cũ</SelectItem>
                  <SelectItem value="Hư hỏng">Hư hỏng</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="ghiChu">Ghi chú</Label>
              <Textarea
                id="ghiChu"
                value={formData.ghiChu}
                onChange={(e) => setFormData({ ...formData, ghiChu: e.target.value })}
                placeholder="Ghi chú thêm về tài sản..."
                rows={3}
              />
            </div>

            <div className="flex justify-end gap-3 pt-4">
              <Button type="button" variant="outline" onClick={() => setIsFormOpen(false)}>
                Hủy
              </Button>
              <Button type="submit" className="bg-[#243B5A] text-white hover:bg-[#1D314D]">
                {editingItem ? 'Lưu thay đổi' : 'Thêm tài sản'}
              </Button>
            </div>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  );
}
