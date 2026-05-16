package com.example.quanlyphongtro.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.NguoiDung;
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

    // Thông tin từ NguoiDung
    private String hoTen;
    private String soDienThoai;
    private String email;
    private String gioiTinh;
    private String anhDaiDien;

    // Thông tin từ KhachThue
    @JsonProperty("cccd")
    private String soCccd;
    private String lienHeKhanCap;
    private LocalDate ngaySinh;
    @JsonProperty("queQuan")
    private String diaChiThuongTru;
    private String ngheNghiep;
    private AnhCCCDResponse anhCCCD;

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

    // Trạng thái (tính toán từ hợp đồng)
    private String trangThai;

    @JsonProperty("ngayTao")
    private LocalDateTime taoLuc;

    @JsonProperty("ngayCapNhat")
    private LocalDateTime capNhatLuc;

    public static KhachThueResponse fromEntity(KhachThue khachThue) {
        NguoiDung nguoiDung = khachThue.getNguoiDung();

        LocalDateTime taoLucLocal = khachThue.getTaoLuc() != null
                ? khachThue.getTaoLuc().toLocalDateTime()
                : null;
        LocalDateTime capNhatLucLocal = khachThue.getCapNhatLuc() != null
                ? khachThue.getCapNhatLuc().toLocalDateTime()
                : null;

        return KhachThueResponse.builder()
                .id(khachThue.getId())
                // Từ NguoiDung
                .hoTen(nguoiDung != null ? nguoiDung.getHoTen() : null)
                .soDienThoai(nguoiDung != null ? nguoiDung.getSoDienThoai() : null)
                .email(nguoiDung != null ? nguoiDung.getEmail() : null)
                .gioiTinh(nguoiDung != null ? nguoiDung.getGioiTinh() : null)
                .anhDaiDien(nguoiDung != null ? nguoiDung.getAnhDaiDien() : null)
                // Từ KhachThue
                .soCccd(khachThue.getSoCccd())
                .lienHeKhanCap(khachThue.getLienHeKhanCap())
                .ngaySinh(khachThue.getNgaySinh())
                .diaChiThuongTru(khachThue.getDiaChiThuongTru())
                .ngheNghiep(khachThue.getNgheNghiep())
                .anhCCCD(AnhCCCDResponse.builder()
                        .matTruoc(khachThue.getAnhCccdTruoc())
                        .matSau(khachThue.getAnhCccdSau())
                        .build())
                // TODO: Tính trangThai từ hợp đồng
                .trangThai("chuaThue")
                .taoLuc(taoLucLocal)
                .capNhatLuc(capNhatLucLocal)
                .build();
    }
}