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

@Service
@RequiredArgsConstructor
public class TaiSanPhongService {

    private final TaiSanPhongRepository taiSanPhongRepository;
    private final PhongRepository phongRepository;

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
                .build();
        taiSan = taiSanPhongRepository.save(taiSan);
        return mapToDto(taiSan);
    }

    @Transactional
    public void deleteTaiSan(UUID id) {
        taiSanPhongRepository.deleteById(id);
    }

    public TaiSanPhongDto mapToDto(TaiSanPhong entity) {
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
}
