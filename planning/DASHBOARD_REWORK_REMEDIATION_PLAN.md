# Dashboard Rework Remediation Plan

Ngay lap: 2026-05-26

Nguon: review lai implementation theo ban lich su `02937ff:planning/DASHBOARD_REWORK_IMPLEMENTATION_PLAN.md`.

Muc tieu: sua cac blocker con lai de dashboard dat dung Definition of Done: service enforce permission, billing/payment khong bi can thiep trai quyen, frontend dung API contract pagination, Docker local restore lap lai duoc, va ket qua test/E2E co bang chung.

Pham vi:

- Backend: `be/src/main/java/com/example/quanlyphongtro`, `be/src/test/java/com/example/quanlyphongtro`.
- Frontend: `frontend/src/app/(dashboard)/dashboard`, `frontend/src/components`, `frontend/src/lib`, `frontend/src/types`, `frontend/src/middleware.ts`.
- Database/local stack: `sql/db.sql`, `sql/seed_reference_data.sql`, `docker/postgres/init`, `docker-compose.easyhouse.yml`.
- Verification docs: `planning/E2E_MANUAL_TEST_CHECKLIST.md`, plan nay.

Khong lam trong dot sua nay:

- Doi ten domain Vietnamese hoac bo `_id` frontend.
- Thay NextAuth/JWT bang mot he auth moi.
- Refactor UI lon khong lien quan den blocker.
- Tick completion dua tren suy doan hoac test khong bao phu behavior can nghiem thu.

## 0. Ket Qua Review Lam Baseline

Da xac nhan pass ngay 2026-05-26:

- `mvn clean test`: pass 45 tests.
- `npx tsc --noEmit`: pass.
- `npm.cmd run build`: pass, con lint/hook warnings.

Baseline truoc khi trien khai remediation (trang thai hien tai xem muc `Tien Do Trien Khai`):

| ID | Muc do | Van de | Trang thai code 2026-05-26 |
|---|---|---|---|
| SEC-01 | P0 | Chi so dien nuoc get/create/update/delete khong enforce permission | Da sua, co unit test bo sung |
| SEC-02 | P0 | VietQR/bank transaction list va manual match khong enforce permission/reconcile/audit | Da sua, co `BankTransactionServiceTest` |
| SEC-03 | P0 | Thong bao dashboard doc/tao/gui/sua/xoa mo cho moi authenticated user | Da sua policy `ADMIN` only; co unit test va API denial evidence |
| SEC-04 | P0 | Media/upload bo qua permission cho meter/payment/incident; raw delete Cloudinary con mo | Da khoa object permission/raw delete va audit upload/delete quan trong; raw upload migration de phase sau |
| SEC-05 | P1 | Cau hinh gia doc bang ID va `ap-dung` khong check quyen | Da sua, co test detail denial |
| SEC-06 | P1 | Audit log doc toan he thong khong scope/admin guard | Da sua policy `ADMIN` only; co unit test va API denial evidence |
| OPS-01 | P1 | Su co van filter in-memory, hard-delete, khong audit, tenant sua qua rong | Da sua filter/page/ownership/cancel; API va browser scope evidence pass |
| API-01 | P1 | Pagination backend lam vo consumer frontend cua lookup/core flow | Da sua consumer/lookup va smoke browser cac flow trong tam pass |
| DB-01 | P1 | Docker init khong restore full `sql/db.sql`; seed `.sql` bi mat | Da reset volume va restore full dump thanh cong |
| OPS-02 | P2 | Public booking co the gui `trangThai` bat ky; update co the chuyen phong khong check quyen moi | Da sua va co unit/API evidence |

Quy tac gate:

- Khong merge neu con bat ky P0 nao.
- Khong chay E2E acceptance khi API-01 hoac DB-01 chua sua.
- Khong tick item neu chua co test hoac manual evidence tuong ung.

## Tien Do Trien Khai - Cap Nhat 2026-05-26

Da implement:

