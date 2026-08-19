package com.example.quanlyphongtro.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class DichVuRequest {
    private String tenDichVu;
    private String loaiTinhPhi;
    private String donVi;
    
    @jakarta.validation.constraints.Min(value = 0, message = "Đơn giá không được âm")
    private BigDecimal donGiaMacDinh;
    
    private Boolean batBuoc;
}
