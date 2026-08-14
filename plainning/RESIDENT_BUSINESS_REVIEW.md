# Review và chuẩn hóa nghiệp vụ Resident

Ngày review: 13/08/2026  
Phạm vi: luồng từ ký hợp đồng → nhận phòng → phát sinh kỳ phí → hóa đơn → thanh toán → gia hạn hoặc trả phòng → quyết toán → bàn giao → phòng sẵn sàng cho thuê.

Tài liệu này là thiết kế nghiệp vụ đích và backlog triển khai, **không phải lệnh thay đổi dữ liệu hoặc mã nguồn**. Các điểm còn cần Product Owner (PO) quyết định được tập hợp tại mục 14.

## 1. Current Problems

| Mức độ | Vấn đề hiện tại | Tác động |
|---|---|---|
| Critical | `HoaDon` còn cho `PARTIAL` và `OVERPAID`; `ThanhToanService` tính lại số đã trả từ nhiều giao dịch. | Trái quy định “một hóa đơn thanh toán một lần, đủ số tiền”; có thể sinh công nợ treo và dư tiền không có luồng xử lý rõ. |
| Critical | Checkout hiện là một modal 2 bước: chốt điện/nước, rồi tạo hóa đơn cuối và cấn cọc. Không có thực thể checkout, checklist bắt buộc, bàn giao hay kiểm kê tài sản. | Có thể kết thúc hợp đồng/phòng trước khi hoàn tất quyết toán hoặc bàn giao. |
| Critical | Cọc là các trường trên `HopDong` và có hóa đơn cọc tự sinh; chưa có sổ giao dịch cọc/settlement tách biệt. | Không thể truy vết chuẩn tiền đã thu, bị giữ, khấu trừ, hoàn và phần khách còn nợ. |
| High | Phí xe được tự tính từ xe hiệu lực của phòng, mặc định **mỗi người miễn phí xe đầu, tính số xe còn lại** và dùng một đơn giá parking. | Quy tắc ngầm, không theo loại xe/biểu phí/ngày hiệu lực; không đáp ứng xe máy/ô tô, thêm-xóa-đổi xe giữa kỳ. |
| High | `PhuongTien` không lưu ngày bắt đầu/kết thúc tính phí hoặc fee plan. Xóa xe là hard delete. | Không thể tái lập hóa đơn lịch sử hoặc prorate chính xác. |
| High | `DichVuHopDong` có loại tính `FIXED`, `PER_PERSON`, `PER_ROOM`, `PER_UNIT`, `PERCENT`, nhưng hóa đơn hiện chủ yếu tính số lượng; điện/nước/xe nhận diện bằng tên dịch vụ. | Nhầm trách nhiệm và dễ tính trùng/chạy sai khi đổi tên dịch vụ. |
| High | Dịch vụ tính theo người lấy số thành viên có giao với kỳ, nhưng không có quy ước cho số ngày, số người bình quân, tăng/giảm giữa kỳ. | Tổng tiền không dự đoán được, gây tranh chấp. |
| High | Hóa đơn mang `kyNam/kyThang` và `tuNgay/denNgay`, unique theo tháng; chưa phân loại rõ regular/deposit/final settlement. | Không thể có nhiều chứng từ hợp lệ cùng tháng (cọc, kỳ thường, quyết toán) mà vẫn giữ uniqueness chuẩn. |
| High | Hóa đơn khi tạo/chỉnh sửa có thể tổng hợp `soDuDauKy` từ nợ cũ. | Mâu thuẫn yêu cầu không chuyển nợ kỳ này sang kỳ khác. |
| High | Trạng thái phòng hiện chỉ có AVAILABLE/RESERVED/RENTED/MAINTENANCE/INACTIVE. | Thiếu “chờ nhận phòng”, “đang trả phòng”, “chờ vệ sinh/kiểm tra”; không phân biệt hợp đồng hết hạn với phòng thực tế sẵn sàng. |
| Medium | Thông báo nợ đã có lịch chạy và log chống gửi trùng theo loại/kênh/người nhận, nhưng danh sách hiện là 3 ngày, 1 ngày và quá hạn; chưa thể hiện đúng chính sách ngày đến hạn + 1/3/7 ngày. | Nhắc chưa đủ nghiệp vụ; cần cấu hình và tiêu chí dừng nhắc. |
| Medium | Gia hạn đã có `PhuLucHopDong` và cập nhật ngày/giá, nhưng chưa lưu snapshot đầy đủ của cọc, dịch vụ, người thực hiện và workflow đề nghị/xác nhận. | Lịch sử thay đổi chưa đầy đủ để đối soát. |
| Medium | Detail hóa đơn đã có loại dòng, nhưng không có snapshot source/rule/period cho từng dòng và các liên kết service/meter còn tùy chọn. | Khó audit sau khi biểu phí, thành viên hoặc xe bị thay đổi. |
| Medium | UI invoice/checkout tính một số tiền ở client; trang checkout dùng giá và dịch vụ từ `HopDong`. | Rủi ro UI hiển thị khác số server chốt, đặc biệt với phụ lục, giá áp dụng và lịch sử. |
| Low | Format hiển thị chưa có chuẩn bắt buộc cho tiền, đơn giá, số lượng và chỉ số. | Dễ nhầm kWh/m³ với VND, dữ liệu demo khó đọc. |
| Low | Bộ lọc và dashboard cần nhất quán label/placeholder và filter theo tòa nhà. | UX chậm, khó nhìn thấy vận hành theo từng tòa. |

