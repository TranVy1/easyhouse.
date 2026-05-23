-- ============================================================================
-- EasyHouse reference/demo seed data for sql/db.sql
--
-- Purpose:
-- - Minimum data required before using the app: roles, at least one landlord
--   account, one property, rooms, services, and price configuration.
-- - Optional demo data: tenants, contract, contract members, contract services,
--   readings, invoice, invoice details, payment, incident, notification.
--
-- Supabase note:
-- - public.nguoi_dung.id references auth.users(id). Create these Auth users in
--   Supabase Auth first, or run the optional auth.users insert block with a
--   privileged database role in a dev database.
-- - Do not run this seed blindly on production with real customer data.
-- ============================================================================

-- ============================================================================
-- 0. OPTIONAL DEV AUTH USERS
-- ============================================================================
-- In production, create users through Supabase Auth/API instead of direct insert.
-- Password hash below is only a placeholder for local/dev seed databases.
/*
INSERT INTO auth.users (
    instance_id, id, aud, role, email, encrypted_password,
    email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at
) VALUES
    ('00000000-0000-0000-0000-000000000000', '22222222-2222-2222-2222-222222222221', 'authenticated', 'authenticated', 'admin@easyhouse.local', '$2a$10$vI8aWBnW3fID.m4/SNnbA.C9hM9p.cW7uP9GZcTfJ3dD6Q9lT.Yxa', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now()),
    ('00000000-0000-0000-0000-000000000000', '22222222-2222-2222-2222-222222222222', 'authenticated', 'authenticated', 'landlord@easyhouse.local', '$2a$10$vI8aWBnW3fID.m4/SNnbA.C9hM9p.cW7uP9GZcTfJ3dD6Q9lT.Yxa', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now()),
    ('00000000-0000-0000-0000-000000000000', '22222222-2222-2222-2222-222222222223', 'authenticated', 'authenticated', 'staff@easyhouse.local', '$2a$10$vI8aWBnW3fID.m4/SNnbA.C9hM9p.cW7uP9GZcTfJ3dD6Q9lT.Yxa', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now()),
    ('00000000-0000-0000-0000-000000000000', '22222222-2222-2222-2222-222222222224', 'authenticated', 'authenticated', 'tenant@easyhouse.local', '$2a$10$vI8aWBnW3fID.m4/SNnbA.C9hM9p.cW7uP9GZcTfJ3dD6Q9lT.Yxa', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now())
ON CONFLICT (id) DO NOTHING;
*/

-- ============================================================================
-- 1. REQUIRED REFERENCE DATA: ROLES
-- ============================================================================
INSERT INTO public.vai_tro (id, ten, mo_ta) VALUES
    ('11111111-1111-1111-1111-111111111111', 'ADMIN', 'Quan tri he thong'),
    ('11111111-1111-1111-1111-111111111112', 'LANDLORD', 'Chu tro'),
    ('11111111-1111-1111-1111-111111111113', 'STAFF', 'Nhan vien quan ly'),
    ('11111111-1111-1111-1111-111111111114', 'TENANT', 'Nguoi thue')
ON CONFLICT (ten) DO UPDATE SET mo_ta = EXCLUDED.mo_ta;

-- ============================================================================
-- 2. REQUIRED APP USERS / PROFILES
-- These IDs must exist in auth.users.
-- ============================================================================
INSERT INTO public.nguoi_dung (
    id, email, ho_ten, so_dien_thoai, trang_thai
) VALUES
    ('22222222-2222-2222-2222-222222222221', 'admin@easyhouse.local', 'Admin EasyHouse', '0900000001', 'ACTIVE'),
    ('22222222-2222-2222-2222-222222222222', 'landlord@easyhouse.local', 'Nguyen Van Chu', '0900000002', 'ACTIVE'),
    ('22222222-2222-2222-2222-222222222223', 'staff@easyhouse.local', 'Tran Thi Nhan Vien', '0900000003', 'ACTIVE'),
    ('22222222-2222-2222-2222-222222222224', 'tenant@easyhouse.local', 'Le Van Khach', '0900000004', 'ACTIVE')
ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email,
    ho_ten = EXCLUDED.ho_ten,
    so_dien_thoai = EXCLUDED.so_dien_thoai,
    trang_thai = EXCLUDED.trang_thai;

INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES
    ('22222222-2222-2222-2222-222222222221', '11111111-1111-1111-1111-111111111111'),
    ('22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111112'),
    ('22222222-2222-2222-2222-222222222223', '11111111-1111-1111-1111-111111111113'),
    ('22222222-2222-2222-2222-222222222224', '11111111-1111-1111-1111-111111111114')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 3. REQUIRED BUSINESS BASELINE: PROPERTY + STAFF ACCESS + ROOMS
-- ============================================================================
INSERT INTO public.nha_tro (
    id, chu_tro_id, ten, dia_chi, so_nha, duong, phuong, quan, thanh_pho,
    mo_ta, tien_nghi_chung, noi_quy, trang_thai
) VALUES
    (
        '33333333-3333-3333-3333-333333333331',
        '22222222-2222-2222-2222-222222222222',
        'Nha tro EasyHouse Quan 1',
        '123 Tran Hung Dao, Phuong Cau Ong Lanh, Quan 1, TP HCM',
        '123', 'Tran Hung Dao', 'Cau Ong Lanh', 'Quan 1', 'TP HCM',
        'Khu nha tro mau cho demo van hanh',
        'wifi, camera, may giat chung, bai xe',
        'Giu ve sinh chung. Khong gay on sau 22h.',
        'ACTIVE'
    )
ON CONFLICT (id) DO UPDATE SET
    ten = EXCLUDED.ten,
    dia_chi = EXCLUDED.dia_chi,
    trang_thai = EXCLUDED.trang_thai;

INSERT INTO public.nguoi_dung_nha_tro (
    nguoi_dung_id, nha_tro_id, vai_tro, co_quyen_xem, co_quyen_sua, co_quyen_thu_tien
) VALUES
    ('22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333331', 'LANDLORD', true, true, true),
    ('22222222-2222-2222-2222-222222222223', '33333333-3333-3333-3333-333333333331', 'STAFF', true, true, true)
ON CONFLICT (nguoi_dung_id, nha_tro_id, vai_tro) DO UPDATE SET
    co_quyen_xem = EXCLUDED.co_quyen_xem,
    co_quyen_sua = EXCLUDED.co_quyen_sua,
    co_quyen_thu_tien = EXCLUDED.co_quyen_thu_tien;

INSERT INTO public.phong (
    id, nha_tro_id, ten, khu_vuc, tang, dien_tich,
    so_nguoi_toi_da, trang_thai, gia_hien_tai, tien_coc_mac_dinh, mo_ta
) VALUES
    ('44444444-4444-4444-4444-444444444441', '33333333-3333-3333-3333-333333333331', 'P101', 'Khu A', 1, 22.00, 2, 'RENTED', 3500000, 3500000, 'Phong co gac, cua so thoang'),
    ('44444444-4444-4444-4444-444444444442', '33333333-3333-3333-3333-333333333331', 'P102', 'Khu A', 1, 24.00, 3, 'AVAILABLE', 4000000, 4000000, 'Phong trong, san sang cho thue'),
    ('44444444-4444-4444-4444-444444444443', '33333333-3333-3333-3333-333333333331', 'P201', 'Khu A', 2, 28.00, 4, 'MAINTENANCE', 5000000, 5000000, 'Dang bao tri dieu hoa')
ON CONFLICT (id) DO UPDATE SET
    trang_thai = EXCLUDED.trang_thai,
    gia_hien_tai = EXCLUDED.gia_hien_tai,
    tien_coc_mac_dinh = EXCLUDED.tien_coc_mac_dinh;

