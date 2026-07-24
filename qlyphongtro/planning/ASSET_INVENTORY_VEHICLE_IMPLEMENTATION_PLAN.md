# Ke hoach trien khai Confirm, Tai san phong, Kho tai san va Phuong tien

Ngay lap: 2026-07-21

Pham vi: EasyHouse rental management system, Next.js frontend va Spring Boot backend.

Muc tieu cua tai lieu nay la tong hop ke hoach thuc hien chi tiet de developer co the trien khai tung buoc. Moi thay doi database phai bat dau bang viec kiem tra bang/cot san co trong repo va database dang chay. Khong tu y them, bot, doi ten bang/cot neu chua co ket qua doi chieu va xac nhan.

## 1. Nguyen tac bat buoc

### 1.1. Khong tu y sua schema

Truoc khi thuc hien bat ky thay doi database nao, bat buoc kiem tra:

- `sql/schema.sql`
- `sql/init-db.sql`
- `sql/data.sql`
- `sql/migrations/*`
- Entity Java trong `be/src/main/java/com/example/quanlyphongtro/entity`
- DTO trong `be/src/main/java/com/example/quanlyphongtro/dto`
- Type frontend trong `frontend/src/types/index.ts`
- Trang frontend duong dan `frontend/src/app/(dashboard)/dashboard/*`

Neu bang/cot da ton tai:

- Uu tien dung lai bang/cot hien co.
- Chi bo sung logic service/controller/frontend neu cot da dap ung du lieu.
- Neu can cot moi, phai viet thanh muc "de xuat migration" rieng va can xac nhan truoc khi code.

Neu bang/cot chua ton tai:

- Khong tao ngay trong code.
- Ghi ro nhu cau, ly do can them, tac dong den backend/frontend/billing.
- Chi tao migration sau khi duoc xac nhan.

### 1.2. Confirm cho moi thao tac them, sua, xoa

Tat ca thao tac lam thay doi du lieu bat buoc co confirm:

- Them moi
- Cap nhat
- Xoa
- Import hang loat
- Cap phat kho
- Thu hoi kho
- Dieu chinh so luong
- Ap dung phi gui xe
- Huy ap dung phi gui xe

Khong dung `window.confirm()` cho code moi. Nen tao component dung chung de thong nhat UI.

### 1.3. Khong pha layout hien co

Khong doi sidebar/header/layout dashboard neu khong lien quan truc tiep. Cac route moi phai di theo App Router:

- `frontend/src/app/(dashboard)/dashboard/...`

API frontend goi qua `/api/...` thi phai kiem tra `frontend/next.config.ts` co rewrite tuong ung.

## 2. Hien trang da kiem tra trong repo

### 2.1. Tai san phong da co module

Backend da co:

- Entity: `TaiSanPhong`
- DTO: `TaiSanPhongDto`
- Service: `TaiSanPhongService`
- Controller: `TaiSanPhongController`
- Repository: `TaiSanPhongRepository`

Frontend da co:

- Route: `frontend/src/app/(dashboard)/dashboard/tai-san-phong`
- Page, form, table tai san phong
- Type `TaiSanPhong` trong `frontend/src/types/index.ts`

SQL hien co:

Bang `tai_san_phong` trong `sql/schema.sql` gom:

```text
id
phong_id
ten_tai_san
so_luong
gia_tri
tinh_trang
ghi_chu
tao_luc
cap_nhat_luc
```

Luu y can check:

- Entity `TaiSanPhong` hien co field `anhTaiSan`, nhung schema excerpt trong `sql/schema.sql` chua thay cot `anh_tai_san`.
- Truoc khi lam import/hinh anh tai san, can kiem tra database thuc te co cot `anh_tai_san` chua.
- Neu chua co, phai de xuat migration rieng, khong tu them ngam.

### 2.2. Phuong tien da co module

Backend da co:

- Entity: `PhuongTien`
- DTO: `PhuongTienDto`
- Request DTO: `PhuongTienRequest`
- Service: `PhuongTienService`
- Controller: `PhuongTienController`
- Repository: `PhuongTienRepository`

Frontend da co:

- Route: `frontend/src/app/(dashboard)/dashboard/phuong-tien`
- Page, form, table phuong tien
- Type `PhuongTien` trong `frontend/src/types/index.ts`

SQL migration hien co:

`sql/migrations/20260720_add_phuong_tien.sql` tao bang `phuong_tien`:

