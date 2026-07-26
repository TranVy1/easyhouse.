#!/usr/bin/env bash
# Sao luu EasyHouse: source + cau hinh can thiet + PostgreSQL logical dump.
# Can: Docker, rclone va file deploy/backup/backup.env (khong commit file nay).

set -Eeuo pipefail
umask 077

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
project_dir="$(cd -- "$script_dir/.." && pwd)"
config_file="${BACKUP_CONFIG_FILE:-$project_dir/deploy/backup/backup.env}"

if [[ ! -r "$config_file" ]]; then
  printf 'Khong doc duoc file cau hinh backup: %s\n' "$config_file" >&2
  exit 2
fi

# shellcheck disable=SC1090
source "$config_file"

: "${RCLONE_REMOTE:?Thieu RCLONE_REMOTE trong backup.env (vi du: gdrive-crypt:easyhouse)}"
: "${POSTGRES_CONTAINER:=easyhouse-postgres}"
: "${POSTGRES_DATABASE:=postgres}"
: "${POSTGRES_USERNAME:=postgres}"
: "${LOCAL_BACKUP_DIR:=/opt/easyhouse/backups}"
: "${LOCAL_RETENTION_DAYS:=14}"
: "${REMOTE_RETENTION_DAYS:=30}"

for program in docker rclone tar gzip hostname; do
  command -v "$program" >/dev/null 2>&1 || {
    printf 'Thieu chuong trinh bat buoc: %s\n' "$program" >&2
    exit 2
  }
done

docker info >/dev/null
# Kiem tra remote va tao thu muc dich neu day la lan backup dau tien.
rclone mkdir "${RCLONE_REMOTE%/}"
docker inspect --type container "$POSTGRES_CONTAINER" >/dev/null

timestamp="$(date --utc +%Y-%m-%dT%H-%M-%SZ)"
host="$(hostname -s)"
backup_name="${host}_${timestamp}"
mkdir -p "$LOCAL_BACKUP_DIR"
work_dir="$(mktemp -d "$LOCAL_BACKUP_DIR/.in-progress.${backup_name}.XXXXXX")"
final_dir="$LOCAL_BACKUP_DIR/$backup_name"

cleanup() {
  if [[ -n "${work_dir:-}" && -d "$work_dir" ]]; then
    rm -rf -- "$work_dir"
  fi
}
trap cleanup EXIT

printf '[%s] Bat dau backup %s\n' "$(date -Is)" "$backup_name"

# Custom format cho phep kiem tra/restore linh hoat bang pg_restore.
docker exec -i "$POSTGRES_CONTAINER" \
  pg_dump --username="$POSTGRES_USERNAME" --dbname="$POSTGRES_DATABASE" \
  --format=custom --no-owner --no-privileges \
  > "$work_dir/postgresql.dump"

docker exec -i "$POSTGRES_CONTAINER" \
  pg_restore --list < "$work_dir/postgresql.dump" > "$work_dir/postgresql.contents.txt"

# Package source khong co secrets; secrets duoc dong goi rieng o phan sau.
# Loai bo output build/dependency va cac backup cu de tranh archive qua lon/long nhau.
tar \
  --exclude='./.git' \
  --exclude='./be/target' \
  --exclude='./be/node_modules' \
  --exclude='./frontend/node_modules' \
  --exclude='./frontend/.next' \
  --exclude='./monitoring/**/data' \
  --exclude='./backups' \
  --exclude='./.env' \
  --exclude='./.env.production' \
  --exclude='./frontend/.env.local' \
  --exclude='./be/src/main/resources/application-secrets.properties' \
  --exclude='./deploy/cloudflare.env' \
  --exclude='./deploy/backup/backup.env' \
  -C "$project_dir" -czf "$work_dir/source.tar.gz" .

# Cac secret bi loai khoi source.tar.gz de khong bi tao ban sao trong project archive.
# Chung duoc dua rieng vao backup va chi an toan khi RCLONE_REMOTE la crypt remote.
for secret_file in \
  "$project_dir/.env" \
  "$project_dir/.env.production" \
  "$project_dir/frontend/.env.local" \
  "$project_dir/be/src/main/resources/application-secrets.properties" \
  "$project_dir/deploy/cloudflare.env" \
  "$config_file"; do
  if [[ -f "$secret_file" ]]; then
    relative_path="${secret_file#"$project_dir"/}"
    install -D -m 600 "$secret_file" "$work_dir/secrets/$relative_path"
  fi
done
if [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/rclone/rclone.conf" ]]; then
  install -D -m 600 "${XDG_CONFIG_HOME:-$HOME/.config}/rclone/rclone.conf" \
    "$work_dir/secrets/rclone/rclone.conf"
fi
tar -C "$work_dir" -czf "$work_dir/secrets.tar.gz" secrets
rm -rf -- "$work_dir/secrets"

{
  printf 'backup_name=%s\n' "$backup_name"
  printf 'created_at_utc=%s\n' "$(date --utc -Is)"
  printf 'hostname=%s\n' "$host"
  printf 'postgres_container=%s\n' "$POSTGRES_CONTAINER"
  printf 'postgres_database=%s\n' "$POSTGRES_DATABASE"
  printf 'git_commit=%s\n' "$(git -C "$project_dir" rev-parse HEAD 2>/dev/null || printf 'not-a-git-repository')"
  printf '\n[docker-compose-images]\n'
  docker compose -f "$project_dir/docker-compose.easyhouse.yml" -f "$project_dir/docker-compose.production.yml" images 2>&1 || true
  printf '\n[docker-volumes]\n'
  docker volume ls --format '{{.Name}}' | grep '^easyhouse_' || true
} > "$work_dir/manifest.txt"

(cd "$work_dir" && sha256sum postgresql.dump postgresql.contents.txt source.tar.gz secrets.tar.gz manifest.txt > SHA256SUMS)
mv -- "$work_dir" "$final_dir"
work_dir=""

# copy xong moi xoa backup local cu. RCLONE_REMOTE nen la crypt remote (xem README).
rclone copy --checksum --transfers 2 "$final_dir" "${RCLONE_REMOTE%/}/$host/$backup_name"
rclone check "$final_dir" "${RCLONE_REMOTE%/}/$host/$backup_name" --one-way

find "$LOCAL_BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d -name "${host}_*" -mtime "+$LOCAL_RETENTION_DAYS" -exec rm -rf -- {} +
rclone delete "${RCLONE_REMOTE%/}/$host" --min-age "${REMOTE_RETENTION_DAYS}d"
rclone rmdirs "${RCLONE_REMOTE%/}/$host" --leave-root

printf '[%s] Backup thanh cong: %s\n' "$(date -Is)" "$final_dir"
