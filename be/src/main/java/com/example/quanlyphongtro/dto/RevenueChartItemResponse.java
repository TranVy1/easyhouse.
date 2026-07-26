package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RevenueChartItemResponse {
    private int month;
    private int year;
    private String label;
    private BigDecimal expectedRevenue;
    private BigDecimal collectedRevenue;
    private BigDecimal outstanding;
}
