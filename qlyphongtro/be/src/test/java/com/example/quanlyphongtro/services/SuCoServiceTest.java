package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.SuCoRequest;
import com.example.quanlyphongtro.dto.SuCoResponse;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.SuCo;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.TrangThaiHopDong;
import com.example.quanlyphongtro.entity.TrangThaiSuCo;
import com.example.quanlyphongtro.repository.AuditLogRepository;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.SuCoRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.test.util.ReflectionTestUtils;

@ExtendWith(MockitoExtension.class)
class SuCoServiceTest {

    @Mock private SuCoRepository suCoRepository;
    @Mock private PhongRepository phongRepository;
    @Mock private KhachThueRepository khachThueRepository;
    @Mock private HopDongRepository hopDongRepository;
    @Mock private MediaService mediaService;
    @Mock private PermissionService permissionService;
    @Mock private AuditLogRepository auditLogRepository;
    @Mock private NguoiDungRepository nguoiDungRepository;

    @InjectMocks
    private SuCoService service;

    @BeforeEach
    void setUp() {
        ReflectionTestUtils.setField(service, "auditLogRepository", auditLogRepository);
        ReflectionTestUtils.setField(service, "permissionService", permissionService);
    }

    @Test
    void createSuCoThrowsWhenTenantCannotReadPhong() {
        UUID phongId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.canReadPhong(userId, phongId)).thenReturn(false);

        SuCoRequest req = new SuCoRequest();
        req.setPhongId(phongId);

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.createSuCo(req));
        assertEquals("Khong co quyen bao cao su co cho phong nay", error.getMessage());
    }

    @Test
    void createSuCoRejectsTenantSpoofingAnotherTenant() {
        UUID userId = UUID.randomUUID();
        UUID phongId = UUID.randomUUID();
        UUID ownTenantId = UUID.randomUUID();
        UUID anotherTenantId = UUID.randomUUID();
        KhachThue ownTenant = KhachThue.builder()
                .id(ownTenantId)
                .nguoiDung(NguoiDung.builder().id(userId).build())
                .build();

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.canReadPhong(userId, phongId)).thenReturn(true);
        when(permissionService.canWritePhong(userId, phongId)).thenReturn(false);
        when(phongRepository.findById(phongId)).thenReturn(Optional.of(Phong.builder().id(phongId).build()));
        when(hopDongRepository.findRoomOccupyingContracts(phongId, List.of(TrangThaiHopDong.ACTIVE)))
                .thenReturn(List.of(HopDong.builder().khachThue(ownTenant).build()));

        SuCoRequest req = new SuCoRequest();
        req.setPhongId(phongId);
        req.setKhachThueId(anotherTenantId);

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.createSuCo(req));
        assertEquals("Khong co quyen bao cao su co cho khach thue khac", error.getMessage());
    }

    @Test
    void createSuCoRejectsTenantAdminFields() {
        UUID userId = UUID.randomUUID();
        UUID phongId = UUID.randomUUID();

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.canReadPhong(userId, phongId)).thenReturn(true);
        when(permissionService.canWritePhong(userId, phongId)).thenReturn(false);
        when(phongRepository.findById(phongId)).thenReturn(Optional.of(Phong.builder().id(phongId).build()));

        SuCoRequest req = new SuCoRequest();
        req.setPhongId(phongId);
        req.setChiPhiSuaChua(BigDecimal.ONE);

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.createSuCo(req));
        assertEquals("Khong co quyen nhap ghi chu chu nha hoac chi phi su co", error.getMessage());
    }

    @Test
    void updateSuCoThrowsWhenTenantUpdatesAdminFields() {
        UUID id = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        UUID phongId = UUID.randomUUID();
        
        SuCo sc = SuCo.builder()
                .id(id)
                .phong(Phong.builder().id(phongId).build())
                .nguoiBao(NguoiDung.builder().id(userId).build())
                .trangThai(TrangThaiSuCo.PENDING)
                .build();
                
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(suCoRepository.findById(id)).thenReturn(Optional.of(sc));
        // Tenant can read, but cannot write
        when(permissionService.canWritePhong(userId, phongId)).thenReturn(false);

        SuCoRequest req = new SuCoRequest();
        req.setTrangThai("RESOLVED"); // Admin field

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.updateSuCo(id, req));
        assertEquals("Khong co quyen cap nhat trang thai hoac chi phi su co", error.getMessage());
    }

    @Test
    void updateSuCoThrowsWhenTenantUpdatesIncidentOfAnotherTenant() {
        UUID id = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        UUID anotherUserId = UUID.randomUUID();
        UUID phongId = UUID.randomUUID();
        
        SuCo sc = SuCo.builder()
                .id(id)
                .phong(Phong.builder().id(phongId).build())
                .nguoiBao(NguoiDung.builder().id(anotherUserId).build())
                .trangThai(TrangThaiSuCo.PENDING)
                .build();
                
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(suCoRepository.findById(id)).thenReturn(Optional.of(sc));
        // User cannot write to room
        when(permissionService.canWritePhong(userId, phongId)).thenReturn(false);

        SuCoRequest req = new SuCoRequest();
        req.setMoTa("New description");

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.updateSuCo(id, req));
        assertEquals("Khong co quyen cap nhat su co nay", error.getMessage());
    }

    @Test
    void updateSuCoAllowsOwnerToUpdateAnything() {
        UUID id = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        UUID phongId = UUID.randomUUID();
        
        SuCo sc = SuCo.builder()
                .id(id)
                .phong(Phong.builder().id(phongId).build())
                .trangThai(TrangThaiSuCo.PENDING)
                .build();
                
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(suCoRepository.findById(id)).thenReturn(Optional.of(sc));
        when(permissionService.canWritePhong(userId, phongId)).thenReturn(true);
        when(suCoRepository.save(any())).thenAnswer(i -> i.getArgument(0));

        SuCoRequest req = new SuCoRequest();
        req.setTrangThai("RESOLVED");
        req.setChiPhiSuaChua(BigDecimal.valueOf(500000));
        req.setGhiChuChuNha("Fixed");

        SuCoResponse res = service.updateSuCo(id, req);
        assertEquals("RESOLVED", res.getTrangThai());
        assertEquals(BigDecimal.valueOf(500000), res.getChiPhiSuaChua());
        assertEquals("Fixed", res.getGhiChuChuNha());
    }

    @Test
    void getAllKeepsTenantOwnedIncidentsVisibleWithoutBuildingScopeAndPassesFilters() {
        UUID userId = UUID.randomUUID();
        Pageable pageable = PageRequest.of(0, 10);

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.isAdmin(userId)).thenReturn(false);
        when(permissionService.getAllAccessibleNhaTroIds(userId)).thenReturn(List.of());
        when(suCoRepository.findAllAccessible(
                false, userId, List.of(), null, null, "PENDING",
                "dien_nuoc", "cao", pageable))
                .thenReturn(new PageImpl<>(List.of(), pageable, 0));

        service.getAllSuCo(null, null, "PENDING", "DIEN_NUOC", "CAO", pageable);

        verify(suCoRepository).findAllAccessible(
                false, userId, List.of(), null, null, "PENDING",
                "dien_nuoc", "cao", pageable);
    }
}
