"use client";

import { AuditLogClient } from "./audit-log-client";

export default function AuditLogPage() {
  return (
    <div className="flex-col md:flex">
      <div className="flex-1 space-y-4 p-8 pt-6">
        <AuditLogClient />
      </div>
    </div>
  );
}
