# Dashboard Rework Implementation Plan

Ngay lap: 2026-05-25

Muc tieu: lam lai cac phan dashboard chua dat sau audit, dua he thong ve trang thai co the tin cay cho giai doan 1: an toan quyen, dung data theo user, API contract ro, audit tai chinh/van hanh day du, build/test lap lai duoc.

Pham vi bat buoc: `sql/db.sql`, backend `be/`, frontend `frontend/`, API rewrite `frontend/next.config.ts`, dashboard route trong `frontend/src/app/(dashboard)/dashboard`.

Khong lam trong dot nay: refactor UI lon, doi ten domain Vietnamese, thay NextAuth bang he auth khac, thay doi schema lon neu co the giai quyet bang service/query.

## 0. Trang Thai Hien Tai Sau Audit

Da pass:

- `mvn clean test`: pass 15 tests.
- `npx tsc --noEmit`: pass.
- Backend da co JWT access/refresh token va `SecurityConfig.anyRequest().authenticated()`.
- Core flow nha tro/phong/khach thue/hop dong/hoa don/thanh toan da co nen tang tot hon truoc.
- `sql/db.sql` co seed admin `admin@easyhouse.local` va role `ADMIN`.

Chua dat:

- `/api/admin/users` chua gioi han role `ADMIN`.
- Public GET `/api/phong/**` va `/api/toa-nha/**` co the lo data dashboard neu khong co token.
- Nhieu service chua co permission theo owner/staff/tenant: cau hinh gia, chi so dien nuoc, su co, lich hen, media, thong bao, dashboard/report.
- Dashboard/report dang aggregate global, khong loc theo user hien tai.
- Cau hinh gia update truc tiep ban ghi cu, chua dung versioning.
- Audit chua phu create/update cho hoa don, cau hinh gia, su co, user/admin, auth.
- Pagination chua that su ap dung cho cac list API core.
- `npm run build` fail trong moi truong network bi chan do `next/font/google`.
- Repo con nhieu script patch/scratch untracked can don truoc khi merge.

## 1. Nguyen Tac Lam Lai

- Moi endpoint dashboard phai xac dinh ro: public, authenticated, hay admin-only.
- Public endpoint chi tra DTO public toi thieu, khong dung chung DTO/list dashboard neu co thong tin noi bo.
- Permission khong chi nam o controller; service phai tu bao ve vi co the duoc goi tu controller khac.
- Moi list API quan trong phai nhan `page`, `limit`, `sort`, filter can thiet va tra `PaginatedResponse<T>`.
- Moi thay doi billing/payment/contract/price/incident/user phai co audit log.
- Khi doi enum/status: check SQL -> Java enum -> DTO -> frontend type -> UI label.
- Khong tick done neu chua co test tuong ung hoac manual E2E ghi ro.

## 2. Phase 0 - Dong Bang Va Don Repo

Muc tieu: co baseline sach truoc khi sua.

- [ ] Chay `git status --short` va phan loai file:
  - [ ] File source dang sua hop le.
  - [ ] File planning/checklist can giu.
  - [ ] File tam can xoa: `be/patch*.py`, `be/scratch_*.txt`.
  - [ ] File `*.note.md` bi delete: xac nhan xoa co chu dich hay restore/cap nhat.
- [ ] Tao snapshot endpoint hien tai:
  - [ ] Backend controller routes.
  - [ ] Frontend `/api/...` calls.
  - [ ] Next rewrite map.
- [ ] Chay verification baseline:
  - [ ] `mvn clean test`.
  - [ ] `npx tsc --noEmit`.
  - [ ] `npm.cmd run build` va ghi loi neu fail do font/network.
- [ ] Cap nhat `planning/DASHBOARD_COMPLETION_AUDIT_PLAN.md`: bo tick cac muc chua dat, hoac them ghi chu "pending rework".

Definition of done:

- Repo khong con file tam ngoai y muon.
- Co danh sach endpoint/call moi nhat.
- Ket qua test/build baseline duoc ghi lai trong planning.

