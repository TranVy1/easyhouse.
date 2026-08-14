--
-- PostgreSQL database dump
--

\restrict O6WaZLv2mrxYc1Q9KPy4H7VPIZL9dMmSim1SDfF2BXcfYGWekHoAaqgZrbLg7YL

-- Dumped from database version 14.23
-- Dumped by pg_dump version 14.23

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: appointment_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.appointment_status AS ENUM (
    'PENDING',
    'CONFIRMED',
    'CANCELLED',
    'COMPLETED'
);


--
-- Name: booking_deposit_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.booking_deposit_status AS ENUM (
    'PENDING',
    'COMPLETED',
    'REFUNDED',
    'FORFEITED'
);


--
-- Name: calc_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.calc_type AS ENUM (
    'PER_METER',
    'PER_PERSON',
    'PER_ROOM'
);


--
-- Name: contract_deposit_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.contract_deposit_status AS ENUM (
    'KEPT',
    'REFUNDED',
    'DEDUCTED'
);


--
-- Name: contract_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.contract_status AS ENUM (
    'PENDING',
    'ACTIVE',
    'EXPIRED',
    'TERMINATED'
);


--
-- Name: invoice_item_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.invoice_item_type AS ENUM (
    'ROOM',
    'ELECTRICITY',
    'WATER',
    'SERVICE',
    'INTERNET',
    'OTHER'
);


--
-- Name: invoice_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.invoice_status AS ENUM (
    'UNPAID',
    'PARTIAL',
    'PAID'
);


--
-- Name: kenh_thong_bao; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.kenh_thong_bao AS ENUM (
    'IN_APP',
    'EMAIL',
    'SMS',
    'ZALO',
    'TELEGRAM',
    'PUSH'
);


--
-- Name: loai_chi_so; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_chi_so AS ENUM (
    'ELECTRICITY',
    'WATER'
);


--
-- Name: loai_cuoc_tro_chuyen; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_cuoc_tro_chuyen AS ENUM (
    'DIRECT',
    'GROUP',
    'BUILDING',
    'FLOOR',
    'SUPPORT'
);


--
-- Name: loai_doi_tuong_media; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_doi_tuong_media AS ENUM (
    'USER',
    'TENANT',
    'ROOM',
    'CONTRACT',
    'INVOICE',
    'PAYMENT',
    'INCIDENT',
    'METER_READING',
    'APPOINTMENT',
    'OTHER'
);


--
-- Name: loai_muc_hoa_don; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_muc_hoa_don AS ENUM (
    'ROOM',
    'ELECTRICITY',
    'WATER',
    'SERVICE',
    'INTERNET',
    'GARBAGE',
    'PARKING',
    'MAINTENANCE',
    'DEBT',
    'DISCOUNT',
    'OTHER',
    'DEPOSIT'
);


--
-- Name: loai_su_co_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_su_co_enum AS ENUM (
    'dien_nuoc',
    'noi_that',
    've_sinh',
    'an_ninh',
    'internet',
    'khac'
);


--
-- Name: loai_thong_bao; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_thong_bao AS ENUM (
    'SYSTEM',
    'INVOICE',
    'PAYMENT',
    'CONTRACT',
    'INCIDENT',
    'APPOINTMENT',
    'DEBT'
);


--
-- Name: loai_tin_nhan; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_tin_nhan AS ENUM (
    'TEXT',
    'IMAGE',
    'FILE',
    'SYSTEM'
);


--
-- Name: loai_tinh_phi; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loai_tinh_phi AS ENUM (
    'FIXED',
    'PER_PERSON',
    'PER_ROOM',
    'PER_UNIT',
    'PERCENT'
);


--
-- Name: maintenance_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.maintenance_status AS ENUM (
    'PENDING',
    'IN_PROGRESS',
    'RESOLVED',
    'REJECTED'
);


--
-- Name: media_entity_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.media_entity_type AS ENUM (
    'USER',
    'MOTEL',
    'ROOM',
    'CONTRACT',
    'INVOICE',
    'OTHER'
);


--
-- Name: nen_tang_push; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.nen_tang_push AS ENUM (
    'WEB',
    'ANDROID',
    'IOS'
);


--
-- Name: phuong_thuc_thanh_toan; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.phuong_thuc_thanh_toan AS ENUM (
    'CASH',
    'BANK_TRANSFER',
    'VIETQR',
    'MOMO',
    'ZALOPAY',
    'OTHER',
    'VNPAY',
    'DEPOSIT'
);


--
-- Name: room_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.room_status AS ENUM (
    'AVAILABLE',
    'RENTED',
    'MAINTENANCE'
);


--
-- Name: trang_thai_bao_cao; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_bao_cao AS ENUM (
    'PENDING',
    'REVIEWED',
    'DISMISSED',
    'ACTIONED'
);


--
-- Name: trang_thai_chi_so; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_chi_so AS ENUM (
    'DRAFT',
    'CONFIRMED',
    'BILLED',
    'CANCELLED'
);


--
-- Name: trang_thai_coc_hop_dong; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_coc_hop_dong AS ENUM (
    'NOT_PAID',
    'KEPT',
    'REFUNDED',
    'DEDUCTED',
    'FORFEITED'
);


--
-- Name: trang_thai_cuoc_tro_chuyen; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_cuoc_tro_chuyen AS ENUM (
    'ACTIVE',
    'ARCHIVED',
    'LOCKED'
);


--
-- Name: trang_thai_dat_coc; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_dat_coc AS ENUM (
    'PENDING',
    'COMPLETED',
    'REFUNDED',
    'FORFEITED',
    'CANCELLED'
);


--
-- Name: trang_thai_hoa_don; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_hoa_don AS ENUM (
    'DRAFT',
    'ISSUED',
    'UNPAID',
    'PARTIAL',
    'PAID',
    'OVERPAID',
    'OVERDUE',
    'CANCELLED'
);


--
-- Name: trang_thai_hop_dong; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_hop_dong AS ENUM (
    'DRAFT',
    'PENDING',
    'ACTIVE',
    'EXPIRED',
    'TERMINATED',
    'CANCELLED'
);


--
-- Name: trang_thai_lich_hen; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_lich_hen AS ENUM (
    'PENDING',
    'CONFIRMED',
    'CANCELLED',
    'COMPLETED',
    'NO_SHOW'
);


--
-- Name: trang_thai_nguoi_dung; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_nguoi_dung AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'BANNED'
);


--
-- Name: trang_thai_phong; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_phong AS ENUM (
    'AVAILABLE',
    'RENTED',
    'MAINTENANCE',
    'RESERVED',
    'INACTIVE'
);


--
-- Name: trang_thai_phuong_tien; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_phuong_tien AS ENUM (
    'HIEU_LUC',
    'HET_HIEU_LUC'
);


--
-- Name: trang_thai_su_co; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_su_co AS ENUM (
    'PENDING',
    'IN_PROGRESS',
    'RESOLVED',
    'CANCELLED'
);


--
-- Name: trang_thai_thanh_toan; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.trang_thai_thanh_toan AS ENUM (
    'PENDING',
    'SUCCESS',
    'FAILED',
    'CANCELLED',
    'REFUNDED'
);


--
-- Name: user_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_status AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'BANNED'
);


--
-- Name: uu_tien_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.uu_tien_enum AS ENUM (
    'thap',
    'trung_binh',
    'cao',
    'khan_cap'
);


--
-- Name: vai_tro_he_thong; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vai_tro_he_thong AS ENUM (
    'ADMIN',
    'LANDLORD',
    'STAFF',
    'TENANT'
);


--
-- Name: vai_tro_thanh_vien_chat; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vai_tro_thanh_vien_chat AS ENUM (
    'OWNER',
    'MODERATOR',
    'MEMBER'
);


