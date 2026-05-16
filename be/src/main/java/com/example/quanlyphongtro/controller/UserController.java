package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.UserResponse;
import com.example.quanlyphongtro.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/profile")
    public ApiResponse<UserResponse> getProfile(@RequestHeader(value = "Authorization", required = false) String authHeader) {
        System.out.println("Fetching profile with Authorization: " + authHeader);
        try {
            String email = null;
            
            if (authHeader != null && authHeader.startsWith("Bearer ") && !authHeader.contains("undefined") && !authHeader.contains("null")) {
                email = authHeader.substring(7).trim().toLowerCase();
            }
            
            // Fallback for old sessions with dummy token
            if ("dummy-jwt-token-for-now".equals(email)) {
                System.out.println("Old dummy token detected, falling back to docong88@gmail.com for development");
                email = "docong88@gmail.com"; 
            }
            
            if (email == null || email.isEmpty()) {
                // For development/fallback, try to get any user or return error
                return ApiResponse.error("Không tìm thấy thông tin định danh người dùng. Vui lòng đăng nhập lại.");
            }
            
            System.out.println("Looking up profile for email: " + email);
            UserResponse profile = userService.getProfileByEmail(email);
            return ApiResponse.success(profile);
        } catch (Exception e) {
            System.err.println("Error fetching profile: " + e.getMessage());
            return ApiResponse.error("Không thể lấy thông tin hồ sơ: " + e.getMessage());
        }
    }

    @PutMapping("/profile")
    public ApiResponse<UserResponse> updateProfile(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @RequestBody com.example.quanlyphongtro.dto.UserRequest request) {
        try {
            String email = "docong88@gmail.com";
            if (authHeader != null && authHeader.startsWith("Bearer ") && !authHeader.contains("undefined") && !authHeader.contains("null")) {
                email = authHeader.substring(7).trim().toLowerCase();
                if ("dummy-jwt-token-for-now".equals(email)) email = "docong88@gmail.com";
            }
            UserResponse profile = userService.updateProfile(email, request);
            return ApiResponse.success(profile, "Cập nhật hồ sơ thành công");
        } catch (Exception e) {
            return ApiResponse.error("Không thể cập nhật hồ sơ: " + e.getMessage());
        }
    }

    @PostMapping("/change-password")
    public ApiResponse<String> changePassword(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @RequestBody com.example.quanlyphongtro.dto.ChangePasswordRequest request) {
        try {
            String email = "docong88@gmail.com";
            if (authHeader != null && authHeader.startsWith("Bearer ") && !authHeader.contains("undefined") && !authHeader.contains("null")) {
                email = authHeader.substring(7).trim().toLowerCase();
                if ("dummy-jwt-token-for-now".equals(email)) email = "docong88@gmail.com";
            }
            userService.changePassword(email, request);
            return ApiResponse.success(null, "Đổi mật khẩu thành công");
        } catch (Exception e) {
            return ApiResponse.error("Đổi mật khẩu thất bại: " + e.getMessage());
        }
    }
}
