import { StyleSheet, Text, View } from "react-native";
import { ListScreen } from "@/components/ListScreen";
import { Badge, Card, Row } from "@/components/ui";
import { useList } from "@/lib/useList";
import { formatDate, incidentStatus } from "@/lib/format";
import { colors } from "@/theme";
import type { SuCo } from "@/types";

export default function ManagerSuCo() {
  const { items, loading, refreshing, error, refresh } = useList<SuCo>("/api/su-co", {
    limit: 50,
  });

  return (
    <ListScreen
      items={items}
      loading={loading}
      refreshing={refreshing}
      error={error}
      onRefresh={refresh}
      keyExtractor={(sc) => sc._id}
      emptyText="Chưa có sự cố nào"
      renderItem={(sc) => {
        const st = incidentStatus(sc.trangThai);
        return (
          <Card>
            <View style={styles.header}>
              <Text style={styles.title}>{sc.tieuDe ?? "Sự cố"}</Text>
              <Badge label={st.label} tone={st.tone} />
            </View>
            {sc.moTa ? <Text style={styles.desc}>{sc.moTa}</Text> : null}
            <Row label="Phòng" value={sc.phong?.maPhong ?? "—"} />
            <Row label="Người báo" value={sc.nguoiBaoCao?.hoTen ?? "—"} />
            <Row label="Ưu tiên" value={sc.mucDoUuTien ?? "—"} />
            <Row label="Ngày báo" value={formatDate(sc.ngayBaoCao)} />
          </Card>
        );
      }}
    />
  );
}

const styles = StyleSheet.create({
  header: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    marginBottom: 6,
  },
  title: { fontSize: 16, fontWeight: "800", color: colors.text, flexShrink: 1, paddingRight: 8 },
  desc: { color: colors.textMuted, fontSize: 14, marginBottom: 6 },
});
