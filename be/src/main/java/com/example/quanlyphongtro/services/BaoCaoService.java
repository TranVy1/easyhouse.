package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.BaoCaoTongQuanResponse;
import com.example.quanlyphongtro.dto.DoanhThuTheoThang;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import com.example.quanlyphongtro.entity.TrangThaiSuCo;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.SuCoRepository;
import com.example.quanlyphongtro.services.PermissionService;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BaoCaoService {

    private final HoaDonRepository hoaDonRepository;
    private final PhongRepository phongRepository;
    private final SuCoRepository suCoRepository;
    private final HopDongRepository hopDongRepository;
    private final PermissionService permissionService;

    @Transactional(readOnly = true)
    public BaoCaoTongQuanResponse getTongQuan() {
        UUID currentUserId = permissionService.requireCurrentUserId();
        List<UUID> nhaTroIds = permissionService.getAllAccessibleNhaTroIds(currentUserId);
        
        LocalDate today = LocalDate.now();
        int currentMonth = today.getMonthValue();
        int currentYear = today.getYear();

        LocalDate sixMonthsAgo = today.minusMonths(5);
        int startMonth = sixMonthsAgo.getMonthValue();
        int startYear = sixMonthsAgo.getYear();

        if (nhaTroIds != null && nhaTroIds.isEmpty()) {
            return BaoCaoTongQuanResponse.builder()
                .doanhThu(BigDecimal.ZERO).tienDaThu(BigDecimal.ZERO).tienChuaThu(BigDecimal.ZERO)
                .tyLeLapDay(0.0).suCoCanXuLy(0L).hopDongSapHetHan(0L).bieuDoDoanhThu(new ArrayList<>()).build();
        }

        List<DoanhThuTheoThang> thongKeList = nhaTroIds == null 
            ? hoaDonRepository.getDoanhThuThongKe(startYear, startMonth)
            : hoaDonRepository.getDoanhThuThongKeAndNhaTroIdIn(startYear, startMonth, nhaTroIds);

        BigDecimal doanhThu = BigDecimal.ZERO;
        BigDecimal tienDaThu = BigDecimal.ZERO;

        for (DoanhThuTheoThang tk : thongKeList) {
            if (tk.getNam() == currentYear && tk.getThang() == currentMonth) {
                doanhThu = doanhThu.add(tk.getDoanhThu() != null ? tk.getDoanhThu() : BigDecimal.ZERO);
                tienDaThu = tienDaThu.add(tk.getDaThu() != null ? tk.getDaThu() : BigDecimal.ZERO);
            }
        }
        
        BigDecimal tienChuaThu = doanhThu.subtract(tienDaThu);

        long totalRooms = nhaTroIds == null ? phongRepository.count() : phongRepository.countByNhaTroIdIn(nhaTroIds);
        long activeRooms = nhaTroIds == null ? phongRepository.countByTrangThai(TrangThaiPhong.RENTED) : phongRepository.countByTrangThaiAndNhaTroIdIn(TrangThaiPhong.RENTED, nhaTroIds);
        
        Double tyLeLapDay = totalRooms > 0 ? (double) activeRooms / totalRooms * 100 : 0.0;

        long suCoCanXuLy = nhaTroIds == null
            ? suCoRepository.countByTrangThai(TrangThaiSuCo.PENDING) + suCoRepository.countByTrangThai(TrangThaiSuCo.IN_PROGRESS)
            : suCoRepository.countByTrangThaiAndPhong_NhaTro_IdIn(TrangThaiSuCo.PENDING, nhaTroIds) + suCoRepository.countByTrangThaiAndPhong_NhaTro_IdIn(TrangThaiSuCo.IN_PROGRESS, nhaTroIds);

        LocalDate in30Days = today.plusDays(30);
        long hopDongSapHetHan = nhaTroIds == null
            ? hopDongRepository.countContractsExpiringBetween(com.example.quanlyphongtro.entity.TrangThaiHopDong.ACTIVE, today, in30Days)
            : hopDongRepository.countContractsExpiringBetweenAndNhaTroIdIn(com.example.quanlyphongtro.entity.TrangThaiHopDong.ACTIVE, today, in30Days, nhaTroIds);

        // Chart data for last 6 months
        List<BaoCaoTongQuanResponse.BieuDoDoanhThu> chartData = new ArrayList<>();
        for (int i = 5; i >= 0; i--) {
            LocalDate monthDate = today.minusMonths(i);
            int m = monthDate.getMonthValue();
            int y = monthDate.getYear();
            
            BigDecimal mDoanhThu = BigDecimal.ZERO;
            BigDecimal mDaThu = BigDecimal.ZERO;
            
            for (DoanhThuTheoThang tk : thongKeList) {
                if (tk.getNam() == y && tk.getThang() == m) {
                    mDoanhThu = mDoanhThu.add(tk.getDoanhThu() != null ? tk.getDoanhThu() : BigDecimal.ZERO);
                    mDaThu = mDaThu.add(tk.getDaThu() != null ? tk.getDaThu() : BigDecimal.ZERO);
                }
            }
            
            String label = String.format("%02d/%d", m, y);
            chartData.add(BaoCaoTongQuanResponse.BieuDoDoanhThu.builder()
                    .thang(label)
                    .doanhThu(mDoanhThu)
                    .daThu(mDaThu)
                    .build());
        }

        return BaoCaoTongQuanResponse.builder()
                .doanhThu(doanhThu)
                .tienDaThu(tienDaThu)
                .tienChuaThu(tienChuaThu)
                .tyLeLapDay(tyLeLapDay)
                .suCoCanXuLy(suCoCanXuLy)
                .hopDongSapHetHan(hopDongSapHetHan)
                .bieuDoDoanhThu(chartData)
                .build();
    }
}
