'use client';

/**
 * FolderImageUploader – upload toàn bộ thư mục ảnh vào phòng tương ứng.
 *
 * Cấu trúc thư mục người dùng upload:
 *   HaiLong/
 *     Tang1/101/img1.jpg
 *     Tang1/102/img1.jpg
 *     Tang2/201/img1.jpg
 *
 * Logic phân tích webkitRelativePath:
 *   parts[0] = tên thư mục gốc (bỏ qua)
 *   parts[1] = tầng (bỏ qua, chỉ log)
 *   parts[2] = mã phòng (dùng để tìm trong DB)
 *   parts[3..] = tên file ảnh
 *
 * Upload qua: POST /api/media?doiTuong=ROOM&doiTuongId=<phongId>&loaiFile=ROOM_IMAGE
 * Lookup phòng: GET /api/phong/lookup-by-name?nhaTroId=<id>&tenPhong=<name>
 */

import React, { useCallback, useRef, useState } from 'react';
import { Button } from '@/components/ui/button';
import { Progress } from '@/components/ui/progress';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Label } from '@/components/ui/label';
import { Badge } from '@/components/ui/badge';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Separator } from '@/components/ui/separator';
import {
  AlertCircle,
  CheckCircle2,
  FolderOpen,
  Upload,
  X,
  Info,
  Loader2,
  ImagePlus,
} from 'lucide-react';
import { toast } from 'sonner';
import type { ToaNha } from '@/types';

// ─────────────────────────────────────────────────────────
// Types
// ─────────────────────────────────────────────────────────

interface ParsedImage {
  file: File;
  relativePath: string; // Tang1/101/img1.jpg
  tang: string;         // Tang1
  tenPhong: string;     // 101
  fileName: string;     // img1.jpg
}

interface UploadResult {
  relativePath: string;
  tenPhong: string;
  tang: string;
  status: 'success' | 'error' | 'skip';
  message?: string;
  url?: string;
}

interface UploadStats {
  total: number;
  success: number;
  error: number;
  skip: number;
}

interface LookupCache {
  [key: string]: { id: string; ten: string } | null;
}

interface FolderImageUploaderProps {
  toaNhaList: ToaNha[];
  accessToken?: string;
  onComplete?: () => void;
  trigger?: React.ReactNode;
}

// ─────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────

