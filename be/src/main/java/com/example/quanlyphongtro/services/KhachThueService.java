package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.KhachThueRequest;
import com.example.quanlyphongtro.dto.KhachThueResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.HopDongRepository;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import com.example.quanlyphongtro.repository.NguoiDungRepository;
import com.example.quanlyphongtro.repository.VaiTroRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class KhachThueService {

    private final KhachThueRepository khachThueRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final VaiTroRepository vaiTroRepository;
    private final HopDongRepository hopDongRepository;

    public List<KhachThueResponse> getAllKhachThue(String trangThai) {
        List<KhachThue> list = khachThueRepository.findAllWithNguoiDung();
        
        // Lấy tất cả hợp đồng đang hoạt động để map thông tin phòng
        List<HopDong> activeContracts = hopDongRepository.findAllActiveWithPhongAndToaNha();
        
        // Map tenantId -> HopDong
        Map<UUID, HopDong> tenantContractMap = new HashMap<>();
        for (HopDong hd : activeContracts) {
            if (hd.getKhachThueIds() != null) {
                for (UUID tenantId : hd.getKhachThueIds()) {
                    tenantContractMap.put(tenantId, hd);
                }
            }
            // Cũng map cho người đại diện
            if (hd.getNguoiDaiDien() != null) {
                tenantContractMap.put(hd.getNguoiDaiDien().getId(), hd);
            }
        }

        return list.stream()
                .map(kt -> {
                    KhachThueResponse res = KhachThueResponse.fromEntity(kt);
                    HopDong hd = tenantContractMap.get(kt.getId());
                    if (hd != null) {
                        mapContractInfo(res, hd);
                    }
                    return res;
                })
                .collect(Collectors.toList());
    }

    public KhachThueResponse getKhachThueById(UUID id) {
        KhachThue khachThue = khachThueRepository.findByIdWithNguoiDung(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Khách thuê"));
        
        KhachThueResponse res = KhachThueResponse.fromEntity(khachThue);
        
        // Tìm hợp đồng đang hoạt động của khách này
        // (native query hoặc lọc từ list active - ở đây làm đơn giản cho single record)
        List<HopDong> activeContracts = hopDongRepository.findAllActiveWithPhongAndToaNha();
        activeContracts.stream()
                .filter(hd -> (hd.getKhachThueIds() != null && hd.getKhachThueIds().contains(id)) 
                           || (hd.getNguoiDaiDien() != null && hd.getNguoiDaiDien().getId().equals(id)))
                .findFirst()
                .ifPresent(hd -> mapContractInfo(res, hd));

        return res;
    }

    private void mapContractInfo(KhachThueResponse res, HopDong hd) {
        res.setTrangThai("dangThue");
        
        KhachThueResponse.CurrentContractResponse contractRes = KhachThueResponse.CurrentContractResponse.builder()
                .id(hd.getId())
                .build();
                
        if (hd.getPhong() != null) {
            Phong p = hd.getPhong();
            KhachThueResponse.PhongInfo phongInfo = KhachThueResponse.PhongInfo.builder()
                    .id(p.getId())
                    .maPhong(p.getTen())
                    .tang(p.getTang())
                    .build();
            
            if (p.getNhaTro() != null) {
                NhaTro tn = p.getNhaTro();
                phongInfo.setToaNha(KhachThueResponse.ToaNhaInfo.builder()
                        .id(tn.getId())
                        .tenToaNha(tn.getTen())
                        .build());
            }
            contractRes.setPhong(phongInfo);
        }
        res.setHopDongHienTai(contractRes);
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
            
            if (request.getSoDienThoai() != null && nguoiDungRepository.existsBySoDienThoai(request.getSoDienThoai())) {
                throw new RuntimeException("Số điện thoại đã tồn tại trong hệ thống");
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
                .anhCccdTruoc(request.getAnhCCCD() != null ? request.getAnhCCCD().getMatTruoc() : null)
                .anhCccdSau(request.getAnhCCCD() != null ? request.getAnhCCCD().getMatSau() : null)
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
            if (request.getSoDienThoai() != null && !request.getSoDienThoai().equals(nguoiDung.getSoDienThoai())) {
                if (nguoiDungRepository.existsBySoDienThoai(request.getSoDienThoai())) {
                    throw new RuntimeException("Số điện thoại đã tồn tại trong hệ thống");
                }
                nguoiDung.setSoDienThoai(request.getSoDienThoai());
            }
            if (request.getGioiTinh() != null) nguoiDung.setGioiTinh(request.getGioiTinh());
            // Email thường không cho đổi, nhưng nếu cần:
            // if (request.getEmail() != null) nguoiDung.setEmail(request.getEmail());
            nguoiDungRepository.save(nguoiDung);
        }

        // Cập nhật thông tin KhachThue
        if (request.getSoCccd() != null && !request.getSoCccd().equals(khachThue.getSoCccd())) {
            if (khachThueRepository.findBySoCccd(request.getSoCccd()).isPresent()) {
                throw new RuntimeException("Số CCCD đã tồn tại trong hệ thống");
            }
            khachThue.setSoCccd(request.getSoCccd());
        }
        if (request.getLienHeKhanCap() != null) khachThue.setLienHeKhanCap(request.getLienHeKhanCap());
        if (request.getNgaySinh() != null) khachThue.setNgaySinh(request.getNgaySinh());
        if (request.getDiaChiThuongTru() != null) khachThue.setDiaChiThuongTru(request.getDiaChiThuongTru());
        if (request.getNgheNghiep() != null) khachThue.setNgheNghiep(request.getNgheNghiep());
        if (request.getAnhCCCD() != null) {
            if (request.getAnhCCCD().getMatTruoc() != null) khachThue.setAnhCccdTruoc(request.getAnhCCCD().getMatTruoc());
            if (request.getAnhCCCD().getMatSau() != null) khachThue.setAnhCccdSau(request.getAnhCCCD().getMatSau());
        }

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