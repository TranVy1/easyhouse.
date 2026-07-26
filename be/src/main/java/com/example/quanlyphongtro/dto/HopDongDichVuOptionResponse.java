package com.example.quanlyphongtro.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.util.UUID;

@Data
@Builder
public class HopDongDichVuOptionResponse {
    private UUID dichVuId;
    private String ten;
    private String loaiTinhPhi;
    private String donVi;
    private BigDecimal donGiaMacDinh;
    private Boolean batBuoc;
}
