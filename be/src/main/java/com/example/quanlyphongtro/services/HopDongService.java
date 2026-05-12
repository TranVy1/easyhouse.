package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.HopDongRequest;
import com.example.quanlyphongtro.entity.HopDong;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.Phong;
import com.example.quanlyphongtro.entity.TrangThaiHopDong;
import com.example.quanlyphongtro.entity.TrangThaiPhong;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class HopDongService {

    private final HopDongRepository hopDongRepository;
    private final PhongRepository phongRepository;
    private final KhachThueRepository khachThueRepository;

    private String toJson(Object obj) {
        try {
            return new ObjectMapper().writeValueAsString(obj);
        } catch (Exception e) {
            return "[]";
        }
    }

    private TrangThaiHopDong mapTrangThai(String frontendStatus) {
        if (frontendStatus == null) return TrangThaiHopDong.ACTIVE;
        switch (frontendStatus) {
            case "hoatDong":
                return TrangThaiHopDong.ACTIVE;
            case "hetHan":
                return TrangThaiHopDong.EXPIRED;
            case "daHuy":
                return TrangThaiHopDong.TERMINATED;
            default:
                return TrangThaiHopDong.ACTIVE;
        }
    }

    // ========== READ ==========
    public List<HopDong> getAll() {
        return hopDongRepository.findAll();
    }

    public HopDong getById(UUID id) {
        return hopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));
    }

    public List<KhachThue> getAllKhachThue() {
        return khachThueRepository.findAll();
    }

    // ========== CREATE ==========
    @Transactional
    public HopDong create(HopDongRequest request) {
        Phong phong = phongRepository.findById(request.getPhong())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));

        KhachThue nguoiDaiDien = khachThueRepository.findById(request.getNguoiDaiDien())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người đại diện"));

        HopDong hopDong = HopDong.builder()
                .maHopDong(request.getMaHopDong())
                .phong(phong)
                .nguoiDaiDien(nguoiDaiDien)
                .khachThueIds(request.getKhachThueId())
                .ngayBatDau(request.getNgayBatDau())
                .ngayKetThuc(request.getNgayKetThuc())
                .giaThue(request.getGiaThue())
                .tienCoc(request.getTienCoc())
                .chuKyThanhToan(request.getChuKyThanhToan())
                .ngayThanhToan(request.getNgayThanhToan())
                .dieuKhoan(request.getDieuKhoan())
                .giaDien(request.getGiaDien())
                .giaNuoc(request.getGiaNuoc())
                .chiSoDienBanDau(request.getChiSoDienBanDau())
                .chiSoNuocBanDau(request.getChiSoNuocBanDau())
                .phiDichVu(toJson(request.getPhiDichVu()))
                .trangThai(mapTrangThai(request.getTrangThai()))
                .build();

        HopDong saved = hopDongRepository.save(hopDong);

        // Cập nhật trạng thái phòng -> Đang thuê
        phong.setTrangThai(TrangThaiPhong.RENTED);
        phongRepository.save(phong);

        return saved;
    }

    // ========== UPDATE ==========
    @Transactional
    public HopDong update(UUID id, HopDongRequest request) {
        HopDong hopDong = hopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));

        // Cập nhật phòng nếu thay đổi
        if (request.getPhong() != null) {
            Phong phong = phongRepository.findById(request.getPhong())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));
            hopDong.setPhong(phong);
        }

        // Cập nhật người đại diện nếu thay đổi
        if (request.getNguoiDaiDien() != null) {
            KhachThue nguoiDaiDien = khachThueRepository.findById(request.getNguoiDaiDien())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy người đại diện"));
            hopDong.setNguoiDaiDien(nguoiDaiDien);
        }

        if (request.getMaHopDong() != null) hopDong.setMaHopDong(request.getMaHopDong());
        if (request.getKhachThueId() != null) hopDong.setKhachThueIds(request.getKhachThueId());
        if (request.getNgayBatDau() != null) hopDong.setNgayBatDau(request.getNgayBatDau());
        if (request.getNgayKetThuc() != null) hopDong.setNgayKetThuc(request.getNgayKetThuc());
        if (request.getGiaThue() != null) hopDong.setGiaThue(request.getGiaThue());
        if (request.getTienCoc() != null) hopDong.setTienCoc(request.getTienCoc());
        if (request.getChuKyThanhToan() != null) hopDong.setChuKyThanhToan(request.getChuKyThanhToan());
        if (request.getNgayThanhToan() != null) hopDong.setNgayThanhToan(request.getNgayThanhToan());
        if (request.getDieuKhoan() != null) hopDong.setDieuKhoan(request.getDieuKhoan());
        if (request.getGiaDien() != null) hopDong.setGiaDien(request.getGiaDien());
        if (request.getGiaNuoc() != null) hopDong.setGiaNuoc(request.getGiaNuoc());
        if (request.getChiSoDienBanDau() != null) hopDong.setChiSoDienBanDau(request.getChiSoDienBanDau());
        if (request.getChiSoNuocBanDau() != null) hopDong.setChiSoNuocBanDau(request.getChiSoNuocBanDau());
        if (request.getPhiDichVu() != null) hopDong.setPhiDichVu(toJson(request.getPhiDichVu()));
        if (request.getTrangThai() != null) {
            TrangThaiHopDong newStatus = mapTrangThai(request.getTrangThai());
            hopDong.setTrangThai(newStatus);

            // Nếu hủy hợp đồng, trả phòng về trạng thái trống
            if (newStatus == TrangThaiHopDong.TERMINATED) {
                Phong phong = hopDong.getPhong();
                phong.setTrangThai(TrangThaiPhong.AVAILABLE);
                phongRepository.save(phong);
            }
        }

        return hopDongRepository.save(hopDong);
    }

    // ========== DELETE ==========
    @Transactional
    public void delete(UUID id) {
        HopDong hopDong = hopDongRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hợp đồng"));

        // Trả phòng về trạng thái trống nếu hợp đồng đang hoạt động
        if (hopDong.getTrangThai() == TrangThaiHopDong.ACTIVE) {
            Phong phong = hopDong.getPhong();
            phong.setTrangThai(TrangThaiPhong.AVAILABLE);
            phongRepository.save(phong);
        }

        hopDongRepository.delete(hopDong);
    }
}
