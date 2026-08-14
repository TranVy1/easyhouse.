package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.repository.MeterAnomalyAlertRepository;
import jakarta.persistence.EntityManager;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class DashboardAnalyticsServiceTest {

    @Mock private EntityManager entityManager;
    @Mock private MeterAnomalyAlertRepository meterAnomalyAlertRepository;
    @Mock private PermissionService permissionService;
    @InjectMocks private DashboardAnalyticsService service;

    @Test
    void rejectsAnalyticsForAnInaccessibleBuildingBeforeQueryingData() {
        UUID userId = UUID.randomUUID();
        UUID allowedBuildingId = UUID.randomUUID();
        UUID forbiddenBuildingId = UUID.randomUUID();
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.getAllAccessibleNhaTroIds(userId)).thenReturn(List.of(allowedBuildingId));

        RuntimeException error = assertThrows(RuntimeException.class,
                () -> service.getOverview(forbiddenBuildingId));

        assertEquals("Bạn không có quyền xem dữ liệu tòa nhà này", error.getMessage());
        verifyNoInteractions(entityManager);
    }
}
