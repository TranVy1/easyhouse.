'use client';
import { useState, useEffect } from "react";
import { Download, Copy, CheckCheck, AlertTriangle, Clock } from "lucide-react";

// Simple QR-like visual
function QRPlaceholder() {
  return (
    <div className="w-48 h-48 mx-auto rounded-2xl bg-white border-4 border-blue-600 p-3 relative shadow-md">
      <div className="w-full h-full grid grid-cols-7 grid-rows-7 gap-0.5">
        {Array.from({ length: 49 }).map((_, i) => {
          const corners = [0,1,2,3,4,5,6,7,13,14,20,21,27,28,34,35,41,42,43,44,45,46,47,48];
          const inner = [8,9,10,15,16,17,22,23,24,29,30,31,36,37,38];
          const filled = [...corners, ...inner, 3, 10, 17, 24, 31, 25, 26, 32, 33];
          return (
            <div
              key={i}
              className={`rounded-sm ${filled.includes(i) ? "bg-slate-900" : "bg-transparent"}`}
            />
          );
        })}
      </div>
      <div className="absolute inset-0 flex items-center justify-center">
        <div className="w-10 h-10 bg-white rounded-md flex items-center justify-center border border-slate-200">
          <div className="text-blue-600 font-black text-[8px] leading-tight text-center">Viet<br/>QR</div>
        </div>
      </div>
    </div>
  );
}

