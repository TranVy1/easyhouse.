"use client";

import { useState, useEffect } from "react";
import { SessionProvider } from "next-auth/react";
import { Home, Heart, Receipt, User, Bot, Star, Play, Camera, Trash2, MapPin, ArrowLeft } from "lucide-react";
import { HomeScreen } from "@/components/mobile-app/HomeScreen";
import { RoomDetailScreen } from "@/components/mobile-app/RoomDetailScreen";
import { BillingScreen } from "@/components/mobile-app/BillingScreen";
import { IncidentScreen } from "@/components/mobile-app/IncidentScreen";
import { ProfileScreen } from "@/components/mobile-app/ProfileScreen";
import { ChatOverlay } from "@/components/mobile-app/ChatOverlay";

type Tab = "home" | "saved" | "bills" | "profile";

const navItems: { tab: Tab; icon: React.ReactNode; label: string }[] = [
  { tab: "home", icon: <Home size={22} />, label: "Trang chủ" },
  { tab: "saved", icon: <Heart size={22} />, label: "Đã lưu" },
  { tab: "bills", icon: <Receipt size={22} />, label: "Hóa đơn" },
  { tab: "profile", icon: <User size={22} />, label: "Hồ sơ" },
];

export default function App() {
  return (
    <SessionProvider>
      <MainApp />
    </SessionProvider>
  );
}

function MainApp() {
  const [activeTab, setActiveTab] = useState<Tab>("home");
  const [viewingRoom, setViewingRoom] = useState<number | null>(null);
  const [chatOpen, setChatOpen] = useState(false);

  useEffect(() => {
    if (typeof window !== "undefined") {
      const params = new URLSearchParams(window.location.search);
      const tabParam = params.get("tab");
      if (tabParam === "profile" || tabParam === "home" || tabParam === "saved" || tabParam === "bills") {
        setActiveTab(tabParam as Tab);
      }
    }
  }, []);

  const handleRoomSelect = (id: number) => {
    setViewingRoom(id);
  };

  const handleBack = () => {
    setViewingRoom(null);
  };

  const renderContent = () => {
    if (viewingRoom !== null) {
      return <RoomDetailScreen onBack={handleBack} roomId={viewingRoom} />;
    }
    switch (activeTab) {
      case "home":
        return <HomeScreen onRoomSelect={handleRoomSelect} onTabChange={setActiveTab} />;
      case "saved":
        return <SavedScreen onRoomSelect={handleRoomSelect} onTabChange={setActiveTab} />;
      case "bills":
        return <BillingScreen />;
      case "profile":
        return <ProfileScreen onOpenChat={() => setChatOpen(true)} />;
    }
  };

  return (
    <div className="flex h-screen bg-[#F8FAFC] font-sans">
      {/* Main Content Area */}
      <div className="flex-1 flex flex-col h-screen relative overflow-hidden">
        {/* Main scrollable view */}
        <div className="flex-1 overflow-y-auto relative">
          <div className="w-full h-full">
            {renderContent()}
          </div>
        </div>

        {/* Bottom Nav - Mobile Only */}
        {viewingRoom === null && (
          <div className="md:hidden shrink-0 bg-white border-t border-slate-100 px-2 pt-2 pb-6 safe-area-bottom z-40 relative">
            <div className="flex">
              {navItems.map(({ tab, icon, label }) => (
                <button
                  key={tab}
                  onClick={() => setActiveTab(tab)}
                  className={`flex-1 flex flex-col items-center gap-1 py-1 transition-all ${
                    activeTab === tab ? "text-blue-600" : "text-slate-400"
                  }`}
                >
                  <div className={`relative transition-transform ${activeTab === tab ? "scale-110" : ""}`}>
                    {icon}
                    {tab === "bills" && (
                      <span className="absolute -top-1 -right-1 w-2 h-2 bg-red-500 rounded-full" />
                    )}
                  </div>
                  <span className="text-xs">{label}</span>
                  {activeTab === tab && (
                    <span className="w-1 h-1 bg-blue-600 rounded-full" />
                  )}
                </button>
              ))}
            </div>
          </div>
        )}

        {/* Floating AI Chat Button (Mobile Only) */}
        {!chatOpen && viewingRoom === null && (
          <button
            onClick={() => setChatOpen(true)}
            className="md:hidden absolute bottom-24 right-4 w-14 h-14 bg-blue-600 rounded-full flex items-center justify-center shadow-lg active:scale-95 transition-transform z-30"
          >
            <Bot size={24} className="text-white" />
          </button>
        )}

        {/* Chat Overlay */}
        {chatOpen && <ChatOverlay onClose={() => setChatOpen(false)} />}
      </div>
    </div>
  );
}