## 3. Phase 1 - Security Va Role Guard

Muc tieu: dashboard API khong bi dung sai quyen.

### 3.1 Admin API

Files chinh:

- `be/src/main/java/com/example/quanlyphongtro/controller/AdminUserController.java`
- `be/src/main/java/com/example/quanlyphongtro/services/UserService.java`
- `be/src/test/java/com/example/quanlyphongtro/config/SecurityConfigTest.java`

Viec can lam:

- [ ] Them role guard cho `/api/admin/users/**`.
  - Uu tien: controller dung `@PreAuthorize("hasRole('ADMIN')")`.
  - Dong thoi service `UserService` nen check `PermissionService.isAdmin(currentUserId)` cho cac thao tac nguy hiem.
- [ ] Bat method security neu chua co: `@EnableMethodSecurity`.
- [ ] Them test:
  - [ ] Khong token -> 401/403.
  - [ ] Token LANDLORD -> 403.
  - [ ] Token ADMIN -> duoc truy cap.
- [ ] Frontend route `/dashboard/quan-ly-tai-khoan` guard role ADMIN.

Acceptance:

- User LANDLORD/STAFF/TENANT khong goi duoc `/api/admin/users`.
- Admin van tao/sua/xoa/gan role/building duoc.

### 3.2 Public Room/Building API

Files chinh:

- `SecurityConfig.java`
- `PhongController.java`, `NhaTroController.java`
- `PhongService.java`, `NhaTroService.java`
- Public pages: `frontend/src/app/xem-phong/page.tsx`

Viec can lam:

- [ ] Khong public dashboard endpoint raw:
  - [ ] Doi whitelist hien tai `/api/phong/**`, `/api/toa-nha/**` thanh endpoint public rieng, vi du `/api/public/phong`, `/api/public/toa-nha`.
  - [ ] Public DTO chi tra thong tin can cho trang xem phong.
- [ ] Dashboard `/api/phong`, `/api/toa-nha` bat buoc authenticated va loc theo permission.
- [ ] Cap nhat frontend public page dung `/api/public/...`.
- [ ] Cap nhat `frontend/next.config.ts` rewrites.
- [ ] Them security tests cho public/dashboard separation.

Acceptance:

- Anonymous chi xem duoc data public.
- Dashboard list khong tra data nha tro/phong cua user khac.

## 4. Phase 2 - Permission Service Phu Kin Dashboard

Muc tieu: moi module chinh deu loc theo ADMIN/LANDLORD/STAFF/TENANT.

### 4.1 Mo Rong PermissionService

Files chinh:

- `PermissionService.java`
- Repositories: `NhaTroRepository`, `PhongRepository`, `HopDongRepository`, `HoaDonRepository`, `KhachThueRepository`

Viec can lam:

- [ ] Them helper:
  - [ ] `canReadPhong(userId, phongId)`
  - [ ] `canWritePhong(userId, phongId)`
  - [ ] `canReadHopDong(userId, hopDongId)`
  - [ ] `canWriteHopDong(userId, hopDongId)`
  - [ ] `canReadHoaDon(userId, hoaDonId)`
  - [ ] `canWriteHoaDon(userId, hoaDonId)`
  - [ ] `canReadKhachThue(userId, khachThueId)`
  - [ ] `accessibleNhaTroIdsForQuery(userId)`
- [ ] Thong nhat convention: admin -> empty filter means all; non-admin -> explicit list ids.
- [ ] Them unit test cho helper permission.

Acceptance:

- Service khac khong can lap lai qua nhieu logic owner/staff/tenant.

### 4.2 Cau Hinh Gia

Files chinh:

- `CauHinhGiaService.java`
- `CauHinhGiaController.java`
- `CauHinhGiaRepository.java`
- `frontend/src/app/(dashboard)/dashboard/cau-hinh-gia/page.tsx`

Viec can lam:

