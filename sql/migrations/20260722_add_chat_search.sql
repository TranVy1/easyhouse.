-- =============================================================================
-- Tìm kiếm nội dung tin nhắn (P4) — EasyHouse
-- Ngày: 2026-07-22
--
-- Mục tiêu: gõ không dấu vẫn tìm ra tin có dấu ("muon do" -> "Mượn đồ"), giống
-- hệt cách ô lọc danh sách hội thoại đang hoạt động, để trải nghiệm nhất quán.
--
-- Script idempotent: chạy lại nhiều lần không lỗi.
-- =============================================================================

-- ----------------------------------------------------------------------------
-- 1. Extension
--    pg_trgm : đánh chỉ mục cho LIKE '%...%'
--    unaccent: bỏ dấu tiếng Việt (đã kiểm chứng: 'Đặng Thị Hà' -> 'Dang Thi Ha')
-- ----------------------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS unaccent;

-- ----------------------------------------------------------------------------
-- 2. Hàm bỏ dấu IMMUTABLE
--
-- unaccent() một tham số là STABLE chứ không IMMUTABLE (nó phụ thuộc search_path
-- để tìm từ điển), nên KHÔNG dùng trực tiếp trong index được.
-- Dạng hai tham số unaccent('unaccent', $1) ghim thẳng từ điển nên an toàn để
-- bọc thành IMMUTABLE.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION f_khong_dau(text)
RETURNS text
LANGUAGE sql
IMMUTABLE
PARALLEL SAFE
STRICT
AS $$
    SELECT lower(public.unaccent('public.unaccent'::regdictionary, $1))
$$;

-- ----------------------------------------------------------------------------
-- 3. Chỉ mục trigram trên nội dung đã bỏ dấu
--
-- Chọn trigram chứ không phải full-text search (tsvector) vì bộ tách từ của
-- PostgreSQL không hiểu tiếng Việt; trigram khớp theo chuỗi con nên không phụ
-- thuộc ngôn ngữ và tìm được cả một phần từ.
--
-- Index từng phần (WHERE ...) để không phí dung lượng cho tin đã xoá/thu hồi —
-- truy vấn tìm kiếm luôn kèm đúng hai điều kiện này nên vẫn dùng được index.
-- ----------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_tin_nhan_noi_dung_trgm
    ON tin_nhan USING gin (f_khong_dau(noi_dung) gin_trgm_ops)
    WHERE xoa_luc IS NULL AND da_thu_hoi = false AND noi_dung IS NOT NULL;