-- ============================================================================
-- 4. RECOMMENDED REFERENCE DATA: AMENITIES
-- ============================================================================
INSERT INTO public.tien_ich (id, ten, bieu_tuong) VALUES
    ('12121212-1212-1212-1212-121212121201', 'wifi', 'wifi'),
    ('12121212-1212-1212-1212-121212121202', 'dieu_hoa', 'snowflake'),
    ('12121212-1212-1212-1212-121212121203', 'may_giat', 'washing-machine'),
    ('12121212-1212-1212-1212-121212121204', 'bai_xe', 'parking'),
    ('12121212-1212-1212-1212-121212121205', 'camera', 'camera')
ON CONFLICT (ten) DO UPDATE SET bieu_tuong = EXCLUDED.bieu_tuong;

INSERT INTO public.phong_tien_ich (phong_id, tien_ich_id) VALUES
    ('44444444-4444-4444-4444-444444444441', '12121212-1212-1212-1212-121212121201'),
    ('44444444-4444-4444-4444-444444444441', '12121212-1212-1212-1212-121212121202'),
    ('44444444-4444-4444-4444-444444444442', '12121212-1212-1212-1212-121212121201'),
    ('44444444-4444-4444-4444-444444444442', '12121212-1212-1212-1212-121212121204')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 5. REQUIRED FOR BILLING/CONTRACT SERVICES: SERVICES + PRICE CONFIG
-- ============================================================================
INSERT INTO public.dich_vu (
    id, chu_tro_id, ten_dich_vu, loai_tinh_phi, don_vi, don_gia_mac_dinh, bat_buoc
) VALUES
    ('55555555-5555-5555-5555-555555555501', '22222222-2222-2222-2222-222222222222', 'Internet', 'FIXED', 'thang', 100000, true),
    ('55555555-5555-5555-5555-555555555502', '22222222-2222-2222-2222-222222222222', 'Rac sinh hoat', 'PER_ROOM', 'phong/thang', 30000, true),
    ('55555555-5555-5555-5555-555555555503', '22222222-2222-2222-2222-222222222222', 'Gui xe may', 'PER_UNIT', 'xe/thang', 150000, false),
    ('55555555-5555-5555-5555-555555555504', '22222222-2222-2222-2222-222222222222', 'Ve sinh chung', 'PER_ROOM', 'phong/thang', 50000, true)
ON CONFLICT (id) DO UPDATE SET
    ten_dich_vu = EXCLUDED.ten_dich_vu,
    loai_tinh_phi = EXCLUDED.loai_tinh_phi,
    don_vi = EXCLUDED.don_vi,
    don_gia_mac_dinh = EXCLUDED.don_gia_mac_dinh,
    bat_buoc = EXCLUDED.bat_buoc;

-- ELECTRICITY/WATER are price configs; service configs reference dich_vu.
INSERT INTO public.cau_hinh_gia (
    id, nha_tro_id, dich_vu_id, loai, ten_hien_thi, loai_tinh_phi,
    don_gia, hieu_luc_tu, dang_ap_dung
) VALUES
    ('66666666-6666-6666-6666-666666666501', '33333333-3333-3333-3333-333333333331', NULL, 'ELECTRICITY', 'Dien sinh hoat', 'PER_UNIT', 3800, '2026-01-01', true),
    ('66666666-6666-6666-6666-666666666502', '33333333-3333-3333-3333-333333333331', NULL, 'WATER', 'Nuoc sinh hoat', 'PER_UNIT', 25000, '2026-01-01', true),
    ('66666666-6666-6666-6666-666666666503', '33333333-3333-3333-3333-333333333331', '55555555-5555-5555-5555-555555555501', 'INTERNET', 'Internet', 'FIXED', 100000, '2026-01-01', true),
    ('66666666-6666-6666-6666-666666666504', '33333333-3333-3333-3333-333333333331', '55555555-5555-5555-5555-555555555502', 'GARBAGE', 'Rac sinh hoat', 'PER_ROOM', 30000, '2026-01-01', true),
    ('66666666-6666-6666-6666-666666666505', '33333333-3333-3333-3333-333333333331', '55555555-5555-5555-5555-555555555503', 'PARKING', 'Gui xe may', 'PER_UNIT', 150000, '2026-01-01', true),
    ('66666666-6666-6666-6666-666666666506', '33333333-3333-3333-3333-333333333331', '55555555-5555-5555-5555-555555555504', 'SERVICE', 'Ve sinh chung', 'PER_ROOM', 50000, '2026-01-01', true)
