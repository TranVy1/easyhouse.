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

