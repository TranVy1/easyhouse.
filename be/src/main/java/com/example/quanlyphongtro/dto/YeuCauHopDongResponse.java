package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.YeuCauHopDong;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class YeuCauHopDongResponse {

    @JsonProperty("_id")
    private UUID id;

    private UUID hopDongId;
    private String maHopDong;
    private String tenPhong;
    private String tenKhachThue;

    private String loai;
    private String trangThai;
    private String lyDo;
    private LocalDate ngayMongMuon;
    private Integer soThangGiaHan;

    private UUID nguoiTaoId;
    private UUID nguoiDuyetId;
    private String ghiChuDuyet;
    private ZonedDateTime duyetLuc;
    private ZonedDateTime taoLuc;

    /**
     * Doc quan he lazy nen CHI duoc goi ben trong transaction. Goi tu controller
     * sau khi session dong se nem LazyInitializationException.
     */
    public static YeuCauHopDongResponse from(YeuCauHopDong y) {
        var hd = y.getHopDong();
        return YeuCauHopDongResponse.builder()
                .id(y.getId())
                .hopDongId(hd != null ? hd.getId() : null)
                .maHopDong(hd != null ? hd.getMaHopDong() : null)
                .tenPhong(hd != null && hd.getPhong() != null ? hd.getPhong().getTen() : null)
                .tenKhachThue(hd != null && hd.getKhachThue() != null ? hd.getKhachThue().getHoTen() : null)
                .loai(y.getLoai() != null ? y.getLoai().name() : null)
                .trangThai(y.getTrangThai() != null ? y.getTrangThai().name() : null)
                .lyDo(y.getLyDo())
                .ngayMongMuon(y.getNgayMongMuon())
                .soThangGiaHan(y.getSoThangGiaHan())
                .nguoiTaoId(y.getNguoiTaoId())
                .nguoiDuyetId(y.getNguoiDuyetId())
                .ghiChuDuyet(y.getGhiChuDuyet())
                .duyetLuc(y.getDuyetLuc())
                .taoLuc(y.getTaoLuc())
                .build();
    }
}
