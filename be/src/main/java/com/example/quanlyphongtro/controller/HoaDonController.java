package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import org.springframework.web.bind.annotation.*;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/hoa-don")
public class HoaDonController {

    @GetMapping
    public ApiResponse<List<Object>> getAll() {
        return ApiResponse.success(Collections.emptyList());
    }

    @PostMapping
    public ApiResponse<Object> create(@RequestBody Object request) {
        return ApiResponse.success(request);
    }

    @GetMapping("/form-data")
    public ApiResponse<Map<String, Object>> getFormData() {
        Map<String, Object> formData = new HashMap<>();
        formData.put("hopDongList", Collections.emptyList());
        formData.put("phongList", Collections.emptyList());
        formData.put("khachThueList", Collections.emptyList());
        return ApiResponse.success(formData);
    }

    @GetMapping("/latest-reading")
    public ApiResponse<Map<String, Object>> getLatestReading(
            @RequestParam String hopDong,
            @RequestParam int thang,
            @RequestParam int nam) {
        Map<String, Object> reading = new HashMap<>();
        reading.put("chiSoDienCu", 0);
        reading.put("chiSoNuocCu", 0);
        return ApiResponse.success(reading);
    }
}
