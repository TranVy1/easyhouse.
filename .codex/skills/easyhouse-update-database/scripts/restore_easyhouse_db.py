#!/usr/bin/env python3
"""Restore EasyHouse local Docker PostgreSQL from a SQL file."""

from __future__ import annotations

import argparse
import subprocess
import sys
import time
from pathlib import Path


ADMIN_EMAIL = "admin@easyhouse.local"
ADMIN_PASSWORD = "Admin@123"
ADMIN_HASH = "$2a$10$9HgmP3LHXFShX6LXoCjinOy0E51QCxzfVmywozLxD/qSnD0u0bY1G"


def project_root_from_script() -> Path:
    return Path(__file__).resolve().parents[4]


def resolve_existing(path_value: str, project_root: Path) -> Path:
    path = Path(path_value)
    if not path.is_absolute():
        path = project_root / path
    return path.resolve(strict=True)


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


def restore_sql(sql_file: Path, container: str, db_user: str, database: str) -> None:
    with sql_file.open("rb") as sql_input:
        result = run(
            [
                "docker",
                "exec",
                "-i",
                container,
                "psql",
                "-v",
                "ON_ERROR_STOP=1",
                "-U",
                db_user,
                "-d",
                database,
            ],
            stdin=sql_input,
        )
    if result.returncode != 0:
        raise RuntimeError(f"Restore failed (exit {result.returncode})")


def ensure_admin(container: str, db_user: str, database: str) -> None:
    admin_sql = f"""
DO $$
DECLARE
    admin_role_id uuid;
    admin_user_id uuid := '00000000-0000-0000-0000-000000000001';
BEGIN
    SELECT COALESCE(
        (SELECT id FROM public.nguoi_dung WHERE email = '{ADMIN_EMAIL}' LIMIT 1),
        admin_user_id
    )
    INTO admin_user_id;

    IF to_regclass('auth.users') IS NOT NULL THEN
        EXECUTE $auth_select$
            SELECT COALESCE(
                (SELECT id FROM auth.users WHERE email = $1 LIMIT 1),
                $2
            )
        $auth_select$
        INTO admin_user_id
        USING '{ADMIN_EMAIL}', admin_user_id;

        EXECUTE $auth_insert$
            INSERT INTO auth.users (
                instance_id,
                id,
                aud,
                role,
                email,
                encrypted_password,
                email_confirmed_at,
                raw_app_meta_data,
                raw_user_meta_data,
                created_at,
                updated_at
            )
            VALUES (
                '00000000-0000-0000-0000-000000000000',
                $1,
                'authenticated',
                'authenticated',
                $2,
                $3,
                now(),
                '{{"provider":"email","providers":["email"]}}'::jsonb,
                '{{}}'::jsonb,
                now(),
                now()
            )
            ON CONFLICT (id) DO UPDATE
            SET
                email = EXCLUDED.email,
                encrypted_password = EXCLUDED.encrypted_password,
                email_confirmed_at = EXCLUDED.email_confirmed_at,
                raw_app_meta_data = EXCLUDED.raw_app_meta_data,
                raw_user_meta_data = EXCLUDED.raw_user_meta_data,
                updated_at = now()
        $auth_insert$
        USING admin_user_id, '{ADMIN_EMAIL}', '{ADMIN_HASH}';
    END IF;

    INSERT INTO public.vai_tro (id, ten, mo_ta, tao_luc)
    VALUES ('11111111-1111-1111-1111-111111111111', 'ADMIN', 'ADMIN', now())
    ON CONFLICT (ten) DO UPDATE
    SET mo_ta = COALESCE(public.vai_tro.mo_ta, EXCLUDED.mo_ta)
    RETURNING id INTO admin_role_id;

    INSERT INTO public.nguoi_dung (
        id,
        email,
        mat_khau,
        ho_ten,
        so_dien_thoai,
        trang_thai,
        so_lan_dang_nhap_sai,
        khoa_den_luc,
        tao_luc,
        cap_nhat_luc
    )
    VALUES (
        admin_user_id,
        '{ADMIN_EMAIL}',
        '{ADMIN_HASH}',
        'EasyHouse Admin',
        NULL,
        'ACTIVE',
        0,
        NULL,
        now(),
        now()
    )
    ON CONFLICT (email) DO UPDATE
    SET
        mat_khau = EXCLUDED.mat_khau,
        ho_ten = EXCLUDED.ho_ten,
        trang_thai = EXCLUDED.trang_thai,
        so_lan_dang_nhap_sai = 0,
        khoa_den_luc = NULL,
        cap_nhat_luc = now()
    RETURNING id INTO admin_user_id;

    INSERT INTO public.nguoi_dung_vai_tro (nguoi_dung_id, vai_tro_id, tao_luc)
    VALUES (admin_user_id, admin_role_id, now())
    ON CONFLICT DO NOTHING;
END $$;
"""
    result = run(
        [
            "docker",
            "exec",
            "-i",
            container,
            "psql",
            "-v",
            "ON_ERROR_STOP=1",
            "-U",
            db_user,
            "-d",
            database,
        ],
        input=admin_sql.encode("utf-8"),
    )
    if result.returncode != 0:
        raise RuntimeError(f"Admin ensure failed (exit {result.returncode})")


def admin_rows(container: str, db_user: str, database: str) -> str:
    query = """
SELECT nd.email,
       nd.trang_thai::text,
       string_agg(vt.ten::text, ', ' ORDER BY vt.ten::text) AS roles
FROM public.nguoi_dung nd
JOIN public.nguoi_dung_vai_tro ndvt ON ndvt.nguoi_dung_id = nd.id
JOIN public.vai_tro vt ON vt.id = ndvt.vai_tro_id
WHERE vt.ten::text = 'ADMIN'
GROUP BY nd.email, nd.trang_thai
ORDER BY nd.email;
"""
    result = run(
        [
            "docker",
            "exec",
            container,
            "psql",
            "-At",
            "-F",
            " | ",
            "-U",
            db_user,
            "-d",
            database,
            "-c",
            query,
        ],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return ""
    return result.stdout.strip()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--sql-file", default="sql/db.sql", help="SQL dump to restore")
    parser.add_argument("--project-root", default=None, help="EasyHouse project root")
    parser.add_argument("--compose-file", default="docker-compose.easyhouse.yml")
    parser.add_argument("--container", default="easyhouse-postgres")
    parser.add_argument("--database", default="easyhouse")
    parser.add_argument("--db-user", default="easyhouse")
    parser.add_argument("--skip-ensure-admin", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    project_root = Path(args.project_root).resolve() if args.project_root else project_root_from_script()
    sql_file = resolve_existing(args.sql_file, project_root)
    compose_file = resolve_existing(args.compose_file, project_root)

    print(f"Project: {project_root}")
    print(f"SQL file: {sql_file}")
    print(f"Target: {args.container}/{args.database}")

    ensure_postgres_running(args.container, compose_file)
    wait_for_postgres(args.container, args.db_user, args.database)
    restore_sql(sql_file, args.container, args.db_user, args.database)

    if not args.skip_ensure_admin:
        ensure_admin(args.container, args.db_user, args.database)

    print("Restore complete.")
    print("Full-permission web login:")
    print("  URL: http://localhost:3000/dang-nhap")
    print(f"  Email: {ADMIN_EMAIL}")
    print(f"  Password: {ADMIN_PASSWORD}")
    print("  Role: ADMIN")

    rows = admin_rows(args.container, args.db_user, args.database)
    if rows:
        print("Admin rows:")
        print(rows)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
