-- =============================================================================
-- P8: ghim tin nhắn, chuyển tiếp, lưu trữ và ẩn hội thoại — EasyHouse
-- Ngày: 2026-07-22
--
-- Bốn nhóm thay đổi, xem đặc tả đầy đủ ở planning/CHAT_MODULE_PLAN.md §11.3.
--
-- 1. GHIM TIN NHẮN (khác hẳn ghim hội thoại đã có ở thanh_vien_cuoc_tro_chuyen.ghim)
--    Ghim tin có phạm vi CẢ HỘI THOẠI — mọi thành viên cùng nhìn thấy, giống
--    Messenger/Zalo. Vì vậy nó thuộc về bản thân tin nhắn, không thuộc về từng
--    thành viên.
--
-- 2. CHUYỂN TIẾP
--    Giữ liên kết về tin gốc để truy vết. Cần cho kiểm duyệt (P6): một tin bị báo
--    cáo mà là bản chuyển tiếp thì phải lần được về nguồn.
--
-- 3. LƯU TRỮ (archive)
--    Ẩn khỏi danh sách nhưng giữ nguyên lịch sử, có tin mới thì hiện lại. Là lựa
--    chọn của TỪNG NGƯỜI nên nằm ở bảng thành viên.
--
-- 4. XOÁ HỘI THOẠI (chỉ xoá bản của mình)
--    KHÔNG xoá hàng thật: tin nhắn là dữ liệu chung của nhiều người, một bên bấm
--    xoá mà xoá thật thì bên kia mất lịch sử và đường truy vết của P6 đứt.
--    Thay vào đó ghi lại con trỏ so_thu_tu tại thời điểm xoá; từ đó chỉ trả tin
--    có so_thu_tu > an_den_seq. Mỗi người có "tầm nhìn" riêng trên cùng chuỗi tin.
--
--    Dùng so_thu_tu (BIGSERIAL, đơn điệu) chứ không dùng mốc thời gian: hai tin
--    trong cùng một mili-giây sẽ không phân định được, lại còn dính lệch múi giờ.
--
-- Script idempotent: chạy lại nhiều lần không lỗi.
-- =============================================================================

-- ── 1 + 2. Trên tin nhắn ────────────────────────────────────────────────────

ALTER TABLE tin_nhan
    ADD COLUMN IF NOT EXISTS ghim_luc         timestamptz,
    ADD COLUMN IF NOT EXISTS nguoi_ghim_id    uuid,
    ADD COLUMN IF NOT EXISTS chuyen_tiep_tu_id uuid;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_tin_nhan_nguoi_ghim'
    ) THEN
        ALTER TABLE tin_nhan
            ADD CONSTRAINT fk_tin_nhan_nguoi_ghim
            FOREIGN KEY (nguoi_ghim_id) REFERENCES nguoi_dung (id) ON DELETE SET NULL;
    END IF;

    -- ON DELETE SET NULL: xoá tin gốc thì bản chuyển tiếp vẫn còn, chỉ mất đường
    -- truy vết. Dùng CASCADE ở đây sẽ xoá lây tin của người khác.
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_tin_nhan_chuyen_tiep_tu'
    ) THEN
        ALTER TABLE tin_nhan
            ADD CONSTRAINT fk_tin_nhan_chuyen_tiep_tu
            FOREIGN KEY (chuyen_tiep_tu_id) REFERENCES tin_nhan (id) ON DELETE SET NULL;
    END IF;
END $$;

-- Index từng phần: số tin được ghim rất nhỏ so với tổng số tin, index đầy đủ sẽ
-- phí cả dung lượng lẫn chi phí ghi.
CREATE INDEX IF NOT EXISTS idx_tin_nhan_ghim
    ON tin_nhan (cuoc_tro_chuyen_id, ghim_luc DESC)
    WHERE ghim_luc IS NOT NULL AND xoa_luc IS NULL;

COMMENT ON COLUMN tin_nhan.ghim_luc IS
    'Thời điểm được ghim. NULL = không ghim. Phạm vi cả hội thoại, mọi thành viên đều thấy';
COMMENT ON COLUMN tin_nhan.nguoi_ghim_id IS
    'Ai đã ghim — dùng để hiển thị "X đã ghim một tin nhắn"';
COMMENT ON COLUMN tin_nhan.chuyen_tiep_tu_id IS
    'Tin gốc nếu đây là bản chuyển tiếp. Dùng để truy vết khi kiểm duyệt';

-- ── 3 + 4. Trên thành viên hội thoại ────────────────────────────────────────

ALTER TABLE thanh_vien_cuoc_tro_chuyen
    ADD COLUMN IF NOT EXISTS luu_tru    boolean NOT NULL DEFAULT false,
    ADD COLUMN IF NOT EXISTS an_den_seq bigint  NOT NULL DEFAULT 0;

COMMENT ON COLUMN thanh_vien_cuoc_tro_chuyen.luu_tru IS
    'Lưu trữ: ẩn khỏi danh sách nhưng giữ lịch sử, có tin mới thì hiện lại';
COMMENT ON COLUMN thanh_vien_cuoc_tro_chuyen.an_den_seq IS
    'Xoá bản của mình: chỉ hiển thị tin có so_thu_tu > giá trị này. Không đụng dữ liệu người khác';
