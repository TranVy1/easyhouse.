package com.example.quanlyphongtro.dto;

import lombok.Data;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Data
public class HopDongRequest {
    private String maHopDong;
    private UUID phong; // ID của phòng
    private List<UUID> khachThueId;
    private UUID nguoiDaiDien;
    private LocalDate ngayBatDau;
    private LocalDate ngayKetThuc;
    private BigDecimal giaThue;
    private BigDecimal tienCoc;
    private String chuKyThanhToan;
    private Integer ngayThanhToan;
    private String dieuKhoan;
    private BigDecimal giaDien;
    private BigDecimal giaNuoc;
    private Integer chiSoDienBanDau;
    private Integer chiSoNuocBanDau;
    private List<PhiDichVuRequest> phiDichVu;
    private String trangThai;

    @Data
    public static class PhiDichVuRequest {
        private String ten;
        private BigDecimal gia;
    }
}
