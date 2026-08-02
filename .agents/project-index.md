# EasyHouse Project Index

Generated from local repo scan on 2026-05-19. Use this as agent entrypoint before code changes.

## Executive Summary

EasyHouse is a full-stack Vietnamese rental property management app for landlords, tenants, rooms, contracts, invoices, payments, incidents, notifications, uploads, and dashboards.

Architecture is conventional but mid-migration:

- Backend is Spring Boot + PostgreSQL with JPA entities, DTOs, repositories, services, and controllers.
- Frontend is Next.js App Router with direct `fetch('/api/...')` calls proxied through `frontend/next.config.ts`.
- Database dump is PostgreSQL/Supabase-style with custom enums, JSONB columns, Row Level Security enabled, and many domain tables not fully surfaced by Java code yet.
- Auth is not production-grade yet: Spring Security permits all endpoints, NextAuth stores `accessToken`, but backend currently returns user email as token.
- Some frontend routes call backend endpoints that are missing in controller scan.

## Directory Map

| Path | Purpose | Notes |
|---|---|---|
| `AGENTS.md` | Codex/Antigravity root guidance | Points to this index |
| `CLAUDE.md` | Claude Code project memory | Imports this index |
| `GEMINI.md` | Gemini/Antigravity companion memory | Mirrors root guidance |
| `.agents/project-index.md` | Main agent index | This file |
| `.codex/skills/easyhouse-local/SKILL.md` | Codex project skill | Same operating rules |
| `.codex/skills/codegraph-search/SKILL.md` | Codex CodeGraph search skill | Graph-first source discovery and impact checks |
| `.agent/rules/easyhouse.md` | Antigravity workspace rule | Load before work |
| `.agent/skills/easyhouse-local/SKILL.md` | Antigravity project skill | Same operating rules |
| `.agent/skills/codegraph-search/SKILL.md` | Antigravity CodeGraph search skill | Graph-first source discovery and impact checks |
| `.claude/skills/easyhouse-local/SKILL.md` | Claude project skill | Same operating rules |
| `be/` | Spring Boot backend | Java 21, Maven |
| `frontend/` | Next.js frontend | React 19, Tailwind v4 |
| `docker-compose.easyhouse.yml` | Local Docker dev stack | Frontend, backend, PostgreSQL |
| `docker/easyhouse.README.md` | Docker runbook | Commands and refresh behavior |
| `sql/easyhouse-after-fix.sql` | Docker seed dump | Complete PostgreSQL schema and data; mounted on first creation of `easyhouse_postgres_data` |
| `sql/db-latest.sql` | Current snapshot | Complete PostgreSQL schema and data; use only when explicitly selected for restore |
| `sql/schema.sql` | Schema reference | Use for focused schema review when data is not needed |
| `monitoring/` | Observability playground | Prometheus, Grafana, k6 |
| `plainning/WEEKLY_IMPLEMENTATION_PLAN.md` | Short-term plan | File name has typo `plainning` |
| `danh_sach_chuc_nang.txt` | Feature catalog | Vietnamese feature list |

## Stack

Backend:

- `be/pom.xml`
- Spring Boot parent `4.0.6`
- Java `21`
- Dependencies: web, data-jpa, validation, security, mail, PostgreSQL runtime, Lombok, Jackson, devtools, test, H2 test, Cloudinary `1.39.0`, JaCoCo
- Main class: `be/src/main/java/com/example/quanlyphongtro/QuanlyphongtroApplication.java`
- Config: `be/src/main/resources/application.properties`

Frontend:

- `frontend/package.json`
- Next.js `15.5.4`, React `19.1.0`, TypeScript `5`
- NextAuth `4.24.11`
- Tailwind CSS v4, Radix UI, TanStack Table, Recharts, lucide-react, Tabler icons, Zod, React Hook Form
- App Router under `frontend/src/app`

Database:

- Docker PostgreSQL: database/user/password `postgres`, host port `54322`
- Docker seed dump: `sql/easyhouse-after-fix.sql` (schema + data, first new volume only)
- Alternate complete snapshot: `sql/db-latest.sql`; schema-only reference: `sql/schema.sql`
- Hibernate `ddl-auto=none` in Docker
- Secrets expected in `application-secrets.properties`
- Hikari pool capped for Supabase free tier
- `stringtype=unspecified` set for PostgreSQL enum casts

## Backend Index

