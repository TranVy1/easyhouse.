package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.FileMediaResponse;
import com.example.quanlyphongtro.entity.FileMedia;
import com.example.quanlyphongtro.entity.LoaiDoiTuongMedia;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.repository.FileMediaRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class FileMediaService {

    private final FileMediaRepository fileMediaRepository;
    private final CloudinaryService cloudinaryService;
    private final NguoiDungRepository nguoiDungRepository;

    @Transactional(readOnly = true)
    public List<FileMediaResponse> getAll() {
        return fileMediaRepository.findAll().stream()
                .map(FileMediaResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<FileMediaResponse> getByDoiTuong(String doiTuong, UUID doiTuongId) {
        LoaiDoiTuongMedia type = LoaiDoiTuongMedia.valueOf(doiTuong);
        return fileMediaRepository.findByDoiTuongAndDoiTuongIdOrderByTaoLucAsc(type, doiTuongId)
                .stream().map(FileMediaResponse::fromEntity).collect(Collectors.toList());
    }

    @Transactional
    public FileMediaResponse uploadFile(MultipartFile file, String doiTuong, UUID doiTuongId, String loaiFile, UUID nguoiDungId) throws IOException {
        Map<String, Object> result = cloudinaryService.uploadFile(file);
        
        FileMedia fileMedia = new FileMedia();
        fileMedia.setDoiTuong(LoaiDoiTuongMedia.valueOf(doiTuong));
        fileMedia.setDoiTuongId(doiTuongId);
        fileMedia.setUrl((String) result.get("secure_url"));
        fileMedia.setPublicId((String) result.get("public_id"));
        fileMedia.setLoaiFile(loaiFile != null ? loaiFile : file.getContentType());
        fileMedia.setKichThuocBytes(file.getSize());
        
        if (nguoiDungId != null) {
            NguoiDung u = nguoiDungRepository.findById(nguoiDungId).orElse(null);
            fileMedia.setNguoiTaiLen(u);
        }

        return FileMediaResponse.fromEntity(fileMediaRepository.save(fileMedia));
    }

    @Transactional
    public void deleteFile(UUID id) {
        FileMedia fileMedia = fileMediaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy file"));
        
        try {
            if (fileMedia.getPublicId() != null) {
                cloudinaryService.deleteFile(fileMedia.getPublicId());
            }
        } catch (Exception e) {
            log.warn("Cloudinary delete failed for public_id: {}, continuing to delete from DB", fileMedia.getPublicId(), e);
        }
        
        fileMediaRepository.delete(fileMedia);
    }
}
