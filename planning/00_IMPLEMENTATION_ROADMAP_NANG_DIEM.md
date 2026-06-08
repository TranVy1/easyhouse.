# Roadmap nâng điểm đồ án EasyHouse

## Mục tiêu

Biến hệ thống từ mức "quản lý CRUD có nghiệp vụ rời rạc" thành một quy trình vận hành nhà trọ khép kín:

`Hợp đồng active -> Chốt chỉ số -> Tự sinh hóa đơn -> Gửi thông báo -> Thanh toán VietQR -> Tự gạch nợ -> Dashboard cảnh báo`

## Ưu tiên triển khai

| Ưu tiên | Hạng mục | Giá trị khi bảo vệ | Độ khó | File plan |
|---|---|---|---|---|
| P0 | Tự động sinh hóa đơn hàng tháng | Chứng minh hệ thống có nghiệp vụ lõi thật, không chỉ CRUD | Cao | `01_AUTO_MONTHLY_INVOICE_PLAN.md` |
| P0 | VietQR auto-reconciliation | Điểm nhấn tài chính/automation, demo rõ ràng | Cao | `02_VIETQR_AUTO_RECONCILIATION_PLAN.md` |
| P0 | Dashboard analytics chuyên nghiệp | Làm sản phẩm nhìn "production-like" khi demo | Trung bình | `03_DASHBOARD_ANALYTICS_PLAN.md` |
| P1 | Cảnh báo bất thường điện/nước | Có phân tích thông minh, dễ gây ấn tượng | Trung bình | `04_METER_ANOMALY_ALERT_PLAN.md` |
| P1 | Đặt cọc/giữ phòng | Bổ sung nghiệp vụ thực tế trước hợp đồng | Trung bình | `05_DEPOSIT_ROOM_BOOKING_PLAN.md` |
| P1 | Nhắc nợ tự động nhiều cấp | Hoàn thiện quy trình thu tiền | Trung bình | `06_DEBT_REMINDER_AUTOMATION_PLAN.md` |
| P2 | Hợp đồng PDF/ký xác nhận | Tăng tính thực tế, nhưng không cấp thiết bằng hóa đơn/thanh toán | Cao | `07_CONTRACT_PDF_ESIGN_PLAN.md` |

## Lộ trình 4 tuần đề xuất

### Tuần 1: Hoàn thiện lõi hóa đơn tự động

Mục tiêu:
- Có thể bấm "Sinh hóa đơn tháng này" và hệ thống tạo hóa đơn đúng cho các hợp đồng active.
- Có preview trước khi sinh.
- Không sinh trùng hóa đơn cùng hợp đồng/kỳ.

Công việc:
- Implement `InvoiceGenerationService`.
- Tạo API preview và generate.
- Reuse `HoaDonService.create`.
- Thêm log sinh hóa đơn.
- Viết test cho case hợp đồng active, thiếu chỉ số, trùng kỳ.
- Demo được flow từ hợp đồng -> hóa đơn.

Kết quả cần có:
- Màn hình hoặc nút thao tác trong `/dashboard/hoa-don`.
- Backend test pass.
- Seed/demo data có ít nhất 2 hợp đồng active và chỉ số tháng hiện tại.

### Tuần 2: VietQR tự động gạch nợ

Mục tiêu:
- Mỗi hóa đơn có mã thanh toán riêng.
- Webhook/simulator nhận giao dịch bank và tự tạo thanh toán.
- Dashboard/đối soát hiển thị giao dịch matched/unmatched/conflict.

Công việc:
- Thêm `payment_code` vào hóa đơn.
- Tạo `ReconciliationService`.
- Tạo endpoint webhook/simulator.
- Nâng cấp `bank_transaction`.
- Update trang hóa đơn public để QR dùng `paymentCode`.
- Viết test auto match, partial payment, overpaid, duplicate transaction.

