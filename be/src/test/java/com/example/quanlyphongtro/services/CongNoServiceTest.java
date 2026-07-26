package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.CongNoResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.TrangThaiHoaDon;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import com.example.quanlyphongtro.repository.ChiTietHoaDonRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageRequest;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CongNoServiceTest {

    @Mock private HoaDonRepository hoaDonRepository;
    @Mock private ChiTietHoaDonRepository chiTietHoaDonRepository;
    @Mock private PermissionService permissionService;

    @InjectMocks
    private CongNoService service;

    private HoaDon overdueInvoice;
    private HoaDon currentInvoice;

    @BeforeEach
    void setUp() {
        UUID userId = UUID.randomUUID();
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.getAllAccessibleNhaTroIds(userId)).thenReturn(null);
        when(chiTietHoaDonRepository.findByHoaDonId(any(UUID.class))).thenReturn(List.of());

        overdueInvoice = invoice("P101", "Nguyen Van An", BigDecimal.valueOf(3_000_000), LocalDate.now().minusDays(2));
        currentInvoice = invoice("P202", "Le Thi Binh", BigDecimal.valueOf(2_000_000), LocalDate.now().plusDays(5));
        when(hoaDonRepository.findByXoaLucIsNullOrderByTaoLucDesc())
                .thenReturn(List.of(overdueInvoice, currentInvoice));
    }

    @Test
    void getTongNoFiltersBySearchBeforePagination() {
        PaginatedResponse<CongNoResponse> result =
                service.getTongNo(PageRequest.of(0, 10), "nguyen van", false);

        assertEquals(1, result.getTotal());
        assertEquals("P101", result.getData().get(0).getMaPhong());
    }

    @Test
    void getTongNoReturnsOnlyOverdueRoomsWhenRequested() {
        PaginatedResponse<CongNoResponse> result =
                service.getTongNo(PageRequest.of(0, 10), null, true);

        assertEquals(1, result.getTotal());
        assertEquals("P101", result.getData().get(0).getMaPhong());
        assertEquals(BigDecimal.valueOf(3_000_000), result.getData().get(0).getNoQuaHan());
    }

    private HoaDon invoice(String roomName, String tenantName, BigDecimal amount, LocalDate dueDate) {
        NhaTro nhaTro = NhaTro.builder()
                .id(UUID.randomUUID())
                .ten("Nhà trọ " + roomName)
                .diaChi("Quận 1")
                .build();
        Phong phong = Phong.builder()
                .id(UUID.randomUUID())
                .nhaTro(nhaTro)
                .ten(roomName)
                .dienTich(BigDecimal.valueOf(20))
                .soNguoiToiDa(2)
                .trangThai(TrangThaiPhong.RENTED)
                .giaHienTai(amount)
                .tienCocMacDinh(BigDecimal.ZERO)
                .build();
        KhachThue khachThue = KhachThue.builder()
                .id(UUID.randomUUID())
                .hoTen(tenantName)
                .soDienThoai("0900000000")
                .dangHoatDong(true)
                .build();
        HopDong hopDong = HopDong.builder()
                .id(UUID.randomUUID())
                .phong(phong)
                .khachThue(khachThue)
                .build();

        return HoaDon.builder()
                .id(UUID.randomUUID())
                .hopDong(hopDong)
                .phong(phong)
                .khachThue(khachThue)
                .maHoaDon("HD-" + roomName)
                .kyNam(2026)
                .kyThang(5)
                .tongTien(amount)
                .daTra(BigDecimal.ZERO)
                .trangThai(TrangThaiHoaDon.UNPAID)
                .hanTra(dueDate)
                .build();
    }
}
