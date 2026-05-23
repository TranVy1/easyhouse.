package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.KhachThueRequest;
import com.example.quanlyphongtro.dto.KhachThueResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.*;
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
    private final HopDongRepository hopDongRepository;
    private final PhongRepository phongRepository;
    private final NguoiDungRepository nguoiDungRepository;
    private final MediaService mediaService;

    public List<KhachThueResponse> getAllKhachThue(String trangThai) {
        List<KhachThue> list = khachThueRepository.findByXoaLucIsNullOrderByTaoLucDesc();
        List<HopDong> activeContracts = hopDongRepository.findAllActive();
        Map<UUID, HopDong> tenantContractMap = new HashMap<>();
        for (HopDong hd : activeContracts) {
            if (hd.getKhachThue() != null) {
                tenantContractMap.put(hd.getKhachThue().getId(), hd);
            }
        }
        return list.stream().map(kt -> {
            KhachThueResponse res = KhachThueResponse.fromEntity(kt);
            mapMedia(res, kt.getId());
            HopDong hd = tenantContractMap.get(kt.getId());
            if (hd != null) mapContractInfo(res, hd);
            return res;
        }).collect(Collectors.toList());
    }

    public KhachThueResponse getKhachThueById(UUID id) {
        KhachThue kt = khachThueRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Khách thuê"));
        KhachThueResponse res = KhachThueResponse.fromEntity(kt);
        mapMedia(res, kt.getId());
        hopDongRepository.findAllActive().stream()
                .filter(hd -> hd.getKhachThue() != null && hd.getKhachThue().getId().equals(id))
                .findFirst()
                .ifPresent(hd -> mapContractInfo(res, hd));
        return res;
    }

    private void mapContractInfo(KhachThueResponse res, HopDong hd) {
        res.setTrangThai("dangThue");
        KhachThueResponse.CurrentContractResponse cr = KhachThueResponse.CurrentContractResponse.builder().id(hd.getId()).build();
        if (hd.getPhong() != null) {
            Phong p = hd.getPhong();
            KhachThueResponse.PhongInfo pi = KhachThueResponse.PhongInfo.builder()
                    .id(p.getId()).maPhong(p.getTen()).tang(p.getTang()).build();
            if (p.getNhaTro() != null) {
                pi.setToaNha(KhachThueResponse.ToaNhaInfo.builder()
                        .id(p.getNhaTro().getId()).tenToaNha(p.getNhaTro().getTen()).build());
            }
            cr.setPhong(pi);
        }
        res.setHopDongHienTai(cr);
    }

    @Transactional
    public KhachThueResponse createKhachThue(KhachThueRequest req) {
        KhachThue kt = KhachThue.builder()
                .hoTen(req.getHoTen())
                .soDienThoai(req.getSoDienThoai())
                .email(req.getEmail())
                .soCccd(firstNonBlank(req.getSoCccd(), req.getCccd()))
                .ngaySinh(req.getNgaySinh())
                .gioiTinh(req.getGioiTinh())
                .diaChi(req.getDiaChi())
                .queQuan(req.getQueQuan())
                .ngheNghiep(req.getNgheNghiep())
                .ghiChu(req.getGhiChu())
                .dangHoatDong(true)
                .build();
        if (req.getNguoiDungId() != null) {
            NguoiDung nd = nguoiDungRepository.findById(req.getNguoiDungId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));
            kt.setNguoiDung(nd);
        }
        
        Object principal = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication() != null 
            ? org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication().getPrincipal() 
            : null;
            
        NguoiDung defaultUser = null;
        if (principal instanceof UUID) {
            defaultUser = nguoiDungRepository.findById((UUID) principal).orElse(null);
        }
        
        if (defaultUser == null) {
            defaultUser = nguoiDungRepository.findAll().stream().findFirst()
                    .orElseThrow(() -> new RuntimeException("Lỗi cấu hình: Không tìm thấy tài khoản người dùng nào trong DB"));
        }
        kt.setChuTro(defaultUser);
        
        KhachThue saved = khachThueRepository.save(kt);
        saveCccdMedia(saved.getId(), req.getAnhCCCD());
        KhachThueResponse response = KhachThueResponse.fromEntity(saved);
        mapMedia(response, saved.getId());
        return response;
    }

    @Transactional
    public KhachThueResponse updateKhachThue(UUID id, KhachThueRequest req) {
        KhachThue kt = khachThueRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Khách thuê"));
        if (req.getHoTen() != null) kt.setHoTen(req.getHoTen());
        if (req.getSoDienThoai() != null) kt.setSoDienThoai(req.getSoDienThoai());
        if (req.getEmail() != null) kt.setEmail(req.getEmail());
        String soCccd = firstNonBlank(req.getSoCccd(), req.getCccd());
        if (soCccd != null) kt.setSoCccd(soCccd);
        if (req.getNgaySinh() != null) kt.setNgaySinh(req.getNgaySinh());
        if (req.getGioiTinh() != null) kt.setGioiTinh(req.getGioiTinh());
        if (req.getDiaChi() != null) kt.setDiaChi(req.getDiaChi());
        if (req.getQueQuan() != null) kt.setQueQuan(req.getQueQuan());
        if (req.getNgheNghiep() != null) kt.setNgheNghiep(req.getNgheNghiep());
        if (req.getGhiChu() != null) kt.setGhiChu(req.getGhiChu());
        KhachThue saved = khachThueRepository.save(kt);
        saveCccdMedia(saved.getId(), req.getAnhCCCD());
        KhachThueResponse response = KhachThueResponse.fromEntity(saved);
        mapMedia(response, saved.getId());
        return response;
    }

    @Transactional
    public void deleteKhachThue(UUID id) {
        KhachThue kt = khachThueRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Khách thuê"));
        kt.setXoaLuc(java.time.ZonedDateTime.now());
        khachThueRepository.save(kt);
    }

    private String firstNonBlank(String primary, String fallback) {
        if (primary != null && !primary.isBlank()) return primary;
        if (fallback != null && !fallback.isBlank()) return fallback;
        return null;
    }

    private void mapMedia(KhachThueResponse response, UUID khachThueId) {
        response.setAnhCCCD(KhachThueResponse.AnhCCCDResponse.builder()
                .matTruoc(mediaService.firstUrl(LoaiDoiTuongMedia.TENANT, khachThueId, MediaService.CCCD_FRONT))
                .matSau(mediaService.firstUrl(LoaiDoiTuongMedia.TENANT, khachThueId, MediaService.CCCD_BACK))
                .build());
    }

    private void saveCccdMedia(UUID khachThueId, Map<String, String> map) {
        if (map == null || map.isEmpty()) return;
        Object matTruoc = firstPresent(map, "matTruoc", "front", "anhCccdTruoc", "anh_cccd_truoc");
        Object matSau = firstPresent(map, "matSau", "back", "anhCccdSau", "anh_cccd_sau");
        mediaService.replaceUrl(LoaiDoiTuongMedia.TENANT, khachThueId, matTruoc != null ? matTruoc.toString() : "", MediaService.CCCD_FRONT);
        mediaService.replaceUrl(LoaiDoiTuongMedia.TENANT, khachThueId, matSau != null ? matSau.toString() : "", MediaService.CCCD_BACK);
    }

    private Object firstPresent(Map<?, ?> map, String... keys) {
        for (String key : keys) {
            Object value = map.get(key);
            if (value != null && !value.toString().isBlank()) return value;
        }
        return null;
    }
}
