package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.HopDongRequest;
import com.example.quanlyphongtro.dto.HopDongResponse;
import com.example.quanlyphongtro.dto.HopDongDichVuOptionResponse;
import com.example.quanlyphongtro.dto.KhachThueResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import org.springframework.transaction.annotation.Transactional;

import java.text.Normalizer;
import java.time.LocalDate;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class HopDongService {
    private static final List<TrangThaiHopDong> OCCUPYING_STATUSES = List.of(TrangThaiHopDong.PENDING, TrangThaiHopDong.ACTIVE);

    private final HopDongRepository hopDongRepository;
    private final PhongRepository phongRepository;
    private final KhachThueRepository khachThueRepository;
    private final ThanhVienHopDongRepository thanhVienHopDongRepository;
    private final DichVuHopDongRepository dichVuHopDongRepository;
    private final DichVuRepository dichVuRepository;
    private final CauHinhGiaRepository cauHinhGiaRepository;
    private final HoaDonRepository hoaDonRepository;
    private final ChiTietHoaDonRepository chiTietHoaDonRepository;
    private final PermissionService permissionService;
    private final JdbcTemplate jdbcTemplate;
    private final KhachThueService khachThueService;

    @org.springframework.beans.factory.annotation.Autowired
    @org.springframework.context.annotation.Lazy
    private com.example.quanlyphongtro.services.HoaDonService hoaDonService;

    @org.springframework.beans.factory.annotation.Autowired
    @org.springframework.context.annotation.Lazy
    private com.example.quanlyphongtro.services.ThanhToanService thanhToanService;

    @org.springframework.beans.factory.annotation.Autowired
    private com.example.quanlyphongtro.repository.AuditLogRepository auditLogRepository;

    @org.springframework.beans.factory.annotation.Autowired
    private com.example.quanlyphongtro.repository.ThanhToanRepository thanhToanRepository;

    @Transactional(readOnly = true)
    public PaginatedResponse<HopDongResponse> getAll(String toaNhaId, String phongId, String trangThaiStr, String search, int page, int limit) {
        UUID userId = permissionService.currentUserId().orElse(null);
        boolean isAdmin = userId != null && permissionService.isAdmin(userId);
        List<UUID> nhaTroIds = List.of(UUID.randomUUID());
        if (!isAdmin && userId != null) {
            List<UUID> accessibleIds = permissionService.getAllAccessibleNhaTroIds(userId);
            if (!accessibleIds.isEmpty()) {
                nhaTroIds = accessibleIds;
            }
        }
        
        TrangThaiHopDong tt = null;
        if (trangThaiStr != null && !trangThaiStr.isBlank() && !trangThaiStr.equals("all")) {
            try { tt = TrangThaiHopDong.valueOf(trangThaiStr.toUpperCase()); } catch (Exception ignored) {}
        }
        
        UUID pid = parseOptionalUuid(phongId);
        UUID nid = parseOptionalUuid(toaNhaId);
        String normalizedSearch = search != null && !search.isBlank() ? search.trim() : null;

        Pageable pageable = PageRequest.of(Math.max(0, page - 1), limit, Sort.by(Sort.Direction.DESC, "taoLuc"));
        Page<HopDong> pageResult = hopDongRepository.findAllAccessible(
                isAdmin, userId, nhaTroIds, pid, nid, tt != null ? tt.name() : null, normalizedSearch, pageable);
        
        List<UUID> hopDongIds = pageResult.getContent().stream().map(HopDong::getId).toList();
        java.util.Map<UUID, List<com.example.quanlyphongtro.entity.ThanhVienHopDong>> memberMap = new java.util.HashMap<>();
        java.util.Map<UUID, List<com.example.quanlyphongtro.entity.DichVuHopDong>> dichVuMap = new java.util.HashMap<>();
        if (!hopDongIds.isEmpty()) {
            thanhVienHopDongRepository.findByHopDongIdInOrderByLaNguoiDaiDienDescTaoLucAsc(hopDongIds)
                .forEach(m -> memberMap.computeIfAbsent(m.getHopDong().getId(), k -> new java.util.ArrayList<>()).add(m));
            dichVuHopDongRepository.findByHopDongIdInOrderByTaoLucAsc(hopDongIds)
                .forEach(s -> dichVuMap.computeIfAbsent(s.getHopDong().getId(), k -> new java.util.ArrayList<>()).add(s));
        }

        List<HopDongResponse> mappedList = pageResult.getContent().stream()
                .map(hd -> toResponse(hd, memberMap.getOrDefault(hd.getId(), java.util.Collections.emptyList()), dichVuMap.getOrDefault(hd.getId(), java.util.Collections.emptyList())))
                .toList();
        return PaginatedResponse.of(pageResult, mappedList);
    }

    @Transactional(readOnly = true)
    public HopDongResponse getById(UUID id) {
        HopDong hd = hopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        if (hd.getXoaLuc() != null) {
            throw new RuntimeException("Không tìm thấy hợp đồng");
        }
        assertCanRead(hd, permissionService.requireCurrentUserId());
        return toResponse(hd);
    }

    @Transactional
    public HopDongResponse create(HopDongRequest req) {
        UUID phongId = coalesce(req.getPhongId(), req.getPhong());
        if (phongId == null) {
            throw new RuntimeException("Vui lòng chọn phòng cho hợp đồng");
        }
        UUID khachThueId = resolveRepresentativeId(req);
        if (khachThueId == null) {
            throw new RuntimeException("Vui lòng chọn người đại diện hợp đồng");
        }

        Phong phong = phongRepository.findById(phongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));
        assertCanWritePhong(phong, permissionService.requireCurrentUserId());

        KhachThue kt = khachThueRepository.findById(khachThueId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy khách thuê"));
        TrangThaiHopDong trangThai = parseStatus(req.getTrangThai(), TrangThaiHopDong.DRAFT);
        assertManualStatusAllowed(trangThai);
        validateRoomCanContract(phong, trangThai);
        validateTenantBelongsToRoomOwner(kt, phong);
        kt = khachThueService.ensureTaiKhoanDangNhap(kt);
        BigDecimal giaThue = firstMoney(req.getGiaThueHopDong(), req.getGiaThue(), phong.getGiaHienTai());
        BigDecimal tienCoc = firstMoney(req.getTienCoc(), phong.getTienCocMacDinh(), BigDecimal.ZERO);
        TrangThaiCocHopDong trangThaiCocVal = parseCocStatus(req.getTrangThaiCoc());
        
        if (tienCoc.compareTo(BigDecimal.ZERO) > 0 && trangThaiCocVal == TrangThaiCocHopDong.NOT_PAID) {
            trangThai = TrangThaiHopDong.PENDING;
        }
        Integer ngayThanhToan = req.getNgayThanhToanHangThang() != null ? req.getNgayThanhToanHangThang()
                : (req.getNgayThanhToan() != null ? req.getNgayThanhToan() : 5);
        validateContractPayload(req.getNgayBatDau(), req.getNgayKetThuc(), giaThue, tienCoc, ngayThanhToan);
        validateInitialReadings(req.getChiSoDienBanDau(), req.getChiSoNuocBanDau());
        validateMemberPayload(req, phong, kt, req.getNgayBatDau(), req.getNgayKetThuc());
        ensureNoOverlappingOccupancy(phong.getId(), req.getNgayBatDau(), req.getNgayKetThuc(), null, trangThai);
        String maHopDong = resolveContractCode(req.getMaHopDong(), phong, req.getNgayBatDau());
        ensureContractCodeAvailable(maHopDong, null);

        HopDong hd = HopDong.builder()
                .maHopDong(maHopDong)
                .phong(phong)
                .khachThue(kt)
                .ngayBatDau(req.getNgayBatDau())
                .ngayKetThuc(req.getNgayKetThuc())
                .giaThueHopDong(giaThue)
                .tienCoc(tienCoc)
                .trangThaiCoc(trangThaiCocVal)
                .trangThai(trangThai)
                .chuKyThanhToan(parseChuKy(req.getChuKyThanhToan()))
                .ngayThanhToanHangThang(ngayThanhToan)
                .tuDongGiaHan(req.getTuDongGiaHan() != null ? req.getTuDongGiaHan() : false)
                .chiSoDienBanDau(req.getChiSoDienBanDau())
                .chiSoNuocBanDau(req.getChiSoNuocBanDau())
                .noiDungHopDong(req.getNoiDungHopDong() != null ? req.getNoiDungHopDong() : req.getDieuKhoan())
                .filePdf(req.getFilePdf())
                .ghiChu(req.getGhiChu())
                .build();

        HopDong saved = hopDongRepository.save(hd);
        replaceThanhVien(saved, req);
        replaceDichVuHopDong(saved, req);
        
        if (tienCoc.compareTo(BigDecimal.ZERO) > 0 && saved.getTrangThai() == TrangThaiHopDong.PENDING) {
            java.time.LocalDate now = java.time.LocalDate.now();
            String maHoaDon = "HD" + System.currentTimeMillis() + java.util.UUID.randomUUID().toString().substring(0, 6).toUpperCase(java.util.Locale.ROOT);
            HoaDon hoaDon = HoaDon.builder()
                .phong(phong)
                .hopDong(saved)
                .khachThue(kt)
                .maHoaDon(maHoaDon)
                .loaiHoaDon(LoaiHoaDon.DEPOSIT_REQUEST)
                .kyNam(now.getYear())
                .kyThang(now.getMonthValue())
                .tuNgay(req.getNgayBatDau())
                .denNgay(req.getNgayBatDau())
                .soDuDauKy(BigDecimal.ZERO)
                .tongTienPhatSinh(tienCoc)
                .tongTien(tienCoc)
                .daTra(BigDecimal.ZERO)
                .trangThai(TrangThaiHoaDon.ISSUED)
                .hanTra(now.plusDays(7))
                .ngayLapHoaDon(java.time.ZonedDateTime.now())
                .ghiChu("Thu tiền cọc hợp đồng")
                .autoGenerated(true)
                .build();
            
            HoaDon savedHoaDon = hoaDonRepository.save(hoaDon);
            
            ChiTietHoaDon chiTiet = ChiTietHoaDon.builder()
                .hoaDon(savedHoaDon)
                .loai(LoaiMucHoaDon.DEPOSIT)
                .moTa("Tiền cọc hợp đồng")
                .soLuong(BigDecimal.ONE)
                .donGia(tienCoc)
                .thanhTien(tienCoc)
                .sourceType("CONTRACT_DEPOSIT")
                .sourceId(saved.getId())
                .pricingRuleVersion("CONTRACT_DEPOSIT_V1")
                .periodStart(req.getNgayBatDau())
                .periodEnd(req.getNgayBatDau())
                .calculationHash("DEPOSIT-" + savedHoaDon.getId())
                .build();
            chiTietHoaDonRepository.save(chiTiet);
        }

        syncRoomStatus(phong.getId());
        return toResponse(saved);
    }

    @Transactional
    public HopDongResponse thanhToanCoc(UUID id) {
        HopDong hd = hopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        UUID userId = permissionService.requireCurrentUserId();
        
        // Kiểm tra quyền của người thuê
        if (!hd.getKhachThue().getNguoiDung().getId().equals(userId) && !permissionService.isAdmin(userId)) {
            throw new RuntimeException("Bạn không có quyền thao tác trên hợp đồng này");
        }

        if (hd.getTrangThai() != TrangThaiHopDong.PENDING) {
            throw new RuntimeException("Hợp đồng không ở trạng thái chờ thanh toán cọc");
        }

        hd.setTrangThaiCoc(com.example.quanlyphongtro.entity.TrangThaiCocHopDong.KEPT);
        hd.setTrangThai(TrangThaiHopDong.ACTIVE);
        
        List<HoaDon> invoices = hoaDonRepository.findByHopDongIdAndXoaLucIsNull(hd.getId());
        for (HoaDon invoice : invoices) {
            if (Boolean.TRUE.equals(invoice.getAutoGenerated()) && invoice.getLoaiHoaDon() == LoaiHoaDon.DEPOSIT_REQUEST
                    && (invoice.getTrangThai() == TrangThaiHoaDon.ISSUED || invoice.getTrangThai() == TrangThaiHoaDon.UNPAID)) {
                com.example.quanlyphongtro.entity.ThanhToan tt = com.example.quanlyphongtro.entity.ThanhToan.builder()
                        .hoaDon(invoice)
                        .khachThue(invoice.getKhachThue())
                        .soTien(invoice.getTongTienPhatSinh())
                        .phuongThucThanhToan(com.example.quanlyphongtro.entity.PhuongThucThanhToan.BANK_TRANSFER)
                        .ngayThanhToan(java.time.ZonedDateTime.now())
                        .nguoiGhiNhan(com.example.quanlyphongtro.entity.NguoiDung.builder().id(userId).build())
                        .trangThai(com.example.quanlyphongtro.entity.TrangThaiThanhToan.SUCCESS)
                        .ghiChu("Hệ thống tự động ghi nhận thanh toán cọc")
                        .build();
                thanhToanRepository.save(tt);
                invoice.setDaTra(invoice.getTongTienPhatSinh());
                invoice.setTrangThai(TrangThaiHoaDon.PAID);
                hoaDonRepository.save(invoice);
            }
        }

        HopDong saved = hopDongRepository.save(hd);
        // Hợp đồng vừa chuyển sang ACTIVE khi đóng cọc: phải đồng bộ trạng thái phòng
        // (RESERVED -> RENTED). Thiếu bước này khiến phòng kẹt ở "đã đặt" dù hợp đồng
        // đã "hoạt động".
        syncRoomStatus(saved.getPhong().getId());
        return toResponse(saved);
    }

    @Transactional
    public HopDongResponse update(UUID id, HopDongRequest req) {
        HopDong hd = hopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        UUID userId = permissionService.requireCurrentUserId();
        assertCanWrite(hd, userId);
        if (hd.getLockedAt() != null) {
            // Hợp đồng đã khóa, CHỈ cho phép cập nhật trạng thái
            if (req.getTrangThai() != null) {
                TrangThaiHopDong newStatus = parseStatus(req.getTrangThai(), hd.getTrangThai());
                if (newStatus == TrangThaiHopDong.ACTIVE || newStatus == TrangThaiHopDong.TERMINATED) {
                    hd.setTrangThai(newStatus);
                    if (newStatus == TrangThaiHopDong.TERMINATED) {
                        hd.setTrangThaiCoc(com.example.quanlyphongtro.entity.TrangThaiCocHopDong.REFUNDED);
                    }
                    syncRoomStatus(hd.getPhong().getId());
                    return toResponse(hopDongRepository.save(hd));
                }
            }
            throw new RuntimeException("Hợp đồng đã được khóa, chỉ có thể cập nhật trạng thái (Đang hoạt động / Đã chấm dứt)");
        }

        UUID oldPhongId = hd.getPhong() != null ? hd.getPhong().getId() : null;
        UUID phongId = coalesce(req.getPhongId(), req.getPhong());
        UUID khachThueId = resolveRepresentativeId(req);
        if (phongId != null) {
            Phong newPhong = phongRepository.findById(phongId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));
            assertCanWritePhong(newPhong, userId);
            hd.setPhong(newPhong);
        }
        if (khachThueId != null) {
            hd.setKhachThue(khachThueRepository.findById(khachThueId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khách thuê")));
        }
        if (req.getMaHopDong() != null)
            hd.setMaHopDong(resolveContractCode(req.getMaHopDong(), hd.getPhong(), hd.getNgayBatDau()));
        if (req.getNgayBatDau() != null)
            hd.setNgayBatDau(req.getNgayBatDau());
        if (req.getNgayKetThuc() != null)
            hd.setNgayKetThuc(req.getNgayKetThuc());
        if (req.getGiaThueHopDong() != null || req.getGiaThue() != null)
            hd.setGiaThueHopDong(req.getGiaThueHopDong() != null ? req.getGiaThueHopDong() : req.getGiaThue());
        if (req.getTienCoc() != null) {
            BigDecimal oldTienCoc = hd.getTienCoc() != null ? hd.getTienCoc() : BigDecimal.ZERO;
            hd.setTienCoc(req.getTienCoc());
            
            if (hd.getTrangThai() == TrangThaiHopDong.PENDING && req.getTienCoc().compareTo(oldTienCoc) != 0) {
                List<HoaDon> invoices = hoaDonRepository.findByHopDongIdAndXoaLucIsNull(hd.getId());
                boolean foundDepositInvoice = false;
                for (HoaDon invoice : invoices) {
                    if (Boolean.TRUE.equals(invoice.getAutoGenerated()) && invoice.getLoaiHoaDon() == LoaiHoaDon.DEPOSIT_REQUEST
                            && (invoice.getTrangThai() == TrangThaiHoaDon.ISSUED || invoice.getTrangThai() == TrangThaiHoaDon.UNPAID)) {
                        foundDepositInvoice = true;
                        // A deposit request is an issued financial document: preserve it and replace it,
                        // never overwrite its amount or detail line.
                        invoice.setTrangThai(TrangThaiHoaDon.CANCELLED);
                        invoice.setGhiChu((invoice.getGhiChu() == null ? "" : invoice.getGhiChu() + "\n")
                                + "Hủy do điều chỉnh tiền cọc hợp đồng trước khi thanh toán");
                        hoaDonRepository.save(invoice);
                        if (req.getTienCoc().compareTo(BigDecimal.ZERO) > 0) {
                            foundDepositInvoice = false;
                        }
                    }
                }
                if (!foundDepositInvoice && req.getTienCoc().compareTo(BigDecimal.ZERO) > 0) {
                    java.time.LocalDate now = java.time.LocalDate.now();
                    String maHoaDon = "HD" + System.currentTimeMillis() + java.util.UUID.randomUUID().toString().substring(0, 6).toUpperCase(java.util.Locale.ROOT);
                    HoaDon hoaDon = HoaDon.builder()
                        .phong(hd.getPhong())
                        .hopDong(hd)
                        .khachThue(hd.getKhachThue())
                        .maHoaDon(maHoaDon)
                        .loaiHoaDon(LoaiHoaDon.DEPOSIT_REQUEST)
                        .kyNam(now.getYear())
                        .kyThang(now.getMonthValue())
                        .tuNgay(hd.getNgayBatDau())
                        .denNgay(hd.getNgayBatDau())
                        .soDuDauKy(BigDecimal.ZERO)
                        .tongTienPhatSinh(req.getTienCoc())
                        .tongTien(req.getTienCoc())
                        .daTra(BigDecimal.ZERO)
                        .trangThai(TrangThaiHoaDon.ISSUED)
                        .hanTra(now.plusDays(7))
                        .ngayLapHoaDon(java.time.ZonedDateTime.now())
                        .ghiChu("Thu tiền cọc hợp đồng")
                        .autoGenerated(true)
                        .build();
                    
                    HoaDon savedHoaDon = hoaDonRepository.save(hoaDon);
                    
                    ChiTietHoaDon chiTiet = ChiTietHoaDon.builder()
                        .hoaDon(savedHoaDon)
                        .loai(LoaiMucHoaDon.DEPOSIT)
                        .moTa("Tiền cọc hợp đồng")
                        .soLuong(BigDecimal.ONE)
                        .donGia(req.getTienCoc())
                        .thanhTien(req.getTienCoc())
                        .sourceType("CONTRACT_DEPOSIT")
                        .sourceId(hd.getId())
                        .pricingRuleVersion("CONTRACT_DEPOSIT_V1")
                        .periodStart(hd.getNgayBatDau())
                        .periodEnd(hd.getNgayBatDau())
                        .calculationHash("DEPOSIT-" + savedHoaDon.getId())
                        .build();
                    chiTietHoaDonRepository.save(chiTiet);
                }
            }
        }
        if (req.getTrangThaiCoc() != null)
            hd.setTrangThaiCoc(parseCocStatus(req.getTrangThaiCoc()));
        if (req.getChuKyThanhToan() != null)
            hd.setChuKyThanhToan(parseChuKy(req.getChuKyThanhToan()));
        if (req.getNgayThanhToanHangThang() != null || req.getNgayThanhToan() != null)
            hd.setNgayThanhToanHangThang(
                    req.getNgayThanhToanHangThang() != null ? req.getNgayThanhToanHangThang() : req.getNgayThanhToan());
        if (req.getTuDongGiaHan() != null)
            hd.setTuDongGiaHan(req.getTuDongGiaHan());
        if (req.getChiSoDienBanDau() != null)
            hd.setChiSoDienBanDau(req.getChiSoDienBanDau());
        if (req.getChiSoNuocBanDau() != null)
            hd.setChiSoNuocBanDau(req.getChiSoNuocBanDau());
        if (req.getNoiDungHopDong() != null || req.getDieuKhoan() != null)
            hd.setNoiDungHopDong(req.getNoiDungHopDong() != null ? req.getNoiDungHopDong() : req.getDieuKhoan());
        if (req.getFilePdf() != null)
            hd.setFilePdf(req.getFilePdf());
        if (req.getGhiChu() != null)
            hd.setGhiChu(req.getGhiChu());

        if (req.getTrangThai() != null) {
            TrangThaiHopDong newStatus = parseStatus(req.getTrangThai(), hd.getTrangThai());
            assertManualStatusAllowed(newStatus);
            hd.setTrangThai(newStatus);
            if (newStatus == TrangThaiHopDong.TERMINATED) {
                hd.setTrangThaiCoc(com.example.quanlyphongtro.entity.TrangThaiCocHopDong.REFUNDED);
            }
        }
        if (hd.getMaHopDong() == null || hd.getMaHopDong().isBlank()) {
            hd.setMaHopDong(resolveContractCode(null, hd.getPhong(), hd.getNgayBatDau()));
        }
        ensureContractCodeAvailable(hd.getMaHopDong(), hd.getId());
        validateRoomCanContract(hd.getPhong(), hd.getTrangThai());
        validateTenantBelongsToRoomOwner(hd.getKhachThue(), hd.getPhong());
        hd.setKhachThue(khachThueService.ensureTaiKhoanDangNhap(hd.getKhachThue()));
        validateContractPayload(hd.getNgayBatDau(), hd.getNgayKetThuc(), hd.getGiaThueHopDong(), hd.getTienCoc(),
                hd.getNgayThanhToanHangThang());
        validateInitialReadings(hd.getChiSoDienBanDau(), hd.getChiSoNuocBanDau());
        if (req.hasMemberPayload()) {
            validateMemberPayload(req, hd.getPhong(), hd.getKhachThue(), hd.getNgayBatDau(), hd.getNgayKetThuc());
        }
        ensureNoOverlappingOccupancy(hd.getPhong().getId(), hd.getNgayBatDau(), hd.getNgayKetThuc(), hd.getId(),
                hd.getTrangThai());
        HopDong saved = hopDongRepository.save(hd);
        if (req.hasMemberPayload()) {
            replaceThanhVien(saved, req);
        }
        if (req.getPhiDichVu() != null) {
            replaceDichVuHopDong(saved, req);
        }
        if (oldPhongId != null && !oldPhongId.equals(saved.getPhong().getId())) {
            syncRoomStatus(oldPhongId);
        }
        syncRoomStatus(saved.getPhong().getId());
        return toResponse(saved);
    }

    @Transactional
    public HopDongResponse preview(UUID id) {
        HopDong hd = hopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        assertCanWrite(hd, permissionService.requireCurrentUserId());
        if (hd.getLockedAt() != null) {
            throw new RuntimeException("Hợp đồng đã được xác nhận và khóa dữ liệu");
        }

        hd.setTemplateVersion(hd.getTemplateVersion() != null ? hd.getTemplateVersion() : "default-v1");
                hd.setPreviewedAt(java.time.ZonedDateTime.now());
        return toResponse(hopDongRepository.save(hd));
    }

    @Transactional
    public HopDongResponse confirm(UUID id) {
        HopDong hd = hopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        assertCanWrite(hd, permissionService.requireCurrentUserId());
        if (hd.getLockedAt() != null) {
            throw new RuntimeException("Hợp đồng đã được xác nhận trước đó");
        }

        // Hop dong chi co hieu luc khi ca hai ben da ky dien tu. Truoc day buoc
        // "Xac nhan" khoa du lieu va chuyen ACTIVE ma khong can chu ky nao, khien
        // chu ky dien tu mat y nghia va hop dong bi khoa truoc khi kip bo sung
        // thong tin con thieu. Viec khoa + chuyen ACTIVE do signContract lo khi
        // signatureStatus = COMPLETED.
        if (hd.getSignatureStatus() != SignatureStatus.COMPLETED) {
            throw new RuntimeException(
                    "Hợp đồng chỉ có hiệu lực sau khi cả hai bên ký điện tử. "
                    + "Vui lòng vào tab \"Văn bản & Ký điện tử\" để ký.");
        }

        validateRoomCanContract(hd.getPhong(), TrangThaiHopDong.ACTIVE);
        validateTenantBelongsToRoomOwner(hd.getKhachThue(), hd.getPhong());
        hd.setKhachThue(khachThueService.ensureTaiKhoanDangNhap(hd.getKhachThue()));
        validateContractPayload(hd.getNgayBatDau(), hd.getNgayKetThuc(), hd.getGiaThueHopDong(), hd.getTienCoc(),
                hd.getNgayThanhToanHangThang());
        ensureNoOverlappingOccupancy(hd.getPhong().getId(), hd.getNgayBatDau(), hd.getNgayKetThuc(), hd.getId(),
                TrangThaiHopDong.ACTIVE);

        java.time.ZonedDateTime now = java.time.ZonedDateTime.now();
        hd.setTemplateVersion(hd.getTemplateVersion() != null ? hd.getTemplateVersion() : "default-v1");
        hd.setTrangThai(TrangThaiHopDong.ACTIVE);
        hd.setConfirmedAt(now);
        hd.setLockedAt(now);

        HopDong saved = hopDongRepository.save(hd);
        syncRoomStatus(saved.getPhong().getId());
        jdbcTemplate.queryForObject("SELECT public.tao_lich_thanh_toan_hang_thang(?::uuid)", Integer.class, saved.getId());
        logAudit(saved, "CONFIRM");
        return toResponse(saved);
    }

    @Transactional(readOnly = true)
    public List<HopDongDichVuOptionResponse> getDichVuTheoPhong(UUID phongId) {
        Phong phong = phongRepository.findById(phongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));
        assertCanReadPhong(phong, permissionService.requireCurrentUserId());
        if (phong.getNhaTro() == null) {
            return List.of();
        }
        LocalDate today = LocalDate.now();
        Map<UUID, HopDongDichVuOptionResponse> options = new LinkedHashMap<>();

        if (phong.getNhaTro() != null && phong.getNhaTro().getChuTro() != null) {
            List<DichVu> defaultServices = dichVuRepository.findByChuTroId(phong.getNhaTro().getChuTro().getId());
            for (DichVu dv : defaultServices) {
                options.put(dv.getId(), HopDongDichVuOptionResponse.builder()
                        .dichVuId(dv.getId())
                        .ten(dv.getTenDichVu())
                        .loaiTinhPhi(dv.getLoaiTinhPhi() != null ? dv.getLoaiTinhPhi().name() : null)
                        .donVi(dv.getDonVi())
                        .donGiaMacDinh(dv.getDonGiaMacDinh())
                        .batBuoc(Boolean.TRUE.equals(dv.getBatBuoc()))
                        .build());
            }
        }

        for (CauHinhGia config : cauHinhGiaRepository.findApplicableServices(phong.getNhaTro().getId(), today)) {
            if (config.getDichVuId() == null)
                continue;
            DichVu dichVu = dichVuRepository.findById(config.getDichVuId()).orElse(null);
            options.put(config.getDichVuId(), HopDongDichVuOptionResponse.builder()
                    .dichVuId(config.getDichVuId())
                    .ten(config.getTenHienThi())
                    .loaiTinhPhi(config.getLoaiTinhPhi() != null ? config.getLoaiTinhPhi().name() : null)
                    .donVi(dichVu != null ? dichVu.getDonVi() : null)
                    .donGiaMacDinh(config.getDonGia())
                    .batBuoc(dichVu != null && Boolean.TRUE.equals(dichVu.getBatBuoc()))
                    .build());
        }

        return new ArrayList<>(options.values());
    }

    @Transactional
    public void delete(UUID id) {
        HopDong hd = hopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        assertCanWrite(hd, permissionService.requireCurrentUserId());
        if (hd.getLockedAt() != null || hd.getTrangThai() == TrangThaiHopDong.ACTIVE || hd.getTrangThai() == TrangThaiHopDong.TERMINATED) {
            throw new RuntimeException("Hợp đồng đã xác nhận hoặc đã phát sinh thực tế, hãy kết thúc hợp đồng thay vì xóa");
        }
        
        List<com.example.quanlyphongtro.entity.HoaDon> hoaDons = hoaDonRepository.findByHopDongIdAndXoaLucIsNull(id);
        boolean hasPaidInvoice = hoaDons.stream().anyMatch(h -> 
            h.getTrangThai() == com.example.quanlyphongtro.entity.TrangThaiHoaDon.PAID || 
            h.getTrangThai() == com.example.quanlyphongtro.entity.TrangThaiHoaDon.PARTIAL || 
            h.getTrangThai() == com.example.quanlyphongtro.entity.TrangThaiHoaDon.OVERPAID
        );
        if (hasPaidInvoice) {
            throw new RuntimeException("Hợp đồng đã có hóa đơn được thanh toán (một phần hoặc toàn bộ), không thể xóa");
        }
        
        for (com.example.quanlyphongtro.entity.HoaDon hoaDon : hoaDons) {
            hoaDon.setXoaLuc(java.time.ZonedDateTime.now());
            hoaDonRepository.save(hoaDon);
        }

        UUID phongId = hd.getPhong() != null ? hd.getPhong().getId() : null;
        hd.setXoaLuc(java.time.ZonedDateTime.now());
        hopDongRepository.save(hd);
        if (phongId != null) {
            syncRoomStatus(phongId);
        }
    }

    @Transactional
    public HopDongResponse cancelContract(UUID id) {
        HopDong hd = hopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        assertCanWrite(hd, permissionService.requireCurrentUserId());
        if (hd.getLockedAt() != null || hd.getTrangThai() == TrangThaiHopDong.ACTIVE || hd.getTrangThai() == TrangThaiHopDong.TERMINATED) {
            throw new RuntimeException("Hợp đồng đã hoạt động, hãy dùng chức năng kết thúc hợp đồng");
        }
        
        List<com.example.quanlyphongtro.entity.HoaDon> hoaDons = hoaDonRepository.findByHopDongIdAndXoaLucIsNull(id);
        boolean hasPaidInvoice = hoaDons.stream().anyMatch(h -> 
            h.getTrangThai() == com.example.quanlyphongtro.entity.TrangThaiHoaDon.PAID || 
            h.getTrangThai() == com.example.quanlyphongtro.entity.TrangThaiHoaDon.PARTIAL || 
            h.getTrangThai() == com.example.quanlyphongtro.entity.TrangThaiHoaDon.OVERPAID
        );
        if (hasPaidInvoice) {
            throw new RuntimeException("Hợp đồng đã có hóa đơn được thanh toán (một phần hoặc toàn bộ), không thể hủy");
        }
        
        for (com.example.quanlyphongtro.entity.HoaDon hoaDon : hoaDons) {
            hoaDon.setTrangThai(com.example.quanlyphongtro.entity.TrangThaiHoaDon.CANCELLED);
            hoaDonRepository.save(hoaDon);
        }

        hd.setTrangThai(TrangThaiHopDong.CANCELLED);
        HopDong saved = hopDongRepository.save(hd);
        if (saved.getPhong() != null) {
            syncRoomStatus(saved.getPhong().getId());
        }
        logAudit(saved, "CANCEL");
        return toResponse(saved);
    }

    public void assertCanRead(HopDong hopDong, UUID userId) {
        if (!canReadHopDong(hopDong, userId)) {
            throw new RuntimeException("Bạn không có quyền xem hợp đồng này");
        }
    }

    // public de ContractDocumentService.boSungThongTin() dung lai khi admin bo
    // sung thong tin bat buoc ngay tren dialog ky.
    public void assertCanWrite(HopDong hopDong, UUID userId) {
        if (!canWriteHopDong(hopDong, userId)) {
            throw new RuntimeException("Bạn không có quyền sửa hợp đồng này");
        }
    }

    private boolean canReadHopDong(HopDong hopDong, UUID userId) {
        if (hopDong == null || userId == null || hopDong.getXoaLuc() != null) {
            return false;
        }
        if (permissionService.isAdmin(userId)) {
            return true;
        }
        KhachThue khachThue = hopDong.getKhachThue();
        if (khachThue != null && khachThue.getNguoiDung() != null && userId.equals(khachThue.getNguoiDung().getId())) {
            return true;
        }
        return canReadPhong(hopDong.getPhong(), userId);
    }

    private boolean canWriteHopDong(HopDong hopDong, UUID userId) {
        return hopDong != null && hopDong.getXoaLuc() == null && canWritePhong(hopDong.getPhong(), userId);
    }

    private void assertCanReadPhong(Phong phong, UUID userId) {
        if (!canReadPhong(phong, userId)) {
            throw new RuntimeException("Bạn không có quyền xem dữ liệu phòng này");
        }
    }

    private void assertCanWritePhong(Phong phong, UUID userId) {
        if (!canWritePhong(phong, userId)) {
            throw new RuntimeException("Bạn không có quyền sửa hợp đồng trong nhà trọ này");
        }
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

    private TrangThaiHopDong parseStatus(String s, TrangThaiHopDong fallback) {
        if (s == null)
            return fallback != null ? fallback : TrangThaiHopDong.DRAFT;
        return switch (s.trim()) {
            case "nhap" -> TrangThaiHopDong.DRAFT;
            case "choKichHoat" -> TrangThaiHopDong.PENDING;
            case "hoatDong" -> TrangThaiHopDong.ACTIVE;
            case "hetHan" -> TrangThaiHopDong.EXPIRED;
            case "daKetThuc" -> TrangThaiHopDong.TERMINATED;
            case "daHuy" -> TrangThaiHopDong.CANCELLED;
            default -> {
                try {
                    yield TrangThaiHopDong.valueOf(s.trim().toUpperCase(Locale.ROOT));
                } catch (Exception e) {
                    throw new RuntimeException("Trạng thái hợp đồng không hợp lệ: " + s);
                }
            }
        };
    }

    private void assertManualStatusAllowed(TrangThaiHopDong status) {
        if (status == TrangThaiHopDong.ACTIVE || status == TrangThaiHopDong.EXPIRED || status == TrangThaiHopDong.TERMINATED || status == TrangThaiHopDong.CANCELLED) {
            throw new RuntimeException("Trạng thái này phải đổi qua luồng xác nhận, kết thúc hoặc hủy hợp đồng");
        }
    }

    private UUID parseOptionalUuid(String value) {
        if (value == null || value.isBlank() || "all".equalsIgnoreCase(value)) {
            return null;
        }
        try {
            return UUID.fromString(value);
        } catch (IllegalArgumentException ex) {
            throw new RuntimeException("ID không hợp lệ");
        }
    }

    private TrangThaiCocHopDong parseCocStatus(String s) {
        if (s == null)
            return TrangThaiCocHopDong.NOT_PAID;
        try {
            return TrangThaiCocHopDong.valueOf(s.trim().toUpperCase(Locale.ROOT));
        } catch (Exception e) {
            throw new RuntimeException("Trạng thái cọc hợp đồng không hợp lệ: " + s);
        }
    }

    private String parseChuKy(String value) {
        if (value == null || value.isBlank())
            return "MONTHLY";
        return switch (value.trim()) {
            case "thang" -> "MONTHLY";
            case "quy" -> "QUARTERLY";
            case "nam" -> "YEARLY";
            case "MONTHLY", "QUARTERLY", "YEARLY" -> value.trim().toUpperCase(Locale.ROOT);
            default -> throw new RuntimeException("Chu kỳ thanh toán không hợp lệ: " + value);
        };
    }

    private UUID coalesce(UUID first, UUID second) {
        return first != null ? first : second;
    }

    private UUID resolveRepresentativeId(HopDongRequest req) {
        if (req.getNguoiDaiDien() != null)
            return req.getNguoiDaiDien();
        if (req.getKhachThueId() != null)
            return req.getKhachThueId();
        if (req.getKhachThueIds() != null && !req.getKhachThueIds().isEmpty())
            return req.getKhachThueIds().get(0);
        return null;
    }

    @Transactional
    private void replaceThanhVien(HopDong hopDong, HopDongRequest req) {
        if (hopDong == null || hopDong.getId() == null)
            return;

        UUID representativeId = hopDong.getKhachThue() != null ? hopDong.getKhachThue().getId()
                : resolveRepresentativeId(req);
        Set<UUID> memberIds = new LinkedHashSet<>();
        if (representativeId != null)
            memberIds.add(representativeId);
        if (req.getKhachThueIds() != null)
            memberIds.addAll(req.getKhachThueIds());
        thanhVienHopDongRepository.deleteByHopDongId(hopDong.getId());
        thanhVienHopDongRepository.flush();
        LocalDate defaultNgayVao = hopDong.getNgayBatDau() != null ? hopDong.getNgayBatDau() : LocalDate.now();

        for (UUID memberId : memberIds) {
            KhachThue kt = khachThueRepository.findById(memberId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy thành viên hợp đồng"));
            thanhVienHopDongRepository.save(com.example.quanlyphongtro.entity.ThanhVienHopDong.builder()
                    .hopDong(hopDong)
                    .khachThue(kt)
                    .hoTen(kt.getHoTen())
                    .soCccd(kt.getSoCccd())
                    .soDienThoai(kt.getSoDienThoai())
                    .ngayVao(defaultNgayVao)
                    .dangO(true)
                    .laNguoiDaiDien(memberId.equals(representativeId))
                    .build());
        }

        if (req.getThanhVien() != null) {
            for (HopDongRequest.ThanhVienRequest member : req.getThanhVien()) {
                if (member == null || member.getKhachThueId() != null) continue;
                if (member.getHoTen() == null || member.getHoTen().isBlank()) continue;
                thanhVienHopDongRepository.save(com.example.quanlyphongtro.entity.ThanhVienHopDong.builder()
                        .hopDong(hopDong)
                        .khachThue(null)
                        .hoTen(member.getHoTen().trim())
                        .soCccd(member.getSoCccd())
                        .soDienThoai(member.getSoDienThoai())
                        .ngayVao(member.getNgayVao() != null ? member.getNgayVao() : defaultNgayVao)
                        .ngayRoi(member.getNgayRoi())
                        .dangO(member.getDangO() != null ? member.getDangO() : true)
                        .laNguoiDaiDien(false)
                        .ghiChu(member.getGhiChu())
                        .build());
            }
        }
    }

    @Transactional
    private void replaceDichVuHopDong(HopDong hopDong, HopDongRequest req) {
        if (hopDong == null || hopDong.getId() == null)
            return;
        dichVuHopDongRepository.deleteByHopDongId(hopDong.getId());
        dichVuHopDongRepository.flush();
        LocalDate defaultStart = hopDong.getNgayBatDau() != null ? hopDong.getNgayBatDau() : LocalDate.now();
        List<HopDongRequest.PhiDichVuItem> phiDichVu = mergeMandatoryServices(hopDong, req.getPhiDichVu());
        Set<UUID> savedDichVuIds = new LinkedHashSet<>();

        for (HopDongRequest.PhiDichVuItem item : phiDichVu) {
            DichVu dichVu = resolveDichVu(hopDong, item);
            if (dichVu == null)
                continue;
            if (!savedDichVuIds.add(dichVu.getId()))
                continue;
            LoaiTinhPhi loaiTinhPhi = parseLoaiTinhPhi(item.getLoaiTinhPhi(), dichVu.getLoaiTinhPhi());
            BigDecimal donGia = item.getGia() != null ? item.getGia() : defaultMoney(dichVu.getDonGiaMacDinh());
            BigDecimal soLuong = item.getSoLuong() != null ? item.getSoLuong() : BigDecimal.ONE;
            validateServiceCharge(dichVu.getTenDichVu(), donGia, soLuong);

            dichVuHopDongRepository.save(DichVuHopDong.builder()
                    .hopDong(hopDong)
                    .dichVu(dichVu)
                    .loaiTinhPhi(loaiTinhPhi)
                    .donGiaApDung(donGia)
                    .soLuong(soLuong)
                    .batDauTu(item.getBatDauTu() != null ? item.getBatDauTu() : defaultStart)
                    .ketThucLuc(item.getKetThucLuc())
                    .build());
        }
    }

    private DichVu resolveDichVu(HopDong hopDong, HopDongRequest.PhiDichVuItem item) {
        if (item == null)
            return null;
        if (item.getDichVuId() != null) {
            return dichVuRepository.findById(item.getDichVuId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy dịch vụ hợp đồng"));
        }
        if (item.getTen() == null || item.getTen().isBlank() || hopDong.getPhong() == null
                || hopDong.getPhong().getNhaTro() == null) {
            return null;
        }
        NguoiDung chuTro = hopDong.getPhong().getNhaTro().getChuTro();
        if (chuTro == null)
            return null;
        return dichVuRepository.findByChuTroIdAndTenDichVuIgnoreCase(chuTro.getId(), item.getTen())
                .orElseGet(() -> dichVuRepository.save(DichVu.builder()
                        .chuTro(chuTro)
                        .tenDichVu(item.getTen())
                        .loaiTinhPhi(parseLoaiTinhPhi(item.getLoaiTinhPhi(), LoaiTinhPhi.FIXED))
                        .donGiaMacDinh(item.getGia() != null ? item.getGia() : BigDecimal.ZERO)
                        .batBuoc(false)
                        .build()));
    }

    public HopDongResponse toResponse(HopDong hopDong) {
        List<com.example.quanlyphongtro.entity.ThanhVienHopDong> members = thanhVienHopDongRepository
                .findByHopDongIdOrderByLaNguoiDaiDienDescTaoLucAsc(hopDong.getId());
        List<com.example.quanlyphongtro.entity.DichVuHopDong> services = dichVuHopDongRepository
                .findByHopDongIdOrderByTaoLucAsc(hopDong.getId());
        return toResponse(hopDong, members, services);
    }

    public HopDongResponse toResponse(HopDong hopDong, List<com.example.quanlyphongtro.entity.ThanhVienHopDong> members, List<com.example.quanlyphongtro.entity.DichVuHopDong> services) {
        HopDongResponse response = HopDongResponse.fromEntity(hopDong);

        if (hopDong.getId() != null) {
            List<HoaDon> invoices = hoaDonRepository.findByHopDongIdAndXoaLucIsNull(hopDong.getId());
            int overdueCount = 0;
            BigDecimal totalDebt = BigDecimal.ZERO;
            LocalDate today = LocalDate.now();
            for (HoaDon inv : invoices) {
                if (inv.getTrangThai() == TrangThaiHoaDon.CANCELLED) continue;
                BigDecimal unpaid = (inv.getTongTien() != null ? inv.getTongTien() : BigDecimal.ZERO)
                        .subtract(inv.getDaTra() != null ? inv.getDaTra() : BigDecimal.ZERO);
                if (unpaid.compareTo(BigDecimal.ZERO) > 0) {
                    totalDebt = totalDebt.add(unpaid);
                    if (inv.getTrangThai() == TrangThaiHoaDon.OVERDUE || (inv.getHanTra() != null && inv.getHanTra().isBefore(today))) {
                        overdueCount++;
                    }
                }
            }
            response.setSoHoaDonQuaHan(overdueCount);
            response.setTongTienNo(totalDebt);
        }

        List<HopDongResponse.PhiDichVuResponse> phiDichVu = services.stream()
                .map(item -> HopDongResponse.PhiDichVuResponse.builder()
                        .id(item.getId())
                        .dichVuId(item.getDichVu() != null ? item.getDichVu().getId() : null)
                        .ten(item.getDichVu() != null ? item.getDichVu().getTenDichVu() : "")
                        .gia(item.getDonGiaApDung())
                        .soLuong(item.getSoLuong())
                        .loaiTinhPhi(item.getLoaiTinhPhi() != null ? item.getLoaiTinhPhi().name() : null)
                        .donVi(item.getDichVu() != null ? item.getDichVu().getDonVi() : null)
                        .batDauTu(item.getBatDauTu())
                        .ketThucLuc(item.getKetThucLuc())
                        .build())
                .toList();

        if (members.isEmpty() && hopDong.getKhachThue() != null) {
            response.setKhachThueId(List.of(KhachThueResponse.fromEntity(hopDong.getKhachThue())));
            response.setNguoiDaiDien(KhachThueResponse.fromEntity(hopDong.getKhachThue()));
            response.setKhachThueDaiDienId(hopDong.getKhachThue().getId());
            response.setThanhVien(List.of());
            response.setPhiDichVu(phiDichVu);
            applyMeterPrices(response, hopDong, phiDichVu);
            return response;
        }

        List<KhachThueResponse> tenants = new java.util.ArrayList<>();
        List<HopDongResponse.ThanhVienHopDongResponse> memberResponses = new java.util.ArrayList<>();
        KhachThueResponse representative = null;
        UUID representativeId = null;

        for (com.example.quanlyphongtro.entity.ThanhVienHopDong member : members) {
            if (member.getKhachThue() != null) {
                KhachThueResponse tenant = KhachThueResponse.fromEntity(member.getKhachThue());
                tenants.add(tenant);
                if (Boolean.TRUE.equals(member.getLaNguoiDaiDien())) {
                    representative = tenant;
                    representativeId = member.getKhachThue().getId();
                }
            }
            memberResponses.add(HopDongResponse.ThanhVienHopDongResponse.builder()
                    .id(member.getId())
                    .hopDongId(hopDong.getId())
                    .khachThueId(member.getKhachThue() != null ? member.getKhachThue().getId() : null)
                    .hoTen(member.getHoTen())
                    .soCccd(member.getSoCccd())
                    .soDienThoai(member.getSoDienThoai())
                    .ngayVao(member.getNgayVao())
                    .ngayRoi(member.getNgayRoi())
                    .dangO(member.getDangO())
                    .laNguoiDaiDien(member.getLaNguoiDaiDien())
                    .ghiChu(member.getGhiChu())
                    .build());
        }

        if (representative == null && hopDong.getKhachThue() != null) {
            representative = KhachThueResponse.fromEntity(hopDong.getKhachThue());
            representativeId = hopDong.getKhachThue().getId();
        }

        response.setKhachThueId(tenants);
        response.setNguoiDaiDien(representative);
        response.setKhachThueDaiDienId(representativeId);
        response.setThanhVien(memberResponses);
        response.setPhiDichVu(phiDichVu);
        applyMeterPrices(response, hopDong, phiDichVu);
        return response;
    }



    private List<HopDongRequest.PhiDichVuItem> mergeMandatoryServices(HopDong hopDong, List<HopDongRequest.PhiDichVuItem> requestItems) {
        List<HopDongRequest.PhiDichVuItem> merged = new ArrayList<>();
        Set<UUID> includedIds = new LinkedHashSet<>();
        if (requestItems != null) {
            for (HopDongRequest.PhiDichVuItem item : requestItems) {
                if (item == null) continue;
                merged.add(item);
                if (item.getDichVuId() != null) includedIds.add(item.getDichVuId());
            }
        }
        if (hopDong.getPhong() == null || hopDong.getPhong().getNhaTro() == null) {
            return merged;
        }
        for (HopDongDichVuOptionResponse option : getDichVuTheoPhong(hopDong.getPhong().getId())) {
            if (!Boolean.TRUE.equals(option.getBatBuoc()) || option.getDichVuId() == null || includedIds.contains(option.getDichVuId())) {
                continue;
            }
            HopDongRequest.PhiDichVuItem item = new HopDongRequest.PhiDichVuItem();
            item.setDichVuId(option.getDichVuId());
            item.setTen(option.getTen());
            item.setGia(defaultMoney(option.getDonGiaMacDinh()));
            item.setSoLuong(BigDecimal.ONE);
            item.setLoaiTinhPhi(option.getLoaiTinhPhi());
            merged.add(item);
            includedIds.add(option.getDichVuId());
        }
        return merged;
    }

    private void applyMeterPrices(HopDongResponse response, HopDong hopDong, List<HopDongResponse.PhiDichVuResponse> phiDichVu) {
        response.setGiaDien(resolveMeterPrice(hopDong, phiDichVu, LoaiMucHoaDon.ELECTRICITY));
        response.setGiaNuoc(resolveMeterPrice(hopDong, phiDichVu, LoaiMucHoaDon.WATER));
    }

    private BigDecimal resolveMeterPrice(HopDong hopDong, List<HopDongResponse.PhiDichVuResponse> phiDichVu, LoaiMucHoaDon loai) {
        if (hopDong.getPhong() != null && hopDong.getPhong().getNhaTro() != null) {
            LocalDate ngayApDung = hopDong.getNgayBatDau() != null ? hopDong.getNgayBatDau() : LocalDate.now();
            List<CauHinhGia> configs = cauHinhGiaRepository.findApplicable(hopDong.getPhong().getNhaTro().getId(), loai, ngayApDung);
            if (!configs.isEmpty()) {
                return defaultMoney(configs.get(0).getDonGia());
            }
        }
        String keyword = loai == LoaiMucHoaDon.ELECTRICITY ? "dien" : "nuoc";
        String english = loai == LoaiMucHoaDon.ELECTRICITY ? "electricity" : "water";
        return phiDichVu.stream()
                .filter(item -> containsNormalized(item.getTen(), keyword) || containsNormalized(item.getTen(), english))
                .map(HopDongResponse.PhiDichVuResponse::getGia)
                .filter(value -> value != null && value.compareTo(BigDecimal.ZERO) >= 0)
                .findFirst()
                .orElse(BigDecimal.ZERO);
    }

    private boolean containsNormalized(String value, String keyword) {
        if (value == null || keyword == null) return false;
        String normalized = Normalizer.normalize(value, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .replace('\u0111', 'd')
                .replace('\u0110', 'D')
                .toLowerCase(Locale.ROOT);
        return normalized.contains(keyword.toLowerCase(Locale.ROOT));
    }

    private LoaiTinhPhi parseLoaiTinhPhi(String value, LoaiTinhPhi fallback) {
        if (value == null || value.isBlank())
            return fallback != null ? fallback : LoaiTinhPhi.FIXED;
        try {
            return LoaiTinhPhi.valueOf(value.toUpperCase());
        } catch (Exception e) {
            return fallback != null ? fallback : LoaiTinhPhi.FIXED;
        }
    }

    private BigDecimal defaultMoney(BigDecimal value) {
        return value != null ? value : BigDecimal.ZERO;
    }

    private BigDecimal firstMoney(BigDecimal first, BigDecimal second, BigDecimal fallback) {
        if (first != null) return first;
        if (second != null) return second;
        return fallback != null ? fallback : BigDecimal.ZERO;
    }

    private void validateContractPayload(LocalDate ngayBatDau, LocalDate ngayKetThuc, BigDecimal giaThue,
            BigDecimal tienCoc, Integer ngayThanhToan) {
        if (ngayBatDau == null || ngayKetThuc == null) {
            throw new RuntimeException("Vui lòng nhập ngày bắt đầu và ngày kết thúc hợp đồng");
        }
        if (!ngayKetThuc.isAfter(ngayBatDau)) {
            throw new RuntimeException("Ngày kết thúc hợp đồng phải sau ngày bắt đầu");
        }
        if (giaThue == null || giaThue.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("Giá thuê hợp đồng không hợp lệ");
        }
        if (tienCoc == null || tienCoc.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("Tiền cọc hợp đồng không hợp lệ");
        }
        if (ngayThanhToan == null || ngayThanhToan < 1 || ngayThanhToan > 31) {
            throw new RuntimeException("Ngày thanh toán hằng tháng phải từ 1 đến 31");
        }
    }


    private void validateInitialReadings(Integer chiSoDien, Integer chiSoNuoc) {
        if (chiSoDien != null && chiSoDien < 0) {
            throw new RuntimeException("Chỉ số điện ban đầu không được âm");
        }
        if (chiSoNuoc != null && chiSoNuoc < 0) {
            throw new RuntimeException("Chỉ số nước ban đầu không được âm");
        }
    }

    private void validateRoomCanContract(Phong phong, TrangThaiHopDong trangThai) {
        if (phong != null && phong.getTrangThai() == TrangThaiPhong.RENTED) {
            throw new RuntimeException("Phòng đang được thuê, không thể tạo hợp đồng mới");
        }
        if (phong == null || phong.getXoaLuc() != null) {
            throw new RuntimeException("Phòng không tồn tại hoặc đã bị xóa");
        }
        if (isOccupyingStatus(trangThai)
                && (phong.getTrangThai() == TrangThaiPhong.MAINTENANCE || phong.getTrangThai() == TrangThaiPhong.INACTIVE)) {
            throw new RuntimeException("Phòng đang bảo trì hoặc ngừng hoạt động, không thể tạo hợp đồng cho thuê");
        }
    }

    private void validateTenantBelongsToRoomOwner(KhachThue khachThue, Phong phong) {
        if (khachThue == null || khachThue.getXoaLuc() != null || Boolean.FALSE.equals(khachThue.getDangHoatDong())) {
            throw new RuntimeException("Khách thuê không tồn tại hoặc đã ngừng hoạt động");
        }
        // UUID roomOwnerId = phong != null && phong.getNhaTro() != null && phong.getNhaTro().getChuTro() != null
        //         ? phong.getNhaTro().getChuTro().getId() : null;
        // UUID tenantOwnerId = khachThue.getChuTro() != null ? khachThue.getChuTro().getId() : null;
        // if (roomOwnerId != null && tenantOwnerId != null && !roomOwnerId.equals(tenantOwnerId)) {
        //     throw new RuntimeException("Khách thuê không thuộc cùng chủ trọ với phòng");
        // }
    }

    private void validateMemberPayload(HopDongRequest req, Phong phong, KhachThue representative,
            LocalDate ngayBatDau, LocalDate ngayKetThuc) {
        Set<UUID> memberIds = resolveMemberIds(req, representative != null ? representative.getId() : null);
        for (UUID memberId : memberIds) {
            KhachThue member = khachThueRepository.findById(memberId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy thành viên hợp đồng"));
            validateTenantBelongsToRoomOwner(member, phong);
        }

        int externalActiveMembers = 0;
        if (req.getThanhVien() != null) {
            for (HopDongRequest.ThanhVienRequest member : req.getThanhVien()) {
                if (member == null || member.getKhachThueId() != null) continue;
                LocalDate ngayVao = member.getNgayVao() != null ? member.getNgayVao() : ngayBatDau;
                LocalDate ngayRoi = member.getNgayRoi();
                if (ngayVao == null) {
                    throw new RuntimeException("Ngày vào của thành viên không hợp lệ");
                }
                if (ngayRoi != null && ngayRoi.isBefore(ngayVao)) {
                    throw new RuntimeException("Ngày rời của thành viên phải sau ngày vào");
                }
                if (ngayBatDau != null && ngayVao.isBefore(ngayBatDau)) {
                    throw new RuntimeException("Ngày vào của thành viên không được trước ngày bắt đầu hợp đồng");
                }
                if (ngayKetThuc != null && ngayRoi != null && ngayRoi.isAfter(ngayKetThuc)) {
                    throw new RuntimeException("Ngày rời của thành viên không được sau ngày kết thúc hợp đồng");
                }
                if (Boolean.TRUE.equals(member.getDangO()) || member.getDangO() == null) {
                    externalActiveMembers++;
                }
            }
        }

        int totalActiveMembers = memberIds.size() + externalActiveMembers;
        if (phong != null && phong.getSoNguoiToiDa() != null && totalActiveMembers > phong.getSoNguoiToiDa()) {
            throw new RuntimeException("Số người trong hợp đồng vượt quá sức chứa tối đa của phòng");
        }
    }

    private Set<UUID> resolveMemberIds(HopDongRequest req, UUID representativeId) {
        Set<UUID> memberIds = new LinkedHashSet<>();
        if (representativeId != null) memberIds.add(representativeId);
        if (req.getKhachThueIds() != null) memberIds.addAll(req.getKhachThueIds());
        if (req.getKhachThueId() != null) memberIds.add(req.getKhachThueId());
        if (req.getNguoiDaiDien() != null) memberIds.add(req.getNguoiDaiDien());
        return memberIds;
    }

    private void validateServiceCharge(String tenDichVu, BigDecimal donGia, BigDecimal soLuong) {
        if (donGia == null || donGia.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("Đơn giá dịch vụ không hợp lệ: " + tenDichVu);
        }
        if (soLuong == null || soLuong.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("Số lượng dịch vụ không hợp lệ: " + tenDichVu);
        }
    }

    private String resolveContractCode(String raw, Phong phong, LocalDate ngayBatDau) {
        String normalized = raw != null ? raw.trim() : "";
        if (!normalized.isBlank()) {
            return normalized;
        }
        String roomPart = phong != null && phong.getTen() != null ? phong.getTen().trim() : "PHONG";
        roomPart = Normalizer.normalize(roomPart, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .replace('\u0111', 'd')
                .replace('\u0110', 'D')
                .replaceAll("[^A-Za-z0-9]+", "-")
                .replaceAll("(^-|-$)", "")
                .toUpperCase(Locale.ROOT);
        if (roomPart.isBlank()) roomPart = "PHONG";
        LocalDate date = ngayBatDau != null ? ngayBatDau : LocalDate.now();
        return "HD-" + roomPart + "-" + date.getYear() + String.format("%02d", date.getMonthValue()) + "-"
                + UUID.randomUUID().toString().substring(0, 6).toUpperCase(Locale.ROOT);
    }

    private void ensureContractCodeAvailable(String maHopDong, UUID excludeId) {
        if (maHopDong == null || maHopDong.isBlank()) {
            throw new RuntimeException("Mã hợp đồng không hợp lệ");
        }
        boolean exists = excludeId == null
                ? hopDongRepository.existsByMaHopDong(maHopDong)
                : hopDongRepository.existsByMaHopDongAndIdNot(maHopDong, excludeId);
        if (exists) {
            throw new RuntimeException("Mã hợp đồng đã tồn tại");
        }
    }

    private void ensureNoOverlappingOccupancy(UUID phongId, LocalDate ngayBatDau, LocalDate ngayKetThuc, UUID excludeId,
            TrangThaiHopDong trangThai) {
        if (!isOccupyingStatus(trangThai)) return;
        List<HopDong> conflicts = hopDongRepository.findOverlappingRoomContracts(
                phongId, OCCUPYING_STATUSES, ngayBatDau, ngayKetThuc, excludeId);
        if (!conflicts.isEmpty()) {
            throw new RuntimeException("Phòng này đã có hợp đồng chờ kích hoạt hoặc đang hoạt động trong khoảng thời gian này");
        }
    }

    private boolean isOccupyingStatus(TrangThaiHopDong trangThai) {
        return trangThai == TrangThaiHopDong.PENDING || trangThai == TrangThaiHopDong.ACTIVE;
    }

    private void syncRoomStatus(UUID phongId) {
        if (phongId == null) return;
        Phong phong = phongRepository.findById(phongId).orElse(null);
        if (phong == null || phong.getXoaLuc() != null) return;
        if (phong.getTrangThai() == TrangThaiPhong.MAINTENANCE || phong.getTrangThai() == TrangThaiPhong.INACTIVE) {
            return;
        }

        List<HopDong> occupying = hopDongRepository.findRoomOccupyingContracts(phongId, OCCUPYING_STATUSES).stream()
                .sorted(Comparator.comparing((HopDong hd) -> hd.getTrangThai() == TrangThaiHopDong.ACTIVE ? 0 : 1)
                        .thenComparing(HopDong::getNgayBatDau, Comparator.nullsLast(Comparator.reverseOrder())))
                .toList();
        if (occupying.stream().anyMatch(hd -> hd.getTrangThai() == TrangThaiHopDong.ACTIVE)) {
            phong.setTrangThai(TrangThaiPhong.RENTED);
        } else if (!occupying.isEmpty()) {
            phong.setTrangThai(TrangThaiPhong.RESERVED);
        } else if (phong.getTrangThai() == TrangThaiPhong.RENTED || phong.getTrangThai() == TrangThaiPhong.RESERVED) {
            phong.setTrangThai(TrangThaiPhong.AVAILABLE);
        }
        phongRepository.save(phong);
    }



    private void logAudit(HopDong hd, String hanhDong) {
        logAudit(hd, hanhDong, null, null);
    }

    private void logAudit(HopDong hd, String hanhDong, String duLieuCu, String duLieuMoi) {
        if (auditLogRepository == null) return;
        com.example.quanlyphongtro.entity.AuditLog log = com.example.quanlyphongtro.entity.AuditLog.builder()
            .nguoiDung(com.example.quanlyphongtro.entity.NguoiDung.builder().id(permissionService.requireCurrentUserId()).build())
            .hanhDong(hanhDong)
            .bangTacDong("hop_dong")
            .banGhiId(hd.getId())
            .duLieuCu(duLieuCu)
            .duLieuMoi(duLieuMoi)
            .taoLuc(java.time.ZonedDateTime.now())
            .build();
        auditLogRepository.save(log);
    }

    @Transactional
    public com.example.quanlyphongtro.dto.HopDongResponse terminateContract(java.util.UUID id, com.example.quanlyphongtro.dto.KetThucHopDongRequest req) {
        HopDong hd = hopDongRepository.findById(id).orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        assertCanWrite(hd, permissionService.requireCurrentUserId());
        if (hd.getTrangThai() != TrangThaiHopDong.ACTIVE) {
            throw new RuntimeException("Chỉ hợp đồng đang hoạt động mới được kết thúc");
        }
        java.time.LocalDate ngayKetThuc = req.getNgayKetThucThucTe() != null ? req.getNgayKetThucThucTe() : java.time.LocalDate.now();
        if (hd.getNgayBatDau() != null && ngayKetThuc.isBefore(hd.getNgayBatDau())) {
            throw new RuntimeException("Ngày kết thúc thực tế không được trước ngày bắt đầu");
        }
        
        // 1. Sinh hóa đơn tháng cuối nếu có truyền chỉ số
        if (req.getChiSoDienCuoiKy() != null || req.getChiSoNuocCuoiKy() != null) {
            com.example.quanlyphongtro.dto.HoaDonRequest hdReq = new com.example.quanlyphongtro.dto.HoaDonRequest();
            hdReq.setHopDong(hd.getId());
            hdReq.setKyNam(ngayKetThuc.getYear());
            hdReq.setKyThang(ngayKetThuc.getMonthValue());
            hdReq.setTuNgay(ngayKetThuc.withDayOfMonth(1));
            hdReq.setDenNgay(ngayKetThuc);
            hdReq.setHanTra(ngayKetThuc.plusDays(5));
            hdReq.setChiSoDienCuoiKy(req.getChiSoDienCuoiKy());
            hdReq.setChiSoNuocCuoiKy(req.getChiSoNuocCuoiKy());
            hdReq.setGhiChu("Hóa đơn thanh lý hợp đồng");
            
            com.example.quanlyphongtro.dto.HoaDonResponse finalInvoice = hoaDonService.create(hdReq);
            
            // 2. Cấn trừ cọc nếu có soTienKhauTru
            if (req.getSoTienKhauTru() != null && req.getSoTienKhauTru().compareTo(java.math.BigDecimal.ZERO) > 0) {
                com.example.quanlyphongtro.dto.ThanhToanRequest ttReq = new com.example.quanlyphongtro.dto.ThanhToanRequest();
                ttReq.setHoaDonId(finalInvoice.getId());
                ttReq.setSoTien(req.getSoTienKhauTru());
                ttReq.setPhuongThuc("DEPOSIT");
                ttReq.setNgayThanhToan(java.time.ZonedDateTime.now().toString());
                ttReq.setGhiChu("Khấu trừ tiền cọc vào hóa đơn cuối");
                ttReq.setIdempotencyKey("TERMINATE-" + hd.getId().toString());
                thanhToanService.create(ttReq);
            }
        }
        
        hd.setTrangThai(TrangThaiHopDong.TERMINATED);
        hd.setNgayKetThucThucTe(ngayKetThuc);
        
        String logHoanCoc = "";
        if (req.getSoTienHoanTra() != null && req.getSoTienHoanTra().compareTo(java.math.BigDecimal.ZERO) > 0) {
            hd.setTrangThaiCoc(com.example.quanlyphongtro.entity.TrangThaiCocHopDong.REFUNDED);
            logHoanCoc = " | Đã hoàn cọc: " + req.getSoTienHoanTra() + " VNĐ.";
        } else if (req.getTrangThaiCoc() != null) {
            hd.setTrangThaiCoc(parseCocStatus(req.getTrangThaiCoc()));
        } else {
            hd.setTrangThaiCoc(com.example.quanlyphongtro.entity.TrangThaiCocHopDong.REFUNDED); // Default
        }
        
        if (req.getGhiChu() != null) {
            hd.setGhiChu(req.getGhiChu() + logHoanCoc);
        } else {
            hd.setGhiChu("Thanh lý hợp đồng" + logHoanCoc);
        }
        
        hd = hopDongRepository.save(hd);
        syncRoomStatus(hd.getPhong().getId());
        logAudit(hd, "TERMINATE");
        return toResponse(hd);
    }

    @org.springframework.beans.factory.annotation.Autowired
    private com.example.quanlyphongtro.repository.PhuLucHopDongRepository phuLucHopDongRepository;

    @Transactional
    public com.example.quanlyphongtro.dto.HopDongResponse extendContract(java.util.UUID id, com.example.quanlyphongtro.dto.GiaHanHopDongRequest req) {
        HopDong hd = hopDongRepository.findById(id).orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        assertCanWrite(hd, permissionService.requireCurrentUserId());
        
        if (req.getNgayKetThucMoi() == null) {
            throw new RuntimeException("Ngày kết thúc mới không được để trống");
        }
        if (req.getNgayHieuLuc() == null) {
            throw new RuntimeException("Ngày hiệu lực không được để trống");
        }
        if (hd.getTrangThai() != TrangThaiHopDong.ACTIVE && hd.getTrangThai() != TrangThaiHopDong.EXPIRED) {
            throw new RuntimeException("Chỉ hợp đồng đang hoạt động hoặc vừa hết hạn mới được gia hạn");
        }
        if (hd.getNgayKetThuc() != null && !req.getNgayKetThucMoi().isAfter(hd.getNgayKetThuc())) {
            throw new RuntimeException("Ngày kết thúc mới phải sau ngày kết thúc hiện tại");
        }
        if (hd.getNgayBatDau() != null && !req.getNgayKetThucMoi().isAfter(hd.getNgayBatDau())) {
            throw new RuntimeException("Ngày kết thúc phải sau ngày bắt đầu");
        }
        
        ensureNoOverlappingOccupancy(hd.getPhong().getId(), hd.getNgayBatDau(), req.getNgayKetThucMoi(), id, hd.getTrangThai());

        BigDecimal giaThueCu = hd.getGiaThueHopDong();
        LocalDate ngayKetThucCu = hd.getNgayKetThuc();
        TrangThaiHopDong trangThaiCu = hd.getTrangThai();
        String noiDungRevision = (req.getNoiDung() == null || req.getNoiDung().isBlank() ? "Gia hạn hợp đồng" : req.getNoiDung().trim())
                + " | Before: end=" + ngayKetThucCu + ", rent=" + giaThueCu
                + " | After: end=" + req.getNgayKetThucMoi() + ", rent="
                + (req.getGiaThueMoi() != null ? req.getGiaThueMoi() : giaThueCu);
        com.example.quanlyphongtro.entity.PhuLucHopDong pl = com.example.quanlyphongtro.entity.PhuLucHopDong.builder()
            .hopDong(hd)
            .loai("GIA_HAN")
            .noiDung(noiDungRevision)
            .ngayHieuLuc(req.getNgayHieuLuc())
            .ngayKetThucMoi(req.getNgayKetThucMoi())
            .giaThueMoi(req.getGiaThueMoi())
            .nguoiTao(com.example.quanlyphongtro.entity.NguoiDung.builder().id(permissionService.requireCurrentUserId()).build())
            .build();
        phuLucHopDongRepository.save(pl);

        hd.setNgayKetThuc(req.getNgayKetThucMoi());
        if (req.getGiaThueMoi() != null) {
            hd.setGiaThueHopDong(req.getGiaThueMoi());
        }
        hd.setTrangThai(TrangThaiHopDong.ACTIVE);
        hd = hopDongRepository.save(hd);
        logAudit(hd, "EXTEND",
                "{\"ngayKetThuc\":\"" + ngayKetThucCu + "\",\"giaThue\":\"" + giaThueCu + "\",\"trangThai\":\"" + trangThaiCu + "\"}",
                "{\"ngayKetThuc\":\"" + hd.getNgayKetThuc() + "\",\"giaThue\":\"" + hd.getGiaThueHopDong() + "\",\"trangThai\":\"" + hd.getTrangThai() + "\",\"phuLucId\":\"" + pl.getId() + "\"}");
        
        return toResponse(hd);
    }

    @org.springframework.transaction.annotation.Transactional
    public HopDong renewContract(java.util.UUID oldContractId) {
        HopDong oldContract = hopDongRepository.findById(oldContractId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng cũ"));

        long durationDays = java.time.temporal.ChronoUnit.DAYS.between(oldContract.getNgayBatDau(), oldContract.getNgayKetThuc());
        java.time.LocalDate newStartDate = oldContract.getNgayKetThuc().plusDays(1);
        java.time.LocalDate newEndDate = newStartDate.plusDays(durationDays);

        HopDong newContract = HopDong.builder()
                .phong(oldContract.getPhong())
                .khachThue(oldContract.getKhachThue())
                .maHopDong(oldContract.getMaHopDong() + "-GH")
                .ngayBatDau(newStartDate)
                .ngayKetThuc(newEndDate)
                .giaThueHopDong(oldContract.getGiaThueHopDong())
                .tienCoc(oldContract.getTienCoc())
                .trangThaiCoc(oldContract.getTrangThaiCoc())
                .trangThai(TrangThaiHopDong.DRAFT)
                .chuKyThanhToan(oldContract.getChuKyThanhToan())
                .ngayThanhToanHangThang(oldContract.getNgayThanhToanHangThang())
                .tuDongGiaHan(oldContract.getTuDongGiaHan())
                .chiSoDienBanDau(oldContract.getChiSoDienBanDau())
                .chiSoNuocBanDau(oldContract.getChiSoNuocBanDau())
                .noiDungHopDong(oldContract.getNoiDungHopDong())
                .build();

        // Save new contract
        newContract = hopDongRepository.save(newContract);

        // Copy ThanhVienHopDong
        java.util.List<com.example.quanlyphongtro.entity.ThanhVienHopDong> oldMembers = thanhVienHopDongRepository.findByHopDongIdOrderByLaNguoiDaiDienDescTaoLucAsc(oldContractId);
        for (com.example.quanlyphongtro.entity.ThanhVienHopDong m : oldMembers) {
            if (Boolean.TRUE.equals(m.getDangO())) {
                thanhVienHopDongRepository.save(com.example.quanlyphongtro.entity.ThanhVienHopDong.builder()
                        .hopDong(newContract)
                        .khachThue(m.getKhachThue())
                        .hoTen(m.getHoTen())
                        .soCccd(m.getSoCccd())
                        .soDienThoai(m.getSoDienThoai())
                        .ngayVao(newStartDate)
                        .dangO(true)
                        .laNguoiDaiDien(m.getLaNguoiDaiDien())
                        .ghiChu("Gia hạn từ HĐ " + oldContract.getMaHopDong())
                        .build());
            }
        }

        // Copy DichVuHopDong
        java.util.List<com.example.quanlyphongtro.entity.DichVuHopDong> oldServices = dichVuHopDongRepository.findByHopDongIdOrderByTaoLucAsc(oldContractId);
        for (com.example.quanlyphongtro.entity.DichVuHopDong s : oldServices) {
            dichVuHopDongRepository.save(com.example.quanlyphongtro.entity.DichVuHopDong.builder()
                    .hopDong(newContract)
                    .dichVu(s.getDichVu())
                    .loaiTinhPhi(s.getLoaiTinhPhi())
                    .donGiaApDung(s.getDonGiaApDung())
                    .soLuong(s.getSoLuong())
                    .batDauTu(newStartDate)
                    .build());
        }

        return newContract;
    }
}

