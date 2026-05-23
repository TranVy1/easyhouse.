package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.SuCo;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
public class SuCoResponse {
    @JsonProperty("_id")
    private UUID id;
    private PhongInfo phong;
    @JsonProperty("nguoiBaoCao")
    private KhachThueInfo khachThue;
    private String tieuDe;
    private String moTa;
    private String loaiSuCo;
    private String mucDoUuTien;
    private String trangThai;
    private String ghiChuChuNha;
    private BigDecimal chiPhiSuaChua;
    private Boolean tinhVaoHoaDon;
    private List<String> anhSuCo;
    @JsonProperty("ngayBaoCao")
    private LocalDateTime taoLuc;
    @JsonProperty("ngayHoanThanh")
    private LocalDateTime giaiQuyetLuc;
    @JsonProperty("ngayCapNhat")
    private LocalDateTime capNhatLuc;

    @Data @Builder
    public static class PhongInfo {
        @JsonProperty("_id")
        private UUID id;
        private String maPhong;
    }

    @Data @Builder
    public static class KhachThueInfo {
        @JsonProperty("_id")
        private UUID id;
        private String hoTen;
        private String soDienThoai;
    }

    public static SuCoResponse fromEntity(SuCo sc) {
        PhongInfo pi = null;
        if (sc.getPhong() != null) {
            pi = PhongInfo.builder().id(sc.getPhong().getId()).maPhong(sc.getPhong().getTen()).build();
        }
        KhachThueInfo ki = null;
        if (sc.getKhachThue() != null) {
            ki = KhachThueInfo.builder()
                    .id(sc.getKhachThue().getId())
                    .hoTen(sc.getKhachThue().getHoTen())
                    .soDienThoai(sc.getKhachThue().getSoDienThoai())
                    .build();
        }
        LocalDateTime tl = sc.getTaoLuc() != null ? sc.getTaoLuc().toLocalDateTime() : null;
        LocalDateTime cl = sc.getCapNhatLuc() != null ? sc.getCapNhatLuc().toLocalDateTime() : null;
        LocalDateTime gl = sc.getGiaiQuyetLuc() != null ? sc.getGiaiQuyetLuc().toLocalDateTime() : null;

        return SuCoResponse.builder()
                .id(sc.getId()).phong(pi).khachThue(ki)
                .tieuDe(sc.getTieuDe()).moTa(sc.getMoTa())
                .loaiSuCo(sc.getLoaiSuCo() != null ? sc.getLoaiSuCo().getDbValue() : null)
                .mucDoUuTien(sc.getUuTien() != null ? sc.getUuTien().getDbValue() : null)
                .trangThai(sc.getTrangThai() != null ? sc.getTrangThai().name() : null)
                .ghiChuChuNha(sc.getGhiChuChuNha())
                .chiPhiSuaChua(sc.getChiPhiSuaChua())
                .tinhVaoHoaDon(sc.getTinhVaoHoaDon())
                .anhSuCo(List.of())
                .taoLuc(tl).giaiQuyetLuc(gl).capNhatLuc(cl)
                .build();
    }
}
