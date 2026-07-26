package com.example.quanlyphongtro.dto;

import lombok.Builder;
import lombok.Data;

import java.time.ZonedDateTime;
import java.util.UUID;

/** Mot lien ket duoc chia se trong hoi thoai. */
@Data
@Builder
public class LienKetChatResponse {

    private String url;

    /** Tin nhan chua lien ket nay — de nguoi dung nhay toi ngu canh goc. */
    private UUID tinNhanId;
    private Long soThuTu;

    private String tenNguoiGui;
    private ZonedDateTime ngayGui;
}
