


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


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "btree_gist" WITH SCHEMA "public";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."appointment_status" AS ENUM (
    'PENDING',
    'CONFIRMED',
    'CANCELLED',
    'COMPLETED'
);


ALTER TYPE "public"."appointment_status" OWNER TO "postgres";


CREATE TYPE "public"."booking_deposit_status" AS ENUM (
    'PENDING',
    'COMPLETED',
    'REFUNDED',
    'FORFEITED'
);


ALTER TYPE "public"."booking_deposit_status" OWNER TO "postgres";


CREATE TYPE "public"."calc_type" AS ENUM (
    'PER_METER',
    'PER_PERSON',
    'PER_ROOM'
);


ALTER TYPE "public"."calc_type" OWNER TO "postgres";


CREATE TYPE "public"."contract_deposit_status" AS ENUM (
    'KEPT',
    'REFUNDED',
    'DEDUCTED'
);


ALTER TYPE "public"."contract_deposit_status" OWNER TO "postgres";


CREATE TYPE "public"."contract_status" AS ENUM (
    'PENDING',
    'ACTIVE',
    'EXPIRED',
    'TERMINATED'
);


ALTER TYPE "public"."contract_status" OWNER TO "postgres";


CREATE TYPE "public"."invoice_item_type" AS ENUM (
    'ROOM',
    'ELECTRICITY',
    'WATER',
    'SERVICE',
    'INTERNET',
    'OTHER'
);


ALTER TYPE "public"."invoice_item_type" OWNER TO "postgres";


CREATE TYPE "public"."invoice_status" AS ENUM (
    'UNPAID',
    'PARTIAL',
    'PAID'
);


ALTER TYPE "public"."invoice_status" OWNER TO "postgres";


CREATE TYPE "public"."kenh_thong_bao" AS ENUM (
    'IN_APP',
    'EMAIL',
    'SMS',
    'ZALO',
    'TELEGRAM',
    'PUSH'
);


ALTER TYPE "public"."kenh_thong_bao" OWNER TO "postgres";


CREATE TYPE "public"."loai_chi_so" AS ENUM (
    'ELECTRICITY',
    'WATER'
);


ALTER TYPE "public"."loai_chi_so" OWNER TO "postgres";


CREATE TYPE "public"."loai_doi_tuong_media" AS ENUM (
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


ALTER TYPE "public"."loai_doi_tuong_media" OWNER TO "postgres";


CREATE TYPE "public"."loai_muc_hoa_don" AS ENUM (
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
    'OTHER'
);


ALTER TYPE "public"."loai_muc_hoa_don" OWNER TO "postgres";


CREATE TYPE "public"."loai_su_co_enum" AS ENUM (
    'dien_nuoc',
    'noi_that',
    've_sinh',
    'an_ninh',
    'internet',
    'khac'
);


ALTER TYPE "public"."loai_su_co_enum" OWNER TO "postgres";


CREATE TYPE "public"."loai_thong_bao" AS ENUM (
    'SYSTEM',
    'INVOICE',
    'PAYMENT',
    'CONTRACT',
    'INCIDENT',
    'APPOINTMENT',
    'DEBT'
);


ALTER TYPE "public"."loai_thong_bao" OWNER TO "postgres";


CREATE TYPE "public"."loai_tinh_phi" AS ENUM (
    'FIXED',
    'PER_PERSON',
    'PER_ROOM',
    'PER_UNIT',
    'PERCENT'
);


ALTER TYPE "public"."loai_tinh_phi" OWNER TO "postgres";


CREATE TYPE "public"."maintenance_status" AS ENUM (
    'PENDING',
    'IN_PROGRESS',
    'RESOLVED',
    'REJECTED'
);


ALTER TYPE "public"."maintenance_status" OWNER TO "postgres";


CREATE TYPE "public"."media_entity_type" AS ENUM (
    'USER',
    'MOTEL',
    'ROOM',
    'CONTRACT',
    'INVOICE',
    'OTHER'
);


ALTER TYPE "public"."media_entity_type" OWNER TO "postgres";


CREATE TYPE "public"."phuong_thuc_thanh_toan" AS ENUM (
    'CASH',
    'BANK_TRANSFER',
    'VIETQR',
    'MOMO',
    'ZALOPAY',
    'OTHER'
);


ALTER TYPE "public"."phuong_thuc_thanh_toan" OWNER TO "postgres";


CREATE TYPE "public"."room_status" AS ENUM (
    'AVAILABLE',
    'RENTED',
    'MAINTENANCE'
);


ALTER TYPE "public"."room_status" OWNER TO "postgres";


CREATE TYPE "public"."trang_thai_chi_so" AS ENUM (
    'DRAFT',
    'CONFIRMED',
    'BILLED',
    'CANCELLED'
);


ALTER TYPE "public"."trang_thai_chi_so" OWNER TO "postgres";


CREATE TYPE "public"."trang_thai_coc_hop_dong" AS ENUM (
    'NOT_PAID',
    'KEPT',
    'REFUNDED',
    'DEDUCTED',
    'FORFEITED'
);


ALTER TYPE "public"."trang_thai_coc_hop_dong" OWNER TO "postgres";


CREATE TYPE "public"."trang_thai_dat_coc" AS ENUM (
    'PENDING',
    'COMPLETED',
    'REFUNDED',
    'FORFEITED',
    'CANCELLED'
);


ALTER TYPE "public"."trang_thai_dat_coc" OWNER TO "postgres";


CREATE TYPE "public"."trang_thai_hoa_don" AS ENUM (
    'DRAFT',
    'UNPAID',
    'PARTIAL',
    'PAID',
    'OVERPAID',
    'OVERDUE',
    'CANCELLED'
);


ALTER TYPE "public"."trang_thai_hoa_don" OWNER TO "postgres";


CREATE TYPE "public"."trang_thai_hop_dong" AS ENUM (
    'DRAFT',
    'PENDING',
    'ACTIVE',
    'EXPIRED',
    'TERMINATED',
    'CANCELLED'
);


ALTER TYPE "public"."trang_thai_hop_dong" OWNER TO "postgres";


CREATE TYPE "public"."trang_thai_lich_hen" AS ENUM (
    'PENDING',
    'CONFIRMED',
    'CANCELLED',
    'COMPLETED',
    'NO_SHOW'
);


ALTER TYPE "public"."trang_thai_lich_hen" OWNER TO "postgres";


CREATE TYPE "public"."trang_thai_nguoi_dung" AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'BANNED'
);


ALTER TYPE "public"."trang_thai_nguoi_dung" OWNER TO "postgres";


CREATE TYPE "public"."trang_thai_phong" AS ENUM (
    'AVAILABLE',
    'RENTED',
    'MAINTENANCE',
    'RESERVED',
    'INACTIVE'
);


ALTER TYPE "public"."trang_thai_phong" OWNER TO "postgres";


CREATE TYPE "public"."trang_thai_su_co" AS ENUM (
    'PENDING',
    'IN_PROGRESS',
    'RESOLVED',
    'CANCELLED'
);


ALTER TYPE "public"."trang_thai_su_co" OWNER TO "postgres";


CREATE TYPE "public"."trang_thai_thanh_toan" AS ENUM (
    'PENDING',
    'SUCCESS',
    'FAILED',
    'CANCELLED',
    'REFUNDED'
);


ALTER TYPE "public"."trang_thai_thanh_toan" OWNER TO "postgres";


CREATE TYPE "public"."user_status" AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'BANNED'
);


ALTER TYPE "public"."user_status" OWNER TO "postgres";


CREATE TYPE "public"."uu_tien_enum" AS ENUM (
    'thap',
    'trung_binh',
    'cao',
    'khan_cap'
);


ALTER TYPE "public"."uu_tien_enum" OWNER TO "postgres";


CREATE TYPE "public"."vai_tro_he_thong" AS ENUM (
    'ADMIN',
    'LANDLORD',
    'STAFF',
    'TENANT'
);


ALTER TYPE "public"."vai_tro_he_thong" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."can_access_nha_tro"("p_nha_tro_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
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


ALTER FUNCTION "public"."can_access_nha_tro"("p_nha_tro_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."cap_nhat_thoi_gian"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    NEW.cap_nhat_luc = now();
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."cap_nhat_thoi_gian"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."cap_nhat_trang_thai_hoa_don"() RETURNS "trigger"
    LANGUAGE "plpgsql"
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


ALTER FUNCTION "public"."cap_nhat_trang_thai_hoa_don"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."clone_cau_truc_toa_nha"("p_nha_tro_nguon_id" "uuid", "p_nha_tro_dich_id" "uuid") RETURNS TABLE("tang_duoc_tao" integer, "phong_duoc_tao" integer)
    LANGUAGE "plpgsql"
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


ALTER FUNCTION "public"."clone_cau_truc_toa_nha"("p_nha_tro_nguon_id" "uuid", "p_nha_tro_dich_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_admin"() RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.nguoi_dung_vai_tro ndvt
        JOIN public.vai_tro vt ON vt.id = ndvt.vai_tro_id
        WHERE ndvt.nguoi_dung_id = auth.uid()
          AND vt.ten = 'ADMIN'
    );
$$;


ALTER FUNCTION "public"."is_admin"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."recalc_hoa_don_from_chi_tiet"() RETURNS "trigger"
    LANGUAGE "plpgsql"
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


ALTER FUNCTION "public"."recalc_hoa_don_from_chi_tiet"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."recalc_hoa_don_from_thanh_toan"() RETURNS "trigger"
    LANGUAGE "plpgsql"
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


ALTER FUNCTION "public"."recalc_hoa_don_from_thanh_toan"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."sinh_phong_toa_nha"("p_nha_tro_id" "uuid", "p_so_tang" integer, "p_so_phong_moi_tang" integer, "p_dien_tich" numeric DEFAULT 20, "p_gia_hien_tai" numeric DEFAULT 0, "p_tien_coc_mac_dinh" numeric DEFAULT 0, "p_so_nguoi_toi_da" integer DEFAULT 2) RETURNS TABLE("tang_duoc_tao" integer, "phong_duoc_tao" integer)
    LANGUAGE "plpgsql"
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
            v_ma_phong := 'Phòng ' || (v_tang * 100 + v_phong)::text;

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


ALTER FUNCTION "public"."sinh_phong_toa_nha"("p_nha_tro_id" "uuid", "p_so_tang" integer, "p_so_phong_moi_tang" integer, "p_dien_tich" numeric, "p_gia_hien_tai" numeric, "p_tien_coc_mac_dinh" numeric, "p_so_nguoi_toi_da" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."tao_lich_thanh_toan_hang_thang"("p_hop_dong_id" "uuid") RETURNS integer
    LANGUAGE "plpgsql"
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


ALTER FUNCTION "public"."tao_lich_thanh_toan_hang_thang"("p_hop_dong_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_invoice_status_on_payment"() RETURNS "trigger"
    LANGUAGE "plpgsql"
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


ALTER FUNCTION "public"."update_invoice_status_on_payment"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_updated_at_column"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."update_updated_at_column"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."audit_log" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nguoi_dung_id" "uuid",
    "hanh_dong" character varying(255) NOT NULL,
    "bang_tac_dong" character varying(255),
    "ban_ghi_id" "uuid",
    "du_lieu_cu" "jsonb",
    "du_lieu_moi" "jsonb",
    "ip_address" "inet",
    "user_agent" character varying(255),
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."audit_log" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."bank_transaction" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nha_tro_id" "uuid",
    "hoa_don_id" "uuid",
    "so_tien" numeric(38,2) NOT NULL,
    "noi_dung_chuyen_khoan" character varying(255),
    "ma_giao_dich" character varying(150),
    "ngan_hang" character varying(100),
    "thoi_gian_giao_dich" timestamp with time zone NOT NULL,
    "payload" "jsonb",
    "da_doi_soat" boolean DEFAULT false NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_bank_transaction_tien" CHECK (("so_tien" > (0)::numeric))
);


ALTER TABLE "public"."bank_transaction" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."cau_hinh_gia" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nha_tro_id" "uuid" NOT NULL,
    "dich_vu_id" "uuid",
    "loai" character varying(255) NOT NULL,
    "ten_hien_thi" character varying(255) NOT NULL,
    "loai_tinh_phi" character varying(255) DEFAULT 'FIXED'::"public"."loai_tinh_phi" NOT NULL,
    "don_gia" numeric(38,2) NOT NULL,
    "hieu_luc_tu" "date" DEFAULT CURRENT_DATE NOT NULL,
    "hieu_luc_den" "date",
    "dang_ap_dung" boolean DEFAULT true NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cap_nhat_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_cau_hinh_gia_ngay" CHECK ((("hieu_luc_den" IS NULL) OR ("hieu_luc_den" >= "hieu_luc_tu"))),
    CONSTRAINT "chk_cau_hinh_gia_tien" CHECK (("don_gia" >= (0)::numeric))
);


ALTER TABLE "public"."cau_hinh_gia" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."chi_so_dien_nuoc" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "phong_id" "uuid" NOT NULL,
    "hop_dong_id" "uuid",
    "loai" character varying(255) NOT NULL,
    "ky_nam" integer NOT NULL,
    "ky_thang" integer NOT NULL,
    "ngay_ghi" "date" DEFAULT CURRENT_DATE NOT NULL,
    "chi_so_cu" integer NOT NULL,
    "chi_so_moi" integer NOT NULL,
    "tieu_thu" integer GENERATED ALWAYS AS (("chi_so_moi" - "chi_so_cu")) STORED,
    "anh_dong_ho" character varying(255),
    "nguoi_ghi_id" "uuid",
    "trang_thai" character varying(255) DEFAULT 'DRAFT'::"public"."trang_thai_chi_so" NOT NULL,
    "ghi_chu" character varying(255),
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cap_nhat_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_chi_so_gia_tri" CHECK ((("chi_so_cu" >= 0) AND ("chi_so_moi" >= "chi_so_cu"))),
    CONSTRAINT "chk_chi_so_ky" CHECK (((("ky_thang" >= 1) AND ("ky_thang" <= 12)) AND (("ky_nam" >= 2000) AND ("ky_nam" <= 2100))))
);


ALTER TABLE "public"."chi_so_dien_nuoc" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."meter_anomaly_alert" (
    "id" "uuid" DEFAULT "gen_random_uuid"() PRIMARY KEY,
    "chi_so_id" "uuid" NOT NULL,
    "phong_id" "uuid" NOT NULL,
    "hop_dong_id" "uuid",
    "loai" character varying(255) NOT NULL,
    "ky_thang" integer NOT NULL,
    "ky_nam" integer NOT NULL,
    "tieu_thu_hien_tai" integer NOT NULL,
    "tieu_thu_trung_binh" numeric(38,2),
    "ty_le_tang" numeric(38,2),
    "muc_do" character varying(255) NOT NULL,
    "ly_do" text NOT NULL,
    "trang_thai" character varying(255) DEFAULT 'OPEN' NOT NULL,
    "resolved_at" timestamp with time zone,
    "resolved_by" "uuid",
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."meter_anomaly_alert" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."debt_reminder_log" (
    "id" "uuid" DEFAULT "gen_random_uuid"() PRIMARY KEY,
    "hoa_don_id" "uuid" NOT NULL,
    "reminder_type" character varying(255) NOT NULL,
    "channel" character varying(255) NOT NULL,
    "recipient_id" "uuid",
    "recipient_contact" character varying(255),
    "status" character varying(255) DEFAULT 'SENT' NOT NULL,
    "error_message" character varying(255),
    "sent_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."debt_reminder_log" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."chi_tiet_hoa_don" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "hoa_don_id" "uuid" NOT NULL,
    "dich_vu_id" "uuid",
    "chi_so_dien_nuoc_id" "uuid",
    "su_co_id" "uuid",
    "loai" "public"."loai_muc_hoa_don" NOT NULL,
    "mo_ta" character varying(255) NOT NULL,
    "so_luong" numeric(38,2) DEFAULT 1 NOT NULL,
    "don_gia" numeric(38,2) DEFAULT 0 NOT NULL,
    "thanh_tien" numeric(38,2) DEFAULT 0 NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_cthd_tien" CHECK ((("so_luong" >= (0)::numeric) AND ("don_gia" >= (0)::numeric) AND ((("loai" = 'DISCOUNT'::"public"."loai_muc_hoa_don") AND ("thanh_tien" <= (0)::numeric)) OR (("loai" <> 'DISCOUNT'::"public"."loai_muc_hoa_don") AND ("thanh_tien" >= (0)::numeric)))))
);


ALTER TABLE "public"."chi_tiet_hoa_don" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."chu_tro" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "nguoi_dung_id" "uuid",
    "ten_cong_ty" character varying(255),
    "so_cccd" character varying(50) NOT NULL,
    "ma_so_thue" character varying(50),
    "so_tai_khoan" character varying(50),
    "da_xac_minh" boolean DEFAULT false,
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "cap_nhat_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "xoa_luc" timestamp with time zone
);


ALTER TABLE "public"."chu_tro" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."dat_coc_phong" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "phong_id" "uuid" NOT NULL,
    "khach_thue_id" "uuid" NOT NULL,
    "hop_dong_id" "uuid",
    "so_tien_coc" numeric(38,2) NOT NULL,
    "ngay_dat_coc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "ngay_du_kien_vao" "date",
    "trang_thai" character varying(255) DEFAULT 'PENDING'::"public"."trang_thai_dat_coc" NOT NULL,
    "ghi_chu" character varying(255),
    "ly_do_huy" character varying(255),
    "confirmed_at" timestamp with time zone,
    "cancelled_at" timestamp with time zone,
    "nguoi_xac_nhan_id" "uuid",
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cap_nhat_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_dat_coc_tien" CHECK (("so_tien_coc" > (0)::numeric))
);


