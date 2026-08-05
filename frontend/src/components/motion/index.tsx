"use client";

/**
 * EasyHouse motion primitives.
 *
 * Bo animation dung chung cho toan bo frontend. Tat ca deu ton trong
 * `prefers-reduced-motion` thong qua `useReducedMotion` cua motion/react.
 *
 * Nguyen tac hoc tu Airbnb / Zillow:
 * - Chuyen dong ngan (0.2-0.6s), easing "ease-out" manh de cam giac nhanh.
 * - Do dich chuyen nho (12-24px), chi chay 1 lan.
 * - Hover chi nang nhe (-4px) + phong anh (1.05) chu khong giat.
 *
 * Ghi chu ve stagger: moi <StaggerItem> tu kich hoat animation cua rieng no,
 * do tre tinh theo chi so (xem StaggerDelayContext), thay vi dung `staggerChildren`
 * cua motion. Ly do: `staggerChildren` la co che orchestration tu parent, chi ap cho
 * nhung con co mat luc parent chay animation. Danh sach o day mount SAU khi API tra
 * du lieu ve, nen cach tu tinh do tre theo chi so on dinh hon voi kieu mount muon.
 *
 * Luu y khi kiem thu bang trinh duyet headless / tab an: motion va CountUp deu chay
 * bang requestAnimationFrame, ma rAF KHONG chay khi document.visibilityState === "hidden".
 * Luc do moi phan tu se dung yen o gia tri `initial` (opacity 0) va CountUp dung o 0.
 * Do la dac diem cua moi truong do, KHONG phai loi giao dien - hay kiem tra
 * document.visibilityState truoc khi ket luan co bug.
 */

import { Children, createContext, useContext, useEffect, useRef, useState } from "react";
import type { ReactNode } from "react";
import {
  motion,
  useInView,
  useMotionValue,
  useReducedMotion,
  useScroll,
  useSpring,
  useTransform,
  type MotionValue,
} from "motion/react";

/** Easing chuan cua he thong: expo-out, cho cam giac "bat ra roi dung lai". */
export const EASE_OUT_EXPO = [0.16, 1, 0.3, 1] as const;
export const EASE_OUT_QUINT = [0.22, 1, 0.36, 1] as const;

/** Spring dung cho tuong tac truc tiep (nut tim, nut bam). */
export const SPRING_SNAPPY = { type: "spring" as const, stiffness: 500, damping: 30 };
export const SPRING_SOFT = { type: "spring" as const, stiffness: 260, damping: 26 };

type Direction = "up" | "down" | "left" | "right" | "none";

const OFFSETS: Record<Direction, { x: number; y: number }> = {
  up: { x: 0, y: 24 },
  down: { x: 0, y: -24 },
  left: { x: 24, y: 0 },
  right: { x: -24, y: 0 },
  none: { x: 0, y: 0 },
};

interface RevealProps {
  children: ReactNode;
  /** Huong bay vao. Mac dinh "up". */
  direction?: Direction;
  /** Tre bao nhieu giay truoc khi chay. */
  delay?: number;
  duration?: number;
  /** Phan tram phan tu phai lot vao viewport moi kich hoat. */
  amount?: number;
  className?: string;
  as?: "div" | "section" | "article" | "li" | "span";
}

/**
 * Hien phan tu khi scroll toi. Chay dung 1 lan.
 * Dung cho section, tieu de, card don le.
 */
export function Reveal({
  children,
  direction = "up",
  delay = 0,
  duration = 0.55,
  amount = 0.2,
  className,
  as = "div",
}: RevealProps) {
  const reduced = useReducedMotion();
  const offset = OFFSETS[direction];

  const MotionTag = motion[as] as typeof motion.div;

  if (reduced) {
    const Tag = as;
    return <Tag className={className}>{children}</Tag>;
  }

  return (
    <MotionTag
      className={className}
      initial={{ opacity: 0, x: offset.x, y: offset.y }}
      whileInView={{ opacity: 1, x: 0, y: 0 }}
      viewport={{ once: true, amount }}
      transition={{ duration, delay, ease: EASE_OUT_EXPO }}
    >
      {children}
    </MotionTag>
  );
}

/**
 * Container cho hieu ung stagger: cac con lan luot hien ra.
 * Dung chung voi <StaggerItem>.
 */
/** Truyen do tre cua tung phan tu con xuong <StaggerItem>. Xem ghi chu dau file. */
const StaggerDelayContext = createContext<{ delay: number; amount: number }>({
  delay: 0,
  amount: 0.15,
});

export function StaggerGroup({
  children,
  className,
  stagger = 0.07,
  delay = 0,
  amount = 0.1,
}: {
  children: ReactNode;
  className?: string;
  stagger?: number;
  delay?: number;
  amount?: number;
}) {
  const reduced = useReducedMotion();

  if (reduced) return <div className={className}>{children}</div>;

  return (
    <div className={className}>
      {Children.map(children, (child, index) => (
        <StaggerDelayContext.Provider value={{ delay: delay + index * stagger, amount }}>
          {child}
        </StaggerDelayContext.Provider>
      ))}
    </div>
  );
}

export function StaggerItem({ children, className }: { children: ReactNode; className?: string }) {
  const reduced = useReducedMotion();
  const { delay, amount } = useContext(StaggerDelayContext);

  if (reduced) return <div className={className}>{children}</div>;

  return (
    <motion.div
      className={className}
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, amount }}
      transition={{ duration: 0.5, delay, ease: EASE_OUT_EXPO }}
    >
      {children}
    </motion.div>
  );
}

