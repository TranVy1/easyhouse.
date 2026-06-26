package com.example.quanlyphongtro.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@Builder
public class AuthResponse {
    private UUID id;
    private String email;
    
    @JsonProperty("hoTen")
    private String name;
    
    @JsonProperty("vaiTro")
    private String role;
    
    @JsonProperty("soDienThoai")
    private String phone;
    
    @JsonProperty("anhDaiDien")
    private String avatar;

    /** JWT access token (short-lived) */
    private String token;

    /** JWT refresh token (long-lived) */
    private String refreshToken;

    /** Whether the user has verified their email */
    private boolean emailVerified;

    /** Whether the user needs to change their password (e.g. default password used) */
    private boolean requirePasswordChange;
}
