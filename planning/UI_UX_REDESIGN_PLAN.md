# EasyHouse UI/UX Redesign Plan

Ngày lập: 2026-05-27  
Phạm vi: public portal, dashboard quản lý và tenant portal.  
Nguồn đối chiếu: controller/DTO trong `be/src/main/java/com/example/quanlyphongtro`, route trong `frontend/src/app` và `frontend/next.config.ts`.

## 1. Vấn Đề Hiện Tại

### Trải nghiệm và thông tin

| Vấn đề | Ảnh hưởng thực tế | Hướng xử lý |
|---|---|---|
| Dashboard dùng bố cục card rời rạc và từng hiển thị tăng trưởng `+12%` không có từ API | Người vận hành hiểu sai doanh thu | Chỉ hiển thị số backend cung cấp; tăng trưởng chỉ xuất hiện sau khi API trả dữ liệu so sánh |
| Navigation quản lý đưa gần 20 chức năng vào các nhóm dài, trang tổng quan không có hành động nhanh | Người dùng phải nhớ module và thao tác nhiều | Nhóm lại theo việc cần làm: Tài sản, Thu tiền, Chăm sóc, Quản trị; dashboard có quick action |
| Loading/error/empty không thống nhất; một số trang fail thành màn hình trống hoặc chỉ toast | Không biết có dữ liệu hay API lỗi | Component trạng thái chung, error có nút thử lại, empty gợi ý thao tác |
| Danh sách tự triển khai search/filter/pagination khác nhau | Tốn bảo trì, mobile khó dùng | Chuẩn `PageHeader -> Summary -> FilterBar -> Table/Card list -> Pagination` |
| Public room listing có trang trí gradient mạnh, khác phong cách dashboard | Thương hiệu không nhất quán, giảm độ rõ | Palette trung tính với primary xanh đậm, nhấn xanh lá/cam theo trạng thái |
| Tenant portal và manager portal dùng hai hệ thị giác khác nhau | Người dùng chuyển vai trò thấy thiếu liên tục | Dùng chung token, card, trạng thái và mobile navigation pattern |

### Vấn đề kỹ thuật liên quan UI

- Frontend vẫn phải xử lý cả `_id` và `id`; đây là hợp đồng chuyển tiếp cần giữ ổn định trong đợt UI.
- Một số list tìm kiếm trên trang hiện tại chỉ lọc dữ liệu của trang đang tải, không phải toàn bộ kết quả.
- Tài liệu chỉ mục cũ không còn đầy đủ: controller hiện tại đã có `cau-hinh-gia`, `cong-no`, `bao-cao`, `tenant`, `lich-hen`, `media`, `audit-log` và `bank-transaction`.
- Bảo mật/role phải do backend enforce; sidebar ẩn mục không phải cơ chế phân quyền.

## 2. Sitemap Và Luồng Người Dùng

### Public

```text
Trang chủ
├── Tìm phòng -> Danh sách phòng -> Chi tiết phòng -> Đặt lịch xem
├── Tra cứu hóa đơn công khai (qua link được chia sẻ)
└── Đăng nhập
    ├── Quản lý / nhân viên -> Dashboard quản lý
    └── Khách thuê -> Portal khách thuê
```

Luồng thuê phòng đề xuất:

1. Khách xem danh sách phòng trống, lọc theo tòa nhà, mức giá, diện tích và tiện ích.
2. Khách mở chi tiết phòng, xem chi phí minh bạch và đặt lịch.
3. Quản lý duyệt lịch hẹn, tạo khách thuê và hợp đồng từ thông tin đã thu thập.

### Dashboard quản lý

```text
Tổng quan
├── Tài sản: Tòa nhà, Phòng, Dịch vụ & tiện ích, Cấu hình giá
├── Cư trú: Khách thuê, Hợp đồng, Chỉ số điện nước
├── Thu tiền: Hóa đơn, Công nợ, Thanh toán, Đối soát VietQR
├── Chăm sóc: Sự cố, Thông báo, Lịch hẹn, Media
├── Phân tích: Báo cáo, Nhật ký hệ thống
└── Hệ thống: Tài khoản, Hồ sơ, Cài đặt, Xem website
```

