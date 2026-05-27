'use client';

import { useState, useEffect, useCallback } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Home, Calendar, DollarSign, FileText, CheckCircle2 } from 'lucide-react';
import { useSession } from 'next-auth/react';
import { toast } from 'sonner';
import { TenantContract } from '@/types';

export default function TenantContractsPage() {
  const session = useSession()?.data;
  const accessToken = session?.accessToken;
  const [contracts, setContracts] = useState<TenantContract[]>([]);
  const [loading, setLoading] = useState(true);

  const fetchContracts = useCallback(async () => {
    try {
      setLoading(true);
      const res = await fetch('/api/tenant/hop-dong', {
        headers: {
          'Authorization': `Bearer ${accessToken}`
        }
      });
      const data = await res.json();
      if (data.success) {
        setContracts(data.data.data); // data.data is PaginatedResponse, .data is the array
      } else {
        toast.error('Không thể tải danh sách hợp đồng');
      }
    } catch (error) {
      console.error('Lỗi khi tải hợp đồng:', error);
      toast.error('Có lỗi xảy ra');
    } finally {
      setLoading(false);
    }
  }, [accessToken]);

  useEffect(() => {
    if (accessToken) {
      void fetchContracts();
    }
  }, [accessToken, fetchContracts]);

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
  };

  const formatDate = (dateStr: string | Date) => {
    if (!dateStr) return '---';
    return new Date(dateStr).toLocaleDateString('vi-VN');
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'hoatDong':
        return <Badge className="bg-green-600">Hoạt động</Badge>;
      case 'choKichHoat':
        return <Badge variant="secondary" className="bg-yellow-100 text-yellow-800">Chờ kích hoạt</Badge>;
      case 'hetHan':
        return <Badge variant="destructive">Hết hạn</Badge>;
      case 'daKetThuc':
      case 'daHuy':
        return <Badge variant="outline">Đã kết thúc</Badge>;
      default:
        return <Badge variant="outline">Không rõ</Badge>;
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  return (
    <div className="p-4 md:p-8 max-w-6xl mx-auto space-y-6 pb-24 md:pb-8">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold tracking-tight">Hợp Đồng Của Tôi</h1>
          <p className="text-muted-foreground mt-1">Quản lý và theo dõi các hợp đồng thuê phòng</p>
        </div>
      </div>

      {contracts.length === 0 ? (
        <Card className="bg-gray-50 border-dashed border-2">
          <CardContent className="flex flex-col items-center justify-center p-12 text-center space-y-4">
            <div className="bg-gray-100 p-4 rounded-full text-gray-400">
              <FileText className="h-12 w-12" />
            </div>
            <div>
              <h3 className="font-bold text-lg text-gray-800">Chưa có hợp đồng nào</h3>
              <p className="text-sm text-gray-500 mt-1 max-w-md mx-auto">
                Bạn hiện chưa có hợp đồng thuê phòng nào được ghi nhận trên hệ thống. 
              </p>
            </div>
          </CardContent>
        </Card>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {contracts.map((contract) => (
            <Card key={contract.id || contract._id} className="flex flex-col hover:shadow-md transition-shadow">
              <CardHeader className="pb-4">
                <div className="flex justify-between items-start mb-2">
                  <div className="bg-blue-50 text-blue-700 px-2 py-1 rounded text-xs font-semibold">
                    {contract.maHopDong}
                  </div>
                  {getStatusBadge(contract.trangThai as string)}
                </div>
                <CardTitle className="text-xl flex items-center gap-2">
                  <Home className="h-5 w-5 text-blue-600" />
                  {contract.phong?.maPhong || '---'}
                </CardTitle>
                <CardDescription className="flex items-center gap-1 mt-1">
                  <span>{contract.phong?.toaNha?.tenToaNha || '---'}</span>
                </CardDescription>
              </CardHeader>
              <CardContent className="flex-1 space-y-4">
                <div className="grid grid-cols-2 gap-4 text-sm">
                  <div>
                    <p className="text-muted-foreground mb-1 text-xs uppercase tracking-wider">Thời hạn</p>
                    <div className="flex items-center gap-1 font-medium">
                      <Calendar className="h-3 w-3 text-gray-400" />
                      {formatDate(contract.ngayBatDau as string)}
                    </div>
                    <div className="text-gray-500 text-xs mt-0.5">đến {formatDate(contract.ngayKetThuc as string)}</div>
                  </div>
                  <div>
                    <p className="text-muted-foreground mb-1 text-xs uppercase tracking-wider">Tiền cọc</p>
                    <div className="font-semibold text-orange-600">
                      {formatCurrency(contract.tienCoc)}
                    </div>
                    {contract.trangThaiCoc === 'KEPT' && (
                      <div className="text-green-600 text-xs flex items-center gap-1 mt-0.5">
                        <CheckCircle2 className="h-3 w-3" /> Đã đóng
                      </div>
                    )}
                  </div>
                </div>

                <div className="bg-gray-50 p-3 rounded-lg flex items-center justify-between">
                  <div>
                    <p className="text-xs text-muted-foreground uppercase tracking-wider">Giá thuê</p>
                    <p className="font-bold text-gray-900 text-lg">
                      {formatCurrency(contract.giaThue || contract.giaThueHopDong || 0)}<span className="text-sm font-normal text-gray-500">/tháng</span>
                    </p>
                  </div>
                  <DollarSign className="h-8 w-8 text-green-200" />
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
