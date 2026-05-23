package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@Data
public class PhongRequest {

    @NotBlank(message = "Tên phòng không được để trống")
    private String ten;

    @NotNull(message = "Vui lòng chọn nhà trọ")
    private UUID nhaTroId;

    private String khuVuc;
    private Integer tang;

    @NotNull(message = "Diện tích không được để trống")
    private BigDecimal dienTich;

    @NotNull(message = "Giá thuê không được để trống")
    private BigDecimal giaHienTai;

    private BigDecimal tienCocMacDinh;
    private Integer soNguoiToiDa;
    private String trangThai;
    private String moTa;
    private List<String> anhPhong;
    private List<String> tienNghi;
}
