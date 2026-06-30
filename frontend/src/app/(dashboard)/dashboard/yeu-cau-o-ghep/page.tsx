'use client';

import { useState, useEffect, useCallback, useMemo } from 'react';
import { useSession } from 'next-auth/react';
import { Button } from '@/components/ui/button';
import { CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { RefreshCw, CheckCircle, XCircle, Users } from 'lucide-react';
import { DashboardCard } from '@/components/dashboard/shared-ui';
import { toast } from 'sonner';

type YeuCauOGhepRequest = {
  id: string;
  trangThai: string;
  tenPhong?: string;
  loiNhan?: string;
  khachThue?: {
    hoTen?: string;
    soDienThoai?: string;
    soCccd?: string;
  };
};

type UserSessionWithNhaTroId = {
  nhaTroId?: string;
};

export default function AdminYeuCauOGhepPage() {
  const session = useSession();
  const accessToken = session?.data?.accessToken;
  const nhaTroId = (session?.data?.user as UserSessionWithNhaTroId | undefined)?.nhaTroId; // Typically admins have nhaTroId in session or selected in global state

  const [requests, setRequests] = useState<YeuCauOGhepRequest[]>([]);
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
    } catch {
      toast.error("Lỗi kết nối");
    } finally {
      setLoading(false);
    }
  }, [accessToken, nhaTroId]);

  useEffect(() => {
    fetchRequests();
  }, [fetchRequests]);

  const requestStats = useMemo(() => {
    const total = requests.length;
    const pending = requests.filter(req => req.trangThai === 'PENDING_ADMIN').length;
    const approved = requests.filter(req => req.trangThai === 'APPROVED').length;
    const rejected = requests.filter(req => req.trangThai === 'REJECTED').length;

    return { total, pending, approved, rejected };
  }, [requests]);

  const hasPendingRequests = requestStats.pending > 0;

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
    } catch {
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
    <div className="space-y-6">
      <section className="yeu-cau-o-ghep-hero">
        <div className="yeu-cau-o-ghep-hero__content">
          <div className="yeu-cau-o-ghep-hero__eyebrow">
            <Users className="h-4 w-4" aria-hidden="true" />
            YÊU CẦU Ở GHÉP
          </div>

          <div className="yeu-cau-o-ghep-hero__title-row">
            <h1>Yêu cầu ở ghép</h1>
            <span className={`yeu-cau-o-ghep-hero__status-badge ${hasPendingRequests ? '' : 'is-stable'}`}>
              {hasPendingRequests ? 'Cần duyệt yêu cầu' : 'Không có yêu cầu mới'}
            </span>
          </div>

          <p>Theo dõi, xét duyệt và quản lý các yêu cầu người thuê muốn vào ở chung phòng.</p>

          <div className="yeu-cau-o-ghep-hero__insight">
            {hasPendingRequests ? (
              <>
                Hiện có <strong>{requestStats.pending} yêu cầu đang chờ duyệt</strong>, nên xử lý sớm để tránh bỏ lỡ khách thuê tiềm năng.
              </>
            ) : (
              <>Không có yêu cầu chờ duyệt. Hệ thống ở ghép đang ổn định.</>
            )}
          </div>

          <div className="yeu-cau-o-ghep-hero__actions">
            <Button onClick={() => fetchRequests()} disabled={loading} variant="outline" className="yeu-cau-o-ghep-hero__button">
              <RefreshCw className={`mr-2 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
              Làm mới
            </Button>
          </div>

          <div className="yeu-cau-o-ghep-hero__stats">
            <div className="yeu-cau-o-ghep-hero__stat-card is-total" style={{ animationDelay: '80ms' }}>
              <span>Tổng yêu cầu</span>
              <strong>{requestStats.total}</strong>
            </div>
            <div className="yeu-cau-o-ghep-hero__stat-card is-pending" style={{ animationDelay: '140ms' }}>
              <span>Chờ duyệt</span>
              <strong>{requestStats.pending}</strong>
            </div>
            <div className="yeu-cau-o-ghep-hero__stat-card is-approved" style={{ animationDelay: '200ms' }}>
              <span>Đã duyệt</span>
              <strong>{requestStats.approved}</strong>
            </div>
            <div className="yeu-cau-o-ghep-hero__stat-card is-rejected" style={{ animationDelay: '260ms' }}>
              <span>Đã từ chối</span>
              <strong>{requestStats.rejected}</strong>
            </div>
          </div>
        </div>

      </section>

      <style>{`
        .yeu-cau-o-ghep-hero {
          position: relative;
          overflow: hidden;
          min-height: 320px;
          border-radius: 28px;
          padding: 42px 48px;
          color: #ffffff;
          background-image:
            linear-gradient(
              90deg,
              rgba(13, 35, 61, 0.92) 0%,
              rgba(18, 58, 82, 0.78) 42%,
              rgba(18, 88, 105, 0.38) 68%,
              rgba(18, 88, 105, 0.10) 100%
            ),
            url("/images/yeu-cau-o-ghep-hero-bg.png");
          background-size: cover;
          background-position: center right;
          background-repeat: no-repeat;
          box-shadow: 0 24px 60px rgba(36, 59, 90, 0.18);
          border: 1px solid rgba(255, 255, 255, 0.16);
          animation: heroFadeIn 520ms cubic-bezier(0.22, 1, 0.36, 1) both;
        }

        .yeu-cau-o-ghep-hero__content {
          width: min(100%, 760px);
        }

        .yeu-cau-o-ghep-hero__eyebrow {
          display: inline-flex;
          align-items: center;
          gap: 8px;
          color: rgba(255, 255, 255, 0.82);
          font-size: 14px;
          font-weight: 800;
          letter-spacing: 0.06em;
          text-transform: uppercase;
        }

        .yeu-cau-o-ghep-hero__title-row {
          display: flex;
          align-items: center;
          gap: 16px;
          margin-top: 14px;
          flex-wrap: wrap;
        }

        .yeu-cau-o-ghep-hero h1 {
          max-width: 720px;
          margin: 0;
          font-size: clamp(40px, 5vw, 72px);
          line-height: 1.02;
          font-weight: 800;
          letter-spacing: 0;
          color: #ffffff;
          text-shadow: 0 12px 32px rgba(0, 0, 0, 0.24);
        }

        .yeu-cau-o-ghep-hero p {
          max-width: 720px;
          margin-top: 18px;
          color: rgba(255, 255, 255, 0.88);
          font-size: clamp(17px, 1.45vw, 23px);
          line-height: 1.55;
        }

        .yeu-cau-o-ghep-hero__status-badge {
          display: inline-flex;
          align-items: center;
          gap: 8px;
          min-height: 38px;
          padding: 8px 14px;
          border-radius: 999px;
          color: #F2A45B;
          font-size: 14px;
          font-weight: 800;
          background: rgba(242, 164, 91, 0.16);
          border: 1px solid rgba(242, 164, 91, 0.28);
          backdrop-filter: blur(14px);
          box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.12);
          white-space: nowrap;
        }

        .yeu-cau-o-ghep-hero__status-badge.is-stable {
          color: #7FFFE0;
          background: rgba(79, 167, 160, 0.16);
          border-color: rgba(127, 255, 224, 0.22);
        }

        .yeu-cau-o-ghep-hero__insight {
          display: inline-flex;
          align-items: center;
          max-width: 800px;
          margin-top: 22px;
          padding: 12px 18px;
          border-radius: 999px;
          color: rgba(255, 255, 255, 0.92);
          background: rgba(255, 255, 255, 0.12);
          border: 1px solid rgba(255, 255, 255, 0.18);
          backdrop-filter: blur(14px);
          box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.12);
          font-weight: 600;
          line-height: 1.5;
          text-wrap: pretty;
        }

        .yeu-cau-o-ghep-hero__insight strong {
          color: #F2A45B;
          font-weight: 800;
          white-space: nowrap;
        }

        .yeu-cau-o-ghep-hero__stats {
          display: grid;
          grid-template-columns: repeat(4, minmax(0, 1fr));
          gap: 16px;
          margin-top: 28px;
          max-width: 740px;
        }

        .yeu-cau-o-ghep-hero__stat-card {
          min-height: 118px;
          padding: 18px;
          border-radius: 22px;
          background: rgba(255, 255, 255, 0.92);
          border: 1px solid rgba(255, 255, 255, 0.58);
          box-shadow: 0 18px 42px rgba(0, 0, 0, 0.12);
          transition:
            transform 220ms ease-out,
            box-shadow 220ms ease-out,
            border-color 220ms ease-out;
          animation: heroCardIn 520ms cubic-bezier(0.22, 1, 0.36, 1) both;
        }

        .yeu-cau-o-ghep-hero__stat-card:hover {
          transform: translateY(-3px);
          box-shadow: 0 24px 58px rgba(0, 0, 0, 0.16);
        }

        .yeu-cau-o-ghep-hero__stat-card span {
          display: block;
          min-height: 36px;
          color: #64748b;
          font-size: 13px;
          font-weight: 800;
          line-height: 1.3;
        }

        .yeu-cau-o-ghep-hero__stat-card strong {
          display: block;
          margin-top: 12px;
          font-size: clamp(28px, 3vw, 38px);
          line-height: 1;
          font-weight: 900;
          letter-spacing: 0;
          font-variant-numeric: tabular-nums;
        }

        .yeu-cau-o-ghep-hero__stat-card.is-total strong {
          color: #243B5A;
        }

        .yeu-cau-o-ghep-hero__stat-card.is-pending strong {
          color: #F2A45B;
        }

        .yeu-cau-o-ghep-hero__stat-card.is-approved strong {
          color: #267D76;
        }

        .yeu-cau-o-ghep-hero__stat-card.is-rejected strong {
          color: #dc2626;
        }

        .yeu-cau-o-ghep-hero__actions {
          position: absolute;
          top: 34px;
          right: 38px;
          z-index: 3;
          display: flex;
          align-items: center;
          gap: 14px;
          flex-wrap: wrap;
          pointer-events: auto;
        }

        .yeu-cau-o-ghep-hero__button {
          position: relative;
          overflow: hidden;
          min-height: 46px;
          padding: 0 18px;
          border-radius: 16px;
          font-weight: 700;
          color: #ffffff;
          background: rgba(255, 255, 255, 0.13);
          border: 1px solid rgba(255, 255, 255, 0.24);
          backdrop-filter: blur(14px);
          transition:
            transform 220ms ease-out,
            box-shadow 220ms ease-out,
            background-color 220ms ease-out,
            border-color 220ms ease-out;
        }

        .yeu-cau-o-ghep-hero__button:hover {
          color: #ffffff;
          background: rgba(255, 255, 255, 0.2);
          border-color: rgba(255, 255, 255, 0.36);
          transform: translateY(-2px);
          box-shadow: 0 14px 32px rgba(0, 0, 0, 0.18);
        }

        .yeu-cau-o-ghep-hero__button svg {
          transition: transform 220ms ease-out;
        }

        .yeu-cau-o-ghep-hero__button:hover svg {
          transform: rotate(16deg);
        }

        @keyframes heroFadeIn {
          from {
            opacity: 0;
            transform: translateY(12px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }

        @keyframes heroCardIn {
          from {
            opacity: 0;
            transform: translateY(10px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }

        @media (max-width: 1024px) {
          .yeu-cau-o-ghep-hero {
            padding: 34px 32px;
          }

          .yeu-cau-o-ghep-hero__content {
            width: min(100%, 720px);
          }

          .yeu-cau-o-ghep-hero__actions {
            position: relative;
            top: auto;
            right: auto;
            margin-top: 24px;
            justify-content: flex-start;
          }

          .yeu-cau-o-ghep-hero__stats {
            grid-template-columns: repeat(2, minmax(0, 1fr));
            max-width: 560px;
          }
        }

        @media (max-width: 768px) {
          .yeu-cau-o-ghep-hero {
            min-height: auto;
            padding: 28px 22px;
            border-radius: 22px;
            background-position: 72% center;
            background-image:
              linear-gradient(
                90deg,
                rgba(13, 35, 61, 0.96) 0%,
                rgba(18, 58, 82, 0.92) 58%,
                rgba(18, 88, 105, 0.72) 100%
              ),
              url("/images/yeu-cau-o-ghep-hero-bg.png");
          }

          .yeu-cau-o-ghep-hero__title-row {
            align-items: flex-start;
            flex-direction: column;
            gap: 12px;
          }

          .yeu-cau-o-ghep-hero__insight {
            width: 100%;
            border-radius: 18px;
            font-size: 14px;
          }

          .yeu-cau-o-ghep-hero__stats {
            grid-template-columns: 1fr;
          }
        }

        @media (max-width: 520px) {
          .yeu-cau-o-ghep-hero__button {
            width: 100%;
          }
        }

        @media (prefers-reduced-motion: reduce) {
          .yeu-cau-o-ghep-hero,
          .yeu-cau-o-ghep-hero__button,
          .yeu-cau-o-ghep-hero__stat-card,
          .yeu-cau-o-ghep-hero__insight {
            animation: none !important;
            transition: none !important;
            transform: none !important;
          }
        }
      `}</style>

      <DashboardCard className="overflow-hidden border-0 shadow-sm ring-1 ring-[#E5E0D8]">
        <CardHeader className="border-b bg-[#F2E8DC]/70 p-5 md:p-6">
          <CardTitle className="text-lg">Danh sách yêu cầu xin ở ghép</CardTitle>
          <CardDescription>Danh sách đã được người trong phòng đồng ý, chờ chủ trọ duyệt</CardDescription>
        </CardHeader>
        <CardContent className="p-5 md:p-6">
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
                      {req.loiNhan && <p className="mt-1 italic text-slate-500">&quot; {req.loiNhan} &quot;</p>}
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
      </DashboardCard>
    </div>
  );
}
