# 📋 KẾ HOẠCH HOÀN THIỆN HỆ THỐNG QUẢN LÝ PHÒNG TRỌ

> Tài liệu này mô tả chi tiết các chức năng còn thiếu và thứ tự triển khai để hoàn thiện app.
> Cập nhật lần cuối: 2026-05-11

---

## 📊 ĐÁNH GIÁ HIỆN TRẠNG

### ✅ Đã hoàn thiện (hoạt động tốt)

| Module                                | Backend                          | Frontend                          |
| ------------------------------------- | -------------------------------- | --------------------------------- |
| Auth (Đăng ký/Đăng nhập/Email verify) | ✅ Service + Controller          | ✅ NextAuth + Pages               |
| Tòa nhà (CRUD)                        | ✅ Entity + Service + Controller | ✅ Trang + Table                  |
| Phòng (CRUD)                          | ✅ Entity + Service + Controller | ✅ Trang + Table                  |
| Khách thuê (CRUD)                     | ✅ Entity + Service + Controller | ✅ Trang + Table                  |
| Upload Cloudinary                     | ✅ Service + Controller          | ✅ Component                      |
| Dashboard (thống kê cơ bản)           | ✅ Service + Controller          | ✅ Trang                          |
| Hợp đồng (CRUD)                       | ✅ Service + Controller          | ✅ Trang + Table                  |
| Hóa đơn (CRUD + Public)               | ✅ Service + Controller          | ✅ Trang + Table + Link Công Khai |
| Thanh toán (History)                  | ✅ Service + Controller          | ✅ Trang + Table + Recalculation  |

### ❌ Chưa hoàn thiện (chỉ có stub/shell)

| Module                | Backend                         | Frontend                        |
| --------------------- | ------------------------------- | ------------------------------- |
| **Bảo mật JWT**       | ❌ Token = "dummy", permitAll() | ⚠️ Có session nhưng ko xác thực |
| **Phân quyền**        | ❌ Không có @PreAuthorize       | ⚠️ Chỉ check admin ở 1 trang    |
| **Sự cố**             | ❌ Stub (trả mảng rỗng)         | ✅ UI có sẵn                    |
| **Thông báo**         | ❌ Stub (trả mảng rỗng)         | ✅ UI có sẵn                    |
| **Chỉ số điện nước**  | ❌ Stub                         | ⚠️ Trong form hóa đơn           |
| **Cấu hình giá**      | ❌ Chưa có                      | ❌ Chưa có                      |
| **Quản lý tài khoản** | ❌ Chưa có endpoint             | ✅ UI có sẵn                    |
| **Hồ sơ cá nhân**     | ❌ Chưa có endpoint             | ✅ UI có sẵn                    |

---

## 🔐 GIAI ĐOẠN 1: Security & JWT (Ưu tiên cao nhất) — ~2-3 ngày

> ⚠️ Đây là nền tảng cho mọi chức năng khác. Không có JWT thật → không thể phân quyền → mọi API đều public.

### Backend — Cần tạo/sửa:

#### [NEW] JwtService.java

`be/src/main/java/com/example/quanlyphongtro/config/JwtService.java`

- Tạo và verify JWT token (dùng `io.jsonwebtoken:jjwt`)
- Method: `generateToken(NguoiDung)`, `validateToken(String)`, `extractUserId(String)`
- Token chứa: userId, email, roles, expiration (24h)

#### [NEW] JwtAuthenticationFilter.java

`be/src/main/java/com/example/quanlyphongtro/config/JwtAuthenticationFilter.java`

- `OncePerRequestFilter`: đọc header `Authorization: Bearer xxx`
- Parse token → set `SecurityContextHolder` với `UsernamePasswordAuthenticationToken`

#### [MODIFY] SecurityConfig.java

`be/src/main/java/com/example/quanlyphongtro/config/SecurityConfig.java`

- Bỏ `.anyRequest().permitAll()`
- Thêm JWT filter vào chain
- Cấu hình CORS cho `http://localhost:3000`
- Public endpoints: `/api/auth/**`, `/api/xem-phong/**`
- Authenticated endpoints: tất cả còn lại
- Role-based: `/api/admin/**` → ADMIN only

#### [MODIFY] AuthService.java

`be/src/main/java/com/example/quanlyphongtro/services/AuthService.java`