Ghi nhận tích cực: dữ liệu hiện có unique `(hop_dong_id, ky_nam, ky_thang)`, chi tiết điện/nước kiểm tra chỉ số không lùi, hóa đơn có giao dịch không thể sửa/xóa, thanh toán có lock hóa đơn và idempotency key. Những cơ chế này giữ lại nhưng phải điều chỉnh theo state machine mới.

## 2. Business Rules

| ID | Rule |
|---|---|
| BR-001 | Mọi số tiền lưu bằng `numeric`/`BigDecimal`, không dùng `float`; tiền VND hiển thị `#,##0 đ`, đơn giá và thành tiền tách riêng. Chỉ số điện (kWh), nước (m³) và số lượng hiển thị đơn vị, không định dạng như tiền. |
| BR-002 | Hóa đơn regular phải thuộc đúng một hợp đồng hiệu lực, một kỳ `[tuNgay, denNgay]` không chồng lấp cùng loại; invoice period, ngày lập, hạn trả và ngày thanh toán là bốn dữ liệu độc lập. |
| BR-003 | Mỗi hóa đơn regular/final chỉ có một khoản thanh toán `SUCCESS` có số tiền đúng bằng `finalAmount`; không có partial, overpayment hoặc carry-forward tự động. |
| BR-004 | Mỗi yêu cầu thanh toán phải có idempotency key duy nhất; callback ngân hàng dùng external transaction ID duy nhất. Cùng key trả về kết quả giao dịch đầu tiên, không tạo giao dịch thứ hai. |
| BR-005 | Chỉ invoice `DRAFT` được sửa/xóa. Invoice `ISSUED`, `OVERDUE`, `PAID` chỉ có thể điều chỉnh bằng credit/debit note hoặc hủy có lý do/quyền phù hợp; không sửa tổng trực tiếp. |
| BR-006 | Chỉ server tạo/đóng băng line item, tổng và trạng thái; client chỉ xem preview và gửi dữ kiện có căn cứ (reading, adjustment có quyền). |
| BR-007 | Mỗi dịch vụ có `chargingBasis` rõ ràng: `PER_ROOM`, `PER_PERSON`, `PER_UNIT`, `METERED`, `PER_VEHICLE`, `FIXED`. Một service chỉ có một basis trong một version biểu phí. |
| BR-008 | Điện/nước chỉ được tính từ meter reading đã xác nhận; một phòng, loại chỉ số, kỳ có tối đa một reading được bill. Chỉ số mới không nhỏ hơn chỉ số cũ trừ khi có biên bản reset meter. |
| BR-009 | Service/vehicle/member chỉ được bill nếu hiệu lực giao với kỳ; invoice line phải lưu snapshot đơn giá, số lượng, basis, nguồn dữ liệu và khoảng áp dụng. |
| BR-010 | Xe và người là hai nguồn độc lập: thêm xe không làm thay số lượng dịch vụ theo người; thêm người không làm thay số xe tính phí. |
| BR-011 | Biểu phí xe chọn theo tòa nhà + loại xe + ngày hiệu lực. Mỗi xe hiệu lực sinh đúng một dòng hoặc được nhóm có danh sách xe truy vết; không có quy tắc miễn xe ngầm. |
| BR-012 | Hợp đồng chỉ `ACTIVE` sau khi được xác nhận và cọc đạt điều kiện PO phê duyệt. Quá hạn cọc chuyển sang `CANCELLED`, giải phóng reservation; không hard delete. |
| BR-013 | Ngày hết hạn hợp đồng chỉ làm hợp đồng thành `EXPIRING/EXPIRED`; không tự trả phòng hoặc trả `AVAILABLE`. Chỉ checkout hoàn tất mới giải phóng phòng. |
| BR-014 | Gia hạn tạo revision/phụ lục bất biến với before/after và người thực hiện; không ghi đè lịch sử điều khoản cũ. |
| BR-015 | Checkout chỉ hoàn tất sau khi khóa chỉ số, hoàn tất inventory handover, tạo/chốt final settlement, xử lý tiền cọc và thu/hoàn tiền theo settlement. |
| BR-016 | Cọc settlement theo: `depositRefund = max(0, depositHeld - deductions)`; `amountDue = max(0, finalCharges + oldDebtApproved + damages + penalties - depositHeld)`. Không âm hóa dòng nợ; khoản cần thu thêm phải ở final invoice. |
| BR-017 | Không tự động chuyển công nợ regular sang kỳ sau. Nợ cũ chỉ xuất hiện trong final settlement hoặc một debit note riêng khi PO cho phép. |
| BR-018 | Notification phải idempotent theo invoice/contract, rule, scheduled date và channel; không gửi sau `PAID`, `CANCELLED`, `TERMINATED` hoặc checkout complete. |
| BR-019 | Mọi chuyển trạng thái tiền, cọc, invoice, checkout và phòng cần audit event với actor, thời điểm, lý do, old/new value và correlation ID. |
| BR-020 | Không hard delete hợp đồng, invoice đã phát hành, payment, deposit, handover, final settlement hoặc asset inspection. Dùng cancel/void/soft delete có audit. |

