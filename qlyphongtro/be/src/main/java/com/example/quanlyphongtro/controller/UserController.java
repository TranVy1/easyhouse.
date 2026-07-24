package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.ChangePasswordRequest;
import com.example.quanlyphongtro.dto.UserRequest;
import com.example.quanlyphongtro.dto.UserResponse;
import com.example.quanlyphongtro.services.UserService;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/profile")
    public ApiResponse<UserResponse> getProfile(Authentication authentication) {
        try {
            UUID userId = requireUserId(authentication);
            return ApiResponse.success(userService.getProfileById(userId));
        } catch (Exception e) {
            return ApiResponse.error("Khong the lay thong tin ho so: " + e.getMessage());
        }
    }

    @PutMapping("/profile")
    public ApiResponse<UserResponse> updateProfile(Authentication authentication, @RequestBody UserRequest request) {
        try {
            UUID userId = requireUserId(authentication);
            UserResponse profile = userService.updateProfile(userId, request);
            return ApiResponse.success(profile, "Cap nhat ho so thanh cong");
        } catch (Exception e) {
            return ApiResponse.error("Khong the cap nhat ho so: " + e.getMessage());
        }
    }

    @PostMapping("/change-password")
    public ApiResponse<String> changePassword(Authentication authentication, @RequestBody ChangePasswordRequest request) {
        try {
            UUID userId = requireUserId(authentication);
            userService.changePassword(userId, request);
            return ApiResponse.success(null, "Doi mat khau thanh cong");
        } catch (Exception e) {
            return ApiResponse.error("Doi mat khau that bai: " + e.getMessage());
        }
    }

    private UUID requireUserId(Authentication authentication) {
        if (authentication != null && authentication.getPrincipal() instanceof UUID userId) {
            return userId;
        }
        throw new RuntimeException("Khong tim thay thong tin dinh danh nguoi dung. Vui long dang nhap lai.");
    }
}
