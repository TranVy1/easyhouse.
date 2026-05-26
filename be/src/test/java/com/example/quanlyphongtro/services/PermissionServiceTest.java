package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.NguoiDungNhaTro;
import com.example.quanlyphongtro.entity.VaiTroHeThong;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import com.example.quanlyphongtro.repository.NguoiDungNhaTroRepository;
import com.example.quanlyphongtro.repository.NguoiDungVaiTroRepository;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;

@ExtendWith(MockitoExtension.class)
class PermissionServiceTest {

    @Mock private NguoiDungVaiTroRepository nguoiDungVaiTroRepository;
    @Mock private NhaTroRepository nhaTroRepository;
    @Mock private NguoiDungNhaTroRepository nguoiDungNhaTroRepository;
    @Mock private PhongRepository phongRepository;
    @Mock private HopDongRepository hopDongRepository;
    @Mock private HoaDonRepository hoaDonRepository;
    @Mock private KhachThueRepository khachThueRepository;

    private PermissionService permissionService;

    @BeforeEach
    void setUp() {
        permissionService = new PermissionService(
                nguoiDungVaiTroRepository,
                nhaTroRepository,
                nguoiDungNhaTroRepository,
                phongRepository,
                hopDongRepository,
                hoaDonRepository,
                khachThueRepository
        );
        SecurityContextHolder.clearContext();
    }

    @Test
    void requireCurrentUserIdThrowsWhenNotAuthenticated() {
        RuntimeException error = assertThrows(RuntimeException.class, () -> permissionService.requireCurrentUserId());
        assertEquals("Vui long dang nhap lai", error.getMessage());
    }

    @Test
    void requireCurrentUserIdReturnsUserIdWhenAuthenticated() {
        UUID userId = UUID.randomUUID();
        SecurityContextHolder.getContext().setAuthentication(
                new UsernamePasswordAuthenticationToken(userId, null, java.util.List.of())
        );

        assertEquals(userId, permissionService.requireCurrentUserId());
    }

    @Test
    void canReadNhaTroReturnsTrueForOwner() {
        UUID userId = UUID.randomUUID();
        UUID nhaTroId = UUID.randomUUID();
        UUID ownerId = userId; // User is owner

        assertTrue(permissionService.canReadNhaTro(userId, nhaTroId, ownerId));
    }

    @Test
    void canReadNhaTroReturnsTrueForStaffWithViewPermission() {
        UUID userId = UUID.randomUUID();
        UUID nhaTroId = UUID.randomUUID();
        UUID ownerId = UUID.randomUUID(); // User is not owner

        NguoiDungNhaTro ndnt = NguoiDungNhaTro.builder()
                .vaiTro(VaiTroHeThong.STAFF)
                .coQuyenXem(true)
                .build();
        when(nguoiDungNhaTroRepository.findByNguoiDungIdAndNhaTroId(userId, nhaTroId))
                .thenReturn(Optional.of(ndnt));

        assertTrue(permissionService.canReadNhaTro(userId, nhaTroId, ownerId));
    }

    @Test
    void canReadNhaTroReturnsFalseForStaffWithoutViewPermission() {
        UUID userId = UUID.randomUUID();
        UUID nhaTroId = UUID.randomUUID();
        UUID ownerId = UUID.randomUUID(); // User is not owner

        NguoiDungNhaTro ndnt = NguoiDungNhaTro.builder()
                .vaiTro(VaiTroHeThong.STAFF)
                .coQuyenXem(false)
                .build();
        when(nguoiDungNhaTroRepository.findByNguoiDungIdAndNhaTroId(userId, nhaTroId))
                .thenReturn(Optional.of(ndnt));

        assertFalse(permissionService.canReadNhaTro(userId, nhaTroId, ownerId));
    }

    @Test
    void isAdminReturnsTrueForAdminRole() {
        UUID userId = UUID.randomUUID();
        // Setup SecurityContext with ADMIN role
        SecurityContextHolder.getContext().setAuthentication(
                new UsernamePasswordAuthenticationToken(userId, null, java.util.List.of(() -> "ROLE_ADMIN"))
        );
        
        assertTrue(permissionService.isAdmin(userId));
    }

    @Test
    void canAccessKhachThueReturnsTrueForTenantThemselves() {
        UUID currentUserId = UUID.randomUUID();
        UUID khachThueId = UUID.randomUUID();
        
        KhachThue khachThue = KhachThue.builder()
                .id(khachThueId)
                .nguoiDung(NguoiDung.builder().id(currentUserId).build())
                .chuTro(NguoiDung.builder().id(UUID.randomUUID()).build())
                .build();

        when(khachThueRepository.findById(khachThueId)).thenReturn(Optional.of(khachThue));

        assertTrue(permissionService.canReadKhachThue(currentUserId, khachThueId));
    }
}
