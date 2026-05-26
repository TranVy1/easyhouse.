# EasyHouse Docker Dev

Run full local stack:

```powershell
docker compose -f docker-compose.easyhouse.yml up --build
```

Open:

- Frontend: http://localhost:3000
- Backend: http://localhost:8080
- PostgreSQL: `localhost:54323`, db/user/password all `easyhouse`

Seed login:

- Email: `admin@easyhouse.local`
- Password: `Admin@123`

Role verification accounts use the same password `Admin@123`:

- Landlord A: `landlord.a@easyhouse.local`, owns `Nha tro A`.
- Landlord B: `landlord.b@easyhouse.local`, owns `Nha tro B`.
- Staff A: `staff.a@easyhouse.local`, assigned only to `Nha tro A`.
- Tenant A: `tenant.a@easyhouse.local`, contracted in room `A101`.
- Tenant B: `tenant.b@easyhouse.local`, contracted in room `B101`.

The dump includes separate A/B contracts, invoices, meter readings, incidents and appointments for access-scope checks.

Use detached mode:

```powershell
docker compose -f docker-compose.easyhouse.yml up -d --build
docker compose -f docker-compose.easyhouse.yml logs -f frontend backend
```

Refresh behavior:

- Frontend changes hot reload in browser because `frontend/` is bind-mounted.
- Backend source is bind-mounted. Restart backend after Java changes:

```powershell
docker compose -f docker-compose.easyhouse.yml restart backend
```

When `pom.xml` or `package-lock.json` changes, rebuild:

```powershell
docker compose -f docker-compose.easyhouse.yml up -d --build
```

Reset local database:

```powershell
docker compose -f docker-compose.easyhouse.yml down -v
docker compose -f docker-compose.easyhouse.yml up --build
```

Notes:

- Local DB initialization restores the complete `sql/db.sql` dump, including schema and seed data. Backend runs with `ddl-auto=none`.
- `sql/db.sql` runs only when PostgreSQL creates a new volume. To apply the latest dump, use the reset commands above.
- After restore, verify web login with `admin@easyhouse.local` / `Admin@123` and role `ADMIN`.
- Cloudinary and SMTP are placeholder values. Upload/register email flows need real secrets if you test those paths.
