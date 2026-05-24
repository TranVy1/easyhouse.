# Rental Management Fix Plan

Ngay lap: 2026-05-24

Pham vi: nghiep vu quan ly nha tro EasyHouse. Trong dot sua nay uu tien hop dong, hoa don, chi so dien nuoc, dich vu hop dong, thanh toan lien quan hoa don.

## 0. Nguon doi chieu nghiep vu

- Hop dong nha o: Dieu 163 Luat Nha o 2023 yeu cau hop dong ve nha o lap thanh van ban, co thong tin cac ben, mo ta nha o/dat o, gia tri, thoi han, quyen/nghia vu, cam ket, thoi diem hieu luc, ngay ky va chu ky. Dieu 164: hop dong thue nha khong bat buoc cong chung/chung thuc tru khi cac ben co nhu cau. Nguon: https://thuvienphapluat.vn/chinh-sach-phap-luat-moi/vn/ho-tro-phap-luat/tu-van-phap-luat/71831/theo-luat-nha-o-2023-thi-hop-dong-cho-thue-nha-o-co-phai-cong-chung-chung-thuc-hay-khong
- Tam tru: Cong dan den sinh song tai cho o hop phap ngoai xa/phuong thuong tru tu 30 ngay tro len phai dang ky tam tru; co quan cu tru xu ly ho so hop le trong 03 ngay lam viec. Nguon: https://thuvienphapluat.vn/chinh-sach-phap-luat-moi/vn/ho-tro-phap-luat/chinh-sach-moi/33228/dieu-kien-thu-tuc-dang-ky-tam-tru-tu-ngay-01-7-2021
- Hoa don/dich vu theo ky: voi dich vu phat sinh thuong xuyen can doi soat so lieu nhu dien/nuoc, thoi diem lap hoa don cham nhat khong qua ngay 07 cua thang sau thang phat sinh hoac 07 ngay tu ngay ket thuc ky quy uoc. Nguon: https://cspl.mic.gov.vn/Pages/TinTuc/138248/Nghi-dinh-123-2020-Nd-CP-quy-dinh-ve-hoa-don--chung-tu.html
- Thue cho thue tai san: ca nhan cho thue nha khai theo tung ky/thang/nam; doanh thu 100 trieu dong/nam la nguong xac dinh nghia vu GTGT/TNCN theo quy dinh hien hanh, ho so khai thue lan dau can ban sao hop dong/phu luc. Nguon: https://thuvienphapluat.vn/van-ban/Thue-Phi-Le-Phi/Thong-tu-40-2021-TT-BTC-huong-dan-thue-gia-tri-gia-tang-thue-thu-nhap-ca-nhan-477635.aspx
- Du lieu ca nhan/CCCD: du lieu ca nhan phai xu ly dung muc dich, chu the duoc biet, duoc dong y, duoc yeu cau cung cap/chinh sua/xoa trong cac truong hop luat cho phep. Nguon: https://xaydungchinhsach.chinhphu.vn/toan-van-nghi-dinh-13-2023-nd-cp-bao-ve-du-lieu-ca-nhan-119230516104357809.htm
- PCCC nha tro: nha tro thuoc dien quan ly ve phong chay chua chay; dieu kien an toan theo Nghi dinh 136/2020 va Nghi dinh 50/2024; nha tro nho duoi 5 tang va tong khoi tich duoi 2.500m3 do UBND cap xa quan ly nhung van phai dam bao ho so va dieu kien PCCC. Nguon: https://chinhsachonline.chinhphu.vn/nha-tro-can-dap-ung-dieu-kien-gi-ve-phong-chay-chua-chay-73591.htm va https://xaydungchinhsach.chinhphu.vn/nha-dang-o-thua-2-phong-neu-cho-thue-o-tro-thi-thuoc-dien-quan-ly-ve-pccc-voi-nha-tro-khong-119240908120037955.htm

Ket luan doi chieu: code cu moi dung luong CRUD, thieu rang buoc phap ly/nghiep vu cho hop dong, thieu billing backend-first, thieu workflow tam tru/PCCC/privacy/thue. Dot sua nay xu ly truoc hop dong/hoa don/thanh toan, cac phan phap ly van hanh con lai dua vao P1/P2 rieng.

## 1. Loi hien tai

### P0 - bao mat va tach du lieu

