package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.services.SchedulerService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin/test-scheduler")
@RequiredArgsConstructor
public class TestSchedulerController {

    private final SchedulerService schedulerService;

    @PostMapping("/trigger-contracts")
    public ApiResponse<Void> triggerContracts() {
        try {
            schedulerService.checkExpiringContracts();
            return ApiResponse.success(null, "Đã kích hoạt quét hợp đồng sắp hết hạn thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/trigger-overdue")
    public ApiResponse<Void> triggerOverdue() {
        try {
            schedulerService.checkInvoices();
            return ApiResponse.success(null, "Đã kích hoạt quét hóa đơn thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/trigger-upcoming-invoices")
    public ApiResponse<Void> triggerUpcomingInvoices() {
        try {
            schedulerService.checkInvoices();
            return ApiResponse.success(null, "Đã kích hoạt quét hóa đơn thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/run-all")
    public ApiResponse<Void> runAll() {
        try {
            schedulerService.runDailyChecks();
            return ApiResponse.success(null, "Đã kích hoạt toàn bộ job hàng ngày thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
