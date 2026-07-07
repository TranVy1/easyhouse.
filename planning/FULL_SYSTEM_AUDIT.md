# FULL SYSTEM AUDIT - EasyHouse Quan Ly Phong Tro Thong Minh

> **Nguoi phan tich:** Senior Software Architect + System Analyst
> **Ngay audit:** 2026-07-07
> **Tieu chuan:** Production-grade SaaS (khong phai do an)
> **Pham vi:** Backend Spring Boot + Frontend Next.js + PostgreSQL Schema

---

## MUC LUC

1. Tong quan he thong
2. Audit Backend (Cuc ky)
3. Audit Business Logic
4. Audit Frontend
5. Data Consistency
6. Bug va Risk Real-World
7. De xuat nang cap (MUST / SHOULD / NICE)
8. Danh gia AI Features
9. Cham diem tong the

---

## 1. TONG QUAN HE THONG

### Kien truc hien tai

```
[Next.js Frontend] --(fetch /api/*)--> [next.config.ts proxy] --> [Spring Boot :8080]
                                                                        |
                                                               [PostgreSQL / Supabase]
                                                                        |
                                                               [Cloudinary (media)]
```

### Trang thai thuc te (2026-07-07)

| Thanh phan | Trang thai | Ghi chu |
|---|---|---|
| Backend | OK | `mvn spring-boot:run` hoat dong |
| Frontend | OK | `npm run dev` hoat dong |
| Auth (JWT) | CANH BAO | Token = email, khong phai signed JWT |
| Database schema | OK | 65+ entities Java, nhieu bang quan he |
| Business logic | OK | HoaDonService/HopDongService rat day |
| CauHinhGia | OK | Entity + Service + Controller day du |
| DatCocPhong | THIEU LUONG | Controller co nhung flow dat coc -> hop dong bi dut |
| Check-out / Thanh ly | THIEU | Chi co TERMINATED status, khong co form chot cong to |
| So quy (Thu/Chi) | CHUA CO | Khong co entity/service rieng |

### Nhan dinh so bo

He thong TOT HON NHIEU so voi mot do an thong thuong. Code da duoc cau truc ro rang theo
DTO -> Service -> Entity -> Response, co transaction boundary, co soft delete (xoaLuc), co audit log.
Day la nen tang solid de dua ra production.

---

## 2. AUDIT BACKEND - CUC KY

### 2.1 Diem Tot - Da lam dung

#### Soft Delete da co

```java
// HopDong.java, HoaDon.java, Phong.java
private ZonedDateTime xoaLuc; // null = con ton tai, not-null = da xoa mem
```
Tat ca cac truy van deu filter `xoaLuc IS NULL`. Pattern dung.

#### Snapshot gia dich vu da co

```java
// DichVuHopDong.java
private BigDecimal donGiaApDung; // Gia duoc dong bang tai thoi diem ky hop dong
```
Khi tao hoa don, he thong lay `donGiaApDung` tu `DichVuHopDong` chu khong lay gia
hien tai tu `DichVu`. DUNG THIET KE.

#### CauHinhGia da implement day du

```java
// CauHinhGia.java
private LocalDate hieuLucTu;
private LocalDate hieuLucDen;
private Boolean dangApDung = true;
```
Co tinh hieu luc theo thoi gian. `findApplicable()` tra ve gia co hieu luc tai ngay lap hoa don.
DUNG VA DU.

#### PhuLucHopDong da co

```java
// PhuLucHopDong.java
private BigDecimal giaThueMoi;
private LocalDate ngayKetThucMoi;
```
Phu luc hop dong ho tro thay doi gia thue. Giai quyet van de thay doi gia trong thoi gian hop dong.

#### Concurrency - da co mot phan

```java
// HoaDonService.upsertReading()
if (reading.getId() != null && reading.getHopDong() != null
        && !reading.getHopDong().getId().equals(ctx.hopDong().getId())
        && reading.getTrangThai() != TrangThaiChiSo.CANCELLED) {
    throw new RuntimeException("Chi so cua phong trong ky nay da duoc ghi cho hop dong khac");
}
```
Kiem tra duplicate chi so, nhung CHUA CO DB-level lock.

---

### 2.2 Van de Nghiem trong

#### [BUG-01] Token la email thuan - KHONG phai JWT an toan

