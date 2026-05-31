'use client';
import { useState, useEffect } from "react";
import { Camera, X, CheckCircle2, Clock, AlertCircle, Plus, RefreshCw } from "lucide-react";
import { api, extractItems, ApiError } from "@/lib/api";

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
  const [tickets, setTickets] = useState<any[]>([]);

  const [loading, setLoading] = useState(true);
  const [fetchError, setFetchError] = useState<string | null>(null);

  const fetchIncidents = async () => {
    setLoading(true);
    setFetchError(null);
    try {
      const data = await api.get<any>('/api/tenant/su-co?limit=20');
      const items = extractItems<any>(data);
      setTickets(items.map((t: any) => ({
        id: t._id || t.id,
        title: t.tieuDe || 'Sự cố không rõ',
        date: t.ngayBaoCao ? new Date(t.ngayBaoCao).toLocaleDateString('vi-VN') : new Date().toLocaleDateString('vi-VN'),
        status: t.trangThai === 'RESOLVED' ? 'resolved' : (t.trangThai === 'IN_PROGRESS' ? 'in_progress' : 'open'),
        desc: t.moTa || '',
        priority: t.mucDoUuTien || '',
      })));
    } catch (e) {
      setFetchError(e instanceof ApiError ? e.message : 'Không thể tải dữ liệu sự cố');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchIncidents(); }, []);

  const handleSubmit = async () => {
    if (!title.trim()) return;
    setSubmitted(true);
    try {
      await api.post('/api/tenant/su-co', { tieuDe: title, moTa: desc });
      setTimeout(() => {
        setSubmitted(false);
        setTitle('');
        setDesc('');
        setImages([]);
        setActiveTab('list');
        fetchIncidents();
      }, 800);
    } catch {
      setSubmitted(false);
    }
  };

  const filteredTickets = filterStatus === "all"
    ? tickets
    : tickets.filter((t) => t.status === filterStatus);

  if (loading) {
    return (
      <div className="flex h-full items-center justify-center gap-2.5 text-slate-400">
        <RefreshCw size={18} className="animate-spin text-indigo-500" />
        <span className="text-sm font-medium">Đang tải sự cố...</span>
      </div>
    );
  }

  if (fetchError) {
    return (
      <div className="flex flex-col h-full items-center justify-center gap-4 px-8 text-center">
        <AlertCircle size={36} className="text-red-400" />
        <p className="text-sm text-slate-600 font-medium">{fetchError}</p>
        <button onClick={fetchIncidents}
          className="flex items-center gap-2 px-4 py-2 bg-indigo-600 text-white text-sm font-bold rounded-xl cursor-pointer">
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
          <h1 className="text-white font-black text-xl">Báo Cáo Sự Cố</h1>
          <p className="text-indigo-200 text-xs mt-1">Gửi yêu cầu bảo trì và theo dõi tiến độ xử lý</p>
        </div>
      </div>

      {/* Tabs */}
      <div className="px-4 -mt-3 relative z-10">
        <div className="flex bg-white rounded-2xl p-1 shadow-sm border border-slate-100">
          <button
            onClick={() => setActiveTab("list")}
            className={`flex-1 py-2.5 rounded-xl text-sm font-bold transition-all cursor-pointer ${
              activeTab === "list" ? "bg-indigo-600 text-white shadow-sm" : "text-slate-500 hover:text-slate-700"
            }`}
          >
            Yêu cầu của tôi
          </button>
          <button
            onClick={() => setActiveTab("new")}
            className={`flex-1 py-2.5 rounded-xl text-sm font-bold transition-all flex items-center justify-center gap-1 cursor-pointer ${
              activeTab === "new" ? "bg-indigo-600 text-white shadow-sm" : "text-slate-500 hover:text-slate-700"
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
            const meta = statusMeta[ticket.status] || statusMeta['open'];
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
        <div className="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-sm bg-white border-t border-slate-100 px-4 py-4 pb-8 z-10" style={{ transform: "translate(-50%, 0)", left: "auto", position: "absolute" }}>
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
