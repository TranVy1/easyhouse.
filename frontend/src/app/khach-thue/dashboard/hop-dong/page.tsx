'use client';

import { useState, useEffect, useCallback, useMemo } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle, CardFooter } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import Link from 'next/link';
import { Home, Calendar, DollarSign, FileText, CheckCircle2, ChevronRight, ArrowRight } from 'lucide-react';
import { useSession } from 'next-auth/react';
import { toast } from 'sonner';
import { TenantContract } from '@/types';

const pageStyles = `
.tenant-contract-page {
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
  .tenant-contract-page {
    margin: -1.5rem -1.5rem -1.5rem;
  }
}
@media (min-width: 1024px) {
  .tenant-contract-page {
    margin: -1.5rem -2rem -2rem;
  }
}

.tenant-contract-page::before {
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

.tenant-contract-content {
  position: relative;
  z-index: 1;
  width: min(100%, 1160px);
  margin-inline: auto;
  padding: 42px 28px 72px;
}

@media (max-width: 768px) {
  .tenant-contract-content {
    padding: 28px 18px 56px;
  }
}

.tenant-contract-page-header {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: 24px;
}

@media (max-width: 768px) {
  .tenant-contract-page-header {
    flex-direction: column;
    align-items: stretch;
  }
}

.tenant-contract-eyebrow {
  margin: 0 0 6px;
  font-family: var(--font-body), Inter, system-ui, sans-serif;
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: #4FA7A0;
}

.tenant-contract-page-header h1 {
  margin: 0;
  font-family: var(--font-heading), "Be Vietnam Pro", Inter, system-ui, sans-serif;
  font-size: clamp(28px, 3vw, 38px);
  line-height: 1.1;
  font-weight: 800;
  letter-spacing: -0.035em;
  color: #243B5A;
}

.tenant-contract-page-header p {
  margin: 8px 0 0;
  font-family: var(--font-body), Inter, system-ui, sans-serif;
  font-size: 15px;
  line-height: 1.55;
  color: #64748B;
}

.tenant-contract-toolbar {
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
  .tenant-contract-toolbar {
    width: 100%;
  }
}

.contract-grid {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 24px;
}

@media (max-width: 1280px) {
  .contract-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 768px) {
  .contract-grid {
    grid-template-columns: 1fr;
    gap: 18px;
  }
}

.contract-card {
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

.contract-card::before {
  content: "";
  position: absolute;
  inset: 0;
  pointer-events: none;
  background: radial-gradient(circle at 88% 12%, rgba(79, 167, 160, 0.12), transparent 26%);
  opacity: 0;
  transition: opacity 220ms ease;
}

.contract-card:hover {
  transform: translateY(-4px);
  border-color: rgba(79, 167, 160, 0.28) !important;
  box-shadow:
    0 26px 64px rgba(36, 59, 90, 0.14),
    inset 0 1px 0 rgba(255,255,255,0.9) !important;
}

.contract-card:hover::before {
  opacity: 1;
}

.contract-card[data-status="active"] {
  border-color: rgba(79, 167, 160, 0.22) !important;
}

.contract-card[data-status="pending"] {
  border-color: rgba(242, 164, 91, 0.24) !important;
}

.contract-card[data-status="expired"] {
  border-color: rgba(229, 72, 77, 0.28) !important;
}

.contract-card button,
.contract-card a {
  transition:
    transform 220ms cubic-bezier(0.22, 1, 0.36, 1),
    box-shadow 220ms ease,
    background-color 220ms ease;
}

.contract-card button:hover,
.contract-card a:hover {
  transform: translateY(-2px);
}

@media (prefers-reduced-motion: reduce) {
  .contract-card,
  .contract-card::before,
  .contract-card button,
  .contract-card a {
    animation: none !important;
    transition: none !important;
    transform: none !important;
  }
}
`;


