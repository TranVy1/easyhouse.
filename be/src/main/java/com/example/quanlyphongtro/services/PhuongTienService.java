package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.*;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.time.LocalDate;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PhuongTienService {

    private final PhuongTienRepository phuongTienRepository;
    private final KhachThueRepository khachThueRepository;
    private final HopDongRepository hopDongRepository;
    private final PermissionService permissionService;
    private final LichSuPhuongTienRepository lichSuPhuongTienRepository;

    public PaginatedResponse<PhuongTienDto> getAll(String keyword, String nhaTroId, String phongId, String trangThai, int page, int limit) {
        UUID chuTroId = permissionService.currentUserId().orElseThrow(() -> new RuntimeException("Unauthorized"));
        // For simplicity in this implementation, we will fetch all by chuTroId and filter in memory, 
        // or we could write a Specification. Since we don't have a complex spec set up here, we filter manually or use basic queries.
        // A better approach is using Specification, but for now we fetch all and filter to ensure fast delivery.
        
        List<PhuongTien> all = phuongTienRepository.findAll().stream()
                .filter(pt -> pt.getChuTro().getId().equals(chuTroId))
                .collect(Collectors.toList());
                
        if (nhaTroId != null && !nhaTroId.equals("all") && !nhaTroId.isBlank()) {
            all = all.stream().filter(pt -> pt.getNhaTro() != null && pt.getNhaTro().getId().toString().equals(nhaTroId)).collect(Collectors.toList());
        }
        
        if (phongId != null && !phongId.equals("all") && !phongId.isBlank()) {
            all = all.stream().filter(pt -> pt.getPhong() != null && pt.getPhong().getId().toString().equals(phongId)).collect(Collectors.toList());
        }
        
        if (trangThai != null && !trangThai.equals("all") && !trangThai.isBlank()) {
            all = all.stream().filter(pt -> pt.getTrangThai() != null && pt.getTrangThai().name().equals(trangThai)).collect(Collectors.toList());
        }
        
        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.toLowerCase();
            all = all.stream().filter(pt -> 
                (pt.getBienSo() != null && pt.getBienSo().toLowerCase().contains(kw)) ||
                (pt.getMaPt() != null && pt.getMaPt().toLowerCase().contains(kw)) ||
                (pt.getLoaiXe() != null && pt.getLoaiXe().toLowerCase().contains(kw))
            ).collect(Collectors.toList());
        }
        
        all.sort((a, b) -> {
            if (a.getCreatedAt() == null && b.getCreatedAt() == null) return 0;
            if (a.getCreatedAt() == null) return 1; // nulls last
            if (b.getCreatedAt() == null) return -1;
            return b.getCreatedAt().compareTo(a.getCreatedAt());
        });
        
        int start = Math.max(0, (page - 1) * limit);
        int end = Math.min(start + limit, all.size());
        List<PhuongTienDto> content = all.subList(start, end).stream().map(this::mapToDto).collect(Collectors.toList());
        
        return new PaginatedResponse<>(
                content,
                all.size(),
                page,
                limit,
                (int) Math.ceil((double) all.size() / limit)
        );
    }

    @Transactional
    public PhuongTienDto create(PhuongTienRequest request) {
        UUID chuTroId = permissionService.currentUserId().orElseThrow(() -> new RuntimeException("Unauthorized"));
        NguoiDung chuTro = new NguoiDung();
        chuTro.setId(chuTroId);
        
        PhuongTien pt = new PhuongTien();
        
        if (request.getMaPt() == null || request.getMaPt().isBlank()) {
            pt.setMaPt("PT" + System.currentTimeMillis());
        } else {
            if (phuongTienRepository.existsByMaPtAndChuTroId(request.getMaPt(), chuTroId)) {
                throw new RuntimeException("Mã phương tiện đã tồn tại");
            }
            pt.setMaPt(request.getMaPt());
        }
        
        if (request.getBienSo() != null && !request.getBienSo().isBlank()) {
            if (phuongTienRepository.existsByBienSoAndTrangThaiAndChuTroId(request.getBienSo(), TrangThaiPhuongTien.HIEU_LUC, chuTroId)) {
                throw new RuntimeException("Biển số xe đã được sử dụng và đang hiệu lực");
            }
        }
        pt.setLoaiXe(request.getLoaiXe());
        pt.setBienSo(request.getBienSo());
        pt.setTrangThai(request.getTrangThai());
        pt.setAnhXe(request.getAnhXe());
        pt.setLoaiPhuongTien(request.getLoaiPhuongTien());
        pt.setTenDongXe(request.getTenDongXe());
        pt.setMauXe(request.getMauXe());
        pt.setTenChuXe(request.getTenChuXe());
        pt.setSoVeXe(request.getSoVeXe());
        applyEffectiveDates(pt, request);
        pt.setChuTro(chuTro);
        
        assignCurrentResidence(pt, request.getKhachThueId(), chuTroId);
        
        PhuongTien saved = phuongTienRepository.save(pt);
        recordAssignment(saved);
        return mapToDto(saved);
    }

    @Transactional
    public PhuongTienDto update(UUID id, PhuongTienRequest request) {
        UUID chuTroId = permissionService.currentUserId().orElseThrow(() -> new RuntimeException("Unauthorized"));
        PhuongTien pt = phuongTienRepository.findByIdAndChuTroId(id, chuTroId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phương tiện"));
                
        if (request.getMaPt() != null && !request.getMaPt().isBlank() && !request.getMaPt().equals(pt.getMaPt())) {
            if (phuongTienRepository.existsByMaPtAndChuTroId(request.getMaPt(), chuTroId)) {
                throw new RuntimeException("Mã phương tiện đã tồn tại");
            }
            pt.setMaPt(request.getMaPt());
        }
        
        if (request.getBienSo() != null && !request.getBienSo().isBlank() && !request.getBienSo().equals(pt.getBienSo())) {
            if (phuongTienRepository.existsByBienSoAndTrangThaiAndChuTroId(request.getBienSo(), TrangThaiPhuongTien.HIEU_LUC, chuTroId)) {
                throw new RuntimeException("Biển số xe đã được sử dụng và đang hiệu lực");
            }
        }
        pt.setLoaiXe(request.getLoaiXe());
        pt.setBienSo(request.getBienSo());
        pt.setTrangThai(request.getTrangThai());
        pt.setAnhXe(request.getAnhXe());
        pt.setLoaiPhuongTien(request.getLoaiPhuongTien());
        pt.setTenDongXe(request.getTenDongXe());
        pt.setMauXe(request.getMauXe());
        pt.setTenChuXe(request.getTenChuXe());
        pt.setSoVeXe(request.getSoVeXe());
        applyEffectiveDates(pt, request);
        
        assignCurrentResidence(pt, request.getKhachThueId(), chuTroId);
        
        PhuongTien saved = phuongTienRepository.save(pt);
        recordAssignment(saved);
        return mapToDto(saved);
    }

    @Transactional
    public void delete(UUID id) {
        UUID chuTroId = permissionService.currentUserId().orElseThrow(() -> new RuntimeException("Unauthorized"));
        PhuongTien pt = phuongTienRepository.findByIdAndChuTroId(id, chuTroId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phương tiện"));
        pt.setTrangThai(TrangThaiPhuongTien.HET_HIEU_LUC);
        if (pt.getHieuLucDen() == null || pt.getHieuLucDen().isAfter(LocalDate.now())) {
            pt.setHieuLucDen(LocalDate.now());
        }
        phuongTienRepository.save(pt);
        lichSuPhuongTienRepository.findFirstByPhuongTienIdAndHieuLucDenIsNullOrderByHieuLucTuDesc(pt.getId())
                .ifPresent(history -> {
                    LocalDate end = pt.getHieuLucDen();
                    if (end.isBefore(history.getHieuLucTu())) end = history.getHieuLucTu();
                    history.setHieuLucDen(end);
                    lichSuPhuongTienRepository.save(history);
                });
    }

    /**
     * A vehicle always follows the tenant's current active contract.  Do not
     * accept room/building IDs from the client: they can be stale or unrelated
     * to the selected tenant.
     */
    private void assignCurrentResidence(PhuongTien pt, UUID khachThueId, UUID userId) {
        KhachThue khachThue = khachThueRepository.findById(khachThueId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy khách thuê"));
        HopDong hopDong = hopDongRepository
                .findByKhachThueIdAndTrangThaiAndXoaLucIsNullOrderByTaoLucDesc(khachThueId, TrangThaiHopDong.ACTIVE)
                .stream()
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Khách thuê chưa có hợp đồng đang hiệu lực"));

        Phong phong = hopDong.getPhong();
        if (phong == null || phong.getNhaTro() == null) {
            throw new RuntimeException("Hợp đồng của khách thuê chưa có thông tin phòng/tòa nhà");
        }
        if (!permissionService.canWritePhong(userId, phong.getId())) {
            throw new RuntimeException("Bạn không có quyền quản lý phương tiện tại phòng này");
        }

        pt.setKhachThue(khachThue);
        pt.setPhong(phong);
        pt.setNhaTro(phong.getNhaTro());
    }

    private void applyEffectiveDates(PhuongTien pt, PhuongTienRequest request) {
        LocalDate start = request.getHieuLucTu() != null ? request.getHieuLucTu()
                : (pt.getHieuLucTu() != null ? pt.getHieuLucTu() : LocalDate.now());
        LocalDate end = request.getHieuLucDen();
        if (end != null && end.isBefore(start)) {
            throw new RuntimeException("Ngày hết hiệu lực xe không được trước ngày bắt đầu hiệu lực");
        }
        if (request.getTrangThai() == TrangThaiPhuongTien.HET_HIEU_LUC && end == null) end = LocalDate.now();
        pt.setHieuLucTu(start);
        pt.setHieuLucDen(end);
    }

    private void recordAssignment(PhuongTien pt) {
        LichSuPhuongTien current = lichSuPhuongTienRepository
                .findFirstByPhuongTienIdAndHieuLucDenIsNullOrderByHieuLucTuDesc(pt.getId()).orElse(null);
        if (current != null && current.getPhong().getId().equals(pt.getPhong().getId())
                && current.getKhachThue().getId().equals(pt.getKhachThue().getId())) {
            current.setHieuLucTu(pt.getHieuLucTu());
            current.setHieuLucDen(pt.getHieuLucDen());
            lichSuPhuongTienRepository.save(current);
            return;
        }
        if (current != null) {
            if (pt.getHieuLucTu().isBefore(current.getHieuLucTu())) {
                throw new RuntimeException("Ngày hiệu lực khi chuyển xe phải từ ngày bắt đầu lịch sử hiện tại trở đi");
            }
            LocalDate end = pt.getHieuLucTu().minusDays(1);
            if (end.isBefore(current.getHieuLucTu())) end = current.getHieuLucTu();
            current.setHieuLucDen(end);
            lichSuPhuongTienRepository.save(current);
        }
        lichSuPhuongTienRepository.save(LichSuPhuongTien.builder().phuongTien(pt).khachThue(pt.getKhachThue())
                .phong(pt.getPhong()).nhaTro(pt.getNhaTro()).hieuLucTu(pt.getHieuLucTu())
                .hieuLucDen(pt.getHieuLucDen()).build());
    }
    
    private PhuongTienDto mapToDto(PhuongTien entity) {
        PhuongTienDto dto = new PhuongTienDto();
        dto.setId(entity.getId());
        dto.setMaPt(entity.getMaPt());
        dto.setLoaiXe(entity.getLoaiXe());
        dto.setBienSo(entity.getBienSo());
        dto.setTrangThai(entity.getTrangThai());
        dto.setAnhXe(entity.getAnhXe());
        dto.setLoaiPhuongTien(entity.getLoaiPhuongTien());
        dto.setTenDongXe(entity.getTenDongXe());
        dto.setMauXe(entity.getMauXe());
        dto.setTenChuXe(entity.getTenChuXe());
        dto.setSoVeXe(entity.getSoVeXe());
        dto.setHieuLucTu(entity.getHieuLucTu());
        dto.setHieuLucDen(entity.getHieuLucDen());
        dto.setCreatedAt(entity.getCreatedAt());
        dto.setUpdatedAt(entity.getUpdatedAt());
        
        if (entity.getNhaTro() != null) {
            dto.setNhaTroId(entity.getNhaTro().getId());
            dto.setNhaTro(NhaTroResponse.builder()
                    .id(entity.getNhaTro().getId())
                    .tenToaNha(entity.getNhaTro().getTen())
                    .build());
        }
        
        if (entity.getPhong() != null) {
            dto.setPhongId(entity.getPhong().getId());
            dto.setPhong(PhongResponse.builder()
                    .id(entity.getPhong().getId())
                    .ten(entity.getPhong().getTen())
                    .build());
        }
        
        if (entity.getKhachThue() != null) {
            dto.setKhachThueId(entity.getKhachThue().getId());
            dto.setKhachThue(KhachThueResponse.builder()
                    .id(entity.getKhachThue().getId())
                    .hoTen(entity.getKhachThue().getHoTen())
                    .build());
        }
        
        return dto;
    }
}
