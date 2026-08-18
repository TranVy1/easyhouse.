import sys
if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

from erd.parse_schema import fk_list, tables, clusters, tbl_to_cluster

print(f"Total FKs in schema.sql: {len(fk_list)}")

cluster_fks = {}
for fk in fk_list:
    src_t = fk["source_table"]
    tgt_t = fk["target_table"]
    src_c = tbl_to_cluster.get(src_t, "?")
    tgt_c = tbl_to_cluster.get(tgt_t, "?")
    key = (src_c, tgt_c)
    cluster_fks.setdefault(key, []).append(fk)

print("\n=== FK DISTRIBUTION ACROSS CLUSTERS ===")
for (sc, tc), fks in sorted(cluster_fks.items()):
    sc_name = clusters.get(sc, {}).get('name', sc)
    tc_name = clusters.get(tc, {}).get('name', tc)
    rel_type = "INTRA" if sc == tc else "INTER"
    print(f"[{rel_type}] Cluster {sc} -> Cluster {tc} ({len(fks)} FKs):")
    for fk in fks:
        src = f"{fk['source_table']}({','.join(fk['source_cols'])})"
        tgt = f"{fk['target_table']}({','.join(fk['target_cols'])})"
        print(f"    - {src:<40} -> {tgt:<35} [1-1: {fk['is_one_to_one']}]")
