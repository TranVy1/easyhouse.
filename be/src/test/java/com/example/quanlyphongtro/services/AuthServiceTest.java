package com.example.quanlyphongtro.services;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import com.example.quanlyphongtro.dto.LoginRequest;
import com.example.quanlyphongtro.dto.RegisterRequest;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.TrangThaiNguoiDung;
import com.example.quanlyphongtro.repository.AuditLogRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import com.example.quanlyphongtro.repository.LoginHistoryRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.NguoiDungVaiTroRepository;
import com.example.quanlyphongtro.repository.RefreshTokenRepository;
import com.example.quanlyphongtro.repository.SuCoRepository;
import com.example.quanlyphongtro.repository.ThongBaoNguoiNhanRepository;
import com.example.quanlyphongtro.repository.ThongBaoRepository;
import com.example.quanlyphongtro.repository.VaiTroRepository;
import java.util.Optional;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock private NguoiDungRepository nguoiDungRepository;
    @Mock private VaiTroRepository vaiTroRepository;
    @Mock private NguoiDungVaiTroRepository nguoiDungVaiTroRepository;
    @Mock private KhachThueRepository khachThueRepository;
    @Mock private HopDongRepository hopDongRepository;
    @Mock private HoaDonRepository hoaDonRepository;
    @Mock private RefreshTokenRepository refreshTokenRepository;
    @Mock private LoginHistoryRepository loginHistoryRepository;
    @Mock private SuCoRepository suCoRepository;
    @Mock private ThongBaoNguoiNhanRepository thongBaoNguoiNhanRepository;
    @Mock private ThongBaoRepository thongBaoRepository;
    @Mock private PasswordEncoder passwordEncoder;
    @Mock private JwtService jwtService;
    @Mock private EmailService emailService;
    @Mock private AuditLogRepository auditLogRepository;
    @InjectMocks private AuthService authService;

    @Test
    void publicRegistrationRejectsTenantRole() {
        RegisterRequest request = new RegisterRequest();
        request.setVaiTro("TENANT");

        RuntimeException error = assertThrows(RuntimeException.class, () -> authService.register(request));

        assertEquals("Dang ky cong khai chi danh cho chu tro", error.getMessage());
    }

    @Test
    void loginRejectsAccountThatHasNotVerifiedEmail() {
        LoginRequest request = new LoginRequest();
        request.setEmail("owner@example.com");
        request.setMatKhau("secret123");
        NguoiDung inactiveUser = NguoiDung.builder()
                .email("owner@example.com")
                .trangThai(TrangThaiNguoiDung.INACTIVE)
                .build();
        org.mockito.Mockito.when(nguoiDungRepository.findByEmail("owner@example.com"))
                .thenReturn(Optional.of(inactiveUser));

        RuntimeException error = assertThrows(RuntimeException.class, () -> authService.login(request, null));

        assertEquals("Vui long xac thuc email truoc khi dang nhap", error.getMessage());
    }
}
