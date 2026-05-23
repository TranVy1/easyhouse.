# 📋 EASYHOUSE - BẢN ĐỒ TỔNG THỂ DỰ ÁN

> **Dự án**: EasyHouse - Hệ thống Quản lý Phòng trọ  
> **Ngày tạo**: 21/05/2026  
> **Tech Stack**: Spring Boot 4.0.6 (Java 21) + Next.js 15.5.4 (React 19, TypeScript) + PostgreSQL + Cloudinary  
> **Monitoring**: Prometheus + Grafana + k6

---

## 📊 TỔNG QUAN TIẾN ĐỘ

| Hạng mục | Đã xong | Cần làm | Tổng |
|---|---|---|---|
| **Backend Controllers** | 15 | ~12 | ~27 |
| **Backend Entities** | 12 | ~10 | ~22 |
| **Frontend Pages** | 12 | ~8 | ~20 |
| **Database Tables (ERD)** | 22 bảng thiết kế | Cần đồng bộ Entity | 22 |

---

## ✅ PHẦN A: CÁC CHỨC NĂNG ĐÃ CÓ TRONG SOURCE CODE

### 1. Xác thực & Quản lý tài khoản
| Chức năng | Backend | Frontend | Trạng thái |
|---|---|---|---|
| Đăng ký tài khoản | `AuthController` + `AuthService` | `/dang-ky` | ✅ Hoàn thành |
| Đăng nhập (NextAuth + JWT) | `AuthController.login()` | `/dang-nhap` | ✅ Hoàn thành |
| Xác thực Email | `EmailVerificationToken` entity | `/xac-thuc-email` | ✅ Hoàn thành |
| Quản lý hồ sơ cá nhân | `UserController` + `UserService` | `/dashboard/ho-so` | ✅ Hoàn thành |
| Đổi mật khẩu | `ChangePasswordRequest` DTO | `/dashboard/ho-so` | ✅ Hoàn thành |
| Phân quyền vai trò | `VaiTro` entity + `nguoi_dung_vai_tro` | Sidebar theo role | ⚠️ Cơ bản (permitAll) |
| Quản lý tài khoản (Admin) | `AdminUserController` | `/dashboard/quan-ly-tai-khoan` | ✅ Hoàn thành |

### 2. Quản lý Tài sản
| Chức năng | Backend | Frontend | Trạng thái |
|---|---|---|---|
| CRUD Tòa nhà/Khu trọ | `NhaTroController` + `NhaTroService` | `/dashboard/toa-nha` | ✅ Hoàn thành |
| CRUD Phòng trọ | `PhongController` + `PhongService` | `/dashboard/phong` | ✅ Hoàn thành |
| Upload ảnh phòng (Cloudinary) | `UploadController` + `CloudinaryService` | `phong-image-upload.tsx` | ✅ Hoàn thành |
| Tiện ích phòng | `tien_nghi` JSONB column | `phong-data-table.tsx` | ✅ Hoàn thành |
| Trạng thái phòng | `TrangThaiPhong` enum | `phong-data-table.tsx` | ✅ Hoàn thành |

### 3. Quản lý Khách thuê & Hợp đồng
| Chức năng | Backend | Frontend | Trạng thái |
|---|---|---|---|
| CRUD Khách thuê | `KhachThueController` + `KhachThueService` | `/dashboard/khach-thue` | ✅ Hoàn thành |
| Upload ảnh CCCD | `UploadController` | `cccd-upload.tsx` | ✅ Hoàn thành |
| CRUD Hợp đồng | `HopDongController` + `HopDongService` | `/dashboard/hop-dong` | ✅ Hoàn thành |
| Tạo/Xem/Sửa hợp đồng | `HopDongRequest/Response` DTO | Form tạo + Chi tiết | ✅ Hoàn thành |

