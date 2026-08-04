-- =============================================================================
-- Kenh SUPPORT la hop thu dung chung cua Ban quan ly - EasyHouse
-- Ngay: 2026-08-04
--
-- Backfill cac kenh da ton tai de moi ADMIN dang hoat dong, chu tro va nhan vien
-- co quyen nha tro cung nhin thay. Chat DIRECT/GROUP khong bi tac dong.
-- Script idempotent: chay lai se tai kich hoat membership, khong tao row trung.
-- =============================================================================

WITH thanh_vien_can_co AS (
    -- Nguoi mo kenh luon duoc giu lai, ke ca tai khoan hien dang tam khoa.
    SELECT c.id AS cuoc_tro_chuyen_id, c.nguoi_tao_id AS nguoi_dung_id
    FROM cuoc_tro_chuyen c
    WHERE c.loai = 'SUPPORT'
      AND c.xoa_luc IS NULL
      AND c.nguoi_tao_id IS NOT NULL

    UNION

    -- ADMIN he thong la luc luong tiep nhan dung chung tren toan bo he thong.
    SELECT c.id, nd.id
    FROM cuoc_tro_chuyen c
    JOIN nguoi_dung nd
      ON nd.trang_thai = 'ACTIVE'
     AND nd.xoa_luc IS NULL
    JOIN nguoi_dung_vai_tro ndvt ON ndvt.nguoi_dung_id = nd.id
    JOIN vai_tro vt ON vt.id = ndvt.vai_tro_id AND vt.ten = 'ADMIN'
    WHERE c.loai = 'SUPPORT'
      AND c.xoa_luc IS NULL

    UNION

    -- Chu tro cua dung nha tro.
    SELECT c.id, nt.chu_tro_id
    FROM cuoc_tro_chuyen c
    JOIN nha_tro nt ON nt.id = c.nha_tro_id AND nt.xoa_luc IS NULL
    JOIN nguoi_dung nd ON nd.id = nt.chu_tro_id
    WHERE c.loai = 'SUPPORT'
      AND c.xoa_luc IS NULL
      AND nd.trang_thai = 'ACTIVE'
      AND nd.xoa_luc IS NULL

    UNION

    -- Nhan vien duoc phan quyen xem hoac sua nha tro.
    SELECT c.id, ndnt.nguoi_dung_id
    FROM cuoc_tro_chuyen c
    JOIN nguoi_dung_nha_tro ndnt ON ndnt.nha_tro_id = c.nha_tro_id
    JOIN nguoi_dung nd ON nd.id = ndnt.nguoi_dung_id
    WHERE c.loai = 'SUPPORT'
      AND c.xoa_luc IS NULL
      AND (ndnt.co_quyen_xem = true OR ndnt.co_quyen_sua = true)
      AND nd.trang_thai = 'ACTIVE'
      AND nd.xoa_luc IS NULL
)
INSERT INTO thanh_vien_cuoc_tro_chuyen (
    id,
    cuoc_tro_chuyen_id,
    nguoi_dung_id,
    vai_tro,
    tham_gia_luc,
    doc_den_seq,
    tat_thong_bao,
    ghim,
    luu_tru,
    an_den_seq
)
SELECT
    gen_random_uuid(),
    tv.cuoc_tro_chuyen_id,
    tv.nguoi_dung_id,
    'MEMBER'::vai_tro_thanh_vien_chat,
    now(),
    0,
    false,
    false,
    false,
    0
FROM thanh_vien_can_co tv
ON CONFLICT (cuoc_tro_chuyen_id, nguoi_dung_id) DO UPDATE
SET roi_luc = NULL,
    tham_gia_luc = CASE
        WHEN thanh_vien_cuoc_tro_chuyen.roi_luc IS NOT NULL THEN now()
        ELSE thanh_vien_cuoc_tro_chuyen.tham_gia_luc
    END;