- [ ] List/get/create/update/deactivate phai check write/read nha tro.
- [ ] Admin xem/sua tat ca.
- [ ] Landlord chi quan ly cau hinh gia cua nha tro minh lam chu.
- [ ] Staff chi xem/sua neu co quyen tren `nguoi_dung_nha_tro`.
- [ ] Tenant khong duoc vao dashboard cau hinh gia.
- [ ] `getApplicable` khong duoc lo gia nha tro khac neu la dashboard call.

Acceptance:

- User khong co quyen khong doc/sua duoc cau hinh gia nha tro khac.

### 4.3 Chi So Dien Nuoc

Files chinh:

- `ChiSoDienNuocService.java`
- `ChiSoDienNuocController.java`
- `ChiSoDienNuocRepository.java`
- `frontend/src/app/(dashboard)/dashboard/chi-so-dien-nuoc/page.tsx`

Viec can lam:

- [ ] List theo `phongId`, `nhaTroId`, `kyThang`, `kyNam`, `loai`, `trangThai`.
- [ ] Loc theo permission cua phong/nha tro.
- [ ] Create/update/delete yeu cau write permission tren phong.
- [ ] Tenant chi duoc xem chi so lien quan hop dong cua minh neu can.
- [ ] Set `nguoiGhi` = current user khi tao/sua.
- [ ] Khi `BILLED`, chi cho cancel co audit, khong update chi so.

Acceptance:

- Khong con `findAll()` tra toan bo chi so.
- Co test chan user khac xem/sua chi so trai quyen.

### 4.4 Su Co

Files chinh:

- `SuCoService.java`
- `SuCoController.java`
- `SuCoRepository.java`
- `frontend/src/app/(dashboard)/dashboard/su-co/page.tsx`

Viec can lam:

- [ ] List loc theo phong/nha tro/tenant ownership.
- [ ] Tenant tao su co chi cho phong/hop dong cua minh.
- [ ] Landlord/staff chi xu ly su co trong nha tro co quyen.
- [ ] Delete chuyen soft delete/cancel neu schema cho phep; neu hard delete thi phai co audit va chi admin/owner.
- [ ] Them nguoi phu trach, chi phi sua chua, tinh vao hoa don neu UI/API da co.
- [ ] Goi `logAudit` cho create/update/resolve/delete.

Acceptance:

- User khong doc/sua su co nha tro khac.
- Audit co ban ghi khi tao/sua/dong su co.

### 4.5 Lich Hen

Files chinh:

- `LichHenService.java`
- `LichHenController.java`
- `LichHenRepository.java`
- `frontend/src/app/(dashboard)/dashboard/lich-hen/lich-hen-client.tsx`
- `frontend/src/components/ui/dat-lich-hen-dialog/index.tsx`

Viec can lam:

- [ ] Public booking chi cho `POST /api/lich-hen` voi validation.
- [ ] Dashboard list/update/delete bat buoc auth va loc theo nha tro cua phong.
- [ ] Status flow ro: PENDING -> CONFIRMED/CANCELLED/COMPLETED/NO_SHOW.
- [ ] Reminder job chi doc lich hen can gui va khong gui lap.
- [ ] Audit cho status update/cancel.

Acceptance:

- Anonymous khong list duoc lich hen.
- Owner/staff chi thay lich hen cua nha tro co quyen.

### 4.6 Media/Upload

Files chinh:

- `FileMediaService.java`
- `MediaService.java`
- `UploadController.java`
- `FileMediaController.java`

Viec can lam:

- [ ] Chuan hoa mot chien luoc:
  - Upload raw file -> `/api/media/upload`.
  - Gan URL/replace URL noi bo -> `MediaService`.
- [ ] Check permission theo doi tuong:
  - ROOM -> permission phong.
  - METER_READING -> permission chi so/phong.
  - PAYMENT -> permission hoa don/payment.
  - INCIDENT -> permission su co/phong.
- [ ] File list/delete phai check owner object.
- [ ] Validation file type/size giu lai, them extension allowlist neu can.

Acceptance:

- User khong list/delete media cua object khong co quyen.

### 4.7 Thong Bao

