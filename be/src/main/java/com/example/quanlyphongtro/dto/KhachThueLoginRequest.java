package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class KhachThueLoginRequest {
    @NotBlank(message = "So dien thoai khong duoc de trong")
    private String soDienThoai;

    @NotBlank(message = "Mat khau khong duoc de trong")
    private String matKhau;
}
