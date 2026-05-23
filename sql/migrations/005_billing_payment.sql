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

