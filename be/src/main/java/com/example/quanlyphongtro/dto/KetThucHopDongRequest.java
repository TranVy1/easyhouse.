package com.example.quanlyphongtro.dto;

import lombok.Data;
import java.time.LocalDate;

@Data
public class KetThucHopDongRequest {
    private LocalDate ngayKetThucThucTe;
    private String trangThaiCoc;
    private String ghiChu;
    
    private Integer chiSoDienCuoiKy;
    private Integer chiSoNuocCuoiKy;
    private java.math.BigDecimal soTienKhauTru;
    private java.math.BigDecimal soTienHoanTra;
}
