package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.NguoiDungNhaTro;
import com.example.quanlyphongtro.entity.VaiTroHeThong;
import com.example.quanlyphongtro.repository.NguoiDungNhaTroRepository;
import com.example.quanlyphongtro.repository.NguoiDungVaiTroRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PermissionService {

    private final NguoiDungVaiTroRepository nguoiDungVaiTroRepository;
    private final NguoiDungNhaTroRepository nguoiDungNhaTroRepository;

    public Optional<UUID> currentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof UUID userId) {
            return Optional.of(userId);
        }
        return Optional.empty();
    }

    public UUID requireCurrentUserId() {
        return currentUserId().orElseThrow(() -> new RuntimeException("Vui long dang nhap lai"));
    }

    public boolean isAdmin(UUID userId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null) {
            boolean hasAdminAuthority = authentication.getAuthorities().stream()
                    .map(GrantedAuthority::getAuthority)
                    .anyMatch(authority -> "ROLE_ADMIN".equals(authority) || "ADMIN".equals(authority));
            if (hasAdminAuthority) return true;
        }

        return nguoiDungVaiTroRepository.findByNguoiDungId(userId).stream()
                .anyMatch(role -> role.getVaiTro() != null && role.getVaiTro().getTen() == VaiTroHeThong.ADMIN);
    }

    public boolean canReadNhaTro(UUID userId, UUID nhaTroId, UUID ownerId) {
        if (isAdmin(userId)) return true;
        if (ownerId != null && ownerId.equals(userId)) return true;
        return nguoiDungNhaTroRepository.findByNguoiDungIdAndNhaTroId(userId, nhaTroId)
                .map(permission -> Boolean.TRUE.equals(permission.getCoQuyenXem()) || Boolean.TRUE.equals(permission.getCoQuyenSua()))
                .orElse(false);
    }

    public boolean canWriteNhaTro(UUID userId, UUID nhaTroId, UUID ownerId) {
        if (isAdmin(userId)) return true;
        if (ownerId != null && ownerId.equals(userId)) return true;
        return nguoiDungNhaTroRepository.findByNguoiDungIdAndNhaTroId(userId, nhaTroId)
                .map(permission -> Boolean.TRUE.equals(permission.getCoQuyenSua()))
                .orElse(false);
    }

    public List<UUID> accessibleNhaTroIds(UUID userId) {
        if (isAdmin(userId)) return List.of();

        List<UUID> assignedIds = nguoiDungNhaTroRepository.findByNguoiDungId(userId).stream()
                .filter(permission -> Boolean.TRUE.equals(permission.getCoQuyenXem()) || Boolean.TRUE.equals(permission.getCoQuyenSua()))
                .map(NguoiDungNhaTro::getNhaTro)
                .filter(nhaTro -> nhaTro != null && nhaTro.getId() != null)
                .map(nhaTro -> nhaTro.getId())
                .toList();
        return assignedIds;
    }
}
