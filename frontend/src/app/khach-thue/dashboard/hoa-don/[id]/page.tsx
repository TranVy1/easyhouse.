'use client';

import { useState, useEffect, useCallback } from 'react';
import Image from 'next/image';
import { useParams, useRouter } from 'next/navigation';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { 
  ArrowLeft, 
  Calendar, 
  FileText, 
  Clock, 
  Banknote, 
  Settings, 
  Printer, 
  Share2, 
  Phone, 
  CheckCircle2, 
  QrCode, 
  Copy, 
  Check, 
  Zap, 
  Droplets, 
  Wrench, 
  Car, 
  ShieldAlert, 
  Home
} from 'lucide-react';
import { useSession } from 'next-auth/react';
import { toast } from 'sonner';
import { ChiTietHoaDon, HoaDon, ThanhToan } from '@/types';
import Link from 'next/link';

const invoiceLineLabels: Record<string, string> = {
  ROOM: 'Tiền thuê nhà',
  ELECTRICITY: 'Tiền điện',
  WATER: 'Tiền nước',
  SERVICE: 'Phí dịch vụ',
  INTERNET: 'Internet / Wifi',
  GARBAGE: 'Phí rác',
  PARKING: 'Phí gửi xe',
  MAINTENANCE: 'Phí bảo trì',
  DEBT: 'Nợ cũ kỳ trước',
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
  const [copiedField, setCopiedField] = useState<string | null>(null);

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

  const copyToClipboard = (text: string, fieldName: string) => {
    navigator.clipboard.writeText(text);
    setCopiedField(fieldName);
    toast.success(`Đã sao chép ${fieldName}`);
    setTimeout(() => setCopiedField(null), 2000);
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'daThanhToan':
      case 'thanhToanDu':
      case 'PAID':
        return <Badge className="bg-emerald-600 text-white hover:bg-emerald-700">Đã thanh toán</Badge>;
      case 'chuaThanhToan':
      case 'UNPAID':
        return <Badge variant="outline" className="border-amber-500 text-amber-600 bg-amber-50">Chưa thanh toán</Badge>;
      case 'daThanhToanMotPhan':
      case 'PARTIAL':
        return <Badge variant="secondary" className="bg-blue-100 text-blue-800">Thanh toán 1 phần</Badge>;
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
        return <Badge className="bg-emerald-600">Thành công</Badge>;
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
      <div className="flex items-center justify-center min-h-[60vh]">
        <div className="flex flex-col items-center gap-3">
          <div className="animate-spin rounded-full h-12 w-12 border-4 border-[#4FA7A0] border-t-transparent"></div>
          <p className="text-sm text-gray-500">Đang tải chi tiết hóa đơn...</p>
        </div>
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

  const bankAccount = "19040069770013";
  const bankName = "Techcombank - Ngân hàng Kỹ Thương Việt Nam";
  const accountHolder = "DO CHI CONG";
  const transferContent = `Thanh toan ${invoice.maHoaDon || ''}`;
  const qrAmount = invoice.conLai !== undefined ? invoice.conLai : (invoice.tongTien || 0);

  return (
    <div className="bg-[#F8F9FA] min-h-screen pb-24 md:pb-12 font-sans">
      {/* Top bar (Floating Action Header) */}
      <div className="sticky top-4 z-20 max-w-4xl mx-auto px-4 pt-2 print:hidden">
        <div className="bg-white/90 backdrop-blur-md rounded-2xl shadow-sm border border-gray-200 flex items-center justify-between p-3 px-4">
          <Button
            variant="ghost"
            size="sm"
            onClick={() => router.push('/khach-thue/dashboard/hoa-don')}
            className="flex items-center gap-1.5 text-gray-700 hover:text-gray-900 rounded-xl"
          >
            <ArrowLeft className="h-4 w-4" />
            <span className="text-sm font-medium">Danh sách hóa đơn</span>
          </Button>
          
          <div className="flex items-center gap-2">
            <Button
              variant="outline"
              size="sm"
              onClick={() => window.print()}
              className="flex items-center gap-1.5 text-gray-700 rounded-xl"
              title="In hóa đơn này"
            >
              <Printer className="h-4 w-4" />
              <span className="hidden sm:inline text-xs font-semibold">In biên lai</span>
            </Button>
          </div>
        </div>
      </div>

      <div className="max-w-4xl mx-auto px-4 py-6 space-y-6">
        {/* Main Receipt Card */}
        <div className="bg-white rounded-3xl shadow-sm border border-gray-200 overflow-hidden relative print:border-none print:shadow-none">
          {/* Header Bar */}
          <div className="bg-gradient-to-r from-[#243B5A] to-[#1C304B] text-white p-6 sm:p-8 rounded-t-3xl">
            <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
              <div>
                <span className="text-xs uppercase tracking-wider bg-white/20 text-white px-2.5 py-1 rounded-full font-semibold">
                  Hóa đơn thu tiền phòng
                </span>
                <h1 className="text-2xl sm:text-3xl font-extrabold mt-2 tracking-tight">
                  Phòng {tenPhong}
                </h1>
                <p className="text-white/80 text-sm mt-1">
                  {tenNhaTro !== '---' ? `${tenNhaTro} • ` : ''}Khách thuê: <strong>{tenKhach}</strong>
                </p>
              </div>

              <div className="flex flex-col items-start sm:items-end gap-1.5">
                <span className="text-xs text-white/70">Mã hóa đơn</span>
                <span className="font-mono text-base font-bold bg-black/20 px-3 py-1 rounded-lg border border-white/10">
                  {invoice.maHoaDon}
                </span>
                <div className="mt-1">
                  {getStatusBadge(invoice.trangThai)}
                </div>
              </div>
            </div>
          </div>

          {/* Meta 3-Box Bar */}
          <div className="grid grid-cols-3 divide-x divide-gray-200 border-b border-gray-200 bg-gray-50/70 text-center">
            <div className="p-3.5 sm:p-4">
              <p className="text-xs text-gray-500 mb-1">Kỳ hóa đơn</p>
              <p className="text-sm sm:text-base font-bold text-gray-900">
                Tháng {invoice.thang || invoice.kyThang}/{invoice.nam || invoice.kyNam}
              </p>
            </div>
            <div className="p-3.5 sm:p-4">
              <p className="text-xs text-gray-500 mb-1">Ngày lập</p>
              <p className="text-sm sm:text-base font-semibold text-gray-800">{ngayTao}</p>
            </div>
            <div className="p-3.5 sm:p-4">
              <p className="text-xs text-gray-500 mb-1">Hạn thanh toán</p>
              <p className="text-sm sm:text-base font-bold text-amber-700">{hanThanhToanDate}</p>
            </div>
          </div>

          {/* Invoice Body Table */}
          <div className="p-5 sm:p-7 space-y-6">
            <div className="border border-gray-200 rounded-2xl overflow-hidden shadow-xs">
              <div className="bg-gray-50 px-5 py-3.5 border-b border-gray-200 flex items-center justify-between">
                <h3 className="text-sm sm:text-base font-bold text-gray-900">
                  Bảng chi tiết các khoản thu trong kỳ
                </h3>
                <span className="text-xs text-gray-500 font-medium hidden sm:inline">
                  Đơn vị tính: VNĐ
                </span>
              </div>

              <div className="overflow-x-auto">
                <table className="w-full text-left text-sm border-collapse">
                  <thead className="bg-slate-50 text-slate-600 text-xs uppercase font-semibold">
                    <tr className="border-b border-gray-200">
                      <th className="px-4 py-3">Khoản thu</th>
                      <th className="px-3 py-3 text-center">Chỉ số cũ</th>
                      <th className="px-3 py-3 text-center">Chỉ số mới</th>
                      <th className="px-3 py-3 text-center">Số lượng / Dùng</th>
                      <th className="px-4 py-3 text-right">Đơn giá</th>
                      <th className="px-4 py-3 text-right">Thành tiền</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {invoiceItems.length > 0 ? (
                      invoiceItems.map((item, index) => {
                        const readings = getMeterReadings(item);
                        const unit = meterUnits[item.loai] || '';
                        const label = invoiceLineLabels[item.loai] || item.loai || 'Khoản thu khác';
                        const showDescription = item.moTa && item.moTa.trim().toLocaleLowerCase('vi-VN') !== label.toLocaleLowerCase('vi-VN');

                        return (
                          <tr key={item._id || item.id || `${item.loai}-${index}`} className="hover:bg-slate-50/70 transition-colors">
                            <td className="px-4 py-3.5">
                              <div className="font-semibold text-gray-900 flex items-center gap-1.5">
                                {item.loai === 'ROOM' && <Home className="h-4 w-4 text-[#243B5A]" />}
                                {item.loai === 'ELECTRICITY' && <Zap className="h-4 w-4 text-yellow-500" />}
                                {item.loai === 'WATER' && <Droplets className="h-4 w-4 text-[#4FA7A0]" />}
                                {item.loai === 'PARKING' && <Car className="h-4 w-4 text-purple-500" />}
                                {item.loai === 'SERVICE' && <Wrench className="h-4 w-4 text-blue-500" />}
                                {label}
                              </div>
                              {showDescription && (
                                <p className="text-xs text-gray-500 mt-0.5 ml-5">{item.moTa}</p>
                              )}
                            </td>
                            <td className="px-3 py-3.5 text-center text-gray-700">
                              {readings ? formatQuantity(readings.oldReading) : '—'}
                            </td>
                            <td className="px-3 py-3.5 text-center text-gray-700">
                              {readings ? formatQuantity(readings.newReading) : '—'}
                            </td>
                            <td className="px-3 py-3.5 text-center font-medium text-gray-900">
                              {formatQuantity(item.soLuong)}{unit ? ` ${unit}` : ''}
                            </td>
                            <td className="px-4 py-3.5 text-right text-gray-700">
                              {formatCurrency(toNumber(item.donGia))}
                            </td>
                            <td className="px-4 py-3.5 text-right font-bold text-gray-900">
                              {formatCurrency(toNumber(item.thanhTien))}
                            </td>
                          </tr>
                        );
                      })
                    ) : (
                      <tr>
                        <td colSpan={6} className="px-4 py-8 text-center text-gray-500">
                          Chưa có thông tin dòng chi tiết cho hóa đơn này.
                        </td>
                      </tr>
                    )}

                    {/* Dòng Nợ cũ nếu có */}
                    {invoice.soDuDauKy && Number(invoice.soDuDauKy) > 0 && (
                      <tr className="bg-amber-50/50">
                        <td className="px-4 py-3.5">
                          <div className="font-semibold text-amber-900 flex items-center gap-1.5">
                            <Clock className="h-4 w-4 text-amber-600" />
                            Dư nợ kỳ trước chuyển sang
                          </div>
                          <p className="text-xs text-amber-700 ml-5">Nợ cũ chưa thanh toán</p>
                        </td>
                        <td className="px-3 py-3.5 text-center text-gray-400">—</td>
                        <td className="px-3 py-3.5 text-center text-gray-400">—</td>
                        <td className="px-3 py-3.5 text-center font-medium text-amber-900">1 kỳ</td>
                        <td className="px-4 py-3.5 text-right text-amber-900">{formatCurrency(invoice.soDuDauKy)}</td>
                        <td className="px-4 py-3.5 text-right font-bold text-amber-900">{formatCurrency(invoice.soDuDauKy)}</td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>

            {/* Financial Summary Card */}
            <div className="bg-[#F8F3EC] border border-[#E8DED2] rounded-2xl p-5 space-y-3">
              <div className="flex justify-between items-center text-sm text-gray-700">
                <span>Tổng tiền phát sinh kỳ này:</span>
                <span className="font-semibold text-gray-900">
                  {formatCurrency(invoice.tongTienPhatSinh || invoice.tongTien || 0)}
                </span>
              </div>

              {invoice.soDuDauKy && Number(invoice.soDuDauKy) > 0 && (
                <div className="flex justify-between items-center text-sm text-amber-800">
                  <span>+ Dư nợ kỳ trước:</span>
                  <span className="font-semibold">{formatCurrency(invoice.soDuDauKy)}</span>
                </div>
              )}

              <div className="h-[1px] bg-[#E8DED2] w-full my-1"></div>

              <div className="flex justify-between items-center text-base sm:text-lg">
                <span className="font-extrabold text-[#243B5A]">Tổng cộng hóa đơn:</span>
                <span className="text-xl sm:text-2xl font-extrabold text-[#243B5A]">
                  {formatCurrency(invoice.tongTien || 0)}
                </span>
              </div>

              <div className="flex justify-between items-center text-sm">
                <span className="text-emerald-700 font-medium">Đã thanh toán:</span>
                <span className="font-bold text-emerald-700">
                  {formatCurrency(invoice.daTra || invoice.daThanhToan || 0)}
                </span>
              </div>

              <div className="flex justify-between items-center text-base font-bold pt-2 border-t border-[#E8DED2]">
                <span className={invoice.conLai > 0 ? "text-red-600" : "text-emerald-700"}>
                  {invoice.conLai > 0 ? "Số tiền còn phải nạp:" : "Trạng thái thanh toán:"}
                </span>
                <span className={`text-xl font-black ${invoice.conLai > 0 ? "text-red-600" : "text-emerald-700"}`}>
                  {invoice.conLai > 0 ? formatCurrency(invoice.conLai) : "Đã nạp đủ"}
                </span>
              </div>
            </div>

            {invoice.ghiChu && (
              <div className="bg-amber-50 border border-amber-200 rounded-2xl p-4 text-sm text-amber-900">
                <p className="font-semibold text-amber-800 mb-1">Ghi chú từ chủ trọ:</p>
                <p>{invoice.ghiChu}</p>
              </div>
            )}
          </div>
        </div>

        {/* Thanh toán & QR Code (If unpaid or partially paid) */}
        {!isPaid && (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-5 print:hidden">
            {/* VNPay Online Payment Option */}
            <Card className="border-[#E8DED2] shadow-sm rounded-3xl overflow-hidden flex flex-col justify-between">
              <CardHeader className="bg-gradient-to-br from-[#243B5A] to-[#1C304B] text-white p-6">
                <div className="flex items-center gap-3">
                  <div className="p-3 bg-white/10 rounded-2xl backdrop-blur-sm">
                    <Banknote className="h-6 w-6 text-white" />
                  </div>
                  <div>
                    <CardTitle className="text-lg font-bold text-white">Thanh toán Online</CardTitle>
                    <CardDescription className="text-white/80 text-xs">
                      Cổng thanh toán điện tử VNPay (Thẻ ATM, Visa, VNPay QR)
                    </CardDescription>
                  </div>
                </div>
              </CardHeader>
              <CardContent className="p-6 space-y-4 flex-1 flex flex-col justify-between">
                <div className="bg-slate-50 p-4 rounded-2xl border border-slate-200 text-sm space-y-2">
                  <div className="flex justify-between">
                    <span className="text-gray-500">Số tiền nạp:</span>
                    <span className="font-bold text-red-600 text-base">{formatCurrency(invoice.conLai)}</span>
                  </div>
                  <div className="flex justify-between text-xs">
                    <span className="text-gray-500">Kích hoạt tự động:</span>
                    <span className="font-semibold text-emerald-600">Ngay lập tức</span>
                  </div>
                </div>

                <Button
                  className="w-full bg-[#4FA7A0] hover:bg-[#3D8580] text-white py-6 text-base font-bold rounded-2xl shadow-md transition-transform hover:scale-[1.01]"
                  onClick={async () => {
                    try {
                      const res = await fetch(`/api/vnpay/create-payment-url?hoaDonId=${invoice._id || invoice.id}`, {
                        headers: accessToken ? { 'Authorization': `Bearer ${accessToken}` } : undefined,
                      });
                      const data = await res.json();
                      if (data.success && data.data) {
                        window.location.href = data.data;
                      } else {
                        toast.error(data.message || "Không thể khởi tạo thanh toán VNPay");
                      }
                    } catch (error) {
                      toast.error("Lỗi khi kết nối đến máy chủ");
                    }
                  }}
                >
                  <Banknote className="mr-2 h-5 w-5" /> Thanh toán ngay qua VNPay
                </Button>
              </CardContent>
            </Card>

            {/* VietQR Bank Transfer Option */}
            <Card className="border-[#E8DED2] shadow-sm rounded-3xl overflow-hidden">
              <CardHeader className="bg-[#F8F3EC] border-b border-[#E8DED2] p-5">
                <div className="flex items-center gap-2">
                  <QrCode className="h-5 w-5 text-[#243B5A]" />
                  <CardTitle className="text-base font-bold text-[#243B5A]">
                    Quét mã VietQR chuyển khoản
                  </CardTitle>
                </div>
              </CardHeader>
              <CardContent className="p-5 space-y-4">
                <div className="flex justify-center">
                  <div className="relative h-[220px] w-[220px] rounded-2xl overflow-hidden border-2 border-[#E8DED2] bg-white p-2 shadow-inner">
                    <Image
                      src={`https://img.vietqr.io/image/970407-${bankAccount}-compact2.png?amount=${qrAmount}&addInfo=${encodeURIComponent(transferContent)}&accountName=${encodeURIComponent(accountHolder)}`}
                      alt={`Mã QR thanh toán hóa đơn ${invoice.maHoaDon}`}
                      fill
                      sizes="220px"
                      className="object-contain p-1"
                    />
                  </div>
                </div>

                <div className="bg-[#F8F3EC]/70 border border-[#E8DED2] rounded-2xl p-4 text-xs space-y-2.5">
                  <div className="flex justify-between items-center">
                    <span className="text-gray-500">Ngân hàng:</span>
                    <span className="font-semibold text-gray-900">{bankName}</span>
                  </div>

                  <div className="flex justify-between items-center">
                    <span className="text-gray-500">Số tài khoản:</span>
                    <div className="flex items-center gap-2">
                      <span className="font-mono font-bold text-sm text-[#243B5A]">{bankAccount}</span>
                      <button
                        onClick={() => copyToClipboard(bankAccount, "Số tài khoản")}
                        className="text-[#4FA7A0] hover:text-[#3D8580] p-1 rounded hover:bg-white"
                        title="Sao chép số tài khoản"
                      >
                        {copiedField === "Số tài khoản" ? <Check className="h-3.5 w-3.5 text-emerald-600" /> : <Copy className="h-3.5 w-3.5" />}
                      </button>
                    </div>
                  </div>

                  <div className="flex justify-between items-center">
                    <span className="text-gray-500">Chủ tài khoản:</span>
                    <span className="font-bold text-gray-900">{accountHolder}</span>
                  </div>

                  <div className="flex justify-between items-center">
                    <span className="text-gray-500">Số tiền:</span>
                    <div className="flex items-center gap-2">
                      <span className="font-bold text-red-600">{formatCurrency(qrAmount)}</span>
                      <button
                        onClick={() => copyToClipboard(String(qrAmount), "Số tiền")}
                        className="text-[#4FA7A0] hover:text-[#3D8580] p-1 rounded hover:bg-white"
                        title="Sao chép số tiền"
                      >
                        {copiedField === "Số tiền" ? <Check className="h-3.5 w-3.5 text-emerald-600" /> : <Copy className="h-3.5 w-3.5" />}
                      </button>
                    </div>
                  </div>

                  <div className="flex justify-between items-center pt-1 border-t border-[#E8DED2]">
                    <span className="text-gray-500">Nội dung:</span>
                    <div className="flex items-center gap-2">
                      <span className="font-mono font-bold text-[#243B5A]">{transferContent}</span>
                      <button
                        onClick={() => copyToClipboard(transferContent, "Nội dung chuyển khoản")}
                        className="text-[#4FA7A0] hover:text-[#3D8580] p-1 rounded hover:bg-white"
                        title="Sao chép nội dung"
                      >
                        {copiedField === "Nội dung chuyển khoản" ? <Check className="h-3.5 w-3.5 text-emerald-600" /> : <Copy className="h-3.5 w-3.5" />}
                      </button>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        )}

        {/* Lịch sử giao dịch */}
        {payments.length > 0 && (
          <div id="payment-history" className="pt-2 print:hidden">
            <div className="bg-white rounded-3xl shadow-sm border border-gray-200 overflow-hidden">
              <div className="px-6 py-4 bg-gray-50 border-b border-gray-200 flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <Clock className="h-5 w-5 text-[#243B5A]" />
                  <h3 className="text-base font-bold text-gray-900">Lịch sử giao dịch thanh toán</h3>
                </div>
                <span className="text-xs bg-emerald-50 text-emerald-700 px-2.5 py-1 rounded-full font-semibold">
                  {payments.length} lần giao dịch
                </span>
              </div>

              <div className="divide-y divide-gray-100">
                {payments.map((payment, idx) => (
                  <div key={idx} className="p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-3 hover:bg-gray-50/60 transition-colors">
                    <div>
                      <div className="flex items-center gap-2">
                        <span className="text-base font-bold text-emerald-600">
                          +{formatCurrency(payment.soTien)}
                        </span>
                        {getPaymentStatusBadge(payment.trangThai)}
                      </div>
                      <p className="text-xs text-gray-500 mt-1">
                        Ngày nộp: {formatDate(payment.ngayThanhToan)} • Phương thức: <strong>{payment.phuongThuc || 'Chuyển khoản'}</strong>
                      </p>
                      {payment.ghiChu && (
                        <p className="text-xs text-gray-700 mt-1 italic">
                          Ghi chú: {payment.ghiChu}
                        </p>
                      )}
                    </div>

                    {payment.anhBienLai && (
                      <div className="relative h-16 w-16 overflow-hidden rounded-xl border border-gray-200 shrink-0">
                        <Image
                          src={payment.anhBienLai}
                          alt="Biên lai"
                          fill
                          sizes="64px"
                          className="object-cover"
                        />
                      </div>
                    )}
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
