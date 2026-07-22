import { AppState, type AppStateStatus } from 'react-native';
import { Client, type IMessage } from '@stomp/stompjs';
import { BASE_URL } from '@/api/client';

/**
 * Client WebSocket/STOMP cho mobile.
 *
 * Khác web ở ba điểm, đều là đặc thù React Native:
 *
 * 1. HAI CỜ BẮT BUỘC (forceBinaryWSFrames, appendMissingNULLonIncoming):
 *    WebSocket của React Native cắt mất byte NULL kết thúc khung STOMP, khiến
 *    khung nhận về bị hỏng. Đây là cách xử lý chính thức theo tài liệu StompJS.
 *
 * 2. Token lấy từ session trong bộ nhớ (AuthContext) chứ không gọi endpoint
 *    session như web — mobile không có NextAuth.
 *
 * 3. NGẮT khi app vào nền: giữ WebSocket ở background vừa tốn pin vừa vô ích vì
 *    hệ điều hành sẽ treo tiến trình. Quay lại foreground thì nối lại rồi gọi
 *    delta bù phần đã lỡ.
 */

export type ChatSocketState = 'idle' | 'connecting' | 'connected' | 'disconnected';

type Handler = (payload: unknown) => void;

/** Backoff luỹ thừa, giãn hơn web một chút để đỡ hao pin khi mạng chập chờn. */
const DELAY_DAU = 2000;
const DELAY_TOI_DA = 60000;

/** Khớp với nhịp tim phía server (25s) — Cloudflare đóng WS sau ~100s im lặng. */
const NHIP_TIM_MS = 25000;

function duongDanWebSocket(): string {
  // BASE_URL dạng http(s)://host:port -> ws(s)://host:port/ws
  return BASE_URL.replace(/^http/, 'ws') + '/ws';
}

class ChatSocket {
  private client: Client | null = null;
  private state: ChatSocketState = 'idle';
  private delayHienTai = DELAY_DAU;
  private token: string | null = null;
  private huyAppState: (() => void) | null = null;

  private handlersTinNhan = new Set<Handler>();
  private handlersTrangThai = new Set<Handler>();
  private handlersState = new Set<(s: ChatSocketState) => void>();

  private datState(s: ChatSocketState) {
    if (this.state === s) return;
    this.state = s;
    this.handlersState.forEach((h) => h(s));
  }

  /** Gọi sau khi đăng nhập. Gọi lại với token mới thì tự nối lại. */
  connect(token: string) {
    if (this.client && this.token === token) return;
    if (this.client) this.disconnect();

    this.token = token;
    this.datState('connecting');

    const client = new Client({
      brokerURL: duongDanWebSocket(),
      connectHeaders: { Authorization: `Bearer ${token}` },
      heartbeatIncoming: NHIP_TIM_MS,
      heartbeatOutgoing: NHIP_TIM_MS,
      reconnectDelay: this.delayHienTai,

      // Xem chú thích đầu file: bắt buộc trên React Native.
      forceBinaryWSFrames: true,
      appendMissingNULLonIncoming: true,

      onConnect: () => {
        this.delayHienTai = DELAY_DAU;
        client.reconnectDelay = DELAY_DAU;
        this.datState('connected');

        // Chỉ subscribe kênh riêng của mình; server chặn mọi destination khác.
        client.subscribe('/user/queue/tin-nhan', (m: IMessage) =>
          this.phatTin(this.handlersTinNhan, m),
        );
        client.subscribe('/user/queue/trang-thai', (m: IMessage) =>
          this.phatTin(this.handlersTrangThai, m),
        );
      },

      onWebSocketClose: () => {
        this.datState('disconnected');
        this.delayHienTai = Math.min(this.delayHienTai * 2, DELAY_TOI_DA);
        client.reconnectDelay = this.delayHienTai;
      },

      onStompError: (frame) => {
        console.warn('[chat] STOMP error:', frame.headers['message']);
      },
    });

    this.client = client;
    client.activate();
    this.batDauTheoDoiAppState();
  }

  /**
   * Ngắt khi app vào nền, nối lại khi quay ra.
   *
   * Không dùng AppState thì WebSocket vẫn "tưởng" là đang kết nối trong lúc hệ
   * điều hành đã treo tiến trình, và khi mở lại app sẽ ngồi im chờ nhịp tim hết
   * hạn (tới 25 giây) mới nhận ra là đã chết.
   */
  private batDauTheoDoiAppState() {
    if (this.huyAppState) return;

    const xuLy = (trangThai: AppStateStatus) => {
      if (trangThai === 'active') {
        if (this.token && this.state !== 'connected') {
          this.delayHienTai = DELAY_DAU; // quay lại thì thử ngay, không chờ backoff
          this.client?.activate();
        }
      } else {
        this.client?.deactivate();
        this.datState('disconnected');
      }
    };

    const sub = AppState.addEventListener('change', xuLy);
    this.huyAppState = () => sub.remove();
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
    this.token = null;
    this.huyAppState?.();
    this.huyAppState = null;
    this.datState('idle');
  }

  /** Báo "đang gõ". Mất frame này không sao — chỉ là thông tin phù du. */
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
}

export const chatSocket = new ChatSocket();
