package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.TienIch;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@Builder
public class TienIchResponse {
    @JsonProperty("_id")
    private UUID id;
    private String ten;
    private String bieuTuong;

    public static TienIchResponse fromEntity(TienIch tienIch) {
        if (tienIch == null) return null;
        return TienIchResponse.builder()
                .id(tienIch.getId())
                .ten(tienIch.getTen())
                .bieuTuong(tienIch.getBieuTuong())
                .build();
    }
}