## 3. Start Point → End State

| Module | Start Point | Main Flow | End State |
|---|---|---|---|
| Hợp đồng | DRAFT có phòng, đại diện và điều khoản | Preview → confirmed → chờ cọc → cọc hợp lệ → active | ACTIVE hoặc CANCELLED; khi rời phòng là TERMINATED |
| Tiền cọc | Deposit due | Thu cọc → verify → held; đến checkout: khấu trừ/hoàn/forfeit | SETTLED (REFUNDED/DEDUCTED/FORFEITED), không còn số dư không rõ |
| Hóa đơn | Contract active + kỳ tính hợp lệ | Collect snapshot → DRAFT → review → ISSUE → due/overdue → pay/cancel | PAID hoặc CANCELLED; kỳ đóng sau PAID |
| Thanh toán | Invoice `ISSUED`/`OVERDUE`, amount due > 0 | initiate → idempotency check → lock → validate exact total → record success | Một PAYMENT `SUCCESS`, invoice PAID |
| Dịch vụ | Service catalog + ContractService hiệu lực | Chọn basis/đơn giá/version → active trong kỳ → invoice snapshot | Billed line bất biến, service tiếp tục hoặc ngừng theo end date |
| Phương tiện | Tenant đang có hợp đồng active | Đăng ký xe → chọn fee plan → active/inactive → invoice khi giao kỳ | Vehicle lịch sử còn, phí của kỳ đã chốt không đổi |
| Gia hạn | Contract `EXPIRING`/`ACTIVE` | Draft proposal → xác nhận điều khoản → create amendment/revision → effective | ACTIVE với ngày kết thúc/điều khoản mới và lịch sử đầy đủ |
| Trả phòng | Contract expired/active, yêu cầu trả phòng | Start checkout → chốt meter → inventory → final settlement → pay/refund → handover confirm | Contract TERMINATED, room CLEANING/MAINTENANCE/AVAILABLE |
| Bàn giao | Checkout đang xử lý | So sánh baseline asset vs actual → ghi damage/compensation → ký bàn giao | HANDOVER_CONFIRMED |
| Hoàn/khấu trừ cọc | Final settlement đã chốt | Phân bổ cọc vào deductions → thu thiếu hoặc hoàn dư → xác nhận | DepositSettlement SETTLED |

## 4. State Machine

`[U]` người dùng có quyền thực hiện; `[S]` hệ thống tự động; mọi mũi tên ghi audit event.

### Contract

```text
DRAFT --[U: xác nhận]--> PENDING_DEPOSIT --[U/S: cọc đủ]--> ACTIVE
PENDING_DEPOSIT --[S: quá hạn cọc]--> CANCELLED
ACTIVE --[S: còn 30/15/7 ngày]--> EXPIRING --[S: qua hạn]--> EXPIRED
ACTIVE/EXPIRING/EXPIRED --[U: bắt đầu trả phòng]--> CHECKOUT_IN_PROGRESS
CHECKOUT_IN_PROGRESS --[S/U: quyết toán + bàn giao xong]--> TERMINATED
ACTIVE/EXPIRING/EXPIRED --[U: hủy trước hạn được duyệt]--> CHECKOUT_IN_PROGRESS
```

