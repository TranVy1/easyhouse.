'use client';

import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { TenantDashboardData } from '@/types';
import { useSession } from 'next-auth/react';
import { toast } from 'sonner';

interface TenantContextType {
  data: TenantDashboardData | null;
  loading: boolean;
  refreshData: () => Promise<void>;
}

const TenantContext = createContext<TenantContextType>({
  data: null,
  loading: true,
  refreshData: async () => {},
});

export function TenantProvider({ children }: { children: ReactNode }) {
  const session = useSession()?.data;
  const [data, setData] = useState<TenantDashboardData | null>(null);
  const [loading, setLoading] = useState(true);

  const refreshData = async () => {
    if (!session?.accessToken) return;
    try {
      setLoading(true);
      const res = await fetch('/api/auth/khach-thue/me', {
        headers: {
          'Authorization': `Bearer ${session.accessToken}`,
        },
      });
      const result = await res.json();
      if (result.success) {
        setData(result.data);
      }
    } catch (error) {
      console.error('Lỗi khi tải thông tin:', error);
      toast.error('Có lỗi xảy ra khi tải dữ liệu');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (session?.accessToken) {
      refreshData();
    } else if (session === null) {
      setLoading(false);
    }
  }, [session]);

  return (
    <TenantContext.Provider value={{ data, loading, refreshData }}>
      {children}
    </TenantContext.Provider>
  );
}

export function useTenantDashboard() {
  return useContext(TenantContext);
}
