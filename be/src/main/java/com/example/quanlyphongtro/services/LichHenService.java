package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.LichHenRequest;
import com.example.quanlyphongtro.dto.LichHenResponse;
import com.example.quanlyphongtro.entity.LichHen;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.TrangThaiLichHen;
import com.example.quanlyphongtro.repository.LichHenRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.services.PermissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.ArrayList;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import jakarta.persistence.criteria.Predicate;
import com.example.quanlyphongtro.dto.PaginatedResponse;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class LichHenService {

    private final LichHenRepository lichHenRepository;
    private final PhongRepository phongRepository;
    private final PermissionService permissionService;
    private final com.example.quanlyphongtro.repository.AuditLogRepository auditLogRepository;

    public PaginatedResponse<LichHenResponse> getAll(UUID nhaTroId, UUID phongId, String trangThai, Pageable pageable) {
        UUID userId = permissionService.requireCurrentUserId();
        List<UUID> accessibleIds = permissionService.getAllAccessibleNhaTroIds(userId);

        Specification<LichHen> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.isNotNull(root.get("phong")));

            if (phongId != null) {
                predicates.add(cb.equal(root.get("phong").get("id"), phongId));
            }
            if (nhaTroId != null) {
                predicates.add(cb.equal(root.get("phong").get("nhaTro").get("id"), nhaTroId));
            }
            if (trangThai != null && !trangThai.isBlank() && !trangThai.equals("all")) {
                predicates.add(cb.equal(root.get("trangThai"), TrangThaiLichHen.valueOf(trangThai)));
            }

            if (accessibleIds != null) {
                if (accessibleIds.isEmpty()) {
                    predicates.add(cb.disjunction());
                } else {
                    predicates.add(root.get("phong").get("nhaTro").get("id").in(accessibleIds));
                }
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<LichHen> page = lichHenRepository.findAll(spec, pageable);
        List<LichHenResponse> data = page.getContent().stream()
                .map(LichHenResponse::fromEntity)
                .collect(Collectors.toList());
        return PaginatedResponse.of(page, data);
    }

    public LichHenResponse getById(UUID id) {
        UUID userId = permissionService.requireCurrentUserId();
        LichHen lichHen = lichHenRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lịch hẹn"));
        if (lichHen.getPhong() != null && !permissionService.canWritePhong(userId, lichHen.getPhong().getId())) {
            throw new RuntimeException("Khong co quyen xem lich hen nay");
        }
        return LichHenResponse.fromEntity(lichHen);
    }

    @Transactional
    public LichHenResponse create(LichHenRequest req) {
        Phong phong = phongRepository.findById(req.getPhongId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));

        LichHen lichHen = new LichHen();
        lichHen.setPhong(phong);
        lichHen.setHoTen(req.getHoTen());
        lichHen.setSoDienThoai(req.getSoDienThoai());
        lichHen.setEmail(req.getEmail());
        lichHen.setNgayHen(req.getNgayHen());
        lichHen.setGhiChu(req.getGhiChu());
        
        if (req.getTrangThai() != null) {
            lichHen.setTrangThai(TrangThaiLichHen.valueOf(req.getTrangThai()));
        } else {
            lichHen.setTrangThai(TrangThaiLichHen.PENDING);
        }

        LichHen saved = lichHenRepository.save(lichHen);
        // Note: create is public (no logged-in user required), audit only if user present
        permissionService.currentUserId().ifPresent(uid -> logAudit(saved, "CREATE", uid));
        return LichHenResponse.fromEntity(saved);
    }

    @Transactional
    public LichHenResponse update(UUID id, LichHenRequest req) {
        UUID userId = permissionService.requireCurrentUserId();
        LichHen lichHen = lichHenRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lịch hẹn"));
        if (lichHen.getPhong() != null && !permissionService.canWritePhong(userId, lichHen.getPhong().getId())) {
            throw new RuntimeException("Khong co quyen cap nhat lich hen nay");
        }

        if (req.getPhongId() != null && !req.getPhongId().equals(lichHen.getPhong().getId())) {
            Phong phong = phongRepository.findById(req.getPhongId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));
            lichHen.setPhong(phong);
        }

        if (req.getHoTen() != null) lichHen.setHoTen(req.getHoTen());
        if (req.getSoDienThoai() != null) lichHen.setSoDienThoai(req.getSoDienThoai());
        if (req.getEmail() != null) lichHen.setEmail(req.getEmail());
        if (req.getNgayHen() != null) lichHen.setNgayHen(req.getNgayHen());
        if (req.getGhiChu() != null) lichHen.setGhiChu(req.getGhiChu());
        if (req.getTrangThai() != null) {
            lichHen.setTrangThai(TrangThaiLichHen.valueOf(req.getTrangThai()));
        }

        LichHen saved = lichHenRepository.save(lichHen);
        logAudit(saved, "UPDATE", userId);
        return LichHenResponse.fromEntity(saved);
    }

    @Transactional
    public LichHenResponse updateStatus(UUID id, String status) {
        UUID userId = permissionService.requireCurrentUserId();
        LichHen lichHen = lichHenRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lịch hẹn"));
        if (lichHen.getPhong() != null && !permissionService.canWritePhong(userId, lichHen.getPhong().getId())) {
            throw new RuntimeException("Khong co quyen cap nhat trang thai lich hen nay");
        }
        
        lichHen.setTrangThai(TrangThaiLichHen.valueOf(status));
        LichHen saved = lichHenRepository.save(lichHen);
        logAudit(saved, "UPDATE_STATUS", userId);
        return LichHenResponse.fromEntity(saved);
    }

    @Transactional
    public void delete(UUID id) {
        UUID userId = permissionService.requireCurrentUserId();
        LichHen lichHen = lichHenRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lịch hẹn"));
        if (lichHen.getPhong() != null && !permissionService.canWritePhong(userId, lichHen.getPhong().getId())) {
            throw new RuntimeException("Khong co quyen xoa lich hen nay");
        }
        logAudit(lichHen, "DELETE", userId);
        lichHenRepository.deleteById(id);
    }

    private void logAudit(LichHen lh, String hanhDong, UUID userId) {
        try {
            com.example.quanlyphongtro.entity.AuditLog log = com.example.quanlyphongtro.entity.AuditLog.builder()
                .nguoiDung(com.example.quanlyphongtro.entity.NguoiDung.builder().id(userId).build())
                .hanhDong(hanhDong)
                .bangTacDong("lich_hen")
                .banGhiId(lh.getId())
                .taoLuc(java.time.ZonedDateTime.now())
                .build();
            auditLogRepository.save(log);
        } catch (Exception e) {
            // Silently fail – audit should not break business flow
        }
    }
}
