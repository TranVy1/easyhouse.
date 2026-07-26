package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.CauHinhGiaRequest;
import com.example.quanlyphongtro.dto.CauHinhGiaResponse;
import com.example.quanlyphongtro.entity.CauHinhGia;
import com.example.quanlyphongtro.entity.LoaiMucHoaDon;
import com.example.quanlyphongtro.entity.LoaiTinhPhi;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.repository.AuditLogRepository;
import com.example.quanlyphongtro.repository.CauHinhGiaRepository;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

@ExtendWith(MockitoExtension.class)
class CauHinhGiaServiceTest {

    @Mock private CauHinhGiaRepository cauHinhGiaRepository;
    @Mock private NhaTroRepository nhaTroRepository;
    @Mock private PermissionService permissionService;
    @Mock private AuditLogRepository auditLogRepository;

    @InjectMocks
    private CauHinhGiaService service;

    @BeforeEach
    void setUp() {
        ReflectionTestUtils.setField(service, "auditLogRepository", auditLogRepository);
        ReflectionTestUtils.setField(service, "permissionService", permissionService);
    }

    @Test
    void createRequiresWritePermission() {
        UUID nhaTroId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        UUID ownerId = UUID.randomUUID();
        
        NhaTro nhaTro = NhaTro.builder().id(nhaTroId).chuTro(NguoiDung.builder().id(ownerId).build()).build();
        when(nhaTroRepository.findById(nhaTroId)).thenReturn(Optional.of(nhaTro));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.canWriteNhaTro(userId, nhaTroId, ownerId)).thenReturn(false);

        CauHinhGiaRequest req = new CauHinhGiaRequest();
        req.setNhaTroId(nhaTroId);
        req.setLoai("ELECTRICITY");
        req.setDonGia(BigDecimal.valueOf(3500));
        req.setTenHienThi("Dien");

        assertThrows(RuntimeException.class, () -> service.create(req));
    }

    @Test
    void createThrowsOnOverlap() {
        UUID nhaTroId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        NhaTro nhaTro = NhaTro.builder().id(nhaTroId).build();
        
        when(nhaTroRepository.findById(nhaTroId)).thenReturn(Optional.of(nhaTro));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.canWriteNhaTro(userId, nhaTroId, null)).thenReturn(true);

        CauHinhGia existing = CauHinhGia.builder()
                .id(UUID.randomUUID())
                .nhaTro(nhaTro)
                .loai(LoaiMucHoaDon.ELECTRICITY)
                .hieuLucTu(LocalDate.of(2026, 1, 1))
                .hieuLucDen(null)
                .dangApDung(true)
                .build();
        when(cauHinhGiaRepository.findByNhaTroIdAndLoaiAndDangApDungTrueOrderByHieuLucTuDesc(nhaTroId, LoaiMucHoaDon.ELECTRICITY))
                .thenReturn(List.of(existing));

        CauHinhGiaRequest req = new CauHinhGiaRequest();
        req.setNhaTroId(nhaTroId);
        req.setLoai("ELECTRICITY");
        req.setDonGia(BigDecimal.valueOf(3500));
        req.setTenHienThi("Dien");
        req.setHieuLucTu(LocalDate.of(2026, 5, 1));

        RuntimeException err = assertThrows(RuntimeException.class, () -> service.create(req));
        assertEquals("Cấu hình giá bị trùng lặp thời gian áp dụng với một cấu hình khác cùng loại", err.getMessage());
    }

    @Test
    void updateCreatesNewVersion() {
        UUID id = UUID.randomUUID();
        UUID nhaTroId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        NhaTro nhaTro = NhaTro.builder().id(nhaTroId).build();
        
        CauHinhGia oldEntity = CauHinhGia.builder()
                .id(id)
                .nhaTro(nhaTro)
                .loai(LoaiMucHoaDon.ELECTRICITY)
                .hieuLucTu(LocalDate.of(2026, 1, 1))
                .dangApDung(true)
                .donGia(BigDecimal.valueOf(3000))
                .build();

        when(cauHinhGiaRepository.findById(id)).thenReturn(Optional.of(oldEntity));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.canWriteNhaTro(userId, nhaTroId, null)).thenReturn(true);
        when(cauHinhGiaRepository.save(any(CauHinhGia.class))).thenAnswer(i -> i.getArgument(0));

        CauHinhGiaRequest req = new CauHinhGiaRequest();
        req.setDonGia(BigDecimal.valueOf(3500));
        req.setHieuLucTu(LocalDate.of(2026, 6, 1));

        CauHinhGiaResponse res = service.update(id, req);
        
        assertEquals(BigDecimal.valueOf(3500), res.getDonGia());
        assertEquals(LocalDate.of(2026, 6, 1), res.getHieuLucTu());
        // Verify old entity was deactivated
        assertEquals(false, oldEntity.getDangApDung());
        assertEquals(LocalDate.of(2026, 5, 31), oldEntity.getHieuLucDen());
    }
    @Test
    void getByIdRequiresReadPermission() {
        UUID id = UUID.randomUUID();
        UUID nhaTroId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        UUID ownerId = UUID.randomUUID();
        CauHinhGia entity = CauHinhGia.builder()
                .id(id)
                .nhaTro(NhaTro.builder().id(nhaTroId).chuTro(NguoiDung.builder().id(ownerId).build()).build())
                .build();
        when(cauHinhGiaRepository.findById(id)).thenReturn(Optional.of(entity));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.canReadNhaTro(userId, nhaTroId, ownerId)).thenReturn(false);

        assertThrows(RuntimeException.class, () -> service.getById(id));
    }

    @Test
    void getApplicableRequiresReadPermission() {
        UUID nhaTroId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        UUID ownerId = UUID.randomUUID();
        NhaTro nhaTro = NhaTro.builder().id(nhaTroId).chuTro(NguoiDung.builder().id(ownerId).build()).build();
        when(nhaTroRepository.findById(nhaTroId)).thenReturn(Optional.of(nhaTro));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.canReadNhaTro(userId, nhaTroId, ownerId)).thenReturn(false);

        assertThrows(RuntimeException.class, () -> service.getApplicable(nhaTroId, "ELECTRICITY", LocalDate.now()));
    }
}