- Thay `"dummy-jwt-token-for-now"` bằng JWT thật từ `JwtService`
- Trả `accessToken` + `refreshToken`

#### [NEW] pom.xml dependency

```xml
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.12.6</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.12.6</version>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.12.6</version>
    <scope>runtime</scope>
</dependency>
```

### Frontend — Cần tạo/sửa:

#### [MODIFY] src/lib/auth.ts

- Lưu accessToken thật vào session

#### [NEW] src/lib/api.ts

- Hàm `fetchWithAuth()` tự động gắn header `Authorization: Bearer {token}`
- Tất cả API call dùng hàm này thay vì `fetch()` trực tiếp

#### [MODIFY] src/middleware.ts

- Thêm check role cho các route cụ thể:
  - `/dashboard/quan-ly-tai-khoan` → chỉ ADMIN
  - `/dashboard/toa-nha`, `/dashboard/phong`... → ADMIN + LANDLORD
  - `/dashboard/su-co`, `/dashboard/ho-so` → tất cả roles

---

## 🗄️ GIAI ĐOẠN 2: Backend CRUD Thật — ~5-7 ngày

> ⚠️ Hiện tại 6 controller chỉ trả mảng rỗng. Cần xây dựng Entity → Repository → Service → Controller hoàn chỉnh.

### 2.1 Hợp Đồng (hop_dong)

| File cần tạo/sửa    | Đường dẫn                           | Mô tả                                                           |
| ------------------- | ----------------------------------- | --------------------------------------------------------------- |
| [CHECK] Entity      | `entity/HopDong.java`               | Đã có, cần kiểm tra mapping                                     |
| [NEW] Repository    | `repository/HopDongRepository.java` | JPQL: findByPhong, findByKhachThue, findActive                  |
| [NEW] DTO Request   | `dto/HopDongRequest.java`           | phongId, khachThueId, ngayBatDau, ngayKetThuc, giaThue, tienCoc |
| [NEW] DTO Response  | `dto/HopDongResponse.java`          | Kèm thông tin phòng, khách thuê populated                       |
| [NEW] Service       | `services/HopDongService.java`      | CRUD + tạo HĐ → đổi phòng RENTED, hủy HĐ → phòng AVAILABLE      |
| [MODIFY] Controller | `controller/HopDongController.java` | GET, GET/{id}, POST, PUT/{id}, DELETE/{id}                      |

### 2.2 Chỉ Số Điện Nước (chi_so_dien_nuoc)

| File                | Đường dẫn                                 | Mô tả                                        |
| ------------------- | ----------------------------------------- | -------------------------------------------- |
| [NEW] Entity        | `entity/ChiSoDienNuoc.java`               | Map bảng `chi_so_dien_nuoc`                  |
| [NEW] Repository    | `repository/ChiSoDienNuocRepository.java` | findLatestByPhong, findByPhongAndThang       |
| [NEW] DTO           | `dto/ChiSoDienNuocRequest.java`           | phongId, ngayGhi, chiSoDienMoi, chiSoNuocMoi |
| [NEW] Service       | `services/ChiSoDienNuocService.java`      | Ghi chỉ số mới, tự lấy chỉ số cũ từ kỳ trước |
| [MODIFY] Controller | `controller/ChiSoDienNuocController.java` | GET, POST, GET /latest                       |

### 2.3 Cấu Hình Giá (cau_hinh_gia)

| File             | Đường dẫn                              | Mô tả                                              |
| ---------------- | -------------------------------------- | -------------------------------------------------- |
| [NEW] Entity     | `entity/CauHinhGia.java`               | Map bảng `cau_hinh_gia`                            |
| [NEW] Repository | `repository/CauHinhGiaRepository.java` | findLatestByNhaTro                                 |
| [NEW] DTO        | `dto/CauHinhGiaRequest.java`           | nhaTroId, giaDien, giaNuoc, giaDichVu, giaInternet |
| [NEW] Service    | `services/CauHinhGiaService.java`      | CRUD                                               |
| [NEW] Controller | `controller/CauHinhGiaController.java` | `/api/cau-hinh-gia`                                |

**Frontend:** Cần thêm rewrite `/api/cau-hinh-gia` vào `next.config.ts`

### 2.4 Hóa Đơn (hoa_don + chi_tiet_hoa_don)

