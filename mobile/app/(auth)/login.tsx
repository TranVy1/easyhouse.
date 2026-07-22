import { useState } from "react";
import {
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { useAuth } from "@/auth/AuthContext";
import { loginManager, loginTenant } from "@/api/auth";
import { Button } from "@/components/ui";
import { colors, radius, spacing } from "@/theme";

type Mode = "manager" | "tenant";

export default function LoginScreen() {
  const { signIn } = useAuth();
  const insets = useSafeAreaInsets();
  const [mode, setMode] = useState<Mode>("manager");
  const [identifier, setIdentifier] = useState(""); // email or phone
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const onSubmit = async () => {
    setError(null);
    if (!identifier.trim() || !password) {
      setError("Vui lòng nhập đầy đủ thông tin đăng nhập.");
      return;
    }
    setLoading(true);
    try {
      const session =
        mode === "manager"
          ? await loginManager(identifier.trim(), password)
          : await loginTenant(identifier.trim(), password);
      await signIn(session);
      // Root navigator redirects based on role.
    } catch (e) {
      setError(e instanceof Error ? e.message : "Đăng nhập thất bại.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <KeyboardAvoidingView
      style={{ flex: 1, backgroundColor: colors.brand }}
      behavior={Platform.OS === "ios" ? "padding" : undefined}
    >
      <ScrollView
        contentContainerStyle={[styles.container, { paddingTop: insets.top + 48 }]}
        keyboardShouldPersistTaps="handled"
      >
        <Text style={styles.logo}>EasyHouse</Text>
        <Text style={styles.subtitle}>Quản lý phòng trọ trong tầm tay</Text>

        <View style={styles.card}>
          <View style={styles.switcher}>
            <SwitchTab
              active={mode === "manager"}
              label="Chủ trọ / Nhân viên"
              onPress={() => setMode("manager")}
            />
            <SwitchTab
              active={mode === "tenant"}
              label="Khách thuê"
              onPress={() => setMode("tenant")}
            />
          </View>

          <Text style={styles.label}>
            {mode === "manager" ? "Email" : "Số điện thoại"}
          </Text>
          <TextInput
            style={styles.input}
            value={identifier}
            onChangeText={setIdentifier}
            autoCapitalize="none"
            keyboardType={mode === "manager" ? "email-address" : "phone-pad"}
            placeholder={mode === "manager" ? "email@example.com" : "09xxxxxxxx"}
            placeholderTextColor={colors.textMuted}
          />

          <Text style={styles.label}>Mật khẩu</Text>
          <TextInput
            style={styles.input}
            value={password}
            onChangeText={setPassword}
            secureTextEntry
            placeholder="••••••••"
            placeholderTextColor={colors.textMuted}
          />

          {error ? <Text style={styles.error}>{error}</Text> : null}

          <Button
            title="Đăng nhập"
            onPress={onSubmit}
            loading={loading}
            style={{ marginTop: spacing.md }}
          />
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

function SwitchTab({
  active,
  label,
  onPress,
}: {
  active: boolean;
  label: string;
  onPress: () => void;
}) {
  return (
    <TouchableOpacity
      style={[styles.switchTab, active && styles.switchTabActive]}
      onPress={onPress}
      activeOpacity={0.8}
    >
      <Text style={[styles.switchTabText, active && styles.switchTabTextActive]}>
        {label}
      </Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: { flexGrow: 1, paddingHorizontal: spacing.lg, paddingBottom: spacing.xl },
  logo: { fontSize: 34, fontWeight: "900", color: "#fff", textAlign: "center" },
  subtitle: {
    color: colors.brandLight,
    textAlign: "center",
    marginTop: spacing.xs,
    marginBottom: spacing.xl,
  },
  card: {
    backgroundColor: colors.surface,
    borderRadius: radius.lg,
    padding: spacing.lg,
  },
  switcher: {
    flexDirection: "row",
    backgroundColor: colors.bg,
    borderRadius: radius.md,
    padding: 4,
    marginBottom: spacing.lg,
  },
  switchTab: {
    flex: 1,
    paddingVertical: 10,
    borderRadius: radius.sm,
    alignItems: "center",
  },
  switchTabActive: { backgroundColor: colors.brand },
  switchTabText: { fontSize: 13, fontWeight: "700", color: colors.textMuted },
  switchTabTextActive: { color: "#fff" },
  label: {
    fontSize: 13,
    fontWeight: "600",
    color: colors.text,
    marginBottom: spacing.xs,
    marginTop: spacing.sm,
  },
  input: {
    height: 48,
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: radius.md,
    paddingHorizontal: spacing.md,
    fontSize: 15,
    color: colors.text,
    backgroundColor: colors.surface,
  },
  error: { color: colors.danger, marginTop: spacing.md, fontSize: 13 },
});
