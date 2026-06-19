SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict lO9oJ1d2VCkLDGk2kGI4nRc1cM42ROfwtAgruiAMsigGep0YeOP8eoU97XeftwI

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

COPY "auth"."audit_log_entries" ("instance_id", "id", "payload", "created_at", "ip_address") FROM stdin;
\.

--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."custom_oauth_providers" ("id", "provider_type", "identifier", "name", "client_id", "client_secret", "acceptable_client_ids", "scopes", "pkce_enabled", "attribute_mapping", "authorization_params", "enabled", "email_optional", "issuer", "discovery_url", "skip_nonce_check", "cached_discovery", "discovery_cached_at", "authorization_url", "token_url", "userinfo_url", "jwks_uri", "created_at", "updated_at") FROM stdin;
\.

--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."flow_state" ("id", "user_id", "auth_code", "code_challenge_method", "code_challenge", "provider_type", "provider_access_token", "provider_refresh_token", "created_at", "updated_at", "authentication_method", "auth_code_issued_at", "invite_token", "referrer", "oauth_client_state_id", "linking_target_id", "email_optional") FROM stdin;
\.

--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") FROM stdin;
00000000-0000-0000-0000-000000000000	8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139	authenticated	authenticated	vyt22052006@gmail.com	$2a$10$JbDA/MW0CBQkMBsikTP5hOqOhY7xspiz5muNSLRCjCjwSNjEs19eu	2026-05-13 16:05:05.985942+00	2026-05-13 16:02:44.320839+00		\N		\N			\N	2026-05-13 16:05:05.992699+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-05-08 16:26:02.151492+00	2026-05-13 16:05:06.010965+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	22222222-2222-2222-2222-222222222221	authenticated	authenticated	admin@easyhouse.com	$2a$10$vI8aWBnW3fID.m4/SNnbA.C9hM9p.cW7uP9GZcTfJ3dD6Q9lT.Yxa	2026-05-23 11:52:59.723797+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{}	\N	2026-05-23 11:52:59.723797+00	2026-05-23 11:52:59.723797+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	22222222-2222-2222-2222-222222222222	authenticated	authenticated	chunha@easyhouse.com	$2a$10$vI8aWBnW3fID.m4/SNnbA.C9hM9p.cW7uP9GZcTfJ3dD6Q9lT.Yxa	2026-05-23 11:52:59.723797+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{}	\N	2026-05-23 11:52:59.723797+00	2026-05-23 11:52:59.723797+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	22222222-2222-2222-2222-222222222223	authenticated	authenticated	khachthue1@easyhouse.com	$2a$10$vI8aWBnW3fID.m4/SNnbA.C9hM9p.cW7uP9GZcTfJ3dD6Q9lT.Yxa	2026-05-23 11:52:59.723797+00	\N	\N	\N	\N	\N	\N	\N	\N	\N	{"provider": "email", "providers": ["email"]}	{}	\N	2026-05-23 11:52:59.723797+00	2026-05-23 11:52:59.723797+00	\N	\N			\N		0	\N		\N	f	\N	f
\.

--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") FROM stdin;
8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139	8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139	{"sub": "8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139", "email": "vyt22052006@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-05-08 16:26:02.171737+00	2026-05-08 16:26:02.171798+00	2026-05-08 16:26:02.171798+00	4164f40a-ea09-4b2f-96dd-a36c05d343b3
\.

--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."instances" ("id", "uuid", "raw_base_config", "created_at", "updated_at") FROM stdin;
\.

--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."oauth_clients" ("id", "client_secret_hash", "registration_type", "redirect_uris", "grant_types", "client_name", "client_uri", "logo_uri", "created_at", "updated_at", "deleted_at", "client_type", "token_endpoint_auth_method") FROM stdin;
\.

--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."sessions" ("id", "user_id", "created_at", "updated_at", "factor_id", "aal", "not_after", "refreshed_at", "user_agent", "ip", "tag", "oauth_client_id", "refresh_token_hmac_key", "refresh_token_counter", "scopes") FROM stdin;
642f3c07-b80d-4ac8-8e24-57f710332e22	8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139	2026-05-13 16:05:05.993855+00	2026-05-13 16:05:05.993855+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	118.68.0.62	\N	\N	\N	\N	\N
\.

--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") FROM stdin;
642f3c07-b80d-4ac8-8e24-57f710332e22	2026-05-13 16:05:06.011582+00	2026-05-13 16:05:06.011582+00	otp	e6505051-df34-4ca8-8e57-78140902dad2
\.

--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."mfa_factors" ("id", "user_id", "friendly_name", "factor_type", "status", "created_at", "updated_at", "secret", "phone", "last_challenged_at", "web_authn_credential", "web_authn_aaguid", "last_webauthn_challenge_data") FROM stdin;
\.

--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."mfa_challenges" ("id", "factor_id", "created_at", "verified_at", "ip_address", "otp_code", "web_authn_session_data") FROM stdin;
\.

--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."oauth_authorizations" ("id", "authorization_id", "client_id", "user_id", "redirect_uri", "scope", "state", "resource", "code_challenge", "code_challenge_method", "response_type", "status", "authorization_code", "created_at", "expires_at", "approved_at", "nonce") FROM stdin;
\.

--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."oauth_client_states" ("id", "provider_type", "code_verifier", "created_at") FROM stdin;
\.

--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."oauth_consents" ("id", "user_id", "client_id", "scopes", "granted_at", "revoked_at") FROM stdin;
\.

--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."one_time_tokens" ("id", "user_id", "token_type", "token_hash", "relates_to", "created_at", "updated_at") FROM stdin;
\.

--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."refresh_tokens" ("instance_id", "id", "token", "user_id", "revoked", "created_at", "updated_at", "parent", "session_id") FROM stdin;
00000000-0000-0000-0000-000000000000	1	kssiz3i4sca3	8b8dfeb1-aa0d-43b9-a9b2-83f5e5c12139	f	2026-05-13 16:05:06.001401+00	2026-05-13 16:05:06.001401+00	\N	642f3c07-b80d-4ac8-8e24-57f710332e22
\.

--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."sso_providers" ("id", "resource_id", "created_at", "updated_at", "disabled") FROM stdin;
\.

--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."saml_providers" ("id", "sso_provider_id", "entity_id", "metadata_xml", "metadata_url", "attribute_mapping", "created_at", "updated_at", "name_id_format") FROM stdin;
\.

--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."saml_relay_states" ("id", "sso_provider_id", "request_id", "for_email", "redirect_to", "created_at", "updated_at", "flow_state_id") FROM stdin;
\.

--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."sso_domains" ("id", "sso_provider_id", "domain", "created_at", "updated_at") FROM stdin;
\.

--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."webauthn_challenges" ("id", "user_id", "challenge_type", "session_data", "created_at", "expires_at") FROM stdin;
\.

--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."webauthn_credentials" ("id", "user_id", "credential_id", "public_key", "attestation_type", "aaguid", "sign_count", "transports", "backup_eligible", "backed_up", "friendly_name", "created_at", "updated_at", "last_used_at") FROM stdin;
\.

--
-- Data for Name: nguoi_dung; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."nguoi_dung" ("id", "email", "ho_ten", "so_dien_thoai", "anh_dai_dien", "ngay_sinh", "gioi_tinh", "dia_chi", "que_quan", "so_cccd", "trang_thai", "so_lan_dang_nhap_sai", "khoa_den_luc", "lan_dang_nhap_cuoi", "cau_hinh_2fa", "tao_luc", "cap_nhat_luc", "xoa_luc", "mat_khau", "trang_thai_kyc", "anh_cccd_truoc", "anh_cccd_sau", "anh_gpkd") FROM stdin;
627d6150-9fe6-41e4-98fd-e966fb11d5f2	landlord@easyhouse.local	Chủ trọ Nguyễn Văn A	0912345678	\N	\N	\N	\N	\N	\N	ACTIVE	0	\N	2026-06-03 13:31:16.979216+00	\N	2026-06-01 07:58:14.319189+00	2026-06-03 13:31:16.667031+00	\N	$2a$10$/wby0sv2LQWXEr30TvkV..psO02BvfRAzII1HHOM0fr3YtZHMB3QW	NONE	\N	\N	\N
7be2a683-5537-41c2-b834-ea534816a945	tenant@easyhouse.local	Khách thuê Trần Văn B	0987654322	\N	\N	\N	\N	\N	\N	ACTIVE	0	\N	2026-06-10 03:38:32.785276+00	\N	2026-06-01 07:59:02.593872+00	2026-06-10 03:38:33.405629+00	\N	$2a$10$dOJwunaf3W3V2WHDPoFtZ.7hRbo1YN7vBkwZBAgccTO6YxPK9U.7G	NONE	\N	\N	\N
c7cdde54-c62a-42af-8bec-62e37f3fde83	debug-register-3000@example.com	Debug User 2	0912345680	\N	\N	\N	\N	\N	\N	INACTIVE	0	\N	\N	\N	2026-05-24 07:16:00.12531+00	2026-05-24 07:16:00.12531+00	\N	$2a$10$qN3PLQcv89yijxXd1KdSJORG2J8zxZmzSr7yMQ3EoAUIFprp329dW	NONE	\N	\N	\N
3b6141c5-a1f0-4bc5-9c17-4fa329b52c29	debug-register-8080@example.com	Debug User	0912345679	\N	\N	\N	\N	\N	\N	INACTIVE	0	\N	\N	\N	2026-05-24 07:16:00.12531+00	2026-05-24 07:16:00.12531+00	\N	$2a$10$3KqyBopasVqD0SJpIUO05OCfjTFQzU6JKy6N9YoT/IRylOUsrEaPm	NONE	\N	\N	\N
91e602be-25b8-4fd4-9769-b307cd9af888	qa20260531103454@easyhouse.local	QA Tester	0952389887	\N	\N	\N	\N	\N	\N	INACTIVE	0	\N	2026-05-31 04:48:22.725192+00	\N	2026-05-31 03:34:55.378731+00	2026-05-31 04:47:51.213228+00	\N	$2a$10$tTQT67M8Jy6wsxBnzw5XR.CUg7dL24zOs2N12RQFaKkA99RR8u9eq	NONE	\N	\N	\N
f7fe48c3-2101-45ba-86cd-26f0bf28a923	gtruc2146@gmail.com	hàng thị trúc giang	0357165019	\N	\N	\N	\N	\N	\N	INACTIVE	0	\N	2026-05-31 06:29:03.100084+00	\N	2026-05-31 06:13:54.093302+00	2026-05-31 06:29:03.08643+00	\N	$2a$10$lDAs9zOQkSzrY1ypRNN0teOBbUi5ABZdOYGuAaU6XUAHVN1St5FW.	NONE	\N	\N	\N
4e0b7b88-3763-4732-a1cf-c2d0707b0511	trson6626@gmail.com	Sơn	0973021078	\N	\N	\N	\N	\N	\N	INACTIVE	0	\N	2026-06-13 16:25:38.831148+00	\N	2026-05-26 13:42:56.668298+00	2026-06-13 16:25:01.97918+00	\N	$2a$10$tL8qAutB/LCGJNO9eu0rX.Dqgt1W/Q7.0ozElJA4Ynhkg/hh7D8j6	NONE	\N	\N	\N
814e5dd5-9805-4566-814a-0b97df3978d0	sown06@gmail.com	Sơn	0873021078	\N	\N	\N	\N	\N	\N	INACTIVE	0	\N	2026-06-10 02:37:01.826193+00	\N	2026-05-30 04:15:00.312795+00	2026-06-13 16:26:00.518637+00	2026-06-13 16:26:37.253743+00	$2a$10$qFjY/ZUGpWV0GXs9.40V..8/MmXc.ZWwd9wA2s738ZTIAbeaUnCGy	NONE	\N	\N	\N
3047f731-7822-47dd-930e-17c9b658cf55	sown123@gmail.com	Sơn	0987654321	\N	\N	\N	\N	\N	\N	INACTIVE	0	\N	2026-06-10 02:37:17.139297+00	\N	2026-05-29 04:43:04.564609+00	2026-06-10 02:36:41.037693+00	\N	$2a$10$ikBOHvvH5YixT6CYUSvDM.EThYIqIojDrdrud9cMsZDBarV/0y5P6	NONE	\N	\N	\N
dc440559-dd1c-462c-832f-a5bb648d9199	trsown6626@gmail.com	Sơn	0966313728	\N	\N	\N	\N	\N	\N	INACTIVE	0	\N	2026-05-30 04:13:36.669063+00	\N	2026-05-29 04:39:31.456623+00	2026-06-13 16:26:27.737392+00	2026-06-13 16:27:04.470449+00	$2a$10$WYI065c1V/APltAPON9GE.TUNzWN10KBqiOih0UNk/96G.n7gP4re	NONE	\N	\N	\N
c4e8b2dc-daf4-47aa-a573-8383561351af	khach01@gmail.com	Khách 01	0839402890	\N	\N	\N	\N	\N	\N	INACTIVE	0	\N	2026-06-13 16:30:01.983923+00	\N	2026-06-13 06:57:20.647011+00	2026-06-13 16:29:25.0693+00	\N	$2a$10$Q5Ig6DYgdGFPr1XikdLMNO..5hzPj40Ke9KZ9fqTppwwunN0SBpyi	NONE	\N	\N	\N
7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	Sơn	0336073019		\N	\N		\N	\N	INACTIVE	0	\N	2026-06-13 16:30:45.077795+00	\N	2026-05-24 07:16:34.769366+00	2026-06-13 16:30:08.155019+00	\N	$2a$10$Lt1aoIWJA5RQuZUFVCelROCr/npkwWS.vFGI7Fy.Z40RoFOlkybRO	NONE	\N	\N	\N
262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	Admin EasyHouse	0973686868	\N	\N	\N	\N	\N	\N	ACTIVE	0	\N	2026-06-13 16:44:50.729453+00	\N	2026-06-01 07:58:13.325673+00	2026-06-13 16:44:13.891114+00	\N	$2a$10$7Osg/WNhzDa8Pl7PeoHrX.tw/OTj2kaQZjTEq6ZuWKt.zmr9WLFuK	NONE	\N	\N	\N
00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	đỗ chí công	0369963725		\N	\N	\N	\N	\N	INACTIVE	0	\N	2026-06-13 22:07:37.201107+00	\N	2026-05-23 16:22:37.909919+00	2026-06-13 22:07:38.976442+00	\N	$2a$10$uMVwgtmD.HRIgVhCGS0dQ.GqmZMoz9njHqj3CaPXXACJtOXGVyFa.	NONE	\N	\N	\N
f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	vyt22052006@gmail.com	Trần Triệu Vỹ	0374729356	\N	\N	\N	\N	\N	\N	ACTIVE	0	\N	2026-06-13 23:42:21.508892+00	\N	2026-05-24 06:02:41.070046+00	2026-06-13 23:42:21.999283+00	\N	$2a$10$6ruK4Qmi2HAjzhvv03BJLelcKw9XBTjIS3Ao8OX42ceX8zW9.5jOK	NONE	\N	\N	\N
5e289847-fa1e-402e-8f46-863cf0d3c395	vyttt22052006@gmail.com	Trần Vỹ Khách Thuê	0374729354	\N	\N	\N	\N	\N	\N	ACTIVE	0	\N	2026-06-13 23:47:07.376463+00	\N	2026-06-10 03:40:03.440591+00	2026-06-13 23:47:07.958606+00	\N	$2a$10$4rKMeQheHlNvmnj59OwyDeDlVC9KAwmbt62.dmmP5AdUXvdatV6u6	NONE	\N	\N	\N
\.

--
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."audit_log" ("id", "nguoi_dung_id", "hanh_dong", "bang_tac_dong", "ban_ghi_id", "du_lieu_cu", "du_lieu_moi", "ip_address", "user_agent", "tao_luc") FROM stdin;
6d030b18-2376-4dbd-8944-a2b98e2c027b	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-05-26 18:17:15.80384+00
ebce0188-a604-4a30-ab82-777257d957ab	00b4c56f-45fa-49a2-874b-601bc77dcb65	CREATE	thanh_toan	3c3ddefe-cb7b-43d1-b730-d54e0454119d	\N	\N	\N	\N	2026-05-26 18:20:54.868722+00
224eef21-3055-4201-a5f0-ddec67ddbaf7	00b4c56f-45fa-49a2-874b-601bc77dcb65	CREATE	thanh_toan	636a8a37-fd70-4336-b4ee-48e0a1078a85	\N	\N	\N	\N	2026-05-26 18:22:08.230597+00
ef6fac96-79bd-4190-b4cb-49c441044e20	00b4c56f-45fa-49a2-874b-601bc77dcb65	CREATE	lich_hen	ae6127cf-cd47-4624-a9bd-c99d9f508f46	\N	\N	\N	\N	2026-05-26 18:23:49.728459+00
7afaf89d-c667-46ae-9429-730ef48c0774	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-05-27 01:55:32.787693+00
9af47cdb-a3c0-43f6-a102-195493b3e84d	00b4c56f-45fa-49a2-874b-601bc77dcb65	CREATE	cau_hinh_gia	dbd82777-3e3b-4e21-bd1a-c6e893f046f9	\N	\N	\N	\N	2026-05-27 02:15:01.420211+00
ea2fa334-90e3-440f-98b5-46e7937f4883	00b4c56f-45fa-49a2-874b-601bc77dcb65	CREATE	cau_hinh_gia	22740db5-ebfb-4fa7-b5bb-a0b58f092fb3	\N	\N	\N	\N	2026-05-27 02:15:20.606276+00
e522e7c4-366c-46d5-b8d3-167f567059ad	00b4c56f-45fa-49a2-874b-601bc77dcb65	CREATE	cau_hinh_gia	c1111ed2-f2e3-4591-83cb-75434bcdcd3a	\N	\N	\N	\N	2026-05-27 02:15:37.236688+00
8dd815a4-b9bc-47ba-92d3-9ccad633f25b	00b4c56f-45fa-49a2-874b-601bc77dcb65	CREATE	cau_hinh_gia	67fc56a3-6730-4d15-b3af-cc855bdaf343	\N	\N	\N	\N	2026-05-27 02:15:58.510578+00
e834131d-b9eb-405f-aa8a-bbf49d8da65c	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	LOGIN	nguoi_dung	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	\N	\N	\N	\N	2026-05-29 16:13:17.649042+00
3a291f17-e8a9-4c27-8d97-5a9f44d5cf03	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-05-29 17:43:25.447035+00
be545884-7a6d-4ab3-9186-dd9d3521bc47	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-05-29 17:47:54.156904+00
4ba42712-b38b-4cd7-9395-e3ab79376db3	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-05-29 17:53:11.086739+00
a9eb6904-c1b9-47ec-8115-06db355d1cc2	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-05-30 02:55:29.843091+00
60192ccd-23f6-447f-807e-01c554901574	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-05-30 02:56:03.713098+00
089ba293-9f3e-4285-8925-daf967486104	00b4c56f-45fa-49a2-874b-601bc77dcb65	CREATE	su_co	b763fba3-b6cd-4163-9429-08cbbb229426	\N	\N	\N	\N	2026-05-30 02:56:08.773843+00
3b5107cb-f393-45a1-a8c4-909488585f02	00b4c56f-45fa-49a2-874b-601bc77dcb65	CREATE	su_co	af6ecffe-b9c5-473d-a9d6-61331cbd0756	\N	\N	\N	\N	2026-05-30 02:56:10.443249+00
56745591-f703-494f-96c2-5a8152d30a5f	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-05-30 02:56:30.054918+00
2bd3cdd1-8b05-41bb-879e-41ebceb39f10	00b4c56f-45fa-49a2-874b-601bc77dcb65	CREATE	su_co	255b3ed5-7381-45d5-825c-8236b60f01e2	\N	\N	\N	\N	2026-05-30 02:56:31.494893+00
54e7c244-9840-41b0-8bcf-37dd4baa9e54	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	CREATE	su_co	c68fc8e4-3746-4d98-ab4f-ca5558fdab80	\N	\N	\N	\N	2026-05-30 03:42:43.097154+00
4d587cd2-687c-4804-afa8-095fb41e8acd	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	CREATE	su_co	e4c9b92a-2365-41aa-bba3-4163bf1c4878	\N	\N	\N	\N	2026-05-30 03:42:44.200771+00
18f07183-7253-45f7-a75b-d2f4a979146b	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	CREATE	su_co	49c55f0a-4c32-40af-97d9-1b64dc801a5c	\N	\N	\N	\N	2026-05-30 03:42:45.164617+00
1ca733d5-f088-4812-80c9-455e443c3f25	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-05-30 04:01:54.578877+00
b0f87667-28d7-46b4-8e9b-83545895b615	dc440559-dd1c-462c-832f-a5bb648d9199	LOGIN	nguoi_dung	dc440559-dd1c-462c-832f-a5bb648d9199	\N	\N	\N	\N	2026-05-30 04:11:30.429588+00
e7ed2094-600d-49bd-b4e6-80df02c631fe	dc440559-dd1c-462c-832f-a5bb648d9199	LOGIN	nguoi_dung	dc440559-dd1c-462c-832f-a5bb648d9199	\N	\N	\N	\N	2026-05-30 04:11:35.664502+00
eac168d2-94d5-47b5-a5c4-1125eb347a62	dc440559-dd1c-462c-832f-a5bb648d9199	LOGIN	nguoi_dung	dc440559-dd1c-462c-832f-a5bb648d9199	\N	\N	\N	\N	2026-05-30 04:11:48.434918+00
99dffb19-ed13-4e36-9791-bb06a936a5ea	dc440559-dd1c-462c-832f-a5bb648d9199	LOGIN	nguoi_dung	dc440559-dd1c-462c-832f-a5bb648d9199	\N	\N	\N	\N	2026-05-30 04:12:03.878976+00
d75937d6-177f-473b-81eb-5cdb902a7770	dc440559-dd1c-462c-832f-a5bb648d9199	LOGIN	nguoi_dung	dc440559-dd1c-462c-832f-a5bb648d9199	\N	\N	\N	\N	2026-05-30 04:12:48.624514+00
410b8837-f717-4fbd-8186-ac43495833c8	dc440559-dd1c-462c-832f-a5bb648d9199	LOGIN	nguoi_dung	dc440559-dd1c-462c-832f-a5bb648d9199	\N	\N	\N	\N	2026-05-30 04:13:36.781583+00
5bb8b35e-12aa-46b5-8b24-f4a53d78fec9	3047f731-7822-47dd-930e-17c9b658cf55	LOGIN	nguoi_dung	3047f731-7822-47dd-930e-17c9b658cf55	\N	\N	\N	\N	2026-05-30 04:13:54.653135+00
5c029e94-0fd4-4d9b-8e74-12ef6ff56138	814e5dd5-9805-4566-814a-0b97df3978d0	REGISTER	nguoi_dung	814e5dd5-9805-4566-814a-0b97df3978d0	\N	\N	\N	\N	2026-05-30 04:15:01.744008+00
47c360ef-790f-420c-a873-f922f49f2d93	814e5dd5-9805-4566-814a-0b97df3978d0	LOGIN	nguoi_dung	814e5dd5-9805-4566-814a-0b97df3978d0	\N	\N	\N	\N	2026-05-30 04:15:11.106854+00
2837e320-f5ad-4805-a5e3-46d49352b572	814e5dd5-9805-4566-814a-0b97df3978d0	LOGIN	nguoi_dung	814e5dd5-9805-4566-814a-0b97df3978d0	\N	\N	\N	\N	2026-05-30 04:15:23.42253+00
108b138d-fa00-4a6e-9305-306beeb39fb0	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-05-30 04:15:34.342062+00
72ad5912-59fe-4d25-9504-8e643bbb58ed	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-05-30 07:14:29.069444+00
e7a2b8b4-1997-4be6-9f3c-5a4d74ae7469	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-05-30 07:15:12.725235+00
d967a8db-c334-4547-bf53-c37dcf85cba6	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-05-30 08:46:17.353511+00
add54dfb-0c29-4c75-8a0b-de2c3d9a486b	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-05-31 03:07:43.397256+00
8bfe3416-a0d1-49dd-9824-8ca2dfece163	91e602be-25b8-4fd4-9769-b307cd9af888	REGISTER	nguoi_dung	91e602be-25b8-4fd4-9769-b307cd9af888	\N	\N	\N	\N	2026-05-31 03:34:56.72027+00
89fa064b-e552-47be-a24d-0b9e6a666c02	91e602be-25b8-4fd4-9769-b307cd9af888	LOGIN	nguoi_dung	91e602be-25b8-4fd4-9769-b307cd9af888	\N	\N	\N	\N	2026-05-31 03:34:57.447207+00
012d2b4c-7d5e-4e1c-b619-ed0f53f6c7ef	91e602be-25b8-4fd4-9769-b307cd9af888	LOGIN	nguoi_dung	91e602be-25b8-4fd4-9769-b307cd9af888	\N	\N	\N	\N	2026-05-31 03:35:14.03304+00
dea8326c-1780-44ce-a7fc-5c858d522872	91e602be-25b8-4fd4-9769-b307cd9af888	LOGIN	nguoi_dung	91e602be-25b8-4fd4-9769-b307cd9af888	\N	\N	\N	\N	2026-05-31 03:37:30.966466+00
549f60bd-569b-410f-a7d5-5ea005b2289a	91e602be-25b8-4fd4-9769-b307cd9af888	CREATE	su_co	bc7a078a-48b9-489e-b996-febe87075f51	\N	\N	\N	\N	2026-05-31 03:37:39.382171+00
a40f0d9f-d8e1-4f07-9f56-273da21373b4	91e602be-25b8-4fd4-9769-b307cd9af888	UPDATE	su_co	bc7a078a-48b9-489e-b996-febe87075f51	\N	\N	\N	\N	2026-05-31 03:37:40.721703+00
65e1ea8a-7379-4c95-935e-83b563a667d2	91e602be-25b8-4fd4-9769-b307cd9af888	CANCEL	su_co	bc7a078a-48b9-489e-b996-febe87075f51	\N	\N	\N	\N	2026-05-31 03:37:41.937049+00
29a86bf6-c98f-454a-8bc1-ac5d8785b777	91e602be-25b8-4fd4-9769-b307cd9af888	LOGIN	nguoi_dung	91e602be-25b8-4fd4-9769-b307cd9af888	\N	\N	\N	\N	2026-05-31 03:38:07.077179+00
76534756-7649-4c4e-b305-aef47d81459c	91e602be-25b8-4fd4-9769-b307cd9af888	LOGIN	nguoi_dung	91e602be-25b8-4fd4-9769-b307cd9af888	\N	\N	\N	\N	2026-05-31 03:48:42.206391+00
911fe15f-b147-4e32-9ed0-90406d63f404	91e602be-25b8-4fd4-9769-b307cd9af888	LOGIN	nguoi_dung	91e602be-25b8-4fd4-9769-b307cd9af888	\N	\N	\N	\N	2026-05-31 03:51:24.241708+00
58fb2633-5b57-4d61-8cfe-407ee0428d0f	91e602be-25b8-4fd4-9769-b307cd9af888	LOGIN	nguoi_dung	91e602be-25b8-4fd4-9769-b307cd9af888	\N	\N	\N	\N	2026-05-31 04:10:16.408237+00
a46c8223-db6f-43bb-9e33-c3e8174ff11b	91e602be-25b8-4fd4-9769-b307cd9af888	LOGIN	nguoi_dung	91e602be-25b8-4fd4-9769-b307cd9af888	\N	\N	\N	\N	2026-05-31 04:11:19.299093+00
921474b9-5903-4bb6-9366-6d17687045a0	91e602be-25b8-4fd4-9769-b307cd9af888	CREATE	su_co	9e5bccfd-d110-43da-aefd-1ed0db3ef7b3	\N	\N	\N	\N	2026-05-31 04:11:23.22023+00
2fbcf773-b10a-4b77-8192-d4fccaca7d0f	91e602be-25b8-4fd4-9769-b307cd9af888	CANCEL	su_co	9e5bccfd-d110-43da-aefd-1ed0db3ef7b3	\N	\N	\N	\N	2026-05-31 04:11:24.481178+00
1846bbc5-171b-41ce-a7b6-d0bf5df46b29	91e602be-25b8-4fd4-9769-b307cd9af888	LOGIN	nguoi_dung	91e602be-25b8-4fd4-9769-b307cd9af888	\N	\N	\N	\N	2026-05-31 04:16:10.731399+00
fbd06299-2d67-4c7a-9e60-ad4b1d10c96a	91e602be-25b8-4fd4-9769-b307cd9af888	LOGIN	nguoi_dung	91e602be-25b8-4fd4-9769-b307cd9af888	\N	\N	\N	\N	2026-05-31 04:48:22.82335+00
caf42f0e-ddf5-4ffa-a57b-f294965e4c21	f7fe48c3-2101-45ba-86cd-26f0bf28a923	REGISTER	nguoi_dung	f7fe48c3-2101-45ba-86cd-26f0bf28a923	\N	\N	\N	\N	2026-05-31 06:14:23.033908+00
9c25c5dc-aae8-411f-a3f9-3874b2f9ad51	f7fe48c3-2101-45ba-86cd-26f0bf28a923	LOGIN	nguoi_dung	f7fe48c3-2101-45ba-86cd-26f0bf28a923	\N	\N	\N	\N	2026-05-31 06:14:34.92533+00
1dbd70ff-baab-4509-a16d-4418712e8094	f7fe48c3-2101-45ba-86cd-26f0bf28a923	LOGIN	nguoi_dung	f7fe48c3-2101-45ba-86cd-26f0bf28a923	\N	\N	\N	\N	2026-05-31 06:14:48.201153+00
43bcc081-05bc-4c37-837d-249f95f499c9	f7fe48c3-2101-45ba-86cd-26f0bf28a923	LOGIN	nguoi_dung	f7fe48c3-2101-45ba-86cd-26f0bf28a923	\N	\N	\N	\N	2026-05-31 06:16:23.002769+00
f23e2b73-62a8-4c21-93c0-2b25faa3d335	f7fe48c3-2101-45ba-86cd-26f0bf28a923	LOGIN	nguoi_dung	f7fe48c3-2101-45ba-86cd-26f0bf28a923	\N	\N	\N	\N	2026-05-31 06:16:36.227804+00
8fc883b2-8013-4f71-86e5-0126adc2cd73	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-05-31 06:25:48.06959+00
ae8ecafb-f8db-424f-8070-13027af86ba7	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-05-31 06:27:59.669477+00
913f57b3-c0ee-4a8d-a88f-b3a941d63c13	f7fe48c3-2101-45ba-86cd-26f0bf28a923	LOGIN	nguoi_dung	f7fe48c3-2101-45ba-86cd-26f0bf28a923	\N	\N	\N	\N	2026-05-31 06:29:03.205299+00
723dca2f-1fd1-4aa8-aea5-7c8ebd862607	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-05-31 06:32:59.841129+00
c6c0f91e-6c38-4660-9eef-a4c8de05b6e0	00b4c56f-45fa-49a2-874b-601bc77dcb65	CREATE	lich_hen	a7806004-e7cb-4ccf-983e-59fd751333d3	\N	\N	\N	\N	2026-05-31 06:36:32.195607+00
1e236077-508b-4286-990c-34d111335cac	00b4c56f-45fa-49a2-874b-601bc77dcb65	UPDATE_STATUS	lich_hen	a7806004-e7cb-4ccf-983e-59fd751333d3	\N	\N	\N	\N	2026-05-31 06:37:00.048523+00
721223de-da3d-44e4-8d94-a977b1db8523	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-05-31 14:15:35.687605+00
f712f1a3-d609-4fd7-8fa3-b69a69cc8cd9	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-05-31 14:44:14.590086+00
5d5499f5-e0bc-47a1-b0c2-096aff7b075e	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-01 02:29:13.566254+00
cfa4cbd6-d369-4820-89b2-7f03ba10e7fd	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-01 02:35:22.125966+00
bf170b20-6526-4728-a13a-90e057794c89	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-01 02:51:07.025099+00
fb2cab40-fb70-4915-a3ec-2fb298ffd778	00b4c56f-45fa-49a2-874b-601bc77dcb65	CREATE	hoa_don	c4d29bf7-18cd-4b37-93ad-1f413583193a	\N	\N	\N	\N	2026-06-01 03:44:26.363242+00
dd660f25-0eab-4a1a-a2f4-4a2a6ba7bc61	00b4c56f-45fa-49a2-874b-601bc77dcb65	SEND	hoa_don	c4d29bf7-18cd-4b37-93ad-1f413583193a	\N	\N	\N	\N	2026-06-01 03:44:27.264828+00
b88e3db2-4285-4477-b31c-81cc5840bd23	00b4c56f-45fa-49a2-874b-601bc77dcb65	CREATE	thanh_toan	8cc3a622-1745-4b33-8224-a233b3e22eac	\N	\N	\N	\N	2026-06-01 03:45:01.878908+00
fca028ea-47c3-4858-9d52-155cd5f086ce	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-01 06:14:17.889831+00
3707201c-56a3-4cb6-ae37-09617c68b3b8	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	LOGIN	nguoi_dung	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	\N	\N	\N	\N	2026-06-01 07:52:58.196575+00
5ccd2764-df72-4b8f-bc97-ddd422589569	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-01 08:02:35.579134+00
d98192c8-b3db-4480-93c1-a8111bbbe4d4	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-01 08:06:10.935851+00
e89e0400-d548-46b6-8210-618cb7be8ae2	627d6150-9fe6-41e4-98fd-e966fb11d5f2	LOGIN	nguoi_dung	627d6150-9fe6-41e4-98fd-e966fb11d5f2	\N	\N	\N	\N	2026-06-01 08:06:08.779707+00
fdaea2de-baa5-4462-808f-237f223597fb	7be2a683-5537-41c2-b834-ea534816a945	LOGIN	nguoi_dung	7be2a683-5537-41c2-b834-ea534816a945	\N	\N	\N	\N	2026-06-01 08:08:10.321015+00
266705df-2232-476d-8d08-ebc9637b0435	7be2a683-5537-41c2-b834-ea534816a945	LOGIN	nguoi_dung	7be2a683-5537-41c2-b834-ea534816a945	\N	\N	\N	\N	2026-06-01 08:08:22.512617+00
c276d7d9-1de0-4b7e-9b30-0b038938603b	627d6150-9fe6-41e4-98fd-e966fb11d5f2	LOGIN	nguoi_dung	627d6150-9fe6-41e4-98fd-e966fb11d5f2	\N	\N	\N	\N	2026-06-01 08:09:21.917393+00
d71ac185-fbcd-4c84-bed3-3b7f861e532d	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-01 08:21:47.671848+00
c16ad921-74f4-4160-8dee-371f3f31883a	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-01 08:48:23.967878+00
65962def-a581-46c0-8faa-2dfe46166cbf	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-01 18:07:47.62151+00
302fb48e-2bc2-46d7-ab84-80c2ca665f67	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-02 01:45:25.893013+00
7fa24806-5f67-426f-9c1f-ef8166778373	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-02 01:57:51.71916+00
aea48284-6d97-455d-9865-e152d54c2ff7	00b4c56f-45fa-49a2-874b-601bc77dcb65	CREATE	hoa_don	3f09457f-c8ef-4eeb-b1ff-0959ac97417c	\N	\N	\N	\N	2026-06-02 02:13:39.788056+00
c26088dc-9f56-43f0-a980-64395ed01753	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-02 14:02:55.838601+00
e3098db8-8395-4dae-906f-365a675c857b	7be2a683-5537-41c2-b834-ea534816a945	LOGIN	nguoi_dung	7be2a683-5537-41c2-b834-ea534816a945	\N	\N	\N	\N	2026-06-02 15:03:14.014367+00
2b7b64f3-eef6-4437-b876-17decf38c04b	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-02 16:34:59.342404+00
1544b307-707f-48f8-b8e7-43e178349d70	814e5dd5-9805-4566-814a-0b97df3978d0	LOGIN	nguoi_dung	814e5dd5-9805-4566-814a-0b97df3978d0	\N	\N	\N	\N	2026-06-03 03:35:00.979479+00
92a2b61c-6b1d-455e-9c88-66349336684f	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-03 12:55:37.654772+00
4c18aa39-10cd-46e3-a6a2-038a9e11a542	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-03 12:56:58.494539+00
c6b92497-25b5-49ee-9deb-9249ec7df76d	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-03 13:02:59.576059+00
4f33706c-0d2e-4851-89ab-6b307dba407d	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-03 13:21:57.715918+00
38a3bbf6-b03a-4a78-8965-a998ae99a6f6	7be2a683-5537-41c2-b834-ea534816a945	LOGIN	nguoi_dung	7be2a683-5537-41c2-b834-ea534816a945	\N	\N	\N	\N	2026-06-03 13:30:38.544475+00
f7acd0a2-8326-4086-bf19-1956c89a2ab1	627d6150-9fe6-41e4-98fd-e966fb11d5f2	LOGIN	nguoi_dung	627d6150-9fe6-41e4-98fd-e966fb11d5f2	\N	\N	\N	\N	2026-06-03 13:31:17.286448+00
6df19f15-4a2c-44d2-b195-f3f87e0794eb	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-03 14:28:54.153361+00
a6cba1c1-011b-4fc2-93a2-81a98cf67c77	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-03 14:36:37.200458+00
a4d738f0-585b-4dfb-b333-90bacc728f1d	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-03 15:38:56.149869+00
91733b84-a5e4-4e35-9c30-96c8ae8db928	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-03 15:50:36.021667+00
8daf972f-f65d-4c90-8c21-4988f760b33c	814e5dd5-9805-4566-814a-0b97df3978d0	LOGIN	nguoi_dung	814e5dd5-9805-4566-814a-0b97df3978d0	\N	\N	\N	\N	2026-06-03 15:53:36.069758+00
798b6e04-7bb2-4748-b9db-86a72c40be7e	3047f731-7822-47dd-930e-17c9b658cf55	LOGIN	nguoi_dung	3047f731-7822-47dd-930e-17c9b658cf55	\N	\N	\N	\N	2026-06-03 15:53:55.003064+00
773f6f80-7b82-48ab-ad25-177bac627fd0	3047f731-7822-47dd-930e-17c9b658cf55	LOGIN	nguoi_dung	3047f731-7822-47dd-930e-17c9b658cf55	\N	\N	\N	\N	2026-06-03 15:55:04.75952+00
eeb7271f-e78f-4145-a885-e7468ca0cec9	3047f731-7822-47dd-930e-17c9b658cf55	LOGIN	nguoi_dung	3047f731-7822-47dd-930e-17c9b658cf55	\N	\N	\N	\N	2026-06-03 15:55:58.776416+00
09e35a0a-9e6b-42e3-9e13-e4d161053143	3047f731-7822-47dd-930e-17c9b658cf55	LOGIN	nguoi_dung	3047f731-7822-47dd-930e-17c9b658cf55	\N	\N	\N	\N	2026-06-03 15:56:24.756048+00
6c2fc519-7ecf-4ead-8121-e4ce74aa3608	3047f731-7822-47dd-930e-17c9b658cf55	LOGIN	nguoi_dung	3047f731-7822-47dd-930e-17c9b658cf55	\N	\N	\N	\N	2026-06-03 15:57:01.630289+00
fc3ce24d-9e21-4dd3-a75d-258e41dbafc1	3047f731-7822-47dd-930e-17c9b658cf55	LOGIN	nguoi_dung	3047f731-7822-47dd-930e-17c9b658cf55	\N	\N	\N	\N	2026-06-03 15:57:08.164455+00
f0da2ae7-aa19-44bf-afc5-a9ee614a3fb9	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-03 15:57:30.509554+00
7a39597b-1875-461e-b600-22d68938922d	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-03 16:58:34.923248+00
cee0e4d8-5f69-4638-8101-9a596a6d5fae	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-03 17:01:28.638644+00
1d75168c-7c00-443b-a382-94751b4ed482	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-03 17:25:58.324563+00
2ef84479-ac85-4b95-9d12-02e262570013	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-04 03:10:52.716798+00
48a5edcf-c828-427d-88e1-b37c4d793503	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-04 03:11:22.455813+00
6806e6b2-ed68-494b-af38-c5f6d28932f7	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-04 15:14:10.194695+00
cce40319-abe4-4ac1-9b4c-001636b89bfa	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-04 15:37:02.208801+00
548ec08b-06b6-4dba-a6fe-822374f51ecc	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-04 15:37:21.274939+00
2634fbba-b725-451d-a1d7-8afae71c17f1	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-04 15:45:40.70446+00
de56d296-2c30-4f78-bebf-b512d8bea0bb	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-04 16:09:30.142678+00
6f6af83d-8e0c-4dbc-b63f-e6a8941747fd	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-04 16:13:42.281941+00
461a0a20-923f-4172-b61b-3ae3b75fbdaf	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-05 02:17:12.224856+00
b1d0ccdb-7a33-4772-9e48-eba33e10c734	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-05 02:17:30.457688+00
ee183071-7580-4351-89a3-3c2251df68e2	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-05 09:56:26.115594+00
6b6c5a18-347e-4ffe-8112-24d331c0343e	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-05 10:29:09.890013+00
84134d90-d53f-4c51-bead-5c240b9fb7e1	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-05 10:29:27.122296+00
0abba130-3b8d-4a5c-857e-7c6f8e43c141	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-05 10:36:20.778929+00
22a30989-fd05-4a96-be33-6d1bc49690d9	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	LOGIN	nguoi_dung	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	\N	\N	\N	\N	2026-06-06 14:57:51.825369+00
c100ae57-109c-43e5-b0c9-eda088193db5	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-07 13:51:10.583134+00
074c605b-1ad0-4a29-8dfe-e92b1f7d6b5a	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-07 14:34:12.260932+00
5dd02b71-1983-41ee-a66b-1dd11cd6a001	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-07 14:54:20.955817+00
52fd673b-e417-4354-9720-d22043cfccc8	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-07 15:03:10.651361+00
f0ddfab2-e9d9-43e0-a69b-438579cf18a3	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-08 02:15:02.820851+00
139589aa-12c1-48cc-b2e3-5dd0ddf4e0fe	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	LOGIN	nguoi_dung	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	\N	\N	\N	\N	2026-06-08 03:44:55.324483+00
900acfc5-2cc7-475f-8d58-e94e6f8fb7df	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	LOGIN	nguoi_dung	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	\N	\N	\N	\N	2026-06-08 03:45:09.812215+00
c09ea2f6-1dfe-4ff6-b98b-529a49f447b8	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-08 03:46:16.623281+00
a708e0da-d7d5-46c7-a01f-83c7b9c1bf04	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-08 04:01:51.113999+00
37670dc0-9f9a-4455-97b3-0f80de812a46	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-08 07:24:40.623097+00
ce868eb2-f611-4b55-8240-36e8f7bcd268	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-08 07:41:25.118812+00
797f256e-6d04-49fe-8b30-513b4b4e7ff7	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-09 02:38:58.787275+00
5fac7e88-2344-4bf9-8728-4cfa3b6d0c5a	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-09 09:02:54.122581+00
95c855f2-0de8-412e-a237-c9ada83039be	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 02:08:03.670293+00
9c255009-f977-472b-9b38-944c1a0bfebb	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-10 02:25:37.268262+00
8ef1f42b-1966-4942-991c-95d77679182a	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 02:32:54.091446+00
8270bdb8-1d1f-4fe9-b367-651dc0b890af	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-10 02:35:44.744803+00
c45050f2-0783-4d05-bfba-1ec965fccac3	814e5dd5-9805-4566-814a-0b97df3978d0	LOGIN	nguoi_dung	814e5dd5-9805-4566-814a-0b97df3978d0	\N	\N	\N	\N	2026-06-10 02:37:01.941169+00
7b820fff-cfad-4ad9-bd42-013411e3c556	3047f731-7822-47dd-930e-17c9b658cf55	LOGIN	nguoi_dung	3047f731-7822-47dd-930e-17c9b658cf55	\N	\N	\N	\N	2026-06-10 02:37:17.256273+00
9bca3b7d-436c-4a5d-831d-e43c0e1ed74d	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 02:41:09.577624+00
b7dba250-97e2-48fd-864c-fde67111b829	7be2a683-5537-41c2-b834-ea534816a945	LOGIN	nguoi_dung	7be2a683-5537-41c2-b834-ea534816a945	\N	\N	\N	\N	2026-06-10 02:43:36.856453+00
f38bfb18-fc45-4e62-9194-111ec31eb5e3	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 03:07:59.101735+00
72de42d8-d0fb-4a28-9ea3-7daa081d9870	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 03:16:40.754986+00
efb5db81-67c4-4a1c-b43e-594f5d68b1c0	7be2a683-5537-41c2-b834-ea534816a945	LOGIN	nguoi_dung	7be2a683-5537-41c2-b834-ea534816a945	\N	\N	\N	\N	2026-06-10 03:17:21.626782+00
fe0c469c-068b-4f06-ac3a-601540422bc5	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 03:23:43.23381+00
7082f4f9-3970-475a-b6e8-4cf8c45106de	7be2a683-5537-41c2-b834-ea534816a945	LOGIN	nguoi_dung	7be2a683-5537-41c2-b834-ea534816a945	\N	\N	\N	\N	2026-06-10 03:23:46.665585+00
225053ca-fe25-44bf-8481-e30af1f07a16	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 03:23:55.786806+00
c52c537f-e452-486e-b9fd-69ca7e4b3e99	7be2a683-5537-41c2-b834-ea534816a945	LOGIN	nguoi_dung	7be2a683-5537-41c2-b834-ea534816a945	\N	\N	\N	\N	2026-06-10 03:24:28.567719+00
f7dc038b-bac2-46a5-9b03-74e24acb5697	7be2a683-5537-41c2-b834-ea534816a945	LOGIN	nguoi_dung	7be2a683-5537-41c2-b834-ea534816a945	\N	\N	\N	\N	2026-06-10 03:38:29.513934+00
1f85982c-530d-41b9-afbc-af3033ceeae6	7be2a683-5537-41c2-b834-ea534816a945	LOGIN	nguoi_dung	7be2a683-5537-41c2-b834-ea534816a945	\N	\N	\N	\N	2026-06-10 03:38:32.897347+00
a71e0181-9d18-4933-973a-14009dfdac62	5e289847-fa1e-402e-8f46-863cf0d3c395	REGISTER	nguoi_dung	5e289847-fa1e-402e-8f46-863cf0d3c395	\N	\N	\N	\N	2026-06-10 03:40:05.792819+00
664a1779-4861-4383-82ac-252fe5440a54	5e289847-fa1e-402e-8f46-863cf0d3c395	LOGIN	nguoi_dung	5e289847-fa1e-402e-8f46-863cf0d3c395	\N	\N	\N	\N	2026-06-10 03:40:21.324269+00
0a5ea6f5-2a43-4c76-9b59-e9b81189c3f5	5e289847-fa1e-402e-8f46-863cf0d3c395	CREATE	lich_hen	2ff03ddb-2438-4fcf-bfaf-53d2f437fc1d	\N	\N	\N	\N	2026-06-10 03:52:44.250195+00
74e09791-4df1-41a9-908a-630d50203df4	\N	SYSTEM_CREATE	thong_bao	1ffb09b6-de78-47ae-b7ee-2ab1a7829495	\N	\N	\N	\N	2026-06-10 03:52:45.332626+00
8e876069-c509-43f6-94c8-65d844ad9b8b	262a2469-eec7-470c-bd92-47874baebdea	UPDATE_STATUS	lich_hen	2ff03ddb-2438-4fcf-bfaf-53d2f437fc1d	\N	\N	\N	\N	2026-06-10 03:53:18.870996+00
70c51fd7-1b88-4286-86f0-4cca9c77588b	262a2469-eec7-470c-bd92-47874baebdea	UPDATE_STATUS	lich_hen	2ff03ddb-2438-4fcf-bfaf-53d2f437fc1d	\N	\N	\N	\N	2026-06-10 03:53:19.663481+00
2a9b4bfd-b7ff-49a4-a47f-0c5e1a8eba15	262a2469-eec7-470c-bd92-47874baebdea	UPDATE_STATUS	lich_hen	2ff03ddb-2438-4fcf-bfaf-53d2f437fc1d	\N	\N	\N	\N	2026-06-10 03:54:35.15818+00
5ce864ce-aa28-42f8-905f-17f9b806c7f9	5e289847-fa1e-402e-8f46-863cf0d3c395	CREATE	lich_hen	38b52264-f767-4338-b244-6f95edc1c1e0	\N	\N	\N	\N	2026-06-10 04:08:50.038518+00
8fcc72a5-8a8a-4120-bb52-d79094fcc7d3	\N	SYSTEM_CREATE	thong_bao	1d0d9bb7-014f-44d1-b2fe-4f43eebfb0fb	\N	\N	\N	\N	2026-06-10 04:08:50.48848+00
ae82aac0-a83b-410b-8aca-a0f390d0baf5	262a2469-eec7-470c-bd92-47874baebdea	UPDATE_STATUS	lich_hen	38b52264-f767-4338-b244-6f95edc1c1e0	\N	\N	\N	\N	2026-06-10 04:09:42.144582+00
b12aa6ce-4bb5-49bf-82a4-e545b079ed3b	262a2469-eec7-470c-bd92-47874baebdea	CANCEL	lich_hen	38b52264-f767-4338-b244-6f95edc1c1e0	\N	\N	\N	\N	2026-06-10 04:11:22.02552+00
dfa09625-1291-42cd-a593-0d243f32a976	5e289847-fa1e-402e-8f46-863cf0d3c395	CREATE	lich_hen	e31a38f2-ab57-486d-9703-303104e83801	\N	\N	\N	\N	2026-06-10 04:14:06.744654+00
4b927dad-4b28-4590-aa95-562c2e0db716	\N	SYSTEM_CREATE	thong_bao	c7ed0584-da12-4b85-ab1a-eaf588ff8e32	\N	\N	\N	\N	2026-06-10 04:14:07.528533+00
e3e070a2-5821-49a7-a1da-20378fc14f0d	262a2469-eec7-470c-bd92-47874baebdea	UPDATE	lich_hen	e31a38f2-ab57-486d-9703-303104e83801	\N	\N	\N	\N	2026-06-10 04:14:47.264507+00
a79d630c-6d7a-4852-950d-2a721e30112f	262a2469-eec7-470c-bd92-47874baebdea	UPDATE_STATUS	lich_hen	e31a38f2-ab57-486d-9703-303104e83801	\N	\N	\N	\N	2026-06-10 04:15:16.438603+00
af60ef1c-6830-463e-a338-a8c3efbb6746	262a2469-eec7-470c-bd92-47874baebdea	UPDATE_STATUS	lich_hen	e31a38f2-ab57-486d-9703-303104e83801	\N	\N	\N	\N	2026-06-10 04:15:52.410758+00
20993503-ed2d-4cb1-a332-797fb11b6d3e	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-10 20:49:53.466264+00
e58c97ce-ebc0-4ec8-a3fc-712f1ef1b011	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 21:00:54.408153+00
2ea0fe35-ecc8-4e50-ae3d-589e916c716f	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 21:00:59.669088+00
5fe3fd2e-9b20-4475-ab42-6e075b96c234	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 21:01:49.057298+00
bab74524-e433-452f-a689-9263b6f1b27d	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 21:02:04.23031+00
a609d504-d707-4ef6-8f75-6ef69b275f52	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 21:02:42.116324+00
119a72fa-c081-4cac-96d0-e5a7d0e999a3	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 21:02:50.52785+00
c02905aa-b909-4ca2-94ac-8108428527d6	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 21:02:56.693363+00
45068bba-44f9-4645-aa89-b55ae3d1b936	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 21:03:19.460934+00
4ca7e281-5c61-4544-9126-42d7660d65e3	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 21:03:25.305186+00
26395fd8-4e87-45f8-b16c-3501ab0b7605	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 21:03:30.699035+00
fe532a2c-61f5-441a-a728-20f6da1b8e85	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 21:10:16.679256+00
a23d5e3f-c4e8-42a9-9048-69c67f53a5f7	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 21:10:32.362285+00
bd668548-d63d-4ef4-950c-52d668b496d9	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-10 21:15:43.547094+00
7bd3aabf-7609-48bc-8e4d-2b7b8f1cfd6f	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-12 17:30:57.289175+00
de2239d5-6375-40a2-abf0-5626f4652b19	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-12 17:31:42.682487+00
91f556de-78a9-4b7f-9638-99faf3035af6	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-12 17:32:01.50207+00
121057cb-860f-43e5-ad13-7751e5a2f60f	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-12 17:46:06.006702+00
c6c9f411-7506-4d0d-a03d-30bfb56bd841	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-13 06:52:59.777055+00
b36874dd-f8a6-4c25-bb3a-a4c65eb4cdc1	c4e8b2dc-daf4-47aa-a573-8383561351af	REGISTER	nguoi_dung	c4e8b2dc-daf4-47aa-a573-8383561351af	\N	\N	\N	\N	2026-06-13 06:57:22.376302+00
58cb9605-a352-41fd-a37d-48df372ae40d	c4e8b2dc-daf4-47aa-a573-8383561351af	LOGIN	nguoi_dung	c4e8b2dc-daf4-47aa-a573-8383561351af	\N	\N	\N	\N	2026-06-13 06:57:29.308291+00
2e4d7ca0-fee2-4bac-a314-8ccc3a713d0d	c4e8b2dc-daf4-47aa-a573-8383561351af	CREATE	lich_hen	eb3eebc1-0980-4218-a775-d4c4a93887e6	\N	\N	\N	\N	2026-06-13 06:58:16.872362+00
516388d9-2d8b-42a0-b0c8-5c9ab5a3b78e	\N	SYSTEM_CREATE	thong_bao	bf764509-38ee-4967-bea6-d4805a516b32	\N	\N	\N	\N	2026-06-13 06:58:17.316462+00
de9591f6-5406-43b8-93ee-ebf68474b0f3	c4e8b2dc-daf4-47aa-a573-8383561351af	LOGIN	nguoi_dung	c4e8b2dc-daf4-47aa-a573-8383561351af	\N	\N	\N	\N	2026-06-13 09:16:22.662463+00
75fed698-43bb-4fc7-8228-2814fd999b24	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 09:16:54.536884+00
3169e474-c75b-4d6d-a844-f59f7c6e4e46	c4e8b2dc-daf4-47aa-a573-8383561351af	LOGIN	nguoi_dung	c4e8b2dc-daf4-47aa-a573-8383561351af	\N	\N	\N	\N	2026-06-13 09:36:30.268804+00
3a42c92f-bd9a-4a9e-846a-facdd55300e5	c4e8b2dc-daf4-47aa-a573-8383561351af	LOGIN	nguoi_dung	c4e8b2dc-daf4-47aa-a573-8383561351af	\N	\N	\N	\N	2026-06-13 09:36:45.775921+00
f299cc20-1157-4620-97f2-8fe77c8c00fc	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 09:36:53.947669+00
908492a0-6354-4eb4-88e2-944c1f056fa5	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 13:41:03.272828+00
80bb084a-cb45-4f75-9bf2-559678a0cb05	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-13 14:34:39.095298+00
519daa65-10c4-4346-84c2-4f1aecec8209	c4e8b2dc-daf4-47aa-a573-8383561351af	LOGIN	nguoi_dung	c4e8b2dc-daf4-47aa-a573-8383561351af	\N	\N	\N	\N	2026-06-13 14:35:03.977805+00
d95b577e-b316-47ab-ac78-1bf892318626	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-13 14:42:56.929588+00
ec711457-6f63-4fc8-bdd0-76204aaf1c12	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 15:20:07.157495+00
17d01ab6-1655-4aaf-ac93-b95472e31d53	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 15:26:58.137031+00
201f8255-6dc0-4e00-a31a-dc0a04d9e8f7	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 15:28:26.421209+00
e239c6cc-1ea4-4a84-a93f-0734747e7f5f	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 15:28:35.996157+00
e193d7a9-7330-4fa0-83ca-b32f85befa90	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	CREATE	cau_hinh_gia	7e80ff5e-6f67-489d-8716-e83a4739d5a9	\N	\N	\N	\N	2026-06-13 15:57:20.109472+00
3f3ca3ec-5ab5-4e22-88b0-3420013e0e20	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 16:16:46.598424+00
99c9f8c2-019c-45f5-9239-d4876625ef02	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 16:17:16.570403+00
d70a36bc-d78b-4a53-97ba-26518f0569ef	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 16:17:46.297258+00
4daf8074-739b-488b-8f92-f1befad476b4	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 16:18:17.608165+00
a152044c-2f34-4578-9183-9092aa2d4a5f	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 16:18:18.291131+00
f0cf66e0-e261-4e93-8531-c4b5bd85057f	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 16:18:48.576892+00
d810ff0f-a655-44bb-801b-66f37a2c6272	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 16:19:58.963282+00
b7b72f80-fa7b-411d-936e-d5d46fb5a721	4e0b7b88-3763-4732-a1cf-c2d0707b0511	LOGIN	nguoi_dung	4e0b7b88-3763-4732-a1cf-c2d0707b0511	\N	\N	\N	\N	2026-06-13 16:25:38.939884+00
eb297a52-96a2-40fd-a231-6ae2a78ef611	4e0b7b88-3763-4732-a1cf-c2d0707b0511	DELETE	nguoi_dung	814e5dd5-9805-4566-814a-0b97df3978d0	\N	\N	\N	\N	2026-06-13 16:26:37.253743+00
240147a8-72f2-4611-ba16-69fb093b2700	4e0b7b88-3763-4732-a1cf-c2d0707b0511	DELETE	nguoi_dung	dc440559-dd1c-462c-832f-a5bb648d9199	\N	\N	\N	\N	2026-06-13 16:27:04.471446+00
c382484f-bcad-44bd-8631-e65056f95f3c	c4e8b2dc-daf4-47aa-a573-8383561351af	LOGIN	nguoi_dung	c4e8b2dc-daf4-47aa-a573-8383561351af	\N	\N	\N	\N	2026-06-13 16:30:02.090177+00
f36223d8-1b0b-491b-b42d-7380b9a72fbf	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	LOGIN	nguoi_dung	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	\N	\N	\N	\N	2026-06-13 16:30:45.181143+00
c6eb1ca9-9322-4301-ab9a-94c65e40cd25	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	CREATE	lich_hen	859a13b8-6b0a-40f6-8336-682df4afd69b	\N	\N	\N	\N	2026-06-13 16:31:08.792908+00
c2844dee-7ff0-4477-b41e-1c772833aee4	\N	SYSTEM_CREATE	thong_bao	6be1095f-d42e-4253-8c86-57cf47fb5cfe	\N	\N	\N	\N	2026-06-13 16:31:09.192923+00
c19d2859-8cdd-4107-aa78-981356f9396b	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 16:35:00.990457+00
395de059-fa88-4cc9-9fdf-c78396477aee	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 16:35:09.427855+00
c37bc400-eabd-483a-bc77-b0e46ff6003d	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 16:35:23.192908+00
9d9ac4b9-5f73-4ea3-b18d-355118131f91	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 16:37:31.637181+00
85a9ef8d-ad72-43a5-906b-2abbb07be5c8	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 16:44:01.191451+00
0a39daf1-7893-4835-bd8a-02b0d590adf2	262a2469-eec7-470c-bd92-47874baebdea	LOGIN	nguoi_dung	262a2469-eec7-470c-bd92-47874baebdea	\N	\N	\N	\N	2026-06-13 16:44:50.834985+00
195aadd8-8152-46af-bddc-d2c021a0802c	00b4c56f-45fa-49a2-874b-601bc77dcb65	LOGIN	nguoi_dung	00b4c56f-45fa-49a2-874b-601bc77dcb65	\N	\N	\N	\N	2026-06-13 22:07:37.299033+00
6c87afca-392b-46b1-936a-f63dc6a64870	\N	CREATE	lich_hen	09e772ad-82e8-42af-b1e6-787e59cd4980	\N	\N	\N	\N	2026-06-13 23:33:23.64553+00
84b6b889-763b-4307-be57-4602684b140f	\N	SYSTEM_CREATE	thong_bao	c4fdfcaf-4ed9-4338-b86f-6e07942bd81a	\N	\N	\N	\N	2026-06-13 23:33:23.989873+00
d6f9ec75-5a33-45bb-bea6-8db38d49857f	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	LOGIN	nguoi_dung	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	\N	\N	\N	\N	2026-06-13 23:42:21.680233+00
efe7cf31-8dde-47aa-9dc6-d432a115df1b	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	UPDATE_STATUS	lich_hen	09e772ad-82e8-42af-b1e6-787e59cd4980	\N	\N	\N	\N	2026-06-13 23:44:22.939123+00
effc9a3f-5db2-4183-8e06-856e643961ed	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	UPDATE_STATUS	lich_hen	09e772ad-82e8-42af-b1e6-787e59cd4980	\N	\N	\N	\N	2026-06-13 23:45:00.996102+00
f7ae385e-1e69-453c-8d71-0bbea617275c	5e289847-fa1e-402e-8f46-863cf0d3c395	LOGIN	nguoi_dung	5e289847-fa1e-402e-8f46-863cf0d3c395	\N	\N	\N	\N	2026-06-13 23:46:31.946536+00
81905902-06af-49ac-9723-8f5f04da0916	5e289847-fa1e-402e-8f46-863cf0d3c395	LOGIN	nguoi_dung	5e289847-fa1e-402e-8f46-863cf0d3c395	\N	\N	\N	\N	2026-06-13 23:46:45.97296+00
1225b6e0-6c94-42e2-9430-70f46772b07c	5e289847-fa1e-402e-8f46-863cf0d3c395	LOGIN	nguoi_dung	5e289847-fa1e-402e-8f46-863cf0d3c395	\N	\N	\N	\N	2026-06-13 23:47:07.476789+00
\.

--
-- Data for Name: khach_thue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."khach_thue" ("id", "nguoi_dung_id", "chu_tro_id", "ho_ten", "so_dien_thoai", "email", "so_cccd", "ngay_sinh", "gioi_tinh", "dia_chi", "que_quan", "nghe_nghiep", "ghi_chu", "dang_hoat_dong", "tao_luc", "cap_nhat_luc", "xoa_luc") FROM stdin;
fba2a7bd-082f-47f7-b0cc-3c53e79352c4	\N	00b4c56f-45fa-49a2-874b-601bc77dcb65	nguyễn văn hà	0396822875	hoangphucminh231205@gmail.com	066206004084	2000-01-02	nam	\N	Hà Nội	Sinh Viên	\N	t	2026-05-23 16:55:13.456136+00	2026-05-23 16:55:13.456136+00	\N
cdbe66ce-3bf0-4023-b2c8-38ba477730f1	\N	00b4c56f-45fa-49a2-874b-601bc77dcb65	lê văn minh	0357165019	gtruc2146@gmail.com	066206004083	2000-12-23	nam	\N	Bắc Giang	Sinh Viên	\N	t	2026-05-23 17:17:43.363368+00	2026-05-23 17:18:00.723047+00	\N
b377a491-32fc-4f59-a52c-8d329b3c00f0	\N	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	Trần Triệu Vỹ	0374729356	vyttt22052006@gmail.com	066206005123	2026-05-14	nam	\N	Đak Lak	CNTT	\N	t	2026-05-25 02:11:28.256857+00	2026-05-25 02:12:20.594341+00	\N
625c3321-ab04-4330-9e34-2a4458635624	\N	00b4c56f-45fa-49a2-874b-601bc77dcb65	đỗ chí công	0987654321	1@gmail.com	099999999986	2006-01-13	nam	\N	Hà Nội	Sinh Viên	\N	t	2026-05-27 02:13:19.910666+00	2026-05-27 02:13:19.910666+00	\N
b3c9ada2-70d5-496d-a103-4cf3d7ecc21f	\N	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	Trần Văn Khách	0973021078	khach01@gmail.com	034820882846	1999-08-09	nam	\N	Hoà Bình	Tự do	\N	t	2026-05-30 06:49:18.927204+00	2026-05-30 07:14:18.960886+00	\N
05bdeac0-c77e-437a-bcb4-ebf97d5c8157	\N	91e602be-25b8-4fd4-9769-b307cd9af888	QA Tenant Updated 103731	0876543210	tenant103731@easyhouse.local	012345678900	1999-01-01	Nam	HCM	HCM	QA	updated	t	2026-05-31 03:37:36.629037+00	2026-05-31 03:37:11.142205+00	2026-05-31 03:37:42.754178+00
76bcede3-1bda-494a-8193-974874f25f8f	7be2a683-5537-41c2-b834-ea534816a945	627d6150-9fe6-41e4-98fd-e966fb11d5f2	Khách thuê Trần Văn B	0987654322	tenant@easyhouse.local	\N	\N	\N	\N	\N	\N	\N	t	2026-06-01 08:00:37.219337+00	2026-06-01 08:00:37.245567+00	\N
a6cab9bf-080a-4cca-b2a1-02b5df4aabfc	\N	00b4c56f-45fa-49a2-874b-601bc77dcb65	Phùng Văn Thọ	0989909909	\N	066206004086	\N	\N	\N	\N	\N	\N	t	2026-06-01 19:24:11.748322+00	2026-06-01 19:24:11.748322+00	\N
28073f55-d86b-4ff1-83d3-58b44808055f	\N	627d6150-9fe6-41e4-98fd-e966fb11d5f2	Trần Triệu Vỹadsad	03747293232	vyyy321321@gmail.com	066206005323	2000-09-03	nam	\N	Đak Lak	CNTT	\N	t	2026-06-03 13:34:34.359985+00	2026-06-03 13:34:34.359985+00	\N
57ff6175-493c-49ab-98c6-7663c1a8c062	\N	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	Nguyễn Văn Khách	0873021078	khach02@gmail.com	034820568943	2006-06-06	nam	\N	Hoà Bình	Tự do	\N	t	2026-06-13 15:51:31.906763+00	2026-06-13 15:51:31.906763+00	\N
171d20ad-de40-40cd-850a-e639b98ebd5a	5e289847-fa1e-402e-8f46-863cf0d3c395	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	Trần Vỹ Khách Thuê	0374729354	vyttt22052006@gmail.com	\N	\N	\N	\N	\N	\N	\N	t	2026-06-13 23:56:25.1862+00	2026-06-13 23:56:25.1862+00	\N
\.

--
-- Data for Name: nha_tro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."nha_tro" ("id", "chu_tro_id", "ten", "dia_chi", "so_nha", "duong", "phuong", "quan", "thanh_pho", "mo_ta", "tien_nghi_chung", "noi_quy", "trang_thai", "tao_luc", "cap_nhat_luc", "xoa_luc") FROM stdin;
b0eb16f8-1be0-4515-8beb-0e09768d833a	00b4c56f-45fa-49a2-874b-601bc77dcb65	Nhà Trọ Hải Dương	11 Nguyễn Văn Linh	11	Nguyễn Văn Linh	Phường Cẩm Thượng	Thành phố Hải Dương	Tỉnh Hải Dương	new	camera,giuXe,sanPhoi,khuBepChung	\N	ACTIVE	2026-05-23 16:30:20.896971+00	2026-05-23 16:30:20.896971+00	\N
4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	00b4c56f-45fa-49a2-874b-601bc77dcb65	Nhà Trọ Trần Hưng Đạo	139 Trần hưng đạo	139	Trần hưng đạo	Phường Thanh Nhàn	Quận Hai Bà Trưng	Thành phố Hà Nội	nhà mới xây	wifi,baoVe,giuXe,camera,sanPhoi,khuBepChung,nhaVeSinhChung,thangMay	\N	ACTIVE	2026-05-23 16:31:10.522132+00	2026-05-23 16:31:37.457694+00	\N
3535d19a-377c-4195-9dbd-74dc82611caf	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	Lamark	141 số 141	141	số 141	Phường Mỹ Đình 1	Quận Nam Từ Liêm	Thành phố Hà Nội		wifi,camera,giuXe,sanPhoi,khuBepChung,baoVe,thangMay,nhaVeSinhChung	\N	ACTIVE	2026-05-25 02:09:07.977043+00	2026-05-25 02:09:07.977043+00	\N
3c21cb2b-21aa-428d-9991-0c320a951eef	00b4c56f-45fa-49a2-874b-601bc77dcb65	Nhà Trọ Chương Long	136 Cầu Diễn	136	Cầu Diễn	Phường Minh Khai	Quận Bắc Từ Liêm	Thành phố Hà Nội	Chung Cư Mini	camera,wifi,baoVe,thangMay,nhaVeSinhChung,giuXe,sanPhoi,khuBepChung	\N	ACTIVE	2026-05-27 01:56:39.696478+00	2026-05-27 01:56:39.696478+00	\N
0189a7a5-857c-4cd9-b000-3ea75f7120c8	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	Dãy Trọ Mỹ Đình	25/52/25/43 Đường Phú Mỹ	25/52/25/43	Đường Phú Mỹ	Phường Mỹ Đình 2	Quận Nam Từ Liêm	Thành phố Hà Nội		wifi,camera,giuXe,sanPhoi,baoVe	\N	ACTIVE	2026-05-30 04:21:16.37617+00	2026-05-30 04:21:16.37617+00	\N
06e0c87c-7ddf-405e-88cb-007c509d7d8c	91e602be-25b8-4fd4-9769-b307cd9af888	QA Tower Updated 103731	2 QA	2	QA	P2	Q2	HCM	QA updated	wifi,camera	\N	ACTIVE	2026-05-31 03:37:31.846397+00	2026-05-31 03:37:12.462167+00	2026-05-31 03:37:44.073513+00
b50b2531-991d-4afa-9383-3ee14f362eaf	91e602be-25b8-4fd4-9769-b307cd9af888	QA Cancel Tower 111119	1 QA	1	QA	P1	Q1	HCM	QA cancel incident		\N	ACTIVE	2026-05-31 04:11:20.048661+00	2026-05-31 04:11:20.048661+00	\N
f63332e3-9477-4735-b07e-ee726bcf4c24	00b4c56f-45fa-49a2-874b-601bc77dcb65	Nhà Trọ Long Thành	19 Nguyễn trãi	19	Nguyễn trãi	Phường Cát Linh	Quận Đống Đa	Thành phố Hà Nội	nhà trọ mới xây	giuXe,camera,sanPhoi,khuBepChung	\N	ACTIVE	2026-06-01 02:36:24.058586+00	2026-06-01 02:36:24.058586+00	\N
c5ef707f-8f63-400d-b926-5f9b7f4aba8c	00b4c56f-45fa-49a2-874b-601bc77dcb65	HH1A	99 Linh Đàm	99	Linh Đàm	Phường Thanh Trì	Quận Hoàng Mai	Thành phố Hà Nội	Chung Cư Cao Cấp	camera,giuXe,sanPhoi,nhaVeSinhChung,thangMay,baoVe,wifi	\N	ACTIVE	2026-06-01 09:04:28.100267+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00
6fd64279-de4f-4265-bbbc-fffa6b37d489	00b4c56f-45fa-49a2-874b-601bc77dcb65	HH1A	11 Linh Đàm	11	Linh Đàm	Phường Thanh Trì	Quận Hoàng Mai	Thành phố Hà Nội	chung cư mới		\N	ACTIVE	2026-06-01 18:19:09.622914+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00
30cf5842-0171-48b4-ac8d-78081e0c7777	00b4c56f-45fa-49a2-874b-601bc77dcb65	HH1A	99 Linh Đàm	99	Linh Đàm	Phường Thanh Trì	Quận Hoàng Mai	Thành phố Hà Nội	chung cư mới	camera,giuXe,sanPhoi,nhaVeSinhChung,baoVe,wifi,thangMay	\N	ACTIVE	2026-06-01 18:23:24.126263+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00
376343b4-f368-407e-bacb-5a3462721473	00b4c56f-45fa-49a2-874b-601bc77dcb65	HH1A	11 Linh Đàm	11	Linh Đàm	Phường Thanh Trì	Quận Hoàng Mai	Thành phố Hà Nội	chung cư mới		\N	ACTIVE	2026-06-01 18:19:10.356042+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00
819d7425-1224-4850-8e90-a1dc4b0155e4	00b4c56f-45fa-49a2-874b-601bc77dcb65	HH1A	139 Linh Đàm	139	Linh Đàm	Phường Thanh Trì	Quận Hoàng Mai	Thành phố Hà Nội	chung cư	camera,giuXe,sanPhoi,nhaVeSinhChung,thangMay,baoVe,wifi	\N	ACTIVE	2026-06-01 18:41:16.296445+00	2026-06-01 18:41:16.296445+00	\N
6f0fb149-c580-4ec5-b097-4d7e120653dd	262a2469-eec7-470c-bd92-47874baebdea	Lamark123	123123 số 1413213	123123	số 1413213	Phường Phúc Xá	Quận Ba Đình	Thành phố Hà Nội	dasdsa	baoVe,wifi	\N	ACTIVE	2026-06-02 14:09:15.712888+00	2026-06-02 14:09:15.712888+00	\N
18f65b13-c046-412a-b1cd-0ebb3b01e00b	627d6150-9fe6-41e4-98fd-e966fb11d5f2	Lamark123323	14123 số 5454	14123	số 5454	Phường Phúc Xá	Quận Ba Đình	Thành phố Hà Nội	addad	thangMay,baoVe	\N	ACTIVE	2026-06-03 13:32:45.923042+00	2026-06-03 13:32:45.923042+00	\N
\.

--
-- Data for Name: tang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."tang" ("id", "nha_tro_id", "so_tang", "ten_tang", "thu_tu_hien_thi", "so_phong_du_kien", "trang_thai", "tao_luc", "cap_nhat_luc", "xoa_luc") FROM stdin;
f959b5a2-d5a1-4b9b-a635-dd333b5e4b8c	30cf5842-0171-48b4-ac8d-78081e0c7777	6	Tang 6	6	5	ACTIVE	2026-06-01 18:23:25.597482+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:37:59.453925+00
a4eafd70-f390-47e2-a4d8-2065f951666b	6f0fb149-c580-4ec5-b097-4d7e120653dd	6	Tang 6	6	10	ACTIVE	2026-06-02 14:09:17.675524+00	2026-06-10 02:03:13.055662+00	\N
158b692a-46d0-4463-814c-9d580ab7e22e	3c21cb2b-21aa-428d-9991-0c320a951eef	1	Tang 1	1	3	ACTIVE	2026-06-01 06:58:55.722708+00	2026-06-10 02:03:13.055662+00	\N
6530c411-f123-4086-92f7-c5c9fca85d16	376343b4-f368-407e-bacb-5a3462721473	4	Tang 4	4	5	ACTIVE	2026-06-01 18:19:11.807229+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:38:08.875537+00
cb953fbe-219c-46d9-bdb1-4d1e76ddb7b0	6fd64279-de4f-4265-bbbc-fffa6b37d489	2	Tang 2	2	5	ACTIVE	2026-06-01 18:19:11.072071+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:22:27.987878+00
8d2ed800-1e17-490f-9b30-edb8890efe92	18f65b13-c046-412a-b1cd-0ebb3b01e00b	5	Tang 5	5	10	ACTIVE	2026-06-03 13:32:45.726482+00	2026-06-10 02:03:13.055662+00	\N
7821f926-c578-4cf8-b5b5-d5abf165f147	30cf5842-0171-48b4-ac8d-78081e0c7777	3	Tang 3	3	5	ACTIVE	2026-06-01 18:23:25.597482+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:37:59.453925+00
000974e9-cccb-486a-8576-ee01e4dc204d	819d7425-1224-4850-8e90-a1dc4b0155e4	2	Tang 2	2	5	ACTIVE	2026-06-01 18:41:17.81944+00	2026-06-10 02:03:13.055662+00	\N
01837be0-052e-4a5f-a27b-3b0bf3aa42d7	30cf5842-0171-48b4-ac8d-78081e0c7777	5	Tang 5	5	5	ACTIVE	2026-06-01 18:23:25.597482+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:37:59.453925+00
33c0052e-4857-43c0-b8ca-9b28600ad73f	819d7425-1224-4850-8e90-a1dc4b0155e4	1	Tang 1	1	5	ACTIVE	2026-06-01 18:41:17.81944+00	2026-06-10 02:03:13.055662+00	\N
ab093e3e-9b98-4339-99e2-185b68c63d3f	b0eb16f8-1be0-4515-8beb-0e09768d833a	1	Tang 1	1	1	ACTIVE	2026-06-01 06:58:55.722708+00	2026-06-10 02:03:13.055662+00	\N
87908f5d-a202-498d-a8cb-c0fadf7d1cfb	6fd64279-de4f-4265-bbbc-fffa6b37d489	4	Tang 4	4	5	ACTIVE	2026-06-01 18:19:11.072071+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:22:27.987878+00
fa1d8ef0-f224-40d2-86c9-4e128ec0c571	6f0fb149-c580-4ec5-b097-4d7e120653dd	1	Tang 1	1	10	ACTIVE	2026-06-02 14:09:17.675524+00	2026-06-10 02:03:13.055662+00	\N
99f08e5d-8c2b-40f1-83c7-3b92bc78c0e8	6f0fb149-c580-4ec5-b097-4d7e120653dd	7	Tang 7	7	10	ACTIVE	2026-06-02 14:09:17.675524+00	2026-06-10 02:03:13.055662+00	\N
b1168d7d-c15c-4be8-9cdf-a5eb78f8efdb	18f65b13-c046-412a-b1cd-0ebb3b01e00b	6	Tang 6	6	10	ACTIVE	2026-06-03 13:32:45.726482+00	2026-06-10 02:03:13.055662+00	\N
c2b782b1-db00-4656-99d8-5b1133102f6a	30cf5842-0171-48b4-ac8d-78081e0c7777	4	Tang 4	4	5	ACTIVE	2026-06-01 18:23:25.597482+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:37:59.453925+00
9be73427-d899-450b-b541-66e2805dff42	f63332e3-9477-4735-b07e-ee726bcf4c24	1	Tang 1	1	2	ACTIVE	2026-06-01 06:58:55.722708+00	2026-06-10 02:03:13.055662+00	\N
49a90761-b85f-453d-bb86-fecbe3346d4c	376343b4-f368-407e-bacb-5a3462721473	1	Tang 1	1	5	ACTIVE	2026-06-01 18:19:11.807229+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:38:08.875537+00
a59e7344-fdca-49e6-a564-11dc83ee3b75	819d7425-1224-4850-8e90-a1dc4b0155e4	3	Tang 3	3	5	ACTIVE	2026-06-01 18:41:17.81944+00	2026-06-10 02:03:13.055662+00	\N
58924ea2-d84b-4351-bb59-b1d840601dc6	376343b4-f368-407e-bacb-5a3462721473	2	Tang 2	2	5	ACTIVE	2026-06-01 18:19:11.807229+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:38:08.875537+00
2f6644f5-1bc9-44c4-9a9e-e8f8b5da68a7	376343b4-f368-407e-bacb-5a3462721473	6	Tang 6	6	5	ACTIVE	2026-06-01 18:19:11.807229+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:38:08.875537+00
baefa1a2-8c5f-4898-94c7-685e6f57e377	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	1	Tang 1	1	1	ACTIVE	2026-06-01 06:58:55.722708+00	2026-06-10 02:03:13.055662+00	\N
e0892859-059c-44db-93f0-5e0ce035b5fa	6f0fb149-c580-4ec5-b097-4d7e120653dd	4	Tang 4	4	10	ACTIVE	2026-06-02 14:09:17.675524+00	2026-06-10 02:03:13.055662+00	\N
a21f1209-0d65-4969-8ca7-f992a3d4f67b	b50b2531-991d-4afa-9383-3ee14f362eaf	1	Tang 1	1	1	ACTIVE	2026-06-01 06:58:55.722708+00	2026-06-10 02:03:13.055662+00	\N
7225842e-e31b-4a00-866e-66abc09e632c	819d7425-1224-4850-8e90-a1dc4b0155e4	5	Tang 5	5	5	ACTIVE	2026-06-01 18:41:17.81944+00	2026-06-10 02:03:13.055662+00	\N
97e00039-c25f-4f25-b702-10a77fc17a57	06e0c87c-7ddf-405e-88cb-007c509d7d8c	2	Tang 2	2	1	ACTIVE	2026-06-01 06:58:55.722708+00	2026-06-10 02:03:13.055662+00	\N
e25b1f2c-ab77-4ec7-94ed-93fa487cd309	6f0fb149-c580-4ec5-b097-4d7e120653dd	5	Tang 5	5	10	ACTIVE	2026-06-02 14:09:17.675524+00	2026-06-10 02:03:13.055662+00	\N
06d97fbc-490e-4803-a2be-897b5a3d0bcd	3535d19a-377c-4195-9dbd-74dc82611caf	1	Tang 1	1	1	ACTIVE	2026-06-01 06:58:55.722708+00	2026-06-10 02:03:13.055662+00	\N
7fa8ad3d-22c2-44fa-aa64-71382a7a88c9	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	2	Tang 2	2	1	ACTIVE	2026-06-01 06:58:55.722708+00	2026-06-10 02:03:13.055662+00	\N
7232b4a9-8040-449a-992d-6f6dd36113c8	6fd64279-de4f-4265-bbbc-fffa6b37d489	5	Tang 5	5	5	ACTIVE	2026-06-01 18:19:11.072071+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:22:27.987878+00
d06241e9-6a1b-4c73-bb21-74f6be5bbf5b	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	3	Tang 3	3	5	ACTIVE	2026-06-01 09:04:28.597242+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:13:38.895795+00
502d49fb-beaa-479b-80fa-f4b855ff715a	18f65b13-c046-412a-b1cd-0ebb3b01e00b	1	Tang 1	1	10	ACTIVE	2026-06-03 13:32:45.726482+00	2026-06-10 02:03:13.055662+00	\N
a11fd03f-f7de-4bd6-bcff-21d08c5993aa	6fd64279-de4f-4265-bbbc-fffa6b37d489	1	Tang 1	1	5	ACTIVE	2026-06-01 18:19:11.072071+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:22:27.987878+00
4fecf774-3d43-498d-b85a-6a0594b699eb	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	4	Tang 4	4	5	ACTIVE	2026-06-01 09:04:28.597242+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:13:38.895795+00
d9a0b507-a1a7-4785-aa30-b555307031d6	6fd64279-de4f-4265-bbbc-fffa6b37d489	3	Tang 3	3	5	ACTIVE	2026-06-01 18:19:11.072071+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:22:27.987878+00
1efd80dd-ab39-49a6-9536-2c3ec53e3fd3	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	6	Tang 6	6	5	ACTIVE	2026-06-01 09:04:28.597242+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:13:38.895795+00
76297bbe-05ac-46e3-a572-fb0ff477ea76	819d7425-1224-4850-8e90-a1dc4b0155e4	4	Tang 4	4	5	ACTIVE	2026-06-01 18:41:17.81944+00	2026-06-10 02:03:13.055662+00	\N
cdbf00a2-12db-48ac-ad33-510cb99ed1c5	18f65b13-c046-412a-b1cd-0ebb3b01e00b	4	Tang 4	4	10	ACTIVE	2026-06-03 13:32:45.726482+00	2026-06-10 02:03:13.055662+00	\N
e00e60f1-c962-4a06-bcba-86873ca2ec15	6f0fb149-c580-4ec5-b097-4d7e120653dd	3	Tang 3	3	10	ACTIVE	2026-06-02 14:09:17.675524+00	2026-06-10 02:03:13.055662+00	\N
a1980dd5-b915-4699-9fc6-d59bc02c6877	18f65b13-c046-412a-b1cd-0ebb3b01e00b	2	Tang 2	2	10	ACTIVE	2026-06-03 13:32:45.726482+00	2026-06-10 02:03:13.055662+00	\N
840caed8-9f38-4a0f-9e77-936b4a741e0d	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	2	Tang 2	2	5	ACTIVE	2026-06-01 09:04:28.597242+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:13:38.895795+00
805ce818-c842-491b-83c4-69ce94e8e958	6f0fb149-c580-4ec5-b097-4d7e120653dd	2	Tang 2	2	10	ACTIVE	2026-06-02 14:09:17.675524+00	2026-06-10 02:03:13.055662+00	\N
909c9f30-5e8a-42af-a20a-389388ea61aa	819d7425-1224-4850-8e90-a1dc4b0155e4	6	Tang 6	6	5	ACTIVE	2026-06-01 18:41:17.81944+00	2026-06-10 02:03:13.055662+00	\N
0cd84afc-6e4c-47f7-8f6e-57be5361c794	376343b4-f368-407e-bacb-5a3462721473	5	Tang 5	5	5	ACTIVE	2026-06-01 18:19:11.807229+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:38:08.875537+00
9274eb18-b57c-413f-8b01-0e62597e3508	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	1	Tang 1	1	5	ACTIVE	2026-06-01 09:04:28.597242+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:13:38.895795+00
b4895944-6cf3-48d0-b21d-41c23dbe4570	0189a7a5-857c-4cd9-b000-3ea75f7120c8	1	Tang 1	1	2	ACTIVE	2026-06-01 06:58:55.722708+00	2026-06-10 02:03:13.055662+00	\N
c050e8b7-9635-48e0-ace3-15b6a8d314c8	30cf5842-0171-48b4-ac8d-78081e0c7777	1	Tang 1	1	5	ACTIVE	2026-06-01 18:23:25.597482+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:37:59.453925+00
88bede5b-2562-4357-8b37-5b54c169299c	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	5	Tang 5	5	5	ACTIVE	2026-06-01 09:04:28.597242+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:13:38.895795+00
5d8e8a7e-81f3-4859-b523-a1603da39ea4	30cf5842-0171-48b4-ac8d-78081e0c7777	2	Tang 2	2	5	ACTIVE	2026-06-01 18:23:25.597482+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:37:59.453925+00
57528ed3-18ec-4da9-b58c-71b3e13ca6cc	18f65b13-c046-412a-b1cd-0ebb3b01e00b	3	Tang 3	3	10	ACTIVE	2026-06-03 13:32:45.726482+00	2026-06-10 02:03:13.055662+00	\N
1c9c5978-23d1-4d3e-b5bc-96e96d4fe273	376343b4-f368-407e-bacb-5a3462721473	3	Tang 3	3	5	ACTIVE	2026-06-01 18:19:11.807229+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:38:08.875537+00
6e9a6b77-e407-47d3-88c7-5b6b46be7e75	6fd64279-de4f-4265-bbbc-fffa6b37d489	6	Tang 6	6	5	ACTIVE	2026-06-01 18:19:11.072071+00	2026-06-10 02:03:13.055662+00	2026-06-01 18:22:27.987878+00
\.

--
-- Data for Name: phong; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."phong" ("id", "nha_tro_id", "ten", "khu_vuc", "tang", "dien_tich", "so_nguoi_toi_da", "trang_thai", "gia_hien_tai", "tien_coc_mac_dinh", "mo_ta", "tao_luc", "cap_nhat_luc", "xoa_luc", "tang_id", "version") FROM stdin;
6c081d7b-7504-4500-bd56-4019bea9350c	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 101	\N	1	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	a11fd03f-f7de-4bd6-bcff-21d08c5993aa	0
6da2b6de-ec29-478b-9022-70f6a6342c0e	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 102	\N	1	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	a11fd03f-f7de-4bd6-bcff-21d08c5993aa	0
15d3243b-8647-47c4-965d-21a24ae4050d	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 103	\N	1	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	a11fd03f-f7de-4bd6-bcff-21d08c5993aa	0
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 104	\N	1	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	a11fd03f-f7de-4bd6-bcff-21d08c5993aa	0
113c2587-c00f-4c5c-b9c4-0d3728a632b6	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 105	\N	1	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	a11fd03f-f7de-4bd6-bcff-21d08c5993aa	0
f20d54ad-694a-4639-b44e-b9312ec165df	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 201	\N	2	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	cb953fbe-219c-46d9-bdb1-4d1e76ddb7b0	0
9a43216a-4010-4a2a-a4fa-bac563cc738e	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 202	\N	2	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	cb953fbe-219c-46d9-bdb1-4d1e76ddb7b0	0
63348357-a443-463a-9e45-9c8b5628aaa5	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 203	\N	2	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	cb953fbe-219c-46d9-bdb1-4d1e76ddb7b0	0
7c9220f4-948a-47d3-b948-d73fa6b6d322	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 204	\N	2	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	cb953fbe-219c-46d9-bdb1-4d1e76ddb7b0	0
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 205	\N	2	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	cb953fbe-219c-46d9-bdb1-4d1e76ddb7b0	0
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 301	\N	3	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	d9a0b507-a1a7-4785-aa30-b555307031d6	0
d828fe52-325e-4013-b3c9-99153744c002	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 302	\N	3	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	d9a0b507-a1a7-4785-aa30-b555307031d6	0
e4df1bcd-65af-4f1a-b55b-597dd38663e7	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 303	\N	3	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	d9a0b507-a1a7-4785-aa30-b555307031d6	0
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 304	\N	3	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	d9a0b507-a1a7-4785-aa30-b555307031d6	0
6a5c8c62-55d4-4e51-95c3-75212bfda869	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 305	\N	3	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	d9a0b507-a1a7-4785-aa30-b555307031d6	0
9f2ca61f-0b37-489a-946e-75d11caff2d5	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 401	\N	4	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	87908f5d-a202-498d-a8cb-c0fadf7d1cfb	0
a3f532e7-00a3-44b8-9503-e70f66f5236f	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 402	\N	4	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	87908f5d-a202-498d-a8cb-c0fadf7d1cfb	0
06190d62-ab23-4809-bac3-0b09780ee749	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 403	\N	4	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	87908f5d-a202-498d-a8cb-c0fadf7d1cfb	0
76833a35-2ea9-42cf-8810-5589be39495b	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 404	\N	4	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	87908f5d-a202-498d-a8cb-c0fadf7d1cfb	0
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 405	\N	4	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	87908f5d-a202-498d-a8cb-c0fadf7d1cfb	0
7be2c80e-7efc-4cf1-bd17-8984323a0e47	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 501	\N	5	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	7232b4a9-8040-449a-992d-6f6dd36113c8	0
5c64724d-0452-4519-83f5-2d9f2aa356bd	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 502	\N	5	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	7232b4a9-8040-449a-992d-6f6dd36113c8	0
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 503	\N	5	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	7232b4a9-8040-449a-992d-6f6dd36113c8	0
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 504	\N	5	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	7232b4a9-8040-449a-992d-6f6dd36113c8	0
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 505	\N	5	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	7232b4a9-8040-449a-992d-6f6dd36113c8	0
6dd938e2-dba5-4e98-8e1f-24dbb4cdb847	b0eb16f8-1be0-4515-8beb-0e09768d833a	PHÒNG 103		1	50.00	2	RENTED	2000000.00	1000000.00		2026-05-24 07:20:09.584951+00	2026-06-01 06:58:55.722708+00	2026-05-24 07:21:14.533089+00	ab093e3e-9b98-4339-99e2-185b68c63d3f	0
ac58f1da-64bb-4524-a104-42be15b02f3b	3535d19a-377c-4195-9dbd-74dc82611caf	P001		1	50.00	2	AVAILABLE	2000000.00	2000000.00		2026-05-25 02:10:10.306414+00	2026-06-01 06:58:55.722708+00	\N	06d97fbc-490e-4803-a2be-897b5a3d0bcd	0
acd7eb9a-4e0e-4056-91f1-50e0b8881240	3c21cb2b-21aa-428d-9991-0c320a951eef	PHÒNG 101		1	20.00	4	AVAILABLE	3500000.00	3500000.00	Phòng studio thiết kế hiện đại với diện tích 20m², không gian thoáng đãng và tối ưu cho sinh hoạt cá nhân hoặc cặp đôi. Phòng được trang bị đầy đủ nội thất gồm giường 1m8, tủ quần áo lớn, bàn làm việc, điều hòa 2 chiều, tủ lạnh, máy giặt riêng và bình nóng lạnh. Khu vực bếp mini bố trí gọn gàng với tủ bếp và bếp từ tiện lợi.\n\nPhòng có cửa sổ lớn và ban công riêng, đón ánh sáng tự nhiên và lưu thông không khí tốt, mang lại cảm giác thoải mái và dễ chịu. Nhà vệ sinh khép kín sử dụng thiết bị vệ sinh hiện đại, sạch sẽ và riêng tư.\n\nTòa nhà được trang bị wifi tốc độ cao, camera an ninh 24/7, khóa vân tay và chỗ để xe rộng rãi, đảm bảo an toàn và thuận tiện cho người thuê. Vị trí nằm gần trường học, chợ, siêu thị và các tuyến giao thông chính, phù hợp cho sinh viên, nhân viên văn phòng hoặc người làm việc tại trung tâm thành phố.	2026-05-27 02:00:54.460465+00	2026-06-01 06:58:55.722708+00	\N	158b692a-46d0-4463-814c-9d580ab7e22e	0
48ef0756-c05a-44fa-b4b0-d3f249f564d0	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	PHÒNG 102		1	20.00	4	AVAILABLE	3000000.00	3000000.00	new	2026-05-23 16:49:45.937334+00	2026-06-01 06:58:55.722708+00	\N	baefa1a2-8c5f-4898-94c7-685e6f57e377	0
e30e4555-7e6c-4c7b-8cdf-c8c57145c75d	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	MP001		2	20.00	4	AVAILABLE	3000000.00	1000000.00	new nhé	2026-05-23 16:32:49.14581+00	2026-06-01 06:58:55.722708+00	\N	7fa8ad3d-22c2-44fa-aa64-71382a7a88c9	0
f776bab1-2a8e-411e-823d-fa16270da89e	3c21cb2b-21aa-428d-9991-0c320a951eef	PHÒNG 103		1	24.00	2	RENTED	2900000.00	2900000.00	Phòng diện tích 24m² có thiết kế gác lửng giúp tối ưu diện tích sử dụng. Không gian sạch sẽ, thông thoáng với điều hòa, quạt trần, wifi tốc độ cao và nhà vệ sinh khép kín. Gác ngủ riêng tạo cảm giác rộng rãi và riêng tư.\n\nKhu trọ gần trường đại học, siêu thị mini và các tuyến xe buýt thuận tiện cho việc học tập và đi làm.	2026-05-27 02:10:42.795126+00	2026-06-01 06:58:55.722708+00	\N	158b692a-46d0-4463-814c-9d580ab7e22e	0
659998c6-e8c1-4ae8-ba7e-4ebb8f454ec2	0189a7a5-857c-4cd9-b000-3ea75f7120c8	P102		1	25.00	1	RENTED	1900000.00	500000.00		2026-05-30 07:32:05.477767+00	2026-06-01 06:58:55.722708+00	\N	b4895944-6cf3-48d0-b21d-41c23dbe4570	0
84588348-eedb-4123-bf48-72f6e03bcc18	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	303	\N	3	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	d06241e9-6a1b-4c73-bb21-74f6be5bbf5b	0
04c237b6-06b8-4c4f-a0f6-2726fd2b2545	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	304	\N	3	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	d06241e9-6a1b-4c73-bb21-74f6be5bbf5b	0
a923a1c5-c571-4e9e-bf9f-1796cc86ecf8	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	305	\N	3	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	d06241e9-6a1b-4c73-bb21-74f6be5bbf5b	0
bf7be43b-f0c2-4333-b921-6b4e6ba707a4	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	401	\N	4	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	4fecf774-3d43-498d-b85a-6a0594b699eb	0
ea0ff2bd-205e-4a88-8d3d-bda59473b0df	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	402	\N	4	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	4fecf774-3d43-498d-b85a-6a0594b699eb	0
d190fb29-811f-48bb-996b-72c34e8cc667	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	403	\N	4	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	4fecf774-3d43-498d-b85a-6a0594b699eb	0
03300ddf-8d3c-452a-b763-177b37a12b4f	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	404	\N	4	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	4fecf774-3d43-498d-b85a-6a0594b699eb	0
791b2ded-b15a-4957-9233-1f61a89bcfd9	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	405	\N	4	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	4fecf774-3d43-498d-b85a-6a0594b699eb	0
3c760a36-622f-42f4-a299-20ed2bfe130f	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	502	\N	5	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	88bede5b-2562-4357-8b37-5b54c169299c	0
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 601	\N	6	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	6e9a6b77-e407-47d3-88c7-5b6b46be7e75	0
591c8cbe-0bb7-4be1-b2bb-286147a4e215	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 602	\N	6	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	6e9a6b77-e407-47d3-88c7-5b6b46be7e75	0
8f54a087-577a-476b-8c74-cb4e6d0c35f0	3c21cb2b-21aa-428d-9991-0c320a951eef	PHÒNG 102		1	32.00	2	AVAILABLE	4200000.00	4200000.00	Phòng studio thiết kế hiện đại với diện tích 32m², không gian thoáng đãng và tối ưu cho sinh hoạt cá nhân hoặc cặp đôi. Phòng được trang bị đầy đủ nội thất gồm giường 1m8, tủ quần áo lớn, bàn làm việc, điều hòa 2 chiều, tủ lạnh, máy giặt riêng và bình nóng lạnh. Khu vực bếp mini bố trí gọn gàng với tủ bếp và bếp từ tiện lợi.\n\nPhòng có cửa sổ lớn và ban công riêng, đón ánh sáng tự nhiên và lưu thông không khí tốt, mang lại cảm giác thoải mái và dễ chịu. Nhà vệ sinh khép kín sử dụng thiết bị vệ sinh hiện đại, sạch sẽ và riêng tư.\n\nTòa nhà được trang bị wifi tốc độ cao, camera an ninh 24/7, khóa vân tay và chỗ để xe rộng rãi, đảm bảo an toàn và thuận tiện cho người thuê. Vị trí nằm gần trường học, chợ, siêu thị và các tuyến giao thông chính, phù hợp cho sinh viên, nhân viên văn phòng hoặc người làm việc tại trung tâm thành phố.	2026-05-27 02:06:13.06732+00	2026-06-01 06:58:55.722708+00	\N	158b692a-46d0-4463-814c-9d580ab7e22e	0
5ef2849e-2240-48b0-b54d-1ff2e7c94c11	0189a7a5-857c-4cd9-b000-3ea75f7120c8	P101		1	30.00	2	AVAILABLE	2000000.00	500000.00		2026-05-30 04:25:52.927794+00	2026-06-01 06:58:55.722708+00	\N	b4895944-6cf3-48d0-b21d-41c23dbe4570	0
747f8d83-d8c2-4e69-8091-36ca3ec77b1c	06e0c87c-7ddf-405e-88cb-007c509d7d8c	QA-103731-U	A	2	26.00	2	MAINTENANCE	3100000.00	3000000.00	QA room updated	2026-05-31 03:37:33.661753+00	2026-06-01 06:58:55.722708+00	2026-05-31 03:37:43.462562+00	97e00039-c25f-4f25-b702-10a77fc17a57	0
745313e9-0ead-412a-8b5f-8159a6c7b89f	b50b2531-991d-4afa-9383-3ee14f362eaf	QA-CANCEL-111119	A	1	20.00	2	AVAILABLE	2500000.00	2500000.00	QA room	2026-05-31 04:11:20.896802+00	2026-06-01 06:58:55.722708+00	\N	a21f1209-0d65-4969-8ca7-f992a3d4f67b	0
738896ea-3b09-4cab-8f71-5437c3392998	f63332e3-9477-4735-b07e-ee726bcf4c24	PHÒNG 104		1	20.00	4	RENTED	3000000.00	3000000.00	phòng mới 	2026-06-01 02:49:42.976425+00	2026-06-01 06:58:55.722708+00	\N	9be73427-d899-450b-b541-66e2805dff42	0
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 603	\N	6	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	6e9a6b77-e407-47d3-88c7-5b6b46be7e75	0
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 604	\N	6	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	6e9a6b77-e407-47d3-88c7-5b6b46be7e75	0
6183a025-92bb-47b9-b581-4151a0585a2c	6fd64279-de4f-4265-bbbc-fffa6b37d489	Phòng 605	\N	6	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.072071+00	2026-06-01 18:22:29.255514+00	2026-06-01 18:22:27.987878+00	6e9a6b77-e407-47d3-88c7-5b6b46be7e75	0
de3f5d7f-2ee8-49f3-b129-ff4db686f048	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 101	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	33c0052e-4857-43c0-b8ca-9b28600ad73f	0
a1740c2a-2fe7-4916-b6e8-ebcc7adb7c80	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 102	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	33c0052e-4857-43c0-b8ca-9b28600ad73f	0
ce3f8058-53ed-4c67-9c40-43fafef8f14d	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 103	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	33c0052e-4857-43c0-b8ca-9b28600ad73f	0
428946e1-19be-4128-ba17-1800dbedbbb0	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 104	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	33c0052e-4857-43c0-b8ca-9b28600ad73f	0
e99a9179-6b62-4fa0-8530-66f04fedd877	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 105	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	33c0052e-4857-43c0-b8ca-9b28600ad73f	0
40127c13-9ed9-4ef6-a428-de6cff371cf3	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 201	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	000974e9-cccb-486a-8576-ee01e4dc204d	0
f20d6421-6e39-4a5a-af24-799f32adf5ac	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 202	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	000974e9-cccb-486a-8576-ee01e4dc204d	0
1c97ab0f-868a-4017-91f0-391b69b72dfe	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 203	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	000974e9-cccb-486a-8576-ee01e4dc204d	0
72f8e384-22dd-43a2-ba12-75027861d2f6	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 204	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	000974e9-cccb-486a-8576-ee01e4dc204d	0
939ebf0f-3cb4-49e0-b7a6-159331098c38	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 205	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	000974e9-cccb-486a-8576-ee01e4dc204d	0
1e9100e6-7aab-4843-a87b-5de1b44a01ef	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 301	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	a59e7344-fdca-49e6-a564-11dc83ee3b75	0
b115dbc3-7c67-4157-9e50-59c7d3e41601	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 302	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	a59e7344-fdca-49e6-a564-11dc83ee3b75	0
36149d64-3e4e-4de6-b19d-d839caf621c3	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 303	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	a59e7344-fdca-49e6-a564-11dc83ee3b75	0
f7f5e823-feb8-4b37-8648-3b23febb1cfb	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 304	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	a59e7344-fdca-49e6-a564-11dc83ee3b75	0
29508272-592e-4191-b94e-8b432121024c	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 305	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	a59e7344-fdca-49e6-a564-11dc83ee3b75	0
d1f40830-6ed0-4603-a24d-98602657fc8c	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 401	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	76297bbe-05ac-46e3-a572-fb0ff477ea76	0
b91c54d3-cb7e-4024-8d3c-d76247220dfd	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 402	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	76297bbe-05ac-46e3-a572-fb0ff477ea76	0
c282b339-1ed6-452c-b4ea-ee2ecef6fe9a	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 403	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	76297bbe-05ac-46e3-a572-fb0ff477ea76	0
399a939b-93d0-45b6-a778-9f81f2e08dc3	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 404	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	76297bbe-05ac-46e3-a572-fb0ff477ea76	0
ccb78430-282b-41e8-986c-cdfd7343def3	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 405	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	76297bbe-05ac-46e3-a572-fb0ff477ea76	0
60c162b5-f2fb-4d91-b007-ba04e01555aa	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 501	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	7225842e-e31b-4a00-866e-66abc09e632c	0
755daa77-304d-4ed0-9145-0152384ffcdd	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 502	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	7225842e-e31b-4a00-866e-66abc09e632c	0
136b7d6c-3dbe-4194-b66d-4d4039bac11f	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 503	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	7225842e-e31b-4a00-866e-66abc09e632c	0
6bf1e5d8-7b1f-49d2-a427-28098130c6d2	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 505	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	7225842e-e31b-4a00-866e-66abc09e632c	0
0543c35f-e76b-4ad0-b04b-699fd9bb0f21	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	203	\N	2	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 09:31:47.410949+00	2026-06-01 09:31:47.135651+00	840caed8-9f38-4a0f-9e77-936b4a741e0d	0
c74dac96-0add-4c70-80e4-2c07823657d6	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	501	\N	5	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 09:32:45.150089+00	2026-06-01 09:32:44.858636+00	88bede5b-2562-4357-8b37-5b54c169299c	0
2c571888-c2e9-4dd2-9280-0481db7ea47e	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	503	\N	5	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 09:33:13.641248+00	2026-06-01 09:33:13.333455+00	88bede5b-2562-4357-8b37-5b54c169299c	0
aa72fd37-950e-4e0f-b932-fe3dcc2e89cf	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	101	\N	1	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	9274eb18-b57c-413f-8b01-0e62597e3508	0
d3449362-8735-40ee-8c1f-bfe1799196af	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	102	\N	1	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	9274eb18-b57c-413f-8b01-0e62597e3508	0
7da0e660-03d7-48d9-bc65-f115f7824422	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	103	\N	1	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	9274eb18-b57c-413f-8b01-0e62597e3508	0
359091c6-0131-4a73-977b-b6c1da82d144	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	104	\N	1	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	9274eb18-b57c-413f-8b01-0e62597e3508	0
9c906a9f-354d-40ec-9844-26a935402107	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	105	\N	1	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	9274eb18-b57c-413f-8b01-0e62597e3508	0
bd78e86f-ad8b-4b34-8e48-074f8769c815	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	201	\N	2	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	840caed8-9f38-4a0f-9e77-936b4a741e0d	0
e9c736e3-ede6-4eb6-8133-1de65ac5acc6	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	202	\N	2	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	840caed8-9f38-4a0f-9e77-936b4a741e0d	0
a135cbca-87ae-4c50-bab7-b1e1d9b82d9a	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	204	\N	2	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	840caed8-9f38-4a0f-9e77-936b4a741e0d	0
03757768-6d6e-4823-8e68-78cd72c88c40	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	205	\N	2	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	840caed8-9f38-4a0f-9e77-936b4a741e0d	0
cd4c306d-d0e7-4803-975f-1148d1394440	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	301	\N	3	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	d06241e9-6a1b-4c73-bb21-74f6be5bbf5b	0
7259c985-3035-4120-9b88-e707f3c5fb86	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	302	\N	3	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	d06241e9-6a1b-4c73-bb21-74f6be5bbf5b	0
203d3d0b-d89b-45ee-808b-fc752154d129	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	504	\N	5	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	88bede5b-2562-4357-8b37-5b54c169299c	0
fb74f1a5-3a77-4a3b-a9c3-15ae39ae023e	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	505	\N	5	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	88bede5b-2562-4357-8b37-5b54c169299c	0
3663cda2-cd96-4c9c-a3b4-d8c98729fe17	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	601	\N	6	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	1efd80dd-ab39-49a6-9536-2c3ec53e3fd3	0
98f9caf8-2005-4fd6-8555-cb03f57834fe	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	602	\N	6	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	1efd80dd-ab39-49a6-9536-2c3ec53e3fd3	0
cc1dd122-a97b-4d06-bd0d-a1c576573bc1	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	603	\N	6	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	1efd80dd-ab39-49a6-9536-2c3ec53e3fd3	0
74b7000c-654a-4f47-b882-f3825580df2c	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	604	\N	6	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	1efd80dd-ab39-49a6-9536-2c3ec53e3fd3	0
d9ee5b36-bc44-4247-8558-0cb467008ec9	c5ef707f-8f63-400d-b926-5f9b7f4aba8c	605	\N	6	25.00	2	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 09:04:28.597242+00	2026-06-01 18:13:40.128346+00	2026-06-01 18:13:38.895795+00	1efd80dd-ab39-49a6-9536-2c3ec53e3fd3	0
3e325a07-da5c-4b15-a1f3-ccde41772592	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 601	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	909c9f30-5e8a-42af-a20a-389388ea61aa	0
7112194a-5364-4d82-abe7-16c5daeba8c4	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 602	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	909c9f30-5e8a-42af-a20a-389388ea61aa	0
bd4b1688-e139-4d91-90dd-cdc617d02a35	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 603	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	909c9f30-5e8a-42af-a20a-389388ea61aa	0
6aad4238-fa3f-4823-927f-3d97d5f65d32	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 604	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 18:41:17.81944+00	\N	909c9f30-5e8a-42af-a20a-389388ea61aa	0
1707dfeb-7942-4339-a171-bbf0f87d03a8	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 605	\N	6	20.00	2	RENTED	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 19:31:33.189506+00	\N	909c9f30-5e8a-42af-a20a-389388ea61aa	0
1369b465-6b56-4588-837c-d2e7c14baf23	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 407	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e0892859-059c-44db-93f0-5e0ce035b5fa	0
7e0e2814-48b8-4e2d-9a26-2f5750716f2c	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 408	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e0892859-059c-44db-93f0-5e0ce035b5fa	0
b65db15a-8341-4988-ae13-aad0da51a089	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 409	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e0892859-059c-44db-93f0-5e0ce035b5fa	0
d7fa727f-dc5b-4b71-8a60-39cc4c4123bc	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 410	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e0892859-059c-44db-93f0-5e0ce035b5fa	0
3e85e817-c1a8-421a-bdf2-102ba663d347	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 501	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e25b1f2c-ab77-4ec7-94ed-93fa487cd309	0
3ce5c1aa-6ed5-4d6e-b389-9546ba73fb65	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 502	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e25b1f2c-ab77-4ec7-94ed-93fa487cd309	0
4be62a58-3497-4919-93ac-7dd3d7c71756	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 503	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e25b1f2c-ab77-4ec7-94ed-93fa487cd309	0
53480ba9-7cb1-4a4b-9f38-c599fe059c84	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 504	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e25b1f2c-ab77-4ec7-94ed-93fa487cd309	0
eebbbd5e-d815-4aae-adff-784014504088	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 505	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e25b1f2c-ab77-4ec7-94ed-93fa487cd309	0
de13ad16-bc86-490d-865c-a0281b3893c5	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 506	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e25b1f2c-ab77-4ec7-94ed-93fa487cd309	0
0f2a04de-83bc-47fc-bfd3-871ab8cbe974	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 507	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e25b1f2c-ab77-4ec7-94ed-93fa487cd309	0
21a37dcc-11de-476e-88d9-8231788e14d1	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 508	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e25b1f2c-ab77-4ec7-94ed-93fa487cd309	0
d1587209-5b15-4416-9fc3-137274c32dae	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 509	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e25b1f2c-ab77-4ec7-94ed-93fa487cd309	0
9a20beff-bcb8-4b79-aca2-1cd6c63db6f7	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 510	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e25b1f2c-ab77-4ec7-94ed-93fa487cd309	0
e8473758-8a48-412c-a277-69092e726b6a	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 601	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	a4eafd70-f390-47e2-a4d8-2065f951666b	0
0b1b8b43-9589-48fd-8c4a-a1af881eb98b	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 602	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	a4eafd70-f390-47e2-a4d8-2065f951666b	0
2b2944f0-ba7e-48aa-b3e9-f766b1a026ea	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 603	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	a4eafd70-f390-47e2-a4d8-2065f951666b	0
b7083879-78f9-4d19-954f-f9061f8d7a6c	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 604	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	a4eafd70-f390-47e2-a4d8-2065f951666b	0
ebc0a8f3-3e6a-43aa-aa48-2f5df129975a	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 605	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	a4eafd70-f390-47e2-a4d8-2065f951666b	0
6beef4d3-8355-4104-8bd5-2796ace4d4db	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 606	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	a4eafd70-f390-47e2-a4d8-2065f951666b	0
40bb1a31-7ef7-41fa-a041-f6c4c70a3721	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 607	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	a4eafd70-f390-47e2-a4d8-2065f951666b	0
ecfca3a0-17e3-41ab-9d92-d103671bbe53	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 608	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	a4eafd70-f390-47e2-a4d8-2065f951666b	0
4dd64abd-0fac-47f7-b4ec-853a5501726f	376343b4-f368-407e-bacb-5a3462721473	Phòng 101	\N	1	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	49a90761-b85f-453d-bb86-fecbe3346d4c	0
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	376343b4-f368-407e-bacb-5a3462721473	Phòng 102	\N	1	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	49a90761-b85f-453d-bb86-fecbe3346d4c	0
f4461d85-bfbb-4cf8-aa27-752367c8f274	376343b4-f368-407e-bacb-5a3462721473	Phòng 103	\N	1	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	49a90761-b85f-453d-bb86-fecbe3346d4c	0
b48397ae-e617-438c-b2e9-b6acfc2e2b59	376343b4-f368-407e-bacb-5a3462721473	Phòng 104	\N	1	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	49a90761-b85f-453d-bb86-fecbe3346d4c	0
6c630751-8020-4457-af88-4cce8d42609c	376343b4-f368-407e-bacb-5a3462721473	Phòng 105	\N	1	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	49a90761-b85f-453d-bb86-fecbe3346d4c	0
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	376343b4-f368-407e-bacb-5a3462721473	Phòng 201	\N	2	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	58924ea2-d84b-4351-bb59-b1d840601dc6	0
202ef8f3-71c7-491d-8f4d-3af7dab5569e	376343b4-f368-407e-bacb-5a3462721473	Phòng 202	\N	2	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	58924ea2-d84b-4351-bb59-b1d840601dc6	0
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	376343b4-f368-407e-bacb-5a3462721473	Phòng 203	\N	2	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	58924ea2-d84b-4351-bb59-b1d840601dc6	0
14f9e931-7065-4e19-a9d0-ef99abb09e36	376343b4-f368-407e-bacb-5a3462721473	Phòng 204	\N	2	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	58924ea2-d84b-4351-bb59-b1d840601dc6	0
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	376343b4-f368-407e-bacb-5a3462721473	Phòng 205	\N	2	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	58924ea2-d84b-4351-bb59-b1d840601dc6	0
b42232b8-545d-4fa1-aaed-8c2b8e05898c	376343b4-f368-407e-bacb-5a3462721473	Phòng 301	\N	3	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	1c9c5978-23d1-4d3e-b5bc-96e96d4fe273	0
1b84150e-7f49-47ce-a857-4e5f42c23196	376343b4-f368-407e-bacb-5a3462721473	Phòng 302	\N	3	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	1c9c5978-23d1-4d3e-b5bc-96e96d4fe273	0
941a5a87-475f-421f-85f8-9202e4514616	376343b4-f368-407e-bacb-5a3462721473	Phòng 303	\N	3	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	1c9c5978-23d1-4d3e-b5bc-96e96d4fe273	0
bb0c0445-82f3-4df1-9b46-277d41dac414	376343b4-f368-407e-bacb-5a3462721473	Phòng 304	\N	3	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	1c9c5978-23d1-4d3e-b5bc-96e96d4fe273	0
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	376343b4-f368-407e-bacb-5a3462721473	Phòng 305	\N	3	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	1c9c5978-23d1-4d3e-b5bc-96e96d4fe273	0
9375f873-9e78-4bc9-9a94-b2b13143f3ef	376343b4-f368-407e-bacb-5a3462721473	Phòng 401	\N	4	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	6530c411-f123-4086-92f7-c5c9fca85d16	0
970d78dd-64e7-4033-a8f1-0cb5e537bb43	376343b4-f368-407e-bacb-5a3462721473	Phòng 402	\N	4	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	6530c411-f123-4086-92f7-c5c9fca85d16	0
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	376343b4-f368-407e-bacb-5a3462721473	Phòng 403	\N	4	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	6530c411-f123-4086-92f7-c5c9fca85d16	0
daaf7cf4-57c7-499e-8f8b-caf257c74bf0	819d7425-1224-4850-8e90-a1dc4b0155e4	Phòng 504	\N	5	20.00	2	RENTED	2500000.00	2500000.00	\N	2026-06-01 18:41:17.81944+00	2026-06-01 19:56:16.334101+00	\N	7225842e-e31b-4a00-866e-66abc09e632c	0
6b3c93d4-1e32-48ca-996c-97788ef201d4	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 609	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	a4eafd70-f390-47e2-a4d8-2065f951666b	0
b229672d-279f-4a07-82e0-2561c004cb2e	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 610	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	a4eafd70-f390-47e2-a4d8-2065f951666b	0
9dc0f0c7-d632-4f0e-9b9e-76d76a726e09	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 701	\N	7	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	99f08e5d-8c2b-40f1-83c7-3b92bc78c0e8	0
d9855233-88d7-4ee9-a73a-39334f4fc336	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 702	\N	7	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	99f08e5d-8c2b-40f1-83c7-3b92bc78c0e8	0
5d7f9029-445a-4b4f-b273-3cfa24899d15	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 703	\N	7	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	99f08e5d-8c2b-40f1-83c7-3b92bc78c0e8	0
4d35f475-6012-4bf8-b771-97524b063d0e	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 704	\N	7	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	99f08e5d-8c2b-40f1-83c7-3b92bc78c0e8	0
4b3e43d7-4461-42e5-9f23-1931d82ed66c	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 705	\N	7	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	99f08e5d-8c2b-40f1-83c7-3b92bc78c0e8	0
e862ac04-d7ca-44db-b7f3-9647de6bcdbb	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 706	\N	7	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	99f08e5d-8c2b-40f1-83c7-3b92bc78c0e8	0
aed1bb1c-0385-43ba-8df8-82705fe44c0b	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 707	\N	7	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	99f08e5d-8c2b-40f1-83c7-3b92bc78c0e8	0
b0852bad-a83a-44ba-810e-0d62707f76eb	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 708	\N	7	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	99f08e5d-8c2b-40f1-83c7-3b92bc78c0e8	0
25d702da-f331-49b4-9e38-b0eb44930f7c	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 709	\N	7	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	99f08e5d-8c2b-40f1-83c7-3b92bc78c0e8	0
da3adc74-99e0-461d-9518-56875ec0ae2f	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 710	\N	7	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	99f08e5d-8c2b-40f1-83c7-3b92bc78c0e8	0
f7741410-bd52-4b20-a8d3-bd415a25d2b0	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 102	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	502d49fb-beaa-479b-80fa-f4b855ff715a	0
20b8422e-5537-4711-9902-d2efd152f3a3	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 103	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	502d49fb-beaa-479b-80fa-f4b855ff715a	0
a7c5e0d9-78cd-4922-a391-79f7d51b09fb	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 104	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	502d49fb-beaa-479b-80fa-f4b855ff715a	0
8287a816-4b08-4af9-8096-9b5bf859a487	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 105	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	502d49fb-beaa-479b-80fa-f4b855ff715a	0
c6334989-e7f7-4ee2-b37f-4d376436fdfb	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 106	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	502d49fb-beaa-479b-80fa-f4b855ff715a	0
cdc7eb6e-653a-46dd-9b8a-088f59dc57d0	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 107	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	502d49fb-beaa-479b-80fa-f4b855ff715a	0
06db94a4-10b9-498e-b718-60d70ef8d298	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 108	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	502d49fb-beaa-479b-80fa-f4b855ff715a	0
69b3c45e-eba2-4da0-846e-fb5e95bc28d7	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 109	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	502d49fb-beaa-479b-80fa-f4b855ff715a	0
71b1f5f5-950c-4616-997c-f3376e63c8f4	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 110	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	502d49fb-beaa-479b-80fa-f4b855ff715a	0
49991c44-ca21-4c26-9525-d1002b0fc840	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 201	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	a1980dd5-b915-4699-9fc6-d59bc02c6877	0
dc14a24e-14f3-49df-8211-a840ba06266a	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 202	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	a1980dd5-b915-4699-9fc6-d59bc02c6877	0
7fd52685-1f62-47c3-a9b9-37cad24acbb6	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 203	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	a1980dd5-b915-4699-9fc6-d59bc02c6877	0
c50f7b99-0ebe-4e33-89f9-c6b8cb2887d3	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 204	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	a1980dd5-b915-4699-9fc6-d59bc02c6877	0
767bbd60-6207-4ec8-8db0-ff197058a296	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 205	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	a1980dd5-b915-4699-9fc6-d59bc02c6877	0
534f5f8e-faa4-499f-8da3-9e803dfe318b	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 206	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	a1980dd5-b915-4699-9fc6-d59bc02c6877	0
f28db6d1-1bd2-45a0-ac71-32c68a48413d	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 101	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	c050e8b7-9635-48e0-ace3-15b6a8d314c8	0
797863e7-d0b4-4a7a-ad8a-7339fa613c12	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 102	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	c050e8b7-9635-48e0-ace3-15b6a8d314c8	0
28a46d86-12c0-4ceb-830f-537cfbda6692	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 103	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	c050e8b7-9635-48e0-ace3-15b6a8d314c8	0
43aabfbf-3a47-4587-a59f-0af58c29d19b	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 104	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	c050e8b7-9635-48e0-ace3-15b6a8d314c8	0
2bc25442-64a4-463b-918b-314b18f1df6a	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 105	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	c050e8b7-9635-48e0-ace3-15b6a8d314c8	0
d8376ec7-f5a7-47cf-a33f-b789c283f54f	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 201	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	5d8e8a7e-81f3-4859-b523-a1603da39ea4	0
f0ccc6bd-3043-41fe-89be-a765c9d776a4	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 202	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	5d8e8a7e-81f3-4859-b523-a1603da39ea4	0
c1d43028-6ecd-4bfc-9f7b-126ba6f8641f	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 203	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	5d8e8a7e-81f3-4859-b523-a1603da39ea4	0
1364bdc3-d951-4a73-9963-b8e9a077a389	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 204	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	5d8e8a7e-81f3-4859-b523-a1603da39ea4	0
ae7a7422-2a8d-43ea-9fa2-443fd6ef7eed	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 205	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	5d8e8a7e-81f3-4859-b523-a1603da39ea4	0
d84a5906-44ff-43ff-853b-5cfd2b562412	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 301	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	7821f926-c578-4cf8-b5b5-d5abf165f147	0
4433637a-0cf4-4c26-ba8a-ce5c78af5526	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 302	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	7821f926-c578-4cf8-b5b5-d5abf165f147	0
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	376343b4-f368-407e-bacb-5a3462721473	Phòng 404	\N	4	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	6530c411-f123-4086-92f7-c5c9fca85d16	0
f234f602-db47-4d6b-af57-843059bd5042	376343b4-f368-407e-bacb-5a3462721473	Phòng 405	\N	4	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	6530c411-f123-4086-92f7-c5c9fca85d16	0
d7a48670-9149-4882-a8b4-eb25a1774e1d	376343b4-f368-407e-bacb-5a3462721473	Phòng 501	\N	5	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	0cd84afc-6e4c-47f7-8f6e-57be5361c794	0
3883fd77-d7cf-472f-8f2d-6624a24ce399	376343b4-f368-407e-bacb-5a3462721473	Phòng 502	\N	5	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	0cd84afc-6e4c-47f7-8f6e-57be5361c794	0
c1adaa94-cab9-420c-8d18-dafbb127ae9d	376343b4-f368-407e-bacb-5a3462721473	Phòng 503	\N	5	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	0cd84afc-6e4c-47f7-8f6e-57be5361c794	0
22273668-4a89-466d-b9af-170555385d89	376343b4-f368-407e-bacb-5a3462721473	Phòng 504	\N	5	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	0cd84afc-6e4c-47f7-8f6e-57be5361c794	0
35b5374c-a3ec-4256-9b25-9a748641f27f	376343b4-f368-407e-bacb-5a3462721473	Phòng 505	\N	5	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	0cd84afc-6e4c-47f7-8f6e-57be5361c794	0
ac31dcb1-552e-42f5-8716-401aec5cf15e	376343b4-f368-407e-bacb-5a3462721473	Phòng 601	\N	6	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	2f6644f5-1bc9-44c4-9a9e-e8f8b5da68a7	0
63c3369b-2d60-4fc9-aedf-8e6567e627b2	376343b4-f368-407e-bacb-5a3462721473	Phòng 602	\N	6	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	2f6644f5-1bc9-44c4-9a9e-e8f8b5da68a7	0
2c789132-952b-4456-87f7-4977403ca50e	376343b4-f368-407e-bacb-5a3462721473	Phòng 603	\N	6	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	2f6644f5-1bc9-44c4-9a9e-e8f8b5da68a7	0
03633568-e1e7-48ad-8502-dc8f80c41ee4	376343b4-f368-407e-bacb-5a3462721473	Phòng 604	\N	6	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	2f6644f5-1bc9-44c4-9a9e-e8f8b5da68a7	0
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	376343b4-f368-407e-bacb-5a3462721473	Phòng 605	\N	6	25.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-01 18:19:11.807229+00	2026-06-01 18:38:10.194835+00	2026-06-01 18:38:08.875537+00	2f6644f5-1bc9-44c4-9a9e-e8f8b5da68a7	0
726e329b-5a55-4932-b4c6-1f49ab90bbea	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 303	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	7821f926-c578-4cf8-b5b5-d5abf165f147	0
6f291510-7198-4d86-8025-f8897d7938b5	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 304	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	7821f926-c578-4cf8-b5b5-d5abf165f147	0
fcf8a87b-77d7-4134-adb5-dc4bc9df8db5	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 305	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	7821f926-c578-4cf8-b5b5-d5abf165f147	0
98f54a91-ea09-4ea9-b45c-19da1fe41beb	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 401	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	c2b782b1-db00-4656-99d8-5b1133102f6a	0
27adfedf-3170-4378-acda-b8d310d130f0	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 402	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	c2b782b1-db00-4656-99d8-5b1133102f6a	0
1703adbd-a7c7-4219-8b55-b3197eae9b50	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 403	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	c2b782b1-db00-4656-99d8-5b1133102f6a	0
4aa71440-5e43-4bf4-8c85-875e7be2e961	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 404	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	c2b782b1-db00-4656-99d8-5b1133102f6a	0
aa0c9dff-c075-471d-bf86-f6715a53aaa5	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 405	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	c2b782b1-db00-4656-99d8-5b1133102f6a	0
cc74678e-f511-4d1e-b7da-e07716788fe4	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 501	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	01837be0-052e-4a5f-a27b-3b0bf3aa42d7	0
bd9a5c8b-08b2-48fe-a900-191c850b8a1a	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 502	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	01837be0-052e-4a5f-a27b-3b0bf3aa42d7	0
b257cebc-cd9b-4ca8-a0dc-a3403c96d17a	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 503	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	01837be0-052e-4a5f-a27b-3b0bf3aa42d7	0
3a495b3c-d636-4f90-8f11-733a70606745	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 504	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	01837be0-052e-4a5f-a27b-3b0bf3aa42d7	0
9cd4c4dd-d361-4dc2-8423-71a12fedc3b7	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 505	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	01837be0-052e-4a5f-a27b-3b0bf3aa42d7	0
446421b5-fe6d-43c7-ae40-d0b9ec2d5d56	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 601	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	f959b5a2-d5a1-4b9b-a635-dd333b5e4b8c	0
423f24ad-14c9-4bd6-ab07-6c75d11d2301	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 602	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	f959b5a2-d5a1-4b9b-a635-dd333b5e4b8c	0
b6f7a9e5-b8cd-4c97-9aca-3c55988bcb63	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 603	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	f959b5a2-d5a1-4b9b-a635-dd333b5e4b8c	0
947d30dd-6721-4842-8fc7-2ac5d449dc8d	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 604	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	f959b5a2-d5a1-4b9b-a635-dd333b5e4b8c	0
b1b8794a-bf6c-4b5e-addd-dfbeb02e3a18	30cf5842-0171-48b4-ac8d-78081e0c7777	Phòng 605	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-01 18:23:25.597482+00	2026-06-01 18:38:00.773174+00	2026-06-01 18:37:59.453925+00	f959b5a2-d5a1-4b9b-a635-dd333b5e4b8c	0
6a5d456b-8e8f-4729-9cf8-35b05359a9ef	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 101	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	fa1d8ef0-f224-40d2-86c9-4e128ec0c571	0
010b0a7c-86ca-424b-bef7-e99b6d8041c7	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 102	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	fa1d8ef0-f224-40d2-86c9-4e128ec0c571	0
beed032b-9881-4f4c-9dd5-786da9ba1115	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 103	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	fa1d8ef0-f224-40d2-86c9-4e128ec0c571	0
bf722b52-1633-4aca-9902-de83310f5ebf	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 104	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	fa1d8ef0-f224-40d2-86c9-4e128ec0c571	0
d60df1f5-d6b4-4e70-beb9-e90abbb3ccd3	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 105	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	fa1d8ef0-f224-40d2-86c9-4e128ec0c571	0
19d05db6-eb97-4267-bc88-1599e3b3b829	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 106	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	fa1d8ef0-f224-40d2-86c9-4e128ec0c571	0
4160dd24-4d87-4c6f-97fd-712b4cdbc4c9	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 107	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	fa1d8ef0-f224-40d2-86c9-4e128ec0c571	0
5e5be979-e1e7-4ca6-b751-131efad44b43	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 108	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	fa1d8ef0-f224-40d2-86c9-4e128ec0c571	0
348ec413-0b86-47b7-9fb8-4c8b84b8920c	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 109	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	fa1d8ef0-f224-40d2-86c9-4e128ec0c571	0
56ad0c8a-a4cc-4d03-8d76-74ed1f9b45e7	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 110	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	fa1d8ef0-f224-40d2-86c9-4e128ec0c571	0
d4d5b622-4ca4-4a03-bb28-97e2120dd9e4	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 201	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	805ce818-c842-491b-83c4-69ce94e8e958	0
e6a78b1a-f229-4b70-b30c-022a6b83219b	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 202	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	805ce818-c842-491b-83c4-69ce94e8e958	0
39e6e488-d55d-4e98-8223-e831a2531642	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 203	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	805ce818-c842-491b-83c4-69ce94e8e958	0
521b2bea-5333-4377-87d7-7ec344bb015f	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 204	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	805ce818-c842-491b-83c4-69ce94e8e958	0
401ff83b-5e99-4708-a97b-30b3fa712703	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 205	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	805ce818-c842-491b-83c4-69ce94e8e958	0
cf37fa79-973f-41cc-b398-16c824eb5771	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 206	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	805ce818-c842-491b-83c4-69ce94e8e958	0
aac69282-fec3-481b-ae58-0d79e8985977	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 207	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	805ce818-c842-491b-83c4-69ce94e8e958	0
cc622fd0-d36b-4eb3-88f0-783f00ba42c9	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 208	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	805ce818-c842-491b-83c4-69ce94e8e958	0
41b611c0-8c04-4947-af58-8b499832bd45	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 209	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	805ce818-c842-491b-83c4-69ce94e8e958	0
44f6fa70-2f22-4d6e-9244-5acb7aaebc62	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 210	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	805ce818-c842-491b-83c4-69ce94e8e958	0
03d773b9-6bd0-4273-b0e5-31a631703129	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 301	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e00e60f1-c962-4a06-bcba-86873ca2ec15	0
c8dd6000-a5ea-4c3b-965b-a7d5b90b71b3	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 302	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e00e60f1-c962-4a06-bcba-86873ca2ec15	0
1b7c26fa-8017-40e3-8b12-e0aa29b475ac	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 303	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e00e60f1-c962-4a06-bcba-86873ca2ec15	0
a558f4ed-139d-4ea7-887d-f61393066c5d	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 304	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e00e60f1-c962-4a06-bcba-86873ca2ec15	0
4fa5d46c-673a-49eb-aab4-5f0f6782f2b1	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 305	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e00e60f1-c962-4a06-bcba-86873ca2ec15	0
8b6cb2f4-08f9-44a1-9eca-838bf2852862	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 306	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e00e60f1-c962-4a06-bcba-86873ca2ec15	0
2cea284e-c5ec-4160-9853-f04e3d931833	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 307	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e00e60f1-c962-4a06-bcba-86873ca2ec15	0
95c52880-f900-440d-8598-46c4b9ea155d	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 308	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e00e60f1-c962-4a06-bcba-86873ca2ec15	0
45660849-8638-4f46-b626-b4a9a0f987e6	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 309	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e00e60f1-c962-4a06-bcba-86873ca2ec15	0
e54d8cca-ef3d-4fc3-8e9b-fc25400b60e0	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 310	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e00e60f1-c962-4a06-bcba-86873ca2ec15	0
d7712abc-0423-47ab-8238-08bd141fc71c	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 401	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e0892859-059c-44db-93f0-5e0ce035b5fa	0
6ce97ced-6e6a-4953-baab-45d2648ead58	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 402	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e0892859-059c-44db-93f0-5e0ce035b5fa	0
7a6be562-0004-4747-a007-85d61471bc9c	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 403	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e0892859-059c-44db-93f0-5e0ce035b5fa	0
bda0924a-53e0-4e08-89d7-c83ae811512e	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 404	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e0892859-059c-44db-93f0-5e0ce035b5fa	0
a2832ea8-52b5-434b-a16e-f2ec870d4d6a	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 405	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e0892859-059c-44db-93f0-5e0ce035b5fa	0
0e50ca82-84f2-4c0c-9f23-d4188ea93fc2	6f0fb149-c580-4ec5-b097-4d7e120653dd	Phòng 406	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-02 14:09:17.675524+00	2026-06-02 14:09:17.675524+00	\N	e0892859-059c-44db-93f0-5e0ce035b5fa	0
098b4994-4fad-4058-bfa8-51be1d269f5c	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 207	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	a1980dd5-b915-4699-9fc6-d59bc02c6877	0
43e0c500-e2eb-4583-9871-84e622cbc27a	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 208	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	a1980dd5-b915-4699-9fc6-d59bc02c6877	0
1e3825fb-ee88-4f07-8f61-0ad3b600c20d	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 209	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	a1980dd5-b915-4699-9fc6-d59bc02c6877	0
f799803c-676d-4b34-bf19-dd80b29f89ef	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 210	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	a1980dd5-b915-4699-9fc6-d59bc02c6877	0
25216422-af7d-49f0-9d8c-ea7622c23255	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 301	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	57528ed3-18ec-4da9-b58c-71b3e13ca6cc	0
25f332d5-6ea8-4e94-bc1e-bae6abe38e85	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 302	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	57528ed3-18ec-4da9-b58c-71b3e13ca6cc	0
4516c8ad-bc19-4e83-9ac1-24855ec10d80	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 303	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	57528ed3-18ec-4da9-b58c-71b3e13ca6cc	0
1d5aec7b-e41d-4926-9dbe-7c55ed740f73	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 304	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	57528ed3-18ec-4da9-b58c-71b3e13ca6cc	0
ce4f00de-6029-4a5d-8a15-13948fd9f9ec	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 305	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	57528ed3-18ec-4da9-b58c-71b3e13ca6cc	0
a98c2d48-2a25-4840-9267-2eadb172ebf5	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 306	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	57528ed3-18ec-4da9-b58c-71b3e13ca6cc	0
2e4cf497-14b5-45cc-bd60-556e78ca4652	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 307	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	57528ed3-18ec-4da9-b58c-71b3e13ca6cc	0
7ebe65d5-0c36-4dab-ade3-6a8147e07501	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 308	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	57528ed3-18ec-4da9-b58c-71b3e13ca6cc	0
960bcbe3-a154-43dc-b9ba-8d63687cdb4b	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 309	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	57528ed3-18ec-4da9-b58c-71b3e13ca6cc	0
163c0b1d-1c3a-4148-95b9-d346871471d0	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 310	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	57528ed3-18ec-4da9-b58c-71b3e13ca6cc	0
349063a2-ec9c-42ba-9e09-d79e56ad1259	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 403	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	cdbf00a2-12db-48ac-ad33-510cb99ed1c5	0
e6501d90-85e2-49c1-84b4-5cc953ed8e2e	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 404	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	cdbf00a2-12db-48ac-ad33-510cb99ed1c5	0
de940c21-41d5-4e88-bd0d-9d68bff89c01	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 405	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	cdbf00a2-12db-48ac-ad33-510cb99ed1c5	0
8440b404-3081-4bfd-8cee-84f0e85609f4	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 406	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	cdbf00a2-12db-48ac-ad33-510cb99ed1c5	0
d4fd1537-b93d-47b2-ae5c-6381935b7a7e	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 407	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	cdbf00a2-12db-48ac-ad33-510cb99ed1c5	0
ffb8c8e7-a824-4384-84fd-6ce6d67dacf2	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 408	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	cdbf00a2-12db-48ac-ad33-510cb99ed1c5	0
c32455af-5ba5-45a1-a269-6ebb0a36e444	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 409	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	cdbf00a2-12db-48ac-ad33-510cb99ed1c5	0
08694424-8883-40ec-8070-d89eee86743c	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 410	\N	4	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	cdbf00a2-12db-48ac-ad33-510cb99ed1c5	0
839ee6cb-cbf6-4b75-bff3-cfa3dde1a83e	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 501	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	8d2ed800-1e17-490f-9b30-edb8890efe92	0
51beb2a6-a3ed-4d2f-9ee8-b454ece9bac8	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 502	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	8d2ed800-1e17-490f-9b30-edb8890efe92	0
b9b086fe-c346-452e-824f-41edd2303c38	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 503	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	8d2ed800-1e17-490f-9b30-edb8890efe92	0
c773aa3c-e99d-4778-8108-165c2f8efd98	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 504	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	8d2ed800-1e17-490f-9b30-edb8890efe92	0
c1076b3d-1515-478d-8548-a5269df52271	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 505	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	8d2ed800-1e17-490f-9b30-edb8890efe92	0
6263f9eb-4389-426e-b27d-85ec7621a6bd	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 506	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	8d2ed800-1e17-490f-9b30-edb8890efe92	0
5bf0945f-ddae-4611-9bbf-7f97a3c6e3df	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 507	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	8d2ed800-1e17-490f-9b30-edb8890efe92	0
ceccf7e5-96b9-4c3f-84ae-4e23122802ea	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 508	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	8d2ed800-1e17-490f-9b30-edb8890efe92	0
f8ebea93-e5a1-432a-b33e-6015e561d2a1	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 509	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	8d2ed800-1e17-490f-9b30-edb8890efe92	0
453f791b-cac5-48b9-be3e-b5a78600b191	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 510	\N	5	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	8d2ed800-1e17-490f-9b30-edb8890efe92	0
f4549c38-1099-4e58-b7dc-8e4a96283d4c	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 601	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	b1168d7d-c15c-4be8-9cdf-a5eb78f8efdb	0
a3882545-402f-4045-b806-6ce79b995d98	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 602	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	b1168d7d-c15c-4be8-9cdf-a5eb78f8efdb	0
91a74f01-0910-48c9-b938-6e45052fcb1f	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 603	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	b1168d7d-c15c-4be8-9cdf-a5eb78f8efdb	0
aa773e93-1d5a-48fa-9b5b-282377d3429e	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 604	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	b1168d7d-c15c-4be8-9cdf-a5eb78f8efdb	0
0b64f493-4229-4222-8e7c-55a0d2fff505	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 605	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	b1168d7d-c15c-4be8-9cdf-a5eb78f8efdb	0
6c097b74-7ec6-489d-a7ad-4b094a6c2f9a	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 606	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	b1168d7d-c15c-4be8-9cdf-a5eb78f8efdb	0
605696f9-82b4-4b88-94b6-019a55361c93	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 607	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	b1168d7d-c15c-4be8-9cdf-a5eb78f8efdb	0
42b70aa0-4195-43dc-8d47-605b53a4c14e	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 608	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	b1168d7d-c15c-4be8-9cdf-a5eb78f8efdb	0
c1b57f4a-4acd-4da7-bcbb-ff05a92080c2	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 609	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	b1168d7d-c15c-4be8-9cdf-a5eb78f8efdb	0
6525b446-1b69-477e-b562-018daddc5c34	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 610	\N	6	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:32:45.726482+00	\N	b1168d7d-c15c-4be8-9cdf-a5eb78f8efdb	0
420f922c-36c0-4b17-a74c-f08262c6f30f	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 101	\N	1	20.00	2	RENTED	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-03 13:35:59.650412+00	\N	502d49fb-beaa-479b-80fa-f4b855ff715a	0
16899884-b3a0-4e2f-a6f6-981834f39065	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 402	\N	4	20.00	2	RENTED	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-10 02:47:04.524371+00	\N	cdbf00a2-12db-48ac-ad33-510cb99ed1c5	0
7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	f63332e3-9477-4735-b07e-ee726bcf4c24	PHÒNG 105		1	20.00	4	AVAILABLE	3000000.00	0.00		2026-06-05 02:27:34.729403+00	2026-06-05 02:32:47.536259+00	\N	9be73427-d899-450b-b541-66e2805dff42	0
f7c95777-0fdc-4e30-8a54-f50e5ab72224	18f65b13-c046-412a-b1cd-0ebb3b01e00b	Phòng 401	\N	4	20.00	2	RENTED	2500000.00	2500000.00	\N	2026-06-03 13:32:45.726482+00	2026-06-10 02:14:51.089616+00	\N	cdbf00a2-12db-48ac-ad33-510cb99ed1c5	0
e6ae979f-35fd-4da4-bcc3-f76bfdf71d03	0189a7a5-857c-4cd9-b000-3ea75f7120c8	P103		1	20.00	1	RENTED	2000000.00	499997.00		2026-06-13 15:46:32.406973+00	2026-06-13 15:53:20.161212+00	\N	b4895944-6cf3-48d0-b21d-41c23dbe4570	0
\.

--
-- Data for Name: hop_dong; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."hop_dong" ("id", "phong_id", "khach_thue_id", "ma_hop_dong", "ngay_bat_dau", "ngay_ket_thuc", "ngay_ket_thuc_thuc_te", "gia_thue_hop_dong", "tien_coc", "trang_thai_coc", "trang_thai", "chu_ky_thanh_toan", "ngay_thanh_toan_hang_thang", "tu_dong_gia_han", "chi_so_dien_ban_dau", "chi_so_nuoc_ban_dau", "noi_dung_hop_dong", "file_pdf", "ghi_chu", "tao_luc", "cap_nhat_luc", "xoa_luc", "template_version", "previewed_at", "confirmed_at", "locked_at", "signed_pdf_url", "tenant_signed_at", "landlord_signed_at", "signature_status") FROM stdin;
b797e88b-a0f1-4b56-8ca7-6a6da5c0240f	e30e4555-7e6c-4c7b-8cdf-c8c57145c75d	cdbe66ce-3bf0-4023-b2c8-38ba477730f1	HD003	2026-05-24	2026-08-24	\N	3000000.00	1000000.00	NOT_PAID	PENDING	MONTHLY	15	f	0	0	ĐIỀU KHOẢN HỢP ĐỒNG THUÊ PHÒNG\n\n1. BÊN CHO THUÊ (Chủ nhà):\n- Cung cấp phòng ở đầy đủ tiện nghi theo thỏa thuận\n- Đảm bảo an ninh, an toàn cho khách thuê\n- Bảo trì, sửa chữa các hư hỏng do hao mòn tự nhiên\n\n2. BÊN THUÊ (Khách thuê):\n- Thanh toán đúng hạn tiền thuê và các chi phí khác\n- Sử dụng phòng đúng mục đích, giữ gìn vệ sinh\n- Không được cải tạo, sửa chữa phòng mà không có sự đồng ý\n- Báo cáo kịp thời các hư hỏng, sự cố\n\n3. ĐIỀU KHOẢN CHUNG:\n- Thời hạn hợp đồng: Từ ngày bắt đầu đến ngày kết thúc\n- Tiền cọc: Được hoàn trả khi kết thúc hợp đồng (trừ các khoản phát sinh)\n- Thanh toán: Hàng tháng vào ngày quy định\n- Điện, nước: Tính theo chỉ số đồng hồ và giá quy định\n- Phí dịch vụ: Theo thỏa thuận riêng\n\n4. CHẤM DỨT HỢP ĐỒNG:\n- Bên thuê có thể chấm dứt hợp đồng trước thời hạn với thông báo trước 30 ngày\n- Bên cho thuê có thể chấm dứt hợp đồng nếu vi phạm nghiêm trọng\n- Hoàn trả tiền cọc sau khi kiểm tra tình trạng phòng\n\n5. ĐIỀU KHOẢN KHÁC:\n- Hai bên cam kết thực hiện đúng các điều khoản đã thỏa thuận\n- Mọi tranh chấp sẽ được giải quyết thông qua thương lượng\n- Hợp đồng có hiệu lực kể từ ngày ký	\N	\N	2026-05-24 06:09:39.143652+00	2026-05-27 02:11:55.55544+00	2026-05-27 02:11:54.039362+00	\N	\N	\N	\N	\N	\N	\N	UNSIGNED
f5075e49-2b06-4750-834e-e157f7e09a82	48ef0756-c05a-44fa-b4b0-d3f249f564d0	fba2a7bd-082f-47f7-b0cc-3c53e79352c4	HD-102-2026	2026-01-01	2026-12-31	\N	3000000.00	3000000.00	KEPT	CANCELLED	MONTHLY	5	f	100	50	Hợp đồng thuê phòng 102	\N	\N	2026-05-24 03:13:31.178449+00	2026-06-01 19:17:11.4333+00	2026-06-01 19:17:10.075172+00	\N	\N	\N	\N	\N	\N	\N	UNSIGNED
ca0fe835-cf14-4b4f-93ab-eb14d1ad250d	e30e4555-7e6c-4c7b-8cdf-c8c57145c75d	cdbe66ce-3bf0-4023-b2c8-38ba477730f1	HD004	2026-05-24	2026-08-24	\N	3000000.00	1000000.00	NOT_PAID	DRAFT	MONTHLY	15	f	0	0	ĐIỀU KHOẢN HỢP ĐỒNG THUÊ PHÒNG\n\n1. BÊN CHO THUÊ (Chủ nhà):\n- Cung cấp phòng ở đầy đủ tiện nghi theo thỏa thuận\n- Đảm bảo an ninh, an toàn cho khách thuê\n- Bảo trì, sửa chữa các hư hỏng do hao mòn tự nhiên\n\n2. BÊN THUÊ (Khách thuê):\n- Thanh toán đúng hạn tiền thuê và các chi phí khác\n- Sử dụng phòng đúng mục đích, giữ gìn vệ sinh\n- Không được cải tạo, sửa chữa phòng mà không có sự đồng ý\n- Báo cáo kịp thời các hư hỏng, sự cố\n\n3. ĐIỀU KHOẢN CHUNG:\n- Thời hạn hợp đồng: Từ ngày bắt đầu đến ngày kết thúc\n- Tiền cọc: Được hoàn trả khi kết thúc hợp đồng (trừ các khoản phát sinh)\n- Thanh toán: Hàng tháng vào ngày quy định\n- Điện, nước: Tính theo chỉ số đồng hồ và giá quy định\n- Phí dịch vụ: Theo thỏa thuận riêng\n\n4. CHẤM DỨT HỢP ĐỒNG:\n- Bên thuê có thể chấm dứt hợp đồng trước thời hạn với thông báo trước 30 ngày\n- Bên cho thuê có thể chấm dứt hợp đồng nếu vi phạm nghiêm trọng\n- Hoàn trả tiền cọc sau khi kiểm tra tình trạng phòng\n\n5. ĐIỀU KHOẢN KHÁC:\n- Hai bên cam kết thực hiện đúng các điều khoản đã thỏa thuận\n- Mọi tranh chấp sẽ được giải quyết thông qua thương lượng\n- Hợp đồng có hiệu lực kể từ ngày ký	\N	\N	2026-05-24 05:05:02.014682+00	2026-05-27 02:11:51.855465+00	2026-05-27 02:11:50.383673+00	\N	\N	\N	\N	\N	\N	\N	UNSIGNED
774f59eb-d908-4313-95aa-46ae4136e932	f776bab1-2a8e-411e-823d-fa16270da89e	625c3321-ab04-4330-9e34-2a4458635624	HD-CL-103-2026	2026-05-27	2026-08-27	\N	2900000.00	2900000.00	NOT_PAID	ACTIVE	MONTHLY	5	f	0	0	ĐIỀU KHOẢN HỢP ĐỒNG THUÊ PHÒNG\n\n1. BÊN CHO THUÊ (Chủ nhà):\n- Cung cấp phòng ở đầy đủ tiện nghi theo thỏa thuận\n- Đảm bảo an ninh, an toàn cho khách thuê\n- Bảo trì, sửa chữa các hư hỏng do hao mòn tự nhiên\n\n2. BÊN THUÊ (Khách thuê):\n- Thanh toán đúng hạn tiền thuê và các chi phí khác\n- Sử dụng phòng đúng mục đích, giữ gìn vệ sinh\n- Không được cải tạo, sửa chữa phòng mà không có sự đồng ý\n- Báo cáo kịp thời các hư hỏng, sự cố\n\n3. ĐIỀU KHOẢN CHUNG:\n- Thời hạn hợp đồng: Từ ngày bắt đầu đến ngày kết thúc\n- Tiền cọc: Được hoàn trả khi kết thúc hợp đồng (trừ các khoản phát sinh)\n- Thanh toán: Hàng tháng vào ngày quy định\n- Điện, nước: Tính theo chỉ số đồng hồ và giá quy định\n- Phí dịch vụ: Theo thỏa thuận riêng\n\n4. CHẤM DỨT HỢP ĐỒNG:\n- Bên thuê có thể chấm dứt hợp đồng trước thời hạn với thông báo trước 30 ngày\n- Bên cho thuê có thể chấm dứt hợp đồng nếu vi phạm nghiêm trọng\n- Hoàn trả tiền cọc sau khi kiểm tra tình trạng phòng\n\n5. ĐIỀU KHOẢN KHÁC:\n- Hai bên cam kết thực hiện đúng các điều khoản đã thỏa thuận\n- Mọi tranh chấp sẽ được giải quyết thông qua thương lượng\n- Hợp đồng có hiệu lực kể từ ngày ký	\N		2026-05-27 02:40:04.996931+00	2026-05-27 02:41:04.683655+00	\N	\N	\N	\N	\N	\N	\N	\N	UNSIGNED
277227c0-b1a9-44d6-8ac5-5dc57b2eaf7f	659998c6-e8c1-4ae8-ba7e-4ebb8f454ec2	b3c9ada2-70d5-496d-a103-4cf3d7ecc21f	HD001	2026-05-30	2026-11-30	\N	1900000.00	500000.00	NOT_PAID	ACTIVE	MONTHLY	15	f	3600	4000	ĐIỀU KHOẢN HỢP ĐỒNG THUÊ PHÒNG\n\n1. BÊN CHO THUÊ (Chủ nhà):\n- Cung cấp phòng ở đầy đủ tiện nghi theo thỏa thuận\n- Đảm bảo an ninh, an toàn cho khách thuê\n- Bảo trì, sửa chữa các hư hỏng do hao mòn tự nhiên\n\n2. BÊN THUÊ (Khách thuê):\n- Thanh toán đúng hạn tiền thuê và các chi phí khác\n- Sử dụng phòng đúng mục đích, giữ gìn vệ sinh\n- Không được cải tạo, sửa chữa phòng mà không có sự đồng ý\n- Báo cáo kịp thời các hư hỏng, sự cố\n\n3. ĐIỀU KHOẢN CHUNG:\n- Thời hạn hợp đồng: Từ ngày bắt đầu đến ngày kết thúc\n- Tiền cọc: Được hoàn trả khi kết thúc hợp đồng (trừ các khoản phát sinh)\n- Thanh toán: Hàng tháng vào ngày quy định\n- Điện, nước: Tính theo chỉ số đồng hồ và giá quy định\n- Phí dịch vụ: Theo thỏa thuận riêng\n\n4. CHẤM DỨT HỢP ĐỒNG:\n- Bên thuê có thể chấm dứt hợp đồng trước thời hạn với thông báo trước 30 ngày\n- Bên cho thuê có thể chấm dứt hợp đồng nếu vi phạm nghiêm trọng\n- Hoàn trả tiền cọc sau khi kiểm tra tình trạng phòng\n\n5. ĐIỀU KHOẢN KHÁC:\n- Hai bên cam kết thực hiện đúng các điều khoản đã thỏa thuận\n- Mọi tranh chấp sẽ được giải quyết thông qua thương lượng\n- Hợp đồng có hiệu lực kể từ ngày ký	\N		2026-05-30 07:33:09.888747+00	2026-05-30 07:33:09.888747+00	\N	\N	\N	\N	\N	\N	\N	\N	UNSIGNED
cc4386ff-881d-4117-9c9c-0471e8b6c04f	738896ea-3b09-4cab-8f71-5437c3392998	cdbe66ce-3bf0-4023-b2c8-38ba477730f1	HD-10222-2026	2026-06-01	2027-06-01	\N	3000000.00	3000000.00	NOT_PAID	ACTIVE	MONTHLY	5	f	0	0	ĐIỀU KHOẢN HỢP ĐỒNG THUÊ PHÒNG\n\n1. BÊN CHO THUÊ (Chủ nhà):\n- Cung cấp phòng ở đầy đủ tiện nghi theo thỏa thuận\n- Đảm bảo an ninh, an toàn cho khách thuê\n- Bảo trì, sửa chữa các hư hỏng do hao mòn tự nhiên\n\n2. BÊN THUÊ (Khách thuê):\n- Thanh toán đúng hạn tiền thuê và các chi phí khác\n- Sử dụng phòng đúng mục đích, giữ gìn vệ sinh\n- Không được cải tạo, sửa chữa phòng mà không có sự đồng ý\n- Báo cáo kịp thời các hư hỏng, sự cố\n\n3. ĐIỀU KHOẢN CHUNG:\n- Thời hạn hợp đồng: Từ ngày bắt đầu đến ngày kết thúc\n- Tiền cọc: Được hoàn trả khi kết thúc hợp đồng (trừ các khoản phát sinh)\n- Thanh toán: Hàng tháng vào ngày quy định\n- Điện, nước: Tính theo chỉ số đồng hồ và giá quy định\n- Phí dịch vụ: Theo thỏa thuận riêng\n\n4. CHẤM DỨT HỢP ĐỒNG:\n- Bên thuê có thể chấm dứt hợp đồng trước thời hạn với thông báo trước 30 ngày\n- Bên cho thuê có thể chấm dứt hợp đồng nếu vi phạm nghiêm trọng\n- Hoàn trả tiền cọc sau khi kiểm tra tình trạng phòng\n\n5. ĐIỀU KHOẢN KHÁC:\n- Hai bên cam kết thực hiện đúng các điều khoản đã thỏa thuận\n- Mọi tranh chấp sẽ được giải quyết thông qua thương lượng\n- Hợp đồng có hiệu lực kể từ ngày ký	\N		2026-06-01 02:56:21.257644+00	2026-06-01 02:56:21.257644+00	\N	\N	\N	\N	\N	\N	\N	\N	UNSIGNED
0a0463eb-0069-4a6f-b421-70695eda5d14	1707dfeb-7942-4339-a171-bbf0f87d03a8	a6cab9bf-080a-4cca-b2a1-02b5df4aabfc	HD-PHONG-605-202606-538A18	2026-06-01	2026-09-01	\N	2500000.00	2500000.00	NOT_PAID	ACTIVE	MONTHLY	5	f	25565	300	ĐIỀU KHOẢN HỢP ĐỒNG THUÊ PHÒNG\n\n1. BÊN CHO THUÊ (Chủ nhà):\n- Cung cấp phòng ở đầy đủ tiện nghi theo thỏa thuận\n- Đảm bảo an ninh, an toàn cho khách thuê\n- Bảo trì, sửa chữa các hư hỏng do hao mòn tự nhiên\n\n2. BÊN THUÊ (Khách thuê):\n- Thanh toán đúng hạn tiền thuê và các chi phí khác\n- Sử dụng phòng đúng mục đích, giữ gìn vệ sinh\n- Không được cải tạo, sửa chữa phòng mà không có sự đồng ý\n- Báo cáo kịp thời các hư hỏng, sự cố\n\n3. ĐIỀU KHOẢN CHUNG:\n- Thời hạn hợp đồng: Từ ngày bắt đầu đến ngày kết thúc\n- Tiền cọc: Được hoàn trả khi kết thúc hợp đồng (trừ các khoản phát sinh)\n- Thanh toán: Hàng tháng vào ngày quy định\n- Điện, nước: Tính theo chỉ số đồng hồ và giá quy định\n- Phí dịch vụ: Theo thỏa thuận riêng\n\n4. CHẤM DỨT HỢP ĐỒNG:\n- Bên thuê có thể chấm dứt hợp đồng trước thời hạn với thông báo trước 30 ngày\n- Bên cho thuê có thể chấm dứt hợp đồng nếu vi phạm nghiêm trọng\n- Hoàn trả tiền cọc sau khi kiểm tra tình trạng phòng\n\n5. ĐIỀU KHOẢN KHÁC:\n- Hai bên cam kết thực hiện đúng các điều khoản đã thỏa thuận\n- Mọi tranh chấp sẽ được giải quyết thông qua thương lượng\n- Hợp đồng có hiệu lực kể từ ngày ký	\N		2026-06-01 19:31:31.961448+00	2026-06-01 19:31:31.961448+00	\N	\N	\N	\N	\N	\N	\N	\N	UNSIGNED
9057baa1-3318-4b5c-af06-131d349d706e	daaf7cf4-57c7-499e-8f8b-caf257c74bf0	a6cab9bf-080a-4cca-b2a1-02b5df4aabfc	HD-PHONG-504-202606-CBEF6B	2026-06-01	2026-09-01	\N	2500000.00	2500000.00	NOT_PAID	ACTIVE	MONTHLY	5	f	0	0	ĐIỀU KHOẢN HỢP ĐỒNG THUÊ PHÒNG\n\n1. BÊN CHO THUÊ (Chủ nhà):\n- Cung cấp phòng ở đầy đủ tiện nghi theo thỏa thuận\n- Đảm bảo an ninh, an toàn cho khách thuê\n- Bảo trì, sửa chữa các hư hỏng do hao mòn tự nhiên\n\n2. BÊN THUÊ (Khách thuê):\n- Thanh toán đúng hạn tiền thuê và các chi phí khác\n- Sử dụng phòng đúng mục đích, giữ gìn vệ sinh\n- Không được cải tạo, sửa chữa phòng mà không có sự đồng ý\n- Báo cáo kịp thời các hư hỏng, sự cố\n\n3. ĐIỀU KHOẢN CHUNG:\n- Thời hạn hợp đồng: Từ ngày bắt đầu đến ngày kết thúc\n- Tiền cọc: Được hoàn trả khi kết thúc hợp đồng (trừ các khoản phát sinh)\n- Thanh toán: Hàng tháng vào ngày quy định\n- Điện, nước: Tính theo chỉ số đồng hồ và giá quy định\n- Phí dịch vụ: Theo thỏa thuận riêng\n\n4. CHẤM DỨT HỢP ĐỒNG:\n- Bên thuê có thể chấm dứt hợp đồng trước thời hạn với thông báo trước 30 ngày\n- Bên cho thuê có thể chấm dứt hợp đồng nếu vi phạm nghiêm trọng\n- Hoàn trả tiền cọc sau khi kiểm tra tình trạng phòng\n\n5. ĐIỀU KHOẢN KHÁC:\n- Hai bên cam kết thực hiện đúng các điều khoản đã thỏa thuận\n- Mọi tranh chấp sẽ được giải quyết thông qua thương lượng\n- Hợp đồng có hiệu lực kể từ ngày ký	\N		2026-06-01 19:56:15.000766+00	2026-06-01 19:56:15.000766+00	\N	\N	\N	\N	\N	\N	\N	\N	UNSIGNED
a6de2592-9cfb-4d0a-8aa4-59cfb1f3d147	f7c95777-0fdc-4e30-8a54-f50e5ab72224	28073f55-d86b-4ff1-83d3-58b44808055f	HD-PHONG-401-202606-F38405	2026-06-10	2026-09-10	\N	2500000.00	2500000.00	NOT_PAID	ACTIVE	MONTHLY	5	f	1000	9000	ĐIỀU KHOẢN HỢP ĐỒNG THUÊ PHÒNG\n\n1. BÊN CHO THUÊ (Chủ nhà):\n- Cung cấp phòng ở đầy đủ tiện nghi theo thỏa thuận\n- Đảm bảo an ninh, an toàn cho khách thuê\n- Bảo trì, sửa chữa các hư hỏng do hao mòn tự nhiên\n\n2. BÊN THUÊ (Khách thuê):\n- Thanh toán đúng hạn tiền thuê và các chi phí khác\n- Sử dụng phòng đúng mục đích, giữ gìn vệ sinh\n- Không được cải tạo, sửa chữa phòng mà không có sự đồng ý\n- Báo cáo kịp thời các hư hỏng, sự cố\n\n3. ĐIỀU KHOẢN CHUNG:\n- Thời hạn hợp đồng: Từ ngày bắt đầu đến ngày kết thúc\n- Tiền cọc: Được hoàn trả khi kết thúc hợp đồng (trừ các khoản phát sinh)\n- Thanh toán: Hàng tháng vào ngày quy định\n- Điện, nước: Tính theo chỉ số đồng hồ và giá quy định\n- Phí dịch vụ: Theo thỏa thuận riêng\n\n4. CHẤM DỨT HỢP ĐỒNG:\n- Bên thuê có thể chấm dứt hợp đồng trước thời hạn với thông báo trước 30 ngày\n- Bên cho thuê có thể chấm dứt hợp đồng nếu vi phạm nghiêm trọng\n- Hoàn trả tiền cọc sau khi kiểm tra tình trạng phòng\n\n5. ĐIỀU KHOẢN KHÁC:\n- Hai bên cam kết thực hiện đúng các điều khoản đã thỏa thuận\n- Mọi tranh chấp sẽ được giải quyết thông qua thương lượng\n- Hợp đồng có hiệu lực kể từ ngày ký	\N		2026-06-10 02:14:50.460967+00	2026-06-10 02:14:50.460967+00	\N	\N	\N	\N	\N	\N	\N	\N	UNSIGNED
58d6ac23-3ff3-4065-b82a-17c408fee39b	420f922c-36c0-4b17-a74c-f08262c6f30f	28073f55-d86b-4ff1-83d3-58b44808055f	HD008	2026-06-03	2027-06-03	\N	2500000.00	2500000.00	NOT_PAID	ACTIVE	YEARLY	5	f	10000	1999	HOP DONG THUE PHONG\n\nMa hop dong: HD008\nToa nha: Lamark123323\nPhong: Phòng 101\nKhach thue dai dien: Trần Triệu Vỹadsad\nThoi han: 2026-06-03 den 2027-06-03\nGia thue: 2500000.00\nTien coc: 2500000.00\nNgay thanh toan hang thang: 5\n\nNoi dung nay duoc sinh tu template default-v1 de phuc vu buoc xem truoc hop dong.\n	\N		2026-06-03 13:36:00.524904+00	2026-06-08 03:55:33.375311+00	\N	default-v1	2026-06-08 03:55:33.48422+00	\N	\N	\N	\N	\N	UNSIGNED
9d9c0239-7832-4607-b4a5-8db5cdb37a3f	16899884-b3a0-4e2f-a6f6-981834f39065	76bcede3-1bda-494a-8193-974874f25f8f	HD-PHONG-402-202606-465086	2026-06-10	2026-09-10	\N	2500000.00	2500000.00	NOT_PAID	ACTIVE	MONTHLY	5	f	9000	9000	ĐIỀU KHOẢN HỢP ĐỒNG THUÊ PHÒNG\n\n1. BÊN CHO THUÊ (Chủ nhà):\n- Cung cấp phòng ở đầy đủ tiện nghi theo thỏa thuận\n- Đảm bảo an ninh, an toàn cho khách thuê\n- Bảo trì, sửa chữa các hư hỏng do hao mòn tự nhiên\n\n2. BÊN THUÊ (Khách thuê):\n- Thanh toán đúng hạn tiền thuê và các chi phí khác\n- Sử dụng phòng đúng mục đích, giữ gìn vệ sinh\n- Không được cải tạo, sửa chữa phòng mà không có sự đồng ý\n- Báo cáo kịp thời các hư hỏng, sự cố\n\n3. ĐIỀU KHOẢN CHUNG:\n- Thời hạn hợp đồng: Từ ngày bắt đầu đến ngày kết thúc\n- Tiền cọc: Được hoàn trả khi kết thúc hợp đồng (trừ các khoản phát sinh)\n- Thanh toán: Hàng tháng vào ngày quy định\n- Điện, nước: Tính theo chỉ số đồng hồ và giá quy định\n- Phí dịch vụ: Theo thỏa thuận riêng\n\n4. CHẤM DỨT HỢP ĐỒNG:\n- Bên thuê có thể chấm dứt hợp đồng trước thời hạn với thông báo trước 30 ngày\n- Bên cho thuê có thể chấm dứt hợp đồng nếu vi phạm nghiêm trọng\n- Hoàn trả tiền cọc sau khi kiểm tra tình trạng phòng\n\n5. ĐIỀU KHOẢN KHÁC:\n- Hai bên cam kết thực hiện đúng các điều khoản đã thỏa thuận\n- Mọi tranh chấp sẽ được giải quyết thông qua thương lượng\n- Hợp đồng có hiệu lực kể từ ngày ký	\N		2026-06-10 02:47:04.367599+00	2026-06-10 02:47:04.367599+00	\N	\N	\N	\N	\N	\N	\N	\N	UNSIGNED
7667b075-29e2-44f0-ae53-d31df1affb7f	e6ae979f-35fd-4da4-bcc3-f76bfdf71d03	57ff6175-493c-49ab-98c6-7663c1a8c062	HD-P103-202606-5EB367	2026-06-13	2026-12-13	\N	2000000.00	499997.00	NOT_PAID	ACTIVE	MONTHLY	15	f	51510	661510	ĐIỀU KHOẢN HỢP ĐỒNG THUÊ PHÒNG\n\n1. BÊN CHO THUÊ (Chủ nhà):\n- Cung cấp phòng ở đầy đủ tiện nghi theo thỏa thuận\n- Đảm bảo an ninh, an toàn cho khách thuê\n- Bảo trì, sửa chữa các hư hỏng do hao mòn tự nhiên\n\n2. BÊN THUÊ (Khách thuê):\n- Thanh toán đúng hạn tiền thuê và các chi phí khác\n- Sử dụng phòng đúng mục đích, giữ gìn vệ sinh\n- Không được cải tạo, sửa chữa phòng mà không có sự đồng ý\n- Báo cáo kịp thời các hư hỏng, sự cố\n\n3. ĐIỀU KHOẢN CHUNG:\n- Thời hạn hợp đồng: Từ ngày bắt đầu đến ngày kết thúc\n- Tiền cọc: Được hoàn trả khi kết thúc hợp đồng (trừ các khoản phát sinh)\n- Thanh toán: Hàng tháng vào ngày quy định\n- Điện, nước: Tính theo chỉ số đồng hồ và giá quy định\n- Phí dịch vụ: Theo thỏa thuận riêng\n\n4. CHẤM DỨT HỢP ĐỒNG:\n- Bên thuê có thể chấm dứt hợp đồng trước thời hạn với thông báo trước 30 ngày\n- Bên cho thuê có thể chấm dứt hợp đồng nếu vi phạm nghiêm trọng\n- Hoàn trả tiền cọc sau khi kiểm tra tình trạng phòng\n\n5. ĐIỀU KHOẢN KHÁC:\n- Hai bên cam kết thực hiện đúng các điều khoản đã thỏa thuận\n- Mọi tranh chấp sẽ được giải quyết thông qua thương lượng\n- Hợp đồng có hiệu lực kể từ ngày ký	\N		2026-06-13 15:53:57.322041+00	2026-06-13 15:53:57.322041+00	\N	\N	\N	\N	\N	\N	\N	\N	UNSIGNED
\.

--
-- Data for Name: hoa_don; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."hoa_don" ("id", "hop_dong_id", "phong_id", "khach_thue_id", "ma_hoa_don", "ky_nam", "ky_thang", "tu_ngay", "den_ngay", "so_du_dau_ky", "tong_tien_phat_sinh", "tong_tien", "da_tra", "trang_thai", "han_tra", "ngay_lap_hoa_don", "ghi_chu", "tao_luc", "cap_nhat_luc", "xoa_luc", "auto_generated", "generation_batch_id", "source_schedule_id", "version") FROM stdin;
967cede6-4a9c-4597-80e2-1c7e935ed67f	f5075e49-2b06-4750-834e-e157f7e09a82	48ef0756-c05a-44fa-b4b0-d3f249f564d0	fba2a7bd-082f-47f7-b0cc-3c53e79352c4	HD20260524913	2026	5	2026-05-01	2026-05-31	0.00	5265000.00	5265000.00	5265000.00	PAID	2026-05-31	2026-05-24 06:16:27.352463+00		2026-05-24 06:16:27.355985+00	2026-05-26 18:21:50.715878+00	\N	\N	\N	\N	0
c4d29bf7-18cd-4b37-93ad-1f413583193a	cc4386ff-881d-4117-9c9c-0471e8b6c04f	738896ea-3b09-4cab-8f71-5437c3392998	cdbe66ce-3bf0-4023-b2c8-38ba477730f1	HD20260601045	2026	6	2026-06-01	2026-06-30	0.00	3508500.00	3508500.00	3508500.00	PAID	2026-07-05	2026-06-01 03:44:24.542626+00		2026-06-01 03:44:24.544086+00	2026-06-01 03:45:00.759498+00	\N	\N	\N	\N	0
3f09457f-c8ef-4eeb-b1ff-0959ac97417c	9057baa1-3318-4b5c-af06-131d349d706e	daaf7cf4-57c7-499e-8f8b-caf257c74bf0	a6cab9bf-080a-4cca-b2a1-02b5df4aabfc	HD20260602828	2026	6	2026-06-01	2026-06-30	0.00	3150000.00	3150000.00	3150000.00	PAID	2026-06-02	2026-06-02 02:13:37.635057+00		2026-06-02 02:13:37.644867+00	2026-06-02 02:13:37.374642+00	\N	\N	\N	\N	0
\.

--
-- Data for Name: bank_transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."bank_transaction" ("id", "nha_tro_id", "hoa_don_id", "so_tien", "noi_dung_chuyen_khoan", "ma_giao_dich", "ngan_hang", "thoi_gian_giao_dich", "payload", "da_doi_soat", "tao_luc") FROM stdin;
\.

--
-- Data for Name: dich_vu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."dich_vu" ("id", "chu_tro_id", "ten_dich_vu", "loai_tinh_phi", "don_vi", "don_gia_mac_dinh", "bat_buoc", "tao_luc", "cap_nhat_luc") FROM stdin;
d1111111-1111-1111-1111-111111111111	00b4c56f-45fa-49a2-874b-601bc77dcb65	Điện	PER_UNIT	kWh	3500.00	t	2026-05-24 03:14:22.878972+00	2026-05-24 03:14:22.878972+00
d3333333-3333-3333-3333-333333333333	00b4c56f-45fa-49a2-874b-601bc77dcb65	Wifi	PER_ROOM	phòng	100000.00	f	2026-05-24 03:14:22.878972+00	2026-05-24 03:14:22.878972+00
d4444444-4444-4444-4444-444444444444	00b4c56f-45fa-49a2-874b-601bc77dcb65	Rác	PER_PERSON	người	30000.00	t	2026-05-24 03:14:22.878972+00	2026-05-24 03:14:22.878972+00
b155d348-c932-48d1-94d0-e01fe0cadd0b	00b4c56f-45fa-49a2-874b-601bc77dcb65	Máy lạnh	PER_ROOM	phòng	300000.00	f	2026-05-24 03:40:52.452403+00	2026-05-24 03:40:52.452403+00
e3cf1e38-b185-4432-bd83-7739802d27fa	00b4c56f-45fa-49a2-874b-601bc77dcb65	Máy giặt	PER_ROOM	phòng	150000.00	f	2026-05-24 03:40:52.452403+00	2026-05-24 03:40:52.452403+00
02b6956b-2a72-4524-9afc-d83f9e2a2e6a	00b4c56f-45fa-49a2-874b-601bc77dcb65	Tủ lạnh	PER_ROOM	phòng	100000.00	f	2026-05-24 03:40:52.452403+00	2026-05-24 03:40:52.452403+00
f6a0428c-72c8-459f-9e91-1dda15bbfc08	00b4c56f-45fa-49a2-874b-601bc77dcb65	Bình nóng lạnh	PER_ROOM	phòng	120000.00	f	2026-05-24 03:40:52.452403+00	2026-05-24 03:40:52.452403+00
cee87b11-9d25-48d9-8954-a9ab0bcb09b9	00b4c56f-45fa-49a2-874b-601bc77dcb65	Giường nệm	PER_ROOM	phòng	200000.00	f	2026-05-24 03:40:52.452403+00	2026-05-24 03:40:52.452403+00
a4fd844a-f876-416b-b54c-2323ae6d251e	00b4c56f-45fa-49a2-874b-601bc77dcb65	Tủ quần áo	PER_ROOM	phòng	100000.00	f	2026-05-24 03:40:52.452403+00	2026-05-24 03:40:52.452403+00
a2374bda-33e9-4390-aaff-e6dcbcea1e97	00b4c56f-45fa-49a2-874b-601bc77dcb65	Bàn ghế	PER_ROOM	phòng	100000.00	f	2026-05-24 03:40:52.452403+00	2026-05-24 03:40:52.452403+00
c4f8ed3c-2fb0-47f3-ac37-6601001dec5f	00b4c56f-45fa-49a2-874b-601bc77dcb65	Bếp nấu ăn	PER_ROOM	phòng	150000.00	f	2026-05-24 03:40:52.452403+00	2026-05-24 03:40:52.452403+00
13d910a9-7396-468f-9274-c0767cbd562a	00b4c56f-45fa-49a2-874b-601bc77dcb65	Kệ bếp	PER_ROOM	phòng	50000.00	f	2026-05-24 03:40:52.452403+00	2026-05-24 03:40:52.452403+00
192687dd-5c6b-41f8-8c3a-bec73dfdb671	00b4c56f-45fa-49a2-874b-601bc77dcb65	Ban công	PER_ROOM	phòng	200000.00	f	2026-05-24 03:40:52.452403+00	2026-05-24 03:40:52.452403+00
c24f4134-298a-496b-9fa9-a6acfdb0e4bb	00b4c56f-45fa-49a2-874b-601bc77dcb65	Dọn vệ sinh	PER_ROOM	phòng	50000.00	f	2026-05-24 03:40:52.452403+00	2026-05-24 03:40:52.452403+00
a0ad6557-8c87-4502-9f62-85a863557f5c	00b4c56f-45fa-49a2-874b-601bc77dcb65	Giặt sấy	PER_PERSON	người	80000.00	f	2026-05-24 03:40:52.452403+00	2026-05-24 03:40:52.452403+00
9b741583-2afc-47bd-ab89-6424e95179cf	00b4c56f-45fa-49a2-874b-601bc77dcb65	Bảo trì sửa chữa	PER_ROOM	phòng	50000.00	f	2026-05-24 03:40:52.452403+00	2026-05-24 03:40:52.452403+00
b3cb85f0-6ddf-4056-9b81-78a13dd33211	00b4c56f-45fa-49a2-874b-601bc77dcb65	Camera 24/7	PER_ROOM	phòng	30000.00	f	2026-05-24 03:40:52.452403+00	2026-05-24 03:40:52.452403+00
dca7b3c9-d37f-4173-85bb-fe1e34570343	00b4c56f-45fa-49a2-874b-601bc77dcb65	Vân tay thẻ từ	PER_ROOM	phòng	10000.00	t	2026-05-24 03:40:52.452403+00	2026-05-24 15:28:45.866537+00
c06a40af-b003-475d-8ccf-9a74a4625be4	00b4c56f-45fa-49a2-874b-601bc77dcb65	Giữ xe	PER_PERSON	xe	10000.00	t	2026-05-24 03:40:52.452403+00	2026-05-24 15:28:57.421414+00
d2222222-2222-2222-2222-222222222222	00b4c56f-45fa-49a2-874b-601bc77dcb65	Nước	PER_PERSON	người	50000.00	t	2026-05-24 03:14:22.878972+00	2026-05-24 15:29:06.503184+00
4622ac10-01c6-4dc4-97e6-be8299ded976	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	Điện	FIXED	kWh	4000.00	t	2026-05-25 02:33:56.513043+00	2026-05-25 02:33:56.513043+00
c89714a7-e371-425f-8df4-7ad6b1ca6549	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	DV01	FIXED	kWh	50000.00	t	2026-05-30 04:04:28.143824+00	2026-05-31 04:29:04.360514+00
\.

--
-- Data for Name: cau_hinh_gia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."cau_hinh_gia" ("id", "nha_tro_id", "dich_vu_id", "loai", "ten_hien_thi", "loai_tinh_phi", "don_gia", "hieu_luc_tu", "hieu_luc_den", "dang_ap_dung", "tao_luc", "cap_nhat_luc") FROM stdin;
9ce1b8f8-3088-41eb-bf44-75cc2870b5a7	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	d1111111-1111-1111-1111-111111111111	ELECTRICITY	Tiền Điện	PER_UNIT	3800.00	2026-01-01	\N	t	2026-05-24 03:34:54.071595+00	2026-05-24 03:34:54.071595+00
5aafcd60-2418-4ab3-95ab-65c5ec2e2d78	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	c24f4134-298a-496b-9fa9-a6acfdb0e4bb	CLEANING	Dọn vệ sinh	PER_ROOM	50000.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 03:41:51.586681+00
e415e434-5500-4503-8aab-43ea403dc65d	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	a0ad6557-8c87-4502-9f62-85a863557f5c	LAUNDRY	Giặt sấy	PER_PERSON	80000.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 03:41:51.586681+00
492b5de7-0bd8-4542-8b56-512f82a769a8	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	9b741583-2afc-47bd-ab89-6424e95179cf	MAINTENANCE	Bảo trì sửa chữa	PER_ROOM	50000.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 03:41:51.586681+00
3abdb570-b5d4-4a86-b4c1-1705d004ea81	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	d2222222-2222-2222-2222-222222222222	WATER	Tiền Nước	PER_PERSON	50000.00	2026-01-01	\N	t	2026-05-24 03:34:54.071595+00	2026-05-24 04:49:25.117881+00
40dc34ef-e9ef-432f-9afc-90a932e76905	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	a4fd844a-f876-416b-b54c-2323ae6d251e	WARDROBE	Tủ quần áo	PER_ROOM	0.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 04:49:50.351301+00
0f60bb41-1c44-404a-b399-a5ed001aa049	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	d3333333-3333-3333-3333-333333333333	INTERNET	Wifi	PER_ROOM	100000.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 04:49:57.100483+00
25ea9fd9-caea-43ab-ba25-5a3ce82e2412	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	cee87b11-9d25-48d9-8954-a9ab0bcb09b9	BED	Giường nệm	PER_ROOM	0.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 04:50:02.972711+00
4394b995-a4d1-4d1c-88ce-dbd375168544	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	c06a40af-b003-475d-8ccf-9a74a4625be4	PARKING	Giữ xe	PER_PERSON	10000.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 04:50:11.015485+00
45ed93f2-2702-41e7-b842-7988f429b673	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	13d910a9-7396-468f-9274-c0767cbd562a	KITCHEN_SHELF	Kệ bếp	PER_ROOM	0.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 04:50:16.093623+00
e27702fa-4441-4193-9724-cab6127e0d87	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	e3cf1e38-b185-4432-bd83-7739802d27fa	WASHING_MACHINE	Máy giặt	PER_ROOM	100000.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 04:52:00.440333+00
6d31ca17-845a-4ae3-8953-9c0b6bdc50ff	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	f6a0428c-72c8-459f-9e91-1dda15bbfc08	WATER_HEATER	Bình nóng lạnh	PER_ROOM	0.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 04:50:33.880204+00
800ab5b5-871f-4583-b769-00b633c0ae9a	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	a2374bda-33e9-4390-aaff-e6dcbcea1e97	TABLE_CHAIR	Bàn ghế	PER_ROOM	0.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 04:50:38.062764+00
8960ab57-db83-4f1e-a66d-daf1338d81da	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	d4444444-4444-4444-4444-444444444444	TRASH	Rác	PER_PERSON	10000.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 04:51:03.680762+00
ade1ba0b-6628-4480-b90b-283ca64ea2fe	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	02b6956b-2a72-4524-9afc-d83f9e2a2e6a	REFRIGERATOR	Tủ lạnh	PER_ROOM	100000.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 04:51:31.412194+00
bf79f210-43a3-44cc-a96e-af9b22a5e9d5	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	c4f8ed3c-2fb0-47f3-ac37-6601001dec5f	KITCHEN	Bếp nấu ăn	PER_ROOM	0.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 04:51:35.09495+00
cdf7510c-d9d8-4721-9fd9-9874c9109ee7	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	192687dd-5c6b-41f8-8c3a-bec73dfdb671	BALCONY	Ban công	PER_ROOM	0.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 04:51:50.313191+00
e7ea672d-938b-4337-828d-fad025c270fc	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	b3cb85f0-6ddf-4056-9b81-78a13dd33211	SECURITY_CAMERA	Camera 24/7	PER_ROOM	0.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 04:52:11.135354+00
f76a7721-9558-46e2-9df4-e8da19459a70	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	dca7b3c9-d37f-4173-85bb-fe1e34570343	SMART_LOCK	Vân tay thẻ từ	PER_ROOM	10000.00	2026-01-01	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 04:52:16.407037+00
16713b5c-2399-43d4-ab34-6e1e744c70cf	4a7e8a51-a55e-4d14-bc58-368ebf3d4f24	b155d348-c932-48d1-94d0-e01fe0cadd0b	AIR_CONDITIONER	Máy lạnh	PER_ROOM	0.00	2026-01-15	\N	t	2026-05-24 03:41:51.586681+00	2026-05-24 06:16:50.86049+00
43657862-6658-4b9f-9ad7-d4e0b077acc4	b0eb16f8-1be0-4515-8beb-0e09768d833a	\N	OTHER	Máy lạnh	FIXED	100000.00	2026-05-24	\N	t	2026-05-24 06:18:21.494359+00	2026-05-24 06:18:36.721337+00
dbd82777-3e3b-4e21-bd1a-c6e893f046f9	3c21cb2b-21aa-428d-9991-0c320a951eef	\N	ELECTRICITY	Tiền Điện	FIXED	3500.00	2026-05-27	\N	t	2026-05-27 02:15:01.419214+00	2026-05-27 02:15:01.419214+00
22740db5-ebfb-4fa7-b5bb-a0b58f092fb3	3c21cb2b-21aa-428d-9991-0c320a951eef	\N	WATER	Tiền Nước	PER_PERSON	50000.00	2026-05-27	\N	t	2026-05-27 02:15:20.605255+00	2026-05-27 02:15:20.605255+00
c1111ed2-f2e3-4591-83cb-75434bcdcd3a	3c21cb2b-21aa-428d-9991-0c320a951eef	\N	INTERNET	Tiền Wifi	PER_ROOM	100000.00	2026-05-27	\N	t	2026-05-27 02:15:37.236688+00	2026-05-27 02:15:37.236688+00
67fc56a3-6730-4d15-b3af-cc855bdaf343	3c21cb2b-21aa-428d-9991-0c320a951eef	\N	GARBAGE	Tiền Rác	PER_ROOM	10000.00	2026-05-27	\N	t	2026-05-27 02:15:58.509541+00	2026-05-27 02:15:58.509541+00
7e80ff5e-6f67-489d-8716-e83a4739d5a9	0189a7a5-857c-4cd9-b000-3ea75f7120c8	\N	MAINTENANCE	Chi phí bảo trì trang thiết bị	FIXED	100000.00	2026-06-13	2026-06-15	t	2026-06-13 15:57:20.108459+00	2026-06-13 15:57:20.108459+00
\.

--
-- Data for Name: chi_so_dien_nuoc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."chi_so_dien_nuoc" ("id", "phong_id", "hop_dong_id", "loai", "ky_nam", "ky_thang", "ngay_ghi", "chi_so_cu", "chi_so_moi", "anh_dong_ho", "nguoi_ghi_id", "trang_thai", "ghi_chu", "tao_luc", "cap_nhat_luc") FROM stdin;
617bab35-2e22-4e3c-834f-a7da282e8dac	ac58f1da-64bb-4524-a104-42be15b02f3b	\N	ELECTRICITY	2026	5	2026-05-25	0	100000	\N	\N	DRAFT		2026-05-25 02:35:08.188247+00	2026-05-25 02:35:08.188247+00
62236eb3-ba83-4b9b-8b0b-ff6460a88a71	738896ea-3b09-4cab-8f71-5437c3392998	cc4386ff-881d-4117-9c9c-0471e8b6c04f	ELECTRICITY	2026	6	2026-06-30	9	40	\N	\N	BILLED	\N	2026-06-01 03:44:24.656614+00	2026-06-01 03:44:24.656614+00
e726e6b8-8c39-4be2-9db2-83e1704c6627	738896ea-3b09-4cab-8f71-5437c3392998	cc4386ff-881d-4117-9c9c-0471e8b6c04f	WATER	2026	6	2026-06-30	2	9	\N	\N	BILLED	\N	2026-06-01 03:44:25.360234+00	2026-06-01 03:44:25.360234+00
b43be140-1333-40cb-96ad-93204ae5cbd5	daaf7cf4-57c7-499e-8f8b-caf257c74bf0	9057baa1-3318-4b5c-af06-131d349d706e	ELECTRICITY	2026	6	2026-06-30	19	119	\N	\N	BILLED	\N	2026-06-02 02:13:38.076745+00	2026-06-02 02:13:38.076745+00
86ea52e1-392b-4789-aa1c-37e118989953	daaf7cf4-57c7-499e-8f8b-caf257c74bf0	9057baa1-3318-4b5c-af06-131d349d706e	WATER	2026	6	2026-06-30	15	20	\N	\N	BILLED	\N	2026-06-02 02:13:38.912551+00	2026-06-02 02:13:38.912551+00
\.

--
-- Data for Name: su_co; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."su_co" ("id", "phong_id", "khach_thue_id", "nguoi_bao_id", "tieu_de", "mo_ta", "loai_su_co", "uu_tien", "trang_thai", "nguoi_phu_trach_id", "chi_phi_sua_chua", "tinh_vao_hoa_don", "ghi_chu_chu_nha", "giai_quyet_luc", "tao_luc", "cap_nhat_luc") FROM stdin;
b763fba3-b6cd-4163-9429-08cbbb229426	f776bab1-2a8e-411e-823d-fa16270da89e	625c3321-ab04-4330-9e34-2a4458635624	00b4c56f-45fa-49a2-874b-601bc77dcb65	Codex test khong anh	Tao su co khong upload anh	dien_nuoc	trung_binh	PENDING	\N	0.00	f	\N	\N	2026-05-30 02:56:08.665901+00	2026-05-30 02:56:08.665901+00
af6ecffe-b9c5-473d-a9d6-61331cbd0756	f776bab1-2a8e-411e-823d-fa16270da89e	625c3321-ab04-4330-9e34-2a4458635624	00b4c56f-45fa-49a2-874b-601bc77dcb65	Codex test co anh	Tao su co voi mot anh URL da co	noi_that	cao	PENDING	\N	0.00	f	\N	\N	2026-05-30 02:56:10.341743+00	2026-05-30 02:56:10.341743+00
255b3ed5-7381-45d5-825c-8236b60f01e2	8f54a087-577a-476b-8c74-cb4e6d0c35f0	\N	00b4c56f-45fa-49a2-874b-601bc77dcb65	Codex test phong trong	Tao su co cho phong chua co khach thue	khac	thap	PENDING	\N	0.00	f	\N	\N	2026-05-30 02:56:31.393138+00	2026-05-30 02:56:31.393138+00
c68fc8e4-3746-4d98-ab4f-ca5558fdab80	f776bab1-2a8e-411e-823d-fa16270da89e	625c3321-ab04-4330-9e34-2a4458635624	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	QA tao su co khong anh	Kiem tra tao su co khong anh tu Codex	dien_nuoc	trung_binh	PENDING	\N	0.00	f	\N	\N	2026-05-30 03:42:42.984053+00	2026-05-30 03:42:42.984053+00
e4c9b92a-2365-41aa-bba3-4163bf1c4878	f776bab1-2a8e-411e-823d-fa16270da89e	625c3321-ab04-4330-9e34-2a4458635624	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	QA tao su co co anh	Kiem tra tao su co co 1 anh tu Codex	noi_that	cao	PENDING	\N	0.00	f	\N	\N	2026-05-30 03:42:44.102834+00	2026-05-30 03:42:44.102834+00
49c55f0a-4c32-40af-97d9-1b64dc801a5c	8f54a087-577a-476b-8c74-cb4e6d0c35f0	\N	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	QA phong chua co khach thue	Kiem tra tao su co phong chua co khach thue	khac	thap	PENDING	\N	0.00	f	\N	\N	2026-05-30 03:42:45.070253+00	2026-05-30 03:42:45.070253+00
bc7a078a-48b9-489e-b996-febe87075f51	747f8d83-d8c2-4e69-8091-36ca3ec77b1c	05bdeac0-c77e-437a-bcb4-ebf97d5c8157	91e602be-25b8-4fd4-9769-b307cd9af888	QA issue updated 103731	Leak fixed	dien_nuoc	trung_binh	CANCELLED	\N	0.00	f	\N	\N	2026-05-31 03:37:39.180441+00	2026-05-31 03:37:10.132384+00
9e5bccfd-d110-43da-aefd-1ed0db3ef7b3	745313e9-0ead-412a-8b5f-8159a6c7b89f	\N	91e602be-25b8-4fd4-9769-b307cd9af888	QA cancel incident 111119	QA cancel flow	dien_nuoc	thap	CANCELLED	\N	0.00	f	\N	\N	2026-05-31 04:11:22.700981+00	2026-05-31 04:10:52.665442+00
\.

--
-- Data for Name: chi_tiet_hoa_don; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."chi_tiet_hoa_don" ("id", "hoa_don_id", "dich_vu_id", "chi_so_dien_nuoc_id", "su_co_id", "loai", "mo_ta", "so_luong", "don_gia", "thanh_tien", "tao_luc") FROM stdin;
56d85c76-bec8-498d-9ca5-a4211b8fc329	967cede6-4a9c-4597-80e2-1c7e935ed67f	\N	\N	\N	ROOM	Tien phong	1.00	3000000.00	3000000.00	2026-05-24 06:16:27.364564+00
21242f56-0e83-455f-a912-23ce2f275617	967cede6-4a9c-4597-80e2-1c7e935ed67f	\N	\N	\N	ELECTRICITY	Tien dien	1.00	105000.00	105000.00	2026-05-24 06:16:27.364564+00
e4c46800-5c5d-4a28-98f2-af2e126b6f76	967cede6-4a9c-4597-80e2-1c7e935ed67f	\N	\N	\N	WATER	Tien nuoc	1.00	2000000.00	2000000.00	2026-05-24 06:16:27.364564+00
02035407-e93d-40ad-ac85-98aa55091d04	967cede6-4a9c-4597-80e2-1c7e935ed67f	d3333333-3333-3333-3333-333333333333	\N	\N	SERVICE	Wifi	1.00	100000.00	100000.00	2026-05-24 06:16:27.364564+00
823dcce3-b5ff-4dbc-adc3-224be6bff4d9	967cede6-4a9c-4597-80e2-1c7e935ed67f	d4444444-4444-4444-4444-444444444444	\N	\N	SERVICE	Rác	2.00	30000.00	60000.00	2026-05-24 06:16:27.364564+00
c06117d1-4a41-4539-9e22-bbced59eebee	c4d29bf7-18cd-4b37-93ad-1f413583193a	\N	\N	\N	ROOM	Tiền phòng	1.00	3000000.00	3000000.00	2026-06-01 03:44:26.347911+00
9521f75a-0f21-4162-8300-2600bb9e8381	c4d29bf7-18cd-4b37-93ad-1f413583193a	\N	62236eb3-ba83-4b9b-8b0b-ff6460a88a71	\N	ELECTRICITY	Tiền điện 9-40	31.00	3500.00	108500.00	2026-06-01 03:44:26.347911+00
766c4f1d-54e7-480d-a3b1-fdadd7dd7800	c4d29bf7-18cd-4b37-93ad-1f413583193a	\N	e726e6b8-8c39-4be2-9db2-83e1704c6627	\N	WATER	Tiền nước 2-9	7.00	50000.00	350000.00	2026-06-01 03:44:26.347911+00
9cbcd3fe-7113-4e10-be55-8bb916b8ceec	c4d29bf7-18cd-4b37-93ad-1f413583193a	c06a40af-b003-475d-8ccf-9a74a4625be4	\N	\N	SERVICE	Giữ xe	1.00	10000.00	10000.00	2026-06-01 03:44:26.347911+00
553024d8-6077-494a-bef0-181f9edbc652	c4d29bf7-18cd-4b37-93ad-1f413583193a	d4444444-4444-4444-4444-444444444444	\N	\N	SERVICE	Rác	1.00	30000.00	30000.00	2026-06-01 03:44:26.347911+00
eb669060-a8fe-433a-8916-f802195b2755	c4d29bf7-18cd-4b37-93ad-1f413583193a	dca7b3c9-d37f-4173-85bb-fe1e34570343	\N	\N	SERVICE	Vân tay thẻ từ	1.00	10000.00	10000.00	2026-06-01 03:44:26.347911+00
dd8c2bc3-7d05-4f28-b592-4bd78c2fe8b6	3f09457f-c8ef-4eeb-b1ff-0959ac97417c	\N	\N	\N	ROOM	Tiền phòng	1.00	2500000.00	2500000.00	2026-06-02 02:13:39.783946+00
f685edd8-50d9-40c3-8506-e284b5947f8f	3f09457f-c8ef-4eeb-b1ff-0959ac97417c	\N	b43be140-1333-40cb-96ad-93204ae5cbd5	\N	ELECTRICITY	Tiền điện 19-119	100.00	3500.00	350000.00	2026-06-02 02:13:39.783946+00
24957e7e-08ca-4240-ac1f-1fa09beb5361	3f09457f-c8ef-4eeb-b1ff-0959ac97417c	\N	86ea52e1-392b-4789-aa1c-37e118989953	\N	WATER	Tiền nước 15-20	5.00	50000.00	250000.00	2026-06-02 02:13:39.783946+00
553987fc-2081-412e-82b9-3275fe5d1a55	3f09457f-c8ef-4eeb-b1ff-0959ac97417c	c06a40af-b003-475d-8ccf-9a74a4625be4	\N	\N	SERVICE	Giữ xe	1.00	10000.00	10000.00	2026-06-02 02:13:39.786037+00
f785144f-5cde-4e13-bf6d-02b8c9e6b4ff	3f09457f-c8ef-4eeb-b1ff-0959ac97417c	d4444444-4444-4444-4444-444444444444	\N	\N	SERVICE	Rác	1.00	30000.00	30000.00	2026-06-02 02:13:39.786037+00
cf4703fb-6a9f-4143-b2e3-13bfe555ffbc	3f09457f-c8ef-4eeb-b1ff-0959ac97417c	dca7b3c9-d37f-4173-85bb-fe1e34570343	\N	\N	SERVICE	Vân tay thẻ từ	1.00	10000.00	10000.00	2026-06-02 02:13:39.786037+00
\.

--
-- Data for Name: chu_tro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."chu_tro" ("id", "nguoi_dung_id", "ten_cong_ty", "so_cccd", "ma_so_thue", "so_tai_khoan", "da_xac_minh", "tao_luc", "cap_nhat_luc", "xoa_luc") FROM stdin;
7a8efd24-8c91-4368-b942-e1c10e5aa182	00b4c56f-45fa-49a2-874b-601bc77dcb65	CTY TNHH 	066206004084	00000000	0369963725	t	2026-05-23 17:51:44+00	2026-05-23 17:51:46.995376+00	\N
\.

--
-- Data for Name: contract_signature; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."contract_signature" ("id", "ip_address", "signature_image_url", "signed_at", "signer_id", "signer_role", "user_agent", "hop_dong_id") FROM stdin;
\.

--
-- Data for Name: dat_coc_phong; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."dat_coc_phong" ("id", "phong_id", "khach_thue_id", "hop_dong_id", "so_tien_coc", "ngay_dat_coc", "ngay_du_kien_vao", "trang_thai", "ghi_chu", "tao_luc", "cap_nhat_luc") FROM stdin;
\.

--
-- Data for Name: dich_vu_hop_dong; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."dich_vu_hop_dong" ("id", "hop_dong_id", "dich_vu_id", "loai_tinh_phi", "don_gia_ap_dung", "so_luong", "bat_dau_tu", "ket_thuc_luc", "tao_luc") FROM stdin;
150e511d-50c0-417b-a7b0-b1bb72cebb78	f5075e49-2b06-4750-834e-e157f7e09a82	d1111111-1111-1111-1111-111111111111	PER_UNIT	3500.00	1.00	2026-01-01	\N	2026-05-24 03:15:34.210606+00
3d4933f8-9cf7-42d7-bf5f-e7d32310297c	f5075e49-2b06-4750-834e-e157f7e09a82	d2222222-2222-2222-2222-222222222222	PER_PERSON	100000.00	2.00	2026-01-01	\N	2026-05-24 03:15:34.210606+00
482e3185-95ac-4112-b695-7cf8447a547a	f5075e49-2b06-4750-834e-e157f7e09a82	d3333333-3333-3333-3333-333333333333	PER_ROOM	100000.00	1.00	2026-01-01	\N	2026-05-24 03:15:34.210606+00
babfa5f5-1e03-45e2-af62-94d807b9b971	f5075e49-2b06-4750-834e-e157f7e09a82	d4444444-4444-4444-4444-444444444444	PER_PERSON	30000.00	2.00	2026-01-01	\N	2026-05-24 03:15:34.210606+00
20f11f0f-1707-4f2c-a954-06243bdbd2ce	ca0fe835-cf14-4b4f-93ab-eb14d1ad250d	d1111111-1111-1111-1111-111111111111	PER_UNIT	3800.00	1.00	2026-05-24	\N	2026-05-24 05:43:29.533424+00
6e25ec21-cd73-46f9-9e58-e98dc731288d	ca0fe835-cf14-4b4f-93ab-eb14d1ad250d	d2222222-2222-2222-2222-222222222222	PER_PERSON	50000.00	1.00	2026-05-24	\N	2026-05-24 05:43:29.623153+00
9eb5e248-43ed-4986-b937-9e1d4373ce91	ca0fe835-cf14-4b4f-93ab-eb14d1ad250d	d4444444-4444-4444-4444-444444444444	PER_PERSON	10000.00	1.00	2026-05-24	\N	2026-05-24 05:43:29.711995+00
dc746b25-c991-4820-9126-f1ffb7932b77	ca0fe835-cf14-4b4f-93ab-eb14d1ad250d	d3333333-3333-3333-3333-333333333333	PER_ROOM	100000.00	1.00	2026-05-24	\N	2026-05-24 05:43:29.802405+00
0c7f2d15-c33d-4f59-89ce-7ab309a12e5a	b797e88b-a0f1-4b56-8ca7-6a6da5c0240f	d1111111-1111-1111-1111-111111111111	PER_UNIT	3800.00	1.00	2026-05-24	\N	2026-05-24 06:09:40.472663+00
9b98130b-5931-485b-bbc4-cc2ad8d3b352	b797e88b-a0f1-4b56-8ca7-6a6da5c0240f	d2222222-2222-2222-2222-222222222222	PER_PERSON	50000.00	1.00	2026-05-24	\N	2026-05-24 06:09:40.680423+00
fc124eb0-d5db-47a9-8340-f1473b525111	b797e88b-a0f1-4b56-8ca7-6a6da5c0240f	d4444444-4444-4444-4444-444444444444	PER_PERSON	10000.00	1.00	2026-05-24	\N	2026-05-24 06:09:40.883313+00
0642f3a8-2c36-43f3-bcba-06af0c036a3a	b797e88b-a0f1-4b56-8ca7-6a6da5c0240f	192687dd-5c6b-41f8-8c3a-bec73dfdb671	PER_ROOM	0.00	1.00	2026-05-24	\N	2026-05-24 06:09:41.088887+00
872f5391-6512-46cd-b37f-6f1d79c344e9	b797e88b-a0f1-4b56-8ca7-6a6da5c0240f	9b741583-2afc-47bd-ab89-6424e95179cf	PER_ROOM	50000.00	1.00	2026-05-24	\N	2026-05-24 06:09:41.291991+00
8efb7e37-170e-4e7e-a362-cc49eb45e1f5	b797e88b-a0f1-4b56-8ca7-6a6da5c0240f	a2374bda-33e9-4390-aaff-e6dcbcea1e97	PER_ROOM	0.00	1.00	2026-05-24	\N	2026-05-24 06:09:41.498142+00
208e8963-4295-4d96-8585-707cbfce0ad7	b797e88b-a0f1-4b56-8ca7-6a6da5c0240f	c4f8ed3c-2fb0-47f3-ac37-6601001dec5f	PER_ROOM	0.00	1.00	2026-05-24	\N	2026-05-24 06:09:41.698759+00
133e4686-5c55-499c-8ba1-a4d91d33dcaa	b797e88b-a0f1-4b56-8ca7-6a6da5c0240f	f6a0428c-72c8-459f-9e91-1dda15bbfc08	PER_ROOM	0.00	1.00	2026-05-24	\N	2026-05-24 06:09:41.909155+00
8340c8c5-e3e7-4e43-b2d9-08d434bf7dc1	b797e88b-a0f1-4b56-8ca7-6a6da5c0240f	c24f4134-298a-496b-9fa9-a6acfdb0e4bb	PER_ROOM	50000.00	1.00	2026-05-24	\N	2026-05-24 06:09:42.115277+00
415146ae-8d85-4b97-9d26-b67a82b820d2	b797e88b-a0f1-4b56-8ca7-6a6da5c0240f	b3cb85f0-6ddf-4056-9b81-78a13dd33211	PER_ROOM	0.00	1.00	2026-05-24	\N	2026-05-24 06:09:42.317688+00
7d02cd0b-8be1-439d-a0b8-df936e9b88c9	b797e88b-a0f1-4b56-8ca7-6a6da5c0240f	a0ad6557-8c87-4502-9f62-85a863557f5c	PER_PERSON	80000.00	1.00	2026-05-24	\N	2026-05-24 06:09:42.45686+00
058325f6-6cd4-466d-89c6-d49063e95c12	b797e88b-a0f1-4b56-8ca7-6a6da5c0240f	c06a40af-b003-475d-8ccf-9a74a4625be4	PER_PERSON	10000.00	1.00	2026-05-24	\N	2026-05-24 06:09:42.587414+00
efe47538-0f1e-4ebe-856a-898933e3cc55	774f59eb-d908-4313-95aa-46ae4136e932	d1111111-1111-1111-1111-111111111111	PER_UNIT	3500.00	1.00	2026-05-27	\N	2026-05-27 02:41:51.829645+00
8ae9d0f6-59be-4f1f-b0e7-6565235f049b	774f59eb-d908-4313-95aa-46ae4136e932	c06a40af-b003-475d-8ccf-9a74a4625be4	PER_PERSON	10000.00	1.00	2026-05-27	\N	2026-05-27 02:41:51.829645+00
fa8cd17b-01dc-4f5a-b98c-10d0d6d3791d	774f59eb-d908-4313-95aa-46ae4136e932	d2222222-2222-2222-2222-222222222222	PER_PERSON	50000.00	1.00	2026-05-27	\N	2026-05-27 02:41:52.026766+00
42d55f33-99af-4f30-8abd-582fb7c2c479	774f59eb-d908-4313-95aa-46ae4136e932	d4444444-4444-4444-4444-444444444444	PER_PERSON	30000.00	1.00	2026-05-27	\N	2026-05-27 02:41:52.223437+00
a018d533-8f91-4bce-a174-a5cf7aaa1ce8	774f59eb-d908-4313-95aa-46ae4136e932	dca7b3c9-d37f-4173-85bb-fe1e34570343	PER_ROOM	10000.00	1.00	2026-05-27	\N	2026-05-27 02:41:52.224437+00
2c580518-5d82-44a5-a7d1-91088c60bbbf	774f59eb-d908-4313-95aa-46ae4136e932	d3333333-3333-3333-3333-333333333333	PER_ROOM	100000.00	1.00	2026-05-27	\N	2026-05-27 02:41:52.421381+00
02b9ef4e-bc97-42a1-82f5-a41926be0b84	774f59eb-d908-4313-95aa-46ae4136e932	02b6956b-2a72-4524-9afc-d83f9e2a2e6a	PER_ROOM	100000.00	1.00	2026-05-27	\N	2026-05-27 02:41:52.421381+00
63fce8f5-10be-4540-a784-65dacc3ee887	277227c0-b1a9-44d6-8ac5-5dc57b2eaf7f	c89714a7-e371-425f-8df4-7ad6b1ca6549	FIXED	500000.00	1.00	2026-05-30	\N	2026-05-30 07:33:10.684442+00
62f4734f-d42f-4dc8-9de1-9e009ce36154	cc4386ff-881d-4117-9c9c-0471e8b6c04f	d1111111-1111-1111-1111-111111111111	PER_UNIT	3500.00	1.00	2026-06-01	\N	2026-06-01 02:56:22.012356+00
33e9e58c-53e8-4042-9664-8527bce6480e	cc4386ff-881d-4117-9c9c-0471e8b6c04f	c06a40af-b003-475d-8ccf-9a74a4625be4	PER_PERSON	10000.00	1.00	2026-06-01	\N	2026-06-01 02:56:22.013479+00
99ec3cf3-1b2c-4f51-bf4a-0822b471a6c6	cc4386ff-881d-4117-9c9c-0471e8b6c04f	d2222222-2222-2222-2222-222222222222	PER_PERSON	50000.00	1.00	2026-06-01	\N	2026-06-01 02:56:22.107132+00
61c899d7-8a0c-4d38-924c-3b724cf6af55	cc4386ff-881d-4117-9c9c-0471e8b6c04f	d4444444-4444-4444-4444-444444444444	PER_PERSON	30000.00	1.00	2026-06-01	\N	2026-06-01 02:56:22.199276+00
ac6e1021-5c96-40c6-a284-877f0cff2fab	cc4386ff-881d-4117-9c9c-0471e8b6c04f	dca7b3c9-d37f-4173-85bb-fe1e34570343	PER_ROOM	10000.00	1.00	2026-06-01	\N	2026-06-01 02:56:22.20027+00
22bf6c8b-cd06-49b6-aa2c-03479a8bce7e	0a0463eb-0069-4a6f-b421-70695eda5d14	d1111111-1111-1111-1111-111111111111	PER_UNIT	3500.00	1.00	2026-06-01	\N	2026-06-01 19:31:32.764751+00
d82ab49d-c7c4-4748-93ae-8e29699ce5df	0a0463eb-0069-4a6f-b421-70695eda5d14	c06a40af-b003-475d-8ccf-9a74a4625be4	PER_PERSON	10000.00	1.00	2026-06-01	\N	2026-06-01 19:31:32.765758+00
35e9ce17-0e05-4ff8-8cfa-aff6a5595200	0a0463eb-0069-4a6f-b421-70695eda5d14	d2222222-2222-2222-2222-222222222222	PER_PERSON	50000.00	1.00	2026-06-01	\N	2026-06-01 19:31:32.864424+00
be2c5e76-376e-43b6-a901-16c22d369e2f	0a0463eb-0069-4a6f-b421-70695eda5d14	d4444444-4444-4444-4444-444444444444	PER_PERSON	30000.00	1.00	2026-06-01	\N	2026-06-01 19:31:32.962414+00
7ee666df-dff1-4786-a4fa-33915642b6a0	0a0463eb-0069-4a6f-b421-70695eda5d14	dca7b3c9-d37f-4173-85bb-fe1e34570343	PER_ROOM	10000.00	1.00	2026-06-01	\N	2026-06-01 19:31:32.96366+00
5b58f4e4-c094-4545-88bc-0c0f85c1e3e8	9057baa1-3318-4b5c-af06-131d349d706e	d1111111-1111-1111-1111-111111111111	PER_UNIT	3500.00	1.00	2026-06-01	\N	2026-06-01 19:56:15.697773+00
f6069a6d-28d0-44ad-8dbf-ef7bdb9152ee	9057baa1-3318-4b5c-af06-131d349d706e	c06a40af-b003-475d-8ccf-9a74a4625be4	PER_PERSON	10000.00	1.00	2026-06-01	\N	2026-06-01 19:56:15.698374+00
c194a35a-a0ed-42fe-a639-ec362fae7ba6	9057baa1-3318-4b5c-af06-131d349d706e	d2222222-2222-2222-2222-222222222222	PER_PERSON	50000.00	1.00	2026-06-01	\N	2026-06-01 19:56:15.698374+00
3abbf422-ef5c-46f2-b910-96a5a8df1821	9057baa1-3318-4b5c-af06-131d349d706e	d4444444-4444-4444-4444-444444444444	PER_PERSON	30000.00	1.00	2026-06-01	\N	2026-06-01 19:56:15.698374+00
7c9a92e4-19c8-47fb-b17c-67812518ab12	9057baa1-3318-4b5c-af06-131d349d706e	dca7b3c9-d37f-4173-85bb-fe1e34570343	PER_ROOM	10000.00	1.00	2026-06-01	\N	2026-06-01 19:56:15.698374+00
ab28d8c2-85a8-4340-aef1-308b69207aa7	7667b075-29e2-44f0-ae53-d31df1affb7f	c89714a7-e371-425f-8df4-7ad6b1ca6549	FIXED	50000.00	1.00	2026-06-13	\N	2026-06-13 15:53:58.004151+00
\.

--
-- Data for Name: email_verification_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."email_verification_token" ("id", "nguoi_dung_id", "token", "ngay_het_han", "tao_luc") FROM stdin;
9e3cc369-c7bc-4504-98e0-25e204aaddb1	00b4c56f-45fa-49a2-874b-601bc77dcb65	53d14152-7792-40e6-a64b-31185e65e9a2	2026-05-24 16:22:38.107621+00	2026-05-23 16:22:38.109125+00
4c2e8909-a359-4ced-9b4c-3f013b45c59b	c7cdde54-c62a-42af-8bec-62e37f3fde83	ce3a699c-48db-4495-aa23-7f7900e1e481	2026-05-25 07:16:00.479228+00	2026-05-24 07:16:00.480735+00
7544b1ec-fa4c-440b-a5ab-0894b7a375d0	3b6141c5-a1f0-4bc5-9c17-4fa329b52c29	e5d7f186-f486-4908-81f7-d47389db1c5c	2026-05-25 07:16:00.479228+00	2026-05-24 07:16:00.480735+00
14f06a1a-2313-48a1-99ed-60dc14d21d36	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	fb7e9500-eb39-4d9f-82a2-1094037585b8	2026-05-25 07:16:35.105676+00	2026-05-24 07:16:35.105676+00
be81c461-f45b-43b9-a62d-099c58a57108	4e0b7b88-3763-4732-a1cf-c2d0707b0511	3daff34f-0681-468d-9dbe-7a3e28c1c44e	2026-05-27 13:42:57.015519+00	2026-05-26 13:42:57.01752+00
5bca4625-2847-4929-be49-5c2647e98bc9	dc440559-dd1c-462c-832f-a5bb648d9199	79da58f9-9bfe-4703-852c-679de42363d8	2026-05-30 04:39:31.840903+00	2026-05-29 04:39:31.8429+00
ed499eec-f917-4b38-ae42-91509ed38524	3047f731-7822-47dd-930e-17c9b658cf55	8b5343a7-862c-43fc-a04a-ce1aae693917	2026-05-30 04:43:04.857609+00	2026-05-29 04:43:04.857609+00
8b74136c-a6f3-4396-9ead-608a5e6cbff4	814e5dd5-9805-4566-814a-0b97df3978d0	6cace70c-c180-4baa-9212-20c051b4b529	2026-05-31 04:15:00.644181+00	2026-05-30 04:15:00.645266+00
819207bc-6680-495c-980b-f65422e728c3	91e602be-25b8-4fd4-9769-b307cd9af888	2a950944-41c6-479a-83c6-6543f71dd3da	2026-06-01 03:34:55.760759+00	2026-05-31 03:34:55.761754+00
933292b4-172a-4a28-9b2b-eadd7c102660	f7fe48c3-2101-45ba-86cd-26f0bf28a923	9b401f88-4b49-4926-8bbe-acf7151376c3	2026-06-01 06:13:54.43777+00	2026-05-31 06:13:54.438772+00
507f03cf-0cf8-4295-aa8d-0758bc83d67a	c4e8b2dc-daf4-47aa-a573-8383561351af	63d2d1a5-c74a-48c6-ab1c-308d39fa7f40	2026-06-14 06:57:21.000331+00	2026-06-13 06:57:21.000331+00
\.

--
-- Data for Name: file_media; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."file_media" ("id", "doi_tuong", "doi_tuong_id", "url", "public_id", "loai_file", "kich_thuoc_bytes", "metadata", "nguoi_tai_len_id", "tao_luc") FROM stdin;
4213e02d-6b7d-45ce-a710-b06e7853d648	ROOM	e30e4555-7e6c-4c7b-8cdf-c8c57145c75d	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779554500/quanlyphongtro/wemzccfpqubdws70pl0m.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-23 16:41:45.542929+00
4fdb4c58-e265-4840-bfef-471baa1398c1	TENANT	cdbe66ce-3bf0-4023-b2c8-38ba477730f1	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779556660/quanlyphongtro/heiky0grafj2zq1u0yzc.webp	\N	CCCD_FRONT	\N	\N	\N	2026-05-23 17:18:00.063393+00
7951052b-31ac-42e6-9a05-9794c4e578fe	TENANT	cdbe66ce-3bf0-4023-b2c8-38ba477730f1	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779556662/quanlyphongtro/c2jpkwgqf6pfkqpzh2sd.webp	\N	CCCD_BACK	\N	\N	\N	2026-05-23 17:18:00.50978+00
03fd824a-e5c7-4169-9dce-2b27a422ea3a	ROOM	48ef0756-c05a-44fa-b4b0-d3f249f564d0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779554980/quanlyphongtro/ehyqt9r4qbcvfqdsrjjp.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-23 18:10:12.776312+00
d9fd9c36-fff7-46f8-9126-ac4b2a1985cb	ROOM	48ef0756-c05a-44fa-b4b0-d3f249f564d0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779554981/quanlyphongtro/fmvcmtahnqudjnnrgsfn.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-23 18:10:12.777314+00
3eb5af57-53fb-4846-8978-fa642f6192c9	ROOM	48ef0756-c05a-44fa-b4b0-d3f249f564d0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779554980/quanlyphongtro/vfvmlq7dcvnlnlpcmyly.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-23 18:10:12.777314+00
d2708e7b-8bba-46a7-bfee-f73de5cb8953	ROOM	48ef0756-c05a-44fa-b4b0-d3f249f564d0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779554979/quanlyphongtro/jnoorbzlqpqj2rmjeqiy.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-23 18:10:12.777314+00
77edbbe6-e2c1-497b-909f-8c0e7c7a58ed	ROOM	48ef0756-c05a-44fa-b4b0-d3f249f564d0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779554979/quanlyphongtro/uh2o7xfn97xhqyr3ayvk.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-23 18:10:12.777314+00
5bafdea5-02f0-4f6b-a728-95e3aa8f7446	ROOM	48ef0756-c05a-44fa-b4b0-d3f249f564d0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779554979/quanlyphongtro/nsu1lvdcza6jkg1nyywz.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-23 18:10:12.779315+00
a03e0f1f-88eb-4710-810d-b21f653ff201	ROOM	6dd938e2-dba5-4e98-8e1f-24dbb4cdb847	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779607231/quanlyphongtro/vakp9qcmonhufuilpa0x.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-24 07:21:05.046041+00
ee034749-ac40-4ec0-9063-febf7aa300fb	METER_READING	617bab35-2e22-4e3c-834f-a7da282e8dac	http://res.cloudinary.com/dlkh28yfs/image/upload/v1779676495/quanlyphongtro/lasw8tip1eevqeejfzq0.jpg	\N	METER_IMAGE	\N	\N	\N	2026-05-25 02:35:08.299134+00
1964db1e-d0c0-4c44-a6ac-15c7bd4bdfea	PAYMENT	3c3ddefe-cb7b-43d1-b730-d54e0454119d	http://res.cloudinary.com/dlkh28yfs/image/upload/v1779819634/quanlyphongtro/ffve1arivrvvxbc32yrj.png	\N	PAYMENT_RECEIPT	\N	\N	\N	2026-05-26 18:20:35.83693+00
5804e533-f878-407f-984c-a8f50184dcc1	PAYMENT	636a8a37-fd70-4336-b4ee-48e0a1078a85	http://res.cloudinary.com/dlkh28yfs/image/upload/v1779819708/quanlyphongtro/bcc9ikxdecbiffaroruk.png	\N	PAYMENT_RECEIPT	\N	\N	\N	2026-05-26 18:21:49.305933+00
6d40dc2d-1233-4502-8671-62b604569fe8	ROOM	acd7eb9a-4e0e-4056-91f1-50e0b8881240	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847246/quanlyphongtro/pmw4ntnngj5hy51xl4ap.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:00:54.649021+00
d26dedc7-426a-45be-af00-7669bb187286	ROOM	acd7eb9a-4e0e-4056-91f1-50e0b8881240	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847246/quanlyphongtro/jqln7jkla5ak2qelrl8u.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:00:54.650017+00
d1ef23e7-be90-4e32-a0c8-b6563f080a9b	ROOM	acd7eb9a-4e0e-4056-91f1-50e0b8881240	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847245/quanlyphongtro/jevvrwtalc5fuv4y40dy.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:00:54.650017+00
d8851e80-e07e-4952-833e-3205a3e68a73	ROOM	acd7eb9a-4e0e-4056-91f1-50e0b8881240	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847246/quanlyphongtro/kzbvmul9let7spijdlgo.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:00:54.650017+00
bef0dbb0-9d5e-4f3f-9f19-3e9a0ed9778c	ROOM	acd7eb9a-4e0e-4056-91f1-50e0b8881240	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847247/quanlyphongtro/a1ltua6f1xzg70wwti4j.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:00:54.650017+00
9eb0f987-37b6-42de-8a3b-f3fbbf37fa06	ROOM	acd7eb9a-4e0e-4056-91f1-50e0b8881240	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847250/quanlyphongtro/oi9tpzbn176sf8z51j7d.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:00:54.650017+00
e0072eef-1cf6-4e06-a559-58581af4d3b1	ROOM	acd7eb9a-4e0e-4056-91f1-50e0b8881240	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847249/quanlyphongtro/ve64kaps8m8rhamtzlnr.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:00:54.651006+00
5a59e31b-6a47-4a85-af81-fcda658e0691	ROOM	acd7eb9a-4e0e-4056-91f1-50e0b8881240	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847249/quanlyphongtro/jnisszinh6utftazkr6h.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:00:54.651006+00
60ff2bd3-188c-468c-a682-e1819c76d4dc	ROOM	8f54a087-577a-476b-8c74-cb4e6d0c35f0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847662/quanlyphongtro/yvx566m2x0ybxo2paig7.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:08:05.057502+00
741615f6-564d-4199-a8ea-2fc63394e083	ROOM	8f54a087-577a-476b-8c74-cb4e6d0c35f0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847664/quanlyphongtro/chhmrxtrmcniiortikaf.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:08:05.057502+00
8a3690b1-38d3-4572-8768-faa06b937381	ROOM	8f54a087-577a-476b-8c74-cb4e6d0c35f0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847662/quanlyphongtro/xllkrizttoexrw8qkshx.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:08:05.058503+00
91fba19d-4726-4543-899d-e79a3b707c80	ROOM	8f54a087-577a-476b-8c74-cb4e6d0c35f0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847663/quanlyphongtro/ydq7q00gon84ge7widtx.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:08:05.058503+00
7d9c94ef-a0eb-423e-b20d-de4b75f2e408	ROOM	8f54a087-577a-476b-8c74-cb4e6d0c35f0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847662/quanlyphongtro/ay8eijinajs8s86vu8nf.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:08:05.058503+00
453be861-54f8-4ec5-8cdb-3903af7f66c5	ROOM	8f54a087-577a-476b-8c74-cb4e6d0c35f0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847662/quanlyphongtro/zznjecxhbpfxhnwlyufh.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:08:05.059739+00
822e0e4f-5c1d-4443-9258-6176d8ca6de8	ROOM	8f54a087-577a-476b-8c74-cb4e6d0c35f0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847665/quanlyphongtro/ankejjvbpjhwsirwemtr.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:08:05.059739+00
fe14b356-9946-4900-87cb-a3850fc24043	ROOM	8f54a087-577a-476b-8c74-cb4e6d0c35f0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847665/quanlyphongtro/zuteot9vpho2gg8dxeyf.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:08:05.059739+00
0d83dc7c-e25f-436e-8bca-fa9104c58b6f	ROOM	8f54a087-577a-476b-8c74-cb4e6d0c35f0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847665/quanlyphongtro/a0rrjkjenaek4xvckcmo.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:08:05.059739+00
b69fd3d3-c87b-41ca-8b8d-38b66f133a52	ROOM	8f54a087-577a-476b-8c74-cb4e6d0c35f0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847665/quanlyphongtro/a4huokbft8mmhkhyvouv.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:08:05.059739+00
7aedd66f-31c1-46cc-bb8d-0f0bbd6a8947	ROOM	f776bab1-2a8e-411e-823d-fa16270da89e	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847839/quanlyphongtro/hgt1nbe0mjlrhzy1i1cm.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:10:43.005+00
075dd151-d6f4-42c5-a13b-b7f4566fb10d	ROOM	f776bab1-2a8e-411e-823d-fa16270da89e	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847839/quanlyphongtro/q37w1nv2btvmcgnq2gzz.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:10:43.005994+00
50219910-4d02-4587-82e2-b8ad67aa0158	ROOM	f776bab1-2a8e-411e-823d-fa16270da89e	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847838/quanlyphongtro/ez8e4m7x5sohhwdoowyl.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:10:43.005994+00
5f35bf3d-45f8-4d64-a402-4b970b8b878c	ROOM	f776bab1-2a8e-411e-823d-fa16270da89e	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847838/quanlyphongtro/eiffmcjw1up0rlq9cclq.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:10:43.006996+00
c426c5c9-9481-47d0-aef7-e1e499348d57	ROOM	f776bab1-2a8e-411e-823d-fa16270da89e	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847838/quanlyphongtro/iskh8muqaxvbnnjlwsju.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:10:43.007991+00
08c1d219-4242-4f2b-97aa-767adc13a6f6	ROOM	f776bab1-2a8e-411e-823d-fa16270da89e	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847840/quanlyphongtro/brdguaq3fkw36qvkyqjf.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:10:43.007991+00
b1cf88a7-439f-4d3d-93f9-f6d296fbeddd	ROOM	f776bab1-2a8e-411e-823d-fa16270da89e	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847840/quanlyphongtro/sh1ik1ywkvtpftkbwgdm.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:10:43.009072+00
0aeea352-77f6-4d97-9322-72e517037a52	ROOM	f776bab1-2a8e-411e-823d-fa16270da89e	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847840/quanlyphongtro/se3n48bqca3ij3rsbkkn.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-27 02:10:43.009072+00
fc544971-08a0-4c4f-9122-eb34aa9396e1	TENANT	625c3321-ab04-4330-9e34-2a4458635624	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847996/quanlyphongtro/hk8mmglfrzeagoui3nu9.webp	\N	CCCD_FRONT	\N	\N	\N	2026-05-27 02:13:20.017501+00
3d27078a-5e04-4a5c-a9f9-fa6cfc5edeb6	TENANT	625c3321-ab04-4330-9e34-2a4458635624	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847998/quanlyphongtro/qenqgjtmk3ojlzvohkem.webp	\N	CCCD_BACK	\N	\N	\N	2026-05-27 02:13:20.341607+00
57fcc8cc-d79e-4d89-9477-727047a65ccd	INCIDENT	af6ecffe-b9c5-473d-a9d6-61331cbd0756	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847839/quanlyphongtro/hgt1nbe0mjlrhzy1i1cm.jpg	\N	INCIDENT_IMAGE	\N	\N	\N	2026-05-30 02:56:10.443249+00
1cc09ffb-b68e-4530-a25b-1c8ace80be38	INCIDENT	e4c9b92a-2365-41aa-bba3-4163bf1c4878	https://res.cloudinary.com/dlkh28yfs/image/upload/v1779847839/quanlyphongtro/hgt1nbe0mjlrhzy1i1cm.jpg	\N	INCIDENT_IMAGE	\N	\N	\N	2026-05-30 03:42:44.199714+00
c4c2efb7-f64d-4243-a029-50f0a78a5d5f	ROOM	659998c6-e8c1-4ae8-ba7e-4ebb8f454ec2	https://res.cloudinary.com/dlkh28yfs/image/upload/v1780126292/quanlyphongtro/pacpgzacfb8w41anc6qw.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-30 07:32:05.707972+00
5bb6a78a-3bd1-49ce-b05f-5a938f80dacb	ROOM	5ef2849e-2240-48b0-b54d-1ff2e7c94c11	https://res.cloudinary.com/dlkh28yfs/image/upload/v1780115072/quanlyphongtro/yoyxj83jmsv3etnqnpza.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-05-30 07:35:18.087436+00
2d328b39-abbc-4751-b15c-4e0fb6b68c83	ROOM	738896ea-3b09-4cab-8f71-5437c3392998	https://res.cloudinary.com/dlkh28yfs/image/upload/v1780282181/quanlyphongtro/qe3zub07mjghshxictbp.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-06-01 02:49:43.169353+00
61a60db1-f423-4e79-97c7-af2f1a5afd8f	ROOM	738896ea-3b09-4cab-8f71-5437c3392998	https://res.cloudinary.com/dlkh28yfs/image/upload/v1780282182/quanlyphongtro/hffbrhvwxkpuq085nlam.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-06-01 02:49:43.170352+00
b3ceb06f-6012-4bba-adef-b9b86178420f	ROOM	738896ea-3b09-4cab-8f71-5437c3392998	https://res.cloudinary.com/dlkh28yfs/image/upload/v1780282180/quanlyphongtro/vpcxkmyomreeqalfiinb.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-06-01 02:49:43.170352+00
ffdc23cd-a76f-4622-8608-3dac0a94c71d	ROOM	7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	https://res.cloudinary.com/dlkh28yfs/image/upload/v1780626509/quanlyphongtro/g4en9pltnlynyeajhjwr.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-06-05 02:32:50.206096+00
2a9e2c09-b240-43f2-ab61-48e62e253061	ROOM	7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	https://res.cloudinary.com/dlkh28yfs/image/upload/v1780626509/quanlyphongtro/zbifl7fusb1yqmjrtsfr.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-06-05 02:32:50.206096+00
5b9ae2f2-df2c-4e3b-9e70-e5a0a8f78d61	ROOM	7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	https://res.cloudinary.com/dlkh28yfs/image/upload/v1780626509/quanlyphongtro/rbr9tvbh3kbpmqgfkl50.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-06-05 02:32:50.207109+00
b451ec84-4f98-4e03-8556-077b43322332	ROOM	7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	https://res.cloudinary.com/dlkh28yfs/image/upload/v1780626510/quanlyphongtro/ognvgbvk2g5odvgpamy4.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-06-05 02:32:50.207109+00
a91e1405-0b9d-48f7-b154-89a1f74e2400	ROOM	7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	https://res.cloudinary.com/dlkh28yfs/image/upload/v1780626509/quanlyphongtro/elvviw71gur2bos5z6av.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-06-05 02:32:50.208428+00
7be511e1-c352-4516-8c84-29415b3ff848	TENANT	b3c9ada2-70d5-496d-a103-4cf3d7ecc21f	https://res.cloudinary.com/dlkh28yfs/image/upload/v1780123715/quanlyphongtro/kgkkcnjm5okmqjs3lvwo.jpg	\N	CCCD_FRONT	\N	\N	\N	2026-06-13 15:42:05.265183+00
3e12206a-7caa-4494-825c-ce02b6769a3c	TENANT	b3c9ada2-70d5-496d-a103-4cf3d7ecc21f	https://res.cloudinary.com/dlkh28yfs/image/upload/v1780123719/quanlyphongtro/svpbtipcew3pfuk94a3b.webp	\N	CCCD_BACK	\N	\N	\N	2026-06-13 15:42:05.590502+00
\.

--
-- Data for Name: invoice_generation_batch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."invoice_generation_batch" ("id", "nha_tro_id", "ky_thang", "ky_nam", "trang_thai", "tong_hop_dong", "tao_thanh_cong", "bo_qua", "loi", "nguoi_tao_id", "tao_luc") FROM stdin;
\.

--
-- Data for Name: invoice_generation_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."invoice_generation_log" ("id", "batch_id", "hop_dong_id", "hoa_don_id", "status", "reason", "tao_luc") FROM stdin;
\.

--
-- Data for Name: lich_hen; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."lich_hen" ("id", "phong_id", "nguoi_dung_id", "ho_ten", "so_dien_thoai", "email", "ngay_hen", "trang_thai", "google_calendar_event_id", "da_gui_nhac_nho", "ghi_chu", "tao_luc", "cap_nhat_luc", "ghi_chu_admin") FROM stdin;
ae6127cf-cd47-4624-a9bd-c99d9f508f46	ac58f1da-64bb-4524-a104-42be15b02f3b	\N	đỗ chí công	0396822875		2026-05-27 02:00:00+00	PENDING	\N	f		2026-05-26 18:23:49.727454+00	2026-05-26 18:23:49.727454+00	\N
a7806004-e7cb-4ccf-983e-59fd751333d3	acd7eb9a-4e0e-4056-91f1-50e0b8881240	\N	tho	0971451782	ptho40144@gmail.com	2026-05-31 07:00:00+00	CONFIRMED	\N	f	xem nha	2026-05-31 06:36:32.195607+00	2026-05-31 06:36:59.544031+00	\N
2ff03ddb-2438-4fcf-bfaf-53d2f437fc1d	c6334989-e7f7-4ee2-b37f-4d376436fdfb	\N	Trần Vỹ Khách Thuê	0374729354	vyttt22052006@gmail.com	2026-06-10 04:00:00+00	COMPLETED	\N	f		2026-06-10 03:52:44.249385+00	2026-06-10 03:54:36.229195+00	\N
38b52264-f767-4338-b244-6f95edc1c1e0	c6334989-e7f7-4ee2-b37f-4d376436fdfb	\N	Trần Vỹ Khách Thuê	0374729354	vyttt22052006@gmail.com	2026-06-10 07:00:00+00	CANCELLED	\N	f		2026-06-10 04:08:50.018559+00	2026-06-10 04:11:23.078314+00	\N
e31a38f2-ab57-486d-9703-303104e83801	c6334989-e7f7-4ee2-b37f-4d376436fdfb	\N	Trần Vỹ Khách Thuê	0374729354	vyttt22052006@gmail.com	2026-06-10 07:00:00+00	COMPLETED	\N	f		2026-06-10 04:14:06.743653+00	2026-06-10 04:15:53.391171+00	chốt giờ này nhé 
eb3eebc1-0980-4218-a775-d4c4a93887e6	71b1f5f5-950c-4616-997c-f3376e63c8f4	\N	Khách 01	0839402890	khach01@gmail.com	2026-06-13 09:00:00+00	PENDING	\N	t	beautiful	2026-06-13 06:58:16.872362+00	2026-06-13 06:59:23.023483+00	\N
859a13b8-6b0a-40f6-8336-682df4afd69b	7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	\N	Sơn	0336073019	phts6626@gmail.com	2026-06-14 02:00:00+00	PENDING	\N	t	kh	2026-06-13 16:31:08.7919+00	2026-06-13 16:59:23.498236+00	\N
09e772ad-82e8-42af-b1e6-787e59cd4980	7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	\N	Admin EasyHouse	0973686868	vyt22052006@gmail.com	2026-06-14 02:00:00+00	COMPLETED	\N	f		2026-06-13 23:33:23.629683+00	2026-06-13 23:45:01.692861+00	\N
\.

--
-- Data for Name: lich_su_hoa_don; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."lich_su_hoa_don" ("id", "hoa_don_id", "trang_thai_truoc", "trang_thai_moi", "nguoi_thay_doi_id", "ghi_chu", "tao_luc") FROM stdin;
\.

--
-- Data for Name: lich_thanh_toan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."lich_thanh_toan" ("id", "hop_dong_id", "ky_nam", "ky_thang", "tu_ngay", "den_ngay", "han_thanh_toan", "so_tien_du_kien", "hoa_don_id", "trang_thai", "ghi_chu", "tao_luc", "cap_nhat_luc", "xoa_luc") FROM stdin;
\.

--
-- Data for Name: login_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."login_history" ("id", "nguoi_dung_id", "email", "thanh_cong", "ip_address", "user_agent", "ly_do_that_bai", "tao_luc") FROM stdin;
357f44fc-27f7-4c3c-91b3-4632eb56d351	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-05-26 18:17:15.616621+00
b988a442-510e-47e1-ab72-d70f4592be83	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-05-27 01:55:32.619907+00
e9c5d850-cbe9-4df9-82be-5d808589b35c	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	vyt22052006@gmail.com	t	::1	node	\N	2026-05-29 16:13:17.167692+00
9993a625-32ac-482c-8896-f4907b297245	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-05-29 17:43:25.284609+00
a90b6b14-6406-4208-83ea-f2e8f73ce485	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-05-29 17:47:54.061741+00
70d97b77-1293-479d-8a94-0d32337f4020	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-05-29 17:53:10.984436+00
644ccacf-4d3d-486a-a208-b39178ac2cf0	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-05-30 02:55:29.725972+00
cb4d4796-5fba-443b-86b1-d9a8199f4ab6	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-05-30 02:56:03.610096+00
eaad2e4f-9f0b-43ea-a8fa-43348e1e371b	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-05-30 02:56:29.951413+00
6562dbe4-cc3d-4768-8ad3-000dfdb4d49e	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-05-30 04:01:54.364639+00
1a3d5771-dbf0-4238-8d19-6a0d8f64b526	dc440559-dd1c-462c-832f-a5bb648d9199	trsown6626@gmail.com	t	::1	node	\N	2026-05-30 04:11:30.314644+00
0cae46a8-00eb-49c1-9189-d20e590f1cc6	dc440559-dd1c-462c-832f-a5bb648d9199	trsown6626@gmail.com	t	::1	node	\N	2026-05-30 04:11:35.559788+00
aabcb43b-d4ff-4da8-bb5f-989fc9779548	dc440559-dd1c-462c-832f-a5bb648d9199	trsown6626@gmail.com	t	::1	node	\N	2026-05-30 04:11:48.329939+00
99176491-491d-482f-83ba-7bc915df0441	dc440559-dd1c-462c-832f-a5bb648d9199	trsown6626@gmail.com	t	::1	node	\N	2026-05-30 04:12:03.775231+00
50d0c4b5-7224-4688-98b9-c49c5d767f6d	dc440559-dd1c-462c-832f-a5bb648d9199	trsown6626@gmail.com	t	::1	node	\N	2026-05-30 04:12:48.512036+00
c105bd4b-2c2b-4d9b-85f9-eda94124c6a4	dc440559-dd1c-462c-832f-a5bb648d9199	trsown6626@gmail.com	t	::1	node	\N	2026-05-30 04:13:36.669063+00
51af67f2-0798-438c-96e4-c4bea60a277e	3047f731-7822-47dd-930e-17c9b658cf55	sown123@gmail.com	t	::1	node	\N	2026-05-30 04:13:54.53973+00
6b2d6d71-4d23-4872-8d8e-53a0b38a6318	814e5dd5-9805-4566-814a-0b97df3978d0	sown06@gmail.com	t	::1	node	\N	2026-05-30 04:15:11.001562+00
49f41b81-9130-4049-99bb-30aee670c8c6	814e5dd5-9805-4566-814a-0b97df3978d0	sown06@gmail.com	t	::1	node	\N	2026-05-30 04:15:23.310844+00
5db9964b-3b5a-4861-ab0a-c4fa66dc967d	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-05-30 04:15:34.244664+00
7e1453c2-21eb-445d-a23f-dcc823427169	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-05-30 07:14:28.957516+00
37c548e7-43fa-4f1f-a75c-2b8765348efd	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-05-30 07:15:12.615833+00
1d2d2724-0839-43b1-9160-9bda4a2634d8	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-05-30 08:46:17.238596+00
cefc840f-4b80-48b5-98f3-9dc8a2cd3977	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-05-31 03:07:43.195557+00
8815ca48-5a19-4385-a0ac-8e18acd97011	91e602be-25b8-4fd4-9769-b307cd9af888	qa20260531103454@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-05-31 03:34:57.332686+00
59d9e4ed-dcaf-4349-86bf-d849b8f673be	91e602be-25b8-4fd4-9769-b307cd9af888	qa20260531103454@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-05-31 03:35:13.919918+00
5fab7380-7768-496d-b1bc-2295241b8f1e	91e602be-25b8-4fd4-9769-b307cd9af888	qa20260531103454@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-05-31 03:37:30.863844+00
f0ad23af-4b21-4dad-8427-423730ed11f7	91e602be-25b8-4fd4-9769-b307cd9af888	qa20260531103454@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-05-31 03:38:06.973562+00
180af574-8ce4-47a4-969b-9666a5bd2d37	91e602be-25b8-4fd4-9769-b307cd9af888	qa20260531103454@easyhouse.local	t	::1	node	\N	2026-05-31 03:48:42.103312+00
b038a383-f2db-4942-9d44-32fbdc6eeb87	91e602be-25b8-4fd4-9769-b307cd9af888	qa20260531103454@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-05-31 03:51:24.146414+00
1e980e70-5ef3-4980-94d4-9b5803ca631f	91e602be-25b8-4fd4-9769-b307cd9af888	qa20260531103454@easyhouse.local	t	::1	node	\N	2026-05-31 04:10:16.295376+00
a06c1a43-506b-4bcc-8851-9f4e43bed5c8	91e602be-25b8-4fd4-9769-b307cd9af888	qa20260531103454@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-05-31 04:11:19.195799+00
5bb1e690-86bd-400e-8d98-e0c9f31eaf8d	91e602be-25b8-4fd4-9769-b307cd9af888	qa20260531103454@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-05-31 04:16:10.621967+00
01cab554-5d58-4213-9ebb-80c2fcbdeaab	91e602be-25b8-4fd4-9769-b307cd9af888	qa20260531103454@easyhouse.local	t	::1	node	\N	2026-05-31 04:48:22.7263+00
6501cf6e-5edd-41bb-91b4-c767e3388c3a	f7fe48c3-2101-45ba-86cd-26f0bf28a923	gtruc2146@gmail.com	t	::1	node	\N	2026-05-31 06:14:34.820524+00
3ca6330a-2249-407a-82bd-07a31fafcda9	f7fe48c3-2101-45ba-86cd-26f0bf28a923	gtruc2146@gmail.com	t	::1	node	\N	2026-05-31 06:14:48.09547+00
f3a7deee-3f5c-4c54-94c3-136a8ab7c72c	f7fe48c3-2101-45ba-86cd-26f0bf28a923	gtruc2146@gmail.com	t	::1	node	\N	2026-05-31 06:16:22.898019+00
6a06218a-395e-449a-861d-689abea7bae2	f7fe48c3-2101-45ba-86cd-26f0bf28a923	gtruc2146@gmail.com	t	::1	node	\N	2026-05-31 06:16:36.126308+00
e2e6f905-549f-406f-9f88-bbcf338a63b5	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-05-31 06:25:47.35992+00
3bfee9a8-cca4-42ac-83c2-392272c8d86a	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-05-31 06:27:59.562872+00
3d684445-23ef-4f98-b65a-6f9239318e6c	f7fe48c3-2101-45ba-86cd-26f0bf28a923	gtruc2146@gmail.com	t	::1	node	\N	2026-05-31 06:29:03.100084+00
e2ad0965-dc72-4d8e-8ef1-7ff62d234f51	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-05-31 06:32:59.701363+00
b545f899-ac29-402c-9b00-ec7e5be0f703	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-05-31 14:15:35.459808+00
9f849740-48e2-4866-93bf-349e4e581715	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-05-31 14:44:14.217507+00
1777af05-f8bc-430d-b894-87925af45dbd	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-01 02:29:13.455539+00
bb791e49-209f-4e03-8471-e2985f164f4e	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-01 02:35:22.030804+00
5ba5d5d8-0582-4db4-9528-97cbc8fb77fd	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-01 02:51:06.858903+00
c208c77c-456b-4926-841b-0e2486a9612f	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-01 06:14:17.785188+00
56df39bc-5939-4aa5-9bc4-ee7d13870ad5	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	vyt22052006@gmail.com	t	::1	node	\N	2026-06-01 07:52:57.938877+00
6004c031-ea0f-4d9a-96c2-4e885f9323b9	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	node	\N	2026-06-01 08:02:35.123741+00
1b6722cc-848b-4901-836d-b6810281a70a	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-01 08:06:10.832104+00
424b2b66-5b02-4c40-a313-b0affa98dd21	627d6150-9fe6-41e4-98fd-e966fb11d5f2	landlord@easyhouse.local	t	::1	node	\N	2026-06-01 08:06:08.668707+00
22eff57d-dc41-4d07-a5a3-62b8dead904e	7be2a683-5537-41c2-b834-ea534816a945	tenant@easyhouse.local	t	::1	node	\N	2026-06-01 08:08:10.221499+00
6b2719f6-2c86-4f20-994f-62fbc29ae7c8	7be2a683-5537-41c2-b834-ea534816a945	tenant@easyhouse.local	t	::1	node	\N	2026-06-01 08:08:22.34719+00
b7005066-5f16-418d-9946-872969d3a12e	627d6150-9fe6-41e4-98fd-e966fb11d5f2	landlord@easyhouse.local	t	::1	node	\N	2026-06-01 08:09:21.809273+00
bfa79ec7-efbf-4975-b421-05d586019928	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-01 08:21:47.357224+00
402edb29-932e-4e34-a465-9e274a4b8587	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-01 08:48:23.863769+00
6e236c39-8f1b-415d-94dd-48c5d12967bb	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-01 18:07:47.486831+00
2094779c-591b-411b-9ecd-99f68983bee6	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-02 01:45:25.767731+00
bf4d584b-dafd-4757-97d4-08e5b5418290	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-02 01:57:51.106065+00
4455a4e3-5eba-4eea-994d-c1fc8b2209fc	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	node	\N	2026-06-02 14:02:55.612397+00
0d513a40-1044-4952-8eac-7f0eeb886076	7be2a683-5537-41c2-b834-ea534816a945	tenant@easyhouse.local	t	::1	node	\N	2026-06-02 15:03:13.536327+00
8c5b76ee-759b-4c29-8e88-cb1ce2099cb3	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-02 16:34:59.088522+00
9b431951-3e85-4396-be90-47ebe0cb7c5c	814e5dd5-9805-4566-814a-0b97df3978d0	sown06@gmail.com	t	::1	node	\N	2026-06-03 03:35:00.872784+00
aaf7754f-b7db-4bfb-a832-e475c6fd2df6	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	node	\N	2026-06-03 12:55:37.001552+00
4fb94061-d3ab-403d-9677-83e72f509d0d	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	node	\N	2026-06-03 12:56:58.368894+00
36f42158-4434-47ba-b644-c2bf27921df5	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.26100.8521	\N	2026-06-03 13:02:59.476528+00
004e9b56-d67c-40a1-9727-f634782cd3ec	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	node	\N	2026-06-03 13:21:57.216842+00
a3bdde11-e617-4a9d-a4f6-56a5da3097ba	7be2a683-5537-41c2-b834-ea534816a945	tenant@easyhouse.local	t	::1	node	\N	2026-06-03 13:30:38.294322+00
29bf9c50-e650-4b6e-9e1b-3ab0d12f3e55	627d6150-9fe6-41e4-98fd-e966fb11d5f2	landlord@easyhouse.local	t	::1	node	\N	2026-06-03 13:31:16.979216+00
a09ddd27-74fc-4415-b78e-ecff1f87e94e	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-03 14:28:53.67075+00
edb20d54-55e6-40c0-a7b0-580177555606	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-03 14:36:37.083409+00
a59a2d2c-8196-476b-b4e1-67a984db5785	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	node	\N	2026-06-03 15:38:55.984366+00
b7524a0e-9194-442a-95e3-bc8338cb1a95	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-03 15:50:35.906952+00
2967ffe3-398b-46d7-ab32-cfa61d567915	814e5dd5-9805-4566-814a-0b97df3978d0	sown06@gmail.com	t	::1	node	\N	2026-06-03 15:53:35.963556+00
4556ad77-7605-4ec8-8019-f19b0ef201dc	3047f731-7822-47dd-930e-17c9b658cf55	sown123@gmail.com	t	::1	node	\N	2026-06-03 15:53:54.898946+00
0e11205f-23e3-4212-8eb7-fdc98412568a	3047f731-7822-47dd-930e-17c9b658cf55	sown123@gmail.com	t	::1	node	\N	2026-06-03 15:55:04.652991+00
e463c7dd-08b9-4285-8852-5be37fb0d118	3047f731-7822-47dd-930e-17c9b658cf55	sown123@gmail.com	t	::1	node	\N	2026-06-03 15:55:58.671387+00
0321c8eb-1fbf-4898-bd9b-7ef54493daa2	3047f731-7822-47dd-930e-17c9b658cf55	sown123@gmail.com	t	::1	node	\N	2026-06-03 15:56:24.650093+00
62560a97-751c-4534-acb3-7114f7f95778	3047f731-7822-47dd-930e-17c9b658cf55	sown123@gmail.com	t	::1	node	\N	2026-06-03 15:57:01.524322+00
d81c099f-e27b-430c-b4c2-64d1861847ed	3047f731-7822-47dd-930e-17c9b658cf55	sown123@gmail.com	t	::1	node	\N	2026-06-03 15:57:08.057495+00
f3f507c3-d75b-452a-acaf-897d9e0f4bbb	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-03 15:57:30.404415+00
d0875a52-db9d-47ee-97d0-f8f52e6c1796	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-03 16:58:34.738297+00
1882ed69-7e03-4194-b42a-3ec7b6083e0f	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-03 17:01:28.523842+00
dcf52fe6-0361-4b9d-a408-34cb4343209a	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-03 17:25:57.908326+00
fad7f22d-1c54-4882-a5c8-97459c1a471c	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-04 03:10:52.595244+00
c8b4c495-a109-416a-8981-c1f1f7cb824f	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-04 03:11:22.34256+00
950f1241-adff-4764-9446-fe02adc73ec5	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-04 15:14:09.927913+00
eca90f8f-644d-4bd1-9ede-9d34cb5ca9b5	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-04 15:37:01.715478+00
79c87f04-06e1-416c-91ab-2920444e392c	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-04 15:37:21.149844+00
3e8dec59-95ee-446f-b2f4-679b2075f5af	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-04 15:45:40.295692+00
8d1ed32d-0f08-4884-8a70-582667644a2a	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-04 16:09:29.964697+00
79938128-17a6-487d-ad2a-3200eea2374c	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-04 16:13:42.10632+00
43fbb5b1-e0c1-4fc8-b4a1-61d82c539e42	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-05 02:17:12.116751+00
77ac235f-00ce-4576-8f4c-04a1244d8f2b	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-05 02:17:30.3561+00
72f97574-5750-4466-9d32-7f1c46b02d44	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-05 09:56:25.99064+00
b8d245f3-ace7-44e7-a7d3-41db9f19bd3e	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	127.0.0.1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-05 10:29:09.498526+00
6d4542c0-1161-4cc8-822c-777699876ae5	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	127.0.0.1	node	\N	2026-06-05 10:29:26.60926+00
25390f99-3705-44a7-a9ad-e10c1cd49bb7	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	127.0.0.1	node	\N	2026-06-05 10:36:20.507007+00
85f183b7-1ef5-4d69-872d-1f47b6f80aed	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	vyt22052006@gmail.com	t	::1	node	\N	2026-06-06 14:57:51.695835+00
90ab61c4-300b-4796-9ec9-ea76b1f65281	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	127.0.0.1	node	\N	2026-06-07 13:51:10.296151+00
e35b8672-1c7e-48b9-a7ac-9321e8ae57da	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	127.0.0.1	node	\N	2026-06-07 14:34:11.837667+00
ae3f621c-ea1c-491b-ba02-d6e5fa53908f	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-07 14:54:20.844297+00
f09a5ea4-36f8-4856-8a48-8b04fdd9b8fa	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	127.0.0.1	node	\N	2026-06-07 15:03:10.374329+00
00fb3dfc-7712-4f20-b5b3-a79b5b1de3e0	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-08 02:15:02.709332+00
a1e45e78-7698-47f6-9541-3dee3f7edb64	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	vyt22052006@gmail.com	t	::1	node	\N	2026-06-08 03:44:55.216479+00
db4df434-1171-437f-82aa-da3a20356a44	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	vyt22052006@gmail.com	t	::1	node	\N	2026-06-08 03:45:09.705084+00
110b980e-8aac-48b6-bec8-9fe262d0e34f	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	node	\N	2026-06-08 03:46:16.514083+00
d6bb41ee-1820-4996-8cb6-19eabff9457f	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	curl/8.19.0	\N	2026-06-08 04:01:50.9973+00
5347d6b9-b941-4ae7-945c-531e315fd272	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	node	\N	2026-06-08 07:24:40.149611+00
dd6ccca2-0e0c-4101-b34b-2527d90b23a7	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	172.18.0.9	node	\N	2026-06-08 07:41:24.477981+00
ff61655b-a1b5-47b9-93f5-dc4689887339	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-09 02:38:58.685158+00
8cde8beb-4d87-420d-b101-77e00141fc19	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	127.0.0.1	node	\N	2026-06-09 09:02:53.68085+00
c003ed41-3d5b-4b89-ad08-47d9400a3748	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	node	\N	2026-06-10 02:08:02.883262+00
4c3e760f-aa30-46f1-8819-0376aaa81a5c	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-10 02:25:37.143422+00
7ff43ab5-01bf-46e7-9e0e-13b7e3c7a60b	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	127.0.0.1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-10 02:32:53.798561+00
552e7eeb-e592-427b-9270-a824448a89e6	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	127.0.0.1	node	\N	2026-06-10 02:35:44.578206+00
1e5dc221-008d-4b15-a55d-30226924ee42	814e5dd5-9805-4566-814a-0b97df3978d0	sown06@gmail.com	t	127.0.0.1	node	\N	2026-06-10 02:37:01.830367+00
5640d517-d0de-451f-8592-b885912c5f0e	3047f731-7822-47dd-930e-17c9b658cf55	sown123@gmail.com	t	127.0.0.1	node	\N	2026-06-10 02:37:17.139297+00
be2fd145-41ec-4a8f-aeb2-e36ac2c2f68a	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	127.0.0.1	node	\N	2026-06-10 02:41:09.479398+00
e8552270-931b-420d-92c4-20bc76410b58	7be2a683-5537-41c2-b834-ea534816a945	tenant@easyhouse.local	t	::1	node	\N	2026-06-10 02:43:36.281511+00
26baaef7-0e49-4f52-89b6-57e85fe5b968	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	node	\N	2026-06-10 03:07:58.811018+00
9ec194ba-4525-44fe-8c88-27adc0300202	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	node	\N	2026-06-10 03:16:40.438244+00
576b1d4f-80a8-41dc-8153-7720d1e69803	7be2a683-5537-41c2-b834-ea534816a945	tenant@easyhouse.local	t	::1	node	\N	2026-06-10 03:17:21.515315+00
bd61a8c8-a24d-47ba-b61a-88d81760f689	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	node	\N	2026-06-10 03:23:42.790435+00
00d4fc55-fc21-474d-b21c-615df736c167	7be2a683-5537-41c2-b834-ea534816a945	tenant@easyhouse.local	t	::1	node	\N	2026-06-10 03:23:46.537122+00
44cd9602-4be8-4968-8556-e4797df8ed87	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	node	\N	2026-06-10 03:23:55.673281+00
7a8fb02f-0483-4cb8-a3b9-9ae1dff72d14	7be2a683-5537-41c2-b834-ea534816a945	tenant@easyhouse.local	t	::1	node	\N	2026-06-10 03:24:28.458458+00
b648dd3b-d166-421c-a0fc-34936dd7b04c	7be2a683-5537-41c2-b834-ea534816a945	tenant@easyhouse.local	t	::1	node	\N	2026-06-10 03:38:29.398253+00
a9a79882-8683-4a32-bb17-fa55eae0a1cd	7be2a683-5537-41c2-b834-ea534816a945	tenant@easyhouse.local	t	::1	node	\N	2026-06-10 03:38:32.787396+00
ec1dc042-083b-410a-ae98-ca6b562627c5	5e289847-fa1e-402e-8f46-863cf0d3c395	vyttt22052006@gmail.com	t	::1	node	\N	2026-06-10 03:40:21.218178+00
297e359e-8352-4c71-86fa-f62665c0062c	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-10 20:49:53.367735+00
0e5b7074-a211-42b4-9cdd-2a47069e6ba7	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	curl/8.19.0	\N	2026-06-10 21:00:54.299054+00
3e0e60dd-86a0-4ea3-a87f-3269ec918a24	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	curl/8.19.0	\N	2026-06-10 21:00:59.574256+00
24ea0ede-7d4a-4571-879b-f2790e28ac24	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	curl/8.19.0	\N	2026-06-10 21:01:48.962821+00
332783d6-5715-44d7-af7b-a1adeffa4293	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	curl/8.19.0	\N	2026-06-10 21:02:04.131273+00
b45cd2c3-fbad-459e-8d51-8d364fb8e6c7	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	curl/8.19.0	\N	2026-06-10 21:02:42.01889+00
f6ad70fc-038b-4a85-af93-38869393f449	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	curl/8.19.0	\N	2026-06-10 21:02:50.430992+00
1345f47e-e392-48ae-b946-799358ee0f04	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	curl/8.19.0	\N	2026-06-10 21:02:56.598025+00
935ec41f-e742-401d-96fb-9453f3c60b70	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	curl/8.19.0	\N	2026-06-10 21:03:19.364354+00
a44c8193-fbde-4920-aeb0-77b49db34ef8	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	curl/8.19.0	\N	2026-06-10 21:03:25.209985+00
f3d16e08-9972-4c85-a200-b46fc8af6d7c	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	curl/8.19.0	\N	2026-06-10 21:03:30.605213+00
c6da8c14-f999-4677-a637-4e061e89bc75	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	curl/8.19.0	\N	2026-06-10 21:10:16.580907+00
383e018b-5d67-4855-ab2d-abbc85aa96d5	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	curl/8.19.0	\N	2026-06-10 21:10:32.267264+00
530ce941-9d58-49fd-8680-eb12f15135c4	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	curl/8.19.0	\N	2026-06-10 21:15:43.396874+00
2add27aa-05bb-44a6-af32-3d74968228e5	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-12 17:30:57.042095+00
8fd2f588-3667-45e6-aa63-b61984540f1c	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-12 17:31:42.583955+00
f6e1cfb0-a7f7-4cb8-9642-fc59c7ad86d2	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	node	\N	2026-06-12 17:32:01.389638+00
3fbfd72e-5304-4f50-9a76-545ff6496822	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-12 17:46:05.826808+00
6b53b654-a473-438f-a4ab-ee90b8929687	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	::1	node	\N	2026-06-13 06:52:59.667202+00
fe40583b-f400-49c7-be87-cd16f155c6b2	c4e8b2dc-daf4-47aa-a573-8383561351af	khach01@gmail.com	t	::1	node	\N	2026-06-13 06:57:29.200621+00
8415f9d5-5aa5-4067-aab8-05832fedcb97	c4e8b2dc-daf4-47aa-a573-8383561351af	khach01@gmail.com	t	::1	node	\N	2026-06-13 09:16:22.548338+00
88f21912-0491-4ea0-8346-021c9168a4a9	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	node	\N	2026-06-13 09:16:54.420971+00
6411bedc-ebd3-4318-8ea6-e6b4f7c33573	c4e8b2dc-daf4-47aa-a573-8383561351af	khach01@gmail.com	t	127.0.0.1	node	\N	2026-06-13 09:36:29.998287+00
cba02724-6841-4b81-979f-6cbefa513350	c4e8b2dc-daf4-47aa-a573-8383561351af	khach01@gmail.com	t	127.0.0.1	node	\N	2026-06-13 09:36:45.655694+00
fa8b9650-0937-4fe6-8e70-0b9374ef774c	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	127.0.0.1	node	\N	2026-06-13 09:36:53.832738+00
810c0617-68e5-49bf-9890-31248828e2d8	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	127.0.0.1	node	\N	2026-06-13 13:41:03.142195+00
ffb385fd-1b8f-4b29-8ea3-18a5fbad818e	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	127.0.0.1	node	\N	2026-06-13 14:34:38.968993+00
a7bf474f-aff2-47b2-b97d-eb50e65343e1	c4e8b2dc-daf4-47aa-a573-8383561351af	khach01@gmail.com	t	127.0.0.1	node	\N	2026-06-13 14:35:03.871001+00
95c34bc3-5c5f-4404-8a27-7726502812b6	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	127.0.0.1	node	\N	2026-06-13 14:42:56.803898+00
103fa6a4-ddda-45aa-bb55-14980af1f6d1	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	127.0.0.1	node	\N	2026-06-13 15:20:07.044334+00
a3bab80c-573a-4b39-9664-5341eab98bc3	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	127.0.0.1	node	\N	2026-06-13 15:26:58.028558+00
c4bbdb6a-4c77-49c7-ace6-03d89c1bc98c	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-13 15:28:26.315811+00
e47614c6-d0b1-45ac-92e1-b21d66a2e28a	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-13 15:28:35.893146+00
7d02caa2-4628-4857-839f-9ef08a8ac836	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-13 16:16:46.475175+00
07446649-81d9-41a2-b26d-92b8f322a44a	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-13 16:17:16.46188+00
15a88093-6610-457f-9286-c81522a64f1d	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-13 16:17:46.188919+00
78ae4001-b968-4d18-98fd-050911babda0	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-13 16:18:17.504352+00
6cda03f5-eec7-41a8-8a07-2bf83d023e46	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-13 16:18:18.183921+00
ca1ead03-a49b-494f-af0a-c60819892f75	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-13 16:18:48.469007+00
4e9a8b9d-acff-4660-8195-28f15f91000e	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-13 16:19:58.861385+00
bd7833c6-5df5-498c-8a69-2665ba455f4c	4e0b7b88-3763-4732-a1cf-c2d0707b0511	trson6626@gmail.com	t	127.0.0.1	node	\N	2026-06-13 16:25:38.831148+00
685ca03f-4768-40f7-8938-dc8e2dbd5d94	c4e8b2dc-daf4-47aa-a573-8383561351af	khach01@gmail.com	t	127.0.0.1	node	\N	2026-06-13 16:30:01.983923+00
3aa1ce61-11c8-48e9-84e8-d16c33b51133	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	phts6626@gmail.com	t	127.0.0.1	node	\N	2026-06-13 16:30:45.077795+00
d681e849-8946-4e0e-b27a-f069afb79240	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-13 16:35:00.89038+00
d89df2e6-8e5e-408b-9f87-b944931492ca	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-13 16:35:09.322648+00
e81769f9-8560-4d2e-af8f-461b0c34f841	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-13 16:35:23.085871+00
6cea2768-2ca1-4bee-80a1-2be5b4d644f5	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-13 16:37:31.424891+00
0b8558a3-9f0a-4ad8-8097-1432535c3ef1	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-13 16:44:01.08702+00
dd613bc4-db34-4969-a9e7-1a113f89c063	262a2469-eec7-470c-bd92-47874baebdea	admin@easyhouse.local	t	::1	Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249	\N	2026-06-13 16:44:50.729453+00
6df8a2f9-b1d3-4e39-af52-acacb6c3c0f2	00b4c56f-45fa-49a2-874b-601bc77dcb65	docong989@gmail.com	t	::1	node	\N	2026-06-13 22:07:37.202612+00
af5b557f-6a7d-474a-84bf-0e0e22ccd233	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	vyt22052006@gmail.com	t	::1	node	\N	2026-06-13 23:42:21.508892+00
a008dae4-eb68-4dad-bdee-334600a02343	5e289847-fa1e-402e-8f46-863cf0d3c395	vyttt22052006@gmail.com	t	::1	node	\N	2026-06-13 23:46:31.829815+00
2ac9268c-1bd0-4203-9cde-95cd8a5e89ab	5e289847-fa1e-402e-8f46-863cf0d3c395	vyttt22052006@gmail.com	t	::1	node	\N	2026-06-13 23:46:45.863572+00
cd98bf70-a8ce-48b3-868b-80be6e9bcd6b	5e289847-fa1e-402e-8f46-863cf0d3c395	vyttt22052006@gmail.com	t	::1	node	\N	2026-06-13 23:47:07.376463+00
\.

--
-- Data for Name: nguoi_dung_nha_tro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."nguoi_dung_nha_tro" ("id", "nguoi_dung_id", "nha_tro_id", "vai_tro", "co_quyen_xem", "co_quyen_sua", "co_quyen_thu_tien", "tao_luc") FROM stdin;
\.

--
-- Data for Name: vai_tro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."vai_tro" ("id", "ten", "mo_ta", "tao_luc") FROM stdin;
ad11a13c-b380-47f4-8d8f-8f13013c84e9	ADMIN	ADMIN	2026-05-23 16:55:50+00
3692907a-7089-42e0-bb9d-42745a6b6e8a	TENANT	Người Dùng	2026-05-23 16:56:08+00
9317c951-459e-4c28-990c-957001b20860	LANDLORD	Chủ Trọ	2026-05-24 06:02:41.369954+00
a171e1ac-7e92-446c-9b33-540e0c188d03	STAFF	Quyền STAFF	2026-06-01 07:58:12.743541+00
\.

--
-- Data for Name: nguoi_dung_vai_tro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."nguoi_dung_vai_tro" ("nguoi_dung_id", "vai_tro_id", "tao_luc") FROM stdin;
c7cdde54-c62a-42af-8bec-62e37f3fde83	9317c951-459e-4c28-990c-957001b20860	2026-05-24 07:16:00.252114+00
3b6141c5-a1f0-4bc5-9c17-4fa329b52c29	9317c951-459e-4c28-990c-957001b20860	2026-05-24 07:16:00.252114+00
7aebaa14-7f23-4ccd-a555-7ec61f27b98a	9317c951-459e-4c28-990c-957001b20860	2026-05-24 07:16:34.876317+00
4e0b7b88-3763-4732-a1cf-c2d0707b0511	9317c951-459e-4c28-990c-957001b20860	2026-05-26 13:42:56.783231+00
dc440559-dd1c-462c-832f-a5bb648d9199	3692907a-7089-42e0-bb9d-42745a6b6e8a	2026-05-29 04:39:31.594647+00
3047f731-7822-47dd-930e-17c9b658cf55	3692907a-7089-42e0-bb9d-42745a6b6e8a	2026-05-29 04:43:04.663609+00
814e5dd5-9805-4566-814a-0b97df3978d0	3692907a-7089-42e0-bb9d-42745a6b6e8a	2026-05-30 04:15:00.425464+00
91e602be-25b8-4fd4-9769-b307cd9af888	9317c951-459e-4c28-990c-957001b20860	2026-05-31 03:34:55.503055+00
f7fe48c3-2101-45ba-86cd-26f0bf28a923	3692907a-7089-42e0-bb9d-42745a6b6e8a	2026-05-31 06:13:54.211439+00
262a2469-eec7-470c-bd92-47874baebdea	ad11a13c-b380-47f4-8d8f-8f13013c84e9	2026-06-01 07:58:13.535014+00
627d6150-9fe6-41e4-98fd-e966fb11d5f2	9317c951-459e-4c28-990c-957001b20860	2026-06-01 07:58:14.522589+00
7be2a683-5537-41c2-b834-ea534816a945	3692907a-7089-42e0-bb9d-42745a6b6e8a	2026-06-01 07:59:02.840082+00
5e289847-fa1e-402e-8f46-863cf0d3c395	3692907a-7089-42e0-bb9d-42745a6b6e8a	2026-06-10 03:40:03.556341+00
f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	ad11a13c-b380-47f4-8d8f-8f13013c84e9	2026-06-10 04:27:12.895834+00
c4e8b2dc-daf4-47aa-a573-8383561351af	3692907a-7089-42e0-bb9d-42745a6b6e8a	2026-06-13 06:57:20.759331+00
\.

--
-- Data for Name: tien_ich; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."tien_ich" ("id", "ten", "bieu_tuong", "tao_luc") FROM stdin;
8c9ff910-1ef2-44d6-81df-93e53b229f3c	dieuhoa	\N	2026-05-30 04:25:22.121208+00
da04a7dd-c0ad-4799-9b3c-7c2ea881a448	nonglanh	\N	2026-05-24 07:19:39.486019+00
988937e2-6351-48a9-b1f6-db5b99b2409c	tulanh	\N	2026-05-25 02:10:10.012441+00
9e208ba0-9c35-45f6-9584-bd6d8d8a6557	tuquanao	\N	2026-05-25 02:10:10.012441+00
141e6311-d00c-4380-9c83-c91514025d2b	wifi	\N	2026-05-23 16:41:44.476966+00
6f02ce8a-9295-4d92-8de3-021585724689	giuong	\N	2026-05-30 04:25:22.121208+00
297357cd-e2c5-4149-b67e-2eb09ac2b205	Thang máy	\N	2026-06-01 18:19:11.072071+00
36456262-2d70-4399-9651-bb900ef06e75	Camera an ninh	\N	2026-06-01 18:19:11.072071+00
a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	Bảo vệ 24/7	\N	2026-06-01 18:19:11.072071+00
2c5ba5de-a379-4630-b307-d47f37861b27	Giữ xe	\N	2026-06-01 18:19:11.072071+00
f8405f97-3d22-4ed1-8a3a-0987fb4a8f1c	Bát		2026-05-31 04:30:14.665922+00
d9d145df-344d-423e-8954-af3d3577812e	Khu bếp chung	\N	2026-06-01 18:19:11.072071+00
e10c7805-4a3e-4025-be61-e52386f86d34	noi	\N	2026-06-01 02:49:44.492466+00
eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	tivi	\N	2026-05-23 17:03:45.635831+00
04d13a37-04ee-49d6-a915-b4a768026b8b	Tủ Lạnh	\N	2026-05-23 16:41:44.476966+00
1ce428dd-3a53-4a9e-bb09-49ea93c22be1	Nóng Lạnh	\N	2026-05-23 16:49:46.489765+00
886d78a4-4787-4e6b-9097-ec705872b255	Tủ Quần Áo	\N	2026-05-23 16:49:46.489765+00
891a47ab-7249-4ad1-b77e-1fe4752bdfdd	Nồi	\N	2026-05-23 16:50:38.016306+00
eeeeeeee-eeee-eeee-eeee-eeeeeeeeee10	Máy Giặt	\N	2026-05-23 17:03:45.635831+00
eeeeeeee-eeee-eeee-eeee-eeeeeeeeee13	Chén	\N	2026-05-23 17:03:45.635831+00
eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee1	Điều Hòa	\N	2026-05-23 17:03:45.635831+00
43650019-be71-4968-b880-fa9fdd5993b0	banlamviec	\N	2026-06-01 02:49:44.492466+00
8b4b3851-e596-4098-ae56-b815b15c70b3	bep	\N	2026-06-01 18:19:11.072071+00
fb2e23f1-c296-4d07-bf5e-edbb44caa342	ghe	\N	2026-06-01 18:19:11.072071+00
5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	maygiat	\N	2026-06-01 18:19:11.072071+00
7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	Điều hòa	\N	2026-06-01 18:23:25.597482+00
79716129-495a-47e4-9034-30dc36a7cef9	Tủ lạnh	\N	2026-06-01 18:23:25.597482+00
eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	Giường	\N	2026-05-23 17:03:45.635831+00
92c3ef86-c8c3-4409-9441-6afe7cf9da41	Nóng lạnh	\N	2026-06-01 18:23:25.597482+00
a87021fa-a456-48b7-ac63-207ffd5de676	Tủ quần áo	\N	2026-06-01 18:23:25.597482+00
021d0812-a29f-4291-b2ac-8c223839e8a9	WiFi	\N	2026-06-01 18:19:11.072071+00
795cd8f4-3e11-4d27-9941-c50c18059809	Máy giặt	\N	2026-06-01 18:23:25.597482+00
ff7f4393-efbe-49f6-9058-9a6f16a55927	Bàn làm việc	\N	2026-06-01 18:23:25.597482+00
eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	Ghế	\N	2026-05-23 17:03:45.635831+00
77163a8d-76ab-4921-b611-4c443d7b24e1	TV	\N	2026-06-01 18:23:25.597482+00
eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	Bếp	\N	2026-05-23 17:03:45.635831+00
\.

--
-- Data for Name: phong_tien_ich; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."phong_tien_ich" ("phong_id", "tien_ich_id", "tao_luc") FROM stdin;
e30e4555-7e6c-4c7b-8cdf-c8c57145c75d	04d13a37-04ee-49d6-a915-b4a768026b8b	2026-05-23 16:41:45.892652+00
e30e4555-7e6c-4c7b-8cdf-c8c57145c75d	141e6311-d00c-4380-9c83-c91514025d2b	2026-05-23 16:41:45.892652+00
659998c6-e8c1-4ae8-ba7e-4ebb8f454ec2	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-05-30 07:31:34.621023+00
659998c6-e8c1-4ae8-ba7e-4ebb8f454ec2	6f02ce8a-9295-4d92-8de3-021585724689	2026-05-30 07:31:34.621023+00
659998c6-e8c1-4ae8-ba7e-4ebb8f454ec2	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-05-30 07:31:34.621023+00
659998c6-e8c1-4ae8-ba7e-4ebb8f454ec2	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-05-30 07:31:34.621023+00
659998c6-e8c1-4ae8-ba7e-4ebb8f454ec2	141e6311-d00c-4380-9c83-c91514025d2b	2026-05-30 07:31:34.621023+00
48ef0756-c05a-44fa-b4b0-d3f249f564d0	891a47ab-7249-4ad1-b77e-1fe4752bdfdd	2026-05-23 18:10:13.447652+00
48ef0756-c05a-44fa-b4b0-d3f249f564d0	1ce428dd-3a53-4a9e-bb09-49ea93c22be1	2026-05-23 18:10:13.447652+00
48ef0756-c05a-44fa-b4b0-d3f249f564d0	04d13a37-04ee-49d6-a915-b4a768026b8b	2026-05-23 18:10:13.447652+00
48ef0756-c05a-44fa-b4b0-d3f249f564d0	886d78a4-4787-4e6b-9097-ec705872b255	2026-05-23 18:10:13.447652+00
48ef0756-c05a-44fa-b4b0-d3f249f564d0	141e6311-d00c-4380-9c83-c91514025d2b	2026-05-23 18:10:13.447652+00
5ef2849e-2240-48b0-b54d-1ff2e7c94c11	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-05-30 07:34:46.866047+00
5ef2849e-2240-48b0-b54d-1ff2e7c94c11	6f02ce8a-9295-4d92-8de3-021585724689	2026-05-30 07:34:46.866047+00
5ef2849e-2240-48b0-b54d-1ff2e7c94c11	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-05-30 07:34:46.866047+00
5ef2849e-2240-48b0-b54d-1ff2e7c94c11	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-05-30 07:34:46.866047+00
5ef2849e-2240-48b0-b54d-1ff2e7c94c11	141e6311-d00c-4380-9c83-c91514025d2b	2026-05-30 07:34:46.866047+00
6dd938e2-dba5-4e98-8e1f-24dbb4cdb847	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-05-24 07:20:34.963119+00
6dd938e2-dba5-4e98-8e1f-24dbb4cdb847	141e6311-d00c-4380-9c83-c91514025d2b	2026-05-24 07:20:34.963119+00
747f8d83-d8c2-4e69-8091-36ca3ec77b1c	141e6311-d00c-4380-9c83-c91514025d2b	2026-05-31 03:37:03.483123+00
738896ea-3b09-4cab-8f71-5437c3392998	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 02:49:44.492466+00
738896ea-3b09-4cab-8f71-5437c3392998	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 02:49:44.492466+00
738896ea-3b09-4cab-8f71-5437c3392998	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 02:49:44.492466+00
738896ea-3b09-4cab-8f71-5437c3392998	e10c7805-4a3e-4025-be61-e52386f86d34	2026-06-01 02:49:44.492466+00
ac58f1da-64bb-4524-a104-42be15b02f3b	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-05-25 02:10:10.012441+00
ac58f1da-64bb-4524-a104-42be15b02f3b	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-05-25 02:10:10.012441+00
ac58f1da-64bb-4524-a104-42be15b02f3b	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-05-25 02:10:10.012441+00
6c081d7b-7504-4500-bd56-4019bea9350c	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
6c081d7b-7504-4500-bd56-4019bea9350c	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
ac58f1da-64bb-4524-a104-42be15b02f3b	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-05-25 02:10:10.012441+00
6c081d7b-7504-4500-bd56-4019bea9350c	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
ac58f1da-64bb-4524-a104-42be15b02f3b	141e6311-d00c-4380-9c83-c91514025d2b	2026-05-25 02:10:10.012441+00
6c081d7b-7504-4500-bd56-4019bea9350c	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
6c081d7b-7504-4500-bd56-4019bea9350c	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
6c081d7b-7504-4500-bd56-4019bea9350c	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
acd7eb9a-4e0e-4056-91f1-50e0b8881240	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-05-27 02:00:56.074087+00
acd7eb9a-4e0e-4056-91f1-50e0b8881240	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-05-27 02:00:56.074087+00
acd7eb9a-4e0e-4056-91f1-50e0b8881240	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-05-27 02:00:56.074087+00
6c081d7b-7504-4500-bd56-4019bea9350c	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
6c081d7b-7504-4500-bd56-4019bea9350c	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
acd7eb9a-4e0e-4056-91f1-50e0b8881240	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-05-27 02:00:56.074087+00
6c081d7b-7504-4500-bd56-4019bea9350c	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
acd7eb9a-4e0e-4056-91f1-50e0b8881240	141e6311-d00c-4380-9c83-c91514025d2b	2026-05-27 02:00:56.074087+00
6c081d7b-7504-4500-bd56-4019bea9350c	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
6c081d7b-7504-4500-bd56-4019bea9350c	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
6c081d7b-7504-4500-bd56-4019bea9350c	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
6c081d7b-7504-4500-bd56-4019bea9350c	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
6c081d7b-7504-4500-bd56-4019bea9350c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
6c081d7b-7504-4500-bd56-4019bea9350c	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
6c081d7b-7504-4500-bd56-4019bea9350c	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
6c081d7b-7504-4500-bd56-4019bea9350c	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
8f54a087-577a-476b-8c74-cb4e6d0c35f0	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-05-27 02:08:06.330466+00
8f54a087-577a-476b-8c74-cb4e6d0c35f0	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-05-27 02:08:06.330466+00
8f54a087-577a-476b-8c74-cb4e6d0c35f0	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-05-27 02:08:06.330466+00
8f54a087-577a-476b-8c74-cb4e6d0c35f0	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-05-27 02:08:06.330466+00
8f54a087-577a-476b-8c74-cb4e6d0c35f0	141e6311-d00c-4380-9c83-c91514025d2b	2026-05-27 02:08:06.330466+00
6da2b6de-ec29-478b-9022-70f6a6342c0e	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
15d3243b-8647-47c4-965d-21a24ae4050d	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
15d3243b-8647-47c4-965d-21a24ae4050d	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
f776bab1-2a8e-411e-823d-fa16270da89e	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-05-27 02:10:44.409955+00
f776bab1-2a8e-411e-823d-fa16270da89e	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-05-27 02:10:44.409955+00
15d3243b-8647-47c4-965d-21a24ae4050d	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
15d3243b-8647-47c4-965d-21a24ae4050d	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
f776bab1-2a8e-411e-823d-fa16270da89e	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-05-27 02:10:44.409955+00
15d3243b-8647-47c4-965d-21a24ae4050d	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
f776bab1-2a8e-411e-823d-fa16270da89e	141e6311-d00c-4380-9c83-c91514025d2b	2026-05-27 02:10:44.409955+00
15d3243b-8647-47c4-965d-21a24ae4050d	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
15d3243b-8647-47c4-965d-21a24ae4050d	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
15d3243b-8647-47c4-965d-21a24ae4050d	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
15d3243b-8647-47c4-965d-21a24ae4050d	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
15d3243b-8647-47c4-965d-21a24ae4050d	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
15d3243b-8647-47c4-965d-21a24ae4050d	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
15d3243b-8647-47c4-965d-21a24ae4050d	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
15d3243b-8647-47c4-965d-21a24ae4050d	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
15d3243b-8647-47c4-965d-21a24ae4050d	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
15d3243b-8647-47c4-965d-21a24ae4050d	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
15d3243b-8647-47c4-965d-21a24ae4050d	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
15d3243b-8647-47c4-965d-21a24ae4050d	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
c6e2afe1-d75f-4434-a935-e3e6bbc62f5a	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
113c2587-c00f-4c5c-b9c4-0d3728a632b6	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
f20d54ad-694a-4639-b44e-b9312ec165df	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
9a43216a-4010-4a2a-a4fa-bac563cc738e	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
63348357-a443-463a-9e45-9c8b5628aaa5	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
7c9220f4-948a-47d3-b948-d73fa6b6d322	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
cb2739e8-c9ba-4f11-8e5d-8254d28656dd	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
3fe6c075-4ab6-4675-bf50-7d798a43b5ad	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
d828fe52-325e-4013-b3c9-99153744c002	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
e4df1bcd-65af-4f1a-b55b-597dd38663e7	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
6b5c22f9-cdfd-4471-bc25-109bfe7ae73b	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
6a5c8c62-55d4-4e51-95c3-75212bfda869	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
9f2ca61f-0b37-489a-946e-75d11caff2d5	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
a3f532e7-00a3-44b8-9503-e70f66f5236f	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
06190d62-ab23-4809-bac3-0b09780ee749	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
76833a35-2ea9-42cf-8810-5589be39495b	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
4cd6a11d-368e-4e9e-87b4-e12d29d109f6	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
7be2c80e-7efc-4cf1-bd17-8984323a0e47	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
5c64724d-0452-4519-83f5-2d9f2aa356bd	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
70bd43ac-e518-4cb5-90ef-0fbdac8d1c19	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
0d229d9d-201d-4b3f-978f-9ed5b02b44a0	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
69c4b475-4f33-4d24-b9c2-bcb8b0f2a731	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
be9bb88a-416b-4c25-a6c3-7a66b4b1c627	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
591c8cbe-0bb7-4be1-b2bb-286147a4e215	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
5f447d0b-0633-497b-aff6-4eb4ae3cd55b	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
eb5c9128-5a07-49cc-a4c2-c6f5ecabf958	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.072071+00
6183a025-92bb-47b9-b581-4151a0585a2c	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.072071+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
4dd64abd-0fac-47f7-b4ec-853a5501726f	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
011ae8dd-fb53-4857-8a5f-1d1d9b81843f	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
f4461d85-bfbb-4cf8-aa27-752367c8f274	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
b48397ae-e617-438c-b2e9-b6acfc2e2b59	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
6c630751-8020-4457-af88-4cce8d42609c	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
60e6a72b-5ad3-4f9d-b194-a5b1933cb1d9	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
202ef8f3-71c7-491d-8f4d-3af7dab5569e	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
4addaaa5-9dbd-4ec2-8770-5ba576f608d7	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
14f9e931-7065-4e19-a9d0-ef99abb09e36	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
c5f81627-9bdb-4ff7-9cf0-4ec7afbd02a9	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
b42232b8-545d-4fa1-aaed-8c2b8e05898c	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
1b84150e-7f49-47ce-a857-4e5f42c23196	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
941a5a87-475f-421f-85f8-9202e4514616	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
bb0c0445-82f3-4df1-9b46-277d41dac414	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
495890df-2b7b-4e3a-a6cc-0f6aafea1bbd	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
9375f873-9e78-4bc9-9a94-b2b13143f3ef	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
970d78dd-64e7-4033-a8f1-0cb5e537bb43	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
bac1bbc4-925e-481d-a4c9-1edc0b726fb1	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
8d7c0d95-1a3a-4b31-b393-c9146d9546ff	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
f234f602-db47-4d6b-af57-843059bd5042	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
d7a48670-9149-4882-a8b4-eb25a1774e1d	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
3883fd77-d7cf-472f-8f2d-6624a24ce399	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
c1adaa94-cab9-420c-8d18-dafbb127ae9d	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
22273668-4a89-466d-b9af-170555385d89	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
35b5374c-a3ec-4256-9b25-9a748641f27f	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
ac31dcb1-552e-42f5-8716-401aec5cf15e	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
63c3369b-2d60-4fc9-aedf-8e6567e627b2	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
2c789132-952b-4456-87f7-4977403ca50e	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
03633568-e1e7-48ad-8502-dc8f80c41ee4	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	297357cd-e2c5-4149-b67e-2eb09ac2b205	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	36456262-2d70-4399-9651-bb900ef06e75	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	a88943b1-f9f4-4a10-b27a-6f5ac22b0a03	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	2c5ba5de-a379-4630-b307-d47f37861b27	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	d9d145df-344d-423e-8954-af3d3577812e	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee8	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-01 18:19:11.807229+00
0f34ff4f-3bdc-497a-a6a4-0f2eb3d4452f	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-01 18:19:11.807229+00
f28db6d1-1bd2-45a0-ac71-32c68a48413d	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
f28db6d1-1bd2-45a0-ac71-32c68a48413d	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
f28db6d1-1bd2-45a0-ac71-32c68a48413d	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
f28db6d1-1bd2-45a0-ac71-32c68a48413d	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
f28db6d1-1bd2-45a0-ac71-32c68a48413d	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
f28db6d1-1bd2-45a0-ac71-32c68a48413d	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
f28db6d1-1bd2-45a0-ac71-32c68a48413d	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
f28db6d1-1bd2-45a0-ac71-32c68a48413d	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
f28db6d1-1bd2-45a0-ac71-32c68a48413d	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
f28db6d1-1bd2-45a0-ac71-32c68a48413d	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
f28db6d1-1bd2-45a0-ac71-32c68a48413d	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
797863e7-d0b4-4a7a-ad8a-7339fa613c12	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
797863e7-d0b4-4a7a-ad8a-7339fa613c12	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
797863e7-d0b4-4a7a-ad8a-7339fa613c12	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
797863e7-d0b4-4a7a-ad8a-7339fa613c12	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
797863e7-d0b4-4a7a-ad8a-7339fa613c12	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
797863e7-d0b4-4a7a-ad8a-7339fa613c12	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
797863e7-d0b4-4a7a-ad8a-7339fa613c12	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
797863e7-d0b4-4a7a-ad8a-7339fa613c12	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
797863e7-d0b4-4a7a-ad8a-7339fa613c12	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
797863e7-d0b4-4a7a-ad8a-7339fa613c12	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
797863e7-d0b4-4a7a-ad8a-7339fa613c12	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
28a46d86-12c0-4ceb-830f-537cfbda6692	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
28a46d86-12c0-4ceb-830f-537cfbda6692	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
28a46d86-12c0-4ceb-830f-537cfbda6692	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
28a46d86-12c0-4ceb-830f-537cfbda6692	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
28a46d86-12c0-4ceb-830f-537cfbda6692	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
28a46d86-12c0-4ceb-830f-537cfbda6692	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
28a46d86-12c0-4ceb-830f-537cfbda6692	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
28a46d86-12c0-4ceb-830f-537cfbda6692	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
28a46d86-12c0-4ceb-830f-537cfbda6692	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
28a46d86-12c0-4ceb-830f-537cfbda6692	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
28a46d86-12c0-4ceb-830f-537cfbda6692	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
43aabfbf-3a47-4587-a59f-0af58c29d19b	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
43aabfbf-3a47-4587-a59f-0af58c29d19b	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
43aabfbf-3a47-4587-a59f-0af58c29d19b	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
43aabfbf-3a47-4587-a59f-0af58c29d19b	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
43aabfbf-3a47-4587-a59f-0af58c29d19b	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
43aabfbf-3a47-4587-a59f-0af58c29d19b	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
43aabfbf-3a47-4587-a59f-0af58c29d19b	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
43aabfbf-3a47-4587-a59f-0af58c29d19b	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
43aabfbf-3a47-4587-a59f-0af58c29d19b	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
43aabfbf-3a47-4587-a59f-0af58c29d19b	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
43aabfbf-3a47-4587-a59f-0af58c29d19b	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
2bc25442-64a4-463b-918b-314b18f1df6a	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
2bc25442-64a4-463b-918b-314b18f1df6a	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
2bc25442-64a4-463b-918b-314b18f1df6a	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
2bc25442-64a4-463b-918b-314b18f1df6a	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
2bc25442-64a4-463b-918b-314b18f1df6a	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
2bc25442-64a4-463b-918b-314b18f1df6a	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
2bc25442-64a4-463b-918b-314b18f1df6a	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
2bc25442-64a4-463b-918b-314b18f1df6a	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
2bc25442-64a4-463b-918b-314b18f1df6a	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
2bc25442-64a4-463b-918b-314b18f1df6a	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
2bc25442-64a4-463b-918b-314b18f1df6a	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
d8376ec7-f5a7-47cf-a33f-b789c283f54f	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
d8376ec7-f5a7-47cf-a33f-b789c283f54f	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
d8376ec7-f5a7-47cf-a33f-b789c283f54f	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
d8376ec7-f5a7-47cf-a33f-b789c283f54f	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
d8376ec7-f5a7-47cf-a33f-b789c283f54f	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
d8376ec7-f5a7-47cf-a33f-b789c283f54f	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
d8376ec7-f5a7-47cf-a33f-b789c283f54f	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
d8376ec7-f5a7-47cf-a33f-b789c283f54f	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
d8376ec7-f5a7-47cf-a33f-b789c283f54f	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
d8376ec7-f5a7-47cf-a33f-b789c283f54f	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
d8376ec7-f5a7-47cf-a33f-b789c283f54f	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
f0ccc6bd-3043-41fe-89be-a765c9d776a4	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
f0ccc6bd-3043-41fe-89be-a765c9d776a4	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
f0ccc6bd-3043-41fe-89be-a765c9d776a4	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
f0ccc6bd-3043-41fe-89be-a765c9d776a4	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
f0ccc6bd-3043-41fe-89be-a765c9d776a4	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
f0ccc6bd-3043-41fe-89be-a765c9d776a4	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
f0ccc6bd-3043-41fe-89be-a765c9d776a4	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
f0ccc6bd-3043-41fe-89be-a765c9d776a4	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
f0ccc6bd-3043-41fe-89be-a765c9d776a4	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
f0ccc6bd-3043-41fe-89be-a765c9d776a4	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
f0ccc6bd-3043-41fe-89be-a765c9d776a4	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
c1d43028-6ecd-4bfc-9f7b-126ba6f8641f	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
c1d43028-6ecd-4bfc-9f7b-126ba6f8641f	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
c1d43028-6ecd-4bfc-9f7b-126ba6f8641f	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
c1d43028-6ecd-4bfc-9f7b-126ba6f8641f	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
c1d43028-6ecd-4bfc-9f7b-126ba6f8641f	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
c1d43028-6ecd-4bfc-9f7b-126ba6f8641f	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
c1d43028-6ecd-4bfc-9f7b-126ba6f8641f	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
c1d43028-6ecd-4bfc-9f7b-126ba6f8641f	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
c1d43028-6ecd-4bfc-9f7b-126ba6f8641f	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
c1d43028-6ecd-4bfc-9f7b-126ba6f8641f	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
c1d43028-6ecd-4bfc-9f7b-126ba6f8641f	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
1364bdc3-d951-4a73-9963-b8e9a077a389	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
1364bdc3-d951-4a73-9963-b8e9a077a389	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
1364bdc3-d951-4a73-9963-b8e9a077a389	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
1364bdc3-d951-4a73-9963-b8e9a077a389	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
1364bdc3-d951-4a73-9963-b8e9a077a389	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
1364bdc3-d951-4a73-9963-b8e9a077a389	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
1364bdc3-d951-4a73-9963-b8e9a077a389	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
1364bdc3-d951-4a73-9963-b8e9a077a389	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
1364bdc3-d951-4a73-9963-b8e9a077a389	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
1364bdc3-d951-4a73-9963-b8e9a077a389	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
1364bdc3-d951-4a73-9963-b8e9a077a389	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
ae7a7422-2a8d-43ea-9fa2-443fd6ef7eed	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
ae7a7422-2a8d-43ea-9fa2-443fd6ef7eed	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
ae7a7422-2a8d-43ea-9fa2-443fd6ef7eed	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
ae7a7422-2a8d-43ea-9fa2-443fd6ef7eed	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
ae7a7422-2a8d-43ea-9fa2-443fd6ef7eed	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
ae7a7422-2a8d-43ea-9fa2-443fd6ef7eed	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
ae7a7422-2a8d-43ea-9fa2-443fd6ef7eed	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
ae7a7422-2a8d-43ea-9fa2-443fd6ef7eed	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
ae7a7422-2a8d-43ea-9fa2-443fd6ef7eed	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
ae7a7422-2a8d-43ea-9fa2-443fd6ef7eed	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
ae7a7422-2a8d-43ea-9fa2-443fd6ef7eed	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
d84a5906-44ff-43ff-853b-5cfd2b562412	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
d84a5906-44ff-43ff-853b-5cfd2b562412	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
d84a5906-44ff-43ff-853b-5cfd2b562412	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
d84a5906-44ff-43ff-853b-5cfd2b562412	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
d84a5906-44ff-43ff-853b-5cfd2b562412	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
d84a5906-44ff-43ff-853b-5cfd2b562412	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
d84a5906-44ff-43ff-853b-5cfd2b562412	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
d84a5906-44ff-43ff-853b-5cfd2b562412	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
d84a5906-44ff-43ff-853b-5cfd2b562412	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
d84a5906-44ff-43ff-853b-5cfd2b562412	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
d84a5906-44ff-43ff-853b-5cfd2b562412	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
4433637a-0cf4-4c26-ba8a-ce5c78af5526	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
4433637a-0cf4-4c26-ba8a-ce5c78af5526	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
4433637a-0cf4-4c26-ba8a-ce5c78af5526	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
4433637a-0cf4-4c26-ba8a-ce5c78af5526	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
4433637a-0cf4-4c26-ba8a-ce5c78af5526	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
4433637a-0cf4-4c26-ba8a-ce5c78af5526	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
4433637a-0cf4-4c26-ba8a-ce5c78af5526	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
4433637a-0cf4-4c26-ba8a-ce5c78af5526	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
4433637a-0cf4-4c26-ba8a-ce5c78af5526	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
4433637a-0cf4-4c26-ba8a-ce5c78af5526	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
4433637a-0cf4-4c26-ba8a-ce5c78af5526	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
726e329b-5a55-4932-b4c6-1f49ab90bbea	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
726e329b-5a55-4932-b4c6-1f49ab90bbea	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
726e329b-5a55-4932-b4c6-1f49ab90bbea	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
726e329b-5a55-4932-b4c6-1f49ab90bbea	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
726e329b-5a55-4932-b4c6-1f49ab90bbea	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
726e329b-5a55-4932-b4c6-1f49ab90bbea	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
726e329b-5a55-4932-b4c6-1f49ab90bbea	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
726e329b-5a55-4932-b4c6-1f49ab90bbea	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
726e329b-5a55-4932-b4c6-1f49ab90bbea	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
726e329b-5a55-4932-b4c6-1f49ab90bbea	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
726e329b-5a55-4932-b4c6-1f49ab90bbea	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
6f291510-7198-4d86-8025-f8897d7938b5	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
6f291510-7198-4d86-8025-f8897d7938b5	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
6f291510-7198-4d86-8025-f8897d7938b5	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
6f291510-7198-4d86-8025-f8897d7938b5	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
6f291510-7198-4d86-8025-f8897d7938b5	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
6f291510-7198-4d86-8025-f8897d7938b5	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
6f291510-7198-4d86-8025-f8897d7938b5	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
6f291510-7198-4d86-8025-f8897d7938b5	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
6f291510-7198-4d86-8025-f8897d7938b5	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
6f291510-7198-4d86-8025-f8897d7938b5	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
6f291510-7198-4d86-8025-f8897d7938b5	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
fcf8a87b-77d7-4134-adb5-dc4bc9df8db5	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
fcf8a87b-77d7-4134-adb5-dc4bc9df8db5	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
fcf8a87b-77d7-4134-adb5-dc4bc9df8db5	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
fcf8a87b-77d7-4134-adb5-dc4bc9df8db5	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
fcf8a87b-77d7-4134-adb5-dc4bc9df8db5	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
fcf8a87b-77d7-4134-adb5-dc4bc9df8db5	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
fcf8a87b-77d7-4134-adb5-dc4bc9df8db5	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
fcf8a87b-77d7-4134-adb5-dc4bc9df8db5	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
fcf8a87b-77d7-4134-adb5-dc4bc9df8db5	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
fcf8a87b-77d7-4134-adb5-dc4bc9df8db5	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
fcf8a87b-77d7-4134-adb5-dc4bc9df8db5	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
98f54a91-ea09-4ea9-b45c-19da1fe41beb	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
98f54a91-ea09-4ea9-b45c-19da1fe41beb	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
98f54a91-ea09-4ea9-b45c-19da1fe41beb	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
98f54a91-ea09-4ea9-b45c-19da1fe41beb	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
98f54a91-ea09-4ea9-b45c-19da1fe41beb	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
98f54a91-ea09-4ea9-b45c-19da1fe41beb	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
98f54a91-ea09-4ea9-b45c-19da1fe41beb	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
98f54a91-ea09-4ea9-b45c-19da1fe41beb	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
98f54a91-ea09-4ea9-b45c-19da1fe41beb	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
98f54a91-ea09-4ea9-b45c-19da1fe41beb	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
98f54a91-ea09-4ea9-b45c-19da1fe41beb	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
27adfedf-3170-4378-acda-b8d310d130f0	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
27adfedf-3170-4378-acda-b8d310d130f0	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
27adfedf-3170-4378-acda-b8d310d130f0	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
27adfedf-3170-4378-acda-b8d310d130f0	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
27adfedf-3170-4378-acda-b8d310d130f0	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
27adfedf-3170-4378-acda-b8d310d130f0	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
27adfedf-3170-4378-acda-b8d310d130f0	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
27adfedf-3170-4378-acda-b8d310d130f0	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
27adfedf-3170-4378-acda-b8d310d130f0	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
27adfedf-3170-4378-acda-b8d310d130f0	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
27adfedf-3170-4378-acda-b8d310d130f0	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
1703adbd-a7c7-4219-8b55-b3197eae9b50	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
1703adbd-a7c7-4219-8b55-b3197eae9b50	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
1703adbd-a7c7-4219-8b55-b3197eae9b50	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
1703adbd-a7c7-4219-8b55-b3197eae9b50	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
1703adbd-a7c7-4219-8b55-b3197eae9b50	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
1703adbd-a7c7-4219-8b55-b3197eae9b50	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
1703adbd-a7c7-4219-8b55-b3197eae9b50	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
1703adbd-a7c7-4219-8b55-b3197eae9b50	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
1703adbd-a7c7-4219-8b55-b3197eae9b50	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
1703adbd-a7c7-4219-8b55-b3197eae9b50	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
1703adbd-a7c7-4219-8b55-b3197eae9b50	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
4aa71440-5e43-4bf4-8c85-875e7be2e961	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
4aa71440-5e43-4bf4-8c85-875e7be2e961	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
4aa71440-5e43-4bf4-8c85-875e7be2e961	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
4aa71440-5e43-4bf4-8c85-875e7be2e961	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
4aa71440-5e43-4bf4-8c85-875e7be2e961	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
4aa71440-5e43-4bf4-8c85-875e7be2e961	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
4aa71440-5e43-4bf4-8c85-875e7be2e961	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
4aa71440-5e43-4bf4-8c85-875e7be2e961	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
4aa71440-5e43-4bf4-8c85-875e7be2e961	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
4aa71440-5e43-4bf4-8c85-875e7be2e961	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
4aa71440-5e43-4bf4-8c85-875e7be2e961	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
aa0c9dff-c075-471d-bf86-f6715a53aaa5	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
aa0c9dff-c075-471d-bf86-f6715a53aaa5	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
aa0c9dff-c075-471d-bf86-f6715a53aaa5	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
aa0c9dff-c075-471d-bf86-f6715a53aaa5	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
aa0c9dff-c075-471d-bf86-f6715a53aaa5	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
aa0c9dff-c075-471d-bf86-f6715a53aaa5	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
aa0c9dff-c075-471d-bf86-f6715a53aaa5	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
aa0c9dff-c075-471d-bf86-f6715a53aaa5	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
aa0c9dff-c075-471d-bf86-f6715a53aaa5	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
aa0c9dff-c075-471d-bf86-f6715a53aaa5	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
aa0c9dff-c075-471d-bf86-f6715a53aaa5	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
cc74678e-f511-4d1e-b7da-e07716788fe4	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
cc74678e-f511-4d1e-b7da-e07716788fe4	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
cc74678e-f511-4d1e-b7da-e07716788fe4	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
cc74678e-f511-4d1e-b7da-e07716788fe4	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
cc74678e-f511-4d1e-b7da-e07716788fe4	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
cc74678e-f511-4d1e-b7da-e07716788fe4	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
cc74678e-f511-4d1e-b7da-e07716788fe4	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
cc74678e-f511-4d1e-b7da-e07716788fe4	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
cc74678e-f511-4d1e-b7da-e07716788fe4	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
cc74678e-f511-4d1e-b7da-e07716788fe4	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
cc74678e-f511-4d1e-b7da-e07716788fe4	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
bd9a5c8b-08b2-48fe-a900-191c850b8a1a	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
bd9a5c8b-08b2-48fe-a900-191c850b8a1a	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
bd9a5c8b-08b2-48fe-a900-191c850b8a1a	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
bd9a5c8b-08b2-48fe-a900-191c850b8a1a	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
bd9a5c8b-08b2-48fe-a900-191c850b8a1a	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
bd9a5c8b-08b2-48fe-a900-191c850b8a1a	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
bd9a5c8b-08b2-48fe-a900-191c850b8a1a	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
bd9a5c8b-08b2-48fe-a900-191c850b8a1a	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
bd9a5c8b-08b2-48fe-a900-191c850b8a1a	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
bd9a5c8b-08b2-48fe-a900-191c850b8a1a	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
bd9a5c8b-08b2-48fe-a900-191c850b8a1a	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
b257cebc-cd9b-4ca8-a0dc-a3403c96d17a	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
b257cebc-cd9b-4ca8-a0dc-a3403c96d17a	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
b257cebc-cd9b-4ca8-a0dc-a3403c96d17a	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
b257cebc-cd9b-4ca8-a0dc-a3403c96d17a	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
b257cebc-cd9b-4ca8-a0dc-a3403c96d17a	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
b257cebc-cd9b-4ca8-a0dc-a3403c96d17a	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
b257cebc-cd9b-4ca8-a0dc-a3403c96d17a	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
b257cebc-cd9b-4ca8-a0dc-a3403c96d17a	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
b257cebc-cd9b-4ca8-a0dc-a3403c96d17a	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
b257cebc-cd9b-4ca8-a0dc-a3403c96d17a	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
b257cebc-cd9b-4ca8-a0dc-a3403c96d17a	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
3a495b3c-d636-4f90-8f11-733a70606745	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
3a495b3c-d636-4f90-8f11-733a70606745	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
3a495b3c-d636-4f90-8f11-733a70606745	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
3a495b3c-d636-4f90-8f11-733a70606745	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
3a495b3c-d636-4f90-8f11-733a70606745	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
3a495b3c-d636-4f90-8f11-733a70606745	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
3a495b3c-d636-4f90-8f11-733a70606745	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
3a495b3c-d636-4f90-8f11-733a70606745	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
3a495b3c-d636-4f90-8f11-733a70606745	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
3a495b3c-d636-4f90-8f11-733a70606745	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
3a495b3c-d636-4f90-8f11-733a70606745	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
9cd4c4dd-d361-4dc2-8423-71a12fedc3b7	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
9cd4c4dd-d361-4dc2-8423-71a12fedc3b7	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
9cd4c4dd-d361-4dc2-8423-71a12fedc3b7	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
9cd4c4dd-d361-4dc2-8423-71a12fedc3b7	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
9cd4c4dd-d361-4dc2-8423-71a12fedc3b7	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
9cd4c4dd-d361-4dc2-8423-71a12fedc3b7	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
9cd4c4dd-d361-4dc2-8423-71a12fedc3b7	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
9cd4c4dd-d361-4dc2-8423-71a12fedc3b7	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
9cd4c4dd-d361-4dc2-8423-71a12fedc3b7	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
9cd4c4dd-d361-4dc2-8423-71a12fedc3b7	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
9cd4c4dd-d361-4dc2-8423-71a12fedc3b7	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
446421b5-fe6d-43c7-ae40-d0b9ec2d5d56	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
446421b5-fe6d-43c7-ae40-d0b9ec2d5d56	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
446421b5-fe6d-43c7-ae40-d0b9ec2d5d56	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
446421b5-fe6d-43c7-ae40-d0b9ec2d5d56	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
446421b5-fe6d-43c7-ae40-d0b9ec2d5d56	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
446421b5-fe6d-43c7-ae40-d0b9ec2d5d56	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
446421b5-fe6d-43c7-ae40-d0b9ec2d5d56	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
446421b5-fe6d-43c7-ae40-d0b9ec2d5d56	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
446421b5-fe6d-43c7-ae40-d0b9ec2d5d56	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
446421b5-fe6d-43c7-ae40-d0b9ec2d5d56	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
446421b5-fe6d-43c7-ae40-d0b9ec2d5d56	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
423f24ad-14c9-4bd6-ab07-6c75d11d2301	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
423f24ad-14c9-4bd6-ab07-6c75d11d2301	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
423f24ad-14c9-4bd6-ab07-6c75d11d2301	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
423f24ad-14c9-4bd6-ab07-6c75d11d2301	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
423f24ad-14c9-4bd6-ab07-6c75d11d2301	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
423f24ad-14c9-4bd6-ab07-6c75d11d2301	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
423f24ad-14c9-4bd6-ab07-6c75d11d2301	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
423f24ad-14c9-4bd6-ab07-6c75d11d2301	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
423f24ad-14c9-4bd6-ab07-6c75d11d2301	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
423f24ad-14c9-4bd6-ab07-6c75d11d2301	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
423f24ad-14c9-4bd6-ab07-6c75d11d2301	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
b6f7a9e5-b8cd-4c97-9aca-3c55988bcb63	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
b6f7a9e5-b8cd-4c97-9aca-3c55988bcb63	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
b6f7a9e5-b8cd-4c97-9aca-3c55988bcb63	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
b6f7a9e5-b8cd-4c97-9aca-3c55988bcb63	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
b6f7a9e5-b8cd-4c97-9aca-3c55988bcb63	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
b6f7a9e5-b8cd-4c97-9aca-3c55988bcb63	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
b6f7a9e5-b8cd-4c97-9aca-3c55988bcb63	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
b6f7a9e5-b8cd-4c97-9aca-3c55988bcb63	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
b6f7a9e5-b8cd-4c97-9aca-3c55988bcb63	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
b6f7a9e5-b8cd-4c97-9aca-3c55988bcb63	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
b6f7a9e5-b8cd-4c97-9aca-3c55988bcb63	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
947d30dd-6721-4842-8fc7-2ac5d449dc8d	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
947d30dd-6721-4842-8fc7-2ac5d449dc8d	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
947d30dd-6721-4842-8fc7-2ac5d449dc8d	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
947d30dd-6721-4842-8fc7-2ac5d449dc8d	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
947d30dd-6721-4842-8fc7-2ac5d449dc8d	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
947d30dd-6721-4842-8fc7-2ac5d449dc8d	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
947d30dd-6721-4842-8fc7-2ac5d449dc8d	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
947d30dd-6721-4842-8fc7-2ac5d449dc8d	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
947d30dd-6721-4842-8fc7-2ac5d449dc8d	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
947d30dd-6721-4842-8fc7-2ac5d449dc8d	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
947d30dd-6721-4842-8fc7-2ac5d449dc8d	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
b1b8794a-bf6c-4b5e-addd-dfbeb02e3a18	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:23:25.597482+00
b1b8794a-bf6c-4b5e-addd-dfbeb02e3a18	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:23:25.597482+00
b1b8794a-bf6c-4b5e-addd-dfbeb02e3a18	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:23:25.597482+00
b1b8794a-bf6c-4b5e-addd-dfbeb02e3a18	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:23:25.597482+00
b1b8794a-bf6c-4b5e-addd-dfbeb02e3a18	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:23:25.597482+00
b1b8794a-bf6c-4b5e-addd-dfbeb02e3a18	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:23:25.597482+00
b1b8794a-bf6c-4b5e-addd-dfbeb02e3a18	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:23:25.597482+00
b1b8794a-bf6c-4b5e-addd-dfbeb02e3a18	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:23:25.597482+00
b1b8794a-bf6c-4b5e-addd-dfbeb02e3a18	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:23:25.597482+00
b1b8794a-bf6c-4b5e-addd-dfbeb02e3a18	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:23:25.597482+00
b1b8794a-bf6c-4b5e-addd-dfbeb02e3a18	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:23:25.597482+00
de3f5d7f-2ee8-49f3-b129-ff4db686f048	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
de3f5d7f-2ee8-49f3-b129-ff4db686f048	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
de3f5d7f-2ee8-49f3-b129-ff4db686f048	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
de3f5d7f-2ee8-49f3-b129-ff4db686f048	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
de3f5d7f-2ee8-49f3-b129-ff4db686f048	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
de3f5d7f-2ee8-49f3-b129-ff4db686f048	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
de3f5d7f-2ee8-49f3-b129-ff4db686f048	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
de3f5d7f-2ee8-49f3-b129-ff4db686f048	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
de3f5d7f-2ee8-49f3-b129-ff4db686f048	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
de3f5d7f-2ee8-49f3-b129-ff4db686f048	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
de3f5d7f-2ee8-49f3-b129-ff4db686f048	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
a1740c2a-2fe7-4916-b6e8-ebcc7adb7c80	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
a1740c2a-2fe7-4916-b6e8-ebcc7adb7c80	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
a1740c2a-2fe7-4916-b6e8-ebcc7adb7c80	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
a1740c2a-2fe7-4916-b6e8-ebcc7adb7c80	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
a1740c2a-2fe7-4916-b6e8-ebcc7adb7c80	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
a1740c2a-2fe7-4916-b6e8-ebcc7adb7c80	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
a1740c2a-2fe7-4916-b6e8-ebcc7adb7c80	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
a1740c2a-2fe7-4916-b6e8-ebcc7adb7c80	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
a1740c2a-2fe7-4916-b6e8-ebcc7adb7c80	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
a1740c2a-2fe7-4916-b6e8-ebcc7adb7c80	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
a1740c2a-2fe7-4916-b6e8-ebcc7adb7c80	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
ce3f8058-53ed-4c67-9c40-43fafef8f14d	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
ce3f8058-53ed-4c67-9c40-43fafef8f14d	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
ce3f8058-53ed-4c67-9c40-43fafef8f14d	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
ce3f8058-53ed-4c67-9c40-43fafef8f14d	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
ce3f8058-53ed-4c67-9c40-43fafef8f14d	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
ce3f8058-53ed-4c67-9c40-43fafef8f14d	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
ce3f8058-53ed-4c67-9c40-43fafef8f14d	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
ce3f8058-53ed-4c67-9c40-43fafef8f14d	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
ce3f8058-53ed-4c67-9c40-43fafef8f14d	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
ce3f8058-53ed-4c67-9c40-43fafef8f14d	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
ce3f8058-53ed-4c67-9c40-43fafef8f14d	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
428946e1-19be-4128-ba17-1800dbedbbb0	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
428946e1-19be-4128-ba17-1800dbedbbb0	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
428946e1-19be-4128-ba17-1800dbedbbb0	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
428946e1-19be-4128-ba17-1800dbedbbb0	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
428946e1-19be-4128-ba17-1800dbedbbb0	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
428946e1-19be-4128-ba17-1800dbedbbb0	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
428946e1-19be-4128-ba17-1800dbedbbb0	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
428946e1-19be-4128-ba17-1800dbedbbb0	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
428946e1-19be-4128-ba17-1800dbedbbb0	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
428946e1-19be-4128-ba17-1800dbedbbb0	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
428946e1-19be-4128-ba17-1800dbedbbb0	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
e99a9179-6b62-4fa0-8530-66f04fedd877	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
e99a9179-6b62-4fa0-8530-66f04fedd877	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
e99a9179-6b62-4fa0-8530-66f04fedd877	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
e99a9179-6b62-4fa0-8530-66f04fedd877	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
e99a9179-6b62-4fa0-8530-66f04fedd877	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
e99a9179-6b62-4fa0-8530-66f04fedd877	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
e99a9179-6b62-4fa0-8530-66f04fedd877	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
e99a9179-6b62-4fa0-8530-66f04fedd877	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
e99a9179-6b62-4fa0-8530-66f04fedd877	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
e99a9179-6b62-4fa0-8530-66f04fedd877	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
e99a9179-6b62-4fa0-8530-66f04fedd877	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
40127c13-9ed9-4ef6-a428-de6cff371cf3	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
40127c13-9ed9-4ef6-a428-de6cff371cf3	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
40127c13-9ed9-4ef6-a428-de6cff371cf3	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
40127c13-9ed9-4ef6-a428-de6cff371cf3	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
40127c13-9ed9-4ef6-a428-de6cff371cf3	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
40127c13-9ed9-4ef6-a428-de6cff371cf3	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
40127c13-9ed9-4ef6-a428-de6cff371cf3	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
40127c13-9ed9-4ef6-a428-de6cff371cf3	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
40127c13-9ed9-4ef6-a428-de6cff371cf3	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
40127c13-9ed9-4ef6-a428-de6cff371cf3	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
40127c13-9ed9-4ef6-a428-de6cff371cf3	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
f20d6421-6e39-4a5a-af24-799f32adf5ac	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
f20d6421-6e39-4a5a-af24-799f32adf5ac	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
f20d6421-6e39-4a5a-af24-799f32adf5ac	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
f20d6421-6e39-4a5a-af24-799f32adf5ac	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
f20d6421-6e39-4a5a-af24-799f32adf5ac	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
f20d6421-6e39-4a5a-af24-799f32adf5ac	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
f20d6421-6e39-4a5a-af24-799f32adf5ac	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
f20d6421-6e39-4a5a-af24-799f32adf5ac	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
f20d6421-6e39-4a5a-af24-799f32adf5ac	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
f20d6421-6e39-4a5a-af24-799f32adf5ac	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
f20d6421-6e39-4a5a-af24-799f32adf5ac	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
1c97ab0f-868a-4017-91f0-391b69b72dfe	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
1c97ab0f-868a-4017-91f0-391b69b72dfe	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
1c97ab0f-868a-4017-91f0-391b69b72dfe	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
1c97ab0f-868a-4017-91f0-391b69b72dfe	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
1c97ab0f-868a-4017-91f0-391b69b72dfe	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
1c97ab0f-868a-4017-91f0-391b69b72dfe	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
1c97ab0f-868a-4017-91f0-391b69b72dfe	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
1c97ab0f-868a-4017-91f0-391b69b72dfe	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
1c97ab0f-868a-4017-91f0-391b69b72dfe	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
1c97ab0f-868a-4017-91f0-391b69b72dfe	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
1c97ab0f-868a-4017-91f0-391b69b72dfe	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
72f8e384-22dd-43a2-ba12-75027861d2f6	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
72f8e384-22dd-43a2-ba12-75027861d2f6	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
72f8e384-22dd-43a2-ba12-75027861d2f6	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
72f8e384-22dd-43a2-ba12-75027861d2f6	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
72f8e384-22dd-43a2-ba12-75027861d2f6	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
72f8e384-22dd-43a2-ba12-75027861d2f6	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
72f8e384-22dd-43a2-ba12-75027861d2f6	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
72f8e384-22dd-43a2-ba12-75027861d2f6	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
72f8e384-22dd-43a2-ba12-75027861d2f6	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
72f8e384-22dd-43a2-ba12-75027861d2f6	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
72f8e384-22dd-43a2-ba12-75027861d2f6	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
939ebf0f-3cb4-49e0-b7a6-159331098c38	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
939ebf0f-3cb4-49e0-b7a6-159331098c38	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
939ebf0f-3cb4-49e0-b7a6-159331098c38	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
939ebf0f-3cb4-49e0-b7a6-159331098c38	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
939ebf0f-3cb4-49e0-b7a6-159331098c38	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
939ebf0f-3cb4-49e0-b7a6-159331098c38	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
939ebf0f-3cb4-49e0-b7a6-159331098c38	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
939ebf0f-3cb4-49e0-b7a6-159331098c38	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
939ebf0f-3cb4-49e0-b7a6-159331098c38	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
939ebf0f-3cb4-49e0-b7a6-159331098c38	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
939ebf0f-3cb4-49e0-b7a6-159331098c38	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
1e9100e6-7aab-4843-a87b-5de1b44a01ef	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
1e9100e6-7aab-4843-a87b-5de1b44a01ef	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
1e9100e6-7aab-4843-a87b-5de1b44a01ef	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
1e9100e6-7aab-4843-a87b-5de1b44a01ef	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
1e9100e6-7aab-4843-a87b-5de1b44a01ef	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
1e9100e6-7aab-4843-a87b-5de1b44a01ef	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
1e9100e6-7aab-4843-a87b-5de1b44a01ef	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
1e9100e6-7aab-4843-a87b-5de1b44a01ef	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
1e9100e6-7aab-4843-a87b-5de1b44a01ef	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
1e9100e6-7aab-4843-a87b-5de1b44a01ef	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
1e9100e6-7aab-4843-a87b-5de1b44a01ef	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
b115dbc3-7c67-4157-9e50-59c7d3e41601	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
b115dbc3-7c67-4157-9e50-59c7d3e41601	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
b115dbc3-7c67-4157-9e50-59c7d3e41601	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
b115dbc3-7c67-4157-9e50-59c7d3e41601	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
b115dbc3-7c67-4157-9e50-59c7d3e41601	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
b115dbc3-7c67-4157-9e50-59c7d3e41601	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
b115dbc3-7c67-4157-9e50-59c7d3e41601	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
b115dbc3-7c67-4157-9e50-59c7d3e41601	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
b115dbc3-7c67-4157-9e50-59c7d3e41601	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
b115dbc3-7c67-4157-9e50-59c7d3e41601	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
b115dbc3-7c67-4157-9e50-59c7d3e41601	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
36149d64-3e4e-4de6-b19d-d839caf621c3	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
36149d64-3e4e-4de6-b19d-d839caf621c3	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
36149d64-3e4e-4de6-b19d-d839caf621c3	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
36149d64-3e4e-4de6-b19d-d839caf621c3	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
36149d64-3e4e-4de6-b19d-d839caf621c3	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
36149d64-3e4e-4de6-b19d-d839caf621c3	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
36149d64-3e4e-4de6-b19d-d839caf621c3	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
36149d64-3e4e-4de6-b19d-d839caf621c3	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
36149d64-3e4e-4de6-b19d-d839caf621c3	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
36149d64-3e4e-4de6-b19d-d839caf621c3	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
36149d64-3e4e-4de6-b19d-d839caf621c3	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
f7f5e823-feb8-4b37-8648-3b23febb1cfb	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
f7f5e823-feb8-4b37-8648-3b23febb1cfb	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
f7f5e823-feb8-4b37-8648-3b23febb1cfb	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
f7f5e823-feb8-4b37-8648-3b23febb1cfb	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
f7f5e823-feb8-4b37-8648-3b23febb1cfb	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
f7f5e823-feb8-4b37-8648-3b23febb1cfb	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
f7f5e823-feb8-4b37-8648-3b23febb1cfb	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
f7f5e823-feb8-4b37-8648-3b23febb1cfb	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
f7f5e823-feb8-4b37-8648-3b23febb1cfb	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
f7f5e823-feb8-4b37-8648-3b23febb1cfb	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
f7f5e823-feb8-4b37-8648-3b23febb1cfb	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
29508272-592e-4191-b94e-8b432121024c	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
29508272-592e-4191-b94e-8b432121024c	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
29508272-592e-4191-b94e-8b432121024c	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
29508272-592e-4191-b94e-8b432121024c	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
29508272-592e-4191-b94e-8b432121024c	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
29508272-592e-4191-b94e-8b432121024c	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
29508272-592e-4191-b94e-8b432121024c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
29508272-592e-4191-b94e-8b432121024c	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
29508272-592e-4191-b94e-8b432121024c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
29508272-592e-4191-b94e-8b432121024c	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
29508272-592e-4191-b94e-8b432121024c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
d1f40830-6ed0-4603-a24d-98602657fc8c	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
d1f40830-6ed0-4603-a24d-98602657fc8c	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
d1f40830-6ed0-4603-a24d-98602657fc8c	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
d1f40830-6ed0-4603-a24d-98602657fc8c	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
d1f40830-6ed0-4603-a24d-98602657fc8c	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
d1f40830-6ed0-4603-a24d-98602657fc8c	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
d1f40830-6ed0-4603-a24d-98602657fc8c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
d1f40830-6ed0-4603-a24d-98602657fc8c	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
d1f40830-6ed0-4603-a24d-98602657fc8c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
d1f40830-6ed0-4603-a24d-98602657fc8c	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
d1f40830-6ed0-4603-a24d-98602657fc8c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
b91c54d3-cb7e-4024-8d3c-d76247220dfd	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
b91c54d3-cb7e-4024-8d3c-d76247220dfd	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
b91c54d3-cb7e-4024-8d3c-d76247220dfd	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
b91c54d3-cb7e-4024-8d3c-d76247220dfd	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
b91c54d3-cb7e-4024-8d3c-d76247220dfd	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
b91c54d3-cb7e-4024-8d3c-d76247220dfd	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
b91c54d3-cb7e-4024-8d3c-d76247220dfd	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
b91c54d3-cb7e-4024-8d3c-d76247220dfd	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
b91c54d3-cb7e-4024-8d3c-d76247220dfd	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
b91c54d3-cb7e-4024-8d3c-d76247220dfd	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
b91c54d3-cb7e-4024-8d3c-d76247220dfd	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
c282b339-1ed6-452c-b4ea-ee2ecef6fe9a	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
c282b339-1ed6-452c-b4ea-ee2ecef6fe9a	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
c282b339-1ed6-452c-b4ea-ee2ecef6fe9a	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
c282b339-1ed6-452c-b4ea-ee2ecef6fe9a	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
c282b339-1ed6-452c-b4ea-ee2ecef6fe9a	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
c282b339-1ed6-452c-b4ea-ee2ecef6fe9a	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
c282b339-1ed6-452c-b4ea-ee2ecef6fe9a	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
c282b339-1ed6-452c-b4ea-ee2ecef6fe9a	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
c282b339-1ed6-452c-b4ea-ee2ecef6fe9a	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
c282b339-1ed6-452c-b4ea-ee2ecef6fe9a	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
c282b339-1ed6-452c-b4ea-ee2ecef6fe9a	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
399a939b-93d0-45b6-a778-9f81f2e08dc3	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
399a939b-93d0-45b6-a778-9f81f2e08dc3	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
399a939b-93d0-45b6-a778-9f81f2e08dc3	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
399a939b-93d0-45b6-a778-9f81f2e08dc3	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
399a939b-93d0-45b6-a778-9f81f2e08dc3	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
399a939b-93d0-45b6-a778-9f81f2e08dc3	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
399a939b-93d0-45b6-a778-9f81f2e08dc3	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
399a939b-93d0-45b6-a778-9f81f2e08dc3	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
399a939b-93d0-45b6-a778-9f81f2e08dc3	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
399a939b-93d0-45b6-a778-9f81f2e08dc3	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
399a939b-93d0-45b6-a778-9f81f2e08dc3	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
ccb78430-282b-41e8-986c-cdfd7343def3	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
ccb78430-282b-41e8-986c-cdfd7343def3	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
ccb78430-282b-41e8-986c-cdfd7343def3	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
ccb78430-282b-41e8-986c-cdfd7343def3	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
ccb78430-282b-41e8-986c-cdfd7343def3	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
ccb78430-282b-41e8-986c-cdfd7343def3	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
ccb78430-282b-41e8-986c-cdfd7343def3	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
ccb78430-282b-41e8-986c-cdfd7343def3	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
ccb78430-282b-41e8-986c-cdfd7343def3	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
ccb78430-282b-41e8-986c-cdfd7343def3	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
ccb78430-282b-41e8-986c-cdfd7343def3	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
60c162b5-f2fb-4d91-b007-ba04e01555aa	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
60c162b5-f2fb-4d91-b007-ba04e01555aa	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
60c162b5-f2fb-4d91-b007-ba04e01555aa	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
60c162b5-f2fb-4d91-b007-ba04e01555aa	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
60c162b5-f2fb-4d91-b007-ba04e01555aa	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
60c162b5-f2fb-4d91-b007-ba04e01555aa	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
60c162b5-f2fb-4d91-b007-ba04e01555aa	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
60c162b5-f2fb-4d91-b007-ba04e01555aa	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
60c162b5-f2fb-4d91-b007-ba04e01555aa	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
60c162b5-f2fb-4d91-b007-ba04e01555aa	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
60c162b5-f2fb-4d91-b007-ba04e01555aa	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
755daa77-304d-4ed0-9145-0152384ffcdd	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
755daa77-304d-4ed0-9145-0152384ffcdd	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
755daa77-304d-4ed0-9145-0152384ffcdd	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
755daa77-304d-4ed0-9145-0152384ffcdd	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
755daa77-304d-4ed0-9145-0152384ffcdd	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
755daa77-304d-4ed0-9145-0152384ffcdd	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
755daa77-304d-4ed0-9145-0152384ffcdd	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
755daa77-304d-4ed0-9145-0152384ffcdd	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
755daa77-304d-4ed0-9145-0152384ffcdd	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
755daa77-304d-4ed0-9145-0152384ffcdd	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
755daa77-304d-4ed0-9145-0152384ffcdd	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
136b7d6c-3dbe-4194-b66d-4d4039bac11f	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
136b7d6c-3dbe-4194-b66d-4d4039bac11f	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
136b7d6c-3dbe-4194-b66d-4d4039bac11f	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
136b7d6c-3dbe-4194-b66d-4d4039bac11f	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
136b7d6c-3dbe-4194-b66d-4d4039bac11f	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
136b7d6c-3dbe-4194-b66d-4d4039bac11f	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
136b7d6c-3dbe-4194-b66d-4d4039bac11f	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
136b7d6c-3dbe-4194-b66d-4d4039bac11f	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
136b7d6c-3dbe-4194-b66d-4d4039bac11f	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
136b7d6c-3dbe-4194-b66d-4d4039bac11f	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
136b7d6c-3dbe-4194-b66d-4d4039bac11f	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
daaf7cf4-57c7-499e-8f8b-caf257c74bf0	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
daaf7cf4-57c7-499e-8f8b-caf257c74bf0	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
daaf7cf4-57c7-499e-8f8b-caf257c74bf0	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
daaf7cf4-57c7-499e-8f8b-caf257c74bf0	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
daaf7cf4-57c7-499e-8f8b-caf257c74bf0	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
daaf7cf4-57c7-499e-8f8b-caf257c74bf0	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
daaf7cf4-57c7-499e-8f8b-caf257c74bf0	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
daaf7cf4-57c7-499e-8f8b-caf257c74bf0	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
daaf7cf4-57c7-499e-8f8b-caf257c74bf0	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
daaf7cf4-57c7-499e-8f8b-caf257c74bf0	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
daaf7cf4-57c7-499e-8f8b-caf257c74bf0	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
6bf1e5d8-7b1f-49d2-a427-28098130c6d2	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
6bf1e5d8-7b1f-49d2-a427-28098130c6d2	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
6bf1e5d8-7b1f-49d2-a427-28098130c6d2	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
6bf1e5d8-7b1f-49d2-a427-28098130c6d2	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
6bf1e5d8-7b1f-49d2-a427-28098130c6d2	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
6bf1e5d8-7b1f-49d2-a427-28098130c6d2	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
6bf1e5d8-7b1f-49d2-a427-28098130c6d2	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
6bf1e5d8-7b1f-49d2-a427-28098130c6d2	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
6bf1e5d8-7b1f-49d2-a427-28098130c6d2	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
6bf1e5d8-7b1f-49d2-a427-28098130c6d2	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
6bf1e5d8-7b1f-49d2-a427-28098130c6d2	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
3e325a07-da5c-4b15-a1f3-ccde41772592	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
3e325a07-da5c-4b15-a1f3-ccde41772592	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
3e325a07-da5c-4b15-a1f3-ccde41772592	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
3e325a07-da5c-4b15-a1f3-ccde41772592	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
3e325a07-da5c-4b15-a1f3-ccde41772592	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
3e325a07-da5c-4b15-a1f3-ccde41772592	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
3e325a07-da5c-4b15-a1f3-ccde41772592	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
3e325a07-da5c-4b15-a1f3-ccde41772592	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
3e325a07-da5c-4b15-a1f3-ccde41772592	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
3e325a07-da5c-4b15-a1f3-ccde41772592	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
3e325a07-da5c-4b15-a1f3-ccde41772592	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
7112194a-5364-4d82-abe7-16c5daeba8c4	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
7112194a-5364-4d82-abe7-16c5daeba8c4	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
7112194a-5364-4d82-abe7-16c5daeba8c4	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
7112194a-5364-4d82-abe7-16c5daeba8c4	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
7112194a-5364-4d82-abe7-16c5daeba8c4	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
7112194a-5364-4d82-abe7-16c5daeba8c4	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
7112194a-5364-4d82-abe7-16c5daeba8c4	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
7112194a-5364-4d82-abe7-16c5daeba8c4	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
7112194a-5364-4d82-abe7-16c5daeba8c4	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
7112194a-5364-4d82-abe7-16c5daeba8c4	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
7112194a-5364-4d82-abe7-16c5daeba8c4	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
bd4b1688-e139-4d91-90dd-cdc617d02a35	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
bd4b1688-e139-4d91-90dd-cdc617d02a35	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
bd4b1688-e139-4d91-90dd-cdc617d02a35	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
bd4b1688-e139-4d91-90dd-cdc617d02a35	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
bd4b1688-e139-4d91-90dd-cdc617d02a35	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
bd4b1688-e139-4d91-90dd-cdc617d02a35	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
bd4b1688-e139-4d91-90dd-cdc617d02a35	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
bd4b1688-e139-4d91-90dd-cdc617d02a35	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
bd4b1688-e139-4d91-90dd-cdc617d02a35	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
bd4b1688-e139-4d91-90dd-cdc617d02a35	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
bd4b1688-e139-4d91-90dd-cdc617d02a35	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
6aad4238-fa3f-4823-927f-3d97d5f65d32	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
6aad4238-fa3f-4823-927f-3d97d5f65d32	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
6aad4238-fa3f-4823-927f-3d97d5f65d32	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
6aad4238-fa3f-4823-927f-3d97d5f65d32	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
6aad4238-fa3f-4823-927f-3d97d5f65d32	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
6aad4238-fa3f-4823-927f-3d97d5f65d32	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
6aad4238-fa3f-4823-927f-3d97d5f65d32	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
6aad4238-fa3f-4823-927f-3d97d5f65d32	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
6aad4238-fa3f-4823-927f-3d97d5f65d32	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
6aad4238-fa3f-4823-927f-3d97d5f65d32	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
6aad4238-fa3f-4823-927f-3d97d5f65d32	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
1707dfeb-7942-4339-a171-bbf0f87d03a8	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-01 18:41:17.81944+00
1707dfeb-7942-4339-a171-bbf0f87d03a8	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-01 18:41:17.81944+00
1707dfeb-7942-4339-a171-bbf0f87d03a8	a87021fa-a456-48b7-ac63-207ffd5de676	2026-06-01 18:41:17.81944+00
1707dfeb-7942-4339-a171-bbf0f87d03a8	021d0812-a29f-4291-b2ac-8c223839e8a9	2026-06-01 18:41:17.81944+00
1707dfeb-7942-4339-a171-bbf0f87d03a8	795cd8f4-3e11-4d27-9941-c50c18059809	2026-06-01 18:41:17.81944+00
1707dfeb-7942-4339-a171-bbf0f87d03a8	ff7f4393-efbe-49f6-9058-9a6f16a55927	2026-06-01 18:41:17.81944+00
1707dfeb-7942-4339-a171-bbf0f87d03a8	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee7	2026-06-01 18:41:17.81944+00
1707dfeb-7942-4339-a171-bbf0f87d03a8	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-01 18:41:17.81944+00
1707dfeb-7942-4339-a171-bbf0f87d03a8	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-01 18:41:17.81944+00
1707dfeb-7942-4339-a171-bbf0f87d03a8	77163a8d-76ab-4921-b611-4c443d7b24e1	2026-06-01 18:41:17.81944+00
1707dfeb-7942-4339-a171-bbf0f87d03a8	eeeeeeee-eeee-eeee-eeee-eeeeeeeeee11	2026-06-01 18:41:17.81944+00
6a5d456b-8e8f-4729-9cf8-35b05359a9ef	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
6a5d456b-8e8f-4729-9cf8-35b05359a9ef	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
6a5d456b-8e8f-4729-9cf8-35b05359a9ef	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
6a5d456b-8e8f-4729-9cf8-35b05359a9ef	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
010b0a7c-86ca-424b-bef7-e99b6d8041c7	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
010b0a7c-86ca-424b-bef7-e99b6d8041c7	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
010b0a7c-86ca-424b-bef7-e99b6d8041c7	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
010b0a7c-86ca-424b-bef7-e99b6d8041c7	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
beed032b-9881-4f4c-9dd5-786da9ba1115	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
beed032b-9881-4f4c-9dd5-786da9ba1115	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
beed032b-9881-4f4c-9dd5-786da9ba1115	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
beed032b-9881-4f4c-9dd5-786da9ba1115	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
bf722b52-1633-4aca-9902-de83310f5ebf	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
bf722b52-1633-4aca-9902-de83310f5ebf	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
bf722b52-1633-4aca-9902-de83310f5ebf	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
bf722b52-1633-4aca-9902-de83310f5ebf	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
d60df1f5-d6b4-4e70-beb9-e90abbb3ccd3	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
d60df1f5-d6b4-4e70-beb9-e90abbb3ccd3	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
d60df1f5-d6b4-4e70-beb9-e90abbb3ccd3	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
d60df1f5-d6b4-4e70-beb9-e90abbb3ccd3	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
19d05db6-eb97-4267-bc88-1599e3b3b829	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
19d05db6-eb97-4267-bc88-1599e3b3b829	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
19d05db6-eb97-4267-bc88-1599e3b3b829	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
19d05db6-eb97-4267-bc88-1599e3b3b829	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
4160dd24-4d87-4c6f-97fd-712b4cdbc4c9	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
4160dd24-4d87-4c6f-97fd-712b4cdbc4c9	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
4160dd24-4d87-4c6f-97fd-712b4cdbc4c9	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
4160dd24-4d87-4c6f-97fd-712b4cdbc4c9	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
5e5be979-e1e7-4ca6-b751-131efad44b43	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
5e5be979-e1e7-4ca6-b751-131efad44b43	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
5e5be979-e1e7-4ca6-b751-131efad44b43	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
5e5be979-e1e7-4ca6-b751-131efad44b43	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
348ec413-0b86-47b7-9fb8-4c8b84b8920c	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
348ec413-0b86-47b7-9fb8-4c8b84b8920c	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
348ec413-0b86-47b7-9fb8-4c8b84b8920c	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
348ec413-0b86-47b7-9fb8-4c8b84b8920c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
56ad0c8a-a4cc-4d03-8d76-74ed1f9b45e7	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
56ad0c8a-a4cc-4d03-8d76-74ed1f9b45e7	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
56ad0c8a-a4cc-4d03-8d76-74ed1f9b45e7	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
56ad0c8a-a4cc-4d03-8d76-74ed1f9b45e7	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
d4d5b622-4ca4-4a03-bb28-97e2120dd9e4	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
d4d5b622-4ca4-4a03-bb28-97e2120dd9e4	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
d4d5b622-4ca4-4a03-bb28-97e2120dd9e4	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
d4d5b622-4ca4-4a03-bb28-97e2120dd9e4	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
e6a78b1a-f229-4b70-b30c-022a6b83219b	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
e6a78b1a-f229-4b70-b30c-022a6b83219b	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
e6a78b1a-f229-4b70-b30c-022a6b83219b	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
e6a78b1a-f229-4b70-b30c-022a6b83219b	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
39e6e488-d55d-4e98-8223-e831a2531642	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
39e6e488-d55d-4e98-8223-e831a2531642	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
39e6e488-d55d-4e98-8223-e831a2531642	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
39e6e488-d55d-4e98-8223-e831a2531642	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
521b2bea-5333-4377-87d7-7ec344bb015f	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
521b2bea-5333-4377-87d7-7ec344bb015f	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
521b2bea-5333-4377-87d7-7ec344bb015f	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
521b2bea-5333-4377-87d7-7ec344bb015f	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
401ff83b-5e99-4708-a97b-30b3fa712703	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
401ff83b-5e99-4708-a97b-30b3fa712703	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
401ff83b-5e99-4708-a97b-30b3fa712703	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
401ff83b-5e99-4708-a97b-30b3fa712703	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
cf37fa79-973f-41cc-b398-16c824eb5771	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
cf37fa79-973f-41cc-b398-16c824eb5771	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
cf37fa79-973f-41cc-b398-16c824eb5771	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
cf37fa79-973f-41cc-b398-16c824eb5771	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
aac69282-fec3-481b-ae58-0d79e8985977	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
aac69282-fec3-481b-ae58-0d79e8985977	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
aac69282-fec3-481b-ae58-0d79e8985977	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
aac69282-fec3-481b-ae58-0d79e8985977	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
cc622fd0-d36b-4eb3-88f0-783f00ba42c9	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
cc622fd0-d36b-4eb3-88f0-783f00ba42c9	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
cc622fd0-d36b-4eb3-88f0-783f00ba42c9	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
cc622fd0-d36b-4eb3-88f0-783f00ba42c9	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
41b611c0-8c04-4947-af58-8b499832bd45	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
41b611c0-8c04-4947-af58-8b499832bd45	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
41b611c0-8c04-4947-af58-8b499832bd45	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
41b611c0-8c04-4947-af58-8b499832bd45	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
44f6fa70-2f22-4d6e-9244-5acb7aaebc62	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
44f6fa70-2f22-4d6e-9244-5acb7aaebc62	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
44f6fa70-2f22-4d6e-9244-5acb7aaebc62	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
44f6fa70-2f22-4d6e-9244-5acb7aaebc62	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
03d773b9-6bd0-4273-b0e5-31a631703129	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
03d773b9-6bd0-4273-b0e5-31a631703129	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
03d773b9-6bd0-4273-b0e5-31a631703129	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
03d773b9-6bd0-4273-b0e5-31a631703129	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
c8dd6000-a5ea-4c3b-965b-a7d5b90b71b3	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
c8dd6000-a5ea-4c3b-965b-a7d5b90b71b3	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
c8dd6000-a5ea-4c3b-965b-a7d5b90b71b3	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
c8dd6000-a5ea-4c3b-965b-a7d5b90b71b3	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
1b7c26fa-8017-40e3-8b12-e0aa29b475ac	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
1b7c26fa-8017-40e3-8b12-e0aa29b475ac	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
1b7c26fa-8017-40e3-8b12-e0aa29b475ac	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
1b7c26fa-8017-40e3-8b12-e0aa29b475ac	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
a558f4ed-139d-4ea7-887d-f61393066c5d	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
a558f4ed-139d-4ea7-887d-f61393066c5d	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
a558f4ed-139d-4ea7-887d-f61393066c5d	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
a558f4ed-139d-4ea7-887d-f61393066c5d	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
4fa5d46c-673a-49eb-aab4-5f0f6782f2b1	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
4fa5d46c-673a-49eb-aab4-5f0f6782f2b1	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
4fa5d46c-673a-49eb-aab4-5f0f6782f2b1	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
4fa5d46c-673a-49eb-aab4-5f0f6782f2b1	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
8b6cb2f4-08f9-44a1-9eca-838bf2852862	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
8b6cb2f4-08f9-44a1-9eca-838bf2852862	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
8b6cb2f4-08f9-44a1-9eca-838bf2852862	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
8b6cb2f4-08f9-44a1-9eca-838bf2852862	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
2cea284e-c5ec-4160-9853-f04e3d931833	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
2cea284e-c5ec-4160-9853-f04e3d931833	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
2cea284e-c5ec-4160-9853-f04e3d931833	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
2cea284e-c5ec-4160-9853-f04e3d931833	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
95c52880-f900-440d-8598-46c4b9ea155d	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
95c52880-f900-440d-8598-46c4b9ea155d	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
95c52880-f900-440d-8598-46c4b9ea155d	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
95c52880-f900-440d-8598-46c4b9ea155d	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
45660849-8638-4f46-b626-b4a9a0f987e6	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
45660849-8638-4f46-b626-b4a9a0f987e6	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
45660849-8638-4f46-b626-b4a9a0f987e6	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
45660849-8638-4f46-b626-b4a9a0f987e6	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
e54d8cca-ef3d-4fc3-8e9b-fc25400b60e0	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
e54d8cca-ef3d-4fc3-8e9b-fc25400b60e0	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
e54d8cca-ef3d-4fc3-8e9b-fc25400b60e0	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
e54d8cca-ef3d-4fc3-8e9b-fc25400b60e0	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
d7712abc-0423-47ab-8238-08bd141fc71c	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
d7712abc-0423-47ab-8238-08bd141fc71c	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
d7712abc-0423-47ab-8238-08bd141fc71c	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
d7712abc-0423-47ab-8238-08bd141fc71c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
6ce97ced-6e6a-4953-baab-45d2648ead58	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
6ce97ced-6e6a-4953-baab-45d2648ead58	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
6ce97ced-6e6a-4953-baab-45d2648ead58	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
6ce97ced-6e6a-4953-baab-45d2648ead58	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
7a6be562-0004-4747-a007-85d61471bc9c	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
7a6be562-0004-4747-a007-85d61471bc9c	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
7a6be562-0004-4747-a007-85d61471bc9c	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
7a6be562-0004-4747-a007-85d61471bc9c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
bda0924a-53e0-4e08-89d7-c83ae811512e	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
bda0924a-53e0-4e08-89d7-c83ae811512e	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
bda0924a-53e0-4e08-89d7-c83ae811512e	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
bda0924a-53e0-4e08-89d7-c83ae811512e	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
a2832ea8-52b5-434b-a16e-f2ec870d4d6a	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
a2832ea8-52b5-434b-a16e-f2ec870d4d6a	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
a2832ea8-52b5-434b-a16e-f2ec870d4d6a	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
a2832ea8-52b5-434b-a16e-f2ec870d4d6a	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
0e50ca82-84f2-4c0c-9f23-d4188ea93fc2	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
0e50ca82-84f2-4c0c-9f23-d4188ea93fc2	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
0e50ca82-84f2-4c0c-9f23-d4188ea93fc2	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
0e50ca82-84f2-4c0c-9f23-d4188ea93fc2	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
1369b465-6b56-4588-837c-d2e7c14baf23	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
1369b465-6b56-4588-837c-d2e7c14baf23	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
1369b465-6b56-4588-837c-d2e7c14baf23	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
1369b465-6b56-4588-837c-d2e7c14baf23	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
7e0e2814-48b8-4e2d-9a26-2f5750716f2c	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
7e0e2814-48b8-4e2d-9a26-2f5750716f2c	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
7e0e2814-48b8-4e2d-9a26-2f5750716f2c	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
7e0e2814-48b8-4e2d-9a26-2f5750716f2c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
b65db15a-8341-4988-ae13-aad0da51a089	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
b65db15a-8341-4988-ae13-aad0da51a089	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
b65db15a-8341-4988-ae13-aad0da51a089	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
b65db15a-8341-4988-ae13-aad0da51a089	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
d7fa727f-dc5b-4b71-8a60-39cc4c4123bc	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
d7fa727f-dc5b-4b71-8a60-39cc4c4123bc	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
d7fa727f-dc5b-4b71-8a60-39cc4c4123bc	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
d7fa727f-dc5b-4b71-8a60-39cc4c4123bc	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
3e85e817-c1a8-421a-bdf2-102ba663d347	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
3e85e817-c1a8-421a-bdf2-102ba663d347	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
3e85e817-c1a8-421a-bdf2-102ba663d347	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
3e85e817-c1a8-421a-bdf2-102ba663d347	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
3ce5c1aa-6ed5-4d6e-b389-9546ba73fb65	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
3ce5c1aa-6ed5-4d6e-b389-9546ba73fb65	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
3ce5c1aa-6ed5-4d6e-b389-9546ba73fb65	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
3ce5c1aa-6ed5-4d6e-b389-9546ba73fb65	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
4be62a58-3497-4919-93ac-7dd3d7c71756	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
4be62a58-3497-4919-93ac-7dd3d7c71756	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
4be62a58-3497-4919-93ac-7dd3d7c71756	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
4be62a58-3497-4919-93ac-7dd3d7c71756	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
53480ba9-7cb1-4a4b-9f38-c599fe059c84	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
53480ba9-7cb1-4a4b-9f38-c599fe059c84	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
53480ba9-7cb1-4a4b-9f38-c599fe059c84	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
53480ba9-7cb1-4a4b-9f38-c599fe059c84	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
eebbbd5e-d815-4aae-adff-784014504088	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
eebbbd5e-d815-4aae-adff-784014504088	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
eebbbd5e-d815-4aae-adff-784014504088	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
eebbbd5e-d815-4aae-adff-784014504088	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
de13ad16-bc86-490d-865c-a0281b3893c5	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
de13ad16-bc86-490d-865c-a0281b3893c5	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
de13ad16-bc86-490d-865c-a0281b3893c5	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
de13ad16-bc86-490d-865c-a0281b3893c5	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
0f2a04de-83bc-47fc-bfd3-871ab8cbe974	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
0f2a04de-83bc-47fc-bfd3-871ab8cbe974	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
0f2a04de-83bc-47fc-bfd3-871ab8cbe974	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
0f2a04de-83bc-47fc-bfd3-871ab8cbe974	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
21a37dcc-11de-476e-88d9-8231788e14d1	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
21a37dcc-11de-476e-88d9-8231788e14d1	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
21a37dcc-11de-476e-88d9-8231788e14d1	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
21a37dcc-11de-476e-88d9-8231788e14d1	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
d1587209-5b15-4416-9fc3-137274c32dae	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
d1587209-5b15-4416-9fc3-137274c32dae	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
d1587209-5b15-4416-9fc3-137274c32dae	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
d1587209-5b15-4416-9fc3-137274c32dae	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
9a20beff-bcb8-4b79-aca2-1cd6c63db6f7	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
9a20beff-bcb8-4b79-aca2-1cd6c63db6f7	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
9a20beff-bcb8-4b79-aca2-1cd6c63db6f7	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
9a20beff-bcb8-4b79-aca2-1cd6c63db6f7	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
e8473758-8a48-412c-a277-69092e726b6a	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
e8473758-8a48-412c-a277-69092e726b6a	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
e8473758-8a48-412c-a277-69092e726b6a	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
e8473758-8a48-412c-a277-69092e726b6a	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
0b1b8b43-9589-48fd-8c4a-a1af881eb98b	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
0b1b8b43-9589-48fd-8c4a-a1af881eb98b	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
0b1b8b43-9589-48fd-8c4a-a1af881eb98b	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
0b1b8b43-9589-48fd-8c4a-a1af881eb98b	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
2b2944f0-ba7e-48aa-b3e9-f766b1a026ea	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
2b2944f0-ba7e-48aa-b3e9-f766b1a026ea	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
2b2944f0-ba7e-48aa-b3e9-f766b1a026ea	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
2b2944f0-ba7e-48aa-b3e9-f766b1a026ea	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
b7083879-78f9-4d19-954f-f9061f8d7a6c	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
b7083879-78f9-4d19-954f-f9061f8d7a6c	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
b7083879-78f9-4d19-954f-f9061f8d7a6c	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
b7083879-78f9-4d19-954f-f9061f8d7a6c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
ebc0a8f3-3e6a-43aa-aa48-2f5df129975a	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
ebc0a8f3-3e6a-43aa-aa48-2f5df129975a	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
ebc0a8f3-3e6a-43aa-aa48-2f5df129975a	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
ebc0a8f3-3e6a-43aa-aa48-2f5df129975a	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
6beef4d3-8355-4104-8bd5-2796ace4d4db	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
6beef4d3-8355-4104-8bd5-2796ace4d4db	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
6beef4d3-8355-4104-8bd5-2796ace4d4db	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
6beef4d3-8355-4104-8bd5-2796ace4d4db	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
40bb1a31-7ef7-41fa-a041-f6c4c70a3721	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
40bb1a31-7ef7-41fa-a041-f6c4c70a3721	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
40bb1a31-7ef7-41fa-a041-f6c4c70a3721	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
40bb1a31-7ef7-41fa-a041-f6c4c70a3721	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
ecfca3a0-17e3-41ab-9d92-d103671bbe53	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
ecfca3a0-17e3-41ab-9d92-d103671bbe53	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
ecfca3a0-17e3-41ab-9d92-d103671bbe53	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
ecfca3a0-17e3-41ab-9d92-d103671bbe53	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
6b3c93d4-1e32-48ca-996c-97788ef201d4	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
6b3c93d4-1e32-48ca-996c-97788ef201d4	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
6b3c93d4-1e32-48ca-996c-97788ef201d4	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
6b3c93d4-1e32-48ca-996c-97788ef201d4	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
b229672d-279f-4a07-82e0-2561c004cb2e	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
b229672d-279f-4a07-82e0-2561c004cb2e	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
b229672d-279f-4a07-82e0-2561c004cb2e	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
b229672d-279f-4a07-82e0-2561c004cb2e	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
9dc0f0c7-d632-4f0e-9b9e-76d76a726e09	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
9dc0f0c7-d632-4f0e-9b9e-76d76a726e09	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
9dc0f0c7-d632-4f0e-9b9e-76d76a726e09	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
9dc0f0c7-d632-4f0e-9b9e-76d76a726e09	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
d9855233-88d7-4ee9-a73a-39334f4fc336	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
d9855233-88d7-4ee9-a73a-39334f4fc336	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
d9855233-88d7-4ee9-a73a-39334f4fc336	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
d9855233-88d7-4ee9-a73a-39334f4fc336	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
5d7f9029-445a-4b4f-b273-3cfa24899d15	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
5d7f9029-445a-4b4f-b273-3cfa24899d15	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
5d7f9029-445a-4b4f-b273-3cfa24899d15	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
5d7f9029-445a-4b4f-b273-3cfa24899d15	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
4d35f475-6012-4bf8-b771-97524b063d0e	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
4d35f475-6012-4bf8-b771-97524b063d0e	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
4d35f475-6012-4bf8-b771-97524b063d0e	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
4d35f475-6012-4bf8-b771-97524b063d0e	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
4b3e43d7-4461-42e5-9f23-1931d82ed66c	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
4b3e43d7-4461-42e5-9f23-1931d82ed66c	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
4b3e43d7-4461-42e5-9f23-1931d82ed66c	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
4b3e43d7-4461-42e5-9f23-1931d82ed66c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
e862ac04-d7ca-44db-b7f3-9647de6bcdbb	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
e862ac04-d7ca-44db-b7f3-9647de6bcdbb	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
e862ac04-d7ca-44db-b7f3-9647de6bcdbb	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
e862ac04-d7ca-44db-b7f3-9647de6bcdbb	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
aed1bb1c-0385-43ba-8df8-82705fe44c0b	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
aed1bb1c-0385-43ba-8df8-82705fe44c0b	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
aed1bb1c-0385-43ba-8df8-82705fe44c0b	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
aed1bb1c-0385-43ba-8df8-82705fe44c0b	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
b0852bad-a83a-44ba-810e-0d62707f76eb	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
b0852bad-a83a-44ba-810e-0d62707f76eb	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
b0852bad-a83a-44ba-810e-0d62707f76eb	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
b0852bad-a83a-44ba-810e-0d62707f76eb	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
25d702da-f331-49b4-9e38-b0eb44930f7c	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
25d702da-f331-49b4-9e38-b0eb44930f7c	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
25d702da-f331-49b4-9e38-b0eb44930f7c	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
25d702da-f331-49b4-9e38-b0eb44930f7c	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
da3adc74-99e0-461d-9518-56875ec0ae2f	7ebc0e2e-f0d8-44b5-9059-f350954b6fc8	2026-06-02 14:09:17.675524+00
da3adc74-99e0-461d-9518-56875ec0ae2f	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-02 14:09:17.675524+00
da3adc74-99e0-461d-9518-56875ec0ae2f	79716129-495a-47e4-9034-30dc36a7cef9	2026-06-02 14:09:17.675524+00
da3adc74-99e0-461d-9518-56875ec0ae2f	eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4	2026-06-02 14:09:17.675524+00
420f922c-36c0-4b17-a74c-f08262c6f30f	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
f7741410-bd52-4b20-a8d3-bd415a25d2b0	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
20b8422e-5537-4711-9902-d2efd152f3a3	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
a7c5e0d9-78cd-4922-a391-79f7d51b09fb	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
8287a816-4b08-4af9-8096-9b5bf859a487	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
c6334989-e7f7-4ee2-b37f-4d376436fdfb	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
cdc7eb6e-653a-46dd-9b8a-088f59dc57d0	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
06db94a4-10b9-498e-b718-60d70ef8d298	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
69b3c45e-eba2-4da0-846e-fb5e95bc28d7	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
71b1f5f5-950c-4616-997c-f3376e63c8f4	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
49991c44-ca21-4c26-9525-d1002b0fc840	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
dc14a24e-14f3-49df-8211-a840ba06266a	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
7fd52685-1f62-47c3-a9b9-37cad24acbb6	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
c50f7b99-0ebe-4e33-89f9-c6b8cb2887d3	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
767bbd60-6207-4ec8-8db0-ff197058a296	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
534f5f8e-faa4-499f-8da3-9e803dfe318b	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
098b4994-4fad-4058-bfa8-51be1d269f5c	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
43e0c500-e2eb-4583-9871-84e622cbc27a	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
1e3825fb-ee88-4f07-8f61-0ad3b600c20d	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
f799803c-676d-4b34-bf19-dd80b29f89ef	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
25216422-af7d-49f0-9d8c-ea7622c23255	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
25f332d5-6ea8-4e94-bc1e-bae6abe38e85	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
4516c8ad-bc19-4e83-9ac1-24855ec10d80	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
1d5aec7b-e41d-4926-9dbe-7c55ed740f73	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
ce4f00de-6029-4a5d-8a15-13948fd9f9ec	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
a98c2d48-2a25-4840-9267-2eadb172ebf5	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
2e4cf497-14b5-45cc-bd60-556e78ca4652	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
7ebe65d5-0c36-4dab-ade3-6a8147e07501	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
960bcbe3-a154-43dc-b9ba-8d63687cdb4b	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
163c0b1d-1c3a-4148-95b9-d346871471d0	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
f7c95777-0fdc-4e30-8a54-f50e5ab72224	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
16899884-b3a0-4e2f-a6f6-981834f39065	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
349063a2-ec9c-42ba-9e09-d79e56ad1259	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
e6501d90-85e2-49c1-84b4-5cc953ed8e2e	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
de940c21-41d5-4e88-bd0d-9d68bff89c01	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
8440b404-3081-4bfd-8cee-84f0e85609f4	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
d4fd1537-b93d-47b2-ae5c-6381935b7a7e	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
ffb8c8e7-a824-4384-84fd-6ce6d67dacf2	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
c32455af-5ba5-45a1-a269-6ebb0a36e444	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
08694424-8883-40ec-8070-d89eee86743c	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
839ee6cb-cbf6-4b75-bff3-cfa3dde1a83e	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
51beb2a6-a3ed-4d2f-9ee8-b454ece9bac8	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
b9b086fe-c346-452e-824f-41edd2303c38	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
c773aa3c-e99d-4778-8108-165c2f8efd98	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
c1076b3d-1515-478d-8548-a5269df52271	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
6263f9eb-4389-426e-b27d-85ec7621a6bd	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
5bf0945f-ddae-4611-9bbf-7f97a3c6e3df	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
ceccf7e5-96b9-4c3f-84ae-4e23122802ea	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
f8ebea93-e5a1-432a-b33e-6015e561d2a1	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
453f791b-cac5-48b9-be3e-b5a78600b191	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
f4549c38-1099-4e58-b7dc-8e4a96283d4c	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
a3882545-402f-4045-b806-6ce79b995d98	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
91a74f01-0910-48c9-b938-6e45052fcb1f	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
aa773e93-1d5a-48fa-9b5b-282377d3429e	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
0b64f493-4229-4222-8e7c-55a0d2fff505	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
6c097b74-7ec6-489d-a7ad-4b094a6c2f9a	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
605696f9-82b4-4b88-94b6-019a55361c93	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
42b70aa0-4195-43dc-8d47-605b53a4c14e	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
c1b57f4a-4acd-4da7-bcbb-ff05a92080c2	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
6525b446-1b69-477e-b562-018daddc5c34	92c3ef86-c8c3-4409-9441-6afe7cf9da41	2026-06-03 13:32:45.726482+00
7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	43650019-be71-4968-b880-fa9fdd5993b0	2026-06-05 02:32:47.536259+00
7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	8b4b3851-e596-4098-ae56-b815b15c70b3	2026-06-05 02:32:47.536259+00
7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-05 02:32:47.536259+00
7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	fb2e23f1-c296-4d07-bf5e-edbb44caa342	2026-06-05 02:32:47.536259+00
7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-05 02:32:47.536259+00
7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	5d1238b2-a160-4ad3-94a9-9ca0a0c8aded	2026-06-05 02:32:47.536259+00
7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-05 02:32:47.536259+00
7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-05 02:32:47.536259+00
7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-05 02:32:47.536259+00
7dc33e85-0298-4e3b-b8b3-fb6c7b8d1d4b	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-05 02:32:47.536259+00
e6ae979f-35fd-4da4-bcc3-f76bfdf71d03	8c9ff910-1ef2-44d6-81df-93e53b229f3c	2026-06-13 15:46:43.039521+00
e6ae979f-35fd-4da4-bcc3-f76bfdf71d03	da04a7dd-c0ad-4799-9b3c-7c2ea881a448	2026-06-13 15:46:43.039521+00
e6ae979f-35fd-4da4-bcc3-f76bfdf71d03	988937e2-6351-48a9-b1f6-db5b99b2409c	2026-06-13 15:46:43.039521+00
e6ae979f-35fd-4da4-bcc3-f76bfdf71d03	9e208ba0-9c35-45f6-9584-bd6d8d8a6557	2026-06-13 15:46:43.039521+00
e6ae979f-35fd-4da4-bcc3-f76bfdf71d03	141e6311-d00c-4380-9c83-c91514025d2b	2026-06-13 15:46:43.039521+00
e6ae979f-35fd-4da4-bcc3-f76bfdf71d03	6f02ce8a-9295-4d92-8de3-021585724689	2026-06-13 15:46:43.039521+00
\.

--
-- Data for Name: phu_luc_hop_dong; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."phu_luc_hop_dong" ("id", "hop_dong_id", "loai", "noi_dung", "ngay_hieu_luc", "gia_thue_moi", "ngay_ket_thuc_moi", "file_pdf", "nguoi_tao_id", "tao_luc") FROM stdin;
\.

--
-- Data for Name: refresh_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."refresh_token" ("id", "nguoi_dung_id", "token", "ngay_het_han", "tao_luc") FROM stdin;
1769b60d-b53c-42ef-8f4d-fd97c612f460	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJkYTNjNjZjNS01NTI4LTQ4YTEtYjRhNi02Njc3YTk3MGZmZGEiLCJpYXQiOjE3Nzk1NTMzODAsImV4cCI6MTc4MjE0NTM4MH0.QbNoh__ti_zKb-QS-w6dq8K-l909WR4aV1AmWf0RQ8gg3Mk6DDo4V-zXl5sfVTi2	2026-06-22 16:23:00.573+00	2026-05-23 16:23:00.574005+00
c7c571af-5156-4f00-8793-6786ed563b7e	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI3ZmU2ZWUxOS02M2NmLTQwNTQtOWZhOS04NzhkZjViNzc2OWQiLCJpYXQiOjE3Nzk1NTM0ODQsImV4cCI6MTc4MjE0NTQ4NH0.xBOHdJ6i2QtarFXJ-tcpFIWCwsXZYjOpSHSLaLgqiYG6uZydXKWpj2yejd-qOZJI	2026-06-22 16:24:44.858+00	2026-05-23 16:24:44.858988+00
800b1b72-2ab9-41ba-a4c3-8be9b8e49071	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI4MzMyODUwNy02ZjUyLTQxZDctOTM5Yy00MWI3NTVjYjg5ZjkiLCJpYXQiOjE3Nzk1NTM3OTQsImV4cCI6MTc4MjE0NTc5NH0.2-XRg7L7q3ekssC6bHPTT3X5JSMbjgtvjjCMkcHNUkjmb-atKUQj4gTqEf-GUZ9y	2026-06-22 16:29:54.186+00	2026-05-23 16:29:54.18855+00
fe34789a-ef43-4f7c-9976-f0823fc606a1	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJkZjU3OTUwMC0xOTA4LTQzODgtYWY2My04MDNiMDZmMmM2NWUiLCJpYXQiOjE3Nzk1NTQ0ODIsImV4cCI6MTc4MjE0NjQ4Mn0.8oodnEyY6pDe01gwtp4kQValYA0DleKAfrOyEkSfL9tj7np9eJUIu6AV9SDhlyFV	2026-06-22 16:41:22.178+00	2026-05-23 16:41:22.178673+00
2d306a91-37b9-4192-998c-7734496025a2	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJjYTdlNTA2MC1hNTZlLTQzZjQtOGRjMy00ZDhlZTE2NTc5NjQiLCJpYXQiOjE3Nzk1NTYyMDEsImV4cCI6MTc4MjE0ODIwMX0.vZMoS067CGM81OLGyVqhWC6Kkf7LxF4Ru-OBGUbwb1k-D3jptdcRVNvVT7otIgfp	2026-06-22 17:10:01.247+00	2026-05-23 17:10:01.250194+00
f621361f-e254-418f-b752-14ac0991d07c	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiIyMDYwY2U2Ny05ZmI3LTQ0ZDMtOTkyZi0wNDExYzg3MTQ5YzQiLCJpYXQiOjE3Nzk1NTc1NzcsImV4cCI6MTc4MjE0OTU3N30.fGsSkX1u1L2govIvQ07XFNaM9_r7RS4Nz7EL9Z1n96sWfbLGjXgAcMJ4oUcTcCvv	2026-06-22 17:32:57.583+00	2026-05-23 17:32:57.584327+00
00b5af30-3c01-4b1e-be4d-b526558b67bf	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiIxOTNiOTkwOC1hZjMzLTQ5M2QtOGU1YS1kNjE5NzVkODY2ODMiLCJpYXQiOjE3Nzk1NTc2ODYsImV4cCI6MTc4MjE0OTY4Nn0.vm3YIRgodvONaK_ezZrGbzsdKomZYT2Mz9swYQzUZgxzVMpDcfZg_tY8UdpUcuNa	2026-06-22 17:34:46.502+00	2026-05-23 17:34:46.504163+00
05cfeca5-eae6-497c-bd5b-45ff2978704e	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJhYzI3ZWUzYS01NGI5LTQwMDAtOWJkNC0wODQyYjE0OGU1NmUiLCJpYXQiOjE3Nzk1NTgwMjAsImV4cCI6MTc4MjE1MDAyMH0.sLn5ndYMsLINGwEmlcsY1ze9DMhmfhqNjedZCk1W5UeCiP3i2OfEEfOIfsAA8zaG	2026-06-22 17:40:20.423+00	2026-05-23 17:40:20.425228+00
da710484-595f-4657-bddd-bbffdb2ded00	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI5YmM5NTg1MS1iYzhiLTQzOGMtYjBjZi1iYzg1NDRmMDAwMjMiLCJpYXQiOjE3Nzk1OTA4NTUsImV4cCI6MTc4MjE4Mjg1NX0.6vy6KZSIn_jK7DYNSNhCF69oEvW9BPv_kZKA5_lQebpaTPE3QYSLz8wRIxLkHrAI	2026-06-23 02:47:35.866+00	2026-05-24 02:47:35.869234+00
75e1e980-78a4-448c-83ba-0a6ee89000fb	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJmMjliNGYzMi00OTI1LTRjODktOWU1OS1iM2Y3MzZjM2JkMjMiLCJpYXQiOjE3Nzk1OTA4NzUsImV4cCI6MTc4MjE4Mjg3NX0.GsGS6L7LKDIj0X7-bhOtUQwTBpEgqnni5B9hZky9HOB7vvw6waq4iwUe1STO842N	2026-06-23 02:47:55.563+00	2026-05-24 02:47:55.563889+00
a0b8fde0-8b3d-4920-ad44-057642c8ae77	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJiNzEyMjZhMS0zYWNlLTRlY2UtOTdmOS1iYTZjMDljYWQxNTUiLCJpYXQiOjE3Nzk1OTE3NzEsImV4cCI6MTc4MjE4Mzc3MX0.IPluQ789nPmYaQdnu49XO_oA7e9_G10swRtPTqN-V-5lGye0KPQAsGz9dW-jhzfE	2026-06-23 03:02:51.627+00	2026-05-24 03:02:51.63065+00
5d36dbf7-3dc1-4e4a-a992-9dafd01adf64	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJjMDlhNjdmOS1iOWY1LTQzMWUtYTk4NC1kOTMzNjFlNjhmOGEiLCJpYXQiOjE3Nzk1OTMzMDIsImV4cCI6MTc4MjE4NTMwMn0.q3anFR974ubkMX8_I6cDmxwXxMM-0llJ2fFWxXwZLtp2GokSe8x5AGbtt3b6gzlx	2026-06-23 03:28:22.63+00	2026-05-24 03:28:22.63261+00
fd61700a-f3b8-4670-ad87-6e2b8b4bcf95	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJiYTI4ZjM2Mi03NzY3LTRjOWEtODUwMS0xNWM2M2MwMzdmOWYiLCJpYXQiOjE3Nzk1OTUwOTMsImV4cCI6MTc4MjE4NzA5M30.XXo70h495CATtwNAnZaRWb7fAJxsMuAwRH8o6wjCZKE9nfcG0eGF5ALM6qfFyAN6	2026-06-23 03:58:13.285+00	2026-05-24 03:58:13.287786+00
daeabae2-b704-4d0e-a939-ece174269730	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJkMzMwMmUyZi1iYTBhLTRhNzMtOGI2Yi00NmNhYmFkM2VkNzkiLCJpYXQiOjE3Nzk2MDEzNjgsImV4cCI6MTc4MjE5MzM2OH0.A_5FnLu8b3b92mFo0S2jJAJWo4Ja4DKhbsCJKbA4OH4ul6R99RzpqVoRDT9mBGyn	2026-06-23 05:42:48.138+00	2026-05-24 05:42:48.139713+00
15daf059-cb69-499f-a69f-c98aea83c425	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmMDZmMzFkZC05ZWM0LTRkNmMtOWU4ZC1jOGFkY2RmNTc2OTMiLCJqdGkiOiIyZTMzOTY0NC1iYjBlLTQ5NGEtYmRmMy1hYTdlZDZjZWUxYjgiLCJpYXQiOjE3Nzk2MDI1NjQsImV4cCI6MTc4MjE5NDU2NH0.qyD-tQ2RNtnVUlKLTgYfh3eO208t_ICcFZuWqsUv1CHJ4miKk4_2Bhv8y7DN-Lj-	2026-06-23 06:02:44.96+00	2026-05-24 06:02:44.960809+00
833b1076-d0ed-456d-bf4e-dd22a71ee075	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmMDZmMzFkZC05ZWM0LTRkNmMtOWU4ZC1jOGFkY2RmNTc2OTMiLCJqdGkiOiJlNTJjYmM5MS1jMGIyLTQ2NDQtOGEzMC02ODgwNWVmYzA2ZDQiLCJpYXQiOjE3Nzk2MDI1ODYsImV4cCI6MTc4MjE5NDU4Nn0.oVv-MSbtNFb-sV4LgSpf6fCzvbsCyAAcZCcTFVilgZ7WkHchyjsswM0O6LGIVjdq	2026-06-23 06:03:06.341+00	2026-05-24 06:03:06.342648+00
238e5401-8b1f-41d7-b652-b653a677c59b	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI5NzEzNjA4My00M2VlLTQ5YjAtYWYyOC03MTgyZWZmMDY2NzYiLCJpYXQiOjE3Nzk2MDQxMTUsImV4cCI6MTc4MjE5NjExNX0.EihhcP2bdZ71YJRh1hLAWA5T9GZc0uQ8L8RsKw0sL2_1Oo-oGhEwNniltGPt0EX2	2026-06-23 06:28:35.638+00	2026-05-24 06:28:35.640993+00
09cae792-f872-4ad2-a9a8-2c6aebb9a779	3b6141c5-a1f0-4bc5-9c17-4fa329b52c29	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzYjYxNDFjNS1hMWYwLTRiYzUtOWMxNy00ZmEzMjliNTJjMjkiLCJqdGkiOiIxMTJlYTAxZi1jMmNhLTQ0NTAtOGNhMi1iZTRhMDM0ZjQ3YWQiLCJpYXQiOjE3Nzk2MDY5NjIsImV4cCI6MTc4MjE5ODk2Mn0.bDPFoRaQ8AwwebugIuFIToRbZVul1UY217IZgFms8_4enYJjQSoXOV5ruEzEoo7T	2026-06-23 07:16:02.174+00	2026-05-24 07:16:02.175876+00
520855d4-7a85-44da-bb0c-d6616bb4c9d5	c7cdde54-c62a-42af-8bec-62e37f3fde83	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjN2NkZGU1NC1jNjJhLTQyYWYtOGJlYy02MmUzN2YzZmRlODMiLCJqdGkiOiIzM2NmMGQ2Yi03Y2NmLTQzMTItYTkyYS01YWQ1ZWE4ODliN2YiLCJpYXQiOjE3Nzk2MDY5NjIsImV4cCI6MTc4MjE5ODk2Mn0.gL0N5nkbdo88LYVXDTzcO4f4CeSSFU4PEghN6x52yef9yuFMITegNjEc-zflB2cJ	2026-06-23 07:16:02.174+00	2026-05-24 07:16:02.175876+00
806ddda7-ce5d-43d4-83c5-fdda410629cc	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI5MDQ2NDJhNy1jYTMyLTQwZjYtYWQ2Zi1lNDA0MWRjYWY2OTIiLCJpYXQiOjE3Nzk2MDY5OTYsImV4cCI6MTc4MjE5ODk5Nn0.Cl0Oc0NgRMNKwf4thpKiCl4TpZg4hte2zoh9fxDGAtNuwYIuY6G4DT7wcWD_Peua	2026-06-23 07:16:36.568+00	2026-05-24 07:16:36.569525+00
73faa898-1e8b-464d-b4a8-e26dc359db9b	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI0MWI2NTExOS0xM2Q1LTQxOWMtODk3NS1kYWQ3ZWJiOGZjYTgiLCJpYXQiOjE3Nzk2MDcwMDYsImV4cCI6MTc4MjE5OTAwNn0.m1h9AjFhFEuOnYJqYiUofAQJ1hRL8JGlKOtIjo6am7-1AsLZdiXPmL1hxr7biEdN	2026-06-23 07:16:46.202+00	2026-05-24 07:16:46.202881+00
6ff4c470-e8db-4ca5-829e-d8184c090328	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiJhOTdmNDBlZC04ZmE0LTRkNzktOGFlMi05MDMwNzM2YjNmNDQiLCJpYXQiOjE3Nzk2MDgxODUsImV4cCI6MTc4MjIwMDE4NX0.O1XZzULEOr6nYi87Xh_0W2wCBYK2yEltj1DmmXAp0u4BJechauCS5Mfd_lzl47qJ	2026-06-23 07:36:25.784+00	2026-05-24 07:36:25.785972+00
f4635e9f-6dc2-4576-9bd9-96ee6c612481	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiJkYTM2ODU4ZS0yYjFkLTQ3NTgtOWVhZi1iYjdiNjBlMzJkMmQiLCJpYXQiOjE3Nzk2MDg0NDAsImV4cCI6MTc4MjIwMDQ0MH0.mBOTURe9VW8FUjXiK7QQcXH_dno25qbnxYDIlpg_6ZlG8itLP0FKkybqrK6jVAwy	2026-06-23 07:40:40.987+00	2026-05-24 07:40:40.987902+00
afdffef4-5948-446a-bc95-e7f5fe7e6413	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI4NTcyNzVmYi0wN2EyLTRkNjgtYTVhMC1mOTY1YjQ4ODE1YzkiLCJpYXQiOjE3Nzk2MTUyMjIsImV4cCI6MTc4MjIwNzIyMn0.ZcVq5WzMe9BiXBor87yG603qY-h_BGJ-ntwuF7A5lFL16Y4JPXocB2h-EpE6ZCX2	2026-06-23 09:33:42.713+00	2026-05-24 09:33:42.714337+00
5d5200f1-e710-4f5f-b4ff-8a4a2074c1f6	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiIzOWVmNWZhMi03YmYyLTQ0MmItOTc4Zi00MGFiYTlhM2EzM2IiLCJpYXQiOjE3Nzk2Mjg4MzYsImV4cCI6MTc4MjIyMDgzNn0.EepCX9q2mZUsU8bZo2dk26I1pyXxo0Cviir4M6reOyEZNjbLXxzbgYdbeHzfeJ-d	2026-06-23 13:20:36.713+00	2026-05-24 13:20:36.716169+00
0f87f21e-1d4f-49de-ae9c-d05dc5aaaa35	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJjY2VmMWVmYi1iNmIxLTQ5NjEtYWI0Yy02Nzc3OWI3NWNlNDAiLCJpYXQiOjE3Nzk2MzE2MDMsImV4cCI6MTc4MjIyMzYwM30.xIGOti-j_TU63iAeu67MO_4YfelohW-qw-_wGeDVTkY5lXOhw-m4NGceCPxwdBws	2026-06-23 14:06:43.13+00	2026-05-24 14:06:43.13357+00
e6f3fcd9-9400-4356-bb8b-fe5945a65fa3	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI5YTkxMTk5My03NjU4LTQ3NTEtODkyMi04NTVmNWQ3ODIwN2YiLCJpYXQiOjE3Nzk2MzUwNjIsImV4cCI6MTc4MjIyNzA2Mn0.gxRbW5r7U2ghWADQlROWyY5ssynce_iJvkbF63hAULnO3RV5njr5w7IyWlN6zC0a	2026-06-23 15:04:22.409+00	2026-05-24 15:04:22.411887+00
05abbb00-9ac8-4040-804f-c7019766c24a	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJjYjNjNjlhYS1mZjAyLTQyYmYtYjRiMS0xZWYwMmIwMGJjZjYiLCJpYXQiOjE3Nzk2MzU0MzMsImV4cCI6MTc4MjIyNzQzM30.ugX669SmyJCzHmz6xsEaTWABAUQdBV0yJt72aP6zaFc8lHnPbSe-0LbEWaDSGqED	2026-06-23 15:10:33.863+00	2026-05-24 15:10:33.866029+00
e16635d6-2f02-4cc9-8f50-da4ab5ded58d	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJmMGZlMGMwNi00MTJlLTQwNzAtOTY3OS04ZGI4YjQyNTZjNWQiLCJpYXQiOjE3Nzk2MzY0OTYsImV4cCI6MTc4MjIyODQ5Nn0.6KegMVdGkyvNsRty-gEWMJazP21JZ-cdIOT7k9C4Sbmj_qIus5UpHcDjoAFX7-gC	2026-06-23 15:28:16.318+00	2026-05-24 15:28:16.318191+00
063be73c-af07-4a84-9b5a-1c74d5ef420e	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJkZDJlY2ZkNC03YTA2LTQ2MjktOTBkNi0xNGRjYjJmY2M4ZmUiLCJpYXQiOjE3Nzk2Mzc0NjYsImV4cCI6MTc4MjIyOTQ2Nn0.s-s6AJthB-GY4N8GohBhX4yvAtmypatW63yuFHvCeRljDIwCA5H7kUmVeHWpujTH	2026-06-23 15:44:26.405+00	2026-05-24 15:44:26.407588+00
bb8a1042-efa9-4e66-b2db-d42d9a2fa058	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI5ODhjYWNmNy0wNWQzLTQ2YjEtODQ0Mi1jNjdlZjY5MWIxODkiLCJpYXQiOjE3Nzk2Mzg1NDIsImV4cCI6MTc4MjIzMDU0Mn0.0HKZ7fNQzaCDAvMhKTRsxMfFAlVBRz8vr7qnh602QO7jI3yu-PXtX4BsduE5LRot	2026-06-23 16:02:22.02+00	2026-05-24 16:02:22.02324+00
10a743db-f428-429e-813e-6d942524b25a	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJkZGMwNzI4OC03MDQzLTRiZjYtYjQ1YS1jMGVmMjE3YTEyNDkiLCJpYXQiOjE3Nzk2NDAzMzIsImV4cCI6MTc4MjIzMjMzMn0.7vfPClJpQmnKvJ5hja91Ds_rc5zcmCQXO1FphbQ-L08QsB14BCWlOmRzPZqzn1Xp	2026-06-23 16:32:12.89+00	2026-05-24 16:32:12.895004+00
18ba24cc-b226-4798-810e-587bdcaea8a8	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI1Njc2ZGVjOC02OWQ2LTRiMDEtODdhNi0zYjkwZmE2OWI5NzAiLCJpYXQiOjE3Nzk2NDgzMTYsImV4cCI6MTc4MjI0MDMxNn0.-MJdJk7To_sDUoVA7DL2GRTe_u14nPUh4LjCHkkjpND8J8NUWge_26J0SNX8RG6A	2026-06-23 18:45:16.336+00	2026-05-24 18:45:16.337659+00
1d8168ed-e5bc-4267-8dfc-fc01961e25ca	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmMDZmMzFkZC05ZWM0LTRkNmMtOWU4ZC1jOGFkY2RmNTc2OTMiLCJqdGkiOiIxNDZmYzQ4Mi0yMzViLTQ3NzUtYjM3Yi05NThiNzQyNjNhNDYiLCJpYXQiOjE3Nzk2NzQ4MTksImV4cCI6MTc4MjI2NjgxOX0.NcRqGMQmVOcN_x7gyn6QbAgigeBODX-8rN0BXkcpDqvHoxKtpMsZljg7PUgxG9k5	2026-06-24 02:06:59.037+00	2026-05-25 02:06:59.045972+00
b2a72907-a99b-424e-a530-2acabde4d6e6	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmMDZmMzFkZC05ZWM0LTRkNmMtOWU4ZC1jOGFkY2RmNTc2OTMiLCJqdGkiOiIwMzVjNDU3OC1hOWJiLTQ2YjYtYWE3MS0zOGM2OWVhNzVlN2YiLCJpYXQiOjE3Nzk2NzQ4MzgsImV4cCI6MTc4MjI2NjgzOH0.kdzXgbd4djQTaf58StKN4-baD6kr7CGOG7N70GVeA4ckHDY1_BJFPxkVN_kvQPnj	2026-06-24 02:07:18.501+00	2026-05-25 02:07:18.502079+00
cee8fd97-35da-4806-83cc-6456f19f91cb	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiJiMmEzMDMzYy02NDQ4LTQ1MzItYTViZi04NDYzMDE1NTBkMGUiLCJpYXQiOjE3Nzk3MDA5NzIsImV4cCI6MTc4MjI5Mjk3Mn0.j_SnDLT1vM2l0gA0R3AnRE0WFbSNIaruq918eKduoId0XMPZqzhrj7yzEGDnMhuc	2026-06-24 09:22:52.73+00	2026-05-25 09:22:52.730528+00
0c4c1bae-4fe6-4c0e-b7ad-7a28f924a471	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI2MTBkYTliOC1jMzE2LTRkOWUtYjk5OC04M2JjZWU2NzgwMDUiLCJpYXQiOjE3Nzk4MDI4NTksImV4cCI6MTc4MjM5NDg1OX0.rhpySBXwYXoXpeImcHK3J_mjgEqVfot1Qiz0zEIOZh0yg75Ia4DcsA1P3rGGRQSn	2026-06-25 13:40:59.493+00	2026-05-26 13:40:59.498728+00
702723e2-56b7-477f-b7b1-749fd3d8cd73	4e0b7b88-3763-4732-a1cf-c2d0707b0511	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI0ZTBiN2I4OC0zNzYzLTQ3MzItYTFjZi1jMmQwNzA3YjA1MTEiLCJqdGkiOiI1ZjExOTRkMS01ZjA5LTRlOTktOTViOS02NDZiZWUzNWIyMmEiLCJpYXQiOjE3Nzk4MDI5NzgsImV4cCI6MTc4MjM5NDk3OH0.aaI_qYuD1RRNoVf75NLvEud_3O0y-Okoe_pyUEpcYEV_P4RmSGID30F2Gw3_UHge	2026-06-25 13:42:58.319+00	2026-05-26 13:42:58.319949+00
40e62396-34c2-42bc-9c8c-60fa6a190fda	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI2M2M0YmRlMS05MjFhLTQ5YTYtYmYxNy1iNjgyYzMzMGUwMzAiLCJpYXQiOjE3Nzk4MDk5MjQsImV4cCI6MTc4MjQwMTkyNH0.w-alY0W-TOHdD88TfRaQB_9gp8Zc5OrvATEaiK9YXWGm4l7pxu4wy4zjTbDuffXZ	2026-06-25 15:38:44.376+00	2026-05-26 15:38:44.376372+00
67bdf7d6-2d4a-4991-981d-b37643cba122	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI5NzgzN2ZhYy0yOTVhLTQ0YTgtOWU2Ni1iNjdjMjg1MjExMTAiLCJpYXQiOjE3Nzk4MTk0MzUsImV4cCI6MTc4MjQxMTQzNX0.y9ryP1X5lqYa4RrYT7DY4BQuU68U80SgAoTh6bsM4h0Xg4m8qSf59o_PC-bcFmyJ	2026-06-25 18:17:15.802+00	2026-05-26 18:17:15.802838+00
59257158-9504-42f3-9276-73bbf95682fc	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI1YjIyOGJlMC04YzNhLTQ1YjMtYWVlMy1mNjk0NDdiMDQ1MzUiLCJpYXQiOjE3Nzk4NTA2MjcsImV4cCI6MTc4MjQ0MjYyN30.d_4kUvciHR6-Bs1juC09wsxZF2s_ignjToACllzqymyUkGTHu3tbY6EhtzHg_93l	2026-06-26 02:57:07.622+00	2026-05-27 02:57:07.622558+00
8892c7af-6207-4431-9278-b6664645d1c1	dc440559-dd1c-462c-832f-a5bb648d9199	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkYzQ0MDU1OS1kZDFjLTQ2MmMtODMyZi1hNWJiNjQ4ZDkxOTkiLCJqdGkiOiIzNTk3OGU2NC0zYmYwLTQwMjgtYmZkNC05NmExZDY0NDExZTYiLCJpYXQiOjE3ODAwMjk1NzQsImV4cCI6MTc4MjYyMTU3NH0.v0IwPY_01B6wztfVHXdM2x9aTOVM2UStJqRYb6EuNmP5rYJWMq4L-LlmOTSWUYgH	2026-06-28 04:39:34.177+00	2026-05-29 04:39:34.178693+00
d7d7a2a3-bb59-4ab5-b9a2-449fdcf67ed1	dc440559-dd1c-462c-832f-a5bb648d9199	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkYzQ0MDU1OS1kZDFjLTQ2MmMtODMyZi1hNWJiNjQ4ZDkxOTkiLCJqdGkiOiIwMzNmNDk3ZC04ZmI1LTRkZWEtOWM3Yy1lZTc5ZTI1ZmY1MGIiLCJpYXQiOjE3ODAwMjk1ODQsImV4cCI6MTc4MjYyMTU4NH0.3PQjSmNKoqdJAQiybHRMew-rbe2WdHsheONvbkisPrPcUSNIeCZ5Rbh4tRykHxUo	2026-06-28 04:39:44.385+00	2026-05-29 04:39:44.386926+00
e9d2d943-e8f5-4f3f-b9fd-00d51d445e43	3047f731-7822-47dd-930e-17c9b658cf55	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzMDQ3ZjczMS03ODIyLTQ3ZGQtOTMwZS0xN2M5YjY1OGNmNTUiLCJqdGkiOiI1NWU1NmNiYy1hYTdkLTRkMzQtOGQ5OC04Yzc3YWQ5ODZmMjMiLCJpYXQiOjE3ODAwMjk3ODUsImV4cCI6MTc4MjYyMTc4NX0.YQHsKqQc2wL4VRpEMY1LNkDO2_h4U24M7H6qsqc8q27tJRIKVC_2yb1cBn_rGvFB	2026-06-28 04:43:05.732+00	2026-05-29 04:43:05.733542+00
3076e190-9114-4520-b736-d753ca6da588	3047f731-7822-47dd-930e-17c9b658cf55	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzMDQ3ZjczMS03ODIyLTQ3ZGQtOTMwZS0xN2M5YjY1OGNmNTUiLCJqdGkiOiJmZDlhODc5YS1kNzAwLTRjMjktOTE5MC1kM2I3OWViYzE3YTMiLCJpYXQiOjE3ODAwMjk3OTQsImV4cCI6MTc4MjYyMTc5NH0.tozMo-xFYapuV-XVIhfRwLaCFY4QJaU7b5u35rLNzHoj81B5bmG2uTO1RrBIJurY	2026-06-28 04:43:14.944+00	2026-05-29 04:43:14.945024+00
f6ccbfdf-742e-477a-8df1-577772ef579b	3047f731-7822-47dd-930e-17c9b658cf55	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzMDQ3ZjczMS03ODIyLTQ3ZGQtOTMwZS0xN2M5YjY1OGNmNTUiLCJqdGkiOiJiOTJkMmJlMi05ZjZmLTQwZTMtYWEyYi1jODcyZjIzNmZlZTUiLCJpYXQiOjE3ODAwNDM1NjgsImV4cCI6MTc4MjYzNTU2OH0.IxuR6oRzx4UJZPPmoGOKPlNieDsNNf9dTXNPxUeAkCFdjcGahyPivYr7W8g9i-KI	2026-06-28 08:32:48.375+00	2026-05-29 08:32:48.376782+00
6e0535ad-bbdd-40bf-89ba-5e0094030a0d	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI3NTI1M2JhNS03NThjLTQ2MDgtODQ4NC0yMjhmOWZjYjY2NmIiLCJpYXQiOjE3ODAwNjkzODMsImV4cCI6MTc4MjY2MTM4M30.Lh_xFgK1l07LMiWHAafhW1T0O1sbVCdXBV4EX9Pdqxp8Ttezd-SfhNY-QOyk2yZx	2026-06-28 15:43:03.021+00	2026-05-29 15:43:03.022819+00
dce4c14a-c9c4-48a1-8d7a-521626726230	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmMDZmMzFkZC05ZWM0LTRkNmMtOWU4ZC1jOGFkY2RmNTc2OTMiLCJqdGkiOiI3NThhNzlkNC00ODgxLTQ1OTQtYWQ2MC1mZmY4NDBhNmI2OTciLCJpYXQiOjE3ODAwNzExOTcsImV4cCI6MTc4MjY2MzE5N30.CqRzFgvcytciZN6tmw4HfXcR_PKDjNrGcuux1ICFvl1dtuxzaeI2GIpQkSYB3JDC	2026-06-28 16:13:17.647+00	2026-05-29 16:13:17.648462+00
187bbe20-a9f6-470f-9441-d7f0858b1922	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiIwMWYyNmJiYi1mZWEwLTQwMDYtODY1YS1hM2Q5MzI0MDA4ZGUiLCJpYXQiOjE3ODAwNzY2MDUsImV4cCI6MTc4MjY2ODYwNX0.wu7Im_SXYFyjmbR4LLy4s-fVF37N9Vx3Z_KBxGBGSna1bZoWHIs2CmIJpPsm_Rof	2026-06-28 17:43:25.446+00	2026-05-29 17:43:25.447035+00
eb3ae8bb-3af7-4d19-959c-6b59950c710d	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiIyOThkZGZhYy03MDM3LTQwMjctODJjOS0zNTZiM2JjZjVlZTQiLCJpYXQiOjE3ODAwNzY4NzQsImV4cCI6MTc4MjY2ODg3NH0.JbBsw-9Czsq7BrV-WYbJGFXTquojV2JUAigoRARntn2wCZQRBBrELI4S9t_7PNll	2026-06-28 17:47:54.156+00	2026-05-29 17:47:54.156904+00
2774e63b-98e3-4d5f-b31a-266feefa009c	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJjMDMyOTg1OC0xM2NlLTRkYjYtOGM2Mi1lZmRmMWY0ZmJiZjEiLCJpYXQiOjE3ODAwNzcxOTEsImV4cCI6MTc4MjY2OTE5MX0.zJnamdVC_ZZJIf5r9G1VJGvsfrVjcn7DCn9HQXG9oExhA2-f3HCuqLN0_36HfvNf	2026-06-28 17:53:11.086+00	2026-05-29 17:53:11.086739+00
72ad4f99-3c84-4109-9347-35408d64b07a	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiIxZjg0MTllMC00NmEzLTQ2MzMtYTU3ZS1mNTZlNGQ3OTdmMGIiLCJpYXQiOjE3ODAxMDc2MjgsImV4cCI6MTc4MjY5OTYyOH0.1v1yqge9kaPzVY0Wle_Ev1ldtPJvfRFCOaerCuCdI8-k_6_uONClPkc81pwnO3Yh	2026-06-29 02:20:28.362+00	2026-05-30 02:20:28.365452+00
96f3ec0b-a183-4dae-b63f-9ca737156df0	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiIxMTM1YmZiMy0xYzliLTQ5NTMtYjdiNC02Nzg3OGMyNjNmZGIiLCJpYXQiOjE3ODAxMDk3MjksImV4cCI6MTc4MjcwMTcyOX0.Hw3jdJkHCZ5NltEIAmbUxTokD6lRCjLHbAeuRwGegKpWPR4etf8USebKH2_HC-Ya	2026-06-29 02:55:29.841+00	2026-05-30 02:55:29.843091+00
c5e43fa2-99be-4fb2-b2dc-01be74f273e9	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJjZmJiYzI1My0wNzE4LTQ3ZDktOWFkZi1mZDc0NjlhMDM4ODMiLCJpYXQiOjE3ODAxMDk3NjMsImV4cCI6MTc4MjcwMTc2M30.NM7IOIhlAuOm989OpWEC_cPehjzJXX-yuRiR6WX_diRb3OcKZIzEFsM1CV6P8tin	2026-06-29 02:56:03.712+00	2026-05-30 02:56:03.7121+00
faf5c750-8d0e-4abd-b5c7-5c40cfa8295a	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI0MmI2M2M4NS1iZWZkLTRhZjctYjkyNS1iMTU2NjU5NmQ5YmUiLCJpYXQiOjE3ODAxMDk3OTAsImV4cCI6MTc4MjcwMTc5MH0.aKbnxcse5w2FoYsk80JDA5q5IDtek0I69Tmin_jiGKlB6xkUIGQmufguQEGw5iOG	2026-06-29 02:56:30.053+00	2026-05-30 02:56:30.054918+00
cfaf749a-ba4b-4f40-a131-99af97103367	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiIxNjdhOTllMC01NThiLTRjOTYtYWRiYy1iNzU2ZjVmOTZmNTAiLCJpYXQiOjE3ODAxMTM3MTQsImV4cCI6MTc4MjcwNTcxNH0.eCa3u1CBdGYImFr5WGLgFQUDlCQCfEZRSDBi560b-2rkdCI997zSAW9WlhSKb_pl	2026-06-29 04:01:54.575+00	2026-05-30 04:01:54.577901+00
2068bea4-af71-4a98-b2da-e21eeb52b4c2	dc440559-dd1c-462c-832f-a5bb648d9199	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkYzQ0MDU1OS1kZDFjLTQ2MmMtODMyZi1hNWJiNjQ4ZDkxOTkiLCJqdGkiOiIxOThmN2M5Mi03ZTdhLTQxYjEtYWViOC02YjUyYTY5ZDg3MDgiLCJpYXQiOjE3ODAxMTQyOTAsImV4cCI6MTc4MjcwNjI5MH0.Ec9HQrFUozKJFFf681kc8To-XGNQRt5ke029j6YYjKyXO5zWMjyr1doRgpzZMVwB	2026-06-29 04:11:30.429+00	2026-05-30 04:11:30.429588+00
f39f0536-12e5-4511-8dfc-3f6290e34a21	dc440559-dd1c-462c-832f-a5bb648d9199	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkYzQ0MDU1OS1kZDFjLTQ2MmMtODMyZi1hNWJiNjQ4ZDkxOTkiLCJqdGkiOiIxODYzZTIxNy04YTE0LTRhOWMtODA0Zi0zODBkM2ZhNDNjZmYiLCJpYXQiOjE3ODAxMTQyOTUsImV4cCI6MTc4MjcwNjI5NX0.2mrW1L1SYpEr7qgwA7A0Ap7oFRF0rnwUT_fJIvNUbfX-w109X0Xmx_DAtzyvPHD2	2026-06-29 04:11:35.664+00	2026-05-30 04:11:35.664502+00
fcb9ad2f-ab86-495b-8d17-b83034b4c5f1	dc440559-dd1c-462c-832f-a5bb648d9199	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkYzQ0MDU1OS1kZDFjLTQ2MmMtODMyZi1hNWJiNjQ4ZDkxOTkiLCJqdGkiOiIzMzU1NzgwMy0wMzVmLTQ0YzYtYTBhNy05NTlkNzYyZDFiN2UiLCJpYXQiOjE3ODAxMTQzMDgsImV4cCI6MTc4MjcwNjMwOH0.w51WkOQTi94trVptOeR29DXx1WJiKJo4-Cre4J9oKCpykkiOGRc-B-liD3l0JngE	2026-06-29 04:11:48.434+00	2026-05-30 04:11:48.434918+00
b1d4d38e-7113-4e74-9667-92a723507bdf	dc440559-dd1c-462c-832f-a5bb648d9199	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkYzQ0MDU1OS1kZDFjLTQ2MmMtODMyZi1hNWJiNjQ4ZDkxOTkiLCJqdGkiOiI2NzlhYzRhYi1kY2U4LTQzYjQtOGI4Ni04MThmZjJlNTEyNTEiLCJpYXQiOjE3ODAxMTQzMjMsImV4cCI6MTc4MjcwNjMyM30.pzwBztGyP4BED-oF6Rx5luJjten2MYnpYooPMERguPKGMJO530Tjmswi9ROhvFq_	2026-06-29 04:12:03.877+00	2026-05-30 04:12:03.878976+00
7ed52edb-c35b-4ad0-9533-ed4c6af4e3e1	dc440559-dd1c-462c-832f-a5bb648d9199	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkYzQ0MDU1OS1kZDFjLTQ2MmMtODMyZi1hNWJiNjQ4ZDkxOTkiLCJqdGkiOiI5MjM5ZDNhNC03MWQ0LTRlNGItYjI0ZS0xZGM4MDFkNTM1ZWUiLCJpYXQiOjE3ODAxMTQzNjgsImV4cCI6MTc4MjcwNjM2OH0.cy5AcmNMAmuQ5OyEg2esdO65X2odzgZRihmOY5q2gNo1JmhL-RkkbsxN7qlj1wOA	2026-06-29 04:12:48.624+00	2026-05-30 04:12:48.624514+00
b9429321-1b57-406f-b86f-20b5e006cd75	dc440559-dd1c-462c-832f-a5bb648d9199	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkYzQ0MDU1OS1kZDFjLTQ2MmMtODMyZi1hNWJiNjQ4ZDkxOTkiLCJqdGkiOiI1MjNlNzdjOC1jYzdkLTRjMTMtYTFiNS1mNWZkYzlhMzQ5ZDEiLCJpYXQiOjE3ODAxMTQ0MTYsImV4cCI6MTc4MjcwNjQxNn0.1K7JhMKS6aX3pCJar7M4BBnAaeqpUP_xU12F2Zc3uMaMQW3CzMdfQ9EKj86gWsjL	2026-06-29 04:13:36.781+00	2026-05-30 04:13:36.781583+00
1f2cc0e5-06f0-4e05-bf9f-2e62f46ae930	3047f731-7822-47dd-930e-17c9b658cf55	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzMDQ3ZjczMS03ODIyLTQ3ZGQtOTMwZS0xN2M5YjY1OGNmNTUiLCJqdGkiOiI1MDdjZmI1Ny0xNmM0LTQ4N2EtOTcyYS0zNjI2NTQwMzZiMjUiLCJpYXQiOjE3ODAxMTQ0MzQsImV4cCI6MTc4MjcwNjQzNH0.KtXNqEPCMVl1-IyPI-Mbsj8HkTL8MP-Pp9PTFW0SqE1K_sCwTt4KZtgRF2CtCewp	2026-06-29 04:13:54.651+00	2026-05-30 04:13:54.652854+00
278d9061-9ee0-49e1-b08f-23d2d3730d56	814e5dd5-9805-4566-814a-0b97df3978d0	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI4MTRlNWRkNS05ODA1LTQ1NjYtODE0YS0wYjk3ZGYzOTc4ZDAiLCJqdGkiOiJlYWI2ODA2OC1hYjNjLTQxYTYtYmQ2Zi01MDQ1YzlhMDcwOTAiLCJpYXQiOjE3ODAxMTQ1MDEsImV4cCI6MTc4MjcwNjUwMX0.mpxgQlcQeRXQzVIqsm2MlnmRmCDNv9A3SKC4Xpt8iCgT_hzOAu_sDPuLETuOXIHb	2026-06-29 04:15:01.744+00	2026-05-30 04:15:01.744008+00
434e6848-885f-49bf-b9b7-04cdb96122ac	814e5dd5-9805-4566-814a-0b97df3978d0	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI4MTRlNWRkNS05ODA1LTQ1NjYtODE0YS0wYjk3ZGYzOTc4ZDAiLCJqdGkiOiIyN2NjMzkwNi1jMTA1LTQyMGItYWIxYi00OTYyNWUyYmVhMTEiLCJpYXQiOjE3ODAxMTQ1MTEsImV4cCI6MTc4MjcwNjUxMX0.gVfjr3n_OYHjI9NNqfGS44mlMKRB1WFx2O1knDh1EaLQBksV6NTeWnB-g-BnyUWC	2026-06-29 04:15:11.105+00	2026-05-30 04:15:11.106854+00
6579e760-8d58-40ed-966f-af05e6dfe06e	814e5dd5-9805-4566-814a-0b97df3978d0	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI4MTRlNWRkNS05ODA1LTQ1NjYtODE0YS0wYjk3ZGYzOTc4ZDAiLCJqdGkiOiJmYzdjNDIxZi00NzIwLTQ4YmUtOTFiMC0wMTIxNzk2OWFlODQiLCJpYXQiOjE3ODAxMTQ1MjMsImV4cCI6MTc4MjcwNjUyM30.tKPRJkba89KIiupys-11SH9jBCBqcgswZw2jt-3Z7cEmO6XnaeS4CofpYZuMHkB2	2026-06-29 04:15:23.422+00	2026-05-30 04:15:23.42253+00
cc152f02-9bf0-4500-8138-ec6675c7a211	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiJmYTNmNmZkYS02ZjM1LTQxZjUtYTg0Yy00OWRjZDhlZjRhYmYiLCJpYXQiOjE3ODAxMjMzMzMsImV4cCI6MTc4MjcxNTMzM30.OxcPhLrBRfbop3EW0fPc8o0t95RfD2of52Qxg1tP4tYPC29AEUFU9hk4wtMbKFCg	2026-06-29 06:42:13.522+00	2026-05-30 06:42:13.522857+00
d3a7947f-aac6-460d-9195-9ea68cc056c5	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiJlOWRhODJhYy1hYjdiLTQ0MTctOTUwOS04NGIzNjgxOGQ2NzIiLCJpYXQiOjE3ODAxMjUyNjksImV4cCI6MTc4MjcxNzI2OX0.y5xjl-MmHYHwYuEfei96xoXbYA_z3InZJnrnBvFq3g7Cnaf0lOmKhA4jU0yRRLgN	2026-06-29 07:14:29.069+00	2026-05-30 07:14:29.069444+00
60a9b768-ef9f-4a5f-9c0e-b02719bf91f0	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiIyMTA1MWNkZS00MTFjLTQ4OGUtYmE1Yy1mNjU3YjZjYzVlMzUiLCJpYXQiOjE3ODAxMjUzMTIsImV4cCI6MTc4MjcxNzMxMn0.BdFOkRqS_Km7JHvyMkMqqFcPtVJsJrzgHCjpdQ2fqyz0oK0j9VnwwOhLREnhvIXg	2026-06-29 07:15:12.725+00	2026-05-30 07:15:12.725235+00
67ec8384-ef6b-4f70-a6c3-958396acf1a5	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiIxOTYxNWZlMi0zMzg3LTRjMTItOWI4My1lYjdmZGUwMzVmNGEiLCJpYXQiOjE3ODAxMzA3NzcsImV4cCI6MTc4MjcyMjc3N30.50z_7OQfwwYgjz-qCinZgsIEP2eHQMQ24pwQkwg714A8D2rgbtlYladDCWvYXjS0	2026-06-29 08:46:17.351+00	2026-05-30 08:46:17.352512+00
cf1a9d6d-df04-4f9f-8bf1-0993a6d1b531	91e602be-25b8-4fd4-9769-b307cd9af888	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI5MWU2MDJiZS0yNWI4LTRmZDQtOTc2OS1iMzA3Y2Q5YWY4ODgiLCJqdGkiOiJjZDZlODg5MS0yZTg1LTQ2MjctOTQ1Ny1hN2MyMjkxODVmYjYiLCJpYXQiOjE3ODAxOTg0OTYsImV4cCI6MTc4Mjc5MDQ5Nn0.2LHM0afYrhaUvv5UVC4mLwtrem6RMbWFiWvJ1gw-vx5lQ0li5hFdP6FMMFi39E1K	2026-06-30 03:34:56.719+00	2026-05-31 03:34:56.72027+00
bafed9c1-66ce-46e2-993e-34095067ce94	91e602be-25b8-4fd4-9769-b307cd9af888	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI5MWU2MDJiZS0yNWI4LTRmZDQtOTc2OS1iMzA3Y2Q5YWY4ODgiLCJqdGkiOiIwYjlkNmQ2Yi1iNDk3LTQ3MmUtYWIxZC1mM2IzNjQ5ZTM2ZDkiLCJpYXQiOjE3ODAxOTg0OTcsImV4cCI6MTc4Mjc5MDQ5N30.h1ARP3K5GahDVcyflbYuhlHGzyx2TBC58XmKpW4f68KTL2LaWd9zv66pAeF-VkzT	2026-06-30 03:34:57.446+00	2026-05-31 03:34:57.447207+00
999798dd-649a-463e-9d56-a05e86bd76d7	91e602be-25b8-4fd4-9769-b307cd9af888	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI5MWU2MDJiZS0yNWI4LTRmZDQtOTc2OS1iMzA3Y2Q5YWY4ODgiLCJqdGkiOiIzZDVlMTg5MS04MDNiLTRmNGYtOTljMi1lYWE2ZWQ3MzkwZWUiLCJpYXQiOjE3ODAxOTg1MTQsImV4cCI6MTc4Mjc5MDUxNH0.ki_PVxvsyjea2eMaIhb7UIqFv0SJmD0TDe69bFS4W9ooAZLuGSajqMpoJQdOqK3V	2026-06-30 03:35:14.033+00	2026-05-31 03:35:14.03304+00
f59bf358-9148-4f62-8d44-409eda281ebc	91e602be-25b8-4fd4-9769-b307cd9af888	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI5MWU2MDJiZS0yNWI4LTRmZDQtOTc2OS1iMzA3Y2Q5YWY4ODgiLCJqdGkiOiI3Y2YxNjlhZS02OWQ2LTRiZmMtYmNhNS00MDYwOWNiOTcxMmQiLCJpYXQiOjE3ODAxOTg2NTAsImV4cCI6MTc4Mjc5MDY1MH0.CKp7K7cu8iJKAdFToBczKpvUMdzejVfey-n_wWfypk2b_6Wlnp35mF51ubqrpUxx	2026-06-30 03:37:30.965+00	2026-05-31 03:37:30.966466+00
8231742a-38b5-473d-a36c-e95742973aa4	91e602be-25b8-4fd4-9769-b307cd9af888	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI5MWU2MDJiZS0yNWI4LTRmZDQtOTc2OS1iMzA3Y2Q5YWY4ODgiLCJqdGkiOiI3MzJhNWEzMi01MjA0LTQzYWQtYmM5Zi0yMzVjYjZhOTU2MDMiLCJpYXQiOjE3ODAxOTg2ODcsImV4cCI6MTc4Mjc5MDY4N30.Hx70Y13ElVXEOkF9YwfJv4dFPA9z55A1Z2giyJMkv5eglo_smqyzQZIbVYKAJcGA	2026-06-30 03:38:07.077+00	2026-05-31 03:38:07.077179+00
738e8d92-729c-4a58-82d0-bbe581fb8b97	91e602be-25b8-4fd4-9769-b307cd9af888	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI5MWU2MDJiZS0yNWI4LTRmZDQtOTc2OS1iMzA3Y2Q5YWY4ODgiLCJqdGkiOiJkMWI2NmY2My1mMDg3LTQwZGItOGJlNC00MjMxYzdlM2FkMDIiLCJpYXQiOjE3ODAxOTkzMjIsImV4cCI6MTc4Mjc5MTMyMn0.cLH5HIhX3Q7_XRsOew5DQCsC1miwSqdF7TYx7wb2MIYQ8J-7noZZSOKGNkhjoelb	2026-06-30 03:48:42.206+00	2026-05-31 03:48:42.206391+00
f7123b90-553c-4816-940d-0a878a24f0bb	91e602be-25b8-4fd4-9769-b307cd9af888	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI5MWU2MDJiZS0yNWI4LTRmZDQtOTc2OS1iMzA3Y2Q5YWY4ODgiLCJqdGkiOiI2ZjA5YWRhOS1iZTgyLTRiMWItYTZmNi1kZDJkZmY2MGU1ZmYiLCJpYXQiOjE3ODAxOTk0ODQsImV4cCI6MTc4Mjc5MTQ4NH0.IEhMGCOKwqHXfozX_3wKpAvZgEVbi9lkV8Fehris5n0-dexNFZ_wVmowaKyfWZV5	2026-06-30 03:51:24.241+00	2026-05-31 03:51:24.241708+00
c90e51c3-812b-411c-bb21-27458f08148c	91e602be-25b8-4fd4-9769-b307cd9af888	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI5MWU2MDJiZS0yNWI4LTRmZDQtOTc2OS1iMzA3Y2Q5YWY4ODgiLCJqdGkiOiJmOTRiY2E3Mi0yODcwLTQ4NjMtOTYwZS05M2Q4ZjI1MjMxYzQiLCJpYXQiOjE3ODAyMDA2MTYsImV4cCI6MTc4Mjc5MjYxNn0.ZGuH-HFx-Lh82kIT0_zhb0WIGcoFcJahAy_K_zojLh9tXXKvgWaW3BYgydJ9Cjty	2026-06-30 04:10:16.406+00	2026-05-31 04:10:16.407239+00
8a2b7d72-1e18-4d22-ab18-5fca5d0336bc	91e602be-25b8-4fd4-9769-b307cd9af888	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI5MWU2MDJiZS0yNWI4LTRmZDQtOTc2OS1iMzA3Y2Q5YWY4ODgiLCJqdGkiOiIzZDI0YTY3OS00YjI0LTQ3NzktYjYwMC05NzU1NTJmNWNlNzIiLCJpYXQiOjE3ODAyMDA2NzksImV4cCI6MTc4Mjc5MjY3OX0.3kd17mClhxKyKB8Ew64KbnnmV0JtRn7X5DLZ4fNWsQqxZghUVK5pZKlgLIK2tcC4	2026-06-30 04:11:19.298+00	2026-05-31 04:11:19.298006+00
3447a5f9-8e96-4f1d-ad9e-31813cf71f81	91e602be-25b8-4fd4-9769-b307cd9af888	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI5MWU2MDJiZS0yNWI4LTRmZDQtOTc2OS1iMzA3Y2Q5YWY4ODgiLCJqdGkiOiJlODY2NDY1NS1jOGRlLTQ5NDgtYmQzYi0yMTU4MmE0MWE1YWMiLCJpYXQiOjE3ODAyMDA5NzAsImV4cCI6MTc4Mjc5Mjk3MH0.14p-Rc_vDh5NaaiOPT7STsmaBtTtrpqDkYbc1bdJWNFtnqIQOBXXHH6SZJkMvCnS	2026-06-30 04:16:10.73+00	2026-05-31 04:16:10.730399+00
be402d7a-7653-49fd-ad7b-e2ca4391f69f	91e602be-25b8-4fd4-9769-b307cd9af888	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI5MWU2MDJiZS0yNWI4LTRmZDQtOTc2OS1iMzA3Y2Q5YWY4ODgiLCJqdGkiOiI4MzZmMzJiYy1iZTVjLTQ5OGItOGU0NS1mYTJmYzc1ZDU4YTMiLCJpYXQiOjE3ODAyMDI5MDIsImV4cCI6MTc4Mjc5NDkwMn0.44SI-xUilpyaH3HMTVXOKXhscZXqBSSEXowPqgKjtHPE9zHM3zRKLC06pK3Li1k7	2026-06-30 04:48:22.822+00	2026-05-31 04:48:22.82335+00
635ab253-8f40-4977-abde-f9a22b619ad8	f7fe48c3-2101-45ba-86cd-26f0bf28a923	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmN2ZlNDhjMy0yMTAxLTQ1YmEtODZjZC0yNmYwYmYyOGE5MjMiLCJqdGkiOiI4YTk1MmM2NS03NzhlLTQyMmEtOWQ2My1jMzYyM2U0YzhjODUiLCJpYXQiOjE3ODAyMDgwNjMsImV4cCI6MTc4MjgwMDA2M30.CtHsrILK0lLMyPoWalaxZ-pa4vjvAU4vIVbVDZ56tVKHrOYriI0hxHW__H8BJbiQ	2026-06-30 06:14:23.032+00	2026-05-31 06:14:23.032908+00
4a34f00b-9ec6-47d8-a348-813e53f817f4	f7fe48c3-2101-45ba-86cd-26f0bf28a923	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmN2ZlNDhjMy0yMTAxLTQ1YmEtODZjZC0yNmYwYmYyOGE5MjMiLCJqdGkiOiJjNzMyZTY2My1jOGFkLTRlNWMtYjYzNi1iOGU1YzFmMTgzNWUiLCJpYXQiOjE3ODAyMDgwNzQsImV4cCI6MTc4MjgwMDA3NH0.AyyeHf2f1wCD1sZCcZLCWhXOAl8nf7wnI6PpRy3vLRPpNWmS-c224zuAvWrDLoCE	2026-06-30 06:14:34.925+00	2026-05-31 06:14:34.92533+00
6a6e932b-3659-48c3-9f47-7977a515c90b	f7fe48c3-2101-45ba-86cd-26f0bf28a923	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmN2ZlNDhjMy0yMTAxLTQ1YmEtODZjZC0yNmYwYmYyOGE5MjMiLCJqdGkiOiJhZDE5YzIwMi0zMWRiLTQyNjUtODcxMC0zMWYyZDU0MTQyNGUiLCJpYXQiOjE3ODAyMDgwODgsImV4cCI6MTc4MjgwMDA4OH0.gG67jAbFxabXJcnhexM30Cw58esK2PEWsF96WuBSZJ3D5Nh1SESwX3Jr534X8Tl2	2026-06-30 06:14:48.201+00	2026-05-31 06:14:48.201153+00
9747d2cd-af50-407c-902c-2c84eacb3bf8	f7fe48c3-2101-45ba-86cd-26f0bf28a923	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmN2ZlNDhjMy0yMTAxLTQ1YmEtODZjZC0yNmYwYmYyOGE5MjMiLCJqdGkiOiIzZjExNjczZi04Y2FmLTQwNDEtYTdlNC03OWUyNzFhMjJjOTciLCJpYXQiOjE3ODAyMDgxODMsImV4cCI6MTc4MjgwMDE4M30.2YzkYgGVCgTeyB5wb06pyCGetwcF__DdUMxrFkHYx4z1Xn04sUiqoEqmNI5jiewE	2026-06-30 06:16:23.002+00	2026-05-31 06:16:23.002769+00
6f9025ce-af16-4e23-8a0b-52a4d7e5f097	f7fe48c3-2101-45ba-86cd-26f0bf28a923	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmN2ZlNDhjMy0yMTAxLTQ1YmEtODZjZC0yNmYwYmYyOGE5MjMiLCJqdGkiOiIxMTE3MTBiYy1kMzNiLTRkNGUtYjRlZi1kNWU4YTI5ZDMwNjUiLCJpYXQiOjE3ODAyMDgxOTYsImV4cCI6MTc4MjgwMDE5Nn0.CncUM7drGAIy4KTqOtpSc78LyjmzzebgB7syJW5nTDwvuodVoez3LdjoZmbeZhJD	2026-06-30 06:16:36.227+00	2026-05-31 06:16:36.227804+00
89ce2399-38b0-4996-b289-db15a5de56f0	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJjYWVmZGIzNy1kODg1LTRkNGYtOWQ5My00ZmEwZjVkNTE4MDciLCJpYXQiOjE3ODAyMDg3NDgsImV4cCI6MTc4MjgwMDc0OH0.sM0PgW8f7fmFYk2t_tA5Ygf5-pD8HP3wyzm10Mlvj4SiM-AGBLpmGQqp9B61VNmV	2026-06-30 06:25:48.066+00	2026-05-31 06:25:48.06959+00
55f7e489-c6b2-4565-b67a-81fd1e82a08b	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiIzNzFlYWRhMy1lMmZmLTQxNWUtYTBmZC0wMDdlYzg1MmU4OGUiLCJpYXQiOjE3ODAyMDg4NzksImV4cCI6MTc4MjgwMDg3OX0.hGuow7oPvS4gDHLb2IfpezLD_XK71fIrvL6HhYXGfnrz1CAyo0kmm2EhtwNrzdfk	2026-06-30 06:27:59.665+00	2026-05-31 06:27:59.669477+00
22138406-3377-467d-8820-afd435e4e9eb	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiIxMWNjNWM5ZC1jMTBjLTRjMmItYjQwZC1hNjVmYzAwOWEzZjAiLCJpYXQiOjE3ODAyMzU5NDgsImV4cCI6MTc4MjgyNzk0OH0.iqZ6fbohwD-uXV81Q0pnxbdZ5VqX8rEQ4fPOGj0EyvIX279ZixOY7tA965vDWgWS	2026-06-30 13:59:08.079+00	2026-05-31 13:59:08.084462+00
f69a0142-7312-42b2-a3a2-50c6b1f187ed	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI0ZWQxZWIyOC00NzlmLTQyMmUtYTNmNy0wNzU5MmY4YWNmN2MiLCJpYXQiOjE3ODAyMzY5MzUsImV4cCI6MTc4MjgyODkzNX0.nLqY1Y2HlVJCLVF3jV7voMbpjVRM7Tx8Lrx6kJQoSq8mQsyRQZCTzMSS-J7npmxL	2026-06-30 14:15:35.684+00	2026-05-31 14:15:35.686584+00
c29b557b-0c27-4323-b096-23ff61f0336f	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJmNTc3YjVlYS1kN2UxLTRkNWItYTk2ZS1mNzlkNjBiMTJlNTgiLCJpYXQiOjE3ODAyODA4NjQsImV4cCI6MTc4Mjg3Mjg2NH0.G-5Hoc6TmdGQ2DEMolJzszU6fZu82aPDXF5wJDwtGhr7xuMOWEHzxghV2_bZg_oN	2026-07-01 02:27:44.656+00	2026-06-01 02:27:44.661143+00
edf9b97f-647e-4096-a3f5-124c47f64394	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJjMTI0Yzg3MS0zMDMyLTRlNTYtOTk4Ni0zNTJiMTY0YmRmYjEiLCJpYXQiOjE3ODAyODA5NTMsImV4cCI6MTc4Mjg3Mjk1M30.N-jl5jB8QpVI2o_AIn438H3qk9mTQFUxLwiZTHip79LpWZMBli4wWRzSXNMtYgca	2026-07-01 02:29:13.565+00	2026-06-01 02:29:13.565686+00
1e3cf89f-712f-42f7-bda3-52a5360d61e7	f7fe48c3-2101-45ba-86cd-26f0bf28a923	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmN2ZlNDhjMy0yMTAxLTQ1YmEtODZjZC0yNmYwYmYyOGE5MjMiLCJqdGkiOiIzZGY5ZmI4My0zMWYyLTQ1ZGYtYTYwMS02YjliMmUwMDhhNDAiLCJpYXQiOjE3ODAyODEzMDgsImV4cCI6MTc4Mjg3MzMwOH0.aOSWg4bAiJwhngImtUHpBbOlNDeV8eRE9mpBTtjS9D_sOvvTBojzErk-u8XWh2zq	2026-07-01 02:35:08.329+00	2026-06-01 02:35:08.332902+00
ec8d0eff-8ed4-4096-be67-04aa8823b7a3	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiIzZGM2MWM2Ni00NDJkLTRiYzEtYjVmNC05N2I3YWMzOGY2ZmYiLCJpYXQiOjE3ODAyOTQ0MjcsImV4cCI6MTc4Mjg4NjQyN30.FXRV6qJ3JmeV18TV1w5Tnz8cpiQ69kDrgwPAII2iheeBRv3xDqnkAUDWN2DrOBAs	2026-07-01 06:13:47.522+00	2026-06-01 06:13:47.525583+00
29b8b73e-5af0-456b-ace8-6f335251f3b4	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI2ZDBkNGVkMS05NGU0LTRiMDUtYjM5Mi0xNTYwY2IxYTQ3OTkiLCJpYXQiOjE3ODAyOTQ0NTcsImV4cCI6MTc4Mjg4NjQ1N30.rmxDIBJJVUr47XO8GWltgRCd4P5WFBuN9HmmHPKEdMqZsA_dxfqKoUb0X_K6oTCF	2026-07-01 06:14:17.888+00	2026-06-01 06:14:17.889831+00
ddc65b48-d1fd-4974-8d03-d38aa6794213	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmMDZmMzFkZC05ZWM0LTRkNmMtOWU4ZC1jOGFkY2RmNTc2OTMiLCJqdGkiOiIzNzRiYzhlNi1iN2M0LTQ3MzktOTBhNC02Yjc1MmJhZGI3MjUiLCJpYXQiOjE3ODAzMDAzNzgsImV4cCI6MTc4Mjg5MjM3OH0.Aqdk5SScsciu4RyXavuuUd44u1acsa9koPqSFf62RMuTmsw4N1DtvicIhRQ1BtOl	2026-07-01 07:52:58.196+00	2026-06-01 07:52:58.196575+00
5c69fa22-067f-4851-b43d-5a9a4b0e34f6	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJlOWZhYjU1Ny0xYWRmLTRlYjQtYmQyYS02ZTAzODUyZjZmZmYiLCJpYXQiOjE3ODAzMDA5NTUsImV4cCI6MTc4Mjg5Mjk1NX0.ygwljDrIFbBsRPCFAGg8FcxMAGxieMnUOgy4BDL6KcDOT9AC98YtWe5pKPAQrTOL	2026-07-01 08:02:35.579+00	2026-06-01 08:02:35.579134+00
81b54296-0100-4051-a11e-275a41501c0d	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI2OWE5MjkxYS1iYzIxLTQwYzEtOWY2MS00Zjc3YTM5NjFlM2IiLCJpYXQiOjE3ODAzMDExNTMsImV4cCI6MTc4Mjg5MzE1M30.QvFl_uZZdgHIZ04hhId09QJI__VSUPWBSqMmefIyOKGHzpGAfQMs7UI2tCd30_Fn	2026-07-01 08:05:53.097+00	2026-06-01 08:05:53.10354+00
0e01121e-5749-45f3-a2af-338976e148c7	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiIxYzIyMmYzYy01Yjc0LTQ2NzEtODY5Yi1kYTBjYWI1NWYxM2MiLCJpYXQiOjE3ODAzMDExNzAsImV4cCI6MTc4Mjg5MzE3MH0.E3MNQfvKNNqTeXYLEYR-ch3wJSsJ5-7wQs9C54ihltWCcFwpUE__kT5IYvmQfGNa	2026-07-01 08:06:10.934+00	2026-06-01 08:06:10.935346+00
dcb20d76-f68d-4f4a-a622-411fd4e77a27	627d6150-9fe6-41e4-98fd-e966fb11d5f2	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI2MjdkNjE1MC05ZmU2LTQxZTQtOThmZC1lOTY2ZmIxMWQ1ZjIiLCJqdGkiOiI0ZmM4ZjBiMC00ZTVlLTRkNjYtOTNkYy0xMzM3ZWU1OTM5OWIiLCJpYXQiOjE3ODAzMDExNjgsImV4cCI6MTc4Mjg5MzE2OH0.axAaYng1abz0DevR8-bdCVCzxRhGogLJW9LnNGZPYDndZfnwrL8Tvu_-Ge1y1Stm	2026-07-01 08:06:08.779+00	2026-06-01 08:06:08.779707+00
74421e0a-5e99-47db-9160-d82cd5bd0560	7be2a683-5537-41c2-b834-ea534816a945	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YmUyYTY4My01NTM3LTQxYzItYjgzNC1lYTUzNDgxNmE5NDUiLCJqdGkiOiI0NzZiNThhYS0xYjU4LTQ5NTAtOTM5Yy03NjhjNjQ5MTcxOTIiLCJpYXQiOjE3ODAzMDEyOTAsImV4cCI6MTc4Mjg5MzI5MH0.pWzozeg5Ckt5qEsYm4r1arSG3ML3M9PIOgHKXBaN19tvYQnlOi5BT89P3J8_l54f	2026-07-01 08:08:10.321+00	2026-06-01 08:08:10.321015+00
ae0d8bcb-ee90-4b1d-8dae-23a88354c71a	7be2a683-5537-41c2-b834-ea534816a945	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YmUyYTY4My01NTM3LTQxYzItYjgzNC1lYTUzNDgxNmE5NDUiLCJqdGkiOiIwYTFlMzdiMC1hMWY3LTRmZjQtYjE0My0yZDdmZjZlMjE4YWYiLCJpYXQiOjE3ODAzMDEzMDIsImV4cCI6MTc4Mjg5MzMwMn0.bD3opM_8_C_hUyQLrX6yy6wg1IHoCUh6Qr0JETDbdumm7KsJJeJiy3csV_m_T1b2	2026-07-01 08:08:22.512+00	2026-06-01 08:08:22.512617+00
59a68b8c-58fe-4cd8-b1c3-f7e03d01ea6d	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJjYWYzZWEyNi02YzFjLTRjZmYtOTY2NS04NTNhNzc1YTc1MzQiLCJpYXQiOjE3ODAzMDM2NDUsImV4cCI6MTc4Mjg5NTY0NX0.8iTCuXp25nWbl6nWTqL5rpM2riQdmahdc-5XywLrWHYjRaVgpDCc8vPT5JjN7_jg	2026-07-01 08:47:25.142+00	2026-06-01 08:47:25.144672+00
01cb638d-e7e8-401c-9668-56d9e219af7f	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJhNWEwNzM5Yy0wYmI0LTRjYWQtYTk2OC03MmYyYjBkMzFiY2IiLCJpYXQiOjE3ODAzMDc1MDMsImV4cCI6MTc4Mjg5OTUwM30.gKMAzi9CSS_IfWED9GG8cnHw8FK0IiOT-TrHINtFpyTXy4V5l2ysOa_9XkTPOjun	2026-07-01 09:51:43.162+00	2026-06-01 09:51:43.162698+00
3c2c4538-0765-4327-bfb4-bd5343e3016d	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI3YTgyODRhYS0wMzc4LTQ1YTgtOTA0ZS1lZWFmNzdjMGEyYzgiLCJpYXQiOjE3ODAzNjQ3MTMsImV4cCI6MTc4Mjk1NjcxM30.Dj2M6MsYZhw7v2W1cOiMvAGCxAOIExL9hwl212di6oD9ps1CizS1fQE3Xt7WEEdZ	2026-07-02 01:45:13.643+00	2026-06-02 01:45:13.645718+00
53c4d253-88d5-4326-844b-be040b73d5b0	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI0YzgxZjkxYS0zNmNhLTRjMmQtODZiZC0wYTVlNGVmOTY0NDYiLCJpYXQiOjE3ODAzODY1ODIsImV4cCI6MTc4Mjk3ODU4Mn0.CXZKJl3cf7s66HgY9O5DF3DlaH_QlTRCABo51FhPmWglWHQrIVMK0AkCWZfO6DV_	2026-07-02 07:49:42.728+00	2026-06-02 07:49:42.729403+00
37b5f3f3-2f39-496a-bf25-4b560db43a14	627d6150-9fe6-41e4-98fd-e966fb11d5f2	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI2MjdkNjE1MC05ZmU2LTQxZTQtOThmZC1lOTY2ZmIxMWQ1ZjIiLCJqdGkiOiI0MjFmOThmZC1mZjIyLTRlNzYtYjUzMi03OWQyYmNjOTFjZjYiLCJpYXQiOjE3ODA0MDg1MzMsImV4cCI6MTc4MzAwMDUzM30.TWa_DeDBQ8rKKG0e9z2E9irAtgS2oeRKr87yehj9uMwZNmET05tSlE7w077QzDF9	2026-07-02 13:55:33.904+00	2026-06-02 13:55:33.915411+00
df2f49e8-f76b-402a-8027-f1fa154d9f57	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI1NDA2OTgyMy04ZmJlLTRhNDUtYWJlZi1jYzg4NGE0YTQ0OGUiLCJpYXQiOjE3ODA0MDg5NzUsImV4cCI6MTc4MzAwMDk3NX0._xQ7Mpz1oPOxgkYAlUgYNze-y-zbaoe43D3CEukkIeVTwRk-own01PameNsV9QzL	2026-07-02 14:02:55.838+00	2026-06-02 14:02:55.838601+00
3e14746d-b862-435c-9775-fcf59a4bc3e4	7be2a683-5537-41c2-b834-ea534816a945	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YmUyYTY4My01NTM3LTQxYzItYjgzNC1lYTUzNDgxNmE5NDUiLCJqdGkiOiJlMWM0YjE2Ny04MDM3LTRiZGEtOGVhZi0yYWY1Mzk2NWQ4MmYiLCJpYXQiOjE3ODA0MTI1OTQsImV4cCI6MTc4MzAwNDU5NH0.qEjsadOJWyoTBx-_HWl4n1-qJECFbuCAdMnQSuP8c5vioMxxAl1SrXcCdNZVKRUo	2026-07-02 15:03:14.011+00	2026-06-02 15:03:14.011884+00
e4e5042e-634b-4f59-baca-1fce66d5430b	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI1NzllYzBmZS04NjRkLTQ5NzUtYjVkZS0yNmY1ZjE4OGI4OTMiLCJpYXQiOjE3ODA0NTc2NzIsImV4cCI6MTc4MzA0OTY3Mn0.08cW1X0SzsmVt6aAumpupvz-ioqtUWoJfwjUZOs0D-lO0so1uoZvXNTqfK0Lhjn2	2026-07-03 03:34:32.433+00	2026-06-03 03:34:32.436617+00
7522bfad-dbdb-4f10-bbf3-9bd7b7ae699e	814e5dd5-9805-4566-814a-0b97df3978d0	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI4MTRlNWRkNS05ODA1LTQ1NjYtODE0YS0wYjk3ZGYzOTc4ZDAiLCJqdGkiOiIxYmYzNDIwOC0zMWYyLTQ0NTQtYjhkMi04Mzk1NTYzNzZkN2EiLCJpYXQiOjE3ODA0NTc3MDAsImV4cCI6MTc4MzA0OTcwMH0.S90UQtsYp030qAMjUtirsqFguISoeM4_lWf786HcMtK7Bs1wOmv-PgG5Kpsyuhgn	2026-07-03 03:35:00.978+00	2026-06-03 03:35:00.97848+00
3e789d5b-37e4-4e3e-8a45-4f73bdb8919c	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIwZDEyYzU0YS04ZGZiLTQ3ODEtOTkyMS00MDM0MWY5MDUxNjYiLCJpYXQiOjE3ODA0OTEzMzcsImV4cCI6MTc4MzA4MzMzN30.lSkuoP1mbKJqulHr-uKjtjUABvdM3OZWq7FX3R02-jlp3vzE_naxgbZpL-eyipyA	2026-07-03 12:55:37.651+00	2026-06-03 12:55:37.654772+00
775fa224-007a-4677-b4a6-1425bca7ca6c	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI4OTM3NmE4NS0zYzAyLTQ2OTgtODA1MC1lN2QyN2RmMjRkMDMiLCJpYXQiOjE3ODA0OTE0MTgsImV4cCI6MTc4MzA4MzQxOH0.MI48lbOGkmR0bdi87mNadVGtU0nl2jkd1yqAwUymMF7A1QGr8UO9L2DCsZRQz4qN	2026-07-03 12:56:58.494+00	2026-06-03 12:56:58.494539+00
162851eb-a73d-4f0c-8cd8-9fcef24dd8a4	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJiZTczY2M0ZC02Y2FhLTQzZGYtYjRkNi1kNDE1ZDhmNTBjZDciLCJpYXQiOjE3ODA0OTE3NzksImV4cCI6MTc4MzA4Mzc3OX0.lentnfgmyW4780JcwcoROqucoG7MEascQWh6W6hoM2Oh82UXWlIP2TKaiOh6j5os	2026-07-03 13:02:59.576+00	2026-06-03 13:02:59.576059+00
23fd6b8e-1725-4a41-a235-82564406e424	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI5Y2Q0ZWY5My1hOTY0LTQyMmYtODBiOC0yZDI2ZTEzODE2MzciLCJpYXQiOjE3ODA0OTI5MTcsImV4cCI6MTc4MzA4NDkxN30.8CblVmyGGpnCkOjDqQHLRIiwuVZTWXPBtSP6voQ_qVseZhuVIwK8gNdvvPGn3Hjc	2026-07-03 13:21:57.715+00	2026-06-03 13:21:57.715918+00
4511b9bb-d88f-4a45-99b5-e6105062de31	7be2a683-5537-41c2-b834-ea534816a945	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YmUyYTY4My01NTM3LTQxYzItYjgzNC1lYTUzNDgxNmE5NDUiLCJqdGkiOiIwOWVmNmNkZi0wMWVmLTQ0M2MtYTJkZi1lZWY5Zjk1N2QwYzciLCJpYXQiOjE3ODA0OTM0MzgsImV4cCI6MTc4MzA4NTQzOH0.qeypLjVIU3B8xydt4YdnRjEndXkt7Z2BpE0ubhCknRjThTeBt6L7WzL2eIBglIyx	2026-07-03 13:30:38.544+00	2026-06-03 13:30:38.544475+00
54c2c29f-97dc-41f4-bcc8-c82d8d4b2f01	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI4Yjc1ZDk1YS1iYTRjLTQ3YjAtYmUyYS0xNTdkZDE0NjliODYiLCJpYXQiOjE3ODA0OTY5MzQsImV4cCI6MTc4MzA4ODkzNH0.CFYLNR263wlIE5yCOaSQ0GRoF5EC2qauBYWPkP3SNiG8cGtGZWUw7tKsu1aQYTp_	2026-07-03 14:28:54.15+00	2026-06-03 14:28:54.15236+00
fb1ff193-1a81-42cb-93ab-a5025e77145e	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI5M2VkYjYzNi0xNjhhLTRjMGYtOWZjNi04YWQ5N2UyZTEzNWIiLCJpYXQiOjE3ODA1MDE4MjYsImV4cCI6MTc4MzA5MzgyNn0.WEHtCySnVJ5cWU3aTYM5AQ0V6et1JW-9tkLG8D_Gv12daNrII61m6SsxaJvp7hAz	2026-07-03 15:50:26.592+00	2026-06-03 15:50:26.596545+00
420bed6e-0846-4e6d-99e7-25fede6b8b05	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiIzYTliZGJiOS1hNzkzLTRjZGMtOWNmOC1lZmMzYTIzNGNjZjciLCJpYXQiOjE3ODA1MDE4MzYsImV4cCI6MTc4MzA5MzgzNn0.afHgeIMygfeB84gbILhlpOEEOjOKpCbxvc2hUBn-PncKqGRGAlWg0xfOIoBZq1Yi	2026-07-03 15:50:36.02+00	2026-06-03 15:50:36.020658+00
d5fbc95b-bd24-4d01-90ad-d1523602c906	814e5dd5-9805-4566-814a-0b97df3978d0	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI4MTRlNWRkNS05ODA1LTQ1NjYtODE0YS0wYjk3ZGYzOTc4ZDAiLCJqdGkiOiIxOWFhZjY1OC01NTMzLTRhZGQtYjQ1ZS02ZDNmOTJkNzg4NmQiLCJpYXQiOjE3ODA1MDIwMTYsImV4cCI6MTc4MzA5NDAxNn0.XUhjta5xn_p7GpFuABA3JXbx0OQpcpi_8CpUWyAW4l6FCSabsadLAijPYSzRhJzF	2026-07-03 15:53:36.068+00	2026-06-03 15:53:36.068766+00
f6e5a8e0-6479-4ea7-9dcb-562f527105bd	3047f731-7822-47dd-930e-17c9b658cf55	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzMDQ3ZjczMS03ODIyLTQ3ZGQtOTMwZS0xN2M5YjY1OGNmNTUiLCJqdGkiOiI5MjYwZDFkMC1kYTc0LTQ1ZDQtYmVhMC0xMmVjZGMxNzcwMDMiLCJpYXQiOjE3ODA1MDIwMzUsImV4cCI6MTc4MzA5NDAzNX0.h4RIb-LK2QsIGX-5egefmvIgIVzDOVCJzOQ2VM7HACYXaC0aarjTS_jHDOjpKkPw	2026-07-03 15:53:55.003+00	2026-06-03 15:53:55.003064+00
45407bf6-2810-4e01-8b88-22f9446b8493	3047f731-7822-47dd-930e-17c9b658cf55	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzMDQ3ZjczMS03ODIyLTQ3ZGQtOTMwZS0xN2M5YjY1OGNmNTUiLCJqdGkiOiJiOWU2M2M2OC0zOTYyLTQ2NjMtYjU3ZS1kMTA1Y2Y0M2NkNTYiLCJpYXQiOjE3ODA1MDIxMDQsImV4cCI6MTc4MzA5NDEwNH0.sSqXxxfRn_DkiJkgutNLL-rwx8JAYFltsiwMaY6UtYV0Ez5GbtklMJwxmTyF6qht	2026-07-03 15:55:04.758+00	2026-06-03 15:55:04.758521+00
a925c72b-9b78-4960-934d-676c49b9b734	3047f731-7822-47dd-930e-17c9b658cf55	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzMDQ3ZjczMS03ODIyLTQ3ZGQtOTMwZS0xN2M5YjY1OGNmNTUiLCJqdGkiOiI2YTViZTE2Yy0zNWI2LTRjMTUtODczNS1kOTNkMDFjOGFlODUiLCJpYXQiOjE3ODA1MDIxNTgsImV4cCI6MTc4MzA5NDE1OH0.1T3YTgn2XstdDOf_9yWuWrb_QwAxpCLmxxtcM6ghIo9-E1MBNcvMWxL_S-xjrrbZ	2026-07-03 15:55:58.776+00	2026-06-03 15:55:58.776416+00
a9ee1fbb-d451-4f6e-bfd5-6b154d8c9ea4	3047f731-7822-47dd-930e-17c9b658cf55	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzMDQ3ZjczMS03ODIyLTQ3ZGQtOTMwZS0xN2M5YjY1OGNmNTUiLCJqdGkiOiI2MzQ1MzJmNS03MWNjLTRmZTMtYTZkNC01ZmJhY2Y3MDI4MmIiLCJpYXQiOjE3ODA1MDIxODQsImV4cCI6MTc4MzA5NDE4NH0.rH3lOUzRcO5qa892EQfZZHLkWEG2L77G4KKm_k8htZ9BJ7JYqmhmAcM7FfVrXS8i	2026-07-03 15:56:24.755+00	2026-06-03 15:56:24.756048+00
b5db7e46-4779-4f23-8b93-e30d7e8e8196	3047f731-7822-47dd-930e-17c9b658cf55	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzMDQ3ZjczMS03ODIyLTQ3ZGQtOTMwZS0xN2M5YjY1OGNmNTUiLCJqdGkiOiJkM2RjN2VmNC0wOTYyLTRlNWUtOTlhMy0wYjg4MGM5ODQxOWMiLCJpYXQiOjE3ODA1MDIyMjEsImV4cCI6MTc4MzA5NDIyMX0.lQSe1NKYGmocS_0rZW8TsAPuRAbK1J7Vwqg80JzqCvpHvpyXV1JEeD4N9feGwpgE	2026-07-03 15:57:01.629+00	2026-06-03 15:57:01.62937+00
9273caeb-ed46-4f29-a15a-106a88f39bf6	3047f731-7822-47dd-930e-17c9b658cf55	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzMDQ3ZjczMS03ODIyLTQ3ZGQtOTMwZS0xN2M5YjY1OGNmNTUiLCJqdGkiOiIzZmIwOWNhNi01NDYwLTQ3NTgtODUwNi05ODFkNjBjOTJjZWUiLCJpYXQiOjE3ODA1MDIyMjgsImV4cCI6MTc4MzA5NDIyOH0.86nMgS48dS3aBDqIrMN36G6jVF9bSvrgUnjF9CYAmeoE_0GZtDcUsP-EtPZSvkF0	2026-07-03 15:57:08.164+00	2026-06-03 15:57:08.164455+00
d57ee2a2-c4f4-4a84-aa7d-db588aaa7241	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI3YjY4OThlYS0xNDczLTRiZTItYTk4ZS0zM2U2ZmY0NDhhZjciLCJpYXQiOjE3ODA1MDIyNTAsImV4cCI6MTc4MzA5NDI1MH0.dfx-DjdYdblLzOF3KCwxUYgJHlZCHYjwpBaEujFHdIv2dGCVptJoEOmojYurvsP-	2026-07-03 15:57:30.509+00	2026-06-03 15:57:30.509554+00
4e671a45-2cba-40fd-85be-6909c7bd7744	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiJhNDVlNjkzOS00MDk4LTQ2MGYtYmUyOS1kYjM4MGMyMjZlNWMiLCJpYXQiOjE3ODA1MDU5MTQsImV4cCI6MTc4MzA5NzkxNH0.kQ1yCP1p0YCkLshDmCdPN7Whsbl77XW58K5H3DxdrrR7Ukv0niFdaqu0bOpG8miJ	2026-07-03 16:58:34.922+00	2026-06-03 16:58:34.923248+00
5298bed0-1662-4f19-8051-3c658e9fbc79	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiJkZTZiMzFhOS1jYTJkLTRjNGMtYTNhMi1iYTA2YWEyOGYxZGQiLCJpYXQiOjE3ODA1MDYwODgsImV4cCI6MTc4MzA5ODA4OH0.04ngS1R3gdgDPeH9zxSa4ecRKSe7mcSE0UqftpJG8_s7EjzWkIcUqilbaDv98DE_	2026-07-03 17:01:28.636+00	2026-06-03 17:01:28.637628+00
6a8a1b21-b797-42bc-a8c5-2903d5f8011c	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiJlOTFiNDQ3ZC1hNmE2LTQ3N2EtOTdlNS01NDA2MGZjOTY3MmEiLCJpYXQiOjE3ODA1MDc1NTgsImV4cCI6MTc4MzA5OTU1OH0.HpmXw5tv12Fft2E2pGosnkWU3yPPAl25x3M5Ujd26Rss9gWztEnISc76v_nvpPMx	2026-07-03 17:25:58.322+00	2026-06-03 17:25:58.324563+00
ba2aebc8-a4a6-4507-9000-6cf01e7c6a85	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiIwMTVmODYwNC0wNjUwLTRiYmQtYjliZS1jMjlkZGNiMTY4YWMiLCJpYXQiOjE3ODA1Mzk5MzksImV4cCI6MTc4MzEzMTkzOX0.4iuZ8tlruIz8D5z0B6rQY0TCbe9gnH4XqukRi8-pu0b0uGf1zs9cNX8kDgCMYRtB	2026-07-04 02:25:39.547+00	2026-06-04 02:25:39.556648+00
6ee23cfb-767d-4684-ab9d-8d49283e7c50	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI1MDk2N2E5Ny04N2I2LTRhNzMtOTYyZS1iODI0NGQwYzNkZWQiLCJpYXQiOjE3ODA1NDI2NTIsImV4cCI6MTc4MzEzNDY1Mn0.qrrb2TNHDJvEXZzqNcKjrQAeUaVBno0Qc6tctPd0OTjBYk34aS7NdOe6zcopnMFh	2026-07-04 03:10:52.71+00	2026-06-04 03:10:52.710322+00
39f190c3-51fd-4fba-a1af-3418ab812fce	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI0OGQxYTY0Ni02NDBkLTQ3ZGMtYmE1OS03ZGI1ZTVkZTAwNzEiLCJpYXQiOjE3ODA1ODYwNTAsImV4cCI6MTc4MzE3ODA1MH0.ulSo5FLgxYgTz6cozHTPPRrXsrqF1M1o8Z17t6qvBMQ1-agcCGabPOAlC0xBEty2	2026-07-04 15:14:10.192+00	2026-06-04 15:14:10.193735+00
e9acea1a-39a4-4059-b8e1-c0d10f070fe9	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiJjNTM3YmEwMi05OTU5LTQwYmItOGZmMy0zZmY3OGFmNzhiODYiLCJpYXQiOjE3ODA1ODc0MjIsImV4cCI6MTc4MzE3OTQyMn0.WeRW5u8_nG2K8qvIvvl--nJrBG8XD1Zz1c22-2pZDNjDqi3WJr10auo9YOGT0oDp	2026-07-04 15:37:02.204+00	2026-06-04 15:37:02.205688+00
c0a980d8-1f02-4b6d-8866-f7ebc36c74b6	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiIyMGMzYzYzYi00Y2Y2LTQzYWEtOTdlMi04NDM5ZjZlMjlmMGIiLCJpYXQiOjE3ODA1ODc0NDEsImV4cCI6MTc4MzE3OTQ0MX0.cYcxMptzILGnKTFBE5zA0_0mNhvNORfboKNcVAzGlIoJ5dsbjtWWdq3lYpYl5d0u	2026-07-04 15:37:21.273+00	2026-06-04 15:37:21.273939+00
e32d5235-bcfc-4955-9194-de8914517aff	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiJmZjVjNDVlNC1hOWM0LTRhZDItOTI3Yy04NTdhZTg1ODYxM2YiLCJpYXQiOjE3ODA1ODc5NDAsImV4cCI6MTc4MzE3OTk0MH0.D1OmC-hVUwcZTR3WpvYdLZjQsbZrGa1VMgMpe504YRcHXnBeORwL8156F2gngjuL	2026-07-04 15:45:40.702+00	2026-06-04 15:45:40.70446+00
dbfae453-ac33-4d7b-8226-e91990238110	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiJiZjRhYjU5YS05ZmJmLTQyYzgtODBkYS1mN2E3ZTZmN2FjZDMiLCJpYXQiOjE3ODA1ODkzNzAsImV4cCI6MTc4MzE4MTM3MH0.qrju93Egg27p6eHKmphpjiamKx4UjT5ePuqxMpUXXUVR4SOxnF3sYkbzXvK6ra5F	2026-07-04 16:09:30.141+00	2026-06-04 16:09:30.141678+00
c7225780-5e4c-44d6-ad48-1a181cd0b8ae	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiIyZGZmNjZlOC0zYjI2LTQ5ZDgtYWU0NC1hOWQ1MGUyYjUyMWUiLCJpYXQiOjE3ODA2MjU3OTksImV4cCI6MTc4MzIxNzc5OX0.iuOJ0TwMiuEp_StEeoac5ofv_OUq_BmhlqIx4JqnIWefmCgG0ozfv5CkpXadVMvn	2026-07-05 02:16:39.905+00	2026-06-05 02:16:39.90547+00
9b8a75a2-8eed-464e-b4a0-f4fd802ace86	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI4Nzk1ODIwMS1iZTI2LTRhNDQtOTU0Yy00OTliNGZjMWUyNDIiLCJpYXQiOjE3ODA2MjU4MzIsImV4cCI6MTc4MzIxNzgzMn0.mi2TZ2wrIlazFpNSEDumBUAdy5li5CONNTT_dmZDrf88Bp344Y7yRw4vrI8z0R_E	2026-07-05 02:17:12.224+00	2026-06-05 02:17:12.224856+00
7cdb86cb-afe8-4ffb-b7df-ea8b2708cfd5	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiIxOTViMzYyYS1hY2YyLTQ0MmMtYWEzMy0wNDdjMjY2YWU2MzkiLCJpYXQiOjE3ODA2NTMzNzYsImV4cCI6MTc4MzI0NTM3Nn0.S6psoKMPeQ-u_LSX-wFFWEX92Z27bHCLXwrKIUUwkFXYkQZ8kcCMPG3ZbDU9k7H8	2026-07-05 09:56:16.517+00	2026-06-05 09:56:16.520536+00
143ddd9a-3750-46ba-bacb-4a0504b3a1b9	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI4ZjNiZjAzZi1jZDIzLTQ4ZWItYjhmYS02NGFkMzE0NzVhYzAiLCJpYXQiOjE3ODA2NTMzODYsImV4cCI6MTc4MzI0NTM4Nn0.UlCh80so_yPuU4IcE9u9vvIgCTIXIs3b1yfC4PaX5DoSg26HAQhJIf5WEBL4Y9Al	2026-07-05 09:56:26.115+00	2026-06-05 09:56:26.115594+00
7b7fecc8-c5db-4eb2-b5b1-e372be8f3567	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI2ZDM0ODZjMC1mZmVhLTRmNTgtOTE4Ny0xNjMxMGUxOGIyZmQiLCJpYXQiOjE3ODA2NTUzNDksImV4cCI6MTc4MzI0NzM0OX0.Mz4KrNEyKKNCflGFjmiw7O-EXgHxD9OQi3vsUQXdie6QBsE6wUyD4iEj-tiC1Vbo	2026-07-05 10:29:09.888+00	2026-06-05 10:29:09.889037+00
4d798f11-cc41-499c-a221-bec148b2d12f	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJlMDY4YWFjMC0wMjY1LTRkNjgtYjYxNi0wZGU4ZTEwZTY1YzMiLCJpYXQiOjE3ODA2NTUzNjcsImV4cCI6MTc4MzI0NzM2N30.bROpvIqBeqFAXqOqg_kPADyEUv_w_LoybVgrbnPyUVtxVAdlXh1PDP_SOtKqmjho	2026-07-05 10:29:27.122+00	2026-06-05 10:29:27.122296+00
71e58cd7-5ff0-40a2-8448-beb4edc329ca	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI4YjM0MDQ3NS1mNDQ2LTRhMzktODBkMC1mMjQzN2JiYzBlOGMiLCJpYXQiOjE3ODA2NTU3ODAsImV4cCI6MTc4MzI0Nzc4MH0.6W9U0nNl9UYC4ehpH54cFTwaDtQ1dwalfTxlf767Mk8XnD6cBt3qqoJyERgTbpGq	2026-07-05 10:36:20.777+00	2026-06-05 10:36:20.778929+00
f7418bd2-746b-445f-a7b2-b24b55ec9e4f	627d6150-9fe6-41e4-98fd-e966fb11d5f2	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI2MjdkNjE1MC05ZmU2LTQxZTQtOThmZC1lOTY2ZmIxMWQ1ZjIiLCJqdGkiOiIwMWRkM2E2NS1jZGY0LTQwZTgtOTE3My00NDUzY2FiNWM4ZWQiLCJpYXQiOjE3ODA3NTc4NTEsImV4cCI6MTc4MzM0OTg1MX0.9UXKaxLTi76UmGhrli5xGJuZPQiZwri4ZHO59NVFSsBENfWe3TUVmyf-JCsVfOiO	2026-07-06 14:57:31.003+00	2026-06-06 14:57:31.005825+00
b12eb579-6106-45bc-a5cb-a2fa4e0331b5	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiIxNzU4ZmNlYy1iZjdiLTRlYjktYjY5OC00ZjJiMGEyZjE4MmEiLCJpYXQiOjE3ODA4NDAyNzAsImV4cCI6MTc4MzQzMjI3MH0.kzdZmW5PL4wir8K7APxroJxfptuUZ_nFUZto2dgZDVjJLUHUBDw5VQvg7aGCiir1	2026-07-07 13:51:10.582+00	2026-06-07 13:51:10.583134+00
d8900603-d20d-4e90-bf03-adcece0ac470	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJlNDcxOWQzZi03MzA4LTRmMTUtYmY5Ni0xMzgwNTUzOWIzNjQiLCJpYXQiOjE3ODA4NDEzNzUsImV4cCI6MTc4MzQzMzM3NX0.bFWzBRAx6x-uzUhENFd0hhLoso_YLC6AiGEEl77P-fRFREnDagULtzE3ftLGoHvf	2026-07-07 14:09:35.921+00	2026-06-07 14:09:35.923008+00
34cce2e5-1f0b-414e-93da-c6456231d77c	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiJjMWIxYjk3Ni04Nzc3LTRlODYtOWE5Ny0wY2VhYjMxMjcwMDYiLCJpYXQiOjE3ODA4NDI4NTIsImV4cCI6MTc4MzQzNDg1Mn0.J-hWaAdWRlVD4nHXn4H8jflfvGdRDsZ2NmUnb7BYnQ8bBdy2SotjjEE4QeyaIz4M	2026-07-07 14:34:12.257+00	2026-06-07 14:34:12.25942+00
3d9d073d-746d-4d1b-a79f-c8f57ed27a4a	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJmMzE2YWZiMy1jOGVkLTRlMjUtOTYwZi1kYzM4Zjg2MmFmMGYiLCJpYXQiOjE3ODA4NDQwNjAsImV4cCI6MTc4MzQzNjA2MH0.PkYRtCT1VlLx6wawH-XzrDLwqk6oO7nWE6dCakatFd0YrQMe5cUQlGS_y2b1jeb_	2026-07-07 14:54:20.954+00	2026-06-07 14:54:20.954653+00
4469ec4e-25e7-41c6-90f3-d12f8b7203df	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiIzMGIzMjgzNy0yODdiLTRhNjktYTk3ZC0wMTgzNjAwMzVmYmQiLCJpYXQiOjE3ODA4ODQ4ODYsImV4cCI6MTc4MzQ3Njg4Nn0.F3yzLHUAqxds3u4ocqrlrWdJgImHg8fgmGBehu1ZKIONfoQ7Y9I_B7ispoJ-6OhO	2026-07-08 02:14:46.653+00	2026-06-08 02:14:46.661697+00
b0a53338-e9f0-49b5-ae44-0cbbd0022a60	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmMDZmMzFkZC05ZWM0LTRkNmMtOWU4ZC1jOGFkY2RmNTc2OTMiLCJqdGkiOiJlMDc3MWU1OS1mODk5LTQ0ZDgtYjgwMi04ZmQ0ZWE2ZmZhNTQiLCJpYXQiOjE3ODA4OTAyODcsImV4cCI6MTc4MzQ4MjI4N30.S_riGzL4ljsGa8atv2-iuehgzhck40iLj3OcDpc6CV27h8PdRh7zO9N4SyA-e4Aa	2026-07-08 03:44:47.879+00	2026-06-08 03:44:47.886344+00
6849dbe2-8ba8-48ae-a869-142b2a42b0ac	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmMDZmMzFkZC05ZWM0LTRkNmMtOWU4ZC1jOGFkY2RmNTc2OTMiLCJqdGkiOiJhNTZiNDMwNS0wNThkLTQyMWMtYWJkOC05OTdhODM5ZTk3M2QiLCJpYXQiOjE3ODA4OTAyOTUsImV4cCI6MTc4MzQ4MjI5NX0.9sHBtgSTIOLBlGgeHkLJoQYVoEGf46Nov1EceFuHPwst2bhN3BrXVOj5MIR9C1ma	2026-07-08 03:44:55.324+00	2026-06-08 03:44:55.324483+00
8c31d493-ddd0-46d9-94d7-c7a3ae7f15f1	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmMDZmMzFkZC05ZWM0LTRkNmMtOWU4ZC1jOGFkY2RmNTc2OTMiLCJqdGkiOiIyNzU4YmRkYS02Zjg1LTRhZWItYjY2Yi1lYjkxMjI4MzE0OTciLCJpYXQiOjE3ODA4OTAzMDksImV4cCI6MTc4MzQ4MjMwOX0.o8u9Vjbfxlt9lV_63_6aHs30pyWvd7NyJQJZn0ds2NZ-wx3LQDBH_aUTtht8tIYf	2026-07-08 03:45:09.812+00	2026-06-08 03:45:09.812215+00
d67d1298-80e5-47ee-8cb6-2548a8887ece	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIyNTk3MmM1Mi05YTlhLTQzMzMtOTE1NC0xNzY3ZjA4MTJhNTciLCJpYXQiOjE3ODA4OTAzNzYsImV4cCI6MTc4MzQ4MjM3Nn0.OrxcJXwuRdbzgVOLpNaaC3iaGcKufHRQ43w3Y48YsZCfvkMebTusVuOwSQv7I5Zs	2026-07-08 03:46:16.622+00	2026-06-08 03:46:16.622575+00
29e66db7-8093-4f11-9753-410c103ba692	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI4NTM4MmJhOC1jYTdhLTQwNWQtOGU0OS00MDFjMzYxMTI3ZjUiLCJpYXQiOjE3ODA4OTEzMTEsImV4cCI6MTc4MzQ4MzMxMX0.ozcNrZfq_KyfxoK3sIE9-SwAxs_pslYYDwjP7z3ka17BhLhkFMcuS6GJsmy5_GVH	2026-07-08 04:01:51.113+00	2026-06-08 04:01:51.113999+00
8d6b04d7-261b-4b53-9971-da9c3a401a3f	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI5NjUxZTliNC02ODI3LTQwM2ItYjcwZC00NjM3NDUzYmZiZDgiLCJpYXQiOjE3ODA5MDM0ODAsImV4cCI6MTc4MzQ5NTQ4MH0.W4m-5S2MpiedGoa0hMGPtoBJ2It7deHqcdF-lphEyETKHAxlVyJ1nuWo9EPGyNs4	2026-07-08 07:24:40.62+00	2026-06-08 07:24:40.621999+00
192c6533-c638-4173-89e3-5418ece24a59	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJhODBkYTVjNS04YjcyLTRiMTQtOGVmYS04Yzc0Y2NmNDAwOTYiLCJpYXQiOjE3ODA5MDQ0ODUsImV4cCI6MTc4MzQ5NjQ4NX0.Jil8VG9Hx9v7s_bCGP592aeTdxMlS-3pmWuRgmTnFxU-cG5xZUXhd0DRl5EOfW9s	2026-07-08 07:41:25.114+00	2026-06-08 07:41:25.117949+00
239ccdd6-9aa4-4e4b-ae5d-2838f6f6dcba	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJiZDhlNmEyOS03YWMyLTQyNjYtYTg2NS0xYjkzY2VhNTRlYjgiLCJpYXQiOjE3ODA5NzI2NzUsImV4cCI6MTc4MzU2NDY3NX0.laIYRYmGr5YjQCCJh_tQAyb79UbeEeYqfZRt7jpLGb5SyZniA2CmIH5Ta-NJOc5e	2026-07-09 02:37:55.152+00	2026-06-09 02:37:55.170791+00
025c94fa-7a49-4a22-b118-b9d8bbd51e89	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIxMGQxMmM5ZC03YjU5LTQ5ZDUtODdlMC1jOWNmYTVmYWFhZWEiLCJpYXQiOjE3ODA5OTU3MzcsImV4cCI6MTc4MzU4NzczN30.7NbohyUkZhXEWy2PvXZNpBxgXxSfI_tNsdI2HbFjm7oUH9YJMs6TfBcjLfzTRkTK	2026-07-09 09:02:17.125+00	2026-06-09 09:02:17.132544+00
e23e4abb-a61a-4e85-8d20-a3eeb3ba4e84	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI2ZTgyYjVkMC0xYjA3LTRlN2EtOGQzYS1hNjkxMjUzYTA1N2YiLCJpYXQiOjE3ODEwNTcyODMsImV4cCI6MTc4MzY0OTI4M30.78ObtmgbdCpGPBxulgh78_mWeSDaoQ6AQm6H5YEvgUgorh1jMKVTrKMeX0jEdbJk	2026-07-10 02:08:03.667+00	2026-06-10 02:08:03.670293+00
21696f69-1ba9-44b2-a4ff-a90826b86001	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI1MzA0Nzg1My01MzM5LTQxNGQtYWNhYi0yMmZlNWJlM2ZiYmIiLCJpYXQiOjE3ODEwNTgyMjAsImV4cCI6MTc4MzY1MDIyMH0.v8ug9QgTC8J3_BUGSVguvp5jzcejmeAIGdyHyBFHD35sZmqbi968GxmdpPig6UcO	2026-07-10 02:23:40.051+00	2026-06-10 02:23:40.058049+00
08708b68-af8b-42ae-9930-f90965d9fed9	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiI3OGJiOGFhMi1mNTU1LTRiOWMtODdiOC04NDY3NWJiOGVjMzQiLCJpYXQiOjE3ODEwNTgzMzcsImV4cCI6MTc4MzY1MDMzN30.bQWlcuw5RZUxNTjswsoRBQJ3gUJCD3--6vc_15PY_Iqj_4_X-yRfpNwvfA-BnCrJ	2026-07-10 02:25:37.268+00	2026-06-10 02:25:37.268262+00
9dfd2485-9c51-4806-9d3f-eab3cb2567ca	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJhNGNmZGZlMC1lMDE5LTQ2OTMtODUwZi04MDY4MGQzN2I3MzciLCJpYXQiOjE3ODEwNTg3NzQsImV4cCI6MTc4MzY1MDc3NH0.ST9o87hgvfa4ywDFailVOQ0obtYWuoD6T76JAH6msBs3Qe-fU6mthN4NxWCClVwW	2026-07-10 02:32:54.09+00	2026-06-10 02:32:54.090446+00
6b5463ec-2db7-4117-b454-3914954ede0f	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI0OGVlMmQ1MC1jMTIxLTQ5MmItODhiYy1lYjNhMThmNDA4MmEiLCJpYXQiOjE3ODEwNTg5MzUsImV4cCI6MTc4MzY1MDkzNX0.lQmrkrkmmr8z7daiX3jT9CGde4CM3GGdcHjIX_hlxuuzyPpVyb4Wm7kj-GnLOOXv	2026-07-10 02:35:35.479+00	2026-06-10 02:35:35.486953+00
afcab47c-0642-43d2-bfc1-25ea2ff05f9c	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiJhOTU0NjQ5OS04NzA3LTQ2YzEtYTY5Ny0yNWRjZTYyYTZiZTUiLCJpYXQiOjE3ODEwNTg5NDQsImV4cCI6MTc4MzY1MDk0NH0.aUbhjDiz96YC_IDN5TSogHPu9CspxAT9EvbtbNrPoA_weyToobZamjZnavOlC8UY	2026-07-10 02:35:44.744+00	2026-06-10 02:35:44.744803+00
95ae346b-412a-42cc-8103-49811782126a	814e5dd5-9805-4566-814a-0b97df3978d0	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI4MTRlNWRkNS05ODA1LTQ1NjYtODE0YS0wYjk3ZGYzOTc4ZDAiLCJqdGkiOiI3MGEyZGMyYy1iYjExLTQ4OTYtYmQxOC0wMGM5OTgxOWE2MGMiLCJpYXQiOjE3ODEwNTkwMjEsImV4cCI6MTc4MzY1MTAyMX0.-dNiOxD-cGbAPhDLfRFcTb245iCd0OtBYx1NN1Uh5HhSlN-bi-S0TrytR7ckAlTr	2026-07-10 02:37:01.941+00	2026-06-10 02:37:01.941169+00
cd3f5ee8-e87e-4b6e-ae12-e83c65346df9	3047f731-7822-47dd-930e-17c9b658cf55	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzMDQ3ZjczMS03ODIyLTQ3ZGQtOTMwZS0xN2M5YjY1OGNmNTUiLCJqdGkiOiI3MDg2ZmViNC1lZTdjLTQwMzUtOTc3OC01Mzk5NzNjYzI1MDEiLCJpYXQiOjE3ODEwNTkwMzcsImV4cCI6MTc4MzY1MTAzN30.N7-eY5KCEsnxO2M0v11iyW25b2Snq91zb2MbYiWHrpMsshj_mf507CtcZcynxziF	2026-07-10 02:37:17.256+00	2026-06-10 02:37:17.256273+00
d8463f7f-e408-4fb0-8ce3-9608b5a1c162	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIwNzVmNTRkMC03NzE1LTQzZDQtOGRiNi03NzMzZTI4YTdiZGMiLCJpYXQiOjE3ODEwNTkyNjksImV4cCI6MTc4MzY1MTI2OX0.1P5HO1cyGL_7W8EqBJ0nkryWdGxzqBlx-bjSpLT_pA-kAmEdnWBELpWb-gSeZImm	2026-07-10 02:41:09.577+00	2026-06-10 02:41:09.577624+00
e48ba57c-e367-4b6d-b464-8632547a58a2	7be2a683-5537-41c2-b834-ea534816a945	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YmUyYTY4My01NTM3LTQxYzItYjgzNC1lYTUzNDgxNmE5NDUiLCJqdGkiOiIzN2I4NGU5Mi05YmU5LTQ3ZWUtOTY3Yi00MzMxOTEwY2M4ODciLCJpYXQiOjE3ODEwNTk0MTYsImV4cCI6MTc4MzY1MTQxNn0.XZSJgXq5yvRI60XbjP7bAiCqTlDIB9Kc7tjbDd5cXwSK_PDpJNGYFLzzi4-tcEuY	2026-07-10 02:43:36.852+00	2026-06-10 02:43:36.856453+00
30aec496-1466-4da4-8df2-38669537ea52	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJmNDlhNmU1MS00YThiLTQzNTYtYjM3OC1kZjM4MWFhMmRjNWYiLCJpYXQiOjE3ODEwNjA4NzksImV4cCI6MTc4MzY1Mjg3OX0.RMQzYckE066sX5d6JmxZXFIRG4i-zcqwvp-RQ07mCsmPw8TNzKm0vdM3JsAfh3dN	2026-07-10 03:07:59.1+00	2026-06-10 03:07:59.100223+00
37a36059-1e4a-402b-9346-ab899e67d131	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIyOWY3MTVlYy0yYzhmLTQxYTctYWQ1OC0wZmEwYWNkYmI4MDgiLCJpYXQiOjE3ODEwNjE0MDAsImV4cCI6MTc4MzY1MzQwMH0.-K2bQIBgLQbskkYjamJysxTZWw0uiU5R6YXO2lQ6BTbKbXqEidwF4mNgBOG4-Px7	2026-07-10 03:16:40.752+00	2026-06-10 03:16:40.753949+00
116bb45d-9c92-48a4-af96-347a3a4dfdb1	7be2a683-5537-41c2-b834-ea534816a945	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YmUyYTY4My01NTM3LTQxYzItYjgzNC1lYTUzNDgxNmE5NDUiLCJqdGkiOiIyZGZkOTEzZC1kNWExLTRkZDQtOWJiYS1kNDhjODA5ODYwOGMiLCJpYXQiOjE3ODEwNjE0NDEsImV4cCI6MTc4MzY1MzQ0MX0.j6fhlUTBM7-iVtlBQVJxf80tU6sIaPpwRfhja22iIaZx6WYp0uMN1wWBFWXyKv3I	2026-07-10 03:17:21.626+00	2026-06-10 03:17:21.626782+00
54660aac-694b-4fc0-9265-e64a5adc8410	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI5YWJmZjZhNy1iOWE3LTRjOTctOGRiZC0zMzE4YjM5NDU5NzciLCJpYXQiOjE3ODEwNjE4MjMsImV4cCI6MTc4MzY1MzgyM30.m187bkdawp-RBiAkxWmxf_o9ybxFvQ-zYBIbPHlXS0xSPdVTSf_oSaP9YNbxegns	2026-07-10 03:23:43.233+00	2026-06-10 03:23:43.23381+00
296bec89-fa9d-420f-a618-4a438832381e	7be2a683-5537-41c2-b834-ea534816a945	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YmUyYTY4My01NTM3LTQxYzItYjgzNC1lYTUzNDgxNmE5NDUiLCJqdGkiOiI5NDliMTNhMy03MzM0LTQxMjEtODNmZS02ZGFjYTNmNDhlMjYiLCJpYXQiOjE3ODEwNjE4MjYsImV4cCI6MTc4MzY1MzgyNn0.W3Ay7DZpQJhTvtyxf_KhhLaRUCaDYYDSwvMwyU1NjmBKBnmGnqcWme-x63e3jPgf	2026-07-10 03:23:46.66+00	2026-06-10 03:23:46.664575+00
b82e8f5e-a843-4319-ab2f-44df0f97500c	7be2a683-5537-41c2-b834-ea534816a945	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YmUyYTY4My01NTM3LTQxYzItYjgzNC1lYTUzNDgxNmE5NDUiLCJqdGkiOiIxMGIxMDUzZi02NzcxLTQ4MGMtYmEwOS0xMzI4YTE5OTZkZjIiLCJpYXQiOjE3ODEwNjE4NjgsImV4cCI6MTc4MzY1Mzg2OH0.hotdHKU_rAwlOMtfJKaPz_9SohsJcmKEuEvi9Bt8psxPFIbnoFvOxpub6x1g7VY5	2026-07-10 03:24:28.567+00	2026-06-10 03:24:28.567719+00
fdadad31-478c-4159-8870-cc812f672782	7be2a683-5537-41c2-b834-ea534816a945	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YmUyYTY4My01NTM3LTQxYzItYjgzNC1lYTUzNDgxNmE5NDUiLCJqdGkiOiJkMjVhNzEyYi1kNDc3LTQ2ZTEtYjVmYy1jNDMzZjM3YTdiZGUiLCJpYXQiOjE3ODEwNjI3MDksImV4cCI6MTc4MzY1NDcwOX0.6Gg8dJnLHHtMxs0M_02psrWcqMX-ULd7QWCw_Y3e-eJgbT4T8W92VZbr_vbqvE43	2026-07-10 03:38:29.511+00	2026-06-10 03:38:29.512907+00
2ab23e90-187d-46f7-981b-442b8f97a640	7be2a683-5537-41c2-b834-ea534816a945	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YmUyYTY4My01NTM3LTQxYzItYjgzNC1lYTUzNDgxNmE5NDUiLCJqdGkiOiJiNmNjYzc4Zi1lODM1LTQwMGYtYTA2Zi0yM2Q2ZGQwNmI1NWIiLCJpYXQiOjE3ODEwNjI3MTIsImV4cCI6MTc4MzY1NDcxMn0.16DbzukEiM9-gmXG1gYAV3Cy4QsmrJCfHJhoBgwgu6RXugQDzLEKUd0vu0ejOwXU	2026-07-10 03:38:32.897+00	2026-06-10 03:38:32.897347+00
51006fb5-f423-447d-9b0e-f7a9635eb2fb	5e289847-fa1e-402e-8f46-863cf0d3c395	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI1ZTI4OTg0Ny1mYTFlLTQwMmUtOGY0Ni04NjNjZjBkM2MzOTUiLCJqdGkiOiJjNWFkYTJhMi03MTE3LTRkNGEtOTllOC0yN2I5MTFlZDU0MjkiLCJpYXQiOjE3ODEwNjI4MDUsImV4cCI6MTc4MzY1NDgwNX0.qOFPF98OR4MRWX6VLmj3rLD4nIDgFxykVEG2_ur3WwVoU-fRF0mJPynjiPcm-esj	2026-07-10 03:40:05.792+00	2026-06-10 03:40:05.792819+00
b97e79cc-c431-4421-907e-ec7600552aa7	5e289847-fa1e-402e-8f46-863cf0d3c395	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI1ZTI4OTg0Ny1mYTFlLTQwMmUtOGY0Ni04NjNjZjBkM2MzOTUiLCJqdGkiOiJhYWEwMTU5Ny1kYjM1LTQwOTctYjAxNi1mN2Q0MDIzM2RjY2MiLCJpYXQiOjE3ODEwNjI4MjEsImV4cCI6MTc4MzY1NDgyMX0.EZN7ow430vOkpqqP98eWdCG3XlO3fgyB1KN4Jt9NZX8xiQ9h7WzM6qwzWq_PkBui	2026-07-10 03:40:21.324+00	2026-06-10 03:40:21.324269+00
d1affe91-ef06-4382-bdf4-4b5dfb82b6f9	5e289847-fa1e-402e-8f46-863cf0d3c395	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI1ZTI4OTg0Ny1mYTFlLTQwMmUtOGY0Ni04NjNjZjBkM2MzOTUiLCJqdGkiOiI1NTUxNjdmYi03ODA5LTQxNzQtOGIwNS04YjJhYmQzYzBiZWYiLCJpYXQiOjE3ODEwNjI4NDQsImV4cCI6MTc4MzY1NDg0NH0.hKctW_TCk8XLkbKJcXJeT5-HPxzHuhufRQU9bGMqkZAb6U-UzZpDEd-vIM5kV5yW	2026-07-10 03:40:44.96+00	2026-06-10 03:40:44.961318+00
f5e6a170-cd5a-4316-87b7-9d21727e44cc	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI2YWQwNjJjMC02ZTRhLTQ4MWYtYjVkYS00ZjljMzVjYzE0M2UiLCJpYXQiOjE3ODEwNzQyMTgsImV4cCI6MTc4MzY2NjIxOH0.3vS7uMeMn9dPxtOEohHWBbBHm2hW7Fre9SNxmtnZKSRreLo84oHQFhIQdrcDsfGJ	2026-07-10 06:50:18.6+00	2026-06-10 06:50:18.600176+00
24d26a52-b054-45d4-bc74-8e4d7bf629c2	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiIwNzY1MDI0Mi01NDJhLTQ0NGUtYjQzMC0yYWJkOWVlZWJkZGQiLCJpYXQiOjE3ODExMjQyMTAsImV4cCI6MTc4MzcxNjIxMH0.LIK6mykj6KF6Hl_ceRX846fsZZaCz4uxm_pLvD4gYP-PVOU4UXbyxVNw4ZaiB4Jc	2026-07-10 20:43:30.197+00	2026-06-10 20:43:30.199365+00
346c1b19-74c2-41e3-af4a-1e22303c44cb	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIzZThlMmNiNy05MzVkLTRhODktYjlkMS00OGQxNWYwYzg3ZTQiLCJpYXQiOjE3ODExMjUyNTQsImV4cCI6MTc4MzcxNzI1NH0.dGzcy_NqjaTd2cWyNlRE0S6kKvHuUlLMtx8m921BLkwMtvTpk0Vhu2RAb-ivrhKv	2026-07-10 21:00:54.407+00	2026-06-10 21:00:54.408153+00
c76e8a30-81a8-4ac9-ac9d-321d9ad403e3	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI1ODRkOTQwMC04YmNiLTQxYWQtOGQxMy1lZDMzNGViYTdmOTMiLCJpYXQiOjE3ODExMjUyNTksImV4cCI6MTc4MzcxNzI1OX0.R5abpq-w0dxnjJJuTNAV8uij1uqFtshlGcMUnw6pfwlhh6ka0ISfmSbsZVCAI7ga	2026-07-10 21:00:59.669+00	2026-06-10 21:00:59.669088+00
02e98604-a255-48ab-806a-ba9e2259d911	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI4MzI5Mjg2Ni0zNWU1LTRhZDgtYWE0Zi03ZTk3M2NmMjNmZDAiLCJpYXQiOjE3ODExMjUzMDksImV4cCI6MTc4MzcxNzMwOX0.hpQa7lXCv1-2WqxSOXOfjrJlXJmPQVcf2TiaQBMnfdWlf2Xx0FjssJ1wEfKQo69Q	2026-07-10 21:01:49.057+00	2026-06-10 21:01:49.057298+00
eaaca5c9-dc9d-4ba3-8075-2fe6d57adeb8	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIxNmE1Y2U3My02NzBiLTQxOWYtYWE4Ni1kNGY4MTZmNzYzNWYiLCJpYXQiOjE3ODExMjUzMjQsImV4cCI6MTc4MzcxNzMyNH0.B2yfnBPTzjGEQwF_ZHgCxATrbK52Huk9noQMjafN7L3YbAUr6B5L-TRx4hxumcFm	2026-07-10 21:02:04.23+00	2026-06-10 21:02:04.23031+00
e9c39fde-da32-4c2f-a66f-53b2f3134486	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIyNGUyNDIzMC0wZWNiLTRiYzMtYjc5NS1mNTg0YjA2NGRjZTkiLCJpYXQiOjE3ODExMjUzNjIsImV4cCI6MTc4MzcxNzM2Mn0.38CW1Sw4ZBi7xcRGFTRKkA1QQl_Gmb30cSSRAI0moRtlkQCk1lp9IkpAEYHn6SXB	2026-07-10 21:02:42.116+00	2026-06-10 21:02:42.116324+00
b60807dd-8bcf-4741-a683-aa4bc025bd3d	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIxOGJhMDY5ZS0zNzBjLTRiNmItYWQxYy1lODZkMmQ5OTI1OGMiLCJpYXQiOjE3ODExMjUzNzAsImV4cCI6MTc4MzcxNzM3MH0.X7vKIgD66B1eEe5D1ERwSWaLZtwaZmCJAIHPUeuChyqAqGc1mklOKmOTyuFa0zaq	2026-07-10 21:02:50.526+00	2026-06-10 21:02:50.52785+00
f67cb3f1-acbe-4aff-85bc-e3117b45441e	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIyYzAyZTk2OC1kZDgwLTQwZDEtYmQ3MC04NDllZTQyMDgwMzIiLCJpYXQiOjE3ODExMjUzNzYsImV4cCI6MTc4MzcxNzM3Nn0.6jIg7g4fZ5z8Kqrjm0erS1464qOkGGivrelSadEUhAwQpbg893sSeb-xMB1PZiaq	2026-07-10 21:02:56.693+00	2026-06-10 21:02:56.693363+00
2e15ea24-07b6-4e8c-bbe9-971ce0135baf	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJjNTMwNjdmNS04YTQ5LTRhYzEtOWMxMy02MmVkYjE1Yzc1OTgiLCJpYXQiOjE3ODExMjUzOTksImV4cCI6MTc4MzcxNzM5OX0.SY6lzoSykjXhKJ5n9huq7t6CVa0sZ_By2PODPdpJxonASy6v1bdmzPw_dNGFW-wJ	2026-07-10 21:03:19.459+00	2026-06-10 21:03:19.460934+00
1b5418cf-ecf4-4ed3-9322-af84cffc39f1	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJhOTMxMjhhOC1jNzVkLTRmZmYtYTVkYS00YzE2YjBlNTNmZmMiLCJpYXQiOjE3ODExMjU0MDUsImV4cCI6MTc4MzcxNzQwNX0.pd4AXJ2_YrG4eYFei81NGd9fo3XVhlJcRekWwQ3IGhuejyk-49Jx9xf0Qk59xipr	2026-07-10 21:03:25.305+00	2026-06-10 21:03:25.305186+00
9b417ed4-80e3-4811-8782-9b92d2b883db	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI0NzNlMmU5My00NjFiLTQyMTMtYjQ1My0xMzgwOGQwMmJmNDEiLCJpYXQiOjE3ODExMjU0MTAsImV4cCI6MTc4MzcxNzQxMH0.blsThm85TfAF1krUd0wPpR9LMQoB_BVsnEsF4irr0q59n1FIVdqk2tJjFIQQ4ESn	2026-07-10 21:03:30.699+00	2026-06-10 21:03:30.699035+00
ba6be540-d6bb-4c79-9eff-b3f002f429ed	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIwMjc2NzZlNi1hNDRlLTQzMDEtODVhZS1lZTk3NzBiYWI0MDkiLCJpYXQiOjE3ODExMjU4MTYsImV4cCI6MTc4MzcxNzgxNn0.9LYmB4FLl9qpDoJU3ymcfdmolIYplOQ0NkVy1KqtVw_8Y70U9Ait5lhwDEtJu5gR	2026-07-10 21:10:16.677+00	2026-06-10 21:10:16.677961+00
128bd39c-bb56-4b74-84ce-8f27b67edfd8	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIyMjE0OTAxMS0yMTI1LTRlMWUtOThlZC1jNDg5YzAzNjNlM2MiLCJpYXQiOjE3ODExMjU4MzIsImV4cCI6MTc4MzcxNzgzMn0.TZtPkLngVo_12lCHyKPTwKeKbsGcu1TNHpU4fOut8oY16DKK7d4ZXxqlGtW03_pP	2026-07-10 21:10:32.36+00	2026-06-10 21:10:32.362285+00
167bfe20-a926-4801-8716-ad4bfdbd083e	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI0NzZmOWY5ZS0xM2JjLTQyY2UtYjE1Mi0yZTg5NGY1N2E1MTIiLCJpYXQiOjE3ODExMjYxNDMsImV4cCI6MTc4MzcxODE0M30.P1GPjoQhH2uP-g8owjLXAeXDqA2STZ4cPkXcGbkw6NSnv71hHQytV80_eF8kEU1o	2026-07-10 21:15:43.546+00	2026-06-10 21:15:43.547094+00
b534f6be-dd7b-4ae8-aafc-bd104e9be458	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiJiMjI4NDg2NC01ZWYyLTRjMGQtOGFhNi0zNDBmYWE1YWQyYzQiLCJpYXQiOjE3ODEyODU0NTcsImV4cCI6MTc4Mzg3NzQ1N30.NE2Hb5rExD_VISxHa88XNqW23wZvlLAlzL2yn37wFGw8fMBa1Q0Jt-3gIzXl3HHZ	2026-07-12 17:30:57.286+00	2026-06-12 17:30:57.288235+00
b4434fe2-a242-4081-bc20-963950a450b7	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiIxMjlhY2M3NC0wMDkzLTQzZTEtYWJhMy04ZThkNWY4ZGQ1ZTEiLCJpYXQiOjE3ODEyODU1MDIsImV4cCI6MTc4Mzg3NzUwMn0._yAwVip0HrK6ZnU2-6FFgFKQMbr3fR-UbqtK-3jp7-ZUhuwwH_m7_6b50IBeHkH_	2026-07-12 17:31:42.682+00	2026-06-12 17:31:42.682487+00
ddc0cc3a-2c0e-45b4-b480-5b35e6271b6e	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJhNmM3NjJhZS1hYjE1LTRlNzgtOTMwNS1mMzIxNTk4Y2RlNWIiLCJpYXQiOjE3ODEyODU1MjEsImV4cCI6MTc4Mzg3NzUyMX0.Dd26cgHbjn16YJriOHTP8N221sd0XH45Qpnz92igwxrZzBK8OcjYyQ-4mRdl0lSp	2026-07-12 17:32:01.501+00	2026-06-12 17:32:01.501159+00
88d24c69-e12c-4598-a79b-185803ebb891	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiI5ZTIxYWRhZC0yNjc4LTQ0YjEtODhiZC1hZTJkNGU0Y2QwYmQiLCJpYXQiOjE3ODEzMzM1NzIsImV4cCI6MTc4MzkyNTU3Mn0.P5d2I-FmScPmQigMps7kdqzFshnG51j7FPPteQRUHPsRt_F_vPys2ld56XdfpGRr	2026-07-13 06:52:52.015+00	2026-06-13 06:52:52.017632+00
54154b09-e07b-42a1-9eb4-64b5854598a5	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiIxYjRhNTNhYS1hMzk4LTQyMGItOThkYi01MzIxMGE5YTIwMDUiLCJpYXQiOjE3ODEzMzM1NzksImV4cCI6MTc4MzkyNTU3OX0.s8ZaGKZm3ihMwcamhtjuqIBlgd4UVyEl3NKSO0uOtLF90kz3hx4XBCZKCMxjyI8p	2026-07-13 06:52:59.776+00	2026-06-13 06:52:59.777055+00
745257c9-421b-4ac3-bbc7-721fa494ff32	c4e8b2dc-daf4-47aa-a573-8383561351af	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjNGU4YjJkYy1kYWY0LTQ3YWEtYTU3My04MzgzNTYxMzUxYWYiLCJqdGkiOiIxZTgwZDIyZC02MGJmLTQ1YTQtYWRjOC05NDMzYjczMTMyOWYiLCJpYXQiOjE3ODEzMzM4NDIsImV4cCI6MTc4MzkyNTg0Mn0.O6B9zCnW4dnggrFO73eW5NIY6mWm_v31KQAaKBaZ1roEqBRGS7CquBnpeKfqxJfB	2026-07-13 06:57:22.376+00	2026-06-13 06:57:22.376302+00
94dc3de0-2449-4529-9683-702eaca6424b	c4e8b2dc-daf4-47aa-a573-8383561351af	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjNGU4YjJkYy1kYWY0LTQ3YWEtYTU3My04MzgzNTYxMzUxYWYiLCJqdGkiOiJkMWNlNDU0MC05YTEyLTRkMjctODA1Yy04OGQxMzI1OGM3NzMiLCJpYXQiOjE3ODEzNDIxNzUsImV4cCI6MTc4MzkzNDE3NX0.Pi7h8Tgv6SSZ6taFu4N4iD80M0zm_BzswTk8FCN07RVLaqARFXQMVPK8PXZeoo8k	2026-07-13 09:16:15.199+00	2026-06-13 09:16:15.2045+00
185608fe-d518-440e-9b79-59e6986c1d41	c4e8b2dc-daf4-47aa-a573-8383561351af	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjNGU4YjJkYy1kYWY0LTQ3YWEtYTU3My04MzgzNTYxMzUxYWYiLCJqdGkiOiJkYTc5OGE3YS0wYzkwLTQ1MmItODRkZS1kYjdjYWM5MWE3OTgiLCJpYXQiOjE3ODEzNDIxODIsImV4cCI6MTc4MzkzNDE4Mn0.EGkM37dhYA3BCUDy7SAiUNphC8-ExD3Geyse1DpPWZlW6byI6zqGNbup3K6zCNjq	2026-07-13 09:16:22.66+00	2026-06-13 09:16:22.661457+00
46761fe8-02e6-4ff2-b627-d70a9a492c1a	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJkMmU4MTQwOS0yMWZjLTQ2YjktYjEzZS1kNjMyMWY4MmU2NWMiLCJpYXQiOjE3ODEzNDIyMTQsImV4cCI6MTc4MzkzNDIxNH0.uRGTSXOGHf0OR5MPYK0-oxvKCN_n4R_gpY_LLR99xuaVdE3nGrqOx1pPFcxPJYzv	2026-07-13 09:16:54.535+00	2026-06-13 09:16:54.536884+00
2a753b73-0d92-445b-908c-af205583aaba	c4e8b2dc-daf4-47aa-a573-8383561351af	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjNGU4YjJkYy1kYWY0LTQ3YWEtYTU3My04MzgzNTYxMzUxYWYiLCJqdGkiOiJkZmEyNGM3MS1lYzczLTRlNmMtYTA2OC1iODdlYWQ1OTIwNjYiLCJpYXQiOjE3ODEzNDMzOTAsImV4cCI6MTc4MzkzNTM5MH0.eFpARs8tG6Ta_K4kpnG-1niMZ4R7kXUpbsrKgT2tGIT2CwWaCP-7YFRFmK4YuTII	2026-07-13 09:36:30.265+00	2026-06-13 09:36:30.267744+00
621dc5d4-c5a9-4a8f-8310-2cb4a2904710	c4e8b2dc-daf4-47aa-a573-8383561351af	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjNGU4YjJkYy1kYWY0LTQ3YWEtYTU3My04MzgzNTYxMzUxYWYiLCJqdGkiOiIzZDk4MjU5Ni1hNWE3LTQ4ODYtYWY5Ni1mMDQ5MzYyZDY2OWMiLCJpYXQiOjE3ODEzNDM0MDUsImV4cCI6MTc4MzkzNTQwNX0.d3S6jihCaOEcEfejoN8p_New3An7zEJYwaGnvA8iJFVrhyN3tMRweOwOoCL7NMe0	2026-07-13 09:36:45.774+00	2026-06-13 09:36:45.775921+00
9654635a-8a35-4324-a10a-8fb1b2a74266	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI0ZmI4NGUyNi1hZmRmLTRhNjQtYjM0MS1lYzk1ZjI2YTFkMjIiLCJpYXQiOjE3ODEzNTgwMDUsImV4cCI6MTc4Mzk1MDAwNX0.ro8cQ7zwG0P6pnHc0Z2VlVZfLOAtZH8tfDFYwxh92IJopsXHO6pkP_5sUuHEoo4n	2026-07-13 13:40:05.88+00	2026-06-13 13:40:05.891286+00
b0c23333-a089-4661-b0df-e6f0e0310893	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJmN2M1NmRmOC1kMzJjLTRhMWItOTYxMi1jMDE0MzdlOGMxN2QiLCJpYXQiOjE3ODEzNTgwNjMsImV4cCI6MTc4Mzk1MDA2M30.Y0Zu5y6YGvxXaIVwGmZU9Trq8dbV5UqNsWJhcPa-J0-izS2w406zh-eElYfDZ7B6	2026-07-13 13:41:03.27+00	2026-06-13 13:41:03.272302+00
5550a75d-4c43-47e3-998a-34e0ff07b545	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiJmODhkZmM5Zi01N2M0LTRlNGEtYjM2OS04MTQ2MGRiODMwNzIiLCJpYXQiOjE3ODEzNjEyNzksImV4cCI6MTc4Mzk1MzI3OX0.Vg0CIWBtzRVMctrftyIWisXDRCtipASZXMvP4UTl17IpstjNoRhcgi3HfnJdS-gB	2026-07-13 14:34:39.094+00	2026-06-13 14:34:39.094199+00
7e12b346-c445-41c4-80cf-3c906b0d9bd4	c4e8b2dc-daf4-47aa-a573-8383561351af	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjNGU4YjJkYy1kYWY0LTQ3YWEtYTU3My04MzgzNTYxMzUxYWYiLCJqdGkiOiI4ODMwMDA0ZS02ZTVmLTRmZjgtYjg4MS02OTc4MGUyYWI1ODgiLCJpYXQiOjE3ODEzNjEzMDMsImV4cCI6MTc4Mzk1MzMwM30.h_uQft6Awsx564KYVLnDdwg5BLNE6W0wleSuyRU0xMw4bFdiw4d3YDOo7XLMhwEo	2026-07-13 14:35:03.976+00	2026-06-13 14:35:03.976807+00
4ba52319-7d1e-472d-8c54-12a18ce05544	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJiMjFlY2Y0Yy0yZTdkLTQyMjQtODY2Ny0yODRkMGQ3YzlhZTIiLCJpYXQiOjE3ODEzNjQwMDcsImV4cCI6MTc4Mzk1NjAwN30.5DRiMj2-4BYO34KUYjQM1854nbt6iRfrPZ108TeBwbaB0Ubg4GIbuXuY4G3xI2Kl	2026-07-13 15:20:07.156+00	2026-06-13 15:20:07.157495+00
54e85893-7ba4-48d2-a013-4a8984b9e452	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJjYzFkZmI1Ny0yNmZmLTQ4NmUtODIxNS05MGNiM2Y2YjE3YjgiLCJpYXQiOjE3ODEzNjQ0MTgsImV4cCI6MTc4Mzk1NjQxOH0.-qxXawefHSB6cg8O7k89R7F9mtw709ChuMEfa2Rv3muWWLF3niLbF_nRxksVvVat	2026-07-13 15:26:58.137+00	2026-06-13 15:26:58.137031+00
a1d1a5e8-1ad9-4aac-8f2e-db5465ab3512	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI5YjU1MGI2MC0yM2E0LTQ3MzctYjU0NS00N2YwN2EyZDQ5NDAiLCJpYXQiOjE3ODEzNjQ1MDYsImV4cCI6MTc4Mzk1NjUwNn0.frfudz0orDFPMMK_1sZfIRsyxlljRORRUNmJcnE8Kw72ZeGdx4CQU7PS2MtVHnV7	2026-07-13 15:28:26.42+00	2026-06-13 15:28:26.421209+00
d4f48bc9-0a7a-44a6-92f0-59970c2a4206	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJjODQ4NGJlOC03MGJkLTQ1MDQtYTRmMS0wNDQ3ZjAxZGEzNjciLCJpYXQiOjE3ODEzNjQ1MTUsImV4cCI6MTc4Mzk1NjUxNX0.A2Cj_PxFYTJKgYpn02GmG6gBhJpE_M15ZgAlRIu7eNMOXzSlazZoA5qAoSiAtozs	2026-07-13 15:28:35.995+00	2026-06-13 15:28:35.995195+00
61b995c4-43b6-4fde-a12c-c9dedce43314	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiIwYjgwOTkwMi05OGVkLTRjNTAtOTM0Zi00MGM4Yzk4Yzg3NTUiLCJpYXQiOjE3ODEzNjU0NDgsImV4cCI6MTc4Mzk1NzQ0OH0.g5IUTV_ioxS1WHmegX2iFpe9b_EKsFECa8qXmE28bsMO0VDUXsxBaYyZek8c9FI3	2026-07-13 15:44:08.744+00	2026-06-13 15:44:08.74434+00
b7fa6a52-2179-4472-b84a-02240ec2592c	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIyMDdhNDY1MC0xYTUyLTQ0MWUtYTFkNC0yOTk1MzIyNWM0YzEiLCJpYXQiOjE3ODEzNjc0MDYsImV4cCI6MTc4Mzk1OTQwNn0.OdQf_sTn4ZM-uVgBYipFmKoNd1fYA3ZDj-YqqQzJNY0swz8657vcDz3y5dDxlMlx	2026-07-13 16:16:46.596+00	2026-06-13 16:16:46.598424+00
5482df10-69ce-4968-b38a-02771e65a6a1	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJmZTIyNGUyZi02MmQ2LTQwMDktOGJjOC04YWZmYTlmZGQ3ZmYiLCJpYXQiOjE3ODEzNjc0MzYsImV4cCI6MTc4Mzk1OTQzNn0.yVYdqDvexxNQhGGXjjbeY2MZ6JV41EE5ZQEV6gKdtVISqwIZQCQC0w1EdM8LMjsB	2026-07-13 16:17:16.57+00	2026-06-13 16:17:16.570403+00
a90df1c7-2db8-4b93-97ac-b35c67522851	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIxNDJhZjMwNS0wMjU1LTRjYzQtYmIyNy1kNTlmNTkxNDRiMTciLCJpYXQiOjE3ODEzNjc0NjYsImV4cCI6MTc4Mzk1OTQ2Nn0.ePogeC9j5iJkUyDVxwIAuKHz561BEXlF9sk6pYUQAp5ZuivasUJ3cT9GcFXbUMv5	2026-07-13 16:17:46.296+00	2026-06-13 16:17:46.29626+00
87aef2c4-11db-4883-9c01-8ed7d2268212	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJmZmU3NWZiNS05ZWJjLTRmOGUtYjA5ZS04OGQzNmU1MTA0OWEiLCJpYXQiOjE3ODEzNjc0OTcsImV4cCI6MTc4Mzk1OTQ5N30.w2bAV0fyt-VwGKTfzRiZYe2Hm-23K9YWEFpudA3V6qW6x64jbRbBQ41WMSmHoWpu	2026-07-13 16:18:17.608+00	2026-06-13 16:18:17.608165+00
bcc4abd6-443e-44ae-b1cb-cdb2f6d4acaf	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI2N2RkYzZiNS0xMTJhLTRmOWUtODgzNS05YWQ0NjQzMjQ2YzEiLCJpYXQiOjE3ODEzNjc0OTgsImV4cCI6MTc4Mzk1OTQ5OH0.3F8DcaDCeg5GHDEbdNLxYpYWlLL2Kaw7_ylO4YcDm1A8TDLkY5f-zjbL8Ziy0AWw	2026-07-13 16:18:18.291+00	2026-06-13 16:18:18.291131+00
de8b3898-3aad-44d8-a828-a8291f5fc67c	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIzMTg3MzY1Ny01NTBlLTRhNzMtOWNmYy1iMmE1ZTM2YjU3N2YiLCJpYXQiOjE3ODEzNjc1MjgsImV4cCI6MTc4Mzk1OTUyOH0.VZADfcocl5qV6EtLkUJkPsEJhQmgsF8X3gGhrfNSNLioXMC7nPHBCWUEan-GtQGO	2026-07-13 16:18:48.576+00	2026-06-13 16:18:48.576892+00
37950e12-dd7a-42f1-9981-cae09b3c83e5	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIyODdhYjA5My00YmM4LTQwZWQtYTFlYi00MTE0YTMxOTk0OTQiLCJpYXQiOjE3ODEzNjc1OTgsImV4cCI6MTc4Mzk1OTU5OH0.lwXrLagbOujVNYNjfSh7qbhwQMLzyNx4vsUwAgGJFMsJMj-MwvAa6k7cQ-csXOi2	2026-07-13 16:19:58.962+00	2026-06-13 16:19:58.963282+00
5753d914-0ba3-4df0-b306-47586c4182ed	4e0b7b88-3763-4732-a1cf-c2d0707b0511	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI0ZTBiN2I4OC0zNzYzLTQ3MzItYTFjZi1jMmQwNzA3YjA1MTEiLCJqdGkiOiI5YWM0MDM3Ni04NTU1LTQ3ZGEtOTMyZS03Y2Y3YTIxZmEyNzEiLCJpYXQiOjE3ODEzNjc5MzgsImV4cCI6MTc4Mzk1OTkzOH0.eyKyBxYlck7P_zcLmyHU9T-NDoprSkyQczkrXkGiyqMn1Ij_oX9efSiHES1O0VSD	2026-07-13 16:25:38.939+00	2026-06-13 16:25:38.939884+00
1c370ec1-124a-4848-865a-114408a37692	c4e8b2dc-daf4-47aa-a573-8383561351af	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJjNGU4YjJkYy1kYWY0LTQ3YWEtYTU3My04MzgzNTYxMzUxYWYiLCJqdGkiOiIzMjM2MzcxMS04MjZjLTRkNzEtOGIwMC04OThkMDMwN2NkMmUiLCJpYXQiOjE3ODEzNjgyMDIsImV4cCI6MTc4Mzk2MDIwMn0.KRWqByJ9pzxOeKKtCtXdcwAKafVR4BB6pg2728e7wXCrYo5-9-AXp-K18TNQhC8Q	2026-07-13 16:30:02.09+00	2026-06-13 16:30:02.090177+00
e48db203-fc7c-436c-81d7-66324ff6d8c9	7aebaa14-7f23-4ccd-a555-7ec61f27b98a	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YWViYWExNC03ZjIzLTRjY2QtYTU1NS03ZWM2MWYyN2I5OGEiLCJqdGkiOiJiN2NhMWE2ZS1hYmU2LTQzNzQtODNkMi0zOWE1NDYxZTQwYTciLCJpYXQiOjE3ODEzNjgyNDUsImV4cCI6MTc4Mzk2MDI0NX0.Ytzzf3YR9ZyAhfChZCrU0ubOs8cTE5JRpLLgnB5r2DBIhbvACx1x56rsOy-SJxDu	2026-07-13 16:30:45.181+00	2026-06-13 16:30:45.181143+00
d25d10a5-774f-4e15-9604-5d9426d3ea68	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI5ZWEwZGY4Zi05YmRhLTQzYmYtOWM2My1jYTgyNGY4NGQ5MzgiLCJpYXQiOjE3ODEzNjg1MDAsImV4cCI6MTc4Mzk2MDUwMH0.738LQqpxcDm9Ae2XzkdNgPdx2R4N1c8HyOdhT7515FtHDOKN8qv6JNWXjMIoIjHS	2026-07-13 16:35:00.989+00	2026-06-13 16:35:00.990457+00
df77aab0-e271-4933-8464-b240681ec439	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI4MjYzMGEwZi05ZTIwLTRhNDEtOTNkNy1jODZiYzkyOTVjNTkiLCJpYXQiOjE3ODEzNjg1MDksImV4cCI6MTc4Mzk2MDUwOX0.1Fs-OvZO8edRtcIIydkfV0knJItiqzCwYqFWZDkOVUdTyv-kypeD7-hKQduoRfnL	2026-07-13 16:35:09.426+00	2026-06-13 16:35:09.427855+00
1614d80f-18fa-4a9d-a157-a12aac4329bc	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI5OGZiNTM1ZS0wMzM2LTQ3MTEtOWIzMC1jZjUyOGZiOGZjZTQiLCJpYXQiOjE3ODEzNjg1MjMsImV4cCI6MTc4Mzk2MDUyM30.IdxOQ6tx8EmMjCHPuehda5xReWZ0EPepzHSSDO6dHIs7y_rLNGRYEYKWmtBu1335	2026-07-13 16:35:23.191+00	2026-06-13 16:35:23.192908+00
809ce4db-5d92-4430-ab8d-b88ce81ba090	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiI0ODRmYjk3MS01MjgxLTRmMzYtYjFkMS1mYWJkYWYzOTI0YTciLCJpYXQiOjE3ODEzNjg2NTEsImV4cCI6MTc4Mzk2MDY1MX0.CcCnNJM2taulMd2Mm3R9GwE0VLtmbh-jR4jP07kI000HQM0oD9D8dAMofJcA9IlX	2026-07-13 16:37:31.636+00	2026-06-13 16:37:31.637181+00
bc2682ae-b4be-4153-bf7f-d3fffbf63897	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiJmNmUwOTE1Mi1hYjhmLTQwMTUtODM3Ni1mOGRiMjRiM2M0YmMiLCJpYXQiOjE3ODEzNjkwNDEsImV4cCI6MTc4Mzk2MTA0MX0.kaZzd8GlWlUfA5lgNmwJowUQYxrkwf_gVSUfVkOWeovIC6l3eNEcJmYr1PXDNlhx	2026-07-13 16:44:01.191+00	2026-06-13 16:44:01.191451+00
016da744-e67c-449e-b681-dfb654ecc7d7	262a2469-eec7-470c-bd92-47874baebdea	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIyNjJhMjQ2OS1lZWM3LTQ3MGMtYmQ5Mi00Nzg3NGJhZWJkZWEiLCJqdGkiOiIwNGViZTc5Ni1hNjBiLTRjMGMtOWE1Zi0wMjljMzM3YjE3YTIiLCJpYXQiOjE3ODEzNjkwOTAsImV4cCI6MTc4Mzk2MTA5MH0.tj1SfMzB3ktlhJYdEZJyxmZyk-NmaK5xITBIXLaTZP4LADPUpvKlWWycKqteKLc6	2026-07-13 16:44:50.834+00	2026-06-13 16:44:50.834985+00
32c11c19-1714-40a0-9656-62a0e18fdd13	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiIyZGU1YmUzZC1mZWFiLTRkNzYtYmM0My1hNGNhZjA3YzQ0MDYiLCJpYXQiOjE3ODEzODgzOTEsImV4cCI6MTc4Mzk4MDM5MX0.vQpPgg9_0rT0anD7-ijJn-OxC-EPDrmS24DkktOmImbgXR-OemNiG2xm-R9wz1yT	2026-07-13 22:06:31.903+00	2026-06-13 22:06:31.906302+00
4e57eb30-8c89-4601-9594-e4f10bddff9e	00b4c56f-45fa-49a2-874b-601bc77dcb65	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMGI0YzU2Zi00NWZhLTQ5YTItODc0Yi02MDFiYzc3ZGNiNjUiLCJqdGkiOiJkMTc5NWJiNy01MzExLTRlNzctYjkyYS0xNzU1ZmI2OGU1NDQiLCJpYXQiOjE3ODEzODg0NTcsImV4cCI6MTc4Mzk4MDQ1N30.wAOct3qnrU-bocEboIYaHCW9HXBGQvwigBiBFshSp0ONG52MBYrb8oaZGcVdeFFA	2026-07-13 22:07:37.298+00	2026-06-13 22:07:37.299033+00
3296a174-587c-42df-bcc2-d80c9a7164ae	f06f31dd-9ec4-4d6c-9e8d-c8adcdf57693	eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJmMDZmMzFkZC05ZWM0LTRkNmMtOWU4ZC1jOGFkY2RmNTc2OTMiLCJqdGkiOiJkMzI3NTY1Mi1lYTBlLTQzZjQtOGVhNy1hNzQyOTRhNWFlZDkiLCJpYXQiOjE3ODEzOTQxNDEsImV4cCI6MTc4Mzk4NjE0MX0.2DNM3oEye06QjNCtVYCKapiV0pMtucBl8LXSRAzF2qCA0pGF1db9ugYLNl0Wb73PDXLq6ggsOT068SVPbYdPyQ	2026-07-13 23:42:21.68+00	2026-06-13 23:42:21.680233+00
05777212-0777-4ce1-9f76-69f918f2b1e3	5e289847-fa1e-402e-8f46-863cf0d3c395	eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI1ZTI4OTg0Ny1mYTFlLTQwMmUtOGY0Ni04NjNjZjBkM2MzOTUiLCJqdGkiOiIzOWE2ZTljOS0wNzIwLTQ1ZWItOWY5Mi1lYmQxOTVmZjRiZjIiLCJpYXQiOjE3ODEzOTQzOTEsImV4cCI6MTc4Mzk4NjM5MX0.F0HojhzInPsIJAcT-KHhhBOJp7i_5vnqEYV3s-m1rliwyLZf2Y2Wx_-6i1m90UwDlLXlQo57Iqmrs2XKwAMNfw	2026-07-13 23:46:31.946+00	2026-06-13 23:46:31.946536+00
70fe66fc-710d-4197-b8c4-b489477eb214	5e289847-fa1e-402e-8f46-863cf0d3c395	eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI1ZTI4OTg0Ny1mYTFlLTQwMmUtOGY0Ni04NjNjZjBkM2MzOTUiLCJqdGkiOiI4OWNiYmM3MC02M2NiLTQ2YTYtYTk3Yi05ODU2MDM4YTgwMDIiLCJpYXQiOjE3ODEzOTQ0MDUsImV4cCI6MTc4Mzk4NjQwNX0.VI7I77llAvaPcVfxzwNiphEVqsAsZRAPxjreyRWfbTfk_EhKxf7ZatqBsZ1KeQzGKJan-2llMJ4G_EcLYF1TwQ	2026-07-13 23:46:45.972+00	2026-06-13 23:46:45.97296+00
5feb5d00-315d-4b57-8031-a639851735bc	5e289847-fa1e-402e-8f46-863cf0d3c395	eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI1ZTI4OTg0Ny1mYTFlLTQwMmUtOGY0Ni04NjNjZjBkM2MzOTUiLCJqdGkiOiI3MWFiMzZlOC0yMWI5LTQzZTEtYTQyMS03OWY3MGZhNzhlYmEiLCJpYXQiOjE3ODEzOTQ0MjcsImV4cCI6MTc4Mzk4NjQyN30.igdpHL9gPzqKEviJbFSJZ92TldhZgkI1SAdklVjdnsaP27i5ZgJdX0kevG7k5QEOgm0joOGZzzdyv_IWrZFO8w	2026-07-13 23:47:07.476+00	2026-06-13 23:47:07.476789+00
\.

--
-- Data for Name: thanh_toan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."thanh_toan" ("id", "hoa_don_id", "khach_thue_id", "so_tien", "ngay_thanh_toan", "phuong_thuc_thanh_toan", "ma_tham_chieu", "external_transaction_id", "trang_thai", "nguoi_thanh_toan_id", "nguoi_ghi_nhan_id", "ghi_chu", "tao_luc") FROM stdin;
3c3ddefe-cb7b-43d1-b730-d54e0454119d	967cede6-4a9c-4597-80e2-1c7e935ed67f	fba2a7bd-082f-47f7-b0cc-3c53e79352c4	2265000.00	2026-05-25 17:00:00+00	BANK_TRANSFER	MNGHJHHFASD	\N	SUCCESS	\N	\N		2026-05-26 18:20:35.741612+00
636a8a37-fd70-4336-b4ee-48e0a1078a85	967cede6-4a9c-4597-80e2-1c7e935ed67f	fba2a7bd-082f-47f7-b0cc-3c53e79352c4	3000000.00	2026-05-25 17:00:00+00	CASH	\N	\N	SUCCESS	\N	\N		2026-05-26 18:21:49.206973+00
8cc3a622-1745-4b33-8224-a233b3e22eac	c4d29bf7-18cd-4b37-93ad-1f413583193a	cdbe66ce-3bf0-4023-b2c8-38ba477730f1	3508500.00	2026-05-31 17:00:00+00	CASH	\N	\N	SUCCESS	\N	\N		2026-06-01 03:45:01.008622+00
\.

--
-- Data for Name: thanh_vien_hop_dong; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."thanh_vien_hop_dong" ("id", "hop_dong_id", "khach_thue_id", "ho_ten", "so_cccd", "so_dien_thoai", "ngay_vao", "ngay_roi", "dang_o", "la_nguoi_dai_dien", "ghi_chu", "tao_luc", "cap_nhat_luc") FROM stdin;
847bbfad-e7a9-457f-8ce8-16a23aca9cc4	f5075e49-2b06-4750-834e-e157f7e09a82	fba2a7bd-082f-47f7-b0cc-3c53e79352c4	nguyễn văn hà	066206004084	0396822875	2026-01-01	\N	t	t	\N	2026-05-24 03:16:26.256991+00	2026-05-24 03:16:26.256991+00
6ee66783-955b-4950-86d5-d00ccb86035b	f5075e49-2b06-4750-834e-e157f7e09a82	\N	Nguyễn Thị B	066206004085	0987654321	2026-01-01	\N	t	f	\N	2026-05-24 03:16:26.256991+00	2026-05-24 03:16:26.256991+00
eefa83e8-9260-4b88-bf4d-b25f47769bfe	ca0fe835-cf14-4b4f-93ab-eb14d1ad250d	cdbe66ce-3bf0-4023-b2c8-38ba477730f1	lê văn minh	066206004083	0357165019	2026-05-24	\N	t	t	\N	2026-05-24 05:43:28.993987+00	2026-05-24 05:43:28.993987+00
a8478841-8d30-4579-b569-9dcab4622460	b797e88b-a0f1-4b56-8ca7-6a6da5c0240f	cdbe66ce-3bf0-4023-b2c8-38ba477730f1	lê văn minh	066206004083	0357165019	2026-05-24	\N	t	t	\N	2026-05-24 06:09:39.555208+00	2026-05-24 06:09:39.555208+00
bb96da61-da96-4792-93fb-0553539cfac7	b797e88b-a0f1-4b56-8ca7-6a6da5c0240f	fba2a7bd-082f-47f7-b0cc-3c53e79352c4	nguyễn văn hà	066206004084	0396822875	2026-05-24	\N	t	f	\N	2026-05-24 06:09:39.747682+00	2026-05-24 06:09:39.747682+00
bb8d44dc-9b2a-4ac3-87f1-69fad39ce33f	774f59eb-d908-4313-95aa-46ae4136e932	625c3321-ab04-4330-9e34-2a4458635624	đỗ chí công	099999999986	0987654321	2026-05-27	\N	t	t	\N	2026-05-27 02:41:50.451764+00	2026-05-27 02:41:50.451764+00
09179657-4c0c-437f-9020-8ebd3d99fc34	277227c0-b1a9-44d6-8ac5-5dc57b2eaf7f	b3c9ada2-70d5-496d-a103-4cf3d7ecc21f	Trần Văn Khách	034820882846	0973021078	2026-05-30	\N	t	t	\N	2026-05-30 07:33:10.131317+00	2026-05-30 07:33:10.131317+00
44444e45-be6c-45dd-ab74-c8cf148df970	cc4386ff-881d-4117-9c9c-0471e8b6c04f	cdbe66ce-3bf0-4023-b2c8-38ba477730f1	lê văn minh	066206004083	0357165019	2026-06-01	\N	t	t	\N	2026-06-01 02:56:21.453778+00	2026-06-01 02:56:21.453778+00
df4d2959-5639-4e48-b0ca-3d9e4eae7257	0a0463eb-0069-4a6f-b421-70695eda5d14	a6cab9bf-080a-4cca-b2a1-02b5df4aabfc	Phùng Văn Thọ	066206004086	0989909909	2026-06-01	\N	t	t	\N	2026-06-01 19:31:32.17067+00	2026-06-01 19:31:32.17067+00
787a41f7-f85e-433b-be9e-ce5cc98b7c2c	9057baa1-3318-4b5c-af06-131d349d706e	a6cab9bf-080a-4cca-b2a1-02b5df4aabfc	Phùng Văn Thọ	066206004086	0989909909	2026-06-01	\N	t	t	\N	2026-06-01 19:56:15.213771+00	2026-06-01 19:56:15.213771+00
b32081dc-2a90-4501-9ee1-6397391eab1a	58d6ac23-3ff3-4065-b82a-17c408fee39b	28073f55-d86b-4ff1-83d3-58b44808055f	Trần Triệu Vỹadsad	066206005323	03747293232	2026-06-03	\N	t	t	\N	2026-06-03 13:36:01.008701+00	2026-06-03 13:36:01.008701+00
ea1a23cd-25f0-4127-a116-e5cc7e3f13b3	a6de2592-9cfb-4d0a-8aa4-59cfb1f3d147	28073f55-d86b-4ff1-83d3-58b44808055f	Trần Triệu Vỹadsad	066206005323	03747293232	2026-06-10	\N	t	t	\N	2026-06-10 02:14:51.040474+00	2026-06-10 02:14:51.040474+00
16e5a5bb-6d5d-4a23-9bc4-f950b2f12df1	9d9c0239-7832-4607-b4a5-8db5cdb37a3f	76bcede3-1bda-494a-8193-974874f25f8f	Khách thuê Trần Văn B	\N	0987654322	2026-06-10	\N	t	t	\N	2026-06-10 02:47:04.605406+00	2026-06-10 02:47:04.605406+00
318a58f9-08a7-4ce7-8378-d9691efc1932	7667b075-29e2-44f0-ae53-d31df1affb7f	57ff6175-493c-49ab-98c6-7663c1a8c062	Nguyễn Văn Khách	034820568943	0873021078	2026-06-13	\N	t	t	\N	2026-06-13 15:53:57.55803+00	2026-06-13 15:53:57.55803+00
\.

--
-- Data for Name: thong_bao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."thong_bao" ("id", "nguoi_gui_id", "loai", "tieu_de", "noi_dung", "doi_tuong", "doi_tuong_id", "kenh", "gui_tat_ca", "tao_luc", "cap_nhat_luc", "xoa_luc") FROM stdin;
c3b4583a-8306-4728-984b-f3c97ee8986e	\N	SYSTEM	Thông báo Test	123	\N	\N	IN_APP	f	2026-05-24 07:18:33.386992+00	2026-05-24 07:18:33.386992+00	\N
1ffb09b6-de78-47ae-b7ee-2ab1a7829495	\N	APPOINTMENT	Lịch hẹn xem phòng mới	Khách hàng Trần Vỹ Khách Thuê đã đặt lịch xem phòng Phòng 106 vào lúc 2026-06-10T04:00Z. Số điện thoại: 0374729354.	\N	\N	IN_APP	f	2026-06-10 03:52:45.088309+00	2026-06-10 03:52:45.088309+00	\N
1d0d9bb7-014f-44d1-b2fe-4f43eebfb0fb	\N	APPOINTMENT	Lịch hẹn xem phòng mới	Khách hàng Trần Vỹ Khách Thuê đã đặt lịch xem phòng Phòng 106 vào lúc 2026-06-10T07:00Z. Số điện thoại: 0374729354.	\N	\N	IN_APP	f	2026-06-10 04:08:50.265096+00	2026-06-10 04:08:50.265096+00	\N
c7ed0584-da12-4b85-ab1a-eaf588ff8e32	\N	APPOINTMENT	Lịch hẹn xem phòng mới	Khách hàng Trần Vỹ Khách Thuê đã đặt lịch xem phòng Phòng 106 vào lúc 2026-06-10T07:00Z. Số điện thoại: 0374729354.	\N	\N	IN_APP	f	2026-06-10 04:14:07.173978+00	2026-06-10 04:14:07.173978+00	\N
bf764509-38ee-4967-bea6-d4805a516b32	\N	APPOINTMENT	Lịch hẹn xem phòng mới	Khách hàng Khách 01 đã đặt lịch xem phòng Phòng 110 vào lúc 2026-06-13T09:00Z. Số điện thoại: 0839402890.	\N	\N	IN_APP	f	2026-06-13 06:58:17.093247+00	2026-06-13 06:58:17.093247+00	\N
6be1095f-d42e-4253-8c86-57cf47fb5cfe	\N	APPOINTMENT	Lịch hẹn xem phòng mới	Khách hàng Sơn đã đặt lịch xem phòng PHÒNG 105 vào lúc 2026-06-14T02:00Z. Số điện thoại: 0336073019.	\N	\N	IN_APP	f	2026-06-13 16:31:08.988894+00	2026-06-13 16:31:08.988894+00	\N
c4fdfcaf-4ed9-4338-b86f-6e07942bd81a	\N	APPOINTMENT	Lịch hẹn xem phòng mới	Khách hàng Admin EasyHouse đã đặt lịch xem phòng PHÒNG 105 vào lúc 2026-06-14T02:00Z. Số điện thoại: 0973686868.	\N	\N	IN_APP	f	2026-06-13 23:33:23.763458+00	2026-06-13 23:33:23.763458+00	\N
\.

--
-- Data for Name: thong_bao_nguoi_nhan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."thong_bao_nguoi_nhan" ("id", "thong_bao_id", "nguoi_dung_id", "da_doc", "doc_luc", "gui_luc", "loi_gui") FROM stdin;
5180e1b9-7daa-4138-b254-8cc23f4e3351	1ffb09b6-de78-47ae-b7ee-2ab1a7829495	627d6150-9fe6-41e4-98fd-e966fb11d5f2	f	\N	2026-06-10 03:52:45.328407+00	\N
6e73090b-5e84-4535-87dd-9a99889eaa63	1d0d9bb7-014f-44d1-b2fe-4f43eebfb0fb	627d6150-9fe6-41e4-98fd-e966fb11d5f2	f	\N	2026-06-10 04:08:50.48848+00	\N
07f98551-dc59-4485-8796-6ea9ab51e35d	c7ed0584-da12-4b85-ab1a-eaf588ff8e32	627d6150-9fe6-41e4-98fd-e966fb11d5f2	f	\N	2026-06-10 04:14:07.528533+00	\N
a79abde0-7097-4539-9252-a269d9959657	bf764509-38ee-4967-bea6-d4805a516b32	627d6150-9fe6-41e4-98fd-e966fb11d5f2	f	\N	2026-06-13 06:58:17.314855+00	\N
2a46352b-2584-4585-8114-b6236fd73d89	6be1095f-d42e-4253-8c86-57cf47fb5cfe	00b4c56f-45fa-49a2-874b-601bc77dcb65	f	\N	2026-06-13 16:31:09.191922+00	\N
6503ecf9-1d5a-457a-8b93-8e1e4aecc81c	c4fdfcaf-4ed9-4338-b86f-6e07942bd81a	00b4c56f-45fa-49a2-874b-601bc77dcb65	f	\N	2026-06-13 23:33:23.989873+00	\N
\.

--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."buckets" ("id", "name", "owner", "created_at", "updated_at", "public", "avif_autodetection", "file_size_limit", "allowed_mime_types", "owner_id", "type") FROM stdin;
\.

--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."buckets_analytics" ("name", "type", "format", "created_at", "updated_at", "id", "deleted_at") FROM stdin;
\.

--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."buckets_vectors" ("id", "type", "created_at", "updated_at") FROM stdin;
\.

--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."objects" ("id", "bucket_id", "name", "owner", "created_at", "updated_at", "last_accessed_at", "metadata", "version", "owner_id", "user_metadata") FROM stdin;
\.

--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."s3_multipart_uploads" ("id", "in_progress_size", "upload_signature", "bucket_id", "key", "version", "owner_id", "created_at", "user_metadata", "metadata") FROM stdin;
\.

--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."s3_multipart_uploads_parts" ("id", "upload_id", "size", "part_number", "bucket_id", "key", "etag", "owner_id", "version", "created_at") FROM stdin;
\.

--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."vector_indexes" ("id", "name", "bucket_id", "data_type", "dimension", "distance_metric", "metadata_configuration", "created_at", "updated_at") FROM stdin;
\.

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 1, true);


--
-- PostgreSQL database dump complete
--

-- \unrestrict lO9oJ1d2VCkLDGk2kGI4nRc1cM42ROfwtAgruiAMsigGep0YeOP8eoU97XeftwI

RESET ALL;
