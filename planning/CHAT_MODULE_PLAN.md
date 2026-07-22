# Kế hoạch triển khai Module Tin nhắn (Chat realtime) — EasyHouse

> Trạng thái: **Bản thiết kế v2 — WebSocket realtime.** Chưa viết code.
> Lập: 2026-07-22 · Sửa: 2026-07-22 (đổi từ polling sang WebSocket sau khi khảo sát hạ tầng)
> Phạm vi: Spring Boot backend (`be/`), Next.js web (`frontend/`), Expo mobile (`mobile/`), PostgreSQL (`sql/`).

---

## 1. Hiện trạng: chưa có chat người-với-người

| Thứ tưởng là chat | Thực chất | Vị trí |
|---|---|---|
| `/api/chat` | Chatbot AI Gemini tư vấn tìm phòng. Một chiều người ↔ AI, không lưu lịch sử, không có người nhận thật. | `frontend/src/app/api/chat/route.ts` |
| `ChatOverlay` | UI bong bóng chat của bot trên. | `frontend/src/components/mobile-app/ChatOverlay.tsx` |
| `realtime.messages` | Bảng nội bộ của **Supabase Realtime** (partition theo ngày), không phải bảng nghiệp vụ. | `sql/schema.sql:5292` |

Đã quét 60+ entity, 38 controller → không có `TinNhan`/`Message`/`Conversation`. Grep `WebSocket|Stomp|SockJS` trên `be/src` và `frontend/src` → **0 kết quả**. Toàn bộ yêu cầu (chat với admin, chủ nhà, nhóm cùng nhà/cùng tầng, nhóm tự tạo) phải xây mới.

---

## 2. Kết luận khảo sát hạ tầng: **realtime khả thi, và dễ hơn dự kiến**

Đây là phần quan trọng nhất. Ba phát hiện làm đổi hướng thiết kế:

### ✅ Thuận lợi ngoài dự kiến

| Phát hiện | Bằng chứng | Ý nghĩa |
|---|---|---|
| **Reverse proxy là Cloudflare Tunnel, KHÔNG phải nginx** | `docker-compose.cloudflare.yml:18-27`, `deploy/CLOUDFLARE_TUNNEL.md` | cloudflared **proxy WebSocket natively**. Không cần cấu hình `proxy_set_header Upgrade` — cảnh báo tôi nêu ở lần trao đổi trước **không áp dụng** cho hệ thống này. Đây là tin tốt. |
| **Backend chạy đúng 1 instance, cố định** | `docker-compose.easyhouse.yml:36` đặt `container_name` hardcode → `--scale` sẽ fail | **SimpleBroker in-memory là lựa chọn đúng và an toàn**. Không cần Redis relay, không cần sticky session. |
| **Redis đã có sẵn cả dependency lẫn container** | `be/pom.xml:54-57` (`spring-boot-starter-data-redis`), `docker-compose.easyhouse.yml:23-26` | Nếu sau này scale ngang, đường nâng cấp lên relay đã sẵn sàng. Hiện **0 dòng code Java nào dùng Redis** — nó đang nằm không. |

### ⚠️ Ràng buộc phải xử lý

| # | Ràng buộc | Bằng chứng | Xử lý |
|---|---|---|---|
| **C1** | **Hikari pool chỉ 5 connection**, Tomcat threads mặc định 200 | `application.properties:13` | Đây là **nút thắt lớn nhất**. Xem §3-D2 — chính đây là lý do polling sẽ chết. Cần nâng lên 15. |
| **C2** | `.anyRequest().authenticated()` + `JwtAuthenticationFilter` chỉ đọc header `Authorization` | `SecurityConfig.java:59`, `JwtAuthenticationFilter.java:35` | Trình duyệt **không set được header khi bắt tay WebSocket**. → `/ws/**` phải `permitAll` ở tầng HTTP, xác thực chuyển xuống **STOMP `CONNECT` frame**. |
| **C3** | `next.config.ts` có 56 rewrite, **toàn bộ là HTTP**, không rule nào cho realtime; Next rewrite **không nâng cấp kết nối WS** | `next.config.ts:31-258` | Browser phải nối **thẳng tới backend**, không qua proxy Next. Cần biến `NEXT_PUBLIC_WS_URL`. |
| **C4** | **Chưa có biến `NEXT_PUBLIC_*` nào được dùng trong `frontend/src`** (grep = 0) và **không có file `.env` nào trong repo** | chỉ có `frontend/env.example` | `NEXT_PUBLIC_WS_URL` sẽ là biến public **đầu tiên**. Phải thêm vào `env.example` + cả 2 compose file, nếu không production sẽ nối nhầm localhost. |
| **C5** | **`@TransactionalEventListener` chưa dùng ở đâu.** Listener hiện có là `@EventListener` + `@Async` → **bắn TRƯỚC khi commit** | `event/InvoiceEventListener.java:17-18` | **Không được copy pattern này.** Đẩy WS trước commit → client nhận báo có tin, gọi REST lại thì chưa thấy, hoặc transaction rollback mà tin đã hiện. Bắt buộc `AFTER_COMMIT`. |
| **C6** | Bean `taskExecutor` tuỳ chỉnh (core 5 / max 20 / queue 100) ghi đè bean mặc định; `@EnableAsync` khai báo **trùng 2 lần** | `config/AsyncConfig.java:14-25`, `QuanlyphongtroApplication.java:10` | Spring WebSocket messaging có thể tra cứu bean tên `taskExecutor`. Phải khai báo executor **riêng** cho kênh WS, nếu không tin nhắn sẽ xếp hàng chung với việc gửi email. |
| **C7** | Role trong JWT **chỉ có `ADMIN`/`TENANT`**; `LANDLORD`/`STAFF` bị làm phẳng thành `ADMIN` | `AuthService.java:421-423`, `:443-457` | Không phân biệt được "admin hệ thống" vs "chủ nhà" từ token → phải tra `NhaTro.chuTro` / `NguoiDungNhaTro` trong DB. |
| **C8** | `KhachThue.nguoiDung` **nullable** | `entity/KhachThue.java:21-23` | Khách thuê chưa có tài khoản thì không chat được. Cần guard + đếm số bị ảnh hưởng. |
| **C9** | `Phong.tangEntity` nullable, song song cột `Integer tang` legacy | `entity/Phong.java:29-33` | Nhóm "cùng tầng" phải fallback, tránh tạo nhóm rác. |
| **C10** | `ddl-auto=none`, **không Flyway/Liquibase** | `application.properties:8` | DDL viết tay, đặt ở 2–3 nơi. |
| **C11** | Mobile: **không có cấu hình ATS/cleartext**; `apiBaseUrl` hardcode `http://10.0.2.2:8080` | `mobile/app.json:28`, không có `expo-build-properties` | Trên native build thật (không phải Expo Go), Android 9+ và iOS ATS **chặn cleartext** → cả HTTP lẫn `ws://` đều fail. Lỗi tiềm ẩn sẵn có, chat sẽ làm nó lộ ra. |
| **C12** | Mobile **chưa dùng `AppState`** ở bất kỳ đâu (grep = 0) | `mobile/` | Phải thêm để ngắt/nối lại WS khi app vào nền. |
| **C13** | Module `ThongBao` có sẵn 2 bug: broadcast không tạo row người nhận (unread sai) + N+1 khi build response | `ThongBaoService.java:61,143-152,184-196` | Không lặp lại. |

---

## 3. Quyết định thiết kế

### D1 — Namespace API: `/api/tin-nhan`
`rewrites()` trả mảng phẳng nên chạy **sau** filesystem routes (`next.config.ts:31`); route handler Gemini sẽ chiếm `/api/chat`. Dùng `/api/tin-nhan`, đồng thời khớp quy ước tên tiếng Việt của repo.

### D2 — **WebSocket + STOMP là kênh chính, ngay từ Phase 1** *(đổi so với v1)*

Bản v1 tôi đề xuất polling trước. **Sai**, vì 3 lý do — lý do thứ 2 là lý do kỹ thuật cứng:

1. **Chat trễ 3 giây thì không còn là chat.** Đây là tính năng mà realtime *là* yêu cầu.

2. **Hikari pool = 5 (C1) khiến polling không khả thi ở quy mô thật.** Mỗi lần poll là một truy vấn DB. 100 người online, poll 3s/lần → ~33 truy vấn/giây **liên tục**, tranh 5 connection với toàn bộ nghiệp vụ còn lại (hoá đơn, hợp đồng, dashboard). WebSocket thì 100 người **ngồi im = 0 truy vấn**. Chênh lệch không phải vài phần trăm mà là bậc độ lớn.

3. **Làm sau tốn hơn làm luôn** — phải sửa lại tầng gửi tin backend + hook web + hook mobile, tức làm lại đúng phần khó nhất.

**Điểm mấu chốt: WebSocket KHÔNG thay thế REST.** Kết nối WS luôn rớt (đổi mạng, tab ngủ, deploy lại). Khi nối lại, client phải hỏi "tôi lỡ mất gì từ `so_thu_tu` X?" — chính là endpoint delta `?sau=<seq>`. Nên:

- Toàn bộ schema và API trong tài liệu này **không đổi một dòng nào**; WS chỉ là tầng *đẩy* thêm lên trên.
- Và có một hệ quả đẹp: **endpoint delta chính là đường lùi tự động.** Nếu WS không nối được sau N lần thử, client tự chuyển sang polling — không cần viết thêm gì.

### D3 — **Chỉ dùng user destination, KHÔNG dùng topic theo hội thoại**

Đây là quyết định bảo mật quan trọng nhất của module.

Cách làm phổ biến là client `SUBSCRIBE /topic/hoi-thoai/{id}`. Nhược điểm: **bất kỳ ai đã đăng nhập đều có thể subscribe id của người khác** và đọc trộm toàn bộ tin nhắn. Muốn chặn thì phải viết interceptor kiểm tra từng frame `SUBSCRIBE` — dễ sót, dễ sai.

**Thay vào đó:** server fan-out bằng `convertAndSendToUser(userId, "/queue/tin-nhan", payload)`. Client chỉ subscribe **`/user/queue/tin-nhan`** — Spring tự động gắn kênh này vào principal đã xác thực, không cách nào nghe kênh của người khác.

- Chi phí: O(số thành viên) lần gửi mỗi tin. Nhóm 50 người = 50 lần gửi in-memory — không đáng kể.
- Vẫn thêm interceptor `SUBSCRIBE` chặn mọi destination không bắt đầu bằng `/user/` làm lớp phòng thủ thứ hai.

### D4 — Không dùng SockJS
Trình duyệt hiện đại đều hỗ trợ WS; Cloudflare Tunnel proxy WS tốt; React Native **không dùng SockJS được**. Bỏ SockJS giúp client web và mobile chung một codebase, và tránh phải mở CORS cho endpoint `/info`. Trường hợp mạng chặn WS đã có đường lùi polling ở D2.

### D5 — Các quyết định khác

| # | Quyết định | Chọn | Lý do |
|---|---|---|---|
| D5.1 | Thứ tự tin nhắn | **`BIGSERIAL so_thu_tu`**, không dùng timestamp | Timestamp trùng khi gửi cùng lúc → sai thứ tự và hỏng cursor |
| D5.2 | Đẩy WS lúc nào | **`@TransactionalEventListener(AFTER_COMMIT)`** | Xem C5 — tránh đẩy tin chưa commit |
| D5.3 | Mã lỗi HTTP | Trả đúng **400/403/404** (lệch có chủ ý so với repo) | Client cần phân biệt "hết quyền" với "lỗi mạng" để dừng reconnect |
| D5.4 | Khách thuê hết hợp đồng | **`roi_luc = now()`** — rời nhóm, giữ tin đã gửi | Không xoá lịch sử của người khác |
| D5.5 | "Đã xem" | Suy từ `doc_den_seq` của thành viên, **không tạo bảng read-receipt** | Tiết kiệm 1 bảng + N row/tin |
| D5.6 | Admin đọc chat riêng | **Không tự động tham gia**; vào xem phải ghi `AuditLog` | Dữ liệu riêng tư, cần dấu vết kiểm duyệt |
| D5.7 | "Mượn đồ / trao đổi" | Nhóm tự tạo (`GROUP`) + ghim tin nhắn | Đáp ứng đúng nhu cầu, chi phí ~0 |

---

## 4. Kiến trúc realtime

```
                    ┌─────────────────────────────────────────┐
   Web (browser)    │  REST  /api/tin-nhan/**  ──► Next rewrite ──► backend:8080
   Mobile (Expo)    │  WS    /ws (STOMP)       ──────────────────► backend:8080
                    └─────────────────────────────────────────┘
                                    (WS đi THẲNG, không qua Next — C3)

  Gửi tin:  POST REST ──► lưu DB (nguồn sự thật) ──► commit
                                                      └─► AFTER_COMMIT event
                                                            └─► convertAndSendToUser(mỗi thành viên)
  Nhận tin: /user/queue/tin-nhan  (không có topic công khai — D3)
  Nối lại:  GET /api/tin-nhan/hoi-thoai/{id}/tin-nhan/moi?sau=<lastSeq>
```

### 4.1 Backend — file cần thêm

