'use client';

import { useState, useEffect } from 'react';
import { useSession } from 'next-auth/react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Info, Image as ImageIcon } from 'lucide-react';
import { toast } from 'sonner';
import { PhongImageUpload } from '@/components/ui/phong-image-upload';
import type { Phong, ToaNha } from '@/types';

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

const labelClass = 'text-[12px] font-semibold text-[#243B5A]';
const requiredClass = 'text-[#E76F51]';
const fieldClass = 'space-y-1';
const controlClass = 'box-border h-10 min-h-10 w-full rounded-xl border border-[#DFE5EC] bg-white px-3 text-sm font-medium leading-none text-[#243B5A] shadow-sm transition-all duration-200 placeholder:text-[#8FA0B3] hover:border-[#4FA7A0] focus:border-[#4FA7A0] focus:outline-none focus:ring-[3px] focus:ring-[#4FA7A0]/15 focus-visible:border-[#4FA7A0] focus-visible:outline-none focus-visible:ring-[3px] focus-visible:ring-[#4FA7A0]/15 focus-visible:ring-offset-0 disabled:cursor-not-allowed disabled:opacity-60';
const inputClass = controlClass;
const selectTriggerClass = `${controlClass} justify-between py-0 data-[placeholder]:text-[#8FA0B3] [&>svg]:ml-3 [&>svg]:size-4 [&>svg]:text-[#6B7A8C] [&>svg]:opacity-70 *:data-[slot=select-value]:flex *:data-[slot=select-value]:h-full *:data-[slot=select-value]:min-w-0 *:data-[slot=select-value]:items-center *:data-[slot=select-value]:gap-2 *:data-[slot=select-value]:truncate`;
const previewControlClass = `${controlClass} flex items-center truncate border-[#4FA7A0]/25 bg-[#4FA7A0]/10 text-[#267D76] hover:border-[#4FA7A0]/45`;
const actionButtonClass = 'h-10 min-h-10 rounded-xl px-4 text-sm font-semibold';
const selectContentClass = 'rounded-xl border-[#243B5A]/10 bg-[#FFFCF7] shadow-xl shadow-[#243B5A]/12';
const selectItemClass = 'my-0.5 min-h-8 cursor-pointer rounded-lg text-sm text-[#243B5A] hover:bg-[#F8F3EC] focus:bg-[#F8F3EC] *:[span]:last:flex *:[span]:last:items-center *:[span]:last:gap-2';
type TangOption = { soTang: number; tenTang: string };

