-- Quyết toán trả phòng: giữ chứng từ khoản khấu trừ, hoàn cọc và chỉ giải phóng phòng sau bàn giao/kiểm tra.

ALTER TABLE public.hoa_don
    ADD COLUMN IF NOT EXISTS loai_hoa_don varchar(32) NOT NULL DEFAULT 'REGULAR';

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

CREATE TABLE IF NOT EXISTS public.quyet_toan_tra_phong (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hop_dong_id uuid NOT NULL UNIQUE REFERENCES public.hop_dong(id),
    hoa_don_id uuid NOT NULL UNIQUE REFERENCES public.hoa_don(id),
    ngay_tra_phong date NOT NULL,
    tien_coc_ban_dau numeric(18,2) NOT NULL DEFAULT 0,
    tien_coc_da_can_tru numeric(18,2) NOT NULL DEFAULT 0,
    tien_coc_can_hoan numeric(18,2) NOT NULL DEFAULT 0,
    tien_phai_thu_them numeric(18,2) NOT NULL DEFAULT 0,
    khoan_khau_tru jsonb NOT NULL DEFAULT '[]'::jsonb,
    trang_thai varchar(32) NOT NULL,
    ban_giao_da_xac_nhan boolean NOT NULL DEFAULT false,
    ve_sinh_kiem_tra_xong boolean NOT NULL DEFAULT false,
    hoan_coc_luc timestamptz,
    ban_giao_luc timestamptz,
    kiem_tra_luc timestamptz,
    hoan_tat_luc timestamptz,
    ghi_chu text,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT quyet_toan_tra_phong_tien_non_negative CHECK (
        tien_coc_ban_dau >= 0 AND tien_coc_da_can_tru >= 0 AND tien_coc_can_hoan >= 0 AND tien_phai_thu_them >= 0
    ),
    CONSTRAINT quyet_toan_tra_phong_coc_balance CHECK (tien_coc_da_can_tru + tien_coc_can_hoan = tien_coc_ban_dau)
);

CREATE INDEX IF NOT EXISTS idx_quyet_toan_tra_phong_trang_thai
    ON public.quyet_toan_tra_phong(trang_thai);
