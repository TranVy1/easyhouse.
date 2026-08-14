package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.CauHinhPhiXe;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CauHinhPhiXeResponse {
    private UUID id;
    @JsonProperty("_id") private UUID legacyId;
    private UUID nhaTroId;
    private String tenNhaTro;
    private String loaiXe;
    private BigDecimal donGia;
    private LocalDate hieuLucTu;
    private LocalDate hieuLucDen;
    private Boolean dangApDung;
    private String ghiChu;

    public static CauHinhPhiXeResponse fromEntity(CauHinhPhiXe entity) {
        UUID id = entity.getId();
        return CauHinhPhiXeResponse.builder().id(id).legacyId(id)
                .nhaTroId(entity.getNhaTro().getId()).tenNhaTro(entity.getNhaTro().getTen())
                .loaiXe(entity.getLoaiXe()).donGia(entity.getDonGia())
                .hieuLucTu(entity.getHieuLucTu()).hieuLucDen(entity.getHieuLucDen())
                .dangApDung(entity.getDangApDung()).ghiChu(entity.getGhiChu()).build();
    }
}