export default function TenantContractsPage() {
  const session = useSession()?.data;
  const accessToken = session?.accessToken;
  const [contracts, setContracts] = useState<TenantContract[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedRoomId, setSelectedRoomId] = useState<string>("all");

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

  const tenantRooms = useMemo(() => {
    const roomsMap = new Map();
    contracts.forEach(contract => {
      const rInfo: any = contract.phong;
      if (rInfo) {
        const id = rInfo.id || rInfo._id;
        const name = rInfo.ten || rInfo.maPhong || rInfo.name || rInfo.code || "Phòng chưa rõ";
        if (id && !roomsMap.has(id)) {
          roomsMap.set(id, { id, name });
        }
      }
    });
    return Array.from(roomsMap.values());
  }, [contracts]);

  const filteredContracts = useMemo(() => {
    if (selectedRoomId === "all") return contracts;
    
    return contracts.filter(contract => {
      const rInfo: any = contract.phong;
      if (rInfo) {
        const id = rInfo.id || rInfo._id;
        return id === selectedRoomId;
      }
      return false;
    });
  }, [contracts, selectedRoomId]);

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount || 0);
  };

  const formatDate = (dateStr: string | Date | undefined) => {
    if (!dateStr) return '---';
    return new Date(dateStr).toLocaleDateString('vi-VN');
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'hoatDong':
      case 'ACTIVE':
        return <Badge className="bg-[#4FA7A0] hover:bg-[#3D8580] text-white border-transparent">Hoạt động</Badge>;
      case 'choKichHoat':
      case 'PENDING':
      case 'DRAFT':
        return <Badge variant="outline" className="border-[#F2A45B] text-[#F2A45B] bg-[#F2A45B]/10">Chờ kích hoạt</Badge>;
      case 'hetHan':
      case 'EXPIRED':
        return <Badge variant="destructive" className="bg-[#E5484D] hover:bg-[#C93B40]">Hết hạn</Badge>;
      case 'daKetThuc':
      case 'TERMINATED':
      case 'daHuy':
      case 'CANCELLED':
        return <Badge variant="outline" className="text-slate-500">Đã kết thúc</Badge>;
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
    <div className="tenant-contract-page">
      <style dangerouslySetInnerHTML={{ __html: pageStyles }} />
      <div className="tenant-contract-content">
        <div className="tenant-contract-page-header">
          <div>
            <p className="tenant-contract-eyebrow">HỢP ĐỒNG</p>
            <h1>Hợp đồng của tôi</h1>
            <p>Quản lý và theo dõi các hợp đồng thuê phòng của bạn.</p>
          </div>
          
          {tenantRooms.length > 1 && (
            <div className="tenant-contract-toolbar">
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

        {filteredContracts.length === 0 ? (
          <Card className="bg-white/60 border-dashed border-2 backdrop-blur-sm border-[#E2DACF] shadow-sm rounded-3xl mt-8">
            <CardContent className="flex flex-col items-center justify-center p-16 text-center space-y-4">
              <div className="bg-[#4FA7A0]/10 p-5 rounded-2xl text-[#4FA7A0]">
                <FileText className="h-10 w-10" />
              </div>
              <div>
                <h3 className="font-bold text-xl text-[#243B5A] mb-1">Chưa có hợp đồng nào</h3>
                <p className="text-[15px] text-[#64748B] max-w-md mx-auto leading-relaxed">
                  {selectedRoomId !== 'all' ? 'Phòng này hiện chưa có hợp đồng nào được ghi nhận.' : 'Bạn hiện chưa có hợp đồng thuê phòng nào được ghi nhận trên hệ thống.'}
                </p>
              </div>
            </CardContent>
          </Card>
        ) : (
          <div className="contract-grid mt-6">
            {filteredContracts.map((contract) => {
              const id = contract.id || contract._id;
              const trangThai = contract.trangThai as string;
              
              const statusMap: Record<string, string> = {
                'hoatDong': 'active',
                'ACTIVE': 'active',
                'choKichHoat': 'pending',
                'PENDING': 'pending',
                'DRAFT': 'pending',
                'hetHan': 'expired',
                'EXPIRED': 'expired',
                'daKetThuc': 'inactive',
                'TERMINATED': 'inactive',
                'daHuy': 'inactive',
                'CANCELLED': 'inactive'
              };
              const dataStatus = statusMap[trangThai] || 'inactive';

              // Extract room info
              const rInfo: any = contract.phong;
              const roomLabel = rInfo?.ten || rInfo?.maPhong || rInfo?.name || rInfo?.code || "Chưa cập nhật";
              
              let bInfo: any = null;
              if (rInfo?.toaNha && typeof rInfo.toaNha === 'object') bInfo = rInfo.toaNha;
              const buildingLabel = bInfo?.tenToaNha || bInfo?.ten || bInfo?.name || "---";

              return (
                <Card key={id as string} className="flex flex-col contract-card" data-status={dataStatus}>
                  {dataStatus === 'active' && (
                    <div className="absolute top-0 right-0 w-16 h-16 pointer-events-none z-10">
                      <div className="absolute transform rotate-45 bg-[#4FA7A0] text-white text-[10px] py-1 right-[-35px] top-[14px] w-[120px] text-center font-bold shadow-sm uppercase tracking-wider">
                        Active
                      </div>
                    </div>
                  )}

                  <CardHeader className="pb-3 relative z-10">
                    <div className="flex justify-between items-start mb-3 pr-6">
                      <div className="bg-[#243B5A]/5 text-[#243B5A] px-2.5 py-1 rounded-md text-[11px] font-mono font-bold tracking-widest uppercase">
                        {contract.maHopDong}
                      </div>
                      {getStatusBadge(trangThai)}
                    </div>
                    <CardTitle className="text-xl font-['Be_Vietnam_Pro'] font-bold text-[#243B5A] flex items-center gap-2">
                      <Home className="h-5 w-5 text-[#4FA7A0]" />
                      {roomLabel}
                    </CardTitle>
                    <CardDescription className="flex items-center gap-1.5 mt-1.5 text-[13px] font-medium text-[#64748B]">
                      <span>{buildingLabel}</span>
                    </CardDescription>
                  </CardHeader>
                  
                  <CardContent className="flex-1 space-y-4 relative z-10">
                    <div className="grid grid-cols-2 gap-4 text-sm mt-2">
                      <div>
                        <p className="text-[#64748B] mb-1 text-xs uppercase tracking-wider font-semibold">Thời hạn</p>
                        <div className="flex items-center gap-1.5 font-medium text-[#243B5A]">
                          <Calendar className="h-3.5 w-3.5 text-[#4FA7A0]" />
                          {formatDate(contract.ngayBatDau as string)}
                        </div>
                        <div className="text-[#7A8699] text-xs mt-1 ml-5">đến {formatDate(contract.ngayKetThuc as string)}</div>
                      </div>
                      <div>
                        <p className="text-[#64748B] mb-1 text-xs uppercase tracking-wider font-semibold">Tiền cọc</p>
                        <div className="font-bold text-[#F2A45B]">
                          {formatCurrency(contract.tienCoc)}
                        </div>
                        {contract.trangThaiCoc === 'KEPT' && (
                          <div className="text-[#4FA7A0] text-xs font-semibold flex items-center gap-1 mt-1">
                            <CheckCircle2 className="h-3.5 w-3.5" /> Đã đóng
                          </div>
                        )}
                      </div>
                    </div>

                    <div className="bg-white/50 border border-[#E2DACF]/60 p-3.5 rounded-xl flex items-center justify-between mt-4">
                      <div>
                        <p className="text-[11px] text-[#64748B] uppercase tracking-wider font-bold mb-0.5">Giá thuê</p>
                        <p className="font-bold text-[#243B5A] text-lg">
                          {formatCurrency(contract.giaThue || contract.giaThueHopDong || 0)}<span className="text-sm font-semibold text-[#7A8699]">/tháng</span>
                        </p>
                      </div>
                      <div className="bg-[#4FA7A0]/10 p-2 rounded-lg text-[#4FA7A0]">
                        <DollarSign className="h-6 w-6" />
                      </div>
                    </div>
                  </CardContent>
                  
                  <CardFooter className="pt-2 pb-5 px-6 relative z-10">
                    <Button asChild variant="outline" className={`w-full h-11 rounded-xl font-bold text-[14px] shadow-sm border-[#E2DACF] text-[#243B5A] hover:bg-slate-50 hover:text-[#4FA7A0] transition-colors`}>
                      <Link href={`/khach-thue/dashboard/hop-dong/${id}`}>
                        Xem chi tiết & Ký <ChevronRight className="h-4 w-4 ml-1" />
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