ALTER TABLE "public"."dat_coc_phong" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."dich_vu" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "chu_tro_id" "uuid",
    "ten_dich_vu" character varying(255) NOT NULL,
    "loai_tinh_phi" character varying(255) DEFAULT 'FIXED'::"public"."loai_tinh_phi" NOT NULL,
    "don_vi" character varying(255),
    "don_gia_mac_dinh" numeric(38,2) DEFAULT 0 NOT NULL,
    "bat_buoc" boolean DEFAULT false NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cap_nhat_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_dich_vu_gia" CHECK (("don_gia_mac_dinh" >= (0)::numeric))
);


ALTER TABLE "public"."dich_vu" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."dich_vu_hop_dong" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "hop_dong_id" "uuid" NOT NULL,
    "dich_vu_id" "uuid" NOT NULL,
    "loai_tinh_phi" character varying(255) NOT NULL,
    "don_gia_ap_dung" numeric(38,2) NOT NULL,
    "so_luong" numeric(38,2) DEFAULT 1 NOT NULL,
    "bat_dau_tu" "date" DEFAULT CURRENT_DATE NOT NULL,
    "ket_thuc_luc" "date",
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_dvhd_tien" CHECK ((("don_gia_ap_dung" >= (0)::numeric) AND ("so_luong" >= (0)::numeric)))
);


ALTER TABLE "public"."dich_vu_hop_dong" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."email_verification_token" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nguoi_dung_id" "uuid" NOT NULL,
    "token" character varying(255) NOT NULL,
    "ngay_het_han" timestamp with time zone NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."email_verification_token" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."file_media" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "doi_tuong" character varying(255) NOT NULL,
    "doi_tuong_id" "uuid" NOT NULL,
    "url" "text" NOT NULL,
    "public_id" character varying(255),
    "loai_file" character varying(255),
    "kich_thuoc_bytes" bigint,
    "metadata" "jsonb",
    "nguoi_tai_len_id" "uuid",
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_file_size" CHECK ((("kich_thuoc_bytes" IS NULL) OR ("kich_thuoc_bytes" >= 0)))
);


ALTER TABLE "public"."file_media" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."hoa_don" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "hop_dong_id" "uuid" NOT NULL,
    "phong_id" "uuid" NOT NULL,
    "khach_thue_id" "uuid" NOT NULL,
    "ma_hoa_don" character varying(100) NOT NULL,
    "ky_nam" integer NOT NULL,
    "ky_thang" integer NOT NULL,
    "tu_ngay" "date" NOT NULL,
    "den_ngay" "date" NOT NULL,
    "so_du_dau_ky" numeric(15,2) DEFAULT 0 NOT NULL,
    "tong_tien_phat_sinh" numeric(15,2) DEFAULT 0 NOT NULL,
    "tong_tien" numeric(15,2) DEFAULT 0 NOT NULL,
    "da_tra" numeric(15,2) DEFAULT 0 NOT NULL,
    "so_du_cuoi_ky" numeric(15,2) GENERATED ALWAYS AS (("tong_tien" - "da_tra")) STORED,
    "trang_thai" "public"."trang_thai_hoa_don" DEFAULT 'DRAFT'::"public"."trang_thai_hoa_don" NOT NULL,
    "han_tra" "date" NOT NULL,
    "ngay_lap_hoa_don" timestamp with time zone DEFAULT "now"() NOT NULL,
    "ghi_chu" "text",
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cap_nhat_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "xoa_luc" timestamp with time zone,
    "auto_generated" boolean DEFAULT false NOT NULL,
    "generation_batch_id" "uuid",
    "source_schedule_id" "uuid",
    "version" bigint DEFAULT 0 NOT NULL,
    CONSTRAINT "chk_hoa_don_ky" CHECK (((("ky_thang" >= 1) AND ("ky_thang" <= 12)) AND (("ky_nam" >= 2000) AND ("ky_nam" <= 2100)))),
    CONSTRAINT "chk_hoa_don_ngay" CHECK ((("den_ngay" >= "tu_ngay") AND ("han_tra" >= "tu_ngay"))),
    CONSTRAINT "chk_hoa_don_tien" CHECK ((("tong_tien_phat_sinh" >= (0)::numeric) AND ("tong_tien" >= (0)::numeric) AND ("da_tra" >= (0)::numeric)))
);


ALTER TABLE "public"."hoa_don" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."hop_dong" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "phong_id" "uuid" NOT NULL,
    "khach_thue_id" "uuid" NOT NULL,
    "ma_hop_dong" character varying(100) NOT NULL,
    "ngay_bat_dau" "date" NOT NULL,
    "ngay_ket_thuc" "date" NOT NULL,
    "ngay_ket_thuc_thuc_te" "date",
    "gia_thue_hop_dong" numeric(15,2) NOT NULL,
    "tien_coc" numeric(15,2) DEFAULT 0 NOT NULL,
    "trang_thai_coc" "public"."trang_thai_coc_hop_dong" DEFAULT 'NOT_PAID'::"public"."trang_thai_coc_hop_dong" NOT NULL,
    "trang_thai" "public"."trang_thai_hop_dong" DEFAULT 'DRAFT'::"public"."trang_thai_hop_dong" NOT NULL,
    "chu_ky_thanh_toan" character varying(30) DEFAULT 'MONTHLY'::character varying NOT NULL,
    "ngay_thanh_toan_hang_thang" integer DEFAULT 5 NOT NULL,
    "tu_dong_gia_han" boolean DEFAULT false NOT NULL,
    "chi_so_dien_ban_dau" integer,
    "chi_so_nuoc_ban_dau" integer,
    "noi_dung_hop_dong" "text",
    "file_pdf" "text",
    "ghi_chu" "text",
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cap_nhat_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "xoa_luc" timestamp with time zone,
    "template_version" character varying(100),
    "previewed_at" timestamp with time zone,
    "confirmed_at" timestamp with time zone,
    "locked_at" timestamp with time zone,
    "signed_pdf_url" "text",
    "tenant_signed_at" timestamp with time zone,
    "landlord_signed_at" timestamp with time zone,
    "signature_status" character varying(30) DEFAULT 'UNSIGNED'::character varying,
    CONSTRAINT "chk_hop_dong_chi_so" CHECK (((("chi_so_dien_ban_dau" IS NULL) OR ("chi_so_dien_ban_dau" >= 0)) AND (("chi_so_nuoc_ban_dau" IS NULL) OR ("chi_so_nuoc_ban_dau" >= 0)))),
    CONSTRAINT "chk_hop_dong_ngay" CHECK (("ngay_ket_thuc" > "ngay_bat_dau")),
    CONSTRAINT "chk_hop_dong_ngay_thanh_toan" CHECK ((("ngay_thanh_toan_hang_thang" >= 1) AND ("ngay_thanh_toan_hang_thang" <= 31))),
    CONSTRAINT "chk_hop_dong_tien" CHECK ((("gia_thue_hop_dong" >= (0)::numeric) AND ("tien_coc" >= (0)::numeric)))
);


ALTER TABLE "public"."hop_dong" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."khach_thue" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nguoi_dung_id" "uuid",
    "chu_tro_id" "uuid" NOT NULL,
    "ho_ten" character varying(255) NOT NULL,
    "so_dien_thoai" character varying(20),
    "email" character varying(255),
    "so_cccd" character varying(50),
    "ngay_sinh" "date",
    "gioi_tinh" character varying(20),
    "dia_chi" "text",
    "que_quan" character varying(255),
    "nghe_nghiep" character varying(255),
    "ghi_chu" "text",
    "dang_hoat_dong" boolean DEFAULT true NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cap_nhat_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "xoa_luc" timestamp with time zone
);


ALTER TABLE "public"."khach_thue" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."lich_hen" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "phong_id" "uuid" NOT NULL,
    "nguoi_dung_id" "uuid",
    "ho_ten" character varying(255),
    "so_dien_thoai" character varying(20),
    "email" character varying(255),
    "ngay_hen" timestamp with time zone NOT NULL,
    "trang_thai" "public"."trang_thai_lich_hen" DEFAULT 'PENDING'::"public"."trang_thai_lich_hen" NOT NULL,
    "google_calendar_event_id" "text",
    "da_gui_nhac_nho" boolean DEFAULT false NOT NULL,
    "ghi_chu" "text",
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cap_nhat_luc" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."lich_hen" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."lich_su_hoa_don" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "hoa_don_id" "uuid" NOT NULL,
    "trang_thai_truoc" "public"."trang_thai_hoa_don",
    "trang_thai_moi" "public"."trang_thai_hoa_don" NOT NULL,
    "nguoi_thay_doi_id" "uuid",
    "ghi_chu" "text",
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."lich_su_hoa_don" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."lich_thanh_toan" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "hop_dong_id" "uuid" NOT NULL,
    "ky_nam" integer NOT NULL,
    "ky_thang" integer NOT NULL,
    "tu_ngay" "date" NOT NULL,
    "den_ngay" "date" NOT NULL,
    "han_thanh_toan" "date" NOT NULL,
    "so_tien_du_kien" numeric(15,2) NOT NULL,
    "hoa_don_id" "uuid",
    "trang_thai" character varying(30) DEFAULT 'PENDING'::character varying NOT NULL,
    "ghi_chu" "text",
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cap_nhat_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "xoa_luc" timestamp with time zone,
    CONSTRAINT "chk_lich_thanh_toan_ky" CHECK ((("ky_thang" >= 1) AND ("ky_thang" <= 12) AND (("ky_nam" >= 2000) AND ("ky_nam" <= 2100)))),
    CONSTRAINT "chk_lich_thanh_toan_ngay" CHECK ((("den_ngay" >= "tu_ngay") AND ("han_thanh_toan" >= "tu_ngay"))),
    CONSTRAINT "chk_lich_thanh_toan_tien" CHECK (("so_tien_du_kien" >= (0)::numeric))
);


