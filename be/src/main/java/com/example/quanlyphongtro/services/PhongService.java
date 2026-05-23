package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.PhongRequest;
import com.example.quanlyphongtro.dto.PhongResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PhongService {

    private final PhongRepository phongRepository;
    private final NhaTroRepository nhaTroRepository;
    private final com.example.quanlyphongtro.repository.HopDongRepository hopDongRepository;
    private final MediaService mediaService;
    private final TienIchService tienIchService;

    public List<Phong> getAllPhong(String nhaTroId, String trangThaiStr) {
        TrangThaiPhong tt = parseTrangThai(trangThaiStr);
        UUID nid = parseUuid(nhaTroId);

        if (nid != null && tt != null) return phongRepository.findByNhaTroIdAndTrangThaiAndXoaLucIsNull(nid, tt);
        if (nid != null) return phongRepository.findByNhaTroIdAndXoaLucIsNull(nid);
        if (tt != null) return phongRepository.findByTrangThaiAndXoaLucIsNull(tt);
        return phongRepository.findByXoaLucIsNull();
    }

    public Phong getPhongById(UUID id) {
        return phongRepository.findById(id).orElseThrow(() -> new RuntimeException("Không tìm thấy Phòng"));
    }

    @Transactional
    public Phong createPhong(PhongRequest req) {
        NhaTro nt = nhaTroRepository.findById(req.getNhaTroId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy nhà trọ"));
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
        Phong saved = phongRepository.save(p);
        mediaService.replaceUrls(LoaiDoiTuongMedia.ROOM, saved.getId(), req.getAnhPhong(), MediaService.ROOM_IMAGE);
        tienIchService.replacePhongTienIch(saved.getId(), req.getTienNghi());
        return saved;
    }

    @Transactional
    public Phong updatePhong(UUID id, PhongRequest req) {
        Phong p = phongRepository.findById(id).orElseThrow(() -> new RuntimeException("Không tìm thấy Phòng"));
        if (req.getNhaTroId() != null) {
            NhaTro nt = nhaTroRepository.findById(req.getNhaTroId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy nhà trọ"));
            p.setNhaTro(nt);
        }
        if (req.getTen() != null) p.setTen(req.getTen());
        if (req.getKhuVuc() != null) p.setKhuVuc(req.getKhuVuc());
        if (req.getTang() != null) p.setTang(req.getTang());
        if (req.getDienTich() != null) p.setDienTich(req.getDienTich());
        if (req.getGiaHienTai() != null) p.setGiaHienTai(req.getGiaHienTai());
        if (req.getTienCocMacDinh() != null) p.setTienCocMacDinh(req.getTienCocMacDinh());
        if (req.getMoTa() != null) p.setMoTa(req.getMoTa());
        if (req.getSoNguoiToiDa() != null) p.setSoNguoiToiDa(req.getSoNguoiToiDa());
        TrangThaiPhong tt = parseTrangThai(req.getTrangThai());
        if (tt != null) p.setTrangThai(tt);
        Phong saved = phongRepository.save(p);
        mediaService.replaceUrls(LoaiDoiTuongMedia.ROOM, saved.getId(), req.getAnhPhong(), MediaService.ROOM_IMAGE);
        tienIchService.replacePhongTienIch(saved.getId(), req.getTienNghi());
        return saved;
    }

    public PhongResponse toResponse(Phong phong) {
        HopDong activeContract = hopDongRepository.findFirstByPhongIdAndTrangThaiOrderByTaoLucDesc(
                phong.getId(), TrangThaiHopDong.ACTIVE).orElse(null);
        PhongResponse response = PhongResponse.fromEntity(phong, activeContract);
        response.setAnhPhong(mediaService.listUrls(LoaiDoiTuongMedia.ROOM, phong.getId(), MediaService.ROOM_IMAGE));
        response.setTienNghi(tienIchService.listByPhong(phong.getId()));
        return response;
    }

    @Transactional
    public void deletePhong(UUID id) {
        Phong p = phongRepository.findById(id).orElseThrow(() -> new RuntimeException("Không tìm thấy Phòng"));
        boolean hasActiveContracts = !hopDongRepository.findByPhongIdAndTrangThai(id, TrangThaiHopDong.ACTIVE).isEmpty();
        if (hasActiveContracts) {
            throw new RuntimeException("Không thể xóa phòng đang có hợp đồng hoạt động");
        }
        p.setXoaLuc(java.time.ZonedDateTime.now());
        phongRepository.save(p);
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
