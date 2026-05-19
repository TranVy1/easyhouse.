# EasyHouse Workspace Rule

Apply this rule to all Antigravity work in `D:\SOURCE\easyhouse`.

1. Read `.agents/project-index.md` before edits.
2. Use repo source over stale docs.
3. Preserve Vietnamese naming and DTO/entity/frontend type contracts.
4. Keep changes narrow. Do not reformat unrelated Java/TypeScript.
5. For backend endpoints consumed by frontend, verify `frontend/next.config.ts` rewrites.
6. For status fields, check SQL enum, Java enum, DTO mapper, frontend type, and UI label.
7. For auth/payment/billing, run or propose targeted verification before finalizing.
8. Do not touch secrets or customer/production databases.
