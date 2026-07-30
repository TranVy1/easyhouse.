package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.*;
import com.fasterxml.jackson.annotation.JsonProperty;
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
    private Object hopDong;
    private Object phong;
    private Object khachThue;
    private Integer kyNam;
    private Integer kyThang;
    private Integer nam;
    private Integer thang;
    private LocalDate tuNgay;
    private LocalDate denNgay;
    private BigDecimal soDuDauKy;
    private BigDecimal tongTienPhatSinh;
    private BigDecimal tongTien;
    private BigDecimal daTra;
    private BigDecimal daThanhToan;
    private BigDecimal soDuCuoiKy;
    private BigDecimal conLai;
    private BigDecimal soDuCo;
    private String trangThai;
    private LocalDate hanTra;
    private LocalDate hanThanhToan;
    private String ghiChu;
    private BigDecimal tienPhong;
    private BigDecimal tienDien;
    private BigDecimal soDien;
    private Integer chiSoDienBanDau;
    private Integer chiSoDienCuoiKy;
    private BigDecimal tienNuoc;
    private BigDecimal soNuoc;
    private Integer chiSoNuocBanDau;
    private Integer chiSoNuocCuoiKy;
    private List<ChiTietItem> chiTiet;
    private List<ChiTietItem> chiTietHoaDon;
    private List<PhiDichVuItem> phiDichVu;
    private ZonedDateTime ngayTao;
    private ZonedDateTime ngayCapNhat;

    @Data
    @Builder
    public static class ChiTietItem {
        private UUID id;
        private UUID dichVuId;
        private UUID chiSoDienNuocId;
        private String loai;
        private String moTa;
        private BigDecimal soLuong;
        private BigDecimal donGia;
        private BigDecimal thanhTien;
    }

    @Data
    @Builder
    public static class PhiDichVuItem {
        private UUID dichVuId;
        private String ten;
        private BigDecimal gia;
        private BigDecimal soLuong;
    }

    public static HoaDonResponse fromEntity(HoaDon hd, List<ChiTietHoaDon> chiTietList) {
        if (hd == null) return null;

        Object phongObj = hd.getPhong() != null ? PhongResponse.fromEntity(hd.getPhong()) : null;
        Object ktObj = hd.getKhachThue() != null ? KhachThueResponse.fromEntity(hd.getKhachThue()) : null;
        Object hdObj = hd.getHopDong() != null ? hd.getHopDong().getId().toString() : null;

        List<ChiTietItem> items = new ArrayList<>();
        List<PhiDichVuItem> phiDichVu = new ArrayList<>();
        Integer chiSoDienBanDau = null;
        Integer chiSoDienCuoiKy = null;
        Integer chiSoNuocBanDau = null;
        Integer chiSoNuocCuoiKy = null;
        BigDecimal tienPhong = BigDecimal.ZERO;
        BigDecimal tienDien = BigDecimal.ZERO;
        BigDecimal soDien = BigDecimal.ZERO;
        BigDecimal tienNuoc = BigDecimal.ZERO;
        BigDecimal soNuoc = BigDecimal.ZERO;
        if (chiTietList != null) {
            for (ChiTietHoaDon ct : chiTietList) {
                items.add(ChiTietItem.builder()
                        .id(ct.getId())
                        .dichVuId(ct.getDichVuId())
                        .chiSoDienNuocId(ct.getChiSoDienNuocId())
                        .loai(ct.getLoai() != null ? ct.getLoai().name() : null)
                        .moTa(ct.getMoTa())
                        .soLuong(ct.getSoLuong())
                        .donGia(ct.getDonGia())
                        .thanhTien(ct.getThanhTien())
                        .build());
                if (ct.getLoai() == LoaiMucHoaDon.SERVICE) {
                    phiDichVu.add(PhiDichVuItem.builder()
                            .dichVuId(ct.getDichVuId())
                            .ten(ct.getMoTa())
                            .gia(ct.getDonGia())
                            .soLuong(ct.getSoLuong())
                            .build());
                }
                if (ct.getLoai() == LoaiMucHoaDon.ROOM) {
                    tienPhong = defaultMoney(ct.getThanhTien());
                }
                if (ct.getLoai() == LoaiMucHoaDon.ELECTRICITY && ct.getMoTa() != null) {
                    tienDien = defaultMoney(ct.getThanhTien());
                    soDien = defaultMoney(ct.getSoLuong());
                    int[] readings = parseReadingRange(ct.getMoTa());
                    chiSoDienBanDau = readings[0];
                    chiSoDienCuoiKy = readings[1];
                }
                if (ct.getLoai() == LoaiMucHoaDon.WATER && ct.getMoTa() != null) {
                    tienNuoc = defaultMoney(ct.getThanhTien());
                    soNuoc = defaultMoney(ct.getSoLuong());
                    int[] readings = parseReadingRange(ct.getMoTa());
                    chiSoNuocBanDau = readings[0];
                    chiSoNuocCuoiKy = readings[1];
                }
            }
        }
        BigDecimal tongTien = defaultMoney(hd.getTongTien());
        BigDecimal daTra = defaultMoney(hd.getDaTra());
        BigDecimal rawBalance = hd.getSoDuCuoiKy() != null ? hd.getSoDuCuoiKy() : tongTien.subtract(daTra);
        BigDecimal conLai = rawBalance.max(BigDecimal.ZERO);
        BigDecimal soDuCo = rawBalance.compareTo(BigDecimal.ZERO) < 0 ? rawBalance.abs() : BigDecimal.ZERO;

        return HoaDonResponse.builder()
                .id(hd.getId())
                .maHoaDon(hd.getMaHoaDon())
                .hopDong(hdObj)
                .phong(phongObj)
                .khachThue(ktObj)
                .kyNam(hd.getKyNam())
                .kyThang(hd.getKyThang())
                .nam(hd.getKyNam())
                .thang(hd.getKyThang())
                .tuNgay(hd.getTuNgay())
                .denNgay(hd.getDenNgay())
                .soDuDauKy(hd.getSoDuDauKy())
                .tongTienPhatSinh(hd.getTongTienPhatSinh())
                .tongTien(tongTien)
                .daTra(daTra)
                .daThanhToan(daTra)
                .soDuCuoiKy(hd.getSoDuCuoiKy())
                .conLai(conLai)
                .soDuCo(soDuCo)
                .trangThai(hd.getTrangThai() != null ? hd.getTrangThai().name() : null)
                .hanTra(hd.getHanTra())
                .hanThanhToan(hd.getHanTra())
                .ghiChu(hd.getGhiChu())
                .tienPhong(tienPhong)
                .tienDien(tienDien)
                .soDien(soDien)
                .chiSoDienBanDau(chiSoDienBanDau)
                .chiSoDienCuoiKy(chiSoDienCuoiKy)
                .tienNuoc(tienNuoc)
                .soNuoc(soNuoc)
                .chiSoNuocBanDau(chiSoNuocBanDau)
                .chiSoNuocCuoiKy(chiSoNuocCuoiKy)
                .chiTiet(items)
                .chiTietHoaDon(items)
                .phiDichVu(phiDichVu)
                .ngayTao(hd.getTaoLuc())
                .ngayCapNhat(hd.getCapNhatLuc())
                .build();
    }

    private static int[] parseReadingRange(String value) {
        try {
            String[] parts = value.replaceAll("[^0-9-]", "").split("-");
            if (parts.length >= 2) {
                return new int[]{Integer.parseInt(parts[0]), Integer.parseInt(parts[1])};
            }
        } catch (Exception ignored) {
        }
        return new int[]{0, 0};
    }

    private static BigDecimal defaultMoney(BigDecimal value) {
        return value != null ? value : BigDecimal.ZERO;
    }
}
