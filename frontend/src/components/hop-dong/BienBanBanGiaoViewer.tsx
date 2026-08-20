'use client';

import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { RefreshCw, ExternalLink, FileDown, PenTool, AlertCircle, CheckCircle2, Clock } from 'lucide-react';
import { HopDongSignaturePad } from './HopDongSignaturePad';
import { cn } from '@/lib/utils';

interface Props {
  hopDongId: string;
  maHopDong?: string;
  /** CHUA_LAP | CHO_KY | BEN_A_DA_KY | BEN_B_DA_KY | HOAN_TAT */
  bienBanTrangThai?: string;
  /** BEN_A = chu tro (ben nhan), BEN_B = khach thue (ben ban giao). */
  vaiTro: 'BEN_A' | 'BEN_B';
  accessToken?: string;
  onSigned?: () => void;
  className?: string;
}

/**
 * Bien ban ban giao khi tra phong: xem PDF va ky dien tu.
 *
 * Chieu ky NGUOC voi hop dong thue — o day Ben A la chu tro (ben NHAN ban giao)
 * va Ben B la khach thue (ben BAN GIAO), dung theo mau bien ban giay.
 */
export function BienBanBanGiaoViewer({
  hopDongId, maHopDong, bienBanTrangThai, vaiTro, accessToken, onSigned, className,
}: Props) {
  const [timestamp, setTimestamp] = useState<number>(Date.now());
  const [openPad, setOpenPad] = useState(false);
  const [dangLamMoi, setDangLamMoi] = useState(false);

  const pdfUrl = `/api/hop-dong/${hopDongId}/bien-ban-ban-giao?format=pdf&t=${timestamp}`;
  const taiUrl = `/api/hop-dong/${hopDongId}/bien-ban-ban-giao?format=pdf&download=1`;

  const lamMoi = () => {
    setDangLamMoi(true);
    setTimestamp(Date.now());
    setTimeout(() => setDangLamMoi(false), 500);
  };

  const chuaLap = bienBanTrangThai === 'CHUA_LAP' || !bienBanTrangThai;
  const daKyRoi = vaiTro === 'BEN_A'
    ? bienBanTrangThai === 'BEN_A_DA_KY' || bienBanTrangThai === 'HOAN_TAT'
    : bienBanTrangThai === 'BEN_B_DA_KY' || bienBanTrangThai === 'HOAN_TAT';
  const kyDuoc = !chuaLap && !daKyRoi;

  const badge = () => {
    switch (bienBanTrangThai) {
      case 'HOAN_TAT':
        return <Badge className="bg-emerald-50 text-emerald-700 border-emerald-200 flex items-center gap-1">
          <CheckCircle2 className="h-3 w-3" /> Đã ký đủ hai bên</Badge>;
      case 'BEN_A_DA_KY':
        return <Badge className="bg-blue-50 text-blue-700 border-blue-200 flex items-center gap-1">
          <Clock className="h-3 w-3" /> Chủ trọ đã ký - Chờ khách ký</Badge>;
      case 'BEN_B_DA_KY':
        return <Badge className="bg-amber-50 text-amber-700 border-amber-200 flex items-center gap-1">
          <Clock className="h-3 w-3" /> Khách đã ký - Chờ chủ trọ ký</Badge>;
      case 'CHO_KY':
        return <Badge variant="outline" className="flex items-center gap-1">
          <Clock className="h-3 w-3" /> Chờ ký</Badge>;
      default:
        return <Badge variant="outline">Chưa lập</Badge>;
    }
  };

  return (
    <div className={cn('space-y-4', className)}>
      <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-3 p-3 bg-[#FBFBFA] border border-slate-200 rounded-xl">
        <div className="flex items-center gap-3 flex-wrap">
          <span className="text-sm font-bold text-[#243B5A]">
            {maHopDong ? `Biên bản bàn giao: ${maHopDong}` : 'Biên bản bàn giao'}
          </span>
          {badge()}
        </div>

        <div className="flex items-center gap-2 flex-wrap">
          <Button size="sm" variant="outline" type="button" onClick={lamMoi}
            disabled={dangLamMoi || chuaLap} className="text-xs h-8">
            <RefreshCw className={cn('h-3.5 w-3.5 mr-1', dangLamMoi && 'animate-spin')} /> Làm mới
          </Button>
          <Button size="sm" asChild variant="outline" className="text-xs h-8" disabled={chuaLap}>
            <a href={pdfUrl} target="_blank" rel="noreferrer">
              <ExternalLink className="h-3.5 w-3.5 mr-1" /> Mở tab mới
            </a>
          </Button>
          <Button size="sm" asChild variant="outline" className="text-xs h-8 text-[#243B5A]" disabled={chuaLap}>
            <a href={taiUrl} download={`bien-ban-ban-giao-${maHopDong || hopDongId}.pdf`}>
              <FileDown className="h-3.5 w-3.5 mr-1 text-[#4FA7A0]" /> Tải PDF
            </a>
          </Button>
          {daKyRoi && (
            <Badge className="bg-emerald-100 text-emerald-800 border-emerald-300 text-xs py-1 px-2.5 font-bold flex items-center gap-1">
              <CheckCircle2 className="h-3.5 w-3.5 text-emerald-600" />
              {vaiTro === 'BEN_A' ? 'Bạn (Chủ trọ) đã ký' : 'Bạn (Khách thuê) đã ký'}
            </Badge>
          )}
          {kyDuoc && (
            <Button size="sm" type="button" onClick={() => setOpenPad(true)}
              className="bg-orange-600 hover:bg-orange-700 text-white text-xs h-8 px-3.5 font-bold shadow-sm">
              <PenTool className="h-3.5 w-3.5 mr-1.5" />
              {vaiTro === 'BEN_A' ? 'Ký xác nhận (Bên A)' : 'Ký xác nhận (Bên B - Bạn)'}
            </Button>
          )}
        </div>
      </div>

      {chuaLap ? (
        <div className="flex gap-3 p-3 border border-amber-200 bg-amber-50 rounded-xl text-sm">
          <AlertCircle className="h-5 w-5 text-amber-600 shrink-0 mt-0.5" />
          <div>
            <p className="font-semibold text-amber-900">Chưa lập biên bản bàn giao</p>
            <p className="text-amber-800 mt-0.5">
              Cần kiểm kê đầy đủ số lượng và tình trạng thực tế của từng tài sản trong phòng,
              sau đó biên bản sẽ tự chuyển sang trạng thái chờ ký.
            </p>
          </div>
        </div>
      ) : (
        <div className="border rounded-xl overflow-hidden bg-slate-50" style={{ height: 640 }}>
          <iframe src={pdfUrl} className="w-full h-full" title="Biên bản bàn giao" />
        </div>
      )}

      <HopDongSignaturePad
        isOpen={openPad}
        onClose={() => setOpenPad(false)}
        hopDongId={hopDongId}
        accessToken={accessToken}
        role={vaiTro === 'BEN_A' ? 'LANDLORD' : 'TENANT'}
        title={vaiTro === 'BEN_A'
          ? 'Ký biên bản bàn giao (Bên A - Chủ trọ nhận bàn giao)'
          : 'Ký biên bản bàn giao (Bên B - Khách thuê bàn giao)'}
        endpoint={`/api/hop-dong/${hopDongId}/bien-ban-ban-giao/ky`}
        buildBody={(chuKyBase64: string) => ({ vaiTro, chuKyBase64 })}
        onSuccess={() => { lamMoi(); onSigned?.(); }}
      />
    </div>
  );
}
