package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.AuditLog;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@Builder
public class AuditLogResponse {
    @JsonProperty("_id")
    private UUID id;
    private UUID nguoiDungId;
    private String nguoiDungHoTen;
    private String nguoiDungEmail;
    private String hanhDong;
    private String bangTacDong;
    private UUID banGhiId;
    private String duLieuCu;
    private String duLieuMoi;
    private String ipAddress;
    private String userAgent;
    private ZonedDateTime taoLuc;

    public static AuditLogResponse fromEntity(AuditLog auditLog) {
        if (auditLog == null) return null;
        return AuditLogResponse.builder()
                .id(auditLog.getId())
                .nguoiDungId(auditLog.getNguoiDung() != null ? auditLog.getNguoiDung().getId() : null)
                .nguoiDungHoTen(auditLog.getNguoiDung() != null ? auditLog.getNguoiDung().getHoTen() : null)
                .nguoiDungEmail(auditLog.getNguoiDung() != null ? auditLog.getNguoiDung().getEmail() : null)
                .hanhDong(auditLog.getHanhDong())
                .bangTacDong(auditLog.getBangTacDong())
                .banGhiId(auditLog.getBanGhiId())
                .duLieuCu(auditLog.getDuLieuCu())
                .duLieuMoi(auditLog.getDuLieuMoi())
                .ipAddress(auditLog.getIpAddress())
                .userAgent(auditLog.getUserAgent())
                .taoLuc(auditLog.getTaoLuc())
                .build();
    }
}
