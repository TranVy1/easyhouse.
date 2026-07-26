--
-- PostgreSQL database dump
--

\restrict Z14RVxZAb6W4gWqMgxekFkdba5CzAb48x1cA5B2xhcLnuh3R4pjLhpB3FbjyMsh

-- Dumped from database version 14.23
-- Dumped by pg_dump version 14.23

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

ALTER TABLE IF EXISTS ONLY public.tin_nhan DROP CONSTRAINT IF EXISTS tin_nhan_tra_loi_cho_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tin_nhan DROP CONSTRAINT IF EXISTS tin_nhan_nguoi_gui_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tin_nhan DROP CONSTRAINT IF EXISTS tin_nhan_file_media_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tin_nhan DROP CONSTRAINT IF EXISTS tin_nhan_cuoc_tro_chuyen_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thong_bao_nguoi_nhan DROP CONSTRAINT IF EXISTS thong_bao_nguoi_nhan_thong_bao_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thong_bao_nguoi_nhan DROP CONSTRAINT IF EXISTS thong_bao_nguoi_nhan_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thong_bao DROP CONSTRAINT IF EXISTS thong_bao_nguoi_gui_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_vien_hop_dong DROP CONSTRAINT IF EXISTS thanh_vien_hop_dong_khach_thue_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_vien_hop_dong DROP CONSTRAINT IF EXISTS thanh_vien_hop_dong_hop_dong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_vien_cuoc_tro_chuyen DROP CONSTRAINT IF EXISTS thanh_vien_cuoc_tro_chuyen_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_vien_cuoc_tro_chuyen DROP CONSTRAINT IF EXISTS thanh_vien_cuoc_tro_chuyen_cuoc_tro_chuyen_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_toan DROP CONSTRAINT IF EXISTS thanh_toan_nguoi_thanh_toan_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_toan DROP CONSTRAINT IF EXISTS thanh_toan_nguoi_ghi_nhan_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_toan DROP CONSTRAINT IF EXISTS thanh_toan_khach_thue_id_fkey;
ALTER TABLE IF EXISTS ONLY public.thanh_toan DROP CONSTRAINT IF EXISTS thanh_toan_hoa_don_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tang DROP CONSTRAINT IF EXISTS tang_nha_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tai_san_phong DROP CONSTRAINT IF EXISTS tai_san_phong_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.tai_san_phong DROP CONSTRAINT IF EXISTS tai_san_phong_kho_tai_san_id_fkey;
ALTER TABLE IF EXISTS ONLY public.su_co DROP CONSTRAINT IF EXISTS su_co_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.su_co DROP CONSTRAINT IF EXISTS su_co_nguoi_phu_trach_id_fkey;
ALTER TABLE IF EXISTS ONLY public.su_co DROP CONSTRAINT IF EXISTS su_co_nguoi_bao_id_fkey;
ALTER TABLE IF EXISTS ONLY public.su_co DROP CONSTRAINT IF EXISTS su_co_khach_thue_id_fkey;
ALTER TABLE IF EXISTS ONLY public.refresh_token DROP CONSTRAINT IF EXISTS refresh_token_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phuong_tien DROP CONSTRAINT IF EXISTS phuong_tien_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phuong_tien DROP CONSTRAINT IF EXISTS phuong_tien_nha_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phuong_tien DROP CONSTRAINT IF EXISTS phuong_tien_khach_thue_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phuong_tien DROP CONSTRAINT IF EXISTS phuong_tien_chu_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phu_luc_hop_dong DROP CONSTRAINT IF EXISTS phu_luc_hop_dong_nguoi_tao_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phu_luc_hop_dong DROP CONSTRAINT IF EXISTS phu_luc_hop_dong_hop_dong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phong_tien_ich DROP CONSTRAINT IF EXISTS phong_tien_ich_tien_ich_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phong_tien_ich DROP CONSTRAINT IF EXISTS phong_tien_ich_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phong DROP CONSTRAINT IF EXISTS phong_tang_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phong DROP CONSTRAINT IF EXISTS phong_nha_tro_id_tang_id_fkey;
ALTER TABLE IF EXISTS ONLY public.phong DROP CONSTRAINT IF EXISTS phong_nha_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nha_tro DROP CONSTRAINT IF EXISTS nha_tro_chu_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung_vai_tro DROP CONSTRAINT IF EXISTS nguoi_dung_vai_tro_vai_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung_vai_tro DROP CONSTRAINT IF EXISTS nguoi_dung_vai_tro_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung_nha_tro DROP CONSTRAINT IF EXISTS nguoi_dung_nha_tro_nha_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nguoi_dung_nha_tro DROP CONSTRAINT IF EXISTS nguoi_dung_nha_tro_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.login_history DROP CONSTRAINT IF EXISTS login_history_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lich_thanh_toan DROP CONSTRAINT IF EXISTS lich_thanh_toan_hop_dong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lich_thanh_toan DROP CONSTRAINT IF EXISTS lich_thanh_toan_hoa_don_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lich_su_kho_tai_san DROP CONSTRAINT IF EXISTS lich_su_kho_tai_san_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lich_su_kho_tai_san DROP CONSTRAINT IF EXISTS lich_su_kho_tai_san_kho_tai_san_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lich_su_hoa_don DROP CONSTRAINT IF EXISTS lich_su_hoa_don_nguoi_thay_doi_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lich_su_hoa_don DROP CONSTRAINT IF EXISTS lich_su_hoa_don_hoa_don_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lich_hen DROP CONSTRAINT IF EXISTS lich_hen_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.lich_hen DROP CONSTRAINT IF EXISTS lich_hen_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.kho_tai_san DROP CONSTRAINT IF EXISTS kho_tai_san_nha_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.khach_thue DROP CONSTRAINT IF EXISTS khach_thue_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.khach_thue DROP CONSTRAINT IF EXISTS khach_thue_chu_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hop_dong DROP CONSTRAINT IF EXISTS hop_dong_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hop_dong DROP CONSTRAINT IF EXISTS hop_dong_khach_thue_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hoa_don DROP CONSTRAINT IF EXISTS hoa_don_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hoa_don DROP CONSTRAINT IF EXISTS hoa_don_khach_thue_id_fkey;
ALTER TABLE IF EXISTS ONLY public.hoa_don DROP CONSTRAINT IF EXISTS hoa_don_hop_dong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.yeu_cau_o_ghep DROP CONSTRAINT IF EXISTS fk_ycog_khach_thue;
ALTER TABLE IF EXISTS ONLY public.yeu_cau_o_ghep DROP CONSTRAINT IF EXISTS fk_ycog_hop_dong;
ALTER TABLE IF EXISTS ONLY public.tin_nhan DROP CONSTRAINT IF EXISTS fk_tin_nhan_nguoi_ghim;
ALTER TABLE IF EXISTS ONLY public.tin_nhan DROP CONSTRAINT IF EXISTS fk_tin_nhan_chuyen_tiep_tu;
ALTER TABLE IF EXISTS ONLY public.invoice_generation_log DROP CONSTRAINT IF EXISTS fk_invoice_log_hop_dong;
ALTER TABLE IF EXISTS ONLY public.invoice_generation_log DROP CONSTRAINT IF EXISTS fk_invoice_log_hoa_don;
ALTER TABLE IF EXISTS ONLY public.invoice_generation_log DROP CONSTRAINT IF EXISTS fk_invoice_log_batch;
ALTER TABLE IF EXISTS ONLY public.invoice_generation_batch DROP CONSTRAINT IF EXISTS fk_invoice_batch_nha_tro;
ALTER TABLE IF EXISTS ONLY public.invoice_generation_batch DROP CONSTRAINT IF EXISTS fk_invoice_batch_nguoi_tao;
ALTER TABLE IF EXISTS ONLY public.dat_coc_phong DROP CONSTRAINT IF EXISTS fk_dat_coc_nguoi_xac_nhan;
ALTER TABLE IF EXISTS ONLY public.dat_coc_phong DROP CONSTRAINT IF EXISTS fk_dat_coc_hop_dong;
ALTER TABLE IF EXISTS ONLY public.chi_tiet_hoa_don DROP CONSTRAINT IF EXISTS fk_cthd_su_co;
ALTER TABLE IF EXISTS ONLY public.meter_anomaly_alert DROP CONSTRAINT IF EXISTS fk_anomaly_resolved_by;
ALTER TABLE IF EXISTS ONLY public.meter_anomaly_alert DROP CONSTRAINT IF EXISTS fk_anomaly_phong;
ALTER TABLE IF EXISTS ONLY public.meter_anomaly_alert DROP CONSTRAINT IF EXISTS fk_anomaly_hop_dong;
ALTER TABLE IF EXISTS ONLY public.meter_anomaly_alert DROP CONSTRAINT IF EXISTS fk_anomaly_chi_so;
ALTER TABLE IF EXISTS ONLY public.file_media DROP CONSTRAINT IF EXISTS file_media_nguoi_tai_len_id_fkey;
ALTER TABLE IF EXISTS ONLY public.email_verification_token DROP CONSTRAINT IF EXISTS email_verification_token_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.dich_vu_hop_dong DROP CONSTRAINT IF EXISTS dich_vu_hop_dong_hop_dong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.dich_vu_hop_dong DROP CONSTRAINT IF EXISTS dich_vu_hop_dong_dich_vu_id_fkey;
ALTER TABLE IF EXISTS ONLY public.dich_vu DROP CONSTRAINT IF EXISTS dich_vu_chu_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.dat_coc_phong DROP CONSTRAINT IF EXISTS dat_coc_phong_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.dat_coc_phong DROP CONSTRAINT IF EXISTS dat_coc_phong_khach_thue_id_fkey;
ALTER TABLE IF EXISTS ONLY public.dat_coc_phong DROP CONSTRAINT IF EXISTS dat_coc_phong_hop_dong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.dang_ky_push DROP CONSTRAINT IF EXISTS dang_ky_push_nguoi_dung_id_fkey;
ALTER TABLE IF EXISTS ONLY public.cuoc_tro_chuyen DROP CONSTRAINT IF EXISTS cuoc_tro_chuyen_tang_id_fkey;
ALTER TABLE IF EXISTS ONLY public.cuoc_tro_chuyen DROP CONSTRAINT IF EXISTS cuoc_tro_chuyen_nha_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.cuoc_tro_chuyen DROP CONSTRAINT IF EXISTS cuoc_tro_chuyen_nguoi_tao_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chi_tiet_hoa_don DROP CONSTRAINT IF EXISTS chi_tiet_hoa_don_hoa_don_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chi_tiet_hoa_don DROP CONSTRAINT IF EXISTS chi_tiet_hoa_don_dich_vu_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chi_tiet_hoa_don DROP CONSTRAINT IF EXISTS chi_tiet_hoa_don_chi_so_dien_nuoc_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chi_so_dien_nuoc DROP CONSTRAINT IF EXISTS chi_so_dien_nuoc_phong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chi_so_dien_nuoc DROP CONSTRAINT IF EXISTS chi_so_dien_nuoc_nguoi_ghi_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chi_so_dien_nuoc DROP CONSTRAINT IF EXISTS chi_so_dien_nuoc_hop_dong_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chan_nguoi_dung DROP CONSTRAINT IF EXISTS chan_nguoi_dung_nguoi_chan_id_fkey;
ALTER TABLE IF EXISTS ONLY public.chan_nguoi_dung DROP CONSTRAINT IF EXISTS chan_nguoi_dung_nguoi_bi_chan_id_fkey;
ALTER TABLE IF EXISTS ONLY public.cau_hinh_gia DROP CONSTRAINT IF EXISTS cau_hinh_gia_nha_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.cau_hinh_gia DROP CONSTRAINT IF EXISTS cau_hinh_gia_dich_vu_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bao_cao_tin_nhan DROP CONSTRAINT IF EXISTS bao_cao_tin_nhan_tin_nhan_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bao_cao_tin_nhan DROP CONSTRAINT IF EXISTS bao_cao_tin_nhan_nguoi_xu_ly_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bao_cao_tin_nhan DROP CONSTRAINT IF EXISTS bao_cao_tin_nhan_nguoi_bao_cao_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bao_cao_tin_nhan DROP CONSTRAINT IF EXISTS bao_cao_tin_nhan_cuoc_tro_chuyen_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bank_transaction DROP CONSTRAINT IF EXISTS bank_transaction_nha_tro_id_fkey;
ALTER TABLE IF EXISTS ONLY public.bank_transaction DROP CONSTRAINT IF EXISTS bank_transaction_hoa_don_id_fkey;
ALTER TABLE IF EXISTS ONLY public.audit_log DROP CONSTRAINT IF EXISTS audit_log_nguoi_dung_id_fkey;
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
DROP INDEX IF EXISTS public.uq_tin_nhan_ma_client;
DROP INDEX IF EXISTS public.idx_tvhd_hop_dong;
DROP INDEX IF EXISTS public.idx_tin_nhan_noi_dung_trgm;
DROP INDEX IF EXISTS public.idx_tin_nhan_hoi_thoai_seq;
DROP INDEX IF EXISTS public.idx_tin_nhan_ghim;
DROP INDEX IF EXISTS public.idx_tin_nhan_dinh_kem;
DROP INDEX IF EXISTS public.idx_tin_nhan_co_lien_ket;
DROP INDEX IF EXISTS public.idx_thong_bao_recipient;
DROP INDEX IF EXISTS public.idx_thanh_vien_nguoi_dung;
DROP INDEX IF EXISTS public.idx_thanh_toan_ref;
DROP INDEX IF EXISTS public.idx_thanh_toan_hoa_don;
DROP INDEX IF EXISTS public.idx_tang_nha_tro_so_tang;
DROP INDEX IF EXISTS public.idx_su_co_phong_status;
DROP INDEX IF EXISTS public.idx_phong_trang_thai;
DROP INDEX IF EXISTS public.idx_phong_tang_id;
DROP INDEX IF EXISTS public.idx_phong_nha_tro_tang;
DROP INDEX IF EXISTS public.idx_phong_nha_tro;
DROP INDEX IF EXISTS public.idx_nha_tro_location_active;
DROP INDEX IF EXISTS public.idx_nha_tro_chu_tro;
DROP INDEX IF EXISTS public.idx_nguoi_dung_trang_thai;
DROP INDEX IF EXISTS public.idx_nguoi_dung_email;
DROP INDEX IF EXISTS public.idx_ndnt_nha_tro_user;
DROP INDEX IF EXISTS public.idx_login_history_user_time;
DROP INDEX IF EXISTS public.idx_lich_thanh_toan_hop_dong;
DROP INDEX IF EXISTS public.idx_lich_thanh_toan_han;
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
DROP INDEX IF EXISTS public.idx_dang_ky_push_nguoi_dung;
DROP INDEX IF EXISTS public.idx_cuoc_tro_chuyen_tin_cuoi;
DROP INDEX IF EXISTS public.idx_cuoc_tro_chuyen_nha_tro;
DROP INDEX IF EXISTS public.idx_cthd_hoa_don;
DROP INDEX IF EXISTS public.idx_chi_so_phong_ky;
DROP INDEX IF EXISTS public.idx_chan_theo_nguoi_bi_chan;
DROP INDEX IF EXISTS public.idx_cau_hinh_gia_nha_tro;
DROP INDEX IF EXISTS public.idx_bao_cao_cho_xu_ly;
DROP INDEX IF EXISTS public.idx_audit_log_target;
ALTER TABLE IF EXISTS ONLY public.yeu_cau_o_ghep DROP CONSTRAINT IF EXISTS yeu_cau_o_ghep_pkey;
ALTER TABLE IF EXISTS ONLY public.vai_tro DROP CONSTRAINT IF EXISTS vai_tro_ten_key;
ALTER TABLE IF EXISTS ONLY public.vai_tro DROP CONSTRAINT IF EXISTS vai_tro_pkey;
ALTER TABLE IF EXISTS ONLY public.thanh_vien_cuoc_tro_chuyen DROP CONSTRAINT IF EXISTS uq_thanh_vien_cuoc_tro_chuyen;
ALTER TABLE IF EXISTS ONLY public.dang_ky_push DROP CONSTRAINT IF EXISTS uq_dang_ky_push_endpoint;
ALTER TABLE IF EXISTS ONLY public.chan_nguoi_dung DROP CONSTRAINT IF EXISTS uq_chan_nguoi_dung;
ALTER TABLE IF EXISTS ONLY public.bao_cao_tin_nhan DROP CONSTRAINT IF EXISTS uq_bao_cao_tin_nhan;
ALTER TABLE IF EXISTS ONLY public.tin_nhan DROP CONSTRAINT IF EXISTS tin_nhan_so_thu_tu_key;
ALTER TABLE IF EXISTS ONLY public.tin_nhan DROP CONSTRAINT IF EXISTS tin_nhan_pkey;
ALTER TABLE IF EXISTS ONLY public.tien_ich DROP CONSTRAINT IF EXISTS tien_ich_ten_key;
ALTER TABLE IF EXISTS ONLY public.tien_ich DROP CONSTRAINT IF EXISTS tien_ich_pkey;
ALTER TABLE IF EXISTS ONLY public.thong_bao DROP CONSTRAINT IF EXISTS thong_bao_pkey;
ALTER TABLE IF EXISTS ONLY public.thong_bao_nguoi_nhan DROP CONSTRAINT IF EXISTS thong_bao_nguoi_nhan_thong_bao_id_nguoi_dung_id_key;
ALTER TABLE IF EXISTS ONLY public.thong_bao_nguoi_nhan DROP CONSTRAINT IF EXISTS thong_bao_nguoi_nhan_pkey;
ALTER TABLE IF EXISTS ONLY public.thanh_vien_hop_dong DROP CONSTRAINT IF EXISTS thanh_vien_hop_dong_pkey;
ALTER TABLE IF EXISTS ONLY public.thanh_vien_cuoc_tro_chuyen DROP CONSTRAINT IF EXISTS thanh_vien_cuoc_tro_chuyen_pkey;
ALTER TABLE IF EXISTS ONLY public.thanh_toan DROP CONSTRAINT IF EXISTS thanh_toan_pkey;
ALTER TABLE IF EXISTS ONLY public.thanh_toan DROP CONSTRAINT IF EXISTS thanh_toan_external_transaction_id_key;
ALTER TABLE IF EXISTS ONLY public.tang DROP CONSTRAINT IF EXISTS tang_pkey;
ALTER TABLE IF EXISTS ONLY public.tang DROP CONSTRAINT IF EXISTS tang_nha_tro_id_so_tang_key;
ALTER TABLE IF EXISTS ONLY public.tang DROP CONSTRAINT IF EXISTS tang_nha_tro_id_id_key;
ALTER TABLE IF EXISTS ONLY public.tai_san_phong DROP CONSTRAINT IF EXISTS tai_san_phong_pkey;
ALTER TABLE IF EXISTS ONLY public.su_co DROP CONSTRAINT IF EXISTS su_co_pkey;
ALTER TABLE IF EXISTS ONLY public.refresh_token DROP CONSTRAINT IF EXISTS refresh_token_token_key;
ALTER TABLE IF EXISTS ONLY public.refresh_token DROP CONSTRAINT IF EXISTS refresh_token_pkey;
ALTER TABLE IF EXISTS ONLY public.phuong_tien DROP CONSTRAINT IF EXISTS phuong_tien_pkey;
ALTER TABLE IF EXISTS ONLY public.phuong_tien DROP CONSTRAINT IF EXISTS phuong_tien_ma_pt_key;
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
ALTER TABLE IF EXISTS ONLY public.meter_anomaly_alert DROP CONSTRAINT IF EXISTS meter_anomaly_alert_pkey;
ALTER TABLE IF EXISTS ONLY public.login_history DROP CONSTRAINT IF EXISTS login_history_pkey;
ALTER TABLE IF EXISTS ONLY public.lich_thanh_toan DROP CONSTRAINT IF EXISTS lich_thanh_toan_pkey;
ALTER TABLE IF EXISTS ONLY public.lich_thanh_toan DROP CONSTRAINT IF EXISTS lich_thanh_toan_hop_dong_id_ky_nam_ky_thang_key;
ALTER TABLE IF EXISTS ONLY public.lich_su_kho_tai_san DROP CONSTRAINT IF EXISTS lich_su_kho_tai_san_pkey;
ALTER TABLE IF EXISTS ONLY public.lich_su_hoa_don DROP CONSTRAINT IF EXISTS lich_su_hoa_don_pkey;
ALTER TABLE IF EXISTS ONLY public.lich_hen DROP CONSTRAINT IF EXISTS lich_hen_pkey;
ALTER TABLE IF EXISTS ONLY public.kho_tai_san DROP CONSTRAINT IF EXISTS kho_tai_san_pkey;
ALTER TABLE IF EXISTS ONLY public.khach_thue DROP CONSTRAINT IF EXISTS khach_thue_pkey;
ALTER TABLE IF EXISTS ONLY public.khach_thue DROP CONSTRAINT IF EXISTS khach_thue_nguoi_dung_id_key;
ALTER TABLE IF EXISTS ONLY public.khach_thue DROP CONSTRAINT IF EXISTS khach_thue_chu_tro_id_so_cccd_key;
ALTER TABLE IF EXISTS ONLY public.invoice_generation_log DROP CONSTRAINT IF EXISTS invoice_generation_log_pkey;
ALTER TABLE IF EXISTS ONLY public.invoice_generation_batch DROP CONSTRAINT IF EXISTS invoice_generation_batch_pkey;
ALTER TABLE IF EXISTS ONLY public.hop_dong DROP CONSTRAINT IF EXISTS hop_dong_pkey;
ALTER TABLE IF EXISTS ONLY public.hop_dong DROP CONSTRAINT IF EXISTS hop_dong_ma_hop_dong_key;
ALTER TABLE IF EXISTS ONLY public.hoa_don DROP CONSTRAINT IF EXISTS hoa_don_pkey;
ALTER TABLE IF EXISTS ONLY public.hoa_don DROP CONSTRAINT IF EXISTS hoa_don_ma_hoa_don_key;
ALTER TABLE IF EXISTS ONLY public.hoa_don DROP CONSTRAINT IF EXISTS hoa_don_hop_dong_id_ky_nam_ky_thang_key;
ALTER TABLE IF EXISTS ONLY public.file_media DROP CONSTRAINT IF EXISTS file_media_pkey;
ALTER TABLE IF EXISTS ONLY public.hop_dong DROP CONSTRAINT IF EXISTS excl_hop_dong_phong_active_overlap;
ALTER TABLE IF EXISTS ONLY public.email_verification_token DROP CONSTRAINT IF EXISTS email_verification_token_token_key;
ALTER TABLE IF EXISTS ONLY public.email_verification_token DROP CONSTRAINT IF EXISTS email_verification_token_pkey;
ALTER TABLE IF EXISTS ONLY public.dich_vu DROP CONSTRAINT IF EXISTS dich_vu_pkey;
ALTER TABLE IF EXISTS ONLY public.dich_vu_hop_dong DROP CONSTRAINT IF EXISTS dich_vu_hop_dong_pkey;
ALTER TABLE IF EXISTS ONLY public.dich_vu_hop_dong DROP CONSTRAINT IF EXISTS dich_vu_hop_dong_hop_dong_id_dich_vu_id_bat_dau_tu_key;
ALTER TABLE IF EXISTS ONLY public.dich_vu DROP CONSTRAINT IF EXISTS dich_vu_chu_tro_id_ten_dich_vu_key;
ALTER TABLE IF EXISTS ONLY public.debt_reminder_log DROP CONSTRAINT IF EXISTS debt_reminder_log_pkey;
ALTER TABLE IF EXISTS ONLY public.dat_coc_phong DROP CONSTRAINT IF EXISTS dat_coc_phong_pkey;
ALTER TABLE IF EXISTS ONLY public.dang_ky_push DROP CONSTRAINT IF EXISTS dang_ky_push_pkey;
ALTER TABLE IF EXISTS ONLY public.cuoc_tro_chuyen DROP CONSTRAINT IF EXISTS cuoc_tro_chuyen_pkey;
ALTER TABLE IF EXISTS ONLY public.cuoc_tro_chuyen DROP CONSTRAINT IF EXISTS cuoc_tro_chuyen_khoa_duy_nhat_key;
ALTER TABLE IF EXISTS ONLY public.contract_signature DROP CONSTRAINT IF EXISTS contract_signature_pkey;
ALTER TABLE IF EXISTS ONLY public.chu_tro DROP CONSTRAINT IF EXISTS chu_tro_so_cccd_key;
ALTER TABLE IF EXISTS ONLY public.chu_tro DROP CONSTRAINT IF EXISTS chu_tro_pkey;
ALTER TABLE IF EXISTS ONLY public.chu_tro DROP CONSTRAINT IF EXISTS chu_tro_nguoi_dung_id_key;
ALTER TABLE IF EXISTS ONLY public.chi_tiet_hoa_don DROP CONSTRAINT IF EXISTS chi_tiet_hoa_don_pkey;
ALTER TABLE IF EXISTS ONLY public.chi_so_dien_nuoc DROP CONSTRAINT IF EXISTS chi_so_dien_nuoc_pkey;
ALTER TABLE IF EXISTS ONLY public.chi_so_dien_nuoc DROP CONSTRAINT IF EXISTS chi_so_dien_nuoc_phong_id_loai_ky_nam_ky_thang_key;
ALTER TABLE IF EXISTS ONLY public.chan_nguoi_dung DROP CONSTRAINT IF EXISTS chan_nguoi_dung_pkey;
ALTER TABLE IF EXISTS ONLY public.cau_hinh_gia DROP CONSTRAINT IF EXISTS cau_hinh_gia_pkey;
ALTER TABLE IF EXISTS ONLY public.bao_cao_tin_nhan DROP CONSTRAINT IF EXISTS bao_cao_tin_nhan_pkey;
ALTER TABLE IF EXISTS ONLY public.bank_transaction DROP CONSTRAINT IF EXISTS bank_transaction_pkey;
ALTER TABLE IF EXISTS ONLY public.bank_transaction DROP CONSTRAINT IF EXISTS bank_transaction_ma_giao_dich_key;
ALTER TABLE IF EXISTS ONLY public.audit_log DROP CONSTRAINT IF EXISTS audit_log_pkey;
ALTER TABLE IF EXISTS public.tin_nhan ALTER COLUMN so_thu_tu DROP DEFAULT;
DROP TABLE IF EXISTS public.yeu_cau_o_ghep;
DROP TABLE IF EXISTS public.vai_tro;
DROP VIEW IF EXISTS public.v_thong_ke_toa_nha;
DROP VIEW IF EXISTS public.v_so_do_toa_nha;
DROP SEQUENCE IF EXISTS public.tin_nhan_so_thu_tu_seq;
DROP TABLE IF EXISTS public.tin_nhan;
DROP TABLE IF EXISTS public.tien_ich;
DROP TABLE IF EXISTS public.thong_bao_nguoi_nhan;
DROP TABLE IF EXISTS public.thong_bao;
DROP TABLE IF EXISTS public.thanh_vien_hop_dong;
DROP TABLE IF EXISTS public.thanh_vien_cuoc_tro_chuyen;
DROP TABLE IF EXISTS public.thanh_toan;
DROP TABLE IF EXISTS public.tang;
DROP TABLE IF EXISTS public.tai_san_phong;
DROP TABLE IF EXISTS public.su_co;
DROP TABLE IF EXISTS public.refresh_token;
DROP TABLE IF EXISTS public.phuong_tien;
DROP TABLE IF EXISTS public.phu_luc_hop_dong;
DROP TABLE IF EXISTS public.phong_tien_ich;
DROP TABLE IF EXISTS public.phong;
DROP TABLE IF EXISTS public.nha_tro;
DROP TABLE IF EXISTS public.nguoi_dung_vai_tro;
DROP TABLE IF EXISTS public.nguoi_dung_nha_tro;
DROP TABLE IF EXISTS public.nguoi_dung;
DROP TABLE IF EXISTS public.meter_anomaly_alert;
DROP TABLE IF EXISTS public.login_history;
DROP TABLE IF EXISTS public.lich_thanh_toan;
DROP TABLE IF EXISTS public.lich_su_kho_tai_san;
DROP TABLE IF EXISTS public.lich_su_hoa_don;
DROP TABLE IF EXISTS public.lich_hen;
DROP TABLE IF EXISTS public.kho_tai_san;
DROP TABLE IF EXISTS public.khach_thue;
DROP TABLE IF EXISTS public.invoice_generation_log;
DROP TABLE IF EXISTS public.invoice_generation_batch;
DROP TABLE IF EXISTS public.hop_dong;
DROP TABLE IF EXISTS public.hoa_don;
DROP TABLE IF EXISTS public.file_media;
DROP TABLE IF EXISTS public.email_verification_token;
DROP TABLE IF EXISTS public.dich_vu_hop_dong;
DROP TABLE IF EXISTS public.dich_vu;
DROP TABLE IF EXISTS public.debt_reminder_log;
DROP TABLE IF EXISTS public.dat_coc_phong;
DROP TABLE IF EXISTS public.dang_ky_push;
DROP TABLE IF EXISTS public.cuoc_tro_chuyen;
DROP TABLE IF EXISTS public.contract_signature;
DROP TABLE IF EXISTS public.chu_tro;
DROP TABLE IF EXISTS public.chi_tiet_hoa_don;
DROP TABLE IF EXISTS public.chi_so_dien_nuoc;
DROP TABLE IF EXISTS public.chan_nguoi_dung;
DROP TABLE IF EXISTS public.cau_hinh_gia;
DROP TABLE IF EXISTS public.bao_cao_tin_nhan;
DROP TABLE IF EXISTS public.bank_transaction;
DROP TABLE IF EXISTS public.audit_log;
DROP FUNCTION IF EXISTS public.update_updated_at_column();
DROP FUNCTION IF EXISTS public.update_invoice_status_on_payment();
DROP FUNCTION IF EXISTS public.tao_lich_thanh_toan_hang_thang(p_hop_dong_id uuid);
DROP FUNCTION IF EXISTS public.sinh_phong_toa_nha(p_nha_tro_id uuid, p_so_tang integer, p_so_phong_moi_tang integer, p_dien_tich numeric, p_gia_hien_tai numeric, p_tien_coc_mac_dinh numeric, p_so_nguoi_toi_da integer);
DROP FUNCTION IF EXISTS public.recalc_hoa_don_from_thanh_toan();
DROP FUNCTION IF EXISTS public.recalc_hoa_don_from_chi_tiet();
DROP FUNCTION IF EXISTS public.is_admin();
DROP FUNCTION IF EXISTS public.f_khong_dau(text);
DROP FUNCTION IF EXISTS public.clone_cau_truc_toa_nha(p_nha_tro_nguon_id uuid, p_nha_tro_dich_id uuid);
DROP FUNCTION IF EXISTS public.cap_nhat_trang_thai_hoa_don();
DROP FUNCTION IF EXISTS public.cap_nhat_thoi_gian();
DROP FUNCTION IF EXISTS public.can_access_nha_tro(p_nha_tro_id uuid);
DROP TYPE IF EXISTS public.vai_tro_thanh_vien_chat;
DROP TYPE IF EXISTS public.vai_tro_he_thong;
DROP TYPE IF EXISTS public.uu_tien_enum;
DROP TYPE IF EXISTS public.user_status;
DROP TYPE IF EXISTS public.trang_thai_thanh_toan;
DROP TYPE IF EXISTS public.trang_thai_su_co;
DROP TYPE IF EXISTS public.trang_thai_phuong_tien;
DROP TYPE IF EXISTS public.trang_thai_phong;
DROP TYPE IF EXISTS public.trang_thai_nguoi_dung;
DROP TYPE IF EXISTS public.trang_thai_lich_hen;
DROP TYPE IF EXISTS public.trang_thai_hop_dong;
DROP TYPE IF EXISTS public.trang_thai_hoa_don;
DROP TYPE IF EXISTS public.trang_thai_dat_coc;
DROP TYPE IF EXISTS public.trang_thai_cuoc_tro_chuyen;
DROP TYPE IF EXISTS public.trang_thai_coc_hop_dong;
DROP TYPE IF EXISTS public.trang_thai_chi_so;
DROP TYPE IF EXISTS public.trang_thai_bao_cao;
DROP TYPE IF EXISTS public.room_status;
DROP TYPE IF EXISTS public.phuong_thuc_thanh_toan;
DROP TYPE IF EXISTS public.nen_tang_push;
DROP TYPE IF EXISTS public.media_entity_type;
DROP TYPE IF EXISTS public.maintenance_status;
DROP TYPE IF EXISTS public.loai_tinh_phi;
DROP TYPE IF EXISTS public.loai_tin_nhan;
DROP TYPE IF EXISTS public.loai_thong_bao;
DROP TYPE IF EXISTS public.loai_su_co_enum;
DROP TYPE IF EXISTS public.loai_muc_hoa_don;
DROP TYPE IF EXISTS public.loai_doi_tuong_media;
DROP TYPE IF EXISTS public.loai_cuoc_tro_chuyen;
DROP TYPE IF EXISTS public.loai_chi_so;
DROP TYPE IF EXISTS public.kenh_thong_bao;
DROP TYPE IF EXISTS public.invoice_status;
DROP TYPE IF EXISTS public.invoice_item_type;
DROP TYPE IF EXISTS public.contract_status;
DROP TYPE IF EXISTS public.contract_deposit_status;
DROP TYPE IF EXISTS public.calc_type;
DROP TYPE IF EXISTS public.booking_deposit_status;
DROP TYPE IF EXISTS public.appointment_status;
DROP EXTENSION IF EXISTS unaccent;
DROP EXTENSION IF EXISTS pg_trgm;
DROP EXTENSION IF EXISTS btree_gist;
--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


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
-- Name: loai_cuoc_tro_chuyen; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_cuoc_tro_chuyen AS ENUM (
    'DIRECT',
    'GROUP',
    'BUILDING',
    'FLOOR',
    'SUPPORT'
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
    'DEPOSIT'
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
-- Name: loai_tin_nhan; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_tin_nhan AS ENUM (
    'TEXT',
    'IMAGE',
    'FILE',
    'SYSTEM'
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
-- Name: nen_tang_push; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.nen_tang_push AS ENUM (
    'WEB',
    'ANDROID',
    'IOS'
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
    'OTHER',
    'VNPAY',
    'DEPOSIT'
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
-- Name: trang_thai_bao_cao; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_bao_cao AS ENUM (
    'PENDING',
    'REVIEWED',
    'DISMISSED',
    'ACTIONED'
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
-- Name: trang_thai_cuoc_tro_chuyen; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_cuoc_tro_chuyen AS ENUM (
    'ACTIVE',
    'ARCHIVED',
    'LOCKED'
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
-- Name: trang_thai_phuong_tien; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_phuong_tien AS ENUM (
    'HIEU_LUC',
    'HET_HIEU_LUC'
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
-- Name: vai_tro_thanh_vien_chat; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vai_tro_thanh_vien_chat AS ENUM (
    'OWNER',
    'MODERATOR',
    'MEMBER'
);


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
-- Name: clone_cau_truc_toa_nha(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.clone_cau_truc_toa_nha(p_nha_tro_nguon_id uuid, p_nha_tro_dich_id uuid) RETURNS TABLE(tang_duoc_tao integer, phong_duoc_tao integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_tang record;
    v_phong record;
    v_tang_moi_id uuid;
    v_tang_count integer := 0;
    v_phong_count integer := 0;
BEGIN
    FOR v_tang IN
        SELECT *
        FROM public.tang
        WHERE nha_tro_id = p_nha_tro_nguon_id
          AND xoa_luc IS NULL
        ORDER BY so_tang
    LOOP
        INSERT INTO public.tang (
            nha_tro_id,
            so_tang,
            ten_tang,
            thu_tu_hien_thi,
            so_phong_du_kien,
            trang_thai
        )
        VALUES (
            p_nha_tro_dich_id,
            v_tang.so_tang,
            v_tang.ten_tang,
            v_tang.thu_tu_hien_thi,
            v_tang.so_phong_du_kien,
            v_tang.trang_thai
        )
        ON CONFLICT (nha_tro_id, so_tang) DO UPDATE
        SET
            ten_tang = EXCLUDED.ten_tang,
            thu_tu_hien_thi = EXCLUDED.thu_tu_hien_thi,
            so_phong_du_kien = EXCLUDED.so_phong_du_kien,
            trang_thai = EXCLUDED.trang_thai,
            cap_nhat_luc = now()
        RETURNING id INTO v_tang_moi_id;

        v_tang_count := v_tang_count + 1;

        FOR v_phong IN
            SELECT *
            FROM public.phong
            WHERE nha_tro_id = p_nha_tro_nguon_id
              AND tang_id = v_tang.id
              AND xoa_luc IS NULL
            ORDER BY ten
        LOOP
            INSERT INTO public.phong (
                nha_tro_id,
                tang_id,
                ten,
                khu_vuc,
                tang,
                dien_tich,
                so_nguoi_toi_da,
                trang_thai,
                gia_hien_tai,
                tien_coc_mac_dinh,
                mo_ta
            )
            VALUES (
                p_nha_tro_dich_id,
                v_tang_moi_id,
                v_phong.ten,
                v_phong.khu_vuc,
                v_phong.tang,
                v_phong.dien_tich,
                v_phong.so_nguoi_toi_da,
                'AVAILABLE'::public.trang_thai_phong,
                v_phong.gia_hien_tai,
                v_phong.tien_coc_mac_dinh,
                v_phong.mo_ta
            )
            ON CONFLICT (nha_tro_id, ten) DO NOTHING;

            IF FOUND THEN
                v_phong_count := v_phong_count + 1;
            END IF;
        END LOOP;
    END LOOP;

    RETURN QUERY SELECT v_tang_count, v_phong_count;
END;
$$;


--
-- Name: f_khong_dau(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.f_khong_dau(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $_$
    SELECT lower(public.unaccent('public.unaccent'::regdictionary, $1))
$_$;


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
-- Name: sinh_phong_toa_nha(uuid, integer, integer, numeric, numeric, numeric, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.sinh_phong_toa_nha(p_nha_tro_id uuid, p_so_tang integer, p_so_phong_moi_tang integer, p_dien_tich numeric DEFAULT 20, p_gia_hien_tai numeric DEFAULT 0, p_tien_coc_mac_dinh numeric DEFAULT 0, p_so_nguoi_toi_da integer DEFAULT 2) RETURNS TABLE(tang_duoc_tao integer, phong_duoc_tao integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_tang integer;
    v_phong integer;
    v_tang_id uuid;
    v_ma_phong text;
    v_tang_count integer := 0;
    v_phong_count integer := 0;
BEGIN
    IF p_so_tang <= 0 OR p_so_phong_moi_tang <= 0 THEN
        RAISE EXCEPTION 'p_so_tang va p_so_phong_moi_tang phai lon hon 0';
    END IF;
    IF p_dien_tich <= 0 OR p_gia_hien_tai < 0 OR p_tien_coc_mac_dinh < 0 OR p_so_nguoi_toi_da <= 0 THEN
        RAISE EXCEPTION 'Thong so phong khong hop le';
    END IF;

    FOR v_tang IN 1..p_so_tang LOOP
        INSERT INTO public.tang (nha_tro_id, so_tang, ten_tang, thu_tu_hien_thi, so_phong_du_kien)
        VALUES (p_nha_tro_id, v_tang, 'Tang ' || v_tang::text, v_tang, p_so_phong_moi_tang)
        ON CONFLICT (nha_tro_id, so_tang) DO UPDATE
        SET so_phong_du_kien = EXCLUDED.so_phong_du_kien,
            cap_nhat_luc = now()
        RETURNING id INTO v_tang_id;

        v_tang_count := v_tang_count + 1;
        FOR v_phong IN 1..p_so_phong_moi_tang LOOP
            v_ma_phong := U&'Ph\00F2ng ' || (v_tang * 100 + v_phong)::text;
            INSERT INTO public.phong (
                nha_tro_id, tang_id, ten, tang, dien_tich, so_nguoi_toi_da,
                trang_thai, gia_hien_tai, tien_coc_mac_dinh
            )
            VALUES (
                p_nha_tro_id, v_tang_id, v_ma_phong, v_tang, p_dien_tich,
                p_so_nguoi_toi_da, 'AVAILABLE'::public.trang_thai_phong,
                p_gia_hien_tai, p_tien_coc_mac_dinh
            )
            ON CONFLICT (nha_tro_id, ten) DO NOTHING;
            IF FOUND THEN
                v_phong_count := v_phong_count + 1;
            END IF;
        END LOOP;
    END LOOP;

    RETURN QUERY SELECT v_tang_count, v_phong_count;
END;
$$;


--
-- Name: tao_lich_thanh_toan_hang_thang(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tao_lich_thanh_toan_hang_thang(p_hop_dong_id uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_hd public.hop_dong%ROWTYPE;
    v_ngay date;
    v_tu_ngay date;
    v_den_ngay date;
    v_han_thanh_toan date;
    v_so_ngay_o integer;
    v_so_ngay_thang integer;
    v_count integer := 0;
BEGIN
    SELECT *
    INTO v_hd
    FROM public.hop_dong
    WHERE id = p_hop_dong_id
      AND xoa_luc IS NULL;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Khong tim thay hop dong %', p_hop_dong_id;
    END IF;

    v_ngay := date_trunc('month', v_hd.ngay_bat_dau)::date;

    WHILE v_ngay <= v_hd.ngay_ket_thuc LOOP
        v_tu_ngay := greatest(v_hd.ngay_bat_dau, v_ngay);
        v_den_ngay := least(v_hd.ngay_ket_thuc, (v_ngay + INTERVAL '1 month - 1 day')::date);
        v_so_ngay_o := (v_den_ngay - v_tu_ngay) + 1;
        v_so_ngay_thang := extract(day FROM (v_ngay + INTERVAL '1 month - 1 day'))::integer;
        v_han_thanh_toan := make_date(
            extract(year FROM (v_ngay + INTERVAL '1 month'))::integer,
            extract(month FROM (v_ngay + INTERVAL '1 month'))::integer,
            least(
                coalesce(v_hd.ngay_thanh_toan_hang_thang, 5),
                extract(day FROM ((v_ngay + INTERVAL '2 month - 1 day')::date))::integer
            )
        );

        INSERT INTO public.lich_thanh_toan (
            hop_dong_id,
            ky_nam,
            ky_thang,
            tu_ngay,
            den_ngay,
            han_thanh_toan,
            so_tien_du_kien
        )
        VALUES (
            v_hd.id,
            extract(year FROM v_ngay)::integer,
            extract(month FROM v_ngay)::integer,
            v_tu_ngay,
            v_den_ngay,
            v_han_thanh_toan,
            round(v_hd.gia_thue_hop_dong * v_so_ngay_o / v_so_ngay_thang, 2)
        )
        ON CONFLICT (hop_dong_id, ky_nam, ky_thang) DO UPDATE
        SET
            tu_ngay = EXCLUDED.tu_ngay,
            den_ngay = EXCLUDED.den_ngay,
            han_thanh_toan = EXCLUDED.han_thanh_toan,
            so_tien_du_kien = EXCLUDED.so_tien_du_kien,
            cap_nhat_luc = now();

        v_count := v_count + 1;
        v_ngay := (v_ngay + INTERVAL '1 month')::date;
    END LOOP;

    RETURN v_count;
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
-- Name: audit_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid,
    hanh_dong character varying(255) NOT NULL,
    bang_tac_dong character varying(255),
    ban_ghi_id uuid,
    du_lieu_cu jsonb,
    du_lieu_moi jsonb,
    ip_address inet,
    user_agent character varying(255),
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: bank_transaction; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bank_transaction (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nha_tro_id uuid,
    hoa_don_id uuid,
    so_tien numeric(38,2) NOT NULL,
    noi_dung_chuyen_khoan character varying(255),
    ma_giao_dich character varying(150),
    ngan_hang character varying(100),
    thoi_gian_giao_dich timestamp with time zone NOT NULL,
    payload jsonb,
    da_doi_soat boolean DEFAULT false NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_bank_transaction_tien CHECK ((so_tien > (0)::numeric))
);


--
-- Name: bao_cao_tin_nhan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bao_cao_tin_nhan (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tin_nhan_id uuid NOT NULL,
    cuoc_tro_chuyen_id uuid NOT NULL,
    nguoi_bao_cao_id uuid NOT NULL,
    ly_do text NOT NULL,
    trang_thai public.trang_thai_bao_cao DEFAULT 'PENDING'::public.trang_thai_bao_cao NOT NULL,
    nguoi_xu_ly_id uuid,
    ghi_chu_xu_ly text,
    xu_ly_luc timestamp with time zone,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
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
-- Name: chan_nguoi_dung; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chan_nguoi_dung (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_chan_id uuid NOT NULL,
    nguoi_bi_chan_id uuid NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_khong_tu_chan CHECK ((nguoi_chan_id <> nguoi_bi_chan_id))
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
    CONSTRAINT chk_chi_so_ky CHECK (((ky_thang >= 1) AND (ky_thang <= 12) AND ((ky_nam >= 2000) AND (ky_nam <= 2100))))
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
-- Name: contract_signature; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contract_signature (
    id uuid NOT NULL,
    ip_address character varying(255),
    signature_image_url text,
    signed_at timestamp(6) with time zone NOT NULL,
    signer_id uuid,
    signer_role character varying(255) NOT NULL,
    user_agent character varying(255),
    hop_dong_id uuid NOT NULL
);


--
-- Name: cuoc_tro_chuyen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cuoc_tro_chuyen (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    loai public.loai_cuoc_tro_chuyen NOT NULL,
    ten text,
    anh text,
    nha_tro_id uuid,
    tang_id uuid,
    nguoi_tao_id uuid,
    trang_thai public.trang_thai_cuoc_tro_chuyen DEFAULT 'ACTIVE'::public.trang_thai_cuoc_tro_chuyen NOT NULL,
    khoa_duy_nhat text NOT NULL,
    tin_nhan_cuoi_luc timestamp with time zone,
    xem_truoc text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone
);


--
-- Name: dang_ky_push; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dang_ky_push (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid NOT NULL,
    nen_tang public.nen_tang_push NOT NULL,
    endpoint text NOT NULL,
    khoa_p256dh text,
    khoa_auth text,
    mo_ta_thiet_bi text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    dung_luc timestamp with time zone
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
    cancelled_at timestamp(6) with time zone,
    confirmed_at timestamp(6) with time zone,
    ly_do_huy character varying(255),
    nguoi_xac_nhan_id uuid,
    CONSTRAINT chk_dat_coc_tien CHECK ((so_tien_coc > (0)::numeric))
);


--
-- Name: debt_reminder_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.debt_reminder_log (
    id uuid NOT NULL,
    channel character varying(255) NOT NULL,
    error_message character varying(255),
    recipient_contact character varying(255),
    reminder_type character varying(255) NOT NULL,
    sent_at timestamp(6) with time zone NOT NULL,
    status character varying(255) NOT NULL,
    hoa_don_id uuid NOT NULL,
    recipient_id uuid,
    CONSTRAINT debt_reminder_log_channel_check CHECK (((channel)::text = ANY (ARRAY[('EMAIL'::character varying)::text, ('SYSTEM_NOTIFICATION'::character varying)::text]))),
    CONSTRAINT debt_reminder_log_reminder_type_check CHECK (((reminder_type)::text = ANY (ARRAY[('DUE_IN_3_DAYS'::character varying)::text, ('DUE_TOMORROW'::character varying)::text, ('OVERDUE_1_DAY'::character varying)::text, ('OVERDUE_7_DAYS'::character varying)::text, ('OVERDUE_15_DAYS'::character varying)::text, ('OVERDUE_30_DAYS'::character varying)::text, ('MANUAL'::character varying)::text])))
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
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid NOT NULL,
    token character varying(255) NOT NULL,
    ngay_het_han timestamp with time zone NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
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
    auto_generated boolean DEFAULT false,
    generation_batch_id uuid,
    source_schedule_id uuid,
    CONSTRAINT chk_hoa_don_ky CHECK (((ky_thang >= 1) AND (ky_thang <= 12) AND ((ky_nam >= 2000) AND (ky_nam <= 2100)))),
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
    template_version character varying(100),
    previewed_at timestamp with time zone,
    confirmed_at timestamp with time zone,
    locked_at timestamp with time zone,
    signed_pdf_url text,
    tenant_signed_at timestamp with time zone,
    landlord_signed_at timestamp with time zone,
    signature_status character varying(50) DEFAULT 'UNSIGNED'::character varying NOT NULL,
    CONSTRAINT chk_hop_dong_chi_so CHECK ((((chi_so_dien_ban_dau IS NULL) OR (chi_so_dien_ban_dau >= 0)) AND ((chi_so_nuoc_ban_dau IS NULL) OR (chi_so_nuoc_ban_dau >= 0)))),
    CONSTRAINT chk_hop_dong_ngay CHECK ((ngay_ket_thuc > ngay_bat_dau)),
    CONSTRAINT chk_hop_dong_ngay_thanh_toan CHECK (((ngay_thanh_toan_hang_thang >= 1) AND (ngay_thanh_toan_hang_thang <= 31))),
    CONSTRAINT chk_hop_dong_tien CHECK (((gia_thue_hop_dong >= (0)::numeric) AND (tien_coc >= (0)::numeric)))
);


--
-- Name: invoice_generation_batch; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoice_generation_batch (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nha_tro_id uuid,
    ky_thang integer NOT NULL,
    ky_nam integer NOT NULL,
    trang_thai character varying(50) NOT NULL,
    tong_hop_dong integer NOT NULL,
    tao_thanh_cong integer NOT NULL,
    bo_qua integer NOT NULL,
    loi integer NOT NULL,
    nguoi_tao_id uuid,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: invoice_generation_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoice_generation_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    batch_id uuid NOT NULL,
    hop_dong_id uuid,
    hoa_don_id uuid,
    status character varying(50) NOT NULL,
    reason text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
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
-- Name: kho_tai_san; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kho_tai_san (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nha_tro_id uuid NOT NULL,
    ten_tai_san character varying(255) NOT NULL,
    hinh_anh text,
    tong_so_luong integer DEFAULT 0 NOT NULL,
    so_luong_kha_dung integer DEFAULT 0 NOT NULL,
    so_luong_da_cap_phat integer DEFAULT 0 NOT NULL,
    so_luong_hu_hong integer DEFAULT 0 NOT NULL,
    tinh_trang character varying(255) NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now(),
    cap_nhat_luc timestamp with time zone DEFAULT now(),
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
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    ghi_chu_admin text,
    so_cccd character varying(50)
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
-- Name: lich_su_kho_tai_san; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lich_su_kho_tai_san (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    kho_tai_san_id uuid NOT NULL,
    phong_id uuid,
    loai_giao_dich character varying(255) NOT NULL,
    so_luong integer NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now()
);


--
-- Name: lich_thanh_toan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lich_thanh_toan (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hop_dong_id uuid NOT NULL,
    ky_nam integer NOT NULL,
    ky_thang integer NOT NULL,
    tu_ngay date NOT NULL,
    den_ngay date NOT NULL,
    han_thanh_toan date NOT NULL,
    so_tien_du_kien numeric(15,2) NOT NULL,
    hoa_don_id uuid,
    trang_thai character varying(30) DEFAULT 'PENDING'::character varying NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    CONSTRAINT chk_lich_thanh_toan_ky CHECK (((ky_thang >= 1) AND (ky_thang <= 12) AND ((ky_nam >= 2000) AND (ky_nam <= 2100)))),
    CONSTRAINT chk_lich_thanh_toan_ngay CHECK (((den_ngay >= tu_ngay) AND (han_thanh_toan >= tu_ngay))),
    CONSTRAINT chk_lich_thanh_toan_tien CHECK ((so_tien_du_kien >= (0)::numeric))
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
-- Name: meter_anomaly_alert; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meter_anomaly_alert (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    chi_so_id uuid NOT NULL,
    phong_id uuid NOT NULL,
    hop_dong_id uuid,
    loai character varying(50) NOT NULL,
    ky_thang integer NOT NULL,
    ky_nam integer NOT NULL,
    tieu_thu_hien_tai integer NOT NULL,
    tieu_thu_trung_binh numeric(10,2),
    ty_le_tang numeric(10,2),
    muc_do character varying(50) NOT NULL,
    ly_do text NOT NULL,
    trang_thai character varying(50) DEFAULT 'OPEN'::character varying NOT NULL,
    resolved_at timestamp with time zone,
    resolved_by uuid,
    tao_luc timestamp with time zone NOT NULL
);


--
-- Name: nguoi_dung; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nguoi_dung (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
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
    trang_thai_kyc character varying(50) DEFAULT 'NONE'::character varying,
    anh_cccd_truoc character varying(500),
    anh_cccd_sau character varying(500),
    anh_gpkd character varying(500),
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
    xoa_luc timestamp with time zone,
    vi_do numeric(10,7),
    kinh_do numeric(10,7),
    google_place_id character varying(255),
    dia_chi_da_chuan_hoa text,
    CONSTRAINT nha_tro_kinh_do_range CHECK (((kinh_do IS NULL) OR ((kinh_do >= ('-180'::integer)::numeric) AND (kinh_do <= (180)::numeric)))),
    CONSTRAINT nha_tro_vi_do_range CHECK (((vi_do IS NULL) OR ((vi_do >= ('-90'::integer)::numeric) AND (vi_do <= (90)::numeric))))
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
    tang_id uuid,
    CONSTRAINT chk_phong_dien_tich CHECK ((dien_tich > (0)::numeric)),
    CONSTRAINT chk_phong_gia CHECK (((gia_hien_tai >= (0)::numeric) AND (tien_coc_mac_dinh >= (0)::numeric))),
    CONSTRAINT chk_phong_so_nguoi CHECK ((so_nguoi_toi_da > 0)),
    CONSTRAINT chk_phong_tang_hop_le CHECK (((tang IS NOT NULL) OR (tang_id IS NOT NULL)))
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
-- Name: phuong_tien; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phuong_tien (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ma_pt character varying(50) NOT NULL,
    loai_xe character varying(255) NOT NULL,
    bien_so character varying(50) NOT NULL,
    khach_thue_id uuid,
    phong_id uuid,
    nha_tro_id uuid,
    chu_tro_id uuid,
    trang_thai public.trang_thai_phuong_tien DEFAULT 'HIEU_LUC'::public.trang_thai_phuong_tien,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    anh_xe character varying(255),
    loai_phuong_tien character varying(50),
    ten_dong_xe character varying(100),
    mau_xe character varying(50),
    ten_chu_xe character varying(100),
    so_ve_xe character varying(50)
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
-- Name: tai_san_phong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tai_san_phong (
    id uuid NOT NULL,
    phong_id uuid NOT NULL,
    ten_tai_san character varying(255) NOT NULL,
    so_luong integer NOT NULL,
    gia_tri numeric(19,2) NOT NULL,
    tinh_trang character varying(255) NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone,
    cap_nhat_luc timestamp with time zone,
    anh_tai_san text,
    xoa_luc timestamp with time zone,
    kho_tai_san_id uuid
);


--
-- Name: tang; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tang (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nha_tro_id uuid NOT NULL,
    so_tang integer NOT NULL,
    ten_tang character varying(100),
    thu_tu_hien_thi integer,
    so_phong_du_kien integer,
    trang_thai character varying(30) DEFAULT 'ACTIVE'::character varying NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    CONSTRAINT chk_tang_so_phong_du_kien CHECK (((so_phong_du_kien IS NULL) OR (so_phong_du_kien >= 0))),
    CONSTRAINT chk_tang_so_tang CHECK ((so_tang >= 0))
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
-- Name: thanh_vien_cuoc_tro_chuyen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thanh_vien_cuoc_tro_chuyen (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    cuoc_tro_chuyen_id uuid NOT NULL,
    nguoi_dung_id uuid NOT NULL,
    vai_tro public.vai_tro_thanh_vien_chat DEFAULT 'MEMBER'::public.vai_tro_thanh_vien_chat NOT NULL,
    tham_gia_luc timestamp with time zone DEFAULT now() NOT NULL,
    roi_luc timestamp with time zone,
    doc_den_seq bigint DEFAULT 0 NOT NULL,
    doc_den_luc timestamp with time zone,
    tat_thong_bao boolean DEFAULT false NOT NULL,
    ghim boolean DEFAULT false NOT NULL,
    luu_tru boolean DEFAULT false NOT NULL,
    an_den_seq bigint DEFAULT 0 NOT NULL,
    biet_danh text,
    tat_thong_bao_den timestamp with time zone
);


--
-- Name: COLUMN thanh_vien_cuoc_tro_chuyen.tat_thong_bao; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.thanh_vien_cuoc_tro_chuyen.tat_thong_bao IS 'T???t th??ng b??o v?? th???i h???n (?????n khi ng?????i d??ng t??? b???t l???i)';


--
-- Name: COLUMN thanh_vien_cuoc_tro_chuyen.luu_tru; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.thanh_vien_cuoc_tro_chuyen.luu_tru IS 'L??u tr???: ???n kh???i danh s??ch nh??ng gi??? l???ch s???, c?? tin m???i th?? hi???n l???i';


--
-- Name: COLUMN thanh_vien_cuoc_tro_chuyen.an_den_seq; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.thanh_vien_cuoc_tro_chuyen.an_den_seq IS 'Xo?? b???n c???a m??nh: ch??? hi???n th??? tin c?? so_thu_tu > gi?? tr??? n??y. Kh??ng ?????ng d??? li???u ng?????i kh??c';


--
-- Name: COLUMN thanh_vien_cuoc_tro_chuyen.tat_thong_bao_den; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.thanh_vien_cuoc_tro_chuyen.tat_thong_bao_den IS 'T???t th??ng b??o t???i th???i ??i???m n??y. ??ang t???t = tat_thong_bao OR tat_thong_bao_den > now()';


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
-- Name: tin_nhan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tin_nhan (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    so_thu_tu bigint NOT NULL,
    cuoc_tro_chuyen_id uuid NOT NULL,
    nguoi_gui_id uuid,
    loai public.loai_tin_nhan DEFAULT 'TEXT'::public.loai_tin_nhan NOT NULL,
    noi_dung text,
    file_media_id uuid,
    tra_loi_cho_id uuid,
    ma_client text,
    da_thu_hoi boolean DEFAULT false NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    ghim_luc timestamp with time zone,
    nguoi_ghim_id uuid,
    chuyen_tiep_tu_id uuid
);


--
-- Name: COLUMN tin_nhan.ghim_luc; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tin_nhan.ghim_luc IS 'Th???i ??i???m ???????c ghim. NULL = kh??ng ghim. Ph???m vi c??? h???i tho???i, m???i th??nh vi??n ?????u th???y';


--
-- Name: COLUMN tin_nhan.nguoi_ghim_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tin_nhan.nguoi_ghim_id IS 'Ai ???? ghim ??? d??ng ????? hi???n th??? "X ???? ghim m???t tin nh???n"';


--
-- Name: COLUMN tin_nhan.chuyen_tiep_tu_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tin_nhan.chuyen_tiep_tu_id IS 'Tin g???c n???u ????y l?? b???n chuy???n ti???p. D??ng ????? truy v???t khi ki???m duy???t';


--
-- Name: tin_nhan_so_thu_tu_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tin_nhan_so_thu_tu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tin_nhan_so_thu_tu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tin_nhan_so_thu_tu_seq OWNED BY public.tin_nhan.so_thu_tu;


--
-- Name: v_so_do_toa_nha; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_so_do_toa_nha AS
 SELECT nt.id AS nha_tro_id,
    nt.ten AS ten_toa_nha,
    COALESCE(t.so_tang, p.tang) AS so_tang,
    COALESCE(t.ten_tang, (('Tang '::text || (COALESCE(t.so_tang, p.tang))::text))::character varying) AS ten_tang,
    p.id AS phong_id,
    p.ten AS ma_phong,
    p.dien_tich,
    p.gia_hien_tai,
    p.trang_thai AS trang_thai_vat_ly,
    hd.id AS hop_dong_id,
    hd.ma_hop_dong,
    hd.ngay_bat_dau,
    hd.ngay_ket_thuc,
    kt.id AS khach_thue_id,
    kt.ho_ten AS khach_thue_hien_tai,
        CASE
            WHEN (p.trang_thai = 'MAINTENANCE'::public.trang_thai_phong) THEN 'MAINTENANCE'::text
            WHEN (hd.id IS NULL) THEN 'VACANT'::text
            WHEN (hd.ngay_ket_thuc <= (CURRENT_DATE + '30 days'::interval)) THEN 'CONTRACT_EXPIRING'::text
            ELSE 'RENTED'::text
        END AS trang_thai_hien_thi
   FROM ((((public.nha_tro nt
     LEFT JOIN public.tang t ON (((t.nha_tro_id = nt.id) AND (t.xoa_luc IS NULL))))
     LEFT JOIN public.phong p ON (((p.nha_tro_id = nt.id) AND (p.xoa_luc IS NULL) AND ((p.tang_id = t.id) OR ((p.tang_id IS NULL) AND (p.tang = t.so_tang))))))
     LEFT JOIN LATERAL ( SELECT h.id,
            h.phong_id,
            h.khach_thue_id,
            h.ma_hop_dong,
            h.ngay_bat_dau,
            h.ngay_ket_thuc,
            h.ngay_ket_thuc_thuc_te,
            h.gia_thue_hop_dong,
            h.tien_coc,
            h.trang_thai_coc,
            h.trang_thai,
            h.chu_ky_thanh_toan,
            h.ngay_thanh_toan_hang_thang,
            h.tu_dong_gia_han,
            h.chi_so_dien_ban_dau,
            h.chi_so_nuoc_ban_dau,
            h.noi_dung_hop_dong,
            h.file_pdf,
            h.ghi_chu,
            h.tao_luc,
            h.cap_nhat_luc,
            h.xoa_luc,
            h.template_version,
            h.previewed_at,
            h.confirmed_at,
            h.locked_at
           FROM public.hop_dong h
          WHERE ((h.phong_id = p.id) AND (h.xoa_luc IS NULL) AND (h.trang_thai = ANY (ARRAY['PENDING'::public.trang_thai_hop_dong, 'ACTIVE'::public.trang_thai_hop_dong])) AND ((CURRENT_DATE >= h.ngay_bat_dau) AND (CURRENT_DATE <= h.ngay_ket_thuc)))
          ORDER BY h.ngay_bat_dau DESC
         LIMIT 1) hd ON (true))
     LEFT JOIN public.khach_thue kt ON ((kt.id = hd.khach_thue_id)))
  WHERE (nt.xoa_luc IS NULL);


--
-- Name: v_thong_ke_toa_nha; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_thong_ke_toa_nha AS
 SELECT nt.id AS nha_tro_id,
    nt.ten AS ten_toa_nha,
    count(DISTINCT t.id) AS tong_so_tang,
    count(DISTINCT p.id) AS tong_so_phong,
    count(DISTINCT p.id) FILTER (WHERE ((p.trang_thai = 'AVAILABLE'::public.trang_thai_phong) AND (hd.id IS NULL))) AS phong_trong,
    count(DISTINCT p.id) FILTER (WHERE (hd.id IS NOT NULL)) AS phong_dang_thue,
    count(DISTINCT p.id) FILTER (WHERE (p.trang_thai = 'MAINTENANCE'::public.trang_thai_phong)) AS phong_bao_tri,
    count(DISTINCT p.id) FILTER (WHERE ((hd.id IS NOT NULL) AND (hd.ngay_ket_thuc <= (CURRENT_DATE + '30 days'::interval)))) AS hop_dong_sap_het_han,
    COALESCE(sum(hd.gia_thue_hop_dong), (0)::numeric) AS doanh_thu_du_kien_thang
   FROM (((public.nha_tro nt
     LEFT JOIN public.tang t ON (((t.nha_tro_id = nt.id) AND (t.xoa_luc IS NULL))))
     LEFT JOIN public.phong p ON (((p.nha_tro_id = nt.id) AND (p.xoa_luc IS NULL))))
     LEFT JOIN LATERAL ( SELECT h.id,
            h.phong_id,
            h.khach_thue_id,
            h.ma_hop_dong,
            h.ngay_bat_dau,
            h.ngay_ket_thuc,
            h.ngay_ket_thuc_thuc_te,
            h.gia_thue_hop_dong,
            h.tien_coc,
            h.trang_thai_coc,
            h.trang_thai,
            h.chu_ky_thanh_toan,
            h.ngay_thanh_toan_hang_thang,
            h.tu_dong_gia_han,
            h.chi_so_dien_ban_dau,
            h.chi_so_nuoc_ban_dau,
            h.noi_dung_hop_dong,
            h.file_pdf,
            h.ghi_chu,
            h.tao_luc,
            h.cap_nhat_luc,
            h.xoa_luc,
            h.template_version,
            h.previewed_at,
            h.confirmed_at,
            h.locked_at
           FROM public.hop_dong h
          WHERE ((h.phong_id = p.id) AND (h.xoa_luc IS NULL) AND (h.trang_thai = ANY (ARRAY['PENDING'::public.trang_thai_hop_dong, 'ACTIVE'::public.trang_thai_hop_dong])) AND ((CURRENT_DATE >= h.ngay_bat_dau) AND (CURRENT_DATE <= h.ngay_ket_thuc)))
          ORDER BY h.ngay_bat_dau DESC
         LIMIT 1) hd ON (true))
  WHERE (nt.xoa_luc IS NULL)
  GROUP BY nt.id, nt.ten;


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
-- Name: yeu_cau_o_ghep; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.yeu_cau_o_ghep (
    id uuid NOT NULL,
    khach_thue_id uuid NOT NULL,
    hop_dong_id uuid NOT NULL,
    trang_thai character varying(255) NOT NULL,
    loi_nhan character varying(255),
    ghi_chu_tu_choi character varying(255),
    tao_luc timestamp with time zone NOT NULL,
    cap_nhat_luc timestamp with time zone
);


--
-- Name: tin_nhan so_thu_tu; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan ALTER COLUMN so_thu_tu SET DEFAULT nextval('public.tin_nhan_so_thu_tu_seq'::regclass);


--
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.audit_log (id, nguoi_dung_id, hanh_dong, bang_tac_dong, ban_ghi_id, du_lieu_cu, du_lieu_moi, ip_address, user_agent, tao_luc) FROM stdin;
1961087f-63f6-4b9b-b97c-5645eb6318ee	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	REGISTER	nguoi_dung	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	\N	\N	\N	\N	2026-07-22 11:16:15.467887+00
00580cb9-fc8c-4fcf-a633-ace38e61706b	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	LOGIN	nguoi_dung	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	\N	\N	\N	\N	2026-07-22 11:16:23.121044+00
bfe09189-38d6-4341-b48c-1a92e0742b62	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	LOGIN	nguoi_dung	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	\N	\N	\N	\N	2026-07-22 11:21:34.291253+00
95ab2218-811b-4e84-87e9-cad585137703	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	LOGIN	nguoi_dung	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	\N	\N	\N	\N	2026-07-22 13:10:39.595239+00
398347ab-fa71-4bab-bf58-21b181baf760	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	LOGIN	nguoi_dung	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	\N	\N	\N	\N	2026-07-22 13:10:47.450366+00
d028f7b7-5fae-488e-84b2-11c449cb30f7	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	cau_hinh_gia	f13e9699-be11-4929-992b-1d4e28b20458	\N	\N	\N	\N	2026-07-22 13:14:04.526206+00
72876a0d-4660-499a-9fd6-fcd6416e0038	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	cau_hinh_gia	9561167c-52e0-401f-9a0b-1aa83a44a6cb	\N	\N	\N	\N	2026-07-22 13:14:13.063767+00
8fffdf48-cb1b-45b9-93d9-8260617ba5c5	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CONFIRM	hop_dong	2081e346-2e5a-4a64-ba2a-4a696e6b1158	\N	\N	\N	\N	2026-07-22 13:23:13.895012+00
7c564b09-bd9c-480c-84dc-c519fdab30db	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	thong_bao	39d198aa-8321-478c-bccb-7ab6427d43e9	\N	\N	\N	\N	2026-07-22 13:29:47.108568+00
3c4c61f9-8c33-4c99-abb8-67c0160ccc3a	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	SEND	thong_bao	39d198aa-8321-478c-bccb-7ab6427d43e9	\N	\N	\N	\N	2026-07-22 13:32:45.492305+00
af325912-7e37-4d9c-9b60-d3b434858b20	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	SEND	thong_bao	39d198aa-8321-478c-bccb-7ab6427d43e9	\N	\N	\N	\N	2026-07-22 13:32:58.806938+00
08af5b65-0ff5-489b-9fe5-79494ff0d087	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	thong_bao	0fe35f57-0a8b-4aaa-9324-0af0ae5282e2	\N	\N	\N	\N	2026-07-22 13:34:56.4002+00
b34e1b13-84b5-4b59-81a7-5b26f866f615	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	SEND	thong_bao	0fe35f57-0a8b-4aaa-9324-0af0ae5282e2	\N	\N	\N	\N	2026-07-22 13:38:18.991087+00
c4070916-651f-4dbe-974c-a0b9e6371f05	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	UPDATE	thong_bao	0fe35f57-0a8b-4aaa-9324-0af0ae5282e2	\N	\N	\N	\N	2026-07-22 13:38:31.461137+00
a41b3901-54d3-4bd9-a985-a6303e1f5bdd	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	thong_bao	92f0a59c-c1a3-4389-9b4d-5c3943636023	\N	\N	\N	\N	2026-07-22 13:38:40.863187+00
e3615cce-e99d-46ab-bad1-e1907f713977	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	thong_bao	ca7e592f-7852-4724-b993-9eb51f0e0f2f	\N	\N	\N	\N	2026-07-22 13:44:06.723699+00
90cc9c00-ef3e-4931-8999-a58b603b1aff	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	thong_bao	755a8efe-b632-4208-8eda-408f5028d004	\N	\N	\N	\N	2026-07-22 13:49:05.740788+00
cc0c02f0-fc78-4517-8ce3-9f0410b7af6e	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	thong_bao	96826d3e-7265-40ec-8290-79ad665d507c	\N	\N	\N	\N	2026-07-22 13:49:23.704791+00
f10bd8d5-16a9-4fc7-8f7b-434d3f739666	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	thong_bao	395eec34-2fa7-4b29-88e7-7ef7930faad9	\N	\N	\N	\N	2026-07-22 13:58:51.306862+00
7fcaabdb-32b3-4d88-9146-bcba7b5cb555	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	thong_bao	a589b84e-46aa-4415-8dac-75b8da9db441	\N	\N	\N	\N	2026-07-22 16:10:29.296253+00
7a116a4d-ac19-49af-ba43-816c5ec792ef	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	thong_bao	4fec1f1b-9b3a-4267-afe1-fbf3af5d065a	\N	\N	\N	\N	2026-07-22 16:27:38.976302+00
4cdac0b6-b64c-4afe-a064-23ae58419ca9	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	LOGIN	nguoi_dung	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	\N	\N	\N	\N	2026-07-23 09:39:44.992558+00
d4fda931-0937-4c56-9b66-7783e585b181	e93c664c-53bc-45b6-9316-198dca1b0cbe	REGISTER	nguoi_dung	e93c664c-53bc-45b6-9316-198dca1b0cbe	\N	\N	\N	\N	2026-07-23 15:05:53.248261+00
79ffeecc-b772-43b2-ab51-fd6833c247cd	e93c664c-53bc-45b6-9316-198dca1b0cbe	LOGIN	nguoi_dung	e93c664c-53bc-45b6-9316-198dca1b0cbe	\N	\N	\N	\N	2026-07-23 15:06:01.816754+00
687a77fc-ffb9-4148-8f7e-054a20b6b766	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	chi_so_dien_nuoc	8c72bf9c-7e3b-458b-a519-b501b46dd0b0	\N	\N	\N	\N	2026-07-23 18:33:04.476289+00
5fc780c4-4ccc-45ef-ab37-16ae21d33ebf	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	chi_so_dien_nuoc	0fd52ba7-bfbb-488e-9659-10f4fe923093	\N	\N	\N	\N	2026-07-23 18:33:21.014708+00
5fda3cba-c235-4734-ad4a-ef7aa19f4841	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	UPDATE	chi_so_dien_nuoc	0fd52ba7-bfbb-488e-9659-10f4fe923093	\N	\N	\N	\N	2026-07-23 18:33:26.257326+00
cb101dbb-c52a-4893-8fa0-2554159aabdc	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	UPDATE	chi_so_dien_nuoc	0fd52ba7-bfbb-488e-9659-10f4fe923093	\N	\N	\N	\N	2026-07-23 18:33:34.531635+00
5fef0b1c-dac8-4c3e-ac68-e3ca5ffe3d1d	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	UPDATE	chi_so_dien_nuoc	0fd52ba7-bfbb-488e-9659-10f4fe923093	\N	\N	\N	\N	2026-07-23 18:33:39.999234+00
6fa4300b-64c0-403f-a094-5051c7cdc741	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	cau_hinh_gia	7a15e292-a4c1-4de5-ab20-6a4e856b0500	\N	\N	\N	\N	2026-07-23 18:58:55.160493+00
5afd4828-f14a-4dd2-9463-d24b177b65dd	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	cau_hinh_gia	c2f89364-b002-46af-a080-09e86fa1a291	\N	\N	\N	\N	2026-07-23 18:59:07.851106+00
85dfa166-2d56-4557-97bf-1ecca9299e5d	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	cau_hinh_gia	8e11c469-cdc8-47bb-9f7d-5dfb4a49388e	\N	\N	\N	\N	2026-07-23 18:59:19.599935+00
8f6022af-5adf-45af-8c72-ca3d515ea147	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	DEACTIVATE	cau_hinh_gia	8e11c469-cdc8-47bb-9f7d-5dfb4a49388e	\N	\N	\N	\N	2026-07-23 19:02:06.520384+00
1697c269-2fa5-4de5-b4a1-4201a5e5bed9	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CANCEL	chi_so_dien_nuoc	8c72bf9c-7e3b-458b-a519-b501b46dd0b0	\N	\N	\N	\N	2026-07-23 19:02:17.814508+00
b4d142d1-9088-4dba-b2b8-841534ce1289	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CANCEL	chi_so_dien_nuoc	0fd52ba7-bfbb-488e-9659-10f4fe923093	\N	\N	\N	\N	2026-07-23 19:02:20.312832+00
7d955119-4cfc-4da1-8f6b-684931f89049	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CONFIRM	hop_dong	122cb046-8a81-4b53-937d-70256e13a62e	\N	\N	\N	\N	2026-07-23 19:03:07.492485+00
cc5a9add-80ab-4316-9d51-e0ecbbfdde41	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	chi_so_dien_nuoc	ac78bbb9-05ad-4e93-b598-720409eaf402	\N	\N	\N	\N	2026-07-23 19:04:20.030096+00
2e518e83-ddf0-4a87-8135-cdf277dbdf9b	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	chi_so_dien_nuoc	6278b410-762e-4e7f-aaeb-f065bf9f1fc6	\N	\N	\N	\N	2026-07-23 19:04:34.993596+00
1badddac-d235-4305-825d-514246ec6ba3	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CANCEL	hoa_don	c01c0433-0996-4087-a14c-a5535ed18dd6	\N	\N	\N	\N	2026-07-23 19:04:50.124014+00
a71b3039-7b8b-43c4-8d59-9e67540b4058	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CONFIRM	hop_dong	21f02101-a8a4-437c-aa2d-1cc3f60f151d	\N	\N	\N	\N	2026-07-23 19:09:02.861901+00
a59b5ca1-85d8-457a-a376-22cff6111649	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CREATE	thanh_toan	dbbf85fd-deca-422f-b1a1-fc27a7da4de3	\N	\N	\N	\N	2026-07-23 19:11:17.492965+00
efe7d871-3b64-4ea9-99b7-5168003d74cd	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	LOGIN	nguoi_dung	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	\N	\N	\N	\N	2026-07-24 07:22:21.615347+00
fee1e667-509e-47bb-afc2-a72d36f284ee	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	LOGIN	nguoi_dung	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	\N	\N	\N	\N	2026-07-24 08:48:24.005337+00
20ff4bf1-d027-4472-9428-90f319afd123	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	LOGIN	nguoi_dung	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	\N	\N	\N	\N	2026-07-24 08:55:25.991991+00
\.


--
-- Data for Name: bank_transaction; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bank_transaction (id, nha_tro_id, hoa_don_id, so_tien, noi_dung_chuyen_khoan, ma_giao_dich, ngan_hang, thoi_gian_giao_dich, payload, da_doi_soat, tao_luc) FROM stdin;
8beff1ee-b4f8-4a9d-98ce-4134c51398e9	7e7978b2-8535-4d5f-851a-65960f801e95	\N	4000000.00	VNPay | TxnRef: 269179968f4dc86f | HD: HD178472655411813DD20 | Thanh toan hoa don 8f4dc86f-f5aa-4b04-a1a2-0ff927b9b03d	269179968f4dc86f	NCB	2026-07-22 14:01:07.042618+00	{"vnp_Amount": "400000000", "vnp_TxnRef": "269179968f4dc86f", "vnp_PayDate": "20260722210104", "vnp_TmnCode": "GGRS4AE3", "vnp_BankCode": "NCB", "vnp_CardType": "ATM", "vnp_OrderInfo": "Thanh toan hoa don 8f4dc86f-f5aa-4b04-a1a2-0ff927b9b03d", "vnp_BankTranNo": "VNP15631725", "vnp_ResponseCode": "00", "vnp_TransactionNo": "15631725", "vnp_TransactionStatus": "00"}	t	2026-07-22 14:01:07.043143+00
\.


--
-- Data for Name: bao_cao_tin_nhan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bao_cao_tin_nhan (id, tin_nhan_id, cuoc_tro_chuyen_id, nguoi_bao_cao_id, ly_do, trang_thai, nguoi_xu_ly_id, ghi_chu_xu_ly, xu_ly_luc, tao_luc) FROM stdin;
\.


--
-- Data for Name: cau_hinh_gia; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cau_hinh_gia (id, nha_tro_id, dich_vu_id, loai, ten_hien_thi, loai_tinh_phi, don_gia, hieu_luc_tu, hieu_luc_den, dang_ap_dung, tao_luc, cap_nhat_luc) FROM stdin;
f13e9699-be11-4929-992b-1d4e28b20458	7e7978b2-8535-4d5f-851a-65960f801e95	\N	ELECTRICITY	Tiền Điện	PER_UNIT	3800.00	2026-07-22	\N	t	2026-07-22 13:14:04.525688+00	2026-07-22 13:14:04.525688+00
9561167c-52e0-401f-9a0b-1aa83a44a6cb	7e7978b2-8535-4d5f-851a-65960f801e95	\N	WATER	Tiền Nước	PER_UNIT	50000.00	2026-07-22	\N	t	2026-07-22 13:14:13.063767+00	2026-07-22 13:14:13.063767+00
7a15e292-a4c1-4de5-ab20-6a4e856b0500	77d63858-dd11-436a-b31f-3739f15af084	\N	ELECTRICITY	Tiền Điện	PER_UNIT	3800.00	2026-07-24	\N	t	2026-07-23 18:58:55.159954+00	2026-07-23 18:58:55.159954+00
c2f89364-b002-46af-a080-09e86fa1a291	77d63858-dd11-436a-b31f-3739f15af084	\N	WATER	Tiền Nước	PER_UNIT	20000.00	2026-07-24	\N	t	2026-07-23 18:59:07.850587+00	2026-07-23 18:59:07.850587+00
8e11c469-cdc8-47bb-9f7d-5dfb4a49388e	77d63858-dd11-436a-b31f-3739f15af084	\N	INTERNET	Tiền Wifi	PER_ROOM	100000.00	2026-07-24	2026-07-24	f	2026-07-23 18:59:19.599416+00	2026-07-23 19:02:06.517965+00
\.


--
-- Data for Name: chan_nguoi_dung; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chan_nguoi_dung (id, nguoi_chan_id, nguoi_bi_chan_id, tao_luc) FROM stdin;
\.


--
-- Data for Name: chi_so_dien_nuoc; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chi_so_dien_nuoc (id, phong_id, hop_dong_id, loai, ky_nam, ky_thang, ngay_ghi, chi_so_cu, chi_so_moi, anh_dong_ho, nguoi_ghi_id, trang_thai, ghi_chu, tao_luc, cap_nhat_luc) FROM stdin;
ac78bbb9-05ad-4e93-b598-720409eaf402	399a5e5a-5a54-452a-85cd-dbf99325750b	122cb046-8a81-4b53-937d-70256e13a62e	ELECTRICITY	2026	7	2026-07-23	0	200	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CONFIRMED		2026-07-23 19:04:20.005959+00	2026-07-23 19:04:20.005959+00
6278b410-762e-4e7f-aaeb-f065bf9f1fc6	399a5e5a-5a54-452a-85cd-dbf99325750b	122cb046-8a81-4b53-937d-70256e13a62e	WATER	2026	7	2026-07-23	0	12	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	CONFIRMED		2026-07-23 19:04:34.982264+00	2026-07-23 19:04:34.982264+00
\.


--
-- Data for Name: chi_tiet_hoa_don; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chi_tiet_hoa_don (id, hoa_don_id, dich_vu_id, chi_so_dien_nuoc_id, su_co_id, loai, mo_ta, so_luong, don_gia, thanh_tien, tao_luc) FROM stdin;
242e6b90-ea1e-40eb-9125-6906b4eaa0bc	4d6ed482-cb76-4a7f-9426-149208f9f960	\N	\N	\N	DEPOSIT	Tiền cọc hợp đồng	1.00	3200000.00	3200000.00	2026-07-23 19:08:45.678038+00
\.


--
-- Data for Name: chu_tro; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chu_tro (id, nguoi_dung_id, ten_cong_ty, so_cccd, ma_so_thue, so_tai_khoan, da_xac_minh, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
b7590c8a-7f65-46ae-b0e7-e328b2a31d54	dddfb501-3d25-4517-ac58-1b9225e85cb3	Cty TNHH Easyhouse	066206004084	066206004084	19040069770013	t	2026-07-08 09:35:36.675829+00	2026-07-08 09:35:43.056302+00	\N
\.


--
-- Data for Name: contract_signature; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contract_signature (id, ip_address, signature_image_url, signed_at, signer_id, signer_role, user_agent, hop_dong_id) FROM stdin;
\.


--
-- Data for Name: cuoc_tro_chuyen; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cuoc_tro_chuyen (id, loai, ten, anh, nha_tro_id, tang_id, nguoi_tao_id, trang_thai, khoa_duy_nhat, tin_nhan_cuoi_luc, xem_truoc, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
13146f4b-2739-4f73-9577-2dd12428563f	FLOOR	Tầng 1	\N	7e7978b2-8535-4d5f-851a-65960f801e95	ac1b3a81-9124-4461-8a13-3766bc1f5d72	\N	ACTIVE	floor_ac1b3a81-9124-4461-8a13-3766bc1f5d72	\N	\N	2026-07-22 13:23:20.269651+00	2026-07-22 13:23:20.269651+00	\N
5155729e-fd60-49ed-9150-23be8832b11b	DIRECT	\N	\N	7e7978b2-8535-4d5f-851a-65960f801e95	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	ACTIVE	direct_08a8fef1-b65f-4b0d-b87f-fb883877e1db_3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-22 16:27:05.224987+00	a	2026-07-22 13:28:42.492691+00	2026-07-22 16:27:05.228701+00	\N
9b38c7cd-acc1-4408-afb8-3999b53128cd	BUILDING	Cả nhà Tòa Nhà FPT	\N	7e7978b2-8535-4d5f-851a-65960f801e95	\N	\N	ACTIVE	building_7e7978b2-8535-4d5f-851a-65960f801e95	2026-07-22 16:26:31.435409+00	gs	2026-07-22 13:23:20.272248+00	2026-07-22 16:26:31.439137+00	\N
\.


--
-- Data for Name: dang_ky_push; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dang_ky_push (id, nguoi_dung_id, nen_tang, endpoint, khoa_p256dh, khoa_auth, mo_ta_thiet_bi, tao_luc, dung_luc) FROM stdin;
\.


--
-- Data for Name: dat_coc_phong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dat_coc_phong (id, phong_id, khach_thue_id, hop_dong_id, so_tien_coc, ngay_dat_coc, ngay_du_kien_vao, trang_thai, ghi_chu, tao_luc, cap_nhat_luc, cancelled_at, confirmed_at, ly_do_huy, nguoi_xac_nhan_id) FROM stdin;
\.


--
-- Data for Name: debt_reminder_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.debt_reminder_log (id, channel, error_message, recipient_contact, reminder_type, sent_at, status, hoa_don_id, recipient_id) FROM stdin;
\.


--
-- Data for Name: dich_vu; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dich_vu (id, chu_tro_id, ten_dich_vu, loai_tinh_phi, don_vi, don_gia_mac_dinh, bat_buoc, tao_luc, cap_nhat_luc) FROM stdin;
20e7d7b3-6202-49a3-b9e5-fe9facc2504e	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	Internet	FIXED	người	100000.00	f	2026-07-22 11:31:18.47614+00	2026-07-22 11:31:18.47614+00
ba073e3f-6f54-4f10-89e4-7ca012906bda	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	Tiền Vệ Sinh 	PER_ROOM	người	20000.00	f	2026-07-22 11:31:44.838618+00	2026-07-22 11:31:44.838618+00
470389b5-ebcf-4da4-be0e-d9a3022dca22	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	Thang máy	PER_ROOM	người	20000.00	f	2026-07-22 11:32:03.566735+00	2026-07-22 11:32:03.566735+00
d6c36043-f6d3-4708-b75d-531000c1e51c	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	Điện	FIXED	\N	3800.00	f	2026-07-23 19:08:45.665523+00	2026-07-23 19:08:45.665523+00
d647fd3d-7ad6-4dbb-a08d-3b559be733ff	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	Nước	FIXED	\N	20000.00	f	2026-07-23 19:08:45.675928+00	2026-07-23 19:08:45.675928+00
\.


--
-- Data for Name: dich_vu_hop_dong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dich_vu_hop_dong (id, hop_dong_id, dich_vu_id, loai_tinh_phi, don_gia_ap_dung, so_luong, bat_dau_tu, ket_thuc_luc, tao_luc) FROM stdin;
eaaa8c08-0f0c-4af9-bba9-55f409447b68	122cb046-8a81-4b53-937d-70256e13a62e	20e7d7b3-6202-49a3-b9e5-fe9facc2504e	FIXED	100000.00	1.00	2026-07-23	\N	2026-07-23 19:02:58.970138+00
960e9b40-5532-4685-b47b-5542f910bb89	122cb046-8a81-4b53-937d-70256e13a62e	ba073e3f-6f54-4f10-89e4-7ca012906bda	PER_ROOM	20000.00	1.00	2026-07-23	\N	2026-07-23 19:02:58.97065+00
4baada13-499d-45af-a770-2a5613527b97	122cb046-8a81-4b53-937d-70256e13a62e	470389b5-ebcf-4da4-be0e-d9a3022dca22	PER_ROOM	20000.00	1.00	2026-07-23	\N	2026-07-23 19:02:58.97065+00
c2274e8f-c0ae-4f83-aff5-c0138fd1220e	21f02101-a8a4-437c-aa2d-1cc3f60f151d	ba073e3f-6f54-4f10-89e4-7ca012906bda	PER_ROOM	20000.00	1.00	2026-07-23	\N	2026-07-23 19:08:45.66077+00
ee8a58df-d659-4950-9e77-a15c3ba5f5a6	21f02101-a8a4-437c-aa2d-1cc3f60f151d	470389b5-ebcf-4da4-be0e-d9a3022dca22	PER_ROOM	20000.00	1.00	2026-07-23	\N	2026-07-23 19:08:45.661307+00
97332459-6e0c-4142-a132-e3b8031145c0	21f02101-a8a4-437c-aa2d-1cc3f60f151d	20e7d7b3-6202-49a3-b9e5-fe9facc2504e	FIXED	100000.00	1.00	2026-07-23	\N	2026-07-23 19:08:45.661307+00
fe4d9b28-7ed8-462e-9f58-5bc2d8043340	21f02101-a8a4-437c-aa2d-1cc3f60f151d	d6c36043-f6d3-4708-b75d-531000c1e51c	FIXED	3800.00	1.00	2026-07-23	\N	2026-07-23 19:08:45.665523+00
b080852c-5011-4f28-9b59-65312750e809	21f02101-a8a4-437c-aa2d-1cc3f60f151d	d647fd3d-7ad6-4dbb-a08d-3b559be733ff	FIXED	20000.00	1.00	2026-07-23	\N	2026-07-23 19:08:45.676454+00
\.


--
-- Data for Name: email_verification_token; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.email_verification_token (id, nguoi_dung_id, token, ngay_het_han, tao_luc) FROM stdin;
6f2a529a-a70d-4f2a-8a1b-bd6c28572900	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	21ae8f93-92f8-41ee-9e1b-c2efced4cf52	2026-07-23 11:16:02.082372+00	2026-07-22 11:16:02.082797+00
dbf2ca3b-4d0c-4254-bae4-3c0cbff1a11c	e93c664c-53bc-45b6-9316-198dca1b0cbe	cca614dd-26b8-43cd-9735-adae706a8b7d	2026-07-24 15:05:33.869167+00	2026-07-23 15:05:33.870013+00
\.


--
-- Data for Name: file_media; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.file_media (id, doi_tuong, doi_tuong_id, url, public_id, loai_file, kich_thuoc_bytes, metadata, nguoi_tai_len_id, tao_luc) FROM stdin;
ad9e3461-692a-4851-96bd-5411bab0b20d	ROOM	09408717-e8cc-4273-88f3-1d516cc70187	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801169/quanlyphongtro/uehwroft3a0v95cdnali.jpg	quanlyphongtro/uehwroft3a0v95cdnali	ROOM_IMAGE	254375	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:06.773047+00
59d1c3f0-e8fd-487a-84a6-83e26f585d0c	ROOM	09408717-e8cc-4273-88f3-1d516cc70187	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801171/quanlyphongtro/x13tbfuhhipptwhmwjrm.jpg	quanlyphongtro/x13tbfuhhipptwhmwjrm	ROOM_IMAGE	294826	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:08.99461+00
c1e0fb46-eadf-4468-899c-dff0efdef86e	ROOM	09408717-e8cc-4273-88f3-1d516cc70187	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801173/quanlyphongtro/jranl1ir1n2zqjj3xgrt.jpg	quanlyphongtro/jranl1ir1n2zqjj3xgrt	ROOM_IMAGE	195488	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:10.952928+00
7a4dc321-cfc5-46e8-a995-7b61bd6df217	ROOM	0c4d97c1-b64f-481a-bc1c-20b0feca05bd	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801175/quanlyphongtro/jqsm3mdxw3gvvdxdfpkj.jpg	quanlyphongtro/jqsm3mdxw3gvvdxdfpkj	ROOM_IMAGE	88634	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:12.696543+00
cbea9f76-fde1-4401-a407-9344bc44f9a7	ROOM	0c4d97c1-b64f-481a-bc1c-20b0feca05bd	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801177/quanlyphongtro/e6cz3lgyvt8xtesfainz.jpg	quanlyphongtro/e6cz3lgyvt8xtesfainz	ROOM_IMAGE	88059	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:14.518551+00
8eff9e0a-b1ae-4ab0-8480-fe2064e521ed	ROOM	0c4d97c1-b64f-481a-bc1c-20b0feca05bd	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801179/quanlyphongtro/d2swlxeymyjgev2pmgh1.jpg	quanlyphongtro/d2swlxeymyjgev2pmgh1	ROOM_IMAGE	93769	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:16.51546+00
2f361f1f-1caf-4f03-9345-6a7c4379a303	ROOM	cf4f7a44-17e0-4f67-b2f4-52a6b6ac3361	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801181/quanlyphongtro/cpmurnjcnn1guratidl0.jpg	quanlyphongtro/cpmurnjcnn1guratidl0	ROOM_IMAGE	80440	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:18.250839+00
e21c6d78-49ea-4181-b2a5-b80ef40c1138	ROOM	cf4f7a44-17e0-4f67-b2f4-52a6b6ac3361	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801183/quanlyphongtro/wrekvawi5cwikbbrkocy.jpg	quanlyphongtro/wrekvawi5cwikbbrkocy	ROOM_IMAGE	244168	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:20.573819+00
d92d3599-5bdd-4d78-aab4-69716545b2a5	ROOM	cf4f7a44-17e0-4f67-b2f4-52a6b6ac3361	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801185/quanlyphongtro/do2gtvtulkiy4ak869tz.jpg	quanlyphongtro/do2gtvtulkiy4ak869tz	ROOM_IMAGE	302374	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:22.648914+00
90fe58ff-89f0-477d-b796-4817a192b63a	ROOM	09408717-e8cc-4273-88f3-1d516cc70187	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801187/quanlyphongtro/ehqam0vm0pedoarlwhzl.jpg	quanlyphongtro/ehqam0vm0pedoarlwhzl	ROOM_IMAGE	86758	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:24.370816+00
eae288e7-0d58-4cdd-8797-f1e462614522	ROOM	09408717-e8cc-4273-88f3-1d516cc70187	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801189/quanlyphongtro/mwtvjmybrtueqvjzsxx6.jpg	quanlyphongtro/mwtvjmybrtueqvjzsxx6	ROOM_IMAGE	83525	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:26.049857+00
1eb17d3f-ab95-4321-a627-e864d37a2dda	ROOM	09408717-e8cc-4273-88f3-1d516cc70187	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801190/quanlyphongtro/qznhttdpevx4uvuvzbco.jpg	quanlyphongtro/qznhttdpevx4uvuvzbco	ROOM_IMAGE	92495	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:28.172289+00
16c6ecce-d740-4d31-93bc-bcc03c802ca5	ROOM	09408717-e8cc-4273-88f3-1d516cc70187	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801192/quanlyphongtro/wc7ud2uimuyierbe8xa4.jpg	quanlyphongtro/wc7ud2uimuyierbe8xa4	ROOM_IMAGE	85984	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:30.004705+00
965a8613-9421-4a86-8d49-91aec911d314	ROOM	0c4d97c1-b64f-481a-bc1c-20b0feca05bd	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801195/quanlyphongtro/nw1nxg2yapiaypn8n8ct.jpg	quanlyphongtro/nw1nxg2yapiaypn8n8ct	ROOM_IMAGE	219338	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:32.876342+00
5b408414-ac99-4a8d-8e5e-6fc347579b86	ROOM	0c4d97c1-b64f-481a-bc1c-20b0feca05bd	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801197/quanlyphongtro/ukpnufdlgpvil2hahxmg.jpg	quanlyphongtro/ukpnufdlgpvil2hahxmg	ROOM_IMAGE	134826	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:34.77822+00
fd67c3f6-68f8-4b21-9d8c-e7171ce96250	ROOM	0c4d97c1-b64f-481a-bc1c-20b0feca05bd	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801199/quanlyphongtro/v6mt23cttlyxozf7pcuf.jpg	quanlyphongtro/v6mt23cttlyxozf7pcuf	ROOM_IMAGE	162731	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:36.71726+00
d0f63787-3e93-46b8-9511-e11d4a922d88	ROOM	0c4d97c1-b64f-481a-bc1c-20b0feca05bd	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801201/quanlyphongtro/f3tqvz2molsmenttjcca.jpg	quanlyphongtro/f3tqvz2molsmenttjcca	ROOM_IMAGE	162731	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:38.64895+00
b399b9c7-a89c-4e47-b74c-16d7d699b080	ROOM	0c4d97c1-b64f-481a-bc1c-20b0feca05bd	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801204/quanlyphongtro/kdsq85ie21vdl7hhvjb4.jpg	quanlyphongtro/kdsq85ie21vdl7hhvjb4	ROOM_IMAGE	219338	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:41.25468+00
0518ada7-2d67-4ad5-aed2-975b106e58e4	ROOM	cf4f7a44-17e0-4f67-b2f4-52a6b6ac3361	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801206/quanlyphongtro/e0lubejjhftz741g5cb5.jpg	quanlyphongtro/e0lubejjhftz741g5cb5	ROOM_IMAGE	237255	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:43.393724+00
487ee836-0f10-4b5c-9a4f-9c7e84bbfa96	ROOM	cf4f7a44-17e0-4f67-b2f4-52a6b6ac3361	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801208/quanlyphongtro/qn1oprvff6tr6pbjjsaz.jpg	quanlyphongtro/qn1oprvff6tr6pbjjsaz	ROOM_IMAGE	324874	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:45.620026+00
d494dc6e-99b0-4df2-bcdb-43550737e7d6	ROOM	cf4f7a44-17e0-4f67-b2f4-52a6b6ac3361	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801211/quanlyphongtro/yrcnodzxf047uaavpeuw.jpg	quanlyphongtro/yrcnodzxf047uaavpeuw	ROOM_IMAGE	238859	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:48.232369+00
1e41c59c-1383-4e16-b279-99d2571b1fd5	ROOM	cf4f7a44-17e0-4f67-b2f4-52a6b6ac3361	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801213/quanlyphongtro/gcitdhf4ezqgygrgx1gx.jpg	quanlyphongtro/gcitdhf4ezqgygrgx1gx	ROOM_IMAGE	274173	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:52.60879+00
64edc665-14b1-4b99-9f84-622dd43c768b	ROOM	cf4f7a44-17e0-4f67-b2f4-52a6b6ac3361	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801218/quanlyphongtro/xj1xsm2ncngigebqlwvp.jpg	quanlyphongtro/xj1xsm2ncngigebqlwvp	ROOM_IMAGE	281734	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:55.241314+00
8eef1e93-1880-40f4-95ae-40c2d767715d	ROOM	09408717-e8cc-4273-88f3-1d516cc70187	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801219/quanlyphongtro/pq4nkvbllppuffjpymu0.jpg	quanlyphongtro/pq4nkvbllppuffjpymu0	ROOM_IMAGE	55796	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:57.015056+00
8a5fbecb-6d16-452d-837c-68eaf9eeab43	ROOM	09408717-e8cc-4273-88f3-1d516cc70187	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801221/quanlyphongtro/qepkel0899ufwb4hxdbs.jpg	quanlyphongtro/qepkel0899ufwb4hxdbs	ROOM_IMAGE	47026	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:06:58.76126+00
e08f2d83-96e0-4f13-85bf-50caaa7ad12b	ROOM	09408717-e8cc-4273-88f3-1d516cc70187	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801223/quanlyphongtro/wffaz3pu6uqsedekkjus.jpg	quanlyphongtro/wffaz3pu6uqsedekkjus	ROOM_IMAGE	41942	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:07:00.390215+00
33312a51-f8d5-45e2-9d95-8acb1171d04f	ROOM	09408717-e8cc-4273-88f3-1d516cc70187	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801225/quanlyphongtro/aatu6e4g42qibflgdwm3.jpg	quanlyphongtro/aatu6e4g42qibflgdwm3	ROOM_IMAGE	55135	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:07:02.065027+00
99431932-ffb6-47c2-b264-811afd97e34c	ROOM	09408717-e8cc-4273-88f3-1d516cc70187	https://res.cloudinary.com/dd4tyakf3/image/upload/v1784801226/quanlyphongtro/bt4d17jkec4atznrtmji.jpg	quanlyphongtro/bt4d17jkec4atznrtmji	ROOM_IMAGE	60102	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:07:03.791359+00
51baf459-ac16-4d2e-9d36-267b0dfb0cbd	ROOM	b3d3c139-adfc-4551-a128-75d3f05e964e	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784801944/quanlyphongtro/fyskei4liurhfrzqmkkg.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-07-23 10:19:07.252138+00
329cde77-b4ca-4a33-bce2-c0381536555c	ROOM	b3d3c139-adfc-4551-a128-75d3f05e964e	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784801944/quanlyphongtro/dunkxxdvn9cxkidzoa47.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-07-23 10:19:07.252654+00
3161575e-384e-44eb-b89d-024046ea4d97	ROOM	b3d3c139-adfc-4551-a128-75d3f05e964e	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784801944/quanlyphongtro/vz4av1ofl1ucgo9gwezg.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-07-23 10:19:07.25317+00
9946bb09-f9ac-4a65-bc45-d949437d403d	ROOM	b3d3c139-adfc-4551-a128-75d3f05e964e	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784801944/quanlyphongtro/fxsljawu1o8yznkj7vtn.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-07-23 10:19:07.25317+00
1848399d-3b1f-4b67-8916-111bc8e9d1a6	ROOM	b3d3c139-adfc-4551-a128-75d3f05e964e	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784801944/quanlyphongtro/oa9qvxsn8gkqhc1eqyos.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-07-23 10:19:07.25317+00
acea9d3d-ff87-42cf-b1f0-e543fa3a30a2	ROOM	66bd69f7-77bd-4864-a4b4-b70c281909dc	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803130/quanlyphongtro/esznrnuaokiwthzdcshb.jpg	quanlyphongtro/esznrnuaokiwthzdcshb	ROOM_IMAGE	82561	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:38:51.762964+00
d0b84dbb-23cb-4a53-b119-940557f58754	ROOM	66bd69f7-77bd-4864-a4b4-b70c281909dc	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803134/quanlyphongtro/wdxitkwn3h0eoyb6gryg.jpg	quanlyphongtro/wdxitkwn3h0eoyb6gryg	ROOM_IMAGE	211337	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:38:54.692094+00
691f4d56-b9d6-4640-843a-9e4aad5f7990	ROOM	66bd69f7-77bd-4864-a4b4-b70c281909dc	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803135/quanlyphongtro/azcfroqjc5lyhvmbwf09.jpg	quanlyphongtro/azcfroqjc5lyhvmbwf09	ROOM_IMAGE	96505	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:38:56.713689+00
cea77e11-a2f2-4883-82bb-9c0cbc1d25d3	ROOM	2ce166dd-aeea-47d3-aeff-7bdaaab5d55f	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803138/quanlyphongtro/m68cvzpzyn02p90ucmp9.jpg	quanlyphongtro/m68cvzpzyn02p90ucmp9	ROOM_IMAGE	75319	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:38:58.601166+00
7d8a7237-78a9-40d0-a399-2414254916b5	ROOM	2ce166dd-aeea-47d3-aeff-7bdaaab5d55f	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803139/quanlyphongtro/ppkutqpavl7m58gcbsof.jpg	quanlyphongtro/ppkutqpavl7m58gcbsof	ROOM_IMAGE	67366	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:02.035613+00
cf003c60-8feb-4adb-b5a5-01201058e47b	ROOM	2ce166dd-aeea-47d3-aeff-7bdaaab5d55f	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803143/quanlyphongtro/sbwgcwfkbxviqps5rlqe.jpg	quanlyphongtro/sbwgcwfkbxviqps5rlqe	ROOM_IMAGE	81731	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:03.736148+00
f6e97c58-b748-417d-832d-90b20bcf693c	ROOM	eb890091-f900-4817-a603-07bc58826207	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803145/quanlyphongtro/oavrw4zdddyckn5cchyp.jpg	quanlyphongtro/oavrw4zdddyckn5cchyp	ROOM_IMAGE	254375	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:05.922385+00
668c5992-f8bb-4cae-bc0d-55b96bc61872	ROOM	eb890091-f900-4817-a603-07bc58826207	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803148/quanlyphongtro/k637anceo0zcxetzsej9.jpg	quanlyphongtro/k637anceo0zcxetzsej9	ROOM_IMAGE	294826	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:09.191964+00
a205742c-a95a-4ea5-bce0-3dee679a13f9	ROOM	eb890091-f900-4817-a603-07bc58826207	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803150/quanlyphongtro/ep6a8vs8brgejre3tnmh.jpg	quanlyphongtro/ep6a8vs8brgejre3tnmh	ROOM_IMAGE	195488	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:11.135211+00
c6d94356-a2d3-4d65-94e7-f21f4b087d61	ROOM	ecfd4423-5909-43df-bedb-83c813bdc7d7	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803152/quanlyphongtro/zsb28kgx9mz7nnhrtboc.jpg	quanlyphongtro/zsb28kgx9mz7nnhrtboc	ROOM_IMAGE	88634	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:12.989669+00
d6bc2ef4-5112-4271-8e0b-1373bb08f072	ROOM	ecfd4423-5909-43df-bedb-83c813bdc7d7	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803154/quanlyphongtro/wvrjmqxeam30gmtn7dxc.jpg	quanlyphongtro/wvrjmqxeam30gmtn7dxc	ROOM_IMAGE	88059	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:15.044847+00
e3ee1d65-d262-4c0d-8d10-beb9ebf0e934	ROOM	ecfd4423-5909-43df-bedb-83c813bdc7d7	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803156/quanlyphongtro/aqguwdwvgvjv93orhjex.jpg	quanlyphongtro/aqguwdwvgvjv93orhjex	ROOM_IMAGE	93769	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:16.770817+00
6aaa546c-c8e3-4cfa-a01b-f97fdf48c6e1	ROOM	8622d06f-e80a-4904-a3e4-c69ee796bce1	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803157/quanlyphongtro/pnjkji6lasdlrgyms1dg.jpg	quanlyphongtro/pnjkji6lasdlrgyms1dg	ROOM_IMAGE	80440	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:18.771374+00
b699781b-9034-4a68-a342-42f255ba69b9	ROOM	8622d06f-e80a-4904-a3e4-c69ee796bce1	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803160/quanlyphongtro/lyytr44u4xsicahy1fxf.jpg	quanlyphongtro/lyytr44u4xsicahy1fxf	ROOM_IMAGE	244168	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:20.978348+00
e9e4fe91-dcec-4acc-a1f0-15230b6cc1fd	ROOM	8622d06f-e80a-4904-a3e4-c69ee796bce1	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803162/quanlyphongtro/a8cgjxqsjloq3edzdivu.jpg	quanlyphongtro/a8cgjxqsjloq3edzdivu	ROOM_IMAGE	302374	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:23.4449+00
0903e491-5e2c-44ab-a2b1-b7b9d04117f4	ROOM	ad2c99e2-b154-4a77-a3b2-b4a2cfc26f47	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803164/quanlyphongtro/ytqx1n1zb6s06vhvfofm.jpg	quanlyphongtro/ytqx1n1zb6s06vhvfofm	ROOM_IMAGE	86758	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:25.399772+00
3f4c3d28-43d5-4c82-a64f-da2ee7594794	ROOM	ad2c99e2-b154-4a77-a3b2-b4a2cfc26f47	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803166/quanlyphongtro/v7vdqvujhffgupopi5sb.jpg	quanlyphongtro/v7vdqvujhffgupopi5sb	ROOM_IMAGE	83525	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:27.136595+00
40395fa7-e13a-4f21-b5d5-6f5fee7674c1	ROOM	ad2c99e2-b154-4a77-a3b2-b4a2cfc26f47	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803170/quanlyphongtro/szc9x1mstymzijzdg8oz.jpg	quanlyphongtro/szc9x1mstymzijzdg8oz	ROOM_IMAGE	85984	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:30.637189+00
cfd5d609-3f96-4ca8-b678-faf39e81b3d4	ROOM	f394e305-1031-4224-9ee9-a8030baa66ca	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803172/quanlyphongtro/exd6hxg5qbmhwooxvzry.jpg	quanlyphongtro/exd6hxg5qbmhwooxvzry	ROOM_IMAGE	219338	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:32.751198+00
7a8bce96-f5be-4a39-b1a6-7bdcc579a4ad	ROOM	f394e305-1031-4224-9ee9-a8030baa66ca	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803178/quanlyphongtro/hm3ii1wxms4r2ri6bfzy.jpg	quanlyphongtro/hm3ii1wxms4r2ri6bfzy	ROOM_IMAGE	162731	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:38.553841+00
6ce1632f-e4a5-4a2f-aff6-1cab19e21cde	ROOM	69236727-8d2c-4b04-bcb1-fb2af2ff6431	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803182/quanlyphongtro/u1zo34ltwuuxjjzxjygw.jpg	quanlyphongtro/u1zo34ltwuuxjjzxjygw	ROOM_IMAGE	237255	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:43.410718+00
cbf3767f-da29-4b02-b65b-45dd2dbefd58	ROOM	69236727-8d2c-4b04-bcb1-fb2af2ff6431	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803187/quanlyphongtro/d5mw57yxsod0wjdwyjjh.jpg	quanlyphongtro/d5mw57yxsod0wjdwyjjh	ROOM_IMAGE	238859	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:47.740497+00
6253455f-0bf6-4248-8d09-f69a6e15ff60	ROOM	69236727-8d2c-4b04-bcb1-fb2af2ff6431	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803190/quanlyphongtro/y4ltfinsofchlweehzfv.jpg	quanlyphongtro/y4ltfinsofchlweehzfv	ROOM_IMAGE	274173	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:50.947009+00
c6a3ae12-d3eb-4dba-85c5-70eaef81135b	ROOM	69236727-8d2c-4b04-bcb1-fb2af2ff6431	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803192/quanlyphongtro/lzakht5enfroerq7e8ih.jpg	quanlyphongtro/lzakht5enfroerq7e8ih	ROOM_IMAGE	281734	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:52.966885+00
783e275d-c699-4cee-9035-40f8353451e8	ROOM	e0303947-1bc4-4220-8194-f57007d2cf5b	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803195/quanlyphongtro/dvsqouhvwtpown6c9fux.jpg	quanlyphongtro/dvsqouhvwtpown6c9fux	ROOM_IMAGE	47026	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:56.304376+00
160986dc-e082-49df-a3e1-1d1c6345000a	ROOM	e0303947-1bc4-4220-8194-f57007d2cf5b	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803199/quanlyphongtro/ctrdir08db9eim8jpnwd.jpg	quanlyphongtro/ctrdir08db9eim8jpnwd	ROOM_IMAGE	55135	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:40:02.160381+00
dfbcba03-942c-4875-a2b7-2638d13e5f85	ROOM	e0303947-1bc4-4220-8194-f57007d2cf5b	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803203/quanlyphongtro/jmfiorsuflog9gvyaugu.jpg	quanlyphongtro/jmfiorsuflog9gvyaugu	ROOM_IMAGE	60102	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:40:03.836797+00
733e408e-4d95-4212-8dbe-0da84ce92587	ROOM	ad2c99e2-b154-4a77-a3b2-b4a2cfc26f47	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803168/quanlyphongtro/zgtsyhz23n1hhmi3z3mf.jpg	quanlyphongtro/zgtsyhz23n1hhmi3z3mf	ROOM_IMAGE	92495	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:28.8999+00
1c5fd9f5-32d5-4c87-a053-825df93b0c0f	ROOM	f394e305-1031-4224-9ee9-a8030baa66ca	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803174/quanlyphongtro/qici1cxvdk79ykkazthq.jpg	quanlyphongtro/qici1cxvdk79ykkazthq	ROOM_IMAGE	134826	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:34.780475+00
cabe646f-b08f-496b-b659-8057782f633e	ROOM	f394e305-1031-4224-9ee9-a8030baa66ca	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803176/quanlyphongtro/sqzs8hr5wwg4xid2zzue.jpg	quanlyphongtro/sqzs8hr5wwg4xid2zzue	ROOM_IMAGE	162731	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:36.665095+00
7cdf6cd4-d8d5-4dd7-8435-8c5df2c4deb0	ROOM	f394e305-1031-4224-9ee9-a8030baa66ca	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803180/quanlyphongtro/wxz5ykrolkwzaqinrawf.jpg	quanlyphongtro/wxz5ykrolkwzaqinrawf	ROOM_IMAGE	219338	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:40.77641+00
fcf87167-c496-4ce7-858e-c441a1b6687b	ROOM	69236727-8d2c-4b04-bcb1-fb2af2ff6431	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803185/quanlyphongtro/hjmdnjhahgnrcq3wx6tb.jpg	quanlyphongtro/hjmdnjhahgnrcq3wx6tb	ROOM_IMAGE	324874	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:45.656341+00
3d243c3a-e1ee-44e4-ba12-d2b3a8fa1703	ROOM	e0303947-1bc4-4220-8194-f57007d2cf5b	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803194/quanlyphongtro/liagavcxrvs0ool9ecpv.jpg	quanlyphongtro/liagavcxrvs0ool9ecpv	ROOM_IMAGE	55796	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:54.720168+00
55fa5683-aa13-4d15-8be8-d4b2abbaa945	ROOM	e0303947-1bc4-4220-8194-f57007d2cf5b	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784803197/quanlyphongtro/ekinv9wxqu3h1m3trw7s.jpg	quanlyphongtro/ekinv9wxqu3h1m3trw7s	ROOM_IMAGE	41942	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 10:39:58.781549+00
be75f881-30ab-41af-854a-cfbe8f5a08ab	ROOM	522285e4-029b-49b6-a089-3a527aff6a49	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830689/quanlyphongtro/six3ucyfudoovbnknha7.jpg	quanlyphongtro/six3ucyfudoovbnknha7	ROOM_IMAGE	25297	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:07.879305+00
4c7526ca-3a95-44b6-91c3-b4b8bf447f3c	ROOM	122364da-f416-4058-94c3-d956fc2694cf	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830690/quanlyphongtro/isvqfcmbeiu1xibxl0zf.jpg	quanlyphongtro/isvqfcmbeiu1xibxl0zf	ROOM_IMAGE	30464	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:09.424768+00
18d9cd6c-8bd9-4971-8c83-ec3dc0c5244b	ROOM	ea3cb683-a653-488a-a66d-54e08b5afb7b	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830692/quanlyphongtro/t8iq2tduqj3sdv52pc8a.jpg	quanlyphongtro/t8iq2tduqj3sdv52pc8a	ROOM_IMAGE	36887	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:11.008813+00
41e6b6f3-8c9c-4075-bf82-11706c77b390	ROOM	2f3f612f-a78c-412f-ba05-695938037e06	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830693/quanlyphongtro/ghgat0lanozxokwmhjvm.jpg	quanlyphongtro/ghgat0lanozxokwmhjvm	ROOM_IMAGE	32362	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:12.773373+00
d4d418eb-4ae6-4417-8b8e-ecb12f863544	ROOM	5ccb2a8e-b751-456a-a1b1-1022ad2ba80d	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830696/quanlyphongtro/w9id3muhrfpgbvgsze09.jpg	quanlyphongtro/w9id3muhrfpgbvgsze09	ROOM_IMAGE	26205	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:15.863427+00
1ee50e4d-42e1-4cc4-b69a-d5fb2aa3ca68	ROOM	5ccb2a8e-b751-456a-a1b1-1022ad2ba80d	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830698/quanlyphongtro/l1s0zllqlfttfggh8fqv.jpg	quanlyphongtro/l1s0zllqlfttfggh8fqv	ROOM_IMAGE	23397	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:17.405691+00
4fa23d91-361c-416f-9931-526bae2a8ee5	ROOM	5ccb2a8e-b751-456a-a1b1-1022ad2ba80d	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830700/quanlyphongtro/gemjwvqb83eqocgzrdha.jpg	quanlyphongtro/gemjwvqb83eqocgzrdha	ROOM_IMAGE	31538	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:18.924788+00
865aec15-37e4-4fb9-8ad6-a1ae0f710cb2	ROOM	ce7667df-c11a-4578-8b33-23cc2cff64cc	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830701/quanlyphongtro/z18hrahvhobxldut3y9h.jpg	quanlyphongtro/z18hrahvhobxldut3y9h	ROOM_IMAGE	34728	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:20.400145+00
9b1c8429-addd-4ba0-b896-b60561f7fb81	ROOM	ce7667df-c11a-4578-8b33-23cc2cff64cc	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830703/quanlyphongtro/qcayeglhtizdpanxtlrk.jpg	quanlyphongtro/qcayeglhtizdpanxtlrk	ROOM_IMAGE	35785	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:21.91226+00
af48b156-9ca4-4628-a5c7-f34cdeea9aaf	ROOM	a13485ca-23ad-4e45-9ac2-56b1dc40f97f	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830704/quanlyphongtro/fqm6tfqqxmopwefkgb2f.jpg	quanlyphongtro/fqm6tfqqxmopwefkgb2f	ROOM_IMAGE	24621	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:23.889369+00
2b5dd2a6-c00f-48bc-a6c6-b2dfec26c0f5	ROOM	a13485ca-23ad-4e45-9ac2-56b1dc40f97f	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830706/quanlyphongtro/dyruesme5t1zenvumeur.jpg	quanlyphongtro/dyruesme5t1zenvumeur	ROOM_IMAGE	28173	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:25.660306+00
4f78c759-94eb-439f-9607-3a8357a6a903	ROOM	45ef6ce0-2a6d-4d7e-9e86-6f4159908a07	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830708/quanlyphongtro/ksrmgua8npqu4dcarbcm.jpg	quanlyphongtro/ksrmgua8npqu4dcarbcm	ROOM_IMAGE	49719	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:27.438414+00
e729d0f3-82e7-43e6-9d58-abdac9a9f5db	ROOM	334e17c2-58ae-4f32-9065-31870d6b7eba	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830710/quanlyphongtro/qhgqhal1smvvdllm3c9m.jpg	quanlyphongtro/qhgqhal1smvvdllm3c9m	ROOM_IMAGE	32401	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:29.019001+00
5bd08e6f-13c5-406f-9053-745cfbb2194b	ROOM	334e17c2-58ae-4f32-9065-31870d6b7eba	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830711/quanlyphongtro/xnnr5wfqwojgcc6wjhga.jpg	quanlyphongtro/xnnr5wfqwojgcc6wjhga	ROOM_IMAGE	36887	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:30.62394+00
842cd5ac-3d61-458f-bdf3-d6e1482e8432	ROOM	85299d2e-8da2-4a5a-afbf-aa875c6f1892	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830713/quanlyphongtro/hvxsspenusipv4ghllec.jpg	quanlyphongtro/hvxsspenusipv4ghllec	ROOM_IMAGE	18067	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:32.09999+00
49c6ebbc-70cb-408c-8455-321f27357a0f	ROOM	85299d2e-8da2-4a5a-afbf-aa875c6f1892	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830714/quanlyphongtro/nloytjfbybddgbufky6t.jpg	quanlyphongtro/nloytjfbybddgbufky6t	ROOM_IMAGE	22283	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:33.623294+00
6f01684b-fff3-4db3-aec1-0b18b45dde48	ROOM	b2aa2fa4-bedd-4cab-a3cd-ef25fcd3eee0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830716/quanlyphongtro/dsy7azwnywrpjhrkwn9t.jpg	quanlyphongtro/dsy7azwnywrpjhrkwn9t	ROOM_IMAGE	31142	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:36.114009+00
9ee4c30d-7df8-41b2-99cd-33c227306418	ROOM	b2aa2fa4-bedd-4cab-a3cd-ef25fcd3eee0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830718/quanlyphongtro/ycn3j6ockfdhl5mvwbpo.jpg	quanlyphongtro/ycn3j6ockfdhl5mvwbpo	ROOM_IMAGE	32394	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:37.651902+00
d562e0f9-3f1c-4113-b64b-8d714698abeb	ROOM	df5b8b22-22cd-44d8-af1f-a6b9211275aa	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830720/quanlyphongtro/hoopul2s7wvngqgl7xfl.jpg	quanlyphongtro/hoopul2s7wvngqgl7xfl	ROOM_IMAGE	33888	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:39.340315+00
3adc8a61-d039-470a-8e8c-a1bd27dc85b5	ROOM	df5b8b22-22cd-44d8-af1f-a6b9211275aa	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830722/quanlyphongtro/sitxrgaxzifdiucudany.jpg	quanlyphongtro/sitxrgaxzifdiucudany	ROOM_IMAGE	35665	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:40.85617+00
cbe48513-2363-4d91-81cf-13174cec3627	ROOM	4257c62f-4564-43b0-a017-3e5c425028a9	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830723/quanlyphongtro/mmtc2fnbdntyxse045mf.jpg	quanlyphongtro/mmtc2fnbdntyxse045mf	ROOM_IMAGE	26954	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:42.391297+00
cf0abe99-4de3-43fd-a509-46ce46a0b8ec	ROOM	f2815a80-55dd-406b-8d42-d1b1364c20ab	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830725/quanlyphongtro/okczsueaah2bffdmuftv.jpg	quanlyphongtro/okczsueaah2bffdmuftv	ROOM_IMAGE	27792	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:43.973534+00
f226d35c-fe0f-4200-977d-3d52990de4d2	ROOM	f2815a80-55dd-406b-8d42-d1b1364c20ab	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830726/quanlyphongtro/lurlphotzd9mf7ojbvo4.jpg	quanlyphongtro/lurlphotzd9mf7ojbvo4	ROOM_IMAGE	26287	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:45.381483+00
bcbf412e-3b29-49c9-96fc-114a713f0f08	ROOM	7b9daa42-5a81-40c5-8fd1-237e0f0580ae	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830728/quanlyphongtro/bmwdgid8whg8qms3can5.jpg	quanlyphongtro/bmwdgid8whg8qms3can5	ROOM_IMAGE	38950	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:47.032743+00
218dfda0-52eb-49d2-852d-2a1a711cdc6d	ROOM	7b9daa42-5a81-40c5-8fd1-237e0f0580ae	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830729/quanlyphongtro/leoyqtdepjgz1gdquvbp.jpg	quanlyphongtro/leoyqtdepjgz1gdquvbp	ROOM_IMAGE	34308	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:48.480078+00
6861e382-16c7-470e-863c-02c23034da65	ROOM	30a37c17-33bb-4b9c-b0ab-99302af6b391	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830731/quanlyphongtro/dzhb9jsd4wnsk262rkam.jpg	quanlyphongtro/dzhb9jsd4wnsk262rkam	ROOM_IMAGE	22259	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:50.46493+00
a36c886f-41b2-4d37-9d94-d69e11c67396	ROOM	30a37c17-33bb-4b9c-b0ab-99302af6b391	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830733/quanlyphongtro/vmcwuifgysy48hvl9vst.jpg	quanlyphongtro/vmcwuifgysy48hvl9vst	ROOM_IMAGE	19174	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:52.552086+00
4b5a9923-2751-4a2d-992e-ed7286e66568	ROOM	5d08fc02-821c-4b06-b6be-33ada8b8e03d	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830735/quanlyphongtro/zavslkibxjv63egs0gq0.jpg	quanlyphongtro/zavslkibxjv63egs0gq0	ROOM_IMAGE	26949	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:54.208991+00
d325ce31-23fc-483c-8314-ccba1cd12822	ROOM	5d08fc02-821c-4b06-b6be-33ada8b8e03d	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830736/quanlyphongtro/pvmkaizoyyrsbx1bz8kl.jpg	quanlyphongtro/pvmkaizoyyrsbx1bz8kl	ROOM_IMAGE	31173	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:55.847032+00
9006217c-a983-495f-a593-fef7a187f62f	ROOM	20f4a957-c65e-4948-8c10-08224efdc49c	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830738/quanlyphongtro/tkrvueilrpkasci67ady.jpg	quanlyphongtro/tkrvueilrpkasci67ady	ROOM_IMAGE	38703	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:57.306132+00
c5c07373-379b-4ad7-b89f-e50391e00b59	ROOM	9e1a1c3c-e55a-4dc5-894c-3600dba515bd	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830740/quanlyphongtro/mjeodiizmy2tw2ze4tsi.jpg	quanlyphongtro/mjeodiizmy2tw2ze4tsi	ROOM_IMAGE	29046	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:18:58.679189+00
e2d219a1-1cd9-4943-b3a0-b6c7aa682c2c	ROOM	9e1a1c3c-e55a-4dc5-894c-3600dba515bd	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830741/quanlyphongtro/thdwhbmmqe6aupqtx0nj.jpg	quanlyphongtro/thdwhbmmqe6aupqtx0nj	ROOM_IMAGE	32290	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:00.258531+00
87b219b6-ac58-43f8-b47e-f4e12cd70aff	ROOM	a768f13f-8b41-48bf-9a47-23bd8170bae7	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830743/quanlyphongtro/db8xttuixgthvkgfirej.jpg	quanlyphongtro/db8xttuixgthvkgfirej	ROOM_IMAGE	29477	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:01.722873+00
0a1eb0a5-90af-4f21-b53e-f570aa23f3ac	ROOM	4eaccbdb-0a0c-4ada-8ead-71f2bb33ba65	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830744/quanlyphongtro/izpwhhygqgx0gr40ohzm.jpg	quanlyphongtro/izpwhhygqgx0gr40ohzm	ROOM_IMAGE	21305	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:03.224412+00
c6869dc0-4cfa-4366-86fb-b6e81bbbecd4	ROOM	4ed56e2f-ed2c-4767-b939-69e33b4e1fdd	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830745/quanlyphongtro/olh5gkaiqoq9r8x5u1j2.jpg	quanlyphongtro/olh5gkaiqoq9r8x5u1j2	ROOM_IMAGE	34478	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:04.783716+00
4c0143d8-1768-4353-9da4-5246297b3106	ROOM	4ed56e2f-ed2c-4767-b939-69e33b4e1fdd	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830747/quanlyphongtro/mdsi16upefknscygqyib.jpg	quanlyphongtro/mdsi16upefknscygqyib	ROOM_IMAGE	23765	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:06.207218+00
7ac418d3-ba4b-4486-a7cd-dea6144183ca	ROOM	4ed56e2f-ed2c-4767-b939-69e33b4e1fdd	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830749/quanlyphongtro/mo847lqsohaed0kzxlsl.jpg	quanlyphongtro/mo847lqsohaed0kzxlsl	ROOM_IMAGE	25313	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:07.979923+00
9f65d21c-e594-410f-9158-e02029266cb7	ROOM	79ad149a-5202-43fa-b062-f62249306c55	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830750/quanlyphongtro/bzthtole2uq8zfc8xssi.jpg	quanlyphongtro/bzthtole2uq8zfc8xssi	ROOM_IMAGE	31707	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:09.388759+00
81e2efec-b9bc-43cd-9fc8-2a926536ae35	ROOM	79ad149a-5202-43fa-b062-f62249306c55	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830752/quanlyphongtro/cv2pzfb9twnqveublh5x.jpg	quanlyphongtro/cv2pzfb9twnqveublh5x	ROOM_IMAGE	27719	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:10.873743+00
74429e12-df16-4f0f-acbf-ef9f8e9aa761	ROOM	79ad149a-5202-43fa-b062-f62249306c55	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830753/quanlyphongtro/xlvdsdzqlwqjrwjrqsmd.jpg	quanlyphongtro/xlvdsdzqlwqjrwjrqsmd	ROOM_IMAGE	27357	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:12.37135+00
abab3cb4-d84c-42e3-9873-dc146e91dda8	ROOM	79ad149a-5202-43fa-b062-f62249306c55	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830755/quanlyphongtro/llqnsskrjnv5t8u0khb7.jpg	quanlyphongtro/llqnsskrjnv5t8u0khb7	ROOM_IMAGE	32682	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:13.779024+00
c94720c1-0b28-4044-82e3-d6671d3a6970	ROOM	6551a4bd-f3e5-4bba-bacb-b6b039813228	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830756/quanlyphongtro/ybwszmrq4upnudsrg4on.jpg	quanlyphongtro/ybwszmrq4upnudsrg4on	ROOM_IMAGE	24904	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:15.57218+00
a58db2b2-a5c7-4166-9426-0ca8d45c10a1	ROOM	6551a4bd-f3e5-4bba-bacb-b6b039813228	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830758/quanlyphongtro/xzrhxfjlgqz5ktjfcv2x.jpg	quanlyphongtro/xzrhxfjlgqz5ktjfcv2x	ROOM_IMAGE	22603	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:16.923029+00
ad62f4fa-0908-49a3-a1db-51f34ec6cccd	ROOM	6551a4bd-f3e5-4bba-bacb-b6b039813228	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830759/quanlyphongtro/zozya6gozeyryjazgr5p.jpg	quanlyphongtro/zozya6gozeyryjazgr5p	ROOM_IMAGE	21371	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:18.492871+00
e6783915-35c6-488d-8e15-dbb4a0ce689e	ROOM	2bcb986d-3cf0-46f1-b98a-ae8403db45f0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830761/quanlyphongtro/hu44drqmuqib6pecslpb.jpg	quanlyphongtro/hu44drqmuqib6pecslpb	ROOM_IMAGE	20593	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:19.891444+00
94bc408e-fdba-4c72-a3b0-eaa11196354f	ROOM	2bcb986d-3cf0-46f1-b98a-ae8403db45f0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830762/quanlyphongtro/xcu8zyuj5ufeujnbo0pp.jpg	quanlyphongtro/xcu8zyuj5ufeujnbo0pp	ROOM_IMAGE	27773	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:21.288109+00
162eba5b-8d26-4b6c-ae9a-f44eba768e36	ROOM	2bcb986d-3cf0-46f1-b98a-ae8403db45f0	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830764/quanlyphongtro/ues13wpiotaezaqctolj.jpg	quanlyphongtro/ues13wpiotaezaqctolj	ROOM_IMAGE	25550	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:22.700435+00
26201697-fe15-4009-94bd-fa84a403b90c	ROOM	62689ce2-c714-4753-9bb1-26e4f5a94b5b	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830765/quanlyphongtro/wjjjgqmq1kgomnbgjphz.jpg	quanlyphongtro/wjjjgqmq1kgomnbgjphz	ROOM_IMAGE	35258	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:24.146053+00
297c4ace-d1f1-4b8c-ae8a-9fa3c37e9587	ROOM	62689ce2-c714-4753-9bb1-26e4f5a94b5b	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830766/quanlyphongtro/t2mpie0lotr9cejt0ssa.jpg	quanlyphongtro/t2mpie0lotr9cejt0ssa	ROOM_IMAGE	32240	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:25.698497+00
89e69102-4e7b-439c-a192-09e26c835b80	ROOM	62689ce2-c714-4753-9bb1-26e4f5a94b5b	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830768/quanlyphongtro/l1j5u1ogpbmx9va71nkl.jpg	quanlyphongtro/l1j5u1ogpbmx9va71nkl	ROOM_IMAGE	37180	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:27.369807+00
b8fc0b20-512e-4b8f-9573-d21a38aef79e	ROOM	80b33ca1-3a8e-4b03-81b4-224b6218cf7a	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830770/quanlyphongtro/xhu9scmy079i1vjx3q6b.jpg	quanlyphongtro/xhu9scmy079i1vjx3q6b	ROOM_IMAGE	37180	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:28.991004+00
27ff3d1e-715f-424f-8757-ca6b146937c1	ROOM	80b33ca1-3a8e-4b03-81b4-224b6218cf7a	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830771/quanlyphongtro/aflzfhaqvhetm4zyb46z.jpg	quanlyphongtro/aflzfhaqvhetm4zyb46z	ROOM_IMAGE	32240	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:30.944116+00
acc66d45-7123-4e9b-ab58-a98df7a1690f	ROOM	80b33ca1-3a8e-4b03-81b4-224b6218cf7a	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830773/quanlyphongtro/xrt2jka11dns7yfh7hxg.jpg	quanlyphongtro/xrt2jka11dns7yfh7hxg	ROOM_IMAGE	41990	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:32.471991+00
b71b92bf-96f6-4b01-a0a0-2fce53cd33d6	ROOM	32410f45-ea0a-4465-a496-c4efb89014cb	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830775/quanlyphongtro/gyjxioiqv7fc3oxj6mlu.jpg	quanlyphongtro/gyjxioiqv7fc3oxj6mlu	ROOM_IMAGE	22954	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:33.94833+00
fa1b4c87-1688-4de4-9f1f-0b758e4bd037	ROOM	32410f45-ea0a-4465-a496-c4efb89014cb	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830776/quanlyphongtro/ecvdfbkfhjiqmxnom1g3.jpg	quanlyphongtro/ecvdfbkfhjiqmxnom1g3	ROOM_IMAGE	23452	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:35.37611+00
a75b9f57-925e-414f-b8fc-5772326d843e	ROOM	32410f45-ea0a-4465-a496-c4efb89014cb	https://res.cloudinary.com/dlkh28yfs/image/upload/v1784830778/quanlyphongtro/hhsmmnqdweueaya221ah.jpg	quanlyphongtro/hhsmmnqdweueaya221ah	ROOM_IMAGE	23378	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	2026-07-23 18:19:36.820023+00
\.


--
-- Data for Name: hoa_don; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hoa_don (id, hop_dong_id, phong_id, khach_thue_id, ma_hoa_don, ky_nam, ky_thang, tu_ngay, den_ngay, so_du_dau_ky, tong_tien_phat_sinh, tong_tien, da_tra, trang_thai, han_tra, ngay_lap_hoa_don, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, auto_generated, generation_batch_id, source_schedule_id) FROM stdin;
c01c0433-0996-4087-a14c-a5535ed18dd6	122cb046-8a81-4b53-937d-70256e13a62e	399a5e5a-5a54-452a-85cd-dbf99325750b	a8dfc6bd-b2df-43ea-9611-4edb70498dcc	HD17848333789871E000F	2026	7	2026-07-23	2026-07-23	0.00	0.00	0.00	0.00	CANCELLED	2026-07-31	2026-07-23 19:02:58.98848+00	Thu tiền cọc hợp đồng	2026-07-23 19:02:58.989025+00	2026-07-23 19:06:38.188149+00	2026-07-23 19:04:50.123484+00	t	\N	\N
4d6ed482-cb76-4a7f-9426-149208f9f960	21f02101-a8a4-437c-aa2d-1cc3f60f151d	30a37c17-33bb-4b9c-b0ab-99302af6b391	95094c9c-f0df-49e0-9dae-d4646963e7fa	HD1784833725676AA6D5E	2026	7	2026-07-23	2026-07-23	0.00	3200000.00	3200000.00	3199999.00	PARTIAL	2026-07-31	2026-07-23 19:08:45.677505+00	Thu tiền cọc hợp đồng	2026-07-23 19:08:45.677505+00	2026-07-23 19:11:01.595885+00	\N	t	\N	\N
\.


--
-- Data for Name: hop_dong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hop_dong (id, phong_id, khach_thue_id, ma_hop_dong, ngay_bat_dau, ngay_ket_thuc, ngay_ket_thuc_thuc_te, gia_thue_hop_dong, tien_coc, trang_thai_coc, trang_thai, chu_ky_thanh_toan, ngay_thanh_toan_hang_thang, tu_dong_gia_han, chi_so_dien_ban_dau, chi_so_nuoc_ban_dau, noi_dung_hop_dong, file_pdf, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, template_version, previewed_at, confirmed_at, locked_at, signed_pdf_url, tenant_signed_at, landlord_signed_at, signature_status) FROM stdin;
122cb046-8a81-4b53-937d-70256e13a62e	399a5e5a-5a54-452a-85cd-dbf99325750b	a8dfc6bd-b2df-43ea-9611-4edb70498dcc	HD-PHONG-507-202607-43FAD5	2026-07-23	2026-10-23	\N	3200000.00	3200000.00	NOT_PAID	ACTIVE	MONTHLY	5	f	0	0	ĐIỀU KHOẢN HỢP ĐỒNG THUÊ PHÒNG\n\n1. BÊN CHO THUÊ (Chủ nhà):\n- Cung cấp phòng ở đầy đủ tiện nghi theo thỏa thuận\n- Đảm bảo an ninh, an toàn cho khách thuê\n- Bảo trì, sửa chữa các hư hỏng do hao mòn tự nhiên\n\n2. BÊN THUÊ (Khách thuê):\n- Thanh toán đúng hạn tiền thuê và các chi phí khác\n- Sử dụng phòng đúng mục đích, giữ gìn vệ sinh\n- Không được cải tạo, sửa chữa phòng mà không có sự đồng ý\n- Báo cáo kịp thời các hư hỏng, sự cố\n\n3. ĐIỀU KHOẢN CHUNG:\n- Thời hạn hợp đồng: Từ ngày bắt đầu đến ngày kết thúc\n- Tiền cọc: Được hoàn trả khi kết thúc hợp đồng (trừ các khoản phát sinh)\n- Thanh toán: Hàng tháng vào ngày quy định\n- Điện, nước: Tính theo chỉ số đồng hồ và giá quy định\n- Phí dịch vụ: Theo thỏa thuận riêng\n\n4. CHẤM DỨT HỢP ĐỒNG:\n- Bên thuê có thể chấm dứt hợp đồng trước thời hạn với thông báo trước 30 ngày\n- Bên cho thuê có thể chấm dứt hợp đồng nếu vi phạm nghiêm trọng\n- Hoàn trả tiền cọc sau khi kiểm tra tình trạng phòng\n\n5. ĐIỀU KHOẢN KHÁC:\n- Hai bên cam kết thực hiện đúng các điều khoản đã thỏa thuận\n- Mọi tranh chấp sẽ được giải quyết thông qua thương lượng\n- Hợp đồng có hiệu lực kể từ ngày ký	\N		2026-07-23 19:02:58.948327+00	2026-07-23 19:03:07.473506+00	\N	default-v1	\N	2026-07-23 19:03:07.480856+00	2026-07-23 19:03:07.480856+00	\N	\N	\N	UNSIGNED
21f02101-a8a4-437c-aa2d-1cc3f60f151d	30a37c17-33bb-4b9c-b0ab-99302af6b391	95094c9c-f0df-49e0-9dae-d4646963e7fa	HD-PHONG-206-202607-AE977F	2026-07-23	2026-10-23	\N	3200000.00	3200000.00	NOT_PAID	ACTIVE	MONTHLY	5	f	0	0	ĐIỀU KHOẢN HỢP ĐỒNG THUÊ PHÒNG\n\n1. BÊN CHO THUÊ (Chủ nhà):\n- Cung cấp phòng ở đầy đủ tiện nghi theo thỏa thuận\n- Đảm bảo an ninh, an toàn cho khách thuê\n- Bảo trì, sửa chữa các hư hỏng do hao mòn tự nhiên\n\n2. BÊN THUÊ (Khách thuê):\n- Thanh toán đúng hạn tiền thuê và các chi phí khác\n- Sử dụng phòng đúng mục đích, giữ gìn vệ sinh\n- Không được cải tạo, sửa chữa phòng mà không có sự đồng ý\n- Báo cáo kịp thời các hư hỏng, sự cố\n\n3. ĐIỀU KHOẢN CHUNG:\n- Thời hạn hợp đồng: Từ ngày bắt đầu đến ngày kết thúc\n- Tiền cọc: Được hoàn trả khi kết thúc hợp đồng (trừ các khoản phát sinh)\n- Thanh toán: Hàng tháng vào ngày quy định\n- Điện, nước: Tính theo chỉ số đồng hồ và giá quy định\n- Phí dịch vụ: Theo thỏa thuận riêng\n\n4. CHẤM DỨT HỢP ĐỒNG:\n- Bên thuê có thể chấm dứt hợp đồng trước thời hạn với thông báo trước 30 ngày\n- Bên cho thuê có thể chấm dứt hợp đồng nếu vi phạm nghiêm trọng\n- Hoàn trả tiền cọc sau khi kiểm tra tình trạng phòng\n\n5. ĐIỀU KHOẢN KHÁC:\n- Hai bên cam kết thực hiện đúng các điều khoản đã thỏa thuận\n- Mọi tranh chấp sẽ được giải quyết thông qua thương lượng\n- Hợp đồng có hiệu lực kể từ ngày ký	\N		2026-07-23 19:08:45.644303+00	2026-07-23 19:09:02.839943+00	\N	default-v1	\N	2026-07-23 19:09:02.847324+00	2026-07-23 19:09:02.847324+00	\N	\N	\N	UNSIGNED
\.


--
-- Data for Name: invoice_generation_batch; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.invoice_generation_batch (id, nha_tro_id, ky_thang, ky_nam, trang_thai, tong_hop_dong, tao_thanh_cong, bo_qua, loi, nguoi_tao_id, tao_luc) FROM stdin;
\.


--
-- Data for Name: invoice_generation_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.invoice_generation_log (id, batch_id, hop_dong_id, hoa_don_id, status, reason, tao_luc) FROM stdin;
\.


--
-- Data for Name: khach_thue; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.khach_thue (id, nguoi_dung_id, chu_tro_id, ho_ten, so_dien_thoai, email, so_cccd, ngay_sinh, gioi_tinh, dia_chi, que_quan, nghe_nghiep, ghi_chu, dang_hoat_dong, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
95094c9c-f0df-49e0-9dae-d4646963e7fa	08a8fef1-b65f-4b0d-b87f-fb883877e1db	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	Phùng Văn Thọ	0357165019	ptho2601@gmail.com	066206004001	2006-01-22	nam	\N	Hà Nội	Sinh Viên	\N	t	2026-07-22 13:08:59.801723+00	2026-07-22 13:08:59.801723+00	\N
a8dfc6bd-b2df-43ea-9611-4edb70498dcc	ebc6a196-06ab-4566-84d6-1772eabf3892	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	hàng thị trúc giang	0396822875	\N	066206004002	\N	\N	\N	\N	\N	\N	t	2026-07-23 18:55:21.861313+00	2026-07-23 18:55:21.861313+00	\N
\.


--
-- Data for Name: kho_tai_san; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.kho_tai_san (id, nha_tro_id, ten_tai_san, hinh_anh, tong_so_luong, so_luong_kha_dung, so_luong_da_cap_phat, so_luong_hu_hong, tinh_trang, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
616da7d7-6c05-4620-93a3-f2e44eedfb94	7e7978b2-8535-4d5f-851a-65960f801e95	Tủ lạnh	http://res.cloudinary.com/dd4tyakf3/image/upload/v1784726253/quanlyphongtro/xrprdjhasnhgxdicfpa8.webp	10	9	1	0	Mới	mới	2026-07-22 13:17:35.276969+00	2026-07-22 13:17:49.583648+00	\N
08fcdd2b-706b-484f-a709-b8a257e05ed7	7e7978b2-8535-4d5f-851a-65960f801e95	Tivi	https://cellphones.com.vn/tivi.html	20	19	1	0	Mới		2026-07-22 16:11:33.570954+00	2026-07-22 16:12:19.553693+00	\N
\.


--
-- Data for Name: lich_hen; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lich_hen (id, phong_id, nguoi_dung_id, ho_ten, so_dien_thoai, email, ngay_hen, trang_thai, google_calendar_event_id, da_gui_nhac_nho, ghi_chu, tao_luc, cap_nhat_luc, ghi_chu_admin, so_cccd) FROM stdin;
\.


--
-- Data for Name: lich_su_hoa_don; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lich_su_hoa_don (id, hoa_don_id, trang_thai_truoc, trang_thai_moi, nguoi_thay_doi_id, ghi_chu, tao_luc) FROM stdin;
\.


--
-- Data for Name: lich_su_kho_tai_san; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lich_su_kho_tai_san (id, kho_tai_san_id, phong_id, loai_giao_dich, so_luong, ghi_chu, tao_luc) FROM stdin;
25e82f38-0e79-47fa-ba62-a994d89c07d3	616da7d7-6c05-4620-93a3-f2e44eedfb94	\N	NHAP_KHO	10	Nhập kho ban đầu	2026-07-22 13:17:35.277485+00
fbaf09cb-feec-4190-b087-c876026e52c5	616da7d7-6c05-4620-93a3-f2e44eedfb94	b3d3c139-adfc-4551-a128-75d3f05e964e	CAP_PHAT	1		2026-07-22 13:17:49.583648+00
deca9855-c412-4772-ad74-1ccd9e309ca5	08fcdd2b-706b-484f-a709-b8a257e05ed7	\N	NHAP_KHO	20	Nhập kho ban đầu	2026-07-22 16:11:33.571481+00
\.


--
-- Data for Name: lich_thanh_toan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lich_thanh_toan (id, hop_dong_id, ky_nam, ky_thang, tu_ngay, den_ngay, han_thanh_toan, so_tien_du_kien, hoa_don_id, trang_thai, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
1c709e7b-ccdb-449e-a076-2e4c9addbf24	122cb046-8a81-4b53-937d-70256e13a62e	2026	7	2026-07-23	2026-07-31	2026-08-05	929032.26	\N	PENDING	\N	2026-07-23 19:03:07.473506+00	2026-07-23 19:03:07.473506+00	\N
dddd2ddc-4ade-430e-bb32-56086f13ff0b	122cb046-8a81-4b53-937d-70256e13a62e	2026	8	2026-08-01	2026-08-31	2026-09-05	3200000.00	\N	PENDING	\N	2026-07-23 19:03:07.473506+00	2026-07-23 19:03:07.473506+00	\N
35d14ceb-43ab-476e-b0f4-20cafaba11f9	122cb046-8a81-4b53-937d-70256e13a62e	2026	9	2026-09-01	2026-09-30	2026-10-05	3200000.00	\N	PENDING	\N	2026-07-23 19:03:07.473506+00	2026-07-23 19:03:07.473506+00	\N
04a46095-f95b-44e4-8291-84ee6e5c02cb	122cb046-8a81-4b53-937d-70256e13a62e	2026	10	2026-10-01	2026-10-23	2026-11-05	2374193.55	\N	PENDING	\N	2026-07-23 19:03:07.473506+00	2026-07-23 19:03:07.473506+00	\N
a0931c22-1928-4a5f-ae4e-7f460eaacb72	21f02101-a8a4-437c-aa2d-1cc3f60f151d	2026	7	2026-07-23	2026-07-31	2026-08-05	929032.26	\N	PENDING	\N	2026-07-23 19:09:02.839943+00	2026-07-23 19:09:02.839943+00	\N
cca9dbd4-192a-4071-b410-940203d458d2	21f02101-a8a4-437c-aa2d-1cc3f60f151d	2026	8	2026-08-01	2026-08-31	2026-09-05	3200000.00	\N	PENDING	\N	2026-07-23 19:09:02.839943+00	2026-07-23 19:09:02.839943+00	\N
2064f8e2-ef95-4dbb-ace5-ba6d0a6b88c3	21f02101-a8a4-437c-aa2d-1cc3f60f151d	2026	9	2026-09-01	2026-09-30	2026-10-05	3200000.00	\N	PENDING	\N	2026-07-23 19:09:02.839943+00	2026-07-23 19:09:02.839943+00	\N
fdff9b72-8094-455f-91bb-aa841f5227f7	21f02101-a8a4-437c-aa2d-1cc3f60f151d	2026	10	2026-10-01	2026-10-23	2026-11-05	2374193.55	\N	PENDING	\N	2026-07-23 19:09:02.839943+00	2026-07-23 19:09:02.839943+00	\N
\.


--
-- Data for Name: login_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.login_history (id, nguoi_dung_id, email, thanh_cong, ip_address, user_agent, ly_do_that_bai, tao_luc) FROM stdin;
85670cba-30f6-409e-9a0f-392d46c438c1	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	docong989@gmail.com	t	172.19.0.6	node	\N	2026-07-22 11:16:23.117661+00
bba05169-11c0-498c-981f-c482815a3d51	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	docong989@gmail.com	t	::1	node	\N	2026-07-22 11:21:34.242921+00
289f618c-868e-4bf0-b371-7675f467f2a5	08a8fef1-b65f-4b0d-b87f-fb883877e1db	ptho2601@gmail.com	t	::1	node	\N	2026-07-22 13:09:55.898929+00
429c7c5f-6f39-47ae-9ca5-b872d494c3e5	08a8fef1-b65f-4b0d-b87f-fb883877e1db	ptho2601@gmail.com	t	::1	node	\N	2026-07-22 13:10:07.104392+00
f7d6aff1-2da9-4084-9477-eb06df4b5d03	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	docong989@gmail.com	t	::1	node	\N	2026-07-22 13:10:39.590622+00
8102177c-da60-428e-ae1e-a53cb44deae0	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	docong989@gmail.com	t	::1	node	\N	2026-07-22 13:10:47.446132+00
20be0e3e-6b91-4ceb-bb36-4965e59e9024	08a8fef1-b65f-4b0d-b87f-fb883877e1db	ptho2601@gmail.com	t	::1	node	\N	2026-07-22 13:11:54.024431+00
de6e64b5-9021-4382-b637-e4059cbdd3ad	08a8fef1-b65f-4b0d-b87f-fb883877e1db	ptho2601@gmail.com	t	::1	node	\N	2026-07-22 13:55:29.091822+00
caae0ad0-3682-4e6e-9a44-14291802165f	08a8fef1-b65f-4b0d-b87f-fb883877e1db	ptho2601@gmail.com	t	::1	node	\N	2026-07-22 13:57:03.297756+00
645421cd-4769-420c-95d0-dde0488d2b23	08a8fef1-b65f-4b0d-b87f-fb883877e1db	ptho2601@gmail.com	t	::1	node	\N	2026-07-22 16:08:11.232711+00
fc5a9bad-c6c8-4f6b-b161-434a48022f24	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	docong989@gmail.com	t	::1	node	\N	2026-07-23 09:39:44.942957+00
24f4e438-1f3b-47a5-8dcd-d4dbe612ffab	08a8fef1-b65f-4b0d-b87f-fb883877e1db	ptho2601@gmail.com	t	::1	node	\N	2026-07-23 10:44:45.707353+00
70e7f126-4ef0-4e6a-8c4c-56190bf394aa	e93c664c-53bc-45b6-9316-198dca1b0cbe	phts6626@gmail.com	t	172.19.0.6	node	\N	2026-07-23 15:06:01.803359+00
b5aa6428-149d-4e56-8cb3-896891fbc4dc	08a8fef1-b65f-4b0d-b87f-fb883877e1db	ptho2601@gmail.com	t	::1	node	\N	2026-07-23 18:24:12.36438+00
db8d6365-3516-4745-9a61-957e9bbf030a	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	docong989@gmail.com	t	::1	node	\N	2026-07-24 07:22:21.558057+00
cfece4b3-c2cd-4008-a08a-22121b34a284	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	docong989@gmail.com	t	172.18.0.4	node	\N	2026-07-24 08:48:23.986121+00
820c48df-1879-4d46-80d4-def5b8f100a4	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	docong989@gmail.com	t	172.18.0.5	node	\N	2026-07-24 08:55:25.664735+00
\.


--
-- Data for Name: meter_anomaly_alert; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.meter_anomaly_alert (id, chi_so_id, phong_id, hop_dong_id, loai, ky_thang, ky_nam, tieu_thu_hien_tai, tieu_thu_trung_binh, ty_le_tang, muc_do, ly_do, trang_thai, resolved_at, resolved_by, tao_luc) FROM stdin;
\.


--
-- Data for Name: nguoi_dung; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.nguoi_dung (id, email, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, dia_chi, que_quan, so_cccd, trang_thai, so_lan_dang_nhap_sai, khoa_den_luc, lan_dang_nhap_cuoi, cau_hinh_2fa, tao_luc, cap_nhat_luc, xoa_luc, mat_khau, trang_thai_kyc, anh_cccd_truoc, anh_cccd_sau, anh_gpkd) FROM stdin;
08a8fef1-b65f-4b0d-b87f-fb883877e1db	ptho2601@gmail.com	Phùng Văn Thọ	0357165019	\N	2006-01-22	nam	\N	Hà Nội	066206004001	ACTIVE	0	\N	\N	\N	2026-07-22 13:08:59.793399+00	2026-07-22 13:10:02.484179+00	\N	$2a$10$mZIv9NEI8yQr.qp0IkwhAO6e4NgbGlGnc9Xe/hvm9omAJXotlgR8O	NONE	\N	\N	\N
e93c664c-53bc-45b6-9316-198dca1b0cbe	phts6626@gmail.com	Sơn	0336073019	\N	\N	\N	\N	\N	\N	INACTIVE	0	\N	2026-07-23 15:06:01.802971+00	\N	2026-07-23 15:05:33.799855+00	2026-07-23 15:06:01.730975+00	\N	$2a$10$hqb/3wmHzcVJ8uXpRC/e7egppvBpsUnLmKaaI99fBPUI0p8T.d9Xy	NONE	\N	\N	\N
ebc6a196-06ab-4566-84d6-1772eabf3892	tenant_0396822875@easyhouse.local	hàng thị trúc giang	0396822875	\N	\N	\N	\N	\N	066206004002	ACTIVE	0	\N	\N	\N	2026-07-23 18:55:21.858698+00	2026-07-23 18:55:21.858698+00	\N	$2a$10$jqw681aZO.dqsxfKdTqg6u./HNRw8LTdlFizc/pdXGjXNHYvavR4K	NONE	\N	\N	\N
3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	docong989@gmail.com	đỗ chí công	0369963725	\N	\N	\N	\N	\N	\N	INACTIVE	0	\N	2026-07-24 08:55:25.644667+00	\N	2026-07-22 11:16:02.050004+00	2026-07-24 08:55:25.433895+00	\N	$2a$10$eZ8mmP3SmSZii81yrlskKuq5/ZAYjeTNkRUQ140rlr9Z83ZotT7OG	NONE	\N	\N	\N
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
3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	fbac658c-ff72-46a6-9fec-84308ff3cb47	2026-07-22 11:16:02.057811+00
e93c664c-53bc-45b6-9316-198dca1b0cbe	fbac658c-ff72-46a6-9fec-84308ff3cb47	2026-07-23 15:05:33.824076+00
\.


--
-- Data for Name: nha_tro; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.nha_tro (id, chu_tro_id, ten, dia_chi, so_nha, duong, phuong, quan, thanh_pho, mo_ta, tien_nghi_chung, noi_quy, trang_thai, tao_luc, cap_nhat_luc, xoa_luc, vi_do, kinh_do, google_place_id, dia_chi_da_chuan_hoa) FROM stdin;
77d63858-dd11-436a-b31f-3739f15af084	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	Tòa Nhà Sông Đà	189 Phạm Hùng, , Quận Nam Từ Liêm, Thành phố Hà Nội	189	Phạm Hùng		Quận Nam Từ Liêm	Thành phố Hà Nội	new	camera,baoVe,giuXe,sanPhoi,nhaVeSinhChung,khuBepChung	\N	ACTIVE	2026-07-23 17:41:59.021502+00	2026-07-23 17:41:59.021502+00	\N	21.0174240	105.7805133	\N	\N
7e7978b2-8535-4d5f-851a-65960f801e95	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	Tòa Nhà FPT	13 trịnh văn bô, , Quận Nam Từ Liêm, Thành phố Hà Nội	13	trịnh văn bô		Quận Nam Từ Liêm	Thành phố Hà Nội	new 	camera,baoVe,giuXe,sanPhoi,nhaVeSinhChung,khuBepChung	\N	ACTIVE	2026-07-22 12:38:01.501086+00	2026-07-22 12:38:01.501086+00	\N	\N	\N	\N	\N
cf6edb0e-afcf-47bd-8a7b-56b09ad5140c	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	Tòa Nhà Hải Hậu	136 cầu diễn, Phường Cầu Diễn, Quận Nam Từ Liêm, Thành phố Hà Nội	136	cầu diễn	Phường Cầu Diễn	Quận Nam Từ Liêm	Thành phố Hà Nội		camera,baoVe,giuXe,sanPhoi,nhaVeSinhChung,khuBepChung	\N	ACTIVE	2026-07-23 10:05:26.410304+00	2026-07-23 10:19:34.936549+00	2026-07-23 10:19:34.938977+00	\N	\N	\N	\N
f99082a3-1c1c-44f0-a05a-25dc11fd5c46	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	Nhà Trọ Hải Dương	13 Trịnh Văn Bô, Phường Xuân Phương, Quận Nam Từ Liêm, Thành phố Hà Nội	13	Trịnh Văn Bô	Phường Xuân Phương	Quận Nam Từ Liêm	Thành phố Hà Nội	new	camera,baoVe,giuXe,sanPhoi,nhaVeSinhChung,khuBepChung	\N	ACTIVE	2026-07-23 10:33:21.017902+00	2026-07-23 10:33:21.017902+00	\N	\N	\N	\N	\N
63fe73ae-b22c-4a78-abd5-33cc79ceffbd	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	Nhà Trọ Trung Lập	136  cầu diễn, Phường Minh Khai, Quận Bắc Từ Liêm, Thành phố Hà Nội	136 	cầu diễn	Phường Minh Khai	Quận Bắc Từ Liêm	Thành phố Hà Nội	phòng new	camera,baoVe,giuXe,sanPhoi,nhaVeSinhChung,khuBepChung	\N	ACTIVE	2026-07-23 17:17:49.408982+00	2026-07-23 17:17:49.408982+00	\N	21.0496940	105.7414170	\N	\N
\.


--
-- Data for Name: phong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.phong (id, nha_tro_id, ten, khu_vuc, tang, dien_tich, so_nguoi_toi_da, trang_thai, gia_hien_tai, tien_coc_mac_dinh, mo_ta, tao_luc, cap_nhat_luc, xoa_luc, tang_id) FROM stdin;
b3d3c139-adfc-4551-a128-75d3f05e964e	7e7978b2-8535-4d5f-851a-65960f801e95	PHÒNG 101		1	25.00	4	RENTED	4000000.00	4000000.00		2026-07-22 13:13:09.537596+00	2026-07-23 10:08:04.616051+00	\N	ac1b3a81-9124-4461-8a13-3766bc1f5d72
e0303947-1bc4-4220-8194-f57007d2cf5b	f99082a3-1c1c-44f0-a05a-25dc11fd5c46	Phòng 101	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-07-23 10:33:21.013354+00	2026-07-23 10:37:21.818172+00	\N	111df5a8-4d2e-4a6c-ace6-45c9c55b5f14
69236727-8d2c-4b04-bcb1-fb2af2ff6431	f99082a3-1c1c-44f0-a05a-25dc11fd5c46	Phòng 102	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-07-23 10:33:21.013354+00	2026-07-23 10:37:21.818172+00	\N	111df5a8-4d2e-4a6c-ace6-45c9c55b5f14
f394e305-1031-4224-9ee9-a8030baa66ca	f99082a3-1c1c-44f0-a05a-25dc11fd5c46	Phòng 103	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-07-23 10:33:21.013354+00	2026-07-23 10:37:21.818172+00	\N	111df5a8-4d2e-4a6c-ace6-45c9c55b5f14
ad2c99e2-b154-4a77-a3b2-b4a2cfc26f47	f99082a3-1c1c-44f0-a05a-25dc11fd5c46	Phòng 201	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-07-23 10:33:21.013354+00	2026-07-23 10:37:21.818172+00	\N	01675501-07db-4b1d-8163-db9e3fe46ebd
8622d06f-e80a-4904-a3e4-c69ee796bce1	f99082a3-1c1c-44f0-a05a-25dc11fd5c46	Phòng 202	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-07-23 10:33:21.013354+00	2026-07-23 10:37:21.818172+00	\N	01675501-07db-4b1d-8163-db9e3fe46ebd
ecfd4423-5909-43df-bedb-83c813bdc7d7	f99082a3-1c1c-44f0-a05a-25dc11fd5c46	Phòng 203	\N	2	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-07-23 10:33:21.013354+00	2026-07-23 10:37:21.818172+00	\N	01675501-07db-4b1d-8163-db9e3fe46ebd
eb890091-f900-4817-a603-07bc58826207	f99082a3-1c1c-44f0-a05a-25dc11fd5c46	Phòng 301	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-07-23 10:33:21.013354+00	2026-07-23 10:37:21.818172+00	\N	97a24f01-e6c8-41b4-89e7-b358f797389c
2ce166dd-aeea-47d3-aeff-7bdaaab5d55f	f99082a3-1c1c-44f0-a05a-25dc11fd5c46	Phòng 302	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-07-23 10:33:21.013354+00	2026-07-23 10:37:21.818172+00	\N	97a24f01-e6c8-41b4-89e7-b358f797389c
66bd69f7-77bd-4864-a4b4-b70c281909dc	f99082a3-1c1c-44f0-a05a-25dc11fd5c46	Phòng 303	\N	3	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-07-23 10:33:21.013354+00	2026-07-23 10:37:21.818172+00	\N	97a24f01-e6c8-41b4-89e7-b358f797389c
1b7a891b-9aa6-4734-ba0a-57a36b384972	63fe73ae-b22c-4a78-abd5-33cc79ceffbd	Phòng 101	\N	1	20.00	4	AVAILABLE	4000000.00	4000000.00	\N	2026-07-23 17:17:49.402523+00	2026-07-23 17:35:37.918385+00	\N	5fde1b78-f252-4aa6-bfc8-9ac40840fd39
322e1b35-584b-4120-b63c-212651e9f275	63fe73ae-b22c-4a78-abd5-33cc79ceffbd	Phòng 102	\N	1	20.00	4	AVAILABLE	4000000.00	4000000.00	\N	2026-07-23 17:17:49.402523+00	2026-07-23 17:35:37.918385+00	\N	5fde1b78-f252-4aa6-bfc8-9ac40840fd39
c840cf15-54ad-44a6-8e64-d34eef34e47a	63fe73ae-b22c-4a78-abd5-33cc79ceffbd	Phòng 103	\N	1	20.00	4	AVAILABLE	4000000.00	4000000.00	\N	2026-07-23 17:17:49.402523+00	2026-07-23 17:35:37.918385+00	\N	5fde1b78-f252-4aa6-bfc8-9ac40840fd39
63148901-af8f-4dad-b97c-b04acd802f67	63fe73ae-b22c-4a78-abd5-33cc79ceffbd	Phòng 104	\N	1	20.00	4	AVAILABLE	4000000.00	4000000.00	\N	2026-07-23 17:17:49.402523+00	2026-07-23 17:35:37.918385+00	\N	5fde1b78-f252-4aa6-bfc8-9ac40840fd39
d22f0ff9-fab1-49f1-bdd7-b3407448822b	63fe73ae-b22c-4a78-abd5-33cc79ceffbd	Phòng 201	\N	2	20.00	4	AVAILABLE	4000000.00	4000000.00	\N	2026-07-23 17:17:49.402523+00	2026-07-23 17:35:37.918385+00	\N	bbc2fe24-2bcf-43df-b4d5-3420bc9bd4f7
671564ac-cb0f-4a30-aa08-813f274df0cc	63fe73ae-b22c-4a78-abd5-33cc79ceffbd	Phòng 202	\N	2	20.00	4	AVAILABLE	4000000.00	4000000.00	\N	2026-07-23 17:17:49.402523+00	2026-07-23 17:35:37.918385+00	\N	bbc2fe24-2bcf-43df-b4d5-3420bc9bd4f7
5b7c73c2-4da1-42c7-9fcb-8087ae8defce	63fe73ae-b22c-4a78-abd5-33cc79ceffbd	Phòng 203	\N	2	20.00	4	AVAILABLE	4000000.00	4000000.00	\N	2026-07-23 17:17:49.402523+00	2026-07-23 17:35:37.918385+00	\N	bbc2fe24-2bcf-43df-b4d5-3420bc9bd4f7
862ebcb8-0087-4703-a08e-992fec0ad6be	63fe73ae-b22c-4a78-abd5-33cc79ceffbd	Phòng 204	\N	2	20.00	4	AVAILABLE	4000000.00	4000000.00	\N	2026-07-23 17:17:49.402523+00	2026-07-23 17:35:37.918385+00	\N	bbc2fe24-2bcf-43df-b4d5-3420bc9bd4f7
a6c85880-c00a-42e3-bf80-da840d324b32	63fe73ae-b22c-4a78-abd5-33cc79ceffbd	Phòng 301	\N	3	20.00	4	AVAILABLE	4000000.00	4000000.00	\N	2026-07-23 17:17:49.402523+00	2026-07-23 17:35:37.918385+00	\N	0115b323-18a6-47ec-8e17-8d4026752daa
4978b1be-77a4-4c6c-aefa-5109b7099ce2	63fe73ae-b22c-4a78-abd5-33cc79ceffbd	Phòng 302	\N	3	20.00	4	AVAILABLE	4000000.00	4000000.00	\N	2026-07-23 17:17:49.402523+00	2026-07-23 17:35:37.918385+00	\N	0115b323-18a6-47ec-8e17-8d4026752daa
0dcf6605-e9e2-4743-9487-c07d8424b204	63fe73ae-b22c-4a78-abd5-33cc79ceffbd	Phòng 303	\N	3	20.00	4	AVAILABLE	4000000.00	4000000.00	\N	2026-07-23 17:17:49.402523+00	2026-07-23 17:35:37.918385+00	\N	0115b323-18a6-47ec-8e17-8d4026752daa
9dc96ba6-f1e7-43c2-ab81-ee6724e3a7a6	63fe73ae-b22c-4a78-abd5-33cc79ceffbd	Phòng 304	\N	3	20.00	4	AVAILABLE	4000000.00	4000000.00	\N	2026-07-23 17:17:49.402523+00	2026-07-23 17:35:37.918385+00	\N	0115b323-18a6-47ec-8e17-8d4026752daa
32410f45-ea0a-4465-a496-c4efb89014cb	77d63858-dd11-436a-b31f-3739f15af084	Phòng 101	\N	1	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	906c3e95-2072-4903-8fa0-ff200a58e27a
80b33ca1-3a8e-4b03-81b4-224b6218cf7a	77d63858-dd11-436a-b31f-3739f15af084	Phòng 102	\N	1	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	906c3e95-2072-4903-8fa0-ff200a58e27a
62689ce2-c714-4753-9bb1-26e4f5a94b5b	77d63858-dd11-436a-b31f-3739f15af084	Phòng 103	\N	1	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	906c3e95-2072-4903-8fa0-ff200a58e27a
2bcb986d-3cf0-46f1-b98a-ae8403db45f0	77d63858-dd11-436a-b31f-3739f15af084	Phòng 104	\N	1	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	906c3e95-2072-4903-8fa0-ff200a58e27a
6551a4bd-f3e5-4bba-bacb-b6b039813228	77d63858-dd11-436a-b31f-3739f15af084	Phòng 105	\N	1	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	906c3e95-2072-4903-8fa0-ff200a58e27a
79ad149a-5202-43fa-b062-f62249306c55	77d63858-dd11-436a-b31f-3739f15af084	Phòng 106	\N	1	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	906c3e95-2072-4903-8fa0-ff200a58e27a
4ed56e2f-ed2c-4767-b939-69e33b4e1fdd	77d63858-dd11-436a-b31f-3739f15af084	Phòng 107	\N	1	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	906c3e95-2072-4903-8fa0-ff200a58e27a
4eaccbdb-0a0c-4ada-8ead-71f2bb33ba65	77d63858-dd11-436a-b31f-3739f15af084	Phòng 201	\N	2	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	d410fcf9-cb4e-48cf-866b-7b93db8181a1
a768f13f-8b41-48bf-9a47-23bd8170bae7	77d63858-dd11-436a-b31f-3739f15af084	Phòng 202	\N	2	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	d410fcf9-cb4e-48cf-866b-7b93db8181a1
9e1a1c3c-e55a-4dc5-894c-3600dba515bd	77d63858-dd11-436a-b31f-3739f15af084	Phòng 203	\N	2	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	d410fcf9-cb4e-48cf-866b-7b93db8181a1
20f4a957-c65e-4948-8c10-08224efdc49c	77d63858-dd11-436a-b31f-3739f15af084	Phòng 204	\N	2	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	d410fcf9-cb4e-48cf-866b-7b93db8181a1
5d08fc02-821c-4b06-b6be-33ada8b8e03d	77d63858-dd11-436a-b31f-3739f15af084	Phòng 205	\N	2	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	d410fcf9-cb4e-48cf-866b-7b93db8181a1
7b9daa42-5a81-40c5-8fd1-237e0f0580ae	77d63858-dd11-436a-b31f-3739f15af084	Phòng 207	\N	2	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	d410fcf9-cb4e-48cf-866b-7b93db8181a1
f2815a80-55dd-406b-8d42-d1b1364c20ab	77d63858-dd11-436a-b31f-3739f15af084	Phòng 301	\N	3	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	1cf894c2-b479-4906-a4b6-1dea105e4fbd
4257c62f-4564-43b0-a017-3e5c425028a9	77d63858-dd11-436a-b31f-3739f15af084	Phòng 302	\N	3	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	1cf894c2-b479-4906-a4b6-1dea105e4fbd
df5b8b22-22cd-44d8-af1f-a6b9211275aa	77d63858-dd11-436a-b31f-3739f15af084	Phòng 303	\N	3	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	1cf894c2-b479-4906-a4b6-1dea105e4fbd
b2aa2fa4-bedd-4cab-a3cd-ef25fcd3eee0	77d63858-dd11-436a-b31f-3739f15af084	Phòng 304	\N	3	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	1cf894c2-b479-4906-a4b6-1dea105e4fbd
30a37c17-33bb-4b9c-b0ab-99302af6b391	77d63858-dd11-436a-b31f-3739f15af084	Phòng 206	\N	2	25.00	4	RENTED	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 19:09:02.839943+00	\N	d410fcf9-cb4e-48cf-866b-7b93db8181a1
85299d2e-8da2-4a5a-afbf-aa875c6f1892	77d63858-dd11-436a-b31f-3739f15af084	Phòng 305	\N	3	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	1cf894c2-b479-4906-a4b6-1dea105e4fbd
334e17c2-58ae-4f32-9065-31870d6b7eba	77d63858-dd11-436a-b31f-3739f15af084	Phòng 306	\N	3	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	1cf894c2-b479-4906-a4b6-1dea105e4fbd
45ef6ce0-2a6d-4d7e-9e86-6f4159908a07	77d63858-dd11-436a-b31f-3739f15af084	Phòng 307	\N	3	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	1cf894c2-b479-4906-a4b6-1dea105e4fbd
a13485ca-23ad-4e45-9ac2-56b1dc40f97f	77d63858-dd11-436a-b31f-3739f15af084	Phòng 401	\N	4	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	4d932fdf-eee1-40fe-a2bb-fa1c6b632478
ce7667df-c11a-4578-8b33-23cc2cff64cc	77d63858-dd11-436a-b31f-3739f15af084	Phòng 402	\N	4	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	4d932fdf-eee1-40fe-a2bb-fa1c6b632478
5ccb2a8e-b751-456a-a1b1-1022ad2ba80d	77d63858-dd11-436a-b31f-3739f15af084	Phòng 403	\N	4	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	4d932fdf-eee1-40fe-a2bb-fa1c6b632478
2f3f612f-a78c-412f-ba05-695938037e06	77d63858-dd11-436a-b31f-3739f15af084	Phòng 404	\N	4	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	4d932fdf-eee1-40fe-a2bb-fa1c6b632478
ea3cb683-a653-488a-a66d-54e08b5afb7b	77d63858-dd11-436a-b31f-3739f15af084	Phòng 405	\N	4	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	4d932fdf-eee1-40fe-a2bb-fa1c6b632478
122364da-f416-4058-94c3-d956fc2694cf	77d63858-dd11-436a-b31f-3739f15af084	Phòng 406	\N	4	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	4d932fdf-eee1-40fe-a2bb-fa1c6b632478
522285e4-029b-49b6-a089-3a527aff6a49	77d63858-dd11-436a-b31f-3739f15af084	Phòng 407	\N	4	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	4d932fdf-eee1-40fe-a2bb-fa1c6b632478
275deb63-4970-44cb-9825-8f9031c31703	77d63858-dd11-436a-b31f-3739f15af084	Phòng 501	\N	5	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	632d647b-27b3-489a-a5a9-ead90e79bfdb
680e837d-5ade-4b00-a235-2ea66c7f7665	77d63858-dd11-436a-b31f-3739f15af084	Phòng 502	\N	5	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	632d647b-27b3-489a-a5a9-ead90e79bfdb
f0124893-6eb5-46b6-8a88-d6e118b0b742	77d63858-dd11-436a-b31f-3739f15af084	Phòng 503	\N	5	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	632d647b-27b3-489a-a5a9-ead90e79bfdb
7fa38a04-0fdf-47bd-a27f-56e01fb06602	77d63858-dd11-436a-b31f-3739f15af084	Phòng 504	\N	5	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	632d647b-27b3-489a-a5a9-ead90e79bfdb
4db01bf4-dd3a-4a0c-9bec-0b0bd116a6af	77d63858-dd11-436a-b31f-3739f15af084	Phòng 505	\N	5	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	632d647b-27b3-489a-a5a9-ead90e79bfdb
c1c7027d-9286-43a5-9692-151315e0e96c	77d63858-dd11-436a-b31f-3739f15af084	Phòng 506	\N	5	25.00	4	AVAILABLE	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N	632d647b-27b3-489a-a5a9-ead90e79bfdb
399a5e5a-5a54-452a-85cd-dbf99325750b	77d63858-dd11-436a-b31f-3739f15af084	Phòng 507	\N	5	25.00	4	RENTED	3200000.00	3200000.00	\N	2026-07-23 17:41:59.01592+00	2026-07-23 19:03:07.473506+00	\N	632d647b-27b3-489a-a5a9-ead90e79bfdb
\.


--
-- Data for Name: phong_tien_ich; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.phong_tien_ich (phong_id, tien_ich_id, tao_luc) FROM stdin;
b3d3c139-adfc-4551-a128-75d3f05e964e	d189fabb-5ef1-45d9-bc97-d74800ee33b1	2026-07-23 10:19:07.231331+00
b3d3c139-adfc-4551-a128-75d3f05e964e	3453962d-2c72-44ae-be10-c25d2a47a4a1	2026-07-23 10:19:07.231331+00
b3d3c139-adfc-4551-a128-75d3f05e964e	be50ca8a-f6f4-4afb-96a8-a3fec61b1143	2026-07-23 10:19:07.231331+00
b3d3c139-adfc-4551-a128-75d3f05e964e	bdcdff77-8d7f-43c8-a1b4-6ad0ed82378b	2026-07-23 10:19:07.231331+00
b3d3c139-adfc-4551-a128-75d3f05e964e	bbe0eda5-c779-4e41-87ef-fcfbe361962a	2026-07-23 10:19:07.231331+00
b3d3c139-adfc-4551-a128-75d3f05e964e	33ba0073-4b14-45dd-b558-cf7181b67cd2	2026-07-23 10:19:07.231331+00
b3d3c139-adfc-4551-a128-75d3f05e964e	f2d646f8-8346-4876-bd43-8dd80520ccdf	2026-07-23 10:19:07.231331+00
b3d3c139-adfc-4551-a128-75d3f05e964e	87ea4a67-b1e1-4e57-9155-f004d46231e9	2026-07-23 10:19:07.231331+00
b3d3c139-adfc-4551-a128-75d3f05e964e	c2e9cc45-84ae-4a8b-8bad-2363af4133cc	2026-07-23 10:19:07.231331+00
b3d3c139-adfc-4551-a128-75d3f05e964e	626fc19b-3f55-4556-9f5f-0378efd8d6a4	2026-07-23 10:19:07.231331+00
b3d3c139-adfc-4551-a128-75d3f05e964e	fa0e247e-0e0e-4601-9340-f02017291e50	2026-07-23 10:19:07.231331+00
b3d3c139-adfc-4551-a128-75d3f05e964e	dee6c56e-a35a-41ea-8c5c-4edcdb70c2f1	2026-07-23 10:19:07.231331+00
b3d3c139-adfc-4551-a128-75d3f05e964e	48b4eb3a-e018-441d-95c6-06ce37eee8fd	2026-07-23 10:19:07.231331+00
b3d3c139-adfc-4551-a128-75d3f05e964e	aaf53ac7-7cc5-4af0-b26a-aefb64455319	2026-07-23 10:19:07.231331+00
e0303947-1bc4-4220-8194-f57007d2cf5b	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 10:33:21.013354+00
e0303947-1bc4-4220-8194-f57007d2cf5b	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 10:33:21.013354+00
e0303947-1bc4-4220-8194-f57007d2cf5b	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 10:33:21.013354+00
e0303947-1bc4-4220-8194-f57007d2cf5b	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 10:33:21.013354+00
e0303947-1bc4-4220-8194-f57007d2cf5b	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 10:33:21.013354+00
e0303947-1bc4-4220-8194-f57007d2cf5b	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 10:33:21.013354+00
e0303947-1bc4-4220-8194-f57007d2cf5b	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 10:33:21.013354+00
e0303947-1bc4-4220-8194-f57007d2cf5b	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 10:33:21.013354+00
e0303947-1bc4-4220-8194-f57007d2cf5b	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 10:33:21.013354+00
69236727-8d2c-4b04-bcb1-fb2af2ff6431	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 10:33:21.013354+00
69236727-8d2c-4b04-bcb1-fb2af2ff6431	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 10:33:21.013354+00
69236727-8d2c-4b04-bcb1-fb2af2ff6431	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 10:33:21.013354+00
69236727-8d2c-4b04-bcb1-fb2af2ff6431	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 10:33:21.013354+00
69236727-8d2c-4b04-bcb1-fb2af2ff6431	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 10:33:21.013354+00
69236727-8d2c-4b04-bcb1-fb2af2ff6431	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 10:33:21.013354+00
69236727-8d2c-4b04-bcb1-fb2af2ff6431	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 10:33:21.013354+00
69236727-8d2c-4b04-bcb1-fb2af2ff6431	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 10:33:21.013354+00
69236727-8d2c-4b04-bcb1-fb2af2ff6431	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 10:33:21.013354+00
f394e305-1031-4224-9ee9-a8030baa66ca	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 10:33:21.013354+00
f394e305-1031-4224-9ee9-a8030baa66ca	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 10:33:21.013354+00
f394e305-1031-4224-9ee9-a8030baa66ca	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 10:33:21.013354+00
f394e305-1031-4224-9ee9-a8030baa66ca	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 10:33:21.013354+00
f394e305-1031-4224-9ee9-a8030baa66ca	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 10:33:21.013354+00
f394e305-1031-4224-9ee9-a8030baa66ca	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 10:33:21.013354+00
f394e305-1031-4224-9ee9-a8030baa66ca	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 10:33:21.013354+00
f394e305-1031-4224-9ee9-a8030baa66ca	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 10:33:21.013354+00
f394e305-1031-4224-9ee9-a8030baa66ca	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 10:33:21.013354+00
ad2c99e2-b154-4a77-a3b2-b4a2cfc26f47	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 10:33:21.013354+00
ad2c99e2-b154-4a77-a3b2-b4a2cfc26f47	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 10:33:21.013354+00
ad2c99e2-b154-4a77-a3b2-b4a2cfc26f47	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 10:33:21.013354+00
ad2c99e2-b154-4a77-a3b2-b4a2cfc26f47	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 10:33:21.013354+00
ad2c99e2-b154-4a77-a3b2-b4a2cfc26f47	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 10:33:21.013354+00
ad2c99e2-b154-4a77-a3b2-b4a2cfc26f47	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 10:33:21.013354+00
ad2c99e2-b154-4a77-a3b2-b4a2cfc26f47	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 10:33:21.013354+00
ad2c99e2-b154-4a77-a3b2-b4a2cfc26f47	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 10:33:21.013354+00
ad2c99e2-b154-4a77-a3b2-b4a2cfc26f47	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 10:33:21.013354+00
8622d06f-e80a-4904-a3e4-c69ee796bce1	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 10:33:21.013354+00
8622d06f-e80a-4904-a3e4-c69ee796bce1	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 10:33:21.013354+00
8622d06f-e80a-4904-a3e4-c69ee796bce1	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 10:33:21.013354+00
8622d06f-e80a-4904-a3e4-c69ee796bce1	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 10:33:21.013354+00
8622d06f-e80a-4904-a3e4-c69ee796bce1	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 10:33:21.013354+00
8622d06f-e80a-4904-a3e4-c69ee796bce1	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 10:33:21.013354+00
8622d06f-e80a-4904-a3e4-c69ee796bce1	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 10:33:21.013354+00
8622d06f-e80a-4904-a3e4-c69ee796bce1	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 10:33:21.013354+00
8622d06f-e80a-4904-a3e4-c69ee796bce1	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 10:33:21.013354+00
ecfd4423-5909-43df-bedb-83c813bdc7d7	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 10:33:21.013354+00
ecfd4423-5909-43df-bedb-83c813bdc7d7	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 10:33:21.013354+00
ecfd4423-5909-43df-bedb-83c813bdc7d7	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 10:33:21.013354+00
ecfd4423-5909-43df-bedb-83c813bdc7d7	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 10:33:21.013354+00
ecfd4423-5909-43df-bedb-83c813bdc7d7	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 10:33:21.013354+00
ecfd4423-5909-43df-bedb-83c813bdc7d7	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 10:33:21.013354+00
ecfd4423-5909-43df-bedb-83c813bdc7d7	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 10:33:21.013354+00
ecfd4423-5909-43df-bedb-83c813bdc7d7	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 10:33:21.013354+00
ecfd4423-5909-43df-bedb-83c813bdc7d7	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 10:33:21.013354+00
eb890091-f900-4817-a603-07bc58826207	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 10:33:21.013354+00
eb890091-f900-4817-a603-07bc58826207	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 10:33:21.013354+00
eb890091-f900-4817-a603-07bc58826207	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 10:33:21.013354+00
eb890091-f900-4817-a603-07bc58826207	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 10:33:21.013354+00
eb890091-f900-4817-a603-07bc58826207	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 10:33:21.013354+00
eb890091-f900-4817-a603-07bc58826207	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 10:33:21.013354+00
eb890091-f900-4817-a603-07bc58826207	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 10:33:21.013354+00
eb890091-f900-4817-a603-07bc58826207	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 10:33:21.013354+00
eb890091-f900-4817-a603-07bc58826207	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 10:33:21.013354+00
2ce166dd-aeea-47d3-aeff-7bdaaab5d55f	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 10:33:21.013354+00
2ce166dd-aeea-47d3-aeff-7bdaaab5d55f	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 10:33:21.013354+00
2ce166dd-aeea-47d3-aeff-7bdaaab5d55f	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 10:33:21.013354+00
2ce166dd-aeea-47d3-aeff-7bdaaab5d55f	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 10:33:21.013354+00
2ce166dd-aeea-47d3-aeff-7bdaaab5d55f	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 10:33:21.013354+00
2ce166dd-aeea-47d3-aeff-7bdaaab5d55f	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 10:33:21.013354+00
2ce166dd-aeea-47d3-aeff-7bdaaab5d55f	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 10:33:21.013354+00
2ce166dd-aeea-47d3-aeff-7bdaaab5d55f	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 10:33:21.013354+00
2ce166dd-aeea-47d3-aeff-7bdaaab5d55f	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 10:33:21.013354+00
66bd69f7-77bd-4864-a4b4-b70c281909dc	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 10:33:21.013354+00
66bd69f7-77bd-4864-a4b4-b70c281909dc	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 10:33:21.013354+00
66bd69f7-77bd-4864-a4b4-b70c281909dc	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 10:33:21.013354+00
66bd69f7-77bd-4864-a4b4-b70c281909dc	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 10:33:21.013354+00
66bd69f7-77bd-4864-a4b4-b70c281909dc	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 10:33:21.013354+00
66bd69f7-77bd-4864-a4b4-b70c281909dc	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 10:33:21.013354+00
66bd69f7-77bd-4864-a4b4-b70c281909dc	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 10:33:21.013354+00
66bd69f7-77bd-4864-a4b4-b70c281909dc	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 10:33:21.013354+00
66bd69f7-77bd-4864-a4b4-b70c281909dc	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 10:33:21.013354+00
1b7a891b-9aa6-4734-ba0a-57a36b384972	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:17:49.402523+00
1b7a891b-9aa6-4734-ba0a-57a36b384972	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:17:49.402523+00
1b7a891b-9aa6-4734-ba0a-57a36b384972	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:17:49.402523+00
1b7a891b-9aa6-4734-ba0a-57a36b384972	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:17:49.402523+00
1b7a891b-9aa6-4734-ba0a-57a36b384972	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:17:49.402523+00
1b7a891b-9aa6-4734-ba0a-57a36b384972	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:17:49.402523+00
1b7a891b-9aa6-4734-ba0a-57a36b384972	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:17:49.402523+00
1b7a891b-9aa6-4734-ba0a-57a36b384972	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:17:49.402523+00
1b7a891b-9aa6-4734-ba0a-57a36b384972	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:17:49.402523+00
322e1b35-584b-4120-b63c-212651e9f275	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:17:49.402523+00
322e1b35-584b-4120-b63c-212651e9f275	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:17:49.402523+00
322e1b35-584b-4120-b63c-212651e9f275	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:17:49.402523+00
322e1b35-584b-4120-b63c-212651e9f275	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:17:49.402523+00
322e1b35-584b-4120-b63c-212651e9f275	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:17:49.402523+00
322e1b35-584b-4120-b63c-212651e9f275	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:17:49.402523+00
322e1b35-584b-4120-b63c-212651e9f275	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:17:49.402523+00
322e1b35-584b-4120-b63c-212651e9f275	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:17:49.402523+00
322e1b35-584b-4120-b63c-212651e9f275	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:17:49.402523+00
c840cf15-54ad-44a6-8e64-d34eef34e47a	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:17:49.402523+00
c840cf15-54ad-44a6-8e64-d34eef34e47a	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:17:49.402523+00
c840cf15-54ad-44a6-8e64-d34eef34e47a	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:17:49.402523+00
c840cf15-54ad-44a6-8e64-d34eef34e47a	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:17:49.402523+00
c840cf15-54ad-44a6-8e64-d34eef34e47a	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:17:49.402523+00
c840cf15-54ad-44a6-8e64-d34eef34e47a	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:17:49.402523+00
c840cf15-54ad-44a6-8e64-d34eef34e47a	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:17:49.402523+00
c840cf15-54ad-44a6-8e64-d34eef34e47a	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:17:49.402523+00
c840cf15-54ad-44a6-8e64-d34eef34e47a	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:17:49.402523+00
63148901-af8f-4dad-b97c-b04acd802f67	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:17:49.402523+00
63148901-af8f-4dad-b97c-b04acd802f67	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:17:49.402523+00
63148901-af8f-4dad-b97c-b04acd802f67	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:17:49.402523+00
63148901-af8f-4dad-b97c-b04acd802f67	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:17:49.402523+00
63148901-af8f-4dad-b97c-b04acd802f67	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:17:49.402523+00
63148901-af8f-4dad-b97c-b04acd802f67	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:17:49.402523+00
63148901-af8f-4dad-b97c-b04acd802f67	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:17:49.402523+00
63148901-af8f-4dad-b97c-b04acd802f67	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:17:49.402523+00
63148901-af8f-4dad-b97c-b04acd802f67	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:17:49.402523+00
d22f0ff9-fab1-49f1-bdd7-b3407448822b	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:17:49.402523+00
d22f0ff9-fab1-49f1-bdd7-b3407448822b	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:17:49.402523+00
d22f0ff9-fab1-49f1-bdd7-b3407448822b	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:17:49.402523+00
d22f0ff9-fab1-49f1-bdd7-b3407448822b	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:17:49.402523+00
d22f0ff9-fab1-49f1-bdd7-b3407448822b	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:17:49.402523+00
d22f0ff9-fab1-49f1-bdd7-b3407448822b	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:17:49.402523+00
d22f0ff9-fab1-49f1-bdd7-b3407448822b	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:17:49.402523+00
d22f0ff9-fab1-49f1-bdd7-b3407448822b	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:17:49.402523+00
d22f0ff9-fab1-49f1-bdd7-b3407448822b	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:17:49.402523+00
671564ac-cb0f-4a30-aa08-813f274df0cc	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:17:49.402523+00
671564ac-cb0f-4a30-aa08-813f274df0cc	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:17:49.402523+00
671564ac-cb0f-4a30-aa08-813f274df0cc	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:17:49.402523+00
671564ac-cb0f-4a30-aa08-813f274df0cc	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:17:49.402523+00
671564ac-cb0f-4a30-aa08-813f274df0cc	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:17:49.402523+00
671564ac-cb0f-4a30-aa08-813f274df0cc	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:17:49.402523+00
671564ac-cb0f-4a30-aa08-813f274df0cc	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:17:49.402523+00
671564ac-cb0f-4a30-aa08-813f274df0cc	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:17:49.402523+00
671564ac-cb0f-4a30-aa08-813f274df0cc	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:17:49.402523+00
5b7c73c2-4da1-42c7-9fcb-8087ae8defce	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:17:49.402523+00
5b7c73c2-4da1-42c7-9fcb-8087ae8defce	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:17:49.402523+00
5b7c73c2-4da1-42c7-9fcb-8087ae8defce	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:17:49.402523+00
5b7c73c2-4da1-42c7-9fcb-8087ae8defce	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:17:49.402523+00
5b7c73c2-4da1-42c7-9fcb-8087ae8defce	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:17:49.402523+00
5b7c73c2-4da1-42c7-9fcb-8087ae8defce	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:17:49.402523+00
5b7c73c2-4da1-42c7-9fcb-8087ae8defce	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:17:49.402523+00
5b7c73c2-4da1-42c7-9fcb-8087ae8defce	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:17:49.402523+00
5b7c73c2-4da1-42c7-9fcb-8087ae8defce	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:17:49.402523+00
862ebcb8-0087-4703-a08e-992fec0ad6be	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:17:49.402523+00
862ebcb8-0087-4703-a08e-992fec0ad6be	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:17:49.402523+00
862ebcb8-0087-4703-a08e-992fec0ad6be	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:17:49.402523+00
862ebcb8-0087-4703-a08e-992fec0ad6be	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:17:49.402523+00
862ebcb8-0087-4703-a08e-992fec0ad6be	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:17:49.402523+00
862ebcb8-0087-4703-a08e-992fec0ad6be	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:17:49.402523+00
862ebcb8-0087-4703-a08e-992fec0ad6be	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:17:49.402523+00
862ebcb8-0087-4703-a08e-992fec0ad6be	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:17:49.402523+00
862ebcb8-0087-4703-a08e-992fec0ad6be	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:17:49.402523+00
a6c85880-c00a-42e3-bf80-da840d324b32	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:17:49.402523+00
a6c85880-c00a-42e3-bf80-da840d324b32	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:17:49.402523+00
a6c85880-c00a-42e3-bf80-da840d324b32	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:17:49.402523+00
a6c85880-c00a-42e3-bf80-da840d324b32	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:17:49.402523+00
a6c85880-c00a-42e3-bf80-da840d324b32	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:17:49.402523+00
a6c85880-c00a-42e3-bf80-da840d324b32	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:17:49.402523+00
a6c85880-c00a-42e3-bf80-da840d324b32	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:17:49.402523+00
a6c85880-c00a-42e3-bf80-da840d324b32	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:17:49.402523+00
a6c85880-c00a-42e3-bf80-da840d324b32	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:17:49.402523+00
4978b1be-77a4-4c6c-aefa-5109b7099ce2	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:17:49.402523+00
4978b1be-77a4-4c6c-aefa-5109b7099ce2	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:17:49.402523+00
4978b1be-77a4-4c6c-aefa-5109b7099ce2	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:17:49.402523+00
4978b1be-77a4-4c6c-aefa-5109b7099ce2	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:17:49.402523+00
4978b1be-77a4-4c6c-aefa-5109b7099ce2	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:17:49.402523+00
4978b1be-77a4-4c6c-aefa-5109b7099ce2	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:17:49.402523+00
4978b1be-77a4-4c6c-aefa-5109b7099ce2	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:17:49.402523+00
4978b1be-77a4-4c6c-aefa-5109b7099ce2	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:17:49.402523+00
4978b1be-77a4-4c6c-aefa-5109b7099ce2	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:17:49.402523+00
0dcf6605-e9e2-4743-9487-c07d8424b204	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:17:49.402523+00
0dcf6605-e9e2-4743-9487-c07d8424b204	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:17:49.402523+00
0dcf6605-e9e2-4743-9487-c07d8424b204	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:17:49.402523+00
0dcf6605-e9e2-4743-9487-c07d8424b204	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:17:49.402523+00
0dcf6605-e9e2-4743-9487-c07d8424b204	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:17:49.402523+00
0dcf6605-e9e2-4743-9487-c07d8424b204	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:17:49.402523+00
0dcf6605-e9e2-4743-9487-c07d8424b204	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:17:49.402523+00
0dcf6605-e9e2-4743-9487-c07d8424b204	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:17:49.402523+00
0dcf6605-e9e2-4743-9487-c07d8424b204	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:17:49.402523+00
9dc96ba6-f1e7-43c2-ab81-ee6724e3a7a6	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:17:49.402523+00
9dc96ba6-f1e7-43c2-ab81-ee6724e3a7a6	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:17:49.402523+00
9dc96ba6-f1e7-43c2-ab81-ee6724e3a7a6	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:17:49.402523+00
9dc96ba6-f1e7-43c2-ab81-ee6724e3a7a6	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:17:49.402523+00
9dc96ba6-f1e7-43c2-ab81-ee6724e3a7a6	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:17:49.402523+00
9dc96ba6-f1e7-43c2-ab81-ee6724e3a7a6	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:17:49.402523+00
9dc96ba6-f1e7-43c2-ab81-ee6724e3a7a6	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:17:49.402523+00
9dc96ba6-f1e7-43c2-ab81-ee6724e3a7a6	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:17:49.402523+00
9dc96ba6-f1e7-43c2-ab81-ee6724e3a7a6	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:17:49.402523+00
32410f45-ea0a-4465-a496-c4efb89014cb	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
32410f45-ea0a-4465-a496-c4efb89014cb	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
32410f45-ea0a-4465-a496-c4efb89014cb	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
32410f45-ea0a-4465-a496-c4efb89014cb	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
32410f45-ea0a-4465-a496-c4efb89014cb	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
32410f45-ea0a-4465-a496-c4efb89014cb	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
32410f45-ea0a-4465-a496-c4efb89014cb	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
32410f45-ea0a-4465-a496-c4efb89014cb	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
32410f45-ea0a-4465-a496-c4efb89014cb	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
80b33ca1-3a8e-4b03-81b4-224b6218cf7a	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
80b33ca1-3a8e-4b03-81b4-224b6218cf7a	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
80b33ca1-3a8e-4b03-81b4-224b6218cf7a	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
80b33ca1-3a8e-4b03-81b4-224b6218cf7a	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
80b33ca1-3a8e-4b03-81b4-224b6218cf7a	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
80b33ca1-3a8e-4b03-81b4-224b6218cf7a	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
80b33ca1-3a8e-4b03-81b4-224b6218cf7a	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
80b33ca1-3a8e-4b03-81b4-224b6218cf7a	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
80b33ca1-3a8e-4b03-81b4-224b6218cf7a	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
62689ce2-c714-4753-9bb1-26e4f5a94b5b	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
62689ce2-c714-4753-9bb1-26e4f5a94b5b	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
62689ce2-c714-4753-9bb1-26e4f5a94b5b	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
62689ce2-c714-4753-9bb1-26e4f5a94b5b	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
62689ce2-c714-4753-9bb1-26e4f5a94b5b	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
62689ce2-c714-4753-9bb1-26e4f5a94b5b	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
62689ce2-c714-4753-9bb1-26e4f5a94b5b	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
62689ce2-c714-4753-9bb1-26e4f5a94b5b	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
62689ce2-c714-4753-9bb1-26e4f5a94b5b	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
2bcb986d-3cf0-46f1-b98a-ae8403db45f0	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
2bcb986d-3cf0-46f1-b98a-ae8403db45f0	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
2bcb986d-3cf0-46f1-b98a-ae8403db45f0	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
2bcb986d-3cf0-46f1-b98a-ae8403db45f0	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
2bcb986d-3cf0-46f1-b98a-ae8403db45f0	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
2bcb986d-3cf0-46f1-b98a-ae8403db45f0	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
2bcb986d-3cf0-46f1-b98a-ae8403db45f0	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
2bcb986d-3cf0-46f1-b98a-ae8403db45f0	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
2bcb986d-3cf0-46f1-b98a-ae8403db45f0	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
6551a4bd-f3e5-4bba-bacb-b6b039813228	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
6551a4bd-f3e5-4bba-bacb-b6b039813228	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
6551a4bd-f3e5-4bba-bacb-b6b039813228	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
6551a4bd-f3e5-4bba-bacb-b6b039813228	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
6551a4bd-f3e5-4bba-bacb-b6b039813228	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
6551a4bd-f3e5-4bba-bacb-b6b039813228	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
6551a4bd-f3e5-4bba-bacb-b6b039813228	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
6551a4bd-f3e5-4bba-bacb-b6b039813228	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
6551a4bd-f3e5-4bba-bacb-b6b039813228	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
79ad149a-5202-43fa-b062-f62249306c55	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
79ad149a-5202-43fa-b062-f62249306c55	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
79ad149a-5202-43fa-b062-f62249306c55	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
79ad149a-5202-43fa-b062-f62249306c55	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
79ad149a-5202-43fa-b062-f62249306c55	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
79ad149a-5202-43fa-b062-f62249306c55	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
79ad149a-5202-43fa-b062-f62249306c55	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
79ad149a-5202-43fa-b062-f62249306c55	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
79ad149a-5202-43fa-b062-f62249306c55	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
4ed56e2f-ed2c-4767-b939-69e33b4e1fdd	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
4ed56e2f-ed2c-4767-b939-69e33b4e1fdd	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
4ed56e2f-ed2c-4767-b939-69e33b4e1fdd	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
4ed56e2f-ed2c-4767-b939-69e33b4e1fdd	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
4ed56e2f-ed2c-4767-b939-69e33b4e1fdd	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
4ed56e2f-ed2c-4767-b939-69e33b4e1fdd	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
4ed56e2f-ed2c-4767-b939-69e33b4e1fdd	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
4ed56e2f-ed2c-4767-b939-69e33b4e1fdd	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
4ed56e2f-ed2c-4767-b939-69e33b4e1fdd	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
4eaccbdb-0a0c-4ada-8ead-71f2bb33ba65	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
4eaccbdb-0a0c-4ada-8ead-71f2bb33ba65	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
4eaccbdb-0a0c-4ada-8ead-71f2bb33ba65	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
4eaccbdb-0a0c-4ada-8ead-71f2bb33ba65	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
4eaccbdb-0a0c-4ada-8ead-71f2bb33ba65	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
4eaccbdb-0a0c-4ada-8ead-71f2bb33ba65	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
4eaccbdb-0a0c-4ada-8ead-71f2bb33ba65	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
4eaccbdb-0a0c-4ada-8ead-71f2bb33ba65	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
4eaccbdb-0a0c-4ada-8ead-71f2bb33ba65	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
a768f13f-8b41-48bf-9a47-23bd8170bae7	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
a768f13f-8b41-48bf-9a47-23bd8170bae7	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
a768f13f-8b41-48bf-9a47-23bd8170bae7	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
a768f13f-8b41-48bf-9a47-23bd8170bae7	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
a768f13f-8b41-48bf-9a47-23bd8170bae7	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
a768f13f-8b41-48bf-9a47-23bd8170bae7	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
a768f13f-8b41-48bf-9a47-23bd8170bae7	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
a768f13f-8b41-48bf-9a47-23bd8170bae7	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
a768f13f-8b41-48bf-9a47-23bd8170bae7	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
9e1a1c3c-e55a-4dc5-894c-3600dba515bd	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
9e1a1c3c-e55a-4dc5-894c-3600dba515bd	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
9e1a1c3c-e55a-4dc5-894c-3600dba515bd	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
9e1a1c3c-e55a-4dc5-894c-3600dba515bd	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
9e1a1c3c-e55a-4dc5-894c-3600dba515bd	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
9e1a1c3c-e55a-4dc5-894c-3600dba515bd	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
9e1a1c3c-e55a-4dc5-894c-3600dba515bd	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
9e1a1c3c-e55a-4dc5-894c-3600dba515bd	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
9e1a1c3c-e55a-4dc5-894c-3600dba515bd	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
20f4a957-c65e-4948-8c10-08224efdc49c	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
20f4a957-c65e-4948-8c10-08224efdc49c	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
20f4a957-c65e-4948-8c10-08224efdc49c	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
20f4a957-c65e-4948-8c10-08224efdc49c	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
20f4a957-c65e-4948-8c10-08224efdc49c	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
20f4a957-c65e-4948-8c10-08224efdc49c	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
20f4a957-c65e-4948-8c10-08224efdc49c	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
20f4a957-c65e-4948-8c10-08224efdc49c	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
20f4a957-c65e-4948-8c10-08224efdc49c	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
5d08fc02-821c-4b06-b6be-33ada8b8e03d	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
5d08fc02-821c-4b06-b6be-33ada8b8e03d	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
5d08fc02-821c-4b06-b6be-33ada8b8e03d	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
5d08fc02-821c-4b06-b6be-33ada8b8e03d	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
5d08fc02-821c-4b06-b6be-33ada8b8e03d	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
5d08fc02-821c-4b06-b6be-33ada8b8e03d	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
5d08fc02-821c-4b06-b6be-33ada8b8e03d	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
5d08fc02-821c-4b06-b6be-33ada8b8e03d	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
5d08fc02-821c-4b06-b6be-33ada8b8e03d	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
30a37c17-33bb-4b9c-b0ab-99302af6b391	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
30a37c17-33bb-4b9c-b0ab-99302af6b391	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
30a37c17-33bb-4b9c-b0ab-99302af6b391	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
30a37c17-33bb-4b9c-b0ab-99302af6b391	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
30a37c17-33bb-4b9c-b0ab-99302af6b391	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
30a37c17-33bb-4b9c-b0ab-99302af6b391	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
30a37c17-33bb-4b9c-b0ab-99302af6b391	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
30a37c17-33bb-4b9c-b0ab-99302af6b391	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
30a37c17-33bb-4b9c-b0ab-99302af6b391	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
7b9daa42-5a81-40c5-8fd1-237e0f0580ae	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
7b9daa42-5a81-40c5-8fd1-237e0f0580ae	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
7b9daa42-5a81-40c5-8fd1-237e0f0580ae	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
7b9daa42-5a81-40c5-8fd1-237e0f0580ae	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
7b9daa42-5a81-40c5-8fd1-237e0f0580ae	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
7b9daa42-5a81-40c5-8fd1-237e0f0580ae	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
7b9daa42-5a81-40c5-8fd1-237e0f0580ae	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
7b9daa42-5a81-40c5-8fd1-237e0f0580ae	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
7b9daa42-5a81-40c5-8fd1-237e0f0580ae	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
f2815a80-55dd-406b-8d42-d1b1364c20ab	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
f2815a80-55dd-406b-8d42-d1b1364c20ab	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
f2815a80-55dd-406b-8d42-d1b1364c20ab	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
f2815a80-55dd-406b-8d42-d1b1364c20ab	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
f2815a80-55dd-406b-8d42-d1b1364c20ab	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
f2815a80-55dd-406b-8d42-d1b1364c20ab	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
f2815a80-55dd-406b-8d42-d1b1364c20ab	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
f2815a80-55dd-406b-8d42-d1b1364c20ab	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
f2815a80-55dd-406b-8d42-d1b1364c20ab	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
4257c62f-4564-43b0-a017-3e5c425028a9	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
4257c62f-4564-43b0-a017-3e5c425028a9	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
4257c62f-4564-43b0-a017-3e5c425028a9	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
4257c62f-4564-43b0-a017-3e5c425028a9	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
4257c62f-4564-43b0-a017-3e5c425028a9	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
4257c62f-4564-43b0-a017-3e5c425028a9	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
4257c62f-4564-43b0-a017-3e5c425028a9	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
4257c62f-4564-43b0-a017-3e5c425028a9	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
4257c62f-4564-43b0-a017-3e5c425028a9	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
df5b8b22-22cd-44d8-af1f-a6b9211275aa	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
df5b8b22-22cd-44d8-af1f-a6b9211275aa	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
df5b8b22-22cd-44d8-af1f-a6b9211275aa	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
df5b8b22-22cd-44d8-af1f-a6b9211275aa	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
df5b8b22-22cd-44d8-af1f-a6b9211275aa	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
df5b8b22-22cd-44d8-af1f-a6b9211275aa	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
df5b8b22-22cd-44d8-af1f-a6b9211275aa	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
df5b8b22-22cd-44d8-af1f-a6b9211275aa	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
df5b8b22-22cd-44d8-af1f-a6b9211275aa	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
b2aa2fa4-bedd-4cab-a3cd-ef25fcd3eee0	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
b2aa2fa4-bedd-4cab-a3cd-ef25fcd3eee0	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
b2aa2fa4-bedd-4cab-a3cd-ef25fcd3eee0	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
b2aa2fa4-bedd-4cab-a3cd-ef25fcd3eee0	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
b2aa2fa4-bedd-4cab-a3cd-ef25fcd3eee0	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
b2aa2fa4-bedd-4cab-a3cd-ef25fcd3eee0	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
b2aa2fa4-bedd-4cab-a3cd-ef25fcd3eee0	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
b2aa2fa4-bedd-4cab-a3cd-ef25fcd3eee0	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
b2aa2fa4-bedd-4cab-a3cd-ef25fcd3eee0	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
85299d2e-8da2-4a5a-afbf-aa875c6f1892	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
85299d2e-8da2-4a5a-afbf-aa875c6f1892	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
85299d2e-8da2-4a5a-afbf-aa875c6f1892	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
85299d2e-8da2-4a5a-afbf-aa875c6f1892	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
85299d2e-8da2-4a5a-afbf-aa875c6f1892	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
85299d2e-8da2-4a5a-afbf-aa875c6f1892	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
85299d2e-8da2-4a5a-afbf-aa875c6f1892	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
85299d2e-8da2-4a5a-afbf-aa875c6f1892	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
85299d2e-8da2-4a5a-afbf-aa875c6f1892	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
334e17c2-58ae-4f32-9065-31870d6b7eba	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
334e17c2-58ae-4f32-9065-31870d6b7eba	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
334e17c2-58ae-4f32-9065-31870d6b7eba	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
334e17c2-58ae-4f32-9065-31870d6b7eba	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
334e17c2-58ae-4f32-9065-31870d6b7eba	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
334e17c2-58ae-4f32-9065-31870d6b7eba	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
334e17c2-58ae-4f32-9065-31870d6b7eba	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
334e17c2-58ae-4f32-9065-31870d6b7eba	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
334e17c2-58ae-4f32-9065-31870d6b7eba	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
45ef6ce0-2a6d-4d7e-9e86-6f4159908a07	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
45ef6ce0-2a6d-4d7e-9e86-6f4159908a07	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
45ef6ce0-2a6d-4d7e-9e86-6f4159908a07	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
45ef6ce0-2a6d-4d7e-9e86-6f4159908a07	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
45ef6ce0-2a6d-4d7e-9e86-6f4159908a07	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
45ef6ce0-2a6d-4d7e-9e86-6f4159908a07	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
45ef6ce0-2a6d-4d7e-9e86-6f4159908a07	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
45ef6ce0-2a6d-4d7e-9e86-6f4159908a07	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
45ef6ce0-2a6d-4d7e-9e86-6f4159908a07	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
a13485ca-23ad-4e45-9ac2-56b1dc40f97f	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
a13485ca-23ad-4e45-9ac2-56b1dc40f97f	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
a13485ca-23ad-4e45-9ac2-56b1dc40f97f	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
a13485ca-23ad-4e45-9ac2-56b1dc40f97f	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
a13485ca-23ad-4e45-9ac2-56b1dc40f97f	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
a13485ca-23ad-4e45-9ac2-56b1dc40f97f	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
a13485ca-23ad-4e45-9ac2-56b1dc40f97f	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
a13485ca-23ad-4e45-9ac2-56b1dc40f97f	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
a13485ca-23ad-4e45-9ac2-56b1dc40f97f	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
ce7667df-c11a-4578-8b33-23cc2cff64cc	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
ce7667df-c11a-4578-8b33-23cc2cff64cc	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
ce7667df-c11a-4578-8b33-23cc2cff64cc	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
ce7667df-c11a-4578-8b33-23cc2cff64cc	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
ce7667df-c11a-4578-8b33-23cc2cff64cc	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
ce7667df-c11a-4578-8b33-23cc2cff64cc	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
ce7667df-c11a-4578-8b33-23cc2cff64cc	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
ce7667df-c11a-4578-8b33-23cc2cff64cc	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
ce7667df-c11a-4578-8b33-23cc2cff64cc	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
5ccb2a8e-b751-456a-a1b1-1022ad2ba80d	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
5ccb2a8e-b751-456a-a1b1-1022ad2ba80d	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
5ccb2a8e-b751-456a-a1b1-1022ad2ba80d	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
5ccb2a8e-b751-456a-a1b1-1022ad2ba80d	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
5ccb2a8e-b751-456a-a1b1-1022ad2ba80d	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
5ccb2a8e-b751-456a-a1b1-1022ad2ba80d	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
5ccb2a8e-b751-456a-a1b1-1022ad2ba80d	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
5ccb2a8e-b751-456a-a1b1-1022ad2ba80d	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
5ccb2a8e-b751-456a-a1b1-1022ad2ba80d	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
2f3f612f-a78c-412f-ba05-695938037e06	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
2f3f612f-a78c-412f-ba05-695938037e06	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
2f3f612f-a78c-412f-ba05-695938037e06	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
2f3f612f-a78c-412f-ba05-695938037e06	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
2f3f612f-a78c-412f-ba05-695938037e06	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
2f3f612f-a78c-412f-ba05-695938037e06	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
2f3f612f-a78c-412f-ba05-695938037e06	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
2f3f612f-a78c-412f-ba05-695938037e06	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
2f3f612f-a78c-412f-ba05-695938037e06	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
ea3cb683-a653-488a-a66d-54e08b5afb7b	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
ea3cb683-a653-488a-a66d-54e08b5afb7b	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
ea3cb683-a653-488a-a66d-54e08b5afb7b	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
ea3cb683-a653-488a-a66d-54e08b5afb7b	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
ea3cb683-a653-488a-a66d-54e08b5afb7b	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
ea3cb683-a653-488a-a66d-54e08b5afb7b	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
ea3cb683-a653-488a-a66d-54e08b5afb7b	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
ea3cb683-a653-488a-a66d-54e08b5afb7b	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
ea3cb683-a653-488a-a66d-54e08b5afb7b	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
122364da-f416-4058-94c3-d956fc2694cf	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
122364da-f416-4058-94c3-d956fc2694cf	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
122364da-f416-4058-94c3-d956fc2694cf	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
122364da-f416-4058-94c3-d956fc2694cf	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
122364da-f416-4058-94c3-d956fc2694cf	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
122364da-f416-4058-94c3-d956fc2694cf	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
122364da-f416-4058-94c3-d956fc2694cf	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
122364da-f416-4058-94c3-d956fc2694cf	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
122364da-f416-4058-94c3-d956fc2694cf	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
522285e4-029b-49b6-a089-3a527aff6a49	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
522285e4-029b-49b6-a089-3a527aff6a49	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
522285e4-029b-49b6-a089-3a527aff6a49	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
522285e4-029b-49b6-a089-3a527aff6a49	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
522285e4-029b-49b6-a089-3a527aff6a49	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
522285e4-029b-49b6-a089-3a527aff6a49	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
522285e4-029b-49b6-a089-3a527aff6a49	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
522285e4-029b-49b6-a089-3a527aff6a49	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
522285e4-029b-49b6-a089-3a527aff6a49	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
275deb63-4970-44cb-9825-8f9031c31703	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
275deb63-4970-44cb-9825-8f9031c31703	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
275deb63-4970-44cb-9825-8f9031c31703	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
275deb63-4970-44cb-9825-8f9031c31703	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
275deb63-4970-44cb-9825-8f9031c31703	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
275deb63-4970-44cb-9825-8f9031c31703	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
275deb63-4970-44cb-9825-8f9031c31703	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
275deb63-4970-44cb-9825-8f9031c31703	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
275deb63-4970-44cb-9825-8f9031c31703	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
680e837d-5ade-4b00-a235-2ea66c7f7665	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
680e837d-5ade-4b00-a235-2ea66c7f7665	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
680e837d-5ade-4b00-a235-2ea66c7f7665	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
680e837d-5ade-4b00-a235-2ea66c7f7665	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
680e837d-5ade-4b00-a235-2ea66c7f7665	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
680e837d-5ade-4b00-a235-2ea66c7f7665	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
680e837d-5ade-4b00-a235-2ea66c7f7665	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
680e837d-5ade-4b00-a235-2ea66c7f7665	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
680e837d-5ade-4b00-a235-2ea66c7f7665	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
f0124893-6eb5-46b6-8a88-d6e118b0b742	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
f0124893-6eb5-46b6-8a88-d6e118b0b742	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
f0124893-6eb5-46b6-8a88-d6e118b0b742	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
f0124893-6eb5-46b6-8a88-d6e118b0b742	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
f0124893-6eb5-46b6-8a88-d6e118b0b742	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
f0124893-6eb5-46b6-8a88-d6e118b0b742	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
f0124893-6eb5-46b6-8a88-d6e118b0b742	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
f0124893-6eb5-46b6-8a88-d6e118b0b742	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
f0124893-6eb5-46b6-8a88-d6e118b0b742	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
7fa38a04-0fdf-47bd-a27f-56e01fb06602	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
7fa38a04-0fdf-47bd-a27f-56e01fb06602	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
7fa38a04-0fdf-47bd-a27f-56e01fb06602	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
7fa38a04-0fdf-47bd-a27f-56e01fb06602	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
7fa38a04-0fdf-47bd-a27f-56e01fb06602	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
7fa38a04-0fdf-47bd-a27f-56e01fb06602	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
7fa38a04-0fdf-47bd-a27f-56e01fb06602	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
7fa38a04-0fdf-47bd-a27f-56e01fb06602	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
7fa38a04-0fdf-47bd-a27f-56e01fb06602	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
4db01bf4-dd3a-4a0c-9bec-0b0bd116a6af	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
4db01bf4-dd3a-4a0c-9bec-0b0bd116a6af	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
4db01bf4-dd3a-4a0c-9bec-0b0bd116a6af	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
4db01bf4-dd3a-4a0c-9bec-0b0bd116a6af	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
4db01bf4-dd3a-4a0c-9bec-0b0bd116a6af	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
4db01bf4-dd3a-4a0c-9bec-0b0bd116a6af	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
4db01bf4-dd3a-4a0c-9bec-0b0bd116a6af	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
4db01bf4-dd3a-4a0c-9bec-0b0bd116a6af	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
4db01bf4-dd3a-4a0c-9bec-0b0bd116a6af	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
c1c7027d-9286-43a5-9692-151315e0e96c	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
c1c7027d-9286-43a5-9692-151315e0e96c	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
c1c7027d-9286-43a5-9692-151315e0e96c	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
c1c7027d-9286-43a5-9692-151315e0e96c	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
c1c7027d-9286-43a5-9692-151315e0e96c	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
c1c7027d-9286-43a5-9692-151315e0e96c	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
c1c7027d-9286-43a5-9692-151315e0e96c	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
c1c7027d-9286-43a5-9692-151315e0e96c	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
c1c7027d-9286-43a5-9692-151315e0e96c	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
399a5e5a-5a54-452a-85cd-dbf99325750b	d243094b-16ff-450f-844e-fc86ea74de8a	2026-07-23 17:41:59.01592+00
399a5e5a-5a54-452a-85cd-dbf99325750b	76d46fb8-81b5-4005-8210-a7301d1cf9af	2026-07-23 17:41:59.01592+00
399a5e5a-5a54-452a-85cd-dbf99325750b	47d2c761-163b-4e5a-b0f3-c113dca042a3	2026-07-23 17:41:59.01592+00
399a5e5a-5a54-452a-85cd-dbf99325750b	798aa675-e6e5-4628-be99-f0b80b9c8c28	2026-07-23 17:41:59.01592+00
399a5e5a-5a54-452a-85cd-dbf99325750b	b81436e8-6f2f-4679-b64c-27e676004fe0	2026-07-23 17:41:59.01592+00
399a5e5a-5a54-452a-85cd-dbf99325750b	67ed137d-9f76-4b69-b41d-8685427ded19	2026-07-23 17:41:59.01592+00
399a5e5a-5a54-452a-85cd-dbf99325750b	2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	2026-07-23 17:41:59.01592+00
399a5e5a-5a54-452a-85cd-dbf99325750b	002e2c4f-da3e-4c57-afae-ce31c2450d45	2026-07-23 17:41:59.01592+00
399a5e5a-5a54-452a-85cd-dbf99325750b	d4327dfe-e4cc-41e6-9e96-f6380e91d457	2026-07-23 17:41:59.01592+00
\.


--
-- Data for Name: phu_luc_hop_dong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.phu_luc_hop_dong (id, hop_dong_id, loai, noi_dung, ngay_hieu_luc, gia_thue_moi, ngay_ket_thuc_moi, file_pdf, nguoi_tao_id, tao_luc) FROM stdin;
\.


--
-- Data for Name: phuong_tien; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.phuong_tien (id, ma_pt, loai_xe, bien_so, khach_thue_id, phong_id, nha_tro_id, chu_tro_id, trang_thai, created_at, updated_at, anh_xe, loai_phuong_tien, ten_dong_xe, mau_xe, ten_chu_xe, so_ve_xe) FROM stdin;
\.


--
-- Data for Name: refresh_token; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.refresh_token (id, nguoi_dung_id, token, ngay_het_han, tao_luc) FROM stdin;
ad28aa2e-3126-496d-a71d-ce48ff2968bc	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzZTk2NDNiNC03ZGQ5LTQ4MjMtYWRlOS1hN2QzY2QyYjkzNDkiLCJqdGkiOiIyMjkxZWNkYi1iN2NhLTQ3ZjgtYjAwOS02MTUzYjE1MTJiOTIiLCJpYXQiOjE3ODQ3MTg5NzUsImV4cCI6MTc4NzMxMDk3NX0.8TV1hplDWVSlEY3ZaAAV58fpOpsODZPFH-NdXKARvnljnyu-Ajv8dJcoSufLFOaB	2026-08-21 11:16:15.466+00	2026-07-22 11:16:15.46757+00
cf021463-ae40-41b2-9fb0-3339c620d066	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzZTk2NDNiNC03ZGQ5LTQ4MjMtYWRlOS1hN2QzY2QyYjkzNDkiLCJqdGkiOiIxMzA5NzlmZi1iZThhLTQzNzItYTFkMy04ZjM1ODhhNzVmZGQiLCJpYXQiOjE3ODQ3MTg5ODMsImV4cCI6MTc4NzMxMDk4M30.L4GWsfuONoZ6z-jQUJqq9A3CqbJMUcgOPiN89liYBPfGjnOnsIJtRtZVMknxA4iI	2026-08-21 11:16:23.12+00	2026-07-22 11:16:23.120939+00
87b48e20-e300-4d04-a693-10a30272798f	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzZTk2NDNiNC03ZGQ5LTQ4MjMtYWRlOS1hN2QzY2QyYjkzNDkiLCJqdGkiOiIwMzBkNTVmNS02ODZjLTQyZTEtYjRhNS03ZWYxMDdhZDQ5NjkiLCJpYXQiOjE3ODQ3MTkyOTQsImV4cCI6MTc4NzMxMTI5NH0.DKHWscVrbR9lJIWYrpDNiU5Kx4F97cZkYY71z-PgEjecgMzO8a5ARFrRxNShbizj	2026-08-21 11:21:34.291+00	2026-07-22 11:21:34.291253+00
51f5cbc7-f126-401a-9b7e-9c9632041e41	08a8fef1-b65f-4b0d-b87f-fb883877e1db	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwOGE4ZmVmMS1iNjVmLTRiMGQtYjg3Zi1mYjg4Mzg3N2UxZGIiLCJqdGkiOiIxNjZkY2M4Yy1lMzVhLTRhMTctOWQxZC01ZGNlNDU5MDNmMWIiLCJpYXQiOjE3ODQ3MjU3OTUsImV4cCI6MTc4NzMxNzc5NX0.5XSbsQ1J5kbJKIzhk7UkTaI1i68QfncsdyGQzY4XbCSSV4NOX-ZVHdnOrPqnnIun	2026-08-21 13:09:55.921+00	2026-07-22 13:09:55.92206+00
94fe50ca-7278-45b9-9494-0aa1f4177f58	08a8fef1-b65f-4b0d-b87f-fb883877e1db	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwOGE4ZmVmMS1iNjVmLTRiMGQtYjg3Zi1mYjg4Mzg3N2UxZGIiLCJqdGkiOiJmYjZhNzdiYy1iOGFlLTRhOGEtOWM5YS1lZGZlN2VkNGZjODEiLCJpYXQiOjE3ODQ3MjU4MDcsImV4cCI6MTc4NzMxNzgwN30.UGhBvZKdZ6ZdW9FcZLBegndNpNzud1yRg3AURUAzYs29fcKcRms-sO8HTAL4D4C_	2026-08-21 13:10:07.105+00	2026-07-22 13:10:07.105546+00
04e6bf66-d3d3-4ae3-a339-39d05c2e8073	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzZTk2NDNiNC03ZGQ5LTQ4MjMtYWRlOS1hN2QzY2QyYjkzNDkiLCJqdGkiOiJlODU0Nzg0ZC0yMWQ5LTRmZGEtYWZlMS1mODI2MjE1ODY2ZGQiLCJpYXQiOjE3ODQ3MjU4MzksImV4cCI6MTc4NzMxNzgzOX0.vK1-UI0YMu2hdJ5fVGEnx5zedynnHD5xR_ehw14jlXc3kW8NQAQZHcJ_vL3TRmSP	2026-08-21 13:10:39.594+00	2026-07-22 13:10:39.595239+00
fde4c6b4-f463-4dca-8c9a-e791e059d523	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzZTk2NDNiNC03ZGQ5LTQ4MjMtYWRlOS1hN2QzY2QyYjkzNDkiLCJqdGkiOiJiMzk4NzhiOC04ZjRlLTQ4OGQtYTEzMC1kN2ZjYzBiMDdmMmUiLCJpYXQiOjE3ODQ3MjU4NDcsImV4cCI6MTc4NzMxNzg0N30.l22ZASU2e5ufeILqUvrzoLQesyvkr1mdojJ-A3v6_5xh4-FMNiR-WA26a7YosjeE	2026-08-21 13:10:47.45+00	2026-07-22 13:10:47.450366+00
0c24f3d1-a5d3-475b-9f74-79c677fe0d93	08a8fef1-b65f-4b0d-b87f-fb883877e1db	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwOGE4ZmVmMS1iNjVmLTRiMGQtYjg3Zi1mYjg4Mzg3N2UxZGIiLCJqdGkiOiJlOGY2Mjc4ZC04ZjVmLTRkYzAtOTQxYy1lYjBiYzg2MDQ0OTQiLCJpYXQiOjE3ODQ3MjU5MTQsImV4cCI6MTc4NzMxNzkxNH0.RGTXNGLbKQy9HBNmK7L8VckGDAE9rmd-UJFeaMCLXwSJU0MIYH2CUrpZM_0WIdUn	2026-08-21 13:11:54.025+00	2026-07-22 13:11:54.025475+00
8442c9b8-11b8-4b19-83c0-e2c4d0fc21e8	08a8fef1-b65f-4b0d-b87f-fb883877e1db	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwOGE4ZmVmMS1iNjVmLTRiMGQtYjg3Zi1mYjg4Mzg3N2UxZGIiLCJqdGkiOiI2MjFlYzQ4NC1iMjA2LTQ1N2MtYjI3Mi1hMDVlODNjMzdiOGYiLCJpYXQiOjE3ODQ3Mjg1MjksImV4cCI6MTc4NzMyMDUyOX0._ASZIun_L3NA5wZSXwWmZAmXr0NkgmRfXOGJ2xLV4lNqrIXI8vcLnJDLUhiyGdbs	2026-08-21 13:55:29.093+00	2026-07-22 13:55:29.093932+00
fb1819b4-1a1f-41bc-82d4-f26c8734114c	08a8fef1-b65f-4b0d-b87f-fb883877e1db	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwOGE4ZmVmMS1iNjVmLTRiMGQtYjg3Zi1mYjg4Mzg3N2UxZGIiLCJqdGkiOiJhNjVjNWYyYi1mZGFiLTQ2ZGUtYTc5Ny00MTI1YmYwZTU0NjQiLCJpYXQiOjE3ODQ3Mjg2MjMsImV4cCI6MTc4NzMyMDYyM30.XRKH25GVhpI3t_ZJrX_kXQPp1onlKGyxs8bkMoqH_IaDnPxRxvinc7gn0ibq77u9	2026-08-21 13:57:03.299+00	2026-07-22 13:57:03.299833+00
e2b68db1-abd4-4451-ae6f-e53cc7cb05a5	08a8fef1-b65f-4b0d-b87f-fb883877e1db	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwOGE4ZmVmMS1iNjVmLTRiMGQtYjg3Zi1mYjg4Mzg3N2UxZGIiLCJqdGkiOiIwYzk0ZTVjOC0zZGI3LTQ0ZWMtODE3NS00NmJmNmVlYzU1ZjciLCJpYXQiOjE3ODQ3MzY0OTEsImV4cCI6MTc4NzMyODQ5MX0.cHEZHlZzupoABPxs8NqRyV3FDKaVpsa6KPmvo9d01lvAjR1wi9DeDZak8aJe21Mn	2026-08-21 16:08:11.27+00	2026-07-22 16:08:11.271827+00
80ba85fd-e012-494a-b01b-fcb4e67ac925	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzZTk2NDNiNC03ZGQ5LTQ4MjMtYWRlOS1hN2QzY2QyYjkzNDkiLCJqdGkiOiIzNjFkYjYxOC1jNDM3LTRiYzYtOGNhZS1iYTI1OTg0NzgzNmIiLCJpYXQiOjE3ODQ3OTk1ODQsImV4cCI6MTc4NzM5MTU4NH0.3q3C2wFRI7wq2EJF3HyGrCIkJswUQ6dCM6v4HIa0KD4oQHN-BTWultqjEBvVw7OF	2026-08-22 09:39:44.991+00	2026-07-23 09:39:44.992558+00
04f23967-39f7-4918-9d0e-2a2bcdb241fc	08a8fef1-b65f-4b0d-b87f-fb883877e1db	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwOGE4ZmVmMS1iNjVmLTRiMGQtYjg3Zi1mYjg4Mzg3N2UxZGIiLCJqdGkiOiIxMzU2ZTkyYS05MzFlLTQwZTUtYmQyOS1iZTYwODMwNGU4MGQiLCJpYXQiOjE3ODQ4MDM0ODUsImV4cCI6MTc4NzM5NTQ4NX0.4hFYw496k3eWzAI3GQWMhqrqeCdKAtrblUEauyqgXHlphX2V78vCZcJ3tuzdOP5x	2026-08-22 10:44:45.71+00	2026-07-23 10:44:45.711507+00
993af062-4276-4f32-842e-09df351f6d53	e93c664c-53bc-45b6-9316-198dca1b0cbe	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJlOTNjNjY0Yy01M2JjLTQ1YjYtOTMxNi0xOThkY2ExYjBjYmUiLCJqdGkiOiI1Y2Q1YjZkMS0zNjA4LTQ5NjQtODZiZi1iYTE0ZjE3ZTdiMjYiLCJpYXQiOjE3ODQ4MTkxNTMsImV4cCI6MTc4NzQxMTE1M30.EBFEpb0gDPiTku1-XWN-GSpvHpdG8awREm5KecgnVTBENj-YkguuP34bXrjMfhdU	2026-08-22 15:05:53.246+00	2026-07-23 15:05:53.247509+00
8e049b79-6b08-4248-8a51-a8df7cdf6c53	e93c664c-53bc-45b6-9316-198dca1b0cbe	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJlOTNjNjY0Yy01M2JjLTQ1YjYtOTMxNi0xOThkY2ExYjBjYmUiLCJqdGkiOiJiZjdmMjdiMC04ZjlkLTQwMjYtYTM2Ni1lZTMyMTJlNjkzZGMiLCJpYXQiOjE3ODQ4MTkxNjEsImV4cCI6MTc4NzQxMTE2MX0.DCArkyWOY1gw-B69zhHng_H2cpazzHNZZRf82Db71sh2H7VVyAItctc2rxDhKbEG	2026-08-22 15:06:01.816+00	2026-07-23 15:06:01.816656+00
e7caef55-85cc-498e-aa30-14f4ad187e5f	08a8fef1-b65f-4b0d-b87f-fb883877e1db	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwOGE4ZmVmMS1iNjVmLTRiMGQtYjg3Zi1mYjg4Mzg3N2UxZGIiLCJqdGkiOiIzNGE2MjI4NS0zMTAwLTRmNGUtODE2NC03Mzk0NTI5NzEwZWYiLCJpYXQiOjE3ODQ4MzEwNTIsImV4cCI6MTc4NzQyMzA1Mn0.88pgGaYAyjcwad6q9XfkgrPZI-pkM9ya_qhhpVDoPdeuNBVeG3DebXc5stl8sfod	2026-08-22 18:24:12.402+00	2026-07-23 18:24:12.403063+00
9221d120-0c74-4cb4-b7ba-b1cce2870c29	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzZTk2NDNiNC03ZGQ5LTQ4MjMtYWRlOS1hN2QzY2QyYjkzNDkiLCJqdGkiOiI1ZTRiMjc4Mi01NjlhLTRlYTItOTAxNC1hYjE3MzdkNWFlYTUiLCJpYXQiOjE3ODQ4Nzc3NDEsImV4cCI6MTc4NzQ2OTc0MX0.SDetydiFZ10q2WccCIf07F4lobUhu5fAnHmIuqFCsT_OrGxUGzx9CgHmEP3O3-2V	2026-08-23 07:22:21.615+00	2026-07-24 07:22:21.615347+00
916b26b1-88d0-4ee6-b369-1b4457f6872d	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzZTk2NDNiNC03ZGQ5LTQ4MjMtYWRlOS1hN2QzY2QyYjkzNDkiLCJqdGkiOiJkMjYwNzBkZC1kNzFlLTQxYWMtODY4NC0wNzI4NWY1NDBlMjkiLCJpYXQiOjE3ODQ4ODI5MDQsImV4cCI6MTc4NzQ3NDkwNH0.dloo4iJxoPuJqmhph_GX16P7DchJhlQTXfvEH7LHs3wCQ9Ib7LkiuhPsIA5W77gR	2026-08-23 08:48:24.004+00	2026-07-24 08:48:24.005098+00
7b1104a9-47ce-40b9-9634-912cbe46b2a9	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzZTk2NDNiNC03ZGQ5LTQ4MjMtYWRlOS1hN2QzY2QyYjkzNDkiLCJqdGkiOiJkZTUxNjQyMS1mNThhLTRkYzQtOTEwYi1mYTE0NWNiNzZmZWQiLCJpYXQiOjE3ODQ4ODMzMjUsImV4cCI6MTc4NzQ3NTMyNX0.nsrE2wa00wjlPRWGqV3UewAMdnNL5LZLrqQMnKVuhchWLb2Xtz5sXfui8BSLUMfs	2026-08-23 08:55:25.989+00	2026-07-24 08:55:25.991148+00
\.


--
-- Data for Name: su_co; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.su_co (id, phong_id, khach_thue_id, nguoi_bao_id, tieu_de, mo_ta, loai_su_co, uu_tien, trang_thai, nguoi_phu_trach_id, chi_phi_sua_chua, tinh_vao_hoa_don, ghi_chu_chu_nha, giai_quyet_luc, tao_luc, cap_nhat_luc) FROM stdin;
\.


--
-- Data for Name: tai_san_phong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tai_san_phong (id, phong_id, ten_tai_san, so_luong, gia_tri, tinh_trang, ghi_chu, tao_luc, cap_nhat_luc, anh_tai_san, xoa_luc, kho_tai_san_id) FROM stdin;
cdafafcf-2c8e-450b-9cad-c4eb41e8e3fd	b3d3c139-adfc-4551-a128-75d3f05e964e	Tủ lạnh	1	2000000.00	Mới		2026-07-22 13:17:49.583125+00	2026-07-22 13:17:49.583125+00	http://res.cloudinary.com/dd4tyakf3/image/upload/v1784726253/quanlyphongtro/xrprdjhasnhgxdicfpa8.webp	\N	616da7d7-6c05-4620-93a3-f2e44eedfb94
bcebd371-b996-43cb-89e3-76ae1becb774	b3d3c139-adfc-4551-a128-75d3f05e964e	Tivi	1	2000000.00	Mới		2026-07-22 16:12:19.552658+00	2026-07-22 16:12:19.552658+00	https://cellphones.com.vn/tivi.html	\N	08fcdd2b-706b-484f-a709-b8a257e05ed7
\.


--
-- Data for Name: tang; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tang (id, nha_tro_id, so_tang, ten_tang, thu_tu_hien_thi, so_phong_du_kien, trang_thai, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
ac1b3a81-9124-4461-8a13-3766bc1f5d72	7e7978b2-8535-4d5f-851a-65960f801e95	1	Tầng 1	1	\N	ACTIVE	2026-07-22 13:13:09.533942+00	2026-07-22 13:13:09.533942+00	\N
a9e70598-647e-4cea-a384-ed0acd4b3cef	cf6edb0e-afcf-47bd-8a7b-56b09ad5140c	1	Tang 1	1	3	ACTIVE	2026-07-23 10:05:26.407225+00	2026-07-23 10:05:26.407225+00	2026-07-23 10:19:34.938977+00
852a2b2a-265a-4b03-86b2-42955e824670	cf6edb0e-afcf-47bd-8a7b-56b09ad5140c	2	Tang 2	2	3	ACTIVE	2026-07-23 10:05:26.407225+00	2026-07-23 10:05:26.407225+00	2026-07-23 10:19:34.938977+00
5682c749-ad3a-43a5-bdf1-696d488f61ef	cf6edb0e-afcf-47bd-8a7b-56b09ad5140c	3	Tang 3	3	3	ACTIVE	2026-07-23 10:05:26.407225+00	2026-07-23 10:05:26.407225+00	2026-07-23 10:19:34.938977+00
111df5a8-4d2e-4a6c-ace6-45c9c55b5f14	f99082a3-1c1c-44f0-a05a-25dc11fd5c46	1	Tang 1	1	3	ACTIVE	2026-07-23 10:33:21.013354+00	2026-07-23 10:33:21.013354+00	\N
01675501-07db-4b1d-8163-db9e3fe46ebd	f99082a3-1c1c-44f0-a05a-25dc11fd5c46	2	Tang 2	2	3	ACTIVE	2026-07-23 10:33:21.013354+00	2026-07-23 10:33:21.013354+00	\N
97a24f01-e6c8-41b4-89e7-b358f797389c	f99082a3-1c1c-44f0-a05a-25dc11fd5c46	3	Tang 3	3	3	ACTIVE	2026-07-23 10:33:21.013354+00	2026-07-23 10:33:21.013354+00	\N
5fde1b78-f252-4aa6-bfc8-9ac40840fd39	63fe73ae-b22c-4a78-abd5-33cc79ceffbd	1	Tang 1	1	4	ACTIVE	2026-07-23 17:17:49.402523+00	2026-07-23 17:17:49.402523+00	\N
bbc2fe24-2bcf-43df-b4d5-3420bc9bd4f7	63fe73ae-b22c-4a78-abd5-33cc79ceffbd	2	Tang 2	2	4	ACTIVE	2026-07-23 17:17:49.402523+00	2026-07-23 17:17:49.402523+00	\N
0115b323-18a6-47ec-8e17-8d4026752daa	63fe73ae-b22c-4a78-abd5-33cc79ceffbd	3	Tang 3	3	4	ACTIVE	2026-07-23 17:17:49.402523+00	2026-07-23 17:17:49.402523+00	\N
906c3e95-2072-4903-8fa0-ff200a58e27a	77d63858-dd11-436a-b31f-3739f15af084	1	Tang 1	1	7	ACTIVE	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N
d410fcf9-cb4e-48cf-866b-7b93db8181a1	77d63858-dd11-436a-b31f-3739f15af084	2	Tang 2	2	7	ACTIVE	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N
1cf894c2-b479-4906-a4b6-1dea105e4fbd	77d63858-dd11-436a-b31f-3739f15af084	3	Tang 3	3	7	ACTIVE	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N
4d932fdf-eee1-40fe-a2bb-fa1c6b632478	77d63858-dd11-436a-b31f-3739f15af084	4	Tang 4	4	7	ACTIVE	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N
632d647b-27b3-489a-a5a9-ead90e79bfdb	77d63858-dd11-436a-b31f-3739f15af084	5	Tang 5	5	7	ACTIVE	2026-07-23 17:41:59.01592+00	2026-07-23 17:41:59.01592+00	\N
\.


--
-- Data for Name: thanh_toan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.thanh_toan (id, hoa_don_id, khach_thue_id, so_tien, ngay_thanh_toan, phuong_thuc_thanh_toan, ma_tham_chieu, external_transaction_id, trang_thai, nguoi_thanh_toan_id, nguoi_ghi_nhan_id, ghi_chu, tao_luc) FROM stdin;
dbbf85fd-deca-422f-b1a1-fc27a7da4de3	4d6ed482-cb76-4a7f-9426-149208f9f960	95094c9c-f0df-49e0-9dae-d4646963e7fa	3199999.00	2026-07-22 17:00:00+00	CASH	\N	\N	SUCCESS	\N	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349		2026-07-23 19:11:01.602796+00
\.


--
-- Data for Name: thanh_vien_cuoc_tro_chuyen; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.thanh_vien_cuoc_tro_chuyen (id, cuoc_tro_chuyen_id, nguoi_dung_id, vai_tro, tham_gia_luc, roi_luc, doc_den_seq, doc_den_luc, tat_thong_bao, ghim, luu_tru, an_den_seq, biet_danh, tat_thong_bao_den) FROM stdin;
cdd18ad4-823d-4116-8199-b9c640c3417b	13146f4b-2739-4f73-9577-2dd12428563f	08a8fef1-b65f-4b0d-b87f-fb883877e1db	MEMBER	2026-07-22 13:23:20.276428+00	\N	0	\N	f	f	f	0	\N	\N
56978baa-7102-4889-a46a-3cda0235e4a6	9b38c7cd-acc1-4408-afb8-3999b53128cd	08a8fef1-b65f-4b0d-b87f-fb883877e1db	MEMBER	2026-07-22 13:23:20.276428+00	\N	42	2026-07-22 16:26:31.463619+00	f	f	f	0	\N	\N
03ac6ec0-0e55-472d-ad73-46e7a8a7b41b	5155729e-fd60-49ed-9150-23be8832b11b	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	MEMBER	2026-07-22 13:28:42.495893+00	\N	70	2026-07-22 16:27:05.26143+00	f	f	f	0	\N	\N
dc2d499b-c4bc-4676-be88-c070f004330b	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	MEMBER	2026-07-22 13:28:42.495893+00	\N	70	2026-07-22 16:27:51.283847+00	f	f	f	0	\N	\N
\.


--
-- Data for Name: thanh_vien_hop_dong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.thanh_vien_hop_dong (id, hop_dong_id, khach_thue_id, ho_ten, so_cccd, so_dien_thoai, ngay_vao, ngay_roi, dang_o, la_nguoi_dai_dien, ghi_chu, tao_luc, cap_nhat_luc) FROM stdin;
989d522a-f254-4141-b94c-e2e2d80f3563	122cb046-8a81-4b53-937d-70256e13a62e	a8dfc6bd-b2df-43ea-9611-4edb70498dcc	hàng thị trúc giang	066206004002	0396822875	2026-07-23	\N	t	t	\N	2026-07-23 19:02:58.959589+00	2026-07-23 19:02:58.959589+00
7970f05d-a29c-4b2a-9f45-ef3c7a41b3b2	21f02101-a8a4-437c-aa2d-1cc3f60f151d	95094c9c-f0df-49e0-9dae-d4646963e7fa	Phùng Văn Thọ	066206004001	0357165019	2026-07-23	\N	t	t	\N	2026-07-23 19:08:45.652116+00	2026-07-23 19:08:45.652116+00
\.


--
-- Data for Name: thong_bao; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.thong_bao (id, nguoi_gui_id, loai, tieu_de, noi_dung, doi_tuong, doi_tuong_id, kenh, gui_tat_ca, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
39d198aa-8321-478c-bccb-7ab6427d43e9	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	SYSTEM	Thông báo Test	thông báo test	\N	\N	IN_APP	f	2026-07-22 13:29:47.102742+00	2026-07-22 13:29:47.102742+00	\N
0fe35f57-0a8b-4aaa-9324-0af0ae5282e2	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	SYSTEM	thong báo all	Found a swap file by the name "/f/qlyphongtro/.git/.MERGE_MSG.swp" owned by: docon dated: Sat Jul 04 18:12:07 2026 file name: /f/qlyphongtro/.git/MERGE_MSG modified: YES user name: docon host name: Orinn process ID: 56 While opening file "/f/qlyphongtro/.git/MERGE_MSG" dated: Wed Jul 22 19:57:53 2026 NEWER than swap file! (1) Another program may be editing the same file. If this is the case, be careful not to end up with two different instances of the same file when making changes. Quit, or continue with caution. (2) An edit session for this file crashed. If this is the case, use ":recover" or "vim -r /f/qlyphongtro/.git/MERGE_MSG" to recover the changes (see ":help recovery"). If you did this already, delete the swap file "/f/qlyphongtro/.git/.MERGE_MSG.swp" to avoid this message. Swap file "/f/qlyphongtro/.git/.MERGE_MSG.swp" already exists! [O]pen Read-Only, (E)dit anyway, (R)ecover, (D)elete it, (Q)uit, (A)bort:	\N	\N	IN_APP	t	2026-07-22 13:34:56.399162+00	2026-07-22 13:34:56.399162+00	\N
92f0a59c-c1a3-4389-9b4d-5c3943636023	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	SYSTEM	thong báo all	Found a swap file by the name "/f/qlyphongtro/.git/.MERGE_MSG.swp" owned by: docon dated: Sat Jul 04 18:12:07 2026 file name: /f/qlyphongtro/.git/MERGE_MSG modified: YES user name: docon host name: Orinn process ID: 56 While opening file "/f/qlyphongtro/.git/MERGE_MSG" dated: Wed Jul 22 19:57:53 2026 NEWER than swap file! (1) Another program may be editing the same file. If this is the case, be careful not to end up with two different instances of the same file when making changes. Quit, or continue with caution. (2) An edit session for this file crashed. If this is the case, use ":recover" or "vim -r /f/qlyphongtro/.git/MERGE_MSG" to recover the changes (see ":help recovery"). If you did this already, delete the swap file "/f/qlyphongtro/.git/.MERGE_MSG.swp" to avoid this message. Swap file "/f/qlyphongtro/.git/.MERGE_MSG.swp" already exists! [O]pen Read-Only, (E)dit anyway, (R)ecover, (D)elete it, (Q)uit, (A)bort:	\N	\N	IN_APP	t	2026-07-22 13:38:40.861632+00	2026-07-22 13:38:40.861632+00	\N
ca7e592f-7852-4724-b993-9eb51f0e0f2f	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	SYSTEM	new	https://soundcloud.com/trung-hoang-official/xi-mang-pho-vol-13-full-trung-hoang	\N	\N	IN_APP	t	2026-07-22 13:44:06.722123+00	2026-07-22 13:44:06.722123+00	\N
755a8efe-b632-4208-8eda-408f5028d004	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	SYSTEM	new	Dịch vụ áp dụng cho hợp đồng	\N	\N	IN_APP	t	2026-07-22 13:49:05.738212+00	2026-07-22 13:49:05.738212+00	\N
96826d3e-7265-40ec-8290-79ad665d507c	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	SYSTEM	new	Dịch vụ áp dụng cho hợp đồng	\N	\N	IN_APP	t	2026-07-22 13:49:23.703741+00	2026-07-22 13:49:23.703741+00	\N
395eec34-2fa7-4b29-88e7-7ef7930faad9	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	SYSTEM	new	sdgsgdgfsdgs	\N	\N	IN_APP	t	2026-07-22 13:58:51.305831+00	2026-07-22 13:58:51.305831+00	\N
a589b84e-46aa-4415-8dac-75b8da9db441	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	SYSTEM	Thông báo Test	tèausfyjhsdfsdagvsfdb	\N	\N	IN_APP	t	2026-07-22 16:10:29.294049+00	2026-07-22 16:10:29.294049+00	\N
4fec1f1b-9b3a-4267-afe1-fbf3af5d065a	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	SYSTEM	new	dfhdfbcv	\N	\N	IN_APP	t	2026-07-22 16:27:38.975265+00	2026-07-22 16:27:38.975265+00	\N
\.


--
-- Data for Name: thong_bao_nguoi_nhan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.thong_bao_nguoi_nhan (id, thong_bao_id, nguoi_dung_id, da_doc, doc_luc, gui_luc, loi_gui) FROM stdin;
bb961836-ed60-4e50-9c8b-88ed8a09271a	39d198aa-8321-478c-bccb-7ab6427d43e9	08a8fef1-b65f-4b0d-b87f-fb883877e1db	t	2026-07-22 13:29:56.587485+00	2026-07-22 13:32:58.806414+00	\N
0696b6ba-0b96-4554-bf75-0a5030768190	92f0a59c-c1a3-4389-9b4d-5c3943636023	08a8fef1-b65f-4b0d-b87f-fb883877e1db	t	2026-07-22 13:38:49.905909+00	2026-07-22 13:38:49.905909+00	\N
4d657669-6afa-4005-af21-59ede24cada0	0fe35f57-0a8b-4aaa-9324-0af0ae5282e2	08a8fef1-b65f-4b0d-b87f-fb883877e1db	t	2026-07-22 13:38:52.545157+00	2026-07-22 13:38:52.545157+00	\N
ac4e8afb-6f5b-4c45-a42d-844a1e91aa39	ca7e592f-7852-4724-b993-9eb51f0e0f2f	08a8fef1-b65f-4b0d-b87f-fb883877e1db	t	2026-07-22 13:44:17.572731+00	2026-07-22 13:44:17.572731+00	\N
adb75ab8-3ae5-4aa8-8eb7-ab2363aca726	755a8efe-b632-4208-8eda-408f5028d004	08a8fef1-b65f-4b0d-b87f-fb883877e1db	t	2026-07-22 13:49:16.997947+00	2026-07-22 13:49:16.997947+00	\N
94c9db81-89db-422d-8938-e7ac746d9320	96826d3e-7265-40ec-8290-79ad665d507c	08a8fef1-b65f-4b0d-b87f-fb883877e1db	t	2026-07-22 13:58:07.78716+00	2026-07-22 13:58:07.78716+00	\N
2ada41ac-410c-474b-8a7b-c1cacd45b648	395eec34-2fa7-4b29-88e7-7ef7930faad9	08a8fef1-b65f-4b0d-b87f-fb883877e1db	t	2026-07-22 14:01:18.390251+00	2026-07-22 14:01:18.390769+00	\N
53881a7e-6fe0-4bd3-93fb-28f4adcf7a79	a589b84e-46aa-4415-8dac-75b8da9db441	08a8fef1-b65f-4b0d-b87f-fb883877e1db	t	2026-07-22 16:10:36.221001+00	2026-07-22 16:10:36.221001+00	\N
536efd4d-381f-4c37-b4f8-4c8e38350d79	4fec1f1b-9b3a-4267-afe1-fbf3af5d065a	08a8fef1-b65f-4b0d-b87f-fb883877e1db	t	2026-07-22 16:27:48.746334+00	2026-07-22 16:27:48.746855+00	\N
\.


--
-- Data for Name: tien_ich; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tien_ich (id, ten, bieu_tuong, tao_luc) FROM stdin;
d243094b-16ff-450f-844e-fc86ea74de8a	Điều hòa	\N	2026-07-23 10:05:26.407225+00
76d46fb8-81b5-4005-8210-a7301d1cf9af	Bàn làm việc	\N	2026-07-23 10:05:26.407225+00
47d2c761-163b-4e5a-b0f3-c113dca042a3	Nóng lạnh	\N	2026-07-23 10:05:26.407225+00
798aa675-e6e5-4628-be99-f0b80b9c8c28	Ghế	\N	2026-07-23 10:05:26.407225+00
b81436e8-6f2f-4679-b64c-27e676004fe0	Giường	\N	2026-07-23 10:05:26.407225+00
67ed137d-9f76-4b69-b41d-8685427ded19	TV	\N	2026-07-23 10:05:26.407225+00
2f7b22c6-5ab7-4240-92f8-0af15edd1ec3	Tủ quần áo	\N	2026-07-23 10:05:26.407225+00
002e2c4f-da3e-4c57-afae-ce31c2450d45	Máy giặt	\N	2026-07-23 10:05:26.407225+00
d4327dfe-e4cc-41e6-9e96-f6380e91d457	Bếp	\N	2026-07-23 10:05:26.407225+00
d189fabb-5ef1-45d9-bc97-d74800ee33b1	banlamviec	\N	2026-07-22 13:13:09.526511+00
3453962d-2c72-44ae-be10-c25d2a47a4a1	bat	\N	2026-07-22 13:13:09.526511+00
be50ca8a-f6f4-4afb-96a8-a3fec61b1143	bep	\N	2026-07-22 13:13:09.526511+00
bdcdff77-8d7f-43c8-a1b4-6ad0ed82378b	chen	\N	2026-07-22 13:13:09.526511+00
bbe0eda5-c779-4e41-87ef-fcfbe361962a	dieuhoa	\N	2026-07-22 13:13:09.526511+00
33ba0073-4b14-45dd-b558-cf7181b67cd2	ghe	\N	2026-07-22 13:13:09.526511+00
f2d646f8-8346-4876-bd43-8dd80520ccdf	giuong	\N	2026-07-22 13:13:09.526511+00
87ea4a67-b1e1-4e57-9155-f004d46231e9	maygiat	\N	2026-07-22 13:13:09.526511+00
c2e9cc45-84ae-4a8b-8bad-2363af4133cc	noi	\N	2026-07-22 13:13:09.526511+00
626fc19b-3f55-4556-9f5f-0378efd8d6a4	nonglanh	\N	2026-07-22 13:13:09.526511+00
fa0e247e-0e0e-4601-9340-f02017291e50	tivi	\N	2026-07-22 13:13:09.526511+00
dee6c56e-a35a-41ea-8c5c-4edcdb70c2f1	tulanh	\N	2026-07-22 13:13:09.526511+00
48b4eb3a-e018-441d-95c6-06ce37eee8fd	tuquanao	\N	2026-07-22 13:13:09.526511+00
aaf53ac7-7cc5-4af0-b26a-aefb64455319	wifi	\N	2026-07-22 13:13:09.526511+00
\.


--
-- Data for Name: tin_nhan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tin_nhan (id, so_thu_tu, cuoc_tro_chuyen_id, nguoi_gui_id, loai, noi_dung, file_media_id, tra_loi_cho_id, ma_client, da_thu_hoi, tao_luc, cap_nhat_luc, xoa_luc, ghim_luc, nguoi_ghim_id, chuyen_tiep_tu_id) FROM stdin;
e32d15fb-1bd2-48b1-963a-4e2381b6330b	1	5155729e-fd60-49ed-9150-23be8832b11b	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	TEXT	xin chào	\N	\N	4161052e-4aa1-4099-b496-7c94d5d2792e	f	2026-07-22 13:28:48.423605+00	2026-07-22 13:28:48.423605+00	\N	\N	\N	\N
b2c922c9-14fb-458b-b388-df76c602aff8	2	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	chào bạn 	\N	\N	d982821d-acc6-4334-8577-3880af152113	f	2026-07-22 13:42:08.928383+00	2026-07-22 13:42:08.928383+00	\N	\N	\N	\N
82455d18-5ca3-40c6-9776-d8f0c54caf0d	3	5155729e-fd60-49ed-9150-23be8832b11b	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	TEXT	alo bạn	\N	\N	2abc3489-6e9c-4f6e-8e5a-9be191216177	f	2026-07-22 13:50:07.861123+00	2026-07-22 13:50:07.861123+00	\N	\N	\N	\N
55a56eeb-ee08-4f7b-b6d4-1c7dabc6c782	4	5155729e-fd60-49ed-9150-23be8832b11b	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	TEXT	àhausf	\N	\N	8c2405c5-91a9-43be-aae8-ee71d9798398	f	2026-07-22 13:50:08.882247+00	2026-07-22 13:50:08.882247+00	\N	\N	\N	\N
da44e763-b04a-41b4-ae58-fb34f0e51b2f	5	5155729e-fd60-49ed-9150-23be8832b11b	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	TEXT	jagsfjkhasf	\N	\N	6aa1b31c-e7d5-4eff-a4ce-c27765419ede	f	2026-07-22 13:50:09.699621+00	2026-07-22 13:50:09.699621+00	\N	\N	\N	\N
1031d7ee-e4b6-4e54-8161-d52a051199c7	6	5155729e-fd60-49ed-9150-23be8832b11b	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	TEXT	alo	\N	\N	8b4baf9e-bd15-4ad8-99b8-a9e04f1b69d6	f	2026-07-22 13:57:30.935831+00	2026-07-22 13:57:30.935831+00	\N	\N	\N	\N
b08de61e-a2d4-4982-a2f8-128093484c95	7	5155729e-fd60-49ed-9150-23be8832b11b	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	TEXT	you	\N	\N	a57e75b6-b5e3-4606-8e7a-bc190bc8bb49	f	2026-07-22 13:57:33.748907+00	2026-07-22 13:57:33.748907+00	\N	\N	\N	\N
9c6f3a5a-cf61-4d40-a4d5-57eb9d3052de	8	5155729e-fd60-49ed-9150-23be8832b11b	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	TEXT	hẻy	\N	\N	0d0d8ba0-17e9-44fc-94a8-8f839f432262	f	2026-07-22 13:57:36.892266+00	2026-07-22 13:57:36.892266+00	\N	\N	\N	\N
f981e9a4-bc34-4bfb-8e5d-4e2b658e33be	9	9b38c7cd-acc1-4408-afb8-3999b53128cd	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	hello	\N	\N	d4153fae-5256-4992-96b6-e2b82dc2d759	f	2026-07-22 13:58:16.758952+00	2026-07-22 13:58:16.758952+00	\N	\N	\N	\N
84381b28-7c08-41c7-b5d3-c3e09677912b	10	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	hey you	\N	\N	c8de7e61-30bf-4513-873d-5b6e3da7124f	f	2026-07-22 13:59:09.471111+00	2026-07-22 13:59:09.471111+00	\N	\N	\N	\N
c70fd597-61c5-4ba2-b9fd-111cbb4d1df5	11	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	fv	\N	\N	22f5e24e-8b6f-4bc1-8eb0-d5b5d62f86df	f	2026-07-22 16:09:13.761334+00	2026-07-22 16:09:13.761334+00	\N	\N	\N	\N
49d15dbb-7067-4783-849a-430a1f50d3d0	12	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	v	\N	\N	12797fb7-5a7b-471b-a550-daefb5fa9208	f	2026-07-22 16:09:14.916067+00	2026-07-22 16:09:14.916067+00	\N	\N	\N	\N
239cd0fb-8cb1-4634-bfd3-31b307fb8e64	13	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	v	\N	\N	452a5188-5ff3-4305-88cd-9fe2fcd2c1ec	f	2026-07-22 16:09:15.143798+00	2026-07-22 16:09:15.143798+00	\N	\N	\N	\N
f18d555f-8469-4952-89eb-aa9957796ee8	14	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	v	\N	\N	46d1f992-2a04-4d54-b9b6-2bce3170994f	f	2026-07-22 16:09:15.304841+00	2026-07-22 16:09:15.304841+00	\N	\N	\N	\N
d39c93a5-c8a5-4678-af5c-d1a9c8f621e2	15	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	v	\N	\N	0d81b5e7-51ee-428c-ad33-39d2e1507338	f	2026-07-22 16:09:15.467836+00	2026-07-22 16:09:15.467836+00	\N	\N	\N	\N
b5b80412-65f2-423c-8592-20a33b6c7db1	16	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	v	\N	\N	4501ec0e-6c3f-4045-ad28-e1e0c47c6256	f	2026-07-22 16:09:15.634202+00	2026-07-22 16:09:15.634202+00	\N	\N	\N	\N
c9fc0b47-2054-4aff-9476-8f5131e75b9a	17	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	v	\N	\N	14edba37-8b91-4ed6-a909-db9729c0e299	f	2026-07-22 16:09:15.760536+00	2026-07-22 16:09:15.760536+00	\N	\N	\N	\N
e2226c43-3838-41b3-98c3-cdf6e740d229	18	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	v	\N	\N	3239248a-b2d8-49f4-bb37-fea3f9d39bda	f	2026-07-22 16:09:15.902147+00	2026-07-22 16:09:15.902147+00	\N	\N	\N	\N
771cfe4d-9dc0-493a-bdfe-1a754e74bd73	19	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	xzc	\N	\N	2a37da7a-5d70-4ab7-992f-ebd2feba868c	f	2026-07-22 16:09:16.589788+00	2026-07-22 16:09:16.589788+00	\N	\N	\N	\N
c0e14732-81dd-4151-913d-7ea1bca11964	20	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	z	\N	\N	ae29a8ec-a889-4746-b820-45dd5db3277f	f	2026-07-22 16:09:16.765783+00	2026-07-22 16:09:16.765783+00	\N	\N	\N	\N
dc7e5e40-0a71-4238-a733-af5baa9530af	21	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	ca	\N	\N	1801fb3a-3c7b-4919-ac86-46079b6eeb1d	f	2026-07-22 16:09:16.955033+00	2026-07-22 16:09:16.955033+00	\N	\N	\N	\N
3afcb475-a3b4-4ce1-be4a-ab19f8a48455	22	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	sd	\N	\N	c9e6e957-4922-4f2c-bb76-947702dad064	f	2026-07-22 16:09:17.121499+00	2026-07-22 16:09:17.121499+00	\N	\N	\N	\N
618906b1-da99-4eb6-aa8a-22adf5c51047	23	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	ác	\N	\N	e1369c31-99c2-4a80-ac42-6897852e73a3	f	2026-07-22 16:09:17.270439+00	2026-07-22 16:09:17.270439+00	\N	\N	\N	\N
ded6dc7d-2192-4d85-b541-c2b93a98be87	24	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	a	\N	\N	22d13fd4-56f7-4221-b3bf-c30ecc72fefd	f	2026-07-22 16:09:17.411949+00	2026-07-22 16:09:17.411949+00	\N	\N	\N	\N
6ab1c281-d178-47fe-a6a4-90f6e89b7c34	25	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	sd	\N	\N	0124a973-016c-4e4c-8c42-87001381337c	f	2026-07-22 16:09:17.815724+00	2026-07-22 16:09:17.815724+00	\N	\N	\N	\N
3a82de04-5dac-47c2-82ff-a6d85d5b181f	26	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	a	\N	\N	ad9d1a24-038e-447a-8cc4-8a9ec61e7ce5	f	2026-07-22 16:09:18.352182+00	2026-07-22 16:09:18.352182+00	\N	\N	\N	\N
d086c6dc-200c-4963-bdb1-a5c53741bca9	27	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	fda	\N	\N	f83856ab-5361-4241-8547-e8e30b70e801	f	2026-07-22 16:09:18.517961+00	2026-07-22 16:09:18.517961+00	\N	\N	\N	\N
e603bf95-2c3e-4ac4-8e48-4e2e6a1246e4	28	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	sf	\N	\N	50f64080-10cc-4b78-b562-d0f8dc4850e0	f	2026-07-22 16:09:18.691473+00	2026-07-22 16:09:18.691473+00	\N	\N	\N	\N
65d2f369-91a6-487b-a30a-87f96c66d97e	29	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	à	\N	\N	ac8c93ed-6a55-45c7-a745-a3576d775e3c	f	2026-07-22 16:09:18.879639+00	2026-07-22 16:09:18.879639+00	\N	\N	\N	\N
ca437472-417b-46bd-b750-aefbbe099228	30	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	v	\N	\N	865374a3-5181-49a0-92b5-e08e13a2a378	f	2026-07-22 16:09:19.436328+00	2026-07-22 16:09:19.436328+00	\N	\N	\N	\N
d5ada8a7-ed45-435c-9200-3bf6d25a8c42	31	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	sf	\N	\N	9f80cd1f-44bf-4ea2-95d5-f79ccc4dd653	f	2026-07-22 16:09:19.646753+00	2026-07-22 16:09:19.646753+00	\N	\N	\N	\N
cbb0cdde-aa05-4aed-b340-6db87d104a2f	32	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	a	\N	\N	9778bb90-40a7-427b-a2c8-5517239193f4	f	2026-07-22 16:09:19.854767+00	2026-07-22 16:09:19.854767+00	\N	\N	\N	\N
8642bf7b-5793-4796-8c14-6c7dd0370ca8	33	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	fad	\N	\N	07136af5-2d92-4b10-a676-a76c7d8b1d68	f	2026-07-22 16:09:20.365066+00	2026-07-22 16:09:20.365066+00	\N	\N	\N	\N
fa75adb7-0a89-48a8-835d-1751ef4ac9d1	34	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	ưq	\N	\N	8b64b5bd-714f-406a-87f8-03aef42c5fac	f	2026-07-22 16:09:20.790458+00	2026-07-22 16:09:20.790458+00	\N	\N	\N	\N
f9308693-db29-437d-a98c-5bdf8b4ccf4a	35	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	eq	\N	\N	01049cdf-36f1-41ce-b0e5-7579b538be8f	f	2026-07-22 16:09:20.989034+00	2026-07-22 16:09:20.989034+00	\N	\N	\N	\N
7912bafa-54ef-4432-9668-0ec70d143ebd	36	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	ưe	\N	\N	8d7d41b9-4859-4c8b-acdf-2eb84efc53c5	f	2026-07-22 16:09:21.271672+00	2026-07-22 16:09:21.271672+00	\N	\N	\N	\N
bdc8c467-acd5-4ef7-b921-ce34d9a0612e	37	9b38c7cd-acc1-4408-afb8-3999b53128cd	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	sfsdgf	\N	\N	6cb3cd91-aeb2-469b-bba3-1aacd07a1d83	f	2026-07-22 16:26:30.585561+00	2026-07-22 16:26:30.585561+00	\N	\N	\N	\N
99b87848-e720-4db2-a134-897c8e9f1fbc	38	9b38c7cd-acc1-4408-afb8-3999b53128cd	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	sg	\N	\N	e645de50-b822-4637-8168-e4b11e7cad0e	f	2026-07-22 16:26:30.824028+00	2026-07-22 16:26:30.824028+00	\N	\N	\N	\N
26aabab1-8c91-40ba-b5a7-f4042ad7fe50	39	9b38c7cd-acc1-4408-afb8-3999b53128cd	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	sd	\N	\N	96610ace-441d-42e5-b2ee-bd88d53b5bc4	f	2026-07-22 16:26:30.972668+00	2026-07-22 16:26:30.972668+00	\N	\N	\N	\N
0336bb70-9bcc-4f54-920d-2100105a6119	40	9b38c7cd-acc1-4408-afb8-3999b53128cd	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	g	\N	\N	f581e5db-7eac-4fa6-968e-ba20f63f5e91	f	2026-07-22 16:26:31.120887+00	2026-07-22 16:26:31.120887+00	\N	\N	\N	\N
da1b2918-f0b1-4470-bdbc-8c730f5fc5c8	41	9b38c7cd-acc1-4408-afb8-3999b53128cd	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	s	\N	\N	37c1eb91-c810-48d3-b14b-9c399548c278	f	2026-07-22 16:26:31.271964+00	2026-07-22 16:26:31.271964+00	\N	\N	\N	\N
ab975b0c-6d3c-48b4-b309-d5df8dc82942	42	9b38c7cd-acc1-4408-afb8-3999b53128cd	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	gs	\N	\N	d785a023-dc22-432e-987d-933d488cc51f	f	2026-07-22 16:26:31.435409+00	2026-07-22 16:26:31.435409+00	\N	\N	\N	\N
46ac7cfb-d494-4186-a23f-9f1ebf9d4d59	43	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	gsgsd	\N	\N	7ce4f978-13a3-43c5-bd12-18b08a44fa59	f	2026-07-22 16:26:34.27984+00	2026-07-22 16:26:34.27984+00	\N	\N	\N	\N
7b533190-8121-4ae5-b83a-066b493555b1	44	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	gs	\N	\N	d7ca0952-139f-4178-9956-103062e08895	f	2026-07-22 16:26:34.465224+00	2026-07-22 16:26:34.465224+00	\N	\N	\N	\N
8e64b7ae-771e-43b3-9edb-28b7f3f02246	45	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	dg	\N	\N	cf126789-5b9d-4c0d-ad70-80a3a375bf3c	f	2026-07-22 16:26:34.605417+00	2026-07-22 16:26:34.605417+00	\N	\N	\N	\N
5065ed1f-abb6-4435-b88d-3a4927b12741	46	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	sd	\N	\N	2b3a047b-4eb1-40d0-ad38-929732763e5b	f	2026-07-22 16:26:34.745024+00	2026-07-22 16:26:34.745024+00	\N	\N	\N	\N
807acd33-3216-4188-b461-d07d10f2c1a6	47	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	g	\N	\N	a5370651-ded8-4c7a-a6e6-4bb87ccb75a2	f	2026-07-22 16:26:34.871518+00	2026-07-22 16:26:34.871518+00	\N	\N	\N	\N
61cfc42a-cfbe-4eeb-880f-db13ea3c4672	48	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	sdg	\N	\N	54973c16-b0b1-4265-8ef6-11d9870cec8b	f	2026-07-22 16:26:35.012134+00	2026-07-22 16:26:35.012134+00	\N	\N	\N	\N
24cc0070-48ee-4fe3-a7c7-f1f24f7e7a19	49	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	sd	\N	\N	e8752cd0-820e-40e2-ae74-83af4c658d58	f	2026-07-22 16:26:35.166299+00	2026-07-22 16:26:35.166299+00	\N	\N	\N	\N
dc667733-1d47-4417-b9ea-f93dec69d062	50	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	g	\N	\N	79390d74-57e6-4f3a-9810-9df7cf5e41a0	f	2026-07-22 16:26:35.314331+00	2026-07-22 16:26:35.314331+00	\N	\N	\N	\N
873eada7-32ca-42da-8e0d-345e1e1e7aea	51	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	sd	\N	\N	e7af0f66-23a9-466e-8db6-300fe8952231	f	2026-07-22 16:26:35.451087+00	2026-07-22 16:26:35.451087+00	\N	\N	\N	\N
e4f030d4-a98a-4731-9e10-734079123b70	52	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	gsd	\N	\N	ef575698-406e-4077-884e-4275212ab115	f	2026-07-22 16:26:35.607139+00	2026-07-22 16:26:35.607139+00	\N	\N	\N	\N
5b97eeb7-10bf-49ee-a313-513e32bd03b6	53	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	g	\N	\N	bcb27972-1b9e-4803-96a6-6298278fa4ee	f	2026-07-22 16:26:35.764994+00	2026-07-22 16:26:35.764994+00	\N	\N	\N	\N
ef567d90-3f76-4ab6-854d-733270eb83ff	58	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	f	\N	\N	763e8fcd-65ab-4f5e-aec3-10689f863760	f	2026-07-22 16:26:38.133415+00	2026-07-22 16:26:38.133415+00	\N	\N	\N	\N
25f7aaec-c12d-438d-a05e-a30ff4b7f050	64	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	a	\N	\N	ad856789-fab5-4bbd-8bbd-3ada098cc08b	f	2026-07-22 16:26:47.672345+00	2026-07-22 16:26:47.672345+00	\N	\N	\N	\N
69d8d1d7-7711-4fe5-b371-e695a6d52eb6	67	5155729e-fd60-49ed-9150-23be8832b11b	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	TEXT	a	\N	\N	29620052-0ae7-4b16-acf7-9b4fd36ca652	f	2026-07-22 16:27:04.838331+00	2026-07-22 16:27:04.838331+00	\N	\N	\N	\N
85051016-5eae-47fa-b8f8-0c1313e5fd31	54	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	sdg	\N	\N	c276d80d-ee7d-48bb-9817-d1896f858638	f	2026-07-22 16:26:35.929717+00	2026-07-22 16:26:35.929717+00	\N	\N	\N	\N
5d605741-c944-425c-848d-dd6b1fa64f99	59	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	qừ	\N	\N	882c1469-bb80-407e-86cf-e90bc7b79404	f	2026-07-22 16:26:38.423192+00	2026-07-22 16:26:38.423192+00	\N	\N	\N	\N
1f4b4866-002d-4d56-8939-8e79e65a99eb	60	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	ấ	\N	\N	c0fe4591-bf22-43ac-a87b-cf3c6538e0f8	f	2026-07-22 16:26:47.024942+00	2026-07-22 16:26:47.024942+00	\N	\N	\N	\N
54b3cadc-2f2c-44e8-83c4-e1ec0ff3f64b	61	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	fa	\N	\N	f78c9382-8ff4-404f-bf96-3fdd23a08914	f	2026-07-22 16:26:47.227822+00	2026-07-22 16:26:47.227822+00	\N	\N	\N	\N
c67f7f3a-78bc-4a07-83a1-a20e256536e9	63	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	à	\N	\N	3b942a56-56dd-445c-b2fe-cebad1567546	f	2026-07-22 16:26:47.537493+00	2026-07-22 16:26:47.537493+00	\N	\N	\N	\N
ff6e84ab-2d5b-4f11-901f-2e7033c1f669	65	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	f	\N	\N	0664b687-fef1-435b-ad87-e57863d98831	f	2026-07-22 16:26:47.795453+00	2026-07-22 16:26:47.795453+00	\N	\N	\N	\N
83ef8abe-d567-4397-8830-887605af75a6	66	5155729e-fd60-49ed-9150-23be8832b11b	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	TEXT	fafa	\N	\N	24046a47-257e-4a6d-8c7a-05d7e236c7a8	f	2026-07-22 16:27:04.690851+00	2026-07-22 16:27:04.690851+00	\N	\N	\N	\N
d09a195e-f2d9-4197-aa12-9dd2a54c67d2	70	5155729e-fd60-49ed-9150-23be8832b11b	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	TEXT	a	\N	\N	98db91f4-64b7-49f7-b07c-ee8786645435	f	2026-07-22 16:27:05.224987+00	2026-07-22 16:27:05.224987+00	\N	\N	\N	\N
3385b768-5a48-4a59-94d9-aa64e5d5fe47	55	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	qư	\N	\N	4197e6b8-7117-43bd-8619-b98cc8c56409	f	2026-07-22 16:26:37.534478+00	2026-07-22 16:26:37.534478+00	\N	\N	\N	\N
487c41fa-a73e-4c31-850e-1c92b8ffbfa7	62	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	sf	\N	\N	380668bf-34bb-4bc9-9bc4-530ba3e061b1	f	2026-07-22 16:26:47.388338+00	2026-07-22 16:26:47.388338+00	\N	\N	\N	\N
1939f3b7-3949-49a7-bb56-da1f47701791	68	5155729e-fd60-49ed-9150-23be8832b11b	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	TEXT	fa	\N	\N	47d76040-30b1-47c4-824c-0e7d9c75b061	f	2026-07-22 16:27:04.986698+00	2026-07-22 16:27:04.986698+00	\N	\N	\N	\N
5425f7ac-c1cd-41a3-b351-f9e1c46b3831	56	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	rfq	\N	\N	083e14b8-5146-4662-9080-339177157819	f	2026-07-22 16:26:37.737675+00	2026-07-22 16:26:37.737675+00	\N	\N	\N	\N
801d96a6-e645-422a-ae95-999f66b65726	57	5155729e-fd60-49ed-9150-23be8832b11b	08a8fef1-b65f-4b0d-b87f-fb883877e1db	TEXT	ừq	\N	\N	96ab95f5-b177-4c8f-b3a0-f5222d7065b3	f	2026-07-22 16:26:37.954129+00	2026-07-22 16:26:37.954129+00	\N	\N	\N	\N
26908e53-299a-4aec-a1ec-7fb9fa624f05	69	5155729e-fd60-49ed-9150-23be8832b11b	3e9643b4-7dd9-4823-ade9-a7d3cd2b9349	TEXT	f	\N	\N	731adbaf-65fe-4b94-b588-1ee208a499e3	f	2026-07-22 16:27:05.098052+00	2026-07-22 16:27:05.098052+00	\N	\N	\N	\N
\.


--
-- Data for Name: vai_tro; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.vai_tro (id, ten, mo_ta, tao_luc) FROM stdin;
fbac658c-ff72-46a6-9fec-84308ff3cb47	ADMIN	Quyền ADMIN	2026-07-22 11:16:02.057439+00
\.


--
-- Data for Name: yeu_cau_o_ghep; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.yeu_cau_o_ghep (id, khach_thue_id, hop_dong_id, trang_thai, loi_nhan, ghi_chu_tu_choi, tao_luc, cap_nhat_luc) FROM stdin;
\.


--
-- Name: tin_nhan_so_thu_tu_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tin_nhan_so_thu_tu_seq', 70, true);


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
-- Name: bao_cao_tin_nhan bao_cao_tin_nhan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bao_cao_tin_nhan
    ADD CONSTRAINT bao_cao_tin_nhan_pkey PRIMARY KEY (id);


--
-- Name: cau_hinh_gia cau_hinh_gia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cau_hinh_gia
    ADD CONSTRAINT cau_hinh_gia_pkey PRIMARY KEY (id);


--
-- Name: chan_nguoi_dung chan_nguoi_dung_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chan_nguoi_dung
    ADD CONSTRAINT chan_nguoi_dung_pkey PRIMARY KEY (id);


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
-- Name: contract_signature contract_signature_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contract_signature
    ADD CONSTRAINT contract_signature_pkey PRIMARY KEY (id);


--
-- Name: cuoc_tro_chuyen cuoc_tro_chuyen_khoa_duy_nhat_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuoc_tro_chuyen
    ADD CONSTRAINT cuoc_tro_chuyen_khoa_duy_nhat_key UNIQUE (khoa_duy_nhat);


--
-- Name: cuoc_tro_chuyen cuoc_tro_chuyen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuoc_tro_chuyen
    ADD CONSTRAINT cuoc_tro_chuyen_pkey PRIMARY KEY (id);


--
-- Name: dang_ky_push dang_ky_push_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dang_ky_push
    ADD CONSTRAINT dang_ky_push_pkey PRIMARY KEY (id);


--
-- Name: dat_coc_phong dat_coc_phong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dat_coc_phong
    ADD CONSTRAINT dat_coc_phong_pkey PRIMARY KEY (id);


--
-- Name: debt_reminder_log debt_reminder_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.debt_reminder_log
    ADD CONSTRAINT debt_reminder_log_pkey PRIMARY KEY (id);


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
-- Name: email_verification_token email_verification_token_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_verification_token
    ADD CONSTRAINT email_verification_token_token_key UNIQUE (token);


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
-- Name: invoice_generation_batch invoice_generation_batch_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_generation_batch
    ADD CONSTRAINT invoice_generation_batch_pkey PRIMARY KEY (id);


--
-- Name: invoice_generation_log invoice_generation_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_generation_log
    ADD CONSTRAINT invoice_generation_log_pkey PRIMARY KEY (id);


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
-- Name: kho_tai_san kho_tai_san_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kho_tai_san
    ADD CONSTRAINT kho_tai_san_pkey PRIMARY KEY (id);


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
-- Name: lich_su_kho_tai_san lich_su_kho_tai_san_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_kho_tai_san
    ADD CONSTRAINT lich_su_kho_tai_san_pkey PRIMARY KEY (id);


--
-- Name: lich_thanh_toan lich_thanh_toan_hop_dong_id_ky_nam_ky_thang_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_thanh_toan
    ADD CONSTRAINT lich_thanh_toan_hop_dong_id_ky_nam_ky_thang_key UNIQUE (hop_dong_id, ky_nam, ky_thang);


--
-- Name: lich_thanh_toan lich_thanh_toan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_thanh_toan
    ADD CONSTRAINT lich_thanh_toan_pkey PRIMARY KEY (id);


--
-- Name: login_history login_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_pkey PRIMARY KEY (id);


--
-- Name: meter_anomaly_alert meter_anomaly_alert_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meter_anomaly_alert
    ADD CONSTRAINT meter_anomaly_alert_pkey PRIMARY KEY (id);


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
-- Name: phuong_tien phuong_tien_ma_pt_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phuong_tien
    ADD CONSTRAINT phuong_tien_ma_pt_key UNIQUE (ma_pt);


--
-- Name: phuong_tien phuong_tien_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phuong_tien
    ADD CONSTRAINT phuong_tien_pkey PRIMARY KEY (id);


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
-- Name: tai_san_phong tai_san_phong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tai_san_phong
    ADD CONSTRAINT tai_san_phong_pkey PRIMARY KEY (id);


--
-- Name: tang tang_nha_tro_id_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tang
    ADD CONSTRAINT tang_nha_tro_id_id_key UNIQUE (nha_tro_id, id);


--
-- Name: tang tang_nha_tro_id_so_tang_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tang
    ADD CONSTRAINT tang_nha_tro_id_so_tang_key UNIQUE (nha_tro_id, so_tang);


--
-- Name: tang tang_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tang
    ADD CONSTRAINT tang_pkey PRIMARY KEY (id);


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
-- Name: thanh_vien_cuoc_tro_chuyen thanh_vien_cuoc_tro_chuyen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_vien_cuoc_tro_chuyen
    ADD CONSTRAINT thanh_vien_cuoc_tro_chuyen_pkey PRIMARY KEY (id);


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
-- Name: tin_nhan tin_nhan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan
    ADD CONSTRAINT tin_nhan_pkey PRIMARY KEY (id);


--
-- Name: tin_nhan tin_nhan_so_thu_tu_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan
    ADD CONSTRAINT tin_nhan_so_thu_tu_key UNIQUE (so_thu_tu);


--
-- Name: bao_cao_tin_nhan uq_bao_cao_tin_nhan; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bao_cao_tin_nhan
    ADD CONSTRAINT uq_bao_cao_tin_nhan UNIQUE (tin_nhan_id, nguoi_bao_cao_id);


--
-- Name: chan_nguoi_dung uq_chan_nguoi_dung; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chan_nguoi_dung
    ADD CONSTRAINT uq_chan_nguoi_dung UNIQUE (nguoi_chan_id, nguoi_bi_chan_id);


--
-- Name: dang_ky_push uq_dang_ky_push_endpoint; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dang_ky_push
    ADD CONSTRAINT uq_dang_ky_push_endpoint UNIQUE (endpoint);


--
-- Name: thanh_vien_cuoc_tro_chuyen uq_thanh_vien_cuoc_tro_chuyen; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_vien_cuoc_tro_chuyen
    ADD CONSTRAINT uq_thanh_vien_cuoc_tro_chuyen UNIQUE (cuoc_tro_chuyen_id, nguoi_dung_id);


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
-- Name: yeu_cau_o_ghep yeu_cau_o_ghep_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.yeu_cau_o_ghep
    ADD CONSTRAINT yeu_cau_o_ghep_pkey PRIMARY KEY (id);


--
-- Name: idx_audit_log_target; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_log_target ON public.audit_log USING btree (bang_tac_dong, ban_ghi_id);


--
-- Name: idx_bao_cao_cho_xu_ly; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bao_cao_cho_xu_ly ON public.bao_cao_tin_nhan USING btree (tao_luc DESC) WHERE (trang_thai = 'PENDING'::public.trang_thai_bao_cao);


--
-- Name: idx_cau_hinh_gia_nha_tro; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cau_hinh_gia_nha_tro ON public.cau_hinh_gia USING btree (nha_tro_id, loai, dang_ap_dung);


--
-- Name: idx_chan_theo_nguoi_bi_chan; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chan_theo_nguoi_bi_chan ON public.chan_nguoi_dung USING btree (nguoi_bi_chan_id);


--
-- Name: idx_chi_so_phong_ky; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chi_so_phong_ky ON public.chi_so_dien_nuoc USING btree (phong_id, loai, ky_nam, ky_thang);


--
-- Name: idx_cthd_hoa_don; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cthd_hoa_don ON public.chi_tiet_hoa_don USING btree (hoa_don_id);


--
-- Name: idx_cuoc_tro_chuyen_nha_tro; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cuoc_tro_chuyen_nha_tro ON public.cuoc_tro_chuyen USING btree (nha_tro_id) WHERE (xoa_luc IS NULL);


--
-- Name: idx_cuoc_tro_chuyen_tin_cuoi; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cuoc_tro_chuyen_tin_cuoi ON public.cuoc_tro_chuyen USING btree (tin_nhan_cuoi_luc DESC) WHERE (xoa_luc IS NULL);


--
-- Name: idx_dang_ky_push_nguoi_dung; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dang_ky_push_nguoi_dung ON public.dang_ky_push USING btree (nguoi_dung_id) WHERE (dung_luc IS NULL);


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
-- Name: idx_lich_thanh_toan_han; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lich_thanh_toan_han ON public.lich_thanh_toan USING btree (han_thanh_toan, trang_thai) WHERE (xoa_luc IS NULL);


--
-- Name: idx_lich_thanh_toan_hop_dong; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lich_thanh_toan_hop_dong ON public.lich_thanh_toan USING btree (hop_dong_id, ky_nam, ky_thang) WHERE (xoa_luc IS NULL);


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
-- Name: idx_nha_tro_location_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nha_tro_location_active ON public.nha_tro USING btree (vi_do, kinh_do) WHERE ((xoa_luc IS NULL) AND (vi_do IS NOT NULL) AND (kinh_do IS NOT NULL));


--
-- Name: idx_phong_nha_tro; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_phong_nha_tro ON public.phong USING btree (nha_tro_id);


--
-- Name: idx_phong_nha_tro_tang; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_phong_nha_tro_tang ON public.phong USING btree (nha_tro_id, tang, ten) WHERE (xoa_luc IS NULL);


--
-- Name: idx_phong_tang_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_phong_tang_id ON public.phong USING btree (tang_id) WHERE (xoa_luc IS NULL);


--
-- Name: idx_phong_trang_thai; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_phong_trang_thai ON public.phong USING btree (trang_thai);


--
-- Name: idx_su_co_phong_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_su_co_phong_status ON public.su_co USING btree (phong_id, trang_thai);


--
-- Name: idx_tang_nha_tro_so_tang; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tang_nha_tro_so_tang ON public.tang USING btree (nha_tro_id, so_tang) WHERE (xoa_luc IS NULL);


--
-- Name: idx_thanh_toan_hoa_don; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_thanh_toan_hoa_don ON public.thanh_toan USING btree (hoa_don_id);


--
-- Name: idx_thanh_toan_ref; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_thanh_toan_ref ON public.thanh_toan USING btree (ma_tham_chieu);


--
-- Name: idx_thanh_vien_nguoi_dung; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_thanh_vien_nguoi_dung ON public.thanh_vien_cuoc_tro_chuyen USING btree (nguoi_dung_id, roi_luc);


--
-- Name: idx_thong_bao_recipient; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_thong_bao_recipient ON public.thong_bao_nguoi_nhan USING btree (nguoi_dung_id, da_doc);


--
-- Name: idx_tin_nhan_co_lien_ket; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tin_nhan_co_lien_ket ON public.tin_nhan USING btree (cuoc_tro_chuyen_id, so_thu_tu DESC) WHERE ((noi_dung IS NOT NULL) AND (xoa_luc IS NULL) AND (da_thu_hoi = false));


--
-- Name: idx_tin_nhan_dinh_kem; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tin_nhan_dinh_kem ON public.tin_nhan USING btree (cuoc_tro_chuyen_id, so_thu_tu DESC) WHERE ((file_media_id IS NOT NULL) AND (xoa_luc IS NULL) AND (da_thu_hoi = false));


--
-- Name: idx_tin_nhan_ghim; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tin_nhan_ghim ON public.tin_nhan USING btree (cuoc_tro_chuyen_id, ghim_luc DESC) WHERE ((ghim_luc IS NOT NULL) AND (xoa_luc IS NULL));


--
-- Name: idx_tin_nhan_hoi_thoai_seq; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tin_nhan_hoi_thoai_seq ON public.tin_nhan USING btree (cuoc_tro_chuyen_id, so_thu_tu DESC);


--
-- Name: idx_tin_nhan_noi_dung_trgm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tin_nhan_noi_dung_trgm ON public.tin_nhan USING gin (public.f_khong_dau(noi_dung) public.gin_trgm_ops) WHERE ((xoa_luc IS NULL) AND (da_thu_hoi = false) AND (noi_dung IS NOT NULL));


--
-- Name: idx_tvhd_hop_dong; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tvhd_hop_dong ON public.thanh_vien_hop_dong USING btree (hop_dong_id);


--
-- Name: uq_tin_nhan_ma_client; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_tin_nhan_ma_client ON public.tin_nhan USING btree (cuoc_tro_chuyen_id, ma_client) WHERE (ma_client IS NOT NULL);


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
-- Name: bao_cao_tin_nhan bao_cao_tin_nhan_cuoc_tro_chuyen_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bao_cao_tin_nhan
    ADD CONSTRAINT bao_cao_tin_nhan_cuoc_tro_chuyen_id_fkey FOREIGN KEY (cuoc_tro_chuyen_id) REFERENCES public.cuoc_tro_chuyen(id) ON DELETE CASCADE;


--
-- Name: bao_cao_tin_nhan bao_cao_tin_nhan_nguoi_bao_cao_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bao_cao_tin_nhan
    ADD CONSTRAINT bao_cao_tin_nhan_nguoi_bao_cao_id_fkey FOREIGN KEY (nguoi_bao_cao_id) REFERENCES public.nguoi_dung(id);


--
-- Name: bao_cao_tin_nhan bao_cao_tin_nhan_nguoi_xu_ly_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bao_cao_tin_nhan
    ADD CONSTRAINT bao_cao_tin_nhan_nguoi_xu_ly_id_fkey FOREIGN KEY (nguoi_xu_ly_id) REFERENCES public.nguoi_dung(id);


--
-- Name: bao_cao_tin_nhan bao_cao_tin_nhan_tin_nhan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bao_cao_tin_nhan
    ADD CONSTRAINT bao_cao_tin_nhan_tin_nhan_id_fkey FOREIGN KEY (tin_nhan_id) REFERENCES public.tin_nhan(id) ON DELETE CASCADE;


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
-- Name: chan_nguoi_dung chan_nguoi_dung_nguoi_bi_chan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chan_nguoi_dung
    ADD CONSTRAINT chan_nguoi_dung_nguoi_bi_chan_id_fkey FOREIGN KEY (nguoi_bi_chan_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: chan_nguoi_dung chan_nguoi_dung_nguoi_chan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chan_nguoi_dung
    ADD CONSTRAINT chan_nguoi_dung_nguoi_chan_id_fkey FOREIGN KEY (nguoi_chan_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


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
-- Name: cuoc_tro_chuyen cuoc_tro_chuyen_nguoi_tao_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuoc_tro_chuyen
    ADD CONSTRAINT cuoc_tro_chuyen_nguoi_tao_id_fkey FOREIGN KEY (nguoi_tao_id) REFERENCES public.nguoi_dung(id);


--
-- Name: cuoc_tro_chuyen cuoc_tro_chuyen_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuoc_tro_chuyen
    ADD CONSTRAINT cuoc_tro_chuyen_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id);


--
-- Name: cuoc_tro_chuyen cuoc_tro_chuyen_tang_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuoc_tro_chuyen
    ADD CONSTRAINT cuoc_tro_chuyen_tang_id_fkey FOREIGN KEY (tang_id) REFERENCES public.tang(id);


--
-- Name: dang_ky_push dang_ky_push_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dang_ky_push
    ADD CONSTRAINT dang_ky_push_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


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
-- Name: email_verification_token email_verification_token_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_verification_token
    ADD CONSTRAINT email_verification_token_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: file_media file_media_nguoi_tai_len_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_media
    ADD CONSTRAINT file_media_nguoi_tai_len_id_fkey FOREIGN KEY (nguoi_tai_len_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: meter_anomaly_alert fk_anomaly_chi_so; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meter_anomaly_alert
    ADD CONSTRAINT fk_anomaly_chi_so FOREIGN KEY (chi_so_id) REFERENCES public.chi_so_dien_nuoc(id) ON DELETE CASCADE;


--
-- Name: meter_anomaly_alert fk_anomaly_hop_dong; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meter_anomaly_alert
    ADD CONSTRAINT fk_anomaly_hop_dong FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE SET NULL;


--
-- Name: meter_anomaly_alert fk_anomaly_phong; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meter_anomaly_alert
    ADD CONSTRAINT fk_anomaly_phong FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE CASCADE;


--
-- Name: meter_anomaly_alert fk_anomaly_resolved_by; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meter_anomaly_alert
    ADD CONSTRAINT fk_anomaly_resolved_by FOREIGN KEY (resolved_by) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: chi_tiet_hoa_don fk_cthd_su_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_tiet_hoa_don
    ADD CONSTRAINT fk_cthd_su_co FOREIGN KEY (su_co_id) REFERENCES public.su_co(id) ON DELETE SET NULL;


--
-- Name: dat_coc_phong fk_dat_coc_hop_dong; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dat_coc_phong
    ADD CONSTRAINT fk_dat_coc_hop_dong FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE SET NULL;


--
-- Name: dat_coc_phong fk_dat_coc_nguoi_xac_nhan; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dat_coc_phong
    ADD CONSTRAINT fk_dat_coc_nguoi_xac_nhan FOREIGN KEY (nguoi_xac_nhan_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: invoice_generation_batch fk_invoice_batch_nguoi_tao; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_generation_batch
    ADD CONSTRAINT fk_invoice_batch_nguoi_tao FOREIGN KEY (nguoi_tao_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: invoice_generation_batch fk_invoice_batch_nha_tro; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_generation_batch
    ADD CONSTRAINT fk_invoice_batch_nha_tro FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE SET NULL;


--
-- Name: invoice_generation_log fk_invoice_log_batch; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_generation_log
    ADD CONSTRAINT fk_invoice_log_batch FOREIGN KEY (batch_id) REFERENCES public.invoice_generation_batch(id) ON DELETE CASCADE;


--
-- Name: invoice_generation_log fk_invoice_log_hoa_don; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_generation_log
    ADD CONSTRAINT fk_invoice_log_hoa_don FOREIGN KEY (hoa_don_id) REFERENCES public.hoa_don(id) ON DELETE SET NULL;


--
-- Name: invoice_generation_log fk_invoice_log_hop_dong; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_generation_log
    ADD CONSTRAINT fk_invoice_log_hop_dong FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE SET NULL;


--
-- Name: tin_nhan fk_tin_nhan_chuyen_tiep_tu; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan
    ADD CONSTRAINT fk_tin_nhan_chuyen_tiep_tu FOREIGN KEY (chuyen_tiep_tu_id) REFERENCES public.tin_nhan(id) ON DELETE SET NULL;


--
-- Name: tin_nhan fk_tin_nhan_nguoi_ghim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan
    ADD CONSTRAINT fk_tin_nhan_nguoi_ghim FOREIGN KEY (nguoi_ghim_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: yeu_cau_o_ghep fk_ycog_hop_dong; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.yeu_cau_o_ghep
    ADD CONSTRAINT fk_ycog_hop_dong FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id);


--
-- Name: yeu_cau_o_ghep fk_ycog_khach_thue; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.yeu_cau_o_ghep
    ADD CONSTRAINT fk_ycog_khach_thue FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id);


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
-- Name: kho_tai_san kho_tai_san_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kho_tai_san
    ADD CONSTRAINT kho_tai_san_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id);


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
-- Name: lich_su_kho_tai_san lich_su_kho_tai_san_kho_tai_san_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_kho_tai_san
    ADD CONSTRAINT lich_su_kho_tai_san_kho_tai_san_id_fkey FOREIGN KEY (kho_tai_san_id) REFERENCES public.kho_tai_san(id);


--
-- Name: lich_su_kho_tai_san lich_su_kho_tai_san_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_kho_tai_san
    ADD CONSTRAINT lich_su_kho_tai_san_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id);


--
-- Name: lich_thanh_toan lich_thanh_toan_hoa_don_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_thanh_toan
    ADD CONSTRAINT lich_thanh_toan_hoa_don_id_fkey FOREIGN KEY (hoa_don_id) REFERENCES public.hoa_don(id) ON DELETE SET NULL;


--
-- Name: lich_thanh_toan lich_thanh_toan_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_thanh_toan
    ADD CONSTRAINT lich_thanh_toan_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE CASCADE;


--
-- Name: login_history login_history_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


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
-- Name: phong phong_nha_tro_id_tang_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phong
    ADD CONSTRAINT phong_nha_tro_id_tang_id_fkey FOREIGN KEY (nha_tro_id, tang_id) REFERENCES public.tang(nha_tro_id, id) ON DELETE RESTRICT;


--
-- Name: phong phong_tang_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phong
    ADD CONSTRAINT phong_tang_id_fkey FOREIGN KEY (tang_id) REFERENCES public.tang(id) ON DELETE SET NULL;


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
-- Name: phuong_tien phuong_tien_chu_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phuong_tien
    ADD CONSTRAINT phuong_tien_chu_tro_id_fkey FOREIGN KEY (chu_tro_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: phuong_tien phuong_tien_khach_thue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phuong_tien
    ADD CONSTRAINT phuong_tien_khach_thue_id_fkey FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id) ON DELETE SET NULL;


--
-- Name: phuong_tien phuong_tien_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phuong_tien
    ADD CONSTRAINT phuong_tien_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE CASCADE;


--
-- Name: phuong_tien phuong_tien_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phuong_tien
    ADD CONSTRAINT phuong_tien_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE SET NULL;


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
-- Name: tai_san_phong tai_san_phong_kho_tai_san_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tai_san_phong
    ADD CONSTRAINT tai_san_phong_kho_tai_san_id_fkey FOREIGN KEY (kho_tai_san_id) REFERENCES public.kho_tai_san(id);


--
-- Name: tai_san_phong tai_san_phong_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tai_san_phong
    ADD CONSTRAINT tai_san_phong_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id);


--
-- Name: tang tang_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tang
    ADD CONSTRAINT tang_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE CASCADE;


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
-- Name: thanh_vien_cuoc_tro_chuyen thanh_vien_cuoc_tro_chuyen_cuoc_tro_chuyen_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_vien_cuoc_tro_chuyen
    ADD CONSTRAINT thanh_vien_cuoc_tro_chuyen_cuoc_tro_chuyen_id_fkey FOREIGN KEY (cuoc_tro_chuyen_id) REFERENCES public.cuoc_tro_chuyen(id) ON DELETE CASCADE;


--
-- Name: thanh_vien_cuoc_tro_chuyen thanh_vien_cuoc_tro_chuyen_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_vien_cuoc_tro_chuyen
    ADD CONSTRAINT thanh_vien_cuoc_tro_chuyen_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id);


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
-- Name: tin_nhan tin_nhan_cuoc_tro_chuyen_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan
    ADD CONSTRAINT tin_nhan_cuoc_tro_chuyen_id_fkey FOREIGN KEY (cuoc_tro_chuyen_id) REFERENCES public.cuoc_tro_chuyen(id) ON DELETE CASCADE;


--
-- Name: tin_nhan tin_nhan_file_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan
    ADD CONSTRAINT tin_nhan_file_media_id_fkey FOREIGN KEY (file_media_id) REFERENCES public.file_media(id);


--
-- Name: tin_nhan tin_nhan_nguoi_gui_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan
    ADD CONSTRAINT tin_nhan_nguoi_gui_id_fkey FOREIGN KEY (nguoi_gui_id) REFERENCES public.nguoi_dung(id);


--
-- Name: tin_nhan tin_nhan_tra_loi_cho_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan
    ADD CONSTRAINT tin_nhan_tra_loi_cho_id_fkey FOREIGN KEY (tra_loi_cho_id) REFERENCES public.tin_nhan(id);


--
-- Name: audit_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

--
-- Name: bank_transaction; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.bank_transaction ENABLE ROW LEVEL SECURITY;

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
-- Name: contract_signature; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.contract_signature ENABLE ROW LEVEL SECURITY;

--
-- Name: dat_coc_phong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.dat_coc_phong ENABLE ROW LEVEL SECURITY;

--
-- Name: debt_reminder_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.debt_reminder_log ENABLE ROW LEVEL SECURITY;

--
-- Name: dich_vu; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.dich_vu ENABLE ROW LEVEL SECURITY;

--
-- Name: dich_vu_hop_dong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.dich_vu_hop_dong ENABLE ROW LEVEL SECURITY;

--
-- Name: email_verification_token; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.email_verification_token ENABLE ROW LEVEL SECURITY;

--
-- Name: file_media; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.file_media ENABLE ROW LEVEL SECURITY;

--
-- Name: hoa_don; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hoa_don ENABLE ROW LEVEL SECURITY;

--
-- Name: hop_dong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hop_dong ENABLE ROW LEVEL SECURITY;

--
-- Name: invoice_generation_batch; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.invoice_generation_batch ENABLE ROW LEVEL SECURITY;

--
-- Name: invoice_generation_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.invoice_generation_log ENABLE ROW LEVEL SECURITY;

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
-- Name: lich_thanh_toan; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lich_thanh_toan ENABLE ROW LEVEL SECURITY;

--
-- Name: login_history; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.login_history ENABLE ROW LEVEL SECURITY;

--
-- Name: meter_anomaly_alert; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.meter_anomaly_alert ENABLE ROW LEVEL SECURITY;

--
-- Name: nguoi_dung; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nguoi_dung ENABLE ROW LEVEL SECURITY;

--
-- Name: nguoi_dung_nha_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nguoi_dung_nha_tro ENABLE ROW LEVEL SECURITY;

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
-- Name: phu_luc_hop_dong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.phu_luc_hop_dong ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_token; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.refresh_token ENABLE ROW LEVEL SECURITY;

--
-- Name: su_co; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.su_co ENABLE ROW LEVEL SECURITY;

--
-- Name: tang; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tang ENABLE ROW LEVEL SECURITY;

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
-- Name: thong_bao_nguoi_nhan; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.thong_bao_nguoi_nhan ENABLE ROW LEVEL SECURITY;

--
-- Name: tien_ich; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tien_ich ENABLE ROW LEVEL SECURITY;

--
-- Name: vai_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.vai_tro ENABLE ROW LEVEL SECURITY;

--
-- PostgreSQL database dump complete
--

\unrestrict Z14RVxZAb6W4gWqMgxekFkdba5CzAb48x1cA5B2xhcLnuh3R4pjLhpB3FbjyMsh

