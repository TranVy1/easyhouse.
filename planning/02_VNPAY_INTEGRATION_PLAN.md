# P0 - Tích hợp VNPay Sandbox tự động gạch nợ

## 1. Vấn đề hiện tại

Hệ thống đã có:
- Quản lý hóa đơn và tính tổng tiền tự động.
- API manual match thanh toán (đối soát thủ công).

Nhưng để làm nổi bật đồ án và mang tính thực tế cao, giáo viên sẽ đánh giá cao việc hệ thống có tích hợp thanh toán trực tuyến qua cổng thanh toán (Payment Gateway) thực tế, thay vì chỉ tạo mã QR tĩnh. VNPay là một trong những cổng thanh toán phổ biến nhất tại Việt Nam và có hỗ trợ môi trường Sandbox cho nhà phát triển.

## 2. Mục tiêu nghiệp vụ

Khi khách thuê có hóa đơn cần thanh toán:
- Khách bấm "Thanh toán VNPay" trên trang chi tiết hóa đơn (public hoặc dashboard khách thuê).
- Hệ thống tự động tạo URL thanh toán VNPay và chuyển hướng người dùng sang trang thanh toán của VNPay Sandbox.
- Khách dùng thẻ test của VNPay để thanh toán.
- Sau khi thanh toán, VNPay gọi webhook (IPN - Instant Payment Notification) về server báo trạng thái.
- Hệ thống kiểm tra chữ ký (checksum), số tiền, trạng thái giao dịch và tự động cập nhật:
  - Tạo một `ThanhToan` liên kết với hóa đơn.
  - Cập nhật `daTra`, `conLai` và `trangThai` của hóa đơn thành `PAID` (Đã thanh toán).
- Hệ thống chuyển hướng người dùng về trang thông báo thành công/thất bại.

## 3. Flow xử lý

### Flow tạo thanh toán (Frontend -> Backend -> VNPay)

1. Client gọi `GET /api/vnpay/create-payment-url?hoaDonId=...&amount=...&returnUrl=...`
2. Backend đọc cấu hình VNPay (TmnCode, HashSecret), tạo chuỗi ký tự (hash) theo chuẩn VNPay, sinh ra URL thanh toán VNPay.
3. Backend trả URL về cho Client.
4. Client redirect người dùng sang URL của VNPay.
5. Khách thuê nhập thông tin thẻ test và xác thực (OTP test).

### Flow nhận kết quả tức thời (VNPay -> Return URL -> Client)

1. Sau khi khách thanh toán xong, VNPay redirect khách về `returnUrl` (trang frontend) kèm theo tham số (vnp_ResponseCode, vnp_TxnRef, vnp_SecureHash...).
2. Frontend gọi API `GET /api/vnpay/check-return?...` hoặc tự hiển thị trang kết quả (Thành công/Thất bại). Thực tế việc gạch nợ nên được IPN lo. Return URL chỉ để báo cho người dùng.

### Flow IPN xử lý giao dịch (VNPay -> Webhook Backend)

1. VNPay server gửi GET/POST request đến URL IPN của backend: `/api/vnpay/ipn`.
2. Backend (VNPayController):
   - Tính toán lại mã hash để xác thực dữ liệu từ VNPay không bị thay đổi.
   - Kiểm tra `vnp_TxnRef` (mã giao dịch, có thể là UUID thanh toán hoặc paymentCode sinh ra lúc tạo URL).
   - Kiểm tra số tiền `vnp_Amount` (chia cho 100).
   - Kiểm tra trạng thái giao dịch trong hệ thống xem đã xử lý chưa.
3. Nếu hợp lệ và `vnp_ResponseCode == "00"`:
   - Lưu giao dịch (có thể dùng bảng `bank_transaction` hoặc lưu thẳng `ThanhToan` và `HoaDon`).
   - Cập nhật hóa đơn.
   - Trả về mã `{"RspCode": "00", "Message": "Confirm Success"}` cho VNPay.
4. Nếu thất bại hoặc có lỗi, trả về mã lỗi tương ứng cho VNPay.

## 4. Cấu trúc và Database

### Cấu hình `application.properties`

```properties
# VNPay
vnpay.tmn-code=YOUR_TMN_CODE
vnpay.hash-secret=YOUR_HASH_SECRET
vnpay.url=https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
vnpay.api-url=https://sandbox.vnpayment.vn/merchant_webapi/api/transaction
vnpay.return-url=http://localhost:3000/thanh-toan/vnpay-return
```

### Database

