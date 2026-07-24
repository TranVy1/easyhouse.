# FULL SYSTEM AUDIT & PRODUCTION PLAN - EasyHouse

> **Nguoi cap nhat:** Codex
> **Ngay cap nhat:** 2026-07-09
> **Pham vi:** Backend Spring Boot + Frontend Next.js + PostgreSQL + planning hien co
> **Muc tieu:** Hoan thien planning, cap nhat hang muc da lam duoc, va xac dinh phan con lai de dua he thong ve muc MVP production-safe.

---

## 1. Tong Quan Trang Thai Hien Tai

EasyHouse da vuot qua giai doan prototype. Codebase hien tai co day du cac module chinh: phong, toa nha, khach thue, hop dong, hoa don, thanh toan, su co, thong bao, cau hinh gia, dat coc phong, lich hen, cong no, bao cao, tenant portal, public listing, upload media, audit log, VietQR/VNPay, va canh bao chi so bat thuong.

Kien truc van theo huong:

```text
[Next.js Frontend] -- fetch /api/* --> [next.config.ts rewrites] --> [Spring Boot :8080]
                                                                       |
                                                              [PostgreSQL / Supabase]
                                                                       |
                                                              [Cloudinary / VietQR]
```

### Bang trang thai module

| Module | Trang thai | Ghi chu cap nhat |
|---|---:|---|
| Authentication JWT | DONE | `JwtService`, `JwtAuthenticationFilter`, access token + refresh token da duoc wire vao `SecurityConfig`; `anyRequest().authenticated()` da bat. |
| Role/permission boundary | PARTIAL | Da co `PermissionService`, nhieu service goi `requireCurrentUserId`; can tiep tuc audit role-level authorization theo tung route. |
| CauHinhGia | DONE | Co entity, repository, service, controller, UI va proxy `/api/cau-hinh-gia`; `HoaDonService` dung `findApplicable`. |
| DatCocPhong | PARTIAL | Co entity/service/controller/UI va flow convert; con lech endpoint frontend `/convert` voi backend `/convert-to-contract` o mot cho. |
| LichHen | DONE/PARTIAL | Co backend, UI, public create va proxy `/api/lich-hen`; can lien ket chat hon voi dat coc/hop dong. |
| Tenant portal | DONE/PARTIAL | Co `TenantApiController`, route khach thue, Next route auth tenant; can kiem thu end-to-end. |
| HoaDon core | PARTIAL | Co duplicate check, cau hinh gia, chi so rieng, cong no dau ky; con rui ro `daTra` co the sua truc tiep va reset cong to chua co. |
| ThanhToan | PARTIAL | Recalculate `daTra` tu bang thanh_toan da co; chong duplicate chi co cho external transaction, manual payment chua co idempotency. |
| Public room listing | DONE | Query public chi lay `TrangThaiPhong.AVAILABLE`; detail cung chan phong khong kha dung. |
| Check-out / ket thuc hop dong | PARTIAL | Da co endpoint `PUT /api/hop-dong/{id}/ket-thuc`, nhung moi set status/ngay ket thuc/coc, chua tao hoa don cuoi va tinh khau tru coc. |
| PhuLucHopDong | PARTIAL | Co entity/repository va gia han hop dong; hoa don tien phong van lay `giaThueHopDong`, chua resolve gia tu phu luc theo ngay hieu luc. |
| VietQR / bank reconciliation | PARTIAL | Co BankTransaction/VNPay/service/UI nen tang; can webhook/auto-match production. |
| Meter anomaly | DONE/PARTIAL | Co `MeterAnomalyService`, entity, controller, proxy; can can gan vao scheduler/hoa don flow neu chua chay tu dong o production. |
| BaoCao / dashboard analytics | DONE/PARTIAL | Co controller/service/UI/proxy; can bo sung widget canh bao han hop dong, no qua han, phong trong. |
| TypeScript/ESLint quality gate | NOT DONE | `frontend/next.config.ts` van `typescript.ignoreBuildErrors = true`; comment noi ESLint/TS dang bi bo qua. |

---

## 2. Cac Hang Muc Da Hoan Thanh

### 2.1 Security/Auth

- Da thay token email thuan bang JWT access token trong `AuthService.login()`.
- Da co refresh token luu DB va rotate token trong `refreshAccessToken()`.
- `SecurityConfig` da them `JwtAuthenticationFilter` va yeu cau authenticate cho request khong public.
- Tenant khong duoc login vao landlord/admin portal bang credential flow thuong.

