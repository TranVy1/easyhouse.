package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InvoiceCandidateResponse {
    private UUID hopDongId;
    private String maHopDong;
    private UUID phongId;
    private String maPhong;
    private UUID khachThueId;
    private String tenKhachThue;
    private String status; // READY, EXISTS, MISSING_READING
    private BigDecimal estimatedAmount;
    private List<String> warnings;
}
