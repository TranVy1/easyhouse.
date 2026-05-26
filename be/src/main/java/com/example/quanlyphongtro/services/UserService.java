package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.AdminUserRequest;
import com.example.quanlyphongtro.dto.ChangePasswordRequest;
import com.example.quanlyphongtro.dto.UserRequest;
import com.example.quanlyphongtro.dto.UserResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.example.quanlyphongtro.dto.UserRoleAssignmentRequest;
import com.example.quanlyphongtro.dto.UserBuildingAssignmentRequest;

@Service
@RequiredArgsConstructor
public class UserService {

    private final NguoiDungRepository nguoiDungRepository;
    private final VaiTroRepository vaiTroRepository;
    private final NguoiDungVaiTroRepository nguoiDungVaiTroRepository;
    private final NhaTroRepository nhaTroRepository;
    private final NguoiDungNhaTroRepository nguoiDungNhaTroRepository;
    private final PermissionService permissionService;
    private final AuditLogRepository auditLogRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public List<UserResponse> getAllUsers() {
        permissionService.requireAdmin();
        return nguoiDungRepository.findByXoaLucIsNullOrderByTaoLucDesc().stream()
                .map(this::mapToUserResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public UserResponse createUser(AdminUserRequest request) {
        permissionService.requireAdmin();
        UUID authUserId = request.getAuthUserId() != null ? request.getAuthUserId() : request.getSupabaseUserId();
        if (authUserId == null) {
            throw new RuntimeException("authUserId la bat buoc vi nguoi_dung.id tham chieu auth.users(id)");
        }
        if (request.getEmail() == null || request.getEmail().isBlank()) {
            throw new RuntimeException("Email khong duoc de trong");
        }

        String email = request.getEmail().trim().toLowerCase();
        if (nguoiDungRepository.existsByEmail(email)) {
            throw new RuntimeException("Email da ton tai trong he thong");
        }

        String phone = normalizeBlank(request.getPhone());
        if (phone != null && nguoiDungRepository.existsBySoDienThoai(phone)) {
            throw new RuntimeException("So dien thoai da ton tai trong he thong");
        }

        NguoiDung user = NguoiDung.builder()
                .id(authUserId)
                .hoTen(normalizeBlank(request.getName()) != null ? request.getName().trim() : email)
                .email(email)
                .soDienThoai(phone)
                .trangThai(Boolean.FALSE.equals(request.getIsActive()) ? TrangThaiNguoiDung.INACTIVE : TrangThaiNguoiDung.ACTIVE)
                .build();

        NguoiDung saved = nguoiDungRepository.save(user);
        logAudit(saved, "CREATE");
        return mapToUserResponse(saved);
    }

    @Transactional
    public UserResponse updateUser(UUID id, AdminUserRequest request) {
        permissionService.requireAdmin();
        NguoiDung user = findActiveUser(id);
        if (request.getName() != null) user.setHoTen(request.getName().trim());
        if (request.getPhone() != null) {
            String phone = normalizeBlank(request.getPhone());
            if (phone != null && !phone.equals(user.getSoDienThoai()) && nguoiDungRepository.existsBySoDienThoai(phone)) {
                throw new RuntimeException("So dien thoai da ton tai trong he thong");
            }
            user.setSoDienThoai(phone);
        }
        if (request.getIsActive() != null) {
            user.setTrangThai(request.getIsActive() ? TrangThaiNguoiDung.ACTIVE : TrangThaiNguoiDung.INACTIVE);
        }
        NguoiDung saved = nguoiDungRepository.save(user);
        logAudit(saved, "UPDATE");
        return mapToUserResponse(saved);
    }

    @Transactional
    public void deleteUser(UUID id) {
        permissionService.requireAdmin();
        NguoiDung user = findActiveUser(id);
        user.setXoaLuc(ZonedDateTime.now());
        nguoiDungRepository.save(user);
        logAudit(user, "DELETE");
    }

    @Transactional(readOnly = true)
    public UserResponse getProfileByEmail(String email) {
        return mapToUserResponse(nguoiDungRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Nguoi dung khong ton tai")));
    }

    @Transactional(readOnly = true)
    public UserResponse getProfileById(UUID id) {
        return mapToUserResponse(findActiveUser(id));
    }

    @Transactional
    public UserResponse updateProfile(String email, UserRequest request) {
        NguoiDung user = nguoiDungRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Nguoi dung khong ton tai"));
        applyProfileRequest(user, request);
        return mapToUserResponse(nguoiDungRepository.save(user));
    }

    @Transactional
    public UserResponse updateProfile(UUID id, UserRequest request) {
        NguoiDung user = findActiveUser(id);
        applyProfileRequest(user, request);
        return mapToUserResponse(nguoiDungRepository.save(user));
    }

    @Transactional
    public void changePassword(UUID id, ChangePasswordRequest request) {
        if (request == null || request.getOldPassword() == null || request.getNewPassword() == null) {
            throw new RuntimeException("Vui long nhap day du mat khau hien tai va mat khau moi");
        }
        if (request.getNewPassword().length() < 8) {
            throw new RuntimeException("Mat khau moi phai co it nhat 8 ky tu");
        }
        NguoiDung user = findActiveUser(id);
        if (user.getMatKhau() == null || !passwordEncoder.matches(request.getOldPassword(), user.getMatKhau())) {
            throw new RuntimeException("Mat khau hien tai khong dung");
        }
        user.setMatKhau(passwordEncoder.encode(request.getNewPassword()));
        nguoiDungRepository.save(user);
    }

    private void applyProfileRequest(NguoiDung user, UserRequest request) {
        if (request.getName() != null) user.setHoTen(request.getName());
        if (request.getPhone() != null) user.setSoDienThoai(request.getPhone());
        if (request.getAvatar() != null) user.setAnhDaiDien(request.getAvatar());
    }

    private NguoiDung findActiveUser(UUID id) {
        NguoiDung user = nguoiDungRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Nguoi dung khong ton tai"));
        if (user.getXoaLuc() != null) throw new RuntimeException("Nguoi dung da bi xoa");
        return user;
    }

    private String normalizeBlank(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }

    private UserResponse mapToUserResponse(NguoiDung user) {
        boolean active = user.getTrangThai() == TrangThaiNguoiDung.ACTIVE;
        return UserResponse.builder()
                .id(user.getId())
                .name(user.getHoTen())
                .email(user.getEmail())
                .phone(user.getSoDienThoai())
                .avatar(user.getAnhDaiDien())
                .role(resolveRole(user))
                .isActive(active)
                .trangThai(active ? "hoatDong" : "tamKhoa")
                .createdAt(user.getTaoLuc())
                .build();
    }

    private String resolveRole(NguoiDung user) {
        try {
            List<NguoiDungVaiTro> roles = nguoiDungVaiTroRepository.findByNguoiDungId(user.getId());
            if (!roles.isEmpty()) {
                return roles.get(0).getVaiTro().getTen().name();
            }
        } catch (Exception e) {
            // ignore
        }
        return "chuNha"; // fallback
    }

    @Transactional
    public void assignRoles(UUID userId, UserRoleAssignmentRequest request) {
        permissionService.requireAdmin();
        NguoiDung user = findActiveUser(userId);
        
        // Remove existing roles
        List<NguoiDungVaiTro> existingRoles = nguoiDungVaiTroRepository.findByNguoiDungId(userId);
        nguoiDungVaiTroRepository.deleteAll(existingRoles);
        
        // Add new roles
        if (request.getRoles() != null) {
            for (VaiTroHeThong roleEnum : request.getRoles()) {
                VaiTro vaiTro = vaiTroRepository.findByTen(roleEnum)
                        .orElseGet(() -> {
                            VaiTro newRole = VaiTro.builder()
                                    .ten(roleEnum)
                                    .moTa("Quyền " + roleEnum.name())
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
        }
    }

    @Transactional
    public void assignBuildings(UUID userId, UserBuildingAssignmentRequest request) {
        permissionService.requireAdmin();
        NguoiDung user = findActiveUser(userId);
        
        // Remove existing assignments
        List<NguoiDungNhaTro> existingAssignments = nguoiDungNhaTroRepository.findByNguoiDungId(userId);
        nguoiDungNhaTroRepository.deleteAll(existingAssignments);
        
        // Add new assignments
        if (request.getAssignments() != null) {
            for (UserBuildingAssignmentRequest.BuildingAssignment assignment : request.getAssignments()) {
                NhaTro nhaTro = nhaTroRepository.findById(assignment.getNhaTroId())
                        .orElseThrow(() -> new RuntimeException("Không tìm thấy tòa nhà: " + assignment.getNhaTroId()));
                
                NguoiDungNhaTro ndnt = NguoiDungNhaTro.builder()
                        .nguoiDung(user)
                        .nhaTro(nhaTro)
                        .vaiTro(assignment.getVaiTro() != null ? assignment.getVaiTro() : VaiTroHeThong.STAFF)
                        .coQuyenXem(assignment.getCoQuyenXem() != null ? assignment.getCoQuyenXem() : true)
                        .coQuyenSua(assignment.getCoQuyenSua() != null ? assignment.getCoQuyenSua() : false)
                        .coQuyenThuTien(assignment.getCoQuyenThuTien() != null ? assignment.getCoQuyenThuTien() : false)
                        .taoLuc(ZonedDateTime.now())
                        .build();
                nguoiDungNhaTroRepository.save(ndnt);
            }
        }
    }

    private void logAudit(NguoiDung targetUser, String hanhDong) {
        try {
            UUID adminId = permissionService.requireCurrentUserId();
            AuditLog log = AuditLog.builder()
                .nguoiDung(NguoiDung.builder().id(adminId).build())
                .hanhDong(hanhDong)
                .bangTacDong("nguoi_dung")
                .banGhiId(targetUser.getId())
                .taoLuc(ZonedDateTime.now())
                .build();
            auditLogRepository.save(log);
        } catch (Exception ignored) {
            // Audit should not break admin flow
        }
    }
}