ON CONFLICT (id) DO UPDATE SET
    don_gia = EXCLUDED.don_gia,
    dang_ap_dung = EXCLUDED.dang_ap_dung;

-- ============================================================================
-- 6. OPTIONAL DEMO TENANTS / CONTRACT FLOW
-- ============================================================================
INSERT INTO public.khach_thue (
    id, nguoi_dung_id, chu_tro_id, ho_ten, so_dien_thoai, email,
    so_cccd, ngay_sinh, gioi_tinh, dia_chi, que_quan, nghe_nghiep, dang_hoat_dong
) VALUES
    ('77777777-7777-7777-7777-777777777701', '22222222-2222-2222-2222-222222222224', '22222222-2222-2222-2222-222222222222', 'Le Van Khach', '0900000004', 'tenant@easyhouse.local', '079199900001', '1999-05-12', 'Nam', 'Quan 1, TP HCM', 'TP HCM', 'Nhan vien van phong', true),
    ('77777777-7777-7777-7777-777777777702', NULL, '22222222-2222-2222-2222-222222222222', 'Pham Thi O Cung', '0900000005', NULL, '079199900002', '2000-07-20', 'Nu', 'Quan 3, TP HCM', 'TP HCM', 'Sinh vien', true)
ON CONFLICT (id) DO UPDATE SET
    ho_ten = EXCLUDED.ho_ten,
    so_dien_thoai = EXCLUDED.so_dien_thoai,
    dang_hoat_dong = EXCLUDED.dang_hoat_dong;

INSERT INTO public.hop_dong (
    id, phong_id, khach_thue_id, ma_hop_dong,
    ngay_bat_dau, ngay_ket_thuc, gia_thue_hop_dong, tien_coc,
    trang_thai_coc, trang_thai, chu_ky_thanh_toan, ngay_thanh_toan_hang_thang,
    tu_dong_gia_han, chi_so_dien_ban_dau, chi_so_nuoc_ban_dau,
    tien_ich_ban_giao, noi_dung_hop_dong
) VALUES
    (
        '88888888-8888-8888-8888-888888888801',
        '44444444-4444-4444-4444-444444444441',
        '77777777-7777-7777-7777-777777777701',
        'HD-2026-0001',
        '2026-05-01', '2027-04-30', 3500000, 3500000,
        'KEPT', 'ACTIVE', 'MONTHLY', 5,
        true, 120, 35,
        'wifi, dieu_hoa',
        'Hop dong mau. Cac dieu khoan chi tiet duoc thoa thuan giua hai ben.'
    )
ON CONFLICT (id) DO UPDATE SET
    trang_thai = EXCLUDED.trang_thai,
    gia_thue_hop_dong = EXCLUDED.gia_thue_hop_dong;

INSERT INTO public.thanh_vien_hop_dong (
    id, hop_dong_id, khach_thue_id, ho_ten, so_cccd, so_dien_thoai,
    ngay_vao, dang_o, la_nguoi_dai_dien, ghi_chu
) VALUES
    ('99999999-9999-9999-9999-999999999901', '88888888-8888-8888-8888-888888888801', '77777777-7777-7777-7777-777777777701', 'Le Van Khach', '079199900001', '0900000004', '2026-05-01', true, true, 'Nguoi dai dien'),
    ('99999999-9999-9999-9999-999999999902', '88888888-8888-8888-8888-888888888801', '77777777-7777-7777-7777-777777777702', 'Pham Thi O Cung', '079199900002', '0900000005', '2026-05-01', true, false, 'Ban cung phong')
ON CONFLICT (id) DO UPDATE SET
    dang_o = EXCLUDED.dang_o,
    la_nguoi_dai_dien = EXCLUDED.la_nguoi_dai_dien;

