package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Data
public class CauHinhGiaRequest {

    @NotNull(message = "nhaTroId khong duoc de trong")
    private UUID nhaTroId;

    private UUID dichVuId;

    @NotBlank(message = "loai khong duoc de trong")
    private String loai;

    @NotBlank(message = "tenHienThi khong duoc de trong")
    private String tenHienThi;

    private String loaiTinhPhi;

    @NotNull(message = "donGia khong duoc de trong")
    @DecimalMin(value = "0.00", message = "donGia phai >= 0")
    private BigDecimal donGia;

    private LocalDate hieuLucTu;
    private LocalDate hieuLucDen;
    private Boolean dangApDung;
}
