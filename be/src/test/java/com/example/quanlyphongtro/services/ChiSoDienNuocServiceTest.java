package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.ChiSoDienNuocRequest;
import com.example.quanlyphongtro.dto.ChiSoDienNuocResponse;
import com.example.quanlyphongtro.entity.ChiSoDienNuoc;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.TrangThaiChiSo;
import com.example.quanlyphongtro.repository.ChiSoDienNuocRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import java.time.LocalDate;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class ChiSoDienNuocServiceTest {

    @Mock private ChiSoDienNuocRepository chiSoDienNuocRepository;
    @Mock private PhongRepository phongRepository;
    @Mock private HopDongRepository hopDongRepository;
    @Mock private MediaService mediaService;
    @Mock private PermissionService permissionService;

    @InjectMocks
    private ChiSoDienNuocService service;

    @BeforeEach
    void setUp() {
    }

    @Test
    void updateThrowsWhenBilledAndNotCancelled() {
        UUID id = UUID.randomUUID();
        ChiSoDienNuoc existing = new ChiSoDienNuoc();
        existing.setId(id);
        existing.setTrangThai(TrangThaiChiSo.BILLED);

        when(chiSoDienNuocRepository.findById(id)).thenReturn(Optional.of(existing));

        ChiSoDienNuocRequest req = new ChiSoDienNuocRequest();
        req.setTrangThai(TrangThaiChiSo.CONFIRMED);

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.update(id, req));
        assertEquals("Không thể sửa chỉ số đã được lập hóa đơn", error.getMessage());
    }

    @Test
    void updateAllowsCancelWhenBilled() {
        UUID id = UUID.randomUUID();
        ChiSoDienNuoc existing = new ChiSoDienNuoc();
        existing.setId(id);
        existing.setTrangThai(TrangThaiChiSo.BILLED);
        existing.setChiSoCu(100);
        existing.setChiSoMoi(150);
        existing.setPhong(Phong.builder().id(UUID.randomUUID()).build());

        when(chiSoDienNuocRepository.findById(id)).thenReturn(Optional.of(existing));
        when(chiSoDienNuocRepository.save(any())).thenAnswer(i -> i.getArgument(0));

        ChiSoDienNuocRequest req = new ChiSoDienNuocRequest();
        req.setTrangThai(TrangThaiChiSo.CANCELLED);
        req.setChiSoCu(100);
        req.setChiSoMoi(150);

        ChiSoDienNuocResponse res = service.update(id, req);
        assertEquals(TrangThaiChiSo.CANCELLED, res.getTrangThai());
    }

    @Test
    void createThrowsWhenChiSoMoiLessThanChiSoCu() {
        UUID phongId = UUID.randomUUID();
        Phong phong = Phong.builder().id(phongId).build();

        when(phongRepository.findById(phongId)).thenReturn(Optional.of(phong));

        ChiSoDienNuocRequest req = new ChiSoDienNuocRequest();
        req.setPhongId(phongId);
        req.setChiSoCu(150);
        req.setChiSoMoi(100); // Invalid

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.create(req));
        assertEquals("Chỉ số mới phải lớn hơn hoặc bằng chỉ số cũ", error.getMessage());
    }
}
