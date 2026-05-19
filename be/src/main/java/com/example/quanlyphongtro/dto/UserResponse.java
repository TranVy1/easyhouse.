package com.example.quanlyphongtro.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponse {
    @JsonProperty("_id")
    private UUID id;
    private String name;
    private String email;
    private String phone;
    private String address;
    private String avatar;
    private String role;
    private Boolean isActive;
    private String trangThai;
    private ZonedDateTime createdAt;
    private ZonedDateTime lastLogin;
}
