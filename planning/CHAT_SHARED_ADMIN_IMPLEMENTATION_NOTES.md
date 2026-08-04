# Chat Ban quan ly dung chung - Implementation Notes

Ngay bat dau: 2026-08-04

## Muc tieu

- Kenh `SUPPORT` la hop thu dung chung cua Ban quan ly.
- Moi admin dang hoat dong deu nhin thay va co the tra loi.
- Chu tro va nhan vien duoc gan quyen nha tro van duoc tham gia dung pham vi.
- Moi cau tra loi hien dung danh tinh nguoi gui va duoc tat ca thanh vien kenh nhan thay.
- Chat `DIRECT` va nhom tu tao van chi danh cho thanh vien cua chinh hoi thoai.
- Tin cua nguoi dang xem phai nam ben phai; tin cua moi nguoi khac nam ben trai,
  giong Messenger, ke ca trong chat DIRECT va SUPPORT nhieu admin.

## Phat hien khi doc source

### Backend

- `CuocTroChuyenService.layHoacTaoHoTro()` tao khoa theo `support_<nhaTroId>_<nguoiGoiId>`, nen moi nguoi thue co mot kenh ho tro rieng tai tung nha tro.
- Thanh vien kenh ho tro hien chi duoc tinh mot lan luc tao: nguoi goi, chu tro va cac dong `nguoi_dung_nha_tro` co quyen xem/sua.
- Admin he thong trong `nguoi_dung_vai_tro` chua duoc them vao kenh neu khong dong thoi la chu tro/nhan vien duoc gan nha tro.
- Hoi thoai da ton tai khong duoc doi chieu lai thanh vien, nen admin duoc them sau khong thay kenh cu.
- `CuocTroChuyenRepository.danhSachCuaToi()` chi tra hoi thoai co ban ghi thanh vien dang hoat dong.
- `ChatPermissionService` chi cho doc/gui khi la thanh vien dang hoat dong. Day la bien bao mat can giu nguyen de admin khong doc duoc chat `DIRECT` cua nguoi khac.
- Realtime fan-out trong `TinNhanService` lay toan bo thanh vien dang hoat dong, nen khi membership cua `SUPPORT` dung thi moi admin se cung nhan tin.

### Frontend

- Admin va khach thue dung chung `ChatPanel` va `useChat`.
- Loai `SUPPORT` da co nhan "Ban quan ly", nhung phan mo ta chua noi ro day la hop thu dung chung.
- Ten hoi thoai `SUPPORT` hien duoc suy nhu chat 1-1; khi co nhieu admin co the thanh danh sach ten dai va kho phan biet nguoi yeu cau ho tro.

### Database local

- Dump `sql/easyhouse-after-fix.sql` hien chua co cac bang `cuoc_tro_chuyen`, `thanh_vien_cuoc_tro_chuyen`, `tin_nhan`.
- Repo da co chuoi migration chat ngay 2026-07-22, nhung `docker-compose.easyhouse.yml` chua mount chuoi nay khi khoi tao volume moi.
- Chuoi day du gom: chat module, info panel, mute-until, P8, moderation va search; `add_mute_until` la bat buoc vi entity hien co cot `tatThongBaoDen`.
- Can chay migration chat theo thu tu va them migration backfill admin cho cac kenh `SUPPORT` hien huu.

## Quyet dinh trien khai

- Dong bo membership `SUPPORT` theo du lieu hien tai, khong chi luc tao.
- Thanh vien bat buoc cua `SUPPORT`: nguoi tao kenh, moi ADMIN dang `ACTIVE`, chu tro, nhan vien nha tro co quyen xem/sua.
- Khi quyen bi thu hoi, thanh vien quan ly khong con hop le se duoc dat `roi_luc`; khong xoa row de giu lich su.
- Chi ap dung dong bo tu dong cho `SUPPORT`; tuyet doi khong mo rong quyen cho `DIRECT` hoac `GROUP`.
- Khach thue thay ten "Ban quan ly"; admin thay ten nguoi gui yeu cau de de phan biet cac ticket chat.

## Checklist dang lam

- [x] Doc luong backend, frontend, permission va realtime.
- [x] Xac minh schema Docker hien thieu bang chat.
- [x] Sua dong bo thanh vien kenh `SUPPORT`.
- [x] Sua ten/mo ta giao dien kenh dung chung.
- [x] Them migration va cau hinh Docker khoi tao chat.
- [x] Them test tu dong cho admin dung chung va chat rieng.
- [x] Test API va browser voi khach thue + it nhat hai admin.
- [ ] Kiem tra va sua can trai/phai tin nhan theo nguoi dang dang nhap.

## Ket qua test

