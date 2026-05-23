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
}
