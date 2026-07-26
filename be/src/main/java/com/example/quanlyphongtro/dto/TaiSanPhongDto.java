package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TaiSanPhongDto {
    private UUID id;
    private UUID phongId;

    @NotBlank(message = "Tên tài sản không được để trống")
    private String tenTaiSan;

    @NotNull(message = "Số lượng không được để trống")
    private Integer soLuong;

    @NotNull(message = "Giá trị không được để trống")
    private BigDecimal giaTri;

    @NotBlank(message = "Tình trạng không được để trống")
    private String tinhTrang;

    private String ghiChu;
    private String anhTaiSan;
    
    private UUID nhaTroId;
    private String tenNhaTro;
    private String tenPhong;
    private UUID khoTaiSanId;
}
