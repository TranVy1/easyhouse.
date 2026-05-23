package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.ThanhToanRequest;
import com.example.quanlyphongtro.dto.ThanhToanResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.time.ZoneId;
import java.util.*;

@Service
@RequiredArgsConstructor
public class ThanhToanService {

    private final ThanhToanRepository thanhToanRepository;
    private final HoaDonRepository hoaDonRepository;
    private final ChiTietHoaDonRepository chiTietHoaDonRepository;
    private final MediaService mediaService;

    public List<ThanhToanResponse> getAll() {
        List<ThanhToan> list = thanhToanRepository.findAll();
        list.sort((a, b) -> {
            if (a.getNgayThanhToan() == null) return 1;
            if (b.getNgayThanhToan() == null) return -1;
            return b.getNgayThanhToan().compareTo(a.getNgayThanhToan());
        });
        List<ThanhToanResponse> res = new ArrayList<>();
        for (ThanhToan tt : list) {
            List<ChiTietHoaDon> ct = tt.getHoaDon() != null ? chiTietHoaDonRepository.findByHoaDonId(tt.getHoaDon().getId()) : Collections.emptyList();
            res.add(toResponse(tt, ct));
        }
        return res;
    }

    public ThanhToanResponse getById(UUID id) {
        ThanhToan tt = thanhToanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thanh toán"));
        List<ChiTietHoaDon> ct = tt.getHoaDon() != null ? chiTietHoaDonRepository.findByHoaDonId(tt.getHoaDon().getId()) : Collections.emptyList();
        return toResponse(tt, ct);
    }

    public List<ThanhToanResponse> getByHoaDon(UUID hoaDonId) {
        return thanhToanRepository.findByHoaDonIdOrderByNgayThanhToanDesc(hoaDonId).stream()
                .map(tt -> toResponse(tt, chiTietHoaDonRepository.findByHoaDonId(hoaDonId)))
                .toList();
    }

    @Transactional
    public ThanhToanResponse create(ThanhToanRequest req) {
        HoaDon hoaDon = req.getHoaDonId() != null ? hoaDonRepository.findById(req.getHoaDonId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn")) : null;

        String maThamChieu = req.getThongTinChuyenKhoan() != null ? req.getThongTinChuyenKhoan().getSoGiaoDich() : null;

        PhuongThucThanhToan pttt = parsePhuongThuc(req.getPhuongThuc());

        ZonedDateTime ngayTT = ZonedDateTime.now();
        if (req.getNgayThanhToan() != null && !req.getNgayThanhToan().isEmpty()) {
            try { ngayTT = LocalDate.parse(req.getNgayThanhToan()).atStartOfDay(ZoneId.systemDefault()); } catch (Exception ignored) {}
        }

        ThanhToan tt = ThanhToan.builder()
                .hoaDon(hoaDon).soTien(req.getSoTien())
                .phuongThucThanhToan(pttt)
                .maThamChieu(maThamChieu)
                .ngayThanhToan(ngayTT).ghiChu(req.getGhiChu())
                .trangThai(TrangThaiThanhToan.SUCCESS)
                .build();
        ThanhToan saved = thanhToanRepository.save(tt);
        mediaService.replaceUrl(LoaiDoiTuongMedia.PAYMENT, saved.getId(), req.getAnhBienLai(), MediaService.PAYMENT_RECEIPT);

        if (hoaDon != null && req.getSoTien() != null) {
            BigDecimal daTra = (hoaDon.getDaTra() != null ? hoaDon.getDaTra() : BigDecimal.ZERO).add(req.getSoTien());
            hoaDon.setDaTra(daTra);
            hoaDon.setTrangThai(resolveInvoiceStatus(daTra, hoaDon.getTongTien()));
            hoaDonRepository.save(hoaDon);
        }

        List<ChiTietHoaDon> ct = hoaDon != null ? chiTietHoaDonRepository.findByHoaDonId(hoaDon.getId()) : Collections.emptyList();
        return toResponse(saved, ct);
    }

    @Transactional
    public void delete(UUID id) {
        ThanhToan tt = thanhToanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thanh toán"));
        UUID hdId = tt.getHoaDon() != null ? tt.getHoaDon().getId() : null;
        thanhToanRepository.delete(tt);
        if (hdId != null) recalculate(hdId);
    }

    private void recalculate(UUID hoaDonId) {
        HoaDon hd = hoaDonRepository.findById(hoaDonId).orElse(null);
        if (hd == null) return;
        BigDecimal total = thanhToanRepository.findByHoaDonIdOrderByNgayThanhToanDesc(hoaDonId).stream()
                .map(ThanhToan::getSoTien).filter(Objects::nonNull).reduce(BigDecimal.ZERO, BigDecimal::add);
        hd.setDaTra(total);
        if (total.compareTo(BigDecimal.ZERO) == 0) hd.setTrangThai(TrangThaiHoaDon.UNPAID);
        else if (total.compareTo(hd.getTongTien()) >= 0) hd.setTrangThai(resolveInvoiceStatus(total, hd.getTongTien()));
        else hd.setTrangThai(TrangThaiHoaDon.PARTIAL);
        hoaDonRepository.save(hd);
    }

    private PhuongThucThanhToan parsePhuongThuc(String value) {
        if (value == null || value.isBlank()) return PhuongThucThanhToan.CASH;
        return switch (value) {
            case "tienMat" -> PhuongThucThanhToan.CASH;
            case "chuyenKhoan" -> PhuongThucThanhToan.BANK_TRANSFER;
            case "viDienTu" -> PhuongThucThanhToan.OTHER;
            default -> {
                try { yield PhuongThucThanhToan.valueOf(value.toUpperCase()); } catch (Exception e) { yield PhuongThucThanhToan.CASH; }
            }
        };
    }

    private TrangThaiHoaDon resolveInvoiceStatus(BigDecimal paid, BigDecimal total) {
        if (total != null && paid.compareTo(total) > 0) return TrangThaiHoaDon.OVERPAID;
        return TrangThaiHoaDon.PAID;
    }

    private ThanhToanResponse toResponse(ThanhToan thanhToan, List<ChiTietHoaDon> chiTietList) {
        ThanhToanResponse response = ThanhToanResponse.fromEntity(thanhToan, chiTietList);
        response.setAnhBienLai(mediaService.firstUrl(LoaiDoiTuongMedia.PAYMENT, thanhToan.getId(), MediaService.PAYMENT_RECEIPT));
        return response;
    }
}
