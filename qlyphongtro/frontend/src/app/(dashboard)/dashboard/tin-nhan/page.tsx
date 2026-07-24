'use client';

import { ChatPanel } from '@/components/chat/ChatPanel';

export default function TinNhanPage() {
  return (
    <div className="flex flex-col gap-4 p-4">
      <div>
        <h1 className="text-xl font-semibold">Tin nhắn</h1>
        <p className="text-sm text-muted-foreground">
          Trao đổi trực tiếp với khách thuê và nhân viên quản lý.
        </p>
      </div>
      <ChatPanel />
    </div>
  );
}
