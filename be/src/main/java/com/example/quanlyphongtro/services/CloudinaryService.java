package com.example.quanlyphongtro.services;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class CloudinaryService {

    private final Cloudinary cloudinary;

    public Map<String, Object> uploadFile(MultipartFile file) throws IOException {
        try {
            log.info("Uploading file to Cloudinary: {}", file.getOriginalFilename());

            Map<String, Object> uploadResult = cloudinary.uploader().upload(
                    file.getBytes(),
                    ObjectUtils.asMap(
                            "folder", "quanlyphongtro/",
                            "resource_type", "auto"));
            log.info("File uploaded successfully: {}", uploadResult.get("secure_url"));
            return uploadResult;

        } catch (Exception e) {
            log.error("Error uploading file to Cloudinary", e);
            throw new IOException("Tải tệp lên thất bại: " + e.getMessage(), e);
        }
    }

    public Map<String, Object> uploadImage(byte[] imageBytes, String fileName) throws IOException {
        try {
            log.info("Uploading image to Cloudinary: {}", fileName);

            Map<String, Object> uploadResult = cloudinary.uploader().upload(
                    imageBytes,
                    ObjectUtils.asMap(
                            "folder", "quanlyphongtro/images/",
                            "resource_type", "image",
                            "public_id", fileName.replaceAll("[^a-zA-Z0-9.-]", "_")));

            log.info("Image uploaded successfully: {}", uploadResult.get("secure_url"));
            return uploadResult;

        } catch (Exception e) {
            log.error("Error uploading image to Cloudinary", e);
            throw new IOException("Tải ảnh lên thất bại: " + e.getMessage(), e);
        }
    }

    public Map<String, Object> uploadPdf(byte[] pdfBytes, String fileName) throws IOException {
        try {
            log.info("Uploading PDF to Cloudinary: {}", fileName);

            String publicId = fileName
                    .replaceAll("[^a-zA-Z0-9.-]", "_")
                    .replaceAll("\\.pdf$", "");

            Map<String, Object> uploadResult = cloudinary.uploader().upload(
                    pdfBytes,
                    ObjectUtils.asMap(
                            "folder", "quanlyphongtro/contracts/",
                            "resource_type", "raw",
                            "public_id", publicId,
                            "overwrite", true));

            String url = uploadResult.get("secure_url").toString();
            log.info("PDF uploaded successfully: {}", url);

            return uploadResult;

        } catch (Exception e) {
            log.error("Error uploading PDF to Cloudinary", e);
            throw new IOException("Tải PDF lên thất bại: " + e.getMessage(), e);
        }
    }

    public String deleteFile(String publicId, String resourceType) throws IOException {
        try {
            log.info("Deleting file from Cloudinary: {} (type: {})", publicId, resourceType);

            Map<String, Object> deleteResult = cloudinary.uploader().destroy(
                    publicId,
                    ObjectUtils.asMap(
                            "resource_type", resourceType // image | raw | video
                    ));

            log.info("File deleted successfully: {}", deleteResult);
            return deleteResult.get("result").toString();

        } catch (Exception e) {
            log.error("Error deleting file from Cloudinary", e);
            throw new IOException("Xóa tệp thất bại: " + e.getMessage(), e);
        }
    }
}
