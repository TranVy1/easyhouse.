-- EasyHouse production schema for PostgreSQL/Supabase.
-- Target: real rental property management with Supabase Auth, RLS, billing,
-- payments, debt carry-over, maintenance, media, and audit support.
--
-- Deploy on Supabase with the SQL editor or migrations. This schema assumes
-- Supabase provides auth.users and auth.uid().

CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "btree_gist";
-- 1. DROP CÁC BẢNG CŨ (Sử dụng CASCADE để xóa luôn các khóa ngoại liên quan)
DROP TABLE IF EXISTS public.audit_log CASCADE;
DROP TABLE IF EXISTS public.thong_bao_nguoi_nhan CASCADE;
DROP TABLE IF EXISTS public.thong_bao CASCADE;
DROP TABLE IF EXISTS public.file_media CASCADE;
DROP TABLE IF EXISTS public.lich_hen CASCADE;
DROP TABLE IF EXISTS public.su_co CASCADE;
DROP TABLE IF EXISTS public.bank_transaction CASCADE;
DROP TABLE IF EXISTS public.lich_su_hoa_don CASCADE;
DROP TABLE IF EXISTS public.thanh_toan CASCADE;
DROP TABLE IF EXISTS public.chi_tiet_hoa_don CASCADE;
DROP TABLE IF EXISTS public.hoa_don CASCADE;
DROP TABLE IF EXISTS public.chi_so_dien_nuoc CASCADE;
DROP TABLE IF EXISTS public.dich_vu_hop_dong CASCADE;
DROP TABLE IF EXISTS public.cau_hinh_gia CASCADE;
DROP TABLE IF EXISTS public.dich_vu CASCADE;
DROP TABLE IF EXISTS public.dat_coc_phong CASCADE;
DROP TABLE IF EXISTS public.phu_luc_hop_dong CASCADE;
DROP TABLE IF EXISTS public.thanh_vien_hop_dong CASCADE;
DROP TABLE IF EXISTS public.hop_dong CASCADE;
DROP TABLE IF EXISTS public.khach_thue CASCADE;
DROP TABLE IF EXISTS public.phong_tien_ich CASCADE;
DROP TABLE IF EXISTS public.tien_ich CASCADE;
DROP TABLE IF EXISTS public.phong CASCADE;
DROP TABLE IF EXISTS public.nguoi_dung_nha_tro CASCADE;
DROP TABLE IF EXISTS public.nha_tro CASCADE;
DROP TABLE IF EXISTS public.login_history CASCADE;
DROP TABLE IF EXISTS public.nguoi_dung_vai_tro CASCADE;
DROP TABLE IF EXISTS public.vai_tro CASCADE;
DROP TABLE IF EXISTS public.nguoi_dung CASCADE;

-- Bổ sung drop các bảng rác từ bản cũ nếu có
DROP TABLE IF EXISTS public.chi_so_dien CASCADE;
DROP TABLE IF EXISTS public.chi_so_nuoc CASCADE;
DROP TABLE IF EXISTS public.nhan_vien_nha_tro CASCADE;
DROP TABLE IF EXISTS public.email_verification_token CASCADE;

-- 2. DROP CÁC ENUM TYPE CŨ
DROP TYPE IF EXISTS public.vai_tro_he_thong CASCADE;
DROP TYPE IF EXISTS public.trang_thai_nguoi_dung CASCADE;
DROP TYPE IF EXISTS public.trang_thai_phong CASCADE;
DROP TYPE IF EXISTS public.trang_thai_hop_dong CASCADE;
DROP TYPE IF EXISTS public.trang_thai_coc_hop_dong CASCADE;
DROP TYPE IF EXISTS public.trang_thai_hoa_don CASCADE;
DROP TYPE IF EXISTS public.loai_muc_hoa_don CASCADE;
DROP TYPE IF EXISTS public.trang_thai_thanh_toan CASCADE;
DROP TYPE IF EXISTS public.phuong_thuc_thanh_toan CASCADE;
DROP TYPE IF EXISTS public.loai_chi_so CASCADE;
DROP TYPE IF EXISTS public.trang_thai_chi_so CASCADE;
DROP TYPE IF EXISTS public.loai_tinh_phi CASCADE;
DROP TYPE IF EXISTS public.trang_thai_dat_coc CASCADE;
DROP TYPE IF EXISTS public.loai_su_co_enum CASCADE;
DROP TYPE IF EXISTS public.uu_tien_enum CASCADE;
DROP TYPE IF EXISTS public.trang_thai_su_co CASCADE;
DROP TYPE IF EXISTS public.trang_thai_lich_hen CASCADE;
DROP TYPE IF EXISTS public.loai_doi_tuong_media CASCADE;
DROP TYPE IF EXISTS public.loai_thong_bao CASCADE;
DROP TYPE IF EXISTS public.kenh_thong_bao CASCADE;