### 2.2 API/proxy/frontend coverage

- `frontend/next.config.ts` da proxy cac endpoint tung bi thieu: `/api/dat-coc`, `/api/cau-hinh-gia`, `/api/chi-so-dien-nuoc`, `/api/lich-hen`, `/api/bao-cao`, `/api/tenant`, `/api/media`, `/api/meter-alerts`, `/api/bank-transaction`.
- Da co route dashboard cho: dat coc, cau hinh gia, chi so dien nuoc, lich hen, bao cao, cong no, media, VietQR doi soat.
- Da co tenant portal va public room detail/listing.

### 2.3 Billing/domain

- Cau hinh gia da co hieu luc theo thoi gian va duoc dung khi lap hoa don dien/nuoc.
- Da co migration `sql/migrations/20260614_hoadon_unique_ky.sql` tao unique index cho hoa don theo hop dong/thang/nam khi `xoa_luc IS NULL`.
- Chi so dien nuoc da co entity/trang thai rieng, khong chi nam trong mo ta hoa don.
- Public listing da filter phong `AVAILABLE`, giam rui ro khach dat nham phong da cho thue.

### 2.4 Dat coc, lich hen, tenant flow

- Da co `DatCocPhongService` voi create, confirm, cancel, convert to contract.
- Da co `LichHenController/Service` va UI dashboard.
- Da co flow tenant login/dashboard o frontend va `TenantApiController` o backend.

---

## 3. Cac Van De Con Lai Can Xu Ly

### MUST FIX

| Ma | Hang muc | Trang thai | Viec can lam tiep |
|---|---:|---|---|
| P0-01 | `daTra` co 2 nguon cap nhat | NOT DONE | Xoa/chan update `hd.setDaTra(...)` trong `HoaDonService.update()`; `daTra` chi duoc tinh qua `ThanhToanService.recalculate()`. |
| P0-02 | Manual double payment | PARTIAL | Them idempotency key/request fingerprint cho `ThanhToanService.create()`; frontend da disable submit khi `submitting` nhung backend van can chan. |
| P0-03 | Reset cong to | NOT DONE | Them field `resetCongTo`, `soKwhThucTe`, `soKhoiNuocThucTe` vao DTO + UI; cho phep chi so moi < chi so cu khi co reset hop le. |
| P0-04 | Check-out/thanh ly hop dong that | PARTIAL | Mo rong `ket-thuc` thanh flow tinh hoa don cuoi, chi so cuoi, no con lai, khau tru/hoan coc, audit log. |
| P0-05 | Phu luc hop dong anh huong gia phong | NOT DONE | Khi build line tien phong trong `HoaDonService`, resolve `giaThueMoi` tu `PhuLucHopDong` theo `ngayHieuLuc` thay vi chi dung `giaThueHopDong`. |
| P0-06 | Endpoint DatCoc convert bi lech | NOT DONE | Dong bo frontend/backend: frontend dang co cho goi `/api/dat-coc/{id}/convert`, backend expose `/convert-to-contract`. |
| P0-07 | Deposit invoice code dung `Math.random()` | NOT DONE | Doi ma hoa don coc sang UUID/random suffix an toan, vi hien con `"HD" + System.currentTimeMillis() + Math.random()`. |

### SHOULD FIX

| Ma | Hang muc | Trang thai | Viec can lam tiep |
|---|---:|---|---|
| P1-01 | Optimistic locking cho hoa don | PARTIAL | Da co DB unique index migration; chua thay `@Version` trong `HoaDon`. |
| P1-02 | Auto-fill so du dau ky | PARTIAL | Backend co du du lieu; can dam bao form hoa don goi API va prefill nhat quan. |
| P1-03 | Lich hen -> dat coc -> hop dong | PARTIAL | Co module rieng; can lam wizard/CTA lien mach de giam thao tac thu cong. |
| P1-04 | Dashboard warnings | PARTIAL | Bo sung widget hop dong sap het han, hoa don qua han, phong trong, chi so bat thuong. |
| P1-05 | Build quality gate | NOT DONE | Bat lai TypeScript/ESLint build check sau khi fix loi ton dong. |
| P1-06 | Tenant E2E smoke test | NOT DONE | Kiem thu login khach thue, xem hop dong, hoa don, thong bao, tao su co. |

### NICE TO HAVE

