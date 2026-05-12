-- ====================================================================================
-- SỬA LỖI: Xóa các cột thừa đã tạo bởi alter_hop_dong.sql
-- Chạy script này trên Supabase SQL Editor
-- ====================================================================================

-- 1. Xóa cột gia_thue thừa (Entity dùng gia_thue_hop_dong gốc)
ALTER TABLE hop_dong DROP COLUMN IF EXISTS gia_thue;

-- 2. Xóa cột nguoi_dai_dien_id thừa (Entity dùng khach_thue_id gốc làm người đại diện)
ALTER TABLE hop_dong DROP COLUMN IF EXISTS nguoi_dai_dien_id;
