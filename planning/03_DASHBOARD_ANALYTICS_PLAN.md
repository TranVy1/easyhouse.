# P0 - Dashboard analytics chuyên nghiệp

## 1. Vấn đề hiện tại

Dashboard hiện có các KPI cơ bản:
- Tổng phòng.
- Phòng trống/đang thuê/bảo trì.
- Doanh thu tháng/năm.
- Tiền chưa thu.
- Hóa đơn sắp đến hạn.
- Sự cố cần xử lý.
- Hợp đồng sắp hết hạn.

Trang báo cáo có biểu đồ doanh thu 6 tháng. Tuy nhiên:
- Dashboard chưa có drill-down.
- Một số màn hình frontend ghi rõ KPI "trên trang", không phải tổng hệ thống.
- Thiếu công nợ aging.
- Thiếu top phòng/khách cần thu.
- Thiếu cảnh báo bất thường.
- Thiếu phân tích theo tòa nhà.

## 2. Mục tiêu nghiệp vụ

Dashboard phải giúp chủ trọ trả lời nhanh:
1. Tháng này phải thu bao nhiêu, đã thu bao nhiêu, còn thiếu bao nhiêu?
2. Ai đang nợ nhiều nhất?
3. Hóa đơn nào quá hạn?
4. Hợp đồng nào sắp hết hạn?
5. Tòa/phòng nào vận hành kém?
6. Sự cố nào cần xử lý hôm nay?

## 3. Dashboard mới đề xuất

### Khu KPI tổng quan

- Tổng doanh thu phải thu tháng này.
- Đã thu tháng này.
- Còn phải thu.
- Tỷ lệ thu tiền.
- Tỷ lệ lấp đầy.
- Số hóa đơn quá hạn.
- Sự cố đang mở.
- Hợp đồng sắp hết hạn.

### Khu biểu đồ

- Doanh thu 12 tháng: phải thu vs đã thu.
- Công nợ aging:
  - Chưa quá hạn.
  - Quá hạn 1-7 ngày.
  - Quá hạn 8-15 ngày.
  - Quá hạn 16-30 ngày.
  - Quá hạn >30 ngày.
- Tỷ lệ lấp đầy theo tòa nhà.
- Sự cố theo trạng thái/độ ưu tiên.

### Khu action items

Danh sách việc cần làm:
- Hóa đơn quá hạn cần nhắc.
- Hóa đơn sắp đến hạn trong 2 ngày.
- Hợp đồng sắp hết hạn trong 30 ngày.
- Sự cố ưu tiên cao chưa xử lý.
- Chỉ số điện/nước bất thường.

### Khu top list

- Top 5 phòng nợ cao nhất.
- Top 5 khách thuê nợ lâu nhất.
- Top 5 phòng tiêu thụ điện/nước tăng mạnh.
- Top tòa nhà có tỷ lệ trống cao.

## 4. API cần thêm

### `GET /api/dashboard/overview`

Response:
- `totalRooms`
- `occupiedRooms`
- `availableRooms`
- `occupancyRate`
- `expectedRevenueThisMonth`
- `collectedThisMonth`
- `outstandingThisMonth`
- `collectionRate`
- `overdueInvoiceCount`
- `openIncidentCount`
- `expiringContractCount`

### `GET /api/dashboard/revenue-chart?months=12&nhaTroId=`

Response item:
- `month`
- `year`
- `label`
- `expectedRevenue`
- `collectedRevenue`
- `outstanding`

### `GET /api/dashboard/debt-aging?nhaTroId=`

Response:
- `notDue`
- `overdue1To7`
- `overdue8To15`
- `overdue16To30`
- `overdueOver30`
- `totalOutstanding`

### `GET /api/dashboard/action-items?nhaTroId=&limit=20`

Response item:
- `type`: `OVERDUE_INVOICE`, `UPCOMING_INVOICE`, `EXPIRING_CONTRACT`, `OPEN_INCIDENT`, `METER_ANOMALY`
- `priority`: `HIGH`, `MEDIUM`, `LOW`
- `title`
- `description`
- `amount`
- `dueDate`
- `href`
- `entityId`

### `GET /api/dashboard/top-debtors?nhaTroId=&limit=5`

Response item:
- `phongId`
- `maPhong`
- `khachThueId`
- `tenKhachThue`
- `soDienThoai`
- `tongNo`
- `noQuaHan`
- `oldestDueDate`
- `invoiceCount`