- Backend targeted tests da chay trong container `easyhouse-backend`:
  `ChatMembershipServiceTest`, `CuocTroChuyenServiceTest`,
  `ChatPermissionServiceTest`, `CuocTroChuyenResponseTest`.
- Ket qua: 32 tests, 0 failures, 0 errors, 0 skipped; Maven `BUILD SUCCESS`.
- Da ap dung thanh cong du 7 migration chat vao PostgreSQL Docker theo dung thu tu.
- Migration chia se SUPPORT ket qua `INSERT 0 0` vi database moi chua co hoi thoai cu can backfill.
- Da restart backend; Spring khoi dong thanh cong sau 42.111 giay.
- `GET /actuator/health` tra HTTP 200, tong the `UP`; PostgreSQL va Redis deu `UP`.
- Backend, frontend va PostgreSQL Docker deu dang chay; PostgreSQL o trang thai healthy.
- Frontend targeted ESLint cho `ChatPanel.tsx` va `BangThongTin.tsx`: 0 errors,
  1 warning co san (`Users` import chua dung trong `ChatPanel.tsx`).
- Da tao tam `admin2@easyhouse.local` (ACTIVE/ADMIN, UUID ket thuc `0002`) de test
  dung tinh huong hai admin; se xoa du lieu QA sau khi browser test xong.
- Lan smoke test API dau tien dung ngay o tenant login: `0396822875` khong con
  dung mat khau mac dinh `123456` (`Mat khau khong dung`); chua chay cac buoc chat.
- Huong xu ly QA: luu nguyen hash hien tai, dat hash tam co biet mat khau, test,
  sau do khoi phuc dung hash ban dau de khong lam thay doi tai khoan that.
- Sau khi dat mat khau QA tam va dang nhap thanh cong ca tenant + hai admin,
  `POST /api/tin-nhan/hoi-thoai/ho-tro` phat hien loi runtime 500:
  Hibernate khong khoi tao duoc lazy proxy `NguoiDung` cua chu tro ngoai session.
- Unit test mock khong bat duoc loi persistence nay; can sua transaction/fetch truoc
  khi tiep tuc API va browser test.
- Da sua loi lazy proxy bang cach query truc tiep UUID chu tro/nhan vien dang ACTIVE
  theo `nhaTroId`; luong tinh membership khong con doc entity quan he lazy.
- Chay lai targeted suite sau fix: 32 tests, 0 failures, 0 errors, `BUILD SUCCESS`.
- Backend da san sang lai va health tra 200 sau khi compile.
- Smoke test API sau fix: PASS toan bo.
- SUPPORT `337bc99e-...` co dung 3 thanh vien (tenant, admin A, admin B).
- Ca admin A va admin B deu thay SUPPORT; admin B doc duoc tin tenant va cau tra
  loi cua admin A.
- DIRECT `ccdaec1a-...` chi co admin A + tenant; admin B khong thay trong danh sach
  va goi doc truc tiep nhan HTTP 403.
- Browser tenant: thay ten `Ban quan ly`, mo kenh thay copy `Hop thu chung - Ban
  quan ly cung tiep nhan va tra loi`, gui tin QA tu UI thanh cong.
- Browser admin A: thay ca SUPPORT va DIRECT, SUPPORT hien `3 thanh vien`, gui cau
  tra loi QA tu UI thanh cong.
- Browser admin B: chi thay SUPPORT (khong co DIRECT), mo kenh thay du tin tenant,
  admin A va cau tra loi moi cua admin A.
- Console/browser phat hien realtime dang hong: STOMP lap canh bao `Thieu token xac
  thuc`, UI hien `Mat ket noi - se tu noi lai`. REST chat van hoat dong nhung can
  sua token WebSocket de dam bao admin khac nhan ngay khong can reload.
- Da sua WebSocket tenant lay token tu `/api/auth-tenant/session`; admin van dung
  `/api/auth/session`.
- Browser test song song sau fix: tenant khong con banner mat ket noi, console khong
  con STOMP warning, tenant gui `QA_REALTIME_SHARED_20260804...` va admin B nhan
  ngay tren tab dang mo ma khong reload.
- Da don du lieu QA: xoa dung 2 hoi thoai test (cascade tin/thanh vien), xoa admin2
  va 3 login-history cua tai khoan tam, khoi phuc dung hash mat khau tenant ban dau.
- Hau kiem: 0 hoi thoai QA, 0 admin QA, tenant hash restored = true.
- Full `tsc --noEmit` hien khong sach do cac loi co san/khong thuoc chat trong
  `frontend/src/components/mobile-app/ui/calendar.tsx`, `chart.tsx`,
  `resizable.tsx` (API type cua dependency da doi). Khong sua cac file ngoai pham vi.