Luồng vận hành hàng tháng:

1. Ghi/chốt chỉ số điện nước theo phòng.
2. Tạo hóa đơn từ hợp đồng, cấu hình giá và chỉ số đã chốt.
3. Theo dõi công nợ, ghi nhận thanh toán hoặc đối soát chuyển khoản.
4. Xử lý sự cố và hợp đồng sắp hết hạn từ hàng đợi dashboard.

### Portal khách thuê

```text
Tổng quan -> Hóa đơn/Thanh toán -> Hợp đồng -> Báo sự cố -> Thông báo -> Hồ sơ
```

Ưu tiên mobile: số tiền cần thanh toán, hạn thanh toán và nút báo sự cố luôn tiếp cận trong tối đa hai thao tác.

## 3. Danh Sách Màn Hình

| Nhóm | Màn hình | API hiện có | Ưu tiên |
|---|---|---|---|
| Public | Landing, danh sách phòng, chi tiết phòng, đặt lịch | `/api/public/phong`, `/api/public/toa-nha`, `/api/lich-hen` | P1 |
| Quản lý | Tổng quan vận hành | `/api/dashboard/stats`, `/api/audit-log` | P0 |
| Tài sản | Tòa nhà, phòng, dịch vụ, cấu hình giá | `/api/toa-nha`, `/api/phong`, `/api/dich-vu`, `/api/tien-ich`, `/api/cau-hinh-gia` | P1 |
| Cư trú | Khách thuê, hợp đồng, chốt chỉ số | `/api/khach-thue`, `/api/hop-dong`, `/api/chi-so-dien-nuoc` | P1 |
| Thu tiền | Hóa đơn, công nợ, thanh toán, VietQR | `/api/hoa-don`, `/api/cong-no`, `/api/thanh-toan`, `/api/bank-transaction` | P0 |
| Chăm sóc | Sự cố, thông báo, lịch hẹn, media | `/api/su-co`, `/api/thong-bao`, `/api/lich-hen`, `/api/media` | P1 |
| Quản trị | Báo cáo, audit, user, hồ sơ/cài đặt | `/api/bao-cao`, `/api/audit-log`, `/api/admin/users`, `/api/user` | P2 |
| Tenant | Tổng quan, hóa đơn, hợp đồng, sự cố, thông báo, hồ sơ | `/api/tenant/*`, `/api/user/profile` | P1 |

## 4. Đặc Tả UI Theo Loại Màn Hình

### Ma trận màn hình cụ thể

