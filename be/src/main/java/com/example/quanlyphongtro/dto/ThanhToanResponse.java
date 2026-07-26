package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.ThanhToan;
import com.example.quanlyphongtro.entity.ChiTietHoaDon;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.*;

@Data
@Builder
public class ThanhToanResponse {
    @JsonProperty("_id")
    private UUID id;
    private Object hoaDon;
    private BigDecimal soTien;
    private String phuongThucThanhToan;
    private String maThamChieu;
    private String trangThai;
    private ZonedDateTime ngayThanhToan;
    private String ghiChu;
    private String anhBienLai;
    private ZonedDateTime ngayTao;

    public static ThanhToanResponse fromEntity(ThanhToan tt, List<ChiTietHoaDon> chiTietList) {
        Object hoaDonObj = tt.getHoaDon() != null ? HoaDonResponse.fromEntity(tt.getHoaDon(), chiTietList) : null;
        return ThanhToanResponse.builder()
                .id(tt.getId()).hoaDon(hoaDonObj)
                .soTien(tt.getSoTien())
                .phuongThucThanhToan(tt.getPhuongThucThanhToan() != null ? tt.getPhuongThucThanhToan().name() : null)
                .maThamChieu(tt.getMaThamChieu())
                .trangThai(tt.getTrangThai() != null ? tt.getTrangThai().name() : null)
                .ngayThanhToan(tt.getNgayThanhToan())
                .ghiChu(tt.getGhiChu())
                .anhBienLai("")
                .ngayTao(tt.getTaoLuc()).build();
    }
}
