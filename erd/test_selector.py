import sys
if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

from erd.build_erd import tables, clusters_config

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

for c_code, cdata in clusters_config.items():
    print(f"\n=== Cluster {cdata['name']} ===")
    for t in cdata['tables']:
        sel = get_selected_cols(t)
        names = [c['name'] for c in sel]
        print(f"  {t:<28} ({len(sel):2d} cols): {', '.join(names)}")