- Targeted ESLint cua cac file chat/WebSocket da sua: 0 errors; con 1 warning import
  `Users` co san trong `ChatPanel.tsx`.
- Kiem tra can trai/phai: `BongBongTin` da co `items-end/items-start` va
  `flex-row-reverse/flex-row`; CSS da co y dinh dung. Quyen so huu tin hien phu
  thuoc hoan toan vao phep so san `tin.nguoiGuiId === nguoiDungId`.
- `nguoiDungId` hien duoc giai ma tu claim `sub` cua access token trong
  `use-chat.ts`. Neu token khong giai ma duoc hoac `sub` khac dinh dang UUID ma
  API tin nhan tra ve, moi tin deu thanh `cuaToi = false` va cung nam ben trai.
- Buoc ke tiep: doc gia tri runtime cua session/token, `nguoiDungId`,
  `nguoiGuiId` va class/toa do DOM tren browser truoc khi chon diem sua.
- Trang admin hien tai tai `/dashboard/tin-nhan` tai binh thuong, khong co overlay
  hay console warning/error, nhung danh sach trong vi du QA da duoc don nen khong
  con tin de do can trai/phai.
- De test lai ma khong sua mat khau du lieu that, se tao bo QA co UUID/phone/email
  co dinh: mot tenant co hop dong ACTIVE tai phong trong, mot ADMIN phu; mat khau
  QA sao chep hash cua tai khoan admin local nen khong doc/xuat hash ra ngoai.
- Sau test se xoa hoi thoai/tin/thanh vien, login/refresh record, hop dong,
  khach thue va hai nguoi dung QA theo dung UUID co dinh.
- Da tao thanh cong bo QA tach biet: 2 `nguoi_dung` (ADMIN B + tenant), 1
  `khach_thue`, 1 `hop_dong ACTIVE` tai phong `8dc80125-...`; khong thay doi
  trang thai phong hay bat ky tai khoan that nao.
- API da tao SUPPORT va ba tin rieng cua tenant, admin A, admin B. Khi goi lai
  `POST /hoi-thoai/ho-tro` tren kenh da ton tai, backend phat sinh 500:
  `Could not initialize proxy NhaTro ... - no session`.
- Day la mot regression persistence rieng cua nhanh "hoi thoai da ton tai": lan
  tao dau con entity `NhaTro` dang duoc nap, lan sau repository tra conversation
  co quan he lazy roi `dungResponse` doc no ngoai transaction. Can sua transaction
  boundary/fetch va them regression test cho lan goi thu hai.
- Da sua lookup get-or-create bang `@EntityGraph(nhaTro, nguoiTao)`, khong them
  transaction ngoai nen van giu duoc co che bat unique-key race cua factory.
- Targeted backend suite sau sua: 32 tests, 0 failures/errors, BUILD SUCCESS.
- Restart backend va goi lai SUPPORT cu: PASS, khong con 500; tenant nhan ten
  `Ban quan ly - HH1A`, kenh co dung 3 thanh vien.
- Da tao DIRECT QA giua admin B va tenant; admin A khong thay trong danh sach va
  doc truc tiep nhan HTTP 403, trong khi admin B van thay SUPPORT. Yeu cau chat
  chung/chat rieng tiep tuc dung sau khi sua persistence.
- Browser admin A sau khi dang nhap lai: SUPPORT mo duoc, co du 3 tin. Do DOM:
  tenant `items-start` (bubble x=665), admin A `items-end` (x=994), admin B
  `items-start` (x=665), tren cung khung rong x=633..1180. Goc nhin admin A dang
  can dung trai/phai.
- Phien admin cu truoc khi dang nhap lai tung hien `Forbidden` khi mo hoi thoai;
  dang nhap lai het loi. Day la dau hieu session/token cu da stale sau cac lan
  backend restart, khong phai permission DB vi cung account voi token moi doc duoc.
- Browser admin B: danh sach co ca SUPPORT va DIRECT. Trong SUPPORT, tin admin B
  o phai; tenant/admin A o trai. Trong DIRECT, tin admin B o phai va tenant o
  trai. Ownership/alignment dung o goc nhin admin B.
- Browser tenant QA moi dang nhap: REST tai du SUPPORT + DIRECT, nhung realtime
  lap canh bao `[chat] STOMP error: Thieu token xac thuc` va UI hien `Mat ket noi`.
  Fix WebSocket truoc do chua bao phu duoc session tenant moi; can doc lai cach
  `ws-client` chon endpoint session va test lai bang phien dang nhap moi.