`DRAFT` chỉ sửa/xóa; `PENDING_DEPOSIT` có thể hủy; `ACTIVE` đổi điều khoản qua amendment; `TERMINATED/CANCELLED` là terminal. `EXPIRED` không terminal vì khách có thể còn ở.

### Invoice

```text
DRAFT --[U: phát hành]--> ISSUED --[S: qua hanTra, chưa PAID]--> OVERDUE
ISSUED/OVERDUE --[U/S: thanh toán chính xác một lần]--> PAID
DRAFT --[U: hủy]--> CANCELLED
ISSUED/OVERDUE --[U: void có quyền, chưa thanh toán]--> CANCELLED
```

Không có `PARTIAL`/`OVERPAID`. `PAID` và `CANCELLED` terminal. Sửa/xóa: chỉ `DRAFT`; cancel không hard delete và phải ghi lý do. “Đóng kỳ” là thuộc tính process sau `PAID`, không nên là một trạng thái tiền thứ hai.

### Room

```text
AVAILABLE --[U: giữ chỗ]--> RESERVED --[U: contract/cọc hợp lệ]--> MOVE_IN_PENDING
MOVE_IN_PENDING --[U: nhận phòng + handover]--> OCCUPIED
OCCUPIED --[U: bắt đầu checkout]--> CHECKOUT_IN_PROGRESS
CHECKOUT_IN_PROGRESS --[U: bàn giao hoàn tất]--> CLEANING_OR_MAINTENANCE
CLEANING_OR_MAINTENANCE --[U: đạt chuẩn sẵn sàng]--> AVAILABLE
ANY operational --[U: ngừng khai thác]--> INACTIVE
```

Nếu không muốn thêm enum ngay, `RENTED` tạm tương đương `OCCUPIED`, `MAINTENANCE` tạm chứa cleaning; nhưng không được đặt `AVAILABLE` từ `EXPIRED`.

### Checkout

```text
REQUESTED -> METER_LOCKED -> INVENTORY_COMPLETED -> SETTLEMENT_DRAFT
-> SETTLEMENT_ISSUED -> AWAITING_PAYMENT_OR_REFUND -> HANDOVER_CONFIRMED -> COMPLETED
```

`[U]` khởi tạo, nhập readings, kiểm kê, ký; `[S]` tạo snapshot/tính settlement/khóa dữ liệu. Cancel chỉ trước `SETTLEMENT_ISSUED`; sau đó cần void có quyền.

### Deposit

```text
DUE -> PAID_HELD -> {DEDUCTED | REFUNDED | FORFEITED} -> SETTLED
DUE -> EXPIRED_UNPAID -> CANCELLED
```

`FORFEITED` chỉ khi có căn cứ hợp đồng/PO policy; không phải mặc định khi trả sớm.

## 5. Invoice Calculation

### Công thức chuẩn

```text
RoomFee          = rateRoom(period/version) × occupancyRatio
ElectricityFee   = (newElectric - oldElectric | approvedResetUsage) × electricityUnitRate
WaterFee         = (newWater - oldWater | approvedResetUsage) × waterUnitRate
ServiceFee       = Σ(serviceUnitRate × resolvedServiceQuantity)      // không gồm meter/vehicle
VehicleFee       = Σ(vehicleFeeRate(vehicleType) × vehicleBillRatio)
AdditionalFee    = Σ(approved surcharge/debit-note)
DamageComp       = Σ(approved handover damage compensation)
Discount         = Σ(approved discount/credit-note), biểu diễn âm
RegularTotal     = RoomFee + ElectricityFee + WaterFee + ServiceFee + VehicleFee
                 + AdditionalFee + DamageComp + Discount
DepositDeduction = min(depositHeld, approvedDeductions)               // chỉ final settlement
FinalAmountDue   = max(0, RegularTotal + approvedOldDebt - DepositDeduction)
DepositRefund    = max(0, depositHeld - approvedDeductions)
```

`occupancyRatio` phải theo chính sách prorate đã được PO chấp thuận. Hiện code đã tính tiền phòng theo số ngày có hiệu lực trong tháng và làm tròn HALF_UP 2 chữ số; thiết kế đích cần chốt quy tắc làm tròn VND (`round to 1,000` cho demo chỉ là dữ liệu demo, không phải quy tắc kế toán).

### Ngăn tính trùng

1. `METERED` service không bao giờ tạo ServiceFee; chỉ tạo Electricity/Water từ `MeterReading`.
2. `PER_VEHICLE` không đồng thời tồn tại trong `ContractService` và vehicle calculator cho cùng `vehicleId + period + feePlanVersion`.
3. Service thông thường khóa bởi `contractServiceId + period`; parking khóa bởi `vehicleId + period`; meter khóa bởi `meterReadingId`.
4. Invoice item lưu `sourceType`, `sourceId`, `pricingRuleVersion`, `periodStart/end`, `calculationHash`; thêm unique tương ứng.
5. Không nhận `tongTien`, `daTra` hay parking line do client tự gửi. Server tự tạo và đối chiếu tổng tất cả lines.

