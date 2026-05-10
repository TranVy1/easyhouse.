package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.DashboardStatsResponse;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import com.example.quanlyphongtro.repository.PhongRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
public class DashboardService {

    private final PhongRepository phongRepository;

    public DashboardStatsResponse getStats() {
        long tongSoPhong = phongRepository.count();
        long phongTrong = phongRepository.countByTrangThai(TrangThaiPhong.AVAILABLE);
        long phongDangThue = phongRepository.countByTrangThai(TrangThaiPhong.RENTED);
        long phongBaoTri = phongRepository.countByTrangThai(TrangThaiPhong.MAINTENANCE);

        // TODO: Tính toán từ bảng hóa đơn, hợp đồng, sự cố khi có entity tương ứng
        // Hiện tại trả về giá trị mặc định
        BigDecimal doanhThuThang = BigDecimal.ZERO;
        BigDecimal doanhThuNam = BigDecimal.ZERO;
        long hoaDonSapDenHan = 0;
        long suCoCanXuLy = 0;
        long hopDongSapHetHan = 0;

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
                .build();
    }
}
