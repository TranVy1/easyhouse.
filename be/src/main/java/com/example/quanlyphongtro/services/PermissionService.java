package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.NguoiDungNhaTro;
import com.example.quanlyphongtro.entity.VaiTroHeThong;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.TrangThaiHopDong;
import com.example.quanlyphongtro.repository.NguoiDungNhaTroRepository;
import com.example.quanlyphongtro.repository.NguoiDungVaiTroRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.KhachThueRepository;
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
    private final NhaTroRepository nhaTroRepository;
    private final NguoiDungNhaTroRepository nguoiDungNhaTroRepository;
    private final PhongRepository phongRepository;
    private final HopDongRepository hopDongRepository;
    private final HoaDonRepository hoaDonRepository;
    private final KhachThueRepository khachThueRepository;

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

    public void requireAdmin() {
        if (!isAdmin(requireCurrentUserId())) {
            throw new RuntimeException("Quyen truy cap bi tu choi. Yeu cau quyen ADMIN.");
        }
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

    public List<UUID> accessibleNhaTroIdsForQuery(UUID userId) {
        return accessibleNhaTroIds(userId); // Alias for clarity
    }

    public boolean canReadPhong(UUID userId, UUID phongId) {
        if (isAdmin(userId)) return true;
        Phong phong = phongRepository.findById(phongId).orElse(null);
        if (phong == null) return false;
        
        // Tenant check
        if (hopDongRepository.findRoomOccupyingContracts(phongId, List.of(TrangThaiHopDong.ACTIVE)).stream()
                .anyMatch(hd -> hd.getKhachThue() != null && hd.getKhachThue().getNguoiDung() != null 
                        && hd.getKhachThue().getNguoiDung().getId().equals(userId))) {
            return true;
        }

        UUID nhaTroId = phong.getNhaTro() != null ? phong.getNhaTro().getId() : null;
        UUID ownerId = phong.getNhaTro() != null && phong.getNhaTro().getChuTro() != null ? phong.getNhaTro().getChuTro().getId() : null;
        return nhaTroId != null && canReadNhaTro(userId, nhaTroId, ownerId);
    }

    public boolean canWritePhong(UUID userId, UUID phongId) {
        if (isAdmin(userId)) return true;
        Phong phong = phongRepository.findById(phongId).orElse(null);
        if (phong == null) return false;
        
        UUID nhaTroId = phong.getNhaTro() != null ? phong.getNhaTro().getId() : null;
        UUID ownerId = phong.getNhaTro() != null && phong.getNhaTro().getChuTro() != null ? phong.getNhaTro().getChuTro().getId() : null;
        return nhaTroId != null && canWriteNhaTro(userId, nhaTroId, ownerId);
    }

    public boolean canReadHopDong(UUID userId, UUID hopDongId) {
        if (isAdmin(userId)) return true;
        HopDong hd = hopDongRepository.findById(hopDongId).orElse(null);
        if (hd == null) return false;
        
        if (hd.getKhachThue() != null && hd.getKhachThue().getNguoiDung() != null && hd.getKhachThue().getNguoiDung().getId().equals(userId)) {
            return true;
        }
        
        return hd.getPhong() != null && canReadPhong(userId, hd.getPhong().getId());
    }

    public boolean canWriteHopDong(UUID userId, UUID hopDongId) {
        if (isAdmin(userId)) return true;
        HopDong hd = hopDongRepository.findById(hopDongId).orElse(null);
        if (hd == null) return false;
        
        return hd.getPhong() != null && canWritePhong(userId, hd.getPhong().getId());
    }

    public boolean canReadHoaDon(UUID userId, UUID hoaDonId) {
        if (isAdmin(userId)) return true;
        HoaDon hd = hoaDonRepository.findById(hoaDonId).orElse(null);
        if (hd == null) return false;
        
        if (hd.getKhachThue() != null && hd.getKhachThue().getNguoiDung() != null && hd.getKhachThue().getNguoiDung().getId().equals(userId)) {
            return true;
        }
        
        return hd.getPhong() != null && canReadPhong(userId, hd.getPhong().getId());
    }

    public boolean canWriteHoaDon(UUID userId, UUID hoaDonId) {
        if (isAdmin(userId)) return true;
        HoaDon hd = hoaDonRepository.findById(hoaDonId).orElse(null);
        if (hd == null) return false;
        
        return hd.getPhong() != null && canWritePhong(userId, hd.getPhong().getId());
    }

    public boolean canReadKhachThue(UUID userId, UUID khachThueId) {
        if (isAdmin(userId)) return true;
        KhachThue kt = khachThueRepository.findById(khachThueId).orElse(null);
        if (kt == null) return false;
        
        if (kt.getNguoiDung() != null && kt.getNguoiDung().getId().equals(userId)) {
            return true;
        }
        
        // Non-tenant must have read access to one of the rooms rented by this tenant
        List<HopDong> hds = hopDongRepository.findByKhachThueIdAndXoaLucIsNull(khachThueId);
        for (HopDong hd : hds) {
            if (hd.getPhong() != null && canReadPhong(userId, hd.getPhong().getId())) {
                return true;
            }
        }
        
        return false;
    }
    public List<UUID> getAllAccessibleNhaTroIds(UUID userId) {
        if (isAdmin(userId)) return null; // null means ALL

        List<UUID> assignedIds = accessibleNhaTroIds(userId);
        List<UUID> ownedIds = nhaTroRepository.findByChuTroIdAndXoaLucIsNull(userId).stream()
                .map(nhaTro -> nhaTro.getId())
                .toList();

        java.util.Set<UUID> allIds = new java.util.HashSet<>();
        if (assignedIds != null) allIds.addAll(assignedIds);
        if (ownedIds != null) allIds.addAll(ownedIds);
        
        return new java.util.ArrayList<>(allIds);
    }
}
