# EasyHouse Mobile

Ứng dụng di động cho hệ thống quản lý phòng trọ EasyHouse, dùng chung backend Spring Boot qua REST + JWT (**không cần sửa backend**).

## Stack

- **Expo SDK 52** + React Native 0.76 + **expo-router** (file-based routing)
- TypeScript, `expo-secure-store` (lưu JWT), `@expo/vector-icons`
- Một app **phân quyền theo vai trò**:
  - `ADMIN` / `LANDLORD` / `STAFF` → `app/(manager)` (tổng quan, hoá đơn, sự cố, thông báo)
  - `TENANT` → `app/(tenant)` (trang chủ, thông báo, tài khoản)

## Cấu trúc

```
mobile/
├─ app/                     # expo-router routes
│  ├─ _layout.tsx           # AuthProvider + điều hướng theo phiên/vai trò
│  ├─ index.tsx             # redirect theo trạng thái đăng nhập
│  ├─ (auth)/login.tsx      # đăng nhập 2 vai trò (email / SĐT)
│  ├─ (manager)/            # tab dành cho chủ trọ/nhân viên
│  └─ (tenant)/             # tab dành cho khách thuê
└─ src/
   ├─ api/client.ts         # fetch wrapper: gắn Bearer, tự refresh khi 401
   ├─ api/auth.ts           # loginManager / loginTenant / logout
   ├─ auth/                 # AuthContext + SecureStore
   ├─ components/           # UI dùng chung
   ├─ lib/                  # format tiền/ngày/trạng thái, hook useList
   ├─ types/                # contract khớp DTO backend (giữ tên tiếng Việt)
   └─ theme.ts              # design token (thương hiệu teal)
```

## Chạy dự án

```bash
cd mobile
npm install
# Đồng bộ phiên bản gói theo đúng Expo SDK (khuyến nghị chạy 1 lần):
npx expo install --fix
npx expo start
```

Mở bằng app **Expo Go** trên điện thoại (quét QR), hoặc nhấn `a` (Android emulator) / `i` (iOS simulator).

## Cấu hình backend URL

Đặt trong `app.json` → `expo.extra.apiBaseUrl`:

- Android emulator: `http://10.0.2.2:8080` (mặc định)
- iOS simulator: `http://localhost:8080`
- Thiết bị thật: `http://<IP-LAN-máy-chạy-backend>:8080`

## Endpoint đang dùng

| Chức năng | Endpoint |
|---|---|
| Đăng nhập chủ trọ/NV | `POST /api/auth/login` (email) |
| Đăng nhập khách thuê | `POST /api/auth/khach-thue/login` (SĐT) |
| Làm mới token | `POST /api/auth/refresh` |
| Đăng xuất | `POST /api/auth/logout` |
| Tổng quan (manager) | `GET /api/dashboard/stats` |
| Hoá đơn (manager) | `GET /api/hoa-don` |
| Sự cố (manager) | `GET /api/su-co` |
| Thông báo (manager) | `GET /api/thong-bao` |
| Trang chủ khách thuê | `GET /api/auth/khach-thue/me` |
| Thông báo khách thuê | `GET /api/thong-bao/my` |

## Phạm vi hiện tại (MVP — chỉ đọc)

Đã có: đăng nhập 2 vai trò, điều hướng phân quyền, dashboard + các danh sách dạng đọc, tự refresh JWT.

**Chưa làm** (giai đoạn sau): chi tiết + thanh toán hoá đơn (VietQR/VNPay), form báo sự cố + upload ảnh,
ghi chỉ số điện nước, CRUD hợp đồng/khách thuê, push notification.

> Lưu ý: các endpoint danh sách backend hiện **chưa lọc theo khách thuê**, nên phía TENANT chỉ dùng
> endpoint tenant-scoped (`/khach-thue/me`, `/thong-bao/my`) để tránh lộ dữ liệu của người khác.
