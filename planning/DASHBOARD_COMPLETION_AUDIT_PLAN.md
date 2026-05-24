# EasyHouse Dashboard Completion Audit Plan

Ngay lap: 2026-05-24

Pham vi: doi chieu `sql/db.sql`, backend Spring Boot trong `be/`, frontend dashboard trong `frontend/src/app/(dashboard)/dashboard`, API rewrites trong `frontend/next.config.ts`, va sidebar dashboard.

## 0. Tien Do Thuc Hien

Cap nhat: 2026-05-25

Da xu ly trong dot thuc hien dau tien:

- Sua luong `/api/user/profile` de dung `Authentication`/JWT principal thay vi parse Bearer token nhu email.
- Bo fallback hard-code email dev trong `UserController`.
- Them `GET /api/auth/khach-thue/me` de tenant dashboard lay du lieu theo JWT tenant.
- Them `PUT /api/thanh-toan/{id}` va dam bao update payment recalculate hoa don lien quan.
- Sua update payment de khong xoa anh bien lai cu khi payload khong gui `anhBienLai`.
- Them repository va service logic cho `thong_bao_nguoi_nhan`.
- Them `POST /api/thong-bao/{id}/send` va `PATCH /api/thong-bao/{id}/da-doc`.
- Dong bo thong bao: frontend gui `khachThue._id`, backend luu `nguoi_dung_id`, response tra lai `khachThue._id` de form/list van hien dung nguoi nhan.
- Chuan hoa response loai thong bao ve gia tri UI dang dung: `chung`, `hoaDon`, `thanhToan`, `hopDong`, `suCo`, `lichHen`, `congNo`.
- Sua sidebar admin chap nhan role `ADMIN`.
- Them test config rieng trong `be/src/test/resources/application.properties` de `mvn test` dung H2 local, khong cham Supabase/staging.
- Them `POST /api/auth/forgot-password` backend va sua Next route `/api/auth/forgot-password` forward ve backend thay vi success gia.
- Forgot-password hien dung mat khau tam thoi gui qua email, revoke refresh token cu; can nang cap thanh reset-token mot lan dung trong phase bao mat tiep theo.
- Them frontend middleware gan `Authorization: Bearer <session.accessToken>` cho cac request `/api/*` da dang nhap, de dashboard co the goi backend sau khi siết security.
- Sua `SecurityConfig` tu `permitAll` sang require authentication cho dashboard API; chi giu public cho auth, hoa don public, xem phong/toa nha public, va dat lich hen public.
- Them `SecurityConfigTest` kiem tra dashboard API khong token bi chan va forgot-password van public.
- Them `PermissionService` va `NguoiDungNhaTroRepository` lam nen tang permission theo owner/staff/admin.
- Ap permission cho `NhaTroService`: list/detail theo user dang nhap, create gan chu tro tu JWT, update/delete yeu cau quyen ghi.
- Ap permission cho `PhongService`: user dang nhap chi thay/sua phong trong nha tro co quyen; public GET van phuc vu trang xem phong.
- Chan xoa nha tro con phong chua xoa.
- Them `NhaTroServiceTest` cho create owner va chan delete nha tro con phong.
- Ap permission cho `KhachThueService`: list/detail/update/delete loc theo admin, chu tro, tenant self, hoac staff co quyen tren nha tro qua hop dong active.
- Bo fallback lay user dau tien khi tao khach thue; create gan chu tro theo JWT, admin co the truyen `chuTroId`.
- Them `KhachThueServiceTest` cho create owner va chan user khong co quyen xem khach thue.
- Ap permission cho `HopDongService`: list/detail/create/update/delete va danh sach dich vu theo phong deu loc theo admin, chu tro, staff co quyen nha tro, hoac tenant self voi detail/list read.
- Them `HopDongServiceTest` cho chan xem hop dong trai quyen va chan tao hop dong trong nha tro khong co quyen ghi.
- Ap permission cho `HoaDonService`: list/detail/form-data/latest-reading/create/update/delete deu loc theo hoa don/hop dong/phong cua user; tenant self chi duoc doc, owner/staff/admin co quyen ghi moi tao/sua/xoa hoa don.
- Ap permission cho `ThanhToanService`: list/detail/by-hoa-don loc theo quyen doc hoa don; tenant self duoc tao payment cho hoa don cua minh, sua/xoa payment yeu cau quyen ghi nha tro.
- Them test permission cho `HoaDonService` va `ThanhToanService`.

Da verify:

- `npx tsc --noEmit` pass trong `frontend`.
- `mvn -DskipTests clean package` pass trong `be`.
- `mvn test` pass: 15 tests, 0 failures, 0 errors.

Rui ro con lai sau dot nay:

- Da bat `SecurityConfig.anyRequest().authenticated()` cho dashboard API. Can manual E2E local de bat cac route con thieu token/whitelist.
- Backend test da dung H2 local, nhung chua co seed/integration test cho dashboard full flow.
- Forgot-password da co luong that, nhung chua phai reset-token flow chuan co expiry va one-time token rieng.
- Permission theo owner/staff/tenant da co nen tang nhung can tiep tuc phu kin cac module su co/media/bao cao va test E2E truoc khi public/staging that.
- Permission moi ap dung cho toa nha/phong/khach thue/hop dong/hoa don/thanh toan; cac module su co, media, bao cao van can ap tiep.
- Notification mark-read hien co fallback mark all khi frontend admin khong gui nguoi dung cu the; can lam luong per-user sau khi auth/recipient context ro.

## 1. Ket Luan Tong Quan

Dashboard hien tai da co mat bang route va UI cho hau het bang nghiep vu quan trong trong `sql/db.sql`, gom:

- Quan ly co ban: toa nha, phong, khach thue, dich vu, tien ich.
- Tai chinh: cau hinh gia, chi so dien nuoc, hop dong, hoa don, cong no, thanh toan.
- Van hanh: su co, thong bao, lich hen, media, bao cao, audit log, VietQR doi soat, xem web.
- Tai khoan: ho so, cai dat, quan ly tai khoan.

Tuy nhien dashboard chua dat muc "hoan thien giai doan 1" vi cac ly do chinh:

- Auth va authorization chua an toan: backend van `permitAll`, nhieu service chua loc theo owner/staff/tenant.
- Mot so UI goi endpoint chua co hoac endpoint chua du logic.
- Mot so man hinh chi moi CRUD mong, chua bam day du quan he trong SQL.
- Nhieu list API chua pagination va con load toan bang.
- Dashboard tong quan va bao cao con du lieu gia/aggregate tam.
- Test hien tai chua co coverage E2E dashboard va dang co nguy co cham DB Supabase that/staging.

## 2. Do Phu Dashboard Theo SQL

### 2.1. Da Co UI + Backend Nen Tang

| Bang SQL | Dashboard/UI | Backend | Muc do |
|---|---|---|---|
| `nha_tro` | `/dashboard/toa-nha` | `NhaTroController`, `NhaTroService` | Co CRUD co ban, can authorization va owner mapping |
| `phong` | `/dashboard/phong` | `PhongController`, `PhongService` | Co CRUD, anh/tien ich da co huong xu ly, can loc owner va pagination |
| `khach_thue` | `/dashboard/khach-thue` | `KhachThueController`, `KhachThueService` | Co CRUD, can tenant account link va owner rule chat hon |
| `hop_dong` | `/dashboard/hop-dong`, create/edit | `HopDongController`, `HopDongService` | Tuong doi tot, can phu luc/gia han/ket thuc/coc/audit |
| `thanh_vien_hop_dong` | trong hop dong | `ThanhVienHopDongRepository` | Co luu thanh vien, can UI lich su vao/roi ro hon |
| `dich_vu` | `/dashboard/dich-vu` | `DichVuController`, `DichVuService` | Co CRUD mong, can owner/permission va validation |
| `tien_ich` | `/dashboard/dich-vu` tab tien ich | `TienIchController`, `TienIchService` | Co CRUD, can gan phong ro rang va permission |
| `cau_hinh_gia` | `/dashboard/cau-hinh-gia` | `CauHinhGiaController`, `CauHinhGiaService` | Co nen tang, can chot quy tac versioning gia |
| `chi_so_dien_nuoc` | `/dashboard/chi-so-dien-nuoc` | `ChiSoDienNuocController`, `ChiSoDienNuocService` | Co CRUD, can cam sua/xoa khi BILLED va gan hop dong active |
| `hoa_don`, `chi_tiet_hoa_don` | `/dashboard/hoa-don` | `HoaDonController`, `HoaDonService` | Co logic line item, can audit, pagination, status consistency |
| `thanh_toan` | `/dashboard/thanh-toan` | `ThanhToanController`, `ThanhToanService` | Co create/update/delete nen tang, can cancel/refund/audit |
| `su_co` | `/dashboard/su-co` | `SuCoController`, `SuCoService` | Co CRUD, can assignment, chi phi vao hoa don, audit |
| `lich_hen` | `/dashboard/lich-hen` | `LichHenController`, `LichHenService` | Co CRUD, can public booking flow va reminder |
| `file_media` | `/dashboard/media`, upload components | `FileMediaController`, `MediaService`, `UploadController` | Co 2 luong media song song, can chuan hoa |
| `audit_log` | `/dashboard/audit-log` | `AuditLogController`, `AuditLogService` | Chi moi xem, chua ghi log tu cac service quan trong |
| `bank_transaction` | `/dashboard/vietqr-doi-soat` | `BankTransactionController`, `BankTransactionService` | Co manual match, chua co import/webhook/auto-match |

