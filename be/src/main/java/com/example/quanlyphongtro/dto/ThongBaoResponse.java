package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.ThongBao;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class ThongBaoResponse {
    @JsonProperty("_id")
    private UUID id;
    private String tieuDe;
    private String noiDung;
    private String loai;
    private String kenh;
    private Boolean guiTatCa;
    @JsonProperty("ngayTao")
    private LocalDateTime taoLuc;

    public static ThongBaoResponse fromEntity(ThongBao tb) {
        if (tb == null) return null;
        LocalDateTime tl = tb.getTaoLuc() != null ? tb.getTaoLuc().toLocalDateTime() : null;
        return ThongBaoResponse.builder()
                .id(tb.getId()).tieuDe(tb.getTieuDe()).noiDung(tb.getNoiDung())
                .loai(tb.getLoai() != null ? tb.getLoai().name() : null)
                .kenh(tb.getKenh() != null ? tb.getKenh().name() : null)
                .guiTatCa(tb.getGuiTatCa())
                .taoLuc(tl).build();
    }
}
