package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.CauHinhGia;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.UUID;

@Data
@Builder
public class CauHinhGiaResponse {
    private UUID id;

    @JsonProperty("_id")
    private UUID legacyId;

    private UUID nhaTroId;
    private String tenNhaTro;
    private UUID dichVuId;
    private String loai;
    private String tenHienThi;
    private String loaiTinhPhi;
    private BigDecimal donGia;
    private LocalDate hieuLucTu;
    private LocalDate hieuLucDen;
    private Boolean dangApDung;
    private ZonedDateTime taoLuc;
    private ZonedDateTime capNhatLuc;

    public static CauHinhGiaResponse fromEntity(CauHinhGia entity) {
        if (entity == null) {
            return null;
        }

        UUID id = entity.getId();
        return CauHinhGiaResponse.builder()
                .id(id)
                .legacyId(id)
                .nhaTroId(entity.getNhaTro() != null ? entity.getNhaTro().getId() : null)
                .tenNhaTro(entity.getNhaTro() != null ? entity.getNhaTro().getTen() : null)
                .dichVuId(entity.getDichVuId())
                .loai(entity.getLoai() != null ? entity.getLoai().name() : null)
                .tenHienThi(entity.getTenHienThi())
                .loaiTinhPhi(entity.getLoaiTinhPhi() != null ? entity.getLoaiTinhPhi().name() : null)
                .donGia(entity.getDonGia())
                .hieuLucTu(entity.getHieuLucTu())
                .hieuLucDen(entity.getHieuLucDen())
                .dangApDung(entity.getDangApDung())
                .taoLuc(entity.getTaoLuc())
                .capNhatLuc(entity.getCapNhatLuc())
                .build();
    }
}