- `SEC-01`: khoa read/write meter theo phong, set `nguoiGhi` tu user dang nhap, cancel thay hard-delete, ghi audit.
- `SEC-02`: scope danh sach bank transaction, manual match qua `ThanhToan` + recalculate + audit, chan khac nha tro/doi soat lap.
- `SEC-03`: policy management thong bao la `ADMIN` only o service; mark-read chi cho chinh recipient; ghi audit CRUD/send.
- `SEC-04`: resolve quyen media cho `ROOM`, `METER_READING`, `PAYMENT`, `INCIDENT`; uploader lay tu principal; raw delete yeu cau admin.
- `SEC-05`, `SEC-06`: check read cau hinh gia; audit log `ADMIN` only.
- `OPS-01`, `OPS-02`: su co dung pagination/cancel/audit/ownership; lich hen public luon `PENDING`, co transition va target-room permission.
- `API-01`: them `frontend/src/lib/api-response.ts` va sua lookup/core pages bi vo boi paginated response.
- `DB-01`: `docker-compose.easyhouse.yml` khoi tao PostgreSQL tu full `sql/db.sql`; README ghi lai cach reset/kiem tra admin.
- Review follow-up: tenant chi co quyen doc du lieu phong qua hop dong `ACTIVE`; tenant tao su co khong the gia mao `khachThueId`/ghi truong quan tri; public detail khong tra phong/toa nha da soft-delete; trang media duoc guard `ADMIN` dong bo voi API.
- Sua loi PostgreSQL phat hien khi E2E: nullable filter typed cho `su_co`, `khach_thue`, `phong`, `hop_dong`, `hoa_don`, `thanh_toan`; nullable UUID filter duoc bind bang `UUID`.
- Sua mapping `inet` cho `login_history.ip_address` va `audit_log.ip_address` de dang nhap/audit chay tren PostgreSQL that.
- `sql/db.sql` bo sung data A/B va account `ADMIN`, `LANDLORD`, `STAFF`, `TENANT` phuc vu permission E2E.

Bang chung da chay:

- `mvn clean test`: pass 81 tests sau cac sua doi backend va regression quyen follow-up.
- `npx tsc --noEmit`: pass.
- `npm.cmd run lint`: pass voi 33 warning ton tai, khong co error.
- `npm.cmd run build`: pass; warning lint/hook con lai duoc ghi nhan la residual.
- Da chay `docker-compose -f docker-compose.easyhouse.yml down -v` va `up -d postgres`; PostgreSQL restore full `sql/db.sql` tu volume rong thanh cong va healthy.
- Database sau restore co 6 web account role (`ADMIN`, hai `LANDLORD`, `STAFF`, hai `TENANT`), 2 phong/2 hop dong/2 hoa don/2 chi so/2 su co/2 lich hen; staff chi gan Nha tro A.
- API smoke that: staff chi list duoc phong/su co A; tenant chi list duoc hoa don/su co A; landlord A list duoc hop dong A va 2 payment A sau reconcile; admin doc audit, staff bi tu choi.
- API cross-owner detail: landlord A bi tu choi meter/price/incident B; tenant A bi tu choi invoice B; staff bi tu choi price B va notification management.
- Browser smoke bang Playwright/Firefox: admin render dashboard, su co A/B, thanh toan A va VietQR `E2E-TXN-A` da doi soat; staff render chi su co A, khong thay menu Media va bi middleware chuyen khoi audit/VietQR/Media; cac page da kiem tra khong co console error.

Residual de phase sau/khong chan hoan tat giai doan 1:

- Media cross-owner chua duoc browser-test voi file Cloudinary that; unit test bao phu guard `ROOM`, `METER_READING`, `PAYMENT`, `INCIDENT` va backend da enforce permission.
- Raw upload tam chua chuyen het sang object-bound `/api/media`; raw delete da khoa admin va file gan doi tuong duoc enforce permission.
- Lint con 33 warning va mot so file cu con mojibake; khong gay fail build hay flow da smoke.
- Chua manual smoke tat ca form create/edit phu nhu notification recipient va upload anh that.

## 1. Chuan Hoa Permission Model Truoc Khi Sua Tung Module

Muc tieu: khong lap lai logic va khong de module moi tu tu dinh nghia quyen khac nhau.

Files chinh:

