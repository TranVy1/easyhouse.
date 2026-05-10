package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import org.springframework.web.bind.annotation.*;
import java.util.Collections;
import java.util.List;

@RestController
@RequestMapping("/api/thanh-toan")
public class ThanhToanController {

    @GetMapping
    public ApiResponse<List<Object>> getAll() {
        return ApiResponse.success(Collections.emptyList());
    }

    @PostMapping
    public ApiResponse<Object> create(@RequestBody Object request) {
        return ApiResponse.success(request);
    }
}
