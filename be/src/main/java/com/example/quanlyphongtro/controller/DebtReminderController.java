package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.entity.DebtReminderLog;
import com.example.quanlyphongtro.repository.DebtReminderLogRepository;
import com.example.quanlyphongtro.services.DebtReminderService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/debt-reminders")
@RequiredArgsConstructor
public class DebtReminderController {

    private final DebtReminderLogRepository logRepository;
    private final DebtReminderService debtReminderService;

    @GetMapping("/invoice/{hoaDonId}")
    public ApiResponse<List<DebtReminderLog>> getLogsByInvoice(@PathVariable UUID hoaDonId) {
        return ApiResponse.success(logRepository.findByHoaDonIdOrderBySentAtDesc(hoaDonId));
    }

    @PostMapping("/invoice/{hoaDonId}/manual")
    public ApiResponse<String> sendManualReminder(@PathVariable UUID hoaDonId) {
        debtReminderService.processManualReminder(hoaDonId);
        return ApiResponse.success("Đã gửi nhắc nợ thành công");
    }
}
