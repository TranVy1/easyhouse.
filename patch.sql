-- 1. hoa_don
ALTER TABLE hoa_don ADD COLUMN auto_generated BOOLEAN DEFAULT false;
ALTER TABLE hoa_don ADD COLUMN generation_batch_id UUID;
ALTER TABLE hoa_don ADD COLUMN source_schedule_id UUID;

-- 2. dat_coc_phong
ALTER TABLE dat_coc_phong ADD COLUMN hop_dong_id UUID;
ALTER TABLE dat_coc_phong ADD COLUMN confirmed_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE dat_coc_phong ADD COLUMN cancelled_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE dat_coc_phong ADD COLUMN nguoi_xac_nhan_id UUID;
ALTER TABLE dat_coc_phong ADD CONSTRAINT fk_dat_coc_hop_dong FOREIGN KEY (hop_dong_id) REFERENCES hop_dong(id) ON DELETE SET NULL;
ALTER TABLE dat_coc_phong ADD CONSTRAINT fk_dat_coc_nguoi_xac_nhan FOREIGN KEY (nguoi_xac_nhan_id) REFERENCES nguoi_dung(id) ON DELETE SET NULL;

-- 3. debt_reminder_log
CREATE TABLE IF NOT EXISTS debt_reminder_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hoa_don_id UUID NOT NULL,
    reminder_type VARCHAR(50) NOT NULL,
    channel VARCHAR(50) NOT NULL,
    recipient_id UUID,
    recipient_contact VARCHAR(255),
    status VARCHAR(50) NOT NULL,
    error_message TEXT,
    sent_at TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT fk_debt_reminder_hoa_don FOREIGN KEY (hoa_don_id) REFERENCES hoa_don(id) ON DELETE CASCADE,
    CONSTRAINT fk_debt_reminder_recipient FOREIGN KEY (recipient_id) REFERENCES nguoi_dung(id) ON DELETE SET NULL
);

-- 4. meter_anomaly_alert
CREATE TABLE IF NOT EXISTS meter_anomaly_alert (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chi_so_id UUID NOT NULL,
    phong_id UUID NOT NULL,
    hop_dong_id UUID,
    loai VARCHAR(50) NOT NULL,
    ky_thang INTEGER NOT NULL,
    ky_nam INTEGER NOT NULL,
    tieu_thu_hien_tai INTEGER NOT NULL,
    tieu_thu_trung_binh NUMERIC(10, 2),
    ty_le_tang NUMERIC(10, 2),
    muc_do VARCHAR(50) NOT NULL,
    ly_do TEXT NOT NULL,
    trang_thai VARCHAR(50) NOT NULL DEFAULT 'OPEN',
    resolved_at TIMESTAMP WITH TIME ZONE,
    resolved_by UUID,
    tao_luc TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT fk_anomaly_chi_so FOREIGN KEY (chi_so_id) REFERENCES chi_so_dien_nuoc(id) ON DELETE CASCADE,
    CONSTRAINT fk_anomaly_phong FOREIGN KEY (phong_id) REFERENCES phong(id) ON DELETE CASCADE,
    CONSTRAINT fk_anomaly_hop_dong FOREIGN KEY (hop_dong_id) REFERENCES hop_dong(id) ON DELETE SET NULL,
    CONSTRAINT fk_anomaly_resolved_by FOREIGN KEY (resolved_by) REFERENCES nguoi_dung(id) ON DELETE SET NULL
);

-- 5. contract_signature
CREATE TABLE IF NOT EXISTS contract_signature (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hop_dong_id UUID NOT NULL,
    signer_id UUID,
    signer_role VARCHAR(50) NOT NULL,
    signature_image_url TEXT,
    signed_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    ip_address VARCHAR(100),
    user_agent TEXT,
    CONSTRAINT fk_signature_hop_dong FOREIGN KEY (hop_dong_id) REFERENCES hop_dong(id) ON DELETE CASCADE
);

-- 6. invoice_generation_batch
CREATE TABLE IF NOT EXISTS invoice_generation_batch (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nha_tro_id UUID,
    ky_thang INTEGER NOT NULL,
    ky_nam INTEGER NOT NULL,
    trang_thai VARCHAR(50) NOT NULL,
    tong_hop_dong INTEGER NOT NULL,
    tao_thanh_cong INTEGER NOT NULL,
    bo_qua INTEGER NOT NULL,
    loi INTEGER NOT NULL,
    nguoi_tao_id UUID,
    tao_luc TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT fk_invoice_batch_nha_tro FOREIGN KEY (nha_tro_id) REFERENCES nha_tro(id) ON DELETE SET NULL,
    CONSTRAINT fk_invoice_batch_nguoi_tao FOREIGN KEY (nguoi_tao_id) REFERENCES nguoi_dung(id) ON DELETE SET NULL
);

-- 7. invoice_generation_log
CREATE TABLE IF NOT EXISTS invoice_generation_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    batch_id UUID NOT NULL,
    hop_dong_id UUID,
    hoa_don_id UUID,
    status VARCHAR(50) NOT NULL,
    reason TEXT,
    tao_luc TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    CONSTRAINT fk_invoice_log_batch FOREIGN KEY (batch_id) REFERENCES invoice_generation_batch(id) ON DELETE CASCADE,
    CONSTRAINT fk_invoice_log_hop_dong FOREIGN KEY (hop_dong_id) REFERENCES hop_dong(id) ON DELETE SET NULL,
    CONSTRAINT fk_invoice_log_hoa_don FOREIGN KEY (hoa_don_id) REFERENCES hoa_don(id) ON DELETE SET NULL
);