### 4. Hóa đơn & Thanh toán
| Chức năng | Backend | Frontend | Trạng thái |
|---|---|---|---|
| CRUD Hóa đơn | `HoaDonController` + `HoaDonService` | `/dashboard/hoa-don` | ✅ Hoàn thành |
| Chi tiết hóa đơn | `ChiTietHoaDon` entity | `hoa-don-data-table.tsx` | ✅ Hoàn thành |
| Xem hóa đơn (Khách thuê) | `HoaDonPublicController` | `/hoa-don` (public) | ✅ Hoàn thành |
| CRUD Thanh toán | `ThanhToanController` + `ThanhToanService` | `/dashboard/thanh-toan` | ✅ Hoàn thành |

### 5. Vận hành
| Chức năng | Backend | Frontend | Trạng thái |
|---|---|---|---|
| CRUD Sự cố | `SuCoController` + `SuCoService` | `/dashboard/su-co` | ✅ Hoàn thành |
| Upload ảnh sự cố | `UploadController` | `su-co-image-upload.tsx` | ✅ Hoàn thành |
| Thông báo | `ThongBaoController` + `ThongBaoService` | `/dashboard/thong-bao` | ✅ Hoàn thành |
| Lịch hẹn xem phòng | `lich_hen` table (ERD) | Trang xem phòng `/xem-phong` | ⚠️ Frontend có, Backend chưa có Controller |

### 6. Dashboard & Thống kê
| Chức năng | Backend | Frontend | Trạng thái |
|---|---|---|---|
| Dashboard cơ bản | `DashboardController` + `DashboardService` | `/dashboard` | ⚠️ Cơ bản (chỉ đếm phòng, doanh thu = 0) |
| Monitoring (Prometheus/Grafana/k6) | `monitoring/` folder | N/A | ✅ Cấu hình sẵn |

---

## ❌ PHẦN B: CÁC CHỨC NĂNG CẦN LÀM (GAP ANALYSIS)

### 🔴 ƯU TIÊN CAO (Core - Bắt buộc hoàn thành cho DATN)

#### B1. Đồng bộ Database Schema mới (ERD → Entity)
> **Lý do**: ERD `erd_schema.sql` đã tách `chi_so_dien_nuoc` thành 2 bảng, thêm các bảng `dich_vu`, `dich_vu_hop_dong`, `nhan_vien_nha_tro`, `lich_su_gia_dich_vu`. Backend chưa có Entity tương ứng.

- [ ] Tạo Entity `ChiSoDien.java` (thay thế `ChiSoDienNuoc`)
- [ ] Tạo Entity `ChiSoNuoc.java`
- [ ] Tạo Entity `DichVu.java` + `DichVuHopDong.java`
- [ ] Tạo Entity `NhanVienNhaTro.java`
- [ ] Tạo Entity `LichSuGiaDichVu.java`
- [ ] Tạo Entity `LichSuHoaDon.java`
- [ ] Tạo Entity `LichHen.java`
- [ ] Tạo Entity `DatCocPhong.java`
- [ ] Tạo Entity `ThanhVienHopDong.java`
- [ ] Cập nhật `ChiTietHoaDon.java`: thêm FK `dich_vu_id`, `chi_so_dien_id`, `chi_so_nuoc_id`, `su_co_id`
- [ ] Cập nhật `NguoiDung.java`: thêm cột `so_cccd`, `anh_cccd_truoc`, `anh_cccd_sau`
- [ ] Xóa Entity `KhachThue.java` (gộp vào `NguoiDung` theo ERD)
- [ ] Xóa bảng `nguoi_dung_vai_tro` + `vai_tro` (ERD dùng cột `vai_tro` trực tiếp trong `nguoi_dung`)

#### B2. Chỉ số Điện/Nước tách riêng (Backend + Frontend)
> **Lý do**: `ChiSoDienNuocController` hiện tại trả về empty list (stub). ERD đã tách thành 2 bảng.

