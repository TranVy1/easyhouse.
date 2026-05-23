-- ========================================================================
-- 7. OPERATIONS, MEDIA, NOTIFICATIONS
-- ========================================================================

CREATE TABLE public.su_co (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    phong_id uuid NOT NULL REFERENCES public.phong(id) ON DELETE CASCADE,
    khach_thue_id uuid REFERENCES public.khach_thue(id) ON DELETE SET NULL,
    nguoi_bao_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    tieu_de varchar(255) NOT NULL,
    mo_ta text NOT NULL,
    loai_su_co public.loai_su_co_enum NOT NULL DEFAULT 'khac',
    uu_tien public.uu_tien_enum NOT NULL DEFAULT 'trung_binh',
    trang_thai public.trang_thai_su_co NOT NULL DEFAULT 'PENDING',
    nguoi_phu_trach_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    chi_phi_sua_chua numeric(15,2) NOT NULL DEFAULT 0,
    tinh_vao_hoa_don boolean NOT NULL DEFAULT false,
    ghi_chu_chu_nha text,
    giai_quyet_luc timestamptz,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_su_co_chi_phi CHECK (chi_phi_sua_chua >= 0)
);

ALTER TABLE public.chi_tiet_hoa_don
ADD CONSTRAINT fk_cthd_su_co
FOREIGN KEY (su_co_id) REFERENCES public.su_co(id) ON DELETE SET NULL;

CREATE TABLE public.lich_hen (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    phong_id uuid NOT NULL REFERENCES public.phong(id) ON DELETE CASCADE,
    nguoi_dung_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    ho_ten varchar(255),
    so_dien_thoai varchar(20),
    email varchar(255),
    ngay_hen timestamptz NOT NULL,
    trang_thai public.trang_thai_lich_hen NOT NULL DEFAULT 'PENDING',
    google_calendar_event_id text,
    da_gui_nhac_nho boolean NOT NULL DEFAULT false,
    ghi_chu text,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.file_media (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    doi_tuong public.loai_doi_tuong_media NOT NULL,
    doi_tuong_id uuid NOT NULL,
    url text NOT NULL,
    public_id text,
    loai_file varchar(100),
    kich_thuoc_bytes bigint,
    metadata jsonb,
    nguoi_tai_len_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT chk_file_size CHECK (kich_thuoc_bytes IS NULL OR kich_thuoc_bytes >= 0)
);

CREATE TABLE public.thong_bao (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nguoi_gui_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    loai public.loai_thong_bao NOT NULL DEFAULT 'SYSTEM',
    tieu_de varchar(255) NOT NULL,
    noi_dung text NOT NULL,
    doi_tuong public.loai_doi_tuong_media,
    doi_tuong_id uuid,
    kenh public.kenh_thong_bao NOT NULL DEFAULT 'IN_APP',
    gui_tat_ca boolean NOT NULL DEFAULT false,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    xoa_luc timestamptz
);

CREATE TABLE public.thong_bao_nguoi_nhan (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    thong_bao_id uuid NOT NULL REFERENCES public.thong_bao(id) ON DELETE CASCADE,
    nguoi_dung_id uuid NOT NULL REFERENCES public.nguoi_dung(id) ON DELETE CASCADE,
    da_doc boolean NOT NULL DEFAULT false,
    doc_luc timestamptz,
    gui_luc timestamptz,
    loi_gui text,
    UNIQUE (thong_bao_id, nguoi_dung_id)
);

CREATE TABLE public.audit_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nguoi_dung_id uuid REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    hanh_dong varchar(100) NOT NULL,
    bang_tac_dong varchar(100),
    ban_ghi_id uuid,
    du_lieu_cu jsonb,
    du_lieu_moi jsonb,
    ip_address inet,
    user_agent text,
    tao_luc timestamptz NOT NULL DEFAULT now()
);

-- ========================================================================
-- 8. FUNCTIONS AND TRIGGERS
-- ========================================================================

