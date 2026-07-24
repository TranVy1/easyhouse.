package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TaiSanPhongImportRow {
    private String phongId;
    private String tenPhong;
    private String tenTaiSan;
    private Integer soLuong;
    private BigDecimal giaTri;
    private String tinhTrang;
    private String ghiChu;
    private String anhTaiSan;
    
    // Fields for preview
    private boolean valid;
    private String errorReason;
}