- Backend `SecurityConfig` dang `anyRequest().permitAll()`. Moi endpoint CRUD/admin/payment/delete co the goi khong can quyen.
- JWT da sinh nhung nhieu controller/service chua dung authorization/owner scope.
- `UserController` con doc Bearer token nhu email va co fallback hardcode dev.
- Cac `getAll()` trong hop dong, hoa don, khach thue, phong chua loc theo chu tro.
- RLS trong `sql/db.sql` dua vao `auth.uid()`, nhung Spring Boot khong set Supabase auth context.

Trang thai: chua sua trong dot nay. Can lam thanh pha rieng vi anh huong tat ca module.

### P0 - hop dong

- Ma hop dong bat buoc/unique o DB, nhung service khong normalize, khong auto sinh, khong check duplicate som.
- Parse status sai thi fallback am tham, de request sai van thanh hop dong hop le.
- Chua validate phong/khach thue cung chu tro.
- Thanh vien hop dong co the vuot so nguoi toi da cua phong.
- Thanh vien co ngay roi truoc ngay vao chua bi chan trong service.
- Dich vu hop dong co the nhan don gia/so luong am neu request sai, chi de DB bat loi muon.
- Dich vu bat buoc trong cau hinh gia/dich vu chua duoc copy mac dinh vao hop dong khi frontend khong gui.
- `giaDien`, `giaNuoc` trong response hop dong chua set, lam frontend hoa don phu thuoc vao doan doan tu `phiDichVu`.

Trang thai: da sua trong dot nay.

### P0 - hoa don

- Create hoa don cho phep thieu `hopDong/phong/khachThue` trong code, de DB loi sau.
- Chua check duplicate hoa don theo `hopDongId + kyNam + kyThang` truoc khi insert/update.
- Tien phong/dien/nuoc dang tin vao tong tien frontend gui, chua tinh uu tien tu hop dong + cau hinh gia + chi so.
- Chi so dien nuoc co upsert, nhung line item hien de `soLuong = 1`, `donGia = tong tien`, lam mat don vi tieu thu.
- Chua validate ky hoa don co giao voi thoi han hop dong.
- Update hoa don rebuild line item nhung chua cap nhat status theo tong/daTra/hanTra ro rang o service.
- Response tra `chiTietHoaDon` nhung frontend normalizer doc `chiTiet`, lam tien phong/dien/nuoc de bi ve 0.
- Xoa hoa don soft delete nhung unique DB van chan tao lai cung hop dong/ky. Can migration sau neu muon reuse ky da xoa.

Trang thai: da sua trong dot nay phan service/DTO/frontend mapper. Migration unique soft-delete can pha DB rieng.

### P1 - thanh toan

- Tao thanh toan mac dinh `SUCCESS`, chua co pending/duyet/doi soat.
- Service recalc cong moi thanh toan, chua loc trang thai `SUCCESS` nhu DB trigger.
- Delete thanh toan la hard delete, mat audit.
- Chua chan so tien <= 0 o service.

Trang thai: da sua nhe trong dot nay: validate so tien, loc `SUCCESS` khi recalc, chan hoa don da xoa/huy.

### P1 - tam tru va du lieu ca nhan

- Chua co workflow tam tru: deadline 30 ngay, trang thai ho so, file xac nhan, export danh sach.
- Luu CCCD/anh CCCD nhung chua co consent, muc dich xu ly, retention, audit xem/xoa.

Trang thai: document, chua sua code.

### P2 - bao cao/van hanh

- Thieu rent roll, aging debt, doanh thu theo nha tro/phong/thang, thue cho thue tai san.
- Thieu checklist PCCC/bao tri dinh ky.
- Test nghiep vu gan nhu chua co.

Trang thai: document, chua sua code.

## 2. Ke hoach sua

### Pha A - hop dong

- Normalize va auto sinh `maHopDong` neu rong.
- Check duplicate ma hop dong khi create/update.
- Validate phong va khach thue con hoat dong, chua xoa, cung chu tro.
- Validate ngay bat dau/ket thuc, tien thue/coc, ngay thanh toan, chi so ban dau.
- Validate so thanh vien dang o khong vuot `phong.soNguoiToiDa`.
- Validate ngay vao/roi cua thanh vien nam trong hop dong.
- Copy dich vu bat buoc mac dinh tu `dich_vu`/`cau_hinh_gia` khi request khong gui.
- Tinh `giaDien`, `giaNuoc` trong response tu dich vu/cau hinh gia.

### Pha B - hoa don

