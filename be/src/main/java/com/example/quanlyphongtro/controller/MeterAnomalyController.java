package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.MeterAnomalyAlertResponse;
import com.example.quanlyphongtro.entity.MeterAnomalyAlert;
import com.example.quanlyphongtro.entity.TrangThaiAlert;
import com.example.quanlyphongtro.repository.MeterAnomalyAlertRepository;
import com.example.quanlyphongtro.services.MeterAnomalyService;
import com.example.quanlyphongtro.services.PermissionService;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/meter-alerts")
@RequiredArgsConstructor
public class MeterAnomalyController {

    private final MeterAnomalyService meterAnomalyService;
    private final MeterAnomalyAlertRepository alertRepository;
    private final PermissionService permissionService;
    private final NguoiDungRepository nguoiDungRepository;

    @GetMapping
    public ResponseEntity<ApiResponse<List<MeterAnomalyAlertResponse>>> getAlerts(
            @RequestParam(required = false) UUID nhaTroId) {
        
        UUID userId = permissionService.requireCurrentUserId();
        List<UUID> nhaTroIds;
        
        if (nhaTroId != null) {
            List<UUID> accessibleIds = permissionService.getAllAccessibleNhaTroIds(userId);
            if (accessibleIds != null && !accessibleIds.contains(nhaTroId)) {
                return ResponseEntity.status(403).body(ApiResponse.error("Access denied"));
            }
            nhaTroIds = List.of(nhaTroId);
        } else {
            nhaTroIds = permissionService.getAllAccessibleNhaTroIds(userId);
        }

        List<MeterAnomalyAlert> alerts;
        if (nhaTroIds.isEmpty()) {
             alerts = List.of();
        } else {
             alerts = alertRepository.findByTrangThaiAndNhaTroIds(TrangThaiAlert.OPEN, nhaTroIds);
        }

        List<MeterAnomalyAlertResponse> responses = alerts.stream().map(a -> MeterAnomalyAlertResponse.builder()
                .id(a.getId())
                .chiSoId(a.getChiSoDienNuoc().getId())
                .phongId(a.getPhong().getId())
                .tenPhong(a.getPhong().getTen())
                .nhaTroTen(a.getPhong().getNhaTro().getTen())
                .loai(a.getLoai())
                .kyThang(a.getKyThang())
                .kyNam(a.getKyNam())
                .tieuThuHienTai(a.getTieuThuHienTai())
                .tieuThuTrungBinh(a.getTieuThuTrungBinh())
                .tyLeTang(a.getTyLeTang())
                .mucDo(a.getMucDo())
                .lyDo(a.getLyDo())
                .trangThai(a.getTrangThai())
                .taoLuc(a.getTaoLuc())
                .build()).collect(Collectors.toList());

        return ResponseEntity.ok(ApiResponse.success(responses));
    }

    @PatchMapping("/{id}/resolve")
    public ResponseEntity<ApiResponse<String>> resolveAlert(
            @PathVariable UUID id,
            @RequestParam String status) {
        
        UUID userId = permissionService.requireCurrentUserId();
        NguoiDung currentUser = nguoiDungRepository.findById(userId).orElseThrow();
        
        MeterAnomalyAlert alert = alertRepository.findById(id).orElseThrow();
        if (!permissionService.canWritePhong(userId, alert.getPhong().getId())) {
             return ResponseEntity.status(403).body(ApiResponse.error("Access denied"));
        }

        TrangThaiAlert newStatus = TrangThaiAlert.valueOf(status.toUpperCase());
        meterAnomalyService.resolveAlert(id, newStatus, currentUser);

        return ResponseEntity.ok(ApiResponse.success("Alert resolved successfully"));
    }
}