/**
 * Dem so tang dan khi phan tu vao viewport.
 * Dung cho cac o thong ke ("120 phong dang dang").
 */
export function CountUp({
  value,
  duration = 1.2,
  className,
  format,
}: {
  value: number;
  duration?: number;
  className?: string;
  format?: (n: number) => string;
}) {
  const reduced = useReducedMotion();
  const ref = useRef<HTMLSpanElement>(null);
  const inView = useInView(ref, { once: true, amount: 0.5 });
  const [display, setDisplay] = useState(0);

  useEffect(() => {
    if (!inView) return;
    if (reduced || duration <= 0) {
      setDisplay(value);
      return;
    }

    let frame = 0;
    const start = performance.now();

    const tick = (now: number) => {
      const progress = Math.min(1, (now - start) / (duration * 1000));
      // ease-out-expo de so nhay nhanh roi cham dan
      const eased = progress === 1 ? 1 : 1 - Math.pow(2, -10 * progress);
      setDisplay(Math.round(value * eased));
      if (progress < 1) frame = requestAnimationFrame(tick);
    };

    frame = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(frame);
  }, [inView, value, duration, reduced]);

  return (
    <span ref={ref} className={className}>
      {format ? format(display) : display.toLocaleString("vi-VN")}
    </span>
  );
}

/**
 * Anh co hieu ung parallax nhe khi scroll (Zillow / Blueground dung nhieu).
 * `strength` la so pixel dich chuyen toi da.
 */
export function ParallaxLayer({
  children,
  strength = 60,
  className,
}: {
  children: ReactNode;
  strength?: number;
  className?: string;
}) {
  const reduced = useReducedMotion();
  const ref = useRef<HTMLDivElement>(null);
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ["start end", "end start"],
  });
  const y = useTransform(scrollYProgress, [0, 1], [strength, -strength]);
  const smoothY = useSpring(y, { stiffness: 120, damping: 30, mass: 0.4 });

  if (reduced) return <div className={className}>{children}</div>;

  return (
    <div ref={ref} className={className}>
      <motion.div style={{ y: smoothY }} className="h-full w-full">
        {children}
      </motion.div>
    </div>
  );
}

/**
 * The nghieng theo con tro (3D tilt) - hoc tu cac trang BDS cao cap.
 * Chi bat tren thiet bi co chuot that (hover: hover).
 */
export function TiltCard({
  children,
  className,
  maxTilt = 8,
  scale = 1.02,
}: {
  children: ReactNode;
  className?: string;
  maxTilt?: number;
  scale?: number;
}) {
  const reduced = useReducedMotion();
  const ref = useRef<HTMLDivElement>(null);
  const rotateX = useMotionValue(0);
  const rotateY = useMotionValue(0);
  const springX = useSpring(rotateX, SPRING_SOFT);
  const springY = useSpring(rotateY, SPRING_SOFT);

  if (reduced) return <div className={className}>{children}</div>;

  const handleMove = (event: React.MouseEvent<HTMLDivElement>) => {
    const node = ref.current;
    if (!node) return;
    const rect = node.getBoundingClientRect();
    const px = (event.clientX - rect.left) / rect.width - 0.5;
    const py = (event.clientY - rect.top) / rect.height - 0.5;
    rotateY.set(px * maxTilt * 2);
    rotateX.set(-py * maxTilt * 2);
  };

  const handleLeave = () => {
    rotateX.set(0);
    rotateY.set(0);
  };

  return (
    <motion.div
      ref={ref}
      className={className}
      onMouseMove={handleMove}
      onMouseLeave={handleLeave}
      whileHover={{ scale }}
      transition={SPRING_SOFT}
      style={{
        rotateX: springX,
        rotateY: springY,
        transformPerspective: 1000,
        transformStyle: "preserve-3d",
      }}
    >
      {children}
    </motion.div>
  );
}

/**
 * Thanh tien do doc trang, gan o dau man hinh.
 */
export function ScrollProgressBar({ className }: { className?: string }) {
  const { scrollYProgress } = useScroll();
  const scaleX = useSpring(scrollYProgress, { stiffness: 200, damping: 30, restDelta: 0.001 });
  return (
    <motion.div
      style={{ scaleX }}
      className={
        className ??
        "fixed left-0 top-0 z-[60] h-[3px] w-full origin-left bg-gradient-to-r from-[#4FA7A0] via-[#4FA7A0] to-[#F2A45B]"
      }
    />
  );
}

/**
 * Hook nho: tra ve MotionValue cua vi tri con tro trong 1 element (0..1).
 * Huu ich khi lam spotlight/glow theo chuot.
 */
export function usePointerPosition<T extends HTMLElement>() {
  const ref = useRef<T>(null);
  const x = useMotionValue(0.5);
  const y = useMotionValue(0.5);

  const onPointerMove = (event: React.PointerEvent<T>) => {
    const node = ref.current;
    if (!node) return;
    const rect = node.getBoundingClientRect();
    x.set((event.clientX - rect.left) / rect.width);
    y.set((event.clientY - rect.top) / rect.height);
  };

  return { ref, x, y, onPointerMove } as {
    ref: React.RefObject<T | null>;
    x: MotionValue<number>;
    y: MotionValue<number>;
    onPointerMove: (event: React.PointerEvent<T>) => void;
  };
}

export { motion, useReducedMotion };
