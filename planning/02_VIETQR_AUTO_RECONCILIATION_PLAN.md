# P0 - VietQR tự động đối soát và gạch nợ

## 1. Vấn đề hiện tại

Hệ thống đã có:
- QR public trên trang hóa đơn.
- Bảng `bank_transaction`.
- Màn hình `/dashboard/vietqr-doi-soat`.
- API manual match `/api/bank-transaction/manual-match`.
- `ThanhToanService.recordBankTransactionMatch`.

Nhưng đây vẫn là đối soát thủ công. Nếu bảo vệ nói "VietQR tự động" mà demo chỉ chọn giao dịch rồi chọn hóa đơn thì giáo viên sẽ xem là chưa hoàn chỉnh.

## 2. Mục tiêu nghiệp vụ

Khi khách chuyển khoản đúng nội dung, hệ thống tự:
- Nhận giao dịch ngân hàng.
- Tìm hóa đơn tương ứng.
- Tạo thanh toán.
- Cập nhật trạng thái hóa đơn.
- Đánh dấu giao dịch đã đối soát.

Manual match chỉ là fallback cho giao dịch sai nội dung hoặc conflict.

## 3. Flow xử lý

### Flow tạo mã thanh toán

1. Khi tạo hóa đơn, backend sinh `paymentCode`, ví dụ `EH-HD202606-ABC123`.
2. Trang hóa đơn public hiển thị VietQR với:
   - `amount = hoaDon.conLai`
   - `addInfo = paymentCode`
3. Khách chuyển khoản theo QR.

### Flow webhook/simulator

1. Ngân hàng/webhook gửi payload vào `POST /api/webhooks/bank-transactions`.
2. Backend validate chữ ký hoặc secret header.
3. Lưu raw payload vào `bank_transaction`.
4. Gọi `ReconciliationService.autoMatch`.
5. Nếu match chính xác:
   - Tạo `ThanhToan`.
   - Cập nhật `HoaDon`.
   - `bank_transaction.daDoiSoat = true`.
   - `matchStatus = AUTO_MATCHED`.
6. Nếu không match:
   - `matchStatus = UNMATCHED`.
   - Hiện ở màn hình đối soát.
7. Nếu nhiều hóa đơn cùng khả năng match:
   - `matchStatus = CONFLICT`.
   - Admin xử lý thủ công.

## 4. Database cần thêm

### Hóa đơn

```sql
ALTER TABLE public.hoa_don
ADD COLUMN IF NOT EXISTS payment_code varchar(80);

CREATE UNIQUE INDEX IF NOT EXISTS uk_hoa_don_payment_code
ON public.hoa_don(payment_code)
WHERE payment_code IS NOT NULL;
```

### Bank transaction

```sql
ALTER TABLE public.bank_transaction
ADD COLUMN IF NOT EXISTS match_status varchar(30) NOT NULL DEFAULT 'UNMATCHED',
ADD COLUMN IF NOT EXISTS matched_at timestamptz,
ADD COLUMN IF NOT EXISTS match_reason text,
ADD COLUMN IF NOT EXISTS raw_payload jsonb;
```

Status đề xuất:
- `UNMATCHED`
- `AUTO_MATCHED`
- `MANUAL_MATCHED`
- `CONFLICT`
- `IGNORED`

### Reconciliation log

```sql
CREATE TABLE IF NOT EXISTS public.payment_reconciliation_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    bank_transaction_id uuid NOT NULL REFERENCES public.bank_transaction(id) ON DELETE CASCADE,
    hoa_don_id uuid NULL REFERENCES public.hoa_don(id) ON DELETE SET NULL,
    action varchar(50) NOT NULL,
    confidence numeric(5,2) NULL,
    reason text NULL,
    nguoi_thuc_hien_id uuid NULL REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    tao_luc timestamptz NOT NULL DEFAULT now()
);
```

## 5. Backend cần thêm

### DTO webhook

`BankWebhookRequest`
- `String transactionId`
- `String accountNumber`
- `BigDecimal amount`
- `String description`
- `String bankCode`
- `ZonedDateTime transactionTime`
- `Map<String, Object> rawPayload`

`BankWebhookResponse`
- `bankTransactionId`
- `matchStatus`
- `hoaDonId`
- `thanhToanId`
- `message`

### Service

Tạo `ReconciliationService`.

Method:
- `receiveBankTransaction(BankWebhookRequest request)`
- `autoMatch(BankTransaction transaction)`
- `findByPaymentCode(String description)`
- `matchByAmountAndTenantFallback(BankTransaction transaction)`
- `markConflict(BankTransaction transaction, List<HoaDon> candidates)`
- `manualMatch(UUID transactionId, UUID hoaDonId)`

