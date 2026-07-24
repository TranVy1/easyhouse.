# GEMINI.md - EasyHouse

Workspace context for Gemini/Antigravity agents in `d:\DATN_TMDT\qlyphongtro`.

Read `.agents/project-index.md` before editing. Then inspect only files relevant to current task.

Core rules:

- Keep Vietnamese camelCase fields stable across backend DTOs and frontend types.
- Database uses snake_case Vietnamese and custom PostgreSQL enums.
- Frontend expects many IDs as `_id`; backend DTOs often map UUID `id` to `_id`.
- Do not expose JPA entities directly from new controllers.
- Add/update `frontend/next.config.ts` rewrites for backend endpoints consumed as `/api/...`.
- Verify enum/status changes through SQL, Java enum, DTO, frontend type, and frontend label logic.
- Auth is not production-grade yet: backend permits all and token is email. Do not assume authorization exists.

Antigravity project skill: `.agent/skills/easyhouse-local/SKILL.md`.
Antigravity CodeGraph search skill: `.agent/skills/codegraph-search/SKILL.md`.
Antigravity workspace rule: `.agent/rules/easyhouse.md`.
