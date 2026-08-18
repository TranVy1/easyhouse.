package com.example.quanlyphongtro.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Admin duyet hoac tu choi mot yeu cau huy / gia han.
 *
 * Khi duyet GIA_HAN, admin duoc phep dieu chinh lai so thang va gia thue moi so
 * voi de xuat cua khach — de trong thi lay theo yeu cau goc.
 */
@Data
public class DuyetYeuCauHopDongRequest {

    private String ghiChuDuyet;

    // --- Chi dung khi duyet GIA_HAN ---
    private Integer soThangGiaHan;
    private LocalDate ngayKetThucMoi;
    private BigDecimal giaThueMoi;
}
