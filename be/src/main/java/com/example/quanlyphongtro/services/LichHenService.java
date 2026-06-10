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
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.ArrayList;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import jakarta.persistence.criteria.Predicate;
import com.example.quanlyphongtro.dto.PaginatedResponse;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class LichHenService {

    private final LichHenRepository lichHenRepository;
    private final PhongRepository phongRepository;
    private final PermissionService permissionService;
    private final com.example.quanlyphongtro.repository.AuditLogRepository auditLogRepository;
    private final ThongBaoService thongBaoService;
    private final EmailService emailService;
    private final ConcurrentMap<String, List<Instant>> publicRequestsByIp = new ConcurrentHashMap<>();

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
        return create(req, null);
    }

    @Transactional
    public LichHenResponse create(LichHenRequest req, String sourceIp) {
        if (req.getHoneypot() != null && !req.getHoneypot().isBlank()) {
            throw new RuntimeException("Yeu cau dat lich khong hop le");
        }
        if (req.getPhongId() == null || req.getNgayHen() == null || req.getNgayHen().isBefore(java.time.ZonedDateTime.now())) {
            throw new RuntimeException("Thong tin lich hen khong hop le");
        }
        
        if (req.getHoTen() == null || req.getHoTen().trim().isEmpty() || req.getHoTen().length() > 100) {
            throw new RuntimeException("Ho ten khong hop le");
        }
        
        if (req.getSoDienThoai() == null || !req.getSoDienThoai().matches("^\\+?[0-9]{9,15}$")) {
            throw new RuntimeException("So dien thoai khong hop le");
        }
        
        if (req.getEmail() != null && !req.getEmail().trim().isEmpty() && !req.getEmail().matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$")) {
            throw new RuntimeException("Email khong hop le");
        }

        if (req.getGhiChu() != null && req.getGhiChu().length() > 500) {
            throw new RuntimeException("Ghi chu qua dai (toi da 500 ky tu)");
        }

        Phong phong = phongRepository.findById(req.getPhongId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));

        if (phong.getXoaLuc() != null) {
            throw new RuntimeException("Phong nay da bi xoa");
        }

        UUID currentUserId = permissionService.currentUserId().orElse(null);
        if (currentUserId == null) {
            if (phong.getTrangThai() != com.example.quanlyphongtro.entity.TrangThaiPhong.AVAILABLE) {
                throw new RuntimeException("Phong nay khong cho phep dat lich (Khong o trang thai TRONG)");
            }
            
            // Basic Anti-spam: Rate limit by phone number for public users
            long pendingCount = lichHenRepository.countBySoDienThoaiAndTrangThai(req.getSoDienThoai(), TrangThaiLichHen.PENDING);
            if (pendingCount >= 3) {
                throw new RuntimeException("Ban co qua nhieu lich hen dang cho xac nhan. Vui long cho hoac lien he truc tiep.");
            }
            enforcePublicIpRateLimit(sourceIp);
        }

        LichHen lichHen = new LichHen();
        lichHen.setPhong(phong);
        lichHen.setHoTen(req.getHoTen());
        lichHen.setSoDienThoai(req.getSoDienThoai());
        lichHen.setEmail(req.getEmail());
        lichHen.setNgayHen(req.getNgayHen());
        lichHen.setGhiChu(req.getGhiChu());
        lichHen.setGhiChuAdmin(req.getGhiChuAdmin());
        
        lichHen.setTrangThai(TrangThaiLichHen.PENDING);

        LichHen saved = lichHenRepository.save(lichHen);
        logAudit(saved, "CREATE", currentUserId);

        // Send In-App notification to Landlord (owner of the building)
        if (phong.getNhaTro() != null && phong.getNhaTro().getChuTro() != null) {
            UUID landlordId = phong.getNhaTro().getChuTro().getId();
            String title = "Lịch hẹn xem phòng mới";
            String content = String.format("Khách hàng %s đã đặt lịch xem phòng %s vào lúc %s. Số điện thoại: %s.",
                    saved.getHoTen(),
                    phong.getTen(),
                    saved.getNgayHen().toString(),
                    saved.getSoDienThoai());
            try {
                thongBaoService.createSystemNotification(title, content, com.example.quanlyphongtro.entity.LoaiThongBao.APPOINTMENT, List.of(landlordId));
                log.info("Created system notification for landlord {} about new appointment {}", landlordId, saved.getId());
            } catch (Exception e) {
                log.error("Failed to create system notification for landlord {}: {}", landlordId, e.getMessage());
            }
        }

        // Send Email confirmation to Guest if email is provided
        if (saved.getEmail() != null && !saved.getEmail().isBlank()) {
            try {
                emailService.sendAppointmentCreatedEmail(saved);
            } catch (Exception e) {
                log.error("Failed to send appointment confirmation email to {}: {}", saved.getEmail(), e.getMessage());
            }
        }

        return LichHenResponse.fromEntity(saved);
    }

    private void enforcePublicIpRateLimit(String sourceIp) {
        if (sourceIp == null || sourceIp.isBlank()) {
            return;
        }
        Instant cutoff = Instant.now().minus(15, ChronoUnit.MINUTES);
        List<Instant> requestTimes = publicRequestsByIp.computeIfAbsent(sourceIp, key -> new ArrayList<>());
        synchronized (requestTimes) {
            requestTimes.removeIf(time -> time.isBefore(cutoff));
            if (requestTimes.size() >= 5) {
                throw new RuntimeException("Ban da gui qua nhieu yeu cau. Vui long thu lai sau.");
            }
            requestTimes.add(Instant.now());
        }
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
            if (!permissionService.canWritePhong(userId, req.getPhongId())) {
                throw new RuntimeException("Khong co quyen chuyen lich hen sang phong nay");
            }
            Phong phong = phongRepository.findById(req.getPhongId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));
            lichHen.setPhong(phong);
        }

        if (req.getHoTen() != null) lichHen.setHoTen(req.getHoTen());
        if (req.getSoDienThoai() != null) lichHen.setSoDienThoai(req.getSoDienThoai());
        if (req.getEmail() != null) lichHen.setEmail(req.getEmail());
        if (req.getNgayHen() != null) lichHen.setNgayHen(req.getNgayHen());
        if (req.getGhiChu() != null) lichHen.setGhiChu(req.getGhiChu());
        if (req.getGhiChuAdmin() != null) lichHen.setGhiChuAdmin(req.getGhiChuAdmin());
        boolean isConfirming = false;
        if (req.getTrangThai() != null) {
            TrangThaiLichHen targetStatus = TrangThaiLichHen.valueOf(req.getTrangThai());
            validateTransition(lichHen.getTrangThai(), targetStatus);
            if (lichHen.getTrangThai() == TrangThaiLichHen.PENDING && targetStatus == TrangThaiLichHen.CONFIRMED) {
                isConfirming = true;
            }
            lichHen.setTrangThai(targetStatus);
        }

        LichHen saved = lichHenRepository.save(lichHen);
        logAudit(saved, "UPDATE", userId);

        if (isConfirming) {
            emailService.sendAppointmentConfirmedEmail(saved);
        }

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
        
        TrangThaiLichHen targetStatus = TrangThaiLichHen.valueOf(status);
        validateTransition(lichHen.getTrangThai(), targetStatus);
        boolean isConfirming = (lichHen.getTrangThai() == TrangThaiLichHen.PENDING && targetStatus == TrangThaiLichHen.CONFIRMED);
        lichHen.setTrangThai(targetStatus);
        LichHen saved = lichHenRepository.save(lichHen);
        logAudit(saved, "UPDATE_STATUS", userId);

        if (isConfirming) {
            emailService.sendAppointmentConfirmedEmail(saved);
        }

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
        if (lichHen.getTrangThai() != TrangThaiLichHen.CANCELLED) {
            validateTransition(lichHen.getTrangThai(), TrangThaiLichHen.CANCELLED);
            lichHen.setTrangThai(TrangThaiLichHen.CANCELLED);
            lichHenRepository.save(lichHen);
        }
        logAudit(lichHen, "CANCEL", userId);
    }

    private void validateTransition(TrangThaiLichHen current, TrangThaiLichHen target) {
        if (current == target) {
            return;
        }
        boolean valid = current == TrangThaiLichHen.PENDING
                && (target == TrangThaiLichHen.CONFIRMED || target == TrangThaiLichHen.CANCELLED);
        valid = valid || current == TrangThaiLichHen.CONFIRMED
                && (target == TrangThaiLichHen.COMPLETED || target == TrangThaiLichHen.NO_SHOW || target == TrangThaiLichHen.CANCELLED);
        if (!valid) {
            throw new RuntimeException("Chuyen trang thai lich hen khong hop le");
        }
    }

    private void logAudit(LichHen lh, String hanhDong, UUID userId) {
        try {
            com.example.quanlyphongtro.entity.AuditLog log = com.example.quanlyphongtro.entity.AuditLog.builder()
                .nguoiDung(userId == null ? null : com.example.quanlyphongtro.entity.NguoiDung.builder().id(userId).build())
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
