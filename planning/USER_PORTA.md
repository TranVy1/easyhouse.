# EasyHouse User Portal Implementation Plan

Ngay lap: 2026-05-26

Nguon tham chieu:

- `planning/DASHBOARD_REWORK_REMEDIATION_PLAN.md`
- `planning/E2E_MANUAL_TEST_CHECKLIST.md`
- `frontend/src/app`, `frontend/src/components`, `frontend/src/lib`, `frontend/src/middleware.ts`
- `be/src/main/java/com/example/quanlyphongtro/controller`, `services`, `dto`
- `sql/db.sql`

## 0. Chuyen Giai Doan

Dashboard quan ly duoc xem la da hoan tat giai doan 1 theo remediation gate ngay 2026-05-26. Phase nay khong mo lai CRUD dashboard neu khong phat hien regression anh huong truc tiep den user portal.

Muc tieu giai doan 2: xay dung web ma nguoi dung thuc su co the truy cap va su dung:

- Khach vang lai: xem thong tin nha tro/phong trong, xem chi tiet, dat lich xem phong.
- Khach thue da co tai khoan: dang nhap, xem phong/hop dong/hoa don/thanh toan cua minh, bao su co, xem thong bao va sua ho so.

Khong dua vao gate giai doan 2:

- AI/OCR/chatbot.
- Ky hop dong dien tu.
- Thanh toan online/webhook VietQR tu dong ngoai flow da co o dashboard.
- Google Calendar, Zalo/SMS, push notification that.
- Favorites, review, ban do hoac dat coc online neu chua co quyet dinh nghiep vu.

## 1. Ket Qua Khao Sat Hien Trang

### 1.1 Tai san co the tai su dung

| Khu vuc | Da co |
|---|---|
| Public frontend | `/`, `/xem-phong`, `/hoa-don/[id]`, dialog dat lich xem phong |
| Tenant frontend | `/khach-thue/dang-nhap`, `/khach-thue/dashboard`, layout sidebar tenant |
| Public API | `GET /api/public/toa-nha`, `GET /api/public/phong`, detail theo id |
| Dat lich | `POST /api/lich-hen` public; dashboard co xu ly lich hen |
| Tenant API nen tang | `POST /api/auth/khach-thue/login`, `GET /api/auth/khach-thue/me` |
| Core API co permission | hoa don, thanh toan, su co, thong bao, media da co service permission tu dashboard remediation |
| Auth backend | JWT access/refresh va Spring Security stateless da co |

### 1.2 Gap bat buoc xu ly truoc khi mo rong UI

| ID | Muc do | Gap hien tai | Huong xu ly |
|---|---|---|---|
| UP-SEC-01 | P0 | `/hoa-don/[id]` goi `/api/hoa-don-public/{uuid}` khong can auth, co the lo thong tin hoa don va lich su thanh toan neu biet UUID | Chuyen hoa don tenant sang endpoint co permission; neu can chia se link thi dung access token co han, khong dung UUID thuan |
| UP-AUTH-01 | P0 | Tenant login luu JWT trong `localStorage`, trong khi middleware bao ve `/khach-thue/dashboard` bang NextAuth session | Dung mot co che duy nhat: NextAuth credentials provider cho `TENANT`, luu access/refresh token trong session JWT |
| UP-AUTH-02 | P0 | Matcher `/khach-thue/:path*` dang bat ca `/khach-thue/dang-nhap`; callback mac dinh yeu cau token cho trang login | Cho phep route auth tenant anonymous; chi protect `/khach-thue/dashboard/:path*` |
| UP-BOOK-01 | P1 | Public dat lich tim phong bang `findById`, chua bat buoc phong public, chua soft-delete/availability validation va chua co spam protection | Chi nhan booking cho phong duoc phep hien thi; validate ngay/gio; them rate limit/honeypot hoac CAPTCHA sau MVP |
| UP-UX-01 | P1 | Cac trang user dang hien thi nhieu chuoi mojibake va thieu he thong navigation/branding dong nhat | Chuan hoa UTF-8 va public/tenant shell truoc khi polish |
| UP-API-01 | P1 | Public room list la client-only, tai toi da 100 item; chua co pagination/search API on dinh va detail route SEO | Tao public DTO/list pagination/filter va route chi tiet co link chia se on dinh |
| UP-TENANT-01 | P1 | Sidebar tenant link toi `hoa-don`, `su-co`, `thong-tin` nhung chua co page tuong ung | Implement module tenant self-service theo phase |

