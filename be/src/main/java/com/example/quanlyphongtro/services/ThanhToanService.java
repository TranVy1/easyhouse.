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
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ThanhToanService {

    private final ThanhToanRepository thanhToanRepository;
    private final HoaDonRepository hoaDonRepository;
    private final ChiTietHoaDonRepository chiTietHoaDonRepository;
    private final HopDongRepository hopDongRepository;
    private final MediaService mediaService;
    private final PermissionService permissionService;
    private final EmailService emailService;

    @Transactional(readOnly = true)
    public PaginatedResponse<ThanhToanResponse> getAll(
            String hoaDonId,
            String trangThaiStr,
            String search,
            String phuongThuc,
            String tuNgay,
            String denNgay,
            int page,
            int limit) {
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
        PhuongThucThanhToan method = parseOptionalPhuongThuc(phuongThuc);
        String normalizedSearch = search != null && !search.isBlank() ? search.trim() : null;
        ZonedDateTime from = parseFilterDate(tuNgay, false);
        ZonedDateTime toExclusive = parseFilterDate(denNgay, true);

        Pageable pageable = PageRequest.of(Math.max(0, page - 1), limit, Sort.by(Sort.Direction.DESC, "ngayThanhToan"));
        Page<ThanhToan> pageResult = thanhToanRepository.findAllAccessible(
                isAdmin,
                userId,
                nhaTroIds,
                hid,
                tt != null ? tt.name() : null,
                method != null ? method.name() : null,
                normalizedSearch,
                from,
                toExclusive,
                pageable);
        
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
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn"));
        assertCanReadHoaDon(hoaDon, permissionService.requireCurrentUserId());
        // FIX #5: Load chi tiết hóa đơn 1 lần duy nhất, tránh N+1 query
        List<ChiTietHoaDon> chiTiet = chiTietHoaDonRepository.findByHoaDonId(hoaDonId);
        return thanhToanRepository.findByHoaDonIdOrderByNgayThanhToanDesc(hoaDonId).stream()
                .map(tt -> toResponse(tt, chiTiet))
                .toList();
    }

    @Transactional
    public ThanhToanResponse create(ThanhToanRequest req) {
        if (req.getIdempotencyKey() == null || req.getIdempotencyKey().isBlank()) {
            throw new RuntimeException("Idempotency key là bắt buộc khi ghi nhận thanh toán");
        }
        String externalId = "MANUAL:" + req.getIdempotencyKey().trim();
        Optional<ThanhToan> previousPayment = thanhToanRepository.findByExternalTransactionId(externalId);
        if (previousPayment.isPresent()) {
            ThanhToan existing = previousPayment.get();
            assertCanWriteHoaDon(existing.getHoaDon(), permissionService.requireCurrentUserId());
            return toResponse(existing, chiTietHoaDonRepository.findByHoaDonId(existing.getHoaDon().getId()));
        }

        HoaDon hoaDon = hoaDonRepository.findById(req.getHoaDonId())
                .orElseThrow(() -> new RuntimeException("KhÃ´ng tÃ¬m tháº¥y hÃ³a Ä‘Æ¡n"));
        UUID userId = permissionService.requireCurrentUserId();
        assertCanWriteHoaDon(hoaDon, userId);
        if (hoaDon.getXoaLuc() != null || hoaDon.getTrangThai() == TrangThaiHoaDon.CANCELLED) {
            throw new RuntimeException("KhÃ´ng thá»ƒ thanh toÃ¡n hÃ³a Ä‘Æ¡n Ä‘Ã£ xÃ³a hoáº·c Ä‘Ã£ há»§y");
        }

        hoaDon = hoaDonRepository.findByIdForUpdate(hoaDon.getId())
                .orElseThrow(() -> new RuntimeException("Khong tim thay hoa don"));

        TrangThaiThanhToan status = TrangThaiThanhToan.SUCCESS;
        if (req.getTrangThai() != null) {
            status = parseTrangThai(req.getTrangThai());
        }
        validatePaymentAmount(hoaDon, req.getSoTien(), status, null);

        ThanhToan tt = ThanhToan.builder()
                .hoaDon(hoaDon)
                .khachThue(hoaDon.getKhachThue())
                .soTien(req.getSoTien())
                .phuongThucThanhToan(parsePhuongThuc(req.getPhuongThuc()))
                .maThamChieu(req.getThongTinChuyenKhoan() != null ? req.getThongTinChuyenKhoan().getSoGiaoDich() : null)
                .externalTransactionId(externalId)
                .ngayThanhToan(parseNgayThanhToan(req.getNgayThanhToan()))
                .nguoiGhiNhan(NguoiDung.builder().id(userId).build())
                .ghiChu(req.getGhiChu())
                .trangThai(status)
                .build();
        ThanhToan saved = thanhToanRepository.save(tt);
        if (saved.getTrangThai() == TrangThaiThanhToan.SUCCESS && saved.getPhuongThucThanhToan() == PhuongThucThanhToan.DEPOSIT) {
            adjustDeposit(hoaDon, saved.getSoTien(), true);
        }
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
        HoaDon lockedInvoice = hoaDonRepository.findByIdForUpdate(hoaDon.getId())
                .orElseThrow(() -> new RuntimeException("Khong tim thay hoa don"));
        validatePaymentAmount(lockedInvoice, transaction.getSoTien(), TrangThaiThanhToan.SUCCESS, null);
        ThanhToan payment = ThanhToan.builder()
                .hoaDon(lockedInvoice)
                .khachThue(lockedInvoice.getKhachThue())
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
        recalculate(lockedInvoice.getId());
        logAudit(saved, "MANUAL_MATCH");
    }

    @Transactional
    public ThanhToanResponse update(UUID id, ThanhToanRequest req) {
        ThanhToan tt = thanhToanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay thanh toan"));
        UUID userId = permissionService.requireCurrentUserId();
        assertCanWriteHoaDon(tt.getHoaDon(), userId);
        if (tt.getTrangThai() == TrangThaiThanhToan.SUCCESS) {
            throw new RuntimeException("Không thể sửa giao dịch thanh toán đã thành công; hãy lập chứng từ điều chỉnh riêng");
        }
        UUID oldHoaDonId = tt.getHoaDon() != null ? tt.getHoaDon().getId() : null;

        boolean oldIsDeposit = tt.getTrangThai() == TrangThaiThanhToan.SUCCESS && tt.getPhuongThucThanhToan() == PhuongThucThanhToan.DEPOSIT;
        BigDecimal oldSoTien = tt.getSoTien();
        HoaDon oldHoaDon = tt.getHoaDon();

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
            tt.setSoTien(req.getSoTien());
        }
        if (req.getPhuongThuc() != null) tt.setPhuongThucThanhToan(parsePhuongThuc(req.getPhuongThuc()));
        if (req.getThongTinChuyenKhoan() != null) tt.setMaThamChieu(req.getThongTinChuyenKhoan().getSoGiaoDich());
        if (req.getNgayThanhToan() != null) tt.setNgayThanhToan(parseNgayThanhToan(req.getNgayThanhToan()));
        if (req.getGhiChu() != null) tt.setGhiChu(req.getGhiChu());
        if (req.getTrangThai() != null) tt.setTrangThai(parseTrangThai(req.getTrangThai()));

        HoaDon lockedInvoice = hoaDonRepository.findByIdForUpdate(tt.getHoaDon().getId())
                .orElseThrow(() -> new RuntimeException("Khong tim thay hoa don"));
        tt.setHoaDon(lockedInvoice);
        tt.setKhachThue(lockedInvoice.getKhachThue());
        validatePaymentAmount(lockedInvoice, tt.getSoTien(), tt.getTrangThai(), tt.getId());

        if (oldIsDeposit) {
            adjustDeposit(oldHoaDon, oldSoTien, false);
        }

        ThanhToan saved = thanhToanRepository.save(tt);
        
        boolean newIsDeposit = saved.getTrangThai() == TrangThaiThanhToan.SUCCESS && saved.getPhuongThucThanhToan() == PhuongThucThanhToan.DEPOSIT;
        if (newIsDeposit) {
            adjustDeposit(saved.getHoaDon(), saved.getSoTien(), true);
        }
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
        if (tt.getTrangThai() == TrangThaiThanhToan.SUCCESS) {
            throw new RuntimeException("Không thể hủy giao dịch thanh toán đã thành công; hãy lập chứng từ điều chỉnh riêng");
        }
        UUID hdId = tt.getHoaDon() != null ? tt.getHoaDon().getId() : null;
        
        // Chuyển delete vật lý thành cancel
        if (tt.getTrangThai() == TrangThaiThanhToan.SUCCESS && tt.getPhuongThucThanhToan() == PhuongThucThanhToan.DEPOSIT) {
            adjustDeposit(tt.getHoaDon(), tt.getSoTien(), false);
        }
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

        // Kích hoạt hợp đồng nếu thanh toán đủ và hợp đồng đang chờ kích hoạt
        if (hd.getTrangThai() == TrangThaiHoaDon.PAID) {
            com.example.quanlyphongtro.entity.HopDong hopDong = hd.getHopDong();
            if (hopDong != null && hopDong.getTrangThai() == com.example.quanlyphongtro.entity.TrangThaiHopDong.PENDING) {
                hopDong.setTrangThai(com.example.quanlyphongtro.entity.TrangThaiHopDong.ACTIVE);
                hopDong.setTrangThaiCoc(com.example.quanlyphongtro.entity.TrangThaiCocHopDong.KEPT);
                hopDongRepository.save(hopDong);
            }
        }
    }

    private void validatePaymentAmount(HoaDon hoaDon, BigDecimal soTien, TrangThaiThanhToan trangThai, UUID excludePaymentId) {
        if (trangThai != TrangThaiThanhToan.SUCCESS) return;
        if (soTien == null || soTien.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("So tien thanh toan phai lon hon 0");
        }
        List<ThanhToan> successfulPayments = thanhToanRepository.findByHoaDonIdOrderByNgayThanhToanDesc(hoaDon.getId()).stream()
                .filter(thanhToan -> thanhToan.getTrangThai() == TrangThaiThanhToan.SUCCESS)
                .filter(thanhToan -> excludePaymentId == null || !excludePaymentId.equals(thanhToan.getId()))
                .toList();
        if (!successfulPayments.isEmpty()) {
            throw new RuntimeException("Hóa đơn đã có giao dịch thanh toán thành công");
        }
        BigDecimal total = hoaDon.getTongTien() != null ? hoaDon.getTongTien() : BigDecimal.ZERO;
        if (soTien.compareTo(total) != 0) {
            throw new RuntimeException("Số tiền thanh toán phải đúng bằng tổng hóa đơn: " + total);
        }
    }

    private void adjustDeposit(HoaDon hoaDon, BigDecimal amount, boolean isDeduction) {
        if (hoaDon == null || hoaDon.getHopDong() == null || amount == null || amount.compareTo(BigDecimal.ZERO) == 0) return;
        com.example.quanlyphongtro.entity.HopDong hd = hoaDon.getHopDong();
        BigDecimal currentDeposit = hd.getTienCoc() != null ? hd.getTienCoc() : BigDecimal.ZERO;
        if (isDeduction) {
            if (currentDeposit.compareTo(amount) < 0) {
                throw new RuntimeException("Số tiền cọc còn lại (" + currentDeposit + ") không đủ để thanh toán (" + amount + ")");
            }
            hd.setTienCoc(currentDeposit.subtract(amount));
        } else {
            hd.setTienCoc(currentDeposit.add(amount));
        }
        hopDongRepository.save(hd);
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
            case "truTienCoc" -> PhuongThucThanhToan.DEPOSIT;
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

    private PhuongThucThanhToan parseOptionalPhuongThuc(String value) {
        if (value == null || value.isBlank() || "all".equalsIgnoreCase(value)) {
            return null;
        }
        return parsePhuongThuc(value);
    }

    private ZonedDateTime parseFilterDate(String value, boolean endExclusive) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            LocalDate date = LocalDate.parse(value);
            return (endExclusive ? date.plusDays(1) : date).atStartOfDay(ZoneId.systemDefault());
        } catch (Exception ex) {
            throw new RuntimeException("Ngày lọc không hợp lệ: " + value);
        }
    }

    private TrangThaiHoaDon resolveInvoiceStatus(BigDecimal paid, BigDecimal total, LocalDate hanTra) {
        BigDecimal safeTotal = total != null ? total : BigDecimal.ZERO;
        if (paid.compareTo(safeTotal) == 0 && safeTotal.compareTo(BigDecimal.ZERO) > 0) return TrangThaiHoaDon.PAID;
        if (hanTra != null && hanTra.isBefore(LocalDate.now())) return TrangThaiHoaDon.OVERDUE;
        return TrangThaiHoaDon.UNPAID;
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
