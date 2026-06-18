'use client';
import { useState, useEffect } from "react";
import { Copy, CheckCheck, AlertTriangle, Clock, RefreshCw, Receipt } from "lucide-react";
import { api, extractItems, ApiError } from "@/lib/api";
import { StatusBadge } from "@/components/ui/status-badge";

// Simple QR-like visual
function QRPlaceholder() {
  return (
    <div className="w-44 h-44 mx-auto rounded-2xl bg-[#FFFDF8] border-4 border-indigo-600 p-3 relative shadow-md">
      <div className="w-full h-full grid grid-cols-7 grid-rows-7 gap-0.5">
        {Array.from({ length: 49 }).map((_, i) => {
          const corners = [0,1,2,3,4,5,6,7,13,14,20,21,27,28,34,35,41,42,43,44,45,46,47,48];
          const inner = [8,9,10,15,16,17,22,23,24,29,30,31,36,37,38];
          const filled = [...corners, ...inner, 3, 10, 17, 24, 31, 25, 26, 32, 33];
          return (
            <div key={i} className={`rounded-sm ${filled.includes(i) ? "bg-[#243B5A]" : "bg-transparent"}`} />
          );
        })}
      </div>
      <div className="absolute inset-0 flex items-center justify-center">
        <div className="w-9 h-9 bg-[#FFFDF8] rounded-md flex items-center justify-center border border-[#E8DED2]">
          <div className="text-indigo-600 font-black text-[7px] leading-tight text-center">Viet<br />QR</div>
        </div>
      </div>
    </div>
  );
}

interface Bill {
  id: string;
  maHoaDon: string;
  period: string;
  total: string;
  totalRaw: number;
  status: string;
  dueDate: string;
  breakdown: { label: string; amount: string }[];
}

function mapBill(b: any): Bill {
  return {
    id: b._id || b.id,
    maHoaDon: b.maHoaDon || '',
    period: b.thang && b.nam ? `Tháng ${b.thang}/${b.nam}` : (b.thangBaoCao || 'Chưa xác định'),
    total: (b.tongTien || 0).toLocaleString('vi-VN'),
    totalRaw: b.tongTien || 0,
    status: b.trangThai || 'UNPAID',
    dueDate: b.hanThanhToan ? new Date(b.hanThanhToan).toLocaleDateString('vi-VN') : '',
    breakdown: [
      { label: 'Tiền phòng', amount: (b.tienPhong || 0).toLocaleString('vi-VN') },
      { label: 'Tiền điện', amount: (b.tienDien || 0).toLocaleString('vi-VN') },
      { label: 'Tiền nước', amount: (b.tienNuoc || 0).toLocaleString('vi-VN') },
    ].filter(item => item.amount !== '0'),
  };
}

