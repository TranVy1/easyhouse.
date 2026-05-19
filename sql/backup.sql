--
-- PostgreSQL database dump
--

\restrict mnv0Hy7GmfB1upJZ32k6iKNUJahfSYePXmKB8z9NFAwkCVuiqcIQPpgsOfdecIs

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

DROP EVENT TRIGGER IF EXISTS pgrst_drop_watch;
DROP EVENT TRIGGER IF EXISTS pgrst_ddl_watch;
DROP EVENT TRIGGER IF EXISTS issue_pg_net_access;
DROP EVENT TRIGGER IF EXISTS issue_pg_graphql_access;
DROP EVENT TRIGGER IF EXISTS issue_pg_cron_access;
DROP EVENT TRIGGER IF EXISTS issue_graphql_placeholder;
DROP PUBLICATION IF EXISTS supabase_realtime;
ALTER TABLE IF EXISTS ONLY storage.vector_indexes DROP CONSTRAINT IF EXISTS vector_indexes_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_upload_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads DROP CONSTRAINT IF EXISTS s3_multipart_uploads_bucket_id_fkey;
ALTER TABLE IF EXISTS ONLY storage.objects DROP CONSTRAINT IF EXISTS "objects_bucketId_fkey";
ALTER TABLE IF EXISTS ONLY public.thong_bao DROP CONSTRAINT IF EXISTS thong_bao_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_vien_hop_dong DROP CONSTRAINT IF EXISTS thanh_vien_hop_dong_hop_dong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_toan DROP CONSTRAINT IF EXISTS thanh_toan_nguoi_thanh_toan_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_toan DROP CONSTRAINT IF EXISTS thanh_toan_hoa_don_id_fkey;
ALTER TABLE IF EXISTS ONLY public.su_co DROP CONSTRAINT IF EXISTS su_co_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.su_co DROP CONSTRAINT IF EXISTS su_co_nguoi_phu_trach_fkey;
ALTER TABLE IF EXISTS ONLY public.su_co DROP CONSTRAINT IF EXISTS su_co_khach_thue_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phong_tien_ich DROP CONSTRAINT IF EXISTS phong_tien_ich_tien_ich_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phong_tien_ich DROP CONSTRAINT IF EXISTS phong_tien_ich_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phong DROP CONSTRAINT IF EXISTS phong_nha_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nha_tro DROP CONSTRAINT IF EXISTS nha_tro_chu_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung_vai_tro DROP CONSTRAINT IF EXISTS nguoi_dung_vai_tro_vai_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung_vai_tro DROP CONSTRAINT IF EXISTS nguoi_dung_vai_tro_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lich_su_hoa_don DROP CONSTRAINT IF EXISTS lich_su_hoa_don_nguoi_thay_doi_fkey;
ALTER TABLE IF EXISTS ONLY public.lich_su_hoa_don DROP CONSTRAINT IF EXISTS lich_su_hoa_don_hoa_don_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lich_hen DROP CONSTRAINT IF EXISTS lich_hen_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lich_hen DROP CONSTRAINT IF EXISTS lich_hen_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.khach_thue DROP CONSTRAINT IF EXISTS khach_thue_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hop_dong DROP CONSTRAINT IF EXISTS hop_dong_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hop_dong DROP CONSTRAINT IF EXISTS hop_dong_khach_thue_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hoa_don DROP CONSTRAINT IF EXISTS hoa_don_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hoa_don DROP CONSTRAINT IF EXISTS hoa_don_khach_thue_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hoa_don DROP CONSTRAINT IF EXISTS hoa_don_hop_dong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.dat_coc_phong DROP CONSTRAINT IF EXISTS fk_dat_coc_hop_dong;
ALTER TABLE IF EXISTS ONLY public.email_verification_token DROP CONSTRAINT IF EXISTS fk13hft1rs4pds05ytufr3dg2te;
ALTER TABLE IF EXISTS ONLY public.dat_coc_phong DROP CONSTRAINT IF EXISTS dat_coc_phong_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.dat_coc_phong DROP CONSTRAINT IF EXISTS dat_coc_phong_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chu_tro DROP CONSTRAINT IF EXISTS chu_tro_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chi_tiet_hoa_don DROP CONSTRAINT IF EXISTS chi_tiet_hoa_don_hoa_don_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chi_so_dien_nuoc DROP CONSTRAINT IF EXISTS chi_so_dien_nuoc_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.cau_hinh_gia DROP CONSTRAINT IF EXISTS cau_hinh_gia_nha_tro_id_fkey;
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
DROP TRIGGER IF EXISTS update_objects_updated_at ON storage.objects;
DROP TRIGGER IF EXISTS protect_objects_delete ON storage.objects;
DROP TRIGGER IF EXISTS protect_buckets_delete ON storage.buckets;
DROP TRIGGER IF EXISTS enforce_bucket_name_length_trigger ON storage.buckets;
DROP TRIGGER IF EXISTS tr_check_filters ON realtime.subscription;
DROP TRIGGER IF EXISTS trg_thanh_vien_cap_nhat ON public.thanh_vien_hop_dong;
DROP TRIGGER IF EXISTS trg_su_co_cap_nhat ON public.su_co;
DROP TRIGGER IF EXISTS trg_sau_thanh_toan ON public.thanh_toan;
DROP TRIGGER IF EXISTS trg_phong_cap_nhat ON public.phong;
DROP TRIGGER IF EXISTS trg_nha_tro_cap_nhat ON public.nha_tro;
DROP TRIGGER IF EXISTS trg_nguoi_dung_cap_nhat ON public.nguoi_dung;
DROP TRIGGER IF EXISTS trg_lich_hen_cap_nhat ON public.lich_hen;
DROP TRIGGER IF EXISTS trg_khach_thue_cap_nhat ON public.khach_thue;
DROP TRIGGER IF EXISTS trg_hop_dong_cap_nhat ON public.hop_dong;
DROP TRIGGER IF EXISTS trg_hoa_don_cap_nhat ON public.hoa_don;
DROP TRIGGER IF EXISTS trg_dat_coc_cap_nhat ON public.dat_coc_phong;
DROP TRIGGER IF EXISTS trg_chu_tro_cap_nhat ON public.chu_tro;
DROP TRIGGER IF EXISTS trg_chi_so_cap_nhat ON public.chi_so_dien_nuoc;
DROP TRIGGER IF EXISTS trg_cau_hinh_gia_cap_nhat ON public.cau_hinh_gia;
DROP INDEX IF EXISTS storage.vector_indexes_name_bucket_id_idx;
DROP INDEX IF EXISTS storage.name_prefix_search;
DROP INDEX IF EXISTS storage.idx_objects_bucket_id_name_lower;
DROP INDEX IF EXISTS storage.idx_objects_bucket_id_name;
DROP INDEX IF EXISTS storage.idx_multipart_uploads_list;
DROP INDEX IF EXISTS storage.buckets_analytics_unique_name_idx;
DROP INDEX IF EXISTS storage.bucketid_objname;
DROP INDEX IF EXISTS storage.bname;
DROP INDEX IF EXISTS realtime.subscription_subscription_id_entity_filters_action_filter_key;
DROP INDEX IF EXISTS realtime.messages_inserted_at_topic_index;
DROP INDEX IF EXISTS realtime.ix_realtime_subscription_entity;
DROP INDEX IF EXISTS public.uk_hoa_don_ma_hoa_don_not_null;
DROP INDEX IF EXISTS public.idx_thong_bao_nguoi_dung_id;
DROP INDEX IF EXISTS public.idx_thanh_vien_hop_dong_id;
DROP INDEX IF EXISTS public.idx_thanh_toan_hoa_don_id;
DROP INDEX IF EXISTS public.idx_su_co_uu_tien;
DROP INDEX IF EXISTS public.idx_su_co_trang_thai;
DROP INDEX IF EXISTS public.idx_su_co_phong_id;
DROP INDEX IF EXISTS public.idx_su_co_loai;
DROP INDEX IF EXISTS public.idx_phong_trang_thai;
DROP INDEX IF EXISTS public.idx_phong_nha_tro_id;
DROP INDEX IF EXISTS public.idx_nha_tro_chu_tro_id;
DROP INDEX IF EXISTS public.idx_hop_dong_phong_trang_thai_dates;
DROP INDEX IF EXISTS public.idx_hop_dong_phong_id;
DROP INDEX IF EXISTS public.idx_hop_dong_khach_thue_id;
DROP INDEX IF EXISTS public.idx_hoa_don_trang_thai_han_tra;
DROP INDEX IF EXISTS public.idx_hoa_don_trang_thai;
DROP INDEX IF EXISTS public.idx_hoa_don_thang;
DROP INDEX IF EXISTS public.idx_hoa_don_phong_id;
DROP INDEX IF EXISTS public.idx_hoa_don_khach_thue_id;
DROP INDEX IF EXISTS public.idx_hoa_don_hop_dong_thang;
DROP INDEX IF EXISTS public.idx_hoa_don_hop_dong_id;
DROP INDEX IF EXISTS public.idx_dat_coc_phong_id;
DROP INDEX IF EXISTS public.idx_chi_tiet_hoa_don_id;
DROP INDEX IF EXISTS public.idx_chi_so_phong_ngay;
DROP INDEX IF EXISTS public.idx_cau_hinh_gia_nha_tro_id;
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
ALTER TABLE IF EXISTS ONLY storage.vector_indexes DROP CONSTRAINT IF EXISTS vector_indexes_pkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads DROP CONSTRAINT IF EXISTS s3_multipart_uploads_pkey;
ALTER TABLE IF EXISTS ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT IF EXISTS s3_multipart_uploads_parts_pkey;
ALTER TABLE IF EXISTS ONLY storage.objects DROP CONSTRAINT IF EXISTS objects_pkey;
ALTER TABLE IF EXISTS ONLY storage.migrations DROP CONSTRAINT IF EXISTS migrations_pkey;
ALTER TABLE IF EXISTS ONLY storage.migrations DROP CONSTRAINT IF EXISTS migrations_name_key;
ALTER TABLE IF EXISTS ONLY storage.buckets_vectors DROP CONSTRAINT IF EXISTS buckets_vectors_pkey;
ALTER TABLE IF EXISTS ONLY storage.buckets DROP CONSTRAINT IF EXISTS buckets_pkey;
ALTER TABLE IF EXISTS ONLY storage.buckets_analytics DROP CONSTRAINT IF EXISTS buckets_analytics_pkey;
ALTER TABLE IF EXISTS ONLY realtime.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY realtime.subscription DROP CONSTRAINT IF EXISTS pk_subscription;
ALTER TABLE IF EXISTS ONLY realtime.messages DROP CONSTRAINT IF EXISTS messages_pkey;
ALTER TABLE IF EXISTS ONLY public.vai_tro DROP CONSTRAINT IF EXISTS vai_tro_ten_key;
ALTER TABLE IF EXISTS ONLY public.vai_tro DROP CONSTRAINT IF EXISTS vai_tro_pkey;
ALTER TABLE IF EXISTS ONLY public.email_verification_token DROP CONSTRAINT IF EXISTS ukidu2ippaks8bn6vcsq62khvdu;
ALTER TABLE IF EXISTS ONLY public.hop_dong DROP CONSTRAINT IF EXISTS uk1gcrgca5o7t8609khe2gdgax9;
ALTER TABLE IF EXISTS ONLY public.tien_ich DROP CONSTRAINT IF EXISTS tien_ich_ten_key;
ALTER TABLE IF EXISTS ONLY public.tien_ich DROP CONSTRAINT IF EXISTS tien_ich_pkey;
ALTER TABLE IF EXISTS ONLY public.thong_bao DROP CONSTRAINT IF EXISTS thong_bao_pkey;
ALTER TABLE IF EXISTS ONLY public.thanh_vien_hop_dong DROP CONSTRAINT IF EXISTS thanh_vien_hop_dong_pkey;
ALTER TABLE IF EXISTS ONLY public.thanh_toan DROP CONSTRAINT IF EXISTS thanh_toan_pkey;
ALTER TABLE IF EXISTS ONLY public.su_co DROP CONSTRAINT IF EXISTS su_co_pkey;
ALTER TABLE IF EXISTS ONLY public.phong_tien_ich DROP CONSTRAINT IF EXISTS phong_tien_ich_pkey;
ALTER TABLE IF EXISTS ONLY public.phong DROP CONSTRAINT IF EXISTS phong_pkey;
ALTER TABLE IF EXISTS ONLY public.nha_tro DROP CONSTRAINT IF EXISTS nha_tro_pkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung_vai_tro DROP CONSTRAINT IF EXISTS nguoi_dung_vai_tro_pkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung DROP CONSTRAINT IF EXISTS nguoi_dung_so_dien_thoai_key;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung DROP CONSTRAINT IF EXISTS nguoi_dung_pkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung DROP CONSTRAINT IF EXISTS nguoi_dung_email_key;
ALTER TABLE IF EXISTS ONLY public.lich_su_hoa_don DROP CONSTRAINT IF EXISTS lich_su_hoa_don_pkey;
ALTER TABLE IF EXISTS ONLY public.lich_hen DROP CONSTRAINT IF EXISTS lich_hen_pkey;
ALTER TABLE IF EXISTS ONLY public.khach_thue DROP CONSTRAINT IF EXISTS khach_thue_so_cccd_key;
ALTER TABLE IF EXISTS ONLY public.khach_thue DROP CONSTRAINT IF EXISTS khach_thue_pkey;
ALTER TABLE IF EXISTS ONLY public.khach_thue DROP CONSTRAINT IF EXISTS khach_thue_nguoi_dung_id_key;
ALTER TABLE IF EXISTS ONLY public.hop_dong DROP CONSTRAINT IF EXISTS hop_dong_pkey;
ALTER TABLE IF EXISTS ONLY public.hoa_don DROP CONSTRAINT IF EXISTS hoa_don_pkey;
ALTER TABLE IF EXISTS ONLY public.email_verification_token DROP CONSTRAINT IF EXISTS email_verification_token_pkey;
ALTER TABLE IF EXISTS ONLY public.dat_coc_phong DROP CONSTRAINT IF EXISTS dat_coc_phong_pkey;
ALTER TABLE IF EXISTS ONLY public.chu_tro DROP CONSTRAINT IF EXISTS chu_tro_so_cccd_key;
ALTER TABLE IF EXISTS ONLY public.chu_tro DROP CONSTRAINT IF EXISTS chu_tro_pkey;
ALTER TABLE IF EXISTS ONLY public.chu_tro DROP CONSTRAINT IF EXISTS chu_tro_nguoi_dung_id_key;
ALTER TABLE IF EXISTS ONLY public.chi_tiet_hoa_don DROP CONSTRAINT IF EXISTS chi_tiet_hoa_don_pkey;
ALTER TABLE IF EXISTS ONLY public.chi_so_dien_nuoc DROP CONSTRAINT IF EXISTS chi_so_dien_nuoc_pkey;
ALTER TABLE IF EXISTS ONLY public.cau_hinh_gia DROP CONSTRAINT IF EXISTS cau_hinh_gia_pkey;
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
DROP TABLE IF EXISTS storage.vector_indexes;
DROP TABLE IF EXISTS storage.s3_multipart_uploads_parts;
DROP TABLE IF EXISTS storage.s3_multipart_uploads;
DROP TABLE IF EXISTS storage.objects;
DROP TABLE IF EXISTS storage.migrations;
DROP TABLE IF EXISTS storage.buckets_vectors;
DROP TABLE IF EXISTS storage.buckets_analytics;
DROP TABLE IF EXISTS storage.buckets;
DROP TABLE IF EXISTS realtime.subscription;
DROP TABLE IF EXISTS realtime.schema_migrations;
DROP TABLE IF EXISTS realtime.messages;
DROP TABLE IF EXISTS public.vai_tro;
DROP TABLE IF EXISTS public.tien_ich;
DROP TABLE IF EXISTS public.thong_bao;
DROP TABLE IF EXISTS public.thanh_vien_hop_dong;
DROP TABLE IF EXISTS public.thanh_toan;
DROP TABLE IF EXISTS public.su_co;
DROP TABLE IF EXISTS public.phong_tien_ich;
DROP TABLE IF EXISTS public.phong;
DROP TABLE IF EXISTS public.nha_tro;
DROP TABLE IF EXISTS public.nguoi_dung_vai_tro;
DROP TABLE IF EXISTS public.nguoi_dung;
DROP TABLE IF EXISTS public.lich_su_hoa_don;
DROP TABLE IF EXISTS public.lich_hen;
DROP TABLE IF EXISTS public.khach_thue;
DROP TABLE IF EXISTS public.hop_dong;
DROP TABLE IF EXISTS public.hoa_don;
DROP TABLE IF EXISTS public.email_verification_token;
DROP TABLE IF EXISTS public.dat_coc_phong;
DROP TABLE IF EXISTS public.chu_tro;
DROP TABLE IF EXISTS public.chi_tiet_hoa_don;
DROP TABLE IF EXISTS public.chi_so_dien_nuoc;
DROP TABLE IF EXISTS public.cau_hinh_gia;
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
DROP FUNCTION IF EXISTS storage.update_updated_at_column();
DROP FUNCTION IF EXISTS storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text);
DROP FUNCTION IF EXISTS storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text);
DROP FUNCTION IF EXISTS storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text);
DROP FUNCTION IF EXISTS storage.protect_delete();
DROP FUNCTION IF EXISTS storage.operation();
DROP FUNCTION IF EXISTS storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text);
DROP FUNCTION IF EXISTS storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text);
DROP FUNCTION IF EXISTS storage.get_size_by_bucket();
DROP FUNCTION IF EXISTS storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text);
DROP FUNCTION IF EXISTS storage.foldername(name text);
DROP FUNCTION IF EXISTS storage.filename(name text);
DROP FUNCTION IF EXISTS storage.extension(name text);
DROP FUNCTION IF EXISTS storage.enforce_bucket_name_length();
DROP FUNCTION IF EXISTS storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb);
DROP FUNCTION IF EXISTS storage.allow_only_operation(expected_operation text);
DROP FUNCTION IF EXISTS storage.allow_any_operation(expected_operations text[]);
DROP FUNCTION IF EXISTS realtime.topic();
DROP FUNCTION IF EXISTS realtime.to_regrole(role_name text);
DROP FUNCTION IF EXISTS realtime.subscription_check_filters();
DROP FUNCTION IF EXISTS realtime.send(payload jsonb, event text, topic text, private boolean);
DROP FUNCTION IF EXISTS realtime.quote_wal2json(entity regclass);
DROP FUNCTION IF EXISTS realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer);
DROP FUNCTION IF EXISTS realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]);
DROP FUNCTION IF EXISTS realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text);
DROP FUNCTION IF EXISTS realtime."cast"(val text, type_ regtype);
DROP FUNCTION IF EXISTS realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]);
DROP FUNCTION IF EXISTS realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text);
DROP FUNCTION IF EXISTS realtime.apply_rls(wal jsonb, max_record_bytes integer);
DROP FUNCTION IF EXISTS public.update_updated_at_column();
DROP FUNCTION IF EXISTS public.update_invoice_status_on_payment();
DROP FUNCTION IF EXISTS public.cap_nhat_trang_thai_hoa_don();
DROP FUNCTION IF EXISTS public.cap_nhat_thoi_gian();
DROP FUNCTION IF EXISTS pgbouncer.get_auth(p_usename text);
DROP FUNCTION IF EXISTS graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb);
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
DROP TYPE IF EXISTS storage.buckettype;
DROP TYPE IF EXISTS realtime.wal_rls;
DROP TYPE IF EXISTS realtime.wal_column;
DROP TYPE IF EXISTS realtime.user_defined_filter;
DROP TYPE IF EXISTS realtime.equality_op;
DROP TYPE IF EXISTS realtime.action;
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
DROP TYPE IF EXISTS public.room_status;
DROP TYPE IF EXISTS public.media_entity_type;
DROP TYPE IF EXISTS public.maintenance_status;
DROP TYPE IF EXISTS public.loai_tinh_phi;
DROP TYPE IF EXISTS public.loai_su_co_enum;
DROP TYPE IF EXISTS public.loai_muc_hoa_don;
DROP TYPE IF EXISTS public.loai_doi_tuong_media;
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
DROP EXTENSION IF EXISTS "uuid-ossp";
DROP EXTENSION IF EXISTS pgcrypto;
DROP EXTENSION IF EXISTS pg_stat_statements;
DROP SCHEMA IF EXISTS vault;
DROP SCHEMA IF EXISTS storage;
DROP SCHEMA IF EXISTS realtime;
-- *not* dropping schema, since initdb creates it
DROP SCHEMA IF EXISTS pgbouncer;
DROP SCHEMA IF EXISTS graphql_public;
DROP SCHEMA IF EXISTS graphql;
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
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


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
-- Name: loai_doi_tuong_media; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_doi_tuong_media AS ENUM (
    'USER',
    'MOTEL',
    'ROOM',
    'CONTRACT',
    'INVOICE',
    'MAINTENANCE',
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
    'OTHER'
);