## 6. Edge Cases

| Condition | Expected Behavior | Data Update | Final State |
|---|---|---|---|
| Không đóng cọc đúng hạn | Scheduler cảnh báo trước; đến deadline hủy reservation/contract theo policy | Deposit `EXPIRED_UNPAID`, Contract `CANCELLED`, audit + notification | Phòng quay `AVAILABLE` hoặc `RESERVED` khác |
| Không thanh toán invoice đúng hạn | Đổi `ISSUED` → `OVERDUE`, gửi nhắc theo policy, không chuyển nợ tự động | Invoice status + reminder logs | OVERDUE đến khi exact payment/cancel |
| Trả phòng trước hạn | Bắt đầu checkout; áp điều khoản early termination được phê duyệt, chưa đổi phòng trống | Checkout + final invoice lines + settlement | TERMINATED chỉ sau thanh toán/bàn giao |
| Trả phòng sau ngày hết hạn | Contract `EXPIRED`, tiếp tục invoice/prorate theo policy cho đến actual handover | Actual end, final settlement | TERMINATED; không auto AVAILABLE |
| Mất/hỏng > cọc | Khấu trừ toàn bộ cọc; phần chênh tạo DamageComp/FinalAmountDue | DepositSettlement, final invoice amount due | Awaiting payment nếu còn thiếu |
| Hợp đồng hết hạn nhưng chưa trả phòng | Cảnh báo; room giữ OCCUPIED, contract EXPIRED | Notification/audit only | EXPIRED + OCCUPIED |
| Thêm/xóa xe giữa kỳ | Xe có effectiveFrom/effectiveTo; invoice draft tính policy prorate hoặc full tháng | Vehicle assignment history; snapshot line | Dòng xe đúng kỳ, không hard delete |
| Thêm người giữa kỳ | Lưu membership start/end; rule chọn person-days/đầu kỳ/full kỳ | ContractTenant history + line snapshot | Service line theo rule PO |
| Chưa chốt chỉ số | Không phát hành invoice khi service require confirmed reading; preview báo thiếu | Không tạo invoice hoặc DRAFT blocked | MISSING_READING/DRAFT |
| Invoice đã tạo nhưng dịch vụ đổi | DRAFT được regenerate có audit; ISSUED giữ snapshot, dùng adjustment riêng | Version + adjustment/credit/debit note | Số lịch sử bất biến |
| Double-click thanh toán | Cùng idempotency key trả kết quả cũ; khác key khi invoice đã PAID bị từ chối | Một payment record | PAID một lần |
| Hai admin cùng thao tác | Pessimistic lock invoice + optimistic version/state precondition; một người thắng, người kia nhận 409/reload | Audit actor/correlation | Không duplicate payment/transition |

## 7. Data Model

| Entity/table đề xuất | Trách nhiệm và quan hệ |
|---|---|
| Building, Room | Building 1-n Room; Room giữ operational state, không tự suy ra chỉ từ contract date. |
| Tenant, Contract, ContractTenant | Contract là điều khoản/đại diện; ContractTenant là danh sách cư trú có `from/to`, representative, status. |
| Deposit, DepositTransaction, DepositSettlement | Deposit thuộc Contract; mọi thu/hoàn/khấu trừ là transaction; settlement liên kết checkout/final invoice. Không chỉ để `tienCoc + trangThaiCoc` trên Contract. |
| Service, ServiceRateVersion, ContractService | Service catalog/basis; rate version theo building/effective dates; ContractService là lựa chọn và override của hợp đồng. |
| Vehicle, VehicleAssignment, VehicleFeePlan | Vehicle có identity; assignment đến tenant/room có effective dates; fee plan theo Building+vehicle type+version. |
| Meter, MeterReading | Meter thuộc Room/utility; reading chỉ số cũ/mới, timestamp, evidence, approval, invoice link. |
| Invoice, InvoiceItem, InvoiceAdjustment | Invoice phân loại `REGULAR`, `DEPOSIT_REQUEST`, `FINAL_SETTLEMENT`, `DEBIT_NOTE`, `CREDIT_NOTE`; item có snapshot nguồn/rule/period. |
| Payment | Một invoice payable chỉ một payment `SUCCESS`; unique idempotency/external ref; refund là transaction riêng, không âm payment. |
| Checkout, CheckoutStep | Aggregate orchestration cho trả phòng; unique active checkout per Contract. |
| Asset, RoomAsset, AssetHandover, AssetHandoverItem | Asset catalog; inventory baseline theo Room; snapshot condition/quantity khi move-in/out và compensation. |
| Notification, NotificationDelivery | Rule/schedule/dedupe/delivery result riêng; không suy dedupe từ nội dung text. |

