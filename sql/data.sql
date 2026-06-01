BEGIN;

CREATE TABLE IF NOT EXISTS public.tang (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nha_tro_id uuid NOT NULL,
    so_tang integer NOT NULL,
    ten_tang character varying(100),
    thu_tu_hien_thi integer,
    so_phong_du_kien integer,
    trang_thai character varying(30) DEFAULT 'ACTIVE'::character varying NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    CONSTRAINT chk_tang_so_tang CHECK (so_tang >= 0),
    CONSTRAINT chk_tang_so_phong_du_kien CHECK ((so_phong_du_kien IS NULL) OR (so_phong_du_kien >= 0))
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tang_pkey'
          AND conrelid = 'public.tang'::regclass
    ) THEN
        ALTER TABLE public.tang
            ADD CONSTRAINT tang_pkey PRIMARY KEY (id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tang_nha_tro_id_so_tang_key'
          AND conrelid = 'public.tang'::regclass
    ) THEN
        ALTER TABLE public.tang
            ADD CONSTRAINT tang_nha_tro_id_so_tang_key UNIQUE (nha_tro_id, so_tang);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tang_nha_tro_id_id_key'
          AND conrelid = 'public.tang'::regclass
    ) THEN
        ALTER TABLE public.tang
            ADD CONSTRAINT tang_nha_tro_id_id_key UNIQUE (nha_tro_id, id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'tang_nha_tro_id_fkey'
          AND conrelid = 'public.tang'::regclass
    ) THEN
        ALTER TABLE public.tang
            ADD CONSTRAINT tang_nha_tro_id_fkey
            FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE CASCADE;
    END IF;
END $$;

INSERT INTO public.tang (nha_tro_id, so_tang, ten_tang, thu_tu_hien_thi, so_phong_du_kien)
SELECT
    p.nha_tro_id,
    p.tang,
    'Tang ' || p.tang::text,
    p.tang,
    count(*)::integer
FROM public.phong p
WHERE p.tang IS NOT NULL
GROUP BY p.nha_tro_id, p.tang
ON CONFLICT (nha_tro_id, so_tang) DO UPDATE
SET
    so_phong_du_kien = EXCLUDED.so_phong_du_kien,
    cap_nhat_luc = now();

ALTER TABLE public.phong
    ADD COLUMN IF NOT EXISTS tang_id uuid;

UPDATE public.phong p
SET tang_id = t.id
FROM public.tang t
WHERE p.tang_id IS NULL
  AND p.nha_tro_id = t.nha_tro_id
  AND p.tang = t.so_tang;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'phong_tang_id_fkey'
          AND conrelid = 'public.phong'::regclass
    ) THEN
        ALTER TABLE public.phong
            ADD CONSTRAINT phong_tang_id_fkey
            FOREIGN KEY (tang_id) REFERENCES public.tang(id) ON DELETE SET NULL;
    END IF;
END $$;

COMMIT;