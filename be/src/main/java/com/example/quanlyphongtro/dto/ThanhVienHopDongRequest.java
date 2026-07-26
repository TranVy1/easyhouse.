package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;

@Data
public class ThanhVienHopDongRequest {
    @NotBlank(message = "Họ tên không được để trống")
    private String hoTen;

    private String soCccd;
    private String soDienThoai;

    @NotNull(message = "Ngày vào không được để trống")
    private LocalDate ngayVao;

    private LocalDate ngayRoi;
    private Boolean dangO;
    private String ghiChu;
}
