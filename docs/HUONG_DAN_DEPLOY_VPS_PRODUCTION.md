# Hướng dẫn triển khai EasyHouse lên VPS mới (Production)

Tài liệu này triển khai EasyHouse trên **Ubuntu Server 24.04 LTS** bằng Docker Compose, Nginx container và Let's Encrypt. Luồng truy cập là:

```text
Trình duyệt --HTTPS/WSS--> Nginx (container) --> Next.js / Spring Boot --> PostgreSQL, Redis
```

Ví dụ bên dưới dùng `easyhouse.example.com`. Thay toàn bộ bằng domain thật của bạn. Không mở các cổng nội bộ của ứng dụng ra Internet: chỉ mở `22`, `80`, `443`.

> Lưu ý quan trọng: mã nguồn hiện tại đang có thông tin nhạy cảm trong một số file `.env` cục bộ. Không sao chép, không commit các file này lên VPS/Git. Hãy đổi toàn bộ secret đã từng lộ và tạo secret mới theo hướng dẫn dưới đây.

## 1. Chuẩn bị trước khi bắt đầu

- VPS Ubuntu 24.04 LTS, tối thiểu 2 vCPU, 4 GB RAM, 40 GB SSD (khuyến nghị 4 vCPU/8 GB RAM nếu có nhiều người dùng).
- Domain và quyền quản trị DNS.
- Một SSH public key trên máy cá nhân.
- Repository GitHub/GitLab của dự án.
- Tài khoản SMTP, Cloudinary (nếu dùng upload ảnh), VNPay (nếu bật thanh toán), và VAPID keys (nếu dùng Web Push).

Tại DNS, tạo hai bản ghi trước khi lấy SSL:

| Loại | Host | Giá trị |
|---|---|---|
| `A` | `@` | IPv4 public của VPS |
| `A` | `www` | IPv4 public của VPS |

Nếu dùng Cloudflare, để bản ghi ở trạng thái **DNS only** (mây xám) trong bước cấp chứng chỉ. Có thể bật proxy sau khi HTTPS hoạt động.

## 2. Đăng nhập lần đầu và cập nhật hệ điều hành

Đăng nhập bằng tài khoản root do nhà cung cấp VPS cấp:

```bash
ssh root@IP_VPS
apt update
apt upgrade -y
apt install -y ca-certificates curl git ufw fail2ban unattended-upgrades gnupg
timedatectl set-timezone Asia/Ho_Chi_Minh
reboot
```

Sau khi VPS khởi động lại, tạo user quản trị (thay `deploy` nếu muốn):

```bash
ssh root@IP_VPS
adduser deploy
usermod -aG sudo deploy
install -d -m 700 -o deploy -g deploy /home/deploy/.ssh
nano /home/deploy/.ssh/authorized_keys
chmod 600 /home/deploy/.ssh/authorized_keys
chown deploy:deploy /home/deploy/.ssh/authorized_keys
```

Dán **SSH public key** của máy cá nhân vào `authorized_keys`, rồi thử đăng nhập ở một terminal mới trước khi tắt root:

```bash
ssh deploy@IP_VPS
```

Sau khi xác nhận đăng nhập thành công, trên VPS cấu hình SSH và firewall:

```bash
sudo nano /etc/ssh/sshd_config.d/99-hardening.conf
```

Nội dung:

```conf
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
```

```bash
sudo sshd -t
sudo systemctl restart ssh
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
sudo ufw status verbose
sudo systemctl enable --now fail2ban
```

Không đóng terminal SSH đang dùng cho đến khi đã thử đăng nhập lại bằng key ở một terminal khác.

## 3. Cài Docker Engine và Docker Compose

