---
name: easyhouse-update-database
description: Restore or recover the local EasyHouse Docker PostgreSQL database from the verified sql/db-latest.sql snapshot by default, or from a user-specified complete SQL dump. Use when the user asks to import, refresh, recover from an error, reset, push, or load EasyHouse database schema and data into Docker, and then provide a full-permission web login account.
---

# EasyHouse Update Database

## Overview

Restore the local Docker database `easyhouse-postgres` / `postgres` from a complete SQL dump. Before restoring, create a separate recovery dump of the current local database. After restore, ensure a known ADMIN account exists and print login details.

## Workflow

1. Treat restore as destructive for the local Docker database.
2. For error recovery, use the verified `sql/db-latest.sql` snapshot by default. It includes the current checkout/deposit-settlement schema. Use `sql/easyhouse-after-fix.sql` only when the user explicitly requests the Docker seed snapshot, or use another complete SQL dump when explicitly named.
3. Restore schema and data together; do not push only schema, only data, or a partial table subset unless explicitly requested.
4. Let the script create `sql/recovery/recovery-before-restore-<timestamp>.sql` before destructive restore. Do not skip this safeguard unless the user explicitly asks.
5. Run the bundled script from the project root:

```powershell
python3 .codex/skills/easyhouse-update-database/scripts/restore_easyhouse_db.py --sql-file sql/db-latest.sql
```

For a user-specified file:

```powershell
python3 .codex/skills/easyhouse-update-database/scripts/restore_easyhouse_db.py --sql-file path/to/file.sql
```

5. Report the script output, especially admin login:

- URL: `http://localhost:3002/dang-nhap` (direct Docker development port)
- Email: `admin@easyhouse.local`
- Password: `Admin@123`
- Role: `ADMIN`

## Guardrails

- Use only local Docker container `easyhouse-postgres`; never restore to remote/customer databases.
- If the container does not exist, the script starts the `postgres` service from `docker-compose.easyhouse.yml`.
- Do not overwrite `sql/db-latest.sql` during recovery; it is the verified restore snapshot. Pre-restore dumps go in `sql/recovery/`.
- If `admin@easyhouse.local` does not exist after restore, create it with password `Admin@123` and role `ADMIN`.
- Do not edit app code for this task unless the restore exposes a concrete project bug the user asks to fix.
- If backend schema changed significantly, suggest restarting `easyhouse-backend` after restore.

## Script

Use `scripts/restore_easyhouse_db.py`; read it only when debugging or changing restore behavior.
