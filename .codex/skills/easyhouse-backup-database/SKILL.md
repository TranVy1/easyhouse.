---
name: easyhouse-backup-database
description: Back up schema and data from the local EasyHouse Docker PostgreSQL database to sql/db.sql by default, or to a user-specified .sql file. Use when the user asks to dump, export, back up, save, or snapshot EasyHouse Docker database schema/data, preserving the previous target SQL file before overwriting it.
---

# EasyHouse Backup Database

## Overview

Dump schema and data from local Docker database `easyhouse-postgres` / `easyhouse` into a plain SQL file. Before overwriting the target file, copy the current file to a timestamped backup next to it.

## Workflow

1. Use `sql/db.sql` unless the user names another output file.
2. Run the bundled script from the project root:

```powershell
python .codex/skills/easyhouse-backup-database/scripts/backup_easyhouse_db.py --output sql/db.sql
```

For a user-specified file:

```powershell
python .codex/skills/easyhouse-backup-database/scripts/backup_easyhouse_db.py --output path/to/file.sql
```

3. Report both paths:

- New dump file path.
- Timestamped backup path, if the target existed.

## Guardrails

- Use only local Docker container `easyhouse-postgres`; never dump remote/customer databases through this skill.
- Dump schema and data together using `pg_dump --clean --if-exists --no-owner --no-privileges`.
- Always preserve the previous target file before overwriting when it exists.

## Script

Use `scripts/backup_easyhouse_db.py`; read it only when debugging or changing backup behavior.
