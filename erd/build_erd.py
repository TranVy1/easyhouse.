import re
import os
import sys
import html
import subprocess

if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

# 1. Parse sql/schema.sql
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

# Add explicit 1-1 relations requested by user if not already in fk_list
# chu_tro -> nguoi_dung (chu_tro has UNIQUE nguoi_dung_id)
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

# Set explicit 1-1 flags as mandated by user prompt:
# chu_tro-nguoi_dung, khach_thue-nguoi_dung, quyet_toan_tra_phong-hoa_don, quyet_toan_tra_phong-hop_dong, giao_dich_tien_coc-thanh_toan
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

print(f"Total Tables: {len(tables)}, Total FK relationships: {len(fk_list)}")

# 2. Clusters Configuration
clusters_config = {
    'A': {
        'id': 'cluster_A',
        'code': 'A',
        'name': 'A. Người dùng, phân quyền & bảo mật',
        'color_bg': '#F0F8FF',       # Alice Blue
        'color_border': '#0288D1',   # Ocean Blue
        'color_header': '#0288D1',   # Deep Ocean Blue
        'color_table_header': '#0288D1',
        'color_edge': '#0288D1',
        'tables': ['nguoi_dung', 'vai_tro', 'nguoi_dung_vai_tro', 'chu_tro', 'nguoi_dung_nha_tro', 'refresh_token', 'email_verification_token', 'login_history', 'chan_nguoi_dung', 'dang_ky_push', 'audit_log'],
        'grid_cols': 3,
        'pos_x': 60,
        'pos_y': 60,
        'width': 1050,
        'height': 920
    },
    'G': {
        'id': 'cluster_G',
        'code': 'G',
        'name': 'G. Thông báo',
        'color_bg': '#FFFDE7',       # Soft Yellow
        'color_border': '#F57F17',   # Amber Dark
        'color_header': '#F57F17',
        'color_table_header': '#F57F17',
        'color_edge': '#F57F17',
        'tables': ['thong_bao', 'thong_bao_nguoi_nhan', 'notification_delivery'],
        'grid_cols': 1,
        'pos_x': 1170,
        'pos_y': 60,
        'width': 440,
        'height': 920
    },
    'H': {
        'id': 'cluster_H',
        'code': 'H',
        'name': 'H. Trò chuyện & tin nhắn',
        'color_bg': '#F3E5F5',       # Soft Purple
        'color_border': '#8E24AA',   # Purple
        'color_header': '#8E24AA',
        'color_table_header': '#8E24AA',
        'color_edge': '#8E24AA',
        'tables': ['cuoc_tro_chuyen', 'thanh_vien_cuoc_tro_chuyen', 'tin_nhan', 'bao_cao_tin_nhan', 'file_media'],
        'grid_cols': 2,
        'pos_x': 1670,
        'pos_y': 60,
        'width': 780,
        'height': 920
    },
    'B': {
        'id': 'cluster_B',
        'code': 'B',
        'name': 'B. Nhà trọ, tầng, phòng & tiện ích',
        'color_bg': '#F1F8E9',       # Soft Green
        'color_border': '#388E3C',   # Forest Green
        'color_header': '#2E7D32',
        'color_table_header': '#2E7D32',
        'color_edge': '#2E7D32',
        'tables': ['nha_tro', 'tang', 'phong', 'tien_ich', 'phong_tien_ich', 'kho_tai_san', 'tai_san_phong', 'lich_su_kho_tai_san'],
        'grid_cols': 3,
        'pos_x': 60,
        'pos_y': 1040,
        'width': 1050,
        'height': 880
    },
    'C': {
        'id': 'cluster_C',
        'code': 'C',
        'name': 'C. Khách thuê & hợp đồng',
        'color_bg': '#FFF8E1',       # Soft Warm Amber
        'color_border': '#E65100',   # Dark Orange
        'color_header': '#E65100',
        'color_table_header': '#E65100',
        'color_edge': '#E65100',
        'tables': ['khach_thue', 'hop_dong', 'thanh_vien_hop_dong', 'phu_luc_hop_dong', 'contract_signature', 'dat_coc_phong', 'yeu_cau_o_ghep', 'lich_hen'],
        'grid_cols': 3,
        'pos_x': 1170,
        'pos_y': 1040,
        'width': 1080,
        'height': 880
    },
    'D': {
        'id': 'cluster_D',
        'code': 'D',
        'name': 'D. Dịch vụ & chỉ số điện nước',
        'color_bg': '#E0F2F1',       # Soft Teal
        'color_border': '#00897B',   # Teal
        'color_header': '#00695C',
        'color_table_header': '#00695C',
        'color_edge': '#00695C',
        'tables': ['dich_vu', 'dich_vu_hop_dong', 'cau_hinh_gia', 'cau_hinh_phi_xe', 'chi_so_dien_nuoc', 'meter_anomaly_alert'],
        'grid_cols': 2,
        'pos_x': 2310,
        'pos_y': 1040,
        'width': 740,
        'height': 880
    },
    'F': {
        'id': 'cluster_F',
        'code': 'F',
        'name': 'F. Sự cố & phương tiện',
        'color_bg': '#EDE7F6',       # Soft Indigo
        'color_border': '#5E35B1',   # Indigo
        'color_header': '#4527A0',
        'color_table_header': '#4527A0',
        'color_edge': '#4527A0',
        'tables': ['su_co', 'phuong_tien', 'lich_su_phuong_tien'],
        'grid_cols': 1,
        'pos_x': 60,
        'pos_y': 1980,
        'width': 440,
        'height': 940
    },
    'E': {
        'id': 'cluster_E',
        'code': 'E',
        'name': 'E. Hóa đơn & thanh toán',
        'color_bg': '#FCE4EC',       # Soft Rose Pink
        'color_border': '#D81B60',   # Rose Ruby
        'color_header': '#C2185B',
        'color_table_header': '#C2185B',
        'color_edge': '#C2185B',
        'tables': ['hoa_don', 'chi_tiet_hoa_don', 'lich_su_hoa_don', 'thanh_toan', 'lich_thanh_toan', 'invoice_generation_batch', 'invoice_generation_log', 'bank_transaction', 'debt_reminder_log', 'giao_dich_tien_coc', 'quyet_toan_tra_phong', 'chi_tiet_ban_giao_tai_san'],
        'grid_cols': 4,
        'pos_x': 560,
        'pos_y': 1980,
        'width': 1560,
        'height': 940
    }
}

tbl_to_cluster = {}
for cid, cdata in clusters_config.items():
    for t in cdata['tables']:
        tbl_to_cluster[t] = cid

print("Cluster setup validated.")
