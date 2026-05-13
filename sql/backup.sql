


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


CREATE TYPE "public"."loai_doi_tuong_media" AS ENUM (
    'USER',
    'MOTEL',
    'ROOM',
    'CONTRACT',
    'INVOICE',
    'MAINTENANCE',
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
    'OTHER'
);


ALTER TYPE "public"."loai_muc_hoa_don" OWNER TO "postgres";


CREATE TYPE "public"."loai_su_co_enum" AS ENUM (
    'dien_nuoc',
    'noi_that',
    've_sinh',
    'an_ninh',
    'khac'
);


ALTER TYPE "public"."loai_su_co_enum" OWNER TO "postgres";


CREATE TYPE "public"."loai_tinh_phi" AS ENUM (
    'PER_METER',
    'PER_PERSON',
    'PER_ROOM'
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


CREATE TYPE "public"."room_status" AS ENUM (
    'AVAILABLE',
    'RENTED',
    'MAINTENANCE'
);


ALTER TYPE "public"."room_status" OWNER TO "postgres";


CREATE TYPE "public"."trang_thai_coc_hop_dong" AS ENUM (
    'KEPT',
    'REFUNDED',
    'DEDUCTED'
);


ALTER TYPE "public"."trang_thai_coc_hop_dong" OWNER TO "postgres";


CREATE TYPE "public"."trang_thai_dat_coc" AS ENUM (
    'PENDING',
    'COMPLETED',
    'REFUNDED',
    'FORFEITED'
);


ALTER TYPE "public"."trang_thai_dat_coc" OWNER TO "postgres";


CREATE TYPE "public"."trang_thai_hoa_don" AS ENUM (
    'UNPAID',
    'PARTIAL',
    'PAID'
);


ALTER TYPE "public"."trang_thai_hoa_don" OWNER TO "postgres";


CREATE TYPE "public"."trang_thai_hop_dong" AS ENUM (
    'PENDING',
    'ACTIVE',
    'EXPIRED',
    'TERMINATED'
);


ALTER TYPE "public"."trang_thai_hop_dong" OWNER TO "postgres";


CREATE TYPE "public"."trang_thai_lich_hen" AS ENUM (
    'PENDING',
    'CONFIRMED',
    'CANCELLED',
    'COMPLETED'
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
    'MAINTENANCE'
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


CREATE OR REPLACE FUNCTION "public"."cap_nhat_thoi_gian"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$ BEGIN NEW.cap_nhat_luc = CURRENT_TIMESTAMP;
RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."cap_nhat_thoi_gian"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."cap_nhat_trang_thai_hoa_don"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE tong_da_tra DECIMAL(15, 2);
tong_can_tra DECIMAL(15, 2);
trang_thai_cu trang_thai_hoa_don;
trang_thai_moi trang_thai_hoa_don;
BEGIN IF NEW.trang_thai != 'SUCCESS' THEN RETURN NEW;
END IF;
SELECT COALESCE(SUM(so_tien), 0) INTO tong_da_tra
FROM thanh_toan
WHERE hoa_don_id = NEW.hoa_don_id
    AND trang_thai = 'SUCCESS';
SELECT tong_tien,
    trang_thai INTO tong_can_tra,
    trang_thai_cu
FROM hoa_don
WHERE id = NEW.hoa_don_id;
IF tong_da_tra >= tong_can_tra THEN trang_thai_moi := 'PAID';
ELSIF tong_da_tra > 0 THEN trang_thai_moi := 'PARTIAL';
ELSE trang_thai_moi := 'UNPAID';
END IF;
UPDATE hoa_don
SET da_tra = tong_da_tra,
    trang_thai = trang_thai_moi,
    cap_nhat_luc = CURRENT_TIMESTAMP
WHERE id = NEW.hoa_don_id;
IF trang_thai_cu != trang_thai_moi THEN
INSERT INTO lich_su_hoa_don (
        hoa_don_id,
        trang_thai_truoc,
        trang_thai_moi,
        ghi_chu
    )
VALUES (
        NEW.hoa_don_id,
        trang_thai_cu,
        trang_thai_moi,
        'He thong tu dong cap nhat'
    );
END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."cap_nhat_trang_thai_hoa_don"() OWNER TO "postgres";


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


CREATE TABLE IF NOT EXISTS "public"."cau_hinh_gia" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "nha_tro_id" "uuid",
    "hieu_luc_tu" "date" NOT NULL,
    "gia_dien" numeric(15,2) NOT NULL,
    "loai_tinh_nuoc" "public"."loai_tinh_phi" DEFAULT 'PER_METER'::"public"."loai_tinh_phi",
    "gia_nuoc" numeric(15,2) NOT NULL,
    "loai_tinh_dich_vu" "public"."loai_tinh_phi" DEFAULT 'PER_PERSON'::"public"."loai_tinh_phi",
    "gia_dich_vu" numeric(15,2) NOT NULL,
    "loai_tinh_internet" "public"."loai_tinh_phi" DEFAULT 'PER_ROOM'::"public"."loai_tinh_phi",
    "gia_internet" numeric(15,2) NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "cap_nhat_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."cau_hinh_gia" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."chi_so_dien_nuoc" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "phong_id" "uuid",
    "ngay_ghi" "date" NOT NULL,
    "chi_so_dien_cu" integer NOT NULL,
    "chi_so_dien_moi" integer NOT NULL,
    "chi_so_nuoc_cu" integer NOT NULL,
    "chi_so_nuoc_moi" integer NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "cap_nhat_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "check_dien" CHECK (("chi_so_dien_moi" >= "chi_so_dien_cu")),
    CONSTRAINT "check_nuoc" CHECK (("chi_so_nuoc_moi" >= "chi_so_nuoc_cu"))
);


ALTER TABLE "public"."chi_so_dien_nuoc" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."chi_tiet_hoa_don" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "hoa_don_id" "uuid",
    "loai" "public"."loai_muc_hoa_don" NOT NULL,
    "mo_ta" character varying(255),
    "so_luong" numeric(10,2) NOT NULL,
    "don_gia" numeric(15,2) NOT NULL,
    "thanh_tien" numeric(15,2) NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
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
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "phong_id" "uuid",
    "nguoi_dung_id" "uuid",
    "hop_dong_id" "uuid",
    "so_tien_coc" numeric(15,2) NOT NULL,
    "ngay_dat_coc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "ngay_du_kien_vao" "date",
    "trang_thai" "public"."trang_thai_dat_coc" DEFAULT 'PENDING'::"public"."trang_thai_dat_coc",
    "ghi_chu" "text",
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "cap_nhat_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."dat_coc_phong" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."email_verification_token" (
    "id" "uuid" NOT NULL,
    "het_han_luc" timestamp(6) with time zone NOT NULL,
    "tao_luc" timestamp(6) with time zone,
    "token" character varying(255) NOT NULL,
    "used" boolean NOT NULL,
    "nguoi_dung_id" "uuid" NOT NULL
);