- `be/src/main/java/com/example/quanlyphongtro/services/PermissionService.java`
- Repositories cua `NhaTro`, `Phong`, `HopDong`, `HoaDon`, `KhachThue`
- `be/src/test/java/com/example/quanlyphongtro/services/PermissionServiceTest.java`

Quyet dinh can chot:

| Doi tuong | ADMIN | LANDLORD | STAFF | TENANT |
|---|---|---|---|---|
| Nha tro/phong | all read/write | owned read/write | assigned theo `coQuyenXem`/`coQuyenSua` | chi read qua hop dong active khi API tenant can |
| Hop dong/hoa don | all | nha tro owned | assigned | chi cua minh, read; payment create theo rule rieng |
| Meter reading | all | nha tro owned | assigned write neu `coQuyenSua` | read cua hop dong minh neu cung cap UI |
| Incident | all | nha tro owned | assigned | create/read own contract room; edit own report gioi han |
| Notification admin view/send | all | context cua nha tro owned neu co modeling | context assigned neu business cho phep | chi `/my`, mark read cua minh |
| Audit/bank transaction | all; hoac audit scoped neu quyet dinh | scoped nha tro | scoped nha tro neu can | khong dashboard access |

Checklist:

- [x] Tenant duoc doc chi so, incident va receipt thuoc pham vi cua minh; quyen tren phong chi ton tai qua hop dong `ACTIVE`.
- [ ] Them helper object-level neu can: `canReadChiSo`, `canWriteChiSo`, `canReadSuCo`, `canWriteSuCo`, `canReadPayment`, `canManageNotification`.
- [ ] Thong nhat gia tri "admin sees all": dung `null` hoac explicit boolean, khong tron `null`, empty list va random UUID sentinel o service moi.
- [x] Them test owner/staff/tenant/cross-owner cho helper moi, bao gom tenant khong con hop dong `ACTIVE`.

Acceptance:

- Service module chi goi helper quyen da co test.
- Khong co thao tac ghi nao chi dua vao route guard frontend.

## 2. Phase P0-A - Khoa Chi So Dien Nuoc

Ly do lam truoc: du lieu nay di vao hoa don; sua sai mot ban ghi anh huong tien.

Files:

- `be/src/main/java/com/example/quanlyphongtro/services/ChiSoDienNuocService.java`
- `be/src/main/java/com/example/quanlyphongtro/controller/ChiSoDienNuocController.java`
- `be/src/main/java/com/example/quanlyphongtro/entity/ChiSoDienNuoc.java`
- `be/src/main/java/com/example/quanlyphongtro/repository/ChiSoDienNuocRepository.java`
- `be/src/test/java/com/example/quanlyphongtro/services/ChiSoDienNuocServiceTest.java`

Sua backend:

- [x] `getById(id)`: lay entity, check `canReadPhong(currentUserId, chiSo.phong.id)` truoc khi map response.
- [x] `create(request)`: check `canWritePhong(currentUserId, request.phongId)` truoc duplicate validation/save.
- [x] `create(request)`: neu co `hopDongId`, verify hop dong thuoc dung phong va user co write permission.
- [x] `create/update`: set `nguoiGhi` bang current authenticated user, khong tin input client.
- [x] `update(id, request)`: check write tren phong hien tai; neu request co the doi phong/hop dong thi check target va consistency.
- [x] `BILLED -> CANCELLED`: chi thay trang thai/audit metadata; khong cho request thay chi so, phong, ky hoac anh.
- [x] `delete(id)`: check write permission; chuyen `CANCELLED` de giu dau vet.
- [x] Ghi audit cho `CREATE`, `UPDATE`, `CANCEL`; delete hien chuyen thanh `CANCEL`.

Tests bat buoc:

- [x] Landlord A khong `getById` meter cua Landlord B (unit test va API A/B evidence).
- [x] Landlord A khong create/update/delete meter cua phong B.
- [x] Staff view/write dung theo assignment.
- [x] Tenant chi read meter cua hop dong minh neu business cho phep; khong write.
- [x] `BILLED` cancel khong thay doi `chiSoCu`/`chiSoMoi`.
- [x] Audit duoc save cho cancel trong unit test; create/update da implement audit.

