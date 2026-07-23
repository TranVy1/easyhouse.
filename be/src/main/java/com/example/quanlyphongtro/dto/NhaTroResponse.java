package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.NhaTro;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NhaTroResponse {
    @JsonProperty("_id")
    private UUID id;
    private String tenToaNha;
    private DiaChiResponse diaChi;
    private String moTa;
    private List<String> tienNghiChung;
    private String noiQuy;
    private String trangThai;
    private String tenDaiDienBenA;
    private Integer soXeMienPhi;
    private int tongSoPhong;
    private int phongTrong;
    private int phongDangThue;
    
    private List<DichVuToaNhaResponse> dichVuList;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DichVuToaNhaResponse {
        private String id;
        private String ten;
        private Boolean suDung;
        private java.math.BigDecimal donGia;
        private String donVi;
        private String loaiTinhPhi;
        private Boolean batBuoc;
        private Boolean isCustom;
    }

    @JsonProperty("ngayTao")
    private LocalDateTime taoLuc;
    @JsonProperty("ngayCapNhat")
    private LocalDateTime capNhatLuc;

    @Data @Builder @NoArgsConstructor @AllArgsConstructor
    public static class DiaChiResponse {
        private String soNha;
        private String duong;
        private String phuong;
        private String quan;
        private String thanhPho;
    }

    public static NhaTroResponse fromEntity(NhaTro nt, int tongSoPhong, int phongTrong, int phongDangThue) {
        LocalDateTime tl = nt.getTaoLuc() != null ? nt.getTaoLuc().toLocalDateTime() : null;
        LocalDateTime cl = nt.getCapNhatLuc() != null ? nt.getCapNhatLuc().toLocalDateTime() : null;
        return NhaTroResponse.builder()
                .id(nt.getId()).tenToaNha(nt.getTen())
                .diaChi(DiaChiResponse.builder()
                        .soNha(nt.getSoNha() != null ? nt.getSoNha() : "")
                        .duong(nt.getDuong() != null ? nt.getDuong() : "")
                        .phuong(nt.getPhuong() != null ? nt.getPhuong() : "")
                        .quan(nt.getQuan() != null ? nt.getQuan() : "")
                        .thanhPho(nt.getThanhPho() != null ? nt.getThanhPho() : "")
                        .build())
                .moTa(nt.getMoTa())
                .tienNghiChung(nt.getTienNghiChung() != null && !nt.getTienNghiChung().isEmpty() 
                        ? java.util.Arrays.asList(nt.getTienNghiChung().split(",")) 
                        : java.util.Collections.emptyList())
                .noiQuy(nt.getNoiQuy())
                .trangThai(nt.getTrangThai())
                .tenDaiDienBenA(nt.getTenDaiDienBenA())
                .soXeMienPhi(nt.getSoXeMienPhi())
                .tongSoPhong(tongSoPhong).phongTrong(phongTrong).phongDangThue(phongDangThue)
                .taoLuc(tl).capNhatLuc(cl).build();
    }
}
