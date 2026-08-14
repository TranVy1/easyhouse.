package com.example.quanlyphongtro.dto;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class TaoQuyetToanTraPhongRequest {
    private LocalDate ngayTraPhong;
    private Integer chiSoDienBanDau;
    private Integer chiSoDienCuoiKy;
    private Integer chiSoNuocBanDau;
    private Integer chiSoNuocCuoiKy;
    private List<KhoanKhauTruCocRequest> khoanKhauTru;
    private String ghiChu;
}
