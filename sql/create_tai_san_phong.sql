CREATE TABLE IF NOT EXISTS tai_san_phong (
    id UUID PRIMARY KEY,
    phong_id UUID NOT NULL REFERENCES phong(id),
    ten_tai_san VARCHAR(255) NOT NULL,
    so_luong INT NOT NULL,
    gia_tri NUMERIC(19, 2) NOT NULL,
    tinh_trang VARCHAR(255) NOT NULL,
    ghi_chu TEXT,
    tao_luc TIMESTAMP WITH TIME ZONE,
    cap_nhat_luc TIMESTAMP WITH TIME ZONE
);