// Premium Saved screen component
interface SavedScreenProps {
  onRoomSelect: (id: number) => void;
  onTabChange?: (tab: Tab) => void;
}

function SavedScreen({ onRoomSelect, onTabChange }: SavedScreenProps) {
  const [savedRooms, setSavedRooms] = useState<any[]>([]);

  useEffect(() => {
    const saved = localStorage.getItem("easyhouse_saved_rooms");
    if (saved) {
      try {
        setSavedRooms(JSON.parse(saved));
      } catch (e) {
        console.error(e);
      }
    }
  }, []);

  const handleUnsave = (id: number, e: React.MouseEvent) => {
    e.stopPropagation();
    const updated = savedRooms.filter((r) => r.id !== id);
    setSavedRooms(updated);
    localStorage.setItem("easyhouse_saved_rooms", JSON.stringify(updated));
  };

  const getRoomImagesLocal = (room: any) => {
    const defaults = [
      "https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=500&fit=crop",
      "https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=300&fit=crop",
      "https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=300&fit=crop",
      "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=300&fit=crop"
    ];

    const roomImages = room.hinhAnh && room.hinhAnh.length > 0
      ? room.hinhAnh.map((img: any) => typeof img === 'string' ? img : img.url || img.hinhAnh || defaults[0])
      : [room.image || defaults[0]];

    const finalImages = [...roomImages];
    while (finalImages.length < 4) {
      finalImages.push(defaults[finalImages.length % defaults.length]);
    }
    return finalImages;
  };

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC] overflow-y-auto">
      {/* Header */}
      <div className="bg-white px-4 md:px-8 xl:px-12 pt-12 pb-5 shadow-sm border-b border-slate-100 flex items-center justify-between shrink-0">
        <div className="flex items-center gap-3">
          <button 
            onClick={() => onTabChange?.("home")}
            className="w-10 h-10 rounded-full bg-slate-50 hover:bg-slate-100 flex items-center justify-center transition-colors text-slate-600"
            title="Quay lại trang chủ"
          >
            <ArrowLeft size={18} />
          </button>
          <div>
            <h1 className="text-slate-900 font-extrabold tracking-tight" style={{ fontSize: "1.5rem" }}>
              Tin Đã Lưu
            </h1>
            <p className="text-xs text-slate-500 font-medium">Danh sách các phòng trọ bạn đã đánh dấu quan tâm</p>
          </div>
        </div>
        <span className="text-xs font-semibold text-slate-500 bg-slate-100 px-3.5 py-2 rounded-full shadow-sm border border-slate-200/50">
          {savedRooms.length} phòng đã lưu
        </span>
      </div>

      {/* Content */}
      <div className="flex-1 px-4 md:px-8 xl:px-12 pt-6 pb-12">
        {savedRooms.length === 0 ? (
          <div className="text-center py-20 bg-white rounded-3xl shadow-sm border border-slate-100 flex flex-col items-center justify-center max-w-xl mx-auto mt-10 p-8">
            <div className="w-16 h-16 rounded-full bg-red-50 flex items-center justify-center mb-4 text-red-500 shadow-inner">
              <Heart size={28} className="fill-red-100" />
            </div>
            <h3 className="text-lg font-bold text-slate-800">Chưa có phòng đã lưu</h3>
            <p className="text-slate-500 text-sm mt-2 max-w-sm leading-relaxed">
              Bạn chưa bấm lưu phòng trọ nào. Hãy khám phá và lưu lại những căn phòng bạn ưng ý nhất để dễ dàng theo dõi nhé!
            </p>
            <button 
              onClick={() => onTabChange?.("home")}
              className="mt-6 px-6 py-3 bg-blue-600 text-white font-bold rounded-xl shadow-lg shadow-blue-100 hover:bg-blue-700 active:scale-95 transition-all text-sm"
            >
              Khám Phá Phòng Trọ Ngay
            </button>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8 max-w-7xl mx-auto">
            {savedRooms.map((room) => {
              const imgs = getRoomImagesLocal(room);
              return (
                <div
                  key={room.id}
                  onClick={() => onRoomSelect(room.id)}
                  className="bg-white rounded-2xl overflow-hidden shadow-sm hover:shadow-lg hover:-translate-y-1 transition-all border border-slate-100 flex flex-col cursor-pointer active:scale-[0.99]"
                >
                  {/* Collage Images */}
                  <div className="grid grid-cols-5 gap-0.5 h-48 sm:h-56 w-full relative overflow-hidden shrink-0">
                    {/* Left large image */}
                    <div className="col-span-3 relative h-full">
                      <img src={imgs[0]} alt={room.name} className="w-full h-full object-cover" />
                      {/* Play button overlay */}
                      <div className="absolute inset-0 flex items-center justify-center">
                        <div className="w-12 h-12 rounded-full bg-black/40 backdrop-blur-sm flex items-center justify-center border border-white/20">
                          <Play size={20} className="fill-white text-white translate-x-0.5" />
                        </div>
                      </div>
                      {/* Camera count overlay */}
                      <span className="absolute bottom-3 left-3 bg-black/60 backdrop-blur-sm text-white text-[10px] sm:text-xs px-2.5 py-1 rounded-md flex items-center gap-1 font-bold shadow-sm">
                        <Camera size={12} className="text-white" /> 7
                      </span>
                    </div>
                    {/* Right column */}
                    <div className="col-span-2 grid grid-rows-2 gap-0.5 h-full">
                      {/* Right Top image */}
                      <img src={imgs[1]} alt={room.name} className="w-full h-full object-cover" />
                      {/* Right Bottom row split */}
                      <div className="grid grid-cols-2 gap-0.5 h-full">
                        <img src={imgs[2]} alt={room.name} className="w-full h-full object-cover" />
                        <img src={imgs[3]} alt={room.name} className="w-full h-full object-cover" />
                      </div>
                    </div>
                    {/* Save heart button overlay (click to unsave) */}
                    <div className="absolute top-3 right-3 z-10">
                      <button
                        onClick={(e) => handleUnsave(room.id, e)}
                        className="w-9 h-9 rounded-full bg-white/90 backdrop-blur flex items-center justify-center shadow-md hover:bg-white hover:scale-110 active:scale-95 transition-all"
                        title="Bỏ lưu phòng này"
                      >
                        <Heart
                          size={16}
                          className="fill-red-500 text-red-500"
                        />
                      </button>
                    </div>
                  </div>

                  {/* Card Info */}
                  <div className="p-4 flex flex-col flex-1 bg-white">
                    <div className="flex items-center gap-1.5 flex-wrap">
                      <div className="flex items-center gap-0.5 shrink-0">
                        {[...Array(5)].map((_, i) => (
                          <Star key={i} size={14} className="fill-amber-400 text-amber-400" />
                        ))}
                      </div>
                      <h3 className="text-[#FF385C] font-extrabold uppercase text-xs sm:text-sm tracking-wide truncate flex-1">
                        {room.name.includes("Phòng") || room.name.includes("Căn hộ") ? room.name : `CHO THUÊ PHÒNG TRỌ ${room.name}`} - DỌN VÀO Ở NGAY
                      </h3>
                    </div>

                    <div className="flex items-center gap-2 text-slate-500 text-xs sm:text-sm mt-2 flex-wrap font-semibold">
                      <span className="text-[#0F9675] font-bold text-sm sm:text-base">{room.price}</span>
                      <span className="text-slate-300 font-normal">•</span>
                      <span className="text-slate-700">{room.area || "38m²"}</span>
                      <span className="text-slate-300 font-normal">•</span>
                      <span className="text-slate-600 truncate max-w-[200px]">{room.location.replace("Chưa cập nhật địa chỉ", "Bình Thạnh, Hồ Chí Minh")}</span>
                    </div>

                    <p className="text-xs text-slate-500 line-clamp-2 mt-2.5 leading-relaxed font-normal">
                      {room.description}
                    </p>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
