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
  Key,
  LogIn,
  MapPin,
  Search,
  ShieldCheck,
  SlidersHorizontal,
  UserPlus,
  Wallet,
  X,
  BadgeCheck,
  Headphones,
  Layers3,
  MapPinned,
  LayoutDashboard,
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
import { LeftSideDecoration, RightSideDecoration } from "@/components/home/SideDecorations";

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
        <div className="relative flex h-full w-full items-center justify-center overflow-hidden bg-gradient-to-br from-[#F8F3EC] via-[#F2EDE4] to-[#E3D8CA]">
          <motion.div 
            className="absolute h-32 w-32 rounded-full bg-[#4FA7A0]/5 blur-2xl"
            animate={{ x: [0, 10, -5, 0], y: [0, -10, 5, 0] }}
            transition={{ duration: 8, repeat: Infinity, ease: "easeInOut" }}
          />
          <div className="absolute inset-0 bg-[radial-gradient(#243B5A_1px,transparent_1px)] [background-size:16px_16px] opacity-[0.03]" />
          <div className="relative flex flex-col items-center gap-3 text-center">
            <motion.div 
              animate={{ y: [-3, 3, -3] }}
              transition={{ duration: 4, repeat: Infinity, ease: "easeInOut" }}
              className="flex h-14 w-14 items-center justify-center rounded-2xl bg-white/60 text-[#243B5A]/80 shadow-sm ring-1 ring-[#E8DED1]/50 backdrop-blur-sm"
            >
              <Building2 size={26} strokeWidth={1.5} />
            </motion.div>
            <span className="rounded-full bg-white/50 px-3 py-1 text-[10px] font-semibold uppercase tracking-wider text-[#6B7A8C] ring-1 ring-[#E8DED1]/50 backdrop-blur-sm">
              Chưa có ảnh
            </span>
          </div>
        </div>
      )}
      {children}
    </div>
  );
}

// Stable particle positions (no Math.random = no SSR/hydration mismatch)
const HERO_PARTICLES = [
  { w: 5, h: 5, left: "12%", top: "18%", delay: 0 },
  { w: 4, h: 4, left: "78%", top: "12%", delay: 1.2 },
  { w: 6, h: 6, left: "85%", top: "65%", delay: 2.4 },
  { w: 3, h: 3, left: "22%", top: "80%", delay: 0.8 },
  { w: 5, h: 5, left: "55%", top: "88%", delay: 3.1 },
  { w: 4, h: 4, left: "68%", top: "28%", delay: 1.7 },
  { w: 3, h: 3, left: "8%",  top: "52%", delay: 2.9 },
  { w: 6, h: 6, left: "42%", top: "6%",  delay: 0.4 },
] as const;

