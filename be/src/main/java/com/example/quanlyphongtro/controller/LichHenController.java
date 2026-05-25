package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.LichHenRequest;
import com.example.quanlyphongtro.dto.LichHenResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.services.LichHenService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/lich-hen")
@RequiredArgsConstructor
public class LichHenController {

    private final LichHenService lichHenService;

    @GetMapping
    public ResponseEntity<ApiResponse<PaginatedResponse<LichHenResponse>>> getAll(
            @RequestParam(required = false) UUID nhaTroId,
            @RequestParam(required = false) UUID phongId,
            @RequestParam(required = false) String trangThai,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit,
            @RequestParam(defaultValue = "ngayHen,desc") String sort) {
        org.springframework.data.domain.Pageable pageable = com.example.quanlyphongtro.utils.PaginationUtils.createPageable(page, limit, sort);
        PaginatedResponse<LichHenResponse> data = lichHenService.getAll(nhaTroId, phongId, trangThai, pageable);
        return ResponseEntity.ok(ApiResponse.<PaginatedResponse<LichHenResponse>>builder()
                .success(true)
                .message("Lấy danh sách lịch hẹn thành công")
                .data(data)
                .build());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<LichHenResponse>> getById(@PathVariable UUID id) {
        LichHenResponse data = lichHenService.getById(id);
        return ResponseEntity.ok(ApiResponse.<LichHenResponse>builder()
                .success(true)
                .message("Lấy chi tiết lịch hẹn thành công")
                .data(data)
                .build());
    }

    @PostMapping
    public ResponseEntity<ApiResponse<LichHenResponse>> create(@RequestBody LichHenRequest req) {
        LichHenResponse data = lichHenService.create(req);
        return ResponseEntity.ok(ApiResponse.<LichHenResponse>builder()
                .success(true)
                .message("Tạo lịch hẹn thành công")
                .data(data)
                .build());
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<LichHenResponse>> update(@PathVariable UUID id, @RequestBody LichHenRequest req) {
        LichHenResponse data = lichHenService.update(id, req);
        return ResponseEntity.ok(ApiResponse.<LichHenResponse>builder()
                .success(true)
                .message("Cập nhật lịch hẹn thành công")
                .data(data)
                .build());
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<ApiResponse<LichHenResponse>> updateStatus(@PathVariable UUID id, @RequestBody java.util.Map<String, String> body) {
        LichHenResponse data = lichHenService.updateStatus(id, body.get("trangThai"));
        return ResponseEntity.ok(ApiResponse.<LichHenResponse>builder()
                .success(true)
                .message("Cập nhật trạng thái lịch hẹn thành công")
                .data(data)
                .build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable UUID id) {
        lichHenService.delete(id);
        return ResponseEntity.ok(ApiResponse.<Void>builder()
                .success(true)
                .message("Xóa lịch hẹn thành công")
                .build());
    }
}
