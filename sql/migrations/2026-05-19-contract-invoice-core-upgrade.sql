-- EasyHouse contract/invoice core upgrade.
-- Safe to run more than once on PostgreSQL.

ALTER TYPE public.trang_thai_hoa_don ADD VALUE IF NOT EXISTS 'OVERDUE';
ALTER TYPE public.loai_muc_hoa_don ADD VALUE IF NOT EXISTS 'INTERNET';
ALTER TYPE public.loai_muc_hoa_don ADD VALUE IF NOT EXISTS 'GARBAGE';
ALTER TYPE public.loai_muc_hoa_don ADD VALUE IF NOT EXISTS 'PARKING';

ALTER TABLE public.hoa_don
    ADD COLUMN IF NOT EXISTS ma_hoa_don varchar(100),
    ADD COLUMN IF NOT EXISTS ngay_phat_hanh date DEFAULT CURRENT_DATE,
    ADD COLUMN IF NOT EXISTS ngay_gui timestamptz,
    ADD COLUMN IF NOT EXISTS da_gui boolean DEFAULT false,
    ADD COLUMN IF NOT EXISTS tien_giam numeric(15, 2) DEFAULT 0,
    ADD COLUMN IF NOT EXISTS phi_phat_sinh numeric(15, 2) DEFAULT 0;

CREATE UNIQUE INDEX IF NOT EXISTS uk_hoa_don_ma_hoa_don_not_null
    ON public.hoa_don (ma_hoa_don)
    WHERE ma_hoa_don IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_hoa_don_hop_dong_thang
    ON public.hoa_don (hop_dong_id, thang_hoa_don);

CREATE INDEX IF NOT EXISTS idx_hoa_don_trang_thai_han_tra
    ON public.hoa_don (trang_thai, han_tra);

CREATE INDEX IF NOT EXISTS idx_hop_dong_phong_trang_thai_dates
    ON public.hop_dong (phong_id, trang_thai, ngay_bat_dau, ngay_ket_thuc);
