package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TopDebtorResponse {
    private UUID phongId;
    private String maPhong;
    private UUID khachThueId;
    private String tenKhachThue;
    private String soDienThoai;
    private BigDecimal tongNo;
    private BigDecimal noQuaHan;
    private ZonedDateTime oldestDueDate;
    private long invoiceCount;
}
