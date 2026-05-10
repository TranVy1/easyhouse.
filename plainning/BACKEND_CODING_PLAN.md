# 🚀 BACKEND DEVELOPMENT PLAN - RENTAL MANAGEMENT SYSTEM (Cập nhật theo Schema Tiếng Việt)

Dưới đây là kế hoạch chi tiết từng bước (Step-by-step) để code Backend Spring Boot một cách chặt chẽ, tối ưu và hạn chế tối đa việc phải đập đi xây lại dựa trên Database Schema (Tiếng Việt không dấu) đã được chuẩn hóa.

---

## 📌 PHASE 1: INITIAL SETUP & BASE ARCHITECTURE (Cấu trúc nền tảng)

_Mục tiêu: Xây dựng móng vững chắc cho dự án, xử lý lỗi tập trung và cấu trúc code chuẩn._

- [ ] **1.1. Package Structure:** Tạo các package chuẩn: `config`, `constant`, `entity`, `repository`, `dto` (request/response), `mapper`, `service`, `controller`, `exception`, `security`.
- [ ] **1.2. Core Configuration:**
  - **CORS Config:** Cấu hình `WebMvcConfigurer` để cho phép Frontend gọi API mà không bị lỗi Cross-Origin.
  - **Validation:** Tích hợp `spring-boot-starter-validation` (Hibernate Validator) để ràng buộc dữ liệu DTO (`@NotBlank`, `@Email`, `@Min`...).
- [ ] **1.3. Database Migration & Data Seeding:**
  - Tích hợp **Flyway** (hoặc dùng `init_schema.sql` có sẵn) để tự động khởi tạo các Roles mặc định và tài khoản Admin gốc.
- [ ] **1.4. JPA & Entities:**
  - Tạo các Class Entity tương ứng với các bảng tiếng Việt trong SQL (`nguoi_dung`, `phong`, `hoa_don`...).
  - Cấu hình `@Id`, `@GeneratedValue(strategy = GenerationType.UUID)`.
  - Cấu hình các quan hệ `@OneToMany`, `@ManyToOne` (chú ý dùng `FetchType.LAZY` để tránh N+1 Query).
  - Cấu hình Entity Auditing (tự động điền `tao_luc`, `cap_nhat_luc` sử dụng `@EntityListeners(AuditingEntityListener.class)`).
- [ ] **1.5. Base Response & Exception Handling:**
  - Tạo class `ApiResponse<T>` chuẩn hóa format trả về (code, message, data).
  - Khởi tạo `@RestControllerAdvice` để bắt lỗi toàn cục (Global Exception Handler).
- [ ] **1.6. Enum Mapping Layer (QUAN TRỌNG):**
  - Do Frontend dùng key tiếng Việt camelCase (vd: `dangThue`, `moi`) còn DB dùng ENUM (vd: `RENTED`, `PENDING`), cần thiết lập các Mapper (MapStruct hoặc Custom Logic) để dịch ngược xuôi giữa DTO và Entity.

---

## toàn bộ api

Authentication
POST /api/auth/register - Đăng ký tài khoản
POST /api/auth/[...nextauth] - Đăng nhập
Tòa nhà
GET /api/toa-nha - Lấy danh sách tòa nhà
POST /api/toa-nha - Tạo tòa nhà mới
GET /api/toa-nha/[id] - Lấy thông tin tòa nhà
PUT /api/toa-nha/[id] - Cập nhật tòa nhà
DELETE /api/toa-nha/[id] - Xóa tòa nhà
Phòng
GET /api/phong - Lấy danh sách phòng
POST /api/phong - Tạo phòng mới
GET /api/phong/[id] - Lấy thông tin phòng
PUT /api/phong/[id] - Cập nhật phòng
DELETE /api/phong/[id] - Xóa phòng
Khách thuê
GET /api/khach-thue - Lấy danh sách khách thuê
POST /api/khach-thue - Tạo khách thuê mới
GET /api/khach-thue/[id] - Lấy thông tin khách thuê
PUT /api/khach-thue/[id] - Cập nhật khách thuê
DELETE /api/khach-thue/[id] - Xóa khách thuê
Hợp đồng
GET /api/hop-dong - Lấy danh sách hợp đồng
POST /api/hop-dong - Tạo hợp đồng mới
GET /api/hop-dong/[id] - Lấy thông tin hợp đồng
PUT /api/hop-dong/[id] - Cập nhật hợp đồng
DELETE /api/hop-dong/[id] - Xóa hợp đồng
Chỉ số điện nước
GET /api/chi-so-dien-nuoc - Lấy danh sách chỉ số
POST /api/chi-so-dien-nuoc - Ghi chỉ số mới
Hóa đơn
GET /api/hoa-don - Lấy danh sách hóa đơn
POST /api/hoa-don - Tạo hóa đơn mới
Thanh toán
GET /api/thanh-toan - Lấy danh sách thanh toán
POST /api/thanh-toan - Ghi nhận thanh toán
Sự cố
GET /api/su-co - Lấy danh sách sự cố
POST /api/su-co - Báo cáo sự cố
GET /api/su-co/[id] - Lấy thông tin sự cố
PUT /api/su-co/[id] - Cập nhật sự cố
DELETE /api/su-co/[id] - Xóa sự cố
Thông báo
GET /api/thong-bao - Lấy danh sách thông báo
POST /api/thong-bao - Gửi thông báo
Dashboard
GET /api/dashboard/stats - Lấy thống kê dashboard

