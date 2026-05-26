--
-- PostgreSQL database dump
--

\restrict zN1OJwmaEjc1FoQuAwn6n5Hzhs8MQwQwNwQIdcmgfz3gAc6jCzXDnQzgasxNzpI

-- Dumped from database version 16.14
-- Dumped by pg_dump version 16.14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP POLICY IF EXISTS vai_tro_read_authenticated ON public.vai_tro;
DROP POLICY IF EXISTS tien_ich_read_authenticated ON public.tien_ich;
DROP POLICY IF EXISTS tien_ich_admin_write ON public.tien_ich;
DROP POLICY IF EXISTS thong_bao_sender_or_recipient ON public.thong_bao;
DROP POLICY IF EXISTS thong_bao_recipient_update_self ON public.thong_bao_nguoi_nhan;
DROP POLICY IF EXISTS thong_bao_recipient_read ON public.thong_bao_nguoi_nhan;
DROP POLICY IF EXISTS thong_bao_recipient_insert_sender ON public.thong_bao_nguoi_nhan;
DROP POLICY IF EXISTS thong_bao_insert_authenticated ON public.thong_bao;
DROP POLICY IF EXISTS thanh_vien_hop_dong_by_contract ON public.thanh_vien_hop_dong;
DROP POLICY IF EXISTS thanh_toan_by_invoice ON public.thanh_toan;
DROP POLICY IF EXISTS su_co_by_room_or_reporter ON public.su_co;
DROP POLICY IF EXISTS phu_luc_hop_dong_by_contract ON public.phu_luc_hop_dong;
DROP POLICY IF EXISTS phong_tien_ich_by_room ON public.phong_tien_ich;
DROP POLICY IF EXISTS phong_by_nha_tro ON public.phong;
DROP POLICY IF EXISTS nha_tro_owner_staff ON public.nha_tro;
DROP POLICY IF EXISTS nguoi_dung_vai_tro_self_or_admin_read ON public.nguoi_dung_vai_tro;
DROP POLICY IF EXISTS nguoi_dung_vai_tro_admin_write ON public.nguoi_dung_vai_tro;
DROP POLICY IF EXISTS nguoi_dung_self_or_admin ON public.nguoi_dung;
DROP POLICY IF EXISTS nguoi_dung_nha_tro_owner_admin ON public.nguoi_dung_nha_tro;
DROP POLICY IF EXISTS login_history_self_or_admin ON public.login_history;
DROP POLICY IF EXISTS lich_su_hoa_don_by_invoice ON public.lich_su_hoa_don;
DROP POLICY IF EXISTS lich_hen_by_room_or_user ON public.lich_hen;
DROP POLICY IF EXISTS khach_thue_owner_or_self ON public.khach_thue;
DROP POLICY IF EXISTS hop_dong_by_room_or_tenant ON public.hop_dong;
DROP POLICY IF EXISTS hoa_don_by_room_or_tenant ON public.hoa_don;
DROP POLICY IF EXISTS file_media_uploader_admin ON public.file_media;
DROP POLICY IF EXISTS dich_vu_owner ON public.dich_vu;
DROP POLICY IF EXISTS dich_vu_hop_dong_by_contract ON public.dich_vu_hop_dong;
DROP POLICY IF EXISTS dat_coc_by_room ON public.dat_coc_phong;
DROP POLICY IF EXISTS chi_tiet_hoa_don_by_invoice ON public.chi_tiet_hoa_don;
DROP POLICY IF EXISTS chi_so_by_room ON public.chi_so_dien_nuoc;
DROP POLICY IF EXISTS cau_hinh_gia_by_nha_tro ON public.cau_hinh_gia;
DROP POLICY IF EXISTS bank_transaction_by_nha_tro ON public.bank_transaction;
DROP POLICY IF EXISTS audit_log_admin_read ON public.audit_log;
ALTER TABLE IF EXISTS ONLY public.thong_bao_nguoi_nhan DROP CONSTRAINT IF EXISTS thong_bao_nguoi_nhan_thong_bao_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thong_bao_nguoi_nhan DROP CONSTRAINT IF EXISTS thong_bao_nguoi_nhan_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thong_bao DROP CONSTRAINT IF EXISTS thong_bao_nguoi_gui_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_vien_hop_dong DROP CONSTRAINT IF EXISTS thanh_vien_hop_dong_khach_thue_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_vien_hop_dong DROP CONSTRAINT IF EXISTS thanh_vien_hop_dong_hop_dong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_toan DROP CONSTRAINT IF EXISTS thanh_toan_nguoi_thanh_toan_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_toan DROP CONSTRAINT IF EXISTS thanh_toan_nguoi_ghi_nhan_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_toan DROP CONSTRAINT IF EXISTS thanh_toan_khach_thue_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_toan DROP CONSTRAINT IF EXISTS thanh_toan_hoa_don_id_fkey;
ALTER TABLE IF EXISTS ONLY public.su_co DROP CONSTRAINT IF EXISTS su_co_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.su_co DROP CONSTRAINT IF EXISTS su_co_nguoi_phu_trach_id_fkey;
ALTER TABLE IF EXISTS ONLY public.su_co DROP CONSTRAINT IF EXISTS su_co_nguoi_bao_id_fkey;
ALTER TABLE IF EXISTS ONLY public.su_co DROP CONSTRAINT IF EXISTS su_co_khach_thue_id_fkey;
ALTER TABLE IF EXISTS ONLY public.refresh_token DROP CONSTRAINT IF EXISTS refresh_token_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phu_luc_hop_dong DROP CONSTRAINT IF EXISTS phu_luc_hop_dong_nguoi_tao_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phu_luc_hop_dong DROP CONSTRAINT IF EXISTS phu_luc_hop_dong_hop_dong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phong_tien_ich DROP CONSTRAINT IF EXISTS phong_tien_ich_tien_ich_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phong_tien_ich DROP CONSTRAINT IF EXISTS phong_tien_ich_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phong DROP CONSTRAINT IF EXISTS phong_nha_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nha_tro DROP CONSTRAINT IF EXISTS nha_tro_chu_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung_vai_tro DROP CONSTRAINT IF EXISTS nguoi_dung_vai_tro_vai_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung_vai_tro DROP CONSTRAINT IF EXISTS nguoi_dung_vai_tro_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung_nha_tro DROP CONSTRAINT IF EXISTS nguoi_dung_nha_tro_nha_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung_nha_tro DROP CONSTRAINT IF EXISTS nguoi_dung_nha_tro_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung DROP CONSTRAINT IF EXISTS nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.login_history DROP CONSTRAINT IF EXISTS login_history_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lich_su_hoa_don DROP CONSTRAINT IF EXISTS lich_su_hoa_don_nguoi_thay_doi_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lich_su_hoa_don DROP CONSTRAINT IF EXISTS lich_su_hoa_don_hoa_don_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lich_hen DROP CONSTRAINT IF EXISTS lich_hen_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lich_hen DROP CONSTRAINT IF EXISTS lich_hen_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.khach_thue DROP CONSTRAINT IF EXISTS khach_thue_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.khach_thue DROP CONSTRAINT IF EXISTS khach_thue_chu_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hop_dong DROP CONSTRAINT IF EXISTS hop_dong_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hop_dong DROP CONSTRAINT IF EXISTS hop_dong_khach_thue_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hoa_don DROP CONSTRAINT IF EXISTS hoa_don_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hoa_don DROP CONSTRAINT IF EXISTS hoa_don_khach_thue_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hoa_don DROP CONSTRAINT IF EXISTS hoa_don_hop_dong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chi_tiet_hoa_don DROP CONSTRAINT IF EXISTS fk_cthd_su_co;
ALTER TABLE IF EXISTS ONLY public.file_media DROP CONSTRAINT IF EXISTS file_media_nguoi_tai_len_id_fkey;
ALTER TABLE IF EXISTS ONLY public.dich_vu_hop_dong DROP CONSTRAINT IF EXISTS dich_vu_hop_dong_hop_dong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.dich_vu_hop_dong DROP CONSTRAINT IF EXISTS dich_vu_hop_dong_dich_vu_id_fkey;
ALTER TABLE IF EXISTS ONLY public.dich_vu DROP CONSTRAINT IF EXISTS dich_vu_chu_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.dat_coc_phong DROP CONSTRAINT IF EXISTS dat_coc_phong_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.dat_coc_phong DROP CONSTRAINT IF EXISTS dat_coc_phong_khach_thue_id_fkey;
ALTER TABLE IF EXISTS ONLY public.dat_coc_phong DROP CONSTRAINT IF EXISTS dat_coc_phong_hop_dong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chi_tiet_hoa_don DROP CONSTRAINT IF EXISTS chi_tiet_hoa_don_hoa_don_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chi_tiet_hoa_don DROP CONSTRAINT IF EXISTS chi_tiet_hoa_don_dich_vu_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chi_tiet_hoa_don DROP CONSTRAINT IF EXISTS chi_tiet_hoa_don_chi_so_dien_nuoc_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chi_so_dien_nuoc DROP CONSTRAINT IF EXISTS chi_so_dien_nuoc_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chi_so_dien_nuoc DROP CONSTRAINT IF EXISTS chi_so_dien_nuoc_nguoi_ghi_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chi_so_dien_nuoc DROP CONSTRAINT IF EXISTS chi_so_dien_nuoc_hop_dong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.cau_hinh_gia DROP CONSTRAINT IF EXISTS cau_hinh_gia_nha_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.cau_hinh_gia DROP CONSTRAINT IF EXISTS cau_hinh_gia_dich_vu_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bank_transaction DROP CONSTRAINT IF EXISTS bank_transaction_nha_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bank_transaction DROP CONSTRAINT IF EXISTS bank_transaction_hoa_don_id_fkey;
ALTER TABLE IF EXISTS ONLY public.audit_log DROP CONSTRAINT IF EXISTS audit_log_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.webauthn_credentials DROP CONSTRAINT IF EXISTS webauthn_credentials_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.webauthn_challenges DROP CONSTRAINT IF EXISTS webauthn_challenges_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.sso_domains DROP CONSTRAINT IF EXISTS sso_domains_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_oauth_client_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_flow_state_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_sso_provider_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_session_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.one_time_tokens DROP CONSTRAINT IF EXISTS one_time_tokens_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_client_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_client_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_user_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_challenges DROP CONSTRAINT IF EXISTS mfa_challenges_auth_factor_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS mfa_amr_claims_session_id_fkey;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_user_id_fkey;
DROP TRIGGER IF EXISTS trg_thong_bao_cap_nhat ON public.thong_bao;
DROP TRIGGER IF EXISTS trg_thanh_vien_cap_nhat ON public.thanh_vien_hop_dong;
DROP TRIGGER IF EXISTS trg_thanh_toan_recalc ON public.thanh_toan;
DROP TRIGGER IF EXISTS trg_su_co_cap_nhat ON public.su_co;
DROP TRIGGER IF EXISTS trg_phong_cap_nhat ON public.phong;
DROP TRIGGER IF EXISTS trg_nha_tro_cap_nhat ON public.nha_tro;
DROP TRIGGER IF EXISTS trg_nguoi_dung_cap_nhat ON public.nguoi_dung;
DROP TRIGGER IF EXISTS trg_lich_hen_cap_nhat ON public.lich_hen;
DROP TRIGGER IF EXISTS trg_khach_thue_cap_nhat ON public.khach_thue;
DROP TRIGGER IF EXISTS trg_hop_dong_cap_nhat ON public.hop_dong;
DROP TRIGGER IF EXISTS trg_hoa_don_status ON public.hoa_don;
DROP TRIGGER IF EXISTS trg_hoa_don_cap_nhat ON public.hoa_don;
DROP TRIGGER IF EXISTS trg_dich_vu_cap_nhat ON public.dich_vu;
DROP TRIGGER IF EXISTS trg_cthd_recalc ON public.chi_tiet_hoa_don;
DROP TRIGGER IF EXISTS trg_chu_tro_cap_nhat ON public.chu_tro;
DROP TRIGGER IF EXISTS trg_chi_so_cap_nhat ON public.chi_so_dien_nuoc;
DROP TRIGGER IF EXISTS trg_cau_hinh_gia_cap_nhat ON public.cau_hinh_gia;
DROP INDEX IF EXISTS public.idx_tvhd_hop_dong;
DROP INDEX IF EXISTS public.idx_thong_bao_recipient;
DROP INDEX IF EXISTS public.idx_thanh_toan_ref;
DROP INDEX IF EXISTS public.idx_thanh_toan_hoa_don;
DROP INDEX IF EXISTS public.idx_su_co_phong_status;
DROP INDEX IF EXISTS public.idx_refresh_token_user;
DROP INDEX IF EXISTS public.idx_phong_trang_thai;
DROP INDEX IF EXISTS public.idx_phong_nha_tro;
DROP INDEX IF EXISTS public.idx_nha_tro_chu_tro;
DROP INDEX IF EXISTS public.idx_nguoi_dung_trang_thai;
DROP INDEX IF EXISTS public.idx_nguoi_dung_email;
DROP INDEX IF EXISTS public.idx_ndnt_nha_tro_user;
DROP INDEX IF EXISTS public.idx_login_history_user_time;
DROP INDEX IF EXISTS public.idx_lich_hen_phong_time;
DROP INDEX IF EXISTS public.idx_khach_thue_sdt;
DROP INDEX IF EXISTS public.idx_khach_thue_chu_tro;
DROP INDEX IF EXISTS public.idx_hop_dong_phong_status_dates;
DROP INDEX IF EXISTS public.idx_hop_dong_khach_thue;
DROP INDEX IF EXISTS public.idx_hoa_don_status_due;
DROP INDEX IF EXISTS public.idx_hoa_don_phong;
DROP INDEX IF EXISTS public.idx_hoa_don_khach_thue;
DROP INDEX IF EXISTS public.idx_hoa_don_hop_dong_ky;
DROP INDEX IF EXISTS public.idx_file_media_target;
DROP INDEX IF EXISTS public.idx_dvhd_hop_dong;
DROP INDEX IF EXISTS public.idx_dat_coc_phong;
DROP INDEX IF EXISTS public.idx_cthd_hoa_don;
DROP INDEX IF EXISTS public.idx_chi_so_phong_ky;
DROP INDEX IF EXISTS public.idx_cau_hinh_gia_nha_tro;
DROP INDEX IF EXISTS public.idx_audit_log_target;
DROP INDEX IF EXISTS auth.webauthn_credentials_user_id_idx;
DROP INDEX IF EXISTS auth.webauthn_credentials_credential_id_key;
DROP INDEX IF EXISTS auth.webauthn_challenges_user_id_idx;
DROP INDEX IF EXISTS auth.webauthn_challenges_expires_at_idx;
DROP INDEX IF EXISTS auth.users_is_anonymous_idx;
DROP INDEX IF EXISTS auth.users_instance_id_idx;
DROP INDEX IF EXISTS auth.users_instance_id_email_idx;
DROP INDEX IF EXISTS auth.users_email_partial_key;
DROP INDEX IF EXISTS auth.user_id_created_at_idx;
DROP INDEX IF EXISTS auth.unique_phone_factor_per_user;
DROP INDEX IF EXISTS auth.sso_providers_resource_id_pattern_idx;
DROP INDEX IF EXISTS auth.sso_providers_resource_id_idx;
DROP INDEX IF EXISTS auth.sso_domains_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.sso_domains_domain_idx;
DROP INDEX IF EXISTS auth.sessions_user_id_idx;
DROP INDEX IF EXISTS auth.sessions_oauth_client_id_idx;
DROP INDEX IF EXISTS auth.sessions_not_after_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_for_email_idx;
DROP INDEX IF EXISTS auth.saml_relay_states_created_at_idx;
DROP INDEX IF EXISTS auth.saml_providers_sso_provider_id_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_updated_at_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_session_id_revoked_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_parent_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_instance_id_user_id_idx;
DROP INDEX IF EXISTS auth.refresh_tokens_instance_id_idx;
DROP INDEX IF EXISTS auth.recovery_token_idx;
DROP INDEX IF EXISTS auth.reauthentication_token_idx;
DROP INDEX IF EXISTS auth.one_time_tokens_user_id_token_type_key;
DROP INDEX IF EXISTS auth.one_time_tokens_token_hash_hash_idx;
DROP INDEX IF EXISTS auth.one_time_tokens_relates_to_hash_idx;
DROP INDEX IF EXISTS auth.oauth_consents_user_order_idx;
DROP INDEX IF EXISTS auth.oauth_consents_active_user_client_idx;
DROP INDEX IF EXISTS auth.oauth_consents_active_client_idx;
DROP INDEX IF EXISTS auth.oauth_clients_deleted_at_idx;
DROP INDEX IF EXISTS auth.oauth_auth_pending_exp_idx;
DROP INDEX IF EXISTS auth.mfa_factors_user_id_idx;
DROP INDEX IF EXISTS auth.mfa_factors_user_friendly_name_unique;
DROP INDEX IF EXISTS auth.mfa_challenge_created_at_idx;
DROP INDEX IF EXISTS auth.idx_users_name;
DROP INDEX IF EXISTS auth.idx_users_last_sign_in_at_desc;
DROP INDEX IF EXISTS auth.idx_users_email;
DROP INDEX IF EXISTS auth.idx_users_created_at_desc;
DROP INDEX IF EXISTS auth.idx_user_id_auth_method;
DROP INDEX IF EXISTS auth.idx_oauth_client_states_created_at;
DROP INDEX IF EXISTS auth.idx_auth_code;
DROP INDEX IF EXISTS auth.identities_user_id_idx;
DROP INDEX IF EXISTS auth.identities_email_idx;
DROP INDEX IF EXISTS auth.flow_state_created_at_idx;
DROP INDEX IF EXISTS auth.factor_id_created_at_idx;
DROP INDEX IF EXISTS auth.email_change_token_new_idx;
DROP INDEX IF EXISTS auth.email_change_token_current_idx;
DROP INDEX IF EXISTS auth.custom_oauth_providers_provider_type_idx;
DROP INDEX IF EXISTS auth.custom_oauth_providers_identifier_idx;
DROP INDEX IF EXISTS auth.custom_oauth_providers_enabled_idx;
DROP INDEX IF EXISTS auth.custom_oauth_providers_created_at_idx;
DROP INDEX IF EXISTS auth.confirmation_token_idx;
DROP INDEX IF EXISTS auth.audit_logs_instance_id_idx;
ALTER TABLE IF EXISTS ONLY public.vai_tro DROP CONSTRAINT IF EXISTS vai_tro_ten_key;
ALTER TABLE IF EXISTS ONLY public.vai_tro DROP CONSTRAINT IF EXISTS vai_tro_pkey;
ALTER TABLE IF EXISTS ONLY public.tien_ich DROP CONSTRAINT IF EXISTS tien_ich_ten_key;
ALTER TABLE IF EXISTS ONLY public.tien_ich DROP CONSTRAINT IF EXISTS tien_ich_pkey;
ALTER TABLE IF EXISTS ONLY public.thong_bao DROP CONSTRAINT IF EXISTS thong_bao_pkey;
ALTER TABLE IF EXISTS ONLY public.thong_bao_nguoi_nhan DROP CONSTRAINT IF EXISTS thong_bao_nguoi_nhan_thong_bao_id_nguoi_dung_id_key;
ALTER TABLE IF EXISTS ONLY public.thong_bao_nguoi_nhan DROP CONSTRAINT IF EXISTS thong_bao_nguoi_nhan_pkey;
ALTER TABLE IF EXISTS ONLY public.thanh_vien_hop_dong DROP CONSTRAINT IF EXISTS thanh_vien_hop_dong_pkey;
ALTER TABLE IF EXISTS ONLY public.thanh_toan DROP CONSTRAINT IF EXISTS thanh_toan_pkey;
ALTER TABLE IF EXISTS ONLY public.thanh_toan DROP CONSTRAINT IF EXISTS thanh_toan_external_transaction_id_key;
ALTER TABLE IF EXISTS ONLY public.su_co DROP CONSTRAINT IF EXISTS su_co_pkey;
ALTER TABLE IF EXISTS ONLY public.refresh_token DROP CONSTRAINT IF EXISTS refresh_token_token_key;
ALTER TABLE IF EXISTS ONLY public.refresh_token DROP CONSTRAINT IF EXISTS refresh_token_pkey;
ALTER TABLE IF EXISTS ONLY public.phu_luc_hop_dong DROP CONSTRAINT IF EXISTS phu_luc_hop_dong_pkey;
ALTER TABLE IF EXISTS ONLY public.phong_tien_ich DROP CONSTRAINT IF EXISTS phong_tien_ich_pkey;
ALTER TABLE IF EXISTS ONLY public.phong DROP CONSTRAINT IF EXISTS phong_pkey;
ALTER TABLE IF EXISTS ONLY public.phong DROP CONSTRAINT IF EXISTS phong_nha_tro_id_ten_key;
ALTER TABLE IF EXISTS ONLY public.nha_tro DROP CONSTRAINT IF EXISTS nha_tro_pkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung_vai_tro DROP CONSTRAINT IF EXISTS nguoi_dung_vai_tro_pkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung DROP CONSTRAINT IF EXISTS nguoi_dung_so_dien_thoai_key;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung DROP CONSTRAINT IF EXISTS nguoi_dung_so_cccd_key;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung DROP CONSTRAINT IF EXISTS nguoi_dung_pkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung_nha_tro DROP CONSTRAINT IF EXISTS nguoi_dung_nha_tro_pkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung_nha_tro DROP CONSTRAINT IF EXISTS nguoi_dung_nha_tro_nguoi_dung_id_nha_tro_id_vai_tro_key;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung DROP CONSTRAINT IF EXISTS nguoi_dung_email_key;
ALTER TABLE IF EXISTS ONLY public.login_history DROP CONSTRAINT IF EXISTS login_history_pkey;
ALTER TABLE IF EXISTS ONLY public.lich_su_hoa_don DROP CONSTRAINT IF EXISTS lich_su_hoa_don_pkey;
ALTER TABLE IF EXISTS ONLY public.lich_hen DROP CONSTRAINT IF EXISTS lich_hen_pkey;
ALTER TABLE IF EXISTS ONLY public.khach_thue DROP CONSTRAINT IF EXISTS khach_thue_pkey;
ALTER TABLE IF EXISTS ONLY public.khach_thue DROP CONSTRAINT IF EXISTS khach_thue_nguoi_dung_id_key;
ALTER TABLE IF EXISTS ONLY public.khach_thue DROP CONSTRAINT IF EXISTS khach_thue_chu_tro_id_so_cccd_key;
ALTER TABLE IF EXISTS ONLY public.hop_dong DROP CONSTRAINT IF EXISTS hop_dong_pkey;
ALTER TABLE IF EXISTS ONLY public.hop_dong DROP CONSTRAINT IF EXISTS hop_dong_ma_hop_dong_key;
ALTER TABLE IF EXISTS ONLY public.hoa_don DROP CONSTRAINT IF EXISTS hoa_don_pkey;
ALTER TABLE IF EXISTS ONLY public.hoa_don DROP CONSTRAINT IF EXISTS hoa_don_ma_hoa_don_key;
ALTER TABLE IF EXISTS ONLY public.hoa_don DROP CONSTRAINT IF EXISTS hoa_don_hop_dong_id_ky_nam_ky_thang_key;
ALTER TABLE IF EXISTS ONLY public.file_media DROP CONSTRAINT IF EXISTS file_media_pkey;
ALTER TABLE IF EXISTS ONLY public.hop_dong DROP CONSTRAINT IF EXISTS excl_hop_dong_phong_active_overlap;
ALTER TABLE IF EXISTS ONLY public.email_verification_token DROP CONSTRAINT IF EXISTS email_verification_token_pkey;
ALTER TABLE IF EXISTS ONLY public.dich_vu DROP CONSTRAINT IF EXISTS dich_vu_pkey;
ALTER TABLE IF EXISTS ONLY public.dich_vu_hop_dong DROP CONSTRAINT IF EXISTS dich_vu_hop_dong_pkey;
ALTER TABLE IF EXISTS ONLY public.dich_vu_hop_dong DROP CONSTRAINT IF EXISTS dich_vu_hop_dong_hop_dong_id_dich_vu_id_bat_dau_tu_key;
ALTER TABLE IF EXISTS ONLY public.dich_vu DROP CONSTRAINT IF EXISTS dich_vu_chu_tro_id_ten_dich_vu_key;
ALTER TABLE IF EXISTS ONLY public.dat_coc_phong DROP CONSTRAINT IF EXISTS dat_coc_phong_pkey;
ALTER TABLE IF EXISTS ONLY public.chu_tro DROP CONSTRAINT IF EXISTS chu_tro_so_cccd_key;
ALTER TABLE IF EXISTS ONLY public.chu_tro DROP CONSTRAINT IF EXISTS chu_tro_pkey;
ALTER TABLE IF EXISTS ONLY public.chu_tro DROP CONSTRAINT IF EXISTS chu_tro_nguoi_dung_id_key;
ALTER TABLE IF EXISTS ONLY public.chi_tiet_hoa_don DROP CONSTRAINT IF EXISTS chi_tiet_hoa_don_pkey;
ALTER TABLE IF EXISTS ONLY public.chi_so_dien_nuoc DROP CONSTRAINT IF EXISTS chi_so_dien_nuoc_pkey;
ALTER TABLE IF EXISTS ONLY public.chi_so_dien_nuoc DROP CONSTRAINT IF EXISTS chi_so_dien_nuoc_phong_id_loai_ky_nam_ky_thang_key;
ALTER TABLE IF EXISTS ONLY public.cau_hinh_gia DROP CONSTRAINT IF EXISTS cau_hinh_gia_pkey;
ALTER TABLE IF EXISTS ONLY public.bank_transaction DROP CONSTRAINT IF EXISTS bank_transaction_pkey;
ALTER TABLE IF EXISTS ONLY public.bank_transaction DROP CONSTRAINT IF EXISTS bank_transaction_ma_giao_dich_key;
ALTER TABLE IF EXISTS ONLY public.audit_log DROP CONSTRAINT IF EXISTS audit_log_pkey;
ALTER TABLE IF EXISTS ONLY auth.webauthn_credentials DROP CONSTRAINT IF EXISTS webauthn_credentials_pkey;
ALTER TABLE IF EXISTS ONLY auth.webauthn_challenges DROP CONSTRAINT IF EXISTS webauthn_challenges_pkey;
ALTER TABLE IF EXISTS ONLY auth.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY auth.users DROP CONSTRAINT IF EXISTS users_phone_key;
ALTER TABLE IF EXISTS ONLY auth.sso_providers DROP CONSTRAINT IF EXISTS sso_providers_pkey;
ALTER TABLE IF EXISTS ONLY auth.sso_domains DROP CONSTRAINT IF EXISTS sso_domains_pkey;
ALTER TABLE IF EXISTS ONLY auth.sessions DROP CONSTRAINT IF EXISTS sessions_pkey;
ALTER TABLE IF EXISTS ONLY auth.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_relay_states DROP CONSTRAINT IF EXISTS saml_relay_states_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_pkey;
ALTER TABLE IF EXISTS ONLY auth.saml_providers DROP CONSTRAINT IF EXISTS saml_providers_entity_id_key;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_token_unique;
ALTER TABLE IF EXISTS ONLY auth.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_pkey;
ALTER TABLE IF EXISTS ONLY auth.one_time_tokens DROP CONSTRAINT IF EXISTS one_time_tokens_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_user_client_unique;
ALTER TABLE IF EXISTS ONLY auth.oauth_consents DROP CONSTRAINT IF EXISTS oauth_consents_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_clients DROP CONSTRAINT IF EXISTS oauth_clients_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_client_states DROP CONSTRAINT IF EXISTS oauth_client_states_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_pkey;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_authorization_id_key;
ALTER TABLE IF EXISTS ONLY auth.oauth_authorizations DROP CONSTRAINT IF EXISTS oauth_authorizations_authorization_code_key;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_factors DROP CONSTRAINT IF EXISTS mfa_factors_last_challenged_at_key;
ALTER TABLE IF EXISTS ONLY auth.mfa_challenges DROP CONSTRAINT IF EXISTS mfa_challenges_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS mfa_amr_claims_session_id_authentication_method_pkey;
ALTER TABLE IF EXISTS ONLY auth.instances DROP CONSTRAINT IF EXISTS instances_pkey;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_provider_id_provider_unique;
ALTER TABLE IF EXISTS ONLY auth.identities DROP CONSTRAINT IF EXISTS identities_pkey;
ALTER TABLE IF EXISTS ONLY auth.flow_state DROP CONSTRAINT IF EXISTS flow_state_pkey;
ALTER TABLE IF EXISTS ONLY auth.custom_oauth_providers DROP CONSTRAINT IF EXISTS custom_oauth_providers_pkey;
ALTER TABLE IF EXISTS ONLY auth.custom_oauth_providers DROP CONSTRAINT IF EXISTS custom_oauth_providers_identifier_key;
ALTER TABLE IF EXISTS ONLY auth.audit_log_entries DROP CONSTRAINT IF EXISTS audit_log_entries_pkey;
ALTER TABLE IF EXISTS ONLY auth.mfa_amr_claims DROP CONSTRAINT IF EXISTS amr_id_pk;
ALTER TABLE IF EXISTS auth.refresh_tokens ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS public.vai_tro;
DROP TABLE IF EXISTS public.tien_ich;
DROP TABLE IF EXISTS public.thong_bao_nguoi_nhan;
DROP TABLE IF EXISTS public.thong_bao;
DROP TABLE IF EXISTS public.thanh_vien_hop_dong;
DROP TABLE IF EXISTS public.thanh_toan;
DROP TABLE IF EXISTS public.su_co;
DROP TABLE IF EXISTS public.refresh_token;
DROP TABLE IF EXISTS public.phu_luc_hop_dong;
DROP TABLE IF EXISTS public.phong_tien_ich;
DROP TABLE IF EXISTS public.phong;
DROP TABLE IF EXISTS public.nha_tro;
DROP TABLE IF EXISTS public.nguoi_dung_vai_tro;
DROP TABLE IF EXISTS public.nguoi_dung_nha_tro;
DROP TABLE IF EXISTS public.nguoi_dung;
DROP TABLE IF EXISTS public.login_history;
DROP TABLE IF EXISTS public.lich_su_hoa_don;
DROP TABLE IF EXISTS public.lich_hen;
DROP TABLE IF EXISTS public.khach_thue;
DROP TABLE IF EXISTS public.hop_dong;
DROP TABLE IF EXISTS public.hoa_don;
DROP TABLE IF EXISTS public.file_media;
DROP TABLE IF EXISTS public.email_verification_token;
DROP TABLE IF EXISTS public.dich_vu_hop_dong;
DROP TABLE IF EXISTS public.dich_vu;
DROP TABLE IF EXISTS public.dat_coc_phong;
DROP TABLE IF EXISTS public.chu_tro;
DROP TABLE IF EXISTS public.chi_tiet_hoa_don;
DROP TABLE IF EXISTS public.chi_so_dien_nuoc;
DROP TABLE IF EXISTS public.cau_hinh_gia;
DROP TABLE IF EXISTS public.bank_transaction;
DROP TABLE IF EXISTS public.audit_log;
DROP TABLE IF EXISTS auth.webauthn_credentials;
DROP TABLE IF EXISTS auth.webauthn_challenges;
DROP TABLE IF EXISTS auth.users;
DROP TABLE IF EXISTS auth.sso_providers;
DROP TABLE IF EXISTS auth.sso_domains;
DROP TABLE IF EXISTS auth.sessions;
DROP TABLE IF EXISTS auth.schema_migrations;
DROP TABLE IF EXISTS auth.saml_relay_states;
DROP TABLE IF EXISTS auth.saml_providers;
DROP SEQUENCE IF EXISTS auth.refresh_tokens_id_seq;
DROP TABLE IF EXISTS auth.refresh_tokens;
DROP TABLE IF EXISTS auth.one_time_tokens;
DROP TABLE IF EXISTS auth.oauth_consents;
DROP TABLE IF EXISTS auth.oauth_clients;
DROP TABLE IF EXISTS auth.oauth_client_states;
DROP TABLE IF EXISTS auth.oauth_authorizations;
DROP TABLE IF EXISTS auth.mfa_factors;
DROP TABLE IF EXISTS auth.mfa_challenges;
DROP TABLE IF EXISTS auth.mfa_amr_claims;
DROP TABLE IF EXISTS auth.instances;
DROP TABLE IF EXISTS auth.identities;
DROP TABLE IF EXISTS auth.flow_state;
DROP TABLE IF EXISTS auth.custom_oauth_providers;
DROP TABLE IF EXISTS auth.audit_log_entries;
DROP FUNCTION IF EXISTS public.update_updated_at_column();
DROP FUNCTION IF EXISTS public.update_invoice_status_on_payment();
DROP FUNCTION IF EXISTS public.recalc_hoa_don_from_thanh_toan();
DROP FUNCTION IF EXISTS public.recalc_hoa_don_from_chi_tiet();
DROP FUNCTION IF EXISTS public.is_admin();
DROP FUNCTION IF EXISTS public.cap_nhat_trang_thai_hoa_don();
DROP FUNCTION IF EXISTS public.cap_nhat_thoi_gian();
DROP FUNCTION IF EXISTS public.can_access_nha_tro(p_nha_tro_id uuid);
DROP FUNCTION IF EXISTS extensions.set_graphql_placeholder();
DROP FUNCTION IF EXISTS extensions.pgrst_drop_watch();
DROP FUNCTION IF EXISTS extensions.pgrst_ddl_watch();
DROP FUNCTION IF EXISTS extensions.grant_pg_net_access();
DROP FUNCTION IF EXISTS extensions.grant_pg_graphql_access();
DROP FUNCTION IF EXISTS extensions.grant_pg_cron_access();
DROP FUNCTION IF EXISTS auth.uid();
DROP FUNCTION IF EXISTS auth.role();
DROP FUNCTION IF EXISTS auth.jwt();
DROP FUNCTION IF EXISTS auth.email();
DROP TYPE IF EXISTS public.vai_tro_he_thong;
DROP TYPE IF EXISTS public.uu_tien_enum;
DROP TYPE IF EXISTS public.user_status;
DROP TYPE IF EXISTS public.trang_thai_thanh_toan;
DROP TYPE IF EXISTS public.trang_thai_su_co;
DROP TYPE IF EXISTS public.trang_thai_phong;
DROP TYPE IF EXISTS public.trang_thai_nguoi_dung;
DROP TYPE IF EXISTS public.trang_thai_lich_hen;
DROP TYPE IF EXISTS public.trang_thai_hop_dong;
DROP TYPE IF EXISTS public.trang_thai_hoa_don;
DROP TYPE IF EXISTS public.trang_thai_dat_coc;
DROP TYPE IF EXISTS public.trang_thai_coc_hop_dong;
DROP TYPE IF EXISTS public.trang_thai_chi_so;
DROP TYPE IF EXISTS public.room_status;
DROP TYPE IF EXISTS public.phuong_thuc_thanh_toan;
DROP TYPE IF EXISTS public.media_entity_type;
DROP TYPE IF EXISTS public.maintenance_status;
DROP TYPE IF EXISTS public.loai_tinh_phi;
DROP TYPE IF EXISTS public.loai_thong_bao;
DROP TYPE IF EXISTS public.loai_su_co_enum;
DROP TYPE IF EXISTS public.loai_muc_hoa_don;
DROP TYPE IF EXISTS public.loai_doi_tuong_media;
DROP TYPE IF EXISTS public.loai_chi_so;
DROP TYPE IF EXISTS public.kenh_thong_bao;
DROP TYPE IF EXISTS public.invoice_status;
DROP TYPE IF EXISTS public.invoice_item_type;
DROP TYPE IF EXISTS public.contract_status;
DROP TYPE IF EXISTS public.contract_deposit_status;
DROP TYPE IF EXISTS public.calc_type;
DROP TYPE IF EXISTS public.booking_deposit_status;
DROP TYPE IF EXISTS public.appointment_status;
DROP TYPE IF EXISTS auth.one_time_token_type;
DROP TYPE IF EXISTS auth.oauth_response_type;
DROP TYPE IF EXISTS auth.oauth_registration_type;
DROP TYPE IF EXISTS auth.oauth_client_type;
DROP TYPE IF EXISTS auth.oauth_authorization_status;
DROP TYPE IF EXISTS auth.factor_type;
DROP TYPE IF EXISTS auth.factor_status;
DROP TYPE IF EXISTS auth.code_challenge_method;
DROP TYPE IF EXISTS auth.aal_level;
DROP SCHEMA IF EXISTS public;
DROP SCHEMA IF EXISTS extensions;
DROP SCHEMA IF EXISTS auth;
--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;

