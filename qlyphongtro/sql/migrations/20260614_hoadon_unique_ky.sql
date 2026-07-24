-- ===================================================================
-- Migration: Chống Duplicate Hóa Đơn (FIX #1)
-- Ngày: 2026-06-14
-- Mục đích: Đảm bảo mỗi hợp đồng chỉ có đúng 1 hóa đơn cho mỗi kỳ tháng/năm
--           Backstop tầng DB sau application-level check (ensureInvoicePeriodAvailable)
-- ===================================================================

-- BƯỚC 1: Kiểm tra dữ liệu duplicate hiện có (chạy để xem trước)
-- SELECT hop_dong_id, ky_thang, ky_nam, COUNT(*) as so_ban
-- FROM hoa_don
-- WHERE xoa_luc IS NULL
-- GROUP BY hop_dong_id, ky_thang, ky_nam
-- HAVING COUNT(*) > 1;

-- BƯỚC 2: Xóa bản ghi duplicate - GIỮ bản ghi CŨ NHẤT (tao_luc nhỏ nhất)
-- Chỉ xóa các hóa đơn chưa được soft-delete (xoa_luc IS NULL)
-- và chưa có thanh toán (daTra = 0)
DELETE FROM hoa_don h1
USING hoa_don h2
WHERE h1.hop_dong_id = h2.hop_dong_id
  AND h1.ky_thang    = h2.ky_thang
  AND h1.ky_nam      = h2.ky_nam
  AND h1.xoa_luc     IS NULL
  AND h2.xoa_luc     IS NULL
  AND h1.tao_luc     > h2.tao_luc   -- Xóa bản mới hơn
  AND h1.da_tra      = 0;            -- Chỉ xóa nếu chưa có giao dịch tiền

-- BƯỚC 3: Với các duplicate còn lại (đã có tiền), soft-delete bản trùng
-- để không mất dữ liệu tài chính
UPDATE hoa_don h1
SET xoa_luc = NOW()
FROM hoa_don h2
WHERE h1.hop_dong_id = h2.hop_dong_id
  AND h1.ky_thang    = h2.ky_thang
  AND h1.ky_nam      = h2.ky_nam
  AND h1.xoa_luc     IS NULL
  AND h2.xoa_luc     IS NULL
  AND h1.tao_luc     > h2.tao_luc;  -- Soft-delete bản mới hơn

-- BƯỚC 4: Tạo partial unique index
-- Partial index loại trừ các hóa đơn đã bị xóa mềm (xoa_luc IS NOT NULL)
-- → Cho phép nhiều hóa đơn bị xóa cùng kỳ, nhưng chỉ 1 bản active
CREATE UNIQUE INDEX IF NOT EXISTS uk_hoadon_hopdong_ky
    ON hoa_don (hop_dong_id, ky_thang, ky_nam)
    WHERE xoa_luc IS NULL;

-- BƯỚC 5: Thêm indexes hỗ trợ query thường dùng (tối ưu hiệu năng)
CREATE INDEX IF NOT EXISTS idx_hoa_don_hop_dong_id
    ON hoa_don (hop_dong_id)
    WHERE xoa_luc IS NULL;

CREATE INDEX IF NOT EXISTS idx_hoa_don_trang_thai
    ON hoa_don (trang_thai)
    WHERE xoa_luc IS NULL;

CREATE INDEX IF NOT EXISTS idx_hop_dong_phong_id
    ON hop_dong (phong_id)
    WHERE xoa_luc IS NULL;

CREATE INDEX IF NOT EXISTS idx_thanh_toan_hoa_don_id
    ON thanh_toan (hoa_don_id);

-- BƯỚC 6: Verify kết quả
-- Sau khi chạy migration, các query này phải trả về 0 rows
-- SELECT hop_dong_id, ky_thang, ky_nam, COUNT(*)
-- FROM hoa_don WHERE xoa_luc IS NULL
-- GROUP BY hop_dong_id, ky_thang, ky_nam
-- HAVING COUNT(*) > 1;

-- Kiểm tra index đã được tạo
-- SELECT indexname, indexdef FROM pg_indexes
-- WHERE tablename = 'hoa_don'
-- AND indexname LIKE 'uk_%' OR indexname LIKE 'idx_%';
