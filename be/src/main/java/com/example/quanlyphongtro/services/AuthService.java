package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.AuthResponse;
import com.example.quanlyphongtro.dto.LoginRequest;
import com.example.quanlyphongtro.dto.RegisterRequest;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.TrangThaiNguoiDung;
import com.example.quanlyphongtro.entity.VaiTro;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.VaiTroRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final NguoiDungRepository nguoiDungRepository;
    private final VaiTroRepository vaiTroRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (nguoiDungRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email đã tồn tại trong hệ thống");
        }

        if (request.getSoDienThoai() != null && nguoiDungRepository.existsBySoDienThoai(request.getSoDienThoai())) {
            throw new RuntimeException("Số điện thoại đã tồn tại trong hệ thống");
        }

        NguoiDung newUser = NguoiDung.builder()
                .hoTen(request.getHoTen())
                .email(request.getEmail().toLowerCase())
                .matKhau(passwordEncoder.encode(request.getMatKhau()))
                .soDienThoai(request.getSoDienThoai())
                .trangThai(TrangThaiNguoiDung.ACTIVE)
                .build();

        // Gán vai trò (Mặc định hoặc theo request)
        String rawRole = request.getVaiTro() != null ? request.getVaiTro() : "tenant";
        String roleName = "TENANT";
        if (rawRole.equals("chuNha") || rawRole.equalsIgnoreCase("LANDLORD"))
            roleName = "LANDLORD";
        if (rawRole.equals("nhanVien") || rawRole.equalsIgnoreCase("ADMIN"))
            roleName = "ADMIN";

        Optional<VaiTro> vaiTroOpt = vaiTroRepository.findByTen(roleName);

        if (vaiTroOpt.isEmpty()) {
            // Nếu chưa có trong DB, tạo mới vai trò này (Tạm thời cho dev)
            VaiTro newRole = VaiTro.builder().ten(roleName).build();
            vaiTroRepository.save(newRole);
            newUser.getVaiTros().add(newRole);
        } else {
            newUser.getVaiTros().add(vaiTroOpt.get());
        }

        nguoiDungRepository.save(newUser);

        return mapToAuthResponse(newUser);
    }

    @Transactional(readOnly = true)
    public AuthResponse login(LoginRequest request) {
        NguoiDung user = nguoiDungRepository.findByEmail(request.getEmail().toLowerCase())
                .orElseThrow(() -> new RuntimeException("Tài khoản không tồn tại"));

        if (!passwordEncoder.matches(request.getMatKhau(), user.getMatKhau())) {
            throw new RuntimeException("Mật khẩu không chính xác");
        }

        if (user.getTrangThai() != TrangThaiNguoiDung.ACTIVE) {
            throw new RuntimeException("Tài khoản đang bị khóa hoặc ngưng hoạt động");
        }

        return mapToAuthResponse(user);
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
                .role(primaryRole)
                .phone(user.getSoDienThoai())
                .avatar(user.getAnhDaiDien())
                .token("dummy-jwt-token-for-now")
                .build();
    }
}
