package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.ThanhVienHopDongRequest;
import com.example.quanlyphongtro.dto.ThanhVienHopDongResponse;
import com.example.quanlyphongtro.services.ThanhVienHopDongService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/hop-dong/{hopDongId}/thanh-vien")
@RequiredArgsConstructor
public class ThanhVienHopDongController {

    private final ThanhVienHopDongService thanhVienHopDongService;

    @GetMapping
    public ApiResponse<List<ThanhVienHopDongResponse>> getMembers(@PathVariable UUID hopDongId) {
        return ApiResponse.success(thanhVienHopDongService.getMembersByHopDongId(hopDongId));
    }

    @PostMapping
    public ApiResponse<ThanhVienHopDongResponse> addMember(
            @PathVariable UUID hopDongId,
            @Valid @RequestBody ThanhVienHopDongRequest request) {
        return ApiResponse.success(thanhVienHopDongService.addMember(hopDongId, request), "Thêm thành viên thành công");
    }

    @PutMapping("/{id}")
    public ApiResponse<ThanhVienHopDongResponse> updateMember(
            @PathVariable UUID hopDongId,
            @PathVariable UUID id,
            @Valid @RequestBody ThanhVienHopDongRequest request) {
        return ApiResponse.success(thanhVienHopDongService.updateMember(id, request), "Cập nhật thành viên thành công");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> removeMember(
            @PathVariable UUID hopDongId,
            @PathVariable UUID id) {
        thanhVienHopDongService.removeMember(id);
        return ApiResponse.success(null, "Xóa thành viên thành công");
    }
}