Thực hiện bằng user `deploy`:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker "$USER"
exit
```

Đăng nhập SSH lại để group `docker` có hiệu lực, rồi kiểm tra:

```bash
docker --version
docker compose version
docker run --rm hello-world
```

## 4. Lấy mã nguồn và kiểm tra các file triển khai

```bash
sudo mkdir -p /opt/easyhouse
sudo chown deploy:deploy /opt/easyhouse
git clone <URL_REPOSITORY_CUA_BAN> /opt/easyhouse
cd /opt/easyhouse
git status
```

Từ đây mọi lệnh Docker được chạy tại `/opt/easyhouse`.

Repository hiện có các file production sau:

- `docker-compose.easyhouse.yml`: PostgreSQL, Redis, Spring Boot và Next.js.
- `docker-compose.production.yml`: frontend production và Nginx công khai cổng 80/443.
- `deploy/nginx/easyhouse.conf`: proxy `/`, `/api/` và WebSocket `/ws`.
- `frontend/Dockerfile.production`: build Next.js production.

### Điều chỉnh bắt buộc trước lần chạy đầu

1. Thay `easyhouse.site` và `www.easyhouse.site` trong **cả** `docker-compose.production.yml` và `deploy/nginx/easyhouse.conf` bằng domain thật. Đồng thời đổi các URL tương ứng trong `docker-compose.easyhouse.yml` (`CORS_ALLOWED_ORIGINS`, `APP_FRONTEND_BASE_URL`, `VNPAY_RETURN_URL`) nếu vẫn còn domain cũ.
2. Trong `docker-compose.easyhouse.yml`, thay các giá trị mẫu `CLOUDINARY_*`, `PUSH_VAPID_*`, `JWT_SECRET` và các mật khẩu database mặc định. Nên đổi các dòng này sang dạng bắt buộc đọc từ `.env.production`, ví dụ `JWT_SECRET: ${JWT_SECRET:?JWT_SECRET is required}`. Không đặt secret trong Git.
3. `docker-compose.easyhouse.yml` hiện tham chiếu `sql/init-db.sql`, nhưng file này không có trong cây mã nguồn hiện tại. **Xóa/comment ba dòng mount `./sql/...:/docker-entrypoint-initdb.d/...` ở service `postgres`** trước khi khởi tạo database. Database sẽ được khôi phục chủ động ở bước 7, nên không dùng cơ chế init tự động này.
4. Không publish database/Redis ra Internet. Xóa các mục `ports` của `postgres` và `redis` trong compose production (và nên xóa cả `8082:8080` của backend). Nginx đã là đường vào duy nhất cần thiết.

Ví dụ phần `ports` production mong muốn: chỉ service `nginx` giữ:

```yaml
ports:
  - "80:80"
  - "443:443"
```

Kiểm tra sau khi chỉnh:

```bash
docker compose -f docker-compose.easyhouse.yml -f docker-compose.production.yml config > /tmp/easyhouse-compose.resolved.yml
```

Lệnh phải kết thúc không báo lỗi. File `/tmp/...` chỉ dùng để kiểm tra, không cần commit.

## 5. Tạo secrets production

Tạo các secret bằng trình sinh ngẫu nhiên; mỗi secret dùng một giá trị riêng:

```bash
openssl rand -base64 48
```

### Backend: `be/src/main/resources/application-secrets.properties`

```bash
nano be/src/main/resources/application-secrets.properties
chmod 600 be/src/main/resources/application-secrets.properties
```

Dùng mẫu dưới đây và điền giá trị thật. File này đã được `.gitignore`, không commit.

```properties
jwt.secret=<JWT_SECRET_DAI_IT_NHAT_32_KY_TU>
cors.allowed-origins=https://easyhouse.example.com,https://www.easyhouse.example.com
app.frontend.base-url=https://easyhouse.example.com

spring.mail.username=<EMAIL_SMTP>
spring.mail.password=<MAT_KHAU_SMTP>

cloudinary.cloud-name=<CLOUDINARY_CLOUD_NAME>
cloudinary.api-key=<CLOUDINARY_API_KEY>
cloudinary.api-secret=<CLOUDINARY_API_SECRET>

vnpay.tmn-code=<VNPAY_TMN_CODE>
vnpay.hash-secret=<VNPAY_HASH_SECRET>
vnpay.return-url=https://easyhouse.example.com/api/vnpay/vnpay-return

