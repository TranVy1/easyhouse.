# EasyHouse — Kế Hoạch Fix 5 Lỗi Critical Trước Production

**Ngày lập:** 2026-06-14  
**Ngày hoàn thành:** 2026-06-14  
**Người thực hiện:** Antigravity (Tech Lead Review)  
**Trạng thái:** ✅ **TẤT CẢ 5 FIX ĐÃ HOÀN THÀNH — BUILD SUCCESS**

---

## Tổng quan 5 lỗi cần fix

| # | Lỗi | File chính | Trạng thái |
|---|---|---|---|
| 1 | Thiếu DB unique constraint trên `hoa_don` | `sql/migrations/20260614_hoadon_unique_ky.sql` | ✅ Done — cần chạy migration |
| 2 | Thiếu `@ControllerAdvice` — mọi lỗi đều trả HTTP 400 | `GlobalExceptionHandler.java` + 3 controllers | ✅ Done |
| 3 | CORS hardcode `localhost` — sẽ block production domain | `SecurityConfig.java` + `application.properties` | ✅ Done |
| 4 | JWT secret có fallback mặc định trong code | `JwtService.java` + `application-secrets.properties` | ✅ Done |
| 5 | N+1 query trong `ThanhToanService.getByHoaDon()` | `ThanhToanService.java` | ✅ Done |

---

## FIX #1: DB Unique Constraint — Chống Duplicate Hóa Đơn

### Vấn đề chi tiết

- `HoaDonService.ensureInvoicePeriodAvailable()` kiểm tra trùng kỳ hóa đơn ở **tầng Java** (application layer).
- Nếu 2 request đến cùng lúc (concurrent), cả 2 đều vượt qua check → tạo 2 hóa đơn cho cùng 1 hợp đồng + cùng tháng.
- Database không có gì ngăn chặn.

### Vị trí cần thay đổi

- **File:** `sql/migrations/` — tạo file migration mới  
- **Không cần** sửa Java code (constraint DB là backstop đủ)

### Các bước thực hiện

**Bước 1:** Tạo file migration mới

```
d:\DATN_TMDT\qlyphongtro\sql\migrations\20260614_hoadon_unique_ky.sql
```

**Nội dung file:**
```sql
-- Migration: Đảm bảo mỗi hợp đồng chỉ có 1 hóa đơn cho mỗi kỳ tháng/năm
-- Ngày: 2026-06-14
-- Mục đích: Chặn duplicate invoice ở tầng database (backstop sau application check)

-- Kiểm tra và xóa dữ liệu duplicate nếu có (chạy an toàn)
-- Giữ lại bản ghi cũ nhất (tao_luc nhỏ nhất) cho mỗi nhóm trùng
DELETE FROM hoa_don h1
USING hoa_don h2
WHERE h1.hop_dong_id = h2.hop_dong_id
  AND h1.ky_thang    = h2.ky_thang
  AND h1.ky_nam      = h2.ky_nam
  AND h1.xoa_luc     IS NULL
  AND h2.xoa_luc     IS NULL
  AND h1.tao_luc     > h2.tao_luc;  -- Xóa bản mới hơn, giữ bản cũ hơn

-- Tạo unique constraint (partial index — loại trừ hóa đơn đã xóa mềm)
-- Cú pháp PostgreSQL: partial unique index = unique constraint linh hoạt hơn
CREATE UNIQUE INDEX IF NOT EXISTS uk_hoadon_hopdong_ky
    ON hoa_don (hop_dong_id, ky_thang, ky_nam)
    WHERE xoa_luc IS NULL;

-- Verify (uncomment để kiểm tra thủ công)
-- SELECT hop_dong_id, ky_thang, ky_nam, COUNT(*) 
-- FROM hoa_don WHERE xoa_luc IS NULL 
-- GROUP BY hop_dong_id, ky_thang, ky_nam 
-- HAVING COUNT(*) > 1;
```

**Bước 2:** Chạy migration lên DB (local Docker trước, production sau)

```powershell
# Kết nối vào PostgreSQL local Docker
docker exec -it <postgres_container_name> psql -U postgres -d easyhouse

# Hoặc dùng psql trực tiếp nếu có local PostgreSQL
psql -h localhost -p 54325 -U easyhouse -d easyhouse -f sql/migrations/20260614_hoadon_unique_ky.sql
```