INSERT INTO public.dich_vu_hop_dong (
    id, hop_dong_id, dich_vu_id, loai_tinh_phi, don_gia_ap_dung, so_luong, bat_dau_tu
) VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa01', '88888888-8888-8888-8888-888888888801', '55555555-5555-5555-5555-555555555501', 'FIXED', 100000, 1, '2026-05-01'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa02', '88888888-8888-8888-8888-888888888801', '55555555-5555-5555-5555-555555555502', 'PER_ROOM', 30000, 1, '2026-05-01'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa03', '88888888-8888-8888-8888-888888888801', '55555555-5555-5555-5555-555555555503', 'PER_UNIT', 150000, 1, '2026-05-01')
ON CONFLICT (hop_dong_id, dich_vu_id, bat_dau_tu) DO UPDATE SET
    don_gia_ap_dung = EXCLUDED.don_gia_ap_dung,
    so_luong = EXCLUDED.so_luong;

-- ============================================================================
-- 7. OPTIONAL DEMO BILLING / PAYMENT / OPERATIONS
-- ============================================================================
INSERT INTO public.chi_so_dien_nuoc (
    id, phong_id, hop_dong_id, loai, ky_nam, ky_thang,
    ngay_ghi, chi_so_cu, chi_so_moi, nguoi_ghi_id, trang_thai
) VALUES
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbb01', '44444444-4444-4444-4444-444444444441', '88888888-8888-8888-8888-888888888801', 'ELECTRICITY', 2026, 5, '2026-05-31', 120, 180, '22222222-2222-2222-2222-222222222223', 'CONFIRMED'),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbb02', '44444444-4444-4444-4444-444444444441', '88888888-8888-8888-8888-888888888801', 'WATER', 2026, 5, '2026-05-31', 35, 42, '22222222-2222-2222-2222-222222222223', 'CONFIRMED')
ON CONFLICT (phong_id, loai, ky_nam, ky_thang) DO UPDATE SET
    chi_so_moi = EXCLUDED.chi_so_moi,
    trang_thai = EXCLUDED.trang_thai;

INSERT INTO public.hoa_don (
    id, hop_dong_id, phong_id, khach_thue_id, ma_hoa_don,
    ky_nam, ky_thang, tu_ngay, den_ngay,
    so_du_dau_ky, tong_tien_phat_sinh, tong_tien, da_tra,
    trang_thai, han_tra, ghi_chu
) VALUES
    (
        'cccccccc-cccc-cccc-cccc-cccccccccc01',
        '88888888-8888-8888-8888-888888888801',
        '44444444-4444-4444-4444-444444444441',
        '77777777-7777-7777-7777-777777777701',
        'INV-2026-05-P101',
        2026, 5, '2026-05-01', '2026-05-31',
        0, 4009000, 4009000, 1000000,
        'PARTIAL', '2026-06-05', 'Hoa don mau thang 05/2026'
    )
ON CONFLICT (id) DO UPDATE SET
    tong_tien = EXCLUDED.tong_tien,
    da_tra = EXCLUDED.da_tra,
    trang_thai = EXCLUDED.trang_thai;

