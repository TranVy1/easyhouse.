package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.repository.PhongRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.quanlyphongtro.dto.PhongRequest;
import com.example.quanlyphongtro.entity.NhaTro;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import com.example.quanlyphongtro.repository.NhaTroRepository;
import java.util.UUID;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PhongService {

    private final PhongRepository phongRepository;
    private final NhaTroRepository nhaTroRepository;

    public List<Phong> getAllPhong(String toaNhaId, String trangThaiStr) {
        TrangThaiPhong trangThai = mapTrangThai(trangThaiStr);
        UUID nhaTroUuid = null;
        if (toaNhaId != null && !toaNhaId.trim().isEmpty() && !toaNhaId.equals("all")) {
            try {
                nhaTroUuid = UUID.fromString(toaNhaId);
            } catch (Exception ignored) {}
        }

        if (nhaTroUuid != null && trangThai != null) {
            return phongRepository.findByNhaTroIdAndTrangThai(nhaTroUuid, trangThai);
        } else if (nhaTroUuid != null) {
            return phongRepository.findByNhaTroId(nhaTroUuid);
        } else if (trangThai != null) {
            return phongRepository.findByTrangThai(trangThai);
        }
        return phongRepository.findAll();
    }

    public Phong getPhongById(UUID id) {
        return phongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Phòng"));
    }

    @Transactional
    public Phong createPhong(PhongRequest request) {
        NhaTro nhaTro = nhaTroRepository.findById(request.getToaNha())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Tòa nhà/Khu trọ"));

        Phong phong = Phong.builder()
                .nhaTro(nhaTro)
                .ten(request.getMaPhong())
                .tang(request.getTang())
                .dienTich(request.getDienTich())
                .giaHienTai(request.getGiaThue())
                .tienCocMacDinh(request.getTienCoc())
                .moTa(request.getMoTa())
                .soNguoiToiDa(request.getSoNguoiToiDa() != null ? request.getSoNguoiToiDa() : 2)
                .trangThai(mapTrangThai(request.getTrangThai()) != null ? mapTrangThai(request.getTrangThai()) : TrangThaiPhong.AVAILABLE)
                .anhPhong(request.getAnhPhong() != null ? request.getAnhPhong() : new java.util.ArrayList<>())
                .tienNghi(request.getTienNghi() != null ? request.getTienNghi() : new java.util.ArrayList<>())
                .build();

        return phongRepository.save(phong);
    }

    @Transactional
    public Phong updatePhong(UUID id, PhongRequest request) {
        Phong phong = phongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Phòng"));

        if (request.getToaNha() != null) {
            NhaTro nhaTro = nhaTroRepository.findById(request.getToaNha())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy Tòa nhà/Khu trọ"));
            phong.setNhaTro(nhaTro);
        }

        if (request.getMaPhong() != null) phong.setTen(request.getMaPhong());
        if (request.getTang() != null) phong.setTang(request.getTang());
        if (request.getDienTich() != null) phong.setDienTich(request.getDienTich());
        if (request.getGiaThue() != null) phong.setGiaHienTai(request.getGiaThue());
        if (request.getTienCoc() != null) phong.setTienCocMacDinh(request.getTienCoc());
        if (request.getMoTa() != null) phong.setMoTa(request.getMoTa());
        if (request.getSoNguoiToiDa() != null) phong.setSoNguoiToiDa(request.getSoNguoiToiDa());
        if (request.getAnhPhong() != null) phong.setAnhPhong(request.getAnhPhong());
        if (request.getTienNghi() != null) phong.setTienNghi(request.getTienNghi());
        
        TrangThaiPhong tt = mapTrangThai(request.getTrangThai());
        if (tt != null) phong.setTrangThai(tt);

        return phongRepository.save(phong);
    }

    @Transactional
    public void deletePhong(UUID id) {
        if (!phongRepository.existsById(id)) {
            throw new RuntimeException("Không tìm thấy Phòng");
        }
        phongRepository.deleteById(id);
    }

    private TrangThaiPhong mapTrangThai(String trangThai) {
        if (trangThai == null || trangThai.equals("all")) return null;
        switch (trangThai) {
            case "trong": return TrangThaiPhong.AVAILABLE;
            case "dangThue": return TrangThaiPhong.RENTED;
            case "baoTri": return TrangThaiPhong.MAINTENANCE;
            case "daDat": return TrangThaiPhong.AVAILABLE; // Tạm map daDat -> AVAILABLE vì enum chưa có BOOKED
            default: return null;
        }
    }
}
