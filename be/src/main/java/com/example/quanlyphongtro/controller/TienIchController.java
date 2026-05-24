package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.TienIchRequest;
import com.example.quanlyphongtro.dto.TienIchResponse;
import com.example.quanlyphongtro.services.TienIchService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/tien-ich")
@RequiredArgsConstructor
public class TienIchController {

    private final TienIchService tienIchService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<TienIchResponse>>> getAll() {
        List<TienIchResponse> data = tienIchService.getAll();
        return ResponseEntity.ok(ApiResponse.<List<TienIchResponse>>builder()
                .success(true)
                .message("Lấy danh sách tiện ích thành công")
                .data(data)
                .build());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TienIchResponse>> getById(@PathVariable UUID id) {
        TienIchResponse data = tienIchService.getById(id);
        return ResponseEntity.ok(ApiResponse.<TienIchResponse>builder()
                .success(true)
                .message("Lấy chi tiết tiện ích thành công")
                .data(data)
                .build());
    }

    @PostMapping
    public ResponseEntity<ApiResponse<TienIchResponse>> create(@RequestBody TienIchRequest req) {
        TienIchResponse data = tienIchService.create(req);
        return ResponseEntity.ok(ApiResponse.<TienIchResponse>builder()
                .success(true)
                .message("Thêm mới tiện ích thành công")
                .data(data)
                .build());
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<TienIchResponse>> update(@PathVariable UUID id, @RequestBody TienIchRequest req) {
        TienIchResponse data = tienIchService.update(id, req);
        return ResponseEntity.ok(ApiResponse.<TienIchResponse>builder()
                .success(true)
                .message("Cập nhật tiện ích thành công")
                .data(data)
                .build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable UUID id) {
        tienIchService.delete(id);
        return ResponseEntity.ok(ApiResponse.<Void>builder()
                .success(true)
                .message("Xóa tiện ích thành công")
                .build());
    }
}
