package com.example.quanlyphongtro.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class GenerateRoomsRequest {
    private Integer soTang;
    private Integer soPhongMoiTang;
    private BigDecimal dienTichMacDinh;
    private BigDecimal giaThueMacDinh;
    private BigDecimal tienCocMacDinh;
    private Integer soNguoiToiDa;
    private List<CauTrucTangRequest> cauTrucTang;
    private List<String> tienNghiMacDinh;

    @Data
    public static class CauTrucTangRequest {
        private Integer soTang;
        private Integer soPhong;
        private BigDecimal dienTichMacDinh;
        private BigDecimal giaThueMacDinh;
        private BigDecimal tienCocMacDinh;
        private Integer soNguoiToiDa;
    }
}
