with open('backups_inserts.sql', 'r', encoding='utf-8') as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if 'INSERT INTO "public"."phong"' in l:
        print(f"Phong inserts start around line {i+1}")
        break
