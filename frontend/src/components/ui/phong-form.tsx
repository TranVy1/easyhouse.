'use client';

import { useState, useEffect } from 'react';
import { useSession } from 'next-auth/react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { DialogFooter } from '@/components/ui/dialog';
import { Info, Image as ImageIcon } from 'lucide-react';
import { toast } from 'sonner';
import { PhongImageUpload } from '@/components/ui/phong-image-upload';
import type { Phong, ToaNha } from '@/types';
import Image from 'next/image';

const mapTrangThai = (tt: string): 'trong' | 'daDat' | 'dangThue' | 'baoTri' => {
  if (!tt) return 'trong';
  if (tt === 'AVAILABLE') return 'trong';
  if (tt === 'RESERVED') return 'daDat';
  if (tt === 'RENTED') return 'dangThue';
  if (tt === 'MAINTENANCE') return 'baoTri';
  if (tt === 'INACTIVE') return 'baoTri';
  if (['trong', 'daDat', 'dangThue', 'baoTri'].includes(tt)) return tt as 'trong' | 'daDat' | 'dangThue' | 'baoTri';
  return 'trong';
};

// Form component for adding/editing phong
export function PhongForm({
  phong,
  toaNhaList,
  onClose,
  onSuccess
}: {
  phong: Phong | null;
  toaNhaList: ToaNha[];
  onClose: () => void;
  onSuccess: () => void;
}) {
  const accessToken = useSession()?.data?.accessToken;
  // Helper function để lấy toaNha ID
  const getToaNhaId = (toaNha: string | { _id: string }) => {
    if (typeof toaNha === 'object' && toaNha !== null) {
      return toaNha._id || '';
    } else if (typeof toaNha === 'string') {
      return toaNha;
    }
    return '';
  };

  const [tangList, setTangList] = useState<{soTang: number, tenTang: string}[]>([]);
  const [formData, setFormData] = useState({
    maPhong: phong?.maPhong || '',
    toaNha: phong?.toaNha ? getToaNhaId(phong.toaNha) : '',
    tang: phong?.tang || 1,
    dienTich: phong?.dienTich || 0,
    giaThue: phong?.giaThue || 0,
    tienCoc: phong?.tienCoc || 0,
    moTa: phong?.moTa || '',
    anhPhong: phong?.anhPhong || [],
    tienNghi: phong?.tienNghi || [],
    soNguoiToiDa: phong?.soNguoiToiDa || 1,
    trangThai: phong ? mapTrangThai(phong.trangThai) : 'trong',
  });

  
  // Fetch floors when toaNha changes
  useEffect(() => {
    if (formData.toaNha) {
      fetch(`/api/toa-nha/${formData.toaNha}/tang`, {
        headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : {},
      })
        .then(res => res.json())
        .then(result => {
          if (result.success && Array.isArray(result.data)) {
            // Sort by soTang
            const sorted = result.data.sort((a: any, b: any) => a.soTang - b.soTang);
            setTangList(sorted);
            
            // If current tang is not in the list and we have floors, maybe select the first one, 
            // but let's keep it if we are editing to not overwrite
            if (!phong && sorted.length > 0) {
              setFormData(prev => ({ ...prev, tang: sorted[0].soTang }));
            }
          }
        })
        .catch(console.error);
    } else {
      setTangList([]);
    }
  }, [formData.toaNha, accessToken, phong]);

  // Cập nhật formData khi phong thay đổi
  useEffect(() => {
    if (phong) {
      const toaNhaId = getToaNhaId(phong.toaNha);

      console.log('Editing phong:', phong);
      console.log('toaNha object:', phong.toaNha);
      console.log('toaNha ID:', toaNhaId);

      setFormData({
        maPhong: phong.maPhong || '',
        toaNha: toaNhaId,
        tang: phong.tang || 1,
        dienTich: phong.dienTich || 0,
        giaThue: phong.giaThue || 0,
        tienCoc: phong.tienCoc || 0,
        moTa: phong.moTa || '',
        anhPhong: phong.anhPhong || [],
        tienNghi: phong.tienNghi || [],
        soNguoiToiDa: phong.soNguoiToiDa || 1,
        trangThai: mapTrangThai(phong.trangThai),
      });
    } else {
      setFormData({
        maPhong: '',
        toaNha: '',
        tang: 1,
        dienTich: 0,
        giaThue: 0,
        tienCoc: 0,
        moTa: '',
        anhPhong: [],
        tienNghi: [],
        soNguoiToiDa: 1,
        trangThai: 'trong',
      });
    }
  }, [phong]);

  // Function format tiền
  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND'
    }).format(amount);
  };

  const tienNghiOptions = [
    { value: 'dieuhoa', label: 'Điều hòa' },
    { value: 'nonglanh', label: 'Nóng lạnh' },
    { value: 'tulanh', label: 'Tủ lạnh' },
    { value: 'giuong', label: 'Giường' },
    { value: 'tuquanao', label: 'Tủ quần áo' },
    { value: 'banlamviec', label: 'Bàn làm việc' },
    { value: 'ghe', label: 'Ghế' },
    { value: 'tivi', label: 'TV' },
    { value: 'wifi', label: 'WiFi' },
    { value: 'maygiat', label: 'Máy giặt' },
    { value: 'bep', label: 'Bếp' },
    { value: 'noi', label: 'Nồi' },
    { value: 'chen', label: 'Chén' },
    { value: 'bat', label: 'Bát' },
  ];

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
      const url = phong ? `/api/phong/${phong._id}` : '/api/phong';
      const method = phong ? 'PUT' : 'POST';

      const payload = {
        ten: formData.maPhong,
        nhaTroId: formData.toaNha,
        khuVuc: '', // Có thể thêm sau nếu cần
        tang: formData.tang,
        dienTich: formData.dienTich,
        giaHienTai: formData.giaThue,
        tienCocMacDinh: formData.tienCoc,
        soNguoiToiDa: formData.soNguoiToiDa,
        trangThai: formData.trangThai,
        moTa: formData.moTa,
        anhPhong: formData.anhPhong,
        tienNghi: formData.tienNghi
      };

      const response = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
          ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
        },
        body: JSON.stringify(payload),
      });

      if (response.ok) {
        const result = await response.json();
        if (result.success) {
          onSuccess();
        } else {
          toast.error(result.message || 'Có lỗi xảy ra');
        }
      } else {
        const error = await response.json();
        toast.error(error.message || 'Có lỗi xảy ra');
      }
    } catch (error) {
      console.error('Error submitting form:', error);
      toast.error('Có lỗi xảy ra khi gửi form');
    }
  };

  const handleTienNghiChange = (tienNghi: string, checked: boolean) => {
    setFormData(prev => ({
      ...prev,
      tienNghi: checked
        ? [...prev.tienNghi, tienNghi]
        : prev.tienNghi.filter(t => t !== tienNghi)
    }));
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4 md:space-y-6">
      <Tabs defaultValue="thong-tin" className="w-full">
        <TabsList className="grid w-full grid-cols-2">
          <TabsTrigger value="thong-tin" className="flex items-center gap-1 md:gap-2 text-xs md:text-sm">
            <Info className="h-3 w-3 md:h-4 md:w-4" />
            Thông tin
          </TabsTrigger>
          <TabsTrigger value="anh-phong" className="flex items-center gap-1 md:gap-2 text-xs md:text-sm">
            <ImageIcon className="h-3 w-3 md:h-4 md:w-4" />
            Ảnh phòng
          </TabsTrigger>
        </TabsList>

        <TabsContent value="thong-tin" className="space-y-4 md:space-y-6 mt-4 md:mt-6">
          {/* Thông tin cơ bản */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-3 md:gap-4">
            <div className="space-y-2">
              <Label htmlFor="maPhong" className="text-sm">Mã phòng</Label>
              <Input
                id="maPhong"
                value={formData.maPhong}
                onChange={(e) => setFormData(prev => ({ ...prev, maPhong: e.target.value.toUpperCase() }))}
                required
                className="text-sm"
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="toaNha" className="text-sm">Tòa nhà</Label>
              <Select value={formData.toaNha} onValueChange={(value) => setFormData(prev => ({ ...prev, toaNha: value }))}>
                <SelectTrigger className="text-sm">
                  <SelectValue placeholder="Chọn tòa nhà" />
                </SelectTrigger>
                <SelectContent>
                  {toaNhaList.map((toaNha) => (
                    <SelectItem key={toaNha._id} value={toaNha._id!} className="text-sm">
                      {toaNha.tenToaNha}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="trangThai" className="text-sm">Trạng thái</Label>
              <Select value={formData.trangThai} onValueChange={(value) => setFormData(prev => ({ ...prev, trangThai: value as 'trong' | 'daDat' | 'dangThue' | 'baoTri' }))}>
                <SelectTrigger className="text-sm">
                  <SelectValue placeholder="Chọn trạng thái" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="trong" className="text-sm">Trống</SelectItem>
                  <SelectItem value="daDat" className="text-sm">Đã đặt</SelectItem>
                  <SelectItem value="dangThue" className="text-sm">Đang thuê</SelectItem>
                  <SelectItem value="baoTri" className="text-sm">Bảo trì</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          {/* Thông tin phòng */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3 md:gap-4">
            <div className="space-y-2">
              <Label htmlFor="tang" className="text-sm">Tầng</Label>
              <Select value={formData.tang.toString()} onValueChange={(value) => setFormData(prev => ({ ...prev, tang: parseInt(value) }))}>
                <SelectTrigger className="text-sm">
                  <SelectValue placeholder="Chọn tầng" />
                </SelectTrigger>
                <SelectContent className="max-h-[200px]">
                  {tangList.length > 0 ? tangList.map((t) => (
                    <SelectItem key={t.soTang} value={t.soTang.toString()} className="text-sm">
                      {t.tenTang || `Tầng ${t.soTang}`}
                    </SelectItem>
                  )) : (
                    <SelectItem value={formData.tang.toString()} className="text-sm">Tầng {formData.tang}</SelectItem>
                  )}
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="dienTich" className="text-sm">Diện tích (m²)</Label>
              <Input
                id="dienTich"
                type="number"
                min="1"
                value={formData.dienTich}
                onChange={(e) => setFormData(prev => ({ ...prev, dienTich: parseInt(e.target.value) || 0 }))}
                required
                className="text-sm"
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="soNguoiToiDa" className="text-sm">Số người tối đa</Label>
              <Input
                id="soNguoiToiDa"
                type="number"
                min="1"
                max="10"
                value={formData.soNguoiToiDa}
                onChange={(e) => setFormData(prev => ({ ...prev, soNguoiToiDa: parseInt(e.target.value) || 1 }))}
                required
                className="text-sm"
              />
            </div>

            <div className="space-y-2 col-span-2 md:col-span-1">
              <Label className="text-sm">Preview</Label>
              <div className="h-10 bg-gray-50 border rounded-md flex items-center justify-center text-xs md:text-sm text-gray-500">
                Phòng {formData.maPhong || 'XXX'} - Tầng {formData.tang}
              </div>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-3 md:gap-4">
            <div className="space-y-2">
              <Label htmlFor="giaThue" className="text-sm">Giá thuê (VNĐ)</Label>
              <Input
                id="giaThue"
                type="number"
                min="0"
                value={formData.giaThue}
                onChange={(e) => setFormData(prev => ({ ...prev, giaThue: parseInt(e.target.value) || 0 }))}
                required
                className="text-sm"
              />
              <span className="text-xs md:text-sm text-gray-500 font-medium">
                {formatCurrency(formData.giaThue)}
              </span>
            </div>

            <div className="space-y-2">
              <Label htmlFor="tienCoc" className="text-sm">Tiền cọc (VNĐ)</Label>
              <Input
                id="tienCoc"
                type="number"
                min="0"
                value={formData.tienCoc}
                onChange={(e) => setFormData(prev => ({ ...prev, tienCoc: parseInt(e.target.value) || 0 }))}
                required
                className="text-sm"
              />
              <span className="text-xs md:text-sm text-gray-500 font-medium">
                {formatCurrency(formData.tienCoc)}
              </span>
            </div>
          </div>

          <div className="space-y-2">
            <Label htmlFor="moTa" className="text-sm">Mô tả</Label>
            <Textarea
              id="moTa"
              value={formData.moTa}
              onChange={(e) => setFormData(prev => ({ ...prev, moTa: e.target.value }))}
              rows={3}
              className="text-sm"
            />
          </div>

          <div className="space-y-2">
            <Label className="text-sm font-semibold text-gray-700">Tiện nghi</Label>
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-3 md:gap-4 bg-gray-50/50 p-4 border border-dashed rounded-lg">
              {tienNghiOptions.map((option) => (
                <div key={option.value} className="flex items-center space-x-2.5 py-1">
                  <input
                    type="checkbox"
                    id={option.value}
                    checked={formData.tienNghi.includes(option.value)}
                    onChange={(e) => handleTienNghiChange(option.value, e.target.checked)}
                    className="rounded border-gray-300 h-4 w-4 accent-blue-600 cursor-pointer"
                  />
                  <Label htmlFor={option.value} className="text-sm font-medium text-gray-600 hover:text-gray-900 cursor-pointer select-none">
                    {option.label}
                  </Label>
                </div>
              ))}
            </div>
          </div>
        </TabsContent>

        <TabsContent value="anh-phong" className="space-y-4 md:space-y-6 mt-4 md:mt-6">
          <div className="space-y-3 md:space-y-4">
            <div>
              <h3 className="text-base md:text-lg font-medium mb-1 md:mb-2">Quản lý ảnh phòng</h3>
              <p className="text-xs md:text-sm text-gray-600">
                Tải lên tối đa 10 ảnh để khách hàng có thể xem chi tiết phòng
              </p>
            </div>

            <PhongImageUpload
              images={formData.anhPhong}
              onImagesChange={(images: string[]) => setFormData(prev => ({ ...prev, anhPhong: images }))}
              maxImages={10}
              className="w-full"
            />
          </div>
        </TabsContent>
      </Tabs>

      <DialogFooter className="gap-2">
        <Button type="button" variant="outline" onClick={onClose} className="text-sm">
          Hủy
        </Button>
        <Button type="submit" className="text-sm">
          {phong ? 'Cập nhật' : 'Thêm mới'}
        </Button>
      </DialogFooter>
    </form>
  );
}