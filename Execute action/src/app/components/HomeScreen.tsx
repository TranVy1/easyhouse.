import { useState } from "react";
import {
  Search, SlidersHorizontal, Heart, MapPin, Wifi, Wind,
  Car, Star, ChevronRight, Bell
} from "lucide-react";

const featuredRooms = [
  {
    id: 1,
    name: "Studio Hiện Đại Quận 1",
    location: "39 Nguyễn Huệ, Q.1, TP.HCM",
    price: "5.500.000",
    rating: 4.9,
    reviews: 128,
    image: "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=600&h=400&fit=crop&auto=format",
    saved: false,
  },
  {
    id: 2,
    name: "Căn Hộ View Sông Q.Bình Thạnh",
    location: "15 Xô Viết Nghệ Tĩnh, Q.BT",
    price: "8.200.000",
    rating: 4.7,
    reviews: 89,
    image: "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=600&h=400&fit=crop&auto=format",
    saved: true,
  },
  {
    id: 3,
    name: "Phòng Trọ Cao Cấp Quận 7",
    location: "12 Nguyễn Thị Thập, Q.7",
    price: "4.200.000",
    rating: 4.8,
    reviews: 56,
    image: "https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=600&h=400&fit=crop&auto=format",
    saved: false,
  },
];

const availableRooms = [
  {
    id: 4,
    name: "Phòng Trọ Bình Dân Q.Gò Vấp",
    location: "88 Quang Trung, Q.Gò Vấp",
    price: "2.800.000",
    area: "20m²",
    bedrooms: 1,
    amenities: ["wifi", "ac"],
    image: "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=200&h=200&fit=crop&auto=format",
  },
  {
    id: 5,
    name: "Căn Hộ Mini Full Nội Thất Q.3",
    location: "22 Võ Thị Sáu, Q.3, TP.HCM",
    price: "6.500.000",
    area: "35m²",
    bedrooms: 1,
    amenities: ["wifi", "ac", "parking"],
    image: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=200&h=200&fit=crop&auto=format",
  },
  {
    id: 6,
    name: "Phòng Master Quận Tân Bình",
    location: "55 Cộng Hòa, Q.Tân Bình",
    price: "3.900.000",
    area: "25m²",
    bedrooms: 1,
    amenities: ["wifi", "ac"],
    image: "https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=200&h=200&fit=crop&auto=format",
  },
];

const amenityIcon = (type: string) => {
  if (type === "wifi") return <Wifi size={14} className="text-blue-500" />;
  if (type === "ac") return <Wind size={14} className="text-blue-500" />;
  if (type === "parking") return <Car size={14} className="text-blue-500" />;
  return null;
};

interface HomeScreenProps {
  onRoomSelect: (id: number) => void;
}