### 2.2. Co Bang SQL Nhung Dashboard/Backend Chua Hoan Chinh

| Bang SQL | Thieu hut |
|---|---|
| `nguoi_dung_nha_tro` | Chua co UI gan staff theo nha tro va service-level permission theo nha tro |
| `nguoi_dung_vai_tro` | Admin user UI chua gan role dung quan he SQL |
| `chu_tro` | Backend hien dung `nguoi_dung` truc tiep; can chot bo hay dung bang `chu_tro` |
| `dat_coc_phong` | Chua co dashboard dat coc rieng, hop dong moi chi co coc hop dong co ban |
| `phu_luc_hop_dong` | Chua co UI/API tao phu luc khi gia han/thay doi gia |
| `lich_su_hoa_don` | SQL co, backend chua ghi lich su khi update status/total/payment |
| `login_history` | SQL co, auth chua ghi login history |
| `thong_bao_nguoi_nhan` | Da co repository/service send/read nen tang, can per-user auth context va retry theo kenh |

## 3. Loi Va Rui Ro Hien Tai

### 3.1. Bao Mat Va Quyen

1. Backend da require authentication cho dashboard API; can tiep tuc kiem tra whitelist public va manual E2E sau khi frontend middleware gan token.
2. JWT da duoc generate; `UserController` da dung principal, nhung can audit tiep cac controller khac.
3. Sidebar admin da chap nhan `ADMIN`, can tiep tuc chuan hoa role label/type tren toan frontend.
4. Da co nen permission owner/staff/admin cho toa nha/phong/khach thue/hop dong; cac service con lai van chua loc du theo `chuTroId`, `nguoi_dung_nha_tro`, hoac tenant ownership.
5. SQL RLS co policy theo `auth.uid()`, nhung backend JPA dang ket noi bang JDBC user; khong nen gia dinh RLS da bao ve dung neu app dung service role hoac pooled connection.

### 3.2. API FE-BE Chua Khop

1. `/api/auth/khach-thue/me`: da them GET endpoint theo JWT tenant, can manual E2E tenant login.
2. `/api/thanh-toan/{id}` PUT: da them update backend, can bo sung audit/cancel-refund policy.
3. `/api/thong-bao/{id}/send` va `/api/thong-bao/{id}/da-doc`: da them endpoint, can hoan thien per-user read context.
4. `/api/auth/forgot-password`: da co backend mapping va Next route forward that; can nang cap reset-token flow.
5. `/api/user/profile`: da sua backend dung JWT principal, can test E2E tren UI ho so.

### 3.3. Truy Van Va Hieu Nang

1. Nhieu service dung `findAll()` hoac load list khong pagination:
   - `BaoCaoService`: load toan bo hoa don/phong/su co/hop dong de aggregate.
   - `ThanhToanService`: load toan bo thanh toan roi sort trong Java.
   - `ChiSoDienNuocService`, `FileMediaService`, `LichHenService`, `DichVuService`, `TienIchService`: list full table.
2. Nhieu frontend goi `limit=100` tam thoi. Can API pagination that: `page`, `limit`, `sort`, filters.
3. Dashboard tong quan nen dung query aggregate rieng, khong load bang qua UI/service.
4. Bao cao doanh thu nen aggregate theo `ky_nam`, `ky_thang`, `ngay_thanh_toan`, `trang_thai`, co index san trong SQL.

### 3.4. Billing/Payment

1. SQL co trigger recalc `hoa_don` tu `chi_tiet_hoa_don` va `thanh_toan`; backend service cung tu set totals/status. Can chot mot nguon tinh chinh va viet test tranh lech status.
2. `ThanhToanService` delete thanh toan cung xoa vat ly, chua co audit/refund/void. Voi tai chinh nen dung cancel/refund adjustment.
3. `ChiSoDienNuocService` cho delete chi so vat ly, chua chan khi `BILLED`.
4. `HoaDonService` da tao line item tu hop dong/cau hinh gia/chi so, nhung can test them cac case: no dau ky, tra du, qua han, sua hoa don paid.

