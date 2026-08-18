import os
import sys
import html
import shutil
import subprocess
from erd.generate_erd_full import (
    table_positions, table_dimensions, tables, get_selected_cols,
    fk_list, table_domain_colors, CANVAS_WIDTH, CANVAS_HEIGHT, ROW_HEIGHT
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
<g id="canvas-header" transform="translate(50, 15)">
  <text x="0" y="20" font-size="20" font-weight="800" fill="#0F172A" letter-spacing="-0.5">EASYHOUSE — SƠ ĐỒ QUAN HỆ THỰC THỂ (ERD)</text>
  <text x="0" y="36" font-size="11" font-weight="500" fill="#64748B">sql/schema.sql • 56 Bảng • 115 Khóa ngoại • Bố cục gọn gàng &amp; trực quan</text>
  
  <!-- Legend -->
  <g transform="translate({CANVAS_WIDTH - 850}, 0)">
    <rect x="0" y="0" width="800" height="36" rx="6" fill="#FFFFFF" stroke="#E2E8F0" filter="url(#card-shadow)"/>
    <text x="16" y="22" font-size="11" font-weight="700" fill="#334155">CHÚ THÍCH:</text>
    
    <rect x="95" y="10" width="24" height="16" rx="3" fill="#FEE2E2"/>
    <text x="107" y="22" font-size="9" font-weight="bold" fill="#DC2626" text-anchor="middle">PK</text>
    <text x="125" y="22" font-size="10.5" fill="#475569">Khóa chính</text>
    
    <rect x="200" y="10" width="24" height="16" rx="3" fill="#DBEAFE"/>
    <text x="212" y="22" font-size="9" font-weight="bold" fill="#2563EB" text-anchor="middle">FK</text>
    <text x="230" y="22" font-size="10.5" fill="#475569">Khóa ngoại</text>
    
    <rect x="305" y="10" width="24" height="16" rx="3" fill="#DCFCE7"/>
    <text x="317" y="22" font-size="9" font-weight="bold" fill="#16A34A" text-anchor="middle">UQ</text>
    <text x="335" y="22" font-size="10.5" fill="#475569">Duy nhất (Unique)</text>
    
    <line x1="450" y1="18" x2="490" y2="18" stroke="#64748B" stroke-width="2"/>
    <text x="496" y="22" font-size="10.5" fill="#475569">Quan hệ 1 - N</text>
    
    <line x1="590" y1="18" x2="630" y2="18" stroke="#EA580C" stroke-width="2.5"/>
    <text x="636" y="22" font-size="10.5" font-weight="bold" fill="#EA580C">Quan hệ 1 - 1</text>
  </g>
</g>
''')

# 1. Draw Foreign Key Connectors (Edges)
for fk in fk_list:
    src_tbl = fk['source_table']
    tgt_tbl = fk['target_table']
    
    if src_tbl not in table_positions or tgt_tbl not in table_positions:
        continue
        
    sx, sy = table_positions[src_tbl]
    sw, sh = table_dimensions[src_tbl]
    tx, ty = table_positions[tgt_tbl]
    tw, th = table_dimensions[tgt_tbl]
    
    src_center_x = sx + sw / 2
    src_center_y = sy + sh / 2
    tgt_center_x = tx + tw / 2
    tgt_center_y = ty + th / 2
    
    # Calculate edge connection points
    if abs(src_center_x - tgt_center_x) > abs(src_center_y - tgt_center_y):
        if src_center_x < tgt_center_x:
            x1, y1 = sx + sw, src_center_y
            x2, y2 = tx, tgt_center_y
        else:
            x1, y1 = sx, src_center_y
            x2, y2 = tx + tw, tgt_center_y
    else:
        if src_center_y < tgt_center_y:
            x1, y1 = src_center_x, sy + sh
            x2, y2 = tgt_center_x, ty
        else:
            x1, y1 = src_center_x, sy
            x2, y2 = tgt_center_x, ty + th
            
    is_1to1 = fk.get('is_one_to_one', False)
    hcolor = table_domain_colors.get(src_tbl, '#64748B')
    stroke_color = '#EA580C' if is_1to1 else hcolor
    stroke_w = '2' if is_1to1 else '1.3'
    marker_end = 'url(#arrow-1to1)' if is_1to1 else 'url(#arrow-many)'
    
    # Orthogonal or curved path
    mid_x = (x1 + x2) / 2
    path_d = f"M {x1} {y1} C {mid_x} {y1}, {mid_x} {y2}, {x2} {y2}"
    
    svg_parts.append(f'''
    <path d="{path_d}" fill="none" stroke="{stroke_color}" stroke-width="{stroke_w}" stroke-opacity="0.55" marker-end="{marker_end}"/>
    ''')

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
            
        type_clean = c['type'].lower()
        if 'varying' in type_clean:
            type_clean = type_clean.replace('character varying', 'varchar')
        elif 'timestamp' in type_clean:
            type_clean = 'timestamptz'
        elif 'boolean' in type_clean:
            type_clean = 'bool'
            
        col_name_style = 'font-weight:600;fill:#0F172A;' if (c['is_pk'] or c['is_unique']) else 'fill:#334155;'
        
        # Badge pill if PK/FK/UQ
        if badge:
            svg_parts.append(f'''
            <rect x="7" y="{row_y-10}" width="18" height="12" rx="2.5" fill="{badge_bg}"/>
            <text x="16" y="{row_y-1}" font-size="8" font-weight="bold" fill="{badge_fg}" text-anchor="middle">{badge}</text>
            ''')
            
        # Column name
        svg_parts.append(f'''
        <text x="30" y="{row_y-1}" font-size="10" {col_name_style} font-family="Consolas, monospace">{html.escape(c['name'])}</text>
        <text x="{tw-8}" y="{row_y-1}" font-size="8.5" fill="#94A3B8" text-anchor="end" font-family="Consolas, monospace">{html.escape(type_clean)}</text>
        <line x1="7" y1="{row_y+3}" x2="{tw-7}" y2="{row_y+3}" stroke="#F1F5F9" stroke-width="1"/>
        ''')
        row_y += ROW_HEIGHT
        
    svg_parts.append('</g>')

svg_parts.append('</svg>')

svg_content = '\n'.join(svg_parts)
OUTPUT_SVG = os.path.join(os.path.dirname(__file__), 'easyhouse-erd.svg')
with open(OUTPUT_SVG, 'w', encoding='utf-8') as f:
    f.write(svg_content)

print(f"Generated SVG: {OUTPUT_SVG} ({len(svg_content)} bytes)")

# Create an HTML viewer for interactive viewing in browser
html_viewer = f'''<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>EasyHouse Database ERD</title>
  <style>
    body {{
      margin: 0;
      padding: 16px;
      background-color: #0F172A;
      color: #F8FAFC;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      overflow: auto;
    }}
    .header {{
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 15px;
      padding: 10px 20px;
      background: #1E293B;
      border-radius: 8px;
    }}
    .btn {{
      background: #3B82F6;
      color: white;
      border: none;
      padding: 8px 16px;
      border-radius: 6px;
      cursor: pointer;
      font-weight: 600;
      text-decoration: none;
      display: inline-block;
    }}
    .btn:hover {{ background: #2563EB; }}
    .svg-container {{
      background: #F8FAFC;
      border-radius: 10px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.3);
      display: inline-block;
      min-width: {CANVAS_WIDTH}px;
    }}
  </style>
</head>
<body>
  <div class="header">
    <div>
      <h2 style="margin:0;font-size:18px;">EasyHouse Database ERD — 56 Bảng (Bố cục gọn gàng)</h2>
      <span style="font-size:12px;color:#94A3B8;">Xem chi tiết ERD dạng vector SVG hoặc mở file .drawio trên app.diagrams.net</span>
    </div>
    <div>
      <a href="easyhouse-erd.drawio" download class="btn">Tải file .drawio</a>
      <a href="easyhouse-erd.svg" download class="btn" style="background:#10B981;margin-left:10px;">Tải file .svg</a>
    </div>
  </div>
  <div class="svg-container">
    {svg_content}
  </div>
</body>
</html>
'''

OUTPUT_HTML = os.path.join(os.path.dirname(__file__), 'easyhouse-erd-preview.html')
with open(OUTPUT_HTML, 'w', encoding='utf-8') as f:
    f.write(html_viewer)

print(f"Generated HTML preview: {OUTPUT_HTML}")

# Try rendering PNG using Headless Chrome or Edge
browser_paths = [
    r"C:\Program Files\Google\Chrome\Application\chrome.exe",
    r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    r"C:\Program Files\Microsoft\Edge\Application\msedge.exe"
]

OUTPUT_PNG = os.path.join(os.path.dirname(__file__), 'easyhouse-erd.png')
for bpath in browser_paths:
    if os.path.exists(bpath):
        print(f"Rendering PNG using browser: {bpath}")
        cmd = [
            bpath,
            "--headless",
            "--disable-gpu",
            "--hide-scrollbars",
            f"--window-size={CANVAS_WIDTH+40},{CANVAS_HEIGHT+80}",
            f"--screenshot={OUTPUT_PNG}",
            OUTPUT_HTML
        ]
        res = subprocess.run(cmd, capture_output=True, text=True)
        if res.returncode == 0 and os.path.exists(OUTPUT_PNG):
            print(f"Generated PNG screenshot: {OUTPUT_PNG} ({os.path.getsize(OUTPUT_PNG)} bytes)")
            break

# Copy all updated files to Downloads
user_profile = os.environ.get('USERPROFILE', r'C:\Users\Admin')
downloads_dir = os.path.join(user_profile, 'Downloads')
for src_f in [OUTPUT_SVG, OUTPUT_HTML, OUTPUT_PNG, os.path.join(os.path.dirname(__file__), 'easyhouse-erd.drawio')]:
    if os.path.exists(src_f):
        dst = os.path.join(downloads_dir, os.path.basename(src_f))
        shutil.copy2(src_f, dst)
        print(f"Updated Downloads file: {dst}")