```text
id
ma_pt
loai_xe
bien_so
khach_thue_id
phong_id
nha_tro_id
chu_tro_id
trang_thai
created_at
updated_at
```

`sql/migrations/add_phuong_tien_fields.sql` bo sung:

```text
anh_xe
loai_phuong_tien
ten_dong_xe
mau_xe
ten_chu_xe
so_ve_xe
```

Luu y can check:

- Bang `phuong_tien` co nam trong database dang chay chua.
- Enum `trang_thai_phuong_tien` co dung voi Java enum `TrangThaiPhuongTien` va frontend union `TrangThaiPhuongTien` chua.
- Chua thay logic "1 nguoi 1 xe mien phi, xe thu 2 tro len tinh phi" trong service hien tai.
- Chua thay field `hop_dong_id`, `co_tinh_phi`, `phi_gui_xe` trong entity/request/schema hien tai. Neu can, phai de xuat migration sau khi xac nhan.

### 2.3. Dich vu, cau hinh gia va chi tiet hoa don da co trong SQL

Bang da co trong SQL:

- `dich_vu`
- `cau_hinh_gia`
- `dich_vu_hop_dong`
- `chi_tiet_hoa_don`

Bang `cau_hinh_gia` hien co cac cot lien quan:

```text
nha_tro_id
dich_vu_id
loai
ten_hien_thi
loai_tinh_phi
don_gia
hieu_luc_tu
hieu_luc_den
dang_ap_dung
```

Bang `chi_tiet_hoa_don` hien co:

```text
hoa_don_id
dich_vu_id
loai
mo_ta
so_luong
don_gia
thanh_tien
```

Huong tich hop phi gui xe nen uu tien check/dung lai `dich_vu`, `cau_hinh_gia`, `dich_vu_hop_dong`, `chi_tiet_hoa_don` truoc khi de xuat enum/cot moi.

## 3. Hang muc A - Confirm thong bao cho moi them/sua/xoa

### 3.1. Muc tieu

Thong nhat confirm UI cho tat ca thao tac co thay doi du lieu. Nguoi dung phai xac nhan truoc khi du lieu duoc tao, cap nhat, xoa, import, cap phat, thu hoi.

### 3.2. Viec can lam

Frontend:

1. Tao component dung chung:
   - `frontend/src/components/ui/confirm-action-dialog.tsx`
2. Props de xuat:
   - `open`
   - `onOpenChange`
   - `title`
   - `description`
   - `confirmText`
   - `cancelText`
   - `variant`: `default | destructive`
   - `loading`
   - `onConfirm`
3. Tao helper hook neu can:
   - `useConfirmAction`
4. Thay the cac cho dang dung `window.confirm()`.

Can scan truoc khi sua:

```powershell
rg -n "confirm\\(|window.confirm|alert\\(" frontend/src
```

Module uu tien:

- `dashboard/phong`
- `dashboard/khach-thue`
- `dashboard/hop-dong`
- `dashboard/hoa-don`
- `dashboard/thanh-toan`
- `dashboard/su-co`
- `dashboard/thong-bao`
- `dashboard/tai-san-phong`
- `dashboard/phuong-tien`
- `dashboard/quan-ly-tai-khoan`

### 3.3. Quy tac noi dung confirm

Them moi:

```text
Ban co chac muon them moi [doi tuong] nay?
```

Cap nhat:

```text
Ban co chac muon cap nhat thong tin [doi tuong] nay?
```

Xoa:

```text
Thao tac xoa co the anh huong den du lieu lien quan. Ban co chac muon xoa?
```

Import:

```text
Ban co chac muon import [n] dong du lieu tu file nay?
```

Cap phat/thu hoi kho:

```text
Ban co chac muon cap phat/thu hoi [so_luong] [ten_tai_san]?
```

### 3.4. Dieu kien hoan thanh

- Khong con `window.confirm()` trong cac module CRUD chinh.
- Tat ca add/edit/delete co confirm dialog.
- Confirm co loading state, khong bam lap nhieu lan.
- Loi API hien thi ro message.

## 4. Hang muc B - Import hang loat tai san phong bang Excel

### 4.1. Muc tieu

Cho phep import nhieu tai san vao phong bang file Excel/CSV, co preview ket qua, validate tung dong, confirm truoc khi ghi database.

### 4.2. Nguyen tac schema

Khong tao bang moi neu chua can. Uu tien dung bang `tai_san_phong` hien co.

Truoc khi lam import, bat buoc check:

- Bang `tai_san_phong` trong database dang chay co cot nao.
- Cot `anh_tai_san` co ton tai hay chua.
- Cot soft delete `xoa_luc` co ton tai hay chua.
- Cot `ma_tai_san`, `don_vi`, `ngay_mua` co ton tai hay chua.

Neu cac cot tren chua co:

- Phase 1 import chi dung cac cot da co:
  - `phong_id`
  - `ten_tai_san`
  - `so_luong`
  - `gia_tri`
  - `tinh_trang`
  - `ghi_chu`
- Anh tai san co the de rieng qua UI upload, khong bat buoc trong import phase 1.
- Neu muon import hinh anh, can xac nhan migration cot anh va quy tac upload URL.

### 4.3. File mau Excel phase 1

Sheet: `tai_san_phong`

Cot de xuat phase 1:

```text
maPhong
tenTaiSan
soLuong
giaTri
tinhTrang
ghiChu
```

Cot optional neu schema da co:

```text
anhTaiSan
maTaiSan
donVi
ngayMua
```

Khong dua cot optional vao file mau neu database chua co cot tuong ung.

### 4.4. Backend can lam

Kiem tra thu vien Excel:

- Neu project da co Apache POI thi dung lai.
- Neu chua co, de xuat them dependency Apache POI va can xac nhan.
- CSV co the lam truoc neu muon giam dependency.

Endpoint de xuat:

```text
GET  /api/tai-san-phong/import/template
POST /api/tai-san-phong/import/preview
POST /api/tai-san-phong/import/commit
```

Khong import truc tiep mot buoc. Nen tach:

1. Preview:
   - Doc file.
   - Validate tung dong.
   - Map `maPhong` sang `phong_id`.
   - Tra ve danh sach dong hop le/loi.
2. Commit:
   - Nhan import session/id tam hoac payload da preview.
   - Confirm tren frontend truoc khi goi commit.
   - Ghi database trong transaction.

DTO de xuat:

```text
TaiSanPhongImportRow
TaiSanPhongImportError
TaiSanPhongImportPreviewResponse
TaiSanPhongImportCommitRequest
TaiSanPhongImportCommitResponse
```

Validate:

- `maPhong` bat buoc, phai tim thay phong cua chu tro hien tai.
- `tenTaiSan` bat buoc.
- `soLuong` > 0.
- `giaTri` >= 0.
- `tinhTrang` khong rong.
- Khong cho import tai san vao phong khong thuoc quyen truy cap.

### 4.5. Frontend can lam

Trong route hien co:

- `frontend/src/app/(dashboard)/dashboard/tai-san-phong/page.tsx`

Them:

- Nut "Tai file mau"
- Nut "Import Excel"
- Dialog import:
  - Chon file
  - Preview danh sach dong hop le/loi
  - Hien tong dong, so dong hop le, so dong loi
  - Confirm truoc khi commit

Khong thay doi layout tong the.

### 4.6. Dieu kien hoan thanh

- Import file hop le tao dung tai san phong.
- File loi khong ghi database.
- Dong loi co message ro.
- Co confirm truoc commit.
- Khong them cot/bang ngoai schema khi chua xac nhan.

## 5. Hang muc C - Quan ly kho gan voi tai san phong

### 5.1. Muc tieu

Co quan ly ton kho tai san cua nha tro/chu tro, sau do cap phat tai san tu kho vao phong.

### 5.2. Trang thai hien tai

Repo da co `tai_san_phong`, nhung chua thay module kho tai san rieng trong cac ket qua scan.

Can check lai truoc khi code:

```powershell
rg -n "kho_tai_san|KhoTaiSan|lich_su_kho|ton_kho|cap_phat" be frontend sql
```

Neu da co bang/module kho:

- Dung lai bang/module do.
- Khong tao `kho_tai_san` moi.

Neu chua co:

- Lap de xuat schema va xin xac nhan truoc khi tao migration.

### 5.3. De xuat nghiep vu kho

Kho quan ly tai san o cap nha tro/chu tro:

- Ten tai san
- Hinh anh
- Tong so luong
- So luong kha dung
- So luong da cap phat
- So luong hu hong
- Trang thai
- Ghi chu

Tai san phong la ket qua cap phat tu kho vao phong.

### 5.4. De xuat schema neu chua co bang

Chi thuc hien sau khi xac nhan.

Bang ung vien: `kho_tai_san`

