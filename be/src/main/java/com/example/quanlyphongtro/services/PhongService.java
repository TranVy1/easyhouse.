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

    public List<PhongResponse> getAllPhong(String nhaTroId, String trangThaiStr) {
        TrangThaiPhong tt = parseTrangThai(trangThaiStr);
        UUID nid = parseUuid(nhaTroId);

        List<Phong> list;
        if (nid != null && tt != null) list = phongRepository.findByNhaTroIdAndTrangThaiAndXoaLucIsNull(nid, tt);
        else if (nid != null) list = phongRepository.findByNhaTroIdAndXoaLucIsNull(nid);
        else if (tt != null) list = phongRepository.findByTrangThaiAndXoaLucIsNull(tt);
        else list = phongRepository.findByXoaLucIsNull();
        return list.stream().map(this::toResponse).toList();
    }

    public PhongResponse getPhongById(UUID id) {
        Phong phong = phongRepository.findById(id).orElseThrow(() -> new RuntimeException("Không tìm thấy Phòng"));
        return toResponse(phong);
    }

    @Transactional
    public PhongResponse createPhong(PhongRequest req) {
        NhaTro nt = nhaTroRepository.findById(req.getNhaTroId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy nhà trọ"));
                
        if (phongRepository.existsByNhaTroIdAndTen(nt.getId(), req.getTen())) {
            throw new RuntimeException("Tên phòng đã tồn tại trong tòa nhà này");
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
        Phong p = phongRepository.findById(id).orElseThrow(() -> new RuntimeException("Không tìm thấy Phòng"));
        UUID currentNhaTroId = p.getNhaTro().getId();
        
        if (req.getNhaTroId() != null) {
            NhaTro nt = nhaTroRepository.findById(req.getNhaTroId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy nhà trọ"));
            p.setNhaTro(nt);
            currentNhaTroId = nt.getId();
        }
        
        if (req.getTen() != null) {
            if (phongRepository.existsByNhaTroIdAndTenAndIdNot(currentNhaTroId, req.getTen(), id)) {
                throw new RuntimeException("Tên phòng đã tồn tại trong tòa nhà này");
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

    private PhongResponse toResponse(Phong phong) {
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
