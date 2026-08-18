import sys
if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

from erd.parse_schema import tables

for tname, cols in sorted(tables.items()):
    all_col_names = [c['name'] for c in cols]
    print(f"{tname:<28} ({len(cols):2d} cols): {', '.join(all_col_names)}")