```text
id
nha_tro_id
ten_tai_san
hinh_anh
tong_so_luong
so_luong_kha_dung
so_luong_da_cap_phat
so_luong_hu_hong
tinh_trang
ghi_chu
tao_luc
cap_nhat_luc
xoa_luc
```

Bang ung vien: `lich_su_kho_tai_san`

```text
id
kho_tai_san_id
phong_id
loai_giao_dich
so_luong
ghi_chu
tao_luc
```

Khong tao neu khong duoc xac nhan.

### 5.5. Backend can lam

Neu bang kho da co:

- Tao/hoan thien Entity, Repository, Service, Controller theo bang san co.

Neu bang kho chua co va da duoc xac nhan migration:

- Entity:
  - `KhoTaiSan`
  - `LichSuKhoTaiSan`
- DTO:
  - `KhoTaiSanRequest`
  - `KhoTaiSanResponse`
  - `CapPhatTaiSanRequest`
  - `ThuHoiTaiSanRequest`
- Service:
  - Nhap kho
  - Dieu chinh ton kho
  - Cap phat vao phong
  - Thu hoi tu phong
  - Bao hong
  - Thanh ly
- Controller:
  - `GET /api/kho-tai-san`
  - `POST /api/kho-tai-san`
  - `PUT /api/kho-tai-san/{id}`
  - `DELETE /api/kho-tai-san/{id}`
  - `POST /api/kho-tai-san/{id}/cap-phat`
  - `POST /api/kho-tai-san/{id}/thu-hoi`
  - `GET /api/kho-tai-san/{id}/lich-su`

### 5.6. Quy tac ton kho

Cap phat:

- So luong cap phat phai <= so luong kha dung.
- Tao/cap nhat `tai_san_phong`.
- Giam so luong kha dung.
- Tang so luong da cap phat.
- Ghi lich su kho.

Thu hoi:

- Giam/doi trang thai tai san phong.
- Neu con dung duoc, tang so luong kha dung.
- Neu hu hong, tang so luong hu hong.
- Ghi lich su kho.

Xoa kho:

- Khong cho xoa cung neu da co lich su hoac da cap phat.
- Uu tien soft delete neu schema co `xoa_luc`.
- Neu schema chua co `xoa_luc`, can xac nhan truoc khi them.

### 5.7. Frontend can lam

Route de xuat:

```text
/dashboard/kho-tai-san
```

Man hinh:

- Danh sach ton kho
- Form them/sua tai san kho
- Cap phat vao phong
- Thu hoi
- Lich su giao dich kho

Filter:

- Toa nha
- Trang thai
- Tu khoa

Tat ca thao tac ghi du lieu phai co confirm.

### 5.8. Dieu kien hoan thanh

- Khong cap phat vuot ton kho.
- Cap phat tao/cap nhat tai san phong dung.
- Thu hoi cap nhat dung ton kho.
- Co lich su giao dich.
- Co confirm cho tat ca thao tac.

## 6. Hang muc D - Phuong tien va tinh phi gui xe

### 6.1. Muc tieu

Moi khach thue duoc co 1 phuong tien mac dinh khong tinh phi. Neu khach co xe thu 2 tro len thi ap dung phi gui xe. Khi lap hoa don, phai check tu phuong tien -> hop dong de tinh phi.

### 6.2. Nguyen tac schema

Bang `phuong_tien` da co. Khong tao bang moi neu khong can.

Truoc khi sua, bat buoc check:

- `phuong_tien` co cot `khach_thue_id`, `phong_id`, `nha_tro_id`, `chu_tro_id`.
- Co cot `hop_dong_id` hay chua.
- Co cot `co_tinh_phi`, `phi_gui_xe`, `ngay_bat_dau_tinh_phi` hay chua.
- Co bang lien ket hop dong - thanh vien khach thue hay chua.
- Logic lap hoa don hien lay dich vu tu dau.

Neu chua co `hop_dong_id`:

- Phase 1 co the suy ra hop dong active qua `khach_thue_id` va `phong_id`.
- Neu can chot theo hop dong lich su, de xuat them `hop_dong_id` sau khi xac nhan.

Neu chua co `co_tinh_phi`/`phi_gui_xe`:

- Phase 1 co the tinh dong phi tai thoi diem lap hoa don, khong luu vao `phuong_tien`.
- Neu can luu trang thai ap phi tren tung xe, de xuat migration sau khi xac nhan.

### 6.3. Logic 1 nguoi 1 xe

