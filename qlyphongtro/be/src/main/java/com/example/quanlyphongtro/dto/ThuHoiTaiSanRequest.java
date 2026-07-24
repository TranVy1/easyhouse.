package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.Min;
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
public class ThuHoiTaiSanRequest {
    @NotNull(message = "Phòng ID không được để trống")
    private UUID phongId;

    @NotNull(message = "Số lượng thu hồi không được để trống")
    @Min(value = 1, message = "Số lượng phải lớn hơn 0")
    private Integer soLuong;

    @NotNull(message = "Trạng thái sau thu hồi không được để trống (true = khả dụng, false = hư hỏng)")
    private Boolean khaDung;

    private String ghiChu;
}
