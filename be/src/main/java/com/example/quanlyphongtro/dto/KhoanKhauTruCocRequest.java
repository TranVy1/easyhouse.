package com.example.quanlyphongtro.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class KhoanKhauTruCocRequest {
    private String moTa;
    private BigDecimal soTien;
    private String chungTuUrl;
}
