import { useState } from "react";
import {
  ArrowLeft, Share2, Heart, MapPin, Wifi, Wind, Car,
  ShieldCheck, ChevronDown, ChevronUp, Star, CheckCircle2
} from "lucide-react";

const images = [
  "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800&h=500&fit=crop&auto=format",
  "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800&h=500&fit=crop&auto=format",
  "https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800&h=500&fit=crop&auto=format",
];

const amenities = [
  { icon: <Wifi size={20} className="text-blue-600" />, label: "Wifi miễn phí" },
  { icon: <Wind size={20} className="text-blue-600" />, label: "Máy lạnh" },
  { icon: <Car size={20} className="text-blue-600" />, label: "Bãi xe" },
  { icon: <ShieldCheck size={20} className="text-blue-600" />, label: "Bảo vệ 24/7" },
  { icon: <CheckCircle2 size={20} className="text-blue-600" />, label: "Nội thất đầy đủ" },
  { icon: <CheckCircle2 size={20} className="text-blue-600" />, label: "Ban công" },
];

interface RoomDetailScreenProps {
  onBack: () => void;
}

export function RoomDetailScreen({ onBack }: RoomDetailScreenProps) {
  const [currentImage, setCurrentImage] = useState(0);
  const [saved, setSaved] = useState(false);
  const [expanded, setExpanded] = useState(false);

  return (
    <div className="flex flex-col h-full bg-white overflow-y-auto">
      {/* Image Gallery */}
      <div className="relative w-full h-72 bg-slate-100 shrink-0">
        <img
          src={images[currentImage]}
          alt="Ảnh phòng"
          className="w-full h-full object-cover"
        />
        {/* Nav buttons */}
        <button
          onClick={onBack}
          className="absolute top-12 left-4 w-10 h-10 rounded-full bg-white/90 backdrop-blur flex items-center justify-center shadow"
        >
          <ArrowLeft size={18} className="text-slate-700" />
        </button>
        <button className="absolute top-12 right-4 w-10 h-10 rounded-full bg-white/90 backdrop-blur flex items-center justify-center shadow">
          <Share2 size={18} className="text-slate-700" />
        </button>
        {/* Dots */}
        <div className="absolute bottom-4 left-1/2 -translate-x-1/2 flex gap-1.5">
          {images.map((_, i) => (
            <button
              key={i}
              onClick={() => setCurrentImage(i)}
              className={`h-1.5 rounded-full transition-all ${
                i === currentImage ? "w-5 bg-white" : "w-1.5 bg-white/50"
              }`}
            />
          ))}
        </div>
      </div>

      {/* Content */}
      <div className="flex-1 px-4 pt-4 pb-28 space-y-5">
        {/* Title & Price */}
        <div className="flex items-start justify-between gap-2">
          <div className="flex-1">
            <div className="flex items-center gap-2 mb-1">
              <span className="text-xs bg-green-100 text-green-700 px-2 py-0.5 rounded-full font-semibold">
                Còn trống
              </span>
            </div>
            <h1 className="text-slate-900" style={{ fontSize: "1.15rem", fontWeight: 700, lineHeight: 1.3 }}>
              Studio Hiện Đại Quận 1
            </h1>
            <div className="flex items-center gap-1 mt-1">
              <MapPin size={13} className="text-slate-400" />
              <p className="text-sm text-slate-500">39 Nguyễn Huệ, Q.1, TP.HCM</p>
            </div>
            <div className="flex items-center gap-1 mt-1.5">
              <Star size={13} className="fill-amber-400 text-amber-400" />
              <span className="text-sm font-semibold text-slate-700">4.9</span>
              <span className="text-sm text-slate-400">(128 đánh giá)</span>
            </div>
          </div>
          <button
            onClick={() => setSaved(!saved)}
            className="w-11 h-11 rounded-full border border-slate-200 flex items-center justify-center shrink-0"
          >
            <Heart size={20} className={saved ? "fill-red-500 text-red-500" : "text-slate-400"} />
          </button>
        </div>

        {/* Price */}
        <div className="bg-blue-50 rounded-2xl p-4 flex items-center justify-between">
          <div>
            <p className="text-sm text-slate-500">Giá thuê hàng tháng</p>
            <p className="text-blue-700 font-bold" style={{ fontSize: "1.4rem" }}>
              5.500.000<span className="text-sm font-normal">đ</span>
            </p>
          </div>
          <div className="text-right">
            <p className="text-xs text-slate-500">Diện tích</p>
            <p className="text-slate-800 font-semibold">30m²</p>
            <p className="text-xs text-slate-500 mt-0.5">1 phòng ngủ</p>
          </div>
        </div>

        {/* Amenities */}
        <div>
          <h2 className="text-slate-900 mb-3" style={{ fontSize: "1rem", fontWeight: 700 }}>
            Tiện ích
          </h2>
          <div className="grid grid-cols-3 gap-3">
            {amenities.map((a, i) => (
              <div key={i} className="flex flex-col items-center gap-1.5 bg-[#F8FAFC] rounded-xl py-3 px-2">
                {a.icon}
                <span className="text-xs text-slate-600 text-center leading-tight">{a.label}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Description */}
        <div>
          <h2 className="text-slate-900 mb-2" style={{ fontSize: "1rem", fontWeight: 700 }}>
            Mô tả
          </h2>
          <p className={`text-sm text-slate-600 leading-relaxed ${!expanded ? "line-clamp-3" : ""}`}>
            Phòng studio hiện đại, thoáng mát, đầy đủ nội thất cao cấp tại trung tâm Quận 1.
            Căn phòng được thiết kế thông minh với đầy đủ tiện nghi: máy lạnh, tủ lạnh, máy giặt,
            bếp từ, smart TV. Tòa nhà có hồ bơi, phòng gym, và bảo vệ 24/7.
            Vị trí thuận tiện, gần các tuyến xe buýt và metro, dễ dàng di chuyển đến các quận khác.
            Phòng có view đẹp nhìn ra thành phố, yên tĩnh và an ninh tốt.
          </p>
          <button
            onClick={() => setExpanded(!expanded)}
            className="flex items-center gap-1 text-blue-600 text-sm mt-1"
          >
            {expanded ? "Thu gọn" : "Xem thêm"}
            {expanded ? <ChevronUp size={14} /> : <ChevronDown size={14} />}
          </button>
        </div>

        {/* Map */}
        <div>
          <h2 className="text-slate-900 mb-2" style={{ fontSize: "1rem", fontWeight: 700 }}>
            Vị trí
          </h2>
          <div className="relative rounded-2xl overflow-hidden h-36 bg-slate-200">
            <img
              src="https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=800&h=300&fit=crop&auto=format"
              alt="Bản đồ"
              className="w-full h-full object-cover opacity-70"
            />
            <div className="absolute inset-0 flex items-center justify-center">
              <div className="bg-white rounded-xl px-3 py-2 flex items-center gap-2 shadow">
                <MapPin size={16} className="text-blue-600" />
                <span className="text-sm font-medium text-slate-700">39 Nguyễn Huệ, Q.1</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Sticky Bottom Bar */}
      <div className="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-sm bg-white border-t border-slate-100 px-4 py-4 pb-8">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-xs text-slate-500">Tổng cộng</p>
            <p className="text-blue-700 font-bold" style={{ fontSize: "1.2rem" }}>5.500.000đ<span className="text-sm font-normal text-slate-500">/tháng</span></p>
          </div>
          <button className="bg-blue-600 text-white px-6 py-3.5 rounded-2xl font-semibold shadow-md active:scale-95 transition-transform">
            Đặt lịch xem phòng
          </button>
        </div>
      </div>
    </div>
  );
}