Files chinh:

- `ThongBaoService.java`
- `ThongBaoController.java`
- `ThongBaoNguoiNhanRepository.java`
- `frontend/src/app/(dashboard)/dashboard/thong-bao/page.tsx`

Viec can lam:

- [ ] Dashboard admin/owner list thong bao theo nguoi gui/nguoi nhan/nha tro neu co context.
- [ ] `markRead` khong cho fallback mark all khi khong co `nguoiDungId`; dung current authenticated user.
- [ ] `GET /api/thong-bao/my` la endpoint tenant/user self.
- [ ] Send/retry theo kenh co trang thai recipient ro.
- [ ] Audit cho create/update/send/delete.

Acceptance:

- User chi mark read thong bao cua minh.
- Admin/owner khong vo tinh mark read tat ca recipient.

## 5. Phase 3 - Dashboard Stats Va Bao Cao Theo Permission

Muc tieu: so lieu dashboard dung voi nguoi dang nhap.

Files chinh:

- `DashboardService.java`
- `BaoCaoService.java`
- `CongNoService.java`
- `HoaDonRepository.java`
- `PhongRepository.java`
- `ThanhToanRepository.java`
- `SuCoRepository.java`
- Frontend dashboard/report pages.

Viec can lam:

- [ ] Moi aggregate nhan current user va filter nha tro accessible.
- [ ] Repository query aggregate theo danh sach `nhaTroIds`.
- [ ] Admin aggregate all.
- [ ] Landlord aggregate nha tro minh lam chu.
- [ ] Staff aggregate nha tro duoc gan quyen.
- [ ] Tenant dashboard dung endpoint tenant rieng, khong dung dashboard admin.
- [ ] Them test:
  - [ ] Admin thay all.
  - [ ] Landlord A khong tinh data landlord B.
  - [ ] Staff chi tinh nha tro assigned.
  - [ ] Tenant khong goi duoc admin stats.

Acceptance:

- Dashboard, bao cao, cong no khong con so global cho non-admin.

## 6. Phase 4 - Billing, Pricing, Payment Chuan Hoa

Muc tieu: tai chinh co nguon tinh ro va co audit.

### 6.1 Cau Hinh Gia Versioning

Viec can lam:

- [ ] Update gia khong sua record cu da tung ap dung.
- [ ] Khi update:
  - [ ] Dong record cu: set `hieuLucDen = newHieuLucTu - 1`, `dangApDung=false` neu can.
  - [ ] Tao record moi voi `hieuLucTu`.
- [ ] Validate overlap cho tat ca loai can doc quyen, khong chi dien/nuoc neu business yeu cau.
- [ ] Them audit CREATE/UPDATE_VERSION/DEACTIVATE.
- [ ] Them test overlap/versioning.

Acceptance:

- Hoa don cu van truy nguyen duoc gia tai thoi diem lap.

### 6.2 Hoa Don

Viec can lam:

- [ ] Them audit CREATE/UPDATE/CANCEL/SEND.
- [ ] Chan update hoa don PAID/OVERPAID tru khi action dieu chinh ro rang.
- [ ] Chot service la nguon recalc chinh, DB trigger chi la safety net hoac bo trigger neu gay lech.
- [ ] Latest reading query dung `chi_so_dien_nuoc`, khong parse text line item.
- [ ] Them test:
  - [ ] No dau ky.
  - [ ] Tra du/tra thua.
  - [ ] Qua han.
  - [ ] Sua hoa don da co payment bi chan.

Acceptance:

- `tongTien`, `daTra`, `conLai`, `trangThai` khop voi line item va payment.

### 6.3 Thanh Toan

Viec can lam:

- [ ] `delete` da cancel, tiep tuc bo hard delete tren UI wording.
- [ ] Them cancel/refund model ro neu can: CANCELLED, REFUNDED.
- [ ] Tenant create payment chi cho invoice cua minh, status co the PENDING neu can landlord approve.
- [ ] Owner/staff/admin moi update/cancel payment.
- [ ] Audit CREATE/UPDATE/CANCEL/REFUND.
- [ ] VietQR manual match tao payment va audit.

