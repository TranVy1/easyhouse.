package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
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

    private String cheDoTaoPhong;
    private Integer soTang;
    private Integer soPhongMoiTang;
    private BigDecimal dienTichMacDinh;
    private BigDecimal giaThueMacDinh;
    private BigDecimal tienCocMacDinh;
    private Integer soNguoiToiDa;
    private List<GenerateRoomsRequest.CauTrucTangRequest> cauTrucTang;
    private List<String> tienNghiMacDinh;

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
