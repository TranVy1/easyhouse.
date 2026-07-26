import { useCallback, useEffect, useState } from "react";
import { api } from "@/api/client";
import type { PaginatedResponse } from "@/types";

interface ListState<T> {
  items: T[];
  loading: boolean;
  refreshing: boolean;
  error: string | null;
  refresh: () => void;
}

/**
 * Fetches a paginated list endpoint (ApiResponse<PaginatedResponse<T>>).
 * Tolerates endpoints that return a plain array instead of a page envelope.
 */
export function useList<T>(
  path: string,
  query?: Record<string, string | number | undefined>
): ListState<T> {
  const [items, setItems] = useState<T[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async (isRefresh: boolean) => {
    isRefresh ? setRefreshing(true) : setLoading(true);
    setError(null);
    try {
      const data = await api.get<PaginatedResponse<T> | T[]>(path, query);
      if (Array.isArray(data)) setItems(data);
      else setItems(data?.data ?? []);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Không tải được dữ liệu");
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [path, JSON.stringify(query)]);

  useEffect(() => {
    void load(false);
  }, [load]);

  return { items, loading, refreshing, error, refresh: () => load(true) };
}
