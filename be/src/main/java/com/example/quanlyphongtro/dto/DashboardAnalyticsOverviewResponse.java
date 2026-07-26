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
public class DashboardAnalyticsOverviewResponse {
    private long totalRooms;
    private long occupiedRooms;
    private long availableRooms;
    private double occupancyRate;
    
    private BigDecimal expectedRevenueThisMonth;
    private BigDecimal collectedThisMonth;
    private BigDecimal outstandingThisMonth;
    private double collectionRate;
    
    private long overdueInvoiceCount;
    private long openIncidentCount;
    private long expiringContractCount;
}
