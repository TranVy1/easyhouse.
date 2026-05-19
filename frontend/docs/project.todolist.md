# EasyHouse frontend-facing todolist

Scope: viec can lam de frontend, API, backend, DB khop nhau. File nay chi dat trong `frontend/`.

## P0 - da sua trong dot 2026-05-19

- [x] Sua `/dashboard/hoa-don/[id]`: `GET /api/hoa-don/{id}`.
- [x] Sua `/dashboard/hoa-don/[id]`: `PUT /api/hoa-don/{id}`.
- [x] Them field hoa don core: `maHoaDon`, `ngayPhatHanh`, `ngayGui`, `daGui`, `tienGiam`, `phiPhatSinh`.
- [x] Map `quaHan` <-> `OVERDUE` trong invoice service.
- [x] Map field hop dong co san trong DB: coc, hoan coc, file PDF, chu ky.
- [x] Them backend cho `/api/auth/khach-thue/login`.
- [x] Them backend cho `/api/auth/khach-thue/me`.
- [x] Them backend CRUD co ban cho `/api/admin/users`.
- [x] Xoa call/rewrite `/api/test-payment` trong man hinh thanh toan.
- [x] Sua role map dashboard: `ADMIN -> admin`, `LANDLORD -> chuNha`, `STAFF -> nhanVien`, `TENANT -> tenant`.
- [x] Hash password khi tao khach thue moi; tenant login tu dong nang plaintext cu len BCrypt khi dang nhap thanh cong.

## P0 - con can lam de demo chac

- [ ] Them RBAC thuc su cho `/api/admin/users`; hien backend dev security dang `permitAll`.
- [ ] Doi tenant token localStorage sang JWT/co expiry/co revoke; hien token la user UUID demo.
- [ ] Fix encoding mojibake tren cac page de demo khong loi font.
- [ ] Tao seed demo sach: admin, chu tro, nhan vien, tenant, nha tro, phong, hop dong, hoa don, thanh toan, su co.

## P1 - data/schema consistency

- [x] Chot schema review hien tai theo runtime Docker DB `easyhouse-postgres` / database `easyhouse`.
- [x] Runtime DB da co cac bang chinh: `cau_hinh_gia`, `chi_so_dien_nuoc`, `lich_hen`, `tien_ich`, `dat_coc_phong`, `thanh_vien_hop_dong`.
- [ ] Quyet dinh co can them `file_media` rieng hay tiep tuc luu URL tren entity.
- [ ] Thong nhat enum phong: them `BOOKED`/`daDat` hoac bo `daDat` tren frontend.
- [ ] Thong nhat notification model: frontend `nguoiNhan[]` vs runtime `nguoi_dung_id` + `da_doc` boolean.
- [ ] Tach chi so dien nuoc that sang table `chi_so_dien_nuoc`; hien invoice van parse chi so tu `chi_tiet_hoa_don.mo_ta`.
- [ ] Them unique/check constraint: `hoa_don(hop_dong_id, thang_hoa_don)`, amount >= 0, meter moi >= meter cu, ngay ket thuc >= ngay bat dau.

## P2 - frontend quality

- [ ] Bo `typescript.ignoreBuildErrors=true` va `eslint.ignoreDuringBuilds=true` sau khi fix type.
- [ ] Thong nhat upload response: dung `secure_url` hoac `url` mot kieu.
- [ ] Gom API client/helper cho `ApiResponse<T>`, auth header, error toast.
- [ ] Doi dashboard forms lon tu `useState` thu cong sang schema validation co chon loc.
- [ ] Cache/sessionStorage can co invalidate tap trung thay vi xoa tung key.
- [ ] Chuan hoa text encoding trong source vi nhieu file dang hien mojibake.

## P3 - docs/process

- [x] Cap nhat note `.md` cho cac page da doi endpoint: hoa don edit, tenant auth, admin users, thanh toan.
- [ ] Them API contract tests cho cac route frontend dang dung.
- [ ] Them checklist release: frontend build, backend test, docker compose smoke, DB migration.
