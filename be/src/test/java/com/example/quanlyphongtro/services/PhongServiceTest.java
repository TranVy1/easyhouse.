package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class PhongServiceTest {

    @Mock private PhongRepository phongRepository;
    @Mock private NhaTroRepository nhaTroRepository;
    @Mock private HopDongRepository hopDongRepository;
    @Mock private MediaService mediaService;
    @Mock private TienIchService tienIchService;
    @Mock private PermissionService permissionService;

    private PhongService service;

    @BeforeEach
    void setUp() {
        service = new PhongService(
                phongRepository, nhaTroRepository, hopDongRepository,
                mediaService, tienIchService, permissionService);
    }

    @Test
    void publicDetailRejectsSoftDeletedRoom() {
        UUID phongId = UUID.randomUUID();
        when(phongRepository.findByIdAndXoaLucIsNull(phongId)).thenReturn(Optional.empty());

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.getPublicPhongById(phongId));

        assertEquals("Khong tim thay phong", error.getMessage());
    }
}
