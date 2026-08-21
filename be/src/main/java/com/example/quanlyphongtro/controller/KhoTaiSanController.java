package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.*;
import com.example.quanlyphongtro.services.KhoTaiSanService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/kho-tai-san")
@RequiredArgsConstructor
public class KhoTaiSanController {

    private final KhoTaiSanService khoTaiSanService;

    @GetMapping("/nha-tro/{nhaTroId}")
    public ApiResponse<List<KhoTaiSanResponse>> getAllByNhaTro(@PathVariable UUID nhaTroId) {
        return ApiResponse.success(khoTaiSanService.getAllByNhaTro(nhaTroId), "Láº¥y danh sÃ¡ch kho tÃ i sáº£n thÃ nh cÃ´ng");
    }

    @PostMapping
    public ApiResponse<KhoTaiSanResponse> createKhoTaiSan(@Valid @RequestBody KhoTaiSanRequest request) {
        return ApiResponse.success(khoTaiSanService.createKhoTaiSan(request), "ThÃªm tÃ i sáº£n vÃ o kho thÃ nh cÃ´ng");
    }

    @PutMapping("/{id}")
    public ApiResponse<KhoTaiSanResponse> updateKhoTaiSan(@PathVariable UUID id, @Valid @RequestBody KhoTaiSanRequest request) {
        return ApiResponse.success(khoTaiSanService.updateKhoTaiSan(id, request), "Cáº­p nháº­t tÃ i sáº£n kho thÃ nh cÃ´ng");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deleteKhoTaiSan(@PathVariable UUID id) {
        khoTaiSanService.deleteKhoTaiSan(id);
        return ApiResponse.success(null, "XÃ³a tÃ i sáº£n kho thÃ nh cÃ´ng");
    }

    @PostMapping("/{id}/cap-phat")
    public ApiResponse<Void> capPhatTaiSan(@PathVariable UUID id, @Valid @RequestBody CapPhatTaiSanRequest request) {
        khoTaiSanService.capPhatTaiSan(id, request);
        return ApiResponse.success(null, "Cáº¥p phÃ¡t tÃ i sáº£n thÃ nh cÃ´ng");
    }

    @PostMapping("/{id}/cap-phat-tat-ca")
    public ApiResponse<CapPhatTatCaResponse> capPhatTatCaTaiSan(@PathVariable UUID id, @Valid @RequestBody CapPhatTatCaRequest request) {
        return ApiResponse.success(khoTaiSanService.capPhatTatCaTaiSan(id, request), "C?p phát tài s?n b? sung thành công");
    }

    @PostMapping("/{id}/thu-hoi")
    public ApiResponse<Void> thuHoiTaiSan(@PathVariable UUID id, @Valid @RequestBody ThuHoiTaiSanRequest request) {
        khoTaiSanService.thuHoiTaiSan(id, request);
        return ApiResponse.success(null, "Thu há»i tÃ i sáº£n thÃ nh cÃ´ng");
    }

    @GetMapping("/{id}/lich-su")
    public ApiResponse<List<LichSuKhoTaiSanResponse>> getLichSuGiaoDich(@PathVariable UUID id) {
        return ApiResponse.success(khoTaiSanService.getLichSuGiaoDich(id), "Láº¥y lá»ch sá»­ giao dá»ch thÃ nh cÃ´ng");
    }
}

