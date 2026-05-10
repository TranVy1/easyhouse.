package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.KhachThueRequest;
import com.example.quanlyphongtro.dto.KhachThueResponse;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.TrangThaiNguoiDung;
import com.example.quanlyphongtro.entity.VaiTro;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.VaiTroRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class KhachThueService {

    private final KhachThueRepository khachThueRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final VaiTroRepository vaiTroRepository;

    public List<KhachThueResponse> getAllKhachThue(String trangThai) {
        List<KhachThue> list = khachThueRepository.findAllWithNguoiDung();
        return list.stream()
                .map(KhachThueResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public KhachThueResponse getKhachThueById(UUID id) {
        KhachThue khachThue = khachThueRepository.findByIdWithNguoiDung(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Khách thuê"));
        return KhachThueResponse.fromEntity(khachThue);
    }

    @Transactional
    public KhachThueResponse createKhachThue(KhachThueRequest request) {
        // Kiểm tra CCCD đã tồn tại
        if (khachThueRepository.findBySoCccd(request.getSoCccd()).isPresent()) {
            throw new RuntimeException("Số CCCD đã tồn tại trong hệ thống");
        }

        NguoiDung nguoiDung;

        // Nếu có nguoiDungId -> link với tài khoản đã có
        if (request.getNguoiDungId() != null) {
            nguoiDung = nguoiDungRepository.findById(request.getNguoiDungId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));

            // Kiểm tra người dùng đã là khách thuê chưa
            if (khachThueRepository.findByNguoiDungId(request.getNguoiDungId()).isPresent()) {
                throw new RuntimeException("Người dùng này đã là khách thuê");
            }
        } else {
            // Tạo mới NguoiDung
            if (request.getEmail() != null && nguoiDungRepository.findByEmail(request.getEmail()).isPresent()) {
                throw new RuntimeException("Email đã tồn tại trong hệ thống");
            }

            // Lấy vai trò TENANT
            VaiTro tenantRole = vaiTroRepository.findByTen("TENANT")
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy vai trò TENANT"));

            Set<VaiTro> vaiTros = new HashSet<>();
            vaiTros.add(tenantRole);

            nguoiDung = NguoiDung.builder()
                    .hoTen(request.getHoTen())
                    .email(request.getEmail())
                    .soDienThoai(request.getSoDienThoai())
                    .gioiTinh(request.getGioiTinh())
                    .matKhau(request.getMatKhau() != null ? request.getMatKhau() : "default123") // TODO: hash password
                    .trangThai(TrangThaiNguoiDung.ACTIVE)
                    .vaiTros(vaiTros)
                    .build();

            nguoiDung = nguoiDungRepository.save(nguoiDung);
        }

        // Tạo KhachThue
        KhachThue khachThue = KhachThue.builder()
                .nguoiDung(nguoiDung)
                .soCccd(request.getSoCccd())
                .lienHeKhanCap(request.getLienHeKhanCap())
                .ngaySinh(request.getNgaySinh())
                .diaChiThuongTru(request.getDiaChiThuongTru())
                .ngheNghiep(request.getNgheNghiep())
                .build();

        khachThue = khachThueRepository.save(khachThue);

        // Reload để có đầy đủ thông tin
        khachThue = khachThueRepository.findByIdWithNguoiDung(khachThue.getId()).orElse(khachThue);

        return KhachThueResponse.fromEntity(khachThue);
    }

    @Transactional
    public KhachThueResponse updateKhachThue(UUID id, KhachThueRequest request) {
        KhachThue khachThue = khachThueRepository.findByIdWithNguoiDung(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Khách thuê"));

        NguoiDung nguoiDung = khachThue.getNguoiDung();

        // Cập nhật thông tin NguoiDung
        if (nguoiDung != null) {
            if (request.getHoTen() != null) nguoiDung.setHoTen(request.getHoTen());
            if (request.getSoDienThoai() != null) nguoiDung.setSoDienThoai(request.getSoDienThoai());
            if (request.getGioiTinh() != null) nguoiDung.setGioiTinh(request.getGioiTinh());
            // Email thường không cho đổi, nhưng nếu cần:
            // if (request.getEmail() != null) nguoiDung.setEmail(request.getEmail());
            nguoiDungRepository.save(nguoiDung);
        }

        // Cập nhật thông tin KhachThue
        if (request.getSoCccd() != null) khachThue.setSoCccd(request.getSoCccd());
        if (request.getLienHeKhanCap() != null) khachThue.setLienHeKhanCap(request.getLienHeKhanCap());
        if (request.getNgaySinh() != null) khachThue.setNgaySinh(request.getNgaySinh());
        if (request.getDiaChiThuongTru() != null) khachThue.setDiaChiThuongTru(request.getDiaChiThuongTru());
        if (request.getNgheNghiep() != null) khachThue.setNgheNghiep(request.getNgheNghiep());

        khachThue = khachThueRepository.save(khachThue);
        return KhachThueResponse.fromEntity(khachThue);
    }

    @Transactional
    public void deleteKhachThue(UUID id) {
        KhachThue khachThue = khachThueRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Khách thuê"));

        // Soft delete - chỉ đánh dấu xoaLuc
        khachThue.setXoaLuc(java.time.ZonedDateTime.now());
        khachThueRepository.save(khachThue);
    }
}