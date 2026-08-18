import re
import os
import sys
import html
import shutil
import subprocess

if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

# 1. Parse schema.sql
SCHEMA_FILE = os.path.join(os.path.dirname(__file__), '..', 'sql', 'schema.sql')
with open(SCHEMA_FILE, 'r', encoding='utf-8') as f:
    sql = f.read()

# Parse CREATE TABLE
table_blocks = re.findall(r'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?(?:public\.)?([a-zA-Z0-9_]+)\s*\((.*?)\);', sql, re.DOTALL | re.IGNORECASE)

tables = {}
for tbl_name, body in table_blocks:
    lines = [l.strip() for l in body.split('\n') if l.strip()]
    columns = []
    for l in lines:
        l_clean = l.rstrip(',')
        if re.match(r'^(PRIMARY\s+KEY|FOREIGN\s+KEY|CONSTRAINT|UNIQUE|CHECK)', l_clean, re.IGNORECASE):
            continue
        m = re.match(r'^"?([a-zA-Z0-9_]+)"?\s+([a-zA-Z0-9_]+(?:\([^\)]+\))?(?:\[\])?)(.*)', l_clean)
        if m:
            col_name = m.group(1)
            col_type = m.group(2)
            rest = m.group(3)
            is_pk = 'PRIMARY KEY' in rest.upper()
            is_unique = 'UNIQUE' in rest.upper()
            is_fk = 'REFERENCES' in rest.upper()
            is_not_null = 'NOT NULL' in rest.upper()
            columns.append({
                'name': col_name,
                'type': col_type,
                'is_pk': is_pk,
                'is_unique': is_unique,
                'is_fk': is_fk,
                'is_not_null': is_not_null
            })
    tables[tbl_name] = columns

# Parse PKs
pks = re.findall(r'ALTER\s+TABLE\s+(?:ONLY\s+)?(?:public\.)?([a-zA-Z0-9_]+)\s+ADD\s+CONSTRAINT\s+([a-zA-Z0-9_]+)\s+PRIMARY\s+KEY\s*\(([^)]+)\);', sql, re.IGNORECASE)
for tbl, c_name, cols in pks:
    col_list = [c.strip().strip('"') for c in cols.split(',')]
    if tbl in tables:
        for c in tables[tbl]:
            if c['name'] in col_list:
                c['is_pk'] = True

# Parse UNIQUEs
uniques = re.findall(r'ALTER\s+TABLE\s+(?:ONLY\s+)?(?:public\.)?([a-zA-Z0-9_]+)\s+ADD\s+CONSTRAINT\s+([a-zA-Z0-9_]+)\s+UNIQUE\s*\(([^)]+)\);', sql, re.IGNORECASE)
unique_map = {}
for tbl, c_name, cols in uniques:
    col_list = [c.strip().strip('"') for c in cols.split(',')]
    unique_map.setdefault(tbl, []).append((c_name, col_list))
    if tbl in tables:
        for c in tables[tbl]:
            if c['name'] in col_list:
                c['is_unique'] = True

# Parse FKs
fks = re.findall(r'ALTER\s+TABLE\s+(?:ONLY\s+)?(?:public\.)?([a-zA-Z0-9_]+)\s+ADD\s+CONSTRAINT\s+([a-zA-Z0-9_]+)\s+FOREIGN\s+KEY\s*\(([^)]+)\)\s+REFERENCES\s+(?:public\.)?([a-zA-Z0-9_]+)\s*\(([^)]+)\)(?:\s+ON\s+DELETE\s+([a-zA-Z\s]+?))?(?:\s+ON\s+UPDATE\s+([a-zA-Z\s]+?))?;', sql, re.IGNORECASE)

