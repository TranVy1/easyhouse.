ALTER TABLE public.phuong_tien ADD COLUMN IF NOT EXISTS anh_xe VARCHAR(255);
ALTER TABLE public.phuong_tien ADD COLUMN IF NOT EXISTS loai_phuong_tien VARCHAR(50);
ALTER TABLE public.phuong_tien ADD COLUMN IF NOT EXISTS ten_dong_xe VARCHAR(100);
ALTER TABLE public.phuong_tien ADD COLUMN IF NOT EXISTS mau_xe VARCHAR(50);
ALTER TABLE public.phuong_tien ADD COLUMN IF NOT EXISTS ten_chu_xe VARCHAR(100);
ALTER TABLE public.phuong_tien ADD COLUMN IF NOT EXISTS so_ve_xe VARCHAR(50);