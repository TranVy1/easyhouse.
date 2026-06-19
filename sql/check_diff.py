import re

with open('db.sql', 'r', encoding='utf-8') as f:
    db = f.read()

with open('backups.sql', 'r', encoding='utf-8') as f:
    bk = f.read()

db_tables = set(re.findall(r'COPY "?[a-zA-Z_]+"?\."?([a-zA-Z_]+)"? \(', db))
bk_tables = set(re.findall(r'COPY "?[a-zA-Z_]+"?\."?([a-zA-Z_]+)"? \(', bk))

missing = db_tables - bk_tables
print('Tables in db.sql but missing in backups.sql:', missing)
