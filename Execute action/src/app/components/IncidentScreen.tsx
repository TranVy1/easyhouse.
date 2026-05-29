import { useState } from "react";
import { Camera, X, CheckCircle2, Clock, AlertCircle, Plus } from "lucide-react";

const tickets = [
  {
    id: 1,
    title: "Máy lạnh phòng 302 bị hỏng",
    date: "22/05/2026",
    status: "in_progress",
    desc: "Máy lạnh không lạnh, chạy nhưng không ra hơi lạnh từ 3 ngày nay.",
  },
  {
    id: 2,
    title: "Rò rỉ nước toilet",
    date: "10/05/2026",
    status: "resolved",
    desc: "Toilet bị rò rỉ nước ở đáy bồn, ướt sàn nhà tắm.",
  },
  {
    id: 3,
    title: "Bóng đèn hành lang bị cháy",
    date: "28/04/2026",
    status: "resolved",
    desc: "Bóng đèn ở hành lang tầng 3 bị cháy, tối không nhìn thấy.",
  },
];

const statusMeta: Record<string, { label: string; color: string; icon: React.ReactNode }> = {
  open: {
    label: "Đang mở",
    color: "bg-orange-100 text-orange-700",
    icon: <AlertCircle size={12} />,
  },
  in_progress: {
    label: "Đang xử lý",
    color: "bg-blue-100 text-blue-700",
    icon: <Clock size={12} />,
  },
  resolved: {
    label: "Đã giải quyết",
    color: "bg-green-100 text-green-700",
    icon: <CheckCircle2 size={12} />,
  },
};