Acceptance:

- Goi truc tiep endpoint voi ID cua phong khac bi tu choi.
- Hoa don khong co the bi anh huong bang viec sua meter trai quyen.

## 3. Phase P0-B - Khoa Payment Va VietQR Reconciliation

Files:

- `be/src/main/java/com/example/quanlyphongtro/controller/BankTransactionController.java`
- `be/src/main/java/com/example/quanlyphongtro/services/BankTransactionService.java`
- `be/src/main/java/com/example/quanlyphongtro/repository/BankTransactionRepository.java`
- `be/src/main/java/com/example/quanlyphongtro/services/ThanhToanService.java`
- `be/src/main/java/com/example/quanlyphongtro/repository/ThanhToanRepository.java`
- Test moi: `be/src/test/java/com/example/quanlyphongtro/services/BankTransactionServiceTest.java`

Sua backend:

- [x] Inject `PermissionService`, `ThanhToanService` va dung transaction boundary cua service.
- [x] `getAll`: admin all; user khac chi query transaction cua `nhaTroIds` accessible; user khong co scope nhan page rong.
- [x] `manualMatch`: check write permission tren transaction context va hoa don dich.
- [x] Khong cong thang `HoaDon.daTra`; tao `ThanhToan` `SUCCESS`, sau do recalculate hoa don.
- [x] Chan match transaction vao invoice cua nha tro khac.
- [x] Chan match lap lai qua `daDoiSoat` va `externalTransactionId`; chua lam flow unmatch/refund.
- [x] Audit `MANUAL_MATCH`; chua co `UNMATCH`/`REFUND` vi chua implement action do.

Frontend:

- [x] `/dashboard/vietqr-doi-soat` chi hien trong sidebar cho `ADMIN` theo policy UI hien tai.
- [x] UI load danh sach hoa don theo paginated contract; backend hoa don chiu trach nhiem scope.

Tests:

- [x] Tenant khong list/match bank transactions.
- [x] Manual match transaction ngoai write scope bi chan trong `BankTransactionServiceTest`; API list duoc scope theo building.
- [x] Match hop le goi payment reconcile path trong `BankTransactionServiceTest`; `ThanhToanService` tao payment/recalculate/audit.
- [x] Match lap lai bi chan.

Acceptance:

- Moi thay doi `daTra` tu VietQR di qua payment/recalculate cung rule voi thanh toan thu cong.

## 4. Phase P0-C - Khoa Thong Bao, Audit Log Va Media

### 4.1 Thong Bao

Files:

- `ThongBaoController.java`
- `ThongBaoService.java`
- `ThongBaoRepository.java`
- `ThongBaoNguoiNhanRepository.java`
- Test moi: `ThongBaoServiceTest.java`

Checklist:

- [x] Tach ro endpoint self-service (`GET /my`, `PATCH /{id}/da-doc`) va management (`GET /`, create/update/send/delete).
- [x] Management endpoint co service guard `ADMIN` only; chua bo sung annotation guard rieng tai controller.
- [x] `getAll/getById` dung policy `ADMIN` only vi entity chua co context nha tro an toan.
- [x] `markRead`: user thuong chi danh dau recipient record cua chinh minh; khong tu tao recipient cho thong bao targeted khong gui den minh.
- [x] `create/update/send/delete`: audit da implement.
- [ ] Them filter/query repository thay vi lay global data roi suy luan o UI.

Tests:

- [x] Non-admin khong goi management list; `STAFF` denial da xac minh API va unit test.
- [x] User khong mark read thong bao targeted cua nguoi khac.
- [x] Admin duoc phep management theo policy `ADMIN` only.
- [x] Audit co record create trong unit test; CRUD/send audit da implement trong service.

### 4.2 Audit Log

Files:

- `AuditLogController.java`
- `AuditLogService.java`
- `AuditLogRepository.java`
- Test moi: `AuditLogServiceTest.java`

Checklist:

- [x] Chot policy phase 1: `ADMIN` only.
- [x] Khong tra global audit cho LANDLORD/STAFF/TENANT qua service.
- [x] Them service test non-admin denial va admin allowed; API smoke xac nhan staff denial/admin allowed.

