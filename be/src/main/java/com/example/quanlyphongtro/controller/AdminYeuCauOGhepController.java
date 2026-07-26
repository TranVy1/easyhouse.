package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.YeuCauOGhepResponse;
import com.example.quanlyphongtro.services.YeuCauOGhepService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/admin/o-ghep")
@RequiredArgsConstructor
public class AdminYeuCauOGhepController {

    private final YeuCauOGhepService yeuCauOGhepService;

    @GetMapping("/nha-tro/{nhaTroId}")
    public ResponseEntity<ApiResponse<List<YeuCauOGhepResponse>>> getRequestsForAdmin(@PathVariable UUID nhaTroId) {
        try {
            return ResponseEntity.ok(ApiResponse.success(yeuCauOGhepService.getRequestsForAdmin(nhaTroId)));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    @PutMapping("/{id}/approve")
    public ResponseEntity<ApiResponse<YeuCauOGhepResponse>> approveRequest(
            @PathVariable UUID id,
            @RequestParam boolean isApprove,
            @RequestParam(required = false) String ghiChu) {
        try {
            return ResponseEntity.ok(ApiResponse.success(yeuCauOGhepService.adminApprove(id, isApprove, ghiChu)));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }
}