ALTER TABLE "public"."lich_thanh_toan" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."login_history" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nguoi_dung_id" "uuid",
    "email" character varying(255),
    "thanh_cong" boolean NOT NULL,
    "ip_address" "inet",
    "user_agent" "text",
    "ly_do_that_bai" "text",
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."login_history" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."nguoi_dung" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "email" character varying(255) NOT NULL,
    "ho_ten" character varying(255) NOT NULL,
    "so_dien_thoai" character varying(20),
    "anh_dai_dien" "text",
    "ngay_sinh" "date",
    "gioi_tinh" character varying(20),
    "dia_chi" "text",
    "que_quan" character varying(255),
    "so_cccd" character varying(50),
    "trang_thai" "public"."trang_thai_nguoi_dung" DEFAULT 'ACTIVE'::"public"."trang_thai_nguoi_dung" NOT NULL,
    "so_lan_dang_nhap_sai" integer DEFAULT 0 NOT NULL,
    "khoa_den_luc" timestamp with time zone,
    "lan_dang_nhap_cuoi" timestamp with time zone,
    "cau_hinh_2fa" "jsonb",
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cap_nhat_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "xoa_luc" timestamp with time zone,
    "mat_khau" character varying(255),
    "trang_thai_kyc" character varying(50) DEFAULT 'NONE'::character varying,
    "anh_cccd_truoc" character varying(500),
    "anh_cccd_sau" character varying(500),
    "anh_gpkd" character varying(500),
    CONSTRAINT "chk_nguoi_dung_email_lower" CHECK ((("email")::"text" = "lower"(("email")::"text"))),
    CONSTRAINT "chk_nguoi_dung_login_fail" CHECK (("so_lan_dang_nhap_sai" >= 0))
);


ALTER TABLE "public"."nguoi_dung" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."nguoi_dung_nha_tro" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nguoi_dung_id" "uuid" NOT NULL,
    "nha_tro_id" "uuid" NOT NULL,
    "vai_tro" "public"."vai_tro_he_thong" NOT NULL,
    "co_quyen_xem" boolean DEFAULT true NOT NULL,
    "co_quyen_sua" boolean DEFAULT false NOT NULL,
    "co_quyen_thu_tien" boolean DEFAULT false NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_ndnt_role" CHECK (("vai_tro" = ANY (ARRAY['LANDLORD'::"public"."vai_tro_he_thong", 'STAFF'::"public"."vai_tro_he_thong"])))
);


ALTER TABLE "public"."nguoi_dung_nha_tro" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."nguoi_dung_vai_tro" (
    "nguoi_dung_id" "uuid" NOT NULL,
    "vai_tro_id" "uuid" NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."nguoi_dung_vai_tro" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."nha_tro" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "chu_tro_id" "uuid" NOT NULL,
    "ten" character varying(255) NOT NULL,
    "dia_chi" "text" NOT NULL,
    "so_nha" character varying(100),
    "duong" character varying(255),
    "phuong" character varying(100),
    "quan" character varying(100),
    "thanh_pho" character varying(100),
    "mo_ta" "text",
    "tien_nghi_chung" "text",
    "noi_quy" "text",
    "trang_thai" character varying(30) DEFAULT 'ACTIVE'::character varying NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cap_nhat_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "xoa_luc" timestamp with time zone
);


ALTER TABLE "public"."nha_tro" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."phong" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nha_tro_id" "uuid" NOT NULL,
    "ten" character varying(100) NOT NULL,
    "khu_vuc" character varying(50),
    "tang" integer,
    "dien_tich" numeric(10,2) NOT NULL,
    "so_nguoi_toi_da" integer DEFAULT 2 NOT NULL,
    "trang_thai" "public"."trang_thai_phong" DEFAULT 'AVAILABLE'::"public"."trang_thai_phong" NOT NULL,
    "gia_hien_tai" numeric(15,2) NOT NULL,
    "tien_coc_mac_dinh" numeric(15,2) DEFAULT 0 NOT NULL,
    "mo_ta" "text",
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cap_nhat_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "xoa_luc" timestamp with time zone,
    "tang_id" "uuid",
    "version" bigint DEFAULT 0 NOT NULL,
    CONSTRAINT "chk_phong_dien_tich" CHECK (("dien_tich" > (0)::numeric)),
    CONSTRAINT "chk_phong_gia" CHECK ((("gia_hien_tai" >= (0)::numeric) AND ("tien_coc_mac_dinh" >= (0)::numeric))),
    CONSTRAINT "chk_phong_so_nguoi" CHECK (("so_nguoi_toi_da" > 0)),
    CONSTRAINT "chk_phong_tang_hop_le" CHECK ((("tang" IS NOT NULL) OR ("tang_id" IS NOT NULL)))
);


ALTER TABLE "public"."phong" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."phong_tien_ich" (
    "phong_id" "uuid" NOT NULL,
    "tien_ich_id" "uuid" NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."phong_tien_ich" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."phu_luc_hop_dong" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "hop_dong_id" "uuid" NOT NULL,
    "loai" character varying(50) NOT NULL,
    "noi_dung" "text" NOT NULL,
    "ngay_hieu_luc" "date" NOT NULL,
    "gia_thue_moi" numeric(15,2),
    "ngay_ket_thuc_moi" "date",
    "file_pdf" "text",
    "nguoi_tao_id" "uuid",
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."phu_luc_hop_dong" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."refresh_token" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nguoi_dung_id" "uuid" NOT NULL,
    "token" character varying(255) NOT NULL,
    "ngay_het_han" timestamp with time zone NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."refresh_token" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."su_co" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "phong_id" "uuid" NOT NULL,
    "khach_thue_id" "uuid",
    "nguoi_bao_id" "uuid",
    "tieu_de" character varying(255) NOT NULL,
    "mo_ta" "text" NOT NULL,
    "loai_su_co" "public"."loai_su_co_enum" DEFAULT 'khac'::"public"."loai_su_co_enum" NOT NULL,
    "uu_tien" "public"."uu_tien_enum" DEFAULT 'trung_binh'::"public"."uu_tien_enum" NOT NULL,
    "trang_thai" "public"."trang_thai_su_co" DEFAULT 'PENDING'::"public"."trang_thai_su_co" NOT NULL,
    "nguoi_phu_trach_id" "uuid",
    "chi_phi_sua_chua" numeric(15,2) DEFAULT 0 NOT NULL,
    "tinh_vao_hoa_don" boolean DEFAULT false NOT NULL,
    "ghi_chu_chu_nha" "text",
    "giai_quyet_luc" timestamp with time zone,
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cap_nhat_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_su_co_chi_phi" CHECK (("chi_phi_sua_chua" >= (0)::numeric))
);


ALTER TABLE "public"."su_co" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tang" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nha_tro_id" "uuid" NOT NULL,
    "so_tang" integer NOT NULL,
    "ten_tang" character varying(100),
    "thu_tu_hien_thi" integer,
    "so_phong_du_kien" integer,
    "trang_thai" character varying(30) DEFAULT 'ACTIVE'::character varying NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cap_nhat_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "xoa_luc" timestamp with time zone,
    CONSTRAINT "chk_tang_so_phong_du_kien" CHECK ((("so_phong_du_kien" IS NULL) OR ("so_phong_du_kien" >= 0))),
    CONSTRAINT "chk_tang_so_tang" CHECK (("so_tang" >= 0))
);


ALTER TABLE "public"."tang" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."thanh_toan" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "hoa_don_id" "uuid" NOT NULL,
    "khach_thue_id" "uuid",
    "so_tien" numeric(15,2) NOT NULL,
    "ngay_thanh_toan" timestamp with time zone DEFAULT "now"() NOT NULL,
    "phuong_thuc_thanh_toan" "public"."phuong_thuc_thanh_toan" DEFAULT 'CASH'::"public"."phuong_thuc_thanh_toan" NOT NULL,
    "ma_tham_chieu" character varying(150),
    "external_transaction_id" character varying(150),
    "trang_thai" "public"."trang_thai_thanh_toan" DEFAULT 'SUCCESS'::"public"."trang_thai_thanh_toan" NOT NULL,
    "nguoi_thanh_toan_id" "uuid",
    "nguoi_ghi_nhan_id" "uuid",
    "ghi_chu" "text",
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_thanh_toan_tien" CHECK (("so_tien" > (0)::numeric))
);


ALTER TABLE "public"."thanh_toan" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."thanh_vien_hop_dong" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "hop_dong_id" "uuid" NOT NULL,
    "khach_thue_id" "uuid",
    "ho_ten" character varying(255) NOT NULL,
    "so_cccd" character varying(50),
    "so_dien_thoai" character varying(20),
    "ngay_vao" "date" DEFAULT CURRENT_DATE NOT NULL,
    "ngay_roi" "date",
    "dang_o" boolean DEFAULT true NOT NULL,
    "la_nguoi_dai_dien" boolean DEFAULT false NOT NULL,
    "ghi_chu" "text",
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cap_nhat_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "chk_tvhd_ngay" CHECK ((("ngay_roi" IS NULL) OR ("ngay_roi" >= "ngay_vao")))
);


ALTER TABLE "public"."thanh_vien_hop_dong" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."thong_bao" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nguoi_gui_id" "uuid",
    "loai" "public"."loai_thong_bao" DEFAULT 'SYSTEM'::"public"."loai_thong_bao" NOT NULL,
    "tieu_de" character varying(255) NOT NULL,
    "noi_dung" "text" NOT NULL,
    "doi_tuong" "public"."loai_doi_tuong_media",
    "doi_tuong_id" "uuid",
    "kenh" "public"."kenh_thong_bao" DEFAULT 'IN_APP'::"public"."kenh_thong_bao" NOT NULL,
    "gui_tat_ca" boolean DEFAULT false NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "cap_nhat_luc" timestamp with time zone DEFAULT "now"() NOT NULL,
    "xoa_luc" timestamp with time zone
);


ALTER TABLE "public"."thong_bao" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."thong_bao_nguoi_nhan" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "thong_bao_id" "uuid" NOT NULL,
    "nguoi_dung_id" "uuid" NOT NULL,
    "da_doc" boolean DEFAULT false NOT NULL,
    "doc_luc" timestamp with time zone,
    "gui_luc" timestamp with time zone,
    "loi_gui" "text"
);


ALTER TABLE "public"."thong_bao_nguoi_nhan" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tien_ich" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "ten" character varying(100) NOT NULL,
    "bieu_tuong" character varying(100),
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."tien_ich" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_so_do_toa_nha" AS
 SELECT "nt"."id" AS "nha_tro_id",
    "nt"."ten" AS "ten_toa_nha",
    COALESCE("t"."so_tang", "p"."tang") AS "so_tang",
    COALESCE("t"."ten_tang", (('Tang '::"text" || (COALESCE("t"."so_tang", "p"."tang"))::"text"))::character varying) AS "ten_tang",
    "p"."id" AS "phong_id",
    "p"."ten" AS "ma_phong",
    "p"."dien_tich",
    "p"."gia_hien_tai",
    "p"."trang_thai" AS "trang_thai_vat_ly",
    "hd"."id" AS "hop_dong_id",
    "hd"."ma_hop_dong",
    "hd"."ngay_bat_dau",
    "hd"."ngay_ket_thuc",
    "kt"."id" AS "khach_thue_id",
    "kt"."ho_ten" AS "khach_thue_hien_tai",
        CASE
            WHEN ("p"."trang_thai" = 'MAINTENANCE'::"public"."trang_thai_phong") THEN 'MAINTENANCE'::"text"
            WHEN ("hd"."id" IS NULL) THEN 'VACANT'::"text"
            WHEN ("hd"."ngay_ket_thuc" <= (CURRENT_DATE + '30 days'::interval)) THEN 'CONTRACT_EXPIRING'::"text"
            ELSE 'RENTED'::"text"
        END AS "trang_thai_hien_thi"
   FROM (((("public"."nha_tro" "nt"
     LEFT JOIN "public"."tang" "t" ON ((("t"."nha_tro_id" = "nt"."id") AND ("t"."xoa_luc" IS NULL))))
     LEFT JOIN "public"."phong" "p" ON ((("p"."nha_tro_id" = "nt"."id") AND ("p"."xoa_luc" IS NULL) AND (("p"."tang_id" = "t"."id") OR (("p"."tang_id" IS NULL) AND ("p"."tang" = "t"."so_tang"))))))
     LEFT JOIN LATERAL ( SELECT "h"."id",
            "h"."phong_id",
            "h"."khach_thue_id",
            "h"."ma_hop_dong",
            "h"."ngay_bat_dau",
            "h"."ngay_ket_thuc",
            "h"."ngay_ket_thuc_thuc_te",
            "h"."gia_thue_hop_dong",
            "h"."tien_coc",
            "h"."trang_thai_coc",
            "h"."trang_thai",
            "h"."chu_ky_thanh_toan",
            "h"."ngay_thanh_toan_hang_thang",
            "h"."tu_dong_gia_han",
            "h"."chi_so_dien_ban_dau",
            "h"."chi_so_nuoc_ban_dau",
            "h"."noi_dung_hop_dong",
            "h"."file_pdf",
            "h"."ghi_chu",
            "h"."tao_luc",
            "h"."cap_nhat_luc",
            "h"."xoa_luc",
            "h"."template_version",
            "h"."previewed_at",
            "h"."confirmed_at",
            "h"."locked_at"
           FROM "public"."hop_dong" "h"
          WHERE (("h"."phong_id" = "p"."id") AND ("h"."xoa_luc" IS NULL) AND ("h"."trang_thai" = ANY (ARRAY['PENDING'::"public"."trang_thai_hop_dong", 'ACTIVE'::"public"."trang_thai_hop_dong"])) AND ((CURRENT_DATE >= "h"."ngay_bat_dau") AND (CURRENT_DATE <= "h"."ngay_ket_thuc")))
          ORDER BY "h"."ngay_bat_dau" DESC
         LIMIT 1) "hd" ON (true))
     LEFT JOIN "public"."khach_thue" "kt" ON (("kt"."id" = "hd"."khach_thue_id")))
  WHERE ("nt"."xoa_luc" IS NULL);


