-- Generic, idempotent delivery record for contract/checkout notification rules.
CREATE TABLE IF NOT EXISTS public.notification_delivery (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    aggregate_type varchar(64) NOT NULL,
    aggregate_id uuid NOT NULL,
    rule_code varchar(128) NOT NULL,
    scheduled_for date NOT NULL,
    channel varchar(32) NOT NULL,
    recipient_id uuid NOT NULL,
    status varchar(16) NOT NULL DEFAULT 'PENDING',
    error_message text,
    tao_luc timestamptz NOT NULL DEFAULT now(),
    cap_nhat_luc timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT uq_notification_delivery_rule UNIQUE (aggregate_type, aggregate_id, rule_code, scheduled_for, channel, recipient_id)
);
CREATE INDEX IF NOT EXISTS idx_notification_delivery_aggregate
    ON public.notification_delivery (aggregate_type, aggregate_id, scheduled_for DESC);
