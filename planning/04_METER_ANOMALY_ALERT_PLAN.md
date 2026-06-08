# P1 - Cảnh báo bất thường điện/nước

## 1. Mục tiêu

Tự phát hiện phòng có mức tiêu thụ điện/nước tăng hoặc giảm bất thường so với lịch sử, từ đó cảnh báo chủ trọ và khách thuê.

Giá trị khi bảo vệ:
- Chứng minh hệ thống không chỉ nhập số và tính tiền.
- Có phân tích thông minh từ dữ liệu vận hành.
- Dễ demo bằng một chỉ số tăng 300%.

## 2. Quy tắc nghiệp vụ đề xuất

Một chỉ số bị xem là bất thường nếu:
- Tiêu thụ tháng hiện tại > trung bình 3 tháng gần nhất * 2.5.
- Hoặc tiêu thụ tháng hiện tại tăng hơn 100 đơn vị điện hoặc 30 m3 nước so với tháng trước.
- Hoặc chỉ số mới < chỉ số cũ.
- Hoặc tiêu thụ = 0 trong khi phòng đang thuê và các tháng trước có tiêu thụ.

Mức cảnh báo:
- `LOW`: tăng 50-100%.
- `MEDIUM`: tăng 100-200%.
- `HIGH`: tăng >200% hoặc vượt ngưỡng tuyệt đối.

## 3. Database cần thêm

```sql
CREATE TABLE IF NOT EXISTS public.meter_anomaly_alert (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    chi_so_id uuid NOT NULL REFERENCES public.chi_so_dien_nuoc(id) ON DELETE CASCADE,
    phong_id uuid NOT NULL REFERENCES public.phong(id) ON DELETE CASCADE,
    hop_dong_id uuid NULL REFERENCES public.hop_dong(id) ON DELETE SET NULL,
    loai varchar(30) NOT NULL,
    ky_thang int NOT NULL,
    ky_nam int NOT NULL,
    tieu_thu_hien_tai int NOT NULL,
    tieu_thu_trung_binh numeric(12,2),
    ty_le_tang numeric(12,2),
    muc_do varchar(20) NOT NULL,
    ly_do text NOT NULL,
    trang_thai varchar(20) NOT NULL DEFAULT 'OPEN',
    resolved_at timestamptz NULL,
    resolved_by uuid NULL REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    tao_luc timestamptz NOT NULL DEFAULT now()
);
```

Status:
- `OPEN`
- `ACKNOWLEDGED`
- `RESOLVED`
- `IGNORED`

## 4. Backend cần thêm

Tạo `MeterAnomalyService`.

Method:
- `analyzeReading(UUID chiSoId)`
- `analyzePeriod(UUID nhaTroId, int kyThang, int kyNam)`
- `resolveAlert(UUID alertId, String action)`
- `getAlerts(...)`

Tích hợp:
- Sau khi tạo/cập nhật `ChiSoDienNuoc` trạng thái `CONFIRMED`, gọi analyze.
- Khi hóa đơn dùng chỉ số `BILLED`, vẫn giữ alert nếu chưa xử lý.
- Scheduler chạy hằng ngày để quét lại các chỉ số mới.

Controller:
- `GET /api/meter-alerts`
- `POST /api/meter-alerts/analyze`
- `PATCH /api/meter-alerts/{id}/resolve`

## 5. Frontend cần thêm

### Trong trang chỉ số điện/nước

- Badge cảnh báo cạnh bản ghi bất thường.
- Dialog xem lý do:
  - Tiêu thụ hiện tại.
  - Trung bình 3 tháng.
  - Tỷ lệ tăng.
  - Gợi ý kiểm tra rò rỉ/chập điện/nhập sai.

### Trong dashboard

- Card `Chỉ số bất thường`.
- Action item high priority.
- Link về bản ghi chỉ số.

## 6. Test cần viết

- Không cảnh báo nếu chưa đủ lịch sử và tiêu thụ bình thường.
- Cảnh báo HIGH khi tăng 300%.
- Cảnh báo khi chỉ số mới nhỏ hơn chỉ số cũ.
- Resolve alert không xóa lịch sử.
- Permission theo tòa/phòng.

## 7. Checklist triển khai

- [ ] Tạo migration alert table.
- [ ] Tạo entity/repository.
- [ ] Tạo DTO request/response.
- [ ] Tạo `MeterAnomalyService`.
- [ ] Tích hợp vào `ChiSoDienNuocService`.
- [ ] Thêm dashboard API action items.
- [ ] Thêm UI badge và dialog.
- [ ] Viết test.

## 8. Demo bảo vệ

1. Cho xem phòng 101 dùng điện 50 kWh các tháng trước.
2. Nhập tháng này 300 kWh.
3. Hệ thống báo HIGH anomaly.
4. Dashboard hiện cảnh báo.
5. Click vào cảnh báo để xem lý do.
6. Resolve sau khi kiểm tra.
