package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.DashboardStatsResponse;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.SuCoRepository;
import com.example.quanlyphongtro.repository.ThanhToanRepository;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class DashboardServiceTest {

    @Mock private PhongRepository phongRepository;
    @Mock private ThanhToanRepository thanhToanRepository;
    @Mock private HoaDonRepository hoaDonRepository;
    @Mock private HopDongRepository hopDongRepository;
    @Mock private SuCoRepository suCoRepository;
    @Mock private KhachThueRepository khachThueRepository;
    @Mock private PermissionService permissionService;

    @InjectMocks
    private DashboardService service;

    @BeforeEach
    void setUp() {
    }

    @Test
    void getStatsScopedByUser() {
        UUID userId = UUID.randomUUID();
        UUID nhaTroId = UUID.randomUUID();
        List<UUID> nhaTroIds = List.of(nhaTroId);

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.getAllAccessibleNhaTroIds(userId)).thenReturn(nhaTroIds);
        when(phongRepository.countByNhaTroIdIn(nhaTroIds)).thenReturn(10L);
        when(phongRepository.countByTrangThaiAndNhaTroIdIn(TrangThaiPhong.AVAILABLE, nhaTroIds)).thenReturn(2L);
        
        DashboardStatsResponse res = service.getStats();
        assertNotNull(res);
        assertEquals(10L, res.getTongSoPhong());
        assertEquals(2L, res.getPhongTrong());

        // Verify the repository was called with the specific nhaTroIds instead of all
        verify(phongRepository).countByNhaTroIdIn(nhaTroIds);
    }

    @Test
    void getStatsAdminSeesAll() {
        UUID userId = UUID.randomUUID();
        
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.getAllAccessibleNhaTroIds(userId)).thenReturn(null);
        when(phongRepository.count()).thenReturn(20L);
        when(phongRepository.countByTrangThai(TrangThaiPhong.AVAILABLE)).thenReturn(5L);
        
        DashboardStatsResponse res = service.getStats();
        assertNotNull(res);
        assertEquals(20L, res.getTongSoPhong());
        assertEquals(5L, res.getPhongTrong());

        verify(phongRepository).count();
    }
}