ALTER TABLE "public"."email_verification_token" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."file_media" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "doi_tuong_id" "uuid" NOT NULL,
    "loai_doi_tuong" "public"."loai_doi_tuong_media" NOT NULL,
    "duong_dan" "text" NOT NULL,
    "ma_cloudinary" character varying(255),
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."file_media" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."hoa_don" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "phong_id" "uuid",
    "hop_dong_id" "uuid",
    "khach_thue_id" "uuid",
    "thang_hoa_don" "date" NOT NULL,
    "tong_tien" numeric(15,2) NOT NULL,
    "da_tra" numeric(15,2) DEFAULT 0 NOT NULL,
    "trang_thai" "public"."trang_thai_hoa_don" DEFAULT 'UNPAID'::"public"."trang_thai_hoa_don",
    "han_tra" "date" NOT NULL,
    "ghi_chu" "text",
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "cap_nhat_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "xoa_luc" timestamp with time zone
);


ALTER TABLE "public"."hoa_don" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."hop_dong" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "phong_id" "uuid",
    "khach_thue_id" "uuid",
    "ngay_bat_dau" "date" NOT NULL,
    "ngay_ket_thuc" "date" NOT NULL,
    "gia_thue_hop_dong" numeric(15,2) NOT NULL,
    "tien_coc" numeric(15,2) DEFAULT 0 NOT NULL,
    "trang_thai_coc" "public"."trang_thai_coc_hop_dong" DEFAULT 'KEPT'::"public"."trang_thai_coc_hop_dong",
    "so_tien_hoan_coc" numeric(15,2) DEFAULT 0,
    "ngay_hoan_coc" timestamp with time zone,
    "trang_thai" character varying(255) DEFAULT 'PENDING'::"public"."trang_thai_hop_dong",
    "noi_dung_hop_dong" "text",
    "file_pdf" "text",
    "chu_ky_chu_tro" "text",
    "chu_ky_khach_thue" "text",
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "cap_nhat_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "xoa_luc" timestamp with time zone,
    "chi_so_dien_ban_dau" integer,
    "chi_so_nuoc_ban_dau" integer,
    "chu_ky_thanh_toan" character varying(50),
    "dieu_khoan" "text",
    "file_hop_dong" character varying(255),
    "gia_dien" numeric(10,2),
    "gia_nuoc" numeric(10,2),
    "khach_thue_ids" "jsonb",
    "ma_hop_dong" character varying(100) NOT NULL,
    "ngay_thanh_toan" integer,
    "phi_dich_vu" "jsonb",
    CONSTRAINT "check_ngay" CHECK (("ngay_ket_thuc" > "ngay_bat_dau"))
);


