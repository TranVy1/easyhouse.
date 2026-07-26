package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.ThanhVienHopDongRequest;
import com.example.quanlyphongtro.dto.YeuCauOGhepRequest;
import com.example.quanlyphongtro.dto.YeuCauOGhepResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import com.example.quanlyphongtro.repository.YeuCauOGhepRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class YeuCauOGhepService {

    private final YeuCauOGhepRepository yeuCauOGhepRepository;
    private final HopDongRepository hopDongRepository;
    private final KhachThueRepository khachThueRepository;
    private final ThanhVienHopDongService thanhVienHopDongService;
    private final PermissionService permissionService;
    private final ThongBaoService thongBaoService;

    @Transactional
    public YeuCauOGhepResponse createYeuCau(YeuCauOGhepRequest request) {
        UUID userId = permissionService.requireCurrentUserId();
        
        // Tìm khách thuê liên kết với user hiện tại
        KhachThue khachThue = khachThueRepository.findByNguoiDungId(userId)
                .orElseThrow(() -> new RuntimeException("Bạn chưa có hồ sơ khách thuê"));

        HopDong hopDong = hopDongRepository.findById(request.getHopDongId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));

        if (hopDong.getTrangThai() != TrangThaiHopDong.ACTIVE && hopDong.getTrangThai() != TrangThaiHopDong.PENDING) {
            throw new RuntimeException("Hợp đồng không hợp lệ để xin ở ghép");
        }

        YeuCauOGhep yeuCau = YeuCauOGhep.builder()
                .khachThue(khachThue)
                .hopDong(hopDong)
                .trangThai(TrangThaiYeuCauOGhep.PENDING_TENANT)
                .loiNhan(request.getLoiNhan())
                .build();

        yeuCau = yeuCauOGhepRepository.save(yeuCau);

        // Gửi thông báo cho người đại diện phòng
        if (hopDong.getKhachThue() != null) {
            thongBaoService.createSystemNotification(
                    "Có người xin ở ghép",
                    "Khách thuê " + khachThue.getHoTen() + " muốn xin ở ghép vào phòng của bạn. Vui lòng kiểm tra và phản hồi.",
                    LoaiThongBao.SYSTEM,
                    List.of(hopDong.getKhachThue().getId())
            );
        }

        return YeuCauOGhepResponse.fromEntity(yeuCau);
    }

    @Transactional
    public YeuCauOGhepResponse tenantApprove(UUID id, boolean isApprove, String ghiChu) {
        YeuCauOGhep yeuCau = yeuCauOGhepRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy yêu cầu"));

        UUID userId = permissionService.requireCurrentUserId();
        
        // Kiểm tra xem người duyệt có phải là đại diện của hợp đồng không
        if (!yeuCau.getHopDong().getKhachThue().getNguoiDung().getId().equals(userId)) {
            throw new RuntimeException("Bạn không phải là đại diện của phòng này");
        }

        if (yeuCau.getTrangThai() != TrangThaiYeuCauOGhep.PENDING_TENANT) {
            throw new RuntimeException("Yêu cầu không ở trạng thái chờ khách thuê duyệt");
        }

        if (isApprove) {
            yeuCau.setTrangThai(TrangThaiYeuCauOGhep.PENDING_ADMIN);
            // Gửi thông báo cho admin (chủ trọ)
            if (yeuCau.getHopDong().getPhong() != null && yeuCau.getHopDong().getPhong().getNhaTro() != null && yeuCau.getHopDong().getPhong().getNhaTro().getChuTro() != null) {
                thongBaoService.createSystemNotification(
                        "Yêu cầu ở ghép cần duyệt",
                        "Phòng " + yeuCau.getHopDong().getPhong().getTen() + " có yêu cầu ở ghép mới đã được đại diện phòng đồng ý. Vui lòng kiểm tra và duyệt.",
                        LoaiThongBao.SYSTEM,
                        List.of(yeuCau.getHopDong().getPhong().getNhaTro().getChuTro().getId())
                );
            }
        } else {
            yeuCau.setTrangThai(TrangThaiYeuCauOGhep.REJECTED);
            yeuCau.setGhiChuTuChoi(ghiChu);
        }

        return YeuCauOGhepResponse.fromEntity(yeuCauOGhepRepository.save(yeuCau));
    }

    @Transactional
    public YeuCauOGhepResponse adminApprove(UUID id, boolean isApprove, String ghiChu) {
        YeuCauOGhep yeuCau = yeuCauOGhepRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy yêu cầu"));

        UUID userId = permissionService.requireCurrentUserId();
        
        // Admin duyệt
        if (!permissionService.isAdmin(userId) && !permissionService.canWriteHopDong(userId, yeuCau.getHopDong().getId())) {
            throw new RuntimeException("Bạn không có quyền duyệt yêu cầu này");
        }

        if (yeuCau.getTrangThai() != TrangThaiYeuCauOGhep.PENDING_ADMIN) {
            throw new RuntimeException("Yêu cầu không ở trạng thái chờ chủ trọ duyệt");
        }

        if (isApprove) {
            yeuCau.setTrangThai(TrangThaiYeuCauOGhep.APPROVED);
            
            // Thêm người vào phòng
            ThanhVienHopDongRequest req = new ThanhVienHopDongRequest();
            req.setHoTen(yeuCau.getKhachThue().getHoTen());
            req.setSoCccd(yeuCau.getKhachThue().getSoCccd());
            req.setSoDienThoai(yeuCau.getKhachThue().getSoDienThoai());
            req.setNgayVao(LocalDate.now());
            req.setDangO(true);
            req.setGhiChu("Tham gia qua luồng xin ở ghép");
            
            thanhVienHopDongService.addMember(yeuCau.getHopDong().getId(), req);

            thongBaoService.createSystemNotification(
                    "Đăng ký ở ghép thành công",
                    "Yêu cầu ở ghép vào phòng " + yeuCau.getHopDong().getPhong().getTen() + " của bạn đã được duyệt.",
                    LoaiThongBao.SYSTEM,
                    List.of(yeuCau.getKhachThue().getId())
            );
        } else {
            yeuCau.setTrangThai(TrangThaiYeuCauOGhep.REJECTED);
            yeuCau.setGhiChuTuChoi(ghiChu);
        }

        return YeuCauOGhepResponse.fromEntity(yeuCauOGhepRepository.save(yeuCau));
    }

    @Transactional(readOnly = true)
    public List<YeuCauOGhepResponse> getMyRequests() {
        UUID userId = permissionService.requireCurrentUserId();
        KhachThue khachThue = khachThueRepository.findByNguoiDungId(userId).orElse(null);
        if (khachThue == null) return List.of();
        
        return yeuCauOGhepRepository.findByKhachThueIdOrderByTaoLucDesc(khachThue.getId()).stream()
                .map(YeuCauOGhepResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<YeuCauOGhepResponse> getRequestsForMyRoom(UUID hopDongId) {
        UUID userId = permissionService.requireCurrentUserId();
        HopDong hopDong = hopDongRepository.findById(hopDongId).orElseThrow(() -> new RuntimeException("Không tìm thấy"));
        if (!hopDong.getKhachThue().getNguoiDung().getId().equals(userId)) {
            throw new RuntimeException("Bạn không phải đại diện phòng này");
        }
        return yeuCauOGhepRepository.findByHopDongIdOrderByTaoLucDesc(hopDongId).stream()
                .map(YeuCauOGhepResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<YeuCauOGhepResponse> getRequestsForAdmin(UUID nhaTroId) {
        UUID userId = permissionService.requireCurrentUserId();
        if (!permissionService.isAdmin(userId) && !permissionService.getAllAccessibleNhaTroIds(userId).contains(nhaTroId)) {
            throw new RuntimeException("Bạn không có quyền xem yêu cầu này");
        }
        return yeuCauOGhepRepository.findByNhaTroId(nhaTroId).stream()
                .map(YeuCauOGhepResponse::fromEntity)
                .collect(Collectors.toList());
    }
}
