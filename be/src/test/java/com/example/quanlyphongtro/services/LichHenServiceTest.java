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
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import com.example.quanlyphongtro.repository.LichHenRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.AuditLogRepository;
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
    @Mock private AuditLogRepository auditLogRepository;
    @Mock private ThongBaoService thongBaoService;
    @Mock private EmailService emailService;
    @Mock private MediaService mediaService;

    @InjectMocks
    private LichHenService service;

    @BeforeEach
    void setUp() {
    }

    @Test
    void createIsPublicAndDoesNotRequireAuth() {
        UUID phongId = UUID.randomUUID();
        Phong phong = Phong.builder().id(phongId).trangThai(TrangThaiPhong.AVAILABLE).build();

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
        req.setTrangThai("CONFIRMED");

        LichHenResponse res = service.create(req);
        
        assertEquals("Guest", res.getHoTen());
        assertEquals("PENDING", res.getTrangThai());
        verify(permissionService, org.mockito.Mockito.never()).requireCurrentUserId();
        verify(auditLogRepository).save(any());
    }

    @Test
    void createRejectsHoneypotSubmission() {
        LichHenRequest req = new LichHenRequest();
        req.setHoneypot("filled-by-bot");

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.create(req, "127.0.0.1"));

        assertEquals("Yeu cau dat lich khong hop le", error.getMessage());
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

    @Test
    void updateRejectsInvalidStatusTransition() {
        UUID id = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        UUID phongId = UUID.randomUUID();
        LichHen lichHen = new LichHen();
        lichHen.setId(id);
        lichHen.setPhong(Phong.builder().id(phongId).build());
        lichHen.setTrangThai(TrangThaiLichHen.PENDING);

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(lichHenRepository.findById(id)).thenReturn(Optional.of(lichHen));
        when(permissionService.canWritePhong(userId, phongId)).thenReturn(true);

        LichHenRequest request = new LichHenRequest();
        request.setTrangThai("COMPLETED");
        RuntimeException error = assertThrows(RuntimeException.class, () -> service.update(id, request));
        assertEquals("Chuyen trang thai lich hen khong hop le", error.getMessage());
    }

    @Test
    void updateRejectsMovingAppointmentToUnauthorizedRoom() {
        UUID id = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        UUID oldRoomId = UUID.randomUUID();
        UUID newRoomId = UUID.randomUUID();
        LichHen lichHen = new LichHen();
        lichHen.setId(id);
        lichHen.setPhong(Phong.builder().id(oldRoomId).build());

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(lichHenRepository.findById(id)).thenReturn(Optional.of(lichHen));
        when(permissionService.canWritePhong(userId, oldRoomId)).thenReturn(true);
        when(permissionService.canWritePhong(userId, newRoomId)).thenReturn(false);

        LichHenRequest request = new LichHenRequest();
        request.setPhongId(newRoomId);
        RuntimeException error = assertThrows(RuntimeException.class, () -> service.update(id, request));
        assertEquals("Khong co quyen chuyen lich hen sang phong nay", error.getMessage());
    }
}
