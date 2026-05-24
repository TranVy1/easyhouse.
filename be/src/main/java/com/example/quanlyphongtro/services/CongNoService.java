package com.example.quanlyphongtro.services;

import com.example.quanlyphongtro.dto.CongNoResponse;
import com.example.quanlyphongtro.dto.HoaDonResponse;
import com.example.quanlyphongtro.entity.HoaDon;
import com.example.quanlyphongtro.repository.ChiTietHoaDonRepository;
import com.example.quanlyphongtro.repository.HoaDonRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CongNoService {

    private final HoaDonRepository hoaDonRepository;
    private final ChiTietHoaDonRepository chiTietHoaDonRepository;

    @Transactional(readOnly = true)
    public List<CongNoResponse> getTongNo() {
        // Fetch all unpaid invoices
        List<HoaDon> unpaidInvoices = hoaDonRepository.findByXoaLucIsNullOrderByTaoLucDesc().stream()
                .filter(hd -> hd.getTongTien().compareTo(hd.getDaTra()) > 0)
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
        return result;
    }
}
