'use client';
import { useState, useEffect } from "react";
import {
  ArrowLeft, Share2, Heart, MapPin, Wifi, Wind, Car,
  ShieldCheck, ChevronDown, ChevronUp, Star, CheckCircle2
} from "lucide-react";
import { DatLichHenDialog } from "@/components/ui/dat-lich-hen-dialog";

const fallbackImages = [
  "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800&h=500&fit=crop&auto=format",
  "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800&h=500&fit=crop&auto=format",
];

const allAmenities = [
  { icon: <Wifi size={20} className="text-[#243B5A]" />, label: "Wifi" },
  { icon: <Wind size={20} className="text-[#243B5A]" />, label: "Máy lạnh" },
  { icon: <Car size={20} className="text-[#243B5A]" />, label: "Bãi xe" },
  { icon: <ShieldCheck size={20} className="text-[#243B5A]" />, label: "Bảo vệ" },
  { icon: <CheckCircle2 size={20} className="text-[#243B5A]" />, label: "Nội thất" },
];

interface RoomDetailScreenProps {
  onBack: () => void;
  roomId: string | number;
}

export function RoomDetailScreen({ onBack, roomId }: RoomDetailScreenProps) {
  const [currentImage, setCurrentImage] = useState(0);
  const [saved, setSaved] = useState(false);
  const [expanded, setExpanded] = useState(false);
  const [roomData, setRoomData] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [isBookingOpen, setIsBookingOpen] = useState(false);

  useEffect(() => {
    fetch('/api/public/phong/' + roomId)
      .then(res => {
        if (!res.ok) throw new Error("HTTP error " + res.status);
        return res.json();
      })
      .then(data => {
        setRoomData(data?.data || data || null);
        setLoading(false);
      })
      .catch(err => {
        console.error(err);
        setLoading(false);
      });
  }, [roomId]);

  if (loading) {
    return <div className="flex h-full items-center justify-center">Đang tải...</div>;
  }

  if (!roomData) {
    return (
      <div className="flex flex-col h-full items-center justify-center">
        <p>Không tìm thấy phòng!</p>
        <button onClick={onBack} className="mt-4 text-[#243B5A]">Quay lại</button>
      </div>
    );
  }

  const roomName = roomData.ten || (roomData.soPhong ? `Phòng ${roomData.soPhong}` : (roomData.name || "Phòng Trọ"));
  
  // Format price nicely
  let roomPriceRaw = roomData.giaHienTai || roomData.giaThue || roomData.price || 0;
  const roomPrice = typeof roomPriceRaw === 'number' || typeof roomPriceRaw === 'bigint'
    ? new Intl.NumberFormat('vi-VN').format(roomPriceRaw)
    : roomPriceRaw || "Liên hệ";

  const roomLocation = roomData.nhaTro?.diaChi || roomData.toaNha?.diaChi || roomData.location || "Chưa cập nhật địa chỉ";
  const roomArea = roomData.dienTich ? `${roomData.dienTich}m²` : "Chưa rõ";
  const images = (roomData.anhList && roomData.anhList.length > 0)
    ? roomData.anhList
    : ((roomData.hinhAnh && roomData.hinhAnh.length > 0) ? roomData.hinhAnh : fallbackImages);

  return (
    <div className="flex flex-col h-full bg-[#F8F3EC] overflow-y-auto w-full">
      <div className="max-w-screen-2xl mx-auto w-full px-4 md:px-8 py-6 flex-1 flex flex-col gap-6 pb-32 relative">
        
        {/* Header Action Bar */}
        <div className="flex items-center justify-between bg-[#FFFDF8] px-5 py-3.5 rounded-2xl border border-[#E8DED2] shadow-xs">
          <button
            onClick={onBack}
            className="flex items-center gap-2 text-[#6B7A8C] hover:text-[#243B5A] transition-colors font-semibold text-sm group"
          >
            <ArrowLeft size={16} className="group-hover:-translate-x-1 transition-transform" />
            <span>Quay lại danh sách</span>
          </button>
          <div className="flex items-center gap-2">
            <button className="p-2.5 rounded-xl border border-[#E8DED2] hover:bg-[#F8F3EC] transition-colors flex items-center justify-center bg-[#FFFDF8] shadow-xs">
              <Share2 size={16} className="text-[#6B7A8C]" />
            </button>
            <button
              onClick={() => setSaved(!saved)}
              className="p-2.5 rounded-xl border border-[#E8DED2] hover:bg-[#F8F3EC] transition-colors flex items-center justify-center bg-[#FFFDF8] shadow-xs"
            >
              <Heart size={16} className={saved ? "fill-red-500 text-red-500" : "text-[#6B7A8C]"} />
            </button>
          </div>
        </div>

        {/* 2-Column Split Layout */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">
          
          {/* CỘT TRÁI: Gallery & Details (2/3 width) */}
          <div className="lg:col-span-2 space-y-6">
            
            {/* Premium Image Slider */}
            <div className="relative w-full h-[240px] sm:h-[360px] md:h-[420px] bg-slate-100 rounded-3xl overflow-hidden shadow-xs group">
              <img
                src={images[currentImage]}
                alt="Ảnh phòng"
                className="w-full h-full object-cover transition-all duration-500"
              />
              
              {/* Prev / Next arrows */}
              {images.length > 1 && (
                <>
                  <button
                    onClick={() => setCurrentImage((prev) => (prev > 0 ? prev - 1 : images.length - 1))}
                    className="absolute left-4 top-1/2 -translate-y-1/2 w-10 h-10 rounded-full bg-[#FFFDF8]/90 hover:bg-[#FFFDF8] backdrop-blur flex items-center justify-center shadow-md transition-all opacity-0 group-hover:opacity-100"
                  >
                    <ArrowLeft size={16} className="text-[#243B5A]" />
                  </button>
                  <button
                    onClick={() => setCurrentImage((prev) => (prev < images.length - 1 ? prev + 1 : 0))}
                    className="absolute right-4 top-1/2 -translate-y-1/2 w-10 h-10 rounded-full bg-[#FFFDF8]/90 hover:bg-[#FFFDF8] backdrop-blur flex items-center justify-center shadow-md transition-all opacity-0 group-hover:opacity-100"
                  >
                    <ArrowLeft size={16} className="text-[#243B5A] rotate-180" />
                  </button>
                </>
              )}
              
              {/* Dots */}
              <div className="absolute bottom-4 left-1/2 -translate-x-1/2 flex gap-1.5 bg-[#243B5A]/35 px-3 py-1.5 rounded-full backdrop-blur-xs">
                {images.map((_: any, i: number) => (
                  <button
                    key={i}
                    onClick={() => setCurrentImage(i)}
                    className={`h-1.5 rounded-full transition-all ${
                      i === currentImage ? "w-5 bg-[#FFFDF8]" : "w-1.5 bg-[#FFFDF8]/60 hover:bg-[#FFFDF8]"
                    }`}
                  />
                ))}
              </div>
            </div>

            {/* Room Title & Address */}
            <div className="bg-[#FFFDF8] rounded-3xl p-6 border border-[#E8DED2] shadow-xs space-y-4">
              <div className="flex items-center gap-2">
                <span className="text-xs bg-[#4FA7A0]/10 text-[#267D76] px-3 py-1 rounded-full font-bold uppercase tracking-wider">
                  {roomData.trangThai || "Còn trống"}
                </span>
                <span className="text-xs bg-[#4FA7A0]/10 text-[#243B5A] px-3 py-1 rounded-full font-bold uppercase tracking-wider">
                  {roomArea}
                </span>
              </div>
              <h1 className="text-2xl md:text-3xl font-black text-[#243B5A] tracking-tight leading-tight">
                {roomName}
              </h1>
              <div className="flex flex-col sm:flex-row sm:items-center gap-3 text-sm text-[#6B7A8C] pt-1">
                <div className="flex items-center gap-1.5">
                  <MapPin size={16} className="text-[#FF5A3D] shrink-0" />
                  <span className="font-medium text-[#243B5A]">{roomLocation}</span>
                </div>
                <div className="hidden sm:block text-slate-300">|</div>
                <div className="flex items-center gap-1.5">
                  <Star size={14} className="fill-amber-400 text-amber-400" />
                  <span className="font-bold text-[#243B5A]">4.9</span>
                  <span className="text-[#6B7A8C]">(0 đánh giá)</span>
                </div>
              </div>
            </div>

            {/* Amenities Section */}
            <div className="bg-[#FFFDF8] rounded-3xl p-6 border border-[#E8DED2] shadow-xs space-y-4">
              <h2 className="text-base font-bold text-[#243B5A] flex items-center gap-2">
                <span className="w-1.5 h-4 bg-[#243B5A] rounded-full" />
                Tiện ích nổi bật
              </h2>
              <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-3">
                {allAmenities.map((a, i) => (
                  <div key={i} className="flex flex-col items-center gap-2 bg-[#F8F3EC] border border-[#E8DED2] rounded-2xl p-3 text-center transition-all hover:bg-[#F8F3EC]">
                    <div className="w-10 h-10 rounded-xl bg-[#4FA7A0]/10 flex items-center justify-center shrink-0">
                      {a.icon}
                    </div>
                    <span className="text-xs font-semibold text-[#243B5A] leading-tight">{a.label}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* Description Section */}
            <div className="bg-[#FFFDF8] rounded-3xl p-6 border border-[#E8DED2] shadow-xs space-y-3">
              <h2 className="text-base font-bold text-[#243B5A] flex items-center gap-2">
                <span className="w-1.5 h-4 bg-[#243B5A] rounded-full" />
                Mô tả chi tiết phòng
              </h2>
              <p className={`text-sm text-[#6B7A8C] leading-relaxed whitespace-pre-line ${!expanded ? "line-clamp-4" : ""}`}>
                {roomData.moTa || "Phòng trọ sạch sẽ, thoáng mát, khu dân cư an ninh. Vui lòng liên hệ trực tiếp chủ nhà để biết thêm chi tiết và đặt lịch xem phòng. Các tiện ích điện nước tính theo giá nhà nước."}
              </p>
              <button
                onClick={() => setExpanded(!expanded)}
                className="flex items-center gap-1 text-[#243B5A] text-sm font-bold hover:underline transition-colors mt-2"
              >
                {expanded ? "Thu gọn mô tả" : "Xem thêm mô tả"}
                {expanded ? <ChevronUp size={14} /> : <ChevronDown size={14} />}
              </button>
            </div>

            {/* Map Section */}
            <div className="bg-[#FFFDF8] rounded-3xl p-6 border border-[#E8DED2] shadow-xs space-y-4">
              <h2 className="text-base font-bold text-[#243B5A] flex items-center gap-2">
                <span className="w-1.5 h-4 bg-[#243B5A] rounded-full" />
                Vị trí địa lý
              </h2>
              <div className="relative rounded-2xl overflow-hidden h-44 bg-slate-200 border border-[#E8DED2] shadow-xs">
                <img
                  src="https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=800&h=300&fit=crop&auto=format"
                  alt="Bản đồ"
                  className="w-full h-full object-cover opacity-70"
                />
                <div className="absolute inset-0 bg-[#243B5A]/10 flex items-center justify-center p-4">
                  <div className="bg-[#FFFDF8] rounded-xl px-4 py-2.5 flex items-center gap-2.5 shadow-lg border border-[#E8DED2] max-w-sm">
                    <MapPin size={18} className="text-[#FF5A3D] shrink-0" />
                    <span className="text-xs font-semibold text-[#243B5A] truncate">{roomLocation}</span>
                  </div>
                </div>
              </div>
            </div>

          </div>

          {/* CỘT PHẢI: Pricing & Sticky Booking Card (1/3 width) */}
          <div className="lg:col-span-1 lg:sticky lg:top-24 space-y-4">
            <div className="bg-[#FFFDF8] border border-slate-150 rounded-3xl p-6 shadow-md shadow-slate-100/30 space-y-6">
              
              {/* Pricing details */}
              <div>
                <p className="text-xs text-[#6B7A8C] font-bold uppercase tracking-wider">Giá thuê tháng</p>
                <div className="flex items-baseline gap-1 mt-1">
                  <span className="text-3xl font-black text-[#243B5A] tracking-tight">{roomPrice}</span>
                  <span className="text-base font-medium text-[#6B7A8C]">đ/tháng</span>
                </div>
              </div>

              {/* Grid attributes */}
              <div className="border-t border-[#E8DED2] pt-5 space-y-4">
                <div className="grid grid-cols-2 gap-3">
                  <div className="bg-[#F8F3EC] rounded-2xl p-3.5 border border-[#E8DED2]">
                    <span className="text-[10px] text-[#6B7A8C] font-bold uppercase block">Diện tích</span>
                    <span className="text-sm font-bold text-[#243B5A] mt-0.5 block">{roomArea}</span>
                  </div>
                  <div className="bg-[#F8F3EC] rounded-2xl p-3.5 border border-[#E8DED2]">
                    <span className="text-[10px] text-[#6B7A8C] font-bold uppercase block">Cấu hình</span>
                    <span className="text-sm font-bold text-[#243B5A] mt-0.5 block">1 phòng ngủ</span>
                  </div>
                </div>

                {/* Brand Assurances */}
                <div className="space-y-2.5 text-xs bg-amber-50/50 border border-amber-100/70 rounded-2xl p-4">
                  <div className="flex items-center gap-2 font-bold text-amber-800">
                    <ShieldCheck size={16} className="text-amber-600 shrink-0" />
                    <span>Cam kết EasyHouse</span>
                  </div>
                  <ul className="space-y-1.5 list-disc pl-4 text-amber-900/80 font-medium">
                    <li>Tin đăng xác thực 100% từ chủ nhà</li>
                    <li>Không qua trung gian, phí môi giới</li>
                    <li>Hỗ trợ hợp đồng thuê nhà điện tử miễn phí</li>
                  </ul>
                </div>
              </div>

              {/* CTA Booking Button */}
              <button 
                onClick={() => setIsBookingOpen(true)}
                className="w-full bg-[#FF5A3D] text-white py-4 px-6 rounded-2xl font-bold hover:bg-orange-600 active:scale-[0.98] transition-all shadow-md shadow-orange-200 flex items-center justify-center gap-2 text-sm md:text-base cursor-pointer"
              >
                Đặt lịch xem phòng
              </button>

              <p className="text-center text-[11px] text-[#6B7A8C] font-medium leading-normal px-2">
                Hỗ trợ thủ tục đặt cọc và tham quan nhà trọ 24/7 hoàn toàn miễn phí
              </p>
            </div>
          </div>

        </div>

      </div>

      {/* Sticky Bottom Bar (Mobile only) */}
      <div className="lg:hidden fixed bottom-0 left-0 w-full bg-[#FFFDF8] border-t border-[#E8DED2] px-5 py-4 pb-8 z-20 flex items-center justify-between shadow-xl">
        <div>
          <p className="text-xs text-[#6B7A8C] font-bold uppercase tracking-wider">Giá thuê</p>
          <p className="text-[#243B5A] font-bold" style={{ fontSize: "1.2rem" }}>
            {roomPrice}đ<span className="text-sm font-normal text-[#6B7A8C]">/tháng</span>
          </p>
        </div>
        <button 
          onClick={() => setIsBookingOpen(true)}
          className="bg-[#FF5A3D] text-white px-6 py-3.5 rounded-2xl font-bold shadow-md shadow-orange-200 active:scale-95 transition-transform text-sm cursor-pointer"
        >
          Đặt lịch xem phòng
        </button>
      </div>

      <DatLichHenDialog 
        isOpen={isBookingOpen} 
        onClose={() => setIsBookingOpen(false)} 
        phongId={String(roomData._id || roomData.id || roomId)} 
        maPhong={roomName} 
      />
    </div>
  );
}