function HeroIllustration() {
  return (
    <div className="relative flex h-full w-full items-center justify-center overflow-hidden">
      {/* Background gradient */}
      <div className="absolute inset-0 bg-gradient-to-br from-[#EEF7F6] via-[#F8F3EC] to-[#EDE5D9]" />

      {/* Slow-moving blobs */}
      <motion.div
        className="absolute -right-16 -top-16 h-56 w-56 rounded-full bg-[#4FA7A0]/12 blur-3xl"
        animate={{ x: [0, -24, 8, 0], y: [0, 32, 10, 0] }}
        transition={{ duration: 20, repeat: Infinity, ease: "easeInOut" }}
      />
      <motion.div
        className="absolute -bottom-16 -left-16 h-56 w-56 rounded-full bg-[#F2A45B]/12 blur-3xl"
        animate={{ x: [0, 24, -8, 0], y: [0, -32, -10, 0] }}
        transition={{ duration: 25, repeat: Infinity, ease: "easeInOut", delay: 3 }}
      />
      <motion.div
        className="absolute left-[45%] top-[30%] h-28 w-28 -translate-x-1/2 rounded-full bg-[#243B5A]/5 blur-2xl"
        animate={{ scale: [1, 1.4, 1], opacity: [0.3, 0.6, 0.3] }}
        transition={{ duration: 18, repeat: Infinity, ease: "easeInOut", delay: 6 }}
      />

      {/* Dot grid pattern */}
      <div className="absolute inset-0 bg-[radial-gradient(#243B5A_1px,transparent_1px)] [background-size:20px_20px] opacity-[0.025]" />

      {/* Floating particles */}
      {HERO_PARTICLES.map((p, i) => (
        <motion.div
          key={i}
          className="absolute rounded-full bg-[#4FA7A0]"
          style={{ width: p.w, height: p.h, left: p.left, top: p.top }}
          animate={{ y: [0, -16, 0], opacity: [0.1, 0.3, 0.1] }}
          transition={{ duration: 4 + (i % 3), repeat: Infinity, ease: "easeInOut", delay: p.delay }}
        />
      ))}

      {/* Icon constellation */}
      <div className="relative z-10 flex items-center justify-center">
        {/* Center — Home with dual pulse rings */}
        <motion.div
          animate={{ y: [-4, 4, -4] }}
          transition={{ duration: 6, repeat: Infinity, ease: "easeInOut" }}
          className="relative z-20"
        >
          <motion.div
            className="absolute inset-0 rounded-3xl bg-[#4FA7A0]/25"
            animate={{ scale: [1, 1.38, 1], opacity: [0.7, 0, 0.7] }}
            transition={{ duration: 2.8, repeat: Infinity, ease: "easeOut" }}
          />
          <motion.div
            className="absolute inset-0 rounded-3xl bg-[#4FA7A0]/12"
            animate={{ scale: [1, 1.7, 1], opacity: [0.4, 0, 0.4] }}
            transition={{ duration: 2.8, repeat: Infinity, ease: "easeOut", delay: 0.5 }}
          />
          <div className="relative flex h-20 w-20 items-center justify-center rounded-3xl bg-gradient-to-br from-[#243B5A] to-[#2d5068] text-white shadow-[0_20px_48px_rgba(36,59,90,0.30)] ring-1 ring-white/15">
            <Home size={38} strokeWidth={1.5} />
          </div>
        </motion.div>

        {/* Satellite: MapPin — top */}
        <motion.div
          className="absolute flex h-11 w-11 items-center justify-center rounded-2xl bg-white/80 text-[#4FA7A0] shadow-[0_8px_24px_rgba(36,59,90,0.12)] ring-1 ring-white/60 backdrop-blur-md"
          style={{ top: "-44px", left: "50%", marginLeft: "-22px" }}
          animate={{ y: [-6, 6, -6], x: [0, 2, 0] }}
          transition={{ duration: 4.8, repeat: Infinity, ease: "easeInOut", delay: 0 }}
        >
          <MapPin size={19} strokeWidth={1.5} />
        </motion.div>

        {/* Satellite: Key — left */}
        <motion.div
          className="absolute flex h-10 w-10 items-center justify-center rounded-2xl bg-white/80 text-[#267D76] shadow-[0_8px_24px_rgba(36,59,90,0.12)] ring-1 ring-white/60 backdrop-blur-md"
          style={{ top: "4px", left: "-48px" }}
          animate={{ y: [-8, 8, -8], x: [-2, 2, -2] }}
          transition={{ duration: 5.2, repeat: Infinity, ease: "easeInOut", delay: 0.6 }}
        >
          <Key size={17} strokeWidth={1.5} />
        </motion.div>

        {/* Satellite: Building2 — right */}
        <motion.div
          className="absolute flex items-center justify-center rounded-2xl bg-white/80 text-[#F2A45B] shadow-[0_8px_24px_rgba(36,59,90,0.12)] ring-1 ring-white/60 backdrop-blur-md"
          style={{ top: "2px", right: "-54px", width: "52px", height: "52px" }}
          animate={{ y: [6, -6, 6], x: [3, -3, 3] }}
          transition={{ duration: 6.0, repeat: Infinity, ease: "easeInOut", delay: 1.0 }}
        >
          <Building2 size={22} strokeWidth={1.5} />
        </motion.div>

        {/* Satellite: ShieldCheck — bottom-left */}
        <motion.div
          className="absolute flex h-10 w-10 items-center justify-center rounded-2xl bg-white/80 text-[#267D76] shadow-[0_8px_24px_rgba(36,59,90,0.12)] ring-1 ring-white/60 backdrop-blur-md"
          style={{ bottom: "-44px", left: "0px" }}
          animate={{ y: [-9, 9, -9], x: [2, -2, 2] }}
          transition={{ duration: 5.8, repeat: Infinity, ease: "easeInOut", delay: 1.4 }}
        >
          <ShieldCheck size={18} strokeWidth={1.5} />
        </motion.div>

        {/* Satellite: Search — bottom-right */}
        <motion.div
          className="absolute flex h-9 w-9 items-center justify-center rounded-2xl bg-white/80 text-[#243B5A]/70 shadow-[0_8px_24px_rgba(36,59,90,0.12)] ring-1 ring-white/60 backdrop-blur-md"
          style={{ bottom: "-38px", right: "-10px" }}
          animate={{ y: [7, -7, 7], x: [-2, 2, -2] }}
          transition={{ duration: 4.5, repeat: Infinity, ease: "easeInOut", delay: 1.8 }}
        >
          <Search size={17} strokeWidth={1.5} />
        </motion.div>

        {/* Satellite: Wallet — upper-left */}
        <motion.div
          className="absolute flex h-10 w-10 items-center justify-center rounded-2xl bg-white/80 text-[#F2A45B] shadow-[0_8px_24px_rgba(36,59,90,0.12)] ring-1 ring-white/60 backdrop-blur-md"
          style={{ top: "62px", left: "-40px" }}
          animate={{ y: [-5, 5, -5], x: [-3, 3, -3] }}
          transition={{ duration: 6.5, repeat: Infinity, ease: "easeInOut", delay: 0.3 }}
        >
          <Wallet size={17} strokeWidth={1.5} />
        </motion.div>
      </div>
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
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => setScrolled(window.scrollY > 20);
    window.addEventListener("scroll", handleScroll, { passive: true });
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

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

    return allRooms.filter((room) => {
      const text = `${room.name} ${room.location} ${room.description}`.toLowerCase();
      const matchQuery = !query || text.includes(query);
      const matchPrice = filterPrice === "all" || (room.priceValue >= price.min && room.priceValue <= price.max);
      const matchArea = filterArea === "all" || (room.areaValue >= area.min && room.areaValue <= area.max);
      
      return matchQuery && matchPrice && matchArea;
    });
  }, [allRooms, filterArea, filterPrice, searchQuery]);

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


  const heroRoom = featuredRooms[0];

  return (
    <div className="relative flex flex-col overflow-x-hidden bg-[#F8F3EC] text-[#243B5A]">
      <LeftSideDecoration />
      <RightSideDecoration />
      <header className={`sticky top-0 z-30 px-4 pb-3 pt-4 backdrop-blur-md transition-all duration-300 md:px-8 ${
        scrolled
          ? "border-b border-[#E8DED1]/70 bg-white/92 shadow-[0_4px_20px_rgba(36,59,90,0.08)]"
          : "border-b border-[#E8DED1]/30 bg-[#F8F3EC]/70 shadow-none"
      }`}>
        <div className="mx-auto flex w-full max-w-screen-2xl items-center justify-between gap-3">
          <button onClick={resetFilters} className="flex min-w-0 items-center gap-2 text-left group" title="Về trang chủ">
            <span className="flex h-11 w-11 items-center justify-center rounded-[14px] bg-[#0D9488] text-white shadow-sm transition-transform duration-300 group-hover:scale-105">
              <svg viewBox="0 0 24 24" fill="none" className="h-[22px] w-[22px]" aria-hidden="true">
                <path d="M3 12l9-9 9 9" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
                <path d="M5 10v9a1 1 0 001 1h4v-4h4v4h4a1 1 0 001-1v-9" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
              </svg>
            </span>
            <span className="min-w-0">
              <span className="block text-[19px] font-black uppercase leading-tight tracking-tight text-slate-900 transition-colors duration-150 group-hover:text-slate-700">
                Easy<span className="text-[#0D9488]">House</span>
              </span>
              <span className="block truncate text-[11px] font-semibold text-[#6B7A8C]">Tìm phòng minh bạch, nhanh gọn</span>
            </span>
          </button>

          <nav className="hidden items-center gap-7 text-sm font-bold text-[#243B5A]/70 md:flex">
            <button
              onClick={() => document.getElementById("featured-rooms")?.scrollIntoView({ behavior: "smooth" })}
              className="group relative transition-colors hover:text-[#4FA7A0]"
            >
              Phòng nổi bật
              <span className="absolute -bottom-1 left-0 h-[2px] w-0 bg-[#4FA7A0] transition-all duration-300 ease-out group-hover:w-full"></span>
            </button>
            <button
              onClick={() => document.getElementById("room-list")?.scrollIntoView({ behavior: "smooth" })}
              className="group relative transition-colors hover:text-[#4FA7A0]"
            >
              Danh sách phòng
              <span className="absolute -bottom-1 left-0 h-[2px] w-0 bg-[#4FA7A0] transition-all duration-300 ease-out group-hover:w-full"></span>
            </button>
            <Link href="/dieu-khoan-dich-vu" className="group relative transition-colors hover:text-[#4FA7A0]">
              Chính sách
              <span className="absolute -bottom-1 left-0 h-[2px] w-0 bg-[#4FA7A0] transition-all duration-300 ease-out group-hover:w-full"></span>
            </Link>
          </nav>

          <div className="flex items-center gap-2">
            <button
              onClick={() => onTabChange?.("saved")}
              className="group relative flex h-10 w-10 items-center justify-center rounded-full border border-[#E8DED1] bg-white text-[#243B5A] shadow-sm transition hover:border-[#4FA7A0] hover:text-[#4FA7A0]"
              title="Tin đã lưu"
            >
              <Heart size={18} className="transition-transform duration-300 group-hover:scale-110" />
              {savedCount > 0 && (
                <span className="absolute -right-1 -top-1 min-w-5 rounded-full bg-[#F2A45B] px-1.5 text-center text-[10px] font-bold text-white">
                  {savedCount}
                </span>
              )}
            </button>
            <button className="group hidden h-10 w-10 items-center justify-center rounded-full border border-[#E8DED1] bg-white text-[#243B5A] shadow-sm transition hover:border-[#4FA7A0] hover:text-[#4FA7A0] md:flex" title="Thông báo">
              <Bell size={18} className="transition-transform duration-300 group-hover:rotate-[8deg]" />
            </button>
            {userProfile ? (
              <div className="flex items-center gap-2">
                {(session?.user as any)?.role === 'TENANT' || (session?.user as any)?.role === 'khachThue' ? (
                  <Link href="/khach-thue/dashboard" className="hidden items-center gap-2 rounded-full border border-[#E8DED1] bg-white px-3 py-1.5 text-sm font-semibold text-[#4FA7A0] shadow-sm transition hover:border-[#4FA7A0] hover:bg-[#4FA7A0]/5 sm:flex">
                    <LayoutDashboard size={15} />
                    <span className="hidden lg:inline">Bảng điều khiển</span>
                  </Link>
                ) : ['ADMIN', 'LANDLORD', 'STAFF', 'admin', 'chuNha', 'nhanVien'].includes((session?.user as any)?.role || '') ? (
                  <Link href="/dashboard" className="hidden items-center gap-2 rounded-full border border-[#E8DED1] bg-white px-3 py-1.5 text-sm font-semibold text-[#4FA7A0] shadow-sm transition hover:border-[#4FA7A0] hover:bg-[#4FA7A0]/5 sm:flex">
                    <LayoutDashboard size={15} />
                    <span className="hidden lg:inline">Quản lý</span>
                  </Link>
                ) : null}
                <button onClick={() => onTabChange?.("profile")} className="group flex items-center gap-2 rounded-full border border-[#E8DED1] bg-white p-1.5 pr-3 shadow-sm transition hover:border-[#4FA7A0]">
                  <span className="flex h-8 w-8 items-center justify-center rounded-full bg-[#4FA7A0] text-xs font-black text-white transition-transform duration-300 group-hover:scale-105">
                    {String(currentUserName).slice(0, 1).toUpperCase()}
                  </span>
                  <span className="hidden max-w-28 truncate text-sm font-semibold text-[#243B5A] transition-colors group-hover:text-[#4FA7A0] sm:block">{currentUserName}</span>
                </button>
              </div>
            ) : (
              <Link href="/dang-nhap" className="group flex h-10 items-center gap-2 rounded-full bg-[#243B5A] px-4 text-sm font-bold text-white shadow-sm transition hover:bg-[#1b2e47]">
                <LogIn size={16} className="transition-transform duration-300 group-hover:-translate-x-0.5" />
                <span className="hidden sm:inline">Đăng nhập</span>
              </Link>
            )}
          </div>
        </div>

        <div className="mx-auto mt-4 flex w-full max-w-screen-2xl gap-2">
          <div className="group flex min-w-0 flex-1 items-center gap-2 rounded-2xl border border-[#E8DED1] bg-white px-4 py-3 transition focus-within:border-[#4FA7A0] focus-within:ring-4 focus-within:ring-[#4FA7A0]/15 hover:shadow-sm">
            <Search size={18} className="shrink-0 text-[#4FA7A0] transition-transform duration-300 group-focus-within:scale-110" />
            <input
              value={searchQuery}
              onChange={(event) => setSearchQuery(event.target.value)}
              placeholder="Tìm khu vực, tên phòng..."
              className="w-full bg-transparent text-sm font-semibold text-[#243B5A] outline-none placeholder:text-[#6B7A8C]"
            />
          </div>
          <button
            onClick={() => setIsFilterOpen(true)}
            className="group flex h-[50px] items-center gap-2 rounded-2xl border border-[#E8DED1] bg-white px-4 text-sm font-black text-[#243B5A] shadow-sm transition hover:border-[#4FA7A0] hover:text-[#4FA7A0] hover:-translate-y-[1px]"
          >
            <SlidersHorizontal size={18} className="transition-transform duration-300 group-hover:translate-x-[2px]" />
            <span className="hidden sm:inline">Bộ lọc</span>
          </button>
        </div>
      </header>

      <main className="mx-auto w-full max-w-screen-2xl flex-1 px-4 py-6 md:px-8 md:py-9">
        <section className="relative grid items-center gap-8 overflow-hidden rounded-[32px] px-1 py-4 lg:grid-cols-[0.9fr_1.1fr] lg:px-6 lg:py-8">
          <div className="absolute inset-0 pointer-events-none opacity-50">
            <motion.div 
              animate={{ x: [0, 20, -10, 0], y: [0, -20, 10, 0] }}
              transition={{ duration: 20, repeat: Infinity, ease: "easeInOut" }}
              className="absolute -left-[10%] -top-[10%] h-[50%] w-[40%] rounded-full bg-[#4FA7A0]/10 blur-[100px]"
            />
            <motion.div 
              animate={{ x: [0, -20, 10, 0], y: [0, 20, -10, 0] }}
              transition={{ duration: 25, repeat: Infinity, ease: "easeInOut" }}
              className="absolute -bottom-[10%] right-[10%] h-[40%] w-[30%] rounded-full bg-[#F2A45B]/10 blur-[80px]"
            />
            <div className="absolute inset-0 bg-[radial-gradient(#243B5A_1px,transparent_1px)] [background-size:24px_24px] opacity-[0.02]" />
          </div>
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

          <motion.div
            initial={{ opacity: 0, scale: 0.96 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.7, delay: 0.1, ease: [0.16, 1, 0.3, 1] }}
            className="relative z-10"
          >
            <ParallaxLayer strength={26} className="overflow-hidden rounded-3xl h-full">
              {heroRoom?.image ? (
                <RoomImage
                  src={heroRoom.image}
                  alt={heroRoom.name}
                  className="group aspect-[4/3] rounded-3xl shadow-[0_22px_48px_rgba(36,59,90,0.18)]"
                >
                  <div className="absolute inset-0 bg-gradient-to-t from-[#243B5A]/70 via-transparent to-transparent" />
                  <motion.button
                    onClick={() => onRoomSelect(heroRoom.id)}
                    whileHover={{ scale: 1.02, y: -3 }}
                    whileTap={{ scale: 0.98 }}
                    transition={{ type: "spring", stiffness: 400, damping: 25 }}
                    className="absolute bottom-5 left-5 right-5 rounded-2xl bg-white/95 p-4 text-left shadow-xl backdrop-blur md:left-auto md:w-80 group-hover:bg-white transition-colors"
                  >
                    <p className="text-xs font-black uppercase tracking-wide text-[#F2A45B]">Gợi ý hôm nay</p>
                    <p className="mt-1 line-clamp-1 text-lg font-black text-[#243B5A]">{heroRoom.name}</p>
                    <p className="mt-1 text-sm font-black text-[#F2A45B]">{heroRoom.priceLabel}</p>
                  </motion.button>
                </RoomImage>
              ) : (
                <div className="group relative aspect-[4/3] w-full overflow-hidden rounded-3xl shadow-[0_22px_48px_rgba(36,59,90,0.18)] ring-1 ring-[#E8DED1]">
                  <HeroIllustration />
                  <div className="absolute inset-0 bg-gradient-to-t from-[#243B5A]/70 via-transparent to-transparent" />
                  {heroRoom && (
                    <motion.button
                      onClick={() => onRoomSelect(heroRoom.id)}
                      whileHover={{ scale: 1.02, y: -3 }}
                      whileTap={{ scale: 0.98 }}
                      transition={{ type: "spring", stiffness: 400, damping: 25 }}
                      className="absolute bottom-5 left-5 right-5 rounded-2xl bg-white/95 p-4 text-left shadow-xl backdrop-blur md:left-auto md:w-80 group-hover:bg-white transition-colors"
                    >
                      <p className="text-xs font-black uppercase tracking-wide text-[#F2A45B]">Gợi ý hôm nay</p>
                      <p className="mt-1 line-clamp-1 text-lg font-black text-[#243B5A]">{heroRoom.name}</p>
                      <p className="mt-1 text-sm font-black text-[#F2A45B]">{heroRoom.priceLabel}</p>
                    </motion.button>
                  )}
                </div>
              )}
            </ParallaxLayer>
          </motion.div>
        </section>

        <motion.section 
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: "-50px" }}
          transition={{ duration: 0.6, ease: [0.16, 1, 0.3, 1] }}
          className="mt-8 rounded-[24px] border border-[#243B5A]/[0.08] bg-white/85 p-3 shadow-[0_12px_30px_rgba(36,59,90,0.08)] backdrop-blur"
        >
          <div className="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
            <div className="flex items-center gap-3 px-2 group cursor-pointer">
              <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-2xl bg-[#4FA7A0]/10 text-[#267D76] transition-transform duration-300 group-hover:scale-110 group-hover:bg-[#4FA7A0]/20">
                <SlidersHorizontal size={19} className="transition-transform duration-300 group-hover:rotate-[8deg]" />
              </span>
              <div>
                <p className="text-sm font-black text-[#243B5A]">Lọc nhanh phòng phù hợp</p>
                <p className="text-xs font-semibold text-[#6B7A8C]">{filteredRooms.length} phòng phù hợp với tìm kiếm của bạn</p>
              </div>
            </div>

            <div className="scrollbar-none flex gap-2 overflow-x-auto pb-1 lg:pb-0">
              {PRICE_RANGES.map((price) => {
                const isActive = filterPrice === price.id;
                return (
                  <button
                    key={price.id}
                    onClick={() => setFilterPrice(price.id)}
                    className={`relative shrink-0 rounded-full px-4 py-2 text-xs font-black transition-colors duration-200 hover:-translate-y-[1px] ${
                      isActive ? "text-white" : "text-[#243B5A] hover:text-[#267D76]"
                    }`}
                  >
                    {isActive ? (
                      <motion.div
                        layoutId="activeFilterPriceBg"
                        className="absolute inset-0 rounded-full bg-[#4FA7A0] shadow-sm"
                        initial={false}
                        transition={{ type: "spring", stiffness: 400, damping: 30 }}
                      />
                    ) : (
                      <div className="absolute inset-0 rounded-full border border-[#E8DED1] bg-[#FFFCF8]" />
                    )}
                    <span className="relative z-10">{price.shortLabel}</span>
                  </button>
                );
              })}
              
              <div className="mx-2 w-[1px] shrink-0 bg-[#E8DED1]" />
              
              {AREA_RANGES.slice(1).map((area) => {
                const isActive = filterArea === area.id;
                return (
                  <button
                    key={area.id}
                    onClick={() => setFilterArea(area.id)}
                    className={`relative shrink-0 rounded-full px-4 py-2 text-xs font-black transition-colors duration-200 hover:-translate-y-[1px] ${
                      isActive ? "text-white" : "text-[#243B5A] hover:text-[#243B5A]/70"
                    }`}
                  >
                    {isActive ? (
                      <motion.div
                        layoutId="activeFilterAreaBg"
                        className="absolute inset-0 rounded-full bg-[#243B5A] shadow-sm"
                        initial={false}
                        transition={{ type: "spring", stiffness: 400, damping: 30 }}
                      />
                    ) : (
                      <div className="absolute inset-0 rounded-full border border-[#E8DED1] bg-[#FFFCF8]" />
                    )}
                    <span className="relative z-10">{area.shortLabel}</span>
                  </button>
                );
              })}
              <button
                onClick={() => document.getElementById("room-list")?.scrollIntoView({ behavior: "smooth" })}
                className="shrink-0 rounded-full bg-[#F2A45B] px-5 py-2 text-xs font-black text-white shadow-[0_10px_22px_rgba(242,164,91,0.22)] transition-transform duration-200 hover:-translate-y-[1px] active:scale-95"
              >
                Áp dụng
              </button>
            </div>
          </div>
        </motion.section>

        {featuredRooms.length > 0 && (
          <section id="featured-rooms" className="mt-12">
            <motion.div
              initial={{ opacity: 0, y: 16 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, margin: "-40px" }}
              transition={{ duration: 0.5, ease: [0.16, 1, 0.3, 1] }}
              className="mb-5 flex items-end justify-between gap-3"
            >
              <div>
                <p className="mb-1 text-xs font-black uppercase tracking-wider text-[#4FA7A0]">Được chọn lọc</p>
                <h2 className="text-2xl font-black tracking-tight text-[#243B5A]">Phòng nổi bật</h2>
                <p className="mt-1 text-sm font-semibold text-[#243B5A]/60">Lấy trực tiếp từ danh sách phòng hiện có</p>
              </div>
              <motion.button
                onClick={() => document.getElementById("room-list")?.scrollIntoView({ behavior: "smooth" })}
                whileHover={{ x: 3 }}
                transition={{ type: "spring", stiffness: 400, damping: 25 }}
                className="hidden items-center gap-1 text-sm font-black text-[#F2A45B] sm:flex"
              >
                Xem tất cả <ChevronRight size={17} />
              </motion.button>
            </motion.div>
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
          <motion.div
            initial={{ opacity: 0, y: 16 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, margin: "-40px" }}
            transition={{ duration: 0.5, ease: [0.16, 1, 0.3, 1] }}
            className="mb-6 flex flex-col gap-2 md:flex-row md:items-end md:justify-between"
          >
            <div>
              <p className="text-xs font-black uppercase tracking-wide text-[#4FA7A0]">Cam kết EasyHouse</p>
              <h2 className="mt-2 text-2xl font-black tracking-tight text-[#243B5A]">Vì sao nên chọn EasyHouse?</h2>
            </div>
            <p className="max-w-xl text-sm font-semibold leading-6 text-[#6B7A8C]">
              Trải nghiệm tìm phòng được thiết kế để dễ quét thông tin, dễ so sánh và luôn dựa trên dữ liệu thật của hệ thống.
            </p>
          </motion.div>

          <StaggerGroup className="grid grid-cols-1 gap-3 sm:grid-cols-2 xl:grid-cols-4" stagger={0.08} delay={0.1}>
            {TRUST_ITEMS.map((item) => (
              <StaggerItem key={item.title}>
                <motion.div
                  whileHover={{ y: -4 }}
                  transition={{ duration: 0.2, ease: [0.16, 1, 0.3, 1] }}
                  className="h-full rounded-[20px] border border-[#E8DED1] bg-white p-5 shadow-sm hover:shadow-[0_18px_40px_rgba(36,59,90,0.10)]"
                >
                  <motion.div
                    whileHover={{ scale: 1.08, rotate: 3 }}
                    transition={{ type: "spring", stiffness: 400, damping: 20 }}
                    className="flex h-11 w-11 items-center justify-center rounded-2xl bg-[#4FA7A0]/10 text-[#267D76]"
                  >
                    {item.icon}
                  </motion.div>
                  <h3 className="mt-4 text-base font-black text-[#243B5A]">{item.title}</h3>
                  <p className="mt-2 text-sm leading-6 text-[#6B7A8C]">{item.description}</p>
                </motion.div>
              </StaggerItem>
            ))}
          </StaggerGroup>
        </section>
      </main>

      <footer className="mt-8 bg-[#243B5A] px-4 py-10 text-white md:px-8">
        <div className="mx-auto grid w-full max-w-screen-2xl gap-7 md:grid-cols-[1.4fr_0.8fr_0.8fr]">
          <div>
            <div className="flex items-center gap-3 group cursor-default">
              <span className="flex h-11 w-11 items-center justify-center rounded-[14px] bg-[#0D9488] text-white shadow-sm transition-transform duration-300 group-hover:scale-105">
                <svg viewBox="0 0 24 24" fill="none" className="h-[22px] w-[22px]" aria-hidden="true">
                  <path d="M3 12l9-9 9 9" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
                  <path d="M5 10v9a1 1 0 001 1h4v-4h4v4h4a1 1 0 001-1v-9" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
                </svg>
              </span>
              <div>
                <p className="text-xl font-black uppercase tracking-tight text-white">
                  Easy<span className="text-[#0D9488]">House</span>
                </p>
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
