# Property, Room, Tenant, Contract Optimization Plan

Last updated: 2026-06-01

## Goal

Hoan thien luong quan ly `Nha tro / Toa nha -> Tang -> Phong -> Khach thue -> Hop dong -> Lich thanh toan` theo huong thong nhat, de thao tac, co so do phong truc quan, tao phong hang loat, clone toa nha va giam thao tac thu cong.

## Current Progress

| Area | Status | Notes |
|---|---|---|
| Database migration | Done | Da tao migration tong `sql/migrations/20260601_property_room_contract_optimization.sql` va migration bo sung `sql/migrations/20260601_contract_workflow_columns.sql` neu DB da chay ban cu. |
| Tang schema | Done | Da them bang `tang`, lien ket nguoc tu `phong.tang_id`, giu `phong.tang` de tuong thich code hien tai. |
| Room map views | Done | Da them `v_so_do_toa_nha` va `v_thong_ke_toa_nha` cho man hinh so do/toa nha. |
| Bulk room generation SQL | Done | Da them function `sinh_phong_toa_nha(...)`. |
| Building clone SQL | Done | Da them function `clone_cau_truc_toa_nha(...)`. |
| Payment schedule SQL | Done | Da them bang/function `lich_thanh_toan` va `tao_lich_thanh_toan_hang_thang(...)`. |
| Backend entity/DTO/API | Done | Da them `Tang`, DTO/API so do/thong ke/tang/generate/clone; `mvn test` pass. |
| Frontend type/API | Done | Da them type `Tang`, `SoDoToaNha`, `ThongKeToaNha`, route chi tiet toa nha va proxy import. |
| Frontend UI | Done | Da them trang `/dashboard/toa-nha/[id]`, so do phong, tao nhanh co dinh/tuy chinh va import paste tu Excel. |
| Contract flow | Mostly Done | Backend/frontend da co preview/confirm, khoa hop dong, chan trung hop dong theo phong/ngay va tao lich thanh toan khi confirm. PDF thuc te con pending. |
| Import Excel | Done | Da them endpoint preview/confirm va UI import paste tu Excel, co validate theo dong. |
| Test/verification | Done | `mvn test` pass 102 tests; `npm run build` pass. Lint con fail do loi cu ngoai pham vi. |

## Phase 1 - Backend Compatibility With New SQL

Status: Done

Objective: Backend doc duoc schema moi nhung khong pha vo API hien tai.

Tasks:

- [x] Tao entity `Tang` map bang `tang`.
- [x] Cap nhat entity `Phong` them quan he `tangEntity`/`tangId` nhung van giu field `tang`.
- [x] Tao `TangRepository`.
- [x] Tao DTO:
  - [x] `TangResponse`
  - [x] `SoDoToaNhaResponse`
  - [x] `ThongKeToaNhaResponse`
  - [x] `GenerateRoomsRequest`
  - [x] `CloneToaNhaRequest`
- [x] Cap nhat repository query cho `Phong` theo `nhaTroId`, `tang`, `tangId`.
- [x] Dam bao soft-delete `xoaLuc IS NULL` trong cac query moi.

Acceptance criteria:

- Backend start duoc voi database da chay migration.
- API cu `/api/phong`, `/api/toa-nha` van chay.
- Tao/sua phong cu khong bi loi khi `tang_id` chua bat buoc.

## Phase 2 - Building Detail And Room Map APIs

Status: Done

Objective: Tu man hinh toa nha xem duoc tong quan, so do tang/phong, khach thue va hop dong hien tai.

Tasks:

- [x] Them endpoint `GET /api/toa-nha/{id}/so-do`.
- [x] Them endpoint `GET /api/toa-nha/{id}/thong-ke`.
- [x] Them endpoint `GET /api/toa-nha/{id}/tang`.
- [x] Tra ve du lieu nhom theo tang:

```json
{
  "_id": "toa-nha-id",
  "tenToaNha": "Toa A",
  "tongSoTang": 6,
  "tongSoPhong": 60,
  "phongTrong": 20,
  "phongDangThue": 38,
  "phongBaoTri": 2,
  "tang": [
    {
      "soTang": 6,
      "phong": [
        {
          "_id": "phong-id",
          "maPhong": "601",
          "trangThaiHienThi": "VACANT"
        }
      ]
    }
  ]
}
```

Acceptance criteria:

- So do phong lay du lieu tu view `v_so_do_toa_nha` hoac query tuong duong.
- Trang thai hien thi co cac gia tri: `VACANT`, `RENTED`, `CONTRACT_EXPIRING`, `MAINTENANCE`.
- Hop dong sap het han duoc tinh theo ngay ket thuc <= 30 ngay.

## Phase 3 - Smart Building Creation

Status: Done

