# EasyHouse Completion Plan

## 0. Tien Do Thuc Hien

Cap nhat theo yeu cau: moi task code xong phai ghi lai tai day de planning luon phan anh dung tien do.

### 2026-05-23

- [x] Backend mapping Hibernate voi `sql/db.sql`: da validate duoc schema Supabase bang `mvn test`.
- [x] Module `cau_hinh_gia` - backend API nen tang:
  - Them `CauHinhGiaRequest`, `CauHinhGiaResponse`.
  - Them `CauHinhGiaRepository`.
  - Them `CauHinhGiaService` voi list/filter, lay gia dang ap dung, create, update, deactivate.
  - Them `CauHinhGiaController` tai `/api/cau-hinh-gia`.
  - Them rewrite frontend cho `/api/cau-hinh-gia`.
  - Da verify: backend test pass, frontend `npx tsc --noEmit` pass.
- [x] Cap nhat planning uu tien dashboard full CRUD truoc, bo sung danh sach man hinh dashboard can co va thu tu lam.
- [x] Ra soat va sua mot phan luong luu data frontend -> backend:
  - `Phong`: backend chap nhan status UI `trong`, `daDat`, `dangThue`, `baoTri`, `ngungHoatDong`.
  - `KhachThue`: backend chap nhan alias frontend `cccd` va khong bi fail khi frontend gui `anhCCCD`, `matKhau`.
  - `HopDong`: backend chap nhan payload frontend `phong`, `nguoiDaiDien`, `giaThue`, `ngayThanhToan`, `dieuKhoan`, status UI.
  - `HoaDon`: backend chap nhan payload frontend `hopDong`, `phong`, `khachThue`, `thang`, `nam`, `hanThanhToan`, `tienPhong`, `tienDien`, `tienNuoc`, `phiDichVu`, `daThanhToan`, status UI; tu tao line items neu frontend chua gui `chiTietHoaDon`.
  - `ThanhToan`: backend map phuong thuc UI `tienMat`, `chuyenKhoan`, `viDienTu` sang enum SQL va nhan dien `OVERPAID`.
  - Da verify: backend test pass, frontend `npx tsc --noEmit` pass.
- [x] Sua luong data loss theo `planning/api_data_sync_report.md`:
  - Them `FileMedia` entity, `FileMediaRepository`, `MediaService` map bang SQL `file_media`.
  - `Phong`: luu/doc `anhPhong` vao `file_media` voi doi_tuong `ROOM`; luu/doc `tienNghi` qua `tien_ich` va `phong_tien_ich`.
  - `KhachThue`: luu/doc `anhCCCD.matTruoc`, `anhCCCD.matSau` vao `file_media` voi doi_tuong `TENANT`.
  - `SuCo`: luu/doc `anhSuCo` vao `file_media` voi doi_tuong `INCIDENT`.
  - `ThanhToan`: luu/doc `anhBienLai` vao `file_media` voi doi_tuong `PAYMENT`; endpoint `hoa-don/{id}/thanh-toan` nhan them `anhBienLai`, `ngayThanhToan`.
  - Da verify: backend `mvn test` pass, frontend `npx tsc --noEmit` pass.
- [x] Hoan thien luong thanh vien hop dong / ban cung phong:
  - Them entity `ThanhVienHopDong` va `ThanhVienHopDongRepository` map bang SQL `thanh_vien_hop_dong`.
  - `HopDongRequest` chap nhan `khachThueId` dang string hoac mang id tu frontend.
  - `HopDongService` luu nguoi dai dien va danh sach nguoi o cung vao `thanh_vien_hop_dong`.
  - `HopDongResponse` tra `khachThueId[]`, `nguoiDaiDien`, `khachThueDaiDienId`, `thanhVien[]`.
  - UI tao/sua hop dong tach ro: nguoi dai dien dung ten hop dong va ban cung phong/thanh vien o cung.
  - Da verify: backend `mvn test` pass, frontend `npx tsc --noEmit` pass.
- [x] Hoàn thiện Phase 0 - Nền Tảng Kỹ Thuật:
  - Tách `db.sql` thành các file migration.
  - Fix hết các lỗi TS lint còn sót lại trong component.
  - Viết lại `check-setup.js` không dùng Mongoose.
  - Xác nhận mapping `id` và `_id` qua `domain-mappers.ts` hoạt động chuẩn.