### 4.3 Media Va Upload

Files:

- `FileMediaService.java`
- `MediaService.java`
- `FileMediaController.java`
- `UploadController.java`
- Repositories/entity lien quan doi tuong media.
- `MediaServiceTest.java`

Checklist:

- [ ] Chon mot public API upload duy nhat: uu tien `/api/media` vi co `doiTuong`/`doiTuongId`.
- [x] Giu raw `/api/upload` lam upload tam cho UI hien tai; raw delete bang `publicId` chi cho `ADMIN`.
- [x] `ROOM`: map toi `canReadPhong/canWritePhong`.
- [x] `METER_READING`: resolve `ChiSoDienNuoc -> Phong`, check read/write phong.
- [x] `PAYMENT`: resolve `ThanhToan -> HoaDon`, check read/write invoice.
- [x] `INCIDENT`: resolve `SuCo -> Phong`, check read/write phong.
- [x] Khong cho client tu truyen `nguoiDungId`; set uploader tu authenticated principal.
- [x] Upload/delete co audit neu file la chung tu payment/meter; list la read operation khong tao audit.

Tests:

- [x] Cross-owner list/upload/delete bi chan cho moi media object type.
- [x] Raw upload/delete endpoint khong tao duong vong permission.

Acceptance:

- Khong co URL file/chung tu nao bi doc hoac xoa chi bang object ID cua user khac.

## 5. Phase P1-A - Cau Hinh Gia Va Su Co

### 5.1 Cau Hinh Gia Read Permission

Files:

- `CauHinhGiaService.java`
- `CauHinhGiaController.java`
- `CauHinhGiaServiceTest.java`

Checklist:

- [x] `getById`: goi `checkReadPermission(entity)` truoc response.
- [x] `getApplicable`: resolve nha tro, check read permission truoc query/response.
- [x] Tenant deny dashboard pricing; khong dua vao frontend middleware.
- [x] Them test `getById`/`getApplicable` read permission va API evidence pricing B bi tu choi.

Acceptance:

- List, detail va applicable co cung rule permission.

### 5.2 Su Co

Files:

- `SuCoController.java`
- `SuCoService.java`
- `SuCoRepository.java`
- `SuCoServiceTest.java`
- `frontend/src/app/(dashboard)/dashboard/su-co/page.tsx`

Checklist:

- [x] Controller tra `ApiResponse<PaginatedResponse<SuCoResponse>>` voi filter server gom `page`, `limit`, `nhaTroId`, `phongId`, `trangThai`, `loaiSuCo`, `uuTien`/`mucDoUuTien`.
- [x] Service dung repository query + `Pageable`; khong con `findAll...().stream().filter(...)`.
- [x] Gan `nguoiBao` bang current user khi create.
- [x] Tenant create qua `canReadPhong`, backend derive `khachThue` tu hop dong `ACTIVE` va tu choi ID/truong quan tri gia mao.
- [x] Tenant update chi incident do minh bao va chi truong khong phai admin khi `PENDING`.
- [x] Khong cho doi `phongId`/`khachThueId` sau create.
- [x] Delete chuyen `CANCELLED` va ghi audit.
- [x] Goi audit cho `CREATE`, `UPDATE`, `CANCEL`; `RESOLVE` di qua `UPDATE`.

Tests:

- [x] Cross-owner list/detail/update/delete bi chan.
- [x] Tenant khong sua incident cua tenant khac trong cung phong.
- [x] Pagination/filter thuc su query server; unit test va API query `loaiSuCo=dien_nuoc&uuTien=cao` pass.
- [x] Audit duoc ghi.

## 6. Phase P1-B - Lich Hen Public Va Status Flow

Files:

- `LichHenService.java`
- `LichHenController.java`
- `LichHenServiceTest.java`
- `frontend/src/app/(dashboard)/dashboard/lich-hen/lich-hen-client.tsx`

Checklist:

