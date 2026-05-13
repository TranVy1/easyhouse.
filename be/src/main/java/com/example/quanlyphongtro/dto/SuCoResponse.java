package com.example.quanlyphongtro.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.example.quanlyphongtro.entity.SuCo;
import com.example.quanlyphongtro.entity.KhachThue;
import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.Phong;
import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class SuCoResponse {

    @JsonProperty("_id")
    private UUID id;

    // Thông tin phòng (embedded)
    private PhongInfo phong;

    // Thông tin khách thuê (embedded)
    @JsonProperty("nguoiBaoCao")
    private KhachThueInfo khachThue;

    private String tieuDe;
    private String moTa;
    private String loaiSuCo;       // dien_nuoc, noi_that, ve_sinh, an_ninh, khac
    private String mucDoUuTien;    // thap, trung_binh, cao, khan_cap
    private String trangThai;      // PENDING, IN_PROGRESS, RESOLVED, CANCELLED
    private String ghiChuChuNha;
    private BigDecimal chiPhiSuaChua;
    private UUID nguoiPhuTrach;

    @JsonProperty("ghiChuXuLy")
    private String ghiChuChuNhaAlias;

    @JsonProperty("ngayBaoCao")
    private LocalDateTime taoLuc;

    @JsonProperty("ngayHoanThanh")
    private LocalDateTime giaiQuyetLuc;

    @JsonProperty("ngayCapNhat")
    private LocalDateTime capNhatLuc;

    // Nested DTOs
    @Data
    @Builder
    public static class PhongInfo {
        @JsonProperty("_id")
        private UUID id;
        private String maPhong;
    }

    @Data
    @Builder
    public static class KhachThueInfo {
        @JsonProperty("_id")
        private UUID id;
        private String hoTen;
        private String soDienThoai;
    }

    public static SuCoResponse fromEntity(SuCo suCo) {
        // Build phong info
        PhongInfo phongInfo = null;
        if (suCo.getPhong() != null) {
            Phong phong = suCo.getPhong();
            phongInfo = PhongInfo.builder()
                    .id(phong.getId())
                    .maPhong(phong.getTen())
                    .build();
        }

        // Build khach thue info
        KhachThueInfo khachThueInfo = null;
        if (suCo.getKhachThue() != null) {
            KhachThue kt = suCo.getKhachThue();
            NguoiDung nd = kt.getNguoiDung();
            khachThueInfo = KhachThueInfo.builder()
                    .id(kt.getId())
                    .hoTen(nd != null ? nd.getHoTen() : null)
                    .soDienThoai(nd != null ? nd.getSoDienThoai() : null)
                    .build();
        }

        // Convert timestamps
        LocalDateTime taoLucLocal = suCo.getTaoLuc() != null
                ? suCo.getTaoLuc().toLocalDateTime() : null;
        LocalDateTime capNhatLucLocal = suCo.getCapNhatLuc() != null
                ? suCo.getCapNhatLuc().toLocalDateTime() : null;
        LocalDateTime giaiQuyetLucLocal = suCo.getGiaiQuyetLuc() != null
                ? suCo.getGiaiQuyetLuc().toLocalDateTime() : null;

        return SuCoResponse.builder()
                .id(suCo.getId())
                .phong(phongInfo)
                .khachThue(khachThueInfo)
                .tieuDe(suCo.getTieuDe())
                .moTa(suCo.getMoTa())
                .loaiSuCo(suCo.getLoaiSuCo() != null ? suCo.getLoaiSuCo().name() : null)
                .mucDoUuTien(suCo.getUuTien() != null ? suCo.getUuTien().name() : null)
                .trangThai(suCo.getTrangThai() != null ? suCo.getTrangThai().name() : null)
                .ghiChuChuNha(suCo.getGhiChuChuNha())
                .ghiChuChuNhaAlias(suCo.getGhiChuChuNha())
                .chiPhiSuaChua(suCo.getChiPhiSuaChua())
                .nguoiPhuTrach(suCo.getNguoiPhuTrach())
                .taoLuc(taoLucLocal)
                .giaiQuyetLuc(giaiQuyetLucLocal)
                .capNhatLuc(capNhatLucLocal)
                .build();
    }
}
