"use client";

import { useEffect, useState } from "react";
import type { ReactNode } from "react";
import { SessionProvider, useSession } from "next-auth/react";
import { ArrowLeft, Bot, Building2, Heart, Home, MapPin, Receipt, User } from "lucide-react";
import { HomeScreen } from "@/components/mobile-app/HomeScreen";
import { RoomDetailScreen } from "@/components/mobile-app/RoomDetailScreen";
import { BillingScreen } from "@/components/mobile-app/BillingScreen";
import { ProfileScreen } from "@/components/mobile-app/ProfileScreen";
import { ChatOverlay } from "@/components/mobile-app/ChatOverlay";

type Tab = "home" | "saved" | "bills" | "profile";
type RoomId = string | number;
type SavedRoom = Record<string, unknown> & {
  id: RoomId;
  images?: unknown[];
  hinhAnh?: unknown[];
  anhList?: unknown[];
  image?: string;
};

const navItems: { tab: Tab; icon: ReactNode; label: string }[] = [
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
  const [viewingRoom, setViewingRoom] = useState<RoomId | null>(null);
  const [chatOpen, setChatOpen] = useState(false);

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const tabParam = params.get("tab");
    if (tabParam === "profile" || tabParam === "home" || tabParam === "saved" || tabParam === "bills") {
      setActiveTab(tabParam as Tab);
    }
  }, []);

  const handleRoomSelect = (id: RoomId) => {
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
        return <ProfileScreen onOpenChat={() => setChatOpen(true)} onBack={() => setActiveTab("home")} />;
    }
  };

  return (
    <main className="min-h-screen overflow-x-hidden bg-[#F8F3EC]">
      <div className="mx-auto w-full max-w-[1440px] px-0 md:px-4 lg:px-8">
        <div className="w-full">{renderContent()}</div>

        {viewingRoom === null && (
          <div className="md:hidden fixed bottom-0 left-0 right-0 z-40 border-t border-[#E8DED1] bg-white px-2 pb-6 pt-2 safe-area-bottom shadow-[0_-4px_16px_rgba(0,0,0,0.05)]">
            <div className="flex">
              {navItems.map(({ tab, icon, label }) => (
                <button
                  key={tab}
                  onClick={() => setActiveTab(tab)}
                  className={`flex flex-1 flex-col items-center gap-1 py-1 transition-all ${
                    activeTab === tab ? "text-[#4FA7A0]" : "text-[#6B7A8C]"
                  }`}
                >
                  <div className={`relative transition-transform ${activeTab === tab ? "scale-110" : ""}`}>
                    {icon}
                    {tab === "bills" && <span className="absolute -right-1 -top-1 h-2 w-2 rounded-full bg-red-500" />}
                  </div>
                  <span className="text-xs">{label}</span>
                  {activeTab === tab && <span className="h-1 w-1 rounded-full bg-[#4FA7A0]" />}
                </button>
              ))}
            </div>
          </div>
        )}

        {!chatOpen && viewingRoom === null && (
          <button
            onClick={() => setChatOpen(true)}
            className="fixed bottom-24 right-4 z-50 flex h-14 w-14 items-center justify-center rounded-full bg-[#243B5A] shadow-lg transition-transform active:scale-95 md:hidden"
          >
            <Bot size={24} className="text-white" />
          </button>
        )}

        {chatOpen && <ChatOverlay onClose={() => setChatOpen(false)} />}
      </div>
    </main>
  );
}

interface SavedScreenProps {
  onRoomSelect: (id: RoomId) => void;
  onTabChange?: (tab: Tab) => void;
}

