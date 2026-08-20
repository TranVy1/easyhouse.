import re
import os
import sys

if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

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
for tbl, c_name, cols in uniques:
    col_list = [c.strip().strip('"') for c in cols.split(',')]
    if tbl in tables:
        for c in tables[tbl]:
            if c['name'] in col_list:
                c['is_unique'] = True

# Parse FKs
fks = re.findall(r'ALTER\s+TABLE\s+(?:ONLY\s+)?(?:public\.)?([a-zA-Z0-9_]+)\s+ADD\s+CONSTRAINT\s+([a-zA-Z0-9_]+)\s+FOREIGN\s+KEY\s*\(([^)]+)\)\s+REFERENCES\s+(?:public\.)?([a-zA-Z0-9_]+)\s*\(([^)]+)\)', sql, re.IGNORECASE)
for src_tbl, c_name, src_cols, tgt_tbl, tgt_cols in fks:
    src_c = [c.strip().strip('"') for c in src_cols.split(',')]
    tgt_clean = tgt_cols.strip().replace('"', '')
    if src_tbl in tables:
        for c in tables[src_tbl]:
            if c['name'] in src_c:
                c['is_fk'] = True
                c['fk_target'] = f"{tgt_tbl}.{tgt_clean}"

# Explicit missing FKs if any
if 'chu_tro' in tables:
    for c in tables['chu_tro']:
        if c['name'] == 'nguoi_dung_id':
            c['is_fk'] = True
            c['fk_target'] = 'nguoi_dung.id'

print(f"Total tables parsed from schema.sql: {len(tables)}")
print("Tables list:", list(tables.keys()))
