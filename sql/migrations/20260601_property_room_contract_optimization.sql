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
        WHERE conname = 'phong_nha_tro_id_tang_id_fkey'
          AND conrelid = 'public.phong'::regclass
    ) THEN
        ALTER TABLE public.phong
            ADD CONSTRAINT phong_nha_tro_id_tang_id_fkey
            FOREIGN KEY (nha_tro_id, tang_id) REFERENCES public.tang(nha_tro_id, id)
            ON DELETE RESTRICT;
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'chk_phong_tang_hop_le'
          AND conrelid = 'public.phong'::regclass
    ) THEN
        ALTER TABLE public.phong
            ADD CONSTRAINT chk_phong_tang_hop_le
            CHECK ((tang IS NOT NULL) OR (tang_id IS NOT NULL));
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_tang_nha_tro_so_tang
    ON public.tang (nha_tro_id, so_tang)
    WHERE xoa_luc IS NULL;

CREATE INDEX IF NOT EXISTS idx_phong_nha_tro_tang
    ON public.phong (nha_tro_id, tang, ten)
    WHERE xoa_luc IS NULL;

CREATE INDEX IF NOT EXISTS idx_phong_tang_id
    ON public.phong (tang_id)
    WHERE xoa_luc IS NULL;

ALTER TABLE public.hop_dong
    ADD COLUMN IF NOT EXISTS template_version character varying(100),
    ADD COLUMN IF NOT EXISTS previewed_at timestamp with time zone,
    ADD COLUMN IF NOT EXISTS confirmed_at timestamp with time zone,
    ADD COLUMN IF NOT EXISTS locked_at timestamp with time zone;

CREATE TABLE IF NOT EXISTS public.lich_thanh_toan (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hop_dong_id uuid NOT NULL,
    ky_nam integer NOT NULL,
    ky_thang integer NOT NULL,
    tu_ngay date NOT NULL,
    den_ngay date NOT NULL,
    han_thanh_toan date NOT NULL,
    so_tien_du_kien numeric(15,2) NOT NULL,
    hoa_don_id uuid,
    trang_thai character varying(30) DEFAULT 'PENDING'::character varying NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    CONSTRAINT chk_lich_thanh_toan_ky CHECK ((((ky_thang >= 1) AND (ky_thang <= 12)) AND ((ky_nam >= 2000) AND (ky_nam <= 2100)))),
    CONSTRAINT chk_lich_thanh_toan_ngay CHECK ((den_ngay >= tu_ngay) AND (han_thanh_toan >= tu_ngay)),
    CONSTRAINT chk_lich_thanh_toan_tien CHECK (so_tien_du_kien >= (0)::numeric)
);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'lich_thanh_toan_pkey'
          AND conrelid = 'public.lich_thanh_toan'::regclass
    ) THEN
        ALTER TABLE public.lich_thanh_toan
            ADD CONSTRAINT lich_thanh_toan_pkey PRIMARY KEY (id);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'lich_thanh_toan_hop_dong_id_ky_nam_ky_thang_key'
          AND conrelid = 'public.lich_thanh_toan'::regclass
    ) THEN
        ALTER TABLE public.lich_thanh_toan
            ADD CONSTRAINT lich_thanh_toan_hop_dong_id_ky_nam_ky_thang_key
            UNIQUE (hop_dong_id, ky_nam, ky_thang);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'lich_thanh_toan_hop_dong_id_fkey'
          AND conrelid = 'public.lich_thanh_toan'::regclass
    ) THEN
        ALTER TABLE public.lich_thanh_toan
            ADD CONSTRAINT lich_thanh_toan_hop_dong_id_fkey
            FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE CASCADE;
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'lich_thanh_toan_hoa_don_id_fkey'
          AND conrelid = 'public.lich_thanh_toan'::regclass
    ) THEN
        ALTER TABLE public.lich_thanh_toan
            ADD CONSTRAINT lich_thanh_toan_hoa_don_id_fkey
            FOREIGN KEY (hoa_don_id) REFERENCES public.hoa_don(id) ON DELETE SET NULL;
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_lich_thanh_toan_hop_dong
    ON public.lich_thanh_toan (hop_dong_id, ky_nam, ky_thang)
    WHERE xoa_luc IS NULL;

CREATE INDEX IF NOT EXISTS idx_lich_thanh_toan_han
    ON public.lich_thanh_toan (han_thanh_toan, trang_thai)
    WHERE xoa_luc IS NULL;

