package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.entity.FileMedia;
import com.example.quanlyphongtro.entity.LoaiDoiTuongMedia;
import com.example.quanlyphongtro.repository.FileMediaRepository;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class MediaServiceTest {

    @Mock private FileMediaRepository fileMediaRepository;
    @Mock private CloudinaryService cloudinaryService;
    @Mock private PermissionService permissionService;

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
}
