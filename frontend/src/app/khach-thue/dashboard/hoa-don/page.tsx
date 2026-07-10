'use client';

import { useState, useEffect, useCallback, useMemo } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle, CardFooter } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { FileText, Calendar, ArrowRight, Home } from 'lucide-react';
import { useSession } from 'next-auth/react';
import { toast } from 'sonner';
import { HoaDon } from '@/types';
import Link from 'next/link';

const pageStyles = `
.tenant-invoice-page {
  position: relative;
  min-height: 100vh;
  overflow-x: hidden;
  background:
    radial-gradient(circle at 18% 8%, rgba(79, 167, 160, 0.13), transparent 28%),
    radial-gradient(circle at 92% 18%, rgba(242, 164, 91, 0.12), transparent 26%),
    radial-gradient(circle at 68% 82%, rgba(36, 59, 90, 0.07), transparent 32%),
    linear-gradient(180deg, #fbf7f0 0%, #f8f3ec 42%, #f5efe6 100%);
  margin: -1.5rem -1rem -1rem;
}
@media (min-width: 768px) {
  .tenant-invoice-page {
    margin: -1.5rem -1.5rem -1.5rem;
  }
}
@media (min-width: 1024px) {
  .tenant-invoice-page {
    margin: -1.5rem -2rem -2rem;
  }
}

.tenant-invoice-page::before {
  content: "";
  position: absolute;
  inset: 0;
  pointer-events: none;
  z-index: 0;
  background-image:
    linear-gradient(rgba(36, 59, 90, 0.035) 1px, transparent 1px),
    linear-gradient(90deg, rgba(36, 59, 90, 0.035) 1px, transparent 1px);
  background-size: 42px 42px;
  mask-image: linear-gradient(to bottom, rgba(0,0,0,0.55), transparent 72%);
  -webkit-mask-image: linear-gradient(to bottom, rgba(0,0,0,0.55), transparent 72%);
}

.tenant-invoice-content {
  position: relative;
  z-index: 1;
  width: min(100%, 1160px);
  margin-inline: auto;
  padding: 42px 28px 72px;
}

@media (max-width: 768px) {
  .tenant-invoice-content {
    padding: 28px 18px 56px;
  }
}

.tenant-invoice-page-header {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: 24px;
}

@media (max-width: 768px) {
  .tenant-invoice-page-header {
    flex-direction: column;
    align-items: stretch;
  }
}

.tenant-invoice-eyebrow {
  margin: 0 0 6px;
  font-family: var(--font-body), Inter, system-ui, sans-serif;
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: #4FA7A0;
}

.tenant-invoice-page-header h1 {
  margin: 0;
  font-family: var(--font-heading), "Be Vietnam Pro", Inter, system-ui, sans-serif;
  font-size: clamp(28px, 3vw, 38px);
  line-height: 1.1;
  font-weight: 800;
  letter-spacing: -0.035em;
  color: #243B5A;
}

.tenant-invoice-page-header p {
  margin: 8px 0 0;
  font-family: var(--font-body), Inter, system-ui, sans-serif;
  font-size: 15px;
  line-height: 1.55;
  color: #64748B;
}

.tenant-invoice-toolbar {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px;
  border-radius: 18px;
  background: rgba(255, 255, 255, 0.72);
  border: 1px solid rgba(226, 218, 207, 0.85);
  box-shadow: 0 14px 36px rgba(36, 59, 90, 0.08);
  backdrop-filter: blur(16px);
}

@media (max-width: 768px) {
  .tenant-invoice-toolbar {
    width: 100%;
  }
}

.invoice-grid {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 24px;
}

@media (max-width: 1280px) {
  .invoice-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 768px) {
  .invoice-grid {
    grid-template-columns: 1fr;
    gap: 18px;
  }
}

.invoice-card {
  position: relative;
  overflow: hidden;
  border-radius: 24px !important;
  background: linear-gradient(180deg, rgba(255,255,255,0.96) 0%, rgba(255,252,247,0.94) 100%) !important;
  border: 1px solid rgba(226, 218, 207, 0.9) !important;
  box-shadow:
    0 18px 46px rgba(36, 59, 90, 0.10),
    inset 0 1px 0 rgba(255,255,255,0.9) !important;
  transition:
    transform 240ms cubic-bezier(0.22, 1, 0.36, 1),
    box-shadow 240ms cubic-bezier(0.22, 1, 0.36, 1),
    border-color 220ms ease !important;
}

.invoice-card::before {
  content: "";
  position: absolute;
  inset: 0;
  pointer-events: none;
  background: radial-gradient(circle at 88% 12%, rgba(79, 167, 160, 0.12), transparent 26%);
  opacity: 0;
  transition: opacity 220ms ease;
}

.invoice-card:hover {
  transform: translateY(-4px);
  border-color: rgba(79, 167, 160, 0.28) !important;
  box-shadow:
    0 26px 64px rgba(36, 59, 90, 0.14),
    inset 0 1px 0 rgba(255,255,255,0.9) !important;
}

.invoice-card:hover::before {
  opacity: 1;
}

.invoice-card[data-status="paid"] {
  border-color: rgba(79, 167, 160, 0.22) !important;
}

.invoice-card[data-status="unpaid"] {
  border-color: rgba(242, 164, 91, 0.24) !important;
}

.invoice-card[data-status="overdue"] {
  border-color: rgba(229, 72, 77, 0.28) !important;
}

.invoice-card button,
.invoice-card a {
  transition:
    transform 220ms cubic-bezier(0.22, 1, 0.36, 1),
    box-shadow 220ms ease,
    background-color 220ms ease;
}

.invoice-card button:hover,
.invoice-card a:hover {
  transform: translateY(-2px);
}

@media (prefers-reduced-motion: reduce) {
  .invoice-card,
  .invoice-card::before,
  .invoice-card button,
  .invoice-card a {
    animation: none !important;
    transition: none !important;
    transform: none !important;
  }
}
`;

