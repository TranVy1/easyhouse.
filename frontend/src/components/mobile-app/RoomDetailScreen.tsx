"use client";

import { useEffect, useMemo, useState } from "react";
import {
  ArrowLeft,
  CheckCircle2,
  ChevronDown,
  ChevronUp,
  ExternalLink,
  Heart,
  MapPin,
  Move3d,
  Navigation,
  Share2,
  ShieldCheck,
  Sparkles,
  Square,
  Users,
  Wifi,
  Wind,
  Car,
  Star,
} from "lucide-react";
import { AnimatePresence } from "motion/react";

import { DatLichHenDialog } from "@/components/ui/dat-lich-hen-dialog";
import { Gallery } from "@/components/property/gallery";
import {
  PanoramaTeaser,
  PanoramaViewer,
  useDetectPanoramas,
} from "@/components/property/panorama-viewer";
import { CountUp, Reveal, StaggerGroup, StaggerItem, motion } from "@/components/motion";

const fallbackImages = [
  "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=1200&h=800&fit=crop&auto=format",
  "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=1200&h=800&fit=crop&auto=format",
];

/** Tien ich mac dinh khi chu nha chua khai bao gi. */
const DEFAULT_AMENITIES = ["Wifi", "Máy lạnh", "Bãi xe", "Bảo vệ", "Nội thất"];

function amenityIcon(label: string) {
  const value = label.toLowerCase();
  if (value.includes("wifi") || value.includes("internet")) return <Wifi size={20} />;
  if (value.includes("lạnh") || value.includes("điều hòa") || value.includes("máy lạnh"))
    return <Wind size={20} />;
  if (value.includes("xe") || value.includes("parking") || value.includes("để xe"))
    return <Car size={20} />;
  if (value.includes("bảo vệ") || value.includes("an ninh") || value.includes("camera"))
    return <ShieldCheck size={20} />;
  if (value.includes("nội thất") || value.includes("giường") || value.includes("tủ"))
    return <CheckCircle2 size={20} />;
  return <Sparkles size={20} />;
}

/** Doc danh sach tien ich tu nhieu ten truong khac nhau cua backend. */
function readAmenities(room: Record<string, unknown> | null): string[] {
  if (!room) return DEFAULT_AMENITIES;
  const raw =
    room.tienIchNoiBat ?? room.tienIchList ?? room.tienNghi ?? room.tienIch ?? room.amenities;
  const list = Array.isArray(raw) ? raw : typeof raw === "string" ? raw.split(",") : [];
  const cleaned = list
    .map((item) =>
      typeof item === "string"
        ? item.trim()
        : String((item as Record<string, unknown>)?.ten ?? (item as Record<string, unknown>)?.name ?? "").trim()
    )
    .filter(Boolean);
  return cleaned.length > 0 ? cleaned : DEFAULT_AMENITIES;
}

/** Gom moi nguon anh cua phong thanh 1 mang URL. */
function readImages(room: Record<string, unknown> | null): string[] {
  if (!room) return [];
  const raw = room.anhList ?? room.anhPhong ?? room.hinhAnh ?? [];
  const list = Array.isArray(raw) ? raw : [];
  const urls = list
    .map((item) => {
      if (typeof item === "string") return item;
      const image = (item ?? {}) as Record<string, unknown>;
      return String(image.url ?? image.hinhAnh ?? "");
    })
    .filter(Boolean);

  const cover = room.anhDaiDien;
  if (typeof cover === "string" && cover && !urls.includes(cover)) return [cover, ...urls];
  return urls;
}

interface RoomDetailScreenProps {
  onBack: () => void;
  roomId: string | number;
}

