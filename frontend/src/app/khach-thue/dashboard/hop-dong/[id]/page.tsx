'use client';

import { HopDongDocumentViewer } from '@/components/hop-dong/HopDongDocumentViewer';

import { useState, useEffect, useCallback, useRef } from 'react';
import { useRouter, useParams } from 'next/navigation';
import { useSession } from 'next-auth/react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter
} from "@/components/ui/dialog";
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { 
  ArrowLeft,
  PenTool,
  XCircle,
  FileDown,
  Clock,
  CheckCircle2,
  Calendar,
  DollarSign,
  Home,
  Laptop,
  Network,
  History,
  Loader2,
  Zap,
  FileSignature
} from 'lucide-react';
import { YeuCauHopDongPanel } from '@/components/hop-dong/YeuCauHopDongPanel';
import { BienBanBanGiaoViewer } from '@/components/hop-dong/BienBanBanGiaoViewer';
import { toast } from 'sonner';
import { cn } from "@/lib/utils";


export default function TenantContractDetailPage() {
  const router = useRouter();
  const params = useParams();
  const hopDongId = params.id as string;
  const session = useSession()?.data;
  const accessToken = session?.accessToken as string | undefined;

  const [contract, setContract] = useState<any | null>(null);
  const [signatures, setSignatures] = useState<any[]>([]);
  // Quyet toan tra phong: null khi hop dong chua den buoc tra phong.
  const [quyetToan, setQuyetToan] = useState<any | null>(null);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  
  const [openSignDialog, setOpenSignDialog] = useState(false);
  const [openRejectDialog, setOpenRejectDialog] = useState(false);
  const [rejectionReason, setRejectionReason] = useState('');
  const [pdfTimestamp, setPdfTimestamp] = useState<number>(Date.now());

  const fetchContractData = useCallback(async () => {
    if (!accessToken || !hopDongId) return;
    try {
      setLoading(true);
      const res = await fetch(`/api/hop-dong/${hopDongId}`, {
        headers: { Authorization: `Bearer ${accessToken}` }
      });
      const data = await res.json();
      if (res.ok && data.success) {
        setContract(data.data);
        setPdfTimestamp(Date.now());
      } else {
        toast.error('Không tìm thấy hợp đồng');
        router.push('/khach-thue/dashboard/hop-dong');
      }

      // Fetch chữ ký
      const sigRes = await fetch(`/api/hop-dong/${hopDongId}/signatures`, {
        headers: { Authorization: `Bearer ${accessToken}` }
      });
      const sigData = await sigRes.json();
      if (sigData.success) {
        setSignatures(sigData.data || []);
      }

      // Quyet toan tra phong: hop dong chua den buoc nay thi backend bao loi,
      // day la truong hop binh thuong nen chi de null.
      const qtRes = await fetch(`/api/hop-dong/${hopDongId}/quyet-toan-tra-phong`, {
        headers: { Authorization: `Bearer ${accessToken}` }
      });
      const qtData = await qtRes.json().catch(() => ({}));
      setQuyetToan(qtRes.ok && qtData?.success ? qtData.data : null);
    } catch (error) {
      console.error(error);
      toast.error('Lỗi khi tải thông tin hợp đồng');
    } finally {
      setLoading(false);
    }
  }, [accessToken, hopDongId, router]);

  useEffect(() => {
    if (accessToken && hopDongId) {
      void fetchContractData();
    }
  }, [accessToken, hopDongId, fetchContractData]);

  const handleSign = async (base64: string) => {
    if (!accessToken || !hopDongId) return;
    setSubmitting(true);
    try {
      const res = await fetch(`/api/hop-dong/${hopDongId}/sign`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${accessToken}`
        },
        body: JSON.stringify({
          signatureBase64: base64,
          ipAddress: '127.0.0.1',
          userAgent: navigator.userAgent,
          role: 'TENANT'
        })
      });
      const data = await res.json();
      if (data.success) {
        toast.success("Ký hợp đồng thành công! Tài liệu PDF đã ký đang được cập nhật ở luồng phụ Async.");
        setOpenSignDialog(false);
        void fetchContractData();
      } else {
        toast.error(data.message || 'Ký hợp đồng thất bại');
      }
    } catch (error) {
      console.error(error);
      toast.error('Có lỗi xảy ra khi ký');
    } finally {
      setSubmitting(false);
    }
  };

  const handleReject = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!rejectionReason.trim()) {
      toast.error('Vui lòng nhập lý do từ chối');
      return;
    }
    setSubmitting(true);
    try {
      const res = await fetch(`/api/hop-dong/${hopDongId}/reject`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${accessToken}`
        },
        body: JSON.stringify({
          rejectionReason: rejectionReason.trim()
        })
      });
      const data = await res.json();
      if (data.success) {
        toast.success("Đã từ chối ký hợp đồng");
        setOpenRejectDialog(false);
        void fetchContractData();
      } else {
        toast.error(data.message || 'Thao tác thất bại');
      }
    } catch (error) {
      console.error(error);
      toast.error('Có lỗi xảy ra');
    } finally {
      setSubmitting(false);
    }
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
  };

  const formatDate = (dateStr: string) => {
    if (!dateStr) return '---';
    return new Date(dateStr).toLocaleDateString('vi-VN');
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-96">
        <Loader2 className="animate-spin h-12 w-12 text-[#243B5A]" />
      </div>
    );
  }

  if (!contract) return null;

  const hasSigned = signatures.some(sig => sig.signerRole === 'TENANT');
  const isCompleted = contract.signatureStatus === 'COMPLETED';
  const isRejected = contract.signatureStatus === 'REJECTED';

  return (
    <div className="p-4 md:p-8 max-w-5xl mx-auto space-y-6 pb-24 md:pb-8">
      {/* Header */}
      <div className="flex items-center gap-4 border bg-card p-4 rounded-xl shadow-xs">
        <Button variant="outline" size="icon" onClick={() => router.push('/khach-thue/dashboard/hop-dong')}>
          <ArrowLeft className="h-4 w-4" />
        </Button>
        <div className="flex-1">
          <div className="flex items-center gap-2 mb-1">
            <Badge variant="outline" className={cn(
              isCompleted ? 'bg-green-50 text-green-700 border-green-200' :
              isRejected ? 'bg-red-50 text-red-700 border-red-200' :
              'bg-yellow-50 text-yellow-700 border-yellow-200'
            )}>
              {isCompleted ? 'Hoạt động (Đã ký hoàn tất)' :
               contract.signatureStatus === 'LANDLORD_SIGNED' ? 'Chủ trọ đã ký (Chờ bạn ký)' :
               contract.signatureStatus === 'TENANT_SIGNED' ? 'Bạn đã ký (Chờ chủ trọ)' :
               isRejected ? 'Đã từ chối ký' : 'Chờ ký xác nhận'}
            </Badge>
          </div>
          <h1 className="text-xl md:text-2xl font-bold text-gray-900">Chi tiết hợp đồng {contract.maHopDong}</h1>
        </div>
      </div>

      {/* Tóm tắt điều khoản */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Card className="flex items-center p-4 gap-4">
          <div className="bg-[#4FA7A0]/10 p-3 rounded-lg text-[#243B5A]"><Home className="h-6 w-6" /></div>
          <div>
            <p className="text-xs text-muted-foreground uppercase font-semibold">Phòng thuê</p>
            <p className="font-bold text-[#243B5A] text-lg">{contract.phong?.maPhong || '---'}</p>
            <p className="text-xs text-[#6B7A8C]">{contract.phong?.toaNha?.tenToaNha || '---'}</p>
          </div>
        </Card>
        <Card className="flex items-center p-4 gap-4">
          <div className="bg-green-50 p-3 rounded-lg text-green-600"><DollarSign className="h-6 w-6" /></div>
          <div>
            <p className="text-xs text-muted-foreground uppercase font-semibold">Giá thuê phòng</p>
            <p className="font-bold text-[#243B5A] text-lg">{formatCurrency(contract.giaThue || contract.giaThueHopDong || 0)}</p>
            <p className="text-xs text-[#6B7A8C]">Đặt cọc: {formatCurrency(contract.tienCoc || 0)}</p>
          </div>
        </Card>
        <Card className="flex items-center p-4 gap-4">
          <div className="bg-orange-50 p-3 rounded-lg text-orange-600"><Calendar className="h-6 w-6" /></div>
          <div>
            <p className="text-xs text-muted-foreground uppercase font-semibold">Thời hạn thuê</p>
            <p className="font-semibold text-[#243B5A] text-sm">{formatDate(contract.ngayBatDau)}</p>
            <p className="text-xs text-[#6B7A8C]">Đến: {formatDate(contract.ngayKetThuc)}</p>
          </div>
        </Card>
      </div>

      {/* Banner thông báo khi có quyết toán trả phòng cần ký */}
      {quyetToan && (
        <Card className={cn(
          "border-2 overflow-hidden shadow-md",
          quyetToan.bienBanTrangThai === 'HOAN_TAT' 
            ? "border-emerald-200 bg-emerald-50/50" 
            : "border-amber-300 bg-gradient-to-r from-amber-50 to-orange-50"
        )}>
          <CardHeader className="pb-3">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
              <div className="flex items-center gap-3">
                <div className={cn(
                  "p-3 rounded-xl",
                  quyetToan.bienBanTrangThai === 'HOAN_TAT' ? "bg-emerald-100 text-emerald-700" : "bg-amber-100 text-amber-700 animate-pulse"
                )}>
                  <FileSignature className="h-6 w-6" />
                </div>
                <div>
                  <div className="flex items-center gap-2">
                    <span className="text-[11px] font-extrabold uppercase tracking-widest text-[#243B5A] bg-white/80 px-2 py-0.5 rounded border">
                      Thủ tục trả phòng
                    </span>
                    <Badge variant="outline" className={cn(
                      quyetToan.bienBanTrangThai === 'HOAN_TAT' 
                        ? 'bg-emerald-100 text-emerald-800 border-emerald-300' 
                        : 'bg-amber-100 text-amber-800 border-amber-300'
                    )}>
                      {quyetToan.bienBanTrangThai === 'HOAN_TAT' ? 'Đã ký đủ 2 bên' :
                       quyetToan.bienBanTrangThai === 'BEN_A_DA_KY' ? 'Chủ trọ đã ký · Chờ bạn ký' :
                       quyetToan.bienBanTrangThai === 'BEN_B_DA_KY' ? 'Bạn đã ký · Chờ chủ trọ' : 'Chờ ký xác nhận'}
                    </Badge>
                  </div>
                  <CardTitle className="text-lg font-bold text-[#243B5A] mt-1">
                    Biên bản bàn giao & Quyết toán tiền cọc
                  </CardTitle>
                </div>
              </div>
            </div>
          </CardHeader>
          <CardContent className="space-y-4 pt-1">
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
              <div className="bg-white/80 p-3 rounded-xl border">
                <p className="text-[11px] text-gray-500 uppercase font-semibold">Cọc ban đầu</p>
                <p className="font-bold text-[#243B5A] text-base">{formatCurrency(quyetToan.tienCocBanDau || 0)}</p>
              </div>
              <div className="bg-white/80 p-3 rounded-xl border">
                <p className="text-[11px] text-gray-500 uppercase font-semibold">Cấn trừ hóa đơn</p>
                <p className="font-bold text-red-600 text-base">- {formatCurrency(quyetToan.tienCocDaCanTru || 0)}</p>
              </div>
              <div className="bg-white/80 p-3 rounded-xl border">
                <p className="text-[11px] text-gray-500 uppercase font-semibold">
                  {quyetToan.tienCocCanHoan > 0 ? 'Số tiền nhận lại' : 'Số tiền phải nộp'}
                </p>
                <p className={cn("font-black text-lg", quyetToan.tienCocCanHoan > 0 ? "text-emerald-700" : "text-red-600")}>
                  {formatCurrency(quyetToan.tienCocCanHoan > 0 ? quyetToan.tienCocCanHoan : quyetToan.tienPhaiThuThem || 0)}
                </p>
              </div>
            </div>

            <BienBanBanGiaoViewer
              hopDongId={hopDongId}
              maHopDong={contract.maHopDong}
              bienBanTrangThai={quyetToan.bienBanTrangThai}
              vaiTro="BEN_B"
              accessToken={accessToken}
              onSigned={() => { void fetchContractData(); }}
            />
          </CardContent>
        </Card>
      )}

      {/* PDF Document Viewer & Actions */}
      <Card>
        <CardHeader className="flex flex-col sm:flex-row justify-between sm:items-center gap-3">
          <div>
            <CardTitle className="text-lg text-[#243B5A] font-bold">Văn bản hợp đồng thuê gốc</CardTitle>
            <CardDescription>Xem trước tài liệu PDF hợp đồng thuê phòng và lịch sử chữ ký.</CardDescription>
          </div>
          {contract.signatureStatus !== 'COMPLETED' && contract.signatureStatus !== 'TENANT_SIGNED' && contract.signatureStatus !== 'REJECTED' && (
            <div className="flex gap-2">
              <Button variant="outline" size="sm" className="text-red-600 border-red-200 hover:bg-red-50 text-xs" onClick={() => setOpenRejectDialog(true)}>
                <XCircle className="h-4 w-4 mr-1.5" /> Từ chối ký
              </Button>
            </div>
          )}
        </CardHeader>
        <CardContent className="space-y-6">
          <HopDongDocumentViewer
            hopDongId={hopDongId}
            maHopDong={contract.maHopDong}
            signatureStatus={contract.signatureStatus}
            role="TENANT"
            accessToken={accessToken}
            onSigned={() => {
              void fetchContractData();
            }}
          />

          {/* Yeu cau huy / gia han hop dong */}
          <div className="space-y-3 pt-4 border-t">
            <h3 className="font-semibold text-[#243B5A] flex items-center gap-2">
              <FileSignature className="h-5 w-5 text-[#4FA7A0]" />
              Yêu cầu hủy / gia hạn hợp đồng
            </h3>
            <YeuCauHopDongPanel
              hopDongId={hopDongId}
              trangThaiHopDong={contract.trangThai}
              accessToken={accessToken}
              onChanged={() => { void fetchContractData(); }}
            />
          </div>

          {/* Nhật ký ký số */}
          <div className="space-y-3 pt-4 border-t">
            <h3 className="font-semibold text-[#243B5A] flex items-center gap-2">
              <History className="h-5 w-5 text-[#4FA7A0]" />
              Nhật ký chữ ký pháp lý
            </h3>
            {signatures.length === 0 ? (
              <div className="text-center p-6 border rounded-lg text-sm text-muted-foreground">Chưa có chữ ký nào.</div>
            ) : (
              <div className="border rounded-lg overflow-hidden">
                <table className="w-full text-sm text-left text-[#6B7A8C]">
                  <thead className="text-xs text-[#243B5A] uppercase bg-[#F8F3EC]">
                    <tr>
                      <th className="px-4 py-3">Người ký</th>
                      <th className="px-4 py-3">Vai trò</th>
                      <th className="px-4 py-3">Địa chỉ IP</th>
                      <th className="px-4 py-3">Trình duyệt</th>
                      <th className="px-4 py-3">Thời gian ký</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y">
                    {signatures.map((sig) => (
                      <tr key={sig.id} className="bg-white hover:bg-[#F8F3EC]">
                        <td className="px-4 py-3 font-medium text-[#243B5A]">{sig.signerName}</td>
                        <td className="px-4 py-3">
                          <Badge variant="outline" className={sig.signerRole === 'LANDLORD' ? 'text-[#243B5A] bg-[#4FA7A0]/10 border-[#4FA7A0]/20' : 'text-orange-700 bg-orange-50 border-orange-100'}>
                            {sig.signerRole === 'LANDLORD' ? 'Chủ trọ Bên A' : 'Khách thuê Bên B (Bạn)'}
                          </Badge>
                        </td>
                        <td className="px-4 py-3"><span className="flex items-center gap-1"><Network className="h-3.5 w-3.5 text-muted-foreground" /> {sig.ipAddress || '127.0.0.1'}</span></td>
                        <td className="px-4 py-3 truncate max-w-[200px]" title={sig.userAgent}><Laptop className="h-3.5 w-3.5 text-muted-foreground inline mr-1" /> {sig.userAgent ? sig.userAgent.split(' ')[0] : 'Browser'}</td>
                        <td className="px-4 py-3 text-xs">{new Date(sig.signedAt).toLocaleString('vi-VN')}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </CardContent>
      </Card>

      

      {/* Dialog từ chối ký */}
      <Dialog open={openRejectDialog} onOpenChange={setOpenRejectDialog}>
        <DialogContent className="sm:max-w-[425px]">
          <DialogHeader>
            <DialogTitle>Từ chối ký hợp đồng</DialogTitle>
            <CardDescription>Vui lòng cung cấp lý do từ chối để chủ trọ điều chỉnh lại hợp đồng.</CardDescription>
          </DialogHeader>
          <form onSubmit={handleReject} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="reason">Lý do từ chối *</Label>
              <Textarea
                id="reason"
                placeholder="Ví dụ: Sai thông tin giá thuê, sai số CCCD, thiếu dịch vụ..."
                value={rejectionReason}
                onChange={(e) => setRejectionReason(e.target.value)}
                required
              />
            </div>
            <DialogFooter>
              <Button variant="ghost" type="button" onClick={() => setOpenRejectDialog(false)}>Hủy</Button>
              <Button variant="destructive" type="submit" disabled={submitting}>
                {submitting && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                Xác nhận từ chối
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  );
}
