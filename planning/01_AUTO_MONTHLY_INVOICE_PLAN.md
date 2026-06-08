# P0 - Tự động sinh hóa đơn hàng tháng

## 1. Vấn đề hiện tại

Hệ thống đã có `HoaDonService.create`, `ChiSoDienNuocService`, `CauHinhGiaService`, hợp đồng active và scheduler nhắc hạn. Tuy nhiên quy trình lập hóa đơn vẫn chủ yếu do người dùng thao tác thủ công.

Điểm yếu khi bảo vệ:
- Giáo viên dễ hỏi: "Mỗi tháng có 100 phòng thì có phải tạo 100 hóa đơn bằng tay không?"
- Có function DB `tao_lich_thanh_toan_hang_thang`, nhưng chưa có luồng rõ ràng từ lịch thanh toán sang hóa đơn.
- Dashboard có số liệu nhưng chưa chứng minh được automation tạo doanh thu.

## 2. Mục tiêu nghiệp vụ

Chủ trọ chọn kỳ tháng/năm, hệ thống tự tìm các hợp đồng đang hoạt động và sinh hóa đơn đúng theo dữ liệu hiện có.

Quy tắc:
- Chỉ sinh hóa đơn cho hợp đồng `ACTIVE`.
- Không sinh trùng nếu hợp đồng đã có hóa đơn cùng `kyThang`, `kyNam`.
- Tiền phòng lấy từ `hop_dong.giaThueHopDong`.
- Dịch vụ lấy từ `dich_vu_hop_dong`.
- Điện/nước lấy từ `chi_so_dien_nuoc` trạng thái `CONFIRMED` hoặc từ form fallback nếu chưa chốt.
- Cấu hình giá lấy từ `cau_hinh_gia` đang hiệu lực.
- Công nợ kỳ trước cộng vào `soDuDauKy`.
- Hóa đơn mới ở trạng thái `UNPAID` sau khi có dòng tiền phát sinh.

## 3. Flow xử lý

### Flow preview

1. User vào `/dashboard/hoa-don`.
2. Chọn "Sinh hóa đơn tháng".
3. Chọn tháng/năm/tòa nhà.
4. Frontend gọi `GET /api/hoa-don/generation-preview`.
5. Backend trả danh sách:
   - Hợp đồng đủ điều kiện.
   - Hợp đồng bị bỏ qua vì đã có hóa đơn.
   - Hợp đồng thiếu chỉ số điện/nước.
   - Tổng tiền dự kiến.
6. User xác nhận.

### Flow generate

1. Frontend gọi `POST /api/hoa-don/generate-monthly`.
2. Backend tạo hóa đơn cho từng hợp đồng hợp lệ.
3. Ghi log cho từng kết quả.
4. Publish `InvoiceCreatedEvent`.
5. Gửi email/in-app notification.
6. Trả summary: số hóa đơn tạo thành công, bỏ qua, lỗi.

## 4. Database cần thêm

### Option tối thiểu

Thêm cột vào `hoa_don`:

```sql
ALTER TABLE public.hoa_don
ADD COLUMN IF NOT EXISTS auto_generated boolean DEFAULT false,
ADD COLUMN IF NOT EXISTS generation_batch_id uuid,
ADD COLUMN IF NOT EXISTS source_schedule_id uuid;
```

### Nên thêm log batch

```sql
CREATE TABLE IF NOT EXISTS public.invoice_generation_batch (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nha_tro_id uuid NULL REFERENCES public.nha_tro(id) ON DELETE SET NULL,
    ky_thang int NOT NULL,
    ky_nam int NOT NULL,
    trang_thai varchar(30) NOT NULL DEFAULT 'COMPLETED',
    tong_hop_dong int NOT NULL DEFAULT 0,
    tao_thanh_cong int NOT NULL DEFAULT 0,
    bo_qua int NOT NULL DEFAULT 0,
    loi int NOT NULL DEFAULT 0,
    nguoi_tao_id uuid NULL REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    tao_luc timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.invoice_generation_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_id uuid NOT NULL REFERENCES public.invoice_generation_batch(id) ON DELETE CASCADE,
    hop_dong_id uuid NULL REFERENCES public.hop_dong(id) ON DELETE SET NULL,
    hoa_don_id uuid NULL REFERENCES public.hoa_don(id) ON DELETE SET NULL,
    status varchar(30) NOT NULL,
    reason text NULL,
    tao_luc timestamptz NOT NULL DEFAULT now()
);
```

## 5. Backend cần thêm

### DTO

`InvoiceGenerationPreviewRequest`
- `UUID nhaTroId`
- `Integer kyThang`
- `Integer kyNam`
- `Boolean requireConfirmedReadings`

`InvoiceGenerationPreviewResponse`
- `kyThang`
- `kyNam`
- `List<InvoiceCandidateResponse> candidates`
- `summary`