### Matching rules

Ưu tiên 1: match payment code
- Extract regex `EH-[A-Z0-9-]+` hoặc `HD...`.
- Tìm `hoa_don.payment_code`.
- Nếu amount <= conLai hoặc cho phép overpaid thì match.

Ưu tiên 2: match mã hóa đơn
- Extract `maHoaDon`.
- Tìm hóa đơn chưa thanh toán.

Ưu tiên 3: fallback
- Cùng nhà trọ.
- Số tiền bằng `conLai`.
- Giao dịch trong khoảng gần hạn trả.
- Nếu chỉ có 1 ứng viên thì auto match confidence thấp hơn.

Không auto match nếu:
- Giao dịch đã tồn tại theo `ma_giao_dich`.
- Hóa đơn đã `PAID` hoặc `CANCELLED`.
- Có nhiều ứng viên cùng điểm.
- Số tiền âm hoặc bằng 0.

### Controller

Tạo `BankWebhookController`:

```java
@PostMapping("/api/webhooks/bank-transactions")
public ApiResponse<BankWebhookResponse> receive(...)
```

Cập nhật `BankTransactionController`:
- `POST /api/bank-transaction/{id}/retry-match`
- `POST /api/bank-transaction/{id}/ignore`
- giữ `manual-match`.

## 6. Frontend cần thêm

### Trang hóa đơn public

Cập nhật QR:
- Không hardcode `addInfo=Thanh toan {maHoaDon}`.
- Dùng `paymentCode`.
- Hiển thị rõ nội dung chuyển khoản bắt buộc.

### Màn hình đối soát VietQR

Thêm cột:
- Match status.
- Hóa đơn matched.
- Lý do match.
- Thời gian matched.

Thêm filter:
- Chưa match.
- Auto matched.
- Conflict.
- Manual matched.

Thêm action:
- Retry auto match.
- Manual match.
- Ignore.

### Simulator cho demo

Trong môi trường đồ án nên thêm một dialog "Mô phỏng webhook":
- Chọn hóa đơn.
- Tự điền số tiền và payment code.
- Bấm "Gửi giao dịch giả".
- Gọi endpoint webhook.

Điều này giúp demo không phụ thuộc ngân hàng thật.

## 7. Test cần viết

Backend:
- Nhận webhook tạo `bank_transaction`.
- Payment code đúng -> tạo thanh toán.
- Giao dịch trùng `transactionId` -> không tạo thanh toán lần 2.
- Số tiền nhỏ hơn còn nợ -> hóa đơn `PARTIAL`.
- Số tiền bằng còn nợ -> hóa đơn `PAID`.
- Số tiền lớn hơn còn nợ -> hóa đơn `OVERPAID`.
- Sai nội dung -> `UNMATCHED`.
- Nhiều ứng viên -> `CONFLICT`.
- Manual match vẫn hoạt động.

Frontend/manual:
- QR hiển thị đúng nội dung.
- Simulator tạo giao dịch và dashboard cập nhật.
- Trang đối soát lọc được giao dịch unmatched/conflict.

## 8. Checklist triển khai

- [ ] Thêm migration `payment_code`, `match_status`, log table.
- [ ] Khi tạo hóa đơn, sinh `paymentCode`.
- [ ] Update `HoaDonResponse`.
- [ ] Update frontend type `HoaDon`.
- [ ] Update QR public invoice.
- [ ] Tạo `BankWebhookController`.
- [ ] Tạo `ReconciliationService`.
- [ ] Refactor manual match dùng chung service.
- [ ] Update màn hình VietQR.
- [ ] Thêm simulator demo.
- [ ] Viết test backend.

## 9. Demo bảo vệ

Kịch bản:
1. Mở hóa đơn chưa thanh toán.
2. Cho xem QR có nội dung `paymentCode`.
3. Mở simulator webhook.
4. Gửi giao dịch số tiền đúng.
5. Hệ thống tự tạo thanh toán.
6. Hóa đơn chuyển `PAID`.
7. Màn hình VietQR hiện `AUTO_MATCHED`.
8. Dashboard doanh thu tăng, công nợ giảm.

## 10. Rủi ro

- Không nên auto match nếu không có payment code và nhiều hóa đơn cùng số tiền.
- Cần chống duplicate webhook.
- Không nên rollback transaction vì lỗi gửi email.
- Nếu hardcode tài khoản ngân hàng trong frontend, cần đưa vào cấu hình tòa nhà/chủ trọ sau.
