# EasyHouse API map tu frontend

Nguon quet: `frontend/next.config.ts`, `frontend/src/app/**`, `frontend/src/components/ui/*upload*.tsx`, `be/src/main/java/.../controller`.

## Proxy rewrites

`frontend/next.config.ts` rewrite cac nhom API sau sang backend:

| Frontend path | Backend path |
|---|---|
| `/api/auth/register` | `/api/auth/register` |
| `/api/auth/forgot-password` | `/api/auth/forgot-password` |
| `/api/phong`, `/api/phong/:path*` | `/api/phong`, `/api/phong/:path*` |
| `/api/toa-nha`, `/api/toa-nha/:path*` | `/api/toa-nha`, `/api/toa-nha/:path*` |
| `/api/khach-thue`, `/api/khach-thue/:path*` | `/api/khach-thue`, `/api/khach-thue/:path*` |
| `/api/dashboard/:path*` | `/api/dashboard/:path*` |
| `/api/hop-dong`, `/api/hop-dong/:path*` | `/api/hop-dong`, `/api/hop-dong/:path*` |
| `/api/hoa-don`, `/api/hoa-don/:path*` | `/api/hoa-don`, `/api/hoa-don/:path*` |
| `/api/hoa-don-public/:path*` | `/api/hoa-don-public/:path*` |
| `/api/upload` | `/api/upload` |
| `/api/thanh-toan`, `/api/thanh-toan/:path*` | `/api/thanh-toan`, `/api/thanh-toan/:path*` |
| `/api/thong-bao`, `/api/thong-bao/:path*` | `/api/thong-bao`, `/api/thong-bao/:path*` |
| `/api/su-co`, `/api/su-co/:path*` | `/api/su-co`, `/api/su-co/:path*` |
| `/api/admin/:path*` | `/api/admin/:path*` |
| `/api/user/:path*` | `/api/user/:path*` |

## Local Next API proxy routes

| Frontend route handler | Backend target | Note |
|---|---|---|
| `frontend/src/app/api/auth/khach-thue/[...path]/route.ts` | `/api/auth/khach-thue/{path}` | Proxy tenant auth because NextAuth owns `/api/auth/[...nextauth]` |

## Backend endpoints thay duoc

| Controller | Endpoint | Method |
|---|---|---|
| `AuthController` | `/api/auth/login` | POST |
| `AuthController` | `/api/auth/register` | POST |
| `AuthController` | `/api/auth/verify-email` | GET |
| `AuthController` | `/api/auth/forgot-password` | POST |
| `AuthController` | `/api/auth/khach-thue/login` | POST |
| `AuthController` | `/api/auth/khach-thue/me` | GET |
| `AdminUserController` | `/api/admin/users` | GET, POST, PUT id, DELETE id |
| `DashboardController` | `/api/dashboard/stats` | GET |
| `NhaTroController` | `/api/nha-tro`, `/api/toa-nha` | GET, GET id, POST, PUT id, DELETE id |
| `PhongController` | `/api/phong` | GET, GET id, POST, PUT id, DELETE id |
| `KhachThueController` | `/api/khach-thue` | GET, GET id, POST, PUT id, DELETE id |
| `HopDongController` | `/api/hop-dong` | GET, GET id, POST, PUT id, DELETE id |
| `HoaDonController` | `/api/hoa-don` | GET, GET id, POST, PUT id, DELETE id, DELETE query |
| `HoaDonController` | `/api/hoa-don/form-data` | GET |
| `HoaDonController` | `/api/hoa-don/latest-reading` | GET |
| `HoaDonController` | `/api/hoa-don/{id}/thanh-toan` | POST |
| `HoaDonPublicController` | `/api/hoa-don-public/{id}` | GET |
| `ThanhToanController` | `/api/thanh-toan` | GET, GET id, GET by invoice, POST, PUT id, DELETE id |
| `ThongBaoController` | `/api/thong-bao` | GET, GET id, POST, PUT id, DELETE id, DELETE query |
| `ThongBaoController` | `/api/thong-bao/{id}/da-doc` | PATCH |
| `ThongBaoController` | `/api/thong-bao/{id}/send` | POST |
| `SuCoController` | `/api/su-co` | GET, GET id, POST, PUT id, DELETE id |
| `UploadController` | `/api/upload` | POST multipart, DELETE id/query |
| `UserController` | `/api/user/profile`, `/api/user/change-password` | GET, PUT, POST |
| `ChiSoDienNuocController` | `/api/chi-so-dien-nuoc` | placeholder GET/POST |

## Frontend screen to API/backend/db

