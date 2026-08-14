-- Keep the debt-reminder rule constraint aligned with ReminderType.DUE_TODAY.
ALTER TABLE public.debt_reminder_log
    DROP CONSTRAINT IF EXISTS debt_reminder_log_reminder_type_check;

ALTER TABLE public.debt_reminder_log
    ADD CONSTRAINT debt_reminder_log_reminder_type_check
    CHECK ((reminder_type)::text = ANY (ARRAY[
        'DUE_IN_3_DAYS', 'DUE_TOMORROW', 'DUE_TODAY',
        'OVERDUE_1_DAY', 'OVERDUE_3_DAYS', 'OVERDUE_7_DAYS',
        'OVERDUE_15_DAYS', 'OVERDUE_30_DAYS', 'MANUAL'
    ]));

-- Regular invoices must not carry old debt forward.  Remove legacy opening
-- balances and recalculate those headers strictly from their own detail lines.
UPDATE public.hoa_don h
SET so_du_dau_ky = 0,
    tong_tien_phat_sinh = COALESCE((
        SELECT SUM(ct.thanh_tien)
        FROM public.chi_tiet_hoa_don ct
        WHERE ct.hoa_don_id = h.id
    ), 0),
    tong_tien = COALESCE((
        SELECT SUM(ct.thanh_tien)
        FROM public.chi_tiet_hoa_don ct
        WHERE ct.hoa_don_id = h.id
    ), 0)
WHERE h.xoa_luc IS NULL
  AND h.loai_hoa_don = 'REGULAR'
  AND COALESCE(h.so_du_dau_ky, 0) <> 0;

-- If a legacy record still has a header/detail rounding difference after the
-- carry-forward cleanup, add a traceable adjustment line.  The existing
-- invoice-detail trigger then recalculates the header from the reconciled lines.
INSERT INTO public.chi_tiet_hoa_don (
    hoa_don_id, loai, mo_ta, so_luong, don_gia, thanh_tien,
    source_type, pricing_rule_version, period_start, period_end, calculation_hash
)
SELECT
    h.id,
    CASE WHEN reconciliation.delta >= 0 THEN 'OTHER'::public.loai_muc_hoa_don
         ELSE 'DISCOUNT'::public.loai_muc_hoa_don END,
    'Điều chỉnh làm tròn dữ liệu lịch sử',
    1,
    ABS(reconciliation.delta),
    reconciliation.delta,
    'MIGRATION_RECONCILIATION',
    'MIGRATION_RECONCILIATION_V1',
    COALESCE(h.tu_ngay, h.ngay_lap_hoa_don::date),
    COALESCE(h.den_ngay, h.ngay_lap_hoa_don::date),
    md5(concat_ws('|', h.id, 'MIGRATION_RECONCILIATION_V1', reconciliation.delta,
        h.tu_ngay, h.den_ngay))
FROM public.hoa_don h
JOIN LATERAL (
    SELECT h.tong_tien - COALESCE(SUM(ct.thanh_tien), 0) AS delta
    FROM public.chi_tiet_hoa_don ct
    WHERE ct.hoa_don_id = h.id
) reconciliation ON TRUE
WHERE h.xoa_luc IS NULL
  AND reconciliation.delta <> 0
  AND NOT EXISTS (
      SELECT 1
      FROM public.chi_tiet_hoa_don ct
      WHERE ct.hoa_don_id = h.id
        AND ct.source_type = 'MIGRATION_RECONCILIATION'
        AND ct.pricing_rule_version = 'MIGRATION_RECONCILIATION_V1'
  );

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM public.hoa_don h
        WHERE h.xoa_luc IS NULL
          AND h.tong_tien <> COALESCE((
              SELECT SUM(ct.thanh_tien)
              FROM public.chi_tiet_hoa_don ct
              WHERE ct.hoa_don_id = h.id
          ), 0)
    ) THEN
        RAISE EXCEPTION 'Invoice reconciliation failed';
    END IF;
END $$;
