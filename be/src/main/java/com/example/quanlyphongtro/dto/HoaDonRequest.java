package com.example.quanlyphongtro.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;

@Data
public class HoaDonRequest {
    private String maHoaDon;
    private UUID hopDong;    // hopDong ID
    private UUID phong;      // phong ID
    private UUID khachThue;  // khachThue ID
    private Integer thang;
    private Integer nam;
    private BigDecimal tienPhong;
    private BigDecimal tienDien;
    private Integer soDien;
    private Integer chiSoDienBanDau;
    private Integer chiSoDienCuoiKy;
    private BigDecimal tienNuoc;
    private Integer soNuoc;
    private Integer chiSoNuocBanDau;
    private Integer chiSoNuocCuoiKy;
    private List<PhiDichVuItem> phiDichVu;
    private BigDecimal tongTien;
    private BigDecimal daThanhToan;
    private BigDecimal conLai;
    private String trangThai; // chuaThanhToan, daThanhToanMotPhan, daThanhToan, quaHan
    private LocalDate hanThanhToan;
    private LocalDate ngayPhatHanh;
    private ZonedDateTime ngayGui;
    private Boolean daGui;
    private BigDecimal tienGiam;
    private BigDecimal phiPhatSinh;
    private String ghiChu;

    @Data
    public static class PhiDichVuItem {
        private String ten;
        private BigDecimal gia;
    }
}
