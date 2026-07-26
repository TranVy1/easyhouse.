package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.dto.TaiSanPhongDto;
import com.example.quanlyphongtro.services.TaiSanPhongService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/tai-san-phong")
@RequiredArgsConstructor
public class TaiSanPhongController {

    private final TaiSanPhongService taiSanPhongService;

    @GetMapping
    public ApiResponse<PaginatedResponse<TaiSanPhongDto>> getAll(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String nhaTroId,
            @RequestParam(required = false) String phongId,
            @RequestParam(required = false) String tinhTrang,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit
    ) {
        return ApiResponse.success(taiSanPhongService.getAll(keyword, nhaTroId, phongId, tinhTrang, page, limit), "Lấy danh sách tài sản thành công");
    }

    @GetMapping("/phong/{phongId}")
    public ApiResponse<List<TaiSanPhongDto>> getTaiSanByPhong(@PathVariable UUID phongId) {
        return ApiResponse.success(taiSanPhongService.getTaiSanByPhong(phongId));
    }

    @PostMapping("/phong/{phongId}")
    public ApiResponse<TaiSanPhongDto> addTaiSanToPhong(@PathVariable UUID phongId, @Valid @RequestBody TaiSanPhongDto dto) {
        return ApiResponse.success(taiSanPhongService.addTaiSanToPhong(phongId, dto), "Thêm tài sản thành công");
    }

    @PutMapping("/{id}")
    public ApiResponse<TaiSanPhongDto> updateTaiSan(@PathVariable UUID id, @Valid @RequestBody TaiSanPhongDto dto) {
        return ApiResponse.success(taiSanPhongService.updateTaiSan(id, dto), "Cập nhật tài sản thành công");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deleteTaiSan(@PathVariable UUID id) {
        taiSanPhongService.deleteTaiSan(id);
        return ApiResponse.success(null, "Xóa tài sản thành công");
    }

    @GetMapping("/import/template")
    public org.springframework.http.ResponseEntity<String> getImportTemplate() {
        String template = taiSanPhongService.getImportTemplate();
        return org.springframework.http.ResponseEntity.ok()
                .header(org.springframework.http.HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"tai-san-phong-template.csv\"")
                .header(org.springframework.http.HttpHeaders.CONTENT_TYPE, "text/csv; charset=UTF-8")
                .body(template);
    }

    @PostMapping("/import/preview")
    public ApiResponse<com.example.quanlyphongtro.dto.TaiSanPhongImportPreviewResponse> previewImport(@RequestParam("file") org.springframework.web.multipart.MultipartFile file) {
        return ApiResponse.success(taiSanPhongService.previewImport(file), "Preview import thành công");
    }

    @PostMapping("/import/commit")
    public ApiResponse<Void> commitImport(@RequestBody com.example.quanlyphongtro.dto.TaiSanPhongImportCommitRequest request) {
        taiSanPhongService.commitImport(request);
        return ApiResponse.success(null, "Import thành công");
    }
}
