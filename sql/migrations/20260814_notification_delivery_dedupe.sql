-- One business reminder delivery per invoice/rule/channel/recipient.
-- Retry reuses the existing row by moving FAILED -> PENDING -> SENT.

DELETE FROM public.debt_reminder_log older
USING public.debt_reminder_log newer
WHERE older.hoa_don_id = newer.hoa_don_id
  AND older.reminder_type = newer.reminder_type
  AND older.channel = newer.channel
  AND COALESCE(older.recipient_contact, '') = COALESCE(newer.recipient_contact, '')
  AND (older.sent_at, older.id) < (newer.sent_at, newer.id);

CREATE UNIQUE INDEX IF NOT EXISTS uq_debt_reminder_delivery
    ON public.debt_reminder_log (hoa_don_id, reminder_type, channel, COALESCE(recipient_contact, ''));