- Webhook ngan hang/VietQR auto-reconcile theo ma hoa don.
- So quy Thu/Chi rieng cho chi phi van hanh, loi nhuan theo toa nha.
- FAQ tinh cho khach thue thay vi chatbot AI ton chi phi.
- Upload anh dong ho khi ghi chi so va dung `MeterAnomalyService` de canh bao dot bien.

---

## 4. Roadmap Cap Nhat

### Tuan 1 - Chot an toan tai chinh

1. Sua `HoaDonService.update()` de khong cho cap nhat `daTra` truc tiep.
2. Them idempotency cho manual payment va unique/duplicate guard phu hop.
3. Sua ma hoa don coc tu `Math.random()` sang UUID suffix.
4. Dong bo endpoint dat coc convert giua frontend va backend.
5. Chay smoke test lap hoa don -> ghi thanh toan -> recalculate trang thai.

### Tuan 2 - Hoan thien billing/hop dong thuc te

1. Implement reset cong to cho dien/nuoc.
2. Resolve tien phong tu `PhuLucHopDong` khi lap hoa don.
3. Mo rong flow ket thuc hop dong: hoa don cuoi, chi so cuoi, no con, khau tru/hoan coc.
4. Bo sung UI thanh ly hop dong thay vi chi doi status.

### Tuan 3 - Dong goi MVP

1. Wizard lich hen -> dat coc -> hop dong.
2. Dashboard warnings cho van hanh hang ngay.
3. Bat lai TypeScript/ESLint build gate.
4. E2E smoke test cho admin/landlord/tenant.
5. Review migration SQL va cap nhat `sql/db.sql` neu can snapshot moi.

---

## 5. Risk Register Cap Nhat

| # | Rui ro | Muc do | Trang thai |
|---|---|---:|---|
| 1 | Gia mao token email | CRITICAL | DONE: da co JWT, can tiep tuc role audit. |
| 2 | Duplicate hoa don cung ky | HIGH | PARTIAL: co app check + DB migration, chua co optimistic lock. |
| 3 | Double payment manual | HIGH | PARTIAL: recalculate co, external transaction co check, manual create chua idempotent. |
| 4 | `daTra` lech voi bang thanh_toan | HIGH | NOT DONE. |
| 5 | Reset cong to khong lap duoc hoa don | HIGH | NOT DONE. |
| 6 | Thanh ly hop dong/hoan coc sai | HIGH | PARTIAL. |
| 7 | Hoa don khong lay gia phu luc | HIGH | NOT DONE. |
| 8 | Dat coc convert bi 404 do endpoint mismatch | MEDIUM | NOT DONE. |
| 9 | Phong da thue hien public | MEDIUM | DONE. |
| 10 | Build bo qua TypeScript errors | MEDIUM | NOT DONE. |

---

## 6. Diem Danh Gia Moi

| Hang muc | Diem | Nhan xet |
|---|---:|---|
| Backend architecture | 8.0/10 | Layered architecture ro, nhieu module da duoc bo sung, JWT da co. |
| Business logic | 7.2/10 | Billing/domain kha day, nhung cac edge case tai chinh van can chot. |
| Data design | 8.0/10 | Schema va migration phong phu; can dong bo snapshot DB va idempotency/lock. |
| Frontend/UX | 7.0/10 | Nhieu route da co, tenant/admin/public day hon; can wizard va checkout UI. |
| Production readiness | 6.2/10 | Tot hon ban audit cu, nhung chua nen go production khi `daTra`, reset cong to, checkout chua xong. |
| Tong ket | 7.3/10 | MVP kha manh; can 1-2 tuan tap trung bug tai chinh va flow van hanh that. |

---

## 7. Ket Luan

Planning cu da dung ve huong uu tien, nhung nhieu hang muc trong do da duoc implement mot phan hoac day du. Tu thoi diem cap nhat 2026-07-09, khong nen tiep tuc coi he thong la "thieu module"; thay vao do nen tap trung vao cac diem tich hop va tinh dung dung nghiep vu:

- Dong bo tien da tra voi thanh toan.
- Chong duplicate payment.
- Xu ly reset cong to.
- Thanh ly hop dong dung doi thuc.
- Gia phong theo phu luc.
- Dong bo endpoint dat coc convert.
- Bat lai quality gate frontend.

Neu hoan thanh cac muc P0, EasyHouse co the tien gan trang thai MVP production-safe cho chu tro/quan ly nha tro quy mo nho.
