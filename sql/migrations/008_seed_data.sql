-- ========================================================================
-- 11. SEED ROLES
-- ========================================================================

INSERT INTO public.vai_tro (ten, mo_ta)
VALUES
    ('ADMIN', 'Quan tri he thong'),
    ('LANDLORD', 'Chu tro'),
    ('STAFF', 'Nhan vien quan ly'),
    ('TENANT', 'Nguoi thue')
ON CONFLICT (ten) DO NOTHING;


-- ==============================================================================
-- DỮ LIỆU MẪU (SEED DATA) CHO EASYHOUSE POSTGRESQL
-- (Dùng để kiểm thử sau khi chạy file db.sql)
-- ==============================================================================

-- 1. Bảng vai_tro
INSERT INTO vai_tro (id, ten, mo_ta) VALUES
('11111111-1111-1111-1111-111111111111', 'ADMIN', 'Quản trị viên hệ thống'),
('11111111-1111-1111-1111-111111111112', 'LANDLORD', 'Chủ nhà trọ'),
('11111111-1111-1111-1111-111111111113', 'TENANT', 'Khách thuê phòng')
ON CONFLICT (id) DO NOTHING;

-- 2. Bảng auth.users (Phải tạo user bên Auth trước khi insert vào nguoi_dung)
INSERT INTO auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at) VALUES
('00000000-0000-0000-0000-000000000000', '22222222-2222-2222-2222-222222222221', 'authenticated', 'authenticated', 'admin@easyhouse.com', '$2a$10$vI8aWBnW3fID.m4/SNnbA.C9hM9p.cW7uP9GZcTfJ3dD6Q9lT.Yxa', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now()),
('00000000-0000-0000-0000-000000000000', '22222222-2222-2222-2222-222222222222', 'authenticated', 'authenticated', 'chunha@easyhouse.com', '$2a$10$vI8aWBnW3fID.m4/SNnbA.C9hM9p.cW7uP9GZcTfJ3dD6Q9lT.Yxa', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now()),
('00000000-0000-0000-0000-000000000000', '22222222-2222-2222-2222-222222222223', 'authenticated', 'authenticated', 'khachthue1@easyhouse.com', '$2a$10$vI8aWBnW3fID.m4/SNnbA.C9hM9p.cW7uP9GZcTfJ3dD6Q9lT.Yxa', now(), '{"provider":"email","providers":["email"]}', '{}', now(), now())
ON CONFLICT (id) DO NOTHING;

-- 2.1. Bảng nguoi_dung (Profile của user)
INSERT INTO nguoi_dung (id, email, ho_ten, so_dien_thoai, trang_thai) VALUES
('22222222-2222-2222-2222-222222222221', 'admin@easyhouse.com', 'Admin System', '0901234567', 'ACTIVE'),
('22222222-2222-2222-2222-222222222222', 'chunha@easyhouse.com', 'Trần Văn Chủ', '0912345678', 'ACTIVE'),
('22222222-2222-2222-2222-222222222223', 'khachthue1@easyhouse.com', 'Nguyễn Thị Khách', '0987654321', 'ACTIVE')
ON CONFLICT (id) DO NOTHING;

-- 3. Bảng nguoi_dung_vai_tro
INSERT INTO nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES
('22222222-2222-2222-2222-222222222221', '11111111-1111-1111-1111-111111111111'),
('22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111112'),
('22222222-2222-2222-2222-222222222223', '11111111-1111-1111-1111-111111111113')
ON CONFLICT DO NOTHING;

-- 4. Bảng nha_tro
INSERT INTO nha_tro (id, chu_tro_id, ten, dia_chi, so_nha, duong, phuong, quan, thanh_pho, mo_ta) VALUES
('33333333-3333-3333-3333-333333333331', '22222222-2222-2222-2222-222222222222', 'Nhà Trọ Trần Hưng Đạo', '123 Trần Hưng Đạo, Cầu Ông Lãnh, Quận 1, TP HCM', '123', 'Trần Hưng Đạo', 'Cầu Ông Lãnh', 'Quận 1', 'TP HCM', 'Khu trọ an ninh'),
('33333333-3333-3333-3333-333333333332', '22222222-2222-2222-2222-222222222222', 'Chung Cư Mini Gò Vấp', '45 Phan Văn Trị, Phường 10, Quận Gò Vấp, TP HCM', '45', 'Phan Văn Trị', 'Phường 10', 'Quận Gò Vấp', 'TP HCM', 'Gần đại học')
ON CONFLICT (id) DO NOTHING;

