import { useCallback, useEffect, useState } from "react";
import { RefreshControl, ScrollView, StyleSheet, Text, View } from "react-native";
import { api } from "@/api/client";
import { useAuth } from "@/auth/AuthContext";
import { Card, EmptyState, Loading, SectionTitle, StatCard } from "@/components/ui";
import { formatCurrency } from "@/lib/format";
import { colors, spacing } from "@/theme";
import type { DashboardStats } from "@/types";

export default function ManagerDashboard() {
  const { session } = useAuth();
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async (isRefresh: boolean) => {
    isRefresh ? setRefreshing(true) : setLoading(true);
    setError(null);
    try {
      const data = await api.get<DashboardStats>("/api/dashboard/stats");
      setStats(data);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Không tải được thống kê");
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, []);

  useEffect(() => {
    void load(false);
  }, [load]);

  if (loading) return <Loading />;

  return (
    <ScrollView
      style={{ backgroundColor: colors.bg }}
      contentContainerStyle={styles.container}
      refreshControl={
        <RefreshControl refreshing={refreshing} onRefresh={() => load(true)} />
      }
    >
      <Text style={styles.greeting}>Xin chào, {session?.hoTen} 👋</Text>

      {error ? <EmptyState text={error} /> : null}

      {stats ? (
        <>
          <SectionTitle>Phòng</SectionTitle>
          <View style={styles.grid}>
            <StatCard label="Tổng số phòng" value={stats.tongSoPhong} tone="info" />
            <StatCard label="Đang thuê" value={stats.phongDangThue} tone="success" />
            <StatCard label="Còn trống" value={stats.phongTrong} tone="warning" />
            <StatCard label="Bảo trì" value={stats.phongBaoTri} tone="danger" />
          </View>

          <SectionTitle>Doanh thu</SectionTitle>
          <Card>
            <View style={styles.moneyRow}>
              <View>
                <Text style={styles.moneyLabel}>Tháng này</Text>
                <Text style={styles.moneyValue}>{formatCurrency(stats.doanhThuThang)}</Text>
              </View>
              <View>
                <Text style={styles.moneyLabel}>Năm nay</Text>
                <Text style={styles.moneyValue}>{formatCurrency(stats.doanhThuNam)}</Text>
              </View>
            </View>
            <View style={[styles.moneyRow, { marginTop: spacing.md }]}>
              <View>
                <Text style={styles.moneyLabel}>Đã thu</Text>
                <Text style={[styles.moneyValueSm, { color: colors.success }]}>
                  {formatCurrency(stats.tienDaThu)}
                </Text>
              </View>
              <View>
                <Text style={styles.moneyLabel}>Chưa thu</Text>
                <Text style={[styles.moneyValueSm, { color: colors.danger }]}>
                  {formatCurrency(stats.tienChuaThu)}
                </Text>
              </View>
            </View>
          </Card>

          <SectionTitle>Cần chú ý</SectionTitle>
          <View style={styles.grid}>
            <StatCard label="Hoá đơn sắp đến hạn" value={stats.hoaDonSapDenHan} tone="warning" />
            <StatCard label="Sự cố cần xử lý" value={stats.suCoCanXuLy} tone="danger" />
            <StatCard label="HĐ sắp hết hạn" value={stats.hopDongSapHetHan} tone="warning" />
            <StatCard label="Khách đang thuê" value={stats.tongKhachDangThue} tone="info" />
          </View>
        </>
      ) : null}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { padding: spacing.lg, paddingBottom: spacing.xl },
  greeting: { fontSize: 18, fontWeight: "700", color: colors.text, marginBottom: spacing.sm },
  grid: { flexDirection: "row", flexWrap: "wrap", gap: spacing.md },
  moneyRow: { flexDirection: "row", justifyContent: "space-between" },
  moneyLabel: { fontSize: 13, color: colors.textMuted },
  moneyValue: { fontSize: 20, fontWeight: "800", color: colors.brand, marginTop: 2 },
  moneyValueSm: { fontSize: 16, fontWeight: "700", marginTop: 2 },
});
