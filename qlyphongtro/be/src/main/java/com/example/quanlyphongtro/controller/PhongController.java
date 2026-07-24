package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.PhongRequest;
import com.example.quanlyphongtro.dto.PhongResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.services.PhongService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/phong")
@RequiredArgsConstructor
public class PhongController {

    private final PhongService phongService;

    @GetMapping
    public ApiResponse<PaginatedResponse<PhongResponse>> getAll(
            @RequestParam(required = false) String toaNha,
            @RequestParam(required = false) String trangThai,
            @RequestParam(required = false) String search,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit,
            @RequestParam(defaultValue = "false") boolean simple
    ) {
        return ApiResponse.success(phongService.getAllPhong(toaNha, trangThai, search, page, limit, simple));
    }

    /**
     * Lookup a room by name (supports fuzzy: "101" matches "Phòng 101").
     * Used by the bulk folder-image upload feature.
     */
    @GetMapping("/lookup-by-name")
    public ApiResponse<Map<String, Object>> lookupByName(
            @RequestParam("nhaTroId") UUID nhaTroId,
            @RequestParam("tenPhong") String tenPhong) {
        try {
            return ApiResponse.success(phongService.lookupPhongByName(nhaTroId, tenPhong));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/nha-tro/{nhaTroId}")
    public ApiResponse<List<PhongResponse>> getByNhaTro(@PathVariable UUID nhaTroId) {
        try {
            return ApiResponse.success(phongService.getPhongByNhaTro(nhaTroId));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ApiResponse<PhongResponse> getById(@PathVariable UUID id) {
        try {
            return ApiResponse.success(phongService.getPhongById(id));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping
    public ApiResponse<PhongResponse> create(@Valid @RequestBody PhongRequest request) {
        try {
            return ApiResponse.success(phongService.createPhong(request), "Thêm phòng thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ApiResponse<PhongResponse> update(@PathVariable UUID id, @RequestBody PhongRequest request) {
        try {
            return ApiResponse.success(phongService.updatePhong(id, request), "Cập nhật phòng thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable UUID id) {
        try {
            phongService.deletePhong(id);
            return ApiResponse.success(null, "Xóa phòng thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