| Màn hình | Bố cục và thông tin quyết định | Thao tác chính / lưu ý mobile |
|---|---|---|
| Landing `/` | Hero định vị sản phẩm, hai hành trình tìm phòng/quản lý, 3 lợi ích vận hành | CTA tìm phòng đầu tiên; login và cổng tenant rõ ràng |
| Danh sách phòng `/xem-phong` | Search + filter tòa nhà/giá/diện tích/tiện ích; card ảnh, giá, trạng thái, địa điểm | Filter thành bottom sheet; card có `Xem chi tiết` |
| Chi tiết phòng `/phong/[id]` | Gallery, giá/cọc/chi phí, tiện ích, địa chỉ, chính sách | CTA `Đặt lịch xem` sticky đáy mobile |
| Đăng nhập/đăng ký | Form một cột, phân biệt quản lý và khách thuê, feedback xác thực email | Input lớn, show password, link recovery |
| Tổng quan quản lý `/dashboard` | KPI thu tiền/công suất, hàng đợi xử lý, quick action, audit cho admin | Các card xếp dọc, việc cần làm đứng trước biểu đồ |
| Tòa nhà | Summary số phòng, table tòa nhà và drawer detail có phòng/giá | `Thêm tòa nhà`; card list trên điện thoại |
| Phòng | Summary trạng thái, filter theo tòa/tình trạng, card/table có giá và người thuê hiện tại | `Thêm phòng`; action xem khách/hình ảnh trong detail |
| Dịch vụ & cấu hình giá | Tab dịch vụ/tiện ích và bảng giá hiệu lực theo tòa nhà | `Thêm mức giá`, tránh sửa trực tiếp giá đã dùng cho kỳ hóa đơn |
| Khách thuê | Table thông tin liên hệ, trạng thái cư trú, hợp đồng hiện tại | `Thêm khách thuê`; không đưa CCCD đầy đủ ra list mobile |
| Hợp đồng | Filter trạng thái/sắp hạn, row có phòng, đại diện, ngày kết thúc | `Tạo hợp đồng`; detail có gia hạn/kết thúc |
| Form hợp đồng | Step/section: phòng -> người ở -> chi phí/dịch vụ -> điều khoản | Footer lưu sticky; chọn phòng trước khi chọn dịch vụ |
| Chỉ số điện nước | Chọn kỳ + tòa, grid phòng với chỉ số cũ/mới và badge chốt | `Lưu nháp`/`Chốt kỳ`; cảnh báo khi chỉ số giảm |
| Hóa đơn | Filter kỳ/trạng thái, amount remaining nổi bật, bulk generate nếu API hỗ trợ | `Tạo hóa đơn`; mobile ưu tiên số còn phải thu |
| Chi tiết/form hóa đơn | Breakdown line item, chỉ số nguồn, lịch sử thanh toán, link public | `Ghi nhận thanh toán`; tổng phải reconcile ngay trên UI |
| Công nợ | KPI tổng nợ/quá hạn, bảng theo phòng/khách và danh sách hóa đơn nợ | `Gửi nhắc nợ` chỉ bật sau khi có API gửi thật |
| Thanh toán / VietQR | Danh sách giao dịch, payment status, màn đối soát hai cột | `Đối soát`/`Ghi nhận`; mobile dùng detail sheet |
| Sự cố | Kanban đơn giản hoặc list theo trạng thái/ưu tiên, ảnh và người phụ trách | `Tạo sự cố`; tenant có nút báo mới nổi bật |
| Thông báo | Composer + lịch sử gửi, filter channel/status/đối tượng nhận | `Gửi thông báo`; hiển thị delivery result |
| Lịch hẹn | Lịch/list, trạng thái xác nhận, thông tin phòng và người xem | Quick approve/cancel; lịch chuyển list trên mobile |
| Media | Filter loại đối tượng, gallery/table tệp, quyền truy cập rõ | Upload theo object context, không upload raw mặc định |
| Báo cáo | Filter thời gian/tòa, KPI và chart doanh thu/đã thu/công suất | Chart responsive; export khi backend hỗ trợ |
| Audit/tài khoản/cài đặt | Table audit read-only; user roles/building assignment; settings theo section | Chỉ ADMIN thấy tính năng quản trị |
| Tenant tổng quan | Số tiền/hạn hóa đơn gần nhất, hợp đồng/phòng, liên hệ hỗ trợ | Bottom navigation, `Thanh toán`/`Báo sự cố` luôn dễ chạm |
| Tenant hóa đơn/hợp đồng/sự cố | List card và detail chỉ trong phạm vi người thuê | Không lộ action quản trị; upload ảnh báo sự cố |

### Dashboard tổng quan

- Header có lời chào theo vai trò, thời điểm cập nhật và các action: `Tạo hóa đơn`, `Ghi chỉ số`, `Thêm hợp đồng`.
- KPI hàng đầu: phòng đang thuê/tổng phòng, tiền đã thu tháng, tiền chưa thu, sự cố cần xử lý. Không suy luận phần trăm tăng/giảm khi API chưa có.
- Hàng đợi cần xử lý: hóa đơn sắp đến hạn, hợp đồng sắp hết hạn, sự cố mở; từng dòng dẫn đến trang module tương ứng.
- Khối tình trạng phòng hiển thị occupied/available/maintenance bằng progress bar và legend.
- Desktop dùng grid 12 cột; mobile xếp KPI một cột, quick action 2 cột, hàng đợi trước thống kê phụ.

### Danh sách dữ liệu

