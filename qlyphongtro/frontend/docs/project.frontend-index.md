# EasyHouse frontend index

Ngay quet: 2026-05-19. Pham vi ghi file: chi trong `frontend/`.

## Tong quan

EasyHouse frontend la Next.js 15 + React 19 + TypeScript + Tailwind CSS. App dung App Router, chia route cong khai, auth, tenant, dashboard. Backend la Spring Boot API qua proxy rewrite trong `frontend/next.config.ts`.

Luong du lieu chuan:

1. Page/form trong `frontend/src/app`.
2. Goi `/api/...` tu browser.
3. Next rewrite sang backend `BACKEND_URL` hoac `http://localhost:8080`.
4. Spring Controller -> Service -> Repository.
5. PostgreSQL runtime `easyhouse-postgres`, database `easyhouse`.
6. Backend tra `ApiResponse<T>` voi `success`, `message`, `data`.

## Stack frontend

| Hang muc | Gia tri |
|---|---|
| Framework | Next.js App Router |
| UI | Radix UI, Tailwind, lucide-react, shadcn-like components |
| Form | `react-hook-form` + `zod` o login/register; nhieu dashboard form dung `useState` |
| Auth | NextAuth credentials cho dashboard; tenant portal dung token localStorage rieng |
| Types | `frontend/src/types/index.ts` |
| API proxy | `frontend/next.config.ts` rewrites |
| Upload | `frontend/src/components/ui/*upload*.tsx` -> `POST /api/upload` |

## Route map nhanh

| Route | File | Muc dich | API chinh |
|---|---|---|---|
| `/` | `frontend/src/app/page.tsx` | Landing noi bo | Khong |
| `/dang-nhap` | `frontend/src/app/(auth)/dang-nhap/page.tsx` | Dang nhap admin/chu nha/nhan vien | NextAuth -> `/api/auth/login`, forgot `/api/auth/forgot-password` |
| `/dang-ky` | `frontend/src/app/(auth)/dang-ky/page.tsx` | Dang ky user | `POST /api/auth/register` |
| `/xac-thuc-email` | `frontend/src/app/xac-thuc-email/page.tsx` | Verify email token | `GET /api/auth/verify-email?token=...` |
| `/xem-phong` | `frontend/src/app/xem-phong/page.tsx` | Public room listing | `GET /api/phong`, `GET /api/toa-nha` |
| `/hoa-don/[id]` | `frontend/src/app/hoa-don/[id]/page.tsx` | Public invoice detail | `GET /api/hoa-don-public/{id}` |
| `/khach-thue/dang-nhap` | `frontend/src/app/khach-thue/dang-nhap/page.tsx` | Tenant login | `POST /api/auth/khach-thue/login` |
| `/khach-thue/dashboard` | `frontend/src/app/khach-thue/dashboard/page.tsx` | Tenant dashboard | `GET /api/auth/khach-thue/me` |
| `/dashboard` | `frontend/src/app/(dashboard)/dashboard/page.tsx` | Stats | `GET /api/dashboard/stats` |
| `/dashboard/toa-nha` | `frontend/src/app/(dashboard)/dashboard/toa-nha/page.tsx` | Building CRUD | `/api/toa-nha` |
| `/dashboard/phong` | `frontend/src/app/(dashboard)/dashboard/phong/page.tsx` | Room CRUD | `/api/phong`, `/api/toa-nha` |
| `/dashboard/khach-thue` | `frontend/src/app/(dashboard)/dashboard/khach-thue/page.tsx` | Tenant CRUD | `/api/khach-thue` |
| `/dashboard/hop-dong` | `frontend/src/app/(dashboard)/dashboard/hop-dong/page.tsx` | Contract list/status/delete | `/api/hop-dong`, `/api/phong`, `/api/khach-thue`, `/api/toa-nha` |
| `/dashboard/hop-dong/them-moi` | `frontend/src/app/(dashboard)/dashboard/hop-dong/them-moi/page.tsx` | Create contract | `POST /api/hop-dong` |
| `/dashboard/hop-dong/[id]` | `frontend/src/app/(dashboard)/dashboard/hop-dong/[id]/page.tsx` | Edit contract | `GET/PUT /api/hop-dong/{id}` |
| `/dashboard/hoa-don` | `frontend/src/app/(dashboard)/dashboard/hoa-don/page.tsx` | Invoice list/payment | `/api/hoa-don`, `/api/hoa-don/form-data`, `/api/hoa-don/{id}/thanh-toan` |
| `/dashboard/hoa-don/them-moi` | `frontend/src/app/(dashboard)/dashboard/hoa-don/them-moi/page.tsx` | Create invoice | `POST /api/hoa-don`, latest reading |
| `/dashboard/hoa-don/[id]` | `frontend/src/app/(dashboard)/dashboard/hoa-don/[id]/page.tsx` | Edit invoice | `GET/PUT /api/hoa-don/{id}` |
| `/dashboard/thanh-toan` | `frontend/src/app/(dashboard)/dashboard/thanh-toan/page.tsx` | Payment CRUD | `/api/thanh-toan`, `/api/hoa-don` |
| `/dashboard/su-co` | `frontend/src/app/(dashboard)/dashboard/su-co/page.tsx` | Incident CRUD/status | `/api/su-co`, `/api/phong`, `/api/khach-thue`, `/api/hop-dong` |
| `/dashboard/thong-bao` | `frontend/src/app/(dashboard)/dashboard/thong-bao/page.tsx` | Notification CRUD/send/read | `/api/thong-bao`, `/api/toa-nha`, `/api/phong`, `/api/khach-thue` |
| `/dashboard/quan-ly-tai-khoan` | `frontend/src/app/(dashboard)/dashboard/quan-ly-tai-khoan/page.tsx` | Admin users | `/api/admin/users` |
| `/dashboard/ho-so` | `frontend/src/app/(dashboard)/dashboard/ho-so/page.tsx` | Profile/password | `/api/user/profile`, `/api/user/change-password` |
| `/dashboard/cai-dat` | `frontend/src/app/(dashboard)/dashboard/cai-dat/page.tsx` | Local UI settings | localStorage |
| `/dashboard/xem-web` | `frontend/src/app/(dashboard)/dashboard/xem-web/page.tsx` | Iframe web viewer | external URL only |

