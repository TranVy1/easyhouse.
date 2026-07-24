
CREATE TABLE public.phuong_tien (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ma_pt VARCHAR(50) UNIQUE NOT NULL,
    loai_xe VARCHAR(255) NOT NULL,
    bien_so VARCHAR(50) NOT NULL,
    khach_thue_id UUID REFERENCES public.khach_thue(id) ON DELETE SET NULL,
    phong_id UUID REFERENCES public.phong(id) ON DELETE SET NULL,
    nha_tro_id UUID REFERENCES public.nha_tro(id) ON DELETE CASCADE,
    chu_tro_id UUID REFERENCES public.nguoi_dung(id) ON DELETE CASCADE,
    trang_thai trang_thai_phuong_tien DEFAULT 'HIEU_LUC',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
