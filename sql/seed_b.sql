
-- ============================================================================
-- 8. LANDLORD B DATA (FOR PERMISSION TESTING)
-- ============================================================================
INSERT INTO public.nguoi_dung (
    id, email, ho_ten, so_dien_thoai, trang_thai
) VALUES
    ('22222222-2222-2222-2222-222222222225', 'landlord2@easyhouse.local', 'Tran Van Chu B', '0900000005', 'ACTIVE')
ON CONFLICT (id) DO UPDATE SET
    email = EXCLUDED.email, ho_ten = EXCLUDED.ho_ten;

INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES
    ('22222222-2222-2222-2222-222222222225', '11111111-1111-1111-1111-111111111112')
ON CONFLICT DO NOTHING;

INSERT INTO public.nha_tro (
    id, chu_tro_id, ten, dia_chi, so_nha, duong, phuong, quan, thanh_pho, trang_thai
) VALUES
    ('33333333-3333-3333-3333-333333333332', '22222222-2222-2222-2222-222222222225', 'Nha tro EasyHouse Quan 3', '456 Vo Van Tan, Phuong 5, Quan 3, TP HCM', '456', 'Vo Van Tan', 'Phuong 5', 'Quan 3', 'TP HCM', 'ACTIVE')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.nguoi_dung_nha_tro (
    nguoi_dung_id, nha_tro_id, vai_tro, co_quyen_xem, co_quyen_sua, co_quyen_thu_tien
) VALUES
    ('22222222-2222-2222-2222-222222222225', '33333333-3333-3333-3333-333333333332', 'LANDLORD', true, true, true)
ON CONFLICT DO NOTHING;

INSERT INTO public.phong (
    id, nha_tro_id, ten, khu_vuc, tang, dien_tich, so_nguoi_toi_da, trang_thai, gia_hien_tai, tien_coc_mac_dinh
) VALUES
    ('44444444-4444-4444-4444-444444444444', '33333333-3333-3333-3333-333333333332', 'P301', 'Khu B', 1, 20.00, 2, 'RENTED', 3000000, 3000000)
ON CONFLICT DO NOTHING;

INSERT INTO public.khach_thue (
    id, chu_tro_id, ho_ten, so_dien_thoai, so_cccd, dang_hoat_dong
) VALUES
    ('77777777-7777-7777-7777-777777777703', '22222222-2222-2222-2222-222222222225', 'Khach Thue B', '0900000006', '079199900003', true)
ON CONFLICT DO NOTHING;

INSERT INTO public.hop_dong (
    id, phong_id, khach_thue_id, ma_hop_dong, ngay_bat_dau, ngay_ket_thuc, gia_thue_hop_dong, tien_coc, trang_thai_coc, trang_thai, chu_ky_thanh_toan, ngay_thanh_toan_hang_thang, tu_dong_gia_han
) VALUES
    ('88888888-8888-8888-8888-888888888802', '44444444-4444-4444-4444-444444444444', '77777777-7777-7777-7777-777777777703', 'HD-2026-0002', '2026-05-01', '2027-04-30', 3000000, 3000000, 'KEPT', 'ACTIVE', 'MONTHLY', 5, true)
ON CONFLICT DO NOTHING;

INSERT INTO public.hoa_don (
    id, hop_dong_id, phong_id, khach_thue_id, ma_hoa_don, ky_nam, ky_thang, tu_ngay, den_ngay, so_du_dau_ky, tong_tien_phat_sinh, tong_tien, da_tra, trang_thai, han_tra
) VALUES
    ('cccccccc-cccc-cccc-cccc-cccccccccc02', '88888888-8888-8888-8888-888888888802', '44444444-4444-4444-4444-444444444444', '77777777-7777-7777-7777-777777777703', 'INV-2026-05-P301', 2026, 5, '2026-05-01', '2026-05-31', 0, 3000000, 3000000, 0, 'UNPAID', '2026-06-05')
ON CONFLICT DO NOTHING;

INSERT INTO public.chi_tiet_hoa_don (
    id, hoa_don_id, loai, mo_ta, so_luong, don_gia, thanh_tien
) VALUES
    ('dddddddd-dddd-dddd-dddd-dddddddddd07', 'cccccccc-cccc-cccc-cccc-cccccccccc02', 'ROOM', 'Tien thue phong P301', 1, 3000000, 3000000)
ON CONFLICT DO NOTHING;
