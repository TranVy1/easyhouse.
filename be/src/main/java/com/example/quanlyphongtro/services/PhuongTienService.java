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
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PhuongTienService {

    private final PhuongTienRepository phuongTienRepository;
    private final KhachThueRepository khachThueRepository;
    private final PhongRepository phongRepository;
    private final NhaTroRepository nhaTroRepository;
    private final PermissionService permissionService;

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
        pt.setChuTro(chuTro);
        
        if (request.getNhaTroId() != null) {
            pt.setNhaTro(nhaTroRepository.findById(request.getNhaTroId()).orElseThrow(() -> new RuntimeException("Không tìm thấy Tòa nhà")));
        }
        if (request.getPhongId() != null) {
            pt.setPhong(phongRepository.findById(request.getPhongId()).orElse(null));
        }
        if (request.getKhachThueId() != null) {
            pt.setKhachThue(khachThueRepository.findById(request.getKhachThueId()).orElse(null));
        }
        
        PhuongTien saved = phuongTienRepository.save(pt);
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
        
        if (request.getNhaTroId() != null) {
            pt.setNhaTro(nhaTroRepository.findById(request.getNhaTroId()).orElseThrow(() -> new RuntimeException("Không tìm thấy Tòa nhà")));
        }
        if (request.getPhongId() != null) {
            pt.setPhong(phongRepository.findById(request.getPhongId()).orElse(null));
        } else {
            pt.setPhong(null);
        }
        
        if (request.getKhachThueId() != null) {
            pt.setKhachThue(khachThueRepository.findById(request.getKhachThueId()).orElse(null));
        } else {
            pt.setKhachThue(null);
        }
        
        return mapToDto(phuongTienRepository.save(pt));
    }

    @Transactional
    public void delete(UUID id) {
        UUID chuTroId = permissionService.currentUserId().orElseThrow(() -> new RuntimeException("Unauthorized"));
        PhuongTien pt = phuongTienRepository.findByIdAndChuTroId(id, chuTroId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phương tiện"));
        phuongTienRepository.delete(pt);
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
