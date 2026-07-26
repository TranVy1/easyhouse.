@echo off
echo Dang tat he thong EasyHouse...
docker compose -f docker-compose.easyhouse.yml -f docker-compose.cloudflare.yml down
echo He thong da duoc tat an toan!
