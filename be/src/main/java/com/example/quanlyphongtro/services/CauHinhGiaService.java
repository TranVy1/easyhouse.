package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.CauHinhGiaRequest;
import com.example.quanlyphongtro.dto.CauHinhGiaResponse;
import com.example.quanlyphongtro.entity.CauHinhGia;
import com.example.quanlyphongtro.entity.LoaiMucHoaDon;
import com.example.quanlyphongtro.entity.LoaiTinhPhi;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.repository.CauHinhGiaRepository;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;
import java.util.ArrayList;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import jakarta.persistence.criteria.Predicate;
import com.example.quanlyphongtro.dto.PaginatedResponse;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CauHinhGiaService {

    private final CauHinhGiaRepository cauHinhGiaRepository;
    private final NhaTroRepository nhaTroRepository;

    public PaginatedResponse<CauHinhGiaResponse> getAll(UUID nhaTroId, String loaiRaw, Boolean dangApDung,
            Pageable pageable) {
        LoaiMucHoaDon loai = parseLoai(loaiRaw, false);
        UUID userId = permissionService.requireCurrentUserId();
        List<UUID> accessibleIds = permissionService.getAllAccessibleNhaTroIds(userId);

        Specification<CauHinhGia> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (nhaTroId != null) {
                predicates.add(cb.equal(root.get("nhaTro").get("id"), nhaTroId));
            }
            if (loai != null) {
                predicates.add(cb.equal(root.get("loai"), loai));
            }
            if (dangApDung != null) {
                predicates.add(cb.equal(root.get("dangApDung"), dangApDung));
            }

            if (accessibleIds != null) {
                if (accessibleIds.isEmpty()) {
                    predicates.add(cb.disjunction());
                } else {
                    predicates.add(root.get("nhaTro").get("id").in(accessibleIds));
                }
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<CauHinhGia> page = cauHinhGiaRepository.findAll(spec, pageable);
        List<CauHinhGiaResponse> data = page.getContent().stream()
                .map(CauHinhGiaResponse::fromEntity)
                .toList();

        return PaginatedResponse.of(page, data);
    }

    public CauHinhGiaResponse getById(UUID id) {
        CauHinhGia entity = findById(id);
        checkReadPermission(entity);
        return CauHinhGiaResponse.fromEntity(entity);
    }

    public CauHinhGiaResponse getApplicable(UUID nhaTroId, String loaiRaw, LocalDate ngayApDung) {
        NhaTro nhaTro = nhaTroRepository.findById(nhaTroId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nha tro"));
        checkReadPermission(CauHinhGia.builder().nhaTro(nhaTro).build());
        LoaiMucHoaDon loai = parseLoai(loaiRaw, true);
        LocalDate effectiveDate = ngayApDung != null ? ngayApDung : LocalDate.now();
        return cauHinhGiaRepository.findApplicable(nhaTroId, loai, effectiveDate).stream()
                .findFirst()
                .map(CauHinhGiaResponse::fromEntity)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy cấu hình giá đang áp dụng"));
    }

    @Transactional
    public CauHinhGiaResponse create(CauHinhGiaRequest request) {
        validateDateRange(request.getHieuLucTu(), request.getHieuLucDen());
        NhaTro nhaTro = nhaTroRepository.findById(request.getNhaTroId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy nhà trọ"));
        checkWritePermission(nhaTro);

        LoaiMucHoaDon loai = parseLoai(request.getLoai(), true);
        CauHinhGia entity = CauHinhGia.builder()
                .nhaTro(nhaTro)
                .dichVuId(request.getDichVuId())
                .loai(loai)
                .tenHienThi(request.getTenHienThi().trim())
                .loaiTinhPhi(normalizeMeterPricing(loai, parseLoaiTinhPhi(request.getLoaiTinhPhi())))
                .donGia(request.getDonGia())
                .hieuLucTu(request.getHieuLucTu() != null ? request.getHieuLucTu() : LocalDate.now())
                .hieuLucDen(request.getHieuLucDen())
                .dangApDung(request.getDangApDung() != null ? request.getDangApDung() : true)
                .build();

        validateMoney(entity.getDonGia());
        validateDateRange(entity.getHieuLucTu(), entity.getHieuLucDen());
        validateOverlap(entity, null);

        if (Boolean.TRUE.equals(entity.getDangApDung())) {
            deactivateExistingConfigs(entity, null);
        }

        CauHinhGia saved = cauHinhGiaRepository.save(entity);
        logAudit(saved, "CREATE");
        return CauHinhGiaResponse.fromEntity(saved);
    }

    @Transactional
    public CauHinhGiaResponse update(UUID id, CauHinhGiaRequest request) {
        CauHinhGia oldEntity = findById(id);
        checkWritePermission(oldEntity.getNhaTro());

        NhaTro nhaTro = oldEntity.getNhaTro();
        if (request.getNhaTroId() != null && !request.getNhaTroId().equals(nhaTro.getId())) {
            nhaTro = nhaTroRepository.findById(request.getNhaTroId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy nhà trọ"));
            checkWritePermission(nhaTro);
        }

        LoaiMucHoaDon loai = request.getLoai() != null ? parseLoai(request.getLoai(), true) : oldEntity.getLoai();
        CauHinhGia newEntity = CauHinhGia.builder()
                .nhaTro(nhaTro)
                .dichVuId(request.getDichVuId() != null ? request.getDichVuId() : oldEntity.getDichVuId())
                .loai(loai)
                .tenHienThi(request.getTenHienThi() != null && !request.getTenHienThi().isBlank()
                        ? request.getTenHienThi().trim()
                        : oldEntity.getTenHienThi())
                .loaiTinhPhi(normalizeMeterPricing(loai, request.getLoaiTinhPhi() != null
                        ? parseLoaiTinhPhi(request.getLoaiTinhPhi()) : oldEntity.getLoaiTinhPhi()))
                .donGia(request.getDonGia() != null ? request.getDonGia() : oldEntity.getDonGia())
                .hieuLucTu(request.getHieuLucTu() != null ? request.getHieuLucTu() : LocalDate.now())
                .hieuLucDen(request.getHieuLucDen() != null ? request.getHieuLucDen() : oldEntity.getHieuLucDen())
                .dangApDung(request.getDangApDung() != null ? request.getDangApDung() : true)
                .build();

        validateMoney(newEntity.getDonGia());
        validateDateRange(newEntity.getHieuLucTu(), newEntity.getHieuLucDen());
        validateOverlap(newEntity, oldEntity.getId());

        if (Boolean.TRUE.equals(oldEntity.getDangApDung())) {
            deactivateExistingConfigs(newEntity, oldEntity.getId());
        }

        CauHinhGia saved = cauHinhGiaRepository.save(newEntity);
        logAudit(saved, "UPDATE_VERSION");
        return CauHinhGiaResponse.fromEntity(saved);
    }

    @Transactional
    public void deactivate(UUID id) {
        CauHinhGia entity = findById(id);
        checkWritePermission(entity.getNhaTro());
        entity.setDangApDung(false);
        if (entity.getHieuLucDen() == null) {
            LocalDate den = LocalDate.now();
            if (entity.getHieuLucTu() != null && den.isBefore(entity.getHieuLucTu())) {
                den = entity.getHieuLucTu();
            }
            entity.setHieuLucDen(den);
        }
        CauHinhGia saved = cauHinhGiaRepository.save(entity);
        logAudit(saved, "DEACTIVATE");
    }

    private CauHinhGia findById(UUID id) {
        return cauHinhGiaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy cấu hình giá"));
    }

    private LoaiMucHoaDon parseLoai(String value, boolean required) {
        if (value == null || value.isBlank() || "all".equalsIgnoreCase(value)) {
            if (required)
                throw new RuntimeException("Loại cấu hình giá không hợp lệ");
            return null;
        }
        try {
            return LoaiMucHoaDon.valueOf(value.trim().toUpperCase());
        } catch (Exception e) {
            throw new RuntimeException("Loại cấu hình giá không hợp lệ: " + value);
        }
    }

    private LoaiTinhPhi parseLoaiTinhPhi(String value) {
        if (value == null || value.isBlank()) {
            return LoaiTinhPhi.FIXED;
        }
        try {
            return LoaiTinhPhi.valueOf(value.trim().toUpperCase());
        } catch (Exception e) {
            throw new RuntimeException("Loại tính phí không hợp lệ: " + value);
        }
    }

    private LoaiTinhPhi normalizeMeterPricing(LoaiMucHoaDon loai, LoaiTinhPhi loaiTinhPhi) {
        if (loai == LoaiMucHoaDon.ELECTRICITY || loai == LoaiMucHoaDon.WATER) {
            return LoaiTinhPhi.PER_UNIT;
        }
        return loaiTinhPhi;
    }

    private void validateMoney(BigDecimal value) {
        if (value == null || value.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("Đơn giá phải lớn hơn hoặc bằng 0");
        }
    }

    private void validateDateRange(LocalDate from, LocalDate to) {
        if (from != null && to != null && to.isBefore(from)) {
            throw new RuntimeException("Ngày hết hiệu lực phải sau hoặc bằng ngày hiệu lực");
        }
    }

    private void deactivateExistingConfigs(CauHinhGia entity, UUID excludeId) {
        if (entity.getNhaTro() == null || entity.getLoai() == null)
            return;
        List<CauHinhGia> activeConfigs = cauHinhGiaRepository
                .findByNhaTroIdAndLoaiAndDangApDungTrueOrderByHieuLucTuDesc(
                        entity.getNhaTro().getId(), entity.getLoai());

        for (CauHinhGia existing : activeConfigs) {
            if (existing == null) {
                continue;
            }
            if (excludeId != null && excludeId.equals(existing.getId())) {
                existing.setDangApDung(false);
                LocalDate newDen = entity.getHieuLucTu().minusDays(1);
                if (existing.getHieuLucTu() != null && newDen.isBefore(existing.getHieuLucTu())) {
                    newDen = existing.getHieuLucTu();
                }
                if (existing.getHieuLucDen() == null || existing.getHieuLucDen().isAfter(newDen)) {
                    existing.setHieuLucDen(newDen);
                }
                cauHinhGiaRepository.save(existing);
                continue;
            }

            if (entity.getLoai() == LoaiMucHoaDon.OTHER || entity.getLoai() == LoaiMucHoaDon.SERVICE) {
                if (entity.getDichVuId() != null && !entity.getDichVuId().equals(existing.getDichVuId()))
                    continue;
                if (entity.getTenHienThi() != null && existing.getTenHienThi() != null
                        && !entity.getTenHienThi().equals(existing.getTenHienThi()))
                    continue;
            }

            // Deactivate other matching configs
            existing.setDangApDung(false);
            LocalDate newDen = entity.getHieuLucTu().minusDays(1);
            if (existing.getHieuLucTu() != null && newDen.isBefore(existing.getHieuLucTu())) {
                newDen = existing.getHieuLucTu();
            }
            if (existing.getHieuLucDen() == null || existing.getHieuLucDen().isAfter(newDen)) {
                existing.setHieuLucDen(newDen);
            }
            cauHinhGiaRepository.save(existing);
        }
    }

    private void validateOverlap(CauHinhGia entity, UUID excludeId) {
        if (!Boolean.TRUE.equals(entity.getDangApDung()))
            return;
        if (entity.getNhaTro() == null || entity.getLoai() == null)
            return;

        List<CauHinhGia> activeConfigs = cauHinhGiaRepository
                .findByNhaTroIdAndLoaiAndDangApDungTrueOrderByHieuLucTuDesc(
                        entity.getNhaTro().getId(), entity.getLoai());

        for (CauHinhGia existing : activeConfigs) {
            if (existing == null) {
                continue;
            }
            if (entity.getId() != null && entity.getId().equals(existing.getId()))
                continue;
            if (excludeId != null && excludeId.equals(existing.getId()))
                continue;
            if (Boolean.FALSE.equals(existing.getDangApDung()))
                continue;

            if (entity.getLoai() == LoaiMucHoaDon.OTHER || entity.getLoai() == LoaiMucHoaDon.SERVICE) {
                if (entity.getDichVuId() != null && !entity.getDichVuId().equals(existing.getDichVuId()))
                    continue;
                if (entity.getTenHienThi() != null && existing.getTenHienThi() != null
                        && !entity.getTenHienThi().equals(existing.getTenHienThi()))
                    continue;
            }

            LocalDate start1 = entity.getHieuLucTu() != null ? entity.getHieuLucTu() : LocalDate.MIN;
            LocalDate end1 = entity.getHieuLucDen() != null ? entity.getHieuLucDen() : LocalDate.MAX;

            LocalDate start2 = existing.getHieuLucTu() != null ? existing.getHieuLucTu() : LocalDate.MIN;
            LocalDate end2 = existing.getHieuLucDen() != null ? existing.getHieuLucDen() : LocalDate.MAX;

            if (!start1.isAfter(end2) && !start2.isAfter(end1)) {
                throw new RuntimeException(
                        "Cấu hình giá bị trùng lặp thời gian áp dụng với một cấu hình khác cùng loại");
            }
        }
    }

    @org.springframework.beans.factory.annotation.Autowired
    private com.example.quanlyphongtro.repository.AuditLogRepository auditLogRepository;
    @org.springframework.beans.factory.annotation.Autowired
    private com.example.quanlyphongtro.services.PermissionService permissionService;

    private void logAudit(CauHinhGia chg, String hanhDong) {
        if (auditLogRepository == null)
            return;
        com.example.quanlyphongtro.entity.AuditLog log = com.example.quanlyphongtro.entity.AuditLog.builder()
                .nguoiDung(com.example.quanlyphongtro.entity.NguoiDung.builder()
                        .id(permissionService.requireCurrentUserId()).build())
                .hanhDong(hanhDong)
                .bangTacDong("cau_hinh_gia")
                .banGhiId(chg.getId())
                .taoLuc(java.time.ZonedDateTime.now())
                .build();
        auditLogRepository.save(log);
    }

    private void checkReadPermission(CauHinhGia entity) {
        if (entity.getNhaTro() != null) {
            UUID userId = permissionService.requireCurrentUserId();
            UUID ownerId = entity.getNhaTro().getChuTro() != null ? entity.getNhaTro().getChuTro().getId() : null;
            if (!permissionService.canReadNhaTro(userId, entity.getNhaTro().getId(), ownerId)) {
                throw new RuntimeException("Khong co quyen truy cap cau hinh gia nay");
            }
        }
    }

    private void checkWritePermission(NhaTro nhaTro) {
        if (nhaTro != null) {
            UUID userId = permissionService.requireCurrentUserId();
            UUID ownerId = nhaTro.getChuTro() != null ? nhaTro.getChuTro().getId() : null;
            if (!permissionService.canWriteNhaTro(userId, nhaTro.getId(), ownerId)) {
                throw new RuntimeException("Khong co quyen thay doi cau hinh gia cua nha tro nay");
            }
        }
    }
}