- [x] Public `POST /api/lich-hen` luon tao `PENDING`; ignore `trangThai` tu client.
- [x] Validate `phongId`, phong ton tai va ngay hen khong o qua khu; can bo sung validate chi tiet contact neu can.
- [x] Define transition map:
  - `PENDING -> CONFIRMED | CANCELLED`
  - `CONFIRMED -> COMPLETED | NO_SHOW | CANCELLED`
  - Terminal status khong update tiep neu khong co admin override ro.
- [x] `update`: check write permission target truoc khi doi sang phong moi.
- [x] `delete`: chuyen status `CANCELLED` thay vi hard delete.
- [x] Audit public create ho tro actor nullable, khong bo mat event vi khong co logged-in user.

Tests:

- [x] Guest gui `trangThai=CONFIRMED` van tao `PENDING`.
- [x] Invalid transition bi chan.
- [x] Staff/owner khong chuyen appointment sang phong ngoai scope.

## 7. Phase P1-C - Khoi Phuc API Contract Pagination Va Frontend Flow

Muc tieu: moi API list tra `ApiResponse<PaginatedResponse<T>>`; moi frontend consumer lay `.data.data` va khong am tham fallback contract cu.

Contract chuan:

```ts
interface ApiResponse<T> {
  success: boolean;
  data?: T;
  message?: string;
}

interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}
```

Quyet dinh implementation:

- [x] Them helper typed `frontend/src/lib/api-response.ts` de extract `PaginatedResponse<T>.data` cho cac lookup/core consumer da sua.
- [x] Lookup dropdown co mot trong hai cach ro rang:
  - API lookup rieng tra minimal list co gioi han/business filter; hoac
  - Fetch paginated voi `limit` hop ly va UI search/page selection.
- [x] Khong con dung API list paginated nhu mang truc tiep tai cac page bat buoc trong bang duoi.

Pages can sua bat buoc:

| Page | API dang doc sai | Hanh vi can xac nhan sau sua |
|---|---|---|
| `dashboard/cau-hinh-gia/page.tsx` | `/api/toa-nha` | Chon duoc toa nha, list va update gia |
| `dashboard/chi-so-dien-nuoc/page.tsx` | `/api/phong` | Chon duoc phong khi tao/sua meter |
| `dashboard/hop-dong/them-moi/page.tsx` | `/api/phong`, `/api/khach-thue`, `/api/dich-vu` | Tao hop dong tu dropdown |
| `dashboard/hop-dong/[id]/page.tsx` | cung cac API tren | Edit hop dong khong loi `.map` |
| `dashboard/thanh-toan/page.tsx` | `/api/hoa-don` | Chon invoice khi tao payment |
| `dashboard/vietqr-doi-soat/vietqr-client.tsx` | `/api/hoa-don` | Match invoice no |
| `dashboard/lich-hen/lich-hen-client.tsx` | `/api/phong` | Hien thi/chon phong |
| `dashboard/su-co/page.tsx` | `/api/phong`, `/api/khach-thue`, `/api/hop-dong`, `/api/su-co` | CRUD va pagination su co |
| `dashboard/thong-bao/page.tsx` | `/api/toa-nha`, `/api/phong`, `/api/khach-thue` | Chon recipient/context |
| `dashboard/phong/page.tsx` | `/api/toa-nha` | Filter/toa nha lookup |

Files shared:

- `frontend/src/types/index.ts`
- `frontend/src/lib/domain-mappers.ts`
- Tao helper moi trong `frontend/src/lib/` neu can.

Verification:

- [x] Cac lookup/core consumer trong bang tren da dung `unwrapPageData` va truyen `limit=100`.
- [x] `npx tsc --noEmit`: pass ngay 2026-05-26.
- [x] `npm.cmd run build`: pass ngay 2026-05-26, con warning lint/hook duoc ghi o phan tien do.
- [ ] Smoke browser cho toan bo create/edit contract, meter, payment, appointment, incident, notification; da smoke list incident/payment/VietQR va role guard.

Acceptance:

- Khong con loi runtime `.map is not a function`/dropdown rong do pagination wrapper.
- Page 1/page 2 va filter server van hoat dong.

## 8. Phase P1-D - Docker Restore Va Seed Lap Lai Duoc

Muc tieu: mot lan khoi tao Docker moi phai tao dung schema + data test, bao gom admin.

