'use client';

import { useState, useEffect } from 'react';
import { useSession } from 'next-auth/react';
import { Plus, Search } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Input } from '@/components/ui/input';
import { Card, CardContent } from '@/components/ui/card';
import { DatCocForm } from '@/components/dat-coc/DatCocForm';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import Link from 'next/link';

export default function DatCocPage() {
  const { data: session } = useSession();
  const [datCocs, setDatCocs] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [selectedDatCoc, setSelectedDatCoc] = useState<any>(null);
  const [filterStatus, setFilterStatus] = useState('ALL');

  const fetchDatCocs = async () => {
    try {
      const res = await fetch('/api/dat-coc', {
        headers: { 'Authorization': `Bearer ${session?.accessToken}` }
      });
      const data = await res.json();
      if (data.success) {
        setDatCocs(data.data);
      }
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (session?.accessToken) fetchDatCocs();
  }, [session]);

  const handleAction = async (id: string, action: 'confirm' | 'cancel' | 'convert', payload?: any) => {
    try {
      let url = `/api/dat-coc/${id}/${action}`;
      let method = action === 'cancel' ? 'PATCH' : (action === 'confirm' ? 'PATCH' : 'POST');
      const res = await fetch(url, {
        method,
        headers: {
          'Authorization': `Bearer ${session?.accessToken}`,
          'Content-Type': 'application/json'
        },
        body: payload ? JSON.stringify(payload) : undefined
      });
      if (res.ok) {
        fetchDatCocs();
      }
    } catch (e) {
      console.error(e);
    }
  };

  const filtered = filterStatus === 'ALL' ? datCocs : datCocs.filter(d => d.trangThai === filterStatus);

  if (showForm) {
    return <DatCocForm 
      datCoc={selectedDatCoc} 
      onClose={() => { setShowForm(false); setSelectedDatCoc(null); }} 
      onSuccess={() => { setShowForm(false); setSelectedDatCoc(null); fetchDatCocs(); }} 
    />;
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold tracking-tight">Đặt cọc & Giữ phòng</h1>
          <p className="text-muted-foreground">Quản lý khách đặt cọc trước khi làm hợp đồng.</p>
        </div>
        <Button onClick={() => setShowForm(true)}>
          <Plus className="mr-2 h-4 w-4" />
          Tạo đặt cọc
        </Button>
      </div>

      <div className="flex items-center gap-4">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input type="search" placeholder="Tìm kiếm phòng, khách thuê..." className="pl-8 bg-white" />
        </div>
        <Select value={filterStatus} onValueChange={setFilterStatus}>
          <SelectTrigger className="w-[180px] bg-white">
            <SelectValue placeholder="Trạng thái" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="ALL">Tất cả trạng thái</SelectItem>
            <SelectItem value="PENDING">Chờ xác nhận</SelectItem>
            <SelectItem value="CONFIRMED">Đã xác nhận</SelectItem>
            <SelectItem value="CONVERTED">Đã tạo hợp đồng</SelectItem>
            <SelectItem value="CANCELLED">Đã hủy</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <Card>
        <CardContent className="p-0">
          <table className="w-full text-sm text-left">
            <thead className="text-xs text-muted-foreground uppercase bg-muted/50 border-b">
              <tr>
                <th className="px-6 py-4 font-medium">Phòng</th>
                <th className="px-6 py-4 font-medium">Khách thuê</th>
                <th className="px-6 py-4 font-medium">Tiền cọc</th>
                <th className="px-6 py-4 font-medium">Dự kiến vào</th>
                <th className="px-6 py-4 font-medium">Trạng thái</th>
                <th className="px-6 py-4 font-medium text-right">Thao tác</th>
              </tr>
            </thead>
            <tbody className="divide-y">
              {loading ? (
                <tr><td colSpan={6} className="text-center py-8 text-muted-foreground">Đang tải...</td></tr>
              ) : filtered.length === 0 ? (
                <tr><td colSpan={6} className="text-center py-8 text-muted-foreground">Không có dữ liệu</td></tr>
              ) : filtered.map((d, i) => (
                <tr key={i} className="hover:bg-muted/50 transition-colors">
                  <td className="px-6 py-4 font-medium text-primary">{d.phong?.ten}</td>
                  <td className="px-6 py-4 font-medium">{d.khachThue?.hoTen}</td>
                  <td className="px-6 py-4 font-bold text-orange-600">{d.soTienCoc?.toLocaleString()} đ</td>
                  <td className="px-6 py-4">{d.ngayDuKienVao ? new Date(d.ngayDuKienVao).toLocaleDateString('vi-VN') : '-'}</td>
                  <td className="px-6 py-4">
                    <Badge variant={d.trangThai === 'CONFIRMED' ? 'default' : d.trangThai === 'CONVERTED' ? 'secondary' : 'outline'}>
                      {d.trangThai}
                    </Badge>
                  </td>
                  <td className="px-6 py-4 text-right space-x-2">
                    {d.trangThai === 'PENDING' && (
                      <Button size="sm" onClick={() => handleAction(d.id, 'confirm')}>Xác nhận</Button>
                    )}
                    {d.trangThai === 'CONFIRMED' && (
                      <Button size="sm" variant="outline" asChild>
                        <Link href={`/dashboard/hop-dong/them-moi?datCocId=${d.id}&phongId=${d.phong.id || d.phong._id}&khachThueId=${d.khachThue.id || d.khachThue._id}&tienCoc=${d.soTienCoc}&nhaTroId=${d.phong.toaNha?.id || d.phong.toaNha?._id || ''}`}>Tạo hợp đồng</Link>
                      </Button>
                    )}
                    {(d.trangThai === 'PENDING' || d.trangThai === 'CONFIRMED') && (
                      <Button size="sm" variant="destructive" onClick={() => handleAction(d.id, 'cancel', { trangThai: 'CANCELLED', lyDoHuy: 'Khách hủy' })}>Hủy</Button>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </CardContent>
      </Card>
    </div>
  );
}
