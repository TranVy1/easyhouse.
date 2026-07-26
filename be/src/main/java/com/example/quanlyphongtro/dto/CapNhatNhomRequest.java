package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class CapNhatNhomRequest {

    @Size(max = 120, message = "Ten nhom toi da 120 ky tu")
    private String ten;

    private String anh;

    /** ACTIVE | ARCHIVED | LOCKED. Bo trong thi giu nguyen. */
    private String trangThai;
}
