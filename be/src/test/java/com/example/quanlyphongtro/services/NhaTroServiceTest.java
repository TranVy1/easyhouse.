package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.NhaTroRequest;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class NhaTroServiceTest {

    @Mock private NhaTroRepository nhaTroRepository;
    @Mock private PhongRepository phongRepository;
    @Mock private NguoiDungRepository nguoiDungRepository;
    @Mock private PermissionService permissionService;

    private NhaTroService service;

    @BeforeEach
    void setUp() {
        service = new NhaTroService(nhaTroRepository, phongRepository, nguoiDungRepository, permissionService);
    }

    @Test
    void createUsesAuthenticatedUserAsOwner() {
        UUID userId = UUID.randomUUID();
        NguoiDung owner = NguoiDung.builder().id(userId).email("owner@example.com").hoTen("Owner").build();
        NhaTroRequest request = new NhaTroRequest();
        request.setTenToaNha("Toa A");

        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(nguoiDungRepository.findById(userId)).thenReturn(Optional.of(owner));
        when(nhaTroRepository.save(org.mockito.ArgumentMatchers.any(NhaTro.class))).thenAnswer(invocation -> {
            NhaTro nhaTro = invocation.getArgument(0);
            nhaTro.setId(UUID.randomUUID());
            return nhaTro;
        });

        service.createNhaTro(request);

        verify(nhaTroRepository).save(org.mockito.ArgumentMatchers.argThat(nhaTro -> owner.equals(nhaTro.getChuTro())));
    }

    @Test
    void deleteRejectsBuildingWithActiveRooms() {
        UUID userId = UUID.randomUUID();
        UUID nhaTroId = UUID.randomUUID();
        NhaTro nhaTro = NhaTro.builder()
                .id(nhaTroId)
                .chuTro(NguoiDung.builder().id(userId).build())
                .build();

        when(nhaTroRepository.findById(nhaTroId)).thenReturn(Optional.of(nhaTro));
        when(permissionService.requireCurrentUserId()).thenReturn(userId);
        when(permissionService.canWriteNhaTro(userId, nhaTroId, userId)).thenReturn(true);
        when(phongRepository.countByNhaTroIdAndXoaLucIsNull(nhaTroId)).thenReturn(1L);

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.deleteNhaTro(nhaTroId));
        assertEquals("Khong the xoa nha tro dang co phong hoat dong", error.getMessage());
    }

    @Test
    void publicDetailRejectsSoftDeletedBuilding() {
        UUID nhaTroId = UUID.randomUUID();
        when(nhaTroRepository.findByIdAndXoaLucIsNull(nhaTroId)).thenReturn(Optional.empty());

        RuntimeException error = assertThrows(RuntimeException.class, () -> service.getPublicNhaTroById(nhaTroId));

        assertEquals("Khong tim thay nha tro", error.getMessage());
    }
}
