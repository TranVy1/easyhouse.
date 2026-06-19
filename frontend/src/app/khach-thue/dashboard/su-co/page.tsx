'use client';

import { useState, useEffect, useCallback } from 'react';
import Image from 'next/image';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger, DialogFooter } from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { AlertTriangle, Clock, Wrench } from 'lucide-react';
import { useSession } from 'next-auth/react';
import { toast } from 'sonner';
import { SuCo } from '@/types';
import { useTenantDashboard } from '../context';

export default function TenantIncidentsPage() {
  const session = useSession()?.data;
  const accessToken = session?.accessToken;
  const { data: dashboardData } = useTenantDashboard();
  const [incidents, setIncidents] = useState<SuCo[]>([]);
  const [loading, setLoading] = useState(true);
  
  const [open, setOpen] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [formData, setFormData] = useState({
    tieuDe: '',
    moTa: '',
    loaiSuCo: 'khac',
    uuTien: 'trung_binh'
  });
  const [file, setFile] = useState<File | null>(null);

  const fetchIncidents = useCallback(async () => {
    try {
      setLoading(true);
      const res = await fetch('/api/tenant/su-co', {
        headers: {
          'Authorization': `Bearer ${accessToken}`
        }
      });
      const data = await res.json();
      if (data.success) {
        setIncidents(data.data.data);
      } else {
        toast.error('Không thể tải danh sách sự cố');
      }
    } catch (error) {
      console.error('Lỗi khi tải sự cố:', error);
      toast.error('Có lỗi xảy ra');
    } finally {
      setLoading(false);
    }
  }, [accessToken]);

  useEffect(() => {
    if (accessToken) {
      void fetchIncidents();
    }
  }, [accessToken, fetchIncidents]);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files.length > 0) {
      const selectedFile = e.target.files[0];
      if (selectedFile.size > 5 * 1024 * 1024) {
        toast.error('Kích thước ảnh tối đa là 5MB');
        return;
      }
      setFile(selectedFile);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!dashboardData?.hopDongHienTai?.phong) {
      toast.error('Không tìm thấy phòng đang thuê để báo sự cố');
      return;
    }

    try {
      setSubmitting(true);
      let imageUrls: string[] = [];

      // 1. Upload ảnh nếu có
      if (file) {
        const fileData = new FormData();
        fileData.append('file', file);
        
        const uploadRes = await fetch('/api/upload', {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${session?.accessToken}`
          },
          body: fileData
        });
        
        const uploadData = await uploadRes.json();
        if (uploadData.success) {
          imageUrls = [uploadData.data.secure_url || uploadData.data.url];
        } else {
          toast.error('Lỗi upload ảnh, sẽ báo cáo sự cố không có ảnh');
        }
      }

      // 2. Gửi báo cáo
      const payload = {
        ...formData,
        phongId: dashboardData.hopDongHienTai.phong.id || dashboardData.hopDongHienTai.phong._id,
        anhSuCo: imageUrls
      };

      const res = await fetch('/api/su-co', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${session?.accessToken}`
        },
        body: JSON.stringify(payload)
      });

      const result = await res.json();
      if (result.success) {
        toast.success('Báo cáo sự cố thành công!');
        setOpen(false);
        setFormData({
          tieuDe: '',
          moTa: '',
          loaiSuCo: 'khac',
          uuTien: 'trung_binh'
        });
        setFile(null);
        fetchIncidents();
      } else {
        throw new Error(result.error || 'Lỗi gửi báo cáo');
      }
    } catch (error: unknown) {
      console.error('Lỗi báo cáo:', error);
      toast.error(error instanceof Error ? error.message : 'Có lỗi xảy ra');
    } finally {
      setSubmitting(false);
    }
  };

  const formatDate = (dateStr: string | Date | undefined) => {
    if (!dateStr) return '---';
    return new Date(dateStr).toLocaleDateString('vi-VN');
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'PENDING':
        return <Badge variant="secondary" className="bg-yellow-100 text-yellow-800">Chờ xử lý</Badge>;
      case 'IN_PROGRESS':
        return <Badge className="bg-[#243B5A]">Đang xử lý</Badge>;
      case 'RESOLVED':
        return <Badge className="bg-green-600">Đã giải quyết</Badge>;
      case 'CANCELLED':
        return <Badge variant="outline">Đã hủy</Badge>;
      default:
        return <Badge variant="outline">{status}</Badge>;
    }
  };

  const getTypeLabel = (type: string) => {
    const types: Record<string, string> = {
      dien_nuoc: 'Điện/Nước',
      noi_that: 'Nội thất',
      ve_sinh: 'Vệ sinh',
      an_ninh: 'An ninh',
      internet: 'Internet',
      khac: 'Khác'
    };
    return types[type] || 'Khác';
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#4FA7A0]"></div>
      </div>
    );
  }

  const hasActiveContract = !!dashboardData?.hopDongHienTai;

  return (
    <div className="p-4 md:p-8 max-w-6xl mx-auto space-y-6 pb-24 md:pb-8">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold tracking-tight">Sự Cố & Yêu Cầu</h1>
          <p className="text-muted-foreground mt-1">Quản lý các báo cáo sự cố hoặc yêu cầu sửa chữa</p>
        </div>
        
        {hasActiveContract ? (
          <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
              <Button className="shrink-0">Báo cáo sự cố mới</Button>
            </DialogTrigger>
            <DialogContent className="sm:max-w-[500px]">
              <DialogHeader>
                <DialogTitle>Báo cáo sự cố</DialogTitle>
                <DialogDescription>
                  Gửi yêu cầu sửa chữa hoặc báo cáo vấn đề cho chủ nhà/quản lý.
                </DialogDescription>
              </DialogHeader>
              <form onSubmit={handleSubmit} className="space-y-4 pt-4">
                <div className="space-y-2">
                  <Label htmlFor="tieuDe">Tiêu đề <span className="text-red-500">*</span></Label>
                  <Input 
                    id="tieuDe" 
                    placeholder="VD: Hư vòi nước nhà vệ sinh" 
                    required 
                    value={formData.tieuDe}
                    onChange={(e) => setFormData({...formData, tieuDe: e.target.value})}
                  />
                </div>
                
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="loaiSuCo">Loại sự cố</Label>
                    <select 
                      id="loaiSuCo"
                      className="flex h-10 w-full items-center justify-between rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                      value={formData.loaiSuCo}
                      onChange={(e) => setFormData({...formData, loaiSuCo: e.target.value})}
                    >
                      <option value="dien_nuoc">Điện / Nước</option>
                      <option value="noi_that">Nội thất</option>
                      <option value="ve_sinh">Vệ sinh</option>
                      <option value="an_ninh">An ninh</option>
                      <option value="internet">Internet</option>
                      <option value="khac">Khác</option>
                    </select>
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="uuTien">Mức độ ưu tiên</Label>
                    <select 
                      id="uuTien"
                      className="flex h-10 w-full items-center justify-between rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                      value={formData.uuTien}
                      onChange={(e) => setFormData({...formData, uuTien: e.target.value})}
                    >
                      <option value="thap">Thấp</option>
                      <option value="trung_binh">Trung bình</option>
                      <option value="cao">Cao</option>
                      <option value="khan_cap">Khẩn cấp</option>
                    </select>
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="moTa">Mô tả chi tiết <span className="text-red-500">*</span></Label>
                  <Textarea 
                    id="moTa" 
                    placeholder="Mô tả rõ hơn về tình trạng gặp phải..." 
                    rows={4}
                    required
                    value={formData.moTa}
                    onChange={(e) => setFormData({...formData, moTa: e.target.value})}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="anhSuCo">Ảnh đính kèm (không bắt buộc)</Label>
                  <Input 
                    id="anhSuCo" 
                    type="file" 
                    accept="image/*"
                    onChange={handleFileChange}
                    className="cursor-pointer file:cursor-pointer"
                  />
                  {file && <p className="text-xs text-green-600 mt-1">Đã chọn: {file.name}</p>}
                </div>

                <DialogFooter className="pt-4">
                  <Button type="button" variant="outline" onClick={() => setOpen(false)} disabled={submitting}>
                    Hủy
                  </Button>
                  <Button type="submit" disabled={submitting}>
                    {submitting ? 'Đang gửi...' : 'Gửi báo cáo'}
                  </Button>
                </DialogFooter>
              </form>
            </DialogContent>
          </Dialog>
        ) : (
          <Button disabled variant="outline" title="Bạn chưa có phòng đang thuê để báo sự cố">
            Báo cáo sự cố
          </Button>
        )}
      </div>

      {incidents.length === 0 ? (
        <Card className="bg-gray-50 border-dashed border-2">
          <CardContent className="flex flex-col items-center justify-center p-12 text-center space-y-4">
            <div className="bg-gray-100 p-4 rounded-full text-gray-400">
              <AlertTriangle className="h-12 w-12" />
            </div>
            <div>
              <h3 className="font-bold text-lg text-gray-800">Chưa có sự cố nào</h3>
              <p className="text-sm text-gray-500 mt-1 max-w-md mx-auto">
                Khi có vấn đề hư hỏng cần hỗ trợ, bạn có thể tạo báo cáo để quản lý nhà theo dõi và xử lý.
              </p>
            </div>
            {hasActiveContract && (
              <Button onClick={() => setOpen(true)} variant="outline" className="mt-2">
                Tạo báo cáo đầu tiên
              </Button>
            )}
          </CardContent>
        </Card>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {incidents.map((incident) => {
            const id = incident.id || incident._id;
            const trangThai = incident.trangThai as string;
            
            return (
              <Card key={id as string} className="flex flex-col hover:shadow-md transition-shadow">
                <CardHeader className="pb-3">
                  <div className="flex justify-between items-start mb-2">
                    <Badge variant="outline" className="bg-gray-50 text-gray-600">
                      {getTypeLabel(incident.loaiSuCo)}
                    </Badge>
                    {getStatusBadge(trangThai)}
                  </div>
                  <CardTitle className="text-lg line-clamp-1">{incident.tieuDe}</CardTitle>
                  <CardDescription className="flex items-center gap-2 mt-1">
                    <Clock className="h-3 w-3" /> {formatDate(incident.ngayBaoCao || incident.taoLuc)}
                  </CardDescription>
                </CardHeader>
                
                <CardContent className="flex-1 space-y-4">
                  <p className="text-sm text-gray-600 line-clamp-3 bg-gray-50 p-3 rounded border border-gray-100">
                    {incident.moTa}
                  </p>

                  {incident.ghiChuChuNha && (
                    <div className="mt-3 p-3 bg-[#4FA7A0]/10 border border-[#4FA7A0]/20 rounded-md">
                      <p className="text-xs font-semibold text-[#243B5A] mb-1 flex items-center gap-1">
                        <Wrench className="h-3 w-3" /> Quản lý phản hồi:
                      </p>
                      <p className="text-sm text-[#243B5A]">{incident.ghiChuChuNha}</p>
                    </div>
                  )}
                  
                  {incident.anhSuCo && incident.anhSuCo.length > 0 && (
                    <div className="mt-2">
                      <p className="text-xs text-gray-500 mb-1">Ảnh đính kèm:</p>
                      <div className="flex gap-2 overflow-x-auto pb-2">
                        {incident.anhSuCo.map((url, i) => (
                          <div key={i} className="h-16 w-16 rounded overflow-hidden shrink-0 border relative">
                            <Image
                              src={url} 
                              alt="Sự cố" 
                              fill
                              sizes="64px"
                              className="object-cover"
                            />
                          </div>
                        ))}
                      </div>
                    </div>
                  )}
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}
    </div>
  );
}
