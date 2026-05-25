package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.NhaTroResponse;
import com.example.quanlyphongtro.dto.PhongResponse;
import com.example.quanlyphongtro.services.NhaTroService;
import com.example.quanlyphongtro.services.PhongService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/public")
@RequiredArgsConstructor
public class PublicApiController {

    private final NhaTroService nhaTroService;
    private final PhongService phongService;

    @GetMapping("/toa-nha")
    public ApiResponse<List<NhaTroResponse>> getAllNhaTro() {
        return ApiResponse.success(nhaTroService.getPublicAllNhaTro());
    }

    @GetMapping("/toa-nha/{id}")
    public ApiResponse<NhaTroResponse> getNhaTroById(@PathVariable UUID id) {
        try {
            return ApiResponse.success(nhaTroService.getPublicNhaTroById(id));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/phong")
    public ApiResponse<List<PhongResponse>> getAllPhong(
            @RequestParam(required = false) String toaNha,
            @RequestParam(required = false) String trangThai) {
        
        List<PhongResponse> phongs = phongService.getPublicAllPhong(toaNha, trangThai).stream()
                .map(this::sanitizeForPublic)
                .collect(Collectors.toList());
        return ApiResponse.success(phongs);
    }

    @GetMapping("/phong/{id}")
    public ApiResponse<PhongResponse> getPhongById(@PathVariable UUID id) {
        try {
            PhongResponse phong = phongService.getPublicPhongById(id);
            return ApiResponse.success(sanitizeForPublic(phong));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    private PhongResponse sanitizeForPublic(PhongResponse original) {
        original.setHopDongHienTai(null); // Hide contract/tenant details
        return original;
    }
}
