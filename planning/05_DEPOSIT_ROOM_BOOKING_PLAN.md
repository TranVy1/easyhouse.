# P1 - Đặt cọc và giữ phòng

## 1. Vấn đề hiện tại

Database đã có `dat_coc_phong`, hệ thống có public room listing và lịch hẹn. Tuy nhiên flow thực tế trước khi ký hợp đồng còn thiếu:

`Khách xem phòng -> đặt cọc -> giữ phòng -> chuyển thành hợp đồng`

Nếu thiếu flow này, hệ thống giống phần mềm quản lý nội bộ sau khi khách đã thuê, chưa bao phủ nghiệp vụ tìm khách và giữ phòng.

## 2. Mục tiêu nghiệp vụ

Cho phép chủ trọ ghi nhận đặt cọc hoặc khách đặt cọc sau khi xem phòng. Khi đặt cọc thành công:
- Phòng chuyển `RESERVED`.
- Không cho tạo hợp đồng active khác đè lên.
- Sau khi ký hợp đồng, liên kết đặt cọc vào hợp đồng.
- Nếu hủy cọc, phòng quay lại `AVAILABLE` nếu không có hợp đồng khác.

## 3. Status đề xuất

`TrangThaiDatCoc`:
- `PENDING`: chờ xác nhận.
- `CONFIRMED`: đã nhận cọc, giữ phòng.
- `CONVERTED`: đã chuyển thành hợp đồng.
- `CANCELLED`: đã hủy.
- `REFUNDED`: đã hoàn cọc.
- `FORFEITED`: mất cọc.

## 4. Flow xử lý

### Flow chủ trọ tạo đặt cọc

1. Chủ trọ chọn phòng trống.
2. Chọn khách thuê hoặc nhập khách mới.
3. Nhập số tiền cọc, ngày dự kiến vào ở.
4. Tạo đặt cọc `CONFIRMED`.
5. Phòng chuyển `RESERVED`.

### Flow chuyển thành hợp đồng

1. Từ đặt cọc, bấm "Tạo hợp đồng".
2. Form hợp đồng tự điền phòng, khách, tiền cọc.
3. Confirm hợp đồng.
4. Đặt cọc chuyển `CONVERTED`.
5. Phòng chuyển `RENTED`.

### Flow hủy/hoàn cọc

1. Chủ trọ chọn hủy cọc.
2. Chọn lý do và trạng thái tiền:
   - hoàn cọc
   - mất cọc
3. Phòng quay lại trống nếu không có hợp đồng/đặt cọc khác.

## 5. Database cần kiểm tra/thêm

Bảng `dat_coc_phong` đã có trong SQL. Cần kiểm tra đủ cột:
- `phong_id`
- `khach_thue_id`
- `hop_dong_id`
- `so_tien_coc`
- `ngay_dat_coc`
- `ngay_du_kien_vao`
- `trang_thai`
- `ghi_chu`

Nên thêm:

```sql
ALTER TABLE public.dat_coc_phong
ADD COLUMN IF NOT EXISTS ly_do_huy text,
ADD COLUMN IF NOT EXISTS confirmed_at timestamptz,
ADD COLUMN IF NOT EXISTS cancelled_at timestamptz,
ADD COLUMN IF NOT EXISTS nguoi_xac_nhan_id uuid NULL REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;
```

## 6. Backend cần thêm

Entity:
- `DatCocPhong`

Repository:
- `DatCocPhongRepository`

Service:
- `DatCocPhongService`

Controller:
- `GET /api/dat-coc`
- `GET /api/dat-coc/{id}`
- `POST /api/dat-coc`
- `PATCH /api/dat-coc/{id}/confirm`
- `PATCH /api/dat-coc/{id}/cancel`
- `POST /api/dat-coc/{id}/convert-to-contract`

DTO:
- `DatCocPhongRequest`
- `DatCocPhongResponse`
- `CancelDatCocRequest`
- `ConvertDatCocRequest`

Business rules:
- Chỉ đặt cọc phòng `AVAILABLE`.
- Một phòng chỉ có một đặt cọc `PENDING` hoặc `CONFIRMED`.
- Không cho xóa vật lý, chỉ đổi trạng thái.
- Khi confirm cọc, sync room status `RESERVED`.
- Khi convert hợp đồng, phải dùng lại logic `HopDongService.create/confirm`.

## 7. Frontend cần thêm

Route:
- `/dashboard/dat-coc`

Trong sidebar:
- Nhóm `Tài sản & cư trú` hoặc `Chăm sóc`.

Màn hình:
- Danh sách đặt cọc.
- Filter status.
- Button tạo đặt cọc.
- Action confirm/cancel/convert.

Trong trang public phòng:
- Có thể thêm CTA "Đặt lịch xem phòng" trước, chưa cần thanh toán online cọc nếu muốn giảm scope.

## 8. Test cần viết

- Tạo cọc cho phòng trống thành công.
- Không tạo cọc cho phòng đang thuê.
- Confirm cọc đổi phòng sang `RESERVED`.
- Cancel cọc đổi phòng về `AVAILABLE`.
- Convert cọc tạo hợp đồng và đổi status `CONVERTED`.
- Permission theo chủ trọ/tòa.

## 9. Checklist triển khai

- [ ] Kiểm tra enum SQL và Java.
- [ ] Tạo entity/repository/service/controller.
- [ ] Tạo DTO.
- [ ] Tích hợp sync room status.
- [ ] Thêm route frontend.
- [ ] Thêm form/dialog.
- [ ] Thêm action convert hợp đồng.
- [ ] Viết test.

## 10. Demo bảo vệ

1. Mở phòng trống.
2. Tạo đặt cọc cho khách.
3. Phòng chuyển sang đã đặt.
4. Tạo hợp đồng từ đặt cọc.
5. Confirm hợp đồng.
6. Phòng chuyển sang đang thuê.