-- 5. Bảng nguoi_dung_nha_tro
INSERT INTO nguoi_dung_nha_tro (nguoi_dung_id, nha_tro_id, vai_tro) VALUES
('22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333331', 'LANDLORD'),
('22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333332', 'LANDLORD')
ON CONFLICT DO NOTHING;

-- 6. Bảng phong
INSERT INTO phong (id, nha_tro_id, ten, khu_vuc, tang, dien_tich, gia_hien_tai, tien_coc_mac_dinh, trang_thai, so_nguoi_toi_da) VALUES
('44444444-4444-4444-4444-444444444441', '33333333-3333-3333-3333-333333333331', 'Phòng 101', 'Khu A', 1, 20.5, 3500000, 3500000, 'RENTED', 2),
('44444444-4444-4444-4444-444444444442', '33333333-3333-3333-3333-333333333331', 'Phòng 102', 'Khu A', 1, 25.0, 4000000, 4000000, 'AVAILABLE', 3),
('44444444-4444-4444-4444-444444444443', '33333333-3333-3333-3333-333333333332', 'Phòng 201', 'Tầng 2', 2, 30.0, 5000000, 5000000, 'AVAILABLE', 4)
ON CONFLICT (id) DO NOTHING;

-- 7. Bảng khach_thue
INSERT INTO khach_thue (id, nguoi_dung_id, chu_tro_id, ho_ten, so_dien_thoai, email, so_cccd, ngay_sinh, gioi_tinh, dang_hoat_dong) VALUES
('55555555-5555-5555-5555-555555555551', '22222222-2222-2222-2222-222222222223', '22222222-2222-2222-2222-222222222222', 'Nguyễn Thị Khách', '0987654321', 'khachthue1@easyhouse.com', '012345678910', '1995-05-15', 'Nữ', true),
('55555555-5555-5555-5555-555555555552', NULL, '22222222-2222-2222-2222-222222222222', 'Trần Minh C', '0922334455', NULL, '012345678912', '1998-10-20', 'Nam', false)
ON CONFLICT (id) DO NOTHING;

-- 8. Bảng hop_dong
INSERT INTO hop_dong (id, khach_thue_id, phong_id, ma_hop_dong, ngay_bat_dau, ngay_ket_thuc, gia_thue_hop_dong, tien_coc, trang_thai_coc, trang_thai, chu_ky_thanh_toan, chi_so_dien_ban_dau, chi_so_nuoc_ban_dau) VALUES
('66666666-6666-6666-6666-666666666661', '55555555-5555-5555-5555-555555555551', '44444444-4444-4444-4444-444444444441', 'HD-2024-001', '2024-01-01', '2024-12-31', 3500000, 3500000, 'KEPT', 'ACTIVE', 'MONTHLY', 100, 20),
('66666666-6666-6666-6666-666666666662', '55555555-5555-5555-5555-555555555552', '44444444-4444-4444-4444-444444444442', 'HD-2023-099', '2023-01-01', '2023-12-31', 4000000, 4000000, 'REFUNDED', 'EXPIRED', 'MONTHLY', 0, 0)
ON CONFLICT (id) DO NOTHING;

-- 9. Bảng chi_so_dien_nuoc
INSERT INTO chi_so_dien_nuoc (id, phong_id, hop_dong_id, loai, ky_nam, ky_thang, chi_so_cu, chi_so_moi) VALUES
('77777777-7777-7777-7777-777777777771', '44444444-4444-4444-4444-444444444441', '66666666-6666-6666-6666-666666666661', 'ELECTRICITY', 2024, 5, 100, 150),
('77777777-7777-7777-7777-777777777772', '44444444-4444-4444-4444-444444444441', '66666666-6666-6666-6666-666666666661', 'WATER', 2024, 5, 20, 25)
ON CONFLICT (id) DO NOTHING;

