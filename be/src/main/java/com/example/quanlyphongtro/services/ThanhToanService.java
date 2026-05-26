package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.ThanhToanRequest;
import com.example.quanlyphongtro.dto.ThanhToanResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Collections;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ThanhToanService {

    private final ThanhToanRepository thanhToanRepository;
    private final HoaDonRepository hoaDonRepository;
    private final ChiTietHoaDonRepository chiTietHoaDonRepository;
    private final MediaService mediaService;
    private final PermissionService permissionService;
    private final EmailService emailService;

    @Transactional(readOnly = true)
    public PaginatedResponse<ThanhToanResponse> getAll(String hoaDonId, String trangThaiStr, int page, int limit) {
        UUID userId = permissionService.requireCurrentUserId();
        boolean isAdmin = permissionService.isAdmin(userId);
        List<UUID> nhaTroIds = List.of();
        if (!isAdmin) {
            List<UUID> accessibleIds = permissionService.getAllAccessibleNhaTroIds(userId);
            if (!accessibleIds.isEmpty()) {
                nhaTroIds = accessibleIds;
            }
        }
        
        TrangThaiThanhToan tt = null;
        if (trangThaiStr != null && !trangThaiStr.isBlank() && !trangThaiStr.equals("all")) {
            try { tt = TrangThaiThanhToan.valueOf(trangThaiStr.toUpperCase()); } catch (Exception ignored) {}
        }
        
        UUID hid = parseOptionalUuid(hoaDonId);

        Pageable pageable = PageRequest.of(Math.max(0, page - 1), limit, Sort.by(Sort.Direction.DESC, "ngayThanhToan"));
        Page<ThanhToan> pageResult = thanhToanRepository.findAllAccessible(
                isAdmin, userId, nhaTroIds, hid, tt != null ? tt.name() : null, pageable);
        
        List<ThanhToanResponse> res = new ArrayList<>();
        for (ThanhToan hd : pageResult.getContent()) {
            List<ChiTietHoaDon> ct = hd.getHoaDon() != null
                    ? chiTietHoaDonRepository.findByHoaDonId(hd.getHoaDon().getId())
                    : Collections.emptyList();
            res.add(toResponse(hd, ct));
        }
        
        return PaginatedResponse.of(pageResult, res);
    }

    @Transactional(readOnly = true)
    public ThanhToanResponse getById(UUID id) {
        ThanhToan tt = thanhToanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thanh toán"));
        assertCanReadHoaDon(tt.getHoaDon(), permissionService.requireCurrentUserId());
        List<ChiTietHoaDon> ct = tt.getHoaDon() != null
                ? chiTietHoaDonRepository.findByHoaDonId(tt.getHoaDon().getId())
                : Collections.emptyList();
        return toResponse(tt, ct);
    }

    @Transactional(readOnly = true)
    public List<ThanhToanResponse> getByHoaDon(UUID hoaDonId) {
        HoaDon hoaDon = hoaDonRepository.findById(hoaDonId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay hoa don"));
        assertCanReadHoaDon(hoaDon, permissionService.requireCurrentUserId());
        return thanhToanRepository.findByHoaDonIdOrderByNgayThanhToanDesc(hoaDonId).stream()
                .map(tt -> toResponse(tt, chiTietHoaDonRepository.findByHoaDonId(hoaDonId)))
                .toList();
    }

    @Transactional
    public ThanhToanResponse create(ThanhToanRequest req) {
        if (req.getHoaDonId() == null) {
            throw new RuntimeException("Hóa đơn là bắt buộc khi ghi nhận thanh toán");
        }
        HoaDon hoaDon = hoaDonRepository.findById(req.getHoaDonId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn"));
        UUID userId = permissionService.requireCurrentUserId();
        assertCanWriteHoaDon(hoaDon, userId);
        if (hoaDon.getXoaLuc() != null || hoaDon.getTrangThai() == TrangThaiHoaDon.CANCELLED) {
            throw new RuntimeException("Không thể thanh toán hóa đơn đã xóa hoặc đã hủy");
        }
        if (req.getSoTien() == null || req.getSoTien().compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("Số tiền thanh toán phải lớn hơn 0");
        }

        TrangThaiThanhToan status = TrangThaiThanhToan.SUCCESS;
        if (req.getTrangThai() != null) {
            status = parseTrangThai(req.getTrangThai());
        }

        ThanhToan tt = ThanhToan.builder()
                .hoaDon(hoaDon)
                .khachThue(hoaDon.getKhachThue())
                .soTien(req.getSoTien())
                .phuongThucThanhToan(parsePhuongThuc(req.getPhuongThuc()))
                .maThamChieu(req.getThongTinChuyenKhoan() != null ? req.getThongTinChuyenKhoan().getSoGiaoDich() : null)
                .ngayThanhToan(parseNgayThanhToan(req.getNgayThanhToan()))
                .ghiChu(req.getGhiChu())
                .trangThai(status)
                .build();
        ThanhToan saved = thanhToanRepository.save(tt);
        mediaService.replaceUrl(LoaiDoiTuongMedia.PAYMENT, saved.getId(), req.getAnhBienLai(), MediaService.PAYMENT_RECEIPT);
        recalculate(hoaDon.getId());

        try {
            HoaDon updatedInvoice = hoaDonRepository.findById(hoaDon.getId()).orElse(hoaDon);
            emailService.sendPaymentReceivedEmail(saved, updatedInvoice, updatedInvoice.getKhachThue());
        } catch (Exception e) {
            // Ignore email error to prevent rollback of transaction
        }

        logAudit(saved, "CREATE");
        return toResponse(saved, chiTietHoaDonRepository.findByHoaDonId(hoaDon.getId()));
    }

    @Transactional
    public void recordBankTransactionMatch(BankTransaction transaction, HoaDon hoaDon) {
        String externalId = "BANK:" + transaction.getId();
        if (thanhToanRepository.findByExternalTransactionId(externalId).isPresent()) {
            throw new RuntimeException("Giao dich nay da tao thanh toan");
        }
        ThanhToan payment = ThanhToan.builder()
                .hoaDon(hoaDon)
                .khachThue(hoaDon.getKhachThue())
                .soTien(transaction.getSoTien())
                .phuongThucThanhToan(PhuongThucThanhToan.VIETQR)
                .maThamChieu(transaction.getMaGiaoDich())
                .externalTransactionId(externalId)
                .ngayThanhToan(transaction.getThoiGianGiaoDich())
                .nguoiGhiNhan(NguoiDung.builder().id(permissionService.requireCurrentUserId()).build())
                .trangThai(TrangThaiThanhToan.SUCCESS)
                .ghiChu("VietQR manual match")
                .build();
        ThanhToan saved = thanhToanRepository.save(payment);
        recalculate(hoaDon.getId());
        logAudit(saved, "MANUAL_MATCH");
    }

    @Transactional
    public ThanhToanResponse update(UUID id, ThanhToanRequest req) {
        ThanhToan tt = thanhToanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay thanh toan"));
        UUID userId = permissionService.requireCurrentUserId();
        assertCanWriteHoaDon(tt.getHoaDon(), userId);
        UUID oldHoaDonId = tt.getHoaDon() != null ? tt.getHoaDon().getId() : null;

        if (req.getHoaDonId() != null && (tt.getHoaDon() == null || !req.getHoaDonId().equals(tt.getHoaDon().getId()))) {
            HoaDon hoaDon = hoaDonRepository.findById(req.getHoaDonId())
                    .orElseThrow(() -> new RuntimeException("Khong tim thay hoa don"));
            assertCanWriteHoaDon(hoaDon, userId);
            if (hoaDon.getXoaLuc() != null || hoaDon.getTrangThai() == TrangThaiHoaDon.CANCELLED) {
                throw new RuntimeException("Khong the gan thanh toan vao hoa don da xoa hoac da huy");
            }
            tt.setHoaDon(hoaDon);
            tt.setKhachThue(hoaDon.getKhachThue());
        }
        if (req.getSoTien() != null) {
            if (req.getSoTien().compareTo(BigDecimal.ZERO) <= 0) {
                throw new RuntimeException("So tien thanh toan phai lon hon 0");
            }
            tt.setSoTien(req.getSoTien());
        }
        if (req.getPhuongThuc() != null) tt.setPhuongThucThanhToan(parsePhuongThuc(req.getPhuongThuc()));
        if (req.getThongTinChuyenKhoan() != null) tt.setMaThamChieu(req.getThongTinChuyenKhoan().getSoGiaoDich());
        if (req.getNgayThanhToan() != null) tt.setNgayThanhToan(parseNgayThanhToan(req.getNgayThanhToan()));
        if (req.getGhiChu() != null) tt.setGhiChu(req.getGhiChu());
        if (req.getTrangThai() != null) tt.setTrangThai(parseTrangThai(req.getTrangThai()));

        ThanhToan saved = thanhToanRepository.save(tt);
        if (req.getAnhBienLai() != null) {
            mediaService.replaceUrl(LoaiDoiTuongMedia.PAYMENT, saved.getId(), req.getAnhBienLai(), MediaService.PAYMENT_RECEIPT);
        }

        if (oldHoaDonId != null) recalculate(oldHoaDonId);
        UUID newHoaDonId = saved.getHoaDon() != null ? saved.getHoaDon().getId() : null;
        if (newHoaDonId != null && !newHoaDonId.equals(oldHoaDonId)) recalculate(newHoaDonId);

        logAudit(saved, "UPDATE");
        return toResponse(saved, newHoaDonId != null ? chiTietHoaDonRepository.findByHoaDonId(newHoaDonId) : Collections.emptyList());
    }

    @Transactional
    public void delete(UUID id) {
        ThanhToan tt = thanhToanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thanh toán"));
        assertCanWriteHoaDon(tt.getHoaDon(), permissionService.requireCurrentUserId());
        UUID hdId = tt.getHoaDon() != null ? tt.getHoaDon().getId() : null;
        
        // Chuyển delete vật lý thành cancel
        tt.setTrangThai(TrangThaiThanhToan.CANCELLED);
        thanhToanRepository.save(tt);
        logAudit(tt, "CANCEL");
        if (hdId != null) recalculate(hdId);
    }

    private void recalculate(UUID hoaDonId) {
        HoaDon hd = hoaDonRepository.findById(hoaDonId).orElse(null);
        if (hd == null || hd.getXoaLuc() != null) return;
        BigDecimal total = thanhToanRepository.findByHoaDonIdOrderByNgayThanhToanDesc(hoaDonId).stream()
                .filter(tt -> tt.getTrangThai() == TrangThaiThanhToan.SUCCESS)
                .map(ThanhToan::getSoTien)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        hd.setDaTra(total);
        hd.setTrangThai(resolveInvoiceStatus(total, hd.getTongTien(), hd.getHanTra()));
        hoaDonRepository.save(hd);
    }

    private void assertCanReadHoaDon(HoaDon hoaDon, UUID userId) {
        if (!canReadHoaDon(hoaDon, userId)) {
            throw new RuntimeException("Ban khong co quyen xem thanh toan nay");
        }
    }

    private void assertCanWriteHoaDon(HoaDon hoaDon, UUID userId) {
        if (!canWriteHoaDon(hoaDon, userId)) {
            throw new RuntimeException("Ban khong co quyen sua thanh toan nay");
        }
    }

    private boolean canReadHoaDon(HoaDon hoaDon, UUID userId) {
        if (hoaDon == null || userId == null || hoaDon.getXoaLuc() != null) {
            return false;
        }
        if (permissionService.isAdmin(userId) || isTenantInvoiceOwner(hoaDon, userId)) {
            return true;
        }
        return canReadPhong(hoaDon.getPhong(), userId);
    }

    private boolean canWriteHoaDon(HoaDon hoaDon, UUID userId) {
        return hoaDon != null && hoaDon.getXoaLuc() == null && canWritePhong(hoaDon.getPhong(), userId);
    }

    private boolean isTenantInvoiceOwner(HoaDon hoaDon, UUID userId) {
        KhachThue khachThue = hoaDon != null ? hoaDon.getKhachThue() : null;
        return khachThue != null && khachThue.getNguoiDung() != null && userId.equals(khachThue.getNguoiDung().getId());
    }

    private boolean canReadPhong(Phong phong, UUID userId) {
        NhaTro nhaTro = phong != null ? phong.getNhaTro() : null;
        if (nhaTro == null || nhaTro.getId() == null) {
            return false;
        }
        return permissionService.canReadNhaTro(userId, nhaTro.getId(), ownerId(nhaTro));
    }

    private boolean canWritePhong(Phong phong, UUID userId) {
        NhaTro nhaTro = phong != null ? phong.getNhaTro() : null;
        if (nhaTro == null || nhaTro.getId() == null) {
            return false;
        }
        return permissionService.canWriteNhaTro(userId, nhaTro.getId(), ownerId(nhaTro));
    }

    private UUID ownerId(NhaTro nhaTro) {
        return nhaTro != null && nhaTro.getChuTro() != null ? nhaTro.getChuTro().getId() : null;
    }

    private ZonedDateTime parseNgayThanhToan(String value) {
        if (value == null || value.isBlank()) return ZonedDateTime.now();
        try {
            return LocalDate.parse(value).atStartOfDay(ZoneId.systemDefault());
        } catch (Exception ignored) {
            return ZonedDateTime.now();
        }
    }

    private PhuongThucThanhToan parsePhuongThuc(String value) {
        if (value == null || value.isBlank()) return PhuongThucThanhToan.CASH;
        return switch (value) {
            case "tienMat" -> PhuongThucThanhToan.CASH;
            case "chuyenKhoan" -> PhuongThucThanhToan.BANK_TRANSFER;
            case "vietQr" -> PhuongThucThanhToan.VIETQR;
            case "viDienTu" -> PhuongThucThanhToan.MOMO;
            case "khac" -> PhuongThucThanhToan.OTHER;
            default -> {
                try {
                    yield PhuongThucThanhToan.valueOf(value.toUpperCase());
                } catch (Exception e) {
                    yield PhuongThucThanhToan.CASH;
                }
            }
        };
    }

    private TrangThaiHoaDon resolveInvoiceStatus(BigDecimal paid, BigDecimal total, LocalDate hanTra) {
        BigDecimal safeTotal = total != null ? total : BigDecimal.ZERO;
        if (paid.compareTo(BigDecimal.ZERO) == 0 && hanTra != null && hanTra.isBefore(LocalDate.now())) return TrangThaiHoaDon.OVERDUE;
        if (paid.compareTo(BigDecimal.ZERO) == 0) return TrangThaiHoaDon.UNPAID;
        if (paid.compareTo(safeTotal) < 0) return TrangThaiHoaDon.PARTIAL;
        if (paid.compareTo(safeTotal) == 0) return TrangThaiHoaDon.PAID;
        return TrangThaiHoaDon.OVERPAID;
    }

    private ThanhToanResponse toResponse(ThanhToan thanhToan, List<ChiTietHoaDon> chiTietList) {
        ThanhToanResponse response = ThanhToanResponse.fromEntity(thanhToan, chiTietList);
        response.setAnhBienLai(mediaService.firstUrl(LoaiDoiTuongMedia.PAYMENT, thanhToan.getId(), MediaService.PAYMENT_RECEIPT));
        return response;
    }

    @org.springframework.beans.factory.annotation.Autowired
    private com.example.quanlyphongtro.repository.AuditLogRepository auditLogRepository;

    private void logAudit(ThanhToan tt, String hanhDong) {
        if (auditLogRepository == null) return;
        com.example.quanlyphongtro.entity.AuditLog log = com.example.quanlyphongtro.entity.AuditLog.builder()
            .nguoiDung(com.example.quanlyphongtro.entity.NguoiDung.builder().id(permissionService.requireCurrentUserId()).build())
            .hanhDong(hanhDong)
            .bangTacDong("thanh_toan")
            .banGhiId(tt.getId())
            .taoLuc(ZonedDateTime.now())
            .build();
        auditLogRepository.save(log);
    }

    private TrangThaiThanhToan parseTrangThai(String value) {
        if (value == null || value.isBlank()) return TrangThaiThanhToan.PENDING;
        try {
            return TrangThaiThanhToan.valueOf(value.trim().toUpperCase(java.util.Locale.ROOT));
        } catch (Exception e) {
            throw new RuntimeException("Trạng thái thanh toán không hợp lệ: " + value);
        }
    }

    private UUID parseOptionalUuid(String value) {
        if (value == null || value.isBlank() || "all".equalsIgnoreCase(value)) {
            return null;
        }
        try {
            return UUID.fromString(value);
        } catch (IllegalArgumentException ex) {
            throw new RuntimeException("ID khong hop le");
        }
    }
}
