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
    private List<ChiTietItem> chiTietHoaDon;
    private ZonedDateTime ngayTao;
    private ZonedDateTime ngayCapNhat;

    @Data
    @Builder
    public static class ChiTietItem {
        private UUID id;
        private String loai;
        private String moTa;
        private BigDecimal soLuong;
        private BigDecimal donGia;
        private BigDecimal thanhTien;
    }

    public static HoaDonResponse fromEntity(HoaDon hd, List<ChiTietHoaDon> chiTietList) {
        if (hd == null) return null;

        Object phongObj = hd.getPhong() != null ? PhongResponse.fromEntity(hd.getPhong()) : null;
        Object ktObj = hd.getKhachThue() != null ? KhachThueResponse.fromEntity(hd.getKhachThue()) : null;
        Object hdObj = hd.getHopDong() != null ? hd.getHopDong().getId().toString() : null;

        List<ChiTietItem> items = new ArrayList<>();
        if (chiTietList != null) {
            for (ChiTietHoaDon ct : chiTietList) {
                items.add(ChiTietItem.builder()
                        .id(ct.getId())
                        .loai(ct.getLoai() != null ? ct.getLoai().name() : null)
                        .moTa(ct.getMoTa())
                        .soLuong(ct.getSoLuong())
                        .donGia(ct.getDonGia())
                        .thanhTien(ct.getThanhTien())
                        .build());
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
                .chiTietHoaDon(items)
                .ngayTao(hd.getTaoLuc())
                .ngayCapNhat(hd.getCapNhatLuc())
                .build();
    }
}
