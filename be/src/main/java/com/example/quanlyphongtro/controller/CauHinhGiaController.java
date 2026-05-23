package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.CauHinhGiaRequest;
import com.example.quanlyphongtro.dto.CauHinhGiaResponse;
import com.example.quanlyphongtro.services.CauHinhGiaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/cau-hinh-gia")
@RequiredArgsConstructor
public class CauHinhGiaController {

    private final CauHinhGiaService cauHinhGiaService;

    @GetMapping
    public ApiResponse<List<CauHinhGiaResponse>> getAll(
            @RequestParam(required = false) UUID nhaTroId,
            @RequestParam(required = false) String loai,
            @RequestParam(required = false) Boolean dangApDung
    ) {
        return ApiResponse.success(cauHinhGiaService.getAll(nhaTroId, loai, dangApDung));
    }

    @GetMapping("/{id}")
    public ApiResponse<CauHinhGiaResponse> getById(@PathVariable UUID id) {
        return ApiResponse.success(cauHinhGiaService.getById(id));
    }

    @GetMapping("/ap-dung")
    public ApiResponse<CauHinhGiaResponse> getApplicable(
            @RequestParam UUID nhaTroId,
            @RequestParam String loai,
            @RequestParam(required = false) LocalDate ngayApDung
    ) {
        return ApiResponse.success(cauHinhGiaService.getApplicable(nhaTroId, loai, ngayApDung));
    }

    @PostMapping
    public ApiResponse<CauHinhGiaResponse> create(@Valid @RequestBody CauHinhGiaRequest request) {
        return ApiResponse.success(cauHinhGiaService.create(request), "Tao cau hinh gia thanh cong");
    }

    @PutMapping("/{id}")
    public ApiResponse<CauHinhGiaResponse> update(@PathVariable UUID id, @RequestBody CauHinhGiaRequest request) {
        return ApiResponse.success(cauHinhGiaService.update(id, request), "Cap nhat cau hinh gia thanh cong");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deactivate(@PathVariable UUID id) {
        cauHinhGiaService.deactivate(id);
        return ApiResponse.success(null, "Ngung ap dung cau hinh gia thanh cong");
    }
}