`InvoiceCandidateResponse`
- `hopDongId`
- `maHopDong`
- `phongId`
- `maPhong`
- `khachThueId`
- `tenKhachThue`
- `status`: `READY`, `EXISTS`, `MISSING_READING`, `INVALID_CONTRACT`
- `estimatedAmount`
- `warnings`

`InvoiceGenerationRequest`
- giống preview request
- `Boolean sendNotification`
- `Boolean skipMissingReadings`

`InvoiceGenerationResultResponse`
- `batchId`
- `createdCount`
- `skippedCount`
- `errorCount`
- `createdInvoices`
- `logs`

### Service

Tạo `InvoiceGenerationService`.

Method:
- `preview(UUID nhaTroId, int kyThang, int kyNam, boolean requireConfirmedReadings)`
- `generate(InvoiceGenerationRequest request)`
- `buildRequestFromContract(HopDong hopDong, int kyThang, int kyNam)`
- `validateCandidate(HopDong hopDong, int kyThang, int kyNam)`

Nguyên tắc:
- Không copy logic tính tiền hóa đơn quá nhiều.
- Ưu tiên build `HoaDonRequest` rồi gọi `HoaDonService.create`.
- Nếu cần hàm nội bộ trong `HoaDonService`, extract phần tính line items thành method reusable.

### Controller

Thêm vào `HoaDonController`:

```java
@GetMapping("/generation-preview")
public ResponseEntity<ApiResponse<InvoiceGenerationPreviewResponse>> preview(...)

@PostMapping("/generate-monthly")
public ResponseEntity<ApiResponse<InvoiceGenerationResultResponse>> generate(...)
```

## 6. Frontend cần thêm

### Trang/màn hình

Trong `/dashboard/hoa-don`:
- Button `Sinh hóa đơn tháng`.
- Dialog chọn:
  - Tòa nhà
  - Tháng
  - Năm
  - Checkbox "Chỉ sinh khi đã chốt đủ chỉ số"
  - Checkbox "Gửi thông báo sau khi sinh"

### Preview UI

Bảng preview:
- Phòng
- Khách thuê
- Hợp đồng
- Trạng thái
- Tổng tiền dự kiến
- Cảnh báo

CTA:
- `Xác nhận sinh hóa đơn`
- `Bỏ qua`

### Sau khi generate

Hiển thị summary:
- Đã tạo bao nhiêu hóa đơn.
- Bỏ qua bao nhiêu vì đã tồn tại.
- Bao nhiêu lỗi.
- Link mở danh sách hóa đơn kỳ đó.

## 7. Test cần viết

Backend unit/integration:
- Sinh hóa đơn thành công cho hợp đồng active.
- Không sinh trùng hóa đơn cùng kỳ.
- Bỏ qua hợp đồng `DRAFT`, `TERMINATED`, `CANCELLED`.
- Thiếu chỉ số điện/nước thì warning hoặc skip tùy option.
- Có công nợ kỳ trước thì cộng vào `soDuDauKy`.
- Hóa đơn sinh ra có chi tiết tiền phòng/dịch vụ/điện/nước đúng.
- Sinh hóa đơn ghi audit/log.

Frontend/manual:
- Preview hiển thị đúng status.
- Confirm tạo hóa đơn.
- Refresh danh sách thấy hóa đơn mới.
- Hóa đơn public mở được QR.

## 8. Checklist triển khai

- [ ] Tạo migration DB.
- [ ] Tạo DTO preview/result.
- [ ] Tạo repository/log entity nếu dùng log table.
- [ ] Tạo `InvoiceGenerationService`.
- [ ] Thêm endpoint preview.
- [ ] Thêm endpoint generate.
- [ ] Cập nhật `frontend/next.config.ts` nếu route mới chưa được proxy.
- [ ] Thêm dialog frontend.
- [ ] Thêm bảng preview.
- [ ] Thêm toast và error state.
- [ ] Viết backend tests.
- [ ] Chuẩn bị seed demo.

## 9. Demo bảo vệ

Kịch bản:
1. Mở hợp đồng active phòng 101.
2. Mở chỉ số điện/nước tháng hiện tại đã chốt.
3. Vào hóa đơn, bấm "Sinh hóa đơn tháng".
4. Cho giáo viên xem preview: phòng nào ready, phòng nào thiếu chỉ số.
5. Bấm generate.
6. Mở hóa đơn mới, chỉ ra các dòng tiền phòng/điện/nước/dịch vụ.
7. Mở dashboard thấy tiền chưa thu tăng.

## 10. Rủi ro

- Dễ sinh trùng hóa đơn nếu không check `hopDongId + kyThang + kyNam`.
- Nếu đọc chỉ số từ `ChiTietHoaDon.moTa` cũ thì dễ sai; nên ưu tiên bảng `chi_so_dien_nuoc`.
- Nếu một phòng có nhiều hợp đồng active do dữ liệu lỗi, phải skip và cảnh báo.
- Nếu auto gửi email lỗi, không được rollback hóa đơn.