Trách nhiệm đang lẫn: `HoaDon` đang vừa là bill kỳ vừa là chứng từ cọc/final; `HopDong` giữ trạng thái/số cọc thay cho ledger; `PhuongTien` là registration nhưng bị dùng trực tiếp để suy phí mà thiếu assignment lịch sử; service điện/nước/xe nhận diện bằng tên thay vì type/basis; Checkout UI đang giữ logic quyết toán thay vì Checkout aggregate trên server.

## 8. UI/UX Proposal

| Màn hình | Đề xuất |
|---|---|
| Invoice List | Thanh filter rõ: Tòa nhà, Kỳ từ–đến, Loại hóa đơn, Trạng thái. Mỗi dòng có mã, phòng, khách, period, due date, total, trạng thái; bulk action chỉ `Generate draft`, không bulk payment. |
| Invoice Detail | Header metadata + state action bar; nhóm chi phí scan-friendly; source/bằng chứng ở từng line; total card; timeline audit/payment/reminder. |
| Contract Detail | Tabs: Tổng quan, Người thuê, Giá & dịch vụ, Cọc, Phụ lục, Hóa đơn/Thanh toán, Trả phòng. CTA theo trạng thái, không nhồi form dài. |
| Checkout | Wizard có checklist khóa: kỳ cuối/reading, inventory, settlement preview, payment/refund, handover signature. Không cho “Hoàn tất” khi còn block. |
| Asset Handover | Bảng side-by-side baseline vs actual, ảnh, tình trạng, thiếu/mất/hỏng, đơn giá bồi thường; ký số/xác nhận hai bên. |
| Dashboard | Global Building selector: `Tất cả tòa nhà`, từng tòa; mọi KPI/chart nhận cùng filter. KPI: total/occupied/available/reserved/checkout, occupancy, expiring contracts, unpaid/overdue, revenue, receivable, deposit held. |
| Vehicle Management | Vehicle registry + fee plan tab; hiển thị loại xe, owner, room, effective dates, rate, trạng thái. Stop/remove là “ngừng hiệu lực từ ngày”, không xóa lịch sử. |

## 9. Invoice UI wireframe

### Desktop

```text
┌ HÓA ĐƠN THANH TOÁN  [DRAFT/CHỜ THANH TOÁN/QUÁ HẠN/ĐÃ THANH TOÁN] ┐
│ Mã HD | Tòa nhà | Phòng | Khách thuê | Kỳ: DD/MM/YYYY–DD/MM/YYYY │
│ Ngày lập | Hạn thanh toán | Ngày thanh toán thực tế                 │
├──────────────────────────────┬───────────────────────────────────────┤
│ TIỀN PHÒNG                   │ TỔNG PHẢI THANH TOÁN                 │
│ Tiền phòng ...               │ Tạm tính             x đ             │
│                               │ Giảm trừ            -x đ             │
│ ĐIỆN & NƯỚC                  │ Đã thanh toán        x đ             │
│ Điện: cũ/mới/tiêu thụ/đơn giá│ CÒN PHẢI TRẢ         x đ             │
│ Nước: cũ/mới/tiêu thụ/đơn giá│ [Thanh toán đủ] [In] [Xuất Excel]    │
│                               ├───────────────────────────────────────┤
│ DỊCH VỤ & TIỆN ÍCH           │ Timeline: tạo/phát hành/nhắc/thanh toán│
│ ...                           │ Evidence & ghi chú                    │
│ PHƯƠNG TIỆN / ĐIỀU CHỈNH ...  │                                       │
└──────────────────────────────┴───────────────────────────────────────┘
```

### Print A4

```text
[Logo/tên đơn vị/địa chỉ]                 HÓA ĐƠN THANH TOÁN
Mã hóa đơn | Ngày lập | Hạn thanh toán | Kỳ DD/MM/YYYY–DD/MM/YYYY
Khách thuê | SĐT | Tòa nhà | Phòng
------------------------------------------------------------------
Nhóm chi phí     Mô tả/đơn vị          SL    Đơn giá    Thành tiền
Tiền phòng       ...
Điện             cũ / mới / tiêu thụ
Nước             cũ / mới / tiêu thụ
Dịch vụ | Xe | Điều chỉnh
------------------------------------------------------------------
Tạm tính | Giảm trừ | TỔNG PHẢI THANH TOÁN | Đã thanh toán | Còn lại
[QR thanh toán nếu invoice chưa PAID]     Người lập / Khách xác nhận
```

