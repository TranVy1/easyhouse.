package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.DichVu;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;
import java.math.BigDecimal;
import java.util.UUID;

@Data
@Builder
public class DichVuResponse {
    @JsonProperty("_id")
    private UUID id;
    private String tenDichVu;
    private String loaiTinhPhi;
    private String donVi;
    private BigDecimal donGiaMacDinh;
    private Boolean batBuoc;

    public static DichVuResponse fromEntity(DichVu dichVu) {
        if (dichVu == null) return null;
        return DichVuResponse.builder()
                .id(dichVu.getId())
                .tenDichVu(dichVu.getTenDichVu())
                .loaiTinhPhi(dichVu.getLoaiTinhPhi() != null ? dichVu.getLoaiTinhPhi().name() : null)
                .donVi(dichVu.getDonVi())
                .donGiaMacDinh(dichVu.getDonGiaMacDinh())
                .batBuoc(dichVu.getBatBuoc())
                .build();
    }
}
