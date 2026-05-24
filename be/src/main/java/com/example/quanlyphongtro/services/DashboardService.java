package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.DashboardStatsResponse;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import com.example.quanlyphongtro.entity.TrangThaiThanhToan;
import com.example.quanlyphongtro.entity.TrangThaiHoaDon;
import com.example.quanlyphongtro.entity.TrangThaiHopDong;
import com.example.quanlyphongtro.entity.TrangThaiSuCo;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.ThanhToanRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.SuCoRepository;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class DashboardService {

    private final PhongRepository phongRepository;
    private final ThanhToanRepository thanhToanRepository;
    private final HoaDonRepository hoaDonRepository;
    private final HopDongRepository hopDongRepository;
    private final SuCoRepository suCoRepository;
    private final KhachThueRepository khachThueRepository;

    public DashboardStatsResponse getStats() {
        long tongSoPhong = phongRepository.count();
        long phongTrong = phongRepository.countByTrangThai(TrangThaiPhong.AVAILABLE);
        long phongDangThue = phongRepository.countByTrangThai(TrangThaiPhong.RENTED);
        long phongBaoTri = phongRepository.countByTrangThai(TrangThaiPhong.MAINTENANCE);
        long tongKhachDangThue = khachThueRepository.countByDangHoatDongTrueAndXoaLucIsNull();

        // Date calculations for payments (ZonedDateTime)
        ZonedDateTime nowZoned = ZonedDateTime.now();
        ZonedDateTime startOfMonth = nowZoned.withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0).withNano(0);
        ZonedDateTime endOfMonth = startOfMonth.plusMonths(1);

        ZonedDateTime startOfYear = nowZoned.withDayOfYear(1).withHour(0).withMinute(0).withSecond(0).withNano(0);
        ZonedDateTime endOfYear = startOfYear.plusYears(1);

        // Date calculations for invoices & contracts (LocalDate)
        LocalDate today = LocalDate.now();
        LocalDate next7Days = today.plusDays(7);
        LocalDate next30Days = today.plusDays(30);

        // Query aggregations
        BigDecimal doanhThuThang = thanhToanRepository.sumSuccessfulPaymentsInPeriod(
                TrangThaiThanhToan.SUCCESS, startOfMonth, endOfMonth);
        BigDecimal doanhThuNam = thanhToanRepository.sumSuccessfulPaymentsInPeriod(
                TrangThaiThanhToan.SUCCESS, startOfYear, endOfYear);

        BigDecimal tienDaThu = doanhThuThang != null ? doanhThuThang : BigDecimal.ZERO;
        BigDecimal tienChuaThu = hoaDonRepository.sumUnpaidAmount(
                List.of(TrangThaiHoaDon.UNPAID, TrangThaiHoaDon.PARTIAL, TrangThaiHoaDon.OVERDUE));

        long hoaDonSapDenHan = hoaDonRepository.countUnpaidInvoicesDueBetween(
                List.of(TrangThaiHoaDon.UNPAID, TrangThaiHoaDon.PARTIAL, TrangThaiHoaDon.OVERDUE), today, next7Days);

        long suCoCanXuLy = suCoRepository.countByTrangThai(TrangThaiSuCo.PENDING)
                + suCoRepository.countByTrangThai(TrangThaiSuCo.IN_PROGRESS);

        long hopDongSapHetHan = hopDongRepository.countContractsExpiringBetween(
                TrangThaiHopDong.ACTIVE, today, next30Days);

        return DashboardStatsResponse.builder()
                .tongSoPhong(tongSoPhong)
                .phongTrong(phongTrong)
                .phongDangThue(phongDangThue)
                .phongBaoTri(phongBaoTri)
                .doanhThuThang(doanhThuThang)
                .doanhThuNam(doanhThuNam)
                .hoaDonSapDenHan(hoaDonSapDenHan)
                .suCoCanXuLy(suCoCanXuLy)
                .hopDongSapHetHan(hopDongSapHetHan)
                .tongKhachDangThue(tongKhachDangThue)
                .tienDaThu(tienDaThu)
                .tienChuaThu(tienChuaThu)
                .build();
    }
}
