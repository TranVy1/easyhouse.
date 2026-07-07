CREATE EXTENSION IF NOT EXISTS btree_gist;
--
-- PostgreSQL database dump
--

\restrict JuHwC982OhoIf53DWohsSxkw2o3DODn6k3AgyA3T0CaVu22OepQiP6Uqn2fTR8b

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--




--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


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
-- Name: phuong_thuc_thanh_toan; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.phuong_thuc_thanh_toan AS ENUM (
    'CASH',
    'BANK_TRANSFER',
    'VIETQR',
    'MOMO',
    'ZALOPAY',
    'OTHER',
    'VNPAY'
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
        SET
            so_phong_du_kien = EXCLUDED.so_phong_du_kien,
            cap_nhat_luc = now()
        RETURNING id INTO v_tang_id;

        v_tang_count := v_tang_count + 1;

        FOR v_phong IN 1..p_so_phong_moi_tang LOOP
            v_ma_phong := 'Ph??ng ' || (v_tang * 100 + v_phong)::text;

            INSERT INTO public.phong (
                nha_tro_id,
                tang_id,
                ten,
                tang,
                dien_tich,
                so_nguoi_toi_da,
                trang_thai,
                gia_hien_tai,
                tien_coc_mac_dinh
            )
            VALUES (
                p_nha_tro_id,
                v_tang_id,
                v_ma_phong,
                v_tang,
                p_dien_tich,
                p_so_nguoi_toi_da,
                'AVAILABLE'::public.trang_thai_phong,
                p_gia_hien_tai,
                p_tien_coc_mac_dinh
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
        
        -- Fix: N???u h???n thanh to??n trong th??ng ?????u b??? r??i v??o tr?????c ng??y b???t ?????u, d???i sang t???_ng??y
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
    CONSTRAINT debt_reminder_log_reminder_type_check CHECK (((reminder_type)::text = ANY (ARRAY[('DUE_IN_3_DAYS'::character varying)::text, ('DUE_TOMORROW'::character varying)::text, ('OVERDUE_1_DAY'::character varying)::text, ('OVERDUE_7_DAYS'::character varying)::text, ('OVERDUE_15_DAYS'::character varying)::text, ('OVERDUE_30_DAYS'::character varying)::text, ('MANUAL'::character varying)::text])))
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
    xoa_luc timestamp with time zone
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
-- Name: refresh_token; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refresh_token (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nguoi_dung_id uuid NOT NULL,
    token character varying(255) NOT NULL,
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
    cap_nhat_luc timestamp with time zone
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
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.audit_log (id, nguoi_dung_id, hanh_dong, bang_tac_dong, ban_ghi_id, du_lieu_cu, du_lieu_moi, ip_address, user_agent, tao_luc) FROM stdin;
12040d18-d9d3-4861-84e1-740c27f789c2	dddfb501-3d25-4517-ac58-1b9225e85cb3	REGISTER	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-06-17 23:32:07.19786+00
1915c4e9-6599-4547-8e7a-d9fc73140f2f	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-06-17 23:32:25.720641+00
ab1a2f84-9930-40be-ab37-d6935a19f9b8	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	cau_hinh_gia	2b8eba5e-b002-441f-aca3-951151f5b7a5	\N	\N	\N	\N	2026-06-18 00:10:29.743476+00
ae4d0810-0535-4d11-8ce4-5f2363d499f7	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	cau_hinh_gia	57c69923-f3a6-48d4-a2f1-fcfd532864ef	\N	\N	\N	\N	2026-06-18 00:10:44.291206+00
8653f156-1a00-4f9b-b8ae-1e7e64e1c842	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	cau_hinh_gia	2ea9f1c4-6fdb-4ed2-ba6a-0fdc0b520f9b	\N	\N	\N	\N	2026-06-18 00:11:07.047462+00
477fc613-fdd2-45f5-9ecc-878e889f7252	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	cau_hinh_gia	54977261-958f-415b-acc1-2c5dba2895db	\N	\N	\N	\N	2026-06-18 00:11:44.296117+00
b5e29446-1a28-4a31-a17c-12d0d43db6c3	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-06-24 02:25:00.778027+00
76ce94bf-c4ad-405e-9534-81e10de851c2	dddfb501-3d25-4517-ac58-1b9225e85cb3	CONFIRM	hop_dong	5f6b7466-f3f0-4a53-bd5c-072712c119de	\N	\N	\N	\N	2026-06-24 02:36:42.979239+00
6eb0d439-a327-4ecb-a9e5-d8854e827199	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-06-24 03:00:22.073821+00
6e2a1595-7993-4fe5-bb5e-8259b037ddfe	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-06-24 03:09:05.809123+00
b14ee156-fb6a-4ff2-a297-d7946845155e	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-06-24 03:12:07.711132+00
0a71b697-d4aa-4b23-8266-d4d3958dbcf9	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-06-24 03:15:46.279346+00
19ef3bf8-b235-4fe5-aa82-806f948c04ca	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	thanh_toan	9dede6f2-14c7-4a13-aa4e-024fdef1574f	\N	\N	\N	\N	2026-06-24 03:16:03.817125+00
c3d132b5-02bd-477b-a871-e2208754895f	dddfb501-3d25-4517-ac58-1b9225e85cb3	UPDATE	thanh_toan	9dede6f2-14c7-4a13-aa4e-024fdef1574f	\N	\N	\N	\N	2026-06-24 03:17:34.626472+00
6b099b47-bc22-4935-a7cc-216b74898f91	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-06-24 03:34:34.642808+00
15bbd569-2504-4a34-853b-851b8e4a4e49	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-06-24 03:37:09.162877+00
6c639afe-53b9-484c-9a69-29812d4473f0	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-06-24 03:38:28.031095+00
f639923d-d285-4e78-b959-6b68b0f5547e	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-06-24 03:39:32.968926+00
0e8c2a70-229c-47a1-867b-447a158b681b	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-06-24 03:48:31.966213+00
123e6d7a-72f6-41c2-af10-69e6ff35c993	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-06-24 03:50:45.604198+00
953f6233-8cd9-4ee9-bd46-c6c5cd56e3ef	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-06-24 03:50:59.08503+00
89f134f3-c7de-4d8e-b898-4fd2bd92274f	\N	SYSTEM_CREATE	thong_bao	f8cbe7b6-789b-49a7-88b1-327b40636c75	\N	\N	\N	\N	2026-06-24 03:57:08.073385+00
02bcd1c3-3de0-4652-b5b3-e5cd47df1e5e	\N	SYSTEM_CREATE	thong_bao	b1a2f698-3098-42b2-ac77-dbd3e4c22c4a	\N	\N	\N	\N	2026-06-24 04:07:52.499172+00
e0460a3e-7ec6-4ef2-9152-e2bd595fe79b	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-06-24 04:08:01.584628+00
22654d87-ed95-4549-986d-f1b223ec0f2d	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	thanh_toan	74249784-dfac-4415-99eb-ece1dcdf70e6	\N	\N	\N	\N	2026-06-24 04:14:33.170047+00
61fa3c3e-43d3-44db-85a4-6f4127c1c709	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	cau_hinh_gia	2afabe4d-6032-4c84-ab28-e40a215f7a7a	\N	\N	\N	\N	2026-06-26 17:41:16.761318+00
138e4280-12b7-4b93-956f-aac2c0536717	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	cau_hinh_gia	6e6ed583-6f4c-4d91-af29-d9c157674780	\N	\N	\N	\N	2026-06-26 17:41:42.829798+00
82a60e6a-4065-44b5-a91f-f16d64c97b46	dddfb501-3d25-4517-ac58-1b9225e85cb3	DEACTIVATE	cau_hinh_gia	6e6ed583-6f4c-4d91-af29-d9c157674780	\N	\N	\N	\N	2026-06-26 17:42:00.551576+00
54e21e82-f198-4d7b-932e-d7b3a222bd4d	dddfb501-3d25-4517-ac58-1b9225e85cb3	UPDATE_VERSION	cau_hinh_gia	953150fe-e979-4d18-bb7e-6c555f578c3d	\N	\N	\N	\N	2026-06-26 17:42:11.111171+00
cf41fe32-8dfb-423b-a023-33976019098e	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	thanh_toan	d02d53aa-6ad9-40ad-af23-4bfcdf76e1db	\N	\N	\N	\N	2026-06-26 17:43:52.17681+00
cfc24c34-9aa3-43fa-855a-20e36c519704	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	thanh_toan	7d478722-6c5e-4f23-8e95-eed61b255347	\N	\N	\N	\N	2026-06-26 17:44:13.137717+00
2d44a3ec-00c9-427b-96dd-f34464f31f73	dddfb501-3d25-4517-ac58-1b9225e85cb3	TERMINATE	hop_dong	fa05907e-eefc-49f9-a255-cce5ba87d9f0	\N	\N	\N	\N	2026-06-26 17:44:28.986395+00
0e581296-a692-4e81-979a-84cf520839fe	dddfb501-3d25-4517-ac58-1b9225e85cb3	TERMINATE	hop_dong	b486f460-d177-4d31-9a6d-0d25621bfaf6	\N	\N	\N	\N	2026-06-26 17:44:33.18793+00
3e315bc1-c230-4b0e-bf47-ce82ee1b6629	dddfb501-3d25-4517-ac58-1b9225e85cb3	TERMINATE	hop_dong	387200fe-0565-4591-bbef-71300cc7dcf5	\N	\N	\N	\N	2026-06-26 17:44:36.089363+00
42164e9a-66e3-4b64-8bdf-8e11dcb5aef6	dddfb501-3d25-4517-ac58-1b9225e85cb3	TERMINATE	hop_dong	5f6b7466-f3f0-4a53-bd5c-072712c119de	\N	\N	\N	\N	2026-06-26 17:44:38.793721+00
db18c2fe-d16d-4fbf-ae53-363c3a68ee00	dddfb501-3d25-4517-ac58-1b9225e85cb3	CONFIRM	hop_dong	f744f5b6-4a22-44ad-acf4-ad0615bff692	\N	\N	\N	\N	2026-06-26 17:48:18.583679+00
7aeed975-e2a9-4c34-9a48-52c476522977	dddfb501-3d25-4517-ac58-1b9225e85cb3	UPDATE	nguoi_dung	4deb410a-cef3-4ab5-b13f-a66ba1b5cd9b	\N	\N	\N	\N	2026-06-26 18:08:24.267997+00
5c7cd5ab-8126-47ba-a6de-358186b7446d	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-06-30 14:07:39.140572+00
89979e45-24bd-4471-85a5-1254a73987d3	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	thanh_toan	dc865f9f-061b-450f-88bd-c382a898d131	\N	\N	\N	\N	2026-07-01 19:38:09.624693+00
56877684-c3c7-4fd9-af69-e308b3350fc7	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	hoa_don	b72cc57a-ab94-48ab-afcd-8d9611b132a3	\N	\N	\N	\N	2026-07-04 10:45:21.94715+00
0dae0775-6f38-4b07-9fb9-d28a3eeb19ec	dddfb501-3d25-4517-ac58-1b9225e85cb3	SEND_EVENT	hoa_don	b72cc57a-ab94-48ab-afcd-8d9611b132a3	\N	\N	\N	\N	2026-07-04 10:45:21.951799+00
9db4fd38-234e-4214-9723-ab714012e11e	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-07-04 10:54:44.843825+00
4f6bc719-c7b3-43cf-be51-b33805887762	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-07-04 12:06:31.726401+00
7e5719f3-853e-464e-8210-a27b9d6d23a4	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	cau_hinh_gia	3106cdf4-fb4c-4370-bf32-18e77fd671c8	\N	\N	\N	\N	2026-07-04 12:14:35.87713+00
f88bcf2e-02e9-4f77-a03b-6337e01af1f5	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	cau_hinh_gia	f1ac5d83-a971-4127-9490-16e6e4a0fe44	\N	\N	\N	\N	2026-07-04 12:14:50.739176+00
568f55a3-e48a-4c3b-8c4a-2d9d9dae43f9	dddfb501-3d25-4517-ac58-1b9225e85cb3	TERMINATE	hop_dong	f744f5b6-4a22-44ad-acf4-ad0615bff692	\N	\N	\N	\N	2026-07-04 12:18:47.148077+00
976e59c2-642c-488a-8f89-377f01a75b21	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	cau_hinh_gia	b2830960-d343-43b5-844f-f82fb6049843	\N	\N	\N	\N	2026-07-04 12:27:06.035755+00
bcee66e1-5f21-4ab9-b6ce-3c2ac39302d6	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	cau_hinh_gia	45a65e5e-b3d2-44ae-8c49-87ee00e2af3a	\N	\N	\N	\N	2026-07-04 12:27:17.785811+00
0f554240-cc80-4a5c-b5fb-ddaacc0c5924	dddfb501-3d25-4517-ac58-1b9225e85cb3	CONFIRM	hop_dong	971984c0-9b21-4a99-9c49-408a87942486	\N	\N	\N	\N	2026-07-04 12:29:51.030781+00
1d22524b-05f4-4933-adad-76663ce0c810	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-07-04 12:37:10.062536+00
8a132d7b-e4bd-4a65-ae9a-d183ae014d3b	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	hoa_don	4b32a371-1a16-4478-a18e-1757f643e163	\N	\N	\N	\N	2026-07-04 12:44:53.864804+00
ea36473a-b5c2-411c-ace4-998908cbbebc	dddfb501-3d25-4517-ac58-1b9225e85cb3	SEND_EVENT	hoa_don	4b32a371-1a16-4478-a18e-1757f643e163	\N	\N	\N	\N	2026-07-04 12:44:53.869572+00
3c616dc2-ff23-4d00-9940-c9255cea142a	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	hoa_don	8cff81b8-d54e-46a4-a59b-790afca1f7b0	\N	\N	\N	\N	2026-07-04 12:48:18.907092+00
143c5857-59aa-41cc-be9b-b4a30a947047	dddfb501-3d25-4517-ac58-1b9225e85cb3	SEND_EVENT	hoa_don	8cff81b8-d54e-46a4-a59b-790afca1f7b0	\N	\N	\N	\N	2026-07-04 12:48:18.908123+00
1b756563-928e-4e59-b488-93db5729689e	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	lich_hen	860d814c-1a58-40c1-9a3e-18b52b975c87	\N	\N	\N	\N	2026-07-04 12:50:57.412665+00
05b38335-a55c-4ada-b1f0-31bf12ee5753	\N	SYSTEM_CREATE	thong_bao	41f1f107-c1e6-47d0-b557-565233f0a5d5	\N	\N	\N	\N	2026-07-04 12:50:57.420553+00
ef14484a-c718-48f2-8171-4a74395ef110	dddfb501-3d25-4517-ac58-1b9225e85cb3	UPDATE_STATUS	lich_hen	860d814c-1a58-40c1-9a3e-18b52b975c87	\N	\N	\N	\N	2026-07-04 12:51:38.932905+00
a7211965-55a1-4eb6-bf32-9348406d5dfd	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-07-07 04:36:48.176799+00
7d2f796c-d918-49fd-99c3-5c5a62a7db47	dddfb501-3d25-4517-ac58-1b9225e85cb3	CONFIRM	hop_dong	3b5a2527-fcdc-41b6-b512-4be49abc8c1b	\N	\N	\N	\N	2026-07-07 04:40:36.907079+00
3bd3c0ac-aa38-479f-b558-34561bd37de3	dddfb501-3d25-4517-ac58-1b9225e85cb3	CONFIRM	hop_dong	bb9fdaee-6918-447b-969c-4950a8ef0a30	\N	\N	\N	\N	2026-07-07 04:53:14.06239+00
c20db6d7-a703-41af-94b2-9cc731f62103	dddfb501-3d25-4517-ac58-1b9225e85cb3	CREATE	chi_so_dien_nuoc	65bd7630-82d3-47de-82dd-ea813fb6db8d	\N	\N	\N	\N	2026-07-07 04:56:22.420734+00
4685e57b-eb67-4610-8622-2a85989887d6	dddfb501-3d25-4517-ac58-1b9225e85cb3	LOGIN	nguoi_dung	dddfb501-3d25-4517-ac58-1b9225e85cb3	\N	\N	\N	\N	2026-07-07 16:56:07.338859+00
\.


--
-- Data for Name: bank_transaction; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bank_transaction (id, nha_tro_id, hoa_don_id, so_tien, noi_dung_chuyen_khoan, ma_giao_dich, ngan_hang, thoi_gian_giao_dich, payload, da_doi_soat, tao_luc) FROM stdin;
d5bcdd7b-983d-44e9-9157-6bfd3bec6231	5528f265-183e-44d1-ada8-532743022a7d	ec16665e-1a4e-406e-97bb-715ba02c5872	2700000.00	VNPay | TxnRef: 99026011ec16665e | HD: HD178316808638438 | Thanh toan hoa don ec16665e-1a4e-406e-97bb-715ba02c5872	99026011ec16665e	NCB	2026-07-04 12:36:57.615184+00	{"vnp_Amount": "270000000", "vnp_TxnRef": "99026011ec16665e", "vnp_PayDate": "20260704193647", "vnp_TmnCode": "GGRS4AE3", "vnp_BankCode": "NCB", "vnp_CardType": "ATM", "vnp_OrderInfo": "Thanh toan hoa don ec16665e-1a4e-406e-97bb-715ba02c5872", "vnp_BankTranNo": "VNP15610106", "vnp_ResponseCode": "00", "vnp_TransactionNo": "15610106", "vnp_TransactionStatus": "00"}	t	2026-07-04 12:36:57.615703+00
\.


--
-- Data for Name: cau_hinh_gia; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cau_hinh_gia (id, nha_tro_id, dich_vu_id, loai, ten_hien_thi, loai_tinh_phi, don_gia, hieu_luc_tu, hieu_luc_den, dang_ap_dung, tao_luc, cap_nhat_luc) FROM stdin;
2b8eba5e-b002-441f-aca3-951151f5b7a5	d447489d-0757-49be-a39d-d6bb5d5b6556	\N	ELECTRICITY	Ti???n ??i???n	PER_UNIT	3900.00	2026-06-18	\N	t	2026-06-18 00:10:29.738709+00	2026-06-18 00:10:29.738709+00
57c69923-f3a6-48d4-a2f1-fcfd532864ef	d447489d-0757-49be-a39d-d6bb5d5b6556	\N	WATER	Ti???n N?????c	PER_UNIT	20000.00	2026-06-18	\N	t	2026-06-18 00:10:44.291206+00	2026-06-18 00:10:44.291206+00
2ea9f1c4-6fdb-4ed2-ba6a-0fdc0b520f9b	d447489d-0757-49be-a39d-d6bb5d5b6556	\N	INTERNET	Ti???n Wifi	PER_ROOM	100000.00	2026-06-18	\N	t	2026-06-18 00:11:07.047462+00	2026-06-18 00:11:07.047462+00
54977261-958f-415b-acc1-2c5dba2895db	d447489d-0757-49be-a39d-d6bb5d5b6556	\N	OTHER	Ti???n R??c	PER_ROOM	10000.00	2026-06-18	\N	t	2026-06-18 00:11:44.296117+00	2026-06-18 00:11:44.296117+00
2afabe4d-6032-4c84-ab28-e40a215f7a7a	1a447810-275a-419f-95b1-8eaa0eef7a01	\N	ELECTRICITY	Ti???n ??i???n	PER_UNIT	4000.00	2026-06-27	\N	t	2026-06-26 17:41:16.760794+00	2026-06-26 17:41:16.760794+00
6e6ed583-6f4c-4d91-af29-d9c157674780	1a447810-275a-419f-95b1-8eaa0eef7a01	\N	WATER	Ti???n N?????c	PER_UNIT	50000.00	2026-06-27	2026-06-27	f	2026-06-26 17:41:42.829798+00	2026-06-26 17:42:00.548634+00
953150fe-e979-4d18-bb7e-6c555f578c3d	1a447810-275a-419f-95b1-8eaa0eef7a01	\N	WATER	Ti???n N?????c	PER_UNIT	20000.00	2026-06-27	2026-06-27	t	2026-06-26 17:42:11.111171+00	2026-06-26 17:42:11.111171+00
3106cdf4-fb4c-4370-bf32-18e77fd671c8	8456155a-f4ff-44c4-89fb-bde594c00bd6	\N	ELECTRICITY	Ti???n ??i???n	PER_UNIT	4000.00	2026-07-04	\N	t	2026-07-04 12:14:35.87713+00	2026-07-04 12:14:35.87713+00
f1ac5d83-a971-4127-9490-16e6e4a0fe44	8456155a-f4ff-44c4-89fb-bde594c00bd6	\N	WATER	Ti???n N?????c	PER_UNIT	50000.00	2026-07-04	\N	t	2026-07-04 12:14:50.738669+00	2026-07-04 12:14:50.738669+00
b2830960-d343-43b5-844f-f82fb6049843	5528f265-183e-44d1-ada8-532743022a7d	\N	ELECTRICITY	Ti???n ??i???n	PER_UNIT	4000.00	2026-07-04	\N	t	2026-07-04 12:27:06.035237+00	2026-07-04 12:27:06.035237+00
45a65e5e-b3d2-44ae-8c49-87ee00e2af3a	5528f265-183e-44d1-ada8-532743022a7d	\N	WATER	Ti???n N?????c	PER_UNIT	50000.00	2026-07-04	\N	t	2026-07-04 12:27:17.785284+00	2026-07-04 12:27:17.785284+00
\.


--
-- Data for Name: chi_so_dien_nuoc; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chi_so_dien_nuoc (id, phong_id, hop_dong_id, loai, ky_nam, ky_thang, ngay_ghi, chi_so_cu, chi_so_moi, anh_dong_ho, nguoi_ghi_id, trang_thai, ghi_chu, tao_luc, cap_nhat_luc) FROM stdin;
54c925a9-d0b4-490e-bb63-2c41c4ca3b31	eff57238-37a8-4d47-b2e3-6330da3cc531	f744f5b6-4a22-44ad-acf4-ad0615bff692	ELECTRICITY	2026	7	2026-07-30	0	200	\N	\N	BILLED	\N	2026-07-04 10:45:21.919548+00	2026-07-04 10:45:21.919548+00
0679b9e1-5674-4cd9-8aa8-bbfaea55d8b8	eff57238-37a8-4d47-b2e3-6330da3cc531	f744f5b6-4a22-44ad-acf4-ad0615bff692	WATER	2026	7	2026-07-30	0	20	\N	\N	BILLED	\N	2026-07-04 10:45:21.942398+00	2026-07-04 10:45:21.942398+00
eb541e1d-e41c-4098-8944-e123802ba16a	d645b12e-de81-4afe-a897-f8f7689d5a38	971984c0-9b21-4a99-9c49-408a87942486	ELECTRICITY	2026	8	2026-08-30	0	200	\N	\N	BILLED	\N	2026-07-04 12:44:53.848017+00	2026-07-04 12:44:53.848017+00
5a0ecaaa-03ea-450e-a878-e4d01a420bb9	d645b12e-de81-4afe-a897-f8f7689d5a38	971984c0-9b21-4a99-9c49-408a87942486	WATER	2026	8	2026-08-30	0	50	\N	\N	BILLED	\N	2026-07-04 12:44:53.857886+00	2026-07-04 12:44:53.857886+00
1d718950-870b-4379-ad81-c14ceda3a3f4	d645b12e-de81-4afe-a897-f8f7689d5a38	971984c0-9b21-4a99-9c49-408a87942486	ELECTRICITY	2026	9	2026-09-29	200	205	\N	\N	BILLED	\N	2026-07-04 12:48:18.899342+00	2026-07-04 12:48:18.899342+00
8ee23eeb-d042-4a73-9e96-4fc61516f37a	d645b12e-de81-4afe-a897-f8f7689d5a38	971984c0-9b21-4a99-9c49-408a87942486	WATER	2026	9	2026-09-29	50	100	\N	\N	BILLED	\N	2026-07-04 12:48:18.903988+00	2026-07-04 12:48:18.903988+00
65bd7630-82d3-47de-82dd-ea813fb6db8d	660c9c25-bf4b-4822-8ef8-4c73292c9434	bb9fdaee-6918-447b-969c-4950a8ef0a30	ELECTRICITY	2026	7	2026-07-07	0	50	\N	dddfb501-3d25-4517-ac58-1b9225e85cb3	CONFIRMED		2026-07-07 04:56:22.409339+00	2026-07-07 04:56:22.409339+00
\.


--
-- Data for Name: chi_tiet_hoa_don; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chi_tiet_hoa_don (id, hoa_don_id, dich_vu_id, chi_so_dien_nuoc_id, su_co_id, loai, mo_ta, so_luong, don_gia, thanh_tien, tao_luc) FROM stdin;
b1516f08-ee2e-4ab0-9781-9dd9d4d96213	9ac1b645-ad42-4d94-b5df-9be918350281	\N	\N	\N	DEPOSIT	Ti???n c???c h???p ?????ng	1.00	3000000.00	3000000.00	2026-06-24 02:32:04.477103+00
e7341809-fbdd-4d32-9dae-6e50054b3285	6c9e16f4-8c70-426a-883f-01727f004f4f	\N	\N	\N	DEPOSIT	Ti???n c???c h???p ?????ng	1.00	2500000.00	2500000.00	2026-06-24 02:46:28.391434+00
73409982-3273-478d-b374-47602067a8fc	c8a43de3-1281-41d1-a262-d366fb51fda2	\N	\N	\N	DEPOSIT	Ti???n c???c h???p ?????ng	1.00	2500000.00	2500000.00	2026-06-24 03:13:01.15969+00
2f7c96e6-3a88-4af1-a87a-4d1de31057e3	20161659-cf97-4f30-8d42-9e22364a2250	\N	\N	\N	DEPOSIT	Ti???n c???c h???p ?????ng	1.00	2500000.00	2500000.00	2026-06-24 03:35:32.325916+00
bcef6b56-92ef-4cfe-a564-783595579259	0b8e2480-27b0-417f-a381-f739bc612925	\N	\N	\N	DEPOSIT	Ti???n c???c h???p ?????ng	1.00	2700000.00	2700000.00	2026-06-24 03:51:56.132792+00
adba09a1-d53b-475c-acd7-37a19e184e71	37816213-ccb2-4071-9414-680c2e94bdf7	\N	\N	\N	DEPOSIT	Ti???n c???c h???p ?????ng	1.00	2500000.00	2500000.00	2026-06-24 04:05:40.846697+00
cc07bfb0-403b-47ed-9fab-0ca7be2cfc07	45c82967-a604-4eaf-a0da-e47b1085f9d5	\N	\N	\N	DEPOSIT	Ti???n c???c h???p ?????ng	1.00	2700000.00	2700000.00	2026-06-26 17:48:04.596536+00
5784982a-ee8d-4695-8e29-e899d8a94f44	b72cc57a-ab94-48ab-afcd-8d9611b132a3	\N	\N	\N	ROOM	Ti???n ph??ng	1.00	2700000.00	2700000.00	2026-07-04 10:45:21.944559+00
8e91a58f-7b15-4923-809a-36bce87d76b2	b72cc57a-ab94-48ab-afcd-8d9611b132a3	\N	54c925a9-d0b4-490e-bb63-2c41c4ca3b31	\N	ELECTRICITY	Ti???n ??i???n 0-200	200.00	4000.00	800000.00	2026-07-04 10:45:21.945087+00
bfe42b0c-9489-4ae0-93d3-619bd3e37c34	b72cc57a-ab94-48ab-afcd-8d9611b132a3	\N	0679b9e1-5674-4cd9-8aa8-bbfaea55d8b8	\N	WATER	Ti???n n?????c 0-20	20.00	20000.00	400000.00	2026-07-04 10:45:21.945087+00
685acee7-abc8-4a78-90fb-6490c0338394	b72cc57a-ab94-48ab-afcd-8d9611b132a3	ef86aeae-1095-4e97-9ca8-c091b3e78fcd	\N	\N	SERVICE	Ph?? v??? sinh kh??ng gian chung	1.00	20000.00	20000.00	2026-07-04 10:45:21.945087+00
d4a7a4a1-3930-4884-bfc9-f6cdee9a5980	45bb06ca-24c2-4254-b09d-48810baca846	\N	\N	\N	DEPOSIT	Ti???n c???c h???p ?????ng	1.00	2500000.00	2500000.00	2026-07-04 12:15:27.859404+00
0c7548d7-102a-44a7-a4fc-d0512ed108c9	689ffc5b-68db-455d-8507-f41335e29236	\N	\N	\N	DEPOSIT	Ti???n c???c h???p ?????ng	1.00	2500000.00	2500000.00	2026-07-04 12:19:41.271232+00
70bd81f4-cb99-4cbe-8782-61f430e648e1	ec16665e-1a4e-406e-97bb-715ba02c5872	\N	\N	\N	DEPOSIT	Ti???n c???c h???p ?????ng	1.00	2700000.00	2700000.00	2026-07-04 12:28:06.384764+00
8a95abc7-3c93-40d7-b024-b59b830ce858	4b32a371-1a16-4478-a18e-1757f643e163	\N	\N	\N	ROOM	Ti???n ph??ng	1.00	2700000.00	2700000.00	2026-07-04 12:44:53.863141+00
048a5adb-bb6e-411a-a7f9-07f03c6e2796	4b32a371-1a16-4478-a18e-1757f643e163	\N	eb541e1d-e41c-4098-8944-e123802ba16a	\N	ELECTRICITY	Ti???n ??i???n 0-200	200.00	4000.00	800000.00	2026-07-04 12:44:53.86366+00
a5406be2-738f-4186-ae9b-90e48cc1a579	4b32a371-1a16-4478-a18e-1757f643e163	\N	5a0ecaaa-03ea-450e-a878-e4d01a420bb9	\N	WATER	Ti???n n?????c 0-50	50.00	50000.00	2500000.00	2026-07-04 12:44:53.86366+00
1c64c8ce-5dfd-4829-8d7b-491584222950	4b32a371-1a16-4478-a18e-1757f643e163	ef86aeae-1095-4e97-9ca8-c091b3e78fcd	\N	\N	SERVICE	Ph?? v??? sinh kh??ng gian chung	1.00	20000.00	20000.00	2026-07-04 12:44:53.86366+00
615a5ad5-fbb7-4b8d-8307-f758f51a542d	8cff81b8-d54e-46a4-a59b-790afca1f7b0	\N	\N	\N	ROOM	Ti???n ph??ng	1.00	2700000.00	2700000.00	2026-07-04 12:48:18.906575+00
aec2d048-3554-49ea-b612-38e8d2466048	8cff81b8-d54e-46a4-a59b-790afca1f7b0	\N	1d718950-870b-4379-ad81-c14ceda3a3f4	\N	ELECTRICITY	Ti???n ??i???n 200-205	5.00	4000.00	20000.00	2026-07-04 12:48:18.906575+00
832cc059-ff9f-41be-91de-772fb82f0c58	8cff81b8-d54e-46a4-a59b-790afca1f7b0	\N	8ee23eeb-d042-4a73-9e96-4fc61516f37a	\N	WATER	Ti???n n?????c 50-100	50.00	50000.00	2500000.00	2026-07-04 12:48:18.906575+00
235a138e-a07f-473b-b92b-f9b3a7f80383	8cff81b8-d54e-46a4-a59b-790afca1f7b0	ef86aeae-1095-4e97-9ca8-c091b3e78fcd	\N	\N	SERVICE	Ph?? v??? sinh kh??ng gian chung	1.00	20000.00	20000.00	2026-07-04 12:48:18.907092+00
726f4e95-dc25-46d2-bba3-82fe4b22c65f	2681404c-8205-419e-9e35-8c2b709308f2	\N	\N	\N	DEPOSIT	Ti???n c???c h???p ?????ng	1.00	2700000.00	2700000.00	2026-07-07 04:52:38.091473+00
\.


--
-- Data for Name: chu_tro; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chu_tro (id, nguoi_dung_id, ten_cong_ty, so_cccd, ma_so_thue, so_tai_khoan, da_xac_minh, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
\.


--
-- Data for Name: contract_signature; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contract_signature (id, ip_address, signature_image_url, signed_at, signer_id, signer_role, user_agent, hop_dong_id) FROM stdin;
914711cf-78c5-4f5a-b694-6cdd035695a1	127.0.0.1	data:image/png;base64,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	2026-06-24 02:49:32.314863+00	\N	LANDLORD	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	0870facf-e577-4fac-adfe-38cc697b916e
a8d1c32c-a773-4cfa-8a2a-30345646fd78	127.0.0.1	data:image/png;base64,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	2026-06-24 03:13:22.356288+00	\N	LANDLORD	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	387200fe-0565-4591-bbef-71300cc7dcf5
0c121c81-bd21-4106-befd-615df5279785	127.0.0.1	data:image/png;base64,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	2026-06-24 03:37:29.292426+00	\N	LANDLORD	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	0b4171b4-7b23-4e6d-94d2-1c3165c79472
a38ca1de-fdf5-444e-9d8a-47d689c7717d	127.0.0.1	data:image/png;base64,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	2026-06-24 03:38:03.208714+00	\N	LANDLORD	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	0b4171b4-7b23-4e6d-94d2-1c3165c79472
5e794d47-418d-4574-8e7a-b6ceca74d1c0	127.0.0.1	data:image/png;base64,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	2026-06-24 03:39:06.963822+00	\N	LANDLORD	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	0b4171b4-7b23-4e6d-94d2-1c3165c79472
58d5dcd4-8391-4fe3-997e-a2d0a537e002	127.0.0.1	data:image/png;base64,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	2026-06-24 03:49:28.648211+00	\N	LANDLORD	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	0b4171b4-7b23-4e6d-94d2-1c3165c79472
2d53a662-49a7-4e70-a642-3c8b6facc70e	127.0.0.1	data:image/png;base64,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	2026-06-24 03:50:18.656386+00	\N	LANDLORD	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	0b4171b4-7b23-4e6d-94d2-1c3165c79472
9de193c3-ad56-4da0-8eed-f526117e4cfd	127.0.0.1	data:image/png;base64,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	2026-06-24 03:52:21.960964+00	\N	LANDLORD	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	b486f460-d177-4d31-9a6d-0d25621bfaf6
518efa56-3c58-42fe-8a3c-32cbaf8cd5b6	127.0.0.1	data:image/png;base64,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	2026-06-24 03:53:49.701083+00	\N	LANDLORD	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0	b486f460-d177-4d31-9a6d-0d25621bfaf6
20a4bcf2-17b3-4e85-82da-e4c80c5790cd	127.0.0.1	data:image/png;base64,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	2026-06-24 03:57:06.86312+00	\N	TENANT	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0	b486f460-d177-4d31-9a6d-0d25621bfaf6
64991950-6f69-4c0b-9d09-ac72322e2b91	127.0.0.1	data:image/png;base64,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	2026-06-24 04:06:30.172551+00	\N	LANDLORD	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	fa05907e-eefc-49f9-a255-cce5ba87d9f0
478dc02e-d604-4649-8a11-0eb520bfad76	127.0.0.1	data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAfQAAADICAYAAAAeGRPoAAAQAElEQVR4AeydSax1S1mG1w8XNCJIa0cUFA2aiCMdiV10qiNMdKZRBzYDjVMTJU5NdCAxMRqdacCRTjU24EhHFwcQFURz7bgiXAVUuPfne/c565zatWvtvZrq6/mz6uy1alXzfU99Ve+utfc5/8sm/kEAAhA4RODJodpUhgAE4hBA0ONwpBUIDEzg6cC+4zoE6iGQVtDr8RNLIAABCAxBgOclQwxz0EkEPYiFTAhAAAJtEuB5SZvjFsPqlgU9hv+0AQEIQAACEOiCAILexTDiBAQgAAEIjE4AQV+KAPIhAAEIQAACDRFA0BsaLEyFAAQgAAEILBFA0JfIKD/d10XVOgkCEIBAVwRYMssOZyFBb2TY+bpo2eik9/QEGpmK6UHQQwwCLJkxKO5vo5CgM+z7h2xFTYpAYC0BpuJaUpSDQPUECgl69VwwEAIQgAAEINAUgYiCzrO7pkZ+v7GJaxJHiQHTPAQSE2AOxwK8lWREQe/j2d1WgLEGjnZmAn3E0ewNrxAYjwBzONaYbyUZUdBjuVC2na0Ay1rbYe+4BAEIQAACuwgg6LuwUQkCEIAABGogwFPVx1FA0B9ZcNY/gXY8ZJVqZ6ywtCiB01NV5stpDBD0EwZ+JCPARNuH9rRK7as6fC1ibrwQYL6cxhxBP2HgRzICWyZa6wtxMog0vInAlpjb1DCF2yUwxuKCoLcbof1ZvmUhHmN+9jfGeASBIgS2LC6ZDYy4liHomceO7iIRqHh+RvLQb4ZrCECgRwIR1zIEvccAwScIlCIQcbdRygX6bZfA6OGHoLcbu1gOgXgEYrUUcbcRyyTaGYfA6OGHoI8T65V5Ovp76cqGA3MgAIH6CdxYNhH0+oewUwtHfy/d6bCG3Wo898Yq2rh3mN8QgRvLJoLe0Fi2aCpLYYuj1ojN2YLrxiraCC7M7J8Agt7/GB/y8Oia2eZSeNTrQ8ipvJbAHFxry1MOAp0TQNA7H+Cj7o25Znbv9V9bXDwbSG+1PA4IQKBRAgh6owOH2RDYQeB/rY7erXybvb4jkD5qeS9Z+pAljjsC/IRAMwQQ9GaGCkMhsJvALORftKIFfd7wdisn4Ze4v9POCx0ypVDXA3ZbLe1qDasvSBD0+sYku0XMl+zIc3W4RchDNik03m83/t9SgUPvKQp0m7PLivqqlna1hlU0ePemIOj3IEZ+Yb6UH30pZzQrnkzXhFzDre789DfWv+7Zy8XxCsvRbv1d9soBAQhUSuBO0DW1KzUwq1lwyIqbzh4JLCnpY4lVZ3dC/nQKPVpXF4rwuzl/2dy3W5buqcw/27nK28vDofz32ZWE3V4iHGoxQjM0sUiAG4MR0ASeJn/qDgbhwV04PKA4nbDgnjA08ONOyKddQh5y72stU2vDR+zVPxQVmin/4N/YfK1WNleiQv8EFGL9e5nCQ03aFO023yYhZUPIgmsQqo6E2EJu/p4db7MrAQhFwtfbvXi7dWts3yHz9tWk1kECyaqHwi1ZZ101jKAvDCchtQBmuOwqIyG1kPujrHVCu3UfhtRUecd3636Pq6/V/erCFDwjoOE7y+CicQKaqI27MK75TMfhxv4D5rEUbM9n5Fb10KHdutaLjwdamXfrfGkuAKfeLIVStdbVZVgji60maF3gsGY1AabjalQ9FNTj7e8IOKIw0HKTay5/udkQ+ka8bNCX5uKLulq2TjkgUIyAZlnGzveGfK5FICOKHF3txZ3DNvrojMC8K/eDTkuM8krM4fkb8aHd+nuj85en0RulwaEJVO783pAvsRhUjnKNeUu4tb6uqU+Z/QSGYry0K/+M8ath7oZ26xqgz5l9HBCAQGYCNSwKmV1O2d2S0Kfsc7S2h2B8a1f+qopGXbv1v/Xseca75hICIxEo5iuCXgw9HUMgSGBpV/5XVrrW+fqtZts/WXIP+eFeN3quBw4bTd9RZWMPFIdAkECtC0TQWDIh0DGBT5tvevzgy8GcV/A/STHLbh9vsSKy1V5Oh/z42Oms6R+uSysd2VFlZcsUg8A0XWGAoF+Bwy0IZCKg3eyXBPqqeVceMHfyH73rL86FypEHAQgkIICgJ4BKkxBYSWDzrlzb3pVtlyimR++f8DrWmxUvi0sIQCAFgQiCnsIs2oRA1wT0pTcJXWhXLs1enJcNPM19g42ca6b86eDRu3nFAYHKCSwuHJXbjXkQaJWAduX6AzESOtcH/Sqan+feb+mcR+8tjdbJ1l5C7+TMsD+qF/TLkakw8Co06ZIbOYUJaFeunevSrrymX0U7ikqP3vUEwm3n7Jop46Kp4VyhWYMdo9twbGY0KOgVBl6FJo0+LSrzX2KmXblvVk+7ct+3l3sZWqke/iwsU8ajwyUETgSOzYwGBf3kdaQfNAOBZQJSoOW7q+78iZXSDPWbmvN62pWbqxfHB70c/a13L4tLCEAgFgEEPRZJ2umOgFR3p1OzkH9foL525aPMOz169zG+GGBCFgQ6JeC/l0/r5igLS1qKC62TPRyBa0IuYdPs7n1X7g+6v8bo+uHRu1+Y684JaAZU7GJ88zTt8zmsyZWvN3qCQJ8E1gh5/XNt72qmekrLY+v/WVgevS+z6vtOXn3bzLJy8276U/8ic9OFUQvgdwUEJOT6wlvo0brWhj81G9uZY7LYDN58qJ7SckX/z8KqJP8jmyiQIBCRQDuLTUSnaQoCBwm4Qh7am85C/v0H++mpur/W6H9k49F7TyOML8UJ+JOsuEEYUAcBrAgSWCPkEniEPIhvqufRu0YpbCO5EGiWwAZBZwY0O8oYPk3Hwhchn6L8q+fR+/WPCKI4SyMQyE3gQdBvr3fMgNyD029/BTzbF763hPwF80RThx25gVh5PKw59+WzP3rXgN33zQsEuiLwsjm4b653c8Gu3McZCAQJrBXyLwvWJvMWAf/R+3tvVYh5/+ZaF7OzLW2xxm6hRdkAgZetDu7VBQO9kDUdfOQ78W89gYMl52+th5ZX3VM+Qn4Msv/oXUz51jtr7LGoovbkP/4CSSoCLU1WLa+pONTbrsRaoxTyXveU7/998nq9qd8y/39k06P3TVZrQDZVoDAEqiCQLnIR9CoGuDIjJGuVmZTQHIm1PA7NsjnfEfKElozVtP4srP/oXWOxmoIGZ3VhCkKgGgLpIhdBr2aQMSQzAYmHZtY1IWd+pB0UPXp3ewiNhXuf8wsCILtAMnAGC1Zjg8/0PTxgn7IWLoX8DuycX2xemG2jHf/iOfx575rLqwQUslcLcPMwgbvF4XAzGRpg4coAOWYX+aZvO0G8ku8s5K8JlH86PT19bXHnfOiOVQBRsqw3ey3z8YYHhMvSBJ6WNmB1/zsXsNXtU7BZAu0E8RXEf2T35kfrYSGfjgj5dP+vFVb35tb3wi69vjHBogYJNCToK3dBK4s1OFaYvJ7A81ZUKvsD9hqKCN1TfkPxb570e2TYpWu4+wWIZxAQgUoXtNDk0xosk2+klcVutMLt9gi4u/E3LJiv6FBwVRr3C1Y3kn3QTP3VPbeJyJ+la+jd5jed77HlrdbD91j6JUt/ZkkGKP2unXNAIAmBShc2xX0Sf2m0LwKuiC/txuWxAgohF4l6k//Hemr4LH3+uObWOinxVpJ4S7AVbx811BLyX7ZXCbu9nI4fPf3s6oemVlcONevMrUBt1rG+DR9+As1CfkvE/9jiQLDGjnMRMBC5jx3dSghdM597vMh6Ngv57IIfP7N4S8Al2hJvJYn3NcH+R/PixywVOWZn4nfuD1v8HmhxHQE/UNfVKloqXVgWdWtT50NOoFnE5fw1IdfjUQWJYvsHN2HdVFhdbKpQrrCIFeh9R7caM9fSr3YvMpz7Qq4uv85+aIc9i7fcmsVbAq57VuTikHgrqYxEXAGjtn7vomSmDBmeqSu6KUTAn0CFzNjSLWG5hVaUslqKojS0q5F5kb0m4goKWan0il29bK6kLjdXosJtAj7Yn7pd5XCJz1oL6lfxY6dnh8Rbu3AJ85J4q8Is3ir3vZYh8VZ6t50XE3Hrm2MgAg0K+kCjU4urWury2uLuxkOLrKyRVc0+Ul9ySo4Nnvw16T0JeejRud4wfvHGPiTef251ZvHWcM7iLQHXPbvNAYG8BPzJk7d3eoPAIwFXxNfsxhW7CR+pPxqW4kzvRlK020mbLh6JZYxdusRbO2z/0bnav4ZN4q0k8XYfnWsXvlK8rzXPPQjEI6BFMV5rtASB7QQk5FrA14i4Fl9idjvj1mr4/xPb1l26xFtJ4n3rW+chNopHCbhEWztvJYk3j85DtMi7J6Dl6f600Mvl4ljepkIoSnc7FHiJuB51auGUkIfg695/2g2BuYxTu8HRLQH9T2wa/9lBxcC1Xfos3hJwfd6tz72VJMrXvnU+t+++ql/FmwS8iUfnrvGclySg0CnZ/zQpcM8tKG/TuT3DXA0B/iTiT6ZJIm4vwcEVCN1TbL4xWILMEQgs7dIl3qFH5xJvJd3by0exp7jbW596EChKgOAtin+Izt3duIR60qrpea6sZr/g5vnCZRwCoV264kQ7b+3Cb4n3/Ln3iyvNUWy2vB5+cqWfG4tRvCUCLQdwS5xHsfX3zdH/s3TaidurFuBru/EbvzOuNdZaSX7k6ie5I613oN23HpsrSbTXDozEW4/HJfL63Fv19Lm32rn1F+cUoyrfMjvNN/2lPfnyby07gu3HCCDox/iNXFvirf8lS4uJFhKlHzYgr7R0bYFUOd1XuvE74ypqrSU/cvWT3JGWOpB46/G4RFfirUHQ7luirKR7IX8k3koqs/St889aRbWnGLPTxUNlelgDXT+/wrxtRtTNVo6IBHoI5og4aGqBgMRbyRfvr7Ly7mJil8FDCyeP1INohsiUeCtJvPd869yFpJ23kr60FvrWuWJ0ze+VK257Wf80v1xGiLpLY6DzXgJ6oCHL4uos3loctVho562kRXCNAarzr1ZQ5ZUUZ83+zrj5wbGNwCzeEnDtvrXzVtKu+tq3zrXz9h+df2ZD14o7xdu1KmvKXKtf4z3NL/nl2PaEL5RODo5BThUIg7g6vJu/aAR+9T79lr3OSeLtf+49i/etxdGaOX3HTYvJH9iFyisprnL/HW7rnqMAAYm3Ho/P4q1YmMVbAq57IbMk3koqs/ToXPVepR9O0vcunMuHU/X7cLFw8mnLV2zaS3eH59caHN0xGN4hLwiG59EzgF8x537hPv2kvc5J4n3rc28rfjq0Sij5u2/F0Y+cStz6Ibm/VYb7tRKQeCtJvLc+Op/FWwKuL67psbnS0qPzJQaKNf+eYtLP868VeV/qZ3INgb0EaqwXmhw12olNZQhooQyJ9/7dt1os4wu9bicwi7cE/Oij81m8JeB6rL7FGjdqJMxuXfeem++e+3Xce5xDoBsCCHo3Q3nYES2MrnhrEVR87BfvwybRQEYCEm89Hp/FW/EQ89H5EVf0rfVQfdkYynfzPuhecA6BNgjss1IL9r6a1MpDQLKapqcPIQm3RQAAEABJREFUW7NqfU6KBcT7Hoq99HxIvJUk3qUenW/h63+OPn9Z02/DF3hd6w/U+OVGuH5hBCfx8ZyAFvHzHK7qIqAlKY5F/+M183a7/i9LHB6BeMi9hjNc6t1ZoJtZvCXgJR+dB0zblRVyU8Pm5ut6pPXtOY/k673rBi7d4WvA3ApNXBvwFZqOSRsJvHp6Mv20V+e1do2oG4ReDlMxiXeCR+dPtn7uHRvp81ca/G+798SSe4y2tul3z13/Gzy36G3Q6ppMHi3oa2Kf35an029apyFR10zSY8zP2f1PWdJnp39hr79h6V2WOOokIPFW0s478aNzhUhRCG9a6F1C/mrvnvK8rO4vD63lIwKLEhGVgTsUBFGAqJGGU2XjuYbkLOr+f+YgV56ZpievmaZJIvFd0zT9jKX3WZLYK82CP4u9BN9ucyQk8E5r200Sb6UeHp2ba6uP0DsK5Sm5jfjX7j3OFwgAbQHMrezKwCUWdGnELSJt369sPNfClKi/zgr7om5ZQY80kEom+JMEfxZ7Cb4quGIfaXev7sycfIcrmvP5z1n3fvpty3OThDWU/s7KuUkfbfhJb5DcJJZ+er+14yb9HreSHqvbrYtDv++tpDLX/mCLVzE7b6//q5diEirgG61yide0kBnkQaAOAomDX/OruKMYsExAoq5FUemHrNh7LP2lJX1DVmnpr3JZkbND9Wex37K7l3D6gqlrE8ynlqY5hQRTea5g6twXTF27gjmfKzD95IrmfP5r5qWfftzy3CRhDaVvsHJueq1d+0nM3GRFvENkvSzvchZvCfjpD7ZYlfl3vkN/69yrPl8Kx3xe1aveLK41KPF6ttaMIuVs2B/6rXYwHyzkJAmBkSdAEqANN/qHZvvPWvpuS/qvGJX0v6FpoZDYK0nslWaxX7NwqL6ShMvf3Us4fcHUtSuYOg8JpvJcwdS5L5i6Vr9+MhcbOZ5OelPlpg+Z5bN4i+ss3u+2/NMX19YMipVt5ZCPrq26DrmofLcc5/cEAHMPYoAXBP3oII9RX2KvJLFXmsVe8aP1QmK/d3dfC0FXNOdzfSThp783g90kEQ2l37Fybvp5u/bTd1qem8TST3pT5aZvtjoP4m3nPR/+7vwj987Oceeyur/Fi08g9O7HL8N1HwQ0MfrwBC9KEpDY79ndv2hG+4Kpa1cwdR4STOW5gqlzXzB17QrmfO4KwXzuiuZ8ro8k/PSNZrOb9Jg7lH7Cyrnp1+3aTx+wPDfZJcc9gWftVWNjL6dDuvS20xk/PAIuptMt/43QKZMfuQhcjEeujicEPSrq6AMZ1bpCjUnslbSzV3J393oU7gumrl3B1HlIMJXnCqbOfcHUtSuY83khFHS7gcC3eGVZqzwgj5d6r/N4ZWcvtLYStWavMb5yXIzHlbJxbzFJQjx3R1e5gQy5QR4EGiWg/87XnYVMrOsDefFX4loDttVeNziuoxnrLoIeGu+t0RVqo4U8bIRAnQRe6ZnFOuUB8S7L/JW4gqra9RJ9gCsTxZsZXEIAArcIHFhxbjU9Tf7nv/2t3fHxlVnHN41MfKdvh1KjJTZxPfexTCCc28BV1QR2T8SqvRrSuGhDeWDFuQ3et7K/NSopvtuAj5bwB2hde407vc7J4qX6myzFkfZmABOxmxGtfyj93fn8a2rdDEEPjtQfRrco73tLcqvVGu4j6DWMAjZsJ9BCjX7XjRT0+TW1/VTdSGtfb/dzWFmzX0QI+soQoBgENhPod93YjGJFBX5NbQWkJoq4by+aMLgfIxH0fsYST+IRoKW8BPg1tby80/bGG9m0fK+0HlXQeWN2hTS3INAtgcMzn19Tixcb/vcQ4rVMS9UTiCrovDGrfrwxsAYC3dkQdeZHbaw71JcOfczL0n+c5GVxOQqBqIKeFtrhXUBa82gdAhDYQ0BfhnPrNbQmuWYXO/8ar+fXe9dcDkSgocnDG/eB4hJX9xNorab/ZbjW7C9tLzud0iNQUf8NCXpF1DAFAhCAQH0E2PXUNyZZLULQs+KmMwg0TiC++e4OE0HaxvfzXnHWcw/IaJcEwGgjjr8QgEAvBFi/exnJ3X6474eniYDYDZKKEIBAZAL8ytU2oE+c4l0/3XAddXyu9zSGwavaOB92BL3ekMCyCwKrIvyiFhnNEHiuGUvLG+r/utony5uUzoJz2UrXT7SWYxi8ow0EPdoI0lB6AjsiPL1R9LCfgP8ra2/Z39SKmn0V4dfV+hrPKN4g6FEw0ggEILCDAL+ytgPafRUeV92D4OWRAIL+yIIzCEAAAnsJlKzHo6ts9Au8j9rQJYKeLRDoqG8CG2Zd3yC2eOdCQ5TWk+PX1dazilyyQJhu6BJBjzzcNDcqgQ2zblRE+L2fwHlN1u1zHlzdEyAw7kHwAgEIFCXw0jS5G/aJf8sEXFC8k1zmNNwdBH24IcdhCFRJwITJjipNq8aoT5glPqQYv65mzXL0QABB72EU8QEC7RN4ue+Cuw317w14rc/NX+f5LXHnf1fzoIx8iaCPPPr4/kDgUjwucx4Kc5KFgNQqS0f1dyIx99/wCE8b63f9fLuxkIDoZihx5AgBrY7n9S9zzu9zBYEsBF6yXhBzg8BxmwCCfpsRJSAAgTQE3HdNPBK5ZCwx97mIGev2IyvOHAIEhgODUwhUT8Bf3qs3GAN3EkDMd4KLW62tCYegxx39bltrK6y7HYZp0v6sY/dw7UQAMT9hqOBHYxOuUUFHXnKHOjqSm/gQ/b04hJfbnNRU8xc4XTe6Vm9zntLHCDQaJIr5Y45TGwKjEZAqVObzf3j2aGeqb3R72d1fymctakq+sxUOm28i1zsJRK/WqKBH50CDEOieQEgtCjv9Zq9/iZe+0S1TJe7Pevd7utQfiZGP8lU+h3wTj1A+eRAIEkDQg1jIjEKA5SgKxviNNDEwMvId5rsET8LXg7i7Iq4/EiMfzcWLQz4v3bsoTAYEZgJngj5n3n4l1m4zokRj3ycZaMCkF9W4q8Xk382aa0apTKvivlbEDcFpxsjXneuymiCNTOAxcBRGq0lcm3urG6EgBCAAARH4SvuhtUirkHbjdrl4qEwL4i4/tFBe24nLSZWRT0pioDwSBHYReAwghdWuJtZWolw9BLR21GMNlrREIHns6PNkdaI0i+ISIJVxxV3ll8rmyFf/WkmVZNtSn7r/YbupMo9rsGVwQOAIAYLpCL1m62o9adZ4DC9KwGJHMpTHBom71ij1OIvlUs8qo2QGTiqrtFQ2Rv7HrRF9O139qE8l9W/ZwUP3XRH/pmCpbjOvoenW6eyOabJk7zRFh7QJAQhkIiBpytSV081ecZe1Et01SWXXpjeabbLpllLpd+1VRmttOhFXD2ZQvYew1mtdL5YpyHrxBT8gAIExCEhItXZJxp43l2+phcqtSdZUlEP2zP09c2pRV6eTRD/UY6KmabYdApoU7VhbzFI6hgAEihMIi+KbzC6tY7q7RtyteJJDkioblGTPeSe6e57DFQSiE7gMvOhd0CAEIACBCARui+IecVert5IemyvNn4FLtP3EWhphiGniGIFhglCz7xiqdLVpGQKlCXQ4P1xxl3tLSWvgraTH5krpPgMvHQBN96+hbdqBaMYrkKM1VnNDegtezj4Crhx7el5DoOz8WGMhZSCwRIDonckMI+izw2VeSwZcGY/pdRQCK96srigyCi38hEBKAgh6Srq0DYHuCax4s7qiSPeYcBACGQgg6Bkg99wFvqUjwMY2HVtahsB2AvXPSAR9+6hSAwJZCLCxzYKZTooTqF8o7xDVPyMR9LuR4meVBDAKAhCIRqBa3axfKKONQeKGEPTdgKudHbs9oiIEINAxAXSz48G9cw1Bv+Ow4yezYwe0qqpgDAQgUIYA26E03BH0NFxpFQIQgAAEFgiwHVoAczAbQT8IkOoQCBMYO5cd2NjjH8t74mgbSQR9Gy9KQ6B9AhlWySM7sAzmtT+Gg3hwJI5qQpQrphH0mkYdWw4SyDVtDpoZofqhJipfJSs37xB6Ko9JIFdMI+hjxtey101rYq5ps4yPOxCAAARKEUDQS5GvtV80sdaRyWgXXUEAAi0SQNBbHDVshgAEIAABCHgEEHQPCJcQgEBaArQOAQikIYCgp+FKqxBIQKDpLzgk4FG6Scaj9AjQ/zkBBP2cB1cbCLS5nLVp9d2w8AWHOw7Xfua8x3jkpE1ftwkg6LcZUWKBQJvLWZtWLwzBRXbLb1cunCEDAhDYRABB34SLwnkIIEt7Off9dmUvlXj1Qi0RrSEq5JUggKCXoN5Cn0VXKWSphRDBxjsCROsdB36WJ4Cglx+DOi1glapzXIa1qug7zEzU6QYCxwgg6Mf4URsCEMhCgHeYWTDTSdMEEPSmhy+P8eyN8nCmFwikJEDb/RNA0Psf48Mesjc6jJAGIAABCCQngKAnR0wHEKiZAM9fah6ddmxLYSmxuZUqgr6VGOUh0NU60/vzl64Ga7C513tsxh9OBD0+U1rsnQDrTEMjzGA1NFiLpq67wZs3BH1dpFDqIAGm2kGAVIdAZQTqm9O8eUPQK5skvZrDVOt1ZPFrG4H6ZHCb/Y+l+5nTjz61foagtz6Cu+3vZ2HZjYCKjRJoOXaRwUaDrgmzEfQmhimFkSwsKajSZg4CxG4OyvQRh8ByK/HfmCLoy7S5AwEIQAACjRKIL5exQcR/Y1q3oNc/IrFHmPYgAAEIQCACgfhyGcGo6E2cN1i3oI84IufjwxUEIACBCwLsdS6QkGEE6hZ0M5ADAhCAQBsE8slsTXudfF63EQUlrYwt6CV9oW8IQMAhwELrwMhyWpPMZnH41MmYXp9cr+7HsILOYlddLGJQZAIstJGB0hwEKifQlqBHhMliFxEmTUEAAhCAQHECwwp6cfIYAAEIQAACmwnwdHUZGYL+yMbOCBWDwAEBCECgWgI8XV0eGgT9jA2hcoaDCwhAAAIQaIYAgp5rqOgHAhCAAAQgkJAAgp4QLk1DAAILBPh0awGMkz0koyGddgb92CmCfoxfLbWxAwJtEWj9060cutM6o10R6Tmdg/MuOx8r1WQigv44LpxBAAIQWEfA0511lSi1mUADnGsyEUHfHGEDVsDlOARqeisfxyNagQAEjhKIuC4g6EcHo9n6EaOoWQaZDa/prXxm1+kOAhBYIBBxXUDQFxj3nx0xio7BojYEIAABCEQggKBHgEgTEIAABCDQMIFOHlgi6A3HYIumZ583LULCZghAIC+BTh5YNi7oyEPeqD/eWyfz5jgIWhiOAKtVm0Oeb9yO99S4oCMPbU6RtVYfD/C1Pe0sF6jWos0BN8iKTiDXakUExh26XOM2Tcd7alzQ4w4crdVG4HiA5/eoRZvzU6LHdASIwHRsa28ZQa99hLBvXAJ4DoFGCfCUoMzAIehluNMrBCAAgW4J8JSgzNAi6GW40ysEShOgfwhAoDMCCHpnA9qHOzyw62Mc43pBVMTlSWv9EUDQ+xvTDjzigVPD5NsAAAArSURBVF3zg5jAge6igncoCaJk7CYR9LHHv2nvWQ+bHj6M7+4dCkNamsAXAAAA//+iGFDaAAAABklEQVQDAKGib84H8ATfAAAAAElFTkSuQmCC	2026-06-24 04:07:51.108361+00	\N	TENANT	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36	fa05907e-eefc-49f9-a255-cce5ba87d9f0
\.


--
-- Data for Name: dat_coc_phong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dat_coc_phong (id, phong_id, khach_thue_id, hop_dong_id, so_tien_coc, ngay_dat_coc, ngay_du_kien_vao, trang_thai, ghi_chu, tao_luc, cap_nhat_luc, cancelled_at, confirmed_at, ly_do_huy, nguoi_xac_nhan_id) FROM stdin;
\.


--
-- Data for Name: debt_reminder_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.debt_reminder_log (id, channel, error_message, recipient_contact, reminder_type, sent_at, status, hoa_don_id, recipient_id) FROM stdin;
\.


--
-- Data for Name: dich_vu; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dich_vu (id, chu_tro_id, ten_dich_vu, loai_tinh_phi, don_vi, don_gia_mac_dinh, bat_buoc, tao_luc, cap_nhat_luc) FROM stdin;
f3d52cbe-8c49-4d73-afcc-0fcd5ca0f3b1	dddfb501-3d25-4517-ac58-1b9225e85cb3	Ph?? thang m??y	PER_PERSON	vnd	50000.00	f	2026-06-24 02:40:18.707754+00	2026-06-24 02:40:18.707754+00
ef86aeae-1095-4e97-9ca8-c091b3e78fcd	dddfb501-3d25-4517-ac58-1b9225e85cb3	Ph?? v??? sinh kh??ng gian chung	PER_ROOM	vnd	20000.00	t	2026-06-24 02:40:43.348719+00	2026-06-24 02:40:43.348719+00
cfe287d4-7e52-44d3-8528-46190ae9ead3	dddfb501-3d25-4517-ac58-1b9225e85cb3	Ph?? gi??? xe m??y	PER_UNIT	chi???c	50000.00	f	2026-06-24 02:39:52.262451+00	2026-06-24 02:42:09.591609+00
ca014be1-c319-4dc2-9d6d-a0a20dc3e467	dddfb501-3d25-4517-ac58-1b9225e85cb3	??i???n	FIXED	\N	4000.00	f	2026-06-26 17:48:04.58633+00	2026-06-26 17:48:04.58633+00
78d96e0f-29dc-492f-a165-e222b4b892a1	dddfb501-3d25-4517-ac58-1b9225e85cb3	N?????c	FIXED	\N	20000.00	f	2026-06-26 17:48:04.594351+00	2026-06-26 17:48:04.594351+00
\.


--
-- Data for Name: dich_vu_hop_dong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dich_vu_hop_dong (id, hop_dong_id, dich_vu_id, loai_tinh_phi, don_gia_ap_dung, so_luong, bat_dau_tu, ket_thuc_luc, tao_luc) FROM stdin;
9ed9bd84-812c-4558-a9d2-228e04190ab8	0870facf-e577-4fac-adfe-38cc697b916e	ef86aeae-1095-4e97-9ca8-c091b3e78fcd	PER_ROOM	20000.00	1.00	2026-06-24	\N	2026-06-24 03:06:10.287826+00
a9e3906d-18c9-479a-9b2d-309a983a1809	387200fe-0565-4591-bbef-71300cc7dcf5	ef86aeae-1095-4e97-9ca8-c091b3e78fcd	PER_ROOM	20000.00	1.00	2026-06-24	\N	2026-06-24 03:13:01.157595+00
eabe1540-2420-4172-9e5c-0d6d28467f57	387200fe-0565-4591-bbef-71300cc7dcf5	f3d52cbe-8c49-4d73-afcc-0fcd5ca0f3b1	PER_PERSON	50000.00	1.00	2026-06-24	\N	2026-06-24 03:13:01.158637+00
5d311ec9-d8e7-4692-8a75-9e1f930e6ed8	0b4171b4-7b23-4e6d-94d2-1c3165c79472	ef86aeae-1095-4e97-9ca8-c091b3e78fcd	PER_ROOM	20000.00	1.00	2026-06-24	\N	2026-06-24 03:35:32.323048+00
0707f087-3882-4984-a14a-3be34ff95040	b486f460-d177-4d31-9a6d-0d25621bfaf6	ef86aeae-1095-4e97-9ca8-c091b3e78fcd	PER_ROOM	20000.00	1.00	2026-06-24	\N	2026-06-24 03:51:56.13128+00
c319a797-4f88-4222-a0a8-d8982fbc4656	fa05907e-eefc-49f9-a255-cce5ba87d9f0	ef86aeae-1095-4e97-9ca8-c091b3e78fcd	PER_ROOM	20000.00	1.00	2026-06-24	\N	2026-06-24 04:05:40.845269+00
1f1de52f-6328-4389-ae8c-d723cd2d7cac	f744f5b6-4a22-44ad-acf4-ad0615bff692	ef86aeae-1095-4e97-9ca8-c091b3e78fcd	PER_ROOM	20000.00	1.00	2026-06-26	\N	2026-06-26 17:48:04.579619+00
66e3157c-dd03-4399-8c81-c20690ff8d96	f744f5b6-4a22-44ad-acf4-ad0615bff692	ca014be1-c319-4dc2-9d6d-a0a20dc3e467	FIXED	4000.00	1.00	2026-06-26	\N	2026-06-26 17:48:04.586872+00
fddebeab-8c48-490e-899f-2f09a46acd47	f744f5b6-4a22-44ad-acf4-ad0615bff692	78d96e0f-29dc-492f-a165-e222b4b892a1	FIXED	20000.00	1.00	2026-06-26	\N	2026-06-26 17:48:04.594351+00
17a417ce-cd0d-4636-96ad-35c824c8eaa7	1df72449-7386-4e4a-82a1-89c55d648645	ef86aeae-1095-4e97-9ca8-c091b3e78fcd	PER_ROOM	20000.00	1.00	2026-07-04	\N	2026-07-04 12:15:27.852086+00
2f2ee25b-571d-4136-9174-d6dfce1ce419	1df72449-7386-4e4a-82a1-89c55d648645	ca014be1-c319-4dc2-9d6d-a0a20dc3e467	FIXED	4000.00	1.00	2026-07-04	\N	2026-07-04 12:15:27.856249+00
8ccdf985-1bed-448c-ad84-9d6ec26c78c3	1df72449-7386-4e4a-82a1-89c55d648645	78d96e0f-29dc-492f-a165-e222b4b892a1	FIXED	50000.00	1.00	2026-07-04	\N	2026-07-04 12:15:27.85782+00
434a34af-7695-4405-8db9-53a690c46b00	3b5a2527-fcdc-41b6-b512-4be49abc8c1b	ef86aeae-1095-4e97-9ca8-c091b3e78fcd	PER_ROOM	20000.00	1.00	2026-07-04	\N	2026-07-04 12:19:41.2665+00
d3226643-c09f-42d9-8680-d078ece4ca4e	3b5a2527-fcdc-41b6-b512-4be49abc8c1b	ca014be1-c319-4dc2-9d6d-a0a20dc3e467	FIXED	4000.00	1.00	2026-07-04	\N	2026-07-04 12:19:41.26859+00
ef8a87eb-b120-409a-9376-833d58c36a77	3b5a2527-fcdc-41b6-b512-4be49abc8c1b	78d96e0f-29dc-492f-a165-e222b4b892a1	FIXED	50000.00	1.00	2026-07-04	\N	2026-07-04 12:19:41.270709+00
9cbb4a26-b3d8-4170-ac81-9e611e612ad9	971984c0-9b21-4a99-9c49-408a87942486	ef86aeae-1095-4e97-9ca8-c091b3e78fcd	PER_ROOM	20000.00	1.00	2026-07-04	\N	2026-07-04 12:28:06.381101+00
75be11cb-4747-40bc-9ca5-90c0e88b5a62	971984c0-9b21-4a99-9c49-408a87942486	ca014be1-c319-4dc2-9d6d-a0a20dc3e467	FIXED	4000.00	1.00	2026-07-04	\N	2026-07-04 12:28:06.382695+00
b779a735-24e4-4c8f-95de-c4613c8bb728	971984c0-9b21-4a99-9c49-408a87942486	78d96e0f-29dc-492f-a165-e222b4b892a1	FIXED	50000.00	1.00	2026-07-04	\N	2026-07-04 12:28:06.384764+00
9330584a-10d0-47ef-bc7d-e5cd8a20ea71	bb9fdaee-6918-447b-969c-4950a8ef0a30	ef86aeae-1095-4e97-9ca8-c091b3e78fcd	PER_ROOM	20000.00	1.00	2026-07-07	\N	2026-07-07 04:52:38.083698+00
a3792a9a-4cce-49f1-b671-e11c3c5a4be0	bb9fdaee-6918-447b-969c-4950a8ef0a30	ca014be1-c319-4dc2-9d6d-a0a20dc3e467	FIXED	4000.00	1.00	2026-07-07	\N	2026-07-07 04:52:38.087844+00
91be3ec5-8e33-47eb-a396-3a82c0dd3d29	bb9fdaee-6918-447b-969c-4950a8ef0a30	78d96e0f-29dc-492f-a165-e222b4b892a1	FIXED	50000.00	1.00	2026-07-07	\N	2026-07-07 04:52:38.089395+00
\.


--
-- Data for Name: email_verification_token; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.email_verification_token (id, nguoi_dung_id, token, ngay_het_han, tao_luc) FROM stdin;
b5050960-75b0-43f1-b858-4a7b9337562b	dddfb501-3d25-4517-ac58-1b9225e85cb3	3d50f1ba-e409-4641-abe0-bb68fcb3f485	2026-06-18 23:31:39.00467+00	2026-06-17 23:31:39.005205+00
\.


--
-- Data for Name: file_media; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.file_media (id, doi_tuong, doi_tuong_id, url, public_id, loai_file, kich_thuoc_bytes, metadata, nguoi_tai_len_id, tao_luc) FROM stdin;
f0c1c17c-291e-40f4-b10c-12f550bc7b48	ROOM	55540e96-9754-46fa-baf6-10c6692aa61a	https://res.cloudinary.com/dd4tyakf3/image/upload/v1781742564/quanlyphongtro/wcqzarng223prqw8yhki.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-06-18 00:29:27.705164+00
bfdfc82a-7cd9-409c-b2ac-2a212b314ba9	ROOM	55540e96-9754-46fa-baf6-10c6692aa61a	https://res.cloudinary.com/dd4tyakf3/image/upload/v1781742564/quanlyphongtro/n35jg1mwkisp27eniitw.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-06-18 00:29:27.709479+00
614b51e0-f19c-4f59-871b-364e098ec189	ROOM	55540e96-9754-46fa-baf6-10c6692aa61a	https://res.cloudinary.com/dd4tyakf3/image/upload/v1781742564/quanlyphongtro/nn3csu2el6sosglnld6x.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-06-18 00:29:27.709479+00
46201a61-01a1-4133-ba08-f1aac12da022	ROOM	55540e96-9754-46fa-baf6-10c6692aa61a	https://res.cloudinary.com/dd4tyakf3/image/upload/v1781742565/quanlyphongtro/nun9jjtyrcbdvcovj1eq.jpg	\N	ROOM_IMAGE	\N	\N	\N	2026-06-18 00:29:27.710009+00
0e579579-d3da-471c-95d7-7860b4d964f6	TENANT	7a660e5a-738b-43da-ae2c-1a15381b7a12	https://res.cloudinary.com/dd4tyakf3/image/upload/v1782268071/quanlyphongtro/xobn6hkljzb3ii0kigu8.webp	\N	CCCD_FRONT	\N	\N	\N	2026-06-24 02:27:55.609913+00
bca3bc66-93ea-46f5-b5b4-9f02507a68ee	TENANT	7a660e5a-738b-43da-ae2c-1a15381b7a12	https://res.cloudinary.com/dd4tyakf3/image/upload/v1782268073/quanlyphongtro/mq9hg3dfm4ssqnwovxq9.webp	\N	CCCD_BACK	\N	\N	\N	2026-06-24 02:27:55.61691+00
ee16385a-7899-4a4f-8bef-22905f6b4713	TENANT	580c70c4-6c6b-4a67-97a1-03d6ccd3d8cc	https://res.cloudinary.com/dd4tyakf3/image/upload/v1783167240/quanlyphongtro/yh4z50rz4ain8sdlazzm.webp	\N	CCCD_FRONT	\N	\N	\N	2026-07-04 12:14:02.01131+00
c6c2d4f0-75f0-42a2-b9a0-face4a8b3704	TENANT	580c70c4-6c6b-4a67-97a1-03d6ccd3d8cc	https://res.cloudinary.com/dd4tyakf3/image/upload/v1783167241/quanlyphongtro/sxj4shaqgnxutf5wgzse.webp	\N	CCCD_BACK	\N	\N	\N	2026-07-04 12:14:02.015991+00
\.


--
-- Data for Name: hoa_don; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hoa_don (id, hop_dong_id, phong_id, khach_thue_id, ma_hoa_don, ky_nam, ky_thang, tu_ngay, den_ngay, so_du_dau_ky, tong_tien_phat_sinh, tong_tien, da_tra, trang_thai, han_tra, ngay_lap_hoa_don, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, auto_generated, generation_batch_id, source_schedule_id) FROM stdin;
2681404c-8205-419e-9e35-8c2b709308f2	bb9fdaee-6918-447b-969c-4950a8ef0a30	660c9c25-bf4b-4822-8ef8-4c73292c9434	2f14a85f-ddb6-4182-95ec-75ca5687346f	HD178339995808978	2026	7	2026-07-07	2026-07-07	0.00	2700000.00	2700000.00	0.00	UNPAID	2026-07-14	2026-07-07 04:52:38.090437+00	Thu ti???n c???c h???p ?????ng	2026-07-07 04:52:38.090963+00	2026-07-07 04:52:38.045285+00	\N	t	\N	\N
6c9e16f4-8c70-426a-883f-01727f004f4f	0870facf-e577-4fac-adfe-38cc697b916e	c3d31275-9559-4e7b-b51e-8928ccdc4137	7a660e5a-738b-43da-ae2c-1a15381b7a12	HD17822691883913	2026	6	2026-06-24	2026-06-24	0.00	2500000.00	2500000.00	0.00	UNPAID	2026-07-01	2026-06-24 02:46:28.391434+00	Thu ti???n c???c h???p ?????ng	2026-06-24 02:46:28.391434+00	2026-06-24 03:08:27.93028+00	2026-06-24 03:08:27.946874+00	t	\N	\N
b72cc57a-ab94-48ab-afcd-8d9611b132a3	f744f5b6-4a22-44ad-acf4-ad0615bff692	eff57238-37a8-4d47-b2e3-6330da3cc531	a672fd3c-0504-42a8-ad47-a5ec0f628e4a	HD20260704521	2026	7	2026-07-01	2026-07-30	0.00	3920000.00	3920000.00	0.00	UNPAID	2026-07-09	2026-07-04 10:45:21.91334+00		2026-07-04 10:45:21.913865+00	2026-07-04 10:45:21.907721+00	\N	\N	\N	\N
c8a43de3-1281-41d1-a262-d366fb51fda2	387200fe-0565-4591-bbef-71300cc7dcf5	f9f371b2-eadc-424f-97e1-bbb28d158826	763cc66e-a785-4c1f-9008-0ed2c4228213	HD178227078115849	2026	6	2026-06-24	2026-06-24	0.00	2500000.00	2500000.00	2500000.00	PAID	2026-07-01	2026-06-24 03:13:01.15969+00	Thu ti???n c???c h???p ?????ng	2026-06-24 03:13:01.15969+00	2026-06-24 03:17:34.609616+00	\N	t	\N	\N
20161659-cf97-4f30-8d42-9e22364a2250	0b4171b4-7b23-4e6d-94d2-1c3165c79472	76e99fea-1dbe-435d-8da3-62ce078007c2	66ff1459-9f98-4506-b6b8-34d9d9ab9d9c	HD178227213232349	2026	6	2026-06-24	2026-06-24	0.00	2500000.00	2500000.00	0.00	UNPAID	2026-07-01	2026-06-24 03:35:32.324859+00	Thu ti???n c???c h???p ?????ng	2026-06-24 03:35:32.32538+00	2026-06-24 03:51:20.13802+00	2026-06-24 03:51:20.146697+00	t	\N	\N
45bb06ca-24c2-4254-b09d-48810baca846	1df72449-7386-4e4a-82a1-89c55d648645	6d6fd936-15ae-4558-a606-6f11000279da	580c70c4-6c6b-4a67-97a1-03d6ccd3d8cc	HD17831673278573	2026	7	2026-07-04	2026-07-04	0.00	2500000.00	2500000.00	0.00	UNPAID	2026-07-11	2026-07-04 12:15:27.858338+00	Thu ti???n c???c h???p ?????ng	2026-07-04 12:15:27.858856+00	2026-07-04 12:18:51.678263+00	2026-07-04 12:18:51.682045+00	t	\N	\N
37816213-ccb2-4071-9414-680c2e94bdf7	fa05907e-eefc-49f9-a255-cce5ba87d9f0	0045aaf1-97a5-4987-83ed-0aaec9ab162d	a672fd3c-0504-42a8-ad47-a5ec0f628e4a	HD178227394084566	2026	6	2026-06-24	2026-06-24	0.00	2500000.00	2500000.00	2500000.00	PAID	2026-07-01	2026-06-24 04:05:40.84591+00	Thu ti???n c???c h???p ?????ng	2026-06-24 04:05:40.846697+00	2026-06-24 04:14:33.152427+00	\N	t	\N	\N
0b8e2480-27b0-417f-a381-f739bc612925	b486f460-d177-4d31-9a6d-0d25621bfaf6	f96050ad-d946-46d6-a055-9a5692946237	808ec20a-5f93-4a22-86a2-40fef4f756e8	HD178227311613143	2026	6	2026-06-24	2026-06-24	0.00	2700000.00	2700000.00	2700000.00	PAID	2026-07-01	2026-06-24 03:51:56.13128+00	Thu ti???n c???c h???p ?????ng	2026-06-24 03:51:56.132792+00	2026-06-26 17:43:52.147001+00	\N	t	\N	\N
9ac1b645-ad42-4d94-b5df-9be918350281	5f6b7466-f3f0-4a53-bd5c-072712c119de	96180a6a-af82-4fe1-ae2d-5ba0a1ae384d	7a660e5a-738b-43da-ae2c-1a15381b7a12	HD178226832447620	2026	6	2026-06-24	2026-06-24	0.00	3000000.00	3000000.00	3000000.00	PAID	2026-07-01	2026-06-24 02:32:04.476015+00	Thu ti???n c???c h???p ?????ng	2026-06-24 02:32:04.476015+00	2026-06-26 17:44:00.174165+00	\N	t	\N	\N
45c82967-a604-4eaf-a0da-e47b1085f9d5	f744f5b6-4a22-44ad-acf4-ad0615bff692	eff57238-37a8-4d47-b2e3-6330da3cc531	a672fd3c-0504-42a8-ad47-a5ec0f628e4a	HD178249608459415	2026	6	2026-06-26	2026-06-26	0.00	2700000.00	2700000.00	2700000.00	PAID	2026-07-04	2026-06-26 17:48:04.595487+00	Thu ti???n c???c h???p ?????ng	2026-06-26 17:48:04.596017+00	2026-07-01 19:38:09.602092+00	\N	t	\N	\N
689ffc5b-68db-455d-8507-f41335e29236	3b5a2527-fcdc-41b6-b512-4be49abc8c1b	9b2eaa71-051e-44fd-bb0a-79da454a3c8b	580c70c4-6c6b-4a67-97a1-03d6ccd3d8cc	HD178316758127068	2026	7	2026-07-04	2026-07-04	0.00	2500000.00	2500000.00	0.00	UNPAID	2026-07-11	2026-07-04 12:19:41.270709+00	Thu ti???n c???c h???p ?????ng	2026-07-04 12:19:41.270709+00	2026-07-04 12:19:41.254354+00	\N	t	\N	\N
ec16665e-1a4e-406e-97bb-715ba02c5872	971984c0-9b21-4a99-9c49-408a87942486	d645b12e-de81-4afe-a897-f8f7689d5a38	2f14a85f-ddb6-4182-95ec-75ca5687346f	HD178316808638438	2026	7	2026-07-04	2026-07-04	0.00	2700000.00	2700000.00	2700000.00	PAID	2026-07-11	2026-07-04 12:28:06.384764+00	Thu ti???n c???c h???p ?????ng	2026-07-04 12:28:06.384764+00	2026-07-04 12:36:57.602592+00	\N	t	\N	\N
4b32a371-1a16-4478-a18e-1757f643e163	971984c0-9b21-4a99-9c49-408a87942486	d645b12e-de81-4afe-a897-f8f7689d5a38	2f14a85f-ddb6-4182-95ec-75ca5687346f	HD20260704653	2026	8	2026-08-01	2026-08-30	0.00	6020000.00	6020000.00	0.00	UNPAID	2026-08-07	2026-07-04 12:44:53.841747+00		2026-07-04 12:44:53.841747+00	2026-07-04 12:44:53.838117+00	\N	\N	\N	\N
8cff81b8-d54e-46a4-a59b-790afca1f7b0	971984c0-9b21-4a99-9c49-408a87942486	d645b12e-de81-4afe-a897-f8f7689d5a38	2f14a85f-ddb6-4182-95ec-75ca5687346f	HD20260704169	2026	9	2026-09-01	2026-09-29	6020000.00	5240000.00	11260000.00	0.00	UNPAID	2026-09-10	2026-07-04 12:48:18.896211+00		2026-07-04 12:48:18.896211+00	2026-07-04 12:48:18.890605+00	\N	\N	\N	\N
\.


--
-- Data for Name: hop_dong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.hop_dong (id, phong_id, khach_thue_id, ma_hop_dong, ngay_bat_dau, ngay_ket_thuc, ngay_ket_thuc_thuc_te, gia_thue_hop_dong, tien_coc, trang_thai_coc, trang_thai, chu_ky_thanh_toan, ngay_thanh_toan_hang_thang, tu_dong_gia_han, chi_so_dien_ban_dau, chi_so_nuoc_ban_dau, noi_dung_hop_dong, file_pdf, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc, template_version, previewed_at, confirmed_at, locked_at, signed_pdf_url, tenant_signed_at, landlord_signed_at, signature_status) FROM stdin;
0870facf-e577-4fac-adfe-38cc697b916e	c3d31275-9559-4e7b-b51e-8928ccdc4137	7a660e5a-738b-43da-ae2c-1a15381b7a12	HD-PHONG-101-202606-0841D0	2026-06-24	2026-09-24	\N	2500000.00	2500000.00	NOT_PAID	DRAFT	MONTHLY	5	f	0	0	??I???U KHO???N H???P ?????NG THU?? PH??NG\n\n1. B??N CHO THU?? (Ch??? nh??):\n- Cung c???p ph??ng ??? ?????y ????? ti???n nghi theo th???a thu???n\n- ?????m b???o an ninh, an to??n cho kh??ch thu??\n- B???o tr??, s???a ch???a c??c h?? h???ng do hao m??n t??? nhi??n\n\n2. B??N THU?? (Kh??ch thu??):\n- Thanh to??n ????ng h???n ti???n thu?? v?? c??c chi ph?? kh??c\n- S??? d???ng ph??ng ????ng m???c ????ch, gi??? g??n v??? sinh\n- Kh??ng ???????c c???i t???o, s???a ch???a ph??ng m?? kh??ng c?? s??? ?????ng ??\n- B??o c??o k???p th???i c??c h?? h???ng, s??? c???\n\n3. ??I???U KHO???N CHUNG:\n- Th???i h???n h???p ?????ng: T??? ng??y b???t ?????u ?????n ng??y k???t th??c\n- Ti???n c???c: ???????c ho??n tr??? khi k???t th??c h???p ?????ng (tr??? c??c kho???n ph??t sinh)\n- Thanh to??n: H??ng th??ng v??o ng??y quy ?????nh\n- ??i???n, n?????c: T??nh theo ch??? s??? ?????ng h??? v?? gi?? quy ?????nh\n- Ph?? d???ch v???: Theo th???a thu???n ri??ng\n\n4. CH???M D???T H???P ?????NG:\n- B??n thu?? c?? th??? ch???m d???t h???p ?????ng tr?????c th???i h???n v???i th??ng b??o tr?????c 30 ng??y\n- B??n cho thu?? c?? th??? ch???m d???t h???p ?????ng n???u vi ph???m nghi??m tr???ng\n- Ho??n tr??? ti???n c???c sau khi ki???m tra t??nh tr???ng ph??ng\n\n5. ??I???U KHO???N KH??C:\n- Hai b??n cam k???t th???c hi???n ????ng c??c ??i???u kho???n ???? th???a thu???n\n- M???i tranh ch???p s??? ???????c gi???i quy???t th??ng qua th????ng l?????ng\n- H???p ?????ng c?? hi???u l???c k??? t??? ng??y k??	https://res.cloudinary.com/dd4tyakf3/image/upload/v1782269374/quanlyphongtro/contracts/contract_13429577887217291787.pdf.pdf		2026-06-24 02:46:28.373277+00	2026-06-24 03:08:27.93028+00	2026-06-24 03:08:27.947393+00	\N	\N	\N	\N	\N	\N	2026-06-24 02:49:32.314863+00	LANDLORD_SIGNED
0b4171b4-7b23-4e6d-94d2-1c3165c79472	76e99fea-1dbe-435d-8da3-62ce078007c2	66ff1459-9f98-4506-b6b8-34d9d9ab9d9c	HD-PHONG-103-202606-4E23CF	2026-06-24	2026-09-24	\N	2500000.00	2500000.00	NOT_PAID	PENDING	MONTHLY	5	f	0	0	??I???U KHO???N H???P ?????NG THU?? PH??NG\n\n1. B??N CHO THU?? (Ch??? nh??):\n- Cung c???p ph??ng ??? ?????y ????? ti???n nghi theo th???a thu???n\n- ?????m b???o an ninh, an to??n cho kh??ch thu??\n- B???o tr??, s???a ch???a c??c h?? h???ng do hao m??n t??? nhi??n\n\n2. B??N THU?? (Kh??ch thu??):\n- Thanh to??n ????ng h???n ti???n thu?? v?? c??c chi ph?? kh??c\n- S??? d???ng ph??ng ????ng m???c ????ch, gi??? g??n v??? sinh\n- Kh??ng ???????c c???i t???o, s???a ch???a ph??ng m?? kh??ng c?? s??? ?????ng ??\n- B??o c??o k???p th???i c??c h?? h???ng, s??? c???\n\n3. ??I???U KHO???N CHUNG:\n- Th???i h???n h???p ?????ng: T??? ng??y b???t ?????u ?????n ng??y k???t th??c\n- Ti???n c???c: ???????c ho??n tr??? khi k???t th??c h???p ?????ng (tr??? c??c kho???n ph??t sinh)\n- Thanh to??n: H??ng th??ng v??o ng??y quy ?????nh\n- ??i???n, n?????c: T??nh theo ch??? s??? ?????ng h??? v?? gi?? quy ?????nh\n- Ph?? d???ch v???: Theo th???a thu???n ri??ng\n\n4. CH???M D???T H???P ?????NG:\n- B??n thu?? c?? th??? ch???m d???t h???p ?????ng tr?????c th???i h???n v???i th??ng b??o tr?????c 30 ng??y\n- B??n cho thu?? c?? th??? ch???m d???t h???p ?????ng n???u vi ph???m nghi??m tr???ng\n- Ho??n tr??? ti???n c???c sau khi ki???m tra t??nh tr???ng ph??ng\n\n5. ??I???U KHO???N KH??C:\n- Hai b??n cam k???t th???c hi???n ????ng c??c ??i???u kho???n ???? th???a thu???n\n- M???i tranh ch???p s??? ???????c gi???i quy???t th??ng qua th????ng l?????ng\n- H???p ?????ng c?? hi???u l???c k??? t??? ng??y k??	https://res.cloudinary.com/dd4tyakf3/image/upload/v1782273019/quanlyphongtro/contracts/contract_8167883260993164640.pdf.pdf		2026-06-24 03:35:32.306075+00	2026-06-24 03:51:20.13802+00	2026-06-24 03:51:20.147241+00	\N	\N	\N	\N	\N	\N	2026-06-24 03:50:18.656937+00	LANDLORD_SIGNED
387200fe-0565-4591-bbef-71300cc7dcf5	f9f371b2-eadc-424f-97e1-bbb28d158826	763cc66e-a785-4c1f-9008-0ed2c4228213	HD-PHONG-102-202606-4F9435	2026-06-24	2026-09-24	2026-06-27	2500000.00	2500000.00	KEPT	TERMINATED	MONTHLY	5	f	0	0	??I???U KHO???N H???P ?????NG THU?? PH??NG\n\n1. B??N CHO THU?? (Ch??? nh??):\n- Cung c???p ph??ng ??? ?????y ????? ti???n nghi theo th???a thu???n\n- ?????m b???o an ninh, an to??n cho kh??ch thu??\n- B???o tr??, s???a ch???a c??c h?? h???ng do hao m??n t??? nhi??n\n\n2. B??N THU?? (Kh??ch thu??):\n- Thanh to??n ????ng h???n ti???n thu?? v?? c??c chi ph?? kh??c\n- S??? d???ng ph??ng ????ng m???c ????ch, gi??? g??n v??? sinh\n- Kh??ng ???????c c???i t???o, s???a ch???a ph??ng m?? kh??ng c?? s??? ?????ng ??\n- B??o c??o k???p th???i c??c h?? h???ng, s??? c???\n\n3. ??I???U KHO???N CHUNG:\n- Th???i h???n h???p ?????ng: T??? ng??y b???t ?????u ?????n ng??y k???t th??c\n- Ti???n c???c: ???????c ho??n tr??? khi k???t th??c h???p ?????ng (tr??? c??c kho???n ph??t sinh)\n- Thanh to??n: H??ng th??ng v??o ng??y quy ?????nh\n- ??i???n, n?????c: T??nh theo ch??? s??? ?????ng h??? v?? gi?? quy ?????nh\n- Ph?? d???ch v???: Theo th???a thu???n ri??ng\n\n4. CH???M D???T H???P ?????NG:\n- B??n thu?? c?? th??? ch???m d???t h???p ?????ng tr?????c th???i h???n v???i th??ng b??o tr?????c 30 ng??y\n- B??n cho thu?? c?? th??? ch???m d???t h???p ?????ng n???u vi ph???m nghi??m tr???ng\n- Ho??n tr??? ti???n c???c sau khi ki???m tra t??nh tr???ng ph??ng\n\n5. ??I???U KHO???N KH??C:\n- Hai b??n cam k???t th???c hi???n ????ng c??c ??i???u kho???n ???? th???a thu???n\n- M???i tranh ch???p s??? ???????c gi???i quy???t th??ng qua th????ng l?????ng\n- H???p ?????ng c?? hi???u l???c k??? t??? ng??y k??	https://res.cloudinary.com/dd4tyakf3/image/upload/v1782270803/quanlyphongtro/contracts/contract_10756444292910221400.pdf.pdf	K???t th??c h???p ?????ng t??? danh s??ch	2026-06-24 03:13:01.128193+00	2026-06-26 17:44:36.080753+00	\N	\N	\N	\N	\N	\N	\N	2026-06-24 03:13:22.357382+00	LANDLORD_SIGNED
5f6b7466-f3f0-4a53-bd5c-072712c119de	96180a6a-af82-4fe1-ae2d-5ba0a1ae384d	7a660e5a-738b-43da-ae2c-1a15381b7a12	HD-PHONG-101-202606-C48300	2026-06-24	2026-09-24	2026-06-27	3000000.00	3000000.00	KEPT	TERMINATED	MONTHLY	5	f	0	0	H???P ?????NG THU?? PH??NG\n\nM?? h???p ?????ng: HD-PHONG-101-202606-C48300\nT??a nh??: HH1A\nPh??ng: Ph??ng 101\nKh??ch thu?? ?????i di???n: nguy???n v??n h??\nTh???i h???n: 2026-06-24 ?????n 2026-09-24\nGi?? thu??: 3000000.00\nTi???n c???c: 3000000.00\nNg??y thanh to??n h???ng th??ng: 5\n\nN???i dung n??y ???????c sinh t??? template default-v1 ????? ph???c v??? b?????c xem tr?????c h???p ?????ng.\n	\N	K???t th??c h???p ?????ng t??? danh s??ch	2026-06-24 02:32:04.457267+00	2026-06-26 17:44:38.785003+00	\N	default-v1	2026-06-24 02:33:28.498145+00	2026-06-24 02:36:42.969538+00	2026-06-24 02:36:42.969538+00	\N	\N	\N	UNSIGNED
b486f460-d177-4d31-9a6d-0d25621bfaf6	f96050ad-d946-46d6-a055-9a5692946237	808ec20a-5f93-4a22-86a2-40fef4f756e8	HD-PHONG-202-202606-456032	2026-06-24	2026-09-24	2026-06-27	2700000.00	2700000.00	KEPT	TERMINATED	MONTHLY	5	f	0	0	??I???U KHO???N H???P ?????NG THU?? PH??NG\n\n1. B??N CHO THU?? (Ch??? nh??):\n- Cung c???p ph??ng ??? ?????y ????? ti???n nghi theo th???a thu???n\n- ?????m b???o an ninh, an to??n cho kh??ch thu??\n- B???o tr??, s???a ch???a c??c h?? h???ng do hao m??n t??? nhi??n\n\n2. B??N THU?? (Kh??ch thu??):\n- Thanh to??n ????ng h???n ti???n thu?? v?? c??c chi ph?? kh??c\n- S??? d???ng ph??ng ????ng m???c ????ch, gi??? g??n v??? sinh\n- Kh??ng ???????c c???i t???o, s???a ch???a ph??ng m?? kh??ng c?? s??? ?????ng ??\n- B??o c??o k???p th???i c??c h?? h???ng, s??? c???\n\n3. ??I???U KHO???N CHUNG:\n- Th???i h???n h???p ?????ng: T??? ng??y b???t ?????u ?????n ng??y k???t th??c\n- Ti???n c???c: ???????c ho??n tr??? khi k???t th??c h???p ?????ng (tr??? c??c kho???n ph??t sinh)\n- Thanh to??n: H??ng th??ng v??o ng??y quy ?????nh\n- ??i???n, n?????c: T??nh theo ch??? s??? ?????ng h??? v?? gi?? quy ?????nh\n- Ph?? d???ch v???: Theo th???a thu???n ri??ng\n\n4. CH???M D???T H???P ?????NG:\n- B??n thu?? c?? th??? ch???m d???t h???p ?????ng tr?????c th???i h???n v???i th??ng b??o tr?????c 30 ng??y\n- B??n cho thu?? c?? th??? ch???m d???t h???p ?????ng n???u vi ph???m nghi??m tr???ng\n- Ho??n tr??? ti???n c???c sau khi ki???m tra t??nh tr???ng ph??ng\n\n5. ??I???U KHO???N KH??C:\n- Hai b??n cam k???t th???c hi???n ????ng c??c ??i???u kho???n ???? th???a thu???n\n- M???i tranh ch???p s??? ???????c gi???i quy???t th??ng qua th????ng l?????ng\n- H???p ?????ng c?? hi???u l???c k??? t??? ng??y k??	https://res.cloudinary.com/dd4tyakf3/image/upload/v1782273230/quanlyphongtro/contracts/contract_9446999650209001358.pdf.pdf	K???t th??c h???p ?????ng t??? danh s??ch	2026-06-24 03:51:56.117105+00	2026-06-26 17:44:33.178251+00	\N	\N	\N	2026-06-24 03:57:06.863652+00	2026-06-24 03:57:06.863652+00	https://res.cloudinary.com/dd4tyakf3/image/upload/v1782273427/quanlyphongtro/contracts/contract_13232438803804747342.pdf.pdf	2026-06-24 03:57:06.863652+00	2026-06-24 03:53:49.701083+00	COMPLETED
fa05907e-eefc-49f9-a255-cce5ba87d9f0	0045aaf1-97a5-4987-83ed-0aaec9ab162d	a672fd3c-0504-42a8-ad47-a5ec0f628e4a	HD-PHONG-305-202606-CCA7A3	2026-06-24	2026-09-24	2026-06-27	2500000.00	2500000.00	KEPT	TERMINATED	MONTHLY	5	f	0	0	??I???U KHO???N H???P ?????NG THU?? PH??NG\n\n1. B??N CHO THU?? (Ch??? nh??):\n- Cung c???p ph??ng ??? ?????y ????? ti???n nghi theo th???a thu???n\n- ?????m b???o an ninh, an to??n cho kh??ch thu??\n- B???o tr??, s???a ch???a c??c h?? h???ng do hao m??n t??? nhi??n\n\n2. B??N THU?? (Kh??ch thu??):\n- Thanh to??n ????ng h???n ti???n thu?? v?? c??c chi ph?? kh??c\n- S??? d???ng ph??ng ????ng m???c ????ch, gi??? g??n v??? sinh\n- Kh??ng ???????c c???i t???o, s???a ch???a ph??ng m?? kh??ng c?? s??? ?????ng ??\n- B??o c??o k???p th???i c??c h?? h???ng, s??? c???\n\n3. ??I???U KHO???N CHUNG:\n- Th???i h???n h???p ?????ng: T??? ng??y b???t ?????u ?????n ng??y k???t th??c\n- Ti???n c???c: ???????c ho??n tr??? khi k???t th??c h???p ?????ng (tr??? c??c kho???n ph??t sinh)\n- Thanh to??n: H??ng th??ng v??o ng??y quy ?????nh\n- ??i???n, n?????c: T??nh theo ch??? s??? ?????ng h??? v?? gi?? quy ?????nh\n- Ph?? d???ch v???: Theo th???a thu???n ri??ng\n\n4. CH???M D???T H???P ?????NG:\n- B??n thu?? c?? th??? ch???m d???t h???p ?????ng tr?????c th???i h???n v???i th??ng b??o tr?????c 30 ng??y\n- B??n cho thu?? c?? th??? ch???m d???t h???p ?????ng n???u vi ph???m nghi??m tr???ng\n- Ho??n tr??? ti???n c???c sau khi ki???m tra t??nh tr???ng ph??ng\n\n5. ??I???U KHO???N KH??C:\n- Hai b??n cam k???t th???c hi???n ????ng c??c ??i???u kho???n ???? th???a thu???n\n- M???i tranh ch???p s??? ???????c gi???i quy???t th??ng qua th????ng l?????ng\n- H???p ?????ng c?? hi???u l???c k??? t??? ng??y k??	https://res.cloudinary.com/dd4tyakf3/image/upload/v1782273991/quanlyphongtro/contracts/contract_17683614809475571372.pdf.pdf	K???t th??c h???p ?????ng t??? danh s??ch	2026-06-24 04:05:40.817256+00	2026-06-26 17:44:28.959371+00	\N	\N	\N	2026-06-24 04:07:51.108361+00	2026-06-24 04:07:51.108361+00	https://res.cloudinary.com/dd4tyakf3/image/upload/v1782274072/quanlyphongtro/contracts/contract_10683717519545414346.pdf.pdf	2026-06-24 04:07:51.108361+00	2026-06-24 04:06:30.172551+00	COMPLETED
f744f5b6-4a22-44ad-acf4-ad0615bff692	eff57238-37a8-4d47-b2e3-6330da3cc531	a672fd3c-0504-42a8-ad47-a5ec0f628e4a	HD-PHONG-203-202606-20C4B8	2026-06-26	2026-09-26	2026-07-04	2700000.00	2700000.00	KEPT	TERMINATED	MONTHLY	5	f	0	0	??I???U KHO???N H???P ?????NG THU?? PH??NG\n\n1. B??N CHO THU?? (Ch??? nh??):\n- Cung c???p ph??ng ??? ?????y ????? ti???n nghi theo th???a thu???n\n- ?????m b???o an ninh, an to??n cho kh??ch thu??\n- B???o tr??, s???a ch???a c??c h?? h???ng do hao m??n t??? nhi??n\n\n2. B??N THU?? (Kh??ch thu??):\n- Thanh to??n ????ng h???n ti???n thu?? v?? c??c chi ph?? kh??c\n- S??? d???ng ph??ng ????ng m???c ????ch, gi??? g??n v??? sinh\n- Kh??ng ???????c c???i t???o, s???a ch???a ph??ng m?? kh??ng c?? s??? ?????ng ??\n- B??o c??o k???p th???i c??c h?? h???ng, s??? c???\n\n3. ??I???U KHO???N CHUNG:\n- Th???i h???n h???p ?????ng: T??? ng??y b???t ?????u ?????n ng??y k???t th??c\n- Ti???n c???c: ???????c ho??n tr??? khi k???t th??c h???p ?????ng (tr??? c??c kho???n ph??t sinh)\n- Thanh to??n: H??ng th??ng v??o ng??y quy ?????nh\n- ??i???n, n?????c: T??nh theo ch??? s??? ?????ng h??? v?? gi?? quy ?????nh\n- Ph?? d???ch v???: Theo th???a thu???n ri??ng\n\n4. CH???M D???T H???P ?????NG:\n- B??n thu?? c?? th??? ch???m d???t h???p ?????ng tr?????c th???i h???n v???i th??ng b??o tr?????c 30 ng??y\n- B??n cho thu?? c?? th??? ch???m d???t h???p ?????ng n???u vi ph???m nghi??m tr???ng\n- Ho??n tr??? ti???n c???c sau khi ki???m tra t??nh tr???ng ph??ng\n\n5. ??I???U KHO???N KH??C:\n- Hai b??n cam k???t th???c hi???n ????ng c??c ??i???u kho???n ???? th???a thu???n\n- M???i tranh ch???p s??? ???????c gi???i quy???t th??ng qua th????ng l?????ng\n- H???p ?????ng c?? hi???u l???c k??? t??? ng??y k??	\N	K???t th??c h???p ?????ng t??? danh s??ch	2026-06-26 17:48:04.558586+00	2026-07-04 12:18:47.142228+00	\N	default-v1	\N	2026-06-26 17:48:18.57392+00	2026-06-26 17:48:18.57392+00	\N	\N	\N	UNSIGNED
1df72449-7386-4e4a-82a1-89c55d648645	6d6fd936-15ae-4558-a606-6f11000279da	580c70c4-6c6b-4a67-97a1-03d6ccd3d8cc	HD-PHONG-101-202607-5BD86C	2026-07-04	2026-10-04	\N	2500000.00	2500000.00	NOT_PAID	PENDING	MONTHLY	5	f	0	0	??I???U KHO???N H???P ?????NG THU?? PH??NG\n\n1. B??N CHO THU?? (Ch??? nh??):\n- Cung c???p ph??ng ??? ?????y ????? ti???n nghi theo th???a thu???n\n- ?????m b???o an ninh, an to??n cho kh??ch thu??\n- B???o tr??, s???a ch???a c??c h?? h???ng do hao m??n t??? nhi??n\n\n2. B??N THU?? (Kh??ch thu??):\n- Thanh to??n ????ng h???n ti???n thu?? v?? c??c chi ph?? kh??c\n- S??? d???ng ph??ng ????ng m???c ????ch, gi??? g??n v??? sinh\n- Kh??ng ???????c c???i t???o, s???a ch???a ph??ng m?? kh??ng c?? s??? ?????ng ??\n- B??o c??o k???p th???i c??c h?? h???ng, s??? c???\n\n3. ??I???U KHO???N CHUNG:\n- Th???i h???n h???p ?????ng: T??? ng??y b???t ?????u ?????n ng??y k???t th??c\n- Ti???n c???c: ???????c ho??n tr??? khi k???t th??c h???p ?????ng (tr??? c??c kho???n ph??t sinh)\n- Thanh to??n: H??ng th??ng v??o ng??y quy ?????nh\n- ??i???n, n?????c: T??nh theo ch??? s??? ?????ng h??? v?? gi?? quy ?????nh\n- Ph?? d???ch v???: Theo th???a thu???n ri??ng\n\n4. CH???M D???T H???P ?????NG:\n- B??n thu?? c?? th??? ch???m d???t h???p ?????ng tr?????c th???i h???n v???i th??ng b??o tr?????c 30 ng??y\n- B??n cho thu?? c?? th??? ch???m d???t h???p ?????ng n???u vi ph???m nghi??m tr???ng\n- Ho??n tr??? ti???n c???c sau khi ki???m tra t??nh tr???ng ph??ng\n\n5. ??I???U KHO???N KH??C:\n- Hai b??n cam k???t th???c hi???n ????ng c??c ??i???u kho???n ???? th???a thu???n\n- M???i tranh ch???p s??? ???????c gi???i quy???t th??ng qua th????ng l?????ng\n- H???p ?????ng c?? hi???u l???c k??? t??? ng??y k??	\N		2026-07-04 12:15:27.834945+00	2026-07-04 12:18:51.678263+00	2026-07-04 12:18:51.682575+00	\N	\N	\N	\N	\N	\N	\N	UNSIGNED
971984c0-9b21-4a99-9c49-408a87942486	d645b12e-de81-4afe-a897-f8f7689d5a38	2f14a85f-ddb6-4182-95ec-75ca5687346f	HD-PHONG-202-202607-C89B28	2026-07-04	2026-10-04	\N	2700000.00	2700000.00	NOT_PAID	ACTIVE	MONTHLY	5	f	0	0	??I???U KHO???N H???P ?????NG THU?? PH??NG\n\n1. B??N CHO THU?? (Ch??? nh??):\n- Cung c???p ph??ng ??? ?????y ????? ti???n nghi theo th???a thu???n\n- ?????m b???o an ninh, an to??n cho kh??ch thu??\n- B???o tr??, s???a ch???a c??c h?? h???ng do hao m??n t??? nhi??n\n\n2. B??N THU?? (Kh??ch thu??):\n- Thanh to??n ????ng h???n ti???n thu?? v?? c??c chi ph?? kh??c\n- S??? d???ng ph??ng ????ng m???c ????ch, gi??? g??n v??? sinh\n- Kh??ng ???????c c???i t???o, s???a ch???a ph??ng m?? kh??ng c?? s??? ?????ng ??\n- B??o c??o k???p th???i c??c h?? h???ng, s??? c???\n\n3. ??I???U KHO???N CHUNG:\n- Th???i h???n h???p ?????ng: T??? ng??y b???t ?????u ?????n ng??y k???t th??c\n- Ti???n c???c: ???????c ho??n tr??? khi k???t th??c h???p ?????ng (tr??? c??c kho???n ph??t sinh)\n- Thanh to??n: H??ng th??ng v??o ng??y quy ?????nh\n- ??i???n, n?????c: T??nh theo ch??? s??? ?????ng h??? v?? gi?? quy ?????nh\n- Ph?? d???ch v???: Theo th???a thu???n ri??ng\n\n4. CH???M D???T H???P ?????NG:\n- B??n thu?? c?? th??? ch???m d???t h???p ?????ng tr?????c th???i h???n v???i th??ng b??o tr?????c 30 ng??y\n- B??n cho thu?? c?? th??? ch???m d???t h???p ?????ng n???u vi ph???m nghi??m tr???ng\n- Ho??n tr??? ti???n c???c sau khi ki???m tra t??nh tr???ng ph??ng\n\n5. ??I???U KHO???N KH??C:\n- Hai b??n cam k???t th???c hi???n ????ng c??c ??i???u kho???n ???? th???a thu???n\n- M???i tranh ch???p s??? ???????c gi???i quy???t th??ng qua th????ng l?????ng\n- H???p ?????ng c?? hi???u l???c k??? t??? ng??y k??	\N		2026-07-04 12:28:06.367067+00	2026-07-04 12:29:51.016263+00	\N	default-v1	\N	2026-07-04 12:29:51.022968+00	2026-07-04 12:29:51.022968+00	\N	\N	\N	UNSIGNED
3b5a2527-fcdc-41b6-b512-4be49abc8c1b	9b2eaa71-051e-44fd-bb0a-79da454a3c8b	580c70c4-6c6b-4a67-97a1-03d6ccd3d8cc	HD-PHONG-102-202607-973B80	2026-07-04	2026-10-04	\N	2500000.00	2500000.00	NOT_PAID	ACTIVE	MONTHLY	5	f	0	0	??I???U KHO???N H???P ?????NG THU?? PH??NG\n\n1. B??N CHO THU?? (Ch??? nh??):\n- Cung c???p ph??ng ??? ?????y ????? ti???n nghi theo th???a thu???n\n- ?????m b???o an ninh, an to??n cho kh??ch thu??\n- B???o tr??, s???a ch???a c??c h?? h???ng do hao m??n t??? nhi??n\n\n2. B??N THU?? (Kh??ch thu??):\n- Thanh to??n ????ng h???n ti???n thu?? v?? c??c chi ph?? kh??c\n- S??? d???ng ph??ng ????ng m???c ????ch, gi??? g??n v??? sinh\n- Kh??ng ???????c c???i t???o, s???a ch???a ph??ng m?? kh??ng c?? s??? ?????ng ??\n- B??o c??o k???p th???i c??c h?? h???ng, s??? c???\n\n3. ??I???U KHO???N CHUNG:\n- Th???i h???n h???p ?????ng: T??? ng??y b???t ?????u ?????n ng??y k???t th??c\n- Ti???n c???c: ???????c ho??n tr??? khi k???t th??c h???p ?????ng (tr??? c??c kho???n ph??t sinh)\n- Thanh to??n: H??ng th??ng v??o ng??y quy ?????nh\n- ??i???n, n?????c: T??nh theo ch??? s??? ?????ng h??? v?? gi?? quy ?????nh\n- Ph?? d???ch v???: Theo th???a thu???n ri??ng\n\n4. CH???M D???T H???P ?????NG:\n- B??n thu?? c?? th??? ch???m d???t h???p ?????ng tr?????c th???i h???n v???i th??ng b??o tr?????c 30 ng??y\n- B??n cho thu?? c?? th??? ch???m d???t h???p ?????ng n???u vi ph???m nghi??m tr???ng\n- Ho??n tr??? ti???n c???c sau khi ki???m tra t??nh tr???ng ph??ng\n\n5. ??I???U KHO???N KH??C:\n- Hai b??n cam k???t th???c hi???n ????ng c??c ??i???u kho???n ???? th???a thu???n\n- M???i tranh ch???p s??? ???????c gi???i quy???t th??ng qua th????ng l?????ng\n- H???p ?????ng c?? hi???u l???c k??? t??? ng??y k??	\N		2026-07-04 12:19:41.258656+00	2026-07-07 04:40:36.885156+00	\N	default-v1	\N	2026-07-07 04:40:36.891462+00	2026-07-07 04:40:36.891462+00	\N	\N	\N	UNSIGNED
bb9fdaee-6918-447b-969c-4950a8ef0a30	660c9c25-bf4b-4822-8ef8-4c73292c9434	2f14a85f-ddb6-4182-95ec-75ca5687346f	HD-PHONG-201-202607-936AEF	2026-07-07	2026-10-07	\N	2700000.00	2700000.00	NOT_PAID	ACTIVE	MONTHLY	5	f	0	0	??I???U KHO???N H???P ?????NG THU?? PH??NG\n\n1. B??N CHO THU?? (Ch??? nh??):\n- Cung c???p ph??ng ??? ?????y ????? ti???n nghi theo th???a thu???n\n- ?????m b???o an ninh, an to??n cho kh??ch thu??\n- B???o tr??, s???a ch???a c??c h?? h???ng do hao m??n t??? nhi??n\n\n2. B??N THU?? (Kh??ch thu??):\n- Thanh to??n ????ng h???n ti???n thu?? v?? c??c chi ph?? kh??c\n- S??? d???ng ph??ng ????ng m???c ????ch, gi??? g??n v??? sinh\n- Kh??ng ???????c c???i t???o, s???a ch???a ph??ng m?? kh??ng c?? s??? ?????ng ??\n- B??o c??o k???p th???i c??c h?? h???ng, s??? c???\n\n3. ??I???U KHO???N CHUNG:\n- Th???i h???n h???p ?????ng: T??? ng??y b???t ?????u ?????n ng??y k???t th??c\n- Ti???n c???c: ???????c ho??n tr??? khi k???t th??c h???p ?????ng (tr??? c??c kho???n ph??t sinh)\n- Thanh to??n: H??ng th??ng v??o ng??y quy ?????nh\n- ??i???n, n?????c: T??nh theo ch??? s??? ?????ng h??? v?? gi?? quy ?????nh\n- Ph?? d???ch v???: Theo th???a thu???n ri??ng\n\n4. CH???M D???T H???P ?????NG:\n- B??n thu?? c?? th??? ch???m d???t h???p ?????ng tr?????c th???i h???n v???i th??ng b??o tr?????c 30 ng??y\n- B??n cho thu?? c?? th??? ch???m d???t h???p ?????ng n???u vi ph???m nghi??m tr???ng\n- Ho??n tr??? ti???n c???c sau khi ki???m tra t??nh tr???ng ph??ng\n\n5. ??I???U KHO???N KH??C:\n- Hai b??n cam k???t th???c hi???n ????ng c??c ??i???u kho???n ???? th???a thu???n\n- M???i tranh ch???p s??? ???????c gi???i quy???t th??ng qua th????ng l?????ng\n- H???p ?????ng c?? hi???u l???c k??? t??? ng??y k??	\N		2026-07-07 04:52:38.057534+00	2026-07-07 04:53:14.043895+00	\N	default-v1	\N	2026-07-07 04:53:14.050192+00	2026-07-07 04:53:14.050192+00	\N	\N	\N	UNSIGNED
\.


--
-- Data for Name: invoice_generation_batch; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.invoice_generation_batch (id, nha_tro_id, ky_thang, ky_nam, trang_thai, tong_hop_dong, tao_thanh_cong, bo_qua, loi, nguoi_tao_id, tao_luc) FROM stdin;
\.


--
-- Data for Name: invoice_generation_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.invoice_generation_log (id, batch_id, hop_dong_id, hoa_don_id, status, reason, tao_luc) FROM stdin;
\.


--
-- Data for Name: khach_thue; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.khach_thue (id, nguoi_dung_id, chu_tro_id, ho_ten, so_dien_thoai, email, so_cccd, ngay_sinh, gioi_tinh, dia_chi, que_quan, nghe_nghiep, ghi_chu, dang_hoat_dong, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
66ff1459-9f98-4506-b6b8-34d9d9ab9d9c	ffba4a1a-b837-44d1-b647-cbcc4a5ddac9	dddfb501-3d25-4517-ac58-1b9225e85cb3	linh nguy???n	0989903903		099999999989	2026-06-18	nam	\N	H?? N???i	Sinh Vi??n	\N	t	2026-06-24 03:35:25.759451+00	2026-06-24 03:51:13.711997+00	2026-06-24 03:51:13.714663+00
a672fd3c-0504-42a8-ad47-a5ec0f628e4a	4deb410a-cef3-4ab5-b13f-a66ba1b5cd9b	dddfb501-3d25-4517-ac58-1b9225e85cb3	Chung ho??ng	0798638798	\N	099999999877	\N	\N	\N	\N	\N	\N	t	2026-06-24 04:05:22.438354+00	2026-06-24 04:05:22.438354+00	\N
7a660e5a-738b-43da-ae2c-1a15381b7a12	\N	dddfb501-3d25-4517-ac58-1b9225e85cb3	nguy???n v??n h??	0396833875	docong989@icloud.com	066206004084	2006-01-06	nam	\N	B???c Giang	Sinh Vi??n	\N	t	2026-06-24 02:27:55.601851+00	2026-07-04 12:12:32.301732+00	2026-07-04 12:12:32.305472+00
763cc66e-a785-4c1f-9008-0ed2c4228213	11a616e8-e290-476f-ac28-fcef0466f571	dddfb501-3d25-4517-ac58-1b9225e85cb3	l?? v??n minh	0357165018		066206004088	2026-06-13	nam	\N	H?? N???i	Sinh Vi??n	\N	t	2026-06-24 03:12:45.216844+00	2026-07-04 12:12:36.809356+00	2026-07-04 12:12:36.811876+00
808ec20a-5f93-4a22-86a2-40fef4f756e8	94f1325a-40ea-450c-945d-bcc97edf175c	dddfb501-3d25-4517-ac58-1b9225e85cb3	chung linh	0989903901	\N	066206004056	\N	\N	\N	\N	\N	\N	t	2026-06-24 03:51:50.73265+00	2026-07-04 12:12:41.793905+00	2026-07-04 12:12:41.796419+00
580c70c4-6c6b-4a67-97a1-03d6ccd3d8cc	8faf0189-da59-48bd-a1ed-89f446fc22e3	dddfb501-3d25-4517-ac58-1b9225e85cb3	h??ng th??? tr??c giang	0357165019	gtruc2146@gmail.com	066206005084	2005-05-23	nu	\N	C???n Th??	Bartender	\N	t	2026-07-04 12:14:02.009735+00	2026-07-04 12:14:02.009735+00	\N
2f14a85f-ddb6-4182-95ec-75ca5687346f	3a8892b9-bb34-4524-8500-7be7e88b1de5	dddfb501-3d25-4517-ac58-1b9225e85cb3	H?? V??n Linh	0396822875	\N	066206007804	\N	\N	\N	\N	\N	\N	t	2026-07-04 12:26:12.921844+00	2026-07-04 12:26:12.921844+00	\N
\.


--
-- Data for Name: lich_hen; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lich_hen (id, phong_id, nguoi_dung_id, ho_ten, so_dien_thoai, email, ngay_hen, trang_thai, google_calendar_event_id, da_gui_nhac_nho, ghi_chu, tao_luc, cap_nhat_luc, ghi_chu_admin, so_cccd) FROM stdin;
860d814c-1a58-40c1-9a3e-18b52b975c87	660c9c25-bf4b-4822-8ef8-4c73292c9434	\N	????? ch?? c??ng	0369963725	docong989@gmail.com	2026-07-09 23:00:00+00	CONFIRMED	\N	f		2026-07-04 12:50:57.412146+00	2026-07-04 12:51:38.931073+00	\N	
\.


--
-- Data for Name: lich_su_hoa_don; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lich_su_hoa_don (id, hoa_don_id, trang_thai_truoc, trang_thai_moi, nguoi_thay_doi_id, ghi_chu, tao_luc) FROM stdin;
\.


--
-- Data for Name: lich_thanh_toan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lich_thanh_toan (id, hop_dong_id, ky_nam, ky_thang, tu_ngay, den_ngay, han_thanh_toan, so_tien_du_kien, hoa_don_id, trang_thai, ghi_chu, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
b44bdfc0-7fae-4fbf-a099-26698bcb1652	5f6b7466-f3f0-4a53-bd5c-072712c119de	2026	6	2026-06-24	2026-06-30	2026-06-24	3000000.00	\N	PENDING	\N	2026-06-24 02:36:42.962117+00	2026-06-24 02:36:42.962117+00	\N
3c7eb40f-f55f-45d6-9d0e-28b5e460baaa	5f6b7466-f3f0-4a53-bd5c-072712c119de	2026	7	2026-07-01	2026-07-31	2026-07-05	3000000.00	\N	PENDING	\N	2026-06-24 02:36:42.962117+00	2026-06-24 02:36:42.962117+00	\N
f0fc84a4-2668-4205-beca-1e9739911e4e	5f6b7466-f3f0-4a53-bd5c-072712c119de	2026	8	2026-08-01	2026-08-31	2026-08-05	3000000.00	\N	PENDING	\N	2026-06-24 02:36:42.962117+00	2026-06-24 02:36:42.962117+00	\N
d80b88cd-2cbb-4129-be8e-70d3754e49ce	5f6b7466-f3f0-4a53-bd5c-072712c119de	2026	9	2026-09-01	2026-09-24	2026-09-05	3000000.00	\N	PENDING	\N	2026-06-24 02:36:42.962117+00	2026-06-24 02:36:42.962117+00	\N
4378596e-4701-46a1-8a63-9ad51794a82a	b486f460-d177-4d31-9a6d-0d25621bfaf6	2026	6	2026-06-24	2026-06-30	2026-06-24	2700000.00	\N	PENDING	\N	2026-06-24 03:57:06.863346+00	2026-06-24 03:57:06.863346+00	\N
058b1e01-6eea-4d54-9100-b4d8d279c74a	b486f460-d177-4d31-9a6d-0d25621bfaf6	2026	7	2026-07-01	2026-07-31	2026-07-05	2700000.00	\N	PENDING	\N	2026-06-24 03:57:06.863346+00	2026-06-24 03:57:06.863346+00	\N
3d7835a4-7c4a-484c-a459-e8f010449cb6	b486f460-d177-4d31-9a6d-0d25621bfaf6	2026	8	2026-08-01	2026-08-31	2026-08-05	2700000.00	\N	PENDING	\N	2026-06-24 03:57:06.863346+00	2026-06-24 03:57:06.863346+00	\N
24cbad7c-b59c-4619-bc1b-504ac69fbab0	b486f460-d177-4d31-9a6d-0d25621bfaf6	2026	9	2026-09-01	2026-09-24	2026-09-05	2700000.00	\N	PENDING	\N	2026-06-24 03:57:06.863346+00	2026-06-24 03:57:06.863346+00	\N
e041e847-01ae-46f3-987a-8a8b9c172f93	fa05907e-eefc-49f9-a255-cce5ba87d9f0	2026	6	2026-06-24	2026-06-30	2026-06-24	2500000.00	\N	PENDING	\N	2026-06-24 04:07:51.106584+00	2026-06-24 04:07:51.106584+00	\N
07808676-8c14-478c-839a-cf151d8bc1e3	fa05907e-eefc-49f9-a255-cce5ba87d9f0	2026	7	2026-07-01	2026-07-31	2026-07-05	2500000.00	\N	PENDING	\N	2026-06-24 04:07:51.106584+00	2026-06-24 04:07:51.106584+00	\N
e6f1ec7d-4dfa-4ca9-9a2f-9a22b0125713	fa05907e-eefc-49f9-a255-cce5ba87d9f0	2026	8	2026-08-01	2026-08-31	2026-08-05	2500000.00	\N	PENDING	\N	2026-06-24 04:07:51.106584+00	2026-06-24 04:07:51.106584+00	\N
cc642b35-3af6-4403-9687-7a90363c2c33	fa05907e-eefc-49f9-a255-cce5ba87d9f0	2026	9	2026-09-01	2026-09-24	2026-09-05	2500000.00	\N	PENDING	\N	2026-06-24 04:07:51.106584+00	2026-06-24 04:07:51.106584+00	\N
2a927394-7f53-427f-968a-0857663ca45c	f744f5b6-4a22-44ad-acf4-ad0615bff692	2026	6	2026-06-26	2026-06-30	2026-06-26	2700000.00	\N	PENDING	\N	2026-06-26 17:48:18.56613+00	2026-06-26 17:48:18.56613+00	\N
e6970bab-d02a-4692-9cc6-0b9ad90493ef	f744f5b6-4a22-44ad-acf4-ad0615bff692	2026	7	2026-07-01	2026-07-31	2026-07-05	2700000.00	\N	PENDING	\N	2026-06-26 17:48:18.56613+00	2026-06-26 17:48:18.56613+00	\N
b05c0480-fdeb-4a73-b51f-6afc963ffa88	f744f5b6-4a22-44ad-acf4-ad0615bff692	2026	8	2026-08-01	2026-08-31	2026-08-05	2700000.00	\N	PENDING	\N	2026-06-26 17:48:18.56613+00	2026-06-26 17:48:18.56613+00	\N
4e66e39d-e51c-431d-95fa-658e0a6fbf24	f744f5b6-4a22-44ad-acf4-ad0615bff692	2026	9	2026-09-01	2026-09-26	2026-09-05	2700000.00	\N	PENDING	\N	2026-06-26 17:48:18.56613+00	2026-06-26 17:48:18.56613+00	\N
417b9cd7-0c0c-477a-af91-2f39fd85a12b	971984c0-9b21-4a99-9c49-408a87942486	2026	7	2026-07-04	2026-07-31	2026-07-05	2700000.00	\N	PENDING	\N	2026-07-04 12:29:51.016263+00	2026-07-04 12:29:51.016263+00	\N
48f03c4b-9bad-47b2-8b43-d0197671a4b0	971984c0-9b21-4a99-9c49-408a87942486	2026	8	2026-08-01	2026-08-31	2026-08-05	2700000.00	\N	PENDING	\N	2026-07-04 12:29:51.016263+00	2026-07-04 12:29:51.016263+00	\N
68223d03-1c48-47b9-991f-cb325eaf6f98	971984c0-9b21-4a99-9c49-408a87942486	2026	9	2026-09-01	2026-09-30	2026-09-05	2700000.00	\N	PENDING	\N	2026-07-04 12:29:51.016263+00	2026-07-04 12:29:51.016263+00	\N
b4f768f9-7b88-4b1e-96ca-f422c253a288	971984c0-9b21-4a99-9c49-408a87942486	2026	10	2026-10-01	2026-10-04	2026-10-05	2700000.00	\N	PENDING	\N	2026-07-04 12:29:51.016263+00	2026-07-04 12:29:51.016263+00	\N
b294c4dd-5778-4777-83e9-93986f8afa11	3b5a2527-fcdc-41b6-b512-4be49abc8c1b	2026	7	2026-07-04	2026-07-31	2026-07-05	2500000.00	\N	PENDING	\N	2026-07-07 04:40:36.885156+00	2026-07-07 04:40:36.885156+00	\N
7293f45b-6367-4f25-b62f-e1ab3edae620	3b5a2527-fcdc-41b6-b512-4be49abc8c1b	2026	8	2026-08-01	2026-08-31	2026-08-05	2500000.00	\N	PENDING	\N	2026-07-07 04:40:36.885156+00	2026-07-07 04:40:36.885156+00	\N
e7203350-cea4-4f77-952a-2e622ed6f2f9	3b5a2527-fcdc-41b6-b512-4be49abc8c1b	2026	9	2026-09-01	2026-09-30	2026-09-05	2500000.00	\N	PENDING	\N	2026-07-07 04:40:36.885156+00	2026-07-07 04:40:36.885156+00	\N
ab77b9ca-28fd-4b71-9a74-b7f26d27d660	3b5a2527-fcdc-41b6-b512-4be49abc8c1b	2026	10	2026-10-01	2026-10-04	2026-10-05	2500000.00	\N	PENDING	\N	2026-07-07 04:40:36.885156+00	2026-07-07 04:40:36.885156+00	\N
05f9e165-eb27-4a20-a15e-a3f40c642c01	bb9fdaee-6918-447b-969c-4950a8ef0a30	2026	7	2026-07-07	2026-07-31	2026-07-07	2700000.00	\N	PENDING	\N	2026-07-07 04:53:14.043895+00	2026-07-07 04:53:14.043895+00	\N
e09dc53f-4179-4756-889d-738282630d55	bb9fdaee-6918-447b-969c-4950a8ef0a30	2026	8	2026-08-01	2026-08-31	2026-08-05	2700000.00	\N	PENDING	\N	2026-07-07 04:53:14.043895+00	2026-07-07 04:53:14.043895+00	\N
d8383d1c-d6b7-42e8-a81c-a5837f33ee46	bb9fdaee-6918-447b-969c-4950a8ef0a30	2026	9	2026-09-01	2026-09-30	2026-09-05	2700000.00	\N	PENDING	\N	2026-07-07 04:53:14.043895+00	2026-07-07 04:53:14.043895+00	\N
5b21a4ec-32e9-44ee-8920-6445dc4447e5	bb9fdaee-6918-447b-969c-4950a8ef0a30	2026	10	2026-10-01	2026-10-07	2026-10-05	2700000.00	\N	PENDING	\N	2026-07-07 04:53:14.043895+00	2026-07-07 04:53:14.043895+00	\N
\.


--
-- Data for Name: login_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.login_history (id, nguoi_dung_id, email, thanh_cong, ip_address, user_agent, ly_do_that_bai, tao_luc) FROM stdin;
ddd0876e-a760-497b-b6cb-b015b420dd7f	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-06-17 23:32:25.714177+00
3b847b8f-77dd-426d-9a70-fd1de49f5fce	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-06-24 02:25:00.769613+00
daeecb71-06ea-4b59-a6bc-7f4071779fa4	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-06-24 03:00:22.015356+00
b273d237-ee61-4d01-af69-f2b3249a151c	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-06-24 03:09:05.796871+00
d7750e76-960e-4afa-95d3-b744848f4765	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-06-24 03:12:07.590085+00
caf40ddc-f001-4695-9e77-ce559e880d64	11a616e8-e290-476f-ac28-fcef0466f571	tenant_0357165019@easyhouse.local	t	::1	node	\N	2026-06-24 03:13:31.599114+00
08cefd26-4552-49ba-85c7-93c71dec214f	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-06-24 03:15:46.275228+00
c286d5eb-2e44-415b-b622-b67a5b7f356a	11a616e8-e290-476f-ac28-fcef0466f571	tenant_0357165019@easyhouse.local	t	::1	node	\N	2026-06-24 03:32:54.935979+00
fcf09ee3-e4eb-49c2-8893-1141f50916e1	11a616e8-e290-476f-ac28-fcef0466f571	tenant_0357165019@easyhouse.local	t	::1	node	\N	2026-06-24 03:34:10.986047+00
a4714556-e099-4367-b22c-a6848d3de82b	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-06-24 03:34:34.637451+00
636fc180-6828-41d5-aa58-56bc07d72b19	ffba4a1a-b837-44d1-b647-cbcc4a5ddac9	tenant_0989903903@easyhouse.local	t	::1	node	\N	2026-06-24 03:35:48.985404+00
d9c1d0bd-1895-4d91-8fe5-83779a968aa2	ffba4a1a-b837-44d1-b647-cbcc4a5ddac9	tenant_0989903903@easyhouse.local	t	::1	node	\N	2026-06-24 03:36:05.625191+00
7b87245e-731c-4347-80f6-f053d2b2a439	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-06-24 03:37:09.159158+00
f3d64ff2-e239-4cb7-8c36-897bf7f49bcd	ffba4a1a-b837-44d1-b647-cbcc4a5ddac9	tenant_0989903903@easyhouse.local	t	::1	node	\N	2026-06-24 03:37:52.894121+00
dfa9b3e4-1c75-43c4-af72-d010e5d7db46	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-06-24 03:38:28.027268+00
5cac11d2-5edc-4a30-a6a1-65b859407723	ffba4a1a-b837-44d1-b647-cbcc4a5ddac9	tenant_0989903903@easyhouse.local	t	::1	node	\N	2026-06-24 03:39:00.914136+00
f738dd5b-11eb-4729-8192-3c7a6f92f413	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-06-24 03:39:32.965093+00
c7511b83-e9bb-477b-a107-b386275c0487	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-06-24 03:48:31.837923+00
ae0b8bb7-f74d-455f-aac9-7c196064b09e	ffba4a1a-b837-44d1-b647-cbcc4a5ddac9	tenant_0989903903@easyhouse.local	t	::1	node	\N	2026-06-24 03:49:15.769488+00
83c42acb-0556-40ac-ad96-c251dd1a9b9e	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-06-24 03:50:45.599437+00
380bd9a0-bf0d-42ad-91e4-b8b85a49bb5d	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-06-24 03:50:59.080805+00
7486a299-ca83-429c-88b7-aa1bcd9daf54	94f1325a-40ea-450c-945d-bcc97edf175c	tenant_0989903901@easyhouse.local	t	::1	node	\N	2026-06-24 03:53:29.297408+00
7c297d1d-301f-4ed6-b4ff-b9e5df3fa5aa	94f1325a-40ea-450c-945d-bcc97edf175c	tenant_0989903901@easyhouse.local	t	::1	node	\N	2026-06-24 03:53:43.879723+00
92e30b1a-a0c9-41bd-9450-9af094276de5	4deb410a-cef3-4ab5-b13f-a66ba1b5cd9b	tenant_0798638798@easyhouse.local	t	::1	node	\N	2026-06-24 04:07:27.867861+00
8e325ce0-7b70-4f89-acf2-2cb08659b188	4deb410a-cef3-4ab5-b13f-a66ba1b5cd9b	tenant_0798638798@easyhouse.local	t	::1	node	\N	2026-06-24 04:07:41.300375+00
12c444ae-06c0-4330-8924-d638ea5aa21d	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-06-24 04:08:01.579991+00
d15a23a8-2fdc-44de-9b2c-d03364b83bee	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-06-30 14:07:39.134945+00
6089ce04-5a2d-4e9e-8681-980f0afe21f3	4deb410a-cef3-4ab5-b13f-a66ba1b5cd9b	tenant_0798638798@easyhouse.local	t	::1	node	\N	2026-07-04 10:46:16.429858+00
33782b1d-c276-46c3-9c46-b723e3be7ec8	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-07-04 10:54:44.836474+00
5ac54b49-41b4-4ae4-92db-48fb475b05c0	4deb410a-cef3-4ab5-b13f-a66ba1b5cd9b	tenant_0798638798@easyhouse.local	t	::1	node	\N	2026-07-04 10:56:14.81614+00
cf966f6f-8092-4881-bf73-a8a407adff5b	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-07-04 12:06:31.690058+00
8bb59751-ac36-4b72-b5b3-4dd6671da431	3a8892b9-bb34-4524-8500-7be7e88b1de5	tenant_0396822875@easyhouse.local	t	::1	node	\N	2026-07-04 12:33:55.062146+00
3159ceea-e6ce-4da7-bafd-7fffcd18b255	3a8892b9-bb34-4524-8500-7be7e88b1de5	tenant_0396822875@easyhouse.local	t	::1	node	\N	2026-07-04 12:34:10.5804+00
f05f72a2-6638-45d1-8a54-f15a0ccf8f88	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-07-04 12:37:10.059267+00
f6a14c48-12b3-475c-a857-11a445ba6074	3a8892b9-bb34-4524-8500-7be7e88b1de5	tenant_0396822875@easyhouse.local	t	::1	node	\N	2026-07-07 04:34:58.325313+00
532496f5-bb36-464a-9cda-7189ab41d02f	3a8892b9-bb34-4524-8500-7be7e88b1de5	tenant_0396822875@easyhouse.local	t	::1	node	\N	2026-07-07 04:36:34.396508+00
350491bd-f4f5-48cb-a53c-c144265e53a7	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	::1	node	\N	2026-07-07 04:36:48.171743+00
68e98232-0a14-4f2b-9aab-676879b13e4c	8faf0189-da59-48bd-a1ed-89f446fc22e3	gtruc2146@gmail.com	t	::1	node	\N	2026-07-07 04:40:48.904926+00
6946e628-e883-4bf2-b88f-989a9916066f	8faf0189-da59-48bd-a1ed-89f446fc22e3	gtruc2146@gmail.com	t	::1	node	\N	2026-07-07 04:41:03.556744+00
34c74fc1-04f5-4138-99d9-36815b8286e3	8faf0189-da59-48bd-a1ed-89f446fc22e3	gtruc2146@gmail.com	t	::1	node	\N	2026-07-07 04:45:41.844212+00
fbcf8867-4ad7-423f-adad-adff8f07e7b5	3a8892b9-bb34-4524-8500-7be7e88b1de5	tenant_0396822875@easyhouse.local	t	::1	node	\N	2026-07-07 04:54:11.448354+00
b61ff5ac-03c0-46ed-88f2-838531e494e8	dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	t	172.19.0.10	node	\N	2026-07-07 16:56:07.143018+00
\.


--
-- Data for Name: meter_anomaly_alert; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.meter_anomaly_alert (id, chi_so_id, phong_id, hop_dong_id, loai, ky_thang, ky_nam, tieu_thu_hien_tai, tieu_thu_trung_binh, ty_le_tang, muc_do, ly_do, trang_thai, resolved_at, resolved_by, tao_luc) FROM stdin;
\.


--
-- Data for Name: nguoi_dung; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.nguoi_dung (id, email, ho_ten, so_dien_thoai, anh_dai_dien, ngay_sinh, gioi_tinh, dia_chi, que_quan, so_cccd, trang_thai, so_lan_dang_nhap_sai, khoa_den_luc, lan_dang_nhap_cuoi, cau_hinh_2fa, tao_luc, cap_nhat_luc, xoa_luc, mat_khau, trang_thai_kyc, anh_cccd_truoc, anh_cccd_sau, anh_gpkd) FROM stdin;
ffba4a1a-b837-44d1-b647-cbcc4a5ddac9	tenant_0989903903@easyhouse.local	linh nguy???n	0989903903	\N	\N	\N	\N	\N	099999999989	ACTIVE	0	\N	\N	\N	2026-06-24 03:35:25.7579+00	2026-06-24 03:35:56.066861+00	\N	$2a$10$lrayPYKfQpR4L.uSY7quaOEz8thbttWkzG8OQeVf7fWVUuqOKyoRq	NONE	\N	\N	\N
94f1325a-40ea-450c-945d-bcc97edf175c	tenant_0989903901@easyhouse.local	chung linh	0989903901	\N	\N	\N	\N	\N	066206004056	ACTIVE	0	\N	\N	\N	2026-06-24 03:51:50.731001+00	2026-06-24 03:53:35.792264+00	\N	$2a$10$6cu638VAQgXZS4NDNKqcauaeEZp7nQkxPLmxSZQ5rvEPIr2SWBhwS	NONE	\N	\N	\N
4deb410a-cef3-4ab5-b13f-a66ba1b5cd9b	tenant_0798638798@easyhouse.local	Chung ho??ng	0798638798	\N	\N	\N	\N	\N	099999999877	ACTIVE	0	\N	\N	\N	2026-06-24 04:05:22.437806+00	2026-06-24 04:07:34.869392+00	\N	$2a$10$dhLh3sVpAQLupUZYvtO44O96DIjGajyDgNEW7J2aejCbwSneZvdxG	NONE	\N	\N	\N
11a616e8-e290-476f-ac28-fcef0466f571	tenant_0357165019@easyhouse.local	l?? v??n minh	0357165018	\N	\N	\N	\N	\N	066206004088	ACTIVE	0	\N	\N	\N	2026-06-24 03:12:45.216337+00	2026-07-04 12:13:16.057261+00	\N	$2a$10$4LQBTudBY2P0o9ehsHUbH.3W9ITipP.hq2TrFUqrF7Y6jhlgs/HW6	NONE	\N	\N	\N
3a8892b9-bb34-4524-8500-7be7e88b1de5	tenant_0396822875@easyhouse.local	H?? V??n Linh	0396822875	\N	\N	\N	\N	\N	066206007804	ACTIVE	0	\N	\N	\N	2026-07-04 12:26:12.921336+00	2026-07-04 12:34:03.047536+00	\N	$2a$10$w61qOpQu0uFIHISjkodrs.tgbMLH4eh7lTIf10hVhU7jemqovJG7C	NONE	\N	\N	\N
8faf0189-da59-48bd-a1ed-89f446fc22e3	gtruc2146@gmail.com	h??ng th??? tr??c giang	0357165019	\N	2005-05-23	nu	\N	C???n Th??	066206005084	ACTIVE	0	\N	\N	\N	2026-07-04 12:14:02.007988+00	2026-07-07 04:40:56.13144+00	\N	$2a$10$rK/m6dyy/XXCKe1L8JeR9egQfhGLZzxLjM/OdvLgLHIBcDC6frXg.	NONE	\N	\N	\N
dddfb501-3d25-4517-ac58-1b9225e85cb3	docong989@gmail.com	????? ch?? c??ng	0369963725	\N	\N	\N	\N	\N	\N	INACTIVE	0	\N	2026-07-07 16:56:07.133728+00	\N	2026-06-17 23:31:38.973156+00	2026-07-07 16:56:07.045969+00	\N	$2a$10$b.9TrQiXlwVwAJZWDpYqYOvPST/aSgYImLkKIsVez7c/eLLMU1zpm	NONE	\N	\N	\N
\.


--
-- Data for Name: nguoi_dung_nha_tro; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.nguoi_dung_nha_tro (id, nguoi_dung_id, nha_tro_id, vai_tro, co_quyen_xem, co_quyen_sua, co_quyen_thu_tien, tao_luc) FROM stdin;
\.


--
-- Data for Name: nguoi_dung_vai_tro; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id, tao_luc) FROM stdin;
dddfb501-3d25-4517-ac58-1b9225e85cb3	04c9a834-05de-43ca-aa21-eb4b9188c54e	2026-06-17 23:31:38.984585+00
\.


--
-- Data for Name: nha_tro; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.nha_tro (id, chu_tro_id, ten, dia_chi, so_nha, duong, phuong, quan, thanh_pho, mo_ta, tien_nghi_chung, noi_quy, trang_thai, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
d447489d-0757-49be-a39d-d6bb5d5b6556	dddfb501-3d25-4517-ac58-1b9225e85cb3	HH1A	19 h?? chung	19	h?? chung	Ph?????ng Qu???ng An	Qu???n T??y H???	Th??nh ph??? H?? N???i	Nh?? m???i x??y	wifi,baoVe,thangMay,nhaVeSinhChung,camera,giuXe,sanPhoi,khuBepChung	\N	ACTIVE	2026-06-17 23:42:32.207916+00	2026-06-17 23:42:32.207916+00	\N
1a447810-275a-419f-95b1-8eaa0eef7a01	dddfb501-3d25-4517-ac58-1b9225e85cb3	HH2A	79 c???u gi???y	79	c???u gi???y	Ph?????ng Quan Hoa	Qu???n C???u Gi???y	Th??nh ph??? H?? N???i	ph??ng tr??? m???i	baoVe,thangMay,camera	\N	ACTIVE	2026-06-24 02:44:20.259703+00	2026-06-24 02:44:20.259703+00	\N
8456155a-f4ff-44c4-89fb-bde594c00bd6	dddfb501-3d25-4517-ac58-1b9225e85cb3	Nh?? Tr??? Anh T??c	22 Nguy???n v??n c???	22	Nguy???n v??n c???	Ph?????ng Long Bi??n	\N	Th??nh ph??? H?? N???i	nh?? m???i	wifi,giuXe,nhaVeSinhChung	\N	ACTIVE	2026-07-04 07:05:48.874791+00	2026-07-04 07:05:48.874791+00	\N
5528f265-183e-44d1-ada8-532743022a7d	dddfb501-3d25-4517-ac58-1b9225e85cb3	Nh?? Tr??? H???i ??u	99 Nguy???n V??n Linh	99	Nguy???n V??n Linh	Ph?????ng Li???u Giai	\N	Th??nh ph??? H?? N???i	nh?? tr??? m???i	wifi,camera,thangMay	\N	ACTIVE	2026-07-04 12:24:54.089777+00	2026-07-04 12:24:54.089777+00	\N
\.


--
-- Data for Name: phong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.phong (id, nha_tro_id, ten, khu_vuc, tang, dien_tich, so_nguoi_toi_da, trang_thai, gia_hien_tai, tien_coc_mac_dinh, mo_ta, tao_luc, cap_nhat_luc, xoa_luc, tang_id) FROM stdin;
8dc80125-7fdb-46a6-a63c-84da85816a61	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 103	\N	1	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	7333c137-dcbf-4c9f-b210-6ebe66dd01cf
66589309-0a36-466f-abb5-a619bdc4afa2	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 104	\N	1	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	7333c137-dcbf-4c9f-b210-6ebe66dd01cf
2f60bf57-7dc2-434a-80a6-b43a7ea2500e	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 105	\N	1	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	7333c137-dcbf-4c9f-b210-6ebe66dd01cf
0d01c0a8-4bdd-452e-9fc0-3d467e5171d0	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 201	\N	2	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	8409fffe-3401-4b9c-8f6b-094f746b1552
dfa6472d-4b65-4cae-b4b7-bf2edb5d6fa0	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 202	\N	2	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	8409fffe-3401-4b9c-8f6b-094f746b1552
95476c73-479b-4d76-81a7-99507bff0251	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 203	\N	2	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	8409fffe-3401-4b9c-8f6b-094f746b1552
6aa71386-7de6-4344-9e97-2441843731fb	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 204	\N	2	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	8409fffe-3401-4b9c-8f6b-094f746b1552
16a38139-377c-4fcb-895a-3a8cb74eb93e	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 205	\N	2	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	8409fffe-3401-4b9c-8f6b-094f746b1552
e135f1e1-4b2d-4300-9a98-dc8e6657235f	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 301	\N	3	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	df637dcb-e59f-4a77-ae34-593d0dd759a7
92a0aa90-05e1-49dc-8882-5f949dfee6db	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 302	\N	3	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	df637dcb-e59f-4a77-ae34-593d0dd759a7
0945be74-3d87-47ec-b3e0-90d2a101efff	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 303	\N	3	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	df637dcb-e59f-4a77-ae34-593d0dd759a7
549d889c-17d1-4b21-ad10-7e2c26657645	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 304	\N	3	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	df637dcb-e59f-4a77-ae34-593d0dd759a7
5728e758-b0aa-4b62-8043-80f238c4cd40	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 305	\N	3	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	df637dcb-e59f-4a77-ae34-593d0dd759a7
b0ca4273-7968-414e-b700-f382100b74b1	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 401	\N	4	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	7a399ad2-dedb-486e-8041-e884aa6f5eb1
b92d616c-693e-4f22-968b-fb705b1071c2	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 402	\N	4	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	7a399ad2-dedb-486e-8041-e884aa6f5eb1
fb0655e9-63ba-4c31-910e-961d8fa02451	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 403	\N	4	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	7a399ad2-dedb-486e-8041-e884aa6f5eb1
537e7199-81fa-4ab1-a6cc-f7fd0f710c49	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 404	\N	4	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	7a399ad2-dedb-486e-8041-e884aa6f5eb1
c113f185-52b8-4ca1-acad-d855070d41ee	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 405	\N	4	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	7a399ad2-dedb-486e-8041-e884aa6f5eb1
d994237c-9db0-4701-8c2b-3776cfbcbabc	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 501	\N	5	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	8cdaf6e6-1616-4c3b-b9ea-0ea04da934b3
56c97c13-6708-4975-a010-bae1463efeea	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 502	\N	5	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	8cdaf6e6-1616-4c3b-b9ea-0ea04da934b3
cb0f6873-5818-4199-821c-34db4bd515fa	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 503	\N	5	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	8cdaf6e6-1616-4c3b-b9ea-0ea04da934b3
ed5aa229-15ca-4bd4-b9c3-05905cbde6ed	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 504	\N	5	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	8cdaf6e6-1616-4c3b-b9ea-0ea04da934b3
5f336e02-2041-43a3-8210-f885ed57def1	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 505	\N	5	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	8cdaf6e6-1616-4c3b-b9ea-0ea04da934b3
772cb429-f692-4ca3-99d5-1f5342f16783	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 601	\N	6	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	2e393679-5d96-4517-8df4-edd53540c0d0
ad432f0f-c2a2-422b-ba4e-0c06035a3814	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 602	\N	6	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	2e393679-5d96-4517-8df4-edd53540c0d0
0af44cdd-f09d-4f00-8a2c-7eb158f01a4f	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 603	\N	6	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	2e393679-5d96-4517-8df4-edd53540c0d0
cddfeedd-5474-4d41-8f63-a7e97e2e4dfc	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 604	\N	6	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	2e393679-5d96-4517-8df4-edd53540c0d0
92b2e305-4936-41d9-972e-ac78b1960480	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 605	\N	6	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	2e393679-5d96-4517-8df4-edd53540c0d0
ba180749-f1c0-4e9d-9162-ba20e1105048	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 701	\N	7	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	12495954-f371-49c6-a23f-60b365c2de26
128c5517-bb6e-412e-a321-4e779e6f1a61	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 702	\N	7	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	12495954-f371-49c6-a23f-60b365c2de26
e0566ded-e7c6-4e29-ae9d-d3188d691f68	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 703	\N	7	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	12495954-f371-49c6-a23f-60b365c2de26
28578527-0ed7-41c8-8d0e-24def7760ee4	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 704	\N	7	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	12495954-f371-49c6-a23f-60b365c2de26
acd4eeb0-72ef-47c1-aef0-7bc223028905	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 705	\N	7	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	12495954-f371-49c6-a23f-60b365c2de26
18edc2e2-6dc4-48b2-9990-6257ce2e601c	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 801	\N	8	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	b8e12939-9bc9-4312-8ce6-249a04899b67
2c87739d-a979-483f-9a87-40931d51f94a	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 802	\N	8	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	b8e12939-9bc9-4312-8ce6-249a04899b67
384a90ab-00e9-428b-9c0d-21e758b96d77	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 803	\N	8	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	b8e12939-9bc9-4312-8ce6-249a04899b67
01a2e811-b7fc-4dc5-bde3-5dcb14483856	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 804	\N	8	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	b8e12939-9bc9-4312-8ce6-249a04899b67
3cd2409d-795d-4235-9860-e04f9a21ea1d	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 805	\N	8	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	b8e12939-9bc9-4312-8ce6-249a04899b67
b97b5f12-3e5e-4783-b4a4-377eb673a166	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 901	\N	9	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	020bcfab-038e-4e4a-b009-b589f888c9db
8eee5562-1fe7-4ab5-bf14-7d44e8932507	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 902	\N	9	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	020bcfab-038e-4e4a-b009-b589f888c9db
0d533780-0064-4b7f-bd87-69fbb688879c	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 903	\N	9	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	020bcfab-038e-4e4a-b009-b589f888c9db
f01f8ace-a246-4332-8028-eca1e141db9b	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 904	\N	9	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	020bcfab-038e-4e4a-b009-b589f888c9db
8673ac93-5258-45ee-9780-c7eb22a0c063	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 905	\N	9	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	020bcfab-038e-4e4a-b009-b589f888c9db
f05e8e39-289f-4cf7-802a-1461a151c285	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1001	\N	10	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	87babd64-94fe-4d86-9bc0-011d4394d76e
787074dd-719a-457c-a492-a8fe0d8596e5	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1002	\N	10	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	87babd64-94fe-4d86-9bc0-011d4394d76e
2b989546-0661-42fa-af0d-d0e196f85e02	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1003	\N	10	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	87babd64-94fe-4d86-9bc0-011d4394d76e
93c8f88c-4b1f-48c8-93c7-6273a6309a34	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1004	\N	10	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	87babd64-94fe-4d86-9bc0-011d4394d76e
579c4065-5b39-4cc3-80d5-f3139e4d5577	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1005	\N	10	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	87babd64-94fe-4d86-9bc0-011d4394d76e
c6f1030d-b6eb-4c84-b7c9-89a4f747ede0	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1101	\N	11	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	5854f56d-b843-41f7-9952-4002c081416e
73d5231c-a931-4a96-849e-b71a94e5a16b	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1102	\N	11	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	5854f56d-b843-41f7-9952-4002c081416e
ff24caf4-d8a1-477c-8e29-416d3e17f414	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1103	\N	11	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	5854f56d-b843-41f7-9952-4002c081416e
22b63f89-569d-4ea7-8e25-3dcc12161b05	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1104	\N	11	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	5854f56d-b843-41f7-9952-4002c081416e
04288077-5171-4568-bc3d-a6ce4900ff70	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1105	\N	11	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	5854f56d-b843-41f7-9952-4002c081416e
96180a6a-af82-4fe1-ae2d-5ba0a1ae384d	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 101	\N	1	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-26 17:44:38.785003+00	\N	7333c137-dcbf-4c9f-b210-6ebe66dd01cf
75c34bac-a078-4311-9c1d-9c2564635667	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1201	\N	12	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	d6f9a582-8315-4e98-9c27-cbc26841bab0
23d60e2d-8e52-43ab-804e-d3394f5d639f	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1202	\N	12	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	d6f9a582-8315-4e98-9c27-cbc26841bab0
8a519598-b376-4a97-ac22-cd42c4780011	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1203	\N	12	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	d6f9a582-8315-4e98-9c27-cbc26841bab0
4699ef5c-ef23-4eb3-9eb7-0ba222424786	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1204	\N	12	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	d6f9a582-8315-4e98-9c27-cbc26841bab0
5f346b23-73d4-47d6-a9e7-61998f4b2b87	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1205	\N	12	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	d6f9a582-8315-4e98-9c27-cbc26841bab0
39fc42fd-2aa3-4d9f-a6da-7c8a3ecc35ec	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1301	\N	13	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	e0ed4faf-5296-4fc5-b75a-23f89a1b20c6
1d0003f2-bc29-4ecb-9277-07e6ba10584b	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1302	\N	13	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	e0ed4faf-5296-4fc5-b75a-23f89a1b20c6
d88b63e7-3553-4554-a31b-46cbb84adf47	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1303	\N	13	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	e0ed4faf-5296-4fc5-b75a-23f89a1b20c6
87730b79-c051-43b5-b5b3-a8d9c4e5e6aa	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1304	\N	13	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	e0ed4faf-5296-4fc5-b75a-23f89a1b20c6
5623bfa4-2faa-48a7-9e9f-22798a019544	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1305	\N	13	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	e0ed4faf-5296-4fc5-b75a-23f89a1b20c6
7a25e6d6-dd01-4d10-b43f-3da8cceedcaa	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1401	\N	14	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	c4fb45b1-70f0-4093-9131-1bee531db922
f5b4583e-9a5c-4136-b95f-16cad5175880	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1402	\N	14	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	c4fb45b1-70f0-4093-9131-1bee531db922
75138526-c8ff-47e5-ae4b-bfb73101364a	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1403	\N	14	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	c4fb45b1-70f0-4093-9131-1bee531db922
5534f268-e259-46c8-a218-7d6504828cca	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1404	\N	14	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	c4fb45b1-70f0-4093-9131-1bee531db922
c9aff452-059e-4054-98a9-c226dc2f81bd	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1405	\N	14	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	c4fb45b1-70f0-4093-9131-1bee531db922
8758901d-c2bb-4a72-8660-48ff0b5a11b6	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1501	\N	15	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	372dcbca-ffc5-43a4-9af1-11021bc6a43e
f08cf432-7817-40bd-ae90-145e80f1a8d8	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1502	\N	15	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	372dcbca-ffc5-43a4-9af1-11021bc6a43e
95eb925a-408c-497e-ba47-61e11c453482	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1503	\N	15	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	372dcbca-ffc5-43a4-9af1-11021bc6a43e
2a257b20-e205-4bc9-8e10-5f6fa3759c92	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1504	\N	15	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	372dcbca-ffc5-43a4-9af1-11021bc6a43e
05cec9a9-0a2b-4b2b-ac88-8eaa0d900301	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1505	\N	15	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	372dcbca-ffc5-43a4-9af1-11021bc6a43e
968a78c6-6e9e-4a50-aa61-61402b6a3e0e	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1601	\N	16	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	2704f3a8-d27c-429f-978f-51f42c6c6c13
50b3a906-ff8c-4632-b603-5a9566fb7314	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1602	\N	16	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	2704f3a8-d27c-429f-978f-51f42c6c6c13
f07c9eb1-ec5b-48fd-8796-f34c331d6469	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1603	\N	16	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	2704f3a8-d27c-429f-978f-51f42c6c6c13
86cae7a4-bc8d-49e7-b6bc-471f4f554528	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1604	\N	16	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	2704f3a8-d27c-429f-978f-51f42c6c6c13
1b8665a2-3f8a-4465-bfae-190cc0b592e4	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1605	\N	16	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	2704f3a8-d27c-429f-978f-51f42c6c6c13
fb364657-a18d-40b0-a0cd-0cf0f0c0517e	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1701	\N	17	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	a6fae403-b118-436b-9b5f-54d8c33cf07a
5e5b6607-c2e9-40fb-bb8e-cb2c287af252	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1702	\N	17	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	a6fae403-b118-436b-9b5f-54d8c33cf07a
973c7d3f-406b-4eb9-ab7e-7cac7535f05c	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1703	\N	17	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	a6fae403-b118-436b-9b5f-54d8c33cf07a
4500095e-03e9-4c40-b226-52db505476fb	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1704	\N	17	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	a6fae403-b118-436b-9b5f-54d8c33cf07a
7008c341-7dd0-4f5b-b6e9-3449321edadb	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1705	\N	17	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	a6fae403-b118-436b-9b5f-54d8c33cf07a
52042e62-a040-44b4-851d-8b89ccd4ebb8	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1801	\N	18	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	1af4c2c6-a9fc-47cf-8fb3-e7feb7e84239
b2650c06-2951-4940-8464-dc9daa71779f	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1802	\N	18	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	1af4c2c6-a9fc-47cf-8fb3-e7feb7e84239
35ae1e82-e318-49d3-aba3-8b72a2b47b4f	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1803	\N	18	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	1af4c2c6-a9fc-47cf-8fb3-e7feb7e84239
d3b93dee-d9af-4aa2-9692-b1614a7be6f1	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1804	\N	18	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	1af4c2c6-a9fc-47cf-8fb3-e7feb7e84239
0140bba6-f382-4bfe-ac0f-bb29182669cd	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1805	\N	18	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	1af4c2c6-a9fc-47cf-8fb3-e7feb7e84239
d7e10dbe-9418-47ba-928b-565943103e2c	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1901	\N	19	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	b437449b-55c0-4704-8387-901c4d64271a
0db123fe-cb49-47ba-9dc9-8c95f22f35ba	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1902	\N	19	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	b437449b-55c0-4704-8387-901c4d64271a
38e67f88-b780-47e6-b5d1-52825d5da24b	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1903	\N	19	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	b437449b-55c0-4704-8387-901c4d64271a
74276126-98b0-472f-b541-a21591032d49	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1904	\N	19	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	b437449b-55c0-4704-8387-901c4d64271a
6f18d5b7-f53a-4e3d-b6b2-8d48a06e9c50	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 1905	\N	19	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	b437449b-55c0-4704-8387-901c4d64271a
dce1e94e-ab9b-4a17-8cc9-919a76734ec5	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 2001	\N	20	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	e2ad9feb-ce74-4e19-8ddd-15fd3f087fd3
cc30eb54-dc1f-4428-87a8-90f0ed77c5f8	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 2002	\N	20	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	e2ad9feb-ce74-4e19-8ddd-15fd3f087fd3
c6aa6b62-037d-4244-aea3-ba5e1e8ab3bb	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 2003	\N	20	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	e2ad9feb-ce74-4e19-8ddd-15fd3f087fd3
fb6dfcb0-4757-47ca-9e80-77e4d0051231	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 2004	\N	20	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	e2ad9feb-ce74-4e19-8ddd-15fd3f087fd3
67ce7c9a-166e-43cb-824e-1795aa5ad3a4	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 2005	\N	20	20.00	4	AVAILABLE	3000000.00	3000000.00	\N	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N	e2ad9feb-ce74-4e19-8ddd-15fd3f087fd3
55540e96-9754-46fa-baf6-10c6692aa61a	d447489d-0757-49be-a39d-d6bb5d5b6556	Ph??ng 102		1	20.00	4	AVAILABLE	3000000.00	3000000.00		2026-06-17 23:42:32.207069+00	2026-06-18 00:29:27.650379+00	\N	7333c137-dcbf-4c9f-b210-6ebe66dd01cf
f3687008-f565-4cb1-be05-8169e6ec3440	1a447810-275a-419f-95b1-8eaa0eef7a01	Ph??ng 201	\N	2	22.00	4	AVAILABLE	2700000.00	2700000.00	\N	2026-06-24 02:44:20.257671+00	2026-06-24 02:44:20.257671+00	\N	45161bb2-737e-48b7-ac04-c088d27e2bba
42380434-937f-4b9e-ba6e-2684365eb525	1a447810-275a-419f-95b1-8eaa0eef7a01	Ph??ng 204	\N	2	22.00	4	AVAILABLE	2700000.00	2700000.00	\N	2026-06-24 02:44:20.257671+00	2026-06-24 02:44:20.257671+00	\N	45161bb2-737e-48b7-ac04-c088d27e2bba
150683a8-2efd-44c7-b915-1b741f7122af	1a447810-275a-419f-95b1-8eaa0eef7a01	Ph??ng 301	\N	3	20.00	4	AVAILABLE	2500000.00	2500000.00	\N	2026-06-24 02:44:20.257671+00	2026-06-24 02:44:20.257671+00	\N	48228941-9355-4ae3-a7f9-b1fa80124267
9ae3f685-c32e-46dc-8165-557caebe0c96	1a447810-275a-419f-95b1-8eaa0eef7a01	Ph??ng 302	\N	3	20.00	4	AVAILABLE	2500000.00	2500000.00	\N	2026-06-24 02:44:20.257671+00	2026-06-24 02:44:20.257671+00	\N	48228941-9355-4ae3-a7f9-b1fa80124267
76e99fea-1dbe-435d-8da3-62ce078007c2	1a447810-275a-419f-95b1-8eaa0eef7a01	Ph??ng 103	\N	1	20.00	4	AVAILABLE	2500000.00	2500000.00	\N	2026-06-24 02:44:20.257671+00	2026-06-24 03:51:20.13802+00	\N	8aa45b87-526d-4aab-85d8-3a27b7441399
f96050ad-d946-46d6-a055-9a5692946237	1a447810-275a-419f-95b1-8eaa0eef7a01	Ph??ng 202	\N	2	22.00	4	AVAILABLE	2700000.00	2700000.00	\N	2026-06-24 02:44:20.257671+00	2026-06-26 17:44:33.178251+00	\N	45161bb2-737e-48b7-ac04-c088d27e2bba
f9f371b2-eadc-424f-97e1-bbb28d158826	1a447810-275a-419f-95b1-8eaa0eef7a01	Ph??ng 102	\N	1	20.00	4	AVAILABLE	2500000.00	2500000.00	\N	2026-06-24 02:44:20.257671+00	2026-06-26 17:44:36.080753+00	\N	8aa45b87-526d-4aab-85d8-3a27b7441399
417c837a-0534-42c8-9e68-fc6dcd5e73fd	1a447810-275a-419f-95b1-8eaa0eef7a01	Ph??ng 304	\N	3	20.00	4	AVAILABLE	2500000.00	2500000.00	\N	2026-06-24 02:44:20.257671+00	2026-06-24 02:44:20.257671+00	\N	48228941-9355-4ae3-a7f9-b1fa80124267
c3d31275-9559-4e7b-b51e-8928ccdc4137	1a447810-275a-419f-95b1-8eaa0eef7a01	Ph??ng 101	\N	1	20.00	4	AVAILABLE	2500000.00	2500000.00	\N	2026-06-24 02:44:20.257671+00	2026-06-24 03:06:10.237347+00	\N	8aa45b87-526d-4aab-85d8-3a27b7441399
33b220e4-0864-4b73-8850-cc7693646155	1a447810-275a-419f-95b1-8eaa0eef7a01	Ph??ng 303	\N	3	20.00	4	AVAILABLE	2500000.00	2500000.00	\N	2026-06-24 02:44:20.257671+00	2026-06-24 04:08:50.439259+00	2026-06-24 04:08:50.443713+00	48228941-9355-4ae3-a7f9-b1fa80124267
bf079329-8a42-46fe-a8dc-f0e452995d45	1a447810-275a-419f-95b1-8eaa0eef7a01	PH??NG 109		1	25.00	1	AVAILABLE	3000000.00	3000000.00		2026-06-24 04:09:35.31204+00	2026-06-24 04:09:35.31204+00	\N	8aa45b87-526d-4aab-85d8-3a27b7441399
0045aaf1-97a5-4987-83ed-0aaec9ab162d	1a447810-275a-419f-95b1-8eaa0eef7a01	Ph??ng 305	\N	3	20.00	4	AVAILABLE	2500000.00	2500000.00	\N	2026-06-24 02:44:20.257671+00	2026-06-26 17:44:28.959371+00	\N	48228941-9355-4ae3-a7f9-b1fa80124267
9ed3cc54-5064-4a52-9bdb-b3e6e723cee7	8456155a-f4ff-44c4-89fb-bde594c00bd6	Ph??ng 201	\N	2	20.00	2	AVAILABLE	2699999.00	2700000.00	\N	2026-07-04 07:05:48.86847+00	2026-07-04 07:05:48.86847+00	\N	0c0a3776-b6e7-4407-b456-1a8e509881be
80bfca58-e1c3-42b7-8366-29d99f7d2249	8456155a-f4ff-44c4-89fb-bde594c00bd6	Ph??ng 202	\N	2	20.00	2	AVAILABLE	2699999.00	2700000.00	\N	2026-07-04 07:05:48.86847+00	2026-07-04 07:05:48.86847+00	\N	0c0a3776-b6e7-4407-b456-1a8e509881be
6ec5a866-74ce-4b17-8eb9-12a82971cef4	8456155a-f4ff-44c4-89fb-bde594c00bd6	Ph??ng 203	\N	2	20.00	2	AVAILABLE	2699999.00	2700000.00	\N	2026-07-04 07:05:48.86847+00	2026-07-04 07:05:48.86847+00	\N	0c0a3776-b6e7-4407-b456-1a8e509881be
eff57238-37a8-4d47-b2e3-6330da3cc531	1a447810-275a-419f-95b1-8eaa0eef7a01	Ph??ng 203	\N	2	22.00	4	AVAILABLE	2700000.00	2700000.00	\N	2026-06-24 02:44:20.257671+00	2026-07-04 12:18:47.142228+00	\N	45161bb2-737e-48b7-ac04-c088d27e2bba
6d6fd936-15ae-4558-a606-6f11000279da	8456155a-f4ff-44c4-89fb-bde594c00bd6	Ph??ng 101	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-07-04 07:05:48.86847+00	2026-07-04 12:18:51.678263+00	\N	78f648fb-177c-4e3e-8109-807342967299
c99434e8-9d42-4dfa-8cfe-af1966fc57de	5528f265-183e-44d1-ada8-532743022a7d	Ph??ng 101	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-07-04 12:24:54.087354+00	2026-07-04 12:24:54.087354+00	\N	9cc80625-d369-416f-ab1c-b08fa4412a15
41f34fa5-45a6-45f7-9c13-59d13eb36eba	5528f265-183e-44d1-ada8-532743022a7d	Ph??ng 102	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-07-04 12:24:54.087354+00	2026-07-04 12:24:54.087354+00	\N	9cc80625-d369-416f-ab1c-b08fa4412a15
007365e9-e89f-40bd-92e7-fe02c4597a99	5528f265-183e-44d1-ada8-532743022a7d	Ph??ng 103	\N	1	20.00	2	AVAILABLE	2500000.00	2500000.00	\N	2026-07-04 12:24:54.087354+00	2026-07-04 12:24:54.087354+00	\N	9cc80625-d369-416f-ab1c-b08fa4412a15
d645b12e-de81-4afe-a897-f8f7689d5a38	5528f265-183e-44d1-ada8-532743022a7d	Ph??ng 202	\N	2	22.00	2	RENTED	2700000.00	2700000.00	\N	2026-07-04 12:24:54.087354+00	2026-07-04 12:29:51.016263+00	\N	858bf5db-8349-4d1b-a883-69b9248061dc
9b2eaa71-051e-44fd-bb0a-79da454a3c8b	8456155a-f4ff-44c4-89fb-bde594c00bd6	Ph??ng 102	\N	1	20.00	2	RENTED	2500000.00	2500000.00	\N	2026-07-04 07:05:48.86847+00	2026-07-07 04:40:36.885156+00	\N	78f648fb-177c-4e3e-8109-807342967299
660c9c25-bf4b-4822-8ef8-4c73292c9434	5528f265-183e-44d1-ada8-532743022a7d	Ph??ng 201	\N	2	22.00	2	RENTED	2700000.00	2700000.00	\N	2026-07-04 12:24:54.087354+00	2026-07-07 04:53:14.043895+00	\N	858bf5db-8349-4d1b-a883-69b9248061dc
\.


--
-- Data for Name: phong_tien_ich; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.phong_tien_ich (phong_id, tien_ich_id, tao_luc) FROM stdin;
96180a6a-af82-4fe1-ae2d-5ba0a1ae384d	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
96180a6a-af82-4fe1-ae2d-5ba0a1ae384d	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
96180a6a-af82-4fe1-ae2d-5ba0a1ae384d	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
96180a6a-af82-4fe1-ae2d-5ba0a1ae384d	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
96180a6a-af82-4fe1-ae2d-5ba0a1ae384d	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
96180a6a-af82-4fe1-ae2d-5ba0a1ae384d	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
96180a6a-af82-4fe1-ae2d-5ba0a1ae384d	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
96180a6a-af82-4fe1-ae2d-5ba0a1ae384d	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
96180a6a-af82-4fe1-ae2d-5ba0a1ae384d	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
8dc80125-7fdb-46a6-a63c-84da85816a61	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
8dc80125-7fdb-46a6-a63c-84da85816a61	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
8dc80125-7fdb-46a6-a63c-84da85816a61	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
8dc80125-7fdb-46a6-a63c-84da85816a61	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
8dc80125-7fdb-46a6-a63c-84da85816a61	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
8dc80125-7fdb-46a6-a63c-84da85816a61	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
8dc80125-7fdb-46a6-a63c-84da85816a61	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
8dc80125-7fdb-46a6-a63c-84da85816a61	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
8dc80125-7fdb-46a6-a63c-84da85816a61	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
66589309-0a36-466f-abb5-a619bdc4afa2	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
66589309-0a36-466f-abb5-a619bdc4afa2	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
66589309-0a36-466f-abb5-a619bdc4afa2	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
66589309-0a36-466f-abb5-a619bdc4afa2	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
66589309-0a36-466f-abb5-a619bdc4afa2	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
66589309-0a36-466f-abb5-a619bdc4afa2	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
66589309-0a36-466f-abb5-a619bdc4afa2	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
66589309-0a36-466f-abb5-a619bdc4afa2	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
66589309-0a36-466f-abb5-a619bdc4afa2	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
2f60bf57-7dc2-434a-80a6-b43a7ea2500e	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
2f60bf57-7dc2-434a-80a6-b43a7ea2500e	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
2f60bf57-7dc2-434a-80a6-b43a7ea2500e	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
2f60bf57-7dc2-434a-80a6-b43a7ea2500e	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
2f60bf57-7dc2-434a-80a6-b43a7ea2500e	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
2f60bf57-7dc2-434a-80a6-b43a7ea2500e	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
2f60bf57-7dc2-434a-80a6-b43a7ea2500e	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
2f60bf57-7dc2-434a-80a6-b43a7ea2500e	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
2f60bf57-7dc2-434a-80a6-b43a7ea2500e	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
0d01c0a8-4bdd-452e-9fc0-3d467e5171d0	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
0d01c0a8-4bdd-452e-9fc0-3d467e5171d0	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
0d01c0a8-4bdd-452e-9fc0-3d467e5171d0	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
0d01c0a8-4bdd-452e-9fc0-3d467e5171d0	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
0d01c0a8-4bdd-452e-9fc0-3d467e5171d0	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
0d01c0a8-4bdd-452e-9fc0-3d467e5171d0	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
0d01c0a8-4bdd-452e-9fc0-3d467e5171d0	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
0d01c0a8-4bdd-452e-9fc0-3d467e5171d0	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
0d01c0a8-4bdd-452e-9fc0-3d467e5171d0	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
dfa6472d-4b65-4cae-b4b7-bf2edb5d6fa0	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
dfa6472d-4b65-4cae-b4b7-bf2edb5d6fa0	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
dfa6472d-4b65-4cae-b4b7-bf2edb5d6fa0	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
dfa6472d-4b65-4cae-b4b7-bf2edb5d6fa0	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
dfa6472d-4b65-4cae-b4b7-bf2edb5d6fa0	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
dfa6472d-4b65-4cae-b4b7-bf2edb5d6fa0	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
dfa6472d-4b65-4cae-b4b7-bf2edb5d6fa0	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
dfa6472d-4b65-4cae-b4b7-bf2edb5d6fa0	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
dfa6472d-4b65-4cae-b4b7-bf2edb5d6fa0	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
95476c73-479b-4d76-81a7-99507bff0251	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
95476c73-479b-4d76-81a7-99507bff0251	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
95476c73-479b-4d76-81a7-99507bff0251	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
95476c73-479b-4d76-81a7-99507bff0251	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
95476c73-479b-4d76-81a7-99507bff0251	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
95476c73-479b-4d76-81a7-99507bff0251	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
95476c73-479b-4d76-81a7-99507bff0251	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
95476c73-479b-4d76-81a7-99507bff0251	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
95476c73-479b-4d76-81a7-99507bff0251	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
6aa71386-7de6-4344-9e97-2441843731fb	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
6aa71386-7de6-4344-9e97-2441843731fb	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
6aa71386-7de6-4344-9e97-2441843731fb	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
6aa71386-7de6-4344-9e97-2441843731fb	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
6aa71386-7de6-4344-9e97-2441843731fb	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
6aa71386-7de6-4344-9e97-2441843731fb	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
6aa71386-7de6-4344-9e97-2441843731fb	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
6aa71386-7de6-4344-9e97-2441843731fb	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
6aa71386-7de6-4344-9e97-2441843731fb	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
16a38139-377c-4fcb-895a-3a8cb74eb93e	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
16a38139-377c-4fcb-895a-3a8cb74eb93e	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
16a38139-377c-4fcb-895a-3a8cb74eb93e	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
16a38139-377c-4fcb-895a-3a8cb74eb93e	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
16a38139-377c-4fcb-895a-3a8cb74eb93e	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
16a38139-377c-4fcb-895a-3a8cb74eb93e	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
16a38139-377c-4fcb-895a-3a8cb74eb93e	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
16a38139-377c-4fcb-895a-3a8cb74eb93e	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
16a38139-377c-4fcb-895a-3a8cb74eb93e	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
e135f1e1-4b2d-4300-9a98-dc8e6657235f	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
e135f1e1-4b2d-4300-9a98-dc8e6657235f	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
e135f1e1-4b2d-4300-9a98-dc8e6657235f	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
e135f1e1-4b2d-4300-9a98-dc8e6657235f	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
e135f1e1-4b2d-4300-9a98-dc8e6657235f	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
e135f1e1-4b2d-4300-9a98-dc8e6657235f	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
e135f1e1-4b2d-4300-9a98-dc8e6657235f	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
e135f1e1-4b2d-4300-9a98-dc8e6657235f	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
e135f1e1-4b2d-4300-9a98-dc8e6657235f	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
92a0aa90-05e1-49dc-8882-5f949dfee6db	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
92a0aa90-05e1-49dc-8882-5f949dfee6db	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
92a0aa90-05e1-49dc-8882-5f949dfee6db	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
92a0aa90-05e1-49dc-8882-5f949dfee6db	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
92a0aa90-05e1-49dc-8882-5f949dfee6db	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
92a0aa90-05e1-49dc-8882-5f949dfee6db	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
92a0aa90-05e1-49dc-8882-5f949dfee6db	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
92a0aa90-05e1-49dc-8882-5f949dfee6db	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
92a0aa90-05e1-49dc-8882-5f949dfee6db	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
0945be74-3d87-47ec-b3e0-90d2a101efff	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
0945be74-3d87-47ec-b3e0-90d2a101efff	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
0945be74-3d87-47ec-b3e0-90d2a101efff	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
0945be74-3d87-47ec-b3e0-90d2a101efff	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
0945be74-3d87-47ec-b3e0-90d2a101efff	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
0945be74-3d87-47ec-b3e0-90d2a101efff	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
0945be74-3d87-47ec-b3e0-90d2a101efff	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
0945be74-3d87-47ec-b3e0-90d2a101efff	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
0945be74-3d87-47ec-b3e0-90d2a101efff	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
549d889c-17d1-4b21-ad10-7e2c26657645	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
549d889c-17d1-4b21-ad10-7e2c26657645	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
549d889c-17d1-4b21-ad10-7e2c26657645	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
549d889c-17d1-4b21-ad10-7e2c26657645	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
549d889c-17d1-4b21-ad10-7e2c26657645	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
549d889c-17d1-4b21-ad10-7e2c26657645	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
549d889c-17d1-4b21-ad10-7e2c26657645	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
549d889c-17d1-4b21-ad10-7e2c26657645	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
549d889c-17d1-4b21-ad10-7e2c26657645	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
5728e758-b0aa-4b62-8043-80f238c4cd40	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
5728e758-b0aa-4b62-8043-80f238c4cd40	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
5728e758-b0aa-4b62-8043-80f238c4cd40	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
5728e758-b0aa-4b62-8043-80f238c4cd40	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
5728e758-b0aa-4b62-8043-80f238c4cd40	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
5728e758-b0aa-4b62-8043-80f238c4cd40	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
5728e758-b0aa-4b62-8043-80f238c4cd40	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
5728e758-b0aa-4b62-8043-80f238c4cd40	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
5728e758-b0aa-4b62-8043-80f238c4cd40	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
b0ca4273-7968-414e-b700-f382100b74b1	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
b0ca4273-7968-414e-b700-f382100b74b1	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
b0ca4273-7968-414e-b700-f382100b74b1	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
b0ca4273-7968-414e-b700-f382100b74b1	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
b0ca4273-7968-414e-b700-f382100b74b1	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
b0ca4273-7968-414e-b700-f382100b74b1	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
b0ca4273-7968-414e-b700-f382100b74b1	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
b0ca4273-7968-414e-b700-f382100b74b1	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
b0ca4273-7968-414e-b700-f382100b74b1	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
b92d616c-693e-4f22-968b-fb705b1071c2	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
b92d616c-693e-4f22-968b-fb705b1071c2	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
b92d616c-693e-4f22-968b-fb705b1071c2	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
b92d616c-693e-4f22-968b-fb705b1071c2	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
b92d616c-693e-4f22-968b-fb705b1071c2	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
b92d616c-693e-4f22-968b-fb705b1071c2	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
b92d616c-693e-4f22-968b-fb705b1071c2	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
b92d616c-693e-4f22-968b-fb705b1071c2	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
b92d616c-693e-4f22-968b-fb705b1071c2	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
fb0655e9-63ba-4c31-910e-961d8fa02451	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
fb0655e9-63ba-4c31-910e-961d8fa02451	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
fb0655e9-63ba-4c31-910e-961d8fa02451	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
fb0655e9-63ba-4c31-910e-961d8fa02451	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
fb0655e9-63ba-4c31-910e-961d8fa02451	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
fb0655e9-63ba-4c31-910e-961d8fa02451	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
fb0655e9-63ba-4c31-910e-961d8fa02451	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
fb0655e9-63ba-4c31-910e-961d8fa02451	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
fb0655e9-63ba-4c31-910e-961d8fa02451	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
537e7199-81fa-4ab1-a6cc-f7fd0f710c49	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
537e7199-81fa-4ab1-a6cc-f7fd0f710c49	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
537e7199-81fa-4ab1-a6cc-f7fd0f710c49	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
537e7199-81fa-4ab1-a6cc-f7fd0f710c49	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
537e7199-81fa-4ab1-a6cc-f7fd0f710c49	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
537e7199-81fa-4ab1-a6cc-f7fd0f710c49	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
537e7199-81fa-4ab1-a6cc-f7fd0f710c49	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
537e7199-81fa-4ab1-a6cc-f7fd0f710c49	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
537e7199-81fa-4ab1-a6cc-f7fd0f710c49	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
c113f185-52b8-4ca1-acad-d855070d41ee	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
c113f185-52b8-4ca1-acad-d855070d41ee	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
c113f185-52b8-4ca1-acad-d855070d41ee	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
c113f185-52b8-4ca1-acad-d855070d41ee	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
c113f185-52b8-4ca1-acad-d855070d41ee	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
c113f185-52b8-4ca1-acad-d855070d41ee	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
c113f185-52b8-4ca1-acad-d855070d41ee	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
c113f185-52b8-4ca1-acad-d855070d41ee	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
c113f185-52b8-4ca1-acad-d855070d41ee	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
d994237c-9db0-4701-8c2b-3776cfbcbabc	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
d994237c-9db0-4701-8c2b-3776cfbcbabc	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
d994237c-9db0-4701-8c2b-3776cfbcbabc	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
d994237c-9db0-4701-8c2b-3776cfbcbabc	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
d994237c-9db0-4701-8c2b-3776cfbcbabc	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
d994237c-9db0-4701-8c2b-3776cfbcbabc	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
d994237c-9db0-4701-8c2b-3776cfbcbabc	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
d994237c-9db0-4701-8c2b-3776cfbcbabc	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
d994237c-9db0-4701-8c2b-3776cfbcbabc	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
56c97c13-6708-4975-a010-bae1463efeea	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
56c97c13-6708-4975-a010-bae1463efeea	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
56c97c13-6708-4975-a010-bae1463efeea	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
56c97c13-6708-4975-a010-bae1463efeea	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
56c97c13-6708-4975-a010-bae1463efeea	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
56c97c13-6708-4975-a010-bae1463efeea	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
56c97c13-6708-4975-a010-bae1463efeea	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
56c97c13-6708-4975-a010-bae1463efeea	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
56c97c13-6708-4975-a010-bae1463efeea	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
cb0f6873-5818-4199-821c-34db4bd515fa	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
cb0f6873-5818-4199-821c-34db4bd515fa	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
cb0f6873-5818-4199-821c-34db4bd515fa	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
cb0f6873-5818-4199-821c-34db4bd515fa	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
cb0f6873-5818-4199-821c-34db4bd515fa	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
cb0f6873-5818-4199-821c-34db4bd515fa	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
cb0f6873-5818-4199-821c-34db4bd515fa	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
cb0f6873-5818-4199-821c-34db4bd515fa	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
cb0f6873-5818-4199-821c-34db4bd515fa	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
ed5aa229-15ca-4bd4-b9c3-05905cbde6ed	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
ed5aa229-15ca-4bd4-b9c3-05905cbde6ed	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
ed5aa229-15ca-4bd4-b9c3-05905cbde6ed	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
ed5aa229-15ca-4bd4-b9c3-05905cbde6ed	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
ed5aa229-15ca-4bd4-b9c3-05905cbde6ed	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
ed5aa229-15ca-4bd4-b9c3-05905cbde6ed	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
ed5aa229-15ca-4bd4-b9c3-05905cbde6ed	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
ed5aa229-15ca-4bd4-b9c3-05905cbde6ed	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
ed5aa229-15ca-4bd4-b9c3-05905cbde6ed	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
5f336e02-2041-43a3-8210-f885ed57def1	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
5f336e02-2041-43a3-8210-f885ed57def1	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
5f336e02-2041-43a3-8210-f885ed57def1	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
5f336e02-2041-43a3-8210-f885ed57def1	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
5f336e02-2041-43a3-8210-f885ed57def1	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
5f336e02-2041-43a3-8210-f885ed57def1	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
5f336e02-2041-43a3-8210-f885ed57def1	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
5f336e02-2041-43a3-8210-f885ed57def1	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
5f336e02-2041-43a3-8210-f885ed57def1	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
772cb429-f692-4ca3-99d5-1f5342f16783	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
772cb429-f692-4ca3-99d5-1f5342f16783	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
772cb429-f692-4ca3-99d5-1f5342f16783	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
772cb429-f692-4ca3-99d5-1f5342f16783	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
772cb429-f692-4ca3-99d5-1f5342f16783	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
772cb429-f692-4ca3-99d5-1f5342f16783	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
772cb429-f692-4ca3-99d5-1f5342f16783	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
772cb429-f692-4ca3-99d5-1f5342f16783	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
772cb429-f692-4ca3-99d5-1f5342f16783	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
ad432f0f-c2a2-422b-ba4e-0c06035a3814	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
ad432f0f-c2a2-422b-ba4e-0c06035a3814	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
ad432f0f-c2a2-422b-ba4e-0c06035a3814	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
ad432f0f-c2a2-422b-ba4e-0c06035a3814	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
ad432f0f-c2a2-422b-ba4e-0c06035a3814	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
ad432f0f-c2a2-422b-ba4e-0c06035a3814	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
ad432f0f-c2a2-422b-ba4e-0c06035a3814	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
ad432f0f-c2a2-422b-ba4e-0c06035a3814	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
ad432f0f-c2a2-422b-ba4e-0c06035a3814	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
0af44cdd-f09d-4f00-8a2c-7eb158f01a4f	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
0af44cdd-f09d-4f00-8a2c-7eb158f01a4f	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
0af44cdd-f09d-4f00-8a2c-7eb158f01a4f	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
0af44cdd-f09d-4f00-8a2c-7eb158f01a4f	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
0af44cdd-f09d-4f00-8a2c-7eb158f01a4f	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
0af44cdd-f09d-4f00-8a2c-7eb158f01a4f	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
0af44cdd-f09d-4f00-8a2c-7eb158f01a4f	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
0af44cdd-f09d-4f00-8a2c-7eb158f01a4f	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
0af44cdd-f09d-4f00-8a2c-7eb158f01a4f	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
cddfeedd-5474-4d41-8f63-a7e97e2e4dfc	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
cddfeedd-5474-4d41-8f63-a7e97e2e4dfc	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
cddfeedd-5474-4d41-8f63-a7e97e2e4dfc	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
cddfeedd-5474-4d41-8f63-a7e97e2e4dfc	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
cddfeedd-5474-4d41-8f63-a7e97e2e4dfc	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
cddfeedd-5474-4d41-8f63-a7e97e2e4dfc	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
cddfeedd-5474-4d41-8f63-a7e97e2e4dfc	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
cddfeedd-5474-4d41-8f63-a7e97e2e4dfc	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
cddfeedd-5474-4d41-8f63-a7e97e2e4dfc	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
92b2e305-4936-41d9-972e-ac78b1960480	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
92b2e305-4936-41d9-972e-ac78b1960480	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
92b2e305-4936-41d9-972e-ac78b1960480	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
92b2e305-4936-41d9-972e-ac78b1960480	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
92b2e305-4936-41d9-972e-ac78b1960480	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
92b2e305-4936-41d9-972e-ac78b1960480	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
92b2e305-4936-41d9-972e-ac78b1960480	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
92b2e305-4936-41d9-972e-ac78b1960480	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
92b2e305-4936-41d9-972e-ac78b1960480	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
ba180749-f1c0-4e9d-9162-ba20e1105048	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
ba180749-f1c0-4e9d-9162-ba20e1105048	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
ba180749-f1c0-4e9d-9162-ba20e1105048	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
ba180749-f1c0-4e9d-9162-ba20e1105048	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
ba180749-f1c0-4e9d-9162-ba20e1105048	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
ba180749-f1c0-4e9d-9162-ba20e1105048	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
ba180749-f1c0-4e9d-9162-ba20e1105048	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
ba180749-f1c0-4e9d-9162-ba20e1105048	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
ba180749-f1c0-4e9d-9162-ba20e1105048	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
128c5517-bb6e-412e-a321-4e779e6f1a61	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
128c5517-bb6e-412e-a321-4e779e6f1a61	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
128c5517-bb6e-412e-a321-4e779e6f1a61	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
128c5517-bb6e-412e-a321-4e779e6f1a61	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
128c5517-bb6e-412e-a321-4e779e6f1a61	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
128c5517-bb6e-412e-a321-4e779e6f1a61	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
128c5517-bb6e-412e-a321-4e779e6f1a61	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
128c5517-bb6e-412e-a321-4e779e6f1a61	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
128c5517-bb6e-412e-a321-4e779e6f1a61	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
e0566ded-e7c6-4e29-ae9d-d3188d691f68	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
e0566ded-e7c6-4e29-ae9d-d3188d691f68	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
e0566ded-e7c6-4e29-ae9d-d3188d691f68	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
e0566ded-e7c6-4e29-ae9d-d3188d691f68	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
e0566ded-e7c6-4e29-ae9d-d3188d691f68	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
e0566ded-e7c6-4e29-ae9d-d3188d691f68	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
e0566ded-e7c6-4e29-ae9d-d3188d691f68	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
e0566ded-e7c6-4e29-ae9d-d3188d691f68	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
e0566ded-e7c6-4e29-ae9d-d3188d691f68	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
28578527-0ed7-41c8-8d0e-24def7760ee4	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
28578527-0ed7-41c8-8d0e-24def7760ee4	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
28578527-0ed7-41c8-8d0e-24def7760ee4	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
28578527-0ed7-41c8-8d0e-24def7760ee4	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
28578527-0ed7-41c8-8d0e-24def7760ee4	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
28578527-0ed7-41c8-8d0e-24def7760ee4	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
28578527-0ed7-41c8-8d0e-24def7760ee4	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
28578527-0ed7-41c8-8d0e-24def7760ee4	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
28578527-0ed7-41c8-8d0e-24def7760ee4	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
acd4eeb0-72ef-47c1-aef0-7bc223028905	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
acd4eeb0-72ef-47c1-aef0-7bc223028905	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
acd4eeb0-72ef-47c1-aef0-7bc223028905	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
acd4eeb0-72ef-47c1-aef0-7bc223028905	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
acd4eeb0-72ef-47c1-aef0-7bc223028905	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
acd4eeb0-72ef-47c1-aef0-7bc223028905	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
acd4eeb0-72ef-47c1-aef0-7bc223028905	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
acd4eeb0-72ef-47c1-aef0-7bc223028905	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
acd4eeb0-72ef-47c1-aef0-7bc223028905	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
18edc2e2-6dc4-48b2-9990-6257ce2e601c	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
18edc2e2-6dc4-48b2-9990-6257ce2e601c	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
18edc2e2-6dc4-48b2-9990-6257ce2e601c	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
18edc2e2-6dc4-48b2-9990-6257ce2e601c	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
18edc2e2-6dc4-48b2-9990-6257ce2e601c	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
18edc2e2-6dc4-48b2-9990-6257ce2e601c	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
18edc2e2-6dc4-48b2-9990-6257ce2e601c	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
18edc2e2-6dc4-48b2-9990-6257ce2e601c	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
18edc2e2-6dc4-48b2-9990-6257ce2e601c	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
2c87739d-a979-483f-9a87-40931d51f94a	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
2c87739d-a979-483f-9a87-40931d51f94a	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
2c87739d-a979-483f-9a87-40931d51f94a	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
2c87739d-a979-483f-9a87-40931d51f94a	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
2c87739d-a979-483f-9a87-40931d51f94a	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
2c87739d-a979-483f-9a87-40931d51f94a	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
2c87739d-a979-483f-9a87-40931d51f94a	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
2c87739d-a979-483f-9a87-40931d51f94a	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
2c87739d-a979-483f-9a87-40931d51f94a	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
384a90ab-00e9-428b-9c0d-21e758b96d77	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
384a90ab-00e9-428b-9c0d-21e758b96d77	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
384a90ab-00e9-428b-9c0d-21e758b96d77	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
384a90ab-00e9-428b-9c0d-21e758b96d77	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
384a90ab-00e9-428b-9c0d-21e758b96d77	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
384a90ab-00e9-428b-9c0d-21e758b96d77	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
384a90ab-00e9-428b-9c0d-21e758b96d77	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
384a90ab-00e9-428b-9c0d-21e758b96d77	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
384a90ab-00e9-428b-9c0d-21e758b96d77	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
01a2e811-b7fc-4dc5-bde3-5dcb14483856	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
01a2e811-b7fc-4dc5-bde3-5dcb14483856	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
01a2e811-b7fc-4dc5-bde3-5dcb14483856	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
01a2e811-b7fc-4dc5-bde3-5dcb14483856	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
01a2e811-b7fc-4dc5-bde3-5dcb14483856	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
01a2e811-b7fc-4dc5-bde3-5dcb14483856	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
01a2e811-b7fc-4dc5-bde3-5dcb14483856	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
01a2e811-b7fc-4dc5-bde3-5dcb14483856	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
01a2e811-b7fc-4dc5-bde3-5dcb14483856	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
3cd2409d-795d-4235-9860-e04f9a21ea1d	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
3cd2409d-795d-4235-9860-e04f9a21ea1d	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
3cd2409d-795d-4235-9860-e04f9a21ea1d	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
3cd2409d-795d-4235-9860-e04f9a21ea1d	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
3cd2409d-795d-4235-9860-e04f9a21ea1d	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
3cd2409d-795d-4235-9860-e04f9a21ea1d	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
3cd2409d-795d-4235-9860-e04f9a21ea1d	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
3cd2409d-795d-4235-9860-e04f9a21ea1d	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
3cd2409d-795d-4235-9860-e04f9a21ea1d	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
b97b5f12-3e5e-4783-b4a4-377eb673a166	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
b97b5f12-3e5e-4783-b4a4-377eb673a166	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
b97b5f12-3e5e-4783-b4a4-377eb673a166	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
b97b5f12-3e5e-4783-b4a4-377eb673a166	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
b97b5f12-3e5e-4783-b4a4-377eb673a166	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
b97b5f12-3e5e-4783-b4a4-377eb673a166	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
b97b5f12-3e5e-4783-b4a4-377eb673a166	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
b97b5f12-3e5e-4783-b4a4-377eb673a166	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
b97b5f12-3e5e-4783-b4a4-377eb673a166	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
8eee5562-1fe7-4ab5-bf14-7d44e8932507	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
8eee5562-1fe7-4ab5-bf14-7d44e8932507	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
8eee5562-1fe7-4ab5-bf14-7d44e8932507	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
8eee5562-1fe7-4ab5-bf14-7d44e8932507	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
8eee5562-1fe7-4ab5-bf14-7d44e8932507	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
8eee5562-1fe7-4ab5-bf14-7d44e8932507	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
8eee5562-1fe7-4ab5-bf14-7d44e8932507	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
8eee5562-1fe7-4ab5-bf14-7d44e8932507	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
8eee5562-1fe7-4ab5-bf14-7d44e8932507	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
0d533780-0064-4b7f-bd87-69fbb688879c	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
0d533780-0064-4b7f-bd87-69fbb688879c	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
0d533780-0064-4b7f-bd87-69fbb688879c	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
0d533780-0064-4b7f-bd87-69fbb688879c	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
0d533780-0064-4b7f-bd87-69fbb688879c	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
0d533780-0064-4b7f-bd87-69fbb688879c	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
0d533780-0064-4b7f-bd87-69fbb688879c	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
0d533780-0064-4b7f-bd87-69fbb688879c	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
0d533780-0064-4b7f-bd87-69fbb688879c	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
f01f8ace-a246-4332-8028-eca1e141db9b	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
f01f8ace-a246-4332-8028-eca1e141db9b	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
f01f8ace-a246-4332-8028-eca1e141db9b	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
f01f8ace-a246-4332-8028-eca1e141db9b	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
f01f8ace-a246-4332-8028-eca1e141db9b	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
f01f8ace-a246-4332-8028-eca1e141db9b	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
f01f8ace-a246-4332-8028-eca1e141db9b	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
f01f8ace-a246-4332-8028-eca1e141db9b	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
f01f8ace-a246-4332-8028-eca1e141db9b	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
8673ac93-5258-45ee-9780-c7eb22a0c063	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
8673ac93-5258-45ee-9780-c7eb22a0c063	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
8673ac93-5258-45ee-9780-c7eb22a0c063	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
8673ac93-5258-45ee-9780-c7eb22a0c063	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
8673ac93-5258-45ee-9780-c7eb22a0c063	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
8673ac93-5258-45ee-9780-c7eb22a0c063	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
8673ac93-5258-45ee-9780-c7eb22a0c063	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
8673ac93-5258-45ee-9780-c7eb22a0c063	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
8673ac93-5258-45ee-9780-c7eb22a0c063	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
f05e8e39-289f-4cf7-802a-1461a151c285	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
f05e8e39-289f-4cf7-802a-1461a151c285	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
f05e8e39-289f-4cf7-802a-1461a151c285	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
f05e8e39-289f-4cf7-802a-1461a151c285	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
f05e8e39-289f-4cf7-802a-1461a151c285	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
f05e8e39-289f-4cf7-802a-1461a151c285	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
f05e8e39-289f-4cf7-802a-1461a151c285	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
f05e8e39-289f-4cf7-802a-1461a151c285	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
f05e8e39-289f-4cf7-802a-1461a151c285	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
787074dd-719a-457c-a492-a8fe0d8596e5	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
787074dd-719a-457c-a492-a8fe0d8596e5	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
787074dd-719a-457c-a492-a8fe0d8596e5	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
787074dd-719a-457c-a492-a8fe0d8596e5	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
787074dd-719a-457c-a492-a8fe0d8596e5	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
787074dd-719a-457c-a492-a8fe0d8596e5	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
787074dd-719a-457c-a492-a8fe0d8596e5	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
787074dd-719a-457c-a492-a8fe0d8596e5	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
787074dd-719a-457c-a492-a8fe0d8596e5	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
2b989546-0661-42fa-af0d-d0e196f85e02	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
2b989546-0661-42fa-af0d-d0e196f85e02	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
2b989546-0661-42fa-af0d-d0e196f85e02	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
2b989546-0661-42fa-af0d-d0e196f85e02	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
2b989546-0661-42fa-af0d-d0e196f85e02	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
2b989546-0661-42fa-af0d-d0e196f85e02	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
2b989546-0661-42fa-af0d-d0e196f85e02	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
2b989546-0661-42fa-af0d-d0e196f85e02	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
2b989546-0661-42fa-af0d-d0e196f85e02	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
93c8f88c-4b1f-48c8-93c7-6273a6309a34	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
93c8f88c-4b1f-48c8-93c7-6273a6309a34	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
93c8f88c-4b1f-48c8-93c7-6273a6309a34	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
93c8f88c-4b1f-48c8-93c7-6273a6309a34	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
93c8f88c-4b1f-48c8-93c7-6273a6309a34	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
93c8f88c-4b1f-48c8-93c7-6273a6309a34	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
93c8f88c-4b1f-48c8-93c7-6273a6309a34	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
93c8f88c-4b1f-48c8-93c7-6273a6309a34	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
93c8f88c-4b1f-48c8-93c7-6273a6309a34	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
579c4065-5b39-4cc3-80d5-f3139e4d5577	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
579c4065-5b39-4cc3-80d5-f3139e4d5577	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
579c4065-5b39-4cc3-80d5-f3139e4d5577	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
579c4065-5b39-4cc3-80d5-f3139e4d5577	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
579c4065-5b39-4cc3-80d5-f3139e4d5577	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
579c4065-5b39-4cc3-80d5-f3139e4d5577	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
579c4065-5b39-4cc3-80d5-f3139e4d5577	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
579c4065-5b39-4cc3-80d5-f3139e4d5577	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
579c4065-5b39-4cc3-80d5-f3139e4d5577	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
c6f1030d-b6eb-4c84-b7c9-89a4f747ede0	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
c6f1030d-b6eb-4c84-b7c9-89a4f747ede0	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
c6f1030d-b6eb-4c84-b7c9-89a4f747ede0	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
c6f1030d-b6eb-4c84-b7c9-89a4f747ede0	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
c6f1030d-b6eb-4c84-b7c9-89a4f747ede0	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
c6f1030d-b6eb-4c84-b7c9-89a4f747ede0	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
c6f1030d-b6eb-4c84-b7c9-89a4f747ede0	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
c6f1030d-b6eb-4c84-b7c9-89a4f747ede0	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
c6f1030d-b6eb-4c84-b7c9-89a4f747ede0	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
73d5231c-a931-4a96-849e-b71a94e5a16b	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
73d5231c-a931-4a96-849e-b71a94e5a16b	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
73d5231c-a931-4a96-849e-b71a94e5a16b	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
73d5231c-a931-4a96-849e-b71a94e5a16b	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
73d5231c-a931-4a96-849e-b71a94e5a16b	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
73d5231c-a931-4a96-849e-b71a94e5a16b	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
73d5231c-a931-4a96-849e-b71a94e5a16b	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
73d5231c-a931-4a96-849e-b71a94e5a16b	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
73d5231c-a931-4a96-849e-b71a94e5a16b	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
ff24caf4-d8a1-477c-8e29-416d3e17f414	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
ff24caf4-d8a1-477c-8e29-416d3e17f414	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
ff24caf4-d8a1-477c-8e29-416d3e17f414	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
ff24caf4-d8a1-477c-8e29-416d3e17f414	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
ff24caf4-d8a1-477c-8e29-416d3e17f414	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
ff24caf4-d8a1-477c-8e29-416d3e17f414	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
ff24caf4-d8a1-477c-8e29-416d3e17f414	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
ff24caf4-d8a1-477c-8e29-416d3e17f414	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
ff24caf4-d8a1-477c-8e29-416d3e17f414	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
22b63f89-569d-4ea7-8e25-3dcc12161b05	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
22b63f89-569d-4ea7-8e25-3dcc12161b05	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
22b63f89-569d-4ea7-8e25-3dcc12161b05	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
22b63f89-569d-4ea7-8e25-3dcc12161b05	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
22b63f89-569d-4ea7-8e25-3dcc12161b05	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
22b63f89-569d-4ea7-8e25-3dcc12161b05	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
22b63f89-569d-4ea7-8e25-3dcc12161b05	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
22b63f89-569d-4ea7-8e25-3dcc12161b05	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
22b63f89-569d-4ea7-8e25-3dcc12161b05	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
04288077-5171-4568-bc3d-a6ce4900ff70	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
04288077-5171-4568-bc3d-a6ce4900ff70	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
04288077-5171-4568-bc3d-a6ce4900ff70	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
04288077-5171-4568-bc3d-a6ce4900ff70	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
04288077-5171-4568-bc3d-a6ce4900ff70	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
04288077-5171-4568-bc3d-a6ce4900ff70	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
04288077-5171-4568-bc3d-a6ce4900ff70	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
04288077-5171-4568-bc3d-a6ce4900ff70	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
04288077-5171-4568-bc3d-a6ce4900ff70	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
75c34bac-a078-4311-9c1d-9c2564635667	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
75c34bac-a078-4311-9c1d-9c2564635667	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
75c34bac-a078-4311-9c1d-9c2564635667	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
75c34bac-a078-4311-9c1d-9c2564635667	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
75c34bac-a078-4311-9c1d-9c2564635667	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
75c34bac-a078-4311-9c1d-9c2564635667	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
75c34bac-a078-4311-9c1d-9c2564635667	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
75c34bac-a078-4311-9c1d-9c2564635667	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
75c34bac-a078-4311-9c1d-9c2564635667	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
23d60e2d-8e52-43ab-804e-d3394f5d639f	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
23d60e2d-8e52-43ab-804e-d3394f5d639f	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
23d60e2d-8e52-43ab-804e-d3394f5d639f	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
23d60e2d-8e52-43ab-804e-d3394f5d639f	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
23d60e2d-8e52-43ab-804e-d3394f5d639f	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
23d60e2d-8e52-43ab-804e-d3394f5d639f	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
23d60e2d-8e52-43ab-804e-d3394f5d639f	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
23d60e2d-8e52-43ab-804e-d3394f5d639f	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
23d60e2d-8e52-43ab-804e-d3394f5d639f	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
8a519598-b376-4a97-ac22-cd42c4780011	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
8a519598-b376-4a97-ac22-cd42c4780011	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
8a519598-b376-4a97-ac22-cd42c4780011	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
8a519598-b376-4a97-ac22-cd42c4780011	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
8a519598-b376-4a97-ac22-cd42c4780011	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
8a519598-b376-4a97-ac22-cd42c4780011	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
8a519598-b376-4a97-ac22-cd42c4780011	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
8a519598-b376-4a97-ac22-cd42c4780011	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
8a519598-b376-4a97-ac22-cd42c4780011	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
4699ef5c-ef23-4eb3-9eb7-0ba222424786	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
4699ef5c-ef23-4eb3-9eb7-0ba222424786	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
4699ef5c-ef23-4eb3-9eb7-0ba222424786	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
4699ef5c-ef23-4eb3-9eb7-0ba222424786	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
4699ef5c-ef23-4eb3-9eb7-0ba222424786	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
4699ef5c-ef23-4eb3-9eb7-0ba222424786	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
4699ef5c-ef23-4eb3-9eb7-0ba222424786	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
4699ef5c-ef23-4eb3-9eb7-0ba222424786	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
4699ef5c-ef23-4eb3-9eb7-0ba222424786	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
5f346b23-73d4-47d6-a9e7-61998f4b2b87	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
5f346b23-73d4-47d6-a9e7-61998f4b2b87	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
5f346b23-73d4-47d6-a9e7-61998f4b2b87	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
5f346b23-73d4-47d6-a9e7-61998f4b2b87	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
5f346b23-73d4-47d6-a9e7-61998f4b2b87	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
5f346b23-73d4-47d6-a9e7-61998f4b2b87	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
5f346b23-73d4-47d6-a9e7-61998f4b2b87	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
5f346b23-73d4-47d6-a9e7-61998f4b2b87	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
5f346b23-73d4-47d6-a9e7-61998f4b2b87	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
39fc42fd-2aa3-4d9f-a6da-7c8a3ecc35ec	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
39fc42fd-2aa3-4d9f-a6da-7c8a3ecc35ec	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
39fc42fd-2aa3-4d9f-a6da-7c8a3ecc35ec	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
39fc42fd-2aa3-4d9f-a6da-7c8a3ecc35ec	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
39fc42fd-2aa3-4d9f-a6da-7c8a3ecc35ec	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
39fc42fd-2aa3-4d9f-a6da-7c8a3ecc35ec	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
39fc42fd-2aa3-4d9f-a6da-7c8a3ecc35ec	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
39fc42fd-2aa3-4d9f-a6da-7c8a3ecc35ec	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
39fc42fd-2aa3-4d9f-a6da-7c8a3ecc35ec	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
1d0003f2-bc29-4ecb-9277-07e6ba10584b	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
1d0003f2-bc29-4ecb-9277-07e6ba10584b	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
1d0003f2-bc29-4ecb-9277-07e6ba10584b	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
1d0003f2-bc29-4ecb-9277-07e6ba10584b	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
1d0003f2-bc29-4ecb-9277-07e6ba10584b	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
1d0003f2-bc29-4ecb-9277-07e6ba10584b	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
1d0003f2-bc29-4ecb-9277-07e6ba10584b	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
1d0003f2-bc29-4ecb-9277-07e6ba10584b	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
1d0003f2-bc29-4ecb-9277-07e6ba10584b	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
d88b63e7-3553-4554-a31b-46cbb84adf47	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
d88b63e7-3553-4554-a31b-46cbb84adf47	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
d88b63e7-3553-4554-a31b-46cbb84adf47	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
d88b63e7-3553-4554-a31b-46cbb84adf47	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
d88b63e7-3553-4554-a31b-46cbb84adf47	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
d88b63e7-3553-4554-a31b-46cbb84adf47	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
d88b63e7-3553-4554-a31b-46cbb84adf47	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
d88b63e7-3553-4554-a31b-46cbb84adf47	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
d88b63e7-3553-4554-a31b-46cbb84adf47	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
87730b79-c051-43b5-b5b3-a8d9c4e5e6aa	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
87730b79-c051-43b5-b5b3-a8d9c4e5e6aa	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
87730b79-c051-43b5-b5b3-a8d9c4e5e6aa	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
87730b79-c051-43b5-b5b3-a8d9c4e5e6aa	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
87730b79-c051-43b5-b5b3-a8d9c4e5e6aa	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
87730b79-c051-43b5-b5b3-a8d9c4e5e6aa	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
87730b79-c051-43b5-b5b3-a8d9c4e5e6aa	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
87730b79-c051-43b5-b5b3-a8d9c4e5e6aa	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
87730b79-c051-43b5-b5b3-a8d9c4e5e6aa	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
5623bfa4-2faa-48a7-9e9f-22798a019544	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
5623bfa4-2faa-48a7-9e9f-22798a019544	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
5623bfa4-2faa-48a7-9e9f-22798a019544	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
5623bfa4-2faa-48a7-9e9f-22798a019544	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
5623bfa4-2faa-48a7-9e9f-22798a019544	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
5623bfa4-2faa-48a7-9e9f-22798a019544	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
5623bfa4-2faa-48a7-9e9f-22798a019544	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
5623bfa4-2faa-48a7-9e9f-22798a019544	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
5623bfa4-2faa-48a7-9e9f-22798a019544	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
7a25e6d6-dd01-4d10-b43f-3da8cceedcaa	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
7a25e6d6-dd01-4d10-b43f-3da8cceedcaa	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
7a25e6d6-dd01-4d10-b43f-3da8cceedcaa	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
7a25e6d6-dd01-4d10-b43f-3da8cceedcaa	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
7a25e6d6-dd01-4d10-b43f-3da8cceedcaa	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
7a25e6d6-dd01-4d10-b43f-3da8cceedcaa	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
7a25e6d6-dd01-4d10-b43f-3da8cceedcaa	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
7a25e6d6-dd01-4d10-b43f-3da8cceedcaa	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
7a25e6d6-dd01-4d10-b43f-3da8cceedcaa	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
f5b4583e-9a5c-4136-b95f-16cad5175880	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
f5b4583e-9a5c-4136-b95f-16cad5175880	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
f5b4583e-9a5c-4136-b95f-16cad5175880	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
f5b4583e-9a5c-4136-b95f-16cad5175880	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
f5b4583e-9a5c-4136-b95f-16cad5175880	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
f5b4583e-9a5c-4136-b95f-16cad5175880	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
f5b4583e-9a5c-4136-b95f-16cad5175880	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
f5b4583e-9a5c-4136-b95f-16cad5175880	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
f5b4583e-9a5c-4136-b95f-16cad5175880	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
75138526-c8ff-47e5-ae4b-bfb73101364a	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
75138526-c8ff-47e5-ae4b-bfb73101364a	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
75138526-c8ff-47e5-ae4b-bfb73101364a	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
75138526-c8ff-47e5-ae4b-bfb73101364a	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
75138526-c8ff-47e5-ae4b-bfb73101364a	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
75138526-c8ff-47e5-ae4b-bfb73101364a	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
75138526-c8ff-47e5-ae4b-bfb73101364a	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
75138526-c8ff-47e5-ae4b-bfb73101364a	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
75138526-c8ff-47e5-ae4b-bfb73101364a	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
5534f268-e259-46c8-a218-7d6504828cca	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
5534f268-e259-46c8-a218-7d6504828cca	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
5534f268-e259-46c8-a218-7d6504828cca	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
5534f268-e259-46c8-a218-7d6504828cca	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
5534f268-e259-46c8-a218-7d6504828cca	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
5534f268-e259-46c8-a218-7d6504828cca	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
5534f268-e259-46c8-a218-7d6504828cca	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
5534f268-e259-46c8-a218-7d6504828cca	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
5534f268-e259-46c8-a218-7d6504828cca	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
c9aff452-059e-4054-98a9-c226dc2f81bd	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
c9aff452-059e-4054-98a9-c226dc2f81bd	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
c9aff452-059e-4054-98a9-c226dc2f81bd	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
c9aff452-059e-4054-98a9-c226dc2f81bd	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
c9aff452-059e-4054-98a9-c226dc2f81bd	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
c9aff452-059e-4054-98a9-c226dc2f81bd	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
c9aff452-059e-4054-98a9-c226dc2f81bd	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
c9aff452-059e-4054-98a9-c226dc2f81bd	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
c9aff452-059e-4054-98a9-c226dc2f81bd	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
8758901d-c2bb-4a72-8660-48ff0b5a11b6	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
8758901d-c2bb-4a72-8660-48ff0b5a11b6	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
8758901d-c2bb-4a72-8660-48ff0b5a11b6	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
8758901d-c2bb-4a72-8660-48ff0b5a11b6	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
8758901d-c2bb-4a72-8660-48ff0b5a11b6	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
8758901d-c2bb-4a72-8660-48ff0b5a11b6	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
8758901d-c2bb-4a72-8660-48ff0b5a11b6	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
8758901d-c2bb-4a72-8660-48ff0b5a11b6	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
8758901d-c2bb-4a72-8660-48ff0b5a11b6	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
f08cf432-7817-40bd-ae90-145e80f1a8d8	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
f08cf432-7817-40bd-ae90-145e80f1a8d8	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
f08cf432-7817-40bd-ae90-145e80f1a8d8	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
f08cf432-7817-40bd-ae90-145e80f1a8d8	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
f08cf432-7817-40bd-ae90-145e80f1a8d8	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
f08cf432-7817-40bd-ae90-145e80f1a8d8	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
f08cf432-7817-40bd-ae90-145e80f1a8d8	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
f08cf432-7817-40bd-ae90-145e80f1a8d8	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
f08cf432-7817-40bd-ae90-145e80f1a8d8	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
95eb925a-408c-497e-ba47-61e11c453482	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
95eb925a-408c-497e-ba47-61e11c453482	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
95eb925a-408c-497e-ba47-61e11c453482	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
95eb925a-408c-497e-ba47-61e11c453482	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
95eb925a-408c-497e-ba47-61e11c453482	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
95eb925a-408c-497e-ba47-61e11c453482	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
95eb925a-408c-497e-ba47-61e11c453482	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
95eb925a-408c-497e-ba47-61e11c453482	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
95eb925a-408c-497e-ba47-61e11c453482	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
2a257b20-e205-4bc9-8e10-5f6fa3759c92	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
2a257b20-e205-4bc9-8e10-5f6fa3759c92	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
2a257b20-e205-4bc9-8e10-5f6fa3759c92	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
2a257b20-e205-4bc9-8e10-5f6fa3759c92	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
2a257b20-e205-4bc9-8e10-5f6fa3759c92	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
2a257b20-e205-4bc9-8e10-5f6fa3759c92	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
2a257b20-e205-4bc9-8e10-5f6fa3759c92	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
2a257b20-e205-4bc9-8e10-5f6fa3759c92	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
2a257b20-e205-4bc9-8e10-5f6fa3759c92	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
05cec9a9-0a2b-4b2b-ac88-8eaa0d900301	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
05cec9a9-0a2b-4b2b-ac88-8eaa0d900301	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
05cec9a9-0a2b-4b2b-ac88-8eaa0d900301	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
05cec9a9-0a2b-4b2b-ac88-8eaa0d900301	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
05cec9a9-0a2b-4b2b-ac88-8eaa0d900301	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
05cec9a9-0a2b-4b2b-ac88-8eaa0d900301	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
05cec9a9-0a2b-4b2b-ac88-8eaa0d900301	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
05cec9a9-0a2b-4b2b-ac88-8eaa0d900301	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
05cec9a9-0a2b-4b2b-ac88-8eaa0d900301	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
968a78c6-6e9e-4a50-aa61-61402b6a3e0e	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
968a78c6-6e9e-4a50-aa61-61402b6a3e0e	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
968a78c6-6e9e-4a50-aa61-61402b6a3e0e	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
968a78c6-6e9e-4a50-aa61-61402b6a3e0e	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
968a78c6-6e9e-4a50-aa61-61402b6a3e0e	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
968a78c6-6e9e-4a50-aa61-61402b6a3e0e	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
968a78c6-6e9e-4a50-aa61-61402b6a3e0e	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
968a78c6-6e9e-4a50-aa61-61402b6a3e0e	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
968a78c6-6e9e-4a50-aa61-61402b6a3e0e	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
50b3a906-ff8c-4632-b603-5a9566fb7314	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
50b3a906-ff8c-4632-b603-5a9566fb7314	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
50b3a906-ff8c-4632-b603-5a9566fb7314	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
50b3a906-ff8c-4632-b603-5a9566fb7314	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
50b3a906-ff8c-4632-b603-5a9566fb7314	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
50b3a906-ff8c-4632-b603-5a9566fb7314	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
50b3a906-ff8c-4632-b603-5a9566fb7314	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
50b3a906-ff8c-4632-b603-5a9566fb7314	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
50b3a906-ff8c-4632-b603-5a9566fb7314	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
f07c9eb1-ec5b-48fd-8796-f34c331d6469	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
f07c9eb1-ec5b-48fd-8796-f34c331d6469	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
f07c9eb1-ec5b-48fd-8796-f34c331d6469	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
f07c9eb1-ec5b-48fd-8796-f34c331d6469	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
f07c9eb1-ec5b-48fd-8796-f34c331d6469	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
f07c9eb1-ec5b-48fd-8796-f34c331d6469	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
f07c9eb1-ec5b-48fd-8796-f34c331d6469	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
f07c9eb1-ec5b-48fd-8796-f34c331d6469	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
f07c9eb1-ec5b-48fd-8796-f34c331d6469	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
86cae7a4-bc8d-49e7-b6bc-471f4f554528	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
86cae7a4-bc8d-49e7-b6bc-471f4f554528	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
86cae7a4-bc8d-49e7-b6bc-471f4f554528	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
86cae7a4-bc8d-49e7-b6bc-471f4f554528	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
86cae7a4-bc8d-49e7-b6bc-471f4f554528	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
86cae7a4-bc8d-49e7-b6bc-471f4f554528	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
86cae7a4-bc8d-49e7-b6bc-471f4f554528	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
86cae7a4-bc8d-49e7-b6bc-471f4f554528	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
86cae7a4-bc8d-49e7-b6bc-471f4f554528	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
1b8665a2-3f8a-4465-bfae-190cc0b592e4	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
1b8665a2-3f8a-4465-bfae-190cc0b592e4	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
1b8665a2-3f8a-4465-bfae-190cc0b592e4	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
1b8665a2-3f8a-4465-bfae-190cc0b592e4	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
1b8665a2-3f8a-4465-bfae-190cc0b592e4	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
1b8665a2-3f8a-4465-bfae-190cc0b592e4	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
1b8665a2-3f8a-4465-bfae-190cc0b592e4	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
1b8665a2-3f8a-4465-bfae-190cc0b592e4	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
1b8665a2-3f8a-4465-bfae-190cc0b592e4	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
fb364657-a18d-40b0-a0cd-0cf0f0c0517e	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
fb364657-a18d-40b0-a0cd-0cf0f0c0517e	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
fb364657-a18d-40b0-a0cd-0cf0f0c0517e	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
fb364657-a18d-40b0-a0cd-0cf0f0c0517e	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
fb364657-a18d-40b0-a0cd-0cf0f0c0517e	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
fb364657-a18d-40b0-a0cd-0cf0f0c0517e	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
fb364657-a18d-40b0-a0cd-0cf0f0c0517e	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
fb364657-a18d-40b0-a0cd-0cf0f0c0517e	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
fb364657-a18d-40b0-a0cd-0cf0f0c0517e	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
5e5b6607-c2e9-40fb-bb8e-cb2c287af252	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
5e5b6607-c2e9-40fb-bb8e-cb2c287af252	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
5e5b6607-c2e9-40fb-bb8e-cb2c287af252	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
5e5b6607-c2e9-40fb-bb8e-cb2c287af252	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
5e5b6607-c2e9-40fb-bb8e-cb2c287af252	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
5e5b6607-c2e9-40fb-bb8e-cb2c287af252	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
5e5b6607-c2e9-40fb-bb8e-cb2c287af252	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
5e5b6607-c2e9-40fb-bb8e-cb2c287af252	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
5e5b6607-c2e9-40fb-bb8e-cb2c287af252	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
973c7d3f-406b-4eb9-ab7e-7cac7535f05c	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
973c7d3f-406b-4eb9-ab7e-7cac7535f05c	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
973c7d3f-406b-4eb9-ab7e-7cac7535f05c	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
973c7d3f-406b-4eb9-ab7e-7cac7535f05c	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
973c7d3f-406b-4eb9-ab7e-7cac7535f05c	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
973c7d3f-406b-4eb9-ab7e-7cac7535f05c	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
973c7d3f-406b-4eb9-ab7e-7cac7535f05c	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
973c7d3f-406b-4eb9-ab7e-7cac7535f05c	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
973c7d3f-406b-4eb9-ab7e-7cac7535f05c	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
4500095e-03e9-4c40-b226-52db505476fb	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
4500095e-03e9-4c40-b226-52db505476fb	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
4500095e-03e9-4c40-b226-52db505476fb	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
4500095e-03e9-4c40-b226-52db505476fb	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
4500095e-03e9-4c40-b226-52db505476fb	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
4500095e-03e9-4c40-b226-52db505476fb	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
4500095e-03e9-4c40-b226-52db505476fb	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
4500095e-03e9-4c40-b226-52db505476fb	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
4500095e-03e9-4c40-b226-52db505476fb	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
7008c341-7dd0-4f5b-b6e9-3449321edadb	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
7008c341-7dd0-4f5b-b6e9-3449321edadb	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
7008c341-7dd0-4f5b-b6e9-3449321edadb	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
7008c341-7dd0-4f5b-b6e9-3449321edadb	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
7008c341-7dd0-4f5b-b6e9-3449321edadb	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
7008c341-7dd0-4f5b-b6e9-3449321edadb	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
7008c341-7dd0-4f5b-b6e9-3449321edadb	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
7008c341-7dd0-4f5b-b6e9-3449321edadb	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
7008c341-7dd0-4f5b-b6e9-3449321edadb	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
52042e62-a040-44b4-851d-8b89ccd4ebb8	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
52042e62-a040-44b4-851d-8b89ccd4ebb8	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
52042e62-a040-44b4-851d-8b89ccd4ebb8	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
52042e62-a040-44b4-851d-8b89ccd4ebb8	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
52042e62-a040-44b4-851d-8b89ccd4ebb8	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
52042e62-a040-44b4-851d-8b89ccd4ebb8	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
52042e62-a040-44b4-851d-8b89ccd4ebb8	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
52042e62-a040-44b4-851d-8b89ccd4ebb8	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
52042e62-a040-44b4-851d-8b89ccd4ebb8	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
b2650c06-2951-4940-8464-dc9daa71779f	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
b2650c06-2951-4940-8464-dc9daa71779f	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
b2650c06-2951-4940-8464-dc9daa71779f	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
b2650c06-2951-4940-8464-dc9daa71779f	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
b2650c06-2951-4940-8464-dc9daa71779f	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
b2650c06-2951-4940-8464-dc9daa71779f	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
b2650c06-2951-4940-8464-dc9daa71779f	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
b2650c06-2951-4940-8464-dc9daa71779f	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
b2650c06-2951-4940-8464-dc9daa71779f	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
35ae1e82-e318-49d3-aba3-8b72a2b47b4f	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
35ae1e82-e318-49d3-aba3-8b72a2b47b4f	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
35ae1e82-e318-49d3-aba3-8b72a2b47b4f	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
35ae1e82-e318-49d3-aba3-8b72a2b47b4f	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
35ae1e82-e318-49d3-aba3-8b72a2b47b4f	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
35ae1e82-e318-49d3-aba3-8b72a2b47b4f	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
35ae1e82-e318-49d3-aba3-8b72a2b47b4f	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
35ae1e82-e318-49d3-aba3-8b72a2b47b4f	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
35ae1e82-e318-49d3-aba3-8b72a2b47b4f	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
d3b93dee-d9af-4aa2-9692-b1614a7be6f1	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
d3b93dee-d9af-4aa2-9692-b1614a7be6f1	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
d3b93dee-d9af-4aa2-9692-b1614a7be6f1	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
d3b93dee-d9af-4aa2-9692-b1614a7be6f1	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
d3b93dee-d9af-4aa2-9692-b1614a7be6f1	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
d3b93dee-d9af-4aa2-9692-b1614a7be6f1	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
d3b93dee-d9af-4aa2-9692-b1614a7be6f1	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
d3b93dee-d9af-4aa2-9692-b1614a7be6f1	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
d3b93dee-d9af-4aa2-9692-b1614a7be6f1	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
0140bba6-f382-4bfe-ac0f-bb29182669cd	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
0140bba6-f382-4bfe-ac0f-bb29182669cd	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
0140bba6-f382-4bfe-ac0f-bb29182669cd	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
0140bba6-f382-4bfe-ac0f-bb29182669cd	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
0140bba6-f382-4bfe-ac0f-bb29182669cd	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
0140bba6-f382-4bfe-ac0f-bb29182669cd	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
0140bba6-f382-4bfe-ac0f-bb29182669cd	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
0140bba6-f382-4bfe-ac0f-bb29182669cd	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
0140bba6-f382-4bfe-ac0f-bb29182669cd	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
d7e10dbe-9418-47ba-928b-565943103e2c	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
d7e10dbe-9418-47ba-928b-565943103e2c	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
d7e10dbe-9418-47ba-928b-565943103e2c	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
d7e10dbe-9418-47ba-928b-565943103e2c	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
d7e10dbe-9418-47ba-928b-565943103e2c	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
d7e10dbe-9418-47ba-928b-565943103e2c	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
d7e10dbe-9418-47ba-928b-565943103e2c	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
d7e10dbe-9418-47ba-928b-565943103e2c	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
d7e10dbe-9418-47ba-928b-565943103e2c	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
0db123fe-cb49-47ba-9dc9-8c95f22f35ba	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
0db123fe-cb49-47ba-9dc9-8c95f22f35ba	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
0db123fe-cb49-47ba-9dc9-8c95f22f35ba	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
0db123fe-cb49-47ba-9dc9-8c95f22f35ba	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
0db123fe-cb49-47ba-9dc9-8c95f22f35ba	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
0db123fe-cb49-47ba-9dc9-8c95f22f35ba	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
0db123fe-cb49-47ba-9dc9-8c95f22f35ba	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
0db123fe-cb49-47ba-9dc9-8c95f22f35ba	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
0db123fe-cb49-47ba-9dc9-8c95f22f35ba	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
38e67f88-b780-47e6-b5d1-52825d5da24b	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
38e67f88-b780-47e6-b5d1-52825d5da24b	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
38e67f88-b780-47e6-b5d1-52825d5da24b	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
38e67f88-b780-47e6-b5d1-52825d5da24b	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
38e67f88-b780-47e6-b5d1-52825d5da24b	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
38e67f88-b780-47e6-b5d1-52825d5da24b	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
38e67f88-b780-47e6-b5d1-52825d5da24b	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
38e67f88-b780-47e6-b5d1-52825d5da24b	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
38e67f88-b780-47e6-b5d1-52825d5da24b	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
74276126-98b0-472f-b541-a21591032d49	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
74276126-98b0-472f-b541-a21591032d49	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
74276126-98b0-472f-b541-a21591032d49	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
74276126-98b0-472f-b541-a21591032d49	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
74276126-98b0-472f-b541-a21591032d49	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
74276126-98b0-472f-b541-a21591032d49	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
74276126-98b0-472f-b541-a21591032d49	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
74276126-98b0-472f-b541-a21591032d49	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
74276126-98b0-472f-b541-a21591032d49	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
6f18d5b7-f53a-4e3d-b6b2-8d48a06e9c50	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
6f18d5b7-f53a-4e3d-b6b2-8d48a06e9c50	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
6f18d5b7-f53a-4e3d-b6b2-8d48a06e9c50	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
6f18d5b7-f53a-4e3d-b6b2-8d48a06e9c50	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
6f18d5b7-f53a-4e3d-b6b2-8d48a06e9c50	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
6f18d5b7-f53a-4e3d-b6b2-8d48a06e9c50	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
6f18d5b7-f53a-4e3d-b6b2-8d48a06e9c50	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
6f18d5b7-f53a-4e3d-b6b2-8d48a06e9c50	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
6f18d5b7-f53a-4e3d-b6b2-8d48a06e9c50	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
dce1e94e-ab9b-4a17-8cc9-919a76734ec5	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
dce1e94e-ab9b-4a17-8cc9-919a76734ec5	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
dce1e94e-ab9b-4a17-8cc9-919a76734ec5	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
dce1e94e-ab9b-4a17-8cc9-919a76734ec5	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
dce1e94e-ab9b-4a17-8cc9-919a76734ec5	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
dce1e94e-ab9b-4a17-8cc9-919a76734ec5	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
dce1e94e-ab9b-4a17-8cc9-919a76734ec5	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
dce1e94e-ab9b-4a17-8cc9-919a76734ec5	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
dce1e94e-ab9b-4a17-8cc9-919a76734ec5	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
cc30eb54-dc1f-4428-87a8-90f0ed77c5f8	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
cc30eb54-dc1f-4428-87a8-90f0ed77c5f8	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
cc30eb54-dc1f-4428-87a8-90f0ed77c5f8	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
cc30eb54-dc1f-4428-87a8-90f0ed77c5f8	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
cc30eb54-dc1f-4428-87a8-90f0ed77c5f8	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
cc30eb54-dc1f-4428-87a8-90f0ed77c5f8	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
cc30eb54-dc1f-4428-87a8-90f0ed77c5f8	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
cc30eb54-dc1f-4428-87a8-90f0ed77c5f8	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
cc30eb54-dc1f-4428-87a8-90f0ed77c5f8	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
c6aa6b62-037d-4244-aea3-ba5e1e8ab3bb	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
c6aa6b62-037d-4244-aea3-ba5e1e8ab3bb	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
c6aa6b62-037d-4244-aea3-ba5e1e8ab3bb	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
c6aa6b62-037d-4244-aea3-ba5e1e8ab3bb	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
c6aa6b62-037d-4244-aea3-ba5e1e8ab3bb	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
c6aa6b62-037d-4244-aea3-ba5e1e8ab3bb	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
c6aa6b62-037d-4244-aea3-ba5e1e8ab3bb	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
c6aa6b62-037d-4244-aea3-ba5e1e8ab3bb	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
c6aa6b62-037d-4244-aea3-ba5e1e8ab3bb	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
fb6dfcb0-4757-47ca-9e80-77e4d0051231	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
fb6dfcb0-4757-47ca-9e80-77e4d0051231	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
fb6dfcb0-4757-47ca-9e80-77e4d0051231	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
fb6dfcb0-4757-47ca-9e80-77e4d0051231	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
fb6dfcb0-4757-47ca-9e80-77e4d0051231	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
fb6dfcb0-4757-47ca-9e80-77e4d0051231	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
fb6dfcb0-4757-47ca-9e80-77e4d0051231	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
fb6dfcb0-4757-47ca-9e80-77e4d0051231	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
fb6dfcb0-4757-47ca-9e80-77e4d0051231	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
67ce7c9a-166e-43cb-824e-1795aa5ad3a4	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-17 23:42:32.207069+00
67ce7c9a-166e-43cb-824e-1795aa5ad3a4	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-17 23:42:32.207069+00
67ce7c9a-166e-43cb-824e-1795aa5ad3a4	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-17 23:42:32.207069+00
67ce7c9a-166e-43cb-824e-1795aa5ad3a4	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-17 23:42:32.207069+00
67ce7c9a-166e-43cb-824e-1795aa5ad3a4	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-17 23:42:32.207069+00
67ce7c9a-166e-43cb-824e-1795aa5ad3a4	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-17 23:42:32.207069+00
67ce7c9a-166e-43cb-824e-1795aa5ad3a4	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-17 23:42:32.207069+00
67ce7c9a-166e-43cb-824e-1795aa5ad3a4	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-17 23:42:32.207069+00
67ce7c9a-166e-43cb-824e-1795aa5ad3a4	d8bce359-f23c-440b-9434-495642c44acb	2026-06-17 23:42:32.207069+00
55540e96-9754-46fa-baf6-10c6692aa61a	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-18 00:29:27.650379+00
55540e96-9754-46fa-baf6-10c6692aa61a	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-18 00:29:27.650379+00
55540e96-9754-46fa-baf6-10c6692aa61a	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-18 00:29:27.650379+00
55540e96-9754-46fa-baf6-10c6692aa61a	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-18 00:29:27.650379+00
55540e96-9754-46fa-baf6-10c6692aa61a	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-18 00:29:27.650379+00
55540e96-9754-46fa-baf6-10c6692aa61a	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-18 00:29:27.650379+00
55540e96-9754-46fa-baf6-10c6692aa61a	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-18 00:29:27.650379+00
55540e96-9754-46fa-baf6-10c6692aa61a	d8bce359-f23c-440b-9434-495642c44acb	2026-06-18 00:29:27.650379+00
55540e96-9754-46fa-baf6-10c6692aa61a	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-18 00:29:27.650379+00
c3d31275-9559-4e7b-b51e-8928ccdc4137	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-24 02:44:20.257671+00
c3d31275-9559-4e7b-b51e-8928ccdc4137	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-24 02:44:20.257671+00
c3d31275-9559-4e7b-b51e-8928ccdc4137	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-24 02:44:20.257671+00
c3d31275-9559-4e7b-b51e-8928ccdc4137	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-24 02:44:20.257671+00
c3d31275-9559-4e7b-b51e-8928ccdc4137	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-24 02:44:20.257671+00
c3d31275-9559-4e7b-b51e-8928ccdc4137	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-24 02:44:20.257671+00
c3d31275-9559-4e7b-b51e-8928ccdc4137	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-06-24 02:44:20.257671+00
c3d31275-9559-4e7b-b51e-8928ccdc4137	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-24 02:44:20.257671+00
c3d31275-9559-4e7b-b51e-8928ccdc4137	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-24 02:44:20.257671+00
c3d31275-9559-4e7b-b51e-8928ccdc4137	e59bae8a-2a7d-416b-b88e-73b907a53efd	2026-06-24 02:44:20.257671+00
c3d31275-9559-4e7b-b51e-8928ccdc4137	d8bce359-f23c-440b-9434-495642c44acb	2026-06-24 02:44:20.257671+00
f9f371b2-eadc-424f-97e1-bbb28d158826	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-24 02:44:20.257671+00
f9f371b2-eadc-424f-97e1-bbb28d158826	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-24 02:44:20.257671+00
f9f371b2-eadc-424f-97e1-bbb28d158826	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-24 02:44:20.257671+00
f9f371b2-eadc-424f-97e1-bbb28d158826	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-24 02:44:20.257671+00
f9f371b2-eadc-424f-97e1-bbb28d158826	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-24 02:44:20.257671+00
f9f371b2-eadc-424f-97e1-bbb28d158826	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-24 02:44:20.257671+00
f9f371b2-eadc-424f-97e1-bbb28d158826	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-06-24 02:44:20.257671+00
f9f371b2-eadc-424f-97e1-bbb28d158826	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-24 02:44:20.257671+00
f9f371b2-eadc-424f-97e1-bbb28d158826	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-24 02:44:20.257671+00
f9f371b2-eadc-424f-97e1-bbb28d158826	e59bae8a-2a7d-416b-b88e-73b907a53efd	2026-06-24 02:44:20.257671+00
f9f371b2-eadc-424f-97e1-bbb28d158826	d8bce359-f23c-440b-9434-495642c44acb	2026-06-24 02:44:20.257671+00
76e99fea-1dbe-435d-8da3-62ce078007c2	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-24 02:44:20.257671+00
76e99fea-1dbe-435d-8da3-62ce078007c2	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-24 02:44:20.257671+00
76e99fea-1dbe-435d-8da3-62ce078007c2	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-24 02:44:20.257671+00
76e99fea-1dbe-435d-8da3-62ce078007c2	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-24 02:44:20.257671+00
76e99fea-1dbe-435d-8da3-62ce078007c2	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-24 02:44:20.257671+00
76e99fea-1dbe-435d-8da3-62ce078007c2	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-24 02:44:20.257671+00
76e99fea-1dbe-435d-8da3-62ce078007c2	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-06-24 02:44:20.257671+00
76e99fea-1dbe-435d-8da3-62ce078007c2	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-24 02:44:20.257671+00
76e99fea-1dbe-435d-8da3-62ce078007c2	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-24 02:44:20.257671+00
76e99fea-1dbe-435d-8da3-62ce078007c2	e59bae8a-2a7d-416b-b88e-73b907a53efd	2026-06-24 02:44:20.257671+00
76e99fea-1dbe-435d-8da3-62ce078007c2	d8bce359-f23c-440b-9434-495642c44acb	2026-06-24 02:44:20.257671+00
f3687008-f565-4cb1-be05-8169e6ec3440	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-24 02:44:20.257671+00
f3687008-f565-4cb1-be05-8169e6ec3440	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-24 02:44:20.257671+00
f3687008-f565-4cb1-be05-8169e6ec3440	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-24 02:44:20.257671+00
f3687008-f565-4cb1-be05-8169e6ec3440	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-24 02:44:20.257671+00
f3687008-f565-4cb1-be05-8169e6ec3440	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-24 02:44:20.257671+00
f3687008-f565-4cb1-be05-8169e6ec3440	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-24 02:44:20.257671+00
f3687008-f565-4cb1-be05-8169e6ec3440	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-06-24 02:44:20.257671+00
f3687008-f565-4cb1-be05-8169e6ec3440	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-24 02:44:20.257671+00
f3687008-f565-4cb1-be05-8169e6ec3440	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-24 02:44:20.257671+00
f3687008-f565-4cb1-be05-8169e6ec3440	e59bae8a-2a7d-416b-b88e-73b907a53efd	2026-06-24 02:44:20.257671+00
f3687008-f565-4cb1-be05-8169e6ec3440	d8bce359-f23c-440b-9434-495642c44acb	2026-06-24 02:44:20.257671+00
f96050ad-d946-46d6-a055-9a5692946237	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-24 02:44:20.257671+00
f96050ad-d946-46d6-a055-9a5692946237	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-24 02:44:20.257671+00
f96050ad-d946-46d6-a055-9a5692946237	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-24 02:44:20.257671+00
f96050ad-d946-46d6-a055-9a5692946237	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-24 02:44:20.257671+00
f96050ad-d946-46d6-a055-9a5692946237	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-24 02:44:20.257671+00
f96050ad-d946-46d6-a055-9a5692946237	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-24 02:44:20.257671+00
f96050ad-d946-46d6-a055-9a5692946237	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-06-24 02:44:20.257671+00
f96050ad-d946-46d6-a055-9a5692946237	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-24 02:44:20.257671+00
f96050ad-d946-46d6-a055-9a5692946237	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-24 02:44:20.257671+00
f96050ad-d946-46d6-a055-9a5692946237	e59bae8a-2a7d-416b-b88e-73b907a53efd	2026-06-24 02:44:20.257671+00
f96050ad-d946-46d6-a055-9a5692946237	d8bce359-f23c-440b-9434-495642c44acb	2026-06-24 02:44:20.257671+00
eff57238-37a8-4d47-b2e3-6330da3cc531	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-24 02:44:20.257671+00
eff57238-37a8-4d47-b2e3-6330da3cc531	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-24 02:44:20.257671+00
eff57238-37a8-4d47-b2e3-6330da3cc531	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-24 02:44:20.257671+00
eff57238-37a8-4d47-b2e3-6330da3cc531	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-24 02:44:20.257671+00
eff57238-37a8-4d47-b2e3-6330da3cc531	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-24 02:44:20.257671+00
eff57238-37a8-4d47-b2e3-6330da3cc531	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-24 02:44:20.257671+00
eff57238-37a8-4d47-b2e3-6330da3cc531	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-06-24 02:44:20.257671+00
eff57238-37a8-4d47-b2e3-6330da3cc531	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-24 02:44:20.257671+00
eff57238-37a8-4d47-b2e3-6330da3cc531	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-24 02:44:20.257671+00
eff57238-37a8-4d47-b2e3-6330da3cc531	e59bae8a-2a7d-416b-b88e-73b907a53efd	2026-06-24 02:44:20.257671+00
eff57238-37a8-4d47-b2e3-6330da3cc531	d8bce359-f23c-440b-9434-495642c44acb	2026-06-24 02:44:20.257671+00
42380434-937f-4b9e-ba6e-2684365eb525	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-24 02:44:20.257671+00
42380434-937f-4b9e-ba6e-2684365eb525	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-24 02:44:20.257671+00
42380434-937f-4b9e-ba6e-2684365eb525	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-24 02:44:20.257671+00
42380434-937f-4b9e-ba6e-2684365eb525	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-24 02:44:20.257671+00
42380434-937f-4b9e-ba6e-2684365eb525	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-24 02:44:20.257671+00
42380434-937f-4b9e-ba6e-2684365eb525	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-24 02:44:20.257671+00
42380434-937f-4b9e-ba6e-2684365eb525	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-06-24 02:44:20.257671+00
42380434-937f-4b9e-ba6e-2684365eb525	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-24 02:44:20.257671+00
42380434-937f-4b9e-ba6e-2684365eb525	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-24 02:44:20.257671+00
42380434-937f-4b9e-ba6e-2684365eb525	e59bae8a-2a7d-416b-b88e-73b907a53efd	2026-06-24 02:44:20.257671+00
42380434-937f-4b9e-ba6e-2684365eb525	d8bce359-f23c-440b-9434-495642c44acb	2026-06-24 02:44:20.257671+00
150683a8-2efd-44c7-b915-1b741f7122af	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-24 02:44:20.257671+00
150683a8-2efd-44c7-b915-1b741f7122af	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-24 02:44:20.257671+00
150683a8-2efd-44c7-b915-1b741f7122af	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-24 02:44:20.257671+00
150683a8-2efd-44c7-b915-1b741f7122af	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-24 02:44:20.257671+00
150683a8-2efd-44c7-b915-1b741f7122af	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-24 02:44:20.257671+00
150683a8-2efd-44c7-b915-1b741f7122af	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-24 02:44:20.257671+00
150683a8-2efd-44c7-b915-1b741f7122af	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-06-24 02:44:20.257671+00
150683a8-2efd-44c7-b915-1b741f7122af	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-24 02:44:20.257671+00
150683a8-2efd-44c7-b915-1b741f7122af	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-24 02:44:20.257671+00
150683a8-2efd-44c7-b915-1b741f7122af	e59bae8a-2a7d-416b-b88e-73b907a53efd	2026-06-24 02:44:20.257671+00
150683a8-2efd-44c7-b915-1b741f7122af	d8bce359-f23c-440b-9434-495642c44acb	2026-06-24 02:44:20.257671+00
9ae3f685-c32e-46dc-8165-557caebe0c96	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-24 02:44:20.257671+00
9ae3f685-c32e-46dc-8165-557caebe0c96	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-24 02:44:20.257671+00
9ae3f685-c32e-46dc-8165-557caebe0c96	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-24 02:44:20.257671+00
9ae3f685-c32e-46dc-8165-557caebe0c96	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-24 02:44:20.257671+00
9ae3f685-c32e-46dc-8165-557caebe0c96	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-24 02:44:20.257671+00
9ae3f685-c32e-46dc-8165-557caebe0c96	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-24 02:44:20.257671+00
9ae3f685-c32e-46dc-8165-557caebe0c96	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-06-24 02:44:20.257671+00
9ae3f685-c32e-46dc-8165-557caebe0c96	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-24 02:44:20.257671+00
9ae3f685-c32e-46dc-8165-557caebe0c96	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-24 02:44:20.257671+00
9ae3f685-c32e-46dc-8165-557caebe0c96	e59bae8a-2a7d-416b-b88e-73b907a53efd	2026-06-24 02:44:20.257671+00
9ae3f685-c32e-46dc-8165-557caebe0c96	d8bce359-f23c-440b-9434-495642c44acb	2026-06-24 02:44:20.257671+00
33b220e4-0864-4b73-8850-cc7693646155	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-24 02:44:20.257671+00
33b220e4-0864-4b73-8850-cc7693646155	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-24 02:44:20.257671+00
33b220e4-0864-4b73-8850-cc7693646155	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-24 02:44:20.257671+00
33b220e4-0864-4b73-8850-cc7693646155	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-24 02:44:20.257671+00
33b220e4-0864-4b73-8850-cc7693646155	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-24 02:44:20.257671+00
33b220e4-0864-4b73-8850-cc7693646155	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-24 02:44:20.257671+00
33b220e4-0864-4b73-8850-cc7693646155	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-06-24 02:44:20.257671+00
33b220e4-0864-4b73-8850-cc7693646155	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-24 02:44:20.257671+00
33b220e4-0864-4b73-8850-cc7693646155	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-24 02:44:20.257671+00
33b220e4-0864-4b73-8850-cc7693646155	e59bae8a-2a7d-416b-b88e-73b907a53efd	2026-06-24 02:44:20.257671+00
33b220e4-0864-4b73-8850-cc7693646155	d8bce359-f23c-440b-9434-495642c44acb	2026-06-24 02:44:20.257671+00
417c837a-0534-42c8-9e68-fc6dcd5e73fd	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-24 02:44:20.257671+00
417c837a-0534-42c8-9e68-fc6dcd5e73fd	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-24 02:44:20.257671+00
417c837a-0534-42c8-9e68-fc6dcd5e73fd	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-24 02:44:20.257671+00
417c837a-0534-42c8-9e68-fc6dcd5e73fd	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-24 02:44:20.257671+00
417c837a-0534-42c8-9e68-fc6dcd5e73fd	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-24 02:44:20.257671+00
417c837a-0534-42c8-9e68-fc6dcd5e73fd	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-24 02:44:20.257671+00
417c837a-0534-42c8-9e68-fc6dcd5e73fd	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-06-24 02:44:20.257671+00
417c837a-0534-42c8-9e68-fc6dcd5e73fd	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-24 02:44:20.257671+00
417c837a-0534-42c8-9e68-fc6dcd5e73fd	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-24 02:44:20.257671+00
417c837a-0534-42c8-9e68-fc6dcd5e73fd	e59bae8a-2a7d-416b-b88e-73b907a53efd	2026-06-24 02:44:20.257671+00
417c837a-0534-42c8-9e68-fc6dcd5e73fd	d8bce359-f23c-440b-9434-495642c44acb	2026-06-24 02:44:20.257671+00
0045aaf1-97a5-4987-83ed-0aaec9ab162d	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-06-24 02:44:20.257671+00
0045aaf1-97a5-4987-83ed-0aaec9ab162d	d40c373a-b549-4493-9759-c1baf120cea5	2026-06-24 02:44:20.257671+00
0045aaf1-97a5-4987-83ed-0aaec9ab162d	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-06-24 02:44:20.257671+00
0045aaf1-97a5-4987-83ed-0aaec9ab162d	225664ba-642a-4d25-9bd5-56bc66e03181	2026-06-24 02:44:20.257671+00
0045aaf1-97a5-4987-83ed-0aaec9ab162d	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-06-24 02:44:20.257671+00
0045aaf1-97a5-4987-83ed-0aaec9ab162d	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-06-24 02:44:20.257671+00
0045aaf1-97a5-4987-83ed-0aaec9ab162d	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-06-24 02:44:20.257671+00
0045aaf1-97a5-4987-83ed-0aaec9ab162d	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-06-24 02:44:20.257671+00
0045aaf1-97a5-4987-83ed-0aaec9ab162d	7fc3565c-b947-47f5-927c-3c810bef2c45	2026-06-24 02:44:20.257671+00
0045aaf1-97a5-4987-83ed-0aaec9ab162d	e59bae8a-2a7d-416b-b88e-73b907a53efd	2026-06-24 02:44:20.257671+00
0045aaf1-97a5-4987-83ed-0aaec9ab162d	d8bce359-f23c-440b-9434-495642c44acb	2026-06-24 02:44:20.257671+00
bf079329-8a42-46fe-a8dc-f0e452995d45	5ee11959-50df-4bc1-843a-3c6aea85a899	2026-06-24 04:09:35.302001+00
6d6fd936-15ae-4558-a606-6f11000279da	d40c373a-b549-4493-9759-c1baf120cea5	2026-07-04 07:05:48.86847+00
6d6fd936-15ae-4558-a606-6f11000279da	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-07-04 07:05:48.86847+00
6d6fd936-15ae-4558-a606-6f11000279da	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-07-04 07:05:48.86847+00
6d6fd936-15ae-4558-a606-6f11000279da	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-07-04 07:05:48.86847+00
6d6fd936-15ae-4558-a606-6f11000279da	225664ba-642a-4d25-9bd5-56bc66e03181	2026-07-04 07:05:48.86847+00
6d6fd936-15ae-4558-a606-6f11000279da	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-07-04 07:05:48.86847+00
6d6fd936-15ae-4558-a606-6f11000279da	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-07-04 07:05:48.86847+00
6d6fd936-15ae-4558-a606-6f11000279da	d8bce359-f23c-440b-9434-495642c44acb	2026-07-04 07:05:48.86847+00
9b2eaa71-051e-44fd-bb0a-79da454a3c8b	d40c373a-b549-4493-9759-c1baf120cea5	2026-07-04 07:05:48.86847+00
9b2eaa71-051e-44fd-bb0a-79da454a3c8b	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-07-04 07:05:48.86847+00
9b2eaa71-051e-44fd-bb0a-79da454a3c8b	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-07-04 07:05:48.86847+00
9b2eaa71-051e-44fd-bb0a-79da454a3c8b	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-07-04 07:05:48.86847+00
9b2eaa71-051e-44fd-bb0a-79da454a3c8b	225664ba-642a-4d25-9bd5-56bc66e03181	2026-07-04 07:05:48.86847+00
9b2eaa71-051e-44fd-bb0a-79da454a3c8b	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-07-04 07:05:48.86847+00
9b2eaa71-051e-44fd-bb0a-79da454a3c8b	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-07-04 07:05:48.86847+00
9b2eaa71-051e-44fd-bb0a-79da454a3c8b	d8bce359-f23c-440b-9434-495642c44acb	2026-07-04 07:05:48.86847+00
9ed3cc54-5064-4a52-9bdb-b3e6e723cee7	d40c373a-b549-4493-9759-c1baf120cea5	2026-07-04 07:05:48.86847+00
9ed3cc54-5064-4a52-9bdb-b3e6e723cee7	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-07-04 07:05:48.86847+00
9ed3cc54-5064-4a52-9bdb-b3e6e723cee7	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-07-04 07:05:48.86847+00
9ed3cc54-5064-4a52-9bdb-b3e6e723cee7	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-07-04 07:05:48.86847+00
9ed3cc54-5064-4a52-9bdb-b3e6e723cee7	225664ba-642a-4d25-9bd5-56bc66e03181	2026-07-04 07:05:48.86847+00
9ed3cc54-5064-4a52-9bdb-b3e6e723cee7	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-07-04 07:05:48.86847+00
9ed3cc54-5064-4a52-9bdb-b3e6e723cee7	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-07-04 07:05:48.86847+00
9ed3cc54-5064-4a52-9bdb-b3e6e723cee7	d8bce359-f23c-440b-9434-495642c44acb	2026-07-04 07:05:48.86847+00
80bfca58-e1c3-42b7-8366-29d99f7d2249	d40c373a-b549-4493-9759-c1baf120cea5	2026-07-04 07:05:48.86847+00
80bfca58-e1c3-42b7-8366-29d99f7d2249	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-07-04 07:05:48.86847+00
80bfca58-e1c3-42b7-8366-29d99f7d2249	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-07-04 07:05:48.86847+00
80bfca58-e1c3-42b7-8366-29d99f7d2249	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-07-04 07:05:48.86847+00
80bfca58-e1c3-42b7-8366-29d99f7d2249	225664ba-642a-4d25-9bd5-56bc66e03181	2026-07-04 07:05:48.86847+00
80bfca58-e1c3-42b7-8366-29d99f7d2249	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-07-04 07:05:48.86847+00
80bfca58-e1c3-42b7-8366-29d99f7d2249	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-07-04 07:05:48.86847+00
80bfca58-e1c3-42b7-8366-29d99f7d2249	d8bce359-f23c-440b-9434-495642c44acb	2026-07-04 07:05:48.86847+00
6ec5a866-74ce-4b17-8eb9-12a82971cef4	d40c373a-b549-4493-9759-c1baf120cea5	2026-07-04 07:05:48.86847+00
6ec5a866-74ce-4b17-8eb9-12a82971cef4	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-07-04 07:05:48.86847+00
6ec5a866-74ce-4b17-8eb9-12a82971cef4	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-07-04 07:05:48.86847+00
6ec5a866-74ce-4b17-8eb9-12a82971cef4	9dd979c8-3368-4968-8e85-99eca417bf4d	2026-07-04 07:05:48.86847+00
6ec5a866-74ce-4b17-8eb9-12a82971cef4	225664ba-642a-4d25-9bd5-56bc66e03181	2026-07-04 07:05:48.86847+00
6ec5a866-74ce-4b17-8eb9-12a82971cef4	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-07-04 07:05:48.86847+00
6ec5a866-74ce-4b17-8eb9-12a82971cef4	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-07-04 07:05:48.86847+00
6ec5a866-74ce-4b17-8eb9-12a82971cef4	d8bce359-f23c-440b-9434-495642c44acb	2026-07-04 07:05:48.86847+00
c99434e8-9d42-4dfa-8cfe-af1966fc57de	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-07-04 12:24:54.087354+00
c99434e8-9d42-4dfa-8cfe-af1966fc57de	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-07-04 12:24:54.087354+00
c99434e8-9d42-4dfa-8cfe-af1966fc57de	d40c373a-b549-4493-9759-c1baf120cea5	2026-07-04 12:24:54.087354+00
c99434e8-9d42-4dfa-8cfe-af1966fc57de	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-07-04 12:24:54.087354+00
c99434e8-9d42-4dfa-8cfe-af1966fc57de	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-07-04 12:24:54.087354+00
c99434e8-9d42-4dfa-8cfe-af1966fc57de	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-07-04 12:24:54.087354+00
41f34fa5-45a6-45f7-9c13-59d13eb36eba	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-07-04 12:24:54.087354+00
41f34fa5-45a6-45f7-9c13-59d13eb36eba	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-07-04 12:24:54.087354+00
41f34fa5-45a6-45f7-9c13-59d13eb36eba	d40c373a-b549-4493-9759-c1baf120cea5	2026-07-04 12:24:54.087354+00
41f34fa5-45a6-45f7-9c13-59d13eb36eba	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-07-04 12:24:54.087354+00
41f34fa5-45a6-45f7-9c13-59d13eb36eba	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-07-04 12:24:54.087354+00
41f34fa5-45a6-45f7-9c13-59d13eb36eba	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-07-04 12:24:54.087354+00
007365e9-e89f-40bd-92e7-fe02c4597a99	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-07-04 12:24:54.087354+00
007365e9-e89f-40bd-92e7-fe02c4597a99	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-07-04 12:24:54.087354+00
007365e9-e89f-40bd-92e7-fe02c4597a99	d40c373a-b549-4493-9759-c1baf120cea5	2026-07-04 12:24:54.087354+00
007365e9-e89f-40bd-92e7-fe02c4597a99	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-07-04 12:24:54.087354+00
007365e9-e89f-40bd-92e7-fe02c4597a99	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-07-04 12:24:54.087354+00
007365e9-e89f-40bd-92e7-fe02c4597a99	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-07-04 12:24:54.087354+00
660c9c25-bf4b-4822-8ef8-4c73292c9434	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-07-04 12:24:54.087354+00
660c9c25-bf4b-4822-8ef8-4c73292c9434	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-07-04 12:24:54.087354+00
660c9c25-bf4b-4822-8ef8-4c73292c9434	d40c373a-b549-4493-9759-c1baf120cea5	2026-07-04 12:24:54.087354+00
660c9c25-bf4b-4822-8ef8-4c73292c9434	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-07-04 12:24:54.087354+00
660c9c25-bf4b-4822-8ef8-4c73292c9434	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-07-04 12:24:54.087354+00
660c9c25-bf4b-4822-8ef8-4c73292c9434	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-07-04 12:24:54.087354+00
d645b12e-de81-4afe-a897-f8f7689d5a38	bc856862-b5cb-4515-a66d-e58af29bbabc	2026-07-04 12:24:54.087354+00
d645b12e-de81-4afe-a897-f8f7689d5a38	e487a51d-dd50-4014-8d5f-2c0aef544304	2026-07-04 12:24:54.087354+00
d645b12e-de81-4afe-a897-f8f7689d5a38	d40c373a-b549-4493-9759-c1baf120cea5	2026-07-04 12:24:54.087354+00
d645b12e-de81-4afe-a897-f8f7689d5a38	ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	2026-07-04 12:24:54.087354+00
d645b12e-de81-4afe-a897-f8f7689d5a38	c9f4e49c-7a31-440a-8f66-c18f7ff304ad	2026-07-04 12:24:54.087354+00
d645b12e-de81-4afe-a897-f8f7689d5a38	3ff342c5-d281-4275-a72a-853a834dfe2d	2026-07-04 12:24:54.087354+00
\.


--
-- Data for Name: phu_luc_hop_dong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.phu_luc_hop_dong (id, hop_dong_id, loai, noi_dung, ngay_hieu_luc, gia_thue_moi, ngay_ket_thuc_moi, file_pdf, nguoi_tao_id, tao_luc) FROM stdin;
\.


--
-- Data for Name: refresh_token; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.refresh_token (id, nguoi_dung_id, token, ngay_het_han, tao_luc) FROM stdin;
47d9efb3-a09e-4632-bb47-b1fdddebed24	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiIwZGY1MTdlMS0zMGQyLTQyNmQtOGVlYy1jMmM0ODJmMzQ2MTUiLCJpYXQiOjE3ODE3MzkxMjcsImV4cCI6MTc4NDMzMTEyN30.xxbLJhJB_ZMDsghCWLwshlIu9i7Uwb3w5wRwtZ5s_oydp6wvLy14zuN56F5yII1m	2026-07-17 23:32:07.195+00	2026-06-17 23:32:07.196883+00
869fb744-d7a0-4f5e-8dc5-31d8caa61c19	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiIxMWVmZjQwMS1mNDI0LTRlYWEtYWY0Ny0xZDJkM2VjMTNjZWUiLCJpYXQiOjE3ODIyNjc4ODQsImV4cCI6MTc4NDg1OTg4NH0.QR-ggKgRcd-N4QimZeo5NmUORQamREtgSWCm4HClRPXhPjOlBuy1IloGTIYl1Rk-	2026-07-24 02:24:44.083+00	2026-06-24 02:24:44.087899+00
0f4c0238-9faf-40b1-bb52-20b59b7ca8ab	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiI4NTE5Mzc5ZS0xMzE0LTRlZmYtOTNhOC1jYjZlN2Y1MjRkOGYiLCJpYXQiOjE3ODIyNjc5MDAsImV4cCI6MTc4NDg1OTkwMH0.Q6uScNcXFkV3puaA2KQDI5CHGUCwyVf5r-Oz8JExUBTk6apkB67Pkx2dNTXmi6kW	2026-07-24 02:25:00.777+00	2026-06-24 02:25:00.777484+00
dfd0dea4-1c3d-4941-81a2-c0cdadf47856	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiI2ZDk1MzU3My0yYTBiLTRmYzMtYmM1OS05YTcwMTViOGJjZDUiLCJpYXQiOjE3ODIyNzAwMjIsImV4cCI6MTc4NDg2MjAyMn0.Kuk3f5Xm_tYI9--dNu0d8NVDi_qhQO2upITFQWddjCaFq04cgHVicZSrPvsoK2m_	2026-07-24 03:00:22.073+00	2026-06-24 03:00:22.073821+00
40f56cc6-bbb8-4174-8046-6b0f16a6adad	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiI3OGUzZmRmMy04NzIwLTQxMjQtOGFjYy0zZDY1MDAzMTA1M2IiLCJpYXQiOjE3ODIyNzA1NDUsImV4cCI6MTc4NDg2MjU0NX0.Q0xp_dJfexk678ZChEwjlFBMBpDoRpxsvVnlHborc_CJwlmcLcpeZmITInXvOUme	2026-07-24 03:09:05.808+00	2026-06-24 03:09:05.809123+00
14cccd0e-f196-4f8c-b54c-9e61c4721f39	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiIzNDdhYmEyNC04ZDlmLTRhNjEtODhjZS1kYjhjYmRjNDJhMjMiLCJpYXQiOjE3ODIyNzA3MjcsImV4cCI6MTc4NDg2MjcyN30.mWgnV5SfiKnRi739A76hrCgVDoJBhk9P4UE_ocKETLeTtp2jARP8-o_hDlnqU5OY	2026-07-24 03:12:07.71+00	2026-06-24 03:12:07.711132+00
6468cf50-591f-4d9e-99bf-4deaa04728ad	11a616e8-e290-476f-ac28-fcef0466f571	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIxMWE2MTZlOC1lMjkwLTQ3NmYtYWMyOC1mY2VmMDQ2NmY1NzEiLCJqdGkiOiIyNzU4YTk4NC1mYmZhLTQ4ZWQtYWI3OC0yZjNiOThkNTc3MzkiLCJpYXQiOjE3ODIyNzA4MTEsImV4cCI6MTc4NDg2MjgxMX0.md_toEl8Iy1hLzrEdkqVjHiHFpLH6rNza7r-4jzv8ZlqBPz_10KvhgqGx8fA1j5E	2026-07-24 03:13:31.6+00	2026-06-24 03:13:31.6009+00
628632aa-257e-4bc8-8d55-5139da2226df	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiI1M2JkNTgyNi1jMTlkLTQyNTUtYTA5NC05NmU2ODQ3ODU3MTciLCJpYXQiOjE3ODIyNzA5NDYsImV4cCI6MTc4NDg2Mjk0Nn0.renZtIUv26ssUg9ZBgFz_JEEbs9sFC1rgpnW78VLRGm_aYuw2fsO2v5iANI4SYKo	2026-07-24 03:15:46.278+00	2026-06-24 03:15:46.279346+00
ea090518-7268-48ee-99c1-10a743b8d9fb	11a616e8-e290-476f-ac28-fcef0466f571	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIxMWE2MTZlOC1lMjkwLTQ3NmYtYWMyOC1mY2VmMDQ2NmY1NzEiLCJqdGkiOiIzMWJkY2MyNC0zNjEzLTQ1ZjMtOGVhMS00NWJhNjY3OTA1YjUiLCJpYXQiOjE3ODIyNzE5NzQsImV4cCI6MTc4NDg2Mzk3NH0.S5oFwvbj7OuGZ79IiR2epFkTWoHBbr0UdAR-kVxJNCyDO_j95sfigWiwumFLqpVz	2026-07-24 03:32:54.981+00	2026-06-24 03:32:54.981489+00
1555d5da-cbfe-454f-9e3b-13ee5a9037d0	11a616e8-e290-476f-ac28-fcef0466f571	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIxMWE2MTZlOC1lMjkwLTQ3NmYtYWMyOC1mY2VmMDQ2NmY1NzEiLCJqdGkiOiJiNjYxZjU5ZC00ZTU4LTRlYjItYjlmNS1hNDJmODY2ZWJmY2YiLCJpYXQiOjE3ODIyNzIwNTAsImV4cCI6MTc4NDg2NDA1MH0.UKjCu_MQ0RwAlQrV-RzKnza_sr23jPo-AI01JznVDKbtO9BApOlJHHvS0NdvU2No	2026-07-24 03:34:10.988+00	2026-06-24 03:34:10.989371+00
f055e7d1-6c59-4193-a9cf-0951ee446eed	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiJjNTI5YmM3OS05ZjJjLTQ5ZTAtODQ0ZS1lYTljZTFiNjY4NmUiLCJpYXQiOjE3ODIyNzIwNzQsImV4cCI6MTc4NDg2NDA3NH0.iAaP3gXdHOcXQpCu3W_CxFnB9BMBMktRl6hOCjdg77_vZ71YHxit7eGQhZBtgmMT	2026-07-24 03:34:34.642+00	2026-06-24 03:34:34.642808+00
af64992c-9f19-44ad-bf16-7f314042aeed	ffba4a1a-b837-44d1-b647-cbcc4a5ddac9	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmZmJhNGExYS1iODM3LTQ0ZDEtYjY0Ny1jYmNjNGE1ZGRhYzkiLCJqdGkiOiI5NjcxZDM1NS0xNjYwLTQ5YjQtOTk3OC05M2Q0ZGM1N2E2ZTUiLCJpYXQiOjE3ODIyNzIxNDgsImV4cCI6MTc4NDg2NDE0OH0.e0ZwuNoQVwFqN10jX2z9qmId6ETt-QqpCxmkr7G4Rnn6063ye4EkDeYk-sgUr6o9	2026-07-24 03:35:48.987+00	2026-06-24 03:35:48.987142+00
4ce5b64e-2ed7-4850-9aa3-f8d16af3d250	ffba4a1a-b837-44d1-b647-cbcc4a5ddac9	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmZmJhNGExYS1iODM3LTQ0ZDEtYjY0Ny1jYmNjNGE1ZGRhYzkiLCJqdGkiOiI2YzBmYTRmYi05ZDdjLTQyMGQtOTBkOS1hNzFlOWY1ZTdiN2IiLCJpYXQiOjE3ODIyNzIxNjUsImV4cCI6MTc4NDg2NDE2NX0.h4v-tZKIjqRmoQEcwWMT9ltyhxp2eQqHZ79AWH1xTitqkKZfCiMWqnb4kPtl-8R_	2026-07-24 03:36:05.626+00	2026-06-24 03:36:05.62628+00
7093e9f0-479e-4f78-bce3-9349628fdd06	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiJkMGMyYTNjNC1iMDk3LTRjNTUtOGFmNi0yZTExNDJiOTRkM2IiLCJpYXQiOjE3ODIyNzIyMjksImV4cCI6MTc4NDg2NDIyOX0.Rzmb5aPawtjkSN6zUVQ4IqmhSvmgsWNfvOw_7JMYEJZ2asVsf867Jp72fpKdRZoY	2026-07-24 03:37:09.162+00	2026-06-24 03:37:09.162877+00
505b2cf5-92d8-441f-a399-b1e0d0aa7584	ffba4a1a-b837-44d1-b647-cbcc4a5ddac9	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmZmJhNGExYS1iODM3LTQ0ZDEtYjY0Ny1jYmNjNGE1ZGRhYzkiLCJqdGkiOiJjODI1YTljOS0zYTE3LTQ2NTktYmFmMC1jZjIzM2VmZWQ4ZWEiLCJpYXQiOjE3ODIyNzIyNzIsImV4cCI6MTc4NDg2NDI3Mn0.IzlA7_QyzHMjSsENNPP_7Fq6X8d34pC-yw522T-MIEkhYvr2PPFBqmFr7Ybyu0iM	2026-07-24 03:37:52.895+00	2026-06-24 03:37:52.895681+00
d53cc386-25ce-4be0-8e89-e9121d4c4157	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiIwNGYzNGVhYi01NDJjLTRiMTgtYjIyMS1mZmFkODJjNzY1YmIiLCJpYXQiOjE3ODIyNzIzMDgsImV4cCI6MTc4NDg2NDMwOH0.E3szmypIAng2c8iqehhJMSLUK-VNfl7N2KfV8BHIhI8gTvgsOkIJGK_LXQkLTi-W	2026-07-24 03:38:28.03+00	2026-06-24 03:38:28.031095+00
f514e904-d538-4ada-b01e-fb637278c0f4	ffba4a1a-b837-44d1-b647-cbcc4a5ddac9	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmZmJhNGExYS1iODM3LTQ0ZDEtYjY0Ny1jYmNjNGE1ZGRhYzkiLCJqdGkiOiJlODlhNDgwNy0wNDQxLTQ1ODAtYmM5MC1mNTI3YWI4ZDEzOGUiLCJpYXQiOjE3ODIyNzIzNDAsImV4cCI6MTc4NDg2NDM0MH0.iSktvNFgYGxE9ZJqHJlFqoW7zPytg0_Lr0DDq8WLgLG0Lbcoc9R7gdZKhtCt55xp	2026-07-24 03:39:00.916+00	2026-06-24 03:39:00.916714+00
ec8ae891-d3ba-4333-a2e7-c9a8a8c7d0a7	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiJiMWMzMjNhMS1iZjA5LTQ5M2YtYjZjMS05ZDNjZGI0NTBkOTMiLCJpYXQiOjE3ODIyNzIzNzIsImV4cCI6MTc4NDg2NDM3Mn0.JpikYfbRxzuDO84_FnSmalNFpwMasl8A_ZFDSDHKsx4GLjVIpJhb5Ik66mONjUAl	2026-07-24 03:39:32.968+00	2026-06-24 03:39:32.968926+00
d7d63934-c41a-406d-902a-9b77f17cd8cb	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiIzMjQ1ODEzMy05MzIyLTQyYmItYmYxZS1jYjk4Y2E5MzhmYTEiLCJpYXQiOjE3ODIyNzI5MTEsImV4cCI6MTc4NDg2NDkxMX0.am0kni3R00Fuowq8D1Qx9st-IcbmPtuZtNtzyx4hV_GGDHcIoSsCCtP_CObKB6yx	2026-07-24 03:48:31.965+00	2026-06-24 03:48:31.966213+00
eb240678-2da6-4dbc-a47b-663d8216483f	ffba4a1a-b837-44d1-b647-cbcc4a5ddac9	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJmZmJhNGExYS1iODM3LTQ0ZDEtYjY0Ny1jYmNjNGE1ZGRhYzkiLCJqdGkiOiI1OWQyMzkzNy1mODhjLTRhMjMtYmU5Mi0zMjY4ZTUwMmU2N2MiLCJpYXQiOjE3ODIyNzI5NTUsImV4cCI6MTc4NDg2NDk1NX0.6trzVFSLrUF4nx3mWd8bQPN8Mlhv2HSznr71_YYoqPDzM68ONP6Eu5OXVn-QgVcj	2026-07-24 03:49:15.771+00	2026-06-24 03:49:15.771278+00
0d7c7476-0e72-4d82-ac1c-0fda7890abb3	4deb410a-cef3-4ab5-b13f-a66ba1b5cd9b	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI0ZGViNDEwYS1jZWYzLTRhYjUtYjEzZi1hNjZiYTFiNWNkOWIiLCJqdGkiOiI1MGY1OWFiNi02OTMzLTRiNmUtYWJhMC1mYTZjMWQ0ZmY3OTkiLCJpYXQiOjE3ODIyNzQwNjEsImV4cCI6MTc4NDg2NjA2MX0.0U7iiXuroO86rrWKRlYjeYx4ya1F7Mzet_F8FljaqdhT_Sp-KoHr5b0PJ-HMD8JL	2026-07-24 04:07:41.301+00	2026-06-24 04:07:41.302011+00
87d39dbc-ae0d-4b4c-b7ef-22de09b41494	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiJmZjQwZjdlOC0zYmZmLTRkYzktYWJhYi01ODFkYWVjMjI3OWIiLCJpYXQiOjE3ODIyNzMwNDUsImV4cCI6MTc4NDg2NTA0NX0.2-m2wLcvm9omeKOKXp1E1xktXDzHanM9ZQ3ylzs3EnD1ymOvnaRBNRWedFuiDjJH	2026-07-24 03:50:45.604+00	2026-06-24 03:50:45.604198+00
30568c53-231a-4063-9df7-cd5f6f85984a	94f1325a-40ea-450c-945d-bcc97edf175c	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI5NGYxMzI1YS00MGVhLTQ1MGMtOTQ1ZC1iY2M5N2VkZjE3NWMiLCJqdGkiOiI0MWJhMDA2ZC0yMzQ2LTQ5ZmEtYWM0MC04Y2NkYTlmZmViMjIiLCJpYXQiOjE3ODIyNzMyMjMsImV4cCI6MTc4NDg2NTIyM30.gjxrGd31K5cNh19q_96Q3fRskXIV_fUkp3_DE2d1flLIITZzYsFeHNZZtt6xJHPv	2026-07-24 03:53:43.88+00	2026-06-24 03:53:43.880803+00
03ec0017-9d56-466d-96d6-db029a7cea9f	4deb410a-cef3-4ab5-b13f-a66ba1b5cd9b	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI0ZGViNDEwYS1jZWYzLTRhYjUtYjEzZi1hNjZiYTFiNWNkOWIiLCJqdGkiOiIzYTliNzE2YS1jNjg4LTRlOTktOTVkOC02YzE0NjgxNDEyOTAiLCJpYXQiOjE3ODIyNzQwNDcsImV4cCI6MTc4NDg2NjA0N30.zq6yUCQzeRb2lTuOqmVjflTF3glVVmuPdqypLhOV6C_OJhgBQHZoWi4OpvnLDTov	2026-07-24 04:07:27.869+00	2026-06-24 04:07:27.86943+00
d88a781b-4c6c-4032-ac89-3d0072c1699f	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiI5MTc0MGE4Ny1hYmQ3LTRjZTMtODczMC00ZWU2NDM1YjQzM2YiLCJpYXQiOjE3ODIyNzMwNTksImV4cCI6MTc4NDg2NTA1OX0.hv3f3zdfSr_ssZ7iT2xUgmQEcFM5FWjjGsl-mb1leF8Ln21t8sjIocJj9EJe3-rn	2026-07-24 03:50:59.084+00	2026-06-24 03:50:59.08503+00
44eba576-66ff-45d0-81f8-e59a7cf5f837	94f1325a-40ea-450c-945d-bcc97edf175c	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI5NGYxMzI1YS00MGVhLTQ1MGMtOTQ1ZC1iY2M5N2VkZjE3NWMiLCJqdGkiOiIwMGM1ZDI3NC0yNTJjLTRhMjAtYmRlMC1lYmU4YjQwM2QwODciLCJpYXQiOjE3ODIyNzMyMDksImV4cCI6MTc4NDg2NTIwOX0.qsSMlKup9D4NQQunDQ_cmEOE0x2T_2HQdhE-XuRAvK5Dsbi31sjb2-9LzggbR8tl	2026-07-24 03:53:29.298+00	2026-06-24 03:53:29.298564+00
dee51941-3c3a-4432-8376-d4af566fc7eb	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiIyM2MyYTllOC1kNWExLTRkMGEtODY2Ni1iZGE3YjdjMmMzNWUiLCJpYXQiOjE3ODI4Mjg0NDgsImV4cCI6MTc4NTQyMDQ0OH0.LPLj8wm7L1ikA427FwTQZ6zdo3RWSwnnTTSftt2icPmolPRRHHU1zruKr-VPLZ0r	2026-07-30 14:07:28.67+00	2026-06-30 14:07:28.671357+00
6d08a02f-94cf-49a1-9231-a580e27f53a7	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiJjZjU1NzA0My00NzU5LTQxYjktYmZjMS0wYzkwOGJlODQyZDQiLCJpYXQiOjE3ODMxNjE3NTMsImV4cCI6MTc4NTc1Mzc1M30.oGjyOajjEGwr3jYzS6CgLNjrRBei9QxRBBu_DqW4NktDHsUeQ1lcyNOxTuEFFXDe	2026-08-03 10:42:33.018+00	2026-07-04 10:42:33.020333+00
3723cece-ae76-446b-b8de-6f159fe79f12	4deb410a-cef3-4ab5-b13f-a66ba1b5cd9b	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI0ZGViNDEwYS1jZWYzLTRhYjUtYjEzZi1hNjZiYTFiNWNkOWIiLCJqdGkiOiIwMTI2ZDM5NC05MTc5LTQ5MDItOGMxNy02YzQ3MTI5ZjI3MzciLCJpYXQiOjE3ODMxNjE5NzYsImV4cCI6MTc4NTc1Mzk3Nn0.IPamavbf3AuYSZXunmEkZtyRNuFtWAvMnGOh-M96wb1BmyawFho_vhP3gNZyarMx	2026-08-03 10:46:16.43+00	2026-07-04 10:46:16.430888+00
007c9900-c652-4d8d-a94b-c273cbda3b0f	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiIyNDFlZjkzNC0zZWYxLTQ3ZjQtYTMxNS0xMmUyZThjMzYwZjQiLCJpYXQiOjE3ODMxNjI0ODQsImV4cCI6MTc4NTc1NDQ4NH0.xk7CfQciUYChAvIg9HkkwipsqXk6DJuvQJ5dzq3f-DFQ7mNlEPuQ-LnwoqGtZS_u	2026-08-03 10:54:44.842+00	2026-07-04 10:54:44.843302+00
1e3dda9a-7e63-48ee-a74c-95db1c18fc9b	4deb410a-cef3-4ab5-b13f-a66ba1b5cd9b	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI0ZGViNDEwYS1jZWYzLTRhYjUtYjEzZi1hNjZiYTFiNWNkOWIiLCJqdGkiOiJjMDE2NTIwNy1jOTRlLTQyZmUtOTlkNy1mYzBlNjg5MWMyMTMiLCJpYXQiOjE3ODMxNjYyNzksImV4cCI6MTc4NTc1ODI3OX0.hg_mbKaoiBizgvl-_aRiB0_reysxOvgeH5G4PGowwM4RJN8WBj09xROt6GCFMA6l	2026-08-03 11:57:59.388+00	2026-07-04 11:57:59.391657+00
30b48468-17f7-4c35-a87b-2878b0f9795d	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiI2MjVkZTA0Ny0xOWU5LTRhY2UtODc2Ny0yZGYyZmVjNjdjMzgiLCJpYXQiOjE3ODMxNjY3OTEsImV4cCI6MTc4NTc1ODc5MX0.Uh50EXEbI2LaylH-umOPi-dvk_4_1zH8eEfy9_FCgSxysFY7s3VDWtSGlSaUvr3D	2026-08-03 12:06:31.725+00	2026-07-04 12:06:31.725885+00
34f0454a-058b-41e2-9108-ff7545037285	3a8892b9-bb34-4524-8500-7be7e88b1de5	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzYTg4OTJiOS1iYjM0LTQ1MjQtODUwMC03YmU3ZTg4YjFkZTUiLCJqdGkiOiI2ZWYxNzllZC0yYjFmLTQ5OTEtYTVjMi0zN2FmNDg4OWYyNDAiLCJpYXQiOjE3ODMxNjg0MzUsImV4cCI6MTc4NTc2MDQzNX0.m1UynGPs8SYaHbNAwaNrR8Ja5MvLUndvwEGjy1WHJc1kafG8rz5hvsB7vqmAg2aJ	2026-08-03 12:33:55.063+00	2026-07-04 12:33:55.063727+00
aa495f6d-63a7-4ca6-a653-ab68c888ff05	3a8892b9-bb34-4524-8500-7be7e88b1de5	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzYTg4OTJiOS1iYjM0LTQ1MjQtODUwMC03YmU3ZTg4YjFkZTUiLCJqdGkiOiJkNWE2YmFjZi1mODZiLTQ2YzYtYTNjNi02NzRlOTg2NzQ1OTMiLCJpYXQiOjE3ODMxNjg0NTAsImV4cCI6MTc4NTc2MDQ1MH0.NbH1Vlz1TtMWv1pBIXMH3wGOhtsmmu-AoZihxmgkw7uGTj4IEz9L1tfO-LDckjgM	2026-08-03 12:34:10.581+00	2026-07-04 12:34:10.581473+00
3fe80fa7-2ff4-472b-9c9e-4461c808266c	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiI1ODBlODBhNy03NDkxLTQxODMtOWZlNy0yMTM4ZGUxYTI2MjAiLCJpYXQiOjE3ODMzOTY5NDYsImV4cCI6MTc4NTk4ODk0Nn0.dkxZ-mH9XdPXEaudmc8oqgLHt4WyX4vjzZ5l0M0igw4YjImD9JkyBoVAawVyqUl1	2026-08-06 04:02:26.032+00	2026-07-07 04:02:26.034587+00
ff0ca290-baf7-4215-8a38-2225dc1efafd	3a8892b9-bb34-4524-8500-7be7e88b1de5	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzYTg4OTJiOS1iYjM0LTQ1MjQtODUwMC03YmU3ZTg4YjFkZTUiLCJqdGkiOiJkMTc1NDJmNS0zMDQzLTRjMTQtOWVmYS0yYzYwOWNiZjgxOTUiLCJpYXQiOjE3ODMzOTg4OTgsImV4cCI6MTc4NTk5MDg5OH0.oUyBrGW3s6CswzTV1hLljgFNIHa6QrlnvFhk_shqS98ydpWTDIQHvPLx0yTFjC5b	2026-08-06 04:34:58.326+00	2026-07-07 04:34:58.326874+00
718a301e-2b27-49d5-b9db-de0f473d34d1	3a8892b9-bb34-4524-8500-7be7e88b1de5	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzYTg4OTJiOS1iYjM0LTQ1MjQtODUwMC03YmU3ZTg4YjFkZTUiLCJqdGkiOiJkOWE1ZTU3NC01ZDQzLTRlNWYtYTNmNy04ZDEzYTlmMzZmZTQiLCJpYXQiOjE3ODMzOTg5OTQsImV4cCI6MTc4NTk5MDk5NH0.f39gNzim28exMLuReF735Ak9Iw4TTjNW8Eh120nBta8_79cki7lg0gkSIXkADjRb	2026-08-06 04:36:34.398+00	2026-07-07 04:36:34.398627+00
5b1c3b03-c642-4578-817f-c5eed170ddd9	8faf0189-da59-48bd-a1ed-89f446fc22e3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI4ZmFmMDE4OS1kYTU5LTQ4YmQtYTFlZC04OWY0NDZmYzIyZTMiLCJqdGkiOiI3NTU3NTRhZS0wNmZiLTRmZWQtOTViYS1hMjIyYzUxMWU4NmQiLCJpYXQiOjE3ODMzOTkyNDgsImV4cCI6MTc4NTk5MTI0OH0.YElyrtvUL5Z-Cv9BtNb8xcKpYcfiwMQQ082y1iVNuxzOLzCtYebUISVwRFLa1Fn8	2026-08-06 04:40:48.906+00	2026-07-07 04:40:48.906023+00
9ca900e7-5b23-4e63-814b-cef4270826a1	8faf0189-da59-48bd-a1ed-89f446fc22e3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI4ZmFmMDE4OS1kYTU5LTQ4YmQtYTFlZC04OWY0NDZmYzIyZTMiLCJqdGkiOiIzNzdhOTFmMS0xMTBjLTRiZGItYWQ0Zi1jM2U5MzljYjFiYmIiLCJpYXQiOjE3ODMzOTkyNjMsImV4cCI6MTc4NTk5MTI2M30.bISjLhmFGFZjAwplLcdryh4pCKd874hULj3vdpz6ZI8N4wit7a0-TO8190GqxrYM	2026-08-06 04:41:03.557+00	2026-07-07 04:41:03.558034+00
c8c21c8d-e241-4eda-a09d-851fe4df7b2b	8faf0189-da59-48bd-a1ed-89f446fc22e3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI4ZmFmMDE4OS1kYTU5LTQ4YmQtYTFlZC04OWY0NDZmYzIyZTMiLCJqdGkiOiJmYjNmM2M5YS1hMmVmLTRlZjktOTYwZi03ZDdiYmQ2ZTZhNjIiLCJpYXQiOjE3ODMzOTk1NDEsImV4cCI6MTc4NTk5MTU0MX0.A1GwKU2zy_m0yzglYg_bDQk2Q1cCgPwp0zhFugFPnY2M4JG6MrLiKMdxkrWy0HHd	2026-08-06 04:45:41.878+00	2026-07-07 04:45:41.879733+00
36e7a00d-e92a-4775-bab3-e5480809dc3c	3a8892b9-bb34-4524-8500-7be7e88b1de5	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIzYTg4OTJiOS1iYjM0LTQ1MjQtODUwMC03YmU3ZTg4YjFkZTUiLCJqdGkiOiI3MzExYTI0Ni1iMGM1LTQ5ZTYtODZlMi1mZjUzOWUwODNhNTciLCJpYXQiOjE3ODM0MDAwNTEsImV4cCI6MTc4NTk5MjA1MX0.-higoClAiBxfmPlgtQ7d3DSx6zotCZ_L9dxQDCOhUn-XiI1F0rPG-oex_T_hNBk7	2026-08-06 04:54:11.449+00	2026-07-07 04:54:11.449673+00
943f3a73-c486-4742-94ab-ffa25e5cc4b7	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiIwNzFlMmQ5ZS01ZWJmLTRhNWEtOWRmOC1mMzNmYWMzYTE5MjkiLCJpYXQiOjE3ODM0NDAzNTcsImV4cCI6MTc4NjAzMjM1N30.TWyrDS22ncyo6Rd3Do885ls6wEsdQZ5WzErsb2Z_Cgcg19-glIp-vENI6YT5ae07	2026-08-06 16:05:57.309+00	2026-07-07 16:05:57.311323+00
714e2d9b-57e5-47f5-99d0-88434d99992f	dddfb501-3d25-4517-ac58-1b9225e85cb3	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkZGRmYjUwMS0zZDI1LTQ1MTctYWM1OC0xYjkyMjVlODVjYjMiLCJqdGkiOiIyYmQ0ZDUwMS0yZTFjLTRmYzItOWM2MS0yN2M1MmU5M2ExOTQiLCJpYXQiOjE3ODM0NDMzNjcsImV4cCI6MTc4NjAzNTM2N30.dcxAOdbFhpTgdKBtlZCrs8luAqKoNa8PycEa8dlfwfDL8gg9GM_b3ONV4oyFMqN0	2026-08-06 16:56:07.337+00	2026-07-07 16:56:07.338328+00
\.


--
-- Data for Name: su_co; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.su_co (id, phong_id, khach_thue_id, nguoi_bao_id, tieu_de, mo_ta, loai_su_co, uu_tien, trang_thai, nguoi_phu_trach_id, chi_phi_sua_chua, tinh_vao_hoa_don, ghi_chu_chu_nha, giai_quyet_luc, tao_luc, cap_nhat_luc) FROM stdin;
\.


--
-- Data for Name: tai_san_phong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tai_san_phong (id, phong_id, ten_tai_san, so_luong, gia_tri, tinh_trang, ghi_chu, tao_luc, cap_nhat_luc) FROM stdin;
\.


--
-- Data for Name: tang; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tang (id, nha_tro_id, so_tang, ten_tang, thu_tu_hien_thi, so_phong_du_kien, trang_thai, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
7333c137-dcbf-4c9f-b210-6ebe66dd01cf	d447489d-0757-49be-a39d-d6bb5d5b6556	1	Tang 1	1	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
8409fffe-3401-4b9c-8f6b-094f746b1552	d447489d-0757-49be-a39d-d6bb5d5b6556	2	Tang 2	2	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
df637dcb-e59f-4a77-ae34-593d0dd759a7	d447489d-0757-49be-a39d-d6bb5d5b6556	3	Tang 3	3	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
7a399ad2-dedb-486e-8041-e884aa6f5eb1	d447489d-0757-49be-a39d-d6bb5d5b6556	4	Tang 4	4	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
8cdaf6e6-1616-4c3b-b9ea-0ea04da934b3	d447489d-0757-49be-a39d-d6bb5d5b6556	5	Tang 5	5	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
2e393679-5d96-4517-8df4-edd53540c0d0	d447489d-0757-49be-a39d-d6bb5d5b6556	6	Tang 6	6	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
12495954-f371-49c6-a23f-60b365c2de26	d447489d-0757-49be-a39d-d6bb5d5b6556	7	Tang 7	7	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
b8e12939-9bc9-4312-8ce6-249a04899b67	d447489d-0757-49be-a39d-d6bb5d5b6556	8	Tang 8	8	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
020bcfab-038e-4e4a-b009-b589f888c9db	d447489d-0757-49be-a39d-d6bb5d5b6556	9	Tang 9	9	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
87babd64-94fe-4d86-9bc0-011d4394d76e	d447489d-0757-49be-a39d-d6bb5d5b6556	10	Tang 10	10	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
5854f56d-b843-41f7-9952-4002c081416e	d447489d-0757-49be-a39d-d6bb5d5b6556	11	Tang 11	11	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
d6f9a582-8315-4e98-9c27-cbc26841bab0	d447489d-0757-49be-a39d-d6bb5d5b6556	12	Tang 12	12	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
e0ed4faf-5296-4fc5-b75a-23f89a1b20c6	d447489d-0757-49be-a39d-d6bb5d5b6556	13	Tang 13	13	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
c4fb45b1-70f0-4093-9131-1bee531db922	d447489d-0757-49be-a39d-d6bb5d5b6556	14	Tang 14	14	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
372dcbca-ffc5-43a4-9af1-11021bc6a43e	d447489d-0757-49be-a39d-d6bb5d5b6556	15	Tang 15	15	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
2704f3a8-d27c-429f-978f-51f42c6c6c13	d447489d-0757-49be-a39d-d6bb5d5b6556	16	Tang 16	16	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
a6fae403-b118-436b-9b5f-54d8c33cf07a	d447489d-0757-49be-a39d-d6bb5d5b6556	17	Tang 17	17	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
1af4c2c6-a9fc-47cf-8fb3-e7feb7e84239	d447489d-0757-49be-a39d-d6bb5d5b6556	18	Tang 18	18	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
b437449b-55c0-4704-8387-901c4d64271a	d447489d-0757-49be-a39d-d6bb5d5b6556	19	Tang 19	19	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
e2ad9feb-ce74-4e19-8ddd-15fd3f087fd3	d447489d-0757-49be-a39d-d6bb5d5b6556	20	Tang 20	20	5	ACTIVE	2026-06-17 23:42:32.207069+00	2026-06-17 23:42:32.207069+00	\N
8aa45b87-526d-4aab-85d8-3a27b7441399	1a447810-275a-419f-95b1-8eaa0eef7a01	1	Tang 1	1	3	ACTIVE	2026-06-24 02:44:20.257671+00	2026-06-24 02:44:20.257671+00	\N
45161bb2-737e-48b7-ac04-c088d27e2bba	1a447810-275a-419f-95b1-8eaa0eef7a01	2	Tang 2	2	4	ACTIVE	2026-06-24 02:44:20.257671+00	2026-06-24 02:44:20.257671+00	\N
48228941-9355-4ae3-a7f9-b1fa80124267	1a447810-275a-419f-95b1-8eaa0eef7a01	3	Tang 3	3	5	ACTIVE	2026-06-24 02:44:20.257671+00	2026-06-24 02:44:20.257671+00	\N
78f648fb-177c-4e3e-8109-807342967299	8456155a-f4ff-44c4-89fb-bde594c00bd6	1	Tang 1	1	2	ACTIVE	2026-07-04 07:05:48.86847+00	2026-07-04 07:05:48.86847+00	\N
0c0a3776-b6e7-4407-b456-1a8e509881be	8456155a-f4ff-44c4-89fb-bde594c00bd6	2	Tang 2	2	3	ACTIVE	2026-07-04 07:05:48.86847+00	2026-07-04 07:05:48.86847+00	\N
9cc80625-d369-416f-ab1c-b08fa4412a15	5528f265-183e-44d1-ada8-532743022a7d	1	Tang 1	1	3	ACTIVE	2026-07-04 12:24:54.087354+00	2026-07-04 12:24:54.087354+00	\N
858bf5db-8349-4d1b-a883-69b9248061dc	5528f265-183e-44d1-ada8-532743022a7d	2	Tang 2	2	2	ACTIVE	2026-07-04 12:24:54.087354+00	2026-07-04 12:24:54.087354+00	\N
\.


--
-- Data for Name: thanh_toan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.thanh_toan (id, hoa_don_id, khach_thue_id, so_tien, ngay_thanh_toan, phuong_thuc_thanh_toan, ma_tham_chieu, external_transaction_id, trang_thai, nguoi_thanh_toan_id, nguoi_ghi_nhan_id, ghi_chu, tao_luc) FROM stdin;
9dede6f2-14c7-4a13-aa4e-024fdef1574f	c8a43de3-1281-41d1-a262-d366fb51fda2	763cc66e-a785-4c1f-9008-0ed2c4228213	2500000.00	2026-06-22 17:00:00+00	CASH	\N	\N	SUCCESS	\N	\N		2026-06-24 03:16:03.782132+00
74249784-dfac-4415-99eb-ece1dcdf70e6	37816213-ccb2-4071-9414-680c2e94bdf7	a672fd3c-0504-42a8-ad47-a5ec0f628e4a	2500000.00	2026-06-23 17:00:00+00	CASH	\N	\N	SUCCESS	\N	\N		2026-06-24 04:14:33.159254+00
d02d53aa-6ad9-40ad-af23-4bfcdf76e1db	0b8e2480-27b0-417f-a381-f739bc612925	808ec20a-5f93-4a22-86a2-40fef4f756e8	2700000.00	2026-06-25 17:00:00+00	CASH	\N	\N	SUCCESS	\N	\N		2026-06-26 17:43:52.150496+00
7d478722-6c5e-4f23-8e95-eed61b255347	9ac1b645-ad42-4d94-b5df-9be918350281	7a660e5a-738b-43da-ae2c-1a15381b7a12	3000000.00	2026-06-25 17:00:00+00	CASH	\N	\N	SUCCESS	\N	\N		2026-06-26 17:44:00.176933+00
dc865f9f-061b-450f-88bd-c382a898d131	45c82967-a604-4eaf-a0da-e47b1085f9d5	a672fd3c-0504-42a8-ad47-a5ec0f628e4a	2700000.00	2026-06-30 17:00:00+00	CASH	\N	\N	SUCCESS	\N	\N		2026-07-01 19:38:09.606196+00
84889297-e47d-4018-ab0d-2b85b1ee3fb2	ec16665e-1a4e-406e-97bb-715ba02c5872	2f14a85f-ddb6-4182-95ec-75ca5687346f	2700000.00	2026-07-04 12:36:57.606186+00	VNPAY	\N	99026011ec16665e	SUCCESS	\N	\N	VNPay | TxnRef: 99026011ec16665e	2026-07-04 12:36:57.606713+00
\.


--
-- Data for Name: thanh_vien_hop_dong; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.thanh_vien_hop_dong (id, hop_dong_id, khach_thue_id, ho_ten, so_cccd, so_dien_thoai, ngay_vao, ngay_roi, dang_o, la_nguoi_dai_dien, ghi_chu, tao_luc, cap_nhat_luc) FROM stdin;
0aa2c588-f286-4613-b922-a34fbd103a10	5f6b7466-f3f0-4a53-bd5c-072712c119de	7a660e5a-738b-43da-ae2c-1a15381b7a12	nguy???n v??n h??	066206004084	0396833875	2026-06-24	\N	t	t	\N	2026-06-24 02:32:04.464535+00	2026-06-24 02:32:04.464535+00
00dd2af3-6bd2-454e-a7d4-d89a00cb5eeb	0870facf-e577-4fac-adfe-38cc697b916e	7a660e5a-738b-43da-ae2c-1a15381b7a12	nguy???n v??n h??	066206004084	0396833875	2026-06-24	\N	t	t	\N	2026-06-24 03:06:10.269477+00	2026-06-24 03:06:10.269477+00
4245d118-1451-4d92-8a9a-ac7cfec7de52	387200fe-0565-4591-bbef-71300cc7dcf5	763cc66e-a785-4c1f-9008-0ed2c4228213	l?? v??n minh	066206004088	0357165019	2026-06-24	\N	t	t	\N	2026-06-24 03:13:01.138701+00	2026-06-24 03:13:01.138701+00
35f0eac8-bd67-42ae-a33b-db1c9dd595ac	0b4171b4-7b23-4e6d-94d2-1c3165c79472	66ff1459-9f98-4506-b6b8-34d9d9ab9d9c	linh nguy???n	099999999989	0989903903	2026-06-24	\N	t	t	\N	2026-06-24 03:35:32.313203+00	2026-06-24 03:35:32.313203+00
07afddd4-fb22-4e19-86d0-36ffbdfe6aa6	b486f460-d177-4d31-9a6d-0d25621bfaf6	808ec20a-5f93-4a22-86a2-40fef4f756e8	chung linh	066206004056	0989903901	2026-06-24	\N	t	t	\N	2026-06-24 03:51:56.122677+00	2026-06-24 03:51:56.122677+00
a7219019-4163-4fd4-8dd1-62b558c1e8be	fa05907e-eefc-49f9-a255-cce5ba87d9f0	a672fd3c-0504-42a8-ad47-a5ec0f628e4a	Chung ho??ng	099999999877	0798638798	2026-06-24	\N	t	t	\N	2026-06-24 04:05:40.828525+00	2026-06-24 04:05:40.828525+00
2906aa6a-1e60-490f-84a9-c87cb8b7a05b	f744f5b6-4a22-44ad-acf4-ad0615bff692	a672fd3c-0504-42a8-ad47-a5ec0f628e4a	Chung ho??ng	099999999877	0798638798	2026-06-26	\N	t	t	\N	2026-06-26 17:48:04.567333+00	2026-06-26 17:48:04.567333+00
c2eaa32d-ea6d-4b15-970d-b68d00e1984f	1df72449-7386-4e4a-82a1-89c55d648645	580c70c4-6c6b-4a67-97a1-03d6ccd3d8cc	h??ng th??? tr??c giang	066206005084	0357165019	2026-07-04	\N	t	t	\N	2026-07-04 12:15:27.843655+00	2026-07-04 12:15:27.843655+00
18ff9ce6-dadc-48b6-a2b0-ecda21efe3bf	3b5a2527-fcdc-41b6-b512-4be49abc8c1b	580c70c4-6c6b-4a67-97a1-03d6ccd3d8cc	h??ng th??? tr??c giang	066206005084	0357165019	2026-07-04	\N	t	t	\N	2026-07-04 12:19:41.261246+00	2026-07-04 12:19:41.261246+00
c21752ed-b0fe-4414-b716-c010a4128984	971984c0-9b21-4a99-9c49-408a87942486	2f14a85f-ddb6-4182-95ec-75ca5687346f	H?? V??n Linh	066206007804	0396822875	2026-07-04	\N	t	t	\N	2026-07-04 12:28:06.374106+00	2026-07-04 12:28:06.374106+00
f60ac7f4-d047-4605-a207-4404404f106d	bb9fdaee-6918-447b-969c-4950a8ef0a30	2f14a85f-ddb6-4182-95ec-75ca5687346f	H?? V??n Linh	066206007804	0396822875	2026-07-07	\N	t	t	\N	2026-07-07 04:52:38.071052+00	2026-07-07 04:52:38.071052+00
\.


--
-- Data for Name: thong_bao; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.thong_bao (id, nguoi_gui_id, loai, tieu_de, noi_dung, doi_tuong, doi_tuong_id, kenh, gui_tat_ca, tao_luc, cap_nhat_luc, xoa_luc) FROM stdin;
f8cbe7b6-789b-49a7-88b1-327b40636c75	\N	CONTRACT	H???p ?????ng ???? ???????c k?? ho??n t???t	H???p ?????ng thu?? ph??ng Ph??ng 202 ???? ???????c c??? hai b??n k?? x??c nh???n th??nh c??ng.	\N	\N	IN_APP	f	2026-06-24 03:57:08.063244+00	2026-06-24 03:57:08.063244+00	\N
b1a2f698-3098-42b2-ac77-dbd3e4c22c4a	\N	CONTRACT	H???p ?????ng ???? ???????c k?? ho??n t???t	H???p ?????ng thu?? ph??ng Ph??ng 305 ???? ???????c c??? hai b??n k?? x??c nh???n th??nh c??ng.	\N	\N	IN_APP	f	2026-06-24 04:07:52.49222+00	2026-06-24 04:07:52.49222+00	\N
41f1f107-c1e6-47d0-b557-565233f0a5d5	\N	APPOINTMENT	L???ch h???n xem ph??ng m???i	Kh??ch h??ng ????? ch?? c??ng ???? ?????t l???ch xem ph??ng Ph??ng 201 v??o l??c 2026-07-09T23:00Z. S??? ??i???n tho???i: 0369963725.	\N	\N	IN_APP	f	2026-07-04 12:50:57.414737+00	2026-07-04 12:50:57.414737+00	\N
\.


--
-- Data for Name: thong_bao_nguoi_nhan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.thong_bao_nguoi_nhan (id, thong_bao_id, nguoi_dung_id, da_doc, doc_luc, gui_luc, loi_gui) FROM stdin;
20cd5850-0fd6-4e56-b598-f17114e5729b	f8cbe7b6-789b-49a7-88b1-327b40636c75	94f1325a-40ea-450c-945d-bcc97edf175c	f	\N	2026-06-24 03:57:08.072206+00	\N
6b76912b-ba88-4227-b280-ecf788f72f86	f8cbe7b6-789b-49a7-88b1-327b40636c75	dddfb501-3d25-4517-ac58-1b9225e85cb3	f	\N	2026-06-24 03:57:08.072834+00	\N
0190f168-c057-48e9-ae89-c54fe7d734c1	b1a2f698-3098-42b2-ac77-dbd3e4c22c4a	4deb410a-cef3-4ab5-b13f-a66ba1b5cd9b	f	\N	2026-06-24 04:07:52.497933+00	\N
7afe20a7-983e-4db2-a6e5-a6bb6d7acfa4	b1a2f698-3098-42b2-ac77-dbd3e4c22c4a	dddfb501-3d25-4517-ac58-1b9225e85cb3	f	\N	2026-06-24 04:07:52.499172+00	\N
2f570f35-c252-420b-b595-44084d95e285	41f1f107-c1e6-47d0-b557-565233f0a5d5	dddfb501-3d25-4517-ac58-1b9225e85cb3	f	\N	2026-07-04 12:50:57.420553+00	\N
\.


--
-- Data for Name: tien_ich; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tien_ich (id, ten, bieu_tuong, tao_luc) FROM stdin;
7fc3565c-b947-47f5-927c-3c810bef2c45	M??y gi???t	\N	2026-06-17 23:42:32.207069+00
e59bae8a-2a7d-416b-b88e-73b907a53efd	B???p	\N	2026-06-24 02:44:20.257671+00
5ee11959-50df-4bc1-843a-3c6aea85a899	dieuhoa	\N	2026-06-24 04:09:35.302001+00
9dd979c8-3368-4968-8e85-99eca417bf4d	WiFi	\N	2026-06-17 23:42:32.207069+00
225664ba-642a-4d25-9bd5-56bc66e03181	Gi?????ng	\N	2026-06-17 23:42:32.207069+00
d8bce359-f23c-440b-9434-495642c44acb	TV	\N	2026-06-17 23:42:32.207069+00
bc856862-b5cb-4515-a66d-e58af29bbabc	??i???u h??a	\N	2026-06-17 23:42:32.207069+00
e487a51d-dd50-4014-8d5f-2c0aef544304	T??? qu???n ??o	\N	2026-06-17 23:42:32.207069+00
d40c373a-b549-4493-9759-c1baf120cea5	N??ng l???nh	\N	2026-06-17 23:42:32.207069+00
ff2c19e9-eda3-46e2-8b71-6339b2d02d5f	B??n l??m vi???c	\N	2026-06-17 23:42:32.207069+00
c9f4e49c-7a31-440a-8f66-c18f7ff304ad	T??? l???nh	\N	2026-06-17 23:42:32.207069+00
3ff342c5-d281-4275-a72a-853a834dfe2d	Gh???	\N	2026-06-24 02:44:20.257671+00
\.


--
-- Data for Name: vai_tro; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.vai_tro (id, ten, mo_ta, tao_luc) FROM stdin;
04c9a834-05de-43ca-aa21-eb4b9188c54e	ADMIN	Quy???n ADMIN	2026-06-17 23:31:38.984064+00
\.


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
-- Name: cau_hinh_gia cau_hinh_gia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cau_hinh_gia
    ADD CONSTRAINT cau_hinh_gia_pkey PRIMARY KEY (id);


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
-- Name: hoa_don hoa_don_hop_dong_id_ky_nam_ky_thang_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hoa_don
    ADD CONSTRAINT hoa_don_hop_dong_id_ky_nam_ky_thang_key UNIQUE (hop_dong_id, ky_nam, ky_thang);


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
-- Name: idx_audit_log_target; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_log_target ON public.audit_log USING btree (bang_tac_dong, ban_ghi_id);


--
-- Name: idx_cau_hinh_gia_nha_tro; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cau_hinh_gia_nha_tro ON public.cau_hinh_gia USING btree (nha_tro_id, loai, dang_ap_dung);


--
-- Name: idx_chi_so_phong_ky; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_chi_so_phong_ky ON public.chi_so_dien_nuoc USING btree (phong_id, loai, ky_nam, ky_thang);


--
-- Name: idx_cthd_hoa_don; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cthd_hoa_don ON public.chi_tiet_hoa_don USING btree (hoa_don_id);


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
-- Name: idx_thong_bao_recipient; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_thong_bao_recipient ON public.thong_bao_nguoi_nhan USING btree (nguoi_dung_id, da_doc);


--
-- Name: idx_tvhd_hop_dong; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tvhd_hop_dong ON public.thanh_vien_hop_dong USING btree (hop_dong_id);


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
-- Name: audit_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

--
-- Name: audit_log audit_log_admin_read; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: bank_transaction; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.bank_transaction ENABLE ROW LEVEL SECURITY;

--
-- Name: bank_transaction bank_transaction_by_nha_tro; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: cau_hinh_gia; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.cau_hinh_gia ENABLE ROW LEVEL SECURITY;

--
-- Name: cau_hinh_gia cau_hinh_gia_by_nha_tro; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: chi_so_dien_nuoc chi_so_by_room; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: chi_so_dien_nuoc; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.chi_so_dien_nuoc ENABLE ROW LEVEL SECURITY;

--
-- Name: chi_tiet_hoa_don; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.chi_tiet_hoa_don ENABLE ROW LEVEL SECURITY;

--
-- Name: chi_tiet_hoa_don chi_tiet_hoa_don_by_invoice; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: chu_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.chu_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: contract_signature; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.contract_signature ENABLE ROW LEVEL SECURITY;

--
-- Name: dat_coc_phong dat_coc_by_room; Type: POLICY; Schema: public; Owner: -
--




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
-- Name: dich_vu_hop_dong dich_vu_hop_dong_by_contract; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: dich_vu dich_vu_owner; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: email_verification_token; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.email_verification_token ENABLE ROW LEVEL SECURITY;

--
-- Name: file_media; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.file_media ENABLE ROW LEVEL SECURITY;

--
-- Name: file_media file_media_uploader_admin; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: hoa_don; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hoa_don ENABLE ROW LEVEL SECURITY;

--
-- Name: hoa_don hoa_don_by_room_or_tenant; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: hop_dong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.hop_dong ENABLE ROW LEVEL SECURITY;

--
-- Name: hop_dong hop_dong_by_room_or_tenant; Type: POLICY; Schema: public; Owner: -
--




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
-- Name: khach_thue khach_thue_owner_or_self; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: lich_hen; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lich_hen ENABLE ROW LEVEL SECURITY;

--
-- Name: lich_hen lich_hen_by_room_or_user; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: lich_su_hoa_don; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lich_su_hoa_don ENABLE ROW LEVEL SECURITY;

--
-- Name: lich_su_hoa_don lich_su_hoa_don_by_invoice; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: lich_thanh_toan; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.lich_thanh_toan ENABLE ROW LEVEL SECURITY;

--
-- Name: login_history; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.login_history ENABLE ROW LEVEL SECURITY;

--
-- Name: login_history login_history_self_or_admin; Type: POLICY; Schema: public; Owner: -
--




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
-- Name: nguoi_dung_nha_tro nguoi_dung_nha_tro_owner_admin; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: nguoi_dung nguoi_dung_self_or_admin; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: nguoi_dung_vai_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nguoi_dung_vai_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: nguoi_dung_vai_tro nguoi_dung_vai_tro_admin_write; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: nguoi_dung_vai_tro nguoi_dung_vai_tro_self_or_admin_read; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: nha_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nha_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: nha_tro nha_tro_owner_staff; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: phong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.phong ENABLE ROW LEVEL SECURITY;

--
-- Name: phong phong_by_nha_tro; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: phong_tien_ich; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.phong_tien_ich ENABLE ROW LEVEL SECURITY;

--
-- Name: phong_tien_ich phong_tien_ich_by_room; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: phu_luc_hop_dong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.phu_luc_hop_dong ENABLE ROW LEVEL SECURITY;

--
-- Name: phu_luc_hop_dong phu_luc_hop_dong_by_contract; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: refresh_token; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.refresh_token ENABLE ROW LEVEL SECURITY;

--
-- Name: su_co; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.su_co ENABLE ROW LEVEL SECURITY;

--
-- Name: su_co su_co_by_room_or_reporter; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: tang; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tang ENABLE ROW LEVEL SECURITY;

--
-- Name: thanh_toan; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.thanh_toan ENABLE ROW LEVEL SECURITY;

--
-- Name: thanh_toan thanh_toan_by_invoice; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: thanh_vien_hop_dong; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.thanh_vien_hop_dong ENABLE ROW LEVEL SECURITY;

--
-- Name: thanh_vien_hop_dong thanh_vien_hop_dong_by_contract; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: thong_bao; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.thong_bao ENABLE ROW LEVEL SECURITY;

--
-- Name: thong_bao thong_bao_insert_authenticated; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: thong_bao_nguoi_nhan; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.thong_bao_nguoi_nhan ENABLE ROW LEVEL SECURITY;

--
-- Name: thong_bao_nguoi_nhan thong_bao_recipient_insert_sender; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: thong_bao_nguoi_nhan thong_bao_recipient_read; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: thong_bao_nguoi_nhan thong_bao_recipient_update_self; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: thong_bao thong_bao_sender_or_recipient; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: tien_ich; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tien_ich ENABLE ROW LEVEL SECURITY;

--
-- Name: tien_ich tien_ich_admin_write; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: tien_ich tien_ich_read_authenticated; Type: POLICY; Schema: public; Owner: -
--




--
-- Name: vai_tro; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.vai_tro ENABLE ROW LEVEL SECURITY;

--
-- Name: vai_tro vai_tro_read_authenticated; Type: POLICY; Schema: public; Owner: -
--




--
-- PostgreSQL database dump complete
--

\unrestrict JuHwC982OhoIf53DWohsSxkw2o3DODn6k3AgyA3T0CaVu22OepQiP6Uqn2fTR8b


