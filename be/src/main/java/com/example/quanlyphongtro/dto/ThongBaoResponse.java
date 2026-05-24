package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.ThongBao;
import com.example.quanlyphongtro.entity.ThongBaoNguoiNhan;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import lombok.Builder;
import lombok.Data;

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
    private List<UUID> nguoiNhan;
    private List<UUID> daDoc;

    @JsonProperty("ngayTao")
    private LocalDateTime taoLuc;

    public static ThongBaoResponse fromEntity(ThongBao tb) {
        return fromEntity(tb, Collections.emptyList());
    }

    public static ThongBaoResponse fromEntity(ThongBao tb, List<ThongBaoNguoiNhan> recipients) {
        if (tb == null) return null;
        List<ThongBaoNguoiNhan> safeRecipients = recipients != null ? recipients : Collections.emptyList();

        return fromEntity(
                tb,
                safeRecipients.stream()
                        .filter(item -> item.getNguoiDung() != null)
                        .map(item -> item.getNguoiDung().getId())
                        .toList(),
                safeRecipients.stream()
                        .filter(item -> Boolean.TRUE.equals(item.getDaDoc()))
                        .filter(item -> item.getNguoiDung() != null)
                        .map(item -> item.getNguoiDung().getId())
                        .toList());
    }

    public static ThongBaoResponse fromEntity(ThongBao tb, List<UUID> nguoiNhanIds, List<UUID> daDocIds) {
        if (tb == null) return null;
        LocalDateTime tl = tb.getTaoLuc() != null ? tb.getTaoLuc().toLocalDateTime() : null;

        return ThongBaoResponse.builder()
                .id(tb.getId())
                .tieuDe(tb.getTieuDe())
                .noiDung(tb.getNoiDung())
                .loai(toFrontendLoai(tb.getLoai()))
                .kenh(tb.getKenh() != null ? tb.getKenh().name() : null)
                .guiTatCa(tb.getGuiTatCa())
                .nguoiNhan(nguoiNhanIds != null ? nguoiNhanIds : Collections.emptyList())
                .daDoc(daDocIds != null ? daDocIds : Collections.emptyList())
                .taoLuc(tl)
                .build();
    }

    private static String toFrontendLoai(com.example.quanlyphongtro.entity.LoaiThongBao loai) {
        if (loai == null) return null;
        return switch (loai) {
            case SYSTEM -> "chung";
            case INVOICE -> "hoaDon";
            case PAYMENT -> "thanhToan";
            case CONTRACT -> "hopDong";
            case INCIDENT -> "suCo";
            case APPOINTMENT -> "lichHen";
            case DEBT -> "congNo";
        };
    }
}
