package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.BaoCaoTongQuanResponse;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import com.example.quanlyphongtro.entity.TrangThaiSuCo;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.SuCoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BaoCaoService {

    private final HoaDonRepository hoaDonRepository;
    private final PhongRepository phongRepository;
    private final SuCoRepository suCoRepository;
    private final HopDongRepository hopDongRepository;

    @Transactional(readOnly = true)
    public BaoCaoTongQuanResponse getTongQuan() {
        LocalDate startOfMonth = LocalDate.now().withDayOfMonth(1);
        LocalDate endOfMonth = startOfMonth.plusMonths(1).minusDays(1);
        
        // Use streams to calculate aggregates if no custom query exists
        var hoaDons = hoaDonRepository.findAll();
        
        BigDecimal doanhThu = BigDecimal.ZERO;
        BigDecimal tienDaThu = BigDecimal.ZERO;

        for (var hd : hoaDons) {
            LocalDate hdDate = hd.getTaoLuc() != null ? hd.getTaoLuc().toLocalDate() : null;
            if (hdDate != null && !hdDate.isBefore(startOfMonth) && !hdDate.isAfter(endOfMonth)) {
                doanhThu = doanhThu.add(hd.getTongTien() != null ? hd.getTongTien() : BigDecimal.ZERO);
                tienDaThu = tienDaThu.add(hd.getDaTra() != null ? hd.getDaTra() : BigDecimal.ZERO);
            }
        }
        
        BigDecimal tienChuaThu = doanhThu.subtract(tienDaThu);

        long totalRooms = phongRepository.count();
        long activeRooms = phongRepository.findAll().stream()
                .filter(p -> p.getTrangThai() == TrangThaiPhong.RENTED).count();
        
        Double tyLeLapDay = totalRooms > 0 ? (double) activeRooms / totalRooms * 100 : 0.0;

        long suCoCanXuLy = suCoRepository.findAll().stream()
                .filter(s -> s.getTrangThai() == TrangThaiSuCo.PENDING || s.getTrangThai() == TrangThaiSuCo.IN_PROGRESS).count();

        LocalDate in30Days = LocalDate.now().plusDays(30);
        long hopDongSapHetHan = hopDongRepository.findAll().stream()
                .filter(h -> h.getNgayKetThuc() != null && !h.getNgayKetThuc().isBefore(LocalDate.now()) && !h.getNgayKetThuc().isAfter(in30Days)).count();

        // Chart data for last 6 months
        List<BaoCaoTongQuanResponse.BieuDoDoanhThu> chartData = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/yyyy");
        for (int i = 5; i >= 0; i--) {
            LocalDate monthStart = LocalDate.now().minusMonths(i).withDayOfMonth(1);
            LocalDate monthEnd = monthStart.plusMonths(1).minusDays(1);
            
            BigDecimal mDoanhThu = BigDecimal.ZERO;
            BigDecimal mDaThu = BigDecimal.ZERO;
            
            for (var hd : hoaDons) {
                LocalDate hdDate = hd.getTaoLuc() != null ? hd.getTaoLuc().toLocalDate() : null;
                if (hdDate != null && !hdDate.isBefore(monthStart) && !hdDate.isAfter(monthEnd)) {
                    mDoanhThu = mDoanhThu.add(hd.getTongTien() != null ? hd.getTongTien() : BigDecimal.ZERO);
                    mDaThu = mDaThu.add(hd.getDaTra() != null ? hd.getDaTra() : BigDecimal.ZERO);
                }
            }
            
            chartData.add(BaoCaoTongQuanResponse.BieuDoDoanhThu.builder()
                    .thang(monthStart.format(formatter))
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
