package com.example.quanlyphongtro.repository;

import com.example.quanlyphongtro.entity.AuditLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface AuditLogRepository extends JpaRepository<AuditLog, UUID> {
    Page<AuditLog> findByBangTacDong(String bangTacDong, Pageable pageable);
    Page<AuditLog> findByNguoiDungId(UUID nguoiDungId, Pageable pageable);
    Page<AuditLog> findByBanGhiId(UUID banGhiId, Pageable pageable);
}