--
-- Name: loai_su_co_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_su_co_enum AS ENUM (
    'dien_nuoc',
    'noi_that',
    've_sinh',
    'an_ninh',
    'khac'
);


--
-- Name: loai_tinh_phi; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_tinh_phi AS ENUM (
    'PER_METER',
    'PER_PERSON',
    'PER_ROOM'
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
-- Name: room_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.room_status AS ENUM (
    'AVAILABLE',
    'RENTED',
    'MAINTENANCE'
);


--
-- Name: trang_thai_coc_hop_dong; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_coc_hop_dong AS ENUM (
    'KEPT',
    'REFUNDED',
    'DEDUCTED'
);


--
-- Name: trang_thai_dat_coc; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_dat_coc AS ENUM (
    'PENDING',
    'COMPLETED',
    'REFUNDED',
    'FORFEITED'
);


--
-- Name: trang_thai_hoa_don; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_hoa_don AS ENUM (
    'UNPAID',
    'PARTIAL',
    'PAID',
    'OVERDUE'
);


--
-- Name: trang_thai_hop_dong; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_hop_dong AS ENUM (
    'PENDING',
    'ACTIVE',
    'EXPIRED',
    'TERMINATED'
);


--
-- Name: trang_thai_lich_hen; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_lich_hen AS ENUM (
    'PENDING',
    'CONFIRMED',
    'CANCELLED',
    'COMPLETED'
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
    'MAINTENANCE'
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
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
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
  select
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
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
-- Name: graphql(text, text, jsonb, jsonb); Type: FUNCTION; Schema: graphql_public; Owner: -
--

CREATE FUNCTION graphql_public.graphql("operationName" text DEFAULT NULL::text, query text DEFAULT NULL::text, variables jsonb DEFAULT NULL::jsonb, extensions jsonb DEFAULT NULL::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
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


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


--
-- Name: cap_nhat_thoi_gian(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.cap_nhat_thoi_gian() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN NEW.cap_nhat_luc = CURRENT_TIMESTAMP;

RETURN NEW;

END;

$$;


--
-- Name: cap_nhat_trang_thai_hoa_don(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.cap_nhat_trang_thai_hoa_don() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE tong_da_tra DECIMAL(15, 2);

tong_can_tra DECIMAL(15, 2);

trang_thai_cu trang_thai_hoa_don;

trang_thai_moi trang_thai_hoa_don;

BEGIN IF NEW.trang_thai != 'SUCCESS' THEN RETURN NEW;

END IF;

SELECT COALESCE(SUM(so_tien), 0) INTO tong_da_tra

FROM thanh_toan

WHERE hoa_don_id = NEW.hoa_don_id

    AND trang_thai = 'SUCCESS';

SELECT tong_tien,

    trang_thai INTO tong_can_tra,

    trang_thai_cu

FROM hoa_don

WHERE id = NEW.hoa_don_id;

IF tong_da_tra >= tong_can_tra THEN trang_thai_moi := 'PAID';

ELSIF tong_da_tra > 0 THEN trang_thai_moi := 'PARTIAL';

ELSE trang_thai_moi := 'UNPAID';

END IF;

UPDATE hoa_don

SET da_tra = tong_da_tra,

    trang_thai = trang_thai_moi,

    cap_nhat_luc = CURRENT_TIMESTAMP

WHERE id = NEW.hoa_don_id;

IF trang_thai_cu != trang_thai_moi THEN

INSERT INTO lich_su_hoa_don (

        hoa_don_id,

        trang_thai_truoc,

        trang_thai_moi,

        ghi_chu

    )

VALUES (

        NEW.hoa_don_id,

        trang_thai_cu,

        trang_thai_moi,

        'He thong tu dong cap nhat'

    );

END IF;

RETURN NEW;

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


--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL AND ppt.tablename NOT LIKE '% %'),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         pg_logical_slot_get_changes(
           slot_name, null, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  -- Count raw slot entries before apply_rls/subscription filter
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  -- Apply RLS and filter as before
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  -- Real rows with slot count attached
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  -- Sentinel row: always returned when no real rows exist so Elixir can
  -- always read slot_changes_count. Identified by wal IS NULL.
  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


--
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Get the last path segment (the actual filename)
    SELECT _parts[array_length(_parts, 1)] INTO _filename;
    -- Extract extension: reverse, split on '.', then reverse again
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint)::bigint as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
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
-- Name: cau_hinh_gia; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cau_hinh_gia (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    nha_tro_id uuid,
    hieu_luc_tu date NOT NULL,
    gia_dien numeric(15,2) NOT NULL,
    loai_tinh_nuoc public.loai_tinh_phi DEFAULT 'PER_METER'::public.loai_tinh_phi,
    gia_nuoc numeric(15,2) NOT NULL,
    loai_tinh_dich_vu public.loai_tinh_phi DEFAULT 'PER_PERSON'::public.loai_tinh_phi,
    gia_dich_vu numeric(15,2) NOT NULL,
    loai_tinh_internet public.loai_tinh_phi DEFAULT 'PER_ROOM'::public.loai_tinh_phi,
    gia_internet numeric(15,2) NOT NULL,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: chi_so_dien_nuoc; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chi_so_dien_nuoc (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    phong_id uuid,
    ngay_ghi date NOT NULL,
    chi_so_dien_cu integer NOT NULL,
    chi_so_dien_moi integer NOT NULL,
    chi_so_nuoc_cu integer NOT NULL,
    chi_so_nuoc_moi integer NOT NULL,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_dien CHECK ((chi_so_dien_moi >= chi_so_dien_cu)),
    CONSTRAINT check_nuoc CHECK ((chi_so_nuoc_moi >= chi_so_nuoc_cu))
);


--
-- Name: chi_tiet_hoa_don; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chi_tiet_hoa_don (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    hoa_don_id uuid,
    loai public.loai_muc_hoa_don NOT NULL,
    mo_ta character varying(255),
    so_luong numeric(10,2) NOT NULL,
    don_gia numeric(15,2) NOT NULL,
    thanh_tien numeric(15,2) NOT NULL,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: chu_tro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chu_tro (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
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
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    phong_id uuid,
    nguoi_dung_id uuid,
    hop_dong_id uuid,
    so_tien_coc numeric(15,2) NOT NULL,
    ngay_dat_coc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    ngay_du_kien_vao date,
    trang_thai public.trang_thai_dat_coc DEFAULT 'PENDING'::public.trang_thai_dat_coc,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: email_verification_token; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_verification_token (
    id uuid NOT NULL,
    het_han_luc timestamp(6) with time zone NOT NULL,
    tao_luc timestamp(6) with time zone,
    token character varying(255) NOT NULL,
    used boolean NOT NULL,
    nguoi_dung_id uuid NOT NULL
);


--
-- Name: hoa_don; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hoa_don (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    phong_id uuid,
    hop_dong_id uuid,
    khach_thue_id uuid,
    thang_hoa_don date NOT NULL,
    tong_tien numeric(15,2) NOT NULL,
    da_tra numeric(15,2) DEFAULT 0 NOT NULL,
    trang_thai public.trang_thai_hoa_don DEFAULT 'UNPAID'::public.trang_thai_hoa_don,
    han_tra date NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    xoa_luc timestamp with time zone,
    ma_hoa_don character varying(100),
    ngay_phat_hanh date DEFAULT CURRENT_DATE,
    ngay_gui timestamp with time zone,
    da_gui boolean DEFAULT false,
    tien_giam numeric(15,2) DEFAULT 0,
    phi_phat_sinh numeric(15,2) DEFAULT 0
);


--
-- Name: hop_dong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hop_dong (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    phong_id uuid,
    khach_thue_id uuid,
    ngay_bat_dau date NOT NULL,
    ngay_ket_thuc date NOT NULL,
    gia_thue_hop_dong numeric(15,2) NOT NULL,
    tien_coc numeric(15,2) DEFAULT 0 NOT NULL,
    trang_thai_coc public.trang_thai_coc_hop_dong DEFAULT 'KEPT'::public.trang_thai_coc_hop_dong,
    so_tien_hoan_coc numeric(15,2) DEFAULT 0,
    ngay_hoan_coc timestamp with time zone,
    trang_thai character varying(255) DEFAULT 'PENDING'::public.trang_thai_hop_dong,
    noi_dung_hop_dong text,
    file_pdf text,
    chu_ky_chu_tro text,
    chu_ky_khach_thue text,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    xoa_luc timestamp with time zone,
    chi_so_dien_ban_dau integer,
    chi_so_nuoc_ban_dau integer,
    chu_ky_thanh_toan character varying(50),
    dieu_khoan text,
    file_hop_dong character varying(255),
    gia_dien numeric(10,2),
    gia_nuoc numeric(10,2),
    khach_thue_ids jsonb,
    ma_hop_dong character varying(100) NOT NULL,
    ngay_thanh_toan integer,
    phi_dich_vu jsonb,
    CONSTRAINT check_ngay CHECK ((ngay_ket_thuc > ngay_bat_dau))
);


--
-- Name: khach_thue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.khach_thue (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    nguoi_dung_id uuid,
    so_cccd character varying(50) NOT NULL,
    lien_he_khan_cap character varying(255),
    ngay_sinh date,
    dia_chi_thuong_tru character varying(255),
    nghe_nghiep character varying(255),
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    xoa_luc timestamp with time zone,
    anh_cccd jsonb,
    email character varying(255),
    gioi_tinh character varying(20),
    mat_khau character varying(255),
    que_quan character varying(255),
    trang_thai character varying(50),
    ho_ten character varying(255),
    so_dien_thoai character varying(20),
    anh_cccd_sau text,
    anh_cccd_truoc text
);


--
-- Name: lich_hen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lich_hen (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    phong_id uuid,
    nguoi_dung_id uuid,
    ngay_hen timestamp with time zone NOT NULL,
    trang_thai public.trang_thai_lich_hen DEFAULT 'PENDING'::public.trang_thai_lich_hen,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: lich_su_hoa_don; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lich_su_hoa_don (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    hoa_don_id uuid,
    trang_thai_truoc public.trang_thai_hoa_don,
    trang_thai_moi public.trang_thai_hoa_don NOT NULL,
    nguoi_thay_doi uuid,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: nguoi_dung; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nguoi_dung (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    email character varying(255) NOT NULL,
    mat_khau character varying(255) NOT NULL,
    ho_ten character varying(255) NOT NULL,
    so_dien_thoai character varying(20),
    anh_dai_dien text,
    ngay_sinh date,
    gioi_tinh character varying(10),
    trang_thai character varying(255) DEFAULT 'ACTIVE'::public.trang_thai_nguoi_dung,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    xoa_luc timestamp with time zone,
    dia_chi text,
    que_quan character varying(255)
);


--
-- Name: nguoi_dung_vai_tro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nguoi_dung_vai_tro (
    nguoi_dung_id uuid NOT NULL,
    vai_tro_id uuid NOT NULL
);


--
-- Name: nha_tro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nha_tro (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    chu_tro_id uuid,
    ten character varying(255) NOT NULL,
    dia_chi text NOT NULL,
    tinh character varying(100) NOT NULL,
    huyen character varying(100) NOT NULL,
    xa character varying(100) NOT NULL,
    mo_ta text,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    xoa_luc timestamp with time zone,
    tien_nghi_chung text,
    duong character varying(255),
    phuong character varying(100),
    quan character varying(100),
    so_nha character varying(100),
    thanh_pho character varying(100)
);


--
-- Name: phong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phong (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    nha_tro_id uuid,
    ten character varying(100) NOT NULL,
    tang integer,
    dien_tich numeric(10,2) NOT NULL,
    so_nguoi_toi_da integer DEFAULT 2 NOT NULL,
    trang_thai character varying(255) DEFAULT 'AVAILABLE'::public.trang_thai_phong,
    gia_hien_tai numeric(15,2) NOT NULL,
    tien_coc_mac_dinh numeric(15,2),
    mo_ta text,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    xoa_luc timestamp with time zone,
    anh_phong jsonb,
    tien_nghi jsonb
);


--
-- Name: phong_tien_ich; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phong_tien_ich (
    phong_id uuid NOT NULL,
    tien_ich_id uuid NOT NULL
);


--
-- Name: su_co; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.su_co (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    phong_id uuid,
    khach_thue_id uuid,
    tieu_de character varying(255) NOT NULL,
    mo_ta text NOT NULL,
    loai_su_co character varying(255) DEFAULT 'khac'::public.loai_su_co_enum,
    uu_tien character varying(255) DEFAULT 'trung_binh'::public.uu_tien_enum,
    trang_thai character varying(255) DEFAULT 'PENDING'::public.trang_thai_su_co,
    nguoi_phu_trach uuid,
    chi_phi_sua_chua numeric(15,2),
    ghi_chu_chu_nha text,
    giai_quyet_luc timestamp with time zone,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    anh_su_co jsonb
);


--
-- Name: thanh_toan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thanh_toan (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    hoa_don_id uuid,
    so_tien numeric(15,2) NOT NULL,
    ngay_thanh_toan timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    phuong_thuc_thanh_toan character varying(50),
    ma_tham_chieu character varying(100),
    trang_thai character varying(50) DEFAULT 'SUCCESS'::public.trang_thai_thanh_toan,
    nguoi_thanh_toan uuid,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: thanh_vien_hop_dong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thanh_vien_hop_dong (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    hop_dong_id uuid,
    ho_ten character varying(255) NOT NULL,
    so_cccd character varying(50) NOT NULL,
    so_dien_thoai character varying(20),
    dang_o boolean DEFAULT true,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: thong_bao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thong_bao (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    nguoi_dung_id uuid,
    tieu_de character varying(255) NOT NULL,
    noi_dung text NOT NULL,
    loai character varying(50),
    da_doc boolean DEFAULT false,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc timestamp(6) with time zone,
    da_doc_json jsonb,
    ngay_gui timestamp(6) with time zone,
    nguoi_gui_id uuid,
    nguoi_nhan jsonb,
    phong jsonb,
    toa_nha_id uuid,
    xoa_luc timestamp(6) with time zone,
    phong_ids jsonb,
    gui_tat_ca boolean,
    nhom_gui_id uuid
);


--
-- Name: tien_ich; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tien_ich (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    ten character varying(100) NOT NULL,
    bieu_tuong character varying(100),
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: vai_tro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vai_tro (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    ten character varying(50) NOT NULL,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb,
    metadata jsonb
);


--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

INSERT INTO auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) VALUES ('8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139', '8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139', '{"sub": "8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139", "email": "vyt22052006@gmail.com", "email_verified": true, "phone_verified": false}', 'email', '2026-05-08 16:26:02.171737+00', '2026-05-08 16:26:02.171798+00', '2026-05-08 16:26:02.171798+00', '4164f40a-ea09-4b2f-96dd-a36c05d343b3');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

INSERT INTO auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) VALUES ('642f3c07-b80d-4ac8-8e24-57f710332e22', '2026-05-13 16:05:06.011582+00', '2026-05-13 16:05:06.011582+00', 'otp', 'e6505051-df34-4ca8-8e57-78140902dad2');


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

INSERT INTO auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) VALUES ('00000000-0000-0000-0000-000000000000', 1, 'kssiz3i4sca3', '8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139', false, '2026-05-13 16:05:06.001401+00', '2026-05-13 16:05:06.001401+00', NULL, '642f3c07-b80d-4ac8-8e24-57f710332e22');


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: -
--

INSERT INTO auth.schema_migrations (version) VALUES ('20171026211738');
INSERT INTO auth.schema_migrations (version) VALUES ('20171026211808');
INSERT INTO auth.schema_migrations (version) VALUES ('20171026211834');
INSERT INTO auth.schema_migrations (version) VALUES ('20180103212743');
INSERT INTO auth.schema_migrations (version) VALUES ('20180108183307');
INSERT INTO auth.schema_migrations (version) VALUES ('20180119214651');
INSERT INTO auth.schema_migrations (version) VALUES ('20180125194653');
INSERT INTO auth.schema_migrations (version) VALUES ('00');
INSERT INTO auth.schema_migrations (version) VALUES ('20210710035447');
INSERT INTO auth.schema_migrations (version) VALUES ('20210722035447');
INSERT INTO auth.schema_migrations (version) VALUES ('20210730183235');
INSERT INTO auth.schema_migrations (version) VALUES ('20210909172000');
INSERT INTO auth.schema_migrations (version) VALUES ('20210927181326');
INSERT INTO auth.schema_migrations (version) VALUES ('20211122151130');
INSERT INTO auth.schema_migrations (version) VALUES ('20211124214934');
INSERT INTO auth.schema_migrations (version) VALUES ('20211202183645');
INSERT INTO auth.schema_migrations (version) VALUES ('20220114185221');
INSERT INTO auth.schema_migrations (version) VALUES ('20220114185340');
INSERT INTO auth.schema_migrations (version) VALUES ('20220224000811');
INSERT INTO auth.schema_migrations (version) VALUES ('20220323170000');
INSERT INTO auth.schema_migrations (version) VALUES ('20220429102000');
INSERT INTO auth.schema_migrations (version) VALUES ('20220531120530');
INSERT INTO auth.schema_migrations (version) VALUES ('20220614074223');
INSERT INTO auth.schema_migrations (version) VALUES ('20220811173540');
INSERT INTO auth.schema_migrations (version) VALUES ('20221003041349');
INSERT INTO auth.schema_migrations (version) VALUES ('20221003041400');
INSERT INTO auth.schema_migrations (version) VALUES ('20221011041400');
INSERT INTO auth.schema_migrations (version) VALUES ('20221020193600');
INSERT INTO auth.schema_migrations (version) VALUES ('20221021073300');
INSERT INTO auth.schema_migrations (version) VALUES ('20221021082433');
INSERT INTO auth.schema_migrations (version) VALUES ('20221027105023');
INSERT INTO auth.schema_migrations (version) VALUES ('20221114143122');
INSERT INTO auth.schema_migrations (version) VALUES ('20221114143410');
INSERT INTO auth.schema_migrations (version) VALUES ('20221125140132');
INSERT INTO auth.schema_migrations (version) VALUES ('20221208132122');
INSERT INTO auth.schema_migrations (version) VALUES ('20221215195500');
INSERT INTO auth.schema_migrations (version) VALUES ('20221215195800');
INSERT INTO auth.schema_migrations (version) VALUES ('20221215195900');
INSERT INTO auth.schema_migrations (version) VALUES ('20230116124310');
INSERT INTO auth.schema_migrations (version) VALUES ('20230116124412');
INSERT INTO auth.schema_migrations (version) VALUES ('20230131181311');
INSERT INTO auth.schema_migrations (version) VALUES ('20230322519590');
INSERT INTO auth.schema_migrations (version) VALUES ('20230402418590');
INSERT INTO auth.schema_migrations (version) VALUES ('20230411005111');
INSERT INTO auth.schema_migrations (version) VALUES ('20230508135423');
INSERT INTO auth.schema_migrations (version) VALUES ('20230523124323');
INSERT INTO auth.schema_migrations (version) VALUES ('20230818113222');
INSERT INTO auth.schema_migrations (version) VALUES ('20230914180801');
INSERT INTO auth.schema_migrations (version) VALUES ('20231027141322');
INSERT INTO auth.schema_migrations (version) VALUES ('20231114161723');
INSERT INTO auth.schema_migrations (version) VALUES ('20231117164230');
INSERT INTO auth.schema_migrations (version) VALUES ('20240115144230');
INSERT INTO auth.schema_migrations (version) VALUES ('20240214120130');
INSERT INTO auth.schema_migrations (version) VALUES ('20240306115329');
INSERT INTO auth.schema_migrations (version) VALUES ('20240314092811');
INSERT INTO auth.schema_migrations (version) VALUES ('20240427152123');
INSERT INTO auth.schema_migrations (version) VALUES ('20240612123726');
INSERT INTO auth.schema_migrations (version) VALUES ('20240729123726');
INSERT INTO auth.schema_migrations (version) VALUES ('20240802193726');
INSERT INTO auth.schema_migrations (version) VALUES ('20240806073726');
INSERT INTO auth.schema_migrations (version) VALUES ('20241009103726');
INSERT INTO auth.schema_migrations (version) VALUES ('20250717082212');
INSERT INTO auth.schema_migrations (version) VALUES ('20250731150234');
INSERT INTO auth.schema_migrations (version) VALUES ('20250804100000');
INSERT INTO auth.schema_migrations (version) VALUES ('20250901200500');
INSERT INTO auth.schema_migrations (version) VALUES ('20250903112500');
INSERT INTO auth.schema_migrations (version) VALUES ('20250904133000');
INSERT INTO auth.schema_migrations (version) VALUES ('20250925093508');
INSERT INTO auth.schema_migrations (version) VALUES ('20251007112900');
INSERT INTO auth.schema_migrations (version) VALUES ('20251104100000');
INSERT INTO auth.schema_migrations (version) VALUES ('20251111201300');
INSERT INTO auth.schema_migrations (version) VALUES ('20251201000000');
INSERT INTO auth.schema_migrations (version) VALUES ('20260115000000');
INSERT INTO auth.schema_migrations (version) VALUES ('20260121000000');
INSERT INTO auth.schema_migrations (version) VALUES ('20260219120000');
INSERT INTO auth.schema_migrations (version) VALUES ('20260302000000');


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

INSERT INTO auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) VALUES ('642f3c07-b80d-4ac8-8e24-57f710332e22', '8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139', '2026-05-13 16:05:05.993855+00', '2026-05-13 16:05:05.993855+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '118.68.0.62', NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

INSERT INTO auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) VALUES ('00000000-0000-0000-0000-000000000000', '8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139', 'authenticated', 'authenticated', 'vyt22052006@gmail.com', '$2a$10$JbDA/MW0CBQkMBsikTP5hOqOhY7xspiz5muNSLRCjCjwSNjEs19eu', '2026-05-13 16:05:05.985942+00', '2026-05-13 16:02:44.320839+00', '', NULL, '', NULL, '', '', NULL, '2026-05-13 16:05:05.992699+00', '{"provider": "email", "providers": ["email"]}', '{"email_verified": true}', NULL, '2026-05-08 16:26:02.151492+00', '2026-05-13 16:05:06.010965+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: -
--



--
-- Data for Name: cau_hinh_gia; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.cau_hinh_gia (id, nha_tro_id, hieu_luc_tu, gia_dien, loai_tinh_nuoc, gia_nuoc, loai_tinh_dich_vu, gia_dich_vu, loai_tinh_internet, gia_internet, tao_luc, cap_nhat_luc) VALUES ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '88888888-8888-8888-8888-888888888888', '2024-01-01', 3500.00, 'PER_METER', 20000.00, 'PER_PERSON', 50000.00, 'PER_ROOM', 100000.00, '2026-05-03 17:13:44.013465+00', '2026-05-03 17:13:44.013465+00');


--
-- Data for Name: chi_so_dien_nuoc; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: chi_tiet_hoa_don; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.chi_tiet_hoa_don (id, hoa_don_id, loai, mo_ta, so_luong, don_gia, thanh_tien, tao_luc) VALUES ('57ca29a2-f76d-423a-9660-a55494771110', 'a7c17aa4-fbe7-4133-becd-7afc57b935c0', 'ROOM', 'Tiền phòng', 1.00, 3500000.00, 3500000.00, '2026-05-12 03:41:34.754373+00');
INSERT INTO public.chi_tiet_hoa_don (id, hoa_don_id, loai, mo_ta, so_luong, don_gia, thanh_tien, tao_luc) VALUES ('df6aa81f-5e7e-4d07-87cc-ed57f1e96599', 'a7c17aa4-fbe7-4133-becd-7afc57b935c0', 'ELECTRICITY', '230-450', 220.00, 3500.00, 770000.00, '2026-05-12 03:41:34.754373+00');
INSERT INTO public.chi_tiet_hoa_don (id, hoa_don_id, loai, mo_ta, so_luong, don_gia, thanh_tien, tao_luc) VALUES ('8ad1ff21-c2a5-4bef-945d-dfe7203d8fba', 'a7c17aa4-fbe7-4133-becd-7afc57b935c0', 'WATER', '2-50', 48.00, 25000.00, 1200000.00, '2026-05-12 03:41:34.754373+00');
INSERT INTO public.chi_tiet_hoa_don (id, hoa_don_id, loai, mo_ta, so_luong, don_gia, thanh_tien, tao_luc) VALUES ('992f6b02-eabd-47ec-89ff-acf94589732c', '2e035718-688c-4f7e-99ed-572bf1c0994a', 'ROOM', 'Tiền phòng', 1.00, 3500000.00, 3500000.00, '2026-05-12 15:41:08.899536+00');
INSERT INTO public.chi_tiet_hoa_don (id, hoa_don_id, loai, mo_ta, so_luong, don_gia, thanh_tien, tao_luc) VALUES ('4ef95758-9e41-4cc0-af36-3f70d1ee3f80', '2e035718-688c-4f7e-99ed-572bf1c0994a', 'ELECTRICITY', '450-454', 4.00, 3500.00, 14000.00, '2026-05-12 15:41:08.899536+00');
INSERT INTO public.chi_tiet_hoa_don (id, hoa_don_id, loai, mo_ta, so_luong, don_gia, thanh_tien, tao_luc) VALUES ('d81a7af9-eaf5-4f23-a15a-dfad5b32e9f4', '2e035718-688c-4f7e-99ed-572bf1c0994a', 'WATER', '50-52', 2.00, 25000.00, 50000.00, '2026-05-12 15:41:08.899536+00');
INSERT INTO public.chi_tiet_hoa_don (id, hoa_don_id, loai, mo_ta, so_luong, don_gia, thanh_tien, tao_luc) VALUES ('98066231-f349-44b3-9725-780ba8ba63f3', 'f2d774a3-3c3d-4192-9c6e-b1f169b58216', 'ROOM', 'Tiền phòng', 1.00, 3500000.00, 3500000.00, '2026-05-12 16:00:09.992488+00');
INSERT INTO public.chi_tiet_hoa_don (id, hoa_don_id, loai, mo_ta, so_luong, don_gia, thanh_tien, tao_luc) VALUES ('902dace2-1c89-45d3-a92b-59bf7cf2567a', 'f2d774a3-3c3d-4192-9c6e-b1f169b58216', 'ELECTRICITY', '450-500', 50.00, 3500.00, 175000.00, '2026-05-12 16:00:09.992488+00');
INSERT INTO public.chi_tiet_hoa_don (id, hoa_don_id, loai, mo_ta, so_luong, don_gia, thanh_tien, tao_luc) VALUES ('dbff6eeb-bde7-407e-8586-7de6cb644325', 'f2d774a3-3c3d-4192-9c6e-b1f169b58216', 'WATER', '50-55', 5.00, 25000.00, 125000.00, '2026-05-12 16:00:09.992488+00');


--
-- Data for Name: chu_tro; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.chu_tro (id, nguoi_dung_id, ten_cong_ty, so_cccd, ma_so_thue, so_tai_khoan, da_xac_minh, tao_luc, cap_nhat_luc, xoa_luc) VALUES ('55555555-5555-5555-5555-555555555555', '44444444-4444-4444-4444-444444444444', 'Nha Tro Binh Dan', '012345678912', NULL, NULL, true, '2026-05-03 17:13:44.013465+00', '2026-05-03 17:13:44.013465+00', NULL);


--
-- Data for Name: dat_coc_phong; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: email_verification_token; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.email_verification_token (id, het_han_luc, tao_luc, token, used, nguoi_dung_id) VALUES ('70defa82-2d16-4a2c-a21d-4e12a74db30d', '2026-05-11 17:53:42.838792+00', '2026-05-10 17:53:45.613208+00', '755058c1-a4b6-4b75-974e-cb905f2d52dd', false, '6a6376e1-98b3-47fd-b7bb-366e30cdcd54');
INSERT INTO public.email_verification_token (id, het_han_luc, tao_luc, token, used, nguoi_dung_id) VALUES ('099951b3-de0f-4358-89d1-ea7c06470b50', '2026-05-11 17:55:42.217709+00', '2026-05-10 17:55:45.802162+00', 'bd6fd292-4bbd-41e0-a6aa-a8fd55ae30de', true, '7239cd84-f0c4-4179-bfd5-37452ffe21f3');
INSERT INTO public.email_verification_token (id, het_han_luc, tao_luc, token, used, nguoi_dung_id) VALUES ('33f21efe-d4d9-4dad-b033-79014d01cad3', '2026-05-11 18:00:36.366076+00', '2026-05-10 18:00:39.506272+00', '06c7b05c-42b8-4ee1-ac68-745fea73a7f9', false, '9fb7c659-ff6e-4f31-90b0-eb724ea682d9');
INSERT INTO public.email_verification_token (id, het_han_luc, tao_luc, token, used, nguoi_dung_id) VALUES ('a31cee95-eb26-4c2a-be93-9f119aace51a', '2026-05-11 18:33:54.672624+00', '2026-05-10 18:33:58.347688+00', '3513874a-a151-4e5c-bc11-4ed07fcc2def', true, '70397230-46ad-421d-9dbe-8f8c6dd09a97');
INSERT INTO public.email_verification_token (id, het_han_luc, tao_luc, token, used, nguoi_dung_id) VALUES ('f4521c33-339e-4eb2-b6d9-3547be52ed63', '2026-05-17 19:46:29.251773+00', '2026-05-16 19:46:42.185281+00', '80db0335-f897-4884-a12d-1422e108db00', true, 'a92ec2f4-531b-4e62-a1f0-07f0bf9c8239');


--
-- Data for Name: hoa_don; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('a7c17aa4-fbe7-4133-becd-7afc57b935c0', '5292361b-5f79-47bd-bd1e-12d38aa6682d', 'f88d6951-c957-4ff6-adff-2a3b73ef21fc', '77777777-7777-7777-7777-777777777777', '2026-05-01', 5470000.00, 5470000.00, 'PAID', '2026-05-15', '', '2026-05-12 03:41:34.748266+00', '2026-05-12 04:30:19.728371+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('2e035718-688c-4f7e-99ed-572bf1c0994a', '5292361b-5f79-47bd-bd1e-12d38aa6682d', 'f88d6951-c957-4ff6-adff-2a3b73ef21fc', '77777777-7777-7777-7777-777777777777', '2026-05-01', 3564000.00, 3564000.00, 'PAID', '2026-06-01', '', '2026-05-12 15:41:08.898005+00', '2026-05-12 15:42:52.294507+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('f2d774a3-3c3d-4192-9c6e-b1f169b58216', '5292361b-5f79-47bd-bd1e-12d38aa6682d', 'f88d6951-c957-4ff6-adff-2a3b73ef21fc', '77777777-7777-7777-7777-777777777777', '2026-05-01', 3800000.00, 1000000.00, 'PARTIAL', '2026-05-15', '', '2026-05-12 16:00:09.990983+00', '2026-05-16 17:56:47.096059+00', '2026-05-16 17:56:29.389025+00', NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('a213d948-5def-4bab-b22c-3f39d40d8cc3', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', NULL, '2026-05-12 16:33:38.103063+00', '2026-05-16 18:53:18.776648+00', '2026-05-16 18:53:00.857769+00', NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('d77b880d-7d56-403b-b605-ebe450451f27', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:18.786418+00', '2026-05-17 03:40:18.786418+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('3d67a5ff-6a74-4ee2-8025-431fb6512bf2', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:19.722963+00', '2026-05-17 03:40:19.722963+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('cb293dc9-16de-44f4-897a-569633296985', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:22.125747+00', '2026-05-17 03:40:22.125747+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('b214efa5-cad2-4e33-b26d-4ca1919ad344', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:22.306599+00', '2026-05-17 03:40:22.306599+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('a1dc6661-148f-4685-be17-bb5fc739a5e6', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:23.131243+00', '2026-05-17 03:40:23.131243+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('7b5b9b1a-a0f1-4c9c-ae30-0b83f8820647', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:24.273607+00', '2026-05-17 03:40:24.273607+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('c6150518-2cb6-4a7f-bbfe-c2ec84980002', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:24.277671+00', '2026-05-17 03:40:24.277671+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('8037f429-910b-4e34-83c7-e3af7f89add4', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:25.392033+00', '2026-05-17 03:40:25.392033+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('1ca78045-e564-4606-a81d-5d4023f73a6a', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:27.06762+00', '2026-05-17 03:40:27.06762+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('78f75369-3d43-41c8-9bb0-444e22bb0376', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:27.097525+00', '2026-05-17 03:40:27.097525+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('2ff845a2-8640-4589-872d-9d66c9280b1e', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:27.151834+00', '2026-05-17 03:40:27.151834+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('ccf771b6-8e79-453d-8072-f4114f489293', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:27.278656+00', '2026-05-17 03:40:27.278656+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('608561c4-232b-4792-8d7d-9a9f62fd2821', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:29.275612+00', '2026-05-17 03:40:29.275612+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('e022bb5e-69d4-4432-a361-738ae51a2be9', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:29.454971+00', '2026-05-17 03:40:29.454971+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('c0552c57-b535-4b51-bc41-9f3b11d457b7', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:29.660485+00', '2026-05-17 03:40:29.660485+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('c73e65cd-4262-45cf-970e-e4be265ff71f', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:29.843308+00', '2026-05-17 03:40:29.843308+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('3e8f2f64-1419-48e9-80c8-1113b224eab3', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:30.775644+00', '2026-05-17 03:40:30.775644+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('81ce1de3-0b7f-4d9a-8e78-1cc70a1fa3fa', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:31.501751+00', '2026-05-17 03:40:31.501751+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('b88955aa-0b8c-4a18-8705-0365a6075444', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:31.682684+00', '2026-05-17 03:40:31.682684+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('000ccaca-ced1-4919-99ee-fbe65bb4a317', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:32.085549+00', '2026-05-17 03:40:32.085549+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('35e35bc0-fbf3-4283-b4d5-7eab02402fb1', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:32.506568+00', '2026-05-17 03:40:32.506568+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('41facf55-b37c-40ab-b234-604fd857e845', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:34.169549+00', '2026-05-17 03:40:34.169549+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('12aaf867-5af1-4cf6-b7d5-c6297c529408', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:35.130962+00', '2026-05-17 03:40:35.130962+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('ff62ce86-2a3e-4897-9e79-c444d24269bc', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:35.497597+00', '2026-05-17 03:40:35.497597+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('259e9eac-e2e6-49de-8c09-2e548e5e3326', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:35.677259+00', '2026-05-17 03:40:35.677259+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('f796327f-1c21-4442-8162-451386a3193e', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:36.873829+00', '2026-05-17 03:40:36.873829+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('b8c925aa-1449-494f-a835-71982d9abae0', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:37.282881+00', '2026-05-17 03:40:37.282881+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('b2c69358-89e7-4b84-92ed-c0e81afc415f', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:37.928608+00', '2026-05-17 03:40:37.928608+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('db3fdd31-b238-498b-b430-b6877c1692f8', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:41.695898+00', '2026-05-17 03:40:41.695898+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('a9e4bac5-e887-41f5-886f-e8292cfa2bbd', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:41.87159+00', '2026-05-17 03:40:41.87159+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('176f9d5b-8d69-4570-93ca-0ddc9c27b717', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:42.990424+00', '2026-05-17 03:40:42.990424+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('32681780-c9ae-474b-97dc-39a234cdf938', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:43.166208+00', '2026-05-17 03:40:43.166208+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('b24aea20-68cd-4616-a4f8-c50a9914e35e', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:45.27111+00', '2026-05-17 03:40:45.27111+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('302cb4f4-a04a-41f9-8bc1-4718159ce5cb', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:46.141515+00', '2026-05-17 03:40:46.141515+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('30e0c110-e638-49de-9b8f-40addb3796a2', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:47.127546+00', '2026-05-17 03:40:47.127546+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('748d3a7b-55dd-4879-ad3f-14a4c475ea86', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:50.335458+00', '2026-05-17 03:40:50.335458+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('9471e747-b678-4e91-b2a6-db6de7eb6fce', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:50.511824+00', '2026-05-17 03:40:50.511824+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('f0c04e27-a464-465d-aed3-bf48b7801585', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:53.673729+00', '2026-05-17 03:40:53.673729+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('9ea6238c-d1f6-4d63-aced-5b9246218461', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:54.521617+00', '2026-05-17 03:40:54.521617+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('eb6233de-14b7-42fd-b6bb-890d80709548', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:55.005693+00', '2026-05-17 03:40:55.005693+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('ac7d8670-c68d-46f6-8299-a9f7ec989e5a', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:56.429392+00', '2026-05-17 03:40:56.429392+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('b2660504-696c-414c-8e61-844503c2ea3f', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:57.836181+00', '2026-05-17 03:40:57.836181+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('b8b5c55e-07e5-4994-a870-10afa2a75eb2', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:40:59.231665+00', '2026-05-17 03:40:59.231665+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('1e8a6432-cf01-4f54-bae6-601556694751', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:00.786064+00', '2026-05-17 03:41:00.786064+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('05f9f0e0-4b68-4c85-8b55-c56795852ac7', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:02.984542+00', '2026-05-17 03:41:02.984542+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('cf0e10b0-403b-44f0-974f-844ba1d9c28d', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:03.866668+00', '2026-05-17 03:41:03.866668+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('2f57512e-1caa-44ed-bad9-e73562081fe1', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:06.873627+00', '2026-05-17 03:41:06.873627+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('9adc944e-46ff-422f-986b-774a3ea86bf8', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:08.806233+00', '2026-05-17 03:41:08.806233+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('60f77e4c-5365-4888-bcce-357cac6ade7c', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:08.986272+00', '2026-05-17 03:41:08.986272+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('974d1b04-d32e-4139-bb43-a1a5eb38581d', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:10.028677+00', '2026-05-17 03:41:10.028677+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('bef2a5ab-3a33-4380-b81f-26d472d4a555', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:12.399705+00', '2026-05-17 03:41:12.399705+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('5ac3b70b-ab79-47f4-9ae7-90fcec1fd03c', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:13.008012+00', '2026-05-17 03:41:13.008012+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('512b49da-a13d-4b9e-916e-650b450ea1b4', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:13.185584+00', '2026-05-17 03:41:13.185584+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('b01b1d90-de57-4f99-b0ff-5fcf2c200423', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:16.869347+00', '2026-05-17 03:41:16.869347+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('ecb59139-7bfc-4845-98c6-8c9f2721ec37', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:17.048523+00', '2026-05-17 03:41:17.048523+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('8219e61a-e9d6-4000-9bb7-1e87673416c7', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:20.401516+00', '2026-05-17 03:41:20.401516+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('c1d5a2c4-583d-471b-a327-4353de60ebe5', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:20.578079+00', '2026-05-17 03:41:20.578079+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('6c612663-b18d-4d3e-aaca-51e2457203ef', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:20.753653+00', '2026-05-17 03:41:20.753653+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('fd32a8c8-f0c7-4ccc-b9b2-9c7d0be296cc', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:22.716324+00', '2026-05-17 03:41:22.716324+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('0e360e48-3c72-4a7d-a139-2e73e00e587f', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:26.597842+00', '2026-05-17 03:41:26.597842+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('ba86c79e-3be4-4528-83b9-ba9be0433f58', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:28.737852+00', '2026-05-17 03:41:28.737852+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('17a096c9-0746-4ad6-a08f-883b4f4a396c', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:30.985877+00', '2026-05-17 03:41:30.985877+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('66ef9e3e-2fb6-4d32-8ea3-6fca8d4b4ab6', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:38.624809+00', '2026-05-17 03:41:38.624809+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('d3e52488-5df9-4696-9564-e3cce74c36df', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:38.803237+00', '2026-05-17 03:41:38.803237+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('8ed0027c-6fc6-4186-b347-edaf059c6e21', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:41.7314+00', '2026-05-17 03:41:41.7314+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('6d5eee83-608d-488e-9a85-17ceda14b409', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:41.90798+00', '2026-05-17 03:41:41.90798+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('d9ec6a6f-acfb-4f25-a898-cb7ec8d4ca06', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:47.334771+00', '2026-05-17 03:41:47.334771+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('49f77cce-3f41-4e2b-bff4-90664c024cdc', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:48.44951+00', '2026-05-17 03:41:48.44951+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('41e4f041-7ed4-427b-93fe-123c00a72556', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:48.624741+00', '2026-05-17 03:41:48.624741+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('23dc3bb4-322f-4821-a201-b0de27f68f9e', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:48.800733+00', '2026-05-17 03:41:48.800733+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('c0194cfb-7fb2-417c-afd2-500148aa6b83', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:53.264785+00', '2026-05-17 03:41:53.264785+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('e9f2d56b-3f9d-4311-a6e1-01cc7b6a7a72', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:53.442205+00', '2026-05-17 03:41:53.442205+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('2488ddb2-90d8-4c54-b07e-06ab0d53695f', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:53.617402+00', '2026-05-17 03:41:53.617402+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('37576355-dd1b-4024-9b7d-ea8225d3b4df', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:53.79337+00', '2026-05-17 03:41:53.79337+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('cd970929-e62e-4ea7-a408-0c35c0e84af3', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:53.970795+00', '2026-05-17 03:41:53.970795+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('99ff11f5-ac07-44cd-912f-c2006a3a7584', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:54.14546+00', '2026-05-17 03:41:54.14546+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('d80a05c5-1837-4f22-b7bc-a80d7a487376', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:54.321798+00', '2026-05-17 03:41:54.321798+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('e0df4331-639e-4a39-a860-aa0e3096f907', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:54.498396+00', '2026-05-17 03:41:54.498396+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('6b9d7c9b-e4c1-4c27-8531-b3e07c212ae0', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:54.673684+00', '2026-05-17 03:41:54.673684+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('70c3caf3-5440-4b54-8077-e358c909a24c', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:54.850329+00', '2026-05-17 03:41:54.850329+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('dc18d05d-db80-43d1-aa22-e09ce4b37dff', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:55.028874+00', '2026-05-17 03:41:55.028874+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('a0cacd6c-ee6c-4ec2-8bcd-9c979acc1873', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:55.204364+00', '2026-05-17 03:41:55.204364+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('070722d1-1c26-46a9-b4d2-9d47899842f3', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:55.380495+00', '2026-05-17 03:41:55.380495+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('8914f97a-46e8-4b64-81c4-2b3b294f9c95', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:55.557208+00', '2026-05-17 03:41:55.557208+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('dd5ddcc3-d5f3-49d5-bc0e-8f0b633cf949', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:55.710069+00', '2026-05-17 03:41:55.710069+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('25bcaaf9-b7a7-4517-971e-0649efc566ee', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:55.73335+00', '2026-05-17 03:41:55.73335+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('7fe8ed64-39ed-40d3-8bc6-bad9dde2ef13', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:55.88714+00', '2026-05-17 03:41:55.88714+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('78963de6-83ef-4eaa-8ee8-2b9eda2349f7', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:55.909333+00', '2026-05-17 03:41:55.909333+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('2179cd73-7252-444e-95e0-631ecd17c9f5', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:56.063253+00', '2026-05-17 03:41:56.063253+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('869e1366-4d68-4258-8e7b-b573f13c5c84', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:56.084788+00', '2026-05-17 03:41:56.084788+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('ae9049be-80cd-48bc-ad1f-c8320157554f', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:56.23888+00', '2026-05-17 03:41:56.23888+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('f83f5f61-bcf2-473a-8261-f0ea8b30ac05', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:56.261536+00', '2026-05-17 03:41:56.261536+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('44ba94b8-d97c-4156-a924-e893ef1e3a99', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:56.414573+00', '2026-05-17 03:41:56.414573+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('c40a8ef5-29a8-4006-886f-ee52c06bab2c', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:56.437584+00', '2026-05-17 03:41:56.437584+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('4125742e-ba1f-4318-bd84-99cd9a66662a', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:56.590997+00', '2026-05-17 03:41:56.590997+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('4003ad17-68c2-4040-8d7a-2e294275e605', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:56.6138+00', '2026-05-17 03:41:56.6138+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('26ca3781-be83-4236-9e09-3abdaf0a3ec0', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:56.767122+00', '2026-05-17 03:41:56.767122+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('a496f3b8-9525-47e9-a54f-9929d09a0755', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:56.790052+00', '2026-05-17 03:41:56.790052+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('e2d12fcd-3d32-4d6e-a9b6-2196c76e88b6', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:56.943456+00', '2026-05-17 03:41:56.943456+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('60edd2a9-25a0-4227-975d-5f522ba1d008', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:56.966223+00', '2026-05-17 03:41:56.966223+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('63a923cc-0329-4c43-b3d2-45df955744d6', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:56.991056+00', '2026-05-17 03:41:56.991056+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('fa5e2fca-2271-4956-9c89-20e1c3f9fc83', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:57.119186+00', '2026-05-17 03:41:57.119186+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('5f6d0de6-1709-4e14-9e0c-b9e0443b5d6b', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:57.142521+00', '2026-05-17 03:41:57.142521+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('f9e15c21-1d40-4942-a54a-41936406e93d', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:57.173494+00', '2026-05-17 03:41:57.173494+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('94188f07-7f3b-441e-8bbd-bf7a6f671fbd', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:57.295639+00', '2026-05-17 03:41:57.295639+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('153b0047-57b4-4e82-94ad-b2252fb9608c', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:57.317769+00', '2026-05-17 03:41:57.317769+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('5d350559-334e-42e7-bdb1-4d6f7619ea94', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:57.354091+00', '2026-05-17 03:41:57.354091+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('fc122225-fe07-4474-94e6-eb3a0df3b7d5', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:57.471532+00', '2026-05-17 03:41:57.471532+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('81026de7-ab97-429c-8c7d-d45497fa6317', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:57.494519+00', '2026-05-17 03:41:57.494519+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('04cfc4f1-112e-452a-8744-01910d35cf46', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:57.533981+00', '2026-05-17 03:41:57.533981+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('c82fdbc8-3a81-44d3-a76d-65deefc8f555', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:57.647433+00', '2026-05-17 03:41:57.647433+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('87771895-da92-4223-b910-225a0e7a9b28', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:57.670714+00', '2026-05-17 03:41:57.670714+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('e3cbaa03-1104-4a2a-a0de-b9f155249777', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:57.714119+00', '2026-05-17 03:41:57.714119+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('be36798c-53dc-469f-9c00-23a1ba5b13e7', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:57.823523+00', '2026-05-17 03:41:57.823523+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('6d70e3bf-bfcd-403c-ada7-4941c5bafeaa', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:57.846534+00', '2026-05-17 03:41:57.846534+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('e1f67a70-3681-43a2-9d81-072aefcfea7d', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:57.895035+00', '2026-05-17 03:41:57.895035+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('e6ce8825-3b6e-4bfb-a4ae-d975e3f306a8', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:58.000043+00', '2026-05-17 03:41:58.000043+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('757bde81-bcbb-48af-bf32-115aa64f6725', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:58.022967+00', '2026-05-17 03:41:58.022967+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('ebb51604-b9c2-4271-8fcf-ad121f039d53', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:58.075215+00', '2026-05-17 03:41:58.075215+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('cf253547-e57f-42eb-bf50-1a761d56e158', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:58.177162+00', '2026-05-17 03:41:58.177162+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('56554a05-f6cd-4e6c-b2ad-ea92540abd92', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:58.202186+00', '2026-05-17 03:41:58.202186+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('656a807f-b1f0-484a-95ed-545b170b973d', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:58.255809+00', '2026-05-17 03:41:58.255809+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('a2083a95-e565-45cf-8c68-b0e58eb91d57', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:58.290865+00', '2026-05-17 03:41:58.290865+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('aaa35436-9811-48a1-aa8b-9b38ee6e6634', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:58.352591+00', '2026-05-17 03:41:58.352591+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('11b17a01-905e-4819-99fb-29002ea128d1', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:58.378801+00', '2026-05-17 03:41:58.378801+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('154063de-5dc5-41fc-8472-11dd01233b0a', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:58.437435+00', '2026-05-17 03:41:58.437435+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('6adae7f2-3eda-46c9-9906-ff5fda6b19d1', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:58.468302+00', '2026-05-17 03:41:58.468302+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('a46d9f7e-1fcf-4dbb-a5ec-f6c5c8e911be', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:58.531288+00', '2026-05-17 03:41:58.531794+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('a3947e16-a0c2-48cf-9b69-2fe8fa769299', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:58.556286+00', '2026-05-17 03:41:58.556286+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('3dc568ab-9708-48c1-ac2f-e51db711f39b', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:58.62038+00', '2026-05-17 03:41:58.62038+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);
INSERT INTO public.hoa_don (id, phong_id, hop_dong_id, khach_thue_id, thang_hoa_don, tong_tien, da_tra, trang_thai, han_tra, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, ma_hoa_don, ngay_phat_hanh, ngay_gui, da_gui, tien_giam, phi_phat_sinh) VALUES ('353e7b28-7be4-47b0-a342-353aa58268ec', NULL, NULL, NULL, '2026-05-01', 0.00, 0.00, 'UNPAID', '2026-06-01', 'Load testing by k6', '2026-05-17 03:41:58.711705+00', '2026-05-17 03:41:58.711705+00', NULL, NULL, '2026-05-19', NULL, false, 0.00, 0.00);


--
-- Data for Name: hop_dong; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.hop_dong (id, phong_id, khach_thue_id, ngay_bat_dau, ngay_ket_thuc, gia_thue_hop_dong, tien_coc, trang_thai_coc, so_tien_hoan_coc, ngay_hoan_coc, trang_thai, noi_dung_hop_dong, file_pdf, chu_ky_chu_tro, chu_ky_khach_thue, tao_luc, cap_nhat_luc, xoa_luc, chi_so_dien_ban_dau, chi_so_nuoc_ban_dau, chu_ky_thanh_toan, dieu_khoan, file_hop_dong, gia_dien, gia_nuoc, khach_thue_ids, ma_hop_dong, ngay_thanh_toan, phi_dich_vu) VALUES ('fda750f3-0399-4dff-b060-015d467bfa08', '99999999-9999-9999-9999-999999999999', '60a7602c-d934-4fe5-9ff1-b51f3fe5b3fb', '2026-05-16', '2026-08-16', 2500000.00, 0.00, 'KEPT', 0.00, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2026-05-16 17:55:38.185392+00', '2026-05-16 17:55:38.185392+00', NULL, 0, 0, 'thang', 'ĐIỀU KHOẢN HỢP ĐỒNG THUÊ PHÒNG

1. BÊN CHO THUÊ (Chủ nhà):
- Cung cấp phòng ở đầy đủ tiện nghi theo thỏa thuận
- Đảm bảo an ninh, an toàn cho khách thuê
- Bảo trì, sửa chữa các hư hỏng do hao mòn tự nhiên

2. BÊN THUÊ (Khách thuê):
- Thanh toán đúng hạn tiền thuê và các chi phí khác
- Sử dụng phòng đúng mục đích, giữ gìn vệ sinh
- Không được cải tạo, sửa chữa phòng mà không có sự đồng ý
- Báo cáo kịp thời các hư hỏng, sự cố

3. ĐIỀU KHOẢN CHUNG:
- Thời hạn hợp đồng: Từ ngày bắt đầu đến ngày kết thúc
- Tiền cọc: Được hoàn trả khi kết thúc hợp đồng (trừ các khoản phát sinh)
- Thanh toán: Hàng tháng vào ngày quy định
- Điện, nước: Tính theo chỉ số đồng hồ và giá quy định
- Phí dịch vụ: Theo thỏa thuận riêng

4. CHẤM DỨT HỢP ĐỒNG:
- Bên thuê có thể chấm dứt hợp đồng trước thời hạn với thông báo trước 30 ngày
- Bên cho thuê có thể chấm dứt hợp đồng nếu vi phạm nghiêm trọng
- Hoàn trả tiền cọc sau khi kiểm tra tình trạng phòng

5. ĐIỀU KHOẢN KHÁC:
- Hai bên cam kết thực hiện đúng các điều khoản đã thỏa thuận
- Mọi tranh chấp sẽ được giải quyết thông qua thương lượng
- Hợp đồng có hiệu lực kể từ ngày ký', NULL, 3500.00, 25000.00, '["60a7602c-d934-4fe5-9ff1-b51f3fe5b3fb"]', 'HD003', 15, '[]');
INSERT INTO public.hop_dong (id, phong_id, khach_thue_id, ngay_bat_dau, ngay_ket_thuc, gia_thue_hop_dong, tien_coc, trang_thai_coc, so_tien_hoan_coc, ngay_hoan_coc, trang_thai, noi_dung_hop_dong, file_pdf, chu_ky_chu_tro, chu_ky_khach_thue, tao_luc, cap_nhat_luc, xoa_luc, chi_so_dien_ban_dau, chi_so_nuoc_ban_dau, chu_ky_thanh_toan, dieu_khoan, file_hop_dong, gia_dien, gia_nuoc, khach_thue_ids, ma_hop_dong, ngay_thanh_toan, phi_dich_vu) VALUES ('f88d6951-c957-4ff6-adff-2a3b73ef21fc', '5292361b-5f79-47bd-bd1e-12d38aa6682d', '77777777-7777-7777-7777-777777777777', '2026-05-12', '2027-05-12', 3500000.00, 1000000.00, 'KEPT', 0.00, NULL, 'ACTIVE', NULL, NULL, NULL, NULL, '2026-05-12 02:35:20.841397+00', '2026-05-16 18:22:47.655279+00', NULL, 230, 2, 'thang', 'ĐIỀU KHOẢN HỢP ĐỒNG THUÊ PHÒNG

1. BÊN CHO THUÊ (Chủ nhà):
- Cung cấp phòng ở đầy đủ tiện nghi theo thỏa thuận
- Đảm bảo an ninh, an toàn cho khách thuê
- Bảo trì, sửa chữa các hư hỏng do hao mòn tự nhiên

2. BÊN THUÊ (Khách thuê):
- Thanh toán đúng hạn tiền thuê và các chi phí khác
- Sử dụng phòng đúng mục đích, giữ gìn vệ sinh
- Không được cải tạo, sửa chữa phòng mà không có sự đồng ý
- Báo cáo kịp thời các hư hỏng, sự cố

3. ĐIỀU KHOẢN CHUNG:
- Thời hạn hợp đồng: Từ ngày bắt đầu đến ngày kết thúc
- Tiền cọc: Được hoàn trả khi kết thúc hợp đồng (trừ các khoản phát sinh)
- Thanh toán: Hàng tháng vào ngày quy định
- Điện, nước: Tính theo chỉ số đồng hồ và giá quy định
- Phí dịch vụ: Theo thỏa thuận riêng

4. CHẤM DỨT HỢP ĐỒNG:
- Bên thuê có thể chấm dứt hợp đồng trước thời hạn với thông báo trước 30 ngày
- Bên cho thuê có thể chấm dứt hợp đồng nếu vi phạm nghiêm trọng
- Hoàn trả tiền cọc sau khi kiểm tra tình trạng phòng

5. ĐIỀU KHOẢN KHÁC:
- Hai bên cam kết thực hiện đúng các điều khoản đã thỏa thuận
- Mọi tranh chấp sẽ được giải quyết thông qua thương lượng
- Hợp đồng có hiệu lực kể từ ngày ký', NULL, 3500.00, 25000.00, '["77777777-7777-7777-7777-777777777777"]', 'HD001', 15, '[]');


--
-- Data for Name: khach_thue; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.khach_thue (id, nguoi_dung_id, so_cccd, lien_he_khan_cap, ngay_sinh, dia_chi_thuong_tru, nghe_nghiep, tao_luc, cap_nhat_luc, xoa_luc, anh_cccd, email, gioi_tinh, mat_khau, que_quan, trang_thai, ho_ten, so_dien_thoai, anh_cccd_sau, anh_cccd_truoc) VALUES ('77777777-7777-7777-7777-777777777777', '66666666-6666-6666-6666-666666666666', '098765432109', '0911223344', '2006-01-01', 'Hà Nội', 'Học Sinh', '2026-05-03 17:13:44.013465+00', '2026-05-08 15:39:00.940205+00', NULL, '{"matSau": "", "matTruoc": ""}', 'docong989@gmail.com', 'nam', 'Badao989@', NULL, NULL, 'do chi cong', '0912345678', NULL, NULL);
INSERT INTO public.khach_thue (id, nguoi_dung_id, so_cccd, lien_he_khan_cap, ngay_sinh, dia_chi_thuong_tru, nghe_nghiep, tao_luc, cap_nhat_luc, xoa_luc, anh_cccd, email, gioi_tinh, mat_khau, que_quan, trang_thai, ho_ten, so_dien_thoai, anh_cccd_sau, anh_cccd_truoc) VALUES ('d2184234-eabe-479d-8b5e-d69b12046189', '52a46682-e118-4c46-b770-edcb02361493', '177842914099', '0900000000', NULL, 'Ha Noi', 'QA Engineer', '2026-05-10 16:05:47.550047+00', '2026-05-10 16:05:49.898367+00', '2026-05-10 16:05:49.577147+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.khach_thue (id, nguoi_dung_id, so_cccd, lien_he_khan_cap, ngay_sinh, dia_chi_thuong_tru, nghe_nghiep, tao_luc, cap_nhat_luc, xoa_luc, anh_cccd, email, gioi_tinh, mat_khau, que_quan, trang_thai, ho_ten, so_dien_thoai, anh_cccd_sau, anh_cccd_truoc) VALUES ('bb7250a0-d68c-49de-9379-d46ab5a0452e', '82c53316-39b2-4ef9-a401-1f9fa103ed83', '177842928199', '0900000000', NULL, 'Ha Noi', 'QA Engineer', '2026-05-10 16:08:03.443438+00', '2026-05-10 16:08:09.792993+00', '2026-05-10 16:08:09.550223+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.khach_thue (id, nguoi_dung_id, so_cccd, lien_he_khan_cap, ngay_sinh, dia_chi_thuong_tru, nghe_nghiep, tao_luc, cap_nhat_luc, xoa_luc, anh_cccd, email, gioi_tinh, mat_khau, que_quan, trang_thai, ho_ten, so_dien_thoai, anh_cccd_sau, anh_cccd_truoc) VALUES ('1fc260d8-0b95-4a3f-af48-15fc4913cc32', '88e1fdb9-0e8c-41dd-93f6-3c25dc3a1ea7', '123456787917', '0999888777', '2000-01-01', 'Ha Noi', 'Tester', '2026-05-10 18:05:10.584337+00', '2026-05-10 18:05:13.445379+00', '2026-05-10 18:05:13.112523+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.khach_thue (id, nguoi_dung_id, so_cccd, lien_he_khan_cap, ngay_sinh, dia_chi_thuong_tru, nghe_nghiep, tao_luc, cap_nhat_luc, xoa_luc, anh_cccd, email, gioi_tinh, mat_khau, que_quan, trang_thai, ho_ten, so_dien_thoai, anh_cccd_sau, anh_cccd_truoc) VALUES ('60a7602c-d934-4fe5-9ff1-b51f3fe5b3fb', '701b1e13-4448-47d4-8f84-f283bda2607e', '098765432108', NULL, '2000-01-17', 'bắc giang', 'Học Sinh', '2026-05-16 17:25:01.649355+00', '2026-05-16 17:25:01.649355+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '');
INSERT INTO public.khach_thue (id, nguoi_dung_id, so_cccd, lien_he_khan_cap, ngay_sinh, dia_chi_thuong_tru, nghe_nghiep, tao_luc, cap_nhat_luc, xoa_luc, anh_cccd, email, gioi_tinh, mat_khau, que_quan, trang_thai, ho_ten, so_dien_thoai, anh_cccd_sau, anh_cccd_truoc) VALUES ('d08c3e78-efbb-4d17-9d7a-72c426623a86', '18b76926-cc76-472a-acb0-b47e631a45e1', '099999999991', NULL, '2000-12-23', 'An Giang', 'Bartender', '2026-05-16 17:35:37.645592+00', '2026-05-16 17:35:37.645592+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '');


--
-- Data for Name: lich_hen; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: lich_su_hoa_don; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.lich_su_hoa_don (id, hoa_don_id, trang_thai_truoc, trang_thai_moi, nguoi_thay_doi, ghi_chu, tao_luc) VALUES ('dd081b00-ed7e-4604-88b3-9d1fc57a5f9c', 'a7c17aa4-fbe7-4133-becd-7afc57b935c0', 'UNPAID', 'PAID', NULL, 'He thong tu dong cap nhat', '2026-05-12 04:30:19.728371+00');
INSERT INTO public.lich_su_hoa_don (id, hoa_don_id, trang_thai_truoc, trang_thai_moi, nguoi_thay_doi, ghi_chu, tao_luc) VALUES ('fc11d595-f4ab-4e86-bfcc-d446de60cff0', '2e035718-688c-4f7e-99ed-572bf1c0994a', 'UNPAID', 'PAID', NULL, 'He thong tu dong cap nhat', '2026-05-12 15:42:52.294507+00');


--
-- Data for Name: nguoi_dung; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('44444444-4444-4444-4444-444444444444', 'landlord@example.com', 'hashed_pw', 'Nguyen Van Chu', '0901234567', NULL, NULL, NULL, 'ACTIVE', '2026-05-03 17:13:44.013465+00', '2026-05-03 17:13:44.013465+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('995636ed-bcd0-4aca-9038-c7f1134fded8', 'test@example.com', '$2a$10$24x32Na5hac9JPN7NQeZburBG50A3fJiv4YmozBQaH1m.zhzlV8/K', 'Test User', '0123456789', NULL, NULL, NULL, 'ACTIVE', '2026-05-03 17:35:35.710536+00', '2026-05-03 17:35:35.710536+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('176e4d76-ed79-4f99-99af-d3e0979ffb24', 'test2@example.com', '$2a$10$qN0gZOS6TS6Ew9t40tZFTuwZzrAA.QF5LIVYWFB6PPZi5ZKlW1L2S', 'Test 2', '0987654329', NULL, NULL, NULL, 'ACTIVE', '2026-05-03 17:36:00.656316+00', '2026-05-03 17:36:00.656316+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('302242ef-a8a2-4b33-8ee9-3502f551ee24', 'test3@example.com', '$2a$10$YBTmR474ZLdNyHWIFmoQaOOyRMa2JKVW8WOUKv7XduWrFVEY6Lfoe', 'Test 3', '0987654311', NULL, NULL, NULL, 'ACTIVE', '2026-05-03 17:57:52.49822+00', '2026-05-03 17:57:52.49822+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('b850675f-4348-4f0a-8727-f660ce72ae55', 'nguyenvana@test.com', '$2a$10$4Vf/UBLQQ/0YkmHuq4hF4u1THwf.B.yeNgZIiY1jQJlfaY3Z8xRBG', 'Nguyen Van A', '0912345678', NULL, NULL, NULL, 'ACTIVE', '2026-05-03 18:00:18.212407+00', '2026-05-03 18:00:18.212407+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('1a048652-538f-4724-98cc-3e3b4623488b', 'tranthib2@test.com', '$2a$10$o31UsLSBs0CJ7/lQvRgahOsj79G8odggTVF4lROOpeTsUHbETysSW', 'Tran Thi B', '0907654321', NULL, NULL, NULL, 'ACTIVE', '2026-05-03 18:05:38.964994+00', '2026-05-03 18:05:38.964994+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('04ad4a99-7cd2-4d39-a208-a74162c97168', 'levanc@test.com', '$2a$10$v13mbsEcw24x8.vb4ZGBSe8dE4W1noAaiQkiiek53f4Is944hIgv2', 'Le Van C', '0999888777', NULL, NULL, NULL, 'ACTIVE', '2026-05-03 18:07:39.02262+00', '2026-05-03 18:07:39.02262+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('06758f94-a29d-48e3-bba3-f85f1a6f3198', 'vyt22052006@gmail.com', '$2a$10$3Wyofx2AfU3/BW8UbHhSYOMcDDw6kwEJTLAPSSDQpLqTmVXuPFwi6', 'Vy Tran', '0932205206', NULL, NULL, NULL, 'ACTIVE', '2026-05-10 15:08:11.168541+00', '2026-05-10 15:08:11.168541+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('52a46682-e118-4c46-b770-edcb02361493', 'autotenant1778429140@example.com', 'Auto@123456', 'Auto Tenant Updated', '0917784291', NULL, NULL, 'male', 'ACTIVE', '2026-05-10 16:05:47.442218+00', '2026-05-10 16:05:49.27287+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('82c53316-39b2-4ef9-a401-1f9fa103ed83', 'autotenant1778429281@example.com', 'Auto@123456', 'Auto Tenant Updated', '0917784292', NULL, NULL, 'male', 'ACTIVE', '2026-05-10 16:08:03.16859+00', '2026-05-10 16:08:07.12228+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('6a6376e1-98b3-47fd-b7bb-366e30cdcd54', 'test.gmail@example.com', '$2a$10$J3Sj8cz2EcFLIf019QeHnuIZLbYsH5QV417x06rjmqX/S5f/0b5nS', 'Test Gmail User', '0999999999', NULL, NULL, NULL, 'INACTIVE', '2026-05-10 17:53:45.484273+00', '2026-05-10 17:53:45.484273+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('7239cd84-f0c4-4179-bfd5-37452ffe21f3', 'vyttt22052006@gmail.com', '$2a$10$5ihfuXms/KF0WbGm83CEsOdW/HV/f34BpqWK0qWK.CvimWWHSYyOG', 'Trần Triệu Vỹ', '0374729356', NULL, NULL, NULL, 'ACTIVE', '2026-05-10 17:55:45.698256+00', '2026-05-10 17:56:22.584726+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('9fb7c659-ff6e-4f31-90b0-eb724ea682d9', 'smoke030048@gmail.com', '$2a$10$4NKO54XYgxdNe7HLHcl9euA4x9h0w60gRBkkNDuG49jCTVJn3FmxO', 'Smoke Test User', '0903004899', NULL, NULL, NULL, 'INACTIVE', '2026-05-10 18:00:39.414327+00', '2026-05-10 18:00:39.414327+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('88e1fdb9-0e8c-41dd-93f6-3c25dc3a1ea7', 'smokekhach7917@gmail.com', 'Test@1234', 'Smoke Khach Updated 7917', '0879177917', NULL, NULL, 'nam', 'ACTIVE', '2026-05-10 18:05:10.483905+00', '2026-05-10 18:05:11.831897+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('70397230-46ad-421d-9dbe-8f8c6dd09a97', 'tranvyclone1@gmail.com', '$2a$10$pX.Yy5Jyg2s.dHLXYGOyi.2X4yg7NKGhCqCtSb4sa5GtIB8KpDRf.', 'Trần Triệu Vỹ Nhân Viên', '0374729357', NULL, NULL, NULL, 'ACTIVE', '2026-05-10 18:33:58.207258+00', '2026-05-10 18:34:20.430377+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('66666666-6666-6666-6666-666666666666', 'tenant@example.com', 'hashed_pw', 'Tran Van Khach', '0987654321', NULL, NULL, 'nam', 'ACTIVE', '2026-05-03 17:13:44.013465+00', '2026-05-12 01:43:38.763076+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('18b76926-cc76-472a-acb0-b47e631a45e1', 'hoangphucminh231205@gmail.com', 'Badao989@', 'hang thi truc giang', '0396822875', NULL, NULL, 'nu', 'ACTIVE', '2026-05-16 17:35:37.546977+00', '2026-05-16 17:35:37.546977+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('426ef5ed-8a99-4643-8978-170b24a4238c', 'docong989@gmail.com', '$2a$10$ksqa6nukmnf1K.JmZQuie.WrxCCPr6OCPKx92vxVJWw8r1Xnk9PTe', 'do chi cong', '0369963725', '', NULL, NULL, 'ACTIVE', '2026-05-04 09:51:08.950796+00', '2026-05-16 18:39:57.452786+00', NULL, '79 cầu giấy, Phường Quan Hoa, Quận Cầu Giấy, Thành phố Hà Nội', NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('a92ec2f4-531b-4e62-a1f0-07f0bf9c8239', 'docong989@icloud.com', '$2a$10$wvUZpCJERiAsuvqRtrB7POpVt1AdxU7RZs.aB/ycynRwiA2D8SB36', 'do chi cong', '0912345677', NULL, NULL, NULL, 'ACTIVE', '2026-05-16 19:46:42.091916+00', '2026-05-16 19:47:40.98409+00', NULL, NULL, NULL);
INSERT INTO public.nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, dia_chi, que_quan) VALUES ('701b1e13-4448-47d4-8f84-f283bda2607e', 'gtruc2146@gmail.com', '$2a$10$wHUYv7Sdryd5MMAjml2ezesLsVMkcjOFjCnV2YlAE755E2zMCPlFy', 'do chi cong', '0357165019', NULL, NULL, 'nam', 'ACTIVE', '2026-05-16 17:25:01.555345+00', '2026-05-19 16:25:31.668177+00', NULL, NULL, NULL);


--
-- Data for Name: nguoi_dung_vai_tro; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('44444444-4444-4444-4444-444444444444', '22222222-2222-2222-2222-222222222222');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('66666666-6666-6666-6666-666666666666', '33333333-3333-3333-3333-333333333333');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('995636ed-bcd0-4aca-9038-c7f1134fded8', '22222222-2222-2222-2222-222222222222');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('176e4d76-ed79-4f99-99af-d3e0979ffb24', '11111111-1111-1111-1111-111111111111');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('302242ef-a8a2-4b33-8ee9-3502f551ee24', '22222222-2222-2222-2222-222222222222');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('b850675f-4348-4f0a-8727-f660ce72ae55', '22222222-2222-2222-2222-222222222222');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('1a048652-538f-4724-98cc-3e3b4623488b', '11111111-1111-1111-1111-111111111111');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('04ad4a99-7cd2-4d39-a208-a74162c97168', '22222222-2222-2222-2222-222222222222');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('06758f94-a29d-48e3-bba3-f85f1a6f3198', '33333333-3333-3333-3333-333333333333');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('52a46682-e118-4c46-b770-edcb02361493', '33333333-3333-3333-3333-333333333333');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('82c53316-39b2-4ef9-a401-1f9fa103ed83', '33333333-3333-3333-3333-333333333333');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('6a6376e1-98b3-47fd-b7bb-366e30cdcd54', '22222222-2222-2222-2222-222222222222');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('7239cd84-f0c4-4179-bfd5-37452ffe21f3', '22222222-2222-2222-2222-222222222222');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('9fb7c659-ff6e-4f31-90b0-eb724ea682d9', '22222222-2222-2222-2222-222222222222');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('88e1fdb9-0e8c-41dd-93f6-3c25dc3a1ea7', '33333333-3333-3333-3333-333333333333');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('70397230-46ad-421d-9dbe-8f8c6dd09a97', '11111111-1111-1111-1111-111111111111');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('701b1e13-4448-47d4-8f84-f283bda2607e', '33333333-3333-3333-3333-333333333333');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('18b76926-cc76-472a-acb0-b47e631a45e1', '33333333-3333-3333-3333-333333333333');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('426ef5ed-8a99-4643-8978-170b24a4238c', '11111111-1111-1111-1111-111111111111');
INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id) VALUES ('a92ec2f4-531b-4e62-a1f0-07f0bf9c8239', '33333333-3333-3333-3333-333333333333');


--
-- Data for Name: nha_tro; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.nha_tro (id, chu_tro_id, ten, dia_chi, tinh, huyen, xa, mo_ta, tao_luc, cap_nhat_luc, xoa_luc, tien_nghi_chung, duong, phuong, quan, so_nha, thanh_pho) VALUES ('474f24e5-db8a-458f-9c98-cf37b84073b9', NULL, 'Lammark72', '99 Phạm Hùng', 'Thành phố Hà Nội', 'Quận Nam Từ Liêm', 'Phường Mỹ Đình 2', '', '2026-05-10 15:21:17.659192+00', '2026-05-15 18:27:34.864451+00', NULL, 'camera,giuXe,sanPhoi', NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.nha_tro (id, chu_tro_id, ten, dia_chi, tinh, huyen, xa, mo_ta, tao_luc, cap_nhat_luc, xoa_luc, tien_nghi_chung, duong, phuong, quan, so_nha, thanh_pho) VALUES ('88888888-8888-8888-8888-888888888888', '55555555-5555-5555-5555-555555555555', 'Khu Tro Hoa Binh', '19  Nguyen Trai', 'Ha Noi', 'Thanh Xuan', 'Thanh Xuan Bac', '', '2026-05-03 17:13:44.013465+00', '2026-05-15 18:27:52.018798+00', NULL, 'camera,wifi,giuXe,sanPhoi,khuBepChung', NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.nha_tro (id, chu_tro_id, ten, dia_chi, tinh, huyen, xa, mo_ta, tao_luc, cap_nhat_luc, xoa_luc, tien_nghi_chung, duong, phuong, quan, so_nha, thanh_pho) VALUES ('26cecb52-a89f-4088-98b3-80752c4ed603', NULL, 'Lammark73', '55 Phạm Hùng', 'Thành phố Hà Nội', 'Quận Nam Từ Liêm', 'Phường Mỹ Đình 2', '', '2026-05-10 15:32:11.732333+00', '2026-05-15 18:28:34.599898+00', NULL, 'camera,giuXe,sanPhoi,khuBepChung', NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.nha_tro (id, chu_tro_id, ten, dia_chi, tinh, huyen, xa, mo_ta, tao_luc, cap_nhat_luc, xoa_luc, tien_nghi_chung, duong, phuong, quan, so_nha, thanh_pho) VALUES ('dc233ef5-408c-45fb-8616-cdb34524732f', NULL, 'Lammark74', '55 Phạm Hùng', 'Thành phố Hà Nội', 'Quận Nam Từ Liêm', 'Phường Mỹ Đình 2', '', '2026-05-10 15:34:22.458028+00', '2026-05-15 18:29:02.070451+00', NULL, 'wifi,baoVe,giuXe,camera', NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.nha_tro (id, chu_tro_id, ten, dia_chi, tinh, huyen, xa, mo_ta, tao_luc, cap_nhat_luc, xoa_luc, tien_nghi_chung, duong, phuong, quan, so_nha, thanh_pho) VALUES ('55478bcd-38c8-4c37-bfe3-2686c7d9fed9', NULL, 'Lammark72', '99 Phạm Hùng', 'Thành phố Hà Nội', 'Quận Nam Từ Liêm', 'Phường Mỹ Đình 1', '', '2026-05-10 15:20:57.499628+00', '2026-05-15 18:29:29.867295+00', NULL, 'camera,giuXe,sanPhoi', NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.nha_tro (id, chu_tro_id, ten, dia_chi, tinh, huyen, xa, mo_ta, tao_luc, cap_nhat_luc, xoa_luc, tien_nghi_chung, duong, phuong, quan, so_nha, thanh_pho) VALUES ('54c98f7b-f27f-451f-9c4f-9de631715273', NULL, 'HH3A', '151  Nguyễn Đức Cảnh', 'Thành phố Hà Nội', 'Quận Ba Đình', 'Phường Phúc Xá', 'new', '2026-05-15 18:09:55.166777+00', '2026-05-15 18:29:48.340927+00', NULL, 'camera,giuXe,sanPhoi,khuBepChung', NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.nha_tro (id, chu_tro_id, ten, dia_chi, tinh, huyen, xa, mo_ta, tao_luc, cap_nhat_luc, xoa_luc, tien_nghi_chung, duong, phuong, quan, so_nha, thanh_pho) VALUES ('0ee21eed-3ead-4e30-9a37-eddfb056d3ea', NULL, 'HH1A', '22 Băng liệt', 'Thành phố Hà Nội', 'Quận Hoàng Mai', 'Phường Lĩnh Nam', 'chung cư', '2026-05-16 16:44:41.540712+00', '2026-05-16 16:46:16.231292+00', NULL, 'wifi,sanPhoi,giuXe,khuBepChung,camera,baoVe,thangMay,nhaVeSinhChung', NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: phong; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.phong (id, nha_tro_id, ten, tang, dien_tich, so_nguoi_toi_da, trang_thai, gia_hien_tai, tien_coc_mac_dinh, mo_ta, tao_luc, cap_nhat_luc, xoa_luc, anh_phong, tien_nghi) VALUES ('01b5e58f-1e4c-4745-ac96-9e54b9978724', 'dc233ef5-408c-45fb-8616-cdb34524732f', 'PHÒNG NGON ', 1, 500.00, 2, 'AVAILABLE', 10000000.00, 10000000.00, 'ngon', '2026-05-10 15:36:59.742707+00', '2026-05-10 15:36:59.742707+00', NULL, '["https://res.cloudinary.com/dlkh28yfs/image/upload/v1778427332/quanlyphongtro/dmj4rgcry9csdhcfbqrh.jpg"]', '["dieuhoa", "nonglanh", "banlamviec", "tulanh", "tuquanao"]');
INSERT INTO public.phong (id, nha_tro_id, ten, tang, dien_tich, so_nguoi_toi_da, trang_thai, gia_hien_tai, tien_coc_mac_dinh, mo_ta, tao_luc, cap_nhat_luc, xoa_luc, anh_phong, tien_nghi) VALUES ('5292361b-5f79-47bd-bd1e-12d38aa6682d', '55478bcd-38c8-4c37-bfe3-2686c7d9fed9', 'MPSD01', 2, 12.00, 5, 'RENTED', 3500004.00, 1000003.00, 'phong moi xay', '2026-05-12 01:25:28.612746+00', '2026-05-15 17:07:10.023424+00', NULL, '["https://res.cloudinary.com/dlkh28yfs/image/upload/v1778549183/quanlyphongtro/pim2fhlzpxx7v6lwmzaz.jpg", "https://res.cloudinary.com/dlkh28yfs/image/upload/v1778549187/quanlyphongtro/nvkw1uctpylf9og0c7vv.jpg", "https://res.cloudinary.com/dlkh28yfs/image/upload/v1778863984/quanlyphongtro/kteicbw5qc3bqjdmodhf.jpg"]', '["dieuhoa", "giuong", "tuquanao", "nonglanh", "banlamviec", "noi"]');
INSERT INTO public.phong (id, nha_tro_id, ten, tang, dien_tich, so_nguoi_toi_da, trang_thai, gia_hien_tai, tien_coc_mac_dinh, mo_ta, tao_luc, cap_nhat_luc, xoa_luc, anh_phong, tien_nghi) VALUES ('99999999-9999-9999-9999-999999999999', '88888888-8888-8888-8888-888888888888', 'Phong 101', 1, 25.00, 3, 'RENTED', 2500000.00, 0.00, '', '2026-05-03 17:13:44.013465+00', '2026-05-16 17:55:55.885788+00', NULL, '[]', '["dieuhoa", "giuong", "tuquanao"]');


--
-- Data for Name: phong_tien_ich; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: su_co; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.su_co (id, phong_id, khach_thue_id, tieu_de, mo_ta, loai_su_co, uu_tien, trang_thai, nguoi_phu_trach, chi_phi_sua_chua, ghi_chu_chu_nha, giai_quyet_luc, tao_luc, cap_nhat_luc, anh_su_co) VALUES ('52806772-f2ba-4e24-aad2-8955bb2937e5', '5292361b-5f79-47bd-bd1e-12d38aa6682d', '77777777-7777-7777-7777-777777777777', 'hong nuoc', 'ro ri', 'dien_nuoc', 'trung_binh', 'PENDING', NULL, NULL, '', NULL, '2026-05-16 19:42:59.14688+00', '2026-05-16 19:42:59.14688+00', '["https://res.cloudinary.com/dlkh28yfs/image/upload/v1778960576/quanlyphongtro/qcwrqvhnnehbkdvqasds.webp"]');
INSERT INTO public.su_co (id, phong_id, khach_thue_id, tieu_de, mo_ta, loai_su_co, uu_tien, trang_thai, nguoi_phu_trach, chi_phi_sua_chua, ghi_chu_chu_nha, giai_quyet_luc, tao_luc, cap_nhat_luc, anh_su_co) VALUES ('d2db8dd6-a9de-4583-92b2-4209b318f046', '99999999-9999-9999-9999-999999999999', '60a7602c-d934-4fe5-9ff1-b51f3fe5b3fb', 'hong cua', 'ban le', 'noi_that', 'trung_binh', 'PENDING', NULL, NULL, '', NULL, '2026-05-16 19:43:33.101182+00', '2026-05-16 19:43:33.101182+00', '["https://res.cloudinary.com/dlkh28yfs/image/upload/v1778960610/quanlyphongtro/ggyil5kxa6zvlc3miyki.jpg"]');
INSERT INTO public.su_co (id, phong_id, khach_thue_id, tieu_de, mo_ta, loai_su_co, uu_tien, trang_thai, nguoi_phu_trach, chi_phi_sua_chua, ghi_chu_chu_nha, giai_quyet_luc, tao_luc, cap_nhat_luc, anh_su_co) VALUES ('ff303459-2297-4c95-adcc-5df6f1821b4c', '5292361b-5f79-47bd-bd1e-12d38aa6682d', '77777777-7777-7777-7777-777777777777', 've sinh', 'rac bua bai', 've_sinh', 'thap', 'PENDING', NULL, NULL, '', NULL, '2026-05-16 19:45:11.771368+00', '2026-05-16 19:45:11.771368+00', '["https://res.cloudinary.com/dlkh28yfs/image/upload/v1778960709/quanlyphongtro/os5mpeyi9pdfewsjhvrv.jpg"]');
INSERT INTO public.su_co (id, phong_id, khach_thue_id, tieu_de, mo_ta, loai_su_co, uu_tien, trang_thai, nguoi_phu_trach, chi_phi_sua_chua, ghi_chu_chu_nha, giai_quyet_luc, tao_luc, cap_nhat_luc, anh_su_co) VALUES ('5e26267d-b8d9-4787-b8d8-cd5d167fecc2', '5292361b-5f79-47bd-bd1e-12d38aa6682d', '77777777-7777-7777-7777-777777777777', 'an ninh', 'khoa ri', 'an_ninh', 'cao', 'PENDING', NULL, NULL, '', NULL, '2026-05-16 19:47:00.630007+00', '2026-05-16 19:47:00.630007+00', '["https://res.cloudinary.com/dlkh28yfs/image/upload/v1778960816/quanlyphongtro/hdr9ylw6a2ftxavkqlt5.jpg"]');


--
-- Data for Name: thanh_toan; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.thanh_toan (id, hoa_don_id, so_tien, ngay_thanh_toan, phuong_thuc_thanh_toan, ma_tham_chieu, trang_thai, nguoi_thanh_toan, ghi_chu, tao_luc) VALUES ('6d6f7e18-f23e-4902-8d59-62d7a5994e27', 'a7c17aa4-fbe7-4133-becd-7afc57b935c0', 5470000.00, '2026-05-12 04:30:11.509331+00', 'tienMat', NULL, 'SUCCESS', NULL, '', '2026-05-12 04:30:11.514079+00');
INSERT INTO public.thanh_toan (id, hoa_don_id, so_tien, ngay_thanh_toan, phuong_thuc_thanh_toan, ma_tham_chieu, trang_thai, nguoi_thanh_toan, ghi_chu, tao_luc) VALUES ('811240c5-f3b2-4bf8-ae17-89f281c84a05', '2e035718-688c-4f7e-99ed-572bf1c0994a', 3564000.00, '2026-05-12 15:42:43.048553+00', 'tienMat', NULL, 'SUCCESS', NULL, '', '2026-05-12 15:42:43.049089+00');


--
-- Data for Name: thanh_vien_hop_dong; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: thong_bao; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('dddac9ba-9750-47e3-a3a4-8a17c573c47f', '66666666-6666-6666-6666-666666666666', 'Thông báo sự cố hệ thống', 'sự cố', 'chung', false, '2026-05-15 03:16:42.489846+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('d859ec16-e788-431d-9b1d-7d8a08ddf578', '44444444-4444-4444-4444-444444444444', 'Thông báo Test', 'Test', 'suCo', false, '2026-05-16 07:38:59.505263+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'd81a2ba6-a484-46b7-a839-65663378431c');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('d55f8d9e-e3ce-4f19-9c4d-95bebec987df', '995636ed-bcd0-4aca-9038-c7f1134fded8', 'Thông báo Test', 'Test', 'suCo', false, '2026-05-16 07:38:59.627362+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'd81a2ba6-a484-46b7-a839-65663378431c');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('18921443-b49e-40c0-ad7d-db8db9377a5b', '176e4d76-ed79-4f99-99af-d3e0979ffb24', 'Thông báo Test', 'Test', 'suCo', false, '2026-05-16 07:38:59.740347+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'd81a2ba6-a484-46b7-a839-65663378431c');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('14eba99c-2eeb-486d-ac30-9eeefc6bbd9f', '302242ef-a8a2-4b33-8ee9-3502f551ee24', 'Thông báo Test', 'Test', 'suCo', false, '2026-05-16 07:38:59.853718+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'd81a2ba6-a484-46b7-a839-65663378431c');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('f9ca30c6-18e4-40e5-9bab-fc5ab2e01b91', 'b850675f-4348-4f0a-8727-f660ce72ae55', 'Thông báo Test', 'Test', 'suCo', false, '2026-05-16 07:38:59.96343+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'd81a2ba6-a484-46b7-a839-65663378431c');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('6c063b9b-459f-4eb0-9a72-a272df16a5f6', '1a048652-538f-4724-98cc-3e3b4623488b', 'Thông báo Test', 'Test', 'suCo', false, '2026-05-16 07:39:00.077588+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'd81a2ba6-a484-46b7-a839-65663378431c');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('f35f4a9b-1a40-4b47-9cd2-c30d5450e86a', '04ad4a99-7cd2-4d39-a208-a74162c97168', 'Thông báo Test', 'Test', 'suCo', false, '2026-05-16 07:39:00.190481+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'd81a2ba6-a484-46b7-a839-65663378431c');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('96927abd-a3d5-4b57-be29-4f4dab364f38', '426ef5ed-8a99-4643-8978-170b24a4238c', 'Thông báo Test', 'Test', 'suCo', false, '2026-05-16 07:39:00.298285+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'd81a2ba6-a484-46b7-a839-65663378431c');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('8d572150-5d80-4777-9642-4c7470d46ebe', '06758f94-a29d-48e3-bba3-f85f1a6f3198', 'Thông báo Test', 'Test', 'suCo', false, '2026-05-16 07:39:00.407519+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'd81a2ba6-a484-46b7-a839-65663378431c');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('03e2cd7f-05c6-4735-bd03-5c8b76e9d2b3', '52a46682-e118-4c46-b770-edcb02361493', 'Thông báo Test', 'Test', 'suCo', false, '2026-05-16 07:39:00.516266+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'd81a2ba6-a484-46b7-a839-65663378431c');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('0f085d9e-1a75-454a-b061-1c1bd695a75a', '82c53316-39b2-4ef9-a401-1f9fa103ed83', 'Thông báo Test', 'Test', 'suCo', false, '2026-05-16 07:39:00.625464+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'd81a2ba6-a484-46b7-a839-65663378431c');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('6eaa279a-6695-473b-8036-eb3cb5f1854c', '6a6376e1-98b3-47fd-b7bb-366e30cdcd54', 'Thông báo Test', 'Test', 'suCo', false, '2026-05-16 07:39:00.735261+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'd81a2ba6-a484-46b7-a839-65663378431c');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('2ad75584-377e-4d6d-9ebe-79b2696538c1', '7239cd84-f0c4-4179-bfd5-37452ffe21f3', 'Thông báo Test', 'Test', 'suCo', false, '2026-05-16 07:39:00.84234+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'd81a2ba6-a484-46b7-a839-65663378431c');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('308289b1-c66e-43ee-a752-6f1006cf49de', '9fb7c659-ff6e-4f31-90b0-eb724ea682d9', 'Thông báo Test', 'Test', 'suCo', false, '2026-05-16 07:39:00.951314+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'd81a2ba6-a484-46b7-a839-65663378431c');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('06c40b8e-2e15-412a-8b33-b5c92f119e31', '88e1fdb9-0e8c-41dd-93f6-3c25dc3a1ea7', 'Thông báo Test', 'Test', 'suCo', false, '2026-05-16 07:39:01.058717+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'd81a2ba6-a484-46b7-a839-65663378431c');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('3ca2d27c-4f17-45c3-8fd4-c054923f462e', 'b850675f-4348-4f0a-8727-f660ce72ae55', 'Thông báo sự cố hệ thống', 'sự cố', 'suCo', false, '2026-05-15 03:16:41.400806+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('f0bb7ccc-aed8-4a1b-89e1-c741a63d212c', '1a048652-538f-4724-98cc-3e3b4623488b', 'Thông báo sự cố hệ thống', 'sự cố', 'suCo', false, '2026-05-15 03:16:41.491733+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('c5956af0-8763-4bd1-9048-edb7ca139f23', '04ad4a99-7cd2-4d39-a208-a74162c97168', 'Thông báo sự cố hệ thống', 'sự cố', 'suCo', false, '2026-05-15 03:16:41.582731+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('5d669e25-1982-41ca-ab05-d154396cf019', '426ef5ed-8a99-4643-8978-170b24a4238c', 'Thông báo sự cố hệ thống', 'sự cố', 'suCo', false, '2026-05-15 03:16:41.673839+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('54c52b91-b413-4861-9bf4-aed5a2b311e0', '06758f94-a29d-48e3-bba3-f85f1a6f3198', 'Thông báo sự cố hệ thống', 'sự cố', 'suCo', false, '2026-05-15 03:16:41.7632+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('136e7e3e-c09d-4af7-9c16-988d562a0ccf', '52a46682-e118-4c46-b770-edcb02361493', 'Thông báo sự cố hệ thống', 'sự cố', 'suCo', false, '2026-05-15 03:16:41.855202+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('aa9b43af-178d-4515-bd58-a4161dda0d54', '82c53316-39b2-4ef9-a401-1f9fa103ed83', 'Thông báo sự cố hệ thống', 'sự cố', 'suCo', false, '2026-05-15 03:16:41.947112+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('48833c4c-2b16-48a8-8bf1-d377d1ee03c9', '6a6376e1-98b3-47fd-b7bb-366e30cdcd54', 'Thông báo sự cố hệ thống', 'sự cố', 'suCo', false, '2026-05-15 03:16:42.037448+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('8f4a3009-3cd8-4a0c-8cc2-46cb5e8ff9c6', '7239cd84-f0c4-4179-bfd5-37452ffe21f3', 'Thông báo sự cố hệ thống', 'sự cố', 'suCo', false, '2026-05-15 03:16:42.127624+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('53a3b601-b1ff-4933-9d3c-187712489d8f', '9fb7c659-ff6e-4f31-90b0-eb724ea682d9', 'Thông báo sự cố hệ thống', 'sự cố', 'suCo', false, '2026-05-15 03:16:42.217945+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('01c8589f-1a52-4fd3-9dae-0a3a5e734b8e', '88e1fdb9-0e8c-41dd-93f6-3c25dc3a1ea7', 'Thông báo sự cố hệ thống', 'sự cố', 'suCo', false, '2026-05-15 03:16:42.308949+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('e4427d71-dba0-4952-abbd-f90652ddfc00', '70397230-46ad-421d-9dbe-8f8c6dd09a97', 'Thông báo sự cố hệ thống', 'sự cố', 'suCo', false, '2026-05-15 03:16:42.398861+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('6c869865-48bf-4853-bc0c-eaab16393883', '66666666-6666-6666-6666-666666666666', 'Thông báo Test', 'Test', 'hoaDon', false, '2026-05-16 07:39:01.276519+00', NULL, NULL, NULL, NULL, NULL, NULL, 'dc233ef5-408c-45fb-8616-cdb34524732f', NULL, '[]', false, 'd81a2ba6-a484-46b7-a839-65663378431c');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('1c13bb11-999d-4b4e-bcfa-3ea04855f6ec', '44444444-4444-4444-4444-444444444444', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'chung', false, '2026-05-15 01:44:36.606348+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('4bcaad7a-e2e0-4a6b-ad97-fdd4367dd8ae', '995636ed-bcd0-4aca-9038-c7f1134fded8', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'chung', false, '2026-05-15 01:44:36.831326+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('c30a3527-8b3e-4daf-b4be-9f3448959bbd', '176e4d76-ed79-4f99-99af-d3e0979ffb24', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'chung', false, '2026-05-15 01:44:36.928993+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('db1e4df3-d63a-40d1-9d5e-726453241eda', '302242ef-a8a2-4b33-8ee9-3502f551ee24', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'chung', false, '2026-05-15 01:44:37.027752+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('557225dc-30d6-495c-9331-f3fb1111d2c2', 'b850675f-4348-4f0a-8727-f660ce72ae55', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'chung', false, '2026-05-15 01:44:37.124644+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('ded3d7d7-e020-4685-83da-14ed85f26ff9', '1a048652-538f-4724-98cc-3e3b4623488b', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'chung', false, '2026-05-15 01:44:37.224433+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('9f337907-e5f3-4bb7-abd2-e221bec4eac9', '04ad4a99-7cd2-4d39-a208-a74162c97168', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'chung', false, '2026-05-15 01:44:37.431026+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('862482f2-7266-4d42-b6aa-18786418cb18', '426ef5ed-8a99-4643-8978-170b24a4238c', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'chung', false, '2026-05-15 01:44:37.52968+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('6d6dba48-7fd1-4eec-988b-aef55625e9ba', '06758f94-a29d-48e3-bba3-f85f1a6f3198', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'chung', false, '2026-05-15 01:44:37.627552+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('4b0a2389-5570-442e-9f76-6fcdfae64d43', '52a46682-e118-4c46-b770-edcb02361493', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'chung', false, '2026-05-15 01:44:37.725712+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('410e7c4b-c39f-4ea5-a612-451add7099ff', '82c53316-39b2-4ef9-a401-1f9fa103ed83', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'chung', false, '2026-05-15 01:44:37.824836+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('5e07e6a3-82be-47c0-8813-516d5d38e039', '6a6376e1-98b3-47fd-b7bb-366e30cdcd54', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'chung', false, '2026-05-15 01:44:37.923726+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('90736cc0-8ceb-4fb6-b0c7-325899cae149', '7239cd84-f0c4-4179-bfd5-37452ffe21f3', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'chung', false, '2026-05-15 01:44:38.155227+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('7b5b0e56-d9de-4368-b79a-383f783d4da7', '9fb7c659-ff6e-4f31-90b0-eb724ea682d9', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'chung', false, '2026-05-15 01:44:38.253798+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('f391c397-c09d-4f2b-9d37-6550353054d6', '88e1fdb9-0e8c-41dd-93f6-3c25dc3a1ea7', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'chung', false, '2026-05-15 01:44:38.352849+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('c6759090-ae1c-430f-a842-a892f3293714', '70397230-46ad-421d-9dbe-8f8c6dd09a97', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'chung', false, '2026-05-15 01:44:38.451794+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('7ec6691e-b895-4f20-89f2-8ef3e9c19370', '66666666-6666-6666-6666-666666666666', 'Thông báo sự cố hệ thống', 'Hiện hệ thống đang gặp sự cố kỹ thuật và đội ngũ phụ trách đang khẩn trương xử lý. Chúng tôi sẽ thông báo ngay khi sự cố được khắc phục.', 'suCo', false, '2026-05-15 01:44:38.549681+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '8582387b-fffe-4504-9d96-5578b531e64b');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('eb89b20e-080b-4157-959e-5ec711fa2356', '44444444-4444-4444-4444-444444444444', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:07.150544+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('bfb82934-82f8-429d-a16d-8fd7f0dacf40', '995636ed-bcd0-4aca-9038-c7f1134fded8', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:07.253998+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('2b64f176-9d38-4118-b4ea-c6a2d16e951c', '176e4d76-ed79-4f99-99af-d3e0979ffb24', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:07.354682+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('de946e10-5896-4e42-98c4-224bca09e6fd', '302242ef-a8a2-4b33-8ee9-3502f551ee24', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:07.453977+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('a0c1976f-876b-43d9-a140-9016b84a047f', 'b850675f-4348-4f0a-8727-f660ce72ae55', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:07.554213+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('c79254be-7ebd-408e-9404-b9c528f87618', '1a048652-538f-4724-98cc-3e3b4623488b', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:07.668696+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('1423bd89-4161-4d14-a8df-52f9b2d23efb', '04ad4a99-7cd2-4d39-a208-a74162c97168', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:07.768349+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('d666c0a2-d550-46a9-a48f-243308beae15', '426ef5ed-8a99-4643-8978-170b24a4238c', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:07.869294+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('7a6b2352-2ea2-42d9-b932-846e6383c04d', '06758f94-a29d-48e3-bba3-f85f1a6f3198', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:07.970989+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('01169feb-081c-4007-a59a-40d370aa6b05', '52a46682-e118-4c46-b770-edcb02361493', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:08.071646+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('7688c2ac-9fe7-4709-9d31-74b107833881', '82c53316-39b2-4ef9-a401-1f9fa103ed83', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:08.174548+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('10c08e37-2617-4590-949a-bfca0bfb4649', '6a6376e1-98b3-47fd-b7bb-366e30cdcd54', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:08.276659+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('cba408b2-1b2a-4574-b19d-ad93ad3e42fa', '7239cd84-f0c4-4179-bfd5-37452ffe21f3', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:08.379246+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('0b318e84-49f3-4f57-9c4e-5adb77f240f6', '9fb7c659-ff6e-4f31-90b0-eb724ea682d9', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:08.484835+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('a85d83cc-b2ac-4a72-8bf7-232dd4f7a1ab', '88e1fdb9-0e8c-41dd-93f6-3c25dc3a1ea7', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:08.583808+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('fcce21ed-2b0d-4038-9505-d2ee572cac1b', '70397230-46ad-421d-9dbe-8f8c6dd09a97', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:08.68134+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('10f99ad5-d2ae-4413-a2c9-612190bb4a18', '66666666-6666-6666-6666-666666666666', 'Sự cố kết nối tạm thời', 'Một số người dùng có thể gặp tình trạng kết nối chậm hoặc không ổn định. Vui lòng thử lại sau ít phút.', 'suCo', false, '2026-05-15 01:45:08.783316+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '01287f38-37cd-462a-9622-4219854e9269');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('374f67d8-d71b-4313-91ca-47c80fdef655', '44444444-4444-4444-4444-444444444444', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:46.253329+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('e7705f89-7d20-42ad-857f-5cc5507b150b', '995636ed-bcd0-4aca-9038-c7f1134fded8', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:46.352909+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('75a4665a-14e1-4e67-a315-679100457217', '176e4d76-ed79-4f99-99af-d3e0979ffb24', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:46.451827+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('bbd0cdf3-72da-42af-a385-a595a7354a92', '302242ef-a8a2-4b33-8ee9-3502f551ee24', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:46.550919+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('11474b01-0a88-4034-8be4-6f69cc35cdd0', 'b850675f-4348-4f0a-8727-f660ce72ae55', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:46.649001+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('f1770a7e-9ef8-4420-bee5-6417f3320536', '1a048652-538f-4724-98cc-3e3b4623488b', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:46.748844+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('ad3ebbc9-3fc4-4f62-939b-ae69e1aa04f7', '04ad4a99-7cd2-4d39-a208-a74162c97168', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:46.848415+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('85279a0e-f99a-4118-a0bb-506ecef2e167', '426ef5ed-8a99-4643-8978-170b24a4238c', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:46.950768+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('5c965847-41e4-48fa-9fba-06b734df439c', '06758f94-a29d-48e3-bba3-f85f1a6f3198', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:47.051264+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('a73209b3-8d6a-44d8-8a1b-83856f46f3c1', '52a46682-e118-4c46-b770-edcb02361493', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:47.153881+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('a35ed107-e896-4346-a679-88ef8e5b3818', '82c53316-39b2-4ef9-a401-1f9fa103ed83', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:47.256674+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('0aca416c-f833-4ee7-8890-2ea44da3eab4', '6a6376e1-98b3-47fd-b7bb-366e30cdcd54', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:47.356055+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('65e89ff3-de91-4505-80e0-4c3b3b438b1e', '7239cd84-f0c4-4179-bfd5-37452ffe21f3', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:47.456425+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('40014f63-c427-4680-9193-7d6ee87b9cc6', '9fb7c659-ff6e-4f31-90b0-eb724ea682d9', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:47.556963+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('dbc31f01-7567-41f8-86f3-746cd63cc3ac', '88e1fdb9-0e8c-41dd-93f6-3c25dc3a1ea7', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:47.657211+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('959ef613-9063-42fa-aa87-a2191eb552b6', '70397230-46ad-421d-9dbe-8f8c6dd09a97', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:47.756753+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('7fb31937-4f34-40ad-ae0c-0a81138bc285', '66666666-6666-6666-6666-666666666666', 'Sự cố đã được khắc phục', 'Sự cố trước đó đã được xử lý thành công. Bạn có thể tiếp tục sử dụng hệ thống bình thường.', 'suCo', false, '2026-05-15 01:45:47.855748+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '51569b14-3eea-4e89-bbf4-7bec4a47ed56');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('5979e112-d2e6-4134-9e13-ffdbdcb4164d', '66666666-6666-6666-6666-666666666666', 'Hợp đồng mới cần xác nhận', 'Có một hợp đồng mới đang chờ bạn kiểm tra và xác nhận. Vui lòng xem chi tiết hợp đồng trong hệ thống.', 'hopDong', false, '2026-05-15 01:46:12.776987+00', NULL, NULL, NULL, NULL, NULL, NULL, '88888888-8888-8888-8888-888888888888', NULL, '["99999999-9999-9999-9999-999999999999"]', false, NULL);
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('46e7a51e-2515-48b5-8635-68ec0bb01300', '66666666-6666-6666-6666-666666666666', 'Hợp đồng sắp hết hạn', 'Hợp đồng của bạn sắp đến ngày hết hạn. Vui lòng liên hệ bộ phận phụ trách để được hỗ trợ gia hạn kịp thời.', 'hopDong', false, '2026-05-15 01:46:32.861086+00', NULL, NULL, NULL, NULL, NULL, NULL, '88888888-8888-8888-8888-888888888888', NULL, '["99999999-9999-9999-9999-999999999999"]', false, NULL);
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('a1c386a5-1533-4e1e-8c4c-874f7435e95b', '66666666-6666-6666-6666-666666666666', 'Hợp đồng đã được cập nhật', 'Thông tin hợp đồng đã được cập nhật trên hệ thống. Vui lòng kiểm tra lại nội dung để đảm bảo chính xác.', 'hopDong', false, '2026-05-15 01:47:15.984068+00', NULL, NULL, NULL, NULL, NULL, NULL, '88888888-8888-8888-8888-888888888888', NULL, '["99999999-9999-9999-9999-999999999999"]', false, NULL);
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('d9e5eadd-c336-4bee-8ae6-d1f3386fc4b4', '66666666-6666-6666-6666-666666666666', 'Yêu cầu hỗ trợ mới', 'Bạn có một yêu cầu hỗ trợ mới cần xử lý. Vui lòng kiểm tra nội dung chi tiết và phản hồi trong thời gian sớm nhất.', 'khac', false, '2026-05-15 01:47:50.244485+00', NULL, NULL, NULL, NULL, NULL, NULL, '88888888-8888-8888-8888-888888888888', NULL, '["99999999-9999-9999-9999-999999999999"]', false, NULL);
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('a9629f46-2813-4bfe-9307-57403b8bfb9f', '44444444-4444-4444-4444-444444444444', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'chung', false, '2026-05-15 01:48:11.952018+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('b438cdd3-68dd-4271-9e77-2fad37a50753', '995636ed-bcd0-4aca-9038-c7f1134fded8', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'chung', false, '2026-05-15 01:48:12.051595+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('45ad1b53-24ba-4c1b-9908-2f1dc07a499e', '176e4d76-ed79-4f99-99af-d3e0979ffb24', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'chung', false, '2026-05-15 01:48:12.154371+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('cd12ab09-3f8e-4722-973a-db92441e0de0', '302242ef-a8a2-4b33-8ee9-3502f551ee24', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'chung', false, '2026-05-15 01:48:12.252055+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('0b3f23bf-3ece-4021-acce-e6b1d97a9347', 'b850675f-4348-4f0a-8727-f660ce72ae55', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'chung', false, '2026-05-15 01:48:12.352346+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('8b4f872a-b128-4021-b8f9-f1d9c93c7edf', '1a048652-538f-4724-98cc-3e3b4623488b', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'chung', false, '2026-05-15 01:48:12.457104+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('e43189c9-ac8f-473d-a8ca-cc42f61e2acb', '04ad4a99-7cd2-4d39-a208-a74162c97168', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'chung', false, '2026-05-15 01:48:12.554706+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('c11d0939-d9e4-4fc8-acc1-4abe9b015eae', '426ef5ed-8a99-4643-8978-170b24a4238c', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'chung', false, '2026-05-15 01:48:12.651469+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('7de87d7c-fdfa-42a3-b4cd-8808ee1bfba4', '06758f94-a29d-48e3-bba3-f85f1a6f3198', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'chung', false, '2026-05-15 01:48:12.748757+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('61aa04d5-6979-46aa-b8a1-0a9b954691b0', '52a46682-e118-4c46-b770-edcb02361493', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'chung', false, '2026-05-15 01:48:12.847676+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('b6f2ecb3-47c2-4d21-b91f-0e798725f636', '82c53316-39b2-4ef9-a401-1f9fa103ed83', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'chung', false, '2026-05-15 01:48:12.945159+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('7f778aea-9ed2-4800-b44d-7d8bbaac50c3', '6a6376e1-98b3-47fd-b7bb-366e30cdcd54', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'chung', false, '2026-05-15 01:48:13.043253+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('a74d18ec-9d86-495d-8a06-3cd727241d47', '7239cd84-f0c4-4179-bfd5-37452ffe21f3', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'chung', false, '2026-05-15 01:48:13.141643+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('8bf69ec4-d8fd-4835-947b-f164a3072e1a', '9fb7c659-ff6e-4f31-90b0-eb724ea682d9', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'chung', false, '2026-05-15 01:48:13.239176+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('61c11d75-392f-4f0e-8fe9-e84621ed786e', '88e1fdb9-0e8c-41dd-93f6-3c25dc3a1ea7', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'chung', false, '2026-05-15 01:48:13.338121+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('287e3516-a6f6-48a8-826e-fb1c5b7c4ab2', '70397230-46ad-421d-9dbe-8f8c6dd09a97', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'chung', false, '2026-05-15 01:48:13.437949+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('d2e1b7fe-7a93-4c13-9658-79b80b638789', '66666666-6666-6666-6666-666666666666', 'Nhắc nhở kiểm tra công việc', 'Bạn có một số công việc cần theo dõi hoặc hoàn thành. Vui lòng kiểm tra danh sách công việc để không bỏ sót thông tin quan trọng.', 'khac', false, '2026-05-15 01:48:13.535726+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', false, 'ad1eaa6a-7903-4a65-8728-0835186b49d1');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('63de52bd-d63a-4c85-950e-bc31b4b11856', '44444444-4444-4444-4444-444444444444', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:34.34688+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('323ee095-1e32-465a-89ce-f72b890590f1', '995636ed-bcd0-4aca-9038-c7f1134fded8', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:34.447272+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('258defc0-cc93-442a-a747-318dc58cd510', '176e4d76-ed79-4f99-99af-d3e0979ffb24', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:34.547744+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('3ff0b57d-c27b-4a8b-9df1-7126a1c1d7ec', '302242ef-a8a2-4b33-8ee9-3502f551ee24', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:34.64797+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('97650521-8a3b-4968-8646-386ac93c8981', 'b850675f-4348-4f0a-8727-f660ce72ae55', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:34.748221+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('53046530-8682-412d-aeba-2f86cbcc1cc8', '1a048652-538f-4724-98cc-3e3b4623488b', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:34.85072+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('32c6284d-d6ea-45d9-98c7-e280c2daedbf', '04ad4a99-7cd2-4d39-a208-a74162c97168', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:34.95308+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('a956f5d7-4984-4eb7-bb7a-d8ea19f9fd7d', '426ef5ed-8a99-4643-8978-170b24a4238c', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:35.053975+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('fb7b8205-e1eb-4b84-b979-54291c92ea17', '06758f94-a29d-48e3-bba3-f85f1a6f3198', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:35.158956+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('c9e44e48-a0d5-42b0-9342-b5a4fa3b46f5', '52a46682-e118-4c46-b770-edcb02361493', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:35.261756+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('526ff075-debb-45f5-9d9a-31271bd1f504', '82c53316-39b2-4ef9-a401-1f9fa103ed83', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:35.370943+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('783b4c92-d6e1-48f4-b490-bae688a8f72f', '6a6376e1-98b3-47fd-b7bb-366e30cdcd54', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:35.470557+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('a591b43e-7ff5-4a8f-8f8a-633244a0b629', '7239cd84-f0c4-4179-bfd5-37452ffe21f3', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:35.571066+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('a0733ef4-1a9f-4590-8114-a5b6d325c9e4', '9fb7c659-ff6e-4f31-90b0-eb724ea682d9', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:35.671081+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('8498511e-a54e-4e2d-a51c-65ea30f16285', '88e1fdb9-0e8c-41dd-93f6-3c25dc3a1ea7', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:35.772139+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('197c05b5-66ff-4f01-840f-339a55ac69c6', '70397230-46ad-421d-9dbe-8f8c6dd09a97', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:35.872076+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('041cb9fe-13bd-4513-bba9-e36be1d774d6', '66666666-6666-6666-6666-666666666666', 'Thông báo quan trọng', 'Có một thông báo quan trọng được gửi đến bạn. Vui lòng đọc kỹ nội dung và thực hiện theo hướng dẫn nếu cần thiết.', 'khac', false, '2026-05-15 01:48:35.972506+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, '2b86a0db-a096-4419-8070-c9fe65bea6a0');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('387337f9-e79e-434c-9c51-b2fc1c35ab8f', '44444444-4444-4444-4444-444444444444', 'Thông báo sự cố hệ thống', 'sự cố', 'suCo', false, '2026-05-15 03:16:41.02723+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('6e08042e-7fb9-4737-879c-61f62546510c', '995636ed-bcd0-4aca-9038-c7f1134fded8', 'Thông báo sự cố hệ thống', 'sự cố', 'suCo', false, '2026-05-15 03:16:41.127318+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('79d2d237-cf4d-4f4f-b44e-b3b594fd51b3', '176e4d76-ed79-4f99-99af-d3e0979ffb24', 'Thông báo sự cố hệ thống', 'sự cố', 'suCo', false, '2026-05-15 03:16:41.218321+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');
INSERT INTO public.thong_bao (id, nguoi_dung_id, tieu_de, noi_dung, loai, da_doc, tao_luc, cap_nhat_luc, da_doc_json, ngay_gui, nguoi_gui_id, nguoi_nhan, phong, toa_nha_id, xoa_luc, phong_ids, gui_tat_ca, nhom_gui_id) VALUES ('2e95745e-777e-4567-a75c-b696d50079cd', '302242ef-a8a2-4b33-8ee9-3502f551ee24', 'Thông báo sự cố hệ thống', 'sự cố', 'suCo', false, '2026-05-15 03:16:41.309335+00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '[]', true, 'c629523a-a132-4b37-b96d-77e72c715539');


--
-- Data for Name: tien_ich; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: vai_tro; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.vai_tro (id, ten, tao_luc) VALUES ('11111111-1111-1111-1111-111111111111', 'ADMIN', '2026-05-03 17:13:44.013465+00');
INSERT INTO public.vai_tro (id, ten, tao_luc) VALUES ('22222222-2222-2222-2222-222222222222', 'LANDLORD', '2026-05-03 17:13:44.013465+00');
INSERT INTO public.vai_tro (id, ten, tao_luc) VALUES ('33333333-3333-3333-3333-333333333333', 'TENANT', '2026-05-03 17:13:44.013465+00');


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20211116024918, '2026-04-30 20:38:38');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20211116045059, '2026-04-30 20:38:39');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20211116050929, '2026-04-30 20:38:40');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20211116051442, '2026-04-30 20:38:41');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20211116212300, '2026-04-30 20:38:42');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20211116213355, '2026-04-30 20:38:42');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20211116213934, '2026-04-30 20:38:43');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20211116214523, '2026-04-30 20:38:44');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20211122062447, '2026-04-30 20:38:45');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20211124070109, '2026-04-30 20:38:45');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20211202204204, '2026-04-30 20:38:46');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20211202204605, '2026-04-30 20:38:47');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20211210212804, '2026-04-30 20:38:49');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20211228014915, '2026-04-30 20:38:49');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20220107221237, '2026-04-30 20:38:50');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20220228202821, '2026-04-30 20:38:51');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20220312004840, '2026-04-30 20:38:51');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20220603231003, '2026-04-30 20:38:53');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20220603232444, '2026-04-30 20:38:53');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20220615214548, '2026-04-30 20:38:54');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20220712093339, '2026-04-30 20:38:55');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20220908172859, '2026-04-30 20:38:55');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20220916233421, '2026-04-30 20:38:56');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20230119133233, '2026-04-30 20:38:57');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20230128025114, '2026-04-30 20:38:58');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20230128025212, '2026-04-30 20:38:58');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20230227211149, '2026-04-30 20:38:59');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20230228184745, '2026-04-30 20:39:00');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20230308225145, '2026-04-30 20:39:00');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20230328144023, '2026-04-30 20:39:01');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20231018144023, '2026-04-30 20:39:02');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20231204144023, '2026-04-30 20:39:03');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20231204144024, '2026-04-30 20:39:04');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20231204144025, '2026-04-30 20:39:04');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20240108234812, '2026-04-30 20:39:05');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20240109165339, '2026-04-30 20:39:06');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20240227174441, '2026-04-30 20:39:07');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20240311171622, '2026-04-30 20:39:08');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20240321100241, '2026-04-30 20:39:09');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20240401105812, '2026-04-30 20:39:11');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20240418121054, '2026-04-30 20:39:12');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20240523004032, '2026-04-30 20:39:15');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20240618124746, '2026-04-30 20:39:15');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20240801235015, '2026-04-30 20:39:16');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20240805133720, '2026-04-30 20:39:17');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20240827160934, '2026-04-30 20:39:17');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20240919163303, '2026-04-30 20:39:18');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20240919163305, '2026-04-30 20:39:19');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20241019105805, '2026-04-30 20:39:20');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20241030150047, '2026-04-30 20:39:22');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20241108114728, '2026-04-30 20:39:23');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20241121104152, '2026-04-30 20:39:24');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20241130184212, '2026-04-30 20:39:25');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20241220035512, '2026-04-30 20:39:25');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20241220123912, '2026-04-30 20:39:26');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20241224161212, '2026-04-30 20:39:27');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20250107150512, '2026-04-30 20:39:27');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20250110162412, '2026-04-30 20:39:28');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20250123174212, '2026-04-30 20:39:29');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20250128220012, '2026-04-30 20:39:29');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20250506224012, '2026-04-30 20:39:30');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20250523164012, '2026-04-30 20:39:31');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20250714121412, '2026-04-30 20:39:31');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20250905041441, '2026-04-30 20:39:32');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20251103001201, '2026-04-30 20:39:33');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20251120212548, '2026-04-30 20:39:34');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20251120215549, '2026-04-30 20:39:34');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20260218120000, '2026-04-30 20:39:35');
INSERT INTO realtime.schema_migrations (version, inserted_at) VALUES (20260326120000, '2026-04-30 20:39:36');


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--



--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--



--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: -
--



--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: -
--



--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (0, 'create-migrations-table', 'e18db593bcde2aca2a408c4d1100f6abba2195df', '2026-04-30 18:21:46.922708');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (1, 'initialmigration', '6ab16121fbaa08bbd11b712d05f358f9b555d777', '2026-04-30 18:21:46.96972');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (2, 'storage-schema', 'f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd', '2026-04-30 18:21:46.978813');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (3, 'pathtoken-column', '2cb1b0004b817b29d5b0a971af16bafeede4b70d', '2026-04-30 18:21:47.005377');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (4, 'add-migrations-rls', '427c5b63fe1c5937495d9c635c263ee7a5905058', '2026-04-30 18:21:47.021939');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (5, 'add-size-functions', '79e081a1455b63666c1294a440f8ad4b1e6a7f84', '2026-04-30 18:21:47.030997');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (6, 'change-column-name-in-get-size', 'ded78e2f1b5d7e616117897e6443a925965b30d2', '2026-04-30 18:21:47.041346');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (7, 'add-rls-to-buckets', 'e7e7f86adbc51049f341dfe8d30256c1abca17aa', '2026-04-30 18:21:47.051397');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (8, 'add-public-to-buckets', 'fd670db39ed65f9d08b01db09d6202503ca2bab3', '2026-04-30 18:21:47.063674');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (9, 'fix-search-function', 'af597a1b590c70519b464a4ab3be54490712796b', '2026-04-30 18:21:47.073616');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (10, 'search-files-search-function', 'b595f05e92f7e91211af1bbfe9c6a13bb3391e16', '2026-04-30 18:21:47.086551');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (11, 'add-trigger-to-auto-update-updated_at-column', '7425bdb14366d1739fa8a18c83100636d74dcaa2', '2026-04-30 18:21:47.097463');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (12, 'add-automatic-avif-detection-flag', '8e92e1266eb29518b6a4c5313ab8f29dd0d08df9', '2026-04-30 18:21:47.107972');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (13, 'add-bucket-custom-limits', 'cce962054138135cd9a8c4bcd531598684b25e7d', '2026-04-30 18:21:47.117372');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (14, 'use-bytes-for-max-size', '941c41b346f9802b411f06f30e972ad4744dad27', '2026-04-30 18:21:47.1269');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (15, 'add-can-insert-object-function', '934146bc38ead475f4ef4b555c524ee5d66799e5', '2026-04-30 18:21:47.155629');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (16, 'add-version', '76debf38d3fd07dcfc747ca49096457d95b1221b', '2026-04-30 18:21:47.164965');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (17, 'drop-owner-foreign-key', 'f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101', '2026-04-30 18:21:47.174321');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (18, 'add_owner_id_column_deprecate_owner', 'e7a511b379110b08e2f214be852c35414749fe66', '2026-04-30 18:21:47.183339');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (19, 'alter-default-value-objects-id', '02e5e22a78626187e00d173dc45f58fa66a4f043', '2026-04-30 18:21:47.194053');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (20, 'list-objects-with-delimiter', 'cd694ae708e51ba82bf012bba00caf4f3b6393b7', '2026-04-30 18:21:47.203863');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (21, 's3-multipart-uploads', '8c804d4a566c40cd1e4cc5b3725a664a9303657f', '2026-04-30 18:21:47.215897');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (22, 's3-multipart-uploads-big-ints', '9737dc258d2397953c9953d9b86920b8be0cdb73', '2026-04-30 18:21:47.24097');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (23, 'optimize-search-function', '9d7e604cddc4b56a5422dc68c9313f4a1b6f132c', '2026-04-30 18:21:47.256162');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (24, 'operation-function', '8312e37c2bf9e76bbe841aa5fda889206d2bf8aa', '2026-04-30 18:21:47.265851');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (25, 'custom-metadata', 'd974c6057c3db1c1f847afa0e291e6165693b990', '2026-04-30 18:21:47.274901');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (26, 'objects-prefixes', '215cabcb7f78121892a5a2037a09fedf9a1ae322', '2026-04-30 18:21:47.285491');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (27, 'search-v2', '859ba38092ac96eb3964d83bf53ccc0b141663a6', '2026-04-30 18:21:47.294579');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (28, 'object-bucket-name-sorting', 'c73a2b5b5d4041e39705814fd3a1b95502d38ce4', '2026-04-30 18:21:47.303619');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (29, 'create-prefixes', 'ad2c1207f76703d11a9f9007f821620017a66c21', '2026-04-30 18:21:47.313573');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (30, 'update-object-levels', '2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6', '2026-04-30 18:21:47.322462');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (31, 'objects-level-index', 'b40367c14c3440ec75f19bbce2d71e914ddd3da0', '2026-04-30 18:21:47.331513');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (32, 'backward-compatible-index-on-objects', 'e0c37182b0f7aee3efd823298fb3c76f1042c0f7', '2026-04-30 18:21:47.340353');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (33, 'backward-compatible-index-on-prefixes', 'b480e99ed951e0900f033ec4eb34b5bdcb4e3d49', '2026-04-30 18:21:47.349305');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (34, 'optimize-search-function-v1', 'ca80a3dc7bfef894df17108785ce29a7fc8ee456', '2026-04-30 18:21:47.358168');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (35, 'add-insert-trigger-prefixes', '458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc', '2026-04-30 18:21:47.367355');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (36, 'optimise-existing-functions', '6ae5fca6af5c55abe95369cd4f93985d1814ca8f', '2026-04-30 18:21:47.37669');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (37, 'add-bucket-name-length-trigger', '3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1', '2026-04-30 18:21:47.386259');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (38, 'iceberg-catalog-flag-on-buckets', '02716b81ceec9705aed84aa1501657095b32e5c5', '2026-04-30 18:21:47.39636');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (39, 'add-search-v2-sort-support', '6706c5f2928846abee18461279799ad12b279b78', '2026-04-30 18:21:47.411783');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (40, 'fix-prefix-race-conditions-optimized', '7ad69982ae2d372b21f48fc4829ae9752c518f6b', '2026-04-30 18:21:47.420512');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (41, 'add-object-level-update-trigger', '07fcf1a22165849b7a029deed059ffcde08d1ae0', '2026-04-30 18:21:47.429656');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (42, 'rollback-prefix-triggers', '771479077764adc09e2ea2043eb627503c034cd4', '2026-04-30 18:21:47.438694');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (43, 'fix-object-level', '84b35d6caca9d937478ad8a797491f38b8c2979f', '2026-04-30 18:21:47.448014');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (44, 'vector-bucket-type', '99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3', '2026-04-30 18:21:47.457055');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (45, 'vector-buckets', '049e27196d77a7cb76497a85afae669d8b230953', '2026-04-30 18:21:47.466453');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (46, 'buckets-objects-grants', 'fedeb96d60fefd8e02ab3ded9fbde05632f84aed', '2026-04-30 18:21:47.481894');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (47, 'iceberg-table-metadata', '649df56855c24d8b36dd4cc1aeb8251aa9ad42c2', '2026-04-30 18:21:47.491467');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (48, 'iceberg-catalog-ids', 'e0e8b460c609b9999ccd0df9ad14294613eed939', '2026-04-30 18:21:47.501233');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (49, 'buckets-objects-grants-postgres', '072b1195d0d5a2f888af6b2302a1938dd94b8b3d', '2026-04-30 18:21:47.524558');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (50, 'search-v2-optimised', '6323ac4f850aa14e7387eb32102869578b5bd478', '2026-04-30 18:21:47.534222');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (51, 'index-backward-compatible-search', '2ee395d433f76e38bcd3856debaf6e0e5b674011', '2026-04-30 18:21:48.525062');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (52, 'drop-not-used-indexes-and-functions', '5cc44c8696749ac11dd0dc37f2a3802075f3a171', '2026-04-30 18:21:48.531563');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (53, 'drop-index-lower-name', 'd0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854', '2026-04-30 18:21:48.548833');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (54, 'drop-index-object-level', '6289e048b1472da17c31a7eba1ded625a6457e67', '2026-04-30 18:21:48.554178');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (55, 'prevent-direct-deletes', '262a4798d5e0f2e7c8970232e03ce8be695d5819', '2026-04-30 18:21:48.557615');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (57, 's3-multipart-uploads-metadata', 'f127886e00d1b374fadbc7c6b31e09336aad5287', '2026-04-30 18:21:48.581662');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (58, 'operation-ergonomics', '00ca5d483b3fe0d522133d9002ccc5df98365120', '2026-04-30 18:21:48.590855');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (56, 'fix-optimized-search-function', 'b823ed1e418101032fa01374edc9a436e54e3ed4', '2026-04-30 18:21:48.570481');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (59, 'drop-unused-functions', '38456f13e39691c2bbb4b5151d0d1cdbabd4a8c4', '2026-05-08 13:42:54.792703');
INSERT INTO storage.migrations (id, name, hash, executed_at) VALUES (60, 'optimize-existing-functions-again', 'db35e1c91a9201e59f4fef8d972c2f277d68b157', '2026-05-08 13:42:54.812468');


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--



--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--



--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: -
--



--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


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
-- Name: cau_hinh_gia cau_hinh_gia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cau_hinh_gia
    ADD CONSTRAINT cau_hinh_gia_pkey PRIMARY KEY (id);


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
-- Name: email_verification_token email_verification_token_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_verification_token
    ADD CONSTRAINT email_verification_token_pkey PRIMARY KEY (id);


--
-- Name: hoa_don hoa_don_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hoa_don
    ADD CONSTRAINT hoa_don_pkey PRIMARY KEY (id);


--
-- Name: hop_dong hop_dong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hop_dong
    ADD CONSTRAINT hop_dong_pkey PRIMARY KEY (id);


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
-- Name: khach_thue khach_thue_so_cccd_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.khach_thue
    ADD CONSTRAINT khach_thue_so_cccd_key UNIQUE (so_cccd);


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
-- Name: nguoi_dung nguoi_dung_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung
    ADD CONSTRAINT nguoi_dung_email_key UNIQUE (email);


--
-- Name: nguoi_dung nguoi_dung_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung
    ADD CONSTRAINT nguoi_dung_pkey PRIMARY KEY (id);


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
-- Name: su_co su_co_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.su_co
    ADD CONSTRAINT su_co_pkey PRIMARY KEY (id);


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
-- Name: hop_dong uk1gcrgca5o7t8609khe2gdgax9; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hop_dong
    ADD CONSTRAINT uk1gcrgca5o7t8609khe2gdgax9 UNIQUE (ma_hop_dong);


--
-- Name: email_verification_token ukidu2ippaks8bn6vcsq62khvdu; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_verification_token
    ADD CONSTRAINT ukidu2ippaks8bn6vcsq62khvdu UNIQUE (token);


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
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


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
-- Name: idx_cau_hinh_gia_nha_tro_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cau_hinh_gia_nha_tro_id ON public.cau_hinh_gia USING btree (nha_tro_id);


--
-- Name: idx_chi_so_phong_ngay; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chi_so_phong_ngay ON public.chi_so_dien_nuoc USING btree (phong_id, ngay_ghi);


--
-- Name: idx_chi_tiet_hoa_don_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chi_tiet_hoa_don_id ON public.chi_tiet_hoa_don USING btree (hoa_don_id);


--
-- Name: idx_dat_coc_phong_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dat_coc_phong_id ON public.dat_coc_phong USING btree (phong_id);


--
-- Name: idx_hoa_don_hop_dong_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hoa_don_hop_dong_id ON public.hoa_don USING btree (hop_dong_id);


--
-- Name: idx_hoa_don_hop_dong_thang; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hoa_don_hop_dong_thang ON public.hoa_don USING btree (hop_dong_id, thang_hoa_don);


--
-- Name: idx_hoa_don_khach_thue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hoa_don_khach_thue_id ON public.hoa_don USING btree (khach_thue_id);


--
-- Name: idx_hoa_don_phong_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hoa_don_phong_id ON public.hoa_don USING btree (phong_id);


--
-- Name: idx_hoa_don_thang; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hoa_don_thang ON public.hoa_don USING btree (thang_hoa_don);


--
-- Name: idx_hoa_don_trang_thai; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hoa_don_trang_thai ON public.hoa_don USING btree (trang_thai);


--
-- Name: idx_hoa_don_trang_thai_han_tra; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hoa_don_trang_thai_han_tra ON public.hoa_don USING btree (trang_thai, han_tra);


--
-- Name: idx_hop_dong_khach_thue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hop_dong_khach_thue_id ON public.hop_dong USING btree (khach_thue_id);


--
-- Name: idx_hop_dong_phong_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hop_dong_phong_id ON public.hop_dong USING btree (phong_id);


--
-- Name: idx_hop_dong_phong_trang_thai_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hop_dong_phong_trang_thai_dates ON public.hop_dong USING btree (phong_id, trang_thai, ngay_bat_dau, ngay_ket_thuc);


--
-- Name: idx_nha_tro_chu_tro_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nha_tro_chu_tro_id ON public.nha_tro USING btree (chu_tro_id);


--
-- Name: idx_phong_nha_tro_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_phong_nha_tro_id ON public.phong USING btree (nha_tro_id);


--
-- Name: idx_phong_trang_thai; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_phong_trang_thai ON public.phong USING btree (trang_thai);


--
-- Name: idx_su_co_loai; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_su_co_loai ON public.su_co USING btree (loai_su_co);


--
-- Name: idx_su_co_phong_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_su_co_phong_id ON public.su_co USING btree (phong_id);


--
-- Name: idx_su_co_trang_thai; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_su_co_trang_thai ON public.su_co USING btree (trang_thai);


--
-- Name: idx_su_co_uu_tien; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_su_co_uu_tien ON public.su_co USING btree (uu_tien);


--
-- Name: idx_thanh_toan_hoa_don_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_thanh_toan_hoa_don_id ON public.thanh_toan USING btree (hoa_don_id);


--
-- Name: idx_thanh_vien_hop_dong_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_thanh_vien_hop_dong_id ON public.thanh_vien_hop_dong USING btree (hop_dong_id);


--
-- Name: idx_thong_bao_nguoi_dung_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_thong_bao_nguoi_dung_id ON public.thong_bao USING btree (nguoi_dung_id);


--
-- Name: uk_hoa_don_ma_hoa_don_not_null; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uk_hoa_don_ma_hoa_don_not_null ON public.hoa_don USING btree (ma_hoa_don) WHERE (ma_hoa_don IS NOT NULL);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


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
-- Name: dat_coc_phong trg_dat_coc_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_dat_coc_cap_nhat BEFORE UPDATE ON public.dat_coc_phong FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: hoa_don trg_hoa_don_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_hoa_don_cap_nhat BEFORE UPDATE ON public.hoa_don FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


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
-- Name: thanh_toan trg_sau_thanh_toan; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_sau_thanh_toan AFTER INSERT OR UPDATE ON public.thanh_toan FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_trang_thai_hoa_don();


--
-- Name: su_co trg_su_co_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_su_co_cap_nhat BEFORE UPDATE ON public.su_co FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: thanh_vien_hop_dong trg_thanh_vien_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_thanh_vien_cap_nhat BEFORE UPDATE ON public.thanh_vien_hop_dong FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


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
-- Name: cau_hinh_gia cau_hinh_gia_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cau_hinh_gia
    ADD CONSTRAINT cau_hinh_gia_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE CASCADE;


--
-- Name: chi_so_dien_nuoc chi_so_dien_nuoc_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_so_dien_nuoc
    ADD CONSTRAINT chi_so_dien_nuoc_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE CASCADE;


--
-- Name: chi_tiet_hoa_don chi_tiet_hoa_don_hoa_don_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_tiet_hoa_don
    ADD CONSTRAINT chi_tiet_hoa_don_hoa_don_id_fkey FOREIGN KEY (hoa_don_id) REFERENCES public.hoa_don(id) ON DELETE CASCADE;


--
-- Name: chu_tro chu_tro_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chu_tro
    ADD CONSTRAINT chu_tro_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: dat_coc_phong dat_coc_phong_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dat_coc_phong
    ADD CONSTRAINT dat_coc_phong_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE RESTRICT;


--
-- Name: dat_coc_phong dat_coc_phong_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dat_coc_phong
    ADD CONSTRAINT dat_coc_phong_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE RESTRICT;


--
-- Name: email_verification_token fk13hft1rs4pds05ytufr3dg2te; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_verification_token
    ADD CONSTRAINT fk13hft1rs4pds05ytufr3dg2te FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id);


--
-- Name: dat_coc_phong fk_dat_coc_hop_dong; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dat_coc_phong
    ADD CONSTRAINT fk_dat_coc_hop_dong FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE SET NULL;


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
-- Name: khach_thue khach_thue_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.khach_thue
    ADD CONSTRAINT khach_thue_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: lich_hen lich_hen_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_hen
    ADD CONSTRAINT lich_hen_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


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
-- Name: lich_su_hoa_don lich_su_hoa_don_nguoi_thay_doi_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_hoa_don
    ADD CONSTRAINT lich_su_hoa_don_nguoi_thay_doi_fkey FOREIGN KEY (nguoi_thay_doi) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


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
    ADD CONSTRAINT nha_tro_chu_tro_id_fkey FOREIGN KEY (chu_tro_id) REFERENCES public.chu_tro(id) ON DELETE RESTRICT;


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
-- Name: su_co su_co_khach_thue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.su_co
    ADD CONSTRAINT su_co_khach_thue_id_fkey FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id) ON DELETE CASCADE;


--
-- Name: su_co su_co_nguoi_phu_trach_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.su_co
    ADD CONSTRAINT su_co_nguoi_phu_trach_fkey FOREIGN KEY (nguoi_phu_trach) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


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
-- Name: thanh_toan thanh_toan_nguoi_thanh_toan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_toan
    ADD CONSTRAINT thanh_toan_nguoi_thanh_toan_fkey FOREIGN KEY (nguoi_thanh_toan) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: thanh_vien_hop_dong thanh_vien_hop_dong_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_vien_hop_dong
    ADD CONSTRAINT thanh_vien_hop_dong_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE CASCADE;


--
-- Name: thong_bao thong_bao_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thong_bao
    ADD CONSTRAINT thong_bao_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


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
-- Name: cau_hinh_gia; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.cau_hinh_gia ENABLE ROW LEVEL SECURITY;

--
-- Name: chi_so_dien_nuoc; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.chi_so_dien_nuoc ENABLE ROW LEVEL SECURITY;

--
-- Name: chi_tiet_hoa_don; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.chi_tiet_hoa_don ENABLE ROW LEVEL SECURITY;

--
-- Name: chu_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.chu_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: dat_coc_phong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.dat_coc_phong ENABLE ROW LEVEL SECURITY;

--
-- Name: hoa_don; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hoa_don ENABLE ROW LEVEL SECURITY;

--
-- Name: hop_dong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hop_dong ENABLE ROW LEVEL SECURITY;

--
-- Name: khach_thue; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.khach_thue ENABLE ROW LEVEL SECURITY;

--
-- Name: lich_hen; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lich_hen ENABLE ROW LEVEL SECURITY;

--
-- Name: lich_su_hoa_don; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lich_su_hoa_don ENABLE ROW LEVEL SECURITY;

--
-- Name: nguoi_dung; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nguoi_dung ENABLE ROW LEVEL SECURITY;

--
-- Name: nguoi_dung_vai_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nguoi_dung_vai_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: nha_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nha_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: phong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.phong ENABLE ROW LEVEL SECURITY;

--
-- Name: phong_tien_ich; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.phong_tien_ich ENABLE ROW LEVEL SECURITY;

--
-- Name: su_co; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.su_co ENABLE ROW LEVEL SECURITY;

--
-- Name: thanh_toan; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.thanh_toan ENABLE ROW LEVEL SECURITY;

--
-- Name: thanh_vien_hop_dong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.thanh_vien_hop_dong ENABLE ROW LEVEL SECURITY;

--
-- Name: thong_bao; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.thong_bao ENABLE ROW LEVEL SECURITY;

--
-- Name: tien_ich; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tien_ich ENABLE ROW LEVEL SECURITY;

--
-- Name: vai_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.vai_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


--
-- PostgreSQL database dump complete
--

\unrestrict mnv0Hy7GmfB1upJZ32k6iKNUJahfSYePXmKB8z9NFAwkCVuiqcIQPpgsOfdecIs
