package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.repository.AuditLogRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

@ExtendWith(MockitoExtension.class)
class AuditLogServiceTest {

    @Mock private AuditLogRepository auditLogRepository;
    @Mock private PermissionService permissionService;
    @InjectMocks private AuditLogService service;

    @Test
    void listRejectsNonAdminBeforeQueryingRepository() {
        Pageable pageable = Pageable.unpaged();
        doThrow(new RuntimeException("admin only")).when(permissionService).requireAdmin();

        assertThrows(RuntimeException.class, () -> service.getAll(pageable));

        verify(auditLogRepository, never()).findAll(pageable);
    }

    @Test
    void adminCanReadAuditList() {
        Pageable pageable = Pageable.unpaged();
        when(auditLogRepository.findAll(pageable)).thenReturn(Page.empty(pageable));

        service.getAll(pageable);

        verify(permissionService).requireAdmin();
        verify(auditLogRepository).findAll(pageable);
    }
}