| File                | Đường dẫn                          | Mô tả                                           |
| ------------------- | ---------------------------------- | ----------------------------------------------- |
| [NEW] Entity        | `entity/HoaDon.java`               | Map bảng `hoa_don`                              |
| [NEW] Entity        | `entity/ChiTietHoaDon.java`        | Map bảng `chi_tiet_hoa_don`                     |
| [NEW] Repository    | `repository/HoaDonRepository.java` | findByPhong, findByTrangThai, thống kê          |
| [NEW] DTO Request   | `dto/HoaDonRequest.java`           | hopDongId, thangHoaDon, chiSoDien/Nuoc          |
| [NEW] DTO Response  | `dto/HoaDonResponse.java`          | Kèm chi tiết, phòng, khách                      |
| [NEW] Service       | `services/HoaDonService.java`      | **Tính toán tổng tiền** (logic quan trọng nhất) |
| [MODIFY] Controller | `controller/HoaDonController.java` | Thay tất cả stub bằng service thật              |

**Logic tính hóa đơn:**

```
tienPhong   = giaThue từ hợp đồng
tienDien    = (chiSoMoi - chiSoCu) × giaDien từ cấu hình
tienNuoc    = (chiSoMoi - chiSoCu) × giaNuoc từ cấu hình
phiDichVu   = giaDichVu × số người (hoặc /phòng tùy loại)
tongTien    = tienPhong + tienDien + tienNuoc + phiDichVu
```

### 2.5 Thanh Toán (thanh_toan)

| File                | Đường dẫn                             | Mô tả                                          |
| ------------------- | ------------------------------------- | ---------------------------------------------- |
| [NEW] Entity        | `entity/ThanhToan.java`               | Map bảng `thanh_toan`                          |
| [NEW] Repository    | `repository/ThanhToanRepository.java` | findByHoaDon, tổng đã trả                      |
| [NEW] DTO           | `dto/ThanhToanRequest.java`           | hoaDonId, soTien, phuongThuc                   |
| [NEW] Service       | `services/ThanhToanService.java`      | Ghi nhận + trigger cập nhật trạng thái hóa đơn |
| [MODIFY] Controller | `controller/ThanhToanController.java` | Thay stub bằng service thật                    |

### 2.6 Sự Cố (su_co)

| File                | Đường dẫn                        | Mô tả                                        |
| ------------------- | -------------------------------- | -------------------------------------------- |
| [NEW] Entity        | `entity/SuCo.java`               | Map bảng `su_co`                             |
| [NEW] Repository    | `repository/SuCoRepository.java` | findByPhong, findByTrangThai                 |
| [NEW] DTO Request   | `dto/SuCoRequest.java`           | phongId, khachThueId, tieuDe, moTa, loaiSuCo |
| [NEW] DTO Response  | `dto/SuCoResponse.java`          | Kèm tên phòng, tên khách thuê                |
| [NEW] Service       | `services/SuCoService.java`      | CRUD + cập nhật trạng thái                   |
| [MODIFY] Controller | `controller/SuCoController.java` | GET, GET/{id}, POST, PUT/{id}, DELETE/{id}   |

### 2.7 Thông Báo (thong_bao)

| File                | Đường dẫn                            | Mô tả                              |
| ------------------- | ------------------------------------ | ---------------------------------- |
| [NEW] Entity        | `entity/ThongBao.java`               | Map bảng `thong_bao`               |
| [NEW] Repository    | `repository/ThongBaoRepository.java` | findByNguoiDung, countUnread       |
| [NEW] DTO           | `dto/ThongBaoRequest.java`           | tieuDe, noiDung, loai, nguoiNhan[] |
| [NEW] Service       | `services/ThongBaoService.java`      | Tạo, đánh dấu đã đọc, xóa          |
| [MODIFY] Controller | `controller/ThongBaoController.java` | CRUD + GET /chua-doc               |

### 2.8 Quản Lý Tài Khoản (Admin)

| File             | Đường dẫn                         | Mô tả                                     |
| ---------------- | --------------------------------- | ----------------------------------------- |
| [NEW] Controller | `controller/AdminController.java` | GET, POST, PUT, DELETE `/api/admin/users` |
| [NEW] Service    | `services/AdminService.java`      | CRUD NguoiDung + quản lý VaiTro           |

### 2.9 Hồ Sơ Cá Nhân

