package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.dto.FileMediaResponse;
import com.example.quanlyphongtro.services.FileMediaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/media")
@RequiredArgsConstructor
public class FileMediaController {

    private final FileMediaService fileMediaService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<FileMediaResponse>>> getAll(
            @RequestParam(required = false) String doiTuong,
            @RequestParam(required = false) UUID doiTuongId) {
        
        List<FileMediaResponse> data;
        if (doiTuong != null && doiTuongId != null) {
            data = fileMediaService.getByDoiTuong(doiTuong, doiTuongId);
        } else {
            data = fileMediaService.getAll();
        }

        return ResponseEntity.ok(ApiResponse.<List<FileMediaResponse>>builder()
                .success(true)
                .message("Lấy danh sách file thành công")
                .data(data)
                .build());
    }

    @PostMapping(consumes = {"multipart/form-data"})
    public ResponseEntity<ApiResponse<FileMediaResponse>> uploadFile(
            @RequestParam("file") MultipartFile file,
            @RequestParam("doiTuong") String doiTuong,
            @RequestParam("doiTuongId") UUID doiTuongId,
            @RequestParam(value = "loaiFile", required = false) String loaiFile,
            @RequestParam(value = "nguoiDungId", required = false) UUID nguoiDungId) throws IOException {

        FileMediaResponse data = fileMediaService.uploadFile(file, doiTuong, doiTuongId, loaiFile, nguoiDungId);
        return ResponseEntity.ok(ApiResponse.<FileMediaResponse>builder()
                .success(true)
                .message("Tải tệp lên thành công")
                .data(data)
                .build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteFile(@PathVariable UUID id) {
        fileMediaService.deleteFile(id);
        return ResponseEntity.ok(ApiResponse.<Void>builder()
                .success(true)
                .message("Xóa tệp thành công")
                .build());
    }
}
