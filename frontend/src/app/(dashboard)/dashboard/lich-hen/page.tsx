"use client";

import { LichHenClient } from "./lich-hen-client";

export default function LichHenPage() {
  return (
    <div className="flex-col md:flex">
      <div className="flex-1 space-y-4 p-8 pt-6">
        <LichHenClient />
      </div>
    </div>
  );
}
