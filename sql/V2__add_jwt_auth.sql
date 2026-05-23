-- Xóa ràng buộc ngoại với auth.users nếu đang có
ALTER TABLE public.nguoi_dung DROP CONSTRAINT IF EXISTS nguoi_dung_id_fkey;

-- Thêm trường mật khẩu
ALTER TABLE public.nguoi_dung ADD COLUMN IF NOT EXISTS mat_khau varchar(255);
-- Nếu id trước đây không có default, thêm default để có thể tự gen UUID
ALTER TABLE public.nguoi_dung ALTER COLUMN id SET DEFAULT gen_random_uuid();

-- Bảng Email Verification Token
CREATE TABLE IF NOT EXISTS public.email_verification_token (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nguoi_dung_id uuid NOT NULL REFERENCES public.nguoi_dung(id) ON DELETE CASCADE,
    token varchar(255) NOT NULL UNIQUE,
    ngay_het_han timestamptz NOT NULL,
    tao_luc timestamptz NOT NULL DEFAULT now()
);

-- Bảng Refresh Token
CREATE TABLE IF NOT EXISTS public.refresh_token (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    nguoi_dung_id uuid NOT NULL REFERENCES public.nguoi_dung(id) ON DELETE CASCADE,
    token varchar(255) NOT NULL UNIQUE,
    ngay_het_han timestamptz NOT NULL,
    tao_luc timestamptz NOT NULL DEFAULT now()
);
