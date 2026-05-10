package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NhaTroRequest {

    private String tenToaNha;

    private DiaChiRequest diaChi;

    private String moTa;

    private List<String> tienNghiChung;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DiaChiRequest {
        private String soNha;
        private String duong;
        private String phuong;
        private String quan;
        private String thanhPho;
    }
}