```
be/pom.xml                                    + spring-boot-starter-websocket
config/WebSocketConfig.java                   @EnableWebSocketMessageBroker
config/StompAuthChannelInterceptor.java       xác thực CONNECT + chặn SUBSCRIBE lạ
config/WebSocketPresenceListener.java         SessionConnected/Disconnect → presence
event/TinNhanCreatedEvent.java
event/TinNhanEventListener.java               @TransactionalEventListener(AFTER_COMMIT)
services/ChatRealtimeService.java             fan-out, typing, presence
```

### 4.2 `WebSocketConfig` — các điểm bắt buộc

| Cấu hình | Giá trị | Vì sao bắt buộc |
|---|---|---|
| `registerStompEndpoints` | `/ws`, `setAllowedOriginPatterns(...)` đọc từ property `cors.allowed-origins` sẵn có | CORS của `SecurityConfig` **không tự áp cho STOMP endpoint** |
| `enableSimpleBroker("/queue")` | + `setUserDestinationPrefix("/user")` | Broker in-memory, đủ cho 1 instance (§2) |
| **`setHeartbeatValue({25000, 25000})`** + `setTaskScheduler(...)` | 25 giây | **Cloudflare đóng WebSocket sau ~100 giây không có dữ liệu.** Không có heartbeat thì kết nối chết âm thầm mỗi ~100s. Đây là lỗi hay gặp nhất khi chạy WS sau Cloudflare — *cần đo lại con số này trên tunnel thực tế của bạn.* |
| `configureClientInboundChannel` / `OutboundChannel` | executor **riêng**, không dùng bean `taskExecutor` | Xem C6 — tránh tin nhắn xếp hàng sau email |
| `setMessageSizeLimit` / `setSendTimeLimit` | giới hạn rõ ràng | Chặn client gửi payload khổng lồ |

### 4.3 Xác thực — `StompAuthChannelInterceptor`

Trên `clientInboundChannel`, `preSend()`:

- **`StompCommand.CONNECT`**: đọc native header `Authorization: Bearer <token>` (STOMP frame **cho phép** header tuỳ ý, khác hẳn HTTP handshake — đây là cách đúng, **không** nhét token vào query string vì query string rò vào access log).
  → `jwtService.parseToken()` (tái dùng nguyên si, API thuần chuỗi nên dùng được ngoài servlet context — `JwtService.java:72`)
  → dựng `UsernamePasswordAuthenticationToken(userId, null, authorities)` **giống hệt** `JwtAuthenticationFilter.java:48-49`, principal là `UUID`
  → `accessor.setUser(auth)`. `getName()` trả `uuid.toString()` ⇒ `convertAndSendToUser(userId.toString(), ...)` hoạt động.
  → token sai ⇒ ném exception ⇒ Spring từ chối CONNECT.
- **`SUBSCRIBE`**: chặn mọi destination không bắt đầu `/user/` (lớp phòng thủ thứ hai của D3).
- **`SEND`**: chỉ cho phép prefix `/app/**` đã đăng ký.

Ở `SecurityConfig`, thêm `/ws/**` vào `permitAll` — **bắt buộc**, vì handshake HTTP không mang được header (C2). Bảo mật nằm ở tầng STOMP CONNECT, không phải tầng HTTP.

### 4.4 Kênh và sự kiện

| Hướng | Destination | Nội dung |
|---|---|---|
| Server → Client | `/user/queue/tin-nhan` | Tin nhắn mới (đầy đủ payload, có `so_thu_tu`) |
| Server → Client | `/user/queue/hoi-thoai` | Hội thoại được tạo/đổi tên/thêm-bớt thành viên |
| Server → Client | `/user/queue/trang-thai` | `dang-go` (đang nhập), `da-doc`, `online`/`offline` |
| Client → Server | `/app/hoi-thoai/{id}/dang-go` | Báo đang nhập — **chỉ đẩy qua WS, không ghi DB** |
| Client → Server | `/app/hoi-thoai/{id}/da-doc` | Cập nhật `doc_den_seq` (có ghi DB) |

> **Gửi tin nhắn đi qua REST `POST`, không qua WS.** Lý do: REST đã có sẵn xác thực, validate, `ma_client` chống trùng, và trả về `so_thu_tu` cho optimistic UI. WS chỉ dùng để *nhận*. Đơn giản hơn và ít đường lỗi hơn.

### 4.5 Chống mất tin — 3 lớp

1. **DB là nguồn sự thật duy nhất.** WS chỉ là thông báo; mất frame không mất dữ liệu.
2. **Phát hiện lỗ hổng số thứ tự:** client giữ `lastSeq`. Nhận tin có `so_thu_tu > lastSeq + 1` ⇒ biết đã lỡ tin ⇒ tự gọi delta REST bù.
3. **Nối lại:** mỗi lần WS connect/reconnect, luôn gọi delta `?sau=<lastSeq>` trước khi tin cậy luồng realtime.

### 4.6 Presence & typing (thứ làm chat "cảm giác online")

- Presence: `SessionConnectedEvent` / `SessionDisconnectEvent` → `Set<UUID>` in-memory (1 instance nên đủ; Redis đã sẵn nếu scale).
- Typing: TTL 3 giây phía client, throttle 1 lần/2 giây phía gửi. **Tuyệt đối không ghi DB.**
- Cả hai đều là dữ liệu phù du — mất khi restart là chấp nhận được.

### 4.7 Client

**Web** — thêm `@stomp/stompjs` (chưa có, `package.json` không có thư viện realtime nào):
- `frontend/src/lib/ws-client.ts` — singleton, `reconnectDelay` luỹ thừa (1s→2s→4s→…→30s), heartbeat khớp server
- Nối tới `process.env.NEXT_PUBLIC_WS_URL` (**biến public đầu tiên của dự án** — C4)
- Token: `useSession().accessToken`. **Lưu ý:** access token TTL 60 phút (`application.properties:35`), NextAuth refresh *lazy* khi có request (`auth.ts:133`) ⇒ WS phải bắt lỗi CONNECT do token hết hạn, gọi refresh rồi nối lại. Không xử lý là chat chết im lặng sau 1 giờ.
- Tab ẩn: giữ kết nối (WS rẻ), chỉ ngừng đánh dấu đã đọc.

**Mobile** — Expo SDK 52 / RN 0.76.9, có WebSocket sẵn:
- `@stomp/stompjs` chạy trên WebSocket native (không SockJS — D4).
  ⚠️ **Cần kiểm chứng sớm:** stompjs v7 cần `TextEncoder`/`TextDecoder`. Hermes trên RN 0.76 *có thể* đã có sẵn; nếu không phải thêm polyfill. **Làm spike 30 phút ở đầu P3, trước khi cam kết.**
- Thêm `AppState` (chưa dùng ở đâu — C12): background → ngắt WS; foreground → nối lại + gọi delta.
- ⚠️ **C11**: `ws://10.0.2.2:8080` cleartext chỉ chạy trên Expo Go. Native build cần `expo-build-properties` bật cleartext cho dev, hoặc `wss://` cho production.

---

## 5. Mô hình dữ liệu

*(Không đổi so với v1 — thiết kế cursor này chính là thứ khiến WS gắn vào được mà không phải sửa schema.)*

### 5.1 Enum PostgreSQL (`docker/postgres/init/01-easyhouse-types.sql`)

Quy ước hiện có: tên type `snake_case`, giá trị `UPPER_SNAKE` tiếng Anh khớp hằng Java (`trang_thai_phong AS ENUM ('AVAILABLE',...)`).

```sql
CREATE TYPE loai_cuoc_tro_chuyen       AS ENUM ('DIRECT','GROUP','BUILDING','FLOOR','SUPPORT');
CREATE TYPE trang_thai_cuoc_tro_chuyen AS ENUM ('ACTIVE','ARCHIVED','LOCKED');
CREATE TYPE vai_tro_thanh_vien_chat    AS ENUM ('OWNER','MODERATOR','MEMBER');
CREATE TYPE loai_tin_nhan              AS ENUM ('TEXT','IMAGE','FILE','SYSTEM');
```

| Loại hội thoại | Dùng cho | Thành viên |
|---|---|---|
| `DIRECT` | Chat 1-1 | 2 người |
| `SUPPORT` | **Báo việc cho chủ nhà/admin** | Khách thuê + chủ trọ + staff `coQuyenXem` toà đó |
| `BUILDING` | **Nhóm cùng nhà** (tự động) | Khách thuê ACTIVE trong nhà + chủ trọ + staff |
| `FLOOR` | **Nhóm cùng tầng** (tự động) | Khách thuê ACTIVE trên tầng đó |
| `GROUP` | **Nhóm tự tạo** (mượn đồ, trao đổi) | Người tạo mời, giới hạn trong cùng phạm vi nhà trọ |

### 5.2 `cuoc_tro_chuyen`

| Cột | Kiểu | Ghi chú |
|---|---|---|
| `id` | UUID PK | |
| `loai` | `loai_cuoc_tro_chuyen` NOT NULL | |
| `ten` / `anh` | text | `ten` null với `DIRECT` → hiển thị tên đối phương |
| `nha_tro_id` | UUID FK → `nha_tro` | Trục phân quyền chính |
| `tang_id` | UUID FK → `tang` | Chỉ với `FLOOR` |
| `nguoi_tao_id` | UUID FK → `nguoi_dung` | null nếu hệ thống tạo |
| `trang_thai` | `trang_thai_cuoc_tro_chuyen` NOT NULL default `'ACTIVE'` | `LOCKED` = chỉ đọc |
| `khoa_duy_nhat` | text **UNIQUE** | Chống trùng — xem 5.2.1 |
| `tin_nhan_cuoi_luc` | timestamptz (index) | Denormalize để sắp xếp danh sách |
| `xem_truoc` | text | Preview 120 ký tự |
| `tao_luc`/`cap_nhat_luc`/`xoa_luc` | timestamptz | Soft-delete theo chuẩn repo |

#### 5.2.1 `khoa_duy_nhat` — chống tạo trùng phòng chat

| Loại | Khoá |
|---|---|
| `DIRECT` | `direct_<uuid_nhỏ>_<uuid_lớn>` (sắp xếp 2 UUID ⇒ ai bấm trước cũng ra một kết quả) |
| `SUPPORT` | `support_<nhaTroId>_<nguoiDungId>` |
| `BUILDING` | `building_<nhaTroId>` |
| `FLOOR` | `floor_<tangId>` |
| `GROUP` | `group_<uuid ngẫu nhiên>` |

`UNIQUE` + `INSERT ... ON CONFLICT DO NOTHING` ⇒ an toàn khi hai request đồng thời.

### 5.3 `thanh_vien_cuoc_tro_chuyen`

| Cột | Kiểu | Ghi chú |
|---|---|---|
| `id` | UUID PK | |
| `cuoc_tro_chuyen_id` | UUID FK NOT NULL | |
| `nguoi_dung_id` | UUID FK NOT NULL | **Luôn là `NguoiDung`** (C8) |
| `vai_tro` | `vai_tro_thanh_vien_chat` default `'MEMBER'` | |
| `tham_gia_luc` / `roi_luc` | timestamptz | `roi_luc` null = đang hoạt động (D5.4) |
| `doc_den_seq` | bigint default 0 | **Cơ sở tính unread + "đã xem"** (D5.5) |
| `doc_den_luc` | timestamptz | |
| `tat_thong_bao` / `ghim` | boolean | mute / pin |

`UNIQUE (cuoc_tro_chuyen_id, nguoi_dung_id)` · index `(nguoi_dung_id, roi_luc)`

Unread = `COUNT(tin_nhan WHERE cuoc_tro_chuyen_id=? AND so_thu_tu > doc_den_seq AND nguoi_gui_id <> me)` — một query, không bảng phụ.

### 5.4 `tin_nhan`

| Cột | Kiểu | Ghi chú |
|---|---|---|
| `id` | UUID PK | |
| `so_thu_tu` | **BIGSERIAL NOT NULL UNIQUE** | Cursor + thứ tự tuyệt đối + phát hiện lỗ hổng (4.5) |
| `cuoc_tro_chuyen_id` | UUID FK NOT NULL | |
| `nguoi_gui_id` | UUID FK | **null = tin hệ thống** |
| `loai` | `loai_tin_nhan` default `'TEXT'` | |
| `noi_dung` | text | |
| `file_media_id` | UUID FK → `file_media` | **Tái dùng `FileMedia` + `/api/upload`** — không xây luồng upload mới |
| `tra_loi_cho_id` | UUID FK → `tin_nhan` | reply-to |
| `ma_client` | text | **Idempotency key**, chống gửi trùng khi retry |
| `da_thu_hoi` | boolean default false | |
| `tao_luc`/`cap_nhat_luc`/`xoa_luc` | timestamptz | |

Index bắt buộc: `(cuoc_tro_chuyen_id, so_thu_tu DESC)` · `UNIQUE (cuoc_tro_chuyen_id, ma_client)`

### 5.5 Entity Java

```
entity/  CuocTroChuyen, ThanhVienCuocTroChuyen, TinNhan
         LoaiCuocTroChuyen, TrangThaiCuocTroChuyen, VaiTroThanhVienChat, LoaiTinNhan
repository/ CuocTroChuyenRepository, ThanhVienCuocTroChuyenRepository, TinNhanRepository
```
Dùng `@EntityListeners(TimestampEntityListener.class)` như các entity khác; danh sách hội thoại dùng **projection/fetch join** để tránh N+1 (C13).

