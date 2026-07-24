package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.ImportToaNhaRequest;
import com.example.quanlyphongtro.dto.ImportToaNhaResponse;
import com.example.quanlyphongtro.services.ImportToaNhaService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/import/toa-nha")
@RequiredArgsConstructor
public class ImportToaNhaController {
    private final ImportToaNhaService importToaNhaService;

    @PostMapping("/preview")
    public ApiResponse<ImportToaNhaResponse> preview(@RequestBody ImportToaNhaRequest request) {
        try {
            return ApiResponse.success(importToaNhaService.preview(request));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/confirm")
    public ApiResponse<ImportToaNhaResponse> confirm(@RequestBody ImportToaNhaRequest request) {
        try {
            return ApiResponse.success(importToaNhaService.confirm(request), "Import toa nha thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