push.vapid.public-key=<VAPID_PUBLIC_KEY>
push.vapid.private-key=<VAPID_PRIVATE_KEY>
push.vapid.subject=mailto:<EMAIL_QUAN_TRI>
```

Nếu chưa dùng Cloudinary hoặc Web Push, có thể bỏ các thuộc tính của tích hợp đó. **Không bỏ `vnpay.tmn-code` và `vnpay.hash-secret`: mã backend hiện tại đọc hai thuộc tính này không có giá trị mặc định, nên cần có thông tin sandbox/hợp lệ để ứng dụng khởi động.** Chỉ cấu hình URL return/IPN production sau khi đã đăng ký HTTPS URL với VNPay.

### Frontend: `.env.production` tại thư mục gốc

Tạo file này để Compose đọc `NEXTAUTH_SECRET`, tuyệt đối không dùng fallback mặc định trong compose:

```bash
nano .env.production
chmod 600 .env.production
```

```dotenv
NEXTAUTH_SECRET=<SECRET_RIENG_IT_NHAT_32_KY_TU>
JWT_SECRET=<JWT_SECRET_DAI_IT_NHAT_32_KY_TU>
FRONTEND_URL=https://easyhouse.example.com
```

Khi chạy Compose, luôn kèm `--env-file .env.production`. Với WebSocket, `NEXT_PUBLIC_WS_URL` phải là `wss://easyhouse.example.com/ws` và được truyền ở **build args** như `docker-compose.production.yml` vì biến `NEXT_PUBLIC_*` được nhúng khi build Next.js.

## 6. Cấp HTTPS Let's Encrypt

Cấu hình Nginx hiện tại dùng `/etc/nginx/ssl/easyhouse.site.crt` và `.key`. Cách bền vững hơn là dùng trực tiếp certificate do Certbot quản lý.

Sửa `docker-compose.production.yml`:

```yaml
volumes:
  - ./deploy/nginx/easyhouse.conf:/etc/nginx/conf.d/default.conf:ro
  - /etc/letsencrypt:/etc/letsencrypt:ro
```

Sửa trong `deploy/nginx/easyhouse.conf` theo domain thật:

```nginx
ssl_certificate     /etc/letsencrypt/live/easyhouse.example.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/easyhouse.example.com/privkey.pem;
```

Cài Certbot trên host và cấp chứng chỉ. DNS phải trỏ đến VPS, cổng 80 phải mở và chưa có container nào chiếm cổng 80:

```bash
sudo apt install -y certbot
sudo certbot certonly --standalone \
  -d easyhouse.example.com \
  -d www.easyhouse.example.com \
  --email <EMAIL_QUAN_TRI> \
  --agree-tos --no-eff-email
sudo certbot renew --dry-run
```

Tạo deploy hook để Nginx container đọc chứng chỉ mới sau mỗi lần renew:

```bash
sudo tee /etc/letsencrypt/renewal-hooks/deploy/reload-easyhouse-nginx >/dev/null <<'EOF'
#!/bin/sh
docker kill -s HUP easyhouse-nginx 2>/dev/null || true
EOF
sudo chmod 750 /etc/letsencrypt/renewal-hooks/deploy/reload-easyhouse-nginx
```

Certbot cài systemd timer tự gia hạn. Kiểm tra bằng `systemctl list-timers | grep certbot`.

## 7. Khởi tạo và khôi phục PostgreSQL

`sql/backup.dump` là file dump nhị phân; dùng `pg_restore`, không dùng `psql`. Bước này xóa toàn bộ dữ liệu trong database container vừa tạo — chỉ thực hiện khi khởi tạo mới hoặc khi bạn đã có backup và chủ động muốn ghi đè.

Khởi động riêng PostgreSQL và Redis trước:

```bash
docker compose --env-file .env.production -f docker-compose.easyhouse.yml -f docker-compose.production.yml up -d postgres redis
docker compose --env-file .env.production -f docker-compose.easyhouse.yml -f docker-compose.production.yml ps
```

Chờ trạng thái PostgreSQL là `healthy`, sau đó restore:

