package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.AuthResponse;
import com.example.quanlyphongtro.dto.KhachThueLoginRequest;
import com.example.quanlyphongtro.dto.KhachThueLoginResponse;
import com.example.quanlyphongtro.dto.KhachThueDashboardResponse;
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
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.math.BigDecimal;
import java.security.SecureRandom;
import java.util.Comparator;
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
    private final LoginHistoryRepository loginHistoryRepository;
    private final SuCoRepository suCoRepository;
    private final ThongBaoNguoiNhanRepository thongBaoNguoiNhanRepository;
    private final ThongBaoRepository thongBaoRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final EmailService emailService;
    private final AuditLogRepository auditLogRepository;

    private static final String TEMP_PASSWORD_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789!@#$%";
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

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
        logAudit(savedUser, "REGISTER");

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
    public AuthResponse login(LoginRequest request, HttpServletRequest httpServletRequest) {
        String ipAddress = httpServletRequest != null ? httpServletRequest.getRemoteAddr() : null;
        String userAgent = httpServletRequest != null ? httpServletRequest.getHeader("User-Agent") : null;
        
        Optional<NguoiDung> userOpt = nguoiDungRepository.findByEmail(request.getEmail().toLowerCase());
        if (userOpt.isEmpty()) {
            saveLoginHistory(null, request.getEmail().toLowerCase(), false, ipAddress, userAgent, "Email không tồn tại");
            throw new RuntimeException("Email hoặc mật khẩu không đúng");
        }
        NguoiDung user = userOpt.get();

        // Check if account is locked
        if (user.getKhoaDenLuc() != null && user.getKhoaDenLuc().isAfter(ZonedDateTime.now())) {
            saveLoginHistory(user, user.getEmail(), false, ipAddress, userAgent, "Tài khoản đang bị khóa");
            throw new RuntimeException("Tài khoản đang bị khóa. Vui lòng thử lại sau.");
        }

        if (user.getTrangThai() == TrangThaiNguoiDung.BANNED) {
            saveLoginHistory(user, user.getEmail(), false, ipAddress, userAgent, "Tài khoản đã bị cấm");
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
                saveLoginHistory(user, user.getEmail(), false, ipAddress, userAgent, "Sai mật khẩu quá 5 lần, khóa tài khoản");
                throw new RuntimeException("Đăng nhập sai quá nhiều lần. Tài khoản bị khóa 15 phút.");
            }
            nguoiDungRepository.save(user);
            saveLoginHistory(user, user.getEmail(), false, ipAddress, userAgent, "Sai mật khẩu");
            throw new RuntimeException("Email hoặc mật khẩu không đúng");
        }

        // Successful login – reset fail counter
        user.setSoLanDangNhapSai(0);
        user.setKhoaDenLuc(null);
        user.setLanDangNhapCuoi(ZonedDateTime.now());
        nguoiDungRepository.save(user);
        saveLoginHistory(user, user.getEmail(), true, ipAddress, userAgent, null);

        // Generate tokens
        String role = resolveRole(user);
        
        // Prevent tenants from logging into landlord portal
        if ("TENANT".equals(role)) {
            throw new RuntimeException("Tài khoản khách thuê không được phép đăng nhập vào trang quản lý. Vui lòng đăng nhập tại cổng Khách thuê.");
        }
        
        String accessToken = jwtService.generateAccessToken(user.getId(), user.getEmail(), role);
        String refreshToken = createRefreshToken(user);
        logAudit(user, "LOGIN");

        boolean verified = user.getTrangThai() == TrangThaiNguoiDung.ACTIVE;
        boolean requirePasswordChange = user.getMatKhau() != null && passwordEncoder.matches("123456", user.getMatKhau());

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
                .requirePasswordChange(requirePasswordChange)
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

    @Transactional
    public void forgotPassword(String email) {
        if (email == null || email.isBlank()) return;

        Optional<NguoiDung> userOptional = nguoiDungRepository.findByEmail(email.toLowerCase());
        if (userOptional.isEmpty()) {
            log.info("Forgot password requested for non-existing email {}", email.toLowerCase());
            return;
        }

        NguoiDung user = userOptional.get();
        if (user.getXoaLuc() != null || user.getTrangThai() == TrangThaiNguoiDung.BANNED) {
            log.info("Forgot password ignored for inactive/banned user {}", user.getId());
            return;
        }

        String temporaryPassword = generateTemporaryPassword(12);
        user.setMatKhau(passwordEncoder.encode(temporaryPassword));
        user.setSoLanDangNhapSai(0);
        user.setKhoaDenLuc(null);
        nguoiDungRepository.save(user);
        refreshTokenRepository.deleteByNguoiDungId(user.getId());

        emailService.sendTemporaryPasswordEmail(user, temporaryPassword);
    }

    /* ====================================================================
     *  KHACH THUE LOGIN (simplified – phone + password)
     * ==================================================================== */

    @Transactional
    public KhachThueLoginResponse loginKhachThue(KhachThueLoginRequest request, HttpServletRequest httpServletRequest) {
        String ipAddress = httpServletRequest != null ? httpServletRequest.getRemoteAddr() : null;
        String userAgent = httpServletRequest != null ? httpServletRequest.getHeader("User-Agent") : null;
        
        Optional<NguoiDung> userOpt = nguoiDungRepository.findBySoDienThoai(request.getSoDienThoai());
        if (userOpt.isEmpty()) {
            saveLoginHistory(null, request.getSoDienThoai(), false, ipAddress, userAgent, "Khách thuê không tồn tại (SĐT)");
            throw new RuntimeException("Khách thuê không tồn tại");
        }
        NguoiDung user = userOpt.get();

        if (user.getMatKhau() == null) {
            saveLoginHistory(user, user.getEmail() != null ? user.getEmail() : request.getSoDienThoai(), false, ipAddress, userAgent, "Tài khoản chưa có mật khẩu");
            throw new RuntimeException("Tài khoản chưa có mật khẩu, vui lòng liên hệ quản lý");
        }
        if (!passwordEncoder.matches(request.getMatKhau(), user.getMatKhau())) {
            saveLoginHistory(user, user.getEmail() != null ? user.getEmail() : request.getSoDienThoai(), false, ipAddress, userAgent, "Sai mật khẩu");
            throw new RuntimeException("Mật khẩu không đúng");
        }

        KhachThue khachThue = khachThueRepository.findByNguoiDungId(user.getId())
                .orElseThrow(() -> {
                    saveLoginHistory(user, user.getEmail() != null ? user.getEmail() : request.getSoDienThoai(), false, ipAddress, userAgent, "Không tìm thấy hồ sơ khách thuê");
                    return new RuntimeException("Tài khoản chưa liên kết khách thuê");
                });

        saveLoginHistory(user, user.getEmail() != null ? user.getEmail() : request.getSoDienThoai(), true, ipAddress, userAgent, null);
        String accessToken = jwtService.generateAccessToken(user.getId(), user.getEmail(), "TENANT");
        String refreshToken = createRefreshToken(user);

        boolean requirePasswordChange = user.getMatKhau() != null && passwordEncoder.matches("123456", user.getMatKhau());

        return KhachThueLoginResponse.builder()
                .token(accessToken)
                .refreshToken(refreshToken)
                .khachThue(KhachThueResponse.fromEntity(khachThue))
                .requirePasswordChange(requirePasswordChange)
                .build();
    }

    @Transactional(readOnly = true)
    public KhachThueDashboardResponse getKhachThueDashboard(UUID userId) {
        KhachThue khachThue = khachThueRepository.findByNguoiDungId(userId)
                .orElseThrow(() -> new RuntimeException("Tai khoan chua lien ket khach thue"));

        HopDong hopDong = hopDongRepository.findByKhachThueIdAndXoaLucIsNull(khachThue.getId()).stream()
                .filter(item -> item.getTrangThai() == TrangThaiHopDong.ACTIVE || item.getTrangThai() == TrangThaiHopDong.PENDING)
                .sorted(Comparator.comparing(HopDong::getNgayBatDau, Comparator.nullsLast(Comparator.reverseOrder())))
                .findFirst()
                .orElse(null);

        List<HoaDon> hoaDons = hoaDonRepository.findByKhachThueIdAndXoaLucIsNullOrderByKyNamDescKyThangDesc(khachThue.getId());
        long unpaidCount = hoaDons.stream()
                .filter(item -> item.getTrangThai() == TrangThaiHoaDon.UNPAID
                        || item.getTrangThai() == TrangThaiHoaDon.PARTIAL
                        || item.getTrangThai() == TrangThaiHoaDon.OVERDUE)
                .count();
        HoaDon latestInvoice = hoaDons.stream().findFirst().orElse(null);

        long soSuCoDangMo = suCoRepository.countByNguoiBaoIdAndTrangThaiIn(
                userId, 
                List.of(TrangThaiSuCo.PENDING, TrangThaiSuCo.IN_PROGRESS)
        );

        long unreadSpecific = thongBaoNguoiNhanRepository.countByNguoiDungIdAndDaDocFalse(userId);
        long unreadBroadcast = thongBaoRepository != null ? thongBaoRepository.countUnreadGuiTatCa(userId) : 0;
        long soThongBaoMoi = unreadSpecific + unreadBroadcast;

        KhachThueDashboardResponse.LienHeNhaTro lienHe = null;
        if (hopDong != null && hopDong.getPhong() != null && hopDong.getPhong().getNhaTro() != null) {
            NguoiDung chuTro = hopDong.getPhong().getNhaTro().getChuTro();
            if (chuTro != null) {
                lienHe = KhachThueDashboardResponse.LienHeNhaTro.builder()
                        .hoTen(chuTro.getHoTen())
                        .soDienThoai(chuTro.getSoDienThoai())
                        .email(chuTro.getEmail())
                        .build();
            }
        }

        return KhachThueDashboardResponse.builder()
                .khachThue(KhachThueDashboardResponse.TenantProfile.builder()
                        .hoTen(khachThue.getHoTen())
                        .trangThai(Boolean.FALSE.equals(khachThue.getDangHoatDong()) ? "daTraPhong" : "dangThue")
                        .build())
                .hopDongHienTai(toTenantContract(hopDong))
                .soHoaDonChuaThanhToan(unpaidCount)
                .soSuCoDangMo(soSuCoDangMo)
                .soThongBaoMoi(soThongBaoMoi)
                .hoaDonGanNhat(toTenantInvoice(latestInvoice))
                .lienHe(lienHe)
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
            tempRole = VaiTroHeThong.TENANT; // default fallback
        }
        // Map LANDLORD and STAFF to ADMIN
        if (tempRole == VaiTroHeThong.LANDLORD || tempRole == VaiTroHeThong.STAFF) {
            tempRole = VaiTroHeThong.ADMIN;
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
                VaiTroHeThong ten = roles.get(0).getVaiTro().getTen();
                if (ten == VaiTroHeThong.LANDLORD || ten == VaiTroHeThong.STAFF) {
                    return "ADMIN";
                }
                return ten.name();
            }
        } catch (Exception e) {
            log.warn("Could not resolve role for user {}: {}", user.getId(), e.getMessage());
        }
        return "TENANT"; // default fallback
    }

    private KhachThueDashboardResponse.TenantContract toTenantContract(HopDong hopDong) {
        if (hopDong == null) return null;
        Phong phong = hopDong.getPhong();
        NhaTro nhaTro = phong != null ? phong.getNhaTro() : null;

        return KhachThueDashboardResponse.TenantContract.builder()
                .maHopDong(hopDong.getMaHopDong())
                .ngayBatDau(hopDong.getNgayBatDau())
                .ngayKetThuc(hopDong.getNgayKetThuc())
                .tienCoc(hopDong.getTienCoc())
                .phong(phong == null ? null : KhachThueDashboardResponse.TenantRoom.builder()
                        .maPhong(phong.getTen())
                        .giaThue(hopDong.getGiaThueHopDong() != null ? hopDong.getGiaThueHopDong() : BigDecimal.ZERO)
                        .toaNha(nhaTro == null ? null : KhachThueDashboardResponse.TenantBuilding.builder()
                                .tenToaNha(nhaTro.getTen())
                                .diaChi(KhachThueDashboardResponse.TenantAddress.builder()
                                        .duong(nhaTro.getDuong())
                                        .phuong(nhaTro.getPhuong())
                                        .build())
                                .build())
                        .build())
                .build();
    }

    private KhachThueDashboardResponse.TenantInvoice toTenantInvoice(HoaDon hoaDon) {
        if (hoaDon == null) return null;
        return KhachThueDashboardResponse.TenantInvoice.builder()
                .maHoaDon(hoaDon.getMaHoaDon())
                .thang(hoaDon.getKyThang())
                .nam(hoaDon.getKyNam())
                .tongTien(hoaDon.getTongTien())
                .trangThai(toTenantInvoiceStatus(hoaDon.getTrangThai()))
                .build();
    }

    private String toTenantInvoiceStatus(TrangThaiHoaDon status) {
        if (status == TrangThaiHoaDon.PAID || status == TrangThaiHoaDon.OVERPAID) return "daThanhToan";
        if (status == TrangThaiHoaDon.PARTIAL) return "daThanhToanMotPhan";
        if (status == TrangThaiHoaDon.OVERDUE) return "quaHan";
        return "chuaThanhToan";
    }

    private String generateTemporaryPassword(int length) {
        StringBuilder password = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            password.append(TEMP_PASSWORD_CHARS.charAt(SECURE_RANDOM.nextInt(TEMP_PASSWORD_CHARS.length())));
        }
        return password.toString();
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
    
    private void saveLoginHistory(NguoiDung user, String email, boolean thanhCong, String ipAddress, String userAgent, String lyDoThatBai) {
        try {
            String safeUserAgent = userAgent != null && userAgent.length() > 255 ? userAgent.substring(0, 255) : userAgent;
            String safeLyDo = lyDoThatBai != null && lyDoThatBai.length() > 255 ? lyDoThatBai.substring(0, 255) : lyDoThatBai;
            LoginHistory history = LoginHistory.builder()
                    .nguoiDung(user)
                    .email(email)
                    .thanhCong(thanhCong)
                    .ipAddress(ipAddress)
                    .userAgent(safeUserAgent)
                    .lyDoThatBai(safeLyDo)
                    .taoLuc(ZonedDateTime.now())
                    .build();
            loginHistoryRepository.save(history);
        } catch (Exception e) {
            log.warn("Could not save login history: {}", e.getMessage());
        }
    }

    private void logAudit(NguoiDung user, String hanhDong) {
        try {
            AuditLog log = AuditLog.builder()
                .nguoiDung(user)
                .hanhDong(hanhDong)
                .bangTacDong("nguoi_dung")
                .banGhiId(user.getId())
                .taoLuc(ZonedDateTime.now())
                .build();
            auditLogRepository.save(log);
        } catch (Exception e) {
            log.warn("Could not save audit log for {}: {}", hanhDong, e.getMessage());
        }
    }
}