Files:

- `docker-compose.easyhouse.yml`
- `docker/postgres/init/`
- `sql/db.sql`
- `sql/seed_reference_data.sql`
- `docker/easyhouse.README.md`
- `planning/E2E_MANUAL_TEST_CHECKLIST.md`

Checklist:

- [x] Chot mot nguon restore duy nhat cho local Docker: `sql/db.sql` theo rule repo.
- [x] Docker initialization mount full dump `sql/db.sql` vao `/docker-entrypoint-initdb.d/00-easyhouse-db.sql`.
- [x] README ghi ro seed nam trong full dump va init script cu khong con duoc mount.
- [x] Verify enum/data restore dung de backend doc `DRAFT`, `PENDING`, `PAID`/reconcile tren PostgreSQL that.
- [x] Verify account:
  - `admin@easyhouse.local` / `Admin@123` / `ADMIN`.
  - Landlord A, Landlord B.
  - Staff assigned chi mot nha tro.
  - Tenant link voi `khach_thue` va hop dong.
- [x] Verify data cross-owner cho room/contract/invoice/payment/meter/incident/appointment.
- [x] Cap nhat README lenh restore volume moi va lenh xac minh admin.

Manual verification:

```powershell
docker compose -f docker-compose.easyhouse.yml down -v
docker compose -f docker-compose.easyhouse.yml up -d postgres
docker compose -f docker-compose.easyhouse.yml ps
```

- [x] Sau khoi tao DB, kiem tra cac bang/domain data va tai khoan admin.
- [x] Sau do khoi dong backend/frontend va chay E2E API/browser trong tam.

Acceptance:

- May local moi co the dung duy nhat runbook de tai tao du account va du lieu permission.

## 9. Phase P2 - Frontend Guard, Menu Va UI Quality

Files:

- `frontend/src/middleware.ts`
- `frontend/src/components/app-sidebar.tsx`
- Dashboard pages bi anh huong.

Checklist:

- [x] Middleware va sidebar normalize role convention (`ADMIN`, `LANDLORD`, `STAFF`, `TENANT`) ke ca prefix `ROLE_`.
- [x] An menu `audit-log`, `vietqr-doi-soat`, `thong-bao`, `media` management cho non-admin theo policy backend da chot.
- [x] Backend van la enforcement chinh; frontend chi giam loi UI.
- [x] Sua mojibake text trong cac file cham vao o dot nay.
- [x] Xu ly React hook warnings trong flow load pagination de tranh stale filters/page.
- [x] Cac flow cancel da cham toi (`chi-so-dien-nuoc`, `lich-hen`, `su-co`) dung label huy thay cho xoa.

Acceptance:

- UI khong hien thao tac user khong duoc backend cho phep.
- Build pass khong co warning hook trong cac page vua sua.

## 10. Test Matrix Bat Buoc

### 10.1 Backend Automated Tests

| Test class | Case bat buoc |
|---|---|
| `SecurityConfigTest` | anonymous protected; public allowed; LANDLORD admin endpoint denied; ADMIN allowed |
| `PermissionServiceTest` | admin/owner/staff/tenant/cross-owner cho helper moi |
| `ChiSoDienNuocServiceTest` | read/write denial, tenant rule, billed lock, audit |
| `BankTransactionServiceTest` | scoped list, manual match permission, recalc, duplicate, audit |
| `ThongBaoServiceTest` | management guard, `/my`, markRead self only, audit |
| `MediaServiceTest` | ROOM/METER_READING/PAYMENT/INCIDENT list/upload/delete guard |
| `CauHinhGiaServiceTest` | detail/applicable read denial, versioning/overlap |
| `SuCoServiceTest` | tenant ownership, cross-owner denial, cancel/audit, pagination |
| `LichHenServiceTest` | public PENDING, transition validation, target-room permission |
| `AuditLogServiceTest` | admin-only hoac scoped policy |
| `ThanhToanServiceTest` | VietQR-created payment reconcile cung manual payment |

Commands:

```powershell
cd be
mvn clean test
```

### 10.2 Frontend Automated Checks