export function RoomDetailScreen({ onBack, roomId }: RoomDetailScreenProps) {
  const [saved, setSaved] = useState(false);
  const [expanded, setExpanded] = useState(false);
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const [roomData, setRoomData] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [isBookingOpen, setIsBookingOpen] = useState(false);
  const [tourOpen, setTourOpen] = useState(false);
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    let cancelled = false;
    setLoading(true);

    fetch("/api/public/phong/" + roomId)
      .then((res) => {
        if (!res.ok) throw new Error("HTTP error " + res.status);
        return res.json();
      })
      .then((data) => {
        if (cancelled) return;
        setRoomData(data?.data || data || null);
        setLoading(false);
      })
      .catch((err) => {
        console.error(err);
        if (!cancelled) setLoading(false);
      });

    return () => {
      cancelled = true;
    };
  }, [roomId]);

  const images = useMemo(() => {
    const found = readImages(roomData);
    return found.length > 0 ? found : fallbackImages;
  }, [roomData]);

  // Tu dong nhan dien anh 360 (ti le 2:1) trong danh sach anh cua phong.
  const panoramas = useDetectPanoramas(images);
  const amenities = useMemo(() => readAmenities(roomData), [roomData]);

  const handleShare = async () => {
    const url = typeof window !== "undefined" ? window.location.href : "";
    try {
      if (navigator.share) {
        await navigator.share({ title: document.title, url });
        return;
      }
      await navigator.clipboard.writeText(url);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch {
      /* nguoi dung huy chia se - khong can bao loi */
    }
  };

  if (loading) return <RoomDetailSkeleton onBack={onBack} />;

  if (!roomData) {
    return (
      <div className="flex min-h-[60vh] flex-col items-center justify-center gap-4 bg-[#F8F3EC] px-6 text-center">
        <div className="flex h-16 w-16 items-center justify-center rounded-2xl bg-white text-[#243B5A] shadow-sm ring-1 ring-[#E8DED2]">
          <MapPin size={28} />
        </div>
        <p className="text-lg font-black text-[#243B5A]">Không tìm thấy phòng này</p>
        <p className="max-w-sm text-sm text-[#6B7A8C]">
          Phòng có thể đã được thuê hoặc chủ nhà đã gỡ tin đăng.
        </p>
        <button
          onClick={onBack}
          className="mt-2 rounded-2xl bg-[#243B5A] px-6 py-3 text-sm font-bold text-white shadow-sm transition hover:bg-[#1b2e47]"
        >
          Quay lại danh sách
        </button>
      </div>
    );
  }

  const roomName =
    roomData.ten || (roomData.soPhong ? `Phòng ${roomData.soPhong}` : roomData.name || "Phòng Trọ");

  const roomPriceRaw = roomData.giaHienTai || roomData.giaThue || roomData.price || 0;
  const priceNumber = Number(roomPriceRaw) || 0;
  const roomPrice =
    priceNumber > 0 ? new Intl.NumberFormat("vi-VN").format(priceNumber) : "Liên hệ";

  const roomLocation =
    roomData.nhaTro?.diaChi || roomData.toaNha?.diaChi || roomData.location || "Chưa cập nhật địa chỉ";
  const hasRoomLocation = Boolean(
    roomData.nhaTro?.diaChi || roomData.toaNha?.diaChi || roomData.location
  );
  const googleMapsEmbedUrl = hasRoomLocation
    ? `https://www.google.com/maps?q=${encodeURIComponent(roomLocation)}&z=16&output=embed`
    : null;
  const googleMapsDirectionsUrl = hasRoomLocation
    ? `https://www.google.com/maps/dir/?api=1&destination=${encodeURIComponent(roomLocation)}`
    : null;
  const roomArea = roomData.dienTich ? `${roomData.dienTich}m²` : "Chưa rõ";
  const maxPeople = Number(roomData.soNguoiToiDa) || 0;

  return (
    <div className="flex w-full flex-col bg-[#F8F3EC] pb-20">
      <div className="relative mx-auto flex w-full max-w-screen-2xl flex-1 flex-col gap-6 px-4 py-6 pb-32 md:px-8">
        {/* ── Thanh dieu huong ── */}
        <motion.div
          initial={{ opacity: 0, y: -12 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4, ease: [0.16, 1, 0.3, 1] }}
          className="flex items-center justify-between rounded-2xl border border-[#E8DED2] bg-[#FFFDF8] px-5 py-3.5 shadow-xs"
        >
          <button
            onClick={onBack}
            className="group flex items-center gap-2 text-sm font-semibold text-[#6B7A8C] transition-colors hover:text-[#243B5A]"
          >
            <ArrowLeft size={16} className="transition-transform group-hover:-translate-x-1" />
            <span>Quay lại danh sách</span>
          </button>
          <div className="flex items-center gap-2">
            <div className="relative">
              <motion.button
                onClick={handleShare}
                whileTap={{ scale: 0.9 }}
                className="flex items-center justify-center rounded-xl border border-[#E8DED2] bg-[#FFFDF8] p-2.5 shadow-xs transition-colors hover:bg-[#F8F3EC]"
                title="Chia sẻ phòng"
              >
                <Share2 size={16} className="text-[#6B7A8C]" />
              </motion.button>
              <AnimatePresence>
                {copied && (
                  <motion.span
                    initial={{ opacity: 0, y: 6, scale: 0.9 }}
                    animate={{ opacity: 1, y: 0, scale: 1 }}
                    exit={{ opacity: 0, y: 6, scale: 0.9 }}
                    className="absolute right-0 top-full z-20 mt-2 whitespace-nowrap rounded-lg bg-[#243B5A] px-3 py-1.5 text-xs font-bold text-white shadow-lg"
                  >
                    Đã sao chép liên kết
                  </motion.span>
                )}
              </AnimatePresence>
            </div>
            <motion.button
              onClick={() => setSaved(!saved)}
              whileTap={{ scale: 0.85 }}
              className="flex items-center justify-center rounded-xl border border-[#E8DED2] bg-[#FFFDF8] p-2.5 shadow-xs transition-colors hover:bg-[#F8F3EC]"
              title={saved ? "Bỏ lưu" : "Lưu phòng"}
            >
              <motion.span key={String(saved)} initial={{ scale: 0.6 }} animate={{ scale: 1 }}>
                <Heart size={16} className={saved ? "fill-red-500 text-red-500" : "text-[#6B7A8C]"} />
              </motion.span>
            </motion.button>
          </div>
        </motion.div>

        {/* ── Bo cuc 2 cot ── */}
        <div className="grid grid-cols-1 items-start gap-8 lg:grid-cols-3">
          <div className="space-y-6 lg:col-span-2">
            {/* Gallery mosaic + lightbox */}
            <Reveal duration={0.5}>
              <Gallery images={images} alt={roomName} />
            </Reveal>

            {/* Tour 360 - chi hien khi phat hien anh equirectangular */}
            {panoramas.length > 0 && (
              <Reveal delay={0.05}>
                {tourOpen ? (
                  <div className="space-y-3">
                    <PanoramaViewer panoramas={panoramas} height="480px" />
                    <button
                      onClick={() => setTourOpen(false)}
                      className="text-sm font-bold text-[#6B7A8C] transition-colors hover:text-[#243B5A]"
                    >
                      Thu gọn tour 360°
                    </button>
                  </div>
                ) : (
                  <PanoramaTeaser onOpen={() => setTourOpen(true)} count={panoramas.length} />
                )}
              </Reveal>
            )}

            {/* Tieu de + dia chi */}
            <Reveal delay={0.08}>
              <div className="space-y-4 rounded-3xl border border-[#E8DED2] bg-[#FFFDF8] p-6 shadow-xs">
                <div className="flex flex-wrap items-center gap-2">
                  <span className="rounded-full bg-[#4FA7A0]/10 px-3 py-1 text-xs font-bold uppercase tracking-wider text-[#267D76]">
                    {roomData.trangThai || "Còn trống"}
                  </span>
                  <span className="rounded-full bg-[#243B5A]/[0.07] px-3 py-1 text-xs font-bold uppercase tracking-wider text-[#243B5A]">
                    {roomArea}
                  </span>
                  {panoramas.length > 0 && (
                    <span className="inline-flex items-center gap-1.5 rounded-full bg-gradient-to-r from-[#17324B] to-[#1B5A5A] px-3 py-1 text-xs font-bold uppercase tracking-wider text-white">
                      <Move3d size={12} /> Có tour 360°
                    </span>
                  )}
                </div>
                <h1 className="text-2xl font-black leading-tight tracking-tight text-[#243B5A] md:text-3xl">
                  {roomName}
                </h1>
                <div className="flex flex-col gap-3 pt-1 text-sm text-[#6B7A8C] sm:flex-row sm:items-center">
                  <div className="flex items-center gap-1.5">
                    <MapPin size={16} className="shrink-0 text-[#FF5A3D]" />
                    <a
                      href={`https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(roomLocation)}`}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="font-medium text-[#243B5A] transition-colors hover:text-[#FF5A3D] hover:underline"
                      title="Xem bản đồ"
                    >
                      {roomLocation}
                    </a>
                  </div>
                  <div className="hidden text-slate-300 sm:block">|</div>
                  <div className="flex items-center gap-1.5">
                    <Star size={14} className="fill-amber-400 text-amber-400" />
                    <span className="font-bold text-[#243B5A]">Tin đã xác thực</span>
                  </div>
                </div>
              </div>
            </Reveal>

            {/* Tien ich - lay tu du lieu that */}
            <Reveal delay={0.1}>
              <div className="space-y-4 rounded-3xl border border-[#E8DED2] bg-[#FFFDF8] p-6 shadow-xs">
                <h2 className="flex items-center gap-2 text-base font-bold text-[#243B5A]">
                  <span className="h-4 w-1.5 rounded-full bg-[#243B5A]" />
                  Tiện ích nổi bật
                </h2>
                <StaggerGroup
                  className="grid grid-cols-2 gap-3 sm:grid-cols-3 md:grid-cols-5"
                  stagger={0.05}
                >
                  {amenities.slice(0, 10).map((label) => (
                    <StaggerItem key={label}>
                      <motion.div
                        whileHover={{ y: -4 }}
                        transition={{ type: "spring", stiffness: 400, damping: 25 }}
                        className="flex h-full flex-col items-center gap-2 rounded-2xl border border-[#E8DED2] bg-[#F8F3EC] p-3 text-center transition-colors hover:border-[#4FA7A0]/40 hover:bg-white"
                      >
                        <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-[#4FA7A0]/10 text-[#243B5A]">
                          {amenityIcon(label)}
                        </div>
                        <span className="text-xs font-semibold leading-tight text-[#243B5A]">
                          {label}
                        </span>
                      </motion.div>
                    </StaggerItem>
                  ))}
                </StaggerGroup>
              </div>
            </Reveal>

            {/* Mo ta */}
            <Reveal delay={0.12}>
              <div className="space-y-3 rounded-3xl border border-[#E8DED2] bg-[#FFFDF8] p-6 shadow-xs">
                <h2 className="flex items-center gap-2 text-base font-bold text-[#243B5A]">
                  <span className="h-4 w-1.5 rounded-full bg-[#243B5A]" />
                  Mô tả chi tiết phòng
                </h2>
                <motion.div initial={false} animate={{ height: "auto" }} className="overflow-hidden">
                  <p
                    className={`whitespace-pre-line text-sm leading-relaxed text-[#6B7A8C] ${
                      !expanded ? "line-clamp-4" : ""
                    }`}
                  >
                    {roomData.moTa ||
                      "Phòng trọ sạch sẽ, thoáng mát, khu dân cư an ninh. Vui lòng liên hệ trực tiếp chủ nhà để biết thêm chi tiết và đặt lịch xem phòng. Các tiện ích điện nước tính theo giá nhà nước."}
                  </p>
                </motion.div>
                <button
                  onClick={() => setExpanded(!expanded)}
                  className="mt-2 flex items-center gap-1 text-sm font-bold text-[#243B5A] transition-colors hover:underline"
                >
                  {expanded ? "Thu gọn mô tả" : "Xem thêm mô tả"}
                  {expanded ? <ChevronUp size={14} /> : <ChevronDown size={14} />}
                </button>
              </div>
            </Reveal>

            {/* Ban do */}
            <Reveal delay={0.14}>
              <div className="space-y-4 rounded-3xl border border-[#E8DED2] bg-[#FFFDF8] p-6 shadow-xs">
                <h2 className="flex items-center gap-2 text-base font-bold text-[#243B5A]">
                  <span className="h-4 w-1.5 rounded-full bg-[#243B5A]" />
                  Vị trí địa lý
                </h2>
                <div className="relative h-56 overflow-hidden rounded-2xl border border-[#E8DED2] bg-slate-100 shadow-xs sm:h-72">
                  {googleMapsEmbedUrl ? (
                    <iframe
                      src={googleMapsEmbedUrl}
                      title={`Bản đồ vị trí ${roomLocation}`}
                      className="h-full w-full border-0"
                      loading="lazy"
                      referrerPolicy="no-referrer-when-downgrade"
                      allowFullScreen
                    />
                  ) : (
                    <div className="flex h-full flex-col items-center justify-center gap-2 px-4 text-center text-sm text-[#6B7A8C]">
                      <MapPin size={24} className="text-[#FF5A3D]" />
                      <span>Chủ nhà chưa cập nhật địa chỉ để hiển thị bản đồ.</span>
                    </div>
                  )}
                  {googleMapsDirectionsUrl && (
                    <a
                      href={googleMapsDirectionsUrl}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="absolute bottom-3 right-3 flex items-center gap-1.5 rounded-lg bg-[#FFFDF8] px-3 py-2 text-xs font-bold text-[#243B5A] shadow-md transition-colors hover:bg-[#F8F3EC]"
                    >
                      <Navigation size={14} className="text-[#FF5A3D]" />
                      Chỉ đường
                      <ExternalLink size={13} />
                    </a>
                  )}
                </div>
              </div>
            </Reveal>
          </div>

          {/* ── Cot phai: gia + dat lich ── */}
          <div className="space-y-4 lg:sticky lg:top-24 lg:col-span-1">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: 0.15, ease: [0.16, 1, 0.3, 1] }}
              className="space-y-6 rounded-3xl border border-[#E8DED2] bg-[#FFFDF8] p-6 shadow-md shadow-slate-100/30"
            >
              <div>
                <p className="text-xs font-bold uppercase tracking-wider text-[#6B7A8C]">
                  Giá thuê tháng
                </p>
                <div className="mt-1 flex items-baseline gap-1">
                  <span className="text-3xl font-black tracking-tight text-[#243B5A]">
                    {priceNumber > 0 ? <CountUp value={priceNumber} duration={1} /> : roomPrice}
                  </span>
                  {priceNumber > 0 && (
                    <span className="text-base font-medium text-[#6B7A8C]">đ/tháng</span>
                  )}
                </div>
              </div>

              <div className="space-y-4 border-t border-[#E8DED2] pt-5">
                <div className="grid grid-cols-2 gap-3">
                  <div className="rounded-2xl border border-[#E8DED2] bg-[#F8F3EC] p-3.5">
                    <span className="flex items-center gap-1 text-[10px] font-bold uppercase text-[#6B7A8C]">
                      <Square size={11} /> Diện tích
                    </span>
                    <span className="mt-0.5 block text-sm font-bold text-[#243B5A]">{roomArea}</span>
                  </div>
                  <div className="rounded-2xl border border-[#E8DED2] bg-[#F8F3EC] p-3.5">
                    <span className="flex items-center gap-1 text-[10px] font-bold uppercase text-[#6B7A8C]">
                      <Users size={11} /> Sức chứa
                    </span>
                    <span className="mt-0.5 block text-sm font-bold text-[#243B5A]">
                      {maxPeople > 0 ? `${maxPeople} người` : "Liên hệ"}
                    </span>
                  </div>
                </div>

                <div className="space-y-2.5 rounded-2xl border border-amber-100/70 bg-amber-50/50 p-4 text-xs">
                  <div className="flex items-center gap-2 font-bold text-amber-800">
                    <ShieldCheck size={16} className="shrink-0 text-amber-600" />
                    <span>Cam kết EasyHouse</span>
                  </div>
                  <ul className="list-disc space-y-1.5 pl-4 font-medium text-amber-900/80">
                    <li>Tin đăng xác thực 100% từ chủ nhà</li>
                    <li>Không qua trung gian, phí môi giới</li>
                    <li>Hỗ trợ hợp đồng thuê nhà điện tử miễn phí</li>
                  </ul>
                </div>
              </div>

              <motion.button
                onClick={() => setIsBookingOpen(true)}
                whileHover={{ scale: 1.02, y: -2 }}
                whileTap={{ scale: 0.98 }}
                transition={{ type: "spring", stiffness: 400, damping: 25 }}
                className="flex w-full cursor-pointer items-center justify-center gap-2 rounded-2xl bg-[#FF5A3D] px-6 py-4 text-sm font-bold text-white shadow-md shadow-orange-200 md:text-base"
              >
                Đặt lịch xem phòng
              </motion.button>

              <p className="px-2 text-center text-[11px] font-medium leading-normal text-[#6B7A8C]">
                Hỗ trợ thủ tục đặt cọc và tham quan nhà trọ 24/7 hoàn toàn miễn phí
              </p>
            </motion.div>
          </div>
        </div>
      </div>

      {/* ── Thanh gia dinh duoi (mobile) ── */}
      <motion.div
        initial={{ y: 100 }}
        animate={{ y: 0 }}
        transition={{ duration: 0.4, delay: 0.2, ease: [0.16, 1, 0.3, 1] }}
        className="fixed bottom-0 left-0 z-20 flex w-full items-center justify-between border-t border-[#E8DED2] bg-[#FFFDF8] px-5 py-4 pb-8 shadow-xl lg:hidden"
      >
        <div>
          <p className="text-xs font-bold uppercase tracking-wider text-[#6B7A8C]">Giá thuê</p>
          <p className="text-[#243B5A]" style={{ fontSize: "1.2rem", fontWeight: 700 }}>
            {roomPrice}
            {priceNumber > 0 && (
              <span className="text-sm font-normal text-[#6B7A8C]">đ/tháng</span>
            )}
          </p>
        </div>
        <motion.button
          onClick={() => setIsBookingOpen(true)}
          whileTap={{ scale: 0.95 }}
          className="cursor-pointer rounded-2xl bg-[#FF5A3D] px-6 py-3.5 text-sm font-bold text-white shadow-md shadow-orange-200"
        >
          Đặt lịch xem phòng
        </motion.button>
      </motion.div>

      <DatLichHenDialog
        isOpen={isBookingOpen}
        onClose={() => setIsBookingOpen(false)}
        phongId={String(roomData._id || roomData.id || roomId)}
        maPhong={roomName}
      />
    </div>
  );
}

