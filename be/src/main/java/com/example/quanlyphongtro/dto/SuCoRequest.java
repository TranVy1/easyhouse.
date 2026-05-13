package com.example.quanlyphongtro.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.util.UUID;

@Data
public class SuCoRequest {
    private UUID phongId;
    private UUID khachThueId;
    private String tieuDe;
    private String moTa;
    private String loaiSuCo; // dien_nuoc, noi_that, ve_sinh, an_ninh, khac
    private String uuTien; // thap, trung_binh, cao, khan_cap
    private String trangThai; // PENDING, IN_PROGRESS, RESOLVED, CANCELLED (chỉ dùng khi update)
    private String ghiChuChuNha;
    private BigDecimal chiPhiSuaChua;
    private UUID nguoiPhuTrach;
}