- Bat buoc co hop dong hop le, tu hop dong suy ra phong va khach thue.
- Validate ky thang/nam, khoang tuNgay/denNgay/hanTra.
- Check duplicate hop dong/ky khi create/update.
- Validate ky hoa don giao voi hop dong.
- Build line item backend-first:
  - Tien phong = request override neu co, nguoc lai lay `hopDong.giaThueHopDong`.
  - Dien/nuoc = tieu thu * don gia cau hinh dang ap dung; neu chua co cau hinh thi fallback tu tong tien frontend / tieu thu.
  - Dich vu = `dich_vu_hop_dong` dang hieu luc; fallback request legacy neu hop dong chua co service.
- Luu chi so dien nuoc voi tieu thu dung `soLuong`.
- Recompute tong tien/status sau khi line item thay doi.
- Response tra ca `chiTietHoaDon` va `chiTiet`.
- Frontend normalizer doc them `chiTietHoaDon`.

### Pha C - thanh toan lien quan hoa don

- Validate hoa don ton tai, chua xoa/huy.
- Validate so tien > 0.
- Recalculate `daTra` chi tu thanh toan `SUCCESS`.
- Status hoa don tinh theo `daTra/tongTien/hanTra`.

### Pha D - sau dot nay

- Security/RBAC/owner scope.
- Tenant portal `/api/auth/khach-thue/me`.
- Deposit/phu luc/thanh ly hop dong.
- Tam tru, privacy CCCD, PCCC, thue, bao cao.
- Migration unique hoa don soft-delete.
- Test frontend va backend day du hon.

## 3. Da thuc hien trong dot 2026-05-24

- Hop dong:
  - Auto sinh ma hop dong khi request rong.
  - Check trung ma hop dong truoc khi save.
  - Validate phong/khach thue cung chu tro.
  - Chan hop dong occupying tren phong bao tri/ngung hoat dong.
  - Validate ngay, tien, chi so ban dau, suc chua phong, thanh vien.
  - Them dich vu bat buoc mac dinh vao hop dong neu frontend khong gui.
  - Tra `giaDien`, `giaNuoc` trong response hop dong tu `cau_hinh_gia`/dich vu hop dong.
- Hoa don:
  - Bat buoc lap hoa don tu hop dong hop le.
  - Suy phong/khach thue tu hop dong, chan request sai phong/khach.
  - Check duplicate `hopDong + kyNam + kyThang` truoc create/update.
  - Validate ky, ngay, han tra, va ky hoa don giao voi hop dong.
  - Tinh line tien phong tu hop dong.
  - Tinh dien/nuoc = tieu thu * don gia uu tien tu `cau_hinh_gia`, fallback tu dich vu hop dong, fallback tu tong tien frontend.
  - Chan lap hoa don khi co chi so dien/nuoc tieu thu nhung khong co don gia hop le, tranh bo sot tien am tham.
  - Luu chi so dien nuoc va line item voi `soLuong = tieuThu`, `donGia = don gia`.
  - Tinh dich vu tu `dich_vu_hop_dong`, co PER_PERSON theo thanh vien dang o.
  - Recompute tong tien/trang thai trong service sau khi rebuild line item.
  - Response them alias `chiTiet` song song `chiTietHoaDon` de frontend mapper doc dung.
- Thanh toan:
  - Bat buoc co hoa don.
  - Chan thanh toan hoa don da xoa/da huy.
  - Validate so tien > 0.
  - Set khach thue tu hoa don.
  - Recalculate `daTra` chi tu thanh toan `SUCCESS`.
- Frontend:
  - `normalizeHoaDon` doc them `chiTietHoaDon`.
  - Contract pages bo lint error `any` o dich vu va escape quote UI.
  - Su co page bo lint error `any` cu de `npm run lint` con warning, khong con error.
- Test:
  - Them `HoaDonServiceTest`: tinh tien tu hop dong/cau hinh/chi so, chan trung ky hoa don, va chan chi so dien/nuoc khi thieu don gia.

## 4. Kiem tra sau sua

- `docker exec easyhouse-backend mvn -DskipTests compile`: pass.
- `docker exec easyhouse-backend mvn test`: pass, 4 tests.
- `docker exec easyhouse-frontend npm run build`: pass.
- `docker exec easyhouse-frontend npm run lint`: pass voi 0 error, con 121 warning cu.
- `git diff --check`: pass, chi co warning CRLF tu Git tren Windows.