fk_list = []
for src_tbl, c_name, src_cols, tgt_tbl, tgt_cols, on_del, on_upd in fks:
    src_c = [c.strip().strip('"') for c in src_cols.split(',')]
    tgt_c = [c.strip().strip('"') for c in tgt_cols.split(',')]
    
    # Check if 1-1
    is_1to1 = False
    if src_tbl in unique_map:
        for u_name, u_cols in unique_map[src_tbl]:
            if set(src_c) == set(u_cols):
                is_1to1 = True
                break
    for pk_t, pk_c, pk_cols in pks:
        if pk_t == src_tbl and set(src_c) == set([c.strip().strip('"') for c in pk_cols.split(',')]):
            is_1to1 = True
            break
            
    fk_list.append({
        'name': c_name,
        'source_table': src_tbl,
        'source_cols': src_c,
        'target_table': tgt_tbl,
        'target_cols': tgt_c,
        'on_delete': on_del.strip() if on_del else None,
        'on_update': on_upd.strip() if on_upd else None,
        'is_one_to_one': is_1to1
    })
    if src_tbl in tables:
        for c in tables[src_tbl]:
            if c['name'] in src_c:
                c['is_fk'] = True
                c['fk_target'] = f"{tgt_tbl}.{tgt_c[0]}"

# Explicit 1-1 relations requested by user prompt
has_chu_tro_fk = any(fk['source_table'] == 'chu_tro' and fk['target_table'] == 'nguoi_dung' for fk in fk_list)
if not has_chu_tro_fk:
    fk_list.append({
        'name': 'chu_tro_nguoi_dung_id_fkey',
        'source_table': 'chu_tro',
        'source_cols': ['nguoi_dung_id'],
        'target_table': 'nguoi_dung',
        'target_cols': ['id'],
        'on_delete': None,
        'on_update': None,
        'is_one_to_one': True
    })
    if 'chu_tro' in tables:
        for c in tables['chu_tro']:
            if c['name'] == 'nguoi_dung_id':
                c['is_fk'] = True
                c['fk_target'] = 'nguoi_dung.id'

for fk in fk_list:
    pair = (fk['source_table'], fk['target_table'])
    if pair in [
        ('chu_tro', 'nguoi_dung'),
        ('khach_thue', 'nguoi_dung'),
        ('quyet_toan_tra_phong', 'hoa_don'),
        ('quyet_toan_tra_phong', 'hop_dong'),
        ('giao_dich_tien_coc', 'thanh_toan')
    ] and fk['source_cols'][0] in ['nguoi_dung_id', 'hoa_don_id', 'hop_dong_id', 'thanh_toan_id']:
        fk['is_one_to_one'] = True

print(f"Parsed {len(tables)} tables and {len(fk_list)} relationships.")

# 2. Table Theme Colors (Domain-based header colors for visual clarity)
table_domain_colors = {
    # Blue: User & Auth
    'nguoi_dung': '#0288D1', 'vai_tro': '#0288D1', 'nguoi_dung_vai_tro': '#0288D1', 'chu_tro': '#0288D1',
    'nguoi_dung_nha_tro': '#0288D1', 'refresh_token': '#0288D1', 'email_verification_token': '#0288D1',
    'login_history': '#0288D1', 'chan_nguoi_dung': '#0288D1', 'dang_ky_push': '#0288D1', 'audit_log': '#0288D1',
    
    # Green: House & Rooms & Assets
    'nha_tro': '#2E7D32', 'tang': '#2E7D32', 'phong': '#2E7D32', 'tien_ich': '#2E7D32', 'phong_tien_ich': '#2E7D32',
    'kho_tai_san': '#2E7D32', 'tai_san_phong': '#2E7D32', 'lich_su_kho_tai_san': '#2E7D32',
    
    # Orange: Tenants & Contracts & Prospects
    'khach_thue': '#E65100', 'hop_dong': '#E65100', 'thanh_vien_hop_dong': '#E65100', 'phu_luc_hop_dong': '#E65100',
    'contract_signature': '#E65100', 'dat_coc_phong': '#E65100', 'yeu_cau_o_ghep': '#E65100', 'lich_hen': '#E65100',
    
    # Teal: Services & Meters
    'dich_vu': '#00695C', 'dich_vu_hop_dong': '#00695C', 'cau_hinh_gia': '#00695C', 'cau_hinh_phi_xe': '#00695C',
    'chi_so_dien_nuoc': '#00695C', 'meter_anomaly_alert': '#00695C',
    
    # Crimson: Invoices & Settlements
    'hoa_don': '#C2185B', 'chi_tiet_hoa_don': '#C2185B', 'lich_su_hoa_don': '#C2185B', 'thanh_toan': '#C2185B',
    'lich_thanh_toan': '#C2185B', 'invoice_generation_batch': '#C2185B', 'invoice_generation_log': '#C2185B',
    'bank_transaction': '#C2185B', 'debt_reminder_log': '#C2185B', 'giao_dich_tien_coc': '#C2185B',
    'quyet_toan_tra_phong': '#C2185B', 'chi_tiet_ban_giao_tai_san': '#C2185B',
    
    # Indigo: Incidents & Vehicles
    'su_co': '#4527A0', 'phuong_tien': '#4527A0', 'lich_su_phuong_tien': '#4527A0',
    
    # Amber: Notifications
    'thong_bao': '#F57F17', 'thong_bao_nguoi_nhan': '#F57F17', 'notification_delivery': '#F57F17',
    
    # Purple: Chat & Messages
    'cuoc_tro_chuyen': '#6A1B9A', 'thanh_vien_cuoc_tro_chuyen': '#6A1B9A', 'tin_nhan': '#6A1B9A',
    'bao_cao_tin_nhan': '#6A1B9A', 'file_media': '#6A1B9A'
}