function SavedScreen({ onRoomSelect, onTabChange }: SavedScreenProps) {
  const [savedRooms, setSavedRooms] = useState<SavedRoom[]>([]);
  const { data: session } = useSession();
  const userId = session?.user?.id;

  const getStorageKey = (uid?: string) => {
    return uid ? `easyhouse_saved_rooms_${uid}` : "easyhouse_saved_rooms";
  };

  useEffect(() => {
    const key = getStorageKey(userId);
    const saved = localStorage.getItem(key);
    if (saved) {
      try {
        const parsed = JSON.parse(saved);
        setSavedRooms(Array.isArray(parsed) ? parsed : []);
      } catch (error) {
        console.error(error);
      }
    } else {
      setSavedRooms([]);
    }
  }, [userId]);

  const handleUnsave = (id: RoomId, event: React.MouseEvent) => {
    event.stopPropagation();
    const key = getStorageKey(userId);
    const updated = savedRooms.filter((room) => room.id !== id);
    setSavedRooms(updated);
    localStorage.setItem(key, JSON.stringify(updated));
  };

  const getRoomImagesLocal = (room: SavedRoom) => {
    const rawImages = room.images || room.hinhAnh || room.anhList || [];
    const imageList = Array.isArray(rawImages) ? rawImages : [];
    const normalized = imageList
      .map((image) => {
        if (typeof image === "string") return image;
        const imageRecord = typeof image === "object" && image !== null ? image as Record<string, unknown> : {};
        return typeof imageRecord.url === "string" ? imageRecord.url : typeof imageRecord.hinhAnh === "string" ? imageRecord.hinhAnh : "";
      })
      .filter(Boolean);

    if (room.image && !normalized.includes(room.image)) {
      return [room.image, ...normalized];
    }

    return normalized;
  };

  const getRoomField = (value: unknown, fallback = "Đang cập nhật") => {
    const text = String(value || "").trim();
    return text || fallback;
  };

  const SavedRoomImage = ({ src, alt }: { src?: string; alt: string }) => (
    <div className="relative h-full w-full bg-gradient-to-br from-[#F8F3EC] via-white to-[#DCEFEB]">
      {src ? (
        <img src={src} alt={alt} className="h-full w-full object-cover" />
      ) : (
        <div className="flex h-full w-full items-center justify-center">
          <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-white/85 text-[#243B5A] shadow-sm ring-1 ring-[#E8DED1]">
            <Building2 size={26} />
          </div>
        </div>
      )}
    </div>
  );

  return (
    <div className="flex h-full flex-col overflow-y-auto bg-[#F8F3EC]">
      <div className="shrink-0 border-b border-[#E8DED1] bg-white px-4 pb-6 pt-12 shadow-sm md:px-8 xl:px-12">
        <div className="mx-auto flex max-w-screen-xl items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <button
              onClick={() => onTabChange?.("home")}
              className="flex h-10 w-10 items-center justify-center rounded-full bg-[#F8F3EC] text-[#243B5A] transition-colors hover:bg-[#EDE5D9]"
              title="Quay lại trang chủ"
            >
              <ArrowLeft size={18} />
            </button>
            <div>
              <h1 className="text-2xl font-extrabold tracking-tight text-[#243B5A]">Tin đã lưu</h1>
              <p className="text-sm font-medium text-[#243B5A]/60">Danh sách phòng bạn đã đánh dấu quan tâm</p>
            </div>
          </div>

          <div className="flex items-center gap-3">
            <span className="inline-flex items-center gap-2 rounded-full border border-[#4FA7A0]/20 bg-[#4FA7A0]/10 px-3 py-2 text-sm font-semibold text-[#267D76]">
              <Heart size={16} /> {savedRooms.length} đã lưu
            </span>
            <button
              onClick={() => onTabChange?.("home")}
              className="hidden items-center gap-2 rounded-full bg-white px-4 py-2 text-sm font-bold text-[#243B5A] shadow-sm ring-1 ring-[#E8DED1] sm:inline-flex"
            >
              Khám phá
            </button>
          </div>
        </div>
      </div>

      <div className="flex-1 px-4 pb-12 pt-6 md:px-8 xl:px-12">
        {savedRooms.length === 0 ? (
          <div className="mx-auto mt-10 flex max-w-2xl flex-col items-center justify-center rounded-2xl border border-[#E8DED1] bg-white p-8 py-20 text-center shadow-sm">
            <div className="mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-[#F2A45B]/10 text-[#F2A45B] shadow-inner">
              <Heart size={28} />
            </div>
            <h3 className="text-lg font-bold text-[#243B5A]">Chưa có phòng đã lưu</h3>
            <p className="mt-2 max-w-sm text-sm leading-relaxed text-[#243B5A]/60">
              Hãy khám phá và lưu lại những phòng bạn quan tâm để dễ theo dõi trước khi liên hệ.
            </p>
            <button
              onClick={() => onTabChange?.("home")}
              className="mt-6 rounded-2xl bg-[#4FA7A0] px-6 py-3 text-sm font-bold text-white shadow-lg shadow-[#4FA7A0]/15 transition active:scale-95"
            >
              Khám phá phòng trọ ngay
            </button>
          </div>
        ) : (
          <div className="mx-auto grid max-w-screen-xl grid-cols-1 gap-6 sm:gap-8 md:grid-cols-2 lg:grid-cols-3">
            {savedRooms.map((room) => {
              const images = getRoomImagesLocal(room);
              const roomName = getRoomField(room.name, "Phòng đã lưu");
              return (
                <article
                  key={room.id}
                  onClick={() => onRoomSelect(room.id)}
                  className="flex cursor-pointer flex-col overflow-hidden rounded-2xl border border-[#E8DED1] bg-white shadow-sm transition hover:-translate-y-1 hover:shadow-lg active:scale-[0.99]"
                >
                  <div className="relative grid h-48 w-full shrink-0 grid-cols-5 gap-0.5 overflow-hidden">
                    <div className="col-span-3 h-full">
                      <SavedRoomImage src={images[0]} alt={roomName} />
                    </div>
                    <div className="col-span-2 grid h-full grid-rows-2 gap-0.5">
                      <SavedRoomImage src={images[1]} alt={roomName} />
                      <div className="grid h-full grid-cols-2 gap-0.5">
                        <SavedRoomImage src={images[2]} alt={roomName} />
                        <SavedRoomImage src={images[3]} alt={roomName} />
                      </div>
                    </div>
                    <button
                      onClick={(event) => handleUnsave(room.id, event)}
                      className="absolute right-3 top-3 z-10 flex h-9 w-9 items-center justify-center rounded-full bg-white/90 shadow-md transition hover:scale-110 hover:bg-white active:scale-95"
                      title="Bỏ lưu phòng này"
                    >
                      <Heart size={16} className="fill-[#F2A45B] text-[#F2A45B]" />
                    </button>
                  </div>

                  <div className="flex flex-1 flex-col bg-white p-6">
                    <h3 className="truncate text-base font-extrabold text-[#243B5A]">{roomName}</h3>
                    <div className="mt-2 flex flex-wrap items-center gap-2 text-xs font-semibold text-[#6B7A8C] sm:text-sm">
                      <span className="text-sm font-extrabold text-[#F2A45B] sm:text-base">{String(room.priceLabel || room.price || "Liên hệ")}</span>
                      <span className="text-slate-300">•</span>
                      <span className="text-[#243B5A]">{String(room.areaLabel || room.area || "Đang cập nhật")}</span>
                      <span className="text-slate-300">•</span>
                      <span className="inline-flex max-w-[200px] items-center gap-1 truncate text-[#6B7A8C]">
                        <MapPin size={13} className="shrink-0 text-[#4FA7A0]" />
                        {getRoomField(room.location)}
                      </span>
                    </div>

                    <p className="mt-2.5 line-clamp-2 text-sm leading-relaxed text-[#6B7A8C]">
                      {getRoomField(room.description)}
                    </p>
                    <div className="mt-4 flex items-center justify-between gap-2">
                      <button className="rounded-full bg-[#4FA7A0] px-3 py-2 text-sm font-bold text-white shadow-sm">Xem chi tiết</button>
                      <button
                        onClick={(event) => handleUnsave(room.id, event)}
                        className="rounded-full border border-[#E8DED1] px-3 py-2 text-sm font-semibold text-[#243B5A]"
                      >
                        Bỏ lưu
                      </button>
                    </div>
                  </div>
                </article>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
