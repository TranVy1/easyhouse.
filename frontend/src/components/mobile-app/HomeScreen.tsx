'use client';
import { useState, useEffect } from "react";
import Link from "next/link";
import {
  Search, SlidersHorizontal, Heart, MapPin, Wifi, Wind,
  Car, Star, ChevronRight, Bell, X, UserPlus, LogIn, PlusCircle,
  Camera, Play, Phone, Mail, Globe, Building
} from "lucide-react";

// --- Types & Constants ---
const CATEGORIES = ["Phòng trọ", "Nhà nguyên căn", "Căn hộ chung cư", "Căn hộ mini", "Căn hộ dịch vụ", "Ở ghép", "Mặt bằng", "Blog", "Bảng giá dịch vụ"];
const PRICE_RANGES = [
  { id: "all", label: "Tất cả", min: 0, max: Infinity },
  { id: "<3", label: "Dưới 3 triệu", min: 0, max: 3000000 },
  { id: "3-5", label: "3 - 5 triệu", min: 3000000, max: 5000000 },
  { id: "5-10", label: "5 - 10 triệu", min: 5000000, max: 10000000 },
  { id: ">10", label: "Trên 10 triệu", min: 10000000, max: Infinity },
];
const AREA_RANGES = [
  { id: "all", label: "Tất cả", min: 0, max: Infinity },
  { id: "<20", label: "Dưới 20m²", min: 0, max: 20 },
  { id: "20-40", label: "20 - 40m²", min: 20, max: 40 },
  { id: ">40", label: "Trên 40m²", min: 40, max: Infinity },
];

const parseNumber = (val: string | number | undefined) => {
  if (!val) return 0;
  if (typeof val === 'number') return val;
  return Number(val.toString().replace(/[^0-9]/g, ''));
};

const amenityIcon = (type: string) => {
  if (type === "wifi") return <Wifi size={14} className="text-blue-500" />;
  if (type === "ac") return <Wind size={14} className="text-blue-500" />;
  if (type === "parking") return <Car size={14} className="text-blue-500" />;
  return null;
};

const getRoomImages = (room: any) => {
  const defaults = [
    "https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=500&fit=crop", // Bedroom
    "https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=300&fit=crop", // Kitchen
    "https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=300&fit=crop", // Bathroom
    "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=300&fit=crop"  // Living room/balcony
  ];

  // Format the source images from either room.hinhAnh or fallback room.image
  const roomImages = room.hinhAnh && room.hinhAnh.length > 0
    ? room.hinhAnh.map((img: any) => typeof img === 'string' ? img : img.url || img.hinhAnh || defaults[0])
    : [room.image || defaults[0]];

  const finalImages = [...roomImages];
  while (finalImages.length < 4) {
    finalImages.push(defaults[finalImages.length % defaults.length]);
  }
  return finalImages;
};

const parseToMillion = (priceStr: string) => {
  const numeric = parseNumber(priceStr);
  if (numeric >= 1000000) {
    return `${(numeric / 1000000).toFixed(1).replace('.0', '')} triệu/tháng`;
  }
  return `${priceStr}đ/tháng`;
};

interface HomeScreenProps {
  onRoomSelect: (id: number) => void;
  onTabChange?: (tab: "home" | "saved" | "bills" | "profile") => void;
}

