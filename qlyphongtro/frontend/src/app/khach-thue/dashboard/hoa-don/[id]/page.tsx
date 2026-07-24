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
import { ChiTietHoaDon, HoaDon, ThanhToan } from '@/types';
import Link from 'next/link';

const invoiceLineLabels: Record<string, string> = {
  ROOM: 'Tiền thuê nhà',
  ELECTRICITY: 'Tiền điện',
  WATER: 'Tiền nước',
  SERVICE: 'Phí dịch vụ',
  INTERNET: 'Internet',
  GARBAGE: 'Phí rác',
  PARKING: 'Phí gửi xe',
  MAINTENANCE: 'Phí bảo trì',
  DEBT: 'Công nợ',
  DISCOUNT: 'Giảm trừ',
  DEPOSIT: 'Tiền cọc hợp đồng',
  BALCONY: 'Phí ban công',
  TRASH: 'Phí rác',
  AIR_CONDITIONER: 'Điều hòa',
  WASHING_MACHINE: 'Máy giặt',
  REFRIGERATOR: 'Tủ lạnh',
  WATER_HEATER: 'Bình nóng lạnh',
  BED: 'Giường',
  WARDROBE: 'Tủ quần áo',
  TABLE_CHAIR: 'Bàn ghế',
  KITCHEN: 'Bếp',
  KITCHEN_SHELF: 'Kệ bếp',
  CLEANING: 'Vệ sinh',
  LAUNDRY: 'Giặt là',
  SMART_LOCK: 'Khóa thông minh',
  SECURITY_CAMERA: 'Camera an ninh',
  OTHER: 'Khoản thu khác',
};

const meterUnits: Record<string, string> = {
  ELECTRICITY: 'kWh',
  WATER: 'm³',
};

const toNumber = (value: unknown) => {
  const numberValue = Number(value);
  return Number.isFinite(numberValue) ? numberValue : 0;
};

const formatQuantity = (value: unknown) => new Intl.NumberFormat('vi-VN', {
  maximumFractionDigits: 2,
}).format(toNumber(value));

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

  const invoiceItems = (invoice.chiTietHoaDon?.length
    ? invoice.chiTietHoaDon
    : invoice.chiTiet || []) as ChiTietHoaDon[];

  const getMeterReadings = (item: ChiTietHoaDon) => {
    const isElectricity = item.loai === 'ELECTRICITY';
    const isWater = item.loai === 'WATER';
    if (!isElectricity && !isWater) return null;

    const oldReading = isElectricity ? invoice.chiSoDienBanDau : invoice.chiSoNuocBanDau;
    const newReading = isElectricity ? invoice.chiSoDienCuoiKy : invoice.chiSoNuocCuoiKy;
    if (oldReading !== null && oldReading !== undefined && newReading !== null && newReading !== undefined) {
      return { oldReading, newReading };
    }

    const range = item.moTa?.match(/(\d+)\s*-\s*(\d+)\s*$/);
    return range ? { oldReading: Number(range[1]), newReading: Number(range[2]) } : null;
  };

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

            <div className="border border-gray-200 rounded-xl overflow-hidden">
              <div className="px-4 py-3 border-b border-gray-200 bg-gray-50">
                <h3 className="text-[15px] font-bold text-gray-900">Bảng chi tiết các khoản thu</h3>
                <p className="text-[12px] text-gray-500 mt-0.5">Chỉ số áp dụng cho tiền điện và tiền nước.</p>
              </div>
              <div className="overflow-x-auto">
                <table className="w-full min-w-[720px] text-[13px]">
                  <thead className="bg-slate-50 text-slate-600">
                    <tr className="border-b border-gray-200">
                      <th className="px-4 py-3 text-left font-semibold">Khoản thu</th>
                      <th className="px-3 py-3 text-right font-semibold">Chỉ số cũ</th>
                      <th className="px-3 py-3 text-right font-semibold">Chỉ số mới</th>
                      <th className="px-3 py-3 text-right font-semibold">Đã dùng / SL</th>
                      <th className="px-3 py-3 text-right font-semibold">Đơn giá</th>
                      <th className="px-4 py-3 text-right font-semibold">Thành tiền</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {invoiceItems.length > 0 ? invoiceItems.map((item, index) => {
                      const readings = getMeterReadings(item);
                      const unit = meterUnits[item.loai] || '';
                      const label = invoiceLineLabels[item.loai] || item.loai || 'Khoản thu khác';
                      const showDescription = !readings && item.moTa
                        && item.moTa.trim().toLocaleLowerCase('vi-VN') !== label.toLocaleLowerCase('vi-VN');

                      return (
                        <tr key={item._id || item.id || `${item.loai}-${index}`} className="align-top hover:bg-slate-50/70">
                          <td className="px-4 py-3.5">
                            <p className="font-semibold text-gray-900">{label}</p>
                            {showDescription && <p className="mt-1 text-[12px] text-gray-500">{item.moTa}</p>}
                          </td>
                          <td className="px-3 py-3.5 text-right text-gray-700">{readings ? formatQuantity(readings.oldReading) : '—'}</td>
                          <td className="px-3 py-3.5 text-right text-gray-700">{readings ? formatQuantity(readings.newReading) : '—'}</td>
                          <td className="px-3 py-3.5 text-right font-medium text-gray-900">
                            {formatQuantity(item.soLuong)}{unit ? ` ${unit}` : ''}
                          </td>
                          <td className="px-3 py-3.5 text-right text-gray-700">{formatCurrency(toNumber(item.donGia))}</td>
                          <td className="px-4 py-3.5 text-right font-bold text-gray-900">{formatCurrency(toNumber(item.thanhTien))}</td>
                        </tr>
                      );
                    }) : (
                      <tr>
                        <td colSpan={6} className="px-4 py-8 text-center text-gray-500">Chưa có dòng chi tiết cho hóa đơn này.</td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>

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
