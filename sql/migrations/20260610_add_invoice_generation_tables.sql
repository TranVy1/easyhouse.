ALTER TABLE public.hoa_don
ADD COLUMN IF NOT EXISTS auto_generated boolean DEFAULT false,
ADD COLUMN IF NOT EXISTS generation_batch_id uuid,
ADD COLUMN IF NOT EXISTS source_schedule_id uuid;

CREATE TABLE IF NOT EXISTS public.invoice_generation_batch (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nha_tro_id uuid NULL REFERENCES public.nha_tro(id) ON DELETE SET NULL,
    ky_thang int NOT NULL,
    ky_nam int NOT NULL,
    trang_thai varchar(30) NOT NULL DEFAULT 'COMPLETED',
    tong_hop_dong int NOT NULL DEFAULT 0,
    tao_thanh_cong int NOT NULL DEFAULT 0,
    bo_qua int NOT NULL DEFAULT 0,
    loi int NOT NULL DEFAULT 0,
    nguoi_tao_id uuid NULL REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    tao_luc timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.invoice_generation_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_id uuid NOT NULL REFERENCES public.invoice_generation_batch(id) ON DELETE CASCADE,
    hop_dong_id uuid NULL REFERENCES public.hop_dong(id) ON DELETE SET NULL,
    hoa_don_id uuid NULL REFERENCES public.hoa_don(id) ON DELETE SET NULL,
    status varchar(30) NOT NULL,
    reason text NULL,
    tao_luc timestamptz NOT NULL DEFAULT now()
);
