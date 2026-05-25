package com.example.quanlyphongtro.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class GiaHanHopDongRequest {
    private LocalDate ngayKetThucMoi;
    private BigDecimal giaThueMoi;
    private LocalDate ngayHieuLuc;
    private String noiDung;
}
