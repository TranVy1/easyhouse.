"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import type { MouseEvent, ReactNode } from "react";
import Link from "next/link";
import { useSession } from "next-auth/react";
import {
  ArrowRight,
  Bell,
  Building2,
  ChevronLeft,
  ChevronRight,
  ChevronDown,
  Heart,
  Home,
  LogIn,
  Search,
  ShieldCheck,
  SlidersHorizontal,
  UserPlus,
  X,
  BadgeCheck,
  Headphones,
  Layers3,
  MapPinned,
} from "lucide-react";

import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { LocateFixed } from "lucide-react";
import { PropertyCard, PropertyCardSkeleton } from "@/components/property/property-card";
import {
  CountUp,
  ParallaxLayer,
  StaggerGroup,
  StaggerItem,
  motion,
} from "@/components/motion";

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

const ROOMS_PER_PAGE = 8;
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
    id: (room?._id || room?.id || index) as RoomId,
    name: String(getRoomName(room, index)),
    location: String(getRoomLocation(room)),
    priceValue,
    priceLabel: formatCurrency(priceValue),
    areaValue,
    areaLabel: areaValue ? `${areaValue}m2` : "Đang cập nhật",
    amenities: normalizeAmenities(room),
    image: images[0] as string | undefined,
    images: images as string[],
    description: String(room?.moTa || room?.description || room?.mo_ta || "Đang cập nhật"),
    status: room?.trangThai as string | undefined,
    maxPeople: parseNumber(room?.soNguoiToiDa),
  };
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

const TRUST_ITEMS = [
  {
    icon: <BadgeCheck size={22} />,
    title: "Thông tin minh bạch",
    description: "Giá, diện tích và trạng thái phòng được hiển thị rõ ràng từ dữ liệu hệ thống.",
  },
  {
    icon: <Layers3 size={22} />,
    title: "Dễ so sánh phòng",
    description: "Card phòng được chuẩn hóa để bạn quét nhanh giá, tiện ích và vị trí.",
  },
  {
    icon: <MapPinned size={22} />,
    title: "Dữ liệu cập nhật",
    description: "Danh sách phòng lấy trực tiếp từ EasyHouse, không tự bịa dữ liệu động.",
  },
  {
    icon: <Headphones size={22} />,
    title: "Hỗ trợ nhanh",
    description: "Luồng tìm kiếm, lưu phòng và xem chi tiết luôn sẵn sàng khi bạn cần.",
  },
];

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
        <img src={src} alt={alt} className="h-full w-full object-cover transition duration-300 ease-out group-hover:scale-[1.03] motion-reduce:transition-none motion-reduce:group-hover:scale-100" />
      ) : (
        <div className="flex h-full w-full items-center justify-center bg-gradient-to-br from-[#F8F3EC] via-white to-[#DCEFEB]">
          <div className="flex flex-col items-center gap-3 text-center">
            <div className="flex h-16 w-16 items-center justify-center rounded-2xl bg-white/85 text-[#243B5A] shadow-sm ring-1 ring-[#E3D8CA]">
              <Building2 size={30} />
            </div>
            <span className="rounded-full bg-white/80 px-3 py-1 text-xs font-bold text-[#6B7A8C] ring-1 ring-[#E8DED1]">
              Chưa có ảnh
            </span>
          </div>
        </div>
      )}
      {children}
    </div>
  );
}

/**
 * Adapter mong noi du lieu RoomCard cua HomeScreen voi <PropertyCard>
 * (the kieu Airbnb: carousel anh trong the, hover nang, tim spring).
 */
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
  const available = isAvailable(room.status);

  return (
    <PropertyCard
      room={{
        id: room.id,
        name: room.name,
        location: room.location,
        priceLabel: room.priceLabel,
        areaLabel: room.areaLabel,
        description: room.description,
        images: room.images,
        amenities: room.amenities,
        badge: featured
          ? { label: "Nổi bật", tone: "orange" }
          : { label: available ? "Còn phòng" : "Đang cập nhật", tone: available ? "teal" : "navy" },
        meta: room.maxPeople ? (
          <span className="rounded-full bg-[#F8F3EC] px-2.5 py-1 text-[#243B5A]">
            {room.maxPeople} người
          </span>
        ) : null,
      }}
      saved={saved}
      onSelect={onSelect}
      onToggleSave={onSave}
      aspect={featured ? "aspect-[4/3]" : "aspect-[4/3]"}
      className="eh-shadow-float eh-shadow-float-hover h-full"
    />
  );
}

