import { Skeleton } from "@/components/ui/skeleton";

export default function DataPageLoading() {
  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-start justify-between gap-4">
        <div className="space-y-2">
          <Skeleton className="h-3 w-16" />
          <Skeleton className="h-7 w-44" />
          <Skeleton className="h-3.5 w-80" />
        </div>
        <div className="flex gap-2 shrink-0">
          <Skeleton className="h-9 w-24 rounded-lg" />
          <Skeleton className="h-9 w-28 rounded-lg" />
        </div>
      </div>

      {/* Filters bar */}
      <div className="flex items-center gap-3">
        <Skeleton className="h-9 flex-1 max-w-xs rounded-lg" />
        <Skeleton className="h-9 w-32 rounded-lg" />
        <Skeleton className="h-9 w-32 rounded-lg" />
        <div className="ml-auto">
          <Skeleton className="h-9 w-20 rounded-lg" />
        </div>
      </div>

      {/* Table */}
      <div className="rounded-xl border bg-card overflow-hidden">
        {/* Table header */}
        <div className="border-b p-4 flex gap-4">
          {[40, 120, 100, 80, 100, 60].map((w, i) => (
            <Skeleton key={i} className={`h-3.5 w-${w === 40 ? '[40px]' : w === 120 ? '[120px]' : w === 100 ? '[100px]' : w === 80 ? '[80px]' : w === 60 ? '[60px]' : '[100px]'}`} />
          ))}
        </div>
        {/* Table rows */}
        {[1, 2, 3, 4, 5, 6, 7, 8].map(i => (
          <div key={i} className="border-b last:border-0 p-4 flex items-center gap-4">
            <Skeleton className="w-4 h-4 rounded" />
            <div className="flex-1 flex items-center gap-4">
              <Skeleton className="h-3.5 w-32" />
              <Skeleton className="h-3.5 w-24" />
              <Skeleton className="h-3.5 w-28" />
              <Skeleton className="h-5 w-20 rounded-full" />
              <Skeleton className="h-3.5 w-20 ml-auto" />
              <Skeleton className="h-7 w-7 rounded-md" />
            </div>
          </div>
        ))}
      </div>

      {/* Pagination */}
      <div className="flex items-center justify-between">
        <Skeleton className="h-3.5 w-40" />
        <div className="flex gap-1">
          {[1, 2, 3, 4, 5].map(i => (
            <Skeleton key={i} className="h-8 w-8 rounded-md" />
          ))}
        </div>
      </div>
    </div>
  );
}
