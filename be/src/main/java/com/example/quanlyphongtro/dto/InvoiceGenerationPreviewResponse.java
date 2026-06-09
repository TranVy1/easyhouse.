package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InvoiceGenerationPreviewResponse {
    private Integer kyThang;
    private Integer kyNam;
    private List<InvoiceCandidateResponse> candidates;
    private int tongHopDong;
    private int tongReady;
    private BigDecimal tongEstimatedAmount;
}
