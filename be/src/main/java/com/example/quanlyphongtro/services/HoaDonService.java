package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.HoaDonRequest;
import com.example.quanlyphongtro.dto.HoaDonResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.Normalizer;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.HashMap;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;

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

    @Transactional(readOnly = true)
    public List<HoaDonResponse> getAll() {
        List<HoaDon> list = hoaDonRepository.findByXoaLucIsNullOrderByTaoLucDesc();
        List<HoaDonResponse> res = new ArrayList<>();
        for (HoaDon hd : list) {
            res.add(HoaDonResponse.fromEntity(hd, chiTietHoaDonRepository.findByHoaDonId(hd.getId())));
        }
        return res;
    }

    @Transactional(readOnly = true)
    public HoaDonResponse getById(UUID id) {
        HoaDon hd = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay hoa don"));
        if (hd.getXoaLuc() != null) {
            throw new RuntimeException("Hoa don da bi xoa");
        }
        return HoaDonResponse.fromEntity(hd, chiTietHoaDonRepository.findByHoaDonId(id));
    }

    @Transactional
    public HoaDonResponse create(HoaDonRequest req) {
        InvoiceContext ctx = resolveContext(req, null);
        ensureInvoicePeriodAvailable(ctx.hopDong().getId(), ctx.kyNam(), ctx.kyThang(), null);

        BigDecimal daTra = nonNegativeMoney(req.getDaThanhToan(), "So tien da thanh toan");
        HoaDon hd = HoaDon.builder()
                .phong(ctx.phong())
                .hopDong(ctx.hopDong())
                .khachThue(ctx.khachThue())
                .maHoaDon(resolveInvoiceCode(req.getMaHoaDon(), ctx))
                .kyNam(ctx.kyNam())
                .kyThang(ctx.kyThang())
                .tuNgay(ctx.tuNgay())
                .denNgay(ctx.denNgay())
                .soDuDauKy(nonNegativeMoney(req.getSoDuDauKy(), "So du dau ky"))
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
        return HoaDonResponse.fromEntity(saved, items);
    }

    @Transactional
    public HoaDonResponse update(UUID id, HoaDonRequest req) {
        HoaDon hd = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay hoa don"));
        if (hd.getXoaLuc() != null) {
            throw new RuntimeException("Hoa don da bi xoa");
        }

        InvoiceContext ctx = resolveContext(req, hd);
        ensureInvoicePeriodAvailable(ctx.hopDong().getId(), ctx.kyNam(), ctx.kyThang(), hd.getId());
        boolean billingContextChanged = changedBillingContext(hd, ctx);

        hd.setHopDong(ctx.hopDong());
        hd.setPhong(ctx.phong());
        hd.setKhachThue(ctx.khachThue());
        hd.setKyNam(ctx.kyNam());
        hd.setKyThang(ctx.kyThang());
        hd.setTuNgay(ctx.tuNgay());
        hd.setDenNgay(ctx.denNgay());
        hd.setHanTra(ctx.hanTra());
        if (req.getMaHoaDon() != null) hd.setMaHoaDon(resolveInvoiceCode(req.getMaHoaDon(), ctx));
        if (req.getSoDuDauKy() != null) hd.setSoDuDauKy(nonNegativeMoney(req.getSoDuDauKy(), "So du dau ky"));
        if (req.getDaThanhToan() != null) hd.setDaTra(nonNegativeMoney(req.getDaThanhToan(), "So tien da thanh toan"));
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

        return HoaDonResponse.fromEntity(hd, items);
    }

    @Transactional
    public void delete(UUID id) {
        HoaDon hd = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay hoa don"));
        markReadingsCancelled(id);
        hd.setTrangThai(TrangThaiHoaDon.CANCELLED);
        hd.setXoaLuc(ZonedDateTime.now());
        hoaDonRepository.save(hd);
    }

    @Transactional(readOnly = true)
    public Map<String, Object> getFormData() {
        Map<String, Object> result = new HashMap<>();
        result.put("hopDongList", hopDongRepository.findAllActive().stream()
                .map(hopDongService::toResponse).toList());
        result.put("phongList", phongRepository.findAll().stream()
                .map(com.example.quanlyphongtro.dto.PhongResponse::fromEntity).toList());
        result.put("khachThueList", khachThueRepository.findByXoaLucIsNullOrderByTaoLucDesc().stream()
                .map(com.example.quanlyphongtro.dto.KhachThueResponse::fromEntity).toList());
        return result;
    }

    @Transactional(readOnly = true)
    public Map<String, Object> getLatestReading(UUID hopDongId, int thang, int nam) {
        Map<String, Object> result = new HashMap<>();
        result.put("isFirstInvoice", true);
        result.put("chiSoDienBanDau", 0);
        result.put("chiSoNuocBanDau", 0);

        HopDong hd = hopDongRepository.findById(hopDongId).orElse(null);
        if (hd != null && hd.getPhong() != null) {
            Optional<Integer> latestElectric = latestReading(hd.getPhong().getId(), LoaiChiSo.ELECTRICITY);
            Optional<Integer> latestWater = latestReading(hd.getPhong().getId(), LoaiChiSo.WATER);
            result.put("chiSoDienBanDau", latestElectric.orElse(hd.getChiSoDienBanDau() != null ? hd.getChiSoDienBanDau() : 0));
            result.put("chiSoNuocBanDau", latestWater.orElse(hd.getChiSoNuocBanDau() != null ? hd.getChiSoNuocBanDau() : 0));
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
        return result;
    }

    private InvoiceContext resolveContext(HoaDonRequest req, HoaDon existing) {
        UUID hopDongId = coalesce(req.getHopDongId(), req.getHopDong());
        HopDong hopDong = hopDongId != null
                ? hopDongRepository.findById(hopDongId).orElseThrow(() -> new RuntimeException("Khong tim thay hop dong"))
                : existing != null ? existing.getHopDong() : null;
        if (hopDong == null || hopDong.getXoaLuc() != null) {
            throw new RuntimeException("Hoa don bat buoc chon hop dong hop le");
        }
        if (hopDong.getTrangThai() == TrangThaiHopDong.DRAFT || hopDong.getTrangThai() == TrangThaiHopDong.CANCELLED) {
            throw new RuntimeException("Hop dong nhap hoac da huy khong duoc lap hoa don");
        }

        Phong phong = hopDong.getPhong();
        KhachThue khachThue = hopDong.getKhachThue();
        if (phong == null || khachThue == null) {
            throw new RuntimeException("Hop dong thieu phong hoac khach thue, khong the lap hoa don");
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
        LocalDate hanTra = req.getHanTra() != null ? req.getHanTra()
                : req.getHanThanhToan() != null ? req.getHanThanhToan()
                : existing != null ? existing.getHanTra()
                : denNgay.plusDays(resolvePaymentGraceDays(hopDong));

        validateInvoiceDates(tuNgay, denNgay, hanTra, hopDong);
        return new InvoiceContext(hopDong, phong, khachThue, kyNam, kyThang, tuNgay, denNgay, hanTra);
    }

    private List<ChiTietHoaDon> buildLineItems(HoaDonRequest req, HoaDon hoaDon, InvoiceContext ctx) {
        if (req.getChiTietHoaDon() != null) {
            List<ChiTietHoaDon> manualItems = buildManualLineItems(req, hoaDon);
            if (manualItems.isEmpty()) {
                throw new RuntimeException("Hoa don phai co it nhat mot dong chi tiet");
            }
            return manualItems;
        }

        List<ChiTietHoaDon> items = new ArrayList<>();
        addLine(items, hoaDon, null, null, LoaiMucHoaDon.ROOM, "Tien phong", BigDecimal.ONE,
                req.getTienPhong() != null ? req.getTienPhong() : defaultMoney(ctx.hopDong().getGiaThueHopDong()));

        addMeterLine(items, hoaDon, ctx, LoaiChiSo.ELECTRICITY, LoaiMucHoaDon.ELECTRICITY,
                req.getChiSoDienBanDau(), req.getChiSoDienCuoiKy(), req.getTienDien(), "Tien dien");
        addMeterLine(items, hoaDon, ctx, LoaiChiSo.WATER, LoaiMucHoaDon.WATER,
                req.getChiSoNuocBanDau(), req.getChiSoNuocCuoiKy(), req.getTienNuoc(), "Tien nuoc");

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

        if (items.isEmpty()) {
            throw new RuntimeException("Hoa don phai co it nhat mot dong chi tiet");
        }
        return items;
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

    private void addMeterLine(List<ChiTietHoaDon> items, HoaDon hoaDon, InvoiceContext ctx, LoaiChiSo loaiChiSo,
            LoaiMucHoaDon loaiMuc, Integer chiSoCu, Integer chiSoMoi, BigDecimal requestTotal, String moTa) {
        if (chiSoCu == null && chiSoMoi == null) return;
        if (chiSoCu == null || chiSoMoi == null) {
            throw new RuntimeException("Can nhap du chi so cu va moi cho " + moTa.toLowerCase(Locale.ROOT));
        }
        if (chiSoCu < 0 || chiSoMoi < chiSoCu) {
            throw new RuntimeException("Chi so dien nuoc khong hop le");
        }
        int tieuThu = chiSoMoi - chiSoCu;
        if (tieuThu == 0) return;

        BigDecimal soLuong = BigDecimal.valueOf(tieuThu);
        BigDecimal donGia = resolveMeterUnitPrice(ctx, loaiMuc, requestTotal, soLuong);
        if (donGia.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("Chua co don gia hop le cho " + moTa.toLowerCase(Locale.ROOT));
        }
        UUID readingId = upsertReading(hoaDon, ctx, loaiChiSo, chiSoCu, chiSoMoi);
        addLine(items, hoaDon, null, readingId, loaiMuc, moTa + " " + chiSoCu + "-" + chiSoMoi, soLuong, donGia);
    }

    private List<ChiTietHoaDon> buildContractServiceLines(HoaDon hoaDon, InvoiceContext ctx) {
        List<DichVuHopDong> services = dichVuHopDongRepository.findByHopDongIdOrderByTaoLucAsc(ctx.hopDong().getId());
        if (services.isEmpty()) return Collections.emptyList();

        List<ChiTietHoaDon> items = new ArrayList<>();
        for (DichVuHopDong service : services) {
            if (!isServiceActiveInPeriod(service, ctx.tuNgay(), ctx.denNgay())) continue;
            String ten = service.getDichVu() != null ? service.getDichVu().getTenDichVu() : "Dich vu";
            if (isMeterServiceName(ten)) continue;
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
        ChiSoDienNuoc reading = chiSoDienNuocRepository
                .findByPhongIdAndLoaiAndKyNamAndKyThang(ctx.phong().getId(), loai, ctx.kyNam(), ctx.kyThang())
                .orElseGet(ChiSoDienNuoc::new);
        if (reading.getId() != null && reading.getHopDong() != null
                && !reading.getHopDong().getId().equals(ctx.hopDong().getId())
                && reading.getTrangThai() != TrangThaiChiSo.CANCELLED) {
            throw new RuntimeException("Chi so " + loai.name() + " cua phong trong ky nay da duoc ghi cho hop dong khac");
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

    private BigDecimal resolveMeterUnitPrice(InvoiceContext ctx, LoaiMucHoaDon loai, BigDecimal requestTotal, BigDecimal consumption) {
        BigDecimal configPrice = findApplicablePrice(ctx, loai);
        if (configPrice.compareTo(BigDecimal.ZERO) > 0) {
            return configPrice;
        }
        BigDecimal servicePrice = findMeterPriceFromContractServices(ctx.hopDong(), loai);
        if (servicePrice.compareTo(BigDecimal.ZERO) > 0) {
            return servicePrice;
        }
        if (requestTotal != null && requestTotal.compareTo(BigDecimal.ZERO) > 0 && consumption.compareTo(BigDecimal.ZERO) > 0) {
            return requestTotal.divide(consumption, 2, RoundingMode.HALF_UP);
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

    private Optional<Integer> latestReading(UUID phongId, LoaiChiSo loai) {
        return chiSoDienNuocRepository.findByPhongIdAndLoaiOrderByKyNamDescKyThangDesc(phongId, loai).stream()
                .filter(item -> item.getTrangThai() != TrangThaiChiSo.CANCELLED)
                .map(ChiSoDienNuoc::getChiSoMoi)
                .filter(Objects::nonNull)
                .findFirst();
    }

    private void ensureInvoicePeriodAvailable(UUID hopDongId, int kyNam, int kyThang, UUID excludeId) {
        Optional<HoaDon> existing = excludeId == null
                ? hoaDonRepository.findByHopDongIdAndKyNamAndKyThangAndXoaLucIsNull(hopDongId, kyNam, kyThang)
                : hoaDonRepository.findByHopDongIdAndKyNamAndKyThangAndIdNotAndXoaLucIsNull(hopDongId, kyNam, kyThang, excludeId);
        if (existing.isPresent()) {
            throw new RuntimeException("Hop dong da co hoa don trong ky " + kyThang + "/" + kyNam);
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
            throw new RuntimeException("Hoa don phai dung " + label + " cua hop dong");
        }
    }

    private void validateInvoiceMonth(int kyNam, int kyThang) {
        if (kyThang < 1 || kyThang > 12 || kyNam < 2000 || kyNam > 2100) {
            throw new RuntimeException("Ky hoa don khong hop le");
        }
    }

    private void validateInvoiceDates(LocalDate tuNgay, LocalDate denNgay, LocalDate hanTra, HopDong hopDong) {
        if (tuNgay == null || denNgay == null || hanTra == null) {
            throw new RuntimeException("Vui long nhap du ngay hoa don");
        }
        if (denNgay.isBefore(tuNgay)) {
            throw new RuntimeException("Den ngay phai sau hoac bang tu ngay");
        }
        if (hanTra.isBefore(tuNgay)) {
            throw new RuntimeException("Han tra khong duoc truoc tu ngay");
        }
        if (hopDong.getNgayBatDau() != null && denNgay.isBefore(hopDong.getNgayBatDau())) {
            throw new RuntimeException("Ky hoa don nam truoc ngay bat dau hop dong");
        }
        if (hopDong.getNgayKetThuc() != null && tuNgay.isAfter(hopDong.getNgayKetThuc())) {
            throw new RuntimeException("Ky hoa don nam sau ngay ket thuc hop dong");
        }
    }

    private int resolvePaymentGraceDays(HopDong hopDong) {
        Integer day = hopDong.getNgayThanhToanHangThang();
        return day != null ? Math.max(0, Math.min(day, 31)) : 5;
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
            case "daThanhToanMotPhan" -> TrangThaiHoaDon.PARTIAL;
            case "daThanhToan", "thanhToanDu" -> TrangThaiHoaDon.PAID;
            case "quaHan" -> TrangThaiHoaDon.OVERDUE;
            case "daHuy" -> TrangThaiHoaDon.CANCELLED;
            default -> {
                try {
                    yield TrangThaiHoaDon.valueOf(value.trim().toUpperCase(Locale.ROOT));
                } catch (Exception e) {
                    throw new RuntimeException("Trang thai hoa don khong hop le: " + value);
                }
            }
        };
    }

    private TrangThaiHoaDon resolveInvoiceStatus(TrangThaiHoaDon requested, BigDecimal paid, BigDecimal total, LocalDate hanTra) {
        if (requested == TrangThaiHoaDon.CANCELLED) return TrangThaiHoaDon.CANCELLED;
        if (requested == TrangThaiHoaDon.DRAFT && total.compareTo(BigDecimal.ZERO) == 0 && paid.compareTo(BigDecimal.ZERO) == 0) {
            return TrangThaiHoaDon.DRAFT;
        }
        if (paid.compareTo(BigDecimal.ZERO) == 0 && hanTra != null && hanTra.isBefore(LocalDate.now())) {
            return TrangThaiHoaDon.OVERDUE;
        }
        if (paid.compareTo(BigDecimal.ZERO) == 0) return TrangThaiHoaDon.UNPAID;
        if (paid.compareTo(total) < 0) return TrangThaiHoaDon.PARTIAL;
        if (paid.compareTo(total) == 0) return TrangThaiHoaDon.PAID;
        return TrangThaiHoaDon.OVERPAID;
    }

    private LoaiMucHoaDon parseLoaiMuc(String value) {
        if (value == null || value.isBlank()) {
            throw new RuntimeException("Loai muc hoa don bat buoc");
        }
        try {
            return LoaiMucHoaDon.valueOf(value.trim().toUpperCase(Locale.ROOT));
        } catch (Exception e) {
            throw new RuntimeException("Loai muc hoa don khong hop le: " + value);
        }
    }

    private void validateLineMoney(LoaiMucHoaDon loai, BigDecimal soLuong, BigDecimal donGia, BigDecimal thanhTien) {
        if (soLuong == null || soLuong.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("So luong hoa don khong hop le");
        }
        if (donGia == null || donGia.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("Don gia hoa don khong hop le");
        }
        if (thanhTien == null) {
            throw new RuntimeException("Thanh tien hoa don khong hop le");
        }
        if (loai == LoaiMucHoaDon.DISCOUNT) {
            return;
        }
        if (thanhTien.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException("Thanh tien hoa don khong duoc am");
        }
    }

    private BigDecimal nonNegativeMoney(BigDecimal value, String label) {
        BigDecimal result = value != null ? value : BigDecimal.ZERO;
        if (result.compareTo(BigDecimal.ZERO) < 0) {
            throw new RuntimeException(label + " khong duoc am");
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
}