ALTER TABLE public.hop_dong
    ADD COLUMN IF NOT EXISTS template_version character varying(50),
    ADD COLUMN IF NOT EXISTS previewed_at timestamp with time zone,
    ADD COLUMN IF NOT EXISTS confirmed_at timestamp with time zone,
    ADD COLUMN IF NOT EXISTS locked_at timestamp with time zone;

CREATE OR REPLACE VIEW public.v_so_do_toa_nha AS
SELECT
    nt.id AS nha_tro_id,
    nt.ten AS ten_toa_nha,
    COALESCE(t.so_tang, p.tang) AS so_tang,
    COALESCE(t.ten_tang, 'Tang ' || COALESCE(t.so_tang, p.tang)::text) AS ten_tang,
    p.id AS phong_id,
    p.ten AS ma_phong,
    p.dien_tich,
    p.gia_hien_tai,
    p.trang_thai AS trang_thai_vat_ly,
    hd.id AS hop_dong_id,
    hd.ma_hop_dong,
    hd.ngay_bat_dau,
    hd.ngay_ket_thuc,
    kt.id AS khach_thue_id,
    kt.ho_ten AS khach_thue_hien_tai,
    CASE
        WHEN p.trang_thai = 'MAINTENANCE'::public.trang_thai_phong THEN 'MAINTENANCE'
        WHEN hd.id IS NULL THEN 'VACANT'
        WHEN hd.ngay_ket_thuc <= (CURRENT_DATE + INTERVAL '30 days') THEN 'CONTRACT_EXPIRING'
        ELSE 'RENTED'
    END AS trang_thai_hien_thi
FROM public.nha_tro nt
LEFT JOIN public.tang t
    ON t.nha_tro_id = nt.id
   AND t.xoa_luc IS NULL
LEFT JOIN public.phong p
    ON p.nha_tro_id = nt.id
   AND p.xoa_luc IS NULL
   AND (p.tang_id = t.id OR (p.tang_id IS NULL AND p.tang = t.so_tang))
LEFT JOIN LATERAL (
    SELECT h.*
    FROM public.hop_dong h
    WHERE h.phong_id = p.id
      AND h.xoa_luc IS NULL
      AND h.trang_thai = ANY (ARRAY['PENDING'::public.trang_thai_hop_dong, 'ACTIVE'::public.trang_thai_hop_dong])
      AND CURRENT_DATE BETWEEN h.ngay_bat_dau AND h.ngay_ket_thuc
    ORDER BY h.ngay_bat_dau DESC
    LIMIT 1
) hd ON true
LEFT JOIN public.khach_thue kt
    ON kt.id = hd.khach_thue_id
WHERE nt.xoa_luc IS NULL;

CREATE OR REPLACE VIEW public.v_thong_ke_toa_nha AS
SELECT
    nt.id AS nha_tro_id,
    nt.ten AS ten_toa_nha,
    count(DISTINCT t.id) AS tong_so_tang,
    count(DISTINCT p.id) AS tong_so_phong,
    count(DISTINCT p.id) FILTER (
        WHERE p.trang_thai = 'AVAILABLE'::public.trang_thai_phong
          AND hd.id IS NULL
    ) AS phong_trong,
    count(DISTINCT p.id) FILTER (
        WHERE hd.id IS NOT NULL
    ) AS phong_dang_thue,
    count(DISTINCT p.id) FILTER (
        WHERE p.trang_thai = 'MAINTENANCE'::public.trang_thai_phong
    ) AS phong_bao_tri,
    count(DISTINCT p.id) FILTER (
        WHERE hd.id IS NOT NULL
          AND hd.ngay_ket_thuc <= (CURRENT_DATE + INTERVAL '30 days')
    ) AS hop_dong_sap_het_han,
    COALESCE(sum(hd.gia_thue_hop_dong), 0) AS doanh_thu_du_kien_thang
FROM public.nha_tro nt
LEFT JOIN public.tang t
    ON t.nha_tro_id = nt.id
   AND t.xoa_luc IS NULL
LEFT JOIN public.phong p
    ON p.nha_tro_id = nt.id
   AND p.xoa_luc IS NULL