### 3.5. UI/UX Dashboard

1. Sidebar va mot so text dang mojibake, can chuan hoa UTF-8.
2. Dashboard tong quan con du lieu gia trong "Hoat dong gan day".
3. Dashboard co the chia cho 0 khi tong so phong bang 0.
4. Mot so trang moi nhu audit-log, bao-cao, media, VietQR la skeleton/chuc nang mong, can empty/loading/error state va validation ro hon.
5. Cai dat hien nghieng ve local UI setting, chua phai cau hinh he thong/thanh toan/thong bao luu DB.

### 3.6. Test Va Moi Truong

1. Backend test hien co it va chua cover dashboard flow end-to-end.
2. Test dang co nguy co ket noi Supabase/staging qua `application-secrets.properties`; can profile test doc lap bang H2/Testcontainers/local Docker.
3. Frontend `next.config.ts` van ignore build TypeScript/ESLint errors; typecheck manual pass chua du.

## 4. Definition Of Done Cho Dashboard Giai Doan 1

Mot man hinh dashboard chi duoc tick done khi dat tat ca:

- Co route UI trong `/dashboard/...`.
- Co list/table voi loading, empty, error, search/filter.
- Co create/update/delete hoac deactivate dung nghiep vu.
- API backend co DTO request/response, khong expose entity.
- API co pagination va filter can thiet.
- Mapping SQL enum -> Java enum -> DTO -> frontend type/label dung.
- Service co validation nghiep vu va transaction boundary.
- Service co permission theo ADMIN/LANDLORD/STAFF/TENANT.
- Neu lien quan tai chinh/hop dong/user: co audit log.
- Co backend unit/integration test cho luong chinh.
- Co manual E2E da chay qua tren local Docker DB.

## 5. Ke Hoach Xu Ly Theo Phase

### Phase 0 - Dong Bang Hien Trang Va Test Nen

Muc tieu: biet ro dashboard hien tai pass/fail o dau, tranh sua mo.

- [x] Tao profile test backend rieng, khong ket noi Supabase that/staging.
- [ ] Them seed local Docker toi thieu: admin, nha tro, phong, khach thue, hop dong, chi so, hoa don, thanh toan.
- [ ] Viet checklist manual E2E:
  - Dang nhap admin.
  - Tao toa nha.
  - Tao phong.
  - Tao khach thue.
  - Tao hop dong.
  - Ghi chi so.
  - Tao hoa don.
  - Ghi thanh toan.
  - Xem dashboard stats/report.
- [x] Chay `mvn test` va `npx tsc --noEmit`.
- [ ] Chay `npm run build` voi build errors khong bi ignore.
- [ ] Chup lai danh sach endpoint FE dang goi va endpoint BE dang co.

### Phase 1 - Sua Auth, Session, Role, Permission

Muc tieu: dashboard khong con la public API.

- [x] Sua `SecurityConfig`: public chi gom auth, public room, public invoice neu can; cac endpoint dashboard require auth.
- [x] Sua `UserController` dung `Authentication`/JWT claims thay vi coi Bearer token la email.
- [x] Bo fallback hard-code email dev.
- [x] Chot auth source:
  - Neu dung Supabase Auth: backend register phai tao/nhan Supabase user id truoc khi insert `nguoi_dung`.
  - Neu dung backend JWT rieng: can bo FK `nguoi_dung.id -> auth.users.id` hoac dong bo auth.users.
- [x] Sua sidebar role check: chap nhan `ADMIN` thay vi chi `admin`.
- [x] Them permission helper: `canAccessNhaTro`, `canAccessPhong`, `canAccessHopDong`, `canAccessHoaDon`.
  - [x] Nen tang `canRead/canWriteNhaTro` va ap cho toa nha/phong.
  - [x] Ap tiep cho khach thue.
  - [x] Ap tiep cho hop dong.
  - [x] Ap tiep cho hoa don/thanh toan.
- [ ] Gan role/user-to-building qua `nguoi_dung_vai_tro` va `nguoi_dung_nha_tro`.
- [ ] Ghi `login_history`.

### Phase 2 - Dong Bo API Contract FE-BE

Muc tieu: khong con UI goi endpoint chua ton tai.

