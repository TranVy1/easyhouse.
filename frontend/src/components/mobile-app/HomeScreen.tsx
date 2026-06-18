"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import type { MouseEvent, ReactNode } from "react";
import Link from "next/link";
import { useSession } from "next-auth/react";
import {
  ArrowRight,
  Bell,
  Building2,
  Car,
  ChevronLeft,
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
  image?: string;
  images: string[];
  description: string;
  status?: string;
  maxPeople?: number;
};

type LooseRoom = Record<string, unknown> & {
  nhaTro?: Record<string, unknown>;
  toaNha?: Record<string, unknown>;
};

type HomeViewState = {
  filterPrice?: string;
  filterArea?: string;
  searchQuery?: string;
  currentPage?: number;
};

interface HomeScreenProps {
  onRoomSelect: (id: RoomId) => void;
  onTabChange?: (tab: "home" | "saved" | "bills" | "profile") => void;
}

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

const ROOMS_PER_PAGE = 9;
const HOME_VIEW_STATE_KEY = "easyhouse_home_view_state";

const getInitialHomeViewState = (): Required<HomeViewState> => {
  const fallback = {
    filterPrice: "all",
    filterArea: "all",
    searchQuery: "",
    currentPage: 1,
  };

  if (typeof window === "undefined") return fallback;

  try {
    const stored = window.sessionStorage.getItem(HOME_VIEW_STATE_KEY);
    if (!stored) return fallback;
    const parsed = JSON.parse(stored) as HomeViewState;

    return {
      filterPrice: parsed.filterPrice || fallback.filterPrice,
      filterArea: parsed.filterArea || fallback.filterArea,
      searchQuery: parsed.searchQuery || fallback.searchQuery,
      currentPage: Math.max(1, Number(parsed.currentPage) || fallback.currentPage),
    };
  } catch {
    return fallback;
  }
};

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

const getRoomImages = (room: LooseRoom) => {
  const raw = room?.anhList || room?.anhPhong || room?.hinhAnh || [];
  const list = Array.isArray(raw) ? raw : [];
  const urls = list
    .map((item) => {
      if (typeof item === "string") return item;
      const image = typeof item === "object" && item !== null ? item as Record<string, unknown> : {};
      return image.url || image.hinhAnh || "";
    })
    .filter(Boolean);

  if (room?.anhDaiDien && !urls.includes(room.anhDaiDien)) {
    return [room.anhDaiDien, ...urls];
  }

  return urls;
};

const normalizeAmenities = (room: LooseRoom) => {
  const raw = room?.tienIchNoiBat || room?.tienIchList || room?.tienNghi || room?.tienIch || [];
  const list = Array.isArray(raw) ? raw : String(raw).split(",");
  return list.map((item) => String(item).trim()).filter(Boolean).slice(0, 4);
};

const getRoomName = (room: LooseRoom, index: number) => {
  const rawName = room?.ten || room?.maPhong || room?.soPhong || room?.name;
  if (!rawName) return `Phòng đang cập nhật ${index + 1}`;
  const name = String(rawName).trim();
  return /^phòng/i.test(name) ? name : `Phòng ${name}`;
};

const getRoomLocation = (room: LooseRoom) => {
  if (room?.diaChiNhaTro) return room.diaChiNhaTro;
  if (room?.tenNhaTro) return room.tenNhaTro;
  if (room?.nhaTro?.tenNhaTro) return room.nhaTro.tenNhaTro;
  if (room?.toaNha?.tenToaNha) return room.toaNha.tenToaNha;
  if (typeof room?.toaNha?.diaChi === "string") return room.toaNha.diaChi;
  if (room?.khuVuc) return room.khuVuc;
  if (room?.location) return room.location;
  return "Đang cập nhật";
};

const mapRoom = (room: LooseRoom, index: number): RoomCard => {
  const priceValue = parseNumber(room?.giaHienTai || room?.giaThue || room?.price);
  const areaValue = parseNumber(room?.dienTich || room?.area);
  const images = getRoomImages(room);

  return {
    id: room?._id || room?.id || index,
    name: getRoomName(room, index),
    location: getRoomLocation(room),
    priceValue,
    priceLabel: formatCurrency(priceValue),
    areaValue,
    areaLabel: areaValue ? `${areaValue}m2` : "Đang cập nhật",
    amenities: normalizeAmenities(room),
    image: images[0],
    images,
    description: room?.moTa || room?.description || room?.mo_ta || "Đang cập nhật",
    status: room?.trangThai,
    maxPeople: parseNumber(room?.soNguoiToiDa),
  };
};

