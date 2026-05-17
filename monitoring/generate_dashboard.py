import json
import os

def create_panel(id, title, expr, gridPos, type="timeseries", format="none", min=None, max=None):
    panel = {
        "id": id,
        "title": title,
        "type": type,
        "gridPos": gridPos,
        "targets": [{"expr": expr, "refId": "A"}],
        "datasource": {"type": "prometheus", "uid": "prometheus"}
    }
    if type in ["timeseries", "gauge", "stat"]:
        panel["fieldConfig"] = {
            "defaults": {
                "unit": format,
                "color": {"mode": "palette-classic"}
            }
        }
        if min is not None: panel["fieldConfig"]["defaults"]["min"] = min
        if max is not None: panel["fieldConfig"]["defaults"]["max"] = max
    
    if type == "stat":
        panel["options"] = {"reduceOptions": {"calcs": ["lastNotNull"]}, "graphMode": "area"}
        
    if type == "gauge":
        panel["options"] = {"reduceOptions": {"calcs": ["lastNotNull"]}, "showThresholdLabels": False, "showThresholdMarkers": True}
        panel["fieldConfig"]["defaults"]["thresholds"] = {"mode": "absolute", "steps": [{"color": "green", "value": None}, {"color": "red", "value": 80}]}
        
    return panel

dashboard = {
    "title": "Spring Boot Full Monitoring",
    "description": "Dashboard for System, Docker, API, and Business Metrics",
    "schemaVersion": 38,
    "style": "dark",
    "timezone": "browser",
    "editable": True,
    "panels": [
        {"type": "row", "title": "1. System Dashboard (Node Exporter)", "gridPos": {"x": 0, "y": 0, "w": 24, "h": 1}, "id": 100},
        create_panel(1, "CPU Usage", "100 - (avg by (instance) (rate(node_cpu_seconds_total{mode='idle'}[1m])) * 100)", {"x": 0, "y": 1, "w": 6, "h": 8}, "gauge", "percent", 0, 100),
        create_panel(2, "RAM Usage", "100 * (1 - ((node_memory_MemFree_bytes + node_memory_Cached_bytes + node_memory_Buffers_bytes) / node_memory_MemTotal_bytes))", {"x": 6, "y": 1, "w": 6, "h": 8}, "gauge", "percent", 0, 100),
        create_panel(3, "Disk Usage", "100 - ((node_filesystem_avail_bytes{mountpoint='/',fstype!='rootfs'} * 100) / node_filesystem_size_bytes{mountpoint='/',fstype!='rootfs'})", {"x": 12, "y": 1, "w": 6, "h": 8}, "gauge", "percent", 0, 100),
        create_panel(4, "Network Traffic (eth0)", "rate(node_network_receive_bytes_total{device='eth0'}[1m])", {"x": 18, "y": 1, "w": 6, "h": 8}, "timeseries", "Bps"),
        
        {"type": "row", "title": "2. Docker Dashboard (cAdvisor)", "gridPos": {"x": 0, "y": 9, "w": 24, "h": 1}, "id": 101},
        create_panel(5, "Container CPU Usage", "sum(rate(container_cpu_usage_seconds_total{name!=''}[1m])) by (name) * 100", {"x": 0, "y": 10, "w": 12, "h": 8}, "timeseries", "percent"),
        create_panel(6, "Container RAM Usage", "sum(container_memory_usage_bytes{name!=''}) by (name)", {"x": 12, "y": 10, "w": 12, "h": 8}, "timeseries", "bytes"),
        
        {"type": "row", "title": "3. API Dashboard (Spring Boot Actuator)", "gridPos": {"x": 0, "y": 18, "w": 24, "h": 1}, "id": 102},
        create_panel(7, "Requests Per Second (RPS)", "sum(rate(http_server_requests_seconds_count[1m]))", {"x": 0, "y": 19, "w": 6, "h": 8}, "stat", "reqps"),
        create_panel(8, "Average Response Time (s)", "sum(rate(http_server_requests_seconds_sum[1m])) / sum(rate(http_server_requests_seconds_count[1m]))", {"x": 6, "y": 19, "w": 6, "h": 8}, "stat", "s"),
        create_panel(9, "Error Rate (5xx)", "(sum(rate(http_server_requests_seconds_count{status=~'5..'}[1m])) / sum(rate(http_server_requests_seconds_count[1m]))) * 100", {"x": 12, "y": 19, "w": 6, "h": 8}, "stat", "percent"),
        create_panel(10, "Top Endpoints by Requests", "topk(5, sum(rate(http_server_requests_seconds_count[5m])) by (uri))", {"x": 18, "y": 19, "w": 6, "h": 8}, "timeseries", "reqps"),
        
        {"type": "row", "title": "4. Business Dashboard", "gridPos": {"x": 0, "y": 27, "w": 24, "h": 1}, "id": 103},
        create_panel(11, "Tổng số Request", "sum(http_server_requests_seconds_count)", {"x": 0, "y": 28, "w": 8, "h": 8}, "stat", "short"),
        create_panel(12, "Số User Online (Mock)", "abs(sin(time() / 1000)) * 50 + 10", {"x": 8, "y": 28, "w": 8, "h": 8}, "stat", "short"),
        create_panel(13, "Doanh Thu Ước Tính (Mock - VND)", "sum(http_server_requests_seconds_count) * 15000", {"x": 16, "y": 28, "w": 8, "h": 8}, "stat", "currencyVND")
    ]
}

os.makedirs("grafana/dashboards", exist_ok=True)
with open("grafana/dashboards/full_monitoring.json", "w", encoding="utf-8") as f:
    json.dump(dashboard, f, indent=2, ensure_ascii=False)
print("Dashboard generated.")
