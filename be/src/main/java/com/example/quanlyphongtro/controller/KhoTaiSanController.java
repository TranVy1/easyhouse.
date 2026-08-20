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
        return ApiResponse.success(khoTaiSanService.getAllByNhaTro(nhaTroId), "Lấy danh sách kho tài sản thành công");
    }

    @PostMapping
    public ApiResponse<KhoTaiSanResponse> createKhoTaiSan(@Valid @RequestBody KhoTaiSanRequest request) {
        return ApiResponse.success(khoTaiSanService.createKhoTaiSan(request), "Thêm tài sản vào kho thành công");
    }

    @PutMapping("/{id}")
    public ApiResponse<KhoTaiSanResponse> updateKhoTaiSan(@PathVariable UUID id, @Valid @RequestBody KhoTaiSanRequest request) {
        return ApiResponse.success(khoTaiSanService.updateKhoTaiSan(id, request), "Cập nhật tài sản kho thành công");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deleteKhoTaiSan(@PathVariable UUID id) {
        khoTaiSanService.deleteKhoTaiSan(id);
        return ApiResponse.success(null, "Xóa tài sản kho thành công");
    }

    @PostMapping("/{id}/cap-phat")
    public ApiResponse<Void> capPhatTaiSan(@PathVariable UUID id, @Valid @RequestBody CapPhatTaiSanRequest request) {
        khoTaiSanService.capPhatTaiSan(id, request);
        return ApiResponse.success(null, "Cấp phát tài sản thành công");
    }

    @PostMapping("/{id}/cap-phat-tat-ca")
    public ApiResponse<CapPhatTatCaResponse> capPhatTatCaTaiSan(@PathVariable UUID id, @Valid @RequestBody CapPhatTatCaRequest request) {
        return ApiResponse.success(khoTaiSanService.capPhatTatCaTaiSan(id, request), "C?p ph�t t�i s?n b? sung th�nh c�ng");
    }

    @PostMapping("/{id}/thu-hoi")
    public ApiResponse<Void> thuHoiTaiSan(@PathVariable UUID id, @Valid @RequestBody ThuHoiTaiSanRequest request) {
        khoTaiSanService.thuHoiTaiSan(id, request);
        return ApiResponse.success(null, "Thu hồi tài sản thành công");
    }

    @GetMapping("/{id}/lich-su")
    public ApiResponse<List<LichSuKhoTaiSanResponse>> getLichSuGiaoDich(@PathVariable UUID id) {
        return ApiResponse.success(khoTaiSanService.getLichSuGiaoDich(id), "Lấy lịch sử giao dịch thành công");
    }
}

