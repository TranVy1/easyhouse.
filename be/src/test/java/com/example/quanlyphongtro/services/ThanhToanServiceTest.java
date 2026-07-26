package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.ThanhToanRequest;
import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.ThanhToan;
import com.example.quanlyphongtro.repository.ChiTietHoaDonRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.ThanhToanRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.mockito.ArgumentCaptor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class ThanhToanServiceTest {

    @Mock private ThanhToanRepository thanhToanRepository;
    @Mock private HoaDonRepository hoaDonRepository;
    @Mock private ChiTietHoaDonRepository chiTietHoaDonRepository;
    @Mock private HopDongRepository hopDongRepository;
    @Mock private MediaService mediaService;
    @Mock private PermissionService permissionService;
    @Mock private EmailService emailService;

    private ThanhToanService service;

    @BeforeEach
    void setUp() {
        service = new ThanhToanService(
                thanhToanRepository,
                hoaDonRepository,
                chiTietHoaDonRepository,
                hopDongRepository,
                mediaService,
                permissionService,
                emailService
        );
    }

    @Test
    void getByIdRejectsUnauthorizedUser() {
        UUID userId = UUID.randomUUID();
        UUID ownerId = UUID.randomUUID();
        UUID nhaTroId = UUID.randomUUID();
        UUID thanhToanId = UUID.randomUUID();
        HoaDon hoaDon = invoice(ownerId, nhaTroId, null);
        ThanhToan thanhToan = ThanhToan.builder()
                .id(thanhToanId)
                .hoaDon(hoaDon)
                .soTien(BigDecimal.valueOf(500_000))
                .ngayThanhToan(ZonedDateTime.now())
                .build();

        when(thanhToanRepository.findById(thanhToanId)).thenReturn(Optional.of(thanhToan));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.isAdmin(userId)).thenReturn(false);
        when(permissionService.canReadNhaTro(userId, nhaTroId, ownerId)).thenReturn(false);

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.getById(thanhToanId));
        assertEquals("Ban khong co quyen xem thanh toan nay", error.getMessage());
    }

    @Test
    void createRejectsTenantInvoiceOwner() {
        UUID tenantUserId = UUID.randomUUID();
        UUID ownerId = UUID.randomUUID();
        UUID nhaTroId = UUID.randomUUID();
        UUID hoaDonId = UUID.randomUUID();
        HoaDon hoaDon = invoice(ownerId, nhaTroId, tenantUserId);
        hoaDon.setId(hoaDonId);
        ThanhToanRequest request = new ThanhToanRequest();
        request.setHoaDonId(hoaDonId);
        request.setSoTien(BigDecimal.valueOf(500_000));

        when(hoaDonRepository.findById(hoaDonId)).thenReturn(Optional.of(hoaDon));
        when(permissionService.requireCurrentUserId()).thenReturn(tenantUserId);
        RuntimeException error = assertThrows(RuntimeException.class, () -> service.create(request));

        assertEquals("Ban khong co quyen sua thanh toan nay", error.getMessage());
    }

    @Test
    void getAllPassesNormalizedPaymentFiltersToRepository() {
        UUID userId = UUID.randomUUID();
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.isAdmin(userId)).thenReturn(true);
        when(thanhToanRepository.findAllAccessible(
                eq(true), eq(userId), eq(List.of()), isNull(), isNull(), eq("BANK_TRANSFER"),
                eq("HD-001"), any(ZonedDateTime.class), any(ZonedDateTime.class), any(Pageable.class)))
                .thenReturn(Page.empty());

        service.getAll(null, "all", "  HD-001 ", "chuyenKhoan", "2026-05-01", "2026-05-03", 1, 10);

        ArgumentCaptor<ZonedDateTime> from = ArgumentCaptor.forClass(ZonedDateTime.class);
        ArgumentCaptor<ZonedDateTime> to = ArgumentCaptor.forClass(ZonedDateTime.class);
        verify(thanhToanRepository).findAllAccessible(
                eq(true), eq(userId), eq(List.of()), isNull(), isNull(), eq("BANK_TRANSFER"),
                eq("HD-001"), from.capture(), to.capture(), any(Pageable.class));
        assertEquals(LocalDate.of(2026, 5, 1), from.getValue().toLocalDate());
        assertEquals(LocalDate.of(2026, 5, 4), to.getValue().toLocalDate());
    }

    @Test
    void getAllRejectsInvalidDateFilter() {
        UUID userId = UUID.randomUUID();
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.isAdmin(userId)).thenReturn(true);

        RuntimeException error = assertThrows(RuntimeException.class,
                () -> service.getAll(null, "all", null, "all", "khong-hop-le", null, 1, 10));

        assertEquals("Ngày lọc không hợp lệ: khong-hop-le", error.getMessage());
    }

    private HoaDon invoice(UUID ownerId, UUID nhaTroId, UUID tenantUserId) {
        NguoiDung owner = NguoiDung.builder().id(ownerId).build();
        NguoiDung tenantUser = tenantUserId != null ? NguoiDung.builder().id(tenantUserId).build() : null;
        KhachThue khachThue = KhachThue.builder()
                .id(UUID.randomUUID())
                .nguoiDung(tenantUser)
                .chuTro(owner)
                .build();
        NhaTro nhaTro = NhaTro.builder()
                .id(nhaTroId)
                .chuTro(owner)
                .build();
        return HoaDon.builder()
                .phong(Phong.builder().id(UUID.randomUUID()).nhaTro(nhaTro).build())
                .khachThue(khachThue)
                .tongTien(BigDecimal.valueOf(1_000_000))
                .hanTra(LocalDate.now().plusDays(5))
                .build();
    }
}
