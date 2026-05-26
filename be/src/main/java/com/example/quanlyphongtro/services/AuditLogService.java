package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.AuditLogResponse;
import com.example.quanlyphongtro.repository.AuditLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuditLogService {

    private final AuditLogRepository auditLogRepository;
    private final PermissionService permissionService;

    @Transactional(readOnly = true)
    public Page<AuditLogResponse> getAll(Pageable pageable) {
        permissionService.requireAdmin();
        return auditLogRepository.findAll(pageable).map(AuditLogResponse::fromEntity);
    }

    @Transactional(readOnly = true)
    public Page<AuditLogResponse> getByBangTacDong(String bangTacDong, Pageable pageable) {
        permissionService.requireAdmin();
        return auditLogRepository.findByBangTacDong(bangTacDong, pageable).map(AuditLogResponse::fromEntity);
    }

    @Transactional(readOnly = true)
    public Page<AuditLogResponse> getByNguoiDungId(UUID nguoiDungId, Pageable pageable) {
        permissionService.requireAdmin();
        return auditLogRepository.findByNguoiDungId(nguoiDungId, pageable).map(AuditLogResponse::fromEntity);
    }

    @Transactional(readOnly = true)
    public Page<AuditLogResponse> getByBanGhiId(UUID banGhiId, Pageable pageable) {
        permissionService.requireAdmin();
        return auditLogRepository.findByBanGhiId(banGhiId, pageable).map(AuditLogResponse::fromEntity);
    }
}
