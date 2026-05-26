# EasyHouse Manual E2E Test Checklist

## Remediation Verification Run - 2026-05-26

Day la lan chay moi cho `DASHBOARD_REWORK_REMEDIATION_PLAN.md`; cac checkbox cu phia duoi khong duoc dung lam bang chung cho dot remediation nay.

Environment:

- [x] Da reset Docker volume va restore full `sql/db.sql`; PostgreSQL container healthy.
- [x] Backend va frontend Docker da khoi dong.
- [x] Database co account `admin`, `landlord.a`, `landlord.b`, `staff.a`, `tenant.a`, `tenant.b` (password web test: `Admin@123`) va data phan tach Nha tro A/B.

Automated checks:

- [x] Backend `mvn test`: 61 tests pass, 0 failure/error.
- [x] Frontend `npx tsc --noEmit`: pass.
- [x] Frontend `npm.cmd run lint`: 0 error, con 36 warning da biet.
- [x] Frontend `npm.cmd run build`: pass voi cung warning residual.

API permission/reconciliation evidence:

- [x] `ADMIN`: login thanh cong; `GET /api/audit-log` thanh cong.
- [x] `STAFF A`: list phong va su co chi co du lieu A; `GET /api/audit-log` bi tu choi; pricing B va notification management bi tu choi.
- [x] `LANDLORD A`: doc meter A thanh cong; meter B, pricing B va incident B bi tu choi.
- [x] `TENANT A`: list/chi tiet hoa don A thanh cong; invoice B bi tu choi; list su co loc chi co A.
- [x] VietQR manual match da tao payment `4.100.000` cho `HD-A-202605`, hoa don A thanh `PAID`, transaction `E2E-TXN-A` thanh da doi soat.
- [x] Public appointment payload gui trang thai khac van duoc luu `PENDING`.

Browser smoke bang Playwright Firefox:

- [x] Admin dang nhap va dashboard render; recent audit/activity hien thi.
- [x] Admin `/dashboard/su-co` render hai dong A/B, lookup tra thanh cong, khong console error.
- [x] Admin `/dashboard/thanh-toan` render hai payment A, gom payment tu VietQR.
- [x] Admin `/dashboard/vietqr-doi-soat` render `E2E-TXN-A` o trang thai da doi soat.
- [x] Staff `/dashboard/su-co` chi render dong `Ro nuoc A`; lookup phong/khach thue/hop dong deu HTTP 200.
- [x] Staff vao `/dashboard/audit-log` va `/dashboard/vietqr-doi-soat` bi middleware chuyen khoi trang protected.

Chua smoke thu cong trong lan chay nay:

- [ ] Upload/delete media that qua Cloudinary va kiem tra file cross-owner tren browser.
- [ ] Tat ca modal create/edit cua contract, meter, appointment va notification recipient.
- [ ] Don 36 lint warnings va sua cac chuoi mojibake cu con lai.

This document provides a step-by-step checklist for manual end-to-end testing of the EasyHouse dashboard on a local environment.

## Prerequisites

- [ ] Ensure local PostgreSQL database is running via `docker-compose`.
- [ ] Database is seeded with initial data (Admin user, basic roles).
- [ ] Backend is running (`mvn spring-boot:run` or docker).
- [ ] Frontend is running (`npm run dev` or docker).

## 1. Authentication & Authorization

- [x] **Login as Admin:** Navigate to `/login`, enter `admin@easyhouse.local` / `Admin@123`. Verify successful login and redirection to dashboard.
- [x] **Role Verification:** Ensure sidebar shows admin-only menus (e.g., Tài Khoản, Cài Đặt Hệ Thống).

## 2. Quản lý Tòa Nhà (Nhà Trọ)

- [x] **Tạo Tòa Nhà:** Truy cập `/dashboard/toa-nha`. Thêm một tòa nhà mới với đầy đủ thông tin (tên, địa chỉ, mô tả, tiện nghi).
- [x] **Sửa Tòa Nhà:** Chỉnh sửa thông tin tòa nhà vừa tạo.
- [x] **Phân Quyền (Tùy chọn):** Nếu có tính năng gán nhân viên, kiểm tra xem nhân viên chỉ thấy tòa nhà được gán.

## 3. Quản lý Phòng

- [x] **Tạo Phòng:** Vào chi tiết tòa nhà vừa tạo, hoặc trang `/dashboard/phong`. Thêm một phòng mới (tên, tầng, diện tích, giá, tiền cọc, số người tối đa).
- [x] **Thêm Tiện Ích Phòng:** Đánh dấu các tiện ích có sẵn trong phòng (điều hòa, nóng lạnh, giường...).
- [x] **Kiểm tra trạng thái:** Trạng thái phòng mới tạo nên là `AVAILABLE`.

