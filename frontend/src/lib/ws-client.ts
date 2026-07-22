'use client';

import { Client, type IMessage } from '@stomp/stompjs';

/**
 * Client WebSocket/STOMP dùng chung cho chat.
 *
 * Vì sao nối THẲNG tới backend mà không đi qua /api như các lời gọi khác:
 * rewrites() của Next.js chỉ proxy HTTP, không nâng cấp được kết nối WebSocket.
 * Vì vậy cần biến NEXT_PUBLIC_WS_URL trỏ trực tiếp tới backend.
 * (Cloudflare Tunnel proxy WebSocket sẵn nên production không cần cấu hình thêm.)
 *
 * Đây là singleton: nhiều tab của cùng người dùng vẫn là nhiều kết nối, nhưng
 * trong MỘT tab thì mọi component dùng chung một kết nối.
 */

export type ChatSocketState = 'idle' | 'connecting' | 'connected' | 'disconnected';

type Handler = (payload: unknown) => void;

const WS_URL =
  process.env.NEXT_PUBLIC_WS_URL ||
  (typeof window !== 'undefined' && window.location.hostname === 'localhost'
    ? 'ws://localhost:8080/ws'
    : '');

/** Backoff luỹ thừa: 1s → 2s → 4s … tối đa 30s, để không dội bom server khi nó đang chết. */
const DELAY_DAU = 1000;
const DELAY_TOI_DA = 30000;

class ChatSocket {
  private client: Client | null = null;
  private state: ChatSocketState = 'idle';
  private delayHienTai = DELAY_DAU;

  private handlersTinNhan = new Set<Handler>();
  private handlersTrangThai = new Set<Handler>();
  private handlersState = new Set<(s: ChatSocketState) => void>();

  /** Gọi mỗi lần (re)connect để lấy lại token còn hạn — xem beforeConnect. */
  private async layTokenMoi(): Promise<string | null> {
    try {
      // Chạm vào endpoint session của NextAuth sẽ kích hoạt callback jwt, tự refresh
      // access token nếu đã hết hạn. Nếu không làm bước này, WebSocket sẽ chết im
      // lặng khi token hết hạn và không bao giờ nối lại được.
      const res = await fetch('/api/auth/session');
      if (!res.ok) return null;
      const session = await res.json();
      return session?.accessToken ?? null;
    } catch {
      return null;
    }
  }

  private datState(s: ChatSocketState) {
    if (this.state === s) return;
    this.state = s;
    this.handlersState.forEach((h) => h(s));
  }

  connect() {
    if (this.client || !WS_URL) {
      if (!WS_URL) {
        console.warn('[chat] Thiếu NEXT_PUBLIC_WS_URL — chat realtime sẽ không hoạt động.');
      }
      return;
    }

    this.datState('connecting');

    const client = new Client({
      brokerURL: WS_URL,
      // Nhịp tim phải khớp phía server (25s). Cloudflare gói Free/Pro đóng
      // WebSocket sau ~100s không có dữ liệu đi qua.
      heartbeatIncoming: 25000,
      heartbeatOutgoing: 25000,
      reconnectDelay: this.delayHienTai,

      beforeConnect: async () => {
        const token = await this.layTokenMoi();
        // Token đi trong frame CONNECT, KHÔNG đi trong query string: query string
        // bị ghi vào access log của proxy và của server.
        client.connectHeaders = token ? { Authorization: `Bearer ${token}` } : {};
      },

      onConnect: () => {
        this.delayHienTai = DELAY_DAU;
        client.reconnectDelay = DELAY_DAU;
        this.datState('connected');

        // Chỉ subscribe kênh riêng của chính mình. Server chặn mọi destination
        // khác, và cũng không mở topic công khai nào.
        client.subscribe('/user/queue/tin-nhan', (msg: IMessage) =>
          this.phatTin(this.handlersTinNhan, msg),
        );
        client.subscribe('/user/queue/trang-thai', (msg: IMessage) =>
          this.phatTin(this.handlersTrangThai, msg),
        );
      },

      onWebSocketClose: () => {
        this.datState('disconnected');
        this.delayHienTai = Math.min(this.delayHienTai * 2, DELAY_TOI_DA);
        client.reconnectDelay = this.delayHienTai;
      },

      onStompError: (frame) => {
        // Token sai/hết hạn rơi vào đây. Vẫn để stompjs nối lại: lần sau
        // beforeConnect sẽ lấy token mới.
        console.warn('[chat] STOMP error:', frame.headers['message']);
      },
    });

    this.client = client;
    client.activate();
  }

  private phatTin(handlers: Set<Handler>, msg: IMessage) {
    try {
      const payload = JSON.parse(msg.body);
      handlers.forEach((h) => h(payload));
    } catch {
      console.warn('[chat] Không đọc được payload WebSocket');
    }
  }

  disconnect() {
    this.client?.deactivate();
    this.client = null;
    this.datState('idle');
  }

  /** Báo "đang gõ". Mất frame này không sao — nó chỉ là thông tin phù du. */
  baoDangGo(cuocTroChuyenId: string, dangGo: boolean) {
    if (this.state !== 'connected' || !this.client) return;
    this.client.publish({
      destination: `/app/hoi-thoai/${cuocTroChuyenId}/dang-go`,
      body: JSON.stringify({ dangGo }),
    });
  }

  onTinNhan(h: Handler) {
    this.handlersTinNhan.add(h);
    return () => this.handlersTinNhan.delete(h);
  }

  onTrangThai(h: Handler) {
    this.handlersTrangThai.add(h);
    return () => this.handlersTrangThai.delete(h);
  }

  onStateChange(h: (s: ChatSocketState) => void) {
    this.handlersState.add(h);
    h(this.state);
    return () => this.handlersState.delete(h);
  }

  get trangThai() {
    return this.state;
  }
}

export const chatSocket = new ChatSocket();
