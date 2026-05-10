# KẾ HOẠCH HOÀN THIỆN & KIỂM THỬ DỰ ÁN QUẢN LÝ PHÒNG TRỌ

## 1. Tổng quan luồng nghiệp vụ
- Đăng ký/Đăng nhập (NextAuth, JWT, phân quyền)
- Quản lý tòa nhà (CRUD)
- Quản lý phòng (CRUD, trạng thái)
- Quản lý khách thuê (CRUD, upload CCCD)
- Quản lý hợp đồng (CRUD, liên kết phòng/khách)
- Quản lý hóa đơn, thanh toán (tính toán, xác nhận)
- Quản lý sự cố, thông báo

## 2. Kế hoạch test (Test Plan)
### 2.1. Test Backend API
- [ ] Test CRUD cho từng entity (tòa nhà, phòng, khách thuê, hợp đồng, hóa đơn...)
- [ ] Test phân quyền API (ADMIN, LANDLORD, TENANT)
- [ ] Test enum mapping (trạng thái phòng, hóa đơn...)
- [ ] Test upload file (Cloudinary)
- [ ] Test validate dữ liệu (trùng lặp, định dạng, ràng buộc)
- [ ] Test lỗi nghiệp vụ (phòng đã thuê, hợp đồng hết hạn...)

### 2.2. Test Frontend
- [ ] Test form nhập liệu (zod, react-hook-form)
- [ ] Test hiển thị bảng dữ liệu (table, filter, phân trang)
- [ ] Test upload ảnh, preview
- [ ] Test bảo vệ route (middleware, useSession)
- [ ] Test UX: double submit, loading, toast, lỗi
- [ ] Test responsive, mobile

### 2.3. Test tích hợp (Integration)
- [ ] Đăng nhập → tạo tòa nhà → thêm phòng → tạo hợp đồng → sinh hóa đơn → thanh toán
- [ ] Test các luồng edge-case: xóa tòa nhà có phòng, xóa khách đang thuê...

## 3. Checklist lỗi tiềm ẩn & hướng xử lý
- [ ] Lỗi nhân đôi bản ghi khi submit nhanh → Chặn double submit, kiểm tra trùng lặp backend
- [ ] Lỗi enum mapping lệch giữa DB/Java/TS → Kiểm tra 3 lớp khi sửa enum
- [ ] Lỗi upload file thất bại → Bắt lỗi rõ ràng, validate size/type
- [ ] Lỗi phân quyền: user truy cập API không đúng role → Test kỹ middleware, @PreAuthorize
- [ ] Lỗi validate dữ liệu: thiếu trường, sai định dạng → Bổ sung validate cả backend/frontend
- [ ] Lỗi mất session, hết hạn token → Xử lý refresh, redirect login

## 4. Đề xuất mở rộng & làm đẹp
- [ ] Thêm dashboard thống kê (doanh thu, phòng trống, sự cố...)
- [ ] Thêm chức năng tìm kiếm, lọc nâng cao
- [ ] Thêm lịch sử thao tác, log audit
- [ ] Thêm xác thực 2 lớp (2FA) cho chủ trọ
- [ ] Thêm dark mode, tối ưu UI/UX (Radix UI, Tailwind)
- [ ] Thêm hướng dẫn sử dụng, tooltip, placeholder rõ ràng
- [ ] Đa ngôn ngữ (i18n)
- [ ] Tối ưu hiệu năng: lazy load, cache, phân trang server
- [ ] Tối ưu bảo mật: rate limit, XSS/CSRF, ẩn thông tin nhạy cảm

## 5. Quy trình kiểm thử & hoàn thiện
1. Viết test case cho từng chức năng chính
2. Thực hiện test thủ công & tự động (Postman, Jest...)
3. Ghi nhận bug, fix và xác nhận lại
4. Review UI/UX, tối ưu trải nghiệm
5. Đánh giá bảo mật, backup dữ liệu
6. Chuẩn bị tài liệu hướng dẫn sử dụng

---

*File này là checklist tổng hợp, có thể bổ sung chi tiết từng mục khi phát sinh thêm yêu cầu thực tế.*
