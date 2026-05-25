package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.HopDongDichVuOptionResponse;
import com.example.quanlyphongtro.dto.HopDongRequest;
import com.example.quanlyphongtro.dto.HopDongResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.services.HopDongService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/hop-dong")
@RequiredArgsConstructor
public class HopDongController {

    private final HopDongService hopDongService;

    @GetMapping
    public ResponseEntity<ApiResponse<PaginatedResponse<HopDongResponse>>> getAll(
            @RequestParam(required = false) String phongId,
            @RequestParam(required = false) String trangThai,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit) {
        try {
            return ResponseEntity.ok(ApiResponse.success(hopDongService.getAll(phongId, trangThai, page, limit)));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<HopDongResponse>> getById(@PathVariable UUID id) {
        try {
            return ResponseEntity.ok(ApiResponse.success(hopDongService.getById(id)));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @GetMapping("/dich-vu")
    public ResponseEntity<ApiResponse<List<HopDongDichVuOptionResponse>>> getDichVuTheoPhong(@RequestParam UUID phongId) {
        try {
            return ResponseEntity.ok(ApiResponse.success(hopDongService.getDichVuTheoPhong(phongId)));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @PostMapping
    public ResponseEntity<ApiResponse<HopDongResponse>> create(@RequestBody HopDongRequest request) {
        try {
            return ResponseEntity.ok(ApiResponse.success(hopDongService.create(request), "Tạo hợp đồng thành công"));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<HopDongResponse>> update(@PathVariable UUID id, @RequestBody HopDongRequest request) {
        try {
            return ResponseEntity.ok(ApiResponse.success(hopDongService.update(id, request), "Cập nhật hợp đồng thành công"));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable UUID id) {
        try {
            hopDongService.delete(id);
            return ResponseEntity.ok(ApiResponse.success(null, "Xóa hợp đồng thành công"));
        } catch (Exception e) {
            return badRequest(e.getMessage());
        }
    }

    private <T> ResponseEntity<ApiResponse<T>> badRequest(String message) {
        return ResponseEntity.badRequest().body(ApiResponse.error(message));
    }

    @PutMapping("/{id}/ket-thuc")
    public ResponseEntity<com.example.quanlyphongtro.dto.ApiResponse<com.example.quanlyphongtro.dto.HopDongResponse>> terminateContract(
            @PathVariable java.util.UUID id,
            @RequestBody com.example.quanlyphongtro.dto.KetThucHopDongRequest req) {
        return ResponseEntity.ok(com.example.quanlyphongtro.dto.ApiResponse.success(hopDongService.terminateContract(id, req), "Ket thuc hop dong thanh cong"));
    }

    @PutMapping("/{id}/gia-han")
    public ResponseEntity<com.example.quanlyphongtro.dto.ApiResponse<com.example.quanlyphongtro.dto.HopDongResponse>> extendContract(
            @PathVariable java.util.UUID id,
            @RequestBody com.example.quanlyphongtro.dto.GiaHanHopDongRequest req) {
        return ResponseEntity.ok(com.example.quanlyphongtro.dto.ApiResponse.success(hopDongService.extendContract(id, req), "Gia han hop dong thanh cong"));
    }
}
