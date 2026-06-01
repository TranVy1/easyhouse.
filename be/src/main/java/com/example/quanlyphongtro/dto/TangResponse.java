package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.Tang;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@Builder
public class TangResponse {
    @JsonProperty("_id")
    private UUID id;
    private UUID nhaTroId;
    private Integer soTang;
    private String tenTang;
    private Integer thuTuHienThi;
    private Integer soPhongDuKien;
    private String trangThai;

    public static TangResponse fromEntity(Tang tang) {
        if (tang == null) return null;
        return TangResponse.builder()
                .id(tang.getId())
                .nhaTroId(tang.getNhaTro() != null ? tang.getNhaTro().getId() : null)
                .soTang(tang.getSoTang())
                .tenTang(tang.getTenTang())
                .thuTuHienThi(tang.getThuTuHienThi())
                .soPhongDuKien(tang.getSoPhongDuKien())
                .trangThai(tang.getTrangThai())
                .build();
    }
}