/** Khung xuong khi dang tai - thay cho dong chu "Dang tai...". */
function RoomDetailSkeleton({ onBack }: { onBack: () => void }) {
  return (
    <div className="flex w-full flex-col bg-[#F8F3EC] pb-20">
      <div className="mx-auto flex w-full max-w-screen-2xl flex-col gap-6 px-4 py-6 md:px-8">
        <div className="flex items-center justify-between rounded-2xl border border-[#E8DED2] bg-[#FFFDF8] px-5 py-3.5">
          <button
            onClick={onBack}
            className="flex items-center gap-2 text-sm font-semibold text-[#6B7A8C]"
          >
            <ArrowLeft size={16} />
            <span>Quay lại danh sách</span>
          </button>
          <div className="skeleton-shimmer h-9 w-20 rounded-xl" />
        </div>

        <div className="grid grid-cols-1 items-start gap-8 lg:grid-cols-3">
          <div className="space-y-6 lg:col-span-2">
            <div className="skeleton-shimmer h-[240px] w-full rounded-3xl md:h-[420px]" />
            <div className="space-y-4 rounded-3xl border border-[#E8DED2] bg-[#FFFDF8] p-6">
              <div className="skeleton-shimmer h-6 w-24 rounded-full" />
              <div className="skeleton-shimmer h-8 w-2/3 rounded-lg" />
              <div className="skeleton-shimmer h-4 w-1/2 rounded-full" />
            </div>
            <div className="space-y-4 rounded-3xl border border-[#E8DED2] bg-[#FFFDF8] p-6">
              <div className="skeleton-shimmer h-5 w-40 rounded-full" />
              <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 md:grid-cols-5">
                {Array.from({ length: 5 }).map((_, i) => (
                  <div key={i} className="skeleton-shimmer h-24 rounded-2xl" />
                ))}
              </div>
            </div>
          </div>
          <div className="space-y-4 rounded-3xl border border-[#E8DED2] bg-[#FFFDF8] p-6 lg:col-span-1">
            <div className="skeleton-shimmer h-4 w-28 rounded-full" />
            <div className="skeleton-shimmer h-9 w-40 rounded-lg" />
            <div className="grid grid-cols-2 gap-3 pt-2">
              <div className="skeleton-shimmer h-16 rounded-2xl" />
              <div className="skeleton-shimmer h-16 rounded-2xl" />
            </div>
            <div className="skeleton-shimmer h-28 rounded-2xl" />
            <div className="skeleton-shimmer h-14 rounded-2xl" />
          </div>
        </div>
      </div>
    </div>
  );
}