- [x] Hoàn thiện mục Dashboard hiện có cần hoàn thiện CRUD:
  - Fix lỗi constraint `chu_tro_id` bằng cách mock admin ID tạm thời cho Khách Thuê và Nhà Trọ.
  - Fix validation: không cho xóa Phòng nếu đang có hợp đồng hoạt động.
  - Fix validation: không cho tạo Hợp Đồng mới nếu Phòng đã có hợp đồng hoạt động.
  - Xác nhận toàn bộ UI/API của 10 màn hình hiện tại (`/dashboard`, `/dashboard/toa-nha`, `/dashboard/phong`, `/dashboard/khach-thue`, `/dashboard/hop-dong`, `/dashboard/hoa-don`, `/dashboard/thanh-toan`, `/dashboard/su-co`, `/dashboard/thong-bao`, `/dashboard/quan-ly-tai-khoan`) đã hoàn thiện và check off trong plan.

## 0.1. Uu Tien Moi - Hoan Thien Dashboard Full CRUD Truoc

Muc tieu gan nhat: lam dashboard co the van hanh duoc end-to-end truoc khi lam cac tinh nang nang cao. Moi module dashboard phai dat toi thieu:

- Co route UI trong `/dashboard/...`.
- Co list/table, search, filter, empty/loading/error state.
- Co create/update/delete hoac deactivate/soft-delete dung nghiep vu.
- Co form validation va mapping dung DTO backend.
- Co backend endpoint dung schema `sql/db.sql`.
- Co rewrite trong `frontend/next.config.ts` neu frontend goi qua `/api/...`.
- Co trang thai/status label dung enum SQL -> Java -> DTO -> frontend.
- Co verify: backend test pass va frontend `npx tsc --noEmit` pass.

### Dashboard hien co can hoan thien CRUD

- [x] `/dashboard` - Tong quan:
  - Chua phai CRUD nhung can dashboard aggregate that tu backend.
  - Can them card: tong phong, phong trong, dang thue, bao tri, tong khach, doanh thu thang, cong no, hoa don qua han, hop dong sap het han, su co dang xu ly.
- [x] `/dashboard/toa-nha` - Toa nha/nha tro:
  - Can full CRUD, search/filter, soft delete.
  - Can thong ke nhanh theo tung toa nha.
- [x] `/dashboard/phong` - Phong:
  - Can full CRUD, search/filter theo toa nha/trang thai/gia/tang.
  - Can quan ly tien ich phong va anh phong.
  - Khong cho xoa cung phong da co hop dong/hoa don.
- [x] `/dashboard/khach-thue` - Khach thue:
  - Can full CRUD, link optional voi tai khoan `nguoi_dung`.
  - Can CCCD, anh CCCD, lich su thue, trang thai dang thue/da roi di.
- [x] `/dashboard/hop-dong` - Hop dong:
  - Can full CRUD + detail/create/edit da co route rieng.
  - Can them thanh vien hop dong, gia han, ket thuc hop dong, xu ly coc.
  - Can chan overlap hop dong active cung phong.
- [x] `/dashboard/hoa-don` - Hoa don:
  - Can full CRUD + create/detail da co route rieng.
  - Can tao tu hop dong + cau hinh gia + chi so dien nuoc.
  - Can line item, no dau ky, phat sinh, da tra, con lai.
- [x] `/dashboard/thanh-toan` - Thanh toan:
  - Can full CRUD/ghi nhan thanh toan, loc theo hoa don/ky/phuong thuc.
  - Can ho tro tra nhieu lan, tra thieu, tra du, huy/refund co audit.
- [x] `/dashboard/su-co` - Su co/bao tri:
  - Can full CRUD, phan cong nguoi phu trach, chi phi sua chua, tinh vao hoa don.
  - Can upload anh su co qua `file_media`.
- [x] `/dashboard/thong-bao` - Thong bao:
  - Can CRUD thong bao va tach nguoi nhan theo `thong_bao_nguoi_nhan`.
  - Can mark read, send/retry, filter theo loai/kenh/trang thai doc.
- [x] `/dashboard/quan-ly-tai-khoan` - Tai khoan/nhan vien:
  - Can CRUD user theo Supabase Auth id.
  - Can gan role va phan cong staff theo nha tro.
- [x] `/dashboard/ho-so` - Ho so ca nhan:
  - Can xem/sua profile, avatar, so dien thoai.
  - Sau khi auth on dinh moi lam doi mat khau/2FA.
