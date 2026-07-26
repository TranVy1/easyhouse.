-- =============================================================================
-- Module Tin nhắn (Chat realtime) — EasyHouse
-- Ngày: 2026-07-22
--
-- Tạo 4 enum type + 3 bảng: cuoc_tro_chuyen, thanh_vien_cuoc_tro_chuyen, tin_nhan.
--
-- Giai đoạn 1 chỉ dùng loại DIRECT và SUPPORT, nhưng schema đã hỗ trợ đầy đủ
-- nhóm (BUILDING / FLOOR / GROUP) để không phải sửa bảng khi mở rộng.
--
-- Script idempotent: chạy lại nhiều lần không lỗi.
-- =============================================================================

-- ----------------------------------------------------------------------------
-- 1. Enum types
--    Quy ước dự án: tên type snake_case, giá trị UPPER_SNAKE khớp hằng Java.
-- ----------------------------------------------------------------------------
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'loai_cuoc_tro_chuyen') THEN
    CREATE TYPE loai_cuoc_tro_chuyen AS ENUM ('DIRECT', 'GROUP', 'BUILDING', 'FLOOR', 'SUPPORT');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'trang_thai_cuoc_tro_chuyen') THEN
    CREATE TYPE trang_thai_cuoc_tro_chuyen AS ENUM ('ACTIVE', 'ARCHIVED', 'LOCKED');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'vai_tro_thanh_vien_chat') THEN
    CREATE TYPE vai_tro_thanh_vien_chat AS ENUM ('OWNER', 'MODERATOR', 'MEMBER');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'loai_tin_nhan') THEN
    CREATE TYPE loai_tin_nhan AS ENUM ('TEXT', 'IMAGE', 'FILE', 'SYSTEM');
  END IF;
END
$$;

-- ----------------------------------------------------------------------------
-- 2. cuoc_tro_chuyen — một cuộc hội thoại (1-1, nhóm, kênh hỗ trợ)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS cuoc_tro_chuyen (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    loai                loai_cuoc_tro_chuyen NOT NULL,

    -- Tên/ảnh chỉ dùng cho nhóm. Với DIRECT, frontend hiển thị tên đối phương.
    ten                 text,
    anh                 text,

    -- Trục phân quyền chính. Null với DIRECT xuyên nhà trọ.
    nha_tro_id          uuid REFERENCES nha_tro (id),
    -- Chỉ dùng cho loại FLOOR.
    tang_id             uuid REFERENCES tang (id),

    nguoi_tao_id        uuid REFERENCES nguoi_dung (id),
    trang_thai          trang_thai_cuoc_tro_chuyen NOT NULL DEFAULT 'ACTIVE',

    -- Khoá chống tạo trùng hội thoại. Xem CuocTroChuyenService.dungKhoaDuyNhat().
    --   DIRECT   : direct_<uuid nhỏ>_<uuid lớn>   (sắp xếp nên ai bấm trước cũng ra 1 kết quả)
    --   SUPPORT  : support_<nhaTroId>_<nguoiDungId>
    --   BUILDING : building_<nhaTroId>
    --   FLOOR    : floor_<tangId>
    --   GROUP    : group_<uuid ngẫu nhiên>
    khoa_duy_nhat       text NOT NULL UNIQUE,

    -- Denormalize để sắp xếp danh sách hội thoại mà không phải join bảng tin nhắn.
    tin_nhan_cuoi_luc   timestamptz,
    xem_truoc           text,

    tao_luc             timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc        timestamptz NOT NULL DEFAULT now(),
    xoa_luc             timestamptz
);

CREATE INDEX IF NOT EXISTS idx_cuoc_tro_chuyen_nha_tro
    ON cuoc_tro_chuyen (nha_tro_id) WHERE xoa_luc IS NULL;
CREATE INDEX IF NOT EXISTS idx_cuoc_tro_chuyen_tin_cuoi
    ON cuoc_tro_chuyen (tin_nhan_cuoi_luc DESC) WHERE xoa_luc IS NULL;

