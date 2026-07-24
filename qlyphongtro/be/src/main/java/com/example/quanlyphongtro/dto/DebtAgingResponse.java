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
public class DebtAgingResponse {
    private BigDecimal notDue;
    private BigDecimal overdue1To7;
    private BigDecimal overdue8To15;
    private BigDecimal overdue16To30;
    private BigDecimal overdueOver30;
    private BigDecimal totalOutstanding;
}
