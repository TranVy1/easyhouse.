import React, { createContext, useContext, useEffect, useMemo, useState } from "react";
import type { Session } from "@/types";
import { clearSession, loadSession, saveSession } from "./storage";
import { configureClient, setClientSession } from "@/api/client";
import { logout as apiLogout } from "@/api/auth";

interface AuthState {
  session: Session | null;
  initializing: boolean;
  signIn: (session: Session) => Promise<void>;
  signOut: () => Promise<void>;
}

const AuthContext = createContext<AuthState | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [session, setSession] = useState<Session | null>(null);
  const [initializing, setInitializing] = useState(true);

  // Called by the api client when it refreshes or invalidates a token.
  const handleClientSessionChange = (next: Session | null) => {
    setSession(next);
    if (next) void saveSession(next);
    else void clearSession();
  };

  useEffect(() => {
    (async () => {
      const stored = await loadSession();
      setSession(stored);
      configureClient({ session: stored, onSessionChange: handleClientSessionChange });
      setInitializing(false);
    })();
  }, []);

  // Keep the client's in-memory token in sync with React state.
  useEffect(() => {
    setClientSession(session);
  }, [session]);

  const signIn = async (next: Session) => {
    await saveSession(next);
    setClientSession(next);
    setSession(next);
  };

  const signOut = async () => {
    await apiLogout();
    await clearSession();
    setClientSession(null);
    setSession(null);
  };

  const value = useMemo<AuthState>(
    () => ({ session, initializing, signIn, signOut }),
    [session, initializing]
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthState {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
}
