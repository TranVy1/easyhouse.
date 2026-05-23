package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.*;
import com.example.quanlyphongtro.services.HopDongService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/hop-dong")
@RequiredArgsConstructor
public class HopDongController {

    private final HopDongService hopDongService;

    @GetMapping
    public ApiResponse<List<HopDongResponse>> getAll() {
        try { return ApiResponse.success(hopDongService.getAll()); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }

    @GetMapping("/{id}")
    public ApiResponse<HopDongResponse> getById(@PathVariable UUID id) {
        try { return ApiResponse.success(hopDongService.getById(id)); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }

    @GetMapping("/dich-vu")
    public ApiResponse<List<HopDongDichVuOptionResponse>> getDichVuTheoPhong(@RequestParam UUID phongId) {
        try { return ApiResponse.success(hopDongService.getDichVuTheoPhong(phongId)); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }

    @PostMapping
    public ApiResponse<HopDongResponse> create(@RequestBody HopDongRequest request) {
        try { return ApiResponse.success(hopDongService.create(request), "Tạo hợp đồng thành công"); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }

    @PutMapping("/{id}")
    public ApiResponse<HopDongResponse> update(@PathVariable UUID id, @RequestBody HopDongRequest request) {
        try { return ApiResponse.success(hopDongService.update(id, request), "Cập nhật hợp đồng thành công"); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable UUID id) {
        try { hopDongService.delete(id); return ApiResponse.success(null, "Xóa hợp đồng thành công"); }
        catch (Exception e) { return ApiResponse.error(e.getMessage()); }
    }
}
