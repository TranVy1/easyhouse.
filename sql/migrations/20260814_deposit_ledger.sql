-- Immutable deposit ledger. The contract's tien_coc remains the agreed amount,
-- while this table is the source of truth for money currently held/refunded.

CREATE TABLE IF NOT EXISTS public.giao_dich_tien_coc (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hop_dong_id uuid NOT NULL REFERENCES public.hop_dong(id) ON DELETE RESTRICT,
    thanh_toan_id uuid UNIQUE REFERENCES public.thanh_toan(id) ON DELETE RESTRICT,
    quyet_toan_tra_phong_id uuid REFERENCES public.quyet_toan_tra_phong(id) ON DELETE RESTRICT,
    loai character varying(32) NOT NULL,
    so_tien numeric(18,2) NOT NULL,
    thoi_diem timestamp with time zone NOT NULL DEFAULT now(),
    dien_giai text NOT NULL,
    ma_tham_chieu character varying(150),
    chung_tu_url text,
    tao_luc timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT giao_dich_tien_coc_so_tien_positive CHECK (so_tien > 0),
    CONSTRAINT giao_dich_tien_coc_loai_check CHECK (loai IN ('LEGACY_OPENING', 'HELD', 'DEDUCTION', 'REFUND'))
);

CREATE INDEX IF NOT EXISTS idx_giao_dich_tien_coc_hop_dong_thoi_diem
    ON public.giao_dich_tien_coc(hop_dong_id, thoi_diem);
CREATE UNIQUE INDEX IF NOT EXISTS uq_giao_dich_tien_coc_quyet_toan_loai
    ON public.giao_dich_tien_coc(quyet_toan_tra_phong_id, loai)
    WHERE quyet_toan_tra_phong_id IS NOT NULL;

-- Preserve only deposits which were already confirmed as held. Contracts still
-- marked NOT_PAID intentionally receive no opening balance.
INSERT INTO public.giao_dich_tien_coc (hop_dong_id, loai, so_tien, thoi_diem, dien_giai, ma_tham_chieu)
SELECT hd.id, 'LEGACY_OPENING', hd.tien_coc, COALESCE(hd.tao_luc, now()),
       'Số dư cọc chuyển đổi từ hợp đồng cũ', hd.ma_hop_dong
FROM public.hop_dong hd
WHERE hd.trang_thai_coc = 'KEPT'
  AND hd.tien_coc > 0
  AND NOT EXISTS (
      SELECT 1 FROM public.giao_dich_tien_coc gd
      WHERE gd.hop_dong_id = hd.id AND gd.loai = 'LEGACY_OPENING'
  );

