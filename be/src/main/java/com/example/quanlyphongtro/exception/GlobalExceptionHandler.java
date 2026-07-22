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

/**
 * FIX #2: Global Exception Handler
 * Thay thế các try-catch và badRequest() helper cục bộ trong từng controller.
 * Đảm bảo HTTP status code đúng ngữ nghĩa:
 *   - 400 Bad Request  → lỗi nghiệp vụ / validation
 *   - 403 Forbidden    → không có quyền
 *   - 404 Not Found    → không tìm thấy tài nguyên
 *   - 409 Conflict     → duplicate key / constraint violation
 *   - 500 Internal     → lỗi không mong đợi
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    // ── Exception có kiểu (module chat) ─────────────────────────────────────
    // Handler bên dưới đoán HTTP status bằng cách dò chuỗi trong message — cách đó
    // hỏng ngay khi ai đó sửa câu chữ. Module chat dùng exception có kiểu để status
    // là hợp đồng rõ ràng, không phụ thuộc vào cách viết message.
    // Spring luôn ưu tiên handler khớp cụ thể hơn, nên hành vi cũ giữ nguyên.

    @ExceptionHandler(ChatKhongTimThayException.class)
    public ResponseEntity<ApiResponse<Void>> handleChatNotFound(ChatKhongTimThayException ex) {
        log.warn("[404][chat] {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error(ex.getMessage()));
    }

    @ExceptionHandler(ChatKhongCoQuyenException.class)
    public ResponseEntity<ApiResponse<Void>> handleChatForbidden(ChatKhongCoQuyenException ex) {
        log.warn("[403][chat] {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ApiResponse.error(ex.getMessage()));
    }

    @ExceptionHandler(ChatYeuCauKhongHopLeException.class)
    public ResponseEntity<ApiResponse<Void>> handleChatBadRequest(ChatYeuCauKhongHopLeException ex) {
        log.warn("[400][chat] {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ApiResponse.error(ex.getMessage()));
    }

    // ── 404 / 403 / 400 — RuntimeException từ Services ──────────────────────

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<ApiResponse<Void>> handleRuntime(RuntimeException ex) {
        String msg = ex.getMessage();
        if (msg == null || msg.isBlank()) msg = "Có lỗi xảy ra, vui lòng thử lại";

        // 404 — không tìm thấy
        if (containsAny(msg, "không tìm thấy", "khong tim thay", "not found")) {
            log.warn("[404] {}", msg);
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(msg));
        }

        // 403 — không có quyền
        if (containsAny(msg, "không có quyền", "khong co quyen", "quyen xem", "quyen sua",
                "quyen lap", "permission denied", "forbidden", "access denied")) {
            log.warn("[403] {}", msg);
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(ApiResponse.error(msg));
        }

        // 400 — lỗi nghiệp vụ thông thường
        log.warn("[400] {}", msg);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error(msg));
    }

    // ── 409 Conflict — vi phạm unique constraint DB ─────────────────────────

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ApiResponse<Void>> handleDuplicate(DataIntegrityViolationException ex) {
        log.error("[409] DataIntegrityViolation: {}", ex.getMostSpecificCause().getMessage());

        // Gợi ý message cụ thể dựa vào tên constraint
        String cause = ex.getMostSpecificCause().getMessage() != null
                ? ex.getMostSpecificCause().getMessage().toLowerCase()
                : "";

        String msg;
        if (cause.contains("uk_hoadon_hopdong_ky")) {
            msg = "Hợp đồng này đã có hóa đơn trong kỳ tháng/năm đã chọn.";
        } else if (cause.contains("ma_hop_dong")) {
            msg = "Mã hợp đồng đã tồn tại. Vui lòng dùng mã khác.";
        } else if (cause.contains("ma_hoa_don")) {
            msg = "Mã hóa đơn đã tồn tại. Vui lòng dùng mã khác.";
        } else if (cause.contains("email")) {
            msg = "Email này đã được sử dụng. Vui lòng dùng email khác.";
        } else {
            msg = "Dữ liệu bị trùng lặp. Vui lòng kiểm tra lại thông tin đã nhập.";
        }

        return ResponseEntity.status(HttpStatus.CONFLICT)
                .body(ApiResponse.error(msg));
    }

    // ── 400 Validation — @Valid trên DTO ─────────────────────────────────────

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Void>> handleValidation(MethodArgumentNotValidException ex) {
        String msg = ex.getBindingResult().getFieldErrors().stream()
                .map(e -> e.getField() + ": " + e.getDefaultMessage())
                .collect(Collectors.joining("; "));
        log.warn("[400 Validation] {}", msg);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error("Dữ liệu không hợp lệ: " + msg));
    }

    // ── 500 — lỗi không mong đợi ─────────────────────────────────────────────

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleGeneric(Exception ex) {
        log.error("[500] Unexpected error: {}", ex.getMessage(), ex);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResponse.error("Lỗi hệ thống. Vui lòng thử lại sau hoặc liên hệ quản trị viên."));
    }

    // ── Helper ────────────────────────────────────────────────────────────────

    private boolean containsAny(String text, String... keywords) {
        if (text == null) return false;
        String lower = text.toLowerCase();
        for (String kw : keywords) {
            if (lower.contains(kw.toLowerCase())) return true;
        }
        return false;
    }
}
