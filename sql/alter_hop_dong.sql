-- ====================================================================================
-- ALTER hop_dong: Bổ sung các cột cần thiết cho CRUD hợp đồng
-- Chạy script này trên database PostgreSQL (Supabase)
-- ====================================================================================

-- Thêm cột ma_hop_dong (mã hợp đồng)
ALTER TABLE hop_dong ADD COLUMN IF NOT EXISTS ma_hop_dong VARCHAR(100) UNIQUE;

-- Thêm cột nguoi_dai_dien_id (người đại diện khách thuê - thay vì chỉ có 1 khach_thue_id)
ALTER TABLE hop_dong ADD COLUMN IF NOT EXISTS nguoi_dai_dien_id UUID REFERENCES khach_thue(id) ON DELETE RESTRICT;

-- Thêm cột khach_thue_ids (danh sách tất cả khách thuê - lưu dạng JSON)
ALTER TABLE hop_dong ADD COLUMN IF NOT EXISTS khach_thue_ids JSONB;

-- Thêm cột chu_ky_thanh_toan
ALTER TABLE hop_dong ADD COLUMN IF NOT EXISTS chu_ky_thanh_toan VARCHAR(50);

-- Thêm cột ngay_thanh_toan (ngày trong tháng cần thanh toán)
ALTER TABLE hop_dong ADD COLUMN IF NOT EXISTS ngay_thanh_toan INT;

-- Thêm cột dieu_khoan (điều khoản hợp đồng)
ALTER TABLE hop_dong ADD COLUMN IF NOT EXISTS dieu_khoan TEXT;

-- Thêm cột gia_dien, gia_nuoc
ALTER TABLE hop_dong ADD COLUMN IF NOT EXISTS gia_dien DECIMAL(10, 2);
ALTER TABLE hop_dong ADD COLUMN IF NOT EXISTS gia_nuoc DECIMAL(10, 2);

-- Thêm cột chi_so_dien_ban_dau, chi_so_nuoc_ban_dau
ALTER TABLE hop_dong ADD COLUMN IF NOT EXISTS chi_so_dien_ban_dau INT;
ALTER TABLE hop_dong ADD COLUMN IF NOT EXISTS chi_so_nuoc_ban_dau INT;

-- Thêm cột phi_dich_vu (JSON array)
ALTER TABLE hop_dong ADD COLUMN IF NOT EXISTS phi_dich_vu JSONB;

-- Thêm cột file_hop_dong
ALTER TABLE hop_dong ADD COLUMN IF NOT EXISTS file_hop_dong TEXT;

-- Rename gia_thue_hop_dong thành gia_thue nếu chưa tồn tại
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'hop_dong' AND column_name = 'gia_thue_hop_dong')
     AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'hop_dong' AND column_name = 'gia_thue')
  THEN
    ALTER TABLE hop_dong RENAME COLUMN gia_thue_hop_dong TO gia_thue;
  ELSIF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'hop_dong' AND column_name = 'gia_thue')
  THEN
    ALTER TABLE hop_dong ADD COLUMN gia_thue DECIMAL(15, 2) NOT NULL DEFAULT 0;
  END IF;
END $$;

-- Cập nhật enum trang_thai_hop_dong nếu cần (thêm 'ACTIVE' nếu chưa có)
-- PostgreSQL enum không hỗ trợ ALTER TYPE ... ADD VALUE IF NOT EXISTS trực tiếp
-- Nếu bảng mới, có thể bỏ qua bước này

-- Đảm bảo cột trang_thai cho phép giá trị mới (ACTIVE thay vì PENDING là mặc định)
-- ALTER TABLE hop_dong ALTER COLUMN trang_thai SET DEFAULT 'ACTIVE';