export function HomeScreen({ onRoomSelect, onTabChange }: HomeScreenProps) {
  const { data: session } = useSession();
  const userId = session?.user?.id;
  const didMountViewState = useRef(false);
  const [userProfile, setUserProfile] = useState<LooseRoom | null>(null);
  const [allRooms, setAllRooms] = useState<RoomCard[]>([]);
  const [loadingRooms, setLoadingRooms] = useState(true);
  const [isFilterOpen, setIsFilterOpen] = useState(false);
  const [filterPrice, setFilterPrice] = useState("all");
  const [filterArea, setFilterArea] = useState("all");
  const [searchQuery, setSearchQuery] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [toaNhaList, setToaNhaList] = useState<any[]>([]);
  const [minGia, setMinGia] = useState('');
  const [maxGia, setMaxGia] = useState('');
  const [minDienTich, setMinDienTich] = useState('');
  const [selectedToaNha, setSelectedToaNha] = useState('all');
  const [radiusKm, setRadiusKm] = useState('5');

  // Hydration fix: load state from sessionStorage after initial render
  useEffect(() => {
    const state = getInitialHomeViewState();
    setFilterPrice(state.filterPrice);
    setFilterArea(state.filterArea);
    setSearchQuery(state.searchQuery);
    setCurrentPage(state.currentPage);
  }, []);
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


    fetch("/api/public/phong?limit=1000")
      .then(async (res) => {
        const text = await res.text();
        if (!res.ok) throw new Error(`HTTP error! status: ${res.status}`);
        try {
          return text ? JSON.parse(text) : {};
        } catch {
          throw new Error("Invalid JSON in phong response: " + text.slice(0, 50));
        }
      })
      .then((data) => {
        const rooms = Array.isArray(data) ? data : data?.data?.data || data?.data?.content || data?.data || [];
        setAllRooms(Array.isArray(rooms) ? rooms.map(mapRoom) : []);
      })
      .catch((error) => console.error("API Fetch Error:", error.message || error))
      .finally(() => setLoadingRooms(false));
  }, []);

  useEffect(() => {
    fetch('/api/public/toa-nha')
      .then(res => res.json())
      .then(res => { if (res.success) setToaNhaList(res.data) })
      .catch(() => {});
  }, []);

  useEffect(() => {
    if (session?.user) {
      setUserProfile(session.user);
    } else {
      setUserProfile(null);
    }
  }, [session]);

  const filteredRooms = useMemo(() => {
    const price = PRICE_RANGES.find((item) => item.id === filterPrice) || PRICE_RANGES[0];
    const area = AREA_RANGES.find((item) => item.id === filterArea) || AREA_RANGES[0];
    const query = searchQuery.trim().toLowerCase();

    const minG = minGia ? Number(minGia) : 0;
    const maxG = maxGia ? Number(maxGia) : Infinity;
    const minD = minDienTich ? Number(minDienTich) : 0;

    return allRooms.filter((room) => {
      const text = `${room.name} ${room.location} ${room.description}`.toLowerCase();
      const matchQuery = !query || text.includes(query);
      const matchPrice = filterPrice === "all" || (room.priceValue >= price.min && room.priceValue <= price.max);
      const matchArea = filterArea === "all" || (room.areaValue >= area.min && room.areaValue <= area.max);
      
      const matchCustomPrice = room.priceValue >= minG && room.priceValue <= maxG;
      const matchCustomArea = room.areaValue >= minD;
      
      let matchToaNha = true;
      if (selectedToaNha && selectedToaNha !== 'all') {
         const toaNhaName = toaNhaList.find(t => t._id === selectedToaNha)?.tenToaNha;
         if (toaNhaName) {
            matchToaNha = room.location.toLowerCase().includes(toaNhaName.toLowerCase());
         }
      }

      return matchQuery && matchPrice && matchArea && matchCustomPrice && matchCustomArea && matchToaNha;
    });
  }, [allRooms, filterArea, filterPrice, searchQuery, minGia, maxGia, minDienTich, selectedToaNha, toaNhaList]);

  const featuredRooms = useMemo(() => filteredRooms.slice(0, 4), [filteredRooms]);

  const listSource = useMemo(() => filteredRooms.slice(featuredRooms.length), [filteredRooms, featuredRooms.length]);
  const totalPages = Math.max(1, Math.ceil(listSource.length / ROOMS_PER_PAGE));
  const paginatedRooms = useMemo(() => {
    return listSource.slice(0, currentPage * ROOMS_PER_PAGE);
  }, [currentPage, listSource]);
  
  const showingFrom = filteredRooms.length === 0 ? 0 : featuredRooms.length + 1;
  const showingTo = filteredRooms.length === 0 ? 0 : featuredRooms.length + paginatedRooms.length;
  const savedCount = savedRooms.size;
  const currentUserName = String(userProfile?.name || userProfile?.hoTen || "Khách thuê");
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

  const findNearbyRooms = () => {
    if (!navigator.geolocation) return;
    navigator.geolocation.getCurrentPosition((pos) => {
      window.location.href = `/xem-phong?viDo=${pos.coords.latitude}&kinhDo=${pos.coords.longitude}&radiusKm=${radiusKm}`;
    });
  };

  const heroRoom = featuredRooms[0];

  return (
    <div className="flex flex-col bg-[#F8F3EC] text-[#243B5A]">
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
        {/* Hero: nen aurora troi cham + noi dung bay vao tung lop */}
        <section className="relative grid items-center gap-8 overflow-hidden rounded-[32px] px-1 py-4 lg:grid-cols-[0.9fr_1.1fr] lg:px-6 lg:py-8">
          <div className="eh-aurora" aria-hidden="true" />

          <div className="relative z-10">
            <motion.span
              initial={{ opacity: 0, y: 16 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, ease: [0.16, 1, 0.3, 1] }}
              className="inline-flex items-center gap-2 rounded-full bg-white px-4 py-2 text-xs font-black uppercase tracking-wide text-[#4FA7A0] shadow-sm ring-1 ring-[#E8DED1]"
            >
              <ShieldCheck size={15} />
              Dữ liệu phòng từ hệ thống EasyHouse
            </motion.span>

            <motion.h1
              initial={{ opacity: 0, y: 24 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: 0.08, ease: [0.16, 1, 0.3, 1] }}
              className="mt-5 max-w-2xl text-4xl font-black leading-tight tracking-tight text-[#243B5A] sm:text-5xl"
            >
              Tìm phòng phù hợp ngân sách trong vài thao tác
            </motion.h1>

            <motion.p
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: 0.16, ease: [0.16, 1, 0.3, 1] }}
              className="mt-4 max-w-xl text-base leading-7 text-[#243B5A]/70"
            >
              Lọc theo giá, diện tích và vị trí. Lưu phòng quan tâm để so sánh trước khi liên hệ.
            </motion.p>

            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: 0.24, ease: [0.16, 1, 0.3, 1] }}
              className="mt-6 flex flex-col gap-3 sm:flex-row"
            >
              <motion.button
                onClick={() => document.getElementById("room-list")?.scrollIntoView({ behavior: "smooth" })}
                whileHover={{ scale: 1.03, y: -2 }}
                whileTap={{ scale: 0.97 }}
                transition={{ type: "spring", stiffness: 400, damping: 25 }}
                className="group inline-flex items-center justify-center gap-2 rounded-2xl bg-[#F2A45B] px-6 py-4 text-sm font-black text-white shadow-[0_12px_24px_rgba(242,164,91,0.25)]"
              >
                Khám phá ngay
                <ArrowRight size={18} className="transition-transform group-hover:translate-x-1" />
              </motion.button>
              <motion.button
                onClick={() => setIsFilterOpen(true)}
                whileHover={{ scale: 1.03, y: -2 }}
                whileTap={{ scale: 0.97 }}
                transition={{ type: "spring", stiffness: 400, damping: 25 }}
                className="inline-flex items-center justify-center gap-2 rounded-2xl border border-[#E8DED1] bg-white px-6 py-4 text-sm font-black text-[#243B5A] shadow-sm"
              >
                <SlidersHorizontal size={18} />
                Lọc phòng
              </motion.button>
            </motion.div>

            <StaggerGroup className="mt-8 grid grid-cols-3 gap-3" delay={0.3} stagger={0.08}>
              {[
                { value: allRooms.length, label: "Phòng đang đăng" },
                { value: filteredRooms.length, label: "Kết quả phù hợp" },
                { value: savedCount, label: "Tin đã lưu" },
              ].map((stat) => (
                <StaggerItem key={stat.label}>
                  <motion.div
                    whileHover={{ y: -4 }}
                    transition={{ type: "spring", stiffness: 400, damping: 25 }}
                    className="h-full rounded-2xl bg-white p-4 shadow-sm ring-1 ring-[#E8DED1]"
                  >
                    <p className="text-2xl font-black text-[#243B5A]">
                      <CountUp value={stat.value} duration={1} />
                    </p>
                    <p className="mt-1 text-xs font-semibold text-[#243B5A]/60">{stat.label}</p>
                  </motion.div>
                </StaggerItem>
              ))}
            </StaggerGroup>
          </div>

          {/* Anh hero co parallax nhe khi cuon */}
          <motion.div
            initial={{ opacity: 0, scale: 0.96 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.7, delay: 0.1, ease: [0.16, 1, 0.3, 1] }}
            className="relative z-10"
          >
            <ParallaxLayer strength={26} className="overflow-hidden rounded-3xl">
              <RoomImage
                src={heroRoom?.image}
                alt={heroRoom?.name || "Phòng EasyHouse"}
                className="group aspect-[4/3] rounded-3xl shadow-[0_22px_48px_rgba(36,59,90,0.18)]"
              >
                <div className="absolute inset-0 bg-gradient-to-t from-[#243B5A]/70 via-transparent to-transparent" />
                {heroRoom ? (
                  <motion.button
                    onClick={() => onRoomSelect(heroRoom.id)}
                    whileHover={{ scale: 1.02, y: -3 }}
                    whileTap={{ scale: 0.98 }}
                    transition={{ type: "spring", stiffness: 400, damping: 25 }}
                    className="absolute bottom-5 left-5 right-5 rounded-2xl bg-white/95 p-4 text-left shadow-xl backdrop-blur md:left-auto md:w-80"
                  >
                    <p className="text-xs font-black uppercase tracking-wide text-[#F2A45B]">Gợi ý hôm nay</p>
                    <p className="mt-1 line-clamp-1 text-lg font-black text-[#243B5A]">{heroRoom.name}</p>
                    <p className="mt-1 text-sm font-black text-[#F2A45B]">{heroRoom.priceLabel}</p>
                  </motion.button>
                ) : null}
              </RoomImage>
            </ParallaxLayer>
          </motion.div>
        </section>

        <div className="relative mt-8">
          <div className="absolute inset-0 bg-gradient-to-r from-[#4FA7A0]/10 via-white/30 to-[#F2A45B]/10 rounded-3xl blur-xl"></div>
          <Card className="relative overflow-hidden rounded-[24px] border border-[#243B5A]/[0.08] bg-[#FFFCF8]/95 shadow-[0_18px_40px_rgba(36,59,90,0.10)] backdrop-blur-md">
            <div className="absolute inset-0 rounded-3xl bg-gradient-to-r from-[#4FA7A0]/20 via-white/20 to-[#F2A45B]/20 p-[1px]">
              <div className="w-full h-full bg-white/95 backdrop-blur-md rounded-3xl"></div>
            </div>
            
            <div className="relative p-6 md:p-8">
              <div className="flex items-center gap-3 mb-6">
                <div className="w-10 h-10 bg-[#243B5A] rounded-xl flex items-center justify-center shadow-lg">
                  <Search className="h-5 w-5 text-white" />
                </div>
                <div>
                  <h2 className="text-lg md:text-xl font-black text-[#243B5A]">Tìm kiếm phòng</h2>
                  <p className="text-xs md:text-sm text-[#6B7A8C]">Tìm phòng phù hợp với nhu cầu của bạn</p>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4 md:gap-6">
                <div className="md:col-span-1">
                  <label className="block text-sm font-medium text-[#243B5A] mb-2">Tìm kiếm</label>
                  <div className="relative group">
                    <div className="absolute inset-0 bg-gradient-to-r from-[#4FA7A0]/20 to-[#F2A45B]/20 rounded-xl blur opacity-0 group-focus-within:opacity-100 transition-opacity duration-300"></div>
                    <div className="relative">
                      <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 h-4 w-4 text-[#6B7A8C] group-focus-within:text-[#4FA7A0] transition-colors duration-300" />
                      <Input
                        placeholder="Nhập mã phòng, mô tả..."
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                        className="pl-12 pr-4 py-3 h-12 text-sm border-0 bg-[#F8F3EC]/70 focus:bg-white focus:ring-2 focus:ring-[#4FA7A0]/20 focus:border-[#4FA7A0]/20 rounded-xl transition-all duration-300 shadow-sm hover:shadow-md focus:shadow-lg"
                      />
                    </div>
                  </div>
                </div>

                <div className="md:col-span-1">
                  <label className="block text-sm font-medium text-[#243B5A] mb-2">Tòa nhà</label>
                  <div className="relative group">
                    <div className="absolute inset-0 bg-gradient-to-r from-[#4FA7A0]/20 to-[#243B5A]/10 rounded-xl blur opacity-0 group-focus-within:opacity-100 transition-opacity duration-300"></div>
                    <div className="relative">
                      <Select value={selectedToaNha} onValueChange={setSelectedToaNha}>
                        <SelectTrigger className="h-12 text-sm border-0 bg-[#F8F3EC]/70 focus:bg-white focus:ring-2 focus:ring-[#4FA7A0]/25 focus:border-[#4FA7A0]/30 rounded-xl transition-all duration-300 shadow-sm hover:shadow-md focus:shadow-lg">
                          <SelectValue placeholder="Chọn tòa nhà" />
                        </SelectTrigger>
                        <SelectContent className="border-0 shadow-xl rounded-xl bg-white/95 backdrop-blur-md">
                          <SelectItem value="all" className="text-sm hover:bg-[#F8F3EC]">Tất cả tòa nhà</SelectItem>
                          {toaNhaList.map((toaNha) => (
                            <SelectItem key={toaNha._id} value={toaNha._id!} className="text-sm hover:bg-[#F8F3EC]">
                              {toaNha.tenToaNha}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </div>
                  </div>
                </div>

                <div className="md:col-span-1">
                  <label className="block text-sm font-medium text-[#243B5A] mb-2">Giá từ</label>
                  <Input type="number" min="0" placeholder="2.000.000" value={minGia} onChange={(e) => setMinGia(e.target.value)} className="h-12 rounded-xl bg-[#F8F3EC]/70" />
                </div>

                <div className="md:col-span-1">
                  <label className="block text-sm font-medium text-[#243B5A] mb-2">Giá đến</label>
                  <Input type="number" min="0" placeholder="5.000.000" value={maxGia} onChange={(e) => setMaxGia(e.target.value)} className="h-12 rounded-xl bg-[#F8F3EC]/70" />
                </div>

                <div className="md:col-span-1">
                  <label className="block text-sm font-medium text-[#243B5A] mb-2">Diện tích từ (m2)</label>
                  <Input type="number" min="0" placeholder="20" value={minDienTich} onChange={(e) => setMinDienTich(e.target.value)} className="h-12 rounded-xl bg-[#F8F3EC]/70" />
                </div>
              </div>

              <div className="mt-5 flex flex-col gap-3 rounded-2xl border border-[#4FA7A0]/20 bg-[#E6F3F1]/60 p-4 sm:flex-row sm:items-end sm:justify-between">
                <div>
                  <p className="text-sm font-semibold text-[#243B5A]">Gợi ý phòng gần nhất</p>
                  <p className="text-xs text-[#6B7A8C]">Cho phép vị trí để sắp xếp phòng trống theo khoảng cách thực tế.</p>
                </div>
                <div className="flex flex-col gap-2 sm:flex-row sm:items-center">
                  <Select value={radiusKm} onValueChange={setRadiusKm}>
                    <SelectTrigger className="h-10 w-full bg-white sm:w-[130px]">
                      <SelectValue placeholder="Bán kính" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="2">Trong 2 km</SelectItem>
                      <SelectItem value="5">Trong 5 km</SelectItem>
                      <SelectItem value="10">Trong 10 km</SelectItem>
                    </SelectContent>
                  </Select>
                  <Button type="button" onClick={findNearbyRooms} className="bg-[#267D76] hover:bg-[#1f665f]">
                    <LocateFixed className="mr-2 h-4 w-4" />
                    Tìm gần tôi
                  </Button>
                </div>
              </div>

              <div className="mt-6 pt-6 border-t border-[#E8DED2]/50">
                <div className="flex items-center justify-between">
                  <p className="text-sm text-[#6B7A8C]">
                    Hiển thị <span className="font-semibold text-[#243B5A]">{filteredRooms.length}</span> trong <span className="font-semibold text-[#243B5A]">{allRooms.length}</span> phòng trống phù hợp
                  </p>
                  {(searchQuery || selectedToaNha !== 'all' || minGia || maxGia || minDienTich || filterPrice !== 'all' || filterArea !== 'all') && (
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={() => {
                        resetFilters();
                        setSelectedToaNha('all');
                        setMinGia('');
                        setMaxGia('');
                        setMinDienTich('');
                      }}
                      className="text-xs text-[#6B7A8C] hover:text-[#243B5A] hover:bg-slate-100"
                    >
                      Xóa bộ lọc
                    </Button>
                  )}
                </div>
              </div>
            </div>
          </Card>
        </div>

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
            <StaggerGroup
              className="grid grid-cols-1 gap-5 pb-3 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4"
              stagger={0.08}
            >
              {featuredRooms.slice(0, 4).map((room) => (
                <StaggerItem key={room.id} className="h-full">
                  <RoomCardView
                    room={room}
                    saved={savedRooms.has(room.id)}
                    featured
                    onSelect={() => onRoomSelect(room.id)}
                    onSave={(event) => toggleSave(room, event)}
                  />
                </StaggerItem>
              ))}
            </StaggerGroup>
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

          {loadingRooms ? (
            <div className="grid grid-cols-1 gap-5 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
              {Array.from({ length: 8 }).map((_, i) => (
                <PropertyCardSkeleton key={i} />
              ))}
            </div>
          ) : filteredRooms.length === 0 ? (
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
              <div id="room-list" className="scroll-mt-32">
              <StaggerGroup
                className="grid grid-cols-1 gap-5 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4"
                stagger={0.05}
                amount={0.02}
              >
                {paginatedRooms.map((room) => (
                  <StaggerItem key={room.id} className="h-full">
                    <RoomCardView
                      room={room}
                      saved={savedRooms.has(room.id)}
                      onSelect={() => onRoomSelect(room.id)}
                      onSave={(event) => toggleSave(room, event)}
                    />
                  </StaggerItem>
                ))}
              </StaggerGroup>
              </div>
              {currentPage < totalPages && (
                <div className="mt-8 flex justify-center">
                  <button
                    onClick={() => changePage(currentPage + 1)}
                    className="flex items-center gap-2 rounded-full bg-white px-6 py-3 text-sm font-bold text-[#243B5A] shadow-sm ring-1 ring-[#E8DED1] transition hover:bg-[#F8F3EC] hover:text-[#4FA7A0]"
                  >
                    Hiển thị thêm phòng <ChevronDown size={18} />
                  </button>
                </div>
              )}
            </>
          )}
        </section>

        <section className="mt-12 rounded-[24px] border border-[#243B5A]/[0.08] bg-[#FFFCF8] p-5 shadow-[0_12px_30px_rgba(36,59,90,0.08)] md:p-7">
          <div className="mb-6 flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
            <div>
              <p className="text-xs font-black uppercase tracking-wide text-[#4FA7A0]">Cam kết EasyHouse</p>
              <h2 className="mt-2 text-2xl font-black tracking-tight text-[#243B5A]">Vì sao nên chọn EasyHouse?</h2>
            </div>
            <p className="max-w-xl text-sm font-semibold leading-6 text-[#6B7A8C]">
              Trải nghiệm tìm phòng được thiết kế để dễ quét thông tin, dễ so sánh và luôn dựa trên dữ liệu thật của hệ thống.
            </p>
          </div>

          <div className="grid grid-cols-1 gap-3 sm:grid-cols-2 xl:grid-cols-4">
            {TRUST_ITEMS.map((item) => (
              <div
                key={item.title}
                className="rounded-[20px] border border-[#E8DED1] bg-white p-5 shadow-sm transition duration-200 ease-out hover:-translate-y-1 hover:shadow-[0_18px_40px_rgba(36,59,90,0.10)]"
              >
                <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-[#4FA7A0]/10 text-[#267D76]">
                  {item.icon}
                </div>
                <h3 className="mt-4 text-base font-black text-[#243B5A]">{item.title}</h3>
                <p className="mt-2 text-sm leading-6 text-[#6B7A8C]">{item.description}</p>
              </div>
            ))}
          </div>
        </section>
      </main>

      <footer className="mt-8 bg-[#243B5A] px-4 py-10 text-white md:px-8">
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