ALTER TABLE "public"."hop_dong" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."khach_thue" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "nguoi_dung_id" "uuid",
    "so_cccd" character varying(50) NOT NULL,
    "lien_he_khan_cap" character varying(255),
    "ngay_sinh" "date",
    "dia_chi_thuong_tru" character varying(255),
    "nghe_nghiep" character varying(255),
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "cap_nhat_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "xoa_luc" timestamp with time zone,
    "anh_cccd" "jsonb",
    "email" character varying(255),
    "gioi_tinh" character varying(20),
    "mat_khau" character varying(255),
    "que_quan" character varying(255),
    "trang_thai" character varying(50),
    "ho_ten" character varying(255),
    "so_dien_thoai" character varying(20)
);


ALTER TABLE "public"."khach_thue" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."lich_hen" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "phong_id" "uuid",
    "nguoi_dung_id" "uuid",
    "ngay_hen" timestamp with time zone NOT NULL,
    "trang_thai" "public"."trang_thai_lich_hen" DEFAULT 'PENDING'::"public"."trang_thai_lich_hen",
    "ghi_chu" "text",
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "cap_nhat_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."lich_hen" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."lich_su_hoa_don" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "hoa_don_id" "uuid",
    "trang_thai_truoc" "public"."trang_thai_hoa_don",
    "trang_thai_moi" "public"."trang_thai_hoa_don" NOT NULL,
    "nguoi_thay_doi" "uuid",
    "ghi_chu" "text",
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."lich_su_hoa_don" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."nguoi_dung" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "email" character varying(255) NOT NULL,
    "mat_khau" character varying(255) NOT NULL,
    "ho_ten" character varying(255) NOT NULL,
    "so_dien_thoai" character varying(20),
    "anh_dai_dien" "text",
    "ngay_sinh" "date",
    "gioi_tinh" character varying(10),
    "trang_thai" character varying(255) DEFAULT 'ACTIVE'::"public"."trang_thai_nguoi_dung",
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "cap_nhat_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "xoa_luc" timestamp with time zone
);


ALTER TABLE "public"."nguoi_dung" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."nguoi_dung_vai_tro" (
    "nguoi_dung_id" "uuid" NOT NULL,
    "vai_tro_id" "uuid" NOT NULL
);


