'use client';

import { useState, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { 
  FileDown, 
  ExternalLink, 
  RefreshCw, 
  PenTool, 
  CheckCircle2, 
  Clock, 
  AlertCircle 
} from 'lucide-react';
import { HopDongSignaturePad } from './HopDongSignaturePad';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { cn } from '@/lib/utils';

/** Mot truong bat buoc con thieu, tra ve tu GET /api/hop-dong/{id}/kiem-tra-truoc-ky */
interface ThieuThongTin {
  ma: string;
  nhan: string;
  ben: 'BEN_A' | 'BEN_B' | 'HOP_DONG' | string;
  suaTaiCho: boolean;
}

interface HopDongDocumentViewerProps {
  hopDongId: string;
  maHopDong?: string;
  signatureStatus?: string;
  role?: 'LANDLORD' | 'TENANT';
  signerId?: string;
  canSign?: boolean;
  onSigned?: (sigData?: any) => void;
  className?: string;
  hideSignButton?: boolean;
  accessToken?: string;
}

export function HopDongDocumentViewer({
  hopDongId,
  maHopDong,
  signatureStatus,
  role = 'LANDLORD',
  signerId,
  canSign,
  onSigned,
  className,
  hideSignButton = false,
  accessToken,
}: HopDongDocumentViewerProps) {
  const [timestamp, setTimestamp] = useState<number>(Date.now());
  const [openSignPad, setOpenSignPad] = useState<boolean>(false);
  const [isRefreshing, setIsRefreshing] = useState<boolean>(false);
  // Ky xong la hop dong bi khoa du lieu, nen phai biet truoc con thieu gi.
  // Backend chan o ContractDocumentService.signContract; day chi la lop hien thi.
  const [thieuThongTin, setThieuThongTin] = useState<ThieuThongTin[]>([]);
  const [openBoSung, setOpenBoSung] = useState<boolean>(false);
  const [dangLuuBoSung, setDangLuuBoSung] = useState<boolean>(false);
  const [duLieuBoSung, setDuLieuBoSung] = useState<Record<string, string>>({});

  useEffect(() => {
    let huy = false;
    const tai = async () => {
      try {
        const res = await fetch(`/api/hop-dong/${hopDongId}/kiem-tra-truoc-ky`, {
          headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : undefined,
        });
        if (!res.ok) return;
        const json = await res.json();
        if (!huy && Array.isArray(json?.data)) setThieuThongTin(json.data);
      } catch {
        // Khong chan giao dien neu goi that bai: backend van chan luc ky.
      }
    };
    void tai();
    return () => { huy = true; };
  }, [hopDongId, accessToken, timestamp]);

  const nhanBen = (ben: string) =>
    ben === 'BEN_A' ? 'Bên A' : ben === 'BEN_B' ? 'Bên B' : 'Hợp đồng';

  // Chi cac truong thuoc ve nguoi (Ben A / Ben B) moi sua duoc ngay tai day.
  // Truong thuoc hop dong (gia thue, thoi han...) phai sua o form hop dong.
  const suaTaiCho = thieuThongTin.filter((t) => t.suaTaiCho);
  const phaiSuaNoiKhac = thieuThongTin.filter((t) => !t.suaTaiCho);

  const luuBoSung = async () => {
    setDangLuuBoSung(true);
    try {
      const res = await fetch(`/api/hop-dong/${hopDongId}/bo-sung-thong-tin`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
        },
        body: JSON.stringify(duLieuBoSung),
      });
      const json = await res.json();
      if (!res.ok || json?.success === false) {
        throw new Error(json?.message || 'Không lưu được thông tin bổ sung');
      }
      if (Array.isArray(json?.data)) setThieuThongTin(json.data);
      setDuLieuBoSung({});
      setOpenBoSung(false);
      handleRefresh();
    } catch (e) {
      alert(e instanceof Error ? e.message : 'Không lưu được thông tin bổ sung');
    } finally {
      setDangLuuBoSung(false);
    }
  };

  // Map ma truong -> ten field trong BoSungThongTinRequest cua backend.
  const tenTruong = (ma: string) => {
    const bang: Record<string, string> = {
      BEN_A_HO_TEN: 'benAHoTen',
      BEN_A_SO_CCCD: 'benASoCccd',
      BEN_A_SO_DIEN_THOAI: 'benASoDienThoai',
      BEN_A_DIA_CHI: 'benADiaChi',
      BEN_B_HO_TEN: 'benBHoTen',
      BEN_B_SO_CCCD: 'benBSoCccd',
      BEN_B_SO_DIEN_THOAI: 'benBSoDienThoai',
      BEN_B_NGAY_SINH: 'benBNgaySinh',
      BEN_B_DIA_CHI: 'benBDiaChi',
    };
    return bang[ma] || ma;
  };

  const documentPdfUrl = `/api/hop-dong/${hopDongId}/document?format=pdf&t=${timestamp}&token=${accessToken || ''}`;
  const downloadPdfUrl = `/api/hop-dong/${hopDongId}/document?format=pdf&download=1&token=${accessToken || ''}`;

  const handleRefresh = () => {
    setIsRefreshing(true);
    setTimestamp(Date.now());
    setTimeout(() => setIsRefreshing(false), 500);
  };

  const handleSignatureSuccess = (sigData: any) => {
    handleRefresh();
    if (onSigned) {
      onSigned(sigData);
    }
  };

  const getSignatureBadge = () => {
    switch (signatureStatus) {
      case 'COMPLETED':
        return (
          <Badge className="bg-emerald-50 text-emerald-700 border-emerald-200 flex items-center gap-1">
            <CheckCircle2 className="h-3 w-3" /> Đã ký hoàn tất (2 bên)
          </Badge>
        );
      case 'LANDLORD_SIGNED':
        return (
          <Badge className="bg-blue-50 text-blue-700 border-blue-200 flex items-center gap-1">
            <Clock className="h-3 w-3" /> Chủ trọ đã ký - Chờ khách ký
          </Badge>
        );
      case 'TENANT_SIGNED':
        return (
          <Badge className="bg-amber-50 text-amber-700 border-amber-200 flex items-center gap-1">
            <Clock className="h-3 w-3" /> Khách đã ký - Chờ chủ trọ ký
          </Badge>
        );
      case 'REJECTED':
        return (
          <Badge variant="destructive" className="flex items-center gap-1">
            <AlertCircle className="h-3 w-3" /> Từ chối ký
          </Badge>
        );
      default:
        return (
          <Badge variant="outline" className="text-slate-600 border-slate-200 flex items-center gap-1">
            <Clock className="h-3 w-3" /> Chưa ký
          </Badge>
        );
    }
  };

  const isSignable = canSign !== undefined ? canSign : (
    signatureStatus !== 'COMPLETED' && (
      (role === 'LANDLORD' && signatureStatus !== 'LANDLORD_SIGNED') ||
      (role === 'TENANT' && signatureStatus !== 'TENANT_SIGNED')
    )
  );

  return (
    <div className={cn("space-y-4", className)}>
      {/* Header Toolbar */}
      <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-3 p-3 bg-[#FBFBFA] border border-slate-200 rounded-xl">
        <div className="flex items-center gap-3 flex-wrap">
          <span className="text-sm font-bold text-[#243B5A]">
            {maHopDong ? `Hợp đồng: ${maHopDong}` : 'Văn bản hợp đồng'}
          </span>
          {getSignatureBadge()}
        </div>

        <div className="flex items-center gap-2 flex-wrap">
          <Button
            size="sm"
            variant="outline"
            type="button"
            onClick={handleRefresh}
            disabled={isRefreshing}
            className="text-xs h-8"
          >
            <RefreshCw className={cn("h-3.5 w-3.5 mr-1", isRefreshing && "animate-spin")} />
            Làm mới
          </Button>

          <Button size="sm" asChild variant="outline" className="text-xs h-8">
            <a href={documentPdfUrl} target="_blank" rel="noreferrer">
              <ExternalLink className="h-3.5 w-3.5 mr-1" /> Mở tab mới
            </a>
          </Button>

          <Button size="sm" asChild variant="outline" className="text-xs h-8 text-[#243B5A]">
            <a href={downloadPdfUrl} download={`hop-dong-${maHopDong || hopDongId}.pdf`}>
              <FileDown className="h-3.5 w-3.5 mr-1 text-[#4FA7A0]" /> Tải PDF
            </a>
          </Button>

          {!hideSignButton && isSignable && (
            <Button
              size="sm"
              type="button"
              onClick={() => setOpenSignPad(true)}
              disabled={thieuThongTin.length > 0}
              title={thieuThongTin.length > 0 ? 'Cần bổ sung đủ thông tin bắt buộc trước khi ký' : undefined}
              className="bg-[#4FA7A0] hover:bg-[#3D8B85] text-white text-xs h-8 font-semibold shadow-sm"
            >
              <PenTool className="h-3.5 w-3.5 mr-1" />
              {role === 'LANDLORD' ? 'Ký xác nhận (Bên A)' : 'Ký xác nhận (Bên B)'}
            </Button>
          )}
        </div>
      </div>

      {!hideSignButton && isSignable && thieuThongTin.length > 0 && (
        <div className="flex gap-3 p-3 border border-amber-200 bg-amber-50 rounded-xl">
          <AlertCircle className="h-5 w-5 text-amber-600 shrink-0 mt-0.5" />
          <div className="text-sm flex-1">
            <p className="font-semibold text-amber-900">
              Chưa thể ký — hợp đồng còn thiếu {thieuThongTin.length} thông tin bắt buộc
            </p>
            <p className="text-amber-800 mt-0.5">
              Ký xong hợp đồng sẽ bị khóa dữ liệu, vui lòng bổ sung trước:
            </p>
            <ul className="list-disc pl-5 mt-1 space-y-0.5 text-amber-800">
              {thieuThongTin.map((item) => (
                <li key={item.ma}>
                  {nhanBen(item.ben)}: {item.nhan}
                </li>
              ))}
            </ul>
            {suaTaiCho.length > 0 && (
              <Button
                size="sm"
                type="button"
                onClick={() => setOpenBoSung(true)}
                className="mt-3 bg-amber-600 hover:bg-amber-700 text-white text-xs h-8"
              >
                Bổ sung ngay ({suaTaiCho.length} trường)
              </Button>
            )}
            {phaiSuaNoiKhac.length > 0 && (
              <p className="text-amber-800 mt-2 text-xs italic">
                {phaiSuaNoiKhac.map((t) => t.nhan).join(', ')} phải sửa ở tab
                &quot;Thông tin hợp đồng&quot;.
              </p>
            )}
          </div>
        </div>
      )}

      <Dialog open={openBoSung} onOpenChange={setOpenBoSung}>
        <DialogContent className="sm:max-w-[520px]">
          <DialogHeader>
            <DialogTitle>Bổ sung thông tin bắt buộc</DialogTitle>
          </DialogHeader>
          <div className="space-y-3 max-h-[60vh] overflow-y-auto pr-1">
            {suaTaiCho.map((t) => (
              <div key={t.ma} className="space-y-1.5">
                <Label htmlFor={t.ma} className="text-sm">
                  {nhanBen(t.ben)} — {t.nhan} <span className="text-red-500">*</span>
                </Label>
                <Input
                  id={t.ma}
                  type={t.ma === 'BEN_B_NGAY_SINH' ? 'date' : 'text'}
                  value={duLieuBoSung[tenTruong(t.ma)] || ''}
                  onChange={(e) =>
                    setDuLieuBoSung((prev) => ({ ...prev, [tenTruong(t.ma)]: e.target.value }))
                  }
                  placeholder={t.ma.includes('DIA_CHI') ? 'Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành' : ''}
                />
              </div>
            ))}
          </div>
          <DialogFooter>
            <Button type="button" variant="outline" onClick={() => setOpenBoSung(false)} disabled={dangLuuBoSung}>
              Hủy
            </Button>
            <Button
              type="button"
              onClick={luuBoSung}
              disabled={dangLuuBoSung || suaTaiCho.some((t) => !(duLieuBoSung[tenTruong(t.ma)] || '').trim())}
              className="bg-[#4FA7A0] hover:bg-[#3D8B85] text-white"
            >
              {dangLuuBoSung ? 'Đang lưu...' : 'Lưu và kiểm tra lại'}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* PDF Viewer Embed */}
      <div className="border border-slate-200 rounded-xl overflow-hidden bg-slate-100 shadow-sm">
        <iframe
          key={timestamp}
          src={documentPdfUrl}
          className="w-full h-[650px] border-0 bg-white"
          title="Văn bản Hợp đồng PDF"
        />
        <div className="bg-white p-2.5 border-t border-slate-200 text-center text-xs text-[#6B7A90]">
          Nếu trình duyệt không hiển thị được PDF, vui lòng{' '}
          <a
            href={downloadPdfUrl}
            className="text-[#4FA7A0] font-semibold underline hover:text-[#3D8B85]"
          >
            bấm vào đây để tải file PDF về máy
          </a>.
        </div>
      </div>

      {/* Signature Dialog */}
      <HopDongSignaturePad
        hopDongId={hopDongId}
        role={role}
        signerId={signerId}
        isOpen={openSignPad}
        onClose={() => setOpenSignPad(false)}
        onSuccess={handleSignatureSuccess}
        accessToken={accessToken}
      />
    </div>
  );
}
