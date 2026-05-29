import { useState } from "react";
import { Home, Heart, Receipt, User, Bot } from "lucide-react";
import { HomeScreen } from "./components/HomeScreen";
import { RoomDetailScreen } from "./components/RoomDetailScreen";
import { BillingScreen } from "./components/BillingScreen";
import { IncidentScreen } from "./components/IncidentScreen";
import { ProfileScreen } from "./components/ProfileScreen";
import { ChatOverlay } from "./components/ChatOverlay";

type Tab = "home" | "saved" | "bills" | "profile";

const navItems: { tab: Tab; icon: React.ReactNode; label: string }[] = [
  { tab: "home", icon: <Home size={22} />, label: "Trang chủ" },
  { tab: "saved", icon: <Heart size={22} />, label: "Đã lưu" },
  { tab: "bills", icon: <Receipt size={22} />, label: "Hóa đơn" },
  { tab: "profile", icon: <User size={22} />, label: "Hồ sơ" },
];

export default function App() {
  const [activeTab, setActiveTab] = useState<Tab>("home");
  const [viewingRoom, setViewingRoom] = useState<number | null>(null);
  const [chatOpen, setChatOpen] = useState(false);

  const handleRoomSelect = (id: number) => {
    setViewingRoom(id);
  };

  const handleBack = () => {
    setViewingRoom(null);
  };

  const renderContent = () => {
    if (viewingRoom !== null) {
      return <RoomDetailScreen onBack={handleBack} />;
    }
    switch (activeTab) {
      case "home":
        return <HomeScreen onRoomSelect={handleRoomSelect} />;
      case "saved":
        return <SavedScreen onRoomSelect={handleRoomSelect} />;
      case "bills":
        return <BillingScreen />;
      case "profile":
        return <ProfileScreen onOpenChat={() => setChatOpen(true)} />;
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-slate-300" style={{ fontFamily: "'Inter', sans-serif" }}>
      {/* Phone frame */}
      <div
        className="relative bg-[#F8FAFC] overflow-hidden flex flex-col"
        style={{
          width: "min(430px, 100vw)",
          height: "min(932px, 100vh)",
          boxShadow: "0 30px 80px rgba(0,0,0,0.3)",
          borderRadius: "min(40px, 0px)",
        }}
      >
        {/* Screen content */}
        <div className="flex-1 overflow-hidden relative">
          {renderContent()}
        </div>

        {/* Bottom Nav — hide on room detail */}
        {viewingRoom === null && (
          <div className="shrink-0 bg-white border-t border-slate-100 px-2 pt-2 pb-6 safe-area-bottom">
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

        {/* Floating AI Chat Button */}
        {!chatOpen && viewingRoom === null && (
          <button
            onClick={() => setChatOpen(true)}
            className="absolute bottom-24 right-4 w-14 h-14 bg-blue-600 rounded-full flex items-center justify-center shadow-lg active:scale-95 transition-transform z-30"
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

// Simple Saved screen placeholder
function SavedScreen({ onRoomSelect }: { onRoomSelect: (id: number) => void }) {
  const savedRooms = [
    {
      id: 2,
      name: "Căn Hộ View Sông Q.Bình Thạnh",
      location: "15 Xô Viết Nghệ Tĩnh, Q.BT",
      price: "8.200.000",
      image: "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=600&h=400&fit=crop&auto=format",
    },
  ];

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC] overflow-y-auto">
      <div className="bg-white px-4 pt-12 pb-4 shadow-sm">
        <h1 className="text-slate-900" style={{ fontSize: "1.25rem", fontWeight: 700 }}>
          Đã Lưu
        </h1>
      </div>
      <div className="flex-1 px-4 pt-5 space-y-3">
        {savedRooms.map((room) => (
          <div
            key={room.id}
            onClick={() => onRoomSelect(room.id)}
            className="bg-white rounded-2xl overflow-hidden shadow-sm cursor-pointer active:scale-[0.99] transition-transform"
          >
            <img src={room.image} alt={room.name} className="w-full h-44 object-cover" />
            <div className="p-4">
              <h3 className="font-semibold text-slate-900">{room.name}</h3>
              <p className="text-sm text-slate-500 mt-0.5">{room.location}</p>
              <p className="text-blue-600 font-bold mt-2">{room.price}đ/tháng</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
