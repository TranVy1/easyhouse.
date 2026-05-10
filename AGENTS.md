# AGENTS.md - AI Development Guide for Rental Management System

> Project Architecture & Patterns for AI-Assisted Development

## Project Overview

**Quy Lý Phòng Trọ** is a full-stack rental property management system serving Vietnamese landlords and tenants. The project follows a clear separation of concerns with:
- **Backend**: Spring Boot 4.0.6 + Java 21, PostgreSQL database with custom ENUMs
- **Frontend**: Next.js 15.5.4 + React 19, TypeScript, Tailwind CSS, Radix UI components
- **Key Phases**: Authentication → Property Setup → Contracts → Billing/Payment → Support/Notifications

---

## Critical Architecture Patterns

### 1. **Vietnamese Naming & CamelCase Convention**
The entire system uses **Vietnamese field names in camelCase**. This is non-standard but essential:

- **Database** (PostgreSQL): Column names are LOWERCASE with underscores (e.g., `trang_thai_phong`, `chi_so_dien_nuoc`)
- **Backend DTOs/Entities**: camelCase Vietnamese (e.g., `trangThaiPhong`, `chiSoDienNuoc`)
- **Frontend Types**: Also camelCase Vietnamese matching Backend (see `src/types/index.ts`)

**Example**: A room status enum in PostgreSQL becomes `RENTED`/`AVAILABLE`/`MAINTENANCE` but maps to DTOs as `dangThue`/`trong`/`baoTri` when communicating with frontend.

### 2. **DTO → Entity → Frontend Type Flow**
Never expose entities directly. Follow this chain:
```
Request DTO → Service → Entity → Response DTO → Frontend Type
```
Reference: `plainning/BACKEND_CODING_PLAN.md` Phase 1.1 emphasizes "DTOs everywhere"

### 3. **Authentication: NextAuth + JWT + Spring Security**
- **Frontend**: NextAuth 4.24.11 with CredentialsProvider calling backend `/api/auth/login`
- **Backend**: Spring Security with JWT token issued by Spring Boot
- **Session Strategy**: JWT with 30-day expiration
- **Token Flow**: Backend returns `accessToken` → NextAuth stores in session → frontend uses for API calls
- **Key Config Files**:
  - Frontend: `src/lib/auth.ts` (NextAuth config)
  - Backend: `be/src/resources/application.properties` (JWT config in secrets file)

### 4. **Enum Mapping Challenge**
This is a critical pain point in the system. Backend PostgreSQL ENUMs don't match frontend display:

| Database ENUM | Backend DTO | Frontend Type | Display (Vietnamese) |
|---|---|---|---|
| `RENTED` | `dangThue` | `'dangThue'` | Đang thuê |
| `AVAILABLE` | `trong` | `'trong'` | Trống |
| `MAINTENANCE` | `baoTri` | `'baoTri'` | Bảo trì |

When fixing enum issues: **Check 3 layers** - SQL ENUM definition, DTO converter, frontend switch statement for labels.

---

## Essential Development Workflows

### Backend Build & Run
```powershell
cd be
mvn clean install        # Full build with tests
mvn spring-boot:run      # Start server on port 8080
mvn -DskipTests clean package  # Quick build skipping tests
```

### Frontend Dev & Build
```powershell
cd frontend
npm run dev               # Start Next.js dev server (port 3000) with Turbopack
npm run build             # Turbopack build
npm run lint              # ESLint check (may be ignored during builds per next.config.ts)
npm run check-setup       # Custom setup verification script
```

### Database Initialization
- Schema: `sql/init_schema.sql` creates all tables with Vietnamese names and custom PostgreSQL ENUMs
- Connection: PostgreSQL on Supabase (credentials in `be/src/resources/application-secrets.properties`)
- Hibernation: `spring.jpa.hibernate.ddl-auto=update` - auto-migrates on startup but **VERIFY first** with `init_schema.sql`

### Common Setup Issue
Both apps expect each other running locally:
- Backend: `http://localhost:8080` (hardcoded in `src/lib/auth.ts` line 20, `next.config.ts` rewrites)
- Frontend: `http://localhost:3000`
- Missing backend → NextAuth login fails silently

---

## Key File Reference Map

| Purpose | Files |
|---|---|
| **Type Definitions** | `frontend/src/types/index.ts` (268 lines) - authoritative for data shape |
| **API Integration** | `frontend/src/lib/auth.ts` (NextAuth), `next.config.ts` (rewrites to backend) |
| **UI Components** | `frontend/src/components/ui/` (40+ Radix UI + custom components) |
| **Backend Config** | `be/pom.xml` (Spring Boot parent v4.0.6), `be/src/resources/application.properties` |
| **Database Schema** | `sql/init_schema.sql` (PostgreSQL with custom TYPE enums) |
| **Development Plan** | `plainning/BACKEND_CODING_PLAN.md` - authoritative roadmap, 8 phases |
| **Middleware/Auth** | `frontend/src/middleware.ts` (NextAuth middleware - route protection) |

---

## Critical Integration Points

### 1. **API Endpoint Rewriting**
The frontend uses `next.config.ts` rewrites to proxy certain API calls to the backend:
```typescript
source: '/api/phong/:path*' → 'http://localhost:8080/api/phong/:path*'
```
This allows frontend to call `/api/phong` directly without CORS issues. New backend endpoints need corresponding rewrites OR they'll 404.

