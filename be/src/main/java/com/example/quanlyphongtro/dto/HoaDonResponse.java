package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.*;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.*;

@Data
@Builder
public class HoaDonResponse {

    @JsonProperty("_id")
    private UUID id;
    private String maHoaDon;
    private Object hopDong;    // ID or nested object
    private Object phong;      // ID or nested PhongResponse
    private Object khachThue;  // ID or nested KhachThueResponse
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
    private List<Map<String, Object>> phiDichVu;
    private BigDecimal tongTien;
    private BigDecimal daThanhToan;
    private BigDecimal conLai;
    private String trangThai;
    private LocalDate hanThanhToan;
    private LocalDate ngayPhatHanh;
    private ZonedDateTime ngayGui;
    private Boolean daGui;
    private BigDecimal tienGiam;
    private BigDecimal phiPhatSinh;
    private String ghiChu;
    private ZonedDateTime ngayTao;
    private ZonedDateTime ngayCapNhat;

    public static HoaDonResponse fromEntity(HoaDon hoaDon, List<ChiTietHoaDon> chiTietList) {
        if (hoaDon == null) return null;

        // Map trạng thái DB → frontend
        String statusFrontend = "chuaThanhToan";
        if (hoaDon.getTrangThai() != null) {
            switch (hoaDon.getTrangThai()) {
                case UNPAID: statusFrontend = "chuaThanhToan"; break;
                case PARTIAL: statusFrontend = "daThanhToanMotPhan"; break;
                case PAID: statusFrontend = "daThanhToan"; break;
                case OVERDUE: statusFrontend = "quaHan"; break;
            }
        }

        // Tính thang/nam từ thangHoaDon
        int thang = hoaDon.getThangHoaDon() != null ? hoaDon.getThangHoaDon().getMonthValue() : 0;
        int nam = hoaDon.getThangHoaDon() != null ? hoaDon.getThangHoaDon().getYear() : 0;

        // Parse chi tiết hóa đơn thành các mục
        BigDecimal tienPhong = BigDecimal.ZERO;
        BigDecimal tienDien = BigDecimal.ZERO;
        BigDecimal tienNuoc = BigDecimal.ZERO;
        int soDien = 0, soNuoc = 0;
        int chiSoDienBanDau = 0, chiSoDienCuoiKy = 0;
        int chiSoNuocBanDau = 0, chiSoNuocCuoiKy = 0;
        List<Map<String, Object>> phiDichVuList = new ArrayList<>();
        String maHoaDon = "";

        if (chiTietList != null) {
            for (ChiTietHoaDon ct : chiTietList) {
                switch (ct.getLoai()) {
                    case ROOM:
                        tienPhong = ct.getThanhTien();
                        break;
                    case ELECTRICITY:
                        tienDien = ct.getThanhTien();
                        soDien = ct.getSoLuong() != null ? ct.getSoLuong().intValue() : 0;
                        // Lấy chi số từ mô tả (format: "chiSoBanDau-chiSoCuoiKy")
                        if (ct.getMoTa() != null && ct.getMoTa().contains("-")) {
                            try {
                                String[] parts = ct.getMoTa().split("-");
                                chiSoDienBanDau = Integer.parseInt(parts[0].trim());
                                chiSoDienCuoiKy = Integer.parseInt(parts[1].trim());
                            } catch (NumberFormatException e) {
                                // ignore
                            }
                        }
                        break;
                    case WATER:
                        tienNuoc = ct.getThanhTien();
                        soNuoc = ct.getSoLuong() != null ? ct.getSoLuong().intValue() : 0;
                        if (ct.getMoTa() != null && ct.getMoTa().contains("-")) {
                            try {
                                String[] parts = ct.getMoTa().split("-");
                                chiSoNuocBanDau = Integer.parseInt(parts[0].trim());
                                chiSoNuocCuoiKy = Integer.parseInt(parts[1].trim());
                            } catch (NumberFormatException e) {
                                // ignore
                            }
                        }
                        break;
                    case SERVICE:
                    case INTERNET:
                    case GARBAGE:
                    case PARKING:
                    case OTHER:
                        Map<String, Object> phi = new HashMap<>();
                        phi.put("ten", ct.getMoTa() != null ? ct.getMoTa() : "Dịch vụ");
                        phi.put("gia", ct.getThanhTien());
                        phiDichVuList.add(phi);
                        break;
                }
            }
        }

        BigDecimal daTra = hoaDon.getDaTra() != null ? hoaDon.getDaTra() : BigDecimal.ZERO;
        BigDecimal tongTien = hoaDon.getTongTien() != null ? hoaDon.getTongTien() : BigDecimal.ZERO;
        BigDecimal conLai = tongTien.subtract(daTra);

        maHoaDon = hoaDon.getMaHoaDon();
        if (maHoaDon == null || maHoaDon.isBlank()) {
            maHoaDon = "HD" + String.format("%04d%02d", nam, thang)
                    + hoaDon.getId().toString().substring(0, 3).toUpperCase();
        }

        // Phong response
        Object phongObj = hoaDon.getPhong() != null ? PhongResponse.fromEntity(hoaDon.getPhong()) : null;
        
        // Khach thue response
        Object khachThueObj = hoaDon.getKhachThue() != null ? KhachThueResponse.fromEntity(hoaDon.getKhachThue()) : null;

        // HopDong ID
        Object hopDongObj = hoaDon.getHopDong() != null ? hoaDon.getHopDong().getId().toString() : null;

        return HoaDonResponse.builder()
                .id(hoaDon.getId())
                .maHoaDon(maHoaDon)
                .hopDong(hopDongObj)
                .phong(phongObj)
                .khachThue(khachThueObj)
                .thang(thang)
                .nam(nam)
                .tienPhong(tienPhong)
                .tienDien(tienDien)
                .soDien(soDien)
                .chiSoDienBanDau(chiSoDienBanDau)
                .chiSoDienCuoiKy(chiSoDienCuoiKy)
                .tienNuoc(tienNuoc)
                .soNuoc(soNuoc)
                .chiSoNuocBanDau(chiSoNuocBanDau)
                .chiSoNuocCuoiKy(chiSoNuocCuoiKy)
                .phiDichVu(phiDichVuList)
                .tongTien(tongTien)
                .daThanhToan(daTra)
                .conLai(conLai)
                .trangThai(statusFrontend)
                .hanThanhToan(hoaDon.getHanTra())
                .ngayPhatHanh(hoaDon.getNgayPhatHanh())
                .ngayGui(hoaDon.getNgayGui())
                .daGui(hoaDon.getDaGui())
                .tienGiam(hoaDon.getTienGiam())
                .phiPhatSinh(hoaDon.getPhiPhatSinh())
                .ghiChu(hoaDon.getGhiChu())
                .ngayTao(hoaDon.getTaoLuc())
                .ngayCapNhat(hoaDon.getCapNhatLuc())
                .build();
    }
}
