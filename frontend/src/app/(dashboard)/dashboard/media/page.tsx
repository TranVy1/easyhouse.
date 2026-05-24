"use client";

import { MediaClient } from "./media-client";

export default function MediaPage() {
  return (
    <div className="flex-col md:flex">
      <div className="flex-1 space-y-4 p-8 pt-6">
        <MediaClient />
      </div>
    </div>
  );
}