INSERT INTO public.chi_tiet_hoa_don (
    id, hoa_don_id, dich_vu_id, chi_so_dien_nuoc_id, loai, mo_ta,
    so_luong, don_gia, thanh_tien
) VALUES
    ('dddddddd-dddd-dddd-dddd-dddddddddd01', 'cccccccc-cccc-cccc-cccc-cccccccccc01', NULL, NULL, 'ROOM', 'Tien thue phong P101', 1, 3500000, 3500000),
    ('dddddddd-dddd-dddd-dddd-dddddddddd02', 'cccccccc-cccc-cccc-cccc-cccccccccc01', NULL, 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbb01', 'ELECTRICITY', 'Dien 60 kWh', 60, 3800, 228000),
    ('dddddddd-dddd-dddd-dddd-dddddddddd03', 'cccccccc-cccc-cccc-cccc-cccccccccc01', NULL, 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbb02', 'WATER', 'Nuoc 7 m3', 7, 25000, 175000),
    ('dddddddd-dddd-dddd-dddd-dddddddddd04', 'cccccccc-cccc-cccc-cccc-cccccccccc01', '55555555-5555-5555-5555-555555555501', NULL, 'INTERNET', 'Internet thang 05/2026', 1, 100000, 100000),
    ('dddddddd-dddd-dddd-dddd-dddddddddd05', 'cccccccc-cccc-cccc-cccc-cccccccccc01', '55555555-5555-5555-5555-555555555502', NULL, 'GARBAGE', 'Rac sinh hoat', 1, 30000, 30000),
    ('dddddddd-dddd-dddd-dddd-dddddddddd06', 'cccccccc-cccc-cccc-cccc-cccccccccc01', '55555555-5555-5555-5555-555555555503', NULL, 'PARKING', 'Gui xe may', 1, 150000, 150000)
ON CONFLICT (id) DO UPDATE SET
    so_luong = EXCLUDED.so_luong,
    don_gia = EXCLUDED.don_gia,
    thanh_tien = EXCLUDED.thanh_tien;

INSERT INTO public.thanh_toan (
    id, hoa_don_id, khach_thue_id, so_tien, ngay_thanh_toan,
    phuong_thuc_thanh_toan, ma_tham_chieu, trang_thai, nguoi_ghi_nhan_id, ghi_chu
) VALUES
    (
        'eeeeeeee-eeee-eeee-eeee-eeeeeeeeee01',
        'cccccccc-cccc-cccc-cccc-cccccccccc01',
        '77777777-7777-7777-7777-777777777701',
        1000000, '2026-06-01 09:00:00+07',
        'BANK_TRANSFER', 'VCB-DEMO-0001', 'SUCCESS',
        '22222222-2222-2222-2222-222222222223',
        'Thanh toan mot phan hoa don demo'
    )
ON CONFLICT (id) DO UPDATE SET
    so_tien = EXCLUDED.so_tien,
    trang_thai = EXCLUDED.trang_thai;

INSERT INTO public.su_co (
    id, phong_id, khach_thue_id, nguoi_bao_id, tieu_de, mo_ta,
    loai_su_co, uu_tien, trang_thai, chi_phi_sua_chua, tinh_vao_hoa_don, ghi_chu_chu_nha
) VALUES
    (
        'ffffffff-ffff-ffff-ffff-ffffffffff01',
        '44444444-4444-4444-4444-444444444441',
        '77777777-7777-7777-7777-777777777701',
        '22222222-2222-2222-2222-222222222224',
        'May lanh khong lanh',
        'Khach bao may lanh phong P101 chay yeu.',
        'dien_nuoc', 'trung_binh', 'PENDING', 0, false, NULL
    )
ON CONFLICT (id) DO UPDATE SET
    trang_thai = EXCLUDED.trang_thai,
    mo_ta = EXCLUDED.mo_ta;

INSERT INTO public.thong_bao (
    id, nguoi_gui_id, loai, tieu_de, noi_dung, doi_tuong, doi_tuong_id, kenh, gui_tat_ca
) VALUES
    (
        'abababab-abab-abab-abab-ababababab01',
        '22222222-2222-2222-2222-222222222222',
        'INVOICE',
        'Nhac thanh toan hoa don thang 05/2026',
        'Vui long thanh toan phan con lai truoc ngay 05/06/2026.',
        'INVOICE',
        'cccccccc-cccc-cccc-cccc-cccccccccc01',
        'IN_APP',
        false
    )
ON CONFLICT (id) DO UPDATE SET
    tieu_de = EXCLUDED.tieu_de,
    noi_dung = EXCLUDED.noi_dung;

INSERT INTO public.thong_bao_nguoi_nhan (
    thong_bao_id, nguoi_dung_id, da_doc, gui_luc
) VALUES
    ('abababab-abab-abab-abab-ababababab01', '22222222-2222-2222-2222-222222222224', false, now())
ON CONFLICT (thong_bao_id, nguoi_dung_id) DO UPDATE SET
    da_doc = EXCLUDED.da_doc,
    gui_luc = EXCLUDED.gui_luc;
