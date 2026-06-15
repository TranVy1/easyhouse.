import re

with open('backups.sql', 'r', encoding='utf-8') as f:
    data = f.read()

tables = re.findall(r'-- Data for Name: (.+?);', data)
copy_tables = re.findall(r'COPY "?[a-zA-Z_]+"?\."?([a-zA-Z_]+)"? \(', data)

missing = [t for t in tables if t not in copy_tables]
print('Missing in backups.sql:', missing)
