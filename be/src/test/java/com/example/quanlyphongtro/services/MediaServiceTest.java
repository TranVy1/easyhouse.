package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.entity.ChiSoDienNuoc;
import com.example.quanlyphongtro.entity.FileMedia;
import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.entity.LoaiDoiTuongMedia;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.SuCo;
import com.example.quanlyphongtro.entity.ThanhToan;
import com.example.quanlyphongtro.repository.AuditLogRepository;
import com.example.quanlyphongtro.repository.ChiSoDienNuocRepository;
import com.example.quanlyphongtro.repository.FileMediaRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.SuCoRepository;
import com.example.quanlyphongtro.repository.ThanhToanRepository;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockMultipartFile;

@ExtendWith(MockitoExtension.class)
class MediaServiceTest {

    @Mock private FileMediaRepository fileMediaRepository;
    @Mock private CloudinaryService cloudinaryService;
    @Mock private NguoiDungRepository nguoiDungRepository;
    @Mock private PermissionService permissionService;
    @Mock private PhongRepository phongRepository;
    @Mock private ChiSoDienNuocRepository chiSoDienNuocRepository;
    @Mock private ThanhToanRepository thanhToanRepository;
    @Mock private SuCoRepository suCoRepository;
    @Mock private AuditLogRepository auditLogRepository;

    @InjectMocks
    private FileMediaService service;

    @BeforeEach
    void setUp() {
    }

    @Test
    void getByDoiTuongThrowsWhenCannotReadRoom() {
        UUID userId = UUID.randomUUID();
        UUID roomId = UUID.randomUUID();

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.canReadPhong(userId, roomId)).thenReturn(false);

