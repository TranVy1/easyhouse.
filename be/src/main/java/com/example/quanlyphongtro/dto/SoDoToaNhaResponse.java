package com.example.quanlyphongtro.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SoDoToaNhaResponse {
    @JsonProperty("_id")
    private UUID id;
    private String tenToaNha;
    private Integer tongSoTang;
    private Integer tongSoPhong;
    private Integer phongTrong;
    private Integer phongDangThue;
    private Integer phongBaoTri;
    private Integer hopDongSapHetHan;
    private BigDecimal doanhThuDuKienThang;
    @Builder.Default
    private List<TangSoDo> tang = new ArrayList<>();

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TangSoDo {
        private Integer soTang;
        private String tenTang;
        @Builder.Default
        private List<PhongSoDo> phong = new ArrayList<>();
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PhongSoDo {
        @JsonProperty("_id")
        private UUID id;
        private String maPhong;
        private BigDecimal dienTich;
        private BigDecimal giaHienTai;
        private String trangThaiVatLy;
        private String trangThaiHienThi;
        private UUID hopDongId;
        private String maHopDong;
        private LocalDate ngayBatDau;
        private LocalDate ngayKetThuc;
        private UUID khachThueId;
        private String khachThueHienTai;
    }
}
