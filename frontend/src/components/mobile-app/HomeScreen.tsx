'use client';

import { useEffect, useMemo, useState } from "react";
import type { MouseEvent } from "react";
import Link from "next/link";
import {
  Bell,
  Building2,
  Car,
  ChevronRight,
  Heart,
  Home,
  LogIn,
  MapPin,
  Search,
  ShieldCheck,
  SlidersHorizontal,
  Sparkles,
  Square,
  Star,
  UserPlus,
  Wifi,
  Wind,
  X,
} from "lucide-react";

type RoomId = string | number;

type RoomCard = {
  id: RoomId;
  name: string;
  location: string;
  priceValue: number;
  priceLabel: string;
  areaValue: number;
  areaLabel: string;
  amenities: string[];
  image: string;
  hinhAnh: string[];
  description: string;
  rating: number;
  reviews: number;
};

interface HomeScreenProps {
  onRoomSelect: (id: any) => void;
  onTabChange?: (tab: "home" | "saved" | "bills" | "profile") => void;
}

const CATEGORIES = ["Phòng trọ", "Căn hộ mini", "Nhà nguyên căn", "Ở ghép", "Mặt bằng"];

const PRICE_RANGES = [
  { id: "all", label: "Tất cả", shortLabel: "Giá", min: 0, max: Infinity },
  { id: "under-3", label: "Dưới 3 triệu", shortLabel: "< 3tr", min: 0, max: 3000000 },
  { id: "3-5", label: "3 - 5 triệu", shortLabel: "3-5tr", min: 3000000, max: 5000000 },
  { id: "5-10", label: "5 - 10 triệu", shortLabel: "5-10tr", min: 5000000, max: 10000000 },
  { id: "over-10", label: "Trên 10 triệu", shortLabel: "> 10tr", min: 10000000, max: Infinity },
];

const AREA_RANGES = [
  { id: "all", label: "Tất cả", shortLabel: "Diện tích", min: 0, max: Infinity },
  { id: "under-20", label: "Dưới 20m2", shortLabel: "< 20m2", min: 0, max: 20 },
  { id: "20-40", label: "20 - 40m2", shortLabel: "20-40m2", min: 20, max: 40 },
  { id: "over-40", label: "Trên 40m2", shortLabel: "> 40m2", min: 40, max: Infinity },
];

const DEFAULT_IMAGES = [
  "https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=900&fit=crop&auto=format",
  "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=900&fit=crop&auto=format",
  "https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=900&fit=crop&auto=format",
];

const parseNumber = (value: unknown) => {
  if (typeof value === "number") return value;
  if (!value) return 0;
  return Number(String(value).replace(/[^0-9]/g, "")) || 0;
};

const formatCurrency = (value: number) => {
  if (!value) return "Liên hệ";
  if (value >= 1000000) {
    return `${(value / 1000000).toFixed(1).replace(".0", "")} triệu/tháng`;
  }
  return `${new Intl.NumberFormat("vi-VN").format(value)}đ/tháng`;
};

const getFirstImage = (room: any, fallbackIndex = 0) => {
  const list = room?.anhList || room?.hinhAnh || [];
  const first = Array.isArray(list) ? list[0] : null;
  if (typeof first === "string") return first;
  if (first?.url) return first.url;
  if (first?.hinhAnh) return first.hinhAnh;
  return room?.anhDaiDien || room?.image || DEFAULT_IMAGES[fallbackIndex % DEFAULT_IMAGES.length];
};

const normalizeAmenities = (room: any) => {
  const raw = room?.tienIchNoiBat || room?.tienIch || [];
  const list = Array.isArray(raw) ? raw : String(raw).split(",");
  return list.map((item) => String(item).trim()).filter(Boolean).slice(0, 3);
};

