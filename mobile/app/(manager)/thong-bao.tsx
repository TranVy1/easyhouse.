import { StyleSheet, Text } from "react-native";
import { ListScreen } from "@/components/ListScreen";
import { Card } from "@/components/ui";
import { useList } from "@/lib/useList";
import { formatDate } from "@/lib/format";
import { colors } from "@/theme";
import type { ThongBao } from "@/types";

export default function ManagerThongBao() {
  const { items, loading, refreshing, error, refresh } = useList<ThongBao>("/api/thong-bao", {
    limit: 50,
  });

  return (
    <ListScreen
      items={items}
      loading={loading}
      refreshing={refreshing}
      error={error}
      onRefresh={refresh}
      keyExtractor={(tb) => tb._id}
      emptyText="Chưa có thông báo nào"
      renderItem={(tb) => (
        <Card>
          <Text style={styles.title}>{tb.tieuDe ?? "Thông báo"}</Text>
          {tb.noiDung ? <Text style={styles.body}>{tb.noiDung}</Text> : null}
          <Text style={styles.date}>{formatDate(tb.ngayTao)}</Text>
        </Card>
      )}
    />
  );
}

const styles = StyleSheet.create({
  title: { fontSize: 16, fontWeight: "800", color: colors.text, marginBottom: 4 },
  body: { color: colors.text, fontSize: 14, lineHeight: 20 },
  date: { color: colors.textMuted, fontSize: 12, marginTop: 8 },
});
