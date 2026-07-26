# Backup EasyHouse lên Google Drive

Backup gồm:

- `postgresql.dump`: PostgreSQL custom dump, khôi phục bằng `pg_restore`.
- `source.tar.gz`: mã nguồn và cấu hình không nhạy cảm, không gồm dependency/build cache.
- `secrets.tar.gz`: `.env`, `application-secrets.properties`, Cloudflare config, cấu hình backup và `rclone.conf` nếu chúng tồn tại.
- `manifest.txt`, `postgresql.contents.txt`, `SHA256SUMS`: metadata và kiểm tra toàn vẹn.

Do `secrets.tar.gz` có thông tin nhạy cảm, `RCLONE_REMOTE` **bắt buộc nên là một `crypt` remote**. Không dùng Google Drive remote thuần cho production.

## 1. Cài và cấu hình rclone trên VPS

```bash
sudo -v
curl https://rclone.org/install.sh | sudo bash
rclone config
```

Trong giao diện `rclone config`:

1. Chọn `n` tạo remote tên `gdrive`.
2. Chọn storage `drive`, đăng nhập đúng Google account và hoàn tất OAuth. Với VPS không có trình duyệt, rclone sẽ in URL để mở trên máy cá nhân; chọn `n` cho auto config khi được hỏi.
3. Chọn `n` lần nữa tạo remote tên `gdrive-crypt`.
4. Chọn storage `crypt`; remote cần mã hóa là `gdrive:easyhouse-encrypted`; chọn mã hóa tên file và thư mục; đặt hai password mạnh, lưu vào password manager.

Kiểm tra remote mã hóa:

```bash
rclone lsd gdrive-crypt:
```

Không mất hai password crypt và không xóa `~/.config/rclone/rclone.conf`: mất chúng thì không thể đọc backup trên Drive. File `rclone.conf` được đưa vào `secrets.tar.gz` để hỗ trợ khôi phục, nhưng bạn vẫn phải lưu hai password crypt trong password manager.

## 2. Cấu hình và chạy thử

Trên VPS production đã clone tại `/opt/easyhouse`:

```bash
cd /opt/easyhouse
cp deploy/backup/backup.env.example deploy/backup/backup.env
chmod 600 deploy/backup/backup.env
nano deploy/backup/backup.env
chmod 700 scripts/backup-to-google-drive.sh
./scripts/backup-to-google-drive.sh
```

Xem backup đã upload:

```bash
rclone lsd gdrive-crypt:easyhouse-production/$(hostname -s)
```

## 3. Bật lịch 03:00 hàng ngày

`User=` và `WorkingDirectory=` trong file service mặc định là `deploy` và `/opt/easyhouse`. Nếu VPS của bạn dùng tên/path khác, sửa chúng trước khi cài.

```bash
sudo install -m 644 deploy/backup/easyhouse-backup.service /etc/systemd/system/easyhouse-backup.service
sudo install -m 644 deploy/backup/easyhouse-backup.timer /etc/systemd/system/easyhouse-backup.timer
sudo systemctl daemon-reload
sudo systemctl enable --now easyhouse-backup.timer
systemctl list-timers easyhouse-backup.timer
sudo systemctl start easyhouse-backup.service
sudo journalctl -u easyhouse-backup.service -n 100 --no-pager
```

Timer chạy lúc 03:00 theo múi giờ `Asia/Ho_Chi_Minh`, có độ trễ ngẫu nhiên tối đa 10 phút để tránh tải đột ngột. Nếu VPS tắt tại thời điểm đó, `Persistent=true` sẽ chạy bù khi VPS bật lại.

## 4. Kiểm tra và khôi phục thử

Tải một bản backup về thư mục rỗng, sau đó kiểm tra checksum:

```bash
mkdir -p /tmp/easyhouse-restore-test
rclone copy gdrive-crypt:easyhouse-production/<HOST>/<BACKUP_NAME> /tmp/easyhouse-restore-test
cd /tmp/easyhouse-restore-test
sha256sum -c SHA256SUMS
```

Khôi phục database vào PostgreSQL **mới/rỗng** (lệnh này ghi đè database đích):

```bash
docker cp postgresql.dump easyhouse-postgres:/tmp/restore.dump
docker exec -it easyhouse-postgres pg_restore -U postgres -d postgres --clean --if-exists --no-owner --no-privileges /tmp/restore.dump
```

Giải nén mã nguồn và secrets chỉ trên máy/VPS an toàn:

```bash
tar -xzf source.tar.gz -C /duong-dan/khoi-phuc
tar -xzf secrets.tar.gz -C /duong-dan/khoi-phuc
```

Không chỉ dựa vào việc backup thành công: hãy thực hiện restore test định kỳ trước buổi bảo vệ hoặc mỗi tháng.
