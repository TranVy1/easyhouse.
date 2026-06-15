with open('backups.sql', 'r', encoding='utf-8') as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if 'COPY "public"."phong"' in line:
        print(f"Found at line {i+1}: {line}")
        print("Next 5 lines:")
        for j in range(1, 6):
            if i+j < len(lines):
                print(f"{i+j+1}: {repr(lines[i+j])}")
