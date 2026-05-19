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

- Local DB init creates PostgreSQL enum types needed by Hibernate. Tables are created/updated by Spring `ddl-auto=update`.
- Seed data only runs automatically on first DB volume creation. To re-run it on the current DB: `Get-Content docker/postgres/init/02-easyhouse-seed.sql -Raw | docker exec -i easyhouse-postgres psql -U easyhouse -d easyhouse`.
- Cloudinary and SMTP are placeholder values. Upload/register email flows need real secrets if you test those paths.