--
-- Required extensions used by EasyHouse/Supabase-compatible defaults.
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;



--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;



--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- Name: appointment_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.appointment_status AS ENUM (
    'PENDING',
    'CONFIRMED',
    'CANCELLED',
    'COMPLETED'
);


--
-- Name: booking_deposit_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.booking_deposit_status AS ENUM (
    'PENDING',
    'COMPLETED',
    'REFUNDED',
    'FORFEITED'
);


--
-- Name: calc_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.calc_type AS ENUM (
    'PER_METER',
    'PER_PERSON',
    'PER_ROOM'
);


--
-- Name: contract_deposit_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.contract_deposit_status AS ENUM (
    'KEPT',
    'REFUNDED',
    'DEDUCTED'
);


--
-- Name: contract_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.contract_status AS ENUM (
    'PENDING',
    'ACTIVE',
    'EXPIRED',
    'TERMINATED'
);


--
-- Name: invoice_item_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.invoice_item_type AS ENUM (
    'ROOM',
    'ELECTRICITY',
    'WATER',
    'SERVICE',
    'INTERNET',
    'OTHER'
);


--
-- Name: invoice_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.invoice_status AS ENUM (
    'UNPAID',
    'PARTIAL',
    'PAID'
);


--
-- Name: kenh_thong_bao; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.kenh_thong_bao AS ENUM (
    'IN_APP',
    'EMAIL',
    'SMS',
    'ZALO',
    'TELEGRAM',
    'PUSH'
);


