'use client';

import { useState, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { useSession } from 'next-auth/react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover';
import { Command, CommandEmpty, CommandGroup, CommandInput, CommandItem } from '@/components/ui/command';
import { Check, ChevronsUpDown } from 'lucide-react';
import { cn } from '@/lib/utils';
import { unwrapPageData } from '@/lib/api-response';

export function DatCocForm({ datCoc, onClose, onSuccess }: { datCoc?: any, onClose: () => void, onSuccess: () => void }) {
  const { data: session } = useSession();
  const [toaNhas, setToaNhas] = useState<any[]>([]);
  const [phongs, setPhongs] = useState<any[]>([]);
  const [khachThues, setKhachThues] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  
  const [selectedToaNha, setSelectedToaNha] = useState<string>('');
  const [openToaNha, setOpenToaNha] = useState(false);
  const [openPhong, setOpenPhong] = useState(false);
  const [openKhachThue, setOpenKhachThue] = useState(false);

  const { register, handleSubmit, setValue, watch, formState: { errors } } = useForm({
    defaultValues: {
      phongId: datCoc?.phong?.id || '',
      khachThueId: datCoc?.khachThue?.id || '',
      soTienCoc: datCoc?.soTienCoc || '',
      ngayDuKienVao: datCoc?.ngayDuKienVao || '',
      ghiChu: datCoc?.ghiChu || ''
    }
  });

  const watchPhongId = watch('phongId');
  const watchKhachThueId = watch('khachThueId');

  useEffect(() => {
    // Fetch available buildings
    fetch('/api/toa-nha?page=1&limit=100', { headers: { 'Authorization': `Bearer ${session?.accessToken}` }})
      .then(r => r.json())
      .then(d => { if(d.success) setToaNhas(unwrapPageData(d.data) || []); });

    // Fetch tenants
    fetch('/api/khach-thue?page=1&limit=100', { headers: { 'Authorization': `Bearer ${session?.accessToken}` }})
      .then(r => r.json())
      .then(d => { if(d.success) setKhachThues(unwrapPageData(d.data) || []); });
  }, [session]);

  useEffect(() => {
    if (!selectedToaNha) {
      setPhongs([]);
      return;
    }
    // Fetch available rooms for selected building
    fetch(`/api/phong?nhaTroId=${selectedToaNha}&trangThai=AVAILABLE&page=1&limit=100`, { headers: { 'Authorization': `Bearer ${session?.accessToken}` }})
      .then(r => r.json())
      .then(d => { if(d.success) setPhongs(unwrapPageData(d.data) || []); });
  }, [selectedToaNha, session]);

  const onSubmit = async (data: any) => {
    setLoading(true);
    try {
      const url = '/api/dat-coc';
      const res = await fetch(url, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${session?.accessToken}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
      });
      const payload = await res.json().catch(() => ({}));
      if (res.ok && payload.success !== false) {
        onSuccess();
      } else {
        alert(payload.message || 'Lỗi lưu đặt cọc');
      }
    } catch (e) {
      console.error(e);
      alert('Đã xảy ra lỗi');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-[#243B5A]/45 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg p-6 max-w-md w-full max-h-[90vh] overflow-y-auto">
        <h2 className="text-xl font-bold mb-4">{datCoc ? 'Chi tiết đặt cọc' : 'Tạo đặt cọc mới'}</h2>
        <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
          
          <div>
            <label className="block text-sm font-medium mb-1">Tòa nhà</label>
            <Popover open={openToaNha} onOpenChange={setOpenToaNha}>
              <PopoverTrigger asChild>
                <Button
                  variant="outline"
                  role="combobox"
                  aria-expanded={openToaNha}
                  className="w-full justify-between"
                  disabled={!!datCoc}
                >
                  {selectedToaNha
                    ? toaNhas.find((t) => (t._id || t.id) === selectedToaNha)?.tenToaNha || 'Chọn tòa nhà...'
                    : "Chọn tòa nhà..."}
                  <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                </Button>
              </PopoverTrigger>
              <PopoverContent className="w-full p-0">
                <Command>
                  <CommandInput placeholder="Tìm kiếm tòa nhà..." />
                  <CommandEmpty>Không tìm thấy tòa nhà.</CommandEmpty>
                  <CommandGroup className="max-h-60 overflow-y-auto">
                    {toaNhas.map((t) => (
                      <CommandItem
                        key={t._id || t.id}
                        value={t.tenToaNha}
                        onSelect={() => {
                          setSelectedToaNha(t._id || t.id);
                          setValue('phongId', '');
                          setOpenToaNha(false);
                        }}
                      >
                        <Check
                          className={cn(
                            "mr-2 h-4 w-4",
                            selectedToaNha === (t._id || t.id) ? "opacity-100" : "opacity-0"
                          )}
                        />
                        {t.tenToaNha}
                      </CommandItem>
                    ))}
                  </CommandGroup>
                </Command>
              </PopoverContent>
            </Popover>
          </div>

          <div>
            <label className="block text-sm font-medium mb-1">Phòng (trống)</label>
            <Popover open={openPhong} onOpenChange={setOpenPhong}>
              <PopoverTrigger asChild>
                <Button
                  variant="outline"
                  role="combobox"
                  aria-expanded={openPhong}
                  className="w-full justify-between"
                  disabled={!!datCoc || !selectedToaNha}
                >
                  {watchPhongId && phongs.length > 0
                    ? (() => {
                        const p = phongs.find((ph) => (ph._id || ph.id) === watchPhongId);
                        return p ? `${p.ten || p.maPhong} - ${((p.giaHienTai || p.giaThue) || 0).toLocaleString()}đ` : "Chọn phòng...";
                      })()
                    : "Chọn phòng..."}
                  <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                </Button>
              </PopoverTrigger>
              <PopoverContent className="w-full p-0">
                <Command>
                  <CommandInput placeholder="Tìm kiếm phòng..." />
                  <CommandEmpty>Không tìm thấy phòng trống.</CommandEmpty>
                  <CommandGroup className="max-h-60 overflow-y-auto">
                    {phongs.map((p) => (
                      <CommandItem
                        key={p._id || p.id}
                        value={p.ten || p.maPhong}
                        onSelect={() => {
                          setValue('phongId', p._id || p.id);
                          setOpenPhong(false);
                        }}
                      >
                        <Check
                          className={cn(
                            "mr-2 h-4 w-4",
                            watchPhongId === (p._id || p.id) ? "opacity-100" : "opacity-0"
                          )}
                        />
                        {(p.ten || p.maPhong)} - {((p.giaHienTai || p.giaThue) || 0).toLocaleString()}đ
                      </CommandItem>
                    ))}
                  </CommandGroup>
                </Command>
              </PopoverContent>
            </Popover>
            {errors.phongId && <span className="text-red-500 text-xs">Bắt buộc</span>}
          </div>

          <div>
            <label className="block text-sm font-medium mb-1">Khách thuê</label>
            <Popover open={openKhachThue} onOpenChange={setOpenKhachThue}>
              <PopoverTrigger asChild>
                <Button
                  variant="outline"
                  role="combobox"
                  aria-expanded={openKhachThue}
                  className="w-full justify-between"
                  disabled={!!datCoc}
                >
                  {watchKhachThueId && khachThues.length > 0
                    ? (() => {
                        const k = khachThues.find((kh) => (kh._id || kh.id) === watchKhachThueId);
                        return k ? `${k.hoTen} - ${k.soDienThoai}` : "Chọn khách thuê...";
                      })()
                    : "Chọn khách thuê..."}
                  <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                </Button>
              </PopoverTrigger>
              <PopoverContent className="w-full p-0">
                <Command>
                  <CommandInput placeholder="Tìm kiếm khách thuê..." />
                  <CommandEmpty>Không tìm thấy khách thuê.</CommandEmpty>
                  <CommandGroup className="max-h-60 overflow-y-auto">
                    {khachThues.map((k) => (
                      <CommandItem
                        key={k._id || k.id}
                        value={`${k.hoTen} ${k.soDienThoai}`}
                        onSelect={() => {
                          setValue('khachThueId', k._id || k.id);
                          setOpenKhachThue(false);
                        }}
                      >
                        <Check
                          className={cn(
                            "mr-2 h-4 w-4",
                            watchKhachThueId === (k._id || k.id) ? "opacity-100" : "opacity-0"
                          )}
                        />
                        {k.hoTen} - {k.soDienThoai}
                      </CommandItem>
                    ))}
                  </CommandGroup>
                </Command>
              </PopoverContent>
            </Popover>
            {errors.khachThueId && <span className="text-red-500 text-xs">Bắt buộc</span>}
          </div>

          <div>
            <label className="block text-sm font-medium mb-1">Số tiền cọc</label>
            <Input type="number" disabled={!!datCoc} {...register('soTienCoc', { required: true })} />
            {errors.soTienCoc && <span className="text-red-500 text-xs">Bắt buộc</span>}
          </div>

          <div>
            <label className="block text-sm font-medium mb-1">Ngày dự kiến vào</label>
            <Input type="date" disabled={!!datCoc} {...register('ngayDuKienVao', { required: true })} />
            {errors.ngayDuKienVao && <span className="text-red-500 text-xs">Bắt buộc</span>}
          </div>

          <div>
            <label className="block text-sm font-medium mb-1">Ghi chú</label>
            <Textarea disabled={!!datCoc} {...register('ghiChu')} />
          </div>

          <div className="flex justify-end gap-2 mt-6">
            <Button type="button" variant="outline" onClick={onClose}>Hủy</Button>
            {!datCoc && <Button type="submit" disabled={loading}>{loading ? 'Đang xử lý...' : 'Tạo mới'}</Button>}
          </div>
        </form>
      </div>
    </div>
  );
}
