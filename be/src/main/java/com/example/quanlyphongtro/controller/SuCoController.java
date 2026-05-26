package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.SuCoRequest;
import com.example.quanlyphongtro.dto.SuCoResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.services.SuCoService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/su-co")
@RequiredArgsConstructor
public class SuCoController {

    private final SuCoService suCoService;

    @GetMapping
    public ApiResponse<PaginatedResponse<SuCoResponse>> getAll(
            @RequestParam(required = false) UUID nhaTroId,
            @RequestParam(required = false) UUID phongId,
            @RequestParam(required = false) String trangThai,
            @RequestParam(required = false) String loaiSuCo,
            @RequestParam(required = false) String uuTien,
            @RequestParam(required = false) String mucDoUuTien,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit,
            @RequestParam(defaultValue = "taoLuc,desc") String sort) {
        try {
            org.springframework.data.domain.Pageable pageable =
                    com.example.quanlyphongtro.utils.PaginationUtils.createPageable(page, limit, sort);
            String priority = uuTien != null ? uuTien : mucDoUuTien;
            return ApiResponse.success(suCoService.getAllSuCo(nhaTroId, phongId, trangThai, loaiSuCo, priority, pageable));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ApiResponse<SuCoResponse> getById(@PathVariable UUID id) {
        try {
            return ApiResponse.success(suCoService.getSuCoById(id));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping
    public ApiResponse<SuCoResponse> create(@Valid @RequestBody SuCoRequest request) {
        try {
            SuCoResponse response = suCoService.createSuCo(request);
            return ApiResponse.success(response, "Tạo sự cố thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ApiResponse<SuCoResponse> update(
            @PathVariable UUID id,
            @Valid @RequestBody SuCoRequest request) {
        try {
            SuCoResponse response = suCoService.updateSuCo(id, request);
            return ApiResponse.success(response, "Cập nhật sự cố thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable UUID id) {
        try {
            suCoService.deleteSuCo(id);
            return ApiResponse.success(null, "Xóa sự cố thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
