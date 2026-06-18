package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.HopDongRequest;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.repository.CauHinhGiaRepository;
import com.example.quanlyphongtro.repository.DichVuHopDongRepository;
import com.example.quanlyphongtro.repository.DichVuRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.ThanhVienHopDongRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;

@ExtendWith(MockitoExtension.class)
class HopDongServiceTest {

    @Mock private HopDongRepository hopDongRepository;
    @Mock private PhongRepository phongRepository;
    @Mock private KhachThueRepository khachThueRepository;
    @Mock private ThanhVienHopDongRepository thanhVienHopDongRepository;
    @Mock private DichVuHopDongRepository dichVuHopDongRepository;
    @Mock private DichVuRepository dichVuRepository;
    @Mock private CauHinhGiaRepository cauHinhGiaRepository;
    @Mock private HoaDonRepository hoaDonRepository;
    @Mock private PermissionService permissionService;
    @Mock private JdbcTemplate jdbcTemplate;

    private HopDongService service;

    @BeforeEach
    void setUp() {
        service = new HopDongService(
                hopDongRepository,
                phongRepository,
                khachThueRepository,
                thanhVienHopDongRepository,
                dichVuHopDongRepository,
                dichVuRepository,
                cauHinhGiaRepository,
                hoaDonRepository,
                permissionService,
                jdbcTemplate
        );
    }

    @Test
    void getByIdRejectsUnauthorizedUser() {
        UUID userId = UUID.randomUUID();
        UUID ownerId = UUID.randomUUID();
        UUID nhaTroId = UUID.randomUUID();
        UUID hopDongId = UUID.randomUUID();
        NhaTro nhaTro = NhaTro.builder()
                .id(nhaTroId)
                .chuTro(NguoiDung.builder().id(ownerId).build())
                .build();
        HopDong hopDong = HopDong.builder()
                .id(hopDongId)
                .phong(Phong.builder().nhaTro(nhaTro).build())
                .khachThue(KhachThue.builder().build())
                .build();

        when(hopDongRepository.findById(hopDongId)).thenReturn(Optional.of(hopDong));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.isAdmin(userId)).thenReturn(false);
        when(permissionService.canReadNhaTro(userId, nhaTroId, ownerId)).thenReturn(false);

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.getById(hopDongId));
        assertEquals("Bạn không có quyền xem hợp đồng này", error.getMessage());
    }

    @Test
    void createRequiresWriteAccessToRoomBuilding() {
        UUID userId = UUID.randomUUID();
        UUID ownerId = UUID.randomUUID();
        UUID nhaTroId = UUID.randomUUID();
        UUID phongId = UUID.randomUUID();
        UUID khachThueId = UUID.randomUUID();
        NhaTro nhaTro = NhaTro.builder()
                .id(nhaTroId)
                .chuTro(NguoiDung.builder().id(ownerId).build())
                .build();
        Phong phong = Phong.builder()
                .id(phongId)
                .nhaTro(nhaTro)
                .build();
        HopDongRequest request = new HopDongRequest();
        request.setPhongId(phongId);
        request.setKhachThueId(khachThueId);

        when(phongRepository.findById(phongId)).thenReturn(Optional.of(phong));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.canWriteNhaTro(userId, nhaTroId, ownerId)).thenReturn(false);

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.create(request));
        assertEquals("Bạn không có quyền sửa hợp đồng trong nhà trọ này", error.getMessage());
    }

    @Test
    void getAllPassesBuildingAndNormalizedSearchToRepository() {
        UUID userId = UUID.randomUUID();
        UUID nhaTroId = UUID.randomUUID();
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.isAdmin(userId)).thenReturn(true);
        when(hopDongRepository.findAllAccessible(
                eq(true), eq(userId), org.mockito.ArgumentMatchers.<List<UUID>>any(), eq(null),
                eq(nhaTroId), eq("ACTIVE"), eq("HD-A01"), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of()));

        service.getAll(null, nhaTroId.toString(), "ACTIVE", " HD-A01 ", 1, 10);

        verify(hopDongRepository).findAllAccessible(
                eq(true), eq(userId), org.mockito.ArgumentMatchers.<List<UUID>>any(), eq(null),
                eq(nhaTroId), eq("ACTIVE"), eq("HD-A01"), any(Pageable.class));
    }
}
