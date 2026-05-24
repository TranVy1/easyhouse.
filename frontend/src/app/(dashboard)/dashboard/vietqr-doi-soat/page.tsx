"use client";

import { VietQRClient } from "./vietqr-client";

export default function VietQRPage() {
  return (
    <div className="flex-col md:flex">
      <div className="flex-1 space-y-4 p-8 pt-6">
        <VietQRClient />
      </div>
    </div>
  );
}
