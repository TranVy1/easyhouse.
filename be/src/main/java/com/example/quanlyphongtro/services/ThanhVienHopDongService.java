package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.ThanhVienHopDongRequest;
import com.example.quanlyphongtro.dto.ThanhVienHopDongResponse;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.ThanhVienHopDong;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.ThanhVienHopDongRepository;
import com.example.quanlyphongtro.repository.AuditLogRepository;
import com.example.quanlyphongtro.entity.AuditLog;
import com.example.quanlyphongtro.entity.NguoiDung;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ThanhVienHopDongService {

    private final ThanhVienHopDongRepository thanhVienHopDongRepository;
    private final HopDongRepository hopDongRepository;
    private final PermissionService permissionService;
    private final AuditLogRepository auditLogRepository;

    public List<ThanhVienHopDongResponse> getMembersByHopDongId(UUID hopDongId) {
        HopDong hopDong = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        UUID userId = permissionService.requireCurrentUserId();
        if (!permissionService.canReadHopDong(userId, hopDongId)) {
            throw new RuntimeException("Bạn không có quyền xem thông tin hợp đồng này");
        }

        return thanhVienHopDongRepository.findByHopDongId(hopDongId).stream()
                .map(ThanhVienHopDongResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional
    public ThanhVienHopDongResponse addMember(UUID hopDongId, ThanhVienHopDongRequest request) {
        HopDong hopDong = hopDongRepository.findById(hopDongId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
        UUID userId = permissionService.requireCurrentUserId();
        if (!permissionService.canWriteHopDong(userId, hopDongId)) {
            throw new RuntimeException("Bạn không có quyền thêm thành viên vào hợp đồng này");
        }

        // Kiem tra so nguoi toi da cua phong
        long currentCount = thanhVienHopDongRepository.findByHopDongId(hopDongId).stream()
                .filter(m -> Boolean.TRUE.equals(m.getDangO()))
                .count();
        Integer maxPeople = hopDong.getPhong().getSoNguoiToiDa();
        if (maxPeople != null && currentCount >= maxPeople) {
            throw new RuntimeException("Phòng đã đạt số người ở tối đa (" + maxPeople + " người)");
        }

        LocalDate ngayVao = request.getNgayVao() != null ? request.getNgayVao() : LocalDate.now();
        boolean dangO = request.getDangO() == null || request.getDangO();
        LocalDate ngayRoi = request.getNgayRoi() != null ? request.getNgayRoi() : (dangO ? null : LocalDate.now());
        if (ngayRoi != null && ngayRoi.isBefore(ngayVao)) {
            throw new RuntimeException("Ngày rời đi không thể trước ngày vào ở");
        }
        ThanhVienHopDong member = ThanhVienHopDong.builder()
                .hopDong(hopDong)
                .hoTen(request.getHoTen().trim())
                .soCccd(request.getSoCccd() != null ? request.getSoCccd().trim() : null)
                .soDienThoai(request.getSoDienThoai() != null ? request.getSoDienThoai().trim() : null)
                .ngayVao(ngayVao)
                .ngayRoi(ngayRoi)
                .dangO(dangO)
                .laNguoiDaiDien(false)
                .ghiChu(request.getGhiChu())
                .build();

        return ThanhVienHopDongResponse.fromEntity(thanhVienHopDongRepository.save(member));
    }

    @Transactional
    public ThanhVienHopDongResponse updateMember(UUID id, ThanhVienHopDongRequest request) {
        ThanhVienHopDong member = thanhVienHopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thành viên"));
        UUID userId = permissionService.requireCurrentUserId();
        if (!permissionService.canWriteHopDong(userId, member.getHopDong().getId())) {
            throw new RuntimeException("Bạn không có quyền sửa thông tin thành viên này");
        }
        
        if (Boolean.TRUE.equals(member.getLaNguoiDaiDien())) {
            throw new RuntimeException("Không thể sửa thông tin người đại diện hợp đồng (đồng bộ từ thông tin khách thuê)");
        }

        member.setHoTen(request.getHoTen().trim());
        member.setSoCccd(request.getSoCccd() != null ? request.getSoCccd().trim() : null);
        member.setSoDienThoai(request.getSoDienThoai() != null ? request.getSoDienThoai().trim() : null);
        if (request.getNgayVao() != null) member.setNgayVao(request.getNgayVao());
        if (request.getDangO() != null) {
            if (Boolean.FALSE.equals(member.getDangO()) && Boolean.TRUE.equals(request.getDangO())) {
                // Kiểm tra lại số lượng tối đa nếu chuyển từ không ở sang đang ở
                long currentCount = thanhVienHopDongRepository.findByHopDongId(member.getHopDong().getId()).stream()
                        .filter(m -> Boolean.TRUE.equals(m.getDangO()) && !m.getId().equals(member.getId()))
                        .count();
                Integer maxPeople = member.getHopDong().getPhong().getSoNguoiToiDa();
                if (maxPeople != null && currentCount + 1 > maxPeople) {
                    throw new RuntimeException("Phòng đã đạt số người ở tối đa (" + maxPeople + " người)");
                }
            }
            member.setDangO(request.getDangO());
            if (Boolean.TRUE.equals(request.getDangO())) {
                member.setNgayRoi(null);
            } else {
                member.setNgayRoi(request.getNgayRoi() != null ? request.getNgayRoi() : LocalDate.now());
            }
        } else if (request.getNgayRoi() != null) {
            member.setNgayRoi(request.getNgayRoi());
            member.setDangO(false);
        }
        member.setGhiChu(request.getGhiChu());

        if (member.getNgayRoi() != null && member.getNgayRoi().isBefore(member.getNgayVao())) {
            throw new RuntimeException("Ngày rời đi không thể trước ngày vào ở");
        }

        return ThanhVienHopDongResponse.fromEntity(thanhVienHopDongRepository.save(member));
    }

    @Transactional
    public void removeMember(UUID id) {
        ThanhVienHopDong member = thanhVienHopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy thành viên"));
        UUID userId = permissionService.requireCurrentUserId();
        if (!permissionService.canWriteHopDong(userId, member.getHopDong().getId())) {
            throw new RuntimeException("Bạn không có quyền xóa thành viên này");
        }

        if (Boolean.TRUE.equals(member.getLaNguoiDaiDien())) {
            throw new RuntimeException("Không thể xóa người đại diện hợp đồng");
        }

        LocalDate ngayRoi = LocalDate.now();
        if (ngayRoi.isBefore(member.getNgayVao())) {
            ngayRoi = member.getNgayVao();
        }
        member.setNgayRoi(ngayRoi);
        member.setDangO(false);
        ThanhVienHopDong saved = thanhVienHopDongRepository.save(member);
        auditLogRepository.save(AuditLog.builder()
                .nguoiDung(NguoiDung.builder().id(userId).build())
                .hanhDong("LEAVE")
                .bangTacDong("thanh_vien_hop_dong")
                .banGhiId(saved.getId())
                .duLieuMoi("{\"ngayRoi\":\"" + ngayRoi + "\",\"dangO\":false}")
                .build());
    }
}
