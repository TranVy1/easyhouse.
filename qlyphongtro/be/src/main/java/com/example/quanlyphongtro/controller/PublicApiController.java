package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.PublicNhaTroSummaryResponse;
import com.example.quanlyphongtro.services.NhaTroService;
import com.example.quanlyphongtro.services.PhongService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import java.math.BigDecimal;

@RestController
@RequestMapping("/api/public")
@RequiredArgsConstructor
public class PublicApiController {

    private final NhaTroService nhaTroService;
    private final PhongService phongService;

    @GetMapping("/toa-nha")
    public ApiResponse<List<PublicNhaTroSummaryResponse>> getAllNhaTro() {
        return ApiResponse.success(nhaTroService.getPublicAllNhaTro());
    }

    @GetMapping("/toa-nha/{id}")
    public ApiResponse<PublicNhaTroSummaryResponse> getNhaTroById(@PathVariable UUID id) {
        try {
            return ApiResponse.success(nhaTroService.getPublicNhaTroById(id));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/phong")
    public ApiResponse<com.example.quanlyphongtro.dto.PaginatedResponse<com.example.quanlyphongtro.dto.PublicPhongSummaryResponse>> getAllPhong(
            @RequestParam(required = false) String toaNha,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) java.math.BigDecimal minGia,
            @RequestParam(required = false) java.math.BigDecimal maxGia,
            @RequestParam(required = false) java.math.BigDecimal minDienTich,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        
        return ApiResponse.success(phongService.getPublicAllPhong(toaNha, search, minGia, maxGia, minDienTich, page, limit));
    }

    @GetMapping("/phong/gan-nhat")
    public ApiResponse<com.example.quanlyphongtro.dto.PaginatedResponse<com.example.quanlyphongtro.dto.PublicPhongSummaryResponse>> getNearbyPhong(
            @RequestParam BigDecimal viDo,
            @RequestParam BigDecimal kinhDo,
            @RequestParam(defaultValue = "5") BigDecimal radiusKm,
            @RequestParam(required = false) String toaNha,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) BigDecimal minGia,
            @RequestParam(required = false) BigDecimal maxGia,
            @RequestParam(required = false) BigDecimal minDienTich,
            @RequestParam(defaultValue = "12") int limit) {
        return ApiResponse.success(phongService.getPublicNearbyPhong(
                viDo, kinhDo, radiusKm, toaNha, search, minGia, maxGia, minDienTich, limit));
    }

    @GetMapping("/phong/{id}")
    public ApiResponse<com.example.quanlyphongtro.dto.PublicPhongDetailResponse> getPhongById(@PathVariable UUID id) {
        try {
            return ApiResponse.success(phongService.getPublicPhongById(id));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
