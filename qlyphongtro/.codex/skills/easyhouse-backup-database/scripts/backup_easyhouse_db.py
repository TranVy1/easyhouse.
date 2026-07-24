#!/usr/bin/env python3
"""Back up EasyHouse local Docker PostgreSQL schema and data."""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
import time
from datetime import datetime
from pathlib import Path


def project_root_from_script() -> Path:
    return Path(__file__).resolve().parents[4]


def resolve_existing(path_value: str, project_root: Path) -> Path:
    path = Path(path_value)
    if not path.is_absolute():
        path = project_root / path
    return path.resolve(strict=True)


def resolve_output(path_value: str, project_root: Path) -> Path:
    path = Path(path_value)
    if not path.is_absolute():
        path = project_root / path
    return path.resolve(strict=False)


def run(args: list[str], **kwargs) -> subprocess.CompletedProcess:
    return subprocess.run(args, **kwargs)


def run_checked(args: list[str], message: str, **kwargs) -> subprocess.CompletedProcess:
    result = run(args, **kwargs)
    if result.returncode != 0:
        raise RuntimeError(f"{message} (exit {result.returncode})")
    return result


def ensure_postgres_running(container: str, compose_file: Path) -> None:
    inspect = run(
        ["docker", "inspect", "-f", "{{.State.Running}}", container],
        capture_output=True,
        text=True,
    )
    if inspect.returncode != 0:
        run_checked(
            ["docker", "compose", "-f", str(compose_file), "up", "-d", "postgres"],
            "Failed to start postgres service",
        )
    elif inspect.stdout.strip().lower() != "true":
        run_checked(["docker", "start", container], "Failed to start postgres container")


def wait_for_postgres(container: str, db_user: str, database: str) -> None:
    for _ in range(60):
        ready = run(
            ["docker", "exec", container, "pg_isready", "-U", db_user, "-d", database],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        if ready.returncode == 0:
            return
        time.sleep(2)
    raise RuntimeError("PostgreSQL did not become ready in time")


def backup_existing(output_file: Path, timestamp: str) -> Path | None:
    if not output_file.exists():
        return None
    backup_file = output_file.with_name(f"{output_file.name}.bak-{timestamp}")
    shutil.copy2(output_file, backup_file)
    return backup_file


def dump_database(output_file: Path, container: str, db_user: str, database: str, timestamp: str) -> Path:
    output_file.parent.mkdir(parents=True, exist_ok=True)
    tmp_file = output_file.with_name(f"{output_file.name}.tmp-{timestamp}")
    with tmp_file.open("wb") as dump_out:
        result = run(
            [
                "docker",
                "exec",
                container,
                "pg_dump",
                "-U",
                db_user,
                "-d",
                database,
                "--clean",
                "--if-exists",
                "--no-owner",
                "--no-privileges",
            ],
            stdout=dump_out,
        )
    if result.returncode != 0:
        if tmp_file.exists():
            tmp_file.unlink()
        raise RuntimeError(f"pg_dump failed (exit {result.returncode})")

    os.replace(tmp_file, output_file)
    return output_file


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", default="sql/db.sql", help="SQL dump output path")
    parser.add_argument("--project-root", default=None, help="EasyHouse project root")
    parser.add_argument("--compose-file", default="docker-compose.easyhouse.yml")
    parser.add_argument("--container", default="easyhouse-postgres")
    parser.add_argument("--database", default="easyhouse")
    parser.add_argument("--db-user", default="easyhouse")
    parser.add_argument("--skip-backup-current", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    project_root = Path(args.project_root).resolve() if args.project_root else project_root_from_script()
    output_file = resolve_output(args.output, project_root)
    compose_file = resolve_existing(args.compose_file, project_root)
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")

    print(f"Project: {project_root}")
    print(f"Output: {output_file}")
    print(f"Source: {args.container}/{args.database}")

    ensure_postgres_running(args.container, compose_file)
    wait_for_postgres(args.container, args.db_user, args.database)

    backup_file = None
    if not args.skip_backup_current:
        backup_file = backup_existing(output_file, timestamp)

    dump_database(output_file, args.container, args.db_user, args.database, timestamp)

    print("Backup complete.")
    print(f"Dump file: {output_file}")
    if backup_file:
        print(f"Previous file backup: {backup_file}")
    else:
        print("Previous file backup: none; target did not exist")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
