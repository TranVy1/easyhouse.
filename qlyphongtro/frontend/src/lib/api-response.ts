import type { PaginatedResponse } from '@/types';

export function unwrapPageData<T>(value: T[] | PaginatedResponse<T> | undefined | null): T[] {
  if (!value) return [];
  return Array.isArray(value) ? value : value.data || [];
}