--
-- Name: can_access_nha_tro(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.can_access_nha_tro(p_nha_tro_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT public.is_admin()
        OR EXISTS (
            SELECT 1
            FROM public.nha_tro nt
            WHERE nt.id = p_nha_tro_id
              AND nt.chu_tro_id = auth.uid()
        )
        OR EXISTS (
            SELECT 1
            FROM public.nguoi_dung_nha_tro ndnt
            WHERE ndnt.nha_tro_id = p_nha_tro_id
              AND ndnt.nguoi_dung_id = auth.uid()
              AND ndnt.co_quyen_xem = true
        );
$$;


--
-- Name: cap_nhat_thoi_gian(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.cap_nhat_thoi_gian() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.cap_nhat_luc = now();
    RETURN NEW;
END;
$$;


--
-- Name: cap_nhat_trang_thai_hoa_don(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.cap_nhat_trang_thai_hoa_don() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.trang_thai = 'CANCELLED' THEN
        RETURN NEW;
    END IF;

    IF NEW.trang_thai = 'DRAFT' AND NEW.tong_tien = 0 AND NEW.da_tra = 0 THEN
        RETURN NEW;
    END IF;

    IF NEW.da_tra = 0 AND NEW.han_tra < CURRENT_DATE THEN
        NEW.trang_thai = 'OVERDUE';
    ELSIF NEW.da_tra = 0 THEN
        NEW.trang_thai = 'UNPAID';
    ELSIF NEW.da_tra < NEW.tong_tien THEN
        NEW.trang_thai = 'PARTIAL';
    ELSIF NEW.da_tra = NEW.tong_tien THEN
        NEW.trang_thai = 'PAID';
    ELSE
        NEW.trang_thai = 'OVERPAID';
    END IF;

    RETURN NEW;
END;
$$;


--
-- Name: clone_cau_truc_toa_nha(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.clone_cau_truc_toa_nha(p_nha_tro_nguon_id uuid, p_nha_tro_dich_id uuid) RETURNS TABLE(tang_duoc_tao integer, phong_duoc_tao integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_tang record;
    v_phong record;
    v_tang_moi_id uuid;
    v_tang_count integer := 0;
    v_phong_count integer := 0;
BEGIN
    FOR v_tang IN
        SELECT *
        FROM public.tang
        WHERE nha_tro_id = p_nha_tro_nguon_id
          AND xoa_luc IS NULL
        ORDER BY so_tang
    LOOP
        INSERT INTO public.tang (
            nha_tro_id,
            so_tang,
            ten_tang,
            thu_tu_hien_thi,
            so_phong_du_kien,
            trang_thai
        )
        VALUES (
            p_nha_tro_dich_id,
            v_tang.so_tang,
            v_tang.ten_tang,
            v_tang.thu_tu_hien_thi,
            v_tang.so_phong_du_kien,
            v_tang.trang_thai
        )
        ON CONFLICT (nha_tro_id, so_tang) DO UPDATE
        SET
            ten_tang = EXCLUDED.ten_tang,
            thu_tu_hien_thi = EXCLUDED.thu_tu_hien_thi,
            so_phong_du_kien = EXCLUDED.so_phong_du_kien,
            trang_thai = EXCLUDED.trang_thai,
            cap_nhat_luc = now()
        RETURNING id INTO v_tang_moi_id;

        v_tang_count := v_tang_count + 1;

        FOR v_phong IN
            SELECT *
            FROM public.phong
            WHERE nha_tro_id = p_nha_tro_nguon_id
              AND tang_id = v_tang.id
              AND xoa_luc IS NULL
            ORDER BY ten
        LOOP
            INSERT INTO public.phong (
                nha_tro_id,
                tang_id,
                ten,
                khu_vuc,
                tang,
                dien_tich,
                so_nguoi_toi_da,
                trang_thai,
                gia_hien_tai,
                tien_coc_mac_dinh,
                mo_ta
            )
            VALUES (
                p_nha_tro_dich_id,
                v_tang_moi_id,
                v_phong.ten,
                v_phong.khu_vuc,
                v_phong.tang,
                v_phong.dien_tich,
                v_phong.so_nguoi_toi_da,
                'AVAILABLE'::public.trang_thai_phong,
                v_phong.gia_hien_tai,
                v_phong.tien_coc_mac_dinh,
                v_phong.mo_ta
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


--
-- Name: f_khong_dau(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.f_khong_dau(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    AS $_$
    SELECT lower(public.unaccent('public.unaccent'::regdictionary, $1))
$_$;


--
-- Name: is_admin(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_admin() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.nguoi_dung_vai_tro ndvt
        JOIN public.vai_tro vt ON vt.id = ndvt.vai_tro_id
        WHERE ndvt.nguoi_dung_id = auth.uid()
          AND vt.ten = 'ADMIN'
    );
$$;


--
-- Name: recalc_hoa_don_from_chi_tiet(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.recalc_hoa_don_from_chi_tiet() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_hoa_don_id uuid;
BEGIN
    v_hoa_don_id = COALESCE(NEW.hoa_don_id, OLD.hoa_don_id);

    UPDATE public.hoa_don hd
    SET tong_tien_phat_sinh = COALESCE((
            SELECT sum(ct.thanh_tien)
            FROM public.chi_tiet_hoa_don ct
            WHERE ct.hoa_don_id = v_hoa_don_id
        ), 0),
        tong_tien = hd.so_du_dau_ky + COALESCE((
            SELECT sum(ct.thanh_tien)
            FROM public.chi_tiet_hoa_don ct
            WHERE ct.hoa_don_id = v_hoa_don_id
        ), 0),
        cap_nhat_luc = now()
    WHERE hd.id = v_hoa_don_id;

    RETURN COALESCE(NEW, OLD);
END;
$$;


--
-- Name: recalc_hoa_don_from_thanh_toan(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.recalc_hoa_don_from_thanh_toan() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_hoa_don_id uuid;
BEGIN
    v_hoa_don_id = COALESCE(NEW.hoa_don_id, OLD.hoa_don_id);

    UPDATE public.hoa_don hd
    SET da_tra = COALESCE((
            SELECT sum(tt.so_tien)
            FROM public.thanh_toan tt
            WHERE tt.hoa_don_id = v_hoa_don_id
              AND tt.trang_thai = 'SUCCESS'
        ), 0),
        cap_nhat_luc = now()
    WHERE hd.id = v_hoa_don_id;

    RETURN COALESCE(NEW, OLD);
END;
$$;


--
-- Name: sinh_phong_toa_nha(uuid, integer, integer, numeric, numeric, numeric, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.sinh_phong_toa_nha(p_nha_tro_id uuid, p_so_tang integer, p_so_phong_moi_tang integer, p_dien_tich numeric DEFAULT 20, p_gia_hien_tai numeric DEFAULT 0, p_tien_coc_mac_dinh numeric DEFAULT 0, p_so_nguoi_toi_da integer DEFAULT 2) RETURNS TABLE(tang_duoc_tao integer, phong_duoc_tao integer)
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


--
-- Name: tao_lich_thanh_toan_hang_thang(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.tao_lich_thanh_toan_hang_thang(p_hop_dong_id uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_hd public.hop_dong%ROWTYPE;
    v_ngay date;
    v_tu_ngay date;
    v_den_ngay date;
    v_han_thanh_toan date;
    v_so_ngay_o integer;
    v_so_ngay_thang integer;
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
        v_so_ngay_o := (v_den_ngay - v_tu_ngay) + 1;
        v_so_ngay_thang := extract(day FROM (v_ngay + INTERVAL '1 month - 1 day'))::integer;
        v_han_thanh_toan := make_date(
            extract(year FROM (v_ngay + INTERVAL '1 month'))::integer,
            extract(month FROM (v_ngay + INTERVAL '1 month'))::integer,
            least(
                coalesce(v_hd.ngay_thanh_toan_hang_thang, 5),
                extract(day FROM ((v_ngay + INTERVAL '2 month - 1 day')::date))::integer
            )
        );

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
            extract(year FROM v_ngay)::integer,
            extract(month FROM v_ngay)::integer,
            v_tu_ngay,
            v_den_ngay,
            v_han_thanh_toan,
            round(v_hd.gia_thue_hop_dong * v_so_ngay_o / v_so_ngay_thang, 2)
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


--
-- Name: update_invoice_status_on_payment(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_invoice_status_on_payment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    total_paid DECIMAL(15, 2);
    inv_total DECIMAL(15, 2);
    old_status invoice_status;
    new_calculated_status invoice_status;
BEGIN
    -- Only process SUCCESS payments
    IF NEW.status != 'SUCCESS' THEN
        RETURN NEW;
    END IF;

    -- Calculate total paid amount for the invoice
    SELECT COALESCE(SUM(amount), 0) INTO total_paid
    FROM payments
    WHERE invoice_id = NEW.invoice_id AND status = 'SUCCESS';

    -- Get invoice details
    SELECT total_amount, status INTO inv_total, old_status
    FROM invoices
    WHERE id = NEW.invoice_id;

    -- Determine new status
    IF total_paid >= inv_total THEN
        new_calculated_status := 'PAID'::invoice_status;
    ELSIF total_paid > 0 THEN
        new_calculated_status := 'PARTIAL'::invoice_status;
    ELSE
        new_calculated_status := 'UNPAID'::invoice_status;
    END IF;

    -- Update invoice
    UPDATE invoices
    SET paid_amount = total_paid,
        status = new_calculated_status,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = NEW.invoice_id;

    -- Log history if status changed
    IF old_status != new_calculated_status THEN
        INSERT INTO invoice_history (invoice_id, previous_status, new_status, notes)
        VALUES (NEW.invoice_id, old_status, new_calculated_status, 'System auto-update upon payment');
    END IF;

    RETURN NEW;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid,
    hanh_dong character varying(255) NOT NULL,
    bang_tac_dong character varying(255),
    ban_ghi_id uuid,
    du_lieu_cu jsonb,
    du_lieu_moi jsonb,
    ip_address inet,
    user_agent character varying(255),
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: bank_transaction; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bank_transaction (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nha_tro_id uuid,
    hoa_don_id uuid,
    so_tien numeric(38,2) NOT NULL,
    noi_dung_chuyen_khoan character varying(255),
    ma_giao_dich character varying(150),
    ngan_hang character varying(100),
    thoi_gian_giao_dich timestamp with time zone NOT NULL,
    payload jsonb,
    da_doi_soat boolean DEFAULT false NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_bank_transaction_tien CHECK ((so_tien > (0)::numeric))
);


--
-- Name: bao_cao_tin_nhan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bao_cao_tin_nhan (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tin_nhan_id uuid NOT NULL,
    cuoc_tro_chuyen_id uuid NOT NULL,
    nguoi_bao_cao_id uuid NOT NULL,
    ly_do text NOT NULL,
    trang_thai public.trang_thai_bao_cao DEFAULT 'PENDING'::public.trang_thai_bao_cao NOT NULL,
    nguoi_xu_ly_id uuid,
    ghi_chu_xu_ly text,
    xu_ly_luc timestamp with time zone,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: cau_hinh_gia; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cau_hinh_gia (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nha_tro_id uuid NOT NULL,
    dich_vu_id uuid,
    loai character varying(255) NOT NULL,
    ten_hien_thi character varying(255) NOT NULL,
    loai_tinh_phi character varying(255) DEFAULT 'FIXED'::public.loai_tinh_phi NOT NULL,
    don_gia numeric(38,2) NOT NULL,
    hieu_luc_tu date DEFAULT CURRENT_DATE NOT NULL,
    hieu_luc_den date,
    dang_ap_dung boolean DEFAULT true NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_cau_hinh_gia_ngay CHECK (((hieu_luc_den IS NULL) OR (hieu_luc_den >= hieu_luc_tu))),
    CONSTRAINT chk_cau_hinh_gia_tien CHECK ((don_gia >= (0)::numeric))
);


--
-- Name: cau_hinh_phi_xe; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cau_hinh_phi_xe (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nha_tro_id uuid NOT NULL,
    loai_xe character varying(100) NOT NULL,
    don_gia numeric(18,2) NOT NULL,
    hieu_luc_tu date NOT NULL,
    hieu_luc_den date,
    dang_ap_dung boolean DEFAULT true NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT cau_hinh_phi_xe_don_gia_check CHECK ((don_gia >= (0)::numeric)),
    CONSTRAINT cau_hinh_phi_xe_hieu_luc_check CHECK (((hieu_luc_den IS NULL) OR (hieu_luc_den >= hieu_luc_tu)))
);


--
-- Name: chan_nguoi_dung; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chan_nguoi_dung (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_chan_id uuid NOT NULL,
    nguoi_bi_chan_id uuid NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_khong_tu_chan CHECK ((nguoi_chan_id <> nguoi_bi_chan_id))
);


--
-- Name: chi_so_dien_nuoc; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chi_so_dien_nuoc (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phong_id uuid NOT NULL,
    hop_dong_id uuid,
    loai character varying(255) NOT NULL,
    ky_nam integer NOT NULL,
    ky_thang integer NOT NULL,
    ngay_ghi date DEFAULT CURRENT_DATE NOT NULL,
    chi_so_cu integer NOT NULL,
    chi_so_moi integer NOT NULL,
    tieu_thu integer GENERATED ALWAYS AS ((chi_so_moi - chi_so_cu)) STORED,
    anh_dong_ho character varying(255),
    nguoi_ghi_id uuid,
    trang_thai character varying(255) DEFAULT 'DRAFT'::public.trang_thai_chi_so NOT NULL,
    ghi_chu character varying(255),
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_chi_so_gia_tri CHECK (((chi_so_cu >= 0) AND (chi_so_moi >= chi_so_cu))),
    CONSTRAINT chk_chi_so_ky CHECK (((ky_thang >= 1) AND (ky_thang <= 12) AND ((ky_nam >= 2000) AND (ky_nam <= 2100))))
);


--
-- Name: chi_tiet_ban_giao_tai_san; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chi_tiet_ban_giao_tai_san (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quyet_toan_tra_phong_id uuid NOT NULL,
    tai_san_phong_id uuid,
    ten_tai_san character varying(255) NOT NULL,
    so_luong_ban_dau integer NOT NULL,
    tinh_trang_ban_dau character varying(255) NOT NULL,
    anh_tai_san_ban_dau text,
    so_luong_thuc_te integer,
    tinh_trang_thuc_te character varying(255),
    chung_tu_url text,
    ghi_chu text,
    da_xac_nhan boolean DEFAULT false NOT NULL,
    xac_nhan_luc timestamp with time zone,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chi_tiet_ban_giao_tai_san_quantity_check CHECK (((so_luong_ban_dau >= 0) AND ((so_luong_thuc_te IS NULL) OR ((so_luong_thuc_te >= 0) AND (so_luong_thuc_te <= so_luong_ban_dau)))))
);


--
-- Name: chi_tiet_hoa_don; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chi_tiet_hoa_don (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hoa_don_id uuid NOT NULL,
    dich_vu_id uuid,
    chi_so_dien_nuoc_id uuid,
    su_co_id uuid,
    loai public.loai_muc_hoa_don NOT NULL,
    mo_ta character varying(255) NOT NULL,
    so_luong numeric(38,2) DEFAULT 1 NOT NULL,
    don_gia numeric(38,2) DEFAULT 0 NOT NULL,
    thanh_tien numeric(38,2) DEFAULT 0 NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    source_type character varying(64) NOT NULL,
    source_id uuid,
    pricing_rule_version character varying(128) NOT NULL,
    period_start date NOT NULL,
    period_end date NOT NULL,
    calculation_hash character varying(64) NOT NULL,
    CONSTRAINT chk_cthd_tien CHECK (((so_luong >= (0)::numeric) AND (don_gia >= (0)::numeric) AND (((loai = 'DISCOUNT'::public.loai_muc_hoa_don) AND (thanh_tien <= (0)::numeric)) OR ((loai <> 'DISCOUNT'::public.loai_muc_hoa_don) AND (thanh_tien >= (0)::numeric)))))
);


--
-- Name: chu_tro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chu_tro (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid,
    ten_cong_ty character varying(255),
    so_cccd character varying(50) NOT NULL,
    ma_so_thue character varying(50),
    so_tai_khoan character varying(50),
    da_xac_minh boolean DEFAULT false,
    tao_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    xoa_luc timestamp with time zone
);


--
-- Name: contract_signature; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contract_signature (
    id uuid NOT NULL,
    ip_address character varying(255),
    signature_image_url text,
    signed_at timestamp(6) with time zone NOT NULL,
    signer_id uuid,
    signer_role character varying(255) NOT NULL,
    user_agent character varying(255),
    hop_dong_id uuid NOT NULL
);


--
-- Name: cuoc_tro_chuyen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cuoc_tro_chuyen (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    loai public.loai_cuoc_tro_chuyen NOT NULL,
    ten text,
    anh text,
    nha_tro_id uuid,
    tang_id uuid,
    nguoi_tao_id uuid,
    trang_thai public.trang_thai_cuoc_tro_chuyen DEFAULT 'ACTIVE'::public.trang_thai_cuoc_tro_chuyen NOT NULL,
    khoa_duy_nhat text NOT NULL,
    tin_nhan_cuoi_luc timestamp with time zone,
    xem_truoc text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone
);


--
-- Name: dang_ky_push; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dang_ky_push (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid NOT NULL,
    nen_tang public.nen_tang_push NOT NULL,
    endpoint text NOT NULL,
    khoa_p256dh text,
    khoa_auth text,
    mo_ta_thiet_bi text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    dung_luc timestamp with time zone
);


--
-- Name: dat_coc_phong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dat_coc_phong (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phong_id uuid NOT NULL,
    khach_thue_id uuid NOT NULL,
    hop_dong_id uuid,
    so_tien_coc numeric(38,2) NOT NULL,
    ngay_dat_coc timestamp with time zone DEFAULT now() NOT NULL,
    ngay_du_kien_vao date,
    trang_thai character varying(255) DEFAULT 'PENDING'::public.trang_thai_dat_coc NOT NULL,
    ghi_chu character varying(255),
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    cancelled_at timestamp(6) with time zone,
    confirmed_at timestamp(6) with time zone,
    ly_do_huy character varying(255),
    nguoi_xac_nhan_id uuid,
    CONSTRAINT chk_dat_coc_tien CHECK ((so_tien_coc > (0)::numeric))
);


--
-- Name: debt_reminder_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.debt_reminder_log (
    id uuid NOT NULL,
    channel character varying(255) NOT NULL,
    error_message character varying(255),
    recipient_contact character varying(255),
    reminder_type character varying(255) NOT NULL,
    sent_at timestamp(6) with time zone NOT NULL,
    status character varying(255) NOT NULL,
    hoa_don_id uuid NOT NULL,
    recipient_id uuid,
    CONSTRAINT debt_reminder_log_channel_check CHECK (((channel)::text = ANY (ARRAY[('EMAIL'::character varying)::text, ('SYSTEM_NOTIFICATION'::character varying)::text]))),
    CONSTRAINT debt_reminder_log_reminder_type_check CHECK (((reminder_type)::text = ANY (ARRAY['DUE_IN_3_DAYS'::text, 'DUE_TOMORROW'::text, 'DUE_TODAY'::text, 'OVERDUE_1_DAY'::text, 'OVERDUE_3_DAYS'::text, 'OVERDUE_7_DAYS'::text, 'OVERDUE_15_DAYS'::text, 'OVERDUE_30_DAYS'::text, 'MANUAL'::text])))
);


--
-- Name: dich_vu; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dich_vu (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    chu_tro_id uuid,
    ten_dich_vu character varying(255) NOT NULL,
    loai_tinh_phi character varying(255) DEFAULT 'FIXED'::public.loai_tinh_phi NOT NULL,
    don_vi character varying(255),
    don_gia_mac_dinh numeric(38,2) DEFAULT 0 NOT NULL,
    bat_buoc boolean DEFAULT false NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_dich_vu_gia CHECK ((don_gia_mac_dinh >= (0)::numeric))
);


--
-- Name: dich_vu_hop_dong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dich_vu_hop_dong (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hop_dong_id uuid NOT NULL,
    dich_vu_id uuid NOT NULL,
    loai_tinh_phi character varying(255) NOT NULL,
    don_gia_ap_dung numeric(38,2) NOT NULL,
    so_luong numeric(38,2) DEFAULT 1 NOT NULL,
    bat_dau_tu date DEFAULT CURRENT_DATE NOT NULL,
    ket_thuc_luc date,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_dvhd_tien CHECK (((don_gia_ap_dung >= (0)::numeric) AND (so_luong >= (0)::numeric)))
);


--
-- Name: email_verification_token; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_verification_token (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid NOT NULL,
    token character varying(255) NOT NULL,
    ngay_het_han timestamp with time zone NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: file_media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.file_media (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    doi_tuong character varying(255) NOT NULL,
    doi_tuong_id uuid NOT NULL,
    url text NOT NULL,
    public_id character varying(255),
    loai_file character varying(255),
    kich_thuoc_bytes bigint,
    metadata jsonb,
    nguoi_tai_len_id uuid,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_file_size CHECK (((kich_thuoc_bytes IS NULL) OR (kich_thuoc_bytes >= 0)))
);


--
-- Name: giao_dich_tien_coc; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.giao_dich_tien_coc (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hop_dong_id uuid NOT NULL,
    thanh_toan_id uuid,
    quyet_toan_tra_phong_id uuid,
    loai character varying(32) NOT NULL,
    so_tien numeric(18,2) NOT NULL,
    thoi_diem timestamp with time zone DEFAULT now() NOT NULL,
    dien_giai text NOT NULL,
    ma_tham_chieu character varying(150),
    chung_tu_url text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT giao_dich_tien_coc_loai_check CHECK (((loai)::text = ANY ((ARRAY['LEGACY_OPENING'::character varying, 'HELD'::character varying, 'DEDUCTION'::character varying, 'REFUND'::character varying])::text[]))),
    CONSTRAINT giao_dich_tien_coc_so_tien_positive CHECK ((so_tien > (0)::numeric))
);


--
-- Name: hoa_don; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hoa_don (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hop_dong_id uuid NOT NULL,
    phong_id uuid NOT NULL,
    khach_thue_id uuid NOT NULL,
    ma_hoa_don character varying(100) NOT NULL,
    ky_nam integer NOT NULL,
    ky_thang integer NOT NULL,
    tu_ngay date NOT NULL,
    den_ngay date NOT NULL,
    so_du_dau_ky numeric(15,2) DEFAULT 0 NOT NULL,
    tong_tien_phat_sinh numeric(15,2) DEFAULT 0 NOT NULL,
    tong_tien numeric(15,2) DEFAULT 0 NOT NULL,
    da_tra numeric(15,2) DEFAULT 0 NOT NULL,
    so_du_cuoi_ky numeric(15,2) GENERATED ALWAYS AS ((tong_tien - da_tra)) STORED,
    trang_thai public.trang_thai_hoa_don DEFAULT 'DRAFT'::public.trang_thai_hoa_don NOT NULL,
    han_tra date NOT NULL,
    ngay_lap_hoa_don timestamp with time zone DEFAULT now() NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    auto_generated boolean DEFAULT false,
    generation_batch_id uuid,
    source_schedule_id uuid,
    hoa_don_goc_id uuid,
    loai_hoa_don character varying(32) DEFAULT 'REGULAR'::character varying NOT NULL,
    CONSTRAINT chk_hoa_don_ky CHECK (((ky_thang >= 1) AND (ky_thang <= 12) AND ((ky_nam >= 2000) AND (ky_nam <= 2100)))),
    CONSTRAINT chk_hoa_don_ngay CHECK (((den_ngay >= tu_ngay) AND (han_tra >= tu_ngay))),
    CONSTRAINT chk_hoa_don_tien CHECK (((tong_tien_phat_sinh >= (0)::numeric) AND (tong_tien >= (0)::numeric) AND (da_tra >= (0)::numeric)))
);


--
-- Name: hop_dong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hop_dong (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phong_id uuid NOT NULL,
    khach_thue_id uuid NOT NULL,
    ma_hop_dong character varying(100) NOT NULL,
    ngay_bat_dau date NOT NULL,
    ngay_ket_thuc date NOT NULL,
    ngay_ket_thuc_thuc_te date,
    gia_thue_hop_dong numeric(15,2) NOT NULL,
    tien_coc numeric(15,2) DEFAULT 0 NOT NULL,
    trang_thai_coc public.trang_thai_coc_hop_dong DEFAULT 'NOT_PAID'::public.trang_thai_coc_hop_dong NOT NULL,
    trang_thai public.trang_thai_hop_dong DEFAULT 'DRAFT'::public.trang_thai_hop_dong NOT NULL,
    chu_ky_thanh_toan character varying(30) DEFAULT 'MONTHLY'::character varying NOT NULL,
    ngay_thanh_toan_hang_thang integer DEFAULT 5 NOT NULL,
    tu_dong_gia_han boolean DEFAULT false NOT NULL,
    chi_so_dien_ban_dau integer,
    chi_so_nuoc_ban_dau integer,
    noi_dung_hop_dong text,
    file_pdf text,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    template_version character varying(100),
    previewed_at timestamp with time zone,
    confirmed_at timestamp with time zone,
    locked_at timestamp with time zone,
    signed_pdf_url text,
    tenant_signed_at timestamp with time zone,
    landlord_signed_at timestamp with time zone,
    signature_status character varying(50) DEFAULT 'UNSIGNED'::character varying NOT NULL,
    CONSTRAINT chk_hop_dong_chi_so CHECK ((((chi_so_dien_ban_dau IS NULL) OR (chi_so_dien_ban_dau >= 0)) AND ((chi_so_nuoc_ban_dau IS NULL) OR (chi_so_nuoc_ban_dau >= 0)))),
    CONSTRAINT chk_hop_dong_ngay CHECK ((ngay_ket_thuc > ngay_bat_dau)),
    CONSTRAINT chk_hop_dong_ngay_thanh_toan CHECK (((ngay_thanh_toan_hang_thang >= 1) AND (ngay_thanh_toan_hang_thang <= 31))),
    CONSTRAINT chk_hop_dong_tien CHECK (((gia_thue_hop_dong >= (0)::numeric) AND (tien_coc >= (0)::numeric)))
);


--
-- Name: invoice_generation_batch; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoice_generation_batch (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nha_tro_id uuid,
    ky_thang integer NOT NULL,
    ky_nam integer NOT NULL,
    trang_thai character varying(50) NOT NULL,
    tong_hop_dong integer NOT NULL,
    tao_thanh_cong integer NOT NULL,
    bo_qua integer NOT NULL,
    loi integer NOT NULL,
    nguoi_tao_id uuid,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: invoice_generation_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoice_generation_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    batch_id uuid NOT NULL,
    hop_dong_id uuid,
    hoa_don_id uuid,
    status character varying(50) NOT NULL,
    reason text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: khach_thue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.khach_thue (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid,
    chu_tro_id uuid NOT NULL,
    ho_ten character varying(255) NOT NULL,
    so_dien_thoai character varying(20),
    email character varying(255),
    so_cccd character varying(50),
    ngay_sinh date,
    gioi_tinh character varying(20),
    dia_chi text,
    que_quan character varying(255),
    nghe_nghiep character varying(255),
    ghi_chu text,
    dang_hoat_dong boolean DEFAULT true NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone
);


--
-- Name: kho_tai_san; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kho_tai_san (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nha_tro_id uuid NOT NULL,
    ten_tai_san character varying(255) NOT NULL,
    hinh_anh text,
    tong_so_luong integer DEFAULT 0 NOT NULL,
    so_luong_kha_dung integer DEFAULT 0 NOT NULL,
    so_luong_da_cap_phat integer DEFAULT 0 NOT NULL,
    so_luong_hu_hong integer DEFAULT 0 NOT NULL,
    tinh_trang character varying(255) NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now(),
    cap_nhat_luc timestamp with time zone DEFAULT now(),
    xoa_luc timestamp with time zone
);


--
-- Name: lich_hen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lich_hen (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phong_id uuid NOT NULL,
    nguoi_dung_id uuid,
    ho_ten character varying(255),
    so_dien_thoai character varying(20),
    email character varying(255),
    ngay_hen timestamp with time zone NOT NULL,
    trang_thai public.trang_thai_lich_hen DEFAULT 'PENDING'::public.trang_thai_lich_hen NOT NULL,
    google_calendar_event_id text,
    da_gui_nhac_nho boolean DEFAULT false NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    ghi_chu_admin text,
    so_cccd character varying(50)
);


--
-- Name: lich_su_hoa_don; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lich_su_hoa_don (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hoa_don_id uuid NOT NULL,
    trang_thai_truoc public.trang_thai_hoa_don,
    trang_thai_moi public.trang_thai_hoa_don NOT NULL,
    nguoi_thay_doi_id uuid,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: lich_su_kho_tai_san; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lich_su_kho_tai_san (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    kho_tai_san_id uuid NOT NULL,
    phong_id uuid,
    loai_giao_dich character varying(255) NOT NULL,
    so_luong integer NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now()
);


--
-- Name: lich_su_phuong_tien; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lich_su_phuong_tien (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phuong_tien_id uuid NOT NULL,
    khach_thue_id uuid NOT NULL,
    phong_id uuid NOT NULL,
    nha_tro_id uuid NOT NULL,
    hieu_luc_tu date NOT NULL,
    hieu_luc_den date,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT ck_lich_su_phuong_tien_dates CHECK (((hieu_luc_den IS NULL) OR (hieu_luc_den >= hieu_luc_tu)))
);


--
-- Name: lich_thanh_toan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lich_thanh_toan (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hop_dong_id uuid NOT NULL,
    ky_nam integer NOT NULL,
    ky_thang integer NOT NULL,
    tu_ngay date NOT NULL,
    den_ngay date NOT NULL,
    han_thanh_toan date NOT NULL,
    so_tien_du_kien numeric(15,2) NOT NULL,
    hoa_don_id uuid,
    trang_thai character varying(30) DEFAULT 'PENDING'::character varying NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    CONSTRAINT chk_lich_thanh_toan_ky CHECK (((ky_thang >= 1) AND (ky_thang <= 12) AND ((ky_nam >= 2000) AND (ky_nam <= 2100)))),
    CONSTRAINT chk_lich_thanh_toan_ngay CHECK (((den_ngay >= tu_ngay) AND (han_thanh_toan >= tu_ngay))),
    CONSTRAINT chk_lich_thanh_toan_tien CHECK ((so_tien_du_kien >= (0)::numeric))
);


--
-- Name: login_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.login_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid,
    email character varying(255),
    thanh_cong boolean NOT NULL,
    ip_address inet,
    user_agent text,
    ly_do_that_bai text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: meter_anomaly_alert; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meter_anomaly_alert (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    chi_so_id uuid NOT NULL,
    phong_id uuid NOT NULL,
    hop_dong_id uuid,
    loai character varying(50) NOT NULL,
    ky_thang integer NOT NULL,
    ky_nam integer NOT NULL,
    tieu_thu_hien_tai integer NOT NULL,
    tieu_thu_trung_binh numeric(10,2),
    ty_le_tang numeric(10,2),
    muc_do character varying(50) NOT NULL,
    ly_do text NOT NULL,
    trang_thai character varying(50) DEFAULT 'OPEN'::character varying NOT NULL,
    resolved_at timestamp with time zone,
    resolved_by uuid,
    tao_luc timestamp with time zone NOT NULL
);


--
-- Name: nguoi_dung; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nguoi_dung (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying(255) NOT NULL,
    ho_ten character varying(255) NOT NULL,
    so_dien_thoai character varying(20),
    anh_dai_dien text,
    ngay_sinh date,
    gioi_tinh character varying(20),
    dia_chi text,
    que_quan character varying(255),
    so_cccd character varying(50),
    trang_thai public.trang_thai_nguoi_dung DEFAULT 'ACTIVE'::public.trang_thai_nguoi_dung NOT NULL,
    so_lan_dang_nhap_sai integer DEFAULT 0 NOT NULL,
    khoa_den_luc timestamp with time zone,
    lan_dang_nhap_cuoi timestamp with time zone,
    cau_hinh_2fa jsonb,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    mat_khau character varying(255),
    trang_thai_kyc character varying(50) DEFAULT 'NONE'::character varying,
    anh_cccd_truoc character varying(500),
    anh_cccd_sau character varying(500),
    anh_gpkd character varying(500),
    CONSTRAINT chk_nguoi_dung_email_lower CHECK (((email)::text = lower((email)::text))),
    CONSTRAINT chk_nguoi_dung_login_fail CHECK ((so_lan_dang_nhap_sai >= 0))
);


--
-- Name: nguoi_dung_nha_tro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nguoi_dung_nha_tro (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid NOT NULL,
    nha_tro_id uuid NOT NULL,
    vai_tro public.vai_tro_he_thong NOT NULL,
    co_quyen_xem boolean DEFAULT true NOT NULL,
    co_quyen_sua boolean DEFAULT false NOT NULL,
    co_quyen_thu_tien boolean DEFAULT false NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_ndnt_role CHECK ((vai_tro = ANY (ARRAY['LANDLORD'::public.vai_tro_he_thong, 'STAFF'::public.vai_tro_he_thong])))
);


--
-- Name: nguoi_dung_vai_tro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nguoi_dung_vai_tro (
    nguoi_dung_id uuid NOT NULL,
    vai_tro_id uuid NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: nha_tro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nha_tro (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    chu_tro_id uuid NOT NULL,
    ten character varying(255) NOT NULL,
    dia_chi text NOT NULL,
    so_nha character varying(100),
    duong character varying(255),
    phuong character varying(100),
    quan character varying(100),
    thanh_pho character varying(100),
    mo_ta text,
    tien_nghi_chung text,
    noi_quy text,
    trang_thai character varying(30) DEFAULT 'ACTIVE'::character varying NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    vi_do numeric(10,7),
    kinh_do numeric(10,7),
    google_place_id character varying(255),
    dia_chi_da_chuan_hoa text,
    CONSTRAINT nha_tro_kinh_do_range CHECK (((kinh_do IS NULL) OR ((kinh_do >= ('-180'::integer)::numeric) AND (kinh_do <= (180)::numeric)))),
    CONSTRAINT nha_tro_vi_do_range CHECK (((vi_do IS NULL) OR ((vi_do >= ('-90'::integer)::numeric) AND (vi_do <= (90)::numeric))))
);


--
-- Name: notification_delivery; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_delivery (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    aggregate_type character varying(64) NOT NULL,
    aggregate_id uuid NOT NULL,
    rule_code character varying(128) NOT NULL,
    scheduled_for date NOT NULL,
    channel character varying(32) NOT NULL,
    recipient_id uuid NOT NULL,
    status character varying(16) DEFAULT 'PENDING'::character varying NOT NULL,
    error_message text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: phong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phong (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nha_tro_id uuid NOT NULL,
    ten character varying(100) NOT NULL,
    khu_vuc character varying(50),
    tang integer,
    dien_tich numeric(10,2) NOT NULL,
    so_nguoi_toi_da integer DEFAULT 2 NOT NULL,
    trang_thai public.trang_thai_phong DEFAULT 'AVAILABLE'::public.trang_thai_phong NOT NULL,
    gia_hien_tai numeric(15,2) NOT NULL,
    tien_coc_mac_dinh numeric(15,2) DEFAULT 0 NOT NULL,
    mo_ta text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    tang_id uuid,
    CONSTRAINT chk_phong_dien_tich CHECK ((dien_tich > (0)::numeric)),
    CONSTRAINT chk_phong_gia CHECK (((gia_hien_tai >= (0)::numeric) AND (tien_coc_mac_dinh >= (0)::numeric))),
    CONSTRAINT chk_phong_so_nguoi CHECK ((so_nguoi_toi_da > 0)),
    CONSTRAINT chk_phong_tang_hop_le CHECK (((tang IS NOT NULL) OR (tang_id IS NOT NULL)))
);


--
-- Name: phong_tien_ich; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phong_tien_ich (
    phong_id uuid NOT NULL,
    tien_ich_id uuid NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: phu_luc_hop_dong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phu_luc_hop_dong (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hop_dong_id uuid NOT NULL,
    loai character varying(50) NOT NULL,
    noi_dung text NOT NULL,
    ngay_hieu_luc date NOT NULL,
    gia_thue_moi numeric(15,2),
    ngay_ket_thuc_moi date,
    file_pdf text,
    nguoi_tao_id uuid,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: phuong_tien; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phuong_tien (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ma_pt character varying(50) NOT NULL,
    loai_xe character varying(255) NOT NULL,
    bien_so character varying(50) NOT NULL,
    khach_thue_id uuid,
    phong_id uuid,
    nha_tro_id uuid,
    chu_tro_id uuid,
    trang_thai public.trang_thai_phuong_tien DEFAULT 'HIEU_LUC'::public.trang_thai_phuong_tien,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    anh_xe character varying(255),
    loai_phuong_tien character varying(50),
    ten_dong_xe character varying(100),
    mau_xe character varying(50),
    ten_chu_xe character varying(100),
    so_ve_xe character varying(50),
    hieu_luc_tu date NOT NULL,
    hieu_luc_den date,
    CONSTRAINT phuong_tien_hieu_luc_check CHECK (((hieu_luc_den IS NULL) OR (hieu_luc_den >= hieu_luc_tu)))
);


--
-- Name: quyet_toan_tra_phong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quyet_toan_tra_phong (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hop_dong_id uuid NOT NULL,
    hoa_don_id uuid NOT NULL,
    ngay_tra_phong date NOT NULL,
    tien_coc_ban_dau numeric(18,2) DEFAULT 0 NOT NULL,
    tien_coc_da_can_tru numeric(18,2) DEFAULT 0 NOT NULL,
    tien_coc_can_hoan numeric(18,2) DEFAULT 0 NOT NULL,
    tien_phai_thu_them numeric(18,2) DEFAULT 0 NOT NULL,
    khoan_khau_tru jsonb DEFAULT '[]'::jsonb NOT NULL,
    trang_thai character varying(32) NOT NULL,
    ban_giao_da_xac_nhan boolean DEFAULT false NOT NULL,
    ve_sinh_kiem_tra_xong boolean DEFAULT false NOT NULL,
    hoan_coc_luc timestamp with time zone,
    ban_giao_luc timestamp with time zone,
    kiem_tra_luc timestamp with time zone,
    hoan_tat_luc timestamp with time zone,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT quyet_toan_tra_phong_coc_balance CHECK (((tien_coc_da_can_tru + tien_coc_can_hoan) = tien_coc_ban_dau)),
    CONSTRAINT quyet_toan_tra_phong_tien_non_negative CHECK (((tien_coc_ban_dau >= (0)::numeric) AND (tien_coc_da_can_tru >= (0)::numeric) AND (tien_coc_can_hoan >= (0)::numeric) AND (tien_phai_thu_them >= (0)::numeric)))
);


--
-- Name: refresh_token; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refresh_token (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid NOT NULL,
    token character varying(1024) NOT NULL,
    ngay_het_han timestamp with time zone NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: su_co; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.su_co (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phong_id uuid NOT NULL,
    khach_thue_id uuid,
    nguoi_bao_id uuid,
    tieu_de character varying(255) NOT NULL,
    mo_ta text NOT NULL,
    loai_su_co public.loai_su_co_enum DEFAULT 'khac'::public.loai_su_co_enum NOT NULL,
    uu_tien public.uu_tien_enum DEFAULT 'trung_binh'::public.uu_tien_enum NOT NULL,
    trang_thai public.trang_thai_su_co DEFAULT 'PENDING'::public.trang_thai_su_co NOT NULL,
    nguoi_phu_trach_id uuid,
    chi_phi_sua_chua numeric(15,2) DEFAULT 0 NOT NULL,
    tinh_vao_hoa_don boolean DEFAULT false NOT NULL,
    ghi_chu_chu_nha text,
    giai_quyet_luc timestamp with time zone,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_su_co_chi_phi CHECK ((chi_phi_sua_chua >= (0)::numeric))
);


--
-- Name: tai_san_phong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tai_san_phong (
    id uuid NOT NULL,
    phong_id uuid NOT NULL,
    ten_tai_san character varying(255) NOT NULL,
    so_luong integer NOT NULL,
    gia_tri numeric(19,2) NOT NULL,
    tinh_trang character varying(255) NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone,
    cap_nhat_luc timestamp with time zone,
    anh_tai_san text,
    xoa_luc timestamp with time zone,
    kho_tai_san_id uuid
);


--
-- Name: tang; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tang (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nha_tro_id uuid NOT NULL,
    so_tang integer NOT NULL,
    ten_tang character varying(100),
    thu_tu_hien_thi integer,
    so_phong_du_kien integer,
    trang_thai character varying(30) DEFAULT 'ACTIVE'::character varying NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    CONSTRAINT chk_tang_so_phong_du_kien CHECK (((so_phong_du_kien IS NULL) OR (so_phong_du_kien >= 0))),
    CONSTRAINT chk_tang_so_tang CHECK ((so_tang >= 0))
);


--
-- Name: thanh_toan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thanh_toan (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hoa_don_id uuid NOT NULL,
    khach_thue_id uuid,
    so_tien numeric(15,2) NOT NULL,
    ngay_thanh_toan timestamp with time zone DEFAULT now() NOT NULL,
    phuong_thuc_thanh_toan public.phuong_thuc_thanh_toan DEFAULT 'CASH'::public.phuong_thuc_thanh_toan NOT NULL,
    ma_tham_chieu character varying(150),
    external_transaction_id character varying(150),
    trang_thai public.trang_thai_thanh_toan DEFAULT 'SUCCESS'::public.trang_thai_thanh_toan NOT NULL,
    nguoi_thanh_toan_id uuid,
    nguoi_ghi_nhan_id uuid,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_thanh_toan_tien CHECK ((so_tien > (0)::numeric))
);


--
-- Name: thanh_vien_cuoc_tro_chuyen; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thanh_vien_cuoc_tro_chuyen (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    cuoc_tro_chuyen_id uuid NOT NULL,
    nguoi_dung_id uuid NOT NULL,
    vai_tro public.vai_tro_thanh_vien_chat DEFAULT 'MEMBER'::public.vai_tro_thanh_vien_chat NOT NULL,
    tham_gia_luc timestamp with time zone DEFAULT now() NOT NULL,
    roi_luc timestamp with time zone,
    doc_den_seq bigint DEFAULT 0 NOT NULL,
    doc_den_luc timestamp with time zone,
    tat_thong_bao boolean DEFAULT false NOT NULL,
    ghim boolean DEFAULT false NOT NULL,
    luu_tru boolean DEFAULT false NOT NULL,
    an_den_seq bigint DEFAULT 0 NOT NULL,
    biet_danh text,
    tat_thong_bao_den timestamp with time zone
);


--
-- Name: COLUMN thanh_vien_cuoc_tro_chuyen.tat_thong_bao; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.thanh_vien_cuoc_tro_chuyen.tat_thong_bao IS 'T???t th??ng b??o v?? th???i h???n (?????n khi ng?????i d??ng t??? b???t l???i)';


--
-- Name: COLUMN thanh_vien_cuoc_tro_chuyen.luu_tru; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.thanh_vien_cuoc_tro_chuyen.luu_tru IS 'L??u tr???: ???n kh???i danh s??ch nh??ng gi??? l???ch s???, c?? tin m???i th?? hi???n l???i';


--
-- Name: COLUMN thanh_vien_cuoc_tro_chuyen.an_den_seq; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.thanh_vien_cuoc_tro_chuyen.an_den_seq IS 'Xo?? b???n c???a m??nh: ch??? hi???n th??? tin c?? so_thu_tu > gi?? tr??? n??y. Kh??ng ?????ng d??? li???u ng?????i kh??c';


--
-- Name: COLUMN thanh_vien_cuoc_tro_chuyen.tat_thong_bao_den; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.thanh_vien_cuoc_tro_chuyen.tat_thong_bao_den IS 'T???t th??ng b??o t???i th???i ??i???m n??y. ??ang t???t = tat_thong_bao OR tat_thong_bao_den > now()';


--
-- Name: thanh_vien_hop_dong; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thanh_vien_hop_dong (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hop_dong_id uuid NOT NULL,
    khach_thue_id uuid,
    ho_ten character varying(255) NOT NULL,
    so_cccd character varying(50),
    so_dien_thoai character varying(20),
    ngay_vao date DEFAULT CURRENT_DATE NOT NULL,
    ngay_roi date,
    dang_o boolean DEFAULT true NOT NULL,
    la_nguoi_dai_dien boolean DEFAULT false NOT NULL,
    ghi_chu text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_tvhd_ngay CHECK (((ngay_roi IS NULL) OR (ngay_roi >= ngay_vao)))
);


--
-- Name: thong_bao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thong_bao (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_gui_id uuid,
    loai public.loai_thong_bao DEFAULT 'SYSTEM'::public.loai_thong_bao NOT NULL,
    tieu_de character varying(255) NOT NULL,
    noi_dung text NOT NULL,
    doi_tuong public.loai_doi_tuong_media,
    doi_tuong_id uuid,
    kenh public.kenh_thong_bao DEFAULT 'IN_APP'::public.kenh_thong_bao NOT NULL,
    gui_tat_ca boolean DEFAULT false NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone
);


--
-- Name: thong_bao_nguoi_nhan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.thong_bao_nguoi_nhan (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    thong_bao_id uuid NOT NULL,
    nguoi_dung_id uuid NOT NULL,
    da_doc boolean DEFAULT false NOT NULL,
    doc_luc timestamp with time zone,
    gui_luc timestamp with time zone,
    loi_gui text
);


--
-- Name: tien_ich; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tien_ich (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ten character varying(100) NOT NULL,
    bieu_tuong character varying(100),
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: tin_nhan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tin_nhan (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    so_thu_tu bigint NOT NULL,
    cuoc_tro_chuyen_id uuid NOT NULL,
    nguoi_gui_id uuid,
    loai public.loai_tin_nhan DEFAULT 'TEXT'::public.loai_tin_nhan NOT NULL,
    noi_dung text,
    file_media_id uuid,
    tra_loi_cho_id uuid,
    ma_client text,
    da_thu_hoi boolean DEFAULT false NOT NULL,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL,
    cap_nhat_luc timestamp with time zone DEFAULT now() NOT NULL,
    xoa_luc timestamp with time zone,
    ghim_luc timestamp with time zone,
    nguoi_ghim_id uuid,
    chuyen_tiep_tu_id uuid
);


--
-- Name: COLUMN tin_nhan.ghim_luc; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tin_nhan.ghim_luc IS 'Th???i ??i???m ???????c ghim. NULL = kh??ng ghim. Ph???m vi c??? h???i tho???i, m???i th??nh vi??n ?????u th???y';


--
-- Name: COLUMN tin_nhan.nguoi_ghim_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tin_nhan.nguoi_ghim_id IS 'Ai ???? ghim ??? d??ng ????? hi???n th??? "X ???? ghim m???t tin nh???n"';


--
-- Name: COLUMN tin_nhan.chuyen_tiep_tu_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.tin_nhan.chuyen_tiep_tu_id IS 'Tin g???c n???u ????y l?? b???n chuy???n ti???p. D??ng ????? truy v???t khi ki???m duy???t';


--
-- Name: tin_nhan_so_thu_tu_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tin_nhan_so_thu_tu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tin_nhan_so_thu_tu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tin_nhan_so_thu_tu_seq OWNED BY public.tin_nhan.so_thu_tu;


--
-- Name: v_so_do_toa_nha; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_so_do_toa_nha AS
 SELECT nt.id AS nha_tro_id,
    nt.ten AS ten_toa_nha,
    COALESCE(t.so_tang, p.tang) AS so_tang,
    COALESCE(t.ten_tang, (('Tang '::text || (COALESCE(t.so_tang, p.tang))::text))::character varying) AS ten_tang,
    p.id AS phong_id,
    p.ten AS ma_phong,
    p.dien_tich,
    p.gia_hien_tai,
    p.trang_thai AS trang_thai_vat_ly,
    hd.id AS hop_dong_id,
    hd.ma_hop_dong,
    hd.ngay_bat_dau,
    hd.ngay_ket_thuc,
    kt.id AS khach_thue_id,
    kt.ho_ten AS khach_thue_hien_tai,
        CASE
            WHEN (p.trang_thai = 'MAINTENANCE'::public.trang_thai_phong) THEN 'MAINTENANCE'::text
            WHEN (hd.id IS NULL) THEN 'VACANT'::text
            WHEN (hd.ngay_ket_thuc <= (CURRENT_DATE + '30 days'::interval)) THEN 'CONTRACT_EXPIRING'::text
            ELSE 'RENTED'::text
        END AS trang_thai_hien_thi
   FROM ((((public.nha_tro nt
     LEFT JOIN public.tang t ON (((t.nha_tro_id = nt.id) AND (t.xoa_luc IS NULL))))
     LEFT JOIN public.phong p ON (((p.nha_tro_id = nt.id) AND (p.xoa_luc IS NULL) AND ((p.tang_id = t.id) OR ((p.tang_id IS NULL) AND (p.tang = t.so_tang))))))
     LEFT JOIN LATERAL ( SELECT h.id,
            h.phong_id,
            h.khach_thue_id,
            h.ma_hop_dong,
            h.ngay_bat_dau,
            h.ngay_ket_thuc,
            h.ngay_ket_thuc_thuc_te,
            h.gia_thue_hop_dong,
            h.tien_coc,
            h.trang_thai_coc,
            h.trang_thai,
            h.chu_ky_thanh_toan,
            h.ngay_thanh_toan_hang_thang,
            h.tu_dong_gia_han,
            h.chi_so_dien_ban_dau,
            h.chi_so_nuoc_ban_dau,
            h.noi_dung_hop_dong,
            h.file_pdf,
            h.ghi_chu,
            h.tao_luc,
            h.cap_nhat_luc,
            h.xoa_luc,
            h.template_version,
            h.previewed_at,
            h.confirmed_at,
            h.locked_at
           FROM public.hop_dong h
          WHERE ((h.phong_id = p.id) AND (h.xoa_luc IS NULL) AND (h.trang_thai = ANY (ARRAY['PENDING'::public.trang_thai_hop_dong, 'ACTIVE'::public.trang_thai_hop_dong])) AND ((CURRENT_DATE >= h.ngay_bat_dau) AND (CURRENT_DATE <= h.ngay_ket_thuc)))
          ORDER BY h.ngay_bat_dau DESC
         LIMIT 1) hd ON (true))
     LEFT JOIN public.khach_thue kt ON ((kt.id = hd.khach_thue_id)))
  WHERE (nt.xoa_luc IS NULL);


--
-- Name: v_thong_ke_toa_nha; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_thong_ke_toa_nha AS
 SELECT nt.id AS nha_tro_id,
    nt.ten AS ten_toa_nha,
    count(DISTINCT t.id) AS tong_so_tang,
    count(DISTINCT p.id) AS tong_so_phong,
    count(DISTINCT p.id) FILTER (WHERE ((p.trang_thai = 'AVAILABLE'::public.trang_thai_phong) AND (hd.id IS NULL))) AS phong_trong,
    count(DISTINCT p.id) FILTER (WHERE (hd.id IS NOT NULL)) AS phong_dang_thue,
    count(DISTINCT p.id) FILTER (WHERE (p.trang_thai = 'MAINTENANCE'::public.trang_thai_phong)) AS phong_bao_tri,
    count(DISTINCT p.id) FILTER (WHERE ((hd.id IS NOT NULL) AND (hd.ngay_ket_thuc <= (CURRENT_DATE + '30 days'::interval)))) AS hop_dong_sap_het_han,
    COALESCE(sum(hd.gia_thue_hop_dong), (0)::numeric) AS doanh_thu_du_kien_thang
   FROM (((public.nha_tro nt
     LEFT JOIN public.tang t ON (((t.nha_tro_id = nt.id) AND (t.xoa_luc IS NULL))))
     LEFT JOIN public.phong p ON (((p.nha_tro_id = nt.id) AND (p.xoa_luc IS NULL))))
     LEFT JOIN LATERAL ( SELECT h.id,
            h.phong_id,
            h.khach_thue_id,
            h.ma_hop_dong,
            h.ngay_bat_dau,
            h.ngay_ket_thuc,
            h.ngay_ket_thuc_thuc_te,
            h.gia_thue_hop_dong,
            h.tien_coc,
            h.trang_thai_coc,
            h.trang_thai,
            h.chu_ky_thanh_toan,
            h.ngay_thanh_toan_hang_thang,
            h.tu_dong_gia_han,
            h.chi_so_dien_ban_dau,
            h.chi_so_nuoc_ban_dau,
            h.noi_dung_hop_dong,
            h.file_pdf,
            h.ghi_chu,
            h.tao_luc,
            h.cap_nhat_luc,
            h.xoa_luc,
            h.template_version,
            h.previewed_at,
            h.confirmed_at,
            h.locked_at
           FROM public.hop_dong h
          WHERE ((h.phong_id = p.id) AND (h.xoa_luc IS NULL) AND (h.trang_thai = ANY (ARRAY['PENDING'::public.trang_thai_hop_dong, 'ACTIVE'::public.trang_thai_hop_dong])) AND ((CURRENT_DATE >= h.ngay_bat_dau) AND (CURRENT_DATE <= h.ngay_ket_thuc)))
          ORDER BY h.ngay_bat_dau DESC
         LIMIT 1) hd ON (true))
  WHERE (nt.xoa_luc IS NULL)
  GROUP BY nt.id, nt.ten;


--
-- Name: vai_tro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vai_tro (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ten public.vai_tro_he_thong NOT NULL,
    mo_ta text,
    tao_luc timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: yeu_cau_o_ghep; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.yeu_cau_o_ghep (
    id uuid NOT NULL,
    khach_thue_id uuid NOT NULL,
    hop_dong_id uuid NOT NULL,
    trang_thai character varying(255) NOT NULL,
    loi_nhan character varying(255),
    ghi_chu_tu_choi character varying(255),
    tao_luc timestamp with time zone NOT NULL,
    cap_nhat_luc timestamp with time zone
);


--
-- Name: tin_nhan so_thu_tu; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan ALTER COLUMN so_thu_tu SET DEFAULT nextval('public.tin_nhan_so_thu_tu_seq'::regclass);


--
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- Name: bank_transaction bank_transaction_ma_giao_dich_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_transaction
    ADD CONSTRAINT bank_transaction_ma_giao_dich_key UNIQUE (ma_giao_dich);


--
-- Name: bank_transaction bank_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_transaction
    ADD CONSTRAINT bank_transaction_pkey PRIMARY KEY (id);


--
-- Name: bao_cao_tin_nhan bao_cao_tin_nhan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bao_cao_tin_nhan
    ADD CONSTRAINT bao_cao_tin_nhan_pkey PRIMARY KEY (id);


--
-- Name: cau_hinh_gia cau_hinh_gia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cau_hinh_gia
    ADD CONSTRAINT cau_hinh_gia_pkey PRIMARY KEY (id);


--
-- Name: cau_hinh_phi_xe cau_hinh_phi_xe_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cau_hinh_phi_xe
    ADD CONSTRAINT cau_hinh_phi_xe_pkey PRIMARY KEY (id);


--
-- Name: chan_nguoi_dung chan_nguoi_dung_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chan_nguoi_dung
    ADD CONSTRAINT chan_nguoi_dung_pkey PRIMARY KEY (id);


--
-- Name: chi_so_dien_nuoc chi_so_dien_nuoc_phong_id_loai_ky_nam_ky_thang_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_so_dien_nuoc
    ADD CONSTRAINT chi_so_dien_nuoc_phong_id_loai_ky_nam_ky_thang_key UNIQUE (phong_id, loai, ky_nam, ky_thang);


--
-- Name: chi_so_dien_nuoc chi_so_dien_nuoc_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_so_dien_nuoc
    ADD CONSTRAINT chi_so_dien_nuoc_pkey PRIMARY KEY (id);


--
-- Name: chi_tiet_ban_giao_tai_san chi_tiet_ban_giao_tai_san_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_tiet_ban_giao_tai_san
    ADD CONSTRAINT chi_tiet_ban_giao_tai_san_pkey PRIMARY KEY (id);


--
-- Name: chi_tiet_hoa_don chi_tiet_hoa_don_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_tiet_hoa_don
    ADD CONSTRAINT chi_tiet_hoa_don_pkey PRIMARY KEY (id);


--
-- Name: chu_tro chu_tro_nguoi_dung_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chu_tro
    ADD CONSTRAINT chu_tro_nguoi_dung_id_key UNIQUE (nguoi_dung_id);


--
-- Name: chu_tro chu_tro_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chu_tro
    ADD CONSTRAINT chu_tro_pkey PRIMARY KEY (id);


--
-- Name: chu_tro chu_tro_so_cccd_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chu_tro
    ADD CONSTRAINT chu_tro_so_cccd_key UNIQUE (so_cccd);


--
-- Name: contract_signature contract_signature_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contract_signature
    ADD CONSTRAINT contract_signature_pkey PRIMARY KEY (id);


--
-- Name: cuoc_tro_chuyen cuoc_tro_chuyen_khoa_duy_nhat_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuoc_tro_chuyen
    ADD CONSTRAINT cuoc_tro_chuyen_khoa_duy_nhat_key UNIQUE (khoa_duy_nhat);


--
-- Name: cuoc_tro_chuyen cuoc_tro_chuyen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuoc_tro_chuyen
    ADD CONSTRAINT cuoc_tro_chuyen_pkey PRIMARY KEY (id);


--
-- Name: dang_ky_push dang_ky_push_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dang_ky_push
    ADD CONSTRAINT dang_ky_push_pkey PRIMARY KEY (id);


--
-- Name: dat_coc_phong dat_coc_phong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dat_coc_phong
    ADD CONSTRAINT dat_coc_phong_pkey PRIMARY KEY (id);


--
-- Name: debt_reminder_log debt_reminder_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.debt_reminder_log
    ADD CONSTRAINT debt_reminder_log_pkey PRIMARY KEY (id);


--
-- Name: dich_vu dich_vu_chu_tro_id_ten_dich_vu_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dich_vu
    ADD CONSTRAINT dich_vu_chu_tro_id_ten_dich_vu_key UNIQUE (chu_tro_id, ten_dich_vu);


--
-- Name: dich_vu_hop_dong dich_vu_hop_dong_hop_dong_id_dich_vu_id_bat_dau_tu_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dich_vu_hop_dong
    ADD CONSTRAINT dich_vu_hop_dong_hop_dong_id_dich_vu_id_bat_dau_tu_key UNIQUE (hop_dong_id, dich_vu_id, bat_dau_tu);


--
-- Name: dich_vu_hop_dong dich_vu_hop_dong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dich_vu_hop_dong
    ADD CONSTRAINT dich_vu_hop_dong_pkey PRIMARY KEY (id);


--
-- Name: dich_vu dich_vu_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dich_vu
    ADD CONSTRAINT dich_vu_pkey PRIMARY KEY (id);


--
-- Name: email_verification_token email_verification_token_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_verification_token
    ADD CONSTRAINT email_verification_token_pkey PRIMARY KEY (id);


--
-- Name: email_verification_token email_verification_token_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_verification_token
    ADD CONSTRAINT email_verification_token_token_key UNIQUE (token);


--
-- Name: hop_dong excl_hop_dong_phong_active_overlap; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hop_dong
    ADD CONSTRAINT excl_hop_dong_phong_active_overlap EXCLUDE USING gist (phong_id WITH =, daterange(ngay_bat_dau, ngay_ket_thuc, '[]'::text) WITH &&) WHERE ((trang_thai = ANY (ARRAY['PENDING'::public.trang_thai_hop_dong, 'ACTIVE'::public.trang_thai_hop_dong])));


--
-- Name: file_media file_media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_media
    ADD CONSTRAINT file_media_pkey PRIMARY KEY (id);


--
-- Name: giao_dich_tien_coc giao_dich_tien_coc_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.giao_dich_tien_coc
    ADD CONSTRAINT giao_dich_tien_coc_pkey PRIMARY KEY (id);


--
-- Name: giao_dich_tien_coc giao_dich_tien_coc_thanh_toan_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.giao_dich_tien_coc
    ADD CONSTRAINT giao_dich_tien_coc_thanh_toan_id_key UNIQUE (thanh_toan_id);


--
-- Name: hoa_don hoa_don_hop_dong_id_ky_nam_ky_thang_loai_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hoa_don
    ADD CONSTRAINT hoa_don_hop_dong_id_ky_nam_ky_thang_loai_key UNIQUE (hop_dong_id, ky_nam, ky_thang, loai_hoa_don);


--
-- Name: hoa_don hoa_don_ma_hoa_don_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hoa_don
    ADD CONSTRAINT hoa_don_ma_hoa_don_key UNIQUE (ma_hoa_don);


--
-- Name: hoa_don hoa_don_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hoa_don
    ADD CONSTRAINT hoa_don_pkey PRIMARY KEY (id);


--
-- Name: hop_dong hop_dong_ma_hop_dong_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hop_dong
    ADD CONSTRAINT hop_dong_ma_hop_dong_key UNIQUE (ma_hop_dong);


--
-- Name: hop_dong hop_dong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hop_dong
    ADD CONSTRAINT hop_dong_pkey PRIMARY KEY (id);


--
-- Name: invoice_generation_batch invoice_generation_batch_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_generation_batch
    ADD CONSTRAINT invoice_generation_batch_pkey PRIMARY KEY (id);


--
-- Name: invoice_generation_log invoice_generation_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_generation_log
    ADD CONSTRAINT invoice_generation_log_pkey PRIMARY KEY (id);


--
-- Name: khach_thue khach_thue_chu_tro_id_so_cccd_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.khach_thue
    ADD CONSTRAINT khach_thue_chu_tro_id_so_cccd_key UNIQUE (chu_tro_id, so_cccd);


--
-- Name: khach_thue khach_thue_nguoi_dung_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.khach_thue
    ADD CONSTRAINT khach_thue_nguoi_dung_id_key UNIQUE (nguoi_dung_id);


--
-- Name: khach_thue khach_thue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.khach_thue
    ADD CONSTRAINT khach_thue_pkey PRIMARY KEY (id);


--
-- Name: kho_tai_san kho_tai_san_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kho_tai_san
    ADD CONSTRAINT kho_tai_san_pkey PRIMARY KEY (id);


--
-- Name: lich_hen lich_hen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_hen
    ADD CONSTRAINT lich_hen_pkey PRIMARY KEY (id);


--
-- Name: lich_su_hoa_don lich_su_hoa_don_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_hoa_don
    ADD CONSTRAINT lich_su_hoa_don_pkey PRIMARY KEY (id);


--
-- Name: lich_su_kho_tai_san lich_su_kho_tai_san_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_kho_tai_san
    ADD CONSTRAINT lich_su_kho_tai_san_pkey PRIMARY KEY (id);


--
-- Name: lich_su_phuong_tien lich_su_phuong_tien_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_phuong_tien
    ADD CONSTRAINT lich_su_phuong_tien_pkey PRIMARY KEY (id);


--
-- Name: lich_thanh_toan lich_thanh_toan_hop_dong_id_ky_nam_ky_thang_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_thanh_toan
    ADD CONSTRAINT lich_thanh_toan_hop_dong_id_ky_nam_ky_thang_key UNIQUE (hop_dong_id, ky_nam, ky_thang);


--
-- Name: lich_thanh_toan lich_thanh_toan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_thanh_toan
    ADD CONSTRAINT lich_thanh_toan_pkey PRIMARY KEY (id);


--
-- Name: login_history login_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_pkey PRIMARY KEY (id);


--
-- Name: meter_anomaly_alert meter_anomaly_alert_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meter_anomaly_alert
    ADD CONSTRAINT meter_anomaly_alert_pkey PRIMARY KEY (id);


--
-- Name: nguoi_dung nguoi_dung_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung
    ADD CONSTRAINT nguoi_dung_email_key UNIQUE (email);


--
-- Name: nguoi_dung_nha_tro nguoi_dung_nha_tro_nguoi_dung_id_nha_tro_id_vai_tro_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung_nha_tro
    ADD CONSTRAINT nguoi_dung_nha_tro_nguoi_dung_id_nha_tro_id_vai_tro_key UNIQUE (nguoi_dung_id, nha_tro_id, vai_tro);


--
-- Name: nguoi_dung_nha_tro nguoi_dung_nha_tro_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung_nha_tro
    ADD CONSTRAINT nguoi_dung_nha_tro_pkey PRIMARY KEY (id);


--
-- Name: nguoi_dung nguoi_dung_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung
    ADD CONSTRAINT nguoi_dung_pkey PRIMARY KEY (id);


--
-- Name: nguoi_dung nguoi_dung_so_cccd_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung
    ADD CONSTRAINT nguoi_dung_so_cccd_key UNIQUE (so_cccd);


--
-- Name: nguoi_dung nguoi_dung_so_dien_thoai_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung
    ADD CONSTRAINT nguoi_dung_so_dien_thoai_key UNIQUE (so_dien_thoai);


--
-- Name: nguoi_dung_vai_tro nguoi_dung_vai_tro_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung_vai_tro
    ADD CONSTRAINT nguoi_dung_vai_tro_pkey PRIMARY KEY (nguoi_dung_id, vai_tro_id);


--
-- Name: nha_tro nha_tro_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nha_tro
    ADD CONSTRAINT nha_tro_pkey PRIMARY KEY (id);


--
-- Name: notification_delivery notification_delivery_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_delivery
    ADD CONSTRAINT notification_delivery_pkey PRIMARY KEY (id);


--
-- Name: phong phong_nha_tro_id_ten_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phong
    ADD CONSTRAINT phong_nha_tro_id_ten_key UNIQUE (nha_tro_id, ten);


--
-- Name: phong phong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phong
    ADD CONSTRAINT phong_pkey PRIMARY KEY (id);


--
-- Name: phong_tien_ich phong_tien_ich_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phong_tien_ich
    ADD CONSTRAINT phong_tien_ich_pkey PRIMARY KEY (phong_id, tien_ich_id);


--
-- Name: phu_luc_hop_dong phu_luc_hop_dong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phu_luc_hop_dong
    ADD CONSTRAINT phu_luc_hop_dong_pkey PRIMARY KEY (id);


--
-- Name: phuong_tien phuong_tien_ma_pt_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phuong_tien
    ADD CONSTRAINT phuong_tien_ma_pt_key UNIQUE (ma_pt);


--
-- Name: phuong_tien phuong_tien_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phuong_tien
    ADD CONSTRAINT phuong_tien_pkey PRIMARY KEY (id);


--
-- Name: quyet_toan_tra_phong quyet_toan_tra_phong_hoa_don_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quyet_toan_tra_phong
    ADD CONSTRAINT quyet_toan_tra_phong_hoa_don_id_key UNIQUE (hoa_don_id);


--
-- Name: quyet_toan_tra_phong quyet_toan_tra_phong_hop_dong_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quyet_toan_tra_phong
    ADD CONSTRAINT quyet_toan_tra_phong_hop_dong_id_key UNIQUE (hop_dong_id);


--
-- Name: quyet_toan_tra_phong quyet_toan_tra_phong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quyet_toan_tra_phong
    ADD CONSTRAINT quyet_toan_tra_phong_pkey PRIMARY KEY (id);


--
-- Name: refresh_token refresh_token_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_token
    ADD CONSTRAINT refresh_token_pkey PRIMARY KEY (id);


--
-- Name: refresh_token refresh_token_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_token
    ADD CONSTRAINT refresh_token_token_key UNIQUE (token);


--
-- Name: su_co su_co_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.su_co
    ADD CONSTRAINT su_co_pkey PRIMARY KEY (id);


--
-- Name: tai_san_phong tai_san_phong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tai_san_phong
    ADD CONSTRAINT tai_san_phong_pkey PRIMARY KEY (id);


--
-- Name: tang tang_nha_tro_id_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tang
    ADD CONSTRAINT tang_nha_tro_id_id_key UNIQUE (nha_tro_id, id);


--
-- Name: tang tang_nha_tro_id_so_tang_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tang
    ADD CONSTRAINT tang_nha_tro_id_so_tang_key UNIQUE (nha_tro_id, so_tang);


--
-- Name: tang tang_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tang
    ADD CONSTRAINT tang_pkey PRIMARY KEY (id);


--
-- Name: thanh_toan thanh_toan_external_transaction_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_toan
    ADD CONSTRAINT thanh_toan_external_transaction_id_key UNIQUE (external_transaction_id);


--
-- Name: thanh_toan thanh_toan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_toan
    ADD CONSTRAINT thanh_toan_pkey PRIMARY KEY (id);


--
-- Name: thanh_vien_cuoc_tro_chuyen thanh_vien_cuoc_tro_chuyen_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_vien_cuoc_tro_chuyen
    ADD CONSTRAINT thanh_vien_cuoc_tro_chuyen_pkey PRIMARY KEY (id);


--
-- Name: thanh_vien_hop_dong thanh_vien_hop_dong_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_vien_hop_dong
    ADD CONSTRAINT thanh_vien_hop_dong_pkey PRIMARY KEY (id);


--
-- Name: thong_bao_nguoi_nhan thong_bao_nguoi_nhan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thong_bao_nguoi_nhan
    ADD CONSTRAINT thong_bao_nguoi_nhan_pkey PRIMARY KEY (id);


--
-- Name: thong_bao_nguoi_nhan thong_bao_nguoi_nhan_thong_bao_id_nguoi_dung_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thong_bao_nguoi_nhan
    ADD CONSTRAINT thong_bao_nguoi_nhan_thong_bao_id_nguoi_dung_id_key UNIQUE (thong_bao_id, nguoi_dung_id);


--
-- Name: thong_bao thong_bao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thong_bao
    ADD CONSTRAINT thong_bao_pkey PRIMARY KEY (id);


--
-- Name: tien_ich tien_ich_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tien_ich
    ADD CONSTRAINT tien_ich_pkey PRIMARY KEY (id);


--
-- Name: tien_ich tien_ich_ten_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tien_ich
    ADD CONSTRAINT tien_ich_ten_key UNIQUE (ten);


--
-- Name: tin_nhan tin_nhan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan
    ADD CONSTRAINT tin_nhan_pkey PRIMARY KEY (id);


--
-- Name: tin_nhan tin_nhan_so_thu_tu_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan
    ADD CONSTRAINT tin_nhan_so_thu_tu_key UNIQUE (so_thu_tu);


--
-- Name: bao_cao_tin_nhan uq_bao_cao_tin_nhan; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bao_cao_tin_nhan
    ADD CONSTRAINT uq_bao_cao_tin_nhan UNIQUE (tin_nhan_id, nguoi_bao_cao_id);


--
-- Name: chan_nguoi_dung uq_chan_nguoi_dung; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chan_nguoi_dung
    ADD CONSTRAINT uq_chan_nguoi_dung UNIQUE (nguoi_chan_id, nguoi_bi_chan_id);


--
-- Name: dang_ky_push uq_dang_ky_push_endpoint; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dang_ky_push
    ADD CONSTRAINT uq_dang_ky_push_endpoint UNIQUE (endpoint);


--
-- Name: notification_delivery uq_notification_delivery_rule; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_delivery
    ADD CONSTRAINT uq_notification_delivery_rule UNIQUE (aggregate_type, aggregate_id, rule_code, scheduled_for, channel, recipient_id);


--
-- Name: thanh_vien_cuoc_tro_chuyen uq_thanh_vien_cuoc_tro_chuyen; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_vien_cuoc_tro_chuyen
    ADD CONSTRAINT uq_thanh_vien_cuoc_tro_chuyen UNIQUE (cuoc_tro_chuyen_id, nguoi_dung_id);


--
-- Name: vai_tro vai_tro_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vai_tro
    ADD CONSTRAINT vai_tro_pkey PRIMARY KEY (id);


--
-- Name: vai_tro vai_tro_ten_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vai_tro
    ADD CONSTRAINT vai_tro_ten_key UNIQUE (ten);


--
-- Name: yeu_cau_o_ghep yeu_cau_o_ghep_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.yeu_cau_o_ghep
    ADD CONSTRAINT yeu_cau_o_ghep_pkey PRIMARY KEY (id);


--
-- Name: idx_audit_log_target; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_log_target ON public.audit_log USING btree (bang_tac_dong, ban_ghi_id);


--
-- Name: idx_bao_cao_cho_xu_ly; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bao_cao_cho_xu_ly ON public.bao_cao_tin_nhan USING btree (tao_luc DESC) WHERE (trang_thai = 'PENDING'::public.trang_thai_bao_cao);


--
-- Name: idx_cau_hinh_gia_nha_tro; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cau_hinh_gia_nha_tro ON public.cau_hinh_gia USING btree (nha_tro_id, loai, dang_ap_dung);


--
-- Name: idx_cau_hinh_phi_xe_lookup; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cau_hinh_phi_xe_lookup ON public.cau_hinh_phi_xe USING btree (nha_tro_id, loai_xe, hieu_luc_tu DESC);


--
-- Name: idx_chan_theo_nguoi_bi_chan; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chan_theo_nguoi_bi_chan ON public.chan_nguoi_dung USING btree (nguoi_bi_chan_id);


--
-- Name: idx_chi_so_phong_ky; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chi_so_phong_ky ON public.chi_so_dien_nuoc USING btree (phong_id, loai, ky_nam, ky_thang);


--
-- Name: idx_chi_tiet_ban_giao_tai_san_quyet_toan; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chi_tiet_ban_giao_tai_san_quyet_toan ON public.chi_tiet_ban_giao_tai_san USING btree (quyet_toan_tra_phong_id);


--
-- Name: idx_chi_tiet_hoa_don_source; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chi_tiet_hoa_don_source ON public.chi_tiet_hoa_don USING btree (source_type, source_id);


--
-- Name: idx_cthd_hoa_don; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cthd_hoa_don ON public.chi_tiet_hoa_don USING btree (hoa_don_id);


--
-- Name: idx_cuoc_tro_chuyen_nha_tro; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cuoc_tro_chuyen_nha_tro ON public.cuoc_tro_chuyen USING btree (nha_tro_id) WHERE (xoa_luc IS NULL);


--
-- Name: idx_cuoc_tro_chuyen_tin_cuoi; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cuoc_tro_chuyen_tin_cuoi ON public.cuoc_tro_chuyen USING btree (tin_nhan_cuoi_luc DESC) WHERE (xoa_luc IS NULL);


--
-- Name: idx_dang_ky_push_nguoi_dung; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dang_ky_push_nguoi_dung ON public.dang_ky_push USING btree (nguoi_dung_id) WHERE (dung_luc IS NULL);


--
-- Name: idx_dat_coc_phong; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dat_coc_phong ON public.dat_coc_phong USING btree (phong_id, trang_thai);


--
-- Name: idx_dvhd_hop_dong; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dvhd_hop_dong ON public.dich_vu_hop_dong USING btree (hop_dong_id);


--
-- Name: idx_file_media_target; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_file_media_target ON public.file_media USING btree (doi_tuong, doi_tuong_id);


--
-- Name: idx_giao_dich_tien_coc_hop_dong_thoi_diem; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_giao_dich_tien_coc_hop_dong_thoi_diem ON public.giao_dich_tien_coc USING btree (hop_dong_id, thoi_diem);


--
-- Name: idx_hoa_don_hoa_don_goc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hoa_don_hoa_don_goc ON public.hoa_don USING btree (hoa_don_goc_id) WHERE (hoa_don_goc_id IS NOT NULL);


--
-- Name: idx_hoa_don_hop_dong_ky; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hoa_don_hop_dong_ky ON public.hoa_don USING btree (hop_dong_id, ky_nam, ky_thang);


--
-- Name: idx_hoa_don_khach_thue; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hoa_don_khach_thue ON public.hoa_don USING btree (khach_thue_id);


--
-- Name: idx_hoa_don_phong; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hoa_don_phong ON public.hoa_don USING btree (phong_id);


--
-- Name: idx_hoa_don_status_due; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hoa_don_status_due ON public.hoa_don USING btree (trang_thai, han_tra);


--
-- Name: idx_hop_dong_khach_thue; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hop_dong_khach_thue ON public.hop_dong USING btree (khach_thue_id);


--
-- Name: idx_hop_dong_phong_status_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hop_dong_phong_status_dates ON public.hop_dong USING btree (phong_id, trang_thai, ngay_bat_dau, ngay_ket_thuc);


--
-- Name: idx_khach_thue_chu_tro; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_khach_thue_chu_tro ON public.khach_thue USING btree (chu_tro_id);


--
-- Name: idx_khach_thue_sdt; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_khach_thue_sdt ON public.khach_thue USING btree (so_dien_thoai);


--
-- Name: idx_lich_hen_phong_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lich_hen_phong_time ON public.lich_hen USING btree (phong_id, ngay_hen);


--
-- Name: idx_lich_su_phuong_tien_billable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lich_su_phuong_tien_billable ON public.lich_su_phuong_tien USING btree (phong_id, hieu_luc_tu, hieu_luc_den);


--
-- Name: idx_lich_thanh_toan_han; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lich_thanh_toan_han ON public.lich_thanh_toan USING btree (han_thanh_toan, trang_thai) WHERE (xoa_luc IS NULL);


--
-- Name: idx_lich_thanh_toan_hop_dong; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lich_thanh_toan_hop_dong ON public.lich_thanh_toan USING btree (hop_dong_id, ky_nam, ky_thang) WHERE (xoa_luc IS NULL);


--
-- Name: idx_login_history_user_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_login_history_user_time ON public.login_history USING btree (nguoi_dung_id, tao_luc DESC);


--
-- Name: idx_ndnt_nha_tro_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ndnt_nha_tro_user ON public.nguoi_dung_nha_tro USING btree (nha_tro_id, nguoi_dung_id);


--
-- Name: idx_nguoi_dung_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nguoi_dung_email ON public.nguoi_dung USING btree (email);


--
-- Name: idx_nguoi_dung_trang_thai; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nguoi_dung_trang_thai ON public.nguoi_dung USING btree (trang_thai);


--
-- Name: idx_nha_tro_chu_tro; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nha_tro_chu_tro ON public.nha_tro USING btree (chu_tro_id);


--
-- Name: idx_nha_tro_location_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nha_tro_location_active ON public.nha_tro USING btree (vi_do, kinh_do) WHERE ((xoa_luc IS NULL) AND (vi_do IS NOT NULL) AND (kinh_do IS NOT NULL));


--
-- Name: idx_notification_delivery_aggregate; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notification_delivery_aggregate ON public.notification_delivery USING btree (aggregate_type, aggregate_id, scheduled_for DESC);


--
-- Name: idx_phong_nha_tro; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_phong_nha_tro ON public.phong USING btree (nha_tro_id);


--
-- Name: idx_phong_nha_tro_tang; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_phong_nha_tro_tang ON public.phong USING btree (nha_tro_id, tang, ten) WHERE (xoa_luc IS NULL);


--
-- Name: idx_phong_tang_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_phong_tang_id ON public.phong USING btree (tang_id) WHERE (xoa_luc IS NULL);


--
-- Name: idx_phong_trang_thai; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_phong_trang_thai ON public.phong USING btree (trang_thai);


--
-- Name: idx_quyet_toan_tra_phong_trang_thai; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quyet_toan_tra_phong_trang_thai ON public.quyet_toan_tra_phong USING btree (trang_thai);


--
-- Name: idx_su_co_phong_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_su_co_phong_status ON public.su_co USING btree (phong_id, trang_thai);


--
-- Name: idx_tang_nha_tro_so_tang; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tang_nha_tro_so_tang ON public.tang USING btree (nha_tro_id, so_tang) WHERE (xoa_luc IS NULL);


--
-- Name: idx_thanh_toan_hoa_don; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_thanh_toan_hoa_don ON public.thanh_toan USING btree (hoa_don_id);


--
-- Name: idx_thanh_toan_ref; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_thanh_toan_ref ON public.thanh_toan USING btree (ma_tham_chieu);


--
-- Name: idx_thanh_vien_nguoi_dung; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_thanh_vien_nguoi_dung ON public.thanh_vien_cuoc_tro_chuyen USING btree (nguoi_dung_id, roi_luc);


--
-- Name: idx_thong_bao_recipient; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_thong_bao_recipient ON public.thong_bao_nguoi_nhan USING btree (nguoi_dung_id, da_doc);


--
-- Name: idx_tin_nhan_co_lien_ket; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tin_nhan_co_lien_ket ON public.tin_nhan USING btree (cuoc_tro_chuyen_id, so_thu_tu DESC) WHERE ((noi_dung IS NOT NULL) AND (xoa_luc IS NULL) AND (da_thu_hoi = false));


--
-- Name: idx_tin_nhan_dinh_kem; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tin_nhan_dinh_kem ON public.tin_nhan USING btree (cuoc_tro_chuyen_id, so_thu_tu DESC) WHERE ((file_media_id IS NOT NULL) AND (xoa_luc IS NULL) AND (da_thu_hoi = false));


--
-- Name: idx_tin_nhan_ghim; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tin_nhan_ghim ON public.tin_nhan USING btree (cuoc_tro_chuyen_id, ghim_luc DESC) WHERE ((ghim_luc IS NOT NULL) AND (xoa_luc IS NULL));


--
-- Name: idx_tin_nhan_hoi_thoai_seq; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tin_nhan_hoi_thoai_seq ON public.tin_nhan USING btree (cuoc_tro_chuyen_id, so_thu_tu DESC);


--
-- Name: idx_tin_nhan_noi_dung_trgm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tin_nhan_noi_dung_trgm ON public.tin_nhan USING gin (public.f_khong_dau(noi_dung) public.gin_trgm_ops) WHERE ((xoa_luc IS NULL) AND (da_thu_hoi = false) AND (noi_dung IS NOT NULL));


--
-- Name: idx_tvhd_hop_dong; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tvhd_hop_dong ON public.thanh_vien_hop_dong USING btree (hop_dong_id);


--
-- Name: uq_debt_reminder_delivery; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_debt_reminder_delivery ON public.debt_reminder_log USING btree (hoa_don_id, reminder_type, channel, COALESCE(recipient_contact, ''::character varying));


--
-- Name: uq_giao_dich_tien_coc_quyet_toan_loai; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_giao_dich_tien_coc_quyet_toan_loai ON public.giao_dich_tien_coc USING btree (quyet_toan_tra_phong_id, loai) WHERE (quyet_toan_tra_phong_id IS NOT NULL);


--
-- Name: uq_tin_nhan_ma_client; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_tin_nhan_ma_client ON public.tin_nhan USING btree (cuoc_tro_chuyen_id, ma_client) WHERE (ma_client IS NOT NULL);


--
-- Name: cau_hinh_gia trg_cau_hinh_gia_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_cau_hinh_gia_cap_nhat BEFORE UPDATE ON public.cau_hinh_gia FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: chi_so_dien_nuoc trg_chi_so_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_chi_so_cap_nhat BEFORE UPDATE ON public.chi_so_dien_nuoc FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: chu_tro trg_chu_tro_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_chu_tro_cap_nhat BEFORE UPDATE ON public.chu_tro FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: chi_tiet_hoa_don trg_cthd_recalc; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_cthd_recalc AFTER INSERT OR DELETE OR UPDATE ON public.chi_tiet_hoa_don FOR EACH ROW EXECUTE FUNCTION public.recalc_hoa_don_from_chi_tiet();


--
-- Name: dich_vu trg_dich_vu_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_dich_vu_cap_nhat BEFORE UPDATE ON public.dich_vu FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: hoa_don trg_hoa_don_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_hoa_don_cap_nhat BEFORE UPDATE ON public.hoa_don FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: hoa_don trg_hoa_don_status; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_hoa_don_status BEFORE INSERT OR UPDATE OF tong_tien, da_tra, han_tra, trang_thai ON public.hoa_don FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_trang_thai_hoa_don();


--
-- Name: hop_dong trg_hop_dong_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_hop_dong_cap_nhat BEFORE UPDATE ON public.hop_dong FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: khach_thue trg_khach_thue_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_khach_thue_cap_nhat BEFORE UPDATE ON public.khach_thue FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: lich_hen trg_lich_hen_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_lich_hen_cap_nhat BEFORE UPDATE ON public.lich_hen FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: nguoi_dung trg_nguoi_dung_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_nguoi_dung_cap_nhat BEFORE UPDATE ON public.nguoi_dung FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: nha_tro trg_nha_tro_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_nha_tro_cap_nhat BEFORE UPDATE ON public.nha_tro FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: phong trg_phong_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_phong_cap_nhat BEFORE UPDATE ON public.phong FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: su_co trg_su_co_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_su_co_cap_nhat BEFORE UPDATE ON public.su_co FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: thanh_toan trg_thanh_toan_recalc; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_thanh_toan_recalc AFTER INSERT OR DELETE OR UPDATE ON public.thanh_toan FOR EACH ROW EXECUTE FUNCTION public.recalc_hoa_don_from_thanh_toan();


--
-- Name: thanh_vien_hop_dong trg_thanh_vien_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_thanh_vien_cap_nhat BEFORE UPDATE ON public.thanh_vien_hop_dong FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: thong_bao trg_thong_bao_cap_nhat; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_thong_bao_cap_nhat BEFORE UPDATE ON public.thong_bao FOR EACH ROW EXECUTE FUNCTION public.cap_nhat_thoi_gian();


--
-- Name: audit_log audit_log_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: bank_transaction bank_transaction_hoa_don_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_transaction
    ADD CONSTRAINT bank_transaction_hoa_don_id_fkey FOREIGN KEY (hoa_don_id) REFERENCES public.hoa_don(id) ON DELETE SET NULL;


--
-- Name: bank_transaction bank_transaction_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_transaction
    ADD CONSTRAINT bank_transaction_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE SET NULL;


--
-- Name: bao_cao_tin_nhan bao_cao_tin_nhan_cuoc_tro_chuyen_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bao_cao_tin_nhan
    ADD CONSTRAINT bao_cao_tin_nhan_cuoc_tro_chuyen_id_fkey FOREIGN KEY (cuoc_tro_chuyen_id) REFERENCES public.cuoc_tro_chuyen(id) ON DELETE CASCADE;


--
-- Name: bao_cao_tin_nhan bao_cao_tin_nhan_nguoi_bao_cao_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bao_cao_tin_nhan
    ADD CONSTRAINT bao_cao_tin_nhan_nguoi_bao_cao_id_fkey FOREIGN KEY (nguoi_bao_cao_id) REFERENCES public.nguoi_dung(id);


--
-- Name: bao_cao_tin_nhan bao_cao_tin_nhan_nguoi_xu_ly_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bao_cao_tin_nhan
    ADD CONSTRAINT bao_cao_tin_nhan_nguoi_xu_ly_id_fkey FOREIGN KEY (nguoi_xu_ly_id) REFERENCES public.nguoi_dung(id);


--
-- Name: bao_cao_tin_nhan bao_cao_tin_nhan_tin_nhan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bao_cao_tin_nhan
    ADD CONSTRAINT bao_cao_tin_nhan_tin_nhan_id_fkey FOREIGN KEY (tin_nhan_id) REFERENCES public.tin_nhan(id) ON DELETE CASCADE;


--
-- Name: cau_hinh_gia cau_hinh_gia_dich_vu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cau_hinh_gia
    ADD CONSTRAINT cau_hinh_gia_dich_vu_id_fkey FOREIGN KEY (dich_vu_id) REFERENCES public.dich_vu(id) ON DELETE SET NULL;


--
-- Name: cau_hinh_gia cau_hinh_gia_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cau_hinh_gia
    ADD CONSTRAINT cau_hinh_gia_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE CASCADE;


--
-- Name: cau_hinh_phi_xe cau_hinh_phi_xe_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cau_hinh_phi_xe
    ADD CONSTRAINT cau_hinh_phi_xe_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE CASCADE;


--
-- Name: chan_nguoi_dung chan_nguoi_dung_nguoi_bi_chan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chan_nguoi_dung
    ADD CONSTRAINT chan_nguoi_dung_nguoi_bi_chan_id_fkey FOREIGN KEY (nguoi_bi_chan_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: chan_nguoi_dung chan_nguoi_dung_nguoi_chan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chan_nguoi_dung
    ADD CONSTRAINT chan_nguoi_dung_nguoi_chan_id_fkey FOREIGN KEY (nguoi_chan_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: chi_so_dien_nuoc chi_so_dien_nuoc_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_so_dien_nuoc
    ADD CONSTRAINT chi_so_dien_nuoc_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE SET NULL;


--
-- Name: chi_so_dien_nuoc chi_so_dien_nuoc_nguoi_ghi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_so_dien_nuoc
    ADD CONSTRAINT chi_so_dien_nuoc_nguoi_ghi_id_fkey FOREIGN KEY (nguoi_ghi_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: chi_so_dien_nuoc chi_so_dien_nuoc_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_so_dien_nuoc
    ADD CONSTRAINT chi_so_dien_nuoc_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE CASCADE;


--
-- Name: chi_tiet_ban_giao_tai_san chi_tiet_ban_giao_tai_san_quyet_toan_tra_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_tiet_ban_giao_tai_san
    ADD CONSTRAINT chi_tiet_ban_giao_tai_san_quyet_toan_tra_phong_id_fkey FOREIGN KEY (quyet_toan_tra_phong_id) REFERENCES public.quyet_toan_tra_phong(id) ON DELETE CASCADE;


--
-- Name: chi_tiet_ban_giao_tai_san chi_tiet_ban_giao_tai_san_tai_san_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_tiet_ban_giao_tai_san
    ADD CONSTRAINT chi_tiet_ban_giao_tai_san_tai_san_phong_id_fkey FOREIGN KEY (tai_san_phong_id) REFERENCES public.tai_san_phong(id) ON DELETE SET NULL;


--
-- Name: chi_tiet_hoa_don chi_tiet_hoa_don_chi_so_dien_nuoc_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_tiet_hoa_don
    ADD CONSTRAINT chi_tiet_hoa_don_chi_so_dien_nuoc_id_fkey FOREIGN KEY (chi_so_dien_nuoc_id) REFERENCES public.chi_so_dien_nuoc(id) ON DELETE SET NULL;


--
-- Name: chi_tiet_hoa_don chi_tiet_hoa_don_dich_vu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_tiet_hoa_don
    ADD CONSTRAINT chi_tiet_hoa_don_dich_vu_id_fkey FOREIGN KEY (dich_vu_id) REFERENCES public.dich_vu(id) ON DELETE SET NULL;


--
-- Name: chi_tiet_hoa_don chi_tiet_hoa_don_hoa_don_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_tiet_hoa_don
    ADD CONSTRAINT chi_tiet_hoa_don_hoa_don_id_fkey FOREIGN KEY (hoa_don_id) REFERENCES public.hoa_don(id) ON DELETE CASCADE;


--
-- Name: cuoc_tro_chuyen cuoc_tro_chuyen_nguoi_tao_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuoc_tro_chuyen
    ADD CONSTRAINT cuoc_tro_chuyen_nguoi_tao_id_fkey FOREIGN KEY (nguoi_tao_id) REFERENCES public.nguoi_dung(id);


--
-- Name: cuoc_tro_chuyen cuoc_tro_chuyen_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuoc_tro_chuyen
    ADD CONSTRAINT cuoc_tro_chuyen_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id);


--
-- Name: cuoc_tro_chuyen cuoc_tro_chuyen_tang_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cuoc_tro_chuyen
    ADD CONSTRAINT cuoc_tro_chuyen_tang_id_fkey FOREIGN KEY (tang_id) REFERENCES public.tang(id);


--
-- Name: dang_ky_push dang_ky_push_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dang_ky_push
    ADD CONSTRAINT dang_ky_push_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: dat_coc_phong dat_coc_phong_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dat_coc_phong
    ADD CONSTRAINT dat_coc_phong_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE SET NULL;


--
-- Name: dat_coc_phong dat_coc_phong_khach_thue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dat_coc_phong
    ADD CONSTRAINT dat_coc_phong_khach_thue_id_fkey FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id) ON DELETE RESTRICT;


--
-- Name: dat_coc_phong dat_coc_phong_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dat_coc_phong
    ADD CONSTRAINT dat_coc_phong_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE RESTRICT;


--
-- Name: dich_vu dich_vu_chu_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dich_vu
    ADD CONSTRAINT dich_vu_chu_tro_id_fkey FOREIGN KEY (chu_tro_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: dich_vu_hop_dong dich_vu_hop_dong_dich_vu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dich_vu_hop_dong
    ADD CONSTRAINT dich_vu_hop_dong_dich_vu_id_fkey FOREIGN KEY (dich_vu_id) REFERENCES public.dich_vu(id) ON DELETE RESTRICT;


--
-- Name: dich_vu_hop_dong dich_vu_hop_dong_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dich_vu_hop_dong
    ADD CONSTRAINT dich_vu_hop_dong_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE CASCADE;


--
-- Name: email_verification_token email_verification_token_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_verification_token
    ADD CONSTRAINT email_verification_token_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: file_media file_media_nguoi_tai_len_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_media
    ADD CONSTRAINT file_media_nguoi_tai_len_id_fkey FOREIGN KEY (nguoi_tai_len_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: meter_anomaly_alert fk_anomaly_chi_so; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meter_anomaly_alert
    ADD CONSTRAINT fk_anomaly_chi_so FOREIGN KEY (chi_so_id) REFERENCES public.chi_so_dien_nuoc(id) ON DELETE CASCADE;


--
-- Name: meter_anomaly_alert fk_anomaly_hop_dong; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meter_anomaly_alert
    ADD CONSTRAINT fk_anomaly_hop_dong FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE SET NULL;


--
-- Name: meter_anomaly_alert fk_anomaly_phong; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meter_anomaly_alert
    ADD CONSTRAINT fk_anomaly_phong FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE CASCADE;


--
-- Name: meter_anomaly_alert fk_anomaly_resolved_by; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meter_anomaly_alert
    ADD CONSTRAINT fk_anomaly_resolved_by FOREIGN KEY (resolved_by) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: chi_tiet_hoa_don fk_cthd_su_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chi_tiet_hoa_don
    ADD CONSTRAINT fk_cthd_su_co FOREIGN KEY (su_co_id) REFERENCES public.su_co(id) ON DELETE SET NULL;


--
-- Name: dat_coc_phong fk_dat_coc_hop_dong; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dat_coc_phong
    ADD CONSTRAINT fk_dat_coc_hop_dong FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE SET NULL;


--
-- Name: dat_coc_phong fk_dat_coc_nguoi_xac_nhan; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dat_coc_phong
    ADD CONSTRAINT fk_dat_coc_nguoi_xac_nhan FOREIGN KEY (nguoi_xac_nhan_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: invoice_generation_batch fk_invoice_batch_nguoi_tao; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_generation_batch
    ADD CONSTRAINT fk_invoice_batch_nguoi_tao FOREIGN KEY (nguoi_tao_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: invoice_generation_batch fk_invoice_batch_nha_tro; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_generation_batch
    ADD CONSTRAINT fk_invoice_batch_nha_tro FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE SET NULL;


--
-- Name: invoice_generation_log fk_invoice_log_batch; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_generation_log
    ADD CONSTRAINT fk_invoice_log_batch FOREIGN KEY (batch_id) REFERENCES public.invoice_generation_batch(id) ON DELETE CASCADE;


--
-- Name: invoice_generation_log fk_invoice_log_hoa_don; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_generation_log
    ADD CONSTRAINT fk_invoice_log_hoa_don FOREIGN KEY (hoa_don_id) REFERENCES public.hoa_don(id) ON DELETE SET NULL;


--
-- Name: invoice_generation_log fk_invoice_log_hop_dong; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_generation_log
    ADD CONSTRAINT fk_invoice_log_hop_dong FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE SET NULL;


--
-- Name: tin_nhan fk_tin_nhan_chuyen_tiep_tu; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan
    ADD CONSTRAINT fk_tin_nhan_chuyen_tiep_tu FOREIGN KEY (chuyen_tiep_tu_id) REFERENCES public.tin_nhan(id) ON DELETE SET NULL;


--
-- Name: tin_nhan fk_tin_nhan_nguoi_ghim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan
    ADD CONSTRAINT fk_tin_nhan_nguoi_ghim FOREIGN KEY (nguoi_ghim_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: yeu_cau_o_ghep fk_ycog_hop_dong; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.yeu_cau_o_ghep
    ADD CONSTRAINT fk_ycog_hop_dong FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id);


--
-- Name: yeu_cau_o_ghep fk_ycog_khach_thue; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.yeu_cau_o_ghep
    ADD CONSTRAINT fk_ycog_khach_thue FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id);


--
-- Name: giao_dich_tien_coc giao_dich_tien_coc_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.giao_dich_tien_coc
    ADD CONSTRAINT giao_dich_tien_coc_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE RESTRICT;


--
-- Name: giao_dich_tien_coc giao_dich_tien_coc_quyet_toan_tra_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.giao_dich_tien_coc
    ADD CONSTRAINT giao_dich_tien_coc_quyet_toan_tra_phong_id_fkey FOREIGN KEY (quyet_toan_tra_phong_id) REFERENCES public.quyet_toan_tra_phong(id) ON DELETE RESTRICT;


--
-- Name: giao_dich_tien_coc giao_dich_tien_coc_thanh_toan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.giao_dich_tien_coc
    ADD CONSTRAINT giao_dich_tien_coc_thanh_toan_id_fkey FOREIGN KEY (thanh_toan_id) REFERENCES public.thanh_toan(id) ON DELETE RESTRICT;


--
-- Name: hoa_don hoa_don_hoa_don_goc_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hoa_don
    ADD CONSTRAINT hoa_don_hoa_don_goc_id_fkey FOREIGN KEY (hoa_don_goc_id) REFERENCES public.hoa_don(id) ON DELETE RESTRICT;


--
-- Name: hoa_don hoa_don_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hoa_don
    ADD CONSTRAINT hoa_don_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE RESTRICT;


--
-- Name: hoa_don hoa_don_khach_thue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hoa_don
    ADD CONSTRAINT hoa_don_khach_thue_id_fkey FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id) ON DELETE RESTRICT;


--
-- Name: hoa_don hoa_don_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hoa_don
    ADD CONSTRAINT hoa_don_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE RESTRICT;


--
-- Name: hop_dong hop_dong_khach_thue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hop_dong
    ADD CONSTRAINT hop_dong_khach_thue_id_fkey FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id) ON DELETE RESTRICT;


--
-- Name: hop_dong hop_dong_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hop_dong
    ADD CONSTRAINT hop_dong_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE RESTRICT;


--
-- Name: khach_thue khach_thue_chu_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.khach_thue
    ADD CONSTRAINT khach_thue_chu_tro_id_fkey FOREIGN KEY (chu_tro_id) REFERENCES public.nguoi_dung(id) ON DELETE RESTRICT;


--
-- Name: khach_thue khach_thue_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.khach_thue
    ADD CONSTRAINT khach_thue_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: kho_tai_san kho_tai_san_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kho_tai_san
    ADD CONSTRAINT kho_tai_san_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id);


--
-- Name: lich_hen lich_hen_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_hen
    ADD CONSTRAINT lich_hen_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: lich_hen lich_hen_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_hen
    ADD CONSTRAINT lich_hen_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE CASCADE;


--
-- Name: lich_su_hoa_don lich_su_hoa_don_hoa_don_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_hoa_don
    ADD CONSTRAINT lich_su_hoa_don_hoa_don_id_fkey FOREIGN KEY (hoa_don_id) REFERENCES public.hoa_don(id) ON DELETE CASCADE;


--
-- Name: lich_su_hoa_don lich_su_hoa_don_nguoi_thay_doi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_hoa_don
    ADD CONSTRAINT lich_su_hoa_don_nguoi_thay_doi_id_fkey FOREIGN KEY (nguoi_thay_doi_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: lich_su_kho_tai_san lich_su_kho_tai_san_kho_tai_san_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_kho_tai_san
    ADD CONSTRAINT lich_su_kho_tai_san_kho_tai_san_id_fkey FOREIGN KEY (kho_tai_san_id) REFERENCES public.kho_tai_san(id);


--
-- Name: lich_su_kho_tai_san lich_su_kho_tai_san_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_kho_tai_san
    ADD CONSTRAINT lich_su_kho_tai_san_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id);


--
-- Name: lich_su_phuong_tien lich_su_phuong_tien_khach_thue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_phuong_tien
    ADD CONSTRAINT lich_su_phuong_tien_khach_thue_id_fkey FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id) ON DELETE RESTRICT;


--
-- Name: lich_su_phuong_tien lich_su_phuong_tien_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_phuong_tien
    ADD CONSTRAINT lich_su_phuong_tien_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE RESTRICT;


--
-- Name: lich_su_phuong_tien lich_su_phuong_tien_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_phuong_tien
    ADD CONSTRAINT lich_su_phuong_tien_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE RESTRICT;


--
-- Name: lich_su_phuong_tien lich_su_phuong_tien_phuong_tien_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_su_phuong_tien
    ADD CONSTRAINT lich_su_phuong_tien_phuong_tien_id_fkey FOREIGN KEY (phuong_tien_id) REFERENCES public.phuong_tien(id) ON DELETE RESTRICT;


--
-- Name: lich_thanh_toan lich_thanh_toan_hoa_don_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_thanh_toan
    ADD CONSTRAINT lich_thanh_toan_hoa_don_id_fkey FOREIGN KEY (hoa_don_id) REFERENCES public.hoa_don(id) ON DELETE SET NULL;


--
-- Name: lich_thanh_toan lich_thanh_toan_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lich_thanh_toan
    ADD CONSTRAINT lich_thanh_toan_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE CASCADE;


--
-- Name: login_history login_history_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: nguoi_dung_nha_tro nguoi_dung_nha_tro_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung_nha_tro
    ADD CONSTRAINT nguoi_dung_nha_tro_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: nguoi_dung_nha_tro nguoi_dung_nha_tro_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung_nha_tro
    ADD CONSTRAINT nguoi_dung_nha_tro_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE CASCADE;


--
-- Name: nguoi_dung_vai_tro nguoi_dung_vai_tro_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung_vai_tro
    ADD CONSTRAINT nguoi_dung_vai_tro_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: nguoi_dung_vai_tro nguoi_dung_vai_tro_vai_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nguoi_dung_vai_tro
    ADD CONSTRAINT nguoi_dung_vai_tro_vai_tro_id_fkey FOREIGN KEY (vai_tro_id) REFERENCES public.vai_tro(id) ON DELETE CASCADE;


--
-- Name: nha_tro nha_tro_chu_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nha_tro
    ADD CONSTRAINT nha_tro_chu_tro_id_fkey FOREIGN KEY (chu_tro_id) REFERENCES public.nguoi_dung(id) ON DELETE RESTRICT;


--
-- Name: phong phong_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phong
    ADD CONSTRAINT phong_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE CASCADE;


--
-- Name: phong phong_nha_tro_id_tang_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phong
    ADD CONSTRAINT phong_nha_tro_id_tang_id_fkey FOREIGN KEY (nha_tro_id, tang_id) REFERENCES public.tang(nha_tro_id, id) ON DELETE RESTRICT;


--
-- Name: phong phong_tang_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phong
    ADD CONSTRAINT phong_tang_id_fkey FOREIGN KEY (tang_id) REFERENCES public.tang(id) ON DELETE SET NULL;


--
-- Name: phong_tien_ich phong_tien_ich_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phong_tien_ich
    ADD CONSTRAINT phong_tien_ich_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE CASCADE;


--
-- Name: phong_tien_ich phong_tien_ich_tien_ich_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phong_tien_ich
    ADD CONSTRAINT phong_tien_ich_tien_ich_id_fkey FOREIGN KEY (tien_ich_id) REFERENCES public.tien_ich(id) ON DELETE CASCADE;


--
-- Name: phu_luc_hop_dong phu_luc_hop_dong_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phu_luc_hop_dong
    ADD CONSTRAINT phu_luc_hop_dong_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE CASCADE;


--
-- Name: phu_luc_hop_dong phu_luc_hop_dong_nguoi_tao_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phu_luc_hop_dong
    ADD CONSTRAINT phu_luc_hop_dong_nguoi_tao_id_fkey FOREIGN KEY (nguoi_tao_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: phuong_tien phuong_tien_chu_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phuong_tien
    ADD CONSTRAINT phuong_tien_chu_tro_id_fkey FOREIGN KEY (chu_tro_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: phuong_tien phuong_tien_khach_thue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phuong_tien
    ADD CONSTRAINT phuong_tien_khach_thue_id_fkey FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id) ON DELETE SET NULL;


--
-- Name: phuong_tien phuong_tien_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phuong_tien
    ADD CONSTRAINT phuong_tien_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE CASCADE;


--
-- Name: phuong_tien phuong_tien_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phuong_tien
    ADD CONSTRAINT phuong_tien_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE SET NULL;


--
-- Name: quyet_toan_tra_phong quyet_toan_tra_phong_hoa_don_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quyet_toan_tra_phong
    ADD CONSTRAINT quyet_toan_tra_phong_hoa_don_id_fkey FOREIGN KEY (hoa_don_id) REFERENCES public.hoa_don(id);


--
-- Name: quyet_toan_tra_phong quyet_toan_tra_phong_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quyet_toan_tra_phong
    ADD CONSTRAINT quyet_toan_tra_phong_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id);


--
-- Name: refresh_token refresh_token_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_token
    ADD CONSTRAINT refresh_token_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: su_co su_co_khach_thue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.su_co
    ADD CONSTRAINT su_co_khach_thue_id_fkey FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id) ON DELETE SET NULL;


--
-- Name: su_co su_co_nguoi_bao_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.su_co
    ADD CONSTRAINT su_co_nguoi_bao_id_fkey FOREIGN KEY (nguoi_bao_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: su_co su_co_nguoi_phu_trach_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.su_co
    ADD CONSTRAINT su_co_nguoi_phu_trach_id_fkey FOREIGN KEY (nguoi_phu_trach_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: su_co su_co_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.su_co
    ADD CONSTRAINT su_co_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id) ON DELETE CASCADE;


--
-- Name: tai_san_phong tai_san_phong_kho_tai_san_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tai_san_phong
    ADD CONSTRAINT tai_san_phong_kho_tai_san_id_fkey FOREIGN KEY (kho_tai_san_id) REFERENCES public.kho_tai_san(id);


--
-- Name: tai_san_phong tai_san_phong_phong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tai_san_phong
    ADD CONSTRAINT tai_san_phong_phong_id_fkey FOREIGN KEY (phong_id) REFERENCES public.phong(id);


--
-- Name: tang tang_nha_tro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tang
    ADD CONSTRAINT tang_nha_tro_id_fkey FOREIGN KEY (nha_tro_id) REFERENCES public.nha_tro(id) ON DELETE CASCADE;


--
-- Name: thanh_toan thanh_toan_hoa_don_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_toan
    ADD CONSTRAINT thanh_toan_hoa_don_id_fkey FOREIGN KEY (hoa_don_id) REFERENCES public.hoa_don(id) ON DELETE RESTRICT;


--
-- Name: thanh_toan thanh_toan_khach_thue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_toan
    ADD CONSTRAINT thanh_toan_khach_thue_id_fkey FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id) ON DELETE SET NULL;


--
-- Name: thanh_toan thanh_toan_nguoi_ghi_nhan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_toan
    ADD CONSTRAINT thanh_toan_nguoi_ghi_nhan_id_fkey FOREIGN KEY (nguoi_ghi_nhan_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: thanh_toan thanh_toan_nguoi_thanh_toan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_toan
    ADD CONSTRAINT thanh_toan_nguoi_thanh_toan_id_fkey FOREIGN KEY (nguoi_thanh_toan_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: thanh_vien_cuoc_tro_chuyen thanh_vien_cuoc_tro_chuyen_cuoc_tro_chuyen_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_vien_cuoc_tro_chuyen
    ADD CONSTRAINT thanh_vien_cuoc_tro_chuyen_cuoc_tro_chuyen_id_fkey FOREIGN KEY (cuoc_tro_chuyen_id) REFERENCES public.cuoc_tro_chuyen(id) ON DELETE CASCADE;


--
-- Name: thanh_vien_cuoc_tro_chuyen thanh_vien_cuoc_tro_chuyen_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_vien_cuoc_tro_chuyen
    ADD CONSTRAINT thanh_vien_cuoc_tro_chuyen_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id);


--
-- Name: thanh_vien_hop_dong thanh_vien_hop_dong_hop_dong_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_vien_hop_dong
    ADD CONSTRAINT thanh_vien_hop_dong_hop_dong_id_fkey FOREIGN KEY (hop_dong_id) REFERENCES public.hop_dong(id) ON DELETE CASCADE;


--
-- Name: thanh_vien_hop_dong thanh_vien_hop_dong_khach_thue_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thanh_vien_hop_dong
    ADD CONSTRAINT thanh_vien_hop_dong_khach_thue_id_fkey FOREIGN KEY (khach_thue_id) REFERENCES public.khach_thue(id) ON DELETE SET NULL;


--
-- Name: thong_bao thong_bao_nguoi_gui_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thong_bao
    ADD CONSTRAINT thong_bao_nguoi_gui_id_fkey FOREIGN KEY (nguoi_gui_id) REFERENCES public.nguoi_dung(id) ON DELETE SET NULL;


--
-- Name: thong_bao_nguoi_nhan thong_bao_nguoi_nhan_nguoi_dung_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thong_bao_nguoi_nhan
    ADD CONSTRAINT thong_bao_nguoi_nhan_nguoi_dung_id_fkey FOREIGN KEY (nguoi_dung_id) REFERENCES public.nguoi_dung(id) ON DELETE CASCADE;


--
-- Name: thong_bao_nguoi_nhan thong_bao_nguoi_nhan_thong_bao_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.thong_bao_nguoi_nhan
    ADD CONSTRAINT thong_bao_nguoi_nhan_thong_bao_id_fkey FOREIGN KEY (thong_bao_id) REFERENCES public.thong_bao(id) ON DELETE CASCADE;


--
-- Name: tin_nhan tin_nhan_cuoc_tro_chuyen_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan
    ADD CONSTRAINT tin_nhan_cuoc_tro_chuyen_id_fkey FOREIGN KEY (cuoc_tro_chuyen_id) REFERENCES public.cuoc_tro_chuyen(id) ON DELETE CASCADE;


--
-- Name: tin_nhan tin_nhan_file_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan
    ADD CONSTRAINT tin_nhan_file_media_id_fkey FOREIGN KEY (file_media_id) REFERENCES public.file_media(id);


--
-- Name: tin_nhan tin_nhan_nguoi_gui_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan
    ADD CONSTRAINT tin_nhan_nguoi_gui_id_fkey FOREIGN KEY (nguoi_gui_id) REFERENCES public.nguoi_dung(id);


--
-- Name: tin_nhan tin_nhan_tra_loi_cho_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tin_nhan
    ADD CONSTRAINT tin_nhan_tra_loi_cho_id_fkey FOREIGN KEY (tra_loi_cho_id) REFERENCES public.tin_nhan(id);


--
-- Name: audit_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

--
-- Name: bank_transaction; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.bank_transaction ENABLE ROW LEVEL SECURITY;

--
-- Name: cau_hinh_gia; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.cau_hinh_gia ENABLE ROW LEVEL SECURITY;

--
-- Name: chi_so_dien_nuoc; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.chi_so_dien_nuoc ENABLE ROW LEVEL SECURITY;

--
-- Name: chi_tiet_hoa_don; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.chi_tiet_hoa_don ENABLE ROW LEVEL SECURITY;

--
-- Name: chu_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.chu_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: contract_signature; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.contract_signature ENABLE ROW LEVEL SECURITY;

--
-- Name: dat_coc_phong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.dat_coc_phong ENABLE ROW LEVEL SECURITY;

--
-- Name: debt_reminder_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.debt_reminder_log ENABLE ROW LEVEL SECURITY;

--
-- Name: dich_vu; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.dich_vu ENABLE ROW LEVEL SECURITY;

--
-- Name: dich_vu_hop_dong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.dich_vu_hop_dong ENABLE ROW LEVEL SECURITY;

--
-- Name: email_verification_token; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.email_verification_token ENABLE ROW LEVEL SECURITY;

--
-- Name: file_media; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.file_media ENABLE ROW LEVEL SECURITY;

--
-- Name: hoa_don; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hoa_don ENABLE ROW LEVEL SECURITY;

--
-- Name: hop_dong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hop_dong ENABLE ROW LEVEL SECURITY;

--
-- Name: invoice_generation_batch; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.invoice_generation_batch ENABLE ROW LEVEL SECURITY;

--
-- Name: invoice_generation_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.invoice_generation_log ENABLE ROW LEVEL SECURITY;

--
-- Name: khach_thue; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.khach_thue ENABLE ROW LEVEL SECURITY;

--
-- Name: lich_hen; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lich_hen ENABLE ROW LEVEL SECURITY;

--
-- Name: lich_su_hoa_don; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lich_su_hoa_don ENABLE ROW LEVEL SECURITY;

--
-- Name: lich_thanh_toan; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lich_thanh_toan ENABLE ROW LEVEL SECURITY;

--
-- Name: login_history; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.login_history ENABLE ROW LEVEL SECURITY;

--
-- Name: meter_anomaly_alert; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.meter_anomaly_alert ENABLE ROW LEVEL SECURITY;

--
-- Name: nguoi_dung; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nguoi_dung ENABLE ROW LEVEL SECURITY;

--
-- Name: nguoi_dung_nha_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nguoi_dung_nha_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: nguoi_dung_vai_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nguoi_dung_vai_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: nha_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nha_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: phong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.phong ENABLE ROW LEVEL SECURITY;

--
-- Name: phong_tien_ich; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.phong_tien_ich ENABLE ROW LEVEL SECURITY;

--
-- Name: phu_luc_hop_dong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.phu_luc_hop_dong ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_token; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.refresh_token ENABLE ROW LEVEL SECURITY;

--
-- Name: su_co; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.su_co ENABLE ROW LEVEL SECURITY;

--
-- Name: tang; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tang ENABLE ROW LEVEL SECURITY;

--
-- Name: thanh_toan; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.thanh_toan ENABLE ROW LEVEL SECURITY;

--
-- Name: thanh_vien_hop_dong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.thanh_vien_hop_dong ENABLE ROW LEVEL SECURITY;

--
-- Name: thong_bao; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.thong_bao ENABLE ROW LEVEL SECURITY;

--
-- Name: thong_bao_nguoi_nhan; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.thong_bao_nguoi_nhan ENABLE ROW LEVEL SECURITY;

--
-- Name: tien_ich; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tien_ich ENABLE ROW LEVEL SECURITY;

--
-- Name: vai_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.vai_tro ENABLE ROW LEVEL SECURITY;

--
-- PostgreSQL database dump complete
--

\unrestrict O6WaZLv2mrxYc1Q9KPy4H7VPIZL9dMmSim1SDfF2BXcfYGWekHoAaqgZrbLg7YL

