'use client';

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
  Zap
} from 'lucide-react';
import { toast } from 'sonner';
import { cn } from "@/lib/utils";

// Canvas component cho vẽ chữ ký
function SignatureCanvas({ onSave, onCancel }: { onSave: (base64: string) => void; onCancel?: () => void }) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [isDrawing, setIsDrawing] = useState(false);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    ctx.strokeStyle = '#000000';
    ctx.lineWidth = 3;
    ctx.lineCap = 'round';
  }, []);

  const getPos = (e: React.MouseEvent<HTMLCanvasElement> | React.TouchEvent<HTMLCanvasElement>) => {
    const canvas = canvasRef.current;
    if (!canvas) return { x: 0, y: 0 };
    const rect = canvas.getBoundingClientRect();
    const clientX = 'touches' in e ? e.touches[0].clientX : e.clientX;
    const clientY = 'touches' in e ? e.touches[0].clientY : e.clientY;
    return {
      x: clientX - rect.left,
      y: clientY - rect.top
    };
  };

  const startDrawing = (e: React.MouseEvent<HTMLCanvasElement> | React.TouchEvent<HTMLCanvasElement>) => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    setIsDrawing(true);
    const pos = getPos(e);
    ctx.beginPath();
    ctx.moveTo(pos.x, pos.y);
  };

  const draw = (e: React.MouseEvent<HTMLCanvasElement> | React.TouchEvent<HTMLCanvasElement>) => {
    if (!isDrawing) return;
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    const pos = getPos(e);
    ctx.lineTo(pos.x, pos.y);
    ctx.stroke();
  };

  const stopDrawing = () => {
    setIsDrawing(false);
  };

  const clear = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
  };

  const save = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const base64 = canvas.toDataURL('image/png');
    onSave(base64);
  };

  return (
    <div className="space-y-4">
      <div className="rounded-lg border bg-[#F8F3EC] p-1">
        <canvas
          ref={canvasRef}
          width={500}
          height={200}
          className="w-full h-[200px] border border-dashed border-slate-300 rounded-md bg-white cursor-crosshair touch-none"
          onMouseDown={startDrawing}
          onMouseMove={draw}
          onMouseUp={stopDrawing}
          onMouseLeave={stopDrawing}
          onTouchStart={startDrawing}
          onTouchMove={draw}
          onTouchEnd={stopDrawing}
        />
      </div>
      <div className="flex justify-between items-center">
        <span className="text-xs text-muted-foreground italic">Vẽ chữ ký của bạn vào khung phía trên</span>
        <div className="flex gap-2">
          <Button variant="outline" size="sm" type="button" onClick={clear}>Xóa vẽ lại</Button>
          <Button size="sm" type="button" onClick={save}>Xác nhận chữ ký</Button>
          {onCancel && <Button variant="ghost" size="sm" type="button" onClick={onCancel}>Hủy</Button>}
        </div>
      </div>
    </div>
  );
}

