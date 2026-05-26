package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.ThongBaoRequest;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.ThongBao;
import com.example.quanlyphongtro.repository.AuditLogRepository;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.ThongBaoNguoiNhanRepository;
import com.example.quanlyphongtro.repository.ThongBaoRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Pageable;
import org.springframework.test.util.ReflectionTestUtils;

@ExtendWith(MockitoExtension.class)
class ThongBaoServiceTest {

    @Mock private ThongBaoRepository thongBaoRepository;
    @Mock private ThongBaoNguoiNhanRepository thongBaoNguoiNhanRepository;
    @Mock private NguoiDungRepository nguoiDungRepository;
    @Mock private KhachThueRepository khachThueRepository;
    @Mock private PermissionService permissionService;
    @Mock private AuditLogRepository auditLogRepository;

    @InjectMocks private ThongBaoService service;

    @BeforeEach
    void setUp() {
        ReflectionTestUtils.setField(service, "permissionService", permissionService);
        ReflectionTestUtils.setField(service, "auditLogRepository", auditLogRepository);
    }

    @Test
    void managementListRequiresAdmin() {
        doThrow(new RuntimeException("admin only")).when(permissionService).requireAdmin();

        assertThrows(RuntimeException.class, () -> service.getAll(Pageable.unpaged()));
    }

    @Test
    void markReadRejectsTargetedNotificationForNonRecipient() {
        UUID notificationId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        ThongBao notification = ThongBao.builder().id(notificationId).guiTatCa(false).build();
        when(thongBaoRepository.findById(notificationId)).thenReturn(Optional.of(notification));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(nguoiDungRepository.findById(userId)).thenReturn(Optional.of(NguoiDung.builder().id(userId).build()));
        when(thongBaoNguoiNhanRepository.findByThongBaoIdAndNguoiDungId(notificationId, userId))
                .thenReturn(Optional.empty());

        assertThrows(RuntimeException.class, () -> service.markRead(notificationId, null, true));
    }

    @Test
    void createWritesAuditWithAuthenticatedSender() {
        UUID userId = UUID.randomUUID();
        UUID notificationId = UUID.randomUUID();
        NguoiDung sender = NguoiDung.builder().id(userId).build();
        ThongBaoRequest request = new ThongBaoRequest();
        request.setTieuDe("Thong bao");
        request.setNoiDung("Noi dung");

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(nguoiDungRepository.findById(userId)).thenReturn(Optional.of(sender));
        when(thongBaoRepository.save(any(ThongBao.class))).thenAnswer(invocation -> {
            ThongBao value = invocation.getArgument(0);
            value.setId(notificationId);
            return value;
        });
        when(thongBaoNguoiNhanRepository.findByThongBaoId(notificationId)).thenReturn(List.of());

        service.create(request);

        verify(permissionService).requireAdmin();
        verify(auditLogRepository).save(any());
    }
}
