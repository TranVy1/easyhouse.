-- Dùng Unicode escape để tên phòng được sinh ra luôn là "Phòng", độc lập mã hóa file SQL.
CREATE OR REPLACE FUNCTION public.sinh_phong_toa_nha(
    p_nha_tro_id uuid,
    p_so_tang integer,
    p_so_phong_moi_tang integer,
    p_dien_tich numeric DEFAULT 20,
    p_gia_hien_tai numeric DEFAULT 0,
    p_tien_coc_mac_dinh numeric DEFAULT 0,
    p_so_nguoi_toi_da integer DEFAULT 2
)
RETURNS TABLE(tang_duoc_tao integer, phong_duoc_tao integer)
LANGUAGE plpgsql
AS $$
DECLARE
    v_tang integer;
    v_phong integer;
    v_tang_id uuid;
    v_ma_phong text;
    v_tang_count integer := 0;
    v_phong_count integer := 0;
BEGIN
    IF p_so_tang <= 0 OR p_so_phong_moi_tang <= 0 THEN
        RAISE EXCEPTION 'p_so_tang va p_so_phong_moi_tang phai lon hon 0';
    END IF;
    IF p_dien_tich <= 0 OR p_gia_hien_tai < 0 OR p_tien_coc_mac_dinh < 0 OR p_so_nguoi_toi_da <= 0 THEN
        RAISE EXCEPTION 'Thong so phong khong hop le';
    END IF;

    FOR v_tang IN 1..p_so_tang LOOP
        INSERT INTO public.tang (nha_tro_id, so_tang, ten_tang, thu_tu_hien_thi, so_phong_du_kien)
        VALUES (p_nha_tro_id, v_tang, 'Tang ' || v_tang::text, v_tang, p_so_phong_moi_tang)
        ON CONFLICT (nha_tro_id, so_tang) DO UPDATE
        SET so_phong_du_kien = EXCLUDED.so_phong_du_kien,
            cap_nhat_luc = now()
        RETURNING id INTO v_tang_id;

        v_tang_count := v_tang_count + 1;
        FOR v_phong IN 1..p_so_phong_moi_tang LOOP
            v_ma_phong := U&'Ph\00F2ng ' || (v_tang * 100 + v_phong)::text;
            INSERT INTO public.phong (
                nha_tro_id, tang_id, ten, tang, dien_tich, so_nguoi_toi_da,
                trang_thai, gia_hien_tai, tien_coc_mac_dinh
            )
            VALUES (
                p_nha_tro_id, v_tang_id, v_ma_phong, v_tang, p_dien_tich,
                p_so_nguoi_toi_da, 'AVAILABLE'::public.trang_thai_phong,
                p_gia_hien_tai, p_tien_coc_mac_dinh
            )
            ON CONFLICT (nha_tro_id, ten) DO NOTHING;
            IF FOUND THEN
                v_phong_count := v_phong_count + 1;
            END IF;
        END LOOP;
    END LOOP;

    RETURN QUERY SELECT v_tang_count, v_phong_count;
END;
$$;

-- Khôi phục các tên sinh bởi phiên bản trước, ví dụ "Ph??ng 101" hoặc "PhÃ²ng 101".
UPDATE public.phong
SET ten = U&'Ph\00F2ng ' || substring(ten from '([0-9]+)$'),
    cap_nhat_luc = now()
WHERE ten LIKE 'Ph??ng %'
   OR ten LIKE U&'Ph\00C3\00B2ng %';
