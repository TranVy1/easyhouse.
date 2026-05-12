package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.HopDongRequest;
import com.example.quanlyphongtro.dto.HopDongResponse;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.services.HopDongService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/hop-dong")
@RequiredArgsConstructor
public class HopDongController {

    private final HopDongService hopDongService;

    // ========== GET ALL ==========
    @GetMapping
    public ApiResponse<List<HopDongResponse>> getAll() {
        try {
            List<KhachThue> allTenants = hopDongService.getAllKhachThue();
            List<HopDongResponse> list = hopDongService.getAll().stream()
                    .map(hd -> HopDongResponse.fromEntity(hd, allTenants))
                    .collect(Collectors.toList());
            return ApiResponse.success(list);
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== GET BY ID ==========
    @GetMapping("/{id}")
    public ApiResponse<HopDongResponse> getById(@PathVariable UUID id) {
        try {
            List<KhachThue> allTenants = hopDongService.getAllKhachThue();
            return ApiResponse.success(HopDongResponse.fromEntity(hopDongService.getById(id), allTenants));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== CREATE ==========
    @PostMapping
    public ApiResponse<HopDongResponse> create(@RequestBody HopDongRequest request) {
        try {
            List<KhachThue> allTenants = hopDongService.getAllKhachThue();
            return ApiResponse.success(
                    HopDongResponse.fromEntity(hopDongService.create(request), allTenants),
                    "Tạo hợp đồng thành công"
            );
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== UPDATE ==========
    @PutMapping("/{id}")
    public ApiResponse<HopDongResponse> update(@PathVariable UUID id, @RequestBody HopDongRequest request) {
        try {
            List<KhachThue> allTenants = hopDongService.getAllKhachThue();
            return ApiResponse.success(
                    HopDongResponse.fromEntity(hopDongService.update(id, request), allTenants),
                    "Cập nhật hợp đồng thành công"
            );
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    // ========== DELETE ==========
    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable UUID id) {
        try {
            hopDongService.delete(id);
            return ApiResponse.success(null, "Xóa hợp đồng thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