Khi tao/cap nhat phuong tien:

1. Xac dinh `khachThueId`.
2. Tim danh sach phuong tien hieu luc cua khach thue.
3. Sap xep theo ngay tao/id.
4. Xe dau tien cua khach: mien phi.
5. Xe thu 2 tro len: tinh phi gui xe.

Khong nen hard delete phuong tien neu can lich su tinh phi. Neu hien tai service dang delete cung, can de xuat chuyen soft delete/trang thai `HET_HIEU_LUC` sau khi check schema va xac nhan.

### 6.4. Lay gia gui xe

Uu tien dung bang da co:

1. Check `dich_vu` co dich vu "Gui xe" hoac loai tuong duong.
2. Check `cau_hinh_gia` theo `nha_tro_id`, `loai`, `dang_ap_dung`.
3. Check `dich_vu_hop_dong` neu hop dong co gia rieng.

Thu tu uu tien gia de xuat:

1. Gia rieng trong `dich_vu_hop_dong` cua hop dong.
2. Gia ap dung trong `cau_hinh_gia` cua nha tro.
3. Gia mac dinh trong `dich_vu`.
4. Neu khong tim thay gia, khong tu tinh 0 ngam. Bao loi cau hinh: "Chua cau hinh phi gui xe".

### 6.5. Tich hop voi hoa don

Khi lap hoa don:

1. Xac dinh hop dong.
2. Xac dinh phong va khach thue trong hop dong.
3. Lay phuong tien hieu luc theo khach thue/phong/hop dong.
4. Tinh xe mien phi va xe tinh phi.
5. Tao dong `chi_tiet_hoa_don`.

Uu tien dung loai da co trong enum `LoaiMucHoaDon`:

- Neu co `SERVICE` hoac loai dich vu tuong duong, dung `SERVICE` va `moTa = "Phi gui xe ..."` trong phase 1.
- Chi de xuat enum moi `PARKING` neu that su can bao cao rieng va da check enum SQL/Java/frontend.

Pseudo logic:

```text
vehicles = findActiveVehicles(khachThueId, phongId or hopDongId)
freeVehicle = first vehicle by createdAt
billableVehicles = vehicles except freeVehicle
parkingFee = sum(priceByVehicleType(vehicle) for billableVehicles)
create invoice detail if parkingFee > 0
```

### 6.6. Backend can lam

Mo rong `PhuongTienService`:

- Validate bien so trung trong pham vi chu tro/nha tro.
- Validate khach thue thuoc phong/hop dong neu co.
- Them method:
  - `getActiveVehiclesByKhachThue`
  - `calculateBillableVehicles`
  - `calculateParkingFeeForContract`

Mo rong billing:

- Check `HoaDonService.create`.
- Check request lap hoa don hien co.
- Them tinh phi gui xe vao chi tiet hoa don neu du dieu kien.

Can test:

- 1 khach 0 xe: khong co phi.
- 1 khach 1 xe: khong co phi.
- 1 khach 2 xe: tinh phi 1 xe.
- 1 khach 3 xe: tinh phi 2 xe.
- Nhieu khach trong 1 hop dong: moi khach duoc mien phi 1 xe.

### 6.7. Frontend can lam

Trong `/dashboard/phuong-tien`:

- Khi chon khach thue, hien so phuong tien hieu luc hien tai.
- Neu dang them xe thu 2 tro len:
  - Hien warning: "Khach thue nay da co 1 phuong tien. Phuong tien moi co the phat sinh phi gui xe."
- Confirm truoc khi luu.
- Hien cot:
  - Khach thue
  - Phong
  - Toa nha
  - Bien so
  - Loai phuong tien
  - Trang thai
  - Co tinh phi hay khong neu backend cung cap

Trong man hinh hop dong:

- Them tab/section "Phuong tien" neu can.
- Hien danh sach xe cua khach trong hop dong.
- Hien canh bao xe phat sinh phi.

Trong man hinh hoa don:

- Preview dong "Phi gui xe" truoc khi luu hoa don.
- Cho nguoi dung thay so xe tinh phi va don gia.
- Confirm truoc khi tao/cap nhat hoa don.

## 7. Thu tu trien khai de giam rui ro

### Phase 0 - Audit truoc khi code

1. Scan confirm hien co:
   - `window.confirm`
   - `alert`
2. Doi chieu schema thuc te:
   - `tai_san_phong`
   - `phuong_tien`
   - `dich_vu`
   - `cau_hinh_gia`
   - `dich_vu_hop_dong`
   - `chi_tiet_hoa_don`