# 3. Compact 8-Column Layout (Organically arranged near related tables, NO outer boxes)
columns_layout = [
    # Col 0: Security & Auth Tokens (8)
    ['vai_tro', 'nguoi_dung_vai_tro', 'chan_nguoi_dung', 'dang_ky_push', 'refresh_token', 'email_verification_token', 'login_history', 'audit_log'],
    
    # Col 1: Users, Landlord & House Root (6)
    ['nguoi_dung', 'chu_tro', 'nguoi_dung_nha_tro', 'nha_tro', 'tang', 'phong'],
    
    # Col 2: Amenities, Warehouse, Assets & Vehicles (8)
    ['tien_ich', 'phong_tien_ich', 'kho_tai_san', 'tai_san_phong', 'lich_su_kho_tai_san', 'su_co', 'phuong_tien', 'lich_su_phuong_tien'],
    
    # Col 3: Tenants, Prospects & Contracts (8)
    ['khach_thue', 'dat_coc_phong', 'lich_hen', 'yeu_cau_o_ghep', 'hop_dong', 'thanh_vien_hop_dong', 'phu_luc_hop_dong', 'contract_signature'],
    
    # Col 4: Services, Tariffs & Meter Readings (6)
    ['dich_vu', 'dich_vu_hop_dong', 'cau_hinh_gia', 'cau_hinh_phi_xe', 'chi_so_dien_nuoc', 'meter_anomaly_alert'],
    
    # Col 5: Monthly Invoices & Contract Settlement (6)
    ['hoa_don', 'chi_tiet_hoa_don', 'lich_su_hoa_don', 'quyet_toan_tra_phong', 'chi_tiet_ban_giao_tai_san', 'giao_dich_tien_coc'],
    
    # Col 6: Payments, Bank Trans & Invoice Batching (7)
    ['thanh_toan', 'lich_thanh_toan', 'bank_transaction', 'invoice_generation_batch', 'invoice_generation_log', 'debt_reminder_log', 'thong_bao'],
    
    # Col 7: Notifications & Chat/Messaging (7)
    ['thong_bao_nguoi_nhan', 'notification_delivery', 'cuoc_tro_chuyen', 'thanh_vien_cuoc_tro_chuyen', 'tin_nhan', 'bao_cao_tin_nhan', 'file_media']
]

