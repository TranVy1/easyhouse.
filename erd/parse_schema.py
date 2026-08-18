import re
import json
import sys

if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

with open('sql/schema.sql', 'r', encoding='utf-8') as f:
    sql = f.read()

# 1. Parse tables
table_blocks = re.findall(r'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?(?:public\.)?([a-zA-Z0-9_]+)\s*\((.*?)\);', sql, re.DOTALL | re.IGNORECASE)

tables = {}
for tbl_name, body in table_blocks:
    lines = [l.strip() for l in body.split('\n') if l.strip()]
    columns = []
    for l in lines:
        l_clean = l.rstrip(',')
        if re.match(r'^(PRIMARY\s+KEY|FOREIGN\s+KEY|CONSTRAINT|UNIQUE|CHECK)', l_clean, re.IGNORECASE):
            continue
        # Extract column name and type
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
                'is_not_null': is_not_null,
                'raw': l_clean
            })
    tables[tbl_name] = columns

# 2. Parse constraints from ALTER TABLE
pks = re.findall(r'ALTER\s+TABLE\s+(?:ONLY\s+)?(?:public\.)?([a-zA-Z0-9_]+)\s+ADD\s+CONSTRAINT\s+([a-zA-Z0-9_]+)\s+PRIMARY\s+KEY\s*\(([^)]+)\);', sql, re.IGNORECASE)
for tbl, c_name, cols in pks:
    col_list = [c.strip().strip('"') for c in cols.split(',')]
    if tbl in tables:
        for c in tables[tbl]:
            if c['name'] in col_list:
                c['is_pk'] = True

uniques = re.findall(r'ALTER\s+TABLE\s+(?:ONLY\s+)?(?:public\.)?([a-zA-Z0-9_]+)\s+ADD\s+CONSTRAINT\s+([a-zA-Z0-9_]+)\s+UNIQUE\s*\(([^)]+)\);', sql, re.IGNORECASE)
unique_map = {}
for tbl, c_name, cols in uniques:
    col_list = [c.strip().strip('"') for c in cols.split(',')]
    unique_map.setdefault(tbl, []).append((c_name, col_list))
    if tbl in tables:
        for c in tables[tbl]:
            if c['name'] in col_list:
                c['is_unique'] = True

fks = re.findall(r'ALTER\s+TABLE\s+(?:ONLY\s+)?(?:public\.)?([a-zA-Z0-9_]+)\s+ADD\s+CONSTRAINT\s+([a-zA-Z0-9_]+)\s+FOREIGN\s+KEY\s*\(([^)]+)\)\s+REFERENCES\s+(?:public\.)?([a-zA-Z0-9_]+)\s*\(([^)]+)\)(?:\s+ON\s+DELETE\s+([a-zA-Z\s]+?))?(?:\s+ON\s+UPDATE\s+([a-zA-Z\s]+?))?;', sql, re.IGNORECASE)

fk_list = []
for src_tbl, c_name, src_cols, tgt_tbl, tgt_cols, on_del, on_upd in fks:
    src_c = [c.strip().strip('"') for c in src_cols.split(',')]
    tgt_c = [c.strip().strip('"') for c in tgt_cols.split(',')]
    fk_list.append({
        'name': c_name,
        'source_table': src_tbl,
        'source_cols': src_c,
        'target_table': tgt_tbl,
        'target_cols': tgt_c,
        'on_delete': on_del.strip() if on_del else None,
        'on_update': on_upd.strip() if on_upd else None,
    })
    if src_tbl in tables:
        for c in tables[src_tbl]:
            if c['name'] in src_c:
                c['is_fk'] = True
                c['fk_target'] = f"{tgt_tbl}.{tgt_c[0]}"

print(f"Parsed {len(tables)} tables, {len(pks)} PKs, {len(uniques)} UNIQUEs, {len(fk_list)} FKs.")

# Check for any tables in fk_list not in tables
missing_src = set(fk['source_table'] for fk in fk_list) - set(tables.keys())
missing_tgt = set(fk['target_table'] for fk in fk_list) - set(tables.keys())
print("Missing FK sources:", missing_src)
print("Missing FK targets:", missing_tgt)

