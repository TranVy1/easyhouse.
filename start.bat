@echo off
echo Dang khoi dong he thong EasyHouse...
docker compose -f docker-compose.easyhouse.yml -f docker-compose.cloudflare.yml up -d
echo He thong da khoi dong thanh cong!
