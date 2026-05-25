package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.ThongBaoRequest;
import com.example.quanlyphongtro.dto.ThongBaoResponse;
import com.example.quanlyphongtro.services.ThongBaoService;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/thong-bao")
@RequiredArgsConstructor
public class ThongBaoController {

    private final ThongBaoService thongBaoService;

    @GetMapping
    public ApiResponse<List<ThongBaoResponse>> getAll() {
        try { return ApiResponse.success(thongBaoService.getAll()); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }

    @GetMapping("/{id}")
    public ApiResponse<ThongBaoResponse> getById(@PathVariable UUID id) {
        try { return ApiResponse.success(thongBaoService.getById(id)); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }

    @PostMapping
    public ApiResponse<ThongBaoResponse> create(@RequestBody ThongBaoRequest request) {
        try { return ApiResponse.success(thongBaoService.create(request), "Tao thong bao thanh cong"); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }

    @PutMapping("/{id}")
    public ApiResponse<ThongBaoResponse> update(@PathVariable UUID id, @RequestBody ThongBaoRequest request) {
        try { return ApiResponse.success(thongBaoService.update(id, request), "Cap nhat thong bao thanh cong"); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }

    @PostMapping("/{id}/send")
    public ApiResponse<ThongBaoResponse> send(@PathVariable UUID id) {
        try { return ApiResponse.success(thongBaoService.send(id), "Gui thong bao thanh cong"); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }

    @PatchMapping("/{id}/da-doc")
    public ApiResponse<ThongBaoResponse> markRead(
            @PathVariable UUID id,
            @RequestParam(required = false) UUID nguoiDungId,
            @RequestParam(defaultValue = "true") boolean daDoc,
            Authentication authentication) {
        try {
            UUID resolvedUserId = nguoiDungId;
            if (resolvedUserId == null && authentication != null && authentication.getPrincipal() instanceof UUID userId) {
                resolvedUserId = userId;
            }
            return ApiResponse.success(thongBaoService.markRead(id, resolvedUserId, daDoc), "Cap nhat trang thai doc thanh cong");
        } catch (Exception e) {
            return ApiResponse.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable UUID id) {
        try { thongBaoService.delete(id); return ApiResponse.success(null, "Xoa thong bao thanh cong"); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }

    @GetMapping("/my")
    public ApiResponse<List<ThongBaoResponse>> getMyThongBao() {
        try { return ApiResponse.success(thongBaoService.getMyThongBao()); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }
}
