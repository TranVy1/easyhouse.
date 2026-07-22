-- Cập nhật bảng tai_san_phong
ALTER TABLE public.tai_san_phong
ADD COLUMN anh_tai_san character varying(255),
ADD COLUMN xoa_luc timestamp with time zone;
