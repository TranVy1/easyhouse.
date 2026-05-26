'use client';

import { useState, useEffect } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle, CardFooter } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { FileText, Calendar, DollarSign, ArrowRight, CheckCircle2, AlertCircle } from 'lucide-react';
import { useSession } from 'next-auth/react';
import { toast } from 'sonner';
import { HoaDon } from '@/types';
import Link from 'next/link';

export default function TenantInvoicesPage() {
  const session = useSession()?.data;
  const [invoices, setInvoices] = useState<HoaDon[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (session?.accessToken) {
      fetchInvoices();
    }
  }, [session]);

  const fetchInvoices = async () => {
    try {
      setLoading(true);
      const res = await fetch('/api/tenant/hoa-don', {
        headers: {
          'Authorization': `Bearer ${session?.accessToken}`
        }
      });
      const data = await res.json();
      if (data.success) {
        setInvoices(data.data.data);
      } else {
        toast.error('Không thể tải danh sách hóa đơn');
      }
    } catch (error) {
      console.error('Lỗi khi tải hóa đơn:', error);
      toast.error('Có lỗi xảy ra');
    } finally {
      setLoading(false);
    }
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount || 0);
  };

  const formatDate = (dateStr: string | Date | undefined) => {
    if (!dateStr) return '---';
    return new Date(dateStr).toLocaleDateString('vi-VN');
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'daThanhToan':
      case 'thanhToanDu':
      case 'PAID':
        return <Badge className="bg-green-600">Đã thanh toán</Badge>;
      case 'chuaThanhToan':
      case 'UNPAID':
        return <Badge variant="outline" className="border-red-500 text-red-600">Chưa thanh toán</Badge>;
      case 'daThanhToanMotPhan':
      case 'PARTIAL':
        return <Badge variant="secondary" className="bg-orange-100 text-orange-800">Thanh toán 1 phần</Badge>;
      case 'quaHan':
      case 'OVERDUE':
        return <Badge variant="destructive">Quá hạn</Badge>;
      case 'nhap':
      case 'DRAFT':
        return <Badge variant="secondary">Nháp</Badge>;
      case 'daHuy':
      case 'CANCELLED':
        return <Badge variant="outline">Đã hủy</Badge>;
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
          <h1 className="text-2xl font-bold tracking-tight">Hóa Đơn Thanh Toán</h1>
          <p className="text-muted-foreground mt-1">Quản lý hóa đơn tiền phòng và dịch vụ hàng tháng</p>
        </div>
      </div>

      {invoices.length === 0 ? (
        <Card className="bg-gray-50 border-dashed border-2">
          <CardContent className="flex flex-col items-center justify-center p-12 text-center space-y-4">
            <div className="bg-gray-100 p-4 rounded-full text-gray-400">
              <FileText className="h-12 w-12" />
            </div>
            <div>
              <h3 className="font-bold text-lg text-gray-800">Chưa có hóa đơn nào</h3>
              <p className="text-sm text-gray-500 mt-1 max-w-md mx-auto">
                Bạn chưa có hóa đơn nào cần thanh toán. Các hóa đơn sẽ tự động xuất hiện tại đây khi đến kỳ thanh toán.
              </p>
            </div>
          </CardContent>
        </Card>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {invoices.map((invoice) => {
            const id = invoice.id || invoice._id;
            const trangThai = invoice.trangThai as string;
            const isPaid = trangThai === 'PAID' || trangThai === 'daThanhToan' || trangThai === 'thanhToanDu';
            
            return (
              <Card key={id as string} className="flex flex-col hover:shadow-md transition-shadow relative overflow-hidden">
                {isPaid && (
                  <div className="absolute top-0 right-0 w-16 h-16 pointer-events-none">
                    <div className="absolute transform rotate-45 bg-green-500 text-white text-xs py-1 right-[-35px] top-[12px] w-[120px] text-center font-bold shadow-sm">
                      ĐÃ TRẢ
                    </div>
                  </div>
                )}
                
                <CardHeader className="pb-3">
                  <div className="flex justify-between items-start mb-2 pr-6">
                    <div className="bg-gray-100 text-gray-700 px-2 py-1 rounded text-xs font-mono font-semibold">
                      {invoice.maHoaDon}
                    </div>
                    {getStatusBadge(trangThai)}
                  </div>
                  <CardTitle className="text-xl">
                    Kỳ tháng {invoice.thang || invoice.kyThang}/{invoice.nam || invoice.kyNam}
                  </CardTitle>
                  <CardDescription className="flex items-center gap-1 mt-1">
                    <Calendar className="h-3 w-3" /> Hạn thanh toán: {formatDate(invoice.hanTra || invoice.hanThanhToan)}
                  </CardDescription>
                </CardHeader>
                
                <CardContent className="flex-1 space-y-4">
                  <div className="space-y-2">
                    <div className="flex justify-between text-sm">
                      <span className="text-gray-500">Tổng hóa đơn:</span>
                      <span className="font-medium text-gray-900">{formatCurrency(invoice.tongTien)}</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span className="text-gray-500">Đã thanh toán:</span>
                      <span className="font-medium text-green-600">{formatCurrency(invoice.daTra || invoice.daThanhToan || 0)}</span>
                    </div>
                    <div className="flex justify-between text-base font-bold pt-2 border-t border-gray-100">
                      <span className="text-gray-900">Cần thanh toán:</span>
                      <span className={isPaid ? "text-green-600" : "text-red-600"}>
                        {formatCurrency(invoice.conLai)}
                      </span>
                    </div>
                  </div>
                </CardContent>
                
                <CardFooter className="pt-0">
                  <Button asChild variant={isPaid ? "outline" : "default"} className="w-full">
                    <Link href={`/khach-thue/dashboard/hoa-don/${id}`}>
                      {isPaid ? 'Xem chi tiết' : 'Thanh toán ngay'} <ArrowRight className="ml-2 h-4 w-4" />
                    </Link>
                  </Button>
                </CardFooter>
              </Card>
            );
          })}
        </div>
      )}
    </div>
  );
}
