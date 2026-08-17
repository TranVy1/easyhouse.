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
import { cn } from '@/lib/utils';

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
  const [thieuThongTin, setThieuThongTin] = useState<string[]>([]);

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

  const documentPdfUrl = `/api/hop-dong/${hopDongId}/document?format=pdf&t=${timestamp}`;
  const downloadPdfUrl = `/api/hop-dong/${hopDongId}/document?format=pdf&download=1`;

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
          <div className="text-sm">
            <p className="font-semibold text-amber-900">
              Chưa thể ký — hợp đồng còn thiếu {thieuThongTin.length} thông tin bắt buộc
            </p>
            <p className="text-amber-800 mt-0.5">
              Ký xong hợp đồng sẽ bị khóa dữ liệu, vui lòng bổ sung trước:
            </p>
            <ul className="list-disc pl-5 mt-1 space-y-0.5 text-amber-800">
              {thieuThongTin.map((item) => (
                <li key={item}>{item}</li>
              ))}
            </ul>
          </div>
        </div>
      )}

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
