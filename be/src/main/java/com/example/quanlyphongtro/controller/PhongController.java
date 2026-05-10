package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.PhongResponse;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.services.PhongService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

import com.example.quanlyphongtro.dto.PhongRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/phong")
@RequiredArgsConstructor
public class PhongController {

    private final PhongService phongService;

    @GetMapping
    public ApiResponse<List<PhongResponse>> getAll(
            @RequestParam(required = false) String toaNha,
            @RequestParam(required = false) String trangThai) {
        
        List<Phong> list = phongService.getAllPhong(toaNha, trangThai);
        List<PhongResponse> respList = list.stream()
            .map(PhongResponse::fromEntity)
            .collect(Collectors.toList());
        
        return ApiResponse.success(respList);
    }

    @GetMapping("/{id}")
    public ApiResponse<PhongResponse> getById(@PathVariable UUID id) {
        try {
            Phong phong = phongService.getPhongById(id);
            return ApiResponse.success(PhongResponse.fromEntity(phong));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping
    public ApiResponse<PhongResponse> createPhong(@Valid @RequestBody PhongRequest request) {
        try {
            Phong phong = phongService.createPhong(request);
            return ApiResponse.success(PhongResponse.fromEntity(phong), "Thêm phòng thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ApiResponse<PhongResponse> updatePhong(@PathVariable UUID id, @RequestBody PhongRequest request) {
        try {
            Phong phong = phongService.updatePhong(id, request);
            return ApiResponse.success(PhongResponse.fromEntity(phong), "Cập nhật phòng thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deletePhong(@PathVariable UUID id) {
        try {
            phongService.deletePhong(id);
            return ApiResponse.success(null, "Xóa phòng thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
