package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.AdminUserRequest;
import com.example.quanlyphongtro.dto.ChangePasswordRequest;
import com.example.quanlyphongtro.dto.UserRequest;
import com.example.quanlyphongtro.dto.UserResponse;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.TrangThaiNguoiDung;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService {

    private final NguoiDungRepository nguoiDungRepository;

    @Transactional(readOnly = true)
    public List<UserResponse> getAllUsers() {
        return nguoiDungRepository.findByXoaLucIsNullOrderByTaoLucDesc().stream()
                .map(this::mapToUserResponse).toList();
    }

    @Transactional
    public UserResponse createUser(AdminUserRequest request) {
        UUID authUserId = request.getAuthUserId() != null ? request.getAuthUserId() : request.getSupabaseUserId();
        if (authUserId == null)
            throw new RuntimeException("authUserId bat buoc vi nguoi_dung.id tham chieu Supabase auth.users(id)");

        if (request.getEmail() == null || request.getEmail().isBlank())
            throw new RuntimeException("Email khong duoc de trong");

        String email = request.getEmail().trim().toLowerCase();
        if (nguoiDungRepository.existsByEmail(email))
            throw new RuntimeException("Email da ton tai trong he thong");

        String phone = normalizeBlank(request.getPhone());
        if (phone != null && nguoiDungRepository.existsBySoDienThoai(phone))
            throw new RuntimeException("So dien thoai da ton tai trong he thong");

        NguoiDung user = NguoiDung.builder()
                .id(authUserId)
                .hoTen(normalizeBlank(request.getName()) != null ? request.getName().trim() : email)
                .email(email)
                .soDienThoai(phone)
                .trangThai(Boolean.FALSE.equals(request.getIsActive()) ? TrangThaiNguoiDung.INACTIVE : TrangThaiNguoiDung.ACTIVE)
                .build();

        return mapToUserResponse(nguoiDungRepository.save(user));
    }

    @Transactional
    public UserResponse updateUser(UUID id, AdminUserRequest request) {
        NguoiDung user = findActiveUser(id);
        if (request.getName() != null) user.setHoTen(request.getName().trim());
        if (request.getPhone() != null) {
            String phone = normalizeBlank(request.getPhone());
            if (phone != null && !phone.equals(user.getSoDienThoai()) && nguoiDungRepository.existsBySoDienThoai(phone))
                throw new RuntimeException("So dien thoai da ton tai trong he thong");
            user.setSoDienThoai(phone);
        }
        if (request.getIsActive() != null)
            user.setTrangThai(request.getIsActive() ? TrangThaiNguoiDung.ACTIVE : TrangThaiNguoiDung.INACTIVE);
        return mapToUserResponse(nguoiDungRepository.save(user));
    }

    @Transactional
    public void deleteUser(UUID id) {
        NguoiDung user = findActiveUser(id);
        user.setXoaLuc(ZonedDateTime.now());
        nguoiDungRepository.save(user);
    }

    @Transactional(readOnly = true)
    public UserResponse getProfileByEmail(String email) {
        return mapToUserResponse(nguoiDungRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Nguoi dung khong ton tai")));
    }

    @Transactional
    public UserResponse updateProfile(String email, UserRequest request) {
        NguoiDung user = nguoiDungRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Nguoi dung khong ton tai"));
        if (request.getName() != null) user.setHoTen(request.getName());
        if (request.getPhone() != null) user.setSoDienThoai(request.getPhone());
        if (request.getAvatar() != null) user.setAnhDaiDien(request.getAvatar());
        return mapToUserResponse(nguoiDungRepository.save(user));
    }

    @Transactional(readOnly = true)
    public UserResponse getProfileById(UUID id) {
        return mapToUserResponse(findActiveUser(id));
    }

    public void changePassword(String email, ChangePasswordRequest request) {
        // Simplified - no password in NguoiDung entity in new schema
        // Auth is handled externally (Supabase / simplified)
        throw new RuntimeException("Password management is handled by external auth provider");
    }

    private NguoiDung findActiveUser(UUID id) {
        NguoiDung user = nguoiDungRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Nguoi dung khong ton tai"));
        if (user.getXoaLuc() != null) throw new RuntimeException("Nguoi dung da bi xoa");
        return user;
    }

    private String normalizeBlank(String v) { return v == null || v.isBlank() ? null : v.trim(); }

    private UserResponse mapToUserResponse(NguoiDung user) {
        boolean active = user.getTrangThai() == TrangThaiNguoiDung.ACTIVE;
        return UserResponse.builder()
                .id(user.getId())
                .name(user.getHoTen())
                .email(user.getEmail())
                .phone(user.getSoDienThoai())
                .avatar(user.getAnhDaiDien())
                .role("chuNha") // Simplified role
                .isActive(active)
                .trangThai(active ? "hoatDong" : "tamKhoa")
                .createdAt(user.getTaoLuc())
                .build();
    }
}