ALTER TABLE "public"."nguoi_dung_vai_tro" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."nha_tro" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "chu_tro_id" "uuid",
    "ten" character varying(255) NOT NULL,
    "dia_chi" "text" NOT NULL,
    "tinh" character varying(100) NOT NULL,
    "huyen" character varying(100) NOT NULL,
    "xa" character varying(100) NOT NULL,
    "mo_ta" "text",
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "cap_nhat_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "xoa_luc" timestamp with time zone,
    "tien_nghi_chung" "text",
    "duong" character varying(255),
    "phuong" character varying(100),
    "quan" character varying(100),
    "so_nha" character varying(100),
    "thanh_pho" character varying(100)
);


ALTER TABLE "public"."nha_tro" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."phong" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "nha_tro_id" "uuid",
    "ten" character varying(100) NOT NULL,
    "tang" integer,
    "dien_tich" numeric(10,2) NOT NULL,
    "so_nguoi_toi_da" integer DEFAULT 2 NOT NULL,
    "trang_thai" character varying(255) DEFAULT 'AVAILABLE'::"public"."trang_thai_phong",
    "gia_hien_tai" numeric(15,2) NOT NULL,
    "tien_coc_mac_dinh" numeric(15,2),
    "mo_ta" "text",
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "cap_nhat_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "xoa_luc" timestamp with time zone,
    "anh_phong" "jsonb",
    "tien_nghi" "jsonb"
);


ALTER TABLE "public"."phong" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."phong_tien_ich" (
    "phong_id" "uuid" NOT NULL,
    "tien_ich_id" "uuid" NOT NULL
);


ALTER TABLE "public"."phong_tien_ich" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."su_co" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "phong_id" "uuid",
    "khach_thue_id" "uuid",
    "tieu_de" character varying(255) NOT NULL,
    "mo_ta" "text" NOT NULL,
    "loai_su_co" "public"."loai_su_co_enum" DEFAULT 'khac'::"public"."loai_su_co_enum",
    "uu_tien" "public"."uu_tien_enum" DEFAULT 'trung_binh'::"public"."uu_tien_enum",
    "trang_thai" "public"."trang_thai_su_co" DEFAULT 'PENDING'::"public"."trang_thai_su_co",
    "nguoi_phu_trach" "uuid",
    "chi_phi_sua_chua" numeric(15,2),
    "ghi_chu_chu_nha" "text",
    "giai_quyet_luc" timestamp with time zone,
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "cap_nhat_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."su_co" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."thanh_toan" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "hoa_don_id" "uuid",
    "so_tien" numeric(15,2) NOT NULL,
    "ngay_thanh_toan" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "phuong_thuc_thanh_toan" character varying(50),
    "ma_tham_chieu" character varying(100),
    "trang_thai" character varying(50) DEFAULT 'SUCCESS'::"public"."trang_thai_thanh_toan",
    "nguoi_thanh_toan" "uuid",
    "ghi_chu" "text",
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."thanh_toan" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."thanh_vien_hop_dong" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "hop_dong_id" "uuid",
    "ho_ten" character varying(255) NOT NULL,
    "so_cccd" character varying(50) NOT NULL,
    "so_dien_thoai" character varying(20),
    "dang_o" boolean DEFAULT true,
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "cap_nhat_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."thanh_vien_hop_dong" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."thong_bao" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "nguoi_dung_id" "uuid",
    "tieu_de" character varying(255) NOT NULL,
    "noi_dung" "text" NOT NULL,
    "loai" character varying(50),
    "da_doc" boolean DEFAULT false,
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "cap_nhat_luc" timestamp(6) with time zone,
    "da_doc_json" "jsonb",
    "ngay_gui" timestamp(6) with time zone,
    "nguoi_gui_id" "uuid",
    "nguoi_nhan" "jsonb",
    "phong" "jsonb",
    "toa_nha_id" "uuid",
    "xoa_luc" timestamp(6) with time zone,
    "phong_ids" "jsonb"
);