Thực chất không cần thay đổi lớn vì đã có bảng `thanh_toan`.
Có thể thêm cột vào `thanh_toan` (tùy chọn) để lưu thông tin chi tiết:

```sql
ALTER TABLE public.thanh_toan
ADD COLUMN IF NOT EXISTS phuong_thuc varchar(50) DEFAULT 'TIEN_MAT', -- TIEN_MAT, CHUYEN_KHOAN, VNPAY
ADD COLUMN IF NOT EXISTS ma_giao_dich_gateway varchar(100); -- Lưu vnp_TransactionNo
```

## 5. Backend cần làm

### `VNPayConfig`

Lớp chứa các hàm tiện ích tạo chuỗi hash SHA-512 hoặc HMAC SHA-512 theo chuẩn VNPay, hàm tạo IP client, mã hóa URL.

### `VNPayService`

- `String createPaymentUrl(UUID hoaDonId, long amount, String bankCode, String ipAddress)`: Tạo URL redirect. (Lưu thông tin giao dịch tạm nếu cần, vnp_TxnRef = mã tự sinh kết hợp hoaDonId).
- `int processIpn(Map<String, String> fields)`: Hàm xử lý IPN. Nhận Map các tham số, tính checksum, tìm hóa đơn, thực hiện logic cộng tiền/chuyển trạng thái hóa đơn. Trả về mã lỗi để controller respond cho VNPay.

### `VNPayController`

```java
@RestController
@RequestMapping("/api/vnpay")
public class VNPayController {

    @GetMapping("/create-payment-url")
    public ApiResponse<String> createPaymentUrl(@RequestParam UUID hoaDonId, @RequestParam long amount, HttpServletRequest request) { ... }

    @GetMapping("/vnpay-ipn")
    public ResponseEntity<?> vnpayIpn(@RequestParam Map<String, String> queryParams) {
        // VNPay IPN endpoint thường là GET và respond bằng JSON code
        int resultCode = vnpayService.processIpn(queryParams);
        // Map resultCode sang {"RspCode": "00", "Message": "Confirm Success"} v.v.
    }
}
```

## 6. Frontend cần làm

- **Trang chi tiết hóa đơn (Public hoặc Dashboard)**: Hiển thị phương thức thanh toán. Thêm nút "Thanh toán qua VNPay". Nút này sẽ gọi API `/api/vnpay/create-payment-url`, lấy URL rồi `window.location.href = url`.
- **Trang `vnpay-return`**: Tạo một page ở Next.js `/thanh-toan/vnpay-return/page.tsx`. Nhận các tham số từ query string (vnp_ResponseCode), hiển thị giao diện báo "Thanh toán thành công" hay "Thanh toán thất bại" (do khách hủy hoặc thẻ lỗi). Kèm theo nút "Quay lại hóa đơn".

## 7. Checklist demo bảo vệ

1. **Chuẩn bị trước**: Lên trang VNPay Sandbox lấy test card (Ví dụ Ngân hàng NCB, Số thẻ 9704198526191432198, Tên NGUYEN VAN A, Ngày phát hành 07/15, OTP 123456). Khởi chạy ngrok nếu giáo viên muốn test IPN thật (Ngrok -> Localhost backend).
2. Mở một hóa đơn có trạng thái CHUA_THANH_TOAN.
3. Chọn "Thanh toán bằng VNPay".
4. Website redirect sang trang VNPay.
5. Nhập thông tin thẻ test NCB.
6. Xác nhận thanh toán. VNPay báo thành công và redirect về trang web báo "Thanh toán thành công".
7. (Backend đã nhận được IPN và xử lý âm thầm). Mở lại trang chi tiết hóa đơn hoặc dashboard quản lý, hóa đơn đã tự chuyển sang ĐÃ THANH TOÁN.

## 8. Rủi ro và Lưu ý

- Khi code local bằng `localhost`, VNPay không thể gọi IPN ngược về máy mình được trừ khi dùng **ngrok**. Trong quá trình test local, nếu không dùng ngrok, có thể test xử lý hóa đơn trong `vnpay-return` thay vì IPN (nhưng thực tế production không được làm vậy vì mất an toàn). Hoặc phải mock dữ liệu.
- Cần chú ý vnp_Amount của VNPay được nhân lên 100 lần (ví dụ 10.000 VNĐ thì tham số gửi đi là 1000000). Khi nhận về cũng phải chia 100.
- Checksum cần đúng thứ tự key sort theo alphabet và nối chuỗi chính xác theo doc của VNPay.
