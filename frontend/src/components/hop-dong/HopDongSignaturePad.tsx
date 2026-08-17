'use client';

import { useState, useRef, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from '@/components/ui/dialog';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Input } from '@/components/ui/input';
import { Loader2, PenTool, Upload, RefreshCw } from 'lucide-react';
import { toast } from 'sonner';

interface HopDongSignaturePadProps {
  hopDongId: string;
  role: 'LANDLORD' | 'TENANT';
  signerId?: string;
  isOpen: boolean;
  onClose: () => void;
  onSuccess: (signatureData?: any) => void;
  accessToken?: string;
  title?: string;
  description?: string;
}

export function HopDongSignaturePad({
  hopDongId,
  role,
  signerId,
  isOpen,
  onClose,
  onSuccess,
  accessToken,
  title,
  description,
}: HopDongSignaturePadProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [isDrawing, setIsDrawing] = useState(false);
  const [hasDrawn, setHasDrawn] = useState(false);
  const [uploadedBase64, setUploadedBase64] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [activeTab, setActiveTab] = useState<'draw' | 'upload'>('draw');

  useEffect(() => {
    if (isOpen && activeTab === 'draw') {
      const timer = setTimeout(() => {
        initCanvas();
      }, 100);
      return () => clearTimeout(timer);
    }
  }, [isOpen, activeTab]);

  const initCanvas = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    ctx.strokeStyle = '#000000';
    ctx.lineWidth = 3;
    ctx.lineCap = 'round';
    ctx.lineJoin = 'round';
  };

  const getPos = (e: React.MouseEvent<HTMLCanvasElement> | React.TouchEvent<HTMLCanvasElement>) => {
    const canvas = canvasRef.current;
    if (!canvas) return { x: 0, y: 0 };
    const rect = canvas.getBoundingClientRect();
    const clientX = 'touches' in e ? e.touches[0].clientX : e.clientX;
    const clientY = 'touches' in e ? e.touches[0].clientY : e.clientY;
    return {
      x: clientX - rect.left,
      y: clientY - rect.top,
    };
  };

  const startDrawing = (e: React.MouseEvent<HTMLCanvasElement> | React.TouchEvent<HTMLCanvasElement>) => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    setIsDrawing(true);
    setHasDrawn(true);
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

  const clearCanvas = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    setHasDrawn(false);
  };

  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    if (!file.type.startsWith('image/')) {
      toast.error('Vui lòng chọn file hình ảnh (PNG, JPG, WebP)');
      return;
    }
    const reader = new FileReader();
    reader.onloadend = () => {
      setUploadedBase64(reader.result as string);
    };
    reader.readAsDataURL(file);
  };

  const handleSave = async () => {
    let signatureBase64 = '';
    if (activeTab === 'draw') {
      const canvas = canvasRef.current;
      if (!canvas || !hasDrawn) {
        toast.error('Vui lòng vẽ chữ ký trước khi xác nhận');
        return;
      }
      signatureBase64 = canvas.toDataURL('image/png');
    } else {
      if (!uploadedBase64) {
        toast.error('Vui lòng chọn ảnh chữ ký');
        return;
      }
      signatureBase64 = uploadedBase64;
    }

    setSubmitting(true);
    try {
      const response = await fetch(`/api/hop-dong/${hopDongId}/sign`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
        },
        body: JSON.stringify({
          signerId: signerId || undefined,
          role,
          signatureBase64,
          ipAddress: '127.0.0.1',
          userAgent: typeof navigator !== 'undefined' ? navigator.userAgent : 'Browser',
        }),
      });

      const result = await response.json().catch(() => ({}));
      if (response.ok && result.success) {
        toast.success(result.message || 'Ký hợp đồng thành công');
        onSuccess(result.data);
        onClose();
      } else {
        toast.error(result.message || 'Lỗi khi ký hợp đồng');
      }
    } catch (err) {
      console.error('Signature submission error:', err);
      toast.error('Có lỗi xảy ra khi gửi chữ ký');
    } finally {
      setSubmitting(false);
    }
  };

  const defaultTitle = role === 'LANDLORD'
    ? 'Ký xác nhận hợp đồng (Bên A - Chủ cho thuê)'
    : 'Ký xác nhận hợp đồng (Bên B - Khách thuê)';

  const defaultDescription = 'Chữ ký điện tử của bạn sẽ được lưu vết kiểm toán và đóng dấu trực tiếp vào văn bản hợp đồng PDF chính thức.';

  return (
    <Dialog open={isOpen} onOpenChange={(open) => !open && !submitting && onClose()}>
      <DialogContent className="sm:max-w-[560px]">
        <DialogHeader>
          <DialogTitle className="text-[#243B5A] flex items-center gap-2">
            <PenTool className="h-5 w-5 text-[#4FA7A0]" />
            {title || defaultTitle}
          </DialogTitle>
          <DialogDescription className="text-xs text-[#6B7A90]">
            {description || defaultDescription}
          </DialogDescription>
        </DialogHeader>

        <Tabs value={activeTab} onValueChange={(v) => setActiveTab(v as 'draw' | 'upload')} className="w-full mt-2">
          <TabsList className="grid w-full grid-cols-2">
            <TabsTrigger value="draw" className="flex items-center gap-1.5 text-xs font-semibold">
              <PenTool className="h-3.5 w-3.5" /> Vẽ chữ ký trực tiếp
            </TabsTrigger>
            <TabsTrigger value="upload" className="flex items-center gap-1.5 text-xs font-semibold">
              <Upload className="h-3.5 w-3.5" /> Tải ảnh chữ ký
            </TabsTrigger>
          </TabsList>

          <TabsContent value="draw" className="space-y-3 py-2">
            <div className="rounded-xl border border-slate-200 bg-[#FBFBFA] p-1 shadow-inner">
              <canvas
                ref={canvasRef}
                width={520}
                height={200}
                className="w-full h-[200px] border border-dashed border-slate-300 rounded-lg bg-white cursor-crosshair touch-none"
                onMouseDown={startDrawing}
                onMouseMove={draw}
                onMouseUp={stopDrawing}
                onMouseLeave={stopDrawing}
                onTouchStart={startDrawing}
                onTouchMove={draw}
                onTouchEnd={stopDrawing}
              />
            </div>
            <div className="flex justify-between items-center text-xs text-[#6B7A90]">
              <span className="italic">Dùng chuột hoặc ngón tay để vẽ chữ ký trong khung trên</span>
              <Button variant="ghost" size="sm" type="button" onClick={clearCanvas} disabled={submitting} className="h-8 text-xs text-slate-600 hover:text-red-600">
                <RefreshCw className="h-3 w-3 mr-1" /> Xóa vẽ lại
              </Button>
            </div>
          </TabsContent>

          <TabsContent value="upload" className="space-y-3 py-2">
            <div className="border-2 border-dashed border-slate-200 rounded-xl p-6 flex flex-col items-center justify-center space-y-3 bg-[#FBFBFA]">
              {uploadedBase64 ? (
                <div className="space-y-2 text-center">
                  <div className="max-h-[140px] max-w-[260px] mx-auto p-2 bg-white rounded-lg border border-slate-200 shadow-sm flex items-center justify-center">
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img src={uploadedBase64} alt="Signature Preview" className="max-h-[120px] max-w-full object-contain" />
                  </div>
                  <Button variant="outline" size="sm" type="button" onClick={() => setUploadedBase64(null)} className="text-xs h-7">
                    Chọn ảnh khác
                  </Button>
                </div>
              ) : (
                <>
                  <div className="rounded-full bg-[#4FA7A0]/10 p-3 text-[#4FA7A0]">
                    <Upload className="h-6 w-6" />
                  </div>
                  <div className="text-center">
                    <p className="text-xs font-semibold text-[#243B5A]">Tải lên file ảnh chữ ký (PNG, JPG)</p>
                    <p className="text-[11px] text-[#6B7A90] mt-0.5">Khuyến khích dùng ảnh nền trong suốt (PNG) để hiển thị đẹp nhất.</p>
                  </div>
                  <Input
                    type="file"
                    accept="image/*"
                    className="max-w-[260px] text-xs h-9"
                    onChange={handleFileUpload}
                  />
                </>
              )}
            </div>
          </TabsContent>
        </Tabs>

        <div className="flex justify-end gap-2 pt-3 border-t border-slate-100">
          <Button variant="outline" size="sm" type="button" onClick={onClose} disabled={submitting}>
            Hủy
          </Button>
          <Button
            size="sm"
            type="button"
            onClick={handleSave}
            disabled={submitting || (activeTab === 'draw' ? !hasDrawn : !uploadedBase64)}
            className="bg-[#4FA7A0] hover:bg-[#3D8B85] text-white"
          >
            {submitting ? (
              <>
                <Loader2 className="h-4 w-4 animate-spin mr-1.5" />
                Đang lưu chữ ký...
              </>
            ) : (
              'Xác nhận & Ký hợp đồng'
            )}
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}
