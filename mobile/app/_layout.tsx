// PHẢI nạp polyfill TRƯỚC mọi thứ khác: @stomp/stompjs cần TextDecoder mà Hermes
// không có sẵn. Nạp muộn thì lỗi sẽ hiện ra từ sâu trong thư viện, rất khó lần ngược.
import "@/lib/polyfills";

import { Slot, useRootNavigationState, useRouter, useSegments } from "expo-router";
import { useEffect } from "react";
import { StatusBar } from "expo-status-bar";
import { SafeAreaProvider } from "react-native-safe-area-context";
import { AuthProvider, useAuth } from "@/auth/AuthContext";
import { isManagerRole } from "@/api/auth";
import { Loading } from "@/components/ui";

function RootNavigator() {
  const { session, initializing } = useAuth();
  const segments = useSegments();
  const navState = useRootNavigationState();
  const router = useRouter();

  useEffect(() => {
    // Wait until auth is resolved AND the navigator is actually mounted,
    // otherwise router.replace throws "navigate before mounting".
    if (initializing || !navState?.key) return;

    const group = segments[0]; // "(auth)" | "(manager)" | "(tenant)" | undefined
    const inAuth = group === "(auth)";

    if (!session) {
      if (!inAuth) router.replace("/(auth)/login");
      return;
    }

    const isManager = isManagerRole(session.role);
    const target = isManager ? "(manager)" : "(tenant)";
    if (group !== target) {
      router.replace(isManager ? "/(manager)/dashboard" : "/(tenant)/home");
    }
  }, [session, initializing, segments, navState?.key]);

  if (initializing) return <Loading />;
  return <Slot />;
}

export default function RootLayout() {
  return (
    <SafeAreaProvider>
      <AuthProvider>
        <StatusBar style="dark" />
        <RootNavigator />
      </AuthProvider>
    </SafeAreaProvider>
  );
}
