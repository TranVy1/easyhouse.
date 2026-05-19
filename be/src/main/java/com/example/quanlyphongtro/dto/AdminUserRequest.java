package com.example.quanlyphongtro.dto;

import lombok.Data;

@Data
public class AdminUserRequest {
    private String name;
    private String email;
    private String password;
    private String phone;
    private String role;
    private Boolean isActive;
}
