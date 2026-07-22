package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class DangKyPushRequest {

    /** WEB | ANDROID | IOS */
    @NotBlank(message = "Thieu nenTang")
    private String nenTang;

    /** Web Push: endpoint URL. FCM: registration token. */
    @NotBlank(message = "Thieu endpoint")
    private String endpoint;

    /** Chi Web Push can hai khoa nay (RFC 8291). */
    private String khoaP256dh;
    private String khoaAuth;

    private String moTaThietBi;
}