| File             | Đường dẫn                        | Mô tả                                                        |
| ---------------- | -------------------------------- | ------------------------------------------------------------ |
| [NEW] Controller | `controller/UserController.java` | GET/PUT `/api/user/profile`, PUT `/api/user/change-password` |
| [NEW] Service    | `services/UserService.java`      | Get/Update profile từ JWT token                              |

---

## 🔑 GIAI ĐOẠN 3: Phân Quyền 3 Vai Trò — ~2-3 ngày

### ⚠️ Vấn đề chuẩn hóa tên vai trò

Hiện tại frontend dùng tên không nhất quán:

- `admin` (frontend) vs `ADMIN` (database)
- `chuNha` (frontend) vs `LANDLORD` (database)
- `nhanVien` (frontend) vs không có (database)

**Cần thống nhất:** Backend trả `ADMIN`/`LANDLORD`/`TENANT`, frontend map sang tên hiển thị tiếng Việt.

### Ma trận phân quyền

| Chức năng  | ADMIN          | LANDLORD          | TENANT              |
| ---------- | -------------- | ----------------- | ------------------- |
| Dashboard  | ✅ Toàn bộ     | ✅ Nhà trọ mình   | ✅ Phòng mình       |
| Tòa nhà    | ✅ CRUD tất cả | ✅ CRUD nhà mình  | ❌ Không thấy       |
| Phòng      | ✅ CRUD tất cả | ✅ CRUD nhà mình  | 👁️ Xem phòng mình   |
| Khách thuê | ✅ CRUD        | ✅ CRUD nhà mình  | 👁️ Xem hồ sơ mình   |
| Hợp đồng   | ✅ CRUD        | ✅ CRUD nhà mình  | 👁️ Xem HĐ mình      |
| Hóa đơn    | ✅ CRUD        | ✅ Tạo & quản lý  | 👁️ Xem & thanh toán |
| Thanh toán | ✅ Tất cả      | ✅ Ghi nhận       | ✅ Thanh toán       |
| Sự cố      | ✅ Tất cả      | ✅ Xử lý          | ✅ Báo cáo          |
| Thông báo  | ✅ Gửi tất cả  | ✅ Gửi khách mình | 👁️ Nhận thông báo   |
| Quản lý TK | ✅ CRUD        | ❌                | ❌                  |
| Hồ sơ      | ✅             | ✅                | ✅                  |
| Cài đặt    | ✅ Hệ thống    | ✅ Nhà mình       | ✅ Cá nhân          |

### Backend: @PreAuthorize

```java
// Ví dụ cách dùng
@PreAuthorize("hasRole('ADMIN')")
@GetMapping("/api/admin/users")
public ApiResponse<List<UserResponse>> getAllUsers() { ... }

@PreAuthorize("hasAnyRole('ADMIN', 'LANDLORD')")
@PostMapping("/api/hoa-don")
public ApiResponse<HoaDonResponse> createHoaDon(...) { ... }

@PreAuthorize("hasAnyRole('ADMIN', 'LANDLORD', 'TENANT')")
@GetMapping("/api/su-co")
public ApiResponse<List<SuCoResponse>> getSuCo(...) { ... }
```

### Frontend: Sidebar theo role

#### [MODIFY] src/components/app-sidebar.tsx

- **TENANT:** Dashboard (phòng mình), Sự cố (báo cáo), Hóa đơn (xem), Hồ sơ
- **LANDLORD:** Tất cả trừ Quản trị
- **ADMIN:** Tất cả

#### [MODIFY] src/middleware.ts

```typescript
// Check role cho từng nhóm route
if (req.nextUrl.pathname.startsWith("/dashboard/quan-ly-tai-khoan")) {
  return token?.role === "ADMIN";
}
if (
  req.nextUrl.pathname.startsWith("/dashboard/toa-nha") ||
  req.nextUrl.pathname.startsWith("/dashboard/phong")
) {
  return ["ADMIN", "LANDLORD"].includes(token?.role);
}
```

---

## 📊 GIAI ĐOẠN 4: Dashboard Thống Kê Thật — ~1-2 ngày

### [MODIFY] DashboardService.java

Thay số cứng bằng query thật:

```java
tongSoPhong     = phongRepository.count();
phongTrong      = phongRepository.countByTrangThai(AVAILABLE);
phongDangThue   = phongRepository.countByTrangThai(RENTED);
doanhThuThang   = hoaDonRepository.sumTongTienByThangAndTrangThai(currentMonth, PAID);
suCoCanXuLy     = suCoRepository.countByTrangThai(PENDING);
hopDongSapHetHan = hopDongRepository.countByNgayKetThucBefore(plus30Days);
hoaDonSapDenHan  = hoaDonRepository.countByHanTraBeforeAndTrangThai(plus7Days, UNPAID);
```

