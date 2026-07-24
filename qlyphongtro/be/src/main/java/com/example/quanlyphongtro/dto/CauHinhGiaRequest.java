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

    @NotNull(message = "Vui lòng chọn nhà trọ")
    private UUID nhaTroId;

    private UUID dichVuId;

    @NotBlank(message = "Vui lòng chọn loại cấu hình giá")
    private String loai;

    @NotBlank(message = "Vui lòng nhập tên hiển thị")
    private String tenHienThi;

    private String loaiTinhPhi;

    @NotNull(message = "Vui lòng nhập đơn giá")
    @DecimalMin(value = "0.00", message = "Đơn giá phải lớn hơn hoặc bằng 0")
    private BigDecimal donGia;

    private LocalDate hieuLucTu;
    private LocalDate hieuLucDen;
    private Boolean dangApDung;
}
