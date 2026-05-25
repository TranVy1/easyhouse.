package com.example.quanlyphongtro.dto;

import lombok.Data;
import java.time.LocalDate;

@Data
public class KetThucHopDongRequest {
    private LocalDate ngayKetThucThucTe;
    private String trangThaiCoc;
    private String ghiChu;
}
