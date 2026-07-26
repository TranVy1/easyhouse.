---
name: easyhouse-update-database
description: Restore or update the local EasyHouse Docker PostgreSQL database from sql/db.sql by default, or from a user-specified .sql file. Use when the user asks to import, refresh, update, reset, push, or load EasyHouse database data/schema into Docker, and then provide a full-permission web login account.
---

# EasyHouse Update Database

## Overview

Restore the local Docker database `easyhouse-postgres` / `easyhouse` from a SQL dump. After restore, ensure a known ADMIN account exists and print login details.

## Workflow

1. Treat restore as destructive for the local Docker database.
2. Use `sql/db.sql` unless the user names another SQL file.
3. Restore the complete dump: schema and data together. Do not push only schema, only data, or a partial table subset unless the user explicitly asks for that exact partial operation.
4. Run the bundled script from the project root:

```powershell
python .codex/skills/easyhouse-update-database/scripts/restore_easyhouse_db.py --sql-file sql/db.sql
```

For a user-specified file:

```powershell
python .codex/skills/easyhouse-update-database/scripts/restore_easyhouse_db.py --sql-file path/to/file.sql
```

5. Report the script output, especially admin login:

- URL: `http://localhost:3000/dang-nhap`
- Email: `admin@easyhouse.local`
- Password: `Admin@123`
- Role: `ADMIN`

## Guardrails

- Use only local Docker container `easyhouse-postgres`; never restore to remote/customer databases.
- If the container does not exist, the script starts the `postgres` service from `docker-compose.easyhouse.yml`.
- If `admin@easyhouse.local` does not exist after restore, create it with password `Admin@123` and role `ADMIN`.
- Do not edit app code for this task unless the restore exposes a concrete project bug the user asks to fix.
- If backend schema changed significantly, suggest restarting `easyhouse-backend` after restore.

## Script

Use `scripts/restore_easyhouse_db.py`; read it only when debugging or changing restore behavior.
