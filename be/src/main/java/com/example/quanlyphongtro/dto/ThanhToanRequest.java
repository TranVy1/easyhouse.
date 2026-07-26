package com.example.quanlyphongtro.dto;

import lombok.Data;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.UUID;

@Data
public class ThanhToanRequest {
    @NotNull(message = "Hóa đơn là bắt buộc khi ghi nhận thanh toán")
    private UUID hoaDonId;
    
    @NotNull(message = "Số tiền thanh toán là bắt buộc")
    @DecimalMin(value = "0.01", message = "Số tiền thanh toán phải lớn hơn 0")
    private BigDecimal soTien;
    
    private String phuongThuc; // tienMat, chuyenKhoan, viDienTu
    private ThongTinChuyenKhoan thongTinChuyenKhoan;
    private String ngayThanhToan;
    private String ghiChu;
    private String anhBienLai;
    private String trangThai;
    private String idempotencyKey;

    @Data
    public static class ThongTinChuyenKhoan {
        private String nganHang;
        private String soGiaoDich;
    }
}