-- 10. Bảng hoa_don
INSERT INTO hoa_don (id, phong_id, hop_dong_id, khach_thue_id, ma_hoa_don, ky_nam, ky_thang, tu_ngay, den_ngay, so_du_dau_ky, tong_tien_phat_sinh, tong_tien, da_tra, han_tra, trang_thai) VALUES
('88888888-8888-8888-8888-888888888881', '44444444-4444-4444-4444-444444444441', '66666666-6666-6666-6666-666666666661', '55555555-5555-5555-5555-555555555551', 'HD-P101-052024', 2024, 5, '2024-05-01', '2024-05-31', 0, 3775000, 3775000, 3775000, '2024-06-05', 'PAID'),
('88888888-8888-8888-8888-888888888882', '44444444-4444-4444-4444-444444444441', '66666666-6666-6666-6666-666666666661', '55555555-5555-5555-5555-555555555551', 'HD-P101-062024', 2024, 6, '2024-06-01', '2024-06-30', 0, 3800000, 3800000, 1000000, '2024-07-05', 'PARTIAL')
ON CONFLICT (id) DO NOTHING;

-- 11. Bảng chi_tiet_hoa_don
INSERT INTO chi_tiet_hoa_don (id, hoa_don_id, loai, mo_ta, so_luong, don_gia, thanh_tien) VALUES
('99999999-9999-9999-9999-999999999991', '88888888-8888-8888-8888-888888888881', 'ROOM', 'Tiền thuê tháng 5', 1, 3500000, 3500000),
('99999999-9999-9999-9999-999999999992', '88888888-8888-8888-8888-888888888881', 'ELECTRICITY', 'Điện 50 kWh', 50, 3500, 175000),
('99999999-9999-9999-9999-999999999993', '88888888-8888-8888-8888-888888888881', 'WATER', 'Nước 5 khối', 5, 20000, 100000)
ON CONFLICT (id) DO NOTHING;

-- 12. Bảng thanh_toan
INSERT INTO thanh_toan (id, hoa_don_id, so_tien, phuong_thuc_thanh_toan, ma_tham_chieu, trang_thai, ghi_chu) VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '88888888-8888-8888-8888-888888888881', 3775000, 'BANK_TRANSFER', 'VCB123456', 'SUCCESS', 'Chuyển khoản thanh toán T5'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '88888888-8888-8888-8888-888888888882', 1000000, 'CASH', NULL, 'SUCCESS', 'Trả trước tiền mặt')
ON CONFLICT (id) DO NOTHING;

-- 13. Bảng su_co
INSERT INTO su_co (id, phong_id, khach_thue_id, tieu_de, mo_ta, loai_su_co, uu_tien, trang_thai, chi_phi_sua_chua) VALUES
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1', '44444444-4444-4444-4444-444444444441', '55555555-5555-5555-5555-555555555551', 'Hư bồn cầu', 'Bồn cầu dội nước không trôi', 've_sinh', 'cao', 'RESOLVED', 200000),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2', '44444444-4444-4444-4444-444444444441', '55555555-5555-5555-5555-555555555551', 'Cháy đèn tuýp', 'Đèn phòng khách bị cháy', 'dien_nuoc', 'trung_binh', 'PENDING', 0)
ON CONFLICT (id) DO NOTHING;

-- 14. Bảng thong_bao
INSERT INTO thong_bao (id, tieu_de, noi_dung, loai, kenh, gui_tat_ca) VALUES
('cccccccc-cccc-cccc-cccc-ccccccccccc1', 'Bảo trì thang máy', 'Hệ thống thang máy bảo trì lúc 9h sáng chủ nhật', 'SYSTEM', 'IN_APP', true),
('cccccccc-cccc-cccc-cccc-ccccccccccc2', 'Đóng tiền nhà T6', 'Vui lòng thanh toán hóa đơn T6 trước ngày mùng 5', 'INVOICE', 'IN_APP', false)
ON CONFLICT (id) DO NOTHING;

-- 15. Bảng thong_bao_nguoi_nhan
INSERT INTO thong_bao_nguoi_nhan (id, thong_bao_id, nguoi_nhan_id, da_doc) VALUES
('dddddddd-dddd-dddd-dddd-ddddddddddd1', 'cccccccc-cccc-cccc-cccc-ccccccccccc1', '22222222-2222-2222-2222-222222222223', true),
('dddddddd-dddd-dddd-dddd-ddddddddddd2', 'cccccccc-cccc-cccc-cccc-ccccccccccc2', '22222222-2222-2222-2222-222222222223', false)
ON CONFLICT (id) DO NOTHING;
