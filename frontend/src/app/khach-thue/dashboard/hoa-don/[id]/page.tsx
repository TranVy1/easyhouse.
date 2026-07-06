'use client';

import { useState, useEffect, useCallback } from 'react';
import Image from 'next/image';
import { useParams, useRouter } from 'next/navigation';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { ArrowLeft, Calendar, FileText, Clock, Banknote } from 'lucide-react';
import { useSession } from 'next-auth/react';
import { toast } from 'sonner';
import { HoaDon, ThanhToan } from '@/types';
import Link from 'next/link';

export default function TenantInvoiceDetailPage() {
  const { id } = useParams();
  const router = useRouter();
  const session = useSession()?.data;
  const accessToken = session?.accessToken;
  const [invoice, setInvoice] = useState<HoaDon | null>(null);
  const [payments, setPayments] = useState<ThanhToan[]>([]);
  const [loading, setLoading] = useState(true);

  const fetchInvoiceDetail = useCallback(async () => {
    try {
      setLoading(true);
      const res = await fetch(`/api/tenant/hoa-don/${id}`, {
        headers: {
          'Authorization': `Bearer ${accessToken}`
        }
      });
      const data = await res.json();
      if (data.success && data.data) {
        setInvoice(data.data.hoaDon);
        setPayments(data.data.thanhToanList || []);
      } else {
        toast.error('Không thể tải chi tiết hóa đơn');
        router.push('/khach-thue/dashboard/hoa-don');
      }
    } catch (error) {
      console.error('Lỗi khi tải chi tiết hóa đơn:', error);
      toast.error('Có lỗi xảy ra');
    } finally {
      setLoading(false);
    }
  }, [accessToken, id, router]);

  useEffect(() => {
    if (accessToken && id) {
      void fetchInvoiceDetail();
    }
  }, [accessToken, id, fetchInvoiceDetail]);

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

  const getPaymentStatusBadge = (status: string | undefined) => {
    if (!status) return <Badge variant="outline">Không rõ</Badge>;
    switch (status) {
      case 'SUCCESS':
        return <Badge className="bg-green-600">Thành công</Badge>;
      case 'PENDING':
        return <Badge variant="secondary" className="bg-yellow-100 text-yellow-800">Chờ duyệt</Badge>;
      case 'FAILED':
      case 'CANCELLED':
        return <Badge variant="destructive">Bị từ chối</Badge>;
      default:
        return <Badge variant="outline">{status}</Badge>;
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#4FA7A0]"></div>
      </div>
    );
  }

  if (!invoice) return null;

  const trangThai = invoice.trangThai as string;
  const isPaid = trangThai === 'PAID' || trangThai === 'daThanhToan' || trangThai === 'thanhToanDu';
  return (
    <div className="p-4 md:p-8 max-w-4xl mx-auto space-y-6 pb-24 md:pb-8">
      <Button variant="ghost" size="sm" asChild className="mb-4">
        <Link href="/khach-thue/dashboard/hoa-don">
          <ArrowLeft className="mr-2 h-4 w-4" />
          Quay lại danh sách
        </Link>
      </Button>

      {/* Header Info */}
      <Card className="border-t-4 border-t-blue-600">
        <CardHeader className="pb-4">
          <div className="flex justify-between items-start mb-2">
            <div className="bg-gray-100 text-gray-700 px-3 py-1.5 rounded-md text-sm font-mono font-semibold">
              HD: {invoice.maHoaDon}
            </div>
            {getStatusBadge(trangThai)}
          </div>
          <CardTitle className="text-2xl pt-2">
            Hóa đơn Tháng {invoice.thang || invoice.kyThang}/{invoice.nam || invoice.kyNam}
          </CardTitle>
          <CardDescription className="flex flex-col gap-2 mt-2">
            <div className="flex items-center text-gray-600">
              <Calendar className="h-4 w-4 mr-2" /> Hạn thanh toán: <strong className="ml-1 text-gray-900">{formatDate(invoice.hanTra || invoice.hanThanhToan)}</strong>
            </div>
            {invoice.hopDong && typeof invoice.hopDong === 'string' && (
              <div className="flex items-center mt-1">
                <Button variant="link" className="p-0 h-auto text-blue-600 hover:text-blue-800" asChild>
                  <Link href={`/khach-thue/dashboard/hop-dong/${invoice.hopDong}`}>
                    <FileText className="h-4 w-4 mr-1" />
                    Xem hợp đồng liên quan
                  </Link>
                </Button>
              </div>
            )}
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 p-4 bg-gray-50 rounded-xl border">
            <div>
              <p className="text-xs text-muted-foreground uppercase tracking-wider mb-1">Tổng tiền</p>
              <p className="font-bold text-gray-900 text-lg">{formatCurrency(invoice.tongTien)}</p>
            </div>
            <div>
              <p className="text-xs text-muted-foreground uppercase tracking-wider mb-1">Đã trả</p>
              <p className="font-bold text-green-600 text-lg">{formatCurrency(invoice.daTra || invoice.daThanhToan || 0)}</p>
            </div>
            <div className="md:col-span-2 text-right border-t md:border-t-0 md:border-l pt-3 md:pt-0 pl-0 md:pl-4">
              <p className="text-xs text-muted-foreground uppercase tracking-wider mb-1">Cần thanh toán</p>
              <p className={`font-bold text-2xl ${isPaid ? 'text-green-600' : 'text-red-600'}`}>
                {formatCurrency(invoice.conLai)}
              </p>
            </div>
          </div>
        </CardContent>
      </Card>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Line Items */}
        <Card className="md:col-span-1 h-fit">
          <CardHeader>
            <CardTitle className="text-lg flex items-center gap-2">
              <FileText className="h-5 w-5" />
              Chi tiết các khoản phí
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {invoice.chiTietHoaDon?.map((item, idx) => (
                <div key={idx} className="flex justify-between items-center py-2 border-b last:border-0 last:pb-0">
                  <div className="flex-1 pr-4">
                    <p className="font-medium text-gray-900">{item.moTa}</p>
                    <p className="text-xs text-gray-500 mt-1">
                      {item.soLuong} x {formatCurrency(item.donGia)}
                    </p>
                  </div>
                  <div className="font-semibold text-gray-900">
                    {formatCurrency(item.thanhTien)}
                  </div>
                </div>
              ))}
              
              {(!invoice.chiTietHoaDon || invoice.chiTietHoaDon.length === 0) && (
                <div className="text-center text-gray-500 py-4">Không có chi tiết</div>
              )}
            </div>
          </CardContent>
        </Card>

        <div className="space-y-6">
          {/* Thanh toán trực tuyến VNPay */}
          {!isPaid && (
            <Card className="border-orange-200 bg-orange-50/50">
              <CardHeader className="pb-3 border-b border-orange-100">
                <CardTitle className="text-lg flex items-center gap-2 text-orange-800">
                  <Banknote className="h-5 w-5" />
                  Thanh toán trực tuyến
                </CardTitle>
              </CardHeader>
              <CardContent className="pt-4 space-y-4">
                <div className="bg-white p-4 rounded-lg border text-center">
                  <p className="text-sm text-gray-600 mb-2">Số tiền cần thanh toán:</p>
                  <p className="text-2xl font-bold text-red-600 mb-4">{formatCurrency(invoice.conLai)}</p>
                  <Button 
                    className="w-full bg-[#243B5A] hover:bg-[#1B2E47] text-white" 
                    onClick={async () => {
                      try {
                        const res = await fetch(`/api/vnpay/create-payment-url?hoaDonId=${invoice._id || invoice.id}&amount=${invoice.conLai}`);
                        const data = await res.json();
                        if (data.success && data.data) {
                          window.location.href = data.data;
                        } else {
                          toast.error("Không thể khởi tạo thanh toán VNPay");
                        }
                      } catch (error) {
                        toast.error("Lỗi khi kết nối đến server");
                      }
                    }}
                  >
                    Thanh toán bằng VNPay
                  </Button>
                  <p className="text-xs text-gray-500 mt-4">
                    Giao dịch sẽ được gạch nợ tự động ngay sau khi thanh toán thành công.
                  </p>
                </div>
              </CardContent>
            </Card>
          )}

          {/* Lịch sử thanh toán */}
          {payments.length > 0 && (
            <Card>
              <CardHeader className="pb-3 border-b">
                <CardTitle className="text-lg flex items-center gap-2">
                  <Clock className="h-5 w-5" />
                  Lịch sử giao dịch
                </CardTitle>
              </CardHeader>
              <CardContent className="pt-4 p-0">
                <div className="divide-y">
                  {payments.map((payment, idx) => (
                    <div key={idx} className="p-4 flex flex-col gap-2">
                      <div className="flex justify-between items-start">
                        <div>
                          <p className="font-bold text-green-600">{formatCurrency(payment.soTien)}</p>
                          <p className="text-xs text-gray-500 mt-0.5">
                            {formatDate(payment.ngayThanhToan)}
                          </p>
                        </div>
                        {getPaymentStatusBadge(payment.trangThai)}
                      </div>
                      
                      {payment.ghiChu && (
                        <p className="text-sm text-gray-600 bg-gray-50 p-2 rounded mt-1 text-xs">
                          {payment.ghiChu}
                        </p>
                      )}
                      
                      {payment.anhBienLai && (
                        <div className="relative mt-2 h-20 w-20 overflow-hidden rounded border">
                          <Image
                            src={payment.anhBienLai} 
                            alt="Biên lai" 
                            fill
                            sizes="80px"
                            className="object-cover"
                          />
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          )}
        </div>
      </div>
    </div>
  );
}