- Header: tên module, mô tả ngắn, primary action bên phải desktop và full-width trên mobile.
- Toolbar dính theo vùng table khi cuộn: tìm kiếm debounced, tối đa 3 filter quan trọng, `Xóa lọc`, tùy chọn cột.
- Desktop dùng table, click mã đối tượng mở detail; action phụ đặt trong menu.
- Mobile dùng card list: mã + trạng thái ở dòng đầu, 2-3 thuộc tính quyết định, action chính rõ ràng.
- Pagination server-side chuẩn: page, limit, sort, total, totalPages; không gọi là tìm kiếm toàn bộ khi đang lọc client-side một trang.

### Form thêm/sửa

- Dùng trang riêng cho nghiệp vụ dài (`hợp đồng`, `hóa đơn`), modal chỉ dùng đối tượng ngắn (`tòa nhà`, cấu hình đơn giản).
- Form chia section có tiêu đề: thông tin chính, liên kết nghiệp vụ, chi phí, tệp đính kèm, ghi chú.
- Footer sticky: `Hủy`, `Lưu nháp` nếu backend hỗ trợ, `Lưu/Kích hoạt`.
- Validation hiển thị dưới field; cảnh báo nghiệp vụ như trùng hợp đồng hoặc chỉ số giảm phải trả từ API rõ ràng.

### Trang chi tiết

- Header gồm mã, badge trạng thái, action nghiệp vụ theo trạng thái.
- Nội dung desktop: thông tin ở cột trái, timeline/thanh toán/tệp ở cột phải; mobile xếp dọc.
- Hóa đơn cần reconciliation rõ: tổng dòng chi tiết, đã trả, còn lại và lịch sử thanh toán.

### Trạng thái chung

- `Loading`: skeleton giữ đúng hình khối màn hình.
- `Error`: thông báo có ngữ cảnh và nút `Thử lại`, không chỉ toast.
- `Empty`: icon nhẹ, lý do và primary action khi người dùng có thể tạo dữ liệu.
- `Success/destructive`: toast cho phản hồi tức thời, dialog xác nhận với hành động xóa/hủy.

## 5. Design System Và Component Dùng Lại

### Visual tokens

| Token | Mục đích |
|---|---|
| Primary navy/teal | Action chính và điều hướng đang chọn, đủ tương phản trên nền trắng |
| Success green | Đã thu, phòng trống, hoàn thành |
| Warning amber | Sắp hạn, thanh toán một phần |
| Danger red | Quá hạn, sự cố khẩn, xóa |
| Surface slate | Nền app, table header, vùng lọc |

- Font: `Inter`, body 14-16px, heading có cấp rõ; không dùng chữ dưới 12px cho nội dung nghiệp vụ.
- Spacing: nhịp 4/8/12/16/24/32; card radius 12px; input và button tối thiểu 40px trên mobile.

### React components đề xuất

| Component | Dùng cho |
|---|---|
| `DashboardPageHeader` | tiêu đề, mô tả, CTA nhất quán |
| `MetricCard` | KPI với icon, intent và supporting text |
| `AsyncState` / `DashboardSkeleton` | loading/error/empty có thể tái dùng |
| `FilterBar` | search, select, reset, filter drawer mobile |
| `DataListLayout` | chuyển table desktop sang card mobile |
| `StatusBadge` | mapping enum -> label/màu duy nhất |
| `FormSection` / `StickyFormActions` | form dài |
| `ActionQueue` | việc cần xử lý từ dashboard |

## 6. Cải Thiện API Cho Frontend

### Cần bổ sung hoặc chỉnh sửa

