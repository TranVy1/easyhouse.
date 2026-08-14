package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.CauHinhPhiXeRequest;
import com.example.quanlyphongtro.dto.CauHinhPhiXeResponse;
import com.example.quanlyphongtro.services.CauHinhPhiXeService;
import jakarta.validation.Valid;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/cau-hinh-phi-xe")
@RequiredArgsConstructor
public class CauHinhPhiXeController {
    private final CauHinhPhiXeService service;
    @GetMapping public ApiResponse<List<CauHinhPhiXeResponse>> getAll(@RequestParam UUID nhaTroId, @RequestParam(required = false) String loaiXe) { return ApiResponse.success(service.getAll(nhaTroId, loaiXe)); }
    @GetMapping("/{id}") public ApiResponse<CauHinhPhiXeResponse> getById(@PathVariable UUID id) { return ApiResponse.success(service.getById(id)); }
    @PostMapping public ApiResponse<CauHinhPhiXeResponse> create(@Valid @RequestBody CauHinhPhiXeRequest request) { return ApiResponse.success(service.create(request), "Tạo biểu phí xe thành công"); }
    @PutMapping("/{id}") public ApiResponse<CauHinhPhiXeResponse> update(@PathVariable UUID id, @Valid @RequestBody CauHinhPhiXeRequest request) { return ApiResponse.success(service.update(id, request), "Cập nhật biểu phí xe thành công"); }
    @DeleteMapping("/{id}") public ApiResponse<Void> deactivate(@PathVariable UUID id, @RequestParam(required = false) LocalDate hieuLucDen) { service.deactivate(id, hieuLucDen); return ApiResponse.success(null, "Đã ngừng hiệu lực biểu phí xe"); }
}