Không sidebar/menu; lề A4, font ≥ 10 pt, ngắt trang lặp header bảng, không tách total card khỏi các dòng cuối.

## 10. Excel & Print

Workbook export gồm:

1. `Invoice Summary`: Mã hóa đơn, loại, tòa nhà, phòng, khách thuê, từ ngày, đến ngày, tiền phòng, điện, nước, dịch vụ, xe, phụ thu, giảm trừ, bồi thường, nợ cũ được duyệt, tổng tiền, đã thanh toán, còn phải trả, trạng thái, ngày thanh toán.
2. `Invoice Items`: Mã hóa đơn, loại dòng, mô tả, nguồn, from/to, số lượng, đơn vị, đơn giá, thành tiền, rule version.
3. `Payments` (nếu người export có quyền): mã hóa đơn, payment ID, phương thức, tham chiếu, số tiền, trạng thái, ngày thanh toán.

Tiền dùng format Excel `#,##0 [$₫-vi-VN]`; số lượng/chỉ số dùng `#,##0.##`; ngày dùng `dd/mm/yyyy`; freeze header, filter, one invoice summary per row. Bản in A4 portrait; nếu quá nhiều lines có thể dùng 2 trang, QR và total chỉ ở trang cuối.

## 11. Notification

| Trigger | Lịch đề xuất | Điều kiện dừng | Nội dung tối thiểu |
|---|---|---|---|
| Invoice sắp hạn | T-3, T-1 | PAID/CANCELLED | mã, period, due date, amount, link thanh toán |
| Đúng hạn | T0 lúc giờ cấu hình | PAID/CANCELLED | nhắc cuối ngày đến hạn |
| Invoice quá hạn | T+1, T+3, T+7; sau đó theo escalation PO | PAID/CANCELLED | số ngày quá hạn, số tiền, CTA thanh toán/liên hệ |
| Contract sắp hết hạn | T-30, T-15, T-7 | renewed/checkout started/terminated | chọn Gia hạn hoặc Chuẩn bị trả phòng |
| Cọc chưa đóng | T-3, T-1, T0 trước deadline | paid/cancelled | deadline, số tiền, hậu quả reservation |
| Checkout | khi requested, settlement issued, payment/refund required | completed/cancelled | bước kế tiếp còn thiếu và deadline |

Mỗi lần gửi tạo `NotificationDelivery` với unique `(aggregate, rule, scheduled_for, channel, recipient)`; retry delivery không tạo notification business mới.

## 12. Acceptance Criteria

| Chức năng | Given / When / Then |
|---|---|
| Thanh toán một lần | Given invoice ISSUED tổng 2.613.000 đ, When gửi payment SUCCESS 2.613.000 đ với key mới, Then tạo đúng một payment và invoice thành PAID. |
| Chặn partial | Given invoice 2.613.000 đ, When gửi 2.000.000 đ, Then API từ chối, không tạo payment và invoice vẫn ISSUED/OVERDUE. |
| Idempotency | Given payment request đã thành công với key K, When gửi lại K, Then trả kết quả payment gốc và không tạo dòng mới. |
| Quá hạn | Given invoice ISSUED qua `hanTra` chưa PAID, When job ngày chạy, Then invoice OVERDUE và gửi tối đa một reminder cho rule/ngày/kênh. |
| Dịch vụ theo người | Given 2 người active cả kỳ và service 50.000 đ/người, When preview invoice, Then có một line 2 × 50.000 đ; thêm xe không đổi line này. |
| Phí xe | Given một xe máy và một ô tô đều active, When tạo draft, Then có line truy vết theo từng xe/fee plan tương ứng, không áp “xe đầu miễn phí” nếu fee plan không nói vậy. |
| Final settlement | Given cọc 3.000.000 đ, damages + công nợ hợp lệ 5.000.000 đ, When chốt checkout, Then khấu trừ 3.000.000 đ và final invoice còn phải thu 2.000.000 đ. |
| Chưa bàn giao | Given final invoice đã PAID nhưng inventory chưa confirmed, When nhấn hoàn tất checkout, Then hệ thống từ chối và phòng không AVAILABLE. |
| Hợp đồng hết hạn | Given ngày kết thúc qua hôm nay nhưng chưa checkout, When job ngày chạy, Then contract EXPIRED, room vẫn OCCUPIED/RENTED và phát notification. |
| Gia hạn | Given contract EXPIRING, When xác nhận giá/kỳ mới, Then tạo amendment bất biến có before/after và contract active với ngày mới. |

