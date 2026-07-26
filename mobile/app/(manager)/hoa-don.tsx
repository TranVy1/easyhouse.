import { StyleSheet, Text, View } from "react-native";
import { ListScreen } from "@/components/ListScreen";
import { Badge, Card, Row } from "@/components/ui";
import { useList } from "@/lib/useList";
import { formatCurrency, formatDate, invoiceStatus } from "@/lib/format";
import { colors } from "@/theme";
import type { HoaDon } from "@/types";

function roomLabel(hd: HoaDon): string {
  const p = hd.phong as { maPhong?: string; ten?: string } | undefined;
  return p?.maPhong ?? p?.ten ?? "—";
}

export default function ManagerHoaDon() {
  const { items, loading, refreshing, error, refresh } = useList<HoaDon>("/api/hoa-don", {
    limit: 50,
  });

  return (
    <ListScreen
      items={items}
      loading={loading}
      refreshing={refreshing}
      error={error}
      onRefresh={refresh}
      keyExtractor={(hd) => hd._id}
      emptyText="Chưa có hoá đơn nào"
      renderItem={(hd) => {
        const st = invoiceStatus(hd.trangThai);
        return (
          <Card>
            <View style={styles.header}>
              <Text style={styles.title}>{hd.maHoaDon ?? "Hoá đơn"}</Text>
              <Badge label={st.label} tone={st.tone} />
            </View>
            <Row label="Phòng" value={roomLabel(hd)} />
            <Row label="Kỳ" value={`${hd.kyThang ?? hd.thang ?? "?"}/${hd.kyNam ?? hd.nam ?? "?"}`} />
            <Row
              label="Tổng tiền"
              value={formatCurrency(hd.tongTien)}
              valueStyle={{ color: colors.brand, fontWeight: "800" }}
            />
            <Row label="Còn lại" value={formatCurrency(hd.conLai)} />
            <Row label="Hạn thanh toán" value={formatDate(hd.hanThanhToan ?? hd.hanTra)} />
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
  title: { fontSize: 16, fontWeight: "800", color: colors.text },
});
