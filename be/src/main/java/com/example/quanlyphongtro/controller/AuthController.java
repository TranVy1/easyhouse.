package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.AuthResponse;
import com.example.quanlyphongtro.dto.KhachThueLoginRequest;
import com.example.quanlyphongtro.dto.KhachThueLoginResponse;
import com.example.quanlyphongtro.dto.LoginRequest;
import com.example.quanlyphongtro.dto.RegisterRequest;
import com.example.quanlyphongtro.services.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ApiResponse<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        try {
            AuthResponse response = authService.login(request);
            return ApiResponse.success(response, "Đăng nhập thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/register")
    public ApiResponse<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        try {
            AuthResponse response = authService.register(request);
            return ApiResponse.success(response, "Đăng ký thành công. Vui lòng kiểm tra email để xác thực.");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/refresh")
    public ApiResponse<AuthResponse> refresh(@RequestBody Map<String, String> body) {
        try {
            String refreshToken = body.get("refreshToken");
            if (refreshToken == null || refreshToken.isBlank()) {
                return ApiResponse.error("refreshToken là bắt buộc");
            }
            AuthResponse response = authService.refreshAccessToken(refreshToken);
            return ApiResponse.success(response, "Token đã được làm mới");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/verify-email")
    public ApiResponse<AuthResponse> verifyEmail(@RequestBody Map<String, String> body) {
        try {
            String token = body.get("token");
            if (token == null || token.isBlank()) {
                return ApiResponse.error("Token xác thực là bắt buộc");
            }
            AuthResponse response = authService.verifyEmail(token);
            return ApiResponse.success(response, "Email đã được xác thực thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/resend-verification")
    public ApiResponse<Void> resendVerification(@RequestBody Map<String, String> body) {
        try {
            String email = body.get("email");
            if (email == null || email.isBlank()) {
                return ApiResponse.error("Email là bắt buộc");
            }
            authService.resendVerificationEmail(email);
            return ApiResponse.success(null, "Email xác thực đã được gửi lại");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/logout")
    public ApiResponse<Void> logout(Authentication authentication) {
        try {
            if (authentication != null && authentication.getPrincipal() instanceof UUID userId) {
                authService.logout(userId);
            }
            return ApiResponse.success(null, "Đăng xuất thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/khach-thue/login")
    public ApiResponse<KhachThueLoginResponse> khachThueLogin(@Valid @RequestBody KhachThueLoginRequest request) {
        try {
            KhachThueLoginResponse response = authService.loginKhachThue(request);
            return ApiResponse.success(response, "Đăng nhập khách thuê thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