const ACCEPTED_TYPES = ['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'image/heic'];
const MAX_FILE_MB = 10;

function parseFolderFiles(files: FileList): ParsedImage[] {
  const results: ParsedImage[] = [];

  for (let i = 0; i < files.length; i++) {
    const file = files[i];
    const relativePath = (file as File & { webkitRelativePath: string }).webkitRelativePath;

    if (!relativePath) continue;

    // Filter by image type
    if (!ACCEPTED_TYPES.includes(file.type)) continue;

    // Filter by size
    if (file.size > MAX_FILE_MB * 1024 * 1024) continue;

    // Parse path: root/Tang1/101/img1.jpg
    const parts = relativePath.split('/');
    if (parts.length < 4) continue; // need at least root/tang/phong/file

    const tang = parts[1];     // Tang1
    const tenPhong = parts[2]; // 101
    const fileName = parts.slice(3).join('/'); // img1.jpg

    if (!tang || !tenPhong || !fileName) continue;

    results.push({ file, relativePath, tang, tenPhong, fileName });
  }

  return results;
}

function groupByPhong(images: ParsedImage[]): Map<string, ParsedImage[]> {
  const map = new Map<string, ParsedImage[]>();
  for (const img of images) {
    const key = `${img.tang}/${img.tenPhong}`;
    if (!map.has(key)) map.set(key, []);
    map.get(key)!.push(img);
  }
  return map;
}

// ─────────────────────────────────────────────────────────
// Main Component
// ─────────────────────────────────────────────────────────

export function FolderImageUploader({
  toaNhaList,
  accessToken,
  onComplete,
  trigger,
}: FolderImageUploaderProps) {
  const [open, setOpen] = useState(false);
  const [selectedNhaTroId, setSelectedNhaTroId] = useState('');
  const [parsedImages, setParsedImages] = useState<ParsedImage[]>([]);
  const [previewGroups, setPreviewGroups] = useState<Map<string, ParsedImage[]>>(new Map());
  const [uploading, setUploading] = useState(false);
  const [progress, setProgress] = useState(0);
  const [results, setResults] = useState<UploadResult[]>([]);
  const [stats, setStats] = useState<UploadStats | null>(null);
  const [phase, setPhase] = useState<'idle' | 'preview' | 'uploading' | 'done'>('idle');

  const inputRef = useRef<HTMLInputElement>(null);
  const lookupCache = useRef<LookupCache>({});

  // ── Reset ──────────────────────────────────────────────

  const reset = useCallback(() => {
    setParsedImages([]);
    setPreviewGroups(new Map());
    setResults([]);
    setStats(null);
    setProgress(0);
    setPhase('idle');
    lookupCache.current = {};
    if (inputRef.current) inputRef.current.value = '';
  }, []);

  const handleClose = useCallback(() => {
    if (uploading) return;
    setOpen(false);
    setTimeout(reset, 300);
  }, [uploading, reset]);

  // ── File selection ─────────────────────────────────────

  const handleFileChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (!files || files.length === 0) return;

    const parsed = parseFolderFiles(files);
    if (parsed.length === 0) {
      toast.error('Không tìm thấy ảnh hợp lệ trong thư mục. Kiểm tra lại cấu trúc: gốc/tầng/phòng/ảnh.jpg');
      return;
    }

    setParsedImages(parsed);
    setPreviewGroups(groupByPhong(parsed));
    setPhase('preview');
    setResults([]);
    setStats(null);
  }, []);

  // ── Lookup room ────────────────────────────────────────

  const lookupRoom = useCallback(async (nhaTroId: string, tenPhong: string): Promise<{ id: string; ten: string } | null> => {
    const cacheKey = `${nhaTroId}::${tenPhong}`;
    if (cacheKey in lookupCache.current) {
      return lookupCache.current[cacheKey];
    }

    try {
      const params = new URLSearchParams({ nhaTroId, tenPhong });
      const res = await fetch(`/api/phong/lookup-by-name?${params}`, {
        headers: {
          ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
        },
      });

      if (!res.ok) {
        lookupCache.current[cacheKey] = null;
        return null;
      }

      const json = await res.json();
      if (json.success && json.data?.found) {
        const room = { id: json.data.id as string, ten: json.data.ten as string };
        lookupCache.current[cacheKey] = room;
        return room;
      }

      lookupCache.current[cacheKey] = null;
      return null;
    } catch {
      lookupCache.current[cacheKey] = null;
      return null;
    }
  }, [accessToken]);

  // ── Upload single image ────────────────────────────────

  const uploadImage = useCallback(async (img: ParsedImage, phongId: string): Promise<string> => {
    const formData = new FormData();
    formData.append('file', img.file, img.fileName);
    formData.append('doiTuong', 'ROOM');
    formData.append('doiTuongId', phongId);
    formData.append('loaiFile', 'ROOM_IMAGE');

    const res = await fetch('/api/media', {
      method: 'POST',
      headers: {
        ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
      },
      body: formData,
    });

    const json = await res.json();
    if (!res.ok || !json.success) {
      throw new Error(json.message || `HTTP ${res.status}`);
    }

    return (json.data?.url as string) ?? '';
  }, [accessToken]);

  // ── Main upload flow ───────────────────────────────────

  const handleUpload = useCallback(async () => {
    if (!selectedNhaTroId) {
      toast.error('Vui lòng chọn tòa nhà trước khi upload');
      return;
    }
    if (parsedImages.length === 0) return;

    setUploading(true);
    setPhase('uploading');
    setResults([]);
    setProgress(0);

    const uploadResults: UploadResult[] = [];
    const notFoundRooms = new Set<string>();

    for (let i = 0; i < parsedImages.length; i++) {
      const img = parsedImages[i];

      // Lookup room
      const room = await lookupRoom(selectedNhaTroId, img.tenPhong);

      if (!room) {
        if (!notFoundRooms.has(img.tenPhong)) notFoundRooms.add(img.tenPhong);
        uploadResults.push({
          relativePath: img.relativePath,
          tenPhong: img.tenPhong,
          tang: img.tang,
          status: 'skip',
          message: `Không tìm thấy phòng "${img.tenPhong}" trong tòa nhà`,
        });
      } else {
        try {
          const url = await uploadImage(img, room.id);
          uploadResults.push({
            relativePath: img.relativePath,
            tenPhong: img.tenPhong,
            tang: img.tang,
            status: 'success',
            url,
            message: `→ ${room.ten}`,
          });
        } catch (err) {
          uploadResults.push({
            relativePath: img.relativePath,
            tenPhong: img.tenPhong,
            tang: img.tang,
            status: 'error',
            message: err instanceof Error ? err.message : 'Lỗi không xác định',
          });
        }
      }

      // Update progress after each file
      setProgress(Math.round(((i + 1) / parsedImages.length) * 100));
      setResults([...uploadResults]);
    }

    const stats: UploadStats = {
      total: parsedImages.length,
      success: uploadResults.filter(r => r.status === 'success').length,
      error: uploadResults.filter(r => r.status === 'error').length,
      skip: uploadResults.filter(r => r.status === 'skip').length,
    };

    setStats(stats);
    setPhase('done');
    setUploading(false);

    if (stats.success > 0) {
      toast.success(`Upload xong: ${stats.success}/${stats.total} ảnh thành công`);
      onComplete?.();
    } else {
      toast.error('Không upload được ảnh nào. Kiểm tra danh sách lỗi bên dưới.');
    }
  }, [selectedNhaTroId, parsedImages, lookupRoom, uploadImage, onComplete]);

  // ─────────────────────────────────────────────────────
  // Render helpers
  // ─────────────────────────────────────────────────────

  const phongCount = previewGroups.size;
  const imageCount = parsedImages.length;

  return (
    <Dialog open={open} onOpenChange={(v) => { if (!v) handleClose(); else setOpen(true); }}>
      <DialogTrigger asChild>
        {trigger ?? (
          <Button variant="outline" size="sm">
            <ImagePlus className="h-4 w-4 mr-2" />
            Upload ảnh hàng loạt
          </Button>
        )}
      </DialogTrigger>

      <DialogContent className="max-w-3xl max-h-[90vh] flex flex-col gap-0 p-0">
        {/* Header */}
        <DialogHeader className="px-6 pt-6 pb-4 border-b">
          <DialogTitle className="flex items-center gap-2 text-lg">
            <FolderOpen className="h-5 w-5 text-blue-600" />
            Upload ảnh hàng loạt từ thư mục
          </DialogTitle>
          <DialogDescription className="text-sm text-muted-foreground">
            Chọn thư mục có cấu trúc: <code className="bg-muted px-1 rounded text-xs">Tòa nhà / Tầng / Phòng / ảnh.jpg</code>
          </DialogDescription>
        </DialogHeader>

        {/* Body */}
        <div className="flex-1 overflow-hidden flex flex-col px-6 py-4 gap-4">

          {/* Step 1: Select property */}
          <div className="space-y-1.5">
            <Label className="text-sm font-medium">1. Chọn tòa nhà</Label>
            <Select value={selectedNhaTroId} onValueChange={setSelectedNhaTroId} disabled={uploading}>
              <SelectTrigger className="w-full">
                <SelectValue placeholder="Chọn tòa nhà..." />
              </SelectTrigger>
              <SelectContent>
                {toaNhaList.map(tn => (
                  <SelectItem key={tn._id ?? tn.id} value={(tn._id ?? tn.id)!}>
                    {tn.tenToaNha}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Step 2: Select folder */}
          <div className="space-y-1.5">
            <Label className="text-sm font-medium">2. Chọn thư mục ảnh</Label>
            <div
              className="border-2 border-dashed border-muted-foreground/30 rounded-lg p-6 text-center cursor-pointer hover:border-blue-400 hover:bg-blue-50/50 transition-colors"
              onClick={() => !uploading && inputRef.current?.click()}
            >
              <Upload className="h-8 w-8 mx-auto mb-2 text-muted-foreground" />
              <p className="text-sm text-muted-foreground">
                Click để chọn thư mục, hoặc kéo thả vào đây
              </p>
              <p className="text-xs text-muted-foreground/70 mt-1">
                Hỗ trợ JPG, PNG, WEBP, HEIC – Tối đa {MAX_FILE_MB}MB/ảnh
              </p>
              {phase !== 'idle' && (
                <p className="text-xs font-medium text-blue-600 mt-2">
                  Đã chọn: {imageCount} ảnh trong {phongCount} phòng
                </p>
              )}
            </div>
            <input
              ref={inputRef}
              type="file"
              // @ts-expect-error webkitdirectory not in standard TS types
              webkitdirectory="true"
              multiple
              accept="image/*"
              className="hidden"
              onChange={handleFileChange}
              disabled={uploading}
            />
          </div>

          {/* Preview: group by phong */}
          {phase === 'preview' && previewGroups.size > 0 && (
            <div className="space-y-1.5">
              <div className="flex items-center gap-2">
                <Label className="text-sm font-medium">3. Xem trước phân tích</Label>
                <Badge variant="secondary" className="text-xs">{phongCount} phòng · {imageCount} ảnh</Badge>
              </div>
              <ScrollArea className="h-36 rounded-md border bg-muted/30 p-2">
                {Array.from(previewGroups.entries()).map(([key, imgs]) => (
                  <div key={key} className="flex items-center gap-2 py-1 px-2 rounded hover:bg-muted">
                    <FolderOpen className="h-3.5 w-3.5 text-amber-500 flex-shrink-0" />
                    <span className="text-sm font-mono font-medium">{key}</span>
                    <span className="text-xs text-muted-foreground ml-auto">{imgs.length} ảnh</span>
                  </div>
                ))}
              </ScrollArea>
            </div>
          )}

          {/* Upload progress */}
          {(phase === 'uploading' || phase === 'done') && (
            <div className="space-y-2">
              <div className="flex items-center justify-between text-sm">
                <span className="font-medium flex items-center gap-1">
                  {phase === 'uploading' && <Loader2 className="h-3.5 w-3.5 animate-spin" />}
                  {phase === 'done' && <CheckCircle2 className="h-3.5 w-3.5 text-green-600" />}
                  {phase === 'uploading' ? 'Đang upload...' : 'Hoàn thành'}
                </span>
                <span className="text-muted-foreground">{progress}%</span>
              </div>
              <Progress value={progress} className="h-2" />

              {/* Stats summary */}
              {stats && (
                <div className="grid grid-cols-3 gap-2 pt-1">
                  <div className="rounded-md bg-green-50 border border-green-200 p-2 text-center">
                    <p className="text-lg font-bold text-green-700">{stats.success}</p>
                    <p className="text-xs text-green-600">Thành công</p>
                  </div>
                  <div className="rounded-md bg-red-50 border border-red-200 p-2 text-center">
                    <p className="text-lg font-bold text-red-700">{stats.error}</p>
                    <p className="text-xs text-red-600">Lỗi upload</p>
                  </div>
                  <div className="rounded-md bg-yellow-50 border border-yellow-200 p-2 text-center">
                    <p className="text-lg font-bold text-yellow-700">{stats.skip}</p>
                    <p className="text-xs text-yellow-600">Bỏ qua</p>
                  </div>
                </div>
              )}
            </div>
          )}

          {/* Results list */}
          {results.length > 0 && (
            <div className="space-y-1.5 flex-1 min-h-0">
              <Label className="text-sm font-medium flex items-center gap-1">
                <Info className="h-3.5 w-3.5" />
                Chi tiết kết quả ({results.length})
              </Label>
              <ScrollArea className="h-44 rounded-md border">
                <div className="p-2 space-y-1">
                  {results.map((r, i) => (
                    <div
                      key={i}
                      className={`flex items-start gap-2 p-2 rounded-md text-xs ${
                        r.status === 'success' ? 'bg-green-50' :
                        r.status === 'error' ? 'bg-red-50' : 'bg-yellow-50'
                      }`}
                    >
                      {r.status === 'success' && <CheckCircle2 className="h-3.5 w-3.5 text-green-600 flex-shrink-0 mt-0.5" />}
                      {r.status === 'error' && <AlertCircle className="h-3.5 w-3.5 text-red-600 flex-shrink-0 mt-0.5" />}
                      {r.status === 'skip' && <X className="h-3.5 w-3.5 text-yellow-600 flex-shrink-0 mt-0.5" />}
                      <div className="flex-1 min-w-0">
                        <p className="font-mono truncate">{r.relativePath}</p>
                        {r.message && <p className={`mt-0.5 ${
                          r.status === 'success' ? 'text-green-700' :
                          r.status === 'error' ? 'text-red-700' : 'text-yellow-700'
                        }`}>{r.message}</p>}
                      </div>
                    </div>
                  ))}
                </div>
              </ScrollArea>
            </div>
          )}

          {/* Tips */}
          {phase === 'idle' && (
            <div className="rounded-md bg-blue-50 border border-blue-200 p-3 text-xs text-blue-700 space-y-1">
              <p className="font-semibold">📁 Cấu trúc thư mục cần có:</p>
              <pre className="font-mono text-[11px] leading-relaxed">
{`TòaNhà/
  Tang1/
    101/  ← mã hoặc tên phòng
      img1.jpg
    102/
      img1.jpg
  Tang2/
    201/
      img1.jpg`}
              </pre>
              <Separator className="bg-blue-200 my-1" />
              <p>Hệ thống sẽ tự động khớp tên thư mục &quot;101&quot; với phòng &quot;Phòng 101&quot; trong database.</p>
            </div>
          )}
        </div>

        {/* Footer actions */}
        <div className="border-t px-6 py-4 flex items-center justify-between gap-3">
          <Button variant="outline" size="sm" onClick={handleClose} disabled={uploading}>
            {phase === 'done' ? 'Đóng' : 'Hủy'}
          </Button>

          <div className="flex items-center gap-2">
            {phase !== 'idle' && phase !== 'uploading' && (
              <Button variant="ghost" size="sm" onClick={reset} disabled={uploading}>
                Chọn lại
              </Button>
            )}
            <Button
              size="sm"
              onClick={handleUpload}
              disabled={!selectedNhaTroId || parsedImages.length === 0 || uploading || phase === 'done'}
              className="gap-2"
            >
              {uploading ? (
                <><Loader2 className="h-4 w-4 animate-spin" />Đang upload...</>
              ) : (
                <><Upload className="h-4 w-4" />Upload {imageCount > 0 ? `${imageCount} ảnh` : ''}</>
              )}
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
