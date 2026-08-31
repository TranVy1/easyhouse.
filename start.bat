@echo off
echo Dang khoi dong he thong EasyHouse...
docker compose -f docker-compose.easyhouse.yml -f docker-compose.production.yml -f docker-compose.cloudflare.yml up -d --build
echo He thong da khoi dong thanh cong!