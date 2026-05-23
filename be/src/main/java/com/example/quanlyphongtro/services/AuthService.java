package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.AuthResponse;
import com.example.quanlyphongtro.dto.KhachThueLoginRequest;
import com.example.quanlyphongtro.dto.KhachThueLoginResponse;
import com.example.quanlyphongtro.dto.KhachThueResponse;
import com.example.quanlyphongtro.dto.LoginRequest;
import com.example.quanlyphongtro.dto.RegisterRequest;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import io.jsonwebtoken.Claims;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthService {

    private final NguoiDungRepository nguoiDungRepository;
    private final VaiTroRepository vaiTroRepository;
    private final NguoiDungVaiTroRepository nguoiDungVaiTroRepository;
    private final KhachThueRepository khachThueRepository;
    private final HopDongRepository hopDongRepository;
    private final HoaDonRepository hoaDonRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final EmailService emailService;

    /* ====================================================================
     *  REGISTER
     * ==================================================================== */

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        // Validate uniqueness
        if (nguoiDungRepository.existsByEmail(request.getEmail().toLowerCase())) {
            throw new RuntimeException("Email đã tồn tại trong hệ thống");
        }
        if (request.getSoDienThoai() != null && nguoiDungRepository.existsBySoDienThoai(request.getSoDienThoai())) {
            throw new RuntimeException("Số điện thoại đã tồn tại trong hệ thống");
        }

        // Create user with INACTIVE status (until email is verified)
        NguoiDung newUser = NguoiDung.builder()
                .id(UUID.randomUUID())
                .hoTen(request.getHoTen())
                .email(request.getEmail().toLowerCase())
                .soDienThoai(request.getSoDienThoai())
                .matKhau(passwordEncoder.encode(request.getMatKhau()))
                .trangThai(TrangThaiNguoiDung.INACTIVE) // Pending email verification
                .soLanDangNhapSai(0)
                .build();

        NguoiDung savedUser = nguoiDungRepository.save(newUser);

        // Assign role
        assignRole(savedUser, request.getVaiTro());

        // Send verification email (non-blocking – won't fail registration)
        emailService.sendVerificationEmail(savedUser);

        // Generate tokens so user can start using dashboard immediately
        // but some features may be restricted until email is verified
        String role = resolveRole(savedUser);
        String accessToken = jwtService.generateAccessToken(savedUser.getId(), savedUser.getEmail(), role);
        String refreshToken = createRefreshToken(savedUser);

        return AuthResponse.builder()
                .id(savedUser.getId())
                .email(savedUser.getEmail())
                .name(savedUser.getHoTen())
                .role(role)
                .phone(savedUser.getSoDienThoai())
                .avatar(savedUser.getAnhDaiDien())
                .token(accessToken)
                .refreshToken(refreshToken)
                .emailVerified(false)
                .build();
    }

    /* ====================================================================
     *  LOGIN
     * ==================================================================== */

    @Transactional
    public AuthResponse login(LoginRequest request) {
        NguoiDung user = nguoiDungRepository.findByEmail(request.getEmail().toLowerCase())
                .orElseThrow(() -> new RuntimeException("Email hoặc mật khẩu không đúng"));

        // Check if account is locked
        if (user.getKhoaDenLuc() != null && user.getKhoaDenLuc().isAfter(ZonedDateTime.now())) {
            throw new RuntimeException("Tài khoản đang bị khóa. Vui lòng thử lại sau.");
        }

        if (user.getTrangThai() == TrangThaiNguoiDung.BANNED) {
            throw new RuntimeException("Tài khoản đã bị cấm");
        }

        // Verify password
        if (user.getMatKhau() == null || !passwordEncoder.matches(request.getMatKhau(), user.getMatKhau())) {
            // Increment failed login count
            int fails = (user.getSoLanDangNhapSai() != null ? user.getSoLanDangNhapSai() : 0) + 1;
            user.setSoLanDangNhapSai(fails);

            // Lock after 5 failed attempts for 15 minutes
            if (fails >= 5) {
                user.setKhoaDenLuc(ZonedDateTime.now().plusMinutes(15));
                user.setSoLanDangNhapSai(0);
                nguoiDungRepository.save(user);
                throw new RuntimeException("Đăng nhập sai quá nhiều lần. Tài khoản bị khóa 15 phút.");
            }
            nguoiDungRepository.save(user);
            throw new RuntimeException("Email hoặc mật khẩu không đúng");
        }

        // Successful login – reset fail counter
        user.setSoLanDangNhapSai(0);
        user.setKhoaDenLuc(null);
        user.setLanDangNhapCuoi(ZonedDateTime.now());
        nguoiDungRepository.save(user);

        // Generate tokens
        String role = resolveRole(user);
        String accessToken = jwtService.generateAccessToken(user.getId(), user.getEmail(), role);
        String refreshToken = createRefreshToken(user);

        boolean verified = user.getTrangThai() == TrangThaiNguoiDung.ACTIVE;

        return AuthResponse.builder()
                .id(user.getId())
                .email(user.getEmail())
                .name(user.getHoTen())
                .role(role)
                .phone(user.getSoDienThoai())
                .avatar(user.getAnhDaiDien())
                .token(accessToken)
                .refreshToken(refreshToken)
                .emailVerified(verified)
                .build();
    }

    /* ====================================================================
     *  REFRESH TOKEN
     * ==================================================================== */

    @Transactional
    public AuthResponse refreshAccessToken(String refreshTokenValue) {
        // Validate the JWT signature of the refresh token
        Claims claims = jwtService.parseToken(refreshTokenValue);
        if (claims == null) {
            throw new RuntimeException("Refresh token không hợp lệ hoặc đã hết hạn");
        }

        // Check that the refresh token exists in DB (not revoked)
        RefreshToken stored = refreshTokenRepository.findByToken(refreshTokenValue)
                .orElseThrow(() -> new RuntimeException("Refresh token không tồn tại hoặc đã bị thu hồi"));

        if (stored.getNgayHetHan().isBefore(ZonedDateTime.now())) {
            refreshTokenRepository.delete(stored);
            throw new RuntimeException("Refresh token đã hết hạn, vui lòng đăng nhập lại");
        }

        NguoiDung user = stored.getNguoiDung();
        String role = resolveRole(user);
        String newAccessToken = jwtService.generateAccessToken(user.getId(), user.getEmail(), role);

        // Rotate refresh token (issue a new one, delete the old)
        refreshTokenRepository.delete(stored);
        String newRefreshToken = createRefreshToken(user);

        boolean verified = user.getTrangThai() == TrangThaiNguoiDung.ACTIVE;

        return AuthResponse.builder()
                .id(user.getId())
                .email(user.getEmail())
                .name(user.getHoTen())
                .role(role)
                .phone(user.getSoDienThoai())
                .avatar(user.getAnhDaiDien())
                .token(newAccessToken)
                .refreshToken(newRefreshToken)
                .emailVerified(verified)
                .build();
    }

    /* ====================================================================
     *  LOGOUT (revoke all refresh tokens)
     * ==================================================================== */

    @Transactional
    public void logout(UUID userId) {
        refreshTokenRepository.deleteByNguoiDungId(userId);
    }

    /* ====================================================================
     *  EMAIL VERIFICATION CALLBACK
     * ==================================================================== */

    @Transactional
    public AuthResponse verifyEmail(String token) {
        NguoiDung user = emailService.verifyToken(token);
        if (user == null) {
            throw new RuntimeException("Token xác thực không hợp lệ hoặc đã hết hạn");
        }
        nguoiDungRepository.save(user);

        String role = resolveRole(user);
        String accessToken = jwtService.generateAccessToken(user.getId(), user.getEmail(), role);
        String refreshToken = createRefreshToken(user);

        return AuthResponse.builder()
                .id(user.getId())
                .email(user.getEmail())
                .name(user.getHoTen())
                .role(role)
                .phone(user.getSoDienThoai())
                .avatar(user.getAnhDaiDien())
                .token(accessToken)
                .refreshToken(refreshToken)
                .emailVerified(true)
                .build();
    }

    /* ====================================================================
     *  RESEND VERIFICATION EMAIL
     * ==================================================================== */

    @Transactional
    public void resendVerificationEmail(String email) {
        NguoiDung user = nguoiDungRepository.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy tài khoản"));
        if (user.getTrangThai() == TrangThaiNguoiDung.ACTIVE) {
            throw new RuntimeException("Email đã được xác thực");
        }
        emailService.sendVerificationEmail(user);
    }

    /* ====================================================================
     *  KHACH THUE LOGIN (simplified – phone + password)
     * ==================================================================== */

    @Transactional
    public KhachThueLoginResponse loginKhachThue(KhachThueLoginRequest request) {
        NguoiDung user = nguoiDungRepository.findBySoDienThoai(request.getSoDienThoai())
                .orElseThrow(() -> new RuntimeException("Khách thuê không tồn tại"));

        if (user.getMatKhau() != null && !passwordEncoder.matches(request.getMatKhau(), user.getMatKhau())) {
            throw new RuntimeException("Mật khẩu không đúng");
        }

        KhachThue khachThue = khachThueRepository.findByNguoiDungId(user.getId())
                .orElseThrow(() -> new RuntimeException("Tài khoản chưa liên kết khách thuê"));

        String accessToken = jwtService.generateAccessToken(user.getId(), user.getEmail(), "TENANT");

        return KhachThueLoginResponse.builder()
                .token(accessToken)
                .khachThue(KhachThueResponse.fromEntity(khachThue))
                .build();
    }

    /* ====================================================================
     *  HELPERS
     * ==================================================================== */

    private void assignRole(NguoiDung user, String vaiTroStr) {
        VaiTroHeThong tempRole;
        try {
            tempRole = VaiTroHeThong.valueOf(vaiTroStr.toUpperCase());
        } catch (Exception e) {
            tempRole = VaiTroHeThong.LANDLORD; // default
        }
        final VaiTroHeThong vaiTroEnum = tempRole;

        VaiTro vaiTro = vaiTroRepository.findByTen(vaiTroEnum)
                .orElseGet(() -> {
                    VaiTro newRole = VaiTro.builder()
                            .ten(vaiTroEnum)
                            .moTa("Quyền " + vaiTroEnum.name())
                            .build();
                    return vaiTroRepository.save(newRole);
                });

        NguoiDungVaiTro ndvt = NguoiDungVaiTro.builder()
                .nguoiDung(user)
                .vaiTro(vaiTro)
                .taoLuc(ZonedDateTime.now())
                .build();
        nguoiDungVaiTroRepository.save(ndvt);
    }

    private String resolveRole(NguoiDung user) {
        try {
            List<NguoiDungVaiTro> roles = nguoiDungVaiTroRepository.findByNguoiDungId(user.getId());
            if (!roles.isEmpty()) {
                return roles.get(0).getVaiTro().getTen().name();
            }
        } catch (Exception e) {
            log.warn("Could not resolve role for user {}: {}", user.getId(), e.getMessage());
        }
        return "LANDLORD";
    }

    private String createRefreshToken(NguoiDung user) {
        String tokenValue = jwtService.generateRefreshToken(user.getId());
        RefreshToken rt = RefreshToken.builder()
                .nguoiDung(user)
                .token(tokenValue)
                .ngayHetHan(jwtService.getRefreshExpiration()
                        .toInstant().atZone(ZoneId.systemDefault()))
                .build();
        refreshTokenRepository.save(rt);
        return tokenValue;
    }
}