Package root: `be/src/main/java/com/example/quanlyphongtro`.

| Layer | Path | Role |
|---|---|---|
| Config | `config/SecurityConfig.java` | Disables CSRF/CORS and permits all requests |
| Config | `config/CloudinaryConfig.java` | Cloudinary bean/config |
| Config | `config/JacksonConfig.java` | JSON/time handling |
| Controllers | `controller/*.java` | REST endpoints |
| DTOs | `dto/*.java` | Request/response contracts |
| Entities | `entity/*.java` | JPA models and enums |
| Repositories | `repository/*.java` | Spring Data JPA |
| Services | `services/*.java` | Business logic |
| Tests | `src/test/.../QuanlyphongtroApplicationTests.java` | Only context-load test observed |

### Backend Endpoints Observed

| Endpoint | Controller | Main operations |
|---|---|---|
| `/api/auth` | `AuthController.java` | login, register, verify-email, forgot-password |
| `/api/dashboard` | `DashboardController.java` | stats |
| `/api/phong` | `PhongController.java` | list/filter, get, create, update, delete |
| `/api/nha-tro`, `/api/toa-nha` | `NhaTroController.java` | list, get, create, update, delete |
| `/api/khach-thue` | `KhachThueController.java` | list, get, create, update, delete |
| `/api/hop-dong` | `HopDongController.java` | list, get, create, update, delete |
| `/api/hoa-don` | `HoaDonController.java` | list, get, create, update, delete, form-data, latest-reading, payment |
| `/api/hoa-don-public` | `HoaDonPublicController.java` | public invoice view |
| `/api/thanh-toan` | `ThanhToanController.java` | list, get, by invoice, create, update, delete |
| `/api/thong-bao` | `ThongBaoController.java` | list, get, create, update, mark read, send, delete |
| `/api/su-co` | `SuCoController.java` | list, get, create, update, delete |
| `/api/upload` | `UploadController.java` | upload multipart, delete by public id |
| `/api/user` | `UserController.java` | profile, update profile, change password |
| `/api/chi-so-dien-nuoc` | `ChiSoDienNuocController.java` | placeholder get/post |

### Frontend Calls Without Matching Backend Controller

These calls were observed in frontend code but no matching backend controller route appeared in the controller scan:

- `/api/admin/users`
- `/api/admin/users/{id}`
- `/api/auth/khach-thue/login`
- `/api/auth/khach-thue/me`
- `/api/test-payment`
- `/api/auth/verify-email` needs frontend rewrite or local Next route. A Next route exists at `frontend/src/app/api/auth/verify-email/route.ts`; `next.config.ts` does not currently proxy it directly.

## Frontend Index

| Route/Area | File | Purpose |
|---|---|---|
| `/` | `frontend/src/app/page.tsx` | Landing/home |
| `/xem-phong` | `frontend/src/app/xem-phong/page.tsx` | Public room listing |
| `/hoa-don/[id]` | `frontend/src/app/hoa-don/[id]/page.tsx` | Public invoice view |
| `/dang-nhap` | `frontend/src/app/(auth)/dang-nhap/page.tsx` | Login |
| `/dang-ky` | `frontend/src/app/(auth)/dang-ky/page.tsx` | Register |
| `/xac-thuc-email` | `frontend/src/app/xac-thuc-email/page.tsx` | Email verification |
| `/dashboard` | `frontend/src/app/(dashboard)/dashboard/page.tsx` | Admin/landlord dashboard |
| `/dashboard/toa-nha` | `frontend/src/app/(dashboard)/dashboard/toa-nha/page.tsx` | Building management |
| `/dashboard/phong` | `frontend/src/app/(dashboard)/dashboard/phong/page.tsx` | Room management |
| `/dashboard/khach-thue` | `frontend/src/app/(dashboard)/dashboard/khach-thue/page.tsx` | Tenant management |
| `/dashboard/hop-dong` | `frontend/src/app/(dashboard)/dashboard/hop-dong/page.tsx` | Contract management |
| `/dashboard/hop-dong/them-moi` | `frontend/src/app/(dashboard)/dashboard/hop-dong/them-moi/page.tsx` | Add contract |
| `/dashboard/hop-dong/[id]` | `frontend/src/app/(dashboard)/dashboard/hop-dong/[id]/page.tsx` | Edit/view contract |
| `/dashboard/hoa-don` | `frontend/src/app/(dashboard)/dashboard/hoa-don/page.tsx` | Invoice management |
| `/dashboard/hoa-don/them-moi` | `frontend/src/app/(dashboard)/dashboard/hoa-don/them-moi/page.tsx` | Add invoice |
| `/dashboard/hoa-don/[id]` | `frontend/src/app/(dashboard)/dashboard/hoa-don/[id]/page.tsx` | Edit/view invoice |
| `/dashboard/thanh-toan` | `frontend/src/app/(dashboard)/dashboard/thanh-toan/page.tsx` | Payments |
| `/dashboard/su-co` | `frontend/src/app/(dashboard)/dashboard/su-co/page.tsx` | Incidents |
| `/dashboard/thong-bao` | `frontend/src/app/(dashboard)/dashboard/thong-bao/page.tsx` | Notifications |
| `/dashboard/quan-ly-tai-khoan` | `frontend/src/app/(dashboard)/dashboard/quan-ly-tai-khoan/page.tsx` | Account management |
| `/dashboard/ho-so` | `frontend/src/app/(dashboard)/dashboard/ho-so/page.tsx` | Profile |
| `/dashboard/cai-dat` | `frontend/src/app/(dashboard)/dashboard/cai-dat/page.tsx` | Settings |
| `/dashboard/xem-web` | `frontend/src/app/(dashboard)/dashboard/xem-web/page.tsx` | Preview site |
| `/khach-thue/dang-nhap` | `frontend/src/app/khach-thue/dang-nhap/page.tsx` | Tenant login, backend missing |
| `/khach-thue/dashboard` | `frontend/src/app/khach-thue/dashboard/page.tsx` | Tenant dashboard, backend missing |

