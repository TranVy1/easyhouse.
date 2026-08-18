-- ============================================================================
-- Yeu cau huy / gia han hop dong tu khach thue, va bien ban ban giao ky dien tu.
--
-- NGUYEN TAC AN TOAN: file nay CHI THEM MOI.
--   - Khong DROP bat ky doi tuong nao.
--   - Khong ALTER kieu du lieu hay doi ten cot dang co.
--   - Moi lenh deu IF NOT EXISTS nen chay lai nhieu lan khong loi.
-- Chay trong mot transaction voi ON_ERROR_STOP=1: loi la rollback sach.
-- ============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Yeu cau huy / gia han hop dong do khach thue gui, admin duyet.
--    Dung chung mot bang cho ca hai loai vi vong doi va cot duyet giong het
--    nhau; tach hai bang chi lam trung lap logic duyet.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.yeu_cau_hop_dong (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hop_dong_id uuid NOT NULL REFERENCES public.hop_dong(id) ON DELETE CASCADE,

    -- HUY | GIA_HAN
    loai character varying(16) NOT NULL,
    -- CHO_DUYET | DA_DUYET | TU_CHOI | DA_HUY_YEU_CAU
    trang_thai character varying(20) NOT NULL DEFAULT 'CHO_DUYET',

    ly_do text,
    -- HUY: ngay mong muon tra phong. GIA_HAN: ngay ket thuc mong muon.
    ngay_mong_muon date,
    -- Chi dung cho GIA_HAN.
    so_thang_gia_han integer,

    nguoi_tao_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    nguoi_duyet_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    ghi_chu_duyet text,
    duyet_luc timestamp with time zone,

    tao_luc timestamp with time zone NOT NULL DEFAULT now(),
    cap_nhat_luc timestamp with time zone NOT NULL DEFAULT now(),

    CONSTRAINT yeu_cau_hop_dong_loai_check
        CHECK (loai IN ('HUY', 'GIA_HAN')),
    CONSTRAINT yeu_cau_hop_dong_trang_thai_check
        CHECK (trang_thai IN ('CHO_DUYET', 'DA_DUYET', 'TU_CHOI', 'DA_HUY_YEU_CAU')),
    -- Gia han thi bat buoc co so thang duong; huy thi khong dung cot nay.
    CONSTRAINT yeu_cau_hop_dong_so_thang_check
        CHECK (
            (loai = 'GIA_HAN' AND so_thang_gia_han IS NOT NULL AND so_thang_gia_han > 0)
            OR (loai = 'HUY' AND so_thang_gia_han IS NULL)
        )
);

CREATE INDEX IF NOT EXISTS idx_yeu_cau_hop_dong_hop_dong
    ON public.yeu_cau_hop_dong(hop_dong_id);
CREATE INDEX IF NOT EXISTS idx_yeu_cau_hop_dong_trang_thai
    ON public.yeu_cau_hop_dong(trang_thai, tao_luc DESC);

-- Moi hop dong chi duoc co toi da MOT yeu cau dang cho duyet. Chan khach gui
-- trung va chan hai admin duyet song song tren cung mot hop dong.
CREATE UNIQUE INDEX IF NOT EXISTS uq_yeu_cau_hop_dong_cho_duyet
    ON public.yeu_cau_hop_dong(hop_dong_id)
    WHERE trang_thai = 'CHO_DUYET';

-- ---------------------------------------------------------------------------
-- 2. Bien ban ban giao: them cot vao quyet_toan_tra_phong (da 1-1 voi hop dong)
--    thay vi tao bang moi.
-- ---------------------------------------------------------------------------
ALTER TABLE public.quyet_toan_tra_phong
    ADD COLUMN IF NOT EXISTS bien_ban_pdf_url text,
    -- CHUA_LAP | CHO_KY | BEN_A_DA_KY | BEN_B_DA_KY | HOAN_TAT
    ADD COLUMN IF NOT EXISTS bien_ban_trang_thai character varying(20) NOT NULL DEFAULT 'CHUA_LAP',
    ADD COLUMN IF NOT EXISTS ben_a_ky_luc timestamp with time zone,
    ADD COLUMN IF NOT EXISTS ben_b_ky_luc timestamp with time zone,
    ADD COLUMN IF NOT EXISTS ben_a_chu_ky_url text,
    ADD COLUMN IF NOT EXISTS ben_b_chu_ky_url text,
    -- "Viec ban giao ket thuc vao luc .... h cung ngay" trong mau bien ban.
    ADD COLUMN IF NOT EXISTS gio_ban_giao character varying(10);

-- Rang buoc trang thai bien ban. Them roi moi kiem tra de chay lai khong loi.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'quyet_toan_tra_phong_bien_ban_trang_thai_check'
    ) THEN
        ALTER TABLE public.quyet_toan_tra_phong
            ADD CONSTRAINT quyet_toan_tra_phong_bien_ban_trang_thai_check
            CHECK (bien_ban_trang_thai IN
                ('CHUA_LAP', 'CHO_KY', 'BEN_A_DA_KY', 'BEN_B_DA_KY', 'HOAN_TAT'));
    END IF;
END
$$;

-- ---------------------------------------------------------------------------
-- 3. Muc khau tru de xuat cho tung tai san, lam can cu tru tien coc.
--    Tach khoi ghi_chu de tinh tong duoc bang SQL thay vi parse chuoi.
-- ---------------------------------------------------------------------------
ALTER TABLE public.chi_tiet_ban_giao_tai_san
    ADD COLUMN IF NOT EXISTS muc_khau_tru numeric(18,2) NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS ly_do_khau_tru text;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'chi_tiet_ban_giao_tai_san_khau_tru_check'
    ) THEN
        ALTER TABLE public.chi_tiet_ban_giao_tai_san
            ADD CONSTRAINT chi_tiet_ban_giao_tai_san_khau_tru_check
            CHECK (muc_khau_tru >= 0);
    END IF;
END
$$;

COMMIT;
