package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;
import lombok.Data;

@Data
public class CauHinhPhiXeRequest {
    @NotNull(message = "Vui lòng chọn nhà trọ")
    private UUID nhaTroId;
    @NotBlank(message = "Vui lòng chọn loại xe")
    private String loaiXe;
    @NotNull(message = "Vui lòng nhập đơn giá")
    @DecimalMin(value = "0.00", message = "Đơn giá không được âm")
    private BigDecimal donGia;
    @NotNull(message = "Vui lòng chọn ngày hiệu lực")
    private LocalDate hieuLucTu;
    private LocalDate hieuLucDen;
    private Boolean dangApDung;
    private String ghiChu;
}
