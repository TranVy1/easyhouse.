package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.AuditLogResponse;
import com.example.quanlyphongtro.services.AuditLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/api/audit-log")
@RequiredArgsConstructor
public class AuditLogController {

    private final AuditLogService auditLogService;

    @GetMapping
    public ResponseEntity<ApiResponse<Page<AuditLogResponse>>> getAuditLogs(
            @RequestParam(required = false) String bangTacDong,
            @RequestParam(required = false) UUID nguoiDungId,
            @RequestParam(required = false) UUID banGhiId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "taoLuc"));
        Page<AuditLogResponse> logs;

        if (bangTacDong != null && !bangTacDong.isEmpty()) {
            logs = auditLogService.getByBangTacDong(bangTacDong, pageable);
        } else if (nguoiDungId != null) {
            logs = auditLogService.getByNguoiDungId(nguoiDungId, pageable);
        } else if (banGhiId != null) {
            logs = auditLogService.getByBanGhiId(banGhiId, pageable);
        } else {
            logs = auditLogService.getAll(pageable);
        }

        return ResponseEntity.ok(ApiResponse.<Page<AuditLogResponse>>builder()
                .success(true)
                .message("Lấy nhật ký hệ thống thành công")
                .data(logs)
                .build());
    }
}
