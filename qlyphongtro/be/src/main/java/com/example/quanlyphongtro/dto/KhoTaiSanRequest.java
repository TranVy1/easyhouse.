package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class KhoTaiSanRequest {
    @NotNull(message = "Nhà trọ ID không được để trống")
    private UUID nhaTroId;

    @NotBlank(message = "Tên tài sản không được để trống")
    private String tenTaiSan;

    private String hinhAnh;

    @NotNull(message = "Tổng số lượng không được để trống")
    @Min(value = 0, message = "Tổng số lượng phải >= 0")
    private Integer tongSoLuong;

    @NotBlank(message = "Tình trạng không được để trống")
    private String tinhTrang;

    private String ghiChu;
}