- [x] `/dashboard/cai-dat` - Cai dat:
  - Can tach thanh cau hinh he thong/toa nha/thanh toan/thong bao.
  - Khong de thanh trang tinh khong luu du lieu.
- [x] `/dashboard/xem-web` - Xem public portal:
  - Can preview phong trong va link public room portal.

### Dashboard can them man hinh moi

Ket luan: can them man hinh. Cac bang SQL moi va chuc nang thuc te chua duoc surfacing day du trong dashboard hien tai.

- [ ] `/dashboard/cau-hinh-gia` - Cau hinh gia dich vu:
  - Bat buoc lam som vi hoa don phu thuoc vao gia phong/dien/nuoc/internet/rac/gui xe.
  - Backend API nen tang da co `/api/cau-hinh-gia`; tiep theo can UI list/form.
- [ ] `/dashboard/chi-so-dien-nuoc` - Chot chi so:
  - CRUD chi so theo phong/hop dong/ky/loai.
  - Trang thai DRAFT/CONFIRMED/BILLED/CANCELLED.
  - Day la dau vao bat buoc cho hoa don dung thuc te.
- [ ] `/dashboard/cong-no` - Cong no:
  - Xem no theo khach thue/phong/toa nha/ky.
  - Loc qua han, xuat danh sach nhac no.
  - Tao line item `DEBT` khi chuyen ky.
- [ ] `/dashboard/dich-vu` - Dich vu va tien ich:
  - CRUD `dich_vu`, `tien_ich`.
  - Gan dich vu vao hop dong qua `dich_vu_hop_dong`.
  - Gan tien ich vao phong qua `phong_tien_ich`.
- [ ] `/dashboard/lich-hen` - Lich hen xem phong:
  - CRUD/duyet/huy/hoan thanh/no-show lich hen.
  - Lay tu public room portal.
- [ ] `/dashboard/media` - Quan ly file/media:
  - Quan ly file trong `file_media`.
  - Gan file cho phong, khach thue, hop dong, hoa don, thanh toan, su co, chi so.
- [ ] `/dashboard/bao-cao` - Bao cao:
  - Doanh thu, tien da thu, tien chua thu, ty le lap day, su co, hop dong sap het han.
  - Nen tach API aggregate rieng, khong load toan bo bang.
- [ ] `/dashboard/audit-log` - Nhat ky he thong:
  - Xem audit cho hop dong, hoa don, thanh toan, user, phan quyen.
  - Quan trong cho production.
- [ ] `/dashboard/vietqr-doi-soat` - Doi soat ngan hang:
  - Lam sau khi thanh toan co ban on dinh.
  - Quan ly `bank_transaction`, auto-match/manual-match/refund.

### Thu tu lam dashboard khuyen nghi

1. On dinh layout/sidebar/route guard va API response normalization.
2. Hoan thien CRUD Toa nha.
3. Hoan thien CRUD Phong.
4. Them dashboard `dich-vu` va `cau-hinh-gia`.
5. Hoan thien CRUD Khach thue.
6. Hoan thien Hop dong + thanh vien hop dong + ket thuc/gia han.
7. Them dashboard `chi-so-dien-nuoc`.
8. Hoan thien Hoa don tao tu hop dong/gia/chi so.
9. Hoan thien Thanh toan nhieu lan va trang thai hoa don.
10. Them dashboard `cong-no`.
11. Hoan thien Su co + chi phi + tinh vao hoa don.
12. Them `lich-hen`, `media`, `thong-bao`.
13. Hoan thien `quan-ly-tai-khoan`, role, staff assignment.
14. Them `bao-cao`, `audit-log`.
15. Lam `vietqr-doi-soat` va cac tinh nang nang cao.

Mục tiêu: hoàn thiện EasyHouse thành webapp quản lý phòng trọ có thể vận hành thực tế, dựa trên:

- Danh sách chức năng: `danh_sach_chuc_nang.txt`
- Schema production: `sql/db.sql`
- Frontend hiện có: `frontend/`
- Backend Spring Boot hiện có: `be/`

## 1. Nguyên Tắc Triển Khai

- Không expose trực tiếp entity JPA ra frontend. Luồng chuẩn: Request DTO -> Service -> Entity -> Response DTO.
- Frontend dùng DTO camelCase ổn định, backend chịu trách nhiệm map với PostgreSQL snake_case.
- Giữ alias `_id` ở DTO response trong giai đoạn chuyển đổi để không phá UI hiện tại.
- Mọi status phải map qua 4 lớp: SQL enum -> Java enum -> DTO -> frontend label.
- Ưu tiên hoàn thiện nghiệp vụ vận hành thật trước AI/nâng cao.
- Auth, billing, payment, công nợ là vùng rủi ro cao, phải có test.

