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
    private LocalDate tuNgay;
    private LocalDate denNgay;
    private BigDecimal soDuDauKy;
    private BigDecimal tongTienPhatSinh;
    private BigDecimal tongTien;
    private BigDecimal daTra;
    private BigDecimal soDuCuoiKy;
    private String trangThai;
    private LocalDate hanTra;
    private String ghiChu;
    private Integer chiSoDienBanDau;
    private Integer chiSoDienCuoiKy;
    private Integer chiSoNuocBanDau;
    private Integer chiSoNuocCuoiKy;
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
                if (ct.getLoai() == LoaiMucHoaDon.ELECTRICITY && ct.getMoTa() != null) {
                    int[] readings = parseReadingRange(ct.getMoTa());
                    chiSoDienBanDau = readings[0];
                    chiSoDienCuoiKy = readings[1];
                }
                if (ct.getLoai() == LoaiMucHoaDon.WATER && ct.getMoTa() != null) {
                    int[] readings = parseReadingRange(ct.getMoTa());
                    chiSoNuocBanDau = readings[0];
                    chiSoNuocCuoiKy = readings[1];
                }
            }
        }

        return HoaDonResponse.builder()
                .id(hd.getId())
                .maHoaDon(hd.getMaHoaDon())
                .hopDong(hdObj)
                .phong(phongObj)
                .khachThue(ktObj)
                .kyNam(hd.getKyNam())
                .kyThang(hd.getKyThang())
                .tuNgay(hd.getTuNgay())
                .denNgay(hd.getDenNgay())
                .soDuDauKy(hd.getSoDuDauKy())
                .tongTienPhatSinh(hd.getTongTienPhatSinh())
                .tongTien(hd.getTongTien())
                .daTra(hd.getDaTra())
                .soDuCuoiKy(hd.getSoDuCuoiKy())
                .trangThai(hd.getTrangThai() != null ? hd.getTrangThai().name() : null)
                .hanTra(hd.getHanTra())
                .ghiChu(hd.getGhiChu())
                .chiSoDienBanDau(chiSoDienBanDau)
                .chiSoDienCuoiKy(chiSoDienCuoiKy)
                .chiSoNuocBanDau(chiSoNuocBanDau)
                .chiSoNuocCuoiKy(chiSoNuocCuoiKy)
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
}
