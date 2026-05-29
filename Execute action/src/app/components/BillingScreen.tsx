import { useState } from "react";
import { Download, Copy, CheckCheck, AlertTriangle, Clock } from "lucide-react";

const bills = {
  unpaid: [
    {
      id: 1,
      month: "Tháng 5/2026",
      total: "7.200.000",
      status: "overdue",
      dueDate: "15/05/2026",
      breakdown: [
        { label: "Tiền phòng", amount: "5.500.000" },
        { label: "Điện (120 kWh × 3.500đ)", amount: "420.000" },
        { label: "Nước (8m³ × 15.000đ)", amount: "120.000" },
        { label: "Dịch vụ chung cư", amount: "200.000" },
        { label: "Internet", amount: "100.000" },
        { label: "Phí quản lý", amount: "860.000" },
      ],
    },
  ],
  paid: [
    {
      id: 2,
      month: "Tháng 4/2026",
      total: "6.900.000",
      status: "paid",
      paidDate: "12/04/2026",
      breakdown: [
        { label: "Tiền phòng", amount: "5.500.000" },
        { label: "Điện (100 kWh × 3.500đ)", amount: "350.000" },
        { label: "Nước (7m³ × 15.000đ)", amount: "105.000" },
        { label: "Dịch vụ chung cư", amount: "200.000" },
        { label: "Internet", amount: "100.000" },
        { label: "Phí quản lý", amount: "645.000" },
      ],
    },
    {
      id: 3,
      month: "Tháng 3/2026",
      total: "6.750.000",
      status: "paid",
      paidDate: "10/03/2026",
      breakdown: [],
    },
  ],
};

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
      {/* VietQR logo area */}
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
        {currentBills.map((bill) => (
          <div key={bill.id} className="bg-white rounded-2xl overflow-hidden shadow-sm">
            {/* Bill Header */}
            <div className={`px-4 py-3 flex items-center justify-between ${
              bill.status === "overdue" ? "bg-red-50" : "bg-green-50"
            }`}>
              <div>
                <p className="font-semibold text-slate-800">{bill.month}</p>
                <p className="text-xs text-slate-500 mt-0.5">
                  {bill.status === "overdue"
                    ? `Hạn thanh toán: ${(bill as typeof bills.unpaid[0]).dueDate}`
                    : `Đã thanh toán: ${(bill as typeof bills.paid[0]).paidDate}`}
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
                {bill.status === "overdue" ? "Quá hạn" : "Đã thanh toán"}
              </span>
            </div>

            {/* Breakdown */}
            {bill.breakdown.length > 0 && (
              <div className="px-4 py-3 space-y-2.5">
                {bill.breakdown.map((item, i) => (
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
            {bill.status === "overdue" && (
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
        {tab === "paid" && (
          <div className="flex items-center gap-2 bg-blue-50 rounded-xl px-4 py-3">
            <Clock size={16} className="text-blue-500 shrink-0" />
            <p className="text-sm text-blue-700">Lịch sử thanh toán được lưu trong 12 tháng</p>
          </div>
        )}
      </div>
    </div>
  );
}
