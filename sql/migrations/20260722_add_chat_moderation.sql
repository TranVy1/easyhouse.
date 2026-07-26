-- =============================================================================
-- Kiểm duyệt tin nhắn (P6) — EasyHouse
-- Ngày: 2026-07-22
--
-- Chat giữa khách thuê là nội dung do người dùng tạo ra, nên cần đường để báo cáo
-- và xử lý. Không có nó thì chủ trọ không có cách nào can thiệp khi có quấy rối.
--
-- Script idempotent: chạy lại nhiều lần không lỗi.
-- =============================================================================

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'trang_thai_bao_cao') THEN
    CREATE TYPE trang_thai_bao_cao AS ENUM ('PENDING', 'REVIEWED', 'DISMISSED', 'ACTIONED');
  END IF;
END
$$;

-- ----------------------------------------------------------------------------
-- Báo cáo tin nhắn
--
-- Trỏ tới TIN NHẮN chứ không sao chép nội dung: sao chép thì khi người gửi thu
-- hồi, bản sao vẫn nằm lại — vừa sai với ý định thu hồi, vừa tạo thêm một nơi
-- lưu dữ liệu nhạy cảm cần bảo vệ.
-- Đổi lại, người kiểm duyệt phải xem tin ở nguyên ngữ cảnh, mà như vậy cũng đúng hơn.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS bao_cao_tin_nhan (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tin_nhan_id         uuid NOT NULL REFERENCES tin_nhan (id) ON DELETE CASCADE,
    cuoc_tro_chuyen_id  uuid NOT NULL REFERENCES cuoc_tro_chuyen (id) ON DELETE CASCADE,
    nguoi_bao_cao_id    uuid NOT NULL REFERENCES nguoi_dung (id),

    ly_do               text NOT NULL,
    trang_thai          trang_thai_bao_cao NOT NULL DEFAULT 'PENDING',

    nguoi_xu_ly_id      uuid REFERENCES nguoi_dung (id),
    ghi_chu_xu_ly       text,
    xu_ly_luc           timestamptz,

    tao_luc             timestamptz NOT NULL DEFAULT now(),

    -- Một người chỉ báo cáo một tin một lần. Không có ràng buộc này thì bấm nhầm
    -- nhiều lần sẽ tạo ra hàng loạt báo cáo trùng cho người kiểm duyệt.
    CONSTRAINT uq_bao_cao_tin_nhan UNIQUE (tin_nhan_id, nguoi_bao_cao_id)
);

CREATE INDEX IF NOT EXISTS idx_bao_cao_cho_xu_ly
    ON bao_cao_tin_nhan (tao_luc DESC) WHERE trang_thai = 'PENDING';

-- ----------------------------------------------------------------------------
-- Chặn người dùng
--
-- Quan hệ MỘT CHIỀU: A chặn B thì B không nhắn được cho A, nhưng A vẫn nhắn được
-- cho B nếu muốn. Đây là cách Messenger/Zalo làm và đúng với ý nghĩa "tôi không
-- muốn nhận tin từ người này".
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS chan_nguoi_dung (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nguoi_chan_id       uuid NOT NULL REFERENCES nguoi_dung (id) ON DELETE CASCADE,
    nguoi_bi_chan_id    uuid NOT NULL REFERENCES nguoi_dung (id) ON DELETE CASCADE,
    tao_luc             timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT uq_chan_nguoi_dung UNIQUE (nguoi_chan_id, nguoi_bi_chan_id),
    CONSTRAINT chk_khong_tu_chan CHECK (nguoi_chan_id <> nguoi_bi_chan_id)
);

CREATE INDEX IF NOT EXISTS idx_chan_theo_nguoi_bi_chan
    ON chan_nguoi_dung (nguoi_bi_chan_id);
