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

