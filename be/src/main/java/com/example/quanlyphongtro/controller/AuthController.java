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
import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ApiResponse<AuthResponse> login(@Valid @RequestBody LoginRequest request, HttpServletRequest httpServletRequest) {
        try {
            return ApiResponse.success(authService.login(request), "Dang nhap thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/register")
    public ApiResponse<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        try {
            return ApiResponse.success(authService.register(request), "Dang ky thanh cong. Vui long kiem tra email de xac thuc.");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/refresh")
    public ApiResponse<AuthResponse> refresh(@RequestBody Map<String, String> body) {
        try {
            String refreshToken = body.get("refreshToken");
            if (refreshToken == null || refreshToken.isBlank()) {
                return ApiResponse.error("refreshToken la bat buoc");
            }
            return ApiResponse.success(authService.refreshAccessToken(refreshToken), "Token da duoc lam moi");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/verify-email")
    public ApiResponse<AuthResponse> verifyEmail(@RequestBody Map<String, String> body) {
        try {
            String token = body.get("token");
            if (token == null || token.isBlank()) {
                return ApiResponse.error("Token xac thuc la bat buoc");
            }
            return ApiResponse.success(authService.verifyEmail(token), "Email da duoc xac thuc thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/resend-verification")
    public ApiResponse<Void> resendVerification(@RequestBody Map<String, String> body) {
        try {
            String email = body.get("email");
            if (email == null || email.isBlank()) {
                return ApiResponse.error("Email la bat buoc");
            }
            authService.resendVerificationEmail(email);
            return ApiResponse.success(null, "Email xac thuc da duoc gui lai");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/forgot-password")
    public ApiResponse<Void> forgotPassword(@Valid @RequestBody ForgotPasswordRequest request) {
        try {
            authService.forgotPassword(request.getEmail());
            return ApiResponse.success(null, "Neu email ton tai, he thong da gui huong dan khoi phuc mat khau");
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
            return ApiResponse.success(null, "Dang xuat thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/khach-thue/login")
    public ApiResponse<KhachThueLoginResponse> khachThueLogin(@Valid @RequestBody KhachThueLoginRequest request, HttpServletRequest httpServletRequest) {
        try {
            return ApiResponse.success(authService.loginKhachThue(request), "Dang nhap khach thue thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @GetMapping("/khach-thue/me")
    public ApiResponse<KhachThueDashboardResponse> khachThueMe(Authentication authentication) {
        try {
            if (authentication == null || !(authentication.getPrincipal() instanceof UUID userId)) {
                return ApiResponse.error("Vui long dang nhap lai");
            }
            return ApiResponse.success(authService.getKhachThueDashboard(userId));
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