## Auth va layout

| Khu vuc | Co che |
|---|---|
| Dashboard | `frontend/src/app/(dashboard)/layout.tsx` dung `useSession`; chua login thi push `/dang-nhap` |
| Sidebar | `frontend/src/components/app-sidebar.tsx`; role `admin` moi hien `Quan ly tai khoan` |
| NextAuth | `frontend/src/lib/auth.ts`; credentials goi backend `/api/auth/login`; luu `accessToken` vao session |
| Tenant portal | `frontend/src/app/khach-thue/dashboard/layout.tsx`; token `khachThueToken` trong localStorage |

## Chuan data dang dung

Frontend type dung `_id`, camelCase tieng Viet khong dau. Backend DTO da map nhieu field bang `@JsonProperty("_id")`, `@JsonProperty("maPhong")`, `@JsonProperty("giaThue")`.

Enum quan trong:

| Domain | Frontend | Backend/DB |
|---|---|---|
| Phong | `trong`, `dangThue`, `baoTri`, `daDat` | `AVAILABLE`, `RENTED`, `MAINTENANCE`; `daDat` dang map ve `AVAILABLE` |
| Hoa don | `chuaThanhToan`, `daThanhToanMotPhan`, `daThanhToan`, `quaHan` | `UNPAID`, `PARTIAL`, `PAID`, `OVERDUE` |
| Hop dong | `hoatDong`, `hetHan`, `daHuy` | `ACTIVE`, `EXPIRED`, `TERMINATED` |
| Su co | `PENDING`, `IN_PROGRESS`, `RESOLVED`, `CANCELLED` | runtime dang varchar; docker init co enum |

## Hotspots

1. Backend security hien `permitAll`; can RBAC that cho `/api/admin/users` va tenant data.
2. Tenant token hien la user UUID demo token; can JWT/co expiry/co revoke.
3. Invoice meter reading van parse tu `chi_tiet_hoa_don.mo_ta`; can dung `chi_so_dien_nuoc`.
4. Runtime Docker DB da co 22 public tables; `file_media` chua co neu muon gom upload tai lieu.
5. Upload response co ca `url` va `secure_url`; component dang dung khac nhau, can thong nhat.
6. Nhieu source UI bi mojibake; can chuan hoa encoding truoc demo.
