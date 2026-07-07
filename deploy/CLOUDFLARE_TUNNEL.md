# Cloudflare Tunnel cho EasyHouse

Mục tiêu:

- `mc4vn.net` phục vụ frontend Next.js
- `api.mc4vn.net` phục vụ backend Spring Boot
- VNPay return callback quay về frontend `/thanh-toan/vnpay-return`
- Các API backend vẫn gọi qua `api.mc4vn.net`

## 1. Tạo tunnel trên Cloudflare

Trong Cloudflare Dashboard:

1. Vào `Networking > Tunnels`
2. Chọn tunnel `easyhouse`
3. Mở tab `Routes`
4. Đảm bảo đã có 2 route:
   - `mc4vn.net` -> `http://host.docker.internal:3002`
   - `api.mc4vn.net` -> `http://host.docker.internal:8082`

Lý do dùng `host.docker.internal`:

- Trên Docker Desktop Windows, đây là đường ổn nhất để Cloudflare Tunnel chạm vào service đang publish port ra host.
- Bên trong stack, frontend và backend vẫn chạy nội bộ bình thường.
- Nếu bạn để `frontend:3000` hoặc `backend:8080`, Cloudflare Tunnel có thể không resolve ổn định ở môi trường hiện tại.

## 2. Tạo file env

Tạo file `deploy/cloudflare.env` từ mẫu bên dưới và điền các giá trị còn thiếu:

```env
PUBLIC_FRONTEND_URL=https://mc4vn.net
CORS_ALLOWED_ORIGINS=https://mc4vn.net,https://api.mc4vn.net
VNPAY_RETURN_URL=https://mc4vn.net/thanh-toan/vnpay-return
NEXTAUTH_SECRET=replace-with-a-long-random-secret
CLOUDFLARED_TUNNEL_TOKEN=replace-with-cloudflare-tunnel-token
```

## 3. Chạy stack

```powershell
docker compose --env-file deploy/cloudflare.env -f docker-compose.easyhouse.yml -f docker-compose.cloudflare.yml up -d --build
```

## 4. Kiểm tra

- Mở `https://mc4vn.net`
- Mở `https://api.mc4vn.net/actuator/health`
- Test đăng nhập, đăng ký, upload và luồng thanh toán VNPay

## 5. Lưu ý

- `NEXTAUTH_SECRET` nên là chuỗi ngẫu nhiên dài tối thiểu 32 ký tự.
- Nếu bạn đổi domain khác sau này, chỉnh lại 3 biến:
  - `PUBLIC_FRONTEND_URL`
  - `CORS_ALLOWED_ORIGINS`
  - `VNPAY_RETURN_URL`
