package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.YeuCauOGhepRequest;
import com.example.quanlyphongtro.dto.YeuCauOGhepResponse;
import com.example.quanlyphongtro.services.YeuCauOGhepService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/tenant/o-ghep")
@RequiredArgsConstructor
public class TenantYeuCauOGhepController {

    private final YeuCauOGhepService yeuCauOGhepService;

    @PostMapping
    public ResponseEntity<ApiResponse<YeuCauOGhepResponse>> createRequest(@RequestBody YeuCauOGhepRequest request) {
        try {
            return ResponseEntity.ok(ApiResponse.success(yeuCauOGhepService.createYeuCau(request)));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @GetMapping("/my-requests")
    public ResponseEntity<ApiResponse<List<YeuCauOGhepResponse>>> getMyRequests() {
        try {
            return ResponseEntity.ok(ApiResponse.success(yeuCauOGhepService.getMyRequests()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @GetMapping("/hop-dong/{hopDongId}")
    public ResponseEntity<ApiResponse<List<YeuCauOGhepResponse>>> getRequestsForMyRoom(@PathVariable UUID hopDongId) {
        try {
            return ResponseEntity.ok(ApiResponse.success(yeuCauOGhepService.getRequestsForMyRoom(hopDongId)));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{id}/approve")
    public ResponseEntity<ApiResponse<YeuCauOGhepResponse>> tenantApprove(
            @PathVariable UUID id,
            @RequestParam boolean isApprove,
            @RequestParam(required = false) String ghiChu) {
        try {
            return ResponseEntity.ok(ApiResponse.success(yeuCauOGhepService.tenantApprove(id, isApprove, ghiChu)));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }
}