## 📌 PHASE 2: SECURITY & AUTHENTICATION (Bảo mật & Đăng nhập)

_Mục tiêu: Đảm bảo luồng đăng nhập, phân quyền hoạt động đúng trước khi làm các API nghiệp vụ._

- [ ] **2.1. JWT Configuration:** Cấu hình tạo và xác thực Json Web Token (Access Token, Refresh Token).
- [ ] **2.2. Spring Security:** Cấu hình `SecurityFilterChain`, chặn các endpoint cần xác thực.
- [ ] **2.3. Role-based Authorization:** Thiết lập phân quyền (`@PreAuthorize("hasRole('LANDLORD')")`).
- [ ] **2.4. Auth APIs:** Code các API Đăng ký, Đăng nhập, Quên mật khẩu cho bảng `nguoi_dung`.

---

## 📌 PHASE 3: UPLOAD & SHARED MODULES (Module dùng chung) - **HOÀN THIỆN**

_Mục tiêu: Giải quyết việc lưu trữ file và các dữ liệu dùng chung._

- [x] **3.1. Cloudinary Integration:** ✅ HOÀN THIỆN
  - **CloudinaryService**: Service xử lý upload/delete files lên Cloudinary
  - **CloudinaryConfig**: Cấu hình Cloudinary bean với credentials
  - **UploadController**: API endpoints `/api/upload` cho upload files
  - **Dependencies**: Thêm `cloudinary-http44` vào pom.xml
  - **Credentials**: Đã cấu hình trong `application-secrets.properties`
  - **API Rewrite**: Frontend proxy `/api/upload` → backend
  - **Error Handling**: Comprehensive error handling với proper JSON responses
  - **File Validation**: Kiểm tra file size (max 10MB), file type validation
  - **Response Format**: Trả về `secure_url`, `public_id`, `format`, `bytes`

- [ ] **3.2. Media Files CRUD:** Viết logic lưu file vào bảng `file_media` (kèm logic `loai_doi_tuong_media`).
- [ ] **3.3. Amenities (Tiện ích):** API quản lý các tiện ích trong bảng `tien_ich`.

---

## 📌 PHASE 4: PROPERTY MANAGEMENT (Quản lý khu trọ & Phòng trọ) - **95% HOÀN THIỆN**

_Mục tiêu: Chủ trọ có thể tạo nhà trọ, cấu hình giá, thêm phòng._

**Status**: ✅ 95% Complete

- [x] **4.1. Landlord & Motel:** API cho chủ nhà (`chu_tro`) tạo Khu trọ (`nha_tro`). ✅ HOÀN THIỆN
  - Controllers: NhaTroController (GET, POST, PUT, DELETE) ✅
  - Service: NhaTroService với CRUD logic ✅
  - DTOs: NhaTroRequest, NhaTroResponse ✅
  - Entity: NhaTro ✅ **(Đã sửa - khớp 100% với schema SQL)**
  - Frontend: Toa-nha page + table, CRUD dialogs ✅
  - API Rewrite: /api/toa-nha routes configured ✅

- [ ] **4.2. Price Config:** API cấu hình giá dịch vụ (`cau_hinh_gia`). ⏳ CHƯA BẮT ĐẦU

- [x] **4.3. Rooms Management:** ✅ 95% HOÀN THIỆN
  - [x] Thêm, sửa, xóa Phòng (`phong`). ✅
  - [x] Gắn tiện ích cho phòng (`phong_tien_ich`). ✅
  - [x] Phân trang và Lọc danh sách phòng ✅

  - [x] **Khách thuê (khach-thue) CRUD:** ✅ **100% HOÀN THIỆN**
    - Entity: KhachThue ✅ **(Đã sửa - khớp 100% với schema SQL)**
      - Liên kết `@OneToOne` với `NguoiDung` qua `nguoi_dung_id`
      - Các trường: `so_cccd`, `lien_he_khan_cap`, `ngay_sinh`, `dia_chi_thuong_tru`, `nghe_nghiep`
    - Repository: KhachThueRepository với `findAllWithNguoiDung()`, `findByIdWithNguoiDung()` ✅
    - Service: KhachThueService ✅
      - `createKhachThue()`: Tạo cả NguoiDung (nếu chưa có) + KhachThue
      - `updateKhachThue()`: Cập nhật cả 2 bảng
      - `deleteKhachThue()`: Soft delete (đánh dấu xoa_luc)
    - DTOs: ✅
      - `KhachThueRequest`: Nhận thông tin từ FE (hoTen, email, soDienThoai, soCccd,...)
      - `KhachThueResponse`: Kết hợp dữ liệu từ NguoiDung + KhachThue
    - Controllers: KhachThueController (GET, GET/{id}, POST, PUT, DELETE) ✅
    - API Rewrite: `/api/khach-thue` routes configured ✅

    **⚠️ LƯU Ý QUAN TRỌNG:**
    - Thông tin cá nhân (hoTen, email, soDienThoai, gioiTinh) → bảng `nguoi_dung`
    - Thông tin bổ sung (soCccd, lienHeKhanCap, diaChiThuongTru) → bảng `khach_thue`
    - Khi tạo khách thuê mới: Service tự động tạo NguoiDung với vai trò TENANT


