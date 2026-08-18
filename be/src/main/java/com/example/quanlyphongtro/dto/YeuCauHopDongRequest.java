package com.example.quanlyphongtro.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;

/** Khach thue gui yeu cau huy hoac gia han hop dong. */
@Data
public class YeuCauHopDongRequest {

    /** HUY hoac GIA_HAN. */
    @NotNull(message = "Vui lòng chọn loại yêu cầu")
    private String loai;

    private String lyDo;

    /** HUY: ngay mong muon tra phong. GIA_HAN: co the bo trong, tinh tu soThangGiaHan. */
    private LocalDate ngayMongMuon;

    /** Chi dung cho GIA_HAN. */
    private Integer soThangGiaHan;
}
