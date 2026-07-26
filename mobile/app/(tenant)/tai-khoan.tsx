import { ScrollView, StyleSheet, Text, View } from "react-native";
import { Ionicons } from "@expo/vector-icons";
import { useAuth } from "@/auth/AuthContext";
import { Button, Card, Row } from "@/components/ui";
import { colors, radius, spacing } from "@/theme";

export default function TenantAccount() {
  const { session, signOut } = useAuth();

  return (
    <ScrollView
      style={{ backgroundColor: colors.bg }}
      contentContainerStyle={styles.container}
    >
      <View style={styles.avatarWrap}>
        <View style={styles.avatar}>
          <Ionicons name="person" size={40} color={colors.brand} />
        </View>
        <Text style={styles.name}>{session?.hoTen}</Text>
        <Text style={styles.role}>Khách thuê</Text>
      </View>

      <Card>
        <Row label="Số điện thoại" value={session?.soDienThoai ?? "—"} />
        <Row label="Email" value={session?.email ?? "—"} />
      </Card>

      <Button
        title="Đăng xuất"
        variant="ghost"
        onPress={() => void signOut()}
        style={{ marginTop: spacing.md }}
      />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { padding: spacing.lg },
  avatarWrap: { alignItems: "center", marginBottom: spacing.lg },
  avatar: {
    width: 80,
    height: 80,
    borderRadius: radius.full,
    backgroundColor: colors.brandLight,
    alignItems: "center",
    justifyContent: "center",
    marginBottom: spacing.sm,
  },
  name: { fontSize: 18, fontWeight: "800", color: colors.text },
  role: { fontSize: 14, color: colors.textMuted },
});
