package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.DichVuResponse;
import com.example.quanlyphongtro.services.DichVuService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/dich-vu")
@RequiredArgsConstructor
public class DichVuController {

    private final DichVuService dichVuService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<DichVuResponse>>> getAll() {
        List<DichVuResponse> data = dichVuService.getAll();
        return ResponseEntity.ok(ApiResponse.<List<DichVuResponse>>builder()
                .success(true)
                .message("Lấy danh sách dịch vụ thành công")
                .data(data)
                .build());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<DichVuResponse>> getById(@org.springframework.web.bind.annotation.PathVariable java.util.UUID id) {
        DichVuResponse data = dichVuService.getById(id);
        return ResponseEntity.ok(ApiResponse.<DichVuResponse>builder()
                .success(true)
                .message("Lấy chi tiết dịch vụ thành công")
                .data(data)
                .build());
    }

    @org.springframework.web.bind.annotation.PostMapping
    public ResponseEntity<ApiResponse<DichVuResponse>> create(@org.springframework.web.bind.annotation.RequestBody com.example.quanlyphongtro.dto.DichVuRequest req) {
        DichVuResponse data = dichVuService.create(req);
        return ResponseEntity.ok(ApiResponse.<DichVuResponse>builder()
                .success(true)
                .message("Thêm mới dịch vụ thành công")
                .data(data)
                .build());
    }

    @org.springframework.web.bind.annotation.PutMapping("/{id}")
    public ResponseEntity<ApiResponse<DichVuResponse>> update(@org.springframework.web.bind.annotation.PathVariable java.util.UUID id,
                                                              @org.springframework.web.bind.annotation.RequestBody com.example.quanlyphongtro.dto.DichVuRequest req) {
        DichVuResponse data = dichVuService.update(id, req);
        return ResponseEntity.ok(ApiResponse.<DichVuResponse>builder()
                .success(true)
                .message("Cập nhật dịch vụ thành công")
                .data(data)
                .build());
    }

    @org.springframework.web.bind.annotation.DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@org.springframework.web.bind.annotation.PathVariable java.util.UUID id) {
        dichVuService.delete(id);
        return ResponseEntity.ok(ApiResponse.<Void>builder()
                .success(true)
                .message("Xóa dịch vụ thành công")
                .build());
    }
}
