package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.UUID;

@Data
public class TaoHoiThoaiTrucTiepRequest {

    /** Nguoi muon nhan tin cung. Phai cung pham vi nha tro voi nguoi goi. */
    @NotNull(message = "Thieu nguoiDungId")
    private UUID nguoiDungId;
}
