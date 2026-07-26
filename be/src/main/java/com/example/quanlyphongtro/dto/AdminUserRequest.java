package com.example.quanlyphongtro.dto;

import lombok.Data;

import java.util.UUID;

@Data
public class AdminUserRequest {
    private UUID authUserId;
    private UUID supabaseUserId;

    private String name;
    private String email;
    private String password;
    private String phone;
    private String role;
    private Boolean isActive;
}
