package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.AuthResponse;
import com.example.quanlyphongtro.dto.KhachThueLoginRequest;
import com.example.quanlyphongtro.dto.KhachThueLoginResponse;
import com.example.quanlyphongtro.dto.KhachThueResponse;
import com.example.quanlyphongtro.dto.LoginRequest;
import com.example.quanlyphongtro.dto.RegisterRequest;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        UUID authUserId = request.getAuthUserId() != null ? request.getAuthUserId() : request.getSupabaseUserId();
        if (authUserId == null) {
            throw new RuntimeException("authUserId bat buoc vi nguoi_dung.id tham chieu Supabase auth.users(id)");
        }
        if (nguoiDungRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email da ton tai trong he thong");
        }
        if (request.getSoDienThoai() != null && nguoiDungRepository.existsBySoDienThoai(request.getSoDienThoai())) {
            throw new RuntimeException("So dien thoai da ton tai trong he thong");
        }

        NguoiDung newUser = NguoiDung.builder()
                .id(authUserId)
                .hoTen(request.getHoTen())
                .email(request.getEmail().toLowerCase())
                .soDienThoai(request.getSoDienThoai())
                .trangThai(TrangThaiNguoiDung.ACTIVE)
                .build();

        NguoiDung savedUser = nguoiDungRepository.save(newUser);
        return mapToAuthResponse(savedUser);
    }

    @Transactional(readOnly = true)
    public AuthResponse login(LoginRequest request) {
        NguoiDung user = nguoiDungRepository.findByEmail(request.getEmail().toLowerCase())
                .orElseThrow(() -> new RuntimeException("Tai khoan khong ton tai"));

        if (user.getTrangThai() == TrangThaiNguoiDung.BANNED) {
            throw new RuntimeException("Tai khoan dang bi khoa");
        }

        // Simplified auth - token is email (as documented in AGENTS.md)
        return mapToAuthResponse(user);
    }

    @Transactional
    public KhachThueLoginResponse loginKhachThue(KhachThueLoginRequest request) {
        // Find KhachThue by phone directly
        NguoiDung user = nguoiDungRepository.findBySoDienThoai(request.getSoDienThoai())
                .orElseThrow(() -> new RuntimeException("Khach thue khong ton tai"));

        KhachThue khachThue = khachThueRepository.findByNguoiDungId(user.getId())
                .orElseThrow(() -> new RuntimeException("Tai khoan chua lien ket khach thue"));

        return KhachThueLoginResponse.builder()
                .token(user.getId().toString())
                .khachThue(KhachThueResponse.fromEntity(khachThue))
                .build();
    }

    private AuthResponse mapToAuthResponse(NguoiDung user) {
        return AuthResponse.builder()
                .id(user.getId())
                .email(user.getEmail())
                .name(user.getHoTen())
                .role("chuNha") // Default role since auth is simplified
                .phone(user.getSoDienThoai())
                .avatar(user.getAnhDaiDien())
                .token(user.getEmail())
                .build();
    }
}