## 2. Phase 0 - Nền Tảng Kỹ Thuật

### 2.1. Chuẩn hóa schema và migration

- [x] Chạy thử `sql/db.sql` trên PostgreSQL/Supabase staging.
- [x] Sửa lỗi DDL nếu có: thứ tự FK, RLS policy, trigger, generated column.
- [x] Tách schema thành migration versioned:
  - `001_extensions_enums.sql`
  - `002_core_identity.sql`
  - `003_property_room.sql`
  - `004_contract_tenant.sql`
  - `005_billing_payment.sql`
  - `006_operations_notification.sql`
  - `007_rls_policy.sql`
  - `008_seed_data.sql`
- [x] Bổ sung seed role: `ADMIN`, `LANDLORD`, `STAFF`, `TENANT`.

### 2.2. Chuẩn hóa DTO contract

- [x] Backend response phải trả cả `id` và `_id`.
- [x] Chuẩn hóa DTO:
  - `NhaTroResponse`
  - `PhongResponse`
  - `KhachThueResponse`
  - `HopDongResponse`
  - `ThanhVienHopDongResponse`
  - `HoaDonResponse`
  - `ChiTietHoaDonResponse`
  - `ThanhToanResponse`
  - `SuCoResponse`
  - `ThongBaoResponse`
  - `CauHinhGiaResponse`
- [x] Frontend dùng `frontend/src/types/index.ts` làm contract duy nhất.
- [x] Mọi API fetch frontend nên normalize qua `frontend/src/lib/domain-mappers.ts`.

### 2.3. Kiểm tra chất lượng frontend

- [x] Bật lại TypeScript build strict theo từng bước.
- [x] Sửa các lỗi lint hiện có:
  - `react/no-unescaped-entities`
  - `@typescript-eslint/no-explicit-any`
  - unused imports
  - missing hook dependency
- [x] Xóa hoặc thay thế các đoạn còn dấu vết Mongo/Mongoose.
- [x] Xóa hoặc viết lại `frontend/scripts/check-setup.js` vì hiện còn kiểm tra MongoDB/Mongoose-era setup.

## 3. Phase 1 - Auth, Account, Role

### 3.1. Đăng ký, đăng nhập, xác thực email

- Hoàn thiện đăng ký chủ trọ/người thuê.
- Email verification sau đăng ký.
- Login bằng JWT thật hoặc Supabase Auth session.
- Không dùng email làm token.
- Thêm refresh token hoặc session refresh đúng chuẩn.

### 3.2. Phân quyền

- Implement role:
  - `ADMIN`: quản trị toàn hệ thống.
  - `LANDLORD`: quản lý nhà trọ thuộc sở hữu.
  - `STAFF`: quản lý nhà trọ được phân công.
  - `TENANT`: xem dữ liệu của chính mình.
- Thêm UI phân công nhân viên theo nhà trọ:
  - Chọn nhà trọ.
  - Gán nhân viên.
  - Cấp quyền xem/sửa/thu tiền.
- Backend kiểm tra quyền ở service/controller, không chỉ frontend hide menu.

### 3.3. Bảo mật tài khoản

- 2FA Google Authenticator:
  - Màn hình bật/tắt 2FA.
  - QR setup.
  - Verify OTP khi login.
- Login history:
  - IP.
  - User agent.
  - Trạng thái thành công/thất bại.
- Auto lock account:
  - Sai mật khẩu quá N lần.
  - Hiển thị trạng thái khóa.
  - Admin mở khóa.
- Audit log:
  - Tạo/sửa/xóa dữ liệu quan trọng.
  - Ai thao tác.
  - Thời gian.
  - Dữ liệu trước/sau.

## 4. Phase 2 - Property And Room Management

### 4.1. Tòa nhà / khu trọ

- Hoàn thiện CRUD tòa nhà.
- Gắn owner `chuTroId`.
- Tìm kiếm theo tên, địa chỉ, quận, thành phố.
- Soft delete bằng `xoa_luc`.
- Dashboard thống kê theo tòa nhà:
  - Tổng phòng.
  - Phòng trống.
  - Phòng đang thuê.
  - Phòng bảo trì.

### 4.2. Phòng

