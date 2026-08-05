"use client";

/**
 * Gallery - luoi anh + lightbox toan man hinh, hoc tu Airbnb / Zillow.
 *
 * - Desktop: mosaic 1 anh lon ben trai + 4 anh nho ben phai, nut "Xem tất cả ảnh".
 * - Mobile: 1 anh lon vuot ngang duoc.
 * - Lightbox: nen mo, dieu huong bang phim mui ten / Esc, vuot tay tren mobile,
 *   dai thumbnail o duoi, dem anh o tren.
 */

import { useCallback, useEffect, useRef, useState } from "react";
import { createPortal } from "react-dom";
import { AnimatePresence, motion, useReducedMotion } from "motion/react";
import { Building2, ChevronLeft, ChevronRight, Grid3x3, X } from "lucide-react";

import { EASE_OUT_EXPO } from "@/components/motion";

interface GalleryProps {
  images: string[];
  alt: string;
  /** Noi dung phu chen vao goc anh lon, vd nut mo tour 360. */
  overlay?: React.ReactNode;
  className?: string;
}

function Placeholder({ className = "" }: { className?: string }) {
  return (
    <div
      className={`flex items-center justify-center bg-gradient-to-br from-[#F8F3EC] via-white to-[#DCEFEB] ${className}`}
    >
      <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-white/85 text-[#243B5A] shadow-sm ring-1 ring-[#E3D8CA]">
        <Building2 size={26} />
      </div>
    </div>
  );
}

export function Gallery({ images, alt, overlay, className = "" }: GalleryProps) {
  const reduced = useReducedMotion();
  const [lightboxIndex, setLightboxIndex] = useState<number | null>(null);
  const list = images.filter(Boolean);
  const [main, ...rest] = list;
  const side = rest.slice(0, 4);

  const open = (index: number) => setLightboxIndex(index);

  return (
    <>
      <div className={`relative ${className}`}>
        {/* --- Mosaic desktop --- */}
        <div className="hidden gap-2 overflow-hidden rounded-3xl md:grid md:h-[420px] md:grid-cols-4 md:grid-rows-2">
          <motion.button
            onClick={() => open(0)}
            className="group relative col-span-2 row-span-2 overflow-hidden bg-[#EDE5D9]"
            whileHover={reduced ? undefined : { scale: 1.005 }}
            transition={{ duration: 0.3, ease: EASE_OUT_EXPO }}
          >
            {main ? (
              <img
                src={main}
                alt={`${alt} - ảnh chính`}
                className="h-full w-full object-cover transition-transform duration-700 ease-out group-hover:scale-[1.06] motion-reduce:group-hover:scale-100"
              />
            ) : (
              <Placeholder className="h-full w-full" />
            )}
            <span className="pointer-events-none absolute inset-0 bg-black/0 transition-colors duration-300 group-hover:bg-black/10" />
          </motion.button>

          {Array.from({ length: 4 }).map((_, i) => {
            const src = side[i];
            return (
              <button
                key={i}
                onClick={() => src && open(i + 1)}
                className="group relative overflow-hidden bg-[#EDE5D9]"
                disabled={!src}
              >
                {src ? (
                  <>
                    <img
                      src={src}
                      alt={`${alt} - ảnh ${i + 2}`}
                      loading="lazy"
                      className="h-full w-full object-cover transition-transform duration-700 ease-out group-hover:scale-[1.08] motion-reduce:group-hover:scale-100"
                    />
                    <span className="pointer-events-none absolute inset-0 bg-black/0 transition-colors duration-300 group-hover:bg-black/10" />
                  </>
                ) : (
                  <Placeholder className="h-full w-full" />
                )}
              </button>
            );
          })}
        </div>

        {/* --- Mobile: 1 anh lon --- */}
        <button
          onClick={() => open(0)}
          className="relative block h-[240px] w-full overflow-hidden rounded-3xl bg-[#EDE5D9] sm:h-[320px] md:hidden"
        >
          {main ? (
            <img src={main} alt={alt} className="h-full w-full object-cover" />
          ) : (
            <Placeholder className="h-full w-full" />
          )}
        </button>

        {/* Nut xem tat ca */}
        {list.length > 1 && (
          <motion.button
            onClick={() => open(0)}
            whileHover={reduced ? undefined : { scale: 1.04, y: -2 }}
            whileTap={{ scale: 0.97 }}
            className="absolute bottom-4 right-4 z-10 inline-flex items-center gap-2 rounded-xl bg-white/95 px-4 py-2.5 text-sm font-black text-[#243B5A] shadow-lg ring-1 ring-black/5 backdrop-blur"
          >
            <Grid3x3 size={16} />
            Xem tất cả {list.length} ảnh
          </motion.button>
        )}

        {overlay}
      </div>

      <Lightbox
        images={list}
        alt={alt}
        index={lightboxIndex}
        onClose={() => setLightboxIndex(null)}
        onIndexChange={setLightboxIndex}
      />
    </>
  );
}

interface LightboxProps {
  images: string[];
  alt: string;
  index: number | null;
  onClose: () => void;
  onIndexChange: (index: number) => void;
}

export function Lightbox({ images, alt, index, onClose, onIndexChange }: LightboxProps) {
  const reduced = useReducedMotion();
  const [mounted, setMounted] = useState(false);
  const [direction, setDirection] = useState(0);
  const touchStartX = useRef<number | null>(null);

  useEffect(() => setMounted(true), []);

  const isOpen = index !== null;

  const go = useCallback(
    (delta: number) => {
      if (index === null || images.length === 0) return;
      setDirection(delta);
      onIndexChange((index + delta + images.length) % images.length);
    },
    [index, images.length, onIndexChange]
  );

  // Dieu huong ban phim + khoa scroll nen.
  useEffect(() => {
    if (!isOpen) return;

    const onKey = (event: KeyboardEvent) => {
      if (event.key === "Escape") onClose();
      if (event.key === "ArrowRight") go(1);
      if (event.key === "ArrowLeft") go(-1);
    };

    const previousOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    window.addEventListener("keydown", onKey);

    return () => {
      document.body.style.overflow = previousOverflow;
      window.removeEventListener("keydown", onKey);
    };
  }, [isOpen, go, onClose]);

  if (!mounted) return null;

  return createPortal(
    <AnimatePresence>
      {isOpen && index !== null && (
        <motion.div
          key="eh-lightbox"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          transition={{ duration: 0.25 }}
          className="fixed inset-0 z-[100] flex flex-col bg-[#0B1220]/97 backdrop-blur-sm"
          onClick={onClose}
        >
          {/* Thanh tren */}
          <div
            className="flex shrink-0 items-center justify-between px-5 py-4 text-white"
            onClick={(event) => event.stopPropagation()}
          >
            <span className="rounded-full bg-white/10 px-3.5 py-1.5 text-sm font-bold tabular-nums">
              {index + 1} / {images.length}
            </span>
            <button
              onClick={onClose}
              aria-label="Đóng"
              className="flex h-10 w-10 items-center justify-center rounded-full bg-white/10 transition hover:scale-110 hover:bg-white/20"
            >
              <X size={20} />
            </button>
          </div>

          {/* Anh chinh */}
          <div
            className="relative flex min-h-0 flex-1 items-center justify-center px-4"
            onClick={(event) => event.stopPropagation()}
            onTouchStart={(event) => {
              touchStartX.current = event.touches[0]?.clientX ?? null;
            }}
            onTouchEnd={(event) => {
              const start = touchStartX.current;
              touchStartX.current = null;
              if (start === null) return;
              const delta = (event.changedTouches[0]?.clientX ?? start) - start;
              if (Math.abs(delta) > 50) go(delta < 0 ? 1 : -1);
            }}
          >
            <motion.img
              key={index}
              src={images[index]}
              alt={`${alt} - ảnh ${index + 1}`}
              initial={reduced ? false : { opacity: 0, x: direction * 60, scale: 0.97 }}
              animate={{ opacity: 1, x: 0, scale: 1 }}
              transition={{ duration: 0.3, ease: EASE_OUT_EXPO }}
              className="max-h-full max-w-full rounded-2xl object-contain shadow-2xl"
            />

            {images.length > 1 && (
              <>
                <button
                  onClick={() => go(-1)}
                  aria-label="Ảnh trước"
                  className="absolute left-4 flex h-12 w-12 items-center justify-center rounded-full bg-white/10 text-white backdrop-blur transition hover:scale-110 hover:bg-white/20"
                >
                  <ChevronLeft size={24} />
                </button>
                <button
                  onClick={() => go(1)}
                  aria-label="Ảnh tiếp theo"
                  className="absolute right-4 flex h-12 w-12 items-center justify-center rounded-full bg-white/10 text-white backdrop-blur transition hover:scale-110 hover:bg-white/20"
                >
                  <ChevronRight size={24} />
                </button>
              </>
            )}
          </div>

          {/* Dai thumbnail */}
          {images.length > 1 && (
            <div
              className="scrollbar-none flex shrink-0 gap-2 overflow-x-auto px-5 py-4"
              onClick={(event) => event.stopPropagation()}
            >
              {images.map((src, i) => (
                <button
                  key={i}
                  onClick={() => {
                    setDirection(i > index ? 1 : -1);
                    onIndexChange(i);
                  }}
                  className={`relative h-16 w-24 shrink-0 overflow-hidden rounded-lg transition-all duration-200 ${
                    i === index
                      ? "ring-2 ring-[#4FA7A0] ring-offset-2 ring-offset-[#0B1220]"
                      : "opacity-50 hover:opacity-100"
                  }`}
                >
                  <img src={src} alt="" loading="lazy" className="h-full w-full object-cover" />
                </button>
              ))}
            </div>
          )}
        </motion.div>
      )}
    </AnimatePresence>,
    document.body
  );
}
