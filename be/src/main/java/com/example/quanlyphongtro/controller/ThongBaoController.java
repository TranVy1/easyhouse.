package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.*;
import com.example.quanlyphongtro.services.ThongBaoService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.UUID;

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
        try { return ApiResponse.success(thongBaoService.create(request), "Tạo thông báo thành công"); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }

    @PutMapping("/{id}")
    public ApiResponse<ThongBaoResponse> update(@PathVariable UUID id, @RequestBody ThongBaoRequest request) {
        try { return ApiResponse.success(thongBaoService.update(id, request), "Cập nhật thông báo thành công"); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable UUID id) {
        try { thongBaoService.delete(id); return ApiResponse.success(null, "Xóa thông báo thành công"); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }
}