- CRUD phòng.
- Trạng thái chuẩn:
  - `AVAILABLE`
  - `RESERVED`
  - `RENTED`
  - `MAINTENANCE`
  - `INACTIVE`
- Quản lý tiện ích:
  - Bảng `tien_ich`.
  - Bảng nối `phong_tien_ich`.
  - UI chọn tiện ích bằng checkbox/tag.
- Upload ảnh phòng qua Cloudinary và lưu vào `file_media`.
- Public room portal:
  - Lọc phòng trống.
  - Tìm kiếm theo tòa nhà/khu vực/giá.
  - Xem chi tiết phòng.

## 5. Phase 3 - Tenant And Contract

### 5.1. Khách thuê

- CRUD khách thuê.
- Lưu CCCD, ảnh CCCD trước/sau, số điện thoại, địa chỉ, nghề nghiệp.
- Cho phép khách thuê không có tài khoản đăng nhập.
- Optional link `khach_thue.nguoi_dung_id`.
- Trạng thái:
  - Chưa thuê.
  - Đang thuê.
  - Đã trả phòng.
- Lịch sử thuê phòng.

### 5.2. Hợp đồng

- CRUD hợp đồng.
- Chống tạo hợp đồng active trùng phòng cùng thời gian.
- Người đại diện hợp đồng là `hop_dong.khach_thue_id`.
- Người ở ghép nằm ở `thanh_vien_hop_dong`.
- Quản lý thành viên hợp đồng:
  - Thêm người ở.
  - Ngày vào.
  - Ngày rời.
  - Đang ở.
  - Người đại diện.
- Gia hạn hợp đồng:
  - Tạo `phu_luc_hop_dong`.
  - Cập nhật ngày kết thúc mới.
  - Lưu lịch sử thay đổi.
- Kết thúc hợp đồng:
  - Ngày kết thúc thực tế.
  - Xử lý cọc: giữ, hoàn, khấu trừ, mất cọc.
  - Cập nhật trạng thái phòng.

### 5.3. Nhắc hết hạn hợp đồng

- Dashboard hiển thị hợp đồng sắp hết hạn.
- Job chạy hằng ngày tìm hợp đồng còn 7 ngày.
- Gửi email/thông báo in-app.
- Sau này mở rộng Zalo/Telegram.

## 6. Phase 4 - Service Price And Meter Readings

### 6.1. Cấu hình giá dịch vụ

- Tạo màn hình `cau-hinh-gia`.
- Quản lý:
  - Giá phòng mặc định.
  - Giá điện.
  - Giá nước.
  - Internet.
  - Rác.
  - Giữ xe.
  - Dịch vụ khác.
- Hỗ trợ loại tính phí:
  - `FIXED`
  - `PER_PERSON`
  - `PER_ROOM`
  - `PER_UNIT`
  - `PERCENT`
- Có hiệu lực từ/ngày hết hiệu lực.
- Không sửa dữ liệu giá cũ đã dùng cho hóa đơn, chỉ tạo cấu hình mới.

### 6.2. Chốt chỉ số điện nước

- Tạo màn hình `chi-so-dien-nuoc`.
- Ghi theo:
  - Phòng.
  - Hợp đồng.
  - Tháng/năm.
  - Loại: điện/nước.
  - Chỉ số cũ.
  - Chỉ số mới.
  - Ảnh đồng hồ.
  - Người ghi.
- Trạng thái:
  - `DRAFT`
  - `CONFIRMED`
  - `BILLED`
  - `CANCELLED`
- Validation:
  - Chỉ số mới >= chỉ số cũ.
  - Không tạo trùng phòng + loại + kỳ.
  - Không sửa chỉ số đã billed nếu không có quyền.

## 7. Phase 5 - Billing, Payment, Debt

### 7.1. Hóa đơn

- Tách rõ:
  - `hoa_don`: header.
  - `chi_tiet_hoa_don`: line item.
- Khi tạo hóa đơn:
  - Lấy hợp đồng active.
  - Lấy cấu hình giá áp dụng.
  - Lấy chỉ số điện/nước đã confirmed.
  - Tạo dòng tiền phòng.
  - Tạo dòng điện.
  - Tạo dòng nước.
  - Tạo dòng dịch vụ.
  - Tạo dòng nợ kỳ trước nếu có.
- Không lưu chỉ số điện nước trong text mô tả.
- Chống tạo trùng hóa đơn cùng hợp đồng + kỳ.