const amenityIcon = (amenity: string) => {
  const value = amenity.toLowerCase();
  if (value.includes("wifi")) return <Wifi size={13} />;
  if (value.includes("điều hòa") || value.includes("máy lạnh") || value.includes("ac")) return <Wind size={13} />;
  if (value.includes("xe") || value.includes("parking")) return <Car size={13} />;
  return <Sparkles size={13} />;
};

const getVisiblePages = (currentPage: number, totalPages: number) => {
  const windowSize = 7;
  if (totalPages <= windowSize) return Array.from({ length: totalPages }, (_, i) => i + 1);

  let start = Math.max(1, currentPage - 3);
  let end = Math.min(totalPages, currentPage + 3);

  if (start === 1) end = Math.min(totalPages, windowSize);
  if (end === totalPages) start = Math.max(1, totalPages - windowSize + 1);

  const pages = [];
  for (let p = start; p <= end; p++) pages.push(p);
  return pages;
};

const isAvailable = (status?: string) => {
  const normalized = String(status || "").toLowerCase();
  return !status || ["available", "trong", "vacant"].includes(normalized);
};

function RoomImage({
  src,
  alt,
  className = "",
  children,
}: {
  src?: string;
  alt: string;
  className?: string;
  children?: ReactNode;
}) {
  return (
    <div className={`relative overflow-hidden bg-[#EDE5D9] ${className}`}>
      {src ? (
        <img src={src} alt={alt} className="h-full w-full object-cover transition duration-700 group-hover:scale-105" />
      ) : (
        <div className="flex h-full w-full items-center justify-center bg-gradient-to-br from-[#F8F3EC] via-white to-[#DCEFEB]">
          <div className="flex h-16 w-16 items-center justify-center rounded-2xl bg-white/80 text-[#243B5A] shadow-sm ring-1 ring-[#E3D8CA]">
            <Building2 size={30} />
          </div>
        </div>
      )}
      {children}
    </div>
  );
}

function StatusBadge({ status }: { status?: string }) {
  const available = isAvailable(status);
  return (
    <span
      className={`inline-flex items-center rounded-full px-3 py-1 text-xs font-extrabold shadow-sm ring-1 ${
        available
          ? "bg-[#4FA7A0]/15 text-[#1E7770] ring-[#4FA7A0]/25"
          : "bg-[#243B5A]/90 text-white ring-white/15"
      }`}
    >
      {available ? "Còn phòng" : "Đang cập nhật"}
    </span>
  );
}

