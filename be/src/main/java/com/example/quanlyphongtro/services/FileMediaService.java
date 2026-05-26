package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.FileMediaResponse;
import com.example.quanlyphongtro.entity.AuditLog;
import com.example.quanlyphongtro.entity.FileMedia;
import com.example.quanlyphongtro.entity.LoaiDoiTuongMedia;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.repository.AuditLogRepository;
import com.example.quanlyphongtro.repository.FileMediaRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import com.example.quanlyphongtro.services.PermissionService;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.ChiSoDienNuocRepository;
import com.example.quanlyphongtro.repository.ThanhToanRepository;
import com.example.quanlyphongtro.repository.SuCoRepository;
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
    private final PermissionService permissionService;
    private final PhongRepository phongRepository;
    private final ChiSoDienNuocRepository chiSoDienNuocRepository;
    private final ThanhToanRepository thanhToanRepository;
    private final SuCoRepository suCoRepository;
    private final AuditLogRepository auditLogRepository;

    @Transactional(readOnly = true)
    public List<FileMediaResponse> getAll() {
        permissionService.requireAdmin();
        return fileMediaRepository.findAll().stream()
                .map(FileMediaResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<FileMediaResponse> getByDoiTuong(String doiTuong, UUID doiTuongId) {
        LoaiDoiTuongMedia type = LoaiDoiTuongMedia.valueOf(doiTuong);
        checkReadPermission(type, doiTuongId);
        return fileMediaRepository.findByDoiTuongAndDoiTuongIdOrderByTaoLucAsc(type, doiTuongId)
                .stream().map(FileMediaResponse::fromEntity).collect(Collectors.toList());
    }

    @Transactional
    public FileMediaResponse uploadFile(MultipartFile file, String doiTuong, UUID doiTuongId, String loaiFile, UUID nguoiDungId) throws IOException {
        validateFile(file);
        checkPermission(LoaiDoiTuongMedia.valueOf(doiTuong), doiTuongId);
        Map<String, Object> result = cloudinaryService.uploadFile(file);
        
        FileMedia fileMedia = new FileMedia();
        fileMedia.setDoiTuong(LoaiDoiTuongMedia.valueOf(doiTuong));
        fileMedia.setDoiTuongId(doiTuongId);
        fileMedia.setUrl((String) result.get("secure_url"));
        fileMedia.setPublicId((String) result.get("public_id"));
        fileMedia.setLoaiFile(loaiFile != null ? loaiFile : file.getContentType());
        fileMedia.setKichThuocBytes(file.getSize());
        
        NguoiDung uploader = nguoiDungRepository.findById(permissionService.requireCurrentUserId())
                .orElseThrow(() -> new RuntimeException("Khong tim thay nguoi dung hien tai"));
        fileMedia.setNguoiTaiLen(uploader);

        FileMedia saved = fileMediaRepository.save(fileMedia);
        logAuditIfRequired(saved, "UPLOAD");
        return FileMediaResponse.fromEntity(saved);
    }

    @Transactional
    public void deleteFile(UUID id) {
        FileMedia fileMedia = fileMediaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy file"));
        checkPermission(fileMedia.getDoiTuong(), fileMedia.getDoiTuongId());
        
        try {
            if (fileMedia.getPublicId() != null) {
                cloudinaryService.deleteFile(fileMedia.getPublicId());
            }
        } catch (Exception e) {
            log.warn("Cloudinary delete failed for public_id: {}, continuing to delete from DB", fileMedia.getPublicId(), e);
        }
        
        fileMediaRepository.delete(fileMedia);
        logAuditIfRequired(fileMedia, "DELETE");
    }

    private void validateFile(MultipartFile file) {
        if (file.isEmpty()) {
            throw new RuntimeException("Tep khong duoc de trong");
        }
        if (file.getSize() > 10 * 1024 * 1024) {
            throw new RuntimeException("Tep qua lon. Kich thuoc toi da la 10MB");
        }
        String contentType = file.getContentType();
        if (contentType == null || (!contentType.startsWith("image/") && !contentType.startsWith("application/"))) {
            throw new RuntimeException("Loai tep khong duoc ho tro. Chi chap nhan anh va tai lieu");
        }
    }

    private void checkPermission(LoaiDoiTuongMedia type, UUID doiTuongId) {
        UUID userId = permissionService.requireCurrentUserId();
        switch (type) {
            case ROOM:
                if (!permissionService.canWritePhong(userId, doiTuongId)) throw new RuntimeException("Khong co quyen");
                break;
            case METER_READING:
                com.example.quanlyphongtro.entity.ChiSoDienNuoc reading = chiSoDienNuocRepository.findById(doiTuongId)
                        .orElseThrow(() -> new RuntimeException("Khong tim thay chi so"));
                if (reading.getPhong() == null || !permissionService.canWritePhong(userId, reading.getPhong().getId())) {
                    throw new RuntimeException("Khong co quyen");
                }
                break;
            case PAYMENT:
                com.example.quanlyphongtro.entity.ThanhToan payment = thanhToanRepository.findById(doiTuongId)
                        .orElseThrow(() -> new RuntimeException("Khong tim thay thanh toan"));
                if (payment.getHoaDon() == null || !permissionService.canWriteHoaDon(userId, payment.getHoaDon().getId())) {
                    throw new RuntimeException("Khong co quyen");
                }
                break;
            case INCIDENT:
                com.example.quanlyphongtro.entity.SuCo incident = suCoRepository.findById(doiTuongId)
                        .orElseThrow(() -> new RuntimeException("Khong tim thay su co"));
                if (incident.getPhong() == null || !permissionService.canWritePhong(userId, incident.getPhong().getId())) {
                    throw new RuntimeException("Khong co quyen");
                }
                break;

            default:
                permissionService.requireAdmin();
        }
    }
    
    private void checkReadPermission(LoaiDoiTuongMedia type, UUID doiTuongId) {
        UUID userId = permissionService.requireCurrentUserId();
        switch (type) {
            case ROOM:
                if (!permissionService.canReadPhong(userId, doiTuongId)) throw new RuntimeException("Khong co quyen");
                break;
            case METER_READING:
                com.example.quanlyphongtro.entity.ChiSoDienNuoc reading = chiSoDienNuocRepository.findById(doiTuongId)
                        .orElseThrow(() -> new RuntimeException("Khong tim thay chi so"));
                if (reading.getPhong() == null || !permissionService.canReadPhong(userId, reading.getPhong().getId())) {
                    throw new RuntimeException("Khong co quyen");
                }
                break;
            case PAYMENT:
                com.example.quanlyphongtro.entity.ThanhToan payment = thanhToanRepository.findById(doiTuongId)
                        .orElseThrow(() -> new RuntimeException("Khong tim thay thanh toan"));
                if (payment.getHoaDon() == null || !permissionService.canReadHoaDon(userId, payment.getHoaDon().getId())) {
                    throw new RuntimeException("Khong co quyen");
                }
                break;
            case INCIDENT:
                com.example.quanlyphongtro.entity.SuCo incident = suCoRepository.findById(doiTuongId)
                        .orElseThrow(() -> new RuntimeException("Khong tim thay su co"));
                if (incident.getPhong() == null || !permissionService.canReadPhong(userId, incident.getPhong().getId())) {
                    throw new RuntimeException("Khong co quyen");
                }
                break;
            default:
                permissionService.requireAdmin();
        }
    }

    private void logAuditIfRequired(FileMedia media, String action) {
        if (media.getDoiTuong() != LoaiDoiTuongMedia.METER_READING
                && media.getDoiTuong() != LoaiDoiTuongMedia.PAYMENT) {
            return;
        }
        auditLogRepository.save(AuditLog.builder()
                .nguoiDung(NguoiDung.builder().id(permissionService.requireCurrentUserId()).build())
                .hanhDong(action)
                .bangTacDong("file_media")
                .banGhiId(media.getId())
                .taoLuc(java.time.ZonedDateTime.now())
                .build());
    }
}