ALTER TABLE "public"."thong_bao" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tien_ich" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "ten" character varying(100) NOT NULL,
    "bieu_tuong" character varying(100),
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."tien_ich" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."vai_tro" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "ten" character varying(50) NOT NULL,
    "tao_luc" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE "public"."vai_tro" OWNER TO "postgres";


ALTER TABLE ONLY "public"."cau_hinh_gia"
    ADD CONSTRAINT "cau_hinh_gia_pkey" PRIMARY KEY ("id");



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



ALTER TABLE ONLY "public"."email_verification_token"
    ADD CONSTRAINT "email_verification_token_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."file_media"
    ADD CONSTRAINT "file_media_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."hoa_don"
    ADD CONSTRAINT "hoa_don_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."hop_dong"
    ADD CONSTRAINT "hop_dong_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."khach_thue"
    ADD CONSTRAINT "khach_thue_nguoi_dung_id_key" UNIQUE ("nguoi_dung_id");



ALTER TABLE ONLY "public"."khach_thue"
    ADD CONSTRAINT "khach_thue_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."khach_thue"
    ADD CONSTRAINT "khach_thue_so_cccd_key" UNIQUE ("so_cccd");



ALTER TABLE ONLY "public"."lich_hen"
    ADD CONSTRAINT "lich_hen_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."lich_su_hoa_don"
    ADD CONSTRAINT "lich_su_hoa_don_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."nguoi_dung"
    ADD CONSTRAINT "nguoi_dung_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."nguoi_dung"
    ADD CONSTRAINT "nguoi_dung_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."nguoi_dung"
    ADD CONSTRAINT "nguoi_dung_so_dien_thoai_key" UNIQUE ("so_dien_thoai");



ALTER TABLE ONLY "public"."nguoi_dung_vai_tro"
    ADD CONSTRAINT "nguoi_dung_vai_tro_pkey" PRIMARY KEY ("nguoi_dung_id", "vai_tro_id");



ALTER TABLE ONLY "public"."nha_tro"
    ADD CONSTRAINT "nha_tro_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."phong"
    ADD CONSTRAINT "phong_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."phong_tien_ich"
    ADD CONSTRAINT "phong_tien_ich_pkey" PRIMARY KEY ("phong_id", "tien_ich_id");



ALTER TABLE ONLY "public"."su_co"
    ADD CONSTRAINT "su_co_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."thanh_toan"
    ADD CONSTRAINT "thanh_toan_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."thanh_vien_hop_dong"
    ADD CONSTRAINT "thanh_vien_hop_dong_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."thong_bao"
    ADD CONSTRAINT "thong_bao_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tien_ich"
    ADD CONSTRAINT "tien_ich_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tien_ich"
    ADD CONSTRAINT "tien_ich_ten_key" UNIQUE ("ten");



ALTER TABLE ONLY "public"."hop_dong"
    ADD CONSTRAINT "uk1gcrgca5o7t8609khe2gdgax9" UNIQUE ("ma_hop_dong");



ALTER TABLE ONLY "public"."email_verification_token"
    ADD CONSTRAINT "ukidu2ippaks8bn6vcsq62khvdu" UNIQUE ("token");



ALTER TABLE ONLY "public"."vai_tro"
    ADD CONSTRAINT "vai_tro_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."vai_tro"
    ADD CONSTRAINT "vai_tro_ten_key" UNIQUE ("ten");



CREATE INDEX "idx_cau_hinh_gia_nha_tro_id" ON "public"."cau_hinh_gia" USING "btree" ("nha_tro_id");



CREATE INDEX "idx_chi_so_phong_ngay" ON "public"."chi_so_dien_nuoc" USING "btree" ("phong_id", "ngay_ghi");



CREATE INDEX "idx_chi_tiet_hoa_don_id" ON "public"."chi_tiet_hoa_don" USING "btree" ("hoa_don_id");



CREATE INDEX "idx_dat_coc_phong_id" ON "public"."dat_coc_phong" USING "btree" ("phong_id");



