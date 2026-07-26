# EasyHouse Workspace Rule

Apply this rule to all Antigravity work in `d:\DATN_TMDT\qlyphongtro`.

1. Read `.agents/project-index.md` before edits.
2. Use repo source over stale docs.
3. Preserve Vietnamese naming and DTO/entity/frontend type contracts.
4. Keep changes narrow. Do not reformat unrelated Java/TypeScript.
5. For backend endpoints consumed by frontend, verify `frontend/next.config.ts` rewrites.
6. For status fields, check SQL enum, Java enum, DTO mapper, frontend type, and UI label.
7. For auth/payment/billing, run or propose targeted verification before finalizing.
8. Do not touch secrets or customer/production databases.
9. When pushing the latest DB into local Docker, restore full schema and data from `sql/db.sql` unless a file is specified; never restore only schema, only data, or partial tables unless explicitly requested.
10. After local Docker DB restore, ensure `admin@easyhouse.local` / `Admin@123` exists with role `ADMIN`.
