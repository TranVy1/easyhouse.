# Kế hoạch Build APK Android - EasyHouse (Khách Thuê)

> Tài liệu này phác thảo kế hoạch xây dựng app Android tại `apk/` cho khách thuê phòng, kết nối tới backend Spring Boot tại `be/`.

## Tổng quan

App Android **EasyHouse** dành riêng cho **khách thuê phòng** (tenant). App kết nối trực tiếp với backend Spring Boot đã có tại `be/` thông qua REST API JSON.

- **Frontend Next.js** (`frontend/`) — dành cho chủ nhà / admin (web)
- **App Android** (`apk/`) — dành cho khách thuê (mobile)

**Scaffold hiện tại** tại `apk/`: Android Gradle project với Kotlin + Jetpack Compose, `compileSdk 36`, `minSdk 24`, chỉ có `MainActivity` rỗng.

---

## Kiến trúc tổng thể

```
apk/
└── app/src/main/java/com/example/easyhouse/
    ├── data/
    │   ├── api/          # Retrofit interfaces + interceptors
    │   ├── model/        # Data classes (JSON mapping)
    │   └── repository/   # Repository pattern
    ├── ui/
    │   ├── theme/        # Colors, Typography, Theme
    │   ├── auth/         # Màn hình đăng nhập
    │   ├── home/         # Dashboard / Home
    │   ├── hoaDon/       # Hóa đơn (list + detail)
    │   ├── hopDong/      # Hợp đồng thuê
    │   ├── suCo/         # Báo cáo sự cố
    │   ├── thongBao/     # Thông báo
    │   └── components/   # Shared composables
    ├── navigation/       # NavHost + Routes
    └── MainActivity.kt
```

---

## Tech Stack

| Thư viện | Version | Mục đích |
|---|---|---|
| Retrofit2 | 2.11.0 | HTTP client |
| OkHttp3 Logging | 4.12.0 | Debug HTTP logs |
| Gson Converter | 2.11.0 | JSON parsing |
| Navigation Compose | 2.8.x | Screen navigation |
| Lifecycle ViewModel Compose | 2.8.x | ViewModel |
| Coil Compose | 2.7.x | Image loading |
| DataStore Preferences | 1.1.x | Local token storage |
| Coroutines | 1.8.x | Async/await |

---

## API Endpoints dùng trong App

### Authentication
| Method | Endpoint | Mô tả |
|---|---|---|
| POST | `/api/auth/khach-thue/login` | Đăng nhập bằng mã KT + mật khẩu |
| GET | `/api/auth/khach-thue/me` | Lấy thông tin khách thuê hiện tại |

### Tenant APIs
| Method | Endpoint | Mô tả |
|---|---|---|
| GET | `/api/tenant/hoa-don` | Danh sách hóa đơn |
| GET | `/api/tenant/hoa-don/{id}` | Chi tiết hóa đơn + lịch sử TT |
| GET | `/api/tenant/hop-dong` | Danh sách hợp đồng |
| GET | `/api/tenant/su-co` | Sự cố của tôi |
| POST | `/api/su-co` | Tạo sự cố mới |
| GET | `/api/tenant/thong-bao` | Thông báo |
| PATCH | `/api/thong-bao/{id}/da-doc` | Đánh dấu đã đọc |

---

## Màn hình (Screens)

### 1. LoginScreen
- Logo EasyHouse + tagline tiếng Việt
- Input: Mã khách thuê (`maKhachThue`)
- Input: Mật khẩu
- Nút "Đăng nhập"
- Validation + loading + error state

### 2. HomeScreen
- Header: Avatar + "Xin chào, {tenKhachThue}"
- Card: thông tin phòng (số phòng, tòa nhà, tầng)
- Card: hóa đơn gần nhất (số tiền, trạng thái badge màu)
- Card: hợp đồng (ngày hết hạn, trạng thái)
- Quick actions: Báo sự cố, Xem hóa đơn

### 3. HoaDonListScreen + HoaDonDetailScreen
- LazyColumn danh sách hóa đơn
- Filter chip: Tất cả / Chưa TT / Đã TT / Quá hạn
- Detail: breakdown tiền phòng, điện, nước, dịch vụ + lịch sử TT

### 4. HopDongScreen
- Danh sách hợp đồng (ngày BĐ, ngày KT, tiền thuê, cọc)

### 5. SuCoListScreen + SuCoCreateScreen
- Danh sách sự cố với badge ưu tiên màu
- Form tạo sự cố: tiêu đề, mô tả, loại, ưu tiên

### 6. ThongBaoScreen
- Danh sách thông báo (chưa đọc highlight)
- Tap → đánh dấu đã đọc
- Badge số chưa đọc trên tab icon

---

## Navigation

```kotlin
sealed class Screen(val route: String) {
    object Login : Screen("login")
    object Home : Screen("home")
    object HoaDonList : Screen("hoa_don")
    object HoaDonDetail : Screen("hoa_don/{id}")
    object HopDong : Screen("hop_dong")
    object SuCo : Screen("su_co")
    object SuCoCreate : Screen("su_co/create")
    object ThongBao : Screen("thong_bao")
}
```

Bottom Navigation Bar: **Trang chủ | Hóa đơn | Sự cố | Thông báo**

---

## Luồng xác thực

```
App khởi động
  → Kiểm tra DataStore có token?
     ├── Có → GET /api/auth/khach-thue/me → HomeScreen
     └── Không → LoginScreen

LoginScreen
  → POST /api/auth/khach-thue/login {maKhachThue, matKhau}
  → Nhận token → lưu DataStore → HomeScreen
```

---

## Thứ tự thực hiện

| STT | Task | Files chính |
|-----|------|-------------|
| 1 | Gradle dependencies | `build.gradle.kts`, `libs.versions.toml` |
| 2 | AndroidManifest (INTERNET) | `AndroidManifest.xml` |
| 3 | Data models | `data/model/*.kt` |
| 4 | API interfaces (Retrofit) | `data/api/*.kt` |
| 5 | TokenDataStore | `data/local/TokenDataStore.kt` |
| 6 | Repositories | `data/repository/*.kt` |
| 7 | Theme (màu EasyHouse) | `ui/theme/Color.kt` |
| 8 | Navigation graph | `navigation/NavGraph.kt` |
| 9 | LoginScreen + VM | `ui/auth/` |
| 10 | HomeScreen + VM | `ui/home/` |
| 11 | HoaDon screens + VM | `ui/hoaDon/` |
| 12 | HopDong screen + VM | `ui/hopDong/` |
| 13 | SuCo screens + VM | `ui/suCo/` |
| 14 | ThongBao screen + VM | `ui/thongBao/` |
| 15 | MainActivity wiring | `MainActivity.kt` |
| 16 | Build APK | `gradlew assembleDebug` |

---

## Build Command

```powershell
cd f:\qlyphongtro\apk
.\gradlew assembleDebug
# Output: apk/app/build/outputs/apk/debug/app-debug.apk
```

---

## Màu sắc thương hiệu (EasyHouse)

| Token | Màu | Hex |
|---|---|---|
| Primary | Xanh navy đậm | `#1E3A5F` |
| Primary Container | Xanh navy nhạt | `#3A6EA5` |
| Accent / Secondary | Vàng cam | `#F0A500` |
| Background | Trắng xám | `#F8F9FA` |
| Surface | Trắng | `#FFFFFF` |
| Error | Đỏ | `#D32F2F` |