```bash
docker cp sql/backup.dump easyhouse-postgres:/tmp/backup.dump
docker exec -it easyhouse-postgres pg_restore \
  --username=postgres --dbname=postgres --clean --if-exists --no-owner --no-privileges \
  /tmp/backup.dump
docker exec -it easyhouse-postgres psql -U postgres -d postgres -c '\dt'
```

Nếu dump của bạn được xuất sang dạng SQL text thay vì `.dump`, thay lệnh `pg_restore` bằng:

```bash
docker exec -i easyhouse-postgres psql -U postgres -d postgres < sql/ten-file.sql
```

Tài khoản demo mặc định chỉ dùng để kiểm tra và phải đổi mật khẩu sau khi đăng nhập lần đầu:

```text
Email: admin@easyhouse.local
Mật khẩu: Admin@123
```

## 8. Build và chạy production

```bash
cd /opt/easyhouse
docker compose --env-file .env.production \
  -f docker-compose.easyhouse.yml \
  -f docker-compose.production.yml \
  up -d --build --remove-orphans

docker compose --env-file .env.production \
  -f docker-compose.easyhouse.yml \
  -f docker-compose.production.yml ps
```

Nếu dùng script có sẵn `easyhouse.sh`, cần bổ sung `--env-file .env.production` vào các lệnh Compose trong script trước khi dùng `./easyhouse.sh deploy`; nếu không Compose có thể dùng fallback secret không an toàn.

## 9. Kiểm thử bắt buộc sau triển khai

Trên VPS:

```bash
curl -I http://easyhouse.example.com
curl -I https://easyhouse.example.com
docker compose --env-file .env.production -f docker-compose.easyhouse.yml -f docker-compose.production.yml logs --tail=100 backend frontend nginx
```

Trên trình duyệt:

1. Mở `https://easyhouse.example.com` và kiểm tra biểu tượng khóa HTTPS.
2. Đăng nhập bằng tài khoản admin, đổi mật khẩu demo ngay.
3. Tạo thử tòa nhà/phòng/khách thuê/hóa đơn và tải thử một ảnh (nếu Cloudinary được bật).
4. Mở DevTools → Network, kiểm tra `/ws` có kết nối `101 Switching Protocols` (nếu dùng chat/thông báo realtime).
5. Kiểm tra đăng xuất/đăng nhập lại và các API dưới `/api/` không bị 404/502.

Không công khai endpoint Actuator chi tiết nếu không cần. Hiện ứng dụng export `health`, `info`, `prometheus`; nếu cần đưa endpoint này qua Nginx cho Prometheus, tạo location `/actuator/` riêng và giới hạn bằng firewall hoặc reverse proxy có xác thực/IP allow-list.

## 10. Vận hành hằng ngày: log, cập nhật, backup và khôi phục

### Xem trạng thái và log

```bash
cd /opt/easyhouse
docker compose --env-file .env.production -f docker-compose.easyhouse.yml -f docker-compose.production.yml ps
docker compose --env-file .env.production -f docker-compose.easyhouse.yml -f docker-compose.production.yml logs -f --tail=200 backend
docker stats
df -h
```

### Cập nhật phiên bản ứng dụng

Tạo backup trước, sau đó cập nhật và build lại:

```bash
cd /opt/easyhouse
git fetch origin
git status
git pull --ff-only origin main
docker compose --env-file .env.production -f docker-compose.easyhouse.yml -f docker-compose.production.yml up -d --build --remove-orphans
docker compose --env-file .env.production -f docker-compose.easyhouse.yml -f docker-compose.production.yml ps
```

Xem migration/database change trong commit trước khi deploy. Không chạy `docker compose down -v` trên production vì lệnh đó xóa volumes, bao gồm dữ liệu PostgreSQL.

### Backup PostgreSQL hằng ngày

Tạo thư mục backup chỉ user `deploy` đọc được:

```bash
mkdir -p /opt/easyhouse/backups
chmod 700 /opt/easyhouse/backups
```

Tạo script `/opt/easyhouse/backup-db.sh`:

