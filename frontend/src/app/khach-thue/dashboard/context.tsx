'use client';

import { createContext, useContext, useState, useEffect, useCallback, ReactNode } from 'react';
import { TenantDashboardData } from '@/types';
import { useSession } from 'next-auth/react';
import { toast } from 'sonner';
import { chatSocket } from '@/lib/ws-client';

interface TenantContextType {
  data: TenantDashboardData | null;
  loading: boolean;
  error: string | null;
  refreshData: () => Promise<void>;
}

const TenantContext = createContext<TenantContextType>({
  data: null,
  loading: true,
  error: null,
  refreshData: async () => {},
});

export function TenantProvider({ children }: { children: ReactNode }) {
  const session = useSession()?.data;
  const [data, setData] = useState<TenantDashboardData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const refreshData = useCallback(async () => {
    if (!session?.accessToken) return;
    try {
      setLoading(true);
      setError(null);
      const res = await fetch('/api/backend-auth/khach-thue/me', {
        headers: {
          'Authorization': `Bearer ${session.accessToken}`,
        },
      });
      const result = await res.json();
      if (result.success) {
        setData(result.data);
      } else {
        throw new Error(result.message || 'Không tải được thông tin cư dân');
      }
    } catch (error) {
      console.error('Lỗi khi tải thông tin:', error);
      const message = error instanceof Error ? error.message : 'Có lỗi xảy ra khi tải dữ liệu';
      setError(message);
      toast.error(message);
    } finally {
      setLoading(false);
    }
  }, [session?.accessToken]);

  useEffect(() => {
    if (session?.accessToken) {
      refreshData();
      
      chatSocket.connect();
      const unsub = chatSocket.onThongBao(() => {
        refreshData();
        toast.info('Bạn có thông báo mới');
      });
      
      return () => {
        unsub();
      };
    } else if (session === null) {
      setLoading(false);
    }
  }, [session, refreshData]);

  return (
    <TenantContext.Provider value={{ data, loading, error, refreshData }}>
      {children}
    </TenantContext.Provider>
  );
}

export function useTenantDashboard() {
  return useContext(TenantContext);
}
