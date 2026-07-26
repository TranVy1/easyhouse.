-- =============================================================================
-- Bảng thông tin hội thoại (P7) — EasyHouse
-- Ngày: 2026-07-22
-- Đặc tả: planning/CHAT_MODULE_PLAN.md §11.2
--
-- Script idempotent: chạy lại nhiều lần không lỗi.
-- =============================================================================

-- ----------------------------------------------------------------------------
-- 1. Biệt danh
--
-- Đặt trên bản ghi THÀNH VIÊN chứ không phải trên nguoi_dung: biệt danh chỉ có
-- nghĩa trong phạm vi một hội thoại. Ai trong hội thoại cũng sửa được và mọi
-- người cùng thấy (giống Messenger) — nhờ vậy tránh được bảng ánh xạ
-- (người xem × người được đặt tên) vốn phình theo tích hai chiều.
-- ----------------------------------------------------------------------------
ALTER TABLE thanh_vien_cuoc_tro_chuyen
    ADD COLUMN IF NOT EXISTS biet_danh text;

-- ----------------------------------------------------------------------------
-- 2. Chỉ mục cho tab Ảnh / Tệp
--
-- Không có index này thì mỗi lần mở tab đính kèm sẽ quét toàn bộ tin nhắn của
-- hội thoại — hội thoại càng dài càng chậm, dù số tệp rất ít.
-- Index TỪNG PHẦN vì tin có đính kèm chiếm tỉ lệ nhỏ.
-- ----------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_tin_nhan_dinh_kem
    ON tin_nhan (cuoc_tro_chuyen_id, so_thu_tu DESC)
    WHERE file_media_id IS NOT NULL AND xoa_luc IS NULL AND da_thu_hoi = false;

-- ----------------------------------------------------------------------------
-- 3. Chỉ mục cho tab Liên kết
--
-- SQL chỉ lọc thô những tin CÓ CHỨA http(s), việc trích từng URL để ở tầng Java:
-- một tin có thể chứa nhiều URL, và regex trích xuất viết trong SQL vừa khó đọc
-- vừa không test được.
-- ----------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_tin_nhan_co_lien_ket
    ON tin_nhan (cuoc_tro_chuyen_id, so_thu_tu DESC)
    WHERE noi_dung IS NOT NULL AND xoa_luc IS NULL AND da_thu_hoi = false;
