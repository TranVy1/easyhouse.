package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.TaiSanPhongDto;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.TaiSanPhong;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.TaiSanPhongRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import com.example.quanlyphongtro.dto.PaginatedResponse;
import com.example.quanlyphongtro.entity.NhaTro;

@Service
@RequiredArgsConstructor
public class TaiSanPhongService {

    private final TaiSanPhongRepository taiSanPhongRepository;
    private final PhongRepository phongRepository;
    private final PermissionService permissionService;

    @Transactional(readOnly = true)
    public PaginatedResponse<TaiSanPhongDto> getAll(String keyword, String nhaTroId, String phongId, String tinhTrang, int page, int limit) {
        UUID chuTroId = permissionService.currentUserId().orElseThrow(() -> new RuntimeException("Unauthorized"));
        
        List<TaiSanPhong> all = taiSanPhongRepository.findAll().stream()
                .filter(ts -> ts.getPhong() != null && ts.getPhong().getNhaTro() != null && ts.getPhong().getNhaTro().getChuTro().getId().equals(chuTroId))
                .collect(Collectors.toList());

        if (nhaTroId != null && !nhaTroId.equals("all") && !nhaTroId.isBlank()) {
            all = all.stream().filter(ts -> ts.getPhong().getNhaTro().getId().toString().equals(nhaTroId)).collect(Collectors.toList());
        }

        if (phongId != null && !phongId.equals("all") && !phongId.isBlank()) {
            all = all.stream().filter(ts -> ts.getPhong().getId().toString().equals(phongId)).collect(Collectors.toList());
        }

        if (tinhTrang != null && !tinhTrang.equals("all") && !tinhTrang.isBlank()) {
            all = all.stream().filter(ts -> ts.getTinhTrang() != null && ts.getTinhTrang().equals(tinhTrang)).collect(Collectors.toList());
        }

        if (keyword != null && !keyword.isBlank()) {
            String kw = keyword.toLowerCase();
            all = all.stream().filter(ts -> 
                (ts.getTenTaiSan() != null && ts.getTenTaiSan().toLowerCase().contains(kw)) ||
                (ts.getGhiChu() != null && ts.getGhiChu().toLowerCase().contains(kw))
            ).collect(Collectors.toList());
        }

        all.sort((a, b) -> {
            if (a.getTaoLuc() == null && b.getTaoLuc() == null) return 0;
            if (a.getTaoLuc() == null) return 1;
            if (b.getTaoLuc() == null) return -1;
            return b.getTaoLuc().compareTo(a.getTaoLuc());
        });

        int start = Math.max(0, (page - 1) * limit);
        int end = Math.min(start + limit, all.size());
        List<TaiSanPhongDto> content = all.subList(start, end).stream().map(this::mapToDto).collect(Collectors.toList());

        return new PaginatedResponse<>(
                content,
                all.size(),
                page,
                limit,
                (int) Math.ceil((double) all.size() / limit)
        );
    }

    @Transactional(readOnly = true)
    public List<TaiSanPhongDto> getTaiSanByPhong(UUID phongId) {
        return taiSanPhongRepository.findByPhongId(phongId).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Transactional
    public TaiSanPhongDto addTaiSanToPhong(UUID phongId, TaiSanPhongDto dto) {
        Phong phong = phongRepository.findById(phongId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay phong"));
        TaiSanPhong taiSan = TaiSanPhong.builder()
                .phong(phong)
                .tenTaiSan(dto.getTenTaiSan())
                .soLuong(dto.getSoLuong())
                .giaTri(dto.getGiaTri())
                .tinhTrang(dto.getTinhTrang())
                .ghiChu(dto.getGhiChu())
                .anhTaiSan(dto.getAnhTaiSan())
                .build();
        taiSan = taiSanPhongRepository.save(taiSan);
        return mapToDto(taiSan);
    }

    @Transactional
    public TaiSanPhongDto updateTaiSan(UUID id, TaiSanPhongDto dto) {
        TaiSanPhong taiSan = taiSanPhongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay tai san"));
        taiSan.setTenTaiSan(dto.getTenTaiSan());
        taiSan.setSoLuong(dto.getSoLuong());
        taiSan.setGiaTri(dto.getGiaTri());
        taiSan.setTinhTrang(dto.getTinhTrang());
        taiSan.setGhiChu(dto.getGhiChu());
        taiSan.setAnhTaiSan(dto.getAnhTaiSan());
        taiSan = taiSanPhongRepository.save(taiSan);
        return mapToDto(taiSan);
    }

    @Transactional
    public void deleteTaiSan(UUID id) {
        taiSanPhongRepository.deleteById(id);
    }

    public TaiSanPhongDto mapToDto(TaiSanPhong entity) {
        String tenNhaTro = null;
        UUID nhaTroId = null;
        if (entity.getPhong() != null && entity.getPhong().getNhaTro() != null) {
            tenNhaTro = entity.getPhong().getNhaTro().getTen();
            nhaTroId = entity.getPhong().getNhaTro().getId();
        }
        
        return TaiSanPhongDto.builder()
                .id(entity.getId())
                .phongId(entity.getPhong().getId())
                .tenPhong(entity.getPhong().getTen())
                .nhaTroId(nhaTroId)
                .tenNhaTro(tenNhaTro)
                .tenTaiSan(entity.getTenTaiSan())
                .soLuong(entity.getSoLuong())
                .giaTri(entity.getGiaTri())
                .tinhTrang(entity.getTinhTrang())
                .ghiChu(entity.getGhiChu())
                .anhTaiSan(entity.getAnhTaiSan())
                .build();
    }
}