export function IncidentScreen() {
  const [activeTab, setActiveTab] = useState<"list" | "new">("list");
  const [filterStatus, setFilterStatus] = useState("all");
  const [images, setImages] = useState<string[]>([]);
  const [title, setTitle] = useState("");
  const [desc, setDesc] = useState("");
  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = () => {
    if (!title.trim()) return;
    setSubmitted(true);
    setTimeout(() => {
      setSubmitted(false);
      setTitle("");
      setDesc("");
      setImages([]);
      setActiveTab("list");
    }, 2000);
  };

  const filteredTickets = filterStatus === "all"
    ? tickets
    : tickets.filter((t) => t.status === filterStatus);

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC] overflow-y-auto">
      {/* Header */}
      <div className="bg-white px-4 pt-12 pb-4 shadow-sm">
        <h1 className="text-slate-900 mb-4" style={{ fontSize: "1.25rem", fontWeight: 700 }}>
          Báo Cáo Sự Cố
        </h1>
        <div className="flex bg-[#F1F5F9] rounded-2xl p-1">
          <button
            onClick={() => setActiveTab("list")}
            className={`flex-1 py-2.5 rounded-xl text-sm font-semibold transition-all ${
              activeTab === "list" ? "bg-white text-blue-600 shadow-sm" : "text-slate-500"
            }`}
          >
            Yêu cầu của tôi
          </button>
          <button
            onClick={() => setActiveTab("new")}
            className={`flex-1 py-2.5 rounded-xl text-sm font-semibold transition-all flex items-center justify-center gap-1 ${
              activeTab === "new" ? "bg-white text-blue-600 shadow-sm" : "text-slate-500"
            }`}
          >
            <Plus size={14} />
            Tạo mới
          </button>
        </div>
      </div>

      {activeTab === "list" ? (
        <div className="flex-1 px-4 pt-4 pb-6 space-y-4">
          {/* Filter chips */}
          <div className="flex gap-2 overflow-x-auto pb-1 scrollbar-none">
            {[
              { key: "all", label: "Tất cả" },
              { key: "open", label: "Đang mở" },
              { key: "in_progress", label: "Đang xử lý" },
              { key: "resolved", label: "Đã giải quyết" },
            ].map((f) => (
              <button
                key={f.key}
                onClick={() => setFilterStatus(f.key)}
                className={`shrink-0 px-3 py-1.5 rounded-full text-xs font-medium transition-all ${
                  filterStatus === f.key
                    ? "bg-blue-600 text-white"
                    : "bg-white text-slate-600 border border-slate-200"
                }`}
              >
                {f.label}
              </button>
            ))}
          </div>

          {filteredTickets.map((ticket) => {
            const meta = statusMeta[ticket.status];
            return (
              <div key={ticket.id} className="bg-white rounded-2xl p-4 shadow-sm">
                <div className="flex items-start justify-between gap-2">
                  <h3 className="text-slate-900 font-semibold text-sm leading-snug flex-1">
                    {ticket.title}
                  </h3>
                  <span className={`flex items-center gap-1 shrink-0 text-xs px-2 py-1 rounded-full font-semibold ${meta.color}`}>
                    {meta.icon}
                    {meta.label}
                  </span>
                </div>
                <p className="text-xs text-slate-500 mt-1">{ticket.date}</p>
                <p className="text-sm text-slate-600 mt-2 leading-relaxed">{ticket.desc}</p>
              </div>
            );
          })}

          {filteredTickets.length === 0 && (
            <div className="text-center py-12">
              <AlertCircle size={40} className="text-slate-300 mx-auto mb-3" />
              <p className="text-slate-500 text-sm">Không có yêu cầu nào</p>
            </div>
          )}
        </div>
      ) : (
        <div className="flex-1 px-4 pt-5 pb-28 space-y-4">
          {/* Form */}
          <div className="bg-white rounded-2xl p-4 shadow-sm space-y-4">
            <div>
              <label className="block text-sm font-semibold text-slate-700 mb-1.5">
                Tiêu đề sự cố <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                placeholder="VD: Máy lạnh bị hỏng, Rò rỉ nước..."
                className="w-full bg-[#F8FAFC] border border-slate-200 rounded-xl px-4 py-3 text-sm text-slate-800 outline-none focus:border-blue-400 focus:ring-2 focus:ring-blue-100 transition-all placeholder:text-slate-400"
              />
            </div>
            <div>
              <label className="block text-sm font-semibold text-slate-700 mb-1.5">
                Mô tả chi tiết
              </label>
              <textarea
                value={desc}
                onChange={(e) => setDesc(e.target.value)}
                placeholder="Mô tả vấn đề để chủ nhà có thể hiểu và hỗ trợ nhanh hơn..."
                rows={4}
                className="w-full bg-[#F8FAFC] border border-slate-200 rounded-xl px-4 py-3 text-sm text-slate-800 outline-none focus:border-blue-400 focus:ring-2 focus:ring-blue-100 transition-all placeholder:text-slate-400 resize-none"
              />
            </div>
          </div>

          {/* Image Upload */}
          <div className="bg-white rounded-2xl p-4 shadow-sm">
            <label className="block text-sm font-semibold text-slate-700 mb-3">
              Ảnh đính kèm
            </label>
            <button
              onClick={() => {
                // Simulate adding a placeholder image
                const demoImages = [
                  "https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=200&h=200&fit=crop&auto=format",
                  "https://images.unsplash.com/photo-1578321272176-b7bbc0679853?w=200&h=200&fit=crop&auto=format",
                ];
                if (images.length < 4) {
                  setImages((prev) => [...prev, demoImages[prev.length % demoImages.length]]);
                }
              }}
              className="w-full border-2 border-dashed border-blue-200 rounded-2xl py-8 flex flex-col items-center gap-2 text-blue-500 active:bg-blue-50 transition-colors"
            >
              <Camera size={32} />
              <span className="text-sm font-medium">Chụp ảnh hoặc chọn từ thư viện</span>
              <span className="text-xs text-slate-400">Tối đa 4 ảnh</span>
            </button>

            {images.length > 0 && (
              <div className="flex gap-2 mt-3 overflow-x-auto pb-1 scrollbar-none">
                {images.map((img, i) => (
                  <div key={i} className="relative shrink-0">
                    <img
                      src={img}
                      alt={`Ảnh ${i + 1}`}
                      className="w-20 h-20 rounded-xl object-cover"
                    />
                    <button
                      onClick={() => setImages((prev) => prev.filter((_, idx) => idx !== i))}
                      className="absolute -top-1.5 -right-1.5 w-5 h-5 bg-slate-800 rounded-full flex items-center justify-center"
                    >
                      <X size={11} className="text-white" />
                    </button>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      )}

      {/* Sticky Submit Button */}
      {activeTab === "new" && (
        <div className="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-sm bg-white border-t border-slate-100 px-4 py-4 pb-8">
          <button
            onClick={handleSubmit}
            disabled={!title.trim() || submitted}
            className={`w-full py-4 rounded-2xl font-semibold text-white transition-all ${
              submitted
                ? "bg-green-500"
                : title.trim()
                ? "bg-blue-600 shadow-md active:scale-95"
                : "bg-slate-300"
            }`}
          >
            {submitted ? (
              <span className="flex items-center justify-center gap-2">
                <CheckCircle2 size={18} /> Đã gửi thành công!
              </span>
            ) : (
              "Gửi báo cáo"
            )}
          </button>
        </div>
      )}
    </div>
  );
}
