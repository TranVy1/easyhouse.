package com.example.quanlyphongtro.dto;

import lombok.Builder;
import lombok.Data;
import java.util.UUID;
import com.example.quanlyphongtro.entity.NhaTro;

@Data
@Builder
public class PublicNhaTroSummaryResponse {
    private UUID _id;
    private String tenNhaTro;
    private String diaChi;

    public static PublicNhaTroSummaryResponse fromEntity(NhaTro nhaTro) {
        if (nhaTro == null) return null;
        return PublicNhaTroSummaryResponse.builder()
                ._id(nhaTro.getId())
                .tenNhaTro(nhaTro.getTen())
                .diaChi(nhaTro.getDiaChi())
                .build();
    }
}
