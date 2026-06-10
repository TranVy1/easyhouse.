'use client';

import { useState, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { useSession } from 'next-auth/react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';

export function DatCocForm({ datCoc, onClose, onSuccess }: { datCoc?: any, onClose: () => void, onSuccess: () => void }) {
  const { data: session } = useSession();
  const [phongs, setPhongs] = useState<any[]>([]);
  const [khachThues, setKhachThues] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);

  const { register, handleSubmit, setValue, watch, formState: { errors } } = useForm({
    defaultValues: {
      phongId: datCoc?.phong?.id || '',
      khachThueId: datCoc?.khachThue?.id || '',
      soTienCoc: datCoc?.soTienCoc || '',
      ngayDuKienVao: datCoc?.ngayDuKienVao || '',
      ghiChu: datCoc?.ghiChu || ''
    }
  });

  useEffect(() => {
    // Fetch available rooms
    fetch('/api/phong?trangThai=AVAILABLE', { headers: { 'Authorization': `Bearer ${session?.accessToken}` }})
      .then(r => r.json())
      .then(d => { if(d.success) setPhongs(d.data.content || d.data); });

    // Fetch tenants
    fetch('/api/khach-thue', { headers: { 'Authorization': `Bearer ${session?.accessToken}` }})
      .then(r => r.json())
      .then(d => { if(d.success) setKhachThues(d.data.content || d.data); });
  }, [session]);

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
      if (res.ok) {
        onSuccess();
      } else {
        const err = await res.json();
        alert(err.message || 'Lỗi lưu đặt cọc');
      }
    } catch (e) {
      console.error(e);
      alert('Đã xảy ra lỗi');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg p-6 max-w-md w-full max-h-[90vh] overflow-y-auto">
        <h2 className="text-xl font-bold mb-4">{datCoc ? 'Chi tiết đặt cọc' : 'Tạo đặt cọc mới'}</h2>
        <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
          <div>
            <label className="block text-sm font-medium mb-1">Phòng (trống)</label>
            <Select disabled={!!datCoc} value={watch('phongId')} onValueChange={(v) => setValue('phongId', v)}>
              <SelectTrigger>
                <SelectValue placeholder="Chọn phòng" />
              </SelectTrigger>
              <SelectContent>
                {phongs.map((p) => (
                  <SelectItem key={p.id} value={p.id}>{p.ten} - {p.giaHienTai?.toLocaleString()}đ</SelectItem>
                ))}
              </SelectContent>
            </Select>
            {errors.phongId && <span className="text-red-500 text-xs">Bắt buộc</span>}
          </div>

          <div>
            <label className="block text-sm font-medium mb-1">Khách thuê</label>
            <Select disabled={!!datCoc} value={watch('khachThueId')} onValueChange={(v) => setValue('khachThueId', v)}>
              <SelectTrigger>
                <SelectValue placeholder="Chọn khách thuê" />
              </SelectTrigger>
              <SelectContent>
                {khachThues.map((k) => (
                  <SelectItem key={k.id} value={k.id}>{k.hoTen} - {k.soDienThoai}</SelectItem>
                ))}
              </SelectContent>
            </Select>
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
            {!datCoc && <Button type="submit" disabled={loading}>{loading ? 'Đang lưu...' : 'Tạo mới'}</Button>}
          </div>
        </form>
      </div>
    </div>
  );
}
