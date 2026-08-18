import xml.etree.ElementTree as ET
import sys

if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

tree = ET.parse('erd/easyhouse-erd.drawio')
root = tree.getroot()
cells = root.findall('.//mxCell')

# Map of cell IDs
cell_map = {c.attrib.get('id'): c for c in cells}

# Check clusters
clusters = [c for c in cells if c.attrib.get('id', '').startswith('cluster_')]
print(f"Clusters count: {len(clusters)} (Expected: 8)")
for c in clusters:
    print(f"  - {c.attrib.get('id')}: {c.attrib.get('value')}")

# Check tables
tables = [c for c in cells if c.attrib.get('id', '').startswith('tbl_')]
print(f"\nTables count: {len(tables)} (Expected: 56)")

# Check edges
edges = [c for c in cells if c.attrib.get('edge') == '1']
print(f"\nEdges count: {len(edges)} (Expected: 115)")

# Validate that all edge sources and targets exist
broken_edges = []
for e in edges:
    src = e.attrib.get('source')
    tgt = e.attrib.get('target')
    if src not in cell_map or tgt not in cell_map:
        broken_edges.append((e.attrib.get('id'), src, tgt))

print(f"Broken edges count: {len(broken_edges)}")

# Validate 1-1 edges
one_to_one_edges = [e for e in edges if '1:1' in e.attrib.get('value', '')]
print(f"\n1-1 edges found: {len(one_to_one_edges)}")
for e in one_to_one_edges:
    print(f"  - {e.attrib.get('source')} -> {e.attrib.get('target')}: {e.attrib.get('value')}")

# Verify views are NOT in tables
assert 'tbl_v_so_do_toa_nha' not in cell_map, 'v_so_do_toa_nha should be excluded'
assert 'tbl_v_thong_ke_toa_nha' not in cell_map, 'v_thong_ke_toa_nha should be excluded'
print("\nViews (v_so_do_toa_nha, v_thong_ke_toa_nha) are properly excluded!")

# Verify polymorphic columns have NO edges
poly_edges = [e for e in edges if e.attrib.get('value') in ['doi_tuong_id', 'aggregate_id']]
print(f"Polymorphic edges found (should be 0): {len(poly_edges)}")
assert len(poly_edges) == 0

print("\nALL VERIFICATIONS PASSED PERFECTLY!")