export default function TenantInvoicesPage() {
  const session = useSession()?.data;
  const accessToken = session?.accessToken;
  const [invoices, setInvoices] = useState<HoaDon[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedRoomId, setSelectedRoomId] = useState<string>("all");

  const fetchInvoices = useCallback(async () => {
    try {
      setLoading(true);
      const res = await fetch('/api/tenant/hoa-don', {
        headers: {
          'Authorization': `Bearer ${accessToken}`
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
  }, [accessToken]);

  useEffect(() => {
    if (accessToken) {
      void fetchInvoices();
    }
  }, [accessToken, fetchInvoices]);

  const tenantRooms = useMemo(() => {
    const roomsMap = new Map();
    invoices.forEach(invoice => {
      let rInfo: any = null;
      if (invoice.phong && typeof invoice.phong === 'object') {
        rInfo = invoice.phong;
      } else if (invoice.hopDong && typeof invoice.hopDong === 'object' && invoice.hopDong.phong && typeof invoice.hopDong.phong === 'object') {
        rInfo = invoice.hopDong.phong;
      }

      if (rInfo) {
        const id = rInfo.id || rInfo._id;
        const name = rInfo.ten || rInfo.maPhong || rInfo.name || rInfo.code || "Phòng chưa rõ";
        if (id && !roomsMap.has(id)) {
          roomsMap.set(id, { id, name });
        }
      }
    });
    return Array.from(roomsMap.values());
  }, [invoices]);

  const filteredInvoices = useMemo(() => {
    if (selectedRoomId === "all") return invoices;
    
    return invoices.filter(invoice => {
      let rInfo: any = null;
      if (invoice.phong && typeof invoice.phong === 'object') {
        rInfo = invoice.phong;
      } else if (invoice.hopDong && typeof invoice.hopDong === 'object' && invoice.hopDong.phong && typeof invoice.hopDong.phong === 'object') {
        rInfo = invoice.hopDong.phong;
      }
      
      if (rInfo) {
        const id = rInfo.id || rInfo._id;
        return id === selectedRoomId;
      }
      return false;
    });
  }, [invoices, selectedRoomId]);

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
        return <Badge className="bg-[#4FA7A0] hover:bg-[#3D8580] text-white border-transparent">Đã thanh toán</Badge>;
      case 'chuaThanhToan':
      case 'UNPAID':
        return <Badge variant="outline" className="border-[#F2A45B] text-[#F2A45B] bg-[#F2A45B]/10">Chưa thanh toán</Badge>;
      case 'daThanhToanMotPhan':
      case 'PARTIAL':
        return <Badge variant="secondary" className="bg-orange-100 text-orange-800">Thanh toán 1 phần</Badge>;
      case 'quaHan':
      case 'OVERDUE':
        return <Badge variant="destructive" className="bg-[#E5484D] hover:bg-[#C93B40]">Quá hạn</Badge>;
      case 'nhap':
      case 'DRAFT':
        return <Badge variant="secondary" className="bg-slate-100 text-slate-700">Nháp</Badge>;
      case 'daHuy':
      case 'CANCELLED':
        return <Badge variant="outline" className="text-slate-500">Đã hủy</Badge>;
      default:
        return <Badge variant="outline">Không rõ</Badge>;
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#4FA7A0]"></div>
      </div>
    );
  }

  return (
    <div className="tenant-invoice-page">
      <style dangerouslySetInnerHTML={{ __html: pageStyles }} />
      <div className="tenant-invoice-content">
        <div className="tenant-invoice-page-header">
          <div>
            <p className="tenant-invoice-eyebrow">THANH TOÁN</p>
            <h1>Hóa đơn thanh toán</h1>
            <p>Quản lý hóa đơn tiền phòng và dịch vụ hàng tháng.</p>
          </div>
          
          {tenantRooms.length > 1 && (
            <div className="tenant-invoice-toolbar">
              <Select value={selectedRoomId} onValueChange={setSelectedRoomId}>
                <SelectTrigger className="bg-transparent border-none shadow-none w-[200px] focus:ring-0 focus:ring-offset-0">
                  <SelectValue placeholder="Chọn phòng" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Tất cả phòng</SelectItem>
                  {tenantRooms.map((room) => (
                    <SelectItem key={room.id} value={room.id}>
                      Phòng {room.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          )}
        </div>

        {filteredInvoices.length === 0 ? (
          <Card className="bg-white/60 border-dashed border-2 backdrop-blur-sm border-[#E2DACF] shadow-sm rounded-3xl mt-8">
            <CardContent className="flex flex-col items-center justify-center p-16 text-center space-y-4">
              <div className="bg-[#4FA7A0]/10 p-5 rounded-2xl text-[#4FA7A0]">
                <FileText className="h-10 w-10" />
              </div>
              <div>
                <h3 className="font-bold text-xl text-[#243B5A] mb-1">Chưa có hóa đơn nào</h3>
                <p className="text-[15px] text-[#64748B] max-w-md mx-auto leading-relaxed">
                  {selectedRoomId !== 'all' ? 'Phòng này hiện chưa có hóa đơn nào cần thanh toán.' : 'Bạn chưa có hóa đơn nào cần thanh toán. Các hóa đơn sẽ tự động xuất hiện tại đây khi đến kỳ thanh toán.'}
                </p>
              </div>
            </CardContent>
          </Card>
        ) : (
          <div className="invoice-grid mt-6">
            {filteredInvoices.map((invoice) => {
              const id = invoice.id || invoice._id;
              const trangThai = invoice.trangThai as string;
              const isPaid = trangThai === 'PAID' || trangThai === 'daThanhToan' || trangThai === 'thanhToanDu';
              
              const statusMap: Record<string, string> = {
                'daThanhToan': 'paid',
                'thanhToanDu': 'paid',
                'PAID': 'paid',
                'chuaThanhToan': 'unpaid',
                'UNPAID': 'unpaid',
                'daThanhToanMotPhan': 'unpaid',
                'PARTIAL': 'unpaid',
                'quaHan': 'overdue',
                'OVERDUE': 'overdue',
                'nhap': 'unpaid',
                'DRAFT': 'unpaid',
                'daHuy': 'paid',
                'CANCELLED': 'paid'
              };
              const dataStatus = statusMap[trangThai] || 'unpaid';

              // Extract room information
              let rInfo: any = null;
              if (invoice.phong && typeof invoice.phong === 'object') rInfo = invoice.phong;
              else if (invoice.hopDong && typeof invoice.hopDong === 'object' && invoice.hopDong.phong && typeof invoice.hopDong.phong === 'object') rInfo = invoice.hopDong.phong;

              const roomLabel = rInfo?.ten || rInfo?.maPhong || rInfo?.name || rInfo?.code || (invoice as any).roomName || (invoice as any).roomCode || "Chưa cập nhật";
              
              let bInfo: any = null;
              if (rInfo?.toaNha && typeof rInfo.toaNha === 'object') bInfo = rInfo.toaNha;
              else if ((invoice as any).toaNha && typeof (invoice as any).toaNha === 'object') bInfo = (invoice as any).toaNha;
              else if (rInfo?.building && typeof rInfo.building === 'object') bInfo = rInfo.building;
              
              const buildingLabel = bInfo?.tenToaNha || bInfo?.ten || bInfo?.name || (invoice as any).buildingName || "Chưa cập nhật";
              
              let addressLabel = "Chưa cập nhật";
              if (bInfo?.diaChi) {
                if (typeof bInfo.diaChi === 'string') {
                  addressLabel = bInfo.diaChi;
                } else if (typeof bInfo.diaChi === 'object') {
                  const { soNha, duong, phuong, quan, thanhPho } = bInfo.diaChi;
                  const parts = [];
                  if (soNha) parts.push(soNha);
                  if (duong) parts.push(duong);
                  const street = parts.join(' ');
                  
                  const locParts = [];
                  if (street) locParts.push(street);
                  if (phuong) locParts.push(phuong);
                  if (quan) locParts.push(quan);
                  if (thanhPho) locParts.push(thanhPho);
                  
                  if (locParts.length > 0) addressLabel = locParts.join(', ');
                }
              } else if (bInfo?.diaChiDayDu) {
                addressLabel = bInfo.diaChiDayDu;
              } else if (bInfo?.address) {
                addressLabel = bInfo.address;
              } else if ((invoice as any).buildingAddress) {
                addressLabel = (invoice as any).buildingAddress;
              }

              const floorLabel = rInfo?.tang || rInfo?.floor || null;

              return (
                <Card key={id as string} className="flex flex-col invoice-card" data-status={dataStatus}>
                  {isPaid && (
                    <div className="absolute top-0 right-0 w-16 h-16 pointer-events-none z-10">
                      <div className="absolute transform rotate-45 bg-[#4FA7A0] text-white text-[10px] py-1 right-[-35px] top-[14px] w-[120px] text-center font-bold shadow-sm uppercase tracking-wider">
                        Đã trả
                      </div>
                    </div>
                  )}
                  
                  <CardHeader className="pb-3 relative z-10">
                    <div className="flex justify-between items-start mb-3 pr-6">
                      <div className="bg-[#243B5A]/5 text-[#243B5A] px-2.5 py-1 rounded-md text-[11px] font-mono font-bold tracking-widest uppercase">
                        {invoice.maHoaDon}
                      </div>
                      {getStatusBadge(trangThai)}
                    </div>
                    <CardTitle className="text-xl font-['Be_Vietnam_Pro'] font-bold text-[#243B5A]">
                      Kỳ tháng {invoice.thang || invoice.kyThang}/{invoice.nam || invoice.kyNam}
                    </CardTitle>
                    <CardDescription className="flex items-center gap-1.5 mt-1.5 text-[13px] font-medium text-[#64748B]">
                      <Calendar className="h-3.5 w-3.5" /> Hạn thanh toán: {formatDate(invoice.hanTra || invoice.hanThanhToan)}
                    </CardDescription>

                    {/* Room Info Box */}
                    <div className="flex items-start gap-3 mt-4 p-3.5 rounded-[18px] bg-[#4FA7A0]/[0.06] border border-[#4FA7A0]/10">
                      <div className="grid place-items-center w-[36px] h-[36px] flex-none rounded-xl text-[#4FA7A0] bg-white shadow-sm border border-[#4FA7A0]/10">
                        <Home className="w-4 h-4" />
                      </div>
                      <div className="min-w-0 flex-1">
                        <div className="text-[14px] leading-snug font-extrabold text-[#243B5A]">
                          Phòng {roomLabel}
                        </div>
                        <div className="mt-0.5 text-[12.5px] leading-snug font-semibold text-[#64748B]">
                          {buildingLabel} {floorLabel ? `· Tầng ${floorLabel}` : ""}
                        </div>
                        <div className="mt-1 text-xs leading-relaxed font-medium text-[#7A8699] line-clamp-2">
                          {addressLabel}
                        </div>
                      </div>
                    </div>
                  </CardHeader>
                  
                  <CardContent className="flex-1 space-y-4 relative z-10">
                    <div className="space-y-3">
                      <div className="flex justify-between text-sm">
                        <span className="text-[#64748B] font-medium">Tổng hóa đơn:</span>
                        <span className="font-semibold text-[#243B5A]">{formatCurrency(invoice.tongTien)}</span>
                      </div>
                      <div className="flex justify-between text-sm">
                        <span className="text-[#64748B] font-medium">Đã thanh toán:</span>
                        <span className="font-semibold text-[#4FA7A0]">{formatCurrency(invoice.daTra || invoice.daThanhToan || 0)}</span>
                      </div>
                      <div className="flex justify-between text-base font-bold pt-3 mt-1 border-t border-[#E2DACF]/60">
                        <span className="text-[#243B5A]">Cần thanh toán:</span>
                        <span className={isPaid ? "text-[#4FA7A0]" : (dataStatus === 'overdue' ? "text-[#E5484D]" : "text-[#F2A45B]")}>
                          {formatCurrency(invoice.conLai)}
                        </span>
                      </div>
                    </div>
                  </CardContent>
                  
                  <CardFooter className="pt-2 pb-5 px-6 relative z-10">
                    <Button asChild variant={isPaid ? "outline" : "default"} className={`w-full h-11 rounded-xl font-bold text-[14px] shadow-sm ${!isPaid ? 'bg-[#4FA7A0] hover:bg-[#3D8580] text-white border-transparent' : 'border-[#E2DACF] text-[#243B5A] hover:bg-slate-50'}`}>
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
    </div>
  );
}
