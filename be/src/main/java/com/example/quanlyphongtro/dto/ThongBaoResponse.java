package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.ThongBao;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

@Data
@Builder
public class ThongBaoResponse {

    @JsonProperty("_id")
    private UUID id;

    private String tieuDe;
    private String noiDung;
    private String loai;
    private UUID nguoiGui;
    private List<UUID> nguoiNhan;
    private List<UUID> phong;
    private UUID toaNha;
    private List<UUID> daDoc;

    @JsonProperty("ngayGui")
    private LocalDateTime taoLuc;

    @JsonProperty("ngayTao")
    private LocalDateTime ngayTao;

    public static ThongBaoResponse fromEntity(ThongBao thongBao) {
        UUID nguoiNhanId = thongBao.getNguoiDung() != null ? thongBao.getNguoiDung().getId() : null;
        return fromEntity(thongBao, nguoiNhanId);
    }

    public static ThongBaoResponse fromEntity(ThongBao thongBao, UUID nguoiNhanId) {
        List<UUID> nguoiNhan = nguoiNhanId != null ? List.of(nguoiNhanId) : Collections.emptyList();
        List<UUID> daDoc = Boolean.TRUE.equals(thongBao.getDaDoc()) && nguoiNhanId != null
                ? List.of(nguoiNhanId)
                : Collections.emptyList();
        LocalDateTime taoLuc = thongBao.getTaoLuc() != null ? thongBao.getTaoLuc().toLocalDateTime() : null;

        return ThongBaoResponse.builder()
                .id(thongBao.getId())
                .tieuDe(thongBao.getTieuDe())
                .noiDung(thongBao.getNoiDung())
                .loai(thongBao.getLoai())
                .nguoiNhan(nguoiNhan)
                .phong(thongBao.getPhongIds() != null ? thongBao.getPhongIds() : Collections.emptyList())
                .toaNha(thongBao.getToaNhaId())
                .daDoc(daDoc)
                .taoLuc(taoLuc)
                .ngayTao(taoLuc)
                .build();
    }
}