```java
// AuthService.java
AuthResponse.token = user.getEmail(); // Email cua nguoi dung, khong phai JWT
```

```java
// UserController.java
// Co fallback hardcode development: docong88@gmail.com
```

RUI RO: Bat ky ai biet email deu co the gia mao token. Khong the revoke. Khong co expiry.

SUA: Da co `JwtService.java`. Can wire vao AuthController:
```java
String token = jwtService.generateToken(user.getEmail(), user.getId(), roles);
return new AuthResponse(token, user.getEmail(), ...);
```

---

#### [BUG-02] Race Condition khi tao hoa don

```java
// HoaDonService.ensureInvoicePeriodAvailable() - check-then-act pattern
Optional<HoaDon> existing = hoaDonRepository
    .findByHopDongIdAndKyNamAndKyThangAndXoaLucIsNull(...);
if (existing.isPresent()) {
    throw new RuntimeException("da co hoa don");
}
// WINDOW: Request thu 2 co the di qua day truoc khi request 1 save xong!
HoaDon saved = hoaDonRepository.save(hd);
```

KICH BAN LOI: 2 nhan vien cung tao hoa don thang 7/2026 cho cung hop dong
-> 2 hoa don trung ky duoc tao.

SUA: Them UNIQUE CONSTRAINT o database:
```sql
CREATE UNIQUE INDEX IF NOT EXISTS uq_hoa_don_hop_dong_ky
ON hoa_don (hop_dong_id, ky_thang, ky_nam)
WHERE xoa_luc IS NULL;
```
Va them `@Version` vao HoaDon entity cho Optimistic Locking.

---

#### [BUG-03] Double Payment - Thieu idempotency check

```java
// ThanhToanService.create() - KHONG CO check duplicate
ThanhToan tt = ThanhToan.builder()...build();
ThanhToan saved = thanhToanRepository.save(tt); // Luu ngay, khong check
recalculate(hoaDon.getId());
```

Trong khi do recordBankTransactionMatch() CO check:
```java
if (thanhToanRepository.findByExternalTransactionId(externalId).isPresent()) {
    throw new RuntimeException("Giao dich nay da tao thanh toan");
}
```

RUI RO: User click "Ghi nhan thanh toan" 2 lan do mang cham -> 2 ban ghi cung gia tri
-> daTra vuot tongTien -> hoa don OVERPAID.

SUA: Them idempotency check o backend + debounce 5s o frontend.

---

#### [BUG-04] Thieu xu ly Reset Cong to

```java
// HoaDonService.addMeterLine()
if (chiSoCu < 0 || chiSoMoi < chiSoCu) {
    throw new RuntimeException("Chi so dien nuoc khong hop le");
}
```

KICH BAN NGOAI DOI: Cong to cu hong, thay moi. Chi so cu = 9999, chi so moi = 0015.
He thong throw exception -> khong the lap hoa don!

SUA: Them field `resetCongTo: Boolean` + `soKwhThucTe: Integer` vao HoaDonRequest:
```java
if (Boolean.TRUE.equals(req.getResetCongTo()) && req.getSoKwhThucTe() != null) {
    tieuThu = req.getSoKwhThucTe(); // Override, cho nhap tay tieu thu
} else {
    if (chiSoMoi < chiSoCu) throw new RuntimeException("...");
    tieuThu = chiSoMoi - chiSoCu;
}
```

---

#### [BUG-05] NullPointerException trong thanhToanCoc()

```java
// HopDongService.thanhToanCoc()
// NPE neu khachThue khong co nguoiDung (khach thue chua co tai khoan)
if (!hd.getKhachThue().getNguoiDung().getId().equals(userId) && !isAdmin) {
    ...
}
```

KICH BAN: Chu tro tao khach thue thu cong (khong co tai khoan). getNguoiDung() = null
-> NullPointerException -> 500 Internal Server Error.

SUA:
```java
KhachThue kt = hd.getKhachThue();
boolean isOwner = kt != null && kt.getNguoiDung() != null
                  && kt.getNguoiDung().getId().equals(userId);
if (!isOwner && !permissionService.isAdmin(userId)) {
    throw new RuntimeException("Khong co quyen thao tac");
}
```

---

#### [BUG-06] Deposit Invoice Code dung Math.random() - De trung

```java
// HopDongService.create()
String maHoaDon = "HD" + System.currentTimeMillis() + (int)(Math.random() * 100);
```

