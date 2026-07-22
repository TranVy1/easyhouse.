package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class DanhDauDaDocRequest {

    /** Da doc den tin co so thu tu nay. Chi tang, khong bao gio lui. */
    @NotNull(message = "Thieu denSeq")
    private Long denSeq;
}
