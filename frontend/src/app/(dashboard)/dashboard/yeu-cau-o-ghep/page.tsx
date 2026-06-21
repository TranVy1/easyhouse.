'use client';

import { useState, useEffect, useCallback } from 'react';
import { useSession } from 'next-auth/react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { RefreshCw, CheckCircle, XCircle } from 'lucide-react';
import { toast } from 'sonner';

export default function AdminYeuCauOGhepPage() {
  const session = useSession();
  const accessToken = session?.data?.accessToken;
  const nhaTroId = session?.data?.user?.nhaTroId; // Typically admins have nhaTroId in session or selected in global state

  const [requests, setRequests] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  const fetchRequests = useCallback(async () => {
    // If we don't have a specific house selected, we might fetch for a default one or get all. 
    // The backend endpoint requires nhaTroId: /api/admin/o-ghep/nha-tro/{nhaTroId}
    // As a fallback, we fetch all from a new endpoint if we don't have nhaTroId, but the user requested:
    if (!accessToken) return;

    try {
      setLoading(true);
      // Currently the backend requires a nhaTroId. If the admin manages multiple, they need to select it.
      // We will try fetching for the default nhaTroId of the user, or if not present, fetch from /api/toa-nha to get the first one.
      let currentNhaTroId = nhaTroId;
      if (!currentNhaTroId) {
        const tnRes = await fetch('/api/toa-nha', {
          headers: { Authorization: `Bearer ${accessToken}` }
        });
        const tnData = await tnRes.json();
        const items = Array.isArray(tnData.data) ? tnData.data : (tnData.data?.data || []);
        if (items.length > 0) {
          currentNhaTroId = items[0]._id || items[0].id;
        }
      }

      if (!currentNhaTroId) {
        setRequests([]);
        return;
      }

      const res = await fetch(`/api/admin/o-ghep/nha-tro/${currentNhaTroId}`, {
        headers: { Authorization: `Bearer ${accessToken}` }
      });
      const result = await res.json();
      if (result.success) {
        setRequests(result.data || []);
      } else {
        toast.error(result.message || "Lỗi khi tải danh sách yêu cầu");
      }
    } catch (err) {
      toast.error("Lỗi kết nối");
    } finally {
      setLoading(false);
    }
  }, [accessToken, nhaTroId]);

  useEffect(() => {
    fetchRequests();
  }, [fetchRequests]);

  const handleApprove = async (id: string, isApprove: boolean) => {
    if (!confirm(isApprove ? "Bạn chắc chắn muốn DUYỆT yêu cầu này?" : "Bạn chắc chắn muốn TỪ CHỐI yêu cầu này?")) return;
    
    try {
      const res = await fetch(`/api/admin/o-ghep/${id}/approve?isApprove=${isApprove}`, {
        method: 'PUT',
        headers: { Authorization: `Bearer ${accessToken}` }
      });
      const result = await res.json();
      if (result.success) {
        toast.success(isApprove ? "Đã duyệt thành công" : "Đã từ chối");
        fetchRequests();
      } else {
        toast.error(result.message || "Có lỗi xảy ra");
      }
    } catch (err) {
      toast.error("Lỗi kết nối");
    }
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'PENDING_TENANT': return <Badge variant="outline" className="text-slate-500">Chờ khách duyệt</Badge>;
      case 'PENDING_ADMIN': return <Badge variant="secondary" className="text-amber-600">Chờ chủ trọ duyệt</Badge>;
      case 'APPROVED': return <Badge className="bg-emerald-500">Đã duyệt</Badge>;
      case 'REJECTED': return <Badge variant="destructive">Đã từ chối</Badge>;
      default: return <Badge>{status}</Badge>;
    }
  };

  return (
    <div className="flex-1 space-y-4 p-4 md:p-8 pt-6">
      <div className="flex items-center justify-between">
        <h2 className="text-3xl font-bold tracking-tight">Yêu cầu ở ghép</h2>
        <Button onClick={() => fetchRequests()} disabled={loading} variant="outline" size="sm">
          <RefreshCw className={`mr-2 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
          Làm mới
        </Button>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Danh sách yêu cầu xin ở ghép</CardTitle>
          <CardDescription>Duyệt các yêu cầu người mới xin vào ở chung phòng (đã được người trong phòng đồng ý)</CardDescription>
        </CardHeader>
        <CardContent>
          {loading ? (
            <div className="flex justify-center p-8"><RefreshCw className="animate-spin text-slate-400" /></div>
          ) : requests.length === 0 ? (
            <div className="text-center p-8 text-slate-500">Không có yêu cầu nào</div>
          ) : (
            <div className="space-y-4">
              {requests.map(req => (
                <div key={req.id} className="flex items-center justify-between p-4 border rounded-lg shadow-sm bg-white">
                  <div>
                    <div className="flex items-center gap-2 mb-1">
                      <span className="font-semibold text-lg">{req.khachThue?.hoTen || 'Khách thuê'}</span>
                      <span className="text-sm text-slate-500">xin vào</span>
                      <span className="font-bold text-indigo-600">Phòng {req.tenPhong}</span>
                    </div>
                    <div className="text-sm text-slate-600">
                      <p>SĐT: {req.khachThue?.soDienThoai || '—'}</p>
                      <p>CCCD: {req.khachThue?.soCccd || '—'}</p>
                      {req.loiNhan && <p className="mt-1 italic text-slate-500">" {req.loiNhan} "</p>}
                    </div>
                  </div>
                  <div className="flex flex-col items-end gap-2">
                    {getStatusBadge(req.trangThai)}
                    {req.trangThai === 'PENDING_ADMIN' && (
                      <div className="flex gap-2 mt-2">
                        <Button size="sm" variant="outline" className="text-red-600 border-red-200 hover:bg-red-50" onClick={() => handleApprove(req.id, false)}>
                          <XCircle className="w-4 h-4 mr-1" /> Từ chối
                        </Button>
                        <Button size="sm" className="bg-emerald-600 hover:bg-emerald-700" onClick={() => handleApprove(req.id, true)}>
                          <CheckCircle className="w-4 h-4 mr-1" /> Duyệt
                        </Button>
                      </div>
                    )}
                  </div>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
