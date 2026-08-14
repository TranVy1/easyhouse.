-- Snapshot room inventory at checkout. Source room assets may later change,
-- therefore all identifying/condition fields are copied into this record.
CREATE TABLE IF NOT EXISTS public.chi_tiet_ban_giao_tai_san (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    quyet_toan_tra_phong_id uuid NOT NULL REFERENCES public.quyet_toan_tra_phong(id) ON DELETE CASCADE,
    tai_san_phong_id uuid REFERENCES public.tai_san_phong(id) ON DELETE SET NULL,
    ten_tai_san character varying(255) NOT NULL,
    so_luong_ban_dau integer NOT NULL,
    tinh_trang_ban_dau character varying(255) NOT NULL,
    anh_tai_san_ban_dau text,
    so_luong_thuc_te integer,
    tinh_trang_thuc_te character varying(255),
    chung_tu_url text,
    ghi_chu text,
    da_xac_nhan boolean NOT NULL DEFAULT false,
    xac_nhan_luc timestamp with time zone,
    tao_luc timestamp with time zone NOT NULL DEFAULT now(),
    cap_nhat_luc timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT chi_tiet_ban_giao_tai_san_quantity_check CHECK (
        so_luong_ban_dau >= 0 AND (so_luong_thuc_te IS NULL OR (so_luong_thuc_te >= 0 AND so_luong_thuc_te <= so_luong_ban_dau))
    )
);
CREATE INDEX IF NOT EXISTS idx_chi_tiet_ban_giao_tai_san_quyet_toan
    ON public.chi_tiet_ban_giao_tai_san(quyet_toan_tra_phong_id);
