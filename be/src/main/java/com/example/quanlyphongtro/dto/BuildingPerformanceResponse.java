package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BuildingPerformanceResponse {
    private UUID nhaTroId;
    private String tenToaNha;
    private long tongPhong;
    private long phongDangThue;
    private double occupancyRate;
    private BigDecimal expectedRevenue;
    private BigDecimal collectedRevenue;
    private BigDecimal outstanding;
    private long openIncidentCount;
}