clusters = {
    'A': {'name': 'A. Người dùng, phân quyền & bảo mật', 'tables': ['nguoi_dung', 'vai_tro', 'nguoi_dung_vai_tro', 'chu_tro', 'nguoi_dung_nha_tro', 'refresh_token', 'email_verification_token', 'login_history', 'chan_nguoi_dung', 'dang_ky_push', 'audit_log']},
    'B': {'name': 'B. Nhà trọ, tầng, phòng & tiện ích', 'tables': ['nha_tro', 'tang', 'phong', 'tien_ich', 'phong_tien_ich', 'kho_tai_san', 'tai_san_phong', 'lich_su_kho_tai_san']},
    'C': {'name': 'C. Khách thuê & hợp đồng', 'tables': ['khach_thue', 'hop_dong', 'thanh_vien_hop_dong', 'phu_luc_hop_dong', 'contract_signature', 'dat_coc_phong', 'yeu_cau_o_ghep', 'lich_hen']},
    'D': {'name': 'D. Dịch vụ & chỉ số điện nước', 'tables': ['dich_vu', 'dich_vu_hop_dong', 'cau_hinh_gia', 'cau_hinh_phi_xe', 'chi_so_dien_nuoc', 'meter_anomaly_alert']},
    'E': {'name': 'E. Hóa đơn & thanh toán', 'tables': ['hoa_don', 'chi_tiet_hoa_don', 'lich_su_hoa_don', 'thanh_toan', 'lich_thanh_toan', 'invoice_generation_batch', 'invoice_generation_log', 'bank_transaction', 'debt_reminder_log', 'giao_dich_tien_coc', 'quyet_toan_tra_phong', 'chi_tiet_ban_giao_tai_san']},
    'F': {'name': 'F. Sự cố & phương tiện', 'tables': ['su_co', 'phuong_tien', 'lich_su_phuong_tien']},
    'G': {'name': 'G. Thông báo', 'tables': ['thong_bao', 'thong_bao_nguoi_nhan', 'notification_delivery']},
    'H': {'name': 'H. Trò chuyện & tin nhắn', 'tables': ['cuoc_tro_chuyen', 'thanh_vien_cuoc_tro_chuyen', 'tin_nhan', 'bao_cao_tin_nhan', 'file_media']}
}

tbl_to_cluster = {}
for cid, cdata in clusters.items():
    for t in cdata['tables']:
        tbl_to_cluster[t] = cid

print("\n=== 1-1 RELATIONSHIPS (Unique FK) ===")
for fk in fk_list:
    src_t = fk['source_table']
    src_cols = fk['source_cols']
    tgt_t = fk['target_table']
    is_unique = False
    if src_t in unique_map:
        for cname, ucols in unique_map[src_t]:
            if set(src_cols) == set(ucols):
                is_unique = True
                break
    for pk_t, pk_c, pk_cols in pks:
        if pk_t == src_t and set(src_cols) == set([c.strip().strip('"') for c in pk_cols.split(',')]):
            is_unique = True
            break
    fk['is_one_to_one'] = is_unique
    if is_unique:
        print(f"1-1: {src_t}.{src_cols} -> {tgt_t}.{fk['target_cols']} ({fk['name']})")

intra_count = 0
inter_count = 0
for fk in fk_list:
    c_src = tbl_to_cluster.get(fk['source_table'], '?')
    c_tgt = tbl_to_cluster.get(fk['target_table'], '?')
    if c_src == c_tgt:
        intra_count += 1
    else:
        inter_count += 1
print(f"\nIntra-cluster FKs: {intra_count}, Inter-cluster FKs: {inter_count}, Total FKs: {len(fk_list)}")

print("\n================== TABLES BY CLUSTER ==================")
for cid, cdata in clusters.items():
    print(f"\n=== CLUSTER {cdata['name']} ({len(cdata['tables'])} tables) ===")
    for t in cdata['tables']:
        cols = tables.get(t, [])
        pk_cols = [c['name'] for c in cols if c['is_pk']]
        fk_cols = [c['name'] for c in cols if c['is_fk']]
        uq_cols = [c['name'] for c in cols if c['is_unique'] and not c['is_pk']]
        other_cols = [c['name'] for c in cols if not c['is_pk'] and not c['is_fk'] and not c['is_unique']]
        print(f"  {t:<28} | PK: {','.join(pk_cols):<15} | FK: {','.join(fk_cols):<35} | UQ: {','.join(uq_cols):<20} | Other: {len(other_cols)} ({','.join(other_cols[:4])})")