- [x] Them `GET /api/auth/khach-thue/me` tra tenant dashboard data theo JWT tenant.
- [x] Them `PUT /api/thanh-toan/{id}` hoac bo edit payment khoi UI va thay bang cancel/refund.
- [x] Them `POST /api/thong-bao/{id}/send`.
- [x] Them `PATCH /api/thong-bao/{id}/da-doc?daDoc=...`.
- [x] Them/kiem tra `POST /api/auth/forgot-password` dung frontend dang goi.
- [ ] Chuan hoa `ApiResponse<T>` va `PaginatedResponse<T>` cho moi list API.
- [ ] Xoa cac `form.note.md` cu neu sai hoac cap nhat lai theo endpoint that.

### Phase 3 - Hoan Thien Core CRUD Van Hanh

Muc tieu: cac man hinh co ban van hanh on dinh.

- [x] Toa nha:
  - [x] Loc theo owner/staff/admin.
  - [x] Soft delete, khong xoa neu con phong active.
  - [x] Thong ke nhanh tong phong/phong trong/dang thue.
- [ ] Phong:
  - Pagination/filter theo toa nha, trang thai, tang, gia.
  - [x] Chan xoa phong co hop dong/hoa don.
  - [x] Loc theo owner/staff/admin khi da dang nhap.
  - [x] Chan xoa phong co hop dong active/pending.
  - [x] Chuan hoa anh phong qua `file_media`.
  - [x] Gan tien ich qua `phong_tien_ich`.
- [x] Khach thue:
  - [x] Loc theo chu tro/staff/admin/tenant self.
  - [x] Link optional `nguoi_dung_id`.
  - [x] Lich su thue tu `hop_dong`/`thanh_vien_hop_dong`.
- [x] Dich vu/Tien ich:
  - [x] Dich vu theo owner.
  - [x] Tien ich danh muc global/admin.
  - [x] Khong delete dich vu dang dung trong `dich_vu_hop_dong`/`cau_hinh_gia`, chi deactivate neu can.

### Phase 4 - Hoan Thien Hop Dong

Muc tieu: hop dong la nguon su that cho phong, thanh vien, dich vu, coc.

- [ ] Them flow gia han hop dong tao `phu_luc_hop_dong`.
- [ ] Them flow ket thuc hop dong:
  - Set `ngayKetThucThucTe`.
  - Xu ly `trangThaiCoc`.
  - Cap nhat phong ve AVAILABLE/MAINTENANCE theo thuc te.
- [x] Gan/sua thanh vien hop dong co ngay vao/ngay roi.
- [ ] Tao audit log khi tao/sua/gia han/ket thuc/xoa hop dong.
- [x] Test overlap hop dong active cung phong.

### Phase 5 - Hoan Thien Gia, Chi So, Hoa Don

Muc tieu: hoa don duoc tao tu cau hinh gia + chi so + hop dong, khong nhap tay qua nhieu.

- [x] Cau hinh gia:
  - [x] Khong update gia cu da dung; tao version moi.
  - [x] Ap dung theo `hieuLucTu`, `hieuLucDen`, `dangApDung`.
  - [x] Validate khong overlap gia cung loai/nha tro.
- [x] Chi so dien nuoc:
  - [x] Bat buoc gan phong va hop dong active neu co.
  - [x] Cam sua/xoa khi status `BILLED`; chi cancel voi audit.
  - [x] Upload anh dong ho vao `file_media`.
- [x] Hoa don:
  - [x] Tao tu hop dong active, cau hinh gia ap dung, chi so confirmed.
  - [x] Cap nhat `conLai`, `trangThai` khi co thanh toan.
  - [x] Chan xoa khi da co thanh toan hoac audit cancel.
  - [x] Chot nguon recalc: DB trigger hay service, va viet test dong bo.

### Phase 6 - Hoan Thien Thanh Toan, Cong No, VietQR

Muc tieu: tien vao/ra va cong no dung, audit du.

- [ ] Thanh toan:
  - Chuyen delete vat ly thanh cancel/refund neu da ghi nhan.
  - Da them `PUT /api/thanh-toan/{id}`; con thieu audit.
  - Cap nhat `hoa_don.da_tra`, `trang_thai` trong transaction.
- [ ] Cong no:
  - API aggregate theo khach thue/phong/toa nha/ky.
  - Hien qua han, so ngay qua han, tong no.
  - Tao line item `DEBT` khi chuyen ky.
- [ ] VietQR:
  - Sinh QR theo hoa don.
  - Import/webhook bank transaction.
  - Auto-match theo ma hoa don/so tien/noi dung.
  - Manual match tao thanh toan va audit.

