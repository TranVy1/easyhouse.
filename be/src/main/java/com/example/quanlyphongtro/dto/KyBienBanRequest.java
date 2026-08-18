package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/** Ky bien ban ban giao khi tra phong. */
@Data
public class KyBienBanRequest {

    /** BEN_A = chu tro (ben nhan ban giao), BEN_B = khach thue (ben ban giao). */
    @NotBlank(message = "Thiếu vai trò ký")
    private String vaiTro;

    /** Anh chu ky dang data URL hoac base64 thuan. */
    @NotBlank(message = "Thiếu chữ ký")
    private String chuKyBase64;
}