Acceptance:

- Huy/thay doi payment luon recalculate hoa don trong transaction.

## 7. Phase 5 - Pagination, Filter, Contract API

Muc tieu: khong load toan bo bang trong dashboard.

List API can doi sang `PaginatedResponse<T>`:

- [ ] `/api/toa-nha`
- [ ] `/api/phong`
- [ ] `/api/khach-thue`
- [ ] `/api/hop-dong`
- [ ] `/api/hoa-don`
- [ ] `/api/thanh-toan`
- [ ] `/api/su-co`
- [ ] `/api/thong-bao`
- [ ] `/api/chi-so-dien-nuoc`
- [ ] `/api/cau-hinh-gia`
- [ ] `/api/lich-hen`
- [ ] `/api/media`
- [ ] `/api/dich-vu`
- [ ] `/api/tien-ich`
- [ ] `/api/cong-no`

Viec can lam:

- [ ] Backend controller nhan `page`, `limit`, `sort`, filters.
- [ ] Repository dung `Pageable` hoac custom aggregate query, khong paginate sau khi `findAll`.
- [ ] Frontend data table dung server pagination.
- [ ] Bo cac `limit=100` tam thoi.
- [ ] `frontend/src/types/index.ts` chuan hoa `ApiResponse<T>` va `PaginatedResponse<T>`.
- [ ] Cap nhat `frontend/src/lib/domain-mappers.ts` cho DTO moi.

Acceptance:

- Data table load page 1/2 dung, filter/sort khong lay full table.

## 8. Phase 6 - Frontend Build Va Route Guard

Muc tieu: build production lap lai duoc va UI khong hien route sai role.

Files chinh:

- `frontend/src/app/layout.tsx`
- `frontend/src/middleware.ts`
- `frontend/src/components/app-sidebar.tsx`
- Dashboard pages.

Viec can lam:

- [ ] Xu ly `next/font/google`:
  - Lua chon A: chuyen sang local fonts.
  - Lua chon B: dung system font stack.
  - Lua chon C: dam bao CI/local build co network.
- [ ] Them route guard:
  - [ ] `/dashboard/quan-ly-tai-khoan`: ADMIN only.
  - [ ] `/dashboard/cau-hinh-gia`: ADMIN/LANDLORD/STAFF co quyen.
  - [ ] `/dashboard/*`: khong cho TENANT neu day la admin dashboard.
  - [ ] `/khach-thue/dashboard`: TENANT only.
- [ ] Sidebar loc menu theo role va permission.
- [ ] Tat ca destructive action co confirm + error state.
- [ ] Tat ca form core co client validation bang Zod/React Hook Form neu dang dung.
- [ ] Sua mojibake text con lai trong file UI.

Acceptance:

- `npm.cmd run build` pass trong moi truong offline hoac co cach build duoc lap lai.
- Role khong phu hop khong thay route/menu va backend van chan neu goi truc tiep.

## 9. Phase 7 - SQL Va Local Data

Muc tieu: schema/data khop code va manual E2E lap lai duoc.

Files chinh:

- `sql/db.sql`
- `sql/data.sql`
- `sql/seed_reference_data.sql`
- `docker-compose.easyhouse.yml`

Viec can lam:

- [ ] Check enum SQL vs Java:
  - [ ] `trang_thai_phong` / `TrangThaiPhong`
  - [ ] `trang_thai_hop_dong` / `TrangThaiHopDong`
  - [ ] `trang_thai_hoa_don` / `TrangThaiHoaDon`
  - [ ] `trang_thai_thanh_toan` / `TrangThaiThanhToan`
  - [ ] `loai_muc_hoa_don` / `LoaiMucHoaDon`
  - [ ] `trang_thai_chi_so` / `TrangThaiChiSo`
  - [ ] `vai_tro_he_thong` / `VaiTroHeThong`