### [MODIFY] Dashboard page.tsx

- Thay phần "Hoạt động gần đây" (đang hardcoded) bằng API thật
- Thêm biểu đồ doanh thu theo tháng (dùng Recharts)
- Dashboard khác nhau theo role:
  - ADMIN: tổng quan toàn hệ thống
  - LANDLORD: chỉ nhà trọ của mình
  - TENANT: chỉ phòng và hóa đơn của mình

---

## 🚀 GIAI ĐOẠN 5: Chức Năng Nâng Cao — ~3-5 ngày

### 5.1 Enum Mapping (Chuẩn hóa)

- Database: `AVAILABLE`, `RENTED`, `PENDING`...
- Backend DTO: Giữ nguyên enum DB
- Frontend: Map enum → nhãn tiếng Việt hiển thị

### 5.2 Xuất PDF Hóa Đơn

- Backend: Endpoint `/api/hoa-don/{id}/pdf` dùng iText hoặc JasperReports
- Frontend: Đã có `html2canvas` + `jspdf` → cải thiện template

### 5.3 Trang Công Khai Xem Phòng

- `/xem-phong` → danh sách phòng trống (không cần đăng nhập)
- `/xem-phong/{id}` → chi tiết phòng + ảnh + tiện ích + giá

### 5.4 Cài Đặt Hệ Thống

- Trang `/dashboard/cai-dat`:
  - Cấu hình giá điện/nước/dịch vụ cho từng nhà trọ
  - Thông tin ngân hàng (QR thanh toán)
  - Mẫu hợp đồng mặc định

### 5.5 Tích Hợp Thanh Toán Online (Tùy chọn)

- VNPay hoặc Momo QR
- Webhook callback cập nhật trạng thái hóa đơn

---

## 📅 TIMELINE TỔNG QUAN

| Giai đoạn           | Thời gian       | Mô tả                                                  |
| ------------------- | --------------- | ------------------------------------------------------ |
| GĐ1: JWT & Security | 2-3 ngày        | Nền tảng bắt buộc                                      |
| GĐ2: Backend CRUD   | 5-7 ngày        | 9 module (HĐ, HĐ, TT, SC, TB, CSDN, CHG, Admin, Hồ sơ) |
| GĐ3: Phân quyền     | 2-3 ngày        | @PreAuthorize + middleware + sidebar                   |
| GĐ4: Dashboard thật | 1-2 ngày        | Query DB + biểu đồ                                     |
| GĐ5: Nâng cao       | 3-5 ngày        | PDF, trang công khai, cài đặt                          |
| **TỔNG**            | **~13-20 ngày** |                                                        |

---

## ❓ CÂU HỎI CẦN TRẢ LỜI TRƯỚC KHI BẮT ĐẦU

1. **Ưu tiên JWT hay CRUD trước?** JWT là nền tảng nhưng nếu muốn test nhanh thì làm CRUD trước rồi bọc security sau.
2. **TENANT có cần đăng nhập vào dashboard không?** Hay chỉ ADMIN + LANDLORD dùng dashboard, TENANT dùng trang riêng?
3. **Thanh toán online (VNPay/Momo)?** Có cần tích hợp hay chỉ ghi nhận thủ công?
4. **Tổng thời gian mong muốn?** Để ưu tiên đúng thứ tự feature.

---

## 🔧 GHI CHÚ KỸ THUẬT

### Thứ tự dependency khi code GĐ2:

```
CauHinhGia → ChiSoDienNuoc → HopDong → HoaDon → ThanhToan → SuCo → ThongBao → Admin → UserProfile
```

(Hóa đơn phụ thuộc vào Cấu hình giá + Chỉ số điện nước + Hợp đồng)

### File frontend cần thêm rewrite (next.config.ts):

- `/api/cau-hinh-gia` → `http://localhost:8080/api/cau-hinh-gia`
- `/api/chi-so-dien-nuoc` → `http://localhost:8080/api/chi-so-dien-nuoc`

### Package backend cần tạo thêm:

- `be/src/main/java/com/example/quanlyphongtro/security/` → JwtService, JwtFilter