--
-- Name: loai_chi_so; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_chi_so AS ENUM (
    'ELECTRICITY',
    'WATER'
);


--
-- Name: loai_doi_tuong_media; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_doi_tuong_media AS ENUM (
    'USER',
    'TENANT',
    'ROOM',
    'CONTRACT',
    'INVOICE',
    'PAYMENT',
    'INCIDENT',
    'METER_READING',
    'APPOINTMENT',
    'OTHER'
);


--
-- Name: loai_muc_hoa_don; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_muc_hoa_don AS ENUM (
    'ROOM',
    'ELECTRICITY',
    'WATER',
    'SERVICE',
    'INTERNET',
    'GARBAGE',
    'PARKING',
    'MAINTENANCE',
    'DEBT',
    'DISCOUNT',
    'OTHER',
    'BALCONY',
    'TRASH',
    'AIR_CONDITIONER',
    'WASHING_MACHINE',
    'REFRIGERATOR',
    'WATER_HEATER',
    'BED',
    'WARDROBE',
    'TABLE_CHAIR',
    'KITCHEN',
    'KITCHEN_SHELF',
    'CLEANING',
    'LAUNDRY',
    'SMART_LOCK',
    'SECURITY_CAMERA'
);


--
-- Name: loai_su_co_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_su_co_enum AS ENUM (
    'dien_nuoc',
    'noi_that',
    've_sinh',
    'an_ninh',
    'internet',
    'khac'
);


--
-- Name: loai_thong_bao; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_thong_bao AS ENUM (
    'SYSTEM',
    'INVOICE',
    'PAYMENT',
    'CONTRACT',
    'INCIDENT',
    'APPOINTMENT',
    'DEBT'
);


--
-- Name: loai_tinh_phi; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_tinh_phi AS ENUM (
    'FIXED',
    'PER_PERSON',
    'PER_ROOM',
    'PER_UNIT',
    'PERCENT'
);


--
-- Name: maintenance_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.maintenance_status AS ENUM (
    'PENDING',
    'IN_PROGRESS',
    'RESOLVED',
    'REJECTED'
);


--
-- Name: media_entity_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.media_entity_type AS ENUM (
    'USER',
    'MOTEL',
    'ROOM',
    'CONTRACT',
    'INVOICE',
    'OTHER'
);


--
-- Name: phuong_thuc_thanh_toan; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.phuong_thuc_thanh_toan AS ENUM (
    'CASH',
    'BANK_TRANSFER',
    'VIETQR',
    'MOMO',
    'ZALOPAY',
    'OTHER'
);


--
-- Name: room_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.room_status AS ENUM (
    'AVAILABLE',
    'RENTED',
    'MAINTENANCE'
);


--
-- Name: trang_thai_chi_so; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_chi_so AS ENUM (
    'DRAFT',
    'CONFIRMED',
    'BILLED',
    'CANCELLED'
);


--
-- Name: trang_thai_coc_hop_dong; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_coc_hop_dong AS ENUM (
    'NOT_PAID',
    'KEPT',
    'REFUNDED',
    'DEDUCTED',
    'FORFEITED'
);


--
-- Name: trang_thai_dat_coc; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_dat_coc AS ENUM (
    'PENDING',
    'COMPLETED',
    'REFUNDED',
    'FORFEITED',
    'CANCELLED'
);


--
-- Name: trang_thai_hoa_don; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_hoa_don AS ENUM (
    'DRAFT',
    'UNPAID',
    'PARTIAL',
    'PAID',
    'OVERPAID',
    'OVERDUE',
    'CANCELLED'
);


--
-- Name: trang_thai_hop_dong; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_hop_dong AS ENUM (
    'DRAFT',
    'PENDING',
    'ACTIVE',
    'EXPIRED',
    'TERMINATED',
    'CANCELLED'
);


--
-- Name: trang_thai_lich_hen; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_lich_hen AS ENUM (
    'PENDING',
    'CONFIRMED',
    'CANCELLED',
    'COMPLETED',
    'NO_SHOW'
);


--
-- Name: trang_thai_nguoi_dung; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_nguoi_dung AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'BANNED'
);


--
-- Name: trang_thai_phong; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_phong AS ENUM (
    'AVAILABLE',
    'RENTED',
    'MAINTENANCE',
    'RESERVED',
    'INACTIVE'
);


--
-- Name: trang_thai_su_co; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_su_co AS ENUM (
    'PENDING',
    'IN_PROGRESS',
    'RESOLVED',
    'CANCELLED'
);


--
-- Name: trang_thai_thanh_toan; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_thanh_toan AS ENUM (
    'PENDING',
    'SUCCESS',
    'FAILED',
    'CANCELLED',
    'REFUNDED'
);


--
-- Name: user_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_status AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'BANNED'
);


--
-- Name: uu_tien_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.uu_tien_enum AS ENUM (
    'thap',
    'trung_binh',
    'cao',
    'khan_cap'
);


--
-- Name: vai_tro_he_thong; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vai_tro_he_thong AS ENUM (
    'ADMIN',
    'LANDLORD',
    'STAFF',
    'TENANT'
);


--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  SELECT nullif(current_setting('request.jwt.claim.sub', true), '')::uuid;
$$;


--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
begin
    if not exists (
        select 1
        from pg_event_trigger_ddl_commands() ev
        join pg_catalog.pg_extension e on ev.objid = e.oid
        where e.extname = 'pg_graphql'
    ) then
        return;
    end if;

    drop function if exists graphql_public.graphql;
    create or replace function graphql_public.graphql(
        "operationName" text default null,
        query text default null,
        variables jsonb default null,
        extensions jsonb default null
    )
        returns jsonb
        language sql
    as $$
        select graphql.resolve(
            query := query,
            variables := coalesce(variables, '{}'),
            "operationName" := "operationName",
            extensions := extensions
        );
    $$;

    -- Attach the wrapper to the extension so DROP EXTENSION cascades to it,
    -- which in turn triggers set_graphql_placeholder to reinstall the "not enabled" stub.
    alter extension pg_graphql add function graphql_public.graphql(text, text, jsonb, jsonb);

    grant usage on schema graphql to postgres, anon, authenticated, service_role;
    grant execute on function graphql.resolve to postgres, anon, authenticated, service_role;
    grant usage on schema graphql to postgres with grant option;
    grant usage on schema graphql_public to postgres with grant option;
