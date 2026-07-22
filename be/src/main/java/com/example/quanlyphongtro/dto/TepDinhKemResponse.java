package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.FileMedia;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

/**
 * Ket qua tai tep len cho chat.
 *
 * Client nhan {@code _id} roi gui kem trong body tin nhan (truong fileMediaId).
 * Tach lam hai buoc nhu vay de nguoi dung thay ngay anh xem truoc trong khi con
 * dang go noi dung.
 */
@Data
@Builder
public class TepDinhKemResponse {

    @JsonProperty("_id")
    private UUID id;

    private String url;

    /** TEXT/IMAGE/FILE — server tu suy tu content-type, client dung lam truong `loai`. */
    private String loaiTinNhan;

    private String tenTep;
    private Long kichThuocBytes;

    public static TepDinhKemResponse fromEntity(FileMedia file, String loaiTinNhan, String tenTep) {
        return TepDinhKemResponse.builder()
                .id(file.getId())
                .url(file.getUrl())
                .loaiTinNhan(loaiTinNhan)
                .tenTep(tenTep)
                .kichThuocBytes(file.getKichThuocBytes())
                .build();
    }
}
