package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.PhongRequest;
import com.example.quanlyphongtro.dto.PhongResponse;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.LoaiDoiTuongMedia;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.TrangThaiHopDong;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PhongService {

    private final PhongRepository phongRepository;
    private final NhaTroRepository nhaTroRepository;
    private final HopDongRepository hopDongRepository;
    private final MediaService mediaService;
    private final TienIchService tienIchService;
    private final PermissionService permissionService;

    public PaginatedResponse<PhongResponse> getAllPhong(String nhaTroId, String trangThaiStr, int page, int limit) {
        TrangThaiPhong tt = parseTrangThai(trangThaiStr);
        UUID nid = parseUuid(nhaTroId);

        UUID userId = permissionService.currentUserId().orElse(null);
        boolean isAdmin = userId != null && permissionService.isAdmin(userId);
        List<UUID> nhaTroIds = List.of();
        if (!isAdmin && userId != null) {
            List<UUID> accessibleIds = permissionService.getAllAccessibleNhaTroIds(userId);
            if (!accessibleIds.isEmpty()) {
                nhaTroIds = accessibleIds;
            }
        }

        Pageable pageable = PageRequest.of(Math.max(0, page - 1), limit, Sort.by(Sort.Direction.DESC, "taoLuc"));
        Page<Phong> pageResult = phongRepository.findAllAccessible(
                nid, tt != null ? tt.name() : null, isAdmin, nhaTroIds, pageable);
        
        List<PhongResponse> mappedList = pageResult.getContent().stream().map(this::toResponse).toList();
        return PaginatedResponse.of(pageResult, mappedList);
    }

    public PhongResponse getPhongById(UUID id) {
        Phong phong = phongRepository.findById(id).orElseThrow(() -> new RuntimeException("Khong tim thay phong"));
        permissionService.currentUserId().ifPresent(userId -> assertCanRead(phong, userId));
        return toResponse(phong);
    }

    public List<PhongResponse> getPublicAllPhong(String nhaTroId, String trangThaiStr) {
        TrangThaiPhong tt = parseTrangThai(trangThaiStr);
        UUID nid = parseUuid(nhaTroId);

        List<Phong> list;
        if (nid != null && tt != null) list = phongRepository.findByNhaTroIdAndTrangThaiAndXoaLucIsNull(nid, tt);
        else if (nid != null) list = phongRepository.findByNhaTroIdAndXoaLucIsNull(nid);
        else if (tt != null) list = phongRepository.findByTrangThaiAndXoaLucIsNull(tt);
        else list = phongRepository.findByXoaLucIsNull();

        return list.stream().map(this::toResponse).toList();
    }

    public PhongResponse getPublicPhongById(UUID id) {
        Phong phong = phongRepository.findById(id).orElseThrow(() -> new RuntimeException("Khong tim thay phong"));
        return toResponse(phong);
    }

    @Transactional
    public PhongResponse createPhong(PhongRequest req) {
        NhaTro nt = nhaTroRepository.findById(req.getNhaTroId())
                .orElseThrow(() -> new RuntimeException("Khong tim thay nha tro"));
        assertCanWrite(nt, permissionService.requireCurrentUserId());

        if (phongRepository.existsByNhaTroIdAndTen(nt.getId(), req.getTen())) {
            throw new RuntimeException("Ten phong da ton tai trong toa nha nay");
        }

        Phong p = Phong.builder()
                .nhaTro(nt)
                .ten(req.getTen())
                .khuVuc(req.getKhuVuc())
                .tang(req.getTang())
                .dienTich(req.getDienTich())
                .giaHienTai(req.getGiaHienTai())
                .tienCocMacDinh(req.getTienCocMacDinh())
                .moTa(req.getMoTa())
                .soNguoiToiDa(req.getSoNguoiToiDa() != null ? req.getSoNguoiToiDa() : 2)
                .trangThai(parseTrangThai(req.getTrangThai()) != null ? parseTrangThai(req.getTrangThai()) : TrangThaiPhong.AVAILABLE)
                .build();
        Phong saved = phongRepository.saveAndFlush(p);
        mediaService.replaceUrls(LoaiDoiTuongMedia.ROOM, saved.getId(), req.getAnhPhong(), MediaService.ROOM_IMAGE);
        tienIchService.replacePhongTienIch(saved.getId(), req.getTienNghi());
        return toResponse(saved);
    }

    @Transactional
    public PhongResponse updatePhong(UUID id, PhongRequest req) {
        Phong p = phongRepository.findById(id).orElseThrow(() -> new RuntimeException("Khong tim thay phong"));
        assertCanWrite(p.getNhaTro(), permissionService.requireCurrentUserId());
        UUID currentNhaTroId = p.getNhaTro().getId();

        if (req.getNhaTroId() != null) {
            NhaTro nt = nhaTroRepository.findById(req.getNhaTroId())
                    .orElseThrow(() -> new RuntimeException("Khong tim thay nha tro"));
            assertCanWrite(nt, permissionService.requireCurrentUserId());
            p.setNhaTro(nt);
            currentNhaTroId = nt.getId();
        }

        if (req.getTen() != null) {
            if (phongRepository.existsByNhaTroIdAndTenAndIdNot(currentNhaTroId, req.getTen(), id)) {
                throw new RuntimeException("Ten phong da ton tai trong toa nha nay");
            }
            p.setTen(req.getTen());
        }

        if (req.getKhuVuc() != null) p.setKhuVuc(req.getKhuVuc());
        if (req.getTang() != null) p.setTang(req.getTang());
        if (req.getDienTich() != null) p.setDienTich(req.getDienTich());
        if (req.getGiaHienTai() != null) p.setGiaHienTai(req.getGiaHienTai());
        if (req.getTienCocMacDinh() != null) p.setTienCocMacDinh(req.getTienCocMacDinh());
        if (req.getMoTa() != null) p.setMoTa(req.getMoTa());
        if (req.getSoNguoiToiDa() != null) p.setSoNguoiToiDa(req.getSoNguoiToiDa());
        TrangThaiPhong tt = parseTrangThai(req.getTrangThai());
        if (tt != null) p.setTrangThai(tt);

        Phong saved = phongRepository.saveAndFlush(p);
        mediaService.replaceUrls(LoaiDoiTuongMedia.ROOM, saved.getId(), req.getAnhPhong(), MediaService.ROOM_IMAGE);
        tienIchService.replacePhongTienIch(saved.getId(), req.getTienNghi());
        return toResponse(saved);
    }

    @Transactional
    public void deletePhong(UUID id) {
        Phong p = phongRepository.findById(id).orElseThrow(() -> new RuntimeException("Khong tim thay phong"));
        assertCanWrite(p.getNhaTro(), permissionService.requireCurrentUserId());
        boolean hasOccupyingContracts = !hopDongRepository.findRoomOccupyingContracts(
                id, List.of(TrangThaiHopDong.PENDING, TrangThaiHopDong.ACTIVE)).isEmpty();
        if (hasOccupyingContracts) {
            throw new RuntimeException("Khong the xoa phong dang co hop dong hoat dong");
        }
        p.setXoaLuc(ZonedDateTime.now());
        phongRepository.save(p);
    }

    private PhongResponse toResponse(Phong phong) {
        HopDong activeContract = hopDongRepository.findFirstByPhongIdAndTrangThaiOrderByTaoLucDesc(
                phong.getId(), TrangThaiHopDong.ACTIVE).orElse(null);
        PhongResponse response = PhongResponse.fromEntity(phong, activeContract);
        response.setAnhPhong(mediaService.listUrls(LoaiDoiTuongMedia.ROOM, phong.getId(), MediaService.ROOM_IMAGE));
        response.setTienNghi(tienIchService.listByPhong(phong.getId()));
        return response;
    }

    private void assertCanRead(Phong phong, UUID userId) {
        if (!canReadPhong(phong, userId)) {
            throw new RuntimeException("Ban khong co quyen xem phong nay");
        }
    }

    private boolean canReadPhong(Phong phong, UUID userId) {
        NhaTro nhaTro = phong.getNhaTro();
        return nhaTro != null && permissionService.canReadNhaTro(userId, nhaTro.getId(), ownerId(nhaTro));
    }

    private void assertCanWrite(NhaTro nhaTro, UUID userId) {
        if (nhaTro == null || !permissionService.canWriteNhaTro(userId, nhaTro.getId(), ownerId(nhaTro))) {
            throw new RuntimeException("Ban khong co quyen sua phong trong nha tro nay");
        }
    }

    private UUID ownerId(NhaTro nhaTro) {
        return nhaTro.getChuTro() != null ? nhaTro.getChuTro().getId() : null;
    }

    private TrangThaiPhong parseTrangThai(String s) {
        if (s == null || s.equals("all")) return null;
        if (s.equals("trong") || s.equalsIgnoreCase("AVAILABLE")) return TrangThaiPhong.AVAILABLE;
        if (s.equals("daDat") || s.equalsIgnoreCase("RESERVED")) return TrangThaiPhong.RESERVED;
        if (s.equals("dangThue") || s.equalsIgnoreCase("RENTED")) return TrangThaiPhong.RENTED;
        if (s.equals("baoTri") || s.equalsIgnoreCase("MAINTENANCE")) return TrangThaiPhong.MAINTENANCE;
        if (s.equals("ngungHoatDong") || s.equalsIgnoreCase("INACTIVE")) return TrangThaiPhong.INACTIVE;
        try { return TrangThaiPhong.valueOf(s.toUpperCase()); } catch (Exception e) { return null; }
    }

    private UUID parseUuid(String s) {
        if (s == null || s.isBlank() || s.equals("all")) return null;
        try { return UUID.fromString(s); } catch (Exception e) { return null; }
    }
}
