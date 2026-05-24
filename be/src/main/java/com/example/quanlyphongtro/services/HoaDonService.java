package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.HoaDonRequest;
import com.example.quanlyphongtro.dto.HoaDonResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.*;

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

    public List<HoaDonResponse> getAll() {
        List<HoaDon> list = hoaDonRepository.findByXoaLucIsNullOrderByTaoLucDesc();
        List<HoaDonResponse> res = new ArrayList<>();
        for (HoaDon hd : list) {
            res.add(HoaDonResponse.fromEntity(hd, chiTietHoaDonRepository.findByHoaDonId(hd.getId())));
        }
        return res;
    }

    public HoaDonResponse getById(UUID id) {
        HoaDon hd = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn"));
        return HoaDonResponse.fromEntity(hd, chiTietHoaDonRepository.findByHoaDonId(id));
    }

    @Transactional
    public HoaDonResponse create(HoaDonRequest req) {
        UUID hopDongId = coalesce(req.getHopDongId(), req.getHopDong());
        UUID phongId = coalesce(req.getPhongId(), req.getPhong());
        UUID khachThueId = coalesce(req.getKhachThueId(), req.getKhachThue());

        HopDong hopDong = hopDongId != null ? hopDongRepository.findById(hopDongId).orElse(null) : null;
        Phong phong = phongId != null ? phongRepository.findById(phongId).orElse(null) : null;
        KhachThue khachThue = khachThueId != null ? khachThueRepository.findById(khachThueId).orElse(null) : null;
        if (hopDong != null) {
            if (phong == null) phong = hopDong.getPhong();
            if (khachThue == null) khachThue = hopDong.getKhachThue();
        }

        int kyNam = req.getKyNam() != null ? req.getKyNam() : (req.getNam() != null ? req.getNam() : LocalDate.now().getYear());
        int kyThang = req.getKyThang() != null ? req.getKyThang() : (req.getThang() != null ? req.getThang() : LocalDate.now().getMonthValue());
        LocalDate tuNgay = req.getTuNgay() != null ? req.getTuNgay() : LocalDate.of(kyNam, kyThang, 1);
        LocalDate denNgay = req.getDenNgay() != null ? req.getDenNgay() : tuNgay.plusMonths(1).minusDays(1);
        LocalDate hanTra = req.getHanTra() != null ? req.getHanTra() : (req.getHanThanhToan() != null ? req.getHanThanhToan() : denNgay.plusDays(5));

        String maHoaDon = req.getMaHoaDon() != null && !req.getMaHoaDon().isBlank()
                ? req.getMaHoaDon().trim()
                : "HD" + kyNam + String.format("%02d", kyThang) + UUID.randomUUID().toString().substring(0, 6).toUpperCase();

        HoaDon hd = HoaDon.builder()
                .phong(phong).hopDong(hopDong).khachThue(khachThue)
                .maHoaDon(maHoaDon).kyNam(kyNam).kyThang(kyThang)
                .tuNgay(tuNgay).denNgay(denNgay)
                .soDuDauKy(req.getSoDuDauKy() != null ? req.getSoDuDauKy() : BigDecimal.ZERO)
                .tongTienPhatSinh(BigDecimal.ZERO).tongTien(BigDecimal.ZERO)
                .daTra(req.getDaThanhToan() != null ? req.getDaThanhToan() : BigDecimal.ZERO)
                .trangThai(parseTrangThai(req.getTrangThai(), TrangThaiHoaDon.DRAFT))
                .hanTra(hanTra).ngayLapHoaDon(ZonedDateTime.now())
                .ghiChu(req.getGhiChu())
                .build();

        HoaDon saved = hoaDonRepository.save(hd);

        // Create line items
        List<ChiTietHoaDon> items = new ArrayList<>();
        BigDecimal tongPhatSinh = BigDecimal.ZERO;
        List<HoaDonRequest.ChiTietItem> requestItems = normalizeLineItems(req, saved, phong, hopDong);
        if (requestItems != null) {
            for (HoaDonRequest.ChiTietItem ci : requestItems) {
                BigDecimal thanhTien = ci.getThanhTien() != null ? ci.getThanhTien()
                        : (ci.getSoLuong() != null && ci.getDonGia() != null ? ci.getSoLuong().multiply(ci.getDonGia()) : BigDecimal.ZERO);
                LoaiMucHoaDon loai = LoaiMucHoaDon.OTHER;
                try { loai = LoaiMucHoaDon.valueOf(ci.getLoai()); } catch (Exception ignored) {}
                items.add(ChiTietHoaDon.builder()
                        .hoaDon(saved).loai(loai)
                        .dichVuId(ci.getDichVuId())
                        .chiSoDienNuocId(ci.getChiSoDienNuocId())
                        .moTa(ci.getMoTa())
                        .soLuong(ci.getSoLuong() != null ? ci.getSoLuong() : BigDecimal.ONE)
                        .donGia(ci.getDonGia() != null ? ci.getDonGia() : BigDecimal.ZERO)
                        .thanhTien(thanhTien).build());
                tongPhatSinh = tongPhatSinh.add(thanhTien);
            }
        }
        chiTietHoaDonRepository.saveAll(items);

        // Update totals (DB trigger also does this, but set for response)
        saved.setTongTienPhatSinh(tongPhatSinh);
        saved.setTongTien(saved.getSoDuDauKy().add(tongPhatSinh));
        hoaDonRepository.save(saved);

        return HoaDonResponse.fromEntity(saved, items);
    }

    @Transactional
    public HoaDonResponse update(UUID id, HoaDonRequest req) {
        HoaDon hd = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn"));
        UUID hopDongId = coalesce(req.getHopDongId(), req.getHopDong());
        UUID phongId = coalesce(req.getPhongId(), req.getPhong());
        UUID khachThueId = coalesce(req.getKhachThueId(), req.getKhachThue());
        if (hopDongId != null) hd.setHopDong(hopDongRepository.findById(hopDongId).orElse(hd.getHopDong()));
        if (phongId != null) hd.setPhong(phongRepository.findById(phongId).orElse(hd.getPhong()));
        if (khachThueId != null) hd.setKhachThue(khachThueRepository.findById(khachThueId).orElse(hd.getKhachThue()));
        if (req.getKyNam() != null || req.getNam() != null) hd.setKyNam(req.getKyNam() != null ? req.getKyNam() : req.getNam());
        if (req.getKyThang() != null || req.getThang() != null) hd.setKyThang(req.getKyThang() != null ? req.getKyThang() : req.getThang());
        if (req.getTuNgay() != null) hd.setTuNgay(req.getTuNgay());
        if (req.getDenNgay() != null) hd.setDenNgay(req.getDenNgay());
        if (req.getHanTra() != null || req.getHanThanhToan() != null) hd.setHanTra(req.getHanTra() != null ? req.getHanTra() : req.getHanThanhToan());
        if (req.getGhiChu() != null) hd.setGhiChu(req.getGhiChu());
        if (req.getMaHoaDon() != null) hd.setMaHoaDon(req.getMaHoaDon());
        if (req.getSoDuDauKy() != null) hd.setSoDuDauKy(req.getSoDuDauKy());
        if (req.getDaThanhToan() != null) hd.setDaTra(req.getDaThanhToan());
        if (req.getTrangThai() != null) hd.setTrangThai(parseTrangThai(req.getTrangThai(), hd.getTrangThai()));

        // Rebuild chi tiet if provided
        List<HoaDonRequest.ChiTietItem> requestItems = normalizeLineItems(req, hd, hd.getPhong(), hd.getHopDong());
        if (requestItems != null) {
            chiTietHoaDonRepository.deleteByHoaDonId(id);
            List<ChiTietHoaDon> items = new ArrayList<>();
            BigDecimal tongPhatSinh = BigDecimal.ZERO;
            for (HoaDonRequest.ChiTietItem ci : requestItems) {
                BigDecimal thanhTien = ci.getThanhTien() != null ? ci.getThanhTien()
                        : (ci.getSoLuong() != null && ci.getDonGia() != null ? ci.getSoLuong().multiply(ci.getDonGia()) : BigDecimal.ZERO);
                LoaiMucHoaDon loai = LoaiMucHoaDon.OTHER;
                try { loai = LoaiMucHoaDon.valueOf(ci.getLoai()); } catch (Exception ignored) {}
                items.add(ChiTietHoaDon.builder()
                        .hoaDon(hd).loai(loai)
                        .dichVuId(ci.getDichVuId())
                        .chiSoDienNuocId(ci.getChiSoDienNuocId())
                        .moTa(ci.getMoTa())
                        .soLuong(ci.getSoLuong() != null ? ci.getSoLuong() : BigDecimal.ONE)
                        .donGia(ci.getDonGia() != null ? ci.getDonGia() : BigDecimal.ZERO)
                        .thanhTien(thanhTien).build());
                tongPhatSinh = tongPhatSinh.add(thanhTien);
            }
            chiTietHoaDonRepository.saveAll(items);
            hd.setTongTienPhatSinh(tongPhatSinh);
            hd.setTongTien(hd.getSoDuDauKy().add(tongPhatSinh));
        }

        HoaDon saved = hoaDonRepository.save(hd);
        return HoaDonResponse.fromEntity(saved, chiTietHoaDonRepository.findByHoaDonId(id));
    }

    @Transactional
    public void delete(UUID id) {
        HoaDon hd = hoaDonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn"));
        markReadingsCancelled(id);
        hd.setXoaLuc(ZonedDateTime.now());
        hoaDonRepository.save(hd);
    }

    @org.springframework.transaction.annotation.Transactional(readOnly = true)
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

    private List<HoaDonRequest.ChiTietItem> normalizeLineItems(HoaDonRequest req, HoaDon hoaDon, Phong phong, HopDong hopDong) {
        if (req.getChiTietHoaDon() != null) return req.getChiTietHoaDon();
        List<HoaDonRequest.ChiTietItem> items = new ArrayList<>();
        addLine(items, LoaiMucHoaDon.ROOM, "Tien phong", BigDecimal.ONE, req.getTienPhong());
        UUID chiSoDienId = upsertReading(hoaDon, phong, hopDong, LoaiChiSo.ELECTRICITY, req.getChiSoDienBanDau(), req.getChiSoDienCuoiKy());
        UUID chiSoNuocId = upsertReading(hoaDon, phong, hopDong, LoaiChiSo.WATER, req.getChiSoNuocBanDau(), req.getChiSoNuocCuoiKy());
        addLine(items, null, chiSoDienId, LoaiMucHoaDon.ELECTRICITY, readingDescription(req.getChiSoDienBanDau(), req.getChiSoDienCuoiKy(), "Tien dien"), BigDecimal.ONE, req.getTienDien());
        addLine(items, null, chiSoNuocId, LoaiMucHoaDon.WATER, readingDescription(req.getChiSoNuocBanDau(), req.getChiSoNuocCuoiKy(), "Tien nuoc"), BigDecimal.ONE, req.getTienNuoc());
        if (req.getPhiDichVu() != null) {
            for (HoaDonRequest.PhiDichVuItem phi : req.getPhiDichVu()) {
                BigDecimal soLuong = phi.getSoLuong() != null ? phi.getSoLuong() : BigDecimal.ONE;
                addLine(items, phi.getDichVuId(), LoaiMucHoaDon.SERVICE, phi.getTen(), soLuong, phi.getGia());
            }
        }
        return items.isEmpty() ? null : items;
    }

    private void addLine(List<HoaDonRequest.ChiTietItem> items, LoaiMucHoaDon loai, String moTa, BigDecimal soLuong, BigDecimal donGia) {
        addLine(items, null, loai, moTa, soLuong, donGia);
    }

    private void addLine(List<HoaDonRequest.ChiTietItem> items, UUID dichVuId, LoaiMucHoaDon loai, String moTa, BigDecimal soLuong, BigDecimal donGia) {
        addLine(items, dichVuId, null, loai, moTa, soLuong, donGia);
    }

    private void addLine(List<HoaDonRequest.ChiTietItem> items, UUID dichVuId, UUID chiSoDienNuocId, LoaiMucHoaDon loai, String moTa, BigDecimal soLuong, BigDecimal donGia) {
        if (donGia == null || donGia.compareTo(BigDecimal.ZERO) == 0) return;
        HoaDonRequest.ChiTietItem item = new HoaDonRequest.ChiTietItem();
        item.setDichVuId(dichVuId);
        item.setChiSoDienNuocId(chiSoDienNuocId);
        item.setLoai(loai.name());
        item.setMoTa(moTa);
        item.setSoLuong(soLuong);
        item.setDonGia(donGia);
        item.setThanhTien(donGia.multiply(soLuong));
        items.add(item);
    }

    private UUID upsertReading(HoaDon hoaDon, Phong phong, HopDong hopDong, LoaiChiSo loai, Integer chiSoCu, Integer chiSoMoi) {
        if (hoaDon == null || phong == null || chiSoCu == null || chiSoMoi == null) return null;
        if (chiSoCu < 0 || chiSoMoi < chiSoCu) {
            throw new RuntimeException("Chi so dien nuoc khong hop le");
        }

        ChiSoDienNuoc reading = chiSoDienNuocRepository
                .findByPhongIdAndLoaiAndKyNamAndKyThang(phong.getId(), loai, hoaDon.getKyNam(), hoaDon.getKyThang())
                .orElseGet(ChiSoDienNuoc::new);
        reading.setPhong(phong);
        reading.setHopDong(hopDong);
        reading.setLoai(loai);
        reading.setKyNam(hoaDon.getKyNam());
        reading.setKyThang(hoaDon.getKyThang());
        reading.setNgayGhi(hoaDon.getDenNgay() != null ? hoaDon.getDenNgay() : LocalDate.now());
        reading.setChiSoCu(chiSoCu);
        reading.setChiSoMoi(chiSoMoi);
        reading.setTrangThai(TrangThaiChiSo.BILLED);
        return chiSoDienNuocRepository.save(reading).getId();
    }

    private String readingDescription(Integer chiSoCu, Integer chiSoMoi, String fallback) {
        if (chiSoCu == null || chiSoMoi == null) return fallback;
        return chiSoCu + "-" + chiSoMoi;
    }

    private Optional<Integer> latestReading(UUID phongId, LoaiChiSo loai) {
        return chiSoDienNuocRepository.findByPhongIdAndLoaiOrderByKyNamDescKyThangDesc(phongId, loai).stream()
                .filter(item -> item.getTrangThai() != TrangThaiChiSo.CANCELLED)
                .map(ChiSoDienNuoc::getChiSoMoi)
                .filter(Objects::nonNull)
                .findFirst();
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

    private TrangThaiHoaDon parseTrangThai(String value, TrangThaiHoaDon fallback) {
        if (value == null || value.isBlank()) return fallback;
        return switch (value) {
            case "chuaThanhToan" -> TrangThaiHoaDon.UNPAID;
            case "daThanhToanMotPhan" -> TrangThaiHoaDon.PARTIAL;
            case "daThanhToan" -> TrangThaiHoaDon.PAID;
            case "quaHan" -> TrangThaiHoaDon.OVERDUE;
            default -> {
                try { yield TrangThaiHoaDon.valueOf(value.toUpperCase()); } catch (Exception e) { yield fallback; }
            }
        };
    }

    private UUID coalesce(UUID first, UUID second) {
        return first != null ? first : second;
    }
}
