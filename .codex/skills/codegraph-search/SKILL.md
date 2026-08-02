---
name: codegraph-search
description: Use CodeGraph for intelligent local code search, architecture discovery, call-flow tracing, change impact analysis, and affected-test discovery in the EasyHouse workspace. Trigger when locating implementations, mapping frontend-to-backend flows, investigating a bug across modules, preparing a change, or choosing targeted tests before using broad file scans.
---

# CodeGraph Search

Use CodeGraph to discover relevant source and relationships first. Read exact files after the graph narrows the scope, because source remains authoritative.

## Workflow

1. Read `.agents/project-index.md` and any applicable project guidance.
2. Confirm the index is available and current with MCP `codegraph_status`, or CLI fallback:

   ```powershell
   codegraph status .
   ```

3. Map the task with MCP `codegraph_context` first. If CodeGraph MCP tools are unavailable, run:

   ```powershell
   codegraph context "<task in domain and symbol terms>" --max-nodes 20
   ```

4. Refine only as required:
   - Use `codegraph_search` / `codegraph query "<symbol-or-term>"` to locate a known controller, DTO, service, React component, hook, enum, or route.
   - Use `codegraph_explore` when MCP is present to retrieve several related source bodies in one bounded result.
   - Use `codegraph_trace` when MCP is present for a question shaped as "how does X reach Y".
   - Use `codegraph_callers` / `codegraph callers "<symbol>"` and `codegraph_callees` / `codegraph callees "<symbol>"` for one-hop flow analysis.
   - Use `codegraph_impact` / `codegraph impact "<symbol>"` before editing shared code.
5. Open the exact source files identified by CodeGraph. Verify DTO/API/status/schema contracts from source before editing; do not treat graph results as a substitute for current file contents.
6. After edits, let MCP auto-sync when active. If using CLI only or the result appears stale, run `codegraph sync .` and repeat the focused query.
7. Choose targeted tests using impacted symbols; when useful, query changed-file test reachability:

   ```powershell
   git diff --name-only | codegraph affected --stdin --quiet
   ```

## Query Strategy

Write queries with domain nouns and layer boundaries, not vague verbs.

```powershell
codegraph context "hoa don payment frontend API to HoaDonService persistence" --max-nodes 20
codegraph context "room status update from Phong page through Spring controller and DTO" --max-nodes 20
codegraph query "HoaDonService"
codegraph impact "ThanhToanService"
```

If a task changes an HTTP or data contract, follow the graph across all relevant EasyHouse layers:

- Next.js page/component and `frontend/src/types/index.ts`
- `/api/...` use and `frontend/next.config.ts` rewrite
- Spring controller, request/response DTO, service, repository/entity
- `sql/easyhouse-after-fix.sql` for enum or schema-sensitive behavior

## Boundaries

- Prefer CodeGraph for discovery and relationships; use `rg` for literal text, configuration, SQL, docs, generated assets, or unsupported/unindexed content.
- Do not perform broad file reads or delegate exploration before trying one focused CodeGraph context query when its index is available.
- Treat stale/pending results as a signal to sync or read the referenced file directly.
- Preserve EasyHouse Vietnamese fields, `_id` DTO mapping, and enum mappings as required by `AGENTS.md`.