Objective: Tao toa nha va sinh tang/phong tu dong.

Tasks:

- [x] Mo rong `NhaTroRequest` them che do tao nhanh:
  - [x] `cheDoTaoPhong`: `NONE | FIXED | CUSTOM`
  - [x] `soTang`
  - [x] `soPhongMoiTang`
  - [x] `cauTrucTang`
  - [x] `dienTichMacDinh`
  - [x] `giaThueMacDinh`
  - [x] `tienCocMacDinh`
- [ ] Tach rieng service `BuildingGenerationService` neu can refactor sau; hien dang giu trong `NhaTroService` de giam thay doi.
- [x] Khi tao toa nha thanh cong, goi logic sinh tang/phong trong cung transaction.
- [x] Ho tro cau truc co dinh: 6 tang x 10 phong.
- [x] Ho tro cau truc tuy chinh: tang 1 co 5 phong, tang 2 co 8 phong...
- [x] Validate trung ma phong trong cung toa nha.

Acceptance criteria:

- Tao toa nha co the tu sinh `101-110`, `201-210`, ...
- Neu loi sinh phong, rollback ca toa nha va phong.
- Khong tao phong doc lap khong co toa nha.

## Phase 4 - Clone Building

Status: Done

Objective: Clone cau truc toa nha mau sang toa nha moi.

Tasks:

- [x] Them endpoint `POST /api/toa-nha/{id}/clone`.
- [x] Tao toa nha dich voi thong tin ten/dia chi moi.
- [x] Clone tang, phong, dien tich, gia thue, tien coc.
- [x] Mac dinh phong clone co trang thai `AVAILABLE`.
- [x] Khong clone khach thue, hop dong, hoa don, su co.

Acceptance criteria:

- Clone toa A sang toa B khong sao chep du lieu van hanh.
- Ma phong trong toa dich khong bi trung.

## Phase 5 - Contract Draft, Preview, Confirm

Status: Mostly Done

Objective: Hop dong co vong doi ro rang va chi cap nhat phong khi xac nhan.

Tasks:

- [x] Chuan hoa trang thai:
  - [x] `DRAFT`: moi tao/da preview nhung chua giu phong
  - [ ] `PENDING`: cho xac nhan/giu phong co chu dich
  - [x] `ACTIVE`: da xac nhan
  - [ ] `EXPIRED`, `TERMINATED`, `CANCELLED`
- [x] Them endpoint `POST /api/hop-dong/{id}/preview`.
- [x] Them endpoint `POST /api/hop-dong/{id}/confirm`.
- [x] Khi preview:
  - [x] Sinh noi dung hop dong tu template.
  - [x] Khong doi trang thai phong.
  - [x] Cap nhat `previewed_at`.
- [x] Khi confirm:
  - [x] Khoa du lieu hop dong bang `locked_at`.
  - [x] Cap nhat `confirmed_at`.
  - [x] Cap nhat hop dong `ACTIVE`.
  - [x] Cap nhat phong `RENTED`.
  - [x] Goi `tao_lich_thanh_toan_hang_thang`.
- [ ] Sinh/lien ket file PDF thuc te neu template PDF da san sang.

Acceptance criteria:

- Preview khong lam phong bi dang thue.
- Confirm moi chuyen phong sang dang thue.
- Mot phong khong co 2 hop dong active trung ngay.

## Phase 6 - Frontend Building UX

Status: Done

Objective: Giao dien toa nha tro thanh trung tam van hanh.

Tasks:

- [x] Cap nhat `frontend/src/types/index.ts` them:
  - [x] `Tang`
  - [x] `SoDoPhong`
  - [x] `SoDoTang`
  - [x] `SoDoToaNha`
  - [x] `ThongKeToaNha`
- [x] Cap nhat trang `/dashboard/toa-nha` de co hanh dong xem chi tiet.
- [x] Them trang chi tiet `/dashboard/toa-nha/[id]`.
- [x] Them tabs:
  - [x] Tong quan
  - [x] So do phong
  - [x] Danh sach phong
  - [ ] Hop dong
  - [ ] Khach thue
  - [ ] Hoa don
- [x] So do phong co mau:
  - [x] Xanh: phong trong
  - [x] Do: dang thue
  - [x] Vang: sap het hop dong
  - [x] Xam: bao tri
- [x] Click phong mo side panel chi tiet.

Acceptance criteria:

- Tu danh sach toa nha click vao duoc chi tiet.
- So do tang/phong hien thi dung theo du lieu API.
- Text/mau trang thai dung Vietnamese mapping hien co.

## Phase 7 - Frontend Smart Creation And Contract UX

Status: In Progress

Objective: Giam thao tac thu cong khi tao toa nha va hop dong.

Tasks:

