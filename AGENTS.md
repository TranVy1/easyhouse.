# AGENTS.md - EasyHouse Agent Guide

Source of truth for Codex and Antigravity work in `d:\DATN_TMDT\qlyphongtro`.

## First Read

Before changing code, read:

1. `.agents/project-index.md`
2. Relevant backend/frontend files named in that index
3. `sql/backup.sql` when data shape or enum behavior matters

Repo source wins over old docs. Previous docs in this repo mentioned files that are not present (`sql/init_schema.sql`, `plainning/BACKEND_CODING_PLAN.md`); use actual files found in the tree.

## Project Shape

EasyHouse is a Vietnamese rental property management system.

- Backend: `be/`, Spring Boot 4.0.6, Java 21, Spring Web/Data JPA/Security/Validation/Mail, PostgreSQL, Cloudinary SDK.
- Frontend: `frontend/`, Next.js 15.5.4 App Router, React 19, TypeScript, Tailwind CSS v4, Radix UI, NextAuth v4.
- Database dump/schema: `sql/backup.sql`.
- Monitoring playground: `monitoring/`, Docker Compose with Prometheus/Grafana/k6.
- Planning/user-facing feature list: `plainning/WEEKLY_IMPLEMENTATION_PLAN.md`, `danh_sach_chuc_nang.txt`.

## Non-Negotiable Conventions

- Preserve Vietnamese domain names and camelCase API fields: `khachThue`, `hopDong`, `hoaDon`, `trangThai`, `chiSoDienBanDau`.
- Database columns use snake_case Vietnamese: `khach_thue_id`, `trang_thai`, `chi_so_dien_ban_dau`.
- Frontend expects Mongo-style `_id` even though backend uses PostgreSQL UUID. Backend DTOs often map UUID `id` to `_id` via `@JsonProperty`.
- Do not expose JPA entities directly from new controllers. Use Request DTO -> Service -> Entity -> Response DTO -> frontend type.
- Check enum mapping across DB, Java enum, DTO response, frontend union/switch before changing status fields.
- Keep edits surgical. No broad formatting or unrelated cleanup.

## Common Commands

Docker full stack:

```powershell
docker compose -f docker-compose.easyhouse.yml up --build
docker compose -f docker-compose.easyhouse.yml logs -f frontend backend
docker compose -f docker-compose.easyhouse.yml restart backend
```

Backend:

```powershell
cd be
mvn clean install
mvn spring-boot:run
mvn -DskipTests clean package
```

Frontend:

```powershell
cd frontend
npm install
npm run dev
npm run build
npm run lint
npm run check-setup
```

Notes:

- `npm run check-setup` is currently stale: it checks MongoDB/Mongoose-era setup.
- `frontend/next.config.ts` currently ignores TypeScript and ESLint build errors.
- Backend security currently permits all requests; do not assume role protection exists unless verified in code.

## Agent Files

- Codex: this `AGENTS.md` plus project skill `.codex/skills/easyhouse-local/SKILL.md`.
- Antigravity: this `AGENTS.md`, `GEMINI.md`, `.agent/rules/easyhouse.md`, `.agent/skills/easyhouse-local/SKILL.md`.
- Claude Code: `CLAUDE.md` imports `.agents/project-index.md`; project skill lives at `.claude/skills/easyhouse-local/SKILL.md`.

## Review Checklist

For backend changes:

- Controller route has matching frontend rewrite if frontend calls `/api/...`.
- Request/Response DTO matches `frontend/src/types/index.ts`.
- Service owns business logic and transaction boundary.
- Repository query excludes soft-deleted rows when needed.
- PostgreSQL enum/string values are compatible with JPA mapping.

For frontend changes:

- Page route lives in `frontend/src/app`.
- Shared data table patterns stay in `frontend/src/components/ui/*data-table.tsx`.
- API call shape matches `ApiResponse<T>` from backend.
- Auth headers use `session.accessToken`, noting current backend token is email, not real JWT.
- UI status labels use existing Vietnamese display mapping.

For billing/payment:

- Invoice total must reconcile with detail lines.
- Payment updates `daTra` and `trangThai` consistently.
- Electricity/water readings must not regress.
- `cau_hinh_gia` exists in SQL but no Java entity/service/controller currently exists.