ALTER VIEW "public"."v_so_do_toa_nha" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_thong_ke_toa_nha" AS
 SELECT "nt"."id" AS "nha_tro_id",
    "nt"."ten" AS "ten_toa_nha",
    "count"(DISTINCT "t"."id") AS "tong_so_tang",
    "count"(DISTINCT "p"."id") AS "tong_so_phong",
    "count"(DISTINCT "p"."id") FILTER (WHERE (("p"."trang_thai" = 'AVAILABLE'::"public"."trang_thai_phong") AND ("hd"."id" IS NULL))) AS "phong_trong",
    "count"(DISTINCT "p"."id") FILTER (WHERE ("hd"."id" IS NOT NULL)) AS "phong_dang_thue",
    "count"(DISTINCT "p"."id") FILTER (WHERE ("p"."trang_thai" = 'MAINTENANCE'::"public"."trang_thai_phong")) AS "phong_bao_tri",
    "count"(DISTINCT "p"."id") FILTER (WHERE (("hd"."id" IS NOT NULL) AND ("hd"."ngay_ket_thuc" <= (CURRENT_DATE + '30 days'::interval)))) AS "hop_dong_sap_het_han",
    COALESCE("sum"("hd"."gia_thue_hop_dong"), (0)::numeric) AS "doanh_thu_du_kien_thang"
   FROM ((("public"."nha_tro" "nt"
     LEFT JOIN "public"."tang" "t" ON ((("t"."nha_tro_id" = "nt"."id") AND ("t"."xoa_luc" IS NULL))))
     LEFT JOIN "public"."phong" "p" ON ((("p"."nha_tro_id" = "nt"."id") AND ("p"."xoa_luc" IS NULL))))
     LEFT JOIN LATERAL ( SELECT "h"."id",
            "h"."phong_id",
            "h"."khach_thue_id",
            "h"."ma_hop_dong",
            "h"."ngay_bat_dau",
            "h"."ngay_ket_thuc",
            "h"."ngay_ket_thuc_thuc_te",
            "h"."gia_thue_hop_dong",
            "h"."tien_coc",
            "h"."trang_thai_coc",
            "h"."trang_thai",
            "h"."chu_ky_thanh_toan",
            "h"."ngay_thanh_toan_hang_thang",
            "h"."tu_dong_gia_han",
            "h"."chi_so_dien_ban_dau",
            "h"."chi_so_nuoc_ban_dau",
            "h"."noi_dung_hop_dong",
            "h"."file_pdf",
            "h"."ghi_chu",
            "h"."tao_luc",
            "h"."cap_nhat_luc",
            "h"."xoa_luc",
            "h"."template_version",
            "h"."previewed_at",
            "h"."confirmed_at",
            "h"."locked_at"
           FROM "public"."hop_dong" "h"
          WHERE (("h"."phong_id" = "p"."id") AND ("h"."xoa_luc" IS NULL) AND ("h"."trang_thai" = ANY (ARRAY['PENDING'::"public"."trang_thai_hop_dong", 'ACTIVE'::"public"."trang_thai_hop_dong"])) AND ((CURRENT_DATE >= "h"."ngay_bat_dau") AND (CURRENT_DATE <= "h"."ngay_ket_thuc")))
          ORDER BY "h"."ngay_bat_dau" DESC
         LIMIT 1) "hd" ON (true))
  WHERE ("nt"."xoa_luc" IS NULL)
  GROUP BY "nt"."id", "nt"."ten";


ALTER VIEW "public"."v_thong_ke_toa_nha" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."vai_tro" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "ten" "public"."vai_tro_he_thong" NOT NULL,
    "mo_ta" "text",
    "tao_luc" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."vai_tro" OWNER TO "postgres";


ALTER TABLE ONLY "public"."audit_log"
    ADD CONSTRAINT "audit_log_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."bank_transaction"
    ADD CONSTRAINT "bank_transaction_ma_giao_dich_key" UNIQUE ("ma_giao_dich");



ALTER TABLE ONLY "public"."bank_transaction"
    ADD CONSTRAINT "bank_transaction_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."cau_hinh_gia"
    ADD CONSTRAINT "cau_hinh_gia_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."chi_so_dien_nuoc"
    ADD CONSTRAINT "chi_so_dien_nuoc_phong_id_loai_ky_nam_ky_thang_key" UNIQUE ("phong_id", "loai", "ky_nam", "ky_thang");



ALTER TABLE ONLY "public"."chi_so_dien_nuoc"
    ADD CONSTRAINT "chi_so_dien_nuoc_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."chi_tiet_hoa_don"
    ADD CONSTRAINT "chi_tiet_hoa_don_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."chu_tro"
    ADD CONSTRAINT "chu_tro_nguoi_dung_id_key" UNIQUE ("nguoi_dung_id");



ALTER TABLE ONLY "public"."chu_tro"
    ADD CONSTRAINT "chu_tro_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."chu_tro"
    ADD CONSTRAINT "chu_tro_so_cccd_key" UNIQUE ("so_cccd");



ALTER TABLE ONLY "public"."dat_coc_phong"
    ADD CONSTRAINT "dat_coc_phong_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."dich_vu"
    ADD CONSTRAINT "dich_vu_chu_tro_id_ten_dich_vu_key" UNIQUE ("chu_tro_id", "ten_dich_vu");



ALTER TABLE ONLY "public"."dich_vu_hop_dong"
    ADD CONSTRAINT "dich_vu_hop_dong_hop_dong_id_dich_vu_id_bat_dau_tu_key" UNIQUE ("hop_dong_id", "dich_vu_id", "bat_dau_tu");



ALTER TABLE ONLY "public"."dich_vu_hop_dong"
    ADD CONSTRAINT "dich_vu_hop_dong_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."dich_vu"
    ADD CONSTRAINT "dich_vu_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."email_verification_token"
    ADD CONSTRAINT "email_verification_token_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."email_verification_token"
    ADD CONSTRAINT "email_verification_token_token_key" UNIQUE ("token");



ALTER TABLE ONLY "public"."hop_dong"
    ADD CONSTRAINT "excl_hop_dong_phong_active_overlap" EXCLUDE USING "gist" ("phong_id" WITH =, "daterange"("ngay_bat_dau", "ngay_ket_thuc", '[]'::"text") WITH &&) WHERE (("trang_thai" = ANY (ARRAY['PENDING'::"public"."trang_thai_hop_dong", 'ACTIVE'::"public"."trang_thai_hop_dong"])));



ALTER TABLE ONLY "public"."file_media"
    ADD CONSTRAINT "file_media_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."hoa_don"
    ADD CONSTRAINT "hoa_don_hop_dong_id_ky_nam_ky_thang_key" UNIQUE ("hop_dong_id", "ky_nam", "ky_thang");



ALTER TABLE ONLY "public"."hoa_don"
    ADD CONSTRAINT "hoa_don_ma_hoa_don_key" UNIQUE ("ma_hoa_don");



ALTER TABLE ONLY "public"."hoa_don"
    ADD CONSTRAINT "hoa_don_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."hop_dong"
    ADD CONSTRAINT "hop_dong_ma_hop_dong_key" UNIQUE ("ma_hop_dong");



ALTER TABLE ONLY "public"."hop_dong"
    ADD CONSTRAINT "hop_dong_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."khach_thue"
    ADD CONSTRAINT "khach_thue_chu_tro_id_so_cccd_key" UNIQUE ("chu_tro_id", "so_cccd");



ALTER TABLE ONLY "public"."khach_thue"
    ADD CONSTRAINT "khach_thue_nguoi_dung_id_key" UNIQUE ("nguoi_dung_id");



ALTER TABLE ONLY "public"."khach_thue"
    ADD CONSTRAINT "khach_thue_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."lich_hen"
    ADD CONSTRAINT "lich_hen_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."lich_su_hoa_don"
    ADD CONSTRAINT "lich_su_hoa_don_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."lich_thanh_toan"
    ADD CONSTRAINT "lich_thanh_toan_hop_dong_id_ky_nam_ky_thang_key" UNIQUE ("hop_dong_id", "ky_nam", "ky_thang");



ALTER TABLE ONLY "public"."lich_thanh_toan"
    ADD CONSTRAINT "lich_thanh_toan_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."login_history"
    ADD CONSTRAINT "login_history_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."nguoi_dung"
    ADD CONSTRAINT "nguoi_dung_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."nguoi_dung_nha_tro"
    ADD CONSTRAINT "nguoi_dung_nha_tro_nguoi_dung_id_nha_tro_id_vai_tro_key" UNIQUE ("nguoi_dung_id", "nha_tro_id", "vai_tro");



ALTER TABLE ONLY "public"."nguoi_dung_nha_tro"
    ADD CONSTRAINT "nguoi_dung_nha_tro_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."nguoi_dung"
    ADD CONSTRAINT "nguoi_dung_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."nguoi_dung"
    ADD CONSTRAINT "nguoi_dung_so_cccd_key" UNIQUE ("so_cccd");



ALTER TABLE ONLY "public"."nguoi_dung"
    ADD CONSTRAINT "nguoi_dung_so_dien_thoai_key" UNIQUE ("so_dien_thoai");



ALTER TABLE ONLY "public"."nguoi_dung_vai_tro"
    ADD CONSTRAINT "nguoi_dung_vai_tro_pkey" PRIMARY KEY ("nguoi_dung_id", "vai_tro_id");



ALTER TABLE ONLY "public"."nha_tro"
    ADD CONSTRAINT "nha_tro_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."phong"
    ADD CONSTRAINT "phong_nha_tro_id_ten_key" UNIQUE ("nha_tro_id", "ten");



ALTER TABLE ONLY "public"."phong"
    ADD CONSTRAINT "phong_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."phong_tien_ich"
    ADD CONSTRAINT "phong_tien_ich_pkey" PRIMARY KEY ("phong_id", "tien_ich_id");



ALTER TABLE ONLY "public"."phu_luc_hop_dong"
    ADD CONSTRAINT "phu_luc_hop_dong_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."refresh_token"
    ADD CONSTRAINT "refresh_token_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."refresh_token"
    ADD CONSTRAINT "refresh_token_token_key" UNIQUE ("token");



ALTER TABLE ONLY "public"."su_co"
    ADD CONSTRAINT "su_co_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tang"
    ADD CONSTRAINT "tang_nha_tro_id_id_key" UNIQUE ("nha_tro_id", "id");



ALTER TABLE ONLY "public"."tang"
    ADD CONSTRAINT "tang_nha_tro_id_so_tang_key" UNIQUE ("nha_tro_id", "so_tang");



ALTER TABLE ONLY "public"."tang"
    ADD CONSTRAINT "tang_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."thanh_toan"
    ADD CONSTRAINT "thanh_toan_external_transaction_id_key" UNIQUE ("external_transaction_id");



ALTER TABLE ONLY "public"."thanh_toan"
    ADD CONSTRAINT "thanh_toan_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."thanh_vien_hop_dong"
    ADD CONSTRAINT "thanh_vien_hop_dong_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."thong_bao_nguoi_nhan"
    ADD CONSTRAINT "thong_bao_nguoi_nhan_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."thong_bao_nguoi_nhan"
    ADD CONSTRAINT "thong_bao_nguoi_nhan_thong_bao_id_nguoi_dung_id_key" UNIQUE ("thong_bao_id", "nguoi_dung_id");



ALTER TABLE ONLY "public"."thong_bao"
    ADD CONSTRAINT "thong_bao_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tien_ich"
    ADD CONSTRAINT "tien_ich_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tien_ich"
    ADD CONSTRAINT "tien_ich_ten_key" UNIQUE ("ten");



ALTER TABLE ONLY "public"."vai_tro"
    ADD CONSTRAINT "vai_tro_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."vai_tro"
    ADD CONSTRAINT "vai_tro_ten_key" UNIQUE ("ten");



CREATE INDEX "idx_audit_log_target" ON "public"."audit_log" USING "btree" ("bang_tac_dong", "ban_ghi_id");



CREATE INDEX "idx_cau_hinh_gia_nha_tro" ON "public"."cau_hinh_gia" USING "btree" ("nha_tro_id", "loai", "dang_ap_dung");



CREATE INDEX "idx_chi_so_phong_ky" ON "public"."chi_so_dien_nuoc" USING "btree" ("phong_id", "loai", "ky_nam", "ky_thang");



CREATE INDEX "idx_cthd_hoa_don" ON "public"."chi_tiet_hoa_don" USING "btree" ("hoa_don_id");



CREATE INDEX "idx_dat_coc_phong" ON "public"."dat_coc_phong" USING "btree" ("phong_id", "trang_thai");



CREATE INDEX "idx_dvhd_hop_dong" ON "public"."dich_vu_hop_dong" USING "btree" ("hop_dong_id");



CREATE INDEX "idx_file_media_target" ON "public"."file_media" USING "btree" ("doi_tuong", "doi_tuong_id");



CREATE INDEX "idx_hoa_don_hop_dong_ky" ON "public"."hoa_don" USING "btree" ("hop_dong_id", "ky_nam", "ky_thang");



CREATE INDEX "idx_hoa_don_khach_thue" ON "public"."hoa_don" USING "btree" ("khach_thue_id");



CREATE INDEX "idx_hoa_don_phong" ON "public"."hoa_don" USING "btree" ("phong_id");



CREATE INDEX "idx_hoa_don_status_due" ON "public"."hoa_don" USING "btree" ("trang_thai", "han_tra");



CREATE INDEX "idx_hop_dong_khach_thue" ON "public"."hop_dong" USING "btree" ("khach_thue_id");



CREATE INDEX "idx_hop_dong_phong_status_dates" ON "public"."hop_dong" USING "btree" ("phong_id", "trang_thai", "ngay_bat_dau", "ngay_ket_thuc");



CREATE INDEX "idx_khach_thue_chu_tro" ON "public"."khach_thue" USING "btree" ("chu_tro_id");



CREATE INDEX "idx_khach_thue_sdt" ON "public"."khach_thue" USING "btree" ("so_dien_thoai");



CREATE INDEX "idx_lich_hen_phong_time" ON "public"."lich_hen" USING "btree" ("phong_id", "ngay_hen");



