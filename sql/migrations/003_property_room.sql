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