Kết quả cần có:
- Demo nhập payload giao dịch giả -> hóa đơn chuyển trạng thái đã thanh toán.
- Màn hình đối soát vẫn cho manual match nếu không tự match được.

### Tuần 3: Dashboard analytics

Mục tiêu:
- Dashboard trả lời được 3 câu hỏi: tháng này thu được bao nhiêu, còn ai nợ, việc gì cần xử lý hôm nay.

Công việc:
- Tạo `DashboardAnalyticsService`.
- API revenue chart 12 tháng, debt aging, action items, occupancy by building.
- Frontend thêm biểu đồ Recharts.
- Fix KPI không còn tính "trên trang" cho các số tổng quan chính.

Kết quả cần có:
- Dashboard có biểu đồ doanh thu, công nợ quá hạn, top phòng nợ cao, cảnh báo hợp đồng/hóa đơn/sự cố.

### Tuần 4: Hoàn thiện điểm cộng

Mục tiêu:
- Bổ sung các điểm chứng minh hệ thống thực tế và thông minh.

Công việc:
- Cảnh báo bất thường điện/nước.
- Đặt cọc/giữ phòng.
- Nhắc nợ tự động nhiều cấp.
- Chuẩn bị script demo và checklist bảo vệ.

Kết quả cần có:
- Có checklist demo end-to-end.
- Có dữ liệu mẫu thể hiện cảnh báo và công nợ.

## Quy tắc triển khai chung

### Backend

- Không expose JPA entity trực tiếp từ controller mới.
- Luồng chuẩn: Request DTO -> Service -> Entity -> Response DTO.
- Service phải giữ transaction boundary.
- Mọi thay đổi hóa đơn/thanh toán phải cập nhật `daTra`, `trangThai`, audit log.
- Mọi endpoint frontend gọi qua `/api/...` phải có rewrite trong `frontend/next.config.ts`.
- Với status enum, kiểm tra đủ: SQL enum, Java enum, DTO, frontend type, UI label.

### Frontend

- Ưu tiên reuse pattern hiện có trong dashboard:
  - `DashboardPageHeader`
  - `MetricCard`
  - `EmptyState`
  - `ErrorState`
  - Radix dialog/select/table
  - Recharts cho biểu đồ
- Không tính aggregate lớn ở frontend nếu backend có thể trả.
- Với số tiền, luôn dùng `Intl.NumberFormat("vi-VN", { currency: "VND" })`.

### Database

- Mọi migration mới đặt trong `sql/migrations`.
- Nếu thêm column/table, cập nhật `sql/schema.sql` hoặc dump theo quy trình dự án.
- Nếu phục hồi local Docker DB, dùng full dump `sql/db.sql`, không restore partial.

### Test

P0 bắt buộc có test backend:
- Hóa đơn tự động.
- Reconciliation thanh toán.
- Dashboard aggregate.

P1 nên có test:
- Cảnh báo điện/nước.
- Đặt cọc/giữ phòng.
- Nhắc nợ.

## Checklist demo bảo vệ

1. Tạo tòa nhà và sinh phòng hàng loạt.
2. Tạo khách thuê.
3. Tạo hợp đồng active cho phòng.
4. Ghi/chốt chỉ số điện nước.
5. Sinh hóa đơn tháng tự động.
6. Mở hóa đơn public có VietQR.
7. Gửi payload giao dịch bank giả.
8. Hóa đơn tự chuyển đã thanh toán.
9. Dashboard cập nhật doanh thu, công nợ, action items.
10. Cho xem audit log và thông báo.

## Định nghĩa hoàn thành

Một hạng mục chỉ được xem là xong khi:
- Có DB/API/backend/frontend tương ứng.
- Có test hoặc checklist manual rõ ràng.
- Có dữ liệu demo.
- Có thể trình bày nghiệp vụ trong 1-2 phút khi bảo vệ.
- Không phá vỡ flow hợp đồng, hóa đơn, thanh toán hiện có.
