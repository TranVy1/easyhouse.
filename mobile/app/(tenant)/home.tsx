import { useCallback, useEffect, useState } from "react";
import { RefreshControl, ScrollView, StyleSheet, Text, View } from "react-native";
import { api } from "@/api/client";
import { Badge, Card, EmptyState, Loading, Row, SectionTitle, StatCard } from "@/components/ui";
import { formatCurrency, formatDate, invoiceStatus } from "@/lib/format";
import { colors, spacing } from "@/theme";
import type { KhachThueDashboard } from "@/types";

export default function TenantHome() {
  const [data, setData] = useState<KhachThueDashboard | null>(null);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async (isRefresh: boolean) => {
    isRefresh ? setRefreshing(true) : setLoading(true);
    setError(null);
    try {
      const res = await api.get<KhachThueDashboard>("/api/auth/khach-thue/me");
      setData(res);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Không tải được dữ liệu");
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, []);

  useEffect(() => {
    void load(false);
  }, [load]);

  if (loading) return <Loading />;
  if (!data) return <EmptyState text={error ?? "Không có dữ liệu"} />;

  const hd = data.hoaDonGanNhat;
  const st = invoiceStatus(hd?.trangThai);
  const contract = data.hopDongHienTai;
  const room = contract?.phong;

  return (
    <ScrollView
      style={{ backgroundColor: colors.bg }}
      contentContainerStyle={styles.container}
      refreshControl={<RefreshControl refreshing={refreshing} onRefresh={() => load(true)} />}
    >
      <Text style={styles.greeting}>Xin chào, {data.khachThue?.hoTen ?? "bạn"} 👋</Text>

      <View style={styles.grid}>
        <StatCard label="Hoá đơn chưa TT" value={data.soHoaDonChuaThanhToan} tone="danger" />
        <StatCard label="Sự cố đang mở" value={data.soSuCoDangMo} tone="warning" />
        <StatCard label="Thông báo mới" value={data.soThongBaoMoi} tone="info" />
      </View>

      <SectionTitle>Phòng đang thuê</SectionTitle>
      <Card>
        <Row label="Phòng" value={room?.maPhong ?? "—"} />
        <Row label="Toà nhà" value={room?.toaNha?.tenToaNha ?? "—"} />
        <Row label="Giá thuê" value={formatCurrency(room?.giaThue)} />
        <Row label="Mã hợp đồng" value={contract?.maHopDong ?? "—"} />
        <Row label="Bắt đầu" value={formatDate(contract?.ngayBatDau)} />
        <Row label="Kết thúc" value={formatDate(contract?.ngayKetThuc)} />
        <Row label="Tiền cọc" value={formatCurrency(contract?.tienCoc)} />
      </Card>

      <SectionTitle>Hoá đơn gần nhất</SectionTitle>
      <Card>
        {hd ? (
          <>
            <View style={styles.rowBetween}>
              <Text style={styles.invoiceCode}>{hd.maHoaDon ?? "Hoá đơn"}</Text>
              <Badge label={st.label} tone={st.tone} />
            </View>
            <Row label="Kỳ" value={`${hd.thang}/${hd.nam}`} />
            <Row
              label="Tổng tiền"
              value={formatCurrency(hd.tongTien)}
              valueStyle={{ color: colors.brand, fontWeight: "800" }}
            />
          </>
        ) : (
          <Text style={{ color: colors.textMuted }}>Chưa có hoá đơn</Text>
        )}
      </Card>

      {data.lienHe ? (
        <>
          <SectionTitle>Liên hệ chủ trọ</SectionTitle>
          <Card>
            <Row label="Họ tên" value={data.lienHe.hoTen ?? "—"} />
            <Row label="Điện thoại" value={data.lienHe.soDienThoai ?? "—"} />
            <Row label="Email" value={data.lienHe.email ?? "—"} />
          </Card>
        </>
      ) : null}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { padding: spacing.lg, paddingBottom: spacing.xl },
  greeting: { fontSize: 18, fontWeight: "700", color: colors.text, marginBottom: spacing.md },
  grid: { flexDirection: "row", flexWrap: "wrap", gap: spacing.md },
  rowBetween: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    marginBottom: 6,
  },
  invoiceCode: { fontSize: 16, fontWeight: "800", color: colors.text },
});
