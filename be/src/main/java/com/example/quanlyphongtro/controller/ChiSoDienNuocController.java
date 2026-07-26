package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.ChiSoDienNuocRequest;
import com.example.quanlyphongtro.dto.ChiSoDienNuocResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.services.ChiSoDienNuocService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/chi-so-dien-nuoc")
@RequiredArgsConstructor
public class ChiSoDienNuocController {

    private final ChiSoDienNuocService chiSoDienNuocService;

    @GetMapping
    public ApiResponse<PaginatedResponse<ChiSoDienNuocResponse>> getAll(
            @RequestParam(required = false) UUID nhaTroId,
            @RequestParam(required = false) UUID phongId,
            @RequestParam(required = false) Integer kyThang,
            @RequestParam(required = false) Integer kyNam,
            @RequestParam(required = false) String loai,
            @RequestParam(required = false) String trangThai,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit,
            @RequestParam(defaultValue = "kyNam,desc") String sort) {
        
        org.springframework.data.domain.Pageable pageable = com.example.quanlyphongtro.utils.PaginationUtils.createPageable(page, limit, sort);
        return ApiResponse.success(chiSoDienNuocService.getAll(nhaTroId, phongId, kyThang, kyNam, loai, trangThai, pageable));
    }

    @GetMapping("/{id}")
    public ApiResponse<ChiSoDienNuocResponse> getById(@PathVariable UUID id) {
        return ApiResponse.success(chiSoDienNuocService.getById(id));
    }

    @PostMapping
    public ApiResponse<ChiSoDienNuocResponse> create(@RequestBody ChiSoDienNuocRequest request) {
        return ApiResponse.success(chiSoDienNuocService.create(request));
    }

    @PutMapping("/{id}")
    public ApiResponse<ChiSoDienNuocResponse> update(
            @PathVariable UUID id, 
            @RequestBody ChiSoDienNuocRequest request) {
        return ApiResponse.success(chiSoDienNuocService.update(id, request));
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable UUID id) {
        chiSoDienNuocService.delete(id);
        return ApiResponse.success(null);
    }
}
