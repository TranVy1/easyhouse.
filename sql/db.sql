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

-- ========================================================================
-- 2. CORE IDENTITY AND AUTHORIZATION
-- ========================================================================

CREATE TABLE public.nguoi_dung (
    id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email varchar(255) NOT NULL UNIQUE,
    ho_ten varchar(255) NOT NULL,
    so_dien_thoai varchar(20) UNIQUE,
    anh_dai_dien text,
    ngay_sinh date,
    gioi_tinh varchar(20),
    dia_chi text,
    que_quan varchar(255),
    so_cccd varchar(50) UNIQUE,
    trang_thai public.trang_thai_nguoi_dung NOT NULL DEFAULT 'ACTIVE',
    so_lan_dang_nhap_sai integer NOT NULL DEFAULT 0,
    khoa_den_luc timestamptz,
    lan_dang_nhap_cuoi timestamptz,
    cau_hinh_2fa jsonb,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    xoa_luc timestamptz,
    CONSTRAINT chk_nguoi_dung_email_lower CHECK (email = lower(email)),
    CONSTRAINT chk_nguoi_dung_login_fail CHECK (so_lan_dang_nhap_sai >= 0)
);

CREATE TABLE public.vai_tro (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    ten public.vai_tro_he_thong NOT NULL UNIQUE,
    mo_ta text,
    tao_luc timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.nguoi_dung_vai_tro (
    nguoi_dung_id uuid NOT NULL REFERENCES public.nguoi_dung(id) ON DELETE CASCADE,
    vai_tro_id uuid NOT NULL REFERENCES public.vai_tro(id) ON DELETE CASCADE,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (nguoi_dung_id, vai_tro_id)
);

CREATE TABLE public.login_history (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nguoi_dung_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    email varchar(255),
    thanh_cong boolean NOT NULL,
    ip_address inet,
    user_agent text,
    ly_do_that_bai text,
    tao_luc timestamptz NOT NULL DEFAULT now()
);

-- ========================================================================
-- 3. PROPERTY, ROOMS, STAFF ASSIGNMENT
-- ========================================================================

CREATE TABLE public.nha_tro (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    chu_tro_id uuid NOT NULL REFERENCES public.nguoi_dung(id) ON DELETE RESTRICT,
    ten varchar(255) NOT NULL,
    dia_chi text NOT NULL,
    so_nha varchar(100),
    duong varchar(255),
    phuong varchar(100),
    quan varchar(100),
    thanh_pho varchar(100),
    mo_ta text,
    tien_nghi_chung text,
    noi_quy text,
    trang_thai varchar(30) NOT NULL DEFAULT 'ACTIVE',
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    xoa_luc timestamptz
);

CREATE TABLE public.nguoi_dung_nha_tro (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nguoi_dung_id uuid NOT NULL REFERENCES public.nguoi_dung(id) ON DELETE CASCADE,
    nha_tro_id uuid NOT NULL REFERENCES public.nha_tro(id) ON DELETE CASCADE,
    vai_tro public.vai_tro_he_thong NOT NULL,
    co_quyen_xem boolean NOT NULL DEFAULT true,
    co_quyen_sua boolean NOT NULL DEFAULT false,
    co_quyen_thu_tien boolean NOT NULL DEFAULT false,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    UNIQUE (nguoi_dung_id, nha_tro_id, vai_tro),
    CONSTRAINT chk_ndnt_role CHECK (vai_tro IN ('LANDLORD', 'STAFF'))
);

CREATE TABLE public.phong (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nha_tro_id uuid NOT NULL REFERENCES public.nha_tro(id) ON DELETE CASCADE,
    ten varchar(100) NOT NULL,
    khu_vuc varchar(50),
    tang integer,
    dien_tich numeric(10,2) NOT NULL,
    so_nguoi_toi_da integer NOT NULL DEFAULT 2,
    trang_thai public.trang_thai_phong NOT NULL DEFAULT 'AVAILABLE',
    gia_hien_tai numeric(15,2) NOT NULL,
    tien_coc_mac_dinh numeric(15,2) NOT NULL DEFAULT 0,
    mo_ta text,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    xoa_luc timestamptz,
    UNIQUE (nha_tro_id, ten),
    CONSTRAINT chk_phong_dien_tich CHECK (dien_tich > 0),
    CONSTRAINT chk_phong_so_nguoi CHECK (so_nguoi_toi_da > 0),
    CONSTRAINT chk_phong_gia CHECK (gia_hien_tai >= 0 AND tien_coc_mac_dinh >= 0)
);

CREATE TABLE public.tien_ich (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    ten varchar(100) NOT NULL UNIQUE,
    bieu_tuong varchar(100),
    tao_luc timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.phong_tien_ich (
    phong_id uuid NOT NULL REFERENCES public.phong(id) ON DELETE CASCADE,
    tien_ich_id uuid NOT NULL REFERENCES public.tien_ich(id) ON DELETE CASCADE,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (phong_id, tien_ich_id)
);

-- ========================================================================
-- 4. TENANTS, CONTRACTS, DEPOSITS
-- ========================================================================

CREATE TABLE public.khach_thue (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nguoi_dung_id uuid UNIQUE REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    chu_tro_id uuid NOT NULL REFERENCES public.nguoi_dung(id) ON DELETE RESTRICT,
    ho_ten varchar(255) NOT NULL,
    so_dien_thoai varchar(20),
    email varchar(255),
    so_cccd varchar(50),
    ngay_sinh date,
    gioi_tinh varchar(20),
    dia_chi text,
    que_quan varchar(255),
    nghe_nghiep varchar(255),
    ghi_chu text,
    dang_hoat_dong boolean NOT NULL DEFAULT true,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    xoa_luc timestamptz,
    UNIQUE (chu_tro_id, so_cccd)
);

CREATE TABLE public.hop_dong (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    phong_id uuid NOT NULL REFERENCES public.phong(id) ON DELETE RESTRICT,
    khach_thue_id uuid NOT NULL REFERENCES public.khach_thue(id) ON DELETE RESTRICT,
    ma_hop_dong varchar(100) NOT NULL UNIQUE,
    ngay_bat_dau date NOT NULL,
    ngay_ket_thuc date NOT NULL,
    ngay_ket_thuc_thuc_te date,
    gia_thue_hop_dong numeric(15,2) NOT NULL,
    tien_coc numeric(15,2) NOT NULL DEFAULT 0,
    trang_thai_coc public.trang_thai_coc_hop_dong NOT NULL DEFAULT 'NOT_PAID',
    trang_thai public.trang_thai_hop_dong NOT NULL DEFAULT 'DRAFT',
    chu_ky_thanh_toan varchar(30) NOT NULL DEFAULT 'MONTHLY',
    ngay_thanh_toan_hang_thang integer NOT NULL DEFAULT 5,
    tu_dong_gia_han boolean NOT NULL DEFAULT false,
    chi_so_dien_ban_dau integer,
    chi_so_nuoc_ban_dau integer,
    noi_dung_hop_dong text,
    file_pdf text,
    ghi_chu text,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    xoa_luc timestamptz,
    CONSTRAINT chk_hop_dong_ngay CHECK (ngay_ket_thuc > ngay_bat_dau),
    CONSTRAINT chk_hop_dong_ngay_thanh_toan CHECK (ngay_thanh_toan_hang_thang BETWEEN 1 AND 31),
    CONSTRAINT chk_hop_dong_tien CHECK (gia_thue_hop_dong >= 0 AND tien_coc >= 0),
    CONSTRAINT chk_hop_dong_chi_so CHECK (
        (chi_so_dien_ban_dau IS NULL OR chi_so_dien_ban_dau >= 0)
        AND (chi_so_nuoc_ban_dau IS NULL OR chi_so_nuoc_ban_dau >= 0)
    )
);

-- Prevent overlapping active/pending contracts for the same room.
ALTER TABLE public.hop_dong
ADD CONSTRAINT excl_hop_dong_phong_active_overlap
EXCLUDE USING gist (
    phong_id WITH =,
    daterange(ngay_bat_dau, ngay_ket_thuc, '[]') WITH &&
)
WHERE (trang_thai IN ('PENDING', 'ACTIVE'));

CREATE TABLE public.thanh_vien_hop_dong (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hop_dong_id uuid NOT NULL REFERENCES public.hop_dong(id) ON DELETE CASCADE,
    khach_thue_id uuid REFERENCES public.khach_thue(id) ON DELETE SET NULL,
    ho_ten varchar(255) NOT NULL,
    so_cccd varchar(50),
    so_dien_thoai varchar(20),
    ngay_vao date NOT NULL DEFAULT CURRENT_DATE,
    ngay_roi date,
    dang_o boolean NOT NULL DEFAULT true,
    la_nguoi_dai_dien boolean NOT NULL DEFAULT false,
    ghi_chu text,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_tvhd_ngay CHECK (ngay_roi IS NULL OR ngay_roi >= ngay_vao)
);

CREATE TABLE public.phu_luc_hop_dong (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hop_dong_id uuid NOT NULL REFERENCES public.hop_dong(id) ON DELETE CASCADE,
    loai varchar(50) NOT NULL,
    noi_dung text NOT NULL,
    ngay_hieu_luc date NOT NULL,
    gia_thue_moi numeric(15,2),
    ngay_ket_thuc_moi date,
    file_pdf text,
    nguoi_tao_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    tao_luc timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.dat_coc_phong (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    phong_id uuid NOT NULL REFERENCES public.phong(id) ON DELETE RESTRICT,
    khach_thue_id uuid NOT NULL REFERENCES public.khach_thue(id) ON DELETE RESTRICT,
    hop_dong_id uuid REFERENCES public.hop_dong(id) ON DELETE SET NULL,
    so_tien_coc numeric(15,2) NOT NULL,
    ngay_dat_coc timestamptz NOT NULL DEFAULT now(),
    ngay_du_kien_vao date,
    trang_thai public.trang_thai_dat_coc NOT NULL DEFAULT 'PENDING',
    ghi_chu text,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_dat_coc_tien CHECK (so_tien_coc > 0)
);

-- ========================================================================
-- 5. SERVICES, PRICE CONFIGURATION, METER READINGS
-- ========================================================================

CREATE TABLE public.dich_vu (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    chu_tro_id uuid REFERENCES public.nguoi_dung(id) ON DELETE CASCADE,
    ten_dich_vu varchar(255) NOT NULL,
    loai_tinh_phi public.loai_tinh_phi NOT NULL DEFAULT 'FIXED',
    don_vi varchar(50),
    don_gia_mac_dinh numeric(15,2) NOT NULL DEFAULT 0,
    bat_buoc boolean NOT NULL DEFAULT false,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    UNIQUE (chu_tro_id, ten_dich_vu),
    CONSTRAINT chk_dich_vu_gia CHECK (don_gia_mac_dinh >= 0)
);

CREATE TABLE public.cau_hinh_gia (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nha_tro_id uuid NOT NULL REFERENCES public.nha_tro(id) ON DELETE CASCADE,
    dich_vu_id uuid REFERENCES public.dich_vu(id) ON DELETE SET NULL,
    loai public.loai_muc_hoa_don NOT NULL,
    ten_hien_thi varchar(255) NOT NULL,
    loai_tinh_phi public.loai_tinh_phi NOT NULL DEFAULT 'FIXED',
    don_gia numeric(15,2) NOT NULL,
    hieu_luc_tu date NOT NULL DEFAULT CURRENT_DATE,
    hieu_luc_den date,
    dang_ap_dung boolean NOT NULL DEFAULT true,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_cau_hinh_gia_tien CHECK (don_gia >= 0),
    CONSTRAINT chk_cau_hinh_gia_ngay CHECK (hieu_luc_den IS NULL OR hieu_luc_den >= hieu_luc_tu)
);

CREATE TABLE public.dich_vu_hop_dong (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hop_dong_id uuid NOT NULL REFERENCES public.hop_dong(id) ON DELETE CASCADE,
    dich_vu_id uuid NOT NULL REFERENCES public.dich_vu(id) ON DELETE RESTRICT,
    loai_tinh_phi public.loai_tinh_phi NOT NULL,
    don_gia_ap_dung numeric(15,2) NOT NULL,
    so_luong numeric(10,2) NOT NULL DEFAULT 1,
    bat_dau_tu date NOT NULL DEFAULT CURRENT_DATE,
    ket_thuc_luc date,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    UNIQUE (hop_dong_id, dich_vu_id, bat_dau_tu),
    CONSTRAINT chk_dvhd_tien CHECK (don_gia_ap_dung >= 0 AND so_luong >= 0)
);

CREATE TABLE public.chi_so_dien_nuoc (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    phong_id uuid NOT NULL REFERENCES public.phong(id) ON DELETE CASCADE,
    hop_dong_id uuid REFERENCES public.hop_dong(id) ON DELETE SET NULL,
    loai public.loai_chi_so NOT NULL,
    ky_nam integer NOT NULL,
    ky_thang integer NOT NULL,
    ngay_ghi date NOT NULL DEFAULT CURRENT_DATE,
    chi_so_cu integer NOT NULL,
    chi_so_moi integer NOT NULL,
    tieu_thu integer GENERATED ALWAYS AS (chi_so_moi - chi_so_cu) STORED,
    anh_dong_ho text,
    nguoi_ghi_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    trang_thai public.trang_thai_chi_so NOT NULL DEFAULT 'DRAFT',
    ghi_chu text,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    UNIQUE (phong_id, loai, ky_nam, ky_thang),
    CONSTRAINT chk_chi_so_ky CHECK (ky_thang BETWEEN 1 AND 12 AND ky_nam BETWEEN 2000 AND 2100),
    CONSTRAINT chk_chi_so_gia_tri CHECK (chi_so_cu >= 0 AND chi_so_moi >= chi_so_cu)
);

-- ========================================================================
-- 6. BILLING, PAYMENTS, DEBT
-- ========================================================================

CREATE TABLE public.hoa_don (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hop_dong_id uuid NOT NULL REFERENCES public.hop_dong(id) ON DELETE RESTRICT,
    phong_id uuid NOT NULL REFERENCES public.phong(id) ON DELETE RESTRICT,
    khach_thue_id uuid NOT NULL REFERENCES public.khach_thue(id) ON DELETE RESTRICT,
    ma_hoa_don varchar(100) NOT NULL UNIQUE,
    ky_nam integer NOT NULL,
    ky_thang integer NOT NULL,
    tu_ngay date NOT NULL,
    den_ngay date NOT NULL,
    so_du_dau_ky numeric(15,2) NOT NULL DEFAULT 0,
    tong_tien_phat_sinh numeric(15,2) NOT NULL DEFAULT 0,
    tong_tien numeric(15,2) NOT NULL DEFAULT 0,
    da_tra numeric(15,2) NOT NULL DEFAULT 0,
    so_du_cuoi_ky numeric(15,2) GENERATED ALWAYS AS (tong_tien - da_tra) STORED,
    trang_thai public.trang_thai_hoa_don NOT NULL DEFAULT 'DRAFT',
    han_tra date NOT NULL,
    ngay_lap_hoa_don timestamptz NOT NULL DEFAULT now(),
    ghi_chu text,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    xoa_luc timestamptz,
    UNIQUE (hop_dong_id, ky_nam, ky_thang),
    CONSTRAINT chk_hoa_don_ky CHECK (ky_thang BETWEEN 1 AND 12 AND ky_nam BETWEEN 2000 AND 2100),
    CONSTRAINT chk_hoa_don_ngay CHECK (den_ngay >= tu_ngay AND han_tra >= tu_ngay),
    CONSTRAINT chk_hoa_don_tien CHECK (
        tong_tien_phat_sinh >= 0
        AND tong_tien >= 0
        AND da_tra >= 0
    )
);

CREATE TABLE public.chi_tiet_hoa_don (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hoa_don_id uuid NOT NULL REFERENCES public.hoa_don(id) ON DELETE CASCADE,
    dich_vu_id uuid REFERENCES public.dich_vu(id) ON DELETE SET NULL,
    chi_so_dien_nuoc_id uuid REFERENCES public.chi_so_dien_nuoc(id) ON DELETE SET NULL,
    su_co_id uuid,
    loai public.loai_muc_hoa_don NOT NULL,
    mo_ta varchar(255) NOT NULL,
    so_luong numeric(10,2) NOT NULL DEFAULT 1,
    don_gia numeric(15,2) NOT NULL DEFAULT 0,
    thanh_tien numeric(15,2) NOT NULL DEFAULT 0,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_cthd_tien CHECK (
        so_luong >= 0
        AND don_gia >= 0
        AND (
            (loai = 'DISCOUNT' AND thanh_tien <= 0)
            OR (loai <> 'DISCOUNT' AND thanh_tien >= 0)
        )
    )
);

CREATE TABLE public.thanh_toan (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hoa_don_id uuid NOT NULL REFERENCES public.hoa_don(id) ON DELETE RESTRICT,
    khach_thue_id uuid REFERENCES public.khach_thue(id) ON DELETE SET NULL,
    so_tien numeric(15,2) NOT NULL,
    ngay_thanh_toan timestamptz NOT NULL DEFAULT now(),
    phuong_thuc_thanh_toan public.phuong_thuc_thanh_toan NOT NULL DEFAULT 'CASH',
    ma_tham_chieu varchar(150),
    external_transaction_id varchar(150),
    trang_thai public.trang_thai_thanh_toan NOT NULL DEFAULT 'SUCCESS',
    nguoi_thanh_toan_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    nguoi_ghi_nhan_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    ghi_chu text,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    UNIQUE (external_transaction_id),
    CONSTRAINT chk_thanh_toan_tien CHECK (so_tien > 0)
);

CREATE TABLE public.lich_su_hoa_don (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hoa_don_id uuid NOT NULL REFERENCES public.hoa_don(id) ON DELETE CASCADE,
    trang_thai_truoc public.trang_thai_hoa_don,
    trang_thai_moi public.trang_thai_hoa_don NOT NULL,
    nguoi_thay_doi_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    ghi_chu text,
    tao_luc timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.bank_transaction (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nha_tro_id uuid REFERENCES public.nha_tro(id) ON DELETE SET NULL,
    hoa_don_id uuid REFERENCES public.hoa_don(id) ON DELETE SET NULL,
    so_tien numeric(15,2) NOT NULL,
    noi_dung_chuyen_khoan text,
    ma_giao_dich varchar(150) UNIQUE,
    ngan_hang varchar(100),
    thoi_gian_giao_dich timestamptz NOT NULL,
    payload jsonb,
    da_doi_soat boolean NOT NULL DEFAULT false,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_bank_transaction_tien CHECK (so_tien > 0)
);

-- ========================================================================
-- 7. OPERATIONS, MEDIA, NOTIFICATIONS
-- ========================================================================

CREATE TABLE public.su_co (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    phong_id uuid NOT NULL REFERENCES public.phong(id) ON DELETE CASCADE,
    khach_thue_id uuid REFERENCES public.khach_thue(id) ON DELETE SET NULL,
    nguoi_bao_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    tieu_de varchar(255) NOT NULL,
    mo_ta text NOT NULL,
    loai_su_co public.loai_su_co_enum NOT NULL DEFAULT 'khac',
    uu_tien public.uu_tien_enum NOT NULL DEFAULT 'trung_binh',
    trang_thai public.trang_thai_su_co NOT NULL DEFAULT 'PENDING',
    nguoi_phu_trach_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    chi_phi_sua_chua numeric(15,2) NOT NULL DEFAULT 0,
    tinh_vao_hoa_don boolean NOT NULL DEFAULT false,
    ghi_chu_chu_nha text,
    giai_quyet_luc timestamptz,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_su_co_chi_phi CHECK (chi_phi_sua_chua >= 0)
);

ALTER TABLE public.chi_tiet_hoa_don
ADD CONSTRAINT fk_cthd_su_co
FOREIGN KEY (su_co_id) REFERENCES public.su_co(id) ON DELETE SET NULL;

CREATE TABLE public.lich_hen (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    phong_id uuid NOT NULL REFERENCES public.phong(id) ON DELETE CASCADE,
    nguoi_dung_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    ho_ten varchar(255),
    so_dien_thoai varchar(20),
    email varchar(255),
    ngay_hen timestamptz NOT NULL,
    trang_thai public.trang_thai_lich_hen NOT NULL DEFAULT 'PENDING',
    google_calendar_event_id text,
    da_gui_nhac_nho boolean NOT NULL DEFAULT false,
    ghi_chu text,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.file_media (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    doi_tuong public.loai_doi_tuong_media NOT NULL,
    doi_tuong_id uuid NOT NULL,
    url text NOT NULL,
    public_id text,
    loai_file varchar(100),
    kich_thuoc_bytes bigint,
    metadata jsonb,
    nguoi_tai_len_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_file_size CHECK (kich_thuoc_bytes IS NULL OR kich_thuoc_bytes >= 0)
);

CREATE TABLE public.thong_bao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nguoi_gui_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    loai public.loai_thong_bao NOT NULL DEFAULT 'SYSTEM',
    tieu_de varchar(255) NOT NULL,
    noi_dung text NOT NULL,
    doi_tuong public.loai_doi_tuong_media,
    doi_tuong_id uuid,
    kenh public.kenh_thong_bao NOT NULL DEFAULT 'IN_APP',
    gui_tat_ca boolean NOT NULL DEFAULT false,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    xoa_luc timestamptz
);

CREATE TABLE public.thong_bao_nguoi_nhan (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    thong_bao_id uuid NOT NULL REFERENCES public.thong_bao(id) ON DELETE CASCADE,
    nguoi_dung_id uuid NOT NULL REFERENCES public.nguoi_dung(id) ON DELETE CASCADE,
    da_doc boolean NOT NULL DEFAULT false,
    doc_luc timestamptz,
    gui_luc timestamptz,
    loi_gui text,
    UNIQUE (thong_bao_id, nguoi_dung_id)
);

CREATE TABLE public.audit_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nguoi_dung_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    hanh_dong varchar(100) NOT NULL,
    bang_tac_dong varchar(100),
    ban_ghi_id uuid,
    du_lieu_cu jsonb,
    du_lieu_moi jsonb,
    ip_address inet,
    user_agent text,
    tao_luc timestamptz NOT NULL DEFAULT now()
);

-- ========================================================================
-- 8. FUNCTIONS AND TRIGGERS
-- ========================================================================

CREATE OR REPLACE FUNCTION public.cap_nhat_thoi_gian()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.cap_nhat_luc = now();
    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.recalc_hoa_don_from_chi_tiet()
RETURNS trigger
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

CREATE OR REPLACE FUNCTION public.recalc_hoa_don_from_thanh_toan()
RETURNS trigger
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

CREATE OR REPLACE FUNCTION public.cap_nhat_trang_thai_hoa_don()
RETURNS trigger
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

CREATE TRIGGER trg_nguoi_dung_cap_nhat BEFORE UPDATE ON public.nguoi_dung
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_nha_tro_cap_nhat BEFORE UPDATE ON public.nha_tro
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_phong_cap_nhat BEFORE UPDATE ON public.phong
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_khach_thue_cap_nhat BEFORE UPDATE ON public.khach_thue
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_hop_dong_cap_nhat BEFORE UPDATE ON public.hop_dong
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_thanh_vien_cap_nhat BEFORE UPDATE ON public.thanh_vien_hop_dong
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_dich_vu_cap_nhat BEFORE UPDATE ON public.dich_vu
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_cau_hinh_gia_cap_nhat BEFORE UPDATE ON public.cau_hinh_gia
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_chi_so_cap_nhat BEFORE UPDATE ON public.chi_so_dien_nuoc
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_hoa_don_cap_nhat BEFORE UPDATE ON public.hoa_don
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_su_co_cap_nhat BEFORE UPDATE ON public.su_co
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_lich_hen_cap_nhat BEFORE UPDATE ON public.lich_hen
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_thong_bao_cap_nhat BEFORE UPDATE ON public.thong_bao
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();

CREATE TRIGGER trg_cthd_recalc AFTER INSERT OR UPDATE OR DELETE ON public.chi_tiet_hoa_don
FOR EACH ROW EXECUTE FUNCTION public.recalc_hoa_don_from_chi_tiet();

CREATE TRIGGER trg_thanh_toan_recalc AFTER INSERT OR UPDATE OR DELETE ON public.thanh_toan
FOR EACH ROW EXECUTE FUNCTION public.recalc_hoa_don_from_thanh_toan();

CREATE TRIGGER trg_hoa_don_status BEFORE INSERT OR UPDATE OF tong_tien, da_tra, han_tra, trang_thai ON public.hoa_don
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_trang_thai_hoa_don();

-- ========================================================================
-- 9. INDEXES
-- ========================================================================

CREATE INDEX idx_nguoi_dung_email ON public.nguoi_dung (email);
CREATE INDEX idx_nguoi_dung_trang_thai ON public.nguoi_dung (trang_thai);
CREATE INDEX idx_login_history_user_time ON public.login_history (nguoi_dung_id, tao_luc DESC);

CREATE INDEX idx_nha_tro_chu_tro ON public.nha_tro (chu_tro_id);
CREATE INDEX idx_ndnt_nha_tro_user ON public.nguoi_dung_nha_tro (nha_tro_id, nguoi_dung_id);
CREATE INDEX idx_phong_nha_tro ON public.phong (nha_tro_id);
CREATE INDEX idx_phong_trang_thai ON public.phong (trang_thai);

CREATE INDEX idx_khach_thue_chu_tro ON public.khach_thue (chu_tro_id);
CREATE INDEX idx_khach_thue_sdt ON public.khach_thue (so_dien_thoai);
CREATE INDEX idx_hop_dong_phong_status_dates ON public.hop_dong (phong_id, trang_thai, ngay_bat_dau, ngay_ket_thuc);
CREATE INDEX idx_hop_dong_khach_thue ON public.hop_dong (khach_thue_id);
CREATE INDEX idx_tvhd_hop_dong ON public.thanh_vien_hop_dong (hop_dong_id);
CREATE INDEX idx_dat_coc_phong ON public.dat_coc_phong (phong_id, trang_thai);

CREATE INDEX idx_cau_hinh_gia_nha_tro ON public.cau_hinh_gia (nha_tro_id, loai, dang_ap_dung);
CREATE INDEX idx_dvhd_hop_dong ON public.dich_vu_hop_dong (hop_dong_id);
CREATE INDEX idx_chi_so_phong_ky ON public.chi_so_dien_nuoc (phong_id, loai, ky_nam, ky_thang);

CREATE INDEX idx_hoa_don_hop_dong_ky ON public.hoa_don (hop_dong_id, ky_nam, ky_thang);
CREATE INDEX idx_hoa_don_phong ON public.hoa_don (phong_id);
CREATE INDEX idx_hoa_don_khach_thue ON public.hoa_don (khach_thue_id);
CREATE INDEX idx_hoa_don_status_due ON public.hoa_don (trang_thai, han_tra);
CREATE INDEX idx_cthd_hoa_don ON public.chi_tiet_hoa_don (hoa_don_id);
CREATE INDEX idx_thanh_toan_hoa_don ON public.thanh_toan (hoa_don_id);
CREATE INDEX idx_thanh_toan_ref ON public.thanh_toan (ma_tham_chieu);

CREATE INDEX idx_su_co_phong_status ON public.su_co (phong_id, trang_thai);
CREATE INDEX idx_lich_hen_phong_time ON public.lich_hen (phong_id, ngay_hen);
CREATE INDEX idx_file_media_target ON public.file_media (doi_tuong, doi_tuong_id);
CREATE INDEX idx_thong_bao_recipient ON public.thong_bao_nguoi_nhan (nguoi_dung_id, da_doc);
CREATE INDEX idx_audit_log_target ON public.audit_log (bang_tac_dong, ban_ghi_id);

-- ========================================================================
-- 10. RLS HELPERS AND POLICIES
-- ========================================================================

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.nguoi_dung_vai_tro ndvt
        JOIN public.vai_tro vt ON vt.id = ndvt.vai_tro_id
        WHERE ndvt.nguoi_dung_id = auth.uid()
          AND vt.ten = 'ADMIN'
    );
$$;

CREATE OR REPLACE FUNCTION public.can_access_nha_tro(p_nha_tro_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
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

ALTER TABLE public.nguoi_dung ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vai_tro ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nguoi_dung_vai_tro ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.login_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nha_tro ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nguoi_dung_nha_tro ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.phong ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tien_ich ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.phong_tien_ich ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.khach_thue ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hop_dong ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.thanh_vien_hop_dong ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.phu_luc_hop_dong ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dat_coc_phong ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dich_vu ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cau_hinh_gia ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dich_vu_hop_dong ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chi_so_dien_nuoc ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hoa_don ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chi_tiet_hoa_don ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.thanh_toan ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lich_su_hoa_don ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bank_transaction ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.su_co ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lich_hen ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.file_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.thong_bao ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.thong_bao_nguoi_nhan ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY nguoi_dung_self_or_admin ON public.nguoi_dung
FOR ALL USING (id = auth.uid() OR public.is_admin())
WITH CHECK (id = auth.uid() OR public.is_admin());

CREATE POLICY vai_tro_read_authenticated ON public.vai_tro
FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY nguoi_dung_vai_tro_self_or_admin_read ON public.nguoi_dung_vai_tro
FOR SELECT USING (nguoi_dung_id = auth.uid() OR public.is_admin());

CREATE POLICY nguoi_dung_vai_tro_admin_write ON public.nguoi_dung_vai_tro
FOR ALL USING (public.is_admin())
WITH CHECK (public.is_admin());

CREATE POLICY login_history_self_or_admin ON public.login_history
FOR SELECT USING (nguoi_dung_id = auth.uid() OR public.is_admin());

CREATE POLICY nha_tro_owner_staff ON public.nha_tro
FOR ALL USING (public.can_access_nha_tro(id))
WITH CHECK (chu_tro_id = auth.uid() OR public.is_admin());

CREATE POLICY nguoi_dung_nha_tro_owner_admin ON public.nguoi_dung_nha_tro
FOR ALL USING (
    public.is_admin()
    OR EXISTS (
        SELECT 1
        FROM public.nha_tro nt
        WHERE nt.id = nguoi_dung_nha_tro.nha_tro_id
          AND nt.chu_tro_id = auth.uid()
    )
)
WITH CHECK (
    public.is_admin()
    OR EXISTS (
        SELECT 1
        FROM public.nha_tro nt
        WHERE nt.id = nguoi_dung_nha_tro.nha_tro_id
          AND nt.chu_tro_id = auth.uid()
    )
);

CREATE POLICY phong_by_nha_tro ON public.phong
FOR ALL USING (public.can_access_nha_tro(nha_tro_id))
WITH CHECK (public.can_access_nha_tro(nha_tro_id));

CREATE POLICY tien_ich_read_authenticated ON public.tien_ich
FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY tien_ich_admin_write ON public.tien_ich
FOR ALL USING (public.is_admin())
WITH CHECK (public.is_admin());

CREATE POLICY phong_tien_ich_by_room ON public.phong_tien_ich
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = phong_tien_ich.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = phong_tien_ich.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY khach_thue_owner_or_self ON public.khach_thue
FOR ALL USING (
    public.is_admin()
    OR chu_tro_id = auth.uid()
    OR nguoi_dung_id = auth.uid()
)
WITH CHECK (
    public.is_admin()
    OR chu_tro_id = auth.uid()
    OR nguoi_dung_id = auth.uid()
);

CREATE POLICY hop_dong_by_room_or_tenant ON public.hop_dong
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = hop_dong.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
    OR EXISTS (
        SELECT 1
        FROM public.khach_thue kt
        WHERE kt.id = hop_dong.khach_thue_id
          AND kt.nguoi_dung_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = hop_dong.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY thanh_vien_hop_dong_by_contract ON public.thanh_vien_hop_dong
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.hop_dong hd
        WHERE hd.id = thanh_vien_hop_dong.hop_dong_id
          AND (
              EXISTS (
                  SELECT 1
                  FROM public.phong p
                  WHERE p.id = hd.phong_id
                    AND public.can_access_nha_tro(p.nha_tro_id)
              )
              OR EXISTS (
                  SELECT 1
                  FROM public.khach_thue kt
                  WHERE kt.id = hd.khach_thue_id
                    AND kt.nguoi_dung_id = auth.uid()
              )
          )
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.hop_dong hd
        JOIN public.phong p ON p.id = hd.phong_id
        WHERE hd.id = thanh_vien_hop_dong.hop_dong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY phu_luc_hop_dong_by_contract ON public.phu_luc_hop_dong
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.hop_dong hd
        JOIN public.phong p ON p.id = hd.phong_id
        WHERE hd.id = phu_luc_hop_dong.hop_dong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.hop_dong hd
        JOIN public.phong p ON p.id = hd.phong_id
        WHERE hd.id = phu_luc_hop_dong.hop_dong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY dat_coc_by_room ON public.dat_coc_phong
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = dat_coc_phong.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = dat_coc_phong.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY dich_vu_owner ON public.dich_vu
FOR ALL USING (chu_tro_id = auth.uid() OR public.is_admin())
WITH CHECK (chu_tro_id = auth.uid() OR public.is_admin());

CREATE POLICY cau_hinh_gia_by_nha_tro ON public.cau_hinh_gia
FOR ALL USING (public.can_access_nha_tro(nha_tro_id))
WITH CHECK (public.can_access_nha_tro(nha_tro_id));

CREATE POLICY dich_vu_hop_dong_by_contract ON public.dich_vu_hop_dong
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.hop_dong hd
        JOIN public.phong p ON p.id = hd.phong_id
        WHERE hd.id = dich_vu_hop_dong.hop_dong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.hop_dong hd
        JOIN public.phong p ON p.id = hd.phong_id
        WHERE hd.id = dich_vu_hop_dong.hop_dong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY chi_so_by_room ON public.chi_so_dien_nuoc
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = chi_so_dien_nuoc.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = chi_so_dien_nuoc.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY hoa_don_by_room_or_tenant ON public.hoa_don
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = hoa_don.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
    OR EXISTS (
        SELECT 1
        FROM public.khach_thue kt
        WHERE kt.id = hoa_don.khach_thue_id
          AND kt.nguoi_dung_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = hoa_don.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY chi_tiet_hoa_don_by_invoice ON public.chi_tiet_hoa_don
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.hoa_don hd
        WHERE hd.id = chi_tiet_hoa_don.hoa_don_id
          AND (
              EXISTS (
                  SELECT 1
                  FROM public.phong p
                  WHERE p.id = hd.phong_id
                    AND public.can_access_nha_tro(p.nha_tro_id)
              )
              OR EXISTS (
                  SELECT 1
                  FROM public.khach_thue kt
                  WHERE kt.id = hd.khach_thue_id
                    AND kt.nguoi_dung_id = auth.uid()
              )
          )
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.hoa_don hd
        JOIN public.phong p ON p.id = hd.phong_id
        WHERE hd.id = chi_tiet_hoa_don.hoa_don_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY thanh_toan_by_invoice ON public.thanh_toan
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.hoa_don hd
        WHERE hd.id = thanh_toan.hoa_don_id
          AND (
              EXISTS (
                  SELECT 1
                  FROM public.phong p
                  WHERE p.id = hd.phong_id
                    AND public.can_access_nha_tro(p.nha_tro_id)
              )
              OR EXISTS (
                  SELECT 1
                  FROM public.khach_thue kt
                  WHERE kt.id = hd.khach_thue_id
                    AND kt.nguoi_dung_id = auth.uid()
              )
          )
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.hoa_don hd
        JOIN public.phong p ON p.id = hd.phong_id
        WHERE hd.id = thanh_toan.hoa_don_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY lich_su_hoa_don_by_invoice ON public.lich_su_hoa_don
FOR SELECT USING (
    EXISTS (
        SELECT 1
        FROM public.hoa_don hd
        WHERE hd.id = lich_su_hoa_don.hoa_don_id
          AND (
              EXISTS (
                  SELECT 1
                  FROM public.phong p
                  WHERE p.id = hd.phong_id
                    AND public.can_access_nha_tro(p.nha_tro_id)
              )
              OR EXISTS (
                  SELECT 1
                  FROM public.khach_thue kt
                  WHERE kt.id = hd.khach_thue_id
                    AND kt.nguoi_dung_id = auth.uid()
              )
          )
    )
);

CREATE POLICY bank_transaction_by_nha_tro ON public.bank_transaction
FOR ALL USING (nha_tro_id IS NOT NULL AND public.can_access_nha_tro(nha_tro_id))
WITH CHECK (nha_tro_id IS NOT NULL AND public.can_access_nha_tro(nha_tro_id));

CREATE POLICY su_co_by_room_or_reporter ON public.su_co
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = su_co.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
    OR nguoi_bao_id = auth.uid()
    OR EXISTS (
        SELECT 1
        FROM public.khach_thue kt
        WHERE kt.id = su_co.khach_thue_id
          AND kt.nguoi_dung_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = su_co.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
    OR nguoi_bao_id = auth.uid()
);

CREATE POLICY lich_hen_by_room_or_user ON public.lich_hen
FOR ALL USING (
    nguoi_dung_id = auth.uid()
    OR EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = lich_hen.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
)
WITH CHECK (
    nguoi_dung_id = auth.uid()
    OR EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = lich_hen.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY file_media_uploader_admin ON public.file_media
FOR ALL USING (nguoi_tai_len_id = auth.uid() OR public.is_admin())
WITH CHECK (nguoi_tai_len_id = auth.uid() OR public.is_admin());

CREATE POLICY thong_bao_sender_or_recipient ON public.thong_bao
FOR SELECT USING (
    nguoi_gui_id = auth.uid()
    OR public.is_admin()
    OR EXISTS (
        SELECT 1
        FROM public.thong_bao_nguoi_nhan tbn
        WHERE tbn.thong_bao_id = thong_bao.id
          AND tbn.nguoi_dung_id = auth.uid()
    )
);

CREATE POLICY thong_bao_insert_authenticated ON public.thong_bao
FOR INSERT WITH CHECK (nguoi_gui_id = auth.uid() OR public.is_admin());

CREATE POLICY thong_bao_recipient_read ON public.thong_bao_nguoi_nhan
FOR SELECT USING (nguoi_dung_id = auth.uid() OR public.is_admin());

CREATE POLICY thong_bao_recipient_update_self ON public.thong_bao_nguoi_nhan
FOR UPDATE USING (nguoi_dung_id = auth.uid() OR public.is_admin())
WITH CHECK (nguoi_dung_id = auth.uid() OR public.is_admin());

CREATE POLICY thong_bao_recipient_insert_sender ON public.thong_bao_nguoi_nhan
FOR INSERT WITH CHECK (
    public.is_admin()
    OR EXISTS (
        SELECT 1
        FROM public.thong_bao tb
        WHERE tb.id = thong_bao_nguoi_nhan.thong_bao_id
          AND tb.nguoi_gui_id = auth.uid()
    )
);

CREATE POLICY audit_log_admin_read ON public.audit_log
FOR SELECT USING (public.is_admin());

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