const mapRoom = (room: any, index: number): RoomCard => {
  const priceValue = parseNumber(room?.giaHienTai || room?.giaThue || room?.price);
  const areaValue = parseNumber(room?.dienTich || room?.area);
  const roomCode = room?.maPhong || room?.soPhong || room?.ten || room?.name;

  return {
    id: room?._id || room?.id || index,
    name: roomCode ? `Phòng ${String(roomCode).replace(/^Phòng\s+/i, "")}` : "Phòng đang cập nhật",
    location: room?.diaChiNhaTro || room?.toaNha?.diaChi || room?.location || "Chưa cập nhật địa chỉ",
    priceValue,
    priceLabel: formatCurrency(priceValue),
    areaValue,
    areaLabel: areaValue ? `${areaValue}m2` : "Đang cập nhật",
    amenities: normalizeAmenities(room),
    image: getFirstImage(room, index),
    hinhAnh: Array.isArray(room?.anhList || room?.hinhAnh) ? room?.anhList || room?.hinhAnh : [],
    description: room?.moTa || room?.description || room?.mo_ta || "Phòng có vị trí thuận tiện, phù hợp để ở lâu dài.",
    rating: Number(room?.rating) || 4.8,
    reviews: Number(room?.reviews) || 12,
  };
};

const amenityIcon = (amenity: string) => {
  const value = amenity.toLowerCase();
  if (value.includes("wifi")) return <Wifi size={13} />;
  if (value.includes("điều hòa") || value.includes("may lanh") || value.includes("ac")) return <Wind size={13} />;
  if (value.includes("xe") || value.includes("parking")) return <Car size={13} />;
  return <Sparkles size={13} />;
};

