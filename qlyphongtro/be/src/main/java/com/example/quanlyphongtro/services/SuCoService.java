package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.SuCoRequest;
import com.example.quanlyphongtro.dto.SuCoResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SuCoService {

    private final SuCoRepository suCoRepository;
    private final PhongRepository phongRepository;
    private final KhachThueRepository khachThueRepository;
    private final HopDongRepository hopDongRepository;
    private final MediaService mediaService;
    private final PermissionService permissionService;
    private final com.example.quanlyphongtro.repository.AuditLogRepository auditLogRepository;
    private final NguoiDungRepository nguoiDungRepository;

    public PaginatedResponse<SuCoResponse> getAllSuCo(
            UUID nhaTroId, UUID phongId, String trangThai, String loaiSuCo, String uuTien, Pageable pageable) {
        UUID userId = permissionService.requireCurrentUserId();
        boolean isAdmin = permissionService.isAdmin(userId);
        List<UUID> accessibleIds = permissionService.getAllAccessibleNhaTroIds(userId);
        List<UUID> scopedIds = accessibleIds == null ? List.of() : accessibleIds;
        String status = isEmptyFilter(trangThai) ? null : TrangThaiSuCo.valueOf(trangThai).name();
        String type = isEmptyFilter(loaiSuCo) ? null : LoaiSuCo.fromDbValue(loaiSuCo).getDbValue();
        String priority = isEmptyFilter(uuTien) ? null : UuTien.fromDbValue(uuTien).getDbValue();
        Page<SuCo> page = suCoRepository.findAllAccessible(
                isAdmin, userId, scopedIds, nhaTroId, phongId, status, type, priority, pageable);
        return PaginatedResponse.of(page, page.getContent().stream().map(this::toResponse).toList());
    }

    public SuCoResponse getSuCoById(UUID id) {
        SuCo sc = suCoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sự cố"));
        UUID userId = permissionService.requireCurrentUserId();
        if (sc.getPhong() != null && !permissionService.canReadPhong(userId, sc.getPhong().getId())) {
            throw new RuntimeException("Khong co quyen truy cap su co nay");
        }
        return toResponse(sc);
    }

    @Transactional
    public SuCoResponse createSuCo(SuCoRequest req) {
        UUID userId = permissionService.requireCurrentUserId();
        if (req.getPhongId() == null || !permissionService.canReadPhong(userId, req.getPhongId())) {
            throw new RuntimeException("Khong co quyen bao cao su co cho phong nay");
        }
        Phong phong = req.getPhongId() != null ? phongRepository.findById(req.getPhongId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng")) : null;
        boolean canManage = permissionService.canWritePhong(userId, req.getPhongId());
        KhachThue kt;
        if (canManage) {
            kt = req.getKhachThueId() != null ? khachThueRepository.findById(req.getKhachThueId()).orElse(null) : null;
        } else {
            if (req.getGhiChuChuNha() != null || req.getChiPhiSuaChua() != null) {
                throw new RuntimeException("Khong co quyen nhap ghi chu chu nha hoac chi phi su co");
            }
            kt = currentTenantForRoom(userId, req.getPhongId());
            if (req.getKhachThueId() != null && !req.getKhachThueId().equals(kt.getId())) {
                throw new RuntimeException("Khong co quyen bao cao su co cho khach thue khac");
            }
        }

        SuCo sc = SuCo.builder()
                .phong(phong).khachThue(kt)
                .nguoiBao(nguoiDungRepository.findById(userId)
                        .orElseThrow(() -> new RuntimeException("Khong tim thay nguoi dung hien tai")))
                .tieuDe(req.getTieuDe()).moTa(req.getMoTa())
                .loaiSuCo(parseLoai(req.getLoaiSuCo()))
                .uuTien(parseUuTien(req.getUuTien()))
                .trangThai(TrangThaiSuCo.PENDING)
                .ghiChuChuNha(canManage ? req.getGhiChuChuNha() : null)
                .chiPhiSuaChua(canManage && req.getChiPhiSuaChua() != null ? req.getChiPhiSuaChua() : BigDecimal.ZERO)
                .build();
        SuCo saved = suCoRepository.save(sc);
        mediaService.replaceUrls(LoaiDoiTuongMedia.INCIDENT, saved.getId(), req.getAnhSuCo(), MediaService.INCIDENT_IMAGE);
        logAudit(saved, "CREATE");
        return toResponse(saved);
    }

    @Transactional
    public SuCoResponse updateSuCo(UUID id, SuCoRequest req) {
        UUID userId = permissionService.requireCurrentUserId();
        SuCo sc = suCoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sự cố"));
        
        // Allow tenant to update their own incident if pending, otherwise require write permission
        boolean isCreatorAndPending = sc.getNguoiBao() != null && userId.equals(sc.getNguoiBao().getId())
                && sc.getTrangThai() == TrangThaiSuCo.PENDING;
        
        if (!permissionService.canWritePhong(userId, sc.getPhong() != null ? sc.getPhong().getId() : null)) {
            if (!isCreatorAndPending) {
                throw new RuntimeException("Khong co quyen cap nhat su co nay");
            }
            // If tenant, they cannot update admin fields
            if (req.getTrangThai() != null || req.getGhiChuChuNha() != null || req.getChiPhiSuaChua() != null) {
                throw new RuntimeException("Khong co quyen cap nhat trang thai hoac chi phi su co");
            }
        }
        
        if (req.getPhongId() != null && sc.getPhong() != null && !req.getPhongId().equals(sc.getPhong().getId())) {
            throw new RuntimeException("Khong the doi phong cua su co sau khi tao");
        }
        if (req.getKhachThueId() != null && (sc.getKhachThue() == null || !req.getKhachThueId().equals(sc.getKhachThue().getId()))) {
            throw new RuntimeException("Khong the doi khach thue cua su co sau khi tao");
        }
        if (req.getTieuDe() != null) sc.setTieuDe(req.getTieuDe());
        if (req.getMoTa() != null) sc.setMoTa(req.getMoTa());
        if (req.getGhiChuChuNha() != null) sc.setGhiChuChuNha(req.getGhiChuChuNha());
        if (req.getChiPhiSuaChua() != null) sc.setChiPhiSuaChua(req.getChiPhiSuaChua());
        if (req.getLoaiSuCo() != null) sc.setLoaiSuCo(parseLoai(req.getLoaiSuCo()));
        if (req.getUuTien() != null) sc.setUuTien(parseUuTien(req.getUuTien()));
        if (req.getTrangThai() != null) {
            TrangThaiSuCo ns = TrangThaiSuCo.valueOf(req.getTrangThai());
            sc.setTrangThai(ns);
            if (ns == TrangThaiSuCo.RESOLVED && sc.getGiaiQuyetLuc() == null) sc.setGiaiQuyetLuc(ZonedDateTime.now());
        }
        SuCo saved = suCoRepository.save(sc);
        mediaService.replaceUrls(LoaiDoiTuongMedia.INCIDENT, saved.getId(), req.getAnhSuCo(), MediaService.INCIDENT_IMAGE);
        logAudit(saved, "UPDATE");
        return toResponse(saved);
    }

    @Transactional
    public void deleteSuCo(UUID id) {
        UUID userId = permissionService.requireCurrentUserId();
        SuCo sc = suCoRepository.findById(id).orElseThrow(() -> new RuntimeException("Không tìm thấy sự cố"));
        if (sc.getPhong() != null && !permissionService.canWritePhong(userId, sc.getPhong().getId())) {
            throw new RuntimeException("Khong co quyen xoa su co nay");
        }
        sc.setTrangThai(TrangThaiSuCo.CANCELLED);
        SuCo saved = suCoRepository.save(sc);
        logAudit(saved, "CANCEL");
    }

    private LoaiSuCo parseLoai(String s) {
        return LoaiSuCo.fromDbValue(s);
    }
    private UuTien parseUuTien(String s) {
        return UuTien.fromDbValue(s);
    }

    private boolean isEmptyFilter(String filter) {
        return filter == null || filter.isBlank() || "all".equalsIgnoreCase(filter);
    }

    private KhachThue currentTenantForRoom(UUID userId, UUID phongId) {
        return hopDongRepository.findRoomOccupyingContracts(phongId, List.of(TrangThaiHopDong.ACTIVE)).stream()
                .map(HopDong::getKhachThue)
                .filter(kt -> kt != null && kt.getNguoiDung() != null && userId.equals(kt.getNguoiDung().getId()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Chi khach thue dang thue phong moi duoc bao cao su co"));
    }

    private SuCoResponse toResponse(SuCo suCo) {
        SuCoResponse response = SuCoResponse.fromEntity(suCo);
        response.setAnhSuCo(mediaService.listUrls(LoaiDoiTuongMedia.INCIDENT, suCo.getId(), MediaService.INCIDENT_IMAGE));
        return response;
    }



    private void logAudit(SuCo sc, String hanhDong) {
        if (auditLogRepository == null) return;
        com.example.quanlyphongtro.entity.AuditLog log = com.example.quanlyphongtro.entity.AuditLog.builder()
            .nguoiDung(com.example.quanlyphongtro.entity.NguoiDung.builder().id(permissionService.requireCurrentUserId()).build())
            .hanhDong(hanhDong)
            .bangTacDong("su_co")
            .banGhiId(sc.getId())
            .taoLuc(java.time.ZonedDateTime.now())
            .build();
        auditLogRepository.save(log);
    }
}
