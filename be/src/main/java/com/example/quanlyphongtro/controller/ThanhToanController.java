package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.ThanhToanRequest;
import com.example.quanlyphongtro.dto.ThanhToanResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.services.ThanhToanService;
import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * FIX #2: Loại bỏ try-catch và badRequest() helper cục bộ.
 * FIX #2: Đổi return type sang ResponseEntity để GlobalExceptionHandler có thể set HTTP status.
 * FIX #2: Thêm @Valid vào create/update.
 * Exception được xử lý tập trung tại GlobalExceptionHandler.
 */
@RestController
@RequestMapping("/api/thanh-toan")
@RequiredArgsConstructor
public class ThanhToanController {

    private final ThanhToanService thanhToanService;

    @GetMapping
    public ResponseEntity<ApiResponse<PaginatedResponse<ThanhToanResponse>>> getAll(
            @RequestParam(required = false) String hoaDonId,
            @RequestParam(required = false) String trangThai,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String phuongThuc,
            @RequestParam(required = false) String tuNgay,
            @RequestParam(required = false) String denNgay,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        return ResponseEntity.ok(ApiResponse.success(thanhToanService.getAll(
                hoaDonId, trangThai, search, phuongThuc, tuNgay, denNgay, page, limit)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ThanhToanResponse>> getById(@PathVariable UUID id) {
        return ResponseEntity.ok(ApiResponse.success(thanhToanService.getById(id)));
    }

    @GetMapping("/hoa-don/{hoaDonId}")
    public ResponseEntity<ApiResponse<List<ThanhToanResponse>>> getByHoaDon(@PathVariable UUID hoaDonId) {
        return ResponseEntity.ok(ApiResponse.success(thanhToanService.getByHoaDon(hoaDonId)));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<ThanhToanResponse>> create(@Valid @RequestBody ThanhToanRequest request) {
        return ResponseEntity.ok(ApiResponse.success(thanhToanService.create(request), "Tạo thanh toán thành công"));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<ThanhToanResponse>> update(
            @PathVariable UUID id,
            @Valid @RequestBody ThanhToanRequest request) {
        return ResponseEntity.ok(ApiResponse.success(thanhToanService.update(id, request), "Cập nhật thanh toán thành công"));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable UUID id) {
        thanhToanService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Xóa thanh toán thành công"));
    }
}
