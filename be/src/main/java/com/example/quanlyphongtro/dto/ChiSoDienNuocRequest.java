package com.example.quanlyphongtro.dto;

import com.example.quanlyphongtro.entity.LoaiChiSo;
import com.example.quanlyphongtro.entity.TrangThaiChiSo;
import lombok.Data;

import java.time.LocalDate;
import java.util.UUID;

@Data
public class ChiSoDienNuocRequest {
    private UUID phongId;
    private UUID hopDongId;
    private LoaiChiSo loai;
    private Integer kyNam;
    private Integer kyThang;
    private LocalDate ngayGhi;
    private Integer chiSoCu;
    private Integer chiSoMoi;
    private String anhDongHo;
    private UUID nguoiGhiId;
    private TrangThaiChiSo trangThai;
    private String ghiChu;
}
