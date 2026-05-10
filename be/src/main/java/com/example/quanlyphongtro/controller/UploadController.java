package com.example.quanlyphongtro.controller;

import com.example.quanlyphongtro.dto.ApiResponse;
import com.example.quanlyphongtro.services.CloudinaryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/upload")
@RequiredArgsConstructor
@Slf4j
public class UploadController {

    private final CloudinaryService cloudinaryService;

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<Map<String, Object>> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            log.info("Received upload request for file: {}", file.getOriginalFilename());

            // Validate file
            if (file.isEmpty()) {
                return ApiResponse.error("File không được để trống");
            }

            // Validate file size (max 10MB)
            if (file.getSize() > 10 * 1024 * 1024) {
                return ApiResponse.error("File quá lớn. Kích thước tối đa là 10MB");
            }

            // Validate file type
            String contentType = file.getContentType();
            if (contentType == null || (!contentType.startsWith("image/") && !contentType.startsWith("application/"))) {
                return ApiResponse.error("Loại file không được hỗ trợ. Chỉ chấp nhận ảnh và tài liệu");
            }

            // Upload to Cloudinary
            Map<String, Object> uploadResult = cloudinaryService.uploadFile(file);

            // Prepare response
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("url", uploadResult.get("url"));
            responseData.put("secure_url", uploadResult.get("secure_url"));
            responseData.put("public_id", uploadResult.get("public_id"));
            responseData.put("format", uploadResult.get("format"));
            responseData.put("bytes", uploadResult.get("bytes"));

            log.info("File uploaded successfully: {}", uploadResult.get("secure_url"));

            return ApiResponse.success(responseData, "Upload file thành công");

        } catch (Exception e) {
            log.error("Error uploading file", e);
            return ApiResponse.error("Lỗi upload file: " + e.getMessage());
        }
    }

    @DeleteMapping("/{publicId}")
    public ApiResponse<String> deleteFile(@PathVariable String publicId) {
        try {
            log.info("Received delete request for file: {}", publicId);

            String result = cloudinaryService.deleteFile(publicId);

            log.info("File deleted successfully: {}", publicId);

            return ApiResponse.success(result, "Xóa file thành công");

        } catch (Exception e) {
            log.error("Error deleting file", e);
            return ApiResponse.error("Lỗi xóa file: " + e.getMessage());
        }
    }

    @DeleteMapping
    public ApiResponse<String> deleteFileByQuery(@RequestParam("publicId") String publicId) {
        try {
            log.info("Received delete request by query for file: {}", publicId);

            String result = cloudinaryService.deleteFile(publicId);

            log.info("File deleted successfully by query: {}", publicId);

            return ApiResponse.success(result, "Xóa file thành công");

        } catch (Exception e) {
            log.error("Error deleting file by query", e);
            return ApiResponse.error("Lỗi xóa file: " + e.getMessage());
        }
    }
}
