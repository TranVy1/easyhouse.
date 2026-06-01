package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.Phong;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
public class PhongResponse {

    @JsonProperty("_id")
    private UUID id;

    @JsonProperty("maPhong")
    private String ten;

    private NhaTroResponse toaNha;
    private String khuVuc;
    private Integer tang;
    private UUID tangId;
    private BigDecimal dienTich;

    @JsonProperty("giaThue")
    private BigDecimal giaHienTai;

    @JsonProperty("tienCoc")
    private BigDecimal tienCocMacDinh;

    private String trangThai;
    private Integer soNguoiToiDa;
    private String moTa;
    private List<String> anhPhong;
    private List<String> tienNghi;

    @JsonProperty("ngayTao")
    private LocalDateTime taoLuc;

    @JsonProperty("ngayCapNhat")
    private LocalDateTime capNhatLuc;

    private CurrentHopDongResponse hopDongHienTai;

    @Data
    @Builder
    public static class CurrentHopDongResponse {
        @JsonProperty("_id")
        private UUID id;
        private List<KhachThueSummary> khachThueId;
        private KhachThueSummary nguoiDaiDien;
    }

    @Data
    @Builder
    public static class KhachThueSummary {
        @JsonProperty("_id")
        private UUID id;
        private String hoTen;
        private String soDienThoai;
    }

    public static PhongResponse fromEntity(Phong phong) {
        return fromEntity(phong, null);
    }

    public static PhongResponse fromEntity(Phong phong, com.example.quanlyphongtro.entity.HopDong activeContract) {
        if (phong == null) return null;

        NhaTroResponse nhaTroResp = null;
        if (phong.getNhaTro() != null) {
            nhaTroResp = NhaTroResponse.builder()
                .id(phong.getNhaTro().getId())
                .tenToaNha(phong.getNhaTro().getTen())
                .diaChi(NhaTroResponse.DiaChiResponse.builder()
                        .soNha(phong.getNhaTro().getSoNha() != null ? phong.getNhaTro().getSoNha() : "")
                        .duong(phong.getNhaTro().getDuong() != null ? phong.getNhaTro().getDuong() : "")
                        .phuong(phong.getNhaTro().getPhuong() != null ? phong.getNhaTro().getPhuong() : "")
                        .quan(phong.getNhaTro().getQuan() != null ? phong.getNhaTro().getQuan() : "")
                        .thanhPho(phong.getNhaTro().getThanhPho() != null ? phong.getNhaTro().getThanhPho() : "")
                        .build())
                .build();
        }

        LocalDateTime taoLucLocal = phong.getTaoLuc() != null ? phong.getTaoLuc().toLocalDateTime() : null;
        LocalDateTime capNhatLucLocal = phong.getCapNhatLuc() != null ? phong.getCapNhatLuc().toLocalDateTime() : null;

        return PhongResponse.builder()
            .id(phong.getId())
            .ten(phong.getTen())
            .toaNha(nhaTroResp)
            .khuVuc(phong.getKhuVuc())
            .tang(phong.getTang())
            .tangId(phong.getTangEntity() != null ? phong.getTangEntity().getId() : null)
            .dienTich(phong.getDienTich())
            .giaHienTai(phong.getGiaHienTai())
            .tienCocMacDinh(phong.getTienCocMacDinh())
            .soNguoiToiDa(phong.getSoNguoiToiDa())
            .trangThai(phong.getTrangThai() != null ? phong.getTrangThai().name() : null)
            .moTa(phong.getMoTa())
            .anhPhong(List.of())
            .tienNghi(List.of())
            .taoLuc(taoLucLocal)
            .capNhatLuc(capNhatLucLocal)
            .hopDongHienTai(activeContract != null ? mapCurrentContract(activeContract) : null)
            .build();
    }

    private static CurrentHopDongResponse mapCurrentContract(com.example.quanlyphongtro.entity.HopDong activeContract) {
        KhachThueSummary nguoiDaiDien = null;
        if (activeContract.getKhachThue() != null) {
            nguoiDaiDien = KhachThueSummary.builder()
                    .id(activeContract.getKhachThue().getId())
                    .hoTen(activeContract.getKhachThue().getHoTen())
                    .soDienThoai(activeContract.getKhachThue().getSoDienThoai())
                    .build();
        }
        return CurrentHopDongResponse.builder()
                .id(activeContract.getId())
                .nguoiDaiDien(nguoiDaiDien)
                .khachThueId(nguoiDaiDien != null ? List.of(nguoiDaiDien) : List.of())
                .build();
    }
}
