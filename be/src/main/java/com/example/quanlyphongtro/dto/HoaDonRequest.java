package com.example.quanlyphongtro.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Data
public class HoaDonRequest {
    private String maHoaDon;
    private UUID hopDongId;
    private UUID hopDong;
    private UUID phongId;
    private UUID phong;
    private UUID khachThueId;
    private UUID khachThue;
    private Integer kyNam;
    private Integer nam;
    private Integer kyThang;
    private Integer thang;
    private LocalDate tuNgay;
    private LocalDate denNgay;
    private BigDecimal soDuDauKy;
    private LocalDate hanTra;
    private LocalDate hanThanhToan;
    private BigDecimal tienPhong;
    private BigDecimal tienDien;
    private BigDecimal tienNuoc;
    private Integer chiSoDienBanDau;
    private Integer chiSoDienCuoiKy;
    private Integer chiSoNuocBanDau;
    private Integer chiSoNuocCuoiKy;
    private BigDecimal daThanhToan;
    private String trangThai;
    private String ghiChu;
    private List<PhiDichVuItem> phiDichVu;

    // Chi tiết hóa đơn dạng line items
    private List<ChiTietItem> chiTietHoaDon;

    @Data
    public static class ChiTietItem {
        private UUID dichVuId;
        private UUID chiSoDienNuocId;
        private String loai;   // ROOM, ELECTRICITY, WATER, SERVICE, etc.
        private String moTa;
        private BigDecimal soLuong;
        private BigDecimal donGia;
        private BigDecimal thanhTien;
    }

    @Data
    public static class PhiDichVuItem {
        private UUID dichVuId;
        private String ten;
        private BigDecimal gia;
        private BigDecimal soLuong;
    }
}
