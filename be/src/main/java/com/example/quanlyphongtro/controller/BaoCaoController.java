package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.BaoCaoTongQuanResponse;
import com.example.quanlyphongtro.services.BaoCaoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/bao-cao")
@RequiredArgsConstructor
public class BaoCaoController {

    private final BaoCaoService baoCaoService;

    @GetMapping("/tong-quan")
    public ResponseEntity<ApiResponse<BaoCaoTongQuanResponse>> getTongQuan() {
        return ResponseEntity.ok(ApiResponse.<BaoCaoTongQuanResponse>builder()
                .success(true)
                .message("Lấy dữ liệu báo cáo thành công")
                .data(baoCaoService.getTongQuan())
                .build());
    }
}
