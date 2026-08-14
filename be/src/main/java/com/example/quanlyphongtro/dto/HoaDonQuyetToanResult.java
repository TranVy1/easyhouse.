package com.example.quanlyphongtro.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Builder
public class HoaDonQuyetToanResult {
    private HoaDonResponse hoaDon;
    private BigDecimal tienCocDaCanTru;
}