- [ ] **Backend**: Tạo `ChiSoDienController`, `ChiSoDienService`, `ChiSoDienRepository`
- [ ] **Backend**: Tạo `ChiSoNuocController`, `ChiSoNuocService`, `ChiSoNuocRepository`
- [ ] **Backend**: Logic nghiệp vụ: chốt số → kiểm tra số cũ/mới → đổi `trang_thai` (CHUA_CHOT → DA_CHOT → DA_XUAT_BILL)
- [ ] **Frontend**: Tạo trang `/dashboard/chi-so-dien` với form nhập + bảng lịch sử
- [ ] **Frontend**: Tạo trang `/dashboard/chi-so-nuoc` tương tự
- [ ] **Frontend Types**: Tách `ChiSoDienNuoc` interface thành `ChiSoDien` + `ChiSoNuoc`

#### B3. Cấu hình Giá Dịch vụ (Bảng `dich_vu`)
> **Lý do**: Hiện tại giá điện/nước/dịch vụ chưa có bảng quản lý. Weekly Plan cũ nêu rõ cần `CauHinhGia`.

- [ ] **Backend**: Entity `DichVu` + `DichVuHopDong` + `LichSuGiaDichVu`
- [ ] **Backend**: CRUD Controller + Service
- [ ] **Frontend**: Trang `/dashboard/cai-dat` → Tab "Cấu hình dịch vụ" (CRUD đơn giá điện, nước, rác, wifi...)
- [ ] **Tích hợp**: `HoaDonService` khi tạo hóa đơn phải lấy đơn giá từ bảng `dich_vu`

#### B4. Dashboard Nâng cao (Doanh thu thực, So sánh tháng)
> **Lý do**: `DashboardService` hiện tại trả `doanhThuThang = BigDecimal.ZERO` (hardcoded TODO).

- [ ] **Backend**: Query SUM doanh thu từ `thanh_toan` theo tháng/năm
- [ ] **Backend**: Query tính Lợi nhuận thực = Tổng thu - Tổng chi phí sửa chữa (`su_co.chi_phi_sua_chua`)
- [ ] **Backend**: Query so sánh tháng trước vs tháng này (tỷ lệ tăng/giảm %)
- [ ] **Backend**: Query tỷ lệ lấp đầy phòng, công nợ theo phòng
- [ ] **Frontend**: Dashboard page hiện có → bổ sung biểu đồ (Chart.js hoặc Recharts)

#### B5. Lịch hẹn xem phòng (Backend)
> **Lý do**: ERD có bảng `lich_hen`, Frontend có `/xem-phong`, nhưng Backend chưa có Controller/Service.

- [ ] **Backend**: Entity `LichHen.java` + Repository + Service + Controller
- [ ] **Backend**: API: `POST /api/lich-hen` (Khách đặt), `GET /api/lich-hen` (Chủ trọ xem), `PUT /api/lich-hen/{id}` (Duyệt/Từ chối)
- [ ] **Frontend**: Kết nối trang xem phòng public với API thật

#### B6. Spring Security thật (Bỏ permitAll)
> **Lý do**: `SecurityConfig.java` hiện tại `.anyRequest().permitAll()` — không có phân quyền thực sự.

- [ ] **Backend**: Tạo `JwtTokenProvider` + `JwtAuthenticationFilter`
- [ ] **Backend**: Cấu hình endpoint theo role (`LANDLORD` mới được CRUD tòa nhà, `TENANT` chỉ xem hóa đơn/sự cố...)
- [ ] **Backend**: Lấy `userId` từ JWT thay vì hardcode/email header
- [ ] **Frontend**: Gửi `Authorization: Bearer <token>` trong mọi API call

---

### 🟡 ƯU TIÊN TRUNG BÌNH (Nâng cao - Ghi điểm với Hội đồng)

#### B7. Bảo mật nâng cao
- [ ] **Refresh Token & Session Expire**: Tạo bảng `refresh_token`, cơ chế tự động gia hạn
- [ ] **2FA (Google Authenticator)**: Thư viện `dev.samstevens.totp`, QR code khi kích hoạt
- [ ] **Audit Log**: Bảng `lich_su_hoat_dong` (userId, action, entity, timestamp, IP)
- [ ] **Khóa tài khoản**: Đếm số lần login sai trong `NguoiDung` (cột `so_lan_dang_nhap_sai`, `khoa_den_luc`)

