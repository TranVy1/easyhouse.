CREATE TABLE IF NOT EXISTS public.contract_signature (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hop_dong_id uuid NOT NULL REFERENCES public.hop_dong(id) ON DELETE CASCADE,
    signer_id uuid NULL REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    signer_role varchar(30) NOT NULL,
    signature_image_url text,
    signed_at timestamptz NOT NULL DEFAULT now(),
    ip_address varchar(80),
    user_agent text
);

ALTER TABLE public.hop_dong
ADD COLUMN IF NOT EXISTS pdf_url text,
ADD COLUMN IF NOT EXISTS signed_pdf_url text,
ADD COLUMN IF NOT EXISTS tenant_signed_at timestamptz,
ADD COLUMN IF NOT EXISTS landlord_signed_at timestamptz,
ADD COLUMN IF NOT EXISTS signature_status varchar(30) DEFAULT 'UNSIGNED';