---

## 6. Phân quyền — `ChatPermissionService`

Ủy quyền cho `PermissionService` sẵn có:

| Hành động | Luật |
|---|---|
| Đọc hội thoại | Thành viên đang hoạt động (`roi_luc IS NULL`) **hoặc** `isAdmin()` (ghi `AuditLog` — D5.6) |
| Gửi tin | Thành viên hoạt động **và** `trang_thai <> 'LOCKED'` |
| Tạo `DIRECT` | Hai bên **cùng phạm vi** (cùng nhà trọ, hoặc cặp khách thuê ↔ chủ trọ/staff của nhà đó) |
| Tạo `GROUP` | Chỉ mời được người trong `layNguoiDungCungPhamVi()` |
| Thêm/xoá thành viên, đổi tên, khoá | `vai_tro IN ('OWNER','MODERATOR')` hoặc chủ trọ/staff `coQuyenSua` |
| Chủ trọ/staff xem `BUILDING`/`FLOOR` | `PermissionService.canReadNhaTro(...)` |

**Hàm lõi `layNguoiDungCungPhamVi(userId)`** — tập người được phép nhắn:
1. Khách thuê: `KhachThue.nguoiDung → HopDong ACTIVE → Phong → NhaTro` ⇒ khách thuê ACTIVE khác cùng nhà + `NhaTro.chuTro` + staff của nhà đó.
2. Chủ trọ/staff: khách thuê ACTIVE trong `PermissionService.getAllAccessibleNhaTroIds()`.
3. Admin thật: không giới hạn.

> ⚠️ Vì C7, hàm này **không được tin role trong token** để suy ra "là chủ nhà" — phải tra DB.

**Cùng một luật này áp cho cả REST lẫn WS.** Vì đã chọn user-destination (D3), tầng WS không cần kiểm tra quyền khi gửi — server chỉ đẩy tới đúng danh sách thành viên đã xác định lúc lưu DB.

---

## 7. API REST — `/api/tin-nhan`

| Method | Path | Mô tả |
|---|---|---|
| `GET` | `/hoi-thoai?page&limit&loai=` | Danh sách hội thoại + preview + unread. Sắp `ghim DESC, tin_nhan_cuoi_luc DESC` |
| `GET` | `/hoi-thoai/{id}` | Chi tiết + thành viên |
| `POST` | `/hoi-thoai/truc-tiep` | `{nguoiDungId}` → **get-or-create** 1-1 |
| `POST` | `/hoi-thoai/ho-tro` | `{nhaTroId?}` → **get-or-create** kênh báo việc cho chủ nhà |
| `POST` | `/hoi-thoai` | `{ten, thanhVienIds[], nhaTroId}` → nhóm tự tạo |
| `PATCH` | `/hoi-thoai/{id}` | Đổi tên / ảnh / khoá |
| `POST` / `DELETE` | `/hoi-thoai/{id}/thanh-vien[/{nguoiDungId}]` | Thêm / xoá thành viên |
| `POST` | `/hoi-thoai/{id}/roi` | Tự rời nhóm |
| `GET` | `/hoi-thoai/{id}/tin-nhan?truoc=<seq>&limit=30` | Lịch sử, cuộn ngược |
| `GET` | `/hoi-thoai/{id}/tin-nhan/moi?sau=<seq>` | **Delta** — dùng khi nối lại WS **và** làm đường lùi polling (D2) |
| `POST` | `/hoi-thoai/{id}/tin-nhan` | `{noiDung, loai, fileMediaId?, traLoiChoId?, maClient}` → **kích hoạt fan-out WS sau commit** |
| `POST` | `/tin-nhan/{id}/thu-hoi` | Thu hồi tin của mình |
| `POST` | `/hoi-thoai/{id}/da-doc` | `{denSeq}` |
| `GET` | `/chua-doc` | Tổng unread cho badge |
| `GET` | `/nguoi-lien-he?q=` | Người được phép nhắn (§6) |

Giữ envelope `ApiResponse`/`PaginatedResponse` (page 1-indexed), map `id → _id` như toàn repo; mã lỗi HTTP theo D5.3.

### Đồng bộ thành viên tự động — `ChatMembershipService`

Nhóm `BUILDING`/`FLOOR`/`SUPPORT` **materialize** thành viên, đồng bộ 3 lớp:
1. **Theo sự kiện** — hook `HopDongService` khi hợp đồng sang `ACTIVE`/`TERMINATED`/`EXPIRED`, khi đổi phòng (đường chính).
2. **Lazy** — `ensureHoiThoaiNhaTro(nhaTroId)` tạo nếu chưa có.
3. **Đối soát định kỳ** — job hằng ngày trong `SchedulerService` sửa lệch.

Mỗi thay đổi sinh 1 `tin_nhan` loại `SYSTEM`.

---

## 8. Frontend Web

```
app/(dashboard)/dashboard/tin-nhan/page.tsx     # chủ nhà / staff / admin
app/khach-thue/dashboard/tin-nhan/page.tsx      # khách thuê
components/chat/
  ChatLayout.tsx  ConversationList.tsx  MessageThread.tsx
  MessageComposer.tsx  NewGroupDialog.tsx  TypingIndicator.tsx
lib/ws-client.ts        # singleton STOMP, reconnect luỹ thừa
hooks/use-chat.ts       # gộp WS + REST delta + optimistic UI
```

- **Không dùng `useCache`/`sessionStorage`** như trang thông báo — chat phải tươi.
- Optimistic UI: hiện tin ngay với `maClient`, đối chiếu khi server trả về.
- `next.config.ts`: thêm rewrite `/api/tin-nhan` + `/api/tin-nhan/:path*` (**chỉ cho REST**; WS đi thẳng — C3).
- `env.example` + 2 compose file: thêm `NEXT_PUBLIC_WS_URL` (C4). Dev `ws://localhost:8082/ws`, prod `wss://api.mc4vn.net/ws`.
- `app-sidebar.tsx`: thêm "Tin nhắn" + **badge unread (admin hiện chưa có badge nào)**.
- `khach-thue/dashboard/layout.tsx`: thêm tab + badge (pattern đã có sẵn).
- `types/index.ts`: thêm `CuocTroChuyen`, `TinNhan`, `ThanhVienChat`.

## 9. Mobile

```
app/(tenant)/tin-nhan.tsx  + tin-nhan/[id].tsx
app/(manager)/tin-nhan.tsx + tin-nhan/[id].tsx
src/lib/ws-client.ts   src/lib/useChat.ts
```
- Tái dùng `src/api/client.ts` (đã có auto-refresh 401) cho REST.
- Thêm `AppState` (C12); poll giãn hơn web khi phải fallback.
- ⚠️ Spike `TextEncoder` (§4.7) và cleartext (C11) **trước** khi bắt đầu P3.
- Không có `expo-notifications` ⇒ **app đóng thì không nhận được tin** — đó là việc của P5, WebSocket không giải quyết được.

## 10. Migration & vận hành

`sql/migrations/20260722_add_chat_module.sql`:
1. `CREATE TYPE` 4 enum (idempotent, bọc `DO $$ ... EXCEPTION WHEN duplicate_object`)
2. `CREATE TABLE` 3 bảng + FK + index + unique
3. Backfill: `BUILDING` cho mọi `nha_tro`, `FLOOR` cho mọi `tang`, `SUPPORT` cho khách thuê có hợp đồng ACTIVE **và có `nguoi_dung_id`**

Cập nhật kèm: `docker/postgres/init/01-easyhouse-types.sql` (enum) + `sql/schema.sql` (C10).

**Cấu hình cần đổi:**
- `application.properties:13` — Hikari `maximum-pool-size` **5 → 15** (C1). Con số 5 là di sản thời Supabase free tier; Docker hiện dùng Postgres local nên nâng được. **Đo lại bằng k6 trước/sau.**
- Thêm `spring.data.redis.*` vào chỗ dùng thật *(chỉ khi scale ngang — hiện chưa cần)*.

**Giám sát** — stack Prometheus/Grafana đã có sẵn (`monitoring/`), tận dụng:
- Micrometer gauge: số phiên WS đang mở, số tin/giây, độ trễ fan-out
- Alert hiện tại chỉ phủ HTTP (`monitoring/prometheus/alerts.yml`) → thêm alert khi phiên WS tụt đột ngột (dấu hiệu heartbeat sai / Cloudflare cắt)
- `monitoring/k6.js` chưa có kịch bản WS → thêm scenario dùng `k6/ws` để kiểm chứng heartbeat 25s thực sự giữ được kết nối qua tunnel

---

## 11. Lộ trình

| Phase | Nội dung | Kiểm chứng được | Ước lượng |
|---|---|---|---|
| **P0** | Migration + entity + repository + `ChatPermissionService` | `mvn test` xanh, bảng tồn tại trong Docker | 1–1.5 ngày |
| **P1** | **WebSocket infra** (config + auth interceptor + AFTER_COMMIT fan-out) + REST + chat **1-1 & kênh hỗ trợ** + UI web 2 portal | Hai trình duyệt mở cạnh nhau, gõ bên này **hiện ngay** bên kia; rút mạng rồi cắm lại **không mất tin** | 3.5–4.5 ngày |
| **P2** | **Nhóm**: `BUILDING`, `FLOOR` tự động + `GROUP` tự tạo + `ChatMembershipService` + job đối soát | Kết thúc hợp đồng → thành viên nhóm tự cập nhật đúng | 2–3 ngày |
| **P3** | **Mobile** (spike `TextEncoder` trước) + `AppState` reconnect | Nhắn giữa app và web, realtime hai chiều | 2–2.5 ngày |
| **P4** | Ảnh/file (Cloudinary sẵn có), trả lời, thu hồi, **đang nhập**, **đã xem**, ghim, mute, tìm kiếm | Gửi ảnh trong nhóm; thấy "đang nhập…" | 2–2.5 ngày |
| **P5** | **Push notification**: `expo-notifications` + FCM (giải quyết "app đóng vẫn nhận tin" — WS không làm được) | Đóng app, vẫn nhận thông báo | 2–3 ngày |
| **P6** *(tuỳ chọn)* | Kiểm duyệt: báo cáo tin, chặn người dùng, log admin, chính sách lưu trữ | Admin xử lý được tin bị báo xấu | 1.5 ngày |
| **P7** *(mới)* | **Bảng thông tin hội thoại**: biệt danh, tab Ảnh–Tệp–Liên kết, thành viên, tìm trong hội thoại — đặc tả ở §11.2 | Mở bảng thấy đủ ảnh/tệp/liên kết đã trao đổi; đặt được biệt danh | 1.5–2 ngày |
| **P8** *(mới)* | **Thao tác trên tin & trên danh sách**: chuyển tiếp, ghim tin, chi tiết tin (ai đã xem), nút cuộn xuống, menu 3 chấm ở danh sách (lưu trữ / xoá / rời nhóm / tắt báo) — đặc tả ở §11.3 | Chuyển tiếp được tin sang hội thoại khác; lưu trữ rồi bỏ lưu trữ mà không mở hội thoại | 2–2.5 ngày |

**P0–P4 (chat realtime dùng được thật): ~11–14 ngày.**
So với v1 (polling, 8–11 ngày rồi *vẫn phải* làm lại): chênh ~2 ngày nhưng **có realtime thật ngay từ đầu và không làm hai lần**.

> **Ghi chú tiến độ (2026-07-22):**
> **P0, P1, P2, P4 (web), P5, P6, P7 (web), P8 (web)** — đã xong và kiểm chứng chạy thật.
> **P3 (mobile)** code-complete nhưng chưa chạy được trên thiết bị (máy chưa cấp quyền USB).
> **Còn nợ:** P4 + P7 + P8 phần mobile, FCM cho mobile, giao diện admin cho báo cáo,
> chính sách lưu trữ tin nhắn, và test WebSocket qua Cloudflare Tunnel thật.
> Danh sách đầy đủ những gì còn treo ở **§13**; chi tiết từng phase ở §11.0.
> P2 gồm: `ChatMembershipService` đồng bộ 2 lớp (lazy khi mở danh sách + job đối soát
> 3:30 sáng), nhóm `BUILDING`/`FLOOR` tự sinh theo hợp đồng ACTIVE, nhóm `GROUP` tự tạo,
> tin hệ thống khi thành viên thay đổi, và UI tạo nhóm/rời nhóm.
> Ngoài kế hoạch còn bổ sung **hiển thị thời gian tin nhắn** theo quy ước Messenger
> (dải phân cách theo ngày/khoảng nghỉ, gom tin liên tiếp, tooltip giờ chính xác).
> Phần lớn *backend* của P4 cũng đã làm sẵn trong P1 vì schema thiết kế bao luôn:
> `file_media_id`, `tra_loi_cho_id`, `da_thu_hoi`, `ghim`, `tat_thong_bao`,
> endpoint thu hồi, và kênh realtime "đang gõ" / "đã xem".
> P4 còn lại chủ yếu là **giao diện**, cộng thêm tìm kiếm (xem 11.1) chưa có gì.

### 11.0 Nhật ký tiến độ

Ghi lại quyết định và vấn đề gặp phải, để lần sau không phải suy luận lại.

#### P0 + P1 — xong 2026-07-22

