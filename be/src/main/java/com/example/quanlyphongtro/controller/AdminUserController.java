package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.AdminUserRequest;
import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.UserResponse;
import com.example.quanlyphongtro.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.example.quanlyphongtro.dto.UserRoleAssignmentRequest;
import com.example.quanlyphongtro.dto.UserBuildingAssignmentRequest;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

import org.springframework.security.access.prepost.PreAuthorize;

@RestController
@RequestMapping("/api/admin/users")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminUserController {

    private final UserService userService;

    @GetMapping
    public ApiResponse<List<UserResponse>> getAll() {
        try {
            return ApiResponse.success(userService.getAllUsers());
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping
    public ApiResponse<UserResponse> create(@RequestBody AdminUserRequest request) {
        try {
            return ApiResponse.success(userService.createUser(request), "Tạo tài khoản thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ApiResponse<UserResponse> update(@PathVariable UUID id, @RequestBody AdminUserRequest request) {
        try {
            return ApiResponse.success(userService.updateUser(id, request), "Cập nhật tài khoản thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable UUID id) {
        try {
            userService.deleteUser(id);
            return ApiResponse.success(null, "Xóa tài khoản thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/{id}/roles")
    public ApiResponse<Void> assignRoles(@PathVariable UUID id, @RequestBody UserRoleAssignmentRequest request) {
        try {
            userService.assignRoles(id, request);
            return ApiResponse.success(null, "Gán quyền thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @PostMapping("/{id}/buildings")
    public ApiResponse<Void> assignBuildings(@PathVariable UUID id, @RequestBody UserBuildingAssignmentRequest request) {
        try {
            userService.assignBuildings(id, request);
            return ApiResponse.success(null, "Gán tòa nhà thành công");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }
}