- Tab tenant moi hoan toan van lap lai loi, nen khong phai singleton bi keo tu
  chuoi doi account trong cung tab. `SessionProvider` co token (REST chat tai du),
  nhung `layTokenMoi()` co the nhan session custom chua co `accessToken` va gui
  STOMP CONNECT khong Authorization.
- Sua `ChatSocket.connect(token)`: nhan va luu token truc tiep tu `useChat`/
  `TenantProvider`; moi lan reconnect van thu doc session de refresh, neu endpoint
  chua tra token thi fallback token dang co thay vi gui CONNECT rong.
- Sau restart frontend de Turbopack nap source moi, tab tenant sach khong con banner
  mat ket noi va console 0 warning/error. Viec reload tab cu van giu log lich su,
  nen ket luan dua tren tab moi hoan toan.
- Browser tenant: SUPPORT hien tin tenant o phai (bubble x=1005..1185), admin A/B
  o trai (x=417..); DIRECT hien tenant o phai (x=1016..1200), admin B o trai.
- Ket luan alignment: CSS/ownership hien tai da dung o ca admin A, admin B, tenant,
  SUPPORT va DIRECT. Khong sua them `ChatPanel` de tranh tao regression; loi nguoi
  dung tung thay kha nang cao den tu session/bundle cu truoc khi dang nhap/reload.
- Realtime browser: tenant gui `QA_REALTIME_TENANT_TO_ADMINS_20260804` tu UI;
  admin A dang mo SUPPORT nhan ngay khong reload, tin den o trai, console admin 0
  warning/error. Tab tenant sach cung 0 warning/error.
- Targeted ESLint cac file chat: 0 errors, 0 warnings (da bo import `Users` khong
  dung trong `ChatPanel.tsx`). TypeScript sau khi sua cast token khong con loi o file chat;
  full `tsc` chi con cac loi co san trong `mobile-app/ui/calendar.tsx`, `chart.tsx`,
  `resizable.tsx`.
- `git diff --check` theo file chat PASS. Check toan repo bi chan boi trailing
  whitespace co san tai `frontend/src/app/phong/[id]/page.tsx:377`, file ngoai
  pham vi ma nguoi dung da yeu cau bo qua.
- Da don sach bo QA: 0 user, tenant, contract, conversation, membership, message,
  login-history QA con lai; refresh token/audit record QA cung da xoa.
- Migration `20260804_share_support_with_admins.sql` chay lai PASS, `INSERT 0 0`,
  xac nhan idempotent.
- Health cuoi: backend `UP`, PostgreSQL `UP`, Redis `UP`, frontend HTTP 200; ca 4
  container backend/frontend/postgres/redis dang chay, Postgres healthy.
- Browser cuoi ve lai admin that tai `/dashboard/tin-nhan`, trang tai day du,
  khong overlay, console 0 warning/error va du lieu QA khong con hien.

## Ket luan cuoi

- SUPPORT dung la hop thu chung: moi ADMIN ACTIVE cung thay, cung tra loi va cung
  nhan realtime; DIRECT van bi gioi han theo membership.
- Messenger alignment dung theo nguoi dang xem o moi goc nhin da test: tin minh
  ben phai, nguoi khac ben trai.
- Hai loi phat hien trong browser da duoc sua: mo lai SUPPORT cu bi lazy proxy 500,
  va tenant STOMP reconnect gui frame khong token.

## Thay doi da viet

- `ChatMembershipService` doi chieu `SUPPORT` moi lan tai danh sach va moi lan mo/gui vao hoi thoai.
- Danh sach quan ly duoc tinh tu ADMIN `ACTIVE`, chu tro va nhan vien co quyen xem/sua.
- Membership bi thu hoi se dat `roi_luc`; membership quay lai duoc tai kich hoat, khong tao row trung.
- Repository chi truy van `SUPPORT` cho luong dong bo; `DIRECT` khong bi mo rong quyen.
- Ten kenh phan biet theo nguoi xem: khach thue thay "Ban quan ly", admin thay nguoi da gui yeu cau ho tro.
- Giao dien ghi ro day la hop thu chung va hien tong so thanh vien.
- Them migration `20260804_share_support_with_admins.sql` de backfill cac kenh cu mot cach idempotent.
- Docker init moi se chay du chuoi chat module -> info panel -> mute -> P8 -> moderation -> search -> support sharing.
- Test moi bao phu: tap thanh vien Ban quan ly, admin moi duoc them vao kenh cu, admin mat quyen bi cho roi, `DIRECT` khong bi dong bo, va ten SUPPORT khac nhau theo goc nhin.
- Them regression test khang dinh admin khong phai thanh vien van khong doc duoc chat `DIRECT`.