- Schema 3 bảng, WebSocket STOMP, xác thực qua frame CONNECT, chat 1-1 + kênh hỗ trợ, UI 2 cổng web.
- **Vấn đề gặp phải:**
  - `@Generated(event = EventType.INSERT)` cho `so_thu_tu` cần `columnDefinition = "bigserial"` để H2 sinh được DDL lúc test.
  - Mọi test nạp Spring context đều hỏng **từ trước** do `PhuongTien.columnDefinition` là enum PostgreSQL mà H2 không hiểu, và thiếu 3 property `vnpay.*`. Đã sửa **chỉ trong test config**, không đụng code production → `contextLoads` và 5 test bảo mật chạy lại được.
  - `@stomp/stompjs` cài trên host nhưng container frontend dùng named volume riêng cho `node_modules` → trang 500. Phải cài **bên trong container**.
  - `session.user.id` ở cổng khách thuê là **khach_thue.id**, không phải nguoi_dung.id → tin của chính mình hiển thị như tin người khác. Sửa bằng cách đọc claim `sub` của access token (đúng cho cả hai luồng đăng nhập).

#### P2 — xong 2026-07-22

- `ChatMembershipService` đồng bộ 2 lớp: lazy khi mở danh sách + job đối soát 3:30 sáng.
- **Quyết định:** không móc vào `HopDongService`. Hợp đồng là vùng rủi ro cao; dùng cơ chế "so rồi sửa cho khớp" tự chữa lành thay vì chèn lời gọi vào luồng nghiệp vụ tiền bạc.
- **Vấn đề gặp phải:** `dongBoChoNguoiDung` ban đầu dùng propagation mặc định nên **nhập vào transaction `readOnly = true`** của `danhSachCuaToi`. Hibernate tắt flush trong transaction chỉ-đọc → mọi `save()` im lặng không ghi gì, **không báo lỗi**. Sửa bằng `Propagation.REQUIRES_NEW`.
- Bổ sung ngoài kế hoạch: hiển thị thời gian tin nhắn theo quy ước Messenger.

#### P3 — đang làm

**Spike `TextEncoder` (rủi ro R8) — đã chốt:**

