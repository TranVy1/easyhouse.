ALTER TYPE public.trang_thai_dat_coc RENAME VALUE 'COMPLETED' TO 'CONFIRMED';
ALTER TYPE public.trang_thai_dat_coc ADD VALUE IF NOT EXISTS 'CONVERTED';

ALTER TABLE public.dat_coc_phong
ADD COLUMN IF NOT EXISTS ly_do_huy text,
ADD COLUMN IF NOT EXISTS confirmed_at timestamptz,
ADD COLUMN IF NOT EXISTS cancelled_at timestamptz,
ADD COLUMN IF NOT EXISTS nguoi_xac_nhan_id uuid NULL REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;