CREATE INDEX "idx_file_media_doi_tuong" ON "public"."file_media" USING "btree" ("doi_tuong_id", "loai_doi_tuong");



CREATE INDEX "idx_hoa_don_hop_dong_id" ON "public"."hoa_don" USING "btree" ("hop_dong_id");



CREATE INDEX "idx_hoa_don_khach_thue_id" ON "public"."hoa_don" USING "btree" ("khach_thue_id");



CREATE INDEX "idx_hoa_don_phong_id" ON "public"."hoa_don" USING "btree" ("phong_id");



CREATE INDEX "idx_hoa_don_thang" ON "public"."hoa_don" USING "btree" ("thang_hoa_don");



CREATE INDEX "idx_hoa_don_trang_thai" ON "public"."hoa_don" USING "btree" ("trang_thai");



CREATE INDEX "idx_hop_dong_khach_thue_id" ON "public"."hop_dong" USING "btree" ("khach_thue_id");



CREATE INDEX "idx_hop_dong_phong_id" ON "public"."hop_dong" USING "btree" ("phong_id");



CREATE INDEX "idx_nha_tro_chu_tro_id" ON "public"."nha_tro" USING "btree" ("chu_tro_id");



CREATE INDEX "idx_phong_nha_tro_id" ON "public"."phong" USING "btree" ("nha_tro_id");



CREATE INDEX "idx_phong_trang_thai" ON "public"."phong" USING "btree" ("trang_thai");



CREATE INDEX "idx_su_co_loai" ON "public"."su_co" USING "btree" ("loai_su_co");



CREATE INDEX "idx_su_co_phong_id" ON "public"."su_co" USING "btree" ("phong_id");



CREATE INDEX "idx_su_co_trang_thai" ON "public"."su_co" USING "btree" ("trang_thai");



CREATE INDEX "idx_su_co_uu_tien" ON "public"."su_co" USING "btree" ("uu_tien");



CREATE INDEX "idx_thanh_toan_hoa_don_id" ON "public"."thanh_toan" USING "btree" ("hoa_don_id");



CREATE INDEX "idx_thanh_vien_hop_dong_id" ON "public"."thanh_vien_hop_dong" USING "btree" ("hop_dong_id");



CREATE INDEX "idx_thong_bao_nguoi_dung_id" ON "public"."thong_bao" USING "btree" ("nguoi_dung_id");



CREATE OR REPLACE TRIGGER "trg_cau_hinh_gia_cap_nhat" BEFORE UPDATE ON "public"."cau_hinh_gia" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_chi_so_cap_nhat" BEFORE UPDATE ON "public"."chi_so_dien_nuoc" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_chu_tro_cap_nhat" BEFORE UPDATE ON "public"."chu_tro" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_dat_coc_cap_nhat" BEFORE UPDATE ON "public"."dat_coc_phong" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_hoa_don_cap_nhat" BEFORE UPDATE ON "public"."hoa_don" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_hop_dong_cap_nhat" BEFORE UPDATE ON "public"."hop_dong" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_khach_thue_cap_nhat" BEFORE UPDATE ON "public"."khach_thue" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_lich_hen_cap_nhat" BEFORE UPDATE ON "public"."lich_hen" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_nguoi_dung_cap_nhat" BEFORE UPDATE ON "public"."nguoi_dung" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_nha_tro_cap_nhat" BEFORE UPDATE ON "public"."nha_tro" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_phong_cap_nhat" BEFORE UPDATE ON "public"."phong" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_sau_thanh_toan" AFTER INSERT OR UPDATE ON "public"."thanh_toan" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_trang_thai_hoa_don"();



CREATE OR REPLACE TRIGGER "trg_su_co_cap_nhat" BEFORE UPDATE ON "public"."su_co" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



CREATE OR REPLACE TRIGGER "trg_thanh_vien_cap_nhat" BEFORE UPDATE ON "public"."thanh_vien_hop_dong" FOR EACH ROW EXECUTE FUNCTION "public"."cap_nhat_thoi_gian"();



