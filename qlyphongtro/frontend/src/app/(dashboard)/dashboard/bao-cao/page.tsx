"use client";

import { BaoCaoClient } from "./bao-cao-client";

export default function BaoCaoPage() {
  return (
    <div className="flex-col md:flex">
      <div className="flex-1 space-y-4 p-8 pt-6">
        <BaoCaoClient />
      </div>
    </div>
  );
}
