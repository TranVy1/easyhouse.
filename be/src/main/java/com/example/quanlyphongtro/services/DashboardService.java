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
import com.example.quanlyphongtro.services.PermissionService;
import java.util.UUID;
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
    private final PermissionService permissionService;

    public DashboardStatsResponse getStats() {
        UUID currentUserId = permissionService.requireCurrentUserId();
        List<UUID> nhaTroIds = permissionService.getAllAccessibleNhaTroIds(currentUserId);
        // nhaTroIds is null if admin (sees all)
        // nhaTroIds is empty if staff/landlord with 0 properties
        if (nhaTroIds != null && nhaTroIds.isEmpty()) {
            return DashboardStatsResponse.builder()
                .tongSoPhong(0L).phongTrong(0L).phongDangThue(0L).phongBaoTri(0L).tongKhachDangThue(0L)
                .doanhThuThang(BigDecimal.ZERO).doanhThuNam(BigDecimal.ZERO).tienDaThu(BigDecimal.ZERO).tienChuaThu(BigDecimal.ZERO)
                .hoaDonSapDenHan(0L).suCoCanXuLy(0L).hopDongSapHetHan(0L).build();
        }

        long tongSoPhong = nhaTroIds == null ? phongRepository.count() : phongRepository.countByNhaTroIdIn(nhaTroIds);
        long phongTrong = nhaTroIds == null ? phongRepository.countByTrangThai(TrangThaiPhong.AVAILABLE) : phongRepository.countByTrangThaiAndNhaTroIdIn(TrangThaiPhong.AVAILABLE, nhaTroIds);
        long phongDangThue = nhaTroIds == null ? phongRepository.countByTrangThai(TrangThaiPhong.RENTED) : phongRepository.countByTrangThaiAndNhaTroIdIn(TrangThaiPhong.RENTED, nhaTroIds);
        long phongBaoTri = nhaTroIds == null ? phongRepository.countByTrangThai(TrangThaiPhong.MAINTENANCE) : phongRepository.countByTrangThaiAndNhaTroIdIn(TrangThaiPhong.MAINTENANCE, nhaTroIds);
        long tongKhachDangThue = nhaTroIds == null ? khachThueRepository.countByDangHoatDongTrueAndXoaLucIsNull() : hopDongRepository.countActiveTenantsByNhaTroIdIn(nhaTroIds);

        ZonedDateTime nowZoned = ZonedDateTime.now();
        ZonedDateTime startOfMonth = nowZoned.withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0).withNano(0);
        ZonedDateTime endOfMonth = startOfMonth.plusMonths(1);
        ZonedDateTime startOfYear = nowZoned.withDayOfYear(1).withHour(0).withMinute(0).withSecond(0).withNano(0);
        ZonedDateTime endOfYear = startOfYear.plusYears(1);

        LocalDate today = LocalDate.now();
        LocalDate next7Days = today.plusDays(7);
        LocalDate next30Days = today.plusDays(30);

        BigDecimal doanhThuThang = nhaTroIds == null 
            ? thanhToanRepository.sumSuccessfulPaymentsInPeriod(TrangThaiThanhToan.SUCCESS, startOfMonth, endOfMonth)
            : thanhToanRepository.sumSuccessfulPaymentsInPeriodAndNhaTroIdIn(TrangThaiThanhToan.SUCCESS, startOfMonth, endOfMonth, nhaTroIds);
            
        BigDecimal doanhThuNam = nhaTroIds == null
            ? thanhToanRepository.sumSuccessfulPaymentsInPeriod(TrangThaiThanhToan.SUCCESS, startOfYear, endOfYear)
            : thanhToanRepository.sumSuccessfulPaymentsInPeriodAndNhaTroIdIn(TrangThaiThanhToan.SUCCESS, startOfYear, endOfYear, nhaTroIds);

        BigDecimal tienDaThu = doanhThuThang != null ? doanhThuThang : BigDecimal.ZERO;
        
        List<TrangThaiHoaDon> unpaidStatuses = List.of(TrangThaiHoaDon.UNPAID, TrangThaiHoaDon.PARTIAL, TrangThaiHoaDon.OVERDUE);
        BigDecimal tienChuaThu = nhaTroIds == null 
            ? hoaDonRepository.sumUnpaidAmount(unpaidStatuses)
            : hoaDonRepository.sumUnpaidAmountAndNhaTroIdIn(unpaidStatuses, nhaTroIds);
        if (tienChuaThu == null) tienChuaThu = BigDecimal.ZERO;

        long hoaDonSapDenHan = nhaTroIds == null 
            ? hoaDonRepository.countUnpaidInvoicesDueBetween(unpaidStatuses, today, next7Days)
            : hoaDonRepository.countUnpaidInvoicesDueBetweenAndNhaTroIdIn(unpaidStatuses, today, next7Days, nhaTroIds);

        long suCoCanXuLy = nhaTroIds == null
            ? suCoRepository.countByTrangThai(TrangThaiSuCo.PENDING) + suCoRepository.countByTrangThai(TrangThaiSuCo.IN_PROGRESS)
            : suCoRepository.countByTrangThaiAndPhong_NhaTro_IdIn(TrangThaiSuCo.PENDING, nhaTroIds) + suCoRepository.countByTrangThaiAndPhong_NhaTro_IdIn(TrangThaiSuCo.IN_PROGRESS, nhaTroIds);

        long hopDongSapHetHan = nhaTroIds == null
            ? hopDongRepository.countContractsExpiringBetween(TrangThaiHopDong.ACTIVE, today, next30Days)
            : hopDongRepository.countContractsExpiringBetweenAndNhaTroIdIn(TrangThaiHopDong.ACTIVE, today, next30Days, nhaTroIds);

        return DashboardStatsResponse.builder()
                .tongSoPhong(tongSoPhong)
                .phongTrong(phongTrong)
                .phongDangThue(phongDangThue)
                .phongBaoTri(phongBaoTri)
                .doanhThuThang(doanhThuThang != null ? doanhThuThang : BigDecimal.ZERO)
                .doanhThuNam(doanhThuNam != null ? doanhThuNam : BigDecimal.ZERO)
                .hoaDonSapDenHan(hoaDonSapDenHan)
                .suCoCanXuLy(suCoCanXuLy)
                .hopDongSapHetHan(hopDongSapHetHan)
                .tongKhachDangThue(tongKhachDangThue)
                .tienDaThu(tienDaThu)
                .tienChuaThu(tienChuaThu)
                .build();
    }
}