Shared frontend files:

- Types: `frontend/src/types/index.ts`
- Auth options: `frontend/src/lib/auth.ts`
- Status helpers: `frontend/src/lib/status-utils.ts`
- Utilities: `frontend/src/lib/utils.ts`
- Middleware: `frontend/src/middleware.ts`
- Sidebar/navigation: `frontend/src/components/app-sidebar.tsx`, `nav-main.tsx`, `nav-user.tsx`
- UI/data tables: `frontend/src/components/ui/*data-table.tsx`
- Upload components: `cccd-upload.tsx`, `image-upload.tsx`, `phong-image-upload.tsx`, `su-co-image-upload.tsx`

## API Proxy Map

Frontend proxy is in `frontend/next.config.ts`.

Proxied to backend:

- `/api/auth/register`
- `/api/auth/forgot-password`
- `/api/phong`, `/api/phong/:path*`
- `/api/toa-nha`, `/api/toa-nha/:path*`
- `/api/khach-thue`, `/api/khach-thue/:path*`
- `/api/dashboard/:path*`
- `/api/hop-dong`, `/api/hop-dong/:path*`
- `/api/hoa-don`, `/api/hoa-don/:path*`
- `/api/hoa-don-public/:path*`
- `/api/upload`
- `/api/thanh-toan`, `/api/thanh-toan/:path*`
- `/api/thong-bao`, `/api/thong-bao/:path*`
- `/api/su-co`, `/api/su-co/:path*`
- `/api/admin/:path*`
- `/api/user/:path*`
- `/api/test-payment`

Local Next route handlers:

- `frontend/src/app/api/auth/[...nextauth]/route.ts`
- `frontend/src/app/api/auth/register/route.ts`
- `frontend/src/app/api/auth/verify-email/route.ts`

## Domain Model

Core business entities:

- `NguoiDung`: account/profile, role join to `VaiTro`, status enum.
- `VaiTro`: role names such as `ADMIN`, `LANDLORD`, `TENANT`.
- `NhaTro`: building/property. Frontend calls it `ToaNha`.
- `Phong`: room, belongs to `NhaTro`.
- `KhachThue`: tenant, optional link to `NguoiDung`.
- `HopDong`: contract, links room and tenant, stores rent, deposit, payment cycle, readings, service fee JSON.
- `HoaDon`: invoice header, links room/contract/tenant.
- `ChiTietHoaDon`: invoice line items: room, electricity, water, service.
- `ThanhToan`: payment record, links invoice.
- `SuCo`: incident/maintenance request.
- `ThongBao`: notification.
- `EmailVerificationToken`: email verification.

Database-only or not fully implemented in Java yet:

