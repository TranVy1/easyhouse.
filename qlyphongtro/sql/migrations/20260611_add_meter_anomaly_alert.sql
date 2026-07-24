CREATE TABLE IF NOT EXISTS public.meter_anomaly_alert (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    chi_so_id uuid NOT NULL REFERENCES public.chi_so_dien_nuoc(id) ON DELETE CASCADE,
    phong_id uuid NOT NULL REFERENCES public.phong(id) ON DELETE CASCADE,
    hop_dong_id uuid NULL REFERENCES public.hop_dong(id) ON DELETE SET NULL,
    loai varchar(30) NOT NULL,
    ky_thang int NOT NULL,
    ky_nam int NOT NULL,
    tieu_thu_hien_tai int NOT NULL,
    tieu_thu_trung_binh numeric(12,2),
    ty_le_tang numeric(12,2),
    muc_do varchar(20) NOT NULL,
    ly_do text NOT NULL,
    trang_thai varchar(20) NOT NULL DEFAULT 'OPEN',
    resolved_at timestamptz NULL,
    resolved_by uuid NULL REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    tao_luc timestamptz NOT NULL DEFAULT now()
);