#### B8. Hợp đồng nâng cao
- [ ] **Nhắc hết hạn**: Spring `@Scheduled` cron job chạy hằng ngày, quét `hop_dong.ngay_ket_thuc - 7 ngày` → tạo `ThongBao` + gửi Email
- [ ] **Gia hạn 1-click**: API `POST /api/hop-dong/{id}/gia-han` clone hợp đồng cũ với ngày mới
- [ ] **Thành viên hợp đồng**: CRUD `ThanhVienHopDong` (khai báo tạm trú cho người ở ghép)

#### B9. Hợp đồng điện tử & Chữ ký số
- [ ] **Backend**: Dùng `iText 7` hoặc `Apache PDFBox` tạo PDF từ template + dữ liệu hợp đồng
- [ ] **Frontend**: Canvas vẽ chữ ký tay → upload base64 → embed vào PDF
- [ ] **Backend**: Lưu file PDF đã ký lên Cloudinary, update `hop_dong.file_pdf`

#### B10. Thanh toán VietQR
- [ ] **Backend**: Generate QR code theo chuẩn VietQR (nội dung = mã hóa đơn + số tiền)
- [ ] **Frontend**: Hiển thị mã QR trên trang hóa đơn public
- [ ] *(Tuỳ chọn)*: Tích hợp Webhook Casso/SePay để auto-reconciliation

---

### 🟢 ƯU TIÊN THẤP (AI & Đột phá - Lên thuyết trình "WOW")

#### B11. AI OCR quét CCCD
- [ ] **Backend**: Endpoint `POST /api/ai/ocr-cccd` nhận ảnh → gọi Google Vision API / Tesseract → trả JSON (họ tên, ngày sinh, số CCCD)
- [ ] **Frontend**: Component upload ảnh CCCD → bấm "Quét AI" → tự điền form

#### B12. AI Vision đọc Công tơ
- [ ] **Backend**: Endpoint `POST /api/ai/read-meter` nhận ảnh công tơ → trả về con số
- [ ] **Frontend**: Tích hợp vào form chốt chỉ số điện/nước

#### B13. AI Chatbot trợ lý
- [ ] **Backend**: Endpoint `POST /api/ai/chat` → gọi OpenAI/Gemini API với context nội quy + FAQ
- [ ] **Frontend**: Widget chatbot floating ở góc màn hình

#### B14. Cảnh báo bất thường (Anomaly Detection)
- [ ] **Backend**: `@Scheduled` so sánh `chi_so_moi - chi_so_cu` tháng này vs trung bình 3 tháng trước. Nếu vượt 200% → tạo ThongBao cảnh báo

#### B15. Telegram/Zalo Notification Bot
- [ ] **Backend**: Dependency `telegrambots-spring-boot-starter`
- [ ] **Backend**: `@Scheduled` quét hóa đơn quá hạn → gửi tin nhắn qua Bot API

---

## 📅 PHẦN C: PLANNING THEO TUẦN

### Tuần 1: Database & Core Backend (Nền tảng)
| Ngày | Công việc | Files liên quan |
|---|---|---|
| T2 | Import `erd_schema.sql` vào Supabase. Tạo tất cả Entity Java mới | `entity/*.java` |
| T3 | Tạo Repository + Service cho `ChiSoDien`, `ChiSoNuoc`, `DichVu` | `repository/`, `services/` |
| T4 | Tạo Controller cho Điện/Nước/Dịch vụ. Cập nhật `HoaDonService` lấy giá từ `DichVu` | `controller/` |
| T5 | Tạo Entity + CRUD cho `LichHen`, `DatCocPhong`, `ThanhVienHopDong` | `entity/`, `controller/` |
| T6 | Xóa `KhachThue` entity cũ. Refactor code dùng `NguoiDung` + role | Toàn bộ `services/` |
| T7 | Fix tất cả compile errors. Chạy `mvn clean install` thành công | Toàn dự án BE |

