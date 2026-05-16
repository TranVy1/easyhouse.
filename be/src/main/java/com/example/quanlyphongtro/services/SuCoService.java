package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.SuCoRequest;
import com.example.quanlyphongtro.dto.SuCoResponse;
import com.example.quanlyphongtro.entity.*;
import com.example.quanlyphongtro.repository.KhachThueRepository;
import com.example.quanlyphongtro.repository.PhongRepository;
import com.example.quanlyphongtro.repository.SuCoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.ArrayList;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SuCoService {

    private final SuCoRepository suCoRepository;
    private final PhongRepository phongRepository;
    private final KhachThueRepository khachThueRepository;
    private final com.example.quanlyphongtro.repository.HopDongRepository hopDongRepository;

    public List<SuCoResponse> getAllSuCo() {
        return suCoRepository.findAllWithDetails().stream()
                .map(SuCoResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public SuCoResponse getSuCoById(UUID id) {
        SuCo suCo = suCoRepository.findByIdWithDetails(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sự cố với id: " + id));
        return SuCoResponse.fromEntity(suCo);
    }

    @Transactional
    public SuCoResponse createSuCo(SuCoRequest request) {
        // Validate phòng
        Phong phong = null;
        if (request.getPhongId() != null) {
            phong = phongRepository.findById(request.getPhongId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));
        }

        // Validate khách thuê
        KhachThue khachThue = null;
        if (request.getKhachThueId() != null) {
            khachThue = khachThueRepository.findById(request.getKhachThueId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khách thuê"));
        } else if (phong != null) {
            // Tự động tìm khách thuê từ hợp đồng đang active của phòng
            Optional<HopDong> activeHopDong = hopDongRepository.findFirstByPhongIdAndTrangThaiOrderByTaoLucDesc(phong.getId(), TrangThaiHopDong.ACTIVE);
            if (activeHopDong.isPresent()) {
                khachThue = activeHopDong.get().getNguoiDaiDien();
            }
        }

        // Parse enums
        LoaiSuCo loaiSuCo = LoaiSuCo.khac;
        if (request.getLoaiSuCo() != null) {
            try {
                loaiSuCo = LoaiSuCo.valueOf(request.getLoaiSuCo());
            } catch (IllegalArgumentException e) {
                throw new RuntimeException("Loại sự cố không hợp lệ: " + request.getLoaiSuCo());
            }
        }

        UuTien uuTien = UuTien.trung_binh;
        if (request.getUuTien() != null) {
            try {
                uuTien = UuTien.valueOf(request.getUuTien());
            } catch (IllegalArgumentException e) {
                throw new RuntimeException("Mức ưu tiên không hợp lệ: " + request.getUuTien());
            }
        }

        SuCo suCo = SuCo.builder()
                .phong(phong)
                .khachThue(khachThue)
                .tieuDe(request.getTieuDe())
                .moTa(request.getMoTa())
                .loaiSuCo(loaiSuCo)
                .uuTien(uuTien)
                .trangThai(TrangThaiSuCo.PENDING)
                .ghiChuChuNha(request.getGhiChuChuNha())
                .chiPhiSuaChua(request.getChiPhiSuaChua())
                .nguoiPhuTrach(request.getNguoiPhuTrach())
                .anhSuCo(request.getAnhSuCo() != null ? request.getAnhSuCo() : new ArrayList<>())
                .build();

        suCo = suCoRepository.save(suCo);

        // Reload with details
        suCo = suCoRepository.findByIdWithDetails(suCo.getId()).orElse(suCo);
        return SuCoResponse.fromEntity(suCo);
    }

    @Transactional
    public SuCoResponse updateSuCo(UUID id, SuCoRequest request) {
        SuCo suCo = suCoRepository.findByIdWithDetails(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sự cố với id: " + id));

        // Update phòng nếu có
        boolean phongChanged = false;
        if (request.getPhongId() != null) {
            phongChanged = suCo.getPhong() == null || !suCo.getPhong().getId().equals(request.getPhongId());
            Phong phong = phongRepository.findById(request.getPhongId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy phòng"));
            suCo.setPhong(phong);
            
            // Nếu đổi phòng hoặc chưa có khách thuê, tự động lấy khách thuê của phòng mới
            if (phongChanged || suCo.getKhachThue() == null) {
                Optional<HopDong> activeHopDong = hopDongRepository.findFirstByPhongIdAndTrangThaiOrderByTaoLucDesc(phong.getId(), TrangThaiHopDong.ACTIVE);
                if (activeHopDong.isPresent()) {
                    suCo.setKhachThue(activeHopDong.get().getNguoiDaiDien());
                } else {
                    suCo.setKhachThue(null);
                }
            }
        }

        // Update khách thuê nếu có (ghi đè logic tự động nếu client truyền lên explicitly)
        // Nhưng nếu phongChanged mà client vẫn gửi khachThueId cũ thì có thể bị sai lệch. 
        // Ta chỉ ghi đè nếu client gửi một khachThueId khác với khách thuê cũ, hoặc cố tình set.
        if (request.getKhachThueId() != null && !phongChanged) {
            KhachThue khachThue = khachThueRepository.findById(request.getKhachThueId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy khách thuê"));
            suCo.setKhachThue(khachThue);
        }

        // Update các trường text
        if (request.getTieuDe() != null)
            suCo.setTieuDe(request.getTieuDe());
        if (request.getMoTa() != null)
            suCo.setMoTa(request.getMoTa());
        if (request.getGhiChuChuNha() != null)
            suCo.setGhiChuChuNha(request.getGhiChuChuNha());
        if (request.getChiPhiSuaChua() != null)
            suCo.setChiPhiSuaChua(request.getChiPhiSuaChua());
        if (request.getNguoiPhuTrach() != null)
            suCo.setNguoiPhuTrach(request.getNguoiPhuTrach());
        if (request.getAnhSuCo() != null)
            suCo.setAnhSuCo(request.getAnhSuCo());

        // Update loại sự cố
        if (request.getLoaiSuCo() != null) {
            try {
                suCo.setLoaiSuCo(LoaiSuCo.valueOf(request.getLoaiSuCo()));
            } catch (IllegalArgumentException e) {
                throw new RuntimeException("Loại sự cố không hợp lệ: " + request.getLoaiSuCo());
            }
        }

        // Update ưu tiên
        if (request.getUuTien() != null) {
            try {
                suCo.setUuTien(UuTien.valueOf(request.getUuTien()));
            } catch (IllegalArgumentException e) {
                throw new RuntimeException("Mức ưu tiên không hợp lệ: " + request.getUuTien());
            }
        }

        // Update trạng thái với business logic
        if (request.getTrangThai() != null) {
            try {
                TrangThaiSuCo newStatus = TrangThaiSuCo.valueOf(request.getTrangThai());
                suCo.setTrangThai(newStatus);

                // Khi chuyển sang RESOLVED, set thời gian giải quyết
                if (newStatus == TrangThaiSuCo.RESOLVED && suCo.getGiaiQuyetLuc() == null) {
                    suCo.setGiaiQuyetLuc(ZonedDateTime.now());
                }
            } catch (IllegalArgumentException e) {
                throw new RuntimeException("Trạng thái không hợp lệ: " + request.getTrangThai());
            }
        }

        suCo = suCoRepository.save(suCo);

        // Reload with details
        suCo = suCoRepository.findByIdWithDetails(suCo.getId()).orElse(suCo);
        return SuCoResponse.fromEntity(suCo);
    }

    @Transactional
    public void deleteSuCo(UUID id) {
        SuCo suCo = suCoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sự cố với id: " + id));
        suCoRepository.delete(suCo);
    }
}