CREATE OR REPLACE FUNCTION public.cap_nhat_thoi_gian()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.cap_nhat_luc = now();
    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.recalc_hoa_don_from_chi_tiet()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_hoa_don_id uuid;
BEGIN
    v_hoa_don_id = COALESCE(NEW.hoa_don_id, OLD.hoa_don_id);

    UPDATE public.hoa_don hd
    SET tong_tien_phat_sinh = COALESCE((
            SELECT sum(ct.thanh_tien)
            FROM public.chi_tiet_hoa_don ct
            WHERE ct.hoa_don_id = v_hoa_don_id
        ), 0),
        tong_tien = hd.so_du_dau_ky + COALESCE((
            SELECT sum(ct.thanh_tien)
            FROM public.chi_tiet_hoa_don ct
            WHERE ct.hoa_don_id = v_hoa_don_id
        ), 0),
        cap_nhat_luc = now()
    WHERE hd.id = v_hoa_don_id;

    RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE OR REPLACE FUNCTION public.recalc_hoa_don_from_thanh_toan()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_hoa_don_id uuid;
BEGIN
    v_hoa_don_id = COALESCE(NEW.hoa_don_id, OLD.hoa_don_id);

    UPDATE public.hoa_don hd
    SET da_tra = COALESCE((
            SELECT sum(tt.so_tien)
            FROM public.thanh_toan tt
            WHERE tt.hoa_don_id = v_hoa_don_id
              AND tt.trang_thai = 'SUCCESS'
        ), 0),
        cap_nhat_luc = now()
    WHERE hd.id = v_hoa_don_id;

    RETURN COALESCE(NEW, OLD);
END;
$$;

CREATE OR REPLACE FUNCTION public.cap_nhat_trang_thai_hoa_don()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.trang_thai = 'CANCELLED' THEN
        RETURN NEW;
    END IF;

    IF NEW.trang_thai = 'DRAFT' AND NEW.tong_tien = 0 AND NEW.da_tra = 0 THEN
        RETURN NEW;
    END IF;

    IF NEW.da_tra = 0 AND NEW.han_tra < CURRENT_DATE THEN
        NEW.trang_thai = 'OVERDUE';
    ELSIF NEW.da_tra = 0 THEN
        NEW.trang_thai = 'UNPAID';
    ELSIF NEW.da_tra < NEW.tong_tien THEN
        NEW.trang_thai = 'PARTIAL';
    ELSIF NEW.da_tra = NEW.tong_tien THEN
        NEW.trang_thai = 'PAID';
    ELSE
        NEW.trang_thai = 'OVERPAID';
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_nguoi_dung_cap_nhat BEFORE UPDATE ON public.nguoi_dung
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_nha_tro_cap_nhat BEFORE UPDATE ON public.nha_tro
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_phong_cap_nhat BEFORE UPDATE ON public.phong
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_khach_thue_cap_nhat BEFORE UPDATE ON public.khach_thue
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_hop_dong_cap_nhat BEFORE UPDATE ON public.hop_dong
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_thanh_vien_cap_nhat BEFORE UPDATE ON public.thanh_vien_hop_dong
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_dich_vu_cap_nhat BEFORE UPDATE ON public.dich_vu
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_cau_hinh_gia_cap_nhat BEFORE UPDATE ON public.cau_hinh_gia
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_chi_so_cap_nhat BEFORE UPDATE ON public.chi_so_dien_nuoc
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_hoa_don_cap_nhat BEFORE UPDATE ON public.hoa_don
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_su_co_cap_nhat BEFORE UPDATE ON public.su_co
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_lich_hen_cap_nhat BEFORE UPDATE ON public.lich_hen
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();
CREATE TRIGGER trg_thong_bao_cap_nhat BEFORE UPDATE ON public.thong_bao
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();

