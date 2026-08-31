"use client";

/**
 * PropertyCard - the phong kieu Airbnb.
 *
 * Hoc tu Airbnb / Zillow:
 * - Anh la chinh: khung ti le co dinh, bo goc, carousel truot ngay trong the.
 * - Mui ten prev/next chi hien khi hover (desktop), vuot tay tren mobile.
 * - Dots gioi han 5 cham, cham giua thu nho dan khi nhieu anh.
 * - Nut tim goc phai tren, bung ra bang spring khi bam.
 * - Badge trang thai goc trai tren.
 * - Hover: the nang -4px, anh phong 1.06, do bong sau hon.
 */

import { useCallback, useRef, useState } from "react";
import type { MouseEvent, ReactNode } from "react";
import { AnimatePresence, motion, useReducedMotion } from "motion/react";
import { Building2, ChevronLeft, ChevronRight, Heart, MapPin } from "lucide-react";

import { EASE_OUT_EXPO, SPRING_SNAPPY } from "@/components/motion";

export interface PropertyCardData {
  id: string | number;
  name: string;
  location: string;
  priceLabel: string;
  areaLabel: string;
  description?: string;
  images: string[];
  amenities?: string[];
  /** Badge tu do o goc trai tren, vd "Con phong" / "Noi bat". */
  badge?: { label: string; tone?: "teal" | "navy" | "orange" };
  /** Nhan phu duoi anh, vd "3 nguoi". */
  meta?: ReactNode;
}

const TONE_CLASS: Record<NonNullable<NonNullable<PropertyCardData["badge"]>["tone"]>, string> = {
  teal: "bg-[#4FA7A0]/95 text-white ring-white/25",
  navy: "bg-[#243B5A]/95 text-white ring-white/20",
  orange: "bg-[#F2A45B] text-white ring-white/30",
};

interface PropertyCardProps {
  room: PropertyCardData;
  saved?: boolean;
  onSelect?: () => void;
  onToggleSave?: (event: MouseEvent) => void;
  /** Ti le khung anh. Mac dinh 4/3 giong Airbnb list. */
  aspect?: string;
  className?: string;
  priority?: boolean;
}

