package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import com.example.quanlyphongtro.dto.*;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;

@ExtendWith(MockitoExtension.class)
class InvoiceGenerationServiceTest {

    @Mock private NguoiDungRepository nguoiDungRepository;
    @Mock private HopDongRepository hopDongRepository;
    @Mock private HoaDonRepository hoaDonRepository;
    @Mock private ChiSoDienNuocRepository chiSoDienNuocRepository;
    @Mock private DichVuHopDongRepository dichVuHopDongRepository;
    @Mock private ThanhVienHopDongRepository thanhVienHopDongRepository;
    @Mock private CauHinhGiaRepository cauHinhGiaRepository;
    @Mock private NhaTroRepository nhaTroRepository;
    @Mock private InvoiceGenerationBatchRepository invoiceGenerationBatchRepository;
    @Mock private InvoiceGenerationLogRepository invoiceGenerationLogRepository;
    @Mock private HoaDonService hoaDonService;
    @Mock private PermissionService permissionService;

    @InjectMocks private InvoiceGenerationService service;

    private UUID userId;
    private UUID nhaTroId;
    private HopDong activeContract;
    private Phong phong;
    private NhaTro nhaTro;

    @BeforeEach
    void setUp() {
        userId = UUID.randomUUID();
        nhaTroId = UUID.randomUUID();

        nhaTro = NhaTro.builder()
                .id(nhaTroId)
                .ten("Tòa nhà Test")
                .build();

        phong = Phong.builder()
                .id(UUID.randomUUID())
                .ten("Phong 101")
                .nhaTro(nhaTro)
                .build();

        activeContract = HopDong.builder()
                .id(UUID.randomUUID())
                .maHopDong("HD-TEST")
                .phong(phong)
                .trangThai(TrangThaiHopDong.ACTIVE)
                .giaThueHopDong(BigDecimal.valueOf(3000000))
                .build();
    }

    @Test
    void previewRequiresCurrentUserId() {
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.getAllAccessibleNhaTroIds(userId)).thenReturn(List.of(nhaTroId));
        when(permissionService.isAdmin(userId)).thenReturn(false);
        when(hopDongRepository.findAllActive()).thenReturn(List.of(activeContract));

        InvoiceGenerationPreviewResponse response = service.preview(nhaTroId, 6, 2026, false);

        assertNotNull(response);
        assertEquals(6, response.getKyThang());
        assertEquals(2026, response.getKyNam());
        assertEquals(1, response.getTongHopDong());
        assertEquals(1, response.getTongReady());
        assertEquals(0, response.getCandidates().stream().filter(c -> "EXISTS".equals(c.getStatus())).count());
    }

    @Test
    void previewIdentifiesExistsWhenInvoiceAlreadyCreated() {
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.getAllAccessibleNhaTroIds(userId)).thenReturn(List.of(nhaTroId));
        when(permissionService.isAdmin(userId)).thenReturn(false);
        when(hopDongRepository.findAllActive()).thenReturn(List.of(activeContract));

        // Mock invoice already exists
        HoaDon existingInvoice = HoaDon.builder()
                .id(UUID.randomUUID())
                .build();
        when(hoaDonRepository.findByHopDongIdAndKyNamAndKyThangAndXoaLucIsNull(activeContract.getId(), 2026, 6))
                .thenReturn(Optional.of(existingInvoice));

        InvoiceGenerationPreviewResponse response = service.preview(nhaTroId, 6, 2026, false);

        assertNotNull(response);
        assertEquals(1, response.getTongHopDong());
        assertEquals(0, response.getTongReady());
        InvoiceCandidateResponse candidate = response.getCandidates().get(0);
        assertEquals("EXISTS", candidate.getStatus());
        assertTrue(candidate.getWarnings().get(0).contains("đã có hóa đơn"));
    }

    @Test
    void previewProratesRentForAContractStartingDuringTheBillingMonth() {
        activeContract.setNgayBatDau(LocalDate.of(2026, 6, 20));
        activeContract.setNgayKetThuc(LocalDate.of(2026, 12, 31));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.getAllAccessibleNhaTroIds(userId)).thenReturn(List.of(nhaTroId));
        when(permissionService.isAdmin(userId)).thenReturn(false);
        when(hopDongRepository.findAllActive()).thenReturn(List.of(activeContract));
        when(hoaDonRepository.findByHopDongIdAndKyNamAndKyThangAndXoaLucIsNull(activeContract.getId(), 2026, 6))
                .thenReturn(Optional.empty());
        when(dichVuHopDongRepository.findByHopDongIdOrderByTaoLucAsc(activeContract.getId())).thenReturn(List.of());
        when(hoaDonRepository.findByHopDongIdAndXoaLucIsNull(activeContract.getId())).thenReturn(List.of());

        InvoiceGenerationPreviewResponse response = service.preview(nhaTroId, 6, 2026, false);

        assertEquals(new BigDecimal("1100000.00"), response.getCandidates().get(0).getEstimatedAmount());
    }

    @Test
    void generateSkipsExistingInvoicesAndRunsCompleted() {
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        NguoiDung admin = NguoiDung.builder().id(userId).hoTen("Admin").build();
        when(nguoiDungRepository.findById(userId)).thenReturn(Optional.of(admin));
        
        when(permissionService.getAllAccessibleNhaTroIds(userId)).thenReturn(List.of(nhaTroId));
        when(permissionService.isAdmin(userId)).thenReturn(false);
        when(hopDongRepository.findAllActive()).thenReturn(List.of(activeContract));
        when(hopDongRepository.findById(activeContract.getId())).thenReturn(Optional.of(activeContract));

        // Mock existing invoice to trigger skipped
        HoaDon existingInvoice = HoaDon.builder()
                .id(UUID.randomUUID())
                .build();
        when(hoaDonRepository.findByHopDongIdAndKyNamAndKyThangAndXoaLucIsNull(activeContract.getId(), 2026, 6))
                .thenReturn(Optional.of(existingInvoice));

        InvoiceGenerationBatch batch = InvoiceGenerationBatch.builder()
                .id(UUID.randomUUID())
                .build();
        when(invoiceGenerationBatchRepository.save(any(InvoiceGenerationBatch.class))).thenReturn(batch);

        InvoiceGenerationRequest request = InvoiceGenerationRequest.builder()
                .nhaTroId(nhaTroId)
                .kyThang(6)
                .kyNam(2026)
                .requireConfirmedReadings(false)
                .sendNotification(false)
                .build();

        InvoiceGenerationResultResponse response = service.generate(request);

        assertNotNull(response);
        assertEquals(0, response.getCreatedCount());
        assertEquals(1, response.getSkippedCount());
        assertEquals(0, response.getErrorCount());
        verify(invoiceGenerationBatchRepository, times(2)).save(any(InvoiceGenerationBatch.class));
        verify(invoiceGenerationLogRepository, times(1)).save(any(InvoiceGenerationLog.class));
    }
}
