"use client";

/**
 * HomeSideDecorations — using the exact animated illustrations from AuthLayout
 * for the homepage sides.
 *
 * Rules:
 *  - pointer-events: none  → never blocks user interaction
 *  - aria-hidden="true"    → purely decorative
 *  - Only visible lg+ (1024px+); hidden on mobile
 */

import { IllustrationLeft, IllustrationRight } from "@/components/auth/AuthIllustration";

export function LeftSideDecoration() {
  return (
    <div
      aria-hidden="true"
      className="pointer-events-none absolute left-0 top-[15vh] z-0 hidden w-[200px] xl:w-[260px] 2xl:w-[300px] lg:flex flex-col opacity-90"
    >
      <IllustrationLeft />
    </div>
  );
}

export function RightSideDecoration() {
  return (
    <div
      aria-hidden="true"
      className="pointer-events-none absolute right-0 top-[25vh] z-0 hidden w-[200px] xl:w-[260px] 2xl:w-[300px] lg:flex flex-col opacity-90"
    >
      <IllustrationRight />
    </div>
  );
}

