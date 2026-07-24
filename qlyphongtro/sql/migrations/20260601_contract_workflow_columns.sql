BEGIN;

ALTER TABLE public.hop_dong
    ADD COLUMN IF NOT EXISTS template_version character varying(100),
    ADD COLUMN IF NOT EXISTS previewed_at timestamp with time zone,
    ADD COLUMN IF NOT EXISTS confirmed_at timestamp with time zone,
    ADD COLUMN IF NOT EXISTS locked_at timestamp with time zone;

COMMIT;