-- ----------------------------------------------------------------------------
-- 3. thanh_vien_cuoc_tro_chuyen — thành viên của hội thoại
--    Người nhận LUÔN là nguoi_dung (giống thong_bao_nguoi_nhan), không phải
--    khach_thue, vì chủ trọ và nhân viên cũng tham gia chat.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS thanh_vien_cuoc_tro_chuyen (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    cuoc_tro_chuyen_id  uuid NOT NULL REFERENCES cuoc_tro_chuyen (id) ON DELETE CASCADE,
    nguoi_dung_id       uuid NOT NULL REFERENCES nguoi_dung (id),

    vai_tro             vai_tro_thanh_vien_chat NOT NULL DEFAULT 'MEMBER',
    tham_gia_luc        timestamptz NOT NULL DEFAULT now(),
    -- Null = đang hoạt động. Khách thuê hết hợp đồng thì set roi_luc, KHÔNG xoá
    -- row, để tin nhắn cũ vẫn còn ngữ cảnh người gửi.
    roi_luc             timestamptz,

    -- Cơ sở tính số tin chưa đọc và trạng thái "đã xem" mà không cần bảng riêng.
    doc_den_seq         bigint NOT NULL DEFAULT 0,
    doc_den_luc         timestamptz,

    tat_thong_bao       boolean NOT NULL DEFAULT false,
    ghim                boolean NOT NULL DEFAULT false,

    CONSTRAINT uq_thanh_vien_cuoc_tro_chuyen UNIQUE (cuoc_tro_chuyen_id, nguoi_dung_id)
);

-- Truy vấn nóng nhất: "danh sách hội thoại của tôi".
CREATE INDEX IF NOT EXISTS idx_thanh_vien_nguoi_dung
    ON thanh_vien_cuoc_tro_chuyen (nguoi_dung_id, roi_luc);

-- ----------------------------------------------------------------------------
-- 4. tin_nhan
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tin_nhan (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Số thứ tự toàn cục, đơn điệu tăng. Dùng làm cursor phân trang, làm mốc
    -- delta khi nối lại WebSocket, và để client phát hiện đã lỡ mất tin.
    -- KHÔNG dùng timestamp cho việc này: hai tin gửi cùng mili giây sẽ sai thứ tự.
    so_thu_tu           bigserial NOT NULL UNIQUE,

    cuoc_tro_chuyen_id  uuid NOT NULL REFERENCES cuoc_tro_chuyen (id) ON DELETE CASCADE,
    -- Null = tin hệ thống ("A đã tham gia nhóm").
    nguoi_gui_id        uuid REFERENCES nguoi_dung (id),

    loai                loai_tin_nhan NOT NULL DEFAULT 'TEXT',
    noi_dung            text,
    file_media_id       uuid REFERENCES file_media (id),
    tra_loi_cho_id      uuid REFERENCES tin_nhan (id),

    -- Khoá chống gửi trùng do client sinh. Khi mạng chập chờn, client retry cùng
    -- ma_client thì server trả lại đúng tin cũ thay vì tạo tin thứ hai.
    ma_client           text,

    da_thu_hoi          boolean NOT NULL DEFAULT false,

    tao_luc             timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc        timestamptz NOT NULL DEFAULT now(),
    xoa_luc             timestamptz
);

-- Phân trang lịch sử + delta poll đều đi qua index này.
CREATE INDEX IF NOT EXISTS idx_tin_nhan_hoi_thoai_seq
    ON tin_nhan (cuoc_tro_chuyen_id, so_thu_tu DESC);

-- Idempotency: cùng một ma_client trong cùng hội thoại chỉ tồn tại một tin.
CREATE UNIQUE INDEX IF NOT EXISTS uq_tin_nhan_ma_client
    ON tin_nhan (cuoc_tro_chuyen_id, ma_client) WHERE ma_client IS NOT NULL;
