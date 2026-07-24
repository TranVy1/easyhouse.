BEGIN;

ALTER TABLE public.hoa_don
    ADD COLUMN IF NOT EXISTS auto_generated boolean DEFAULT false,
    ADD COLUMN IF NOT EXISTS generation_batch_id uuid,
    ADD COLUMN IF NOT EXISTS source_schedule_id uuid;

CREATE TABLE IF NOT EXISTS public.invoice_generation_batch (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nha_tro_id uuid NULL,
    ky_thang int NOT NULL,
    ky_nam int NOT NULL,
    trang_thai varchar(30) NOT NULL DEFAULT 'COMPLETED',
    tong_hop_dong int NOT NULL DEFAULT 0,
    tao_thanh_cong int NOT NULL DEFAULT 0,
    bo_qua int NOT NULL DEFAULT 0,
    loi int NOT NULL DEFAULT 0,
    nguoi_tao_id uuid NULL,
    tao_luc timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT fk_batch_nha_tro FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE SET NULL,
    CONSTRAINT fk_batch_nguoi_tao FOREIGN KEY (nguoi_tao_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS public.invoice_generation_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_id uuid NOT NULL,
    hop_dong_id uuid NULL,
    hoa_don_id uuid NULL,
    status varchar(30) NOT NULL,
    reason text NULL,
    tao_luc timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT fk_log_batch FOREIGN KEY (batch_id) REFERENCES public.invoice_generation_batch(id) ON DELETE CASCADE,
    CONSTRAINT fk_log_hop_dong FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE SET NULL,
    CONSTRAINT fk_log_hoa_don FOREIGN KEY (hoa_don_id) REFERENCES public.hoa_don(id) ON DELETE SET NULL
);

COMMIT;