### Tuần 2: Spring Security & Frontend Sync
| Ngày | Công việc | Files liên quan |
|---|---|---|
| T2 | Tạo `JwtTokenProvider`, `JwtAuthenticationFilter`, cấu hình SecurityConfig thật | `config/` |
| T3 | Phân quyền endpoint theo role. Test bằng Postman | `SecurityConfig.java` |
| T4 | Frontend: Cập nhật `types/index.ts` khớp với DTO mới | `frontend/src/types/` |
| T5 | Frontend: Tạo trang Chỉ số Điện + Chỉ số Nước | `frontend/src/app/(dashboard)/` |
| T6 | Frontend: Cập nhật Dashboard với dữ liệu thật (biểu đồ) | `dashboard/page.tsx` |
| T7 | Test E2E luồng: Chốt số → Tạo hóa đơn → Thanh toán | Toàn bộ |

### Tuần 3: Tính năng Nâng cao
| Ngày | Công việc | Files liên quan |
|---|---|---|
| T2 | Backend: `@Scheduled` nhắc hợp đồng hết hạn + gia hạn 1-click | `HopDongService.java` |
| T3 | Backend: Tạo PDF hợp đồng (iText/PDFBox) + Chữ ký số | Thêm dependency mới |
| T4 | Backend: VietQR generator cho hóa đơn | `HoaDonService.java` |
| T5 | Backend: Bảo mật (Audit log, khóa tài khoản, Refresh Token) | `config/`, `entity/` |
| T6 | Frontend: Tích hợp Canvas chữ ký + QR hóa đơn | `frontend/src/components/` |
| T7 | Test toàn bộ tính năng nâng cao | Toàn bộ |

### Tuần 4: AI & Polish
| Ngày | Công việc | Files liên quan |
|---|---|---|
| T2 | Backend: AI OCR quét CCCD (Google Vision API) | `controller/AiController.java` |
| T3 | Backend: AI đọc công tơ điện/nước | `controller/AiController.java` |
| T4 | Frontend: Tích hợp AI vào form CCCD + form chốt số | `components/ui/` |
| T5 | Backend: Chatbot AI (OpenAI/Gemini) + Frontend widget | Endpoint + Component |
| T6 | Backend: Anomaly Detection + Telegram Bot | `@Scheduled` jobs |
| T7 | **Code freeze** — Chỉ sửa lỗi, không thêm feature | Toàn bộ |

### Tuần 5: Kiểm thử & Deploy
| Ngày | Công việc |
|---|---|
| T2 | Chạy k6 load test (sử dụng `monitoring/k6.js`) |
| T3 | Fix tất cả bug phát hiện được |
| T4 | Deploy lên VPS/Cloud (Docker Compose) |
| T5 | Viết tài liệu hướng dẫn sử dụng |
| T6 | Chuẩn bị slide thuyết trình |
| T7 | **Rehearsal** — Thuyết trình thử |

---

## 🔧 PHẦN D: DRIFT GIỮA SOURCE CODE HIỆN TẠI VÀ ERD MỚI

### D1. Bảng có trong ERD nhưng CHƯA CÓ Entity Java
| Bảng ERD | Cần tạo Entity | Cần tạo Controller |
|---|---|---|
| `chi_so_dien` | ✅ Cần tạo | ✅ Cần tạo |
| `chi_so_nuoc` | ✅ Cần tạo | ✅ Cần tạo |
| `dich_vu` | ✅ Cần tạo | ✅ Cần tạo |
| `dich_vu_hop_dong` | ✅ Cần tạo | Gộp vào `HopDongController` |
| `nhan_vien_nha_tro` | ✅ Cần tạo | ✅ Cần tạo |
| `lich_su_gia_dich_vu` | ✅ Cần tạo | Gộp vào `DichVuController` |
| `lich_su_hoa_don` | ✅ Cần tạo | Gộp vào `HoaDonController` |
| `lich_hen` | ✅ Cần tạo | ✅ Cần tạo |
| `dat_coc_phong` | ✅ Cần tạo | ✅ Cần tạo |
| `thanh_vien_hop_dong` | ✅ Cần tạo | Gộp vào `HopDongController` |
| `phong_tien_ich` | ✅ Cần tạo | Gộp vào `PhongController` |