## 2. Persona Va Luong Su Dung Muc Tieu

### 2.1 Khach vang lai tim phong

1. Mo landing page, thay thong tin dich vu va CTA ro rang.
2. Tim/loc phong theo toa nha, gia, dien tich, suc chua, tien ich, trang thai con trong.
3. Mo chi tiet phong voi anh, gia, dia chi, tien ich va chinh sach co the cong khai.
4. Gui yeu cau dat lich xem phong.
5. Nhan thong bao gui thanh cong; quan ly tiep nhan lich hen trong dashboard da co.

### 2.2 Khach thue dang su dung dich vu

1. Dang nhap portal tenant bang tai khoan duoc quan ly cap.
2. Xem tong quan phong dang thue, hop dong active, hoa don can thanh toan.
3. Xem danh sach/chi tiet hoa don, QR/chuyen khoan neu duoc phep, lich su thanh toan cua chinh minh.
4. Tao va theo doi su co cua phong dang thue, dinh kem anh.
5. Xem thong bao cua minh va cap nhat da doc.
6. Xem/sua thong tin ca nhan va dang xuat.

## 3. Kien Truc Route De Xuat

### 3.1 Public portal

| Route | Chuc nang | Trang thai |
|---|---|---|
| `/` | Landing page/CTA tim phong va dang nhap tenant | Refactor tu trang co san |
| `/phong` hoac giu `/xem-phong` | Danh sach phong cong khai, filter, pagination | Refactor tu trang co san; chot mot canonical URL |
| `/phong/[id]` | Chi tiet phong linkable/SEO-friendly | Tao moi |
| `/dat-lich-thanh-cong` | Confirmation sau khi gui booking | Tuy chon MVP, khuyen nghi |
| `/dang-nhap` | Login quan ly/staff | Giu nguyen ngoai scope portal |
| `/khach-thue/dang-nhap` | Login tenant anonymous | Sua auth flow |

Khuyen nghi: giu redirect tu `/xem-phong` sang `/phong` sau khi route moi on dinh de cac link dashboard cu khong bi vo.

### 3.2 Tenant portal

| Route | Chuc nang | Uu tien |
|---|---|---|
| `/khach-thue/dashboard` | Tong quan cua tenant | MVP |
| `/khach-thue/dashboard/hop-dong` | Hop dong active/lich su va thanh vien | MVP |
| `/khach-thue/dashboard/hoa-don` | Danh sach hoa don cua minh | MVP |
| `/khach-thue/dashboard/hoa-don/[id]` | Chi tiet hoa don/thanh toan/VietQR | MVP |
| `/khach-thue/dashboard/su-co` | Danh sach + tao su co | MVP |
| `/khach-thue/dashboard/su-co/[id]` | Chi tiet/tien do/anh | Sau MVP neu can rut gon |
| `/khach-thue/dashboard/thong-bao` | Notification inbox/mark read | MVP |
| `/khach-thue/dashboard/thong-tin` | Ho so ca nhan/doi mat khau | MVP |

## 4. Nguyen Tac API Va Bao Mat