end;
$_$;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: can_access_nha_tro(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.can_access_nha_tro(p_nha_tro_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT public.is_admin()
        OR EXISTS (
            SELECT 1
            FROM public.nha_tro nt
            WHERE nt.id = p_nha_tro_id
              AND nt.chu_tro_id = auth.uid()
        )
        OR EXISTS (
            SELECT 1
            FROM public.nguoi_dung_nha_tro ndnt
            WHERE ndnt.nha_tro_id = p_nha_tro_id
              AND ndnt.nguoi_dung_id = auth.uid()
              AND ndnt.co_quyen_xem = true
        );
$$;


--
-- Name: cap_nhat_thoi_gian(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.cap_nhat_thoi_gian() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.cap_nhat_luc = now();
    RETURN NEW;
END;
$$;


--
-- Name: cap_nhat_trang_thai_hoa_don(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.cap_nhat_trang_thai_hoa_don() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.trang_thai = 'CANCELLED' THEN
        RETURN NEW;
    END IF;

    IF NEW.trang_thai = 'DRAFT' AND NEW.tong_tien = 0 AND NEW.da_tra = 0 THEN
        RETURN NEW;
    END IF;

    IF NEW.da_tra = 0 AND NEW.han_tra < CURRENT_DATE THEN
        NEW.trang_thai = 'OVERDUE';
    ELSIF NEW.da_tra = 0 THEN
        NEW.trang_thai = 'UNPAID';
    ELSIF NEW.da_tra < NEW.tong_tien THEN
        NEW.trang_thai = 'PARTIAL';
    ELSIF NEW.da_tra = NEW.tong_tien THEN
        NEW.trang_thai = 'PAID';
    ELSE
        NEW.trang_thai = 'OVERPAID';
    END IF;

    RETURN NEW;
END;
$$;


--
-- Name: is_admin(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_admin() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.nguoi_dung_vai_tro ndvt
        JOIN public.vai_tro vt ON vt.id = ndvt.vai_tro_id
        WHERE ndvt.nguoi_dung_id = auth.uid()
          AND vt.ten = 'ADMIN'
    );
$$;


--
-- Name: recalc_hoa_don_from_chi_tiet(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.recalc_hoa_don_from_chi_tiet() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_hoa_don_id uuid;
BEGIN
    v_hoa_don_id = COALESCE(NEW.hoa_don_id, OLD.hoa_don_id);

    UPDATE public.hoa_don hd
    SET tong_tien_phat_sinh = COALESCE((
            SELECT sum(ct.thanh_tien)
            FROM public.chi_tiet_hoa_don ct
            WHERE ct.hoa_don_id = v_hoa_don_id
        ), 0),
        tong_tien = hd.so_du_dau_ky + COALESCE((
            SELECT sum(ct.thanh_tien)
            FROM public.chi_tiet_hoa_don ct
            WHERE ct.hoa_don_id = v_hoa_don_id
        ), 0),
        cap_nhat_luc = now()
    WHERE hd.id = v_hoa_don_id;

    RETURN COALESCE(NEW, OLD);
END;
$$;


--
-- Name: recalc_hoa_don_from_thanh_toan(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.recalc_hoa_don_from_thanh_toan() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_hoa_don_id uuid;
BEGIN
    v_hoa_don_id = COALESCE(NEW.hoa_don_id, OLD.hoa_don_id);

    UPDATE public.hoa_don hd
    SET da_tra = COALESCE((
            SELECT sum(tt.so_tien)
            FROM public.thanh_toan tt
            WHERE tt.hoa_don_id = v_hoa_don_id
              AND tt.trang_thai = 'SUCCESS'
        ), 0),
        cap_nhat_luc = now()
    WHERE hd.id = v_hoa_don_id;

    RETURN COALESCE(NEW, OLD);
END;
$$;


--
-- Name: update_invoice_status_on_payment(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_invoice_status_on_payment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE

    total_paid DECIMAL(15, 2);

    inv_total DECIMAL(15, 2);

    old_status invoice_status;

    new_calculated_status invoice_status;

BEGIN

    -- Only process SUCCESS payments

    IF NEW.status != 'SUCCESS' THEN

        RETURN NEW;

    END IF;



    -- Calculate total paid amount for the invoice

    SELECT COALESCE(SUM(amount), 0) INTO total_paid

    FROM payments

    WHERE invoice_id = NEW.invoice_id AND status = 'SUCCESS';



    -- Get invoice details

    SELECT total_amount, status INTO inv_total, old_status

    FROM invoices

    WHERE id = NEW.invoice_id;



    -- Determine new status

    IF total_paid >= inv_total THEN

        new_calculated_status := 'PAID'::invoice_status;

    ELSIF total_paid > 0 THEN

        new_calculated_status := 'PARTIAL'::invoice_status;

    ELSE

        new_calculated_status := 'UNPAID'::invoice_status;

    END IF;



    -- Update invoice

    UPDATE invoices

    SET paid_amount = total_paid,

        status = new_calculated_status,

        updated_at = CURRENT_TIMESTAMP

    WHERE id = NEW.invoice_id;



    -- Log history if status changed

    IF old_status != new_calculated_status THEN

        INSERT INTO invoice_history (invoice_id, previous_status, new_status, notes)

        VALUES (NEW.invoice_id, old_status, new_calculated_status, 'System auto-update upon payment');

    END IF;



    RETURN NEW;

END;

$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

    NEW.updated_at = CURRENT_TIMESTAMP;

    RETURN NEW;

END;

$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


--
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


--
-- Name: audit_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid,
    hanh_dong character varying(100) NOT NULL,
    bang_tac_dong character varying(100),
    ban_ghi_id uuid,
    du_lieu_cu jsonb,
    du_lieu_moi jsonb,
    ip_address inet,
    user_agent text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: bank_transaction; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bank_transaction (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nha_tro_id uuid,
    hoa_don_id uuid,
    so_tien numeric(15,2) NOT NULL,
    noi_dung_chuyen_khoan text,
    ma_giao_dich character varying(150),
    ngan_hang character varying(100),
    thoi_gian_giao_dich timestamp with time zone NOT NULL,
    payload jsonb,
    da_doi_soat boolean DEFAULT false NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_bank_transaction_tien CHECK ((so_tien > (0)::numeric))
);


--
-- Name: cau_hinh_gia; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cau_hinh_gia (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nha_tro_id uuid NOT NULL,
    dich_vu_id uuid,
    loai character varying(255) NOT NULL,
    ten_hien_thi character varying(255) NOT NULL,
    loai_tinh_phi character varying(255) DEFAULT 'FIXED'::public.loai_tinh_phi NOT NULL,
    don_gia numeric(38,2) NOT NULL,
    hieu_luc_tu date DEFAULT CURRENT_DATE NOT NULL,
    hieu_luc_den date,
    dang_ap_dung boolean DEFAULT true NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_cau_hinh_gia_ngay CHECK (((hieu_luc_den IS NULL) OR (hieu_luc_den >= hieu_luc_tu))),
    CONSTRAINT chk_cau_hinh_gia_tien CHECK ((don_gia >= (0)::numeric))
);


--
-- Name: chi_so_dien_nuoc; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chi_so_dien_nuoc (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phong_id uuid NOT NULL,
    hop_dong_id uuid,
    loai character varying(255) NOT NULL,
    ky_nam integer NOT NULL,
    ky_thang integer NOT NULL,
    ngay_ghi date DEFAULT CURRENT_DATE NOT NULL,
    chi_so_cu integer NOT NULL,
    chi_so_moi integer NOT NULL,
    tieu_thu integer GENERATED ALWAYS AS ((chi_so_moi - chi_so_cu)) STORED,
    anh_dong_ho character varying(255),
    nguoi_ghi_id uuid,
    trang_thai character varying(255) DEFAULT 'DRAFT'::public.trang_thai_chi_so NOT NULL,
    ghi_chu character varying(255),
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_chi_so_gia_tri CHECK (((chi_so_cu >= 0) AND (chi_so_moi >= chi_so_cu))),
    CONSTRAINT chk_chi_so_ky CHECK ((((ky_thang >= 1) AND (ky_thang <= 12)) AND ((ky_nam >= 2000) AND (ky_nam <= 2100))))
);


--
-- Name: chi_tiet_hoa_don; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chi_tiet_hoa_don (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hoa_don_id uuid NOT NULL,
    dich_vu_id uuid,
    chi_so_dien_nuoc_id uuid,
    su_co_id uuid,
    loai public.loai_muc_hoa_don NOT NULL,
    mo_ta character varying(255) NOT NULL,
    so_luong numeric(38,2) DEFAULT 1 NOT NULL,
    don_gia numeric(38,2) DEFAULT 0 NOT NULL,
    thanh_tien numeric(38,2) DEFAULT 0 NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_cthd_tien CHECK (((so_luong >= (0)::numeric) AND (don_gia >= (0)::numeric) AND (((loai = 'DISCOUNT'::public.loai_muc_hoa_don) AND (thanh_tien <= (0)::numeric)) OR ((loai <> 'DISCOUNT'::public.loai_muc_hoa_don) AND (thanh_tien >= (0)::numeric)))))
);


--
-- Name: chu_tro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chu_tro (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid,
    ten_cong_ty character varying(255),
    so_cccd character varying(50) NOT NULL,
    ma_so_thue character varying(50),
    so_tai_khoan character varying(50),
    da_xac_minh boolean DEFAULT false,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    xoa_luc timestamp with time zone
);


--
-- Name: dat_coc_phong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dat_coc_phong (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phong_id uuid NOT NULL,
    khach_thue_id uuid NOT NULL,
    hop_dong_id uuid,
    so_tien_coc numeric(38,2) NOT NULL,
    ngay_dat_coc timestamp with time zone DEFAULT now() NOT NULL,
    ngay_du_kien_vao date,
    trang_thai character varying(255) DEFAULT 'PENDING'::public.trang_thai_dat_coc NOT NULL,
    ghi_chu character varying(255),
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_dat_coc_tien CHECK ((so_tien_coc > (0)::numeric))
);


--
-- Name: dich_vu; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dich_vu (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    chu_tro_id uuid,
    ten_dich_vu character varying(255) NOT NULL,
    loai_tinh_phi character varying(255) DEFAULT 'FIXED'::public.loai_tinh_phi NOT NULL,
    don_vi character varying(255),
    don_gia_mac_dinh numeric(38,2) DEFAULT 0 NOT NULL,
    bat_buoc boolean DEFAULT false NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_dich_vu_gia CHECK ((don_gia_mac_dinh >= (0)::numeric))
);


--
-- Name: dich_vu_hop_dong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dich_vu_hop_dong (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hop_dong_id uuid NOT NULL,
    dich_vu_id uuid NOT NULL,
    loai_tinh_phi character varying(255) NOT NULL,
    don_gia_ap_dung numeric(38,2) NOT NULL,
    so_luong numeric(38,2) DEFAULT 1 NOT NULL,
    bat_dau_tu date DEFAULT CURRENT_DATE NOT NULL,
    ket_thuc_luc date,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_dvhd_tien CHECK (((don_gia_ap_dung >= (0)::numeric) AND (so_luong >= (0)::numeric)))
);


--
-- Name: email_verification_token; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_verification_token (
    id uuid NOT NULL,
    ngay_het_han timestamp(6) with time zone NOT NULL,
    tao_luc timestamp(6) with time zone NOT NULL,
    token character varying(255) NOT NULL,
    nguoi_dung_id uuid NOT NULL
);


--
-- Name: file_media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.file_media (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    doi_tuong character varying(255) NOT NULL,
    doi_tuong_id uuid NOT NULL,
    url text NOT NULL,
    public_id character varying(255),
    loai_file character varying(255),
    kich_thuoc_bytes bigint,
    metadata jsonb,
    nguoi_tai_len_id uuid,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_file_size CHECK (((kich_thuoc_bytes IS NULL) OR (kich_thuoc_bytes >= 0)))
);


--
-- Name: hoa_don; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hoa_don (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hop_dong_id uuid NOT NULL,
    phong_id uuid NOT NULL,
    khach_thue_id uuid NOT NULL,
    ma_hoa_don character varying(100) NOT NULL,
    ky_nam integer NOT NULL,
    ky_thang integer NOT NULL,
    tu_ngay date NOT NULL,
    den_ngay date NOT NULL,
    so_du_dau_ky numeric(15,2) DEFAULT 0 NOT NULL,
    tong_tien_phat_sinh numeric(15,2) DEFAULT 0 NOT NULL,
    tong_tien numeric(15,2) DEFAULT 0 NOT NULL,
    da_tra numeric(15,2) DEFAULT 0 NOT NULL,
    so_du_cuoi_ky numeric(15,2) GENERATED ALWAYS AS ((tong_tien - da_tra)) STORED,
    trang_thai public.trang_thai_hoa_don DEFAULT 'DRAFT'::public.trang_thai_hoa_don NOT NULL,
    han_tra date NOT NULL,
    ngay_lap_hoa_don timestamp with time zone DEFAULT now() NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    CONSTRAINT chk_hoa_don_ky CHECK ((((ky_thang >= 1) AND (ky_thang <= 12)) AND ((ky_nam >= 2000) AND (ky_nam <= 2100)))),
    CONSTRAINT chk_hoa_don_ngay CHECK (((den_ngay >= tu_ngay) AND (han_tra >= tu_ngay))),
    CONSTRAINT chk_hoa_don_tien CHECK (((tong_tien_phat_sinh >= (0)::numeric) AND (tong_tien >= (0)::numeric) AND (da_tra >= (0)::numeric)))
);


--
-- Name: hop_dong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hop_dong (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phong_id uuid NOT NULL,
    khach_thue_id uuid NOT NULL,
    ma_hop_dong character varying(100) NOT NULL,
    ngay_bat_dau date NOT NULL,
    ngay_ket_thuc date NOT NULL,
    ngay_ket_thuc_thuc_te date,
    gia_thue_hop_dong numeric(15,2) NOT NULL,
    tien_coc numeric(15,2) DEFAULT 0 NOT NULL,
    trang_thai_coc public.trang_thai_coc_hop_dong DEFAULT 'NOT_PAID'::public.trang_thai_coc_hop_dong NOT NULL,
    trang_thai public.trang_thai_hop_dong DEFAULT 'DRAFT'::public.trang_thai_hop_dong NOT NULL,
    chu_ky_thanh_toan character varying(30) DEFAULT 'MONTHLY'::character varying NOT NULL,
    ngay_thanh_toan_hang_thang integer DEFAULT 5 NOT NULL,
    tu_dong_gia_han boolean DEFAULT false NOT NULL,
    chi_so_dien_ban_dau integer,
    chi_so_nuoc_ban_dau integer,
    noi_dung_hop_dong text,
    file_pdf text,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    CONSTRAINT chk_hop_dong_chi_so CHECK ((((chi_so_dien_ban_dau IS NULL) OR (chi_so_dien_ban_dau >= 0)) AND ((chi_so_nuoc_ban_dau IS NULL) OR (chi_so_nuoc_ban_dau >= 0)))),
    CONSTRAINT chk_hop_dong_ngay CHECK ((ngay_ket_thuc > ngay_bat_dau)),
    CONSTRAINT chk_hop_dong_ngay_thanh_toan CHECK (((ngay_thanh_toan_hang_thang >= 1) AND (ngay_thanh_toan_hang_thang <= 31))),
    CONSTRAINT chk_hop_dong_tien CHECK (((gia_thue_hop_dong >= (0)::numeric) AND (tien_coc >= (0)::numeric)))
);


--
-- Name: khach_thue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.khach_thue (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid,
    chu_tro_id uuid NOT NULL,
    ho_ten character varying(255) NOT NULL,
    so_dien_thoai character varying(20),
    email character varying(255),
    so_cccd character varying(50),
    ngay_sinh date,
    gioi_tinh character varying(20),
    dia_chi text,
    que_quan character varying(255),
    nghe_nghiep character varying(255),
    ghi_chu text,
    dang_hoat_dong boolean DEFAULT true NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone
);


--
-- Name: lich_hen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lich_hen (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phong_id uuid NOT NULL,
    nguoi_dung_id uuid,
    ho_ten character varying(255),
    so_dien_thoai character varying(20),
    email character varying(255),
    ngay_hen timestamp with time zone NOT NULL,
    trang_thai public.trang_thai_lich_hen DEFAULT 'PENDING'::public.trang_thai_lich_hen NOT NULL,
    google_calendar_event_id text,
    da_gui_nhac_nho boolean DEFAULT false NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: lich_su_hoa_don; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lich_su_hoa_don (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hoa_don_id uuid NOT NULL,
    trang_thai_truoc public.trang_thai_hoa_don,
    trang_thai_moi public.trang_thai_hoa_don NOT NULL,
    nguoi_thay_doi_id uuid,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: login_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.login_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid,
    email character varying(255),
    thanh_cong boolean NOT NULL,
    ip_address inet,
    user_agent text,
    ly_do_that_bai text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: nguoi_dung; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nguoi_dung (
    id uuid NOT NULL,
    email character varying(255) NOT NULL,
    ho_ten character varying(255) NOT NULL,
    so_dien_thoai character varying(20),
    anh_dai_dien text,
    ngay_sinh date,
    gioi_tinh character varying(20),
    dia_chi text,
    que_quan character varying(255),
    so_cccd character varying(50),
    trang_thai public.trang_thai_nguoi_dung DEFAULT 'ACTIVE'::public.trang_thai_nguoi_dung NOT NULL,
    so_lan_dang_nhap_sai integer DEFAULT 0 NOT NULL,
    khoa_den_luc timestamp with time zone,
    lan_dang_nhap_cuoi timestamp with time zone,
    cau_hinh_2fa jsonb,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    mat_khau character varying(255),
    CONSTRAINT chk_nguoi_dung_email_lower CHECK (((email)::text = lower((email)::text))),
    CONSTRAINT chk_nguoi_dung_login_fail CHECK ((so_lan_dang_nhap_sai >= 0))
);


--
-- Name: nguoi_dung_nha_tro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nguoi_dung_nha_tro (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid NOT NULL,
    nha_tro_id uuid NOT NULL,
    vai_tro public.vai_tro_he_thong NOT NULL,
    co_quyen_xem boolean DEFAULT true NOT NULL,
    co_quyen_sua boolean DEFAULT false NOT NULL,
    co_quyen_thu_tien boolean DEFAULT false NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_ndnt_role CHECK ((vai_tro = ANY (ARRAY['LANDLORD'::public.vai_tro_he_thong, 'STAFF'::public.vai_tro_he_thong])))
);


--
-- Name: nguoi_dung_vai_tro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nguoi_dung_vai_tro (
    nguoi_dung_id uuid NOT NULL,
    vai_tro_id uuid NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: nha_tro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nha_tro (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    chu_tro_id uuid NOT NULL,
    ten character varying(255) NOT NULL,
    dia_chi text NOT NULL,
    so_nha character varying(100),
    duong character varying(255),
    phuong character varying(100),
    quan character varying(100),
    thanh_pho character varying(100),
    mo_ta text,
    tien_nghi_chung text,
    noi_quy text,
    trang_thai character varying(30) DEFAULT 'ACTIVE'::character varying NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone
);


--
-- Name: phong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phong (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nha_tro_id uuid NOT NULL,
    ten character varying(100) NOT NULL,
    khu_vuc character varying(50),
    tang integer,
    dien_tich numeric(10,2) NOT NULL,
    so_nguoi_toi_da integer DEFAULT 2 NOT NULL,
    trang_thai public.trang_thai_phong DEFAULT 'AVAILABLE'::public.trang_thai_phong NOT NULL,
    gia_hien_tai numeric(15,2) NOT NULL,
    tien_coc_mac_dinh numeric(15,2) DEFAULT 0 NOT NULL,
    mo_ta text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    CONSTRAINT chk_phong_dien_tich CHECK ((dien_tich > (0)::numeric)),
    CONSTRAINT chk_phong_gia CHECK (((gia_hien_tai >= (0)::numeric) AND (tien_coc_mac_dinh >= (0)::numeric))),
    CONSTRAINT chk_phong_so_nguoi CHECK ((so_nguoi_toi_da > 0))
);


--
-- Name: phong_tien_ich; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phong_tien_ich (
    phong_id uuid NOT NULL,
    tien_ich_id uuid NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: phu_luc_hop_dong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phu_luc_hop_dong (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hop_dong_id uuid NOT NULL,
    loai character varying(50) NOT NULL,
    noi_dung text NOT NULL,
    ngay_hieu_luc date NOT NULL,
    gia_thue_moi numeric(15,2),
    ngay_ket_thuc_moi date,
    file_pdf text,
    nguoi_tao_id uuid,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: refresh_token; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refresh_token (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid NOT NULL,
    token character varying(255) NOT NULL,
    ngay_het_han timestamp with time zone NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: su_co; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.su_co (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phong_id uuid NOT NULL,
    khach_thue_id uuid,
    nguoi_bao_id uuid,
    tieu_de character varying(255) NOT NULL,
    mo_ta text NOT NULL,
    loai_su_co public.loai_su_co_enum DEFAULT 'khac'::public.loai_su_co_enum NOT NULL,
    uu_tien public.uu_tien_enum DEFAULT 'trung_binh'::public.uu_tien_enum NOT NULL,
    trang_thai public.trang_thai_su_co DEFAULT 'PENDING'::public.trang_thai_su_co NOT NULL,
    nguoi_phu_trach_id uuid,
    chi_phi_sua_chua numeric(15,2) DEFAULT 0 NOT NULL,
    tinh_vao_hoa_don boolean DEFAULT false NOT NULL,
    ghi_chu_chu_nha text,
    giai_quyet_luc timestamp with time zone,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_su_co_chi_phi CHECK ((chi_phi_sua_chua >= (0)::numeric))
);


--
-- Name: thanh_toan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thanh_toan (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hoa_don_id uuid NOT NULL,
    khach_thue_id uuid,
    so_tien numeric(15,2) NOT NULL,
    ngay_thanh_toan timestamp with time zone DEFAULT now() NOT NULL,
    phuong_thuc_thanh_toan public.phuong_thuc_thanh_toan DEFAULT 'CASH'::public.phuong_thuc_thanh_toan NOT NULL,
    ma_tham_chieu character varying(150),
    external_transaction_id character varying(150),
    trang_thai public.trang_thai_thanh_toan DEFAULT 'SUCCESS'::public.trang_thai_thanh_toan NOT NULL,
    nguoi_thanh_toan_id uuid,
    nguoi_ghi_nhan_id uuid,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_thanh_toan_tien CHECK ((so_tien > (0)::numeric))
);


--
-- Name: thanh_vien_hop_dong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thanh_vien_hop_dong (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hop_dong_id uuid NOT NULL,
    khach_thue_id uuid,
    ho_ten character varying(255) NOT NULL,
    so_cccd character varying(50),
    so_dien_thoai character varying(20),
    ngay_vao date DEFAULT CURRENT_DATE NOT NULL,
    ngay_roi date,
    dang_o boolean DEFAULT true NOT NULL,
    la_nguoi_dai_dien boolean DEFAULT false NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_tvhd_ngay CHECK (((ngay_roi IS NULL) OR (ngay_roi >= ngay_vao)))
);


--
-- Name: thong_bao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thong_bao (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_gui_id uuid,
    loai public.loai_thong_bao DEFAULT 'SYSTEM'::public.loai_thong_bao NOT NULL,
    tieu_de character varying(255) NOT NULL,
    noi_dung text NOT NULL,
    doi_tuong public.loai_doi_tuong_media,
    doi_tuong_id uuid,
    kenh public.kenh_thong_bao DEFAULT 'IN_APP'::public.kenh_thong_bao NOT NULL,
    gui_tat_ca boolean DEFAULT false NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone
);


--
-- Name: thong_bao_nguoi_nhan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thong_bao_nguoi_nhan (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    thong_bao_id uuid NOT NULL,
    nguoi_dung_id uuid NOT NULL,
    da_doc boolean DEFAULT false NOT NULL,
    doc_luc timestamp with time zone,
    gui_luc timestamp with time zone,
    loi_gui text
);


--
-- Name: tien_ich; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tien_ich (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ten character varying(100) NOT NULL,
    bieu_tuong character varying(100),
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: vai_tro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vai_tro (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ten public.vai_tro_he_thong NOT NULL,
    mo_ta text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);




--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\N	00000000-0000-0000-0000-000000000001	\N	\N	admin@easyhouse.local	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-05-24 09:47:09.734324+00	2026-05-24 09:47:09.734324+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.audit_log (id, nguoi_dung_id, hanh_dong, bang_tac_dong, ban_ghi_id, du_lieu_cu, du_lieu_moi, ip_address, user_agent, tao_luc) FROM stdin;
\.


--
-- Data for Name: bank_transaction; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bank_transaction (id, nha_tro_id, hoa_don_id, so_tien, noi_dung_chuyen_khoan, ma_giao_dich, ngan_hang, thoi_gian_giao_dich, payload, da_doi_soat, tao_luc) FROM stdin;
\.


--
-- Data for Name: cau_hinh_gia; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cau_hinh_gia (id, nha_tro_id, dich_vu_id, loai, ten_hien_thi, loai_tinh_phi, don_gia, hieu_luc_tu, hieu_luc_den, dang_ap_dung, tao_luc, cap_nhat_luc) FROM stdin;
\.


--
-- Data for Name: chi_so_dien_nuoc; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chi_so_dien_nuoc (id, phong_id, hop_dong_id, loai, ky_nam, ky_thang, ngay_ghi, chi_so_cu, chi_so_moi, anh_dong_ho, nguoi_ghi_id, trang_thai, ghi_chu, tao_luc, cap_nhat_luc) FROM stdin;
\.


--
-- Data for Name: chi_tiet_hoa_don; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chi_tiet_hoa_don (id, hoa_don_id, dich_vu_id, chi_so_dien_nuoc_id, su_co_id, loai, mo_ta, so_luong, don_gia, thanh_tien, tao_luc) FROM stdin;
\.


--
-- Data for Name: chu_tro; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chu_tro (id, nguoi_dung_id, ten_cong_ty, so_cccd, ma_so_thue, so_tai_khoan, da_xac_minh, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
55555555-5555-5555-5555-555555555555	44444444-4444-4444-4444-444444444444	Nha Tro Binh Dan	012345678912	\N	\N	t	2026-05-03 17:13:44.013465+00	2026-05-03 17:13:44.013465+00	\N
\.


--
-- Data for Name: dat_coc_phong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dat_coc_phong (id, phong_id, khach_thue_id, hop_dong_id, so_tien_coc, ngay_dat_coc, ngay_du_kien_vao, trang_thai, ghi_chu, tao_luc, cap_nhat_luc) FROM stdin;
\.


--
-- Data for Name: dich_vu; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dich_vu (id, chu_tro_id, ten_dich_vu, loai_tinh_phi, don_vi, don_gia_mac_dinh, bat_buoc, tao_luc, cap_nhat_luc) FROM stdin;
\.


--
-- Data for Name: dich_vu_hop_dong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dich_vu_hop_dong (id, hop_dong_id, dich_vu_id, loai_tinh_phi, don_gia_ap_dung, so_luong, bat_dau_tu, ket_thuc_luc, tao_luc) FROM stdin;
\.


--
-- Data for Name: email_verification_token; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.email_verification_token (id, ngay_het_han, tao_luc, token, nguoi_dung_id) FROM stdin;
\.


--
-- Data for Name: file_media; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.file_media (id, doi_tuong, doi_tuong_id, url, public_id, loai_file, kich_thuoc_bytes, metadata, nguoi_tai_len_id, tao_luc) FROM stdin;
\.


--
-- Data for Name: hoa_don; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hoa_don (id, hop_dong_id, phong_id, khach_thue_id, ma_hoa_don, ky_nam, ky_thang, tu_ngay, den_ngay, so_du_dau_ky, tong_tien_phat_sinh, tong_tien, da_tra, trang_thai, han_tra, ngay_lap_hoa_don, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
\.


--
-- Data for Name: hop_dong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hop_dong (id, phong_id, khach_thue_id, ma_hop_dong, ngay_bat_dau, ngay_ket_thuc, ngay_ket_thuc_thuc_te, gia_thue_hop_dong, tien_coc, trang_thai_coc, trang_thai, chu_ky_thanh_toan, ngay_thanh_toan_hang_thang, tu_dong_gia_han, chi_so_dien_ban_dau, chi_so_nuoc_ban_dau, noi_dung_hop_dong, file_pdf, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
\.


--
-- Data for Name: khach_thue; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.khach_thue (id, nguoi_dung_id, chu_tro_id, ho_ten, so_dien_thoai, email, so_cccd, ngay_sinh, gioi_tinh, dia_chi, que_quan, nghe_nghiep, ghi_chu, dang_hoat_dong, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
\.


--
-- Data for Name: lich_hen; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lich_hen (id, phong_id, nguoi_dung_id, ho_ten, so_dien_thoai, email, ngay_hen, trang_thai, google_calendar_event_id, da_gui_nhac_nho, ghi_chu, tao_luc, cap_nhat_luc) FROM stdin;
\.


--
-- Data for Name: lich_su_hoa_don; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lich_su_hoa_don (id, hoa_don_id, trang_thai_truoc, trang_thai_moi, nguoi_thay_doi_id, ghi_chu, tao_luc) FROM stdin;
\.


--
-- Data for Name: login_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.login_history (id, nguoi_dung_id, email, thanh_cong, ip_address, user_agent, ly_do_that_bai, tao_luc) FROM stdin;
\.


--
-- Data for Name: nguoi_dung; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.nguoi_dung (id, email, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, dia_chi, que_quan, so_cccd, trang_thai, so_lan_dang_nhap_sai, khoa_den_luc, lan_dang_nhap_cuoi, cau_hinh_2fa, tao_luc, cap_nhat_luc, xoa_luc, mat_khau) FROM stdin;
00000000-0000-0000-0000-000000000001	admin@easyhouse.local	EasyHouse Admin	0900000000	\N	\N	\N	\N	\N	\N	ACTIVE	0	\N	2026-05-24 09:53:13.171357+00	\N	2026-05-24 09:47:09.734324+00	2026-05-24 09:53:13.109794+00	\N	$2a$10$9HgmP3LHXFShX6LXoCjinOy0E51QCxzfVmywozLxD/qSnD0u0bY1G
\.


--
-- Data for Name: nguoi_dung_nha_tro; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.nguoi_dung_nha_tro (id, nguoi_dung_id, nha_tro_id, vai_tro, co_quyen_xem, co_quyen_sua, co_quyen_thu_tien, tao_luc) FROM stdin;
\.


--
-- Data for Name: nguoi_dung_vai_tro; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id, tao_luc) FROM stdin;
00000000-0000-0000-0000-000000000001	64df4eeb-df51-468e-b2e1-911edc920d1a	2026-05-24 09:47:09.734324+00
\.


--
-- Data for Name: nha_tro; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.nha_tro (id, chu_tro_id, ten, dia_chi, so_nha, duong, phuong, quan, thanh_pho, mo_ta, tien_nghi_chung, noi_quy, trang_thai, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
\.


--
-- Data for Name: phong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.phong (id, nha_tro_id, ten, khu_vuc, tang, dien_tich, so_nguoi_toi_da, trang_thai, gia_hien_tai, tien_coc_mac_dinh, mo_ta, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
\.


--
-- Data for Name: phong_tien_ich; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.phong_tien_ich (phong_id, tien_ich_id, tao_luc) FROM stdin;
\.


--
-- Data for Name: phu_luc_hop_dong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.phu_luc_hop_dong (id, hop_dong_id, loai, noi_dung, ngay_hieu_luc, gia_thue_moi, ngay_ket_thuc_moi, file_pdf, nguoi_tao_id, tao_luc) FROM stdin;
\.


--
-- Data for Name: refresh_token; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.refresh_token (id, nguoi_dung_id, token, ngay_het_han, tao_luc) FROM stdin;
b3cbefd0-f3fd-42cb-85e4-85b850977a72	00000000-0000-0000-0000-000000000001	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAwMDAwMDEiLCJqdGkiOiI4ZTU3NmM2Ni1jMzg1LTQxNzEtYWY1Ni0wMDMzZjJlYWZkMTciLCJpYXQiOjE3Nzk2MTYzOTMsImV4cCI6MTc4MjIwODM5M30.BgR90nZIj5lYUoyOMknd5nl1JuyBEnjdGuxcs8V6eGbfrLf9vPNpyqYC8kT2pzok	2026-06-23 09:53:13.174+00	2026-05-24 09:53:13.174766+00
\.


--
-- Data for Name: su_co; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.su_co (id, phong_id, khach_thue_id, nguoi_bao_id, tieu_de, mo_ta, loai_su_co, uu_tien, trang_thai, nguoi_phu_trach_id, chi_phi_sua_chua, tinh_vao_hoa_don, ghi_chu_chu_nha, giai_quyet_luc, tao_luc, cap_nhat_luc) FROM stdin;
\.


--
-- Data for Name: thanh_toan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.thanh_toan (id, hoa_don_id, khach_thue_id, so_tien, ngay_thanh_toan, phuong_thuc_thanh_toan, ma_tham_chieu, external_transaction_id, trang_thai, nguoi_thanh_toan_id, nguoi_ghi_nhan_id, ghi_chu, tao_luc) FROM stdin;
\.


--
-- Data for Name: thanh_vien_hop_dong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.thanh_vien_hop_dong (id, hop_dong_id, khach_thue_id, ho_ten, so_cccd, so_dien_thoai, ngay_vao, ngay_roi, dang_o, la_nguoi_dai_dien, ghi_chu, tao_luc, cap_nhat_luc) FROM stdin;
\.


--
-- Data for Name: thong_bao; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.thong_bao (id, nguoi_gui_id, loai, tieu_de, noi_dung, doi_tuong, doi_tuong_id, kenh, gui_tat_ca, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
\.


--
-- Data for Name: thong_bao_nguoi_nhan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.thong_bao_nguoi_nhan (id, thong_bao_id, nguoi_dung_id, da_doc, doc_luc, gui_luc, loi_gui) FROM stdin;
\.


--
-- Data for Name: tien_ich; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tien_ich (id, ten, bieu_tuong, tao_luc) FROM stdin;
\.


--
-- Data for Name: vai_tro; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.vai_tro (id, ten, mo_ta, tao_luc) FROM stdin;
64df4eeb-df51-468e-b2e1-911edc920d1a	ADMIN	Quan tri he thong	2026-05-24 09:46:33.972804+00
40658ea7-6d3e-4bc2-8ed2-c1f40010d89e	LANDLORD	Chu tro	2026-05-24 09:46:33.972804+00
87418c2c-9142-4bc6-ae34-eabb13d46e6c	STAFF	Nhan vien quan ly	2026-05-24 09:46:33.972804+00
244d7f88-d499-4d6d-accd-46ab4665a622	TENANT	Nguoi thue	2026-05-24 09:46:33.972804+00
\.


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- Name: bank_transaction bank_transaction_ma_giao_dich_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_transaction
    ADD CONSTRAINT bank_transaction_ma_giao_dich_key UNIQUE (ma_giao_dich);


--
-- Name: bank_transaction bank_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_transaction
    ADD CONSTRAINT bank_transaction_pkey PRIMARY KEY (id);


--
-- Name: cau_hinh_gia cau_hinh_gia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cau_hinh_gia
    ADD CONSTRAINT cau_hinh_gia_pkey PRIMARY KEY (id);


--
-- Name: chi_so_dien_nuoc chi_so_dien_nuoc_phong_id_loai_ky_nam_ky_thang_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_so_dien_nuoc
    ADD CONSTRAINT chi_so_dien_nuoc_phong_id_loai_ky_nam_ky_thang_key UNIQUE (phong_id, loai, ky_nam, ky_thang);


--
-- Name: chi_so_dien_nuoc chi_so_dien_nuoc_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_so_dien_nuoc
    ADD CONSTRAINT chi_so_dien_nuoc_pkey PRIMARY KEY (id);


--
-- Name: chi_tiet_hoa_don chi_tiet_hoa_don_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_tiet_hoa_don
    ADD CONSTRAINT chi_tiet_hoa_don_pkey PRIMARY KEY (id);


--
-- Name: chu_tro chu_tro_nguoi_dung_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chu_tro
    ADD CONSTRAINT chu_tro_nguoi_dung_id_key UNIQUE (nguoi_dung_id);


--
-- Name: chu_tro chu_tro_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chu_tro
    ADD CONSTRAINT chu_tro_pkey PRIMARY KEY (id);


--
-- Name: chu_tro chu_tro_so_cccd_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chu_tro
    ADD CONSTRAINT chu_tro_so_cccd_key UNIQUE (so_cccd);


--
-- Name: dat_coc_phong dat_coc_phong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dat_coc_phong
    ADD CONSTRAINT dat_coc_phong_pkey PRIMARY KEY (id);


--
-- Name: dich_vu dich_vu_chu_tro_id_ten_dich_vu_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dich_vu
    ADD CONSTRAINT dich_vu_chu_tro_id_ten_dich_vu_key UNIQUE (chu_tro_id, ten_dich_vu);


--
-- Name: dich_vu_hop_dong dich_vu_hop_dong_hop_dong_id_dich_vu_id_bat_dau_tu_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dich_vu_hop_dong
    ADD CONSTRAINT dich_vu_hop_dong_hop_dong_id_dich_vu_id_bat_dau_tu_key UNIQUE (hop_dong_id, dich_vu_id, bat_dau_tu);


--
-- Name: dich_vu_hop_dong dich_vu_hop_dong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dich_vu_hop_dong
    ADD CONSTRAINT dich_vu_hop_dong_pkey PRIMARY KEY (id);


--
-- Name: dich_vu dich_vu_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dich_vu
    ADD CONSTRAINT dich_vu_pkey PRIMARY KEY (id);


--
-- Name: email_verification_token email_verification_token_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_verification_token
    ADD CONSTRAINT email_verification_token_pkey PRIMARY KEY (id);


--
-- Name: hop_dong excl_hop_dong_phong_active_overlap; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hop_dong
    ADD CONSTRAINT excl_hop_dong_phong_active_overlap EXCLUDE USING gist (phong_id WITH =, daterange(ngay_bat_dau, ngay_ket_thuc, '[]'::text) WITH &&) WHERE ((trang_thai = ANY (ARRAY['PENDING'::public.trang_thai_hop_dong, 'ACTIVE'::public.trang_thai_hop_dong])));


--
-- Name: file_media file_media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_media
    ADD CONSTRAINT file_media_pkey PRIMARY KEY (id);


--
-- Name: hoa_don hoa_don_hop_dong_id_ky_nam_ky_thang_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hoa_don
    ADD CONSTRAINT hoa_don_hop_dong_id_ky_nam_ky_thang_key UNIQUE (hop_dong_id, ky_nam, ky_thang);


--
-- Name: hoa_don hoa_don_ma_hoa_don_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hoa_don
    ADD CONSTRAINT hoa_don_ma_hoa_don_key UNIQUE (ma_hoa_don);


--
-- Name: hoa_don hoa_don_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hoa_don
    ADD CONSTRAINT hoa_don_pkey PRIMARY KEY (id);


--
-- Name: hop_dong hop_dong_ma_hop_dong_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hop_dong
    ADD CONSTRAINT hop_dong_ma_hop_dong_key UNIQUE (ma_hop_dong);


--
-- Name: hop_dong hop_dong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hop_dong
    ADD CONSTRAINT hop_dong_pkey PRIMARY KEY (id);


--
-- Name: khach_thue khach_thue_chu_tro_id_so_cccd_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.khach_thue
    ADD CONSTRAINT khach_thue_chu_tro_id_so_cccd_key UNIQUE (chu_tro_id, so_cccd);


--
-- Name: khach_thue khach_thue_nguoi_dung_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.khach_thue
    ADD CONSTRAINT khach_thue_nguoi_dung_id_key UNIQUE (nguoi_dung_id);


--
-- Name: khach_thue khach_thue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.khach_thue
    ADD CONSTRAINT khach_thue_pkey PRIMARY KEY (id);


--
-- Name: lich_hen lich_hen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_hen
    ADD CONSTRAINT lich_hen_pkey PRIMARY KEY (id);


--
-- Name: lich_su_hoa_don lich_su_hoa_don_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_hoa_don
    ADD CONSTRAINT lich_su_hoa_don_pkey PRIMARY KEY (id);


--
-- Name: login_history login_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_pkey PRIMARY KEY (id);


--
-- Name: nguoi_dung nguoi_dung_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung
    ADD CONSTRAINT nguoi_dung_email_key UNIQUE (email);


--
-- Name: nguoi_dung_nha_tro nguoi_dung_nha_tro_nguoi_dung_id_nha_tro_id_vai_tro_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung_nha_tro
    ADD CONSTRAINT nguoi_dung_nha_tro_nguoi_dung_id_nha_tro_id_vai_tro_key UNIQUE (nguoi_dung_id, nha_tro_id, vai_tro);


--
-- Name: nguoi_dung_nha_tro nguoi_dung_nha_tro_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung_nha_tro
    ADD CONSTRAINT nguoi_dung_nha_tro_pkey PRIMARY KEY (id);


--
-- Name: nguoi_dung nguoi_dung_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung
    ADD CONSTRAINT nguoi_dung_pkey PRIMARY KEY (id);


--
-- Name: nguoi_dung nguoi_dung_so_cccd_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung
    ADD CONSTRAINT nguoi_dung_so_cccd_key UNIQUE (so_cccd);


--
-- Name: nguoi_dung nguoi_dung_so_dien_thoai_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung
    ADD CONSTRAINT nguoi_dung_so_dien_thoai_key UNIQUE (so_dien_thoai);


--
-- Name: nguoi_dung_vai_tro nguoi_dung_vai_tro_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung_vai_tro
    ADD CONSTRAINT nguoi_dung_vai_tro_pkey PRIMARY KEY (nguoi_dung_id, vai_tro_id);


--
-- Name: nha_tro nha_tro_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nha_tro
    ADD CONSTRAINT nha_tro_pkey PRIMARY KEY (id);


--
-- Name: phong phong_nha_tro_id_ten_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phong
    ADD CONSTRAINT phong_nha_tro_id_ten_key UNIQUE (nha_tro_id, ten);


--
-- Name: phong phong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phong
    ADD CONSTRAINT phong_pkey PRIMARY KEY (id);


--
-- Name: phong_tien_ich phong_tien_ich_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phong_tien_ich
    ADD CONSTRAINT phong_tien_ich_pkey PRIMARY KEY (phong_id, tien_ich_id);


--
-- Name: phu_luc_hop_dong phu_luc_hop_dong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phu_luc_hop_dong
    ADD CONSTRAINT phu_luc_hop_dong_pkey PRIMARY KEY (id);


--
-- Name: refresh_token refresh_token_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_token
    ADD CONSTRAINT refresh_token_pkey PRIMARY KEY (id);


--
-- Name: refresh_token refresh_token_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_token
    ADD CONSTRAINT refresh_token_token_key UNIQUE (token);


--
-- Name: su_co su_co_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.su_co
    ADD CONSTRAINT su_co_pkey PRIMARY KEY (id);


--
-- Name: thanh_toan thanh_toan_external_transaction_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_toan
    ADD CONSTRAINT thanh_toan_external_transaction_id_key UNIQUE (external_transaction_id);


--
-- Name: thanh_toan thanh_toan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_toan
    ADD CONSTRAINT thanh_toan_pkey PRIMARY KEY (id);


--
-- Name: thanh_vien_hop_dong thanh_vien_hop_dong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_vien_hop_dong
    ADD CONSTRAINT thanh_vien_hop_dong_pkey PRIMARY KEY (id);


--
-- Name: thong_bao_nguoi_nhan thong_bao_nguoi_nhan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thong_bao_nguoi_nhan
    ADD CONSTRAINT thong_bao_nguoi_nhan_pkey PRIMARY KEY (id);


--
-- Name: thong_bao_nguoi_nhan thong_bao_nguoi_nhan_thong_bao_id_nguoi_dung_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thong_bao_nguoi_nhan
    ADD CONSTRAINT thong_bao_nguoi_nhan_thong_bao_id_nguoi_dung_id_key UNIQUE (thong_bao_id, nguoi_dung_id);


--
-- Name: thong_bao thong_bao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thong_bao
    ADD CONSTRAINT thong_bao_pkey PRIMARY KEY (id);


--
-- Name: tien_ich tien_ich_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tien_ich
    ADD CONSTRAINT tien_ich_pkey PRIMARY KEY (id);


--
-- Name: tien_ich tien_ich_ten_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tien_ich
    ADD CONSTRAINT tien_ich_ten_key UNIQUE (ten);


--
-- Name: vai_tro vai_tro_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vai_tro
    ADD CONSTRAINT vai_tro_pkey PRIMARY KEY (id);


--
-- Name: vai_tro vai_tro_ten_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vai_tro
    ADD CONSTRAINT vai_tro_ten_key UNIQUE (ten);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: idx_users_created_at_desc; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_users_created_at_desc ON auth.users USING btree (created_at DESC);


--
-- Name: idx_users_email; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_users_email ON auth.users USING btree (email);


--
-- Name: idx_users_last_sign_in_at_desc; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_users_last_sign_in_at_desc ON auth.users USING btree (last_sign_in_at DESC);


--
-- Name: idx_users_name; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_users_name ON auth.users USING btree (((raw_user_meta_data ->> 'name'::text))) WHERE ((raw_user_meta_data ->> 'name'::text) IS NOT NULL);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- Name: idx_audit_log_target; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_log_target ON public.audit_log USING btree (bang_tac_dong, ban_ghi_id);


--
-- Name: idx_cau_hinh_gia_nha_tro; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cau_hinh_gia_nha_tro ON public.cau_hinh_gia USING btree (nha_tro_id, loai, dang_ap_dung);


--
-- Name: idx_chi_so_phong_ky; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chi_so_phong_ky ON public.chi_so_dien_nuoc USING btree (phong_id, loai, ky_nam, ky_thang);


--
-- Name: idx_cthd_hoa_don; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cthd_hoa_don ON public.chi_tiet_hoa_don USING btree (hoa_don_id);


--
-- Name: idx_dat_coc_phong; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dat_coc_phong ON public.dat_coc_phong USING btree (phong_id, trang_thai);


--
-- Name: idx_dvhd_hop_dong; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dvhd_hop_dong ON public.dich_vu_hop_dong USING btree (hop_dong_id);


--
-- Name: idx_file_media_target; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_file_media_target ON public.file_media USING btree (doi_tuong, doi_tuong_id);


--
-- Name: idx_hoa_don_hop_dong_ky; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hoa_don_hop_dong_ky ON public.hoa_don USING btree (hop_dong_id, ky_nam, ky_thang);


--
-- Name: idx_hoa_don_khach_thue; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hoa_don_khach_thue ON public.hoa_don USING btree (khach_thue_id);


--
-- Name: idx_hoa_don_phong; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hoa_don_phong ON public.hoa_don USING btree (phong_id);


--
-- Name: idx_hoa_don_status_due; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hoa_don_status_due ON public.hoa_don USING btree (trang_thai, han_tra);


--
-- Name: idx_hop_dong_khach_thue; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hop_dong_khach_thue ON public.hop_dong USING btree (khach_thue_id);


--
-- Name: idx_hop_dong_phong_status_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hop_dong_phong_status_dates ON public.hop_dong USING btree (phong_id, trang_thai, ngay_bat_dau, ngay_ket_thuc);


--
-- Name: idx_khach_thue_chu_tro; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_khach_thue_chu_tro ON public.khach_thue USING btree (chu_tro_id);


--
-- Name: idx_khach_thue_sdt; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_khach_thue_sdt ON public.khach_thue USING btree (so_dien_thoai);


--
-- Name: idx_lich_hen_phong_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lich_hen_phong_time ON public.lich_hen USING btree (phong_id, ngay_hen);


--
-- Name: idx_login_history_user_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_login_history_user_time ON public.login_history USING btree (nguoi_dung_id, tao_luc DESC);


--
-- Name: idx_ndnt_nha_tro_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ndnt_nha_tro_user ON public.nguoi_dung_nha_tro USING btree (nha_tro_id, nguoi_dung_id);


--
-- Name: idx_nguoi_dung_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nguoi_dung_email ON public.nguoi_dung USING btree (email);


--
-- Name: idx_nguoi_dung_trang_thai; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nguoi_dung_trang_thai ON public.nguoi_dung USING btree (trang_thai);


--
-- Name: idx_nha_tro_chu_tro; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nha_tro_chu_tro ON public.nha_tro USING btree (chu_tro_id);


--
-- Name: idx_phong_nha_tro; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_phong_nha_tro ON public.phong USING btree (nha_tro_id);


--
-- Name: idx_phong_trang_thai; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_phong_trang_thai ON public.phong USING btree (trang_thai);


--
-- Name: idx_refresh_token_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_refresh_token_user ON public.refresh_token USING btree (nguoi_dung_id);


--
-- Name: idx_su_co_phong_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_su_co_phong_status ON public.su_co USING btree (phong_id, trang_thai);


--
-- Name: idx_thanh_toan_hoa_don; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_thanh_toan_hoa_don ON public.thanh_toan USING btree (hoa_don_id);


--
-- Name: idx_thanh_toan_ref; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_thanh_toan_ref ON public.thanh_toan USING btree (ma_tham_chieu);


--
-- Name: idx_thong_bao_recipient; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_thong_bao_recipient ON public.thong_bao_nguoi_nhan USING btree (nguoi_dung_id, da_doc);


--
-- Name: idx_tvhd_hop_dong; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tvhd_hop_dong ON public.thanh_vien_hop_dong USING btree (hop_dong_id);


--
-- Name: cau_hinh_gia trg_cau_hinh_gia_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_cau_hinh_gia_cap_nhat BEFORE UPDATE ON public.cau_hinh_gia FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: chi_so_dien_nuoc trg_chi_so_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_chi_so_cap_nhat BEFORE UPDATE ON public.chi_so_dien_nuoc FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: chu_tro trg_chu_tro_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_chu_tro_cap_nhat BEFORE UPDATE ON public.chu_tro FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: chi_tiet_hoa_don trg_cthd_recalc; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_cthd_recalc AFTER INSERT OR DELETE OR UPDATE ON public.chi_tiet_hoa_don FOR EACH ROW EXECUTE FUNCTION public.recalc_hoa_don_from_chi_tiet();


--
-- Name: dich_vu trg_dich_vu_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_dich_vu_cap_nhat BEFORE UPDATE ON public.dich_vu FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: hoa_don trg_hoa_don_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_hoa_don_cap_nhat BEFORE UPDATE ON public.hoa_don FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: hoa_don trg_hoa_don_status; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_hoa_don_status BEFORE INSERT OR UPDATE OF tong_tien, da_tra, han_tra, trang_thai ON public.hoa_don FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_trang_thai_hoa_don();


--
-- Name: hop_dong trg_hop_dong_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_hop_dong_cap_nhat BEFORE UPDATE ON public.hop_dong FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: khach_thue trg_khach_thue_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_khach_thue_cap_nhat BEFORE UPDATE ON public.khach_thue FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: lich_hen trg_lich_hen_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_lich_hen_cap_nhat BEFORE UPDATE ON public.lich_hen FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: nguoi_dung trg_nguoi_dung_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_nguoi_dung_cap_nhat BEFORE UPDATE ON public.nguoi_dung FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: nha_tro trg_nha_tro_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_nha_tro_cap_nhat BEFORE UPDATE ON public.nha_tro FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: phong trg_phong_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_phong_cap_nhat BEFORE UPDATE ON public.phong FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: su_co trg_su_co_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_su_co_cap_nhat BEFORE UPDATE ON public.su_co FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: thanh_toan trg_thanh_toan_recalc; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_thanh_toan_recalc AFTER INSERT OR DELETE OR UPDATE ON public.thanh_toan FOR EACH ROW EXECUTE FUNCTION public.recalc_hoa_don_from_thanh_toan();


--
-- Name: thanh_vien_hop_dong trg_thanh_vien_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_thanh_vien_cap_nhat BEFORE UPDATE ON public.thanh_vien_hop_dong FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: thong_bao trg_thong_bao_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_thong_bao_cap_nhat BEFORE UPDATE ON public.thong_bao FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: audit_log audit_log_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: bank_transaction bank_transaction_hoa_don_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_transaction
    ADD CONSTRAINT bank_transaction_hoa_don_id_fkey FOREIGN KEY (hoa_don_id) REFERENCES public.hoa_don(id) ON DELETE SET NULL;


--
-- Name: bank_transaction bank_transaction_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_transaction
    ADD CONSTRAINT bank_transaction_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE SET NULL;


--
-- Name: cau_hinh_gia cau_hinh_gia_dich_vu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cau_hinh_gia
    ADD CONSTRAINT cau_hinh_gia_dich_vu_id_fkey FOREIGN KEY (dich_vu_id) REFERENCES public.dich_vu(id) ON DELETE SET NULL;


--
-- Name: cau_hinh_gia cau_hinh_gia_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cau_hinh_gia
    ADD CONSTRAINT cau_hinh_gia_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE CASCADE;


--
-- Name: chi_so_dien_nuoc chi_so_dien_nuoc_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_so_dien_nuoc
    ADD CONSTRAINT chi_so_dien_nuoc_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE SET NULL;


--
-- Name: chi_so_dien_nuoc chi_so_dien_nuoc_nguoi_ghi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_so_dien_nuoc
    ADD CONSTRAINT chi_so_dien_nuoc_nguoi_ghi_id_fkey FOREIGN KEY (nguoi_ghi_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: chi_so_dien_nuoc chi_so_dien_nuoc_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_so_dien_nuoc
    ADD CONSTRAINT chi_so_dien_nuoc_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE CASCADE;


--
-- Name: chi_tiet_hoa_don chi_tiet_hoa_don_chi_so_dien_nuoc_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_tiet_hoa_don
    ADD CONSTRAINT chi_tiet_hoa_don_chi_so_dien_nuoc_id_fkey FOREIGN KEY (chi_so_dien_nuoc_id) REFERENCES public.chi_so_dien_nuoc(id) ON DELETE SET NULL;


--
-- Name: chi_tiet_hoa_don chi_tiet_hoa_don_dich_vu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_tiet_hoa_don
    ADD CONSTRAINT chi_tiet_hoa_don_dich_vu_id_fkey FOREIGN KEY (dich_vu_id) REFERENCES public.dich_vu(id) ON DELETE SET NULL;


--
-- Name: chi_tiet_hoa_don chi_tiet_hoa_don_hoa_don_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_tiet_hoa_don
    ADD CONSTRAINT chi_tiet_hoa_don_hoa_don_id_fkey FOREIGN KEY (hoa_don_id) REFERENCES public.hoa_don(id) ON DELETE CASCADE;


--
-- Name: dat_coc_phong dat_coc_phong_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dat_coc_phong
    ADD CONSTRAINT dat_coc_phong_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE SET NULL;


--
-- Name: dat_coc_phong dat_coc_phong_khach_thue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dat_coc_phong
    ADD CONSTRAINT dat_coc_phong_khach_thue_id_fkey FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id) ON DELETE RESTRICT;


--
-- Name: dat_coc_phong dat_coc_phong_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dat_coc_phong
    ADD CONSTRAINT dat_coc_phong_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE RESTRICT;


--
-- Name: dich_vu dich_vu_chu_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dich_vu
    ADD CONSTRAINT dich_vu_chu_tro_id_fkey FOREIGN KEY (chu_tro_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: dich_vu_hop_dong dich_vu_hop_dong_dich_vu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dich_vu_hop_dong
    ADD CONSTRAINT dich_vu_hop_dong_dich_vu_id_fkey FOREIGN KEY (dich_vu_id) REFERENCES public.dich_vu(id) ON DELETE RESTRICT;


--
-- Name: dich_vu_hop_dong dich_vu_hop_dong_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dich_vu_hop_dong
    ADD CONSTRAINT dich_vu_hop_dong_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE CASCADE;


--
-- Name: file_media file_media_nguoi_tai_len_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_media
    ADD CONSTRAINT file_media_nguoi_tai_len_id_fkey FOREIGN KEY (nguoi_tai_len_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: chi_tiet_hoa_don fk_cthd_su_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_tiet_hoa_don
    ADD CONSTRAINT fk_cthd_su_co FOREIGN KEY (su_co_id) REFERENCES public.su_co(id) ON DELETE SET NULL;


--
-- Name: hoa_don hoa_don_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hoa_don
    ADD CONSTRAINT hoa_don_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE RESTRICT;


--
-- Name: hoa_don hoa_don_khach_thue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hoa_don
    ADD CONSTRAINT hoa_don_khach_thue_id_fkey FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id) ON DELETE RESTRICT;


--
-- Name: hoa_don hoa_don_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hoa_don
    ADD CONSTRAINT hoa_don_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE RESTRICT;


--
-- Name: hop_dong hop_dong_khach_thue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hop_dong
    ADD CONSTRAINT hop_dong_khach_thue_id_fkey FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id) ON DELETE RESTRICT;


--
-- Name: hop_dong hop_dong_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hop_dong
    ADD CONSTRAINT hop_dong_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE RESTRICT;


--
-- Name: khach_thue khach_thue_chu_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.khach_thue
    ADD CONSTRAINT khach_thue_chu_tro_id_fkey FOREIGN KEY (chu_tro_id) REFERENCES public.nguoi_dung(id) ON DELETE RESTRICT;


--
-- Name: khach_thue khach_thue_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.khach_thue
    ADD CONSTRAINT khach_thue_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: lich_hen lich_hen_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_hen
    ADD CONSTRAINT lich_hen_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: lich_hen lich_hen_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_hen
    ADD CONSTRAINT lich_hen_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE CASCADE;


--
-- Name: lich_su_hoa_don lich_su_hoa_don_hoa_don_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_hoa_don
    ADD CONSTRAINT lich_su_hoa_don_hoa_don_id_fkey FOREIGN KEY (hoa_don_id) REFERENCES public.hoa_don(id) ON DELETE CASCADE;


--
-- Name: lich_su_hoa_don lich_su_hoa_don_nguoi_thay_doi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_hoa_don
    ADD CONSTRAINT lich_su_hoa_don_nguoi_thay_doi_id_fkey FOREIGN KEY (nguoi_thay_doi_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: login_history login_history_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: nguoi_dung nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--




--
-- Name: nguoi_dung_nha_tro nguoi_dung_nha_tro_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung_nha_tro
    ADD CONSTRAINT nguoi_dung_nha_tro_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: nguoi_dung_nha_tro nguoi_dung_nha_tro_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung_nha_tro
    ADD CONSTRAINT nguoi_dung_nha_tro_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE CASCADE;


--
-- Name: nguoi_dung_vai_tro nguoi_dung_vai_tro_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung_vai_tro
    ADD CONSTRAINT nguoi_dung_vai_tro_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: nguoi_dung_vai_tro nguoi_dung_vai_tro_vai_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung_vai_tro
    ADD CONSTRAINT nguoi_dung_vai_tro_vai_tro_id_fkey FOREIGN KEY (vai_tro_id) REFERENCES public.vai_tro(id) ON DELETE CASCADE;


--
-- Name: nha_tro nha_tro_chu_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nha_tro
    ADD CONSTRAINT nha_tro_chu_tro_id_fkey FOREIGN KEY (chu_tro_id) REFERENCES public.nguoi_dung(id) ON DELETE RESTRICT;


--
-- Name: phong phong_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phong
    ADD CONSTRAINT phong_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE CASCADE;


--
-- Name: phong_tien_ich phong_tien_ich_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phong_tien_ich
    ADD CONSTRAINT phong_tien_ich_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE CASCADE;


--
-- Name: phong_tien_ich phong_tien_ich_tien_ich_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phong_tien_ich
    ADD CONSTRAINT phong_tien_ich_tien_ich_id_fkey FOREIGN KEY (tien_ich_id) REFERENCES public.tien_ich(id) ON DELETE CASCADE;


--
-- Name: phu_luc_hop_dong phu_luc_hop_dong_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phu_luc_hop_dong
    ADD CONSTRAINT phu_luc_hop_dong_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE CASCADE;


--
-- Name: phu_luc_hop_dong phu_luc_hop_dong_nguoi_tao_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phu_luc_hop_dong
    ADD CONSTRAINT phu_luc_hop_dong_nguoi_tao_id_fkey FOREIGN KEY (nguoi_tao_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: refresh_token refresh_token_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_token
    ADD CONSTRAINT refresh_token_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: su_co su_co_khach_thue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.su_co
    ADD CONSTRAINT su_co_khach_thue_id_fkey FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id) ON DELETE SET NULL;


--
-- Name: su_co su_co_nguoi_bao_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.su_co
    ADD CONSTRAINT su_co_nguoi_bao_id_fkey FOREIGN KEY (nguoi_bao_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: su_co su_co_nguoi_phu_trach_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.su_co
    ADD CONSTRAINT su_co_nguoi_phu_trach_id_fkey FOREIGN KEY (nguoi_phu_trach_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: su_co su_co_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.su_co
    ADD CONSTRAINT su_co_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE CASCADE;


--
-- Name: thanh_toan thanh_toan_hoa_don_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_toan
    ADD CONSTRAINT thanh_toan_hoa_don_id_fkey FOREIGN KEY (hoa_don_id) REFERENCES public.hoa_don(id) ON DELETE RESTRICT;


--
-- Name: thanh_toan thanh_toan_khach_thue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_toan
    ADD CONSTRAINT thanh_toan_khach_thue_id_fkey FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id) ON DELETE SET NULL;


--
-- Name: thanh_toan thanh_toan_nguoi_ghi_nhan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_toan
    ADD CONSTRAINT thanh_toan_nguoi_ghi_nhan_id_fkey FOREIGN KEY (nguoi_ghi_nhan_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: thanh_toan thanh_toan_nguoi_thanh_toan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_toan
    ADD CONSTRAINT thanh_toan_nguoi_thanh_toan_id_fkey FOREIGN KEY (nguoi_thanh_toan_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: thanh_vien_hop_dong thanh_vien_hop_dong_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_vien_hop_dong
    ADD CONSTRAINT thanh_vien_hop_dong_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE CASCADE;


--
-- Name: thanh_vien_hop_dong thanh_vien_hop_dong_khach_thue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_vien_hop_dong
    ADD CONSTRAINT thanh_vien_hop_dong_khach_thue_id_fkey FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id) ON DELETE SET NULL;


--
-- Name: thong_bao thong_bao_nguoi_gui_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thong_bao
    ADD CONSTRAINT thong_bao_nguoi_gui_id_fkey FOREIGN KEY (nguoi_gui_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: thong_bao_nguoi_nhan thong_bao_nguoi_nhan_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thong_bao_nguoi_nhan
    ADD CONSTRAINT thong_bao_nguoi_nhan_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: thong_bao_nguoi_nhan thong_bao_nguoi_nhan_thong_bao_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thong_bao_nguoi_nhan
    ADD CONSTRAINT thong_bao_nguoi_nhan_thong_bao_id_fkey FOREIGN KEY (thong_bao_id) REFERENCES public.thong_bao(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: audit_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

--
-- Name: audit_log audit_log_admin_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY audit_log_admin_read ON public.audit_log FOR SELECT USING (public.is_admin());


--
-- Name: bank_transaction; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.bank_transaction ENABLE ROW LEVEL SECURITY;

--
-- Name: bank_transaction bank_transaction_by_nha_tro; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY bank_transaction_by_nha_tro ON public.bank_transaction USING (((nha_tro_id IS NOT NULL) AND public.can_access_nha_tro(nha_tro_id))) WITH CHECK (((nha_tro_id IS NOT NULL) AND public.can_access_nha_tro(nha_tro_id)));


--
-- Name: cau_hinh_gia; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.cau_hinh_gia ENABLE ROW LEVEL SECURITY;

--
-- Name: cau_hinh_gia cau_hinh_gia_by_nha_tro; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY cau_hinh_gia_by_nha_tro ON public.cau_hinh_gia USING (public.can_access_nha_tro(nha_tro_id)) WITH CHECK (public.can_access_nha_tro(nha_tro_id));


--
-- Name: chi_so_dien_nuoc chi_so_by_room; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY chi_so_by_room ON public.chi_so_dien_nuoc USING ((EXISTS ( SELECT 1
   FROM public.phong p
  WHERE ((p.id = chi_so_dien_nuoc.phong_id) AND public.can_access_nha_tro(p.nha_tro_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.phong p
  WHERE ((p.id = chi_so_dien_nuoc.phong_id) AND public.can_access_nha_tro(p.nha_tro_id)))));


--
-- Name: chi_so_dien_nuoc; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.chi_so_dien_nuoc ENABLE ROW LEVEL SECURITY;

--
-- Name: chi_tiet_hoa_don; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.chi_tiet_hoa_don ENABLE ROW LEVEL SECURITY;

--
-- Name: chi_tiet_hoa_don chi_tiet_hoa_don_by_invoice; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY chi_tiet_hoa_don_by_invoice ON public.chi_tiet_hoa_don USING ((EXISTS ( SELECT 1
   FROM public.hoa_don hd
  WHERE ((hd.id = chi_tiet_hoa_don.hoa_don_id) AND ((EXISTS ( SELECT 1
           FROM public.phong p
          WHERE ((p.id = hd.phong_id) AND public.can_access_nha_tro(p.nha_tro_id)))) OR (EXISTS ( SELECT 1
           FROM public.khach_thue kt
          WHERE ((kt.id = hd.khach_thue_id) AND (kt.nguoi_dung_id = auth.uid()))))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.hoa_don hd
     JOIN public.phong p ON ((p.id = hd.phong_id)))
  WHERE ((hd.id = chi_tiet_hoa_don.hoa_don_id) AND public.can_access_nha_tro(p.nha_tro_id)))));


--
-- Name: chu_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.chu_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: dat_coc_phong dat_coc_by_room; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY dat_coc_by_room ON public.dat_coc_phong USING ((EXISTS ( SELECT 1
   FROM public.phong p
  WHERE ((p.id = dat_coc_phong.phong_id) AND public.can_access_nha_tro(p.nha_tro_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.phong p
  WHERE ((p.id = dat_coc_phong.phong_id) AND public.can_access_nha_tro(p.nha_tro_id)))));


--
-- Name: dat_coc_phong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.dat_coc_phong ENABLE ROW LEVEL SECURITY;

--
-- Name: dich_vu; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.dich_vu ENABLE ROW LEVEL SECURITY;

--
-- Name: dich_vu_hop_dong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.dich_vu_hop_dong ENABLE ROW LEVEL SECURITY;

--
-- Name: dich_vu_hop_dong dich_vu_hop_dong_by_contract; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY dich_vu_hop_dong_by_contract ON public.dich_vu_hop_dong USING ((EXISTS ( SELECT 1
   FROM (public.hop_dong hd
     JOIN public.phong p ON ((p.id = hd.phong_id)))
  WHERE ((hd.id = dich_vu_hop_dong.hop_dong_id) AND public.can_access_nha_tro(p.nha_tro_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.hop_dong hd
     JOIN public.phong p ON ((p.id = hd.phong_id)))
  WHERE ((hd.id = dich_vu_hop_dong.hop_dong_id) AND public.can_access_nha_tro(p.nha_tro_id)))));


--
-- Name: dich_vu dich_vu_owner; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY dich_vu_owner ON public.dich_vu USING (((chu_tro_id = auth.uid()) OR public.is_admin())) WITH CHECK (((chu_tro_id = auth.uid()) OR public.is_admin()));


--
-- Name: file_media; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.file_media ENABLE ROW LEVEL SECURITY;

--
-- Name: file_media file_media_uploader_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY file_media_uploader_admin ON public.file_media USING (((nguoi_tai_len_id = auth.uid()) OR public.is_admin())) WITH CHECK (((nguoi_tai_len_id = auth.uid()) OR public.is_admin()));


--
-- Name: hoa_don; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hoa_don ENABLE ROW LEVEL SECURITY;

--
-- Name: hoa_don hoa_don_by_room_or_tenant; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY hoa_don_by_room_or_tenant ON public.hoa_don USING (((EXISTS ( SELECT 1
   FROM public.phong p
  WHERE ((p.id = hoa_don.phong_id) AND public.can_access_nha_tro(p.nha_tro_id)))) OR (EXISTS ( SELECT 1
   FROM public.khach_thue kt
  WHERE ((kt.id = hoa_don.khach_thue_id) AND (kt.nguoi_dung_id = auth.uid())))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.phong p
  WHERE ((p.id = hoa_don.phong_id) AND public.can_access_nha_tro(p.nha_tro_id)))));


--
-- Name: hop_dong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hop_dong ENABLE ROW LEVEL SECURITY;

--
-- Name: hop_dong hop_dong_by_room_or_tenant; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY hop_dong_by_room_or_tenant ON public.hop_dong USING (((EXISTS ( SELECT 1
   FROM public.phong p
  WHERE ((p.id = hop_dong.phong_id) AND public.can_access_nha_tro(p.nha_tro_id)))) OR (EXISTS ( SELECT 1
   FROM public.khach_thue kt
  WHERE ((kt.id = hop_dong.khach_thue_id) AND (kt.nguoi_dung_id = auth.uid())))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.phong p
  WHERE ((p.id = hop_dong.phong_id) AND public.can_access_nha_tro(p.nha_tro_id)))));


--
-- Name: khach_thue; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.khach_thue ENABLE ROW LEVEL SECURITY;

--
-- Name: khach_thue khach_thue_owner_or_self; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY khach_thue_owner_or_self ON public.khach_thue USING ((public.is_admin() OR (chu_tro_id = auth.uid()) OR (nguoi_dung_id = auth.uid()))) WITH CHECK ((public.is_admin() OR (chu_tro_id = auth.uid()) OR (nguoi_dung_id = auth.uid())));


--
-- Name: lich_hen; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lich_hen ENABLE ROW LEVEL SECURITY;

--
-- Name: lich_hen lich_hen_by_room_or_user; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY lich_hen_by_room_or_user ON public.lich_hen USING (((nguoi_dung_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.phong p
  WHERE ((p.id = lich_hen.phong_id) AND public.can_access_nha_tro(p.nha_tro_id)))))) WITH CHECK (((nguoi_dung_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.phong p
  WHERE ((p.id = lich_hen.phong_id) AND public.can_access_nha_tro(p.nha_tro_id))))));


--
-- Name: lich_su_hoa_don; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lich_su_hoa_don ENABLE ROW LEVEL SECURITY;

--
-- Name: lich_su_hoa_don lich_su_hoa_don_by_invoice; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY lich_su_hoa_don_by_invoice ON public.lich_su_hoa_don FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.hoa_don hd
  WHERE ((hd.id = lich_su_hoa_don.hoa_don_id) AND ((EXISTS ( SELECT 1
           FROM public.phong p
          WHERE ((p.id = hd.phong_id) AND public.can_access_nha_tro(p.nha_tro_id)))) OR (EXISTS ( SELECT 1
           FROM public.khach_thue kt
          WHERE ((kt.id = hd.khach_thue_id) AND (kt.nguoi_dung_id = auth.uid())))))))));


--
-- Name: login_history; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.login_history ENABLE ROW LEVEL SECURITY;

--
-- Name: login_history login_history_self_or_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY login_history_self_or_admin ON public.login_history FOR SELECT USING (((nguoi_dung_id = auth.uid()) OR public.is_admin()));


--
-- Name: nguoi_dung; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nguoi_dung ENABLE ROW LEVEL SECURITY;

--
-- Name: nguoi_dung_nha_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nguoi_dung_nha_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: nguoi_dung_nha_tro nguoi_dung_nha_tro_owner_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY nguoi_dung_nha_tro_owner_admin ON public.nguoi_dung_nha_tro USING ((public.is_admin() OR (EXISTS ( SELECT 1
   FROM public.nha_tro nt
  WHERE ((nt.id = nguoi_dung_nha_tro.nha_tro_id) AND (nt.chu_tro_id = auth.uid())))))) WITH CHECK ((public.is_admin() OR (EXISTS ( SELECT 1
   FROM public.nha_tro nt
  WHERE ((nt.id = nguoi_dung_nha_tro.nha_tro_id) AND (nt.chu_tro_id = auth.uid()))))));


--
-- Name: nguoi_dung nguoi_dung_self_or_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY nguoi_dung_self_or_admin ON public.nguoi_dung USING (((id = auth.uid()) OR public.is_admin())) WITH CHECK (((id = auth.uid()) OR public.is_admin()));


--
-- Name: nguoi_dung_vai_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nguoi_dung_vai_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: nguoi_dung_vai_tro nguoi_dung_vai_tro_admin_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY nguoi_dung_vai_tro_admin_write ON public.nguoi_dung_vai_tro USING (public.is_admin()) WITH CHECK (public.is_admin());


--
-- Name: nguoi_dung_vai_tro nguoi_dung_vai_tro_self_or_admin_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY nguoi_dung_vai_tro_self_or_admin_read ON public.nguoi_dung_vai_tro FOR SELECT USING (((nguoi_dung_id = auth.uid()) OR public.is_admin()));


--
-- Name: nha_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nha_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: nha_tro nha_tro_owner_staff; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY nha_tro_owner_staff ON public.nha_tro USING (public.can_access_nha_tro(id)) WITH CHECK (((chu_tro_id = auth.uid()) OR public.is_admin()));


--
-- Name: phong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.phong ENABLE ROW LEVEL SECURITY;

--
-- Name: phong phong_by_nha_tro; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY phong_by_nha_tro ON public.phong USING (public.can_access_nha_tro(nha_tro_id)) WITH CHECK (public.can_access_nha_tro(nha_tro_id));


--
-- Name: phong_tien_ich; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.phong_tien_ich ENABLE ROW LEVEL SECURITY;

--
-- Name: phong_tien_ich phong_tien_ich_by_room; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY phong_tien_ich_by_room ON public.phong_tien_ich USING ((EXISTS ( SELECT 1
   FROM public.phong p
  WHERE ((p.id = phong_tien_ich.phong_id) AND public.can_access_nha_tro(p.nha_tro_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.phong p
  WHERE ((p.id = phong_tien_ich.phong_id) AND public.can_access_nha_tro(p.nha_tro_id)))));


--
-- Name: phu_luc_hop_dong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.phu_luc_hop_dong ENABLE ROW LEVEL SECURITY;

--
-- Name: phu_luc_hop_dong phu_luc_hop_dong_by_contract; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY phu_luc_hop_dong_by_contract ON public.phu_luc_hop_dong USING ((EXISTS ( SELECT 1
   FROM (public.hop_dong hd
     JOIN public.phong p ON ((p.id = hd.phong_id)))
  WHERE ((hd.id = phu_luc_hop_dong.hop_dong_id) AND public.can_access_nha_tro(p.nha_tro_id))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.hop_dong hd
     JOIN public.phong p ON ((p.id = hd.phong_id)))
  WHERE ((hd.id = phu_luc_hop_dong.hop_dong_id) AND public.can_access_nha_tro(p.nha_tro_id)))));


--
-- Name: su_co; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.su_co ENABLE ROW LEVEL SECURITY;

--
-- Name: su_co su_co_by_room_or_reporter; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY su_co_by_room_or_reporter ON public.su_co USING (((EXISTS ( SELECT 1
   FROM public.phong p
  WHERE ((p.id = su_co.phong_id) AND public.can_access_nha_tro(p.nha_tro_id)))) OR (nguoi_bao_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.khach_thue kt
  WHERE ((kt.id = su_co.khach_thue_id) AND (kt.nguoi_dung_id = auth.uid())))))) WITH CHECK (((EXISTS ( SELECT 1
   FROM public.phong p
  WHERE ((p.id = su_co.phong_id) AND public.can_access_nha_tro(p.nha_tro_id)))) OR (nguoi_bao_id = auth.uid())));


--
-- Name: thanh_toan; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.thanh_toan ENABLE ROW LEVEL SECURITY;

--
-- Name: thanh_toan thanh_toan_by_invoice; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY thanh_toan_by_invoice ON public.thanh_toan USING ((EXISTS ( SELECT 1
   FROM public.hoa_don hd
  WHERE ((hd.id = thanh_toan.hoa_don_id) AND ((EXISTS ( SELECT 1
           FROM public.phong p
          WHERE ((p.id = hd.phong_id) AND public.can_access_nha_tro(p.nha_tro_id)))) OR (EXISTS ( SELECT 1
           FROM public.khach_thue kt
          WHERE ((kt.id = hd.khach_thue_id) AND (kt.nguoi_dung_id = auth.uid()))))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.hoa_don hd
     JOIN public.phong p ON ((p.id = hd.phong_id)))
  WHERE ((hd.id = thanh_toan.hoa_don_id) AND public.can_access_nha_tro(p.nha_tro_id)))));


--
-- Name: thanh_vien_hop_dong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.thanh_vien_hop_dong ENABLE ROW LEVEL SECURITY;

--
-- Name: thanh_vien_hop_dong thanh_vien_hop_dong_by_contract; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY thanh_vien_hop_dong_by_contract ON public.thanh_vien_hop_dong USING ((EXISTS ( SELECT 1
   FROM public.hop_dong hd
  WHERE ((hd.id = thanh_vien_hop_dong.hop_dong_id) AND ((EXISTS ( SELECT 1
           FROM public.phong p
          WHERE ((p.id = hd.phong_id) AND public.can_access_nha_tro(p.nha_tro_id)))) OR (EXISTS ( SELECT 1
           FROM public.khach_thue kt
          WHERE ((kt.id = hd.khach_thue_id) AND (kt.nguoi_dung_id = auth.uid()))))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (public.hop_dong hd
     JOIN public.phong p ON ((p.id = hd.phong_id)))
  WHERE ((hd.id = thanh_vien_hop_dong.hop_dong_id) AND public.can_access_nha_tro(p.nha_tro_id)))));


--
-- Name: thong_bao; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.thong_bao ENABLE ROW LEVEL SECURITY;

--
-- Name: thong_bao thong_bao_insert_authenticated; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY thong_bao_insert_authenticated ON public.thong_bao FOR INSERT WITH CHECK (((nguoi_gui_id = auth.uid()) OR public.is_admin()));


--
-- Name: thong_bao_nguoi_nhan; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.thong_bao_nguoi_nhan ENABLE ROW LEVEL SECURITY;

--
-- Name: thong_bao_nguoi_nhan thong_bao_recipient_insert_sender; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY thong_bao_recipient_insert_sender ON public.thong_bao_nguoi_nhan FOR INSERT WITH CHECK ((public.is_admin() OR (EXISTS ( SELECT 1
   FROM public.thong_bao tb
  WHERE ((tb.id = thong_bao_nguoi_nhan.thong_bao_id) AND (tb.nguoi_gui_id = auth.uid()))))));


--
-- Name: thong_bao_nguoi_nhan thong_bao_recipient_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY thong_bao_recipient_read ON public.thong_bao_nguoi_nhan FOR SELECT USING (((nguoi_dung_id = auth.uid()) OR public.is_admin()));


--
-- Name: thong_bao_nguoi_nhan thong_bao_recipient_update_self; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY thong_bao_recipient_update_self ON public.thong_bao_nguoi_nhan FOR UPDATE USING (((nguoi_dung_id = auth.uid()) OR public.is_admin())) WITH CHECK (((nguoi_dung_id = auth.uid()) OR public.is_admin()));


--
-- Name: thong_bao thong_bao_sender_or_recipient; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY thong_bao_sender_or_recipient ON public.thong_bao FOR SELECT USING (((nguoi_gui_id = auth.uid()) OR public.is_admin() OR (EXISTS ( SELECT 1
   FROM public.thong_bao_nguoi_nhan tbn
  WHERE ((tbn.thong_bao_id = thong_bao.id) AND (tbn.nguoi_dung_id = auth.uid()))))));


--
-- Name: tien_ich; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tien_ich ENABLE ROW LEVEL SECURITY;

--
-- Name: tien_ich tien_ich_admin_write; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY tien_ich_admin_write ON public.tien_ich USING (public.is_admin()) WITH CHECK (public.is_admin());


--
-- Name: tien_ich tien_ich_read_authenticated; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY tien_ich_read_authenticated ON public.tien_ich FOR SELECT USING ((auth.uid() IS NOT NULL));


--
-- Name: vai_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.vai_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: vai_tro vai_tro_read_authenticated; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY vai_tro_read_authenticated ON public.vai_tro FOR SELECT USING ((auth.uid() IS NOT NULL));


--
-- PostgreSQL database dump complete
--

\unrestrict zN1OJwmaEjc1FoQuAwn6n5Hzhs8MQwQwNwQIdcmgfz3gAc6jCzXDnQzgasxNzpI
