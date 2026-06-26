CREATE OR REPLACE FUNCTION public.tao_lich_thanh_toan_hang_thang(p_hop_dong_id uuid)
 RETURNS integer
 LANGUAGE plpgsql
AS $$
DECLARE
    v_hd public.hop_dong%ROWTYPE;
    v_ngay date;
    v_tu_ngay date;
    v_den_ngay date;
    v_han_thanh_toan date;
    v_count integer := 0;
BEGIN
    SELECT *
    INTO v_hd
    FROM public.hop_dong
    WHERE id = p_hop_dong_id
      AND xoa_luc IS NULL;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Khong tim thay hop dong %', p_hop_dong_id;
    END IF;

    v_ngay := date_trunc('month', v_hd.ngay_bat_dau)::date;

    WHILE v_ngay <= v_hd.ngay_ket_thuc LOOP
        v_tu_ngay := greatest(v_hd.ngay_bat_dau, v_ngay);
        v_den_ngay := least(v_hd.ngay_ket_thuc, (v_ngay + INTERVAL '1 month - 1 day')::date);
        v_han_thanh_toan := make_date(
            extract(year from v_ngay)::integer,
            extract(month from v_ngay)::integer,
            least(
                v_hd.ngay_thanh_toan_hang_thang,
                extract(day from ((v_ngay + INTERVAL '1 month - 1 day')::date))::integer
            )
        );
        
        -- Fix: Nếu hạn thanh toán trong tháng đầu bị rơi vào trước ngày bắt đầu, dời sang từ_ngày
        IF v_han_thanh_toan < v_tu_ngay THEN
            v_han_thanh_toan := v_tu_ngay;
        END IF;

        INSERT INTO public.lich_thanh_toan (
            hop_dong_id,
            ky_nam,
            ky_thang,
            tu_ngay,
            den_ngay,
            han_thanh_toan,
            so_tien_du_kien
        )
        VALUES (
            v_hd.id,
            extract(year from v_ngay)::integer,
            extract(month from v_ngay)::integer,
            v_tu_ngay,
            v_den_ngay,
            v_han_thanh_toan,
            v_hd.gia_thue_hop_dong
        )
        ON CONFLICT (hop_dong_id, ky_nam, ky_thang) DO UPDATE
        SET
            tu_ngay = EXCLUDED.tu_ngay,
            den_ngay = EXCLUDED.den_ngay,
            han_thanh_toan = EXCLUDED.han_thanh_toan,
            so_tien_du_kien = EXCLUDED.so_tien_du_kien,
            cap_nhat_luc = now();

        v_count := v_count + 1;
        v_ngay := (v_ngay + INTERVAL '1 month')::date;
    END LOOP;

    RETURN v_count;
END;
$$;
