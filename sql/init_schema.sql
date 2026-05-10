-- ====================================================================================
-- QUAN LY PHONG TRO - POSTGRESQL SCHEMA (Chuan hoa ten cot tieng Viet khong dau)
-- ====================================================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- ==========================================
-- ENUMS
-- ==========================================
DO $$ BEGIN -- trang_thai_nguoi_dung
IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'trang_thai_nguoi_dung'
        AND n.nspname = 'public'
) THEN CREATE TYPE public.trang_thai_nguoi_dung AS ENUM ('ACTIVE', 'INACTIVE', 'BANNED');
END IF;
-- trang_thai_phong
IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'trang_thai_phong'
        AND n.nspname = 'public'
) THEN CREATE TYPE public.trang_thai_phong AS ENUM ('AVAILABLE', 'RENTED', 'MAINTENANCE');
END IF;
-- trang_thai_hop_dong
IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'trang_thai_hop_dong'
        AND n.nspname = 'public'
) THEN CREATE TYPE public.trang_thai_hop_dong AS ENUM ('PENDING', 'ACTIVE', 'EXPIRED', 'TERMINATED');
END IF;
-- trang_thai_coc_hop_dong
IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'trang_thai_coc_hop_dong'
        AND n.nspname = 'public'
) THEN CREATE TYPE public.trang_thai_coc_hop_dong AS ENUM ('KEPT', 'REFUNDED', 'DEDUCTED');
END IF;
-- trang_thai_dat_coc
IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'trang_thai_dat_coc'
        AND n.nspname = 'public'
) THEN CREATE TYPE public.trang_thai_dat_coc AS ENUM ('PENDING', 'COMPLETED', 'REFUNDED', 'FORFEITED');
END IF;
-- trang_thai_hoa_don
IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'trang_thai_hoa_don'
        AND n.nspname = 'public'
) THEN CREATE TYPE public.trang_thai_hoa_don AS ENUM ('UNPAID', 'PARTIAL', 'PAID');
END IF;
-- trang_thai_lich_hen
IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'trang_thai_lich_hen'
        AND n.nspname = 'public'
) THEN CREATE TYPE public.trang_thai_lich_hen AS ENUM ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED');
END IF;
-- trang_thai_su_co
IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'trang_thai_su_co'
        AND n.nspname = 'public'
) THEN CREATE TYPE public.trang_thai_su_co AS ENUM ('PENDING', 'IN_PROGRESS', 'RESOLVED', 'CANCELLED');
END IF;
-- trang_thai_thanh_toan
IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'trang_thai_thanh_toan'
        AND n.nspname = 'public'
) THEN CREATE TYPE public.trang_thai_thanh_toan AS ENUM ('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED');
END IF;
-- loai_muc_hoa_don
IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'loai_muc_hoa_don'
        AND n.nspname = 'public'
) THEN CREATE TYPE public.loai_muc_hoa_don AS ENUM (
    'ROOM',
    'ELECTRICITY',
    'WATER',
    'SERVICE',
    'INTERNET',
    'GARBAGE',
    'PARKING',
    'OTHER'
);
END IF;
-- loai_doi_tuong_media
IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'loai_doi_tuong_media'
        AND n.nspname = 'public'
) THEN CREATE TYPE public.loai_doi_tuong_media AS ENUM (
    'USER',
    'MOTEL',
    'ROOM',
    'CONTRACT',
    'INVOICE',
    'MAINTENANCE',
    'APPOINTMENT',
    'OTHER'
);
END IF;
-- loai_tinh_phi
IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'loai_tinh_phi'
        AND n.nspname = 'public'
) THEN CREATE TYPE public.loai_tinh_phi AS ENUM ('PER_METER', 'PER_PERSON', 'PER_ROOM');
END IF;
-- loai_su_co_enum
IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'loai_su_co_enum'
        AND n.nspname = 'public'
) THEN CREATE TYPE public.loai_su_co_enum AS ENUM (
    'dien_nuoc',
    'noi_that',
    've_sinh',
    'an_ninh',
    'khac'
);
END IF;
-- uu_tien_enum
IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
    WHERE t.typname = 'uu_tien_enum'
        AND n.nspname = 'public'
) THEN CREATE TYPE public.uu_tien_enum AS ENUM ('thap', 'trung_binh', 'cao', 'khan_cap');
END IF;
END $$;
-- ==========================================
-- 1. NGUOI DUNG & PHAN QUYEN
-- ==========================================
CREATE TABLE nguoi_dung (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    mat_khau VARCHAR(255) NOT NULL,
    ho_ten VARCHAR(255) NOT NULL,
    so_dien_thoai VARCHAR(20) UNIQUE,
    anh_dai_dien TEXT,
    ngay_sinh DATE,
    gioi_tinh VARCHAR(10),
    trang_thai trang_thai_nguoi_dung DEFAULT 'ACTIVE',
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    xoa_luc TIMESTAMP WITH TIME ZONE
);
CREATE TABLE vai_tro (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ten VARCHAR(50) UNIQUE NOT NULL,
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE nguoi_dung_vai_tro (
    nguoi_dung_id UUID REFERENCES nguoi_dung(id) ON DELETE CASCADE,
    vai_tro_id UUID REFERENCES vai_tro(id) ON DELETE CASCADE,
    PRIMARY KEY (nguoi_dung_id, vai_tro_id)
);
-- ==========================================
-- 2. CHU TRO
-- ==========================================
CREATE TABLE chu_tro (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nguoi_dung_id UUID UNIQUE REFERENCES nguoi_dung(id) ON DELETE CASCADE,
    ten_cong_ty VARCHAR(255),
    so_cccd VARCHAR(50) UNIQUE NOT NULL,
    ma_so_thue VARCHAR(50),
    so_tai_khoan VARCHAR(50),
    da_xac_minh BOOLEAN DEFAULT FALSE,
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    xoa_luc TIMESTAMP WITH TIME ZONE
);
-- ==========================================
-- 3. KHACH THUE
-- ==========================================
CREATE TABLE khach_thue (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nguoi_dung_id UUID UNIQUE REFERENCES nguoi_dung(id) ON DELETE CASCADE,
    so_cccd VARCHAR(50) UNIQUE NOT NULL,
    lien_he_khan_cap VARCHAR(255),
    ngay_sinh DATE,
    dia_chi_thuong_tru TEXT,
    nghe_nghiep VARCHAR(255),
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    xoa_luc TIMESTAMP WITH TIME ZONE
);
-- ==========================================
-- 4. NHA TRO & PHONG
-- ==========================================
CREATE TABLE nha_tro (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chu_tro_id UUID REFERENCES chu_tro(id) ON DELETE RESTRICT,
    ten VARCHAR(255) NOT NULL,
    dia_chi TEXT NOT NULL,
    tinh VARCHAR(100) NOT NULL,
    huyen VARCHAR(100) NOT NULL,
    xa VARCHAR(100) NOT NULL,
    mo_ta TEXT,
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    xoa_luc TIMESTAMP WITH TIME ZONE
);
CREATE INDEX idx_nha_tro_chu_tro_id ON nha_tro(chu_tro_id);
CREATE TABLE phong (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nha_tro_id UUID REFERENCES nha_tro(id) ON DELETE CASCADE,
    ten VARCHAR(100) NOT NULL,
    tang INT,
    dien_tich DECIMAL(10, 2) NOT NULL,
    so_nguoi_toi_da INT NOT NULL DEFAULT 2,
    trang_thai trang_thai_phong DEFAULT 'AVAILABLE',
    gia_hien_tai DECIMAL(15, 2) NOT NULL,
    tien_coc_mac_dinh DECIMAL(15, 2),
    mo_ta TEXT,
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    xoa_luc TIMESTAMP WITH TIME ZONE
);
CREATE INDEX idx_phong_nha_tro_id ON phong(nha_tro_id);
CREATE INDEX idx_phong_trang_thai ON phong(trang_thai);
CREATE TABLE file_media (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    doi_tuong_id UUID NOT NULL,
    loai_doi_tuong loai_doi_tuong_media NOT NULL,
    duong_dan TEXT NOT NULL,
    ma_cloudinary VARCHAR(255),
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_file_media_doi_tuong ON file_media(doi_tuong_id, loai_doi_tuong);
CREATE TABLE tien_ich (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ten VARCHAR(100) UNIQUE NOT NULL,
    bieu_tuong VARCHAR(100),
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE phong_tien_ich (
    phong_id UUID REFERENCES phong(id) ON DELETE CASCADE,
    tien_ich_id UUID REFERENCES tien_ich(id) ON DELETE CASCADE,
    PRIMARY KEY (phong_id, tien_ich_id)
);
-- ==========================================
-- 5. DAT COC & HOP DONG
-- ==========================================
CREATE TABLE dat_coc_phong (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phong_id UUID REFERENCES phong(id) ON DELETE RESTRICT,
    nguoi_dung_id UUID REFERENCES nguoi_dung(id) ON DELETE RESTRICT,
    hop_dong_id UUID,
    -- FK se them sau khi tao bang hop_dong
    so_tien_coc DECIMAL(15, 2) NOT NULL,
    ngay_dat_coc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    ngay_du_kien_vao DATE,
    trang_thai trang_thai_dat_coc DEFAULT 'PENDING',
    ghi_chu TEXT,
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_dat_coc_phong_id ON dat_coc_phong(phong_id);
CREATE TABLE hop_dong (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phong_id UUID REFERENCES phong(id) ON DELETE RESTRICT,
    khach_thue_id UUID REFERENCES khach_thue(id) ON DELETE RESTRICT,
    ngay_bat_dau DATE NOT NULL,
    ngay_ket_thuc DATE NOT NULL,
    gia_thue_hop_dong DECIMAL(15, 2) NOT NULL,
    tien_coc DECIMAL(15, 2) NOT NULL DEFAULT 0,
    trang_thai_coc trang_thai_coc_hop_dong DEFAULT 'KEPT',
    so_tien_hoan_coc DECIMAL(15, 2) DEFAULT 0,
    ngay_hoan_coc TIMESTAMP WITH TIME ZONE,
    trang_thai trang_thai_hop_dong DEFAULT 'PENDING',
    noi_dung_hop_dong TEXT,
    file_pdf TEXT,
    chu_ky_chu_tro TEXT,
    chu_ky_khach_thue TEXT,
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    xoa_luc TIMESTAMP WITH TIME ZONE,
    CONSTRAINT check_ngay CHECK (ngay_ket_thuc > ngay_bat_dau)
);
CREATE INDEX idx_hop_dong_phong_id ON hop_dong(phong_id);
CREATE INDEX idx_hop_dong_khach_thue_id ON hop_dong(khach_thue_id);
-- FK nguoc cho dat_coc_phong
ALTER TABLE dat_coc_phong
ADD CONSTRAINT fk_dat_coc_hop_dong FOREIGN KEY (hop_dong_id) REFERENCES hop_dong(id) ON DELETE
SET NULL;
CREATE TABLE thanh_vien_hop_dong (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    hop_dong_id UUID REFERENCES hop_dong(id) ON DELETE CASCADE,
    ho_ten VARCHAR(255) NOT NULL,
    so_cccd VARCHAR(50) NOT NULL,
    so_dien_thoai VARCHAR(20),
    dang_o BOOLEAN DEFAULT TRUE,
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_thanh_vien_hop_dong_id ON thanh_vien_hop_dong(hop_dong_id);
-- ==========================================
-- 6. HOA DON & THANH TOAN
-- ==========================================
CREATE TABLE cau_hinh_gia (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nha_tro_id UUID REFERENCES nha_tro(id) ON DELETE CASCADE,
    hieu_luc_tu DATE NOT NULL,
    gia_dien DECIMAL(15, 2) NOT NULL,
    loai_tinh_nuoc loai_tinh_phi DEFAULT 'PER_METER',
    gia_nuoc DECIMAL(15, 2) NOT NULL,
    loai_tinh_dich_vu loai_tinh_phi DEFAULT 'PER_PERSON',
    gia_dich_vu DECIMAL(15, 2) NOT NULL,
    loai_tinh_internet loai_tinh_phi DEFAULT 'PER_ROOM',
    gia_internet DECIMAL(15, 2) NOT NULL,
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_cau_hinh_gia_nha_tro_id ON cau_hinh_gia(nha_tro_id);
CREATE TABLE chi_so_dien_nuoc (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phong_id UUID REFERENCES phong(id) ON DELETE CASCADE,
    ngay_ghi DATE NOT NULL,
    chi_so_dien_cu INT NOT NULL,
    chi_so_dien_moi INT NOT NULL,
    chi_so_nuoc_cu INT NOT NULL,
    chi_so_nuoc_moi INT NOT NULL,
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_dien CHECK (chi_so_dien_moi >= chi_so_dien_cu),
    CONSTRAINT check_nuoc CHECK (chi_so_nuoc_moi >= chi_so_nuoc_cu)
);
CREATE INDEX idx_chi_so_phong_ngay ON chi_so_dien_nuoc(phong_id, ngay_ghi);
CREATE TABLE hoa_don (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phong_id UUID REFERENCES phong(id) ON DELETE RESTRICT,
    hop_dong_id UUID REFERENCES hop_dong(id) ON DELETE RESTRICT,
    khach_thue_id UUID REFERENCES khach_thue(id) ON DELETE RESTRICT,
    thang_hoa_don DATE NOT NULL,
    tong_tien DECIMAL(15, 2) NOT NULL,
    da_tra DECIMAL(15, 2) NOT NULL DEFAULT 0,
    trang_thai trang_thai_hoa_don DEFAULT 'UNPAID',
    han_tra DATE NOT NULL,
    ghi_chu TEXT,
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    xoa_luc TIMESTAMP WITH TIME ZONE
);
CREATE INDEX idx_hoa_don_phong_id ON hoa_don(phong_id);
CREATE INDEX idx_hoa_don_hop_dong_id ON hoa_don(hop_dong_id);
CREATE INDEX idx_hoa_don_khach_thue_id ON hoa_don(khach_thue_id);
CREATE INDEX idx_hoa_don_trang_thai ON hoa_don(trang_thai);
CREATE INDEX idx_hoa_don_thang ON hoa_don(thang_hoa_don);
CREATE TABLE chi_tiet_hoa_don (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    hoa_don_id UUID REFERENCES hoa_don(id) ON DELETE CASCADE,
    loai loai_muc_hoa_don NOT NULL,
    mo_ta VARCHAR(255),
    so_luong DECIMAL(10, 2) NOT NULL,
    don_gia DECIMAL(15, 2) NOT NULL,
    thanh_tien DECIMAL(15, 2) NOT NULL,
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_chi_tiet_hoa_don_id ON chi_tiet_hoa_don(hoa_don_id);
CREATE TABLE thanh_toan (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    hoa_don_id UUID REFERENCES hoa_don(id) ON DELETE RESTRICT,
    so_tien DECIMAL(15, 2) NOT NULL,
    ngay_thanh_toan TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    phuong_thuc_thanh_toan VARCHAR(50),
    ma_tham_chieu VARCHAR(100),
    trang_thai trang_thai_thanh_toan DEFAULT 'SUCCESS',
    nguoi_thanh_toan UUID REFERENCES nguoi_dung(id) ON DELETE
    SET NULL,
        ghi_chu TEXT,
        tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_thanh_toan_hoa_don_id ON thanh_toan(hoa_don_id);
CREATE TABLE lich_su_hoa_don (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    hoa_don_id UUID REFERENCES hoa_don(id) ON DELETE CASCADE,
    trang_thai_truoc trang_thai_hoa_don,
    trang_thai_moi trang_thai_hoa_don NOT NULL,
    nguoi_thay_doi UUID REFERENCES nguoi_dung(id) ON DELETE
    SET NULL,
        ghi_chu TEXT,
        tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
-- ==========================================
-- 7. LICH HEN XEM PHONG
-- ==========================================
CREATE TABLE lich_hen (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phong_id UUID REFERENCES phong(id) ON DELETE CASCADE,
    nguoi_dung_id UUID REFERENCES nguoi_dung(id) ON DELETE CASCADE,
    ngay_hen TIMESTAMP WITH TIME ZONE NOT NULL,
    trang_thai trang_thai_lich_hen DEFAULT 'PENDING',
    ghi_chu TEXT,
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    cap_nhat_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
-- ==========================================
-- 8. SU CO BAO TRI
-- ==========================================
CREATE TABLE su_co (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phong_id UUID REFERENCES phong(id) ON DELETE CASCADE,
    khach_thue_id UUID REFERENCES khach_thue(id) ON DELETE CASCADE,
    tieu_de VARCHAR(255) NOT NULL,
    mo_ta TEXT NOT NULL,
    loai_su_co loai_su_co_enum DEFAULT 'khac',
    uu_tien uu_tien_enum DEFAULT 'trung_binh',
    trang_thai trang_thai_su_co DEFAULT 'PENDING',
    nguoi_phu_trach UUID REFERENCES nguoi_dung(id) ON DELETE
    SET NULL,
        chi_phi_sua_chua DECIMAL(15, 2),
        ghi_chu_chu_nha TEXT,
        giai_quyet_luc TIMESTAMP WITH TIME ZONE,
        tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        cap_nhat_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_su_co_phong_id ON su_co(phong_id);
CREATE INDEX idx_su_co_trang_thai ON su_co(trang_thai);
CREATE INDEX idx_su_co_loai ON su_co(loai_su_co);
CREATE INDEX idx_su_co_uu_tien ON su_co(uu_tien);
-- ==========================================
-- 9. THONG BAO
-- ==========================================
CREATE TABLE thong_bao (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nguoi_dung_id UUID REFERENCES nguoi_dung(id) ON DELETE CASCADE,
    tieu_de VARCHAR(255) NOT NULL,
    noi_dung TEXT NOT NULL,
    loai VARCHAR(50),
    da_doc BOOLEAN DEFAULT FALSE,
    tao_luc TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_thong_bao_nguoi_dung_id ON thong_bao(nguoi_dung_id);
-- ==========================================
-- TRIGGERS & FUNCTIONS
-- ==========================================
CREATE OR REPLACE FUNCTION cap_nhat_thoi_gian() RETURNS TRIGGER AS $$ BEGIN NEW.cap_nhat_luc = CURRENT_TIMESTAMP;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_nguoi_dung_cap_nhat BEFORE
UPDATE ON nguoi_dung FOR EACH ROW EXECUTE FUNCTION cap_nhat_thoi_gian();
CREATE TRIGGER trg_chu_tro_cap_nhat BEFORE
UPDATE ON chu_tro FOR EACH ROW EXECUTE FUNCTION cap_nhat_thoi_gian();
CREATE TRIGGER trg_khach_thue_cap_nhat BEFORE
UPDATE ON khach_thue FOR EACH ROW EXECUTE FUNCTION cap_nhat_thoi_gian();
CREATE TRIGGER trg_nha_tro_cap_nhat BEFORE
UPDATE ON nha_tro FOR EACH ROW EXECUTE FUNCTION cap_nhat_thoi_gian();
CREATE TRIGGER trg_phong_cap_nhat BEFORE
UPDATE ON phong FOR EACH ROW EXECUTE FUNCTION cap_nhat_thoi_gian();
CREATE TRIGGER trg_hop_dong_cap_nhat BEFORE
UPDATE ON hop_dong FOR EACH ROW EXECUTE FUNCTION cap_nhat_thoi_gian();
CREATE TRIGGER trg_thanh_vien_cap_nhat BEFORE
UPDATE ON thanh_vien_hop_dong FOR EACH ROW EXECUTE FUNCTION cap_nhat_thoi_gian();
CREATE TRIGGER trg_dat_coc_cap_nhat BEFORE
UPDATE ON dat_coc_phong FOR EACH ROW EXECUTE FUNCTION cap_nhat_thoi_gian();
CREATE TRIGGER trg_cau_hinh_gia_cap_nhat BEFORE
UPDATE ON cau_hinh_gia FOR EACH ROW EXECUTE FUNCTION cap_nhat_thoi_gian();
CREATE TRIGGER trg_chi_so_cap_nhat BEFORE
UPDATE ON chi_so_dien_nuoc FOR EACH ROW EXECUTE FUNCTION cap_nhat_thoi_gian();
CREATE TRIGGER trg_hoa_don_cap_nhat BEFORE
UPDATE ON hoa_don FOR EACH ROW EXECUTE FUNCTION cap_nhat_thoi_gian();
CREATE TRIGGER trg_lich_hen_cap_nhat BEFORE
UPDATE ON lich_hen FOR EACH ROW EXECUTE FUNCTION cap_nhat_thoi_gian();
CREATE TRIGGER trg_su_co_cap_nhat BEFORE
UPDATE ON su_co FOR EACH ROW EXECUTE FUNCTION cap_nhat_thoi_gian();
-- Function: Tu dong cap nhat trang thai hoa don khi co thanh toan
CREATE OR REPLACE FUNCTION cap_nhat_trang_thai_hoa_don() RETURNS TRIGGER AS $$
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
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_sau_thanh_toan
AFTER
INSERT
    OR
UPDATE ON thanh_toan FOR EACH ROW EXECUTE FUNCTION cap_nhat_trang_thai_hoa_don();
-- ==========================================
-- DU LIEU MAU
-- ==========================================
INSERT INTO vai_tro (id, ten)
VALUES ('11111111-1111-1111-1111-111111111111', 'ADMIN'),
    (
        '22222222-2222-2222-2222-222222222222',
        'LANDLORD'
    ),
    ('33333333-3333-3333-3333-333333333333', 'TENANT') ON CONFLICT DO NOTHING;
INSERT INTO nguoi_dung (id, email, mat_khau, ho_ten, so_dien_thoai)
VALUES (
        '44444444-4444-4444-4444-444444444444',
        'landlord@example.com',
        'hashed_pw',
        'Nguyen Van Chu',
        '0901234567'
    ),
    (
        '66666666-6666-6666-6666-666666666666',
        'tenant@example.com',
        'hashed_pw',
        'Tran Van Khach',
        '0987654321'
    ) ON CONFLICT DO NOTHING;
INSERT INTO nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id)
VALUES (
        '44444444-4444-4444-4444-444444444444',
        '22222222-2222-2222-2222-222222222222'
    ),
    (
        '66666666-6666-6666-6666-666666666666',
        '33333333-3333-3333-3333-333333333333'
    ) ON CONFLICT DO NOTHING;
INSERT INTO chu_tro (
        id,
        nguoi_dung_id,
        so_cccd,
        ten_cong_ty,
        da_xac_minh
    )
VALUES (
        '55555555-5555-5555-5555-555555555555',
        '44444444-4444-4444-4444-444444444444',
        '012345678912',
        'Nha Tro Binh Dan',
        TRUE
    ) ON CONFLICT DO NOTHING;
INSERT INTO khach_thue (id, nguoi_dung_id, so_cccd, lien_he_khan_cap)
VALUES (
        '77777777-7777-7777-7777-777777777777',
        '66666666-6666-6666-6666-666666666666',
        '098765432109',
        '0911223344'
    ) ON CONFLICT DO NOTHING;
INSERT INTO nha_tro (id, chu_tro_id, ten, dia_chi, tinh, huyen, xa)
VALUES (
        '88888888-8888-8888-8888-888888888888',
        '55555555-5555-5555-5555-555555555555',
        'Khu Tro Hoa Binh',
        '123 Nguyen Trai',
        'Ha Noi',
        'Thanh Xuan',
        'Thanh Xuan Bac'
    ) ON CONFLICT DO NOTHING;
INSERT INTO phong (
        id,
        nha_tro_id,
        ten,
        tang,
        dien_tich,
        so_nguoi_toi_da,
        gia_hien_tai,
        trang_thai
    )
VALUES (
        '99999999-9999-9999-9999-999999999999',
        '88888888-8888-8888-8888-888888888888',
        'Phong 101',
        1,
        25.5,
        3,
        2500000,
        'AVAILABLE'
    ) ON CONFLICT DO NOTHING;
INSERT INTO cau_hinh_gia (
        id,
        nha_tro_id,
        hieu_luc_tu,
        gia_dien,
        gia_nuoc,
        gia_dich_vu,
        gia_internet
    )
VALUES (
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        '88888888-8888-8888-8888-888888888888',
        '2024-01-01',
        3500,
        20000,
        50000,
        100000
    ) ON CONFLICT DO NOTHING;