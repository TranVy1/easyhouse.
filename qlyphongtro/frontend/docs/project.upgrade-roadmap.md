# EasyHouse upgrade roadmap

Muc tieu: bien EasyHouse thanh do an tot nghiep trong chi chu, co nghiep vu thue nha tro that, co tham chieu PMS/property-management hien dai.

Nguon tham khao nhanh:
- Buildium nhan manh accounting, online rent collection, leasing, screening, maintenance tracking, resident portal, reporting/analytics: [Buildium](https://www.buildium.com/), [Buildium features](https://www.buildium.com/features/).
- AppFolio gom online payments, online maintenance requests, lead-to-lease, property accounting/reports: [AppFolio product](https://www.appfolio.com/about/our-product).
- Avail co tenant portal cho rent payment, maintenance requests, online lease signing, renter profile: [Avail tenant portal](https://www.avail.com/tenants/features).
- Hotel PMS nhu eZee co reservation, front office, check-in/check-out, housekeeping, deposits/invoicing, audit trails, rate/occupancy, reporting: [eZee Absolute PMS](https://www.ezeeabsolute.com/hotel-pms-software.php), [front office features](https://www.ezeeabsolute.com/features/front-office.php).

## Ket luan nang cap

EasyHouse nen di theo huong "rental property PMS": khong can day du nhu khach san, nhung nen co day du vong doi phong: dang tin -> hen xem phong -> dat coc -> hop dong -> ghi chi so -> hoa don -> thanh toan -> su co/bao tri -> thong bao -> bao cao.

Phan dang co nen giu: toa nha, phong, khach thue, hop dong, hoa don, thanh toan, su co, thong bao.

Phan can lam de do an sang han: lich hen/dat coc, tenant portal, gia dich vu theo thoi gian, chi so dien nuoc rieng, bao cao tai chinh, upload tai lieu, audit log, role/permission, seed demo data.

## P0 - Sua nen tang truoc khi them tinh nang

- [x] Sua endpoint hoa don edit:
  - Frontend `/dashboard/hoa-don/[id]` dung `GET /api/hoa-don/{id}`.
  - Frontend update dung `PUT /api/hoa-don/{id}`.
  - Smoke tested `GET /api/hoa-don/{id}` direct backend and via Next rewrite.
- [x] Them truong hoa don can thiet:
  - DB: `ma_hoa_don`, `ngay_phat_hanh`, `ngay_gui`, `da_gui`, `tien_giam`, `phi_phat_sinh`.
  - DB enum: them `OVERDUE` cho `trang_thai_hoa_don`.
  - Backend entity/DTO/service map cac truong moi.
- [x] Map truong hop dong co san trong DB:
  - `trang_thai_coc`, `so_tien_hoan_coc`, `ngay_hoan_coc`.
  - `file_pdf`, `chu_ky_chu_tro`, `chu_ky_khach_thue`.
- [x] Chot role map co ban:
  - Backend DB roles: `ADMIN`, `LANDLORD`, `TENANT`; service se tao `STAFF` khi can.
  - Frontend session role map ve `admin`, `chuNha`, `nhanVien`, `tenant`.
  - Sidebar admin co the hien dung sau login.
- [x] Sua tenant auth co ban:
  - Tao `POST /api/auth/khach-thue/login`.
  - Tao `GET /api/auth/khach-thue/me`.
  - Tenant dashboard lay phong/hop dong/hoa don theo khach thue dang nhap.
  - Password tenant moi duoc BCrypt; plaintext cu duoc nang cap khi login thanh cong.
- [ ] Nang cap tenant auth:
  - Token co expiry/revoke; logout xoa token.
  - Tenant chi xem duoc data cua minh bang backend auth filter that.
- [x] Sua admin users co ban:
  - Tao `GET/POST/PUT/DELETE /api/admin/users`.
  - Khong tra `mat_khau`.
- [ ] Them backend RBAC cho admin users; hien dev security van `permitAll`.
- [x] Bo `/api/test-payment` khoi frontend/rewrite.
- [ ] Fix encoding mojibake trong source UI de demo khong bi loi font.
- [ ] Tat dan `typescript.ignoreBuildErrors` va `eslint.ignoreDuringBuilds` sau khi fix type.
- [ ] Tao seed demo:
  - 1 admin, 1 chu tro, 1 nhan vien, 2 tenant.
  - 2 nha tro, 8 phong, 3 hop dong active, 2 hoa don, 2 thanh toan, 2 su co.
  - Script seed chay duoc trong Docker.

## P1 - Cleanup database cho dung nghiep vu

- [ ] Dia chi nha tro:
  - Chon chuan `so_nha`, `duong`, `phuong`, `quan`, `thanh_pho`.
  - `dia_chi` la generated/display string hoac bo.
  - Bo/khong dung `tinh/huyen/xa` neu da dung `thanh_pho/quan/phuong`.
- [ ] Khach thue:
  - Chon chuan tenant co `nguoi_dung_id` de login.
  - Bo `khach_thue.email/mat_khau/ho_ten/so_dien_thoai` hoac coi la snapshot va ghi ro.
  - Chon `anh_cccd_truoc/sau`, bo `anh_cccd` jsonb, hoac nguoc lai.
- [ ] Hop dong:
  - `khach_thue_id` = nguoi dai dien.
  - `thanh_vien_hop_dong` = danh sach nguoi o.
  - Bo `khach_thue_ids` jsonb sau migration.
  - Them rang buoc phong khong co 2 hop dong `ACTIVE` cung thoi gian.
- [ ] Tien ich:
  - Dung `tien_ich` + `phong_tien_ich` lam chuan.
  - Bo `phong.tien_nghi` jsonb sau khi migrate.
- [ ] Thong bao:
  - Tao bang `thong_bao_nguoi_nhan(id, thong_bao_id, nguoi_dung_id, da_doc, doc_luc)`.
  - Tao bang `nhom_thong_bao` neu can group.
  - Bo cac cot trung `da_doc_json`, `nguoi_nhan`, `phong`, `phong_ids` sau migration.
- [x] Hoa don:
  - Them `ma_hoa_don` unique.
  - Them `ngay_phat_hanh`, `ngay_gui`, `phi_phat_sinh`, `tien_giam`.
  - Them status `OVERDUE` neu UI co `quaHan`.
- [ ] Thanh toan:
  - Them `anh_bien_lai`, `provider`, `transaction_id`, `idempotency_key`, `phi_giao_dich`.
  - Them refund fields: `so_tien_hoan`, `ngay_hoan`, `ly_do_hoan`.
- [ ] Index/constraint:
  - Index tat ca FK.
  - Index `phong(nha_tro_id, trang_thai)`.
  - Index `hop_dong(phong_id, trang_thai, ngay_bat_dau, ngay_ket_thuc)`.
  - Index `hoa_don(hop_dong_id, thang_hoa_don)`.
  - Unique `hoa_don(hop_dong_id, thang_hoa_don)`.
  - Check amount >= 0; meter moi >= meter cu; date end >= start.

## P2 - Lead, xem phong, dat coc

- [ ] Public room listing nang cap:
  - Search theo khu vuc, gia, dien tich, so nguoi, tien ich, trang thai.
  - Anh carousel, tien ich, gia dien/nuoc/dich vu, dieu kien coc.
  - CTA: "Hen xem phong", "Dat coc".
- [ ] `lich_hen` workflow:
  - Form public: ho ten, phone, email, phong, ngay gio muon xem, ghi chu.
  - Staff dashboard: list calendar, confirm/cancel/complete.
  - Notification/email khi confirm.
  - Chuyen lich hen thanh dat coc/hop dong.
- [ ] `dat_coc_phong` workflow:
  - Tao dat coc tu phong/lich hen.
  - Trang thai: PENDING -> COMPLETED -> REFUNDED/FORFEITED.
  - Deadline giu phong; qua han tu dong release.
  - Luu payment/bien lai coc.
  - Khi ky hop dong, link `hop_dong_id`.
- [ ] Room status board:
  - `AVAILABLE`, `RESERVED`, `RENTED`, `MAINTENANCE`, `CLEANING`.
  - Timeline lich hen/dat coc/hop dong tren tung phong.

## P3 - Hop dong chuyen nghiep

- [ ] Mau hop dong:
  - Table `mau_hop_dong(id, ten, noi_dung_template, version)`.
  - Placeholder: tenant, room, rent, deposit, dates, utility prices.
- [ ] Sinh PDF hop dong:
  - Preview HTML.
  - Export PDF.
  - Luu URL/file vao `file_hop_dong` hoac `file_media`.
- [ ] Chu ky:
  - Upload anh chu ky chu tro/tenant hoac checkbox "da ky".
  - Luu `chu_ky_chu_tro`, `chu_ky_khach_thue`, `ky_luc`.
- [ ] Thanh vien o cung:
  - Them/sua/xoa thanh vien.
  - CCCD, phone, tam tru, dang_o.
  - Export danh sach tam tru.
- [ ] Gia tai thoi diem ky:
  - Copy gia dien/nuoc/dich vu tu `cau_hinh_gia` vao hop dong.
  - Khi `cau_hinh_gia` doi, hop dong cu khong bi doi.
- [ ] Ket thuc hop dong:
  - Notice truoc ngay het han.
  - Tinh hoan coc/khau tru.
  - Checklist ban giao phong.
  - Cap nhat phong ve `AVAILABLE` hoac `MAINTENANCE`.

## P4 - Ghi chi so va hoa don dung nghiep vu

- [ ] Dung bang `chi_so_dien_nuoc` that:
  - CRUD chi so theo phong/thang.
  - Upload anh dong ho dien/nuoc.
  - Validate chi so moi >= chi so cu.
  - Lich su chi so theo phong.
- [ ] Hoa don tu dong:
  - Chon thang/nam -> load hop dong active.
  - Lay chi so dau/cuoi tu `chi_so_dien_nuoc`.
  - Lay don gia tu hop dong.
  - Tao line item: room, electricity, water, service, internet, parking, garbage, other.
- [ ] Gui hoa don:
  - Public link `/hoa-don/{id}`.
  - QR/VietQR.
  - Email/thong bao tenant.
  - `ngay_gui` va `da_gui`.
- [ ] Qua han va nhac no:
  - Job ngay: neu `han_tra < today` va con no, set `OVERDUE`.
  - Nhac truoc han 3 ngay, dung han, qua han 3/7 ngay.
  - Dashboard cong no.
- [ ] Lich su hoa don:
  - Ghi log moi lan tao/sua/gui/thanh toan/huy.
  - Hien timeline trong UI.

## P5 - Thanh toan va accounting

- [ ] Payment lifecycle:
  - Status: PENDING, SUCCESS, FAILED, REFUNDED.
  - Manual cash, bank transfer, wallet, QR/VietQR.
  - Upload bien lai.
  - Chon hoa don va ap so tien thanh toan.
- [ ] Idempotency:
  - Khong cho ghi duplicate transaction id.
  - `idempotency_key` cho webhook/payment callback.
- [ ] So quy don gian:
  - Table `thu_chi(id, nha_tro_id, loai, so_tien, ngay, danh_muc, ghi_chu, file_dinh_kem)`.
  - Thu: tien phong, tien coc, phi.
  - Chi: sua chua, dien/nuoc tong, internet, ve sinh, vat tu.
- [ ] Bao cao:
  - Doanh thu theo thang/nam.
  - Cong no theo tenant/phong.
  - Ty le lap day.
  - Su co theo status/chi phi.
  - Export Excel/PDF.
- [ ] Doi soat:
  - Loc thanh toan theo ngay/phuong thuc.
  - Tong thu tien mat/chuyen khoan.
  - Bien lai thu tien printable.

## P6 - Tenant portal

- [ ] Tenant dashboard:
  - Phong dang o.
  - Hop dong active.
  - Hoa don chua thanh toan/lich su.
  - Su co da bao.
  - Thong bao.
- [ ] Tenant actions:
  - Tai hop dong PDF.
  - Xem/tra hoa don.
  - Gui su co kem anh.
  - Dat lich hen voi chu tro.
  - Cap nhat thong tin ca nhan.
- [ ] Security:
  - Tenant chi xem record co `khach_thue_id` cua minh.
  - Backend filter theo token, khong tin id tu frontend.

## P7 - Bao tri/su co chuyen nghiep

- [ ] Work order:
  - Mo rong `su_co` thanh quy trinh: PENDING -> IN_PROGRESS -> RESOLVED -> CANCELLED.
  - Them `ngay_du_kien`, `ngay_bat_dau`, `ngay_hoan_tat`.
  - Them `chi_phi_du_kien`, `chi_phi_thuc_te`.
- [ ] Assignee/vendor:
  - Table `nha_cung_cap` hoac dung `nguoi_dung` role `STAFF`.
  - Gan nguoi phu trach.
  - Note noi bo.
- [ ] SLA:
  - Uu tien `khan_cap` can xu ly trong X gio.
  - Dashboard qua SLA.
- [ ] Lien ket chi phi:
  - Khi su co co chi phi, tao `thu_chi` loai chi.
  - Neu tenant phai tra, tao line item invoice.

## P8 - Notifications va communication

- [ ] Notification center:
  - Recipient normalized per user.
  - Read/unread per user.
  - Filter by invoice/contract/incident/general.
- [ ] Templates:
  - Invoice due.
  - Payment received.
  - Contract expiry.
  - Appointment confirmed.
  - Maintenance update.
- [ ] Delivery:
  - In-app first.
  - Email optional.
  - SMS/Zalo optional demo note, khong bat buoc implement.
- [ ] Scheduled jobs:
  - Remind due invoice.
  - Remind expiring contract.
  - Remind appointment.

## P9 - UI/UX cho do an

- [ ] Dashboard tong quan:
  - Occupancy rate.
  - Monthly revenue.
  - Outstanding debt.
  - Open maintenance.
  - Contracts expiring soon.
- [ ] Calendar/timeline:
  - Lich hen xem phong.
  - Contract start/end.
  - Invoice due dates.
- [ ] Room board:
  - Grid theo toa nha/tang.
  - Mau theo status.
  - Click phong -> drawer: tenant, contract, invoice, incidents.
- [ ] Empty/loading/error states:
  - Moi page co skeleton/loading.
  - Empty state co CTA tao moi.
  - Error state co retry.
- [ ] Search/filter/export:
  - Moi bang quan ly co search, filter, sort, pagination.
  - Export CSV/XLSX cho bao cao.
- [ ] Demo polish:
  - Text Viet dung encoding.
  - Responsive mobile.
  - Print invoice/contract dep.

## P10 - Testing, security, deployment

- [ ] Backend tests:
  - Auth/login/register.
  - Room CRUD.
  - Contract create/end.
  - Invoice generation.
  - Payment partial/full.
  - Tenant permission.
- [ ] Frontend tests/smoke:
  - Login.
  - Create building/room/tenant/contract/invoice/payment.
  - Tenant portal view invoice.
- [ ] API contract:
  - Document request/response per endpoint.
  - Fix all frontend/backend field mismatch.
- [ ] Security:
  - Password hashing checked.
  - CORS/proxy only intended URLs.
  - RBAC per endpoint.
  - No sensitive data in public invoice URL.
- [ ] Docker:
  - One command start.
  - Seed demo command.
  - README demo account.
- [ ] Graduation deliverables:
  - ERD diagram.
  - Use-case diagram.
  - Sequence diagrams: login, create contract, generate invoice, payment, incident.
  - Screenshots of main flows.
  - Test cases table.

## De xuat thu tu lam trong 3 sprint

### Sprint 1 - On dinh core

- [ ] Fix endpoint mismatch + auth/role + encoding.
  - Done: hoa don edit endpoint, tenant auth co ban, admin users co ban, role map.
  - Con lai: encoding + RBAC/token that.
- [ ] Cleanup DB field decisions, migration notes.
- [ ] Seed demo data.
- [ ] Contract CRUD and invoice CRUD pass end-to-end.

### Sprint 2 - Nghiep vu thue nha

- [ ] Lich hen xem phong.
- [ ] Dat coc.
- [ ] Tenant portal.
- [ ] Chi so dien nuoc + invoice generation from readings.
- [ ] Payment receipt + debt dashboard.

### Sprint 3 - Polish do an

- [ ] Reports/export.
- [ ] Maintenance workflow.
- [ ] Notification reminders.
- [ ] Print/PDF invoice and contract.
- [ ] ERD/use-case/sequence/test docs.
