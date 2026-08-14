ALTER TABLE public.phuong_tien
    ADD COLUMN IF NOT EXISTS hieu_luc_tu date,
    ADD COLUMN IF NOT EXISTS hieu_luc_den date;

UPDATE public.phuong_tien
SET hieu_luc_tu = COALESCE(created_at::date, CURRENT_DATE)
WHERE hieu_luc_tu IS NULL;

UPDATE public.phuong_tien
SET hieu_luc_den = COALESCE(updated_at::date, CURRENT_DATE)
WHERE trang_thai = 'HET_HIEU_LUC' AND hieu_luc_den IS NULL;

ALTER TABLE public.phuong_tien
    ALTER COLUMN hieu_luc_tu SET NOT NULL;

ALTER TABLE public.phuong_tien
    DROP CONSTRAINT IF EXISTS phuong_tien_hieu_luc_check;
ALTER TABLE public.phuong_tien
    ADD CONSTRAINT phuong_tien_hieu_luc_check CHECK (hieu_luc_den IS NULL OR hieu_luc_den >= hieu_luc_tu);

CREATE TABLE IF NOT EXISTS public.cau_hinh_phi_xe (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nha_tro_id uuid NOT NULL REFERENCES public.nha_tro(id) ON DELETE CASCADE,
    loai_xe character varying(100) NOT NULL,
    don_gia numeric(18,2) NOT NULL,
    hieu_luc_tu date NOT NULL,
    hieu_luc_den date,
    dang_ap_dung boolean NOT NULL DEFAULT true,
    ghi_chu text,
    tao_luc timestamp with time zone NOT NULL DEFAULT now(),
    cap_nhat_luc timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT cau_hinh_phi_xe_don_gia_check CHECK (don_gia >= 0),
    CONSTRAINT cau_hinh_phi_xe_hieu_luc_check CHECK (hieu_luc_den IS NULL OR hieu_luc_den >= hieu_luc_tu)
);
CREATE INDEX IF NOT EXISTS idx_cau_hinh_phi_xe_lookup
    ON public.cau_hinh_phi_xe(nha_tro_id, loai_xe, hieu_luc_tu DESC);
