package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CapPhatTatCaRequest {
    @NotNull(message = "Số lượng mỗi phòng không được để trống")
    @Min(value = 1, message = "Số lượng mỗi phòng phải lớn hơn 0")
    private Integer soLuongMoiPhong;

    private BigDecimal giaTri;
    private String ghiChu;
}
