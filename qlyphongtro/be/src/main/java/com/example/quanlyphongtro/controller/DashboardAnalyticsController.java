package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.*;
import com.example.quanlyphongtro.services.DashboardAnalyticsService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/dashboard/analytics")
@RequiredArgsConstructor
public class DashboardAnalyticsController {

    private final DashboardAnalyticsService analyticsService;

    @GetMapping("/overview")
    public ApiResponse<DashboardAnalyticsOverviewResponse> getOverview(
            @RequestParam(required = false) UUID nhaTroId) {
        return ApiResponse.success(analyticsService.getOverview(nhaTroId));
    }

    @GetMapping("/revenue-chart")
    public ApiResponse<List<RevenueChartItemResponse>> getRevenueChart(
            @RequestParam(defaultValue = "12") int months,
            @RequestParam(required = false) UUID nhaTroId) {
        return ApiResponse.success(analyticsService.getRevenueChart(months, nhaTroId));
    }

    @GetMapping("/debt-aging")
    public ApiResponse<DebtAgingResponse> getDebtAging(
            @RequestParam(required = false) UUID nhaTroId) {
        return ApiResponse.success(analyticsService.getDebtAging(nhaTroId));
    }

    @GetMapping("/top-debtors")
    public ApiResponse<List<TopDebtorResponse>> getTopDebtors(
            @RequestParam(defaultValue = "5") int limit,
            @RequestParam(required = false) UUID nhaTroId) {
        return ApiResponse.success(analyticsService.getTopDebtors(nhaTroId, limit));
    }

    @GetMapping("/action-items")
    public ApiResponse<List<ActionItemResponse>> getActionItems(
            @RequestParam(defaultValue = "10") int limit,
            @RequestParam(required = false) UUID nhaTroId) {
        return ApiResponse.success(analyticsService.getActionItems(nhaTroId, limit));
    }
}