3. Doi chieu Java entity/DTO/frontend type.
4. Ghi ket qua audit vao task/PR truoc khi sua.

### Phase 1 - Confirm dung chung

1. Tao `ConfirmActionDialog`.
2. Thay `window.confirm()` trong `tai-san-phong`, `phuong-tien`.
3. Sau do lan sang cac CRUD module chinh.

### Phase 2 - Hoan thien tai san phong hien co

1. Fix cac mismatch giua schema/entity/type neu co, nhung chi sau khi xac nhan.
2. Them validate backend.
3. Neu delete dang hard delete, danh gia chuyen soft delete neu schema co san `xoa_luc`.

### Phase 3 - Import tai san phong

1. File mau.
2. Preview import.
3. Commit import co confirm.
4. Bao cao loi tung dong.

### Phase 4 - Quan ly kho

1. Check co bang/module kho hay chua.
2. Neu chua co, trinh de xuat migration.
3. Sau khi xac nhan moi code kho.
4. Tich hop cap phat kho -> tai san phong.

### Phase 5 - Phuong tien va phi gui xe

1. Hoan thien validate phuong tien.
2. Them logic dem xe theo khach thue.
3. Lay gia tu `dich_vu`/`cau_hinh_gia`.
4. Tich hop vao lap hoa don.
5. Test billing ky luong.

## 8. Checklist nghiem thu

### Confirm

- Them moi co confirm.
- Cap nhat co confirm.
- Xoa co confirm.
- Import co confirm.
- Cap phat/thu hoi kho co confirm.
- Tao hoa don co dong phi gui xe co confirm.

### Tai san phong

- Danh sach tai san dung theo quyen chu tro.
- Them/sua/xoa tai san phong dung.
- Import file hop le thanh cong.
- Import file loi khong ghi database.
- Khong import vao phong khong thuoc quyen.

### Kho tai san

- Ton kho khong am.
- Cap phat khong vuot so luong kha dung.
- Thu hoi cap nhat dung so luong.
- Lich su kho ghi dung.
- Tai san phong sinh ra dung khi cap phat.

### Phuong tien

- 1 khach 1 xe khong tinh phi.
- 1 khach 2 xe tinh phi 1 xe.
- 1 khach 3 xe tinh phi 2 xe.
- Nhieu khach trong 1 hop dong moi khach duoc mien 1 xe.
- Xe het hieu luc khong tinh phi.
- Bien so trung duoc validate theo quy tac da xac nhan.

### Hoa don

- Dong phi gui xe hien trong preview.
- Tong tien hoa don bang tong chi tiet.
- `daTra` va `trangThai` khong bi anh huong sai.
- Hoa don cu khong bi thay doi ngoai y muon.

## 9. Rủi ro can luu y

- `tai_san_phong` entity co `anhTaiSan` nhung schema scan chua thay `anh_tai_san`.
- `phuong_tien` hien chua ro co `hop_dong_id`; neu chi dua vao `phong_id`, lich su xe theo hop dong cu co the khong chinh xac.
- Billing la khu vuc rui ro cao, phai test tong tien hoa don va chi tiet hoa don.
- Neu them enum moi cho invoice line item, phai check SQL enum, Java enum, DTO response, frontend union/switch.
- Neu them kho tai san, can thiet ke transaction can than de khong am ton kho.

## 10. Cau lenh ho tro audit

```powershell
rg -n "confirm\\(|window.confirm|alert\\(" frontend/src
rg -n "tai_san_phong|TaiSanPhong|phuong_tien|PhuongTien|kho_tai_san|KhoTaiSan|cau_hinh_gia|dich_vu|chi_tiet_hoa_don" be frontend sql
rg -n "LoaiMucHoaDon|loai_muc_hoa_don|SERVICE|PARKING|TIEN_DICH_VU" be frontend sql
```

## 11. Ket luan

Khong nen lam moi hoan toan cac module tai san phong va phuong tien vi repo da co nen tang san. Huong dung la:

1. Check bang/cot/module hien co.
2. Hoan thien confirm dung chung.
3. Mo rong tai san phong bang import.
4. Thiet ke kho dua tren schema da co hoac de xuat migration rieng.
5. Mo rong phuong tien de tinh phi gui xe theo hop dong/hoa don.
6. Moi thay doi schema deu phai co buoc xac nhan truoc khi tao migration.