| API | Cần thay đổi | Lý do UI |
|---|---|---|
| `GET /api/dashboard/stats` | thêm `generatedAt`, thống kê quá hạn, so sánh tháng trước hoặc `trendPercent` nullable | dashboard không được tự dựng số tăng trưởng |
| `GET /api/dashboard/tasks` (mới) | trả top hóa đơn quá hạn/sắp hạn, hợp đồng sắp hết hạn, sự cố ưu tiên kèm ID/route | action queue có dữ liệu cụ thể thay vì chỉ count |
| Các list CRUD | chuẩn hóa `search`, filter, `sort`, `page`, `limit` server-side và metadata thống nhất | tìm kiếm/pagination đúng trên toàn bộ dữ liệu |
| `GET /api/cong-no` | Đã thêm `search`, `overdueOnly`; còn cần `toaNhaId` và tổng tiền aggregate theo filter | list đã tìm kiếm/lọc đúng toàn bộ dữ liệu; KPI tiền hiện phải ghi rõ phạm vi trang |
| `POST/PUT /api/chi-so-dien-nuoc` | Đã chặn client tự gán `BILLED`/`CANCELLED`; `BILLED` chỉ do quy trình lập hóa đơn tạo ra | tránh sai lệch chỉ số đã tính tiền và trạng thái hóa đơn |
| `GET /api/thanh-toan` | Đã thêm `search`, `phuongThuc`, `tuNgay`, `denNgay` server-side bên cạnh trạng thái/hóa đơn | danh sách thanh toán lọc đúng toàn bộ dữ liệu và hỗ trợ đối soát thực tế |
| `GET /api/hoa-don` | Đã thêm `search`, `kyThang`, `kyNam` server-side bên cạnh trạng thái/hợp đồng | danh sách hóa đơn lọc đúng theo kỳ; luồng thu tiền được mở theo hóa đơn cụ thể |
| `GET /api/toa-nha` / `GET /api/nha-tro` | Đã thêm `search` server-side theo tên và địa chỉ | danh sách tòa nhà không còn lọc sai trong từng trang phân trang |
| `GET /api/phong` | Đã thêm `search` server-side theo tên phòng, khu vực, mô tả và tòa nhà bên cạnh các filter hiện hữu | quản lý phòng tìm đúng toàn bộ tập dữ liệu trong phạm vi quyền |
| `GET /api/khach-thue` | Đã thêm `search` server-side theo tên, điện thoại, CCCD, quê quán và email bên cạnh trạng thái | tìm khách thuê đúng toàn bộ tập phân trang |
| `GET /api/hop-dong` | Đã thêm `search` và nối filter `toaNha` thực sự vào repository bên cạnh phòng/trạng thái | danh sách hợp đồng không còn hiển thị filter tòa nhà vô hiệu |
| `GET /api/public/phong` | Đã có và UI đã dùng filter giá/diện tích; còn cần tiện ích và facet counts | khách đã lọc được phòng thực tế theo ngân sách/diện tích; facet là cải tiến tiếp theo |
| `GET /api/hoa-don/{id}` | bảo đảm line items + payment history + outstanding được trả trong detail DTO | trang chi tiết không phải gọi ghép nhiều nguồn |
| `GET /api/audit-log` | thay response `PageImpl` thô bằng `PaginatedResponse<AuditLogResponse>` hoặc page DTO ổn định | loại cảnh báo runtime Spring Data và giữ contract pagination nhất quán |
| Notification | endpoint tạo nhắc nợ/sự cố có template, channel và delivery status | UI công nợ đã bỏ nút thành công giả; chỉ bật gửi khi có backend thật |
| Auth/session | backend trả access token thực và enforce quyền | UI role-based không thay thế authorization |

### Contract frontend thống nhất

- Response list: `ApiResponse<PaginatedResponse<T>>` với `data`, `total`, `totalPages`, `page`, `limit`.
- ID: tiếp tục trả `_id` trong DTO tới khi migration frontend hoàn tất; không để từng page tự suy đoán.
- Enum: backend DTO trả value UI ổn định hoặc frontend dùng một mapper tập trung; không mix DB/UI status trên từng component.

## 7. Kế Hoạch Triển Khai Và Tiến Độ