export function PropertyCard({
  room,
  saved = false,
  onSelect,
  onToggleSave,
  aspect = "aspect-[4/3]",
  className = "",
}: PropertyCardProps) {
  const reduced = useReducedMotion();
  const images = room.images?.filter(Boolean) ?? [];
  const hasCarousel = images.length > 1;

  const [index, setIndex] = useState(0);
  const [direction, setDirection] = useState(0);
  const touchStartX = useRef<number | null>(null);

  const go = useCallback(
    (next: number, dir: number, event?: MouseEvent) => {
      event?.stopPropagation();
      event?.preventDefault();
      if (images.length === 0) return;
      setDirection(dir);
      setIndex(((next % images.length) + images.length) % images.length);
    },
    [images.length]
  );

  const handleTouchStart = (event: React.TouchEvent) => {
    touchStartX.current = event.touches[0]?.clientX ?? null;
  };

  const handleTouchEnd = (event: React.TouchEvent) => {
    const start = touchStartX.current;
    touchStartX.current = null;
    if (start === null || !hasCarousel) return;
    const delta = (event.changedTouches[0]?.clientX ?? start) - start;
    if (Math.abs(delta) < 40) return;
    go(delta < 0 ? index + 1 : index - 1, delta < 0 ? 1 : -1);
  };

  // Dots: chi hien toi da 5, truot cua so quanh anh hien tai.
  const dotWindow = 5;
  const dotStart = Math.max(0, Math.min(index - 2, images.length - dotWindow));
  const dots = images.slice(dotStart, dotStart + dotWindow);

  const slideVariants = {
    enter: (dir: number) => ({ opacity: 0, x: reduced ? 0 : dir * 40 }),
    center: { opacity: 1, x: 0 },
    exit: (dir: number) => ({ opacity: 0, x: reduced ? 0 : dir * -40 }),
  };

  return (
    <motion.article
      onClick={onSelect}
      className={`group relative cursor-pointer overflow-hidden rounded-[22px] bg-[#FFFCF8] text-left shadow-[0_12px_30px_rgba(36,59,90,0.08)] ring-1 ring-[#243B5A]/[0.08] transition-all duration-300 hover:shadow-[0_20px_48px_rgba(36,59,90,0.12)] hover:ring-[#4FA7A0]/40 ${className}`}
      initial={false}
      whileHover={reduced ? undefined : { y: -5 }}
      transition={{ duration: 0.25, ease: EASE_OUT_EXPO }}
    >
      {/* ---- Khung anh + carousel ---- */}
      <div
        className={`relative w-full overflow-hidden bg-[#EDE5D9] ${aspect}`}
        onTouchStart={handleTouchStart}
        onTouchEnd={handleTouchEnd}
      >
        {images.length > 0 ? (
          <AnimatePresence initial={false} custom={direction} mode="popLayout">
            <motion.img
              key={`${room.id}-${index}`}
              src={images[index]}
              alt={`${room.name} - anh ${index + 1}`}
              custom={direction}
              variants={slideVariants}
              initial="enter"
              animate="center"
              exit="exit"
              transition={{ duration: 0.35, ease: EASE_OUT_EXPO }}
              loading="lazy"
              className="absolute inset-0 h-full w-full object-cover transition-transform duration-500 ease-out group-hover:scale-[1.06] motion-reduce:group-hover:scale-100"
            />
          </AnimatePresence>
        ) : (
          <div className="relative flex h-full w-full items-center justify-center overflow-hidden bg-gradient-to-br from-[#EEF7F6] via-[#F8F3EC] to-[#EDE5D9]">
            {/* Ambient blobs */}
            <motion.div
              className="absolute -left-6 -top-6 h-28 w-28 rounded-full bg-[#4FA7A0]/18 blur-[40px]"
              animate={{ x: [0, 8, 0], y: [0, 10, 0] }}
              transition={{ duration: 10, repeat: Infinity, ease: "easeInOut" }}
            />
            <motion.div
              className="absolute -bottom-6 -right-6 h-24 w-24 rounded-full bg-[#F2A45B]/14 blur-[36px]"
              animate={{ x: [0, -8, 0], y: [0, -10, 0] }}
              transition={{ duration: 13, repeat: Infinity, ease: "easeInOut", delay: 3 }}
            />
            {/* Dot pattern */}
            <div className="absolute inset-0 bg-[radial-gradient(#243B5A_1px,transparent_1px)] [background-size:18px_18px] opacity-[0.025]" />
            {/* Dotted ring */}
            <svg className="absolute opacity-[0.12]" width="80" height="80" viewBox="0 0 80 80" fill="none">
              <circle cx="40" cy="40" r="34" stroke="#4FA7A0" strokeWidth="1.5" strokeDasharray="5 7" />
            </svg>
            {/* Center icon */}
            <div className="relative flex flex-col items-center gap-2.5 text-center">
              <motion.div
                animate={{ y: [-3, 3, -3] }}
                transition={{ duration: 4, repeat: Infinity, ease: "easeInOut" }}
                className="flex h-14 w-14 items-center justify-center rounded-2xl bg-white/70 text-[#243B5A]/75 shadow-sm ring-1 ring-[#E8DED1]/60 backdrop-blur-sm"
              >
                <Building2 size={26} strokeWidth={1.5} />
              </motion.div>
              <span className="rounded-full bg-white/60 px-3 py-1 text-[10px] font-semibold uppercase tracking-wider text-[#6B7A8C]/80 ring-1 ring-[#E8DED1]/50 backdrop-blur-sm">
                Chưa có ảnh
              </span>
            </div>
          </div>
        )}

        {/* Lop phu gradient de chu/badge luon doc duoc */}
        <div className="pointer-events-none absolute inset-0 bg-gradient-to-t from-[#243B5A]/45 via-transparent to-[#243B5A]/10" />

        {/* Badge trang thai */}
        {room.badge && (
          <span
            className={`absolute left-3 top-3 inline-flex items-center rounded-full px-3 py-1 text-[11px] font-extrabold shadow-sm ring-1 backdrop-blur-sm ${
              TONE_CLASS[room.badge.tone ?? "teal"]
            }`}
          >
            {room.badge.label}
          </span>
        )}

        {/* Nut luu - bung bang spring */}
        {onToggleSave && (
          <motion.button
            onClick={(event) => {
              event.stopPropagation();
              onToggleSave(event);
            }}
            aria-label={saved ? "Bỏ lưu phòng" : "Lưu phòng"}
            aria-pressed={saved}
            className="absolute right-3 top-3 z-10 flex h-9 w-9 items-center justify-center rounded-full bg-white/95 text-[#243B5A] shadow-sm ring-1 ring-white/70 backdrop-blur"
            whileTap={reduced ? undefined : { scale: 0.82 }}
            whileHover={reduced ? undefined : { scale: 1.1 }}
            transition={SPRING_SNAPPY}
          >
            <motion.span
              key={String(saved)}
              initial={reduced ? false : { scale: 0.6 }}
              animate={{ scale: 1 }}
              transition={SPRING_SNAPPY}
              className="flex"
            >
              <Heart size={17} className={saved ? "fill-[#F2A45B] text-[#F2A45B]" : ""} />
            </motion.span>
          </motion.button>
        )}

        {/* Mui ten prev/next - chi hien khi hover tren desktop */}
        {hasCarousel && (
          <>
            <button
              onClick={(event) => go(index - 1, -1, event)}
              aria-label="Ảnh trước"
              className="absolute left-2 top-1/2 z-10 flex h-8 w-8 -translate-y-1/2 items-center justify-center rounded-full bg-white/90 text-[#243B5A] opacity-0 shadow-md ring-1 ring-black/5 backdrop-blur transition-all duration-200 hover:scale-110 hover:bg-white focus-visible:opacity-100 group-hover:opacity-100"
            >
              <ChevronLeft size={17} />
            </button>
            <button
              onClick={(event) => go(index + 1, 1, event)}
              aria-label="Ảnh tiếp theo"
              className="absolute right-2 top-1/2 z-10 flex h-8 w-8 -translate-y-1/2 items-center justify-center rounded-full bg-white/90 text-[#243B5A] opacity-0 shadow-md ring-1 ring-black/5 backdrop-blur transition-all duration-200 hover:scale-110 hover:bg-white focus-visible:opacity-100 group-hover:opacity-100"
            >
              <ChevronRight size={17} />
            </button>

            {/* Dots */}
            <div className="absolute bottom-3 left-1/2 z-10 flex -translate-x-1/2 items-center gap-1.5">
              {dots.map((_, i) => {
                const realIndex = dotStart + i;
                const active = realIndex === index;
                return (
                  <motion.span
                    key={realIndex}
                    animate={{
                      scale: active ? 1 : 0.7,
                      opacity: active ? 1 : 0.6,
                    }}
                    transition={{ duration: 0.2, ease: EASE_OUT_EXPO }}
                    className="h-1.5 w-1.5 rounded-full bg-white shadow-[0_1px_3px_rgba(0,0,0,0.4)]"
                  />
                );
              })}
            </div>

            {/* Dem anh */}
            <span className="absolute bottom-3 right-3 z-10 rounded-full bg-black/45 px-2 py-0.5 text-[10px] font-bold text-white backdrop-blur-sm">
              {index + 1}/{images.length}
            </span>
          </>
        )}
      </div>

      {/* ---- Phan thong tin ---- */}
      <div className="p-4 sm:p-5">
        <div className="flex items-start justify-between gap-3">
          <h3 className="line-clamp-1 text-base font-black tracking-tight text-[#243B5A] sm:text-lg">
            {room.name}
          </h3>
          <p className="shrink-0 text-right text-sm font-black text-[#F2A45B] sm:text-base">
            {room.priceLabel}
          </p>
        </div>

        <p className="mt-1.5 flex items-center gap-1.5 text-sm font-medium text-[#6B7A8C]">
          <MapPin size={14} className="shrink-0 text-[#4FA7A0]" />
          <span className="line-clamp-1">{room.location}</span>
        </p>

        {room.description && (
          <p className="mt-2 line-clamp-2 min-h-[40px] text-sm leading-6 text-[#6B7A8C]">
            {room.description}
          </p>
        )}

        <div className="mt-3 flex flex-wrap items-center gap-2 text-xs font-bold">
          <span className="rounded-full bg-[#F8F3EC] px-2.5 py-1 text-[#243B5A]">{room.areaLabel}</span>
          {room.meta}
          {room.amenities?.slice(0, 2).map((amenity) => (
            <span
              key={`${room.id}-${amenity}`}
              className="rounded-full bg-[#4FA7A0]/10 px-2.5 py-1 text-[#267D76]"
            >
              {amenity}
            </span>
          ))}
        </div>
      </div>

      {/* Vien sang khi hover */}
      <div className="pointer-events-none absolute inset-0 rounded-[22px] ring-1 ring-inset ring-[#4FA7A0]/0 transition-all duration-300 group-hover:ring-[#4FA7A0]/30" />
    </motion.article>
  );
}

/** Skeleton dung khi dang tai danh sach - shimmer thay vi chu "Dang tai...". */
export function PropertyCardSkeleton({ aspect = "aspect-[4/3]" }: { aspect?: string }) {
  return (
    <div className="overflow-hidden rounded-[22px] bg-[#FFFCF8] ring-1 ring-[#243B5A]/[0.08]">
      <div className={`skeleton-shimmer w-full ${aspect}`} />
      <div className="space-y-3 p-5">
        <div className="flex items-center justify-between gap-3">
          <div className="skeleton-shimmer h-4 w-1/2 rounded-full" />
          <div className="skeleton-shimmer h-4 w-20 rounded-full" />
        </div>
        <div className="skeleton-shimmer h-3 w-2/3 rounded-full" />
        <div className="skeleton-shimmer h-3 w-full rounded-full" />
        <div className="flex gap-2 pt-1">
          <div className="skeleton-shimmer h-6 w-16 rounded-full" />
          <div className="skeleton-shimmer h-6 w-20 rounded-full" />
        </div>
      </div>
    </div>
  );
}