export function HomeScreen({ onRoomSelect, onTabChange }: HomeScreenProps) {
  const [userProfile, setUserProfile] = useState<any>(null);

  // Data States
  const [allRooms, setAllRooms] = useState<any[]>([]);
  const [availableRoomsData, setAvailableRoomsData] = useState<any[]>([]);
  const [featuredRoomsData, setFeaturedRoomsData] = useState<any[]>([]);

  // Filter States
  const [isFilterOpen, setIsFilterOpen] = useState(false);
  const [filterCat, setFilterCat] = useState("Phòng trọ");
  const [filterPrice, setFilterPrice] = useState("all");
  const [filterArea, setFilterArea] = useState("all");

  const [savedRooms, setSavedRooms] = useState<Set<number>>(new Set());

  useEffect(() => {
    // Load saved rooms from localStorage
    const saved = localStorage.getItem("easyhouse_saved_rooms");
    if (saved) {
      try {
        const parsed = JSON.parse(saved);
        const ids = new Set<number>(parsed.map((r: any) => r.id));
        setSavedRooms(ids);
      } catch (e) {
        console.error(e);
      }
    }

    // Fetch profile
    fetch('/api/user/profile')
      .then(res => res.json())
      .then(data => {
        if (data.data) {
          setUserProfile(data.data);
        }
      })
      .catch(() => { });

    // Fetch rooms
    fetch('/api/public/phong')
      .then(res => res.json())
      .then(data => {
        const rooms = Array.isArray(data) ? data : data?.data?.data || data?.data?.content || data?.data || [];
        if (rooms.length > 0) {
          const mappedRooms = rooms.map((room: any) => ({
            id: room._id || room.id,
            name: room.ten || (room.soPhong ? `Phòng ${room.soPhong}` : 'Phòng Trọ'),
            location: room.diaChiNhaTro || room.toaNha?.diaChi || 'Chưa cập nhật địa chỉ',
            price: room.giaHienTai || room.giaThue || 0,
            area: room.dienTich ? `${room.dienTich}m²` : '',
            bedrooms: 1,
            amenities: room.tienIchNoiBat || room.tienIch || ["wifi"],
            image: room.anhDaiDien || (room.hinhAnh && room.hinhAnh.length > 0 ? room.hinhAnh[0] : 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=200&h=200&fit=crop&auto=format'),
            hinhAnh: room.anhList || room.hinhAnh || [],
            description: room.moTa || room.description || room.mo_ta || '',
            rating: 4.9,
            reviews: 12,
            saved: false
          }));
          // Format price after parsing for filter
          mappedRooms.forEach((r: any) => {
            r.price = new Intl.NumberFormat('vi-VN').format(r.price);
          });

          setAllRooms(mappedRooms);
          setAvailableRoomsData(mappedRooms);
          setFeaturedRoomsData(mappedRooms.slice(0, 3)); // 3 first rooms as featured
        }
      })
      .catch(err => console.error("API Fetch Error:", err));
  }, []);

  // Filter Logic
  useEffect(() => {
    if (allRooms.length === 0) return;

    const filtered = allRooms.filter((room) => {
      // 1. Filter Category
      let matchCat = true;
      if (filterCat !== "Phòng trọ") {
        const n = room.name.toLowerCase();
        // Giả lập từ khóa do backend chưa có loại phòng
        if (filterCat === "Căn hộ mini") matchCat = n.includes("căn hộ") || n.includes("studio") || n.includes("mini");
        else if (filterCat === "Nhà nguyên căn") matchCat = n.includes("nhà");
        else if (filterCat === "Căn hộ chung cư") matchCat = n.includes("chung cư");
        else if (filterCat === "Ở ghép") matchCat = n.includes("ghép");
        else if (filterCat === "Mặt bằng") matchCat = n.includes("mặt bằng");
        else if (filterCat === "Căn hộ dịch vụ") matchCat = n.includes("dịch vụ");
      }

      // 2. Filter Price
      let matchPrice = true;
      if (filterPrice !== "all") {
        const pObj = PRICE_RANGES.find(p => p.id === filterPrice);
        const pVal = parseNumber(room.price);
        if (pObj && pVal > 0) {
          matchPrice = pVal >= pObj.min && pVal <= pObj.max;
        }
      }

      // 3. Filter Area
      let matchArea = true;
      if (filterArea !== "all") {
        const aObj = AREA_RANGES.find(a => a.id === filterArea);
        const aVal = parseNumber(room.area);
        if (aObj && aVal > 0) {
          matchArea = aVal >= aObj.min && aVal <= aObj.max;
        }
      }

      return matchCat && matchPrice && matchArea;
    });

    setAvailableRoomsData(filtered);
  }, [filterCat, filterPrice, filterArea, allRooms]);


  const toggleSave = (room: any, e: React.MouseEvent) => {
    e.stopPropagation();
    const roomId = room.id;
    const saved = localStorage.getItem("easyhouse_saved_rooms");
    let currentSaved: any[] = saved ? JSON.parse(saved) : [];

    const exists = currentSaved.some((r: any) => r.id === roomId);
    if (exists) {
      currentSaved = currentSaved.filter((r: any) => r.id !== roomId);
      setSavedRooms((prev) => {
        const next = new Set(prev);
        next.delete(roomId);
        return next;
      });
    } else {
      currentSaved.push(room);
      setSavedRooms((prev) => {
        const next = new Set(prev);
        next.add(roomId);
        return next;
      });
    }
    localStorage.setItem("easyhouse_saved_rooms", JSON.stringify(currentSaved));
  };

  const currentUserName = userProfile?.name || userProfile?.hoTen || "Nguyễn Văn An";
  const currentUserAvatar = userProfile?.avatar || "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=80&h=80&fit=crop&auto=format";

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC] overflow-y-auto relative">
      {/* Header */}
      <div className="sticky top-0 z-20 bg-white px-4 md:px-8 xl:px-12 pt-6 pb-2 shadow-sm border-b border-slate-100">
        <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">

          {/* Left: Logo */}
          <div
            onClick={() => {
              setFilterCat("Phòng trọ");
              setFilterPrice("all");
              setFilterArea("all");
            }}
            className="flex flex-col mr-4 shrink-0 cursor-pointer hover:opacity-80 transition-opacity"
            title="Về trang chủ"
          >
            <h1 className="text-2xl font-black text-blue-600 tracking-tight leading-none uppercase flex items-center gap-1">
              EASY<span className="text-slate-800">HOUSE</span>
            </h1>
            <p className="text-[10px] text-slate-500 font-medium mt-1 uppercase tracking-wider">Kênh thông tin phòng trọ số 1 Việt Nam</p>
          </div>

          {/* Center: Search & Filter */}
          <div className="flex-1 flex w-full max-w-2xl gap-2">
            <div className="flex-1 flex items-center gap-2 bg-[#F1F5F9] rounded-xl px-4 py-2.5">
              <MapPin size={18} className="text-slate-400 shrink-0" />
              <input
                type="text"
                placeholder="Tìm theo khu vực"
                className="bg-transparent outline-none text-sm text-slate-700 placeholder:text-slate-400 w-full"
              />
            </div>
            <button
              onClick={() => setIsFilterOpen(true)}
              className="px-4 py-2.5 bg-white border border-slate-200 rounded-xl flex items-center justify-center gap-2 hover:bg-slate-50 transition-colors shadow-sm shrink-0"
            >
              <SlidersHorizontal size={16} className="text-slate-600" />
              <span className="text-sm font-medium text-slate-700 hidden sm:inline">Bộ lọc</span>
            </button>
          </div>

          {/* Right: Actions */}
          <div className="hidden lg:flex items-center gap-6 ml-4 shrink-0">
            <button 
              onClick={() => onTabChange?.("saved")}
              className="flex items-center gap-2 text-slate-600 hover:text-slate-900 transition-colors"
            >
              <Heart size={18} />
              <span className="text-sm font-medium">Tin đã lưu</span>
            </button>
            
            {userProfile ? (
              <button
                onClick={() => onTabChange?.("profile")}
                className="flex items-center gap-2.5 hover:opacity-90 transition-opacity"
                title="Xem hồ sơ cá nhân"
              >
                <img
                  src={currentUserAvatar}
                  alt={currentUserName}
                  className="w-8 h-8 rounded-full object-cover border border-slate-200"
                />
                <span className="text-sm font-semibold text-slate-700">{currentUserName}</span>
              </button>
            ) : (
              <>
                <Link href="/dang-ky" className="flex items-center gap-2 text-slate-600 hover:text-slate-900 transition-colors">
                  <UserPlus size={18} />
                  <span className="text-sm font-medium">Đăng ký</span>
                </Link>
                <Link href="/dang-nhap" className="flex items-center gap-2 text-slate-600 hover:text-slate-900 transition-colors">
                  <LogIn size={18} />
                  <span className="text-sm font-medium">Đăng nhập</span>
                </Link>
              </>
            )}

            {userProfile && ['ADMIN', 'LANDLORD', 'STAFF'].includes(userProfile.role?.toUpperCase()) && (
              <Link href="/dashboard" className="px-5 py-2.5 bg-[#FF5A3D] text-white rounded-xl flex items-center gap-2 font-medium hover:bg-orange-600 transition-colors shadow-md ml-2">
                <span>Trang quản trị</span>
                <SlidersHorizontal size={16} />
              </Link>
            )}
          </div>
        </div>
      </div>

      <div className="flex-1 px-4 md:px-8 xl:px-12 pt-3 pb-10 space-y-8">
        {/* 2-Column Layout: Sidebar (Trái) & Content (Phải) */}
        <div className="flex flex-col lg:flex-row gap-8 mt-0">

          {/* CỘT TRÁI: Bộ lọc, Tin mới đăng, Bài viết mới */}
          <div className="w-full lg:w-[280px] xl:w-[320px] shrink-0 space-y-6">

            {/* Xem theo khoảng giá */}
            <div className="bg-white rounded-xl border border-slate-100 p-5 shadow-sm">
              <div className="flex items-center justify-between mb-4">
                <h3 className="font-bold text-slate-900">Xem theo khoảng giá</h3>
                {filterPrice !== "all" && (
                  <button onClick={() => setFilterPrice("all")} className="text-xs text-blue-600 font-semibold hover:underline">
                    Bỏ lọc
                  </button>
                )}
              </div>
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-1 xl:grid-cols-2 gap-y-3 gap-x-2 text-sm">
                {PRICE_RANGES.filter(r => r.id !== 'all').map(r => (
                  <button
                    key={r.id}
                    onClick={() => setFilterPrice(filterPrice === r.id ? "all" : r.id)}
                    className={`flex items-center gap-1.5 text-left hover:text-[#FF5A3D] transition-colors ${filterPrice === r.id ? "text-[#FF5A3D] font-medium" : "text-slate-600"}`}
                  >
                    <ChevronRight size={14} className="text-slate-400 shrink-0" />
                    {r.label}
                  </button>
                ))}
              </div>
            </div>

            {/* Xem theo diện tích */}
            <div className="bg-white rounded-xl border border-slate-100 p-5 shadow-sm">
              <div className="flex items-center justify-between mb-4">
                <h3 className="font-bold text-slate-900">Xem theo diện tích</h3>
                {filterArea !== "all" && (
                  <button onClick={() => setFilterArea("all")} className="text-xs text-blue-600 font-semibold hover:underline">
                    Bỏ lọc
                  </button>
                )}
              </div>
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-1 xl:grid-cols-2 gap-y-3 gap-x-2 text-sm">
                {AREA_RANGES.filter(r => r.id !== 'all').map(r => (
                  <button
                    key={r.id}
                    onClick={() => setFilterArea(filterArea === r.id ? "all" : r.id)}
                    className={`flex items-center gap-1.5 text-left hover:text-[#FF5A3D] transition-colors ${filterArea === r.id ? "text-[#FF5A3D] font-medium" : "text-slate-600"}`}
                  >
                    <ChevronRight size={14} className="text-slate-400 shrink-0" />
                    {r.label}
                  </button>
                ))}
              </div>
            </div>

            {/* Tin mới đăng */}
            <div className="bg-white rounded-xl border border-slate-100 p-5 shadow-sm">
              <h3 className="font-bold text-slate-900 mb-4">Tin mới đăng</h3>
              <div className="space-y-4">
                {featuredRoomsData.slice(0, 5).map(room => (
                  <div key={room.id} onClick={() => onRoomSelect(room.id)} className="flex gap-3 cursor-pointer group border-b border-slate-50 pb-3 last:border-0 last:pb-0">
                    <img src={room.image} className="w-16 h-16 rounded-md object-cover shrink-0" />
                    <div className="flex-1 min-w-0">
                      <h4 className="text-sm font-semibold text-slate-800 group-hover:text-blue-600 truncate">{room.name}</h4>
                      <p className="text-[#FF5A3D] text-xs font-bold mt-1.5">{room.price}đ/tháng</p>
                      <p className="text-[10px] text-slate-400 mt-1">1 giờ trước</p>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Bài viết mới */}
            <div className="bg-white rounded-xl border border-slate-100 p-5 shadow-sm">
              <h3 className="font-bold text-slate-900 mb-4">Bài viết mới</h3>
              <div className="space-y-3">
                <div className="flex gap-3 cursor-pointer group border-b border-slate-50 pb-3">
                  <div className="flex-1 min-w-0">
                    <h4 className="text-sm font-semibold text-slate-800 group-hover:text-blue-600 leading-snug">Kinh nghiệm thuê phòng trọ sinh viên giá rẻ, an ninh tốt</h4>
                    <p className="text-[10px] text-slate-400 mt-1">Hôm nay</p>
                  </div>
                </div>
                <div className="flex gap-3 cursor-pointer group">
                  <div className="flex-1 min-w-0">
                    <h4 className="text-sm font-semibold text-slate-800 group-hover:text-blue-600 leading-snug">Cập nhật bảng giá dịch vụ điện nước mới nhất 2026</h4>
                    <p className="text-[10px] text-slate-400 mt-1">Hôm qua</p>
                  </div>
                </div>
              </div>
            </div>

          </div>

          {/* CỘT PHẢI: Danh sách phòng */}
          <div className="flex-1 min-w-0">
            {/* Featured Rooms */}
            {featuredRoomsData.length > 0 && filterCat === "Phòng trọ" && filterPrice === "all" && filterArea === "all" && (
              <section className="mb-8">
                <div className="flex items-center justify-between mb-3">
                  <h2 className="text-slate-900" style={{ fontSize: "1.125rem", fontWeight: 700 }}>
                    Phòng Nổi Bật
                  </h2>
                  <button className="flex items-center gap-1 text-blue-600 text-sm font-semibold hover:underline">
                    Xem tất cả <ChevronRight size={14} />
                  </button>
                </div>
                 <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6 sm:gap-8">
                   {featuredRoomsData.map((room) => {
                     const imgs = getRoomImages(room);
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
                             {/* Play button overlay in the center of the main image */}
                             <div className="absolute inset-0 flex items-center justify-center">
                               <div className="w-12 h-12 rounded-full bg-black/40 backdrop-blur-sm flex items-center justify-center border border-white/20">
                                 <Play size={20} className="fill-white text-white translate-x-0.5" />
                               </div>
                             </div>
                             {/* Camera count overlay bottom left */}
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
                           {/* Save heart button overlay top right */}
                           <div className="absolute top-3 right-3 z-10">
                             <button
                               onClick={(e) => toggleSave(room, e)}
                               className="w-9 h-9 rounded-full bg-white/90 backdrop-blur flex items-center justify-center shadow-md hover:bg-white transition-all"
                             >
                               <Heart
                                 size={16}
                                 className={savedRooms.has(room.id) ? "fill-red-500 text-red-500" : "text-slate-500"}
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
                             <span className="text-[#0F9675] font-bold text-sm sm:text-base">{parseToMillion(room.price)}</span>
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
              </section>
            )}
            <section>
              <div className="flex items-center justify-between mb-4">
                <h2 className="text-slate-900" style={{ fontSize: "1.125rem", fontWeight: 700 }}>
                  {(filterCat !== "Phòng trọ" || filterPrice !== "all" || filterArea !== "all")
                    ? "Kết quả bộ lọc"
                    : "Tất Cả Phòng"}
                </h2>
                <span className="text-xs font-medium text-slate-500 bg-slate-100 px-3 py-1.5 rounded-full">
                  {availableRoomsData.length} kết quả
                </span>
              </div>

              {availableRoomsData.length === 0 ? (
                <div className="text-center py-10 bg-white rounded-2xl shadow-sm border border-dashed border-slate-200">
                  <p className="text-slate-500 text-sm">Không tìm thấy phòng phù hợp với bộ lọc.</p>
                  <button onClick={() => { setFilterCat("Phòng trọ"); setFilterPrice("all"); setFilterArea("all"); }} className="mt-3 text-blue-600 text-sm font-semibold hover:underline">
                    Xóa bộ lọc
                  </button>
                </div>
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6 sm:gap-8">
                  {availableRoomsData.map((room) => {
                    const imgs = getRoomImages(room);
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
                            {/* Play button overlay in the center of the main image */}
                            <div className="absolute inset-0 flex items-center justify-center">
                              <div className="w-12 h-12 rounded-full bg-black/40 backdrop-blur-sm flex items-center justify-center border border-white/20">
                                <Play size={20} className="fill-white text-white translate-x-0.5" />
                              </div>
                            </div>
                            {/* Camera count overlay bottom left */}
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
                          {/* Save heart button overlay top right */}
                          <div className="absolute top-3 right-3 z-10">
                            <button
                              onClick={(e) => toggleSave(room, e)}
                              className="w-9 h-9 rounded-full bg-white/90 backdrop-blur flex items-center justify-center shadow-md hover:bg-white transition-all"
                            >
                              <Heart
                                size={16}
                                className={savedRooms.has(room.id) ? "fill-red-500 text-red-500" : "text-slate-500"}
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
                            <span className="text-[#0F9675] font-bold text-sm sm:text-base">{parseToMillion(room.price)}</span>
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
            </section>
          </div>
        </div>
      </div>

      {/* Footer Component */}
      <footer className="bg-slate-900 text-slate-400 pt-16 pb-8 border-t border-slate-800 shrink-0 mt-8">
        <div className="w-full max-w-7xl mx-auto px-4 md:px-8 xl:px-12">
          {/* Main Footer Content */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-10 mb-12">
            
            {/* Column 1: Brand & Logo */}
            <div className="space-y-4">
              <div className="flex flex-col">
                <h2 className="text-2xl font-black text-blue-500 tracking-tight leading-none uppercase">
                  EASY<span className="text-white">HOUSE</span>
                </h2>
                <p className="text-[10px] text-slate-500 font-medium mt-1 uppercase tracking-wider">
                  Kênh thông tin phòng trọ số 1 Việt Nam
                </p>
              </div>
              <p className="text-sm text-slate-400 leading-relaxed">
                Hệ thống quản lý và tìm kiếm phòng trọ thông minh hàng đầu, kết nối trực tiếp giữa chủ trọ và người thuê phòng một cách hiệu quả, minh bạch và an toàn nhất.
              </p>
              <div className="flex items-center gap-3 pt-2">
                <span className="w-8 h-8 rounded-full bg-slate-800 hover:bg-blue-600 transition-colors flex items-center justify-center text-white text-sm font-semibold cursor-pointer">f</span>
                <span className="w-8 h-8 rounded-full bg-slate-800 hover:bg-[#FF385C] transition-colors flex items-center justify-center text-white text-sm font-semibold cursor-pointer">y</span>
                <span className="w-8 h-8 rounded-full bg-slate-800 hover:bg-blue-400 transition-colors flex items-center justify-center text-white text-sm font-semibold cursor-pointer">t</span>
              </div>
            </div>

            {/* Column 2: Quick Links */}
            <div className="space-y-4">
              <h3 className="text-white font-bold text-base tracking-wide uppercase">Liên Kết Nhanh</h3>
              <ul className="space-y-2.5 text-sm">
                <li>
                  <button 
                    onClick={() => {
                      setFilterCat("Phòng trọ");
                      setFilterPrice("all");
                      setFilterArea("all");
                    }}
                    className="hover:text-white hover:underline transition-colors text-left"
                  >
                    Trang chủ EasyHouse
                  </button>
                </li>
                <li>
                  <Link href="/xem-phong" className="hover:text-white hover:underline transition-colors">
                    Tìm kiếm phòng trọ
                  </Link>
                </li>
                <li>
                  <Link href="/dang-ky" className="hover:text-white hover:underline transition-colors">
                    Đăng ký tài khoản mới
                  </Link>
                </li>
                <li>
                  <Link href="/dang-nhap" className="hover:text-white hover:underline transition-colors">
                    Đăng nhập hệ thống
                  </Link>
                </li>
              </ul>
            </div>

            {/* Column 3: Contact Info */}
            <div className="space-y-4">
              <h3 className="text-white font-bold text-base tracking-wide uppercase">Thông Tin Liên Hệ</h3>
              <ul className="space-y-3 text-sm">
                <li className="flex items-start gap-2.5">
                  <MapPin size={16} className="text-blue-500 shrink-0 mt-0.5" />
                  <span>136 Cầu Diễn, Bắc Từ Liêm, Hà Nội, Việt Nam</span>
                </li>
                <li className="flex items-center gap-2.5">
                  <Phone size={16} className="text-blue-500 shrink-0" />
                  <span>1900 8888 (Hotline hỗ trợ 24/7)</span>
                </li>
                <li className="flex items-center gap-2.5">
                  <Mail size={16} className="text-blue-500 shrink-0" />
                  <span>support@easyhouse.local</span>
                </li>
                <li className="flex items-center gap-2.5">
                  <Globe size={16} className="text-blue-500 shrink-0" />
                  <span>www.easyhouse.local</span>
                </li>
              </ul>
            </div>

            {/* Column 4: Partner & Trust */}
            <div className="space-y-4">
              <h3 className="text-white font-bold text-base tracking-wide uppercase">Chứng Nhận & Uy Tín</h3>
              <p className="text-sm text-slate-400 leading-relaxed">
                Giải pháp công nghệ số giúp tối ưu quy trình tìm kiếm, quản lý nhà trọ và hợp đồng thuê nhà trực tuyến nhanh gọn.
              </p>
              <div className="pt-2">
                <div className="border border-slate-800 rounded-xl p-3 bg-slate-950/50 flex items-center gap-3">
                  <Building size={24} className="text-blue-500 shrink-0" />
                  <div className="min-w-0">
                    <p className="text-xs font-bold text-white uppercase tracking-wider">EasyHouse Corp</p>
                    <p className="text-[10px] text-slate-500 truncate">Hệ thống Chuyển đổi số Nhà trọ</p>
                  </div>
                </div>
              </div>
            </div>

          </div>

          {/* Divider */}
          <div className="border-t border-slate-800 pt-8 flex flex-col md:flex-row items-center justify-between gap-4">
            <p className="text-xs text-slate-500">
              © {new Date().getFullYear()} EasyHouse. Bảo lưu mọi quyền.
            </p>
            <div className="flex items-center gap-6 text-xs text-slate-500">
              <Link href="/dieu-khoan-dich-vu" className="hover:text-slate-300 transition-colors">Điều khoản dịch vụ</Link>
              <Link href="/chinh-sach-bao-mat" className="hover:text-slate-300 transition-colors">Chính sách bảo mật</Link>
              <Link href="/quy-che-hoat-dong" className="hover:text-slate-300 transition-colors">Quy chế hoạt động</Link>
            </div>
          </div>
        </div>
      </footer>

      {/* Filter Modal Overlay */}
      {isFilterOpen && (
        <div className="fixed inset-0 z-50 flex items-end md:items-center justify-center bg-black/50 backdrop-blur-sm transition-opacity">
          <div className="bg-white w-full md:w-[450px] md:rounded-3xl rounded-t-3xl overflow-hidden shadow-2xl flex flex-col max-h-[90vh] animate-in slide-in-from-bottom-10 fade-in duration-200">
            {/* Modal Header */}
            <div className="flex items-center justify-between px-6 py-4 border-b border-slate-100">
              <h2 className="text-lg font-bold text-slate-900">Bộ Lọc Tìm Kiếm</h2>
              <button
                onClick={() => setIsFilterOpen(false)}
                className="w-8 h-8 rounded-full bg-slate-100 flex items-center justify-center hover:bg-slate-200 transition-colors"
              >
                <X size={18} className="text-slate-600" />
              </button>
            </div>

            {/* Modal Body */}
            <div className="flex-1 overflow-y-auto px-6 py-5 space-y-6">

              {/* Category Filter */}
              <div>
                <h3 className="text-sm font-bold text-slate-800 mb-3">Danh mục cho thuê</h3>
                <div className="flex flex-wrap gap-2">
                  {CATEGORIES.map((cat) => (
                    <button
                      key={cat}
                      onClick={() => setFilterCat(cat)}
                      className={`px-4 py-2 rounded-xl text-sm transition-all border ${filterCat === cat
                        ? "bg-blue-50 border-blue-500 text-blue-700 font-semibold shadow-sm"
                        : "bg-white border-slate-200 text-slate-600 hover:border-blue-300"
                        }`}
                    >
                      {cat}
                    </button>
                  ))}
                </div>
              </div>

              {/* Price Range Filter */}
              <div>
                <h3 className="text-sm font-bold text-slate-800 mb-3">Khoảng giá</h3>
                <div className="grid grid-cols-2 gap-2">
                  {PRICE_RANGES.map((price) => (
                    <button
                      key={price.id}
                      onClick={() => setFilterPrice(price.id)}
                      className={`px-3 py-2.5 rounded-xl text-sm transition-all border text-center ${filterPrice === price.id
                        ? "bg-blue-50 border-blue-500 text-blue-700 font-semibold shadow-sm"
                        : "bg-white border-slate-200 text-slate-600 hover:border-blue-300"
                        }`}
                    >
                      {price.label}
                    </button>
                  ))}
                </div>
              </div>

              {/* Area Range Filter */}
              <div>
                <h3 className="text-sm font-bold text-slate-800 mb-3">Diện tích</h3>
                <div className="grid grid-cols-2 gap-2">
                  {AREA_RANGES.map((area) => (
                    <button
                      key={area.id}
                      onClick={() => setFilterArea(area.id)}
                      className={`px-3 py-2.5 rounded-xl text-sm transition-all border text-center ${filterArea === area.id
                        ? "bg-blue-50 border-blue-500 text-blue-700 font-semibold shadow-sm"
                        : "bg-white border-slate-200 text-slate-600 hover:border-blue-300"
                        }`}
                    >
                      {area.label}
                    </button>
                  ))}
                </div>
              </div>

            </div>

            {/* Modal Footer */}
            <div className="px-6 py-4 border-t border-slate-100 flex gap-3 bg-slate-50">
              <button
                onClick={() => {
                  setFilterCat("Phòng trọ");
                  setFilterPrice("all");
                  setFilterArea("all");
                }}
                className="px-5 py-3 rounded-xl font-semibold text-slate-600 bg-white border border-slate-200 hover:bg-slate-100 transition-colors"
              >
                Thiết lập lại
              </button>
              <button
                onClick={() => setIsFilterOpen(false)}
                className="flex-1 py-3 rounded-xl font-bold text-white bg-blue-600 hover:bg-blue-700 shadow-md shadow-blue-200 transition-colors"
              >
                Hiển thị {availableRoomsData.length} kết quả
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
