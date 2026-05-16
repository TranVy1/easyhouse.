package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.UserResponse;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.VaiTro;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService {

    private final NguoiDungRepository nguoiDungRepository;
    private final org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;

    @Transactional
    public void changePassword(String email, com.example.quanlyphongtro.dto.ChangePasswordRequest request) {
        NguoiDung user = nguoiDungRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Người dùng không tồn tại"));

        if (!passwordEncoder.matches(request.getOldPassword(), user.getMatKhau())) {
            throw new RuntimeException("Mật khẩu hiện tại không chính xác");
        }

        user.setMatKhau(passwordEncoder.encode(request.getNewPassword()));
        nguoiDungRepository.save(user);
    }

    @Transactional(readOnly = true)
    public UserResponse getProfileByEmail(String email) {
        NguoiDung user = nguoiDungRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Người dùng không tồn tại"));
        
        return mapToUserResponse(user);
    }

    @Transactional
    public UserResponse updateProfile(String email, com.example.quanlyphongtro.dto.UserRequest request) {
        NguoiDung user = nguoiDungRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Người dùng không tồn tại"));
        
        user.setHoTen(request.getName());
        user.setSoDienThoai(request.getPhone());
        user.setDiaChi(request.getAddress());
        user.setAnhDaiDien(request.getAvatar());
        
        NguoiDung saved = nguoiDungRepository.save(user);
        return mapToUserResponse(saved);
    }

    @Transactional(readOnly = true)
    public UserResponse getProfileById(UUID id) {
        NguoiDung user = nguoiDungRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Người dùng không tồn tại"));
        
        return mapToUserResponse(user);
    }

    private UserResponse mapToUserResponse(NguoiDung user) {
        String primaryRole = user.getVaiTros().stream()
                .findFirst()
                .map(VaiTro::getTen)
                .orElse("TENANT");

        return UserResponse.builder()
                .id(user.getId())
                .name(user.getHoTen())
                .email(user.getEmail())
                .phone(user.getSoDienThoai())
                .address(user.getDiaChi())
                .avatar(user.getAnhDaiDien())
                .role(primaryRole.toLowerCase())
                .createdAt(user.getTaoLuc())
                // .lastLogin(...) // Hiện tại chưa có trường này trong entity
                .build();
    }
}
