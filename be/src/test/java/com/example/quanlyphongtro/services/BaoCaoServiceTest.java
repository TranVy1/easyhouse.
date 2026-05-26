package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.BaoCaoTongQuanResponse;
import com.example.quanlyphongtro.dto.DoanhThuTheoThang;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.SuCoRepository;
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

@ExtendWith(MockitoExtension.class)
class BaoCaoServiceTest {

    @Mock private HoaDonRepository hoaDonRepository;
    @Mock private PhongRepository phongRepository;
    @Mock private SuCoRepository suCoRepository;
    @Mock private HopDongRepository hopDongRepository;
    @Mock private PermissionService permissionService;

    @InjectMocks
    private BaoCaoService service;

    @BeforeEach
    void setUp() {
    }

    @Test
    void getTongQuanScopedByUser() {
        UUID userId = UUID.randomUUID();
        UUID nhaTroId = UUID.randomUUID();
        List<UUID> nhaTroIds = List.of(nhaTroId);

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.getAllAccessibleNhaTroIds(userId)).thenReturn(nhaTroIds);
        
        LocalDate today = LocalDate.now();
        DoanhThuTheoThang mockDoanhThu = new DoanhThuTheoThang() {
            @Override
            public Integer getNam() { return today.getYear(); }
            @Override
            public Integer getThang() { return today.getMonthValue(); }
            @Override
            public BigDecimal getDoanhThu() { return BigDecimal.valueOf(10000000); }
            @Override
            public BigDecimal getDaThu() { return BigDecimal.valueOf(8000000); }
        };

        when(hoaDonRepository.getDoanhThuThongKeAndNhaTroIdIn(anyInt(), anyInt(), anyList()))
                .thenReturn(List.of(mockDoanhThu));
        
        when(phongRepository.countByNhaTroIdIn(nhaTroIds)).thenReturn(10L);
        when(phongRepository.countByTrangThaiAndNhaTroIdIn(TrangThaiPhong.RENTED, nhaTroIds)).thenReturn(8L);

        BaoCaoTongQuanResponse res = service.getTongQuan();
        
        assertNotNull(res);
        assertEquals(BigDecimal.valueOf(10000000), res.getDoanhThu());
        assertEquals(BigDecimal.valueOf(8000000), res.getTienDaThu());
        assertEquals(BigDecimal.valueOf(2000000), res.getTienChuaThu()); // 10m - 8m = 2m
        assertEquals(80.0, res.getTyLeLapDay()); // 8 / 10 = 80%

        verify(phongRepository).countByNhaTroIdIn(nhaTroIds);
        verify(hoaDonRepository).getDoanhThuThongKeAndNhaTroIdIn(anyInt(), anyInt(), anyList());
    }

    @Test
    void getTongQuanEmptyWhenNoProperties() {
        UUID userId = UUID.randomUUID();

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.getAllAccessibleNhaTroIds(userId)).thenReturn(List.of());
        
        BaoCaoTongQuanResponse res = service.getTongQuan();
        
        assertNotNull(res);
        assertEquals(BigDecimal.ZERO, res.getDoanhThu());
        assertEquals(0.0, res.getTyLeLapDay());
    }
}
