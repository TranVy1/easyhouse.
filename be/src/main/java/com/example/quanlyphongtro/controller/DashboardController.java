package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.DashboardStatsResponse;
import com.example.quanlyphongtro.services.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final DashboardService dashboardService;

    @GetMapping("/stats")
    public ApiResponse<DashboardStatsResponse> getStats() {
        try {
            DashboardStatsResponse stats = dashboardService.getStats();
            return ApiResponse.success(stats);
        } catch (Exception e) {
            return ApiResponse.error("Lỗi khi lấy thống kê: " + e.getMessage());
        }
    }
}