-- ========================================================================
-- 1. ENUMS
-- ========================================================================

CREATE TYPE public.vai_tro_he_thong AS ENUM (
    'ADMIN', 'LANDLORD', 'STAFF', 'TENANT'
);

CREATE TYPE public.trang_thai_nguoi_dung AS ENUM (
    'ACTIVE', 'INACTIVE', 'BANNED'
);

CREATE TYPE public.trang_thai_phong AS ENUM (
    'AVAILABLE', 'RENTED', 'MAINTENANCE', 'RESERVED', 'INACTIVE'
);

CREATE TYPE public.trang_thai_hop_dong AS ENUM (
    'DRAFT', 'PENDING', 'ACTIVE', 'EXPIRED', 'TERMINATED', 'CANCELLED'
);

CREATE TYPE public.trang_thai_coc_hop_dong AS ENUM (
    'NOT_PAID', 'KEPT', 'REFUNDED', 'DEDUCTED', 'FORFEITED'
);

CREATE TYPE public.trang_thai_hoa_don AS ENUM (
    'DRAFT', 'UNPAID', 'PARTIAL', 'PAID', 'OVERPAID', 'OVERDUE', 'CANCELLED'
);

CREATE TYPE public.loai_muc_hoa_don AS ENUM (
    'ROOM', 'ELECTRICITY', 'WATER', 'SERVICE', 'INTERNET', 'GARBAGE',
    'PARKING', 'MAINTENANCE', 'DEBT', 'DISCOUNT', 'OTHER'
);

CREATE TYPE public.trang_thai_thanh_toan AS ENUM (
    'PENDING', 'SUCCESS', 'FAILED', 'CANCELLED', 'REFUNDED'
);

CREATE TYPE public.phuong_thuc_thanh_toan AS ENUM (
    'CASH', 'BANK_TRANSFER', 'VIETQR', 'MOMO', 'ZALOPAY', 'OTHER'
);

CREATE TYPE public.loai_chi_so AS ENUM (
    'ELECTRICITY', 'WATER'
);

CREATE TYPE public.trang_thai_chi_so AS ENUM (
    'DRAFT', 'CONFIRMED', 'BILLED', 'CANCELLED'
);

CREATE TYPE public.loai_tinh_phi AS ENUM (
    'FIXED', 'PER_PERSON', 'PER_ROOM', 'PER_UNIT', 'PERCENT'
);

CREATE TYPE public.trang_thai_dat_coc AS ENUM (
    'PENDING', 'COMPLETED', 'REFUNDED', 'FORFEITED', 'CANCELLED'
);

CREATE TYPE public.loai_su_co_enum AS ENUM (
    'dien_nuoc', 'noi_that', 've_sinh', 'an_ninh', 'internet', 'khac'
);

CREATE TYPE public.uu_tien_enum AS ENUM (
    'thap', 'trung_binh', 'cao', 'khan_cap'
);

CREATE TYPE public.trang_thai_su_co AS ENUM (
    'PENDING', 'IN_PROGRESS', 'RESOLVED', 'CANCELLED'
);

CREATE TYPE public.trang_thai_lich_hen AS ENUM (
    'PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED', 'NO_SHOW'
);

CREATE TYPE public.loai_doi_tuong_media AS ENUM (
    'USER', 'TENANT', 'ROOM', 'CONTRACT', 'INVOICE', 'PAYMENT',
    'INCIDENT', 'METER_READING', 'APPOINTMENT', 'OTHER'
);

CREATE TYPE public.loai_thong_bao AS ENUM (
    'SYSTEM', 'INVOICE', 'PAYMENT', 'CONTRACT', 'INCIDENT', 'APPOINTMENT', 'DEBT'
);

CREATE TYPE public.kenh_thong_bao AS ENUM (
    'IN_APP', 'EMAIL', 'SMS', 'ZALO', 'TELEGRAM', 'PUSH'
);

