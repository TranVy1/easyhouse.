SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict g4d2pVDlZIS5hJYho0oOMq7tuW2REbddFaAaRCM18ZbX4fLXAbi2NCPMjBgje3a

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") VALUES
	('00000000-0000-0000-0000-000000000000', '8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139', 'authenticated', 'authenticated', 'vyt22052006@gmail.com', '$2a$10$JbDA/MW0CBQkMBsikTP5hOqOhY7xspiz5muNSLRCjCjwSNjEs19eu', '2026-05-13 16:05:05.985942+00', '2026-05-13 16:02:44.320839+00', '', NULL, '', NULL, '', '', NULL, '2026-05-13 16:05:05.992699+00', '{"provider": "email", "providers": ["email"]}', '{"email_verified": true}', NULL, '2026-05-08 16:26:02.151492+00', '2026-05-13 16:05:06.010965+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '22222222-2222-2222-2222-222222222221', 'authenticated', 'authenticated', 'admin@easyhouse.com', '$2a$10$vI8aWBnW3fID.m4/SNnbA.C9hM9p.cW7uP9GZcTfJ3dD6Q9lT.Yxa', '2026-05-23 11:52:59.723797+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"provider": "email", "providers": ["email"]}', '{}', NULL, '2026-05-23 11:52:59.723797+00', '2026-05-23 11:52:59.723797+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '22222222-2222-2222-2222-222222222222', 'authenticated', 'authenticated', 'chunha@easyhouse.com', '$2a$10$vI8aWBnW3fID.m4/SNnbA.C9hM9p.cW7uP9GZcTfJ3dD6Q9lT.Yxa', '2026-05-23 11:52:59.723797+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"provider": "email", "providers": ["email"]}', '{}', NULL, '2026-05-23 11:52:59.723797+00', '2026-05-23 11:52:59.723797+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '22222222-2222-2222-2222-222222222223', 'authenticated', 'authenticated', 'khachthue1@easyhouse.com', '$2a$10$vI8aWBnW3fID.m4/SNnbA.C9hM9p.cW7uP9GZcTfJ3dD6Q9lT.Yxa', '2026-05-23 11:52:59.723797+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"provider": "email", "providers": ["email"]}', '{}', NULL, '2026-05-23 11:52:59.723797+00', '2026-05-23 11:52:59.723797+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139', '8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139', '{"sub": "8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139", "email": "vyt22052006@gmail.com", "email_verified": true, "phone_verified": false}', 'email', '2026-05-08 16:26:02.171737+00', '2026-05-08 16:26:02.171798+00', '2026-05-08 16:26:02.171798+00', '4164f40a-ea09-4b2f-96dd-a36c05d343b3');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."sessions" ("id", "user_id", "created_at", "updated_at", "factor_id", "aal", "not_after", "refreshed_at", "user_agent", "ip", "tag", "oauth_client_id", "refresh_token_hmac_key", "refresh_token_counter", "scopes") VALUES
	('642f3c07-b80d-4ac8-8e24-57f710332e22', '8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139', '2026-05-13 16:05:05.993855+00', '2026-05-13 16:05:05.993855+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '118.68.0.62', NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") VALUES
	('642f3c07-b80d-4ac8-8e24-57f710332e22', '2026-05-13 16:05:06.011582+00', '2026-05-13 16:05:06.011582+00', 'otp', 'e6505051-df34-4ca8-8e57-78140902dad2');


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."refresh_tokens" ("instance_id", "id", "token", "user_id", "revoked", "created_at", "updated_at", "parent", "session_id") VALUES
	('00000000-0000-0000-0000-000000000000', 1, 'kssiz3i4sca3', '8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139', false, '2026-05-13 16:05:06.001401+00', '2026-05-13 16:05:06.001401+00', NULL, '642f3c07-b80d-4ac8-8e24-57f710332e22');


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: nguoi_dung; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."nguoi_dung" ("id", "email", "ho_ten", "so_dien_thoai", "anh_dai_dien", "ngay_sinh", "gioi_tinh", "dia_chi", "que_quan", "so_cccd", "trang_thai", "so_lan_dang_nhap_sai", "khoa_den_luc", "lan_dang_nhap_cuoi", "cau_hinh_2fa", "tao_luc", "cap_nhat_luc", "xoa_luc", "mat_khau") VALUES
	('00b4c56f-45fa-49a2-874b-601bc77dcb65', 'docong989@gmail.com', 'đỗ chí công', '0369963725', NULL, NULL, NULL, NULL, NULL, NULL, 'INACTIVE', 0, NULL, '2026-05-24 03:28:22.467305+00', NULL, '2026-05-23 16:22:37.909919+00', '2026-05-24 03:28:23.50645+00', NULL, '$2a$10$uMVwgtmD.HRIgVhCGS0dQ.GqmZMoz9njHqj3CaPXXACJtOXGVyFa.');


--
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: khach_thue; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."khach_thue" ("id", "nguoi_dung_id", "chu_tro_id", "ho_ten", "so_dien_thoai", "email", "so_cccd", "ngay_sinh", "gioi_tinh", "dia_chi", "que_quan", "nghe_nghiep", "ghi_chu", "dang_hoat_dong", "tao_luc", "cap_nhat_luc", "xoa_luc") VALUES
	('fba2a7bd-082f-47f7-b0cc-3c53e79352c4', NULL, '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'nguyễn văn hà', '0396822875', 'hoangphucminh231205@gmail.com', '066206004084', '2000-01-02', 'nam', NULL, 'Hà Nội', 'Sinh Viên', NULL, true, '2026-05-23 16:55:13.456136+00', '2026-05-23 16:55:13.456136+00', NULL),
	('cdbe66ce-3bf0-4023-b2c8-38ba477730f1', NULL, '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'lê văn minh', '0357165019', 'gtruc2146@gmail.com', '066206004083', '2000-12-23', 'nam', NULL, 'Bắc Giang', 'Sinh Viên', NULL, true, '2026-05-23 17:17:43.363368+00', '2026-05-23 17:18:00.723047+00', NULL);


--
-- Data for Name: nha_tro; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."nha_tro" ("id", "chu_tro_id", "ten", "dia_chi", "so_nha", "duong", "phuong", "quan", "thanh_pho", "mo_ta", "tien_nghi_chung", "noi_quy", "trang_thai", "tao_luc", "cap_nhat_luc", "xoa_luc") VALUES
	('b0eb16f8-1be0-4515-8beb-0e09768d833a', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Nhà Trọ Hải Dương', '11 Nguyễn Văn Linh', '11', 'Nguyễn Văn Linh', 'Phường Cẩm Thượng', 'Thành phố Hải Dương', 'Tỉnh Hải Dương', 'new', 'camera,giuXe,sanPhoi,khuBepChung', NULL, 'ACTIVE', '2026-05-23 16:30:20.896971+00', '2026-05-23 16:30:20.896971+00', NULL),
	('4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Nhà Trọ Trần Hưng Đạo', '139 Trần hưng đạo', '139', 'Trần hưng đạo', 'Phường Thanh Nhàn', 'Quận Hai Bà Trưng', 'Thành phố Hà Nội', 'nhà mới xây', 'wifi,baoVe,giuXe,camera,sanPhoi,khuBepChung,nhaVeSinhChung,thangMay', NULL, 'ACTIVE', '2026-05-23 16:31:10.522132+00', '2026-05-23 16:31:37.457694+00', NULL);


--
-- Data for Name: phong; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."phong" ("id", "nha_tro_id", "ten", "khu_vuc", "tang", "dien_tich", "so_nguoi_toi_da", "trang_thai", "gia_hien_tai", "tien_coc_mac_dinh", "mo_ta", "tao_luc", "cap_nhat_luc", "xoa_luc") VALUES
	('48ef0756-c05a-44fa-b4b0-d3f249f564d0', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'PHÒNG 102', '', 1, 20.00, 4, 'AVAILABLE', 3000000.00, 3000000.00, 'new', '2026-05-23 16:49:45.937334+00', '2026-05-23 18:08:12.029343+00', NULL),
	('e30e4555-7e6c-4c7b-8cdf-c8c57145c75d', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'MP001', '', 2, 20.00, 4, 'AVAILABLE', 3000000.00, 1000000.00, 'new nhé', '2026-05-23 16:32:49.14581+00', '2026-05-23 18:08:14.029706+00', NULL);


--
-- Data for Name: hop_dong; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."hop_dong" ("id", "phong_id", "khach_thue_id", "ma_hop_dong", "ngay_bat_dau", "ngay_ket_thuc", "ngay_ket_thuc_thuc_te", "gia_thue_hop_dong", "tien_coc", "trang_thai_coc", "trang_thai", "chu_ky_thanh_toan", "ngay_thanh_toan_hang_thang", "tu_dong_gia_han", "chi_so_dien_ban_dau", "chi_so_nuoc_ban_dau", "noi_dung_hop_dong", "file_pdf", "ghi_chu", "tao_luc", "cap_nhat_luc", "xoa_luc") VALUES
	('f5075e49-2b06-4750-834e-e157f7e09a82', '48ef0756-c05a-44fa-b4b0-d3f249f564d0', 'fba2a7bd-082f-47f7-b0cc-3c53e79352c4', 'HD-102-2026', '2026-01-01', '2026-12-31', NULL, 3000000.00, 3000000.00, 'KEPT', 'ACTIVE', 'MONTHLY', 5, false, 100, 50, 'Hợp đồng thuê phòng 102', NULL, NULL, '2026-05-24 03:13:31.178449+00', '2026-05-24 03:13:31.178449+00', NULL);


--
-- Data for Name: hoa_don; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."hoa_don" ("id", "ma_hoa_don", "phong_id", "khach_thue_id", "hop_dong_id", "ky_nam", "ky_thang", "tong_tien", "da_tra", "con_lai", "trang_thai", "han_thanh_toan", "ngay_lap", "ghi_chu", "hien_thi_cho_khach", "tao_luc", "cap_nhat_luc") VALUES
	('10e9f6cd-73e4-41e7-beaa-2a201f11a88b', 'HD-001', '48ef0756-c05a-44fa-b4b0-d3f249f564d0', 'fba2a7bd-082f-47f7-b0cc-3c53e79352c4', 'f5075e49-2b06-4750-834e-e157f7e09a82', 2026, 5, 3375000.00, 3375000.00, 0.00, 'PAID', '2026-05-30', '2026-05-24', 'Hóa đơn tháng 5', true, '2026-05-24 10:05:00.000000+00', '2026-05-24 10:05:00.000000+00');


--
-- Data for Name: bank_transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: dich_vu; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."dich_vu" ("id", "chu_tro_id", "ten_dich_vu", "loai_tinh_phi", "don_vi", "don_gia_mac_dinh", "bat_buoc", "tao_luc", "cap_nhat_luc") VALUES
	('d1111111-1111-1111-1111-111111111111', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Điện', 'PER_UNIT', 'kWh', 3500.00, true, '2026-05-24 03:14:22.878972+00', '2026-05-24 03:14:22.878972+00'),
	('d2222222-2222-2222-2222-222222222222', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Nước', 'PER_PERSON', 'người', 100000.00, true, '2026-05-24 03:14:22.878972+00', '2026-05-24 03:14:22.878972+00'),
	('d3333333-3333-3333-3333-333333333333', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Wifi', 'PER_ROOM', 'phòng', 100000.00, false, '2026-05-24 03:14:22.878972+00', '2026-05-24 03:14:22.878972+00'),
	('d4444444-4444-4444-4444-444444444444', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Rác', 'PER_PERSON', 'người', 30000.00, true, '2026-05-24 03:14:22.878972+00', '2026-05-24 03:14:22.878972+00'),
	('b155d348-c932-48d1-94d0-e01fe0cadd0b', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Máy lạnh', 'PER_ROOM', 'phòng', 300000.00, false, '2026-05-24 03:40:52.452403+00', '2026-05-24 03:40:52.452403+00'),
	('e3cf1e38-b185-4432-bd83-7739802d27fa', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Máy giặt', 'PER_ROOM', 'phòng', 150000.00, false, '2026-05-24 03:40:52.452403+00', '2026-05-24 03:40:52.452403+00'),
	('02b6956b-2a72-4524-9afc-d83f9e2a2e6a', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Tủ lạnh', 'PER_ROOM', 'phòng', 100000.00, false, '2026-05-24 03:40:52.452403+00', '2026-05-24 03:40:52.452403+00'),
	('f6a0428c-72c8-459f-9e91-1dda15bbfc08', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Bình nóng lạnh', 'PER_ROOM', 'phòng', 120000.00, false, '2026-05-24 03:40:52.452403+00', '2026-05-24 03:40:52.452403+00'),
	('cee87b11-9d25-48d9-8954-a9ab0bcb09b9', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Giường nệm', 'PER_ROOM', 'phòng', 200000.00, false, '2026-05-24 03:40:52.452403+00', '2026-05-24 03:40:52.452403+00'),
	('a4fd844a-f876-416b-b54c-2323ae6d251e', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Tủ quần áo', 'PER_ROOM', 'phòng', 100000.00, false, '2026-05-24 03:40:52.452403+00', '2026-05-24 03:40:52.452403+00'),
	('a2374bda-33e9-4390-aaff-e6dcbcea1e97', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Bàn ghế', 'PER_ROOM', 'phòng', 100000.00, false, '2026-05-24 03:40:52.452403+00', '2026-05-24 03:40:52.452403+00'),
	('c4f8ed3c-2fb0-47f3-ac37-6601001dec5f', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Bếp nấu ăn', 'PER_ROOM', 'phòng', 150000.00, false, '2026-05-24 03:40:52.452403+00', '2026-05-24 03:40:52.452403+00'),
	('13d910a9-7396-468f-9274-c0767cbd562a', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Kệ bếp', 'PER_ROOM', 'phòng', 50000.00, false, '2026-05-24 03:40:52.452403+00', '2026-05-24 03:40:52.452403+00'),
	('192687dd-5c6b-41f8-8c3a-bec73dfdb671', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Ban công', 'PER_ROOM', 'phòng', 200000.00, false, '2026-05-24 03:40:52.452403+00', '2026-05-24 03:40:52.452403+00'),
	('c06a40af-b003-475d-8ccf-9a74a4625be4', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Giữ xe', 'PER_PERSON', 'xe', 100000.00, false, '2026-05-24 03:40:52.452403+00', '2026-05-24 03:40:52.452403+00'),
	('c24f4134-298a-496b-9fa9-a6acfdb0e4bb', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Dọn vệ sinh', 'PER_ROOM', 'phòng', 50000.00, false, '2026-05-24 03:40:52.452403+00', '2026-05-24 03:40:52.452403+00'),
	('a0ad6557-8c87-4502-9f62-85a863557f5c', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Giặt sấy', 'PER_PERSON', 'người', 80000.00, false, '2026-05-24 03:40:52.452403+00', '2026-05-24 03:40:52.452403+00'),
	('9b741583-2afc-47bd-ab89-6424e95179cf', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Bảo trì sửa chữa', 'PER_ROOM', 'phòng', 50000.00, false, '2026-05-24 03:40:52.452403+00', '2026-05-24 03:40:52.452403+00'),
	('b3cb85f0-6ddf-4056-9b81-78a13dd33211', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Camera 24/7', 'PER_ROOM', 'phòng', 30000.00, false, '2026-05-24 03:40:52.452403+00', '2026-05-24 03:40:52.452403+00'),
	('dca7b3c9-d37f-4173-85bb-fe1e34570343', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'Vân tay thẻ từ', 'PER_ROOM', 'phòng', 50000.00, false, '2026-05-24 03:40:52.452403+00', '2026-05-24 03:40:52.452403+00');


--
-- Data for Name: cau_hinh_gia; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."cau_hinh_gia" ("id", "nha_tro_id", "dich_vu_id", "loai", "ten_hien_thi", "loai_tinh_phi", "don_gia", "hieu_luc_tu", "hieu_luc_den", "dang_ap_dung", "tao_luc", "cap_nhat_luc") VALUES
	('9ce1b8f8-3088-41eb-bf44-75cc2870b5a7', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'd1111111-1111-1111-1111-111111111111', 'ELECTRICITY', 'Tiền Điện', 'PER_UNIT', 3800.00, '2026-01-01', NULL, true, '2026-05-24 03:34:54.071595+00', '2026-05-24 03:34:54.071595+00'),
	('3abdb570-b5d4-4a86-b4c1-1705d004ea81', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'd2222222-2222-2222-2222-222222222222', 'WATER', 'Tiền Nước', 'PER_PERSON', 120000.00, '2026-01-01', NULL, true, '2026-05-24 03:34:54.071595+00', '2026-05-24 03:34:54.071595+00'),
	('830e14df-283d-4617-a02c-adc93af7cd00', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'd3333333-3333-3333-3333-333333333333', 'INTERNET', 'Tiền Wifi', 'PER_ROOM', 150000.00, '2026-01-01', NULL, true, '2026-05-24 03:34:54.071595+00', '2026-05-24 03:34:54.071595+00'),
	('65f03dfc-fccb-4c8e-a504-d4216a6cdb1c', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'd1111111-1111-1111-1111-111111111111', 'ELECTRICITY', 'Điện', 'PER_UNIT', 4000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('cd98da7a-bebf-419a-a0eb-83cf1e1ff588', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'd2222222-2222-2222-2222-222222222222', 'WATER', 'Nước', 'PER_PERSON', 120000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('0f60bb41-1c44-404a-b399-a5ed001aa049', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'd3333333-3333-3333-3333-333333333333', 'INTERNET', 'Wifi', 'PER_ROOM', 150000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('8960ab57-db83-4f1e-a66d-daf1338d81da', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'd4444444-4444-4444-4444-444444444444', 'TRASH', 'Rác', 'PER_PERSON', 30000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('16713b5c-2399-43d4-ab34-6e1e744c70cf', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'b155d348-c932-48d1-94d0-e01fe0cadd0b', 'AIR_CONDITIONER', 'Máy lạnh', 'PER_ROOM', 300000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('e27702fa-4441-4193-9724-cab6127e0d87', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'e3cf1e38-b185-4432-bd83-7739802d27fa', 'WASHING_MACHINE', 'Máy giặt', 'PER_ROOM', 150000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('ade1ba0b-6628-4480-b90b-283ca64ea2fe', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', '02b6956b-2a72-4524-9afc-d83f9e2a2e6a', 'REFRIGERATOR', 'Tủ lạnh', 'PER_ROOM', 120000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('6d31ca17-845a-4ae3-8953-9c0b6bdc50ff', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'f6a0428c-72c8-459f-9e91-1dda15bbfc08', 'WATER_HEATER', 'Bình nóng lạnh', 'PER_ROOM', 100000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('25ea9fd9-caea-43ab-ba25-5a3ce82e2412', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'cee87b11-9d25-48d9-8954-a9ab0bcb09b9', 'BED', 'Giường nệm', 'PER_ROOM', 200000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('40dc34ef-e9ef-432f-9afc-90a932e76905', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'a4fd844a-f876-416b-b54c-2323ae6d251e', 'WARDROBE', 'Tủ quần áo', 'PER_ROOM', 100000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('800ab5b5-871f-4583-b769-00b633c0ae9a', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'a2374bda-33e9-4390-aaff-e6dcbcea1e97', 'TABLE_CHAIR', 'Bàn ghế', 'PER_ROOM', 100000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('bf79f210-43a3-44cc-a96e-af9b22a5e9d5', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'c4f8ed3c-2fb0-47f3-ac37-6601001dec5f', 'KITCHEN', 'Bếp nấu ăn', 'PER_ROOM', 150000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('45ed93f2-2702-41e7-b842-7988f429b673', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', '13d910a9-7396-468f-9274-c0767cbd562a', 'KITCHEN_SHELF', 'Kệ bếp', 'PER_ROOM', 50000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('cdf7510c-d9d8-4721-9fd9-9874c9109ee7', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', '192687dd-5c6b-41f8-8c3a-bec73dfdb671', 'BALCONY', 'Ban công', 'PER_ROOM', 250000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('4394b995-a4d1-4d1c-88ce-dbd375168544', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'c06a40af-b003-475d-8ccf-9a74a4625be4', 'PARKING', 'Giữ xe', 'PER_PERSON', 120000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('5aafcd60-2418-4ab3-95ab-65c5ec2e2d78', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'c24f4134-298a-496b-9fa9-a6acfdb0e4bb', 'CLEANING', 'Dọn vệ sinh', 'PER_ROOM', 50000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('e415e434-5500-4503-8aab-43ea403dc65d', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'a0ad6557-8c87-4502-9f62-85a863557f5c', 'LAUNDRY', 'Giặt sấy', 'PER_PERSON', 80000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('492b5de7-0bd8-4542-8b56-512f82a769a8', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', '9b741583-2afc-47bd-ab89-6424e95179cf', 'MAINTENANCE', 'Bảo trì sửa chữa', 'PER_ROOM', 50000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('e7ea672d-938b-4337-828d-fad025c270fc', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'b3cb85f0-6ddf-4056-9b81-78a13dd33211', 'SECURITY_CAMERA', 'Camera 24/7', 'PER_ROOM', 30000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00'),
	('f76a7721-9558-46e2-9df4-e8da19459a70', '4a7e8a51-a55e-4d14-bc58-368ebf3d4f24', 'dca7b3c9-d37f-4173-85bb-fe1e34570343', 'SMART_LOCK', 'Vân tay thẻ từ', 'PER_ROOM', 50000.00, '2026-01-01', NULL, true, '2026-05-24 03:41:51.586681+00', '2026-05-24 03:41:51.586681+00');


--
-- Data for Name: chi_so_dien_nuoc; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."chi_so_dien_nuoc" ("id", "phong_id", "loai", "chi_so_cu", "chi_so_moi", "ngay_ghi", "ky_nam", "ky_thang", "nguoi_ghi_id", "hop_dong_id", "trang_thai", "hinh_anh", "ghi_chu", "tao_luc", "cap_nhat_luc") VALUES
	('576579fc-349f-4428-ba1e-35e67ed9d750', '48ef0756-c05a-44fa-b4b0-d3f249f564d0', 'ELECTRICITY', 100, 150, '2026-05-24', 2026, 5, '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'f5075e49-2b06-4750-834e-e157f7e09a82', 'BILLED', NULL, NULL, '2026-05-24 10:00:00.000000+00', '2026-05-24 10:00:00.000000+00'),
	('90fc6a44-a03d-4c31-97b7-6ec7e3cc00d4', '48ef0756-c05a-44fa-b4b0-d3f249f564d0', 'WATER', 50, 60, '2026-05-24', 2026, 5, '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'f5075e49-2b06-4750-834e-e157f7e09a82', 'BILLED', NULL, NULL, '2026-05-24 10:00:00.000000+00', '2026-05-24 10:00:00.000000+00');


--
-- Data for Name: su_co; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: chi_tiet_hoa_don; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."chi_tiet_hoa_don" ("id", "hoa_don_id", "dich_vu_id", "loai", "ten_hien_thi", "don_gia", "so_luong", "thanh_tien", "chi_so_dien_nuoc_id", "ghi_chu", "tao_luc") VALUES
	('6bdc2bb3-ec73-424a-950c-e22119eb4b12', '10e9f6cd-73e4-41e7-beaa-2a201f11a88b', NULL, 'ROOM', 'Tiền phòng', 3000000.00, 1.00, 3000000.00, NULL, NULL, '2026-05-24 10:05:00.000000+00'),
	('8ebdbab6-1c25-4c6e-8260-fb0b1f1a5477', '10e9f6cd-73e4-41e7-beaa-2a201f11a88b', 'd1111111-1111-1111-1111-111111111111', 'ELECTRICITY', 'Tiền điện', 3500.00, 50.00, 175000.00, '576579fc-349f-4428-ba1e-35e67ed9d750', NULL, '2026-05-24 10:05:00.000000+00'),
	('f02b37ac-1f74-4b47-beae-dc553ba5cb63', '10e9f6cd-73e4-41e7-beaa-2a201f11a88b', 'd2222222-2222-2222-2222-222222222222', 'WATER', 'Tiền nước', 100000.00, 2.00, 200000.00, '90fc6a44-a03d-4c31-97b7-6ec7e3cc00d4', NULL, '2026-05-24 10:05:00.000000+00');


--
-- Data for Name: chu_tro; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."chu_tro" ("id", "nguoi_dung_id", "ten_cong_ty", "so_cccd", "ma_so_thue", "so_tai_khoan", "da_xac_minh", "tao_luc", "cap_nhat_luc", "xoa_luc") VALUES
	('7a8efd24-8c91-4368-b942-e1c10e5aa182', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'CTY TNHH ', '066206004084', '00000000', '0369963725', true, '2026-05-23 17:51:44+00', '2026-05-23 17:51:46.995376+00', NULL);


--
-- Data for Name: dat_coc_phong; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: dich_vu_hop_dong; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."dich_vu_hop_dong" ("id", "hop_dong_id", "dich_vu_id", "loai_tinh_phi", "don_gia_ap_dung", "so_luong", "bat_dau_tu", "ket_thuc_luc", "tao_luc") VALUES
	('150e511d-50c0-417b-a7b0-b1bb72cebb78', 'f5075e49-2b06-4750-834e-e157f7e09a82', 'd1111111-1111-1111-1111-111111111111', 'PER_UNIT', 3500.00, 1.00, '2026-01-01', NULL, '2026-05-24 03:15:34.210606+00'),
	('3d4933f8-9cf7-42d7-bf5f-e7d32310297c', 'f5075e49-2b06-4750-834e-e157f7e09a82', 'd2222222-2222-2222-2222-222222222222', 'PER_PERSON', 100000.00, 2.00, '2026-01-01', NULL, '2026-05-24 03:15:34.210606+00'),
	('482e3185-95ac-4112-b695-7cf8447a547a', 'f5075e49-2b06-4750-834e-e157f7e09a82', 'd3333333-3333-3333-3333-333333333333', 'PER_ROOM', 100000.00, 1.00, '2026-01-01', NULL, '2026-05-24 03:15:34.210606+00'),
	('babfa5f5-1e03-45e2-af62-94d807b9b971', 'f5075e49-2b06-4750-834e-e157f7e09a82', 'd4444444-4444-4444-4444-444444444444', 'PER_PERSON', 30000.00, 2.00, '2026-01-01', NULL, '2026-05-24 03:15:34.210606+00');


--
-- Data for Name: email_verification_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."email_verification_token" ("id", "nguoi_dung_id", "token", "ngay_het_han", "tao_luc") VALUES
	('9e3cc369-c7bc-4504-98e0-25e204aaddb1', '00b4c56f-45fa-49a2-874b-601bc77dcb65', '53d14152-7792-40e6-a64b-31185e65e9a2', '2026-05-24 16:22:38.107621+00', '2026-05-23 16:22:38.109125+00');


--
-- Data for Name: file_media; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."file_media" ("id", "doi_tuong", "doi_tuong_id", "url", "public_id", "loai_file", "kich_thuoc_bytes", "metadata", "nguoi_tai_len_id", "tao_luc") VALUES
	('4213e02d-6b7d-45ce-a710-b06e7853d648', 'ROOM', 'e30e4555-7e6c-4c7b-8cdf-c8c57145c75d', 'https://res.cloudinary.com/dlkh28yfs/image/upload/v1779554500/quanlyphongtro/wemzccfpqubdws70pl0m.jpg', NULL, 'ROOM_IMAGE', NULL, NULL, NULL, '2026-05-23 16:41:45.542929+00'),
	('4fdb4c58-e265-4840-bfef-471baa1398c1', 'TENANT', 'cdbe66ce-3bf0-4023-b2c8-38ba477730f1', 'https://res.cloudinary.com/dlkh28yfs/image/upload/v1779556660/quanlyphongtro/heiky0grafj2zq1u0yzc.webp', NULL, 'CCCD_FRONT', NULL, NULL, NULL, '2026-05-23 17:18:00.063393+00'),
	('7951052b-31ac-42e6-9a05-9794c4e578fe', 'TENANT', 'cdbe66ce-3bf0-4023-b2c8-38ba477730f1', 'https://res.cloudinary.com/dlkh28yfs/image/upload/v1779556662/quanlyphongtro/c2jpkwgqf6pfkqpzh2sd.webp', NULL, 'CCCD_BACK', NULL, NULL, NULL, '2026-05-23 17:18:00.50978+00'),
	('03fd824a-e5c7-4169-9dce-2b27a422ea3a', 'ROOM', '48ef0756-c05a-44fa-b4b0-d3f249f564d0', 'https://res.cloudinary.com/dlkh28yfs/image/upload/v1779554980/quanlyphongtro/ehyqt9r4qbcvfqdsrjjp.jpg', NULL, 'ROOM_IMAGE', NULL, NULL, NULL, '2026-05-23 18:10:12.776312+00'),
	('d9fd9c36-fff7-46f8-9126-ac4b2a1985cb', 'ROOM', '48ef0756-c05a-44fa-b4b0-d3f249f564d0', 'https://res.cloudinary.com/dlkh28yfs/image/upload/v1779554981/quanlyphongtro/fmvcmtahnqudjnnrgsfn.jpg', NULL, 'ROOM_IMAGE', NULL, NULL, NULL, '2026-05-23 18:10:12.777314+00'),
	('3eb5af57-53fb-4846-8978-fa642f6192c9', 'ROOM', '48ef0756-c05a-44fa-b4b0-d3f249f564d0', 'https://res.cloudinary.com/dlkh28yfs/image/upload/v1779554980/quanlyphongtro/vfvmlq7dcvnlnlpcmyly.jpg', NULL, 'ROOM_IMAGE', NULL, NULL, NULL, '2026-05-23 18:10:12.777314+00'),
	('d2708e7b-8bba-46a7-bfee-f73de5cb8953', 'ROOM', '48ef0756-c05a-44fa-b4b0-d3f249f564d0', 'https://res.cloudinary.com/dlkh28yfs/image/upload/v1779554979/quanlyphongtro/jnoorbzlqpqj2rmjeqiy.jpg', NULL, 'ROOM_IMAGE', NULL, NULL, NULL, '2026-05-23 18:10:12.777314+00'),
	('77edbbe6-e2c1-497b-909f-8c0e7c7a58ed', 'ROOM', '48ef0756-c05a-44fa-b4b0-d3f249f564d0', 'https://res.cloudinary.com/dlkh28yfs/image/upload/v1779554979/quanlyphongtro/uh2o7xfn97xhqyr3ayvk.jpg', NULL, 'ROOM_IMAGE', NULL, NULL, NULL, '2026-05-23 18:10:12.777314+00'),
	('5bafdea5-02f0-4f6b-a728-95e3aa8f7446', 'ROOM', '48ef0756-c05a-44fa-b4b0-d3f249f564d0', 'https://res.cloudinary.com/dlkh28yfs/image/upload/v1779554979/quanlyphongtro/nsu1lvdcza6jkg1nyywz.jpg', NULL, 'ROOM_IMAGE', NULL, NULL, NULL, '2026-05-23 18:10:12.779315+00');


--
-- Data for Name: lich_hen; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: lich_su_hoa_don; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: login_history; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: nguoi_dung_nha_tro; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: vai_tro; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."vai_tro" ("id", "ten", "mo_ta", "tao_luc") VALUES
	('ad11a13c-b380-47f4-8d8f-8f13013c84e9', 'ADMIN', 'ADMIN', '2026-05-23 16:55:50+00'),
	('3692907a-7089-42e0-bb9d-42745a6b6e8a', 'TENANT', 'Người Dùng', '2026-05-23 16:56:08+00');


--
-- Data for Name: nguoi_dung_vai_tro; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: tien_ich; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."tien_ich" ("id", "ten", "bieu_tuong", "tao_luc") VALUES
	('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8', 'tivi', NULL, '2026-05-23 17:03:45.635831+00'),
	('141e6311-d00c-4380-9c83-c91514025d2b', 'wifi', NULL, '2026-05-23 16:41:44.476966+00'),
	('04d13a37-04ee-49d6-a915-b4a768026b8b', 'Tủ Lạnh', NULL, '2026-05-23 16:41:44.476966+00'),
	('1ce428dd-3a53-4a9e-bb09-49ea93c22be1', 'Nóng Lạnh', NULL, '2026-05-23 16:49:46.489765+00'),
	('4d09f674-c43a-4515-b267-1a34d786fe03', 'Bàn Làm Việc', NULL, '2026-05-23 16:41:44.476966+00'),
	('886d78a4-4787-4e6b-9097-ec705872b255', 'Tủ Quần Áo', NULL, '2026-05-23 16:49:46.489765+00'),
	('891a47ab-7249-4ad1-b77e-1fe4752bdfdd', 'Nồi', NULL, '2026-05-23 16:50:38.016306+00'),
	('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee10', 'Máy Giặt', NULL, '2026-05-23 17:03:45.635831+00'),
	('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11', 'Bếp', NULL, '2026-05-23 17:03:45.635831+00'),
	('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee13', 'Chén', NULL, '2026-05-23 17:03:45.635831+00'),
	('eeeeeeee-eeee-eeee-eeee-eeeeeeeeee14', 'Bát', NULL, '2026-05-23 17:03:45.635831+00'),
	('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee1', 'Điều Hòa', NULL, '2026-05-23 17:03:45.635831+00'),
	('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4', 'Giường', NULL, '2026-05-23 17:03:45.635831+00'),
	('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7', 'Ghế', NULL, '2026-05-23 17:03:45.635831+00');


--
-- Data for Name: phong_tien_ich; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."phong_tien_ich" ("phong_id", "tien_ich_id", "tao_luc") VALUES
	('e30e4555-7e6c-4c7b-8cdf-c8c57145c75d', '04d13a37-04ee-49d6-a915-b4a768026b8b', '2026-05-23 16:41:45.892652+00'),
	('e30e4555-7e6c-4c7b-8cdf-c8c57145c75d', '4d09f674-c43a-4515-b267-1a34d786fe03', '2026-05-23 16:41:45.892652+00'),
	('e30e4555-7e6c-4c7b-8cdf-c8c57145c75d', '141e6311-d00c-4380-9c83-c91514025d2b', '2026-05-23 16:41:45.892652+00'),
	('48ef0756-c05a-44fa-b4b0-d3f249f564d0', '4d09f674-c43a-4515-b267-1a34d786fe03', '2026-05-23 18:10:13.447652+00'),
	('48ef0756-c05a-44fa-b4b0-d3f249f564d0', '891a47ab-7249-4ad1-b77e-1fe4752bdfdd', '2026-05-23 18:10:13.447652+00'),
	('48ef0756-c05a-44fa-b4b0-d3f249f564d0', '1ce428dd-3a53-4a9e-bb09-49ea93c22be1', '2026-05-23 18:10:13.447652+00'),
	('48ef0756-c05a-44fa-b4b0-d3f249f564d0', '04d13a37-04ee-49d6-a915-b4a768026b8b', '2026-05-23 18:10:13.447652+00'),
	('48ef0756-c05a-44fa-b4b0-d3f249f564d0', '886d78a4-4787-4e6b-9097-ec705872b255', '2026-05-23 18:10:13.447652+00'),
	('48ef0756-c05a-44fa-b4b0-d3f249f564d0', '141e6311-d00c-4380-9c83-c91514025d2b', '2026-05-23 18:10:13.447652+00');


--
-- Data for Name: phu_luc_hop_dong; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: refresh_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."refresh_token" ("id", "nguoi_dung_id", "token", "ngay_het_han", "tao_luc") VALUES
	('1769b60d-b53c-42ef-8f4d-fd97c612f460', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJkYTNjNjZjNS01NTI4LTQ4YTEtYjRhNi02Njc3YTk3MGZmZGEiLCJpYXQiOjE3Nzk1NTMzODAsImV4cCI6MTc4MjE0NTM4MH0.QbNoh__ti_zKb-QS-w6dq8K-l909WR4aV1AmWf0RQ8gg3Mk6DDo4V-zXl5sfVTi2', '2026-06-22 16:23:00.573+00', '2026-05-23 16:23:00.574005+00'),
	('c7c571af-5156-4f00-8793-6786ed563b7e', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI3ZmU2ZWUxOS02M2NmLTQwNTQtOWZhOS04NzhkZjViNzc2OWQiLCJpYXQiOjE3Nzk1NTM0ODQsImV4cCI6MTc4MjE0NTQ4NH0.xBOHdJ6i2QtarFXJ-tcpFIWCwsXZYjOpSHSLaLgqiYG6uZydXKWpj2yejd-qOZJI', '2026-06-22 16:24:44.858+00', '2026-05-23 16:24:44.858988+00'),
	('800b1b72-2ab9-41ba-a4c3-8be9b8e49071', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI4MzMyODUwNy02ZjUyLTQxZDctOTM5Yy00MWI3NTVjYjg5ZjkiLCJpYXQiOjE3Nzk1NTM3OTQsImV4cCI6MTc4MjE0NTc5NH0.2-XRg7L7q3ekssC6bHPTT3X5JSMbjgtvjjCMkcHNUkjmb-atKUQj4gTqEf-GUZ9y', '2026-06-22 16:29:54.186+00', '2026-05-23 16:29:54.18855+00'),
	('fe34789a-ef43-4f7c-9976-f0823fc606a1', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJkZjU3OTUwMC0xOTA4LTQzODgtYWY2My04MDNiMDZmMmM2NWUiLCJpYXQiOjE3Nzk1NTQ0ODIsImV4cCI6MTc4MjE0NjQ4Mn0.8oodnEyY6pDe01gwtp4kQValYA0DleKAfrOyEkSfL9tj7np9eJUIu6AV9SDhlyFV', '2026-06-22 16:41:22.178+00', '2026-05-23 16:41:22.178673+00'),
	('2d306a91-37b9-4192-998c-7734496025a2', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJjYTdlNTA2MC1hNTZlLTQzZjQtOGRjMy00ZDhlZTE2NTc5NjQiLCJpYXQiOjE3Nzk1NTYyMDEsImV4cCI6MTc4MjE0ODIwMX0.vZMoS067CGM81OLGyVqhWC6Kkf7LxF4Ru-OBGUbwb1k-D3jptdcRVNvVT7otIgfp', '2026-06-22 17:10:01.247+00', '2026-05-23 17:10:01.250194+00'),
	('f621361f-e254-418f-b752-14ac0991d07c', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiIyMDYwY2U2Ny05ZmI3LTQ0ZDMtOTkyZi0wNDExYzg3MTQ5YzQiLCJpYXQiOjE3Nzk1NTc1NzcsImV4cCI6MTc4MjE0OTU3N30.fGsSkX1u1L2govIvQ07XFNaM9_r7RS4Nz7EL9Z1n96sWfbLGjXgAcMJ4oUcTcCvv', '2026-06-22 17:32:57.583+00', '2026-05-23 17:32:57.584327+00'),
	('00b5af30-3c01-4b1e-be4d-b526558b67bf', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiIxOTNiOTkwOC1hZjMzLTQ5M2QtOGU1YS1kNjE5NzVkODY2ODMiLCJpYXQiOjE3Nzk1NTc2ODYsImV4cCI6MTc4MjE0OTY4Nn0.vm3YIRgodvONaK_ezZrGbzsdKomZYT2Mz9swYQzUZgxzVMpDcfZg_tY8UdpUcuNa', '2026-06-22 17:34:46.502+00', '2026-05-23 17:34:46.504163+00'),
	('05cfeca5-eae6-497c-bd5b-45ff2978704e', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJhYzI3ZWUzYS01NGI5LTQwMDAtOWJkNC0wODQyYjE0OGU1NmUiLCJpYXQiOjE3Nzk1NTgwMjAsImV4cCI6MTc4MjE1MDAyMH0.sLn5ndYMsLINGwEmlcsY1ze9DMhmfhqNjedZCk1W5UeCiP3i2OfEEfOIfsAA8zaG', '2026-06-22 17:40:20.423+00', '2026-05-23 17:40:20.425228+00'),
	('da710484-595f-4657-bddd-bbffdb2ded00', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI5YmM5NTg1MS1iYzhiLTQzOGMtYjBjZi1iYzg1NDRmMDAwMjMiLCJpYXQiOjE3Nzk1OTA4NTUsImV4cCI6MTc4MjE4Mjg1NX0.6vy6KZSIn_jK7DYNSNhCF69oEvW9BPv_kZKA5_lQebpaTPE3QYSLz8wRIxLkHrAI', '2026-06-23 02:47:35.866+00', '2026-05-24 02:47:35.869234+00'),
	('75e1e980-78a4-448c-83ba-0a6ee89000fb', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJmMjliNGYzMi00OTI1LTRjODktOWU1OS1iM2Y3MzZjM2JkMjMiLCJpYXQiOjE3Nzk1OTA4NzUsImV4cCI6MTc4MjE4Mjg3NX0.GsGS6L7LKDIj0X7-bhOtUQwTBpEgqnni5B9hZky9HOB7vvw6waq4iwUe1STO842N', '2026-06-23 02:47:55.563+00', '2026-05-24 02:47:55.563889+00'),
	('a0b8fde0-8b3d-4920-ad44-057642c8ae77', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJiNzEyMjZhMS0zYWNlLTRlY2UtOTdmOS1iYTZjMDljYWQxNTUiLCJpYXQiOjE3Nzk1OTE3NzEsImV4cCI6MTc4MjE4Mzc3MX0.IPluQ789nPmYaQdnu49XO_oA7e9_G10swRtPTqN-V-5lGye0KPQAsGz9dW-jhzfE', '2026-06-23 03:02:51.627+00', '2026-05-24 03:02:51.63065+00'),
	('5d36dbf7-3dc1-4e4a-a992-9dafd01adf64', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 'eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJjMDlhNjdmOS1iOWY1LTQzMWUtYTk4NC1kOTMzNjFlNjhmOGEiLCJpYXQiOjE3Nzk1OTMzMDIsImV4cCI6MTc4MjE4NTMwMn0.q3anFR974ubkMX8_I6cDmxwXxMM-0llJ2fFWxXwZLtp2GokSe8x5AGbtt3b6gzlx', '2026-06-23 03:28:22.63+00', '2026-05-24 03:28:22.63261+00');


--
-- Data for Name: thanh_toan; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."thanh_toan" ("id", "hoa_don_id", "khach_thue_id", "nguoi_ghi_nhan_id", "so_tien", "phuong_thuc", "ma_giao_dich", "anh_bien_lai", "ngay_thanh_toan", "trang_thai", "external_transaction_id", "ghi_chu", "tao_luc", "cap_nhat_luc") VALUES
	('41e8c74a-4e89-4b6f-bc3a-9e120d9128f6', '10e9f6cd-73e4-41e7-beaa-2a201f11a88b', 'fba2a7bd-082f-47f7-b0cc-3c53e79352c4', '00b4c56f-45fa-49a2-874b-601bc77dcb65', 3375000.00, 'CASH', 'GD-001', NULL, '2026-05-25', 'COMPLETED', NULL, 'Thanh toán tiền mặt', '2026-05-25 10:00:00.000000+00', '2026-05-25 10:00:00.000000+00');


--
-- Data for Name: thanh_vien_hop_dong; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."thanh_vien_hop_dong" ("id", "hop_dong_id", "khach_thue_id", "ho_ten", "so_cccd", "so_dien_thoai", "ngay_vao", "ngay_roi", "dang_o", "la_nguoi_dai_dien", "ghi_chu", "tao_luc", "cap_nhat_luc") VALUES
	('847bbfad-e7a9-457f-8ce8-16a23aca9cc4', 'f5075e49-2b06-4750-834e-e157f7e09a82', 'fba2a7bd-082f-47f7-b0cc-3c53e79352c4', 'nguyễn văn hà', '066206004084', '0396822875', '2026-01-01', NULL, true, true, NULL, '2026-05-24 03:16:26.256991+00', '2026-05-24 03:16:26.256991+00'),
	('6ee66783-955b-4950-86d5-d00ccb86035b', 'f5075e49-2b06-4750-834e-e157f7e09a82', NULL, 'Nguyễn Thị B', '066206004085', '0987654321', '2026-01-01', NULL, true, false, NULL, '2026-05-24 03:16:26.256991+00', '2026-05-24 03:16:26.256991+00');


--
-- Data for Name: thong_bao; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: thong_bao_nguoi_nhan; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 1, true);


--
-- PostgreSQL database dump complete
--

-- \unrestrict g4d2pVDlZIS5hJYho0oOMq7tuW2REbddFaAaRCM18ZbX4fLXAbi2NCPMjBgje3a

RESET ALL;
