package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.NguoiDung;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

/** Mot nguoi ma nguoi dung hien tai duoc phep nhan tin. */
@Data
@Builder
public class NguoiLienHeResponse {

    @JsonProperty("_id")
    private UUID nguoiDungId;

    private String hoTen;
    private String soDienThoai;
    private String anhDaiDien;

    /** Vai tro trong pham vi nha tro: LANDLORD | STAFF | TENANT. */
    private String vaiTro;

    public static NguoiLienHeResponse fromEntity(NguoiDung nd, String vaiTro) {
        if (nd == null) return null;
        return NguoiLienHeResponse.builder()
                .nguoiDungId(nd.getId())
                .hoTen(nd.getHoTen())
                .soDienThoai(nd.getSoDienThoai())
                .anhDaiDien(nd.getAnhDaiDien())
                .vaiTro(vaiTro)
                .build();
    }
}
