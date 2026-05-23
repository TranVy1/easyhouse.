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

    @GetMapping
    public ApiResponse<List<ThanhToanResponse>> getAll() {
        try {
            return ApiResponse.success(thanhToanService.getAll());
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ApiResponse<ThanhToanResponse> getById(@PathVariable UUID id) {
        try {
            return ApiResponse.success(thanhToanService.getById(id));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/hoa-don/{hoaDonId}")
    public ApiResponse<List<ThanhToanResponse>> getByHoaDon(@PathVariable UUID hoaDonId) {
        try {
            return ApiResponse.success(thanhToanService.getByHoaDon(hoaDonId));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping
    public ApiResponse<ThanhToanResponse> create(@RequestBody ThanhToanRequest request) {
        try {
            return ApiResponse.success(thanhToanService.create(request), "Tạo thanh toán thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

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
