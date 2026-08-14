"use client";

/**
 * PanoramaViewer - xem phong 360 do (WebGL/three.js qua Photo Sphere Viewer).
 *
 * Day la phan "xem nha 3D": nguoi dung keo chuot / vuot tay de nhin quanh phong,
 * cuon de zoom, bam nut de vao toan man hinh hoac bat che do VR.
 *
 * Thu vien nang (~500KB do keo theo three.js) nen chi tai bang dynamic import
 * khi nguoi dung thuc su mo tab 360 - khong anh huong toc do tai trang danh sach.
 *
 * Anh dau vao phai la anh equirectangular (ti le 2:1), loai anh ma dien thoai
 * chup o che do Photo Sphere hoac may Insta360/Ricoh Theta xuat ra.
 */

import { useEffect, useMemo, useRef, useState } from "react";
import dynamic from "next/dynamic";
import { AnimatePresence, motion } from "motion/react";
import { Compass, Loader2, Maximize2, Move3d, RotateCcw } from "lucide-react";

import { EASE_OUT_EXPO } from "@/components/motion";

// Chi tai o client, va chi khi component nay duoc render.
const ReactPhotoSphereViewer = dynamic(
  () => import("react-photo-sphere-viewer").then((mod) => mod.ReactPhotoSphereViewer),
  {
    ssr: false,
    loading: () => <PanoramaLoading />,
  }
);

function PanoramaLoading() {
  return (
    <div className="flex h-full w-full flex-col items-center justify-center gap-3 bg-[#0F1B2D] text-white">
      <Loader2 size={28} className="animate-spin text-[#4FA7A0]" />
      <p className="text-sm font-semibold">Đang dựng không gian 360°...</p>
      <p className="text-xs text-white/50">Lần đầu có thể mất vài giây</p>
    </div>
  );
}

export interface PanoramaViewerProps {
  /** Danh sach anh 360 (equirectangular, ti le 2:1). */
  panoramas: string[];
  /** Ten hien thi cho tung diem, vd ["Phòng khách", "Ban công"]. */
  labels?: string[];
  height?: string;
  className?: string;
}

export function PanoramaViewer({
  panoramas,
  labels,
  height = "480px",
  className = "",
}: PanoramaViewerProps) {
  const [activeIndex, setActiveIndex] = useState(0);
  const [ready, setReady] = useState(false);
  const [hintVisible, setHintVisible] = useState(true);
  const viewerRef = useRef<{ animate: (o: Record<string, unknown>) => void } | null>(null);

  const src = panoramas[activeIndex];

  // An goi y "keo de nhin quanh" sau 4 giay.
  useEffect(() => {
    if (!ready) return;
    const timer = setTimeout(() => setHintVisible(false), 4000);
    return () => clearTimeout(timer);
  }, [ready]);

  // Doi anh thi hien lai goi y va reset trang thai san sang.
  useEffect(() => {
    setHintVisible(true);
  }, [activeIndex]);

  const resetView = () => {
    viewerRef.current?.animate({ yaw: 0, pitch: 0, zoom: 50, speed: "3rpm" });
  };

  if (!src) return null;

  return (
    <div
      className={`relative overflow-hidden rounded-3xl bg-[#0F1B2D] ring-1 ring-[#243B5A]/15 ${className}`}
      style={{ height }}
    >
      <ReactPhotoSphereViewer
        key={src}
        src={src}
        height="100%"
        width="100%"
        navbar={["zoom", "fullscreen"]}
        defaultZoomLvl={50}
        touchmoveTwoFingers={false}
        mousewheelCtrlKey={false}
        loadingTxt="Đang tải ảnh 360°..."
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        onReady={(instance: any) => {
          viewerRef.current = instance;
          setReady(true);
          // Xoay cham mot vong nho de nguoi dung hieu day la anh 360.
          instance?.animate?.({ yaw: Math.PI / 6, speed: "2rpm" });
        }}
        containerClass="!bg-[#0F1B2D]"
      />

      {/* Nhan "360" goc trai tren */}
      <div className="pointer-events-none absolute left-4 top-4 z-10 flex items-center gap-2 rounded-full bg-black/50 px-3 py-1.5 text-xs font-black text-white backdrop-blur-md ring-1 ring-white/15">
        <Compass size={14} className="text-[#4FA7A0]" />
        Không gian 360°
      </div>

      {/* Nut reset goc nhin */}
      <button
        onClick={resetView}
        title="Về góc nhìn ban đầu"
        className="absolute right-4 top-4 z-10 flex h-9 w-9 items-center justify-center rounded-full bg-black/50 text-white ring-1 ring-white/15 backdrop-blur-md transition hover:scale-110 hover:bg-black/70"
      >
        <RotateCcw size={16} />
      </button>

      {/* Goi y thao tac */}
      <AnimatePresence>
        {hintVisible && (
          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 12 }}
            transition={{ duration: 0.4, ease: EASE_OUT_EXPO }}
            className="pointer-events-none absolute bottom-20 left-1/2 z-10 -translate-x-1/2 whitespace-nowrap rounded-full bg-black/60 px-4 py-2 text-xs font-semibold text-white backdrop-blur-md ring-1 ring-white/15"
          >
            <span className="inline-flex items-center gap-2">
              <Move3d size={15} className="text-[#4FA7A0]" />
              Kéo để nhìn quanh · Cuộn để phóng to
            </span>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Chuyen diem trong tour */}
      {panoramas.length > 1 && (
        <div className="absolute bottom-4 left-1/2 z-10 flex max-w-[92%] -translate-x-1/2 gap-2 overflow-x-auto rounded-full bg-black/50 p-1.5 backdrop-blur-md ring-1 ring-white/15 scrollbar-none">
          {panoramas.map((_, i) => (
            <button
              key={i}
              onClick={() => setActiveIndex(i)}
              className={`shrink-0 whitespace-nowrap rounded-full px-3.5 py-1.5 text-xs font-bold transition ${
                i === activeIndex
                  ? "bg-[#4FA7A0] text-white shadow"
                  : "text-white/70 hover:bg-white/10 hover:text-white"
              }`}
            >
              {labels?.[i] ?? `Điểm ${i + 1}`}
            </button>
          ))}
        </div>
      )}
    </div>
  );
}

