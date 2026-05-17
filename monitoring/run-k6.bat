@echo off
echo ======================================================
echo           DANG KICH HOAT LOAD TEST K6 (DOCKER)
echo ======================================================
echo [+] Dang chuan bi mount thu muc hien tai: %cd%
echo [+] Dang ket noi den Prometheus va gui metric...
echo.

docker run --rm -i ^
  --add-host=host.docker.internal:host-gateway ^
  --network monitoring_monitoring_network ^
  -v "%cd%:/scripts" ^
  -e K6_OUT=experimental-prometheus-rw ^
  -e K6_PROMETHEUS_RW_SERVER_URL=http://prometheus:9090/api/v1/write ^
  grafana/k6 run /scripts/k6.js

echo.
echo ======================================================
echo            K6 LOAD TEST DA HOAN THANH!
echo ======================================================
pause
