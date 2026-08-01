package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.ChiSoDienNuocRequest;
import com.example.quanlyphongtro.dto.ChiSoDienNuocResponse;
import com.example.quanlyphongtro.dto.PhongResponse;
import com.example.quanlyphongtro.dto.HopDongResponse;
import com.example.quanlyphongtro.entity.ChiSoDienNuoc;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.repository.ChiSoDienNuocRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.entity.TrangThaiChiSo;
import com.example.quanlyphongtro.entity.LoaiDoiTuongMedia;
import com.example.quanlyphongtro.services.PermissionService;
import com.example.quanlyphongtro.entity.NguoiDung;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.ArrayList;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import jakarta.persistence.criteria.Predicate;
import com.example.quanlyphongtro.entity.LoaiChiSo;
import com.example.quanlyphongtro.dto.PaginatedResponse;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ChiSoDienNuocService {

    private final ChiSoDienNuocRepository chiSoDienNuocRepository;
    private final PhongRepository phongRepository;
    private final HopDongRepository hopDongRepository;
    private final MediaService mediaService;
    private final PermissionService permissionService;
    private final com.example.quanlyphongtro.repository.NguoiDungRepository nguoiDungRepository;
    private final com.example.quanlyphongtro.repository.AuditLogRepository auditLogRepository;
    private final MeterAnomalyService meterAnomalyService;

    public PaginatedResponse<ChiSoDienNuocResponse> getAll(UUID nhaTroId, UUID phongId, Integer kyThang, Integer kyNam, String loai, String trangThai, Pageable pageable) {
        UUID userId = permissionService.requireCurrentUserId();
        List<UUID> accessibleIds = permissionService.getAllAccessibleNhaTroIds(userId);

        Specification<ChiSoDienNuoc> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.isNotNull(root.get("phong")));

            if (phongId != null) {
                predicates.add(cb.equal(root.get("phong").get("id"), phongId));
            }
            if (nhaTroId != null) {
                predicates.add(cb.equal(root.get("phong").get("nhaTro").get("id"), nhaTroId));
            }
            if (kyThang != null) {
                predicates.add(cb.equal(root.get("kyThang"), kyThang));
            }
            if (kyNam != null) {
                predicates.add(cb.equal(root.get("kyNam"), kyNam));
            }
            if (loai != null && !loai.isBlank() && !loai.equals("all")) {
                predicates.add(cb.equal(root.get("loai"), LoaiChiSo.valueOf(loai)));
            }
            if (trangThai != null && !trangThai.isBlank() && !trangThai.equals("all")) {
                predicates.add(cb.equal(root.get("trangThai"), TrangThaiChiSo.valueOf(trangThai)));
            }
            
            if (accessibleIds != null) {
                if (accessibleIds.isEmpty()) {
                    predicates.add(cb.disjunction()); // Always false if no access
                } else {
                    predicates.add(root.get("phong").get("nhaTro").get("id").in(accessibleIds));
                }
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<ChiSoDienNuoc> page = chiSoDienNuocRepository.findAll(spec, pageable);
        List<ChiSoDienNuocResponse> data = page.getContent().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
        return PaginatedResponse.of(page, data);
    }

    public List<ChiSoDienNuocResponse> getByPhong(UUID phongId) {
        UUID userId = permissionService.requireCurrentUserId();
        if (!permissionService.canReadPhong(userId, phongId)) {
            throw new RuntimeException("Khong co quyen truy cap phong nay");
        }
        return chiSoDienNuocRepository.findByPhongIdOrderByKyNamDescKyThangDesc(phongId).stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    public ChiSoDienNuocResponse getById(UUID id) {
        ChiSoDienNuoc chiSo = chiSoDienNuocRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy chỉ số"));
        assertCanRead(chiSo);
        return mapToResponse(chiSo);
    }

    @Transactional
    public ChiSoDienNuocResponse create(ChiSoDienNuocRequest request) {
        validateRequiredFields(request);
        UUID userId = permissionService.requireCurrentUserId();
        assertCanWrite(userId, request.getPhongId());
        Phong phong = phongRepository.findById(request.getPhongId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));

        // Validate duplicates
        Optional<ChiSoDienNuoc> existing = chiSoDienNuocRepository.findByPhongIdAndLoaiAndKyNamAndKyThang(
                request.getPhongId(), request.getLoai(), request.getKyNam(), request.getKyThang()
        );
        if (existing.isPresent() && existing.get().getTrangThai() != TrangThaiChiSo.CANCELLED) {
            throw new RuntimeException("Chỉ số của phòng trong kỳ này đã tồn tại");
        }

        if (request.getChiSoMoi() < request.getChiSoCu()) {
            throw new RuntimeException("Chỉ số mới phải lớn hơn hoặc bằng chỉ số cũ");
        }
        assertManualStatusAllowed(request.getTrangThai());

        List<HopDong> activeContracts = hopDongRepository.findRoomOccupyingContracts(
                phong.getId(), List.of(com.example.quanlyphongtro.entity.TrangThaiHopDong.ACTIVE));
        if (activeContracts.isEmpty()) {
            throw new RuntimeException("Chỉ có thể ghi chỉ số cho phòng đang có hợp đồng hiệu lực");
        }

        ChiSoDienNuoc chiSo = existing.orElseGet(ChiSoDienNuoc::new);
        chiSo.setPhong(phong);

        if (request.getHopDongId() != null) {
            HopDong hopDong = hopDongRepository.findById(request.getHopDongId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
            validateHopDongPhong(hopDong, phong);
            if (!permissionService.canWriteHopDong(userId, hopDong.getId())) {
                throw new RuntimeException("Khong co quyen thay doi hop dong nay");
            }
            if (hopDong.getTrangThai() != com.example.quanlyphongtro.entity.TrangThaiHopDong.ACTIVE) {
                throw new RuntimeException("Chỉ có thể ghi chỉ số cho hợp đồng đang hiệu lực");
            }
            chiSo.setHopDong(hopDong);
        } else {
            chiSo.setHopDong(activeContracts.get(0));
        }

        validateReadingContinuity(phong, chiSo.getHopDong(), request.getLoai(), request.getKyNam(),
                request.getKyThang(), request.getChiSoCu(), request.getChiSoMoi(), chiSo.getId());

        chiSo.setLoai(request.getLoai());
        chiSo.setKyNam(request.getKyNam());
        chiSo.setKyThang(request.getKyThang());
        chiSo.setNgayGhi(request.getNgayGhi() != null ? request.getNgayGhi() : java.time.LocalDate.now());
        chiSo.setChiSoCu(request.getChiSoCu());
        chiSo.setChiSoMoi(request.getChiSoMoi());
        chiSo.setTrangThai(request.getTrangThai() != null ? request.getTrangThai() : TrangThaiChiSo.DRAFT);
        chiSo.setGhiChu(request.getGhiChu());
        chiSo.setNguoiGhi(nguoiDungRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nguoi dung hien tai")));

        ChiSoDienNuoc saved = chiSoDienNuocRepository.save(chiSo);
        if (request.getAnhDongHo() != null) {
            mediaService.replaceUrl(LoaiDoiTuongMedia.METER_READING, saved.getId(), request.getAnhDongHo(), MediaService.METER_IMAGE);
        }
        meterAnomalyService.analyzeReading(saved);
        logAudit(saved, "CREATE");
        return mapToResponse(saved);
    }

    @Transactional
    public ChiSoDienNuocResponse update(UUID id, ChiSoDienNuocRequest request) {
        ChiSoDienNuoc chiSo = chiSoDienNuocRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy chỉ số"));

        UUID userId = permissionService.requireCurrentUserId();
        assertCanWrite(userId, chiSo.getPhong() != null ? chiSo.getPhong().getId() : null);

        if (chiSo.getTrangThai() == TrangThaiChiSo.BILLED && request.getTrangThai() != TrangThaiChiSo.CANCELLED) {
            throw new RuntimeException("Không thể sửa chỉ số đã được lập hóa đơn");
        }
        if (chiSo.getTrangThai() == TrangThaiChiSo.BILLED) {
            chiSo.setTrangThai(TrangThaiChiSo.CANCELLED);
            chiSo.setNguoiGhi(nguoiDungRepository.findById(userId)
                    .orElseThrow(() -> new RuntimeException("Khong tim thay nguoi dung hien tai")));
            ChiSoDienNuoc cancelled = chiSoDienNuocRepository.save(chiSo);
            logAudit(cancelled, "CANCEL");
            return mapToResponse(cancelled);
        }
        assertManualStatusAllowed(request.getTrangThai());

        LoaiChiSo loai = request.getLoai() != null ? request.getLoai() : chiSo.getLoai();
        Integer kyNam = request.getKyNam() != null ? request.getKyNam() : chiSo.getKyNam();
        Integer kyThang = request.getKyThang() != null ? request.getKyThang() : chiSo.getKyThang();
        Integer chiSoCu = request.getChiSoCu() != null ? request.getChiSoCu() : chiSo.getChiSoCu();
        Integer chiSoMoi = request.getChiSoMoi() != null ? request.getChiSoMoi() : chiSo.getChiSoMoi();
        validateRequiredFields(loai, kyNam, kyThang, chiSoCu, chiSoMoi);

        if (chiSoMoi < chiSoCu) {
            throw new RuntimeException("Chỉ số mới phải lớn hơn hoặc bằng chỉ số cũ");
        }

        if (request.getHopDongId() != null) {
            HopDong hopDong = hopDongRepository.findById(request.getHopDongId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
            validateHopDongPhong(hopDong, chiSo.getPhong());
            if (!permissionService.canWriteHopDong(userId, hopDong.getId())) {
                throw new RuntimeException("Khong co quyen thay doi hop dong nay");
            }
            chiSo.setHopDong(hopDong);
        } else if (chiSo.getHopDong() == null && chiSo.getPhong() != null) {
            // Find active contract for the room
            List<HopDong> activeContracts = hopDongRepository.findRoomOccupyingContracts(chiSo.getPhong().getId(), List.of(com.example.quanlyphongtro.entity.TrangThaiHopDong.ACTIVE));
            if (!activeContracts.isEmpty()) {
                chiSo.setHopDong(activeContracts.get(0));
            }
        }

        Optional<ChiSoDienNuoc> duplicate = chiSoDienNuocRepository.findByPhongIdAndLoaiAndKyNamAndKyThang(
                chiSo.getPhong().getId(), loai, kyNam, kyThang);
        if (duplicate.isPresent() && !duplicate.get().getId().equals(chiSo.getId())) {
            throw new RuntimeException("Chỉ số của phòng trong kỳ này đã tồn tại");
        }
        validateReadingContinuity(chiSo.getPhong(), chiSo.getHopDong(), loai, kyNam, kyThang,
                chiSoCu, chiSoMoi, chiSo.getId());

        chiSo.setLoai(loai);
        chiSo.setKyNam(kyNam);
        chiSo.setKyThang(kyThang);
        chiSo.setNgayGhi(request.getNgayGhi() != null ? request.getNgayGhi() : java.time.LocalDate.now());
        chiSo.setChiSoCu(chiSoCu);
        chiSo.setChiSoMoi(chiSoMoi);
        if (request.getTrangThai() != null) chiSo.setTrangThai(request.getTrangThai());
        chiSo.setGhiChu(request.getGhiChu());
        chiSo.setNguoiGhi(nguoiDungRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nguoi dung hien tai")));

        ChiSoDienNuoc saved = chiSoDienNuocRepository.save(chiSo);
        if (request.getAnhDongHo() != null) {
            mediaService.replaceUrl(LoaiDoiTuongMedia.METER_READING, saved.getId(), request.getAnhDongHo(), MediaService.METER_IMAGE);
        }
        meterAnomalyService.analyzeReading(saved);
        logAudit(saved, "UPDATE");
        return mapToResponse(saved);
    }

    @Transactional
    public void delete(UUID id) {
        ChiSoDienNuoc chiSo = chiSoDienNuocRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy chỉ số"));
        if (chiSo.getTrangThai() == TrangThaiChiSo.BILLED) {
            throw new RuntimeException("Không thể xóa chỉ số đã được lập hóa đơn. Chỉ có thể Hủy.");
        }
        UUID userId = permissionService.requireCurrentUserId();
        assertCanWrite(userId, chiSo.getPhong() != null ? chiSo.getPhong().getId() : null);
        chiSo.setTrangThai(TrangThaiChiSo.CANCELLED);
        chiSo.setNguoiGhi(nguoiDungRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay nguoi dung hien tai")));
        ChiSoDienNuoc cancelled = chiSoDienNuocRepository.save(chiSo);
        logAudit(cancelled, "CANCEL");
    }

    private void assertCanRead(ChiSoDienNuoc chiSo) {
        UUID phongId = chiSo.getPhong() != null ? chiSo.getPhong().getId() : null;
        if (phongId == null || !permissionService.canReadPhong(permissionService.requireCurrentUserId(), phongId)) {
            throw new RuntimeException("Khong co quyen truy cap chi so nay");
        }
    }

    private void assertCanWrite(UUID userId, UUID phongId) {
        if (phongId == null || !permissionService.canWritePhong(userId, phongId)) {
            throw new RuntimeException("Khong co quyen thay doi chi so nay");
        }
    }

    private void assertManualStatusAllowed(TrangThaiChiSo trangThai) {
        if (trangThai == TrangThaiChiSo.BILLED || trangThai == TrangThaiChiSo.CANCELLED) {
            throw new RuntimeException("Trang thai nay chi duoc cap nhat boi quy trinh lap hoa don hoac huy");
        }
    }

    private void validateHopDongPhong(HopDong hopDong, Phong phong) {
        if (phong == null || hopDong.getPhong() == null || !phong.getId().equals(hopDong.getPhong().getId())) {
            throw new RuntimeException("Hop dong khong thuoc phong cua chi so");
        }
    }

    private void validateRequiredFields(ChiSoDienNuocRequest request) {
        if (request == null) {
            throw new RuntimeException("Dữ liệu chỉ số không hợp lệ");
        }
        validateRequiredFields(request.getLoai(), request.getKyNam(), request.getKyThang(),
                request.getChiSoCu(), request.getChiSoMoi());
    }

    private void validateRequiredFields(LoaiChiSo loai, Integer kyNam, Integer kyThang,
            Integer chiSoCu, Integer chiSoMoi) {
        if (loai == null || kyNam == null || kyNam < 2000 || kyNam > 2100
                || kyThang == null || kyThang < 1 || kyThang > 12
                || chiSoCu == null || chiSoMoi == null || chiSoCu < 0 || chiSoMoi < 0) {
            throw new RuntimeException("Dữ liệu chỉ số không hợp lệ");
        }
    }

    private void validateReadingContinuity(Phong phong, HopDong hopDong, LoaiChiSo loai,
            int kyNam, int kyThang, int chiSoCu, int chiSoMoi, UUID excludedId) {
        List<ChiSoDienNuoc> readings = chiSoDienNuocRepository
                .findByPhongIdAndLoaiOrderByKyNamDescKyThangDesc(phong.getId(), loai);
        Optional<ChiSoDienNuoc> previous = readings.stream()
                .filter(reading -> !reading.getId().equals(excludedId))
                .filter(reading -> reading.getTrangThai() != TrangThaiChiSo.CANCELLED)
                .filter(reading -> reading.getKyNam() < kyNam
                        || (reading.getKyNam().equals(kyNam) && reading.getKyThang() < kyThang))
                .findFirst();
        int expectedStart = previous.map(ChiSoDienNuoc::getChiSoMoi)
                .orElse(defaultMeterReading(hopDong, loai));
        if (chiSoCu != expectedStart) {
            throw new RuntimeException("Chỉ số cũ phải bằng chỉ số cuối kỳ trước của phòng (" + expectedStart + ")");
        }

        readings.stream()
                .filter(reading -> !reading.getId().equals(excludedId))
                .filter(reading -> reading.getTrangThai() != TrangThaiChiSo.CANCELLED)
                .filter(reading -> reading.getKyNam() > kyNam
                        || (reading.getKyNam().equals(kyNam) && reading.getKyThang() > kyThang))
                .filter(reading -> reading.getChiSoCu() != chiSoMoi)
                .findFirst()
                .ifPresent(reading -> {
                    throw new RuntimeException("Không thể sửa chỉ số vì kỳ " + reading.getKyThang() + "/"
                            + reading.getKyNam() + " đang dùng chỉ số cuối kỳ này làm chỉ số đầu");
                });
    }

    private int defaultMeterReading(HopDong hopDong, LoaiChiSo loai) {
        Integer value = hopDong == null ? null : loai == LoaiChiSo.ELECTRICITY
                ? hopDong.getChiSoDienBanDau() : hopDong.getChiSoNuocBanDau();
        return value == null ? 0 : value;
    }

    private void logAudit(ChiSoDienNuoc chiSo, String action) {
        auditLogRepository.save(com.example.quanlyphongtro.entity.AuditLog.builder()
                .nguoiDung(NguoiDung.builder().id(permissionService.requireCurrentUserId()).build())
                .hanhDong(action)
                .bangTacDong("chi_so_dien_nuoc")
                .banGhiId(chiSo.getId())
                .taoLuc(java.time.ZonedDateTime.now())
                .build());
    }

    private ChiSoDienNuocResponse mapToResponse(ChiSoDienNuoc entity) {
        ChiSoDienNuocResponse response = new ChiSoDienNuocResponse();
        response.setId(entity.getId());

        if (entity.getPhong() != null) {
            response.setPhong(PhongResponse.builder()
                    .id(entity.getPhong().getId())
                    .ten(entity.getPhong().getTen())
                    .build());
        }

        if (entity.getHopDong() != null) {
            response.setHopDong(HopDongResponse.builder()
                    .id(entity.getHopDong().getId())
                    .maHopDong(entity.getHopDong().getMaHopDong())
                    .build());
        }

        response.setLoai(entity.getLoai());
        response.setKyNam(entity.getKyNam());
        response.setKyThang(entity.getKyThang());
        response.setNgayGhi(entity.getNgayGhi());
        response.setChiSoCu(entity.getChiSoCu());
        response.setChiSoMoi(entity.getChiSoMoi());
        response.setTieuThu(entity.getTieuThu());
        response.setAnhDongHo(mediaService.firstUrl(LoaiDoiTuongMedia.METER_READING, entity.getId(), MediaService.METER_IMAGE));
        response.setTrangThai(entity.getTrangThai());
        response.setGhiChu(entity.getGhiChu());
        response.setTaoLuc(entity.getTaoLuc());
        response.setCapNhatLuc(entity.getCapNhatLuc());

        return response;
    }
}
