package com.example.quanlyphongtro.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class DichVuRequest {
    private String tenDichVu;
    private String loaiTinhPhi;
    private String donVi;
    private BigDecimal donGiaMacDinh;
    private Boolean batBuoc;
}
