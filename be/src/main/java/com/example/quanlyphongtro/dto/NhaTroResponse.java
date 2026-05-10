package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.example.quanlyphongtro.entity.NhaTro;
import java.util.UUID;
import java.util.List;
import java.time.ZonedDateTime;
import java.time.LocalDateTime;

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

    private int tongSoPhong;

    private int phongTrong;

    private int phongDangThue;

    @JsonProperty("ngayTao")
    private LocalDateTime taoLuc;

    @JsonProperty("ngayCapNhat")
    private LocalDateTime capNhatLuc;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DiaChiResponse {
        private String soNha;
        private String duong;
        private String phuong;
        private String quan;
        private String thanhPho;
    }

    public static NhaTroResponse fromEntity(NhaTro nhaTro, int tongSoPhong, int phongTrong, int phongDangThue) {
        LocalDateTime taoLucLocal = nhaTro.getTaoLuc() != null
                ? nhaTro.getTaoLuc().toLocalDateTime()
                : null;
        LocalDateTime capNhatLucLocal = nhaTro.getCapNhatLuc() != null
                ? nhaTro.getCapNhatLuc().toLocalDateTime()
                : null;

        return NhaTroResponse.builder()
                .id(nhaTro.getId())
                .tenToaNha(nhaTro.getTen())
                .diaChi(DiaChiResponse.builder()
                        .soNha("")
                        .duong(nhaTro.getDiaChi() != null ? nhaTro.getDiaChi() : "")
                        .phuong(nhaTro.getXa() != null ? nhaTro.getXa() : "")
                        .quan(nhaTro.getHuyen() != null ? nhaTro.getHuyen() : "")
                        .thanhPho(nhaTro.getTinh() != null ? nhaTro.getTinh() : "")
                        .build())
                .moTa(nhaTro.getMoTa())
                // .tienNghiChung(nhaTro.getTienNghiChung())
                .tongSoPhong(tongSoPhong)
                .phongTrong(phongTrong)
                .phongDangThue(phongDangThue)
                .taoLuc(taoLucLocal)
                .capNhatLuc(capNhatLucLocal)
                .build();
    }
}
