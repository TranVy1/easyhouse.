package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@Data
public class PhongBatchRequest {
    @NotNull(message = "Nhà trọ không được để trống")
    private UUID nhaTroId;

    @NotBlank(message = "Prefix không được để trống")
    private String prefix;

    @Min(value = 1, message = "Số bắt đầu phải lớn hơn 0")
    private int start;

    @Min(value = 1, message = "Số kết thúc phải lớn hơn 0")
    private int end;

    private Integer tang;
    private UUID tangId;
    private BigDecimal dienTich;
    private BigDecimal giaHienTai;
    private BigDecimal tienCocMacDinh;
    private String moTa;
    private Integer soNguoiToiDa;
    private String trangThai; // AVAILABLE by default
    private String khuVuc;
    private List<UUID> tienNghi;
}