### Phase 7 - Thong Bao, Lich Hen, Su Co, Media

Muc tieu: cac luong van hanh khong chi CRUD.

- [ ] Thong bao:
  - Da luu recipient vao `thong_bao_nguoi_nhan`.
  - Da co mark read nen tang; can hoan thien theo tung nguoi sau khi auth context ro.
  - Send/retry theo kenh `IN_APP`, `EMAIL`, sau do SMS/Zalo.
  - Job nhac hoa don/hop dong/su co.
- [ ] Lich hen:
  - Public booking form.
  - [x] Duyet/huy/hoan thanh/no-show.
  - Nhac lich truoc gio hen.
- [ ] Su co:
  - Phan cong nguoi phu trach.
  - Chi phi sua chua co the tinh vao hoa don.
  - Anh su co qua `file_media`.
- [ ] Media:
  - Hop nhat `/api/upload` va `/api/media` thanh chien luoc ro.
  - Kiem tra file type/size/owner object.

### Phase 8 - Dashboard Tong Quan, Bao Cao, Audit

Muc tieu: dashboard that su phan anh van hanh.

- [x] Dashboard stats:
  - [x] Tong phong, phong trong, dang thue, bao tri.
  - [x] Tong khach dang thue.
  - [x] Doanh thu thang, da thu, chua thu.
  - [x] Hoa don qua han/sap den han.
  - [x] Hop dong sap het han.
  - [x] Su co dang xu ly.
- [x] Thay du lieu gia "Hoat dong gan day" bang audit/recent event API.
- [x] Sua chia 0 khi tong phong = 0.
- [x] Bao cao:
  - [ ] Query aggregate theo thang/nam/toa nha.
  - [x] Khong load toan bo bang trong service.
  - [x] Them chart doanh thu, cong no, ty le lap day.
- [ ] Audit:
  - Ghi audit cho auth, user, hop dong, hoa don, thanh toan, cau hinh gia, su co.
  - UI loc theo bang, nguoi dung, ban ghi, thoi gian.

### Phase 9 - Chat Luong Frontend

Muc tieu: dashboard dung duoc lau dai.

- [x] Sua mojibake UTF-8 trong sidebar va cac page.
- [ ] Bo `ignoreBuildErrors` va `ignoreDuringBuilds` trong `next.config.ts` sau khi fix loi.
- [ ] Chuan hoa `domain-mappers.ts` cho moi DTO moi.
- [ ] Tat ca form co validation client + server.
- [ ] Tat ca table co pagination, sorting, filter.
- [ ] Tat ca destructive action co confirm va error state ro.
- [ ] Them route guard theo role cho dashboard/admin/tenant.

## 6. Thu Tu Uu Tien De Hoan Thanh Dashboard Giai Doan 1

1. Sua auth/security/profile/role admin sidebar.
2. Sua endpoint mismatch: tenant me, payment update/cancel, notification send/read, forgot-password.
3. Chuan hoa test profile va local seed, khong test vao Supabase that.
4. Hoan thien CRUD co ban: toa nha, phong, khach thue, dich vu/tien ich.
5. Hoan thien hop dong: thanh vien, overlap, gia han, ket thuc, coc.
6. Hoan thien cau hinh gia va chi so dien nuoc.
7. Hoan thien hoa don, thanh toan, cong no.
8. Hoan thien thong bao, su co, lich hen, media.
9. Hoan thien dashboard stats, bao cao, audit log.
10. Bat lai build strict, them test, chay E2E local Docker.

## 7. Danh Sach Kiem Tra Truoc Khi Tick Done

- [x] `mvn test` pass voi profile test local.
- [x] `npx tsc --noEmit` pass.
- [ ] `npm run build` pass khi khong ignore TypeScript/ESLint.
- [ ] Docker local restore du `sql/db.sql`.
- [ ] Login duoc bang `admin@easyhouse.local` / `Admin@123`.
- [ ] Manual E2E full flow pass:
  - Tao toa nha.
  - Tao phong.
  - Tao khach thue.
  - Tao hop dong.
  - Ghi chi so.
  - Tao hoa don.
  - Ghi thanh toan.
  - Xem cong no ve 0 khi paid.
  - Dashboard stats cap nhat dung.
- [ ] Khach thue login va xem hoa don cua minh.
- [ ] User khong co quyen khong xem/sua du lieu nha tro khac.
- [ ] Audit log co ban ghi cho hop dong/hoa don/thanh toan.