LEFT JOIN LATERAL (
    SELECT h.*
    FROM public.hop_dong h
    WHERE h.phong_id = p.id
      AND h.xoa_luc IS NULL
      AND h.trang_thai = ANY (ARRAY['PENDING'::public.trang_thai_hop_dong, 'ACTIVE'::public.trang_thai_hop_dong])
      AND CURRENT_DATE BETWEEN h.ngay_bat_dau AND h.ngay_ket_thuc
    ORDER BY h.ngay_bat_dau DESC
    LIMIT 1
) hd ON true
WHERE nt.xoa_luc IS NULL
GROUP BY nt.id, nt.ten;

CREATE OR REPLACE FUNCTION public.sinh_phong_toa_nha(
    p_nha_tro_id uuid,
    p_so_tang integer,
    p_so_phong_moi_tang integer,
    p_dien_tich numeric DEFAULT 20,
    p_gia_hien_tai numeric DEFAULT 0,
    p_tien_coc_mac_dinh numeric DEFAULT 0,
    p_so_nguoi_toi_da integer DEFAULT 2
)
RETURNS TABLE(tang_duoc_tao integer, phong_duoc_tao integer)
LANGUAGE plpgsql
AS $$
DECLARE
    v_tang integer;
    v_phong integer;
    v_tang_id uuid;
    v_ma_phong text;
    v_tang_count integer := 0;
    v_phong_count integer := 0;
BEGIN
    IF p_so_tang <= 0 OR p_so_phong_moi_tang <= 0 THEN
        RAISE EXCEPTION 'p_so_tang va p_so_phong_moi_tang phai lon hon 0';
    END IF;

    IF p_dien_tich <= 0 OR p_gia_hien_tai < 0 OR p_tien_coc_mac_dinh < 0 OR p_so_nguoi_toi_da <= 0 THEN
        RAISE EXCEPTION 'Thong so phong khong hop le';
    END IF;

    FOR v_tang IN 1..p_so_tang LOOP
        INSERT INTO public.tang (nha_tro_id, so_tang, ten_tang, thu_tu_hien_thi, so_phong_du_kien)
        VALUES (p_nha_tro_id, v_tang, 'Tang ' || v_tang::text, v_tang, p_so_phong_moi_tang)
        ON CONFLICT (nha_tro_id, so_tang) DO UPDATE
        SET
            so_phong_du_kien = EXCLUDED.so_phong_du_kien,
            cap_nhat_luc = now()
        RETURNING id INTO v_tang_id;

        v_tang_count := v_tang_count + 1;

        FOR v_phong IN 1..p_so_phong_moi_tang LOOP
            v_ma_phong := (v_tang * 100 + v_phong)::text;

            INSERT INTO public.phong (
                nha_tro_id,
                tang_id,
                ten,
                tang,
                dien_tich,
                so_nguoi_toi_da,
                trang_thai,
                gia_hien_tai,
                tien_coc_mac_dinh
            )
            VALUES (
                p_nha_tro_id,
                v_tang_id,
                v_ma_phong,
                v_tang,
                p_dien_tich,
                p_so_nguoi_toi_da,
                'AVAILABLE'::public.trang_thai_phong,
                p_gia_hien_tai,
                p_tien_coc_mac_dinh
            )
            ON CONFLICT (nha_tro_id, ten) DO NOTHING;

            IF FOUND THEN
                v_phong_count := v_phong_count + 1;
            END IF;
        END LOOP;
    END LOOP;

    RETURN QUERY SELECT v_tang_count, v_phong_count;
END;
$$;

CREATE OR REPLACE FUNCTION public.clone_cau_truc_toa_nha(
    p_nha_tro_nguon_id uuid,
    p_nha_tro_dich_id uuid
)
RETURNS TABLE(tang_duoc_tao integer, phong_duoc_tao integer)
LANGUAGE plpgsql
AS $$
DECLARE
    v_tang record;
    v_phong record;
    v_tang_moi_id uuid;
    v_tang_count integer := 0;
    v_phong_count integer := 0;
