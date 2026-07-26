package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.quanlyphongtro.dto.AdminUserRequest;
import com.example.quanlyphongtro.dto.UserResponse;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.TrangThaiNguoiDung;
import com.example.quanlyphongtro.repository.NguoiDungNhaTroRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.NguoiDungVaiTroRepository;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import com.example.quanlyphongtro.repository.VaiTroRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class AdminUserServiceTest {

    @Mock private NguoiDungRepository nguoiDungRepository;
    @Mock private VaiTroRepository vaiTroRepository;
    @Mock private NguoiDungVaiTroRepository nguoiDungVaiTroRepository;
    @Mock private NhaTroRepository nhaTroRepository;
    @Mock private NguoiDungNhaTroRepository nguoiDungNhaTroRepository;
    @Mock private PermissionService permissionService;
    @Mock private org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;
    @Mock private com.example.quanlyphongtro.repository.AuditLogRepository auditLogRepository;

    private UserService userService;

    @BeforeEach
    void setUp() {
        userService = new UserService(
                nguoiDungRepository,
                vaiTroRepository,
                nguoiDungVaiTroRepository,
                nhaTroRepository,
                nguoiDungNhaTroRepository,
                permissionService,
                auditLogRepository,
                passwordEncoder
        );
    }

    @Test
    void getAllUsersRequiresAdmin() {
        doThrow(new RuntimeException("Access Denied")).when(permissionService).requireAdmin();

        assertThrows(RuntimeException.class, () -> userService.getAllUsers());
    }

    @Test
    void getAllUsersReturnsList() {
        NguoiDung user = NguoiDung.builder().id(UUID.randomUUID()).email("test@easyhouse.local").trangThai(TrangThaiNguoiDung.ACTIVE).build();
        when(nguoiDungRepository.findByXoaLucIsNullOrderByTaoLucDesc()).thenReturn(List.of(user));

        List<UserResponse> responses = userService.getAllUsers();
        assertEquals(1, responses.size());
        assertEquals(user.getEmail(), responses.get(0).getEmail());
    }

    @Test
    void createUserRequiresAdmin() {
        doThrow(new RuntimeException("Access Denied")).when(permissionService).requireAdmin();

        assertThrows(RuntimeException.class, () -> userService.createUser(new AdminUserRequest()));
    }

    @Test
    void createUserSavesSuccessfully() {
        UUID authUserId = UUID.randomUUID();
        AdminUserRequest request = new AdminUserRequest();
        request.setAuthUserId(authUserId);
        request.setEmail("new@easyhouse.local");
        request.setName("New User");

        NguoiDung user = NguoiDung.builder()
                .id(authUserId)
                .email(request.getEmail())
                .hoTen(request.getName())
                .trangThai(TrangThaiNguoiDung.ACTIVE)
                .build();

        when(nguoiDungRepository.existsByEmail(request.getEmail())).thenReturn(false);
        when(nguoiDungRepository.save(any(NguoiDung.class))).thenReturn(user);

        UserResponse response = userService.createUser(request);
        assertEquals("new@easyhouse.local", response.getEmail());
        verify(permissionService, times(1)).requireAdmin();
    }
}