/**
 * Nhan dien anh 360: anh equirectangular co ti le rong/cao xap xi 2:1.
 * Nho vay khong can doi schema backend - chu nha chi can upload anh 360
 * vao dung o anh phong san co la he thong tu bat che do 3D.
 */
export function useDetectPanoramas(images: string[]) {
  const [panoramas, setPanoramas] = useState<string[]>([]);
  const key = useMemo(() => images.join("|"), [images]);

  useEffect(() => {
    let cancelled = false;
    if (images.length === 0) {
      setPanoramas([]);
      return;
    }

    const checks = images.map(
      (src) =>
        new Promise<string | null>((resolve) => {
          const img = new Image();
          img.onload = () => {
            const ratio = img.naturalWidth / img.naturalHeight;
            // 2:1 chuan, cho sai so de chua anh 1.9-2.1
            resolve(ratio > 1.9 && ratio < 2.1 && img.naturalWidth >= 2000 ? src : null);
          };
          img.onerror = () => resolve(null);
          img.src = src;
        })
    );

    Promise.all(checks).then((results) => {
      if (cancelled) return;
      setPanoramas(results.filter((item): item is string => Boolean(item)));
    });

    return () => {
      cancelled = true;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [key]);

  return panoramas;
}

/** Nut noi bat de moi nguoi dung vao tour 360. */
export function PanoramaTeaser({ onOpen, count }: { onOpen: () => void; count: number }) {
  return (
    <motion.button
      onClick={onOpen}
      whileHover={{ scale: 1.03 }}
      whileTap={{ scale: 0.97 }}
      className="group relative flex w-full items-center gap-4 overflow-hidden rounded-3xl bg-gradient-to-r from-[#0F1B2D] via-[#17324B] to-[#1B5A5A] p-5 text-left text-white ring-1 ring-white/10"
    >
      {/* Vong sang chay ngang */}
      <span className="pointer-events-none absolute inset-0 -translate-x-full bg-gradient-to-r from-transparent via-white/15 to-transparent transition-transform duration-700 group-hover:translate-x-full" />

      <span className="relative flex h-14 w-14 shrink-0 items-center justify-center rounded-2xl bg-white/10 ring-1 ring-white/20">
        <Move3d size={26} className="text-[#7FE3DA]" />
      </span>
      <span className="relative min-w-0 flex-1">
        <span className="block text-base font-black">Tham quan phòng 360°</span>
        <span className="mt-0.5 block text-sm text-white/70">
          {count} không gian · Kéo để nhìn quanh như đang đứng trong phòng
        </span>
      </span>
      <span className="relative flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-[#4FA7A0] transition-transform group-hover:scale-110">
        <Maximize2 size={17} />
      </span>
    </motion.button>
  );
}