# 4. Helper to select columns for table card
def get_selected_cols(tname):
    cols = tables.get(tname, [])
    selected = []
    # 1. PK
    for c in cols:
        if c['is_pk']:
            selected.append(c)
    # 2. FK
    for c in cols:
        if c['is_fk'] and c not in selected:
            selected.append(c)
    # 3. UQ
    for c in cols:
        if c['is_unique'] and c not in selected:
            selected.append(c)
    # 4. Key business cols
    priority_keywords = ['ma_', 'ten', 'ho_ten', 'email', 'so_dien_thoai', 'so_cccd', 'trang_thai', 'loai', 'so_tien', 'tong_tien', 'gia_', 'tien_', 'ngay_', 'don_gia', 'chi_so_', 'tieu_thu', 'bien_so', 'tieu_de', 'status']
    for kw in priority_keywords:
        for c in cols:
            if c not in selected and kw in c['name'] and c['name'] not in ['xoa_luc', 'cap_nhat_luc', 'metadata']:
                selected.append(c)
    # 5. Remaining cols up to max 10
    for c in cols:
        if c not in selected and c['name'] not in ['xoa_luc', 'cap_nhat_luc', 'metadata', 'user_agent', 'ip_address']:
            selected.append(c)
    return selected[:10]

# Calculate layout coordinates
TABLE_WIDTH = 260
ROW_HEIGHT = 18
HEADER_HEIGHT = 30
PADDING_Y = 14
GAP_X = 54
GAP_Y = 22
MARGIN_X = 50
MARGIN_Y = 50

table_positions = {}
table_dimensions = {}

for col_idx, col_tables in enumerate(columns_layout):
    current_x = MARGIN_X + col_idx * (TABLE_WIDTH + GAP_X)
    current_y = MARGIN_Y
    for tname in col_tables:
        cols = get_selected_cols(tname)
        t_height = HEADER_HEIGHT + len(cols) * ROW_HEIGHT + PADDING_Y
        table_positions[tname] = (current_x, current_y)
        table_dimensions[tname] = (TABLE_WIDTH, t_height)
        current_y += t_height + GAP_Y

CANVAS_WIDTH = MARGIN_X * 2 + len(columns_layout) * TABLE_WIDTH + (len(columns_layout) - 1) * GAP_X
MAX_Y = max(y + table_dimensions[t][1] for t, (x, y) in table_positions.items())
CANVAS_HEIGHT = MAX_Y + MARGIN_Y

print(f"Canvas size: {CANVAS_WIDTH} x {CANVAS_HEIGHT}")

