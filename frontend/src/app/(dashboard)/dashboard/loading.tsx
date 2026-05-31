import { Skeleton } from "@/components/ui/skeleton";

export default function DashboardLoading() {
  return (
    <div className="space-y-6 lg:space-y-8">
      {/* Page header skeleton */}
      <div className="flex items-start justify-between gap-4">
        <div className="space-y-2">
          <Skeleton className="h-3 w-20" />
          <Skeleton className="h-7 w-56" />
          <Skeleton className="h-4 w-96" />
        </div>
        <div className="flex gap-2 shrink-0">
          <Skeleton className="h-9 w-24 rounded-lg" />
          <Skeleton className="h-9 w-28 rounded-lg" />
        </div>
      </div>

      {/* Metric cards */}
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        {[1, 2, 3, 4].map(i => (
          <div key={i} className="rounded-xl border bg-card p-5 space-y-3">
            <div className="flex items-center justify-between">
              <Skeleton className="h-3.5 w-28" />
              <Skeleton className="h-8 w-8 rounded-lg" />
            </div>
            <Skeleton className="h-7 w-20" />
            <Skeleton className="h-3 w-32" />
          </div>
        ))}
      </div>

      {/* Content cards */}
      <div className="grid gap-4 xl:grid-cols-[1.45fr_1fr]">
        <div className="rounded-xl border bg-card">
          <div className="border-b p-5 space-y-1.5">
            <Skeleton className="h-5 w-36" />
            <Skeleton className="h-3.5 w-64" />
          </div>
          <div className="p-5 space-y-3">
            {[1, 2, 3].map(i => (
              <div key={i} className="flex items-center gap-4 rounded-xl border p-4">
                <Skeleton className="w-11 h-11 rounded-xl shrink-0" />
                <div className="flex-1 space-y-1.5">
                  <Skeleton className="h-4 w-40" />
                  <Skeleton className="h-3 w-56" />
                </div>
                <Skeleton className="w-4 h-4 rounded" />
              </div>
            ))}
          </div>
        </div>

        <div className="rounded-xl border bg-card">
          <div className="border-b p-5 space-y-1.5">
            <Skeleton className="h-5 w-28" />
            <Skeleton className="h-3.5 w-48" />
          </div>
          <div className="p-5 space-y-4">
            <Skeleton className="h-2.5 w-full rounded-full" />
            {[1, 2, 3].map(i => (
              <div key={i} className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <Skeleton className="w-2.5 h-2.5 rounded-full" />
                  <Skeleton className="h-3.5 w-20" />
                </div>
                <Skeleton className="h-3.5 w-14" />
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
