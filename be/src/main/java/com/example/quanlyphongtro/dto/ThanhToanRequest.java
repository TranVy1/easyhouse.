package com.example.quanlyphongtro.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.util.UUID;

@Data
public class ThanhToanRequest {
    private UUID hoaDonId;
    private BigDecimal soTien;
    private String phuongThuc; // tienMat, chuyenKhoan, viDienTu
    private ThongTinChuyenKhoan thongTinChuyenKhoan;
    private String ngayThanhToan;
    private String ghiChu;
    private String anhBienLai;

    @Data
    public static class ThongTinChuyenKhoan {
        private String nganHang;
        private String soGiaoDich;
    }
}
