package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.AuthResponse;
import com.example.quanlyphongtro.dto.KhachThueDashboardResponse;
import com.example.quanlyphongtro.dto.KhachThueLoginRequest;
import com.example.quanlyphongtro.dto.KhachThueLoginResponse;
import com.example.quanlyphongtro.dto.KhachThueResponse;
import com.example.quanlyphongtro.dto.LoginRequest;
import com.example.quanlyphongtro.dto.RegisterRequest;
import com.example.quanlyphongtro.entity.EmailVerificationToken;
import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.TrangThaiHoaDon;
import com.example.quanlyphongtro.entity.TrangThaiNguoiDung;
import com.example.quanlyphongtro.entity.VaiTro;
import com.example.quanlyphongtro.repository.EmailVerificationTokenRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.VaiTroRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final NguoiDungRepository nguoiDungRepository;
    private final VaiTroRepository vaiTroRepository;
    private final KhachThueRepository khachThueRepository;
    private final HopDongRepository hopDongRepository;
    private final HoaDonRepository hoaDonRepository;
    private final EmailVerificationTokenRepository emailVerificationTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;

    @Value("${app.frontend.base-url:http://localhost:3000}")
    private String frontendBaseUrl;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (nguoiDungRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email da ton tai trong he thong");
        }

        if (request.getSoDienThoai() != null && nguoiDungRepository.existsBySoDienThoai(request.getSoDienThoai())) {
            throw new RuntimeException("So dien thoai da ton tai trong he thong");
        }

        NguoiDung newUser = NguoiDung.builder()
                .hoTen(request.getHoTen())
                .email(request.getEmail().toLowerCase())
                .matKhau(passwordEncoder.encode(request.getMatKhau()))
                .soDienThoai(request.getSoDienThoai())
                .trangThai(TrangThaiNguoiDung.INACTIVE)
                .build();

        String roleName = toDbRole(request.getVaiTro());
        VaiTro vaiTro = vaiTroRepository.findByTen(roleName)
                .orElseGet(() -> vaiTroRepository.save(VaiTro.builder().ten(roleName).build()));
        newUser.getVaiTros().add(vaiTro);

        NguoiDung savedUser = nguoiDungRepository.save(newUser);
        sendVerificationEmail(savedUser, request.getMatKhau());

        return mapToAuthResponse(savedUser);
    }

    @Transactional(readOnly = true)
    public AuthResponse login(LoginRequest request) {
        NguoiDung user = nguoiDungRepository.findByEmail(request.getEmail().toLowerCase())
                .orElseThrow(() -> new RuntimeException("Tai khoan khong ton tai"));

        if (!passwordEncoder.matches(request.getMatKhau(), user.getMatKhau())) {
            throw new RuntimeException("Mat khau khong chinh xac");
        }

        if (user.getTrangThai() == TrangThaiNguoiDung.INACTIVE) {
            throw new RuntimeException("Tai khoan chua xac thuc email");
        }

        if (user.getTrangThai() == TrangThaiNguoiDung.BANNED) {
            throw new RuntimeException("Tai khoan dang bi khoa");
        }

        return mapToAuthResponse(user);
    }

    @Transactional
    public KhachThueLoginResponse loginKhachThue(KhachThueLoginRequest request) {
        NguoiDung user = nguoiDungRepository.findBySoDienThoai(request.getSoDienThoai())
                .orElseThrow(() -> new RuntimeException("Khach thue khong ton tai"));

        if (user.getTrangThai() == TrangThaiNguoiDung.INACTIVE) {
            throw new RuntimeException("Tai khoan chua kich hoat");
        }

        if (user.getTrangThai() == TrangThaiNguoiDung.BANNED) {
            throw new RuntimeException("Tai khoan dang bi khoa");
        }

        boolean passwordMatches = passwordEncoder.matches(request.getMatKhau(), user.getMatKhau());
        boolean legacyPlaintextMatches = request.getMatKhau().equals(user.getMatKhau());
        if (!passwordMatches && !legacyPlaintextMatches) {
            throw new RuntimeException("Mat khau khong chinh xac");
        }

        if (legacyPlaintextMatches) {
            user.setMatKhau(passwordEncoder.encode(request.getMatKhau()));
            nguoiDungRepository.save(user);
        }

        KhachThue khachThue = khachThueRepository.findByNguoiDungId(user.getId())
                .orElseThrow(() -> new RuntimeException("Tai khoan chua lien ket khach thue"));

        return KhachThueLoginResponse.builder()
                .token(user.getId().toString())
                .khachThue(KhachThueResponse.fromEntity(khachThue))
                .build();
    }

    @Transactional(readOnly = true)
    public KhachThueDashboardResponse getKhachThueDashboard(String authorizationHeader) {
        UUID nguoiDungId = parseBearerUserId(authorizationHeader);
        KhachThue khachThue = khachThueRepository.findByNguoiDungId(nguoiDungId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay khach thue"));

        Optional<HopDong> activeContract = findActiveContract(khachThue.getId());
        List<HoaDon> invoices = hoaDonRepository.findByKhachThueIdAndXoaLucIsNullOrderByThangHoaDonDesc(khachThue.getId());
        long unpaidCount = invoices.stream()
                .filter(invoice -> invoice.getTrangThai() != TrangThaiHoaDon.PAID)
                .count();

        return KhachThueDashboardResponse.builder()
                .khachThue(KhachThueDashboardResponse.TenantProfile.builder()
                        .hoTen(khachThue.getNguoiDung() != null ? khachThue.getNguoiDung().getHoTen() : "")
                        .trangThai(activeContract.isPresent() ? "dangThue" : "chuaThue")
                        .build())
                .hopDongHienTai(activeContract.map(this::toTenantContract).orElse(null))
                .soHoaDonChuaThanhToan(unpaidCount)
                .hoaDonGanNhat(invoices.stream().findFirst().map(this::toTenantInvoice).orElse(null))
                .build();
    }

    @Transactional
    public String verifyEmail(String token) {
        EmailVerificationToken verificationToken = emailVerificationTokenRepository
                .findByTokenAndUsedFalse(token)
                .orElseThrow(() -> new RuntimeException("Lien ket xac thuc khong hop le hoac da duoc su dung"));

        if (verificationToken.getHetHanLuc().isBefore(ZonedDateTime.now())) {
            throw new RuntimeException("Lien ket xac thuc da het han");
        }

        NguoiDung user = verificationToken.getNguoiDung();
        user.setTrangThai(TrangThaiNguoiDung.ACTIVE);
        nguoiDungRepository.save(user);

        verificationToken.setUsed(true);
        emailVerificationTokenRepository.save(verificationToken);

        return "Xac thuc email thanh cong. Ban co the dang nhap ngay.";
    }

    public void forgotPassword(String email) {
        NguoiDung user = nguoiDungRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nguoi dung voi email nay."));

        String newPassword = generateRandomPassword(8);
        user.setMatKhau(passwordEncoder.encode(newPassword));
        nguoiDungRepository.save(user);

        try {
            emailService.sendNewPassword(user.getEmail(), user.getHoTen(), newPassword);
        } catch (MailException e) {
            throw new RuntimeException("Khong the gui email chua mat khau moi: " + e.getMessage());
        }
    }

    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        java.util.Random random = new java.util.Random();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }

    private void sendVerificationEmail(NguoiDung user, String rawPassword) {
        emailVerificationTokenRepository.deleteByNguoiDungId(user.getId());

        String token = UUID.randomUUID().toString();
        EmailVerificationToken verificationToken = EmailVerificationToken.builder()
                .token(token)
                .nguoiDung(user)
                .hetHanLuc(ZonedDateTime.now().plusHours(24))
                .build();

        emailVerificationTokenRepository.save(verificationToken);

        String verifyUrl = frontendBaseUrl + "/xac-thuc-email?token=" + token;
        try {
            emailService.sendEmailVerification(
                    user.getEmail(),
                    user.getHoTen(),
                    user.getEmail(),
                    rawPassword,
                    verifyUrl);
        } catch (MailException e) {
            throw new RuntimeException("Khong the gui email xac thuc. Vui long kiem tra cau hinh SMTP va thu lai.");
        }
    }

    private UUID parseBearerUserId(String authorizationHeader) {
        if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
            throw new RuntimeException("Token khong hop le");
        }

        try {
            return UUID.fromString(authorizationHeader.substring("Bearer ".length()).trim());
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Token khong hop le");
        }
    }

    private Optional<HopDong> findActiveContract(UUID khachThueId) {
        return hopDongRepository.findAllActiveWithPhongAndToaNha().stream()
                .filter(hopDong -> isTenantInContract(hopDong, khachThueId))
                .findFirst();
    }

    private boolean isTenantInContract(HopDong hopDong, UUID khachThueId) {
        if (hopDong.getNguoiDaiDien() != null && khachThueId.equals(hopDong.getNguoiDaiDien().getId())) {
            return true;
        }

        return hopDong.getKhachThueIds() != null && hopDong.getKhachThueIds().contains(khachThueId);
    }

    private KhachThueDashboardResponse.TenantContract toTenantContract(HopDong hopDong) {
        Phong phong = hopDong.getPhong();
        NhaTro nhaTro = phong != null ? phong.getNhaTro() : null;

        KhachThueDashboardResponse.TenantRoom room = phong != null
                ? KhachThueDashboardResponse.TenantRoom.builder()
                        .maPhong(phong.getTen())
                        .giaThue(hopDong.getGiaThue() != null ? hopDong.getGiaThue() : phong.getGiaHienTai())
                        .toaNha(nhaTro != null
                                ? KhachThueDashboardResponse.TenantBuilding.builder()
                                        .tenToaNha(nhaTro.getTen())
                                        .diaChi(KhachThueDashboardResponse.TenantAddress.builder()
                                                .duong(nhaTro.getDiaChi())
                                                .phuong(nhaTro.getXa())
                                                .build())
                                        .build()
                                : null)
                        .build()
                : null;

        return KhachThueDashboardResponse.TenantContract.builder()
                .maHopDong(hopDong.getMaHopDong())
                .ngayBatDau(hopDong.getNgayBatDau())
                .ngayKetThuc(hopDong.getNgayKetThuc())
                .tienCoc(hopDong.getTienCoc())
                .phong(room)
                .build();
    }

    private KhachThueDashboardResponse.TenantInvoice toTenantInvoice(HoaDon hoaDon) {
        String status = switch (hoaDon.getTrangThai()) {
            case PAID -> "daThanhToan";
            case PARTIAL -> "daThanhToanMotPhan";
            case OVERDUE -> "quaHan";
            case UNPAID -> "chuaThanhToan";
        };

        return KhachThueDashboardResponse.TenantInvoice.builder()
                .maHoaDon(hoaDon.getMaHoaDon())
                .thang(hoaDon.getThangHoaDon() != null ? hoaDon.getThangHoaDon().getMonthValue() : 0)
                .nam(hoaDon.getThangHoaDon() != null ? hoaDon.getThangHoaDon().getYear() : 0)
                .tongTien(hoaDon.getTongTien())
                .trangThai(status)
                .build();
    }

    private String toDbRole(String rawRole) {
        if (rawRole == null || rawRole.isBlank()) {
            return "TENANT";
        }

        return switch (rawRole) {
            case "admin", "ADMIN" -> "ADMIN";
            case "chuNha", "LANDLORD" -> "LANDLORD";
            case "nhanVien", "STAFF" -> "STAFF";
            case "TENANT", "tenant" -> "TENANT";
            default -> "TENANT";
        };
    }

    private String toFrontendRole(String dbRole) {
        if (dbRole == null) {
            return "tenant";
        }

        return switch (dbRole) {
            case "ADMIN" -> "admin";
            case "LANDLORD" -> "chuNha";
            case "STAFF" -> "nhanVien";
            case "TENANT" -> "tenant";
            default -> dbRole.toLowerCase();
        };
    }

    private AuthResponse mapToAuthResponse(NguoiDung user) {
        String primaryRole = user.getVaiTros().stream()
                .findFirst()
                .map(VaiTro::getTen)
                .orElse("TENANT");

        return AuthResponse.builder()
                .id(user.getId())
                .email(user.getEmail())
                .name(user.getHoTen())
                .role(toFrontendRole(primaryRole))
                .phone(user.getSoDienThoai())
                .avatar(user.getAnhDaiDien())
                .token(user.getEmail())
                .build();
    }
}
