package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.AuthResponse;
import com.example.quanlyphongtro.dto.ForgotPasswordRequest;
import com.example.quanlyphongtro.dto.KhachThueDashboardResponse;
import com.example.quanlyphongtro.dto.KhachThueLoginRequest;
import com.example.quanlyphongtro.dto.KhachThueLoginResponse;
import com.example.quanlyphongtro.dto.LoginRequest;
import com.example.quanlyphongtro.dto.RegisterRequest;
import com.example.quanlyphongtro.services.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestParam;

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

    @PostMapping("/khach-thue/login")
    public ApiResponse<KhachThueLoginResponse> khachThueLogin(@Valid @RequestBody KhachThueLoginRequest request) {
        try {
            KhachThueLoginResponse response = authService.loginKhachThue(request);
            return ApiResponse.success(response, "Dang nhap khach thue thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/khach-thue/me")
    public ApiResponse<KhachThueDashboardResponse> khachThueMe(
            @RequestHeader(value = "Authorization", required = false) String authorizationHeader) {
        try {
            KhachThueDashboardResponse response = authService.getKhachThueDashboard(authorizationHeader);
            return ApiResponse.success(response);
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/register")
    public ApiResponse<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        try {
            AuthResponse response = authService.register(request);
            return ApiResponse.success(response, "Đăng ký thành công. Vui lòng kiểm tra email để xác thực tài khoản.");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/verify-email")
    public ApiResponse<String> verifyEmail(@RequestParam("token") String token) {
        try {
            String message = authService.verifyEmail(token);
            return ApiResponse.success(message, message);
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/forgot-password")
    public ApiResponse<Void> forgotPassword(@Valid @RequestBody ForgotPasswordRequest request) {
        try {
            authService.forgotPassword(request.getEmail());
            return ApiResponse.success(null, "Mật khẩu mới đã được gửi vào email của bạn.");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
