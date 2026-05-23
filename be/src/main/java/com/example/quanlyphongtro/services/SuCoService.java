package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.SuCoRequest;
import com.example.quanlyphongtro.dto.SuCoResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SuCoService {

    private final SuCoRepository suCoRepository;
    private final PhongRepository phongRepository;
    private final KhachThueRepository khachThueRepository;
    private final MediaService mediaService;

    public List<SuCoResponse> getAllSuCo() {
        return suCoRepository.findAllByOrderByTaoLucDesc().stream()
                .map(this::toResponse).collect(Collectors.toList());
    }

    public SuCoResponse getSuCoById(UUID id) {
        SuCo sc = suCoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sự cố"));
        return toResponse(sc);
    }

    @Transactional
    public SuCoResponse createSuCo(SuCoRequest req) {
        Phong phong = req.getPhongId() != null ? phongRepository.findById(req.getPhongId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng")) : null;
        KhachThue kt = req.getKhachThueId() != null ? khachThueRepository.findById(req.getKhachThueId()).orElse(null) : null;

        SuCo sc = SuCo.builder()
                .phong(phong).khachThue(kt)
                .tieuDe(req.getTieuDe()).moTa(req.getMoTa())
                .loaiSuCo(parseLoai(req.getLoaiSuCo()))
                .uuTien(parseUuTien(req.getUuTien()))
                .trangThai(TrangThaiSuCo.PENDING)
                .ghiChuChuNha(req.getGhiChuChuNha())
                .chiPhiSuaChua(req.getChiPhiSuaChua() != null ? req.getChiPhiSuaChua() : BigDecimal.ZERO)
                .build();
        SuCo saved = suCoRepository.save(sc);
        mediaService.replaceUrls(LoaiDoiTuongMedia.INCIDENT, saved.getId(), req.getAnhSuCo(), MediaService.INCIDENT_IMAGE);
        return toResponse(saved);
    }

    @Transactional
    public SuCoResponse updateSuCo(UUID id, SuCoRequest req) {
        SuCo sc = suCoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sự cố"));
        if (req.getPhongId() != null) sc.setPhong(phongRepository.findById(req.getPhongId()).orElse(sc.getPhong()));
        if (req.getKhachThueId() != null) sc.setKhachThue(khachThueRepository.findById(req.getKhachThueId()).orElse(sc.getKhachThue()));
        if (req.getTieuDe() != null) sc.setTieuDe(req.getTieuDe());
        if (req.getMoTa() != null) sc.setMoTa(req.getMoTa());
        if (req.getGhiChuChuNha() != null) sc.setGhiChuChuNha(req.getGhiChuChuNha());
        if (req.getChiPhiSuaChua() != null) sc.setChiPhiSuaChua(req.getChiPhiSuaChua());
        if (req.getLoaiSuCo() != null) sc.setLoaiSuCo(parseLoai(req.getLoaiSuCo()));
        if (req.getUuTien() != null) sc.setUuTien(parseUuTien(req.getUuTien()));
        if (req.getTrangThai() != null) {
            TrangThaiSuCo ns = TrangThaiSuCo.valueOf(req.getTrangThai());
            sc.setTrangThai(ns);
            if (ns == TrangThaiSuCo.RESOLVED && sc.getGiaiQuyetLuc() == null) sc.setGiaiQuyetLuc(ZonedDateTime.now());
        }
        SuCo saved = suCoRepository.save(sc);
        mediaService.replaceUrls(LoaiDoiTuongMedia.INCIDENT, saved.getId(), req.getAnhSuCo(), MediaService.INCIDENT_IMAGE);
        return toResponse(saved);
    }

    @Transactional
    public void deleteSuCo(UUID id) {
        if (!suCoRepository.existsById(id)) throw new RuntimeException("Không tìm thấy sự cố");
        suCoRepository.deleteById(id);
    }

    private LoaiSuCo parseLoai(String s) {
        return LoaiSuCo.fromDbValue(s);
    }
    private UuTien parseUuTien(String s) {
        return UuTien.fromDbValue(s);
    }

    private SuCoResponse toResponse(SuCo suCo) {
        SuCoResponse response = SuCoResponse.fromEntity(suCo);
        response.setAnhSuCo(mediaService.listUrls(LoaiDoiTuongMedia.INCIDENT, suCo.getId(), MediaService.INCIDENT_IMAGE));
        return response;
    }
}