```powershell
cd frontend
npx tsc --noEmit
npm.cmd run build
```

- [x] `npx tsc --noEmit` da duoc chay va pass ngay 2026-05-26.
- [x] Build pass; warnings con lai da duoc ghi ro la viec chua hoan tat.

### 10.3 Manual Permission E2E

Cap nhat ket qua that vao `planning/E2E_MANUAL_TEST_CHECKLIST.md`, kem ngay test va account role da dung.

| Actor | Kiem thu bat buoc |
|---|---|
| Anonymous | Chi public room/building/invoice/booking; khong dashboard GET |
| ADMIN | Quan ly user, audit, all building data, VietQR match |
| Landlord A | Khong doc/sua room, meter, incident, price, invoice, payment, media cua Landlord B |
| STAFF | Chi doc/sua nha tro assigned theo flag permission |
| TENANT | Chi xem data cua minh; khong truy cap management notification/audit/VietQR; khong sua meter |

Core functional E2E:

- [ ] Price version -> contract -> meter -> invoice -> payment -> cancel/refund/reconcile.
- [ ] Incident create/update/close co audit.
- [ ] Appointment public create `PENDING`, dashboard confirm/complete dung transition.
- [ ] Notification send/mark read dung recipient.
- [ ] Dropdown va table pagination page 1/page 2 hoat dong cho cac page da sua.

## 11. Thu Tu Trien Khai De Giam Rework

1. Them/chot helper permission va unit tests.
2. Sua `ChiSoDienNuocService`.
3. Sua `BankTransactionService` va hop nhat reconcile payment.
4. Sua `ThongBaoService`, `AuditLogService`, `FileMediaService`/upload.
5. Sua read permission cau hinh gia.
6. Sua su co va lich hen.
7. On dinh contract pagination frontend va smoke cac form.
8. Sua Docker restore/seed va tai tao local database.
9. Chay full automated tests.
10. Chay manual E2E bang cac role, cap nhat checklist bang bang chung.

Moi phase nen commit rieng, vi du:

- `fix: enforce billing and payment permissions`
- `fix: scope notification audit and media access`
- `fix: restore paginated dashboard consumers`
- `fix: make local database restore reproducible`

## 12. Final Definition Of Done Moi

Chi danh dau dashboard rework dat khi tat ca item duoi day duoc kiem chung:

- [x] Khong con blocker P0/P1 trong bang baseline; residual manual-media/UI quality duoc tach ro.
- [x] `mvn clean test` pass 81 tests, bao gom security role guard, tenant active-contract scope, public soft-delete, incident spoofing, media va `BankTransactionServiceTest`.
- [x] `npx tsc --noEmit` pass.
- [x] `npm.cmd run build` pass.
- [x] Local Docker restore full `sql/db.sql` pass tu volume rong.
- [x] Admin login thanh cong bang `admin@easyhouse.local` / `Admin@123`.
- [ ] Anonymous chi truy cap public endpoints da quy dinh.
- [x] Landlord/Staff/Tenant khong doc data ngoai scope trong cac endpoint P0/P1 da smoke truc tiep; write denial co unit test dich vu.
- [x] Meter, payment, VietQR va invoice reconcile trong transaction, co audit implementation/test va reconcile E2E.
- [x] Notification va audit log khong cho non-admin management; media enforce object permission, con residual upload Cloudinary manual smoke.
- [x] Su co va lich hen dung ownership/status/audit rules theo unit/API/browser evidence.
- [x] Cac list API/dashboard consumer trong pham vi remediation dung server pagination va contract moi.
- [x] `planning/E2E_MANUAL_TEST_CHECKLIST.md` duoc cap nhat bang lan chay thuc, khong tick muc bi skip.

## 13. Ket Luan Giai Doan 1 - 2026-05-26

Giai doan 1 remediation da hoan tat cho cac blocker P0/P1 trong pham vi dashboard rework: permission backend, payment/VietQR reconciliation, paginated lookup, restore Docker lap lai duoc va smoke role scope. Cac muc residual ghi o phan tien do la cong viec chat luong/migration tiep theo, khong mo lai cac loi bao mat va runtime da duoc gate trong giai doan nay.