        RuntimeException err = assertThrows(RuntimeException.class, () -> service.getByDoiTuong("ROOM", roomId));
        assertEquals("Khong co quyen", err.getMessage());
    }

    @Test
    void deleteFileThrowsWhenCannotWriteRoom() {
        UUID id = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        UUID roomId = UUID.randomUUID();

        FileMedia file = new FileMedia();
        file.setId(id);
        file.setDoiTuong(LoaiDoiTuongMedia.ROOM);
        file.setDoiTuongId(roomId);

        when(fileMediaRepository.findById(id)).thenReturn(Optional.of(file));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.canWritePhong(userId, roomId)).thenReturn(false);

        RuntimeException err = assertThrows(RuntimeException.class, () -> service.deleteFile(id));
        assertEquals("Khong co quyen", err.getMessage());
    }

    @Test
    void getByDoiTuongThrowsWhenCannotReadMeterReadingRoom() {
        UUID userId = UUID.randomUUID();
        UUID readingId = UUID.randomUUID();
        UUID roomId = UUID.randomUUID();
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(chiSoDienNuocRepository.findById(readingId))
                .thenReturn(Optional.of(ChiSoDienNuoc.builder().phong(Phong.builder().id(roomId).build()).build()));
        when(permissionService.canReadPhong(userId, roomId)).thenReturn(false);

        RuntimeException err = assertThrows(RuntimeException.class,
                () -> service.getByDoiTuong("METER_READING", readingId));
        assertEquals("Khong co quyen", err.getMessage());
    }

    @Test
    void uploadPaymentMediaUsesPrincipalAndWritesAudit() throws Exception {
        UUID userId = UUID.randomUUID();
        UUID requestUserId = UUID.randomUUID();
        UUID paymentId = UUID.randomUUID();
        UUID invoiceId = UUID.randomUUID();
        NguoiDung principal = NguoiDung.builder().id(userId).build();
        MockMultipartFile file = new MockMultipartFile("file", "receipt.png", "image/png", new byte[] { 1 });

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(thanhToanRepository.findById(paymentId))
                .thenReturn(Optional.of(ThanhToan.builder().hoaDon(HoaDon.builder().id(invoiceId).build()).build()));
        when(permissionService.canWriteHoaDon(userId, invoiceId)).thenReturn(true);
        when(cloudinaryService.uploadFile(file))
                .thenReturn(Map.of("secure_url", "https://example.test/receipt.png", "public_id", "receipt"));
        when(nguoiDungRepository.findById(userId)).thenReturn(Optional.of(principal));
        when(fileMediaRepository.save(any(FileMedia.class))).thenAnswer(invocation -> {
            FileMedia media = invocation.getArgument(0);
            media.setId(UUID.randomUUID());
            return media;
        });

        service.uploadFile(file, "PAYMENT", paymentId, null, requestUserId);

        verify(fileMediaRepository).save(org.mockito.ArgumentMatchers.argThat(
                media -> media.getNguoiTaiLen().getId().equals(userId)));
        verify(auditLogRepository).save(any());
    }

    @Test
    void uploadFileThrowsWhenCannotWriteRoom() {
        UUID userId = UUID.randomUUID();
        UUID roomId = UUID.randomUUID();
        MockMultipartFile file = new MockMultipartFile("file", "test.png", "image/png", new byte[] { 1 });

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.canWritePhong(userId, roomId)).thenReturn(false);

        RuntimeException err = assertThrows(RuntimeException.class,
                () -> service.uploadFile(file, "ROOM", roomId, null, null));
        assertEquals("Khong co quyen", err.getMessage());
    }

    @Test
    void uploadMeterReadingThrowsWhenCannotWriteRoom() {
        UUID userId = UUID.randomUUID();
        UUID readingId = UUID.randomUUID();
        UUID roomId = UUID.randomUUID();
        MockMultipartFile file = new MockMultipartFile("file", "meter.png", "image/png", new byte[] { 1 });

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(chiSoDienNuocRepository.findById(readingId))
                .thenReturn(Optional.of(ChiSoDienNuoc.builder().phong(Phong.builder().id(roomId).build()).build()));
        when(permissionService.canWritePhong(userId, roomId)).thenReturn(false);

        RuntimeException err = assertThrows(RuntimeException.class,
                () -> service.uploadFile(file, "METER_READING", readingId, null, null));
        assertEquals("Khong co quyen", err.getMessage());
    }

    @Test
    void getByDoiTuongThrowsWhenCannotReadPaymentInvoice() {
        UUID userId = UUID.randomUUID();
        UUID paymentId = UUID.randomUUID();
        UUID invoiceId = UUID.randomUUID();

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(thanhToanRepository.findById(paymentId))
                .thenReturn(Optional.of(ThanhToan.builder().hoaDon(HoaDon.builder().id(invoiceId).build()).build()));
        when(permissionService.canReadHoaDon(userId, invoiceId)).thenReturn(false);

        RuntimeException err = assertThrows(RuntimeException.class,
                () -> service.getByDoiTuong("PAYMENT", paymentId));
        assertEquals("Khong co quyen", err.getMessage());
    }

    @Test
    void deletePaymentThrowsWhenCannotWriteInvoice() {
        UUID fileId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        UUID paymentId = UUID.randomUUID();
        UUID invoiceId = UUID.randomUUID();
        FileMedia file = new FileMedia();
        file.setId(fileId);
        file.setDoiTuong(LoaiDoiTuongMedia.PAYMENT);
        file.setDoiTuongId(paymentId);

        when(fileMediaRepository.findById(fileId)).thenReturn(Optional.of(file));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(thanhToanRepository.findById(paymentId))
                .thenReturn(Optional.of(ThanhToan.builder().hoaDon(HoaDon.builder().id(invoiceId).build()).build()));
        when(permissionService.canWriteHoaDon(userId, invoiceId)).thenReturn(false);

        RuntimeException err = assertThrows(RuntimeException.class, () -> service.deleteFile(fileId));
        assertEquals("Khong co quyen", err.getMessage());
    }

    @Test
    void getByDoiTuongThrowsWhenCannotReadIncidentRoom() {
        UUID userId = UUID.randomUUID();
        UUID incidentId = UUID.randomUUID();
        UUID roomId = UUID.randomUUID();

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(suCoRepository.findById(incidentId))
                .thenReturn(Optional.of(SuCo.builder().phong(Phong.builder().id(roomId).build()).build()));
        when(permissionService.canReadPhong(userId, roomId)).thenReturn(false);

        RuntimeException err = assertThrows(RuntimeException.class,
                () -> service.getByDoiTuong("INCIDENT", incidentId));
        assertEquals("Khong co quyen", err.getMessage());
    }

    @Test
    void uploadIncidentThrowsWhenCannotWriteRoom() {
        UUID userId = UUID.randomUUID();
        UUID incidentId = UUID.randomUUID();
        UUID roomId = UUID.randomUUID();
        MockMultipartFile file = new MockMultipartFile("file", "incident.png", "image/png", new byte[] { 1 });

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(suCoRepository.findById(incidentId))
                .thenReturn(Optional.of(SuCo.builder().phong(Phong.builder().id(roomId).build()).build()));
        when(permissionService.canWritePhong(userId, roomId)).thenReturn(false);

        RuntimeException err = assertThrows(RuntimeException.class,
                () -> service.uploadFile(file, "INCIDENT", incidentId, null, null));
        assertEquals("Khong co quyen", err.getMessage());
    }

    @Test
    void deleteIncidentThrowsWhenCannotWriteRoom() {
        UUID fileId = UUID.randomUUID();
        UUID userId = UUID.randomUUID();
        UUID incidentId = UUID.randomUUID();
        UUID roomId = UUID.randomUUID();
        FileMedia file = new FileMedia();
        file.setId(fileId);
        file.setDoiTuong(LoaiDoiTuongMedia.INCIDENT);
        file.setDoiTuongId(incidentId);

        when(fileMediaRepository.findById(fileId)).thenReturn(Optional.of(file));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(suCoRepository.findById(incidentId))
                .thenReturn(Optional.of(SuCo.builder().phong(Phong.builder().id(roomId).build()).build()));
        when(permissionService.canWritePhong(userId, roomId)).thenReturn(false);

        RuntimeException err = assertThrows(RuntimeException.class, () -> service.deleteFile(fileId));
        assertEquals("Khong co quyen", err.getMessage());
    }
}