export default function TenantContractDetailPage() {
  const router = useRouter();
  const params = useParams();
  const hopDongId = params.id as string;
  const session = useSession()?.data;
  const accessToken = session?.accessToken;

  const [contract, setContract] = useState<any | null>(null);
  const [signatures, setSignatures] = useState<any[]>([]);
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

      {/* PDF Viewer & Actions */}
      <Card>
        <CardHeader className="flex flex-col sm:flex-row justify-between sm:items-center gap-3">
          <div>
            <CardTitle className="text-lg">Văn bản hợp đồng</CardTitle>
            <CardDescription>Xem trước tài liệu PDF và thực hiện ký điện tử xác nhận.</CardDescription>
          </div>
          <div className="flex gap-2">
            {!hasSigned && !isCompleted && !isRejected && contract.filePdf && (
              <>
                <Button variant="outline" className="text-red-600 border-red-200 hover:bg-red-50" onClick={() => setOpenRejectDialog(true)}>
                  <XCircle className="h-4 w-4 mr-2" /> Từ chối ký
                </Button>
                <Button onClick={() => setOpenSignDialog(true)}>
                  <PenTool className="h-4 w-4 mr-2" /> Ký hợp đồng
                </Button>
              </>
            )}
            {contract.filePdf && (
              <Button asChild variant="outline">
                <a href={contract.filePdf} target="_blank" rel="noreferrer">
                  <FileDown className="h-4 w-4 mr-2" /> Tải PDF
                </a>
              </Button>
            )}
          </div>
        </CardHeader>
        <CardContent className="space-y-6">
          {contract.filePdf ? (
            <div className="border rounded-lg overflow-hidden bg-slate-100 shadow-inner">
              <iframe 
                src={`https://docs.google.com/viewer?url=${encodeURIComponent(contract.filePdf + '?t=' + pdfTimestamp)}&embedded=true`}
                className="w-full h-[600px] border-0"
                title="Contract PDF Viewer"
              />
              <div className="bg-white p-2 border-t text-center text-xs text-muted-foreground">
                Nếu tài liệu không hiển thị, vui lòng <a href={contract.filePdf} target="_blank" rel="noreferrer" className="text-[#4FA7A0] underline font-semibold">bấm vào đây để tải xuống trực tiếp</a>.
              </div>
            </div>
          ) : contract.noiDungHopDong ? (
            <div 
              className="border rounded-lg p-6 md:p-8 bg-white shadow-sm overflow-x-auto text-sm md:text-base max-h-[800px] overflow-y-auto prose max-w-none" 
              dangerouslySetInnerHTML={{ __html: contract.noiDungHopDong }} 
            />
          ) : (
            <div className="space-y-6">
              <div className="text-center p-6 border border-dashed rounded-lg bg-[#F8F3EC] text-[#6B7A8C]">
                Chưa có văn bản PDF. Dưới đây là thông tin chi tiết của hợp đồng.
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6 p-6 border rounded-xl bg-white shadow-sm">
                <div>
                  <h4 className="font-bold text-[#243B5A] mb-4 flex items-center gap-2">
                    <span className="w-8 h-8 rounded-full bg-[#4FA7A0]/10 flex items-center justify-center text-[#4FA7A0]">A</span>
                    Bên Cho Thuê (Bên A)
                  </h4>
                  <div className="space-y-2 text-sm">
                    <p><span className="text-gray-500">Người đại diện:</span> <strong>{contract.phong?.toaNha?.chuTro?.ten || 'Ban quản lý'}</strong></p>
                    <p><span className="text-gray-500">Điện thoại:</span> <strong>{contract.phong?.toaNha?.chuTro?.soDienThoai || '---'}</strong></p>
                    <p><span className="text-gray-500">Tòa nhà:</span> <strong>{contract.phong?.toaNha?.tenToaNha || '---'}</strong></p>
                  </div>
                </div>
                <div>
                  <h4 className="font-bold text-[#243B5A] mb-4 flex items-center gap-2">
                    <span className="w-8 h-8 rounded-full bg-orange-50 flex items-center justify-center text-orange-600">B</span>
                    Bên Thuê (Bên B)
                  </h4>
                  <div className="space-y-2 text-sm">
                    <p><span className="text-gray-500">Họ và tên:</span> <strong>{contract.khachThue?.hoTen || '---'}</strong></p>
                    <p><span className="text-gray-500">Điện thoại:</span> <strong>{contract.khachThue?.soDienThoai || '---'}</strong></p>
                    <p><span className="text-gray-500">CCCD/CMND:</span> <strong>{contract.khachThue?.cccd || '---'}</strong></p>
                  </div>
                </div>
              </div>
              <div className="p-6 border rounded-xl bg-white shadow-sm space-y-4 text-sm">
                <h4 className="font-bold text-[#243B5A] mb-2 flex items-center gap-2">
                  <Home className="h-5 w-5 text-gray-500" /> Thông tin thuê chi tiết
                </h4>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <p><span className="text-gray-500">Phòng thuê:</span> <strong>{contract.phong?.maPhong || '---'}</strong></p>
                  <p><span className="text-gray-500">Kỳ thanh toán:</span> <strong>{contract.chuKyThanhToan === 'MONTHLY' ? 'Hàng tháng' : contract.chuKyThanhToan}</strong></p>
                  <p><span className="text-gray-500">Giá thuê:</span> <strong>{formatCurrency(contract.giaThue || contract.giaThueHopDong || 0)} / tháng</strong></p>
                  <p><span className="text-gray-500">Tiền cọc:</span> <strong>{formatCurrency(contract.tienCoc || 0)}</strong></p>
                  <p><span className="text-gray-500">Ngày bắt đầu:</span> <strong>{formatDate(contract.ngayBatDau)}</strong></p>
                  <p><span className="text-gray-500">Ngày kết thúc:</span> <strong>{formatDate(contract.ngayKetThuc)}</strong></p>
                  {contract.phong?.dienTich && <p><span className="text-gray-500">Diện tích phòng:</span> <strong>{contract.phong.dienTich} m2</strong></p>}
                  {contract.phong?.soNguoiToiDa && <p><span className="text-gray-500">Số người ở tối đa:</span> <strong>{contract.phong.soNguoiToiDa} người</strong></p>}
                </div>
              </div>

              {(contract.dichVuHopDongs && contract.dichVuHopDongs.length > 0) ? (
                <div className="p-6 border rounded-xl bg-white shadow-sm space-y-4 text-sm">
                  <h4 className="font-bold text-[#243B5A] mb-2 flex items-center gap-2">
                    <Zap className="h-5 w-5 text-yellow-500" /> Các phí dịch vụ đính kèm
                  </h4>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {contract.dichVuHopDongs.map((dv: any, idx: number) => (
                      <div key={idx} className="flex justify-between items-center p-3 bg-gray-50 rounded-lg border border-gray-100">
                        <div>
                          <p className="font-semibold text-gray-800">{dv.dichVu?.tenDichVu || 'Dịch vụ'}</p>
                          <p className="text-xs text-gray-500">
                            {dv.loaiTinhPhi === 'PER_USER' ? 'Tính theo người' : 
                             dv.loaiTinhPhi === 'PER_ROOM' ? 'Tính theo phòng' : 
                             dv.loaiTinhPhi === 'METERED' ? 'Tính theo chỉ số' : 'Cố định'}
                          </p>
                        </div>
                        <p className="font-bold text-[#4FA7A0]">{formatCurrency(dv.donGiaApDung || dv.dichVu?.donGia || 0)}</p>
                      </div>
                    ))}
                  </div>
                </div>
              ) : (contract.phong?.dichVus && contract.phong.dichVus.length > 0) ? (
                <div className="p-6 border rounded-xl bg-white shadow-sm space-y-4 text-sm">
                  <h4 className="font-bold text-[#243B5A] mb-2 flex items-center gap-2">
                    <Zap className="h-5 w-5 text-yellow-500" /> Các phí dịch vụ cơ bản của phòng
                  </h4>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {contract.phong.dichVus.map((dv: any, idx: number) => (
                      <div key={idx} className="flex justify-between items-center p-3 bg-gray-50 rounded-lg border border-gray-100">
                        <div>
                          <p className="font-semibold text-gray-800">{dv.tenDichVu || 'Dịch vụ'}</p>
                          <p className="text-xs text-gray-500">
                            {dv.loaiTinhPhi === 'PER_USER' ? 'Tính theo người' : 
                             dv.loaiTinhPhi === 'PER_ROOM' ? 'Tính theo phòng' : 
                             dv.loaiTinhPhi === 'METERED' ? 'Tính theo chỉ số' : 'Cố định'}
                          </p>
                        </div>
                        <p className="font-bold text-[#4FA7A0]">{formatCurrency(dv.donGia || 0)}</p>
                      </div>
                    ))}
                  </div>
                </div>
              ) : null}
            </div>
          )}

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

      {/* Dialog vẽ chữ ký cho khách thuê */}
      <Dialog open={openSignDialog} onOpenChange={setOpenSignDialog}>
        <DialogContent className="sm:max-w-[550px]">
          <DialogHeader>
            <DialogTitle>Ký hợp đồng thuê phòng (Bên B - Khách thuê)</DialogTitle>
            <CardDescription>
              Vui lòng vẽ chữ ký tay của bạn hoặc tải ảnh chữ ký lên. Bằng việc ký tên, bạn xác nhận đồng ý với toàn bộ điều khoản ghi trong văn bản hợp đồng.
            </CardDescription>
          </DialogHeader>
          <Tabs defaultValue="draw" className="w-full mt-2">
            <TabsList className="grid w-full grid-cols-2">
              <TabsTrigger value="draw">Vẽ chữ ký</TabsTrigger>
              <TabsTrigger value="upload">Tải ảnh lên</TabsTrigger>
            </TabsList>
            <TabsContent value="draw" className="py-2">
              <SignatureCanvas 
                onSave={handleSign} 
                onCancel={() => setOpenSignDialog(false)} 
              />
            </TabsContent>
            <TabsContent value="upload" className="py-4 space-y-4">
              <div className="border-2 border-dashed rounded-lg p-6 flex flex-col items-center justify-center space-y-4 text-center">
                <div className="rounded-full bg-slate-100 p-3">
                  <FileDown className="h-6 w-6 text-slate-600" />
                </div>
                <div>
                  <p className="text-sm font-medium">Chọn file ảnh chữ ký (PNG, JPG)</p>
                  <p className="text-xs text-muted-foreground mt-1">Nên dùng ảnh nền trong suốt (PNG) để hiển thị đẹp nhất.</p>
                </div>
                <Input 
                  type="file" 
                  accept="image/*" 
                  className="max-w-[250px]"
                  onChange={(e) => {
                    const file = e.target.files?.[0];
                    if (file) {
                      const reader = new FileReader();
                      reader.onloadend = () => {
                        const base64 = reader.result as string;
                        handleSign(base64);
                      };
                      reader.readAsDataURL(file);
                    }
                  }}
                />
              </div>
              <div className="flex justify-end pt-2">
                <Button variant="outline" onClick={() => setOpenSignDialog(false)}>
                  Hủy
                </Button>
              </div>
            </TabsContent>
          </Tabs>
        </DialogContent>
      </Dialog>

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