- `cau_hinh_gia`
- `chu_tro`
- `dat_coc_phong`
- `file_media`
- `lich_hen`
- `lich_su_hoa_don`
- `phong_tien_ich`
- `thanh_vien_hop_dong`
- `tien_ich`

## Naming Contracts

Keep these mappings stable:

| Concept | Database | Backend Java | Frontend |
|---|---|---|---|
| Room | `phong` | `Phong` | `Phong` |
| Building | `nha_tro` | `NhaTro` | `ToaNha` |
| Tenant | `khach_thue` | `KhachThue` | `KhachThue` |
| Contract | `hop_dong` | `HopDong` | `HopDong` |
| Invoice | `hoa_don` | `HoaDon` | `HoaDon` |
| Payment | `thanh_toan` | `ThanhToan` | `ThanhToan` |
| Incident | `su_co` | `SuCo` | `SuCo` |
| Status | `trang_thai` | `trangThai` | `trangThai` |

Frontend generally expects `_id`, while backend stores `id`. DTOs should map with `@JsonProperty("_id")`.

## Enum Contracts

Observed Java enums:

- `TrangThaiPhong`: room status.
- `TrangThaiHopDong`: contract status.
- `TrangThaiHoaDon`: invoice status.
- `TrangThaiSuCo`: incident status.
- `TrangThaiNguoiDung`: account status.
- `LoaiMucHoaDon`: invoice line item type.
- `LoaiSuCo`: incident type.
- `UuTien`: incident priority.

Important known mapping:

| Backend enum | Frontend value | Display intent |
|---|---|---|
| `TrangThaiPhong.AVAILABLE` | `trong` | Room available |
| `TrangThaiPhong.RENTED` | `dangThue` | Room rented |
| `TrangThaiPhong.MAINTENANCE` | `baoTri` | Room under maintenance |
| `TrangThaiHoaDon.UNPAID` | `chuaThanhToan` | Unpaid |
| `TrangThaiHoaDon.PARTIAL` | `daThanhToanMotPhan` | Partially paid |
| `TrangThaiHoaDon.PAID` | `daThanhToan` | Paid |

Do not assume SQL enum values match frontend values. Check:

1. `sql/easyhouse-after-fix.sql`
2. Java enum in `be/src/main/java/.../entity`
3. Response DTO mapping
4. `frontend/src/types/index.ts`
5. Frontend status label/switch logic

## Critical Flows

### Auth

Frontend:

- Login page calls `signIn('credentials')`.
- `frontend/src/lib/auth.ts` calls the Docker backend at `http://localhost:8082/api/auth/login` when running through the published development port.
- Session stores `role`, `phone`, `avatar`, `accessToken`.

Backend:

- `AuthService.register` creates inactive user, role, verification token, sends email.
- `AuthService.login` validates password and active/banned status.
- `AuthResponse.token` is currently `user.getEmail()`, not a signed JWT.
- `UserController` treats bearer token as email and contains `docong88@gmail.com` development fallback.
- `SecurityConfig` currently permits all endpoints.

Implication: any auth/authorization task must fix backend security/token model before claiming role safety.

### Property/Room

- `NhaTroController` exposes both `/api/nha-tro` and `/api/toa-nha`.
- Frontend primarily uses `/api/toa-nha`.
- `PhongService` maps frontend room status strings to Java enum.
- `PhongResponse` maps Java UUID `id` to `_id` and room `ten` to `maPhong`.

### Tenant/Contract

- Contract stores representative tenant and JSON list of tenant IDs.
- Creating/updating contracts can update room status.
- Frontend contract pages load rooms, tenants, buildings, contracts independently.

### Invoice/Billing

- `HoaDonService.create` creates invoice header and detail lines.
- Detail line item types are `ROOM`, `ELECTRICITY`, `WATER`, `SERVICE`.
- Electricity/water readings are stored in `ChiTietHoaDon.moTa` as `"start-end"`.
- `getLatestReading` parses that text to find next initial readings.
- `cau_hinh_gia` exists in SQL and plan, but no entity/service/controller observed. Invoice uses values supplied by request or contract flow, not building price config.

### Payment

- `HoaDonService.thanhToan` writes `ThanhToan`, increments `HoaDon.daTra`, updates status.
- `ThanhToanService` also recalculates invoice payment state.
- Check both paths before changing payment behavior.

### Upload

