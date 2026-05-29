'use client';
import { useState, useEffect } from "react";
import { Settings, Bot, LogOut, ChevronRight, FileText, AlertTriangle, ExternalLink } from "lucide-react";

const menuItems = [
  { icon: <Settings size={20} className="text-slate-500" />, label: "Cài đặt", color: "text-slate-800" },
  { icon: <Bot size={20} className="text-blue-500" />, label: "AI Chat Trợ Lý", color: "text-slate-800", badge: "Mới" },
  { icon: <LogOut size={20} className="text-red-400" />, label: "Đăng xuất", color: "text-red-500" },
];

export function ProfileScreen({ onOpenChat }: { onOpenChat: () => void }) {
  const [userProfile, setUserProfile] = useState<any>(null);

  useEffect(() => {
    fetch('/api/user/profile')
      .then(res => res.json())
      .then(data => {
        if (data.data) {
          setUserProfile(data.data);
        } else {
          // Fallback if not authenticated
          setUserProfile({
             hoTen: "Khách thuê",
             sdt: "Vui lòng đăng nhập",
             phong: "Chưa xác định"
          });
        }
      })
      .catch(err => {
         setUserProfile({
             hoTen: "Khách thuê",
             sdt: "Vui lòng đăng nhập",
             phong: "Chưa xác định"
         });
      });
  }, []);

  if (!userProfile) {
    return <div className="flex h-full items-center justify-center">Đang tải...</div>;
  }

  const totalDays = 365;
  const passedDays = 148;
  const progress = (passedDays / totalDays) * 100;
  const daysLeft = totalDays - passedDays;
  const isExpiringSoon = daysLeft < 60;

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC] overflow-y-auto">
      {/* Header */}
      <div className="bg-blue-600 px-4 pt-14 pb-20 relative overflow-hidden">
        <div className="absolute inset-0 opacity-10">
          <div className="absolute top-0 right-0 w-40 h-40 bg-white rounded-full -translate-y-1/2 translate-x-1/4" />
          <div className="absolute bottom-0 left-0 w-32 h-32 bg-white rounded-full translate-y-1/2 -translate-x-1/4" />
        </div>
        <div className="relative flex items-center gap-4">
          <div className="relative">
            <img
              src={userProfile.avatar || "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=120&h=120&fit=crop&auto=format"}
              alt="Avatar"
              className="w-20 h-20 rounded-full border-4 border-white object-cover shadow-md"
            />
            <span className="absolute bottom-0 right-0 w-5 h-5 bg-green-400 rounded-full border-2 border-white" />
          </div>
          <div>
            <h1 className="text-white font-bold" style={{ fontSize: "1.2rem" }}>{userProfile.hoTen}</h1>
            <p className="text-blue-200 text-sm">Phòng {userProfile.phong}</p>
            <p className="text-blue-200 text-sm">{userProfile.sdt || userProfile.dienThoai}</p>
          </div>
        </div>
        <button className="relative mt-4 border border-white/40 text-white text-sm px-4 py-1.5 rounded-full active:bg-white/10 transition-colors">
          Chỉnh sửa hồ sơ
        </button>
      </div>

      {/* Contract Card */}
      <div className="mx-4 -mt-8 bg-white rounded-2xl shadow-md p-4 relative z-10">
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 bg-blue-50 rounded-lg flex items-center justify-center">
              <FileText size={16} className="text-blue-600" />
            </div>
            <div>
              <p className="font-semibold text-slate-900 text-sm">Hợp đồng thuê nhà</p>
              <p className="text-xs text-slate-500">Đang hiệu lực</p>
            </div>
          </div>
          <span className="text-xs bg-green-100 text-green-700 px-2 py-1 rounded-full font-semibold">Hiệu lực</span>
        </div>

        <div className="grid grid-cols-2 gap-3 mb-4">
          <div className="bg-[#F8FAFC] rounded-xl p-3">
            <p className="text-xs text-slate-500">Ngày bắt đầu</p>
            <p className="font-semibold text-slate-800 text-sm mt-0.5">01/01/2026</p>
          </div>
          <div className="bg-[#F8FAFC] rounded-xl p-3">
            <p className="text-xs text-slate-500">Ngày kết thúc</p>
            <p className="font-semibold text-slate-800 text-sm mt-0.5">31/12/2026</p>
          </div>
          <div className="bg-[#F8FAFC] rounded-xl p-3 col-span-2">
            <p className="text-xs text-slate-500">Tiền đặt cọc</p>
            <p className="font-semibold text-slate-800 text-sm mt-0.5">11.000.000đ (2 tháng)</p>
          </div>
        </div>

        {/* Progress bar */}
        <div className="mb-3">
          <div className="flex justify-between text-xs text-slate-500 mb-1.5">
            <span>Thời gian hợp đồng</span>
            <span className="font-medium text-slate-700">{daysLeft} ngày còn lại</span>
          </div>
          <div className="h-2 bg-slate-100 rounded-full overflow-hidden">
            <div
              className="h-full bg-blue-600 rounded-full transition-all"
              style={{ width: `${progress}%` }}
            />
          </div>
        </div>

        {/* Expiry warning */}
        {isExpiringSoon && (
          <div className="bg-amber-50 border border-amber-200 rounded-xl p-3 flex items-center gap-3 mb-3">
            <AlertTriangle size={16} className="text-amber-500 shrink-0" />
            <p className="text-xs text-amber-700 flex-1">Hợp đồng sắp hết hạn! Vui lòng liên hệ chủ nhà để gia hạn.</p>
            <button className="text-xs text-amber-700 font-semibold border border-amber-300 px-2 py-1 rounded-lg shrink-0">
              Gia hạn
            </button>
          </div>
        )}

        <button className="w-full flex items-center justify-center gap-2 border border-blue-200 text-blue-700 py-3 rounded-xl text-sm font-medium active:bg-blue-50 transition-colors">
          <ExternalLink size={15} />
          Xem hợp đồng điện tử (PDF)
        </button>
      </div>

      {/* Menu */}
      <div className="mx-4 mt-4 bg-white rounded-2xl shadow-sm overflow-hidden">
        {menuItems.map((item, i) => (
          <button
            key={i}
            onClick={item.label === "AI Chat Trợ Lý" ? onOpenChat : undefined}
            className={`w-full flex items-center justify-between px-4 py-4 active:bg-slate-50 transition-colors ${
              i < menuItems.length - 1 ? "border-b border-slate-100" : ""
            }`}
          >
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 bg-slate-50 rounded-xl flex items-center justify-center">
                {item.icon}
              </div>
              <span className={`text-sm font-medium ${item.color}`}>{item.label}</span>
              {item.badge && (
                <span className="text-xs bg-blue-600 text-white px-1.5 py-0.5 rounded-full">
                  {item.badge}
                </span>
              )}
            </div>
            <ChevronRight size={16} className="text-slate-400" />
          </button>
        ))}
      </div>

      <p className="text-center text-xs text-slate-400 mt-6 mb-8">
        EasyHouse v2.1.0 · Lấy dữ liệu API thành công
      </p>
    </div>
  );
}
