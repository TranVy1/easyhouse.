CREATE TABLE IF NOT EXISTS public.debt_reminder_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    hoa_don_id uuid NOT NULL REFERENCES public.hoa_don(id) ON DELETE CASCADE,
    reminder_type varchar(50) NOT NULL,
    channel varchar(30) NOT NULL,
    recipient_id uuid NULL REFERENCES public.nguoi_dung(id) ON DELETE SET NULL,
    recipient_contact varchar(255),
    status varchar(30) NOT NULL DEFAULT 'SENT',
    error_message text,
    sent_at timestamptz NOT NULL DEFAULT now(),
    UNIQUE (hoa_don_id, reminder_type, channel, recipient_contact)
);
