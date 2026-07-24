-- Tạo bảng kho_tai_san
CREATE TABLE public.kho_tai_san (
    id uuid NOT NULL,
    nha_tro_id uuid NOT NULL,
    ten_tai_san character varying(255) NOT NULL,
    hinh_anh character varying(255),
    tong_so_luong integer NOT NULL DEFAULT 0,
    so_luong_kha_dung integer NOT NULL DEFAULT 0,
    so_luong_da_cap_phat integer NOT NULL DEFAULT 0,
    so_luong_hu_hong integer NOT NULL DEFAULT 0,
    tinh_trang character varying(255) NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone,
    cap_nhat_luc timestamp with time zone,
    xoa_luc timestamp with time zone,
    CONSTRAINT kho_tai_san_pkey PRIMARY KEY (id),
    CONSTRAINT fk_kho_tai_san_nha_tro FOREIGN KEY (nha_tro_id)
        REFERENCES public.nha_tro (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

-- Tạo bảng lich_su_kho_tai_san
CREATE TABLE public.lich_su_kho_tai_san (
    id uuid NOT NULL,
    kho_tai_san_id uuid NOT NULL,
    phong_id uuid,
    loai_giao_dich character varying(255) NOT NULL,
    so_luong integer NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone,
    CONSTRAINT lich_su_kho_tai_san_pkey PRIMARY KEY (id),
    CONSTRAINT fk_lich_su_kho_tai_san_kho FOREIGN KEY (kho_tai_san_id)
        REFERENCES public.kho_tai_san (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_lich_su_kho_tai_san_phong FOREIGN KEY (phong_id)
        REFERENCES public.phong (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
