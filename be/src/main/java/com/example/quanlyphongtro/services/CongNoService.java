package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.CongNoResponse;
import com.example.quanlyphongtro.dto.HoaDonResponse;
import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.repository.ChiTietHoaDonRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import com.example.quanlyphongtro.services.PermissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.example.quanlyphongtro.dto.PaginatedResponse;

@Service
@RequiredArgsConstructor
public class CongNoService {

    private final HoaDonRepository hoaDonRepository;
    private final ChiTietHoaDonRepository chiTietHoaDonRepository;
    private final PermissionService permissionService;

    @Transactional(readOnly = true)
    public PaginatedResponse<CongNoResponse> getTongNo(Pageable pageable) {
        UUID currentUserId = permissionService.requireCurrentUserId();
        List<UUID> nhaTroIds = permissionService.getAllAccessibleNhaTroIds(currentUserId);
        
        if (nhaTroIds != null && nhaTroIds.isEmpty()) {
            return PaginatedResponse.of(new PageImpl<>(new ArrayList<>(), pageable, 0), new ArrayList<>());
        }

        // Fetch all unpaid invoices
        List<HoaDon> unpaidInvoices = hoaDonRepository.findByXoaLucIsNullOrderByTaoLucDesc().stream()
                .filter(hd -> hd.getTongTien().compareTo(hd.getDaTra()) > 0)
                .filter(hd -> {
                    if (nhaTroIds == null) return true; // Admin sees all
                    if (hd.getHopDong() == null || hd.getHopDong().getPhong() == null || hd.getHopDong().getPhong().getNhaTro() == null) return false;
                    return nhaTroIds.contains(hd.getHopDong().getPhong().getNhaTro().getId());
                })
                .collect(Collectors.toList());

        // Group by Phong ID
        Map<UUID, List<HoaDon>> groupedByPhong = unpaidInvoices.stream()
                .collect(Collectors.groupingBy(hd -> hd.getPhong().getId()));

        List<CongNoResponse> result = new ArrayList<>();
        LocalDate today = LocalDate.now();

        for (Map.Entry<UUID, List<HoaDon>> entry : groupedByPhong.entrySet()) {
            List<HoaDon> invoices = entry.getValue();
            if (invoices.isEmpty()) continue;

            HoaDon firstHd = invoices.get(0);
            
            BigDecimal tongNo = BigDecimal.ZERO;
            BigDecimal noQuaHan = BigDecimal.ZERO;
            List<HoaDonResponse> danhSachHoaDonNo = new ArrayList<>();

            for (HoaDon hd : invoices) {
                BigDecimal conLai = hd.getTongTien().subtract(hd.getDaTra());
                tongNo = tongNo.add(conLai);
                
                if (hd.getHanTra() != null && hd.getHanTra().isBefore(today)) {
                    noQuaHan = noQuaHan.add(conLai);
                }

                danhSachHoaDonNo.add(HoaDonResponse.fromEntity(hd, chiTietHoaDonRepository.findByHoaDonId(hd.getId())));
            }

            result.add(CongNoResponse.builder()
                    .phongId(firstHd.getPhong().getId())
                    .maPhong(firstHd.getPhong().getTen())
                    .toaNhaId(firstHd.getPhong().getNhaTro() != null ? firstHd.getPhong().getNhaTro().getId() : null)
                    .tenToaNha(firstHd.getPhong().getNhaTro() != null ? firstHd.getPhong().getNhaTro().getTen() : null)
                    .khachThueId(firstHd.getKhachThue() != null ? firstHd.getKhachThue().getId() : null)
                    .tenKhachThue(firstHd.getKhachThue() != null ? firstHd.getKhachThue().getHoTen() : null)
                    .soDienThoai(firstHd.getKhachThue() != null ? firstHd.getKhachThue().getSoDienThoai() : null)
                    .tongNo(tongNo)
                    .noQuaHan(noQuaHan)
                    .danhSachHoaDonNo(danhSachHoaDonNo)
                    .build());
        }

        // Sort by tongNo descending
        result.sort((a, b) -> b.getTongNo().compareTo(a.getTongNo()));
        
        int totalElements = result.size();
        int start = (int) pageable.getOffset();
        int end = Math.min((start + pageable.getPageSize()), totalElements);
        List<CongNoResponse> pageContent = new ArrayList<>();
        if (start < totalElements) {
            pageContent = result.subList(start, end);
        }
        
        Page<CongNoResponse> page = new PageImpl<>(pageContent, pageable, totalElements);
        return PaginatedResponse.of(page, pageContent);
    }
}