### `GET /api/dashboard/building-performance`

Response item:
- `nhaTroId`
- `tenToaNha`
- `tongPhong`
- `phongDangThue`
- `occupancyRate`
- `expectedRevenue`
- `collectedRevenue`
- `outstanding`
- `openIncidentCount`

## 5. Backend cần thêm

Tạo `DashboardAnalyticsService`.

Method:
- `getOverview(UUID nhaTroId)`
- `getRevenueChart(int months, UUID nhaTroId)`
- `getDebtAging(UUID nhaTroId)`
- `getActionItems(UUID nhaTroId, int limit)`
- `getTopDebtors(UUID nhaTroId, int limit)`
- `getBuildingPerformance()`

Repository query nên aggregate ở DB, không lấy toàn bộ rồi stream nếu dữ liệu lớn.

Nên tạo projection DTO:
- `RevenueMonthlyProjection`
- `DebtAgingProjection`
- `TopDebtorProjection`
- `BuildingPerformanceProjection`

## 6. Frontend cần thêm

### Dashboard `/dashboard`

Layout đề xuất:
1. Header + filter tòa nhà.
2. KPI cards 4-8 cards.
3. Row biểu đồ:
   - Revenue line/bar chart.
   - Debt aging donut/bar chart.
4. Row vận hành:
   - Action items.
   - Top debtors.
5. Row phân tích:
   - Building performance table.
   - Incident summary.

Component nên tạo:
- `RevenueTrendChart`
- `DebtAgingChart`
- `ActionItemsPanel`
- `TopDebtorsTable`
- `BuildingPerformanceTable`

## 7. Database/view đề xuất

Có thể tạo view:

```sql
CREATE OR REPLACE VIEW public.v_dashboard_invoice_monthly AS
SELECT
  date_trunc('month', make_date(ky_nam, ky_thang, 1))::date AS month_start,
  ky_nam,
  ky_thang,
  p.nha_tro_id,
  sum(hd.tong_tien) AS expected_revenue,
  sum(hd.da_tra) AS collected_revenue,
  sum(greatest(hd.tong_tien - hd.da_tra, 0)) AS outstanding
FROM public.hoa_don hd
JOIN public.phong p ON p.id = hd.phong_id
WHERE hd.xoa_luc IS NULL
  AND hd.trang_thai <> 'CANCELLED'
GROUP BY ky_nam, ky_thang, p.nha_tro_id;
```

Debt aging có thể query trực tiếp từ `hoa_don` với `han_tra`.

## 8. Test cần viết

Backend:
- Overview tính đúng tỷ lệ thu tiền.
- Revenue chart trả đủ 12 tháng kể cả tháng không có dữ liệu.
- Debt aging phân loại đúng theo `hanTra`.
- Top debtors sắp xếp theo `tongNo desc`.
- Permission: user chỉ thấy tòa nhà được quyền.

Frontend/manual:
- Dashboard load được khi không có dữ liệu.
- Filter theo tòa nhà cập nhật biểu đồ.
- Click action item điều hướng đúng module.

## 9. Checklist triển khai

- [ ] Tạo DTO response.
- [ ] Tạo projection/repository query.
- [ ] Tạo `DashboardAnalyticsService`.
- [ ] Tạo controller endpoint mới.
- [ ] Cập nhật `next.config.ts` nếu cần.
- [ ] Tạo components chart frontend.
- [ ] Thay KPI "trên trang" bằng aggregate backend ở các phần quan trọng.
- [ ] Thêm loading/empty/error states.
- [ ] Viết backend tests.

## 10. Demo bảo vệ

Kịch bản:
1. Mở dashboard.
2. Chỉ ra KPI: phải thu, đã thu, còn nợ, tỷ lệ thu.
3. Chỉ ra biểu đồ 12 tháng.
4. Mở công nợ aging và top phòng nợ cao.
5. Click một action item hóa đơn quá hạn.
6. Ghi nhận thanh toán hoặc webhook VietQR.
7. Quay lại dashboard thấy công nợ giảm/doanh thu tăng.

## 11. Điểm cần tránh

- Không hiển thị số tổng bằng cách cộng dữ liệu của trang hiện tại.
- Không tạo dashboard chỉ toàn card số.
- Không dùng quá nhiều màu trạng thái không nhất quán.
- Không để biểu đồ rỗng mà không có empty state.
