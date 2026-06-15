with open('backups_inserts_fixed.sql', 'r', encoding='utf-8') as f:
    lines = f.readlines()

phong = [l for l in lines if 'INSERT INTO "public"."phong"' in l]
print(f"Phong lines count: {len(phong)}")
