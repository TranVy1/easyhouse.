package com.example.quanlyphongtro.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.example.quanlyphongtro.entity.NhaTro;
import java.util.UUID;
import java.util.List;
import java.time.ZonedDateTime;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NhaTroResponse {
    @JsonProperty("_id")
    private UUID id;

    private String tenToaNha;

    private DiaChiResponse diaChi;

    private String moTa;

    private List<String> tienNghiChung;

    private int tongSoPhong;

    private int phongTrong;

    private int phongDangThue;

    @JsonProperty("ngayTao")
    private LocalDateTime taoLuc;

    @JsonProperty("ngayCapNhat")
    private LocalDateTime capNhatLuc;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DiaChiResponse {
        private String soNha;
        private String duong;
        private String phuong;
        private String quan;
        private String thanhPho;
    }

    public static NhaTroResponse fromEntity(NhaTro nhaTro, int tongSoPhong, int phongTrong, int phongDangThue) {
        LocalDateTime taoLucLocal = nhaTro.getTaoLuc() != null
                ? nhaTro.getTaoLuc().toLocalDateTime()
                : null;
        LocalDateTime capNhatLucLocal = nhaTro.getCapNhatLuc() != null
                ? nhaTro.getCapNhatLuc().toLocalDateTime()
                : null;

        // Split dia_chi into soNha and duong for the form
        String fullDiaChi = nhaTro.getDiaChi() != null ? nhaTro.getDiaChi() : "";
        String soNha = "";
        String duong = fullDiaChi;

        if (!fullDiaChi.isEmpty()) {
            int firstSpaceIndex = fullDiaChi.indexOf(" ");
            if (firstSpaceIndex > 0) {
                soNha = fullDiaChi.substring(0, firstSpaceIndex);
                duong = fullDiaChi.substring(firstSpaceIndex + 1);
            }
        }

        return NhaTroResponse.builder()
                .id(nhaTro.getId())
                .tenToaNha(nhaTro.getTen())
                .diaChi(DiaChiResponse.builder()
                        .soNha(soNha)
                        .duong(duong)
                        .phuong(nhaTro.getXa() != null ? nhaTro.getXa() : "")
                        .quan(nhaTro.getHuyen() != null ? nhaTro.getHuyen() : "")
                        .thanhPho(nhaTro.getTinh() != null ? nhaTro.getTinh() : "")
                        .build())
                .moTa(nhaTro.getMoTa())
                .tienNghiChung(parseTienNghi(nhaTro.getTienNghiChung()))
                .tongSoPhong(tongSoPhong)
                .phongTrong(phongTrong)
                .phongDangThue(phongDangThue)
                .taoLuc(taoLucLocal)
                .capNhatLuc(capNhatLucLocal)
                .build();
    }

    private static List<String> parseTienNghi(String tienNghiStr) {
        if (tienNghiStr == null || tienNghiStr.isEmpty()) {
            return List.of();
        }
        // Handle JSON array format ["wifi", "camera"]
        if (tienNghiStr.startsWith("[") && tienNghiStr.endsWith("]")) {
            String cleaned = tienNghiStr.substring(1, tienNghiStr.length() - 1);
            if (cleaned.isEmpty()) return List.of();
            return List.of(cleaned.split(","))
                    .stream()
                    .map(s -> s.trim().replaceAll("^\"|\"$", "")) // Remove quotes
                    .filter(s -> !s.isEmpty())
                    .collect(java.util.stream.Collectors.toList());
        }
        // Handle comma-separated format
        return List.of(tienNghiStr.split(","))
                .stream()
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .collect(java.util.stream.Collectors.toList());
    }
}
