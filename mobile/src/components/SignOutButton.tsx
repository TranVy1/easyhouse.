import { Alert, TouchableOpacity } from "react-native";
import { Ionicons } from "@expo/vector-icons";
import { useAuth } from "@/auth/AuthContext";
import { colors, spacing } from "@/theme";

export function SignOutButton() {
  const { signOut } = useAuth();
  const confirm = () => {
    Alert.alert("Đăng xuất", "Bạn có chắc muốn đăng xuất?", [
      { text: "Huỷ", style: "cancel" },
      { text: "Đăng xuất", style: "destructive", onPress: () => void signOut() },
    ]);
  };
  return (
    <TouchableOpacity onPress={confirm} style={{ paddingHorizontal: spacing.md }}>
      <Ionicons name="log-out-outline" size={24} color={colors.danger} />
    </TouchableOpacity>
  );
}
