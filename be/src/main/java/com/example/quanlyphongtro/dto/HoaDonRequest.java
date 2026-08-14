package com.example.quanlyphongtro.dto;

import lombok.Data;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Data
public class HoaDonRequest {
    private String maHoaDon;
    private String loaiHoaDon;
    private UUID hopDongId;
    
    @NotNull(message = "Hợp đồng không được để trống")
    private UUID hopDong;
    
    private UUID phongId;
    private UUID phong;
    private UUID khachThueId;
    private UUID khachThue;
    
    @NotNull(message = "Kỳ năm không được để trống")
    private Integer kyNam;
    private Integer nam;
    
    @NotNull(message = "Kỳ tháng không được để trống")
    private Integer kyThang;
    private Integer thang;
    
    @NotNull(message = "Từ ngày không được để trống")
    private LocalDate tuNgay;
    
    @NotNull(message = "Đến ngày không được để trống")
    private LocalDate denNgay;
    
    private BigDecimal soDuDauKy;
    
    @NotNull(message = "Hạn trả không được để trống")
    private LocalDate hanTra;
    private LocalDate hanThanhToan;
    
    @Min(value = 0, message = "Tiền phòng không hợp lệ")
    private BigDecimal tienPhong;
    
    @Min(value = 0, message = "Tiền điện không hợp lệ")
    private BigDecimal tienDien;
    
    @Min(value = 0, message = "Tiền nước không hợp lệ")
    private BigDecimal tienNuoc;
    
    private Integer chiSoDienBanDau;
    private Integer chiSoDienCuoiKy;
    private Integer chiSoNuocBanDau;
    private Integer chiSoNuocCuoiKy;
    private Boolean resetCongTo = false;
    private Integer soKwhThucTe;
    private Integer soKhoiNuocThucTe;
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
