package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.AdminUserRequest;
import com.example.quanlyphongtro.dto.ChangePasswordRequest;
import com.example.quanlyphongtro.dto.UserRequest;
import com.example.quanlyphongtro.dto.UserResponse;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.TrangThaiNguoiDung;
import com.example.quanlyphongtro.entity.VaiTro;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.VaiTroRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService {

    private final NguoiDungRepository nguoiDungRepository;
    private final VaiTroRepository vaiTroRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public void changePassword(String email, ChangePasswordRequest request) {
        NguoiDung user = nguoiDungRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Nguoi dung khong ton tai"));

        if (!passwordEncoder.matches(request.getOldPassword(), user.getMatKhau())) {
            throw new RuntimeException("Mat khau hien tai khong chinh xac");
        }

        user.setMatKhau(passwordEncoder.encode(request.getNewPassword()));
        nguoiDungRepository.save(user);
    }

    @Transactional(readOnly = true)
    public List<UserResponse> getAllUsers() {
        return nguoiDungRepository.findByXoaLucIsNullOrderByTaoLucDesc().stream()
                .map(this::mapToUserResponse)
                .toList();
    }

    @Transactional
    public UserResponse createUser(AdminUserRequest request) {
        if (request.getEmail() == null || request.getEmail().isBlank()) {
            throw new RuntimeException("Email khong duoc de trong");
        }
        if (request.getPassword() == null || request.getPassword().isBlank()) {
            throw new RuntimeException("Mat khau khong duoc de trong");
        }

        String email = request.getEmail().trim().toLowerCase();
        if (nguoiDungRepository.existsByEmail(email)) {
            throw new RuntimeException("Email da ton tai trong he thong");
        }

        String phone = normalizeBlank(request.getPhone());
        if (phone != null && nguoiDungRepository.existsBySoDienThoai(phone)) {
            throw new RuntimeException("So dien thoai da ton tai trong he thong");
        }

        VaiTro role = resolveRole(request.getRole() != null ? request.getRole() : "nhanVien");
        Set<VaiTro> roles = new HashSet<>();
        roles.add(role);

        NguoiDung user = NguoiDung.builder()
                .hoTen(normalizeBlank(request.getName()) != null ? request.getName().trim() : email)
                .email(email)
                .matKhau(passwordEncoder.encode(request.getPassword()))
                .soDienThoai(phone)
                .trangThai(Boolean.FALSE.equals(request.getIsActive()) ? TrangThaiNguoiDung.INACTIVE : TrangThaiNguoiDung.ACTIVE)
                .vaiTros(roles)
                .build();

        return mapToUserResponse(nguoiDungRepository.save(user));
    }

    @Transactional
    public UserResponse updateUser(UUID id, AdminUserRequest request) {
        NguoiDung user = findActiveUser(id);

        if (request.getName() != null) {
            user.setHoTen(request.getName().trim());
        }

        if (request.getPhone() != null) {
            String phone = normalizeBlank(request.getPhone());
            if (phone != null && !phone.equals(user.getSoDienThoai()) && nguoiDungRepository.existsBySoDienThoai(phone)) {
                throw new RuntimeException("So dien thoai da ton tai trong he thong");
            }
            user.setSoDienThoai(phone);
        }

        if (request.getRole() != null && !request.getRole().isBlank()) {
            user.getVaiTros().clear();
            user.getVaiTros().add(resolveRole(request.getRole()));
        }

        if (request.getIsActive() != null) {
            user.setTrangThai(request.getIsActive() ? TrangThaiNguoiDung.ACTIVE : TrangThaiNguoiDung.INACTIVE);
        }

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
        NguoiDung user = nguoiDungRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Nguoi dung khong ton tai"));

        return mapToUserResponse(user);
    }

    @Transactional
    public UserResponse updateProfile(String email, UserRequest request) {
        NguoiDung user = nguoiDungRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Nguoi dung khong ton tai"));

        user.setHoTen(request.getName());
        user.setSoDienThoai(request.getPhone());
        user.setDiaChi(request.getAddress());
        user.setAnhDaiDien(request.getAvatar());

        return mapToUserResponse(nguoiDungRepository.save(user));
    }

    @Transactional(readOnly = true)
    public UserResponse getProfileById(UUID id) {
        return mapToUserResponse(findActiveUser(id));
    }

    private NguoiDung findActiveUser(UUID id) {
        NguoiDung user = nguoiDungRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Nguoi dung khong ton tai"));
        if (user.getXoaLuc() != null) {
            throw new RuntimeException("Nguoi dung da bi xoa");
        }
        return user;
    }

    private VaiTro resolveRole(String frontendRole) {
        String dbRole = toDbRole(frontendRole);
        return vaiTroRepository.findByTen(dbRole)
                .orElseGet(() -> vaiTroRepository.save(VaiTro.builder().ten(dbRole).build()));
    }

    private String normalizeBlank(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }

    private String toDbRole(String rawRole) {
        if (rawRole == null || rawRole.isBlank()) {
            return "STAFF";
        }

        return switch (rawRole) {
            case "admin", "ADMIN" -> "ADMIN";
            case "chuNha", "LANDLORD" -> "LANDLORD";
            case "nhanVien", "STAFF" -> "STAFF";
            case "tenant", "TENANT" -> "TENANT";
            default -> "STAFF";
        };
    }

    private String toFrontendRole(String dbRole) {
        if (dbRole == null) {
            return "nhanVien";
        }

        return switch (dbRole) {
            case "ADMIN" -> "admin";
            case "LANDLORD" -> "chuNha";
            case "STAFF" -> "nhanVien";
            case "TENANT" -> "tenant";
            default -> dbRole.toLowerCase();
        };
    }

    private UserResponse mapToUserResponse(NguoiDung user) {
        String primaryRole = user.getVaiTros().stream()
                .findFirst()
                .map(VaiTro::getTen)
                .orElse("TENANT");

        boolean active = user.getTrangThai() == TrangThaiNguoiDung.ACTIVE;

        return UserResponse.builder()
                .id(user.getId())
                .name(user.getHoTen())
                .email(user.getEmail())
                .phone(user.getSoDienThoai())
                .address(user.getDiaChi())
                .avatar(user.getAnhDaiDien())
                .role(toFrontendRole(primaryRole))
                .isActive(active)
                .trangThai(active ? "hoatDong" : "tamKhoa")
                .createdAt(user.getTaoLuc())
                .build();
    }
}