ALTER TABLE ONLY "public"."cau_hinh_gia"
    ADD CONSTRAINT "cau_hinh_gia_nha_tro_id_fkey" FOREIGN KEY ("nha_tro_id") REFERENCES "public"."nha_tro"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."chi_so_dien_nuoc"
    ADD CONSTRAINT "chi_so_dien_nuoc_phong_id_fkey" FOREIGN KEY ("phong_id") REFERENCES "public"."phong"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."chi_tiet_hoa_don"
    ADD CONSTRAINT "chi_tiet_hoa_don_hoa_don_id_fkey" FOREIGN KEY ("hoa_don_id") REFERENCES "public"."hoa_don"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."chu_tro"
    ADD CONSTRAINT "chu_tro_nguoi_dung_id_fkey" FOREIGN KEY ("nguoi_dung_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."dat_coc_phong"
    ADD CONSTRAINT "dat_coc_phong_nguoi_dung_id_fkey" FOREIGN KEY ("nguoi_dung_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."dat_coc_phong"
    ADD CONSTRAINT "dat_coc_phong_phong_id_fkey" FOREIGN KEY ("phong_id") REFERENCES "public"."phong"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."email_verification_token"
    ADD CONSTRAINT "fk13hft1rs4pds05ytufr3dg2te" FOREIGN KEY ("nguoi_dung_id") REFERENCES "public"."nguoi_dung"("id");



ALTER TABLE ONLY "public"."dat_coc_phong"
    ADD CONSTRAINT "fk_dat_coc_hop_dong" FOREIGN KEY ("hop_dong_id") REFERENCES "public"."hop_dong"("id") ON DELETE SET NULL;



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
    ADD CONSTRAINT "khach_thue_nguoi_dung_id_fkey" FOREIGN KEY ("nguoi_dung_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."lich_hen"
    ADD CONSTRAINT "lich_hen_nguoi_dung_id_fkey" FOREIGN KEY ("nguoi_dung_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."lich_hen"
    ADD CONSTRAINT "lich_hen_phong_id_fkey" FOREIGN KEY ("phong_id") REFERENCES "public"."phong"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."lich_su_hoa_don"
    ADD CONSTRAINT "lich_su_hoa_don_hoa_don_id_fkey" FOREIGN KEY ("hoa_don_id") REFERENCES "public"."hoa_don"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."lich_su_hoa_don"
    ADD CONSTRAINT "lich_su_hoa_don_nguoi_thay_doi_fkey" FOREIGN KEY ("nguoi_thay_doi") REFERENCES "public"."nguoi_dung"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."nguoi_dung_vai_tro"
    ADD CONSTRAINT "nguoi_dung_vai_tro_nguoi_dung_id_fkey" FOREIGN KEY ("nguoi_dung_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."nguoi_dung_vai_tro"
    ADD CONSTRAINT "nguoi_dung_vai_tro_vai_tro_id_fkey" FOREIGN KEY ("vai_tro_id") REFERENCES "public"."vai_tro"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."nha_tro"
    ADD CONSTRAINT "nha_tro_chu_tro_id_fkey" FOREIGN KEY ("chu_tro_id") REFERENCES "public"."chu_tro"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."phong"
    ADD CONSTRAINT "phong_nha_tro_id_fkey" FOREIGN KEY ("nha_tro_id") REFERENCES "public"."nha_tro"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."phong_tien_ich"
    ADD CONSTRAINT "phong_tien_ich_phong_id_fkey" FOREIGN KEY ("phong_id") REFERENCES "public"."phong"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."phong_tien_ich"
    ADD CONSTRAINT "phong_tien_ich_tien_ich_id_fkey" FOREIGN KEY ("tien_ich_id") REFERENCES "public"."tien_ich"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."su_co"
    ADD CONSTRAINT "su_co_khach_thue_id_fkey" FOREIGN KEY ("khach_thue_id") REFERENCES "public"."khach_thue"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."su_co"
    ADD CONSTRAINT "su_co_nguoi_phu_trach_fkey" FOREIGN KEY ("nguoi_phu_trach") REFERENCES "public"."nguoi_dung"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."su_co"
    ADD CONSTRAINT "su_co_phong_id_fkey" FOREIGN KEY ("phong_id") REFERENCES "public"."phong"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."thanh_toan"
    ADD CONSTRAINT "thanh_toan_hoa_don_id_fkey" FOREIGN KEY ("hoa_don_id") REFERENCES "public"."hoa_don"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."thanh_toan"
    ADD CONSTRAINT "thanh_toan_nguoi_thanh_toan_fkey" FOREIGN KEY ("nguoi_thanh_toan") REFERENCES "public"."nguoi_dung"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."thanh_vien_hop_dong"
    ADD CONSTRAINT "thanh_vien_hop_dong_hop_dong_id_fkey" FOREIGN KEY ("hop_dong_id") REFERENCES "public"."hop_dong"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."thong_bao"
    ADD CONSTRAINT "thong_bao_nguoi_dung_id_fkey" FOREIGN KEY ("nguoi_dung_id") REFERENCES "public"."nguoi_dung"("id") ON DELETE CASCADE;



ALTER TABLE "public"."cau_hinh_gia" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."chi_so_dien_nuoc" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."chi_tiet_hoa_don" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."chu_tro" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."dat_coc_phong" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."file_media" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."hoa_don" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."hop_dong" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."khach_thue" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."lich_hen" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."lich_su_hoa_don" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."nguoi_dung" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."nguoi_dung_vai_tro" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."nha_tro" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."phong" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."phong_tien_ich" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."su_co" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."thanh_toan" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."thanh_vien_hop_dong" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."thong_bao" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."tien_ich" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."vai_tro" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";






















































































































































GRANT ALL ON FUNCTION "public"."cap_nhat_thoi_gian"() TO "anon";
GRANT ALL ON FUNCTION "public"."cap_nhat_thoi_gian"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."cap_nhat_thoi_gian"() TO "service_role";



GRANT ALL ON FUNCTION "public"."cap_nhat_trang_thai_hoa_don"() TO "anon";
GRANT ALL ON FUNCTION "public"."cap_nhat_trang_thai_hoa_don"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."cap_nhat_trang_thai_hoa_don"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_invoice_status_on_payment"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_invoice_status_on_payment"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_invoice_status_on_payment"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_updated_at_column"() TO "service_role";


















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



GRANT ALL ON TABLE "public"."nguoi_dung" TO "anon";
GRANT ALL ON TABLE "public"."nguoi_dung" TO "authenticated";
GRANT ALL ON TABLE "public"."nguoi_dung" TO "service_role";



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



GRANT ALL ON TABLE "public"."su_co" TO "anon";
GRANT ALL ON TABLE "public"."su_co" TO "authenticated";
GRANT ALL ON TABLE "public"."su_co" TO "service_role";



GRANT ALL ON TABLE "public"."thanh_toan" TO "anon";
GRANT ALL ON TABLE "public"."thanh_toan" TO "authenticated";
GRANT ALL ON TABLE "public"."thanh_toan" TO "service_role";



GRANT ALL ON TABLE "public"."thanh_vien_hop_dong" TO "anon";
GRANT ALL ON TABLE "public"."thanh_vien_hop_dong" TO "authenticated";
GRANT ALL ON TABLE "public"."thanh_vien_hop_dong" TO "service_role";



GRANT ALL ON TABLE "public"."thong_bao" TO "anon";
GRANT ALL ON TABLE "public"."thong_bao" TO "authenticated";
GRANT ALL ON TABLE "public"."thong_bao" TO "service_role";



GRANT ALL ON TABLE "public"."tien_ich" TO "anon";
GRANT ALL ON TABLE "public"."tien_ich" TO "authenticated";
GRANT ALL ON TABLE "public"."tien_ich" TO "service_role";



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