## 13. Priority

### P0 – Phải sửa trước

- Chuẩn hóa Invoice/Payment: bỏ partial/overpaid/carry-forward, exact-payment validation, idempotency response, lock/version và audit.
- Tách `FINAL_SETTLEMENT` và chặn hoàn tất checkout nếu chưa thanh toán/hoàn tiền/bàn giao.
- Deposit ledger + deposit settlement; không còn suy cọc chỉ từ trạng thái trên hợp đồng.
- Chốt state transitions contract/invoice/room; tuyệt đối không đổi phòng `AVAILABLE` chỉ vì hợp đồng hết hạn.
- Server-calculated invoice snapshots, metering validation và calculation reconciliation tests.

### P1 – Core nghiệp vụ

- Service catalog/rate version/ContractService với charging basis rõ.
- Vehicle fee plan + assignment history + hóa đơn xe tự sinh theo loại xe.
- ContractTenant effective dates, gia hạn revision đầy đủ.
- Checkout wizard, asset handover và damage assessment.
- Final invoice/settlement, refund process và early-termination policy đã chốt.

### P2 – UX & Reporting

- Invoice UI scan-friendly, A4 print và Excel workbook.
- Dashboard filter theo tòa nhà và KPI vận hành/công nợ/cọc.
- Filter labels nhất quán, money/unit formatting và dữ liệu demo làm tròn dễ đọc.
- Notification policy có cấu hình/dedupe/escalation dashboard.

## 14. Open Questions

| ID | Vấn đề | Các phương án | Khuyến nghị | Cần PO xác nhận |
|---|---|---|---|---|
| OQ-001 | Prorate tiền phòng | Full tháng; theo ngày lịch; 30-day convention | Theo ngày lịch, làm tròn VND cuối dòng | Có |
| OQ-002 | Prorate dịch vụ fixed/per-person | Full tháng; theo ngày; trung bình person-days | Theo basis: fixed full tháng, per-person theo person-days nếu minh bạch | Có |
| OQ-003 | Phí xe giữa tháng | Full tháng; prorate theo ngày; từ kỳ kế tiếp | Prorate theo effective date để công bằng | Có |
| OQ-004 | Xe miễn phí | Không miễn; miễn xe đầu mỗi người/phòng; quota plan | Không hard-code; cấu hình quota trong fee plan nếu cần | Có |
| OQ-005 | Mất cọc | Forfeit toàn bộ; theo khoản thực tế/điều khoản | Chỉ deduct/forfeit có căn cứ và audit | Có |
| OQ-006 | Phạt trả trước hạn | Không phạt; n tháng tiền phòng; theo days notice | Thành rule version trong contract/amendment | Có |
| OQ-007 | Khách ở quá hạn | Day-rate; tháng kế tiếp full; penalty rate | Tách khoản tiền ở quá hạn và penalty, không ngầm | Có |
| OQ-008 | Hoàn cọc | Trước/sau thanh toán final invoice; cash/bank | Hoàn sau final settlement PAID và handover confirmed; có thể workflow refund riêng | Có |
| OQ-009 | Phòng AVAILABLE khi nào | Sau contract expiry; after final invoice; after handover+cleaning | Chỉ sau handover complete và cleaning/maintenance approved | Có |
| OQ-010 | Hóa đơn cọc | Deposit ledger thuần; invoice riêng loại deposit | Giữ chứng từ `DEPOSIT_REQUEST` nếu cần thu tiền, nhưng ledger là nguồn sự thật | Có |
| OQ-011 | Nợ cũ | Cấm; debit note riêng; đưa invoice kỳ sau | Theo yêu cầu hiện tại: cấm carry-forward; chỉ final settlement/debit note được duyệt | Có |
| OQ-012 | Một invoice một payment | Hạn chế tất cả payment; chỉ manual exact payment | Áp dụng cho regular/final; refund tách payment/refund transaction | Có |

## Hướng triển khai an toàn

1. PO chốt các OQ P0 trước, đặc biệt prorate, cọc, phạt và thời điểm trả `AVAILABLE`.
2. Viết migration additive (tables/version/audit) và migration mapping dữ liệu cũ; không đổi enum/unique production trực tiếp trước khi có kế hoạch chuyển đổi.
3. Triển khai P0 phía server cùng integration/concurrency tests, sau đó mới thay UI theo API state/action mới.
4. Chạy reconciliation trên dữ liệu demo: `invoice.total = sum(items)`, `paid = exact payment or 0`, `deposit held = transactions`, `room available chỉ khi checkout completed`.