export function HomeScreen({ onRoomSelect, onTabChange }: HomeScreenProps) {
  const [userProfile, setUserProfile] = useState<any>(null);
  const [allRooms, setAllRooms] = useState<RoomCard[]>([]);
  const [isFilterOpen, setIsFilterOpen] = useState(false);
  const [filterCat, setFilterCat] = useState("Phòng trọ");
  const [filterPrice, setFilterPrice] = useState("all");
  const [filterArea, setFilterArea] = useState("all");
  const [searchQuery, setSearchQuery] = useState("");
  const [savedRooms, setSavedRooms] = useState<Set<RoomId>>(new Set());

  useEffect(() => {
    const saved = localStorage.getItem("easyhouse_saved_rooms");
    if (saved) {
      try {
        const parsed = JSON.parse(saved);
        setSavedRooms(new Set(parsed.map((room: any) => room.id)));
      } catch (error) {
        console.error(error);
      }
    }

    fetch("/api/user/profile")
      .then((res) => res.json())
      .then((data) => {
        if (data?.data) setUserProfile(data.data);
      })
      .catch(() => {});

    fetch("/api/public/phong")
      .then((res) => res.json())
      .then((data) => {
        const rooms = Array.isArray(data) ? data : data?.data?.data || data?.data?.content || data?.data || [];
        setAllRooms(Array.isArray(rooms) ? rooms.map(mapRoom) : []);
      })
      .catch((error) => console.error("API Fetch Error:", error));
  }, []);

  const filteredRooms = useMemo(() => {
    const price = PRICE_RANGES.find((item) => item.id === filterPrice) || PRICE_RANGES[0];
    const area = AREA_RANGES.find((item) => item.id === filterArea) || AREA_RANGES[0];
    const query = searchQuery.trim().toLowerCase();

    return allRooms.filter((room) => {
      const text = `${room.name} ${room.location} ${room.description}`.toLowerCase();
      const matchQuery = !query || text.includes(query);
      const matchPrice = filterPrice === "all" || (room.priceValue >= price.min && room.priceValue <= price.max);
      const matchArea = filterArea === "all" || (room.areaValue >= area.min && room.areaValue <= area.max);
      return matchQuery && matchPrice && matchArea;
    });
  }, [allRooms, filterArea, filterPrice, searchQuery]);

  const featuredRooms = useMemo(() => filteredRooms.slice(0, 3), [filteredRooms]);
  const savedCount = savedRooms.size;
  const currentUserName = userProfile?.name || userProfile?.hoTen || "Khách thuê";
  const currentUserAvatar =
    userProfile?.avatar ||
    "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=120&h=120&fit=crop&auto=format";
  const selectedPriceLabel = PRICE_RANGES.find((item) => item.id === filterPrice)?.shortLabel || "Giá";
  const selectedAreaLabel = AREA_RANGES.find((item) => item.id === filterArea)?.shortLabel || "Diện tích";

  const resetFilters = () => {
    setFilterCat("Phòng trọ");
    setFilterPrice("all");
    setFilterArea("all");
    setSearchQuery("");
  };

  const toggleSave = (room: RoomCard, event: MouseEvent) => {
    event.stopPropagation();
    const saved = localStorage.getItem("easyhouse_saved_rooms");
    let currentSaved: RoomCard[] = saved ? JSON.parse(saved) : [];
    const exists = currentSaved.some((item) => item.id === room.id);

    if (exists) {
      currentSaved = currentSaved.filter((item) => item.id !== room.id);
    } else {
      currentSaved.push(room);
    }

    localStorage.setItem("easyhouse_saved_rooms", JSON.stringify(currentSaved));
    setSavedRooms(new Set(currentSaved.map((item) => item.id)));
  };

  return (
    <div className="flex h-full flex-col overflow-y-auto bg-[#F6F8FB] text-slate-900">
      <header className="sticky top-0 z-30 border-b border-slate-200/80 bg-white/95 px-4 pb-3 pt-4 shadow-sm backdrop-blur md:px-8">
        <div className="mx-auto flex w-full max-w-7xl items-center justify-between gap-3">
          <button onClick={resetFilters} className="flex min-w-0 items-center gap-2 text-left" title="Về trang chủ">
            <span className="flex h-10 w-10 items-center justify-center rounded-2xl bg-teal-600 text-white shadow-sm">
              <Home size={20} />
            </span>
            <span className="min-w-0">
              <span className="block text-base font-black leading-tight tracking-tight text-slate-950">EasyHouse</span>
              <span className="block truncate text-[11px] font-medium text-slate-500">Tìm phòng minh bạch, nhanh gọn</span>
            </span>
          </button>

          <div className="flex items-center gap-2">
            <button
              onClick={() => onTabChange?.("saved")}
              className="relative flex h-10 w-10 items-center justify-center rounded-2xl border border-slate-200 bg-white text-slate-700 shadow-sm transition hover:border-teal-200 hover:text-teal-700"
              title="Tin đã lưu"
            >
              <Heart size={18} />
              {savedCount > 0 && (
                <span className="absolute -right-1 -top-1 min-w-5 rounded-full bg-orange-500 px-1.5 text-center text-[10px] font-bold text-white">
                  {savedCount}
                </span>
              )}
            </button>
            <button className="hidden h-10 w-10 items-center justify-center rounded-2xl border border-slate-200 bg-white text-slate-700 shadow-sm md:flex" title="Thông báo">
              <Bell size={18} />
            </button>
            {userProfile ? (
              <button onClick={() => onTabChange?.("profile")} className="flex items-center gap-2 rounded-2xl border border-slate-200 bg-white p-1.5 pr-3 shadow-sm">
                <img src={currentUserAvatar} alt={currentUserName} className="h-8 w-8 rounded-xl object-cover" />
                <span className="hidden max-w-28 truncate text-sm font-semibold text-slate-700 sm:block">{currentUserName}</span>
              </button>
            ) : (
              <Link href="/dang-nhap" className="flex h-10 items-center gap-2 rounded-2xl bg-slate-950 px-3 text-sm font-semibold text-white shadow-sm">
                <LogIn size={16} />
                <span className="hidden sm:inline">Đăng nhập</span>
              </Link>
            )}
          </div>
        </div>

        <div className="mx-auto mt-4 flex w-full max-w-7xl gap-2">
          <div className="flex min-w-0 flex-1 items-center gap-2 rounded-2xl border border-slate-200 bg-slate-50 px-3 py-2.5 transition focus-within:border-teal-400 focus-within:bg-white focus-within:ring-4 focus-within:ring-teal-100">
            <Search size={18} className="shrink-0 text-slate-400" />
            <input
              value={searchQuery}
              onChange={(event) => setSearchQuery(event.target.value)}
              placeholder="Tìm khu vực, tên phòng..."
              className="w-full bg-transparent text-sm font-medium text-slate-800 outline-none placeholder:text-slate-400"
            />
          </div>
          <button
            onClick={() => setIsFilterOpen(true)}
            className="flex h-[46px] items-center gap-2 rounded-2xl border border-slate-200 bg-white px-3 text-sm font-bold text-slate-800 shadow-sm transition hover:border-teal-200 hover:text-teal-700"
          >
            <SlidersHorizontal size={18} />
            <span className="hidden sm:inline">Bộ lọc</span>
          </button>
        </div>
      </header>

      <main className="mx-auto w-full max-w-7xl flex-1 px-4 py-5 md:px-8 md:py-7">
        <section className="overflow-hidden rounded-[28px] bg-slate-950 text-white shadow-xl shadow-slate-200">
          <div className="grid gap-0 lg:grid-cols-[1.05fr_0.95fr]">
            <div className="flex flex-col justify-between p-5 sm:p-7 lg:p-8">
              <div>
                <span className="inline-flex items-center gap-2 rounded-full bg-white/10 px-3 py-1.5 text-xs font-bold text-teal-100 ring-1 ring-white/10">
                  <ShieldCheck size={14} />
                  Phòng đã kiểm duyệt
                </span>
                <h1 className="mt-4 max-w-2xl text-2xl font-black leading-tight tracking-tight sm:text-4xl">
                  Tìm phòng phù hợp ngân sách trong vài thao tác
                </h1>
                <p className="mt-3 max-w-xl text-sm leading-6 text-slate-300">
                  Lọc theo giá, diện tích và vị trí. Lưu phòng quan tâm để so sánh trước khi liên hệ.
                </p>
              </div>
              <div className="mt-6 grid grid-cols-3 gap-3">
                <div className="rounded-2xl bg-white/10 p-3 ring-1 ring-white/10">
                  <p className="text-xl font-black">{allRooms.length}</p>
                  <p className="mt-1 text-[11px] font-medium text-slate-300">Phòng đang đăng</p>
                </div>
                <div className="rounded-2xl bg-white/10 p-3 ring-1 ring-white/10">
                  <p className="text-xl font-black">{filteredRooms.length}</p>
                  <p className="mt-1 text-[11px] font-medium text-slate-300">Kết quả phù hợp</p>
                </div>
                <div className="rounded-2xl bg-white/10 p-3 ring-1 ring-white/10">
                  <p className="text-xl font-black">{savedCount}</p>
                  <p className="mt-1 text-[11px] font-medium text-slate-300">Tin đã lưu</p>
                </div>
              </div>
            </div>
            <div className="relative min-h-[220px] overflow-hidden lg:min-h-full">
              <img src={featuredRooms[0]?.image || DEFAULT_IMAGES[0]} alt="Phòng trọ EasyHouse" className="h-full min-h-[220px] w-full object-cover" />
              <div className="absolute inset-0 bg-gradient-to-t from-slate-950/60 via-transparent to-transparent lg:bg-gradient-to-r" />
              <div className="absolute bottom-4 left-4 right-4 rounded-3xl bg-white/95 p-4 text-slate-900 shadow-2xl backdrop-blur">
                <p className="text-xs font-bold uppercase tracking-wide text-teal-700">Gợi ý hôm nay</p>
                <p className="mt-1 line-clamp-1 text-base font-black">{featuredRooms[0]?.name || "Phòng tiện nghi gần trung tâm"}</p>
                <p className="mt-1 text-sm font-bold text-orange-600">{featuredRooms[0]?.priceLabel || "Từ 3 triệu/tháng"}</p>
              </div>
            </div>
          </div>
        </section>

        <section className="mt-5">
          <div className="flex gap-2 overflow-x-auto pb-1 [scrollbar-width:none]">
            {CATEGORIES.map((category) => (
              <button
                key={category}
                onClick={() => setFilterCat(category)}
                className={`shrink-0 rounded-full border px-4 py-2 text-sm font-bold transition ${
                  filterCat === category
                    ? "border-teal-600 bg-teal-600 text-white shadow-sm"
                    : "border-slate-200 bg-white text-slate-600 hover:border-teal-200 hover:text-teal-700"
                }`}
              >
                {category}
              </button>
            ))}
          </div>

          <div className="mt-3 grid grid-cols-2 gap-2 sm:flex">
            <button onClick={() => setIsFilterOpen(true)} className="rounded-2xl border border-slate-200 bg-white px-3 py-2.5 text-left text-sm font-bold text-slate-700 shadow-sm">
              {selectedPriceLabel}
            </button>
            <button onClick={() => setIsFilterOpen(true)} className="rounded-2xl border border-slate-200 bg-white px-3 py-2.5 text-left text-sm font-bold text-slate-700 shadow-sm">
              {selectedAreaLabel}
            </button>
            {(searchQuery || filterPrice !== "all" || filterArea !== "all" || filterCat !== "Phòng trọ") && (
              <button onClick={resetFilters} className="col-span-2 rounded-2xl border border-orange-200 bg-orange-50 px-3 py-2.5 text-sm font-bold text-orange-700 sm:col-span-1">
                Xóa lọc
              </button>
            )}
          </div>
        </section>

        {featuredRooms.length > 0 && (
          <section className="mt-7">
            <div className="mb-3 flex items-center justify-between">
              <div>
                <h2 className="text-lg font-black tracking-tight text-slate-950">Phòng nổi bật</h2>
                <p className="text-xs font-medium text-slate-500">Ưu tiên phòng có thông tin đầy đủ</p>
              </div>
              <button className="flex items-center gap-1 text-sm font-bold text-teal-700">
                Xem thêm <ChevronRight size={16} />
              </button>
            </div>
            <div className="flex gap-3 overflow-x-auto pb-2 [scrollbar-width:none]">
              {featuredRooms.map((room) => (
                <button
                  key={room.id}
                  onClick={() => onRoomSelect(room.id)}
                  className="relative min-w-[250px] overflow-hidden rounded-3xl bg-white text-left shadow-sm ring-1 ring-slate-200 transition hover:-translate-y-0.5 hover:shadow-md"
                >
                  <img src={room.image} alt={room.name} className="h-36 w-full object-cover" />
                  <div className="absolute left-3 top-3 rounded-full bg-white/95 px-2.5 py-1 text-xs font-black text-orange-600 shadow-sm">
                    {room.priceLabel}
                  </div>
                  <div className="p-4">
                    <p className="line-clamp-1 text-base font-black text-slate-950">{room.name}</p>
                    <p className="mt-1 flex items-center gap-1 text-xs font-medium text-slate-500">
                      <MapPin size={13} /> <span className="line-clamp-1">{room.location}</span>
                    </p>
                  </div>
                </button>
              ))}
            </div>
          </section>
        )}

        <section className="mt-7">
          <div className="mb-3 flex items-end justify-between gap-3">
            <div>
              <h2 className="text-lg font-black tracking-tight text-slate-950">Danh sách phòng</h2>
              <p className="text-xs font-medium text-slate-500">{filteredRooms.length} kết quả đang hiển thị</p>
            </div>
            <Link href="/dang-ky" className="hidden items-center gap-2 rounded-2xl bg-white px-3 py-2 text-sm font-bold text-slate-700 shadow-sm ring-1 ring-slate-200 sm:flex">
              <UserPlus size={16} /> Đăng tin
            </Link>
          </div>

          {filteredRooms.length === 0 ? (
            <div className="rounded-3xl border border-dashed border-slate-300 bg-white p-8 text-center">
              <div className="mx-auto flex h-12 w-12 items-center justify-center rounded-2xl bg-slate-100 text-slate-500">
                <Search size={22} />
              </div>
              <h3 className="mt-4 text-base font-black text-slate-900">Chưa có phòng phù hợp</h3>
              <p className="mt-1 text-sm text-slate-500">Thử bỏ bớt điều kiện lọc hoặc tìm bằng khu vực khác.</p>
              <button onClick={resetFilters} className="mt-4 rounded-2xl bg-teal-600 px-4 py-2.5 text-sm font-bold text-white shadow-sm">
                Xóa bộ lọc
              </button>
            </div>
          ) : (
            <div className="grid grid-cols-1 gap-4 md:grid-cols-2 xl:grid-cols-3">
              {filteredRooms.map((room) => (
                <article
                  key={room.id}
                  onClick={() => onRoomSelect(room.id)}
                  className="group cursor-pointer overflow-hidden rounded-3xl bg-white shadow-sm ring-1 ring-slate-200 transition hover:-translate-y-0.5 hover:shadow-lg"
                >
                  <div className="relative h-52 overflow-hidden">
                    <img src={room.image} alt={room.name} className="h-full w-full object-cover transition duration-300 group-hover:scale-105" />
                    <div className="absolute left-3 top-3 rounded-full bg-white/95 px-2.5 py-1 text-xs font-black text-teal-700 shadow-sm">
                      Còn phòng
                    </div>
                    <button
                      onClick={(event) => toggleSave(room, event)}
                      className="absolute right-3 top-3 flex h-10 w-10 items-center justify-center rounded-2xl bg-white/95 text-slate-600 shadow-sm transition hover:text-orange-600"
                      title="Lưu phòng"
                    >
                      <Heart size={18} className={savedRooms.has(room.id) ? "fill-orange-500 text-orange-500" : ""} />
                    </button>
                  </div>

                  <div className="p-4">
                    <div className="flex items-start justify-between gap-3">
                      <div className="min-w-0">
                        <h3 className="line-clamp-1 text-base font-black text-slate-950">{room.name}</h3>
                        <p className="mt-1 flex items-center gap-1 text-xs font-medium text-slate-500">
                          <MapPin size={13} className="shrink-0" />
                          <span className="line-clamp-1">{room.location}</span>
                        </p>
                      </div>
                      <div className="flex shrink-0 items-center gap-1 rounded-full bg-amber-50 px-2 py-1 text-xs font-black text-amber-700">
                        <Star size={13} className="fill-amber-500 text-amber-500" />
                        {room.rating.toFixed(1)}
                      </div>
                    </div>

                    <div className="mt-4 flex items-center justify-between gap-3">
                      <p className="text-lg font-black text-orange-600">{room.priceLabel}</p>
                      <span className="inline-flex items-center gap-1 rounded-full bg-slate-100 px-2.5 py-1 text-xs font-bold text-slate-700">
                        <Square size={12} /> {room.areaLabel}
                      </span>
                    </div>

                    <p className="mt-3 line-clamp-2 text-sm leading-6 text-slate-600">{room.description}</p>

                    <div className="mt-4 flex flex-wrap gap-2">
                      {(room.amenities.length ? room.amenities : ["Wifi", "An ninh", "Gửi xe"]).map((amenity) => (
                        <span key={`${room.id}-${amenity}`} className="inline-flex items-center gap-1 rounded-full bg-teal-50 px-2.5 py-1 text-xs font-bold text-teal-700">
                          {amenityIcon(amenity)}
                          {amenity}
                        </span>
                      ))}
                    </div>
                  </div>
                </article>
              ))}
            </div>
          )}
        </section>
      </main>

      <footer className="mt-4 bg-slate-950 px-4 py-8 text-slate-300 md:px-8">
        <div className="mx-auto grid w-full max-w-7xl gap-6 md:grid-cols-[1.2fr_0.8fr_0.8fr]">
          <div>
            <div className="flex items-center gap-2">
              <span className="flex h-10 w-10 items-center justify-center rounded-2xl bg-teal-500 text-white">
                <Building2 size={20} />
              </span>
              <div>
                <p className="text-lg font-black text-white">EasyHouse</p>
                <p className="text-xs text-slate-400">Nền tảng tìm và quản lý phòng trọ</p>
              </div>
            </div>
            <p className="mt-4 max-w-xl text-sm leading-6 text-slate-400">
              Hỗ trợ chủ trọ đăng phòng minh bạch và giúp khách thuê tìm được nơi ở phù hợp hơn.
            </p>
          </div>
          <div>
            <p className="font-bold text-white">Liên kết</p>
            <div className="mt-3 grid gap-2 text-sm">
              <Link href="/xem-phong" className="hover:text-white">Tìm phòng</Link>
              <Link href="/dang-ky" className="hover:text-white">Đăng ký</Link>
              <Link href="/dang-nhap" className="hover:text-white">Đăng nhập</Link>
            </div>
          </div>
          <div>
            <p className="font-bold text-white">Liên hệ</p>
            <div className="mt-3 grid gap-2 text-sm text-slate-400">
              <span>Hotline: 1900 8888</span>
              <span>Email: support@easyhouse.local</span>
              <span>136 Cầu Diễn, Bắc Từ Liêm, Hà Nội</span>
            </div>
          </div>
        </div>
      </footer>

      {isFilterOpen && (
        <div className="fixed inset-0 z-50 flex items-end justify-center bg-slate-950/55 backdrop-blur-sm md:items-center">
          <div className="flex max-h-[90vh] w-full flex-col overflow-hidden rounded-t-[28px] bg-white shadow-2xl md:max-w-lg md:rounded-[28px]">
            <div className="flex items-center justify-between border-b border-slate-100 px-5 py-4">
              <div>
                <h2 className="text-lg font-black text-slate-950">Bộ lọc tìm phòng</h2>
                <p className="text-xs font-medium text-slate-500">Chọn điều kiện phù hợp nhu cầu</p>
              </div>
              <button onClick={() => setIsFilterOpen(false)} className="flex h-10 w-10 items-center justify-center rounded-2xl bg-slate-100 text-slate-600">
                <X size={18} />
              </button>
            </div>

            <div className="flex-1 space-y-6 overflow-y-auto px-5 py-5">
              <div>
                <p className="mb-3 text-sm font-black text-slate-900">Loại hình</p>
                <div className="flex flex-wrap gap-2">
                  {CATEGORIES.map((category) => (
                    <button
                      key={category}
                      onClick={() => setFilterCat(category)}
                      className={`rounded-full border px-4 py-2 text-sm font-bold transition ${
                        filterCat === category
                          ? "border-teal-600 bg-teal-600 text-white"
                          : "border-slate-200 bg-white text-slate-600"
                      }`}
                    >
                      {category}
                    </button>
                  ))}
                </div>
              </div>

              <div>
                <p className="mb-3 text-sm font-black text-slate-900">Khoảng giá</p>
                <div className="grid grid-cols-2 gap-2">
                  {PRICE_RANGES.map((price) => (
                    <button
                      key={price.id}
                      onClick={() => setFilterPrice(price.id)}
                      className={`rounded-2xl border px-3 py-3 text-sm font-bold transition ${
                        filterPrice === price.id
                          ? "border-teal-600 bg-teal-50 text-teal-800"
                          : "border-slate-200 bg-white text-slate-600"
                      }`}
                    >
                      {price.label}
                    </button>
                  ))}
                </div>
              </div>

              <div>
                <p className="mb-3 text-sm font-black text-slate-900">Diện tích</p>
                <div className="grid grid-cols-2 gap-2">
                  {AREA_RANGES.map((area) => (
                    <button
                      key={area.id}
                      onClick={() => setFilterArea(area.id)}
                      className={`rounded-2xl border px-3 py-3 text-sm font-bold transition ${
                        filterArea === area.id
                          ? "border-teal-600 bg-teal-50 text-teal-800"
                          : "border-slate-200 bg-white text-slate-600"
                      }`}
                    >
                      {area.label}
                    </button>
                  ))}
                </div>
              </div>
            </div>

            <div className="grid grid-cols-[0.8fr_1.2fr] gap-3 border-t border-slate-100 bg-slate-50 px-5 py-4">
              <button onClick={resetFilters} className="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-black text-slate-700">
                Đặt lại
              </button>
              <button onClick={() => setIsFilterOpen(false)} className="rounded-2xl bg-teal-600 px-4 py-3 text-sm font-black text-white shadow-lg shadow-teal-100">
                Hiển thị {filteredRooms.length} kết quả
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
