package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class DatBietDanhRequest {

    /** De trong hoac null = xoa biet danh, quay ve dung ho ten goc. */
    @Size(max = 60, message = "Biet danh toi da 60 ky tu")
    private String bietDanh;
}