- Public API chi tra du lieu duoc phep quang ba: thong tin toa nha/phong, anh phong, tien ich, gia niem yet va tinh trang co the dat lich.
- Public response khong tra tenant, hop dong, chi so, hoa don, thanh toan, internal media ID, audit data.
- Tenant portal phai dung JWT/NextAuth session; backend luon kiem permission, khong dua vao viec an menu frontend.
- Tenant chi doc hop dong/phong/hoa don/su co/thong bao gan voi danh tinh dang nhap va hop dong hop le.
- Link hoa don khong duoc coi UUID la bi mat. MVP nen bo public invoice va dua chi tiet vao tenant portal authenticated.
- Booking public khong duoc cap quyen doc danh sach booking hay status noi bo.
- Moi endpoint moi dung `Request DTO -> Service -> Entity -> Response DTO`; response frontend tiep tuc giu `_id` neu component dang can.
- Moi endpoint backend ma frontend goi `/api/...` phai co rewrite hoac Next route proxy duoc ghi ro.

## 5. Ke Hoach Trien Khai Theo Phase


- [x] Them NextAuth provider hoac mode credentials tenant goi `/api/auth/khach-thue/login`; session co `role=TENANT`, `accessToken`, refresh handling.
- [x] Sua `/khach-thue/dang-nhap` de goi `signIn(...)`, bo luu JWT/profile trong `localStorage`.
- [x] Sua middleware: login tenant la public; `/khach-thue/dashboard/:path*` yeu cau session `TENANT`; dashboard quan ly van chan `TENANT`.
- [x] Sua tenant layout doc thong tin tu `useSession`, xu ly session het han va logout dung NextAuth.

Gate UP-0:

- [x] Anonymous mo duoc trang login tenant nhung khong mo duoc tenant dashboard.
- [x] Tenant login thanh cong va reload trang van con session.
- [x] Tenant khong the vao `/dashboard`; manager khong tu dong xem duoc portal tenant cua nguoi khac.
- [x] Endpoint invoice private khong lo du lieu qua public UUID.

### Phase UP-1 - Public Website Va Danh Sach Phong

Muc tieu: khach vang lai tim thay phong can xem tren giao dien sach, mobile-friendly.

UX/UI:

- [x] Tao public layout chung: header, logo/brand, navigation, CTA, footer, hotline/contact that tu config hoac nha tro.
- [x] Sua toan bo chuoi hien thi mojibake tai landing/list/detail/booking.
- [x] Landing page co hero, loi ich, phong noi bat/phong trong moi, quy trinh dat lich, CTA.
- [x] Danh sach phong co loading, empty, error, skeleton, filter tren desktop/mobile.
- [x] Card phong co anh cover, gia, dien tich, so nguoi, tien ich noi bat, dia chi rut gon, nut xem chi tiet/dat lich.

Backend/API:

- [x] Tao `PublicPhongSummaryResponse` va `PublicPhongDetailResponse` rieng thay vi mutate `PhongResponse`.
- [x] Public list chi tra phong co the cong khai; chot rule hien thi `AVAILABLE` va cac status duoc phep.
- [x] Ho tro pagination va filter server-side: `page`, `limit`, `search`, `nhaTroId`, khoang gia, dien tich, tien ich.
- [x] Public toa nha response khong dua thong ke noi bo khong can cho visitor.

Route:

- [x] Tao detail `/phong/[id]`; cho phep tu dashboard copy link public moi.
- [x] Giu compatibility cho `/xem-phong?phong=...` hoac tao redirect sau khi cap nhat cac link quan ly.

Gate UP-1:

- [x] Visitor xem duoc landing, list va detail khong dang nhap.
- [x] Soft-deleted/non-public room khong hien thi va detail tra not-found.
- [x] Responsive smoke tai mobile va desktop; khong co chuoi mojibake/console error tren page public trong scope.

### Phase UP-2 - Dat Lich Xem Phong

Muc tieu: visitor gui lead hop le tu phong dang cong khai.

