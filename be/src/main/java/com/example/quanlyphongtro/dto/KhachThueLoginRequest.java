package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class KhachThueLoginRequest {
    @NotBlank(message = "Số điện thoại không được để trống")
    private String soDienThoai;

    @NotBlank(message = "Mật khẩu không được để trống")
    private String matKhau;
}
