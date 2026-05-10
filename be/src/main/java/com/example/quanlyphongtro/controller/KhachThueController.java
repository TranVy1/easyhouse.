package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.KhachThueRequest;
import com.example.quanlyphongtro.dto.KhachThueResponse;
import com.example.quanlyphongtro.services.KhachThueService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/khach-thue")
@RequiredArgsConstructor
public class KhachThueController {

    private final KhachThueService khachThueService;

    @GetMapping
    public ApiResponse<List<KhachThueResponse>> getAll(
            @RequestParam(required = false) String trangThai) {
        return ApiResponse.success(khachThueService.getAllKhachThue(trangThai));
    }

    @GetMapping("/{id}")
    public ApiResponse<KhachThueResponse> getById(@PathVariable UUID id) {
        try {
            return ApiResponse.success(khachThueService.getKhachThueById(id));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping
    public ApiResponse<KhachThueResponse> createKhachThue(@Valid @RequestBody KhachThueRequest request) {
        try {
            KhachThueResponse response = khachThueService.createKhachThue(request);
            return ApiResponse.success(response, "Thêm khách thuê thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ApiResponse<KhachThueResponse> updateKhachThue(
            @PathVariable UUID id,
            @Valid @RequestBody KhachThueRequest request) {
        try {
            KhachThueResponse response = khachThueService.updateKhachThue(id, request);
            return ApiResponse.success(response, "Cập nhật khách thuê thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deleteKhachThue(@PathVariable UUID id) {
        try {
            khachThueService.deleteKhachThue(id);
            return ApiResponse.success(null, "Xóa khách thuê thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}