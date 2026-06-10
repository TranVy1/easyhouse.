package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.*;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import java.time.ZonedDateTime;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DatCocPhongService {

    private final DatCocPhongRepository datCocPhongRepository;
    private final PhongRepository phongRepository;
    private final KhachThueRepository khachThueRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final HopDongService hopDongService;
    private final PermissionService permissionService;

    public List<DatCocPhongResponse> getAll(UUID nhaTroId) {
        UUID userId = permissionService.requireCurrentUserId();
        List<UUID> nhaTroIds = nhaTroId != null ? List.of(nhaTroId) : permissionService.getAllAccessibleNhaTroIds(userId);
        
        return datCocPhongRepository.findAll().stream()
                .filter(dc -> nhaTroIds == null || nhaTroIds.contains(dc.getPhong().getNhaTro().getId()))
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    public DatCocPhongResponse getById(UUID id) {
        DatCocPhong dc = datCocPhongRepository.findById(id).orElseThrow();
        if (!permissionService.canReadPhong(permissionService.requireCurrentUserId(), dc.getPhong().getId())) {
             throw new RuntimeException("Access denied");
        }
        return mapToResponse(dc);
    }

    @Transactional
    public DatCocPhongResponse create(DatCocPhongRequest request) {
        UUID userId = permissionService.requireCurrentUserId();
        if (!permissionService.canWritePhong(userId, request.getPhongId())) {
            throw new RuntimeException("Access denied");
        }

        Phong phong = phongRepository.findById(request.getPhongId()).orElseThrow();
        if (phong.getTrangThai() != TrangThaiPhong.AVAILABLE) {
            throw new RuntimeException("Phòng không ở trạng thái trống");
        }

        // Check active dat coc
        List<DatCocPhong> activeCocs = datCocPhongRepository.findByPhongIdAndTrangThaiIn(
                request.getPhongId(), List.of(TrangThaiDatCoc.PENDING, TrangThaiDatCoc.CONFIRMED));
        if (!activeCocs.isEmpty()) {
            throw new RuntimeException("Phòng đã có đặt cọc khác đang mở");
        }

        KhachThue khachThue = khachThueRepository.findById(request.getKhachThueId()).orElseThrow();

        DatCocPhong dc = new DatCocPhong();
        dc.setPhong(phong);
        dc.setKhachThue(khachThue);
        dc.setSoTienCoc(request.getSoTienCoc());
        dc.setNgayDuKienVao(request.getNgayDuKienVao());
        dc.setGhiChu(request.getGhiChu());
        dc.setTrangThai(TrangThaiDatCoc.PENDING);
        
        return mapToResponse(datCocPhongRepository.save(dc));
    }

    @Transactional
    public DatCocPhongResponse confirm(UUID id) {
        UUID userId = permissionService.requireCurrentUserId();
        DatCocPhong dc = datCocPhongRepository.findById(id).orElseThrow();
        if (!permissionService.canWritePhong(userId, dc.getPhong().getId())) {
            throw new RuntimeException("Access denied");
        }
        
        if (dc.getTrangThai() != TrangThaiDatCoc.PENDING) {
            throw new RuntimeException("Chỉ được confirm cọc trạng thái PENDING");
        }

        dc.setTrangThai(TrangThaiDatCoc.CONFIRMED);
        dc.setConfirmedAt(ZonedDateTime.now());
        dc.setNguoiXacNhan(nguoiDungRepository.findById(userId).orElseThrow());

        Phong p = dc.getPhong();
        if (p.getTrangThai() == TrangThaiPhong.AVAILABLE) {
             p.setTrangThai(TrangThaiPhong.RESERVED);
             phongRepository.save(p);
        }

        return mapToResponse(datCocPhongRepository.save(dc));
    }

    @Transactional
    public DatCocPhongResponse cancel(UUID id, CancelDatCocRequest req) {
        UUID userId = permissionService.requireCurrentUserId();
        DatCocPhong dc = datCocPhongRepository.findById(id).orElseThrow();
        if (!permissionService.canWritePhong(userId, dc.getPhong().getId())) {
            throw new RuntimeException("Access denied");
        }

        if (dc.getTrangThai() != TrangThaiDatCoc.PENDING && dc.getTrangThai() != TrangThaiDatCoc.CONFIRMED) {
            throw new RuntimeException("Không thể hủy đặt cọc ở trạng thái " + dc.getTrangThai());
        }

        dc.setTrangThai(req.getTrangThai()); // CANCELLED, REFUNDED or FORFEITED
        dc.setLyDoHuy(req.getLyDoHuy());
        dc.setCancelledAt(ZonedDateTime.now());
        dc.setNguoiXacNhan(nguoiDungRepository.findById(userId).orElseThrow());

        // Nếu phòng đang RESERVED và không còn cọc nào khác, trả lại AVAILABLE
        Phong p = dc.getPhong();
        if (p.getTrangThai() == TrangThaiPhong.RESERVED) {
            List<DatCocPhong> otherCocs = datCocPhongRepository.findByPhongIdAndTrangThaiIn(
                p.getId(), List.of(TrangThaiDatCoc.PENDING, TrangThaiDatCoc.CONFIRMED));
            if (otherCocs.size() <= 1) { // 1 is the current one being cancelled
                p.setTrangThai(TrangThaiPhong.AVAILABLE);
                phongRepository.save(p);
            }
        }

        return mapToResponse(datCocPhongRepository.save(dc));
    }

    @Transactional
    public DatCocPhongResponse convertToContract(UUID id, ConvertDatCocRequest request) {
        UUID userId = permissionService.requireCurrentUserId();
        DatCocPhong dc = datCocPhongRepository.findById(id).orElseThrow();
        if (!permissionService.canWritePhong(userId, dc.getPhong().getId())) {
            throw new RuntimeException("Access denied");
        }

        if (dc.getTrangThai() != TrangThaiDatCoc.CONFIRMED) {
            throw new RuntimeException("Chỉ được convert cọc trạng thái CONFIRMED");
        }

        HopDongResponse hdRes = hopDongService.create(request.getHopDongRequest());
        
        dc.setTrangThai(TrangThaiDatCoc.CONVERTED);
        // Load the contract to set it
        com.example.quanlyphongtro.entity.HopDong hd = new com.example.quanlyphongtro.entity.HopDong();
        hd.setId(hdRes.getId());
        dc.setHopDong(hd);

        return mapToResponse(datCocPhongRepository.save(dc));
    }

    private DatCocPhongResponse mapToResponse(DatCocPhong e) {
        return DatCocPhongResponse.builder()
                .id(e.getId())
                .phong(PhongResponse.builder().id(e.getPhong().getId()).ten(e.getPhong().getTen()).build())
                .khachThue(KhachThueResponse.builder().id(e.getKhachThue().getId()).hoTen(e.getKhachThue().getHoTen()).build())
                .hopDongId(e.getHopDong() != null ? e.getHopDong().getId() : null)
                .soTienCoc(e.getSoTienCoc())
                .ngayDatCoc(e.getNgayDatCoc())
                .ngayDuKienVao(e.getNgayDuKienVao())
                .trangThai(e.getTrangThai())
                .ghiChu(e.getGhiChu())
                .lyDoHuy(e.getLyDoHuy())
                .confirmedAt(e.getConfirmedAt())
                .cancelledAt(e.getCancelledAt())
                .nguoiXacNhanTen(e.getNguoiXacNhan() != null ? e.getNguoiXacNhan().getHoTen() : null)
                .build();
    }
}