BEGIN
    FOR v_tang IN
        SELECT *
        FROM public.tang
        WHERE nha_tro_id = p_nha_tro_nguon_id
          AND xoa_luc IS NULL
        ORDER BY so_tang
    LOOP
        INSERT INTO public.tang (
            nha_tro_id,
            so_tang,
            ten_tang,
            thu_tu_hien_thi,
            so_phong_du_kien,
            trang_thai
        )
        VALUES (
            p_nha_tro_dich_id,
            v_tang.so_tang,
            v_tang.ten_tang,
            v_tang.thu_tu_hien_thi,
            v_tang.so_phong_du_kien,
            v_tang.trang_thai
        )
        ON CONFLICT (nha_tro_id, so_tang) DO UPDATE
        SET
            ten_tang = EXCLUDED.ten_tang,
            thu_tu_hien_thi = EXCLUDED.thu_tu_hien_thi,
            so_phong_du_kien = EXCLUDED.so_phong_du_kien,
            trang_thai = EXCLUDED.trang_thai,
            cap_nhat_luc = now()
        RETURNING id INTO v_tang_moi_id;

        v_tang_count := v_tang_count + 1;

        FOR v_phong IN
            SELECT *
            FROM public.phong
            WHERE nha_tro_id = p_nha_tro_nguon_id
              AND tang_id = v_tang.id
              AND xoa_luc IS NULL
            ORDER BY ten
        LOOP
            INSERT INTO public.phong (
                nha_tro_id,
                tang_id,
                ten,
                khu_vuc,
                tang,
                dien_tich,
                so_nguoi_toi_da,
                trang_thai,
                gia_hien_tai,
                tien_coc_mac_dinh,
                mo_ta
            )
            VALUES (
                p_nha_tro_dich_id,
                v_tang_moi_id,
                v_phong.ten,
                v_phong.khu_vuc,
                v_phong.tang,
                v_phong.dien_tich,
                v_phong.so_nguoi_toi_da,
                'AVAILABLE'::public.trang_thai_phong,
                v_phong.gia_hien_tai,
                v_phong.tien_coc_mac_dinh,
                v_phong.mo_ta
            )
            ON CONFLICT (nha_tro_id, ten) DO NOTHING;

            IF FOUND THEN
                v_phong_count := v_phong_count + 1;
            END IF;
        END LOOP;
    END LOOP;

    RETURN QUERY SELECT v_tang_count, v_phong_count;
END;
$$;

CREATE OR REPLACE FUNCTION public.tao_lich_thanh_toan_hang_thang(p_hop_dong_id uuid)
RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
    v_hd public.hop_dong%ROWTYPE;
    v_ngay date;
    v_tu_ngay date;
    v_den_ngay date;
    v_han_thanh_toan date;
    v_count integer := 0;
BEGIN
    SELECT *
    INTO v_hd
    FROM public.hop_dong
    WHERE id = p_hop_dong_id
      AND xoa_luc IS NULL;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Khong tim thay hop dong %', p_hop_dong_id;
    END IF;

    v_ngay := date_trunc('month', v_hd.ngay_bat_dau)::date;

    WHILE v_ngay <= v_hd.ngay_ket_thuc LOOP
        v_tu_ngay := greatest(v_hd.ngay_bat_dau, v_ngay);
        v_den_ngay := least(v_hd.ngay_ket_thuc, (v_ngay + INTERVAL '1 month - 1 day')::date);
        v_han_thanh_toan := make_date(
            extract(year from v_ngay)::integer,
            extract(month from v_ngay)::integer,
            least(
                v_hd.ngay_thanh_toan_hang_thang,
                extract(day from ((v_ngay + INTERVAL '1 month - 1 day')::date))::integer
            )
        );

        INSERT INTO public.lich_thanh_toan (
            hop_dong_id,
            ky_nam,
            ky_thang,
            tu_ngay,
            den_ngay,
            han_thanh_toan,
            so_tien_du_kien
        )
        VALUES (
            v_hd.id,
            extract(year from v_ngay)::integer,
            extract(month from v_ngay)::integer,
            v_tu_ngay,
            v_den_ngay,
            v_han_thanh_toan,
            v_hd.gia_thue_hop_dong
        )
        ON CONFLICT (hop_dong_id, ky_nam, ky_thang) DO UPDATE
        SET
            tu_ngay = EXCLUDED.tu_ngay,
            den_ngay = EXCLUDED.den_ngay,
            han_thanh_toan = EXCLUDED.han_thanh_toan,
            so_tien_du_kien = EXCLUDED.so_tien_du_kien,
            cap_nhat_luc = now();

        v_count := v_count + 1;
        v_ngay := (v_ngay + INTERVAL '1 month')::date;
    END LOOP;

    RETURN v_count;
END;
$$;

COMMIT;