export function BillingScreen() {
  const [tab, setTab] = useState<"unpaid" | "paid">("unpaid");
  const [copied, setCopied] = useState(false);
  const [bills, setBills] = useState<{ unpaid: Bill[]; paid: Bill[] }>({ unpaid: [], paid: [] });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const loadBills = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await api.get<any>('/api/tenant/hoa-don?limit=20');
      const items = extractItems<any>(data);
      setBills({
        unpaid: items.filter((b: any) => b.trangThai !== 'PAID').map(mapBill),
        paid: items.filter((b: any) => b.trangThai === 'PAID').map(mapBill),
      });
    } catch (e) {
      setError(e instanceof ApiError ? e.message : 'Không thể tải dữ liệu hóa đơn');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { loadBills(); }, []);

  const currentBills = bills[tab];

  const handleCopy = () => {
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  if (loading) {
    return (
      <div className="flex h-full items-center justify-center gap-2.5 text-[#6B7A8C]">
        <RefreshCw size={18} className="animate-spin text-indigo-500" />
        <span className="text-sm font-medium">Đang tải hóa đơn...</span>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex flex-col h-full items-center justify-center gap-4 px-8 text-center">
        <AlertTriangle size={36} className="text-red-400" />
        <p className="text-sm text-[#6B7A8C] font-medium">{error}</p>
        <button onClick={loadBills}
          className="flex items-center gap-2 px-4 py-2 bg-indigo-600 text-white text-sm font-bold rounded-xl">
          <RefreshCw size={14} /> Thử lại
        </button>
      </div>
    );
  }

  return (
    <div className="flex flex-col h-full bg-slate-100 overflow-y-auto">
      {/* Header */}
      <div className="bg-indigo-700 px-4 pt-12 pb-6 relative overflow-hidden shrink-0">
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,_var(--tw-gradient-stops))] from-indigo-500/30 via-transparent to-transparent pointer-events-none" />
        <div className="relative">
          <p className="text-indigo-300 text-[10px] font-bold uppercase tracking-widest mb-0.5">Tài khoản của tôi</p>
          <h1 className="text-white font-black text-xl">Hóa Đơn Tiền Phòng</h1>
          <p className="text-indigo-200 text-xs mt-1">Theo dõi và thanh toán hóa đơn hàng tháng</p>
        </div>
      </div>

      {/* Tab Toggle */}
      <div className="px-4 -mt-3 relative z-10">
        <div className="flex bg-[#FFFDF8] rounded-2xl p-1 shadow-sm border border-[#E8DED2]">
          {(["unpaid", "paid"] as const).map((t) => (
            <button
              key={t}
              onClick={() => setTab(t)}
              className={`flex-1 py-2.5 rounded-xl text-sm font-bold transition-all cursor-pointer ${
                tab === t ? "bg-indigo-600 text-white shadow-sm" : "text-[#6B7A8C] hover:text-[#243B5A]"
              }`}
            >
              {t === "unpaid" ? (
                <span className="flex items-center justify-center gap-1.5">
                  Chưa thanh toán
                  {bills.unpaid.length > 0 && (
                    <span className={`text-[9px] font-black px-1.5 py-0.5 rounded-full ${tab === "unpaid" ? "bg-[#FFFDF8]/25" : "bg-red-500 text-white"}`}>
                      {bills.unpaid.length}
                    </span>
                  )}
                </span>
              ) : "Đã thanh toán"}
            </button>
          ))}
        </div>
      </div>

      {/* Bills list */}
      <div className="flex-1 px-4 pt-4 pb-10 space-y-3">
        {currentBills.length === 0 && (
          <div className="flex flex-col items-center py-16 gap-3 text-center">
            <div className="w-14 h-14 rounded-2xl bg-[#FFFDF8] border border-[#E8DED2] flex items-center justify-center text-slate-300 shadow-sm">
              <Receipt size={26} />
            </div>
            <p className="font-bold text-[#6B7A8C] text-sm">
              {tab === "unpaid" ? "Không có hóa đơn chưa thanh toán" : "Chưa có hóa đơn đã thanh toán"}
            </p>
            <p className="text-xs text-[#6B7A8C] max-w-xs leading-relaxed">
              {tab === "unpaid" ? "Tuyệt vời! Bạn đã thanh toán đầy đủ tất cả hóa đơn." : "Lịch sử thanh toán sẽ xuất hiện tại đây."}
            </p>
          </div>
        )}

        {currentBills.map((bill) => {
          const isUnpaid = bill.status !== 'PAID';
          return (
            <div key={bill.id} className="bg-[#FFFDF8] rounded-2xl overflow-hidden shadow-sm border border-[#E8DED2]">
              {/* Bill Header */}
              <div className="px-4 py-3.5 flex items-center justify-between border-b border-slate-50">
                <div>
                  <p className="font-bold text-[#243B5A] text-sm">{bill.period}</p>
                  <p className="text-[10px] text-[#6B7A8C] mt-0.5">
                    {bill.maHoaDon}
                    {bill.dueDate && ` · Hạn: ${bill.dueDate}`}
                  </p>
                </div>
                <StatusBadge status={bill.status} />
              </div>

              {/* Breakdown */}
              {bill.breakdown.length > 0 && (
                <div className="px-4 py-3 space-y-2">
                  {bill.breakdown.map((item, i) => (
                    <div key={i} className="flex justify-between text-sm">
                      <span className="text-[#6B7A8C]">{item.label}</span>
                      <span className="text-[#243B5A] font-semibold">{item.amount}đ</span>
                    </div>
                  ))}
                  <div className="border-t border-dashed border-[#E8DED2] pt-2 mt-2 flex justify-between">
                    <span className="font-black text-[#243B5A]">Tổng cộng</span>
                    <span className="font-black text-indigo-700 text-base">{bill.total}đ</span>
                  </div>
                </div>
              )}

              {/* QR Payment for unpaid */}
              {isUnpaid && (
                <div className="px-4 pb-5 pt-2 border-t border-dashed border-[#E8DED2]">
                  <p className="text-center text-xs text-[#6B7A8C] mb-4 font-medium">
                    Quét mã để thanh toán qua ứng dụng ngân hàng
                  </p>
                  <QRPlaceholder />
                  <p className="text-center text-xs text-[#6B7A8C] mt-3">
                    Vietcombank · 1234567890 · NGUYEN VAN AN
                  </p>
                  <div className="flex gap-2 mt-4">
                    <button
                      onClick={handleCopy}
                      className="flex-1 flex items-center justify-center gap-2 border border-indigo-200 text-indigo-700 py-3 rounded-xl text-sm font-bold transition-colors hover:bg-indigo-50 cursor-pointer"
                    >
                      {copied ? <CheckCheck size={15} /> : <Copy size={15} />}
                      {copied ? "Đã sao chép" : "Sao chép STK"}
                    </button>
                  </div>
                </div>
              )}
            </div>
          );
        })}

        {tab === "paid" && currentBills.length > 0 && (
          <div className="flex items-center gap-2 bg-indigo-50 border border-indigo-100 rounded-xl px-4 py-3">
            <Clock size={14} className="text-indigo-400 shrink-0" />
            <p className="text-xs text-indigo-700 font-medium">Lịch sử thanh toán được lưu trong 12 tháng</p>
          </div>
        )}
      </div>
    </div>
  );
}
