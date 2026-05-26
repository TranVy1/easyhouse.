CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'trang_thai_hoa_don') THEN
    CREATE TYPE trang_thai_hoa_don AS ENUM ('UNPAID', 'PARTIAL', 'PAID', 'OVERDUE');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'loai_muc_hoa_don') THEN
    CREATE TYPE loai_muc_hoa_don AS ENUM ('ROOM', 'ELECTRICITY', 'WATER', 'SERVICE', 'INTERNET', 'GARBAGE', 'PARKING', 'MAINTENANCE', 'DEBT', 'DISCOUNT', 'OTHER', 'BALCONY', 'TRASH', 'AIR_CONDITIONER', 'WASHING_MACHINE', 'REFRIGERATOR', 'WATER_HEATER', 'BED', 'WARDROBE', 'TABLE_CHAIR', 'KITCHEN', 'KITCHEN_SHELF', 'CLEANING', 'LAUNDRY', 'SMART_LOCK', 'SECURITY_CAMERA');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'trang_thai_phong') THEN
    CREATE TYPE trang_thai_phong AS ENUM ('AVAILABLE', 'RENTED', 'MAINTENANCE');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'trang_thai_hop_dong') THEN
    CREATE TYPE trang_thai_hop_dong AS ENUM ('ACTIVE', 'EXPIRED', 'TERMINATED', 'PENDING');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'trang_thai_nguoi_dung') THEN
    CREATE TYPE trang_thai_nguoi_dung AS ENUM ('ACTIVE', 'INACTIVE', 'BANNED');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'trang_thai_su_co') THEN
    CREATE TYPE trang_thai_su_co AS ENUM ('PENDING', 'IN_PROGRESS', 'RESOLVED', 'CANCELLED');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'loai_su_co_enum') THEN
    CREATE TYPE loai_su_co_enum AS ENUM ('dien_nuoc', 'noi_that', 've_sinh', 'an_ninh', 'khac');
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'uu_tien_enum') THEN
    CREATE TYPE uu_tien_enum AS ENUM ('thap', 'trung_binh', 'cao', 'khan_cap');
  END IF;
END $$;
