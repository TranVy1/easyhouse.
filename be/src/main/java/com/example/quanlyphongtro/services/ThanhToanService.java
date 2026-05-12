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

    // ========== GET ALL ==========
    public List<ThanhToanResponse> getAll() {
        List<ThanhToan> list = thanhToanRepository.findAll();
        // Sắp xếp theo ngày thanh toán mới nhất
        list.sort((a, b) -> {
            if (a.getNgayThanhToan() == null) return 1;
            if (b.getNgayThanhToan() == null) return -1;
            return b.getNgayThanhToan().compareTo(a.getNgayThanhToan());
        });

        List<ThanhToanResponse> responses = new ArrayList<>();
        for (ThanhToan tt : list) {
            List<ChiTietHoaDon> chiTiet = tt.getHoaDon() != null
                    ? chiTietHoaDonRepository.findByHoaDonId(tt.getHoaDon().getId())
                    : Collections.emptyList();
            responses.add(ThanhToanResponse.fromEntity(tt, chiTiet));
        }
        return responses;
    }

    // ========== GET BY ID ==========
    public ThanhToanResponse getById(UUID id) {
        ThanhToan tt = thanhToanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thanh toán"));
        List<ChiTietHoaDon> chiTiet = tt.getHoaDon() != null
                ? chiTietHoaDonRepository.findByHoaDonId(tt.getHoaDon().getId())
                : Collections.emptyList();
        return ThanhToanResponse.fromEntity(tt, chiTiet);
    }

    // ========== GET BY HOA DON ==========
    public List<ThanhToanResponse> getByHoaDon(UUID hoaDonId) {
        List<ThanhToan> list = thanhToanRepository.findByHoaDonIdOrderByNgayThanhToanDesc(hoaDonId);
        List<ThanhToanResponse> responses = new ArrayList<>();
        for (ThanhToan tt : list) {
            List<ChiTietHoaDon> chiTiet = chiTietHoaDonRepository.findByHoaDonId(hoaDonId);
            responses.add(ThanhToanResponse.fromEntity(tt, chiTiet));
        }
        return responses;
    }

    // ========== CREATE ==========
    @Transactional
    public ThanhToanResponse create(ThanhToanRequest request) {
        // Lookup hóa đơn
        HoaDon hoaDon = null;
        if (request.getHoaDonId() != null) {
            hoaDon = hoaDonRepository.findById(request.getHoaDonId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn"));
        }

        // Xác định mã tham chiếu
        String maThamChieu = null;
        if (request.getThongTinChuyenKhoan() != null) {
            maThamChieu = request.getThongTinChuyenKhoan().getSoGiaoDich();
        }

        // Parse ngày thanh toán
        ZonedDateTime ngayThanhToan = ZonedDateTime.now();
        if (request.getNgayThanhToan() != null && !request.getNgayThanhToan().isEmpty()) {
            try {
                LocalDate date = LocalDate.parse(request.getNgayThanhToan());
                ngayThanhToan = date.atStartOfDay(ZoneId.systemDefault());
            } catch (Exception e) {
                // Giữ nguyên ZonedDateTime.now()
            }
        }

        ThanhToan thanhToan = ThanhToan.builder()
                .hoaDon(hoaDon)
                .soTien(request.getSoTien())
                .phuongThuc(request.getPhuongThuc())
                .maThamChieu(maThamChieu)
                .ngayThanhToan(ngayThanhToan)
                .ghiChu(request.getGhiChu())
                .trangThai("SUCCESS")
                .build();

        ThanhToan saved = thanhToanRepository.save(thanhToan);

        // Cập nhật số tiền đã trả trên hóa đơn
        if (hoaDon != null && request.getSoTien() != null) {
            BigDecimal daTra = (hoaDon.getDaTra() != null ? hoaDon.getDaTra() : BigDecimal.ZERO)
                    .add(request.getSoTien());
            hoaDon.setDaTra(daTra);

            if (daTra.compareTo(hoaDon.getTongTien()) >= 0) {
                hoaDon.setTrangThai(TrangThaiHoaDon.PAID);
            } else if (daTra.compareTo(BigDecimal.ZERO) > 0) {
                hoaDon.setTrangThai(TrangThaiHoaDon.PARTIAL);
            }
            hoaDonRepository.save(hoaDon);
        }

        List<ChiTietHoaDon> chiTiet = hoaDon != null
                ? chiTietHoaDonRepository.findByHoaDonId(hoaDon.getId())
                : Collections.emptyList();
        return ThanhToanResponse.fromEntity(saved, chiTiet);
    }

    // ========== UPDATE ==========
    @Transactional
    public ThanhToanResponse update(UUID id, ThanhToanRequest request) {
        ThanhToan thanhToan = thanhToanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thanh toán"));

        // Lưu lại số tiền cũ để tính lại
        BigDecimal soTienCu = thanhToan.getSoTien();
        HoaDon hoaDonCu = thanhToan.getHoaDon();

        // Cập nhật hóa đơn nếu thay đổi
        if (request.getHoaDonId() != null) {
            HoaDon hoaDon = hoaDonRepository.findById(request.getHoaDonId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy hóa đơn"));
            thanhToan.setHoaDon(hoaDon);
        }

        if (request.getSoTien() != null) thanhToan.setSoTien(request.getSoTien());
        if (request.getPhuongThuc() != null) thanhToan.setPhuongThuc(request.getPhuongThuc());
        if (request.getGhiChu() != null) thanhToan.setGhiChu(request.getGhiChu());

        // Cập nhật mã tham chiếu
        if (request.getThongTinChuyenKhoan() != null) {
            thanhToan.setMaThamChieu(request.getThongTinChuyenKhoan().getSoGiaoDich());
        }

        // Parse ngày thanh toán
        if (request.getNgayThanhToan() != null && !request.getNgayThanhToan().isEmpty()) {
            try {
                LocalDate date = LocalDate.parse(request.getNgayThanhToan());
                thanhToan.setNgayThanhToan(date.atStartOfDay(ZoneId.systemDefault()));
            } catch (Exception e) {
                // Giữ nguyên
            }
        }

        ThanhToan saved = thanhToanRepository.save(thanhToan);

        // Tính lại số tiền đã trả trên hóa đơn cũ (nếu thay đổi hóa đơn)
        if (hoaDonCu != null) {
            recalculateHoaDonPayment(hoaDonCu.getId());
        }

        // Tính lại số tiền trên hóa đơn mới (nếu khác hóa đơn cũ)
        if (saved.getHoaDon() != null) {
            recalculateHoaDonPayment(saved.getHoaDon().getId());
        }

        List<ChiTietHoaDon> chiTiet = saved.getHoaDon() != null
                ? chiTietHoaDonRepository.findByHoaDonId(saved.getHoaDon().getId())
                : Collections.emptyList();
        return ThanhToanResponse.fromEntity(saved, chiTiet);
    }

    // ========== DELETE ==========
    @Transactional
    public void delete(UUID id) {
        ThanhToan thanhToan = thanhToanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thanh toán"));

        UUID hoaDonId = thanhToan.getHoaDon() != null ? thanhToan.getHoaDon().getId() : null;

        thanhToanRepository.delete(thanhToan);

        // Tính lại số tiền đã trả trên hóa đơn
        if (hoaDonId != null) {
            recalculateHoaDonPayment(hoaDonId);
        }
    }

    // ========== HELPER: Tính lại tổng đã trả từ tất cả thanh toán ==========
    private void recalculateHoaDonPayment(UUID hoaDonId) {
        HoaDon hoaDon = hoaDonRepository.findById(hoaDonId).orElse(null);
        if (hoaDon == null) return;

        List<ThanhToan> payments = thanhToanRepository.findByHoaDonIdOrderByNgayThanhToanDesc(hoaDonId);
        BigDecimal totalPaid = payments.stream()
                .map(ThanhToan::getSoTien)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        hoaDon.setDaTra(totalPaid);

        if (totalPaid.compareTo(BigDecimal.ZERO) == 0) {
            hoaDon.setTrangThai(TrangThaiHoaDon.UNPAID);
        } else if (totalPaid.compareTo(hoaDon.getTongTien()) >= 0) {
            hoaDon.setTrangThai(TrangThaiHoaDon.PAID);
        } else {
            hoaDon.setTrangThai(TrangThaiHoaDon.PARTIAL);
        }

        hoaDonRepository.save(hoaDon);
    }
}
