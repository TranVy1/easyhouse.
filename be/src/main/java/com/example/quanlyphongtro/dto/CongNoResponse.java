package com.example.quanlyphongtro.dto;

import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@Data
@Builder
public class CongNoResponse {
    private UUID phongId;
    private String maPhong;
    private UUID toaNhaId;
    private String tenToaNha;
    private UUID khachThueId;
    private String tenKhachThue;
    private String soDienThoai;
    
    private BigDecimal tongNo;
    private BigDecimal noQuaHan;
    
    private List<HoaDonResponse> danhSachHoaDonNo;
}
