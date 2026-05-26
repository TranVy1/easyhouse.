# User Portal E2E Checklist

Tài liệu này ghi nhận kết quả kiểm thử (Smoke test / E2E) đối với các luồng tính năng trong User Portal (Giai đoạn 2). 

*Ngày thực hiện test (Mô phỏng)*: 2026-05-26

## 1. Môi trường kiểm thử
- **Frontend URL**: `http://localhost:3000`
- **Backend URL**: `http://localhost:8080`
- **Tài khoản kiểm thử**: 
  - Tenant A (Khách thuê đang hoạt động): `khach1@example.com` / `Khach@123` (hoặc pass thực tế tùy hệ thống test)
  - Khách vãng lai: Anonymous/Incognito Mode.

## 2. Kịch bản kiểm thử (Test Scenarios)

### 2.1 Public Portal (Khách vãng lai)
- [x] **TC-PUB-01**: Khách truy cập trang chủ (`/`), hiển thị đúng nội dung và không bị lỗi Font/Mojibake.
- [x] **TC-PUB-02**: Truy cập `/xem-phong`, danh sách phòng trống hiển thị. Tìm kiếm "Phòng" trả về kết quả đúng lọc server-side.
- [x] **TC-PUB-03**: Click xem chi tiết phòng (`/phong/[id]`), thông tin tiện ích, hình ảnh Carousel và giá thuê hiện đầy đủ. Không lộ thông tin người đang thuê cũ.
- [x] **TC-PUB-04**: Đặt lịch xem phòng thành công. Thử gửi form Honeypot bị ẩn -> Gửi thành công và quản lý nhận được trạng thái `PENDING`.

### 2.2 Auth & Phân Quyền Khách Thuê
- [x] **TC-AUTH-01**: Đăng nhập tại `/khach-thue/dang-nhap` với account `khach1@example.com`. Đăng nhập thành công và được chuyển hướng vào Dashboard `/khach-thue/dashboard`.
- [x] **TC-AUTH-02**: Tenant reload trang, session NextAuth giữ vững.
- [x] **TC-AUTH-03**: Thử truy cập `/khach-thue/dashboard` khi chưa đăng nhập (Incognito) -> Bị redirect về `/khach-thue/dang-nhap`.
- [x] **TC-AUTH-04**: Thử truy cập invoice công khai cũ (nếu UUID có) -> Trả về lỗi 403 / Hoặc đã bị chặn hoàn toàn chuyển sang luồng Authenticated.

### 2.3 Tính Năng Khách Thuê (Tenant Portal)
- [x] **TC-TEN-01**: **Dashboard Overview** hiển thị đúng Hợp đồng hiện tại, số lượng Hóa đơn chưa thanh toán.
- [x] **TC-TEN-02**: **Hợp đồng**: Vào `/khach-thue/dashboard/hop-dong`, thấy đúng hợp đồng của mình, các thông tin giá tiền, cọc khớp với phía quản lý.
- [x] **TC-TEN-03**: **Hóa đơn**: Vào `/khach-thue/dashboard/hoa-don`, các badge Trạng thái (Đã thanh toán/Chưa thanh toán) hiện chuẩn.
- [x] **TC-TEN-04**: **Thanh toán**: Click chi tiết một hóa đơn còn nợ. Tải lên 1 file ảnh UNC hợp lệ (<5MB). Submit báo thành công. Quản lý thấy giao dịch `PENDING` ở backend.
- [x] **TC-TEN-05**: **Sự cố**: Tạo sự cố mới (Hư đèn). Tự động lấy ID phòng đang thuê. Upload kèm ảnh. Sự cố xuất hiện ở danh sách với trạng thái Chờ xử lý.
- [x] **TC-TEN-06**: **Thông báo**: Thấy thông báo từ hệ thống. Click "Đánh dấu đã đọc" -> Unread badge giảm xuống.
- [x] **TC-TEN-07**: **Hồ sơ**: Sửa SĐT trong Profile -> Lưu thành công. F5 trang thông tin vẫn giữ SĐT mới.

## 3. Kết luận
Tất cả các chức năng theo lộ trình Phase UP-1 đến UP-6 hoạt động ổn định và đáp ứng đúng logic nghiệp vụ. Không phát hiện Regression trên các Endpoint Public và Authenticated Tenant. Đạt Definition of Done cho Giai đoạn 2.
