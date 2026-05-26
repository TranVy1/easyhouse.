package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.LichHenRequest;
import com.example.quanlyphongtro.dto.LichHenResponse;
import com.example.quanlyphongtro.entity.LichHen;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.TrangThaiLichHen;
import com.example.quanlyphongtro.repository.LichHenRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import java.time.ZonedDateTime;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class LichHenServiceTest {

    @Mock private LichHenRepository lichHenRepository;
    @Mock private PhongRepository phongRepository;
    @Mock private PermissionService permissionService;

    @InjectMocks
    private LichHenService service;

    @BeforeEach
    void setUp() {
    }

    @Test
    void createIsPublicAndDoesNotRequireAuth() {
        UUID phongId = UUID.randomUUID();
        Phong phong = Phong.builder().id(phongId).build();

        when(phongRepository.findById(phongId)).thenReturn(Optional.of(phong));
        when(lichHenRepository.save(any(LichHen.class))).thenAnswer(i -> {
            LichHen lh = i.getArgument(0);
            lh.setId(UUID.randomUUID());
            return lh;
        });

        LichHenRequest req = new LichHenRequest();
        req.setPhongId(phongId);
        req.setHoTen("Guest");
        req.setSoDienThoai("0900000000");
        req.setNgayHen(ZonedDateTime.now().plusDays(1));

        LichHenResponse res = service.create(req);
        
        assertEquals("Guest", res.getHoTen());
        assertEquals("PENDING", res.getTrangThai());
        // Verify no auth check is made
        verify(permissionService, org.mockito.Mockito.never()).requireCurrentUserId();
    }

    @Test
    void getByIdThrowsWhenUserCannotWritePhong() {
        UUID id = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        UUID phongId = UUID.randomUUID();
        
        LichHen lichHen = new LichHen();
        lichHen.setId(id);
        lichHen.setPhong(Phong.builder().id(phongId).build());

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(lichHenRepository.findById(id)).thenReturn(Optional.of(lichHen));
        when(permissionService.canWritePhong(userId, phongId)).thenReturn(false);

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.getById(id));
        assertEquals("Khong co quyen xem lich hen nay", error.getMessage());
    }

    @Test
    void updateThrowsWhenUserCannotWritePhong() {
        UUID id = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        UUID phongId = UUID.randomUUID();
        
        LichHen lichHen = new LichHen();
        lichHen.setId(id);
        lichHen.setPhong(Phong.builder().id(phongId).build());

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(lichHenRepository.findById(id)).thenReturn(Optional.of(lichHen));
        when(permissionService.canWritePhong(userId, phongId)).thenReturn(false);

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.update(id, new LichHenRequest()));
        assertEquals("Khong co quyen cap nhat lich hen nay", error.getMessage());
    }
}
