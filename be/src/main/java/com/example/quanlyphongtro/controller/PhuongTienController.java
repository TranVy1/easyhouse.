package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.dto.PhuongTienDto;
import com.example.quanlyphongtro.dto.PhuongTienRequest;
import com.example.quanlyphongtro.services.PhuongTienService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/phuong-tien")
@RequiredArgsConstructor
public class PhuongTienController {

    private final PhuongTienService phuongTienService;

    @GetMapping
    public ResponseEntity<ApiResponse<PaginatedResponse<PhuongTienDto>>> getAll(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String nhaTroId,
            @RequestParam(required = false) String phongId,
            @RequestParam(required = false) String trangThai,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit
    ) {
        return ResponseEntity.ok(
                ApiResponse.success(phuongTienService.getAll(keyword, nhaTroId, phongId, trangThai, page, limit), "Lấy danh sách phương tiện thành công")
        );
    }

    @PostMapping
    public ResponseEntity<ApiResponse<PhuongTienDto>> create(@Valid @RequestBody PhuongTienRequest request) {
        return ResponseEntity.ok(
                ApiResponse.success(phuongTienService.create(request), "Thêm phương tiện thành công")
        );
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<PhuongTienDto>> update(@PathVariable UUID id, @Valid @RequestBody PhuongTienRequest request) {
        return ResponseEntity.ok(
                ApiResponse.success(phuongTienService.update(id, request), "Cập nhật phương tiện thành công")
        );
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable UUID id) {
        phuongTienService.delete(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Xóa phương tiện thành công"));
    }
}