function RoomCardView({
  room,
  saved,
  onSelect,
  onSave,
  featured = false,
}: {
  room: RoomCard;
  saved: boolean;
  onSelect: () => void;
  onSave: (event: MouseEvent) => void;
  featured?: boolean;
}) {
  return (
    <article
      onClick={onSelect}
      className={`group cursor-pointer overflow-hidden rounded-2xl bg-white text-left shadow-[0_8px_28px_rgba(36,59,90,0.08)] ring-1 ring-[#E8DED1] transition hover:-translate-y-1 hover:shadow-[0_16px_38px_rgba(36,59,90,0.13)] ${
        featured ? "min-w-[310px] snap-start md:min-w-[390px]" : ""
      }`}
    >
      <RoomImage src={room.image} alt={room.name} className={featured ? "h-64" : "h-56"}>
        <div className="absolute inset-0 bg-gradient-to-t from-[#243B5A]/50 via-transparent to-transparent opacity-80" />
        <div className="absolute left-4 top-4">
          <StatusBadge status={room.status} />
        </div>
        <button
          onClick={onSave}
          className="absolute right-4 top-4 flex h-10 w-10 items-center justify-center rounded-full bg-white/95 text-[#243B5A] shadow-sm transition hover:text-[#F2A45B]"
          title="Lưu phòng"
        >
          <Heart size={18} className={saved ? "fill-[#F2A45B] text-[#F2A45B]" : ""} />
        </button>
        {featured && (
          <span className="absolute bottom-4 left-4 rounded-full bg-[#F2A45B] px-3 py-1 text-xs font-extrabold text-white shadow-sm">
            Nổi bật
          </span>
        )}
      </RoomImage>

      <div className="p-5">
        <div className="flex items-start justify-between gap-4">
          <div className="min-w-0">
            <h3 className="line-clamp-1 text-lg font-black tracking-tight text-[#243B5A]">{room.name}</h3>
            <p className="mt-2 flex items-center gap-1.5 text-sm font-medium text-[#6B7A8C]">
              <MapPin size={15} className="shrink-0 text-[#4FA7A0]" />
              <span className="line-clamp-1">{room.location}</span>
            </p>
          </div>
          <p className="shrink-0 text-right text-lg font-black text-[#F2A45B]">{room.priceLabel}</p>
        </div>

        <p className="mt-4 line-clamp-2 min-h-[44px] text-sm leading-6 text-[#6B7A8C]">{room.description}</p>

        <div className="mt-4 flex flex-wrap gap-2">
          <span className="inline-flex items-center gap-1 rounded-full bg-[#F8F3EC] px-3 py-1.5 text-xs font-bold text-[#243B5A]">
            <Square size={13} /> {room.areaLabel}
          </span>
          {room.maxPeople ? (
            <span className="inline-flex items-center gap-1 rounded-full bg-[#F8F3EC] px-3 py-1.5 text-xs font-bold text-[#243B5A]">
              {room.maxPeople} người
            </span>
          ) : null}
          {room.amenities.slice(0, featured ? 2 : 3).map((amenity) => (
            <span key={`${room.id}-${amenity}`} className="inline-flex items-center gap-1 rounded-full bg-[#4FA7A0]/10 px-3 py-1.5 text-xs font-bold text-[#267D76]">
              {amenityIcon(amenity)}
              {amenity}
            </span>
          ))}
        </div>
      </div>
    </article>
  );
}

