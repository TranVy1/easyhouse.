import os
import sys
import html
import shutil
import subprocess

# Ensure we import the updated layout and routing functions
from generate_erd_full import (
    table_positions, table_dimensions, table_col_map, tables, get_selected_cols,
    fk_list, table_domain_colors, CANVAS_WIDTH, CANVAS_HEIGHT, ROW_HEIGHT,
    get_top_lane, get_bot_lane, get_channel_x
)

svg_parts = []
svg_parts.append(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {CANVAS_WIDTH} {CANVAS_HEIGHT}" width="{CANVAS_WIDTH}" height="{CANVAS_HEIGHT}" style="background-color:#F8FAFC;font-family:-apple-system,BlinkMacSystemFont,\'Segoe UI\',Roboto,Helvetica,Arial,sans-serif;">')

# Definitions
svg_parts.append('''
<defs>
  <!-- Shadow Filter -->
  <filter id="card-shadow" x="-5%" y="-5%" width="115%" height="115%" filterUnits="userSpaceOnUse">
    <feDropShadow dx="0" dy="3" stdDeviation="5" flood-color="#0F172A" flood-opacity="0.07"/>
  </filter>
  
  <!-- Crow foot markers -->
  <marker id="arrow-many" viewBox="0 0 14 14" refX="10" refY="7" markerWidth="9" markerHeight="9" orient="auto">
    <path d="M 0 2 L 10 7 L 0 12 M 10 1 L 10 13" fill="none" stroke="#64748B" stroke-width="1.8" stroke-linecap="round"/>
  </marker>
  <marker id="arrow-one" viewBox="0 0 14 14" refX="10" refY="7" markerWidth="9" markerHeight="9" orient="auto">
    <path d="M 6 2 L 6 12 M 10 2 L 10 12" fill="none" stroke="#64748B" stroke-width="1.8" stroke-linecap="round"/>
  </marker>
  <marker id="arrow-1to1" viewBox="0 0 14 14" refX="10" refY="7" markerWidth="9" markerHeight="9" orient="auto">
    <path d="M 5 2 L 5 12 M 9 2 L 9 12" fill="none" stroke="#EA580C" stroke-width="2" stroke-linecap="round"/>
  </marker>
</defs>
''')

# Canvas Header & Legend
svg_parts.append(f'''
<g id="canvas-header" transform="translate(80, 20)">
  <text x="0" y="22" font-size="22" font-weight="800" fill="#0F172A" letter-spacing="-0.5">EASYHOUSE — SƠ ĐỒ QUAN HỆ THỰC THỂ (ERD)</text>
  <text x="0" y="42" font-size="11.5" font-weight="500" fill="#64748B">sql/schema.sql • 56 Bảng • 115 Khóa ngoại • Bố cục luồng gọn gàng &amp; không cắt qua bảng</text>
  
  <!-- Legend -->
  <g transform="translate({CANVAS_WIDTH - 900}, 0)">
    <rect x="0" y="0" width="820" height="42" rx="6" fill="#FFFFFF" stroke="#E2E8F0" filter="url(#card-shadow)"/>
    <text x="16" y="26" font-size="11" font-weight="700" fill="#334155">CHÚ THÍCH:</text>
    
    <rect x="95" y="13" width="24" height="16" rx="3" fill="#FEE2E2"/>
    <text x="107" y="25" font-size="9" font-weight="bold" fill="#DC2626" text-anchor="middle">PK</text>
    <text x="125" y="25" font-size="10.5" fill="#475569">Khóa chính</text>
    
    <rect x="200" y="13" width="24" height="16" rx="3" fill="#DBEAFE"/>
    <text x="212" y="25" font-size="9" font-weight="bold" fill="#2563EB" text-anchor="middle">FK</text>
    <text x="230" y="25" font-size="10.5" fill="#475569">Khóa ngoại</text>
    
    <rect x="305" y="13" width="24" height="16" rx="3" fill="#DCFCE7"/>
    <text x="317" y="25" font-size="9" font-weight="bold" fill="#16A34A" text-anchor="middle">UQ</text>
    <text x="335" y="25" font-size="10.5" fill="#475569">Duy nhất (Unique)</text>
    
    <line x1="450" y1="21" x2="490" y2="21" stroke="#64748B" stroke-width="2"/>
    <text x="496" y="25" font-size="10.5" fill="#475569">Quan hệ 1 - N</text>
    
    <line x1="590" y1="21" x2="630" y2="21" stroke="#EA580C" stroke-width="2.5"/>
    <text x="636" y="25" font-size="10.5" font-weight="bold" fill="#EA580C">Quan hệ 1 - 1</text>
  </g>
</g>
''')

# 1. Draw Clean Orthogonal Connectors (Obstacle Avoiding)
edge_idx = 1
for fk in fk_list:
    src_tbl = fk['source_table']
    tgt_tbl = fk['target_table']
    
    if src_tbl not in table_positions or tgt_tbl not in table_positions:
        continue
        
    sx, sy = table_positions[src_tbl]
    sw, sh = table_dimensions[src_tbl]
    tx, ty = table_positions[tgt_tbl]
    tw, th = table_dimensions[tgt_tbl]
    
    scol, srow = table_col_map[src_tbl]
    tcol, trow = table_col_map[tgt_tbl]
    
    is_1to1 = fk.get('is_one_to_one', False)
    hcolor = table_domain_colors.get(src_tbl, '#64748B')
    stroke_color = '#EA580C' if is_1to1 else hcolor
    stroke_w = '2.2' if is_1to1 else '1.4'
    marker_end = 'url(#arrow-1to1)' if is_1to1 else 'url(#arrow-many)'
    
    path_points = []
    
    # Case A: Same Column
    if scol == tcol:
        chan_x = sx + sw + 16 + (edge_idx % 4) * 8
        start_y = sy + 25 + (edge_idx % 3) * 8
        end_y = ty + 25 + (edge_idx % 3) * 8
        path_points = [(sx + sw, start_y), (chan_x, start_y), (chan_x, end_y), (tx + tw, end_y)]
        
    # Case B: Adjacent Columns
    elif abs(scol - tcol) == 1:
        if scol < tcol:
            chan_x = get_channel_x(scol, edge_idx)
            start_y = sy + sh * 0.45
            end_y = ty + th * 0.45
            path_points = [(sx + sw, start_y), (chan_x, start_y), (chan_x, end_y), (tx, end_y)]
        else:
            chan_x = get_channel_x(tcol, edge_idx)
            start_y = sy + sh * 0.45
            end_y = ty + th * 0.45
            path_points = [(sx, start_y), (chan_x, start_y), (chan_x, end_y), (tx + tw, end_y)]
            
    # Case C: Far Columns (Route via Top/Bottom Highways)
    else:
        use_top = (srow + trow) <= 6
        if use_top:
            highway_y = get_top_lane(scol, tcol)
            if scol > tcol:
                chan_src = sx - 15 - (edge_idx % 3) * 6
                chan_tgt = tx + tw + 15 + (edge_idx % 3) * 6
                path_points = [(sx, sy + 20), (chan_src, sy + 20), (chan_src, highway_y), (chan_tgt, highway_y), (chan_tgt, ty + 20), (tx + tw, ty + 20)]
            else:
                chan_src = sx + sw + 15 + (edge_idx % 3) * 6
                chan_tgt = tx - 15 - (edge_idx % 3) * 6
                path_points = [(sx + sw, sy + 20), (chan_src, sy + 20), (chan_src, highway_y), (chan_tgt, highway_y), (chan_tgt, ty + 20), (tx, ty + 20)]
        else:
            highway_y = get_bot_lane(scol, tcol)
            if scol > tcol:
                chan_src = sx - 15 - (edge_idx % 3) * 6
                chan_tgt = tx + tw + 15 + (edge_idx % 3) * 6
                path_points = [(sx, sy + sh - 20), (chan_src, sy + sh - 20), (chan_src, highway_y), (chan_tgt, highway_y), (chan_tgt, ty + th - 20), (tx + tw, ty + th - 20)]
            else:
                chan_src = sx + sw + 15 + (edge_idx % 3) * 6
                chan_tgt = tx - 15 - (edge_idx % 3) * 6
                path_points = [(sx + sw, sy + sh - 20), (chan_src, sy + sh - 20), (chan_src, highway_y), (chan_tgt, highway_y), (chan_tgt, ty + th - 20), (tx, ty + th - 20)]

    # Format SVG path string
    d_str = f"M {path_points[0][0]} {path_points[0][1]}"
    for pt in path_points[1:]:
        d_str += f" L {pt[0]} {pt[1]}"
        
    svg_parts.append(f'''
    <path d="{d_str}" fill="none" stroke="{stroke_color}" stroke-width="{stroke_w}" stroke-opacity="0.65" marker-end="{marker_end}"/>
    ''')
    edge_idx += 1

# 2. Draw Table Cards
for tname, (tx, ty) in table_positions.items():
    tw, th = table_dimensions[tname]
    cols = get_selected_cols(tname)
    hcolor = table_domain_colors.get(tname, '#455A64')
    
    svg_parts.append(f'''
    <!-- Table: {tname} -->
    <g id="table-{tname}" transform="translate({tx}, {ty})">
      <!-- Card Background -->
      <rect x="0" y="0" width="{tw}" height="{th}" rx="6" fill="#FFFFFF" stroke="{hcolor}" stroke-width="1.6" filter="url(#card-shadow)"/>
      
      <!-- Table Header -->
      <path d="M 0 6 Q 0 0 6 0 L {tw-6} 0 Q {tw} 0 {tw} 6 L {tw} 28 L 0 28 Z" fill="{hcolor}"/>
      <text x="{tw/2}" y="19" font-size="11.5" font-weight="bold" fill="#FFFFFF" text-anchor="middle" letter-spacing="0.3">{tname}</text>
    ''')
    
    # Rows
    row_y = 44
    for c in cols:
        badge = ''
        badge_bg = '#F1F5F9'
        badge_fg = '#64748B'
        if c['is_pk']:
            badge = 'PK'
            badge_bg = '#FEE2E2'
            badge_fg = '#DC2626'
        elif c['is_fk']:
            badge = 'FK'
            badge_bg = '#DBEAFE'
            badge_fg = '#2563EB'
        elif c['is_unique']:
            badge = 'UQ'
            badge_bg = '#DCFCE7'
            badge_fg = '#16A34A'
            
        name_weight = '700' if (c['is_pk'] or c['is_unique']) else '500'
        name_color = '#0F172A' if c['is_pk'] else '#1E293B'
        
        type_clean = c['type'].lower()
        if 'varying' in type_clean:
            type_clean = type_clean.replace('character varying', 'varchar')
        elif 'timestamp' in type_clean:
            type_clean = 'timestamptz' if 'with time zone' in c.get('raw', '') or 'tz' in type_clean else 'timestamp'
        elif 'boolean' in type_clean:
            type_clean = 'bool'
            
        svg_parts.append(f'''
        <!-- Row: {c['name']} -->
        <line x1="8" y1="{row_y + 4}" x2="{tw - 8}" y2="{row_y + 4}" stroke="#F1F5F9" stroke-width="1"/>
        ''')
        if badge:
            svg_parts.append(f'''
        <rect x="10" y="{row_y - 10}" width="20" height="13" rx="2.5" fill="{badge_bg}"/>
        <text x="20" y="{row_y}" font-size="8.5" font-weight="bold" fill="{badge_fg}" text-anchor="middle">{badge}</text>
            ''')
            
        svg_parts.append(f'''
        <text x="36" y="{row_y}" font-size="10" font-weight="{name_weight}" fill="{name_color}">{html.escape(c['name'])}</text>
        <text x="{tw - 12}" y="{row_y}" font-size="9" font-weight="400" fill="#94A3B8" text-anchor="end">{html.escape(type_clean)}</text>
        ''')
        row_y += ROW_HEIGHT
        
    svg_parts.append('    </g>\n')

svg_parts.append('</svg>')

svg_content = ''.join(svg_parts)
OUTPUT_SVG = os.path.join(os.path.dirname(__file__), 'easyhouse-erd.svg')
with open(OUTPUT_SVG, 'w', encoding='utf-8') as f:
    f.write(svg_content)
print(f"Generated clean SVG: {OUTPUT_SVG} ({len(svg_content)} bytes)")

# Generate Interactive HTML Viewer
html_content = f'''<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>EasyHouse — Sơ đồ quan hệ thực thể (ERD)</title>
  <script src="https://cdn.jsdelivr.net/npm/panzoom@9.4.3/dist/panzoom.min.js"></script>
  <style>
    * {{ margin: 0; padding: 0; box-sizing: border-box; }}
    body {{
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background-color: #0F172A;
      color: #F8FAFC;
      overflow: hidden;
      height: 100vh;
      display: flex;
      flex-direction: column;
    }}
    header {{
      background: #1E293B;
      padding: 12px 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 1px solid #334155;
      z-index: 10;
    }}
    .title h1 {{ font-size: 16px; font-weight: 700; color: #38BDF8; }}
    .title p {{ font-size: 12px; color: #94A3B8; margin-top: 2px; }}
    .controls {{ display: flex; gap: 8px; align-items: center; }}
    .btn {{
      background: #334155;
      color: #F8FAFC;
      border: 1px solid #475569;
      padding: 6px 14px;
      border-radius: 6px;
      font-size: 12px;
      font-weight: 600;
      cursor: pointer;
      text-decoration: none;
      transition: background 0.15s;
    }}
    .btn:hover {{ background: #475569; }}
    .btn-primary {{ background: #0284C7; border-color: #0284C7; }}
    .btn-primary:hover {{ background: #0369A1; }}
    #viewport {{
      flex: 1;
      overflow: hidden;
      position: relative;
      cursor: grab;
      background-color: #0B1120;
    }}
    #viewport:active {{ cursor: grabbing; }}
    #svg-container {{
      transform-origin: 0 0;
      display: inline-block;
      padding: 20px;
    }}
  </style>
</head>
<body>
  <header>
    <div class="title">
      <h1>EASYHOUSE — SƠ ĐỒ QUAN HỆ THỰC THỂ (ERD ĐẦY ĐỦ 56 BẢNG)</h1>
      <p>Nguồn: sql/schema.sql • 115 Khóa ngoại • Bố cục gọn gàng không cắt qua bảng</p>
    </div>
    <div class="controls">
      <button class="btn" onclick="zoomIn()">➕ Phóng to</button>
      <button class="btn" onclick="zoomOut()">➖ Thu nhỏ</button>
      <button class="btn" onclick="resetZoom()">🔄 Vừa màn hình</button>
      <a href="easyhouse-erd.drawio" download class="btn">Tải file .drawio</a>
      <a href="easyhouse-erd.svg" download class="btn" style="background:#10B981;margin-left:6px;">Tải file .svg</a>
    </div>
  </header>
  <div id="viewport">
    <div id="svg-container">
      {svg_content}
    </div>
  </div>
  <script>
    const container = document.getElementById('svg-container');
    const pz = panzoom(container, {{
      maxZoom: 6,
      minZoom: 0.15,
      bounds: false,
      initialZoom: 0.38,
      initialX: 30,
      initialY: 30
    }});
    function zoomIn() {{ pz.smoothZoom(window.innerWidth / 2, window.innerHeight / 2, 1.3); }}
    function zoomOut() {{ pz.smoothZoom(window.innerWidth / 2, window.innerHeight / 2, 0.75); }}
    function resetZoom() {{ pz.moveTo(30, 30); pz.zoomAbs(30, 30, 0.38); }}
  </script>
</body>
</html>
'''

OUTPUT_HTML = os.path.join(os.path.dirname(__file__), 'easyhouse-erd-preview.html')
with open(OUTPUT_HTML, 'w', encoding='utf-8') as f:
    f.write(html_content)
print(f"Generated HTML preview: {OUTPUT_HTML}")

# Generate High-Resolution PNG via Playwright
OUTPUT_PNG = os.path.join(os.path.dirname(__file__), 'easyhouse-erd.png')
try:
    print("Exporting high-resolution PNG with Playwright & Chrome...")
    pw_path = os.path.join(os.path.dirname(__file__), '..', 'frontend', 'node_modules', 'playwright').replace('\\', '/')
    svg_uri = OUTPUT_SVG.replace('\\', '/')
    png_uri = OUTPUT_PNG.replace('\\', '/')
    chrome_path = "C:/Program Files/Google/Chrome/Application/chrome.exe"
    pw_script = f'''
const {{ chromium }} = require('{pw_path}');
(async () => {{
  const browser = await chromium.launch({{ executablePath: '{chrome_path}' }});
  const page = await browser.newPage({{ viewport: {{ width: {CANVAS_WIDTH}, height: {CANVAS_HEIGHT} }} }});
  await page.goto('file:///{svg_uri}');
  await page.screenshot({{ path: '{png_uri}', fullPage: true }});
  await browser.close();
  console.log("PNG generated successfully.");
}})();
'''
    subprocess.run(['node', '-e', pw_script], check=True)
    print(f"Generated PNG: {OUTPUT_PNG}")
except Exception as e:
    print(f"Could not generate PNG automatically: {e}")

# Copy all generated artifacts to user Downloads folder
DOWNLOADS_DIR = os.path.join(os.path.expanduser('~'), 'Downloads')
if os.path.exists(DOWNLOADS_DIR):
    for src_f in [OUTPUT_SVG, OUTPUT_HTML, OUTPUT_PNG, os.path.join(os.path.dirname(__file__), 'easyhouse-erd.drawio')]:
        if os.path.exists(src_f):
            dest_f = os.path.join(DOWNLOADS_DIR, os.path.basename(src_f))
            shutil.copy2(src_f, dest_f)
            print(f"Copied to Downloads: {dest_f}")