| Phase | Phạm vi | Kết quả kiểm chứng | Trạng thái 2026-05-27 |
|---|---|---|---|
| 0. Discovery | đối chiếu routes, controller, DTO và UX hiện tại | blueprint phản ánh API đang có | Hoàn thành |
| 1. Foundation | theme tokens, dashboard shell/navigation, primitive trạng thái/KPI | TypeScript/lint; responsive shell | Đã triển khai; kiểm tra phạm vi pass |
| 2. Operational dashboard | tổng quan vận hành dựa dữ liệu thật, queue và quick action | API stats; không có metric giả | Đã triển khai; kiểm tra phạm vi pass |
| 3. Revenue workflow | hóa đơn, công nợ, thanh toán, chỉ số | list/form/detail responsive, server filter | Hoàn thành: đã kiểm tra build/test |
| 4. Asset/residency | tòa nhà, phòng, khách thuê, hợp đồng | bốn danh sách đã dùng search server-side; hợp đồng lọc tòa nhà thật; backend test pass | Hoàn thành phần list/filter |
| 5. Service/public/tenant | public listing/detail/booking, tenant mobile, sự cố | public listing đã có giá/diện tích, phân trang/error; tenant shell/dashboard có navigation, retry và request session chuẩn hóa | Hoàn thành phạm vi triển khai |
| 6. Governance | báo cáo, audit, user/settings; a11y/E2E | auth cho API dashboard, lint/build sạch, Playwright smoke desktop/mobile | Hoàn thành phạm vi triển khai |

### Definition of Done cho mỗi màn hình

- Dùng đúng endpoint/DTO và role scope được backend enforce.
- Có loading, error/retry, empty và success feedback.
- Có layout desktop/mobile; thao tác chính không bị ẩn trong menu ở mobile.
- List có filter/pagination đúng phạm vi dữ liệu; form có validation nghiệp vụ.
- `npx tsc --noEmit`, lint liên quan và smoke flow tương ứng không phát sinh lỗi mới.

### Nhật ký thực hiện