## 📌 PHASE 5: BOOKING & CONTRACTS (Hợp đồng & Đặt cọc)

_Mục tiêu: Luồng người thuê xem phòng, đặt cọc và ký hợp đồng._

- [ ] **5.1. Appointments (Hẹn xem phòng):** Đăng ký lịch hẹn (`lich_hen`), chủ nhà duyệt lịch.
- [ ] **5.2. Booking Deposits (Cọc giữ chỗ):** Tạo phiếu cọc `dat_coc_phong`. Xử lý logic tự động hủy cọc nếu quá hạn.
- [ ] **5.3. Contracts (Hợp đồng):**
  - Khởi tạo hợp đồng (`hop_dong`) từ `dat_coc_phong`.
  - Hỗ trợ lưu chữ ký (`chu_ky_chu_tro`, `chu_ky_khach_thue`) và xuất `file_pdf`.
  - Thu tiền cọc hợp đồng, tự động đổi trạng thái phòng sang `RENTED` (Đang thuê).
- [ ] **5.4. Contract Members:** Thêm danh sách người ở ghép vào `thanh_vien_hop_dong` (Khai báo tạm trú).

---

## 📌 PHASE 6: BILLING & PAYMENT SYSTEM (Trái tim của hệ thống)

_Mục tiêu: Chốt điện nước, xuất hóa đơn và thanh toán online._

- [ ] **6.1. Electricity & Water Logs:**
  - Chốt chỉ số điện/nước hàng tháng (`chi_so_dien_nuoc`).
  - Validate: Chỉ số mới >= Chỉ số cũ.
- [ ] **6.2. Invoice Generation Logic (Rất quan trọng):**
  - Viết Service tính toán tổng tiền dựa trên cấu hình giá `cau_hinh_gia` và lưu vào `hoa_don` cùng `chi_tiet_hoa_don`.
- [ ] **6.3. Payment Tracking & VNPay:**
  - Viết `VNPayService` tạo URL thanh toán (Tùy chọn).
  - Lưu lịch sử thanh toán vào bảng `thanh_toan`.
  - Tự động cập nhật trạng thái `hoa_don` (PAID/PARTIAL) dựa theo Trigger SQL đã viết sẵn hoặc code backend bù trừ.

---

## 📌 PHASE 7: MAINTENANCE & NOTIFICATIONS (Vận hành & Hỗ trợ)

_Mục tiêu: Chăm sóc khách hàng và nhắc nợ tự động._

- [ ] **7.1. Maintenance Requests:** Quản lý báo cáo sự cố (`su_co`), chủ nhà cập nhật tiến độ, tính `chi_phi_sua_chua`.
- [ ] **7.2. System Notifications:** Tạo thông báo (`thong_bao`) nhắc đóng tiền phòng, duyệt lịch xem phòng.

---

## 📌 PHASE 8: DASHBOARD & REPORTING (Thống kê)

_Mục tiêu: Cung cấp góc nhìn tổng quan cho chủ trọ._

- [ ] **8.1. Revenue Stats:** Thống kê doanh thu theo tháng/năm dựa trên hóa đơn đã thanh toán.
- [ ] **8.2. Occupancy Rate:** Tỉ lệ lấp đầy (Phòng đang thuê / Tổng phòng).
- [ ] **8.3. Debt Report:** Danh sách các khoản nợ (`hoa_don` trạng thái UNPAID/PARTIAL).

---

## 💡 Best Practices khi Coding:

1. **DTOs everywhere:** KHÔNG BAO GIỜ trả trực tiếp Entity ra Controller. Luôn dùng DTO (`PhongRequest`, `PhongResponse`).
2. **MapStruct:** Dùng thư viện MapStruct để map giữa DTO và Entity thay vì viết hàm setter thủ công.
3. **Enum Converter:** Sử dụng `@Converter(autoApply = true)` hoặc MapStruct Mapper để dịch ENUM giữa Java và Frontend chuẩn xác.
4. **Git Flow:** Tạo branch cho từng Phase (vd: `feature/phase1-auth`, `feature/phase4-phong`).
5. **Swagger/OpenAPI:** Tích hợp `springdoc-openapi-starter-webmvc-ui` để xuất document tự động.
