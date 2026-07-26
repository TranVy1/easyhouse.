package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DatCocPhongRequest {
    private UUID phongId;
    private UUID khachThueId;
    private BigDecimal soTienCoc;
    private LocalDate ngayDuKienVao;
    private String ghiChu;
}