- [x] Dialog/form booking dat trong detail page va co CTA tu room card.
- [x] Validate client va backend: ho ten, so dien thoai, email neu co, ngay gio tuong lai, ghi chu gioi han do dai.
- [x] Backend chi tao lich cho phong khong bi xoa va dang cho phep dat lich.
- [x] Khong cho visitor gui `trangThai`; backend luon tao `PENDING`.
- [x] Them thong bao consent ve viec dung thong tin lien he.
- [x] Them bien phap chong spam MVP: honeypot + rate limit theo IP/so dien thoai; CAPTCHA de sau neu can.
- [x] Sau submit hien success state, ma tham chieu hoac huong dan lien he; khong lo danh sach lich hen.

Gate UP-2:

- [x] Public dat lich thanh cong cho phong hop le; dashboard nhan va duyet duoc lich.
- [x] Khong dat duoc phong da xoa/khong public/khong kha dung.
- [x] Invalid date/status va spam burst bi tu choi; co backend test.

### Phase UP-3 - Tenant Shell Va Tong Quan

Muc tieu: tenant co khu vuc ca nhan dung duoc tren dien thoai.

- [x] Tao shell tenant dong nhat: sidebar desktop, bottom/menu mobile, header, account/logout, notification badge.
- [x] Tong quan hien thi: phong dang thue, contract active, invoice chua thanh toan/qua han, su co dang mo, thong bao moi.
- [x] Tao empty states ro rang cho tenant chua co contract active hoac chua co hoa don.
- [x] Khong hien thi thong tin lien he hard-code; lay thong tin quan ly/nha tro tu response an toan.
- [x] Chuan hoa types tenant trong `frontend/src/types/index.ts`, bo interface lap rieng neu DTO da on dinh.

Gate UP-3:

- [x] Tenant A chi thay tong quan A; Tenant B chi thay tong quan B.
- [x] Khong render private data truoc khi session da validate.
- [x] Reload, logout, expired token va unauthorized redirect hoat dong.

### Phase UP-4 - Hop Dong, Hoa Don Va Thanh Toan Cua Toi

Muc tieu: tenant tu xem nghia vu tai chinh an toan.

- [x] Page hop dong: thong tin phong, thoi han, tien coc, gia thue, dich vu; lich su/contract cu neu policy cho phep.
- [x] Page danh sach hoa don: ky, tong tien, da tra, con lai, han thanh toan, trang thai.
- [x] Page chi tiet hoa don authenticated: line items dien/nuoc/dich vu, payment history, VietQR/noi dung chuyen khoan neu hoa don con no.
- [x] Xac dinh hanh vi download/in hoa don; PDF la follow-up neu chua co generator.
- [x] Khong cho tenant ghi nhan thanh toan thu cong; chi hien huong dan/chung tu cua minh, viec reconcile van o backend/dashboard.

Gate UP-4:

- [x] Invoice total/paid/remaining khop voi dashboard cho cung hoa don.
- [x] Tenant cross-owner invoice/payment/detail bi 403.
- [x] Khong con flow UI dua nguoi dung vao public invoice UUID nhay cam.

### Phase UP-5 - Su Co, Thong Bao Va Ho So

Muc tieu: tenant co kenh tu phuc vu va tuong tac day du.

Su co:

- [x] Danh sach su co cua minh, loc status/priority va detail timeline co the hien thi.
- [x] Form tao su co chi chon phong active cua tenant; khong gui `khachThueId`, `chiPhiSuaChua`, `ghiChuChuNha`.
- [x] Upload anh su co qua object-bound media; list/delete anh theo policy tenant/manager da gate.
- [x] Tenant chi sua/huy khi status cho phep; manager tiep tuc xu ly tren dashboard.

Thong bao:

- [x] Notification inbox cua user dang nhap, unread badge va mark-read.
- [x] Chi expose thong bao co nguoi nhan la tenant dang nhap.

Ho so:

- [x] Xem/sua ho ten, email/so dien thoai theo policy xac minh.
- [x] Doi mat khau qua endpoint authenticated; khong luu mat khau/token o local storage.