# 5. Generate Clean Draw.io XML without outer group containers
def generate_drawio_xml():
    xml_parts = []
    xml_parts.append('<?xml version="1.0" encoding="UTF-8"?>')
    xml_parts.append('<mxfile host="app.diagrams.net" modified="2026-08-18T12:00:00.000Z" agent="EasyHouse ERD Generator" version="24.0.0" type="device">')
    xml_parts.append('  <diagram id="easyhouse_erd_diagram" name="EasyHouse Database ERD">')
    xml_parts.append(f'    <mxGraphModel dx="2400" dy="1600" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="{CANVAS_WIDTH+100}" pageHeight="{CANVAS_HEIGHT+100}" math="0" shadow="0">')
    xml_parts.append('      <root>')
    xml_parts.append('        <mxCell id="0" />')
    xml_parts.append('        <mxCell id="1" parent="0" />')

    # 5.1 Table Entities (Directly on canvas, no outer boxes)
    for tname, (tx, ty) in table_positions.items():
        tw, th = table_dimensions[tname]
        cols = get_selected_cols(tname)
        hcolor = table_domain_colors.get(tname, '#455A64')
        
        # HTML label for table
        rows_html = []
        rows_html.append(f'<div style="background-color:{hcolor};color:#FFFFFF;font-weight:bold;padding:5px 8px;border-radius:3px;font-size:12px;letter-spacing:0.3px;text-align:center;font-family:Segoe UI,sans-serif;">{html.escape(tname)}</div>')
        rows_html.append('<table style="width:100%;border-collapse:collapse;margin-top:4px;font-family:Consolas,Courier New,monospace;font-size:10px;line-height:1.35;">')
        
        for c in cols:
            badge = ''
            badge_style = ''
            if c['is_pk']:
                badge = 'PK'
                badge_style = 'color:#D32F2F;font-weight:bold;'
            elif c['is_fk']:
                badge = 'FK'
                badge_style = 'color:#1976D2;font-weight:bold;'
            elif c['is_unique']:
                badge = 'UQ'
                badge_style = 'color:#2E7D32;font-weight:bold;'
            else:
                badge = ''
                badge_style = 'color:#9E9E9E;'
                
            name_style = 'font-weight:bold;color:#212121;' if (c['is_pk'] or c['is_unique']) else 'color:#37474F;'
            type_clean = c['type'].lower()
            if 'varying' in type_clean:
                type_clean = type_clean.replace('character varying', 'varchar')
            elif 'timestamp' in type_clean:
                type_clean = 'timestamptz' if 'with time zone' in c.get('raw', '') or 'tz' in type_clean else 'timestamp'
            elif 'boolean' in type_clean:
                type_clean = 'bool'
            
            rows_html.append(
                f'<tr style="border-bottom:1px solid #ECEFF1;">'
                f'<td style="width:22px;padding:2px 0;{badge_style}text-align:left;">{badge}</td>'
                f'<td style="padding:2px 4px;{name_style}">{html.escape(c["name"])}</td>'
                f'<td style="padding:2px 0;text-align:right;color:#78909C;font-size:9px;">{html.escape(type_clean)}</td>'
                f'</tr>'
            )
        rows_html.append('</table>')
        
        label_str = ''.join(rows_html)
        escaped_label = html.escape(label_str, quote=True)
        
        tbl_style = (
            f"shape=rectangle;whiteSpace=wrap;html=1;rounded=1;arcSize=4;shadow=1;"
            f"strokeColor={hcolor};strokeWidth=1.5;fillColor=#FFFFFF;"
            f"align=left;verticalAlign=top;spacing=6;overflow=hidden;"
        )
        
        xml_parts.append(
            f'        <mxCell id="tbl_{tname}" value="{escaped_label}" style="{tbl_style}" vertex="1" parent="1">'
            f'<mxGeometry x="{tx}" y="{ty}" width="{tw}" height="{th}" as="geometry" />'
            f'</mxCell>'
        )

    # 5.2 FK Edges (Connectors)
    edge_idx = 1
    for fk in fk_list:
        src_tbl = fk['source_table']
        tgt_tbl = fk['target_table']
        
        if src_tbl not in table_positions or tgt_tbl not in table_positions:
            continue
            
        hcolor = table_domain_colors.get(src_tbl, '#607D8B')
        is_1to1 = fk.get('is_one_to_one', False)
        
        # Styles
        if is_1to1:
            edge_style = (
                f"edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;"
                f"startArrow=ERmandOne;startFill=0;endArrow=ERone;endFill=0;"
                f"strokeColor=#EA580C;strokeWidth=2;dashed=0;fontSize=9;fontStyle=1;fontColor=#BF360C;"
            )
            edge_label = f"1:1 ({fk['source_cols'][0]})"
        else:
            edge_style = (
                f"edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;"
                f"startArrow=ERone;startFill=0;endArrow=ERmany;endFill=0;"
                f"strokeColor={hcolor};strokeWidth=1.2;fontSize=9;fontColor=#455A64;"
            )
            edge_label = fk['source_cols'][0]
            
        escaped_edge_label = html.escape(edge_label, quote=True)
        xml_parts.append(
            f'        <mxCell id="edge_{edge_idx}" value="{escaped_edge_label}" style="{edge_style}" edge="1" parent="1" source="tbl_{src_tbl}" target="tbl_{tgt_tbl}">'
            f'<mxGeometry relative="1" as="geometry" />'
            f'</mxCell>'
        )
        edge_idx += 1

    xml_parts.append('      </root>')
    xml_parts.append('    </mxGraphModel>')
    xml_parts.append('  </diagram>')
    xml_parts.append('</mxfile>')
    
    return '\n'.join(xml_parts)

# Write .drawio file
drawio_content = generate_drawio_xml()
OUTPUT_DRAWIO = os.path.join(os.path.dirname(__file__), 'easyhouse-erd.drawio')
with open(OUTPUT_DRAWIO, 'w', encoding='utf-8') as f:
    f.write(drawio_content)

print(f"Generated .drawio file: {OUTPUT_DRAWIO} ({len(drawio_content)} bytes)")