### 2. **Multi-Step Form Patterns**
Components like `image-upload.tsx`, `cccd-upload.tsx`, `phong-image-upload.tsx` handle file uploads to Cloudinary (implied by Backend plan Phase 3.1). These likely call backend `/api/upload` endpoints.

### 3. **Data Table Components**
Custom components for CRUD views:
- `phong-data-table.tsx` - Room listings with filters
- `khach-thue-data-table.tsx` - Tenant listings
- `hop-dong-data-table.tsx` - Contract listings
- `hoa-don-data-table.tsx` - Invoice listings

These use TanStack React Table v8.21.3 and expect backend pagination/filtering support.

### 4. **Billing Logic (Critical Business Logic)**
Located in Backend Phase 6: `HoaDon` (Invoice) generation calculates:
- Base rent from contract (`giaThue`)
- Electricity cost: (new reading - old reading) × price from `cau_hinh_gia`
- Water cost: Same as electricity
- Service fees from `phiDichVu` array
- Total must match: `tienPhong + tienDien + tienNuoc + serviceFees`

Errors here cascade: Wrong invoice → unpaid rent → incorrect payment status.

---

## Development Principles

### Prefer Existing Patterns
Before creating new utilities/components, check:
- `src/lib/utils.ts` - Only has `cn()` for Tailwind merge (minimal)
- `src/hooks/` - Likely contains reusable state logic
- `src/components/ui/` - 40+ components using Radix UI primitives

### Form Validation Strategy
- **Backend**: Spring `@NotBlank`, `@Email`, `@Min` annotations on DTOs
- **Frontend**: Zod schema (v4.1.11) for client-side validation before submission
- **Pattern**: react-hook-form (v7.63.0) + Zod resolvers for type-safe forms

### Styling Convention
- **Tailwind CSS** v4 with `@tailwindcss/postcss` for atomic utilities
- **Component Lib**: Radix UI primitives + custom styling via Tailwind
- **Class Merging**: `cn()` utility uses `clsx` + `tailwind-merge` to avoid conflicts

### Authentication Flow for New Pages
1. Check `middleware.ts` for route protection rules
2. Wrap protected components with `useSession()` hook
3. Redirect unauthenticated users to `/dang-nhap` (login, not sign-up)
4. Use `session.user.role` to check authorization (ADMIN, LANDLORD, TENANT roles expected)

---

## Command-Line Reference

| Task | Command |
|---|---|
| Backend: Full rebuild | `cd be && mvn clean install` |
| Backend: Quick start | `cd be && mvn spring-boot:run` |
| Backend: Skip tests | `cd be && mvn -DskipTests clean package` |
| Frontend: Dev with Turbopack | `cd frontend && npm run dev` |
| Frontend: Build check | `cd frontend && npm run build` |
| Frontend: Lint check | `cd frontend && npm run lint` |
| Database: Init schema | Import `sql/init_schema.sql` to Supabase PostgreSQL |
| Full reset (local dev) | Stop both servers, clear `.next/`, kill Node processes, restart fresh |

---

## Known Constraints & Technical Debt

1. **Build Ignores Errors**: `next.config.ts` sets `typescript.ignoreBuildErrors=true` and `eslint.ignoreDuringBuilds=true` - this masks real issues during development
2. **Hardcoded Auth Endpoints**: `auth.ts` line 20 has hardcoded `http://localhost:8080` - not environment-aware
3. **Missing Error Handling**: NextAuth promise chains don't always catch backend timeouts
4. **Vietnamese Schema Complexity**: ENUM drift between SQL, Java, TypeScript is error-prone
5. **No Real File Upload**: `cloudinary-service` referenced in plan but not implemented yet

---

## When Adding Features

### For Backend APIs:
1. Define Request/Response DTOs first
2. Create JPA Entity if needed with proper `@Id`, `@ManyToOne`, `@OneToMany`
3. Build Repository interface extending `JpaRepository<Entity, UUID>`
4. Write Service logic, map DTOs ↔ Entities
5. Add Controller endpoints with `@PreAuthorize` if role-gated
6. Test with cURL or Postman before connecting frontend

### For Frontend Features:
1. Add TypeScript interface to `src/types/index.ts`
2. Create UI component in `src/components/` using Radix UI primitives
3. Add API rewrite to `next.config.ts` if calling new backend endpoint
4. Use `src/lib/auth.ts` session for auth headers
5. Wrap with NextAuth protection in `middleware.ts` if needed
6. Test with `npm run dev` locally with backend running

### For Database Changes:
1. Modify `init_schema.sql` with new tables/enums
2. Add corresponding JPA Entity in backend
3. Run `mvn spring-boot:run` (Hibernate ddl-auto will sync if ddl-auto=update)
4. Update `src/types/index.ts` with new TypeScript types
5. Verify ENUM mapping in all 3 layers (SQL → Java DTO → TypeScript)

---

## Reference Resources

- **Detailed Implementation Plan**: `plainning/BACKEND_CODING_PLAN.md` (170 lines, 8 phases)
- **Database Schema**: `sql/init_schema.sql` (646 lines, fully commented)
- **Type Source of Truth**: `frontend/src/types/index.ts` (268 lines, all entities and responses)
- **Auth Implementation**: `frontend/src/lib/auth.ts` (88 lines, complete NextAuth config)
- **Build Defaults**: `next.config.ts` (45 lines, rewrites, error ignoring, Turbopack)