Gate UP-5:

- [x] Su co tenant tao ra gan dung tenant/phong active va hien tren dashboard manager.
- [x] Incident/media cross-owner bi chan.
- [x] Notification/profile chi tra du lieu cua principal.

### Phase UP-6 - Polish, SEO, Accessibility Va Acceptance

- [x] Them metadata title/description/Open Graph cho landing/list/detail room.
- [x] Toi uu anh Cloudinary/Next Image, fallback image va loading performance.
- [x] Keyboard focus, label/form validation, contrast, screen reader cho booking va auth.
- [x] Standardize toast/error/not-found/empty state.
- [x] Chay browser acceptance tren viewport mobile va desktop.
- [x] Cap nhat checklist user portal bang account/test data thuc, khong tick theo suy doan.

## 6. Ma Tran API Can Co

| Flow | Endpoint de xuat | Quyen | Ghi chu |
|---|---|---|---|
| Public room list | `GET /api/public/phong` | Anonymous | Public DTO + pagination/filter |
| Public room detail | `GET /api/public/phong/{id}` | Anonymous | Khong hop dong/tenant/private ID |
| Booking create | `POST /api/lich-hen` | Anonymous | Validate public room, `PENDING` only |
| Tenant login | `POST /api/auth/khach-thue/login` | Anonymous | Tich hop vao NextAuth |
| Tenant overview | `GET /api/auth/khach-thue/me` hoac `/api/tenant/me/overview` | TENANT | Chot naming truoc khi implement them |
| My contracts | `GET /api/tenant/hop-dong` | TENANT | Chi principal |
| My invoices | `GET /api/tenant/hoa-don` | TENANT | Pagination/status |
| My invoice detail | `GET /api/tenant/hoa-don/{id}` | TENANT | Thay cho invoice public UUID |
| My incidents | `GET/POST /api/tenant/su-co` | TENANT | Co the tai su dung `/api/su-co` neu DTO khong lo du lieu manager |
| My notifications | `GET/PATCH /api/thong-bao/my...` | TENANT | Service da co `getMyThongBao` can wire UI/API dung |
| My profile | `GET/PUT /api/user/profile` | TENANT | Principal only |

Quyet dinh API truoc khi code: co the tai su dung endpoint chung da co permission, nhung endpoint tenant rieng nen duoc uu tien neu response hien tai chua sanitize truong quan ly/noi bo.

## 7. File/Module Du Kien Tac Dong

Frontend:

- `frontend/src/app/page.tsx`
- `frontend/src/app/xem-phong/page.tsx` va/hoac `frontend/src/app/phong/*`
- `frontend/src/components/ui/dat-lich-hen-dialog/index.tsx`
- `frontend/src/app/khach-thue/dang-nhap/page.tsx`
- `frontend/src/app/khach-thue/dashboard/layout.tsx`
- `frontend/src/app/khach-thue/dashboard/**`
- `frontend/src/app/hoa-don/[id]/page.tsx` (remove/deprecate public private-data flow)
- `frontend/src/lib/auth.ts`, `frontend/src/middleware.ts`, `frontend/src/types/index.ts`
- `frontend/next.config.ts`

Backend:

- `controller/PublicApiController.java`, `LichHenController.java`, `AuthController.java`, `HoaDonPublicController.java`
- Tenant-facing controllers moi neu tach endpoint `/api/tenant/*`
- `services/PhongService.java`, `LichHenService.java`, `AuthService.java`, `PermissionService.java`
- `services/HoaDonService.java`, `SuCoService.java`, `ThongBaoService.java`, `MediaService.java`
- DTO public/tenant response moi va test tuong ung

Tai lieu/test:

- Tao `planning/USER_PORTAL_E2E_CHECKLIST.md` khi bat dau UP-0.
- Mo rong backend unit/security test va browser smoke Playwright theo role `Anonymous`/`TENANT`.