// Form component for adding/editing phong
export function PhongForm({
  phong,
  toaNhaList,
  onClose,
  onSuccess
}: {
  phong: Phong | null;
  toaNhaList: Pick<ToaNha, '_id' | 'tenToaNha'>[];
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

  const [tangList, setTangList] = useState<TangOption[]>([]);
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
        .then((result: { success?: boolean; data?: TangOption[] }) => {
          if (result.success && Array.isArray(result.data)) {
            // Sort by soTang
            const sorted = [...result.data].sort((a, b) => a.soTang - b.soTang);
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
    <form onSubmit={handleSubmit} className="flex min-h-0 flex-1 flex-col overflow-hidden bg-[#FFFCF7]">
      <div className="easyhouse-room-modal-scroll flex-1 space-y-4 overflow-y-auto overscroll-contain px-4 py-3 sm:px-5 sm:py-4 lg:px-7 lg:py-5">
        <Tabs defaultValue="thong-tin" className="w-full">
          <TabsList className="mb-1 grid h-10 w-full grid-cols-2 rounded-xl bg-[#F8F3EC] p-1">
            <TabsTrigger
              value="thong-tin"
              className="flex h-8 items-center justify-center gap-1.5 rounded-lg text-sm font-semibold text-[#6B7A8C] transition-all duration-200 hover:bg-white/55 hover:text-[#243B5A] data-[state=active]:bg-white data-[state=active]:text-[#243B5A] data-[state=active]:shadow-sm"
            >
              <Info className="h-4 w-4" />
              Thông tin phòng
            </TabsTrigger>
            <TabsTrigger
              value="anh-phong"
              className="flex h-8 items-center justify-center gap-1.5 rounded-lg text-sm font-semibold text-[#6B7A8C] transition-all duration-200 hover:bg-white/55 hover:text-[#243B5A] data-[state=active]:bg-white data-[state=active]:text-[#243B5A] data-[state=active]:shadow-sm"
            >
              <ImageIcon className="h-4 w-4" />
              Ảnh phòng
            </TabsTrigger>
          </TabsList>

          <TabsContent value="thong-tin" className="mt-3 space-y-4 outline-none focus-visible:ring-0">
            {/* Row 1 */}
            <div className="grid grid-cols-1 gap-3 md:grid-cols-3 lg:gap-4">
              <div className={fieldClass}>
                <Label htmlFor="maPhong" className={labelClass}>Tên phòng <span className={requiredClass}>*</span></Label>
                <Input
                  id="maPhong"
                  value={formData.maPhong}
                  onChange={(e) => setFormData(prev => ({ ...prev, maPhong: e.target.value.toUpperCase() }))}
                  required
                  placeholder="VD: P101"
                  className={inputClass}
                />
              </div>

              <div className={fieldClass}>
                <Label htmlFor="toaNha" className={labelClass}>Tòa nhà <span className={requiredClass}>*</span></Label>
                <Select value={formData.toaNha} onValueChange={(value) => setFormData(prev => ({ ...prev, toaNha: value }))}>
                  <SelectTrigger className={selectTriggerClass}>
                    <SelectValue placeholder="Chọn tòa nhà" />
                  </SelectTrigger>
                  <SelectContent className={selectContentClass}>
                    {toaNhaList.map((toaNha) => (
                      <SelectItem key={toaNha._id} value={toaNha._id!} className={selectItemClass}>
                        {toaNha.tenToaNha}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <div className={fieldClass}>
                <Label htmlFor="trangThai" className={labelClass}>Trạng thái <span className={requiredClass}>*</span></Label>
                <Select value={formData.trangThai} onValueChange={(value) => setFormData(prev => ({ ...prev, trangThai: value as 'trong' | 'daDat' | 'dangThue' | 'baoTri' }))}>
                  <SelectTrigger className={selectTriggerClass}>
                    <SelectValue placeholder="Chọn trạng thái" />
                  </SelectTrigger>
                  <SelectContent className={selectContentClass}>
                    <SelectItem value="trong" className={selectItemClass}>
                      <div className="flex items-center gap-2 leading-none"><div className="h-2 w-2 shrink-0 rounded-full bg-[#4FA7A0]"></div> Trống</div>
                    </SelectItem>
                    <SelectItem value="daDat" className={selectItemClass}>
                      <div className="flex items-center gap-2 leading-none"><div className="h-2 w-2 shrink-0 rounded-full bg-[#F2A45B]"></div> Đã đặt</div>
                    </SelectItem>
                    <SelectItem value="dangThue" className={selectItemClass}>
                      <div className="flex items-center gap-2 leading-none"><div className="h-2 w-2 shrink-0 rounded-full bg-[#243B5A]"></div> Đang thuê</div>
                    </SelectItem>
                    <SelectItem value="baoTri" className={selectItemClass}>
                      <div className="flex items-center gap-2 leading-none"><div className="h-2 w-2 shrink-0 rounded-full bg-[#F2A45B]"></div> Bảo trì</div>
                    </SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            {/* Row 2 */}
            <div className="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-4 lg:gap-4">
              <div className={fieldClass}>
                <Label htmlFor="tang" className={labelClass}>Tầng</Label>
                <Select value={formData.tang.toString()} onValueChange={(value) => setFormData(prev => ({ ...prev, tang: parseInt(value) }))}>
                  <SelectTrigger className={selectTriggerClass}>
                    <SelectValue placeholder="Chọn tầng" />
                  </SelectTrigger>
                  <SelectContent className={`${selectContentClass} max-h-[200px]`}>
                    {tangList.length > 0 ? tangList.map((t) => (
                      <SelectItem key={t.soTang} value={t.soTang.toString()} className={selectItemClass}>
                        {t.tenTang || `Tầng ${t.soTang}`}
                      </SelectItem>
                    )) : (
                      <SelectItem value={formData.tang.toString()} className={selectItemClass}>Tầng {formData.tang}</SelectItem>
                    )}
                  </SelectContent>
                </Select>
              </div>

              <div className={fieldClass}>
                <Label htmlFor="dienTich" className={labelClass}>Diện tích (m²)</Label>
                <Input
                  id="dienTich"
                  type="number"
                  min="1"
                  value={formData.dienTich}
                  onChange={(e) => setFormData(prev => ({ ...prev, dienTich: parseInt(e.target.value) || 0 }))}
                  required
                  className={inputClass}
                />
              </div>

              <div className={fieldClass}>
                <Label htmlFor="soNguoiToiDa" className={labelClass}>Người tối đa</Label>
                <Input
                  id="soNguoiToiDa"
                  type="number"
                  min="1"
                  max="10"
                  value={formData.soNguoiToiDa}
                  onChange={(e) => setFormData(prev => ({ ...prev, soNguoiToiDa: parseInt(e.target.value) || 1 }))}
                  required
                  className={inputClass}
                />
              </div>

              <div className={fieldClass}>
                <Label className={labelClass}>Xem trước</Label>
                <div className={previewControlClass}>
                  <span className="truncate">
                    {formData.maPhong ? `Phòng ${formData.maPhong}` : 'Mã phòng'} - {formData.tang ? `Tầng ${formData.tang}` : 'Tầng'}
                  </span>
                </div>
              </div>
            </div>

            {/* Row 3 */}
            <div className="grid grid-cols-1 gap-3 rounded-xl border border-[#4FA7A0]/16 bg-[#4FA7A0]/8 p-3 shadow-[inset_0_1px_0_rgba(255,255,255,0.65)] md:grid-cols-2 lg:gap-4 lg:p-4">
              <div className={fieldClass}>
                <Label htmlFor="giaThue" className={labelClass}>Giá thuê (VNĐ)</Label>
                <div className="relative">
                  <Input
                    id="giaThue"
                    type="number"
                    min="0"
                    value={formData.giaThue}
                    onChange={(e) => setFormData(prev => ({ ...prev, giaThue: parseInt(e.target.value) || 0 }))}
                    required
                    className={`${inputClass} pr-9`}
                  />
                  <div className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 text-sm font-semibold leading-none text-[#8FA0B3]">đ</div>
                </div>
                <div className="pt-0.5 text-[12px] font-semibold text-[#267D76]">
                  Bằng chữ: {formatCurrency(formData.giaThue)}
                </div>
              </div>

              <div className={fieldClass}>
                <Label htmlFor="tienCoc" className={labelClass}>Tiền cọc (VNĐ)</Label>
                <div className="relative">
                  <Input
                    id="tienCoc"
                    type="number"
                    min="0"
                    value={formData.tienCoc}
                    onChange={(e) => setFormData(prev => ({ ...prev, tienCoc: parseInt(e.target.value) || 0 }))}
                    required
                    className={`${inputClass} pr-9 focus-visible:border-[#F2A45B] focus-visible:ring-[#F2A45B]/20`}
                  />
                  <div className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 text-sm font-semibold leading-none text-[#8FA0B3]">đ</div>
                </div>
                <div className="pt-0.5 text-[12px] font-semibold text-[#F2A45B]">
                  Bằng chữ: {formatCurrency(formData.tienCoc)}
                </div>
              </div>
            </div>

            {/* Row 4 */}
            <div className={fieldClass}>
              <Label htmlFor="moTa" className={labelClass}>Mô tả bổ sung</Label>
              <Textarea
                id="moTa"
                value={formData.moTa}
                onChange={(e) => setFormData(prev => ({ ...prev, moTa: e.target.value }))}
                placeholder="Nhập thông tin mô tả chi tiết về phòng..."
                className="min-h-[76px] resize-y rounded-xl border-[#243B5A]/12 bg-white p-3 text-sm font-medium text-[#243B5A] shadow-[0_1px_2px_rgba(36,59,90,0.04)] transition-all duration-200 placeholder:text-[#8FA0B2] hover:border-[#243B5A]/20 focus-visible:border-[#4FA7A0] focus-visible:ring-[3px] focus-visible:ring-[#4FA7A0]/15 focus-visible:ring-offset-0"
              />
            </div>

            {/* Row 5 */}
            <div className="space-y-2.5">
              <Label className="text-sm font-semibold text-[#243B5A] flex items-center justify-between">
                <span>Tiện nghi có sẵn</span>
                <span className="rounded-full bg-[#F8F3EC] px-2 py-0.5 text-xs font-medium text-slate-500">{formData.tienNghi.length} đã chọn</span>
              </Label>
              <div className="grid grid-cols-2 gap-2 sm:grid-cols-3 lg:grid-cols-4">
                {tienNghiOptions.map((option) => {
                  const isChecked = formData.tienNghi.includes(option.value);
                  return (
                    <label
                      key={option.value}
                      className={`relative flex cursor-pointer items-center justify-between rounded-xl border px-3 py-2 transition-all duration-200 hover:shadow-sm ${isChecked
                        ? 'border-[#4FA7A0] bg-[#4FA7A0]/5 shadow-sm ring-1 ring-[#4FA7A0]/10'
                        : 'border-gray-200 bg-white hover:border-gray-300 hover:bg-gray-50'
                        }`}
                    >
                      <span className={`text-sm font-medium transition-colors ${isChecked ? 'text-[#243B5A]' : 'text-gray-600'}`}>
                        {option.label}
                      </span>
                      <div className={`flex h-5 w-5 items-center justify-center rounded-md border transition-all ${isChecked
                        ? 'border-[#4FA7A0] bg-[#4FA7A0] text-white shadow-sm scale-110'
                        : 'border-gray-300 bg-white text-transparent'
                        }`}>
                        <svg width="12" height="12" viewBox="0 0 12 12" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <path d="M10 3L4.5 8.5L2 6" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
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

          <TabsContent value="anh-phong" className="mt-3 space-y-4 outline-none focus-visible:ring-0">
            <div className="rounded-xl border border-[#243B5A]/10 bg-white p-3 shadow-sm lg:p-4">
              <div className="mb-3">
                <h3 className="mb-1 text-base font-semibold text-[#243B5A]">Quản lý ảnh phòng</h3>
                <p className="text-sm text-gray-500">
                  Tải lên tối đa 10 ảnh chất lượng cao để khách hàng có thể xem chi tiết phòng. Định dạng hỗ trợ: JPG, PNG.
                </p>
              </div>

              <div className="rounded-xl border border-dashed border-[#243B5A]/12 bg-[#F8F3EC]/55 p-2">
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

      <div className="sticky bottom-0 z-10 flex shrink-0 flex-col-reverse gap-2 border-t border-[#243B5A]/10 bg-[#FFFCF7]/95 px-4 py-3 backdrop-blur sm:flex-row sm:justify-end sm:gap-2.5 sm:px-5 lg:px-7">
        <Button
          type="button"
          variant="outline"
          onClick={onClose}
          className={`${actionButtonClass} w-full border-[#DFE5EC] bg-white text-[#243B5A] shadow-sm transition-all duration-200 ease-out hover:-translate-y-[1px] hover:border-[#4FA7A0]/35 hover:bg-[#F8F3EC] hover:text-[#243B5A] hover:shadow-md focus-visible:ring-4 focus-visible:ring-[#4FA7A0]/18 sm:w-auto`}
        >
          Hủy
        </Button>
        <Button
          type="submit"
          className={`${actionButtonClass} w-full bg-[#243B5A] font-bold text-white shadow-sm shadow-[#243B5A]/20 transition-all duration-200 ease-out hover:-translate-y-[1px] hover:bg-[#1D314D] hover:shadow-md hover:shadow-[#243B5A]/25 focus-visible:ring-4 focus-visible:ring-[#4FA7A0]/22 disabled:cursor-not-allowed disabled:opacity-60 disabled:hover:translate-y-0 disabled:hover:shadow-sm sm:w-auto`}
        >
          {phong ? 'Lưu thay đổi' : 'Thêm phòng'}
        </Button>
      </div>
    </form>
  );
}
