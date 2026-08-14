CREATE TABLE IF NOT EXISTS public.lich_su_phuong_tien (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    phuong_tien_id uuid NOT NULL REFERENCES public.phuong_tien(id) ON DELETE RESTRICT,
    khach_thue_id uuid NOT NULL REFERENCES public.khach_thue(id) ON DELETE RESTRICT,
    phong_id uuid NOT NULL REFERENCES public.phong(id) ON DELETE RESTRICT,
    nha_tro_id uuid NOT NULL REFERENCES public.nha_tro(id) ON DELETE RESTRICT,
    hieu_luc_tu date NOT NULL,
    hieu_luc_den date,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT ck_lich_su_phuong_tien_dates CHECK (hieu_luc_den IS NULL OR hieu_luc_den >= hieu_luc_tu)
);

INSERT INTO public.lich_su_phuong_tien (phuong_tien_id, khach_thue_id, phong_id, nha_tro_id, hieu_luc_tu, hieu_luc_den)
SELECT pt.id, pt.khach_thue_id, pt.phong_id, pt.nha_tro_id, pt.hieu_luc_tu, pt.hieu_luc_den
FROM public.phuong_tien pt
WHERE pt.khach_thue_id IS NOT NULL AND pt.phong_id IS NOT NULL AND pt.nha_tro_id IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM public.lich_su_phuong_tien ls WHERE ls.phuong_tien_id = pt.id);

CREATE INDEX IF NOT EXISTS idx_lich_su_phuong_tien_billable
    ON public.lich_su_phuong_tien (phong_id, hieu_luc_tu, hieu_luc_den);
