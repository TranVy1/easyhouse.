# Khach thue dang nhap form note

- Route: `/khach-thue/dang-nhap`
- Frontend: `frontend/src/app/khach-thue/dang-nhap/page.tsx`
- Router links: success -> `/khach-thue/dashboard`
- Form fields: `soDienThoai`, `matKhau`
- API:
  - `POST /api/auth/khach-thue/login`
  - body `{ soDienThoai, matKhau }`
- Backend:
  - `AuthController.khachThueLogin`
  - `AuthService.loginKhachThue`
- DB:
  - `khach_thue`
  - `nguoi_dung`
- Logic:
  - On success, stores `khachThueToken` and `khachThueData` in localStorage.
  - Tenant auth is separate from NextAuth dashboard auth.
- Can luu y:
  - Current backend token is demo user UUID; upgrade to JWT/expiry/revoke before final.