VAN DE: 2 hop dong tao cung millisecond -> 1% kha nang trung ma -> unique constraint violation.

SUA:
```java
String maHoaDon = "COC-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
```

---

### 2.3 Quan he Entity va Foreign Key

| Quan he | Trang thai | Ghi chu |
|---|---|---|
| HopDong -> Phong | Dung | FK, LAZY loading |
| HopDong -> KhachThue | Dung | FK, LAZY loading |
| HoaDon -> HopDong + Phong + KhachThue | Du thua | phong/khachThue da co trong hopDong |
| ChiTietHoaDon -> HoaDon | Dung | FK |
| ThanhToan -> HoaDon | Dung | FK |
| DatCocPhong -> Phong + KhachThue + HopDong | Thieu lien ket | Flow booking->contract bi dut |

### 2.4 Transaction va Rollback

```java
// ThanhToanService.create() - Pattern dung
@Transactional
public ThanhToanResponse create(ThanhToanRequest req) {
    ThanhToan saved = thanhToanRepository.save(tt);
    recalculate(hoaDon.getId()); // Cung transaction
    try {
        emailService.sendPaymentReceivedEmail(...); // Bat loi rieng
    } catch (Exception e) { /* ignore - email loi khong cuon rollback */ }
}
```

THIEU: @Transactional(rollbackFor = Exception.class) - mac dinh Spring chi rollback voi
RuntimeException, khong rollback voi checked Exception (IOException, v.v.)

---

## 3. AUDIT BUSINESS LOGIC

### 3.1 Luong Thue Phong

```
[Hien tai - Dung]
Khach -> Chu tro tao KhachThue -> Tao HopDong (DRAFT)
      -> Preview -> Confirm (ACTIVE + tao lich thanh toan)
      -> Tao HoaDon hang thang

[Thieu - Flow dat coc tu nhien]
Khach tu dat lich xem phong (LichHen)
-> Khach dat coc (DatCocPhong) - CAO NHAT LA CHU TRO
-> Chu tro duyet coc
-> Tao hop dong tu coc (CHUA CO BUOC NAY)
```

DatCocPhong co entity day du, co service, co controller, co frontend route /dashboard/dat-coc.
NHUNG: Khong co luong tu dong tao HopDong tu DatCocPhong khi xac nhan.
THIEU: Nut "Chuyen thanh hop dong" trong DatCocPhong detail -> pre-fill form HopDong.

### 3.2 Luong Hoa Don

Da lam DUNG:
- Snapshot gia: cauHinhGiaRepository.findApplicable(nhaTroId, loai, ctx.tuNgay())
- Ke thua no cu: soDuDauKy duoc tinh tu dong (chi la goi y cho UI)
- Validate ky hoa don: Chan tao 2 hoa don cung thang cho cung hop dong
- Tu dong chuyen trang thai: resolveInvoiceStatus() xac dinh OVERDUE neu hanTra da qua

VAN DE:
1. soDuDauKy khong tu dong dien vao hoa don moi - nguoi dung phai nhap tay.
2. HoaDon.buildLineItems() lay gia phong tu giaThueHopDong, KHONG nhin vao PhuLucHopDong:
   ```java
   req.getTienPhong() != null ? req.getTienPhong()
       : defaultMoney(ctx.hopDong().getGiaThueHopDong())
   // KHONG check PhuLucHopDong -> hoa don lay gia cu sau khi tang gia!
   ```

### 3.3 Luong Dien Nuoc

Dung:
- Validate chiSoMoi >= chiSoCu >= 0
- Luu ChiSoDienNuoc rieng, co trang thai BILLED/CANCELLED
- latestReading() tra ve chi so cuoi cua ky truoc

