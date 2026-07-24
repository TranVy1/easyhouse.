package com.example.quanlyphongtro.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.util.UUID;

@Data
@Builder
public class ThongKeToaNhaResponse {
    @JsonProperty("_id")
    private UUID nhaTroId;
    private String tenToaNha;
    private Integer tongSoTang;
    private Integer tongSoPhong;
    private Integer phongTrong;
    private Integer phongDangThue;
    private Integer phongBaoTri;
    private Integer hopDongSapHetHan;
    private BigDecimal doanhThuDuKienThang;
}