## 4. Quản lý Khách Thuê

- [x] **Tạo Khách Thuê:** Truy cập `/dashboard/khach-thue`. Thêm một khách thuê mới với đầy đủ thông tin cá nhân (họ tên, CCCD, số điện thoại, email).
- [x] **Upload CCCD:** Nếu có tính năng, thử upload ảnh mặt trước/sau CCCD.

## 5. Quản lý Hợp Đồng

- [x] **Tạo Hợp Đồng:** Truy cập `/dashboard/hop-dong`. Tạo hợp đồng mới, chọn phòng vừa tạo và khách thuê vừa tạo.
- [x] **Gán Dịch Vụ:** Chọn các dịch vụ áp dụng cho hợp đồng (Điện, Nước, Rác, Wifi...) với đơn giá tương ứng.
- [x] **Chỉ Số Ban Đầu:** Nhập chỉ số điện/nước ban đầu.
- [x] **Xác nhận trạng thái:** Hợp đồng được lưu, trạng thái là `ACTIVE` (hoặc `PENDING` nếu cần duyệt). Trạng thái phòng chuyển sang `RENTED`.

## 6. Ghi Chỉ Số Điện Nước

- [x] **Ghi Chỉ Số Mới:** Truy cập `/dashboard/chi-so-dien-nuoc`. Chọn tháng hiện tại, nhập chỉ số mới cho phòng có hợp đồng.
- [x] **Kiểm tra hợp lệ:** Đảm bảo chỉ số mới >= chỉ số cũ. Trạng thái sau khi lưu là `UNBILLED` hoặc `DRAFT`.

## 7. Quản lý Hóa Đơn

- [x] **Tạo Hóa Đơn:** Truy cập `/dashboard/hoa-don`. Tạo hóa đơn cho kỳ hiện tại của phòng vừa ghi chỉ số.
- [x] **Kiểm tra chi tiết:** Hóa đơn tự động tính các khoản:
  - Tiền phòng.
  - Tiền điện (chênh lệch chỉ số * đơn giá).
  - Tiền nước.
  - Tiền dịch vụ khác (rác, wifi).
- [x] **Xác nhận tổng tiền:** Tổng tiền phải khớp với tổng các dòng chi tiết. Trạng thái là `UNPAID`.
- [x] **Khóa Chỉ Số:** Chỉ số điện nước liên kết với hóa đơn phải chuyển trạng thái sang `BILLED` (không cho phép sửa/xóa).

## 8. Quản lý Thanh Toán

- [x] **Ghi Nhận Thanh Toán:** Truy cập chi tiết hóa đơn hoặc `/dashboard/thanh-toan`. Tạo khoản thanh toán cho hóa đơn vừa tạo (nhập đủ số tiền).
- [x] **Kiểm tra công nợ:** Công nợ của hóa đơn (con_lai) phải về 0. Trạng thái hóa đơn chuyển sang `PAID`.
- [x] **Hủy Thanh Toán (Tùy chọn):** Thử hủy hoặc hoàn tiền khoản thanh toán, kiểm tra công nợ và trạng thái hóa đơn có quay lại `UNPAID` không.

## 9. Dashboard Tổng Quan & Báo Cáo

- [x] **Dashboard Stats:** Về trang chủ `/dashboard`. Kiểm tra các số liệu:
  - Tổng số phòng, phòng trống, phòng đang thuê (cập nhật đúng sau khi tạo hợp đồng).
  - Doanh thu tháng, đã thu (tăng lên sau khi thanh toán), chưa thu.
  - Khách đang thuê.
- [x] **Recent Activity:** Kiểm tra các hoạt động gần đây (Audit log) có hiển thị việc tạo hợp đồng, hóa đơn, thanh toán không.

## 10. Luồng Khách Thuê (Tenant Flow)

- [x] **Tenant Login:** (Nếu có) Đăng nhập bằng tài khoản của khách thuê.
- [x] **Xem Hóa Đơn:** Khách thuê chỉ xem được hóa đơn của phòng mình, không thấy dữ liệu của nhà trọ khác.
- [x] **Giao Diện:** Không thấy các menu quản trị (Tòa Nhà, Cấu Hình Giá, Cài Đặt).

## 11. Các Trường Hợp Cạnh (Edge Cases)

- [x] **Phòng đang thuê:** Thử tạo thêm một hợp đồng cho phòng đang `RENTED` -> Phải báo lỗi (ngăn chặn overlap hợp đồng active).
- [x] **Xóa dữ liệu liên kết:** Thử xóa một phòng đang có hợp đồng -> Phải báo lỗi (ràng buộc khóa ngoại). Thử xóa hợp đồng đã có hóa đơn -> Phải báo lỗi.