### 7.2. Công nợ

- Hóa đơn cần hiển thị:
  - Số dư đầu kỳ.
  - Phát sinh kỳ này.
  - Tổng phải thu.
  - Đã trả.
  - Còn lại.
  - Trạng thái.
- Thêm màn hình công nợ:
  - Theo khách thuê.
  - Theo phòng.
  - Theo tòa nhà.
  - Theo kỳ.
  - Quá hạn.
- Chuyển nợ kỳ trước vào hóa đơn kỳ sau bằng line item `DEBT`.

### 7.3. Thanh toán

- Ghi nhận nhiều lần thanh toán cho một hóa đơn.
- Cho phép trả thiếu.
- Cho phép trả dư và đánh dấu `OVERPAID`.
- Phương thức:
  - Tiền mặt.
  - Chuyển khoản.
  - VietQR.
  - Ví điện tử.
- Upload ảnh biên lai vào `file_media`.
- Trigger/backend service cập nhật `hoa_don.da_tra` và `trang_thai`.

### 7.4. VietQR/OpenBanking

- Sinh QR động theo từng hóa đơn:
  - Số tiền.
  - Nội dung chuyển khoản.
  - Mã hóa đơn.
- Bảng `bank_transaction`.
- Webhook nhận giao dịch ngân hàng.
- Auto-match giao dịch với hóa đơn.
- UI đối soát:
  - Giao dịch chưa match.
  - Match thủ công.
  - Giao dịch bị trùng.
  - Hoàn tiền/refund.

## 8. Phase 6 - Operations And Interaction

### 8.1. Sự cố / bảo trì

- Người thuê báo sự cố với ảnh.
- Chủ trọ/staff phân công người xử lý.
- Trạng thái:
  - `PENDING`
  - `IN_PROGRESS`
  - `RESOLVED`
  - `CANCELLED`
- Ghi nhận chi phí sửa chữa.
- Cho phép tính chi phí vào hóa đơn nếu cần.
- Báo cáo chi phí bảo trì theo tháng.

### 8.2. Booking xem phòng

- Public room portal thêm form đặt lịch xem phòng.
- Thông tin khách:
  - Họ tên.
  - Số điện thoại.
  - Email.
  - Ngày giờ hẹn.
  - Phòng muốn xem.
- Chủ trọ duyệt/hủy lịch.
- Trạng thái:
  - `PENDING`
  - `CONFIRMED`
  - `CANCELLED`
  - `COMPLETED`
  - `NO_SHOW`
- Đồng bộ Google Calendar.
- Job nhắc lịch trước 2 giờ qua email/SMS.

### 8.3. Thông báo

- Tách:
  - `thong_bao`
  - `thong_bao_nguoi_nhan`
- Theo dõi đã đọc theo từng người.
- Loại thông báo:
  - System.
  - Hóa đơn.
  - Thanh toán.
  - Hợp đồng.
  - Sự cố.
  - Lịch hẹn.
  - Công nợ.
- Job tự động:
  - Nhắc hóa đơn sắp đến hạn.
  - Nhắc nợ quá hạn.
  - Nhắc hợp đồng sắp hết hạn.
- Push notification sau khi có service worker.

## 9. Phase 7 - Dashboard And Reports

### 9.1. Dashboard tổng quan

- Tổng phòng.
- Phòng trống.
- Phòng đang thuê.
- Phòng bảo trì.
- Tổng khách thuê.
- Doanh thu tháng.
- Công nợ.
- Hóa đơn quá hạn.
- Hợp đồng sắp hết hạn.
- Sự cố đang xử lý.

### 9.2. Báo cáo tài chính

- Doanh thu theo tháng/năm.
- Doanh thu theo tòa nhà.
- Tiền đã thu.
- Tiền chưa thu.
- Công nợ quá hạn.
- Tỷ lệ thu tiền.
- Lợi nhuận thực:
  - Doanh thu đã thu.
  - Trừ chi phí sửa chữa/bảo trì.

### 9.3. Báo cáo vận hành

- Tỷ lệ lấp đầy phòng.
- Thời gian phòng trống.
- Số sự cố theo loại.
- Chi phí bảo trì theo phòng/tòa nhà.
- Hợp đồng sắp hết hạn.
- Khách thuê rời đi.

## 10. Phase 8 - Media And Files

- Chuẩn hóa upload về bảng `file_media`.
- Mỗi file có:
  - Đối tượng.
  - Đối tượng ID.
  - URL.
  - Cloudinary public ID.
  - Metadata.
  - Người tải lên.
