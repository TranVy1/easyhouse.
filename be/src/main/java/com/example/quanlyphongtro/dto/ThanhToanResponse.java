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

    // Populate hoaDon as nested object (frontend expects hoaDon: HoaDon object)
    private Object hoaDon;

    private BigDecimal soTien;
    private String phuongThuc;
    private Map<String, String> thongTinChuyenKhoan;
    private ZonedDateTime ngayThanhToan;
    private String nguoiNhan;
    private String ghiChu;
    private String anhBienLai;
    private ZonedDateTime ngayTao;

    public static ThanhToanResponse fromEntity(ThanhToan tt, List<ChiTietHoaDon> chiTietList) {
        // Map phương thức thanh toán DB → frontend
        String phuongThuc = "tienMat";
        if (tt.getPhuongThuc() != null) {
            switch (tt.getPhuongThuc()) {
                case "CASH": case "tienMat": phuongThuc = "tienMat"; break;
                case "TRANSFER": case "chuyenKhoan": phuongThuc = "chuyenKhoan"; break;
                case "EWALLET": case "viDienTu": phuongThuc = "viDienTu"; break;
                default: phuongThuc = tt.getPhuongThuc(); break;
            }
        }

        // Thông tin chuyển khoản
        Map<String, String> thongTinCK = null;
        if ("chuyenKhoan".equals(phuongThuc) && tt.getMaThamChieu() != null) {
            thongTinCK = new HashMap<>();
            thongTinCK.put("soGiaoDich", tt.getMaThamChieu());
            thongTinCK.put("nganHang", tt.getMaThamChieu()); // Tạm dùng maThamChieu
        }

        // Populate hoaDon nếu có
        Object hoaDonObj = null;
        if (tt.getHoaDon() != null) {
            hoaDonObj = HoaDonResponse.fromEntity(tt.getHoaDon(), chiTietList);
        }

        return ThanhToanResponse.builder()
                .id(tt.getId())
                .hoaDon(hoaDonObj)
                .soTien(tt.getSoTien())
                .phuongThuc(phuongThuc)
                .thongTinChuyenKhoan(thongTinCK)
                .ngayThanhToan(tt.getNgayThanhToan())
                .nguoiNhan(null)
                .ghiChu(tt.getGhiChu())
                .anhBienLai(null) // TODO: implement khi có upload
                .ngayTao(tt.getTaoLuc())
                .build();
    }
}