CREATE INDEX "idx_lich_thanh_toan_han" ON "public"."lich_thanh_toan" USING "btree" ("han_thanh_toan", "trang_thai") WHERE ("xoa_luc" IS NULL);



CREATE INDEX "idx_lich_thanh_toan_hop_dong" ON "public"."lich_thanh_toan" USING "btree" ("hop_dong_id", "ky_nam", "ky_thang") WHERE ("xoa_luc" IS NULL);



CREATE INDEX "idx_login_history_user_time" ON "public"."login_history" USING "btree" ("nguoi_dung_id", "tao_luc" DESC);



CREATE INDEX "idx_ndnt_nha_tro_user" ON "public"."nguoi_dung_nha_tro" USING "btree" ("nha_tro_id", "nguoi_dung_id");



CREATE INDEX "idx_nguoi_dung_email" ON "public"."nguoi_dung" USING "btree" ("email");



CREATE INDEX "idx_nguoi_dung_trang_thai" ON "public"."nguoi_dung" USING "btree" ("trang_thai");



CREATE INDEX "idx_nha_tro_chu_tro" ON "public"."nha_tro" USING "btree" ("chu_tro_id");



CREATE INDEX "idx_phong_nha_tro" ON "public"."phong" USING "btree" ("nha_tro_id");



CREATE INDEX "idx_phong_nha_tro_tang" ON "public"."phong" USING "btree" ("nha_tro_id", "tang", "ten") WHERE ("xoa_luc" IS NULL);



CREATE INDEX "idx_phong_tang_id" ON "public"."phong" USING "btree" ("tang_id") WHERE ("xoa_luc" IS NULL);



CREATE INDEX "idx_phong_trang_thai" ON "public"."phong" USING "btree" ("trang_thai");



CREATE INDEX "idx_su_co_phong_status" ON "public"."su_co" USING "btree" ("phong_id", "trang_thai");



CREATE INDEX "idx_tang_nha_tro_so_tang" ON "public"."tang" USING "btree" ("nha_tro_id", "so_tang") WHERE ("xoa_luc" IS NULL);



CREATE INDEX "idx_thanh_toan_hoa_don" ON "public"."thanh_toan" USING "btree" ("hoa_don_id");



CREATE INDEX "idx_thanh_toan_ref" ON "public"."thanh_toan" USING "btree" ("ma_tham_chieu");



CREATE INDEX "idx_thong_bao_recipient" ON "public"."thong_bao_nguoi_nhan" USING "btree" ("nguoi_dung_id", "da_doc");



CREATE INDEX "idx_tvhd_hop_dong" ON "public"."thanh_vien_hop_dong" USING "btree" ("hop_dong_id");



CREATE OR REPLACE TRIGGER "trg_cau_hinh_gia_cap_nhat" BEFORE UPDATE ON "public"."cau_hinh_gia" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_chi_so_cap_nhat" BEFORE UPDATE ON "public"."chi_so_dien_nuoc" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_chu_tro_cap_nhat" BEFORE UPDATE ON "public"."chu_tro" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_cthd_recalc" AFTER INSERT OR DELETE OR UPDATE ON "public"."chi_tiet_hoa_don" FOR EACH ROW EXECUTE FUNCTION "public"."recalc_hoa_don_from_chi_tiet"();



CREATE OR REPLACE TRIGGER "trg_dich_vu_cap_nhat" BEFORE UPDATE ON "public"."dich_vu" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_hoa_don_cap_nhat" BEFORE UPDATE ON "public"."hoa_don" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_hoa_don_status" BEFORE INSERT OR UPDATE OF "tong_tien", "da_tra", "han_tra", "trang_thai" ON "public"."hoa_don" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_trang_thai_hoa_don"();



CREATE OR REPLACE TRIGGER "trg_hop_dong_cap_nhat" BEFORE UPDATE ON "public"."hop_dong" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_khach_thue_cap_nhat" BEFORE UPDATE ON "public"."khach_thue" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_lich_hen_cap_nhat" BEFORE UPDATE ON "public"."lich_hen" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_nguoi_dung_cap_nhat" BEFORE UPDATE ON "public"."nguoi_dung" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_nha_tro_cap_nhat" BEFORE UPDATE ON "public"."nha_tro" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_phong_cap_nhat" BEFORE UPDATE ON "public"."phong" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_su_co_cap_nhat" BEFORE UPDATE ON "public"."su_co" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_thanh_toan_recalc" AFTER INSERT OR DELETE OR UPDATE ON "public"."thanh_toan" FOR EACH ROW EXECUTE FUNCTION "public"."recalc_hoa_don_from_thanh_toan"();



CREATE OR REPLACE TRIGGER "trg_thanh_vien_cap_nhat" BEFORE UPDATE ON "public"."thanh_vien_hop_dong" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_thong_bao_cap_nhat" BEFORE UPDATE ON "public"."thong_bao" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



