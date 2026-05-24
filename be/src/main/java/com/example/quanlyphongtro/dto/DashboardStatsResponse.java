package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DashboardStatsResponse {
    private long tongSoPhong;
    private long phongTrong;
    private long phongDangThue;
    private long phongBaoTri;
    private BigDecimal doanhThuThang;
    private BigDecimal doanhThuNam;
    private long hoaDonSapDenHan;
    private long suCoCanXuLy;
    private long hopDongSapHetHan;
    private long tongKhachDangThue;
    private BigDecimal tienDaThu;
    private BigDecimal tienChuaThu;
}
