package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.HoaDonRequest;
import com.example.quanlyphongtro.dto.HoaDonResponse;
import com.example.quanlyphongtro.dto.HoaDonQuyetToanResult;
import com.example.quanlyphongtro.dto.KhoanKhauTruCocRequest;
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
import java.math.RoundingMode;
import java.text.Normalizer;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.HashMap;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class HoaDonService {

    private final HoaDonRepository hoaDonRepository;
    private final ChiTietHoaDonRepository chiTietHoaDonRepository;
    private final PhongRepository phongRepository;
    private final HopDongRepository hopDongRepository;
    private final KhachThueRepository khachThueRepository;
    private final HopDongService hopDongService;
    private final ChiSoDienNuocRepository chiSoDienNuocRepository;
    private final CauHinhGiaRepository cauHinhGiaRepository;
    private final DichVuHopDongRepository dichVuHopDongRepository;
    private final ThanhVienHopDongRepository thanhVienHopDongRepository;
    private final PhuLucHopDongRepository phuLucHopDongRepository;
    private final PhuongTienRepository phuongTienRepository;
    private final PermissionService permissionService;
    private final EmailService emailService;
    private final org.springframework.context.ApplicationEventPublisher eventPublisher;

    @Transactional(readOnly = true)
    public PaginatedResponse<HoaDonResponse> getAll(
            String hopDongId,
            String trangThaiStr,
            String search,
            Integer kyThang,
            Integer kyNam,
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
        
        TrangThaiHoaDon tt = null;
        if (trangThaiStr != null && !trangThaiStr.isBlank() && !trangThaiStr.equals("all")) {
            try { tt = TrangThaiHoaDon.valueOf(trangThaiStr.toUpperCase()); } catch (Exception ignored) {}
        }
        
        UUID hid = parseOptionalUuid(hopDongId);
        if (kyThang != null && (kyThang < 1 || kyThang > 12)) {
            throw new RuntimeException("Tháng hóa đơn không hợp lệ");
        }
        if (kyNam != null && (kyNam < 2000 || kyNam > 2100)) {
            throw new RuntimeException("Năm hóa đơn không hợp lệ");
        }
        String normalizedSearch = search != null && !search.isBlank() ? search.trim() : null;

        Pageable pageable = PageRequest.of(Math.max(0, page - 1), limit, Sort.by(Sort.Direction.DESC, "taoLuc"));
        Page<HoaDon> pageResult = hoaDonRepository.findAllAccessible(
                isAdmin, userId, nhaTroIds, hid, tt != null ? tt.name() : null, normalizedSearch, kyThang, kyNam, pageable);
        
        List<UUID> hoaDonIds = pageResult.getContent().stream().map(HoaDon::getId).toList();
        List<ChiTietHoaDon> allChiTiet = hoaDonIds.isEmpty() ? Collections.emptyList() : chiTietHoaDonRepository.findByHoaDonIdIn(hoaDonIds);
        Map<UUID, List<ChiTietHoaDon>> chiTietMap = allChiTiet.stream()
                .collect(Collectors.groupingBy(ct -> ct.getHoaDon().getId()));
        
        List<HoaDonResponse> res = new ArrayList<>();
        for (HoaDon hd : pageResult.getContent()) {
            res.add(HoaDonResponse.fromEntity(hd, chiTietMap.getOrDefault(hd.getId(), Collections.emptyList())));
        }
        
        return PaginatedResponse.of(pageResult, res);
    }

    @Transactional(readOnly = true)
    public HoaDonResponse getById(UUID id) {
        HoaDon hd = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn"));
        if (hd.getXoaLuc() != null) {
            throw new RuntimeException("Hóa đơn đã bị xóa");
        }
        assertCanReadHoaDon(hd, permissionService.requireCurrentUserId());
        return HoaDonResponse.fromEntity(hd, chiTietHoaDonRepository.findByHoaDonId(id));
    }

    @Transactional(readOnly = true)
    public HoaDonResponse getPublicById(UUID id) {
        HoaDon hd = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay hoa don"));
        if (hd.getXoaLuc() != null) {
            throw new RuntimeException("Hóa đơn đã bị xóa");
        }
        return HoaDonResponse.fromEntity(hd, chiTietHoaDonRepository.findByHoaDonId(id));
    }

    @Transactional
    public HoaDonResponse create(HoaDonRequest req) {
        InvoiceContext ctx = resolveContext(req, null);
        assertCanWriteHopDong(ctx.hopDong(), permissionService.requireCurrentUserId());
        LoaiHoaDon loaiHoaDon = parseLoaiHoaDon(req.getLoaiHoaDon(), LoaiHoaDon.REGULAR);
        ensureInvoicePeriodAvailable(ctx.hopDong().getId(), ctx.kyNam(), ctx.kyThang(), loaiHoaDon, null);

        if (req.getDaThanhToan() != null && req.getDaThanhToan().compareTo(BigDecimal.ZERO) > 0) {
            throw new RuntimeException("Số tiền đã thanh toán chỉ được cập nhật thông qua module thanh toán.");
        }
        BigDecimal daTra = BigDecimal.ZERO;
        HoaDon hd = HoaDon.builder()
                .phong(ctx.phong())
                .hopDong(ctx.hopDong())
                .khachThue(ctx.khachThue())
                .maHoaDon(resolveInvoiceCode(req.getMaHoaDon(), ctx))
                .loaiHoaDon(loaiHoaDon)
                .kyNam(ctx.kyNam())
                .kyThang(ctx.kyThang())
                .tuNgay(ctx.tuNgay())
                .denNgay(ctx.denNgay())
                .soDuDauKy(nonNegativeMoney(req.getSoDuDauKy(), "Số dư đầu kỳ"))
                .tongTienPhatSinh(BigDecimal.ZERO)
                .tongTien(BigDecimal.ZERO)
                .daTra(daTra)
                .trangThai(parseTrangThai(req.getTrangThai(), TrangThaiHoaDon.DRAFT))
                .hanTra(ctx.hanTra())
                .ngayLapHoaDon(ZonedDateTime.now())
                .ghiChu(req.getGhiChu())
                .build();

        HoaDon saved = hoaDonRepository.save(hd);
        List<ChiTietHoaDon> items = buildLineItems(req, saved, ctx);
        persistLineItemsAndTotals(saved, items);

        logAudit(saved, "CREATE");
        if (saved.getTrangThai() == TrangThaiHoaDon.UNPAID) {
            eventPublisher.publishEvent(new com.example.quanlyphongtro.event.InvoiceCreatedEvent(this, saved));
            logAudit(saved, "SEND_EVENT");
        }

        return HoaDonResponse.fromEntity(saved, items);
    }

    @Transactional
    public HoaDonResponse update(UUID id, HoaDonRequest req) {
        HoaDon hd = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn"));
        if (hd.getXoaLuc() != null) {
            throw new RuntimeException("Hóa đơn đã bị xóa");
        }
        if (hd.getTrangThai() != TrangThaiHoaDon.DRAFT) {
            throw new RuntimeException("Chỉ được sửa hóa đơn ở trạng thái nháp");
        }
        TrangThaiHoaDon oldStatus = hd.getTrangThai();
        if (hd.getDaTra() != null && hd.getDaTra().compareTo(java.math.BigDecimal.ZERO) > 0) {
            throw new RuntimeException("Không thể sửa hóa đơn đã có giao dịch thanh toán");
        }
        UUID userId = permissionService.requireCurrentUserId();
        assertCanWriteHoaDon(hd, userId);

        InvoiceContext ctx = resolveContext(req, hd);
        assertCanWriteHopDong(ctx.hopDong(), userId);
        LoaiHoaDon loaiHoaDon = parseLoaiHoaDon(req.getLoaiHoaDon(), hd.getLoaiHoaDon());
        ensureInvoicePeriodAvailable(ctx.hopDong().getId(), ctx.kyNam(), ctx.kyThang(), loaiHoaDon, hd.getId());
        boolean billingContextChanged = changedBillingContext(hd, ctx);

        hd.setHopDong(ctx.hopDong());
        hd.setPhong(ctx.phong());
        hd.setKhachThue(ctx.khachThue());
        hd.setKyNam(ctx.kyNam());
        hd.setKyThang(ctx.kyThang());
        hd.setLoaiHoaDon(loaiHoaDon);
        hd.setTuNgay(ctx.tuNgay());

        hd.setDenNgay(ctx.denNgay());
        hd.setHanTra(ctx.hanTra());
        if (req.getMaHoaDon() != null) hd.setMaHoaDon(resolveInvoiceCode(req.getMaHoaDon(), ctx));
        if (req.getSoDuDauKy() != null) hd.setSoDuDauKy(nonNegativeMoney(req.getSoDuDauKy(), "Số dư đầu kỳ"));
        if (req.getDaThanhToan() != null) {
            throw new RuntimeException("Số tiền đã thanh toán chỉ được cập nhật qua module thanh toán");
        }
        if (req.getGhiChu() != null) hd.setGhiChu(req.getGhiChu());
        if (req.getTrangThai() != null) hd.setTrangThai(parseTrangThai(req.getTrangThai(), hd.getTrangThai()));

        List<ChiTietHoaDon> items;
        if (hasBillingPayload(req) || billingContextChanged) {
            markReadingsCancelled(id);
            chiTietHoaDonRepository.deleteByHoaDonId(id);
            items = buildLineItems(req, hd, ctx);
            persistLineItemsAndTotals(hd, items);
        } else {
            items = chiTietHoaDonRepository.findByHoaDonId(id);
            syncInvoiceTotals(hd, items);
            hoaDonRepository.save(hd);
        }

        logAudit(hd, "UPDATE");
        if (oldStatus == TrangThaiHoaDon.DRAFT && hd.getTrangThai() == TrangThaiHoaDon.UNPAID) {
            eventPublisher.publishEvent(new com.example.quanlyphongtro.event.InvoiceCreatedEvent(this, hd));
            logAudit(hd, "SEND_EVENT");
        }

        return HoaDonResponse.fromEntity(hd, items);
    }

    @Transactional
    public void delete(UUID id) {
        HoaDon hd = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn"));
        assertCanWriteHoaDon(hd, permissionService.requireCurrentUserId());
        if (hd.getTrangThai() != TrangThaiHoaDon.DRAFT) {
            throw new RuntimeException("Chỉ được hủy hóa đơn ở trạng thái nháp");
        }
        
        if (hd.getDaTra() != null && hd.getDaTra().compareTo(BigDecimal.ZERO) > 0) {
            throw new RuntimeException("Không thể xóa hóa đơn đã có giao dịch thanh toán");
        }
        
        markReadingsCancelled(id);
        hd.setTrangThai(TrangThaiHoaDon.CANCELLED);
        hd.setXoaLuc(ZonedDateTime.now());
        hoaDonRepository.save(hd);
        logAudit(hd, "CANCEL");
    }

    @Transactional(readOnly = true)
    public Map<String, Object> getFormData() {
        UUID userId = permissionService.requireCurrentUserId();
        Map<String, Object> result = new HashMap<>();
        result.put("hopDongList", hopDongRepository.findAllActive().stream()
                .filter(hopDong -> canReadHopDong(hopDong, userId))
                .map(hopDongService::toResponse).toList());
        result.put("phongList", phongRepository.findAll().stream()
                .filter(phong -> canReadPhong(phong, userId))
                .map(com.example.quanlyphongtro.dto.PhongResponse::fromEntity).toList());
        result.put("khachThueList", khachThueRepository.findByXoaLucIsNullOrderByTaoLucDesc().stream()
                .filter(khachThue -> canReadKhachThue(khachThue, userId))
                .map(com.example.quanlyphongtro.dto.KhachThueResponse::fromEntity).toList());
        return result;
    }

    @Transactional(readOnly = true)
    public Map<String, Object> getLatestReading(UUID hopDongId, int thang, int nam) {
        Map<String, Object> result = new HashMap<>();
        result.put("isFirstInvoice", true);
        result.put("chiSoDienBanDau", 0);
        result.put("chiSoDienCuoiKy", 0);
        result.put("chiSoNuocBanDau", 0);
        result.put("chiSoNuocCuoiKy", 0);
        result.put("coChiSoDienKyNay", false);
        result.put("coChiSoNuocKyNay", false);
        result.put("donGiaDien", BigDecimal.ZERO);
        result.put("donGiaNuoc", BigDecimal.ZERO);

        HopDong hd = hopDongRepository.findById(hopDongId).orElse(null);
        if (hd != null && hd.getPhong() != null) {
            assertCanReadHopDong(hd, permissionService.requireCurrentUserId());
            Optional<ChiSoDienNuoc> electricThisPeriod = readingForPeriod(hd, LoaiChiSo.ELECTRICITY, thang, nam);
            Optional<ChiSoDienNuoc> waterThisPeriod = readingForPeriod(hd, LoaiChiSo.WATER, thang, nam);
            Optional<Integer> latestElectric = latestReadingBeforePeriod(hd.getPhong().getId(), LoaiChiSo.ELECTRICITY, thang, nam);
            Optional<Integer> latestWater = latestReadingBeforePeriod(hd.getPhong().getId(), LoaiChiSo.WATER, thang, nam);

            int dienBanDau = electricThisPeriod.map(ChiSoDienNuoc::getChiSoCu)
                    .orElse(latestElectric.orElse(defaultMeterReading(hd.getChiSoDienBanDau())));
            int nuocBanDau = waterThisPeriod.map(ChiSoDienNuoc::getChiSoCu)
                    .orElse(latestWater.orElse(defaultMeterReading(hd.getChiSoNuocBanDau())));

            result.put("chiSoDienBanDau", dienBanDau);
            result.put("chiSoDienCuoiKy", electricThisPeriod.map(ChiSoDienNuoc::getChiSoMoi).orElse(dienBanDau));
            result.put("chiSoNuocBanDau", nuocBanDau);
            result.put("chiSoNuocCuoiKy", waterThisPeriod.map(ChiSoDienNuoc::getChiSoMoi).orElse(nuocBanDau));
            result.put("coChiSoDienKyNay", electricThisPeriod.isPresent());
            result.put("coChiSoNuocKyNay", waterThisPeriod.isPresent());
            InvoiceContext context = new InvoiceContext(hd, hd.getPhong(), hd.getKhachThue(), nam, thang,
                    LocalDate.of(nam, thang, 1), LocalDate.of(nam, thang, 1).plusMonths(1).minusDays(1),
                    billingDueDate(nam, thang));
            result.put("donGiaDien", resolveMeterUnitPrice(context, LoaiMucHoaDon.ELECTRICITY));
            result.put("donGiaNuoc", resolveMeterUnitPrice(context, LoaiMucHoaDon.WATER));
            if (latestElectric.isPresent() || latestWater.isPresent()) {
                result.put("isFirstInvoice", false);
            }
        }

        List<HoaDon> latest = hoaDonRepository.findLatestByHopDong(hopDongId);
        if (!latest.isEmpty()) {
            result.put("isFirstInvoice", false);
            HoaDon last = latest.get(0);
            result.put("lastInvoiceMonth", last.getKyThang() + "/" + last.getKyNam());
        }

        // Calculate total unpaid debt
        BigDecimal totalDebt = BigDecimal.ZERO;
        List<HoaDon> invoices = hoaDonRepository.findByHopDongIdAndXoaLucIsNull(hopDongId);
        for (HoaDon invoice : invoices) {
            BigDecimal unpaid = invoice.getTongTien().subtract(invoice.getDaTra());
            if (unpaid.compareTo(BigDecimal.ZERO) > 0) {
                totalDebt = totalDebt.add(unpaid);
            }
        }
        result.put("soDuDauKy", totalDebt);
        return result;
    }

    private InvoiceContext resolveContext(HoaDonRequest req, HoaDon existing) {
        UUID hopDongId = coalesce(req.getHopDongId(), req.getHopDong());
        HopDong hopDong = hopDongId != null
                ? hopDongRepository.findById(hopDongId).orElseThrow(() -> new RuntimeException("KhÃ´ng tÃ¬m tháº¥y há»£p Ä‘á»“ng"))
                : existing != null ? existing.getHopDong() : null;
        if (hopDong == null || hopDong.getXoaLuc() != null) {
            throw new RuntimeException("Hóa đơn bắt buộc chọn hợp đồng hợp lệ");
        }
        if (hopDong.getTrangThai() == TrangThaiHopDong.DRAFT || hopDong.getTrangThai() == TrangThaiHopDong.CANCELLED) {
            throw new RuntimeException("Hợp đồng nháp hoặc đã hủy không được lập hóa đơn");
        }

        Phong phong = hopDong.getPhong();
        KhachThue khachThue = hopDong.getKhachThue();
        if (phong == null || khachThue == null) {
            throw new RuntimeException("Hợp đồng thiếu phòng hoặc khách thuê, không thể lập hóa đơn");
        }
        validateRequestedRef(req.getPhongId(), req.getPhong(), phong != null ? phong.getId() : null, "phong");
        validateRequestedRef(req.getKhachThueId(), req.getKhachThue(), khachThue != null ? khachThue.getId() : null, "khach thue");

        int kyNam = req.getKyNam() != null ? req.getKyNam()
                : req.getNam() != null ? req.getNam()
                : existing != null ? existing.getKyNam()
                : LocalDate.now().getYear();
        int kyThang = req.getKyThang() != null ? req.getKyThang()
                : req.getThang() != null ? req.getThang()
                : existing != null ? existing.getKyThang()
                : LocalDate.now().getMonthValue();
        validateInvoiceMonth(kyNam, kyThang);

        LocalDate tuNgay = req.getTuNgay() != null ? req.getTuNgay()
                : existing != null ? existing.getTuNgay()
                : LocalDate.of(kyNam, kyThang, 1);
        LocalDate denNgay = req.getDenNgay() != null ? req.getDenNgay()
                : existing != null ? existing.getDenNgay()
                : tuNgay.plusMonths(1).minusDays(1);
        LocalDate hanTra = existing != null ? existing.getHanTra() : billingDueDate(kyNam, kyThang);

        validateInvoiceDates(tuNgay, denNgay, hanTra, hopDong);
        return new InvoiceContext(hopDong, phong, khachThue, kyNam, kyThang, tuNgay, denNgay, hanTra);
    }

    private void assertCanReadHoaDon(HoaDon hoaDon, UUID userId) {
        if (!canReadHoaDon(hoaDon, userId)) {
            throw new RuntimeException("Bạn không có quyền xem hóa đơn này");
        }
    }

    private void assertCanWriteHoaDon(HoaDon hoaDon, UUID userId) {
        if (!canWriteHoaDon(hoaDon, userId)) {
            throw new RuntimeException("Bạn không có quyền sửa hóa đơn này");
        }
    }

    private boolean canReadHoaDon(HoaDon hoaDon, UUID userId) {
        if (hoaDon == null || userId == null || hoaDon.getXoaLuc() != null) {
            return false;
        }
        if (permissionService.isAdmin(userId)) {
            return true;
        }
        KhachThue khachThue = hoaDon.getKhachThue();
        if (khachThue != null && khachThue.getNguoiDung() != null && userId.equals(khachThue.getNguoiDung().getId())) {
            return true;
        }
        return canReadPhong(hoaDon.getPhong(), userId);
    }

    private boolean canWriteHoaDon(HoaDon hoaDon, UUID userId) {
        return hoaDon != null && hoaDon.getXoaLuc() == null && canWritePhong(hoaDon.getPhong(), userId);
    }

    private void assertCanReadHopDong(HopDong hopDong, UUID userId) {
        if (!canReadHopDong(hopDong, userId)) {
            throw new RuntimeException("Bạn không có quyền xem hợp đồng này");
        }
    }

    private void assertCanWriteHopDong(HopDong hopDong, UUID userId) {
        if (!canWriteHopDong(hopDong, userId)) {
            throw new RuntimeException("Bạn không có quyền lập hóa đơn cho hợp đồng này");
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

    private boolean canReadKhachThue(KhachThue khachThue, UUID userId) {
        if (khachThue == null || userId == null || khachThue.getXoaLuc() != null) {
            return false;
        }
        if (permissionService.isAdmin(userId)) {
            return true;
        }
        if (khachThue.getNguoiDung() != null && userId.equals(khachThue.getNguoiDung().getId())) {
            return true;
        }
        UUID ownerId = khachThue.getChuTro() != null ? khachThue.getChuTro().getId() : null;
        return ownerId != null && ownerId.equals(userId);
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

    private List<ChiTietHoaDon> buildLineItems(HoaDonRequest req, HoaDon hoaDon, InvoiceContext ctx) {
        if (req.getChiTietHoaDon() != null) {
            List<ChiTietHoaDon> manualItems = buildManualLineItems(req, hoaDon);
            if (manualItems.stream().anyMatch(item -> item.getLoai() == LoaiMucHoaDon.PARKING)) {
                throw new RuntimeException("Phí gửi xe được hệ thống tự tính theo số xe của từng người thuê");
            }
            manualItems.addAll(buildParkingFeeLines(hoaDon, ctx));
            if (manualItems.isEmpty()) {
                throw new RuntimeException("Hóa đơn phải có ít nhất một dòng chi tiết");
            }
            return manualItems;
        }

        List<ChiTietHoaDon> items = new ArrayList<>();
        addLine(items, hoaDon, null, null, LoaiMucHoaDon.ROOM, roomChargeDescription(ctx), BigDecimal.ONE,
                resolveRoomPrice(ctx));

        addMeterLine(items, hoaDon, ctx, LoaiChiSo.ELECTRICITY, LoaiMucHoaDon.ELECTRICITY,
                req.getChiSoDienBanDau(), req.getChiSoDienCuoiKy(),
                Boolean.TRUE.equals(req.getResetCongTo()) ? req.getSoKwhThucTe() : null, "Tiền điện");
        addMeterLine(items, hoaDon, ctx, LoaiChiSo.WATER, LoaiMucHoaDon.WATER,
                req.getChiSoNuocBanDau(), req.getChiSoNuocCuoiKy(),
                Boolean.TRUE.equals(req.getResetCongTo()) ? req.getSoKhoiNuocThucTe() : null, "Tiền nước");

        List<ChiTietHoaDon> contractServiceLines = buildContractServiceLines(hoaDon, ctx);
        if (!contractServiceLines.isEmpty()) {
            items.addAll(contractServiceLines);
        } else if (req.getPhiDichVu() != null) {
            for (HoaDonRequest.PhiDichVuItem phi : req.getPhiDichVu()) {
                if (phi == null || isMeterServiceName(phi.getTen())) continue;
                BigDecimal soLuong = phi.getSoLuong() != null ? phi.getSoLuong() : BigDecimal.ONE;
                addLine(items, hoaDon, phi.getDichVuId(), null, LoaiMucHoaDon.SERVICE, phi.getTen(), soLuong, phi.getGia());
            }
        }
        
        List<ChiTietHoaDon> parkingFeeLines = buildParkingFeeLines(hoaDon, ctx);
        items.addAll(parkingFeeLines);

        if (items.isEmpty()) {
            throw new RuntimeException("Hóa đơn phải có ít nhất một dòng chi tiết");
        }
        return items;
    }
    
    private List<ChiTietHoaDon> buildParkingFeeLines(HoaDon hoaDon, InvoiceContext ctx) {
        List<ChiTietHoaDon> lines = new ArrayList<>();
        if (ctx.phong() == null || ctx.hopDong() == null || ctx.phong().getNhaTro() == null) return lines;
        
        List<PhuongTien> activeVehicles = phuongTienRepository.findByPhongIdAndTrangThai(ctx.phong().getId(), TrangThaiPhuongTien.HIEU_LUC);
        if (activeVehicles.isEmpty()) return lines;
        
        // Group by tenant
        Map<UUID, List<PhuongTien>> vehiclesByTenant = new HashMap<>();
        for (PhuongTien pt : activeVehicles) {
            if (pt.getKhachThue() != null) {
                vehiclesByTenant.computeIfAbsent(pt.getKhachThue().getId(), k -> new ArrayList<>()).add(pt);
            } else {
                // If no tenant specified, assume it belongs to the primary tenant
                vehiclesByTenant.computeIfAbsent(ctx.khachThue().getId(), k -> new ArrayList<>()).add(pt);
            }
        }
        
        int billableCount = 0;
        for (List<PhuongTien> pts : vehiclesByTenant.values()) {
            pts.sort((v1, v2) -> {
                if (v1.getCreatedAt() == null && v2.getCreatedAt() == null) return 0;
                if (v1.getCreatedAt() == null) return 1;
                if (v2.getCreatedAt() == null) return -1;
                return v1.getCreatedAt().compareTo(v2.getCreatedAt());
            });
            // First vehicle is free, the rest are billable
            if (pts.size() > 1) {
                billableCount += (pts.size() - 1);
            }
        }
        
        if (billableCount > 0) {
            // Find parking fee in CauHinhGia or DichVuHopDong
            BigDecimal parkingFee = resolveParkingFee(ctx);
            if (parkingFee.compareTo(BigDecimal.ZERO) > 0) {
                addLine(lines, hoaDon, null, null, LoaiMucHoaDon.PARKING, "Phí gửi xe (" + billableCount + " chiếc)", BigDecimal.valueOf(billableCount), parkingFee);
            }
        }
        
        return lines;
    }
    
    private BigDecimal resolveParkingFee(InvoiceContext ctx) {
        // Ưu tiên đơn giá dịch vụ đã gắn với hợp đồng, nếu còn hiệu lực trong kỳ hóa đơn.
        List<DichVuHopDong> services = dichVuHopDongRepository.findByHopDongIdOrderByTaoLucAsc(ctx.hopDong().getId());
        for (DichVuHopDong svc : services) {
            if (svc.getDichVu() != null && isParkingServiceName(svc.getDichVu().getTenDichVu())
                    && isServiceActiveInPeriod(svc, ctx.tuNgay(), ctx.denNgay())) {
                return svc.getDonGiaApDung() != null ? svc.getDonGiaApDung() : BigDecimal.ZERO;
            }
        }

        return findApplicablePrice(ctx, LoaiMucHoaDon.PARKING);
    }

    private List<ChiTietHoaDon> buildManualLineItems(HoaDonRequest req, HoaDon hoaDon) {
        List<ChiTietHoaDon> items = new ArrayList<>();
        for (HoaDonRequest.ChiTietItem ci : req.getChiTietHoaDon()) {
            if (ci == null) continue;
            LoaiMucHoaDon loai = parseLoaiMuc(ci.getLoai());
            BigDecimal soLuong = ci.getSoLuong() != null ? ci.getSoLuong() : BigDecimal.ONE;
            BigDecimal donGia = ci.getDonGia() != null ? ci.getDonGia() : BigDecimal.ZERO;
            BigDecimal thanhTien = ci.getThanhTien() != null ? ci.getThanhTien() : donGia.multiply(soLuong);
            validateLineMoney(loai, soLuong, donGia, thanhTien);
            items.add(ChiTietHoaDon.builder()
                    .hoaDon(hoaDon)
                    .loai(loai)
                    .dichVuId(ci.getDichVuId())
                    .chiSoDienNuocId(ci.getChiSoDienNuocId())
                    .moTa(nonBlank(ci.getMoTa(), loai.name()))
                    .soLuong(soLuong)
                    .donGia(donGia)
                    .thanhTien(thanhTien)
                    .build());
        }
        return items;
    }

    @Transactional
    public HoaDonQuyetToanResult createFinalSettlement(HoaDonRequest request,
            List<KhoanKhauTruCocRequest> khoanKhauTru, BigDecimal tienCoc) {
        request.setLoaiHoaDon(LoaiHoaDon.FINAL_SETTLEMENT.name());
        request.setTrangThai("chuaThanhToan");
        HoaDonResponse response = create(request);
        HoaDon hoaDon = hoaDonRepository.findById(response.getId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn quyết toán"));
        List<ChiTietHoaDon> items = new ArrayList<>(chiTietHoaDonRepository.findByHoaDonId(hoaDon.getId()));

        if (khoanKhauTru != null) {
            for (KhoanKhauTruCocRequest item : khoanKhauTru) {
                if (item == null || item.getSoTien() == null || item.getSoTien().compareTo(BigDecimal.ZERO) <= 0) continue;
                items.add(ChiTietHoaDon.builder()
                        .hoaDon(hoaDon)
                        .loai(LoaiMucHoaDon.MAINTENANCE)
                        .moTa("Khoản khấu trừ cọc: " + item.getMoTa().trim() + " | Chứng từ: " + item.getChungTuUrl().trim())
                        .soLuong(BigDecimal.ONE)
                        .donGia(item.getSoTien())
                        .thanhTien(item.getSoTien())
                        .build());
            }
        }

        BigDecimal gross = items.stream()
                .map(ChiTietHoaDon::getThanhTien)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal tienCocDaCanTru = defaultMoney(tienCoc).min(gross.max(BigDecimal.ZERO));
        if (tienCocDaCanTru.compareTo(BigDecimal.ZERO) > 0) {
            items.add(ChiTietHoaDon.builder()
                    .hoaDon(hoaDon)
                    .loai(LoaiMucHoaDon.DISCOUNT)
                    .moTa("Cấn trừ tiền cọc hợp đồng")
                    .soLuong(BigDecimal.ONE)
                    .donGia(BigDecimal.ZERO)
                    .thanhTien(tienCocDaCanTru.negate())
                    .build());
        }
        List<ChiTietHoaDon> newItems = items.stream().filter(item -> item.getId() == null).toList();
        if (!newItems.isEmpty()) chiTietHoaDonRepository.saveAll(newItems);
        List<ChiTietHoaDon> savedItems = chiTietHoaDonRepository.findByHoaDonId(hoaDon.getId());
        syncInvoiceTotals(hoaDon, savedItems);
        hoaDonRepository.save(hoaDon);
        return HoaDonQuyetToanResult.builder()
                .hoaDon(HoaDonResponse.fromEntity(hoaDon, savedItems))
                .tienCocDaCanTru(tienCocDaCanTru)
                .build();
    }

    private void addMeterLine(List<ChiTietHoaDon> items, HoaDon hoaDon, InvoiceContext ctx, LoaiChiSo loaiChiSo,
            LoaiMucHoaDon loaiMuc, Integer chiSoCu, Integer chiSoMoi,
            Integer actualConsumption, String moTa) {
        if (chiSoCu == null && chiSoMoi == null) return;
        if (chiSoCu == null || chiSoMoi == null) {
            throw new RuntimeException("Cần nhập đủ chỉ số cũ và mới cho " + moTa.toLowerCase(Locale.ROOT));
        }
        boolean resetMeter = actualConsumption != null;
        if (chiSoCu < 0 || (!resetMeter && chiSoMoi < chiSoCu)) {
            throw new RuntimeException("Chỉ số điện nước không hợp lệ");
        }
        if (resetMeter && actualConsumption < 0) {
            throw new RuntimeException("Số tiêu thụ thực tế không hợp lệ");
        }
        int tieuThu = resetMeter ? actualConsumption : chiSoMoi - chiSoCu;
        if (tieuThu == 0) return;

        BigDecimal soLuong = BigDecimal.valueOf(tieuThu);
        BigDecimal donGia = resolveMeterUnitPrice(ctx, loaiMuc);
        if (donGia.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("Chưa có đơn giá hợp lệ cho " + moTa.toLowerCase(Locale.ROOT));
        }
        UUID readingId = upsertReading(hoaDon, ctx, loaiChiSo, chiSoCu, chiSoMoi);
        addLine(items, hoaDon, null, readingId, loaiMuc, moTa + " " + chiSoCu + "-" + chiSoMoi, soLuong, donGia);
    }

    private BigDecimal resolveRoomPrice(InvoiceContext ctx) {
        if (ctx.hopDong() == null) {
            return BigDecimal.ZERO;
        }
        BigDecimal contractPrice = defaultMoney(ctx.hopDong().getGiaThueHopDong());
        if (ctx.hopDong().getId() == null || ctx.tuNgay() == null) {
            return contractPrice;
        }
        BigDecimal monthlyPrice = phuLucHopDongRepository.findByHopDongIdOrderByNgayHieuLucDescTaoLucDesc(ctx.hopDong().getId()).stream()
                .filter(phuLuc -> phuLuc.getGiaThueMoi() != null)
                .filter(phuLuc -> phuLuc.getNgayHieuLuc() != null && !phuLuc.getNgayHieuLuc().isAfter(ctx.tuNgay()))
                .map(PhuLucHopDong::getGiaThueMoi)
                .map(this::defaultMoney)
                .findFirst()
                .orElse(contractPrice);
        return calculateProratedRoomRent(monthlyPrice, ctx.hopDong(), ctx.tuNgay(), ctx.denNgay());
    }

    public static BigDecimal calculateProratedRoomRent(BigDecimal monthlyPrice, HopDong hopDong,
            LocalDate tuNgay, LocalDate denNgay) {
        if (monthlyPrice == null || monthlyPrice.compareTo(BigDecimal.ZERO) <= 0
                || hopDong == null || tuNgay == null || denNgay == null) {
            return BigDecimal.ZERO;
        }
        LocalDate occupiedStart = hopDong.getNgayBatDau() != null && hopDong.getNgayBatDau().isAfter(tuNgay)
                ? hopDong.getNgayBatDau() : tuNgay;
        LocalDate contractEnd = effectiveContractEnd(hopDong);
        LocalDate occupiedEnd = contractEnd != null && contractEnd.isBefore(denNgay) ? contractEnd : denNgay;
        if (occupiedEnd.isBefore(occupiedStart)) {
            return BigDecimal.ZERO;
        }
        long occupiedDays = ChronoUnit.DAYS.between(occupiedStart, occupiedEnd) + 1;
        int daysInMonth = YearMonth.from(tuNgay).lengthOfMonth();
        if (occupiedDays == daysInMonth) {
            return monthlyPrice;
        }
        return monthlyPrice.multiply(BigDecimal.valueOf(occupiedDays))
                .divide(BigDecimal.valueOf(daysInMonth), 2, RoundingMode.HALF_UP);
    }

    private String roomChargeDescription(InvoiceContext ctx) {
        LocalDate occupiedStart = ctx.hopDong().getNgayBatDau() != null && ctx.hopDong().getNgayBatDau().isAfter(ctx.tuNgay())
                ? ctx.hopDong().getNgayBatDau() : ctx.tuNgay();
        LocalDate contractEnd = effectiveContractEnd(ctx.hopDong());
        LocalDate occupiedEnd = contractEnd != null && contractEnd.isBefore(ctx.denNgay()) ? contractEnd : ctx.denNgay();
        if (occupiedEnd.isBefore(occupiedStart)) return "Tiền phòng";
        long occupiedDays = ChronoUnit.DAYS.between(occupiedStart, occupiedEnd) + 1;
        int daysInMonth = YearMonth.from(ctx.tuNgay()).lengthOfMonth();
        return occupiedDays == daysInMonth ? "Tiền phòng" : "Tiền phòng " + occupiedDays + "/" + daysInMonth + " ngày";
    }

    private static LocalDate effectiveContractEnd(HopDong hopDong) {
        LocalDate scheduledEnd = hopDong.getNgayKetThuc();
        LocalDate actualEnd = hopDong.getNgayKetThucThucTe();
        if (scheduledEnd == null) return actualEnd;
        if (actualEnd == null) return scheduledEnd;
        return actualEnd.isBefore(scheduledEnd) ? actualEnd : scheduledEnd;
    }

    private List<ChiTietHoaDon> buildContractServiceLines(HoaDon hoaDon, InvoiceContext ctx) {
        List<DichVuHopDong> services = dichVuHopDongRepository.findByHopDongIdOrderByTaoLucAsc(ctx.hopDong().getId());
        if (services.isEmpty()) return Collections.emptyList();

        List<ChiTietHoaDon> items = new ArrayList<>();
        for (DichVuHopDong service : services) {
            if (!isServiceActiveInPeriod(service, ctx.tuNgay(), ctx.denNgay())) continue;
            String ten = service.getDichVu() != null ? service.getDichVu().getTenDichVu() : "Dá»‹ch vá»¥";
            if (isMeterServiceName(ten) || isParkingServiceName(ten)) continue;
            BigDecimal soLuong = resolveServiceQuantity(service, ctx.hopDong(), ctx.tuNgay(), ctx.denNgay());
            addLine(items, hoaDon, service.getDichVu() != null ? service.getDichVu().getId() : null, null,
                    LoaiMucHoaDon.SERVICE, ten, soLuong, service.getDonGiaApDung());
        }
        return items;
    }

    private void addLine(List<ChiTietHoaDon> items, HoaDon hoaDon, UUID dichVuId, UUID chiSoDienNuocId,
            LoaiMucHoaDon loai, String moTa, BigDecimal soLuong, BigDecimal donGia) {
        if (donGia == null || soLuong == null) return;
        if (donGia.compareTo(BigDecimal.ZERO) == 0 || soLuong.compareTo(BigDecimal.ZERO) == 0) return;
        BigDecimal thanhTien = donGia.multiply(soLuong);
        validateLineMoney(loai, soLuong, donGia, thanhTien);
        items.add(ChiTietHoaDon.builder()
                .hoaDon(hoaDon)
                .loai(loai)
                .dichVuId(dichVuId)
                .chiSoDienNuocId(chiSoDienNuocId)
                .moTa(nonBlank(moTa, loai.name()))
                .soLuong(soLuong)
                .donGia(donGia)
                .thanhTien(thanhTien)
                .build());
    }

    private void persistLineItemsAndTotals(HoaDon hoaDon, List<ChiTietHoaDon> items) {
        List<ChiTietHoaDon> savedItems = chiTietHoaDonRepository.saveAll(items);
        syncInvoiceTotals(hoaDon, savedItems);
        hoaDonRepository.save(hoaDon);
    }

    private void syncInvoiceTotals(HoaDon hoaDon, List<ChiTietHoaDon> items) {
        BigDecimal tongPhatSinh = items.stream()
                .map(ChiTietHoaDon::getThanhTien)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        hoaDon.setTongTienPhatSinh(tongPhatSinh);
        hoaDon.setTongTien(defaultMoney(hoaDon.getSoDuDauKy()).add(tongPhatSinh));
        hoaDon.setTrangThai(resolveInvoiceStatus(hoaDon.getTrangThai(), defaultMoney(hoaDon.getDaTra()), hoaDon.getTongTien(), hoaDon.getHanTra()));
    }

    private UUID upsertReading(HoaDon hoaDon, InvoiceContext ctx, LoaiChiSo loai, Integer chiSoCu, Integer chiSoMoi) {
        int expectedStart = latestReadingBeforePeriod(ctx.phong().getId(), loai, ctx.kyThang(), ctx.kyNam())
                .orElse(defaultMeterReading(loai == LoaiChiSo.ELECTRICITY
                        ? ctx.hopDong().getChiSoDienBanDau()
                        : ctx.hopDong().getChiSoNuocBanDau()));
        if (!Objects.equals(chiSoCu, expectedStart)) {
            throw new RuntimeException("Chỉ số cũ không khớp chỉ số cuối kỳ trước của phòng (dự kiến: "
                    + expectedStart + ")");
        }
        ChiSoDienNuoc reading = chiSoDienNuocRepository
                .findByPhongIdAndLoaiAndKyNamAndKyThang(ctx.phong().getId(), loai, ctx.kyNam(), ctx.kyThang())
                .orElseGet(ChiSoDienNuoc::new);
        if (reading.getId() != null && reading.getHopDong() != null
                && !reading.getHopDong().getId().equals(ctx.hopDong().getId())
                && reading.getTrangThai() != TrangThaiChiSo.CANCELLED) {
            throw new RuntimeException("Chỉ số " + loai.name() + " của phòng trong kỳ này đã được ghi cho hợp đồng khác");
        }
        reading.setPhong(ctx.phong());
        reading.setHopDong(ctx.hopDong());
        reading.setLoai(loai);
        reading.setKyNam(hoaDon.getKyNam());
        reading.setKyThang(hoaDon.getKyThang());
        reading.setNgayGhi(hoaDon.getDenNgay() != null ? hoaDon.getDenNgay() : LocalDate.now());
        reading.setChiSoCu(chiSoCu);
        reading.setChiSoMoi(chiSoMoi);
        reading.setTrangThai(TrangThaiChiSo.BILLED);
        return chiSoDienNuocRepository.save(reading).getId();
    }

    private BigDecimal resolveMeterUnitPrice(InvoiceContext ctx, LoaiMucHoaDon loai) {
        BigDecimal configPrice = findApplicablePrice(ctx, loai);
        if (configPrice.compareTo(BigDecimal.ZERO) > 0) {
            return configPrice;
        }
        BigDecimal servicePrice = findMeterPriceFromContractServices(ctx.hopDong(), loai);
        if (servicePrice.compareTo(BigDecimal.ZERO) > 0) {
            return servicePrice;
        }
        return BigDecimal.ZERO;
    }

    private BigDecimal findApplicablePrice(InvoiceContext ctx, LoaiMucHoaDon loai) {
        if (ctx.phong() == null || ctx.phong().getNhaTro() == null) return BigDecimal.ZERO;
        return cauHinhGiaRepository.findApplicable(ctx.phong().getNhaTro().getId(), loai, ctx.tuNgay()).stream()
                .findFirst()
                .map(CauHinhGia::getDonGia)
                .map(this::defaultMoney)
                .orElse(BigDecimal.ZERO);
    }

    private BigDecimal findMeterPriceFromContractServices(HopDong hopDong, LoaiMucHoaDon loai) {
        String keyword = loai == LoaiMucHoaDon.ELECTRICITY ? "dien" : "nuoc";
        String english = loai == LoaiMucHoaDon.ELECTRICITY ? "electricity" : "water";
        return dichVuHopDongRepository.findByHopDongIdOrderByTaoLucAsc(hopDong.getId()).stream()
                .filter(item -> item.getDichVu() != null)
                .filter(item -> containsNormalized(item.getDichVu().getTenDichVu(), keyword)
                        || containsNormalized(item.getDichVu().getTenDichVu(), english))
                .map(DichVuHopDong::getDonGiaApDung)
                .filter(value -> value != null && value.compareTo(BigDecimal.ZERO) > 0)
                .findFirst()
                .orElse(BigDecimal.ZERO);
    }

    private BigDecimal resolveServiceQuantity(DichVuHopDong service, HopDong hopDong, LocalDate tuNgay, LocalDate denNgay) {
        if (service.getLoaiTinhPhi() == LoaiTinhPhi.PER_PERSON) {
            return BigDecimal.valueOf(Math.max(1, countActiveMembers(hopDong, tuNgay, denNgay)));
        }
        return service.getSoLuong() != null ? service.getSoLuong() : BigDecimal.ONE;
    }

    private long countActiveMembers(HopDong hopDong, LocalDate tuNgay, LocalDate denNgay) {
        List<ThanhVienHopDong> members = thanhVienHopDongRepository.findByHopDongIdOrderByLaNguoiDaiDienDescTaoLucAsc(hopDong.getId());
        long count = members.stream()
                .filter(member -> !Boolean.FALSE.equals(member.getDangO()))
                .filter(member -> member.getNgayVao() == null || !member.getNgayVao().isAfter(denNgay))
                .filter(member -> member.getNgayRoi() == null || !member.getNgayRoi().isBefore(tuNgay))
                .count();
        return count > 0 ? count : 1;
    }

    private boolean isServiceActiveInPeriod(DichVuHopDong service, LocalDate tuNgay, LocalDate denNgay) {
        LocalDate start = service.getBatDauTu();
        LocalDate end = service.getKetThucLuc();
        return (start == null || !start.isAfter(denNgay)) && (end == null || !end.isBefore(tuNgay));
    }

    private boolean isMeterServiceName(String name) {
        return containsNormalized(name, "dien") || containsNormalized(name, "electricity")
                || containsNormalized(name, "nuoc") || containsNormalized(name, "water");
    }

    private boolean isParkingServiceName(String name) {
        return containsNormalized(name, "gui xe") || containsNormalized(name, "parking");
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

    private void markReadingsCancelled(UUID hoaDonId) {
        for (ChiTietHoaDon item : chiTietHoaDonRepository.findByHoaDonId(hoaDonId)) {
            if (item.getChiSoDienNuocId() == null) continue;
            chiSoDienNuocRepository.findById(item.getChiSoDienNuocId()).ifPresent(reading -> {
                reading.setTrangThai(TrangThaiChiSo.CANCELLED);
                chiSoDienNuocRepository.save(reading);
            });
        }
    }

    private Optional<ChiSoDienNuoc> readingForPeriod(HopDong hopDong, LoaiChiSo loai, int thang, int nam) {
        return chiSoDienNuocRepository.findByPhongIdAndLoaiAndKyNamAndKyThang(
                        hopDong.getPhong().getId(), loai, nam, thang)
                .filter(item -> item.getTrangThai() != TrangThaiChiSo.CANCELLED)
                .filter(item -> item.getHopDong() == null || hopDong.getId().equals(item.getHopDong().getId()));
    }

    private Optional<Integer> latestReadingBeforePeriod(UUID phongId, LoaiChiSo loai, int thang, int nam) {
        return chiSoDienNuocRepository.findByPhongIdAndLoaiOrderByKyNamDescKyThangDesc(phongId, loai).stream()
                .filter(item -> item.getTrangThai() != TrangThaiChiSo.CANCELLED)
                .filter(item -> isBeforeBillingPeriod(item, thang, nam))
                .map(ChiSoDienNuoc::getChiSoMoi)
                .filter(Objects::nonNull)
                .findFirst();
    }

    private boolean isBeforeBillingPeriod(ChiSoDienNuoc item, int thang, int nam) {
        return item.getKyNam() != null && item.getKyThang() != null
                && (item.getKyNam() < nam || (item.getKyNam() == nam && item.getKyThang() < thang));
    }

    private int defaultMeterReading(Integer reading) {
        return reading != null ? reading : 0;
    }

    private void ensureInvoicePeriodAvailable(UUID hopDongId, int kyNam, int kyThang, LoaiHoaDon loaiHoaDon, UUID excludeId) {
        Optional<HoaDon> existing;
        if (loaiHoaDon == LoaiHoaDon.REGULAR) {
            existing = excludeId == null
                    ? hoaDonRepository.findByHopDongIdAndKyNamAndKyThangAndXoaLucIsNull(hopDongId, kyNam, kyThang)
                    : hoaDonRepository.findByHopDongIdAndKyNamAndKyThangAndIdNotAndXoaLucIsNull(hopDongId, kyNam, kyThang, excludeId);
        } else {
            existing = excludeId == null
                    ? hoaDonRepository.findByHopDongIdAndKyNamAndKyThangAndLoaiHoaDonAndXoaLucIsNull(hopDongId, kyNam, kyThang, loaiHoaDon)
                    : hoaDonRepository.findByHopDongIdAndKyNamAndKyThangAndLoaiHoaDonAndIdNotAndXoaLucIsNull(hopDongId, kyNam, kyThang, loaiHoaDon, excludeId);
        }
        if (existing.isPresent()) {
            throw new RuntimeException("Hợp đồng đã có hóa đơn trong kỳ " + kyThang + "/" + kyNam);
        }
    }

    private boolean hasBillingPayload(HoaDonRequest req) {
        return req.getChiTietHoaDon() != null || req.getPhiDichVu() != null
                || req.getTienPhong() != null || req.getTienDien() != null || req.getTienNuoc() != null
                || req.getChiSoDienBanDau() != null || req.getChiSoDienCuoiKy() != null
                || req.getChiSoNuocBanDau() != null || req.getChiSoNuocCuoiKy() != null;
    }

    private boolean changedBillingContext(HoaDon hd, InvoiceContext ctx) {
        return !hd.getHopDong().getId().equals(ctx.hopDong().getId())
                || !Objects.equals(hd.getKyNam(), ctx.kyNam())
                || !Objects.equals(hd.getKyThang(), ctx.kyThang())
                || !Objects.equals(hd.getTuNgay(), ctx.tuNgay())
                || !Objects.equals(hd.getDenNgay(), ctx.denNgay());
    }

    private void validateRequestedRef(UUID first, UUID second, UUID expected, String label) {
        UUID requested = coalesce(first, second);
        if (requested != null && expected != null && !requested.equals(expected)) {
            throw new RuntimeException("Hóa đơn phải đúng " + label + " của hợp đồng");
        }
    }

    private void validateInvoiceMonth(int kyNam, int kyThang) {
        if (kyThang < 1 || kyThang > 12 || kyNam < 2000 || kyNam > 2100) {
            throw new RuntimeException("Kỳ hóa đơn không hợp lệ");
        }
    }

    private void validateInvoiceDates(LocalDate tuNgay, LocalDate denNgay, LocalDate hanTra, HopDong hopDong) {
        if (tuNgay == null || denNgay == null || hanTra == null) {
            throw new RuntimeException("Vui lòng nhập đủ ngày hóa đơn");
        }
        if (denNgay.isBefore(tuNgay)) {
            throw new RuntimeException("Đến ngày phải sau hoặc bằng từ ngày");
        }
        if (hanTra.isBefore(tuNgay)) {
            throw new RuntimeException("Hạn trả không được trước từ ngày");
        }
        if (hopDong.getNgayBatDau() != null && denNgay.isBefore(hopDong.getNgayBatDau())) {
            throw new RuntimeException("Kỳ hóa đơn nằm trước ngày bắt đầu hợp đồng");
        }
        if (hopDong.getNgayKetThuc() != null && tuNgay.isAfter(hopDong.getNgayKetThuc())) {
            throw new RuntimeException("Kỳ hóa đơn nằm sau ngày kết thúc hợp đồng");
        }
    }

    private LocalDate billingDueDate(int kyNam, int kyThang) {
        return LocalDate.of(kyNam, kyThang, Math.min(5, YearMonth.of(kyNam, kyThang).lengthOfMonth()));
    }

    private String resolveInvoiceCode(String raw, InvoiceContext ctx) {
        String normalized = raw != null ? raw.trim() : "";
        if (!normalized.isBlank()) {
            return normalized;
        }
        return "HD" + ctx.kyNam() + String.format("%02d", ctx.kyThang()) + "-"
                + UUID.randomUUID().toString().substring(0, 6).toUpperCase(Locale.ROOT);
    }

    private TrangThaiHoaDon parseTrangThai(String value, TrangThaiHoaDon fallback) {
        if (value == null || value.isBlank()) return fallback;
        return switch (value.trim()) {
            case "nhap" -> TrangThaiHoaDon.DRAFT;
            case "chuaThanhToan" -> TrangThaiHoaDon.UNPAID;
            case "daThanhToanMotPhan", "PARTIAL", "OVERPAID", "thanhToanDu" ->
                    throw new RuntimeException("Hệ thống không hỗ trợ thanh toán từng phần hoặc thanh toán dư");
            case "daThanhToan", "PAID", "quaHan", "OVERDUE" ->
                    throw new RuntimeException("Trạng thái đã thanh toán hoặc quá hạn chỉ được hệ thống cập nhật");
            case "daHuy" -> TrangThaiHoaDon.CANCELLED;
            default -> {
                try {
                    yield TrangThaiHoaDon.valueOf(value.trim().toUpperCase(Locale.ROOT));
                } catch (Exception e) {
                    throw new RuntimeException("Trạng thái hóa đơn không hợp lệ: " + value);
                }
            }
        };
    }

    private LoaiHoaDon parseLoaiHoaDon(String value, LoaiHoaDon fallback) {
        if (value == null || value.isBlank()) return fallback != null ? fallback : LoaiHoaDon.REGULAR;
        try {
            return LoaiHoaDon.valueOf(value.trim().toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException ex) {
            throw new RuntimeException("Loại hóa đơn không hợp lệ: " + value);
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

    private TrangThaiHoaDon resolveInvoiceStatus(TrangThaiHoaDon requested, BigDecimal paid, BigDecimal total, LocalDate hanTra) {
        if (requested == TrangThaiHoaDon.CANCELLED) return TrangThaiHoaDon.CANCELLED;
        if (requested == TrangThaiHoaDon.DRAFT && total.compareTo(BigDecimal.ZERO) == 0 && paid.compareTo(BigDecimal.ZERO) == 0) {
            return TrangThaiHoaDon.DRAFT;
        }
        if (paid.compareTo(total) == 0 && total.compareTo(BigDecimal.ZERO) > 0) return TrangThaiHoaDon.PAID;
        if (hanTra != null && hanTra.isBefore(LocalDate.now())) return TrangThaiHoaDon.OVERDUE;
        return TrangThaiHoaDon.UNPAID;
    }

    private LoaiMucHoaDon parseLoaiMuc(String value) {
        if (value == null || value.isBlank()) {
            throw new RuntimeException("Loại mục hóa đơn là bắt buộc");
        }
        try {
            return LoaiMucHoaDon.valueOf(value.trim().toUpperCase(Locale.ROOT));
        } catch (Exception e) {
            throw new RuntimeException("Loại mục hóa đơn không hợp lệ: " + value);
        }
    }

    private void validateLineMoney(LoaiMucHoaDon loai, BigDecimal soLuong, BigDecimal donGia, BigDecimal thanhTien) {
        if (soLuong == null || soLuong.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("Số lượng hóa đơn không hợp lệ");
        }
        if (donGia == null || donGia.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("Đơn giá hóa đơn không hợp lệ");
        }
        if (thanhTien == null) {
            throw new RuntimeException("Thành tiền hóa đơn không hợp lệ");
        }
        if (loai == LoaiMucHoaDon.DISCOUNT) {
            return;
        }
        if (thanhTien.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("Thành tiền hóa đơn không được âm");
        }
    }

    private BigDecimal nonNegativeMoney(BigDecimal value, String label) {
        BigDecimal result = value != null ? value : BigDecimal.ZERO;
        if (result.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException(label + " không được âm");
        }
        return result;
    }

    private BigDecimal defaultMoney(BigDecimal value) {
        return value != null ? value : BigDecimal.ZERO;
    }

    private String nonBlank(String value, String fallback) {
        return value != null && !value.isBlank() ? value.trim() : fallback;
    }

    private UUID coalesce(UUID first, UUID second) {
        return first != null ? first : second;
    }

    private record InvoiceContext(
            HopDong hopDong,
            Phong phong,
            KhachThue khachThue,
            int kyNam,
            int kyThang,
            LocalDate tuNgay,
            LocalDate denNgay,
            LocalDate hanTra
    ) {}

    @org.springframework.beans.factory.annotation.Autowired
    private com.example.quanlyphongtro.repository.AuditLogRepository auditLogRepository;

    private void logAudit(HoaDon hd, String hanhDong) {
        if (auditLogRepository == null) return;
        com.example.quanlyphongtro.entity.AuditLog log = com.example.quanlyphongtro.entity.AuditLog.builder()
            .nguoiDung(com.example.quanlyphongtro.entity.NguoiDung.builder().id(permissionService.requireCurrentUserId()).build())
            .hanhDong(hanhDong)
            .bangTacDong("hoa_don")
            .banGhiId(hd.getId())
            .taoLuc(java.time.ZonedDateTime.now())
            .build();
        auditLogRepository.save(log);
    }
}
