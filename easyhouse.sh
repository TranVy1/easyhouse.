#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/docker-compose.easyhouse.yml"
PRODUCTION_COMPOSE_FILE="${SCRIPT_DIR}/docker-compose.production.yml"
CLOUDFLARE_COMPOSE_FILE="${SCRIPT_DIR}/docker-compose.cloudflare.yml"

usage() {
  printf 'Cach dung: %s {start|stop|restart|deploy|status|logs}\n' "$(basename "$0")"
  printf '  deploy: build va khoi tao lai backend, frontend, nginx bang cau hinh production.\n'
}

if ! command -v docker >/dev/null 2>&1; then
  printf 'Loi: Khong tim thay Docker. Hay cai dat va khoi dong Docker truoc.\n' >&2
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  printf 'Loi: Docker Compose khong san sang.\n' >&2
  exit 1
fi

if [[ ! -f "$COMPOSE_FILE" ]]; then
  printf 'Loi: Khong tim thay file %s.\n' "$COMPOSE_FILE" >&2
  exit 1
fi

if [[ ! -f "$PRODUCTION_COMPOSE_FILE" ]]; then
  printf 'Loi: Khong tim thay file %s.\n' "$PRODUCTION_COMPOSE_FILE" >&2
  exit 1
fi

start() {
  printf 'Dang khoi dong he thong EasyHouse...\n'
  docker compose -f "$COMPOSE_FILE" up -d
  printf 'He thong da khoi dong thanh cong!\n'
}

stop() {
  printf 'Dang tat he thong EasyHouse...\n'

  if [[ -f "$CLOUDFLARE_COMPOSE_FILE" ]]; then
    docker compose \
      -f "$COMPOSE_FILE" \
      -f "$CLOUDFLARE_COMPOSE_FILE" \
      down
  else
    docker compose -f "$COMPOSE_FILE" down
  fi

  printf 'He thong da duoc tat an toan!\n'
}

deploy() {
  printf 'Dang build va trien khai EasyHouse (production)...\n'
  docker compose \
    -f "$COMPOSE_FILE" \
    -f "$PRODUCTION_COMPOSE_FILE" \
    up -d --build --force-recreate backend frontend nginx

  printf 'Trang thai sau trien khai:\n'
  docker compose -f "$COMPOSE_FILE" -f "$PRODUCTION_COMPOSE_FILE" ps

  for attempt in {1..30}; do
    if curl --fail --silent --show-error --max-time 5 -o /dev/null http://localhost/; then
      printf 'Kiem tra HTTP thanh cong (200).\n'
      return 0
    fi
    sleep 2
  done

  printf 'Loi: he thong chua tra HTTP 200 sau 60 giay. Xem log bang: %s logs frontend nginx\n' \
    "$(basename "$0")" >&2
  return 1
}

case "${1:-}" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  deploy)
    deploy
    ;;
  status)
    docker compose -f "$COMPOSE_FILE" ps
    ;;
  logs)
    docker compose -f "$COMPOSE_FILE" logs -f "${@:2}"
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac
