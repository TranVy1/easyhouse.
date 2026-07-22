package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.NguoiDung;
import com.example.quanlyphongtro.entity.ThanhVienCuocTroChuyen;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@Builder
public class ThanhVienChatResponse {

    /** Day la nguoiDungId, khong phai id cua ban ghi thanh vien. */
    @JsonProperty("_id")
    private UUID nguoiDungId;

    private String hoTen;

    /** Biet danh trong hoi thoai nay. Client hien thi `bietDanh ?? hoTen`. */
    private String bietDanh;

    private String anhDaiDien;
    private String vaiTro;

    /**
     * Da doc den so thu tu nay. Client dung de hien "da xem" ma khong can
     * bang read-receipt rieng.
     */
    private Long docDenSeq;

    public static ThanhVienChatResponse fromEntity(ThanhVienCuocTroChuyen tv) {
        if (tv == null || tv.getNguoiDung() == null) return null;
        NguoiDung nd = tv.getNguoiDung();
        return ThanhVienChatResponse.builder()
                .nguoiDungId(nd.getId())
                .hoTen(nd.getHoTen())
                .bietDanh(tv.getBietDanh())
                .anhDaiDien(nd.getAnhDaiDien())
                .vaiTro(tv.getVaiTro() != null ? tv.getVaiTro().name() : null)
                .docDenSeq(tv.getDocDenSeq())
                .build();
    }
}