- Frontend upload components post multipart to `/api/upload`.
- Backend `UploadController` uses `CloudinaryService`.
- `next.config.ts` allows Cloudinary images.

### Notifications and Incidents

- `SuCo` and `ThongBao` modules exist.
- Plan mentions event-driven notifications, but observed code is CRUD/manual send style.

## Data Schema Highlights

`sql/easyhouse-after-fix.sql` defines these major tables:

- `nguoi_dung`, `vai_tro`, `nguoi_dung_vai_tro`
- `chu_tro`, `khach_thue`
- `nha_tro`, `phong`, `tien_ich`, `phong_tien_ich`
- `hop_dong`, `thanh_vien_hop_dong`
- `hoa_don`, `chi_tiet_hoa_don`, `lich_su_hoa_don`
- `thanh_toan`
- `chi_so_dien_nuoc`
- `cau_hinh_gia`
- `su_co`, `thong_bao`
- `file_media`, `lich_hen`, `dat_coc_phong`
- `email_verification_token`

Custom enum families include:

- Room/contract/invoice/payment/user statuses
- Appointment/booking/deposit statuses
- Invoice item types
- Maintenance/incident type and priority
- Media object types

RLS is enabled in the dump, but backend JPA access will depend on the Supabase role/connection used in secrets.

## Known Risks And Drift

1. Auth is permissive and token is email, not JWT.
2. Frontend builds ignore TypeScript and ESLint errors.
3. `frontend/scripts/check-setup.js` is stale from a MongoDB/Mongoose setup.
4. `frontend/src/types/index.ts` still uses Mongo-style `ObjectId` comments and `_id`.
5. Frontend has routes/calls without backend controllers for admin users and tenant auth.
6. `cau_hinh_gia` is in SQL and plan but not implemented in backend Java code.
7. `ChiTietHoaDon.moTa` is used as a parseable reading storage format; fragile for billing.
8. Several docs/comments displayed mojibake in PowerShell output; preserve UTF-8 when editing Vietnamese text.
9. `plainning` directory name is misspelled; do not rename without a link-update plan.
10. Only one backend context-load test observed.

## Verification Matrix

Docker local stack:

```powershell
docker compose -f docker-compose.easyhouse.yml up --build
docker compose -f docker-compose.easyhouse.yml ps
```

Open `http://localhost:3002`. Backend API is `http://localhost:8082`. PostgreSQL is exposed on `localhost:54322`. Production overrides may instead expose the frontend through Nginx on ports `80` and `443`.

For docs-only changes:

```powershell
git diff --check
python C:\Users\Admin\.codex\skills\.system\skill-creator\scripts\quick_validate.py .codex\skills\easyhouse-local
python C:\Users\Admin\.codex\skills\.system\skill-creator\scripts\quick_validate.py .agent\skills\easyhouse-local
python C:\Users\Admin\.codex\skills\.system\skill-creator\scripts\quick_validate.py .claude\skills\easyhouse-local
```

For backend changes:

```powershell
cd be
mvn test
```

For frontend changes:

```powershell
cd frontend
npm run lint
npm run build
```

For full local manual flow:

```powershell
cd be
mvn spring-boot:run
```

```powershell
cd frontend
npm run dev
```

Then open `http://localhost:3002`.

## Agent Operating Procedure

1. Start with this index; for source discovery, use CodeGraph context/search first when `.codegraph/` is indexed, then use `rg` or direct reads to verify exact source.
2. Read only relevant files before editing.
3. Preserve Vietnamese naming and DTO boundaries.
4. Update backend DTO/entity/service/controller and frontend type/API usage together when changing a contract.
5. Add or update `frontend/next.config.ts` rewrites when adding backend endpoints called through `/api/...`.
6. Treat billing, payment, and auth as high-risk areas.
7. Do not run writes against production/customer DB. This repo currently points to Supabase secrets outside tracked files.
8. When restoring the Docker database, use a complete schema-and-data dump; do not restore only schema, only data, or partial tables unless explicitly requested. The default seed/restore source is `sql/easyhouse-after-fix.sql`; use `sql/db-latest.sql` only when explicitly requested. A PostgreSQL restart preserves the named volume and does not re-import the seed.
9. After local Docker DB restore, ensure full-permission login exists: `admin@easyhouse.local` / `Admin@123` with role `ADMIN`.
10. Keep docs in sync when changing architecture or routes.