Thieu:
- Khong xu ly Reset cong to (Bug #4)
- Khong co upload anh cong to kem chi so trong luong lap hoa don
  (field anhDongHo co trong entity nhung khong co trong HoaDonRequest flow)

### 3.4 Luong Check-out (Thanh ly hop dong) - NGHIEM TRONG

Hien trang:
```java
// HopDongService.update() khi status = TERMINATED
hd.setTrangThai(TrangThaiHopDong.TERMINATED);
hd.setTrangThaiCoc(TrangThaiCocHopDong.REFUNDED); // TU DONG REFUND?!
syncRoomStatus(hd.getPhong().getId());
```

VAN DE NGHIEM TRONG: Khi set TERMINATED, he thong tu dong set coc la REFUNDED ma khong tinh:
- Ngay chot dien nuoc cuoi
- Tien con no chua thanh toan
- Thiet hai tai san
- So ngay o them (ra truoc/sau ngay ket thuc)

THIEU: Endpoint /api/hop-dong/{id}/thanh-ly voi payload:
```json
{
  "ngayRa": "2026-07-15",
  "chiSoDienCuoi": 1523,
  "chiSoNuocCuoi": 445,
  "tienCocHoanTra": 2000000,
  "soTienKhauTru": 500000,
  "lyDoKhauTru": "Son tuong hao mon",
  "taoHoaDonCuoi": true
}
```
Logic: Tao HoaDon thang cuoi -> Tinh tienCocHoanTra = tienCoc - soTienKhauTru - noCon
     -> Set trangThaiCoc -> Set TERMINATED -> syncRoomStatus -> phong ve AVAILABLE

---

## 4. AUDIT FRONTEND

### 4.1 Routes co mat nhung thieu backend

| Frontend Route | Backend | Trang thai |
|---|---|---|
| /khach-thue/dang-nhap | /api/auth/khach-thue/login | MISSING |
| /khach-thue/dashboard | TenantApiController | Co controller, chua proxy next.config.ts |
| /dashboard/dat-coc | DatCocPhongController | Co, chua proxy /api/dat-coc |
| /dashboard/cau-hinh-gia | CauHinhGiaController | Can kiem tra proxy |
| /dashboard/vietqr-doi-soat | BankTransactionController | Co |

### 4.2 UX Issues Cu the

[UX-01] Luong xac nhan thue bi dut:
- /dashboard/lich-hen co UI nhung khong tu dong doi trang thai phong sau xac nhan
- LichHen -> DatCocPhong -> HopDong la 3 buoc roi nhau, khong co wizard

[UX-02] Form tao HoaDon khong auto-fill soDuDauKy:
getLatestReading() tra ve soDuDauKy nhung frontend can tu goi API va pre-fill.
Nguoi dung phai nho so no cu va nhap tay -> dez sai.

[UX-03] Khong co man hinh Thanh ly hop dong:
Chi co the doi trangThai = TERMINATED tu danh sach. Khong co form chot cong to, tinh hoan coc.

[UX-04] Dashboard thieu canh bao thuc te:
- Khong co widget "Hop dong het han trong 7 ngay"
- Khong co widget "Hoa don qua han"
- SchedulerService gui email nhung khong push notification realtime len dashboard

[UX-05] Phong da cho thue van hien thi trong /xem-phong public:
Can filter trangThai = AVAILABLE o PublicApiController.

---

## 5. DATA CONSISTENCY

### 5.1 Hoa don vs. Hop dong

| Truong hop | Rui ro | Muc do |
|---|---|---|
| Xoa phong khi co hop dong active | Bi chan (soft delete) | AN TOAN |
| Sua gia thue trong hop dong active (khong qua PhuLuc) | Hoa don thang sau tu lay gia moi | TRUNG BINH |
| Khach thue bi xoa khi co hop dong | Soft delete nhung hoa don van lien ket | CAN KIEM TRA |
| Hoa don lay sai gia dien do doi CauHinhGia | Da dung hieuLucTu filter | AN TOAN |

### 5.2 Payment vs. Invoice - Van de daTra 2 nguon

```java
// Nguon 1: ThanhToanService.recalculate() - DUNG
hd.setDaTra(total); // Tong tu bang thanh_toan
hoaDonRepository.save(hd);

// Nguon 2: HoaDonService.update() - SAI THIET KE
if (req.getDaThanhToan() != null) hd.setDaTra(...); // Admin sua truc tiep!
```

RUI RO: Admin sua daTra qua form edit hoa don -> lech voi tong ThanhToan trong DB.

SUA: Khong cho phep sua daTra truc tiep trong HoaDonService.update().
daTra chi duoc cap nhat qua recalculate().

### 5.3 Trang thai Phong

syncRoomStatus() duoc goi sau moi thay doi hop dong. Tot.
Can kiem tra: Neu co 2 hop dong cho cung phong (cu EXPIRED, moi ACTIVE),
syncRoomStatus() co lay dung trang thai khong?

---

## 6. BUG VA RISK REAL-WORLD

### Bang tong hop rui ro khi deploy that

| # | Bug | Mo ta | Xac suat | Impact | Uu tien |
|---|---|---|---|---|---|
| 1 | Token = Email | Gia mao danh tinh de dang | Cao | CRITICAL | MUST FIX |
| 2 | Race Condition tao HoaDon | 2 hoa don cung ky cho 1 hop dong | Trung binh | HIGH | MUST FIX |
| 3 | Double Payment | Thanh toan 2 lan do click nhieu | Trung binh | HIGH | MUST FIX |
| 4 | Reset cong to | Khong the lap hoa don sau thay cong to | Cao | HIGH | MUST FIX |
| 5 | NPE trong thanhToanCoc | Crash khi khach thue chua co tai khoan | Cao | HIGH | MUST FIX |
| 6 | Deposit invoice code trung | Unique constraint violation | Thap | MEDIUM | SHOULD |
| 7 | daTra 2 nguon cap nhat | So tien da tra lech | Trung binh | HIGH | MUST FIX |
| 8 | PhuLucHopDong khong anh huong HoaDon | Hoa don lay gia cu sau tang gia | Cao | HIGH | MUST FIX |
| 9 | Check-out thieu | Hoan coc sai, khong chot cong to | Cao | HIGH | MUST FIX |
| 10 | DatCocPhong khong auto -> HopDong | Flow dut, thu cong | Trung binh | MEDIUM | SHOULD |
| 11 | Phong da thue hien tren trang public | Khach dat nham phong da co nguoi | Cao | MEDIUM | SHOULD |
| 12 | TypeScript/ESLint tat trong build | Bug frontend khong bi phat hien | Cao | MEDIUM | SHOULD |
| 13 | next.config.ts thieu proxy | 404 khi truy cap dat-coc, cau-hinh-gia | Cao | MEDIUM | SHOULD |

---

## 7. DE XUAT NANG CAP

### MUST FIX (Bat buoc - Dung yeu cau giang vien)

#### Fix 1: Hoan thien JWT Authentication

JwtService.java da co - can wire vao AuthController:
```java
// AuthService.java - method login()
String token = jwtService.generateToken(user.getEmail(), user.getId(), roles);
return new AuthResponse(token, user.getEmail(), ...);
```
File can sua: AuthService.java, SecurityConfig.java

#### Fix 2: DB Unique Constraint cho Hoa don (chong Race Condition)

```sql
-- Them vao patch.sql
CREATE UNIQUE INDEX IF NOT EXISTS uq_hoa_don_hop_dong_ky
ON hoa_don (hop_dong_id, ky_thang, ky_nam)
WHERE xoa_luc IS NULL;
```

Them vao HoaDon.java:
```java
@Version
private Long version; // Optimistic Locking
```

#### Fix 3: Sua daTra chi update qua recalculate

Trong HoaDonService.update(), XOA dong:
```java
// if (req.getDaThanhToan() != null) hd.setDaTra(...); // XOA DONG NAY
```

#### Fix 4: Sua NPE trong thanhToanCoc()

```java
// TRUOC (bi NPE):
if (!hd.getKhachThue().getNguoiDung().getId().equals(userId) && !isAdmin)

// SAU (an toan):
KhachThue kt = hd.getKhachThue();
boolean isOwner = kt != null && kt.getNguoiDung() != null
                  && kt.getNguoiDung().getId().equals(userId);
if (!isOwner && !permissionService.isAdmin(userId)) {
    throw new RuntimeException("Khong co quyen thao tac");
}
```

#### Fix 5: Xu ly Reset Cong to

Them vao HoaDonRequest.java:
```java
private Boolean resetCongTo = false;
private Integer soKwhThucTe;
private Integer soKhoiNuocThucTe;
```

Trong addMeterLine() HoaDonService:
```java
if (Boolean.TRUE.equals(req.getResetCongTo()) && req.getSoKwhThucTe() != null) {
    tieuThu = req.getSoKwhThucTe();
} else {
    if (chiSoMoi < chiSoCu) throw new RuntimeException("Chi so khong hop le");
    tieuThu = chiSoMoi - chiSoCu;
}
```

#### Fix 6: Luong Thanh ly Hop dong (Check-out)

Tao endpoint: POST /api/hop-dong/{id}/thanh-ly

Logic service:
1. Tao HoaDon thang cuoi voi chi so dien nuoc cuoi
2. Tinh tienCocHoanTra = tienCoc - soTienKhauTru - noCon
3. Set trangThaiCoc = DEDUCTED hoac REFUNDED
4. Set hop_dong.trangThai = TERMINATED, ghi ngayKetThucThucTe
5. syncRoomStatus() -> phong ve AVAILABLE

#### Fix 7: PhuLucHopDong anh huong gia phong trong HoaDon

Them helper method trong HoaDonService:
```java
private BigDecimal resolveRoomPrice(InvoiceContext ctx) {
    LocalDate invoiceDate = ctx.tuNgay();
    // Tim phu luc co hieu luc tai thoi diem lap hoa don
    return phuLucHopDongRepository.findByHopDongId(ctx.hopDong().getId()).stream()
        .filter(pl -> pl.getGiaThueMoi() != null)
        .filter(pl -> !pl.getNgayHieuLuc().isAfter(invoiceDate))
        .max(Comparator.comparing(PhuLucHopDong::getNgayHieuLuc))
        .map(PhuLucHopDong::getGiaThueMoi)
        .orElse(ctx.hopDong().getGiaThueHopDong());
}
```

#### Fix 8: Sua next.config.ts proxy thieu

Them vao frontend/next.config.ts:
```typescript
{ source: '/api/dat-coc/:path*',
  destination: 'http://localhost:8080/api/dat-coc/:path*' },
{ source: '/api/cau-hinh-gia/:path*',
  destination: 'http://localhost:8080/api/cau-hinh-gia/:path*' },
{ source: '/api/chi-so-dien-nuoc/:path*',
  destination: 'http://localhost:8080/api/chi-so-dien-nuoc/:path*' },
{ source: '/api/lich-hen/:path*',
  destination: 'http://localhost:8080/api/lich-hen/:path*' },
{ source: '/api/bao-cao/:path*',
  destination: 'http://localhost:8080/api/bao-cao/:path*' },
```

---

### SHOULD IMPROVE (De giong san pham that)

1. Wizard 3 buoc: Lich hen -> Dat coc -> Tao hop dong tu coc
   Backend: POST /api/dat-coc/{id}/chuyen-thanh-hop-dong

2. Auto-fill soDuDauKy trong form HoaDon:
   Frontend goi GET /api/hoa-don/latest-reading?hopDongId=xxx&thang=7&nam=2026
   -> Pre-fill soDuDauKy, chiSoDienBanDau, chiSoNuocBanDau

3. Dashboard Widgets canh bao realtime:
   [Hop dong het han trong 7 ngay: 3] [Hoa don qua han: 5] [Phong trong: 12]

4. Filter phong da thue tren trang public:
   ```java
   // PublicApiController
   phongRepository.findByTrangThaiAndXoaLucIsNull(TrangThaiPhong.AVAILABLE)
   ```

5. Bat lai TypeScript strict mode:
   ```typescript
   // frontend/next.config.ts - XOA:
   // typescript: { ignoreBuildErrors: true },
   // eslint: { ignoreDuringBuilds: true },
   ```

6. Fix deposit invoice code - dung UUID:
   ```java
   String maHoaDon = "COC-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
   ```

---

### NICE TO HAVE (Tinh nang moi)

1. VietQR Auto-reconciliation:
   Da co BankTransactionController + BankTransactionService + VNPayService.
   Can: webhook tu ngan hang + auto-match theo maHoaDon trong noi dung chuyen khoan.

2. Zalo OA Integration:
   Tich hop Zalo OA API de gui tin nhan nhac no.
   Webhook Zalo -> backend /api/webhook/zalo

3. IoT Dong ho dien tu:
   Thay vi OCR anh, tich hop API thiet bi IoT doc chi so dien tu dong cuoi thang.

4. So quy Thu/Chi (Cashflow):
   Entity: SoQuy { loai: THU/CHI, soTien, ngay, moTa, loaiChiPhi }
   Bao cao: Loi nhuan = Tong thu - Tong chi

---

## 8. DANH GIA AI FEATURES

### AI Vision doc Cong to

| Tieu chi | Danh gia |
|---|---|
| Co kha thi khong? | Kha thi nhung do chinh xac thap o VN |
| Chi phi van hanh | Cao (Google Vision API ~$1.5/1000 anh) |
| Co can khong? | KHONG cho giai doan hien tai |
| Giai phap tot hon | Nhap tay co validation + upload anh chung minh |

KHUYEN NGHI: KHONG implement OCR. Thay vao do:
1. Cho phep upload anhDongHo khi ghi chi so (da co field trong ChiSoDienNuoc)
2. Validate: chi so moi >= chi so cu, khong tang dot bien >= 300%
3. Module MeterAnomalyService da co san - DUNG CAI NAY THAY THE AI

### AI Chatbot 24/7

KHUYEN NGHI: Thay bang FAQ accordion tinh trong trang khach thue.
Khi khach thue bao su co -> tao SuCo record -> thong bao cho chu tro.
Don gian hon, hieu qua hon, khong ton chi phi.

### Canh bao bat thuong dien/nuoc (MeterAnomalyService)

```java
// MeterAnomalyService.java - DA IMPLEMENT!
// Phat hien tieu thu tang >= 300% so voi thang truoc
// Tao MeterAnomalyAlert, gui thong bao
```

Day la AI feature THUC SU HUU ICH va da co code.
Can ket noi voi scheduler de chay tu dong khi lap hoa don.

### Ket luan AI

| Feature | Khuyen nghi |
|---|---|
| AI Vision OCR cong to | BO |
| AI Chatbot | THAY BANG FAQ TINH |
| Canh bao bat thuong dien/nuoc | GIU va ket noi vao scheduler |
| VietQR auto-reconcile | IMPLEMENT - da co nen tang |

---

## 9. CHAM DIEM TONG THE

### Thang diem 10 - Tieu chuan Production SaaS

| Hang muc | Diem | Nhan xet |
|---|---|---|
| Backend Architecture | 7.5/10 | Cau truc tot, Transaction dung, Soft delete dung. Tru: JWT chua hoan chinh, thieu Optimistic Lock |
| Business Logic | 7.0/10 | HoaDonService/HopDongService rat day du. Tru: thieu Check-out flow, PhuLuc khong anh huong HoaDon |
| Data Design | 8.0/10 | Schema phong phu, quan he dung, co CauHinhGia/PhuLuc/DatCoc. Tru: thieu SoQuy, daTra 2 nguon |
| UX / Frontend | 6.5/10 | Nhieu trang, kha day du. Tru: thieu wizard flow, auto-fill, man hinh check-out, canh bao dashboard |
| Production Readiness | 5.5/10 | Deploy duoc nhung: JWT khong an toan, race condition, khong co E2E test, TypeScript tat |
| TONG KET | 6.9/10 | "Do an xuat sac, startup can sua them 2-3 tuan de ra MVP an toan" |

### Roadmap de xuat (3 tuan)

```
Tuan 1 - MUST FIX:
  [Day 1-2] Fix JWT Authentication (real signed token)
  [Day 3]   Fix daTra chi qua recalculate
  [Day 4]   Fix NPE thanhToanCoc, Fix deposit invoice code
  [Day 5]   Them DB unique constraint hoa_don
  [Day 6-7] Implement Reset Cong to

Tuan 2 - SHOULD FIX:
  [Day 1-3] Implement Check-out/Thanh ly endpoint + UI
  [Day 4]   PhuLucHopDong anh huong gia tien phong
  [Day 5]   Fix next.config.ts proxy thieu
  [Day 6-7] Auto-fill soDuDauKy trong form HoaDon

Tuan 3 - IMPROVE:
  [Day 1-2] Dashboard warning widgets
  [Day 3]   DatCocPhong -> HopDong wizard
  [Day 4]   Filter phong public
  [Day 5-7] Testing + E2E review
```

---

## KET LUAN

EasyHouse co mot codebase backend dang ngac nhien tot cho quy mo do an.
Kien truc layered dung, domain model phong phu (65+ entities), business logic da duoc validate ky.
Cac van de con ton tai la SUA DUOC va khong doi hoi refactor lon.

Voi 2-3 tuan tap trung sua 9 bug MUST FIX va bo sung luong check-out,
he thong hoan toan co the deploy production cho khach hang that.

---
*Audit thuc hien boi Antigravity AI Agent - Dua tren doc code thuc te tu repo f:\qlyphongtro*
*Ngay: 2026-07-07*
