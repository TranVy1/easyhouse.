package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.KhachThue;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class KhachThueResponse {

    @JsonProperty("_id")
    private UUID id;

    private String hoTen;
    private String soDienThoai;
    private String email;
    private String gioiTinh;
    private String soCccd;
    private LocalDate ngaySinh;
    private String diaChi;
    private String queQuan;
    private String ngheNghiep;
    private String ghiChu;
    private AnhCCCDResponse anhCCCD;
    private Boolean dangHoatDong;

    @JsonProperty("hopDongHienTai")
    private CurrentContractResponse hopDongHienTai;

    @Data
    @Builder
    public static class CurrentContractResponse {
        @JsonProperty("_id")
        private UUID id;
        private PhongInfo phong;
    }

    @Data
    @Builder
    public static class PhongInfo {
        @JsonProperty("_id")
        private UUID id;
        private String maPhong;
        private Integer tang;
        private ToaNhaInfo toaNha;
    }

    @Data
    @Builder
    public static class ToaNhaInfo {
        @JsonProperty("_id")
        private UUID id;
        private String tenToaNha;
    }

    @Data
    @Builder
    public static class AnhCCCDResponse {
        private String matTruoc;
        private String matSau;
    }

    private String trangThai;

    @JsonProperty("ngayTao")
    private LocalDateTime taoLuc;

    @JsonProperty("ngayCapNhat")
    private LocalDateTime capNhatLuc;

    public static KhachThueResponse fromEntity(KhachThue kt) {
        if (kt == null) return null;

        LocalDateTime taoLucLocal = kt.getTaoLuc() != null ? kt.getTaoLuc().toLocalDateTime() : null;
        LocalDateTime capNhatLucLocal = kt.getCapNhatLuc() != null ? kt.getCapNhatLuc().toLocalDateTime() : null;

        return KhachThueResponse.builder()
                .id(kt.getId())
                .hoTen(kt.getHoTen())
                .soDienThoai(kt.getSoDienThoai())
                .email(kt.getEmail())
                .gioiTinh(kt.getGioiTinh())
                .soCccd(kt.getSoCccd())
                .ngaySinh(kt.getNgaySinh())
                .diaChi(kt.getDiaChi())
                .queQuan(kt.getQueQuan())
                .ngheNghiep(kt.getNgheNghiep())
                .ghiChu(kt.getGhiChu())
                .anhCCCD(AnhCCCDResponse.builder().matTruoc("").matSau("").build())
                .dangHoatDong(kt.getDangHoatDong())
                .trangThai(Boolean.TRUE.equals(kt.getDangHoatDong()) ? "dangThue" : "chuaThue")
                .taoLuc(taoLucLocal)
                .capNhatLuc(capNhatLucLocal)
                .build();
    }
}
