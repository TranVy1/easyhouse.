-- Tọa độ được quản trị viên cập nhật từ vị trí thực tế/Google Maps.
-- Dùng cho API tìm phòng gần vị trí người dùng; địa chỉ văn bản hiện có vẫn được giữ nguyên.
ALTER TABLE nha_tro
    ADD COLUMN IF NOT EXISTS vi_do DECIMAL(10,7),
    ADD COLUMN IF NOT EXISTS kinh_do DECIMAL(10,7),
    ADD COLUMN IF NOT EXISTS google_place_id VARCHAR(255),
    ADD COLUMN IF NOT EXISTS dia_chi_da_chuan_hoa TEXT;

ALTER TABLE nha_tro
    ADD CONSTRAINT nha_tro_vi_do_range CHECK (vi_do IS NULL OR vi_do BETWEEN -90 AND 90),
    ADD CONSTRAINT nha_tro_kinh_do_range CHECK (kinh_do IS NULL OR kinh_do BETWEEN -180 AND 180);

CREATE INDEX IF NOT EXISTS idx_nha_tro_location_active
    ON nha_tro (vi_do, kinh_do)
    WHERE xoa_luc IS NULL AND vi_do IS NOT NULL AND kinh_do IS NOT NULL;