**Bước 3:** Xử lý `DataIntegrityViolationException` trong GlobalExceptionHandler (đã được cover ở Fix #2)

### Kiểm tra sau fix

```sql
-- Test: Thử insert 2 hóa đơn cùng kỳ cho cùng hợp đồng → phải báo lỗi
INSERT INTO hoa_don (hop_dong_id, ky_thang, ky_nam, ...) VALUES ('uuid-1', 6, 2026, ...);
INSERT INTO hoa_don (hop_dong_id, ky_thang, ky_nam, ...) VALUES ('uuid-1', 6, 2026, ...);
-- Lệnh thứ 2 phải fail với: ERROR: duplicate key value violates unique constraint
```

---

## FIX #2: Global Exception Handler — Chuẩn hóa HTTP Status Codes

### Vấn đề chi tiết

- **Mọi lỗi** (404, 403, 409, 500) đều trả về **HTTP 400** qua helper `badRequest()` cục bộ.
- `ThanhToanController` còn trả thẳng `ApiResponse` (không phải `ResponseEntity`) — Spring **không thể set HTTP status** đúng.
- Frontend không phân biệt được `"không tìm thấy"` vs `"không có quyền"` vs `"lỗi server"`.
- `@Valid` được dùng trên DTO nhưng `MethodArgumentNotValidException` không được handle → unformatted 500.

### Vị trí cần thay đổi

1. **Tạo mới:** `be/src/main/java/com/example/quanlyphongtro/exception/GlobalExceptionHandler.java`
2. **Sửa:** `be/src/main/java/com/example/quanlyphongtro/controller/ThanhToanController.java` (đổi return type)
3. **Thêm `@Valid`:** `HopDongController.java`, `HoaDonController.java`, `ThanhToanController.java`

### Bước 1: Tạo GlobalExceptionHandler

**File:** `be/src/main/java/com/example/quanlyphongtro/exception/GlobalExceptionHandler.java`

```java
package com.example.quanlyphongtro.exception;

import com.example.quanlyphongtro.dto.ApiResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.stream.Collectors;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    // ====== 404 Not Found ======
    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<ApiResponse<Void>> handleRuntime(RuntimeException ex) {
        String msg = ex.getMessage();
        if (msg == null) msg = "Có lỗi xảy ra";

        // 404 — các từ khóa "không tìm thấy"
        if (containsAny(msg, "không tìm thấy", "khong tim thay", "not found")) {
            log.warn("[404] {}", msg);
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(msg));
        }

        // 403 — các từ khóa quyền truy cập
        if (containsAny(msg, "quyền", "quyen", "không có quyền", "permission denied", "forbidden")) {
            log.warn("[403] {}", msg);
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(ApiResponse.error(msg));
        }

        // 400 — lỗi nghiệp vụ thông thường
        log.warn("[400] {}", msg);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error(msg));
    }

    // ====== 409 Conflict — duplicate key, unique constraint ======
    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ApiResponse<Void>> handleDuplicate(DataIntegrityViolationException ex) {
        log.error("[409] DataIntegrityViolation: {}", ex.getMessage());
        String msg = "Dữ liệu bị trùng lặp. Vui lòng kiểm tra lại thông tin đã nhập.";
        
        // Gợi ý message cụ thể hơn dựa vào constraint name
        String cause = ex.getMessage() != null ? ex.getMessage().toLowerCase() : "";
        if (cause.contains("uk_hoadon_hopdong_ky")) {
            msg = "Hợp đồng này đã có hóa đơn trong kỳ tháng/năm đã chọn.";
        } else if (cause.contains("ma_hop_dong") || cause.contains("mahoadon")) {
            msg = "Mã hợp đồng/hóa đơn đã tồn tại. Vui lòng dùng mã khác.";
        }
        
        return ResponseEntity.status(HttpStatus.CONFLICT)
                .body(ApiResponse.error(msg));
    }

    // ====== 400 Validation — @Valid trên DTO ======
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Void>> handleValidation(MethodArgumentNotValidException ex) {
        String msg = ex.getBindingResult().getFieldErrors().stream()
                .map(e -> e.getField() + ": " + e.getDefaultMessage())
                .collect(Collectors.joining("; "));
        log.warn("[400 Validation] {}", msg);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error("Dữ liệu không hợp lệ: " + msg));
    }

    // ====== 500 — các lỗi không mong đợi ======
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleGeneric(Exception ex) {
        log.error("[500] Unexpected error: {}", ex.getMessage(), ex);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResponse.error("Lỗi hệ thống. Vui lòng thử lại sau."));
    }

    private boolean containsAny(String text, String... keywords) {
        if (text == null) return false;
        String lower = text.toLowerCase();
        for (String kw : keywords) {
            if (lower.contains(kw.toLowerCase())) return true;
        }
        return false;
    }
}
```

### Bước 2: Sửa ThanhToanController — đổi return type sang ResponseEntity

**File:** `ThanhToanController.java`

Các method hiện tại trả `ApiResponse<T>` trực tiếp — cần đổi thành `ResponseEntity<ApiResponse<T>>`.  
Sau khi có `GlobalExceptionHandler`, các `try-catch` cục bộ không còn cần thiết nữa.

```java
// TRƯỚC (sai — Spring không set HTTP status được):
@GetMapping
public ApiResponse<PaginatedResponse<ThanhToanResponse>> getAll(...) {
    try {
        return ApiResponse.success(thanhToanService.getAll(...));
    } catch (Exception e) {
        return ApiResponse.error(e.getMessage()); // luôn là 200!
    }
}

// SAU (đúng — GlobalExceptionHandler xử lý exception):
@GetMapping
public ResponseEntity<ApiResponse<PaginatedResponse<ThanhToanResponse>>> getAll(...) {
    return ResponseEntity.ok(ApiResponse.success(thanhToanService.getAll(...)));
    // Exception sẽ được GlobalExceptionHandler bắt → trả đúng status
}
```

Áp dụng tương tự cho tất cả method trong `ThanhToanController`.

### Bước 3: Thêm @Valid vào 3 controller còn thiếu

```java
// HopDongController.java
@PostMapping
public ResponseEntity<ApiResponse<HopDongResponse>> create(@Valid @RequestBody HopDongRequest request) { ... }

@PutMapping("/{id}")
public ResponseEntity<ApiResponse<HopDongResponse>> update(@PathVariable UUID id, @Valid @RequestBody HopDongRequest request) { ... }

// HoaDonController.java — tương tự
// ThanhToanController.java — tương tự
```

### Bước 4: Xóa các `badRequest()` helper cục bộ trong controller

Sau khi `GlobalExceptionHandler` được tạo, các method `private <T> ResponseEntity<ApiResponse<T>> badRequest(String message)` trong từng controller trở nên dư thừa. Xóa chúng và xóa toàn bộ khối `try-catch` trong controller (để exception tự bọt lên).

> **Lưu ý quan trọng:** `LichHenController` hiện không dùng try-catch — đây là pattern đúng. Áp dụng pattern này cho toàn bộ.

### Kiểm tra sau fix

```bash
# Test 404
curl -i http://localhost:8080/api/hop-dong/00000000-0000-0000-0000-000000000000
# → phải trả HTTP 404, body: { success: false, message: "Không tìm thấy hợp đồng" }

# Test 400 validation (nếu có @Valid + @NotNull trên DTO)
curl -i -X POST http://localhost:8080/api/hop-dong -H "Content-Type: application/json" -d '{}'
# → phải trả HTTP 400, body có message validation

# Test 409 duplicate invoice
# Tạo 2 hóa đơn cùng kỳ → phải trả HTTP 409
```

---

## FIX #3: CORS — Externalize Config cho Production Domain

### Vấn đề chi tiết

```java
// SecurityConfig.java — hardcode localhost
config.setAllowedOrigins(List.of(
    "http://localhost:3000",
    "http://localhost:8080"
));
```

Khi deploy lên domain thật (ví dụ: `https://easyhouse.vn`), **toàn bộ browser request sẽ bị block** bởi Same-Origin Policy vì backend không cho phép domain này.

### Vị trí cần thay đổi

1. `be/src/main/resources/application.properties`
2. `be/src/main/java/com/example/quanlyphongtro/config/SecurityConfig.java`

### Bước 1: Thêm config vào application.properties

```properties
# ===================================================================
# 9. CORS CONFIGURATION
# ===================================================================
# Danh sách origin được phép, phân cách bằng dấu phẩy
# Dev: http://localhost:3000
# Production: thay bằng domain thật của frontend
cors.allowed-origins=http://localhost:3000,http://localhost:8080
```

### Bước 2: Đọc config từ properties vào SecurityConfig.java

```java
// SecurityConfig.java
@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    // Thêm dòng này:
    @Value("${cors.allowed-origins:http://localhost:3000}")
    private List<String> allowedOrigins;

    // ... (phần securityFilterChain giữ nguyên)

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        // Đổi từ hardcode sang đọc từ config:
        config.setAllowedOrigins(allowedOrigins);
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));
        config.setAllowedHeaders(List.of("*"));
        config.setAllowCredentials(true);
        config.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        return source;
    }
}
```

### Bước 3: Khi deploy production, set biến môi trường hoặc override trong secrets

```properties
# application-secrets.properties (production)
cors.allowed-origins=https://easyhouse.vn,https://www.easyhouse.vn
app.frontend.base-url=https://easyhouse.vn
vnpay.return-url=https://api.easyhouse.vn/api/payment/vnpay-return
```

### Kiểm tra sau fix

```bash
# Verify CORS header từ production domain
curl -i -X OPTIONS https://api.easyhouse.vn/api/hop-dong \
  -H "Origin: https://easyhouse.vn" \
  -H "Access-Control-Request-Method: GET"
# → phải có: Access-Control-Allow-Origin: https://easyhouse.vn
```

---

## FIX #4: JWT Secret — Fail-Fast & Tách Khỏi Source Code

### Vấn đề chi tiết

```properties
# application.properties line 105 — secret hardcode trong file commit lên Git!
jwt.secret=EasyHouse-Secret-Key-Must-Be-At-Least-256-Bits-Long!!
```

```java
// JwtService.java line 26 — có fallback default trong code
@Value("${jwt.secret:EasyHouse-Secret-Key-Must-Be-At-Least-256-Bits-Long!!}") String secret
```

**Rủi ro:** Nếu deploy production mà quên set secret mới → toàn bộ token đều dùng key yếu, đã lộ công khai trên GitHub.

### Vị trí cần thay đổi

1. `be/src/main/resources/application.properties`
2. `be/src/main/java/com/example/quanlyphongtro/services/JwtService.java`

### Bước 1: Xóa fallback trong JwtService.java

```java
// TRƯỚC (nguy hiểm):
@Value("${jwt.secret:EasyHouse-Secret-Key-Must-Be-At-Least-256-Bits-Long!!}") String secret

// SAU (fail-fast — app sẽ không start nếu không có config):
@Value("${jwt.secret}") String secret
```

### Bước 2: Di chuyển secret khỏi application.properties

```properties
# application.properties — XÓA hoặc comment dòng này:
# jwt.secret=EasyHouse-Secret-Key-Must-Be-At-Least-256-Bits-Long!!

# Thay bằng comment hướng dẫn:
# jwt.secret phải được set trong application-secrets.properties (file này trong .gitignore)
# Dùng lệnh sau để sinh secret an toàn (>= 32 chars ngẫu nhiên):
# openssl rand -base64 48
```

### Bước 3: Đảm bảo application-secrets.properties có secret

Kiểm tra file `be/src/main/resources/application-secrets.properties`:

```properties
# application-secrets.properties (KHÔNG commit lên Git)
jwt.secret=<THAY_BẰNG_SECRET_MẠNH_DO_OPENSSL_SINH>
# Ví dụ sinh secret: openssl rand -base64 48
```

### Bước 4: Xác nhận .gitignore

```gitignore
# be/src/main/resources/.gitignore hoặc root .gitignore
application-secrets.properties
```

### Bước 5 (Optional nâng cao): Validate độ dài secret lúc startup

```java
// JwtService.java — thêm validation
public JwtService(
        @Value("${jwt.secret}") String secret,
        ...) {
    if (secret == null || secret.length() < 32) {
        throw new IllegalStateException(
            "jwt.secret phải có ít nhất 32 ký tự. " +
            "Dùng: openssl rand -base64 48 để sinh secret an toàn."
        );
    }
    this.key = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
    ...
}
```

### Kiểm tra sau fix

```bash
# Test 1: Start app khi KHÔNG có jwt.secret → phải fail với message rõ ràng
mvn spring-boot:run  # Nếu không có application-secrets.properties → lỗi startup

# Test 2: Start app với secret đúng → phải khởi động bình thường
# Thêm jwt.secret vào application-secrets.properties rồi thử lại
```

---

## FIX #5: N+1 Query — ThanhToanService.getByHoaDon()

### Vấn đề chi tiết

```java
// ThanhToanService.java lines 108–110 — HIỆN TẠI (BUG):
return thanhToanRepository.findByHoaDonIdOrderByNgayThanhToanDesc(hoaDonId).stream()
    .map(tt -> toResponse(tt, chiTietHoaDonRepository.findByHoaDonId(hoaDonId)))
    //                           ↑ gọi DB 1 lần cho mỗi phần tử trong stream!
    .toList();
```

Nếu hóa đơn có 10 thanh toán → thực hiện **11 queries** (1 lấy danh sách + 10 lần lặp lại cùng query `findByHoaDonId`).

### Vị trí cần thay đổi

- **File:** `be/src/main/java/com/example/quanlyphongtro/services/ThanhToanService.java`
- **Method:** `getByHoaDon(UUID hoaDonId)`

### Thay đổi cụ thể

```java
// ThanhToanService.java — SỬA method getByHoaDon:

@Transactional(readOnly = true)
public List<ThanhToanResponse> getByHoaDon(UUID hoaDonId) {
    HoaDon hoaDon = hoaDonRepository.findById(hoaDonId)
            .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn"));
    assertCanReadHoaDon(hoaDon, permissionService.requireCurrentUserId());
    
    // FIX: Lấy chi tiết hóa đơn 1 LẦN duy nhất, dùng chung cho tất cả thanh toán
    List<ChiTietHoaDon> chiTiet = chiTietHoaDonRepository.findByHoaDonId(hoaDonId);
    
    return thanhToanRepository.findByHoaDonIdOrderByNgayThanhToanDesc(hoaDonId).stream()
            .map(tt -> toResponse(tt, chiTiet))  // Truyền list đã load sẵn
            .toList();
    
    // KẾT QUẢ: 2 queries thay vì N+1 queries
}
```

### Kiểm tra sau fix

Bật SQL logging tạm thời để đếm số query:

```properties
# application.properties — bật tạm để test
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
```

```bash
# Gọi endpoint
curl http://localhost:8080/api/thanh-toan/hoa-don/{hoaDonId} -H "Authorization: Bearer <token>"

# Kiểm tra console log:
# TRƯỚC FIX: sẽ thấy SELECT lặp đi lặp lại nhiều lần với cùng WHERE hoa_don_id = ?
# SAU FIX: chỉ thấy đúng 2 SELECT (1 lấy thanhToan, 1 lấy chiTietHoaDon)
```

---

## Thứ tự thực hiện đề xuất

```
[Ưu tiên cao - làm trước]
Fix #5 → Fix #4 → Fix #3  (mỗi cái ~15–30 phút, ít rủi ro)

[Làm sau]
Fix #1 (chạy migration DB - cần backup trước)
Fix #2 (nhiều file nhất, cần test kỹ)
```

**Lý do thứ tự:**
- Fix #5, #4, #3 chỉ sửa 1–2 file, không ảnh hưởng logic nghiệp vụ → nhanh, an toàn.
- Fix #1 cần chạy migration lên DB → phải backup trước, test trên local trước.
- Fix #2 ảnh hưởng toàn bộ error handling của app → cần test nhiều case nhất.

---

## Checklist Kiểm Tra Sau Khi Hoàn Thành

### Backend Build

```powershell
cd be
mvn clean compile    # Phải pass không có lỗi
mvn test             # Phải pass (context load test)
```

### Test Thủ Công Các Endpoint

| Test Case | Expected | Fix |
|---|---|---|
| GET `/api/hop-dong/{uuid-không-tồn-tại}` | HTTP **404** | #2 |
| GET `/api/hop-dong/{id}` không có token | HTTP **401/403** | #2 |
| POST `/api/hoa-don` với body thiếu `hopDongId` | HTTP **400** | #2 |
| Tạo 2 hóa đơn cùng kỳ cho 1 hợp đồng | HTTP **409** | #1 + #2 |
| Start app khi không có `jwt.secret` | App không start | #4 |
| CORS từ domain thật (sau deploy) | 200 với CORS header | #3 |
| GET `/api/thanh-toan/hoa-don/{id}` | Đúng 2 SQL queries | #5 |

### Verify CORS (sau khi deploy lên staging)

```bash
curl -I -X OPTIONS https://api.easyhouse.vn/api/phong \
  -H "Origin: https://easyhouse.vn" \
  -H "Access-Control-Request-Method: GET"
# → Access-Control-Allow-Origin: https://easyhouse.vn ✓
```

---

## Files Cần Tạo / Sửa — Summary

| Action | File |
|---|---|
| **TẠO MỚI** | `sql/migrations/20260614_hoadon_unique_ky.sql` |
| **TẠO MỚI** | `be/src/main/java/com/example/quanlyphongtro/exception/GlobalExceptionHandler.java` |
| **SỬA** | `be/src/main/java/com/example/quanlyphongtro/controller/ThanhToanController.java` |
| **SỬA** | `be/src/main/java/com/example/quanlyphongtro/controller/HopDongController.java` |
| **SỬA** | `be/src/main/java/com/example/quanlyphongtro/controller/HoaDonController.java` |
| **SỬA** | `be/src/main/java/com/example/quanlyphongtro/config/SecurityConfig.java` |
| **SỬA** | `be/src/main/java/com/example/quanlyphongtro/services/JwtService.java` |
| **SỬA** | `be/src/main/java/com/example/quanlyphongtro/services/ThanhToanService.java` |
| **SỬA** | `be/src/main/resources/application.properties` |
| **KIỂM TRA** | `be/src/main/resources/application-secrets.properties` |
| **KIỂM TRA** | `.gitignore` (phải có `application-secrets.properties`) |
