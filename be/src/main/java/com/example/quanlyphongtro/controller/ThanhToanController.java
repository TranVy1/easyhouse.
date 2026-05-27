package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.ThanhToanRequest;
import com.example.quanlyphongtro.dto.ThanhToanResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.services.ThanhToanService;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/thanh-toan")
@RequiredArgsConstructor
public class ThanhToanController {

    private final ThanhToanService thanhToanService;

    @GetMapping
    public ApiResponse<PaginatedResponse<ThanhToanResponse>> getAll(
            @RequestParam(required = false) String hoaDonId,
            @RequestParam(required = false) String trangThai,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String phuongThuc,
            @RequestParam(required = false) String tuNgay,
            @RequestParam(required = false) String denNgay,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        try {
            return ApiResponse.success(thanhToanService.getAll(
                    hoaDonId, trangThai, search, phuongThuc, tuNgay, denNgay, page, limit));
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
            return ApiResponse.success(thanhToanService.create(request), "Tao thanh toan thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ApiResponse<ThanhToanResponse> update(@PathVariable UUID id, @RequestBody ThanhToanRequest request) {
        try {
            return ApiResponse.success(thanhToanService.update(id, request), "Cap nhat thanh toan thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable UUID id) {
        try {
            thanhToanService.delete(id);
            return ApiResponse.success(null, "Xoa thanh toan thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
