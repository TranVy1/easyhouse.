-- =============================================================================
-- Thông báo đẩy (P5) — EasyHouse
-- Ngày: 2026-07-22
--
-- Một bảng dùng chung cho CẢ Web Push lẫn FCM (mobile), thay vì mỗi nền tảng một
-- bảng: luật quyết định "có gửi push không" là như nhau, chỉ khác cách chuyển đi.
-- Tách bảng thì logic đó phải viết hai lần và sớm muộn cũng lệch nhau.
--
-- Script idempotent: chạy lại nhiều lần không lỗi.
-- =============================================================================

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'nen_tang_push') THEN
    CREATE TYPE nen_tang_push AS ENUM ('WEB', 'ANDROID', 'IOS');
  END IF;
END
$$;

CREATE TABLE IF NOT EXISTS dang_ky_push (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nguoi_dung_id   uuid NOT NULL REFERENCES nguoi_dung (id) ON DELETE CASCADE,
    nen_tang        nen_tang_push NOT NULL,

    -- Web Push: endpoint URL do trình duyệt cấp.
    -- FCM: registration token.
    -- Dùng chung một cột vì cả hai đều là "địa chỉ để gửi tới", chỉ khác định dạng.
    endpoint        text NOT NULL,

    -- Chỉ Web Push dùng: khoá mã hoá payload theo chuẩn RFC 8291.
    khoa_p256dh     text,
    khoa_auth       text,

    -- Để đối chiếu khi người dùng hỏi "sao máy này không nhận được thông báo".
    mo_ta_thiet_bi  text,

    tao_luc         timestamptz NOT NULL DEFAULT now(),
    dung_luc        timestamptz,

    -- Endpoint là định danh duy nhất của một thiết bị/trình duyệt. Cùng người
    -- đăng ký lại trên cùng máy thì phải cập nhật, không tạo bản ghi thứ hai.
    CONSTRAINT uq_dang_ky_push_endpoint UNIQUE (endpoint)
);

CREATE INDEX IF NOT EXISTS idx_dang_ky_push_nguoi_dung
    ON dang_ky_push (nguoi_dung_id) WHERE dung_luc IS NULL;
