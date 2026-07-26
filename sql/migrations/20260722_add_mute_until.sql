-- =============================================================================
-- Tắt thông báo có thời hạn — EasyHouse
-- Ngày: 2026-07-22
--
-- Messenger cho tắt 15 phút / 1 giờ / 8 giờ / 24 giờ / đến khi bật lại. Chỉ có
-- cờ bật-tắt thì người dùng phải tự nhớ bật lại, và thường là quên luôn.
--
-- Giữ NGUYÊN cột tat_thong_bao (= tắt vô thời hạn) và thêm cột hạn, thay vì dùng
-- một cột với giá trị "xa tít" làm mốc vô hạn: mốc giả kiểu đó luôn gây nhầm khi
-- đọc dữ liệu và khi so sánh.
--
-- Script idempotent: chạy lại nhiều lần không lỗi.
-- =============================================================================

ALTER TABLE thanh_vien_cuoc_tro_chuyen
    ADD COLUMN IF NOT EXISTS tat_thong_bao_den timestamptz;

COMMENT ON COLUMN thanh_vien_cuoc_tro_chuyen.tat_thong_bao IS
    'Tắt thông báo vô thời hạn (đến khi người dùng tự bật lại)';
COMMENT ON COLUMN thanh_vien_cuoc_tro_chuyen.tat_thong_bao_den IS
    'Tắt thông báo tới thời điểm này. Đang tắt = tat_thong_bao OR tat_thong_bao_den > now()';
