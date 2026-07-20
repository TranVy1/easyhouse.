'use client';

import { useState, useEffect, useCallback } from 'react';
import Image from 'next/image';
import { useParams, useRouter } from 'next/navigation';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { ArrowLeft, Calendar, FileText, Clock, Banknote, Settings, Printer, Share2, Phone, CheckCircle2 } from 'lucide-react';
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
  const tenPhong = typeof invoice.phong === 'object' && invoice.phong !== null
    ? ((invoice.phong as any).ten || (invoice.phong as any).maPhong || 'Phòng thuê')
    : 'Phòng thuê';
  const tenNhaTro = typeof invoice.phong === 'object' && invoice.phong !== null
    ? ((invoice.phong as any).nhaTro?.ten || '---')
    : '---';
  const tenKhach = typeof invoice.khachThue === 'object' && invoice.khachThue !== null
    ? ((invoice.khachThue as any).hoTen || '---')
    : '---';

  const trangThaiConfig: Record<string, { label: string; color: string; bg: string }> = {
    chuaThanhToan: { label: 'Chưa thu', color: '#D97706', bg: '#FEF3C7' },
    daThanhToanMotPhan: { label: 'Thu một phần', color: '#2563EB', bg: '#DBEAFE' },
    daThanhToan: { label: 'Đã thu xong', color: '#16A34A', bg: '#DCFCE7' },
    quaHan: { label: 'Quá hạn', color: '#DC2626', bg: '#FEE2E2' },
    PAID: { label: 'Đã thu xong', color: '#16A34A', bg: '#DCFCE7' },
    UNPAID: { label: 'Chưa thu', color: '#D97706', bg: '#FEF3C7' },
    PARTIAL: { label: 'Thu một phần', color: '#2563EB', bg: '#DBEAFE' },
    OVERDUE: { label: 'Quá hạn', color: '#DC2626', bg: '#FEE2E2' },
  };
  const tsConf = trangThaiConfig[invoice.trangThai as string] || trangThaiConfig.chuaThanhToan;

  const ngayTao = invoice.ngayTao || invoice.taoLuc
    ? new Date(String(invoice.ngayTao || invoice.taoLuc)).toLocaleDateString('vi-VN')
    : '---';
  const hanThanhToanDate = invoice.hanTra || invoice.hanThanhToan
    ? new Date(String(invoice.hanTra || invoice.hanThanhToan)).toLocaleDateString('vi-VN')
    : '---';

  // Fallback for services if not array
  const phiDichVu = Array.isArray(invoice.phiDichVu) ? invoice.phiDichVu : [];
  const totalDichVu = phiDichVu.reduce((sum: number, p: any) => sum + (p.gia || 0), 0);

  const soDienSD = Math.max(0, (invoice.chiSoDienCuoiKy || 0) - (invoice.chiSoDienBanDau || 0));
  const soNuocSD = Math.max(0, (invoice.chiSoNuocCuoiKy || 0) - (invoice.chiSoNuocBanDau || 0));

  // Determine what services exist
  const hasDien = (invoice.tienDien || 0) > 0;
  const hasNuoc = (invoice.tienNuoc || 0) > 0;
  const hasOtherDichVu = phiDichVu.length > 0;
  const hasAnyServiceSection = hasDien || hasNuoc || hasOtherDichVu;
  const overallServiceTotal = (invoice.tienDien || 0) + (invoice.tienNuoc || 0) + totalDichVu;

  return (
    <div className="bg-[#F6F7F9] min-h-screen pb-24 md:pb-8 font-sans">
      {/* Top bar (Floating Card) */}
      <div className="sticky top-4 z-10 max-w-3xl mx-auto px-4 pt-2">
        <div className="bg-white rounded-[20px] shadow-sm border border-gray-200 flex items-center justify-between p-3 px-4">
          <button
            onClick={() => router.push('/khach-thue/dashboard/hoa-don')}
            className="flex items-center justify-center w-10 h-10 rounded-full bg-gray-50 hover:bg-gray-100 transition-colors"
          >
            <ArrowLeft className="h-5 w-5 text-gray-700" />
          </button>
          <h1 className="text-[17px] font-bold text-gray-800">Chi tiết hóa đơn</h1>
          <button className="flex items-center justify-center w-10 h-10 rounded-full bg-gray-50 hover:bg-gray-100 transition-colors">
            <Settings className="h-5 w-5 text-gray-700" />
          </button>
        </div>
      </div>
      <div className="max-w-3xl mx-auto px-4 py-6 space-y-5">


        {/* Main Receipt Card */}
        <div className="bg-white rounded-[24px] shadow-sm border border-gray-200 overflow-hidden relative">
          {/* Header */}
          <div className="p-6 text-center">
            <h2 className="text-[22px] font-bold text-gray-900">{tenPhong}</h2>
            <p className="text-[15px] font-medium text-gray-600 mt-1">Khách thuê: {tenKhach}</p>
          </div>

          {/* Meta Grid */}
          <div className="grid grid-cols-3 divide-x divide-gray-200 border-t border-b border-gray-200 mx-5 rounded-[14px] overflow-hidden mb-6 border">
            <div className="px-2 py-3.5 text-center bg-gray-50/50">
              <p className="text-[11.5px] text-gray-500 mb-1.5">Hóa đơn tháng</p>
              <p className="text-[13px] font-semibold text-gray-900">T.{invoice.thang || invoice.kyThang}, {invoice.nam || invoice.kyNam}</p>
            </div>
            <div className="px-2 py-3.5 text-center bg-white">
              <p className="text-[11.5px] text-gray-500 mb-1.5">Ngày lập hóa đơn</p>
              <p className="text-[13px] font-semibold text-gray-900">{ngayTao}</p>
            </div>
            <div className="px-2 py-3.5 text-center bg-gray-50/50">
              <p className="text-[11.5px] text-gray-500 mb-1.5">Hạn nạp tiền</p>
              <p className="text-[13px] font-semibold text-gray-900">{hanThanhToanDate}</p>
            </div>
          </div>

          <div className="px-5 space-y-4">
            {/* Lý do thu */}
            <div className="flex items-start justify-between py-2">
              <div>
                <p className="text-[14px] text-gray-600 mb-1.5">Lý do thu</p>
                <p className="text-[15px] font-bold text-gray-900">Tiền phòng tháng {invoice.thang || invoice.kyThang}</p>
              </div>
              <div className="flex flex-col items-end gap-2">
                <span className="px-3 py-1 rounded-full text-[12px] font-semibold flex items-center gap-1.5" style={{ color: tsConf.color, backgroundColor: tsConf.bg }}>
                  <span className="w-1.5 h-1.5 rounded-full" style={{ backgroundColor: tsConf.color }}></span>
                  {tsConf.label}
                </span>

              </div>
            </div>

            {/* Tiền thuê nhà */}
            {invoice.chiTietHoaDon && invoice.chiTietHoaDon.some((c: any) => c.loai === 'TIEN_PHONG') ? (
              invoice.chiTietHoaDon.filter((c: any) => c.loai === 'TIEN_PHONG').map((c: any, idx: number) => (
                <div key={idx} className="flex items-start justify-between py-3 border-t border-gray-100">
                  <div>
                    <p className="text-[15px] font-semibold text-gray-800">Tiền thuê nhà</p>
                    <p className="text-[14px] font-bold text-gray-900 mt-1">{c.moTa}</p>
                    {c.soLuong > 1 && (
                      <p className="text-[12px] text-gray-500 mt-1">{c.soLuong} × {formatCurrency(c.donGia)}</p>
                    )}
                  </div>
                  <div className="text-right">
                    <p className="text-[13px] text-gray-500 mb-0.5">Thành tiền</p>
                    <p className="text-[16px] font-bold text-gray-900">{formatCurrency(c.thanhTien)}</p>
                  </div>
                </div>
              ))
            ) : (
              <div className="flex items-start justify-between py-3 border-t border-gray-100">
                <div>
                  <p className="text-[15px] font-semibold text-gray-800">Tiền thuê nhà</p>
                  <p className="text-[14px] text-gray-500 mt-1">1 tháng</p>
                </div>
                <div className="text-right">
                  <p className="text-[13px] text-gray-500 mb-0.5">Thành tiền</p>
                  <p className="text-[16px] font-bold text-gray-900">{formatCurrency(invoice.tienPhong || 0)}</p>
                </div>
              </div>
            )}

            {/* Thu tiền cọc */}
            {invoice.chiTietHoaDon && invoice.chiTietHoaDon.some((c: any) => c.loai === 'TIEN_COC') && (
              <>
                <div className="h-[1px] bg-gray-100 w-full" />
                {invoice.chiTietHoaDon.filter((c: any) => c.loai === 'TIEN_COC').map((c: any, idx: number) => (
                  <div key={idx} className="flex items-start justify-between py-3">
                    <div>
                      <p className="text-[15px] font-semibold text-gray-800">Thu tiền cọc</p>
                      {c.moTa && c.moTa !== 'Thu tiền cọc' && <p className="text-[14px] text-gray-500 mt-1">{c.moTa}</p>}
                    </div>
                    <div className="text-right">
                      <p className="text-[13px] text-gray-500 mb-0.5">Thành tiền</p>
                      <p className="text-[16px] font-bold text-gray-900">{formatCurrency(c.thanhTien)}</p>
                    </div>
                  </div>
                ))}
              </>
            )}

            {/* Tiền điện */}
            <div className="flex justify-between items-start py-4 border-t border-gray-100">
              <div>
                <p className="text-[15px] font-bold text-gray-900">Tiền điện</p>
                <p className="text-[13px] text-gray-500 mt-0.5 mb-1.5">Số mới: {invoice.chiSoDienCuoiKy || 0} - Số cũ: {invoice.chiSoDienBanDau || 0}</p>
                {invoice.chiTietHoaDon?.find((c: any) => c.loai === 'TIEN_DIEN') ? (
                  <span className="inline-flex items-center px-2.5 py-1 rounded-full bg-[#F0FDF4] text-gray-800 text-[13px] font-medium">
                    <span className="w-1.5 h-1.5 rounded-full bg-gray-400 mr-2"></span>
                    {invoice.chiTietHoaDon!.find((c: any) => c.loai === 'TIEN_DIEN')?.soLuong} KWh x {formatCurrency(invoice.chiTietHoaDon!.find((c: any) => c.loai === 'TIEN_DIEN')?.donGia || 0).replace(' đ', '')}đ
                  </span>
                ) : (
                  <span className="inline-flex items-center px-2.5 py-1 rounded-full bg-[#F0FDF4] text-gray-800 text-[13px] font-medium">
                    <span className="w-1.5 h-1.5 rounded-full bg-gray-400 mr-2"></span>
                    {soDienSD} KWh
                  </span>
                )}
              </div>
              <div className="text-right">
                <p className="text-[13px] text-gray-500 mb-0.5">Thành tiền</p>
                <p className="text-[16px] font-bold text-gray-900">{formatCurrency(invoice.tienDien || 0)}</p>
              </div>
            </div>

            {/* Tiền nước */}
            <div className="flex justify-between items-start py-4 border-t border-gray-100">
              <div>
                <p className="text-[15px] font-bold text-gray-900">Tiền nước</p>
                {(invoice.chiSoNuocCuoiKy > 0 || invoice.chiSoNuocBanDau > 0) && (
                  <p className="text-[13px] text-gray-500 mt-0.5 mb-1.5">Số mới: {invoice.chiSoNuocCuoiKy || 0} - Số cũ: {invoice.chiSoNuocBanDau || 0}</p>
                )}
                {invoice.chiTietHoaDon?.find((c: any) => c.loai === 'TIEN_NUOC') ? (
                  <span className="inline-flex items-center px-2.5 py-1 rounded-full bg-[#F0FDF4] text-gray-800 text-[13px] font-medium">
                    <span className="w-1.5 h-1.5 rounded-full bg-gray-400 mr-2"></span>
                    {invoice.chiTietHoaDon!.find((c: any) => c.loai === 'TIEN_NUOC')?.soLuong} khối x {formatCurrency(invoice.chiTietHoaDon!.find((c: any) => c.loai === 'TIEN_NUOC')?.donGia || 0).replace(' đ', '')}đ
                  </span>
                ) : (
                  <span className="inline-flex items-center px-2.5 py-1 rounded-full bg-[#F0FDF4] text-gray-800 text-[13px] font-medium">
                    <span className="w-1.5 h-1.5 rounded-full bg-gray-400 mr-2"></span>
                    {soNuocSD} khối
                  </span>
                )}
              </div>
              <div className="text-right">
                <p className="text-[13px] text-gray-500 mb-0.5">Thành tiền</p>
                <p className="text-[16px] font-bold text-gray-900">{formatCurrency(invoice.tienNuoc || 0)}</p>
              </div>
            </div>

            {/* Dịch vụ khác */}
            {phiDichVu.map((phi: any, i: number) => {
              const matchChiTiet = invoice.chiTietHoaDon?.find((c: any) => c.loai === 'TIEN_DICH_VU' && c.moTa?.includes(phi.ten));
              return (
                <div key={i} className="flex justify-between items-start py-4 border-t border-gray-100">
                  <div>
                    <p className="text-[15px] font-bold text-gray-900">{phi.ten}</p>
                    <span className="inline-flex items-center px-2.5 py-1 rounded-full bg-[#F0FDF4] text-gray-800 text-[13px] font-medium mt-1">
                      <span className="w-1.5 h-1.5 rounded-full bg-gray-400 mr-2"></span>
                      {matchChiTiet?.moTa || 'Phí dịch vụ'}
                    </span>
                  </div>
                  <div className="text-right">
                    <p className="text-[13px] text-gray-500 mb-0.5">Thành tiền</p>
                    <p className="text-[16px] font-bold text-gray-900">{formatCurrency(phi.gia || 0)}</p>
                  </div>
                </div>
              );
            })}

            <div className="h-[1px] bg-gray-200 w-full" />

            {/* Other line items from chiTietHoaDon just in case */}
            {invoice.chiTietHoaDon && invoice.chiTietHoaDon.filter((c: any) => c.loai !== 'TIEN_PHONG' && c.loai !== 'TIEN_DIEN' && c.loai !== 'TIEN_NUOC' && c.loai !== 'TIEN_DICH_VU').map((item, idx) => (
              <div key={idx} className="flex items-start justify-between py-2 border-b border-gray-100 last:border-0">
                <div>
                  <p className="text-[15px] font-medium text-gray-800">{item.moTa}</p>
                  {item.soLuong > 1 && (
                    <span className="inline-block mt-1.5 text-[12px] font-medium text-gray-600 bg-gray-100 px-2 py-0.5 rounded-full">
                      {item.soLuong} × {formatCurrency(item.donGia)}
                    </span>
                  )}
                </div>
                <div className="text-right">
                  <p className="text-[13px] text-gray-500">Thành tiền</p>
                  <p className="text-[17px] font-bold text-gray-900 mt-1">{formatCurrency(item.thanhTien)}</p>
                </div>
              </div>
            ))}

            <div className="flex flex-col items-end pb-5 pt-3">
              <p className="text-[14px] text-gray-600 mb-1.5">Tổng cộng kỳ này</p>
              <p className="text-[22px] font-extrabold text-gray-900">{formatCurrency(invoice.tongTien || 0)}</p>
            </div>
          </div>
          {/* Edge shadow overlay for right side scroll indication (optional) */}
          <div className="absolute top-0 bottom-0 right-0 w-1 bg-gradient-to-l from-black/5 to-transparent pointer-events-none"></div>
        </div>

        {/* Đã trả & Số lần thanh toán */}
        <div className="flex flex-col items-end px-2 pt-2 pb-1">
          <p className="text-[14px] text-gray-600 mb-1">Đã trả</p>
          <p className="text-[22px] font-bold text-[#16A34A]">{formatCurrency(invoice.daTra || invoice.daThanhToan || 0)}</p>
        </div>

        <div className="bg-[#F0FDF4] border border-[#86EFAC] rounded-xl p-4 flex items-center justify-between shadow-sm relative">
          <div>
            <p className="text-[14px] text-gray-800 font-medium">Số lần thanh toán</p>
            <a href="#payment-history" className="text-[14px] text-[#2563EB] hover:underline mt-1 inline-block">
              {payments.length} lần, nhấp để xem
            </a>
          </div>
          <div className="text-right">
            <p className="text-[14px] text-gray-800 font-medium mb-1">Tổng phải thu</p>
            {isPaid ? (
              <span className="text-[14px] font-semibold text-[#16A34A] flex items-center justify-end gap-1.5">
                <CheckCircle2 className="h-4 w-4" />
                Đã thu xong
              </span>
            ) : (
              <span className="text-[14px] font-semibold text-red-600">
                Còn nợ {formatCurrency(invoice.conLai)}
              </span>
            )}
          </div>
          {/* Vertical right accent line as seen in image */}
          <div className="absolute top-3 bottom-3 right-0 w-[3px] bg-gray-300 rounded-l-full"></div>
        </div>

        {/* VNPay Payment Button (if unpaid) */}
        {!isPaid && (
          <div className="pt-2">
            <Button
              className="w-full bg-[#243B5A] hover:bg-[#1B2E47] text-white py-6 text-[16px] font-semibold rounded-xl shadow-md"
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
              <Banknote className="mr-2 h-5 w-5" /> Thanh toán bằng VNPay
            </Button>
          </div>
        )}

        {/* Lịch sử thanh toán */}
        <div id="payment-history" className="pt-4 space-y-4">
          {payments.length > 0 && (
            <div className="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
              <div className="px-5 py-4 bg-gray-50/80 border-b border-gray-200 flex items-center gap-2">
                <Clock className="h-5 w-5 text-gray-600" />
                <h3 className="text-[15px] font-bold text-gray-800">Lịch sử giao dịch</h3>
              </div>
              <div className="divide-y divide-gray-100">
                {payments.map((payment, idx) => (
                  <div key={idx} className="p-5 flex flex-col gap-3">
                    <div className="flex justify-between items-start">
                      <div>
                        <p className="text-[16px] font-bold text-green-600">{formatCurrency(payment.soTien)}</p>
                        <p className="text-[13px] text-gray-500 mt-1">
                          {formatDate(payment.ngayThanhToan)}
                        </p>
                      </div>
                      {getPaymentStatusBadge(payment.trangThai)}
                    </div>

                    {payment.ghiChu && (
                      <p className="text-[13px] text-gray-700 bg-gray-50 p-3 rounded-lg border border-gray-100 mt-1">
                        {payment.ghiChu}
                      </p>
                    )}

                    {payment.anhBienLai && (
                      <div className="relative mt-2 h-24 w-24 overflow-hidden rounded-lg border border-gray-200 shadow-sm">
                        <Image
                          src={payment.anhBienLai}
                          alt="Biên lai"
                          fill
                          sizes="96px"
                          className="object-cover hover:scale-105 transition-transform duration-300"
                        />
                      </div>
                    )}
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