- Áp dụng cho:
  - Ảnh phòng.
  - CCCD.
  - Ảnh sự cố.
  - Ảnh đồng hồ.
  - Hợp đồng PDF.
  - Biên lai thanh toán.
- Thêm màn hình quản lý media nếu cần.

## 11. Phase 9 - Advanced Features

### 11.1. AI OCR CCCD

- Upload ảnh CCCD.
- Gửi ảnh tới OCR service.
- Trích xuất:
  - Họ tên.
  - Ngày sinh.
  - Số CCCD.
  - Quê quán.
- Hiển thị preview để người dùng xác nhận trước khi lưu.
- Lưu OCR confidence và raw result.

### 11.2. AI Vision đọc công tơ

- Upload/chụp ảnh đồng hồ điện/nước.
- OCR/Vision đọc chỉ số.
- Hiển thị số đọc được.
- Người dùng xác nhận.
- Lưu ảnh, chỉ số, confidence.
- Cảnh báo nếu thấp hơn kỳ trước hoặc tăng bất thường.

### 11.3. Anomaly detection

- Phát hiện điện/nước tăng đột biến.
- Rule ban đầu:
  - Tăng > 200% so với trung bình 3 tháng.
  - Tăng tuyệt đối vượt ngưỡng.
- Gửi cảnh báo cho chủ trọ và khách thuê.

### 11.4. Chatbot tenant

- UI chat trong tenant dashboard.
- Knowledge base:
  - Nội quy.
  - Hướng dẫn thanh toán.
  - Cách báo sự cố.
  - Cách tính hóa đơn.
- Log cuộc trò chuyện.
- Escalate sang chủ trọ/staff nếu không xử lý được.

### 11.5. E-contract and e-signature

- Generate hợp đồng từ template.
- Cho chủ trọ/khách thuê ký trên màn hình.
- Lưu chữ ký.
- Hash file PDF sau khi ký.
- Khóa phiên bản hợp đồng đã ký.
- Tạo phụ lục khi gia hạn/thay đổi giá.

### 11.6. Multi-channel notification

- Email.
- SMS.
- Zalo ZNS.
- Telegram Bot.
- Push notification.
- Cấu hình kênh theo chủ trọ.
- Retry khi gửi lỗi.
- Lưu delivery log.

## 12. Tối Ưu Truy Vấn Và Hiệu Năng

### 12.1. Index bắt buộc

- `phong(nha_tro_id)`
- `phong(trang_thai)`
- `hop_dong(phong_id, trang_thai, ngay_bat_dau, ngay_ket_thuc)`
- `hop_dong(khach_thue_id)`
- `thanh_vien_hop_dong(hop_dong_id)`
- `hoa_don(hop_dong_id, ky_nam, ky_thang)`
- `hoa_don(phong_id)`
- `hoa_don(khach_thue_id)`
- `hoa_don(trang_thai, han_tra)`
- `chi_tiet_hoa_don(hoa_don_id)`
- `thanh_toan(hoa_don_id)`
- `chi_so_dien_nuoc(phong_id, loai, ky_nam, ky_thang)`
- `su_co(phong_id, trang_thai)`
- `thong_bao_nguoi_nhan(nguoi_dung_id, da_doc)`

### 12.2. Query pattern

- Danh sách phòng không query từng hợp đồng riêng gây N+1.
- Danh sách hóa đơn phải join/DTO batch:
  - Hóa đơn.
  - Phòng.
  - Khách thuê.
  - Tổng thanh toán.
- Dashboard dùng query aggregate riêng, không load toàn bộ bảng lên app.
- Báo cáo doanh thu dùng query theo tháng/năm có index.
- Public invoice chỉ trả dữ liệu cần hiển thị, không trả thông tin nhạy cảm.

### 12.3. Pagination

- Mọi list API phải có:
  - `page`
  - `limit`
  - `sort`
  - `search`
  - filter theo trạng thái/kỳ/tòa nhà.
- Không dùng `limit=100` lâu dài trong frontend.
- Default `limit=20`, max `limit=100`.

### 12.4. Cache

- Frontend cache ngắn hạn cho danh mục ít thay đổi:
  - Tòa nhà.
  - Phòng.
  - Dịch vụ.
- Không cache lâu dữ liệu tài chính:
  - Hóa đơn.
  - Thanh toán.
  - Công nợ.