| Câu hỏi | Kết luận |
|---|---|
| Hermes RN 0.76 có `TextEncoder`? | **Có** sẵn |
| Có `TextDecoder`? | **Không** — phải lấp bằng `@bacons/text-decoder` (tự kiểm tra trước khi lấp, không ghi đè) |
| stompjs cần gì? | `TextEncoder` ×5, `TextDecoder` ×3 — cần **cả hai** |
| Cấu hình riêng cho RN | `forceBinaryWSFrames: true` **và** `appendMissingNULLonIncoming: true` — theo [tài liệu chính thức StompJS](https://stomp-js.github.io/workaround/stompjs/rx-stomp/react-native-additional-notes.html), vì WebSocket của RN cắt mất byte NULL kết thúc khung STOMP |
| `atob` có trong RN? | **Không** trong global core → tự viết bộ giải mã base64url (đã test 8/8, đối chiếu 100/100 với Node) |

**Về rủi ro của `appendMissingNULLonIncoming`:** tài liệu StompJS cảnh báo cờ này "có thể gây mất dữ liệu" với khung lớn/bị phân mảnh. Chấp nhận được ở đây vì kiến trúc đã có lưới an toàn: khung hỏng → stompjs ngắt kết nối → nối lại → gọi delta `?sau=<seq>` bù đủ phần đã lỡ. Người dùng không mất tin.

**Cleartext (C11) — chưa xử lý, có chủ ý:** `app.json` đang trỏ `http://10.0.2.2:8080`. Expo Go cho phép cleartext nên dev chạy được. **Không** thêm `usesCleartextTraffic` vào cấu hình native vì đó là hạ thấp bảo mật cho toàn app; bản chạy thật nên trỏ `https://` + `wss://` qua Cloudflare Tunnel (`api.mc4vn.net`).

**Sửa tận gốc:** `Session.userId` trên mobile trước đây cũng gán nhầm `khachThue._id`. Do trường này **chưa nơi nào đọc**, đã sửa thẳng ở `src/api/auth.ts` cho cả hai luồng đăng nhập thay vì vá ở chỗ dùng.

**Đã làm xong (code-complete):**

| Tệp | Vai trò |
|---|---|
| `src/lib/polyfills.ts` | Lấp `TextDecoder`, kiểm tra lúc khởi động. Nạp đầu tiên ở `app/_layout.tsx` |
| `src/lib/jwt.ts` | Giải mã base64url tự viết (RN không có `atob`), lấy `sub` |
| `src/lib/ws-client.ts` | STOMP + 2 cờ RN + backoff 2s→60s + **ngắt/nối lại theo `AppState`** |
| `src/lib/useChat.ts` | Cùng 3 lớp chống mất tin như web, dùng `api` client sẵn có |
| `src/lib/chat-time.ts` | **Bản sao** của `frontend/src/lib/chat-time.ts` — sửa quy tắc thời gian phải sửa cả hai |
| `src/components/ChatScreen.tsx` | Màn hình dùng chung, hai trạng thái (danh sách ↔ khung chat) |
| `app/(tenant)/tin-nhan.tsx`, `app/(manager)/tin-nhan.tsx` | Route + tab cho hai cổng |

**Lỗi cấu hình phát hiện khi làm:** `app.json` trỏ `http://10.0.2.2:8080`, nhưng docker ánh xạ backend ra **cổng 8082**, và cổng 8080 trên máy này đang bị **một dự án khác** chiếm. Mobile sẽ nói chuyện với sai server mà không báo lỗi rõ ràng. Đã sửa mặc định thành 8082 và thêm biến `EXPO_PUBLIC_API_BASE_URL` (xem `mobile/env.example`) để đổi mà không phải sửa `app.json`.

**Mức độ kiểm chứng — cần nói rõ:**

| Đã xác minh | Cách |
|---|---|
| Bộ giải mã base64url đúng | 8/8 test, đối chiếu 100/100 với `Buffer.from(..., 'base64url')` của Node |
| Mọi import phân giải được | `npx expo export --platform android` → bundle Hermes 2.98 MB, exit 0 |
| Không lỗi kiểu | `npm run typecheck` exit 0 |
| **CHƯA xác minh** | **Hành vi thật trên thiết bị**: Hermes có `TextEncoder` không, STOMP có chạy qua WebSocket của RN không, hai cờ RN có đủ không |

Lý do chưa xác minh: máy có thiết bị Android cắm sẵn (`24239524700101`) nhưng đang ở trạng thái `unauthorized` — phải bấm đồng ý USB debugging trên chính thiết bị, không làm thay được.

**Cách tự kiểm chứng:**

```
adb reverse tcp:8082 tcp:8082
cd mobile && npx expo start
```

Dấu hiệu đạt: đăng nhập `0396822875 / Tenant@123`, mở tab **Tin nhắn**, thấy các hội thoại; nhắn từ web thì mobile hiện ngay; thu nhỏ app rồi mở lại thì tin gửi trong lúc đó vẫn về đủ.

Nếu gặp `Can't find variable: TextEncoder` thì Hermes bản đó không có sẵn — khi ấy thêm polyfill cho encoder vào `src/lib/polyfills.ts` (hàm `kiemTraPolyfill()` sẽ in ra đúng thứ đang thiếu).

#### Sửa theo phản hồi khi dùng thật — 2026-07-22

Danh sách hội thoại không phân biệt được nhóm với chat 1-1, và không có cách lọc.

- **Phân biệt nhóm:** nhóm dùng biểu tượng người + nền hổ phách, chat 1-1 giữ chữ cái đầu tên. Thêm nhãn ngắn cạnh tên: `Cả nhà` / `Tầng` / `Nhóm` / `Ban quản lý`. Chat 1-1 **cố tình không có nhãn** — gắn nhãn cho mọi thứ thì nhãn mất tác dụng phân biệt. Hiện thêm số thành viên ở dòng xem trước.
- **Lọc danh sách:** ô tìm ngay trên danh sách, lọc theo tên hội thoại + tên thành viên + nội dung xem trước. Lọc **phía client** trên danh sách đã tải nên phản hồi tức thì, không gọi API.
- **Bỏ dấu khi so khớp:** gõ `ca nha` vẫn ra `Cả nhà`, `muon do` vẫn ra `Mượn đồ`. Dùng `normalize('NFD')` + xoá dải U+0300–U+036F; riêng `đ/Đ` xử lý tay vì là chữ cái độc lập, NFD không tách được. Đã test 10/10, lấy hàm thẳng từ mã nguồn để không test bản sao đã lệch.
- Áp dụng cho **cả web và mobile**.

> Phân biệt rõ: đây là **lọc danh sách hội thoại theo tên**. Tìm kiếm **nội dung tin nhắn** là việc khác, vẫn thuộc P4 — đặc tả ở §11.1 ngay dưới.

#### P4 — xong phần web 2026-07-22, mobile còn nợ

| Hạng mục | Backend | Web | Mobile |
|---|---|---|---|
| Gửi ảnh / tệp | ✅ | ✅ | ❌ cần `expo-image-picker` |
| Thu hồi tin | ✅ | ✅ | ❌ |
| Trả lời có trích dẫn | ✅ | ✅ | ❌ |
| Hiển thị "Đã xem" | ✅ | ✅ | ❌ |
| Ghim / tắt thông báo | ✅ | ✅ | ❌ |
| Tìm kiếm nội dung tin | ✅ | ✅ | ❌ |

**Quyết định thiết kế:**

- **Upload tách khỏi gửi tin** (2 bước: `POST .../tep` → nhận `fileMediaId` → gửi tin kèm id). Lý do: người dùng thấy ảnh xem trước ngay trong khi còn đang gõ; gửi lỗi không phải tải lại tệp; đường gửi tin vẫn thuần JSON nên giữ nguyên cơ chế chống trùng bằng `maClient`.
- **Không dùng `/api/upload` sẵn có** cho chat: endpoint đó không kiểm tra người gọi có thuộc hội thoại nào không, và không tạo bản ghi `FileMedia` để còn đối soát/dọn dẹp. Endpoint mới kiểm tra quyền thành viên trước khi nhận tệp.
- Thêm giá trị `MESSAGE` vào `LoaiDoiTuongMedia` — cột `file_media.doi_tuong` là varchar **không có CHECK constraint** (đã kiểm bằng `pg_constraint`) nên không cần migration.
- `doiTuongId` của tệp trỏ tới **hội thoại** chứ không phải tin nhắn, vì lúc tải lên tin nhắn chưa tồn tại.
- **Thu hồi xoá hẳn** `noi_dung` và `file_media_id` trong DB, không chỉ ẩn ở tầng hiển thị. Đã kiểm chứng: bản ghi còn lại `noi_dung = NULL`, và tin đã thu hồi **không lọt vào kết quả tìm kiếm**.
- **"Đã xem" chỉ hiện dưới tin cuối cùng của mình** đã được đọc — gắn vào mọi tin thì màn hình đầy chữ "Đã xem".
- **Ghim/tắt thông báo lưu trên bản ghi thành viên**, không phải trên hội thoại: đó là tuỳ chọn cá nhân, mỗi người ghim gì là việc của họ.

**Tìm kiếm — khác đặc tả §11.1 ở một điểm quan trọng:**

§11.1 ban đầu chỉ định index trigram trên `lower(noi_dung)`. Khi làm thật thì thấy **không đủ**: ô lọc danh sách hội thoại đã bỏ dấu, nếu tìm nội dung lại phân biệt dấu thì trải nghiệm lệch nhau. Đã kiểm chứng `unaccent` xử lý tốt tiếng Việt (`'Đặng Thị Hà'` → `'Dang Thi Ha'`, kể cả `đ`), nên:

- Migration `20260722_add_chat_search.sql` tạo hàm `f_khong_dau()` **IMMUTABLE** bọc `unaccent('unaccent', $1)` — dạng một tham số là STABLE nên không dùng trong index được.
- Index trigram đặt trên `f_khong_dau(noi_dung)`, và truy vấn phải gọi **đúng biểu thức đó**, nếu không PostgreSQL sẽ bỏ index và quét tuần tự toàn bảng.
- Vì cần gọi hàm tự định nghĩa nên dùng **native query** thay vì JPQL.
- **Phạm vi quyền nằm ngay trong mệnh đề JOIN**, không lọc ở tầng trên: đoán đúng từ khoá cũng không đọc trộm được hội thoại mình không tham gia. Đã test: người ngoài tìm đúng câu đó → 0 kết quả.
- Bấm kết quả → mở hội thoại và nạp `?truoc=<seq+1>` nên tin cần tìm nằm cuối trang, chắc chắn nhìn thấy. Không phải thêm endpoint mới.

**Lưu ý về test:** native query **không** được Spring validate lúc khởi động (khác JPQL), và H2 không có `f_khong_dau()`. Nghĩa là lỗi cú pháp trong truy vấn tìm kiếm chỉ lộ ra khi chạy thật với PostgreSQL — đã kiểm chứng bằng smoke test 13/13.

**Vấn đề gặp phải:** thêm `CloudinaryService` vào constructor `TinNhanService` làm hỏng 9 test (`NoSuchMethodError`). Đây là lần thứ hai dính đúng kiểu lỗi này (lần trước với `CuocTroChuyenService`) — Lombok `@RequiredArgsConstructor` đổi chữ ký mỗi khi thêm dependency, mà test gọi constructor tường minh.

**Cloudinary chưa cấu hình được:** biến trong `docker-compose.easyhouse.yml` là giá trị giả nên upload trả `cloud_name is disabled`. Phần kiểm quyền vẫn chạy đúng (người ngoài → 403). Muốn thử gửi ảnh thật thì đặt `CLOUDINARY_CLOUD_NAME` / `API_KEY` / `API_SECRET` thật.

#### P7 — xong phần web 2026-07-22

Làm đúng theo đặc tả §11.2 bên dưới. Kiểm chứng: **13/13 smoke test backend**, và
kiểm tra thật trên trình duyệt.

**Lỗi gốc đã sửa triệt để.** Nút ghim/tắt thông báo trước đây không đổi trạng thái
vì `hoiThoaiDangMo` là state độc lập, còn `capNhatTuyChon` chỉ cập nhật `hoiThoais`.
Đã **bỏ hẳn state trùng lặp**: `hoiThoaiDangMo` giờ là `useMemo` dẫn xuất từ
`hoiThoais` theo id, kèm một biến dự phòng dùng đúng trong khoảnh khắc hội thoại
vừa tạo mà danh sách chưa kịp tải lại. Xác minh: bấm ghim → nhãn đổi `Ghim` →
`Bỏ ghim`, màu đổi, và icon ghim xuất hiện đồng thời trong danh sách bên trái.

Sự kiện `DA_DOC` qua WebSocket cũng đã chuyển sang cập nhật vào `hoiThoais` thay vì
state riêng, theo cùng nguyên tắc một nguồn sự thật.

**Khác đặc tả một chỗ:** không làm bố cục ba cột cố định. Bảng thông tin dùng
`absolute inset-0` trên màn hình hẹp (che toàn bộ như một trang riêng) và
`md:static md:w-80` trên màn rộng. Lý do: khung chat vốn đã hẹp, ép ba cột cố định
thì cột giữa không còn đủ chỗ đọc tin.

**Trích URL** để ở tầng Java đúng như đặc tả. Có xử lý hai việc mà regex ngây thơ
hay sai: một tin chứa **nhiều URL**, và **dấu câu dính cuối** (`https://abc.com.`
→ cắt dấu chấm). Đã test 4 ca riêng cho hàm này.

**Còn nợ:** bảng thông tin cho mobile.

#### P5 + P6 — xong backend 2026-07-22 (18/18 smoke test)

**P5 — Thông báo đẩy.** Toàn bộ giá trị nằm ở **ba bộ lọc** trong `PushService`, chứ
không phải ở việc gửi được push:

1. bỏ người gửi · 2. **bỏ người đang online** (họ đã thấy tin qua WebSocket rồi —
gửi thêm push là lỗi dễ nhận thấy nhất của một hệ thống chat) · 3. bỏ người đã tắt
thông báo hội thoại đó.

- `ChatPresenceService` **đếm theo số phiên**, không phải cờ có/không: một người mở
  nhiều tab, đóng MỘT tab không được làm hệ thống tưởng họ đã offline. Có test riêng.
- Một bảng `dang_ky_push` dùng chung cho cả Web Push và FCM: luật quyết định giống
  nhau, chỉ khác cách chuyển đi. Tách bảng thì logic đó phải viết hai lần.
- `KenhGuiPush` là interface — thêm FCM sau chỉ cần thêm một lớp, không sửa nghiệp vụ.
- Endpoint trả 404/410 → đánh dấu `dung_luc` (ngừng gửi) nhưng **giữ bản ghi** để còn
  đối chiếu. Lỗi mạng thì KHÔNG đánh dấu, để còn thử lại.
- `WebPushSender` chỉ được tạo bean khi có khoá VAPID (`@ConditionalOnProperty`) —
  thiếu khoá thì hệ thống bỏ qua push, không ném lỗi lung tung.
- **Vấn đề gặp phải:** `web-push` khai báo BouncyCastle là `provided` nên không tự
  kéo về → phải thêm `bcprov-jdk18on` tường minh.

**P6 — Kiểm duyệt.**

- Báo cáo **trỏ tới tin nhắn**, không sao chép nội dung: sao chép thì khi người gửi
  thu hồi, bản sao vẫn nằm lại — vừa sai với ý định thu hồi, vừa tạo thêm một nơi
  lưu dữ liệu nhạy cảm cần bảo vệ.
- Chặn là quan hệ **một chiều** (giống Messenger/Zalo), nhưng khi mở chat 1-1 thì
  **xét cả hai chiều**: nếu B đã chặn A mà vẫn cho A mở cuộc trò chuyện thì A gửi
  vào khoảng không — đó là lừa người dùng.
- Ghi `AuditLog` cả khi admin **chỉ XEM**, không chỉ khi xử lý: đọc tin nhắn riêng
  của người khác là hành động nhạy cảm, phải có dấu vết để còn quy trách nhiệm.

**Ba lỗi tự gây ra rồi tự sửa trong lượt này:**

1. Cột `audit_log.du_lieu_moi` là **jsonb**, tôi truyền chuỗi thường → PostgreSQL từ
   chối. Sửa: đóng gói thành `{"moTa": "..."}` bằng Jackson.
2. Chặn xong người bị chặn **vẫn hiện trong danh bạ**, vì `danhBa` dựng từ phạm vi
   nhà trọ chứ không đi qua `cungPhamVi`. Phải lọc riêng ở đó.
3. `permissionService.requireAdmin()` ném message *"Quyen truy cap bi tu choi"* —
   `GlobalExceptionHandler` đoán status bằng cách **dò chuỗi** và chuỗi đó không khớp
   từ khoá nào nên ra **400 thay vì 403**. Dùng exception có kiểu để status là hợp
   đồng rõ ràng. *(Đây là lỗi tiềm ẩn của mọi endpoint chỉ-admin trong dự án, không
   riêng chat — đáng rà lại toàn bộ.)*

**Đã dứt điểm cái bẫy lặp 3 lần:** thêm dependency vào constructor làm vỡ test
(`NoSuchMethodError`) đã xảy ra với `CuocTroChuyenService`, `TinNhanService`, rồi
`ChatPermissionService`. Đã chuyển cả ba test sang **`@InjectMocks`** — Mockito khớp
theo KIỂU nên thêm dependency không làm vỡ test nữa.

**Chưa kiểm chứng được:** việc trình duyệt thực sự hiện thông báo khi đóng tab —
cần cấp quyền Notification trên trình duyệt thật, công cụ tự động không bấm được.
Đã kiểm chứng: server sinh/trả khoá VAPID, đăng ký/huỷ thiết bị, và ba bộ lọc quyết
định (7/7 unit test).

**Còn nợ:** FCM cho mobile, giao diện admin cho danh sách báo cáo, chính sách lưu trữ.

#### Bốn chỉnh sửa giao diện sau khi dùng thật — xong 2026-07-22

Phản hồi khi dùng thật: liên kết mở tab mới rất khó chịu, tắt thông báo chỉ có
bật/tắt cứng, ô tìm trong bảng thông tin lại nhảy ra danh sách chung, và các nhãn
loại hội thoại cùng một màu xám nên nhìn không phân biệt được.

| Yêu cầu | Cách làm | Kiểm chứng trên trình duyệt |
|---|---|---|
| Liên kết mở **cùng tab** | Bỏ `target="_blank"` ở cả ba danh sách (ảnh / tệp / liên kết) | 3/3 thẻ `<a>` không còn `target` |
| **Tắt thông báo có thời hạn** kiểu Messenger | Cột `tat_thong_bao_den timestamptz` + `dangTatThongBao()`; menu 15 phút / 1 giờ / 8 giờ / 24 giờ / đến khi bật lại | Chọn "1 giờ" → hiện "Tắt thông báo đến 18:06"; chọn "đến khi bật lại" → **không** hiện dòng hạn |
| **Tìm trong chính hội thoại** đang mở | `TimTrongHoiThoai` gọi `/tim-kiem?hoiThoaiId=…`, debounce 300ms, kết quả hiện tại chỗ | Gõ "may bom" (không dấu) → ra "Máy bơm nước tầng 3…"; ô tìm bên trái **vẫn trống** |
| **Nhãn loại có màu** | `nhanNganLoai` trả `{chu, mau}`: BUILDING sky, FLOOR violet, GROUP amber, SUPPORT emerald — áp cả web lẫn mobile | "Ban quản lý" xanh lá, "Nhóm" hổ phách, khác nhau rõ |

**Giữ cột boolean cũ thay vì dùng mốc thời gian "xa vô tận" làm sentinel:** sentinel
kiểu `9999-12-31` trông gọn nhưng rất dễ rò rỉ ra báo cáo và phép tính khoảng thời
gian. Hai cột, một hàm `dangTatThongBao()` gộp lại, client không phải tự tính hạn.

**Ba lỗi thật tìm ra nhờ smoke test, đã sửa:**

1. **Tắt vĩnh viễn không xoá hạn cũ.** Đang tắt 60 phút rồi chọn "đến khi bật lại"
   thì `tat_thong_bao_den` vẫn còn → giao diện hiện "tắt đến 10:53" dù người dùng đã
   chọn vĩnh viễn. Sửa: nhánh `tatThongBao != null` xoá hạn ở **cả hai** chiều.
2. **Tạo nhóm lại báo lỗi về kênh hỗ trợ.** `taoNhom` và `layHoacTaoHoTro` dùng chung
   `nhaTroMacDinh()`, mà hàm này ném thông điệp cố định *"Bạn chưa thuê phòng nào nên
   chưa có ban quản lý để liên hệ"* — vô nghĩa khi đang tạo nhóm. Sửa: bên gọi truyền
   thông điệp hợp ngữ cảnh.
3. **Admin bị chặn oan.** Cả hai chỗ gọi đều cố ý cho admin đi qua bằng `|| isAdmin`,
   nhưng `nhaTroMacDinh()` ném lỗi **trước** khi tới nhánh đó. Admin không bỏ trống
   `nhaTroId` được, lại nhận thông báo "bạn chưa thuê phòng nào". Sửa: nhận diện admin
   và báo rõ *"hãy chọn nhà trọ cụ thể"* — cố ý **không** tự chọn nhà trọ đầu tiên,
   vì chọn sai thì hội thoại nằm nhầm phạm vi và rất khó phát hiện về sau.

**Kiểm chứng:** 51/51 unit test chat xanh (thêm 5 test hồi quy cho đúng 3 lỗi trên),
13/13 smoke REST, và bốn hạng mục đều xác nhận trên trình duyệt thật.

**Bẫy môi trường lặp lại:** sửa `.tsx` mà trang vẫn render class cũ — bind mount trên
Windows không kích hoạt watcher của Next dev. Phải `docker compose restart frontend`.
Type-check trên host **không** phát hiện được chuyện này.

**Toàn bộ test backend:** 155 test, còn 3 failure + 4 error — đã đối chứng bằng
`git worktree` tại HEAD sạch, **giống hệt**, đều nằm ở `SecurityConfigTest`,
`HoaDonServiceTest`, `ContractDocumentServiceTest`, `LichHenServiceTest`,
`SchedulerServiceTest` (lỗi có sẵn, không liên quan chat: mojibake trong file nguồn
và cùng kiểu `@InjectMocks` mà chat đã sửa).

#### P8 — Thao tác trên tin nhắn và trên danh sách *(web)* — xong 2026-07-22

Đặc tả ở §11.3. Đã làm đủ cả 6 phần: ghim tin, chuyển tiếp, chi tiết tin, nút cuộn
xuống, menu ba chấm trên tin, menu ba chấm trên mục danh sách (kèm lưu trữ và xoá).

**Quyết định thiết kế đáng ghi lại:**

- **"Xoá cuộc trò chuyện" KHÔNG xoá hàng nào.** Dùng con trỏ `an_den_seq`: từ đó
  mọi đường đọc tin chỉ trả `so_thu_tu > an_den_seq`. Tin nhắn là dữ liệu chung của
  nhiều người — một bên bấm xoá mà xoá thật thì bên kia mất lịch sử và đường truy vết
  của P6 đứt. Hộp thoại xác nhận nói rõ điều này để người dùng không tưởng là thu hồi.
- **Bộ lọc `an_den_seq` phải phủ MỌI đường đọc**, không riêng khung chat: lịch sử,
  delta, tab Ảnh, tab Tệp, tab Liên kết, tìm kiếm, và bảng ghim. Bỏ sót một chỗ là rò
  rỉ tin đã ẩn ở nơi khác — smoke test kiểm riêng từng đường.
- **Ghim tin ≠ ghim hội thoại.** Ghim tin nằm trên `tin_nhan` vì phạm vi là cả hội
  thoại (ai cũng thấy); ghim hội thoại nằm trên bảng thành viên vì là lựa chọn riêng.
  Giới hạn 5 tin, vượt thì **báo lỗi** chứ không tự bỏ ghim tin cũ nhất — tự ý gỡ ghim
  của người khác là hành vi khó đoán.
- **Chuyển tiếp kiểm quyền ở hội thoại ĐÍCH.** Đọc được tin ở A không có nghĩa được
  ghi vào B. Có test riêng cho đúng điều này, cả unit lẫn smoke (403 + kiểm chứng tin
  không lọt sang).
- **Chi tiết tin nhắn không thêm bảng.** Suy từ `doc_den_seq` sẵn có; một bảng "lượt
  xem" sẽ sinh một hàng cho mỗi cặp (tin × người), phình rất nhanh mà không thêm gì.
- **Bật lưu trữ thì tự bỏ ghim** — hai thứ mâu thuẫn nhau (một cái đẩy lên đầu, một
  cái cất khỏi danh sách).

**Lỗi thật tìm ra khi kiểm chứng trên trình duyệt:**

*Cuộn mượt im lặng không làm gì.* `scrollIntoView({behavior:'smooth'})` không chạy khi
trang không compositing (tab nền, webview nhúng, hoặc bật "giảm chuyển động"). Bấm mũi
tên xuống thì nút biến mất mà khung tin đứng yên. Sửa: `scrollTo` mượt như cũ, nhưng
sau 300ms kiểm lại — nếu `scrollTop` **không hề đổi** thì chốt cứng bằng gán trực tiếp.
Chỉ can thiệp khi cuộn mượt hoàn toàn không chạy, để không giật ngang giữa animation.
Phần nhảy tới tin từ tìm kiếm/băng ghim thì dùng thẳng `behavior:'auto'`: quãng đường
có thể hàng trăm tin, nhảy thẳng vừa chắc vừa hợp lý hơn.

*Auto-cuộn giật người đang đọc tin cũ.* Hiệu ứng cũ cuộn xuống đáy vô điều kiện mỗi
khi `tinNhans.length` đổi. Giờ chỉ cuộn khi người dùng **đang ở đáy** (cách dưới
<120px); còn lại thì hiện nút mũi tên, đúng cách Messenger làm.

*Mục danh sách là `<button>` nên không lồng được menu.* Button trong button là HTML
không hợp lệ, trình duyệt sẽ tự tách thẻ. Đổi vỏ ngoài thành `<div>`, vùng bấm mở hội
thoại là một `<button>` phủ tuyệt đối bên dưới (`absolute inset-0`), các phần hiển thị
đặt `pointer-events-none` để không chặn vùng bấm đó.

**Kiểm chứng:** 65/65 unit test backend (+14 test P8), 28/28 smoke REST, và toàn bộ 6
chức năng xác nhận trực tiếp trên trình duyệt: menu 5 mục trên tin, băng ghim + tin hệ
thống, chuyển tiếp sang nhóm khác (có nhãn "Đã chuyển tiếp" ở đích), hộp chi tiết hiện
"CHƯA XEM · 2", lưu trữ (4→3 mục rồi hiện trong kho), menu nhóm có "Rời nhóm" còn menu
chat 1-1 thì không.

**Bẫy môi trường lần này:** trang `/dashboard/tin-nhan` trả **404** dù file tồn tại và
`tsc` sạch — cache Turbopack trong `.next` hỏng (Next có cảnh báo sẵn *"Slow filesystem
detected… /app/.next/dev is a network drive"*). Xoá `.next` rồi khởi động lại là hết.
Không phải lỗi code; đừng đi sửa nhầm chỗ.

**Còn nợ của P8:** toàn bộ phần **mobile** (menu tin, ghim, chuyển tiếp, lưu trữ, nút
cuộn xuống) — theo đúng yêu cầu "mobile để sau".

#### Badge "Tin nhắn" trên thanh điều hướng không tự cập nhật — sửa 2026-07-22

Triệu chứng: đọc tin xong nhưng con số trên tab vẫn y nguyên, phải tải lại trang.

**Nguyên nhân:** badge nằm ở `khach-thue/dashboard/layout.tsx`, còn việc đánh dấu đã
đọc xảy ra trong `ChatPanel` — **hai cây component tách rời**, không thấy state của
nhau. Badge chỉ có polling 60 giây nên đọc xong vẫn đứng nguyên gần một phút.

**Cách sửa:** thêm một kênh báo hiệu tối giản ngay trong `use-chua-doc-tin-nhan.ts` —
một `Set` các listener ở phạm vi module, kèm hàm `baoCanDemLaiChuaDoc()`. `useChat`
gọi hàm này sau khi đánh dấu đã đọc, khi nhận tin mới ở hội thoại khác, và sau khi xoá
hội thoại.

Vì sao chọn cách này:
- **Set ở phạm vi module** thay vì `CustomEvent` trên `window`: an toàn khi render
  phía máy chủ và giữ được kiểu chặt chẽ.
- **Không kéo thư viện quản lý trạng thái** vào chỉ vì một con số.
- **Không truyền con số qua kênh**, chỉ nói "đếm lại đi" — nguồn sự thật vẫn là
  server. Tự cộng trừ ở client sẽ lệch ngay khi người dùng mở nhiều thiết bị.

**Lỗi thứ hai phát hiện khi kiểm chứng:** lần đếm **đầu tiên lúc mount** cũng bị chặn
bởi kiểm tra `document.visibilityState`. Mở trang bằng Ctrl+click vào tab nền thì badge
đứng ở 0 cho tới khi người dùng bấm sang tab đó. Sửa: kiểm tra tab ẩn/hiện chỉ áp cho
**vòng polling định kỳ**; lần đầu và các lần do kênh báo hiệu kích hoạt thì luôn chạy.
Thêm luôn listener `visibilitychange` để quay lại tab là đếm lại ngay, không chờ hết
60 giây (chỉ đếm khi tab **hiện lại** — sự kiện này bắn cả lúc tab bị ẩn đi).

**Kiểm chứng:** đăng nhập cổng khách thuê thật, tạo 3 tin chưa đọc từ phía chủ trọ →
badge hiện **3**; mở hội thoại → badge về **0 ngay, không tải lại trang**. Nhật ký
request xác nhận đúng thứ tự: `POST …/da-doc` rồi `GET …/chua-doc`.

*Ghi chú:* cổng chủ nhà (`app-sidebar.tsx`) hiện **không** có badge này, nên chỉ cổng
khách thuê bị ảnh hưởng. Nếu sau này thêm badge cho cổng chủ nhà thì dùng lại đúng hook
này là có sẵn hành vi.

#### Menu thả xuống bị chữ phía sau xuyên qua — sửa 2026-07-22

Triệu chứng: mở menu ba chấm ở danh sách thì chữ của các mục phía sau lộ đè lên menu,
trông như menu trong suốt.

**Nguyên nhân:** nền menu vẫn trắng đặc, nhưng **các mục PHÍA SAU vẽ đè lên trên**.
Khi đổi mục danh sách từ `<button>` sang `<div>` (để nhét được menu vào), tôi đã gắn
`z-10` cho các phần hiển thị bên trong nhằm cho chúng nổi trên nút bấm phủ trong suốt.
Chính đám `z-10` đó lại cạnh tranh với `z-30` của menu ở cùng ngữ cảnh xếp lớp gốc —
chỉ cần một mục sau vẽ sau là menu chìm xuống dưới.

**Sửa:**
- Bỏ hẳn `z-10` ở các phần hiển thị — chúng chỉ cần nằm trên nút phủ, mà **thứ tự DOM
  đã lo việc đó** (nút phủ đứng trước). Gán z-index ở đó là thừa và chính là mầm lỗi.
- Menu lên `z-50`, và mục đang mở menu được `focus-within:z-20` để cả cụm nổi lên.
- Đậm bóng đổ (`shadow-xl` + `ring-1 ring-black/5`) cho menu tách khỏi nền rõ hơn.

**Lỗi thứ hai phát hiện khi đo:** menu của mục **cuối danh sách** bị `overflow-y` của
khung cuộn cắt mất 39px — mục "Xoá cuộc trò chuyện" bấm không tới. Sửa: đo lúc mở, nếu
khoảng trống phía dưới nhỏ hơn chiều cao menu thì **lật lên trên** (`bottom-full`). Đo
so với **khung cuộn** chứ không so với cửa sổ, vì thứ cắt menu là `overflow-y` của danh
sách chứ không phải mép màn hình. Áp cho cả menu tin nhắn — tin cuối cũng sát đáy.

**Kiểm chứng:** đo bằng `elementFromPoint` tại 6 điểm dọc menu — cả 6 đều trả về chính
menu, không còn gì đè. Mục giữa danh sách mở **xuống**, mục cuối mở **lên**, cả hai đều
không bị khung cuộn cắt.

**Bẫy môi trường tái diễn:** cache Turbopack lại hỏng sau restart, trang trả 404. Lưu ý
`.next` là **named volume** (`easyhouse_next_cache`) chứ không nằm ở thư mục host — nên
phải xoá **nội dung** bên trong container, không xoá thư mục mount:

```bash
docker exec easyhouse-frontend sh -c "rm -rf /app/.next/* /app/.next/.[!.]*"
```

### 11.2 Đặc tả P7 — Bảng thông tin hội thoại *(đã làm phần web)*

Phát sinh khi dùng thật: các nút hành động nằm rải rác trên header, không đủ chỗ,
và thiếu hẳn những thứ mà người dùng quen có ở Messenger/Zalo.

#### Lỗi đã phát hiện, phải sửa cùng

**Nút ghim / tắt thông báo không đổi trạng thái ở header.** Hành động *có* tác dụng
(icon ghim xuất hiện trong danh sách, DB cập nhật đúng) nhưng nút vẫn giữ nguyên
màu và tooltip. Nguyên nhân: `capNhatTuyChon` chỉ cập nhật mảng `hoiThoais`, không
cập nhật `hoiThoaiDangMo` — mà header đọc từ `hoiThoaiDangMo` nên thấy giá trị cũ.
Cùng loại lỗi "hai nguồn dữ liệu cho một sự thật" sẽ còn lặp lại nếu không gom về
một chỗ: **`hoiThoaiDangMo` nên là dẫn xuất từ `hoiThoais` theo id**, thay vì một
state riêng được set độc lập.

#### Khảo sát: bảng thông tin của các ứng dụng phổ biến

| Ứng dụng | Nội dung bảng bên phải |
|---|---|
| Messenger | Tuỳ chỉnh (chủ đề, emoji, **biệt danh**), **Ảnh–Tệp–Liên kết**, Tìm trong hội thoại, Quyền riêng tư (tắt thông báo, chặn, báo cáo), nhóm: thành viên/rời nhóm |
| Zalo | Thêm: **tin nhắn ghim**, ghi chú, bình chọn, nhắc hẹn |
| Teams/Slack | Thành viên, tệp, mục đã ghim, cài đặt thông báo |

Điểm chung: một nút "i" mở bảng bên phải, gom **mọi thứ về hội thoại** vào một chỗ
thay vì rải nút trên header.

#### Phạm vi chọn làm — và phạm vi cố tình bỏ

**Làm:**

1. **Đầu bảng** — ảnh đại diện, tên, số thành viên (nhóm) hoặc số điện thoại (1-1).
2. **Hành động nhanh** — Ghim · Tắt thông báo · Tìm trong hội thoại. Chuyển hết
   các nút đang nằm rải trên header vào đây, header chỉ còn nút mở bảng.
3. **Biệt danh** — đặt tên hiển thị riêng cho từng thành viên, chỉ có tác dụng trong
   hội thoại đó, mọi người cùng thấy (giống Messenger).
   *Lý do ưu tiên cao:* dữ liệu `nguoi_dung.ho_ten` trong dump hiện tại bị mất dấu
   (`H?? V??n Linh`), nên biệt danh là cách người dùng tự sửa được tên hiển thị mà
   không phải chờ nhập lại dữ liệu.
4. **Ảnh · Tệp · Liên kết** — ba tab:
   - *Ảnh*: lưới thumbnail, bấm mở ảnh lớn
   - *Tệp*: tên tệp, kích thước, ngày gửi, bấm để tải
   - *Liên kết*: URL trích từ nội dung tin nhắn, kèm ngày và người gửi
5. **Thành viên** (nhóm) — danh sách + vai trò, thêm/xoá, rời nhóm.
6. **Tìm trong hội thoại** — dùng lại endpoint `/tim-kiem?hoiThoaiId=` đã có.

**Cố tình KHÔNG làm** (và lý do, để sau khỏi phải cân nhắc lại):

- *Chủ đề màu, emoji hội thoại*: là trang trí, không phục vụ việc quản lý nhà trọ.
- *Bình chọn, nhắc hẹn*: trùng chức năng với module Lịch hẹn và Thông báo đã có.
- *Chặn người dùng, báo cáo*: thuộc P6 (kiểm duyệt), làm cùng chính sách lưu trữ.

#### Thay đổi cần ở backend

**1. Biệt danh** — thêm một cột, không cần bảng mới:

```sql
ALTER TABLE thanh_vien_cuoc_tro_chuyen
    ADD COLUMN IF NOT EXISTS biet_danh text;
```

Đặt trên bản ghi *thành viên* chứ không phải trên `nguoi_dung`: biệt danh chỉ có
nghĩa trong phạm vi một hội thoại. Ai trong hội thoại cũng sửa được và mọi người
cùng thấy — giống Messenger, và tránh phải làm bảng ánh xạ (người xem × người được
đặt tên) vốn phình rất nhanh.

Khi đổi biệt danh thì sinh **tin hệ thống** ("A đã đặt biệt danh cho B là …") để
nhóm có ngữ cảnh, giống cách đã làm với thêm/xoá thành viên.

Endpoint: `PATCH /api/tin-nhan/hoi-thoai/{id}/thanh-vien/{nguoiDungId}/biet-danh`
với body `{ bietDanh }`; để trống = xoá biệt danh.

`ThanhVienChatResponse` thêm trường `bietDanh`; chỗ nào hiển thị tên thành viên thì
ưu tiên `bietDanh ?? hoTen`.

**2. Ảnh / tệp** — truy vấn theo loại tin, có sẵn dữ liệu:

```
GET /api/tin-nhan/hoi-thoai/{id}/tep-dinh-kem?loai=IMAGE|FILE&page=&limit=
```

Lọc `tin_nhan` theo `loai` và `file_media_id IS NOT NULL`, bỏ tin đã thu hồi/đã xoá.
Cần index để không quét cả bảng khi hội thoại dài:

```sql
CREATE INDEX IF NOT EXISTS idx_tin_nhan_dinh_kem
    ON tin_nhan (cuoc_tro_chuyen_id, so_thu_tu DESC)
    WHERE file_media_id IS NOT NULL AND xoa_luc IS NULL AND da_thu_hoi = false;
```

**3. Liên kết** — trích URL từ nội dung:

```
GET /api/tin-nhan/hoi-thoai/{id}/lien-ket?page=&limit=
```

Lọc bằng `noi_dung ~* 'https?://'` ở SQL rồi **trích URL ở tầng Java**, không cố
viết regex trích xuất trong SQL. Lý do: một tin có thể chứa nhiều URL, và regex
trích xuất phức tạp trong SQL vừa khó đọc vừa khó test. SQL chỉ làm việc lọc thô.

Không tạo bảng lưu link riêng: trích lúc đọc thì luôn khớp với nội dung hiện tại,
còn bảng riêng sẽ lệch khi tin bị thu hồi.

#### Thay đổi ở frontend

- `ChatPanel` thành **ba cột**: danh sách · khung chat · bảng thông tin (bảng có thể
  đóng/mở). Màn hình hẹp thì bảng chiếm toàn màn hình như một trang riêng.
- Gom nút Ghim/Tắt thông báo từ header vào bảng; header chỉ giữ nút **ⓘ**.
- **Sửa lỗi state:** cho `hoiThoaiDangMo` dẫn xuất từ `hoiThoais` theo id, để mọi
  thay đổi tuỳ chọn phản ánh ngay ở cả ba nơi (danh sách, header, bảng thông tin).

#### Thứ tự làm

1. Migration (cột `biet_danh` + index đính kèm) — nhỏ, làm trước để không chặn.
2. Backend: biệt danh, ảnh/tệp, liên kết + test.
3. Sửa lỗi state `hoiThoaiDangMo`.
4. Frontend: bảng thông tin ba cột + các tab.
5. Mobile: bảng thông tin dạng màn hình riêng (làm sau, cùng đợt P4-mobile).

Ước lượng: **1.5–2 ngày** cho web (backend + frontend), mobile tính riêng.

### 11.1 Đặc tả tìm kiếm tin nhắn — ĐÃ LÀM (xem ghi chú P4 ở trên)

> Giữ lại đặc tả gốc để đối chiếu. Bản triển khai thực tế **khác ở chỗ bỏ dấu** —
> lý do và cách làm ghi ở mục P4 phía trên.

Chưa triển khai. Ghi lại ở đây để khi vào P4 không phải thiết kế lại.

**Endpoint**

```
GET /api/tin-nhan/tim-kiem?q=<từ khoá>&hoiThoaiId=<tuỳ chọn>&page=1&limit=20
```

- `q` bắt buộc, tối thiểu 2 ký tự (tránh quét toàn bảng vì một chữ cái).
- `hoiThoaiId` bỏ trống = tìm trong **mọi hội thoại người gọi đang là thành viên**.
- Trả về `PaginatedResponse<TinNhanResponse>` kèm thêm `tenHoiThoai` để hiển thị kết quả gộp nhiều hội thoại.

**Phạm vi quyền** — dùng lại đúng luật hiện có, không nới lỏng:
truy vấn luôn `JOIN thanh_vien_cuoc_tro_chuyen tv ON tv.nguoi_dung_id = :toi AND tv.roi_luc IS NULL`.
Không được tìm thấy tin của hội thoại mình không tham gia, kể cả khi đoán đúng từ khoá.
Bỏ qua tin `da_thu_hoi = true` và `xoa_luc IS NOT NULL`.

**Chỉ mục** — tiếng Việt có dấu nên `LIKE '%...%'` sẽ quét tuần tự, chậm dần theo số tin:

```sql
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX idx_tin_nhan_noi_dung_trgm
    ON tin_nhan USING gin (noi_dung gin_trgm_ops)
    WHERE xoa_luc IS NULL AND da_thu_hoi = false;
```

Chọn **trigram** chứ không phải full-text search (`tsvector`) vì bộ phân tách từ mặc định
của PostgreSQL không hiểu tiếng Việt; trigram khớp theo chuỗi con nên không phụ thuộc
ngôn ngữ và hỗ trợ tốt tìm kiếm một phần từ.

**Giao diện**
- Ô tìm kiếm ngay trên danh sách hội thoại, gõ xong chờ 300ms mới gọi API.
- Kết quả hiện đoạn trích có **tô đậm từ khoá**, kèm tên hội thoại và thời gian.
- Bấm vào kết quả → mở hội thoại và **cuộn tới đúng tin** bằng `so_thu_tu`
  (gọi `/tin-nhan?truoc=<seq+1>` để nạp đúng vùng quanh tin đó).

**Rủi ro cần lưu ý:** đây là tính năng cho phép quét lại toàn bộ lịch sử, nên phải
gắn liền với chính sách lưu trữ ở P6. Nếu sau này có xoá tin theo hạn thì chỉ mục
trigram cũng cần được dọn theo.

---

### 11.3 Đặc tả P8 — Thao tác trên tin nhắn và trên danh sách hội thoại

Phát sinh khi dùng thật: muốn chuyển tiếp một tin sang hội thoại khác, muốn ghim
tin quan trọng, muốn xem ai đã đọc, muốn nhảy nhanh xuống cuối, và muốn thao tác
với một hội thoại **mà không phải mở nó ra**.

#### Đã tra cứu quy ước của các ứng dụng phổ biến

| Câu hỏi | Kết quả tra cứu | Áp dụng vào EasyHouse |
|---|---|---|
| Ghim được bao nhiêu tin? | Signal và WhatsApp: **3 tin/đoạn chat**, vượt thì tin cũ nhất tự bị bỏ ghim. Messenger không công bố. | Chọn **5**, đặt thành hằng số `GIOI_HAN_GHIM`. Nhóm "cả nhà" thường ghim nội quy + lịch thu tiền + số liên hệ khẩn, 3 hơi chật. Vượt hạn thì **báo lỗi rõ**, không tự bỏ ghim tin cũ — tự ý gỡ ghim của người khác là hành vi khó đoán. |
| Lưu trữ khác xoá thế nào? | **Lưu trữ**: ẩn khỏi danh sách, giữ nguyên lịch sử, có tin mới thì hiện lại — **đảo ngược được**. **Xoá**: chỉ xoá bản của *mình*, người kia vẫn còn nguyên; có tin mới thì đoạn chat hiện lại nhưng **trống**. | Làm đúng như vậy. Xem bảng dữ liệu bên dưới. |

#### Thay đổi dữ liệu — `sql/migrations/20260722_add_chat_p8.sql`

| Cột | Bảng | Vì sao |
|---|---|---|
| `ghim_luc timestamptz`, `nguoi_ghim_id uuid` | `tin_nhan` | Ghim tin có **phạm vi cả hội thoại** (mọi thành viên cùng thấy), giống Messenger — nên thuộc về tin nhắn, không thuộc về từng thành viên. Lưu ai ghim để hiện "X đã ghim một tin nhắn". |
| `chuyen_tiep_tu_id uuid` | `tin_nhan` | Truy vết nguồn khi chuyển tiếp. Cần cho P6 kiểm duyệt: một tin bị báo cáo mà là bản chuyển tiếp thì phải lần được về gốc. |
| `luu_tru boolean` | `thanh_vien_cuoc_tro_chuyen` | Lưu trữ là lựa chọn **của từng người**, không phải của hội thoại. |
| `an_den_seq bigint` | `thanh_vien_cuoc_tro_chuyen` | "Xoá cuộc trò chuyện" kiểu Messenger. Ghi lại `so_thu_tu` lớn nhất tại thời điểm xoá; từ đó chỉ trả tin có `so_thu_tu > an_den_seq`. |

**Vì sao `an_den_seq` chứ không `DELETE`:** tin nhắn là dữ liệu **chung của nhiều
người**. Một bên bấm "xoá" mà xoá hàng thật thì bên kia mất lịch sử — vừa sai kỳ
vọng người dùng, vừa hỏng đường truy vết của P6. Dùng con trỏ seq thì mỗi người có
"tầm nhìn" riêng trên cùng một chuỗi tin, không ai đụng dữ liệu của ai.

**Vì sao dùng lại `so_thu_tu` mà không thêm mốc thời gian:** `so_thu_tu` là
`BIGSERIAL` đơn điệu, so sánh chính xác tuyệt đối. Mốc thời gian thì hai tin trong
cùng một mili-giây sẽ không phân định được, và còn dính vấn đề lệch giờ.

#### API bổ sung

| Endpoint | Việc | Ràng buộc phải giữ |
|---|---|---|
| `POST /tin-nhan/{id}/ghim` · `DELETE /tin-nhan/{id}/ghim` | Ghim / bỏ ghim tin | Phải là thành viên. Không ghim tin đã thu hồi. Tối đa `GIOI_HAN_GHIM`. Sinh tin hệ thống + bắn WS cho cả phòng. |
| `GET /tin-nhan/hoi-thoai/{id}/ghim` | Danh sách tin đã ghim | Dùng cho băng hiển thị ở đầu khung chat. |
| `POST /tin-nhan/{id}/chuyen-tiep` | Chuyển tiếp sang nhiều hội thoại | **Kiểm quyền ở hội thoại ĐÍCH**, không phải ở nguồn — đây là chỗ dễ sai nhất: người dùng đọc được tin ở A không có nghĩa được phép ghi vào B. Chặn tin đã thu hồi. |
| `GET /tin-nhan/{id}/chi-tiet` | Ai đã xem, lúc nào | Suy từ `doc_den_seq >= so_thu_tu` sẵn có — **không thêm bảng**. Chỉ người trong hội thoại xem được. |
| `PATCH /tin-nhan/hoi-thoai/{id}/tuy-chon` | Thêm `luuTru` | Gộp vào endpoint tuỳ chọn đã có thay vì đẻ endpoint mới. |
| `DELETE /tin-nhan/hoi-thoai/{id}` | Xoá bản của mình | Đặt `an_den_seq` = seq lớn nhất hiện tại. Không đụng dữ liệu người khác. |
| `GET /tin-nhan/hoi-thoai?luuTru=true` | Xem mục đã lưu trữ | Mặc định danh sách **loại** mục đã lưu trữ. |

#### Giao diện web

**Menu 3 chấm trên từng bong bóng tin** — thay cho hai nút trả lời/thu hồi đang hiện
thường trực (rối và chật): trả lời · chuyển tiếp · ghim · chi tiết · thu hồi *(chỉ
tin của mình)*.

**Băng tin đã ghim** ở đầu khung chat, bấm vào thì nhảy tới tin đó.

**Nút cuộn xuống cuối** hiện khi đã cuộn lên xa đáy, kèm số tin chưa đọc. Bấm kết
quả tìm kiếm thì nhảy tới đúng tin và tô sáng — *phần "xuống khoảng 20 tin" mà bạn
nhắc: Messenger không nhảy từng 20 tin, nó nhảy thẳng về cuối. Tôi làm theo cách đó
vì bấm nhiều lần để về đáy là thao tác thừa; nếu bạn vẫn muốn kiểu nhảy từng đoạn
thì nói, tôi đổi.*

**Menu 3 chấm trên từng mục danh sách hội thoại**: ghim · tắt thông báo (kèm thời
hạn) · lưu trữ · rời nhóm *(chỉ nhóm)* · xoá hội thoại — không cần mở hội thoại ra.

---

## 12. Rủi ro

| # | Rủi ro | Mức | Xử lý |
|---|---|---|---|
| R1 | **Cloudflare cắt WebSocket sau ~100s không có dữ liệu** → chat "chết im lặng" | **Cao** | Heartbeat STOMP 25s (§4.2) + reconnect luỹ thừa + kịch bản k6 WS xác nhận. **Phải test qua tunnel thật, không chỉ localhost.** |
| R2 | **Hikari pool = 5** nghẽn khi chat + nghiệp vụ chạy chung (C1) | **Cao** | Nâng lên 15; WS đã loại bỏ tải polling; đo bằng k6 trước/sau. |
| R3 | Đẩy WS trước khi commit → client thấy tin "ma" (C5) | **Cao** | `@TransactionalEventListener(AFTER_COMMIT)`, tuyệt đối không `@EventListener` thuần. |
| R4 | **Nghe trộm hội thoại người khác qua SUBSCRIBE** | **Cao** | D3: chỉ dùng user destination + interceptor chặn destination lạ. Đây là lỗ hổng WebSocket kinh điển. |
| R5 | Access token hết hạn sau 60 phút → WS im lặng chết | **Trung bình** | Client bắt lỗi CONNECT, gọi refresh NextAuth rồi nối lại (§4.7). |
| R6 | Role JWT chỉ ADMIN/TENANT (C7) → không phân biệt admin vs chủ nhà | **Trung bình** | `ChatPermissionService` luôn tra DB, ghi rõ trong comment. |
| R7 | `KhachThue.nguoiDung` nullable (C8) → khách thuê không có tài khoản thì không chat được | **Trung bình** | Guard + thông báo rõ; đếm số bị ảnh hưởng **trước** P1. |
| R8 | Mobile: `TextEncoder` thiếu / cleartext bị chặn trên native build (C11) | **Trung bình** | Spike 30 phút đầu P3; `expo-build-properties` cho dev, `wss://` cho prod. |
| R9 | Không có công cụ migration (C10) → DDL đặt tay 2–3 nơi, dễ lệch | **Trung bình** | Migration idempotent + checklist verify. Đề xuất Flyway thành task riêng. |
| R10 | `Phong.tangEntity` nullable (C9) → phòng chưa gán tầng rơi khỏi nhóm `FLOOR` | **Trung bình** | Fallback cột `Integer tang`; cả hai null thì bỏ qua + log, không tạo nhóm rác. |
| R11 | Chat giữa khách thuê là nội dung người dùng tạo → quấy rối, spam, riêng tư | **Trung bình** | P6: báo cáo/chặn + `AuditLog` khi admin xem. Chốt chính sách lưu trữ trước khi lên production. |
| R12 | Kênh WS dùng chung executor với gửi email (C6) | Thấp | Executor riêng cho inbound/outbound channel. |
| R13 | Lặp lại bug `ThongBao` (C13) | Thấp | Materialize thành viên ngay; danh sách dùng projection + `tin_nhan_cuoi_luc` denormalize. |
| R14 | Gửi trùng khi mạng chập chờn | Thấp | `ma_client` + `UNIQUE (cuoc_tro_chuyen_id, ma_client)`. |
| R15 | Scale ngang sau này (SimpleBroker in-memory chỉ chạy 1 node) | Thấp *(hiện tại)* | Compose hiện hardcode `container_name` nên không scale được. Khi cần: Redis đã sẵn sàng làm relay. |

---

## 13. Cần chốt — cập nhật 2026-07-22

Mục này viết từ lúc chưa code. Nay P0–P8 (web) đã xong nên phần lớn đã tự giải quyết;
giữ lại đây để thấy cái gì còn treo.

### Đã xong, không phải chốt nữa

1. ~~Duyệt **D1–D5** (§3)~~ — đã làm đúng theo D2 (WebSocket từ P1) và D3 (chỉ dùng
   user destination). Có test bảo mật cho D3.
2. ~~Phạm vi P1~~ — đã làm 1-1 + kênh hỗ trợ trước, rồi mới tới nhóm ở P2.
3. **R2 Hikari pool** — hiện đã là `maximum-pool-size=15` trong
   `application.properties`. Xong.
4. **R7 khách thuê chưa có tài khoản** — đã đếm trên DB local:
   **1 / 7** bản ghi `khach_thue` có `nguoi_dung_id` NULL. Người này **không chat
   được** (không có `nguoi_dung.id` để làm thành viên hội thoại). Số nhỏ nên không
   chặn, nhưng cần một trong hai hướng: tạo tài khoản khi thêm khách thuê, hoặc hiện
   thông báo rõ ở giao diện thay vì im lặng bỏ qua. **Chưa làm.**

### Còn treo thật sự

| # | Việc | Vì sao còn treo |
|---|---|---|
| 1 | **Chính sách lưu trữ tin nhắn** (giữ vĩnh viễn / xoá sau N tháng) | Cần bạn quyết. Ảnh hưởng index trigram, job dọn dẹp, và cả `chuyen_tiep_tu_id` (xoá tin gốc thì đứt đường truy vết). |
| 2 | **P3/P4/P7/P8 phần mobile** | Bạn đã bảo "mobile để sau". P3 code-complete nhưng chưa chạy trên máy thật. |
| 3 | **FCM cho mobile** | Web Push đã xong; mobile cần adapter riêng. |
| 4 | **Toàn bộ giao diện cho P6 kiểm duyệt** | Xem ô cảnh báo ngay bên dưới — thiếu nhiều hơn tôi ghi lúc đầu. |
| 5 | **R1: test WebSocket qua Cloudflare Tunnel thật** | Mới chỉ chạy trên localhost. Heartbeat 25s là để chống Cloudflare cắt ở ~100s — **chưa kiểm chứng qua tunnel thật**. |
| 6 | **Thông báo trình duyệt khi đóng tab** | Cần cấp quyền Notification trên trình duyệt thật; công cụ tự động không bấm được. Server phía sau đã kiểm chứng đủ. |
| 7 | **Khách thuê chưa có tài khoản** (R7 ở trên) | 1/7 bản ghi. |
| 8 | **R9: Flyway** | Migration vẫn chạy tay bằng script idempotent. Đề xuất tách thành task riêng, ngoài phạm vi module chat. |

#### Ảnh đại diện trong chat — làm 2026-07-22

Trước đó mọi chỗ trong chat đều vẽ **chữ cái đầu**, không nơi nào dùng ảnh thật của
người dùng, và nhóm thì không đặt được ảnh.

**Backend:** `CuocTroChuyenResponse.anh` giờ được **suy ra** giống hệt cách `ten` được
suy, chứ không đọc thẳng `cuoc_tro_chuyen.anh`:

| Loại | Ảnh hiển thị |
|---|---|
| `GROUP` / `BUILDING` / `FLOOR` | Ảnh của nhóm (`cuoc_tro_chuyen.anh`) |
| `DIRECT` / `SUPPORT` | Ảnh đại diện của **người còn lại** |

Lý do giống với tên: cùng một hàng `cuoc_tro_chuyen` nhưng **mỗi bên nhìn thấy một ảnh
khác nhau**, nên không thể lưu chung một cột. Trường hợp có hơn một người khác (kênh hỗ
trợ nhiều nhân viên) thì **không đoán bừa** — trả về ảnh nhóm/null để client vẽ chữ cái.

**Frontend:** gom về một component `AnhDaiDien` dùng chung cho cả 5 chỗ (danh sách, đầu
khung chat, cạnh bong bóng tin, bảng thông tin, hộp danh bạ). Trước đây mỗi nơi tự vẽ
một kiểu. Có ảnh thì hiện ảnh, không thì rơi về chữ cái đầu / biểu tượng nhóm; **ảnh
hỏng link cũng rơi về chữ cái** chứ không để ô vỡ. Chữ cái nằm *dưới*, ảnh phủ *lên* —
nhờ vậy lúc ảnh đang tải vẫn luôn có thứ để nhìn, không nhấp nháy ô trống.

Ảnh cạnh bong bóng tin chỉ hiện ở **tin cuối cụm** và chỉ với tin của **người khác** —
gắn vào mọi tin thì một chuỗi 5 tin sẽ có 5 ảnh giống hệt nhau. Các tin còn lại chừa
một khoảng trống cùng bề rộng để bong bóng vẫn thẳng hàng.

**Đổi tên và ảnh nhóm:** nút bút chì cạnh tên + nút máy ảnh trên avatar, đều ở bảng
thông tin. Backend vốn đã hỗ trợ cả hai qua `PATCH /hoi-thoai/{id}` từ P2 — **chỉ thiếu
giao diện**, không ai gọi tới. Ô nhập tên dùng cùng kiểu tương tác với sửa biệt danh
bên dưới (Enter lưu, Esc huỷ) để không phải học hai cách. Tên rỗng hoặc y hệt tên cũ
thì chỉ đóng ô nhập, không gọi API — tránh sinh tin hệ thống rác.

Chat 1-1 **cố ý không cho đổi ảnh** vì đó là ảnh đại diện của đối phương.

**Điều kiện hiện nút — khớp đúng `ChatPermissionService.yeuCauQuanTriNhom`:**

1. Chỉ nhóm **tự tạo** (`GROUP`). Nhóm theo nhà trọ / theo tầng do job đồng bộ quản lý,
   sửa tay xong sẽ bị ghi đè — server cũng từ chối thẳng.
2. Phải là **OWNER hoặc MODERATOR** của nhóm.

*Lỗi bắt được ngay khi làm phần này:* nút đổi ảnh ban đầu dùng `laLoaiNhom(...)` nên
hiện cả với nhóm `BUILDING`/`FLOOR` — bấm vào chắc chắn 403. Đúng kiểu "nút bấm không
ăn" mà đã bị phàn nàn trước đó. Đã siết lại đúng hai điều kiện trên.

*Chỗ chưa phủ hết (biết và chấp nhận):* server còn cho chủ trọ / nhân viên có quyền sửa
nhà trọ được quản trị nhóm trong phạm vi đó, nhưng client không biết được quyền ấy. Nếu
họ chỉ là thành viên thường của nhóm thì sẽ **không thấy nút**, dù server cho phép. Chọn
ẩn nút thay vì hiện một nút có thể 403, vì trường hợp thường gặp là người tạo nhóm cũng
chính là OWNER.

**Kiểm chứng đổi tên:** OWNER thấy cả hai nút; MEMBER của nhóm tự tạo **không** thấy;
nhóm `FLOOR` (Tầng 2) **không** thấy. Đổi tên từ giao diện: tên trong danh sách khớp
đúng tên vừa nhập, tin hệ thống *"… đã đổi tên nhóm thành …"* đúng nội dung, ô nhập tự
đóng. Backend cũng kiểm riêng qua API (`PATCH` 200, tên trong response khớp).

**Kiểm chứng:** DB local vốn có **0/8** người dùng với ảnh — nên phải seed ảnh thật rồi
mới kiểm được, nếu không màn hình vẫn hiện chữ cái và dễ tưởng nhầm là code sai.
Kết quả: A nhìn thấy ảnh của B và B nhìn thấy ảnh của A (đúng đối xứng); ảnh hiện ở
danh sách, đầu khung chat, cạnh tin của người khác, và trong bảng thông tin; nhóm có
ảnh thì hiện ảnh, nhóm chưa có thì hiện biểu tượng nhóm; nút đổi ảnh chỉ có ở nhóm.

⚠️ **Chưa kiểm chứng được:** bước **tải ảnh lên** thật, vì Cloudinary trong môi trường
dev đang là khoá giả (`cloud_name is disabled`). Đường `PATCH` gắn URL vào nhóm thì đã
kiểm chứng chạy đúng (200 + sinh tin hệ thống). Khi có khoá Cloudinary thật cần thử lại
nguyên luồng chọn tệp → tải lên → đổi ảnh.

#### Xác nhận lại hành vi lưu trữ và xoá — 2026-07-22

Theo yêu cầu, đã viết smoke test riêng để **chứng minh** hai điều (10/10 pass), không
phải sửa gì vì hành vi vốn đã đúng:

- **Lưu trữ là lưu trữ mãi.** Có tin mới cũng **không** tự bật lại về danh sách chính;
  vẫn nằm trong kho, lịch sử và tin mới vẫn đọc được bình thường.
  *(Khác với hành vi Messenger đã tra ở §11.3 — Messenger tự bỏ lưu trữ khi có tin mới.
  Ở đây làm theo yêu cầu: giữ nguyên trong kho.)*
- **Xoá chỉ ảnh hưởng người xoá.** Người kia giữ **nguyên vẹn** toàn bộ lịch sử (82/82
  tin) và hội thoại vẫn nằm trong danh sách của họ. Trong nhóm: thành viên khác thấy đủ
  lịch sử, và **người xoá vẫn còn là thành viên** — xoá ≠ rời nhóm.

> ⚠️ **P6 kiểm duyệt hiện KHÔNG dùng được từ giao diện** — đính chính 2026-07-22.
>
> Ghi chú cũ nói "chỉ thiếu màn hình admin" là **sai, thiếu nhiều hơn thế**. Kiểm lại:
>
> | Thành phần | Trạng thái |
> |---|---|
> | Backend: 5 endpoint `/api/kiem-duyet-chat/*`, service, bảng, audit log, unit test | ✅ Có |
> | Nút **Báo cáo** trong menu tin nhắn | ❌ Chưa có |
> | Nút **Chặn người dùng** trong menu hội thoại / bảng thông tin | ❌ Chưa có |
> | Màn hình admin duyệt danh sách báo cáo | ❌ Chưa có |
> | Rewrite `/api/kiem-duyet-chat` trong `frontend/next.config.ts` | ❌ **Chưa có** — thiếu cái này thì dù có nút cũng gọi lỗi |
>
> Tức là tính năng mới chỉ tồn tại ở tầng backend và trong test. Người dùng cuối
> **chưa báo cáo hay chặn được ai**. Khi làm tiếp, nhớ thêm rewrite TRƯỚC, nếu không
> sẽ mất thời gian dò một lỗi 404 rất khó hiểu.
>
> Nhắc lại phạm vi để khỏi hiểu nhầm: đây là kiểm duyệt kiểu **người dùng báo cáo →
> admin xử lý**, KHÔNG có lọc từ ngữ tự động hay duyệt nội dung bằng máy.
