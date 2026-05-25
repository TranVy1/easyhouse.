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

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CauHinhGiaService {

    private final CauHinhGiaRepository cauHinhGiaRepository;
    private final NhaTroRepository nhaTroRepository;

    public List<CauHinhGiaResponse> getAll(UUID nhaTroId, String loaiRaw, Boolean dangApDung) {
        LoaiMucHoaDon loai = parseLoai(loaiRaw, false);
        List<CauHinhGia> list;
        if (nhaTroId != null) {
            list = cauHinhGiaRepository.findByNhaTroIdOrderByHieuLucTuDesc(nhaTroId);
        } else {
            list = cauHinhGiaRepository.findAll();
        }

        return list.stream()
                .filter(c -> loai == null || c.getLoai() == loai)
                .filter(c -> dangApDung == null || c.getDangApDung().equals(dangApDung))
                .sorted(Comparator.comparing((CauHinhGia c) -> c.getNhaTro() != null ? c.getNhaTro().getTen() : "", Comparator.nullsLast(String::compareTo))
                        .thenComparing(c -> c.getLoai() != null ? c.getLoai().name() : "", Comparator.nullsLast(String::compareTo))
                        .thenComparing(CauHinhGia::getHieuLucTu, Comparator.nullsLast(Comparator.reverseOrder())))
                .map(CauHinhGiaResponse::fromEntity)
                .toList();
    }

    public CauHinhGiaResponse getById(UUID id) {
        return CauHinhGiaResponse.fromEntity(findById(id));
    }

    public CauHinhGiaResponse getApplicable(UUID nhaTroId, String loaiRaw, LocalDate ngayApDung) {
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

        CauHinhGia entity = CauHinhGia.builder()
                .nhaTro(nhaTro)
                .dichVuId(request.getDichVuId())
                .loai(parseLoai(request.getLoai(), true))
                .tenHienThi(request.getTenHienThi().trim())
                .loaiTinhPhi(parseLoaiTinhPhi(request.getLoaiTinhPhi()))
                .donGia(request.getDonGia())
                .hieuLucTu(request.getHieuLucTu() != null ? request.getHieuLucTu() : LocalDate.now())
                .hieuLucDen(request.getHieuLucDen())
                .dangApDung(request.getDangApDung() != null ? request.getDangApDung() : true)
                .build();

        validateMoney(entity.getDonGia());
        validateOverlap(entity);
        return CauHinhGiaResponse.fromEntity(cauHinhGiaRepository.save(entity));
    }

    @Transactional
    public CauHinhGiaResponse update(UUID id, CauHinhGiaRequest request) {
        CauHinhGia entity = findById(id);

        if (request.getNhaTroId() != null) {
            entity.setNhaTro(nhaTroRepository.findById(request.getNhaTroId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy nhà trọ")));
        }
        if (request.getDichVuId() != null) entity.setDichVuId(request.getDichVuId());
        if (request.getLoai() != null) entity.setLoai(parseLoai(request.getLoai(), true));
        if (request.getTenHienThi() != null && !request.getTenHienThi().isBlank()) {
            entity.setTenHienThi(request.getTenHienThi().trim());
        }
        if (request.getLoaiTinhPhi() != null) entity.setLoaiTinhPhi(parseLoaiTinhPhi(request.getLoaiTinhPhi()));
        if (request.getDonGia() != null) {
            validateMoney(request.getDonGia());
            entity.setDonGia(request.getDonGia());
        }
        if (request.getHieuLucTu() != null) entity.setHieuLucTu(request.getHieuLucTu());
        if (request.getHieuLucDen() != null) entity.setHieuLucDen(request.getHieuLucDen());
        if (request.getDangApDung() != null) entity.setDangApDung(request.getDangApDung());

        validateDateRange(entity.getHieuLucTu(), entity.getHieuLucDen());
        validateOverlap(entity);
        return CauHinhGiaResponse.fromEntity(cauHinhGiaRepository.save(entity));
    }

    @Transactional
    public void deactivate(UUID id) {
        CauHinhGia entity = findById(id);
        entity.setDangApDung(false);
        if (entity.getHieuLucDen() == null) {
            entity.setHieuLucDen(LocalDate.now());
        }
        cauHinhGiaRepository.save(entity);
    }

    private CauHinhGia findById(UUID id) {
        return cauHinhGiaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy cấu hình giá"));
    }

    private LoaiMucHoaDon parseLoai(String value, boolean required) {
        if (value == null || value.isBlank() || "all".equalsIgnoreCase(value)) {
            if (required) throw new RuntimeException("Loại cấu hình giá không hợp lệ");
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

    private void validateOverlap(CauHinhGia entity) {
        if (!Boolean.TRUE.equals(entity.getDangApDung())) return;
        if (entity.getNhaTro() == null || entity.getLoai() == null) return;
        // Chi validate overlap cho dien, nuoc, hoac cac loai co dinh khong the overlap.
        // Dich vu co the co nhieu loai.
        if (entity.getLoai() != LoaiMucHoaDon.ELECTRICITY && entity.getLoai() != LoaiMucHoaDon.WATER) return;

        List<CauHinhGia> activeConfigs = cauHinhGiaRepository.findByNhaTroIdAndLoaiAndDangApDungTrueOrderByHieuLucTuDesc(
                entity.getNhaTro().getId(), entity.getLoai());

        for (CauHinhGia existing : activeConfigs) {
            if (entity.getId() != null && entity.getId().equals(existing.getId())) continue;
            
            LocalDate start1 = entity.getHieuLucTu() != null ? entity.getHieuLucTu() : LocalDate.MIN;
            LocalDate end1 = entity.getHieuLucDen() != null ? entity.getHieuLucDen() : LocalDate.MAX;
            
            LocalDate start2 = existing.getHieuLucTu() != null ? existing.getHieuLucTu() : LocalDate.MIN;
            LocalDate end2 = existing.getHieuLucDen() != null ? existing.getHieuLucDen() : LocalDate.MAX;
            
            if (!start1.isAfter(end2) && !start2.isAfter(end1)) {
                throw new RuntimeException("Cấu hình giá bị trùng lặp thời gian áp dụng với một cấu hình khác cùng loại");
            }
        }
    }

    @org.springframework.beans.factory.annotation.Autowired
    private com.example.quanlyphongtro.repository.AuditLogRepository auditLogRepository;
    @org.springframework.beans.factory.annotation.Autowired
    private com.example.quanlyphongtro.services.PermissionService permissionService;

    private void logAudit(CauHinhGia chg, String hanhDong) {
        if (auditLogRepository == null) return;
        com.example.quanlyphongtro.entity.AuditLog log = com.example.quanlyphongtro.entity.AuditLog.builder()
            .nguoiDung(com.example.quanlyphongtro.entity.NguoiDung.builder().id(permissionService.requireCurrentUserId()).build())
            .hanhDong(hanhDong)
            .bangTacDong("cau_hinh_gia")
            .banGhiId(chg.getId())
            .taoLuc(java.time.ZonedDateTime.now())
            .build();
        auditLogRepository.save(log);
    }
}
