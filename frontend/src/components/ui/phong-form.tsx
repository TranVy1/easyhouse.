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
    <form onSubmit={handleSubmit} className="flex min-h-0 flex-1 flex-col">
      <div className="flex-1 overflow-y-auto overscroll-contain px-6 pb-6 space-y-6 md:space-y-8 animate-in fade-in duration-300">
        <Tabs defaultValue="thong-tin" className="w-full">
          <TabsList className="grid w-full grid-cols-2 p-1.5 bg-[#F8F3EC] rounded-2xl mb-2">
            <TabsTrigger 
              value="thong-tin" 
              className="flex items-center justify-center gap-2 text-sm font-semibold rounded-xl py-2.5 transition-all duration-300 data-[state=active]:bg-white data-[state=active]:text-[#4FA7A0] data-[state=active]:shadow-sm text-gray-500 hover:text-[#243B5A]"
            >
              <Info className="h-4 w-4" />
              Thông tin phòng
            </TabsTrigger>
            <TabsTrigger 
              value="anh-phong" 
              className="flex items-center justify-center gap-2 text-sm font-semibold rounded-xl py-2.5 transition-all duration-300 data-[state=active]:bg-white data-[state=active]:text-[#4FA7A0] data-[state=active]:shadow-sm text-gray-500 hover:text-[#243B5A]"
            >
              <ImageIcon className="h-4 w-4" />
              Ảnh phòng
            </TabsTrigger>
          </TabsList>

          <TabsContent value="thong-tin" className="space-y-6 md:space-y-8 mt-4 outline-none focus-visible:ring-0">
            {/* Row 1 */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-5 md:gap-6">
              <div className="space-y-2.5">
                <Label htmlFor="maPhong" className="text-sm font-semibold text-[#243B5A]">Mã phòng <span className="text-red-500">*</span></Label>
                <Input
                  id="maPhong"
                  value={formData.maPhong}
                  onChange={(e) => setFormData(prev => ({ ...prev, maPhong: e.target.value.toUpperCase() }))}
                  required
                  placeholder="VD: P101"
                  className="h-11 rounded-xl border-gray-200 bg-white px-4 text-sm font-medium shadow-sm transition-all focus-visible:border-[#4FA7A0] focus-visible:ring-1 focus-visible:ring-[#4FA7A0] hover:border-gray-300"
                />
              </div>

              <div className="space-y-2.5">
                <Label htmlFor="toaNha" className="text-sm font-semibold text-[#243B5A]">Tòa nhà <span className="text-red-500">*</span></Label>
                <Select value={formData.toaNha} onValueChange={(value) => setFormData(prev => ({ ...prev, toaNha: value }))}>
                  <SelectTrigger className="h-11 rounded-xl border-gray-200 bg-white px-4 text-sm font-medium shadow-sm transition-all focus:border-[#4FA7A0] focus:ring-1 focus:ring-[#4FA7A0] hover:border-gray-300">
                    <SelectValue placeholder="Chọn tòa nhà" />
                  </SelectTrigger>
                  <SelectContent className="rounded-xl shadow-lg border-gray-100">
                    {toaNhaList.map((toaNha) => (
                      <SelectItem key={toaNha._id} value={toaNha._id!} className="text-sm rounded-lg my-1 cursor-pointer hover:bg-[#F8F3EC] focus:bg-[#F8F3EC]">
                        {toaNha.tenToaNha}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-2.5">
                <Label htmlFor="trangThai" className="text-sm font-semibold text-[#243B5A]">Trạng thái <span className="text-red-500">*</span></Label>
                <Select value={formData.trangThai} onValueChange={(value) => setFormData(prev => ({ ...prev, trangThai: value as 'trong' | 'daDat' | 'dangThue' | 'baoTri' }))}>
                  <SelectTrigger className="h-11 rounded-xl border-gray-200 bg-white px-4 text-sm font-medium shadow-sm transition-all focus:border-[#4FA7A0] focus:ring-1 focus:ring-[#4FA7A0] hover:border-gray-300">
                    <SelectValue placeholder="Chọn trạng thái" />
                  </SelectTrigger>
                  <SelectContent className="rounded-xl shadow-lg border-gray-100">
                    <SelectItem value="trong" className="text-sm rounded-lg my-1 cursor-pointer">
                      <div className="flex items-center gap-2"><div className="w-2 h-2 rounded-full bg-[#4FA7A0]"></div> Trống</div>
                    </SelectItem>
                    <SelectItem value="daDat" className="text-sm rounded-lg my-1 cursor-pointer">
                      <div className="flex items-center gap-2"><div className="w-2 h-2 rounded-full bg-[#F2A45B]"></div> Đã đặt</div>
                    </SelectItem>
                    <SelectItem value="dangThue" className="text-sm rounded-lg my-1 cursor-pointer">
                      <div className="flex items-center gap-2"><div className="w-2 h-2 rounded-full bg-[#243B5A]"></div> Đang thuê</div>
                    </SelectItem>
                    <SelectItem value="baoTri" className="text-sm rounded-lg my-1 cursor-pointer">
                      <div className="flex items-center gap-2"><div className="w-2 h-2 rounded-full bg-red-500"></div> Bảo trì</div>
                    </SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            {/* Row 2 */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-5 md:gap-6">
              <div className="space-y-2.5">
                <Label htmlFor="tang" className="text-sm font-semibold text-[#243B5A]">Tầng</Label>
                <Select value={formData.tang.toString()} onValueChange={(value) => setFormData(prev => ({ ...prev, tang: parseInt(value) }))}>
                  <SelectTrigger className="h-11 rounded-xl border-gray-200 bg-white px-4 text-sm font-medium shadow-sm transition-all focus:border-[#4FA7A0] focus:ring-1 focus:ring-[#4FA7A0] hover:border-gray-300">
                    <SelectValue placeholder="Chọn tầng" />
                  </SelectTrigger>
                  <SelectContent className="rounded-xl shadow-lg border-gray-100 max-h-[200px]">
                    {tangList.length > 0 ? tangList.map((t) => (
                      <SelectItem key={t.soTang} value={t.soTang.toString()} className="text-sm rounded-lg my-1 cursor-pointer">
                        {t.tenTang || `Tầng ${t.soTang}`}
                      </SelectItem>
                    )) : (
                      <SelectItem value={formData.tang.toString()} className="text-sm rounded-lg my-1 cursor-pointer">Tầng {formData.tang}</SelectItem>
                    )}
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-2.5">
                <Label htmlFor="dienTich" className="text-sm font-semibold text-[#243B5A]">Diện tích (m²)</Label>
                <Input
                  id="dienTich"
                  type="number"
                  min="1"
                  value={formData.dienTich}
                  onChange={(e) => setFormData(prev => ({ ...prev, dienTich: parseInt(e.target.value) || 0 }))}
                  required
                  className="h-11 rounded-xl border-gray-200 bg-white px-4 text-sm font-medium shadow-sm transition-all focus-visible:border-[#4FA7A0] focus-visible:ring-1 focus-visible:ring-[#4FA7A0] hover:border-gray-300"
                />
              </div>

              <div className="space-y-2.5">
                <Label htmlFor="soNguoiToiDa" className="text-sm font-semibold text-[#243B5A]">Người tối đa</Label>
                <Input
                  id="soNguoiToiDa"
                  type="number"
                  min="1"
                  max="10"
                  value={formData.soNguoiToiDa}
                  onChange={(e) => setFormData(prev => ({ ...prev, soNguoiToiDa: parseInt(e.target.value) || 1 }))}
                  required
                  className="h-11 rounded-xl border-gray-200 bg-white px-4 text-sm font-medium shadow-sm transition-all focus-visible:border-[#4FA7A0] focus-visible:ring-1 focus-visible:ring-[#4FA7A0] hover:border-gray-300"
                />
              </div>

              <div className="space-y-2.5 col-span-2 md:col-span-1">
                <Label className="text-sm font-semibold text-[#243B5A]">Xem trước</Label>
                <div className="h-11 bg-[#4FA7A0]/5 border border-[#4FA7A0]/20 rounded-xl flex items-center px-4 text-sm font-medium text-[#4FA7A0] shadow-sm truncate">
                  <span className="truncate">
                    {formData.maPhong ? `Phòng ${formData.maPhong}` : 'Mã phòng'} - {formData.tang ? `Tầng ${formData.tang}` : 'Tầng'}
                  </span>
                </div>
              </div>
            </div>

            {/* Row 3 */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-5 md:gap-6 bg-[#F8F3EC]/50 p-5 rounded-2xl border border-gray-100/50">
              <div className="space-y-2.5">
                <Label htmlFor="giaThue" className="text-sm font-semibold text-[#243B5A]">Giá thuê (VNĐ)</Label>
                <div className="relative">
                  <Input
                    id="giaThue"
                    type="number"
                    min="0"
                    value={formData.giaThue}
                    onChange={(e) => setFormData(prev => ({ ...prev, giaThue: parseInt(e.target.value) || 0 }))}
                    required
                    className="h-12 rounded-xl border-gray-200 bg-white pl-4 pr-12 text-base font-semibold shadow-sm transition-all focus-visible:border-[#4FA7A0] focus-visible:ring-1 focus-visible:ring-[#4FA7A0] hover:border-gray-300"
                  />
                  <div className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 font-medium">đ</div>
                </div>
                <div className="text-xs font-medium text-[#4FA7A0] pt-1">
                  Bằng chữ: {formatCurrency(formData.giaThue)}
                </div>
              </div>

              <div className="space-y-2.5">
                <Label htmlFor="tienCoc" className="text-sm font-semibold text-[#243B5A]">Tiền cọc (VNĐ)</Label>
                <div className="relative">
                  <Input
                    id="tienCoc"
                    type="number"
                    min="0"
                    value={formData.tienCoc}
                    onChange={(e) => setFormData(prev => ({ ...prev, tienCoc: parseInt(e.target.value) || 0 }))}
                    required
                    className="h-12 rounded-xl border-gray-200 bg-white pl-4 pr-12 text-base font-semibold shadow-sm transition-all focus-visible:border-[#F2A45B] focus-visible:ring-1 focus-visible:ring-[#F2A45B] hover:border-gray-300"
                  />
                  <div className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 font-medium">đ</div>
                </div>
                <div className="text-xs font-medium text-[#F2A45B] pt-1">
                  Bằng chữ: {formatCurrency(formData.tienCoc)}
                </div>
              </div>
            </div>

            {/* Row 4 */}
            <div className="space-y-2.5">
              <Label htmlFor="moTa" className="text-sm font-semibold text-[#243B5A]">Mô tả bổ sung</Label>
              <Textarea
                id="moTa"
                value={formData.moTa}
                onChange={(e) => setFormData(prev => ({ ...prev, moTa: e.target.value }))}
                placeholder="Nhập thông tin mô tả chi tiết về phòng..."
                className="min-h-[100px] rounded-xl border-gray-200 bg-white p-4 text-sm font-medium shadow-sm resize-y transition-all focus-visible:border-[#4FA7A0] focus-visible:ring-1 focus-visible:ring-[#4FA7A0] hover:border-gray-300"
              />
            </div>

            {/* Row 5 */}
            <div className="space-y-3">
              <Label className="text-sm font-semibold text-[#243B5A] flex items-center justify-between">
                <span>Tiện nghi có sẵn</span>
                <span className="text-xs font-normal text-gray-500 bg-gray-100 px-2 py-0.5 rounded-full">{formData.tienNghi.length} đã chọn</span>
              </Label>
              <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3">
                {tienNghiOptions.map((option) => {
                  const isChecked = formData.tienNghi.includes(option.value);
                  return (
                    <label
                      key={option.value}
                      className={`relative flex cursor-pointer items-center justify-between rounded-xl border p-3 transition-all duration-200 hover:shadow-sm ${
                        isChecked 
                          ? 'border-[#4FA7A0] bg-[#4FA7A0]/5 shadow-sm ring-1 ring-[#4FA7A0]/10' 
                          : 'border-gray-200 bg-white hover:border-gray-300 hover:bg-gray-50'
                      }`}
                    >
                      <span className={`text-sm font-medium transition-colors ${isChecked ? 'text-[#243B5A]' : 'text-gray-600'}`}>
                        {option.label}
                      </span>
                      <div className={`flex h-5 w-5 items-center justify-center rounded-md border transition-all ${
                        isChecked 
                          ? 'border-[#4FA7A0] bg-[#4FA7A0] text-white shadow-sm scale-110' 
                          : 'border-gray-300 bg-white text-transparent'
                      }`}>
                        <svg width="12" height="12" viewBox="0 0 12 12" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <path d="M10 3L4.5 8.5L2 6" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"/>
                        </svg>
                      </div>
                      <input
                        type="checkbox"
                        className="sr-only"
                        checked={isChecked}
                        onChange={(e) => handleTienNghiChange(option.value, e.target.checked)}
                      />
                    </label>
                  );
                })}
              </div>
            </div>
          </TabsContent>

          <TabsContent value="anh-phong" className="space-y-6 mt-4 outline-none focus-visible:ring-0">
            <div className="bg-white border rounded-2xl p-6 shadow-sm">
              <div className="mb-6">
                <h3 className="text-lg font-semibold text-[#243B5A] mb-1">Quản lý ảnh phòng</h3>
                <p className="text-sm text-gray-500">
                  Tải lên tối đa 10 ảnh chất lượng cao để khách hàng có thể xem chi tiết phòng. Định dạng hỗ trợ: JPG, PNG.
                </p>
              </div>

              <div className="bg-gray-50/50 rounded-xl border border-dashed border-gray-200 p-2">
                <PhongImageUpload
                  images={formData.anhPhong}
                  onImagesChange={(images: string[]) => setFormData(prev => ({ ...prev, anhPhong: images }))}
                  maxImages={10}
                  className="w-full"
                />
              </div>
            </div>
          </TabsContent>
        </Tabs>
      </div>

      <div className="shrink-0 border-t border-slate-200/70 bg-white/95 px-6 py-5 backdrop-blur flex justify-end gap-3 z-10">
        <Button 
          type="button" 
          variant="outline" 
          onClick={onClose} 
          className="h-11 px-6 rounded-xl text-sm font-semibold border-gray-200 text-gray-600 hover:bg-gray-50 hover:text-gray-900 transition-colors"
        >
          Hủy bỏ
        </Button>
        <Button 
          type="submit" 
          className="h-11 px-8 rounded-xl text-sm font-semibold bg-[#4FA7A0] text-white hover:bg-[#3d857f] shadow-sm hover:shadow transition-all"
        >
          {phong ? 'Lưu thay đổi' : 'Thêm phòng mới'}
        </Button>
      </div>
    </form>
  );
}