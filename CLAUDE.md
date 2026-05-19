# CLAUDE.md - EasyHouse

Read this first when working in `D:\SOURCE\easyhouse`.

@.agents/project-index.md

## Claude Operating Rules

- Use `.agents/project-index.md` as project map before editing.
- Preserve Vietnamese domain names and API field contracts.
- Keep backend DTO -> Service -> Entity -> Response DTO -> Frontend Type boundary.
- Check `frontend/next.config.ts` when adding or changing backend endpoints called via `/api/...`.
- Treat auth, billing, payment, enum mapping, and PostgreSQL schema changes as high-risk.
- Prefer small, source-backed edits over speculative refactors.
- Project skill is available at `.claude/skills/easyhouse-local/SKILL.md`.
