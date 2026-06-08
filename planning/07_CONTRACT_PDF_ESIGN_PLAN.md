# P2 - Hợp đồng PDF và ký xác nhận

## 1. Vấn đề hiện tại

Hợp đồng đã có:
- Tạo/sửa.
- Preview text.
- Confirm và khóa hợp đồng.
- Gia hạn/kết thúc.
- Phụ lục.

Nhưng preview hiện còn đơn giản. Nếu muốn hệ thống giống thực tế hơn, cần file hợp đồng PDF có dữ liệu thật và bước ký/xác nhận.

## 2. Mục tiêu nghiệp vụ

Chủ trọ tạo hợp đồng, hệ thống sinh PDF từ template, khách thuê xác nhận/ký, sau đó hợp đồng bị khóa.

## 3. Flow xử lý

1. Tạo hợp đồng `DRAFT`.
2. Bấm `Xem trước`.
3. Backend render nội dung hợp đồng từ template.
4. Bấm `Sinh PDF`.
5. Lưu file vào media/Cloudinary.
6. Gửi link cho khách thuê.
7. Khách thuê đăng nhập portal và xác nhận/ký.
8. Hợp đồng chuyển `ACTIVE`, set `lockedAt`.

## 4. Database cần thêm

```sql
ALTER TABLE public.hop_dong
ADD COLUMN IF NOT EXISTS pdf_url text,
ADD COLUMN IF NOT EXISTS signed_pdf_url text,
ADD COLUMN IF NOT EXISTS tenant_signed_at timestamptz,
ADD COLUMN IF NOT EXISTS landlord_signed_at timestamptz,
ADD COLUMN IF NOT EXISTS signature_status varchar(30) DEFAULT 'UNSIGNED';
```

Signature status:
- `UNSIGNED`
- `LANDLORD_SIGNED`
- `TENANT_SIGNED`
- `COMPLETED`
- `REJECTED`

Nếu cần lưu chữ ký:

```sql
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
```

## 5. Backend cần thêm

Service:
- `ContractDocumentService`

Method:
- `generatePreview(UUID hopDongId)`
- `generatePdf(UUID hopDongId)`
- `sign(UUID hopDongId, ContractSignRequest request)`
- `reject(UUID hopDongId, String reason)`

API:
- `POST /api/hop-dong/{id}/generate-pdf`
- `POST /api/hop-dong/{id}/sign`
- `POST /api/hop-dong/{id}/reject`
- `GET /api/hop-dong/{id}/document`

PDF library:
- Có thể dùng OpenHTMLToPDF hoặc iText nếu license phù hợp.
- Nếu muốn nhanh, dùng HTML template -> PDF.

## 6. Frontend cần thêm

Trong trang hợp đồng:
- Tab `Văn bản hợp đồng`.
- Button `Sinh PDF`.
- Preview PDF.
- Button `Ký/Xác nhận`.

Tenant portal:
- Trang hợp đồng của tôi.
- Xem PDF.
- Checkbox đồng ý điều khoản.
- Ký hoặc xác nhận.

## 7. Test cần viết

- Không sinh PDF nếu hợp đồng thiếu phòng/khách/ngày.
- Sinh PDF thành công có URL.
- Tenant chỉ ký hợp đồng của chính mình.
- Sau khi đủ chữ ký thì hợp đồng khóa.
- Không sửa hợp đồng đã ký.

## 8. Checklist triển khai

- [ ] Chọn thư viện PDF.
- [ ] Tạo template hợp đồng.
- [ ] Thêm cột DB.
- [ ] Tạo service render PDF.
- [ ] Tạo API ký/xác nhận.
- [ ] Update frontend trang hợp đồng.
- [ ] Update tenant portal.
- [ ] Viết test.

## 9. Demo bảo vệ

1. Tạo hợp đồng nháp.
2. Sinh PDF.
3. Mở tenant portal.
4. Khách xác nhận/ký.
5. Hợp đồng chuyển active và bị khóa.
6. Cho xem audit log.
