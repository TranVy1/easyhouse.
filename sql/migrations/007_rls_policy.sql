-- ========================================================================
-- 10. RLS HELPERS AND POLICIES
-- ========================================================================

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.nguoi_dung_vai_tro ndvt
        JOIN public.vai_tro vt ON vt.id = ndvt.vai_tro_id
        WHERE ndvt.nguoi_dung_id = auth.uid()
          AND vt.ten = 'ADMIN'
    );
$$;

CREATE OR REPLACE FUNCTION public.can_access_nha_tro(p_nha_tro_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT public.is_admin()
        OR EXISTS (
            SELECT 1
            FROM public.nha_tro nt
            WHERE nt.id = p_nha_tro_id
              AND nt.chu_tro_id = auth.uid()
        )
        OR EXISTS (
            SELECT 1
            FROM public.nguoi_dung_nha_tro ndnt
            WHERE ndnt.nha_tro_id = p_nha_tro_id
              AND ndnt.nguoi_dung_id = auth.uid()
              AND ndnt.co_quyen_xem = true
        );
$$;

ALTER TABLE public.nguoi_dung ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vai_tro ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nguoi_dung_vai_tro ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.login_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nha_tro ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nguoi_dung_nha_tro ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.phong ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tien_ich ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.phong_tien_ich ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.khach_thue ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hop_dong ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.thanh_vien_hop_dong ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.phu_luc_hop_dong ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dat_coc_phong ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dich_vu ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cau_hinh_gia ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dich_vu_hop_dong ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chi_so_dien_nuoc ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hoa_don ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chi_tiet_hoa_don ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.thanh_toan ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lich_su_hoa_don ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bank_transaction ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.su_co ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lich_hen ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.file_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.thong_bao ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.thong_bao_nguoi_nhan ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY nguoi_dung_self_or_admin ON public.nguoi_dung
FOR ALL USING (id = auth.uid() OR public.is_admin())
WITH CHECK (id = auth.uid() OR public.is_admin());

CREATE POLICY vai_tro_read_authenticated ON public.vai_tro
FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY nguoi_dung_vai_tro_self_or_admin_read ON public.nguoi_dung_vai_tro
FOR SELECT USING (nguoi_dung_id = auth.uid() OR public.is_admin());

CREATE POLICY nguoi_dung_vai_tro_admin_write ON public.nguoi_dung_vai_tro
FOR ALL USING (public.is_admin())
WITH CHECK (public.is_admin());

CREATE POLICY login_history_self_or_admin ON public.login_history
FOR SELECT USING (nguoi_dung_id = auth.uid() OR public.is_admin());

CREATE POLICY nha_tro_owner_staff ON public.nha_tro
FOR ALL USING (public.can_access_nha_tro(id))
WITH CHECK (chu_tro_id = auth.uid() OR public.is_admin());

CREATE POLICY nguoi_dung_nha_tro_owner_admin ON public.nguoi_dung_nha_tro
FOR ALL USING (
    public.is_admin()
    OR EXISTS (
        SELECT 1
        FROM public.nha_tro nt
        WHERE nt.id = nguoi_dung_nha_tro.nha_tro_id
          AND nt.chu_tro_id = auth.uid()
    )
)
WITH CHECK (
    public.is_admin()
    OR EXISTS (
        SELECT 1
        FROM public.nha_tro nt
        WHERE nt.id = nguoi_dung_nha_tro.nha_tro_id
          AND nt.chu_tro_id = auth.uid()
    )
);

CREATE POLICY phong_by_nha_tro ON public.phong
FOR ALL USING (public.can_access_nha_tro(nha_tro_id))
WITH CHECK (public.can_access_nha_tro(nha_tro_id));

CREATE POLICY tien_ich_read_authenticated ON public.tien_ich
FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY tien_ich_admin_write ON public.tien_ich
FOR ALL USING (public.is_admin())
WITH CHECK (public.is_admin());

CREATE POLICY phong_tien_ich_by_room ON public.phong_tien_ich
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = phong_tien_ich.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = phong_tien_ich.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY khach_thue_owner_or_self ON public.khach_thue
FOR ALL USING (
    public.is_admin()
    OR chu_tro_id = auth.uid()
    OR nguoi_dung_id = auth.uid()
)
WITH CHECK (
    public.is_admin()
    OR chu_tro_id = auth.uid()
    OR nguoi_dung_id = auth.uid()
);

CREATE POLICY hop_dong_by_room_or_tenant ON public.hop_dong
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = hop_dong.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
    OR EXISTS (
        SELECT 1
        FROM public.khach_thue kt
        WHERE kt.id = hop_dong.khach_thue_id
          AND kt.nguoi_dung_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = hop_dong.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY thanh_vien_hop_dong_by_contract ON public.thanh_vien_hop_dong
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.hop_dong hd
        WHERE hd.id = thanh_vien_hop_dong.hop_dong_id
          AND (
              EXISTS (
                  SELECT 1
                  FROM public.phong p
                  WHERE p.id = hd.phong_id
                    AND public.can_access_nha_tro(p.nha_tro_id)
              )
              OR EXISTS (
                  SELECT 1
                  FROM public.khach_thue kt
                  WHERE kt.id = hd.khach_thue_id
                    AND kt.nguoi_dung_id = auth.uid()
              )
          )
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.hop_dong hd
        JOIN public.phong p ON p.id = hd.phong_id
        WHERE hd.id = thanh_vien_hop_dong.hop_dong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY phu_luc_hop_dong_by_contract ON public.phu_luc_hop_dong
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.hop_dong hd
        JOIN public.phong p ON p.id = hd.phong_id
        WHERE hd.id = phu_luc_hop_dong.hop_dong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.hop_dong hd
        JOIN public.phong p ON p.id = hd.phong_id
        WHERE hd.id = phu_luc_hop_dong.hop_dong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY dat_coc_by_room ON public.dat_coc_phong
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = dat_coc_phong.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = dat_coc_phong.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY dich_vu_owner ON public.dich_vu
FOR ALL USING (chu_tro_id = auth.uid() OR public.is_admin())
WITH CHECK (chu_tro_id = auth.uid() OR public.is_admin());

CREATE POLICY cau_hinh_gia_by_nha_tro ON public.cau_hinh_gia
FOR ALL USING (public.can_access_nha_tro(nha_tro_id))
WITH CHECK (public.can_access_nha_tro(nha_tro_id));

CREATE POLICY dich_vu_hop_dong_by_contract ON public.dich_vu_hop_dong
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.hop_dong hd
        JOIN public.phong p ON p.id = hd.phong_id
        WHERE hd.id = dich_vu_hop_dong.hop_dong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.hop_dong hd
        JOIN public.phong p ON p.id = hd.phong_id
        WHERE hd.id = dich_vu_hop_dong.hop_dong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY chi_so_by_room ON public.chi_so_dien_nuoc
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = chi_so_dien_nuoc.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = chi_so_dien_nuoc.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY hoa_don_by_room_or_tenant ON public.hoa_don
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = hoa_don.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
    OR EXISTS (
        SELECT 1
        FROM public.khach_thue kt
        WHERE kt.id = hoa_don.khach_thue_id
          AND kt.nguoi_dung_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = hoa_don.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY chi_tiet_hoa_don_by_invoice ON public.chi_tiet_hoa_don
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.hoa_don hd
        WHERE hd.id = chi_tiet_hoa_don.hoa_don_id
          AND (
              EXISTS (
                  SELECT 1
                  FROM public.phong p
                  WHERE p.id = hd.phong_id
                    AND public.can_access_nha_tro(p.nha_tro_id)
              )
              OR EXISTS (
                  SELECT 1
                  FROM public.khach_thue kt
                  WHERE kt.id = hd.khach_thue_id
                    AND kt.nguoi_dung_id = auth.uid()
              )
          )
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.hoa_don hd
        JOIN public.phong p ON p.id = hd.phong_id
        WHERE hd.id = chi_tiet_hoa_don.hoa_don_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY thanh_toan_by_invoice ON public.thanh_toan
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.hoa_don hd
        WHERE hd.id = thanh_toan.hoa_don_id
          AND (
              EXISTS (
                  SELECT 1
                  FROM public.phong p
                  WHERE p.id = hd.phong_id
                    AND public.can_access_nha_tro(p.nha_tro_id)
              )
              OR EXISTS (
                  SELECT 1
                  FROM public.khach_thue kt
                  WHERE kt.id = hd.khach_thue_id
                    AND kt.nguoi_dung_id = auth.uid()
              )
          )
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.hoa_don hd
        JOIN public.phong p ON p.id = hd.phong_id
        WHERE hd.id = thanh_toan.hoa_don_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY lich_su_hoa_don_by_invoice ON public.lich_su_hoa_don
FOR SELECT USING (
    EXISTS (
        SELECT 1
        FROM public.hoa_don hd
        WHERE hd.id = lich_su_hoa_don.hoa_don_id
          AND (
              EXISTS (
                  SELECT 1
                  FROM public.phong p
                  WHERE p.id = hd.phong_id
                    AND public.can_access_nha_tro(p.nha_tro_id)
              )
              OR EXISTS (
                  SELECT 1
                  FROM public.khach_thue kt
                  WHERE kt.id = hd.khach_thue_id
                    AND kt.nguoi_dung_id = auth.uid()
              )
          )
    )
);

CREATE POLICY bank_transaction_by_nha_tro ON public.bank_transaction
FOR ALL USING (nha_tro_id IS NOT NULL AND public.can_access_nha_tro(nha_tro_id))
WITH CHECK (nha_tro_id IS NOT NULL AND public.can_access_nha_tro(nha_tro_id));

CREATE POLICY su_co_by_room_or_reporter ON public.su_co
FOR ALL USING (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = su_co.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
    OR nguoi_bao_id = auth.uid()
    OR EXISTS (
        SELECT 1
        FROM public.khach_thue kt
        WHERE kt.id = su_co.khach_thue_id
          AND kt.nguoi_dung_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = su_co.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
    OR nguoi_bao_id = auth.uid()
);

CREATE POLICY lich_hen_by_room_or_user ON public.lich_hen
FOR ALL USING (
    nguoi_dung_id = auth.uid()
    OR EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = lich_hen.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
)
WITH CHECK (
    nguoi_dung_id = auth.uid()
    OR EXISTS (
        SELECT 1
        FROM public.phong p
        WHERE p.id = lich_hen.phong_id
          AND public.can_access_nha_tro(p.nha_tro_id)
    )
);

CREATE POLICY file_media_uploader_admin ON public.file_media
FOR ALL USING (nguoi_tai_len_id = auth.uid() OR public.is_admin())
WITH CHECK (nguoi_tai_len_id = auth.uid() OR public.is_admin());

CREATE POLICY thong_bao_sender_or_recipient ON public.thong_bao
FOR SELECT USING (
    nguoi_gui_id = auth.uid()
    OR public.is_admin()
    OR EXISTS (
        SELECT 1
        FROM public.thong_bao_nguoi_nhan tbn
        WHERE tbn.thong_bao_id = thong_bao.id
          AND tbn.nguoi_dung_id = auth.uid()
    )
);

CREATE POLICY thong_bao_insert_authenticated ON public.thong_bao
FOR INSERT WITH CHECK (nguoi_gui_id = auth.uid() OR public.is_admin());

CREATE POLICY thong_bao_recipient_read ON public.thong_bao_nguoi_nhan
FOR SELECT USING (nguoi_dung_id = auth.uid() OR public.is_admin());

CREATE POLICY thong_bao_recipient_update_self ON public.thong_bao_nguoi_nhan
FOR UPDATE USING (nguoi_dung_id = auth.uid() OR public.is_admin())
WITH CHECK (nguoi_dung_id = auth.uid() OR public.is_admin());

CREATE POLICY thong_bao_recipient_insert_sender ON public.thong_bao_nguoi_nhan
FOR INSERT WITH CHECK (
    public.is_admin()
    OR EXISTS (
        SELECT 1
        FROM public.thong_bao tb
        WHERE tb.id = thong_bao_nguoi_nhan.thong_bao_id
          AND tb.nguoi_gui_id = auth.uid()
    )
);

CREATE POLICY audit_log_admin_read ON public.audit_log
FOR SELECT USING (public.is_admin());

