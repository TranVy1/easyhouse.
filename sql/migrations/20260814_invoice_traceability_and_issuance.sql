-- Invoice lifecycle and line-item traceability. Safe to apply to an existing EasyHouse database.

ALTER TYPE public.trang_thai_hoa_don ADD VALUE IF NOT EXISTS 'ISSUED' BEFORE 'UNPAID';

ALTER TABLE public.hoa_don
    ADD COLUMN IF NOT EXISTS loai_hoa_don character varying(32) NOT NULL DEFAULT 'REGULAR',
    ADD COLUMN IF NOT EXISTS hoa_don_goc_id uuid;

-- A final settlement/deposit request may share the regular invoice month.  Keep
-- regular monthly billing unique while allowing distinct document types.
ALTER TABLE public.hoa_don
    DROP CONSTRAINT IF EXISTS hoa_don_hop_dong_id_ky_nam_ky_thang_key;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'hoa_don_hop_dong_id_ky_nam_ky_thang_loai_key'
          AND conrelid = 'public.hoa_don'::regclass
    ) THEN
        ALTER TABLE public.hoa_don
            ADD CONSTRAINT hoa_don_hop_dong_id_ky_nam_ky_thang_loai_key
            UNIQUE (hop_dong_id, ky_nam, ky_thang, loai_hoa_don);
    END IF;
END $$;

ALTER TABLE public.chi_tiet_hoa_don
    ADD COLUMN IF NOT EXISTS source_type character varying(64),
    ADD COLUMN IF NOT EXISTS source_id uuid,
    ADD COLUMN IF NOT EXISTS pricing_rule_version character varying(128),
    ADD COLUMN IF NOT EXISTS period_start date,
    ADD COLUMN IF NOT EXISTS period_end date,
    ADD COLUMN IF NOT EXISTS calculation_hash character varying(64);

UPDATE public.chi_tiet_hoa_don ct
SET source_type = CASE
        WHEN ct.chi_so_dien_nuoc_id IS NOT NULL THEN 'METER_READING'
        WHEN ct.dich_vu_id IS NOT NULL THEN 'CONTRACT_SERVICE'
        WHEN ct.loai = 'ROOM' THEN 'CONTRACT_RENT'
        WHEN ct.loai = 'DISCOUNT' THEN 'DEPOSIT_SETTLEMENT'
        ELSE 'LEGACY_UNKNOWN'
    END,
    source_id = COALESCE(ct.chi_so_dien_nuoc_id, ct.dich_vu_id, ct.source_id),
    pricing_rule_version = 'LEGACY_V1',
    period_start = hd.tu_ngay,
    period_end = hd.den_ngay,
    calculation_hash = md5(concat_ws('|', hd.id, ct.id, ct.loai, ct.so_luong, ct.don_gia, ct.thanh_tien))
FROM public.hoa_don hd
WHERE hd.id = ct.hoa_don_id
  AND (ct.source_type IS NULL OR ct.pricing_rule_version IS NULL OR ct.period_start IS NULL
       OR ct.period_end IS NULL OR ct.calculation_hash IS NULL);

ALTER TABLE public.chi_tiet_hoa_don
    ALTER COLUMN source_type SET NOT NULL,
    ALTER COLUMN pricing_rule_version SET NOT NULL,
    ALTER COLUMN period_start SET NOT NULL,
    ALTER COLUMN period_end SET NOT NULL,
    ALTER COLUMN calculation_hash SET NOT NULL;

ALTER TABLE public.hoa_don
    DROP CONSTRAINT IF EXISTS hoa_don_hoa_don_goc_id_fkey;

ALTER TABLE public.hoa_don
    ADD CONSTRAINT hoa_don_hoa_don_goc_id_fkey
    FOREIGN KEY (hoa_don_goc_id) REFERENCES public.hoa_don(id) ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS idx_chi_tiet_hoa_don_source
    ON public.chi_tiet_hoa_don (source_type, source_id);

CREATE INDEX IF NOT EXISTS idx_hoa_don_hoa_don_goc
    ON public.hoa_don (hoa_don_goc_id)
    WHERE hoa_don_goc_id IS NOT NULL;

ALTER TABLE public.debt_reminder_log
    DROP CONSTRAINT IF EXISTS debt_reminder_log_reminder_type_check;

ALTER TABLE public.debt_reminder_log
    ADD CONSTRAINT debt_reminder_log_reminder_type_check
    CHECK ((reminder_type)::text = ANY (ARRAY[
        'DUE_IN_3_DAYS', 'DUE_TOMORROW', 'OVERDUE_1_DAY', 'OVERDUE_3_DAYS',
        'OVERDUE_7_DAYS', 'OVERDUE_15_DAYS', 'OVERDUE_30_DAYS', 'MANUAL'
    ]));

-- Historical UNPAID/PARTIAL/OVERPAID records are intentionally not rewritten.
-- They remain read-only legacy financial history; only newly issued invoices use ISSUED.
