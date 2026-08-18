# Nap sql/easyhouse-export-20260817.sql vao Docker PostgreSQL cua EasyHouse.
# Giu nguyen volume easyhouse_postgres_data, chi thay noi dung schema public.
# CANH BAO: buoc DROP SCHEMA se xoa toan bo du lieu dang co trong DB local.

$ErrorActionPreference = 'Stop'
$repo = 'E:\duAnCaNhan\qlyphongtro'
$compose = Join-Path $repo 'docker-compose.easyhouse.yml'
$dump = Join-Path $repo 'sql\easyhouse-export-20260817.sql'
$container = 'easyhouse-postgres'

if (-not (Test-Path $dump)) { throw "Khong tim thay dump: $dump" }

Write-Output '=== 1. Khoi dong postgres ==='
docker compose -f $compose up -d postgres

Write-Output '=== 2. Cho postgres san sang ==='
for ($i = 0; $i -lt 60; $i++) {
    docker exec $container pg_isready -U postgres -d postgres 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) { Write-Output "  san sang sau $i giay"; break }
    Start-Sleep -Seconds 1
}

Write-Output '=== 3. Sao luu DB hien tai truoc khi ghi de ==='
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backup = Join-Path $repo "sql\pre-restore-$stamp.sql"
# Cung ly do encoding nhu buoc 4, nhung theo chieu nguoc lai: dump ra file BEN
# TRONG container roi `docker cp` ve host, thay vi cho PowerShell xu ly stdout.
docker exec $container sh -c 'pg_dump -U postgres -d postgres > /tmp/pre-restore.sql'
docker cp "${container}:/tmp/pre-restore.sql" $backup
docker exec $container rm -f /tmp/pre-restore.sql
Write-Output "  da luu: $backup"

Write-Output '=== 4. Xoa schema public va nap dump moi ==='
docker exec $container psql -U postgres -d postgres -v ON_ERROR_STOP=1 -c 'DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA public;'

# QUAN TRONG: KHONG dung `Get-Content $dump | docker exec -i ... psql`.
# Windows PowerShell 5.1 ma hoa lai pipeline theo codepage ANSI cua console khi
# ghi vao stdin cua tien trinh native, lam nat UTF-8: moi ky tu tieng Viet co dau
# bien thanh '?' (vd "Phung Van Tho" mat het dau) va khong the khoi phuc.
# Copy nguyen file vao container roi dung `psql -f` de giu nguyen tung byte.
docker cp $dump "${container}:/tmp/dump.sql"
docker exec -e PGCLIENTENCODING=UTF8 $container psql -U postgres -d postgres -v ON_ERROR_STOP=1 --quiet -f /tmp/dump.sql
docker exec $container rm -f /tmp/dump.sql

Write-Output '=== 5. Kiem chung ==='
docker exec $container psql -U postgres -d postgres -c "SELECT count(*) AS so_bang FROM information_schema.tables WHERE table_schema='public';"
docker exec $container psql -U postgres -d postgres -c "SELECT count(*) AS so_function FROM information_schema.routines WHERE routine_schema='public';"
docker exec $container psql -U postgres -d postgres -c "SELECT nd.email, vt.ten_vai_tro FROM nguoi_dung nd JOIN nguoi_dung_vai_tro ndvt ON ndvt.nguoi_dung_id = nd.id JOIN vai_tro vt ON vt.id = ndvt.vai_tro_id WHERE nd.email = 'admin@easyhouse.local';"
docker exec $container psql -U postgres -d postgres -c "SELECT count(*) AS so_hop_dong FROM hop_dong;"
docker exec $container psql -U postgres -d postgres -c "SELECT count(*) AS so_chu_ky FROM contract_signature;"

Write-Output '=== XONG ==='