export function BillingScreen() {
  const [tab, setTab] = useState<"unpaid" | "paid">("unpaid");
  const [copied, setCopied] = useState(false);
  const [bills, setBills] = useState<{ unpaid: any[]; paid: any[] }>({ unpaid: [], paid: [] });

  useEffect(() => {
    fetch('/api/tenant/hoa-don')
      .then(res => res.json())
      .then(data => {
        const items = data.data?.content || data.data || [];
        const unpaid = items.filter((b: any) => b.trangThai !== 'PAID');
        const paid = items.filter((b: any) => b.trangThai === 'PAID');
        
        const mapBill = (b: any) => ({
          id: b._id || b.id,
          month: b.thangBaoCao || `Tháng ${new Date(b.ngayTao || Date.now()).getMonth() + 1}`,
          total: b.tongTien?.toLocaleString('vi-VN') || "0",
          status: b.trangThai === 'PAID' ? 'paid' : (b.trangThai === 'OVERDUE' ? 'overdue' : 'unpaid'),
          dueDate: b.hanThanhToan ? new Date(b.hanThanhToan).toLocaleDateString('vi-VN') : "",
          paidDate: b.ngayThanhToan ? new Date(b.ngayThanhToan).toLocaleDateString('vi-VN') : "",
          breakdown: [
            { label: "Tiền phòng", amount: (b.tienPhong || 0).toLocaleString('vi-VN') },
            { label: "Tiền điện", amount: (b.tienDien || 0).toLocaleString('vi-VN') },
            { label: "Tiền nước", amount: (b.tienNuoc || 0).toLocaleString('vi-VN') },
            { label: "Tiền dịch vụ", amount: (b.tienDichVu || 0).toLocaleString('vi-VN') },
          ].filter(item => item.amount !== "0")
        });

        setBills({
          unpaid: unpaid.map(mapBill),
          paid: paid.map(mapBill)
        });
      })
      .catch(err => console.error(err));
  }, []);

  const currentBills = bills[tab];

  const handleCopy = () => {
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC] overflow-y-auto">
      {/* Header */}
      <div className="bg-white px-4 pt-12 pb-4 shadow-sm">
        <h1 className="text-slate-900 mb-4" style={{ fontSize: "1.25rem", fontWeight: 700 }}>
          Hóa Đơn Của Tôi
        </h1>
        {/* Toggle */}
        <div className="flex bg-[#F1F5F9] rounded-2xl p-1">
          {(["unpaid", "paid"] as const).map((t) => (
            <button
              key={t}
              onClick={() => setTab(t)}
              className={`flex-1 py-2.5 rounded-xl text-sm font-semibold transition-all ${
                tab === t ? "bg-white text-blue-600 shadow-sm" : "text-slate-500"
              }`}
            >
              {t === "unpaid" ? "Chưa thanh toán" : "Đã thanh toán"}
            </button>
          ))}
        </div>
      </div>

      <div className="flex-1 px-4 pt-4 pb-6 space-y-4">
        {currentBills.length === 0 && (
          <div className="text-center py-10 text-slate-500 text-sm">
            Không có hóa đơn nào.
          </div>
        )}
        {currentBills.map((bill: any) => (
          <div key={bill.id} className="bg-white rounded-2xl overflow-hidden shadow-sm">
            {/* Bill Header */}
            <div className={`px-4 py-3 flex items-center justify-between ${
              bill.status === "overdue" ? "bg-red-50" : (bill.status === "paid" ? "bg-green-50" : "bg-orange-50")
            }`}>
              <div>
                <p className="font-semibold text-slate-800">{bill.month}</p>
                <p className="text-xs text-slate-500 mt-0.5">
                  {bill.status === "overdue" || bill.status === "unpaid"
                    ? `Hạn thanh toán: ${bill.dueDate}`
                    : `Đã thanh toán: ${bill.paidDate}`}
                </p>
              </div>
              <span
                className={`flex items-center gap-1 text-xs px-2.5 py-1 rounded-full font-semibold ${
                  bill.status === "overdue"
                    ? "bg-red-100 text-red-700"
                    : bill.status === "paid"
                    ? "bg-green-100 text-green-700"
                    : "bg-orange-100 text-orange-700"
                }`}
              >
                {bill.status === "overdue" && <AlertTriangle size={11} />}
                {bill.status === "paid" && <CheckCheck size={11} />}
                {bill.status === "overdue" ? "Quá hạn" : (bill.status === "paid" ? "Đã thanh toán" : "Chờ thanh toán")}
              </span>
            </div>

            {/* Breakdown */}
            {bill.breakdown.length > 0 && (
              <div className="px-4 py-3 space-y-2.5">
                {bill.breakdown.map((item: any, i: number) => (
                  <div key={i}>
                    <div className="flex justify-between text-sm">
                      <span className="text-slate-600">{item.label}</span>
                      <span className="text-slate-800 font-medium">{item.amount}đ</span>
                    </div>
                    {i < bill.breakdown.length - 1 && (
                      <div className="border-t border-dashed border-slate-200 mt-2.5" />
                    )}
                  </div>
                ))}
                <div className="border-t-2 border-dashed border-slate-300 pt-2.5">
                  <div className="flex justify-between">
                    <span className="font-bold text-slate-900">Tổng cộng</span>
                    <span className="font-bold text-blue-700" style={{ fontSize: "1.05rem" }}>{bill.total}đ</span>
                  </div>
                </div>
              </div>
            )}

            {/* QR Section for unpaid */}
            {(bill.status === "overdue" || bill.status === "unpaid") && (
              <div className="px-4 pb-5 pt-2 border-t border-dashed border-slate-200">
                <p className="text-center text-sm text-slate-600 mb-4">
                  Quét mã để thanh toán qua ứng dụng ngân hàng
                </p>
                <QRPlaceholder />
                <p className="text-center text-xs text-slate-500 mt-3">
                  Vietcombank · 1234567890 · NGUYEN VAN AN
                </p>
                <div className="flex gap-2 mt-4">
                  <button
                    onClick={handleCopy}
                    className="flex-1 flex items-center justify-center gap-2 border border-blue-200 text-blue-700 py-3 rounded-xl text-sm font-medium active:scale-95 transition-transform"
                  >
                    {copied ? <CheckCheck size={16} /> : <Copy size={16} />}
                    {copied ? "Đã sao chép" : "Sao chép STK"}
                  </button>
                  <button className="flex-1 flex items-center justify-center gap-2 bg-blue-600 text-white py-3 rounded-xl text-sm font-medium shadow-sm active:scale-95 transition-transform">
                    <Download size={16} />
                    Tải PDF
                  </button>
                </div>
              </div>
            )}
          </div>
        ))}

        {/* Payment history note */}
        {tab === "paid" && currentBills.length > 0 && (
          <div className="flex items-center gap-2 bg-blue-50 rounded-xl px-4 py-3">
            <Clock size={16} className="text-blue-500 shrink-0" />
            <p className="text-sm text-blue-700">Lịch sử thanh toán được lưu trong 12 tháng</p>
          </div>
        )}
      </div>
    </div>
  );
}
