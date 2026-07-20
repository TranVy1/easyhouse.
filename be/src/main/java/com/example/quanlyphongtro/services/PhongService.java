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
import com.example.quanlyphongtro.repository.TangRepository;
import com.example.quanlyphongtro.repository.TaiSanPhongRepository;
import com.example.quanlyphongtro.entity.TaiSanPhong;
import com.example.quanlyphongtro.dto.TaiSanPhongDto;
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
    private final TangRepository tangRepository;
    private final MediaService mediaService;
    private final TienIchService tienIchService;
    private final PermissionService permissionService;
    private final TaiSanPhongRepository taiSanPhongRepository;

    public PaginatedResponse<PhongResponse> getAllPhong(String nhaTroId, String trangThaiStr, String search, int page, int limit, boolean simple) {
        TrangThaiPhong tt = parseTrangThai(trangThaiStr);
        UUID nid = parseUuid(nhaTroId);

        UUID userId = permissionService.currentUserId().orElse(null);
        boolean isAdmin = userId != null && permissionService.isAdmin(userId);
        List<UUID> nhaTroIds = List.of();
        if (!isAdmin && userId != null) {
            List<UUID> accessibleIds = permissionService.getAllAccessibleNhaTroIds(userId);
            if (accessibleIds != null && !accessibleIds.isEmpty()) {
                nhaTroIds = accessibleIds;
            }
        }

        String normalizedSearch = search != null && !search.isBlank() ? search.trim() : null;
        Pageable pageable = PageRequest.of(Math.max(0, page - 1), limit, Sort.by(Sort.Direction.DESC, "taoLuc"));
        Page<Phong> pageResult = phongRepository.findAllAccessible(
                nid, tt != null ? tt.name() : null, normalizedSearch, isAdmin, nhaTroIds, pageable);
        
        List<PhongResponse> mappedList = pageResult.getContent().stream().map(p -> this.toResponse(p, simple)).toList();
        return PaginatedResponse.of(pageResult, mappedList);
    }

    public PhongResponse getPhongById(UUID id) {
        Phong phong = phongRepository.findById(id).orElseThrow(() -> new RuntimeException("Khong tim thay phong"));
        permissionService.currentUserId().ifPresent(userId -> assertCanRead(phong, userId));
        return toResponse(phong, false);
    }

    public List<PhongResponse> getPhongByNhaTro(UUID nhaTroId) {
        return phongRepository.findByNhaTroIdAndXoaLucIsNull(nhaTroId).stream()
                .map(p -> toResponse(p, true))
                .toList();
    }

    public PaginatedResponse<com.example.quanlyphongtro.dto.PublicPhongSummaryResponse> getPublicAllPhong(
            String nhaTroId, String search, java.math.BigDecimal minGia, java.math.BigDecimal maxGia, java.math.BigDecimal minDienTich, int page, int limit) {
        UUID nid = parseUuid(nhaTroId);
        Pageable pageable = PageRequest.of(Math.max(0, page - 1), limit, Sort.by(Sort.Direction.DESC, "taoLuc"));
        Page<Phong> pageResult = phongRepository.findPublicRooms(nid, search, minGia, maxGia, minDienTich, pageable);
        
        List<com.example.quanlyphongtro.dto.PublicPhongSummaryResponse> mappedList = pageResult.getContent().stream()
                .map(p -> {
                    List<String> urls = mediaService.listUrls(LoaiDoiTuongMedia.ROOM, p.getId(), MediaService.ROOM_IMAGE);
                    String primary = urls.stream().findFirst().orElse(null);
                    return com.example.quanlyphongtro.dto.PublicPhongSummaryResponse.fromEntity(p, primary, tienIchService.listByPhong(p.getId()), urls);
                })
                .toList();
        return PaginatedResponse.of(pageResult, mappedList);
    }

    public com.example.quanlyphongtro.dto.PublicPhongDetailResponse getPublicPhongById(UUID id) {
        Phong phong = phongRepository.findByIdAndXoaLucIsNull(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay phong"));
        
        if (phong.getTrangThai() != TrangThaiPhong.AVAILABLE) {
            throw new RuntimeException("Phong nay hien khong kha dung de xem");
        }
        
        List<String> anhList = mediaService.listUrls(LoaiDoiTuongMedia.ROOM, phong.getId(), MediaService.ROOM_IMAGE);
        List<com.example.quanlyphongtro.dto.HopDongDichVuOptionResponse> dichVuList = List.of(); // Requires hopDongService, but we can't easily inject it without circular dependency if not careful. Alternatively we can fetch dich vu the same way HopDongService does, or leave it for now.
        // Let's use tienIchService which we have. For dich vu, let's leave it empty or map it if we can.
        
        return com.example.quanlyphongtro.dto.PublicPhongDetailResponse.fromEntity(phong, anhList, dichVuList, tienIchService.listByPhong(phong.getId()));
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
                .tangEntity(resolveTang(nt.getId(), req.getTangId(), req.getTang()))
                .dienTich(req.getDienTich())
                .giaHienTai(req.getGiaHienTai())
                .tienCocMacDinh(req.getTienCocMacDinh())
                .moTa(req.getMoTa())
                .soNguoiToiDa(req.getSoNguoiToiDa() != null ? req.getSoNguoiToiDa() : 2)
                .trangThai(parseTrangThai(req.getTrangThai()) != null ? parseTrangThai(req.getTrangThai()) : TrangThaiPhong.AVAILABLE)
                .build();
        
        Phong saved;
        try {
            saved = phongRepository.saveAndFlush(p);
        } catch (org.springframework.dao.DataIntegrityViolationException e) {
            throw new RuntimeException("Ten phong da ton tai trong toa nha nay");
        }
        
        mediaService.replaceUrls(LoaiDoiTuongMedia.ROOM, saved.getId(), req.getAnhPhong(), MediaService.ROOM_IMAGE);
        tienIchService.replacePhongTienIch(saved.getId(), req.getTienNghi());
        return toResponse(saved, false);
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
        if (req.getTangId() != null || req.getTang() != null) {
            p.setTangEntity(resolveTang(currentNhaTroId, req.getTangId(), p.getTang()));
        }
        if (req.getDienTich() != null) p.setDienTich(req.getDienTich());
        if (req.getGiaHienTai() != null) p.setGiaHienTai(req.getGiaHienTai());
        if (req.getTienCocMacDinh() != null) p.setTienCocMacDinh(req.getTienCocMacDinh());
        if (req.getMoTa() != null) p.setMoTa(req.getMoTa());
        if (req.getSoNguoiToiDa() != null) p.setSoNguoiToiDa(req.getSoNguoiToiDa());
        TrangThaiPhong tt = parseTrangThai(req.getTrangThai());
        if (tt != null) p.setTrangThai(tt);

        Phong saved;
        try {
            saved = phongRepository.saveAndFlush(p);
        } catch (org.springframework.dao.DataIntegrityViolationException e) {
            throw new RuntimeException("Ten phong da ton tai trong toa nha nay");
        }
        
        mediaService.replaceUrls(LoaiDoiTuongMedia.ROOM, saved.getId(), req.getAnhPhong(), MediaService.ROOM_IMAGE);
        tienIchService.replacePhongTienIch(saved.getId(), req.getTienNghi());
        return toResponse(saved, false);
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

    private PhongResponse toResponse(Phong phong, boolean simple) {
        if (simple) {
            PhongResponse response = PhongResponse.fromEntity(phong, null);
            response.setAnhPhong(List.of());
            response.setTienNghi(List.of());
            return response;
        }
        HopDong activeContract = hopDongRepository.findFirstByPhongIdAndTrangThaiOrderByTaoLucDesc(
                phong.getId(), TrangThaiHopDong.ACTIVE).orElse(null);
        PhongResponse response = PhongResponse.fromEntity(phong, activeContract);
        response.setAnhPhong(mediaService.listUrls(LoaiDoiTuongMedia.ROOM, phong.getId(), MediaService.ROOM_IMAGE));
        response.setTienNghi(tienIchService.listByPhong(phong.getId()));
        response.setTaiSanPhong(taiSanPhongRepository.findByPhongId(phong.getId()).stream()
                .map(this::mapTaiSanToDto).toList());
        return response;
    }

    private TaiSanPhongDto mapTaiSanToDto(TaiSanPhong entity) {
        return TaiSanPhongDto.builder()
                .id(entity.getId())
                .phongId(entity.getPhong().getId())
                .tenTaiSan(entity.getTenTaiSan())
                .soLuong(entity.getSoLuong())
                .giaTri(entity.getGiaTri())
                .tinhTrang(entity.getTinhTrang())
                .ghiChu(entity.getGhiChu())
                .build();
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

    private com.example.quanlyphongtro.entity.Tang resolveTang(UUID nhaTroId, UUID tangId, Integer soTang) {
        if (tangId != null) {
            com.example.quanlyphongtro.entity.Tang tang = tangRepository.findByIdAndXoaLucIsNull(tangId)
                    .orElseThrow(() -> new RuntimeException("Khong tim thay tang"));
            if (tang.getNhaTro() == null || !tang.getNhaTro().getId().equals(nhaTroId)) {
                throw new RuntimeException("Tang khong thuoc toa nha da chon");
            }
            return tang;
        }
        if (soTang != null) {
            return tangRepository.findByNhaTroIdAndSoTangAndXoaLucIsNull(nhaTroId, soTang).orElse(null);
        }
        return null;
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

    /**
     * Lookup phòng theo tên, hỗ trợ fuzzy: "101" có thể match "Phòng 101".
     * Trả về id + ten của phòng nếu tìm thấy.
     */
    public java.util.Map<String, Object> lookupPhongByName(UUID nhaTroId, String tenPhong) {
        if (nhaTroId == null || tenPhong == null || tenPhong.isBlank()) {
            throw new RuntimeException("nhaTroId và tenPhong không được để trống");
        }
        String trimmed = tenPhong.trim();
        java.util.Optional<Phong> phongOpt = phongRepository.findByNhaTroIdAndTenPhongFuzzy(nhaTroId, trimmed);
        return phongOpt.map(p -> {
            java.util.Map<String, Object> result = new java.util.HashMap<>();
            result.put("id", p.getId().toString());
            result.put("ten", p.getTen());
            result.put("found", true);
            return result;
        }).orElseGet(() -> {
            java.util.Map<String, Object> result = new java.util.HashMap<>();
            result.put("found", false);
            result.put("tenPhong", trimmed);
            return result;
        });
    }
}