ALTER TABLE ONLY "public"."audit_log"
    ADD CONSTRAINT "audit_log_nguoi_dung_id_fkey" FOREIGN KEY ("nguoi_dung_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."bank_transaction"
    ADD CONSTRAINT "bank_transaction_hoa_don_id_fkey" FOREIGN KEY ("hoa_don_id") REFERENCES "public"."hoa_don"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."bank_transaction"
    ADD CONSTRAINT "bank_transaction_nha_tro_id_fkey" FOREIGN KEY ("nha_tro_id") REFERENCES "public"."nha_tro"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."cau_hinh_gia"
    ADD CONSTRAINT "cau_hinh_gia_dich_vu_id_fkey" FOREIGN KEY ("dich_vu_id") REFERENCES "public"."dich_vu"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."cau_hinh_gia"
    ADD CONSTRAINT "cau_hinh_gia_nha_tro_id_fkey" FOREIGN KEY ("nha_tro_id") REFERENCES "public"."nha_tro"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."chi_so_dien_nuoc"
    ADD CONSTRAINT "chi_so_dien_nuoc_hop_dong_id_fkey" FOREIGN KEY ("hop_dong_id") REFERENCES "public"."hop_dong"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."chi_so_dien_nuoc"
    ADD CONSTRAINT "chi_so_dien_nuoc_nguoi_ghi_id_fkey" FOREIGN KEY ("nguoi_ghi_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."chi_so_dien_nuoc"
    ADD CONSTRAINT "chi_so_dien_nuoc_phong_id_fkey" FOREIGN KEY ("phong_id") REFERENCES "public"."phong"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."chi_tiet_hoa_don"
    ADD CONSTRAINT "chi_tiet_hoa_don_chi_so_dien_nuoc_id_fkey" FOREIGN KEY ("chi_so_dien_nuoc_id") REFERENCES "public"."chi_so_dien_nuoc"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."chi_tiet_hoa_don"
    ADD CONSTRAINT "chi_tiet_hoa_don_dich_vu_id_fkey" FOREIGN KEY ("dich_vu_id") REFERENCES "public"."dich_vu"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."chi_tiet_hoa_don"
    ADD CONSTRAINT "chi_tiet_hoa_don_hoa_don_id_fkey" FOREIGN KEY ("hoa_don_id") REFERENCES "public"."hoa_don"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."dat_coc_phong"
    ADD CONSTRAINT "dat_coc_phong_hop_dong_id_fkey" FOREIGN KEY ("hop_dong_id") REFERENCES "public"."hop_dong"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."dat_coc_phong"
    ADD CONSTRAINT "dat_coc_phong_khach_thue_id_fkey" FOREIGN KEY ("khach_thue_id") REFERENCES "public"."khach_thue"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."dat_coc_phong"
    ADD CONSTRAINT "dat_coc_phong_phong_id_fkey" FOREIGN KEY ("phong_id") REFERENCES "public"."phong"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."dich_vu"
    ADD CONSTRAINT "dich_vu_chu_tro_id_fkey" FOREIGN KEY ("chu_tro_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."dich_vu_hop_dong"
    ADD CONSTRAINT "dich_vu_hop_dong_dich_vu_id_fkey" FOREIGN KEY ("dich_vu_id") REFERENCES "public"."dich_vu"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."dich_vu_hop_dong"
    ADD CONSTRAINT "dich_vu_hop_dong_hop_dong_id_fkey" FOREIGN KEY ("hop_dong_id") REFERENCES "public"."hop_dong"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."email_verification_token"
    ADD CONSTRAINT "email_verification_token_nguoi_dung_id_fkey" FOREIGN KEY ("nguoi_dung_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."file_media"
    ADD CONSTRAINT "file_media_nguoi_tai_len_id_fkey" FOREIGN KEY ("nguoi_tai_len_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."chi_tiet_hoa_don"
    ADD CONSTRAINT "fk_cthd_su_co" FOREIGN KEY ("su_co_id") REFERENCES "public"."su_co"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."hoa_don"
    ADD CONSTRAINT "hoa_don_hop_dong_id_fkey" FOREIGN KEY ("hop_dong_id") REFERENCES "public"."hop_dong"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."hoa_don"
    ADD CONSTRAINT "hoa_don_khach_thue_id_fkey" FOREIGN KEY ("khach_thue_id") REFERENCES "public"."khach_thue"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."hoa_don"
    ADD CONSTRAINT "hoa_don_phong_id_fkey" FOREIGN KEY ("phong_id") REFERENCES "public"."phong"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."hop_dong"
    ADD CONSTRAINT "hop_dong_khach_thue_id_fkey" FOREIGN KEY ("khach_thue_id") REFERENCES "public"."khach_thue"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."hop_dong"
    ADD CONSTRAINT "hop_dong_phong_id_fkey" FOREIGN KEY ("phong_id") REFERENCES "public"."phong"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."khach_thue"
    ADD CONSTRAINT "khach_thue_chu_tro_id_fkey" FOREIGN KEY ("chu_tro_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."khach_thue"
    ADD CONSTRAINT "khach_thue_nguoi_dung_id_fkey" FOREIGN KEY ("nguoi_dung_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."lich_hen"
    ADD CONSTRAINT "lich_hen_nguoi_dung_id_fkey" FOREIGN KEY ("nguoi_dung_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."lich_hen"
    ADD CONSTRAINT "lich_hen_phong_id_fkey" FOREIGN KEY ("phong_id") REFERENCES "public"."phong"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."lich_su_hoa_don"
    ADD CONSTRAINT "lich_su_hoa_don_hoa_don_id_fkey" FOREIGN KEY ("hoa_don_id") REFERENCES "public"."hoa_don"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."lich_su_hoa_don"
    ADD CONSTRAINT "lich_su_hoa_don_nguoi_thay_doi_id_fkey" FOREIGN KEY ("nguoi_thay_doi_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."lich_thanh_toan"
    ADD CONSTRAINT "lich_thanh_toan_hoa_don_id_fkey" FOREIGN KEY ("hoa_don_id") REFERENCES "public"."hoa_don"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."lich_thanh_toan"
    ADD CONSTRAINT "lich_thanh_toan_hop_dong_id_fkey" FOREIGN KEY ("hop_dong_id") REFERENCES "public"."hop_dong"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."login_history"
    ADD CONSTRAINT "login_history_nguoi_dung_id_fkey" FOREIGN KEY ("nguoi_dung_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."nguoi_dung_nha_tro"
    ADD CONSTRAINT "nguoi_dung_nha_tro_nguoi_dung_id_fkey" FOREIGN KEY ("nguoi_dung_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."nguoi_dung_nha_tro"
    ADD CONSTRAINT "nguoi_dung_nha_tro_nha_tro_id_fkey" FOREIGN KEY ("nha_tro_id") REFERENCES "public"."nha_tro"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."nguoi_dung_vai_tro"
    ADD CONSTRAINT "nguoi_dung_vai_tro_nguoi_dung_id_fkey" FOREIGN KEY ("nguoi_dung_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."nguoi_dung_vai_tro"
    ADD CONSTRAINT "nguoi_dung_vai_tro_vai_tro_id_fkey" FOREIGN KEY ("vai_tro_id") REFERENCES "public"."vai_tro"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."nha_tro"
    ADD CONSTRAINT "nha_tro_chu_tro_id_fkey" FOREIGN KEY ("chu_tro_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."phong"
    ADD CONSTRAINT "phong_nha_tro_id_fkey" FOREIGN KEY ("nha_tro_id") REFERENCES "public"."nha_tro"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."phong"
    ADD CONSTRAINT "phong_nha_tro_id_tang_id_fkey" FOREIGN KEY ("nha_tro_id", "tang_id") REFERENCES "public"."tang"("nha_tro_id", "id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."phong"
    ADD CONSTRAINT "phong_tang_id_fkey" FOREIGN KEY ("tang_id") REFERENCES "public"."tang"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."phong_tien_ich"
    ADD CONSTRAINT "phong_tien_ich_phong_id_fkey" FOREIGN KEY ("phong_id") REFERENCES "public"."phong"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."phong_tien_ich"
    ADD CONSTRAINT "phong_tien_ich_tien_ich_id_fkey" FOREIGN KEY ("tien_ich_id") REFERENCES "public"."tien_ich"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."phu_luc_hop_dong"
    ADD CONSTRAINT "phu_luc_hop_dong_hop_dong_id_fkey" FOREIGN KEY ("hop_dong_id") REFERENCES "public"."hop_dong"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."phu_luc_hop_dong"
    ADD CONSTRAINT "phu_luc_hop_dong_nguoi_tao_id_fkey" FOREIGN KEY ("nguoi_tao_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."refresh_token"
    ADD CONSTRAINT "refresh_token_nguoi_dung_id_fkey" FOREIGN KEY ("nguoi_dung_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."su_co"
    ADD CONSTRAINT "su_co_khach_thue_id_fkey" FOREIGN KEY ("khach_thue_id") REFERENCES "public"."khach_thue"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."su_co"
    ADD CONSTRAINT "su_co_nguoi_bao_id_fkey" FOREIGN KEY ("nguoi_bao_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."su_co"
    ADD CONSTRAINT "su_co_nguoi_phu_trach_id_fkey" FOREIGN KEY ("nguoi_phu_trach_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."su_co"
    ADD CONSTRAINT "su_co_phong_id_fkey" FOREIGN KEY ("phong_id") REFERENCES "public"."phong"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tang"
    ADD CONSTRAINT "tang_nha_tro_id_fkey" FOREIGN KEY ("nha_tro_id") REFERENCES "public"."nha_tro"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."thanh_toan"
    ADD CONSTRAINT "thanh_toan_hoa_don_id_fkey" FOREIGN KEY ("hoa_don_id") REFERENCES "public"."hoa_don"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."thanh_toan"
    ADD CONSTRAINT "thanh_toan_khach_thue_id_fkey" FOREIGN KEY ("khach_thue_id") REFERENCES "public"."khach_thue"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."thanh_toan"
    ADD CONSTRAINT "thanh_toan_nguoi_ghi_nhan_id_fkey" FOREIGN KEY ("nguoi_ghi_nhan_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."thanh_toan"
    ADD CONSTRAINT "thanh_toan_nguoi_thanh_toan_id_fkey" FOREIGN KEY ("nguoi_thanh_toan_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."thanh_vien_hop_dong"
    ADD CONSTRAINT "thanh_vien_hop_dong_hop_dong_id_fkey" FOREIGN KEY ("hop_dong_id") REFERENCES "public"."hop_dong"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."thanh_vien_hop_dong"
    ADD CONSTRAINT "thanh_vien_hop_dong_khach_thue_id_fkey" FOREIGN KEY ("khach_thue_id") REFERENCES "public"."khach_thue"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."thong_bao"
    ADD CONSTRAINT "thong_bao_nguoi_gui_id_fkey" FOREIGN KEY ("nguoi_gui_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."thong_bao_nguoi_nhan"
    ADD CONSTRAINT "thong_bao_nguoi_nhan_nguoi_dung_id_fkey" FOREIGN KEY ("nguoi_dung_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."thong_bao_nguoi_nhan"
    ADD CONSTRAINT "thong_bao_nguoi_nhan_thong_bao_id_fkey" FOREIGN KEY ("thong_bao_id") REFERENCES "public"."thong_bao"("id") ON DELETE CASCADE;



ALTER TABLE "public"."audit_log" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "audit_log_admin_read" ON "public"."audit_log" FOR SELECT USING ("public"."is_admin"());



ALTER TABLE "public"."bank_transaction" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "bank_transaction_by_nha_tro" ON "public"."bank_transaction" USING ((("nha_tro_id" IS NOT NULL) AND "public"."can_access_nha_tro"("nha_tro_id"))) WITH CHECK ((("nha_tro_id" IS NOT NULL) AND "public"."can_access_nha_tro"("nha_tro_id")));



ALTER TABLE "public"."cau_hinh_gia" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "cau_hinh_gia_by_nha_tro" ON "public"."cau_hinh_gia" USING ("public"."can_access_nha_tro"("nha_tro_id")) WITH CHECK ("public"."can_access_nha_tro"("nha_tro_id"));



CREATE POLICY "chi_so_by_room" ON "public"."chi_so_dien_nuoc" USING ((EXISTS ( SELECT 1
   FROM "public"."phong" "p"
  WHERE (("p"."id" = "chi_so_dien_nuoc"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id"))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."phong" "p"
  WHERE (("p"."id" = "chi_so_dien_nuoc"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))));



ALTER TABLE "public"."chi_so_dien_nuoc" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."chi_tiet_hoa_don" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "chi_tiet_hoa_don_by_invoice" ON "public"."chi_tiet_hoa_don" USING ((EXISTS ( SELECT 1
   FROM "public"."hoa_don" "hd"
  WHERE (("hd"."id" = "chi_tiet_hoa_don"."hoa_don_id") AND ((EXISTS ( SELECT 1
           FROM "public"."phong" "p"
          WHERE (("p"."id" = "hd"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))) OR (EXISTS ( SELECT 1
           FROM "public"."khach_thue" "kt"
          WHERE (("kt"."id" = "hd"."khach_thue_id") AND ("kt"."nguoi_dung_id" = "auth"."uid"()))))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."hoa_don" "hd"
     JOIN "public"."phong" "p" ON (("p"."id" = "hd"."phong_id")))
  WHERE (("hd"."id" = "chi_tiet_hoa_don"."hoa_don_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))));



ALTER TABLE "public"."chu_tro" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "dat_coc_by_room" ON "public"."dat_coc_phong" USING ((EXISTS ( SELECT 1
   FROM "public"."phong" "p"
  WHERE (("p"."id" = "dat_coc_phong"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id"))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."phong" "p"
  WHERE (("p"."id" = "dat_coc_phong"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))));



ALTER TABLE "public"."dat_coc_phong" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."dich_vu" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."dich_vu_hop_dong" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "dich_vu_hop_dong_by_contract" ON "public"."dich_vu_hop_dong" USING ((EXISTS ( SELECT 1
   FROM ("public"."hop_dong" "hd"
     JOIN "public"."phong" "p" ON (("p"."id" = "hd"."phong_id")))
  WHERE (("hd"."id" = "dich_vu_hop_dong"."hop_dong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id"))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."hop_dong" "hd"
     JOIN "public"."phong" "p" ON (("p"."id" = "hd"."phong_id")))
  WHERE (("hd"."id" = "dich_vu_hop_dong"."hop_dong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))));



CREATE POLICY "dich_vu_owner" ON "public"."dich_vu" USING ((("chu_tro_id" = "auth"."uid"()) OR "public"."is_admin"())) WITH CHECK ((("chu_tro_id" = "auth"."uid"()) OR "public"."is_admin"()));



ALTER TABLE "public"."email_verification_token" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."file_media" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "file_media_uploader_admin" ON "public"."file_media" USING ((("nguoi_tai_len_id" = "auth"."uid"()) OR "public"."is_admin"())) WITH CHECK ((("nguoi_tai_len_id" = "auth"."uid"()) OR "public"."is_admin"()));



ALTER TABLE "public"."hoa_don" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "hoa_don_by_room_or_tenant" ON "public"."hoa_don" USING (((EXISTS ( SELECT 1
   FROM "public"."phong" "p"
  WHERE (("p"."id" = "hoa_don"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))) OR (EXISTS ( SELECT 1
   FROM "public"."khach_thue" "kt"
  WHERE (("kt"."id" = "hoa_don"."khach_thue_id") AND ("kt"."nguoi_dung_id" = "auth"."uid"())))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."phong" "p"
  WHERE (("p"."id" = "hoa_don"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))));



ALTER TABLE "public"."hop_dong" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "hop_dong_by_room_or_tenant" ON "public"."hop_dong" USING (((EXISTS ( SELECT 1
   FROM "public"."phong" "p"
  WHERE (("p"."id" = "hop_dong"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))) OR (EXISTS ( SELECT 1
   FROM "public"."khach_thue" "kt"
  WHERE (("kt"."id" = "hop_dong"."khach_thue_id") AND ("kt"."nguoi_dung_id" = "auth"."uid"())))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."phong" "p"
  WHERE (("p"."id" = "hop_dong"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))));



ALTER TABLE "public"."khach_thue" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "khach_thue_owner_or_self" ON "public"."khach_thue" USING (("public"."is_admin"() OR ("chu_tro_id" = "auth"."uid"()) OR ("nguoi_dung_id" = "auth"."uid"()))) WITH CHECK (("public"."is_admin"() OR ("chu_tro_id" = "auth"."uid"()) OR ("nguoi_dung_id" = "auth"."uid"())));



ALTER TABLE "public"."lich_hen" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "lich_hen_by_room_or_user" ON "public"."lich_hen" USING ((("nguoi_dung_id" = "auth"."uid"()) OR (EXISTS ( SELECT 1
   FROM "public"."phong" "p"
  WHERE (("p"."id" = "lich_hen"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))))) WITH CHECK ((("nguoi_dung_id" = "auth"."uid"()) OR (EXISTS ( SELECT 1
   FROM "public"."phong" "p"
  WHERE (("p"."id" = "lich_hen"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id"))))));



ALTER TABLE "public"."lich_su_hoa_don" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "lich_su_hoa_don_by_invoice" ON "public"."lich_su_hoa_don" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."hoa_don" "hd"
  WHERE (("hd"."id" = "lich_su_hoa_don"."hoa_don_id") AND ((EXISTS ( SELECT 1
           FROM "public"."phong" "p"
          WHERE (("p"."id" = "hd"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))) OR (EXISTS ( SELECT 1
           FROM "public"."khach_thue" "kt"
          WHERE (("kt"."id" = "hd"."khach_thue_id") AND ("kt"."nguoi_dung_id" = "auth"."uid"())))))))));



ALTER TABLE "public"."login_history" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "login_history_self_or_admin" ON "public"."login_history" FOR SELECT USING ((("nguoi_dung_id" = "auth"."uid"()) OR "public"."is_admin"()));



ALTER TABLE "public"."nguoi_dung" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."nguoi_dung_nha_tro" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "nguoi_dung_nha_tro_owner_admin" ON "public"."nguoi_dung_nha_tro" USING (("public"."is_admin"() OR (EXISTS ( SELECT 1
   FROM "public"."nha_tro" "nt"
  WHERE (("nt"."id" = "nguoi_dung_nha_tro"."nha_tro_id") AND ("nt"."chu_tro_id" = "auth"."uid"())))))) WITH CHECK (("public"."is_admin"() OR (EXISTS ( SELECT 1
   FROM "public"."nha_tro" "nt"
  WHERE (("nt"."id" = "nguoi_dung_nha_tro"."nha_tro_id") AND ("nt"."chu_tro_id" = "auth"."uid"()))))));



CREATE POLICY "nguoi_dung_self_or_admin" ON "public"."nguoi_dung" USING ((("id" = "auth"."uid"()) OR "public"."is_admin"())) WITH CHECK ((("id" = "auth"."uid"()) OR "public"."is_admin"()));



ALTER TABLE "public"."nguoi_dung_vai_tro" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "nguoi_dung_vai_tro_admin_write" ON "public"."nguoi_dung_vai_tro" USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "nguoi_dung_vai_tro_self_or_admin_read" ON "public"."nguoi_dung_vai_tro" FOR SELECT USING ((("nguoi_dung_id" = "auth"."uid"()) OR "public"."is_admin"()));



ALTER TABLE "public"."nha_tro" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "nha_tro_owner_staff" ON "public"."nha_tro" USING ("public"."can_access_nha_tro"("id")) WITH CHECK ((("chu_tro_id" = "auth"."uid"()) OR "public"."is_admin"()));



ALTER TABLE "public"."phong" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "phong_by_nha_tro" ON "public"."phong" USING ("public"."can_access_nha_tro"("nha_tro_id")) WITH CHECK ("public"."can_access_nha_tro"("nha_tro_id"));



ALTER TABLE "public"."phong_tien_ich" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "phong_tien_ich_by_room" ON "public"."phong_tien_ich" USING ((EXISTS ( SELECT 1
   FROM "public"."phong" "p"
  WHERE (("p"."id" = "phong_tien_ich"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id"))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."phong" "p"
  WHERE (("p"."id" = "phong_tien_ich"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))));



ALTER TABLE "public"."phu_luc_hop_dong" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "phu_luc_hop_dong_by_contract" ON "public"."phu_luc_hop_dong" USING ((EXISTS ( SELECT 1
   FROM ("public"."hop_dong" "hd"
     JOIN "public"."phong" "p" ON (("p"."id" = "hd"."phong_id")))
  WHERE (("hd"."id" = "phu_luc_hop_dong"."hop_dong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id"))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."hop_dong" "hd"
     JOIN "public"."phong" "p" ON (("p"."id" = "hd"."phong_id")))
  WHERE (("hd"."id" = "phu_luc_hop_dong"."hop_dong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))));



ALTER TABLE "public"."refresh_token" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."su_co" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "su_co_by_room_or_reporter" ON "public"."su_co" USING (((EXISTS ( SELECT 1
   FROM "public"."phong" "p"
  WHERE (("p"."id" = "su_co"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))) OR ("nguoi_bao_id" = "auth"."uid"()) OR (EXISTS ( SELECT 1
   FROM "public"."khach_thue" "kt"
  WHERE (("kt"."id" = "su_co"."khach_thue_id") AND ("kt"."nguoi_dung_id" = "auth"."uid"())))))) WITH CHECK (((EXISTS ( SELECT 1
   FROM "public"."phong" "p"
  WHERE (("p"."id" = "su_co"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))) OR ("nguoi_bao_id" = "auth"."uid"())));



ALTER TABLE "public"."tang" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."thanh_toan" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "thanh_toan_by_invoice" ON "public"."thanh_toan" USING ((EXISTS ( SELECT 1
   FROM "public"."hoa_don" "hd"
  WHERE (("hd"."id" = "thanh_toan"."hoa_don_id") AND ((EXISTS ( SELECT 1
           FROM "public"."phong" "p"
          WHERE (("p"."id" = "hd"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))) OR (EXISTS ( SELECT 1
           FROM "public"."khach_thue" "kt"
          WHERE (("kt"."id" = "hd"."khach_thue_id") AND ("kt"."nguoi_dung_id" = "auth"."uid"()))))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."hoa_don" "hd"
     JOIN "public"."phong" "p" ON (("p"."id" = "hd"."phong_id")))
  WHERE (("hd"."id" = "thanh_toan"."hoa_don_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))));



ALTER TABLE "public"."thanh_vien_hop_dong" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "thanh_vien_hop_dong_by_contract" ON "public"."thanh_vien_hop_dong" USING ((EXISTS ( SELECT 1
   FROM "public"."hop_dong" "hd"
  WHERE (("hd"."id" = "thanh_vien_hop_dong"."hop_dong_id") AND ((EXISTS ( SELECT 1
           FROM "public"."phong" "p"
          WHERE (("p"."id" = "hd"."phong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))) OR (EXISTS ( SELECT 1
           FROM "public"."khach_thue" "kt"
          WHERE (("kt"."id" = "hd"."khach_thue_id") AND ("kt"."nguoi_dung_id" = "auth"."uid"()))))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."hop_dong" "hd"
     JOIN "public"."phong" "p" ON (("p"."id" = "hd"."phong_id")))
  WHERE (("hd"."id" = "thanh_vien_hop_dong"."hop_dong_id") AND "public"."can_access_nha_tro"("p"."nha_tro_id")))));



ALTER TABLE "public"."thong_bao" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "thong_bao_insert_authenticated" ON "public"."thong_bao" FOR INSERT WITH CHECK ((("nguoi_gui_id" = "auth"."uid"()) OR "public"."is_admin"()));



ALTER TABLE "public"."thong_bao_nguoi_nhan" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "thong_bao_recipient_insert_sender" ON "public"."thong_bao_nguoi_nhan" FOR INSERT WITH CHECK (("public"."is_admin"() OR (EXISTS ( SELECT 1
   FROM "public"."thong_bao" "tb"
  WHERE (("tb"."id" = "thong_bao_nguoi_nhan"."thong_bao_id") AND ("tb"."nguoi_gui_id" = "auth"."uid"()))))));



CREATE POLICY "thong_bao_recipient_read" ON "public"."thong_bao_nguoi_nhan" FOR SELECT USING ((("nguoi_dung_id" = "auth"."uid"()) OR "public"."is_admin"()));



CREATE POLICY "thong_bao_recipient_update_self" ON "public"."thong_bao_nguoi_nhan" FOR UPDATE USING ((("nguoi_dung_id" = "auth"."uid"()) OR "public"."is_admin"())) WITH CHECK ((("nguoi_dung_id" = "auth"."uid"()) OR "public"."is_admin"()));



CREATE POLICY "thong_bao_sender_or_recipient" ON "public"."thong_bao" FOR SELECT USING ((("nguoi_gui_id" = "auth"."uid"()) OR "public"."is_admin"() OR (EXISTS ( SELECT 1
   FROM "public"."thong_bao_nguoi_nhan" "tbn"
  WHERE (("tbn"."thong_bao_id" = "thong_bao"."id") AND ("tbn"."nguoi_dung_id" = "auth"."uid"()))))));



ALTER TABLE "public"."tien_ich" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "tien_ich_admin_write" ON "public"."tien_ich" USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "tien_ich_read_authenticated" ON "public"."tien_ich" FOR SELECT USING (("auth"."uid"() IS NOT NULL));



ALTER TABLE "public"."vai_tro" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "vai_tro_read_authenticated" ON "public"."vai_tro" FOR SELECT USING (("auth"."uid"() IS NOT NULL));





ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey16_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey16_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey16_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey16_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey16_out"("public"."gbtreekey16") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey16_out"("public"."gbtreekey16") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey16_out"("public"."gbtreekey16") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey16_out"("public"."gbtreekey16") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey2_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey2_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey2_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey2_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey2_out"("public"."gbtreekey2") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey2_out"("public"."gbtreekey2") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey2_out"("public"."gbtreekey2") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey2_out"("public"."gbtreekey2") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey32_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey32_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey32_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey32_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey32_out"("public"."gbtreekey32") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey32_out"("public"."gbtreekey32") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey32_out"("public"."gbtreekey32") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey32_out"("public"."gbtreekey32") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey4_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey4_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey4_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey4_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey4_out"("public"."gbtreekey4") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey4_out"("public"."gbtreekey4") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey4_out"("public"."gbtreekey4") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey4_out"("public"."gbtreekey4") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey8_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey8_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey8_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey8_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey8_out"("public"."gbtreekey8") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey8_out"("public"."gbtreekey8") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey8_out"("public"."gbtreekey8") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey8_out"("public"."gbtreekey8") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey_var_in"("cstring") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_in"("cstring") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_in"("cstring") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_in"("cstring") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbtreekey_var_out"("public"."gbtreekey_var") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_out"("public"."gbtreekey_var") TO "anon";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_out"("public"."gbtreekey_var") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbtreekey_var_out"("public"."gbtreekey_var") TO "service_role";






















































































































































GRANT ALL ON FUNCTION "public"."can_access_nha_tro"("p_nha_tro_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."can_access_nha_tro"("p_nha_tro_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."can_access_nha_tro"("p_nha_tro_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."cap_nhat_thoi_gian"() TO "anon";
GRANT ALL ON FUNCTION "public"."cap_nhat_thoi_gian"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."cap_nhat_thoi_gian"() TO "service_role";



GRANT ALL ON FUNCTION "public"."cap_nhat_trang_thai_hoa_don"() TO "anon";
GRANT ALL ON FUNCTION "public"."cap_nhat_trang_thai_hoa_don"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."cap_nhat_trang_thai_hoa_don"() TO "service_role";



GRANT ALL ON FUNCTION "public"."cash_dist"("money", "money") TO "postgres";
GRANT ALL ON FUNCTION "public"."cash_dist"("money", "money") TO "anon";
GRANT ALL ON FUNCTION "public"."cash_dist"("money", "money") TO "authenticated";
GRANT ALL ON FUNCTION "public"."cash_dist"("money", "money") TO "service_role";



GRANT ALL ON FUNCTION "public"."clone_cau_truc_toa_nha"("p_nha_tro_nguon_id" "uuid", "p_nha_tro_dich_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."clone_cau_truc_toa_nha"("p_nha_tro_nguon_id" "uuid", "p_nha_tro_dich_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."clone_cau_truc_toa_nha"("p_nha_tro_nguon_id" "uuid", "p_nha_tro_dich_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."date_dist"("date", "date") TO "postgres";
GRANT ALL ON FUNCTION "public"."date_dist"("date", "date") TO "anon";
GRANT ALL ON FUNCTION "public"."date_dist"("date", "date") TO "authenticated";
GRANT ALL ON FUNCTION "public"."date_dist"("date", "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."float4_dist"(real, real) TO "postgres";
GRANT ALL ON FUNCTION "public"."float4_dist"(real, real) TO "anon";
GRANT ALL ON FUNCTION "public"."float4_dist"(real, real) TO "authenticated";
GRANT ALL ON FUNCTION "public"."float4_dist"(real, real) TO "service_role";



GRANT ALL ON FUNCTION "public"."float8_dist"(double precision, double precision) TO "postgres";
GRANT ALL ON FUNCTION "public"."float8_dist"(double precision, double precision) TO "anon";
GRANT ALL ON FUNCTION "public"."float8_dist"(double precision, double precision) TO "authenticated";
GRANT ALL ON FUNCTION "public"."float8_dist"(double precision, double precision) TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_consistent"("internal", bit, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_consistent"("internal", bit, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_consistent"("internal", bit, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_consistent"("internal", bit, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bit_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bit_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bit_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bit_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_consistent"("internal", boolean, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_consistent"("internal", boolean, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_consistent"("internal", boolean, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_consistent"("internal", boolean, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_same"("public"."gbtreekey2", "public"."gbtreekey2", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_same"("public"."gbtreekey2", "public"."gbtreekey2", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_same"("public"."gbtreekey2", "public"."gbtreekey2", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_same"("public"."gbtreekey2", "public"."gbtreekey2", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bool_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bool_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bool_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bool_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bpchar_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bpchar_consistent"("internal", character, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_consistent"("internal", character, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_consistent"("internal", character, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bpchar_consistent"("internal", character, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_consistent"("internal", "bytea", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_consistent"("internal", "bytea", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_consistent"("internal", "bytea", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_consistent"("internal", "bytea", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_bytea_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_bytea_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_bytea_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_bytea_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_consistent"("internal", "money", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_consistent"("internal", "money", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_consistent"("internal", "money", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_consistent"("internal", "money", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_distance"("internal", "money", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_distance"("internal", "money", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_distance"("internal", "money", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_distance"("internal", "money", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_cash_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_cash_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_cash_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_cash_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_consistent"("internal", "date", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_consistent"("internal", "date", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_consistent"("internal", "date", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_consistent"("internal", "date", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_distance"("internal", "date", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_distance"("internal", "date", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_distance"("internal", "date", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_distance"("internal", "date", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_date_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_date_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_date_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_date_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_decompress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_decompress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_decompress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_decompress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_consistent"("internal", "anyenum", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_consistent"("internal", "anyenum", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_consistent"("internal", "anyenum", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_consistent"("internal", "anyenum", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_enum_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_enum_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_enum_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_enum_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_consistent"("internal", real, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_consistent"("internal", real, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_consistent"("internal", real, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_consistent"("internal", real, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_distance"("internal", real, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_distance"("internal", real, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_distance"("internal", real, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_distance"("internal", real, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float4_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float4_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float4_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float4_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_consistent"("internal", double precision, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_consistent"("internal", double precision, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_consistent"("internal", double precision, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_consistent"("internal", double precision, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_distance"("internal", double precision, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_distance"("internal", double precision, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_distance"("internal", double precision, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_distance"("internal", double precision, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_float8_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_float8_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_float8_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_float8_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_consistent"("internal", "inet", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_consistent"("internal", "inet", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_consistent"("internal", "inet", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_consistent"("internal", "inet", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_inet_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_inet_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_inet_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_inet_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_consistent"("internal", smallint, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_consistent"("internal", smallint, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_consistent"("internal", smallint, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_consistent"("internal", smallint, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_distance"("internal", smallint, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_distance"("internal", smallint, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_distance"("internal", smallint, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_distance"("internal", smallint, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_same"("public"."gbtreekey4", "public"."gbtreekey4", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_same"("public"."gbtreekey4", "public"."gbtreekey4", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_same"("public"."gbtreekey4", "public"."gbtreekey4", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_same"("public"."gbtreekey4", "public"."gbtreekey4", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int2_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int2_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int2_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int2_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_consistent"("internal", integer, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_consistent"("internal", integer, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_consistent"("internal", integer, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_consistent"("internal", integer, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_distance"("internal", integer, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_distance"("internal", integer, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_distance"("internal", integer, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_distance"("internal", integer, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int4_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int4_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int4_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int4_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_consistent"("internal", bigint, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_consistent"("internal", bigint, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_consistent"("internal", bigint, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_consistent"("internal", bigint, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_distance"("internal", bigint, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_distance"("internal", bigint, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_distance"("internal", bigint, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_distance"("internal", bigint, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_int8_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_int8_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_int8_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_int8_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_consistent"("internal", interval, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_consistent"("internal", interval, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_consistent"("internal", interval, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_consistent"("internal", interval, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_decompress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_decompress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_decompress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_decompress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_distance"("internal", interval, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_distance"("internal", interval, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_distance"("internal", interval, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_distance"("internal", interval, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_intv_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_intv_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_intv_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_intv_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_consistent"("internal", "macaddr8", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_consistent"("internal", "macaddr8", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_consistent"("internal", "macaddr8", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_consistent"("internal", "macaddr8", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad8_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad8_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad8_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad8_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_consistent"("internal", "macaddr", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_consistent"("internal", "macaddr", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_consistent"("internal", "macaddr", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_consistent"("internal", "macaddr", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_macad_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_macad_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_macad_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_macad_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_consistent"("internal", numeric, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_consistent"("internal", numeric, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_consistent"("internal", numeric, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_consistent"("internal", numeric, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_numeric_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_numeric_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_numeric_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_numeric_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_consistent"("internal", "oid", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_consistent"("internal", "oid", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_consistent"("internal", "oid", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_consistent"("internal", "oid", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_distance"("internal", "oid", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_distance"("internal", "oid", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_distance"("internal", "oid", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_distance"("internal", "oid", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_same"("public"."gbtreekey8", "public"."gbtreekey8", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_oid_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_oid_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_oid_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_oid_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_consistent"("internal", "text", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_consistent"("internal", "text", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_consistent"("internal", "text", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_consistent"("internal", "text", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_same"("public"."gbtreekey_var", "public"."gbtreekey_var", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_text_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_text_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_text_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_text_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_consistent"("internal", time without time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_consistent"("internal", time without time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_consistent"("internal", time without time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_consistent"("internal", time without time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_distance"("internal", time without time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_distance"("internal", time without time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_distance"("internal", time without time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_distance"("internal", time without time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_time_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_time_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_time_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_time_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_timetz_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_timetz_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_timetz_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_timetz_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_timetz_consistent"("internal", time with time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_timetz_consistent"("internal", time with time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_timetz_consistent"("internal", time with time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_timetz_consistent"("internal", time with time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_consistent"("internal", timestamp without time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_consistent"("internal", timestamp without time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_consistent"("internal", timestamp without time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_consistent"("internal", timestamp without time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_distance"("internal", timestamp without time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_distance"("internal", timestamp without time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_distance"("internal", timestamp without time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_distance"("internal", timestamp without time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_same"("public"."gbtreekey16", "public"."gbtreekey16", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_ts_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_ts_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_ts_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_ts_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_tstz_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_tstz_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_tstz_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_tstz_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_tstz_consistent"("internal", timestamp with time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_tstz_consistent"("internal", timestamp with time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_tstz_consistent"("internal", timestamp with time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_tstz_consistent"("internal", timestamp with time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_tstz_distance"("internal", timestamp with time zone, smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_tstz_distance"("internal", timestamp with time zone, smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_tstz_distance"("internal", timestamp with time zone, smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_tstz_distance"("internal", timestamp with time zone, smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_compress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_compress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_compress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_compress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_consistent"("internal", "uuid", smallint, "oid", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_consistent"("internal", "uuid", smallint, "oid", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_consistent"("internal", "uuid", smallint, "oid", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_consistent"("internal", "uuid", smallint, "oid", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_penalty"("internal", "internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_penalty"("internal", "internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_penalty"("internal", "internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_penalty"("internal", "internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_picksplit"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_picksplit"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_picksplit"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_picksplit"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_same"("public"."gbtreekey32", "public"."gbtreekey32", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_uuid_union"("internal", "internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_uuid_union"("internal", "internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_uuid_union"("internal", "internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_uuid_union"("internal", "internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_var_decompress"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_var_decompress"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_var_decompress"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_var_decompress"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."gbt_var_fetch"("internal") TO "postgres";
GRANT ALL ON FUNCTION "public"."gbt_var_fetch"("internal") TO "anon";
GRANT ALL ON FUNCTION "public"."gbt_var_fetch"("internal") TO "authenticated";
GRANT ALL ON FUNCTION "public"."gbt_var_fetch"("internal") TO "service_role";



GRANT ALL ON FUNCTION "public"."int2_dist"(smallint, smallint) TO "postgres";
GRANT ALL ON FUNCTION "public"."int2_dist"(smallint, smallint) TO "anon";
GRANT ALL ON FUNCTION "public"."int2_dist"(smallint, smallint) TO "authenticated";
GRANT ALL ON FUNCTION "public"."int2_dist"(smallint, smallint) TO "service_role";



GRANT ALL ON FUNCTION "public"."int4_dist"(integer, integer) TO "postgres";
GRANT ALL ON FUNCTION "public"."int4_dist"(integer, integer) TO "anon";
GRANT ALL ON FUNCTION "public"."int4_dist"(integer, integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."int4_dist"(integer, integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."int8_dist"(bigint, bigint) TO "postgres";
GRANT ALL ON FUNCTION "public"."int8_dist"(bigint, bigint) TO "anon";
GRANT ALL ON FUNCTION "public"."int8_dist"(bigint, bigint) TO "authenticated";
GRANT ALL ON FUNCTION "public"."int8_dist"(bigint, bigint) TO "service_role";



GRANT ALL ON FUNCTION "public"."interval_dist"(interval, interval) TO "postgres";
GRANT ALL ON FUNCTION "public"."interval_dist"(interval, interval) TO "anon";
GRANT ALL ON FUNCTION "public"."interval_dist"(interval, interval) TO "authenticated";
GRANT ALL ON FUNCTION "public"."interval_dist"(interval, interval) TO "service_role";



GRANT ALL ON FUNCTION "public"."is_admin"() TO "anon";
GRANT ALL ON FUNCTION "public"."is_admin"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_admin"() TO "service_role";



GRANT ALL ON FUNCTION "public"."oid_dist"("oid", "oid") TO "postgres";
GRANT ALL ON FUNCTION "public"."oid_dist"("oid", "oid") TO "anon";
GRANT ALL ON FUNCTION "public"."oid_dist"("oid", "oid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."oid_dist"("oid", "oid") TO "service_role";



GRANT ALL ON FUNCTION "public"."recalc_hoa_don_from_chi_tiet"() TO "anon";
GRANT ALL ON FUNCTION "public"."recalc_hoa_don_from_chi_tiet"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."recalc_hoa_don_from_chi_tiet"() TO "service_role";



GRANT ALL ON FUNCTION "public"."recalc_hoa_don_from_thanh_toan"() TO "anon";
GRANT ALL ON FUNCTION "public"."recalc_hoa_don_from_thanh_toan"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."recalc_hoa_don_from_thanh_toan"() TO "service_role";



GRANT ALL ON FUNCTION "public"."sinh_phong_toa_nha"("p_nha_tro_id" "uuid", "p_so_tang" integer, "p_so_phong_moi_tang" integer, "p_dien_tich" numeric, "p_gia_hien_tai" numeric, "p_tien_coc_mac_dinh" numeric, "p_so_nguoi_toi_da" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."sinh_phong_toa_nha"("p_nha_tro_id" "uuid", "p_so_tang" integer, "p_so_phong_moi_tang" integer, "p_dien_tich" numeric, "p_gia_hien_tai" numeric, "p_tien_coc_mac_dinh" numeric, "p_so_nguoi_toi_da" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."sinh_phong_toa_nha"("p_nha_tro_id" "uuid", "p_so_tang" integer, "p_so_phong_moi_tang" integer, "p_dien_tich" numeric, "p_gia_hien_tai" numeric, "p_tien_coc_mac_dinh" numeric, "p_so_nguoi_toi_da" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."tao_lich_thanh_toan_hang_thang"("p_hop_dong_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."tao_lich_thanh_toan_hang_thang"("p_hop_dong_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."tao_lich_thanh_toan_hang_thang"("p_hop_dong_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."time_dist"(time without time zone, time without time zone) TO "postgres";
GRANT ALL ON FUNCTION "public"."time_dist"(time without time zone, time without time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."time_dist"(time without time zone, time without time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."time_dist"(time without time zone, time without time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."ts_dist"(timestamp without time zone, timestamp without time zone) TO "postgres";
GRANT ALL ON FUNCTION "public"."ts_dist"(timestamp without time zone, timestamp without time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."ts_dist"(timestamp without time zone, timestamp without time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."ts_dist"(timestamp without time zone, timestamp without time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."tstz_dist"(timestamp with time zone, timestamp with time zone) TO "postgres";
GRANT ALL ON FUNCTION "public"."tstz_dist"(timestamp with time zone, timestamp with time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."tstz_dist"(timestamp with time zone, timestamp with time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."tstz_dist"(timestamp with time zone, timestamp with time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."update_invoice_status_on_payment"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_invoice_status_on_payment"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_invoice_status_on_payment"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "service_role";


















GRANT ALL ON TABLE "public"."audit_log" TO "anon";
GRANT ALL ON TABLE "public"."audit_log" TO "authenticated";
GRANT ALL ON TABLE "public"."audit_log" TO "service_role";



GRANT ALL ON TABLE "public"."bank_transaction" TO "anon";
GRANT ALL ON TABLE "public"."bank_transaction" TO "authenticated";
GRANT ALL ON TABLE "public"."bank_transaction" TO "service_role";



GRANT ALL ON TABLE "public"."cau_hinh_gia" TO "anon";
GRANT ALL ON TABLE "public"."cau_hinh_gia" TO "authenticated";
GRANT ALL ON TABLE "public"."cau_hinh_gia" TO "service_role";



GRANT ALL ON TABLE "public"."chi_so_dien_nuoc" TO "anon";
GRANT ALL ON TABLE "public"."chi_so_dien_nuoc" TO "authenticated";
GRANT ALL ON TABLE "public"."chi_so_dien_nuoc" TO "service_role";



GRANT ALL ON TABLE "public"."chi_tiet_hoa_don" TO "anon";
GRANT ALL ON TABLE "public"."chi_tiet_hoa_don" TO "authenticated";
GRANT ALL ON TABLE "public"."chi_tiet_hoa_don" TO "service_role";



GRANT ALL ON TABLE "public"."chu_tro" TO "anon";
GRANT ALL ON TABLE "public"."chu_tro" TO "authenticated";
GRANT ALL ON TABLE "public"."chu_tro" TO "service_role";



GRANT ALL ON TABLE "public"."dat_coc_phong" TO "anon";
GRANT ALL ON TABLE "public"."dat_coc_phong" TO "authenticated";
GRANT ALL ON TABLE "public"."dat_coc_phong" TO "service_role";



GRANT ALL ON TABLE "public"."dich_vu" TO "anon";
GRANT ALL ON TABLE "public"."dich_vu" TO "authenticated";
GRANT ALL ON TABLE "public"."dich_vu" TO "service_role";



GRANT ALL ON TABLE "public"."dich_vu_hop_dong" TO "anon";
GRANT ALL ON TABLE "public"."dich_vu_hop_dong" TO "authenticated";
GRANT ALL ON TABLE "public"."dich_vu_hop_dong" TO "service_role";



GRANT ALL ON TABLE "public"."email_verification_token" TO "anon";
GRANT ALL ON TABLE "public"."email_verification_token" TO "authenticated";
GRANT ALL ON TABLE "public"."email_verification_token" TO "service_role";



GRANT ALL ON TABLE "public"."file_media" TO "anon";
GRANT ALL ON TABLE "public"."file_media" TO "authenticated";
GRANT ALL ON TABLE "public"."file_media" TO "service_role";



GRANT ALL ON TABLE "public"."hoa_don" TO "anon";
GRANT ALL ON TABLE "public"."hoa_don" TO "authenticated";
GRANT ALL ON TABLE "public"."hoa_don" TO "service_role";



GRANT ALL ON TABLE "public"."hop_dong" TO "anon";
GRANT ALL ON TABLE "public"."hop_dong" TO "authenticated";
GRANT ALL ON TABLE "public"."hop_dong" TO "service_role";



GRANT ALL ON TABLE "public"."khach_thue" TO "anon";
GRANT ALL ON TABLE "public"."khach_thue" TO "authenticated";
GRANT ALL ON TABLE "public"."khach_thue" TO "service_role";



GRANT ALL ON TABLE "public"."lich_hen" TO "anon";
GRANT ALL ON TABLE "public"."lich_hen" TO "authenticated";
GRANT ALL ON TABLE "public"."lich_hen" TO "service_role";



GRANT ALL ON TABLE "public"."lich_su_hoa_don" TO "anon";
GRANT ALL ON TABLE "public"."lich_su_hoa_don" TO "authenticated";
GRANT ALL ON TABLE "public"."lich_su_hoa_don" TO "service_role";



GRANT ALL ON TABLE "public"."lich_thanh_toan" TO "anon";
GRANT ALL ON TABLE "public"."lich_thanh_toan" TO "authenticated";
GRANT ALL ON TABLE "public"."lich_thanh_toan" TO "service_role";



GRANT ALL ON TABLE "public"."login_history" TO "anon";
GRANT ALL ON TABLE "public"."login_history" TO "authenticated";
GRANT ALL ON TABLE "public"."login_history" TO "service_role";



GRANT ALL ON TABLE "public"."nguoi_dung" TO "anon";
GRANT ALL ON TABLE "public"."nguoi_dung" TO "authenticated";
GRANT ALL ON TABLE "public"."nguoi_dung" TO "service_role";



GRANT ALL ON TABLE "public"."nguoi_dung_nha_tro" TO "anon";
GRANT ALL ON TABLE "public"."nguoi_dung_nha_tro" TO "authenticated";
GRANT ALL ON TABLE "public"."nguoi_dung_nha_tro" TO "service_role";



GRANT ALL ON TABLE "public"."nguoi_dung_vai_tro" TO "anon";
GRANT ALL ON TABLE "public"."nguoi_dung_vai_tro" TO "authenticated";
GRANT ALL ON TABLE "public"."nguoi_dung_vai_tro" TO "service_role";



GRANT ALL ON TABLE "public"."nha_tro" TO "anon";
GRANT ALL ON TABLE "public"."nha_tro" TO "authenticated";
GRANT ALL ON TABLE "public"."nha_tro" TO "service_role";



GRANT ALL ON TABLE "public"."phong" TO "anon";
GRANT ALL ON TABLE "public"."phong" TO "authenticated";
GRANT ALL ON TABLE "public"."phong" TO "service_role";



GRANT ALL ON TABLE "public"."phong_tien_ich" TO "anon";
GRANT ALL ON TABLE "public"."phong_tien_ich" TO "authenticated";
GRANT ALL ON TABLE "public"."phong_tien_ich" TO "service_role";



GRANT ALL ON TABLE "public"."phu_luc_hop_dong" TO "anon";
GRANT ALL ON TABLE "public"."phu_luc_hop_dong" TO "authenticated";
GRANT ALL ON TABLE "public"."phu_luc_hop_dong" TO "service_role";



GRANT ALL ON TABLE "public"."refresh_token" TO "anon";
GRANT ALL ON TABLE "public"."refresh_token" TO "authenticated";
GRANT ALL ON TABLE "public"."refresh_token" TO "service_role";



GRANT ALL ON TABLE "public"."su_co" TO "anon";
GRANT ALL ON TABLE "public"."su_co" TO "authenticated";
GRANT ALL ON TABLE "public"."su_co" TO "service_role";



GRANT ALL ON TABLE "public"."tang" TO "anon";
GRANT ALL ON TABLE "public"."tang" TO "authenticated";
GRANT ALL ON TABLE "public"."tang" TO "service_role";



GRANT ALL ON TABLE "public"."thanh_toan" TO "anon";
GRANT ALL ON TABLE "public"."thanh_toan" TO "authenticated";
GRANT ALL ON TABLE "public"."thanh_toan" TO "service_role";



GRANT ALL ON TABLE "public"."thanh_vien_hop_dong" TO "anon";
GRANT ALL ON TABLE "public"."thanh_vien_hop_dong" TO "authenticated";
GRANT ALL ON TABLE "public"."thanh_vien_hop_dong" TO "service_role";



GRANT ALL ON TABLE "public"."thong_bao" TO "anon";
GRANT ALL ON TABLE "public"."thong_bao" TO "authenticated";
GRANT ALL ON TABLE "public"."thong_bao" TO "service_role";



GRANT ALL ON TABLE "public"."thong_bao_nguoi_nhan" TO "anon";
GRANT ALL ON TABLE "public"."thong_bao_nguoi_nhan" TO "authenticated";
GRANT ALL ON TABLE "public"."thong_bao_nguoi_nhan" TO "service_role";



GRANT ALL ON TABLE "public"."tien_ich" TO "anon";
GRANT ALL ON TABLE "public"."tien_ich" TO "authenticated";
GRANT ALL ON TABLE "public"."tien_ich" TO "service_role";



GRANT ALL ON TABLE "public"."v_so_do_toa_nha" TO "anon";
GRANT ALL ON TABLE "public"."v_so_do_toa_nha" TO "authenticated";
GRANT ALL ON TABLE "public"."v_so_do_toa_nha" TO "service_role";



GRANT ALL ON TABLE "public"."v_thong_ke_toa_nha" TO "anon";
GRANT ALL ON TABLE "public"."v_thong_ke_toa_nha" TO "authenticated";
GRANT ALL ON TABLE "public"."v_thong_ke_toa_nha" TO "service_role";



GRANT ALL ON TABLE "public"."vai_tro" TO "anon";
GRANT ALL ON TABLE "public"."vai_tro" TO "authenticated";
GRANT ALL ON TABLE "public"."vai_tro" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