- [x] Wizard tao toa nha:
  - [x] Thong tin toa nha
  - [x] Cau truc phong co dinh
  - [x] Gia/dich vu mac dinh co ban
  - [x] Cau truc phong tuy chinh
  - [x] Preview cau truc truc tiep tren form truoc khi tao
- [ ] Wizard tao hop dong:
  - [ ] Chon phong
  - [ ] Chon/tao khach thue
  - [ ] Dieu khoan
  - [ ] Dich vu
  - [ ] Preview
  - [ ] Confirm
- [ ] Goi y phong trong khi tao hop dong.

Acceptance criteria:

- Nguoi dung tao toa nha 6 tang x 10 phong trong mot luong.
- Nguoi dung tao hop dong khong can qua lai nhieu man hinh.

## Phase 8 - Import Excel

Status: Done

Objective: Import nhanh toa nha/tang/phong tu file Excel.

Tasks:

- [x] Dinh nghia file mau:

```text
ten_toa_nha | dia_chi | tang | ma_phong | dien_tich | gia_thue | tien_coc | so_nguoi_toi_da
```

- [x] Endpoint `POST /api/import/toa-nha/preview`.
- [x] Endpoint `POST /api/import/toa-nha/confirm`.
- [x] Preview bao loi theo dong.
- [x] Confirm chay transaction.
- [x] UI import dang paste tu Excel trong man hinh `/dashboard/toa-nha`.

Acceptance criteria:

- Import khong ghi database neu chi preview.
- Confirm rollback neu co loi bat thuong.
- Bao ro phong trung, thieu gia, sai tang, sai dien tich.

## Phase 9 - Verification

Status: Done

Commands:

```powershell
cd be
mvn test
```

Status: Passed on 2026-06-01 after import/backend updates. 102 tests passed.

```powershell
cd frontend
npm run lint
npm run build
```

Status:

- `npm run build`: Passed on 2026-06-01 after room-map, quick-create, contract workflow and import UI updates.
- `npm run lint`: Failed because of pre-existing lint errors in landing/mobile app files outside this change.

Manual checklist:

- [ ] Tao toa nha co dinh 6 tang x 10 phong tren local UI.
- [ ] Xem so do toa nha tren local UI.
- [ ] Click phong mo chi tiet tren local UI.
- [ ] Tao hop dong draft tren local UI.
- [ ] Preview hop dong tren local UI.
- [ ] Confirm hop dong tren local UI.
- [ ] Kiem tra phong chuyen sang dang thue tren local DB.
- [ ] Kiem tra lich thanh toan duoc tao tren local DB.
- [ ] Clone toa nha tren local UI.
- [ ] Import Excel preview va confirm tren local UI.

## Implementation Order

Recommended sequence:

1. [x] Backend entity/DTO/repository compatibility.
2. [x] API so do toa nha va thong ke toa nha.
3. [x] Frontend chi tiet toa nha va so do phong.
4. [x] API tao toa nha thong minh.
5. [x] Frontend wizard tao toa nha.
6. [x] Contract preview/confirm va lich thanh toan.
7. [x] Clone toa nha.
8. [x] Import Excel.
9. [x] Test va fix regression.

## Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Backend JPA chua map `tang_id` | App co the loi neu ep NOT NULL qua som | Giu `tang_id` nullable den khi frontend/backend xong. |
| `phong.trang_thai` dang duoc frontend map sang UI string | Sai mau/trang thai | Kiem tra enum SQL, Java enum, DTO va status-utils. |
| Contract confirm anh huong thanh toan/hoa don | Sai cong no | Confirm phai goi service transaction rieng va test payment schedule. |
| Import Excel tao du lieu rac | Kho sua du lieu | Bat buoc preview, validate, transaction rollback. |
| Auth hien tai chua an toan | API moi co the bi goi tu do | Sau luong nghiep vu can lam phase rieng cho JWT/authorization. |

## Next Immediate Tasks

- [ ] Manual QA voi database local da chay migration:

```sql
-- Neu da chay migration tong ban cu truoc do, chay bo sung:
\i sql/migrations/20260601_contract_workflow_columns.sql

SELECT to_regclass('public.tang');
SELECT to_regclass('public.lich_thanh_toan');
SELECT to_regclass('public.v_so_do_toa_nha');
SELECT to_regclass('public.v_thong_ke_toa_nha');
SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'hop_dong'
  AND column_name IN ('template_version', 'previewed_at', 'confirmed_at', 'locked_at');
```

- [ ] Sinh PDF hop dong thuc te tu Word/template neu template chinh thuc da san sang.
- [ ] Bo sung tab Hop dong/Khach thue/Hoa don trong chi tiet toa nha.
- [ ] Tach `BuildingGenerationService` neu can lam sach service sau khi nghiep vu on dinh.