- Backend có thể dùng cache cho dashboard aggregate nếu cần.

### 12.5. Database consistency

- Tính tổng hóa đơn trong transaction.
- Payment insert/update phải cập nhật hóa đơn trong cùng transaction.
- Không cho sửa/xóa payment thành công nếu đã đối soát ngân hàng, chỉ tạo adjustment/refund.
- Không cho sửa hóa đơn `PAID` nếu không có quyền admin hoặc không tạo lịch sử.

## 13. Bảo Mật Và RLS

- RLS theo owner/staff/tenant.
- LANDLORD chỉ xem nhà trọ của mình.
- STAFF chỉ xem nhà trọ được phân công.
- TENANT chỉ xem hợp đồng/hóa đơn/thanh toán/sự cố của mình.
- Public invoice dùng token/share slug riêng, không dùng ID đoán được.
- Upload file phải kiểm tra:
  - Loại file.
  - Size.
  - Quyền sở hữu đối tượng.
- Không lưu secret trong frontend.
- Không log mật khẩu/token.

## 14. Kiểm Thử

### 14.1. Backend tests

- Auth:
  - Login đúng/sai.
  - User bị khóa.
  - Role access.
- Room:
  - Không xóa phòng đang có hợp đồng active.
- Contract:
  - Không overlap hợp đồng cùng phòng.
  - Gia hạn tạo phụ lục.
  - Kết thúc hợp đồng cập nhật phòng.
- Billing:
  - Tạo hóa đơn đúng line items.
  - Không tạo trùng kỳ.
  - Điện/nước không âm.
  - Công nợ chuyển kỳ.
- Payment:
  - Trả thiếu.
  - Trả đủ.
  - Trả dư.
  - Cập nhật trạng thái hóa đơn.

### 14.2. Frontend tests

- Login/register flow.
- CRUD tòa nhà/phòng/khách thuê.
- Tạo hợp đồng nhiều người ở.
- Tạo hóa đơn từ chỉ số.
- Ghi nhận thanh toán nhiều lần.
- Tenant xem hóa đơn.
- Sự cố có ảnh.

### 14.3. E2E flows

- Chủ trọ tạo tòa nhà -> tạo phòng -> tạo khách thuê -> tạo hợp đồng -> chốt số -> tạo hóa đơn -> khách xem hóa đơn -> thanh toán -> hóa đơn paid.
- Khách thuê báo sự cố -> staff xử lý -> chủ trọ đóng sự cố -> chi phí vào báo cáo.
- Phòng trống public -> khách đặt lịch -> chủ trọ duyệt -> gửi nhắc lịch.

## 15. DevOps And Monitoring

- Docker Compose local full stack.
- Environment profiles:
  - local
  - staging
  - production
- Health check backend.
- Logging request/error.
- Metrics:
  - API latency.
  - Error rate.
  - DB connection pool.
  - Slow queries.
- Prometheus/Grafana dashboard.
- Backup database hằng ngày.
- Migration rollback plan.

## 16. Thứ Tự Ưu Tiên Khuyến Nghị

1. Chạy ổn schema production trên staging.
2. Chuẩn hóa backend DTO theo frontend contract.
3. Sửa auth/JWT/session.
4. Hoàn thiện tòa nhà/phòng/khách thuê theo schema mới.
5. Hoàn thiện hợp đồng + thành viên hợp đồng.
6. Làm cấu hình giá.
7. Làm chốt chỉ số điện/nước.
8. Làm hóa đơn line items + công nợ.
9. Làm thanh toán nhiều lần + trạng thái hóa đơn.
10. Làm báo cáo công nợ/doanh thu.
11. Làm phân công staff/RLS.
12. Làm booking xem phòng.
13. Làm thông báo tự động.
14. Làm VietQR đối soát.
15. Làm e-contract/chữ ký.
16. Làm AI OCR/AI Vision/chatbot/anomaly.

## 17. Definition Of Done

Một module chỉ được coi là hoàn thành khi:

- Có schema/table/index phù hợp.
- Có backend entity/repository/service/controller.
- Có DTO request/response.
- Có validation request.
- Có authorization/RLS hoặc service-level permission.
- Có frontend list/form/detail.
- Có loading/error/empty state.
- Có test backend cho nghiệp vụ chính.
- Có ít nhất một manual E2E flow đã chạy qua.
- Có log/audit nếu là nghiệp vụ tài chính/hợp đồng/thanh toán.
