package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.BaoCaoTinNhan;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@Builder
public class BaoCaoTinNhanResponse {

    @JsonProperty("_id")
    private UUID id;

    private UUID tinNhanId;
    private UUID cuocTroChuyenId;

    /**
     * Noi dung tin bi bao cao, doc TRUC TIEP tu tin nhan (khong sao chep luc bao cao).
     * Nho vay khi nguoi gui thu hoi thi cho nay cung rong theo, dung voi y dinh thu hoi.
     */
    private String noiDungTin;
    private String tenNguoiGuiTin;

    private String tenNguoiBaoCao;
    private String lyDo;
    private String trangThai;

    private String tenNguoiXuLy;
    private String ghiChuXuLy;
    private ZonedDateTime xuLyLuc;
    private ZonedDateTime taoLuc;

    public static BaoCaoTinNhanResponse fromEntity(BaoCaoTinNhan bc) {
        if (bc == null) return null;
        var tin = bc.getTinNhan();
        boolean daThuHoi = tin != null && Boolean.TRUE.equals(tin.getDaThuHoi());

        return BaoCaoTinNhanResponse.builder()
                .id(bc.getId())
                .tinNhanId(tin != null ? tin.getId() : null)
                .cuocTroChuyenId(bc.getCuocTroChuyen() != null ? bc.getCuocTroChuyen().getId() : null)
                .noiDungTin(tin == null ? null : daThuHoi ? "[Tin đã được thu hồi]" : tin.getNoiDung())
                .tenNguoiGuiTin(tin != null && tin.getNguoiGui() != null ? tin.getNguoiGui().getHoTen() : null)
                .tenNguoiBaoCao(bc.getNguoiBaoCao() != null ? bc.getNguoiBaoCao().getHoTen() : null)
                .lyDo(bc.getLyDo())
                .trangThai(bc.getTrangThai() != null ? bc.getTrangThai().name() : null)
                .tenNguoiXuLy(bc.getNguoiXuLy() != null ? bc.getNguoiXuLy().getHoTen() : null)
                .ghiChuXuLy(bc.getGhiChuXuLy())
                .xuLyLuc(bc.getXuLyLuc())
                .taoLuc(bc.getTaoLuc())
                .build();
    }
}