| Frontend route | API call | Backend | DB touched | Note |
|---|---|---|---|---|
| `/dang-nhap` | NextAuth credentials -> `/api/auth/login` | `AuthController`, `AuthService` | `nguoi_dung`, `vai_tro`, `nguoi_dung_vai_tro` | Backend returns token/session data |
| `/dang-nhap` | `POST /api/auth/forgot-password` | `AuthController`, `AuthService`, `EmailService` | `nguoi_dung` | Sends reset password email |
| `/dang-ky` | `POST /api/auth/register` | `AuthController`, `AuthService` | `nguoi_dung`, `vai_tro`, `nguoi_dung_vai_tro`, `email_verification_token` | Frontend sends `ten`; backend maps to `hoTen` |
| `/xac-thuc-email` | `GET /api/auth/verify-email?token=...` | `AuthController` | `email_verification_token`, `nguoi_dung` | Marks user active |
| `/xem-phong` | `GET /api/phong?limit=100&toaNha=&trangThai=` | `PhongController`, `PhongService` | `phong`, `nha_tro`, `hop_dong` | Filters building/status |
| `/xem-phong` | `GET /api/toa-nha` | `NhaTroController` | `nha_tro`, `phong` | Dropdown building |
| `/hoa-don/[id]` | `GET /api/hoa-don-public/{id}` | `HoaDonPublicController` | `hoa_don`, `chi_tiet_hoa_don`, `phong`, `khach_thue`, `thanh_toan` | Public bill view |
| `/khach-thue/dang-nhap` | `POST /api/auth/khach-thue/login` | `AuthController`, `AuthService` | `khach_thue`, `nguoi_dung` | Stores tenant token in localStorage |
| `/khach-thue/dashboard` | `GET /api/auth/khach-thue/me` | `AuthController`, `AuthService` | `khach_thue`, `hop_dong`, `phong`, `hoa_don` | Uses tenant token |
| `/dashboard` | `GET /api/dashboard/stats` | `DashboardController`, `DashboardService` | `phong`, `hoa_don`, `su_co`, `hop_dong` | Stats cards |
| `/dashboard/toa-nha` | CRUD `/api/toa-nha` | `NhaTroController`, `NhaTroService` | `nha_tro`, `phong` | Uses external province API for address |
| `/dashboard/phong` | CRUD `/api/phong`; list `/api/toa-nha` | `PhongController`, `PhongService` | `phong`, `nha_tro`, `hop_dong` | Status map important |
| `/dashboard/khach-thue` | CRUD `/api/khach-thue` | `KhachThueController`, `KhachThueService` | `khach_thue`, `nguoi_dung`, `hop_dong` | CCCD upload component |
| `/dashboard/hop-dong` | list/update/delete `/api/hop-dong` | `HopDongController`, `HopDongService` | `hop_dong`, `phong`, `khach_thue` | Quick status update |
| `/dashboard/hop-dong/them-moi` | `GET /api/phong`, `GET /api/khach-thue`, `POST /api/hop-dong` | `HopDongController` | `hop_dong`, `phong`, `khach_thue` | Creates contract, stores service fees jsonb |
| `/dashboard/hop-dong/[id]` | `GET/PUT /api/hop-dong/{id}` | `HopDongController` | `hop_dong`, `phong`, `khach_thue` | Same form as create |
| `/dashboard/hoa-don` | `GET /api/hoa-don`, `GET /api/hoa-don/form-data` | `HoaDonController`, `HoaDonService` | `hoa_don`, `chi_tiet_hoa_don`, `hop_dong`, `phong`, `khach_thue` | Payment dialog hits invoice payment endpoint |
| `/dashboard/hoa-don/them-moi` | `GET /api/hoa-don/latest-reading`, `POST /api/hoa-don` | `HoaDonController` | `hoa_don`, `chi_tiet_hoa_don`, `hop_dong` | Computes electricity/water on frontend |
| `/dashboard/hoa-don/[id]` | `GET /api/hoa-don/{id}`, `PUT /api/hoa-don/{id}` | `HoaDonController` | `hoa_don`, `chi_tiet_hoa_don` | Endpoint mismatch fixed |
| `/dashboard/thanh-toan` | CRUD `/api/thanh-toan`, `GET /api/hoa-don` | `ThanhToanController`, `HoaDonController` | `thanh_toan`, `hoa_don` | Removed dead `/api/test-payment` call |
| `/dashboard/su-co` | CRUD `/api/su-co` plus lists | `SuCoController`, `SuCoService` | `su_co`, `phong`, `khach_thue`, `hop_dong` | Auto-pick tenant from active contract |
| `/dashboard/thong-bao` | CRUD/send/read `/api/thong-bao` plus lists | `ThongBaoController`, `ThongBaoService` | `thong_bao`, `nguoi_dung`, jsonb `phong_ids` | Recipient model differs from TS type |
| `/dashboard/quan-ly-tai-khoan` | `/api/admin/users` | `AdminUserController`, `UserService` | `nguoi_dung`, `vai_tro`, `nguoi_dung_vai_tro` | Basic CRUD done; RBAC still needed |
| `/dashboard/ho-so` | `/api/user/profile`, `/api/user/change-password` | `UserController`, `UserService` | `nguoi_dung` | Sends bearer from NextAuth session |
| `/dashboard/cai-dat` | none | none | none | localStorage only |
| `/dashboard/xem-web` | external iframe URL | none | none | CSP/X-Frame-Options can block |

## Query/filter notes

| Domain | Query/filter |
|---|---|
| Phong | `toaNha`, `trangThai`; service uses `findByNhaTroId`, `findByTrangThai`, `findByNhaTroIdAndTrangThai` |
| Khach thue | frontend sends `trangThai`; backend computes status TODO and currently tends to `chuaThue` |
| Hoa don latest reading | `hopDong`, `thang`, `nam`; backend finds latest invoice by contract, parses `ChiTietHoaDon.moTa` range like `old-new` |
| Dashboard stats | repository counts/status totals, revenue from invoices/payments |
| Thong bao | frontend filters type and target client-side after full list |
| Su co | frontend filters status/type/priority client-side after full list |

## Remaining mismatch/risk list

| Gap | Impact |
|---|---|
| Backend security currently `permitAll` | Admin users endpoint needs real RBAC before production/demo grading |
| Tenant token is user UUID demo token | Needs JWT/expiry/revoke to be clean |
| `daDat` room status maps to `AVAILABLE` | Booked room not persisted separately |
| Invoice meter readings still parsed from `chi_tiet_hoa_don.mo_ta` | Should move to `chi_so_dien_nuoc` for audit |