### D2. Entity Java có nhưng ERD đã loại bỏ
| Entity cũ | Hành động |
|---|---|
| `KhachThue.java` | ❌ Xóa — gộp vào `NguoiDung` (vai trò TENANT) |
| `VaiTro.java` + `nguoi_dung_vai_tro` (N-N) | ❌ Đổi sang cột `vai_tro VARCHAR` trong `NguoiDung` |

### D3. Frontend Types cần đồng bộ
| Type hiện tại | Thay đổi cần thiết |
|---|---|
| `ChiSoDienNuoc` | Tách thành `ChiSoDien` + `ChiSoNuoc` |
| `KhachThue` | Gộp vào `NguoiDung` |
| `HopDong.giaDien/giaNuoc` | Chuyển sang lấy từ `DichVu` |
| `HoaDon` | Thêm `tuNgay`, `denNgay`, `ngayLapHoaDon` |

---

## 📂 PHẦN E: CẤU TRÚC THƯ MỤC DỰ ÁN

```
qlyphongtro/
├── be/                          # Spring Boot Backend
│   └── src/main/java/com/example/quanlyphongtro/
│       ├── config/              # SecurityConfig, CloudinaryConfig, JacksonConfig
│       ├── controller/          # 15 REST controllers (cần thêm ~7)
│       ├── dto/                 # 29 Request/Response DTOs (cần thêm ~10)
│       ├── entity/              # 12 JPA Entities + 9 Enums (cần thêm ~10)
│       ├── repository/          # 12 JPA Repositories (cần thêm ~8)
│       ├── services/            # 13 Service classes (cần thêm ~7)
│       └── utils/               # Utility classes
├── frontend/                    # Next.js 15 Frontend
│   └── src/
│       ├── app/(auth)/          # Đăng ký, Đăng nhập
│       ├── app/(dashboard)/     # 12 trang Dashboard
│       ├── components/ui/       # 44 UI components (Radix UI)
│       ├── lib/                 # Auth, Utils, Status mapping
│       └── types/               # TypeScript interfaces
├── monitoring/                  # Prometheus + Grafana + k6
├── sql/
│   ├── backup.sql               # Backup gốc từ Supabase
│   ├── backup_public_only.sql   # Backup đã clean
│   └── erd_schema.sql           # ⭐ Schema chuẩn mới từ ERD (22 bảng)
├── plainning/                   # Tài liệu kế hoạch
├── danh_sach_chuc_nang.txt      # Danh sách 85 chức năng
├── AGENTS.md                    # Agent guide
├── GEMINI.md                    # Gemini agent context
└── CLAUDE.md                    # Claude agent context
```

---

## ⚡ LỆNH CHẠY NHANH

```powershell
# Backend
cd be && mvn clean install && mvn spring-boot:run

# Frontend
cd frontend && npm install && npm run dev

# Docker full stack
docker compose -f docker-compose.easyhouse.yml up --build

# Load test
cd monitoring && .\run-k6.bat
```

---

> [!IMPORTANT]
> **Nguyên tắc quan trọng khi code:**
> 1. Giữ nguyên tên Vietnamese camelCase (hoTen, soDienThoai, trangThai...)
> 2. Không expose Entity trực tiếp — luôn qua Request DTO → Service → Response DTO
> 3. Kiểm tra enum mapping xuyên suốt: SQL ↔ Java Enum ↔ DTO ↔ Frontend Type ↔ UI Label
> 4. Frontend gọi API qua `/api/...` thông qua Next.js rewrite proxy