```bash
nano /opt/easyhouse/backup-db.sh
chmod 700 /opt/easyhouse/backup-db.sh
```

```bash
#!/usr/bin/env bash
set -euo pipefail
backup_dir=/opt/easyhouse/backups
timestamp=$(date +%F_%H%M%S)
docker exec easyhouse-postgres pg_dump -U postgres -Fc postgres > "$backup_dir/easyhouse_${timestamp}.dump"
find "$backup_dir" -type f -name 'easyhouse_*.dump' -mtime +14 -delete
```

Thêm cron chạy lúc 02:15 mỗi ngày:

```bash
crontab -e
```

```cron
15 2 * * * /opt/easyhouse/backup-db.sh >> /opt/easyhouse/backups/backup.log 2>&1
```

Kiểm tra một file backup có thể đọc được:

```bash
docker cp /opt/easyhouse/backups/<TEN_FILE>.dump easyhouse-postgres:/tmp/verify.dump
docker exec easyhouse-postgres pg_restore --list /tmp/verify.dump | head
```

Sao chép backup sang một nơi khác VPS (object storage, Google Drive được mã hóa, hoặc máy cá nhân). Backup chỉ nằm trên cùng VPS không bảo vệ được khi VPS hỏng/mất dữ liệu.

### Khôi phục từ backup

Chỉ làm khi đã thông báo downtime và có backup hiện tại. Dừng backend/frontend, restore bằng đúng lệnh ở phần 7 với file backup cần khôi phục, rồi chạy lại backend/frontend. Luôn kiểm tra restore trên môi trường thử nghiệm trước khi áp dụng dữ liệu production quan trọng.

## 11. Checklist bàn giao đồ án

- [ ] DNS `@` và `www` trỏ đúng VPS; HTTPS hợp lệ, tự gia hạn thành công.
- [ ] UFW chỉ mở 22, 80, 443; PostgreSQL/Redis/backend không có public port.
- [ ] SSH chỉ cho phép key; root và password login đã tắt.
- [ ] `NEXTAUTH_SECRET`, JWT, SMTP, Cloudinary, VNPay và VAPID là secret mới; không nằm trong Git.
- [ ] Database đã restore từ dump, đăng nhập admin được và mật khẩu demo đã đổi.
- [ ] Các container `postgres`, `redis`, `backend`, `frontend`, `nginx` đều `Up`; Postgres `healthy`.
- [ ] Kiểm tra API, upload (nếu dùng), thanh toán sandbox (nếu dùng), WebSocket và refresh trang dashboard.
- [ ] Có backup tự động hằng ngày, retention và một bản copy ngoài VPS.
- [ ] Đã lưu lại domain, IP VPS, repository/branch, vị trí backup và cách rollback cho buổi bảo vệ.

## 12. Sự cố thường gặp

| Hiện tượng | Cách kiểm tra/khắc phục |
|---|---|
| Nginx không khởi động, báo thiếu `.crt`/`.key` | Kiểm tra certificate paths và volume `/etc/letsencrypt` ở phần 6; chạy `sudo certbot certificates`. |
| `502 Bad Gateway` | Xem `docker compose ... logs backend frontend nginx`; kiểm tra `backend`/`frontend` đang Up và cùng network. |
| Build frontend xong nhưng WebSocket trỏ domain cũ | Sửa build arg `NEXT_PUBLIC_WS_URL`, sau đó build lại frontend với `--build`; biến `NEXT_PUBLIC_*` không đổi chỉ bằng restart. |
| Postgres không khởi động lần đầu | Kiểm tra đã xóa mount `sql/init-db.sql` không tồn tại; xem `docker logs easyhouse-postgres`. |
| API lỗi CORS/WebSocket bị chặn | Bổ sung chính xác `https://easyhouse.example.com` và `https://www.easyhouse.example.com` vào `CORS_ALLOWED_ORIGINS`/`cors.allowed-origins`, rồi recreate backend. |
| Không gửi email/upload | Kiểm tra giá trị SMTP/Cloudinary trong `application-secrets.properties` và log backend; không đưa credential vào log/screenshot. |