CREATE TRIGGER trg_cthd_recalc AFTER INSERT OR UPDATE OR DELETE ON public.chi_tiet_hoa_don
FOR EACH ROW EXECUTE FUNCTION public.recalc_hoa_don_from_chi_tiet();

CREATE TRIGGER trg_thanh_toan_recalc AFTER INSERT OR UPDATE OR DELETE ON public.thanh_toan
FOR EACH ROW EXECUTE FUNCTION public.recalc_hoa_don_from_thanh_toan();

CREATE TRIGGER trg_hoa_don_status BEFORE INSERT OR UPDATE OF tong_tien, da_tra, han_tra, trang_thai ON public.hoa_don
FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_trang_thai_hoa_don();

-- ========================================================================
-- 9. INDEXES
-- ========================================================================

CREATE INDEX idx_nguoi_dung_email ON public.nguoi_dung (email);
CREATE INDEX idx_nguoi_dung_trang_thai ON public.nguoi_dung (trang_thai);
CREATE INDEX idx_login_history_user_time ON public.login_history (nguoi_dung_id, tao_luc DESC);

CREATE INDEX idx_nha_tro_chu_tro ON public.nha_tro (chu_tro_id);
CREATE INDEX idx_ndnt_nha_tro_user ON public.nguoi_dung_nha_tro (nha_tro_id, nguoi_dung_id);
CREATE INDEX idx_phong_nha_tro ON public.phong (nha_tro_id);
CREATE INDEX idx_phong_trang_thai ON public.phong (trang_thai);

CREATE INDEX idx_khach_thue_chu_tro ON public.khach_thue (chu_tro_id);
CREATE INDEX idx_khach_thue_sdt ON public.khach_thue (so_dien_thoai);
CREATE INDEX idx_hop_dong_phong_status_dates ON public.hop_dong (phong_id, trang_thai, ngay_bat_dau, ngay_ket_thuc);
CREATE INDEX idx_hop_dong_khach_thue ON public.hop_dong (khach_thue_id);
CREATE INDEX idx_tvhd_hop_dong ON public.thanh_vien_hop_dong (hop_dong_id);
CREATE INDEX idx_dat_coc_phong ON public.dat_coc_phong (phong_id, trang_thai);

CREATE INDEX idx_cau_hinh_gia_nha_tro ON public.cau_hinh_gia (nha_tro_id, loai, dang_ap_dung);
CREATE INDEX idx_dvhd_hop_dong ON public.dich_vu_hop_dong (hop_dong_id);
CREATE INDEX idx_chi_so_phong_ky ON public.chi_so_dien_nuoc (phong_id, loai, ky_nam, ky_thang);

CREATE INDEX idx_hoa_don_hop_dong_ky ON public.hoa_don (hop_dong_id, ky_nam, ky_thang);
CREATE INDEX idx_hoa_don_phong ON public.hoa_don (phong_id);
CREATE INDEX idx_hoa_don_khach_thue ON public.hoa_don (khach_thue_id);
CREATE INDEX idx_hoa_don_status_due ON public.hoa_don (trang_thai, han_tra);
CREATE INDEX idx_cthd_hoa_don ON public.chi_tiet_hoa_don (hoa_don_id);
CREATE INDEX idx_thanh_toan_hoa_don ON public.thanh_toan (hoa_don_id);
CREATE INDEX idx_thanh_toan_ref ON public.thanh_toan (ma_tham_chieu);

CREATE INDEX idx_su_co_phong_status ON public.su_co (phong_id, trang_thai);
CREATE INDEX idx_lich_hen_phong_time ON public.lich_hen (phong_id, ngay_hen);
CREATE INDEX idx_file_media_target ON public.file_media (doi_tuong, doi_tuong_id);
CREATE INDEX idx_thong_bao_recipient ON public.thong_bao_nguoi_nhan (nguoi_dung_id, da_doc);
CREATE INDEX idx_audit_log_target ON public.audit_log (bang_tac_dong, ban_ghi_id);