- [ ] Dam bao `sql/db.sql` restore full schema + data.
- [ ] Dam bao admin login:
  - Email: `admin@easyhouse.local`
  - Password: `Admin@123`
  - Role: `ADMIN`
- [ ] Seed du lieu toi thieu:
  - [ ] 2 landlord khac nhau.
  - [ ] 1 staff assigned mot nha tro.
  - [ ] 1 tenant linked khach thue.
  - [ ] Nha tro/phong/hop dong/hoa don/payment cho tung owner.
- [ ] Manual E2E permission:
  - [ ] Landlord A khong xem/sua data Landlord B.
  - [ ] Staff chi xem/sua nha tro assigned.
  - [ ] Tenant chi xem hoa don/hop dong cua minh.

Acceptance:

- Restore Docker local xong co du account va data test permission.

## 10. Phase 8 - Test Coverage Bat Buoc

Backend tests:

- [ ] `SecurityConfigTest`: public/auth/admin/dashboard route.
- [ ] `PermissionServiceTest`: owner/staff/tenant/admin.
- [ ] `AdminUserServiceTest`: admin only.
- [ ] `CauHinhGiaServiceTest`: permission, overlap, versioning.
- [ ] `ChiSoDienNuocServiceTest`: permission, BILLED lock, cancel.
- [ ] `SuCoServiceTest`: tenant create, owner update, cross-owner blocked.
- [ ] `LichHenServiceTest`: public create, dashboard access blocked.
- [ ] `MediaServiceTest`: object permission.
- [ ] `DashboardServiceTest`: aggregate scoped by user.
- [ ] `BaoCaoServiceTest`: aggregate scoped by user.
- [ ] `HoaDonServiceTest`: audit, paid update blocked, recalc.
- [ ] `ThanhToanServiceTest`: tenant create, owner cancel, recalc.

Frontend checks:

- [ ] `npx tsc --noEmit`.
- [ ] `npm.cmd run build`.
- [ ] Manual browser smoke:
  - [ ] Login admin.
  - [ ] Login landlord A.
  - [ ] Login staff.
  - [ ] Login tenant.
  - [ ] Route/menu guard dung.
  - [ ] Core CRUD flow pass.

## 11. Thu Tu Lam Khuyen Nghi

1. Don repo va cap nhat checklist audit cho dung thuc te.
2. Khoa `/api/admin/users` bang ADMIN role.
3. Tach public room/building endpoint khoi dashboard endpoint.
4. Mo rong `PermissionService`.
5. Ap permission cho cau hinh gia va chi so dien nuoc.
6. Ap permission cho su co, lich hen, media, thong bao.
7. Scope dashboard/report/cong no theo user.
8. Hoan thien pricing versioning va audit.
9. Hoan thien pagination core API va frontend tables.
10. Fix frontend build font/route guard.
11. Update SQL seed permission va manual E2E.
12. Chay full verification va chi tick done khi pass.

## 12. Final Definition Of Done

Chi coi dashboard giai doan 1 hoan thanh khi tat ca muc sau pass:

- [ ] `mvn clean test` pass.
- [ ] `npx tsc --noEmit` pass.
- [ ] `npm.cmd run build` pass.
- [ ] Docker local restore full `sql/db.sql` pass.
- [ ] Admin login duoc bang `admin@easyhouse.local` / `Admin@123`.
- [ ] Anonymous chi xem duoc public room/building/invoice/booking endpoint.
- [ ] Non-admin khong xem/sua du lieu nha tro khac.
- [ ] Tenant chi xem du lieu cua minh.
- [ ] Dashboard stats/report/cong no scoped dung theo user.
- [ ] Billing/payment status reconcile voi line items va payments.
- [ ] Audit log co ban ghi cho user/admin, auth, hop dong, hoa don, thanh toan, cau hinh gia, su co, lich hen.
- [ ] Tat ca list API core co server pagination/filter.
- [ ] Manual E2E full flow pass va duoc cap nhat trong `planning/E2E_MANUAL_TEST_CHECKLIST.md`.