## 8. Thu Tu Thuc Hien Khuyen Nghi

| Dot | Phase | Ket qua nhin thay | Ly do thu tu |
|---|---|---|---|
| 1 | UP-0 | Login tenant dung session; invoice khong lo public | Phai khoa risk/auth truoc khi them tinh nang |
| 2 | UP-1 | Website public va room detail dep, dung du lieu | Tao mat tien de demo va dat lich |
| 3 | UP-2 | Visitor gui lich hen that | Hoan thanh conversion flow public |
| 4 | UP-3 | Tenant vao portal va xem tong quan | Nen tang self-service |
| 5 | UP-4 | Tenant xem hop dong/hoa don/thanh toan | Flow nghiep vu quan trong nhat |
| 6 | UP-5 | Incident/notification/profile | Hoan thien tuong tac hang ngay |
| 7 | UP-6 | Polish/acceptance | Chot chat luong va demo |

## 9. Verification Matrix

Automated bat buoc moi dot:

```powershell
cd be
mvn clean test
```

```powershell
cd frontend
npx tsc --noEmit
npm.cmd run lint
npm.cmd run build
```

Backend tests toi thieu:

- Anonymous public room list/detail: chi public/non-deleted data.
- Booking: hop le, phong khong kha dung/soft-deleted, status injection, invalid date, spam guard.
- Auth tenant: login hop le/sai mat khau, refresh/logout, role/session.
- Tenant scope: contract/invoice/payment/incident/notification/profile cross-owner denial.
- Invoice: anonymous denial hoac valid share-token behavior neu quyet dinh giu link share.

Browser E2E toi thieu:

| Actor | Flow can smoke |
|---|---|
| Anonymous | Landing -> room list -> detail -> booking success; khong vao tenant dashboard/private invoice |
| Tenant A | Login -> overview -> invoice A -> create incident A -> notification/profile -> logout |
| Tenant B | Khong doc duoc URL/detail cua Tenant A |
| Manager | Dashboard van hoat dong sau khi them portal; tiep nhan booking/incident tu user |

## 10. Definition Of Done Giai Doan 2

- [x] Dashboard giai doan 1 khong regression trong smoke lien quan booking/incident/invoice.
- [x] Public portal co landing, room list, room detail va dat lich xem phong responsive.
- [x] Khong con chuoi mojibake tren cac route public/tenant trong scope.
- [x] Public endpoint khong lo thong tin tenant, hop dong, hoa don hoac thanh toan.
- [x] Tenant auth dung NextAuth/JWT session thong nhat; khong dung `localStorage` luu bearer token.
- [x] Tenant xem duoc tong quan, hop dong, hoa don/thanh toan, su co, thong bao va ho so cua minh.
- [x] Tenant/anonymous khong doc hoac ghi du lieu ngoai scope; co test backend va browser evidence.
- [x] Booking chi tao cho phong duoc phep cong khai va co validation/chong spam co ban.
- [x] `mvn clean test`, `npx tsc --noEmit`, `npm.cmd run lint`, `npm.cmd run build` pass tai thoi diem nghiem thu; warning neu con phai duoc ghi residual ro rang.
- [x] `planning/USER_PORTAL_E2E_CHECKLIST.md` ghi lai lan chay thuc voi account va ket qua cu thu.

## 11. Cong Viec Dau Tien Can Lam

Bat dau bang UP-0, khong bat dau tu redesign landing page:

1. Chot policy invoice: authenticated tenant-only hay signed share link.
2. Sua login tenant vao NextAuth session va middleware redirect.
3. Tao test bao mat cho invoice va tenant auth/scope.
4. Sau khi auth gate pass moi refactor public layout, room detail va booking.

Ly do: landing dep nhung login tenant vo hoac hoa don lo cong khai se khong dat duoc dieu kien demo/bao ve du lieu nguoi dung.