export function HomeScreen({ onRoomSelect }: HomeScreenProps) {
  const [savedRooms, setSavedRooms] = useState<Set<number>>(
    new Set(featuredRooms.filter((r) => r.saved).map((r) => r.id))
  );

  const toggleSave = (id: number, e: React.MouseEvent) => {
    e.stopPropagation();
    setSavedRooms((prev) => {
      const next = new Set(prev);
      next.has(id) ? next.delete(id) : next.add(id);
      return next;
    });
  };

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC] overflow-y-auto">
      {/* Header */}
      <div className="sticky top-0 z-20 bg-white px-4 pt-12 pb-4 shadow-sm">
        <div className="flex items-center justify-between mb-4">
          <div>
            <p className="text-sm text-slate-500">Chào buổi sáng 👋</p>
            <h1 className="text-slate-900" style={{ fontSize: "1.25rem", fontWeight: 700, lineHeight: 1.3 }}>
              Nguyễn Văn An
            </h1>
          </div>
          <div className="flex items-center gap-2">
            <button className="relative w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center">
              <Bell size={20} className="text-blue-600" />
              <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full" />
            </button>
            <img
              src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=80&h=80&fit=crop&auto=format"
              alt="Avatar"
              className="w-10 h-10 rounded-full object-cover border-2 border-blue-500"
            />
          </div>
        </div>
        {/* Search Bar */}
        <div className="flex gap-2">
          <div className="flex-1 flex items-center gap-2 bg-[#F1F5F9] rounded-2xl px-4 py-3">
            <Search size={18} className="text-slate-400 shrink-0" />
            <input
              type="text"
              placeholder="Tìm phòng, địa điểm..."
              className="bg-transparent outline-none text-sm text-slate-700 placeholder:text-slate-400 w-full"
            />
          </div>
          <button className="w-12 h-12 bg-blue-600 rounded-2xl flex items-center justify-center shadow-sm">
            <SlidersHorizontal size={18} className="text-white" />
          </button>
        </div>
        {/* Filter Chips */}
        <div className="flex gap-2 mt-3 overflow-x-auto pb-1 scrollbar-none">
          {["Tất cả", "Quận 1", "Quận 7", "Bình Thạnh", "Gò Vấp"].map((f) => (
            <button
              key={f}
              className={`shrink-0 px-3 py-1.5 rounded-full text-xs ${f === "Tất cả"
                  ? "bg-blue-600 text-white"
                  : "bg-[#F1F5F9] text-slate-600"
                }`}
            >
              {f}
            </button>
          ))}
        </div>
      </div>

      <div className="flex-1 px-4 pt-5 pb-4 space-y-6">
        {/* Featured Rooms */}
        <section>
          <div className="flex items-center justify-between mb-3">
            <h2 className="text-slate-900" style={{ fontSize: "1rem", fontWeight: 700 }}>
              Phòng Nổi Bật
            </h2>
            <button className="flex items-center gap-1 text-blue-600 text-sm">
              Xem tất cả <ChevronRight size={14} />
            </button>
          </div>
          <div className="flex gap-4 overflow-x-auto pb-2 scrollbar-none">
            {featuredRooms.map((room) => (
              <div
                key={room.id}
                onClick={() => onRoomSelect(room.id)}
                className="shrink-0 w-64 rounded-2xl overflow-hidden bg-white shadow-sm cursor-pointer active:scale-95 transition-transform"
              >
                <div className="relative">
                  <img
                    src={room.image}
                    alt={room.name}
                    className="w-full h-40 object-cover"
                  />
                  <div className="absolute top-3 right-3">
                    <button
                      onClick={(e) => toggleSave(room.id, e)}
                      className="w-9 h-9 rounded-full bg-white/90 backdrop-blur flex items-center justify-center shadow-sm"
                    >
                      <Heart
                        size={16}
                        className={savedRooms.has(room.id) ? "fill-red-500 text-red-500" : "text-slate-400"}
                      />
                    </button>
                  </div>
                  <div className="absolute bottom-3 left-3 bg-blue-600 text-white text-xs px-2.5 py-1 rounded-full font-semibold">
                    {room.price}đ/tháng
                  </div>
                </div>
                <div className="p-3">
                  <h3 className="text-slate-900 text-sm font-semibold leading-snug">{room.name}</h3>
                  <div className="flex items-center gap-1 mt-1">
                    <MapPin size={12} className="text-slate-400" />
                    <p className="text-xs text-slate-500 truncate">{room.location}</p>
                  </div>
                  <div className="flex items-center gap-1 mt-2">
                    <Star size={12} className="fill-amber-400 text-amber-400" />
                    <span className="text-xs font-semibold text-slate-700">{room.rating}</span>
                    <span className="text-xs text-slate-400">({room.reviews} đánh giá)</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* Available Rooms */}
        <section>
          <div className="flex items-center justify-between mb-3">
            <h2 className="text-slate-900" style={{ fontSize: "1rem", fontWeight: 700 }}>
              Tất Cả Phòng
            </h2>
            <button className="flex items-center gap-1 text-blue-600 text-sm">
              Xem tất cả <ChevronRight size={14} />
            </button>
          </div>
          <div className="space-y-3">
            {availableRooms.map((room) => (
              <div
                key={room.id}
                onClick={() => onRoomSelect(room.id)}
                className="flex gap-3 bg-white rounded-2xl p-3 shadow-sm cursor-pointer active:scale-[0.99] transition-transform"
              >
                <img
                  src={room.image}
                  alt={room.name}
                  className="w-20 h-20 rounded-xl object-cover shrink-0"
                />
                <div className="flex-1 min-w-0">
                  <h3 className="text-slate-900 text-sm font-semibold leading-snug truncate">{room.name}</h3>
                  <div className="flex items-center gap-1 mt-0.5">
                    <MapPin size={11} className="text-slate-400 shrink-0" />
                    <p className="text-xs text-slate-500 truncate">{room.location}</p>
                  </div>
                  <div className="flex items-center gap-3 mt-2">
                    <span className="text-xs text-slate-500">{room.area}</span>
                    <div className="flex items-center gap-1">
                      {room.amenities.map((a) => (
                        <span key={a}>{amenityIcon(a)}</span>
                      ))}
                    </div>
                  </div>
                  <p className="text-blue-600 text-sm font-bold mt-1">{room.price}đ/tháng</p>
                </div>
              </div>
            ))}
          </div>
        </section>
      </div>
    </div>
  );
}
