package com.example.quanlyphongtro.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@Builder
public class KhachThueDashboardResponse {
    private TenantProfile khachThue;
    private TenantContract hopDongHienTai;
    private long soHoaDonChuaThanhToan;
    private long soSuCoDangMo;
    private long soThongBaoMoi;
    private TenantInvoice hoaDonGanNhat;
    private LienHeNhaTro lienHe;

    @Data
    @Builder
    public static class LienHeNhaTro {
        private String hoTen;
        private String soDienThoai;
        private String email;
    }

    @Data
    @Builder
    public static class TenantProfile {
        private String hoTen;
        private String trangThai;
    }

    @Data
    @Builder
    public static class TenantBuilding {
        private String tenToaNha;
        private TenantAddress diaChi;
    }

    @Data
    @Builder
    public static class TenantAddress {
        private String duong;
        private String phuong;
    }

    @Data
    @Builder
    public static class TenantRoom {
        private String maPhong;
        private BigDecimal giaThue;
        private TenantBuilding toaNha;
    }

    @Data
    @Builder
    public static class TenantContract {
        private String maHopDong;
        private LocalDate ngayBatDau;
        private LocalDate ngayKetThuc;
        private BigDecimal tienCoc;
        private TenantRoom phong;
    }

    @Data
    @Builder
    public static class TenantInvoice {
        private String maHoaDon;
        private int thang;
        private int nam;
        private BigDecimal tongTien;
        private String trangThai;
    }
}
