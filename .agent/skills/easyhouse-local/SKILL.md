---
name: easyhouse-local
description: Use when working on the EasyHouse rental management project in d:\DATN_TMDT\qlyphongtro, including Spring Boot backend, Next.js frontend, PostgreSQL schema, auth, rooms, tenants, contracts, invoices, payments, incidents, notifications, uploads, monitoring, project review, indexing, or agent documentation for Antigravity.
---

# EasyHouse Local

## Workflow

1. Read `.agents/project-index.md`.
2. Inspect only relevant files with `rg`/file reads.
3. Preserve Vietnamese domain naming and API contracts.
4. Keep DTO -> Service -> Entity -> Response DTO -> Frontend Type flow.
5. When adding backend endpoint used by frontend, update `frontend/next.config.ts`.
6. When changing status/enum behavior, verify SQL enum, Java enum, DTO mapper, frontend type, and UI label.
7. Treat auth, billing, payment, and database schema as high-risk.
8. When restoring the latest DB into local Docker, restore schema and data together from `sql/db.sql` unless a file is specified; never restore only schema, only data, or partial tables unless explicitly requested.
9. After local Docker DB restore, ensure `admin@easyhouse.local` / `Admin@123` exists with role `ADMIN`.

## Key Paths

- Backend: `be/`
- Frontend: `frontend/`
- Schema dump: `sql/backup.sql`
- Docker DB restore dump: `sql/db.sql`
- Main index: `.agents/project-index.md`
- Codex guide: `AGENTS.md`
- Claude guide: `CLAUDE.md`
- Antigravity guide: `GEMINI.md`

## Known Drift

- Backend security permits all requests.
- Auth token is currently email, not signed JWT.
- Frontend calls some missing backend routes.
- `frontend/scripts/check-setup.js` still checks MongoDB/Mongoose setup.
- `cau_hinh_gia` exists in SQL but lacks Java implementation.
