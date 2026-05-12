package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.ThanhToanRequest;
import com.example.quanlyphongtro.dto.ThanhToanResponse;
import com.example.quanlyphongtro.services.ThanhToanService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/thanh-toan")
@RequiredArgsConstructor
public class ThanhToanController {

    private final ThanhToanService thanhToanService;

    // ========== GET ALL ==========
    @GetMapping
    public ApiResponse<List<ThanhToanResponse>> getAll() {
        try {
            return ApiResponse.success(thanhToanService.getAll());
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== GET BY ID ==========
    @GetMapping("/{id}")
    public ApiResponse<ThanhToanResponse> getById(@PathVariable UUID id) {
        try {
            return ApiResponse.success(thanhToanService.getById(id));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== GET BY HOA DON ==========
    @GetMapping("/hoa-don/{hoaDonId}")
    public ApiResponse<List<ThanhToanResponse>> getByHoaDon(@PathVariable UUID hoaDonId) {
        try {
            return ApiResponse.success(thanhToanService.getByHoaDon(hoaDonId));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== CREATE ==========
    @PostMapping
    public ApiResponse<ThanhToanResponse> create(@RequestBody ThanhToanRequest request) {
        try {
            return ApiResponse.success(
                    thanhToanService.create(request),
                    "Tạo thanh toán thành công"
            );
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== UPDATE ==========
    @PutMapping("/{id}")
    public ApiResponse<ThanhToanResponse> update(
            @PathVariable UUID id,
            @RequestBody ThanhToanRequest request) {
        try {
            return ApiResponse.success(
                    thanhToanService.update(id, request),
                    "Cập nhật thanh toán thành công"
            );
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== DELETE ==========
    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable UUID id) {
        try {
            thanhToanService.delete(id);
            return ApiResponse.success(null, "Xóa thanh toán thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
