'use client';

import { ChatPanel } from '@/components/chat/ChatPanel';

export default function TinNhanKhachThuePage() {
  return (
    <div className="flex flex-col gap-4 p-4">
      <div>
        <h1 className="text-xl font-semibold">Tin nhắn</h1>
        <p className="text-sm text-muted-foreground">
          Nhắn tin với ban quản lý hoặc người cùng khu trọ.
        </p>
      </div>
      {/* Khách thuê có thêm nút mở nhanh kênh liên hệ ban quản lý. */}
      <ChatPanel hienNutHoTro />
    </div>
  );
}