| Thời điểm | Công việc | Kết quả |
|---|---|---|
| 2026-05-27 | Khảo sát API/frontend và tạo blueprint redesign | Đã hoàn thành tài liệu này |
| 2026-05-27 | Implement foundation, shell/navigation, dashboard và landing public | Đã triển khai React/Tailwind |
| 2026-05-27 | Kiểm tra thay đổi UI | `npx.cmd tsc --noEmit` pass; ESLint riêng các file UI mới/sửa pass; `git diff --check` phạm vi UI pass |
| 2026-05-27 | Build frontend trước Phase 3 | Bundle compile thành công; bước lint từng bị chặn bởi 3 lỗi `no-explicit-any` trong thay đổi hợp đồng |
| 2026-05-27 | Triển khai `/dashboard/cong-no` | KPI, error/retry, server search/filter, bảng desktop, card mobile, dialog hóa đơn nợ; bỏ thao tác nhắc nợ giả |
| 2026-05-27 | Mở rộng `GET /api/cong-no` | Thêm query `search` và `overdueOnly`, lọc trước phân trang; thêm `CongNoServiceTest` |
| 2026-05-27 | Dọn blocker kiểm tra hợp đồng | Thay ba biểu thức `any` bằng kiểu response/tham chiếu tòa nhà cụ thể, không đổi hành vi nghiệp vụ |
| 2026-05-27 | Kiểm tra Phase 3 công nợ | `mvn test` pass 85 tests; `npx.cmd tsc --noEmit` pass; `npm.cmd run lint` pass với 61 warning legacy; `npm.cmd run build` pass |
| 2026-05-27 | Triển khai `/dashboard/chi-so-dien-nuoc` | Filter kỳ/phòng/loại/trạng thái server-side, KPI, table/card responsive, form nhập/chốt chỉ số và xác nhận hủy |
| 2026-05-27 | Khóa transition chỉ số ở backend | API từ chối client tạo/sửa bản ghi thành `BILLED` hoặc `CANCELLED`; trạng thái đã tính tiền vẫn do `HoaDonService` quản lý |
| 2026-05-27 | Kiểm tra Phase 3 chỉ số | `mvn test` pass 87 tests; `npx.cmd tsc --noEmit` pass; `npm.cmd run lint` pass với 61 warning legacy; `npm.cmd run build` pass |
| 2026-05-27 | Triển khai `/dashboard/thanh-toan` | Thay UI legacy bằng KPI, search/filter server-side, table/card responsive, form thực thu và xác nhận hủy; loại bỏ thao tác tải giả |
| 2026-05-27 | Mở rộng `GET /api/thanh-toan` | Thêm lọc phương thức, khoảng ngày và tìm kiếm mã/hóa đơn/khách/phòng/ghi chú; thêm test chuẩn hóa filter và ngày |
| 2026-05-27 | Kiểm tra Phase 3 thanh toán | `mvn test` pass 89 tests; `npx.cmd tsc --noEmit` và ESLint phạm vi sửa pass; `npm.cmd run lint` pass với 61 warning legacy; `npm.cmd run build` pass |
| 2026-05-27 | Triển khai `/dashboard/hoa-don` và liên kết thu tiền | KPI, search/kỳ/trạng thái server-side, list responsive, xác nhận hủy; nút thu tiền mở form thanh toán với hóa đơn chọn sẵn |
| 2026-05-27 | Mở rộng `GET /api/hoa-don` | Thêm query `search`, `kyThang`, `kyNam`, validation kỳ và test repository contract; cập nhật tenant call site |
| 2026-05-27 | Chốt Phase 3 doanh thu | `mvn clean test` pass 91 tests; TypeScript/ESLint phạm vi sửa pass; `npm.cmd run lint` pass với 61 warning legacy; `npm.cmd run build` pass; bundle list hóa đơn còn `7.55 kB` |
| 2026-05-27 | Chuẩn hóa tìm kiếm `/dashboard/toa-nha` và `/dashboard/phong` | Chuyển search từ lọc từng trang sang backend filter có debounce; giữ nguyên form CRUD hiện hữu |
| 2026-05-27 | Mở rộng `GET /api/toa-nha` và `GET /api/phong` | Thêm query `search`, repository filter theo scope quyền và unit tests chuẩn hóa từ khóa |
| 2026-05-27 | Kiểm tra bước đầu Phase 4 | `mvn clean test` pass 93 tests; `npx.cmd tsc --noEmit` và ESLint phạm vi sửa pass; `npm.cmd run lint` pass với 61 warning legacy; `npm.cmd run build` pass |
| 2026-05-27 | Chuẩn hóa `/dashboard/khach-thue` và `/dashboard/hop-dong` | Tìm kiếm debounce chạy server-side; filter tòa nhà hợp đồng được xử lý thật thay vì bị backend bỏ qua |
| 2026-05-27 | Mở rộng `GET /api/khach-thue` và `GET /api/hop-dong` | Thêm contract tìm kiếm/filter repository theo quyền truy cập và unit tests cho normalization/forward filter |
| 2026-05-27 | Cải thiện public listing `/xem-phong` | Dùng filter API giá/diện tích có sẵn, phân trang, error/retry và KPI đúng tổng kết quả; bỏ filter trạng thái vô hiệu |
| 2026-05-27 | Cải thiện tenant shell/dashboard | Bổ sung điều hướng hợp đồng, icon thông báo đúng nghĩa và trạng thái lỗi/tải lại cho tổng quan cư dân |
| 2026-05-27 | Kiểm tra Phase 4 và phần đầu Phase 5 | `mvn clean test` pass 95 tests; TypeScript/ESLint phạm vi sửa pass; `npm.cmd run lint` pass với 54 warning legacy; `npm.cmd run build` pass |
| 2026-05-27 | Ổn định tenant portal và governance frontend | Chuẩn hóa callback tải dữ liệu theo session token, dùng `next/image` ở các ảnh vận hành/tenant và dọn toàn bộ warning frontend còn lại |
| 2026-05-27 | Sửa lỗi runtime phát hiện qua smoke | Gắn `Authorization: Bearer session.accessToken` cho các trang dashboard/CRUD bảo vệ; ép kiểu query tìm kiếm và ngày lọc PostgreSQL để tránh lỗi tham số null |
| 2026-05-27 | Kiểm chứng cuối | `mvn clean test` pass 95 tests và `mvn test` pass lại sau bản vá query cuối; `npx.cmd tsc --noEmit`, `npm.cmd run lint`, `npm.cmd run build` pass sạch; Docker + Playwright smoke pass cho dashboard, hợp đồng, khách thuê, hóa đơn, công nợ, thanh toán, hai form tạo mới và `/xem-phong` mobile |
| 2026-05-27 | Backlog API được xác nhận | `GET /api/audit-log` vẫn phát cảnh báo do serialize `PageImpl` trực tiếp; cần đổi sang DTO pagination ổn định, không chặn UI hiện tại |
