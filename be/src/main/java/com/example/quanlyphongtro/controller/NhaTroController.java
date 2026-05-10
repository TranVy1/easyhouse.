package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.NhaTroRequest;
import com.example.quanlyphongtro.dto.NhaTroResponse;
import com.example.quanlyphongtro.services.NhaTroService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping({"/api/nha-tro", "/api/toa-nha"})
@RequiredArgsConstructor
public class NhaTroController {

    private final NhaTroService nhaTroService;

    @GetMapping
    public ApiResponse<List<NhaTroResponse>> getAll() {
        return ApiResponse.success(nhaTroService.getAllNhaTro());
    }

    @GetMapping("/{id}")
    public ApiResponse<NhaTroResponse> getById(@PathVariable UUID id) {
        try {
            return ApiResponse.success(nhaTroService.getNhaTroById(id));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping
    public ApiResponse<NhaTroResponse> createNhaTro(@RequestBody NhaTroRequest request) {
        try {
            NhaTroResponse response = nhaTroService.createNhaTro(request);
            return ApiResponse.success(response, "Thêm tòa nhà thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ApiResponse<NhaTroResponse> updateNhaTro(@PathVariable UUID id, @RequestBody NhaTroRequest request) {
        try {
            NhaTroResponse response = nhaTroService.updateNhaTro(id, request);
            return ApiResponse.success(response, "Cập nhật tòa nhà thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deleteNhaTro(@PathVariable UUID id) {
        try {
            nhaTroService.deleteNhaTro(id);
            return ApiResponse.success(null, "Xóa tòa nhà thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
