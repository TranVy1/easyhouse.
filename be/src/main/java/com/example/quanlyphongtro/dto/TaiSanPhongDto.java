package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TaiSanPhongDto {
    private UUID id;
    private UUID phongId;
    private String tenTaiSan;
    private Integer soLuong;
    private BigDecimal giaTri;
    private String tinhTrang;
    private String ghiChu;
}
