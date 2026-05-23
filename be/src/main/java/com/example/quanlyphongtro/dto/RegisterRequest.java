package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.UUID;

@Data
public class RegisterRequest {
    private UUID authUserId;
    private UUID supabaseUserId;

    @NotBlank(message = "Họ tên không được để trống")
    @JsonProperty("ten")
    private String hoTen;

    @NotBlank(message = "Email không được để trống")
    @Email(message = "Email không hợp lệ")
    private String email;

    @NotBlank(message = "Mật khẩu không được để trống")
    private String matKhau;

    @NotBlank(message = "Số điện thoại không được để trống")
    private String soDienThoai;

    @NotBlank(message = "Vai trò không được để trống")
    private String vaiTro; // "LANDLORD" or "TENANT"
}