export function HomeScreen({ onRoomSelect, onTabChange }: HomeScreenProps) {
  const { data: session } = useSession();
  const userId = session?.user?.id;
  const initialViewState = useMemo(() => getInitialHomeViewState(), []);
  const didMountViewState = useRef(false);
  const [userProfile, setUserProfile] = useState<LooseRoom | null>(null);
  const [allRooms, setAllRooms] = useState<RoomCard[]>([]);
  const [isFilterOpen, setIsFilterOpen] = useState(false);
  const [filterPrice, setFilterPrice] = useState(initialViewState.filterPrice);
  const [filterArea, setFilterArea] = useState(initialViewState.filterArea);
  const [searchQuery, setSearchQuery] = useState(initialViewState.searchQuery);
  const [currentPage, setCurrentPage] = useState(initialViewState.currentPage);
  const [savedRooms, setSavedRooms] = useState<Set<RoomId>>(new Set());

  const getStorageKey = (uid?: string) => {
    return uid ? `easyhouse_saved_rooms_${uid}` : "easyhouse_saved_rooms";
  };

  useEffect(() => {
    const key = getStorageKey(userId);
    const saved = localStorage.getItem(key);
    if (saved) {
      try {
        const parsed = JSON.parse(saved);
        const parsedRooms = Array.isArray(parsed) ? parsed : [];
        setSavedRooms(new Set(parsedRooms.map((room) => String((room as LooseRoom).id || ""))));
      } catch (error) {
        console.error(error);
      }
    } else {
      setSavedRooms(new Set());
    }
  }, [userId]);

  useEffect(() => {
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

  const featuredRooms = useMemo(() => filteredRooms.slice(0, 5), [filteredRooms]);

  const listSource = useMemo(() => filteredRooms.slice(featuredRooms.length), [filteredRooms, featuredRooms.length]);
  const totalPages = Math.max(1, Math.ceil(listSource.length / ROOMS_PER_PAGE));
  const paginatedRooms = useMemo(() => {
    const start = (currentPage - 1) * ROOMS_PER_PAGE;
    return listSource.slice(start, start + ROOMS_PER_PAGE);
  }, [currentPage, listSource]);
  const visiblePages = useMemo(() => getVisiblePages(currentPage, totalPages), [currentPage, totalPages]);
  const showingFrom = filteredRooms.length === 0 ? 0 : featuredRooms.length + ((currentPage - 1) * ROOMS_PER_PAGE + 1);
  const showingTo = filteredRooms.length === 0 ? 0 : featuredRooms.length + Math.min(currentPage * ROOMS_PER_PAGE, listSource.length);
  const savedCount = savedRooms.size;
  const currentUserName = userProfile?.name || userProfile?.hoTen || "Khách thuê";
  const selectedPriceLabel = PRICE_RANGES.find((item) => item.id === filterPrice)?.shortLabel || "Giá";
  const selectedAreaLabel = AREA_RANGES.find((item) => item.id === filterArea)?.shortLabel || "Diện tích";

  const resetFilters = () => {
    setFilterPrice("all");
    setFilterArea("all");
    setSearchQuery("");
    setCurrentPage(1);
  };

  const changePage = (page: number) => {
    setCurrentPage(Math.min(Math.max(page, 1), totalPages));
  };

  useEffect(() => {
    if (!didMountViewState.current) {
      didMountViewState.current = true;
      return;
    }

    setCurrentPage(1);
  }, [filterArea, filterPrice, searchQuery]);

  useEffect(() => {
    if (currentPage > totalPages) {
      setCurrentPage(totalPages);
    }
  }, [currentPage, totalPages]);

  useEffect(() => {
    window.sessionStorage.setItem(
      HOME_VIEW_STATE_KEY,
      JSON.stringify({ filterPrice, filterArea, searchQuery, currentPage })
    );
  }, [currentPage, filterArea, filterPrice, searchQuery]);

  const toggleSave = (room: RoomCard, event: MouseEvent) => {
    event.stopPropagation();
    const key = getStorageKey(userId);
    const saved = localStorage.getItem(key);
    let currentSaved: RoomCard[] = saved ? JSON.parse(saved) : [];
    const exists = currentSaved.some((item) => item.id === room.id);

    if (exists) {
      currentSaved = currentSaved.filter((item) => item.id !== room.id);
    } else {
      currentSaved.push(room);
    }

    localStorage.setItem(key, JSON.stringify(currentSaved));
    setSavedRooms(new Set(currentSaved.map((item) => item.id)));
  };

  const heroRoom = featuredRooms[0];

  return (
    <div className="flex h-full min-h-0 flex-col overflow-y-auto bg-[#F8F3EC] text-[#243B5A]">
      <header className="sticky top-0 z-30 border-b border-[#E8DED1] bg-[#F8F3EC]/90 px-4 pb-3 pt-4 shadow-sm backdrop-blur md:px-8">
        <div className="mx-auto flex w-full max-w-screen-2xl items-center justify-between gap-3">
          <button onClick={resetFilters} className="flex min-w-0 items-center gap-2 text-left" title="Về trang chủ">
            <span className="flex h-11 w-11 items-center justify-center rounded-2xl bg-[#243B5A] text-white shadow-sm">
              <Home size={21} />
            </span>
            <span className="min-w-0">
              <span className="block text-lg font-black leading-tight tracking-tight text-[#243B5A]">EasyHouse</span>
              <span className="block truncate text-[11px] font-semibold text-[#4FA7A0]">Tìm phòng minh bạch, nhanh gọn</span>
            </span>
          </button>

          <nav className="hidden items-center gap-7 text-sm font-bold text-[#243B5A]/70 md:flex">
            <button
              onClick={() => document.getElementById("featured-rooms")?.scrollIntoView({ behavior: "smooth" })}
              className="transition hover:text-[#4FA7A0]"
            >
              Phòng nổi bật
            </button>
            <button
              onClick={() => document.getElementById("room-list")?.scrollIntoView({ behavior: "smooth" })}
              className="transition hover:text-[#4FA7A0]"
            >
              Danh sách phòng
            </button>
            <Link href="/dieu-khoan-dich-vu" className="transition hover:text-[#4FA7A0]">
              Chính sách
            </Link>
          </nav>

          <div className="flex items-center gap-2">
            <button
              onClick={() => onTabChange?.("saved")}
              className="relative flex h-10 w-10 items-center justify-center rounded-full border border-[#E8DED1] bg-white text-[#243B5A] shadow-sm transition hover:border-[#4FA7A0] hover:text-[#4FA7A0]"
              title="Tin đã lưu"
            >
              <Heart size={18} />
              {savedCount > 0 && (
                <span className="absolute -right-1 -top-1 min-w-5 rounded-full bg-[#F2A45B] px-1.5 text-center text-[10px] font-bold text-white">
                  {savedCount}
                </span>
              )}
            </button>
            <button className="hidden h-10 w-10 items-center justify-center rounded-full border border-[#E8DED1] bg-white text-[#243B5A] shadow-sm md:flex" title="Thông báo">
              <Bell size={18} />
            </button>
            {userProfile ? (
              <button onClick={() => onTabChange?.("profile")} className="flex items-center gap-2 rounded-full border border-[#E8DED1] bg-white p-1.5 pr-3 shadow-sm">
                <span className="flex h-8 w-8 items-center justify-center rounded-full bg-[#4FA7A0] text-xs font-black text-white">
                  {String(currentUserName).slice(0, 1).toUpperCase()}
                </span>
                <span className="hidden max-w-28 truncate text-sm font-semibold text-[#243B5A] sm:block">{currentUserName}</span>
              </button>
            ) : (
              <Link href="/dang-nhap" className="flex h-10 items-center gap-2 rounded-full bg-[#243B5A] px-4 text-sm font-bold text-white shadow-sm transition hover:bg-[#1b2e47]">
                <LogIn size={16} />
                <span className="hidden sm:inline">Đăng nhập</span>
              </Link>
            )}
          </div>
        </div>

        <div className="mx-auto mt-4 flex w-full max-w-screen-2xl gap-2">
          <div className="flex min-w-0 flex-1 items-center gap-2 rounded-2xl border border-[#E8DED1] bg-white px-4 py-3 transition focus-within:border-[#4FA7A0] focus-within:ring-4 focus-within:ring-[#4FA7A0]/15">
            <Search size={18} className="shrink-0 text-[#4FA7A0]" />
            <input
              value={searchQuery}
              onChange={(event) => setSearchQuery(event.target.value)}
              placeholder="Tìm khu vực, tên phòng..."
              className="w-full bg-transparent text-sm font-semibold text-[#243B5A] outline-none placeholder:text-[#6B7A8C]"
            />
          </div>
          <button
            onClick={() => setIsFilterOpen(true)}
            className="flex h-[50px] items-center gap-2 rounded-2xl border border-[#E8DED1] bg-white px-4 text-sm font-black text-[#243B5A] shadow-sm transition hover:border-[#4FA7A0] hover:text-[#4FA7A0]"
          >
            <SlidersHorizontal size={18} />
            <span className="hidden sm:inline">Bộ lọc</span>
          </button>
        </div>
      </header>

      <main className="mx-auto w-full max-w-screen-2xl flex-1 px-4 py-6 md:px-8 md:py-9">
        <section className="grid items-center gap-8 lg:grid-cols-[0.9fr_1.1fr]">
          <div className="relative z-10">
            <span className="inline-flex items-center gap-2 rounded-full bg-white px-4 py-2 text-xs font-black uppercase tracking-wide text-[#4FA7A0] shadow-sm ring-1 ring-[#E8DED1]">
              <ShieldCheck size={15} />
              Dữ liệu phòng từ hệ thống EasyHouse
            </span>
            <h1 className="mt-5 max-w-2xl text-4xl font-black leading-tight tracking-tight text-[#243B5A] sm:text-5xl">
              Tìm phòng phù hợp ngân sách trong vài thao tác
            </h1>
            <p className="mt-4 max-w-xl text-base leading-7 text-[#243B5A]/70">
              Lọc theo giá, diện tích và vị trí. Lưu phòng quan tâm để so sánh trước khi liên hệ.
            </p>
            <div className="mt-6 flex flex-col gap-3 sm:flex-row">
              <button
                onClick={() => document.getElementById("room-list")?.scrollIntoView({ behavior: "smooth" })}
                className="inline-flex items-center justify-center gap-2 rounded-2xl bg-[#F2A45B] px-6 py-4 text-sm font-black text-white shadow-[0_12px_24px_rgba(242,164,91,0.25)] transition hover:-translate-y-0.5 hover:bg-[#e89447]"
              >
                Khám phá ngay
                <ArrowRight size={18} />
              </button>
              <button
                onClick={() => setIsFilterOpen(true)}
                className="inline-flex items-center justify-center gap-2 rounded-2xl border border-[#E8DED1] bg-white px-6 py-4 text-sm font-black text-[#243B5A] shadow-sm transition hover:border-[#4FA7A0]"
              >
                <SlidersHorizontal size={18} />
                Lọc phòng
              </button>
            </div>

            <div className="mt-8 grid grid-cols-3 gap-3">
              <div className="rounded-2xl bg-white p-4 shadow-sm ring-1 ring-[#E8DED1]">
                <p className="text-2xl font-black text-[#243B5A]">{allRooms.length}</p>
                <p className="mt-1 text-xs font-semibold text-[#243B5A]/60">Phòng đang đăng</p>
              </div>
              <div className="rounded-2xl bg-white p-4 shadow-sm ring-1 ring-[#E8DED1]">
                <p className="text-2xl font-black text-[#243B5A]">{filteredRooms.length}</p>
                <p className="mt-1 text-xs font-semibold text-[#243B5A]/60">Kết quả phù hợp</p>
              </div>
              <div className="rounded-2xl bg-white p-4 shadow-sm ring-1 ring-[#E8DED1]">
                <p className="text-2xl font-black text-[#243B5A]">{savedCount}</p>
                <p className="mt-1 text-xs font-semibold text-[#243B5A]/60">Tin đã lưu</p>
              </div>
            </div>
          </div>

          <div className="relative">
            <RoomImage src={heroRoom?.image} alt={heroRoom?.name || "Phòng EasyHouse"} className="group aspect-[4/3] rounded-2xl shadow-[0_22px_48px_rgba(36,59,90,0.18)]">
              <div className="absolute inset-0 bg-gradient-to-t from-[#243B5A]/70 via-transparent to-transparent" />
              {heroRoom ? (
                <button
                  onClick={() => onRoomSelect(heroRoom.id)}
                  className="absolute bottom-5 left-5 right-5 rounded-2xl bg-white/95 p-4 text-left shadow-xl backdrop-blur transition hover:scale-[1.01] md:left-auto md:w-80"
                >
                  <p className="text-xs font-black uppercase tracking-wide text-[#F2A45B]">Gợi ý hôm nay</p>
                  <p className="mt-1 line-clamp-1 text-lg font-black text-[#243B5A]">{heroRoom.name}</p>
                  <p className="mt-1 text-sm font-black text-[#F2A45B]">{heroRoom.priceLabel}</p>
                </button>
              ) : null}
            </RoomImage>
          </div>
        </section>

        {featuredRooms.length > 0 && (
          <section id="featured-rooms" className="mt-12">
            <div className="mb-5 flex items-end justify-between gap-3">
              <div>
                <h2 className="text-2xl font-black tracking-tight text-[#243B5A]">Phòng nổi bật</h2>
                <p className="mt-1 text-sm font-semibold text-[#243B5A]/60">Lấy trực tiếp từ danh sách phòng hiện có</p>
              </div>
              <button
                onClick={() => document.getElementById("room-list")?.scrollIntoView({ behavior: "smooth" })}
                className="hidden items-center gap-1 text-sm font-black text-[#F2A45B] sm:flex"
              >
                Xem tất cả <ChevronRight size={17} />
              </button>
            </div>
            <div className="scrollbar-none flex snap-x gap-5 overflow-x-auto pb-3">
              {featuredRooms.map((room) => (
                <RoomCardView
                  key={room.id}
                  room={room}
                  saved={savedRooms.has(room.id)}
                  featured
                  onSelect={() => onRoomSelect(room.id)}
                  onSave={(event) => toggleSave(room, event)}
                />
              ))}
            </div>
          </section>
        )}

        <section className="mt-12">
          <div className="mb-5 flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
            <div>
              <h2 className="text-2xl font-black tracking-tight text-[#243B5A]">Danh sách phòng</h2>
              <p className="mt-1 text-sm font-semibold text-[#243B5A]/60">
                {filteredRooms.length === 0 ? "0 kết quả đang hiển thị" : `Hiển thị ${showingFrom}-${showingTo} trong ${filteredRooms.length} kết quả`}
              </p>
            </div>
            <div className="flex flex-wrap items-center gap-2">
              <span className="rounded-full bg-white px-4 py-2 text-xs font-black text-[#243B5A] ring-1 ring-[#E8DED1]">{selectedPriceLabel}</span>
              <span className="rounded-full bg-white px-4 py-2 text-xs font-black text-[#243B5A] ring-1 ring-[#E8DED1]">{selectedAreaLabel}</span>
              <Link href="/dang-ky" className="hidden items-center gap-2 rounded-full bg-[#243B5A] px-4 py-2 text-sm font-bold text-white shadow-sm sm:flex">
                <UserPlus size={16} /> Đăng tin
              </Link>
            </div>
          </div>

          {filteredRooms.length === 0 ? (
            <div className="rounded-2xl border border-dashed border-[#D8CBBA] bg-white p-8 text-center shadow-sm">
              <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-[#F8F3EC] text-[#243B5A]">
                <Search size={24} />
              </div>
              <h3 className="mt-4 text-lg font-black text-[#243B5A]">Chưa có phòng phù hợp</h3>
              <p className="mt-1 text-sm text-[#243B5A]/60">Thử bỏ bớt điều kiện lọc hoặc tìm bằng khu vực khác.</p>
              <button onClick={resetFilters} className="mt-4 rounded-2xl bg-[#4FA7A0] px-4 py-2.5 text-sm font-bold text-white shadow-sm">
                Xóa bộ lọc
              </button>
            </div>
          ) : (
            <>
              <div id="room-list" className="grid grid-cols-1 gap-5 md:grid-cols-2 xl:grid-cols-3">
                {paginatedRooms.map((room) => (
                  <RoomCardView
                    key={room.id}
                    room={room}
                    saved={savedRooms.has(room.id)}
                    onSelect={() => onRoomSelect(room.id)}
                    onSave={(event) => toggleSave(room, event)}
                  />
                ))}
              </div>
              {totalPages > 1 && (
                <nav className="mt-7 flex flex-col items-center justify-between gap-3 rounded-2xl bg-white p-3 shadow-sm ring-1 ring-[#E8DED1] sm:flex-row" aria-label="Phân trang danh sách phòng">
                  <p className="text-xs font-bold text-[#243B5A]/60">
                    Trang {currentPage}/{totalPages} - tối đa {ROOMS_PER_PAGE} phòng mỗi trang
                  </p>
                  <div className="flex flex-wrap items-center justify-center gap-1">
                    <button
                      onClick={() => changePage(currentPage - 1)}
                      disabled={currentPage === 1}
                      className="flex h-10 min-w-10 items-center justify-center rounded-xl border border-[#E8DED1] bg-white px-3 text-sm font-black text-[#243B5A] transition hover:border-[#4FA7A0] hover:text-[#4FA7A0] disabled:cursor-not-allowed disabled:opacity-40"
                      aria-label="Trang trước"
                    >
                      <ChevronLeft size={16} />
                    </button>
                    {visiblePages.map((page, index) => {
                      const previousPage = visiblePages[index - 1];
                      const needsSeparator = previousPage && page - previousPage > 1;

                      return (
                        <span key={page} className="flex items-center gap-1">
                          {needsSeparator && <span className="px-1 text-sm font-bold text-[#6B7A8C]">...</span>}
                          <button
                            onClick={() => changePage(page)}
                            className={`h-10 min-w-10 rounded-xl px-3 text-sm font-black transition ${
                              currentPage === page
                                ? "bg-[#4FA7A0] text-white shadow-sm"
                                : "border border-[#E8DED1] bg-white text-[#243B5A] hover:border-[#4FA7A0] hover:text-[#4FA7A0]"
                            }`}
                            aria-current={currentPage === page ? "page" : undefined}
                          >
                            {page}
                          </button>
                        </span>
                      );
                    })}
                    <button
                      onClick={() => changePage(currentPage + 1)}
                      disabled={currentPage === totalPages}
                      className="flex h-10 min-w-10 items-center justify-center rounded-xl border border-[#E8DED1] bg-white px-3 text-sm font-black text-[#243B5A] transition hover:border-[#4FA7A0] hover:text-[#4FA7A0] disabled:cursor-not-allowed disabled:opacity-40"
                      aria-label="Trang sau"
                    >
                      <ChevronRight size={16} />
                    </button>
                  </div>
                </nav>
              )}
            </>
          )}
        </section>
      </main>

      <footer className="mt-8 bg-[#243B5A] px-4 py-9 text-white md:px-8">
        <div className="mx-auto grid w-full max-w-screen-2xl gap-7 md:grid-cols-[1.4fr_0.8fr_0.8fr]">
          <div>
            <div className="flex items-center gap-3">
              <span className="flex h-11 w-11 items-center justify-center rounded-2xl bg-[#F2A45B] font-black text-white">EH</span>
              <div>
                <p className="text-xl font-black">EasyHouse</p>
                <p className="text-sm text-white/65">Nền tảng tìm và quản lý phòng trọ</p>
              </div>
            </div>
            <p className="mt-4 max-w-md text-sm leading-6 text-white/70">
              Hỗ trợ chủ trọ đăng phòng minh bạch và giúp khách thuê tìm được nơi ở phù hợp hơn.
            </p>
          </div>

          <div>
            <p className="font-bold">Liên kết</p>
            <nav className="mt-3 flex flex-col gap-2 text-sm text-white/70">
              <Link href="/xem-phong" className="hover:text-white">Tìm phòng</Link>
              <Link href="/dang-ky" className="hover:text-white">Đăng ký</Link>
              <Link href="/dang-nhap" className="hover:text-white">Đăng nhập</Link>
            </nav>
          </div>

          <div>
            <p className="font-bold">Chính sách</p>
            <nav className="mt-3 flex flex-col gap-2 text-sm text-white/70">
              <Link href="/chinh-sach-bao-mat" className="hover:text-white">Chính sách bảo mật</Link>
              <Link href="/dieu-khoan-dich-vu" className="hover:text-white">Điều khoản dịch vụ</Link>
              <Link href="/quy-che-hoat-dong" className="hover:text-white">Quy chế hoạt động</Link>
            </nav>
          </div>
        </div>
        <div className="mx-auto mt-7 max-w-screen-2xl border-t border-white/10 pt-4 text-xs text-white/55">
          © EasyHouse. Bản quyền thuộc về EasyHouse.
        </div>
      </footer>

      {isFilterOpen && (
        <div className="fixed inset-0 z-50 flex items-end justify-center bg-[#243B5A]/60 backdrop-blur-sm md:items-center">
          <div className="flex max-h-[90vh] w-full flex-col overflow-hidden rounded-t-2xl bg-white shadow-2xl md:max-w-lg md:rounded-2xl">
            <div className="flex items-center justify-between border-b border-[#E8DED1] px-5 py-4">
              <div>
                <h2 className="text-lg font-black text-[#243B5A]">Bộ lọc tìm phòng</h2>
                <p className="text-xs font-semibold text-[#243B5A]/60">Chọn điều kiện phù hợp nhu cầu</p>
              </div>
              <button onClick={() => setIsFilterOpen(false)} className="flex h-10 w-10 items-center justify-center rounded-full bg-[#F8F3EC] text-[#243B5A]">
                <X size={18} />
              </button>
            </div>

            <div className="flex-1 space-y-6 overflow-y-auto px-5 py-5">
              <div>
                <p className="mb-3 text-sm font-black text-[#243B5A]">Khoảng giá</p>
                <div className="grid grid-cols-2 gap-2">
                  {PRICE_RANGES.map((price) => (
                    <button
                      key={price.id}
                      onClick={() => setFilterPrice(price.id)}
                      className={`rounded-2xl border px-3 py-3 text-sm font-bold transition ${
                        filterPrice === price.id
                          ? "border-[#4FA7A0] bg-[#4FA7A0]/10 text-[#267D76]"
                          : "border-[#E8DED1] bg-white text-[#243B5A]/70"
                      }`}
                    >
                      {price.label}
                    </button>
                  ))}
                </div>
              </div>

              <div>
                <p className="mb-3 text-sm font-black text-[#243B5A]">Diện tích</p>
                <div className="grid grid-cols-2 gap-2">
                  {AREA_RANGES.map((area) => (
                    <button
                      key={area.id}
                      onClick={() => setFilterArea(area.id)}
                      className={`rounded-2xl border px-3 py-3 text-sm font-bold transition ${
                        filterArea === area.id
                          ? "border-[#4FA7A0] bg-[#4FA7A0]/10 text-[#267D76]"
                          : "border-[#E8DED1] bg-white text-[#243B5A]/70"
                      }`}
                    >
                      {area.label}
                    </button>
                  ))}
                </div>
              </div>
            </div>

            <div className="grid grid-cols-[0.8fr_1.2fr] gap-3 border-t border-[#E8DED1] bg-[#F8F3EC] px-5 py-4">
              <button onClick={resetFilters} className="rounded-2xl border border-[#E8DED1] bg-white px-4 py-3 text-sm font-black text-[#243B5A]">
                Đặt lại
              </button>
              <button onClick={() => setIsFilterOpen(false)} className="rounded-2xl bg-[#4FA7A0] px-4 py-3 text-sm font-black text-white shadow-lg shadow-[#4FA7A0]/15">
                Hiển thị {filteredRooms.length} kết quả
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
